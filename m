Return-Path: <kvm+bounces-25321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 453A49639DB
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0284E284751
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A84C1494A5;
	Thu, 29 Aug 2024 05:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a+p4m47G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1ABDDA6;
	Thu, 29 Aug 2024 05:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909080; cv=none; b=fwzRRVCL7TGJfIA0TaTosN649s78kVuqNfu+lvArZ8zDBJDE48pcOw7SnqBXRYc7P4FgN8KJxOzd2sOsrq54s5NLVan4bCVadKj6+Dvajz0Oa6BTU+XVcCphGfjFaylXn73i8zewacnqpRzJc1Gjv6QMnrBTJ2IwT7SsSAAGZAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909080; c=relaxed/simple;
	bh=rd0LIAgusAC6euWhqUGor/RakkI802QgHQ/B1YFlMYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tshgRUsdI3jJdbR92bU3EkOP9gJIJqCG+okGgNNtp6L5e3FkFiUJ5SRbc9QnTXti35yhQRf6tNhlC39rPw4J+yKFtNu/tfD4hF7tcUqHGBE4BTK4VS6HaF4vbiEORtsoF6KeIXw1OhCrv84yTFEGJ9w64Fy0drN0VtBqWlBX8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a+p4m47G; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724909079; x=1756445079;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rd0LIAgusAC6euWhqUGor/RakkI802QgHQ/B1YFlMYc=;
  b=a+p4m47GRDuZynGU0Kvxgw2dkYAEPGG4NXNbE6pj2EvnvPD6977ZMsjn
   6T2HtsOnw5qtpVZyPRtGUwlh85PTE8tomFU2JbaZWrITZEixFaaOYcqlW
   N7dknHrrx67CCninUWINMpkS7zOf4HpWI8+YMBKEpXz1h2Ti/o8qQEa01
   bgx0ckbSQKfbgpU1WnMD4WkfmlrOZ8joMkm0//cBSyt42nQ6Zq9Uq46RI
   +2Yug/0sHqjjI0v3P588FXWHc0AO5Y80YNp0iraAdZhnAuoRbAv6pxLct
   80qg9ZKuP02dJg3tR/pktHWKw8L5Q/nEwa+/RsAp6AxyxHj5Jnki0Rhvf
   w==;
X-CSE-ConnectionGUID: Paw6iOr5RBGaiA6586X0Jw==
X-CSE-MsgGUID: HaBbULhoQjOzpbw8DqWKRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34048272"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="34048272"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 22:24:39 -0700
X-CSE-ConnectionGUID: mxtmdO2fRYeN+IaFgY4+kw==
X-CSE-MsgGUID: PvRMVpGZRfq3aPjsKS10JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="100975545"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.198])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 22:24:33 -0700
Date: Thu, 29 Aug 2024 08:24:25 +0300
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
Message-ID: <ZtAGCSslkH3XhM7a@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-4-rick.p.edgecombe@intel.com>
 <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>

On Tue, Aug 13, 2024 at 02:08:40PM +0800, Binbin Wu wrote:
> On 8/13/2024 6:47 AM, Rick Edgecombe wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > --- a/arch/x86/include/asm/shared/tdx.h
> > +++ b/arch/x86/include/asm/shared/tdx.h
> > @@ -28,6 +28,12 @@
> >   #define TDVMCALL_STATUS_RETRY		1
> > +/*
> > + * TDG.VP.VMCALL Status Codes (returned in R10)
> > + */
> > +#define TDVMCALL_SUCCESS		0x0000000000000000ULL
> > +#define TDVMCALL_INVALID_OPERAND	0x8000000000000000ULL
> > +
> TDX guest code has already defined/uses "TDVMCALL_STATUS_RETRY", which is
> one
> of the TDG.VP.VMCALL Status Codes.
> 
> IMHO, the style of the macros should be unified.
> How about using TDVMALL_STATUS_* for TDG.VP.VMCALL Status Codes?
> 
> +/*
> + * TDG.VP.VMCALL Status Codes (returned in R10)
> + */
> +#define TDVMCALL_STATUS_SUCCESS 0x0000000000000000ULL
> -#define TDVMCALL_STATUS_RETRY                  1
> +#define TDVMCALL_STATUS_RETRY 0x0000000000000001ULL
> +#define TDVMCALL_STATUS_INVALID_OPERAND 0x8000000000000000ULL

Makes sense as they are the hardware status codes.

Regards,

Tony

