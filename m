Return-Path: <kvm+bounces-19026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3828FF268
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC1F1C2227D
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8981991AE;
	Thu,  6 Jun 2024 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZ0Nhn5w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43BC1990A1;
	Thu,  6 Jun 2024 16:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690955; cv=none; b=boegV0zHhYJRXZS45IWSoph0Ej3hQwWf5R85nHlyDKE/ppDxRA+Q/zypY+Z//MEp1wg+txi0i+yCTdjqV9mVSB5gJHry2medLgJ/wIeptzJDDf/q3eEGjWWA/RVtTOpa9mijOByvyv7mN7q46WLb+8+K5WPK8XfkgcQjjcqXacU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690955; c=relaxed/simple;
	bh=Q+vrgTBGO4uoIOOe7S/ANwtcnFISMpO8zG4tv8qihJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MFo0xQDRCEtxAz9MWc8UXflYhZgNvRWAA1ZGrKJWRm43ZACVXk/vBgVrmprIBD1JoRRbnszy4lqTigQP2B4fAeW8i6lAejn7FKbGm28A/W9tYHL9UlC9tOrjNL+ZsTn33DhIPK1LkDh4K4ofY4KFKmB9oXA+swCmpy4P6azwkOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZ0Nhn5w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EF7C2BD10;
	Thu,  6 Jun 2024 16:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717690955;
	bh=Q+vrgTBGO4uoIOOe7S/ANwtcnFISMpO8zG4tv8qihJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RZ0Nhn5wVlF93tjBwFq8HsyrTnvto9/1TGU4wvK3s1CMwRqNYAVPuPjvFn6e02gYn
	 PlPJDfj+AIdI4RtXo6A3n+4ROqzf8faGiM6qdPbwrfH7KnDlARvp1KhAEsJ/RYi9DS
	 np6kEpAn0ky2D44t8U+9G/wVQYvAXxsPC/JKzo4VrYI8dSskEhqM0z9dcBporrJj3m
	 A3u2Z65TWapU00op5WOU8VDcwy/Kz+nkauRj4tfXf1wTn0aWOlhPo7Tk3FwjItkRAo
	 hV2xSOQ4FrTDXZby9lFrrX57r1XWOGcIw3Qh4MqWBI7gMqVcZcbl2PxjIe6kGU3GSE
	 gP0ueFkuunGtQ==
Date: Thu, 6 Jun 2024 17:22:26 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 11/13] KVM: arm64: Improve CONFIG_CFI_CLANG error
 message
Message-ID: <20240606162226.GA23425@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-12-ptosi@google.com>
 <20240603144808.GL19151@willie-the-truck>
 <whzwqltolrms4ct35az5eif5rg25e2km23cztypgikallbcxoj@wtwfckujzcrf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <whzwqltolrms4ct35az5eif5rg25e2km23cztypgikallbcxoj@wtwfckujzcrf>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 04, 2024 at 05:05:59PM +0100, Pierre-Clément Tosi wrote:
> On Mon, Jun 03, 2024 at 03:48:08PM +0100, Will Deacon wrote:
> > On Wed, May 29, 2024 at 01:12:17PM +0100, Pierre-Clément Tosi wrote:
> > > For kCFI, the compiler encodes in the immediate of the BRK (which the
> > > CPU places in ESR_ELx) the indices of the two registers it used to hold
> > > (resp.) the function pointer and expected type. Therefore, the kCFI
> > > handler must be able to parse the contents of the register file at the
> > > point where the exception was triggered.
> > > 
> > > To achieve this, introduce a new hypervisor panic path that first stores
> > > the CPU context in the per-CPU kvm_hyp_ctxt before calling (directly or
> > > indirectly) hyp_panic() and execute it from all EL2 synchronous
> > > exception handlers i.e.
> > > 
> > > - call it directly in host_el2_sync_vect (__kvm_hyp_host_vector, EL2t&h)
> > > - call it directly in el2t_sync_invalid (__kvm_hyp_vector, EL2t)
> > > - set ELR_EL2 to it in el2_sync (__kvm_hyp_vector, EL2h), which ERETs
> > > 
> > > Teach hyp_panic() to decode the kCFI ESR and extract the target and type
> > > from the saved CPU context. In VHE, use that information to panic() with
> > > a specialized error message. In nVHE, only report it if the host (EL1)
> > > has access to the saved CPU context i.e. iff CONFIG_NVHE_EL2_DEBUG=y,
> > > which aligns with the behavior of CONFIG_PROTECTED_NVHE_STACKTRACE.
> > > 
> > > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > > ---
> > >  arch/arm64/kvm/handle_exit.c            | 30 +++++++++++++++++++++++--
> > >  arch/arm64/kvm/hyp/entry.S              | 24 +++++++++++++++++++-
> > >  arch/arm64/kvm/hyp/hyp-entry.S          |  2 +-
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
> > >  arch/arm64/kvm/hyp/nvhe/host.S          |  2 +-
> > >  arch/arm64/kvm/hyp/vhe/switch.c         | 26 +++++++++++++++++++--
> > >  6 files changed, 79 insertions(+), 9 deletions(-)
> > 
> > This quite a lot of work just to print out some opaque type numbers
> > when CONFIG_NVHE_EL2_DEBUG=y. Is it really worth it? How would I use
> > this information to debug an otherwise undebuggable kcfi failure at EL2?
> 
> The type ID alone might not be worth it but what about the target?
> 
> In my experience, non-malicious kCFI failures are often caused by an issue with
> the callee, not the caller. Without this patch, only the source of the exception
> is reported but, with it, the panic handler also prints the kCFI target (i.e.
> value of the function pointer) as a symbol.

I think it's less of an issue for EL2, as we don't have tonnes of
indirections, but I agree that the target is nice to have.

> With the infrastructure for the target in place, it isn't much more work to also
> report the type ID. Although it is rarely informative (as you noted), there are
> some situations where it can still be useful e.g. if reported as zero and/or has
> been corrupted and does not match its value from the ELF.

So looking at the implementation, I'm not a huge fan of saving off all
the GPRs and then relying on the stage-2 being disabled so that the host
can fish out the registers it cares about. I think I'd prefer to provide
the target as an additional argument to nvhe_hyp_panic_handler(), meaning
that we could even print the VA when CONFIG_NVHE_EL2_DEBUG is disabled.

But for now, I suggest we drop this patch along with the testing patches
because I think the rest of the series is nearly there and it's a useful
change on its own.

Will

