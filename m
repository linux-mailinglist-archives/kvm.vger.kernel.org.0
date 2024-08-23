Return-Path: <kvm+bounces-24862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D36C95C3F2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 05:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F51A1C232CB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 03:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0FB13A1DC;
	Fri, 23 Aug 2024 03:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Edq0b3Tf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E974A01
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 03:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724385187; cv=none; b=OsbSmJvBTpUm18loD6rKCsPfmuqixjuWbXwAvtoe1mxwO/eVqoFGRMW3tvFYTNOuT6+U4AuEZsnluPlEGBPw84oiAjZZHVgazUxRha472ngg200l5hPVtseZV2We3XRpFKTdAvMLooPijVj76oc75OAPftHkbxtMHjNBN48qFDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724385187; c=relaxed/simple;
	bh=QMxO/C+zXao3ZOSTPsbRM+LiqrAYhma/hAGmyX1PRbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cs1Hg/3rOnVhot98wb5Cv30kk4Qx85z81kulj8raPpDwxfUAxQX7bv+5OpW0vzdVqq9QSMkcicmlyUAk3VqXMks+IN1YLVFblEaPf2bFFZjcH07h0kG/RALcxN+rueHntVJlpypqGHturfsplfyYlFzszmig3BiFoqgiJcmqlVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Edq0b3Tf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724385185; x=1755921185;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=QMxO/C+zXao3ZOSTPsbRM+LiqrAYhma/hAGmyX1PRbI=;
  b=Edq0b3Tf/f5ZQ6m1DRdHpzs7WVX52PnaD1dUHb84hcKJUJKl1nSieO4+
   9L4xTNVASmfMRB5Il1Al3Jz5z447CJWPOS2J5psg30waPQ+zLrKstdqH3
   D7vl7qmUp8ra/2vVT9FjGO2jVWoQ/EhXicd3OZqt23xzvTkdJTlU2KP4Q
   BeaaL40tYXuKCgVkpjtDvOJsjm+jErntevA10YNZ2B9NtSsNUhIyWwO/e
   861Z9/RHEHMUkzc6/gRqLJvtseWse7TFiZfzDJ9v79YRRGIjneLaBfHUH
   GLlCCYphRUoxwKqcCIY1a8+fDAlZf8Hnzog9p2b2g7gPVw6TrZtSRt0pG
   Q==;
X-CSE-ConnectionGUID: ghOLsCx3RBuaWcMe0WDO7w==
X-CSE-MsgGUID: plGZ5x7CQ1SyfGPXgrzGMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="22701068"
X-IronPort-AV: E=Sophos;i="6.10,169,1719903600"; 
   d="scan'208";a="22701068"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 20:53:05 -0700
X-CSE-ConnectionGUID: Pktoj//sTrKOzDxA5r4Tjw==
X-CSE-MsgGUID: uUWExjyoQpi7v8eUGqMfEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,169,1719903600"; 
   d="scan'208";a="61349023"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 20:53:02 -0700
Date: Fri, 23 Aug 2024 11:47:48 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, x86@kernel.org,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Xu Liu <liuxu@meta.com>
Subject: Re: [PATCH RFC] kvm: emulate avx vmovdq
Message-ID: <ZsgGZAX2F5AG5Q4T@linux.bj.intel.com>
References: <20240820230431.3850991-1-kbusch@meta.com>
 <ZsbnO17DWqpKHkmU@linux.bj.intel.com>
 <ZsdNl_Adm6FC6ejG@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZsdNl_Adm6FC6ejG@kbusch-mbp.mynextlight.net>

On Thu, Aug 22, 2024 at 08:39:19AM -0600, Keith Busch wrote:
> On Thu, Aug 22, 2024 at 03:22:35PM +0800, Tao Su wrote:
> > On Tue, Aug 20, 2024 at 04:04:31PM -0700, Keith Busch wrote:
> > > +	if (map == 1 && !v)
> > > +		return avx_0f_table[ctxt->b];
> > > +	return (struct opcode){.flags = NotImpl};
> > 
> > Can we check whether the host supports AVX? I.e. if the host does not support
> > AVX, set NotImpl. I am thinking that if the host does not support AVX, perhaps
> > the guest executing AVX instructions will cause the host to panic, because the
> > host will execute AVX instructions during the simulation.
> > 
> > Yeah if the host does not support AVX, it may not report AVX to the guest, but
> > the guest can always ignore the AVX check, such as the code in the commit.
> 
> That's a good thought. Here is how I rationalized not adding additional
> checks for it:
> 
> If the guest cpu doesn't support AVX, I think it should fail then and
> there rather than trap to the hypervisor running on the host, so this
> new code wouldn't get a chance to attempt emulating it. 
> 

Per SDM:
If YMM state management is not enabled by an operating systems, Intel AVX
instructions will #UD regardless of CPUID.1:ECX.AVX[bit 28].

Host and guest can set different xstates, so it has possibility to trigger,
i.e. host clears but guest sets XCR0[2]. But I don’t see this case can occur
now, so just ignore my concern if no one else wants to do that :-)

> In the case where the host doesn't support AVX, but the guest does
> support it, then I assume the VM is running on an emulated CPU and not
> using kvm acceleration anymore.
> 
> Anyway, I haven't tried it, so not entirely confident that's how this
> all works. I was mainly following the existing SSE emulations, which
> don't have CPU support checks either. I don't think it's a problem to
> add such checks though, so happy to do it if needed.

