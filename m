Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858E6588FC4
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiHCPv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiHCPve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB8E24A81B
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PZmvPRv2wyPIO8oJ82T1OQSX+OhBky8ZRvxbccr9Q84=;
        b=M0RDArIv9/bTUUK5wjLEdZuysonNqBcbNgnHrPtR0MCWqL10AOjZglV18/7V3e6/4QvdAR
        4EzP/PKNB1yF1sQflS0F842merCdWwzLYrv5ZoYQ7lN1+ttpfix+S0NIZzHt6rNraiidnZ
        W8pfVbw8HCI76CEGRTS4kA+01QMQdik=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-5xbvyP-OODOtgpSK7vgQSA-1; Wed, 03 Aug 2022 11:51:03 -0400
X-MC-Unique: 5xbvyP-OODOtgpSK7vgQSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B93E2919EAC;
        Wed,  3 Aug 2022 15:51:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7F321121314;
        Wed,  3 Aug 2022 15:50:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 11/13] KVM: x86: SVM: use smram structs
Date:   Wed,  3 Aug 2022 18:50:09 +0300
Message-Id: <20220803155011.43721-12-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This removes the last user of put_smstate/GET_SMSTATE so
remove these functions as well.

Also add a sanity check that we don't attempt to enter the SMM
on non long mode capable guest CPU with a running nested guest.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ------
 arch/x86/kvm/svm/svm.c          | 21 ++++++---------------
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d752fabde94ad2..d570ec522ebb55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2077,12 +2077,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #endif
 }
 
-#define put_smstate(type, buf, offset, val)                      \
-	*(type *)((buf) + (offset) - 0x7e00) = val
-
-#define GET_SMSTATE(type, buf, offset)		\
-	(*(type *)((buf) + (offset) - 0x7e00))
-
 int kvm_cpu_dirty_log_size(void);
 
 int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 688315d1dfabd1..7ca5e06878e19a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4439,15 +4439,11 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	struct kvm_host_map map_save;
 	int ret;
 
-	char *smstate = (char *)smram;
-
 	if (!is_guest_mode(vcpu))
 		return 0;
 
-	/* FED8h - SVM Guest */
-	put_smstate(u64, smstate, 0x7ed8, 1);
-	/* FEE0h - SVM Guest VMCB Physical Address */
-	put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
+	smram->smram64.svm_guest_flag = 1;
+	smram->smram64.svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
@@ -4486,28 +4482,23 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map, map_save;
-	u64 saved_efer, vmcb12_gpa;
 	struct vmcb *vmcb12;
 	int ret;
 
-	const char *smstate = (const char *)smram;
-
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		return 0;
 
 	/* Non-zero if SMI arrived while vCPU was in guest mode. */
-	if (!GET_SMSTATE(u64, smstate, 0x7ed8))
+	if (!smram->smram64.svm_guest_flag)
 		return 0;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
 		return 1;
 
-	saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
-	if (!(saved_efer & EFER_SVME))
+	if (!(smram->smram64.efer & EFER_SVME))
 		return 1;
 
-	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(smram->smram64.svm_guest_vmcb_gpa), &map) == -EINVAL)
 		return 1;
 
 	ret = 1;
@@ -4533,7 +4524,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
+	ret = enter_svm_guest_mode(vcpu, smram->smram64.svm_guest_vmcb_gpa, vmcb12, false);
 
 	if (ret)
 		goto unmap_save;
-- 
2.26.3

