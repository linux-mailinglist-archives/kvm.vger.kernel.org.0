Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF8747ABC
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 02:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjGEAeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 20:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGEAeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 20:34:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCCBE70
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 17:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688517205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sznGK6ZukwvfWp0A8i4mc61vcYJsrjsNcN47/Lw0qI8=;
        b=BJ0uL/0owcUv6E9tkDH+HHsUdiGpG2Aku5j2mlaW/gpzf7xuIchnxvzBdu5KClzf6DzM3k
        lsqneWfp4nJ0gE2/IRG8Kuhs6ZwbIL53Nr/+hB40i49BA0IU07BF8S+yhP16AxCZkRUxU2
        HFvg6yg7hISB1Ms9/mRQ+wtYKbLfz6o=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-4jyNNhsPNSSgOGgE6AtK5w-1; Tue, 04 Jul 2023 20:33:23 -0400
X-MC-Unique: 4jyNNhsPNSSgOGgE6AtK5w-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-666ee6aeddbso6125397b3a.3
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 17:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688517202; x=1691109202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sznGK6ZukwvfWp0A8i4mc61vcYJsrjsNcN47/Lw0qI8=;
        b=Te8kB3ICZKUimWoFSACgBTPFwC96GZoh8HjL0Y6W9ZB0cuHJs+0Exut9izLERp3NyF
         dau2/QC7etfp7G6PBqIcPm2QO9BnFjzXJKr+dHDTAKk7x2ahbADGX4Iu+y3xQ1Katg3J
         zF+r3v32mEbU5bSq/GhjtIX1J/QBJxIR8iPjTTtHkGurAWatfHsjldzRrjz93c2Nfxo/
         j5jw6k8N1ywb5l/bvRqjXP09xgYddeE0Dzxz5PUAm3t1+PzoYqQB96x+23BXf5QRW6TN
         KzznGl02NvBc3VkoNxsr4VQDCCB7lmuWZPNeEDr+Em24RyqUsBKTQq2j7OPRYCGjKqbx
         pONQ==
X-Gm-Message-State: ABy/qLaTFy7OMRLgP0un6odtt73Es0MNQS4kqKjcFO5dDHs1w+spF8YK
        CJoYSWjg9AtduVtV280vWQYeGXxC2e+/ONqbBr1T3hxDNRg4ZDZedu527WKaR/136yzH/xzAMOP
        1Ou005efzZfNA
X-Received: by 2002:a05:6a20:1601:b0:12f:4d11:5f74 with SMTP id l1-20020a056a20160100b0012f4d115f74mr2599847pzj.58.1688517202486;
        Tue, 04 Jul 2023 17:33:22 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFvypcLwb/KPkwH9ar4hG3nsZmNacj2rbML5ruL00tj8y35B6pCwD/DI8RaK0glisLwI/suTQ==
X-Received: by 2002:a05:6a20:1601:b0:12f:4d11:5f74 with SMTP id l1-20020a056a20160100b0012f4d115f74mr2599827pzj.58.1688517202196;
        Tue, 04 Jul 2023 17:33:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b001ac897026cesm17766726plh.102.2023.07.04.17.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:33:21 -0700 (PDT)
Message-ID: <6b8dd9cd-784c-b9e1-73de-6c84deba9426@redhat.com>
Date:   Wed, 5 Jul 2023 10:33:12 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 08/11] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-9-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-9-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   2 files changed, 10 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 81ab41b84f436..343fb530eea9c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d0a0d3dca9316..c3ec2141c3284 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -92,6 +92,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> +{
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> +				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
> +	return 0;
> +}
> +
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_is_map_memory(pfn);

