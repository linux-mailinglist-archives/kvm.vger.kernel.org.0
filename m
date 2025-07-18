Return-Path: <kvm+bounces-52855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 785A4B09B0D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 737067AE556
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433D71E835D;
	Fri, 18 Jul 2025 05:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g/yu3qE0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0251DE4E1;
	Fri, 18 Jul 2025 05:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752818266; cv=none; b=YS8Jvp348/D8jdsRKxpHwLw+b9eXyZ4K0b/As8ADyKdcsjePoiCcpI/vzpRumKy0qGolCbcGvVZCwTaA7YlxB5Em2vcBaGRu2K27IOU7KKUD1fGqpSxtIJUj8eWH8HG1bKgf8+i4GAra2fVC86o9o+59ztbUN2SWzMLOBjeDdpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752818266; c=relaxed/simple;
	bh=6HyipH6ZGn2eTCwtX/8w8N8MbCivU7M119JVojMbDow=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UMStaDm6g7+EtD7TXGsmhf1CAh4IkGvxgjr128OELegC4cWrUnf1NaZq4erHA2Pyyr6pek2j9wVJcPmoK/kcPCprUaeQixPOR1iMMOw+nQKC8mDvEVfs96H5bfk8H/YIdGoK2+srDBmBOpKW4mr29gonQrEiyt8v2I94SIo6nhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g/yu3qE0; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752818264; x=1784354264;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=6HyipH6ZGn2eTCwtX/8w8N8MbCivU7M119JVojMbDow=;
  b=g/yu3qE005OQnYf9YgH/Z1RaiMHznwySxFQmv10EQJUBtjktnx+UNhvH
   wzrnh/lXVeszP3TKacpkmTTkwhABckWrS606oQgaUzTi9Eb0rRKDaoRj5
   IBz9TfJT0dVlc2JNA1Gu/6PL0MKl8nbqqq6wIByqpTcNU+4tOUXnmNSOU
   /K2cgdaf7kXyAzYLc6gFNBk2UAFMfdSQ1YWjEPZlwek5UYo7KAf/ORBli
   8nzhgAmzqB482spHtNl/34JzM48M7WU75CMHDpMzkAFRPWnQ14oWOUJ8o
   cfBVW7I/KNAodnVD/78zGx+6ucA7A0Q9tyQWgmHnbsN5Mre39Oy9Z4tKW
   A==;
X-CSE-ConnectionGUID: jfvhYIWFSme1khIB3xWuNA==
X-CSE-MsgGUID: 3UIL3NaPRvK54yyC6iUi/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="54963627"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="54963627"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:57:43 -0700
X-CSE-ConnectionGUID: gGSQjf1oTiKmkpHzD1CHqg==
X-CSE-MsgGUID: 7MpZdOhSSiy/G0j+1Lk4Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188960541"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:57:28 -0700
Message-ID: <8db83e78-8e18-4cdb-b8eb-80351c5273fc@intel.com>
Date: Fri, 18 Jul 2025 13:57:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/21] KVM: x86/mmu: Consult guest_memfd when
 computing max_mapping_level
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250717162731.446579-1-tabba@google.com>
 <20250717162731.446579-13-tabba@google.com>
 <9b425918-1858-47d6-a1cd-1b44d5898ab4@intel.com>
Content-Language: en-US
In-Reply-To: <9b425918-1858-47d6-a1cd-1b44d5898ab4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/2025 1:32 PM, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Modify kvm_mmu_max_mapping_level() to consult guest_memfd for memory
>> regions backed by it when computing the maximum mapping level,
>> especially during huge page recovery.
> 
> IMHO, we need integrate the consultation of guest_memfd into 
> __kvm_mmu_max_mapping_level, not kvm_mmu_max_mapping_level().
> 
> __kvm_mmu_max_mapping_level() (called by kvm_mmu_hugepage_adjust()) is 
> the function KVM X86 uses to determine the final mapping level,
> fault->goal_level.
> 

I think I can understand the patch now.

For normal TDP page fault that requires KVM to setup the TDP page table 
to map the guest memory. The max page level of guest memfd is consulted 
when faulting in the pfn in kvm_mmu_faultin_pfn_private() and update 
fault->max_level accordingly. So skip consultation in 
__kvm_mmu_max_mapping_level() is OK.

But for recover_huge_pages_range() and kvm_mmu_zap_collapsible_spte() 
(this patch misses this case) which call kvm_mmu_max_mapping_level() and 
without information of the max page level of guest memfd. So we need to 
consult guest memfd separately.

But the changelog doesn't clarify it such way.


