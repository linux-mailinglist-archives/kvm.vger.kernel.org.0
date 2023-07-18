Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F66757A48
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjGRLSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjGRLSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 07:18:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7271704
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689679033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FMvWdQ8jDtgrg4TmzvreNToMG0I25+6piVG21WnWmLI=;
        b=g3T1jU00h51yKRzlHF+nfa4bKMUt8c9XS/Z2umtjf+4ia/S7yR1nQUti9Zm3022UDEG4V5
        m4dI9/+Rya/PzODfY4mSlexlRFvALFIG5wgLUAAY69BQZVzcn6RcrmvsGfRVUTIQOh6KNt
        ULik3G+J45Zm0j/yTa+P1hsx2jSkZPc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-KVQgnLZdPbCMbruHS3ByBg-1; Tue, 18 Jul 2023 07:17:11 -0400
X-MC-Unique: KVQgnLZdPbCMbruHS3ByBg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-26359a348ccso643500a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:17:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689679029; x=1690283829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMvWdQ8jDtgrg4TmzvreNToMG0I25+6piVG21WnWmLI=;
        b=gt26LYWHcHkO4mGJM26Dfy5C2nHHiITLyWzUAPiCU0ttgkwKmRI+A6JKFA71eg+Yor
         ZQcgrBsAHCOEMWfeLLk6b8lS2gd2BbeYjYR5VjfZzbbL9ReZIbTJlTZZ8eJE6+ABvYfJ
         p9RMdCfruq5zdlykXL/fswUi0zuOk/ZLh7KPsVvd+O384k3tU/3u1Wv8V2KXjHbvPQXq
         PPj9wXgUbskCbI/qG3llbqOvQw2EalAhXQ3JtReAA5XwnqliNRJlrfcBsAKvet8c4HgJ
         Sjuel+gFQ0SOhojn0I/W6PCU7caREgdkshZkqaUQoAqgOtncuLTocAWGZ/6a/IVUhtev
         ueGQ==
X-Gm-Message-State: ABy/qLbgfN266IS+DrdL1uDmOw+EMmxux6yDNxtQpyq9VhKKryHxUrXY
        HvVU2vnW+6Lq/E7ZSA6YIE6Nw/w4mGVkFq+Rn7DdFg1PXGEmXmAoMNjsTtTw68e6iMCPd13peBB
        Y+c3BPPZZCFgs
X-Received: by 2002:a17:903:230b:b0:1b8:b0c4:2e3d with SMTP id d11-20020a170903230b00b001b8b0c42e3dmr11266959plh.4.1689679028951;
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH5kvIm7BO6HgOwtAhzPPJqnxdHrdyX/BVtSHl74wvgT6sMhv7vpU6zAkVVa8mgoPsZbPZuzQ==
X-Received: by 2002:a17:903:230b:b0:1b8:b0c4:2e3d with SMTP id d11-20020a170903230b00b001b8b0c42e3dmr11266944plh.4.1689679028672;
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
Received: from [10.72.112.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l18-20020a170902eb1200b001a80ad9c599sm1576337plb.294.2023.07.18.04.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:17:08 -0700 (PDT)
Message-ID: <4f02d91a-acd8-afa5-03b0-fd8ec29328dd@redhat.com>
Date:   Tue, 18 Jul 2023 19:17:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 09/11] KVM: arm64: Flush only the memslot after
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
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-10-rananta@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-10-rananta@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> After write-protecting the region, currently KVM invalidates
> the entire TLB entries using kvm_flush_remote_tlbs(). Instead,
> scope the invalidation only to the targeted memslot. If
> supported, the architecture would use the range-based TLBI
> instructions to flush the memslot or else fallback to flushing
> all of the TLBs.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 387f2215fde7..985f605e2abc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1082,7 +1082,7 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	write_lock(&kvm->mmu_lock);
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
>   	write_unlock(&kvm->mmu_lock);
> -	kvm_flush_remote_tlbs(kvm);
> +	kvm_flush_remote_tlbs_memslot(kvm, memslot);
>   }
>   
>   /**

-- 
Shaoqin

