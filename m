Return-Path: <kvm+bounces-18248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 759F18D29D6
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1911F250FD
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2329415ADA8;
	Wed, 29 May 2024 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZOBzO3w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E6B15AAB8;
	Wed, 29 May 2024 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716945373; cv=none; b=IzPudMzU8qg3ktgqokkw+2EIgD5nJAn30GU8XgZKCGmD1P6OIndQGO8vrpq2nawcfjloJbkVwWUD0LtPM1adF7gZxIz7MjPidqKQFN9CwjXULpels8yikYoBLH4nDG6Wji9jlQTaUbdlns1e6MCTQWkNJT0lzGpukyHx3Ueh9zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716945373; c=relaxed/simple;
	bh=X6eKSJId4PnbR29PlohmOfwdfESIOrzsPzvWL9z8YwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovmlSUKkHWCgM9IbZCrdOI/b+X1BnRiiagTdDJLwW2hMWmIAh4SuOU/MXZ1YANggSt2mSvCXECBDZK4ctNmCIBgyO0vYjzo93hmXY/vkJGXajbLVcUgHdEGY9RewQKlJADjlpb+Y9K4TtYjfurBqqPY8E4Ne1hSMu5aLtLHYYCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZOBzO3w; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716945371; x=1748481371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X6eKSJId4PnbR29PlohmOfwdfESIOrzsPzvWL9z8YwA=;
  b=NZOBzO3wpabN1awWApwNC7k80rih9Fqgsa0parwPWYGdzFxeTPjBjeN6
   YCT9aUVgM6WGVq/5ldmfygmRUbWqhNkXsqlix4+IUt6VpfYwaJLBSSa6y
   0Nh9IIHt2M8FSOfuWKwrm2rU3/WO7iD4rlnKfDgbCmCLB1E+JeZgM8MHt
   fU9KmGE8Kx7Ykjw5iI9wKzFPj4P3EjRfz/GEBEXJKZTDvljuKA7PXXh62
   JJ3nBrB37pJL0YOsCSRsbsWZAWlz3LFl1WrO0q/b/6+WYGd/IYkvEda4j
   npwYUODQGvo1V7OFwLN5uSKoWADJqSvDEezEx3NX857+3/9grcWyq53fw
   Q==;
X-CSE-ConnectionGUID: 5VWDJTspSM6pLVyy3Jm5pQ==
X-CSE-MsgGUID: Mz5uUd2QRLWVrA0aDubjrw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13146363"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13146363"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:16:10 -0700
X-CSE-ConnectionGUID: HUY80etjTZ6dUxDCo3rhIA==
X-CSE-MsgGUID: AcQgqI7FRC61DAX6K7/Bzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="66106689"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 18:16:10 -0700
Date: Tue, 28 May 2024 18:16:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240529011609.GD386318@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <6273a3de68722ddbb453cab83fe8f155eff7009a.camel@intel.com>
 <20240524082006.GG212599@ls.amr.corp.intel.com>
 <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c8cb0829c74596ff660532f9662941dea9aa35f4.camel@intel.com>

On Tue, May 28, 2024 at 09:48:45PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Fri, 2024-05-24 at 01:20 -0700, Isaku Yamahata wrote:
> > > 
> > > I don't see why these (zap_private_spte and remove_private_spte) can't be a
> > > single op. Was it to prepare for huge pages support or something? In the
> > > base
> > > series they are both only called once.
> > 
> > That is for large page support. The step to merge or split large page is
> > 1. zap_private_spte()
> > 2. tlb shoot down
> > 3. merge/split_private_spte()
> 
> I think we can simplify it for now. Otherwise we can't justify it without
> getting into the huge page support.

Ok. Now we don't care large page support, we can combine those hooks into single
hook.


> Looking at how to create some more explainable code here, I'm also wondering
> about the tdx_track() call in tdx_sept_remove_private_spte(). I didn't realize
> it will send IPIs to each vcpu for *each* page getting zapped. Another one in
> the "to optimize later" bucket I guess. And I guess it won't happen very often.

We need it. Without tracking (or TLB shoot down), we'll hit
TDX_TLB_TRACKING_NOT_DONE.  The TDX module has to guarantee that there is no
remaining TLB entries for pages freed by TDH.MEM.PAGE.REMOVE().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

