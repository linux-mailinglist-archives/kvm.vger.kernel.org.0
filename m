Return-Path: <kvm+bounces-15488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B3A88ACC45
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACDD3B221A2
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 11:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FE9146D7D;
	Mon, 22 Apr 2024 11:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8QOSHnm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1114430B;
	Mon, 22 Apr 2024 11:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713786396; cv=none; b=H8Vlip2dJOc7mKdTlKvARgr4nVdDFTRCAwjSB3mefTYH15QWvkvDF5z4v9IOVD5WfEH0rhfVo+XV9Vm2rkfBAGGXbEtS8Igdxk6B5mrO35uGWtxwTWlKmomGgfn96CtIJBBloSwnGLaItsswE9O35Oz1/nPUK5TI8LehBIw3DcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713786396; c=relaxed/simple;
	bh=1hlSkEjrrBoum+9LYxCMsFDrIJupO+YIajpf9DAWRrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DriLc1CtqrnaafC/JYbMGOoRc/J1rcvxIPHbcH6Okia+EAN29jPlvl9LdIjwj98162FWu6edy3/QneHSoi1JYaDckEFnkB5PMoTkKaYDo0D4yi5lqcX31kRbgw6yRAsd1sVSq13TfkzF38OfLU9yP+vT9ldJQmf8vIpc5w6Hadk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8QOSHnm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713786395; x=1745322395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1hlSkEjrrBoum+9LYxCMsFDrIJupO+YIajpf9DAWRrM=;
  b=W8QOSHnm7CZnw3V/Atbr30kwui2LGeAqWiiJqCSIwxM4Gkh4XSYRby36
   aZzoYhk3JbZNCrY7ns2WsFxkxbBo9HgHLH0LV0+wqYDQgq9lV0uautsLm
   nYdA3D8BaxW3hi0F6rFDE96iz3zh4L2OvpF0hJHVAqxjYDHYBEUzAZgHv
   1Yffec9GKuUN+uTOB1G9h0AfJ5/xPJuCxF88SRTJmvxEVvx8AK7lc7uhU
   WO9h3MG9VInKNtr9iFeKpn34URQNe643rP4kbfOmRVl75LWbcL0hDAG9z
   Sju8mHPjDerbPlIq2D31avLD0M2dbfmsYo8WC/LJEu6iRg/qAyeIHLG+b
   w==;
X-CSE-ConnectionGUID: ompUvJHySYWofBQ+chcLng==
X-CSE-MsgGUID: tjT1tbUpSL+iXm0rU0eNZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11051"; a="12257918"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="12257918"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 04:46:34 -0700
X-CSE-ConnectionGUID: W7489JvvSNCWB5ZeIp15BQ==
X-CSE-MsgGUID: He9L6VxLRQ6eGUJ9oEzXBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="24062817"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa007.fm.intel.com with ESMTP; 22 Apr 2024 04:46:30 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 80182FD; Mon, 22 Apr 2024 14:46:29 +0300 (EEST)
Date: Mon, 22 Apr 2024 14:46:29 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "seanjc@google.com" <seanjc@google.com>, 
	"Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "Chen, Bo2" <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Message-ID: <no7n57wmkm3pdkannl2m3u622icfdnof27ayukgkb7q4prnx6k@lfm5cnbie2r5>
References: <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
 <ZfR4UHsW_Y1xWFF-@google.com>
 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
 <ZiFlw_lInUZgv3J_@google.com>
 <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
 <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>

On Fri, Apr 19, 2024 at 08:04:26PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2024-04-19 at 17:46 +0300, kirill.shutemov@linux.intel.com wrote:
> > 
> > > Side topic #3, the ud2 to induce panic should be out-of-line.
> > 
> > Yeah. I switched to the inline one while debugging one section mismatch
> > issue and forgot to switch back.
> 
> Sorry, why do we need to panic?

It panics in cases that should never occur if the TDX module is
functioning properly. For example, TDVMCALL itself should never fail,
although the leaf function could.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

