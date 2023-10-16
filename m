Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5009F7CAD50
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbjJPPUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjJPPUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:20:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1781F0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697469606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=AEix8IoCjFYipbhyqgKL2qJL2YZHCFj9VqmEx2SLGiw=;
        b=SpPhvC8TmWVrm6zy97d3BY/Umc8wwkcRv+Z3VVTSz207GNwayu2FANcUQYHsIJuaDVdhKk
        5pufUMsi22pR8hFCos6WSubruc88AghGZpSwYptVPZk8uhEQnOYJIr6mlDk3yI0Opvl9m0
        mH4hhuS53EDUEfSBkEvxufz1EFhHNsI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-_6jHJ399OXanytTzmoicVQ-1; Mon, 16 Oct 2023 11:20:00 -0400
X-MC-Unique: _6jHJ399OXanytTzmoicVQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9b95fa56bd5so324556466b.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697469599; x=1698074399;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEix8IoCjFYipbhyqgKL2qJL2YZHCFj9VqmEx2SLGiw=;
        b=rNE51lF2m1uegcQRe86SZFODHS4BRtKCdDs4yHg0qJkIn4pkO6kQWI3/e4mMGycdvL
         h4QVh1GC+ASv8Js4GRdPvYPP/t+BwIhhRjy9lyM46KJTs0uM7345RPuIV9/pjoHr6fOe
         lb657SpIro2OykzNAIkgKLXc+PY8aD9Fj90CILBX9msZ2GvOCu+JMVF7rWzSEmncQ+RO
         2RXApiRSUrurUtzyJTHG4c6nf57szigclq8QdFVdOKwB3fbAJXiiAGSbT4p7n/qUk8u1
         JOQ0fhU3hdodJGpU1cAN+OqGc9kb3WSqHfxNO6dlbHWfBDzeyfR2nhfsC0mvwGFbUvZI
         Umfw==
X-Gm-Message-State: AOJu0YygyQd5vA3KgCzSyvBELmXTmgRk1377eCJ6p/Exf0C57QxQmhgy
        gLtXQIRjcsIx54fW9GibM6P4ExoiekHxFi+1pIB92WKPg9cEr6JcyqLf1vAKuGpIUPHpq23AgoI
        Yru86IOqY2xG+
X-Received: by 2002:a17:906:2109:b0:9ba:65e:750e with SMTP id 9-20020a170906210900b009ba065e750emr20293556ejt.32.1697469598876;
        Mon, 16 Oct 2023 08:19:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEb9fPiHlPImABzViiZVbA7Y0gtuhzGOpmK/RHwaaH407PNB9TewIyWSMoP3jZFn9L9XkN9ig==
X-Received: by 2002:a17:906:2109:b0:9ba:65e:750e with SMTP id 9-20020a170906210900b009ba065e750emr20293542ejt.32.1697469598512;
        Mon, 16 Oct 2023 08:19:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z4-20020a1709064e0400b00982a352f078sm4274087eju.124.2023.10.16.08.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 08:19:57 -0700 (PDT)
Message-ID: <c46606c8-fb6d-4e81-843c-47a0443bebc1@redhat.com>
Date:   Mon, 16 Oct 2023 17:19:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <ZSQO4fHaAxDkbGyz@google.com> <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com> <20231009204037.GK800259@ZenIV>
 <ZSRwDItBbsn2IfWl@google.com> <20231010000910.GM800259@ZenIV>
 <ZSSaWPc5wjU9k1Kw@google.com> <20231010003746.GN800259@ZenIV>
 <ZSXeipdJcWZjLx8k@google.com>
 <7c4b1c78-de74-5fff-7327-0863f403eb7e@redhat.com>
 <ZSl2hdfF8XSXss3h@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZSl2hdfF8XSXss3h@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/23 18:55, Sean Christopherson wrote:
> On Wed, Oct 11, 2023, Paolo Bonzini wrote:
>> Your patch 2 looks good, but perhaps instead of setting the owner we could
>> stash the struct module* in a global, and try_get/put it from open and
>> release respectively?  That is, .owner keeps the kvm module alive and the
>> kvm module keeps kvm-intel/kvm-amd alive.  That would subsume patches 1 and 3.
> 
> I don't think that would be a net positive.  We'd have to implement .open() for
> several file types just to get a reference to the sub-module.  At that point, the
> odds of forgetting to implement .open() are about the same as forgetting to set
> .owner when adding a new file type, e.g. guest_memfd.

Fair enough, it's true that many fops don't have a .open callback already.

Paolo

