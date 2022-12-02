Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA7D640D8A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiLBSjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiLBSjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:39:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2003ED69C
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670006249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRCCAO836Dkk36/ISmrsSydPeXHNO72rUKzm2SjpIeo=;
        b=ct6cx4aHmh55hmcuAhojeFZzUGOjrw/Y5i97dnMtrqnFgSLeRiGn3cweYnVtND/Hw9fWnp
        XDAFmBAhI596zrGHR2gnBmKoVeiuQgMpdpLe/MdgAj51R/jClJsRSb3FJTRCHKOfvL+FWx
        4VqQNqlciXRbLreY5VyKiYga8aDlLjM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-4eQMLAThP7Wc-PyCUE9GzQ-1; Fri, 02 Dec 2022 13:37:27 -0500
X-MC-Unique: 4eQMLAThP7Wc-PyCUE9GzQ-1
Received: by mail-wm1-f69.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so2245540wmb.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRCCAO836Dkk36/ISmrsSydPeXHNO72rUKzm2SjpIeo=;
        b=eMKgnOBLbzbZaQlukSNZlJauHEhxpUOtxSTsa9VqOeBoLDd/ipNDj1RaCq39TRCVK/
         rpAUnNOJePmdwnJXxZayjjjmGkDD7kq4G6QxoBgFiYYQAVdkaIkhni1aPGzURTP4J7uz
         Hv4TS4Wogi7xM8KmdcFckAvIRnS8lBgPMu/VgGx26RIiMbN2wcYauXztR5FpIMvXKrWv
         p6iEf3A+CHY+phaj8UTxzbWQLw150jPy1jVNMWgJCQOTl3bJcBSYDjee+vEhMW7vwQTu
         Yc7MbB7aZiAVzkgLyVYCGyVGszgAmBY1TtB8N9eiyA22mPruVHBnhmPoQA3P1AQbu3XH
         7aQw==
X-Gm-Message-State: ANoB5pk89zFnhauQl/KTAnkt0BWioQBiV4pjGehIrS3S+/pNVLN9RG9a
        THTJB7V9SnL1j84RsWF2rcjJlQM45+1fhRb4TS4n8Dma1i7OzzZATrkXppXnd1zYpbPVuDLaBzk
        pRoZIhU2r4w7h
X-Received: by 2002:a5d:65c9:0:b0:241:bd29:6a73 with SMTP id e9-20020a5d65c9000000b00241bd296a73mr43031890wrw.499.1670006246604;
        Fri, 02 Dec 2022 10:37:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5bDxlHPeOMTNDdfeXqolK1EsQa6JCzP6RbCTWC2p3Ob+s87IOgv7n0zbGEsBosGljKzxlI0A==
X-Received: by 2002:a5d:65c9:0:b0:241:bd29:6a73 with SMTP id e9-20020a5d65c9000000b00241bd296a73mr43031885wrw.499.1670006246340;
        Fri, 02 Dec 2022 10:37:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z2-20020a5d4402000000b00226dba960b4sm7559791wrq.3.2022.12.02.10.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:37:25 -0800 (PST)
Message-ID: <95374a64-47fc-ae25-d54e-8200671acacc@redhat.com>
Date:   Fri, 2 Dec 2022 19:37:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 00/14] KVM: x86: Remove unnecessary exported symbols
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221114095606.39785-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 10:55, Like Xu wrote:
> Inspired by the Sean's minor fix [1], more unnecessary (from a GPL
> developer's perspective) exported symbols could be cleaned up
> (automation to find out true positives is possible). This move helps reduce
> the attack surface of KVM modules and guides more developers to practice
> the principle of low coupling in the KVM context.
> 
> [1] https://lore.kernel.org/kvm/20221110010354.1342128-1-seanjc@google.com/

I'll squash everything in a single patch and limit the change to just 
removing EXPORT_SYMBOL_GPL().

Paolo

> Like Xu (13):
>    KVM: x86: Remove unnecessary export of kvm_inject_pending_timer_irqs()
>    KVM: x86: Remove unnecessary export of kvm_get_apic_base()
>    KVM: x86: Remove unnecessary export of kvm_set_apic_base()
>    KVM: x86: Remove unnecessary export of kvm_inject_page_fault()
>    KVM: x86: Remove unnecessary export of kvm_inject_nmi()
>    KVM: x86: Remove unnecessary export of kvm_require_cpl()
>    KVM: x86: Remove unnecessary export of kvm_emulate_as_nop()
>    KVM: x86: Remove unnecessary export of kvm_scale_tsc()
>    KVM: x86: Remove unnecessary export of kvm_vcpu_is_reset_bsp()
>    KVM: x86: Remove unnecessary export of kvm_hv_assist_page_enabled()
>    KVM: x86: Remove unnecessary export of kvm_can_use_hv_timer()
>    KVM: x86: Remove unnecessary export of kvm_lapic_hv_timer_in_use()
>    KVM: x86: Remove unnecessary export of kvm_apic_update_apicv()
> 
> Sean Christopherson (1):
>    KVM: x86: Remove unnecessary export of kvm_cpu_has_pending_timer()
> 
>   arch/x86/kvm/hyperv.c |  1 -
>   arch/x86/kvm/irq.c    |  2 --
>   arch/x86/kvm/lapic.c  |  3 ---
>   arch/x86/kvm/x86.c    | 18 +++++-------------
>   arch/x86/kvm/x86.h    |  2 ++
>   5 files changed, 7 insertions(+), 19 deletions(-)
> 

