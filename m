Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003AC40F70E
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344064AbhIQMFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 08:05:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344032AbhIQMFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 08:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631880221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tKks65Juqy4+m8tLOHbe5AVSRWKRBMmdkZx8Ybbbbdk=;
        b=VKkkM2C+4RnEv7QllBFGgmHlR2ddRkd8F1yjSEibsmgcXQheMyWj3mZ4YGku3BrL8bEeOU
        J+QEYWABdH3MVfPzulFYOuCGd3cuHA+2d4XR2UyXGUp1xYWkjibzUklXg50yQ9hGInad5j
        S2zCmWhkkMfHoQL846UV8nG1sOgDGqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-jCpZ-llmN92IeTFu1_p35w-1; Fri, 17 Sep 2021 08:03:40 -0400
X-MC-Unique: jCpZ-llmN92IeTFu1_p35w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9453D814314;
        Fri, 17 Sep 2021 12:03:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86BB4100164A;
        Fri, 17 Sep 2021 12:03:37 +0000 (UTC)
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
Subject: [PATCH v2 4/4] nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU races
Date:   Fri, 17 Sep 2021 08:03:29 -0400
Message-Id: <20210917120329.2013766-5-eesposit@redhat.com>
In-Reply-To: <20210917120329.2013766-1-eesposit@redhat.com>
References: <20210917120329.2013766-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the already checked svm->nested.save cached fields
(EFER, CR0, CR4, ...) instead of vmcb12's in
nested_vmcb02_prepare_save().
This prevents from creating TOC/TOU races, since the
guest could modify the vmcb12 fields.

This also avoids the need of force-setting EFER_SVME in
nested_vmcb02_prepare_save.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7e4cd134946f..9b2c4895d5d9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -280,13 +280,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
 				    struct vmcb_save_area_cached *save)
 {
-	/*
-	 * FIXME: these should be done after copying the fields,
-	 * to avoid TOC/TOU races.  For these save area checks
-	 * the possible damage is limited since kvm_set_cr0 and
-	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
-	 * so it is force-set later in nested_prepare_vmcb_save.
-	 */
 	if (CC(!(save->efer & EFER_SVME)))
 		return false;
 
@@ -488,15 +481,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
-	/*
-	 * Force-set EFER_SVME even though it is checked earlier on the
-	 * VMCB12, because the guest can flip the bit between the check
-	 * and now.  Clearing EFER_SVME would call svm_free_nested.
-	 */
-	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
+	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
 
-	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
-	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
+	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
+	svm_set_cr4(&svm->vcpu, svm->nested.save.cr4);
 
 	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
 
@@ -511,8 +499,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 
 	/* These bits will be set properly on the first execution when new_vmc12 is true */
 	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
-		svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
-		svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
+		svm->vmcb->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
+		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
 		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 	}
 }
@@ -621,7 +609,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_vmcb02_prepare_control(svm);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
-	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
+	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
 				  nested_npt_enabled(svm), true);
 	if (ret)
 		return ret;
-- 
2.27.0

