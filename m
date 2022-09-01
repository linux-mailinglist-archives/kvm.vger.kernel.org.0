Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC835A9D7D
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbiIAQsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiIAQsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:48:21 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D1E98583
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:48:13 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-11f0fa892aeso24702636fac.7
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 09:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9MZCDyZSfCSBFopbfuyhtB/Vm05oHAYYuw+g8lPMMNE=;
        b=bGebJmMRwicYNWHXo5Y96sdD2A8z39jWg8gonOcPSFKNxhkRcmXde1chNRrwjiz4w8
         4fyBq5QmbDs9o97IZMKcZcsaqRYx2yY9Mk5Q8qgXqtC8nyrBNLzC8R7dIBoY3OEn5nsD
         5lAGqVfGade1EEgrxXjz4ShP3Wp8hsy5zjKC6HeEtq/0lyRwpk56B20GQV0vXisctUoq
         7SoLWaWrXrUqRzo6Cam5Yd5bQlbOXPg+77cOFmmcXMcwAob6uMVRrajDuKB1ybA+G4Lp
         UTogIwiew553jdLbKDmU7/KoJlAo8/FkXQfwf3cNkMh9naHlvE0G/2kCyETvymNusuDY
         9x6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9MZCDyZSfCSBFopbfuyhtB/Vm05oHAYYuw+g8lPMMNE=;
        b=4fz8+x4xf1oC02csU3p9m3tJLYs4ZazIsbxmKCxPMXiLwR5TAA3sIOdvMEggP62eNC
         S2XwG235SdXfrFyHZ63nkWQB85z7iDMgDKJEndf5vWgJVVR5sf0Bmn5FjePFjDtfQ8jS
         XRlq6UUpuy+xiNhbF9dtwRUqNVz2WyJseXZ2/1c8KaF208NrAGOzIwTlX8JyDNIj7McI
         0Nyteq/ZFT6MLlRpAybBM5Hf1XE1HhhmaQRr6t7TwsY5eVWc742rKbYAUKKSZ5UgX6la
         VixZgUmYjgvxeXDW03PhPeOx4vCcXY6CJUr3xgKDA4h+lUjNmPkDQAaBGim9BWLt+weV
         orag==
X-Gm-Message-State: ACgBeo1ELR25o+ITzMKPkRdJKAUjbAk5caSPpUn3n/RjBIIczt4JLrYG
        KmTqQtpPJJ6vHpo+PEnC8vJThhRi5hRDxNt3u1ghRw==
X-Google-Smtp-Source: AA6agR4Y527NOHcX3ZbLZPj5nM4EOO4PpAiDqTmvTjfXNuxL/jqo/kNvnPq6IlorOJeQudZSc863gungKsBbEHjtO2U=
X-Received: by 2002:a05:6808:656:b0:343:2783:7e62 with SMTP id
 z22-20020a056808065600b0034327837e62mr2399oih.297.1662050892165; Thu, 01 Sep
 2022 09:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com> <20220826231227.4096391-2-dmatlack@google.com>
 <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
In-Reply-To: <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 1 Sep 2022 09:47:46 -0700
Message-ID: <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Aug 30, 2022 at 3:12 AM Huang, Kai <kai.huang@intel.com> wrote:
>
> On Fri, 2022-08-26 at 16:12 -0700, David Matlack wrote:
> > Change tdp_mmu to a read-only parameter and drop the per-vm
> > tdp_mmu_enabled. For 32-bit KVM, make tdp_mmu_enabled a const bool so
> > that the compiler can continue omitting calls to the TDP MMU.
> >
> > The TDP MMU was introduced in 5.10 and has been enabled by default since
> > 5.15. At this point there are no known functionality gaps between the
> > TDP MMU and the shadow MMU, and the TDP MMU uses less memory and scales
> > better with the number of vCPUs. In other words, there is no good reason
> > to disable the TDP MMU on a live system.
> >
> > Do not drop tdp_mmu=N support (i.e. do not force 64-bit KVM to always
> > use the TDP MMU) since tdp_mmu=N is still used to get test coverage of
> > KVM's shadow MMU TDP support, which is used in 32-bit KVM.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  9 ------
> >  arch/x86/kvm/mmu.h              | 11 +++----
> >  arch/x86/kvm/mmu/mmu.c          | 54 ++++++++++++++++++++++-----------
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  9 ++----
> >  4 files changed, 44 insertions(+), 39 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 2c96c43c313a..d76059270a43 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1262,15 +1262,6 @@ struct kvm_arch {
> >       struct task_struct *nx_lpage_recovery_thread;
> >
> >  #ifdef CONFIG_X86_64
> > -     /*
> > -      * Whether the TDP MMU is enabled for this VM. This contains a
> > -      * snapshot of the TDP MMU module parameter from when the VM was
> > -      * created and remains unchanged for the life of the VM. If this is
> > -      * true, TDP MMU handler functions will run for various MMU
> > -      * operations.
> > -      */
> > -     bool tdp_mmu_enabled;
> > -
> >       /*
> >        * List of struct kvm_mmu_pages being used as roots.
> >        * All struct kvm_mmu_pages in the list should have
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 6bdaacb6faa0..dd014bece7f0 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -230,15 +230,14 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
> >  }
> >
> >  #ifdef CONFIG_X86_64
> > -static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
> > -#else
> > -static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
> > -#endif
> > -
> > +extern bool tdp_mmu_enabled;
> >  static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> >  {
> > -     return !is_tdp_mmu_enabled(kvm) || kvm_shadow_root_allocated(kvm);
> > +     return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
> >  }
> > +#else
> > +static inline bool kvm_memslots_have_rmaps(struct kvm *kvm) { return true; }
> > +#endif
> >
> >  static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
> >  {
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e418ef3ecfcb..7caf51023d47 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -98,6 +98,16 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> >   */
> >  bool tdp_enabled = false;
> >
> > +bool __read_mostly tdp_mmu_allowed;
>
> This can be __ro_after_init since it is only set in kvm_mmu_x86_module_init()
> which is tagged with __init.

Indeed, thanks.

>
> > +
> > +#ifdef CONFIG_X86_64
> > +bool __read_mostly tdp_mmu_enabled = true;
> > +module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
> > +#else
> > +/* TDP MMU is not supported on 32-bit KVM. */
> > +const bool tdp_mmu_enabled;
> > +#endif
> > +
>
> I am not sure by using 'const bool' the compile will always omit the function
> call?  I did some experiment on my 64-bit system and it seems if we don't use
> any -O option then the generated code still does function call.
>
> How about just (if it works):
>
>         #define tdp_mmu_enabled false

I can give it a try. By the way, I wonder if the existing code
compiles without -O. The existing code relies on a static inline
function returning false on 32-bit KVM, which doesn't seem like it
would be any easier for the compiler to optimize out than a const
bool. But who knows.

I considered biting the bullet and using conditional compilation
instead of relying on the compiler to optimize calls out, but I didn't
want to blow up the series.

>
> ?



>
> --
> Thanks,
> -Kai
>
>
