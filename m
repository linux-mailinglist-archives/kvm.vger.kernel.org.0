Return-Path: <kvm+bounces-20377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8543914489
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 152821C2105E
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3268E61FDF;
	Mon, 24 Jun 2024 08:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gl5H9rdZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58C961FC0
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719217221; cv=none; b=moiLyYAKKKuTC2kFofAeIvrAPHi8IOiYLKhw/EwCNqJ8woDg1euCiMAZaQc8i6Sr57VPgTZLCvofNfej//Bi8v/qUC7/pheg83x0u5gjdZcIMZIA9PC50KVAEnLvOUKC6mNW6SqAn53iUoWl5SJt8veqWcnW1oKad3xUEgjOrdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719217221; c=relaxed/simple;
	bh=GBbVrRtqaC9Uc8IVZ89+z4flR2yKlxZBRwKjcTHwNlQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hYm7Hj/CXf3Ruh8jg2k2SJIRqZpJzYBHTW3+8qGBW0Hl3Awe8kfq+gwK+U+PPUdGruo+N7NSB4br87IC8EATjRO11stgsOYxKRijUV3LqaKTBJQgCZVk8USRF/bNG6T5GC2rXWcwpPv0vFhsH+PzkN4/5mfzGXRZGVrDuccFnTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gl5H9rdZ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719217219; x=1750753219;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=GBbVrRtqaC9Uc8IVZ89+z4flR2yKlxZBRwKjcTHwNlQ=;
  b=Gl5H9rdZNwgxkjGAKKp7ALqqeZ2LC7/NbXCUHbFcdUp8JI1+6lzlRmWp
   w1BoOhjEKYGZPPJZkOudWQae/OLRJj79g5sVd90tBrqiGneaclr5JDIjt
   e4ijJIkqjApQ5DcpuA81cDcBfCICQxmbTyBFTFLrMbXPOhWgwT+h560h2
   pe6psLbA58BazUs0QdNncvIz7RkbRjw5YInr6d4X3KoeYAIMiO2hRxdW0
   X2T9CjHiTbyLtrpr/KFUvecBOT9r4j+qCSQJG/UsR0SIk9bz/o4iUOlO7
   pNx6pZ/wmkTLlF1YA2bLa7K8JH4S7VSnfAGUYO+szR0mlU2J2gAzflaPk
   w==;
X-CSE-ConnectionGUID: 7uZdwUxvTRCMkztSB/CYMA==
X-CSE-MsgGUID: eIISLLmcQ+WhKCFtQKSyfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11112"; a="15930255"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="15930255"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 01:20:19 -0700
X-CSE-ConnectionGUID: Kv4VgrVtRJecK8Qh3ljF2w==
X-CSE-MsgGUID: NW/j8MNBTdG3mGc0dLVPQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="48392723"
Received: from unknown (HELO [10.238.9.0]) ([10.238.9.0])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 01:20:18 -0700
Message-ID: <1be3d379-9052-4284-8ad8-70b03050fa91@linux.intel.com>
Date: Mon, 24 Jun 2024 16:20:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v6 4/4] x86: Add test case for INVVPID with
 LAM
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
 robert.hu@linux.intel.com
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
 <20240122085354.9510-5-binbin.wu@linux.intel.com>
 <ZmC0_4ZN---IZEdk@google.com>
 <d1c80ad9-9551-479a-84b5-dfe9b13fc9a2@linux.intel.com>
Content-Language: en-US
In-Reply-To: <d1c80ad9-9551-479a-84b5-dfe9b13fc9a2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/18/2024 1:55 PM, Binbin Wu wrote:
>
>
> On 6/6/2024 2:57 AM, Sean Christopherson wrote:
>> On Mon, Jan 22, 2024, Binbin Wu wrote:
>>> +    if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>> Checking for feature support seems superfluous, e.g. LA57 should 
>> never be set if
>> it's unsupported.  Then you can do
>>
>>     lam_mask = is_la57_enabled() ? LAM57_MASK : LAM48_MASK;
> OK, will drop the feature check.
>
>>
>>> +        lam_mask = LAM57_MASK;
>>> +
>>> +    vaddr = alloc_vpage();
>>> +    install_page(current_page_table(), virt_to_phys(alloc_page()), 
>>> vaddr);
>>> +    /*
>>> +     * Since the stack memory address in KUT doesn't follow kernel 
>>> address
>>> +     * space partition rule, reuse the memory address for 
>>> descriptor and
>>> +     * the target address in the descriptor of invvpid.
>>> +     */
>>> +    operand = (struct invvpid_operand *)vaddr;
>> Why bother backing the virtual address?  MOV needs a valid 
>> translation, but
>> INVVPID does not (ditto for INVLPG and INVPCID, though it might be 
>> simpler and
>> easier to just use the allocated address for those).
>
> OK, will remove the unnecessary code.

Sorry, the backing is still needed here.
The target address inside the invvpid descriptor (operand->gla) doesn't 
need a valid translation, but the invvpid descriptor itself needs a 
valid translation.

>
>>
>>> +    operand->vpid = 0xffff;
>>> +    operand->gla = (u64)vaddr;
>>> +    operand = (struct invvpid_operand 
>>> *)set_la_non_canonical((u64)operand,
>>> +                                 lam_mask);
>>> +    fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>>> +    report(!fault, "INVVPID (LAM on): tagged operand");
>
>


