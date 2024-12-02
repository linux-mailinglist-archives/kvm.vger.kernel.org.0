Return-Path: <kvm+bounces-32809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CC09DFAC2
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 07:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F5D281953
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 06:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FFA51F9404;
	Mon,  2 Dec 2024 06:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QSWcNgEo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D533F6;
	Mon,  2 Dec 2024 06:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733121376; cv=none; b=VAj+VEpJcI/z0sC0ZlsBsLcBTySuJooyu2yq8gaks4/mUx1a7gZiWELA/T/iDh+QOV3Wg1HpcwaYHvIvs493potQTNwtJmoQX8UvQwSBP1GQf6fm9WltBtiYCYGtwpH2OsKLdtVbYudfFJij0Q+tn2sVUUrSFitsMnLtrYkHq3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733121376; c=relaxed/simple;
	bh=LC+fJ3vbEI+NdPBc84Eyj0Lc0zpeooAJNH+G8lVbmEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=It4SYar7UUztewKpy2NPUut+5CViRrE8gOCNZIXUWj2Mqzl3ic0sLhF1BeWF901lsz2t1CWtzY4MuXRxkm9Lsnj3vI0wngm5rqBshmk4jFZFBJ2JB6EMN3GYR66Unzq5ZAsLP2uYd4F6Oi0oqvzTCwutKl2+1ElNhKwPyoXop44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QSWcNgEo; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733121374; x=1764657374;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LC+fJ3vbEI+NdPBc84Eyj0Lc0zpeooAJNH+G8lVbmEE=;
  b=QSWcNgEo5VhIEji86+GHMp+Wwa2tPHtBQyaxprcuyI3FvEZuDSrd0u3K
   DQmns5ey0qNsuoYYZYnvORfE0jRr29Z7s6bVtMtXh/AvGRYKCB0P8Kasl
   ULOLgK6YQzdIbNWLHWGIad/+XxILfX145v9h22Wu+SPcMTKPaaewlnSq1
   d7N7HCY1+jmrVVnnW7eyLIX5h/105oIidkf7yR+mQITNSKA2a/OKlXxH8
   FFapH1rz7PN6Oee5UAVprI6iGcbaqBuzmYVwcK+CZoLjQtSJFoZSQ/nxu
   6pPTDWcqvltcHmvPN24c2XOvMUyv+/J6UnuYHAeRwck5fzCdYP3J2Xy65
   w==;
X-CSE-ConnectionGUID: NyymhBlzT22jVf8a1014XQ==
X-CSE-MsgGUID: 8KWK9pMKQHydjtdeIIkbNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11273"; a="43887698"
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="43887698"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 22:36:14 -0800
X-CSE-ConnectionGUID: 3I52U4gTS1C7+L02jgpFnw==
X-CSE-MsgGUID: 1OVXtrIITAKSHD2ZJdlZgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="123954282"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 22:36:08 -0800
Message-ID: <08b373ac-01b2-4afe-81bd-85e3fe13615d@intel.com>
Date: Mon, 2 Dec 2024 08:36:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 dmatlack@google.com, isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z0UwWT9bvmdOZiiq@intel.com>
 <5f4e8e8d-81e8-4cf3-bda1-4858fa1f2fff@intel.com> <Z00hAGYg1BQsiHJ5@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <Z00hAGYg1BQsiHJ5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/12/24 04:52, Chao Gao wrote:
>>>> /* 
>>>> * Before returning from TDH.VP.ENTER, the TDX Module assigns:
>>>> *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9)
>>>> *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
> 
> TILECFG state (bit 17) and TILEDATA state (bit 18) are also user state. Are they
> cleared unconditionally?

Bit 17 and 18 should also be in TDX_XFAM_XCR0_MASK
TDX Module does define them, from TDX Module sources:

	#define XCR0_USER_BIT_MASK                  0x000602FF

Thanks for spotting that!

> 
>>>> */
>>>> #define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
>>>> #define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
>>>> #define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)


