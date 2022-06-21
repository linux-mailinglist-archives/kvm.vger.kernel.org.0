Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50B655356F
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352358AbiFUPKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352305AbiFUPJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:09:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20B2B286D1
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655824191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ka4XL8eUbPK3JlNTcyLvESzgetbfj19qXaCNRJQDQwU=;
        b=ag/TuFRx8/aXrc9v8LWxDXd5M8BuJMrA222UDQNYl3WPnwTpNdN7HVHd7rtJJutM2ntRfw
        lMiIQatNZWTar4iyOfylPqUtViTWIDh/aREEHLKIQso0K8RFELj5SJOzF+G33wmK3pT6QL
        5DTvbqz6I04OQdA9b3N3WS8x+8JpxQI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-WIYvMZs6Mw-UA6Q5f7iyJw-1; Tue, 21 Jun 2022 11:09:47 -0400
X-MC-Unique: WIYvMZs6Mw-UA6Q5f7iyJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B64E811E83;
        Tue, 21 Jun 2022 15:09:46 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0810710725;
        Tue, 21 Jun 2022 15:09:42 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 10/11] KVM: x86: SVM: use smram structs
Date:   Tue, 21 Jun 2022 18:09:01 +0300
Message-Id: <20220621150902.46126-11-mlevitsk@redhat.com>
In-Reply-To: <20220621150902.46126-1-mlevitsk@redhat.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/svm.c          | 28 +++++++++++++++++-----------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1038ccb7056a39..9e8467be96b4e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2057,12 +2057,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
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
index 136298cfb3fb57..8dcbbe839bef36 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4399,6 +4399,7 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 
 static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 {
+	struct kvm_smram_state_64 *smram = (struct kvm_smram_state_64 *)smstate;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map_save;
 	int ret;
@@ -4406,10 +4407,17 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	if (!is_guest_mode(vcpu))
 		return 0;
 
-	/* FED8h - SVM Guest */
-	put_smstate(u64, smstate, 0x7ed8, 1);
-	/* FEE0h - SVM Guest VMCB Physical Address */
-	put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
+	/*
+	 * 32 bit SMRAM format doesn't preserve EFER and SVM state.
+	 * SVM should not be enabled by the userspace without marking
+	 * the CPU as at least long mode capable.
+	 */
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		return 1;
+
+	smram->svm_guest_flag = 1;
+	smram->svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
@@ -4446,9 +4454,9 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 
 static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
+	struct kvm_smram_state_64 *smram = (struct kvm_smram_state_64 *)smstate;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map, map_save;
-	u64 saved_efer, vmcb12_gpa;
 	struct vmcb *vmcb12;
 	int ret;
 
@@ -4456,18 +4464,16 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		return 0;
 
 	/* Non-zero if SMI arrived while vCPU was in guest mode. */
-	if (!GET_SMSTATE(u64, smstate, 0x7ed8))
+	if (!smram->svm_guest_flag)
 		return 0;
 
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
 		return 1;
 
-	saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
-	if (!(saved_efer & EFER_SVME))
+	if (!(smram->efer & EFER_SVME))
 		return 1;
 
-	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(smram->svm_guest_vmcb_gpa), &map) == -EINVAL)
 		return 1;
 
 	ret = 1;
@@ -4493,7 +4499,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	vmcb12 = map.hva;
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
-	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
+	ret = enter_svm_guest_mode(vcpu, smram->svm_guest_vmcb_gpa, vmcb12, false);
 
 	if (ret)
 		goto unmap_save;
-- 
2.26.3

