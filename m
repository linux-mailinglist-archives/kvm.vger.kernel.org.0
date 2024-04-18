Return-Path: <kvm+bounces-15100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2DFE8A9CE0
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6DB91C23769
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9141016C434;
	Thu, 18 Apr 2024 14:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2pNwg/h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF921635C8;
	Thu, 18 Apr 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713449980; cv=none; b=VK+zdNN+9gG4MnwGWVWkh6fw8mulMI9fIbD/YVff/D8vuFEJorj+KlP1fxSkB7ZVwZd0U7epelTj1OEO5BBG2OyVArhx4Ivl63HGJnegazSRmKUJ4X82X+p88oQW1SuSHQGmbhu2Hx1dU7cfx1SHL3kgC59V8is+gUj3lsdYgow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713449980; c=relaxed/simple;
	bh=AUt0AvjyUjML6ZxpdeebsS26lKqvFMfvN3N/sVPtRcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fD6ZJUe5UvWgYnHyQmPd8l8WrJ9o2nHqnHqI+A4xy9v+/+OC85Z2YOlzElmR6jEvbEEXbgqz4xnn5Gv7S7v4eHL6DxFKuYY9X7PEoEjCGk31B6lPaESl9jxdajBoLf6OI9TkYmcTHCUd3ZneBtlTkuXbP8W78XhIya5ZEVocnk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2pNwg/h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DADC32781;
	Thu, 18 Apr 2024 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713449980;
	bh=AUt0AvjyUjML6ZxpdeebsS26lKqvFMfvN3N/sVPtRcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B2pNwg/hwD4GFU+j3nK1XWEUYARxusswHne4K6Z5OpMVZCZ5ULburdPwHrZg5I4iu
	 U/y9G2YsiGlibZSfkHi7l9Xc1A1byzgoT5FVOk+X4RFIoKyf/9F5r8tzdINa6Ps8CK
	 NPuSjycgX6VTiF+iVSS1slG1ZPMnyNtYdJWJVNkY44ow8evHMgw76zaMNBUTb1gBOc
	 nj3GHa4KAPMpDuvEycIrwcKhHJVzFpCFK7p7pG+gbOJbi5QsNN4n2gti59vuYtfqHK
	 aaq8X28NwfZ8l26T0x1HIRhf7nZrUbo6m75mqZ305iGTMgwp0/oNpia09G3VtqBot9
	 UR6a8YKfras6w==
Date: Thu, 18 Apr 2024 15:19:32 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
Message-ID: <20240418141932.GA1855@willie-the-truck>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
 <20240412104408.GA27645@willie-the-truck>
 <86jzl2sovz.wl-maz@kernel.org>
 <ZhlLHtfeSHk9gRRO@google.com>
 <86h6g5si0m.wl-maz@kernel.org>
 <Zh1d94Pl6gneVoDd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh1d94Pl6gneVoDd@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 15, 2024 at 10:03:51AM -0700, Sean Christopherson wrote:
> On Sat, Apr 13, 2024, Marc Zyngier wrote:
> > On Fri, 12 Apr 2024 15:54:22 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > On Fri, Apr 12, 2024, Marc Zyngier wrote:
> > > > On Fri, 12 Apr 2024 11:44:09 +0100, Will Deacon <will@kernel.org> wrote:
> > > > > On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> > > > > Also, if you're in the business of hacking the MMU notifier code, it
> > > > > would be really great to change the .clear_flush_young() callback so
> > > > > that the architecture could handle the TLB invalidation. At the moment,
> > > > > the core KVM code invalidates the whole VMID courtesy of 'flush_on_ret'
> > > > > being set by kvm_handle_hva_range(), whereas we could do a much
> > > > > lighter-weight and targetted TLBI in the architecture page-table code
> > > > > when we actually update the ptes for small ranges.
> > > > 
> > > > Indeed, and I was looking at this earlier this week as it has a pretty
> > > > devastating effect with NV (it blows the shadow S2 for that VMID, with
> > > > costly consequences).
> > > > 
> > > > In general, it feels like the TLB invalidation should stay with the
> > > > code that deals with the page tables, as it has a pretty good idea of
> > > > what needs to be invalidated and how -- specially on architectures
> > > > that have a HW-broadcast facility like arm64.
> > > 
> > > Would this be roughly on par with an in-line flush on arm64?  The simpler, more
> > > straightforward solution would be to let architectures override flush_on_ret,
> > > but I would prefer something like the below as x86 can also utilize a range-based
> > > flush when running as a nested hypervisor.
> 
> ...
> 
> > I think this works for us on HW that has range invalidation, which
> > would already be a positive move.
> > 
> > For the lesser HW that isn't range capable, it also gives the
> > opportunity to perform the iteration ourselves or go for the nuclear
> > option if the range is larger than some arbitrary constant (though
> > this is additional work).
> > 
> > But this still considers the whole range as being affected by
> > range->handler(). It'd be interesting to try and see whether more
> > precise tracking is (or isn't) generally beneficial.
> 
> I assume the idea would be to let arch code do single-page invalidations of
> stage-2 entries for each gfn?

Right, as it's the only code which knows which ptes actually ended up
being aged.

> Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
> doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
> provides an instruction to do broadcast invalidations, but it takes a virtual
> address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
> a guest virtual address, but it's a moot point because KVM doen't have the guest
> virtual address, and if it's a host virtual address, there would need to be valid
> mappings in the host page tables for it to work, which KVM can't guarantee.

Ah, so it sounds like it would need to be an arch opt-in then.

Will

