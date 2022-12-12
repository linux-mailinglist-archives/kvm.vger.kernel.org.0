Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC64649CD9
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 11:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiLLKoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 05:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiLLKmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 05:42:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099A0B7DF
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670841383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
        b=WDjoGjpC2rxRC/a5Knq34XtqIX4r4QbV+A0DiHlRTqsOChXl7EwoO5Ik/NLX2jNVqANVUq
        MB9hQ+vzl5CqHx3IPxWUfDGKiCjXE9snWeVidHY8jRb7AAeEJ3aXLpIL8YMAfMYeHaAdMy
        0j3qtZgkFzOyQ8QDxat2t6oj5U35MG8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626-XsTk83z3PxyV4hC6A1e4uw-1; Mon, 12 Dec 2022 05:36:22 -0500
X-MC-Unique: XsTk83z3PxyV4hC6A1e4uw-1
Received: by mail-wm1-f72.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so1847527wmb.6
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 02:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQe1vPVAoLefYVtJgOMADA9UsAQ3Kxq8XGAB/nV1Q60=;
        b=UsNDDC5Zl6zQYNs1+ywBBDDk040hyzxFnsoXBuiPULGUYAsKQmvEUnLtEr9lSQixIH
         Ar4hWLJaAbnv/EmtmyK7e4XKY4jxcwpInhzsTOQTT8BlznGnTthm0PHYQd9c4RCousqD
         bHAK2ooL+y7CG7RaJErypH868bvVwjA6efZuvUaAwrJHzZDQkAiYx8Dvv8w8PmQBIcUc
         1pCo2zvDDV9sLYF/tFZaYpl+amfis78N3jai6xceM14a3MuJa+sdEMCxbFK3Z8SgQ2oV
         x2YQvl2ofbJV7iezlaELOEEUqFCN9Dlvcmynab4KKCABzjCKswyA8r+ts5nF7IyNQ491
         OJ8w==
X-Gm-Message-State: ANoB5pkN6+Jo//+UKiz3Hl0WMOuEh+JxRzgRc/sC7nNZC90LIKgBr3Ms
        pludAjgJPdYypMcIaOOeEwPebD98+YiiwVtuP4YgO4awX2srR27wmgyb0FgfjKL+00iBvbo/zy8
        5vhFwCSYHzQY5
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id j10-20020a5d564a000000b0024cf1cab2dfmr5988130wrw.67.1670841380634;
        Mon, 12 Dec 2022 02:36:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5yfwj5UnZ7QW7iYJjXIjnpYQh7U361r5HLW6PWTGWDdexdLTapuWofhSkU9q9aAnLfd+7YDA==
X-Received: by 2002:a5d:564a:0:b0:24c:f1ca:b2df with SMTP id j10-20020a5d564a000000b0024cf1cab2dfmr5988117wrw.67.1670841380414;
        Mon, 12 Dec 2022 02:36:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bp8-20020a5d5a88000000b00241e8d00b79sm10772956wrb.54.2022.12.12.02.36.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 02:36:19 -0800 (PST)
Message-ID: <42dbdb4d-13da-cd6b-e2ad-95b0cb0ff04e@redhat.com>
Date:   Mon, 12 Dec 2022 11:36:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 0/7] KVM: selftests: Fixes for ucall pool +
 page_fault_test
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/22 02:52, Oliver Upton wrote:
> The combination of the pool-based ucall implementation + page_fault_test
> resulted in some 'fun' bugs. As has always been the case, KVM selftests
> is a house of cards.
> 
> Small series to fix up the issues on kvm/queue. Patches 1-2 can probably
> be squashed into Paolo's merge resolution, if desired.
> 
> Tested on Ampere Altra and a Skylake box, since there was a decent
> amount of munging in architecture-generic code.
> 
> v1 -> v2:
>   - Collect R-b from Sean (thanks!)
>   - Use a common routine for split and contiguous VA spaces, with
>     commentary on why arm64 is different since we all get to look at it
>     now. (Sean)
>   - Don't identity map the ucall MMIO hole
>   - Fix an off-by-one issue in the accounting of virtual memory,
>     discovered in fighting with #2
>   - Fix an infinite loop in ucall_alloc(), discovered fighting with the
>     ucall_init() v. kvm_vm_elf_load() ordering issue

Queued 3+5, thanks.

Paolo

