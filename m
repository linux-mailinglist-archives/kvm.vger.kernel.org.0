Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37717751C0
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 06:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjHIEBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 00:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHIEBQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 00:01:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799261981
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 21:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691553629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQlmNO2lLhBYx7/A3bGLPPLUydSYqDE41nBYvmLEPYg=;
        b=AZrVYGWbpzJHeesymMhb/1IHNT5C5nc88LyrpsIJ+xZ9VSJLJI27+SYPgggNArdww6wYQf
        e5LdQYXeWkeOnaOEzLaq8DMds1k4mDwC2N1odSVOz2A5K0rDllfUXP872yN59uUza8wPZj
        fIQFQyqiPCPCGDRobydf43THcdxseI4=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-u-x2Ir27Mbu1B-Ll0fCAAA-1; Wed, 09 Aug 2023 00:00:28 -0400
X-MC-Unique: u-x2Ir27Mbu1B-Ll0fCAAA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-686d924d215so5112722b3a.2
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 21:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691553627; x=1692158427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQlmNO2lLhBYx7/A3bGLPPLUydSYqDE41nBYvmLEPYg=;
        b=GKZDJSGmnOxOubKbTSccRxvt4SbVg7gJslB9+wSH+R5N6UYKOLVrfhDwMkKbpT8QU9
         XFun2qssz2eM92+tLK1snRsD7Ljp2Hzs+z4ixZh+L5DYuGSA7yZTtkZ4xc+OwBFOjPIl
         dyWUsZYDpiMZ4fJ3ndY7p+X6sv24sYsRUcjdgSferdNgJx5u51RUktKLcSeolOFdXUgf
         OjxKN+H7YdeaF6TYIUrV4jSQ28l6URqjWYofXo6HbqsFzAZ74hND3uzxZQzyF2ToZcGx
         cJieXxuZpNMFDRlwHmeHRe/p8oUCWdo9UnlHafdY6BsAQBL5pBjjIA6QwUyVosI5vWcq
         x8Sw==
X-Gm-Message-State: AOJu0Ywq4vA7Br+bNbVvgSNIuFe32XS94AXvCeY3/PH/arqXPOtcmR14
        BpKXG8zvIJdVwFdPXvY8atTzg5zdN0SV1SHdSZLebWmpCze2X9PyluBiLLdbpJ6sH1n0LWGuJVE
        PVafcMTwOxgAm
X-Received: by 2002:a05:6a20:2c98:b0:141:d54e:a907 with SMTP id g24-20020a056a202c9800b00141d54ea907mr938670pzj.19.1691553627005;
        Tue, 08 Aug 2023 21:00:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOvufvyUoufFYXdfEuvYMIQHRTZK4zZPGr4dTmruEN2n1tJuTAm2AE/WhYVDypt5ObnuK/mg==
X-Received: by 2002:a05:6a20:2c98:b0:141:d54e:a907 with SMTP id g24-20020a056a202c9800b00141d54ea907mr938627pzj.19.1691553625804;
        Tue, 08 Aug 2023 21:00:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902c3c600b001bc930d4517sm470398plj.42.2023.08.08.21.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:00:25 -0700 (PDT)
Message-ID: <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
Date:   Wed, 9 Aug 2023 14:00:15 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
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
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-3-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> There's no reason for the architectures to declare
> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
> avoid this duplication, make the declaration global, leaving
> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> as needed.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
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

Is the declaration inconsistent to that in arch/x86/include/asm/kvm_host.h?
In order to keep them consistent, I guess we need move kvm_arch_flush_remote_tlbs()
from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to be dropped.

Thanks,
Gavin

