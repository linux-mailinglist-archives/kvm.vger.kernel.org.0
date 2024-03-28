Return-Path: <kvm+bounces-12915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DDF488F36A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FB8F1C26A58
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EC11FBA;
	Thu, 28 Mar 2024 00:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D9S5p5Gv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FD8363;
	Thu, 28 Mar 2024 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711584422; cv=none; b=hAJzBpBlcq/FaycVFRVeBrtXXnw6RRpkhZQVB0oJ0gxla/4DbY01H2plaMX1KKWneOX2xSMjCZQ/4pcHh5Hk+dUxOpacI3nAMVsFn0jnm2YeU52L384kIt/AkoMZzP6IzjuIVHboitJ8JwuFhukF4vwrextetjFEJuJ6JCsPMpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711584422; c=relaxed/simple;
	bh=3hEkNgmQddH/2BXruNuYCtM/9XJkyRMeb2eNMB6zyP0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QCC58BxhnAuDYk9s5TOIeKRcfV1jHOW48XRoC/7KtDpvCWs5lC0WEnqfPVxaZGcEX/8yb6e4cpY9AF/JnYiGRtbMAyLFYoHlxjGjO2UeGTC4F0t+JSygtpRBfDqpzXPUIByyyKOzIOGnDqFmEeSA0qqGfgvdj5PWa2Mc6CC/taE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D9S5p5Gv; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711584420; x=1743120420;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3hEkNgmQddH/2BXruNuYCtM/9XJkyRMeb2eNMB6zyP0=;
  b=D9S5p5GvPs/p8N+jPcgUyv/bVPMVFoYOVJngL5v5B3D8v6EIiSXia6a0
   SfFj33PsKqG9/Q19m00jxgIFwLbFqDWH+rkfMxwgMj3WfDK4Vrs5+Vv4r
   bOPzinnTddrnEunEr/G/YlRXboXulVzqbPZ5y3jL5yA/ePHkTUNlb2awK
   RGvEkl175IdktLn4rzHU8nLsS8Q5I4azBDQYkWn2Dk2DTrrjY6enHgTzy
   1MWABQTeY6nINqcmxv8nWSjaICkPtzNJp16NoNpd4Xoo5+voQPdxORI26
   lQ2yib9JFn85ujiApw2lViC2IbQygA5VGkkoiVhA+MUyNEAURRY1vGOAX
   w==;
X-CSE-ConnectionGUID: XXCtWHNUSFilZN2cioTzog==
X-CSE-MsgGUID: mrEVqmV+Q06BYOLWv6uGkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6908643"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6908643"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="20937873"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:06:56 -0700
Message-ID: <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
Date: Thu, 28 Mar 2024 08:06:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
 <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
 <hang.yuan@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
 <ZgIzvHKobT2K8LZb@chao-email>
 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
 <ZgKt6ljcmnfSbqG/@chao-email>
 <20240326174859.GB2444378@ls.amr.corp.intel.com>
 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/28/2024 1:36 AM, Edgecombe, Rick P wrote:
> On Wed, 2024-03-27 at 10:54 +0800, Xiaoyao Li wrote:
>>>> If QEMU doesn't configure the msr filter list correctly, KVM has to handle
>>>> guest's MTRR MSR accesses. 
>>>> In my understanding, the suggestion is KVM zap private memory mappings. 

TDX spec states that

   18.2.1.4.1 Memory Type for Private and Opaque Access

   The memory type for private and opaque access semantics, which use a
   private HKID, is WB.

   18.2.1.4.2 Memory Type for Shared Accesses

   Intel SDM, Vol. 3, 28.2.7.2 Memory Type Used for Translated Guest-
   Physical Addresses

   The memory type for shared access semantics, which use a shared HKID,
   is determined as described below. Note that this is different from the
   way memory type is determined by the hardware during non-root mode
   operation. Rather, it is a best-effort approximation that is designed
   to still allow the host VMM some control over memory type.
     • For shared access during host-side (SEAMCALL) flows, the memory
       type is determined by MTRRs.
     • For shared access during guest-side flows (VM exit from the guest
       TD), the memory type is determined by a combination of the Shared
       EPT and MTRRs.
       o If the memory type determined during Shared EPT walk is WB, then
         the effective memory type for the access is determined by MTRRs.
       o Else, the effective memory type for the access is UC.

My understanding is that guest MTRR doesn't affect the memory type for 
private memory. So we don't need to zap private memory mappings.

>>>> But guests won't accept memory again because no one
>>>> currently requests guests to do this after writes to MTRR MSRs. In this case,
>>>> guests may access unaccepted memory, causing infinite EPT violation loop
>>>> (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
>>>> the host. But I think it would be better if we can avoid wasting CPU resource
>>>> on the useless EPT violation loop.
>>>
>>> Qemu is expected to do it correctly.  There are manyways for userspace to go
>>> wrong.  This isn't specific to MTRR MSR.
>>
>> This seems incorrect. KVM shouldn't force userspace to filter some
>> specific MSRs. The semantic of MSR filter is userspace configures it on
>> its own will, not KVM requires to do so.
> 
> I'm ok just always doing the exit to userspace on attempt to use MTRRs in a TD, and not rely on the
> MSR list. At least I don't see the problem.

What is the exit reason in vcpu->run->exit_reason? 
KVM_EXIT_X86_RDMSR/WRMSR? If so, it breaks the ABI on 
KVM_EXIT_X86_RDMSR/WRMSR.

