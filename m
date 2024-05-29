Return-Path: <kvm+bounces-18249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E17848D29E6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A2F21C22B65
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C8215A878;
	Wed, 29 May 2024 01:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jMKXZqRJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B737A632;
	Wed, 29 May 2024 01:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716945886; cv=none; b=BQC9oah/SlDedKTYyERjH9f4uP3TmCiCK6VQ6ba5iV/rJBX1opmfUzHd026ZmSQPdBwSyL7hB2shgAkTHxTpelywBHhvNeXnnkXzygMwDIkqACUnFLF5DLTzVTr4t+hTA5QGxHuDfqJAEzXlkEM05lUI6CFz0QmMDc6alef9D4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716945886; c=relaxed/simple;
	bh=h17TCwO7J8oz04t/BLJj158cBfXMx//CHvgnp7zRR30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCv6f7DffjK/BJXFojdlZc6nkhrDfchbW91ZvuedSR2gY5ny7rjsjq+DDKtV79im9Y5vChA0RQJOI1iHCN95H+dJJto3tEG0vfu4lhDPOLDWflBCne6+z9nM33tVucIqeAOQQoe3LFrROk4IqSxkhrjO/QtNCz+jDTp84BDaa6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jMKXZqRJ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716945885; x=1748481885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=h17TCwO7J8oz04t/BLJj158cBfXMx//CHvgnp7zRR30=;
  b=jMKXZqRJ8HeQA9n4VsViTxuwlbrJP+kilXXqbjbfa7sTNqPOAUiQvlMe
   j7SQV5TprMu8dkGP9gIRYobHjB+kwj/nZc3+xh9x5dZp4tmr4CLJKKx4V
   TkeF04imbEqSjBvHkJd45I50sosnQgjI7PE/NRb/S5RbGM37Y77YAyTg/
   7zFdhKuotvv5lLVEv4Bh/yrV88N9bv//ZA/bRvte3y6wxDdkkppvrLZyn
   KMYCFMrN6r8T8Cb+uqPTvzGsfgzoYLXaC1IOMTXwB13/8+62MfWGzHb0c
   2/UdJq69k3iETLDP1R5vbm4wAS0O9C/5r1alKJEsiJMS2P/uSUyRzenBU
   g==;
X-CSE-ConnectionGUID: Lz32YKi7QZC0e7lC5wesCA==
X-CSE-MsgGUID: Z1QQJdRvRz+iofBfBjs1tA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13509623"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13509623"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:24:44 -0700
X-CSE-ConnectionGUID: FxV3x9RcT+GXTtPwt8Htrw==
X-CSE-MsgGUID: ClJDGNrWQZORNSK9Wv888A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="35727802"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:24:44 -0700
Date: Tue, 28 May 2024 18:24:43 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529012443.GE386318@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <36a1b5d239bdbca588625a75660406c1b5ea952a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36a1b5d239bdbca588625a75660406c1b5ea952a.camel@intel.com>

On Tue, May 28, 2024 at 08:54:31PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-05-14 at 17:59 -0700, Rick Edgecombe wrote:
> > +static inline int __tdp_mmu_set_spte_atomic(struct kvm *kvm, struct tdp_iter
> > *iter, u64 new_spte)
> >  {
> >         u64 *sptep = rcu_dereference(iter->sptep);
> >  
> > @@ -542,15 +671,42 @@ static inline int __tdp_mmu_set_spte_atomic(struct
> > tdp_iter *iter, u64 new_spte)
> >          */
> >         WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
> >  
> > -       /*
> > -        * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
> > -        * does not hold the mmu_lock.  On failure, i.e. if a different
> > logical
> > -        * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
> > -        * the current value, so the caller operates on fresh data, e.g. if it
> > -        * retries tdp_mmu_set_spte_atomic()
> > -        */
> > -       if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
> > -               return -EBUSY;
> > +       if (is_private_sptep(iter->sptep) && !is_removed_spte(new_spte)) {
> > +               int ret;
> > +
> > +               if (is_shadow_present_pte(new_spte)) {
> > +                       /*
> > +                        * Populating case.
> > +                        * - set_private_spte_present() implements
> > +                        *   1) Freeze SPTE
> > +                        *   2) call hooks to update private page table,
> > +                        *   3) update SPTE to new_spte
> > +                        * - handle_changed_spte() only updates stats.
> > +                        */
> > +                       ret = set_private_spte_present(kvm, iter->sptep, iter-
> > >gfn,
> > +                                                      iter->old_spte,
> > new_spte, iter->level);
> > +                       if (ret)
> > +                               return ret;
> > +               } else {
> > +                       /*
> > +                        * Zapping case.
> > +                        * Zap is only allowed when write lock is held
> > +                        */
> > +                       if (WARN_ON_ONCE(!is_shadow_present_pte(new_spte)))
> 
> This inside an else block for (is_shadow_present_pte(new_spte)), so it will
> always be true if it gets here. But it can't because TDX doesn't do any atomic
> zapping.
> 
> We can remove the conditional, but in regards to the WARN, any recollection of
> what was might have been going on here originally?

We had an optimization so that there are other state in addition to present,
non-present.  When I dropped it, I should've dropped else-sentence.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

