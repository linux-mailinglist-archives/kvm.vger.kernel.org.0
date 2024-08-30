Return-Path: <kvm+bounces-25461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E240A9657E4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:00:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0775284E03
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6A4154455;
	Fri, 30 Aug 2024 07:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EwPoVVx7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEFD14C59B;
	Fri, 30 Aug 2024 07:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725001208; cv=none; b=D9hIwPN/584+7Y7Ub4vsdfpbp5YpD61nnxZT4C195IzHYOXbhBtbIEaVDDBIP+zLKHWmlFa7K/RPiwiZu49Dvyjhn3Hk22EotsoiGqEo+Btv/36nNVaMUqpI36V1Y1g9iN0/e7sqhlOfrNqsVE1hZD1nhgOA8Cobm8YXtoF/PVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725001208; c=relaxed/simple;
	bh=Bx9D6+1+1wG5CyMx7IYqqPKfoDF4vg4aTCvo2szaC3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFbii34YQJZ6A7KyyEfcSKIqRMjwfAwKjRw3SrUbwYtx/XYHuVopYfpkGljs57leBB7lQ8QovdEbN0ZXfda9gewIkKRb1A4L7THSeJYNXDyq5pSPrm/uNk2MwFubiqsg4BIZmU5DHCxzcROo2SxekY3gftElPxDSaa8qSX8l8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EwPoVVx7; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725001203; x=1756537203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bx9D6+1+1wG5CyMx7IYqqPKfoDF4vg4aTCvo2szaC3E=;
  b=EwPoVVx7Kg5T+Ampqm4x5jetAiwQDv1gk13WGNUgUZsTpEvgPd+STIS6
   y6XC8iea4teizIH2YVbC3//ot6hytdu8XvY3/mj2vLgTkXmJZ7BGRqoSZ
   zaYidfSs2rkBHj0DWnRq0KlZdJfX0MFtPB8jJM1/0l7g/4XBIr2WUDBE5
   KYYh/oHuleeIy4vJu3foLmMwxkemkdJSEzz/eP8+o4/R3QEu2vAMYyk2r
   0aRYBpTrWS0+lcP6Ej6Ry7QzYlWYKCjzGpbK7tXBRq81x9uSXMiXKug4e
   H793y/ahsuDDkNpKmKbLd8i5MUROBmsrZ7SVj4wFZvYXb1DWHWFECKPOr
   w==;
X-CSE-ConnectionGUID: 51yE/8NRRq2Heb4FXBwIHw==
X-CSE-MsgGUID: VSKh50KJQ3GyuvjHNboqrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27508830"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="27508830"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 00:00:02 -0700
X-CSE-ConnectionGUID: 5mREBznMThe2T87jFH5kSA==
X-CSE-MsgGUID: PeYJRNsfTTW1nfdPYP9P3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68649361"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 23:59:57 -0700
Date: Fri, 30 Aug 2024 09:59:52 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
Message-ID: <ZtFt6Ehhdh2ruJtL@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
 <42d844c9-2a17-4cb0-8710-328e7774b4d4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42d844c9-2a17-4cb0-8710-328e7774b4d4@linux.intel.com>

On Tue, Aug 13, 2024 at 02:47:17PM +0800, Binbin Wu wrote:
> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3,6 +3,7 @@
> >   #include <asm/tdx.h>
> >   #include "capabilities.h"
> >   #include "x86_ops.h"
> > +#include "mmu.h"
> 
> Is this needed by this patch?

Needed but looks like it should have been introduced only in patch
"KVM: x86: Introduce KVM_TDX_GET_CPUID" for kvm_gfn_direct_bits().

Regards,

Tony

