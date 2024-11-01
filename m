Return-Path: <kvm+bounces-30293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 053DA9B8CE9
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 09:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A45491F22A72
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 08:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B8715697B;
	Fri,  1 Nov 2024 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XOgM7I6n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECF4087C;
	Fri,  1 Nov 2024 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730449219; cv=none; b=PHGtqdqaycUH5UZQukoVP4thP35VDpaURQW2NCDkTdhljyIFxRksawaUvrbdkBPQPqSTiyWF2sxX3LCFSZQYx4YslGtEl5odZldPOyw3wnxWgAiiQIrSIlBTPvTZMCRCCxWiTHyhsx4kHi6MjfaVNj9l3EhvRi0SQM/PeBo/Asc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730449219; c=relaxed/simple;
	bh=HLnoqyTmhS73S+2+YnvXMBDQn5UW8hoXcGdTMQHnBjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9lbt3k1+2udK5diTrHNywNUmDC4scwpbz2TFvaRVg60b+cPK5dHg7iOnH0/nTp06orXfHoAtRGv/3+c2PY/EKI1xwa80110S2Yz506zvoHR7CxQue6HQjoq7MwnDH99iqIUynONWdf16AajtJHh8wUKhN0XVMshLiHht0XbaUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XOgM7I6n; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730449218; x=1761985218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HLnoqyTmhS73S+2+YnvXMBDQn5UW8hoXcGdTMQHnBjM=;
  b=XOgM7I6nbd63V67sYC75KYIDJ7GL6FhVljBvlfbuVF6V0H1p7OM+2bjk
   eDV+pqdIH64VqBjQeBv0y3WzHdKLyXCdC3RLCaIOOP2iUtFkQHQH3Gtca
   Tvfmd9KXuLzfqRbwkZ8InGtOKBmUIIjnk7+HqDLa/4NHEcVrS3aR5k9NA
   IYqqaeKvpr4AiMHbBzcn/cHlYAmQQpA9wrzVCHGJut+r2tEd49/2XVjX3
   haGbpY0gIAiMKf2ttJFJHM4AVtHBgqw5NT+OgNy6/xIg8Wb113ord6Ybl
   njUW0hrcWcVOYR1IHCJxRpKi3ODyVtu2ZqqKoXqtLX6w2m0rgwHtz8kCD
   Q==;
X-CSE-ConnectionGUID: cLwqVywUSmewHCoo6g1nJQ==
X-CSE-MsgGUID: LKKhpuUcR8G62uLP7n1xow==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17846337"
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="17846337"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:20:17 -0700
X-CSE-ConnectionGUID: d4wCS3EqRMeAwQtKfdiSPw==
X-CSE-MsgGUID: R/9oY3BgQv2Trvh7UoNJPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,249,1725346800"; 
   d="scan'208";a="83005667"
Received: from kniemiec-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.246.229])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2024 01:20:11 -0700
Date: Fri, 1 Nov 2024 10:19:55 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module
 on initialization
Message-ID: <ZySPK71RlFqPfkmU@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-17-rick.p.edgecombe@intel.com>
 <88ea52ea-df9f-45d6-9022-db4313c324e2@linux.intel.com>
 <bb60b05d-5ccc-49ab-9a0c-a7f87b0c827c@intel.com>
 <ZyNP82ApuQQeNGJ3@tlindgre-MOBL1>
 <b47e8622-ea5d-47b2-97b5-02216bf6989a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47e8622-ea5d-47b2-97b5-02216bf6989a@intel.com>

On Thu, Oct 31, 2024 at 10:27:11PM +0800, Xiaoyao Li wrote:
> On 10/31/2024 5:37 PM, Tony Lindgren wrote:
> > On Thu, Oct 31, 2024 at 05:23:57PM +0800, Xiaoyao Li wrote:
> > > here it is to initialize the configurable CPUID bits that get reported to
> > > userspace. Though TDX module doesn't allow them to be set in TD_PARAM for
> > > KVM_TDX_INIT_VM, they get set to 0xff because KVM reuse these bits
> > > EBX[23:16] as the interface for userspace to configure GPAW of TD guest
> > > (implemented in setup_tdparams_eptp_controls() in patch 19). That's why they
> > > need to be set as all-1 to allow userspace to configure.
> > > 
> > > And the comment above it is wrong and vague. we need to change it to
> > > something like
> > > 
> > > 	/*
> > >           * Though TDX module doesn't allow the configuration of guest
> > >           * phys addr bits (EBX[23:16]), KVM uses it as the interface for
> > >           * userspace to configure the GPAW. So need to report these bits
> > >           * as configurable to userspace.
> > >           */
> > 
> > That sounds good to me.
> > 
> > Hmm so care to check if we can also just leave out another "old module"
> > comment in tdx_read_cpuid()?
> 
> That one did relate to old module, the module that without
> TDX_CONFIG_FLAGS_MAXGPA_VIRT reported in tdx_feature0.

OK thanks for checking.

> I will sent an follow up patch to complement the handling if TDX module
> supports TDX_CONFIG_FLAGS_MAXGPA_VIRT.

OK

Regards,

Tony

