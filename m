Return-Path: <kvm+bounces-19839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4557290C344
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 07:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1286B22265
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 05:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1D71CD32;
	Tue, 18 Jun 2024 05:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixyMLHDy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7494518E1D
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 05:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718690128; cv=none; b=aUJmGSdEAxTNaTEfHRGw9W0pMw/LHim5euiJ916l33tp3tt9y9RNtAnetNThnrjbCFAOxLjtSdYoJeOSy594CU19VBjNqYiDobiCLFyvhrwYhJPgRrG4spPtu73X6EIF5R8WeifskLS648YfVPUIR7kRjjGCIf+JEjgfwT7f3Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718690128; c=relaxed/simple;
	bh=ug3lPLbo89no+WyJHYxYvrRuIrcb8kYKzcp/IQHGM3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WpO0yg95+F1P6hHhcpJL97oXHCHpWi2wLaYXrLbVYbodq2yGRFRXTO24lDkUIH01S7Xw33EQV0iL8P6HaDlSSAGKae2gkkC9RFq1verhwX6f0x6vjxHkMVUT7KAhrBzL2TgorT8cZ1A51pM+BzXbmt9aGrATnvQI1nzRw2rUuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixyMLHDy; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718690128; x=1750226128;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ug3lPLbo89no+WyJHYxYvrRuIrcb8kYKzcp/IQHGM3k=;
  b=ixyMLHDyhYv3vEN11tNE53y6qEuJewEC8Qn8aLq1WQJuw3Bd2cGAa8tV
   yxk6OzzVQ55jLvy66HWIZxri0B8QLfRf1MKBk79XR5QBUSc6/ki8FGnUV
   nXDbiRIVlUJoyKoLnaRdFPeA4ARMHJjKhD5DnlPXSCbLPbyOOllPlDVoa
   jrsFMCqmfrUHLMbzlsOwasrxbQN238NzQSYx3KAnfS+U9+HtsCecZa7G5
   fLtj8oMVYqsyUgXUzYpbmdj5gzcVgASoa/2EgNX04dUgJ/MSr0NmhFOEK
   eQN0URzzDhXF+/N7Jf8CizjT0N53pYeqxPLaG0BZsOFCdNBVaLlAsQbM5
   w==;
X-CSE-ConnectionGUID: Gwcz8yXaR0yh8k5PcUvsDg==
X-CSE-MsgGUID: sVTk9rgxQS+8q/DAQTM+kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="15377470"
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="15377470"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 22:55:27 -0700
X-CSE-ConnectionGUID: 9ZyViSziTp6xW1enEIHC/Q==
X-CSE-MsgGUID: B3oFEXTiRY2v3NMvAOsBjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="41547301"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.125.242.247]) ([10.125.242.247])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 22:55:26 -0700
Message-ID: <d1c80ad9-9551-479a-84b5-dfe9b13fc9a2@linux.intel.com>
Date: Tue, 18 Jun 2024 13:55:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v6 4/4] x86: Add test case for INVVPID with
 LAM
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
 robert.hu@linux.intel.com
References: <20240122085354.9510-1-binbin.wu@linux.intel.com>
 <20240122085354.9510-5-binbin.wu@linux.intel.com>
 <ZmC0_4ZN---IZEdk@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZmC0_4ZN---IZEdk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/6/2024 2:57 AM, Sean Christopherson wrote:
> On Mon, Jan 22, 2024, Binbin Wu wrote:
>> +	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
> Checking for feature support seems superfluous, e.g. LA57 should never be set if
> it's unsupported.  Then you can do
>
> 	lam_mask = is_la57_enabled() ? LAM57_MASK : LAM48_MASK;
OK, will drop the feature check.

>
>> +		lam_mask = LAM57_MASK;
>> +
>> +	vaddr = alloc_vpage();
>> +	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
>> +	/*
>> +	 * Since the stack memory address in KUT doesn't follow kernel address
>> +	 * space partition rule, reuse the memory address for descriptor and
>> +	 * the target address in the descriptor of invvpid.
>> +	 */
>> +	operand = (struct invvpid_operand *)vaddr;
> Why bother backing the virtual address?  MOV needs a valid translation, but
> INVVPID does not (ditto for INVLPG and INVPCID, though it might be simpler and
> easier to just use the allocated address for those).

OK, will remove the unnecessary code.

>
>> +	operand->vpid = 0xffff;
>> +	operand->gla = (u64)vaddr;
>> +	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
>> +								 lam_mask);
>> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>> +	report(!fault, "INVVPID (LAM on): tagged operand");


