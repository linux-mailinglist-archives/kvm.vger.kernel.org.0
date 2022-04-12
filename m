Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02B94FC959
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 02:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiDLAly (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 20:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiDLAlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 20:41:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCF5AE71
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 17:39:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d15so15302347pll.10
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 17:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mmFuKKRZ4tQMbPoZWaUuE8327F93ewiEqGBPPN/nLVY=;
        b=EMK7j5B7n5pQHK3FyLq7YyWGgFSlF/QN2gKNib8LuwqV3H4CHnr5HLDvawUg7hl1bO
         3lhhsipQkMOOg88/x28n8Ia1RpTQt87HWUEub4QEuibgxNcDg77jWWyMJbq/oWtC3Pzq
         PRxdzrsSHQIOlJIqDzs/bKuDqxQ5mxHp39ipW8TlIxU1FLZ3fUbW70VPU5f44hnBX9CR
         cENzfMnSTGI69mpYN/6QhAXp+rI/WxHbbhvnBlZA8xx1MvWBDbgbtW37sqjKIRlNz6j/
         9uJhitJnbSEcuwanOxujCj6COUEKis5TbuRhG45vq2tEyDbII9YJrCRLJFG0q7kEE5hs
         fwZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mmFuKKRZ4tQMbPoZWaUuE8327F93ewiEqGBPPN/nLVY=;
        b=Ytlx/ZcjYC11ljtVEJX+szmgpHqCrzuWh+tKX8qc5gun70DBcY0EnOQ24t2qDzsExf
         LF/a/u/lzObESD6cme/mSmTfDgPfH1V9sy8v96e31IbwUT7d1hWYcr4Vsdpj6MKqmWHu
         dVy/g+FkwBcTkA0YkCvpDi1PhdD3ma3myvPIPIAE7nkr38k72XhOtE8vz2r8FqHEdirj
         xR4DMbhpN+L93eX+ngJsKT/6MjuKHQQT0wSIzfd5EIYxKSoAvyD9pQmfXyfMjSjPUOOz
         cAusHq3+ne34dY9NmXtSEnQzZTErDJpJg0KO0NTEeKpEPnY/+EjF73i9LMiBbFN3kkIG
         MHxQ==
X-Gm-Message-State: AOAM530iOOXnlSxkLL2RuvYOuxeIoC+8s1cBTxL3nLB08nLzJ/GT8E/P
        Z+HO+5ihOAz2aDkjKaxsGggIkw==
X-Google-Smtp-Source: ABdhPJzVnnK+Llaw/lDsRSwluGntj0Ck+RPpEEoRbDuil9Q/E1ruBpSOsEq6vjD4X/iago6TZSmWVA==
X-Received: by 2002:a17:902:ccd0:b0:156:7ac2:5600 with SMTP id z16-20020a170902ccd000b001567ac25600mr35257168ple.156.1649723975653;
        Mon, 11 Apr 2022 17:39:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z24-20020aa79f98000000b0050564c90916sm16756466pfr.200.2022.04.11.17.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 17:39:34 -0700 (PDT)
Date:   Tue, 12 Apr 2022 00:39:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3 00/23] KVM: Extend Eager Page Splitting to the shadow
 MMU
Message-ID: <YlTKQz8HVPtyfwKe@google.com>
References: <20220401175554.1931568-1-dmatlack@google.com>
 <YlRhiF1O71TWQr5r@google.com>
 <CALzav=f_WY7xH_MV8-gJPAVmj1KjE_LvXupL7aA5n-vCjTETNw@mail.gmail.com>
 <YlSLuZphElMyF2sG@google.com>
 <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=fGucZOZjbVE2+9PZVf1p+jP7GBYDpPph5PoU552LELsw@mail.gmail.com>
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

On Mon, Apr 11, 2022, David Matlack wrote:
> On Mon, Apr 11, 2022 at 1:12 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Apr 11, 2022, David Matlack wrote:
> > > On Mon, Apr 11, 2022 at 10:12 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > Circling back to eager page splitting, this series could be reworked to take the
> > > > first step of forking FNAME(page_fault), FNAME(fetch) and kvm_mmu_get_page() in
> > > > order to provide the necessary path for reworking nested MMU page faults.  Then it
> > > > can remove unsync and shrinker support for nested MMUs.  With those gone,
> > > > dissecting the nested MMU variant of kvm_mmu_get_page() should be simpler/cleaner
> > > > than dealing with the existing kvm_mmu_get_page(), i.e. should eliminate at least
> > > > some of the complexity/churn.
> > >
> > > These sound like useful improvements but I am not really seeing the
> > > value of sequencing them before this series:
> > >
> > >  - IMO the "churn" in patches 1-14 are a net improvement to the
> > > existing code. They improve readability by decomposing the shadow page
> > > creation path into smaller functions with better names, reduce the
> > > amount of redundant calculations, and reduce the dependence on struct
> > > kvm_vcpu where it is not needed. Even if eager page splitting is
> > > completely dropped I think they would be useful to merge.
> >
> > I definitely like some of patches 1-14, probably most after a few read throughs.
> > But there are key parts that I do not like that are motivated almost entirely by
> > the desire to support page splitting.  Specifically, I don't like splitting the
> > logic of finding a page, and I don't like having a separate alloc vs. initializer
> > (though I'm guessing this will be needed somewhere to split huge pages for nested
> > MMUs).
> >
> > E.g. I'd prefer the "get" flow look like the below (completely untested, for
> > discussion purposes only).  There's still churn, but the core loop is almost
> > entirely unchanged.
> >
> > And it's not just this series, I don't want future improvements nested TDP to have
> > to deal with the legacy baggage.
> 
> One thing that would be helpful is if you can explain in a bit more
> specifically what you'd like to see. Part of the reason why I prefer
> to sequence your proposal after eager page splitting is that I do not
> fully understand what you're proposing, and how complex it would be.
> e.g. Forking FNAME(fetch), FNAME(page_fault), and kvm_mmu_get_page()
> for nested MMUs does not sound like less churn.

Oh, it's most definitely not less code, and probably more churn.  But, it's churn
that pushes us in a more favorable direction and that is desirable long term.  I
don't mind churning code, but I want the churn to make future life easier, not
harder.  Details below.

> From my perspective, this series is a net improvement to the
> readability and maintainability of existing code, while adding a
> performance improvement (eager page splitting). All of the changes you
> are proposing can still be implemented on top if

They can be implemented on top, but I want to avoid inhireting complexity we
don't actually want/need, unsync support being the most notable.

What I mean by "fork" is that after the cleanups that make sense irrespective of
eager page splitting, we make a copy of FNAME(page_fault) and add FNAME(get_shadow_page),
extracting common logic where we can and probably doing something fancy to avoid
having multiple copies of FNAME(get_shadow_page).  Looking again at the code, it's
probably best to keep FNAME(fetch), at least for now, as it's only the single unsync
check that we can purge at this point.

That gives us e.g. FNAME(nested_page_fault) that support EPT and 64-bit NPT, and
a nested TDP specific get_shadow_page().

Then we rip out the unsync stuff for nested MMUs, which is quite clean because we
can key off of tdp_enabled.  It'll leave dead code for 32-bit hosts running nested
VMs, but I highly doubt anyone will notice the perf hit.

At that point, dissect kvm_nested_mmu_get_page() for eager page splitting and
continue on.

It's not drastically different than what you have now, but it avoids the nastiness
around unsync pages, e.g. I'm pretty sure kvm_mmu_alloc_shadow_page() can be reused
as I proposed and the "find" becomes something like:

static struct kvm_mmu_page *kvm_mmu_nested_tdp_find_sp(struct kvm_vcpu *vcpu,
						       gfn_t gfn,
						       unsigned int gfn_hash,
						       union kvm_mmu_page_role role)
{
	struct hlist_head *sp_list = &kvm->arch.mmu_page_hash[gfn_hash];
	struct kvm_mmu_page *sp;

	for_each_valid_sp(kvm, sp, sp_list) {
		if (sp->gfn != gfn || sp->role.word != role.word)
			continue;

		__clear_sp_write_flooding_count(sp);
		return sp;
	}

	return NULL;
}

Having the separate page fault and get_shadow_page(), without the baggage of unsync
in particular, sets us up for switching to taking mmu_lock for read, and in the
distant future, implementing whatever new scheme someone concocts for shadowing
nested TDP.
