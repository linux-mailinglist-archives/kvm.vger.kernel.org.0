Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF069B00C
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjBQQAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBQQAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:00:13 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5ED68AEC
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:00:10 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id cl6-20020a056a0032c600b0058d9b9fecb6so654539pfb.1
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+ASrBAOfhB8V2b1UWnVkBSljvQtym3PPwSnuFL8RngU=;
        b=sUkblHuJ9dulsxh4CZcm+FIp/qRpAAcmRtfvp6ULnSXppIvCitchjm1OUit+QXJRWj
         fwJ7Xd7LeD3Frj7FzM+U/mMAyXTZ8R5RK0CcMGNMR8PLROcI0/4xgADL5vqH5U+/VYgG
         dkLQqFX5fKeKJhpV5Gz8z+39KNbu/jjFTFfYD8mmFsM5kC/nK+Gp9BDhC26xn+icV0pC
         bHQSk7Mqvc6fB6p4dz8MrdQupt1NEggpWvfcZBir6hbXow/Kay6VqXDNaQVda+8NmyZ/
         DJpPCojT4dj2fTwoDxf+msJ00C5RYvwVAx1bbgonDLlmp6LfYVABRQ30VMxJGXDgaHEA
         nfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+ASrBAOfhB8V2b1UWnVkBSljvQtym3PPwSnuFL8RngU=;
        b=mRaOekJLWcdyBG440QVWmdBOV8LuU9sGwLRsMcV+jTrSNzWJRMc0dzQjXBRgF2PYdm
         6LrumJX9XNoGRDxdE6HAZq8NnCQyPUEX5fafXn6N/9zFbV/DQ5t/gegcQ0K9nQZJEwtj
         3MLNhbYL/X++Q6UBDrtiKpep5ODRdbVS4AwGS8KrxrBE2m27zfb2pNx9ygNN7HW3EYHA
         VR5LBdNfTgwHq7apX6xZyRuBgZfQrNZki8O7Izwiqngg+AhOw0m5cXzFPLwJGemAOfgG
         3oW6kGabFaUSJIjQfuCFyw9Kpie7/HBmL4eN4QDT01bV8N+oinEnEwx2P1+958/LLNq/
         7CLg==
X-Gm-Message-State: AO0yUKWCJpuXrZz8IrZYAdTV80ah2Ch92xe5ALL277QMoDa2XKPeKfDv
        5Pi4IHIYTTXY4swcLjWlGyRjnop2KrY=
X-Google-Smtp-Source: AK7set/TQ5moWaaNQcL8V8kGjN9B7zl+2zJIJ8kumCX3x4I/RGgInnGSIHRIAYNv9fJ3WTWtfSDyzLo0yfI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:43:b0:4fd:72f3:5859 with SMTP id
 az3-20020a056a02004300b004fd72f35859mr296462pgb.2.1676649609963; Fri, 17 Feb
 2023 08:00:09 -0800 (PST)
Date:   Fri, 17 Feb 2023 08:00:08 -0800
In-Reply-To: <Y+9EUeUIS/ZUe2vw@linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
 <Y+9EUeUIS/ZUe2vw@linux.dev>
Message-ID: <Y++kiJwUIh55jkvl@google.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Yu Zhao <yuzhao@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Oliver Upton wrote:
> Hi Yu,
> 
> scripts/get_maintainers.pl is your friend for getting the right set of
> emails for a series :) Don't know about others, but generally I would
> prefer to be Cc'ed on an entire series (to gather context) than just an
> individual patch.

+1

> 
> On Thu, Feb 16, 2023 at 09:12:28PM -0700, Yu Zhao wrote:
> > This patch adds kvm_arch_test_clear_young() for the vast majority of
> > VMs that are not pKVM and run on hardware that sets the accessed bit
> > in KVM page tables.

At least for the x86 changes, please read Documentation/process/maintainer-tip.rst
and rewrite the changelogs.

> > It relies on two techniques, RCU and cmpxchg, to safely test and clear
> > the accessed bit without taking the MMU lock. The former protects KVM
> > page tables from being freed while the latter clears the accessed bit
> > atomically against both the hardware and other software page table
> > walkers.
> > 
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       |  7 +++
> >  arch/arm64/include/asm/kvm_pgtable.h    |  8 +++
> >  arch/arm64/include/asm/stage2_pgtable.h | 43 ++++++++++++++
> >  arch/arm64/kvm/arm.c                    |  1 +
> >  arch/arm64/kvm/hyp/pgtable.c            | 51 ++--------------
> >  arch/arm64/kvm/mmu.c                    | 77 ++++++++++++++++++++++++-
> >  6 files changed, 141 insertions(+), 46 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 35a159d131b5..572bcd321586 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1031,4 +1031,11 @@ static inline void kvm_hyp_reserve(void) { }
> >  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
> >  
> > +/* see the comments on the generic kvm_arch_has_test_clear_young() */

Please eliminate all of these "see the comments on blah", in every case they do
nothing more than redirect the reader to something they're likely already aware of.

> > +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> > +static inline bool kvm_arch_has_test_clear_young(void)
> > +{
> > +	return IS_ENABLED(CONFIG_KVM) && cpu_has_hw_af() && !is_protected_kvm_enabled();
> > +}

...

> Also, I'm at a loss for why we'd need to test if CONFIG_KVM is enabled.
> My expectation is that we should provide an implementation that returns
> false if !CONFIG_KVM, avoiding the need to repeat that bit in every
> single implementation of the function.

mm/vmscan.c uses kvm_arch_has_test_clear_young().  I have opinions on that, but
I'll hold off on expressing them until there's actual justification presented
somewhere.

Yu, this series and each patch needs a big pile of "why".  I get that the goal
is to optimize memory oversubscribe, but there needs to be justification for
why this is KVM only, why nested VMs and !A/D hardware are out of scope, why yet
another mmu_notifier hook is being added, etc.
