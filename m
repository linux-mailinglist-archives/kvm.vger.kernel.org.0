Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CC31DBB59
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgETRYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:24:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26601 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727940AbgETRWB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 13:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Rs658D4BryPokbUe2jlTj8urayd8s1mPqmRjV+mKTDs=;
        b=VAD9UEg/iM6HxL43J6c+xnSLdJ1v+q9Ravz7jo+wmh6C4uCssf2/CUL749LAg7Rx5wcqnK
        Ip1BxB/CQYpVbjeafZdntepqEYUn347sx/9YyUDsB57AaNhKeAjUsZPgXMFayaBCRm5u2d
        MbLwMP85K0lA9frk2ZwBskhJpL7aQgM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-QInejBBJOQ-V2zZBfarM_g-1; Wed, 20 May 2020 13:21:58 -0400
X-MC-Unique: QInejBBJOQ-V2zZBfarM_g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9C20107B474;
        Wed, 20 May 2020 17:21:52 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E250682A33;
        Wed, 20 May 2020 17:21:51 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 06/24] KVM: nSVM: move map argument out of enter_svm_guest_mode
Date:   Wed, 20 May 2020 13:21:27 -0400
Message-Id: <20200520172145.23284-7-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 7efefceb5f2f..083f11d5e3fa 100644
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
@@ -308,8 +308,6 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm->vmcb->control.pause_filter_thresh =
 		nested_vmcb->control.pause_filter_thresh;
 
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
-
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
 
@@ -372,10 +370,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
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
@@ -418,7 +413,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	copy_vmcb_control_area(hsave, vmcb);
 
 	svm->nested.nested_run_pending = 1;
-	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb, &map);
+	enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
@@ -429,6 +424,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_vmexit(svm);
 	}
 
+out:
+	kvm_vcpu_unmap(&svm->vcpu, &map, true);
+
 	return ret;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 04332d0efa5f..47c565338426 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3820,7 +3820,8 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
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
2.18.2


