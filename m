Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2177ABF3F
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjIWJZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 05:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjIWJZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 05:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C88AC2
        for <kvm@vger.kernel.org>; Sat, 23 Sep 2023 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695461090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXH/z9I2U5yZm4eO+7VtM4L0zfP0q4sZwQaS4eYQojo=;
        b=YfYJ0J33R3lrDzQQWB7G9vjDWW1BmJ33tKrKvE3qh0nT5M3RMovYtY7eZHPIw5m0auH3zH
        jvSkDGytfHtDi7nKuyPYIN2Qx0UUIHmnVE61CWyissMISOLNCuacWUqLU1AZVg9lYbhkRN
        QiNOOu1GyV1bb2U4cZKd09zfdxwBwzk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-q4zAL0yCO1yxUJ-_9A5ybg-1; Sat, 23 Sep 2023 05:24:49 -0400
X-MC-Unique: q4zAL0yCO1yxUJ-_9A5ybg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40469bcd1eeso27092455e9.2
        for <kvm@vger.kernel.org>; Sat, 23 Sep 2023 02:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695461087; x=1696065887;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nXH/z9I2U5yZm4eO+7VtM4L0zfP0q4sZwQaS4eYQojo=;
        b=rotv4k3b3LrE0nkzW75nYnO/BFamsppQHCJhhpGJ9ipHmcDkiKWlRcbhZsHEhynwE7
         oJ77oUo907ba/TQdCICC/4B+fljl9qKUeKLs77LQpxOgGvGb9va8amvu2MnuQ+VBJP3U
         qtfm69IWg4N/uDabr+o3UR6V1RwUXOGJFVGpWNHPK7CMBzYnd4TEt05ORndSI7Fg9KhE
         UpBqGhlNFqXRTW93DF+o/Y3OqzVwrrrwOWIXKNV4LLekM2n9vCy6exexKxc302bhWyQB
         Xw/qLYhJnxNl/PSW271Id7yVR0QydhGU0TxetffWgFsuDfwz/WHluhmX7M6n2QjvWbVo
         /VBA==
X-Gm-Message-State: AOJu0YzL3nAevLaZvIZOl0N3V9fwAs4Oz+wV1+8s5hITBWEBmCqjsYh6
        fibX7shz+V3xtBgRxBabkQboybEX9iVBql2M4j9kjtQgujkBsp90eKRa9Qh1NqwG5B9zFJktiFL
        x0NRjN2gbxGmeE4b2rRyd
X-Received: by 2002:a7b:ce10:0:b0:3ff:28b8:c53d with SMTP id m16-20020a7bce10000000b003ff28b8c53dmr1324584wmc.33.1695461087300;
        Sat, 23 Sep 2023 02:24:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzWAQVkjvFxUa3O8HwBx+l+WmSWzKfVnpxt/9gjJpYJRF2Cxuv42ygz201/3oojgDSFFucSA==
X-Received: by 2002:a7b:ce10:0:b0:3ff:28b8:c53d with SMTP id m16-20020a7bce10000000b003ff28b8c53dmr1324570wmc.33.1695461086985;
        Sat, 23 Sep 2023 02:24:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id n11-20020adffe0b000000b0031c3ee933b5sm6445672wrr.108.2023.09.23.02.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Sep 2023 02:24:46 -0700 (PDT)
Message-ID: <3dc66987-49c7-abda-eb70-1898181ef3fe@redhat.com>
Date:   Sat, 23 Sep 2023 11:24:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        graf@amazon.de, Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Griffoul, Fred" <fgriffo@amazon.com>
References: <1b52b557beb6606007f7ec5672eab0adf1606a34.camel@infradead.org>
 <CABgObfZgYXaXqP=6s53=+mYWvOnbgYJiCRct-0ob444sK9SvGw@mail.gmail.com>
 <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] KVM: x86: Allow userspace exit on HLT and MWAIT, else yield
 on MWAIT
In-Reply-To: <faec494b6df5ebee5644017c9415e747bd34952b.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/23 09:22, David Woodhouse wrote:
> On Fri, 2023-09-22 at 14:00 +0200, Paolo Bonzini wrote:
>> To avoid races you need two flags though; there needs to be also a
>> kernel->userspace communication of whether the vCPU is currently in
>> HLT or MWAIT, using the "flags" field for example. If it was HLT only,
>> moving the mp_state in kvm_run would seem like a good idea; but not if
>> MWAIT or PAUSE are also included.
> 
> Right. When work is added to an empty workqueue, the VMM will want to
> hunt for a vCPU which is currently idle and then signal it to exit.
> 
> As you say, for HLT it's simple enough to look at the mp_state, and we
> can move that into kvm_run so it doesn't need an ioctl...

Looking at it again: not so easy because the mpstate is changed in the 
vCPU thread by vcpu_block() itself.

> although it
> would also be nice to get an *event* on an eventfd when the vCPU
> becomes runnable (as noted, we want that for VSM anyway). Or perhaps
> even to be able to poll() on the vCPU fd.

Why do you need it?  You can just use KVM_RUN to go to sleep, and if you 
get another job you kick out the vCPU with pthread_kill.  (I also didn't 
get the VSM reference).

An interesting quirk is that kvm_run->immediate_exit is processed before 
kvm_vcpu_block(), but TIF_SIGPENDING is processed afterwards.  This 
means that you can force an mpstate update with pthread_kill + KVM_RUN. 
It's not going to be a speed demon, but it's worth writing a selftest 
for it.

> But MWAIT (as currently not-really-emulated) and PAUSE are both just
> transient states with nothing you can really *wait* for, which is why
> they're such fun to deal with.

PAUSE is easier because it is just momentary and you stick it inside 
what's already a busy wait.  MWAIT is less fun because you don't really 
want to busy wait.

Paolo

