Return-Path: <kvm+bounces-36226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B086A18D97
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 09:28:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 440323A67E1
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E380204681;
	Wed, 22 Jan 2025 08:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLc+5PPU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CF203705;
	Wed, 22 Jan 2025 08:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737534470; cv=none; b=nlsxRYfwNK9Nxt+0cLuyTvp2wU4A5lqRPEXWbr4AVapxG6n7huG9c1SPfgi+zsvoWHFR4IMT40iBimWobv7bXg12w5oeD9fMdyBDn79QPXGSRbeMQOinJzVNR1/erJN5ciFor0KTeWHErWh0Tj535imgRUER/Z7Ks3MPNz/FjsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737534470; c=relaxed/simple;
	bh=FtCqAQv1YlUfdX9xfdQZD810YHl6sym/evT0F7HVC0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew6x6IyOc4wOEJ2CbtxJA9vHCaBkU1lYEXkeEvcFUGwR/re0UkVyh9wI2wsVHQbd33in9C5isnDRAm1VUSjfffA7GNnxQxysTXMmP60uDU8yxRbixSgY9p1EL9Nsibgh484FBnupbpknBlj0nGvB1utQ8vc+BWiFTNM/qpS5wrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLc+5PPU; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737534469; x=1769070469;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FtCqAQv1YlUfdX9xfdQZD810YHl6sym/evT0F7HVC0s=;
  b=bLc+5PPU4wOKnfLxoFQv2kpt450PW5VX4sDopbSin6IGsbcI/AZooLPI
   BSudKt2vIC5z6L1HezAviQfEiOVvJ1+FLeCw+d/Lzckz1S88EF2IiZwWL
   3mOcNpfD5KObk/XaU4x06vsHAycqW0T7VCg2/GeWikJWCRe9BISDK+wTF
   eXQpPELPXUyG2TFjMUGVvY1tWf2JWp6zoU6d1+7BlBYfei98b3Zmox8TY
   RSlcQOCv0Q7r7VK1Yp9XMxBKJTq4sn0jX56gz8YFFaDM51o9Bv0EP7Frj
   +q/T4xhqn5O8vIOftNd/yLrd7TOmGGz0vAP6yV1Z6MOZKwk9M43Wa1W9v
   Q==;
X-CSE-ConnectionGUID: f+a6mIAnQsmjRLyK2XwrnQ==
X-CSE-MsgGUID: +JA2QYy/QX2YuI0Q35P7ew==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="48578185"
X-IronPort-AV: E=Sophos;i="6.13,224,1732608000"; 
   d="scan'208";a="48578185"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:27:48 -0800
X-CSE-ConnectionGUID: gkSEjk9NQDOJYznQOI9Z7w==
X-CSE-MsgGUID: LLxwZOwuQWOQcpF9eKyE3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="112043351"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.245])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 00:27:44 -0800
Date: Wed, 22 Jan 2025 10:27:39 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [PATCH v2 00/25] TDX vCPU/VM creation
Message-ID: <Z5Cr-6t469cZRTaA@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <CABgObfZsF+1YGTQO_+uF+pBPm-i08BrEGCfTG8_o824776c=6Q@mail.gmail.com>
 <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94e37a815632447d4d16df0a85f3ec2e346fca49.camel@intel.com>

On Sat, Jan 04, 2025 at 01:43:56AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2024-12-23 at 17:25 +0100, Paolo Bonzini wrote:
> > 11: see the type safety comment above:
> > > The ugly part here is the type-unsafety of to_vmx/to_tdx.  We probably
> > > should add some "#pragma poison" of to_vmx/to_tdx: for example both can
> > > be poisoned in pmu_intel.c after the definition of
> > > vcpu_to_lbr_records(), while one of them can be poisoned in
> > > sgx.c/posted_intr.c/vmx.c/tdx.c.
> 
> I left it off because you said "Not a strict requirement though." and gave it a
> RB tag. Other stuff seemed higher priority. We can look at some options for a
> follow on patch if it lightens your load.

I suggest we do this:

- Make to_kvm_tdx() and to_tdx() private to tdx.c as they're only used
  in tdx.c

- Add pragma poison to_vmx at the top of tdx.c

- Add pragma poison to_vmx in pmu_intel.c after vcpu_to_lbr_records()

Other pragma poison to_vmx can be added as needed, but AFAIK there's
not need to add it for to_tdx().

Regards,

Tony

