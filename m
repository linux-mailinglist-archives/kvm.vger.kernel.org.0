Return-Path: <kvm+bounces-25717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90098969618
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:51:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EB142831FE
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A801DAC7D;
	Tue,  3 Sep 2024 07:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CgHcnG4u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCBE1CEADC;
	Tue,  3 Sep 2024 07:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725349886; cv=none; b=kinEBaK499YccIscSvukCilKwbsf7kQqnz6O61WtMt+JzACL5/SvZDIILDoDpsvmRMhHT8sge0AZrJdGUc5zP7gM4KeIHfvJwKG7Ao6eoZEj216U+4/TDWqLfZIKBq9dQHzT0C/qHJC0/nEHtx0e9h3+b+Vrm76h95vqw/QMIok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725349886; c=relaxed/simple;
	bh=6n+f+i9uiY1XYgNOjPwkQFM0Q4pTEHZu9wbUyjLXiEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDKm7UvDXaTaxbSgYiEFDiVmsfQ89FFsm/xRvdVeyfnMSFZKAerLukZ4yXE9kOl/c10/EsSHEmnIfl/lNQuBL9CpQthEd0yzGOs91QpALRdP0u8bD51xeMVUbHlYGVfNHIO3+6Tt0v6akZQD4pcHTQac8vhJ+ZVNT8ycfLNI/FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CgHcnG4u; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725349885; x=1756885885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6n+f+i9uiY1XYgNOjPwkQFM0Q4pTEHZu9wbUyjLXiEA=;
  b=CgHcnG4uxFafevshmh96eC/EJr3qC1BLlIW8zBd2e2F/NKupTgpEuCvn
   lakkZ979d83HXj4i9+sR6mYQxC1m2b89/zEcDe6/cDPW7Wo318cEjBXKW
   mCPJeTl+WCFs52abvtcI4BRyXZMVbrVIL0NVMvZwM3p8gnm7dsa0Hjkm6
   AIsWGkqugeGv6cQK7AWKYyR46/nOicgyCl+L/FaTCf9mTYy9X6s4SMpqu
   +p3eVrQrsIoVESGnmq5OcHEewGBMld/zF9OUzA5Vx/CUYOOjL7RacK6Hv
   qTnRXdUcV5vaUfuCNPLYDS3F1E289GgM5B5Kf2BLOu3Y1z8ORSKMC9OgJ
   Q==;
X-CSE-ConnectionGUID: stS37wkaQyCEMiz2vLk//A==
X-CSE-MsgGUID: Ys7WTTVHR8mEicW/srwYhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="27724413"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="27724413"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:51:22 -0700
X-CSE-ConnectionGUID: wsAWvkdZQ/mVCBR7PAkGxQ==
X-CSE-MsgGUID: id5D8xO8QgqeZorzJgiYaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="95549493"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:51:17 -0700
Date: Tue, 3 Sep 2024 10:51:12 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] KVM: x86: Filter directly configurable TDX CPUID
 bits
Message-ID: <Zta_8CWVPET-7O1x@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-25-rick.p.edgecombe@intel.com>
 <ZsLR8RxAsTT8yTUo@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsLR8RxAsTT8yTUo@yilunxu-OptiPlex-7050>

On Mon, Aug 19, 2024 at 01:02:41PM +0800, Xu Yilun wrote:
> On Mon, Aug 12, 2024 at 03:48:19PM -0700, Rick Edgecombe wrote:
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1086,8 +1086,9 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
> >  	return ret;
> >  }
> >  
> > -static int __maybe_unused tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
> > +static int tdx_get_kvm_supported_cpuid(struct kvm_cpuid2 **cpuid)
> 
> This func is already used in patch #21, put the change in that patch.
> 
> >  {
> > +
> 
> remove the blank line.
> 
> >  	int r;

Yes looks like that got removed in patch 25/25.

Tony

