Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FF16576E6
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 14:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiL1NWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 08:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiL1NWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 08:22:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E385F58D
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 05:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672233723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VoX0fOYy2BDjN7WWcv2XIAfkcDcckcAo0GBCFxmkNWU=;
        b=Kouw/WoBWsq8MLSE+339cRBv/GxHoKggY2i6PYt+hplyVUWc/dIay/O9Mcjm3Hg9VFjwwh
        zcA7l6Whp9dmWh+1mapcm+N/WOIvQxglwPemiQWonXHS83Xy0FwohnaVXYQkPr9H5SmBVZ
        w95GzD0C6nsuI+U/2YV4r41CxUhtYBs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-J_v2-GcnMF2HwMiBLBA4Aw-1; Wed, 28 Dec 2022 08:21:54 -0500
X-MC-Unique: J_v2-GcnMF2HwMiBLBA4Aw-1
Received: by mail-ej1-f69.google.com with SMTP id qf33-20020a1709077f2100b007c155ab74e9so10857953ejc.18
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 05:21:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoX0fOYy2BDjN7WWcv2XIAfkcDcckcAo0GBCFxmkNWU=;
        b=Z9aImlR4ub1A/ANyWyGkFjyFQkgFDt3npixBKbJpc61LBjX1yo9qGkfFgin1SCYx/G
         adekt1NZ1vGL3SpSNGLDW5Xrd+DbPGYNaoMD9u3zcJGZxV51q7MrlHNvWWAwYjT1WOYu
         CqiXbTLziw9LZ3J8XbrIE5Iz26Btpem/iC3Sgi/nVhVkx4im9SiN+Vg20G5nssrg3lqm
         QYi50FHhSVM2ANAy12GHdns1MoLX813zGRiohvsVHJ34NwSbJGSDFlV7HOPMhLjTTcKr
         hD1lp4alJ7aUUI3qk4FbQpMgqAOiR3JrlQT6XuvRNR02LNdW677+DPElgQYXSVzOrqyd
         nQNg==
X-Gm-Message-State: AFqh2kpQaOYAe6POgv5FphDh31TJaK1OhYmhFXWg3r8PebGvxs+1fGo5
        Nm1kcGymm3vkp9ja0wrzq9j1xw0vvjzmlgVrwFDi3kLBQuQZx8BpJgA8/sHMd0JhIG+6ohoKs5M
        G6ARrqvKoxcwo
X-Received: by 2002:a05:6402:1609:b0:467:7775:ba8 with SMTP id f9-20020a056402160900b0046777750ba8mr22203169edv.1.1672233713541;
        Wed, 28 Dec 2022 05:21:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsVQlyzIJlKOMVRWcRmu37jM2MJz8kjJirNUFMEGIsarUaKwr0SRSD4p42iR/9N9MpLeGEVfA==
X-Received: by 2002:a05:6402:1609:b0:467:7775:ba8 with SMTP id f9-20020a056402160900b0046777750ba8mr22203160edv.1.1672233713355;
        Wed, 28 Dec 2022 05:21:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id dn5-20020a05640222e500b004610899742asm7170937edb.13.2022.12.28.05.21.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 05:21:52 -0800 (PST)
Message-ID: <3619dc3b-d1b9-ab76-a008-2c45799d5803@redhat.com>
Date:   Wed, 28 Dec 2022 14:21:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <62d7c91f-1486-4aea-8764-352efb383326@email.android.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
In-Reply-To: <62d7c91f-1486-4aea-8764-352efb383326@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/28/22 12:55, Woodhouse, David wrote:
> 
> IIRC the send_port and type aren't used from hcall_send so we could 
> stick those in a union with a 'next' pointer and use it to build a list 
> instead of having to allocate the array (pathological worst case 32KiB).

Yeah I thought about using a list.  The union is doable as you say, but 
I wasn't sure if things were going to change in kvm_xen_evtchn_send later.

And the worst case is order 3, which is within PAGE_ALLOC_COSTLY_ORDER, 
so I decided to go with the array which only consumes memory on reset 
rather than always; it's much more likely that the array will be smaller 
than a page.

Paolo

> Or if the union is a bit icky, we could just add the 'next' pointer 
> unconditionally.
> 

