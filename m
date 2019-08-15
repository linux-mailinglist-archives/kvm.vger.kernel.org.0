Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2717A8F6F8
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733071AbfHOW3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 18:29:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34766 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfHOW3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 18:29:17 -0400
Received: by mail-io1-f68.google.com with SMTP id s21so2416908ioa.1
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 15:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ULp104tsvsKFZNXaoeE0ZQ3dEnDaoYPuoOhtlzPB234=;
        b=S9VjIK7QsFW6FBdr2df29pXKH/O6wbTFc4Y6CnXnpqCOZKAH6xi+RydGJGJrg+XObk
         40dhn/MDZ0ksbAV2v+lw9ugKBPXczHO4KVcvzC34HHMkodBCfv/0g2JBsfP/MrH7qtfb
         EXzyj9MaGfJzbe+7xbUvmOWko5/9U8qN8lMEGYIyRSxMNLoJEaYcNRWZTqH1rG82Meqg
         fO0ro6xFrMTZ9HgY8oNu3JdMfb2drJLnruS5OQr+9BKqUSwxDQBgXU4uBHSI3UxRHeOq
         KKORbj1SCa3+nEXyKBPxKRgIGSODHQiovikZAHP0DXCe1F04h5JQMJ+1B18nU/hRX7iY
         ReWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ULp104tsvsKFZNXaoeE0ZQ3dEnDaoYPuoOhtlzPB234=;
        b=bhSncc7ZkMatyPGoBpKSsTV1Oh35RgiXygCPkg8Dxs9YLePEvW7nlY9pHlQa0i+dIg
         oFk4PekrkaIgTBjw+J/1tlVTto4nOIU7D/h7QBOAdOOp5NeWvCdEp8W4NBfGC4zFuPxs
         DLaD3m/R2zG4tdqQ035VJ06+Utne06Wj3h3yXUKsfw281oJh9sNJDujyC75QukQ4jnmx
         jDr6wzWj73Fyg4VS+UOLl+GWdXWI+ygRkEhi/DK6tt+UV2N6mOmpqjB23PIfHS3jSdx2
         rT5Vz2yvfmLZGdwcWiQHK3b+5OnQTNzaH2RAgY26lgwOjb+TPzCynz0PhU3IUxJ5jx9o
         y5uQ==
X-Gm-Message-State: APjAAAUBx99mcAU4IxUwtd0thuydrXSFWi/u75tAnswYxOU13xnstMo9
        Am1SPphAUjC9rzRJTlS4C8fcrPMt7w0vOXMWJFpEcH4RiwLC0A==
X-Google-Smtp-Source: APXvYqygg16ytk4nPMtye6BCuMedAsBW0zRHWb69nJ1aaZf8TPQ42/cAX/6bJuKFR5mo4Oh3tiOoSawMF+7U5mciofs=
X-Received: by 2002:a02:a809:: with SMTP id f9mr1076783jaj.111.1565908155845;
 Thu, 15 Aug 2019 15:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-4-krish.sadhukhan@oracle.com> <20190513185746.GH28561@linux.intel.com>
In-Reply-To: <20190513185746.GH28561@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 15 Aug 2019 15:29:04 -0700
Message-ID: <CALMp9eQ5hrU3-KtS5GbKiyc-Hai7H=3r0RvhA8Fb8aQfWL8dCw@mail.gmail.com>
Subject: Re: [PATCH 3/8][KVM VMX]: Add a function to check reserved bits in MSR_CORE_PERF_GLOBAL_CTRL
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 11:57 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Apr 24, 2019 at 07:17:19PM -0400, Krish Sadhukhan wrote:
> > Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h  |  1 +
> >  arch/x86/include/asm/msr-index.h |  7 +++++++
> >  arch/x86/kvm/x86.c               | 20 ++++++++++++++++++++
> >  3 files changed, 28 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4660ce90de7f..c5b3c63129a6 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1311,6 +1311,7 @@ int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
> >
> >  void kvm_enable_efer_bits(u64);
> >  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> > +bool kvm_valid_perf_global_ctrl(u64 perf_global);
> >  int kvm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
> >  int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
> >
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index 8e40c2446fd1..d10e8d4b2842 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -775,6 +775,13 @@
> >  #define MSR_CORE_PERF_GLOBAL_CTRL    0x0000038f
> >  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL        0x00000390
> >
> > +/* MSR_CORE_PERF_GLOBAL_CTRL bits */
> > +#define      PERF_GLOBAL_CTRL_PMC0_ENABLE    (1ull << 0)
>
> BIT and BIT_ULL
>
> > +#define      PERF_GLOBAL_CTRL_PMC1_ENABLE    (1ull << 1)
> > +#define      PERF_GLOBAL_CTRL_FIXED0_ENABLE  (1ull << 32)
> > +#define      PERF_GLOBAL_CTRL_FIXED1_ENABLE  (1ull << 33)
> > +#define      PERF_GLOBAL_CTRL_FIXED2_ENABLE  (1ull << 34)
> > +
> >  /* Geode defined MSRs */
> >  #define MSR_GEODE_BUSCONT_CONF0              0x00001900
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 02c8e095a239..ecddb8baaa7f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -89,8 +89,19 @@ EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
> >  #ifdef CONFIG_X86_64
> >  static
> >  u64 __read_mostly efer_reserved_bits = ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
> > +static
> > +u64 __read_mostly perf_global_ctrl_reserved_bits =
> > +                             ~((u64)(PERF_GLOBAL_CTRL_PMC0_ENABLE    |
> > +                                     PERF_GLOBAL_CTRL_PMC1_ENABLE    |
> > +                                     PERF_GLOBAL_CTRL_FIXED0_ENABLE  |
> > +                                     PERF_GLOBAL_CTRL_FIXED1_ENABLE  |
> > +                                     PERF_GLOBAL_CTRL_FIXED2_ENABLE));
> >  #else
> >  static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
> > +static
>
> Why is static on a different line?
>
> > +u64 __read_mostly perf_global_ctrl_reserved_bits =
> > +                             ~((u64)(PERF_GLOBAL_CTRL_PMC0_ENABLE    |
> > +                                     PERF_GLOBAL_CTRL_PMC1_ENABLE));
>
> Why are the fixed bits reserved on a 32-bit build?
>
> >  #endif
> >
> >  #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
> > @@ -1255,6 +1266,15 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> >       return 0;
> >  }
> >
> > +bool kvm_valid_perf_global_ctrl(u64 perf_global)
> > +{
> > +     if (perf_global & perf_global_ctrl_reserved_bits)
>
> If the check were correct, this could be:
>
>         return !(perf_blobal & perf_global_ctrl_reserved_bits);
>
> But the check isn't correct, the number of counters is variable, i.e. the
> helper should query the guest's CPUID 0xA (ignoring for the moment the
> fact that this bypasses the PMU handling of guest vs. host ownership).

Aren't the reserved bits already easily calculated as
~pmu->global_ctrl_mask? Well, there's also bit 48, potentially, I
guess, but I don't think kvm virtualizes it.

Once we have this concept, shouldn't intel_pmu_set_msr() return
non-zero if an attempt is made to set a reserved bit of this MSR?

> > +             return false;
> > +
> > +     return true;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_valid_perf_global_ctrl);
> > +
> >  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  {
> >       if (efer & efer_reserved_bits)
> > --
> > 2.17.2
> >
