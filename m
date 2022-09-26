Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BDA5EA8EC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbiIZOsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234674AbiIZOrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:47:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05F6B1D4;
        Mon, 26 Sep 2022 06:12:42 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e74d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e74d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED5171EC051E;
        Mon, 26 Sep 2022 15:12:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1664197956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=WoAsNIjxtOydRj3E9e8AKmT+MPVf0jUVuDQQzfJocNg=;
        b=YlkrwAcwyMQjQRO0wTBEUyoDvIIogt7PwJBqH9c6yVxgqYlhBY5xt3oHREab1EXAgd1+Jt
        ajd5Z6pFsRNvdhCy0jlBQv3Pytt9U52OucBWsQsAJGfx18Xvd1FQyx1QD2bygaB9ytBcb2
        ccjY1VjlLyZmDeDfFXjwOze/QNV1TC0=
Date:   Mon, 26 Sep 2022 15:12:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] perf/x86/intel/lbr: use setup_clear_cpu_cap
 instead of clear_cpu_cap
Message-ID: <YzGlQBkCSJxY+8Jf@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-2-mlevitsk@redhat.com>
 <Yyh9RDbaRqUR1XSW@zn.tnic>
 <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c105971a72dfe6d46ad75fb7e71f79ba716e081c.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 11:20:47AM +0300, Maxim Levitsky wrote:
> If I understand that correctly, the difference between clear_cpu_cap and setup_clear_cpu_cap
> is that setup_clear_cpu_cap should be called early when only the boot cpu is running and it 
>
> 1. works on 'boot_cpu_data' which represents the boot cpu.
> 2. sets a bit in 'cpu_caps_cleared' which are later applied to all CPUs, including these that are hotplugged.

Yes.

> On the other hand the clear_cpu_cap just affects the given 'struct cpuinfo_x86'.

Yes.

> Call of 'clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR)' is weird since it still affects 'boot_cpu_data'
> but doesn't affect 'cpu_caps_cleared'

Yes.

> I assumed that this was a mistake and the intention was to disable the feature on all CPUs.

peterz says yes.

> I need this patch because in the next patch, I change the clear_cpu_cap such as it detects being
> called on boot_cpu_data and in this case also clears bits in 'cpu_caps_cleared', thus
> while this patch does introduce a functional change, the next patch doesn't since this is the only
> place where clear_cpu_cap is called explicitly on 'boot_cpu_data'

This is not needed - this patch doing setup_clear_cpu_cap() should suffice.

But, there must be something you're fixing with this. Which is it? Some
weird virt config?

> I do now notice that initcalls are run after smp is initialized, which
> means that this code doesn't really disable the CPUID feature on all
> CPUs at all.

Well, not exactly. There's do_pre_smp_calls() which is where the
early_initcall() thing is run.

So setup_clear_cpu_cap() will make sure that the feature bit is cleared
when the APs come online.

Do you have a virt configuration where you can test this case where the
feature flag is clear on all CPUs when it fails?

I.e., "arch_lbr" will disappear in /proc/cpuinfo completely.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
