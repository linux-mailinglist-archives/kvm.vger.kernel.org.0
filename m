Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB0607C09
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJUQUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiJUQTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 12:19:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D557D4456E;
        Fri, 21 Oct 2022 09:19:36 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e769329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e769:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0CC6D1EC0731;
        Fri, 21 Oct 2022 18:19:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1666369174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=osvnA1VVG8lOO7CofSEE3U1qKE+FmJzIhRV7z1btuj4=;
        b=kTrJPiFSirvT8QAitnYEpzpcdMbtcXA5yOQxTep7XgZPzoZ7lttGRZVygRLbYsnaOD+LzU
        /RhEgA3iGecU55zSIGnw2ZiO8DllFm7LXz29lmQH3D3HkNrqJcr2lCuQHbKV8uRxNlwMvW
        ITkPMYEdCWAcH8rJMRHThhLuixBO9Z8=
Date:   Fri, 21 Oct 2022 18:19:29 +0200
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
Message-ID: <Y1LGkTXCksqAYLHD@zn.tnic>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
 <20220718141123.136106-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220718141123.136106-3-mlevitsk@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 05:11:20PM +0300, Maxim Levitsky wrote:
> Currently setup_clear_cpu_cap passes NULL 'struct cpuinfo_x86*'
> to clear_cpu_cap to indicate that capability should be cleared from boot_cpu_data.
> 
> Later that is used in clear_feature to do recursive call to
> clear_cpu_cap together with clearing the feature bit from 'cpu_caps_cleared'
> 
> Remove that code and just call the do_clear_cpu_cap on boot_cpu_data directly
> from the setup_clear_cpu_cap.
> 
> The only functional change this introduces is that now calling clear_cpu_cap
> explicitly on boot_cpu_data also sets the bits in cpu_caps_cleared,
> which is the only thing that makes sense anyway.
> 
> All callers of both functions were checked for this and fixed.

Change looks ok. What I can't grok is this sentence: what was checked
and fixed where?

What does need fixing and why?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
