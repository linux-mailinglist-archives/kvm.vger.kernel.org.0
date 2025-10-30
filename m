Return-Path: <kvm+bounces-61498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F81C2120E
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 17:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88E3D3AB6CA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269AA2D12EB;
	Thu, 30 Oct 2025 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H1m9g1W4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E112253B42
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761841065; cv=none; b=ZeuqO/SyHLEoM0aC/zK5u/6dMxTKlIeh9QGYnsZAOLvEc5pLlaT2atnp9D/X+aUNaPQurVlciQxZP4c82prWjerhBNFn958JIuBoeIhuUY0BRjUedI+b8M3p6mAYYci4avOoy7UTuqLXx9M29GndkL1R5zyYcGmEz1cb6hyfCkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761841065; c=relaxed/simple;
	bh=auefPtati7woFejgoYeBYbRyUtIZoiPQxj0zexbepbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8/El4X9CQXinxISSeq3pURGaTyL2aNVqGuK05Hfz9Bkcf4bmg9XqBVAczUt9Zv1LD3+aBeJL7k4LOoZX/LB6Ac8Tua98RjGLdl/5F+2bxElTgjqVFGf4HIKZJxiR4b8w3qeXOXfDS9sBcmylazJsA+hsn3uUEvE3RQHT0Ds44E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H1m9g1W4; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761841064; x=1793377064;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=auefPtati7woFejgoYeBYbRyUtIZoiPQxj0zexbepbI=;
  b=H1m9g1W4wW8Rvwun+m5VqadgP/HTH2L5hjsQhf+G5ya7DWbh5R9qmTtB
   OfAnGvL/u7cDaqGTNHw2Xbgv1Cg+Piw2meGBcVK9jpO1y3eBoqj2k3R5O
   uKZsx+sb/LFGloaBZ4hkhcpyvl9gKOUnLg/jDG3jWfsQtnRF59DmDWPN0
   z3lALf+MdwvS4DGxaUV7BsIn5qSDxTQDiYmHV+Xm5tOZxGKMrUx3F+3P6
   Mg4dz7sG9dv1Vd6puhF0q/m7bxiH/5LEP83BPwCdzskdx48U+gInp/Chn
   siczHy4Xy7r0GTiLflG5n2dCUMeqd2D6zBWwXQALYwhcIzv/mCNACpR6O
   Q==;
X-CSE-ConnectionGUID: HeLdsjPEQzCoqNEXS0fzAw==
X-CSE-MsgGUID: F9unj9m2R+SOD9vRkIj10w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63917081"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63917081"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 09:17:43 -0700
X-CSE-ConnectionGUID: OkNRYvrMSTOBfjcMIEUxlw==
X-CSE-MsgGUID: mFXhO+JLRLauSgZJr98RhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185932717"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa007.jf.intel.com with ESMTP; 30 Oct 2025 09:17:40 -0700
Date: Fri, 31 Oct 2025 00:39:51 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chao Gao <chao.gao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Yang Weijiang <weijiang.yang@intel.com>
Subject: Re: [PATCH v3 11/20] i386/cpu: Enable xsave support for CET states
Message-ID: <aQOU1/kR7w7U2NxD@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-12-zhao1.liu@intel.com>
 <aQGe66NsIm7AglKb@intel.com>
 <4806bc74-e4c2-4aa1-b003-e72895a11f11@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4806bc74-e4c2-4aa1-b003-e72895a11f11@intel.com>

> > It just occurred to me that KVM_GET/SET_XSAVE don't save/restore supervisor
> > states. Supervisor states need to be saved/restored via MSR APIs. So, there
> > is no need to add supervisor states (including ARCH_LBR states) to
> > x86_ext_save_areas[].
> 
> x86_ext_save_areas[] is not used only for xsave state, it's also used for
> the setup of xsave features, i.e., CPUID leaf 0xD.

Yes. And it can also maintain dependencies.

> And you did catch the missing part of this series, it lacks the save/restore
> of CET XSAVE state in x86_cpu_xsave_all_areas()/x86_cpu_xrstor_all_areas()

Not a missing part. CET's xstates contain CET related MSRs and actually
is saved/restored via MSR ioctls, not KVM_GET/SET_XSAVE.

Regards,
Zhao


