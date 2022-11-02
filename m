Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C42C616B60
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKBSCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKBSCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:02:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ADA20BE8
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667412063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCufs503dpXhujdx2ITwJq82yoPCeWyuDZvhe6M3z5g=;
        b=WITmVO/apQx4y9E+LjtSXnHYfj1eBIAWSf/GKj8bqpjvwTk6m30SgIC1x9SjzCNc+aHyGF
        ZYWkJ0oPdkehAJb/JeDcvhjDz3hcTUsKMucl/QyJYck1hcHl9+99U/gFD72QJPl08Qk0FY
        4sdBLLqKt5tA2bFahxwU1WHTyiQVYhs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-KZ9y2C0cP4iSILb4kbh3oQ-1; Wed, 02 Nov 2022 14:01:01 -0400
X-MC-Unique: KZ9y2C0cP4iSILb4kbh3oQ-1
Received: by mail-ej1-f70.google.com with SMTP id xj11-20020a170906db0b00b0077b6ecb23fcso10290826ejb.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:01:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rCufs503dpXhujdx2ITwJq82yoPCeWyuDZvhe6M3z5g=;
        b=AiJk5bVUCBn4GMsmjszoEOSn4Z3uT+ZUrqd5Ln1gNlN8UpEoY06XnwDf+fDDPMd1vW
         gjBEvtbPnbbzD+YxRBS3lRMfwjyF98SK2T7DRj5jc4aoxl5crrCPzw0N+E6rbB2lXySp
         c45zDvEKz57kHnHzMPlcdKcBvj3mERAXYB9D9G08gRtlyRVGSuvDDzVcHRN9QsQoPpFY
         ZonWuWV3rEZlhggxgH+smuKWJUMRqN9SflyE1WLSkPe62qrNYCWUdOYIsoWk1pmcH5Jh
         Nu5jute6Yd1QpPrcQP+U+riPJIR/WPgT2Rc+giy3Jb5LmtLVmZPrb/lo26VJLCjO4jc4
         cfmA==
X-Gm-Message-State: ACrzQf3FeFixadM6VXLT8fmjfEMJkGkc2aTi1UMUnG2Uaktj9ZWgQKIl
        bsKjWXJeqXhS0WmGRnQotOEmb4cnUsQKfHUbrLVUyG46lyWPDMPtaKflYOMq1SJOweL9UYgT+Xz
        od8RKurXvN69e
X-Received: by 2002:a17:907:162a:b0:7a9:9875:3147 with SMTP id hb42-20020a170907162a00b007a998753147mr24811955ejc.546.1667412059713;
        Wed, 02 Nov 2022 11:00:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6+k26jt8P0meTC5cvtxOQG2A16cOuUyN4Zb9NbzYoBjeJ+Gwhk+kLVvmXBfhREPPfCCMEb7A==
X-Received: by 2002:a17:907:162a:b0:7a9:9875:3147 with SMTP id hb42-20020a170907162a00b007a998753147mr24811931ejc.546.1667412059484;
        Wed, 02 Nov 2022 11:00:59 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id q16-20020a17090676d000b007ae035374a0sm1016781ejn.214.2022.11.02.11.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:00:57 -0700 (PDT)
Message-ID: <28116f0b-4acd-d72c-aaee-c2fc63ad8190@redhat.com>
Date:   Wed, 2 Nov 2022 19:00:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH AUTOSEL 6.0 03/11] kvm: x86: Do proper cleanup if
 kvm_x86_ops->vm_init() fails
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20221014135139.2109024-1-sashal@kernel.org>
 <20221014135139.2109024-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221014135139.2109024-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/14/22 15:51, Sasha Levin wrote:
> From: Junaid Shahid <junaids@google.com>
> 
> [ Upstream commit b24ede22538b4d984cbe20532bbcb303692e7f52 ]
> 
> If vm_init() fails [which can happen, for instance, if a memory
> allocation fails during avic_vm_init()], we need to cleanup some
> state in order to avoid resource leaks.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> Link: https://lore.kernel.org/r/20220729224329.323378-1-junaids@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c47b41c264..11fbd42100be 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12080,6 +12080,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	if (ret)
>   		goto out_page_track;
>   
> +	ret = static_call(kvm_x86_vm_init)(kvm);
> +	if (ret)
> +		goto out_uninit_mmu;
> +
>   	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
>   	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>   	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
> @@ -12115,8 +12119,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm_hv_init_vm(kvm);
>   	kvm_xen_init_vm(kvm);
>   
> -	return static_call(kvm_x86_vm_init)(kvm);
> +	return 0;
>   
> +out_uninit_mmu:
> +	kvm_mmu_uninit_vm(kvm);
>   out_page_track:
>   	kvm_page_track_cleanup(kvm);
>   out:

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

