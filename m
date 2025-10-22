Return-Path: <kvm+bounces-60800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8487DBFA581
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 08:53:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57CAA18C0731
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 06:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1C662F2916;
	Wed, 22 Oct 2025 06:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FTwnnr0N"
X-Original-To: kvm@vger.kernel.org
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FA2246BB0;
	Wed, 22 Oct 2025 06:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116007; cv=none; b=g0/B1qe88X9apBs7tZJkGdp58z8m+xh/G1BIB6cs+VzJgYgcIWHKZXZEpuwK+GSXU/RQRoMXzlMzfuLsScVQRL1hOfiqwBGIgSjaeREa0tmI8be/FsU6rOZ5dQpQwRLUA67G7+BHS7boT1LVuc3EAlZ39VTubqUkM+039KBBBsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116007; c=relaxed/simple;
	bh=8NQWyS1IcbxGD4Id05IwMMBC7+tBGiBE2LzZjTde18A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mhvuna6ZU/tLDj6VNJhGFgqFG8lsz5WPteRFAMujMZtXRe39nBKMumE1/jgEy7cCjDZGrnM/epp9ouVo1z+D3krAe3l+UuQqnASevw4gTE/IIBF6b6mgMEM3CtBWx40W4h6nGHmTvwlDmG0zISWzeL05vr+X+z0O2tMQMuEkv84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FTwnnr0N; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761115995; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lQL6SeVGx4c1D991//YZKaa0cyRKwryW27KFK0xeilY=;
	b=FTwnnr0N+YHQ/tBs+S2lYWBtSpcJnr6LuoLAShI4lBmq5lkFgBSl80WWxUegvi+GazI3oEmVWPqY0ko+eEjvcZkSdpmWwnY9aXHGxTY/SArSdPzcCEt2cIvWDM+GTAGmXD4vsoZEs2ktnFkTw9tyBFS/k9XFA9K3hxvIDnzbXcg=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqlkw1q_1761115990 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 14:53:12 +0800
Message-ID: <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
Date: Wed, 22 Oct 2025 14:53:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
To: "Luck, Tony" <tony.luck@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
 "ankita@nvidia.com" <ankita@nvidia.com>,
 "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi, Vikram"
 <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mochs@nvidia.com" <mochs@nvidia.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
 "alex@shazbot.org" <alex@shazbot.org>
Cc: "cjia@nvidia.com" <cjia@nvidia.com>,
 "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
 "targupta@nvidia.com" <targupta@nvidia.com>,
 "zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com"
 <dnigam@nvidia.com>, "kjaju@nvidia.com" <kjaju@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>,
 "u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/22 01:19, Luck, Tony 写道:
>>>      pfn = PHYS_PFN(physical_addr);
>>> -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>>
>> Tony,
>>
>> I'm not an SGX expert but does this break SGX by removing
>> arch_is_platform_page()?
>>
>> See:
>>
>> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
>> Cc: Tony Luck <tony.luck@intel.com>
>>
> Ira,
> 
> I think this deletion makes the GHES code always call memory_failure()
> instead of bailing out here on "bad" page frame numbers.
> 
> That centralizes the checks for different types of memory into
> memory_failure().
> 
> -Tony

Hi, Tony, Ankit and Ira,

Finally, we're seeing other use cases that need to handle errors for
non-struct page PFNs :)

IMHO, non-struct page PFNs are common in production environments.
Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memory
managed by a separate VMEM allocator. This VMEM allocator is designed
for virtual machine memory allocation, significantly reducing kernel
memory management overhead by minimizing page table maintenance.

To enable hardware error isolation for these memory pages, we've already
removed this sanity check internally. This change makes memory_failure()
the central point for handling all memory types, which is a much cleaner
architecture.

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks.
Shuai

