Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6CB44C599
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 18:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhKJRDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 12:03:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54360 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232433AbhKJRDP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 12:03:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636563626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j4pYydCf5K8wTsOHmFWFndJrj56wgud3cb8m0v50g38=;
        b=ftOM4lK6xZadlBk2+t/0aWDNK88iw3PaTrlLGEcKRfrfEvYMdEiQgFebWBp/FiOh7Emruf
        9TjrTooJuKvgMmt0Bf9XXbmKRBT/og8QUd7aawzug3uaKQIZuK0Jc6NdGQ/DdNednxh3E2
        KrQAkNvyQ8KaK8fAMTXxq7I9wPIYRS4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-iRHjN8s6N-azU698OtfJ-A-1; Wed, 10 Nov 2021 12:00:25 -0500
X-MC-Unique: iRHjN8s6N-azU698OtfJ-A-1
Received: by mail-wm1-f69.google.com with SMTP id m18-20020a05600c3b1200b0033283ea5facso1254176wms.1
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 09:00:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j4pYydCf5K8wTsOHmFWFndJrj56wgud3cb8m0v50g38=;
        b=D3nN8DJwr3faNAa8TVYjwe4OMgKonQkqi3awGZ10ciORCYkDFCUuevRa8ha/VeaAVh
         p0uWkDn7yNjmY/7x6dXXanraSP47d8muJ2+Nc0VlvEQQ+tTtXGfQf9TU2b6oWGFnbf1I
         Bc/iuCKAwV8KNhvfpKwJQTw9ufHcDE7GzwBBl40yJrq5+Io8pF1Egp3ISUCRhNSWrp+4
         o3lUerd+BvobcnVWyy5k4eNbAhCNsfUanYxGhSP+/0T4tMXZeApHGjJ+DcLy3siSPPdn
         JzjEymd/dmCNNag8qq1s36Yvr/b5QgeorlEJgXQCmJiJ90XC1ifpAyCPmOcRGeRjKwr5
         JM6g==
X-Gm-Message-State: AOAM531Z7VSPEQJWoS3YG0QmgzgR0c6hC6aRjrzhFKuxVfNdf34aW+UL
        wVdjXcM8jrZbKPdPoQa/g1g9yC0s6EHuSeY//Xk/Xf3Zgj/Ay2Dt8RXdvoGYV53HlzNuX9fE0r3
        tBfPqXwVdh4Hi
X-Received: by 2002:a5d:630b:: with SMTP id i11mr590599wru.316.1636563624498;
        Wed, 10 Nov 2021 09:00:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4FSv8uhNCOetBqLnjn97Pn3geEIeaFMrtzY8km47wF1WfYkY4s3Qxyf5Otm3ueRK9bYv2vw==
X-Received: by 2002:a5d:630b:: with SMTP id i11mr590539wru.316.1636563624164;
        Wed, 10 Nov 2021 09:00:24 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v191sm271021wme.36.2021.11.10.09.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:00:23 -0800 (PST)
Subject: Re: [PATCH v4 03/15] KVM: async_pf: Make GFN slot management generic
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-4-gshan@redhat.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <3e36bb05-90ce-9448-14c8-172313b986b7@redhat.com>
Date:   Wed, 10 Nov 2021 18:00:22 +0100
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

