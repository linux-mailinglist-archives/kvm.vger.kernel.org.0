Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98832B5B0
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382706AbhCCHTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835989AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbNGRdTXkPZFsZjV1m+HGFabl3ek1eVaUxTXNq0F0fg=;
        b=BXFtbzxHTsU/m4OXr0rqUVOewPrP2uCchswPEjsguTGrJ+S6IJxFFQ/FBgcUu0JAylIT5T
        SjtYJYowA4n6tR3vtbKRvnB7Tuocdq36D+1shDh8K84jaJLxKmMiutEucEtH2tliinKNML
        OZLdNqRsexVWtaQB7S5txRo4V57Ue5M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-56sP-4MvMbKnPzSPsIF8IA-1; Tue, 02 Mar 2021 14:33:53 -0500
X-MC-Unique: 56sP-4MvMbKnPzSPsIF8IA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 937A4801977;
        Tue,  2 Mar 2021 19:33:52 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DCD260CC5;
        Tue,  2 Mar 2021 19:33:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 14/23] KVM: nSVM: Add VMLOAD/VMSAVE helper to deduplicate code
Date:   Tue,  2 Mar 2021 14:33:34 -0500
Message-Id: <20210302193343.313318-15-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add another helper layer for VMLOAD+VMSAVE, the code is identical except
for the one line that determines which VMCB is the source and which is
the destination.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210205005750.3841462-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c2626babe575..5815fedf978e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2116,7 +2116,7 @@ static int vmmcall_interception(struct kvm_vcpu *vcpu)
 	return kvm_emulate_hypercall(vcpu);
 }
 
-static int vmload_interception(struct kvm_vcpu *vcpu)
+static int vmload_vmsave_interception(struct kvm_vcpu *vcpu, bool vmload)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb12;
@@ -2137,37 +2137,24 @@ static int vmload_interception(struct kvm_vcpu *vcpu)
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
-	nested_svm_vmloadsave(vmcb12, svm->vmcb);
+	if (vmload)
+		nested_svm_vmloadsave(vmcb12, svm->vmcb);
+	else
+		nested_svm_vmloadsave(svm->vmcb, vmcb12);
+
 	kvm_vcpu_unmap(vcpu, &map, true);
 
 	return ret;
 }
 
-static int vmsave_interception(struct kvm_vcpu *vcpu)
+static int vmload_interception(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-	struct vmcb *vmcb12;
-	struct kvm_host_map map;
-	int ret;
-
-	if (nested_svm_check_permissions(vcpu))
-		return 1;
-
-	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
-	if (ret) {
-		if (ret == -EINVAL)
-			kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
-
-	vmcb12 = map.hva;
-
-	ret = kvm_skip_emulated_instruction(vcpu);
-
-	nested_svm_vmloadsave(svm->vmcb, vmcb12);
-	kvm_vcpu_unmap(vcpu, &map, true);
+	return vmload_vmsave_interception(vcpu, true);
+}
 
-	return ret;
+static int vmsave_interception(struct kvm_vcpu *vcpu)
+{
+	return vmload_vmsave_interception(vcpu, false);
 }
 
 static int vmrun_interception(struct kvm_vcpu *vcpu)
-- 
2.26.2


