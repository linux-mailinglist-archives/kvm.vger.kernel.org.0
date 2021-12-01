Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A13465222
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbhLAP4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:56:44 -0500
Received: from foss.arm.com ([217.140.110.172]:40472 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351198AbhLAP4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:56:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E489143B;
        Wed,  1 Dec 2021 07:53:22 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CDF13F766;
        Wed,  1 Dec 2021 07:53:20 -0800 (PST)
Date:   Wed, 1 Dec 2021 15:53:18 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Eric Auger <eauger@redhat.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
Message-ID: <YaeabhZnYNLQcejs@monolith.localdoman>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
 <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Mon, Nov 29, 2021 at 09:32:02PM -0800, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
> >
> > Hi Reiji,
> >
> > On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > > expose the value for the guest as it is.  Since KVM doesn't support
> > > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > > exopse 0x0 (PMU is not implemented) instead.
> > s/exopse/expose
> > >
> > > Change cpuid_feature_cap_perfmon_field() to update the field value
> > > to 0x0 when it is 0xf.
> > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > guest should not use it as a PMUv3?
> 
> > is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> > guest should not use it as a PMUv3?
> 
> For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
> Arm ARM says:
>   "IMPLEMENTATION DEFINED form of performance monitors supported,
>    PMUv3 not supported."
> 
> Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
> be exposed to guests (And this patch series doesn't allow userspace
> to set the fields to 0xf for guests).

While it's true that a value of 0xf means that PMUv3 is not present (both
KVM and the PMU driver handle it this way) this is an userspace visible
change.

Are you sure there isn't software in the wild that relies on this value
being 0xf to detect that some non-Arm architected hardware is present?

Since both 0 and 0xf are valid values that mean that PMUv3 is not present,
I think it's best that both are kept.

Thanks,
Alex

> 
> Thanks,
> Reiji
> 
> >
> > Eric
> > >
> > > Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/include/asm/cpufeature.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > > index ef6be92b1921..fd7ad8193827 100644
> > > --- a/arch/arm64/include/asm/cpufeature.h
> > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
> > >
> > >       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
> > >       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> > > -             val = 0;
> > > +             return (features & ~mask);
> > >
> > >       if (val > cap) {
> > >               features &= ~mask;
> > >
> >
