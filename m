Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6EEB6ABE
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfIRSlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 14:41:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43026 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388688AbfIRSls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 14:41:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id q17so447541wrx.10
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 11:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o9lwG+mTYSdeHD501iAOjt1X4gbm+LgNQ1VfXfGzDYc=;
        b=KOar7SuWNHQisJGwCD+7EI6jBg3yPcd8GXetUZGCn9GKKT05TJNH6SS3JxvoavqodE
         /nvUcPypmgyWy31lz4Zpmc83TtyslIUXAI9iYuv2dB7ByEogkYOjqDHDJTT5KCmeL/IY
         2L5XCFlxQA/Y18bncK2nU5DlyTla/AG80ebV75b/CSHi8bioqA4KMa5vxSF0kmWqq1/n
         alb94Xf1zdcr20VfuNs7PbseOeRMtAPnTB6wpXGSBK4yA+1c+CwQiUKhd2tMuRMWHTPB
         EvjJwqUtZZ/vNb5NDCfK9xaPLw827XOwv+Z1VNZpKxr7pMzTKEIRlZIHOxhU+CVYQhyM
         tZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o9lwG+mTYSdeHD501iAOjt1X4gbm+LgNQ1VfXfGzDYc=;
        b=jXpXZGagXv9HR/WjrGyUs1AlDIGCnmljHnaSfkCNahxHBuF8bU9Dq/fpAQi8r+GiOU
         4cS9x687mOoXHsZ3dvjOB+aMqO0UfBZ7F1olwGMEcVHi4oB5V2DeCh8AdWF0+1ty6Lu1
         XsrN/cy0JL8rvDa1CAzAw+R55CnI9kqVtNVkVf7KE0TA5zlYESiV1T+Tw/VLmlpiRKdV
         S2O3MZF/SJk0gIzV3WRakd4MnTT2hA4NZKVVkhUCBxCS5J924lWfDn20JEra8VV0wHPy
         6jyTNtiOMxRryGglY1fqaOQVbJvKTSHH8k+Jad2c0IjiWLZ3/M3707vbVyz92SXNSzM1
         4vsw==
X-Gm-Message-State: APjAAAUIEFxfpRPPRFGPG83XA2lpMGbNcUc8FPr+NcFQGyYQttjhB5NY
        4SPGoEOD3YsUZRlry6v+jhIL1Vei47dUNpMz8y20iA==
X-Google-Smtp-Source: APXvYqzC4m1ycIESXZUBSNfi2rU3ngouzKC33hBtnWBlC0cjS9ScnHNKocEfbnGW2JDZkGtLaklfu4JF91Gda9Tcp+U=
X-Received: by 2002:a05:6000:a:: with SMTP id h10mr3830839wrx.226.1568832103092;
 Wed, 18 Sep 2019 11:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190912232753.85969-1-jmattson@google.com> <20190918174308.GC14850@linux.intel.com>
 <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
In-Reply-To: <CALMp9eQSd8kMKEdLYTF2ugAYjQO-wAR-PoYmf0NgD2Z4ZVr5FA@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Sep 2019 11:41:31 -0700
Message-ID: <CALMp9eSJkjO0CX2_s1QpgaYk-pDVCYoof_QVjxf9cpquaMOr1A@mail.gmail.com>
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

On Wed, Sep 18, 2019 at 11:22 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Sep 18, 2019 at 10:43 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Sep 12, 2019 at 04:27:53PM -0700, Jim Mattson wrote:
> > > If these CPUID leaves are implemented, the EDX output is always the
> > > x2APIC ID, regardless of the ECX input. Furthermore, the low byte of
> > > the ECX output is always identical to the low byte of the ECX input.
> > >
> > > KVM's CPUID emulation doesn't report the correct ECX and EDX outputs
> > > when the ECX input is greater than the first subleaf for which the
> > > "level type" is zero. This is probably only significant in the case of
> > > the x2APIC ID, which should be the result of CPUID(EAX=0BH):EDX or
> > > CPUID(EAX=1FH):EDX, without even setting a particular ECX input value.
> >
> > At a glance, shouldn't leaf 0x1f be marked significant in do_host_cpuid()?
>
> Indeed. See my previous post, "[PATCH] kvm: x86: Add "significant
> index" flag to a few CPUID leaves."
>
> > > Create a "wildcard" kvm_cpuid_entry2 for leaves 0BH and 1FH in
> > > response to the KVM_GET_SUPPORTED_CPUID ioctl. This entry does not
> > > have the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag, so it matches all
> > > subleaves for which there isn't a prior explicit index match.
> > >
> > > Add a new KVM_CPUID flag that is only applicable to leaves 0BH and
> > > 1FH: KVM_CPUID_FLAG_CL_IS_PASSTHROUGH. When KVM's CPUID emulation
> > > encounters this flag, it will fix up ECX[7:0] in the CPUID output. Add
> > > this flag to the aforementioned "wildcard" kvm_cpuid_entry2.
> > >
> > > Note that userspace is still responsible for setting EDX to the x2APIC
> > > ID of the vCPU in each of these structures, *including* the wildcard.
> > >
> > > Qemu doesn't pass the flags from KVM_GET_SUPPORTED_CPUID to
> > > KVM_SET_CPUID2, so it will have to be modified to take advantage of
> > > these changes. Note that passing the new flag to older kernels will
> > > have no effect.
> > >
> > > Unfortunately, the new flag bit was not previously reserved, so it is
> > > possible that a userspace agent that already sets this bit will be
> > > unhappy with the new behavior. Technically, I suppose, this should be
> > > implemented as a new set of ioctls. Posting as an RFC to get comments
> > > on the API breakage.
> > >
> > > Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
> > > Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > > Reviewed-by: Jacob Xu <jacobhxu@google.com>
> > > Reviewed-by: Peter Shier <pshier@google.com>
> > > Change-Id: I6b422427f78b530106af3f929518363895367e25
> > > ---
> > >  Documentation/virt/kvm/api.txt  |  6 +++++
> > >  arch/x86/include/uapi/asm/kvm.h |  1 +
> > >  arch/x86/kvm/cpuid.c            | 39 +++++++++++++++++++++++++++------
> > >  3 files changed, 39 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > > index 2d067767b6170..be5cc42ad35f4 100644
> > > --- a/Documentation/virt/kvm/api.txt
> > > +++ b/Documentation/virt/kvm/api.txt
> > > @@ -1396,6 +1396,7 @@ struct kvm_cpuid2 {
> > >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              BIT(0)
> > >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         BIT(1)
> > >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               BIT(2)
> > > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     BIT(3)
> > >
> > >  struct kvm_cpuid_entry2 {
> > >       __u32 function;
> > > @@ -1447,6 +1448,8 @@ emulate them efficiently. The fields in each entry are defined as follows:
> > >          KVM_CPUID_FLAG_STATE_READ_NEXT:
> > >             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> > >             the first entry to be read by a cpu
> > > +     KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> > > +        If the output value of ECX[7:0] matches the input value of ECX[7:0]
> > >     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
> > >           this function/index combination
> > >
> > > @@ -2992,6 +2995,7 @@ The member 'flags' is used for passing flags from userspace.
> > >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              BIT(0)
> > >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         BIT(1)
> > >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               BIT(2)
> > > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     BIT(3)
> > >
> > >  struct kvm_cpuid_entry2 {
> > >       __u32 function;
> > > @@ -3040,6 +3044,8 @@ The fields in each entry are defined as follows:
> > >          KVM_CPUID_FLAG_STATE_READ_NEXT:
> > >             for KVM_CPUID_FLAG_STATEFUL_FUNC entries, set if this entry is
> > >             the first entry to be read by a cpu
> > > +     KVM_CPUID_FLAG_CL_IS_PASSTHROUGH:
> > > +        If the output value of ECX[7:0] matches the input value of ECX[7:0]
> > >     eax, ebx, ecx, edx: the values returned by the cpuid instruction for
> > >           this function/index combination
> > >
> > > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > > index 503d3f42da167..3b67d21123946 100644
> > > --- a/arch/x86/include/uapi/asm/kvm.h
> > > +++ b/arch/x86/include/uapi/asm/kvm.h
> > > @@ -223,6 +223,7 @@ struct kvm_cpuid_entry2 {
> > >  #define KVM_CPUID_FLAG_SIGNIFCANT_INDEX              (1 << 0)
> > >  #define KVM_CPUID_FLAG_STATEFUL_FUNC         (1 << 1)
> > >  #define KVM_CPUID_FLAG_STATE_READ_NEXT               (1 << 2)
> > > +#define KVM_CPUID_FLAG_CL_IS_PASSTHROUGH     (1 << 3)
> > >
> > >  /* for KVM_SET_CPUID2 */
> > >  struct kvm_cpuid2 {
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index e7d25f4364664..280a796159cb2 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -612,19 +612,41 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> > >        */
> > >       case 0x1f:
> > >       case 0xb: {
> > > -             int i, level_type;
> > > +             int i;
> > >
> > > -             /* read more entries until level_type is zero */
> > > -             for (i = 1; ; ++i) {
> > > +             /*
> > > +              * We filled in entry[0] for CPUID(EAX=<function>,
> > > +              * ECX=00H) above.  If its level type (ECX[15:8]) is
> > > +              * zero, then the leaf is unimplemented, and we're
> > > +              * done.  Otherwise, continue to populate entries
> > > +              * until the level type (ECX[15:8]) of the previously
> > > +              * added entry is zero.
> > > +              */
> > > +             for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
> > >                       if (*nent >= maxnent)
> > >                               goto out;
> > >
> > > -                     level_type = entry[i - 1].ecx & 0xff00;
> > > -                     if (!level_type)
> > > -                             break;
> > >                       do_host_cpuid(&entry[i], function, i);
> > >                       ++*nent;
> > >               }
> >
> > This should be a standalone bugfix/enhancement path.  Bugfix because it
> > eliminates a false positive on *nent >= maxnent.
>
> Sure.
>
> > > +
> > > +             if (i > 1) {
> > > +                     /*
> > > +                      * If this leaf has multiple entries, treat
> > > +                      * the final entry as a "wildcard." Clear the
> > > +                      * "significant index" flag so that the index
> > > +                      * will be ignored when we later look for an
> > > +                      * entry that matches a CPUID
> > > +                      * invocation. Since this entry will now match
> > > +                      * CPUID(EAX=<function>, ECX=<index>) for any
> > > +                      * <index> >= (i - 1), set the "CL
> > > +                      * passthrough" flag to ensure that ECX[7:0]
> > > +                      * will be set to (<index> & 0xff), per the SDM.
> > > +                      */
> > > +                     entry[i - 1].flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> >
> > If I'm reading the code correctly, this is fragile and subtle.  The order
> > of cpuid entries is controlled by userspace, which means that clearing
> > KVM_CPUID_FLAG_SIGNIFCANT_INDEX depends on this entry being kept after all
> > other entries for this function.  In practice I'm guessing userspaces
> > naturally sort entries with the same function by ascending index, but it
> > seems like avoidable issue.
>
> Though not documented, the CPUID leaf matching code has always
> depended on ordering.
>
> > Also, won't matching the last entry generate the wrong values for EAX, EBX
> > and ECX, i.e. the valid values for the last index instead of zeroes?
>
> This entry has CH==0. According to the SDM, "For sub-leaves that
> return an invalid level-type of 0 in ECX[15:8]; EAX and EBX will
> return 0."
> ECX[7:0] will be wrong, but that's fixed up by the flag below.
> ECX[31:16] are reserved and perhaps should be cleared here, but I'm
> not sure how I would interpret it if those bits started being non-zero
> for the first leaf with CH==0.
>
> > > +                     entry[i - 1].flags |= KVM_CPUID_FLAG_CL_IS_PASSTHROUGH;
> >
> > Lastly, do we actually need to enumerate this silliness to userspace?
> > What if we handle this as a one-off case in CPUID emulation and avoid the
> > ABI breakage that way?  E.g.:
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index dd5985eb61b4..aaf5cdcb88c9 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1001,6 +1001,16 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> >         }
> >
> >  out:
> > +       if (!best && (function == 0xb || function == 0x1f)) {
> > +               best = check_cpuid_limit(vcpu, function, 0);
> > +               if (best) {
> > +                       *eax = 0;
> > +                       *ebx = 0;
> > +                       *ecx &= 0xff;
> > +                       *edx = *best->edx;
> > +               }
> > +       }
> > +
>
> Aside from the fact that one should never call check_cpuid_limit on
> AMD systems (they don't do the "last basic leaf" nonsense), an
> approach like this should work.

The above proposal doesn't correctly handle a leaf outside of ([0,
maxBasicLeaf] union [80000000H, maxExtendedLeaf]) , where maxBasicLeaf
== (0BH or 1FH) on Intel hardware...but it could be fixed up to do so,
if hard-coding this behavior in kvm_cpuid() is preferable to the API
breakage.
