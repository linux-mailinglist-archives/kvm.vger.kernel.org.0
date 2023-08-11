Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF607785F3
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 05:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbjHKDTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 23:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjHKDTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 23:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005692D68
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691723913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PiI+QsxMTBs9vA9vlC+ZyswANJfDDGFtsPp4BYCBVbg=;
        b=StEEFzzG3862GLAF7SiQthLuoO7p7Aio1jiXwNF1oFey2icr81eEA4461RMWpaLYR2sFRY
        tByJwjf7OxT1nzkSe4gdQ24NL4U3mOPHV6vu7uHPhVogz94p99jPp1sqmE/OHLX0B+zcfu
        RHVa9uWgE3J63dhpcEQE8jeFwVSTEhI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-fNakT43DO_CqBgwzU8Ql9Q-1; Thu, 10 Aug 2023 23:18:31 -0400
X-MC-Unique: fNakT43DO_CqBgwzU8Ql9Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-26953535169so409682a91.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 20:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723910; x=1692328710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PiI+QsxMTBs9vA9vlC+ZyswANJfDDGFtsPp4BYCBVbg=;
        b=JtI0D4fr47g0tuDahLAVYhtxMGsG9+bzJw7uOipRDbkB8GT8QWG3PZLpN24j5BqHYE
         LcDK0sFd91OEptxNpln8BcXKKVHt+R/eCHU2RCRHiHvmkrIpoGqWyeQkUMxUxz6rEx80
         xhIz0Jo2x/d6Ts+rlkgdwcA7zWOtyq/SZBKBgvcIO8wvpWmWA7yGXDo1RbYW12ELn+nA
         06imvMPsFXpQeM4GJ7TboFK25WO5QGKS3r4mxvl4js9bOz2MNzMDyctDIm9NRGBvgkfj
         xQ6J1doTf6mrDF0L/A6JZX9XTL0lJm1oYu32y3vsQJY/CoqSuzGpRtzUWqzRWPzo2zIn
         i/Lw==
X-Gm-Message-State: AOJu0YxX6o+pzmf9jypXNLyaV9/726g3eWZOlrEzLU3j5xpUmWcIOREO
        7WWKQsy+AwouLxAHWv8Fv5/b8r/uV2X6p1SrpHiRntJonAYOjh3SjEGFAnkHY9PTHuijEhcyJJj
        0WqmmQasFKGd4
X-Received: by 2002:a17:903:11c8:b0:1b8:17e8:547e with SMTP id q8-20020a17090311c800b001b817e8547emr828117plh.1.1691723910725;
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHID5R08qiLj5A7MSG7B2ILJx/BX/BiDQni1fswd5I7LC3NtLSpgFqmDqjcNklr7RUUka6Afw==
X-Received: by 2002:a17:903:11c8:b0:1b8:17e8:547e with SMTP id q8-20020a17090311c800b001b817e8547emr828095plh.1.1691723910468;
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q22-20020a170902b11600b001bb24cb9a40sm2547142plr.39.2023.08.10.20.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:18:30 -0700 (PDT)
Message-ID: <60d1a498-2815-2465-ccc9-e4464791a3fb@redhat.com>
Date:   Fri, 11 Aug 2023 11:18:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs()
 globally
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
        kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-3-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> There's no reason for the architectures to declare
> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> avoid this duplication, make the declaration global, leaving
> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> as needed.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/mips/include/asm/kvm_host.h | 1 -
>   include/linux/kvm_host.h         | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 9b0ad8f3bf327..54a85f1d4f2c8 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
>   #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e3f968b38ae97..ade5d4500c2ce 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	return -ENOTSUPP;
>   }
> +#else
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   #endif
>   
>   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA

-- 
Shaoqin

