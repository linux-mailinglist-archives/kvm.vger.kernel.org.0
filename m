Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B30616B61
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKBSCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKBSCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:02:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081FA21278
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667412068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1RvRC0SBdFOJn30TlRHeijUE+uZFovyhqvtp0pHaQFo=;
        b=EN0kEhaMi6k7nN9cZJE3ISGP3gfcpoxIFxSP3hlCXYm0muVOmtuA3VLgkocWQ988ItzL9I
        85+q01NRsf26pMkMPpmAuLadJ3wjb7ztjdpjk7oJftphScCESUKoqWaBCh0NVy3vlgSy7W
        dg9iyzr/nUHT0N/wOGQakEPCQCKO2YI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-7-bAQVqMZqMEK68hhp0jo4bQ-1; Wed, 02 Nov 2022 14:01:06 -0400
X-MC-Unique: bAQVqMZqMEK68hhp0jo4bQ-1
Received: by mail-ed1-f69.google.com with SMTP id h9-20020a05640250c900b00461d8ee12e2so12811580edb.23
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1RvRC0SBdFOJn30TlRHeijUE+uZFovyhqvtp0pHaQFo=;
        b=6lxmbAFymYr1wlyISiYNQsI+XOxIbh8aQgLSCAUlD5AkfsASVozVX9luWESt6p09kg
         HajUGdYASJ1MsODiXFXsl/cJgc7y28Rn/l/xE5TRGmB+loDKxqIitCghwITpVKa5p4nR
         uzNR1QK2rFtCfwU0Wa8S5r1ZOpOi/5UD6xkxW5vxyVSLkBkHkZHZJIpU4dKNyz70hMLc
         EurMEd/X+0nEl9GjY+g/wfiM/TdwJ9rgsAmzfCiDDVwyO4uphVBB/o2gG7F+jmNWetIM
         SLSEfBCA4O8M+tXff+SEXorX+yG2Fc9tEurKkDpvP6E0zjPWiS5lAlIV0RKXj7HYTpph
         vezw==
X-Gm-Message-State: ACrzQf3fLKZgjtzY9Mm4EaKyX+P3s3QHO6QHOhh4+AZPxbDw7wVdsQB1
        iNxXXZpUuOrSmDTgz0Evbnq3BnYptiW2wFEhPBJMwYgbb9Acjt+D/tV1fSgJ4+4XS/YGz6sZU9I
        bFC4XQD+aMQRh
X-Received: by 2002:a05:6402:4441:b0:454:8a74:5459 with SMTP id o1-20020a056402444100b004548a745459mr25327360edb.155.1667412064821;
        Wed, 02 Nov 2022 11:01:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57hTgvEfvojkgJ8KYcHKTN9VaUPnKu2iAGaKHsefUDp7ok0INXb6ztlZx81bz1ij1AbEgveA==
X-Received: by 2002:a05:6402:4441:b0:454:8a74:5459 with SMTP id o1-20020a056402444100b004548a745459mr25327335edb.155.1667412064616;
        Wed, 02 Nov 2022 11:01:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id be8-20020a0564021a2800b0045c3f6ad4c7sm5974668edb.62.2022.11.02.11.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:01:03 -0700 (PDT)
Message-ID: <a9f099ee-3608-b68c-b089-057bcd9bc4dc@redhat.com>
Date:   Wed, 2 Nov 2022 19:01:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH AUTOSEL 5.19 03/10] kvm: x86: Do proper cleanup if
 kvm_x86_ops->vm_init() fails
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20221014135222.2109334-1-sashal@kernel.org>
 <20221014135222.2109334-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221014135222.2109334-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/14/22 15:52, Sasha Levin wrote:
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
> index 8c2815151864..8d2211b22ff3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11842,6 +11842,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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
> @@ -11877,8 +11881,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

