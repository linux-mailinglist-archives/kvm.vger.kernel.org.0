Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197FA4CFE76
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 13:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242294AbiCGM1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 07:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiCGM1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 07:27:36 -0500
Received: from out0-141.mail.aliyun.com (out0-141.mail.aliyun.com [140.205.0.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCC181198;
        Mon,  7 Mar 2022 04:26:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.N.AWOLr_1646655996;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.N.AWOLr_1646655996)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 20:26:37 +0800
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
Subject: [PATCH v2 2/2] KVM: x86/emulator: Emulate RDPID only if it is enabled in guest
Date:   Mon, 07 Mar 2022 20:26:34 +0800
Message-Id: <45a2dbcbf694c48f1fb6a834a0f97a36a226a172.1646655860.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <2b2774154f7532c96a6f04d71c82a8bec7d9e80b.1646655860.git.houwenlong.hwl@antgroup.com>
References: <2b2774154f7532c96a6f04d71c82a8bec7d9e80b.1646655860.git.houwenlong.hwl@antgroup.com>
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

When RDTSCP is supported but RDPID is not supported in host,
RDPID emulation is available. However, __kvm_get_msr() would
only fail when RDTSCP/RDPID both are disabled in guest, so
the emulator wouldn't inject a #UD when RDPID is disabled but
RDTSCP is enabled in guest.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c     | 4 +++-
 arch/x86/kvm/kvm_emulate.h | 1 +
 arch/x86/kvm/x86.c         | 6 ++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3497a35bd085..be83c9c8482d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3521,8 +3521,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 {
 	u64 tsc_aux = 0;
 
-	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
+	if (!ctxt->ops->guest_has_rdpid(ctxt))
 		return emulate_ud(ctxt);
+
+	ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 29ac5a9679e5..1cbd46cf71f9 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -228,6 +228,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09c5677f4186..44f97038d3e5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7723,6 +7723,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
 }
 
+static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
+}
+
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
 	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
@@ -7807,6 +7812,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
+	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
-- 
2.31.1

