Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DEF6A256F
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 01:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBYAUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 19:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjBYAUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 19:20:31 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785016F009;
        Fri, 24 Feb 2023 16:20:30 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C2F971EC0543;
        Sat, 25 Feb 2023 01:20:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677284428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=X7PAPL/STovbCmJD9AH2lbf9CjEajQmm8ljOsvBs+uE=;
        b=De9a7roHnFHHeYNZTfamL+Jp8O3FZ1mA7hCeuPeeFf8V4DpWpy3Zk4o3A4wm+vlMNcByXt
        88ERf57XlocQRI40fn9rolXPa4iR74uE4op/P3e6RUQxZmd4Ghs2u/F1ZiD9qaLtKqrW0r
        AEY9fBnMq/qBCLGmghyZajZ0MiL/CJk=
Date:   Sat, 25 Feb 2023 01:20:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
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
Subject: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <Y/lUSC5x2ZkTIGu4@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230225000931.wrednfun4jifkqau@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 04:09:31PM -0800, Josh Poimboeuf wrote:
> Ah, I had to stare it that for a bit to figure out how it works.

Yeah, it is a bit "hidden". :)

> setup_real_mode() reads MSR_EFER from the boot CPU and stores it in
> trampoline_header->efer.  Then the other CPUs read that stored value in
> startup_32() and write it into their MSR.

Exactly.

> Yeah, I think that would be good.  Otherwise it's rather magical.

Yap, see below.

> That EFER MSR is a surprising place to put that bit.

That MSR is very important on AMD. Consider it AMD's CR4. :-)

Thx.

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
 arch/x86/kernel/cpu/amd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 380753b14cab..de624c1442c2 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -996,6 +996,16 @@ static void init_amd(struct cpuinfo_x86 *c)
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
+	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
+		msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
 }
 
 #ifdef CONFIG_X86_32
-- 
2.35.1



-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
