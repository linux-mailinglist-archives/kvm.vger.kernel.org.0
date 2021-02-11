Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDFE31951F
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 22:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBKVZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 16:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhBKVZX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 16:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613078637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RERqyVecoC0CfcYPF9w5jxKANHKVv67OPd/lj0yaULM=;
        b=f4hFKL0en1bw4guiA7x4LfBNisHdIdkLq/a+dBKaEhT4PaThToqYlmUE1DykAcjHPVMCRG
        ErrS6psQfda/KH/DFgqPUPT0Oextefq0C6RAvevax/DYiCN2A+O+mzb74AS72xSuOlbL6u
        h6copPTLLoLByX2vq+bIBDWlYMKtPE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-dE1L1Y-LP8KpG3kVWW2v7w-1; Thu, 11 Feb 2021 16:23:55 -0500
X-MC-Unique: dE1L1Y-LP8KpG3kVWW2v7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26119192FDAB;
        Thu, 11 Feb 2021 21:23:53 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9F7660BF1;
        Thu, 11 Feb 2021 21:23:52 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, wei.huang2@amd.com,
        babu.moger@amd.com
Subject: [PATCH 2/3] KVM: SVM: Handle invpcid during gp interception
Date:   Thu, 11 Feb 2021 16:22:38 -0500
Message-Id: <20210211212241.3958897-3-bsd@redhat.com>
In-Reply-To: <20210211212241.3958897-1-bsd@redhat.com>
References: <20210211212241.3958897-1-bsd@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the gp interception path to inject a #UD
to the guest if the guest has invpcid disabled.
This is required because for CPL > 0, #GP takes
precedence over the INVPCID intercept.

Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 754e07538b4a..0e8ce7adb815 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2170,6 +2170,7 @@ enum {
 	SVM_INSTR_VMRUN,
 	SVM_INSTR_VMLOAD,
 	SVM_INSTR_VMSAVE,
+	SVM_INSTR_INVPCID,
 };
 
 /* Return NONE_SVM_INSTR if not SVM instrs, otherwise return decode result */
@@ -2177,6 +2178,8 @@ static int svm_instr_opcode(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
 
+	if (ctxt->b == 0x82)
+		return SVM_INSTR_INVPCID;
 	if (ctxt->b != 0x1 || ctxt->opcode_len != 2)
 		return NONE_SVM_INSTR;
 
@@ -2200,11 +2203,13 @@ static int emulate_svm_instr(struct kvm_vcpu *vcpu, int opcode)
 		[SVM_INSTR_VMRUN] = SVM_EXIT_VMRUN,
 		[SVM_INSTR_VMLOAD] = SVM_EXIT_VMLOAD,
 		[SVM_INSTR_VMSAVE] = SVM_EXIT_VMSAVE,
+		[SVM_INSTR_INVPCID] = SVM_EXIT_EXCP_BASE + UD_VECTOR,
 	};
 	int (*const svm_instr_handlers[])(struct kvm_vcpu *vcpu) = {
 		[SVM_INSTR_VMRUN] = vmrun_interception,
 		[SVM_INSTR_VMLOAD] = vmload_interception,
 		[SVM_INSTR_VMSAVE] = vmsave_interception,
+		[SVM_INSTR_INVPCID] = ud_interception,
 	};
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -2253,8 +2258,12 @@ static int gp_interception(struct kvm_vcpu *vcpu)
 		if (!is_guest_mode(vcpu))
 			return kvm_emulate_instruction(vcpu,
 				EMULTYPE_VMWARE_GP | EMULTYPE_NO_DECODE);
-	} else
+	} else {
+		if ((opcode == SVM_INSTR_INVPCID) &&
+		    guest_cpuid_has(vcpu, X86_FEATURE_INVPCID))
+			goto reinject;
 		return emulate_svm_instr(vcpu, opcode);
+	}
 
 reinject:
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
-- 
2.24.1

