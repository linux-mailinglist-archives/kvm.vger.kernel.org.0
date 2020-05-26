Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAEA1E28C1
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389235AbgEZRZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:25:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31316 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388803AbgEZRXT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbtBU1MOelWIUuUVVYfK0gQzdSdxJbp6qK0Ut7yTAY8=;
        b=QyAOzwuPLedH/WWsnCqCY7st68vO/HUMNFokGACFoFno09YWLfaeI/Q+ksVzm6lWyezbTz
        ZBzlSSywgOc+5MD5mGDkwf8F+i3cNgfEIJ8Ue01quvedS1ImgXgW+Qz/C3hisRZJzdY0S5
        +wdLNzAD/+G4T4kg1NTIRqxfR3736wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-1CkpBpgGOAunrVF5A7XMYg-1; Tue, 26 May 2020 13:23:16 -0400
X-MC-Unique: 1CkpBpgGOAunrVF5A7XMYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A5F1464;
        Tue, 26 May 2020 17:23:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7652010013DB;
        Tue, 26 May 2020 17:23:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 08/28] KVM: nSVM: move map argument out of enter_svm_guest_mode
Date:   Tue, 26 May 2020 13:22:48 -0400
Message-Id: <20200526172308.111575-9-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unmapping the nested VMCB in enter_svm_guest_mode is a bit of a wart,
since the map is not used elsewhere in the function.  There are
just two calls, so move it there.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 14 ++++++--------
 arch/x86/kvm/svm/svm.c    |  3 ++-
 arch/x86/kvm/svm/svm.h    |  2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 81e0fbd5e267..d2fc3c4aa00b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -229,7 +229,7 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb, struct kvm_host_map *map)
+			  struct vmcb *nested_vmcb)
 {
 	bool evaluate_pending_interrupts =
 		is_intercept(svm, INTERCEPT_VINTR) ||
@@ -304,8 +304,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->control.pause_filter_thresh =
 		nested_vmcb->control.pause_filter_thresh;
 
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
-
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
 
@@ -368,10 +366,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_vmcb->control.exit_code_hi = 0;
 		nested_vmcb->control.exit_info_1  = 0;
 		nested_vmcb->control.exit_info_2  = 0;
-
-		kvm_vcpu_unmap(&svm->vcpu, &map, true);
-
-		return ret;
+		goto out;
 	}
 
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
@@ -414,7 +409,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	copy_vmcb_control_area(hsave, vmcb);
 
 	svm->nested.nested_run_pending = 1;
-	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
+	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
@@ -425,6 +420,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_vmexit(svm);
 	}
 
+out:
+	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index abe277a3216b..3321c402a753 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3814,7 +3814,8 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
 			return 1;
 		nested_vmcb = map.hva;
-		enter_svm_guest_mode(svm, vmcb, nested_vmcb, &map);
+		enter_svm_guest_mode(svm, vmcb, nested_vmcb);
+		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 89fab75dd4f5..33e3f09d7a8e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -395,7 +395,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb, struct kvm_host_map *map);
+			  struct vmcb *nested_vmcb);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.26.2


