Return-Path: <kvm+bounces-11872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0737E87C6BE
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3944B1C2175B
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75A86AA0;
	Fri, 15 Mar 2024 00:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luqzFIDN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2449F4C80;
	Fri, 15 Mar 2024 00:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710462295; cv=none; b=MCp+IuNlRcwXBhNg2apfJoju6HpYQbdiWrDSWcnxptsOvgs3voTb300IWXzcXGeva5dwMaYZMpVSj2Ej/EMg9GGbGzsfWLZGzGf3E17JZGsuGdRvURms4T94eqwpJ7mtGSBpqd+yvlWS4v/EGkxJsq85k+i9D36Flgwh0JAcrlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710462295; c=relaxed/simple;
	bh=Jwy/unLAt9Zhejet2huLO9qy+XoBPa9uqAfZQ8cRmrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwV2c8YP8r/plHMyTuM2/EkeBplHOVOWhwH4bS+qFxpYNkrBt3pTPd8PVkR/Dpj5E3TpV+KK3UGRnW3YQJpRBqdzIOheVu6tmnQxx22adUBbBKCurvfb0siSxVmvQQFk7WSCw66+T/tP4Q7hkGhhQw+fVeqMFUKgWnMw2zFa8Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=luqzFIDN; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710462293; x=1741998293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Jwy/unLAt9Zhejet2huLO9qy+XoBPa9uqAfZQ8cRmrA=;
  b=luqzFIDNdztfjnu30pcZ0E1L781CesAZm9Cot2jisr3adItdCQS61Ki+
   b+UXxhBGuf6cyDzBIPRdSa7RKolWZhP6H0JGCC7Mtsq5WrPd/twbvTE0y
   fOFgPLSlu0CnnzhjllTzn52IQuXDvvmzmr8oVZ/KWUr0MEWDPa0parjVe
   rIp2+d5BKYxDJq0SIeN92Ynkddn2UEDadhyj7YQlMDobulAu4J4PdHegR
   AujTDrAyNFOyP6aknO//AbyUJfJfQPsPLhwmeaDyAhFzQp+7txwYSXZmX
   DTny9H22JzMXiVT9AU86pVyMFbbLMIcYutigJzQMVujUwIjK0txkCxYHe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="22774682"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="22774682"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 17:24:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="17077589"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 17:24:52 -0700
Date: Thu, 14 Mar 2024 17:24:52 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20240315002452.GD1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
 <20240314181000.GC1258280@ls.amr.corp.intel.com>
 <b0e82a9c262ba335cc27bc9921b8f86bb0a6676f.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0e82a9c262ba335cc27bc9921b8f86bb0a6676f.camel@intel.com>

On Thu, Mar 14, 2024 at 09:52:58PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Thu, 2024-03-14 at 11:10 -0700, Isaku Yamahata wrote:
> > > I think the point of putting these in a union is that they only
> > > apply
> > > to shadow paging and so can't be used with TDX. I think you are
> > > putting
> > > more than the sizeof(void *) in there as there are multiple in the
> > > same
> > > category.
> > 
> > I'm not sure if I'm following you.
> > On x86_64, sizeof(unsigned int) = 4, sizeof(atomic_t) = 4,
> > sizeof(void *) = 8.
> > I moved write_flooding_count to have 8 bytes.
> 
> Ah, I see. Yes you are write about it summing to 8. Ok, what do you
> think about putting a comment that these will always be unused with
> TDX?

Ok, will add a comment. Also add some to the commit message.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

