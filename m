Return-Path: <kvm+bounces-12745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C4688D4D1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 03:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FF381C248D9
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 02:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDAD0225AE;
	Wed, 27 Mar 2024 02:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RgfTmEBs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A05F219FD;
	Wed, 27 Mar 2024 02:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711508091; cv=none; b=g3TFt/FFKJO0TXjDhg6IH367IM4dj04Yl9AHJDlSe7SGsLvYzp1gioGl0jD4ehMnbNvRNP49hOiRCLz68k//NaKMFQ5vr1kyE4zVn8EEDvPEDx7oTA7rrRIrC33Z/WRyNFN8gcC9pu3zh4APw+x1+vqYBSZ1BPDfPlHWvBkY38w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711508091; c=relaxed/simple;
	bh=xIKUdUOxhPeSjvi7wBh6frImJmN0BKUrySEAkp7ZeUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EznVreyQJArwa73mnVZYlJWLkyZj/aYwnvhMpX0Kuydfn35uUdJUqAAOqCuujll8ViLi2i9OX4tU+RWacgwKmpR4r3qkH3303MQjYgIHCfToHT4KVggDpMuiJIPtMi/0i4Xw/PpOm8/BVp3+cf0O5Hq5yAKHKRqIECYluJh+ZW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RgfTmEBs; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711508089; x=1743044089;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xIKUdUOxhPeSjvi7wBh6frImJmN0BKUrySEAkp7ZeUE=;
  b=RgfTmEBs57K3XriTkyYyagGNahZoB8OZN29i72CS5/eaLgKXvIiFqPxw
   SoYU+Tq4TpADP8V4ObbvxuJ7hzQWloJXMDq2OYHHBTjhsd08mP+ig7WgI
   BiRPi5a+F9Fw9+WaY4i5hLC4PsS4CnQluEtR6NKCryJXLxKuJU15uytcM
   sPEdroqIrPhWxmX/Z012jgA/2vEqN6tLqtPtqrvN01KddrEFvXa/8U3mV
   ns41ufiuF6I9ABfQTKsXGk2bM/8yE0v7e/Qpbu40ZmRiyJnWsJboiUvVN
   K/JV5t/VB+WJLhTN4y5QcPOZNpzWeHE4DphlVBLM+mCAMUday7SvSN3tZ
   w==;
X-CSE-ConnectionGUID: nEQsr2EdTt2t5F9Ahvm1wA==
X-CSE-MsgGUID: C+R5JO4wQ9qIYOBfjRIHJQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="24080066"
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="24080066"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 19:54:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,157,1708416000"; 
   d="scan'208";a="16806291"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2024 19:54:45 -0700
Message-ID: <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
Date: Wed, 27 Mar 2024 10:54:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Zhang, Tina" <tina.zhang@intel.com>,
 "isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Yuan, Hang"
 <hang.yuan@intel.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
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
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240326174859.GB2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/27/2024 1:48 AM, Isaku Yamahata wrote:
> On Tue, Mar 26, 2024 at 07:13:46PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
> 
>> On Tue, Mar 26, 2024 at 10:42:36AM +0800, Edgecombe, Rick P wrote:
>>> On Tue, 2024-03-26 at 10:32 +0800, Chao Gao wrote:
>>>>>>> Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
>>>>>>> Compile only tested at this point.
>>>>>>
>>>>>> Seems reasonable to me. Does QEMU configure a special set of MSRs to filter for TDX currently?
>>>>>
>>>>> No for TDX at the moment.  We need to add such logic.
>>>>
>>>> What if QEMU doesn't configure the set of MSRs to filter? In this case, KVM
>>>> still needs to handle the MSR accesses.
>>>
>>> Do you see a problem for the kernel? I think if any issues are limited to only the guest, then we
>>> should count on userspace to configure the msr list.
>>
>> How can QEMU handle MTRR MSR accesses if KVM exits to QEMU? I am not sure if
>> QEMU needs to do a lot of work to virtualize MTRR.
> 
> The default kernel logic will to return error for
> TDG.VP.VMCALL<RDMSR or WRMSR MTRR registers>.
> Qemu can have mostly same in the current kernel logic.
> 
> rdmsr:
> MTRRCAP: 0
> MTRRDEFTYPE: MTRR_TYPE_WRBACK
> 
> wrmsr:
> MTRRDEFTYPE: If write back, nop. Otherwise error.
> 
> 
>> If QEMU doesn't configure the msr filter list correctly, KVM has to handle
>> guest's MTRR MSR accesses. In my understanding, the suggestion is KVM zap
>> private memory mappings. But guests won't accept memory again because no one
>> currently requests guests to do this after writes to MTRR MSRs. In this case,
>> guests may access unaccepted memory, causing infinite EPT violation loop
>> (assume SEPT_VE_DISABLE is set). This won't impact other guests/workloads on
>> the host. But I think it would be better if we can avoid wasting CPU resource
>> on the useless EPT violation loop.
> 
> Qemu is expected to do it correctly.  There are manyways for userspace to go
> wrong.  This isn't specific to MTRR MSR.

This seems incorrect. KVM shouldn't force userspace to filter some 
specific MSRs. The semantic of MSR filter is userspace configures it on 
its own will, not KVM requires to do so.

