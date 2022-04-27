Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0992751175A
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 14:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiD0MZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 08:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiD0MZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 08:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BAE240A22
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 05:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651062136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQ+0Ceo3McurL0XSQT/LicuV5aNuvEIglYDv/pzRVNQ=;
        b=JCiRHHs+Z5ptDQFVgNA8JuykU6T4Z6UESQ0GVfnaO1JXSSQzXpvo5XMQc0JYVXVGYk7roM
        bUDAPUetyFRUBohKti6Ryxh4X4pq2el51p8S1F1OoCpVhj2xfe/v0EqUlLIwu4dJWrN1pj
        Ykad70EL2G3TRereG3CWDo1XXcpxCMw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-DONuUUZNPJGeU4YxZtWpsg-1; Wed, 27 Apr 2022 08:22:13 -0400
X-MC-Unique: DONuUUZNPJGeU4YxZtWpsg-1
Received: by mail-ej1-f71.google.com with SMTP id qf24-20020a1709077f1800b006e87e97d2e7so1066193ejc.3
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 05:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=EQ+0Ceo3McurL0XSQT/LicuV5aNuvEIglYDv/pzRVNQ=;
        b=xEv48loEL7WNeaYfbPBjzGoQXb9m95b90aLDljqXIcnD/cySDhG6hCpZEOl7ZmGuVR
         JSx3feDiMgUF8QqzJpong7OF2wAe4Qgco3wMY2R0ALBmM4HinNMrLsKCNP9luznnM7pK
         /nsLUIZUKqqaNcv0aSqNSTQIMyLbWd1D+IWhOJG5hoZ7LnaW0XULDK/47df8N7Uzt+wn
         GChrLo741OVdvhr4UoLGVfCO8Jyo/Zc3VQcA2TBYixRUu/WvofJ1e7+GIiCy8AV7yHfM
         dxl7uw93tmsD8AK7BjT7IVKEKnepcDAYaoczWPRRGJfDGEvE4hrpG2i9pkrO+OWzB9Uq
         OBzA==
X-Gm-Message-State: AOAM532Z83M1j/CXKSf88srhWb7HNjk0rDLqApzEdSxTbP5X2QUL0Iml
        BZ2Gnci9WFlo2tPa2Nzd40yh0Civia3TTE2mrZfDUBOxKLO6A1by9Ovh7zNmQV7ftwJNE95pde4
        9b7OhoRlfN8SB
X-Received: by 2002:a05:6402:3609:b0:425:a4bc:db86 with SMTP id el9-20020a056402360900b00425a4bcdb86mr30240318edb.98.1651062131908;
        Wed, 27 Apr 2022 05:22:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuj09Zt9Xrl6beXjm441/a58r42X6yqePyFwWFQI6q2sJBs4NcSfoDnbKEM2YpH2jkXcbBhw==
X-Received: by 2002:a05:6402:3609:b0:425:a4bc:db86 with SMTP id el9-20020a056402360900b00425a4bcdb86mr30240296edb.98.1651062131708;
        Wed, 27 Apr 2022 05:22:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id b16-20020a170906709000b006f3a8aac0eesm3136859ejk.0.2022.04.27.05.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 05:22:11 -0700 (PDT)
Message-ID: <229c4cb9-c8f4-6392-dfb5-c9afedc3262b@redhat.com>
Date:   Wed, 27 Apr 2022 14:22:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
 <YmghjwgcSZzuH7Rb@google.com>
 <cc0c62dd-9c95-f3b9-b736-226b8c864cd4@redhat.com>
 <YmgtPGur0Uwk5Yg6@google.com> <Ymg2pN9V4uwkmLZ/@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
In-Reply-To: <Ymg2pN9V4uwkmLZ/@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 20:15, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Sean Christopherson wrote:
>> On Tue, Apr 26, 2022, Paolo Bonzini wrote:
>>> On 4/26/22 18:45, Sean Christopherson wrote:
>>>> On Tue, Apr 26, 2022, Maxim Levitsky wrote:
>>>>> [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
>>>>> [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
>>>>
>>>> This is my fault.  memremap() can sleep as well.  I'll work on a fix.
>>>
>>> Indeed, "KVM: Fix race between mmu_notifier invalidation and pfncache
>>> refresh" hadn't gone through a full test cycle yet.
>>
>> And I didn't run with PROVE_LOCKING :-(
>>
>> I'm pretty sure there's an existing memory leak too.  If a refresh occurs, but
>> the pfn ends up being the same, KVM will keep references to both the "old" and the
>> "new", but only release one when the cache is destroyed.
>>
>> The refcounting bug begs the question of why KVM even keeps a reference.  This code
>> really should look exactly like the page fault path, i.e. should drop the reference
>> to the pfn once the pfn has been installed into the cache and obtained protection
>> via the mmu_notifier.
> 
> This is getting a bit gnarly.  It probably makes sense to drop the existing patches
> from kvm/queue, and then I can send a full v2 instead of just the delta?

Yes, that's a good idea.

Paolo

