Return-Path: <kvm+bounces-70289-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KO//OD7/g2nYwgMAu9opvQ
	(envelope-from <kvm+bounces-70289-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 03:23:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F775EDF1B
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 03:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F7C0301466B
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 02:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8869129D28F;
	Thu,  5 Feb 2026 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XxWZAEUz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD15C288C13
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770258220; cv=none; b=s2qPNu54dgX1vouVQh5DaOvWW3WVKX4ElmTGviLuR+9uGKsxgZfnhUdSp8v6R/wv5/CCNMAOstT/dBO272Iwg/MG5H2lJSEN9a90lt76AkxE3hcxHicS6o0W55bH3E4n2nDdAdYqZk96d0mBCmBpAPgy2eDwI8XngTs/46B/8NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770258220; c=relaxed/simple;
	bh=lYsctyliy0fxMEq30nM3NL5c5XYklWNxX4CS91jws6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mCe9+LPTKrK9LHfQYUZ7e1hlqyNH8DFDgoQ1fGYrklj4a/RoK1MOr+ekOmk5NvhHBEN9776yshRAQxxITXbJCPC6L1tcZGzxoOacJB3FGd5Mbh+TbJ+6gILy7QOzGiA87qQp8SdjUKsSVYR0vQTNZGhCc745z6PtBbhhN5eJxac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XxWZAEUz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c273332cso14930875ad.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 18:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770258220; x=1770863020; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UPAGPooo/X3dpeBJpmDTPFwweJO68Ii9P/cjFAf7PTs=;
        b=XxWZAEUzfkApfEQ8dk54mADW0T0Vcb5RDtWu/2FV/H4nGoJsRO0vSHk4G8+iEuJ5ta
         5vXOLLJjHggHzDvSvsMb8bQ1Pd6F+YUgNmJa3Nth20/QUQRfSNMYNGda916pA8SDwMw6
         XbeJOfeyICdM0ms7OVWKtd+4W2/+pJB0kRsdLIXcKkyhuiS76u/YjYMcB/6WbcWCzXiu
         MBdmgQr3yDAam0dcefkscVxeW5551w/E2SrfyhfToaMfh93zG4j6nhTD3dXOGJZVYtp4
         2IfLqYU/DYaj0SCRewPlto4BfG/iMDXSbt6msmE3NT8XP6nCEarDGqrHA21DfiH2+mqo
         M13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770258220; x=1770863020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPAGPooo/X3dpeBJpmDTPFwweJO68Ii9P/cjFAf7PTs=;
        b=PBA3ifstcTT5ZOJh4Wck6LPJLmFEnq2Bgy8BQS7ShbxOZavd/6ybFFXAxCoIy96VSo
         zUhO4OckeNEw3MFK5Q1K32KqW0Q7N1fn6fDe/KGqBgq5qbEAN8DJ/k4LfMCKspejN+Hz
         bsYMDA7qrk0GCsGGZGS2SkvMK0zG2YkLiAGhkwrQfxeFlCQEr9nUHPDFJl13xyryJZTM
         bOiNcfQL/86kaGUlyVDzI65NXUAc4r9jCEyZ3gUCZ0BbQv/172OYRWX7DKHxKiLszX4U
         NprDRFYcPl8sTeaPYFMsYbxEhC5eVVtlN2WKu89hYZNZoGMnFyE6ikCZVAXh1wGCcMrR
         21GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyFt5+/ydNrkpkIYkQWrYIMcifTAweEntOMumKPlQo3Q3EYp/Kkv4QfVD4LCNGVUVreWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YweC0oEAX0oYBC+LzQYNHDgy0XIETrgX3H2MJMe5ws6itQPOs0U
	Lzq2YfKlWwq3xMI1G/cCfFO3X1z8rM/KWFJtPDVsANGF1V9wx834rGocEwDklW5eExZ6vYr5RS3
	2KChJYQ==
X-Received: from plcl21.prod.google.com ([2002:a17:902:e2d5:b0:29f:fca:3bd4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a4c:b0:2a0:d431:930
 with SMTP id d9443c01a7336-2a933fe5cd9mr59743895ad.47.1770258219992; Wed, 04
 Feb 2026 18:23:39 -0800 (PST)
Date: Wed, 4 Feb 2026 18:23:38 -0800
In-Reply-To: <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
Message-ID: <aYP_Ko3FGRriGXWR@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70289-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4F775EDF1B
X-Rspamd-Action: no action

On Wed, Feb 04, 2026, Yan Zhao wrote:
> On Wed, Jan 28, 2026 at 05:14:40PM -0800, Sean Christopherson wrote:
> > @@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >  	 * the paging structure.  Note the WARN on the PFN changing without the
> >  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
> >  	 * pages are kernel allocations and should never be migrated.
> > +	 *
> > +	 * When removing leaf entries from a mirror, immediately propagate the
> > +	 * changes to the external page tables.  Note, non-leaf mirror entries
> > +	 * are handled by handle_removed_pt(), as TDX requires that all leaf
> > +	 * entries are removed before the owning page table.  Note #2, writes
> > +	 * to make mirror PTEs shadow-present are propagated to external page
> > +	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
> > +	 * external page table was successfully updated before marking the
> > +	 * mirror SPTE present.
> >  	 */
> >  	if (was_present && !was_leaf &&
> >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> Should we check !is_present instead of !is_leaf?
> e.g. a transition from a present leaf entry to a present non-leaf entry could
> also trigger this if case.

No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
tdx_sept_remove_private_spte() to fire:

	/* TODO: handle large pages. */
	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
		return -EIO;


And then later on, when S-EPT gains support for hugepages, "KVM: TDX: Add core
support for splitting/demoting 2MiB S-EPT to 4KiB" doesn't need to touch code
outside of arch/x86/kvm/vmx/tdx.c, because everything has already been plumbed
in.

> Besides, need "KVM_BUG_ON(shared, kvm)" in this case.

Eh, we have lockdep_assert_held_write() in the S-EPT paths that require mmu_lock
to be held for write.  I don't think a KVM_BUG_ON() here would add meaningful
value.

