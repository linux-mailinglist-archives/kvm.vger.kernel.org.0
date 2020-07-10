Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA14221B7F2
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgGJOMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 10:12:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727861AbgGJOMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 10:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594390334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6FchqiKTNfD7SANtadf7uzNNvcrA+BUGouO31rgAiwk=;
        b=Vncxc1NGR/+MNP4OpGIPhth8h2rd1rHQQuYe80KgzMAQFkZPiC/uh65raRI5kjHE+Fffyz
        2sBlRovRxpOPD9M2g5OxGY2f3WKRSdK0Zr02n6/UCPOxISSAmkWCR98P1VZRDpjdj+AIa6
        Yk8jxligg+8NyY0l8DxXMGNEalyppH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-CkkStAsCMsGbe_E3vSa7vg-1; Fri, 10 Jul 2020 10:12:13 -0400
X-MC-Unique: CkkStAsCMsGbe_E3vSa7vg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADEE38015F7;
        Fri, 10 Jul 2020 14:12:11 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80D5B1CA;
        Fri, 10 Jul 2020 14:12:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/9] KVM: nSVM: prepare to handle errors from enter_svm_guest_mode()
Date:   Fri, 10 Jul 2020 16:11:52 +0200
Message-Id: <20200710141157.1640173-5-vkuznets@redhat.com>
In-Reply-To: <20200710141157.1640173-1-vkuznets@redhat.com>
References: <20200710141157.1640173-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some operations in enter_svm_guest_mode() may fail, e.g. currently
we suppress kvm_set_cr3() return value. Prepare the code to proparate
errors.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 26 ++++++++++++++++----------
 arch/x86/kvm/svm/svm.c    |  6 ++++--
 arch/x86/kvm/svm/svm.h    |  4 ++--
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 1cc8592b1820..5e6c988a4e6b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -379,7 +379,7 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	mark_all_dirty(svm->vmcb);
 }
 
-void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
+int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			  struct vmcb *nested_vmcb)
 {
 	svm->nested.vmcb = vmcb_gpa;
@@ -388,6 +388,8 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	nested_prepare_vmcb_control(svm);
 
 	svm_set_gif(svm, true);
+
+	return 0;
 }
 
 int nested_svm_vmrun(struct vcpu_svm *svm)
@@ -465,18 +467,22 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	copy_vmcb_control_area(&hsave->control, &vmcb->control);
 
 	svm->nested.nested_run_pending = 1;
-	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 
-	if (!nested_svm_vmrun_msrpm(svm)) {
-		svm->nested.nested_run_pending = 0;
+	if (enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb))
+		goto out_exit_err;
 
-		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
-		svm->vmcb->control.exit_code_hi = 0;
-		svm->vmcb->control.exit_info_1  = 0;
-		svm->vmcb->control.exit_info_2  = 0;
+	if (nested_svm_vmrun_msrpm(svm))
+		goto out;
 
-		nested_svm_vmexit(svm);
-	}
+out_exit_err:
+	svm->nested.nested_run_pending = 0;
+
+	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1  = 0;
+	svm->vmcb->control.exit_info_2  = 0;
+
+	nested_svm_vmexit(svm);
 
 out:
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..b8ec56fe5478 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,6 +3843,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct kvm_host_map map;
 	u64 guest;
 	u64 vmcb;
+	int ret = 0;
 
 	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
 	vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
@@ -3851,10 +3852,11 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
 			return 1;
 		nested_vmcb = map.hva;
-		enter_svm_guest_mode(svm, vmcb, nested_vmcb);
+		ret = enter_svm_guest_mode(svm, vmcb, nested_vmcb);
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 	}
-	return 0;
+
+	return ret;
 }
 
 static void enable_smi_window(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6ac4c00a5d82..f98649af11d1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -387,8 +387,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return (svm->nested.ctl.intercept & (1ULL << INTERCEPT_NMI));
 }
 
-void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb);
+int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
+			 struct vmcb *nested_vmcb);
 void svm_leave_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
-- 
2.25.4

