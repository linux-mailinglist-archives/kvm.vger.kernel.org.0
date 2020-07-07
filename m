Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B76C216FEF
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgGGPMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 11:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgGGPMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 11:12:00 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAF52065D;
        Tue,  7 Jul 2020 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134720;
        bh=C4bPJbq0e1P34S5uLx3jO+V10U+5mus3QC4vneFLX1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=frYEk8iaPRhfVRhVtZ5aQCYq7V2EWVUpPQ1xar9FIMJtduC6Os5mcGHmWesD2xu0j
         bxNCIk4f9NvMsPil6ThxO/O7OddeaOOHn2PYV3T/QTBDeqhhHAgqRuAxsXYk1t++rw
         GVsJbkqA7f3SQDK8ZCTW/skBpHyrtMSbJrTVCyXQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jspGI-009mGD-I7; Tue, 07 Jul 2020 16:11:58 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH] KVM: arm64: Don't use has_vhe() for CHOOSE_HYP_SYM()
Date:   Tue,  7 Jul 2020 16:11:12 +0100
Message-Id: <20200707151112.2514630-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The recently introduced CHOOSE_HYP_SYM() macro picks one symbol
or another, depending on whether the kernel run as a VHE
hypervisor or not. For that, it uses the has_vhe() helper, which
is itself implemented as a final capability.

Unfortunately, __copy_hyp_vect_bpi now indirectly uses CHOOSE_HYP_SYM
to get the __bp_harden_hyp_vecs symbol, using has_vhe() in the process.
At this stage, the capability isn't final and things explode:

[    0.000000] ACPI: SRAT not present
[    0.000000] percpu: Embedded 34 pages/cpu s101264 r8192 d29808 u139264
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] ------------[ cut here ]------------
[    0.000000] kernel BUG at arch/arm64/include/asm/cpufeature.h:459!
[    0.000000] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.8.0-rc4-00080-gd630681366e5 #1388
[    0.000000] pstate: 80000085 (Nzcv daIf -PAN -UAO BTYPE=--)
[    0.000000] pc : check_branch_predictor+0x3a4/0x408
[    0.000000] lr : check_branch_predictor+0x2a4/0x408
[    0.000000] sp : ffff800011693e90
[    0.000000] x29: ffff800011693e90 x28: ffff8000116a1530
[    0.000000] x27: ffff8000112c1008 x26: ffff800010ca6ff8
[    0.000000] x25: ffff8000112c1000 x24: ffff8000116a1320
[    0.000000] x23: 0000000000000000 x22: ffff8000112c1000
[    0.000000] x21: ffff800010177120 x20: ffff8000116ae108
[    0.000000] x19: 0000000000000000 x18: ffff800011965c90
[    0.000000] x17: 0000000000022000 x16: 0000000000000003
[    0.000000] x15: 00000000ffffffff x14: ffff8000118c3a38
[    0.000000] x13: 0000000000000021 x12: 0000000000000022
[    0.000000] x11: d37a6f4de9bd37a7 x10: 000000000000001d
[    0.000000] x9 : 0000000000000000 x8 : ffff800011f8dad8
[    0.000000] x7 : ffff800011965ad0 x6 : 0000000000000003
[    0.000000] x5 : 0000000000000000 x4 : 0000000000000000
[    0.000000] x3 : 0000000000000100 x2 : 0000000000000004
[    0.000000] x1 : ffff8000116ae148 x0 : 0000000000000000
[    0.000000] Call trace:
[    0.000000]  check_branch_predictor+0x3a4/0x408
[    0.000000]  update_cpu_capabilities+0x84/0x138
[    0.000000]  init_cpu_features+0x2c0/0x2d8
[    0.000000]  cpuinfo_store_boot_cpu+0x54/0x64
[    0.000000]  smp_prepare_boot_cpu+0x2c/0x60
[    0.000000]  start_kernel+0x16c/0x574
[    0.000000] Code: 17ffffc7 91010281 14000198 17ffffca (d4210000)

This is addressed using a two-fold process:
- Replace has_vhe() with is_kernel_in_hyp_mode(), which tests
  whether we are running at EL2.
- Make CHOOSE_HYP_SYM() return an *undefined* symbol when
  compiled in the nVHE hypervisor, as we really should never
  use this helper in the nVHE-specific code.

With this in place, we're back to a bootable kernel again.

Fixes: b877e9849d41 ("KVM: arm64: Build hyp-entry.S separately for VHE/nVHE")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5716f5de9707..fb1a922b31ba 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -62,8 +62,26 @@
 
 #define CHOOSE_VHE_SYM(sym)	sym
 #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
-#define CHOOSE_HYP_SYM(sym)	(has_vhe() ? CHOOSE_VHE_SYM(sym) \
+
+#ifndef __KVM_NVHE_HYPERVISOR__
+/*
+ * BIG FAT WARNINGS:
+ *
+ * - Don't be tempted to change the following is_kernel_in_hyp_mode()
+ *   to has_vhe(). has_vhe() is implemented as a *final* capability,
+ *   while this is used early at boot time, when the capabilities are
+ *   not final yet....
+ *
+ * - Don't let the nVHE hypervisor have access to this, as it will
+ *   pick the *wrong* symbol (yes, it runs at EL2...).
+ */
+#define CHOOSE_HYP_SYM(sym)	(is_kernel_in_hyp_mode() ? CHOOSE_VHE_SYM(sym) \
 					   : CHOOSE_NVHE_SYM(sym))
+#else
+/* The nVHE hypervisor shouldn't even try to access anything */
+extern void *__nvhe_undefined_symbol;
+#define CHOOSE_HYP_SYM(sym)	__nvhe_undefined_symbol
+#endif
 
 /* Translate a kernel address @ptr into its equivalent linear mapping */
 #define kvm_ksym_ref(ptr)						\
-- 
2.26.2

