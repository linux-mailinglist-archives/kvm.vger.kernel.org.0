Return-Path: <kvm+bounces-58445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9685B94178
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 81D702A7D0A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FAE252910;
	Tue, 23 Sep 2025 03:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j86N3wRi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0AF5789D;
	Tue, 23 Sep 2025 03:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597608; cv=none; b=YC1Mpagml/xWX8pP7tEIqWvPmuALTQ1QIRQAel8kxG88iIE8xo879vGYK0aCzJO2nPRHb2TZXsOrSty8/Smgjb0DTcLJk+jZJSS6NR0iKcja0kCswTh2U/bYLTgkha0UTijYHuTW4OgPyuXgrbMVgMCx6WGTsrDSbXH071BMAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597608; c=relaxed/simple;
	bh=UTNHV7EzYz2RCe0aUYcV/EvPLOr/POAF+JlFNQ/315o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eep7XhsOUU1XpPPEsBk+tAuBob9CfNraqdgSiSETQag8DTvHlGw/Uu5JJfAPvw+b4h1DEJXkKpmi1klaH1SQWxlXaPKJimQQxxrSlDyeGuQHfJxcDSqvXRQpyrmEUTSMVENEzi+DcEeUrwfV5Wsxy/k6bQCiMei7zCvyMWCIiN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j86N3wRi; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758597607; x=1790133607;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UTNHV7EzYz2RCe0aUYcV/EvPLOr/POAF+JlFNQ/315o=;
  b=j86N3wRiQw1ZCIBq+liZsPqmzpjJ6plxGhA01oSXLJSDeWeRvtFqA5zY
   5LQKoimoA/csSAa7xJ0g9ziFrOMNp0mWEV7b0BAiA51e10jC4IiGYpFiq
   DNG2zEdlysMuNnA6zIc3ZV82OlBTiSKhUfbnKyyCLxjbUqUFOw75sP3rk
   nvfGcGrDgtEgzWbwbZnkPB/rOKqW7Q9Ye8fAwb53bfglVoEJioubAdktO
   0WganILJPATm96E6iQR+KJC12fRPCVnB2/tbslzSRZKI0Z/1vcs//b8o+
   593trAH7OiXzGp8r+tFQG9ivLlStoDjkosPxEgEFZ/eY3iH+RW/z8/6iB
   A==;
X-CSE-ConnectionGUID: 5fRo1/ulRZGJ6gB6sdJGmQ==
X-CSE-MsgGUID: +8L3Ci5mTCCHkFO7RUV4cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71975685"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="71975685"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:20:06 -0700
X-CSE-ConnectionGUID: UmT/oRYQT1WqG/FnTyYOTA==
X-CSE-MsgGUID: vqqZvvA/R2iKPAxHFPf6vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="207398169"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:20:04 -0700
Message-ID: <25a7a16f-ec73-4311-81ff-3adf62748040@intel.com>
Date: Tue, 23 Sep 2025 11:20:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250919214259.1584273-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/2025 5:42 AM, Sean Christopherson wrote:
> Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> and use the helper kvm_set_user_return_msr() to make it obvious that the
                      ^
the helper *in* kvm_set_user_return_msrs() ..

> double-underscores version is doing a subset of the work of the "full"
> setter.
> 
> While the function does indeed update a cache, the nomenclature becomes
> slightly misleading when adding a getter[1], as the current value isn't
> _just_ the cached value, it's also the value that's currently loaded in
> hardware.
> 
> Opportunistically rename "index" to "slot" in the prototypes.  The user-
> return APIs deliberately use "slot" to try and make it more obvious that
> they take the slot within the array, not the index of the MSR.
> 
> No functional change intended.
> 
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/all/aM2EvzLLmBi5-iQ5@google.com [1]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

