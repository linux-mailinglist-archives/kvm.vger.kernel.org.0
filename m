Return-Path: <kvm+bounces-51604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3925AF96D9
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA07454584B
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA6C28EA53;
	Fri,  4 Jul 2025 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i+JnHJYK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643934501A;
	Fri,  4 Jul 2025 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643219; cv=none; b=FoYQRXzV3e3LqIM+eBCqJsJ12+JyPk2sZkh/hAoUQeytXakl1yKqYWXUEQLNoM1uRGajtB3j3reOMlsnYiit4k55cnRPyYDtEU0SaZKuuT6tNBTWZt2R6gGa/i6h++pQyPphb23TvIceV6pt0LJTdwThJR0qnixIOZvNWcqKReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643219; c=relaxed/simple;
	bh=3rVSQb1ky4M9mYD6xyMObgEo62QkPRKguWFX5Vo8YAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ni/pFZDGIKtY/ALxM5bCd7mzPrWnLWj82t681g+0m/XHSGDMabEGBFhiBUUZRWc9V1FKVmPFhoZ16U/cmpOKSkVFEs2A7gbSjxi+ekVFnnI1bwxNKOTg7bwT7h2DGTG/0ehgADW7X+RWp8mFj36VK2pskT6AWO6mLs867gG1/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i+JnHJYK; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751643218; x=1783179218;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3rVSQb1ky4M9mYD6xyMObgEo62QkPRKguWFX5Vo8YAg=;
  b=i+JnHJYKOibBRVKUULjteh8kqusTDTlnc10PZsrm3mRlpNBPYX82hlnC
   Io6pestkilrGEhclZXNn/ooMxcc+lgfhQkpm4NzosV722Xa2GN3bhBSR3
   Bx20Z+40oASsYua9GzI7iQRNE1AyAfepS5lWYY4WgBELuDLQGNC740LBN
   SVYe1Rq8JrD7dAH1evGCFfL341jLAbS147lJjFcdJ3kXkqTfbka5tbg57
   w6zVe5n7npU5De2HENdDb5p1ls5O529v9d02pOzwb4hFASM+MYYOuipMf
   GzW9nWZSfiEvmHkdv6PzzENsqwhEgGXQzSjpPjG02KMVdtcbvaNXmFU6w
   A==;
X-CSE-ConnectionGUID: enCAj0LpQRqfdtsIyMRSCA==
X-CSE-MsgGUID: Op4v0MLWTdKg6piMaWpejQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11484"; a="57649290"
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="57649290"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 08:33:37 -0700
X-CSE-ConnectionGUID: l9ejXSAeSduUTXIB1im0JQ==
X-CSE-MsgGUID: hLIJHK+2TuKy3DmTShVZ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,287,1744095600"; 
   d="scan'208";a="159213942"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 08:33:30 -0700
Message-ID: <122349a0-9046-45c2-868c-5968b59b7834@intel.com>
Date: Fri, 4 Jul 2025 23:33:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: Adrian Hunter <adrian.hunter@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 x86@kernel.org, H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 chao.gao@intel.com
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-2-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703153712.155600-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2025 11:37 PM, Adrian Hunter wrote:
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and use it
> in place of tdx_clear_page().
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

