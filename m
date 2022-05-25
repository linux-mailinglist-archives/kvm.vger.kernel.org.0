Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6304533794
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 09:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbiEYHol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 03:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiEYHok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 03:44:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1167E40A28
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653464678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjkxpIMm89SC2WnmaqJiSzzHACdhZrPtwGazc1RItnc=;
        b=U336WAXvGmgcifZ4a4wC3eNDPidyGDANVnF0QujJc3Kqg5KyR+G5WuOiOEgcpGSFoJl/c0
        gc9Vtl19noniLwxl5PiLgqgzdQNt8vL23X3mWqfx6jtsZbZpoYBzVhWc2G77uJCiWW9JbD
        AJ7jJqh+JQsCquE8mQNfn+N9g1/Fux4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-VuZG98gZNjyTHbkTaT0kwQ-1; Wed, 25 May 2022 03:44:36 -0400
X-MC-Unique: VuZG98gZNjyTHbkTaT0kwQ-1
Received: by mail-wm1-f71.google.com with SMTP id v126-20020a1cac84000000b00396fe5959d2so8014690wme.8
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 00:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IjkxpIMm89SC2WnmaqJiSzzHACdhZrPtwGazc1RItnc=;
        b=CC0yosEhezrJ4HmRiSDwPOC5O+9IUuE3ftx8j4Cl7/qu5oiSpng1osqQD2zfzbg4D6
         FQioFOzK27Xf0nWZbLqH5Ci7/efiAGNpFavDpZM0cuhpQwhxw821PVUth6xH9dA0kEwN
         EYoiCiuK7RC7r2hvO3F0b9VJQxGqlIGTBKJ3GKUccCF7oGzYkWlXWvT6/gXNHXDjJctr
         K0od+02YQn82yJ6y/Yx9/eNLk5GCVZM6VcDfAoRbHnjurZJro9BL+sN4QrjhM2g/caef
         5l8Rj1S0KwIKn1PZUwafvXbHvQuq1UWI6Av5G4RXm5N6Mh+wq1OISNN9wXaaVtuqXaU1
         +ASA==
X-Gm-Message-State: AOAM531bfq8Pw8Rd31PM9q/n9+xszWqGR5qAVFXkzNQVlRrvgdrqMhQO
        +aPRLoE2OOXAXeo86TtbZiayqg8r7NhQwSAjc5uN7upw0FW7G1lQed8Q9E+Q5UcP5QesmjaImky
        6gt8R8lpVyjYJ
X-Received: by 2002:a7b:c2a9:0:b0:397:9a4:f66b with SMTP id c9-20020a7bc2a9000000b0039709a4f66bmr6940940wmk.128.1653464675603;
        Wed, 25 May 2022 00:44:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzpAHi9Eu+hdTkDtsM1RPcoGYUz94H2oHpdQWh2R1ZlSNJqbKZ2qh+KdmhLbVWpzYyL0z14mw==
X-Received: by 2002:a7b:c2a9:0:b0:397:9a4:f66b with SMTP id c9-20020a7bc2a9000000b0039709a4f66bmr6940926wmk.128.1653464675300;
        Wed, 25 May 2022 00:44:35 -0700 (PDT)
Received: from [192.168.0.2] (ip-109-43-179-69.web.vodafone.de. [109.43.179.69])
        by smtp.gmail.com with ESMTPSA id o30-20020a05600c511e00b003942a244f54sm1038040wms.45.2022.05.25.00.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 00:44:34 -0700 (PDT)
Message-ID: <3cbdf951-513a-7527-ece6-6f2593fbc94e@redhat.com>
Date:   Wed, 25 May 2022 09:44:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
Content-Language: en-US
To:     Dan Cross <cross@oxidecomputer.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
References: <Yn2ErGvi4XKJuQjI@google.com>
 <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com>
 <CAA9fzEEjU9y7HdNOkWTjEtxPDNxTh_PDBWoREGKW2Y2aarZXbw@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <CAA9fzEEjU9y7HdNOkWTjEtxPDNxTh_PDBWoREGKW2Y2aarZXbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/2022 23.22, Dan Cross wrote:
> On Fri, May 13, 2022 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
...
>>> diff --git a/configure b/configure
>>> index 86c3095..7193811 100755
>>> --- a/configure
>>> +++ b/configure
>>> @@ -15,6 +15,7 @@ objdump=objdump
>>>   ar=ar
>>>   addr2line=addr2line
>>>   arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>>> +os=$(uname -s)
>>>   host=$arch
>>>   cross_prefix=
>>>   endian=""
>>> @@ -317,9 +318,9 @@ EOF
>>>     rm -f lib-test.{o,S}
>>>   fi
>>>
>>> -# require enhanced getopt
>>> +# require enhanced getopt everywhere except illumos
>>>   getopt -T > /dev/null
>>> -if [ $? -ne 4 ]; then
>>> +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
>>
>> What does illumos return for `getopt -T`?
> 
> Sadly, it returns "0".  I was wrong in my earlier explorations
> because I did not realize that `configure` does not use `getopt`
> aside from that one check, which is repeated in `run_tests.sh`.
> 
> I would argue that the most straight-forward way to deal with
> this is to just remove the check for "getopt" from "configure",
> which doesn't otherwise use "getopt".  The only place it is
> used is in `run_tests.sh`, which is unlikely to be used directly
> for illumos, and repeats the check anyway.

Fine for me if we remove the check from configure, or turn it into a warning 
instead ("Enhanced getopt is not available, you won't be able to use the 
run_tests.sh script" or so).

  Thomas

