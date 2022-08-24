Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2D15A0020
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239924AbiHXRN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiHXRN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:13:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8367CE78
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661361234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tuZk/Krq6hGyifX8HCw3lyKxmaIHFfb7r24yMdOL1tk=;
        b=W24eMIdpF1RWOQFKJLReNX4kw1r/Ywwn9Mx0Vq9E8S8/SYblZZ6IjW2MSatMPFgUColZV/
        sfCYtoHB+Y2LvrRmJTcJ1QrYoAwgOvL6HKKGH6aj6t7F8BnLCHyyaKFAveLq4qq6i8z1wY
        8vS51wTZiP8pzGRiGu7OXA/1Lmw8v24=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-7Mi6ozpNOoSWuwbiln5oXw-1; Wed, 24 Aug 2022 13:13:53 -0400
X-MC-Unique: 7Mi6ozpNOoSWuwbiln5oXw-1
Received: by mail-wm1-f72.google.com with SMTP id ay21-20020a05600c1e1500b003a6271a9718so9411209wmb.0
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tuZk/Krq6hGyifX8HCw3lyKxmaIHFfb7r24yMdOL1tk=;
        b=Jvb6VaWuli1EYjp6ZUO8KoTloW9RbEqQSnWkSLxIOU4k2AMzgQKE99QzQOZm45ynvn
         Zt8r/Xue9UZTSeTe1qHNRI81V3iK9b5juPUR3laTD8JbkaCPQP+ReVwmmWUClz6FCP4p
         gZKH7UOFB9udWkETT1ebhrn7SOYQrnC+pVGjSF90t9DRIxs/CLQGciQ+9wIQjbeYdMzt
         T1LoSIwY+h1BnquUTzm1WEvFK9jdL/HPF2EJK38nEVOvc8jXcWNgg7jCInxSaqyABUE1
         M2ttb6Bkv4AGQ4L2cUNbKcHb0F029Iiz2ZSrzRVeuxulZuE7P0ryRGk7uYO3XthFJSPs
         QdwQ==
X-Gm-Message-State: ACgBeo0URUCmqno8OjWva4Y96Dtic644hcEtroajtStbzeTbukwaQGjK
        qlDZKSES4Cbz7+MKQqA0RVXmiAADezS0UUiOpWjVKKpkD1AA4kLUVSGGhc2OBf7b5L7J1FC1jsE
        Bv4ZsVEYC1SsT
X-Received: by 2002:a5d:4e41:0:b0:225:5b3d:3942 with SMTP id r1-20020a5d4e41000000b002255b3d3942mr138096wrt.78.1661361232070;
        Wed, 24 Aug 2022 10:13:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4eo7NGgzFigzRHD+53MEwLFsw5/KpvzidbxVsbzsXvf2VZZxMIi7HBZI00mo0WNMsBZHT4EQ==
X-Received: by 2002:a5d:4e41:0:b0:225:5b3d:3942 with SMTP id r1-20020a5d4e41000000b002255b3d3942mr138076wrt.78.1661361231827;
        Wed, 24 Aug 2022 10:13:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id p7-20020a05600c1d8700b003a5bd5ea215sm2602518wms.37.2022.08.24.10.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 10:13:51 -0700 (PDT)
Message-ID: <e3718025-682d-469c-eac9-b4995e91dc11@redhat.com>
Date:   Wed, 24 Aug 2022 19:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org, tony.luck@intel.com,
        peterz@infradead.org, kyung.min.park@intel.com, wei.huang2@amd.com,
        jgross@suse.com, andrew.cooper3@citrix.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <CALMp9eSKcwChbc=cgYpdrTCtt49S1uuRdYoe83yph3tXGN6a2Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eSKcwChbc=cgYpdrTCtt49S1uuRdYoe83yph3tXGN6a2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/22 23:26, Jim Mattson wrote:
> For consistency, should this feature be renamed AMD_PSFD, now that
> Intel is enumerating PSFD with CPUID.(EAX=7,ECX=2):EDX.PSFD[bit 0]?
> Seehttps://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html.
> 
> And, Paolo, why are we carrying X86_FEATURE_PSFD as a private #define
> in KVM rather than putting it where it belongs in cpufeatures.h?
> 

Borislav asked to not show psfd in /proc/cpuinfo, because Linux had
decided not to control PSF separately; instead it just piggybacked
on SSBD which should disable PSF as well.  Honestly I disagree but
it's not my area of maintenance.

Paolo

