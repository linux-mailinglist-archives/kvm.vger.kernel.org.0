Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9956B4CE8
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCJQ1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjCJQ0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:26:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4E164B20;
        Fri, 10 Mar 2023 08:23:12 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5C3E11EC0554;
        Fri, 10 Mar 2023 17:22:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678465377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Zn3O1Wv8hkpbU9xlZEacvI/7IhPFKYjF4Rh+Ru4Qd7o=;
        b=i4X5Mit4U8kl9v7iGgYtOKUsx1Wd68zbYF2p6kNYzqJ7GiZu/mWyCs3+mmgXDho/tsy1Uq
        c4NTudr4144eQrYalak0XGyKKhUqr4axXIMb0VupXDBjeddRqYLAsrfsBXdMlD8Tpvm5Mn
        eKKNGx344acXzkCNqDR2ES0jFJr0XuE=
Date:   Fri, 10 Mar 2023 17:22:53 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -v2] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <20230310162253.GCZAtZXcpK2JK0cFkZ@fat_crate.local>
References: <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <445daef5-8417-ddbb-abbf-3c5ab38e1c9c@intel.com>
 <Y/zO7MtvjiVLCiLg@zn.tnic>
 <3f80e71f-a995-8ad6-b7f2-2b80fefdbd46@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f80e71f-a995-8ad6-b7f2-2b80fefdbd46@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2, with feedback addressed, and rediffed ontop of 6.3-rc1:

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>

The AutoIBRS bit gets set only on the BSP as part of determining which
mitigation to enable on AMD. Setting on the APs relies on the
circumstance that the APs get booted through the trampoline and EFER
- the MSR which contains that bit - gets replicated on every AP from the
BSP.

However, this can change in the future and considering the security
implications of this bit not being set on every CPU, make sure it is set
by verifying EFER later in the boot process and on every AP.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230224185257.o3mcmloei5zqu7wa@treble
---
 arch/x86/kernel/cpu/amd.c  | 11 +++++++++++
 arch/x86/kernel/cpu/bugs.c | 10 +---------
 arch/x86/kernel/cpu/cpu.h  |  8 ++++++++
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 380753b14cab..dd32dbc7c33e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -996,6 +996,17 @@ static void init_amd(struct cpuinfo_x86 *c)
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);
+
+	/*
+	 * Make sure EFER[AIBRSE - Automatic IBRS Enable] is set. The APs are brought up
+	 * using the trampoline code and as part of it, MSR_EFER gets prepared there in
+	 * order to be replicated onto them. Regardless, set it here again, if not set,
+	 * to protect against any future refactoring/code reorganization which might
+	 * miss setting this important bit.
+	 */
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled) &&
+	    cpu_has(c, X86_FEATURE_AUTOIBRS))
+		WARN_ON_ONCE(msr_set_bit(MSR_EFER, _EFER_AUTOIBRS));
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f9d060e71c3e..182af64387d0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -784,8 +784,7 @@ static int __init nospectre_v1_cmdline(char *str)
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
-static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
-	SPECTRE_V2_NONE;
+enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init = SPECTRE_V2_NONE;
 
 #undef pr_fmt
 #define pr_fmt(fmt)     "RETBleed: " fmt
@@ -1133,13 +1132,6 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
-{
-	return mode == SPECTRE_V2_EIBRS ||
-	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
-	       mode == SPECTRE_V2_EIBRS_LFENCE;
-}
-
 static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 {
 	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 57a5349e6954..f97b0fe13da8 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -83,4 +83,12 @@ unsigned int aperfmperf_get_khz(int cpu);
 extern void x86_spec_ctrl_setup_ap(void);
 extern void update_srbds_msr(void);
 
+extern enum spectre_v2_mitigation spectre_v2_enabled;
+
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return mode == SPECTRE_V2_EIBRS ||
+	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	       mode == SPECTRE_V2_EIBRS_LFENCE;
+}
 #endif /* ARCH_X86_CPU_H */
-- 
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
