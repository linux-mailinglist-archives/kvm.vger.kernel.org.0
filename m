Return-Path: <kvm+bounces-12452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE2B886391
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 23:59:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CCD21C21D89
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2620C8C04;
	Thu, 21 Mar 2024 22:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VXbSVTN8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7826FBE;
	Thu, 21 Mar 2024 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711061954; cv=none; b=ovlrDgtfQ5/1bkL0+mhDEl9qGSzhClsutNo7LhuMEp34GESLHQea0ZUu9bTwXKw0vgmOxkArKLNABKb8Xk6jVRp9SEINL89yshTj71umH3ohA8jueJt1C+0QJUqzVzV8+DPHp2fBywEQP/vtgQT54PY69GcwPE2DztXnwu29UZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711061954; c=relaxed/simple;
	bh=GI3K64J7vLiN3bPpcKnL62DXpmEjzOMkcBmiGh2A8ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjFnbJDKX8Aa0xegJ8OlbjPiagRiqQddSfRy4RJ/zsHxiC51uEA9ZQ+QGTarxauzcYunxI5GK/Ol8mQK4WeIZgocQJ3YYtENJoCM89JVGt68aej8+VnHAzqE2Tr6YTRvhFPitMn3OiZ0s77btlu9Hg8HAl37Cg0R5tCWkfyUbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VXbSVTN8; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711061953; x=1742597953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GI3K64J7vLiN3bPpcKnL62DXpmEjzOMkcBmiGh2A8ZM=;
  b=VXbSVTN80KYk1vCchnmz63X4C67QczuTmKPVNGP7aTAlxHaK456CXDYS
   QnR9WZj2/jQOiaSFNFSLMmoxLePr6iO7L07kv99aj5yyaJ4pN5L3nOP/Q
   QpYSnzOkbynCPxKvUH2720a1Ub81Ka+ySnr4PooJiq+sMHgrrvDDT8/9L
   LSIBMRWtvfEDzIrAiCbKzygh0gadlWVL6h3Ajl6O26i3HU6RQCEGjy0yj
   KcyBjxY17oeRTq6E6VA8Wx9OqZpV/J2ANfz30SJNudgNxzch8r59eUOs2
   BwDgGSVsWpbpUM8CytkClkd4AletsXqBh/eu28FcVMWO/imJCZ72xGnKh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9041316"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="9041316"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14729348"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 15:59:10 -0700
Date: Thu, 21 Mar 2024 15:59:10 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <20240321225910.GU1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
 <20240319235654.GC1994522@ls.amr.corp.intel.com>
 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>

On Thu, Mar 21, 2024 at 01:17:35AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Tue, 2024-03-19 at 17:56 -0700, Rick Edgecombe wrote:
> > > Because TDX supports only WB, we
> > > ignore the request for MTRR and lapic page change to not zap
> > > private
> > > pages on unmapping for those two cases
> > 
> > Hmm. I need to go back and look at this again. It's not clear from
> > the
> > description why it is safe for the host to not zap pages if requested
> > to. I see why the guest wouldn't want them to be zapped.
> 
> Ok, I see now how this works. MTRRs and APIC zapping happen to use the
> same function: kvm_zap_gfn_range(). So restricting that function from
> zapping private pages has the desired affect. I think it's not ideal
> that kvm_zap_gfn_range() silently skips zapping some ranges. I wonder
> if we could pass something in, so it's more clear to the caller.
> 
> But can these code paths even get reaches in TDX? It sounded like MTRRs
> basically weren't supported.

We can make the code paths so with the (new) assumption that guest MTRR can
be disabled cleanly.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

