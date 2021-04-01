Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4A351E02
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbhDASdw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:33:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40539 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237382AbhDASXC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkC1sdkerI8F8vOf005GBPiJgNfEMNHeDOPdciRJ6BE=;
        b=a/AFQk1IE9f5h28Aw+pFPtYzrwvchV6djd2X/i3KrlOgPPF2GBJFf4vCioKGH/cjHrLhKf
        5R2ZMQRsDjm2GamSbqZupHXSR2QA+TZ/nrn0lXqTGG5to8gY6NxB9CYXbzA5zBj92+5cZd
        WVTo5Vq2g3MMJFNSC2O3dBxku+OMv/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-wC2CLdPINA-Ph_XASs6Mjw-1; Thu, 01 Apr 2021 10:19:05 -0400
X-MC-Unique: wC2CLdPINA-Ph_XASs6Mjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 516FA107AD64;
        Thu,  1 Apr 2021 14:18:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91E915945C;
        Thu,  1 Apr 2021 14:18:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/6] KVM: nSVM: call nested_svm_load_cr3 on nested state load
Date:   Thu,  1 Apr 2021 17:18:10 +0300
Message-Id: <20210401141814.1029036-3-mlevitsk@redhat.com>
In-Reply-To: <20210401141814.1029036-1-mlevitsk@redhat.com>
References: <20210401141814.1029036-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While KVM's MMU should be fully reset by loading of nested CR0/CR3/CR4
by KVM_SET_SREGS, we are not in nested mode yet when we do it and therefore
only root_mmu is reset.

On regular nested entries we call nested_svm_load_cr3 which both updates
the guest's CR3 in the MMU when it is needed, and it also initializes
the mmu again which makes it initialize the walk_mmu as well when nested
paging is enabled in both host and guest.

Since we don't call nested_svm_load_cr3 on nested state load,
the walk_mmu can be left uninitialized, which can lead to a NULL pointer
dereference while accessing it if we happen to get a nested page fault
right after entering the nested guest first time after the migration and
we decide to emulate it, which leads to the emulator trying to access
walk_mmu->gva_to_gpa which is NULL.

Therefore we should call this function on nested state load as well.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 40 +++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8523f60adb92..ac5e3e17bda4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -215,24 +215,6 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
-static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	if (WARN_ON(!is_guest_mode(vcpu)))
-		return true;
-
-	if (!nested_svm_vmrun_msrpm(svm)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
-			KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return false;
-	}
-
-	return true;
-}
-
 static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 {
 	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
@@ -1312,6 +1294,28 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (WARN_ON(!is_guest_mode(vcpu)))
+		return true;
+
+	if (nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				nested_npt_enabled(svm)))
+		return false;
+
+	if (!nested_svm_vmrun_msrpm(svm)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror =
+			KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		return false;
+	}
+
+	return true;
+}
+
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
 	.triple_fault = nested_svm_triple_fault,
-- 
2.26.2

