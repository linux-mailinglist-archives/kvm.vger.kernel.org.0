Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B3C3328BF
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 15:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCIOjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 09:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhCIOis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 09:38:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F0464EEE;
        Tue,  9 Mar 2021 14:38:45 +0000 (UTC)
Date:   Tue, 9 Mar 2021 14:38:42 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a
 same VM
Message-ID: <20210309143841.GA32754@arm.com>
References: <20210303164505.68492-1-maz@kernel.org>
 <20210309132645.GA28297@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309132645.GA28297@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 01:26:46PM +0000, Will Deacon wrote:
> On Wed, Mar 03, 2021 at 04:45:05PM +0000, Marc Zyngier wrote:
> > It recently became apparent that the ARMv8 architecture has interesting
> > rules regarding attributes being used when fetching instructions
> > if the MMU is off at Stage-1.
> > 
> > In this situation, the CPU is allowed to fetch from the PoC and
> > allocate into the I-cache (unless the memory is mapped with
> > the XN attribute at Stage-2).
> > 
> > If we transpose this to vcpus sharing a single physical CPU,
> > it is possible for a vcpu running with its MMU off to influence
> > another vcpu running with its MMU on, as the latter is expected to
> > fetch from the PoU (and self-patching code doesn't flush below that
> > level).
> > 
> > In order to solve this, reuse the vcpu-private TLB invalidation
> > code to apply the same policy to the I-cache, nuking it every time
> > the vcpu runs on a physical CPU that ran another vcpu of the same
> > VM in the past.
> > 
> > This involve renaming __kvm_tlb_flush_local_vmid() to
> > __kvm_flush_cpu_context(), and inserting a local i-cache invalidation
> > there.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h   | 4 ++--
> >  arch/arm64/kvm/arm.c               | 7 ++++++-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 +++---
> >  arch/arm64/kvm/hyp/nvhe/tlb.c      | 3 ++-
> >  arch/arm64/kvm/hyp/vhe/tlb.c       | 3 ++-
> >  5 files changed, 15 insertions(+), 8 deletions(-)
> 
> Since the FWB discussion doesn't affect the correctness of this patch:
> 
> Acked-by: Will Deacon <will@kernel.org>

I agree. We can optimise it later for FWB.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
