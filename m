Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC13CB8F2
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 16:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhGPOoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 10:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240524AbhGPOoG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 10:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626446470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8ps4gOzEkG1hG/qJ2VWdaMcAGr+nQ0tVSLRPGFZQGhs=;
        b=e0/FPRVNKDsEJc3SxRNmHYapZAOUt93K8vyuvJUHN7CUc9eGuZ06ytbLBvZvK8eUT8n/m4
        635KFqylncZ4uF4NedlRZVfAMOjX1mK3jA85RxUzMsIJq5a4OFhk+lQ1wydnufcl7KBSoJ
        CyoJT6bSq9MlGptlD82VoMmfN0tS1FY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272--9tmXt4lPDCHNpqMOS73ZA-1; Fri, 16 Jul 2021 10:41:09 -0400
X-MC-Unique: -9tmXt4lPDCHNpqMOS73ZA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35D47192FDA0;
        Fri, 16 Jul 2021 14:41:08 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFFF01062246;
        Fri, 16 Jul 2021 14:41:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: nSVM: Rename nested_svm_vmloadsave() to svm_copy_vmloadsave_state()
Date:   Fri, 16 Jul 2021 16:41:04 +0200
Message-Id: <20210716144104.465269-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To match svm_copy_vmrun_state(), rename nested_svm_vmloadsave() to
svm_copy_vmloadsave_state().

Opportunistically add missing braces to 'else' branch in
vmload_vmsave_interception().

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 arch/x86/kvm/svm/svm.c    | 7 ++++---
 arch/x86/kvm/svm/svm.h    | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3bd09c50c98b..8493592b63b4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -722,7 +722,7 @@ void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
 	to_save->cpl = 0;
 }
 
-void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+void svm_copy_vmloadsave_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
 {
 	to_vmcb->save.fs = from_vmcb->save.fs;
 	to_vmcb->save.gs = from_vmcb->save.gs;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 664d20f0689c..cfe165d74093 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2147,11 +2147,12 @@ static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 	ret = kvm_skip_emulated_instruction(vcpu);
 
 	if (vmload) {
-		nested_svm_vmloadsave(vmcb12, svm->vmcb);
+		svm_copy_vmloadsave_state(vmcb12, svm->vmcb);
 		svm->sysenter_eip_hi = 0;
 		svm->sysenter_esp_hi = 0;
-	} else
-		nested_svm_vmloadsave(svm->vmcb, vmcb12);
+	} else {
+		svm_copy_vmloadsave_state(svm->vmcb, vmcb12);
+	}
 
 	kvm_vcpu_unmap(vcpu, &map, true);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7e2090752d8f..1b65ee3a9569 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -466,7 +466,7 @@ int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct kvm_vcpu *vcpu);
 void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
 			  struct vmcb_save_area *to_save);
-void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
+void svm_copy_vmloadsave_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
 int nested_svm_vmexit(struct vcpu_svm *svm);
 
 static inline int nested_svm_simple_vmexit(struct vcpu_svm *svm, u32 exit_code)
-- 
2.31.1

