Return-Path: <kvm+bounces-47856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA98AC6498
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 10:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0AE189A568
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 08:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A882126A0A7;
	Wed, 28 May 2025 08:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ONqR8pR+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE22269CF5;
	Wed, 28 May 2025 08:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748421359; cv=none; b=Bnh63DDvT/ggkPAKhuPQXo1OaCOuR84sU/GlqDKd+wi45BALvlqbEepT/zFFEb/cMScH+MX/q1+rpYYA2rVv70hEw+WE37Ja2QuLfIGiNZ2st1ACbjR/dGeq0zRALzz/nGQlIbJYoXj5TvPzVNRwTlLPwt8knznJEPs1cXfgDOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748421359; c=relaxed/simple;
	bh=zC6RfVpR24GC2DQDRKbj6v6ZzT4oGsPAyeKR4bvFIM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3tVWPaWEuZAwagSUCJgAYBs9Z/Crwhe+e9wQzuH0IFqLwJIIUihuc6ZmHOcuF+qtJbec9Kq5a9ZmEEw0P05L8dlBmKZCxhfjpPjnJxYMpH+W4v7oUeYXIM/gVD7q7WZ7rt5/+q7n75dsov9u6vSg8O35/YYtI358hsnnF1hwhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ONqR8pR+; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748421358; x=1779957358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zC6RfVpR24GC2DQDRKbj6v6ZzT4oGsPAyeKR4bvFIM8=;
  b=ONqR8pR+SzPjxsT1JDCpxb6G4g/GiAJhD2PTSA8CgEMfHSjuwPpeo5el
   IFUmnEIw1Fr3fP8nNW1dU97gMLzJZTB19fGelr5MZaglMjvvWZfHZpTP0
   TqN5x9B5Sey26lQllN9O+UIse6vNI95emImAY6e7dI5xxf9reLQ3ESe2a
   gpxdg7vlSPSu3Htcztc995fEwgTBb31FTqW5Q9d37Fewp8YqRgxdmcFcQ
   enL4IFo6ZEdykz6lSNiucE5jI1ZRqzv8pbbuPi9sBT5wIGa/Rzmt4kdgt
   yyGpq/wlUIFl+UHpzdppzDs3GOkXKCbWlLtehyFGRUZWOiV0KiPz29ZgN
   g==;
X-CSE-ConnectionGUID: P30fevplQ3GMzXzE9WKF/w==
X-CSE-MsgGUID: 4gkpNXjLReKiQk3kp7NO0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="53062877"
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="53062877"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 01:35:57 -0700
X-CSE-ConnectionGUID: 2X13U/L4S0+UGn5NnIHtXQ==
X-CSE-MsgGUID: +PuLB7i8SQqFwqHf8cSYAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="144148737"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 01:35:56 -0700
Message-ID: <aea0cc02-3b18-4c7e-9108-ab5e923051bf@intel.com>
Date: Wed, 28 May 2025 16:35:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] KVM: x86: Use kvzalloc() to allocate VM struct
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
References: <20250523001138.3182794-1-seanjc@google.com>
 <20250523001138.3182794-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250523001138.3182794-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/2025 8:11 AM, Sean Christopherson wrote:
> Allocate VM structs via kvzalloc(), i.e. try to use a contiguous physical
> allocation before falling back to __vmalloc(), to avoid the overhead of
> establishing the virtual mappings.  For non-debug builds, The SVM and VMX
> (and TDX) structures are now just below 7000 bytes in the worst case
> scenario (see below), i.e. are order-1 allocations, and will likely remain
> that way for quite some time.
> 
> Add compile-time assertions in vendor code to ensure the size of the
> structures, sans the memslos hash tables, are order-0 allocations, i.e.

s/memslos/memslots

> are less than 4KiB.  There's nothing fundamentally wrong with a larger
> kvm_{svm,vmx,tdx} size, but given that the size of the structure (without
> the memslots hash tables) is below 2KiB after 18+ years of existence,
> more than doubling the size would be quite notable.
> 
> Add sanity checks on the memslot hash table sizes, partly to ensure they
> aren't resized without accounting for the impact on VM structure size, and
> partly to document that the majority of the size of VM structures comes
> from the memslots.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

