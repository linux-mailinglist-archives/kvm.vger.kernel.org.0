Return-Path: <kvm+bounces-24662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF7FF958E27
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 20:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACC061C21F1D
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 18:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD5814A603;
	Tue, 20 Aug 2024 18:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H7gu94oe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53324145336;
	Tue, 20 Aug 2024 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724179131; cv=none; b=NvAKyEYl1181vTmxUQUqZRHfCDmBSzUj9zjMFHkR9rHqeF+aOy/oTYY4htYtMTMFLsX98CuH9sxoH9WENVhzG6fNQAmU3Bzh2hjrmrGIuhvaG6R603bj+OxUYh27Ye0eWGyemDDavh5v7AMHwB5GFtygid/W9AYhhAES0geHxTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724179131; c=relaxed/simple;
	bh=20AVXm/0uUPdjJAMb2hQINv+OjKlcm7AL8U9uS97DEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIzA1hXb4Zwxp1Q0YygmGuNWJd6w/0zDBRTYN1ynY/pf9xM6+oV61u4iQuuVRzr9twG2sQ7y89jEksZuS7PrQqjZggMoLl6EZnh+T0aVpMP3pPZileeA46tipK9UomRpsmfqONgNRJ/pX4uI6bN5kTSyAKro5922VxDP3J0oDO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H7gu94oe; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724179129; x=1755715129;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=20AVXm/0uUPdjJAMb2hQINv+OjKlcm7AL8U9uS97DEg=;
  b=H7gu94oeHcC+DySlAltGhV468a19tvhuZEv59dJd+ValmWLhhRqAhulc
   Si0qZvThEsucGzNg0rYPAd8WBR3f3CzjcSSgF5WYq6YwFB1b05873uh2R
   HI2WuVvMy92r2VHfFw8pOG0uT6ZqXJHhN69MTiFRYcm1we1D8YpR5bu8G
   g5givR6BhbG8ZERes2qEiqdl52mxOTvBcs1k9zDr5m9MysVj5Sve08JWX
   6RQpO2znICpRcJ7Ufjidd0KRNSTf7o/GnD6BjuhM3fSrTewfzxiPmHqlj
   +gWUY3BtmjYNEkh86/wcWg8VPftlelmZr9JfWjFt7Hu8zaGfkbqsrThkj
   Q==;
X-CSE-ConnectionGUID: h+2EUuBHTCqkoFnYs3pVLw==
X-CSE-MsgGUID: 5U58F7t5ThCnY3nV05jdKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="33123338"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="33123338"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 11:38:48 -0700
X-CSE-ConnectionGUID: kaEVU4Q4TfGDN5lWr12CmA==
X-CSE-MsgGUID: ULbiAfDYQ9+PdbiIAtE4vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="61139753"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.81])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 11:38:43 -0700
Message-ID: <055622fb-93b9-49a3-804e-c2525edea4a2@intel.com>
Date: Tue, 20 Aug 2024 21:38:37 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, dan.j.williams@intel.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1721186590.git.kai.huang@intel.com>
 <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 861ddf2c2e88..4b43eb774ffa 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -40,6 +40,10 @@
>  #define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
>  #define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL
>  
> +#define MD_FIELD_ID_NUM_CMRS			0x9000000100000000ULL
> +#define MD_FIELD_ID_CMR_BASE0			0x9000000300000080ULL
> +#define MD_FIELD_ID_CMR_SIZE0			0x9000000300000100ULL

For scripted checking against "global_metadata.json" it might be better
to stick to the same field names e.g.

	MD_FIELD_ID_CMR_BASE0 -> MD_FIELD_ID_CMR_BASE




