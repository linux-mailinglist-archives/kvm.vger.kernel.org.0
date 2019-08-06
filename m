Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0182B64
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbfHFGCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:02:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39520 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFGCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:02:00 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so64772020wmc.4
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfrxUaemeRG9VI0ytXEeofeipp9g1C2I6vo/HJLUMww=;
        b=KPQCAhKBiY2AIcaubCoaupfbJXuxNiOHYHxvg1nXCUP8sRsXI/CTSm4bpRSJc7DdlS
         9ETYSuFG/dWxuXZtTSXY4kmkN2IJ9+AQY3Wq7zV68yWM45J7wX9KlaE28QEHA3ax38Pn
         gpW1Mn/aAgpF+B1mUozPH0rUBODlAXj+5yDL8l4FYjMrs2Jsrr/zyoFn0VplmH3ZeuCT
         eMzfhOQKgtRonhy4+u9GoNrYL8QKuXara5edIlVWE/F1LpixyXusGirh2vxTa81OcVxe
         E/lBfOW00pMrJI9wAbaMIFYmc1h2TYsMQPjp5WZKFR6o9ke2XV0fW2F8Z9WQsvYOeEXa
         IgPw==
X-Gm-Message-State: APjAAAV1fD+oRJ8iU3XhFK5rDWRDZfYAe3iFgmzJK7tx0QvtnBrbnxSq
        Ka6wRSkSx34VaQltF+FAmwopFZQtCVA=
X-Google-Smtp-Source: APXvYqxy/Qek+sb8jhKHItoVqLd23jTp4eCz5u21ZKnCSx/bUGJi1LZP4lyi6e7CxyRHQ5sjNppevg==
X-Received: by 2002:a7b:c04f:: with SMTP id u15mr2361536wmc.106.1565071318296;
        Mon, 05 Aug 2019 23:01:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id r5sm94216756wmh.35.2019.08.05.23.01.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:01:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 4/5] x86: KVM: add xsetbv to the emulator
Date:   Tue,  6 Aug 2019 08:01:49 +0200
Message-Id: <20190806060150.32360-5-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806060150.32360-1-vkuznets@redhat.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid hardcoding xsetbv length to '3' we need to support decoding it in
the emulator.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  3 ++-
 arch/x86/kvm/emulate.c             | 23 ++++++++++++++++++++++-
 arch/x86/kvm/svm.c                 |  1 +
 arch/x86/kvm/x86.c                 |  6 ++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index feab24cac610..77cf6c11f66b 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -229,7 +229,7 @@ struct x86_emulate_ops {
 	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
 			     const char *smstate);
 	void (*post_leave_smm)(struct x86_emulate_ctxt *ctxt);
-
+	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
 };
 
 typedef u32 __attribute__((vector_size(16))) sse128_t;
@@ -429,6 +429,7 @@ enum x86_intercept {
 	x86_intercept_ins,
 	x86_intercept_out,
 	x86_intercept_outs,
+	x86_intercept_xsetbv,
 
 	nr_x86_intercepts
 };
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 718f7d9afedc..f9e843dd992a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4156,6 +4156,20 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 	return rc;
 }
 
+static int em_xsetbv(struct x86_emulate_ctxt *ctxt)
+{
+	u32 eax, ecx, edx;
+
+	eax = reg_read(ctxt, VCPU_REGS_RAX);
+	edx = reg_read(ctxt, VCPU_REGS_RDX);
+	ecx = reg_read(ctxt, VCPU_REGS_RCX);
+
+	if (ctxt->ops->set_xcr(ctxt, ecx, ((u64)edx << 32) | eax))
+		return emulate_gp(ctxt, 0);
+
+	return X86EMUL_CONTINUE;
+}
+
 static bool valid_cr(int nr)
 {
 	switch (nr) {
@@ -4409,6 +4423,12 @@ static const struct opcode group7_rm1[] = {
 	N, N, N, N, N, N,
 };
 
+static const struct opcode group7_rm2[] = {
+	N,
+	II(ImplicitOps | Priv,			em_xsetbv,	xsetbv),
+	N, N, N, N, N, N,
+};
+
 static const struct opcode group7_rm3[] = {
 	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
 	II(SrcNone  | Prot | EmulateOnUD,	em_hypercall,	vmmcall),
@@ -4498,7 +4518,8 @@ static const struct group_dual group7 = { {
 }, {
 	EXT(0, group7_rm0),
 	EXT(0, group7_rm1),
-	N, EXT(0, group7_rm3),
+	EXT(0, group7_rm2),
+	EXT(0, group7_rm3),
 	II(SrcNone | DstMem | Mov,		em_smsw, smsw), N,
 	II(SrcMem16 | Mov | Priv,		em_lmsw, lmsw),
 	EXT(0, group7_rm7),
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 80f576e05112..793a60461abe 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6064,6 +6064,7 @@ static const struct __x86_intercept {
 	[x86_intercept_ins]		= POST_EX(SVM_EXIT_IOIO),
 	[x86_intercept_out]		= POST_EX(SVM_EXIT_IOIO),
 	[x86_intercept_outs]		= POST_EX(SVM_EXIT_IOIO),
+	[x86_intercept_xsetbv]		= PRE_EX(SVM_EXIT_XSETBV),
 };
 
 #undef PRE_EX
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eac8253d84d2..b902b4735ad1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6068,6 +6068,11 @@ static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
 	kvm_smm_changed(emul_to_vcpu(ctxt));
 }
 
+static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
+{
+	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.read_gpr            = emulator_read_gpr,
 	.write_gpr           = emulator_write_gpr,
@@ -6109,6 +6114,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_hflags          = emulator_set_hflags,
 	.pre_leave_smm       = emulator_pre_leave_smm,
 	.post_leave_smm      = emulator_post_leave_smm,
+	.set_xcr             = emulator_set_xcr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.20.1

