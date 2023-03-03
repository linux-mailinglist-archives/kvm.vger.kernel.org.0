Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445296A9384
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCCJPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCCJPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:15:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B29457E8
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677834872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ElE1LjbREKSESr9EiwNTgI8SniA5dGYSmsKj5Ma/fSU=;
        b=bjy0bnmrzrDYDGDzFO8YGZ3uRXAzt50TVdh9wU/zTCU1+/o5ZQmaj2ceCp0bk/wrLm1hdo
        WTT6IfU73LLQdDXtK1bs5fzZQXoeKevL7KoPwlrC3K2S6/yIj+yk1L9dtfJ668ZaDAYqO4
        TzRZdmneRx/rysAC7WGbnuN2uxOVBBY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-573-YvPQuF2uNMin7BPKEUaEBg-1; Fri, 03 Mar 2023 04:14:31 -0500
X-MC-Unique: YvPQuF2uNMin7BPKEUaEBg-1
Received: by mail-qk1-f198.google.com with SMTP id d72-20020ae9ef4b000000b0072db6346c39so984910qkg.16
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 01:14:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ElE1LjbREKSESr9EiwNTgI8SniA5dGYSmsKj5Ma/fSU=;
        b=fDnFswr9fUCEkm/p7GkcZgJEq1w9SqeTkdp/dhIwu9mGEGT3GSpOgI2KUntqXeBf/z
         K6M3PkAPS1oQOVdm5cYnZkQLEOqXOJHkOKHNs8zrBH6wdsJnGChACSj0GLa9H5h7DMgA
         ZsliDB0vCe+PzuQdLtBer2lYUVJ2jZUqiaKwZOKg0lrXQQIRUKYLwkfwmWkuEgUtiJOi
         Bdwdxcjceqj2af9uAYQcxUZ9t9H7Gx/QaOVeOWShaP2hMpt4J8REhVpHoqD6e1p0FDxN
         +tXqFtgUvKElu1Y2dYuUM3rSqbpVmbkT4ofwZgkIKfloo9ipXIbc98NtzSckRLI2A+ij
         raDg==
X-Gm-Message-State: AO0yUKWnVgWIaYzi9Bl7d1QofOmxZKPFlrgnibXnE5I+sGCjazg0B/jY
        ZMBxz/7daPmcDB5fDKgPqkLBPyZlBNS2CTDtKnnjp1y2ERcRfqW5/yULJzKuzH2yFNA7NBljMnU
        ejzESxXj4socn
X-Received: by 2002:a05:622a:1753:b0:3bf:daa8:cacc with SMTP id l19-20020a05622a175300b003bfdaa8caccmr1890688qtk.3.1677834871085;
        Fri, 03 Mar 2023 01:14:31 -0800 (PST)
X-Google-Smtp-Source: AK7set+ExrTlvAdM0fij85zmPZ19kivkSvquwQopzeOB1lF6a91tW8NLVLGuWTzAYp6FLn0X26n1aA==
X-Received: by 2002:a05:622a:1753:b0:3bf:daa8:cacc with SMTP id l19-20020a05622a175300b003bfdaa8caccmr1890666qtk.3.1677834870790;
        Fri, 03 Mar 2023 01:14:30 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o62-20020a375a41000000b0073fe1056b00sm1338448qkb.55.2023.03.03.01.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:14:30 -0800 (PST)
Message-ID: <ed801052-008d-42e4-2c91-517783637c5f@redhat.com>
Date:   Fri, 3 Mar 2023 17:14:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-6-ricarkol@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-6-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/23 05:09, Ricardo Koller wrote:
> Refactor kvm_arch_commit_memory_region() as a preparation for a future
> commit to look cleaner and more understandable. Also, it looks more
> like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9bd3c2cfb476..d2c5e6992459 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   				   const struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +
>   	/*
>   	 * At this point memslot has been committed and there is an
>   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>   	 * memory slot is write protected.
>   	 */
> -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +	if (log_dirty_pages) {
> +
> +		if (change == KVM_MR_DELETE)
> +			return;
> +
>   		/*
>   		 * If we're with initial-all-set, we don't need to write
>   		 * protect any pages because they're all reported as dirty.
>   		 * Huge pages and normal pages will be write protect gradually.
>   		 */
> -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> -			kvm_mmu_wp_memory_region(kvm, new->id);
> -		}
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			return;
> +
> +		kvm_mmu_wp_memory_region(kvm, new->id);
>   	}
>   }
>   

-- 
Shaoqin

