Return-Path: <kvm+bounces-13402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE92895EF2
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 23:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 832D628699E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 21:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C86B15E802;
	Tue,  2 Apr 2024 21:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mli6n7xJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137AD15E5DC
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712094605; cv=none; b=A7DTFQ6OPkBM9V8h0roeresNvM9yZDdrsqR9SXJzU/P7Xa461yCmN/CK2vEEHsKcjCbw7WTxrig5E0L4WFFMLoi0PERhZfhUipDAQrl3kiv/hJJQQ6Y728zNm1TKrdX7I6wISl56987vEl4B26krp3ndc4Ukfy7rQ/ezOv2EprA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712094605; c=relaxed/simple;
	bh=Uvkgx7W/GzX0GWvB+qq7IACzj9NPpV596U6aIw7O7ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9dJAcwxC54KFPtlhkTXtNjHaoRv5uaH0VTkOAU5joKZlbnt1O5MxSlayWQh+k/UOgzKGG0mvUGTWNXxjuiEIw3BRQVU1gfeGfLsUzzG4WzUdvljLOZzs+zLIwHkOEJY4bDxvULXcY+DrMnC1Jozh0PKN2kdwufbgaBQgRdmqmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mli6n7xJ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712094604; x=1743630604;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Uvkgx7W/GzX0GWvB+qq7IACzj9NPpV596U6aIw7O7ws=;
  b=Mli6n7xJOU359o0HOjW0btAT4uCn9jdSQXLLBhmVc2zm3+76Jw68D2cj
   l+H5iN+hrjlAkl9+QqScFK1MgF9OVkkXshd5mdGoHtAbW0OKD8480wGs8
   7cRBBYEeEJxUVQ3fbtoWevPyRmBvoEp+3cZfFD70qejwQxusqNCnPs20Z
   xz5M0kNqsTBcKW4MLAcQ+mB3icWpDZ5roBonkw5Bxp3Se8hNNfRKzfP4a
   BkFDAZ7xRD+kG0HDyL7dq4qrWwNWi9cjkz6lL+hptbrKAryafW0sQoemV
   M2h/hlEYWsZ+4+0tMDd9aWNkdrCGAFXYoeFgbpNEruObyr31X2P/sJf6Q
   Q==;
X-CSE-ConnectionGUID: /7e+Mb/VSDaBj0tj6rbaHg==
X-CSE-MsgGUID: Hlj4Zz2zQ6akipcleSrF6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="24753649"
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="24753649"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 14:50:03 -0700
X-CSE-ConnectionGUID: OCHICaIYQVy6RqrvoplvLg==
X-CSE-MsgGUID: svNsW9D+T9Ca43AVthsQJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,176,1708416000"; 
   d="scan'208";a="22674694"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 14:50:03 -0700
Date: Tue, 2 Apr 2024 14:50:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
	linux-coco@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH gmem 2/6] KVM: guest_memfd: Only call
 kvm_arch_gmem_prepare hook if necessary
Message-ID: <20240402215002.GA2444378@ls.amr.corp.intel.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
 <20240329212444.395559-3-michael.roth@amd.com>
 <297fd9b8-9321-40e3-816b-2de92cb1a3ae@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <297fd9b8-9321-40e3-816b-2de92cb1a3ae@linux.intel.com>

On Mon, Apr 01, 2024 at 01:06:07PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 3/30/2024 5:24 AM, Michael Roth wrote:
> > It has been reported that the internal workings of
> > kvm_gmem_prepare_folio() incurs noticeable overhead for large guests
> > even for platforms where kvm_arch_gmem_prepare() is a no-op.
> > 
> > Provide a new kvm_arch_gmem_prepare_needed() hook so that architectures
> > that set CONFIG_HAVE_KVM_GMEM_PREPARE can still opt-out of issuing the
> > kvm_arch_gmem_prepare() callback
> 
> Just wondering which part has big impact on performance,
> the issue of kvm_arch_gmem_prepare() callback or the preparation code for
> the kvm_arch_gmem_prepare()?

I'm fine without this patch for now baecause this is optimization.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

