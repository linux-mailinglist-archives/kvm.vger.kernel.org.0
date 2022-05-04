Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C335C51AD93
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353205AbiEDTPl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiEDTPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BC1C488A9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651691518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hd3MPPhfZEFzLVMyRypDkVk2xJ4qChQYAeQatJK81b8=;
        b=VkbF9ketZgSP1c2dOtXPa8f+GREB8T2B2LoG73rDI61mJoqyVPJ2AtxMxzjxQVUMcCk/gJ
        g7dioa2UUMdRPKxFVvVu/onQ7tb9bgL5OD1rfT12DRNCameHfuPH1/Cc/BA+iLwU7kA0L3
        NnG4Vw+ON/5Sk1zWgeZjtpVnDQDuSIc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-PptpaQxaNPOdCb9Z6fG7iw-1; Wed, 04 May 2022 15:11:57 -0400
X-MC-Unique: PptpaQxaNPOdCb9Z6fG7iw-1
Received: by mail-ed1-f70.google.com with SMTP id cz24-20020a0564021cb800b00425dfdd7768so1292451edb.2
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 12:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hd3MPPhfZEFzLVMyRypDkVk2xJ4qChQYAeQatJK81b8=;
        b=StJjI5SMla3J5oBDz0DJGON3XjxNOGHXWEXRnXO6NITv+8EYeXHZaqMrUriK/5AFwv
         /Kl57UFS3R6zVh8lToxqYu3BgslhzC1neuQKMytqv+akMkxGeZsRzTwta7a7o9b6DJ/a
         BdPm4S7B6Ycr63BpR91ii3wzeWYDiqAS5Y9tRCQA+TmzaGVaJyseznj6PjlFgNq5dI0T
         qWXQk54q0zPLtvBBrhUMNNsmKAmaG2lPQ0RIMlH4Oyol6NkLOByS/KdUYzbP3E/cZUEk
         8jidLOl+P3Da7TxVTwIGGEGx8nAJufG3eFFBXt4adXxpFcRcxfnGYdPu/D3knrUolILw
         GHlg==
X-Gm-Message-State: AOAM532kS7gw3icYH31Z3UM3hq1mtP0LFn2nShQtXig/5HhytTSlAVZC
        dX2wpbWzK1RlAkBINDJZhI8+q+mNsRfcs/R45T3c3crakqDSBbA7EIAc7vKxioX1K8+vxXm/ycA
        TPjo1gMXO3ouo
X-Received: by 2002:a17:907:728d:b0:6f4:5a83:a616 with SMTP id dt13-20020a170907728d00b006f45a83a616mr14064184ejc.297.1651691516005;
        Wed, 04 May 2022 12:11:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyg0JsD7iu2Y23r3GnlIcchSoad40wOMbWKHRukO45v+eQMegv9BK4IGGRz74EZIhhUiWnzCg==
X-Received: by 2002:a17:907:728d:b0:6f4:5a83:a616 with SMTP id dt13-20020a170907728d00b006f45a83a616mr14064160ejc.297.1651691515824;
        Wed, 04 May 2022 12:11:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id qz24-20020a170907681800b006f4c82c2b12sm930211ejc.19.2022.05.04.12.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:11:55 -0700 (PDT)
Message-ID: <0ba0b879-cc46-1f60-539a-5bb7e407c01f@redhat.com>
Date:   Wed, 4 May 2022 21:11:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
References: <Ymv5TR76RNvFBQhz@google.com>
 <e5864cb4-cce8-bd32-04b0-ecb60c058d0b@redhat.com>
 <YmwL87h6klEC4UKV@google.com>
 <ac2001e66957edc8a3af2413b78478c15898f86c.camel@redhat.com>
 <f3ffad3aa8476156f369ff1d4c33f3e127b47d0c.camel@redhat.com>
 <82d1a5364f1cc479da3762b046d22f136db167e3.camel@redhat.com>
 <af15fd31f73e8a956da50db6104e690f9d308dad.camel@redhat.com>
 <YnAMKtfAeoydHr3x@google.com>
 <e11c21e99e7c4ac758b4417e0ae66d3a2f1fe663.camel@redhat.com>
 <cbd4709bb499874c60986083489e17c93b48d003.camel@redhat.com>
 <YnGQyE60lHD7wusA@google.com>
 <42e9431ec2c716f1066fc282ebd97a7a24cbac72.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <42e9431ec2c716f1066fc282ebd97a7a24cbac72.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/4/22 14:08, Maxim Levitsky wrote:
> Nope, still reproduces.
> 
> I'll think on how to trace this, maybe that will give me some ideas.
> Anything useful to dump from the mmu pages that are still not freed at that point?

Perhaps you can dump the gpa and TSC of the allocation, and also print 
the TSC right before destroy_workqueue?

Paolo

