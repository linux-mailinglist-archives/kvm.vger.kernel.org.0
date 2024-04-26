Return-Path: <kvm+bounces-16007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7EB8B2E3C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 03:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB9BA1F22340
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 01:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB1A17C2;
	Fri, 26 Apr 2024 01:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WbR292jS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38A3EA4
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714094214; cv=none; b=l5qgXW2tYmjkS6vEauhRPGr1jSvWEEfejMGl9rpt1sQLEKYoKiarEf+jse0zc7NNqxY+6F8+vUAbxxM8liepFPIVCiTTYhB+2XyAFMmQxtZQEhH9CkGAaCUsyeLSPQxMFXcY88pjM8bdqcuQTLpBykoyHZCe1i3+HJ4+P1cXQCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714094214; c=relaxed/simple;
	bh=gHL1To3t1rQvDw7ewsCpgKDSFotW6/GpzAXqL1wkUoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/QTq3+EemoaWvDjFilACCWEVruGkrqPDSl5n8UDZoih8GIQN5dytWEmfqe9aigGyBjjfi/Kc3I2U7eIwRGKGuv3CxfF90jLCpgzuDqL6wUms3VZXFyeOV3epSIzJf9BbCGmoriUHjRFqEvbHEm+KrCDNs7+WExLoU0brtRLoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WbR292jS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714094213; x=1745630213;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gHL1To3t1rQvDw7ewsCpgKDSFotW6/GpzAXqL1wkUoU=;
  b=WbR292jSM47j6q304YzocAbKyUFPd4Y6rnNMXnie7n+OZa1CXK9Jjb/d
   QfIR+PJsIwSshMjcWrdH3ymXqITDir24/qzVvqrv8jNW0U36I3BjZVwMv
   bWOicNwwo1IvWPdDpLgQ3k4kLi6v+l3v7NfvPhcgndU7t8BkmfYwFXofr
   ZNQZaB21ChYzAR5D6K7H5pV89bxsVmkpjFSBSL74SD6Tg8+TqIZIfDNZt
   xbfEm+EXRrFwzloj1SJUi2YIk/CGgnSiu+71v946lhuTRzUnBbKTe2230
   NgyFSTMbrMFmvj8eNHbc8XsogUOiem34IFODpXQxpLDRHkI1bc7qctFJ/
   Q==;
X-CSE-ConnectionGUID: BTiTRfCaSwC96ebodqVVLg==
X-CSE-MsgGUID: 3uxtf+UzQf+LoGEpYKYH4g==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="21238025"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="21238025"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:16:52 -0700
X-CSE-ConnectionGUID: xlY5NCbFQ0OFnwHvLVaPjg==
X-CSE-MsgGUID: Xglgjj/UScqthcxM994Peg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="29915363"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.50]) ([10.24.10.50])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 18:16:52 -0700
Message-ID: <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
Date: Thu, 25 Apr 2024 18:16:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
To: Kele Huang <kele@cs.columbia.edu>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org
References: <20240423024933.80143-1-kele@cs.columbia.edu>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240423024933.80143-1-kele@cs.columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/22/2024 7:49 PM, Kele Huang wrote:
> Function kvm_gfn_to_hva_cache_init() is exported and used to init
> gfn to hva cache at various places, such as called in function
> kvm_pv_enable_async_pf().  However, this function directly tail
> calls function __kvm_gfn_to_hva_cache_init(), which assigns
> ghc->memslot to NULL and returns 0 for cache initialization of
> cross pages cache.  This is unsafe as 0 typically means a successful
> return, but it actually fails to return a valid ghc->memslot.
> The functions call kvm_gfn_to_hva_cache_init(), such as
> kvm_lapic_set_vapicz_addr() do not make future checking on the
> ghc->memslot if kvm_gfn_to_hva_cache_init() returns a 0.  Moreover,
> other developers may try to initialize a cache across pages by
> calling this function but fail with a success return value.
> 
> This patch fixes this issue by explicitly restricting function
> kvm_gfn_to_hva_cache_init() to only accept address ranges within
> one page and adding comments to the function accordingly.
> 

For cross page cache, returning a zero is not really a mistake, since it
verifies the entire region against the memslot and does initialize ghc.

The nullified memslot is to indicate that the read or write should
follow the slow path, and it's the caller's responsibility to check
ghc->memslot if needed.  e.g., kvm_read_guest_offset_cached() and
kvm_write_guest_offset_cached().  Please refer to commit fcfbc617547f
("KVM: Check for a bad hva before dropping into the ghc slow path")

