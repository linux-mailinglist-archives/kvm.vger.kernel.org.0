Return-Path: <kvm+bounces-18537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CBCA8D6418
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 16:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FC321C27013
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 14:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8882415D5A0;
	Fri, 31 May 2024 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZgtKZD3i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04367145328;
	Fri, 31 May 2024 14:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717164680; cv=none; b=hvh110ahmfzWiXP9tXv9vu/3SNvtu+3BLEceq3NV+yOGDP7xtnI2gOda0M7/eJCDPrEEaRKppWFeuWNeSC3VtbsNjXGugFPFySIY/jtJgcvzsl9YAa6j4s/X0gD1jVBladwAdLq12niF5+FZMdp88g2gOPZFfRGy+gm35rkEKOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717164680; c=relaxed/simple;
	bh=yjI3iFmouPnWBxFK1wKDvl5O5Q+G36gJJ/9ZqesnSCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIopRBwty9+y1SdE7GIlCrU14qwrc/kEdT5Z/C6FzH1+MYYKeaPb+yaxyJSX4i35pdcabLhJ+DX2GwCogQ0I0PWW7uT7jqz6OXjy8V54ATLgnWzQQcpnrbQkjhRijhNCy1Aih3BLpFJShcILr1G968+RlideXGkzgrqMGKqioRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZgtKZD3i; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717164679; x=1748700679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=yjI3iFmouPnWBxFK1wKDvl5O5Q+G36gJJ/9ZqesnSCI=;
  b=ZgtKZD3iuebC2RNZ9aqqyBMwtC0E6plWdlhnt1cZOv9SihspKn7iE8Xk
   GurqEwhIfyXKezz24wjHYE4FUkHcCF+kQsO+XciBbmLBDi5L30iEZS//M
   N2S+6ssjmUQR0P/HMFqWBlCdxmobvCXtrKDPf70aE9R9LhVu+J00ONm3S
   UMGXllLLgwz7GcST8UcBDZfPS3gO3B6H6lortrD1hWwyDYAU0vZOqC5gK
   rj8tuXdXpWKwcbFKNR8xfgDEDl1ejA1oEOuscaujgh58U0y7uDnBpPlsx
   PvSW5gjrWJhcoTy3di9hiXf68Z/PJBH0qnnYHbIyweLTPe3Wwutiw2mba
   w==;
X-CSE-ConnectionGUID: 0m/SIMn/QyCxetEIOlc5IQ==
X-CSE-MsgGUID: 9/Jh7PtITnOVLFxRGhTXRA==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="24370456"
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="24370456"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 07:11:17 -0700
X-CSE-ConnectionGUID: irsAJJ7oQDa/yNZcDVjIsQ==
X-CSE-MsgGUID: AGIeMMVEQZOp7mUnq6TRog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,204,1712646000"; 
   d="scan'208";a="40724187"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 07:11:17 -0700
Date: Fri, 31 May 2024 07:11:16 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240531141116.GI386318@ls.amr.corp.intel.com>
References: <9bc661643e3ce11f32f0bac78a2dbfd62d9cd283.camel@intel.com>
 <20240522234754.GD212599@ls.amr.corp.intel.com>
 <4a6e393c6a1f99ee45b9020fbd2ac70f48c980b4.camel@intel.com>
 <20240523000100.GE212599@ls.amr.corp.intel.com>
 <35b63d56fe6ebd98c61b7c7ca1680da91c28a4d0.camel@intel.com>
 <20240524075519.GF212599@ls.amr.corp.intel.com>
 <31a2b098797b3837597880d5827a727fee9be11e.camel@intel.com>
 <CABgObfa+vx3euEXwopBBzt7BEVT8MV7HuuLayRKxURnopO3f=w@mail.gmail.com>
 <b6217ba2f75366d25ff46cd72dcf671cdc57f340.camel@intel.com>
 <CABgObfYCnC2qoMHmKx7QK=pEoARfcGw=F-epXYT4z6uoJeH_-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYCnC2qoMHmKx7QK=pEoARfcGw=F-epXYT4z6uoJeH_-w@mail.gmail.com>

On Wed, May 29, 2024 at 09:25:46AM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Wed, May 29, 2024 at 4:14 AM Edgecombe, Rick P
> <rick.p.edgecombe@intel.com> wrote:
> >
> > On Tue, 2024-05-28 at 19:47 +0200, Paolo Bonzini wrote:
> > > On Tue, May 28, 2024 at 6:27 PM Edgecombe, Rick P
> > > <rick.p.edgecombe@intel.com> wrote:
> > > > > I don't see benefit of x86_ops.max_gfn() compared to kvm->arch.max_gfn.
> > > > > But I don't have strong preference. Either way will work.
> > > >
> > > > The non-TDX VM's won't need per-VM data, right? So it's just unneeded extra
> > > > state per-vm.
> > >
> > > It's just a cached value like there are many in the MMU. It's easier
> > > for me to read code without the mental overhead of a function call.
> >
> > Ok. Since this has (optimization) utility beyond TDX, maybe it's worth splitting
> > it off as a separate patch? I think maybe we'll pursue this path unless there is
> > objection.
> 
> Yes, absolutely.

Ok, let me cook an independent patch series for kvm-coco-queue. 
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

