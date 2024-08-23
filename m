Return-Path: <kvm+bounces-24887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 872BE95CC39
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 14:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FE5828255A
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 12:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF16185B55;
	Fri, 23 Aug 2024 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1Skkx5s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF3358A7;
	Fri, 23 Aug 2024 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724415343; cv=none; b=j03TXI1cCYNrRqLf6J7AxXlk2ayIMdSR+yfx2VE+5iEsggBF7317TUlM2XbWAXq0s2YjAexuZ8STiVBrcbgtofp9OqlqzCSLPDYgFK+4R+bWGoeE8t2ngVZHRniQn1A4QsgRAoacPD5xtxzvqWoQngKgmyRg2CArglz/p2NUgk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724415343; c=relaxed/simple;
	bh=QSwBy/mtxU5PQEV0qc+NWWpaKehQRcAiGZXxDif/GcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UcyoL9xt4X65P/YcK7HtvUnIrhmFV8zVhPhkGktHC7lsd0QdJ6bod9wFNmZ9cGttND9B52DyT9x3hvoqDcY8Lae9Y91T8DCPC1rf95tutODGe8hon4zhk4spf1GUfG8rkeS2S576cV/tym73e0ale331/rpVfpxDmbxMzytffM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1Skkx5s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A489AC32786;
	Fri, 23 Aug 2024 12:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724415342;
	bh=QSwBy/mtxU5PQEV0qc+NWWpaKehQRcAiGZXxDif/GcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1Skkx5sYt3Grbjh67xETdslEani4TBJqgeWd8AajJv1OcyeopWDTUF5qG6K8oUjB
	 YQIVyWcZSTdxcLJOq+O/6XQ2dftgK8y0xfTGr5eQUbkZMrj32Wv26HILtebpX56Rlv
	 tAIZkaYSevVNBWAHtso7keRAbAOUbaTmmlcQRbVpgrIvUkS6MkI1yuHvnPp+5FGbEO
	 FZjaHQ7uwIKk4neNvmNVkkezJbd+zLqg5YNMVRk2jK9ummmJTqUAU3YVBnzcy9qDKd
	 UlcNU8NTLr9kYROzDZgxeecu2c/Synb91cfNu2g129MDCGQ0ybQY8YZ97Pn1alLBXb
	 7xS1jQRvqNo1A==
Date: Fri, 23 Aug 2024 13:15:38 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks
 when possible
Message-ID: <20240823121538.GA32110@willie-the-truck>
References: <20240802191617.312752-1-seanjc@google.com>
 <20240820154150.GA28750@willie-the-truck>
 <ZsS_OmxwFzrqDcfY@google.com>
 <20240820163213.GD28750@willie-the-truck>
 <ZsTM-Olv8aT2rql6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsTM-Olv8aT2rql6@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Aug 20, 2024 at 10:06:00AM -0700, Sean Christopherson wrote:
> On Tue, Aug 20, 2024, Will Deacon wrote:
> > On Tue, Aug 20, 2024 at 09:07:22AM -0700, Sean Christopherson wrote:
> > > On Tue, Aug 20, 2024, Will Deacon wrote:
> > > > handler could do the invalidation as part of its page-table walk (for
> > > > example, it could use information about the page-table structure such
> > > > as the level of the leaves to optimise the invalidation further), but
> > > > this does at least avoid zapping the whole VMID on CPUs with range
> > > > support.
> > > > 
> > > > My only slight concern is that, should clear_flush_young() be extended
> > > > to operate on more than a single page-at-a-time in future, this will
> > > > silently end up invalidating the entire VMID for each memslot unless we
> > > > teach kvm_arch_flush_remote_tlbs_range() to return !0 in that case.
> > > 
> > > I'm not sure I follow the "entire VMID for each memslot" concern.  Are you
> > > worried about kvm_arch_flush_remote_tlbs_range() failing and triggering a VM-wide
> > > flush?
> > 
> > The arm64 implementation of kvm_arch_flush_remote_tlbs_range()
> > unconditionally returns 0, so we could end up over-invalidating pretty
> > badly if that doesn't change. It should be straightforward to fix, but
> > I just wanted to point it out because it would be easy to miss too!
> 
> Sorry, I'm still not following.  0==success, and gfn_range.{start,end} is scoped
> precisely to the overlap between the memslot and hva range.  Regardless of the
> number of pages that are passed into clear_flush_young(), KVM should naturally
> flush only the exact range being aged.  The only hiccup would be if the hva range
> straddles multiple memslots, but if userspace creates multiple memslots for a
> single vma, then that's a userspace problem.

Fair enough, but it's not a lot of effort to fix this (untested diff
below) and if the code were to change in future so that
__kvm_handle_hva_range() was more commonly used to span multiple
memslots we probably wouldn't otherwise notice the silent
over-invalidation for a while.

Will

--->8

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..1e34127f79b0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -175,6 +175,9 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
                                      gfn_t gfn, u64 nr_pages)
 {
+       if (!system_supports_tlb_range())
+               return -EOPNOTSUPP;
+
        kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
                                gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
        return 0;


