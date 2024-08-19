Return-Path: <kvm+bounces-24495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDA8956B99
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BA821C2208A
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F5916C6A4;
	Mon, 19 Aug 2024 13:14:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D673316C696;
	Mon, 19 Aug 2024 13:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073273; cv=none; b=k2CLLc0YSUBpYtJS9iFKVpL2Tt5C2lZ6KEpE96ZFk+Dk9LxtqmBnkEO4L6luDTZkuPic4Yqirsn0KKhVLXABWmhX4qFjEBGJ2CSGqJfxXmj8J+8yEXJHqg2w1t537BYcwlM9Ghzs6lvZc2bkaA/cD0GnXZjvgJQjmEm/DSkC/vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073273; c=relaxed/simple;
	bh=rc16Tw8Jfaiuo7ahDPjQiVd6wP3G1D+Mp34GXAenTzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=dnCtJrkTfXlG2ESiIN2h7iTLxL2BMbovtnXtvFDnHWMTvyXdAE6iJttw60QieBPMtcrJ6tr0jFcenXlR7bwx7lEoFvAssyr3ag+4JVWWW2p3s4cqkFSuzN2y+7RPKzhOP1YH94SxpdqkDt/OHEzaANVH7Q2ISRA7/WlQ1Cr0JNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WnXxP422Nz1j6lw;
	Mon, 19 Aug 2024 21:09:29 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E97721402E2;
	Mon, 19 Aug 2024 21:14:27 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 21:14:26 +0800
Message-ID: <498e0731-81a4-4f75-95b4-a8ad0bcc7665@huawei.com>
Date: Mon, 19 Aug 2024 21:14:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Content-Language: en-US
To: Peter Xu <peterx@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
	<axelrasmussen@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<x86@kernel.org>, Will Deacon <will@kernel.org>, Gavin Shan
	<gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zi Yan
	<ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, Alistair Popple
	<apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand
	<david@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	<kvm@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alex
 Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com> <Zr5VA6QSBHO3rpS8@x1n>
 <1147332f-790e-487f-8816-1860b8744ab2@huawei.com> <Zr9jIKp_vWyfCzQs@x1n>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <Zr9jIKp_vWyfCzQs@x1n>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/8/16 22:33, Peter Xu wrote:
> On Fri, Aug 16, 2024 at 11:05:33AM +0800, Kefeng Wang wrote:
>>
>>
>> On 2024/8/16 3:20, Peter Xu wrote:
>>> On Wed, Aug 14, 2024 at 09:37:15AM -0300, Jason Gunthorpe wrote:
>>>>> Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.
>>>>
>>>> There is definitely interest here in extending ARM to support the 1G
>>>> size too, what is missing?
>>>
>>> Currently PUD pfnmap relies on THP_PUD config option:
>>>
>>> config ARCH_SUPPORTS_PUD_PFNMAP
>>> 	def_bool y
>>> 	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>
>>> Arm64 unfortunately doesn't yet support dax 1G, so not applicable yet.
>>>
>>> Ideally, pfnmap is too simple comparing to real THPs and it shouldn't
>>> require to depend on THP at all, but we'll need things like below to land
>>> first:
>>>
>>> https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com
>>>
>>> I sent that first a while ago, but I didn't collect enough inputs, and I
>>> decided to unblock this series from that, so x86_64 shouldn't be affected,
>>> and arm64 will at least start to have 2M.
>>>
>>>>
>>>>> The other trick is how to allow gup-fast working for such huge mappings
>>>>> even if there's no direct sign of knowing whether it's a normal page or
>>>>> MMIO mapping.  This series chose to keep the pte_special solution, so that
>>>>> it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
>>>>> gup-fast will be able to identify them and fail properly.
>>>>
>>>> Make sense
>>>>
>>>>> More architectures / More page sizes
>>>>> ------------------------------------
>>>>>
>>>>> Currently only x86_64 (2M+1G) and arm64 (2M) are supported.
>>>>>
>>>>> For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
>>>>> on 1G will be automatically enabled.
>>
>> A draft patch to enable THP_PUD on arm64, only passed with DEBUG_VM_PGTABLE,
>> we may test pud pfnmaps on arm64.
> 
> Thanks, Kefeng.  It'll be great if this works already, as simple.
> 
> Might be interesting to know whether it works already if you have some
> few-GBs GPU around on the systems.
> 
> Logically as long as you have HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD selected
> below, 1g pfnmap will be automatically enabled when you rebuild the kernel.
> You can double check that by looking for this:
> 
>    CONFIG_ARCH_SUPPORTS_PUD_PFNMAP=y
> 
> And you can try to observe the mappings by enabling dynamic debug for
> vfio_pci_mmap_huge_fault(), then map the bar with vfio-pci and read
> something from it.


I don't have such device, but we write a driver which use
vmf_insert_pfn_pmd/pud in huge_fault,

static const struct vm_operations_struct test_vm_ops = {
         .huge_fault = test_huge_fault,
	...
}

and read/write it after mmap(,2M/1G,test_fd,...), it works as expected,
since it could be used by dax, let's send it separately.

