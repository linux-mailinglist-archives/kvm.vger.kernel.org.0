Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63332FB1D
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCFOQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Mar 2021 09:16:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230259AbhCFOPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Mar 2021 09:15:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 545426501A;
        Sat,  6 Mar 2021 14:15:51 +0000 (UTC)
Date:   Sat, 6 Mar 2021 14:15:48 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a
 same VM
Message-ID: <20210306141546.GB2932@arm.com>
References: <20210303164505.68492-1-maz@kernel.org>
 <20210305190708.GL23855@arm.com>
 <877dmksgaw.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dmksgaw.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 06, 2021 at 10:54:47AM +0000, Marc Zyngier wrote:
> On Fri, 05 Mar 2021 19:07:09 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > On Wed, Mar 03, 2021 at 04:45:05PM +0000, Marc Zyngier wrote:
> > > It recently became apparent that the ARMv8 architecture has interesting
> > > rules regarding attributes being used when fetching instructions
> > > if the MMU is off at Stage-1.
> > > 
> > > In this situation, the CPU is allowed to fetch from the PoC and
> > > allocate into the I-cache (unless the memory is mapped with
> > > the XN attribute at Stage-2).
> > 
> > Digging through the ARM ARM is hard. Do we have this behaviour with FWB
> > as well?
> 
> The ARM ARM doesn't seem to mention FWB at all when it comes to
> instruction fetch, which is sort of expected as it only covers the
> D-side. I *think* we could sidestep this when CTR_EL0.DIC is set
> though, as the I-side would then snoop the D-side.

Not sure this helps. CTR_EL0.DIC refers to the need for maintenance to
PoU while the SCTLR_EL1.M == 0 causes the I-cache to fetch from PoC. I
don't think I-cache snooping the D-cache would happen to the PoU when
the S1 MMU is off.

My reading of D4.4.4 is that when SCTLR_EL1.M == 0 both I and D accesses
are Normal Non-cacheable with a note in D4.4.6 that Non-cacheable
accesses may be held in the I-cache.

The FWB rules on combining S1 and S2 says that Normal Non-cacheable at
S1 is "upgraded" to cacheable. This should happen irrespective of
whether the S1 MMU is on or off and should apply to both I and D
accesses (since it does not explicitly says). So I think we could skip
this IC IALLU when FWB is present.

The same logic should apply when the VMM copies the VM text. With FWB,
we probably only need D-cache maintenance to PoU and only if
CTR_EL0.IDC==0. I haven't checked what the code currently does.

-- 
Catalin
