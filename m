Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2567640F711
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344104AbhIQMFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344085AbhIQMFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NXqnDnKXSmxK7Xb9jbVIcy+QPn0LnNcsYEId2et3Sto=;
        b=bAnjusNubMJbIC5LezdEF3wb3K/SZ5tVIRLcc5epBkdBhbNd0GPy/7TiOtnxdQ/RfpwO88
        L/madm0sPfgVSp036G2/fnbHykXRUdn2E5bdnOaFizLXOzZ27bE5BEFGtM40zCMuJmVbOF
        e7g/1V+IFIdxnkWebtrT43zN2oxHQFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-SYVfWYWCO2WPD0t-f9Ta9A-1; Fri, 17 Sep 2021 08:03:38 -0400
X-MC-Unique: SYVfWYWCO2WPD0t-f9Ta9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44537802C89;
        Fri, 17 Sep 2021 12:03:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24E95100164A;
        Fri, 17 Sep 2021 12:03:35 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [PATCH v2 2/4] nSVM: introduce smv->nested.save to cache save area fields
Date:   Fri, 17 Sep 2021 08:03:27 -0400
Message-Id: <20210917120329.2013766-3-eesposit@redhat.com>
In-Reply-To: <20210917120329.2013766-1-eesposit@redhat.com>
References: <20210917120329.2013766-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is useful in next patch, to avoid having temporary
copies of vmcb12 registers and passing them manually.

Right now, instead of blindly copying everything,
we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
will need to be added, it will be more obvious to see
that they must be added in struct vmcb_save_area_cached and
in copy_vmcb_save_area().

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    | 12 ++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d2fe65e2a7a4..fcbb66915403 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -194,6 +194,22 @@ static void copy_vmcb_control_area(struct vmcb_control_area *dst,
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
 }
 
+static void copy_vmcb_save_area(struct vmcb_save_area_cached *dst,
+				struct vmcb_save_area *from)
+{
+	/*
+	 * Copy only necessary fields, as we need them
+	 * to avoid TOC/TOU races.
+	 */
+	dst->efer = from->efer;
+	dst->cr0 = from->cr0;
+	dst->cr3 = from->cr3;
+	dst->cr4 = from->cr4;
+
+	dst->dr6 = from->dr6;
+	dst->dr7 = from->dr7;
+}
+
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
 	/*
@@ -313,6 +329,12 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
 
+void nested_load_save_from_vmcb12(struct vcpu_svm *svm,
+				  struct vmcb_save_area *save)
+{
+	copy_vmcb_save_area(&svm->nested.save, save);
+}
+
 /*
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
@@ -647,6 +669,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_load_save_from_vmcb12(svm, &vmcb12->save);
 
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
@@ -1385,6 +1408,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_load_control_from_vmcb12(svm, ctl);
+	nested_load_save_from_vmcb12(svm, save);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 69639f9624f5..169b930322ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4386,6 +4386,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 			vmcb12 = map.hva;
 
 			nested_load_control_from_vmcb12(svm, &vmcb12->control);
+			nested_load_save_from_vmcb12(svm, &vmcb12->save);
 
 			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
 			kvm_vcpu_unmap(vcpu, &map, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd0fe94c2920..9982e6136724 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -103,6 +103,15 @@ struct kvm_vmcb_info {
 	uint64_t asid_generation;
 };
 
+struct vmcb_save_area_cached {
+	u64 efer;
+	u64 cr4;
+	u64 cr3;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+};
+
 struct svm_nested_state {
 	struct kvm_vmcb_info vmcb02;
 	u64 hsave_msr;
@@ -119,6 +128,7 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+	struct vmcb_save_area_cached save;
 
 	bool initialized;
 };
@@ -484,6 +494,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
+void nested_load_save_from_vmcb12(struct vcpu_svm *svm,
+				  struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
-- 
2.27.0

