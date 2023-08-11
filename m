Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1A7785BE
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjHKDEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjHKDEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:04:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ECC2D65
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691723039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DMrZ/cVVx9oJnb2z2JJ4WKVaGEEQv2IXABVTFJ5wRQ=;
        b=eViK7cmuXm7qapoTxs6HXXdJUQhVUf3IG+2xlSwJoNIYd1q9QtxUE8VjCkxlsVaWY5w+Z4
        nwgEE4MIyp4EVuwoUI+LiXKj7A03U3Eo5AhQXPIdK7En3GUGRUEx7AJl/v9w6N8vsFs3Bm
        G9OiwS79Kov8mJFII5i6icfZn10Ni2Y=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-AaT3VYr_NKSpQq_SWQxXtA-1; Thu, 10 Aug 2023 23:03:58 -0400
X-MC-Unique: AaT3VYr_NKSpQq_SWQxXtA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-56561aaaeeeso234322a12.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723037; x=1692327837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DMrZ/cVVx9oJnb2z2JJ4WKVaGEEQv2IXABVTFJ5wRQ=;
        b=N0qp+scS+jNeI/Tf6L+SmtN7CT0fkX1/D6yjfJ8fwCZSdpfCgbqHkVUhVLCPT8aHsi
         6RHpeIixsNVRXBs2I0L2+yCtq/BXxvDtVx5/q41bJqx6ebMWHLp4mBXorhZsxeJmKknb
         WLAxnLq6nWmem6K4l5PZfNRWcdASZZhXhyGEugNmzI0lKU/I5YXcwNzoyZAAHwNWoFEA
         qf7cgqB+aL2No72JJ3KwZQX4Ri/Faumi+5hHndIeFuSfoMU5FU9Oe/ZIoYRpurOz9i6m
         T+19BRHcbZK3nUVqBNoARJo+i+tfMnMXI60j26J5Iy1teLMkmOjDyG7tIBEI8E6f8Gn+
         fTUQ==
X-Gm-Message-State: AOJu0YzjDleq+bx2sHhzUKGXbO6SNXfNPaZbIs7HoOEK+rYCde+O1ygw
        5CsR5aguGte7jtcDf/hYOD6c+VwwSLaHOrhnT9lbBBtF34UI7U9FkukPrWDmUZSkmFHC6Smt97n
        aM47aLT1WDpbt
X-Received: by 2002:a05:6a21:6d88:b0:13a:3649:dc1a with SMTP id wl8-20020a056a216d8800b0013a3649dc1amr1316468pzb.0.1691723036991;
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENpkl1RL6Mkjeuk83qmopiO791ccRF4dSFjJzHpK+/MQLjdG2TJSO7XFsP6XAreIKgXCzHJg==
X-Received: by 2002:a05:6a21:6d88:b0:13a:3649:dc1a with SMTP id wl8-20020a056a216d8800b0013a3649dc1amr1316435pzb.0.1691723036603;
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y15-20020a637d0f000000b00553d42a7cb5sm2239376pgc.68.2023.08.10.20.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
Message-ID: <d03b0f1f-2bd6-fc23-2d7a-ddb36eba93cf@redhat.com>
Date:   Fri, 11 Aug 2023 11:03:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 11/14] KVM: arm64: Implement
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
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-12-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-12-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   arch/arm64/kvm/mmu.c              | 8 ++++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 20f2ba149c70c..8f2d99eaab036 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1113,6 +1113,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0ac721fa27f18..294078ce16349 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -172,6 +172,14 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +				      gfn_t gfn, u64 nr_pages)
Hi Raghavendra,

As the kernel test robot points out, the parameter `gfn` should change 
to `start_gfn`.

Thanks,
Shaoqin
> +{
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> +				start_gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
> +	return 0;
> +}
> +
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_is_map_memory(pfn);

-- 
Shaoqin

