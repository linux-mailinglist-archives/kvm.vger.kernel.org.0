Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0642361FE4F
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 20:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiKGTLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 14:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKGTKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 14:10:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DF629C82;
        Mon,  7 Nov 2022 11:10:48 -0800 (PST)
Received: from zn.tnic (p200300ea9733e71f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e71f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5052F1EC0567;
        Mon,  7 Nov 2022 20:10:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1667848247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zgafXme/YlkPVTuatr/YKPrpFzsJCUOJ17VfQBIvcIA=;
        b=YJ2hJxTGDz78MWs+NfxNQAyMXBGKrEZmSid4LJPUTmJhcqkjulwoXe2CRpAhwfWGGNZKQ6
        6JPQWgbT+W8ye6miqzwlNMJ9vi0JFMbpNL4rbENdJMpKUORXbbOn5W6v74Kv+p7xWGIUiR
        Qu2rcfVifxdsrSfF/1L0UBDJJRgfyW0=
Date:   Mon, 7 Nov 2022 20:10:42 +0100
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
Subject: Re: [PATCH v2 2/5] x86/cpuid: refactor
 setup_clear_cpu_cap()/clear_cpu_cap()
Message-ID: <Y2lYMqLVP+00Rpu5@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-3-mlevitsk@redhat.com>
 <Y1LGkTXCksqAYLHD@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y1LGkTXCksqAYLHD@zn.tnic>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022 at 06:19:29PM +0200, Borislav Petkov wrote:
> On Mon, Jul 18, 2022 at 05:11:20PM +0300, Maxim Levitsky wrote:
> > Currently setup_clear_cpu_cap passes NULL 'struct cpuinfo_x86*'
> > to clear_cpu_cap to indicate that capability should be cleared from boot_cpu_data.
> > 
> > Later that is used in clear_feature to do recursive call to
> > clear_cpu_cap together with clearing the feature bit from 'cpu_caps_cleared'
> > 
> > Remove that code and just call the do_clear_cpu_cap on boot_cpu_data directly
> > from the setup_clear_cpu_cap.
> > 
> > The only functional change this introduces is that now calling clear_cpu_cap
> > explicitly on boot_cpu_data also sets the bits in cpu_caps_cleared,
> > which is the only thing that makes sense anyway.
> > 
> > All callers of both functions were checked for this and fixed.
> 
> Change looks ok. What I can't grok is this sentence: what was checked
> and fixed where?

Ok, I think I know what you mean. That:

git grep -E "clear_cpu_cap.*boot"
arch/x86/events/intel/lbr.c:1599:       clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
arch/x86/kernel/alternative.c:746:              clear_cpu_cap(&boot_cpu_data, X86_FEATURE_UP);

Right, so here's the difference:

When you call setup_clear_cpu_cap(), it basically means, to disable the
cap on *every* CPU. This is done with cpu_caps_cleared which gets ANDed
in in apply_forced_caps().

clear_cpu_cap() clears the bit *only* in the first parameter supplied.

Now, that first parameter can be boot_cpu_data too but then, strictly
speaking, clear_cpu_cap() would really do what you want it to do - to
clear it only in its first param.

If you really want to enforce that bit cleared everywhere, you need to
use the setup_* variant.

So this patch is actually incorrect but I admit, the CPU caps handling
are kinda subtle and probably need cleaning.

Lemme document it so that it is at least clear. Who knows, we might end
up improving it in the process.

:-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
