Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47A44C592
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 18:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhKJRDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 12:03:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232305AbhKJRDG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 12:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636563618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4pYydCf5K8wTsOHmFWFndJrj56wgud3cb8m0v50g38=;
        b=QlVnH9qKr6X6CUb0bgjBq89OP1IrFXG7JVEIgdX38bQjzofd7PIJNgGRy7dPh5NInhUSXb
        m5Ko1M6a/ePcXFxjKId9oKfWHv8ba+zCxT5cJN9t9vhd5KK0G1UGiCxIPcVf4MenVhLJZQ
        9wBdslq+G2UjWq0KAFm+AngeTbn09g0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-zHAPwx8KMLmp7S3c_zbdjQ-1; Wed, 10 Nov 2021 12:00:17 -0500
X-MC-Unique: zHAPwx8KMLmp7S3c_zbdjQ-1
Received: by mail-wr1-f70.google.com with SMTP id a2-20020a5d4d42000000b0017b3bcf41b9so551871wru.23
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 09:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4pYydCf5K8wTsOHmFWFndJrj56wgud3cb8m0v50g38=;
        b=a0UYbR9UvVikgZkj/g8RvKe1rYiJ74AxZMj8+WyijDkSoRCZBkDFEcMPcikoFg+oyR
         /YoxyRYY1mC1kl4TRgskiH1fPKGwHloCKo1dTiXQbBRim3KGLyK6qxyG9/n0ouw/kjvO
         x/tHfCGOIMGnREZatZH0Huubbtf84I1qhePK2b5HGfLejvOQEynwzUc4i9pZ0ABBXtXj
         jVyczsjYrqNxHY7vzJeJ0xKhU/AvlxkZY8gwmFRCfr15y/szGwBcSva84+DCaUlzhEBJ
         GrRDkTaO/NXiIRxMaWUqaV+jldfV/lsHxIdhf3gCB1FUlFizUIzelDUuz5c7w+1lXgIU
         2ElA==
X-Gm-Message-State: AOAM531pVfSD1ylAP9r3uB37IjXui33rHbScl4keDvme0EA9ut32oZ+7
        DQQ0BatNLQnJWE3krYfsYZjJsA9KPWTpd3JOawu87r6pquybbnVE8Pbll3LPRt0JcJ5523GSHg/
        S2d/c0JRIrRbz
X-Received: by 2002:a1c:43c1:: with SMTP id q184mr18128560wma.153.1636563615739;
        Wed, 10 Nov 2021 09:00:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzI55jyDNoSB30zudIHtQh+iKpj0BpgPN8b1JOQeacltE6fInNdbDMoAUO3wu73arG51UEabg==
X-Received: by 2002:a1c:43c1:: with SMTP id q184mr18128529wma.153.1636563615493;
        Wed, 10 Nov 2021 09:00:15 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id z6sm434734wmp.1.2021.11.10.09.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:00:14 -0800 (PST)
Subject: Re: [PATCH v4 03/15] KVM: async_pf: Make GFN slot management generic
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-4-gshan@redhat.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <06cb06c0-13e7-906b-9b88-543a58bb5590@redhat.com>
Date:   Wed, 10 Nov 2021 18:00:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-4-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> It's not allowed to fire duplicate notification for same GFN on
> x86 platform, with help of a hash table. This mechanism is going
s/, with help of a hash table/this is achieved through a hash table
> to be used by arm64 and this makes the code generic and shareable
s/and this makes/.\n Turn the code generic
> by multiple platforms.
> 
>    * As this mechanism isn't needed by all platforms, a new kernel
>      config option (CONFIG_ASYNC_PF_SLOT) is introduced so that it
>      can be disabled at compiling time.
compile time
> 
>    * The code is basically copied from x86 platform and the functions
>      are renamed to reflect the fact: (a) the input parameters are
>      vCPU and GFN. 
not for reset
(b) The operations are resetting, searching, adding
>      and removing.
find, add, remove ops are renamed with _slot suffix
> 
>    * Helper stub is also added on !CONFIG_KVM_ASYNC_PF because we're
>      going to use IS_ENABLED() instead of #ifdef on arm64 when the
>      asynchronous page fault is supported.
> 
> This is preparatory work to use the newly introduced functions on x86
> platform and arm64 in subsequent patches.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  include/linux/kvm_host.h | 18 +++++++++
>  virt/kvm/Kconfig         |  3 ++
>  virt/kvm/async_pf.c      | 85 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 106 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a5f990f6dc35..a9685c2b2250 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -298,6 +298,9 @@ struct kvm_vcpu {
>  
>  #ifdef CONFIG_KVM_ASYNC_PF
>  	struct {
> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
> +		gfn_t gfns[ASYNC_PF_PER_VCPU];
> +#endif
>  		u32 queued;
>  		struct list_head queue;
>  		struct list_head done;
> @@ -339,6 +342,13 @@ struct kvm_async_pf {
>  	bool				notpresent_injected;
>  };
>  
> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
> +void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu);
this does not reset a "slot" but the whole hash table. So to me this
shouldn't be renamed with _slot suffix. reset_hash or reset_all_slots?
> +void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
> +void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
> +bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn);
> +#endif
> +
>  static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  {
>  	return !list_empty_careful(&vcpu->async_pf.done);
> @@ -350,6 +360,14 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			unsigned long hva, struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #else
> +static inline void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu) { }
> +static inline void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
> +static inline void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn) { }
> +static inline bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	return false;
> +}
> +
>  static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  {
>  	return false;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 62b39149b8c8..59b518c8c205 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -23,6 +23,9 @@ config KVM_MMIO
>  config KVM_ASYNC_PF
>         bool
>  
> +config KVM_ASYNC_PF_SLOT
> +	bool
> +
>  # Toggle to switch between direct notification and batch job
>  config KVM_ASYNC_PF_SYNC
>         bool
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index d145a61a046a..0d1fdb2932af 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -13,12 +13,97 @@
>  #include <linux/module.h>
>  #include <linux/mmu_context.h>
>  #include <linux/sched/mm.h>
> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
> +#include <linux/hash.h>
> +#endif
>  
>  #include "async_pf.h"
>  #include <trace/events/kvm.h>
>  
>  static struct kmem_cache *async_pf_cache;
>  
> +#ifdef CONFIG_KVM_ASYNC_PF_SLOT
> +static inline u32 kvm_async_pf_hash(gfn_t gfn)
> +{
> +	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
> +
> +	return hash_32(gfn & 0xffffffff, order_base_2(ASYNC_PF_PER_VCPU));
> +}
> +
> +static inline u32 kvm_async_pf_next_slot(u32 key)
> +{
> +	return (key + 1) & (ASYNC_PF_PER_VCPU - 1);
> +}
> +
> +static u32 kvm_async_pf_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_hash(gfn);
> +	int i;
> +
> +	for (i = 0; i < ASYNC_PF_PER_VCPU &&
> +		(vcpu->async_pf.gfns[key] != gfn &&
> +		vcpu->async_pf.gfns[key] != ~0); i++)
> +		key = kvm_async_pf_next_slot(key);
> +
> +	return key;
> +}
> +
> +void kvm_async_pf_reset_slot(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	for (i = 0; i < ASYNC_PF_PER_VCPU; i++)
> +		vcpu->async_pf.gfns[i] = ~0;
> +}
> +
> +void kvm_async_pf_add_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_hash(gfn);
> +
> +	while (vcpu->async_pf.gfns[key] != ~0)
> +		key = kvm_async_pf_next_slot(key);
> +
> +	vcpu->async_pf.gfns[key] = gfn;
> +}
> +
> +void kvm_async_pf_remove_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 i, j, k;
> +
> +	i = j = kvm_async_pf_slot(vcpu, gfn);
> +
> +	if (WARN_ON_ONCE(vcpu->async_pf.gfns[i] != gfn))
> +		return;
> +
> +	while (true) {
> +		vcpu->async_pf.gfns[i] = ~0;
> +
> +		do {
> +			j = kvm_async_pf_next_slot(j);
> +			if (vcpu->async_pf.gfns[j] == ~0)
> +				return;
> +
> +			k = kvm_async_pf_hash(vcpu->async_pf.gfns[j]);
> +			/*
> +			 * k lies cyclically in ]i,j]
> +			 * |    i.k.j |
> +			 * |....j i.k.| or  |.k..j i...|
> +			 */
> +		} while ((i <= j) ? (i < k && k <= j) : (i < k || k <= j));
> +
> +		vcpu->async_pf.gfns[i] = vcpu->async_pf.gfns[j];
> +		i = j;
> +	}
> +}
> +
> +bool kvm_async_pf_find_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_async_pf_slot(vcpu, gfn);
> +
> +	return vcpu->async_pf.gfns[key] == gfn;
> +}
> +#endif /* CONFIG_KVM_ASYNC_PF_SLOT */
> +
>  int kvm_async_pf_init(void)
>  {
>  	async_pf_cache = KMEM_CACHE(kvm_async_pf, 0);
> 
Thanks

Eric

