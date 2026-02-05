Return-Path: <kvm+bounces-70375-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFt6GKEbhWkO8gMAu9opvQ
	(envelope-from <kvm+bounces-70375-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:37:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B04D8F8252
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 23:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A79FC3037E65
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 22:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C663533A9D2;
	Thu,  5 Feb 2026 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sm0WPA0k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1A833A036
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 22:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770330799; cv=none; b=ev4eSu9BiMGsnT88rHy4AIptxbfEQe25IqryJDOxGH9jdFkuJ5831uiaqGYCdvV4SaxKos0Vqc15iZLzpx2jxzsQ4dJ6wL/fSILr1nQ56R+ZKcYGsSA7BSJJp4zPGfFRWLrpkxfrbYtDNieTEw+xDjd29CATi+b0nRdVWdeE/gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770330799; c=relaxed/simple;
	bh=jFBGPxbgt7yvrPxyF3IcZirzv/eOTdVuE3Whhc0MLj8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q773E1eFBDYhsp/XSFDorRbMnz4al1f5rIkUwvWUE70ALX/l0gnNrV58KrpZ6QCmxuVYN8S4ps6SgD9LDPI+w5bz5imHqvIMR3Luc0Mqz4VYrBSbeX2ehngvJR0Wa4zF8tzB1uqwReOoT8KXd9t+RwodY3zmYP1KZpMzc4Bnb+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sm0WPA0k; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354490889b6so2403535a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 14:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770330798; x=1770935598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jf0tV+3Au/5ctTTszs4A1kRtXNYfBj14UQ6nvW/dMCc=;
        b=Sm0WPA0kZwHejYpbADr9MU0MuKC1DsHOOfFNLV9qAIPI2J8L6O4zfO66IAh1bdG3GW
         3XJ6RpMxkO2yfDJtMsJE2lODiNQZOD9FV2+ojw5xU2dZmg8+/m9VminxbTIRQtdvEfXc
         rL2LOyIz1DVYxTfN4CcQ655TNJBfAFAvRJmiGF+PeiNbhYsiMNhJFPTkpjGrZFHm468X
         1g97pHT4+iP/DH4+luH1z1A0pxoJvxPbvDWiRzW6LNFHv66HJlwsdocLEICgas3g1JLI
         CvNt7S2zJiVPCN0GbYElOIOS6jNKRlgPQTmdV80j6tRLWk1ICsgsk9oQiRyeHMVJskG7
         hGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770330798; x=1770935598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jf0tV+3Au/5ctTTszs4A1kRtXNYfBj14UQ6nvW/dMCc=;
        b=lEzr06GgPM5ylBh+Mgb3maNIomfaYj10d11MT1fwWMBzu0NhiiOkWLhkLplT8RdyUP
         3R834bs/RCXTtpAh1BZEcr7w2YIaxwXjkKUmi1DTasgXEqh+oEK4UH5xAQuLuYdXPgf3
         5YP4gyEROwAecB888oftELFQE/lIQFytdTIyb2B/3z+1mAtsVv3OZ6BJP695YFUZNCAC
         ccb0WOOaabCVmYyngrN1I9g+e25/Z0LKxJumuciyaSQ/Pui5wYYw27j9+Gf/aHQH4AOi
         oL4gvjFYn9jS2wLaRu0fTTxh//aGAmU6fYQY8UpsrB3HbGYauu7XPR2SgFeeaJRSBQoR
         wOdg==
X-Forwarded-Encrypted: i=1; AJvYcCU6n/DGweAtOgiyO4yKhpRS0jUerT0pGcQp5u01GdAn8FqjcLxl1hcclOMfjh6uiHM2RdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPvIKV5PaFhdIe4ppr556YnhywtajtVjTv2PtXSMFhFlMmoWUm
	beYw7sgmJtysU9pl2isJQXxnAffyylr29It5WDJbpMAep5OMqpSbgbb+BMzMCxOOMJ4lh90azo8
	jSxMDQQ==
X-Received: from pjbcp2.prod.google.com ([2002:a17:90a:fb82:b0:34c:5d4f:65e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a04:b0:340:ad5e:cb
 with SMTP id 98e67ed59e1d1-354b3b7d75amr421917a91.8.1770330798266; Thu, 05
 Feb 2026 14:33:18 -0800 (PST)
Date: Thu, 5 Feb 2026 14:33:16 -0800
In-Reply-To: <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com> <aYP_Ko3FGRriGXWR@google.com> <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
Message-ID: <aYUarHf3KEwHGuJe@google.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70375-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B04D8F8252
X-Rspamd-Action: no action

On Thu, Feb 05, 2026, Yan Zhao wrote:
> On Wed, Feb 04, 2026 at 06:23:38PM -0800, Sean Christopherson wrote:
> > On Wed, Feb 04, 2026, Yan Zhao wrote:
> > > On Wed, Jan 28, 2026 at 05:14:40PM -0800, Sean Christopherson wrote:
> > > > @@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > > >  	 * the paging structure.  Note the WARN on the PFN changing without the
> > > >  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
> > > >  	 * pages are kernel allocations and should never be migrated.
> > > > +	 *
> > > > +	 * When removing leaf entries from a mirror, immediately propagate the
> > > > +	 * changes to the external page tables.  Note, non-leaf mirror entries
> > > > +	 * are handled by handle_removed_pt(), as TDX requires that all leaf
> > > > +	 * entries are removed before the owning page table.  Note #2, writes
> > > > +	 * to make mirror PTEs shadow-present are propagated to external page
> > > > +	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
> > > > +	 * external page table was successfully updated before marking the
> > > > +	 * mirror SPTE present.
> > > >  	 */
> > > >  	if (was_present && !was_leaf &&
> > > >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > > >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > > > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> > > Should we check !is_present instead of !is_leaf?
> > > e.g. a transition from a present leaf entry to a present non-leaf entry could
> > > also trigger this if case.
> > 
> > No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
> > doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
> > that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
> > tdx_sept_remove_private_spte() to fire:
> > 
> > 	/* TODO: handle large pages. */
> > 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > 		return -EIO;
> But the op is named remove_external_spte().
> And the check of "level != PG_LEVEL_4K" is for removing large leaf entries.

I agree that the naming at this point in the series is unfortunate, but I don't
see it as outright wrong.  That the TDP MMU could theoretically replace the leaf
SPTE with a non-leaf SPTE doesn't change the fact that the old leaf SPTE *is*
being removed.

> Relying on this check is tricky and confusing.

If it's still confusing at the end of the series, then I'm happy to discuss how
we can make it less confusion.  But as of this point in the series, I unfortunately
don't see a better way to achieve my end goals (reducing the number of kvm_x86_ops
hooks, and reducing how many TDX specific details bleed into common MMU code).

There are "different" ways to incrementally move from where were at today, to where
I want KVM to be, but I don't see them as "better".  I.e. AFAICT, there's no way
to move incrementally with reviewable patches while also maintaining perfect/ideal
naming and flow.

> > And then later on, when S-EPT gains support for hugepages, "KVM: TDX: Add core
> > support for splitting/demoting 2MiB S-EPT to 4KiB" doesn't need to touch code
> > outside of arch/x86/kvm/vmx/tdx.c, because everything has already been plumbed
> > in.
> I haven't looked at the later patches for huge pages,

Please do.  As above, I don't think it's realistic to completely avoid some amount
of "eww" in the intermediate stages.

> but plumbing here directly for splitting does not look right when it's
> invoked under shared mmu_lock.
> See the comment below.
>  
> > > Besides, need "KVM_BUG_ON(shared, kvm)" in this case.
> > 
> > Eh, we have lockdep_assert_held_write() in the S-EPT paths that require mmu_lock
> > to be held for write.  I don't think a KVM_BUG_ON() here would add meaningful
> > value.
> Hmm, I think KVM_BUG_ON(shared, kvm) is still useful.
> If KVM invokes remove_external_spte() under shared mmu_lock, it needs to freeze
> the entry first, similar to the sequence in __tdp_mmu_set_spte_atomic().
> 
> i.e., invoking external x86 ops in handle_changed_spte() for mirror roots should
> be !shared only.

Sure, but...

> Relying on the TDX code's lockdep_assert_held_write() for warning seems less
> clear than having an explicit check here.

...that's TDX's responsibility to enforce, and I don't see any justification for
something more than a lockdep assertion.  As I've said elsewhere, several times,
at some point we have to commit to getting the code right.  Adding KVM_BUG_ON() in
Every. Single. Call. does not yield more maintainable code.  There are myriad
things KVM can screw up, many of which have far, far more harmful impact than
calling an S-EPT hook with mmu_lock held for read instead of write.

The bar for adding a KVM_BUG_ON() is not simply "this shouldn't happen".  It's,
this shouldn't happen *and* at least one of (not a complete list):

  - we've either screwed this up badly more than once
  - it's really hard to get right
  - we might not notice if we do screw it up
  - KVM might corrupt data if we continue on

