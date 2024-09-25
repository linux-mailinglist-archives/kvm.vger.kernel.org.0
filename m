Return-Path: <kvm+bounces-27399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A183E98509C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 03:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE51A1C22C3D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 01:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C77F013D2BC;
	Wed, 25 Sep 2024 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnjvZq9M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4688C13C683
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727227380; cv=none; b=qdmFgDZBLaQxwKoO1Xj0T+dOWVmaIB1DHzNFPpeZZzPLAd9Naua4YU7CtLcWEKuLySKDWiOScXVOHgoF26F8YpYEqvd2UYwUWcJb/fQ78R+dw09fREIVfdDKr3wgV9ZUrxJGtCsRvxvT2zDUxUqk3TyvGHhqSfj/w9Opbdu3nIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727227380; c=relaxed/simple;
	bh=wQvjgJUa25divElc33WjJ9NN9k+brV4M9RdBg97EQUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lR7Xzs+vNpnjo+y8h880nAByNnfkjO0tB4pI6vaq1tbDc/CNDI5ouEVn4927WxGwrK6M8lMaBLUcQNkg+nbWlAdm/TJUIcKSIurMZWNb9bMiwXjMPmfbxGvMzEWVkKCitAPWWomBwSPGykVx7FJEIEdEn7kxN4XTjq3HzqLYtGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnjvZq9M; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727227378; x=1758763378;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wQvjgJUa25divElc33WjJ9NN9k+brV4M9RdBg97EQUM=;
  b=fnjvZq9MnjVETOZvaqg+MdUDl3N0Luew7zCkNUgfQGPzCEkcYJZtXnjl
   DsqsS98B7B1WYeQ2Ld94XtBuge+YKIA2qJAm3RyW6jbmQwmYUSxKUq0qg
   nPgGC9XwoAQKoqldgUzsB2pC3F8jW50bV/gsfbyv5DLbl7r/c3bN215kD
   5wlPfIkWT+ulXfGG8qXs5oQYM8pu+BNScFhvf3IqYlm0DqDFCgKTKYVch
   NDpGxxXmMQDbmExx0920KvlotB10NWEsWr6ZT53ARN8QDYOfaBXnX1Ckd
   2hoo+R0DwBYB9aDsQksQcwI+K/d2znyc9O+n724CO0TdBrvVW9KxQ+kPE
   g==;
X-CSE-ConnectionGUID: U8CKx4SpQ9mh7YwBYLKGzQ==
X-CSE-MsgGUID: +y7wEHlLSeKXVsGL2QnL4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11205"; a="26406508"
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="26406508"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 18:22:57 -0700
X-CSE-ConnectionGUID: oT0T1v7YQum/2ZBh8EblmQ==
X-CSE-MsgGUID: OMLmzN8sT+2BnNhyH+ZWeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,256,1719903600"; 
   d="scan'208";a="71899562"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 18:22:56 -0700
Message-ID: <e4ea1632-f6bf-4e81-942b-54e3529a306b@linux.intel.com>
Date: Wed, 25 Sep 2024 09:22:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 0/5] x86: Add test cases for LAM
To: kvm@vger.kernel.org, seanjc@google.com
Cc: pbonzini@redhat.com, chao.gao@intel.com, robert.hu@linux.intel.com,
 robert.hoo.linux@gmail.com
References: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240701073010.91417-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Ping...

On 7/1/2024 3:30 PM, Binbin Wu wrote:
> Intel Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated address
> bits for metadata.
>
> The patch series add test cases for KVM LAM:
>
> Patch 1 moves struct invpcid_desc to header file for new test cases.
> Patch 2 makes change to allow setting of CR3 LAM bits in vmlaunch tests.
> Patch 3~5 add test cases for LAM supervisor mode and user mode, including:
> - For supervisor mode
>    CR4.LAM_SUP toggle
>    Memory/MMIO access with tagged pointer
>    INVLPG
>    INVPCID
>    INVVPID (also used to cover VMX instruction VMExit path)
> - For user mode
>    CR3 LAM bits toggle
>    Memory/MMIO access with tagged pointer
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
> ---
> Changelog:
> v7
> - Move struct invpcid_desc to header file instead of defining a new copy in lam.c.
> - Rename is_la57()/lam_sup_active() to is_la57_enabled()/is_lam_sup_enabled(),
>    and move them to processor.h (Sean)
> - Drop cr4_set_lam_sup()/cr4_clear_lam_sup() and use write_cr4_safe() instead. (Sean)
> - Add get_lam_mask() to get lam status based on the address and vCPU state. (Sean)
> - Drop the wrappers for INVLPG since INVLPG never faults. (Sean)
> - Drop the wrapper for INVPCID and use invpcid_safe() instead. (Sean)
> - Drop the check for X86_FEATURE_PCID. (Sean)
> - Rename lam_{u48,u57}_active() to is_lam_{u48,u57}_enabled(), and move them to
>    processor.h (Sean)
> - Test LAM userspace address in kernel mode directly to simplify the interface
>    of test_ptr() since LAM identifies a address as kernel or user only based on
>    the address itself.
> - Add comments about the virtualization hole of CR3 LAM bits.
> - Drop the check of X86_FEATURE_LA57 when check LA57. (Sean)
>
> v6
> - https://lore.kernel.org/kvm/20240122085354.9510-1-binbin.wu@linux.intel.com/
>
> v5
> - https://lore.kernel.org/kvm/20230530024356.24870-1-binbin.wu@linux.intel.com/
>
> Binbin Wu (4):
>    x86: Move struct invpcid_desc to processor.h
>    x86: Allow setting of CR3 LAM bits if LAM supported
>    x86: Add test cases for LAM_{U48,U57}
>    x86: Add test case for INVVPID with LAM
>
> Robert Hoo (1):
>    x86: Add test case for LAM_SUP
>
>   lib/x86/processor.h |  41 +++++++
>   x86/Makefile.x86_64 |   1 +
>   x86/lam.c           | 281 ++++++++++++++++++++++++++++++++++++++++++++
>   x86/pcid.c          |   6 -
>   x86/unittests.cfg   |  10 ++
>   x86/vmx_tests.c     |  51 +++++++-
>   6 files changed, 382 insertions(+), 8 deletions(-)
>   create mode 100644 x86/lam.c
>
>
> base-commit: d301d0187f5db09531a1c2c7608997cc3b0a5c7d


