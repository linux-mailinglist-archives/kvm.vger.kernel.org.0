Return-Path: <kvm+bounces-52630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C921B0753E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48E034E00E6
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563C42F4315;
	Wed, 16 Jul 2025 12:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXcUZf79"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BA01FECB0;
	Wed, 16 Jul 2025 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752667339; cv=none; b=Ay3CoQxs970UpyYxoANg0wCbKZaKHx5TrOzLCRtgaOzmyty63chVTZUNASFNyQJO+gGDFOAKkFU2/BmuK2GUXNq4LsjtaakR1DoXUW1PWwniGQVUCmPmjrsWwMX9hz3G87OIQNubORkU9J3mlqWA4AiKgYI4uF4I/Kx1Sw/7KIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752667339; c=relaxed/simple;
	bh=YDkjJ/FR4VY16/R/TYPixM7ci5vkGgf7C5bX+4c+lKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZcMLi7UCTV5HsElmFA7aoPmgrls8YdQtsBmxslho+UgHwiAU2eTgda6qUCX5gjnZ2cQyIFAhmeLkHuKdK/MBg3Edmj9f0WGO+Q5XV0UwYjNtxcHYUv20MVkN27/iST5ibNbxieJ4WKkPF/8oZM8ln3zZc/Up1L/IIq1+ThhNmK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXcUZf79; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752667338; x=1784203338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YDkjJ/FR4VY16/R/TYPixM7ci5vkGgf7C5bX+4c+lKQ=;
  b=OXcUZf79GDPATZzFd/d92yWOEDge2Y7XHZBEO9F4J4RuTDsq5tRlp3GR
   14WC7qyk844l+N9mvG+U8kn3FBKxdTkLNUwhyvpOnYz65ww4NZDZolQWU
   9BmrRU2D+0BBiIR+298Plhcn83EYZsOpFlxMAzle3GihvB4NMAW9IJz6+
   JM/QXq2IyN2sRA926VgCc5ZPIp7PcpgK0EQY0YntJbO8Stoo3o8fXyh6e
   nXCKM5iakU9jdbvoXHQLiXDv/grI9SxbLk8ev5svgJ1ce1R4hTSOu6+Yp
   BP+3nQhkIaWFTPkCrErC9Ba2icvCfeJMcB8DxUO0WjVe87/vJhJ37L3GP
   g==;
X-CSE-ConnectionGUID: sZYwYYqWS+uObXLwsgfLug==
X-CSE-MsgGUID: c8j4Ys0zSSif3RcYTCYXlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="77443291"
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="77443291"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:02:17 -0700
X-CSE-ConnectionGUID: 145ZkuStQ2SYn8mHxjRkqw==
X-CSE-MsgGUID: 7cPaGUvRRmOhozspvimeJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,316,1744095600"; 
   d="scan'208";a="157973432"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 05:02:01 -0700
Message-ID: <fa1ccce7-40d3-45d2-9865-524f4b187963@intel.com>
Date: Wed, 16 Jul 2025 20:01:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
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
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-3-tabba@google.com>
 <a4091b13-9c3b-48bf-a7f6-f56868224cf5@intel.com>
 <CA+EHjTy5zUJt5n5N1tRyHUQN6-P6CPqyC7+6Zqhokx-3=mvx+A@mail.gmail.com>
 <418ddbbd-c25e-4047-9317-c05735e02807@intel.com>
 <778ca011-1b2f-4818-80c6-ac597809ec77@redhat.com>
 <6927a67b-cd2e-45f1-8e6b-019df7a7417e@intel.com>
 <CA+EHjTz7C4WgS2-Dw0gywHy+zguSNXKToukPiRfsdiY8+Eq6KA@mail.gmail.com>
 <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <47395660-79ad-4d22-87b0-c5bf891f708c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 7:15 PM, David Hildenbrand wrote:
> On 16.07.25 13:05, Fuad Tabba wrote:
>> On Wed, 16 Jul 2025 at 12:02, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>
>>> On 7/16/2025 6:25 PM, David Hildenbrand wrote:
>>>> On 16.07.25 10:31, Xiaoyao Li wrote:
>>>>> On 7/16/2025 4:11 PM, Fuad Tabba wrote:
>>>>>> On Wed, 16 Jul 2025 at 05:09, Xiaoyao Li<xiaoyao.li@intel.com> wrote:
>>>>>>> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
>>>>>>>> The original name was vague regarding its functionality. This 
>>>>>>>> Kconfig
>>>>>>>> option specifically enables and gates the kvm_gmem_populate()
>>>>>>>> function,
>>>>>>>> which is responsible for populating a GPA range with guest data.
>>>>>>> Well, I disagree.
>>>>>>>
>>>>>>> The config KVM_GENERIC_PRIVATE_MEM was introduced by commit
>>>>>>> 89ea60c2c7b5
>>>>>>> ("KVM: x86: Add support for "protected VMs" that can utilize private
>>>>>>> memory"), which is a convenient config for vm types that requires
>>>>>>> private memory support, e.g., SNP, TDX, and KVM_X86_SW_PROTECTED_VM.
>>>>>>>
>>>>>>> It was commit e4ee54479273 ("KVM: guest_memfd: let 
>>>>>>> kvm_gmem_populate()
>>>>>>> operate only on private gfns") that started to use
>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM gates kvm_gmem_populate() 
>>>>>>> function. But
>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM is not for kvm_gmem_populate() only.
>>>>>>>
>>>>>>> If using CONFIG_KVM_GENERIC_PRIVATE_MEM to gate 
>>>>>>> kvm_gmem_populate() is
>>>>>>> vague and confusing, we can introduce KVM_GENERIC_GMEM_POPULATE 
>>>>>>> to gate
>>>>>>> kvm_gmem_populate() and select KVM_GENERIC_GMEM_POPULATE under
>>>>>>> CONFIG_KVM_GENERIC_PRIVATE_MEM.
>>>>>>>
>>>>>>> Directly replace CONFIG_KVM_GENERIC_PRIVATE_MEM with
>>>>>>> KVM_GENERIC_GMEM_POPULATE doesn't look correct to me.
>>>>>> I'll quote David's reply to an earlier version of this patch [*]:
>>>>>
>>>>> It's not related to my concern.
>>>>>
>>>>> My point is that CONFIG_KVM_GENERIC_PRIVATE_MEM is used for selecting
>>>>> the private memory support. Rename it to KVM_GENERIC_GMEM_POPULATE is
>>>>> not correct.
>>>>
>>>> It protects a function that is called kvm_gmem_populate().
>>>>
>>>> Can we stop the nitpicking?
>>>
>>> I don't think it's nitpicking.
>>>
>>> Could you loot into why it was named as KVM_GENERIC_PRIVATE_MEM in the
>>> first place, and why it was picked to protect kvm_gmem_populate()?
>>
>> That is, in part, the point of this patch. This flag protects
>> kvm_gmem_populate(), and the name didn't reflect that. Now it does. It
>> is the only thing it protects.
> 
> I'll note that the kconfig makes it clear that it depends on 
> KVM_GENERIC_MEMORY_ATTRIBUTES -- having support for private memory.
> 
> In any case, CONFIG_KVM_GENERIC_PRIVATE_MEM is a bad name: what on earth 
> is generic private memory.

"gmem" + "memory_attribute" is the generic private memory.

If KVM_GENERIC_PRIVATE_MEM is a bad name, we can drop it, but not rename 
it to CONFIG_KVM_GENERIC_GMEM_POPULATE.

> If CONFIG_KVM_GENERIC_GMEM_POPULATE is for some reason I don't 
> understand yet not the right name, can we have something that better 
> expresses that is is about KVM .. GMEM ... and POPULATE?

I'm not objecting the name of CONFIG_KVM_GENERIC_GMEM_POPULATE, but 
objecting the simple rename. Does something below look reasonable?

---
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2eeffcec5382..3f87dcaaae83 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -135,6 +135,7 @@ config KVM_INTEL_TDX
         bool "Intel Trust Domain Extensions (TDX) support"
         default y
         depends on INTEL_TDX_HOST
+       select KVM_GENERIC_GMEM_POPULATE
         help
           Provides support for launching Intel Trust Domain Extensions 
(TDX)
           confidential VMs on Intel processors.
@@ -158,6 +159,7 @@ config KVM_AMD_SEV
         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
         select ARCH_HAS_CC_PLATFORM
         select KVM_GENERIC_PRIVATE_MEM
+       select KVM_GENERIC_GMEM_POPULATE
         select HAVE_KVM_ARCH_GMEM_PREPARE
         select HAVE_KVM_ARCH_GMEM_INVALIDATE
         help
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 755b09dcafce..359baaae5e9f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, 
int max_order);
  #endif

-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
  /**
   * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
   *
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 49df4e32bff7..9b37ca009a22 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -121,6 +121,10 @@ config KVM_GENERIC_PRIVATE_MEM
         select KVM_GMEM
         bool

+config KVM_GENERIC_GMEM_POPULATE
+       bool
+       depends on KVM_GMEM && KVM_GENERIC_MEMORY_ATTRIBUTES
+
  config HAVE_KVM_ARCH_GMEM_PREPARE
         bool
         depends on KVM_GMEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..befea51bbc75 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -638,7 +638,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
kvm_memory_slot *slot,
  }
  EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);

-#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
+#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user 
*src, long npages,
                        kvm_gmem_populate_cb post_populate, void *opaque)
  {


