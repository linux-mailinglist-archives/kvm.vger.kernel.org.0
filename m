Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C61E6A24F3
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 00:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBXXXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 18:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBXXXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 18:23:09 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE840231D4;
        Fri, 24 Feb 2023 15:23:08 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3C4411EC0725;
        Sat, 25 Feb 2023 00:23:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677280987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=j0zvR/GW8qESlMENYKavRs5BBeojGzLc+Igg/tiAP10=;
        b=LYcoaFyr631Gy3vC9r2lkRIy/pHYb5Kb6lwDjloyRBA8QwwjuE990CgNkiI00nprv/0KY6
        Ow1/wyGRtZpeSkENTyGShz1PCjHPGgaTgNLqDi831UepcbiOdqO9CYXIgJchcHY3q6BhKB
        OqDjqbOoXrxYig5kP9pSfm8H+jGlEbM=
Date:   Sat, 25 Feb 2023 00:23:02 +0100
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
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <Y/lG1v28zQx976Pz@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/k/ZXUXOFiBhOiI@zn.tnic>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 11:51:17PM +0100, Borislav Petkov wrote:
> Or, actually, we should simply write it again because it is the init
> path and not really a hot path but it should damn well make sure that
> that bit gets set.

Yeah, we have this fancy msr_set_bit() interface which saves us the MSR
write when not needed. And it also tells us that. :-)

So we can do:

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 380753b14cab..2aa089aa23db 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -996,6 +996,12 @@ static void init_amd(struct cpuinfo_x86 *c)
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 
 	check_null_seg_clears_base(c);
+
+	if (cpu_has(c, X86_FEATURE_AUTOIBRS)) {
+		int ret = msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+
+		pr_info("%s: CPU%d, ret: %d\n", __func__, smp_processor_id(), ret);
+	}
 }
 
 #ifdef CONFIG_X86_32

---

and the output looks like this:

[    3.046607] x86: Booting SMP configuration:
[    3.046609] .... node  #0, CPUs:          #1
[    2.874768] init_amd: CPU1, ret: 0
[    3.046873]    #2
[    2.874768] init_amd: CPU2, ret: 0
[    3.049155]    #3
[    2.874768] init_amd: CPU3, ret: 0
[    3.050834]    #4
[    2.874768] init_amd: CPU4, ret: 0
...

which says that the bit was already set - which confirms the
trampoline setting thing.

And doing the write again serves as a guard when in the future we decide
to not set EFER anymore - I doubt it - but we can't allow ourselves to
not set the autoibrs bit so one more RDMSR on init doesn't matter.

Proper patch tomorrow.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
