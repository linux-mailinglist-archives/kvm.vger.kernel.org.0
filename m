Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D40332720
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 14:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhCIN1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 08:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhCIN0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 08:26:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC30064D8F;
        Tue,  9 Mar 2021 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615296411;
        bh=GW/0WIVybU+FKZci+pHzO6MpN/bNiJDrh5DoiKRhFGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZgLBDtYY4aIDeUHdlKwtssqYTc3uPuKrCzBJUYdtFYSrE1mQA2FiUxsEh6PX+DCf4
         SQrAAhLsr6Pp5qvvgoyWI5P4OLszI7f7dBuIkSx/g4+tIbeXcBEwybscpR3BJXjbQe
         uuLsBFErYny4EmsPbJkucFL+VYcY/CxXovHyidKU0C44zYl+siFpQp82qsoH1JfME3
         yLXglUMvBgDqhZde+oRzWHYWnMxUf700y8JIvPreQMpqzla1Pp6NDw1vvrqyb/+EKM
         RwbBN2UTIbmuxxZY2DTuX2F2tDTOh+5TY1tNK5oBp6Ot7+E4FgCnmeuhOulkcfjyBS
         +ndJVCHjsd5/A==
Date:   Tue, 9 Mar 2021 13:26:46 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a
 same VM
Message-ID: <20210309132645.GA28297@willie-the-truck>
References: <20210303164505.68492-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303164505.68492-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 04:45:05PM +0000, Marc Zyngier wrote:
> It recently became apparent that the ARMv8 architecture has interesting
> rules regarding attributes being used when fetching instructions
> if the MMU is off at Stage-1.
> 
> In this situation, the CPU is allowed to fetch from the PoC and
> allocate into the I-cache (unless the memory is mapped with
> the XN attribute at Stage-2).
> 
> If we transpose this to vcpus sharing a single physical CPU,
> it is possible for a vcpu running with its MMU off to influence
> another vcpu running with its MMU on, as the latter is expected to
> fetch from the PoU (and self-patching code doesn't flush below that
> level).
> 
> In order to solve this, reuse the vcpu-private TLB invalidation
> code to apply the same policy to the I-cache, nuking it every time
> the vcpu runs on a physical CPU that ran another vcpu of the same
> VM in the past.
> 
> This involve renaming __kvm_tlb_flush_local_vmid() to
> __kvm_flush_cpu_context(), and inserting a local i-cache invalidation
> there.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h   | 4 ++--
>  arch/arm64/kvm/arm.c               | 7 ++++++-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 +++---
>  arch/arm64/kvm/hyp/nvhe/tlb.c      | 3 ++-
>  arch/arm64/kvm/hyp/vhe/tlb.c       | 3 ++-
>  5 files changed, 15 insertions(+), 8 deletions(-)

Since the FWB discussion doesn't affect the correctness of this patch:

Acked-by: Will Deacon <will@kernel.org>

Will
