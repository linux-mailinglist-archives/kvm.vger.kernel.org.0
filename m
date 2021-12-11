Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E842470F49
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 01:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbhLKAPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 19:15:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345312AbhLKAPl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 19:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639181525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TCfiwijmHPHIc3kkqrixLwmjXk/TcaGMQGB9RrBMHuM=;
        b=DtLTacuhP5JVrKnTNxXeqPRMe/340Gt7vZbFSg+KMpWCTcol6vZyIvQHq3djY+PcvAUx2R
        tlzJivuUoBRFF/7g77B5M80jKkQBsL53Zv041bVJm4p1wAn1JDsxnHLj13MJy4UEihmMWX
        bz3XYk3zMDx2wK57Ax7+m6MhZyLTUvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-pptP4O6rN_akHlfsM_qniw-1; Fri, 10 Dec 2021 19:12:00 -0500
X-MC-Unique: pptP4O6rN_akHlfsM_qniw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2703D80BCA8;
        Sat, 11 Dec 2021 00:11:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81D187AB43;
        Sat, 11 Dec 2021 00:11:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     laijs@linux.alibaba.com, David Matlack <dmatlack@google.com>
Subject: [PATCH] Revert "KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()"
Date:   Fri, 10 Dec 2021 19:11:56 -0500
Message-Id: <20211211001157.74709-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit 15ad9762d69fd8e40a4a51828c1d6b0c1b8fbea0.

David Matlack reports:

"While testing some patches I ran into a VM_BUG_ON that I have been able to
reproduce at kvm/queue commit 45af1bb99b72 ("KVM: VMX: Clean up PI
pre/post-block WARNs").

To repro run the kvm-unit-tests on a kernel built from kvm/queue with
CONFIG_DEBUG_VM=y. I was testing on an Intel Cascade Lake host and have not
tested in any other environments yet. The repro is not 100% reliable, although
it's fairly easy to trigger and always during a vmx* kvm-unit-tests

Given the details of the crash, commit 15ad9762d69f ("KVM: VMX: Save HOST_CR3
in vmx_prepare_switch_to_guest()") and surrounding commits look most suspect."

Reported-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Not tested yet.  I did reproduce the WARN with debug kernels though.
---
 arch/x86/kvm/vmx/nested.c |  8 +++++++-
 arch/x86/kvm/vmx/vmx.c    | 17 +++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2f6f465e575f..26b236187850 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3054,7 +3054,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr4;
+	unsigned long cr3, cr4;
 	bool vm_fail;
 
 	if (!nested_early_check)
@@ -3077,6 +3077,12 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 	 */
 	vmcs_writel(GUEST_RFLAGS, 0);
 
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 640f4719612c..7826556b2a47 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1103,7 +1103,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #ifdef CONFIG_X86_64
 	int cpu = raw_smp_processor_id();
 #endif
-	unsigned long cr3;
 	unsigned long fs_base, gs_base;
 	u16 fs_sel, gs_sel;
 	int i;
@@ -1168,14 +1167,6 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
-
-	/* Host CR3 including its PCID is stable when guest state is loaded. */
-	cr3 = __get_current_cr3_fast();
-	if (unlikely(cr3 != host_state->cr3)) {
-		vmcs_writel(HOST_CR3, cr3);
-		host_state->cr3 = cr3;
-	}
-
 	vmx->guest_state_loaded = true;
 }
 
@@ -6638,7 +6629,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long cr4;
+	unsigned long cr3, cr4;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -6683,6 +6674,12 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 	vcpu->arch.regs_dirty = 0;
 
+	cr3 = __get_current_cr3_fast();
+	if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
+		vmcs_writel(HOST_CR3, cr3);
+		vmx->loaded_vmcs->host_state.cr3 = cr3;
+	}
+
 	cr4 = cr4_read_shadow();
 	if (unlikely(cr4 != vmx->loaded_vmcs->host_state.cr4)) {
 		vmcs_writel(HOST_CR4, cr4);
-- 
2.31.1

