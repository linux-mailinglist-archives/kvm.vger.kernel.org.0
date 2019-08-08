Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B298681A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404394AbfHHRbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36304 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404378AbfHHRbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so1988719wrt.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OrZlb/PPDCv83pS8OZEyWscfXBkK3tF0dI829N03AEg=;
        b=GHSc+3ydVefsaEGAfsGOTe38944UEunk7+c8gZHuXlAMUsXRoYNhAbFjMyrSeXpnPQ
         N8/FtrIt9F1JXsWUOOs+J5q3jImFrXLWNsi1mVTJh9UkllA6VN5yd51ld0Xz2oJjWpn+
         Bbxv+Rl4TjqX3etyngdtb7ZGDqct19PDFOukylqH+vYANoA92+lVINdg0qMa7GYE1KdP
         Tb4uwKb6oW8dRLGzy3HoZ9l8hOjfXQITXN186ELCjW/BiRd1zWYPfqELngfiH41nDVb+
         WNL96sMK9uR3NkHBDNTfoYHTbhAXVpS0Agu/EOfhZ/B9DQW62yll0wKv0ZN76hl1yaEE
         Hg2w==
X-Gm-Message-State: APjAAAVNlWsLr3P0sX3oDZlAvXYtGUJW+SlRmL66uzAtyehOc/NDgbsf
        32Sxy7VH0v9lWJjRkrhcneXLdO7Dhtg=
X-Google-Smtp-Source: APXvYqwZsjo1q2VLIRF5Vw3WvB1AeiVm0PcY9HQk4DrPeZZQgC8w8+NUWQC1Yp1eN6Ric9+VH+8FBA==
X-Received: by 2002:adf:eac5:: with SMTP id o5mr5554602wrn.140.1565285461828;
        Thu, 08 Aug 2019 10:31:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.30.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:31:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 4/7] x86: KVM: add xsetbv to the emulator
Date:   Thu,  8 Aug 2019 19:30:48 +0200
Message-Id: <20190808173051.6359-5-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
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
index 8299b0de06e2..858feeac01a4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6067,6 +6067,7 @@ static const struct __x86_intercept {
 	[x86_intercept_ins]		= POST_EX(SVM_EXIT_IOIO),
 	[x86_intercept_out]		= POST_EX(SVM_EXIT_IOIO),
 	[x86_intercept_outs]		= POST_EX(SVM_EXIT_IOIO),
+	[x86_intercept_xsetbv]		= PRE_EX(SVM_EXIT_XSETBV),
 };
 
 #undef PRE_EX
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50e0b25092c7..2f4a4d0967f3 100644
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

