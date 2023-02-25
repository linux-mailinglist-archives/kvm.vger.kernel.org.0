Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5601F6A2987
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 13:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBYMWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 07:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBYMWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 07:22:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D3E395;
        Sat, 25 Feb 2023 04:21:55 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C87131EC047D;
        Sat, 25 Feb 2023 13:21:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677327713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OdE0DYVEn9gDitPK3SGqJ0wBcUW0JAiMYjDlzTXKee0=;
        b=HCR4DqNd8FA6jStBpbdi3WhEHDNd9CgJCysyrSH580xrzDLnDWJNQ7hbqIxEOSrTTUsZ7z
        5QQaMwUHhVOhyDA/HpK+BVW5IxPHX19rWoD1U5WlqQJ+OFYJj4zTf4LGg28/U8uvb5gUbY
        zUp+edZPdPAGSeDjZvcMbPuQI2gcjE8=
Date:   Sat, 25 Feb 2023 13:21:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
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
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <Y/n9XcbnCzWv2Vul@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230225013202.g7tibykvylprsxs5@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 05:32:02PM -0800, Josh Poimboeuf wrote:
> > Is it intended to be set regardless of the spectre_v2 mitigation status?
> 
> Right, it needs to check spectre_v2_enabled.

Right, I realized this too this morning, while sleeping, so I made me
a note on the nightstand to fix it... :-)

> Also, this code might be a better fit in identify_secondary_cpu() with
> the other MSR-writing bug-related code.

Same path:

identify_secondary_cpu->identify_cpu->this_cpu->c_init(c)->init_amd

Plus, it keeps the vendor code where it belongs.

v2 below, still untested.

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Date: Sat, 25 Feb 2023 01:11:31 +0100
Subject: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set

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
 arch/x86/kernel/cpu/bugs.c | 14 ++------------
 arch/x86/kernel/cpu/cpu.h  | 10 ++++++++++
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 380753b14cab..aba1b43ed6fd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -996,6 +996,17 @@ static void init_amd(struct cpuinfo_x86 *c)
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);
+
+	/*
+	 * Make sure EFER[AIBRSE - Automatic IBRS Enable] is set. The APs are brought up
+	 * using the trampoline code and as part of it, EFER gets prepared there in order
+	 * to be replicated onto them. Regardless, set it here again, if not set, to protect
+	 * against any future refactoring/code reorganization which might miss setting
+	 * this important bit.
+	 */
+	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled) &&
+	    cpu_has(c, X86_FEATURE_AUTOIBRS))
+		msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4fd43d25b483..407c73d3beb9 100644
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
@@ -1133,16 +1132,7 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
-{
-	return mode == SPECTRE_V2_IBRS ||
-	       mode == SPECTRE_V2_EIBRS ||
-	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
-	       mode == SPECTRE_V2_EIBRS_LFENCE;
-}
-
-static void __init
-spectre_v2_user_select_mitigation(void)
+static void __init spectre_v2_user_select_mitigation(void)
 {
 	enum spectre_v2_user_mitigation mode = SPECTRE_V2_USER_NONE;
 	bool smt_possible = IS_ENABLED(CONFIG_SMP);
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 57a5349e6954..99c507c42901 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -83,4 +83,14 @@ unsigned int aperfmperf_get_khz(int cpu);
 extern void x86_spec_ctrl_setup_ap(void);
 extern void update_srbds_msr(void);
 
+extern enum spectre_v2_mitigation spectre_v2_enabled;
+
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return mode == SPECTRE_V2_IBRS ||
+	       mode == SPECTRE_V2_EIBRS ||
+	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	       mode == SPECTRE_V2_EIBRS_LFENCE;
+}
+
 #endif /* ARCH_X86_CPU_H */
-- 
2.35.1

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
