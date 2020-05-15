Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698501D5834
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgEORlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:41:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38166 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEORlw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=obvdaqrDmOo0TZ7H8EUPrGh8lXy9dD8Hldwr4knbgD0=;
        b=ShnRSmvLeXh64VW5XDoTeIZrrEQvJBzCj6wLSV9bHNcPjRcExZU1L4rjJsxIwG9DaoRf6r
        vQPTmHhjLMt9+p/De0qPpJc5siJXaP/s0/FwWJMjEyNN4MJ1xDCCgI09v7DcnZubedvYiv
        Hu05w7YH2tTrT3Dsyb4a9b5qZLR5sSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-FwbIl2CVOiiBBWetwE2nzw-1; Fri, 15 May 2020 13:41:48 -0400
X-MC-Unique: FwbIl2CVOiiBBWetwE2nzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43DEA83DE2B;
        Fri, 15 May 2020 17:41:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 979C210002CD;
        Fri, 15 May 2020 17:41:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 1/7] KVM: SVM: move map argument out of enter_svm_guest_mode
Date:   Fri, 15 May 2020 13:41:38 -0400
Message-Id: <20200515174144.1727-2-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
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
index a89a166d1cb8..22f75f66084f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -226,7 +226,7 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb, struct kvm_host_map *map)
+			  struct vmcb *nested_vmcb)
 {
 	bool evaluate_pending_interrupts =
 		is_intercept(svm, INTERCEPT_VINTR) ||
@@ -305,8 +305,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->control.pause_filter_thresh =
 		nested_vmcb->control.pause_filter_thresh;
 
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
-
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
 
@@ -369,10 +367,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
@@ -415,7 +410,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	copy_vmcb_control_area(hsave, vmcb);
 
 	svm->nested.nested_run_pending = 1;
-	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
+	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
@@ -426,6 +421,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_vmexit(svm);
 	}
 
+out:
+	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e9cd2a73ad0..dc12a03d16f6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3843,7 +3843,8 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
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
index 5cc559ab862d..730eb7242930 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -397,7 +397,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 }
 
 void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
-			  struct vmcb *nested_vmcb, struct kvm_host_map *map);
+			  struct vmcb *nested_vmcb);
 int nested_svm_vmrun(struct vcpu_svm *svm);
 void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
-- 
2.18.2


