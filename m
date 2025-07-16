Return-Path: <kvm+bounces-52591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41472B0709A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:31:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7877D560F9B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAEE2EE979;
	Wed, 16 Jul 2025 08:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m+ije0PC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715AB2749DB;
	Wed, 16 Jul 2025 08:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654700; cv=none; b=s62OwU1deixQT2mQL8iiRGRS4JtNNE+57dOfWX5TfRcXSfno/7JuXAS0N9v9JFLqxgtazDH0dx3Zes+reZf+q+T4Bj7a4AfRdhswA0FSZLUtKTHWxPauk7BVua7O0aaEM5MGifEnVGJsj07hw/NIXkcTbSzTO6WPbTjyowdLjEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654700; c=relaxed/simple;
	bh=M8tEAX0g/+FHjCYjptDJd+fCfcSOLCtDuZhA2so9Vs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jhExvWQqqFt0hyF4XSVL8X5Mpdwagncqo6hpDld6+nKQ2xxLP6w0j+Z96pu/g56sPRYtFpehKAu3O77HrpAJ8IFy0Ngb/s9ADGrQDD5wRNo3GuwKhIu/r7LiY78IKspZOChBdl85Y7SsxxEhZxTgUOM3ltlGZwjkLsIiJZKlnH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m+ije0PC; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752654698; x=1784190698;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M8tEAX0g/+FHjCYjptDJd+fCfcSOLCtDuZhA2so9Vs8=;
  b=m+ije0PCXiTk3aCEYB1z5NPshRBpc/6hI16sqSR023mTZisrBMD34m6X
   /YdlJRY/JByZJiyL+l0eIjpRaiXzZDapQAm83UE+gjAZhu4TrmjNlOwy+
   nScbY49kke/0VMigr2jZNb8zHbFhApL+ztSz/MAyYKW0kU/nKfJJTBBXY
   imoNjMgECJ+IsOE697hWKQ7p4js9thiWuqGn40yRsCkUFyscskP7lb+Vi
   LB0EQMu+P1w/yXlxF8FhnmeX7mU6G+fineinWjNyr46Y98L7Hm8HLg00o
   dGSjauY7IdZrBo5bKBh/diT/t0CwZjB6rG9BdG0GLJ2vSKk7WtvaPFFnv
   w==;
X-CSE-ConnectionGUID: XP0hD86kRMGdbkfQ4MUwGA==
X-CSE-MsgGUID: 6KPrFpDFQwqlxgoK5x9yGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65955342"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="65955342"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 01:31:33 -0700
X-CSE-ConnectionGUID: nVOQ/N/PSSSwhIizbLv+DA==
X-CSE-MsgGUID: O80dBXWoQ8GoQDCI749OMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="162986525"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 01:31:18 -0700
Message-ID: <418ddbbd-c25e-4047-9317-c05735e02807@intel.com>
Date: Wed, 16 Jul 2025 16:31:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
 <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 4:11 PM, Fuad Tabba wrote:
> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>> The original name was vague regarding its functionality. This Kconfig
>>> option specifically enables and gates the kvm_gmem_populate() function,
>>> which is responsible for populating a GPA range with guest data.
>> Well, I disagree.
>>
>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit 89ea60c2c7b5
>> ("KVM: x86: Add support for "protected VMs" that can utilize private
>> memory"), which is a convenient config for vm types that requires
>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
>>
>> It was commit e4ee54479273 ("KVM: guest_memfd: let kvm_gmem_populate()
>> operate only on private gfns") that started to use
>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() function. But
>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
>>
>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate kvm_gmem_populate() is
>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE to gate
>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
>>
>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
> I'll quote David's reply to an earlier version of this patch [*]:

It's not related to my concern.

My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting 
the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is 
not correct.

Current code uses CONFIG_KVM_GENERIC_PRIVATE_MEM to gate 
kvm_gmem_populate() because kvm_gmem_populate() requires both gmem and 
memory attributes support and CONFIG_KVM_GENERIC_PRIVATE_MEM can ensure 
it. But CONFIG_KVM_GENERIC_PRIVATE_MEM was not only for gating 
kvm_gmem_populate().

>>> I'm curious what generic means in this name?
>> That an architecture wants to use the generic version and not provide
>> it's own alternative implementation.
>>
>> We frequently use that term in this context, see GENERIC_IOREMAP as one
>> example.
> [*]https://lore.kernel.org/all/b6355951-5f9d-4ca9-850f-79e767d8caa2@redhat.com/
> 
> Thanks,
> /fuad


