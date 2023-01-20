Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31F5D675D23
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjATSxZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 13:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjATSxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 13:53:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F08780B92
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:53:20 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 7so4840887pga.1
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hbVkhmbwrxHdRnc6988uVhgGX0OwIVVngeM3AP0vwwM=;
        b=YyZ2GQPJLnmNMqIOhj29cQEAc2wXHLAdR8q265VO2GVcMv9W4doftcJuxezu6FeMMd
         AmvJJde8mojg96TsP8yugvRvdUMypU+170DfXgEIIODZznKsXIv7KjhdxJtQQfUna4ml
         r8xVDRNxdf+XoQ1l7NSaB7kXGnsHTw+Hk8AtKsulhEEphZeUm0ozgiFovnLOOkFAuYF/
         /Tf2H5rNtukMv2qaQXMg6PMeICYvsx3baVQ4CeuzEiQYTpGAJhgli2+abXL+xZp8BgT3
         IG+5Kx8QsAJv0F31/SIIce3oLwYRLcg57DTbur3J+NT5ab+qdmwGwrp5vH9XG3ECQqwC
         TX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbVkhmbwrxHdRnc6988uVhgGX0OwIVVngeM3AP0vwwM=;
        b=zUmh2bI6p4syRDNWru1kbkFuI+Rh3hVltwu5yn4p0hkKcB+DVxgtcM+JaIGABGjQzn
         fo9XRO38lnafjfrCRQoF6rwyHLMFgBGZkkExJGA373LQ5x4sfFqOryD3IKWJlCrdWmoo
         wp+SmsOvkdz1MvblvivLibCUGFKd+3LW5VbVcqNxlk/oXrEJkvcTR/ni0GMjPQSCP05U
         xl81V4ele5fpqHSzhOc1KOfjI4M0eEs6L+4amjw7SN2rfn8ti/vO1ig7S10UPqskjQr3
         jd6szZZWV8Nr6ebQ+RgRiZrUII7O0/CfDpk2ecjTp01hhM9x3KouJU7OuAjR1988dhPr
         I5XQ==
X-Gm-Message-State: AFqh2kp7XFFC6iV6mdxIwabHfJkCjVUQwo/nPPhPvd59oBZe5QZjjKsc
        qdxWtG+jl0ZAfq3KzdEJD952zNizjy10gD1GwP8xpQ==
X-Google-Smtp-Source: AMrXdXtaABkqdOaqTa0aNwcY5jjakms9UPj5X9miquUpJAfFjmwpqsB8bwMVYIqvgg7fGfBCNdeZ9t7RkQfzzZfa1Aw=
X-Received: by 2002:a62:6084:0:b0:582:392e:8bbf with SMTP id
 u126-20020a626084000000b00582392e8bbfmr1484138pfb.75.1674240799468; Fri, 20
 Jan 2023 10:53:19 -0800 (PST)
MIME-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com> <20230117013542.371944-4-reijiw@google.com>
 <Y8ngqRHhiXHjc0vA@google.com> <86pmb9mmkv.wl-maz@kernel.org> <Y8rXx+7EUob7qPXh@google.com>
In-Reply-To: <Y8rXx+7EUob7qPXh@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 20 Jan 2023 10:53:02 -0800
Message-ID: <CAAeT=FyYspSieevHO3gD_Snvn19HXdzbUD3z-Q=1qQ1BBX-Jjw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value
 on vCPU reset
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver, Marc,

Thank you for the review!

On Fri, Jan 20, 2023 at 10:05 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey Marc,
>
> On Fri, Jan 20, 2023 at 12:12:32PM +0000, Marc Zyngier wrote:
> > On Fri, 20 Jan 2023 00:30:33 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > > I think we need to derive a sanitised value for PMCR_EL0.N, as I believe
> > > nothing in the architecture prevents implementers from gluing together
> > > cores with varying numbers of PMCs. We probably haven't noticed it yet
> > > since it would appear all Arm designs have had 6 PMCs.
> >
> > This brings back the question of late onlining. How do you cope with
> > with the onlining of such a CPU that has a smaller set of counters
> > than its online counterparts? This is at odds with the way the PMU
> > code works.
>
> You're absolutely right, any illusion we derived from the online set of
> CPUs could fall apart with a late onlining of a different core.
>
> > If you have a different set of counters, you are likely to have a
> > different PMU altogether:
> >
> > [    1.192606] hw perfevents: enabled with armv8_cortex_a57 PMU driver, 7 counters available
> > [    1.201254] hw perfevents: enabled with armv8_cortex_a53 PMU driver, 7 counters available
> >
> > This isn't a broken system, but it has two set of cores which are
> > massively different, and two PMUs.
> >
> > This really should tie back to the PMU type we're counting on, and to
> > the set of CPUs that implements it. We already have some
> > infrastructure to check for the affinity of the PMU vs the CPU we're
> > running on, and this is already visible to userspace.
> >
> > Can't we just leave this responsibility to userspace?
>
> Believe me, I'm always a fan of offloading things to userspace :)
>
> If the VMM is privy to the details of the system it is on then the
> differing PMUs can be passed through to the guest w/ pinned vCPU
> threads. I just worry about the case of a naive VMM that assumes a
> homogenous system. I don't think I could entirely blame the VMM in this
> case either as we've gone to lengths to sanitise the feature set
> exposed to userspace.
>
> What happens when a vCPU gets scheduled on a core where the vPMU
> doesn't match? Ignoring other incongruences, it is not possible to
> virtualize more counters than are supported by the vPMU of the core.

I believe KVM_RUN will fail with KVM_EXIT_FAIL_ENTRY (Please see
the code that handles ON_UNSUPPORTED_CPU).

> Stopping short of any major hacks in the kernel to fudge around the
> problem, I believe we may need to provide better documentation of how
> heterogeneous CPUs are handled in KVM and what userspace can do about
> it.

Documentation/virt/kvm/devices/vcpu.rstDocumentation/virt/kvm/devices/vcpu.rst
for KVM_ARM_VCPU_PMU_V3_SET_PMU
has some description for the current behavior at least.
(perhaps we may need to update documents for this though)

Now I'm a bit worried about the validation code for PMCR_EL0.N
as well, as setting (restoring) PMCR_EL0 could be done on any
pCPUs (even before using KVM_ARM_VCPU_PMU_V3_SET_PMU).

What I am currently looking at is something like this:
 - Set the sanitised (min) value of PMCR_EL0.N among all PMUs
   for vCPUs by default.
 - Validate the PMCR_EL0.N value that userspace tries to set
   against the max value on the system (this is to ensure that
   restoring PMCR_EL0 for a vCPU works on any pCPUs)
 - Make KVM_RUN fail when PMCR_EL0.N for the vCPU indicates
   more counters than the PMU that is set for the vCPU.

What do you think ?

Thank you,
Reiji
