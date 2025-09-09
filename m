Return-Path: <kvm+bounces-57098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4934AB4AB0F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64D0718946CB
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F9131D72A;
	Tue,  9 Sep 2025 11:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GT8ZvnTx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C2128AAEB
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 11:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757415950; cv=none; b=PHrNacS/sLfs9EKlCHrHqxQABqHCvpt/BNwqmJQlXZaCwKJFbYGfnYgpy1LYVPrpAVK0ASoRcTQyEKRt5TWLu6zc2TdilOQ03f/2YGcScqPNd43qXiCY2211EsU+gCfRTa9ONnD8d7OrlY9Dv5akNKWt1JiZ+Wcor58HC2Genwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757415950; c=relaxed/simple;
	bh=xHHjqlqgTlKvT/wvk5PXIcZjLzGRtKEzzkdVAuE1B9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mq2dN+W/jfgNpKhypf9B2CivVPqLwfNrFXnSsP6QvXCg3PR6emnoOyk2CTcrZryjs6QhHvgp2AQv81M3K3LIYxIlKZiJTasIJ5mb3CCSiICF3AaNcie1BpUIqb+V49a8IMrdtblvU+FLnTFhNAKW9DvA1s9SyntY1/yGW0jvJ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GT8ZvnTx; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757415949; x=1788951949;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xHHjqlqgTlKvT/wvk5PXIcZjLzGRtKEzzkdVAuE1B9s=;
  b=GT8ZvnTxtFCWBSVF9jHQUpFSI/+xvxzyF5/g/ta2bvVKlD5URCBRGp1E
   jl8RStNejuFdsuJE5G+d+Dc4oTkS6n6O90kAodtwdSIqY9XTjncURmGB4
   4xrvMQSAnn+gwIdzdxGWe4DG4NMOh9O8TFUw0AkDXuqOjxrAD+Tx+aGIz
   PZBqozNJ1S8BmOwGpS6MOXnCnWZsrPp3TqjAOdOxJdq3XEvgOdBQPEElg
   9R7HyEoZpyDulnnQj204Wpr06a25E5WtBv7YtDAbMfPfhLtx3dNztXxdF
   GSe+h5/QZI0yY+8MnjwRQm3ZuDbZn1i5cavFjMvNpxFmfTwInBoPu6PVq
   Q==;
X-CSE-ConnectionGUID: eVrqA1apQm+tcmzwaQg0wg==
X-CSE-MsgGUID: dKYlrYWITVi1G6rSfRH49A==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="71112892"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="71112892"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 04:05:49 -0700
X-CSE-ConnectionGUID: n+Fs03o2Q1WdHs3zKIdwVQ==
X-CSE-MsgGUID: bi4mtYMFR9Cve71UJ40CBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="173442089"
Received: from carterle-desk.ger.corp.intel.com (HELO localhost) ([10.245.246.29])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 04:05:45 -0700
Date: Tue, 9 Sep 2025 14:05:41 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for
 __tdx_bringup()
Message-ID: <aMAKBUAD-fdJBhOD@tlindgre-MOBL1>
References: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
 <20e22c04918a34268c6aa93efc2950b2c9d3b377.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e22c04918a34268c6aa93efc2950b2c9d3b377.camel@intel.com>

On Tue, Sep 09, 2025 at 10:55:18AM +0000, Huang, Kai wrote:
> How about we just initialize r to -EINVAL once before tdx_get_sysinfo() so
> that all 'r = -EINVAL;' can be removed?  I think in this way the code
> would be simpler (see below diff [*])?
> 
> The "Fixes" tag would be hard to identify, though, because the diff
> touches the code introduced multiple commits.  But I am not sure whether
> this is a true issue since AFAICT we can use multiple "Fixes" tags.

Your diff looks fine to me, however my personal preference would be to do
the fix first then clean-up :) 

Regards,

Tony

