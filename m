Return-Path: <kvm+bounces-39539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 333C4A475E9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 07:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5A75188DEBC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 06:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C355F21B1A8;
	Thu, 27 Feb 2025 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XviIQ2hD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C457217668
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740637361; cv=none; b=Jxi6JSydK2q55dMNcVXSZJKl+Ym4WfxIqCQ1thN2DHrPFEih28f1LtYAsZBKaRH78BwcDYOZDks23Ag3xazcpmh3cyY6P7vO7nWMoSmsl97Yc2AA+Rj4CTYfeZ82s8fPbvX9sHeDzLT8Uvk8PaztCssG1n6+A3k+AmNAXB7u37Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740637361; c=relaxed/simple;
	bh=iEVKpF7UnIq52/UIR99jPQQ910Ex7ozCZdIK5ktgMJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pfYf3M1msvHscW3df9IltDpmryyCmGzl4kXwZkhWLgLfog7z/qMsztOIaw/Pqhjgewd7hL+3oI81ITZHDnjvA0ZD3fcTGPlldv57nkFQVfxP7PIe4YgvSePDu2O3IrXEHjhJ6hDBf8WMPfpXQQ83FZbP1D+fcJkUt7DVF4t5xsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XviIQ2hD; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740637359; x=1772173359;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iEVKpF7UnIq52/UIR99jPQQ910Ex7ozCZdIK5ktgMJI=;
  b=XviIQ2hD7eF4ZdPxdqFUgx3nBNB2ofbwfcr/bQ+ohawGK3rK9eXCKidV
   8OYP1WQYLNMnZRn5qSIe9W2i1Hhuzxd4zY96cGJWR3FUdzI4TFyNYvEX1
   Jr2FuUeaeZfCpMK153gqNi4lTXB9hJsSaAnbPmj6oUpoSXLbPAg6WuFyn
   H+YfZwnh1cBFMtK1E7l6M30Ukwu2+9XfMsCK+HwFmRGthjKnrqcTa9b0c
   YHSybqyh5kaYdXpAu4qDFCm7m21PbFe9OFibJLTRMx5vIyyanaguS3Ay2
   Uw6aLBNVVd3hC+ybEDkKfcIXZ53CkzzvdlQHGXMauErfFjfhpDelQooMl
   A==;
X-CSE-ConnectionGUID: BPjl3xKdSquCb7luIJlb8g==
X-CSE-MsgGUID: Zp6HHSbIR922BhZYKJNnlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="41641795"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="41641795"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 22:22:33 -0800
X-CSE-ConnectionGUID: 7UH/6/VcT46BAs492C6b8g==
X-CSE-MsgGUID: EF1cyGRaSSyDgaK2RmYm+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="147753155"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 26 Feb 2025 22:22:30 -0800
Date: Thu, 27 Feb 2025 14:42:35 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Moger, Babu" <babu.moger@amd.com>
Cc: John Allen <john.allen@amd.com>, pbonzini@redhat.com,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	davydov-max@yandex-team.ru,
	Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v5 1/6] target/i386: Update EPYC CPU model for Cache
 property, RAS, SVM feature bits
Message-ID: <Z8AJW9VJKZXPD2d4@intel.com>
References: <cover.1738869208.git.babu.moger@amd.com>
 <c777bf763a636c8922164a174685b4f03864452f.1738869208.git.babu.moger@amd.com>
 <Z7cLFrIPmrUGuqp4@intel.com>
 <Z733dp+gePxwDsyW@AUSJOHALLEN.amd.com>
 <7822f511-6b64-417f-830f-3ef912e572d7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7822f511-6b64-417f-830f-3ef912e572d7@amd.com>

On Wed, Feb 26, 2025 at 02:28:35PM -0600, Moger, Babu wrote:
> Date: Wed, 26 Feb 2025 14:28:35 -0600
> From: "Moger, Babu" <babu.moger@amd.com>
> Subject: Re: [PATCH v5 1/6] target/i386: Update EPYC CPU model for Cache
>  property, RAS, SVM feature bits
> 
> Hi John,
> 
> On 2/25/25 11:01, John Allen wrote:
> > On Thu, Feb 20, 2025 at 06:59:34PM +0800, Zhao Liu wrote:
> >> And one more thing :-) ...
> >>
> >>>  static const CPUCaches epyc_rome_cache_info = {
> >>>      .l1d_cache = &(CPUCacheInfo) {
> >>>          .type = DATA_CACHE,
> >>> @@ -5207,6 +5261,25 @@ static const X86CPUDefinition builtin_x86_defs[] = {
> >>>                  },
> >>>                  .cache_info = &epyc_v4_cache_info
> >>>              },
> >>> +            {
> >>> +                .version = 5,
> >>> +                .props = (PropValue[]) {
> >>> +                    { "overflow-recov", "on" },
> >>> +                    { "succor", "on" },
> >>
> >> When I checks the "overflow-recov" and "succor" enabling, I find these 2
> >> bits are set unconditionally.
> >>
> >> I'm not sure if all AMD platforms support both bits, do you think it's
> >> necessary to check the host support?
> > 
> > Hi Zhao,
> > 
> > IIRC, we intentionally set these unconditionally since there is no
> > specific support needed from the host side for guests to use these bits
> > to handle MCEs. See the original discussion and rationale in this
> > thread:
> > 
> > https://lore.kernel.org/all/20230706194022.2485195-2-john.allen@amd.com/
> > 
> > However, this discussion only applied to the SUCCOR feature and not the
> > OVERFLOW_RECOV feature and now that you bring it up, I'm second guessing
> > whether we can apply the same thinking to OVERFLOW_RECOV. I think we may
> > want to keep setting the SUCCOR bit unconditionally, but we may want to
> > handle OVERFLOW_RECOV normally. I'll have to track down some old
> > hardware to see how this behaves when the hardware doesn't support it.

Yes, thanks!

> Yes. We need to verify it on pre-EPYC hardware. Please let us know how it
> goes.
> 
> But, this series updates only the EPYC based CPU models. It should not be
> a concern here. Right?

Yes, it doesn't block this series. :-)

Thank you both,
Zhao


