Return-Path: <kvm+bounces-31525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43979C460C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B8A7B220D7
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 19:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F37FE1AA7AF;
	Mon, 11 Nov 2024 19:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4QNyNbw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B91B8468;
	Mon, 11 Nov 2024 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731354100; cv=none; b=nXH0EZ9P3uy1+dkeAw0rVBZLuG87Zi+O/M8U8Ic9We3XFcNRy25p8utt9k07dMvAaMv4PBg3WXPhR7r/95ROWf2JhnN4xlVqN5o2+hUfTDcXhVt6EbcjHD+zDmxs63bRvmBjy+naOCoDgXAMKB96qkAbznI1sG2dPusMSbtxDJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731354100; c=relaxed/simple;
	bh=E2Be+Um0D29lPNZMVbka1SWU3QlOOJ8gKrM8Hna7fD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kMZB2J2fpokXJUZs5vktPuM38MZtIlyzqp/zcuVDtvne+X7ZNKRk6N5PshYL558oIY1TXtjIkaudlaNAqMU7+9Hy8HK3okC0BVUmDIuWxAc3+e/BFXcP8hRTqubt5fLL7jd8/eKblmHERue/g3yjH+oGNz76B6j+FySs8rqKDEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4QNyNbw; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731354099; x=1762890099;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E2Be+Um0D29lPNZMVbka1SWU3QlOOJ8gKrM8Hna7fD0=;
  b=U4QNyNbwfVb2bcdQZ3n2Apnaig6vH1dy8zCxy4Fqmze3TzBC5McVO0m5
   EGE0o6giKeONZF/NdBpUwEYcxKTSMHQvgnjTqACNsFquJ038SNZ+yEn3R
   I3Zndm0+/IViUxI/QlYIuXpOyVkmULD90cUnI9rCmaK+c0Cdt1KIxlxL/
   SZQ3ZSVGZ2Vcah59zv+kT73MAp7QmugliCH3TJKOrUILjul3GjpK7dumC
   dCx6JaIGGsb80+TNA8zvha/FonzEEiSa8aFBxNGCoSHwVPfockOV8rjeP
   0Gtl1IbISkBHuo2M/uHVnhV64tUM3q9RyKOu52mWxrZ6UcqGX3IXFALxS
   g==;
X-CSE-ConnectionGUID: pjp8c9NRS6mcppWmxLB0vA==
X-CSE-MsgGUID: CQo/WM0kRcaaTsXaeWTdpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="34963072"
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="34963072"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 11:41:38 -0800
X-CSE-ConnectionGUID: lxuSWyxxSQOrPh6VQfbszA==
X-CSE-MsgGUID: Kcn6ta7pTJmzHSdxAWeG7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="91855774"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.124.223.216]) ([10.124.223.216])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 11:41:36 -0800
Message-ID: <4702f25d-0b01-484c-b542-767dcec97256@intel.com>
Date: Mon, 11 Nov 2024 11:41:35 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
To: Kai Huang <kai.huang@intel.com>, kirill.shutemov@linux.intel.com,
 tglx@linutronix.de, bp@alien8.de, peterz@infradead.org, mingo@redhat.com,
 hpa@zytor.com, dan.j.williams@intel.com, seanjc@google.com,
 pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com,
 adrian.hunter@intel.com, nik.borisov@suse.com
References: <cover.1731318868.git.kai.huang@intel.com>
 <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/11/24 02:39, Kai Huang wrote:
> TDX architecturally supports up to 32 CMRs.  The global metadata field
> "NUM_CMRS" reports the number of CMR entries that can be read by the
> kernel.  However, that field may just report the maximum number of CMRs
> albeit the actual number of CMRs is smaller, in which case there are
> tail null CMRs (size is 0).
> 
> Trim away those null CMRs, and print valid CMRs since they are useful
> at least to developers.
> 
> More information about CMR can be found at "Intel TDX ISA Background:
> Convertible Memory Ranges (CMRs)" in TDX 1.5 base spec [1], and
> "CMR_INFO" in TDX 1.5 ABI spec [2].
> 
> Now get_tdx_sys_info() just reads kernel-needed global metadata to
> kernel structure, and it is auto-generated.  Add a wrapper function
> init_tdx_sys_info() to invoke get_tdx_sys_info() and provide room to do
> additional things like dealing with CMRs.

I'm not sure I understand why this patch is here.

What does trimming buy us in the first place?

