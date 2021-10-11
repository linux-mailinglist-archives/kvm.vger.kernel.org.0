Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C4A429211
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbhJKOjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 10:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240109AbhJKOjO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 10:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633963034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBIhqbEQFgwyPopnLPcFT4lWN21gi3x6lgr636XaT0c=;
        b=TFLd0dxUwQqvcRYYfMNDCqLrIQ3jfJlNBXNfKhAUTLMQHjCjTmC0Ls5E+Xdxu4cFwDeu4+
        FJ0FUQIVl2CldflLAEteHZOV7Am3wx2uV/j1Xrc7aATblqAXqifFkoPwYTVn7ObjdirK6s
        jKIw15L/99tK9YlxhPfsuh8guWVNpp4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-dtGNdUMQPk20tjMD2QnrLg-1; Mon, 11 Oct 2021 10:37:10 -0400
X-MC-Unique: dtGNdUMQPk20tjMD2QnrLg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B84DBD526;
        Mon, 11 Oct 2021 14:37:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 086A619C59;
        Mon, 11 Oct 2021 14:37:07 +0000 (UTC)
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
Subject: [PATCH v3 2/8] nSVM: introduce smv->nested.save to cache save area fields
Date:   Mon, 11 Oct 2021 10:36:56 -0400
Message-Id: <20211011143702.1786568-3-eesposit@redhat.com>
In-Reply-To: <20211011143702.1786568-1-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is useful in next patch, to avoid having temporary
copies of vmcb12 registers and passing them manually.

Right now, instead of blindly copying everything,
we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
will need to be added, it will be more obvious to see
that they must be added in struct vmcb_save_area_cached and
in nested_copy_vmcb_save_to_cache().

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 18 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    | 16 ++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d2fe65e2a7a4..c4959da8aec0 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -313,6 +313,22 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
 
+void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
+				    struct vmcb_save_area *save)
+{
+	/*
+	 * Copy only fields that are validated, as we need them
+	 * to avoid TOC/TOU races.
+	 */
+	svm->nested.save.efer = save->efer;
+	svm->nested.save.cr0 = save->cr0;
+	svm->nested.save.cr3 = save->cr3;
+	svm->nested.save.cr4 = save->cr4;
+
+	svm->nested.save.dr6 = save->dr6;
+	svm->nested.save.dr7 = save->dr7;
+}
+
 /*
  * Synchronize fields that are written by the processor, so that
  * they can be copied back into the vmcb12.
@@ -647,6 +663,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
 	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
@@ -1385,6 +1402,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
 	nested_load_control_from_vmcb12(svm, ctl);
+	nested_copy_vmcb_save_to_cache(svm, save);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
 	nested_vmcb02_prepare_control(svm);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 69639f9624f5..bf171f5f6158 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4386,6 +4386,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 			vmcb12 = map.hva;
 
 			nested_load_control_from_vmcb12(svm, &vmcb12->control);
+			nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
 			kvm_vcpu_unmap(vcpu, &map, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd0fe94c2920..f0195bc263e9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -103,6 +103,19 @@ struct kvm_vmcb_info {
 	uint64_t asid_generation;
 };
 
+/*
+ * This struct is not kept up-to-date, and it is only valid within
+ * svm_set_nested_state and nested_svm_vmrun.
+ */
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
@@ -119,6 +132,7 @@ struct svm_nested_state {
 
 	/* cache for control fields of the guest */
 	struct vmcb_control_area ctl;
+	struct vmcb_save_area_cached save;
 
 	bool initialized;
 };
@@ -484,6 +498,8 @@ int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 int nested_svm_exit_special(struct vcpu_svm *svm);
 void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
 				     struct vmcb_control_area *control);
+void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
+				  struct vmcb_save_area *save);
 void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
-- 
2.27.0

