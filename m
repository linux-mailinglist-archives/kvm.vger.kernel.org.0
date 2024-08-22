Return-Path: <kvm+bounces-24812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9D495AF4E
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 09:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B886B265BA
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 07:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C72315443B;
	Thu, 22 Aug 2024 07:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QC37+d/B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCD81531D2
	for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 07:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724311843; cv=none; b=LLQpoyfd4+T1iSCOHIBpmfY3wtiomMsjn16DHmI+mm1oUSn3lGwbMs8/ec2c7p+fICxHelX2pV9oC3WbUTlqxwDuQnA+Ya3znlIOEqvpSbsxqjDL0mnWSuX/238KmcnPz1GFqtPNLZAXUKc+L7Ki32kM3+D86nHnOYoNzZClivQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724311843; c=relaxed/simple;
	bh=wflbkegX9lhN90I9cT/Wox0CZ4nBgijX/nV4JrgzedA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sd8Iu6/lcYEVWZcMvA0cgWDNOXrMAjbAyIWHxFpOeFdfYOKZ4gBu2hhyNzzTLA1hBrnrMAr8qLF2wSzvw0ZY07h8otzPyE4GgBbNwdW4tx9wy/VkNzFo69pESizdsH15QasbXgjyUi2Dy6QGTTCGjRHu0JMrJi852HHUTQrsmVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QC37+d/B; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7cd9d408040so209793a12.0
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2024 00:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1724311840; x=1724916640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yu45mhS9M6cpsqi0d7w1McuChLfYTo8/F70JoVl9/2g=;
        b=QC37+d/B+57+F01X6vXCpNCTf44sR7dKnHvboFFJ7oSASOuxr3ejmXzrNiIoyENQlU
         XIXQSmvV6f8eSrt1hX9+L5TdGo08B96fZ4+vqANhsyf4udzCq6dDvQ1qkPeL/ZE+jvpp
         O36sgFx++v4vn5CiQRTbWLWSQMl22zO0a00MXN9te8rxjuACAf+juuPCdOBxFH9xbShH
         aykmUQwp8BBj4701SEqpiXYcBDu+Wll7u1ceAyNAYm5hR2pNr53OqRcQYQV2XE9bOvwA
         CVWPe/kkfm7yfZmWuAeGuqP7E2MikW2eUQbt8xl0P2abN2K+oAnO5E5ytII42VeVN7iO
         vPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724311840; x=1724916640;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yu45mhS9M6cpsqi0d7w1McuChLfYTo8/F70JoVl9/2g=;
        b=NzQY+9pCH0vPXK29obFcYJRI5vcFiyb6yCv+2AYLkd5pZYeswODpu1HfrzhlVb+3UU
         bOXsQYfIm4YOt2ReXFBUBb4zNfBiuhwLnRFp7+vpOE60g/HBeJE/XPqddP/WIvHFRMK4
         T4BGv8IuwbQaMjkzuMsCZbKy+rbYlLcucyY2ScEaVxv6ynlDQaN6wjEomy/549987ULP
         EjfKbbbb3XWRSbnQPIvbX5jpOnsivX3Yd0sLnLrDKclTfGdu/81ggXgsbx1Uatl9KnJY
         39FK5FDKOC2+GdZq9Vt+z1A9V69EJOzAnvrsHbKirc8myc76XcUWaJUgKVA66ia4itKE
         +9Uw==
X-Gm-Message-State: AOJu0YwOAx42LgURsAFCIzjlOoQr0jPObWKRIpt/fMm/dHo4D4k/Vsw0
	i8I/6gExrf42+Qt8OHHob1/dyxaVGc01bFR+vTWIVjzCO6G9yPaetUuBHk/o/M0=
X-Google-Smtp-Source: AGHT+IF4a6zyRiNkijHgJJHeF1HEJchxpEjb93jd3pzBPW1XDEeUrjDn0+de0keEB1SW9zZTSKi7TQ==
X-Received: by 2002:a05:6a20:c6ca:b0:1c6:9e5e:2ec4 with SMTP id adf61e73a8af0-1cad8184cdemr6498215637.50.1724311839810;
        Thu, 22 Aug 2024 00:30:39 -0700 (PDT)
Received: from [10.84.154.91] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557e6eesm6709215ad.73.2024.08.22.00.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 00:30:39 -0700 (PDT)
Message-ID: <8eb1b3c4-5797-4497-b80f-3735a6bf1564@bytedance.com>
Date: Thu, 22 Aug 2024 15:30:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
To: pbonzini@redhat.com, chao.p.peng@linux.intel.com, seanjc@google.com,
 Liam.Howlett@oracle.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
From: Peng Zhang <zhangpeng.00@bytedance.com>
In-Reply-To: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2024/8/22 14:55, Peng Zhang 写道:
> Currently, xarray is used to manage memory attributes. The memory
> attributes management here is an interval problem. However, xarray is
> not suitable for handling interval problems. It may cause memory waste
> and is not efficient. Switching it to maple tree is more elegant. Using
> maple tree here has the following three advantages:
> 1. Less memory overhead.
> 2. More efficient interval operations.
> 3. Simpler code.
> 
> This is the first user of the maple tree interface mas_find_range(),
> and it does not have any test cases yet, so its stability is unclear.
> 
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> ---
>   include/linux/kvm_host.h |  5 +++--
>   virt/kvm/kvm_main.c      | 47 ++++++++++++++--------------------------
>   2 files changed, 19 insertions(+), 33 deletions(-)
> 
> I haven't tested this code yet, and I'm not very familiar with kvm, so I'd
> be happy if someone could help test it. This is just an RFC now. Any comments
> are welcome.
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 79a6b1a63027..9b3351d88d64 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -35,6 +35,7 @@
>   #include <linux/interval_tree.h>
>   #include <linux/rbtree.h>
>   #include <linux/xarray.h>
The header file of xarray can be deleted.

> +#include <linux/maple_tree.h>
>   #include <asm/signal.h>
>   
>   #include <linux/kvm.h>
> @@ -839,7 +840,7 @@ struct kvm {
>   #endif
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   	/* Protected by slots_locks (for writes) and RCU (for reads) */
> -	struct xarray mem_attr_array;
> +	struct maple_tree mem_attr_mtree;
>   #endif
>   	char stats_id[KVM_STATS_NAME_SIZE];
>   };
> @@ -2410,7 +2411,7 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>   {
> -	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> +	return xa_to_value(mtree_load(&kvm->mem_attr_mtree, gfn));
>   }
>   
>   bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 92901656a0d4..9a99c334f4af 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -10,6 +10,7 @@
>    *   Yaniv Kamay  <yaniv@qumranet.com>
>    */
>   
> +#include "linux/maple_tree.h"
This line should be deleted.
>   #include <kvm/iodev.h>
>   
>   #include <linux/kvm_host.h>
> @@ -1159,7 +1160,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>   	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>   	xa_init(&kvm->vcpu_array);
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	xa_init(&kvm->mem_attr_array);
> +	mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN);
There is a flag missing here, should be:
mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_RCU);

> +	mt_set_external_lock(&kvm->mem_attr_mtree, &kvm->slots_lock);
>   #endif
>   
>   	INIT_LIST_HEAD(&kvm->gpc_list);
> @@ -1356,7 +1358,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
>   	cleanup_srcu_struct(&kvm->irq_srcu);
>   	cleanup_srcu_struct(&kvm->srcu);
>   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	xa_destroy(&kvm->mem_attr_array);
> +	mutex_lock(&kvm->slots_lock);
> +	__mt_destroy(&kvm->mem_attr_mtree);
> +	mutex_unlock(&kvm->slots_lock);
>   #endif
>   	kvm_arch_free_vm(kvm);
>   	preempt_notifier_dec();
> @@ -2413,30 +2417,20 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>   bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>   				     unsigned long mask, unsigned long attrs)
>   {
> -	XA_STATE(xas, &kvm->mem_attr_array, start);
> -	unsigned long index;
> +	MA_STATE(mas, &kvm->mem_attr_mtree, start, start);
>   	void *entry;
>   
>   	mask &= kvm_supported_mem_attributes(kvm);
>   	if (attrs & ~mask)
>   		return false;
>   
> -	if (end == start + 1)
> -		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
> -
>   	guard(rcu)();
> -	if (!attrs)
> -		return !xas_find(&xas, end - 1);
> -
> -	for (index = start; index < end; index++) {
> -		do {
> -			entry = xas_next(&xas);
> -		} while (xas_retry(&xas, entry));
>   
> -		if (xas.xa_index != index ||
> -		    (xa_to_value(entry) & mask) != attrs)
> +	do {
> +		entry = mas_find_range(&mas, end - 1);
> +		if ((xa_to_value(entry) & mask) != attrs)
>   			return false;
> -	}
> +	} while (mas.last < end - 1);
>   
>   	return true;
>   }
> @@ -2524,9 +2518,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>   		.on_lock = kvm_mmu_invalidate_end,
>   		.may_block = true,
>   	};
> -	unsigned long i;
>   	void *entry;
>   	int r = 0;
> +	MA_STATE(mas, &kvm->mem_attr_mtree, start, end - 1);
>   
>   	entry = attributes ? xa_mk_value(attributes) : NULL;
>   
> @@ -2540,20 +2534,11 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>   	 * Reserve memory ahead of time to avoid having to deal with failures
>   	 * partway through setting the new attributes.
>   	 */
> -	for (i = start; i < end; i++) {
> -		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
> -		if (r)
> -			goto out_unlock;
> -	}
> -
> +	r = mas_preallocate(&mas, entry, GFP_KERNEL_ACCOUNT);
> +	if (r)
> +		goto out_unlock;
>   	kvm_handle_gfn_range(kvm, &pre_set_range);
> -
> -	for (i = start; i < end; i++) {
> -		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> -				    GFP_KERNEL_ACCOUNT));
> -		KVM_BUG_ON(r, kvm);
> -	}
> -
> +	mas_store_prealloc(&mas, entry);
>   	kvm_handle_gfn_range(kvm, &post_set_range);
>   
>   out_unlock:

