Return-Path: <kvm+bounces-11442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADC88770A2
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 12:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98C2D1F21683
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 11:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048EB36B0E;
	Sat,  9 Mar 2024 11:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rl9M6geC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6451D69E;
	Sat,  9 Mar 2024 11:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709982924; cv=none; b=f1goCM8wyLYH13qFfBm0QSmMAubIQtRWeBXrPK9zul3nC57ilvgCeJHiv3DNPYycmLcNMBfJkp/TRR5vr1INxJTqaIrGRDs6wQETk2FLzyrl46+uzjiddf6XeZUcwnwNoYsN7sPRFS6PJXgFnPNNDjNoqnIp3CwxxFhjhqjdMxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709982924; c=relaxed/simple;
	bh=YaUuuk7Crsl2a1PUUVlftTiGcGES7hvpa0gsLJH4zXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aa/W+KdyCHtD4zxfoUmF1tR5LrH9XJ/amfL8r2d8YlNodYG4Q67T3aCuB6IBQfLgHs5VSozdFySLft8HYmfuC+bcVahQcttrkXk/ED8mH/pTAN7Weg6/Q/PnW/e7Az+QrC+KOjAlKXyybbQZPguqmtBmags1677YStdoYIngl2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rl9M6geC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB0EC433C7;
	Sat,  9 Mar 2024 11:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709982923;
	bh=YaUuuk7Crsl2a1PUUVlftTiGcGES7hvpa0gsLJH4zXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rl9M6geC4ebyRSg/d2wRXYZOIlzGBGevef0ILal/PwLTfJYHxWnepu1EFQhJSJqp1
	 dqKzS8GKxJ+rhJToGRkhboVOZdHt+vU98vtpuGtVx1OYquHCjgIoWOt5kIIIUgUdkA
	 zVhFg8xuVaI+nt//g1J0r8SZk/3Q7xTmCC8eOzhi9FBsQ9Y0h+puyEVimWTJnC8oYu
	 Y7MxIveJTBKivuvGizPHVxJlu5YPSGFls3TxEPBEiRf30S5/tAKcIhqs0kqyYQkT4I
	 tS6X5kYMX/52fcixiE4zhGRDtQidSASFWNKNftwdz9lcEYoKUFz7B7hl+61ijvjwHK
	 DHGPLi3zffCQA==
Date: Sat, 9 Mar 2024 13:14:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: James Gowans <jgowans@amazon.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Patrick Roy <roypat@amazon.co.uk>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	Derek Manwaring <derekmn@amazon.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Nikita Kalyazin <kalyazin@amazon.co.uk>,
	"lstoakes@gmail.com" <lstoakes@gmail.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>,
	Alexander Graf <graf@amazon.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
Message-ID: <ZexEkGkNe_7UY7w6@kernel.org>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
 <ZeudRmZz7M6fWPVM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZeudRmZz7M6fWPVM@google.com>

On Fri, Mar 08, 2024 at 03:22:50PM -0800, Sean Christopherson wrote:
> On Fri, Mar 08, 2024, James Gowans wrote:
> > However, memfd_secret doesn’t work out the box for KVM guest memory; the
> > main reason seems to be that the GUP path is intentionally disabled for
> > memfd_secret, so if we use a memfd_secret backed VMA for a memslot then
> > KVM is not able to fault the memory in. If it’s been pre-faulted in by
> > userspace then it seems to work.
> 
> Huh, that _shouldn't_ work.  The folio_is_secretmem() in gup_pte_range() is
> supposed to prevent the "fast gup" path from getting secretmem pages.

I suspect this works because KVM only calls gup on faults and if the memory
was pre-faulted via memfd_secret there won't be faults and no gups from
KVM.
 
> > With this in mind, what’s the best way to solve getting guest RAM out of
> > the direct map? Is memfd_secret integration with KVM the way to go, or
> > should we build a solution on top of guest_memfd, for example via some
> > flag that causes it to leave memory in the host userspace’s page tables,
> > but removes it from the direct map? 
> 
> memfd_secret obviously gets you a PoC much faster, but in the long term I'm quite
> sure you'll be fighting memfd_secret all the way.  E.g. it's not dumpable, it
> deliberately allocates at 4KiB granularity (though I suspect the bug you found
> means that it can be inadvertantly mapped with 2MiB hugepages), it has no line
> of sight to taking userspace out of the equation, etc.
> 
> With guest_memfd on the other hand, everyone contributing to and maintaining it
> has goals that are *very* closely aligned with what you want to do.

I agree with Sean, guest_memfd seems a better interface to use. It's
integrated by design with KVM and removing guest memory from the direct map
looks like a natural enhancement to guest_memfd. 

Unless I'm missing something, for fast-and-dirty POC it'll be a oneliner
that adds set_memory_np() to kvm_gmem_get_folio() and then figuring out
what to do with virtio :)

-- 
Sincerely yours,
Mike.

