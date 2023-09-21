Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5429A7A9B37
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjIUS4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIUSzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADBD46E5C
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695321302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tSWZutc0jBg4LRB6lh/PjnElphckaTmoFsFbI4z61RQ=;
        b=BOruYlQ1AkHaTBAUGrIiqN+2Ft3e8aULApPKMy60xeYc2F3CboRSFqSmsS2lbLwj5KOdc1
        SEin1+mGkWHxN06AD74Xyjn3ySQFU5pNCD1NRR3D5eCi1TRL7g5zb07bJmjpa0qa71WDov
        GLebojHw/hgfcrj9lI9JZO3kqL2hBtc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-VoiVm3BsPjGwxP3NmzF8Lw-1; Thu, 21 Sep 2023 06:05:17 -0400
X-MC-Unique: VoiVm3BsPjGwxP3NmzF8Lw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40478e6abd0so6013285e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 03:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695290716; x=1695895516;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSWZutc0jBg4LRB6lh/PjnElphckaTmoFsFbI4z61RQ=;
        b=iHaIv7M6FeY1M5JTJVlo78kgcuYwLxwJ/OIE8seElkVxNt8+EY3qohTlBaagvMZ8yM
         g6Sap5Ak64RU53YOlCt4rp6OSnPDMzMhKT5/SuXOwJ7hjshew04phoOYqf4fWLA1K+0y
         MpamKWjzm+AqPJuqEhnD3AKjtL9zst5gNfQIvsx9NTMZzrBEoEYVzDPqn30sTpxpyar/
         +CZrNI+LDrMGQn/e0s6W1IkVzukDKrok4gquamq5KOulplkg2iSz0YE5xeO+L3G+Q2YC
         pGFPOz320YlpPlSCz1Rkb/Huvr1Jrz8u9OmYyrB1bGp706ooWlTW9qhUTwBJuE3Hl6zF
         oMww==
X-Gm-Message-State: AOJu0YyPw3EFSu6+F6XFmA3DCMi0hUMFDglIcCtTPNhBEj2JKwJRmBXL
        Z0738CAl4ekOFqJlT3VPDeOvmyMIIQNcBtTVDHduVkwEw5A52jx1T2hb2V20n5uBaKTjzIYGdXo
        tK0P+2cG9HKNB
X-Received: by 2002:adf:e70b:0:b0:31f:b364:a6ba with SMTP id c11-20020adfe70b000000b0031fb364a6bamr4691483wrm.52.1695290716206;
        Thu, 21 Sep 2023 03:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFb+xpkOukKwFUqxDHZtMEtfwl9qISBYPAa6ay6agAbXJC9Ql0Yok8DkWeufmD4yqy0T55nBg==
X-Received: by 2002:adf:e70b:0:b0:31f:b364:a6ba with SMTP id c11-20020adfe70b000000b0031fb364a6bamr4691458wrm.52.1695290715836;
        Thu, 21 Sep 2023 03:05:15 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i9-20020a5d6309000000b003214fc12a30sm1298462wru.106.2023.09.21.03.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 03:05:15 -0700 (PDT)
Message-ID: <01cf00ad-0461-d72f-4b0d-d2093628049d@redhat.com>
Date:   Thu, 21 Sep 2023 12:05:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
References: <20230916003916.2545000-1-seanjc@google.com>
 <20230916003916.2545000-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Open code walking TDP MMU roots for
 mmu_notifier's zap SPTEs
In-Reply-To: <20230916003916.2545000-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/23 02:39, Sean Christopherson wrote:
> Use the "inner" TDP MMU root walker when zapping SPTEs in response to an
> mmu_notifier invalidation instead of invoking kvm_tdp_mmu_zap_leafs().
> This will allow reworking for_each_tdp_mmu_root_yield_safe() to do more
> work, and to also make it usable in more places, without increasing the
> number of params to the point where it adds no value.
> 
> The mmu_notifier path is a bit of a special snowflake, e.g. it zaps only a
> single address space (because it's per-slot), and can't always yield.
> 
> Drop the @can_yield param from tdp_mmu_zap_leafs() as its sole remaining
> caller unconditionally passes "true".

Slightly rewritten commit log:

---
The mmu_notifier path is a bit of a special snowflake, e.g. it zaps only a
single address space (because it's per-slot), and can't always yield.
Because of this, it calls kvm_tdp_mmu_zap_leafs() in ways that no one
else does.

Iterate manually over the leafs in response to an mmu_notifier
invalidation, instead of invoking kvm_tdp_mmu_zap_leafs().  Drop the
@can_yield param from kvm_tdp_mmu_zap_leafs() as its sole remaining
caller unconditionally passes "true".
---

and using the "__" macro can be moved to the second patch.

Paolo

