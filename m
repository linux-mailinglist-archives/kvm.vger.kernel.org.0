Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA7DB6A6F
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfIRSWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:22:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34476 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388440AbfIRSWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:22:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id a11so458344wrx.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 11:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lwLjjSOFnFtFhwq+T5a2m8HgG5NATwpKVIe+a7iFG5M=;
        b=jZRZFWWGkd+dY7aiBB1zZmPYtxLiGcU0wgY9q0Tv8YZpigB+X25JjJyd83NwgMKwvt
         p4a89nOeqSUeNpIxv9swcyz/8c8lKVRxeWm4EgY6zZSnpg7V4TbE6OcMENgP+5g+F8VE
         m61oaqYFZDg1MDdfrihsGj6cVylhhS5Kz81K0DSQCssNIWBj+Q2t+sxyVb6bydBFRiTL
         tVwdsiZO5hIsaMTyHQyqRyuWsFwkgkv7QkvZe/kdm3ozsNUq7VoGfCHJjUYdDt5moFoI
         IvST339KAhubGjIP3ua+TxtNi6d4J2N0MVy3gzJNMz2Jk24FEbUBxyq8zdqUniqv6r0K
         q8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lwLjjSOFnFtFhwq+T5a2m8HgG5NATwpKVIe+a7iFG5M=;
        b=PJxnW99srMZ2doeNPaAE/HuaTMO/y/FiatQms71T8W0Oj28j79dLNrU5I8EGTkGL4c
         9btscjAhvoOApY1mzm5HqnhIP/yGJorOl+HIt/EFAo7wVIoNPjFX8mqEGpsRl83XAh6Q
         QiD60nb0AoCiSWy5Dhdrd+sS/DDx+mKgRJIQcoGEWk8OHf2xrABWFkaHSH0XZ+rIMnfY
         aI68j4DsBNqCDiltXtxceDBWepcUo9ObUu1Dss5mNFxl9MRJVtnM07GYYd9UHnW/Bbks
         lQLhG+o+mMk85y+bQjsequiPCc/9svK2zeTbuxdFQyZ2Kd/ni28nYdcAlZCqE58p94tI
         Ppjg==
X-Gm-Message-State: APjAAAUeuESwvRHTWCPme/FrbyUkXC0ofxFSG8F0kkMXXkyPFeVWKg/Q
        AMyjM3Zh2regXcczhGxVgC4fab7ulrb5UX8W8e1V2j4YDOl6yg==
X-Google-Smtp-Source: APXvYqyVCnSQh+N1Ls872JZwFgcA9wRadzjeMDwFZHgIlJMwBPIKzphns+crcUH5JFYO5d0PlbStwP8TDMdhvw/xHjs=
X-Received: by 2002:a5d:428c:: with SMTP id k12mr4209833wrq.196.1568830950650;
 Wed, 18 Sep 2019 11:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190912232753.85969-1-jmattson@google.com> <20190918174308.GC14850@linux.intel.com>
In-Reply-To: <20190918174308.GC14850@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Sep 2019 11:22:18 -0700
Message-ID: <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 18, 2019 at 10:43 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, Sep 12, 2019 at 04:27:53PM -0700, Jim Mattson wrote:
> > If these CPUID leaves are implemented, the EDX output is always the
> > x2APIC ID, regardless of the ECX input. Furthermore, the low byte of
> > the ECX output is always identical to the low byte of the ECX input.
> >
> > KVM's CPUID emulation doesn't report the correct ECX and EDX outputs
> > when the ECX input is greater than the first subleaf for which the
> > "level type" is zero. This is probably only significant in the case of
> > the x2APIC ID, which should be the result of CPUID(EAX=0BH):EDX or
> > CPUID(EAX=1FH):EDX, without even setting a particular ECX input value.
>
> At a glance, shouldn't leaf 0x1f be marked significant in do_host_cpuid()?

Indeed. See my previous post, "[PATCH] kvm: x86: Add "significant
index" flag to a few CPUID leaves."

> > Create a "wildcard" kvm_cpuid_entry2 for leaves 0BH and 1FH in
> > response to the KVM_GET_SUPPORTED_CPUID ioctl. This entry does not
> > have the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag, so it matches all
> > subleaves for which there isn't a prior explicit index match.
> >
> > Add a new KVM_CPUID flag that is only applicable to leaves 0BH and
> > 1FH: KVM_CPUID_FLAG_CL_IS_PASSTHROUGH. When KVM's CPUID emulation
> > encounters this flag, it will fix up ECX[7:0] in the CPUID output. Add
> > this flag to the aforementioned "wildcard" kvm_cpuid_entry2.
> >
> > Note that userspace is still responsible for setting EDX to the x2APIC
> > ID of the vCPU in each of these structures, *including* the wildcard.
> >
> > Qemu doesn't pass the flags from KVM_GET_SUPPORTED_CPUID to
> > KVM_SET_CPUID2, so it will have to be modified to take advantage of
> > these changes. Note that passing the new flag to older kernels will
> > have no effect.
> >
> > Unfortunately, the new flag bit was not previously reserved, so it is
> > possible that a userspace agent that already sets this bit will be
> > unhappy with the new behavior. Technically, I suppose, this should be
> > implemented as a new set of ioctls. Posting as an RFC to get comments
> > on the API breakage.
> >
> > Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
> > Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > Reviewed-by: Jacob Xu <jacobhxu@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > Change-Id: I6b422427f78b530106af3f929518363895367e25
> > ---
> >  Documentation/virt/kvm/api.txt  |  6 +++++
> >  arch/x86/include/uapi/asm/kvm.h |  1 +
> >  arch/x86/kvm/cpuid.c            | 39 +++++++++++++++++++++++++++------
> >  3 files changed, 39 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index 2d067767b6170..be5cc42ad35f4 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -1396,6 +1396,7 @@ struct kvm_cpuid2 {
> >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              BIT(0)
> >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         BIT(1)
> >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               BIT(2)
> > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     BIT(3)
> >
> >  struct kvm_cpuid_entry2 {
> >       __u32 function;
> > @@ -1447,6 +1448,8 @@ emulate them efficiently. The fields in each entry are defined as follows:
> >          KVM_CPUID_FLAG_STATE_READ_NEXT:
> >             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> >             the first entry to be read by a cpu
> > +     KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> > +        If the output value of ECX[7:0] matches the input value of ECX[7:0]
> >     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
> >           this function/index combination
> >
> > @@ -2992,6 +2995,7 @@ The member 'flags' is used for passing flags from userspace.
> >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              BIT(0)
> >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         BIT(1)
> >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               BIT(2)
> > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     BIT(3)
> >
> >  struct kvm_cpuid_entry2 {
> >       __u32 function;
> > @@ -3040,6 +3044,8 @@ The fields in each entry are defined as follows:
> >          KVM_CPUID_FLAG_STATE_READ_NEXT:
> >             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> >             the first entry to be read by a cpu
> > +     KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> > +        If the output value of ECX[7:0] matches the input value of ECX[7:0]
> >     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
> >           this function/index combination
> >
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 503d3f42da167..3b67d21123946 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -223,6 +223,7 @@ struct kvm_cpuid_entry2 {
> >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              (1 << 0)
> >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         (1 << 1)
> >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               (1 << 2)
> > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     (1 << 3)
> >
> >  /* for KVM_SET_CPUID2 */
> >  struct kvm_cpuid2 {
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index e7d25f4364664..280a796159cb2 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -612,19 +612,41 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >        */
> >       case 0x1f:
> >       case 0xb: {
> > -             int i, level_type;
> > +             int i;
> >
> > -             /* read more entries until level_type is zero */
> > -             for (i = 1; ; ++i) {
> > +             /*
> > +              * We filled in entry[0] for CPUID(EAX=<function>,
> > +              * ECX=00H) above.  If its level type (ECX[15:8]) is
> > +              * zero, then the leaf is unimplemented, and we're
> > +              * done.  Otherwise, continue to populate entries
> > +              * until the level type (ECX[15:8]) of the previously
> > +              * added entry is zero.
> > +              */
> > +             for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
> >                       if (*nent >= maxnent)
> >                               goto out;
> >
> > -                     level_type = entry[i - 1].ecx & 0xff00;
> > -                     if (!level_type)
> > -                             break;
> >                       do_host_cpuid(&entry[i], function, i);
> >                       ++*nent;
> >               }
>
> This should be a standalone bugfix/enhancement path.  Bugfix because it
> eliminates a false positive on *nent >= maxnent.

Sure.

> > +
> > +             if (i > 1) {
> > +                     /*
> > +                      * If this leaf has multiple entries, treat
> > +                      * the final entry as a "wildcard." Clear the
> > +                      * "significant index" flag so that the index
> > +                      * will be ignored when we later look for an
> > +                      * entry that matches a CPUID
> > +                      * invocation. Since this entry will now match
> > +                      * CPUID(EAX=<function>, ECX=<index>) for any
> > +                      * <index> >= (i - 1), set the "CL
> > +                      * passthrough" flag to ensure that ECX[7:0]
> > +                      * will be set to (<index> & 0xff), per the SDM.
> > +                      */
> > +                     entry[i - 1].flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>
> If I'm reading the code correctly, this is fragile and subtle.  The order
> of cpuid entries is controlled by userspace, which means that clearing
> KVM_CPUID_FLAG_SIGNIFCANT_INDEX depends on this entry being kept after all
> other entries for this function.  In practice I'm guessing userspaces
> naturally sort entries with the same function by ascending index, but it
> seems like avoidable issue.

Though not documented, the CPUID leaf matching code has always
depended on ordering.

> Also, won't matching the last entry generate the wrong values for EAX, EBX
> and ECX, i.e. the valid values for the last index instead of zeroes?

This entry has CH==0. According to the SDM, "For sub-leaves that
return an invalid level-type of 0 in ECX[15:8]; EAX and EBX will
return 0."
ECX[7:0] will be wrong, but that's fixed up by the flag below.
ECX[31:16] are reserved and perhaps should be cleared here, but I'm
not sure how I would interpret it if those bits started being non-zero
for the first leaf with CH==0.

> > +                     entry[i - 1].flags |= KVM_CPUID_FLAG_CL_IS_PASSTHROUGH;
>
> Lastly, do we actually need to enumerate this silliness to userspace?
> What if we handle this as a one-off case in CPUID emulation and avoid the
> ABI breakage that way?  E.g.:
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index dd5985eb61b4..aaf5cdcb88c9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1001,6 +1001,16 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>         }
>
>  out:
> +       if (!best && (function == 0xb || function == 0x1f)) {
> +               best = check_cpuid_limit(vcpu, function, 0);
> +               if (best) {
> +                       *eax = 0;
> +                       *ebx = 0;
> +                       *ecx &= 0xff;
> +                       *edx = *best->edx;
> +               }
> +       }
> +

Aside from the fact that one should never call check_cpuid_limit on
AMD systems (they don't do the "last basic leaf" nonsense), an
approach like this should work.

>         if (best) {
>                 *eax = best->eax;
>                 *ebx = best->ebx;
>
> > +             }
> > +
> >               break;
> >       }
> >       case 0xd: {
> > @@ -1001,8 +1023,11 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >               *ebx = best->ebx;
> >               *ecx = best->ecx;
> >               *edx = best->edx;
> > -     } else
> > +             if (best->flags & KVM_CPUID_FLAG_CL_IS_PASSTHROUGH)
> > +                     *ecx = (*ecx & ~0xff) | (index & 0xff);
> > +     } else {
> >               *eax = *ebx = *ecx = *edx = 0;
> > +     }
> >       trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, entry_found);
> >       return entry_found;
> >  }
> > --
> > 2.23.0.237.gc6a4ce50a0-goog
> >
