Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF921AAD7F
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415387AbgDOQOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:14:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1415382AbgDOQOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 12:14:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586967241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJeTo/zRnrqHhvOgPTgaHSH4vrzTtRuXcGPzKEfUHnY=;
        b=IrQXpc172A/c9nxpXNbRKtBrk+hkcC8cFUwgnwZ34ymZhfUa9PDCBush1BA/fEZ9lg9yRt
        7sXjZBhgpdSj/0zkzIiEhVCwrVsTKSTAcgV0r2xX6QGzqEsRaOwzhpz9Js76Jj0LEq8sN+
        /u55g3Req4bhCfTo59X82c8OiMKL714=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-3NwBz7QSOWCiwF86G-MtlA-1; Wed, 15 Apr 2020 12:13:59 -0400
X-MC-Unique: 3NwBz7QSOWCiwF86G-MtlA-1
Received: by mail-wm1-f71.google.com with SMTP id o26so62698wmh.1
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 09:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RJeTo/zRnrqHhvOgPTgaHSH4vrzTtRuXcGPzKEfUHnY=;
        b=IvGkjrlnM0EGQsr0CUIDmDJ6Yt8ri4IU0gHqRdGsKOr77SQ0d6SBaKDQTWEQnI18LC
         wXqS/wb6uWMnj4QKBjU7wqev8C3jBb2JnExJU9wnMfP7LxbkPBQUu9Onfq1u8ovSLmPE
         zR2eREXBfoWLAzLM5lSptRw6sPWOxzG3hf5vxAr8f8Ri7SP8zwtcXhzp4jlSpvs0Uzmj
         rSz3eSjjFmfO2glPpQ/xVFxQvy297TysweZA/XuJPIi746DWmILM5gIYdtRq/5CkotS6
         xyw7T/C/1InDZrMNRhVNMU+XQ36BdtbB4l7F9dYFS9EYBz042c8fg2allfgKrjprR9of
         Dgiw==
X-Gm-Message-State: AGi0PuZuT7tfbPfLF30abMOGovZRADIFl0pcRo0RxRY+uIJ2hb+RLfJW
        h8DEnGmkyYd5olSnB6Vcv00ZCnBVwn6SUgBFLWnL8hWRztT4CJM1c6PmJwyyLHEbt676aZiOTCJ
        W5F8lNhAg/GHb
X-Received: by 2002:adf:ff82:: with SMTP id j2mr18428718wrr.96.1586967238410;
        Wed, 15 Apr 2020 09:13:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypIDz/OV9eeQuwJYvgc7hCdaj4l2fEwtDfmedhtg4jVMeo+Svh1HHKzk8lWg60lun+SjucTPTg==
X-Received: by 2002:adf:ff82:: with SMTP id j2mr18428685wrr.96.1586967238108;
        Wed, 15 Apr 2020 09:13:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id p7sm24315229wrf.31.2020.04.15.09.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 09:13:57 -0700 (PDT)
Subject: Re: [PATCH v2] KVM/arm64: Support enabling dirty log gradually in
 small chunks
To:     Keqian Zhu <zhukeqian1@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Will Deacon <will@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jay Zhou <jianjay.zhou@huawei.com>, wanghaibin.wang@huawei.com
References: <20200413122023.52583-1-zhukeqian1@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be45ec89-2bdb-454b-d20a-c08898e26024@redhat.com>
Date:   Wed, 15 Apr 2020 18:13:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200413122023.52583-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/04/20 14:20, Keqian Zhu wrote:
> There is already support of enabling dirty log graually in small chunks
> for x86 in commit 3c9bd4006bfc ("KVM: x86: enable dirty log gradually in
> small chunks"). This adds support for arm64.
> 
> x86 still writes protect all huge pages when DIRTY_LOG_INITIALLY_ALL_SET
> is eanbled. However, for arm64, both huge pages and normal pages can be
> write protected gradually by userspace.
> 
> Under the Huawei Kunpeng 920 2.6GHz platform, I did some tests on 128G
> Linux VMs with different page size. The memory pressure is 127G in each
> case. The time taken of memory_global_dirty_log_start in QEMU is listed
> below:
> 
> Page Size      Before    After Optimization
>   4K            650ms         1.8ms
>   2M             4ms          1.8ms
>   1G             2ms          1.8ms
> 
> Besides the time reduction, the biggest income is that we will minimize
> the performance side effect (because of dissloving huge pages and marking
> memslots dirty) on guest after enabling dirty log.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>  Documentation/virt/kvm/api.rst    |  2 +-
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  virt/kvm/arm/mmu.c                | 12 ++++++++++--
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index efbbe570aa9b..0017f63fa44f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5777,7 +5777,7 @@ will be initialized to 1 when created.  This also improves performance because
>  dirty logging can be enabled gradually in small chunks on the first call
>  to KVM_CLEAR_DIRTY_LOG.  KVM_DIRTY_LOG_INITIALLY_SET depends on
>  KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE (it is also only available on
> -x86 for now).
> +x86 and arm64 for now).
>  
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 was previously available under the name
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT, but the implementation had bugs that make
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 32c8a675e5a4..a723f84fab83 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,6 +46,9 @@
>  #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>  
> +#define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> +				     KVM_DIRTY_LOG_INITIALLY_SET)
> +
>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  
>  extern unsigned int kvm_sve_max_vl;
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e3b9ee268823..1077f653a611 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -2265,8 +2265,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	 * allocated dirty_bitmap[], dirty pages will be be tracked while the
>  	 * memory slot is write protected.
>  	 */
> -	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
> -		kvm_mmu_wp_memory_region(kvm, mem->slot);
> +	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +		/*
> +		 * If we're with initial-all-set, we don't need to write
> +		 * protect any pages because they're all reported as dirty.
> +		 * Huge pages and normal pages will be write protect gradually.
> +		 */
> +		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> +			kvm_mmu_wp_memory_region(kvm, mem->slot);
> +		}
> +	}
>  }
>  
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
> 

Marc, what is the status of this patch?

Paolo

