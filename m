Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2F540234
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 17:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbiFGPPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 11:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343901AbiFGPPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 11:15:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADE271EAD6
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654614893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6/ubDDYUq7JsSD5y7BKE6Pnt9grBbg8NpCvbzWDfuGc=;
        b=NQbWoUFv7cezwYTHlXbqmgDo9GuspCEaimV5dfKlug6uukNyh07LnyHaqKRfWA/9EoJQir
        PKbRuHk+mNSAtviVM4YV7dIYm7GJR7nGadYNLh9jOsoGby5H1yZ0PzUZPJUBNRBkBpPuo8
        j7AvACs7U7fncK/+HtKC9rSE9roWWrk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-ZKTk2AhPOPit1npjl4Ux-Q-1; Tue, 07 Jun 2022 11:14:52 -0400
X-MC-Unique: ZKTk2AhPOPit1npjl4Ux-Q-1
Received: by mail-wr1-f71.google.com with SMTP id m18-20020adff392000000b0021848a78a53so1492031wro.19
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 08:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6/ubDDYUq7JsSD5y7BKE6Pnt9grBbg8NpCvbzWDfuGc=;
        b=UTjtOpX1bbVdFnSeWszOjwrKZycCms9PL56QBqw/qQqRDcjM9poywncAGZzLIb6kk0
         YCv5ocHNFRzFktVpkvoqeK1D+KIZ06UjO0zYCtZLcrylmLKHJLUYtVqKQfe4rUz2dEjL
         kNyUlEqXBbTU4ulIXJb/kDc3E9jYXMZNPTKHJOJN5MlSae9D8oVvtnZ/+FyfpDHhV9bB
         fXkZaXKquCBwMXgQFPsX1VlB2uXTLHaZhaVBZ6otLoQixTWbHATQU0gbNG92VgsKgBoP
         tqss4Hn4iw6jmpiPKyouz3q9Isi7sZQLPSRb1wBSTD4aY7BEZ7/o5nW2TENZpj3y2l7g
         iIwA==
X-Gm-Message-State: AOAM531LrdpnkziD4rWjC+hqoMoIBq7YncaF+dpvR0wijIWoRLNwEsVk
        VhkeLdM7rNT9CfjindeO5QK0EQqAXLmZpwzpCHT7GI2kC+XL6B0PcmufLZNKY0Q9b4ZgHAf9ofq
        qqSXImtqOCVi6
X-Received: by 2002:a7b:c341:0:b0:37b:ed90:7dad with SMTP id l1-20020a7bc341000000b0037bed907dadmr28506803wmj.138.1654614891006;
        Tue, 07 Jun 2022 08:14:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUdbpCo/MOt8IWw71ZrXkaFebf2wItJLgp9HKWhrVYS9665oEGQ/r6dzZuLlTCgCgb4RxP8g==
X-Received: by 2002:a7b:c341:0:b0:37b:ed90:7dad with SMTP id l1-20020a7bc341000000b0037bed907dadmr28506758wmj.138.1654614890592;
        Tue, 07 Jun 2022 08:14:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u10-20020adfdd4a000000b002102cc4d63asm21428082wrm.81.2022.06.07.08.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 08:14:49 -0700 (PDT)
Message-ID: <97789f9e-a33e-bb8d-d5b1-9be31232b64a@redhat.com>
Date:   Tue, 7 Jun 2022 17:14:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] KVM: x86/mmu: Check every prev_roots in
 __kvm_mmu_free_obsolete_roots()
Content-Language: en-US
To:     shaoqin.huang@intel.com
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220607005905.2933378-1-shaoqin.huang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220607005905.2933378-1-shaoqin.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/22 02:59, shaoqin.huang@intel.com wrote:
> From: Shaoqin Huang <shaoqin.huang@intel.com>
> 
> When freeing obsolete previous roots, check prev_roots as intended, not
> the current root.
> 
> Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
> Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
> ---
> Changes in v2:
>    - Make the commit message more clearer.
>    - Fixed the missing idx.
> 
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f4653688fa6d..e826ee9138fa 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5179,7 +5179,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
>   		roots_to_free |= KVM_MMU_ROOT_CURRENT;
>   
>   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> -		if (is_obsolete_root(kvm, mmu->root.hpa))
> +		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
>   			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
>   	}
>   

Queued, thanks.

Paolo

