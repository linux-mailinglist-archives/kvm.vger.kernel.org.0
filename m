Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F708747AC2
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 02:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjGEAg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 20:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjGEAg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 20:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E645EE72
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 17:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688517340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kggeUHVn+fybi/vP4cTbHO7AeLXxPNqVprkHx0Chh4=;
        b=O81tKq8fRI8p+KUS98bkZeL+2EcMSYw834SFyQqs681DLC7biTgM/aKdv09zVSncHYPypj
        0d05YEp+krPQE7WX3RCmlVn60sUrwF2IZ+dJLfDiC5WWgRRcqhySV09PK7AfLdmyj9QVK1
        4ODMTLBTUEgVU5UnGTvcrnzRi1HozLU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-_WaHHjZjMeOOef8BAmocTg-1; Tue, 04 Jul 2023 20:35:38 -0400
X-MC-Unique: _WaHHjZjMeOOef8BAmocTg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1b895fa8929so26975375ad.0
        for <kvm@vger.kernel.org>; Tue, 04 Jul 2023 17:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688517338; x=1691109338;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kggeUHVn+fybi/vP4cTbHO7AeLXxPNqVprkHx0Chh4=;
        b=Ui0CIffcN7ulsy9/ZZ8IyXt4jrnEfkVlRPvlRVeoplFEQWb/C+uK/ADjb9oo6dvkEY
         214Gwl0B1lf8lN7hLN9xeY3xPSH2Ai+rcakQ2tq3THFhvI8Nxf0VSChdhsh06lUYbjIn
         rFXNlTEWCm6B88G86t9Eqi+M8MmC7vYGPlrd60isDIbSCR6Wau3h0QtxPYCsM/mYT3z8
         i8W1Kk8qf1pV1TerZJedgejJGFCqEzC/7Qb4qEPqsyIc5v0yewHJVYu4KOQS75XFvx5H
         I+4gxy4Cq7Yd/TL7r4C5ECYiYYBtQSjQfGCGtZeiom32IsBhppXn27rbUAAjfYwAT2FU
         x7/Q==
X-Gm-Message-State: ABy/qLb4dDnhC7HQnJBAIGf8+TRqQJyOOpFWAc5e7oPnSu/3+5I71NRM
        JF0HKdWcx+gNEL56h6A/yIaLx7K+wHwSGLJciz7XOkwsMJ/1m1Pzn0uoSV0Y3KPMdP+eBtoCW1H
        JDBI63ZLapv/H
X-Received: by 2002:a17:902:dac4:b0:1b8:9195:1dd8 with SMTP id q4-20020a170902dac400b001b891951dd8mr5383571plx.51.1688517337915;
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG1dv3HBeoyb27A4Q9lu9hw82Tk11vqBX4veNPK7IWmCWzA4mOu6o5korMa8AFQToKad6zjdQ==
X-Received: by 2002:a17:902:dac4:b0:1b8:9195:1dd8 with SMTP id q4-20020a170902dac400b001b891951dd8mr5383559plx.51.1688517337630;
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id ix6-20020a170902f80600b001b87f957ba5sm6601048plb.12.2023.07.04.17.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:35:37 -0700 (PDT)
Message-ID: <73a4655a-2c63-3209-1153-2fc816e8990e@redhat.com>
Date:   Wed, 5 Jul 2023 10:35:28 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 09/11] KVM: arm64: Flush only the memslot after
 write-protect
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
 <20230621175002.2832640-10-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-10-rananta@google.com>
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

On 6/22/23 03:50, Raghavendra Rao Ananta wrote:
> After write-protecting the region, currently KVM invalidates
> the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
> scope the invalidation only to the targeted memslot. If
> supported, the architecture would use the range-based TLBI
> instructions to flush the memslot or else fallback to flushing
> all of the TLBs.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c3ec2141c3284..94f10e670c100 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -992,7 +992,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	write_lock(&kvm->mmu_lock);
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   	write_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   /**

