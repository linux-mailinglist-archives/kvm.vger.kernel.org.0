Return-Path: <kvm+bounces-58741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8235FB9ED88
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88C5F188EBEE
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 11:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C371D63D3;
	Thu, 25 Sep 2025 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSBVZ+3y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067C62E9743
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758798056; cv=none; b=GkcfROKeV/iDv83WWjHrwbNDyau1hh3ovZKvgx3zTAtzQgPvBdl2qrswaIDFPkwVmFNOz8e9ZjrBgT2+v6Wu4sDkoX8L2C36j+cVzlk0spNN5IiZey9kRRbN2gpYytPhu6ZmLbAGDqXOK0bSSnkNdMcZOLqK91atG76tzh5mi0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758798056; c=relaxed/simple;
	bh=WNLFrvOskwWENrF4CXX4Z4D7EhOVVB95cs7xFI3xkw0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0RiMp8qrtlpRRpxuHBBHO7O2kVPsBOZvFjOnAsW/93+oQqI22y561TkFpyxdeD2ApFizocCHSDI3g3Nc/x/Fef3gTlPPm7nVQ4oVD9ToETnk30iwhFeQf5Y6Dlz64gSddT7gxwjiAF2oErRZtLKkyMeMRRmBs60RmmOqqYR9E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YSBVZ+3y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758798053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LsFjckaZRSZSgvIBBGozNR9QSfDm9ZdOZyuvNGkLoik=;
	b=YSBVZ+3ynHMzQ6isRHnb4Cw32CrMrNNX9jfwnVxUuYVjnX35B23Syw1LwBikenmr1GXUWi
	xRzBtVMh9joA7LMSInPL7YMAk6xAY/mY+AitvBgt0no0KsonJMLBhwn/Rli/JcDabcUrcY
	n/qdjlWV+ERchNoZA0mikQ5ZDu1i36Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-x6-u_5nrNc6o8xKVv4aQ1w-1; Thu, 25 Sep 2025 07:00:51 -0400
X-MC-Unique: x6-u_5nrNc6o8xKVv4aQ1w-1
X-Mimecast-MFC-AGG-ID: x6-u_5nrNc6o8xKVv4aQ1w_1758798050
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46da436df64so9527645e9.0
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 04:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758798050; x=1759402850;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LsFjckaZRSZSgvIBBGozNR9QSfDm9ZdOZyuvNGkLoik=;
        b=Hd1rCSdsFkpbp9g59M2qDX88Gjpuu66kr0t+E0bSAUmr5hq90ydy3DGbyRxzG4ZuAC
         T+3WscXxRohxQ5wWR3HBdS4rRyjo09kNEhSzEYmNTRVPkXm6D1Hg1WY4CsOFQTnTVk9e
         E88l/LhkE/wamX3w3dJI2948JhkiANnXH6T6FfH6xHew7wB7ZkxgC6TeCCfIXKjPeQtF
         F3XDu2ugwo5RC6Cbk2pXpTzTt8chyk9PEnz6cE8iwmlNqi2/4J8dbNw4Q0v7lMV85NVe
         g/CNKZYbDwygSm/76hhgEBeClKlWZ7Cis2cC5crpZdl3UhC0kA6eJd8jjbEE+vEgUs5Z
         jGug==
X-Forwarded-Encrypted: i=1; AJvYcCU5j6gBf8e0Ghh3hRevgX9EBJldmxVVFp58WplfGqLnz5//rv2YS8u+PUvx87KeUJMJzEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9/ZMfcnl25BBoQFMiTYiHj1C45foV5a+vmroJeVpHo6h7hXbg
	m/cj3518WGwb/BRMQUv/xTXKPRO+cC6MBk2GvN/VMtGo0V30nzGhLNfxEWS0xscSK2UP8feegia
	LlzQaRUoOMJhwDJ04sldZKcYF0wSkm7bDrKQsZhtLVJVjZDxR+moQzg==
X-Gm-Gg: ASbGncvili+xwN7V+q9HyooYYaDlPXBROVWWcfwgqAXSHU3+Rli+1Bwt0x3lXGn2dE8
	wsU+goF6/wxtfsIhWpIyY0oaIOr1kZf2iwzdSwvWkQtaM8N7578rVYBaxYdjOGlnaQoaLreCNsn
	1QkmX6OrWZmIYNIqVn7qZeoojXHB21PvJgrtbtq6cN49e/1y4o2C61s2jT88PjNdu0YDyb+N/SF
	CcHnWNyLla1NKX4nzBrgWPi1mMtXQua/vtaHGaP5v8+ZlZb4RWNx3RCztMTDSvM2OpBK4s8KQ1B
	ReHnCWo0F69cXrkwraKUyHt3aM/AMncr7StDle2dRcfs5p9IQcVppnMZh2UUYsRJkQTuErnh5Um
	8tgq4t9iPBlKRL6+oJhccc6WKt2qdxJ93uNgyqYRIWEts4xh7ftHbZU3vxJWuqOfKjJMo
X-Received: by 2002:a05:600c:1554:b0:45d:d6fc:24f7 with SMTP id 5b1f17b1804b1-46e32a158camr31228575e9.32.1758798050155;
        Thu, 25 Sep 2025 04:00:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBJES16mG0dvjX/+8YEMFt/mXYaxImgtqz08XZYHmHVSOGfz52OI8Lf1kSYhL10lrl8HbeQA==
X-Received: by 2002:a05:600c:1554:b0:45d:d6fc:24f7 with SMTP id 5b1f17b1804b1-46e32a158camr31227445e9.32.1758798049427;
        Thu, 25 Sep 2025 04:00:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6de90desm2659224f8f.47.2025.09.25.04.00.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:00:48 -0700 (PDT)
Message-ID: <a02996f3-fdf4-4b5f-85b6-d79b948b3237@redhat.com>
Date: Thu, 25 Sep 2025 13:00:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924152214.7292-2-roypat@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.09.25 17:22, Roy, Patrick wrote:
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
> 
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> 
> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether
> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on
> guest_memfd itself being supported, but also on whether linux supports
> manipulatomg the direct map at page granularity at all (possible most of
> the time, outliers being arm64 where its impossible if the direct map
> has been setup using hugepages, as arm64 cannot break these apart due to
> break-before-make semantics, and powerpc, which does not select
> ARCH_HAS_SET_DIRECT_MAP, though also doesn't support guest_memfd
> anyway).
> 
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
> 
> Direct map entries are zapped right before guest or userspace mappings
> of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> kvm_gmem_get_pfn() [called from the KVM MMU code]. The only place where
> a gmem folio can be allocated without being mapped anywhere is
> kvm_gmem_populate(), where handling potential failures of direct map
> removal is not possible (by the time direct map removal is attempted,
> the folio is already marked as prepared, meaning attempting to re-try
> kvm_gmem_populate() would just result in -EEXIST without fixing up the
> direct map state). These folios are then removed form the direct map
> upon kvm_gmem_get_pfn(), e.g. when they are mapped into the guest later.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>   Documentation/virt/kvm/api.rst    |  5 +++
>   arch/arm64/include/asm/kvm_host.h | 12 ++++++
>   include/linux/kvm_host.h          |  6 +++
>   include/uapi/linux/kvm.h          |  2 +
>   virt/kvm/guest_memfd.c            | 61 ++++++++++++++++++++++++++++++-
>   virt/kvm/kvm_main.c               |  5 +++
>   6 files changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index c17a87a0a5ac..b52c14d58798 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supported, the 'flags' field
>   supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation
>   enables mmap() and faulting of guest_memfd memory to host userspace.
>   
> +When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' field
> +supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest_memfd
> +instance behave similarly to memfd_secret, and unmaps the memory backing it from
> +the kernel's address space after allocation.
> +

Do we want to document what the implication of that is? Meaning, 
limitations etc. I recall that we would need the user mapping for gmem 
slots to be properly set up.

Is that still the case in this patch set?

>   When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>   guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
>   consumed from guest_memfd, regardless of whether it is a shared or a private
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2f2394cce24e..0bfd8e5fd9de 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>   #include <linux/maple_tree.h>
>   #include <linux/percpu.h>
>   #include <linux/psci.h>
> +#include <linux/set_memory.h>
>   #include <asm/arch_gicv3.h>
>   #include <asm/barrier.h>
>   #include <asm/cpufeature.h>
> @@ -1706,5 +1707,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>   void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>   void check_feature_map(void);
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +static inline bool kvm_arch_gmem_supports_no_direct_map(void)
> +{
> +	/*
> +	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),
> +	 * as it calls dcache_clean_inval_poc().
> +	 */
> +	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);
> +}
> +#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_direct_map
> +#endif /* CONFIG_KVM_GUEST_MEMFD */
>   

I strongly assume that the aarch64 support should be moved to a separate 
patch -- if possible, see below.

>   #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1d0585616aa3..73a15cade54a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>   #endif
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifndef kvm_arch_gmem_supports_no_direct_map
> +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> +#endif

Hm, wouldn't it be better to have an opt-in per arch, and really only 
unlock the ones we know work (tested etc), explicitly in separate patches.


[...]

>   
>   #include "kvm_mm.h"
>   
> @@ -42,6 +45,44 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>   	return 0;
>   }
>   
> +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> +
> +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> +{
> +	return ((u64) folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;
> +}
> +
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		return 0;
> +
> +	int r = set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
> +					 false);
> +
> +	if (!r) {
> +		unsigned long addr = (unsigned long) folio_address(folio);

empty line missing.

> +		folio->private = (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +		flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +	}
> +
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{
> +	/*
> +	 * Direct map restoration cannot fail, as the only error condition
> +	 * for direct map manipulation is failure to allocate page tables
> +	 * when splitting huge pages, but this split would have already
> +	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_folio_zap_direct_map().
> +	 * Thus set_direct_map_valid_noflush() here only updates prot bits.
> +	 */
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
> +					 true);
> +}
> +
>   static inline void kvm_gmem_mark_prepared(struct folio *folio)
>   {
>   	folio_mark_uptodate(folio);
> @@ -324,13 +365,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   	struct inode *inode = file_inode(vmf->vma->vm_file);
>   	struct folio *folio;
>   	vm_fault_t ret = VM_FAULT_LOCKED;
> +	int err;
>   
>   	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>   		return VM_FAULT_SIGBUS;
>   
>   	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>   	if (IS_ERR(folio)) {
> -		int err = PTR_ERR(folio);
> +		err = PTR_ERR(folio);
>   
>   		if (err == -EAGAIN)
>   			return VM_FAULT_RETRY;
> @@ -348,6 +390,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>   		kvm_gmem_mark_prepared(folio);
>   	}
>   
> +	err = kvm_gmem_folio_zap_direct_map(folio);
> +

I'd drop this empty line here.

> +	if (err) {
> +		ret = vmf_error(err);
> +		goto out_folio;
> +	}
> +
>   	vmf->page = folio_file_page(folio, vmf->pgoff);
>   
>   out_folio:
> @@ -435,6 +484,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>   	kvm_pfn_t pfn = page_to_pfn(page);
>   	int order = folio_order(folio);
>   
> +	kvm_gmem_folio_restore_direct_map(folio);
> +
>   	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>   }
>   
> @@ -499,6 +550,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>   	/* Unmovable mappings are supposed to be marked unevictable as well. */
>   	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>   
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>   	kvm_get_kvm(kvm);
>   	gmem->kvm = kvm;
>   	xa_init(&gmem->bindings);
> @@ -523,6 +577,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>   	if (kvm_arch_supports_gmem_mmap(kvm))
>   		valid_flags |= GUEST_MEMFD_FLAG_MMAP;
>   
> +	if (kvm_arch_gmem_supports_no_direct_map())
> +		valid_flags |= GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +
>   	if (flags & ~valid_flags)
>   		return -EINVAL;
>   
> @@ -687,6 +744,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	if (!is_prepared)
>   		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>   
> +	kvm_gmem_folio_zap_direct_map(folio);
> +
>   	folio_unlock(folio);
>   
>   	if (!r)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 18f29ef93543..b5e702d95230 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -65,6 +65,7 @@
>   #include <trace/events/kvm.h>
>   
>   #include <linux/kvm_dirty_ring.h>
> +#include <linux/set_memory.h>

Likely not required here.

-- 
Cheers

David / dhildenb


