Return-Path: <kvm+bounces-44027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19EF6A99ED0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 04:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EA8E194683A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 02:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B03119D065;
	Thu, 24 Apr 2025 02:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R5GgT0FA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E162701BD
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 02:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745461894; cv=none; b=NnTyAqYAZo7FAL+SVg1BAg60apSkwILzdueg8+RJNOf9AWM/7Mu02/y9KDg862Qesdcf2eEQLPJGVFi13UgB/rXv/ohg8aW2A13x3ZwKS7KYtBg8ouDOX76Qk1KdylCY7VTe6ZGzMn94qzBDbIacCxQA87laS9Rn5fM8f1CBRMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745461894; c=relaxed/simple;
	bh=Ekg2qfsM9bPBGyQiZZJL+MMvwd2ayI0bu7Qyc0F1u/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qB50lY+qyfUOL+2Imf9Vgh14kblLOTGZa6PC2JUmpHgVu0VKx1CsQBN0Xk5T+H+MXVuugf3VIQa2PBLfwutZToUSlCBeaNwmLdASzwt45e9Dk3QJNMBYYrTqci8Dyi37b44t0mhSxIG8hOQarq9Z21SgOcZ0wyoZi7BlPpPmnA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R5GgT0FA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745461892; x=1776997892;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Ekg2qfsM9bPBGyQiZZJL+MMvwd2ayI0bu7Qyc0F1u/8=;
  b=R5GgT0FAFX8kNEh2xfzjBzEAizxEelD/rJ94BplZeR7IGi2WtSEyp6uH
   bUymRKj/FEMNyp2++4OqogQPxcDxBot9ve5Yjy9tr45hi0HTrSEwnYF5p
   m10bT41I93nQCmlcGgFo7XARpLGs78b9Z1H8hxBif3mgcn1/cnd+2dYFY
   vYdnEwE2Uvbbb/9oM1sAWJaq7k+wZkGj8BT2cBRxpbBTTlR7WWXO2pqrB
   AoH2I/zKCBFICVEBPKCKFL0EyJS8FNho9TMkGBTqyk/XQ/OegeYLhTzFN
   8tXjHzg/1504YIW5tYIoNGufZoSKwcD0XM3TYrue0DQ2ip6gm+njAE9ii
   g==;
X-CSE-ConnectionGUID: 4bBuvt7hQO+24I7tuZSm3Q==
X-CSE-MsgGUID: M6N7TYmeQeif2F1e2n2AGw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="57724971"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="57724971"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 19:31:31 -0700
X-CSE-ConnectionGUID: 3zhve+q3R8inQ1NaKVLnag==
X-CSE-MsgGUID: UH0bjNOcTgOH3Yrd3jjvvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132788659"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa008.fm.intel.com with ESMTP; 23 Apr 2025 19:31:28 -0700
Date: Thu, 24 Apr 2025 10:52:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
	Tejus GK <tejus.gk@nutanix.com>, Jason Zeng <jason.zeng@intel.com>,
	Manish Mishra <manish.mishra@nutanix.com>,
	Tao Su <tao1.su@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [RFC 01/10] i386/cpu: Mark CPUID[0x80000005] as reserved for
 Intel
Message-ID: <aAmnaAbrELVl3UiT@intel.com>
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-2-zhao1.liu@intel.com>
 <596c7a44-797b-4a16-bd7e-0f0dc5c2e593@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <596c7a44-797b-4a16-bd7e-0f0dc5c2e593@intel.com>

> > +        /*
> > +         * cache info (L1 cache)
> > +         *
> > +         * For !vendor_cpuid_only case, non-AMD CPU would get the wrong
> > +         * information, i.e., get AMD's cache model. It doesn't matter,
> > +         * vendor_cpuid_only has been turned on by default since
> > +         * PC machine v6.1.
> > +         */
> 
> We need to define a new compat property for it other than vendor_cpuid_only,
> for 10.1.
> 
> I proposed some change to leaf FEAT_8000_0001_EDX[1], and I was told by
> Paolo (privately) that vendor_cpuid_only doesn't suffice.
> 
>  On Fri, Oct 11, 2024 at 6:22 PM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>  >
>  > On 10/11/2024 11:30 PM, Paolo Bonzini wrote:
>  > > On Fri, Oct 11, 2024 at 4:55 PM Xiaoyao Li <xiaoyao.li@intel.com>
> wrote:
>  > >>
>  > >> I think patch 8 is also a general issue> Without it, the
>  > >> CPUID_EXT2_AMD_ALIASES bits are exposed to Intel VMs which are
>  > >> reserved bits for Intel.
>  > >
>  > > Yes but you'd have to add compat properties for these. If you can do
>  > > it for TDX only, that's easier.
>  >
>  > Does vendor_cpuid_only suffice?
> 
>  Unfortunately not, because it is turned off only for <=6.0 machine
>  types. Here you'd have to turn it off for <=9.1 machine types.
> 
> 
> [1] https://lore.kernel.org/qemu-devel/20240814075431.339209-9-xiaoyao.li@intel.com/

For the patch link, you wanted to mark it as unavailiable but it would
break the machine <= 6.0 (with vendor_cpuid_only turned off), correct?

For this patch:
 * vendor_cpuid_only turns off for <= 6.0 machine, no change.
 * vendor_cpuid_only turns on for > 6.0 machine, I treated it as a
   "direct" fix because original codes encode the AMD cache model info
   on non-AMD platform (in ecx & edx). This doesn't make sense. Non-AMD
   platform should use cache_info_cpuid4 or 0 here. If it is considered
   a fix, it may be more appropriate to use cache_info_cpuid4.

I think it's somehow similar to the “trade-offs” Daniel indicated [2].

This case can also be fixed by compat option. Then we don't  need to
encode cache_info_cpuid4 info for non-AMD platforms in this leaf.

Do you still need the patches in your links? (I didn't find the related
patch merged.) If so, I can add the compat option in the next version
which could also help you land your previous patches v10.1 as well.

[2]: https://lore.kernel.org/qemu-devel/Z08j2Ii-QuZk3lTY@redhat.com/

> > +        if (cpu->vendor_cpuid_only &&
> > +            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> > +            *eax = *ebx = *ecx = *edx = 0;
> > +            break;
> > +        } else if (cpu->cache_info_passthrough) {
> >               x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
> >               break;
> >           }
> > +
> >           *eax = (L1_DTLB_2M_ASSOC << 24) | (L1_DTLB_2M_ENTRIES << 16) |
> >                  (L1_ITLB_2M_ASSOC <<  8) | (L1_ITLB_2M_ENTRIES);
> >           *ebx = (L1_DTLB_4K_ASSOC << 24) | (L1_DTLB_4K_ENTRIES << 16) |
> 

