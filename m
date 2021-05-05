Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B6737471D
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 19:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbhEERot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 13:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbhEERnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 13:43:02 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C35FC061239
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 10:16:30 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b3so1447336plg.11
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 10:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djopts1q8PI7dAtaZWUrixZ53WdtxNRvva94X6xpEM4=;
        b=qAnluIIk5pJoFiatt3fpnimjfRk0bcjHgK1esvazYLdeIzN8euobrodONTAQdO2Id4
         hkOyLN+a+duFpYU8XlaLMWmp8ndGrkxrDuXW/P1GriLtflkEShfKb8jzGz8PWzJSX5Go
         47TjqfpipXdsNPqhRZb2H1rocmp61I1oclaAfLAih9UZE8qqgnQ5dBNPI7bGgCwReUa5
         M62Z2d+0C8Ihit91ZeOQTj79MVzs65GLy73BebTDQiSyWwPwh5CuGCLOLZX2ZckxDjd9
         uGZ+x1jxOrLeVpbalCEQmp9AZR8LxMsNGvF8VQ8Wg3OY1ny25PsnwF9R9060PXfR6sTr
         364w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djopts1q8PI7dAtaZWUrixZ53WdtxNRvva94X6xpEM4=;
        b=h9SWK5z9MOVZJF/me2W49daiudjrXVuWoUsBGB6NGApntkqvRmwe7MU462CMai1ICL
         KbEK2fKXGeLq2S2OVjt0SRgJMgJuCOfPz9f+hCTplefl5S6g4IA3NiI2+c6WdeUzzz3u
         7SDmyMRg3JIfOb0kdG3TZuaAwNWQvyJYSqrXEHc6TsE4J0nGRmrqru/5sNZVSylplZpE
         kI0DzautsCutKdF1Sj0gVNKu7urhkURjyPm1VE/AlAJDJ4yHJwZxWvbvXyeXI01c9kys
         4C0OuSJBlbRMJJl0V99eLWgs5lVJSN46x8dAbwpRBfs5fUJ7TYdWpPbiWr8u2L6ohk7w
         Bigw==
X-Gm-Message-State: AOAM532q2WdYE0DC8fJ1cfdPjSG/Uc4CDRRtchjKnR658BSXxaBeFyHM
        s0skHDfdv0n4p4r8PC7GfxrQSA==
X-Google-Smtp-Source: ABdhPJzArqnv9ckJap9AexsIlR7ru87wSes2kWWt48Cwc8KcgpIzitNTK3oIoM+1QeX7sIQzcswsPA==
X-Received: by 2002:a17:90b:2307:: with SMTP id mt7mr12086389pjb.131.1620234989950;
        Wed, 05 May 2021 10:16:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k13sm15008833pfc.50.2021.05.05.10.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:16:29 -0700 (PDT)
Date:   Wed, 5 May 2021 17:16:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
Message-ID: <YJLS6cUghgktsMNJ@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
 <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
 <YJLH4Iyz4imfY0c2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJLH4Iyz4imfY0c2@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021, Sean Christopherson wrote:
> On Wed, May 05, 2021, Kai Huang wrote:
> > Currently pf_fixed is increased even when page fault requires emulation,
> > or fault is spurious.  Fix by only increasing it when return value is
> > RET_PF_FIXED.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 1cad4c9f7c34..debe8c3ec844 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -942,7 +942,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
> >  				       rcu_dereference(iter->sptep));
> >  	}
> >  
> > -	if (!prefault)
> > +	if (!prefault && ret == RET_PF_FIXED)
> >  		vcpu->stat.pf_fixed++;
> For RET_PF_EMULATE, I could go either way.  On one hand, KVM is installing a
> translation that accelerates future emulated MMIO, so it's kinda sorta fixing
> the page fault.  On the other handle, future emulated MMIO still page faults, it
> just gets handled without going through the full page fault handler.

Hrm, the other RET_PF_EMULATE case is when KVM creates a _new_ SPTE to handle a
page fault, but installs a read-only SPTE on a write fault because the page is
marked for write access tracking, e.g. for non-leaf guest page tables.  Bumping
pf_fixed is arguably correct in that case since KVM did fault in a page and from
the guest's perspective the page fault was fixed, it's just that "fixing" the
fault involved a bit of instruction emulation.

> If we do decide to omit RET_PF_EMULATE, it should be a separate patch and should
> be done for all flavors of MMU.  For this patch, the correct code is:
> 
> 	if (ret != RET_PF_SPURIOUS)
> 		vcpu->stat.pf_fixed++;
> 
> which works because "ret" cannot be RET_PF_RETRY.
> 
> Looking through the other code, KVM also fails to bump stat.pf_fixed in the fast
> page fault case.  So, if we decide to fix/adjust RET_PF_EMULATE, I think it would
> make sense to handle stat.pf_fixed in a common location.

Blech.  My original thought was to move the stat.pf_fixed logic all the way out
to kvm_mmu_do_page_fault(), but that would do the wrong thing if pf_fixed is
bumped on RET_PF_EMULATE and page_fault_handle_page_track() returns RET_PF_EMULATE.
That fast path handles the case where the guest gets a !WRITABLE page fault on
an PRESENT SPTE that KVM is write tracking.  *sigh*.

I'm leaning towards making RET_PF_EMULATE a modifier instead of a standalone
type, which would allow more precise pf_fixed adjustments and would also let us
clean up the EMULTYPE_ALLOW_RETRY_PF logic, which has a rather gross check for
detecting MMIO page faults.

> The legacy MMU also prefetches on RET_PF_EMULATE, which isn't technically wrong,
> but it's pretty much guaranteed to be a waste of time since prefetching only
> installs SPTEs if there is a backing memslot and PFN.
> 
> Kai, if it's ok with you, I'll fold the above "ret != RET_PF_SPURIOUS" change
> into a separate mini-series to address the other issues I pointed out.  I was
> hoping I could paste patches for them inline and let you carry them, but moving
> stat.pf_fixed handling to a common location requires additional code shuffling
> because of async page faults :-/

Cancel that idea, given the twisty mess of RET_PF_EMULATE it's probably best for
you to just send a new version of your patch to make the TDP MMU pf_fixed behavior
match the legacy MMU.  It doesn't make sense to hold up a trivial fix just so I
can scratch a refactoring itch :-)
