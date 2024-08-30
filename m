Return-Path: <kvm+bounces-25456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BB996571F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 07:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2378B1C229E0
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 05:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F01E14F9DC;
	Fri, 30 Aug 2024 05:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eL3vLcNR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4191487F1;
	Fri, 30 Aug 2024 05:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724997191; cv=none; b=DxxCiuIrOrYuJj1qnJSJPoOIOxXtgaph0IqCYLIj2BEmUageVX87ZmxnwM0WcZMnuu2fgQ36LrAOkfAp8EyPfpQOilig9LSL2Bu7l5+9Qib6hjRgS1w5pAZk3DT0XwwTiwbAeudaZ9mdi1ZOOHv71d9MPvuz3JvsFhTRf7iHmQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724997191; c=relaxed/simple;
	bh=g8P8p7Incuz2BvQF4nESgVIUskOg6ugvxVwqtEVj/2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ/0xyTKzIn5CoQfA/PiGrcYc1EekkiG5WkRu9qgl39k2OBTILOuY1tf6TKlJ86Q6q8ONQN0TvoC9upEUic4b5hDVWPCNanfFOog7ShsrFfUbBoxEH00Z/viqdt/rGQyzlcXGz6XzqZBsuQea8Y9vgmbPZ4bCCMV650VWAzTQvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eL3vLcNR; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724997189; x=1756533189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=g8P8p7Incuz2BvQF4nESgVIUskOg6ugvxVwqtEVj/2g=;
  b=eL3vLcNRKa+5slpWrJ08rGO8YKlC6QlHk/AcRci5/iIpnY32016r9fvj
   jAnxZqXjgFTflWHrGXzwfBOa6qMKfPWU8OdjMKISLV6iooFXPoMauYMo+
   QZjR38EeiNrJgN8vd/5dyWs2L6A7XK+4MKSG4CfmWP3mndtgHJdHY4HP7
   KPT8Nej1G7CvV2iOJ2ZfR7tBmFNt2Ug4CrpNevrcMPGjjnmqKaY7USytd
   hHD4UgQ+p2I78T3Th67Uk6H5MjHJy/XAfxtUJSIOWGRt4x3YKqqrdA4T+
   EZsE6aWHXXdnVb05N3EAtJJgjRUOA+z+xa8ugeGhcQhhKDJSLW3IPOUxC
   Q==;
X-CSE-ConnectionGUID: irdajkvJT1Wcn7BifHwCng==
X-CSE-MsgGUID: hEDYRST/Tx67HUNQBeCpyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23764227"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="23764227"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 22:53:09 -0700
X-CSE-ConnectionGUID: MGE3kQIcQh+7YCVzklcIeQ==
X-CSE-MsgGUID: BdANivYkSIaDMHdGcl+AUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="94538656"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 22:53:04 -0700
Date: Fri, 30 Aug 2024 08:52:59 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 03/25] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <ZtFeO3hq6dpnXvmf@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-4-rick.p.edgecombe@intel.com>
 <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>
 <ZtAGCSslkH3XhM7a@tlindgre-MOBL1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtAGCSslkH3XhM7a@tlindgre-MOBL1>

On Thu, Aug 29, 2024 at 08:24:25AM +0300, Tony Lindgren wrote:
> On Tue, Aug 13, 2024 at 02:08:40PM +0800, Binbin Wu wrote:
> > On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
> > > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > > --- a/arch/x86/include/asm/shared/tdx.h
> > > +++ b/arch/x86/include/asm/shared/tdx.h
> > > @@ -28,6 +28,12 @@
> > >   #define TDVMCALL_STATUS_RETRY		1
> > > +/*
> > > + * TDG.VP.VMCALL Status Codes (returned in R10)
> > > + */
> > > +#define TDVMCALL_SUCCESS		0x0000000000000000ULL
> > > +#define TDVMCALL_INVALID_OPERAND	0x8000000000000000ULL
> > > +
> > TDX guest code has already defined/uses "TDVMCALL_STATUS_RETRY", which is
> > one
> > of the TDG.VP.VMCALL Status Codes.
> > 
> > IMHO, the style of the macros should be unified.
> > How about using TDVMALL_STATUS_* for TDG.VP.VMCALL Status Codes?
> > 
> > +/*
> > + * TDG.VP.VMCALL Status Codes (returned in R10)
> > + */
> > +#define TDVMCALL_STATUS_SUCCESS 0x0000000000000000ULL
> > -#define TDVMCALL_STATUS_RETRY                  1
> > +#define TDVMCALL_STATUS_RETRY 0x0000000000000001ULL
> > +#define TDVMCALL_STATUS_INVALID_OPERAND 0x8000000000000000ULL
> 
> Makes sense as they are the hardware status codes.

I'll do a patch against the CoCo queue for the TDVMCALL_STATUS prefix FYI.

Regards,

Tony

