Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4283B7799AA
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 23:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbjHKViq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 17:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbjHKVip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 17:38:45 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2CE271E;
        Fri, 11 Aug 2023 14:38:43 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5121D40E0194;
        Fri, 11 Aug 2023 21:38:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
        reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TBV3ZfJQF_rh; Fri, 11 Aug 2023 21:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1691789919; bh=8lThs7X7lClP0qlzhhIQWUA0MkkUb+owSuB5fkWYPt4=;
        h=From:To:Cc:Subject:Date:From;
        b=PkffhscIv9jqZRCClpKYvVliU3bxTCYLu5cwXHf0wckVVNVXYNo26g9YVb/AbZ9nt
         6Je++Qd/7U6KJ/CWhZCWDDRYb3dLplJ6f6SglWE7Wd4CH818OcIC2UnBEs2rZuIhKV
         cuk0k0gmMRFnRh+2/TQmP/gZCXR1LQA/wTjUUbWNMDBoWOtjUjOh0Oj9G3pICWwQJe
         SxUw1gTqepOkruEd5ezJL+TtFKHmBT1V9AjMGzgCSCAX5ziNfLOOF08AK3sxZ9vg7J
         I6KoOkigD8QYh2Q/zYuKDOJK0jESAjiEB9zgA34BuJ/ZMqtKsKVxr54c2v+zMKCVMR
         JZjcXS9OkPWzA0klDidVOgVx08/mk7iWfeLRx2+u4b7z6JKvssMTxfpxf51s/rY8iA
         5rlwUMfEJhK2B6H2PZPWEY9Mcpy//HPng3/CauN7kP3kh1WWFUCceROVAR9VMd8jWI
         qDxgSA+nkDBg2UpDU1k5ptn1smz+6EVBWFToYsi198Gw2DyMTVUO94fZDL3Wa78P2D
         5EX1p3SxN/fvDPPIQ/1+hohw+X+0ebVUb1nVWVSyCrIaFARLPX8JtRGjC+Z/TYw3sP
         s4FHW7Zy1vEdXD/pHrEbZ2/Hi7lhVJgRGhY/A8JdJfzCPzr6+q6tkzG5A97y2GArPC
         oFQJdiV+ajU/rJuVZLFSbFyw=
Received: from zn.tnic (pd9530d32.dip0.t-ipconnect.de [217.83.13.50])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4236D40E0185;
        Fri, 11 Aug 2023 21:38:35 +0000 (UTC)
From:   Borislav Petkov <bp@alien8.de>
To:     X86 ML <x86@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: [PATCH] x86/CPU/AMD: Fix the DIV(0) initial fix attempt
Date:   Fri, 11 Aug 2023 23:38:24 +0200
Message-ID: <20230811213824.10025-1-bp@alien8.de>
X-Mailer: git-send-email 2.42.0.rc0.25.ga82fb66fed25
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Borislav Petkov (AMD)" <bp@alien8.de>

Initially, it was thought that doing an innocuous division in the DE#
handler would take care to prevent any leaking of old data from the
divider but by the time the fault is raised, the speculation has already
advanced too far and such data could already have been used by younger
operations.

Therefore, do the innocuous division on every exit to userspace so that
userspace doesn't see any potentially old data from integer divisions in
kernel space.

Do the same before VMRUN too, to protect host data from leaking into the
guest too.

Fixes: 77245f1c3c64 ("x86/CPU/AMD: Do not leak quotient data after a divi=
sion by 0")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
---
 arch/x86/include/asm/entry-common.h | 1 +
 arch/x86/kernel/cpu/amd.c           | 1 +
 arch/x86/kernel/traps.c             | 2 --
 arch/x86/kvm/svm/svm.c              | 2 ++
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/e=
ntry-common.h
index 117903881fe4..ce8f50192ae3 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -92,6 +92,7 @@ static inline void arch_exit_to_user_mode_prepare(struc=
t pt_regs *regs,
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	mds_user_clear_cpu_buffers();
+	amd_clear_divider();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
=20
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b55d8f82b621..89a52db40d64 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1328,3 +1328,4 @@ void noinstr amd_clear_divider(void)
 	asm volatile(ALTERNATIVE("", "div %2\n\t", X86_BUG_DIV0)
 		     :: "a" (0), "d" (0), "r" (1));
 }
+EXPORT_SYMBOL_GPL(amd_clear_divider);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1885326a8f65..4a817d20ce3b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -206,8 +206,6 @@ DEFINE_IDTENTRY(exc_divide_error)
 {
 	do_error_trap(regs, 0, "divide error", X86_TRAP_DE, SIGFPE,
 		      FPE_INTDIV, error_get_trap_addr(regs));
-
-	amd_clear_divider();
 }
=20
 DEFINE_IDTENTRY(exc_overflow)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03e852dedcc1..d4bfdc607fe7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4006,6 +4006,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_=
vcpu *vcpu, bool spec_ctrl_in
=20
 	guest_state_enter_irqoff();
=20
+	amd_clear_divider();
+
 	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
 	else
--=20
2.42.0.rc0.25.ga82fb66fed25

