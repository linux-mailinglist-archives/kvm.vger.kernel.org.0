Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E225EFB3F
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 18:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235996AbiI2Qrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiI2Qrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 12:47:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BFC1CD126
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664470067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rgklLOMQL7VylspPk97tlA/0goi9ks/sFgXajXuL5kw=;
        b=gUAm0IMntmhq2AyVncbBwSz1EZwM8O+zP9BJOWtp268SUtfo7J+bYfoKwM0iN2he+djW3Y
        wYoagebQy3xqhOMaftuUmTZO9UdqLKQnca2UwVQt2k9j20VXWiZ3LtPrpWyPgsBh7qDd27
        UnEPFKmwAgoc1pBqhkkEL+JJk9XlBFs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-371-JFSwSe1kPva60X1PB8GwPw-1; Thu, 29 Sep 2022 12:47:45 -0400
X-MC-Unique: JFSwSe1kPva60X1PB8GwPw-1
Received: by mail-ed1-f72.google.com with SMTP id y9-20020a056402270900b00451dfbbc9b2so1678983edd.12
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 09:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rgklLOMQL7VylspPk97tlA/0goi9ks/sFgXajXuL5kw=;
        b=O9tFxJbXDYhPr6Q10ICcdw/VndgbylxFfPYjWGTGMXOZcjYNz6S8+5GiNeDXpVfLZB
         19pwkwZip7hzoQH8HvgFf+VDqgNoBUexUIE5W828cC/UTFvWdjmkp5U8toY1KvrtcYBG
         6csxl6z+Ystt0gtvR6SNK0r/LxEzNsOpwwFcI7d0j1OQ4kZ5byygb1i9IMW6pWqMu6V9
         eZ8PuFejeDZ7kwQPnPS7c8UlrZ03oVdH70HIMYIpDpm3UXOkAmBvrjzjbCGJq8lQ9R+B
         yk0uSI17iC5dH/cW6/XoEBWLRh5Bvzzi8vlo8y4kytMC5cbvw0avFopYLAWZTZJE7DKx
         zl4w==
X-Gm-Message-State: ACrzQf0V8M5KulXT04mxLWeQqRWRvpwwRKFL55ABM3WkwV8mCzLIDtVl
        sTfZ8HWx9KxyZU2SfVETWcnqIbG/spNXP71Gf75IyPbuE7up/JVHgxqcIBSDgMrbk5j2KK1ivje
        9m/XJ0g7RAR6E
X-Received: by 2002:a05:6402:4503:b0:457:e6ac:9785 with SMTP id ez3-20020a056402450300b00457e6ac9785mr4140533edb.416.1664470063958;
        Thu, 29 Sep 2022 09:47:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63x3Fm95ysSCPsE9mdlZJVkjgIEF+Cn7dlN/X1FIKx3EnPya7MLzCiw7Rs+pmWclzNSsm2ow==
X-Received: by 2002:a05:6402:4503:b0:457:e6ac:9785 with SMTP id ez3-20020a056402450300b00457e6ac9785mr4140520edb.416.1664470063686;
        Thu, 29 Sep 2022 09:47:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id b18-20020a17090630d200b00780982d77d1sm4174040ejb.154.2022.09.29.09.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 09:47:43 -0700 (PDT)
Message-ID: <56a125ab-f113-56f7-f8cb-de05127c92b7@redhat.com>
Date:   Thu, 29 Sep 2022 18:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: allow compiling out SMM support
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220927152241.194900-1-pbonzini@redhat.com>
 <bd4d7463-a960-3c49-9c56-a8bd5c1ea7f0@maciej.szmigiero.name>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <bd4d7463-a960-3c49-9c56-a8bd5c1ea7f0@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/29/22 17:49, Maciej S. Szmigiero wrote:
> On 27.09.2022 17:22, Paolo Bonzini wrote:
>> Some users of KVM implement the UEFI variable store through a 
>> paravirtual device
>> that does not require the "SMM lockbox" component of edk2; allow them to
>> compile out system management mode, which is not a full implementation
>> especially in how it interacts with nested virtualization.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>     The patch isn't pretty.  I could skip all the changes to add WARNs
>>     to called functions, but the point of adding the config symbol is
>>     to make sure that those functions, and all the baggage they bring,
>>     are dead.
> 
> Out of curiosity: why the SMM support is so special that it's worth to
> add a dedicated Kconfig entry for it?

Yeah, that's a good point.  In general the module parameters either:

1) change between two behaviors (e.g. tdp_mmu) or

2) can be toggled at runtime or

3) disable _hardware_ features

The two Kconfig entries for SMM and XEN are more for things that you 
want to remove to reduce attack surface than for testing.

> Looking at the patch it doesn't seem to disable that much of code (like,
> significantly slim down the binary) and where it does disable something
> it mostly relies on compiler dead code removal rather than explicit
> #ifdefs (which would guarantee that the disabled code did not end in
> the binary).

Yeah, v2 will actually remove much more.

Paolo

