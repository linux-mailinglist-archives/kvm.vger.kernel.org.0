Return-Path: <kvm+bounces-25320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ECE59639B7
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3826A1F25236
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6101487E9;
	Thu, 29 Aug 2024 05:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TOk0ZZks"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C1481CE;
	Thu, 29 Aug 2024 05:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724907638; cv=none; b=ojC93OmUtaCgxAlkB7WgTj9cYH3Vw3/dukt8qWvCPZoCBszABwIWyQrrJSEXm/McCPpTypxuUVOgVu6GRb0S8jftgiTKZZSnqr4WKB3npX6GlxcgtQEz7exwAdFzyPYaGBJ+KqoeZeP5rSt58KOIkWZaeaVBL+Gspnn0V8zgL9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724907638; c=relaxed/simple;
	bh=83/fKrNVuC1X4pmCI4/kp0Fd1fZEJFnYRelSbFykTjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CluR/mopVf7P3EzbCaxKY1jIsN1ZmV316/eoTyBbA/j8Srhd7t7x8EMBblT4DQ34Gthf17gcBGo5FLpLe+xAkMoQLUCQde5dNUxkX4wfOoqWFLrKTbBIZmtw86X9u2Qr1HcJ7jBh0O0sz+jhgdsaNOgwd8yYtUs2zs9jYiOW9A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TOk0ZZks; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724907637; x=1756443637;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=83/fKrNVuC1X4pmCI4/kp0Fd1fZEJFnYRelSbFykTjI=;
  b=TOk0ZZksDQ5GGsLjOqAeE9DMMQKqGazMTyMJl+glh+MxAoO8UkNrqPo5
   UHEb0bvZSK8ubNTaAjiUr+eMftxL8B74Obv7id/4lq8DQT8aj6flp5WBq
   mYbyW90BjMBX1LRgXe4k48zCXY4YKqdlazO/IBl4lIFmZIOoXrvjqjH0A
   1/h4pZENyaryRt6k2aUduy2yBoN4gvXKh4SZPNu9026fnwfdvCRIWWh/e
   SxqlR5XC0ycky47FdqbEmEw0QeE2Anm87Eng7FjGBh3FofcFVG0EKonu+
   LTJuEYXRYV0mCX4XCw5NvFCVtauUZv9LsRbDiLfZs2cLs5CWKzfD0K8o2
   w==;
X-CSE-ConnectionGUID: PTY7apmUSw+0D6sM36Obww==
X-CSE-MsgGUID: CBn+oSrHQOW46aMNTLduEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="23663063"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="23663063"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 22:00:36 -0700
X-CSE-ConnectionGUID: rSF4E554Rxe99H4zZBEkRg==
X-CSE-MsgGUID: +JOX/46yRqucWe2L9TZuFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="68118938"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.198])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 22:00:32 -0700
Date: Thu, 29 Aug 2024 08:00:23 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
Message-ID: <ZtAAZzBCIuZ3jsuA@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-18-rick.p.edgecombe@intel.com>
 <4fcff880-30e2-44f8-aa45-6444a3eaa398@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fcff880-30e2-44f8-aa45-6444a3eaa398@suse.com>

On Mon, Aug 19, 2024 at 07:46:13PM +0300, Nikolay Borisov wrote:
> On 13.08.24 г. 1:48 ч., Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -377,6 +377,47 @@ int tdx_vm_init(struct kvm *kvm)
> >   	return 0;
> >   }
> > +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > +
> > +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> > +	if (!vcpu->arch.apic)
> > +		return -EINVAL;
> 
> nit: Use kvm_apic_present()

Thanks will do a patch for this.

Regards,

Tony

