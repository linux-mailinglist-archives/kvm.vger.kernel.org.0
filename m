Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F002F5A29DA
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbiHZOoR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344548AbiHZOoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:44:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869111C93A
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661525050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVp4JGBIXQpSm3kQ4cm6KMRIYGQ5gLwGRVip8fUB6E8=;
        b=GoHpNVx7mdLy9ThRLpkSwS/uSGPuwlL2AQvwg+Pji1Ub2r85UqWC6rkroSVwLcdxGORwrG
        T8QtrXKQu8PhC8S2XVdpSdlJDwsALOCVS1wWoGf4jaUSCtQfrsskG/9NXt3IQcRCfKIZ+h
        N9VBw6esQ5iLWD+Nl0BAAg5ZsqObe4c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-45-92QL-q4kPXGxEayncir1hg-1; Fri, 26 Aug 2022 10:44:09 -0400
X-MC-Unique: 92QL-q4kPXGxEayncir1hg-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfa1d1000000b0022574d4574aso193228wrv.22
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=HVp4JGBIXQpSm3kQ4cm6KMRIYGQ5gLwGRVip8fUB6E8=;
        b=fGDyi6dRwMjJTA9DW1hk2qHtEWr0MzVBC6vXfrIjJ91++QB1FxWYNrJiUZCBpmsVUI
         o1xi9bAWuK4PQyuCjaGoS073usOWZD7TnlTm5MVGetPcr1t6o7UK/VS6IgKnIC7eAWF6
         73fjm+pJCX3pnYG8oUPWuye637FdIbYA5d9Ak7TotBF4AGQQNwgAaQzV6Qd3X89+Annk
         E+ViIHE+wWGVsKFJeQMLPay91pJX3J0MQGwRAUkRwV8kmFQ7bo7rBxrS2rGXLCS0snqJ
         tYRYkBnrA29bT27IUjPZA+UbhhUHq9vQayDcaA++3q5iESTNsSMl8Dw7Yz51TYtxdkpM
         4Ulw==
X-Gm-Message-State: ACgBeo1zfO+3vG5/uWQ0iLyJATyvoHIfY9DzkEQY2agaM735XrbZiATU
        2x34SVi/7+ZLgsn6TzTItpcnrYA73dIUm1nZRcPAxWxZRep9U9GqrKceMzLnsuCrzg1KTnrRI1/
        xhpDVdSe9LyQG
X-Received: by 2002:a05:600c:19d0:b0:3a6:2eb1:cfa5 with SMTP id u16-20020a05600c19d000b003a62eb1cfa5mr11395402wmq.37.1661525048169;
        Fri, 26 Aug 2022 07:44:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4xM2jiGQdFFne/iBakDZMTEjwBdHcVQtdLe6W3ZAC7kwXp6gfwTYPKGS38y+6gnIPv2vq6ww==
X-Received: by 2002:a05:600c:19d0:b0:3a6:2eb1:cfa5 with SMTP id u16-20020a05600c19d000b003a62eb1cfa5mr11395380wmq.37.1661525047899;
        Fri, 26 Aug 2022 07:44:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c708:f600:abad:360:c840:33fa? (p200300cbc708f600abad0360c84033fa.dip0.t-ipconnect.de. [2003:cb:c708:f600:abad:360:c840:33fa])
        by smtp.gmail.com with ESMTPSA id h7-20020a5d4307000000b002205a5de337sm1964576wrq.102.2022.08.26.07.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:44:07 -0700 (PDT)
Message-ID: <e0a5f20c-32a5-b57d-0b32-3b1256243b02@redhat.com>
Date:   Fri, 26 Aug 2022 16:44:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
 <6cb75197-1d9e-babd-349a-3e56b3482620@redhat.com>
 <c1e0a91e-5c95-8c10-e578-39e41de79f6a@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <c1e0a91e-5c95-8c10-e578-39e41de79f6a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.08.22 16:32, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 26/08/2022 um 16:15 schrieb David Hildenbrand:
>> On 16.08.22 12:12, Emanuele Giuseppe Esposito wrote:
>>> Instead of sending a single ioctl every time ->region_* or ->log_*
>>> callbacks are called, "queue" all memory regions in a list that will
>>> be emptied only when committing.
>>>
>>
>> Out of interest, how many such regions does the ioctl support? As many
>> as KVM theoretically supports? (32k IIRC)
>>
> 
> I assume you mean for the new ioctl, but yes that's a good question.
> 
> The problem here is that we could have more than a single update per
> memory region. So we are not limited anymore to the number of regions,
> but the number of operations * number of region.
> 
> I was thinking, maybe when pre-processing QEMU could divide a single
> transaction into multiple atomic operations (ie operations on the same
> memory region)? That way avoid sending a single ioctl with 32k *
> #operation elements. Is that what you mean?

Oh, so we're effectively collecting slot updates and not the complete
"slot" view, got it. Was the kernel series already sent so I can have a
look?

Note that there are some possible slot updates (like a split, or a
merge) that involve multiple slots and that would have to be part of the
same "transaction" to be atomic.


-- 
Thanks,

David / dhildenb

