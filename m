Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4049C760379
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 02:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjGYACG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 20:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjGYACF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 20:02:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAF81736
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 17:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690243273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGMLgvPQ9oVQ5a58eOnstHWba90xgOfCvkrBdng9LSo=;
        b=Lb+8gCY96SQNpmSqMByCLLeyO34+uJbrzQB5Fb/Iw94FYLjIyGPorX1fEl8eNsCn5NmWkA
        2WIHlCXw0DLqfovkLs3J+Ta5yJEWGEgYFjVBzUh0Y9gcYMxJlrqsSvPpcY2XGaJoBLdixm
        2AB26YHeU8hY5uAYC/SQb+IzIHU9IFc=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-z9IRRkYYOcKN7TrKgqtNrw-1; Mon, 24 Jul 2023 20:01:11 -0400
X-MC-Unique: z9IRRkYYOcKN7TrKgqtNrw-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3a3c76a8accso10517684b6e.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 17:01:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690243270; x=1690848070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AGMLgvPQ9oVQ5a58eOnstHWba90xgOfCvkrBdng9LSo=;
        b=T/qUXCk6/iZR7Y3wBVSSRI3QLOncoFhLap9vpoIiG2oLz9xbpUwP8tndid+R7anOEO
         u91XW3SJMApk09okDQgl90xWuyiBPKPmyudQNqnIAPHExFANzfd5wOl0kotPv0ZVFV1r
         oIYo7oKgYzPsu68z06bQhgFSsQMN/c0J8+ucbSfofTjNu0xLtLrKOjF2V6ONk428N6kI
         ILmo5cbqXfMDKP+ptg60O825zzk1q4qgZsORQkzdj6PgNesBPWq5D9Jnvs/GBwKsjphN
         Z/G8kaNyDx4J/Qdi4Uac3o2FVdUYK4LRbV0yhLDocXtpeel5AcFiTMqhUyuQFqoPXazW
         3grw==
X-Gm-Message-State: ABy/qLZWR3j8r6e2ZOM9rHKc7JAY4I+UX01Ms4uVWKmOig8WAqoOvpg9
        HrGh24736Ri6A8i/9W4ftrPmUSgftM8iaQLXyD+g5Gh0NOhntEA3of9ObFrn8SQWwHXDEdQDWzI
        Ncuzsh3F9mclS
X-Received: by 2002:a05:6808:1818:b0:3a5:afdf:8ebb with SMTP id bh24-20020a056808181800b003a5afdf8ebbmr6830757oib.17.1690243270257;
        Mon, 24 Jul 2023 17:01:10 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFu3NnsE3XLXcJopkwLRAi4e/BTrUxK7AmsrBhX79A1EvKKi/DteHzm3DR+T9FjEBnI40I8kw==
X-Received: by 2002:a05:6808:1818:b0:3a5:afdf:8ebb with SMTP id bh24-20020a056808181800b003a5afdf8ebbmr6830750oib.17.1690243270053;
        Mon, 24 Jul 2023 17:01:10 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709029b8700b001b89045ff03sm9565456plp.233.2023.07.24.17.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 17:01:09 -0700 (PDT)
Message-ID: <4a990b57-800c-6799-8c23-4488069ffb76@redhat.com>
Date:   Tue, 25 Jul 2023 10:01:04 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH for-8.2 2/2] arm/kvm: convert to kvm_get_one_reg
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-3-cohuck@redhat.com>
 <db578c20-22d9-3b76-63e7-d99b891f6d36@redhat.com> <878rb5g0f0.fsf@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <878rb5g0f0.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/24/23 18:48, Cornelia Huck wrote:
> On Mon, Jul 24 2023, Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 7/18/23 21:14, Cornelia Huck wrote:
>>> We can neaten the code by switching the callers that work on a
>>> CPUstate to the kvm_get_one_reg function.
>>>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>    target/arm/kvm.c   | 15 +++---------
>>>    target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>>>    2 files changed, 18 insertions(+), 54 deletions(-)
>>>
>>
>> The replacements look good to me. However, I guess it's worty to apply
>> the same replacements for target/arm/kvm64.c since we're here?
>>
>> [gshan@gshan arm]$ pwd
>> /home/gshan/sandbox/q/target/arm
>> [gshan@gshan arm]$ git grep KVM_GET_ONE_REG
>> kvm64.c:    err = ioctl(fd, KVM_GET_ONE_REG, &idreg);
>> kvm64.c:    return ioctl(fd, KVM_GET_ONE_REG, &idreg);
>> kvm64.c:        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
> 
> These are the callers that don't work on a CPUState (all in initial
> feature discovery IIRC), so they need to stay that way.
> 

Right, All these ioctl commands are issued when CPUState isn't around. However, there
are two wrappers read_sys_{reg32, reg64}(). The ioctl call in kvm_arm_sve_get_vls()
can be replaced by read_sys_reg64(). I guess it'd better to do this in a separate
patch if you agree.

Thanks,
Gavin

