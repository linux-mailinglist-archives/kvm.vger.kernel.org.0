Return-Path: <kvm+bounces-19493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C13B905B33
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 20:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AFD2B20E94
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 18:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D3B57CAB;
	Wed, 12 Jun 2024 18:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="At6Tb0Q9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A13209;
	Wed, 12 Jun 2024 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718217548; cv=none; b=mYSAMfjAFzjcJs3Wroy6VcceyD6EkK7auu6TFE+81YKv50EKLOMmy11Ly/UBPCeTweNTMhGZcRPnX2OMn4ecXT2WtKCiWjMC3sGZodboA80mHlT9CeRSBrmYWdWd0sNFD5h+mnlj6wdwtTBAppSFepvvAeu3OT9FK6KEXjMZFSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718217548; c=relaxed/simple;
	bh=txRDCxXysbYoGs6KmB8gDyxdmCk1ImxdaQ0ie+Vtfbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpKbRjI5Ov4nym4UGZnHrP6yMl78QurGLzdg0TfgYQgs4XGqopXZl42FTd54XxRiY/C3VSv8M2TkIPPlCRzNHIReCNQTFroJ7ynB/81BrCiUyZSq1zjH6kok9OuTjwnVXc8V24fSTHbAcNe6p4JRpgNY9P2R3/dqm/JrOYq9Xj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=At6Tb0Q9; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718217546; x=1749753546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=txRDCxXysbYoGs6KmB8gDyxdmCk1ImxdaQ0ie+Vtfbo=;
  b=At6Tb0Q9wNmbqf7NZVwL6/ixeRELoeju0nlXKjpggETydT/aMjcTgIA7
   GkVf7Q1DdBJwxJ/BBXj6hLceyLIJbYYamSepZd9pjlLNpPmCCBkUaZyGJ
   RBmKSwPaxaghtdCizpA1KLcLvdK8PB1n4Oa/Z6d92SQ8DCp4VZaIl6jlG
   CTCTMzdvL3LHIRu46+wumgHI6MWKsDv7GPPnlAER4lVwDCbQi8rSKptug
   ZZWo+ObM2j0zCDf8SxBbR7jE5rGqu3Mih6X1DiAOkf+iagMQv3lFqVKkM
   z7Yt5COz0g5dnFefKB6dDyta6yz9IfgidbC0UomjR9MobLwZgckJ1FYDS
   w==;
X-CSE-ConnectionGUID: UW0MLy+VTxGYTr+4lcSNhg==
X-CSE-MsgGUID: KZYyuVTRR3iJyLkktaFKRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="15127735"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="15127735"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:39:06 -0700
X-CSE-ConnectionGUID: /XxSs6BUTA+G2qwONlbcdw==
X-CSE-MsgGUID: aA7HezJKRcWLdGIR5kNPtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="45002458"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 11:39:05 -0700
Date: Wed, 12 Jun 2024 11:39:05 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
Message-ID: <20240612183905.GJ386318@ls.amr.corp.intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
 <20240530210714.364118-12-rick.p.edgecombe@intel.com>
 <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
 <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>

On Fri, Jun 07, 2024 at 09:46:27PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> > /* Here we only care about zapping the external leaf PTEs. */
> > if (!is_last_spte(old_spte, level))
> > 
> > > +       kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > > +       int ret;
> > > +
> > > +       /*
> > > +        * Allow only leaf page to be zapped. Reclaim non-leaf page tables
> > > page
> > 
> > This comment left me confused, so I'll try to rephrase and see if I
> > can explain what happens. Correct me if I'm wrong.
> > 
> > The only paths to handle_removed_pt() are:
> > - kvm_tdp_mmu_zap_leafs()
> > - kvm_tdp_mmu_zap_invalidated_roots()
> > 
> > but because kvm_mmu_zap_all_fast() does not operate on mirror roots,
> > the latter can only happen at VM destruction time.
> > 
> > But it's not clear why it's worth mentioning it here, or even why it
> > is special at all. Isn't that just what handle_removed_pt() does at
> > the end? Why does it matter that it's only done at VM destruction
> > time?
> > 
> > In other words, it seems to me that this comment is TMI. And if I am
> > wrong (which may well be), the extra information should explain the
> > "why" in more detail, and it should be around the call to
> > reflect_free_spt, not here.
> 
> TDX of course has the limitation around the ordering of the zapping S-EPT. So I
> read the comment to be referring to how the implementation avoids zapping any
> non-leaf PTEs during TD runtime.
> 
> But I'm going to have to circle back here after investigating a bit more. Isaku,
> any comments on this comment and conditional?

It's for large page page merge/split.  At this point, it seems only confusing.
We need only leaf zapping.  Maybe reflect_removed_leaf_spte() or something.
Later we can come back when large page support.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

