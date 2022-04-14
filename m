Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A88750188C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 18:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbiDNQXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 12:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347166AbiDNQJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 12:09:54 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9A0F9FBA
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:51:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s137so5106955pgs.5
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 08:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=528GGcT5AuLjlTi8kLrr8eu7nKa2Q0My6OrpHPfCZvA=;
        b=EWbqny0Pp93YFKhLpC9HjurNJEBnJu/IiR1ictMdTGdNxsCMPbekhaGAJHZFo6854D
         sTUz0E9PG8/4aCqXzd6e5m9xIknSuyKGaVI39k7wQup+5jVZnniFUu2Kuo/CKlsEd04k
         Y34LLML4cNd4U44GaF8ptP/ww7/3Agi3AhnLRjL2vL+PKs3xTqXhm25hcwrS5phGMdi6
         /9gTW9JE7U2HfOrs+Mr7RKQhe66kAxnIfBaA7GC83kQBx9J+GyZiujAHBFUjnbP/WqOS
         avSyNZZHZBQ5GpHl+A017y+mHcSx0QQaSHP+5rGLDN4KHFisMaGKgGjiM4JXCK3W6tpa
         IGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=528GGcT5AuLjlTi8kLrr8eu7nKa2Q0My6OrpHPfCZvA=;
        b=EW3um+jEcpIX9lkecQp3+d+G7U26wae9rePoG+lZ/DUMrR5JgyVTG6HhkxpnTTBXsf
         NMh3spg3Ve/My7qQGfR2KxUmUUPrgnOmCNwaIhsmHbJayhjAvXtW0hYyJUviPtYuxTu3
         ADdJPXPgce0hPW3alakzSKQOOoPxs68ixs15gQrO5eXMd4htbs5bATJ+ny+vD3PnNa0c
         ut+D4Gh4qAFqy21Fy5g84qkQYzSxsETu3ulriDZNpsfwcQgUPacTFG9fM+3RC82qNxOm
         hL7Sl2mWoQgS5sePDoTrA0dm7oyo9l3a3T1E19FTH0JEjqYtMAHFuqOcpIPSLXgcp5cN
         oshw==
X-Gm-Message-State: AOAM530tUOhW/e0eTFKjpphNOxSDsq5Y0Nj0MY14TwpZ59nCVez0vqJ7
        0SMLKJLJIIrLANXlyhkZHue8qA==
X-Google-Smtp-Source: ABdhPJzK6IWgENAWqUpuayzeQ0Ry7DOQhMd2mRcARy4VtSmd0Ni8fcUdG/deU1VWXaPUnB9HOk8w3A==
X-Received: by 2002:a05:6a00:b89:b0:505:dead:db1d with SMTP id g9-20020a056a000b8900b00505deaddb1dmr4598474pfj.74.1649951479140;
        Thu, 14 Apr 2022 08:51:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm302572pfc.190.2022.04.14.08.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:51:18 -0700 (PDT)
Date:   Thu, 14 Apr 2022 15:51:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH V3 2/4] KVM: X86: Introduce role.glevel for level
 expanded pagetable
Message-ID: <YlhC86CFDRghdd5v@google.com>
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
 <20220330132152.4568-3-jiangshanlai@gmail.com>
 <YlXvtMqWpyM9Bjox@google.com>
 <caffa434-5644-ee73-1636-45a87517bae2@redhat.com>
 <YlbhVov4cvM26FnC@google.com>
 <d2122fb0-7327-0490-9077-c69bbfba4830@redhat.com>
 <YlbtEorfabzkRucF@google.com>
 <e549d4c4-ca56-da1d-cc50-1a73621ba487@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e549d4c4-ca56-da1d-cc50-1a73621ba487@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022, Paolo Bonzini wrote:
> On 4/13/22 17:32, Sean Christopherson wrote:
> > > > Are we planning on removing direct?
> > > 
> > > I think so, it's redundant and the code almost always checks
> > > direct||passthrough (which would be passthrough_delta > 0 with your scheme).
> > 
> > I'm ok dropping direct and rolling it into target_level, just so long as we add
> > helpers, e.g. IIUC they would be
> > 
> > static inline bool is_sp_direct(...)
> > {
> > 	return !sp->role.target_level;
> > }
> > 
> > static inline bool is_sp_direct_or_passthrough(...)
> > {
> > 	return sp->role.target_level != sp->role.level;
> > }
> 
> Yes of course.  Or respectively:
> 
> 	return sp->role.passthrough_levels == s->role.level;
> 
> 	return sp->role.passthrough_levels > 0;
> 
> I'm not sure about a more concise name for the latter.  Maybe
> sp_has_gpt(...) but I haven't thought it through very much.
> 
> > > > Hmm, it's not a raw level though.
> > > 
> > > Hence the plural. :)
> > 
> > LOL, I honestly thought that was a typo.  Making it plural sounds like it's passing
> > through to multiple levels.
> 
> I meant it as number of levels being passed through.  I'll leave that to
> Jiangshan, either target_level or passthrough_levels will do for me.

It took me until like 9pm last night to finally understand what you meant by
"passthrough level".   Now that I actually have my head wrapped around this...

Stepping back, "glevel" and any of its derivations is actually just a combination
of CR0.PG, CR4.PAE, EFER.LMA, and CR4.LA57.  And "has_4_byte_gpte" is CR0.PG && !CR4.PAE.
When running with !tdp_enabled, CR0.PG is tracked by "direct".  And with TDP enabled,
CR0.PG is either a don't care (L1 or nested EPT), or is guaranteed to be '1' (nested NPT).

So, rather than add yet more synthetic information to the role, what about using
the info we already have?  I don't think it changes the number of bits that need to
be stored, but I think the result would be easier for people to understand, at
least superficially, e.g. "oh, the mode matters, got it".  We'd need a beefy comment
to explain the whole "passthrough levels" thing, but I think it the code would be
more approachable for most people.

If we move efer_lma and cr4_la57 from kvm_mmu_extended_role to kvm_mmu_page_role,
and rename has_4_byte_gpte to cr4_pae, then we don't need passthrough_levels.
If needed for performance, we could still have a "passthrough" bit, but otherwise
detecting a passthrough SP would be

static inline bool is_passthrough_sp(struct kvm_mmu_page *sp)
{
	return !sp->role.direct && sp->role.level > role_to_root_level(sp->role);
}

where role_to_root_level() is extracted from kvm_calc_cpu_role() is Paolo's series.

Or, if we wanted to optimize "is passthrough", then cr4_la57 could be left in
the extended role, because passthrough is guaranteed to be '0' if CR4.LA57=1.

That would prevent reusing shadow pages between 64-bit paging and PAE paging, but
in practice no sane guest is going to reuse page tables between those mode, so who
cares.
