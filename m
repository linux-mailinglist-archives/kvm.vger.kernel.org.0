Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E836B4E8746
	for <lists+kvm@lfdr.de>; Sun, 27 Mar 2022 12:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiC0Kmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 06:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiC0Kmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 06:42:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7955D1A388
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 03:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648377666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mFTcX2t9p3wv/uCdWkqMzj2ugqVepjYfseDXDJCz6Q=;
        b=fD6DWWyS0GrjR47VNO3xunhsB+HEmcdvndl2xCpyQvWLpzCmlfYfhw1Cxn8gcQp9peR9SH
        hQQtT+vEXV7svQ+rZl/zTCzaW/YLKtnU00qQpKy1yblBgdUFYL67eEfKL/M1K6A15dIUQN
        7iTQUQG1xNVf60Xv4TbwJ78OAeF1LAE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-ZfHeork8OsW5zLXoWvwXBQ-1; Sun, 27 Mar 2022 06:41:04 -0400
X-MC-Unique: ZfHeork8OsW5zLXoWvwXBQ-1
Received: by mail-ed1-f72.google.com with SMTP id j39-20020a05640223a700b0041992453601so5219384eda.1
        for <kvm@vger.kernel.org>; Sun, 27 Mar 2022 03:41:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1mFTcX2t9p3wv/uCdWkqMzj2ugqVepjYfseDXDJCz6Q=;
        b=KzVPAKTkrDAeskQmBx+3mCkPlQwGWDQ2xkliokW2fn/74UKqnP6JWOIPQ3lGeou/E/
         wdRybYWH4kwvRYxIdDtLklbETQ6gHp3FEKwH1ObSNABWV0xtMzSJIqtP3BCDMizwEpWg
         fqBUZjyCfAgQYGGdzVybSYGqrKQDo6pgnMtTINKPp2Zwg0Km1DzW3fntsz7nA4ArKBMk
         lKOkNcCCICeK7WwphR3bZz6h1oW/PdJH4qDuEK1Td7aLt6WswS42JNF1H5IeKZeXdsGY
         5mBuJRWimKj31dIzuV5EXf96Tq5+/KAWyRxyP2vwQjM++VyOYhQG2Y/xYv3l/ozmj64k
         11Ew==
X-Gm-Message-State: AOAM531Eoc4PboRIOPDes1OTL9/tW+uDn3WDEh8Ga14fgO6PKNfxBwaY
        aLYn79wrFio1YWfeyIOmSdXaJQnD26Cigi5eWSc+cAH/MU1LeGNy2d2j5ShjkjJPTmAJWK/f8iR
        V+X/IIbX2zgnk
X-Received: by 2002:a17:906:17db:b0:6da:f8d8:ab53 with SMTP id u27-20020a17090617db00b006daf8d8ab53mr21089982eje.274.1648377663427;
        Sun, 27 Mar 2022 03:41:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytaQvKY2CY47C0QVZPuli4dV3wY/7Vyq9dDldBV4fgLQZcD0AOfYQcDpZA6+PHM7wg3h7irw==
X-Received: by 2002:a17:906:17db:b0:6da:f8d8:ab53 with SMTP id u27-20020a17090617db00b006daf8d8ab53mr21089962eje.274.1648377663200;
        Sun, 27 Mar 2022 03:41:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id v26-20020a50955a000000b00418ebdb07ddsm5606052eda.56.2022.03.27.03.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Mar 2022 03:41:02 -0700 (PDT)
Message-ID: <b754fa0a-4f9e-1ea5-6c77-f2410b7f8456@redhat.com>
Date:   Sun, 27 Mar 2022 12:40:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely
 populated rmaps
Content-Language: en-US
To:     Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220325233125.413634-1-vipinsh@google.com>
 <CALzav=e6W2VSp=btmqTpQJ=3bH+Bw3D8sLApkTTvMMKAnw_LAw@mail.gmail.com>
 <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHVum0dOfJ5HuscNq0tA6BnUJK34v4CPCTkD4piHc7FObZOsng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/26/22 01:31, Vipin Sharma wrote:
>>> -static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
>>> +static noinline void
>>
>> What is the reason to add noinline?
> 
> My understanding is that since this method is called from
> __always_inline methods, noinline will avoid gcc inlining the
> slot_rmap_walk_next in those functions and generate smaller code.
> 

Iterators are written in such a way that it's way more beneficial to 
inline them.  After inlining, compilers replace the aggregates (in this 
case, struct slot_rmap_walk_iterator) with one variable per field and 
that in turn enables a lot of optimizations, so the iterators should 
actually be always_inline if anything.

For the same reason I'd guess the effect on the generated code should be 
small (next time please include the output of "size mmu.o"), but should 
still be there.  I'll do a quick check of the generated code and apply 
the patch.

Paolo

