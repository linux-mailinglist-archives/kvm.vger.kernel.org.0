Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE804CFE70
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242281AbiCGM1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiCGM1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:27:37 -0500
Received: from out0-129.mail.aliyun.com (out0-129.mail.aliyun.com [140.205.0.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07E181199;
        Mon,  7 Mar 2022 04:26:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047209;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.N.AWOLN_1646655994;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.N.AWOLN_1646655994)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 20:26:35 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: x86: Only do MSR filtering when access MSR by rdmsr/wrmsr
Date:   Mon, 07 Mar 2022 20:26:33 +0800
Message-Id: <2b2774154f7532c96a6f04d71c82a8bec7d9e80b.1646655860.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1dfd46ae5b76d3ed87bde3154d51c64ea64c99c1.1646226788.git.houwenlong.hwl@antgroup.com>
References: <1dfd46ae5b76d3ed87bde3154d51c64ea64c99c1.1646226788.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If MSR access is rejected by MSR filtering,
kvm_set_msr()/kvm_get_msr() would return KVM_MSR_RET_FILTERED,
and the return value is only handled well for rdmsr/wrmsr.
However, some instruction emulation and state transition also
use kvm_set_msr()/kvm_get_msr() to do msr access but may trigger
some unexpected results if MSR access is rejected, E.g. RDPID
emulation would inject a #UD but RDPID wouldn't cause a exit
when RDPID is supported in hardware and ENABLE_RDTSCP is set.
And it would also cause failure when load MSR at nested entry/exit.
Since msr filtering is based on MSR bitmap, it is better to only
do MSR filtering for rdmsr/wrmsr.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c     |  4 +--
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/x86.c         | 50 +++++++++++++++++++++++++++-----------
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a60b4d20b309..3497a35bd085 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3623,7 +3623,7 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 
 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
-	r = ctxt->ops->set_msr(ctxt, msr_index, msr_data);
+	r = ctxt->ops->set_msr_with_filter(ctxt, msr_index, msr_data);
 
 	if (r == X86EMUL_IO_NEEDED)
 		return r;
@@ -3640,7 +3640,7 @@ static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
 	u64 msr_data;
 	int r;
 
-	r = ctxt->ops->get_msr(ctxt, msr_index, &msr_data);
+	r = ctxt->ops->get_msr_with_filter(ctxt, msr_index, &msr_data);
 
 	if (r == X86EMUL_IO_NEEDED)
 		return r;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 39eded2426ff..29ac5a9679e5 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -210,6 +210,8 @@ struct x86_emulate_ops {
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	u64 (*get_smbase)(struct x86_emulate_ctxt *ctxt);
 	void (*set_smbase)(struct x86_emulate_ctxt *ctxt, u64 smbase);
+	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
+	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
 	int (*set_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
 	int (*check_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf17af4d6904..09c5677f4186 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1736,9 +1736,6 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 {
 	struct msr_data msr;
 
-	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
-		return KVM_MSR_RET_FILTERED;
-
 	switch (index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
@@ -1820,9 +1817,6 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 	struct msr_data msr;
 	int ret;
 
-	if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
-		return KVM_MSR_RET_FILTERED;
-
 	switch (index) {
 	case MSR_TSC_AUX:
 		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
@@ -1859,6 +1853,20 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
+		return KVM_MSR_RET_FILTERED;
+	return kvm_get_msr_ignored_check(vcpu, index, data, false);
+}
+
+static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
+		return KVM_MSR_RET_FILTERED;
+	return kvm_set_msr_ignored_check(vcpu, index, data, false);
+}
+
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
@@ -1941,7 +1949,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	u64 data;
 	int r;
 
-	r = kvm_get_msr(vcpu, ecx, &data);
+	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
 
 	if (!r) {
 		trace_kvm_msr_read(ecx, data);
@@ -1966,7 +1974,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
-	r = kvm_set_msr(vcpu, ecx, data);
+	r = kvm_set_msr_with_filter(vcpu, ecx, data);
 
 	if (!r) {
 		trace_kvm_msr_write(ecx, data);
@@ -7606,13 +7614,13 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 	return;
 }
 
-static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
-			    u32 msr_index, u64 *pdata)
+static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
+					u32 msr_index, u64 *pdata)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_get_msr(vcpu, msr_index, pdata);
+	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
 
 	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
 				    complete_emulated_rdmsr, r)) {
@@ -7623,13 +7631,13 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 	return r;
 }
 
-static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
-			    u32 msr_index, u64 data)
+static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
+					u32 msr_index, u64 data)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_set_msr(vcpu, msr_index, data);
+	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
 
 	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
 				    complete_emulated_msr_access, r)) {
@@ -7640,6 +7648,18 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 	return r;
 }
 
+static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
+			    u32 msr_index, u64 *pdata)
+{
+	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+}
+
+static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
+			    u32 msr_index, u64 data)
+{
+	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
+}
+
 static u64 emulator_get_smbase(struct x86_emulate_ctxt *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
@@ -7773,6 +7793,8 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_dr              = emulator_set_dr,
 	.get_smbase          = emulator_get_smbase,
 	.set_smbase          = emulator_set_smbase,
+	.set_msr_with_filter = emulator_set_msr_with_filter,
+	.get_msr_with_filter = emulator_get_msr_with_filter,
 	.set_msr             = emulator_set_msr,
 	.get_msr             = emulator_get_msr,
 	.check_pmc	     = emulator_check_pmc,
-- 
2.31.1

