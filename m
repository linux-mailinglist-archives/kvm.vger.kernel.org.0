Return-Path: <kvm+bounces-46671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B9BAB8252
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:18:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AFEA1B62C1E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F35297A44;
	Thu, 15 May 2025 09:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TAAKWTVl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6800296721;
	Thu, 15 May 2025 09:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747300675; cv=none; b=Fzpbc/DSSJGJKsDlokEnLMzu04lm7vkqGQ54E544gwmqimyx9cAkffGyA6YLmAeMxOP+6M1MHdozgf15EEO0Tn2Qs0hwCV2OQ6YxZcYu+QW0KOMejSuMa4wt9pP2904353eCpNWqjcxn6cpAPPZ2rh27kuagjIUwwEExv+KVgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747300675; c=relaxed/simple;
	bh=16mrttDqkGMk1xuXFQG657d/rNSJ7Kzc97AIqHURTrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r29NV780ABWX92ZIHtxOSHNfqytVZPzDjRaY6fjS6lwAoU0dMjzv+OI6emBBL980AIiL3KNTui1QwptOibbKike7eJFDDB/PeoPakLqe12pA7BvADdAtFqgvNMZeuK0m2nS3qGJZl41DXJl3t+ZZxAp6H1Q7cPKB45jjGfLaUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TAAKWTVl; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747300673; x=1778836673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=16mrttDqkGMk1xuXFQG657d/rNSJ7Kzc97AIqHURTrE=;
  b=TAAKWTVlH+V0B3QwDNEti0oMOgdoMzzTGEPGZjUtM2yo154JpcU9N7BV
   PqivtjYdTzH9eLTvfXOKL+hu/r+vKzE8kxPjmg1cGKJ31QlF4ubgJ52gK
   NlVKUnOmRobt81d8qaPR+Gg9cQ55ICnajOjOrk0nCZmryvpDbx456o2f+
   oB3uA41e7d3lSn2qocM3uh5IWexizA3XT2HLoHr2lTfiVfzfMjZwQjnOg
   TmP80Ue92i/GLMjQf9FrhXqBxzj4kKXfnE9SXEkqGOMowxTlSbMXsrEhl
   LnVEKFMXDjT8A6J83ww0SPCsKY5hNbBl6c9X5LljwEpVxUihcvk7jvRA2
   g==;
X-CSE-ConnectionGUID: gMo4miBvQb+mHSYutR86yw==
X-CSE-MsgGUID: tfOTcYO6RzO28mZiPaUWsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="71736308"
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="71736308"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 02:17:53 -0700
X-CSE-ConnectionGUID: OCO+lFPURlqDfj1aLOv1HA==
X-CSE-MsgGUID: 3MOaRAPPSkufbH7Xzg3BIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,290,1739865600"; 
   d="scan'208";a="143502817"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa004.fm.intel.com with ESMTP; 15 May 2025 02:17:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id F25E923F; Thu, 15 May 2025 12:17:47 +0300 (EEST)
Date: Thu, 15 May 2025 12:17:47 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Zhi Wang <zhiw@nvidia.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] TDX: Enable Dynamic PAMT
Message-ID: <pvcetnkt2qvxikcneh2ojszrytwenmagvjc33swd3q23hcftf4@nxqi73f57w6b>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250514233317.306f69f9.zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514233317.306f69f9.zhiw@nvidia.com>

On Wed, May 14, 2025 at 11:33:17PM +0300, Zhi Wang wrote:
> On Fri,  2 May 2025 16:08:16 +0300
> "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > This RFC patchset enables Dynamic PAMT in TDX. It is not intended to
> > be applied, but rather to receive early feedback on the feature
> > design and enabling.
> > 
> > From our perspective, this feature has a lower priority compared to
> > huge page support. I will rebase this patchset on top of Yan's huge
> > page enabling at a later time, as it requires additional work.
> > 
> > Any feedback is welcome. We are open to ideas.
> > 
> 
> Do we have any estimation on how much extra cost on TVM creation/destroy
> when tightly couple the PAMT allocation/de-allocation to the private
> page allocation/de-allocation? It has been trendy nowadays that
> meta pages are required to be given to the TSM when doing stuff with
> private page in many platforms. When the pool of the meta page is
> extensible/shrinkable, there are always ideas about batch pre-charge the
> pool and lazy batch reclaim it at a certain path for performance
> considerations or VM characteristics. That might turn into a
> vendor-agnostic path in KVM with tunable configurations.

It depends on the pages that the page allocator gives to TD. If memory is
not fragmented and TD receives memory from the same 2M chunks, we do not
need much PAMT memory and we do not need to make additional SEAMCALLs to
add it. It also depends on the availability of huge pages.

From my tests, a typical TD boot takes about 20 MiB of PAMT memory if no
huge pages are allocated and about 2MiB with huge pages. The overhead on
its management is negligible, especially with huge pages: approximately
256 SEAMCALLs to add PAMT pages and the same number to remove.

The consumption of PAMT memory for booting does not increase significantly
with the size of TD as the guest accepts memory lazily. However, it will
increase as more memory is accepted if huge pages are not used.

I don't think we can justify any batching here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

