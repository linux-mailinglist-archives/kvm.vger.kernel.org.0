Return-Path: <kvm+bounces-26496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 236D097506C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:05:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E172728DDFA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 11:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF7E188A1D;
	Wed, 11 Sep 2024 11:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UdCFLliG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE751185B68;
	Wed, 11 Sep 2024 11:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726052656; cv=none; b=oSD+/kf184cGq7PRRkbIujDS7hf9BWf2/xL2cATisDM8FqsdILu+h/6l8nR80/F7cTIMlIkc7j6/a5zcfzE5WxgDTpv28ZubhKuXCdLxhwIp1hVhAhKhkTbcP4PmDDiMpQdnRyqkXOtyOnX7nIEys5INYP+s+1l3RrQLNhZBFMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726052656; c=relaxed/simple;
	bh=63tlxJTpPIMy+FO/Rgfx6YxVpQEL0qxeUzDpU3gziZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcS6/TvFIY2IXdh7cyXqYO9gEVIE+b31L8wwzAwV9/0GrRrvgsFADZsrIIwmCKAz5JzCSxseBoN0ItpAo8powul5trtazyxyvPkFB0/bWYiHcPiwbjqXGEOSbuBEH+JhqOBSfm4PeKFklSA9NrnLD/bgh1uuz98BHunVW8R0rYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UdCFLliG; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726052655; x=1757588655;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=63tlxJTpPIMy+FO/Rgfx6YxVpQEL0qxeUzDpU3gziZ4=;
  b=UdCFLliGgKGt+zcymapnZ6H5mM3dsks5Ku9PdlANw/ODLY9IPmX7Rind
   fbVk6giIIje3ozmPMrQReDiyfJsKqpoIbZee/z/SgUGFaLIYxOZUU4fe7
   ay45KGe6tA9nJVia8iubhVI9jk0xW2QhONFZVsGihuwBBfO5hndfAuME5
   X2xr97yPmAi98zIi5Jeu6UpyIcJh1lFqDKjXTJjIilKG8+LSKzhqr9rzH
   5bnTM8pPX8ZaivdviLX+UKShOF+sSoldw3yw0MisxLRb2CwQ+M6Rjq27P
   ssiRyumLWMGsnqGPn5eshZdrvWQujn3WpadX+ixfXqkTXcepu3naub66T
   w==;
X-CSE-ConnectionGUID: /HpoKA3ERB6fzJhR34vMuQ==
X-CSE-MsgGUID: fzQTNfvMTBK51GlL4PPflg==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="36220602"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="36220602"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:04:14 -0700
X-CSE-ConnectionGUID: 2dGXu00sQ1OyAcfV/fFuEg==
X-CSE-MsgGUID: s98ZHqlIR6qiK0n/PzwLFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="98034498"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.117])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 04:04:11 -0700
Date: Wed, 11 Sep 2024 14:04:05 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nikolay Borisov <nik.borisov@suse.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <ZuFPBPLy9MqgTsR1@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
 <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
 <b3a46758-b0ac-4136-934b-ec38fc845eeb@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3a46758-b0ac-4136-934b-ec38fc845eeb@redhat.com>

On Tue, Sep 10, 2024 at 07:15:12PM +0200, Paolo Bonzini wrote:
> On 8/29/24 06:51, Tony Lindgren wrote:
> > > nit: Since there are other similarly named functions that come later how
> > > about rename this to init_kvm_tdx_caps, so that it's clear that the
> > > functions that are executed ones are prefixed with "init_" and those that
> > > will be executed on every TDV boot up can be named prefixed with "setup_"
> > We can call setup_kvm_tdx_caps() from from tdx_get_kvm_supported_cpuid(),
> > and drop the struct kvm_tdx_caps. So then the setup_kvm_tdx_caps() should
> > be OK.
> 
> I don't understand this suggestion since tdx_get_capabilities() also needs
> kvm_tdx_caps.  I think the code is okay as it is with just the rename that
> Nik suggested (there are already some setup_*() functions in KVM but for
> example setup_vmcs_config() is called from hardware_setup()).

Oh sorry for the confusion, looks like I pasted the function names wrong
way around above and left out where setup_kvm_tdx_caps() can be called
from.

I meant only tdx_get_capabilities() needs to call setup_kvm_tdx_caps().
And setup_kvm_tdx_caps() calls tdx_get_kvm_supported_cpuid().

The data in kvm_tdx_caps is only needed for tdx_get_capabilities(). It can
be generated from the data already in td_conf.

At least that's what it looks like to me, but maybe I'm missing something.

Regards,

Tony

