Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFBB588FBE
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbiHCPvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbiHCPvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 11:51:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D04F1DFA3
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 08:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659541855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2n5o7mheKtO8vvklO92VzMiud5N3yOqYKtpNEIS5Hpk=;
        b=h4grGN8531g+/k9qYOFk4mmWqDMYWN2JvyjK1fgxJ4t9uZdFdH5BVwkIlbMchIpZ6VSnkR
        5IpoDPMiiD/hB1VaRYriYOrPnsGxhfzsnRS0lpwROZmATy6lL0lFKl2I6rE1Kzj3H31TP/
        YOkRq5RDKun8sZcJlSQKYfk/oFohO4o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-ETP-vPSoN2KOmkDW-D7iGQ-1; Wed, 03 Aug 2022 11:50:51 -0400
X-MC-Unique: ETP-vPSoN2KOmkDW-D7iGQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F032802E5C;
        Wed,  3 Aug 2022 15:50:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC9C31121314;
        Wed,  3 Aug 2022 15:50:46 +0000 (UTC)
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
Subject: [PATCH v3 08/13] KVM: x86: emulator/smm: use smram structs in the common code
Date:   Wed,  3 Aug 2022 18:50:06 +0300
Message-Id: <20220803155011.43721-9-mlevitsk@redhat.com>
In-Reply-To: <20220803155011.43721-1-mlevitsk@redhat.com>
References: <20220803155011.43721-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch from using a raw array to 'union kvm_smram'.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++--
 arch/x86/kvm/emulate.c          | 12 +++++++-----
 arch/x86/kvm/kvm_emulate.h      |  3 ++-
 arch/x86/kvm/svm/svm.c          |  8 ++++++--
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 arch/x86/kvm/x86.c              | 16 ++++++++--------
 6 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a4315a..d752fabde94ad2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -204,6 +204,7 @@ typedef enum exit_fastpath_completion fastpath_t;
 
 struct x86_emulate_ctxt;
 struct x86_exception;
+union kvm_smram;
 enum x86_intercept;
 enum x86_intercept_stage;
 
@@ -1600,8 +1601,8 @@ struct kvm_x86_ops {
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
 	int (*smi_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
-	int (*enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
-	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
+	int (*enter_smm)(struct kvm_vcpu *vcpu, union kvm_smram *smram);
+	int (*leave_smm)(struct kvm_vcpu *vcpu, const union kvm_smram *smram);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 55d9328e6074a2..610978d00b52b0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2594,16 +2594,18 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 static int em_rsm(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned long cr0, cr4, efer;
-	char buf[512];
+	const union kvm_smram smram;
 	u64 smbase;
 	int ret;
 
+	BUILD_BUG_ON(sizeof(smram) != 512);
+
 	if ((ctxt->ops->get_hflags(ctxt) & X86EMUL_SMM_MASK) == 0)
 		return emulate_ud(ctxt);
 
 	smbase = ctxt->ops->get_smbase(ctxt);
 
-	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, buf, sizeof(buf));
+	ret = ctxt->ops->read_phys(ctxt, smbase + 0xfe00, (void *)&smram, sizeof(smram));
 	if (ret != X86EMUL_CONTINUE)
 		return X86EMUL_UNHANDLEABLE;
 
@@ -2653,15 +2655,15 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	 * state (e.g. enter guest mode) before loading state from the SMM
 	 * state-save area.
 	 */
-	if (ctxt->ops->leave_smm(ctxt, buf))
+	if (ctxt->ops->leave_smm(ctxt, &smram))
 		goto emulate_shutdown;
 
 #ifdef CONFIG_X86_64
 	if (emulator_has_longmode(ctxt))
-		ret = rsm_load_state_64(ctxt, buf);
+		ret = rsm_load_state_64(ctxt, (const char *)&smram);
 	else
 #endif
-		ret = rsm_load_state_32(ctxt, buf);
+		ret = rsm_load_state_32(ctxt, (const char *)&smram);
 
 	if (ret != X86EMUL_CONTINUE)
 		goto emulate_shutdown;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index dd0ae61e44a116..76c0b8e7890b5d 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -19,6 +19,7 @@
 struct x86_emulate_ctxt;
 enum x86_intercept;
 enum x86_intercept_stage;
+union kvm_smram;
 
 struct x86_exception {
 	u8 vector;
@@ -236,7 +237,7 @@ struct x86_emulate_ops {
 
 	unsigned (*get_hflags)(struct x86_emulate_ctxt *ctxt);
 	void (*exiting_smm)(struct x86_emulate_ctxt *ctxt);
-	int (*leave_smm)(struct x86_emulate_ctxt *ctxt, const char *smstate);
+	int (*leave_smm)(struct x86_emulate_ctxt *ctxt, const union kvm_smram *smram);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 38f873cb6f2c14..688315d1dfabd1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4433,12 +4433,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return 1;
 }
 
-static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map_save;
 	int ret;
 
+	char *smstate = (char *)smram;
+
 	if (!is_guest_mode(vcpu))
 		return 0;
 
@@ -4480,7 +4482,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map, map_save;
@@ -4488,6 +4490,8 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct vmcb *vmcb12;
 	int ret;
 
+	const char *smstate = (const char *)smram;
+
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		return 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e72..fdb7e9280e9150 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7919,7 +7919,7 @@ static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 	return !is_smm(vcpu);
 }
 
-static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
+static int vmx_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7940,7 +7940,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	return 0;
 }
 
-static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
+static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int ret;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bea7e5015d592e..cbbe49bdc58787 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8054,9 +8054,9 @@ static void emulator_exiting_smm(struct x86_emulate_ctxt *ctxt)
 }
 
 static int emulator_leave_smm(struct x86_emulate_ctxt *ctxt,
-				  const char *smstate)
+			      const union kvm_smram *smram)
 {
-	return static_call(kvm_x86_leave_smm)(emul_to_vcpu(ctxt), smstate);
+	return static_call(kvm_x86_leave_smm)(emul_to_vcpu(ctxt), smram);
 }
 
 static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
@@ -9979,25 +9979,25 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	struct kvm_segment cs, ds;
 	struct desc_ptr dt;
 	unsigned long cr0;
-	char buf[512];
+	union kvm_smram smram;
 
-	memset(buf, 0, 512);
+	memset(smram.bytes, 0, sizeof(smram.bytes));
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		enter_smm_save_state_64(vcpu, buf);
+		enter_smm_save_state_64(vcpu, (char *)&smram);
 	else
 #endif
-		enter_smm_save_state_32(vcpu, buf);
+		enter_smm_save_state_32(vcpu, (char *)&smram);
 
 	/*
 	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
 	 * state (e.g. leave guest mode) after we've saved the state into the
 	 * SMM state-save area.
 	 */
-	static_call(kvm_x86_enter_smm)(vcpu, buf);
+	static_call(kvm_x86_enter_smm)(vcpu, &smram);
 
 	kvm_smm_changed(vcpu, true);
-	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
+	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, &smram, sizeof(smram));
 
 	if (static_call(kvm_x86_get_nmi_mask)(vcpu))
 		vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;
-- 
2.26.3

