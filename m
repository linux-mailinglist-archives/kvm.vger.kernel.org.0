Return-Path: <kvm+bounces-9607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7F2866782
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 02:30:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCEC21F2182A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 01:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F046D53E;
	Mon, 26 Feb 2024 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLyTNF2B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826A2CA64;
	Mon, 26 Feb 2024 01:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708911046; cv=none; b=E8LyPbwettjXUUe62eGK4zjG4IsAnyZH6BlALDCdxFSe0FXYYRJ9sFgADQiwzIpOrbRnqX6EapJ80OMTIenJBDu6RqIk/ZPIgaW9XiXSzIG6Miq7N/mouS9xRN22HQjNxi18z0Q38oN2nzMSWaRXCa7HOwsvGm7U080plbyg7SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708911046; c=relaxed/simple;
	bh=pTe4Lw17jAWCBM2LXqFO/yfVCNiDCEmziDRbuSALlQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ckG4rQ2OZ5VyOcaLeuaADiXugNTR+PuUz8fwytRYJlz/9xIEzefEDcUCDVVl9NTBnZNLJFofHwAIbX/BQBbPgmwy1/uvBVDTyamhlsloK6MPNJqatCB2oLkOjNE1W98lbKVOMOCoILNlDPeplrrGD6pvbT1ZohwP+tBRegHqGOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLyTNF2B; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708911045; x=1740447045;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pTe4Lw17jAWCBM2LXqFO/yfVCNiDCEmziDRbuSALlQ4=;
  b=LLyTNF2BYlcVF0oNjbXGUAiR/9Whgh2dDXND3VLhf3h/1zlj23cS7/2y
   Cy2iRfmumtvI/ob5EeXeYvYyoupKw6FaEsQVBvJGKAdPvc92lyhSbTLzi
   mq0DqYcKOPivmEPGUJcsMzG1pyg88lWVdT6xHvJl8Rw2SWixzVWUGCldr
   to0uHlMMitveUuY64kuJtO8aFOWL3wNBmz/PpaUtn5skCQJ8FWJxf/mq2
   EUgIszJ1B8Pprb1CgU/BX/76eakzVlbRTOaFXn8YoGbfGI8eCswMF3yzV
   AHk5NLwnRj+lGeC2u1GmELhSKv9VWhtZ57jGRmKrDYHj/XG4giSz850X8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6994521"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6994521"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 17:30:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6511950"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.241.113]) ([10.124.241.113])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2024 17:30:38 -0800
Message-ID: <dfca56c5-770b-46a3-90a3-3a6b219048f2@intel.com>
Date: Mon, 26 Feb 2024 09:30:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yi Lai <yi1.lai@intel.com>, Tao Su <tao1.su@linux.intel.com>,
 Xudong Hao <xudong.hao@intel.com>
References: <20240110002340.485595-1-seanjc@google.com>
 <170864656017.3080257.14048100709856204250.b4-ty@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <170864656017.3080257.14048100709856204250.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/2024 9:35 AM, Sean Christopherson wrote:
> On Tue, 09 Jan 2024 16:23:40 -0800, Sean Christopherson wrote:
>> Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
>> whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
>> enumerated via MSR, i.e. aren't accessible to userspace without help from
>> the kernel, and knowing whether or not 5-level EPT is supported is sadly
>> necessary for userspace to correctly configure KVM VMs.
>>
>> When EPT is enabled, bits 51:49 of guest physical addresses are consumed
>> if and only if 5-level EPT is enabled.  For CPUs with MAXPHYADDR > 48, KVM
>> *can't* map all legal guest memory if 5-level EPT is unsupported, e.g.
>> creating a VM with RAM (or anything that gets stuffed into KVM's memslots)
>> above bit 48 will be completely broken.
>>
>> [...]
> 
> Applied to kvm-x86 vmx, with a massaged changelog to avoid presenting this as a
> bug fix (and finally fixed the 51:49=>51:48 goof):
> 
>      Add a VMX flag in /proc/cpuinfo, ept_5level, so that userspace can query
>      whether or not the CPU supports 5-level EPT paging.  EPT capabilities are
>      enumerated via MSR, i.e. aren't accessible to userspace without help from
>      the kernel, and knowing whether or not 5-level EPT is supported is useful
>      for debug, triage, testing, etc.
>      
>      For example, when EPT is enabled, bits 51:48 of guest physical addresses
>      are consumed by the CPU if and only if 5-level EPT is enabled.  For CPUs
>      with MAXPHYADDR > 48, KVM *can't* map all legal guest memory if 5-level
>      EPT is unsupported, making it more or less necessary to know whether or
>      not 5-level EPT is supported.
> 
> [1/1] x86/cpu: Add a VMX flag to enumerate 5-level EPT support to userspace
>        https://github.com/kvm-x86/linux/commit/b1a3c366cbc7

Do we need a new KVM CAP for this? This decides how to interact with old 
kernel without this patch. In that case, no ept_5level in /proc/cpuinfo, 
what should we do in the absence of ept_5level? treat it only 4 level 
EPT supported?



> --
> https://github.com/kvm-x86/linux/tree/next
> 


