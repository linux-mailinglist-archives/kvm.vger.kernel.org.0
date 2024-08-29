Return-Path: <kvm+bounces-25318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 959B5963986
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C87681C21C6C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 04:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CB11487F1;
	Thu, 29 Aug 2024 04:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpKpL6gE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75EB7581F;
	Thu, 29 Aug 2024 04:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724907121; cv=none; b=pQD4kGBUSBkM4OjlPr8OOG30pdEOTjGlF1PwMXWnDOToAixiRU0zL0FFTmltyofAVEluQ1CSGjyTOgSSM4SGGpd6x24IraNucqQDyubE73kJ/iNsKGuXkb2spQLb5jxgxNAv6Vi9QIys6WY4I91aKxlaBXdgQrqA0pVWDkt3QPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724907121; c=relaxed/simple;
	bh=WaZKLhi2JY5mxFC5iByEt/Wb3qK4TM0N4HwIuzX2Kik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tT7zu96sc39XB274zmDx3PGq9honmDjaWRc9w8z+1ZrD6/YDM53A/f7JtehE3s00GSSgn14gjq7Jjp/imb2khDOMvsLJY+En1uR+OGhDQiDkUMbRi5YbKYd4DfbKgdHJsTSUqg2iAV6f/n0JRzzKICaFJOpdI4JE5/eLV5ecTyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpKpL6gE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724907120; x=1756443120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WaZKLhi2JY5mxFC5iByEt/Wb3qK4TM0N4HwIuzX2Kik=;
  b=BpKpL6gEDO3etBNNVQdw9vb5jimnKK+D3Nh5gNby9DEs6ieIPMRNWQkD
   Msr5a6NPpu6eRh3dGC5WWyOo31SJllvYRll5KVLL+hDvU7Vy2HsEumCAn
   8XmYWoMdELGLfGA4+5Yoo6OiYZJis24kLAK7rW+clxQ4MiLV6dOHZ4Vof
   yAD0nXUlTCwGqnIWIV3hmVVKvaxppG7v61ex2hvdeSTC0e5O1iXn8+Vum
   84YINDaTud/VGeADhq8phHhV5zjpmpHJX2HYPIz5ZpMXUC8BhScXwboSA
   SVP1Y2+aLCcGdwY82N/9YjpYjE6tS5HIRPFKSV5nCDUHpFsh6GIqgxo1r
   Q==;
X-CSE-ConnectionGUID: ZGAkIsR4QTOS9f+S9JWjsA==
X-CSE-MsgGUID: /yWaMTiKQqmFoz0QLvmfPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="23360230"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="23360230"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 21:51:59 -0700
X-CSE-ConnectionGUID: pDhZHg0zTtGJocqr+XHCaQ==
X-CSE-MsgGUID: drmNX1dISdWd0whYKzaVlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="63640588"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.198])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 21:51:55 -0700
Date: Thu, 29 Aug 2024 07:51:46 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Message-ID: <Zs_-YqQ-9MUAEubx@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
 <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8ed694f-3ab1-453c-b14b-25113defbdb6@suse.com>

On Mon, Aug 26, 2024 at 02:04:27PM +0300, Nikolay Borisov wrote:
> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> >   static int tdx_online_cpu(unsigned int cpu)
> >   {
> >   	unsigned long flags;
> > @@ -217,11 +292,16 @@ static int __init __tdx_bringup(void)
> >   		goto get_sysinfo_err;
> >   	}
> > +	r = setup_kvm_tdx_caps();
> 
> nit: Since there are other similarly named functions that come later how
> about rename this to init_kvm_tdx_caps, so that it's clear that the
> functions that are executed ones are prefixed with "init_" and those that
> will be executed on every TDV boot up can be named prefixed with "setup_"

We can call setup_kvm_tdx_caps() from from tdx_get_kvm_supported_cpuid(),
and drop the struct kvm_tdx_caps. So then the setup_kvm_tdx_caps() should
be OK.

Regards,

Tony

