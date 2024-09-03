Return-Path: <kvm+bounces-25702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A612969331
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:23:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2AB1C21748
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 05:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409AC1CE713;
	Tue,  3 Sep 2024 05:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AaqTYWK2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0D195;
	Tue,  3 Sep 2024 05:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725341022; cv=none; b=TW2a9pFHKBEJ62Ez7HwB9udLXkZSOgyv0BwBRyAAkOV2cQab82CJ2nvxUdQDsSr+mQTmyHVClBSrLM4PkzRqqVl6bl491ZSaxr4f/Aq8SmpIw3JK5VJ8wzmCx7rdmEKuUpwcsdugXVRIVnSYpPZ/I+HJHBICbU8qisfQeB1UrYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725341022; c=relaxed/simple;
	bh=atI1igT+Vz8ssCWz+Rt5jVIJeGElv6cm0euSN7lJGCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfVTLP6C0Sa0zm0Oyg075mI8ukvULRcRjRBtxmRS8ykvvBiCP3iSyeACFQJqQCocqZEcmbzDzhM3i61Yt7WmRuaQtgRm5eAG1gkuszOwcKZvEZmEUv3zKeQ/hQdELfx/pEdnfGlw5LJq44cgil0fomKPZ0kGo/v2KH4lsXJTjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AaqTYWK2; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725341021; x=1756877021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=atI1igT+Vz8ssCWz+Rt5jVIJeGElv6cm0euSN7lJGCE=;
  b=AaqTYWK2WabW7r2mYaLqdmL6nBmrqP/szM3JGqQ7E+QXfsOh+6b/65NE
   53zjJXg+tybLEsbTRtaJ2go4eROZuFkB2tH8GLYIt/gULxnOv35F1BYe2
   epnCXifwqBYhsMnEWGjqHN/lotXeL2WsxMRe/pye6j6KBXanDV3Fw9guX
   10mNz+PwRmaLqB6SUwhss3FRu6qK+sPmguHRJTT3BdlcJmECMUD/LCLdH
   wcCPu2v58shEMJsdPWZl5duO9zX5yU3tljsw+4Am+uuNE9f6lFvH2XjwK
   HrLNhdLFuOwY5sj0E58qFnGHdjr0wZvkljcIV4wYKG0F8URFxriptYuRi
   w==;
X-CSE-ConnectionGUID: B+fqAOn5SHuJwyhheU7iLw==
X-CSE-MsgGUID: EiAN1Jv4RlyvV3uUXa015Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="35285732"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="35285732"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:23:40 -0700
X-CSE-ConnectionGUID: VXb1BOb7R++KIuWagky1bA==
X-CSE-MsgGUID: B8d/sKaHTUmmcJongjftYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="64823159"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.115])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:23:35 -0700
Date: Tue, 3 Sep 2024 08:23:29 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Yuan Yao <yuan.yao@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <ZtadUapr1rU_kwqV@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813080009.zowu3woyffwlyazu@yy-desk-7060>

On Tue, Aug 13, 2024 at 04:00:09PM +0800, Yuan Yao wrote:
> On Mon, Aug 12, 2024 at 03:48:13PM -0700, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > @@ -293,6 +303,15 @@ static inline u8 tdx_sysinfo_nr_tdcs_pages(void)
> >  	return tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
> >  }
> >
> > +static inline u8 tdx_sysinfo_nr_tdcx_pages(void)
> 
> tdx_sysinfo_nr_tdcx_pages() is very similar to
> tdx_sysinfo_nr_tdcs_pages() which is introduced in patch 13.
> 
> It's easy to use either of them in wrong place and hard to
> review, these 2 functions have same signature so compiler
> has no way to prevent us from using them incorrectly.
> TDX 1.5 spec defines these additional pages for TD and vCPU to
> "TDCX" pages, so how about we name them like:
> 
> u8 tdx_sysinfo_nr_td_tdcx_pages(void);
> u8 tdx_sysinfo_nr_vcpu_tdcx_pages(void);
> 
> Above name matchs spec more, and easy to distinguish and review.

Good idea to clarify the naming. For patch 13/25, Nikolay suggested
precalculating the values and dropping the helpers. So we could have
kvm_tdx->nr_td_tdcx_pages and kvm_tdx->nr_vcpu_tdcx_pages following
your naming suggestion.

Regards,

Tony

