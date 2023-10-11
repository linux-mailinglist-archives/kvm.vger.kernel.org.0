Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31CE7C5AA9
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbjJKR6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbjJKR63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D980A9
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697047061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7j5XITIXrvvxgZyR1Yp67hNUsMKkfoy7Ri4I+RKHjI=;
        b=NjCgWiK4zRP0YU7fmgvx3APcGVa44+9WMuvfaAIbQ0XGX38FPhhZ98PE1zg5WOWrN2mhV4
        B3YONyeGvK6KVkDtTqgiyHpeY4g2jLTr/tInS/kJuwiYO4jEd+e/4Z1sTy/35wmO28QWW4
        Sh0TGvq1G7je2VwvRkGqlEpBuh4hBQI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-EP3KGtCIMfetoGav5UXU5Q-1; Wed, 11 Oct 2023 13:57:39 -0400
X-MC-Unique: EP3KGtCIMfetoGav5UXU5Q-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9b65b6bcfb7so4834766b.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697047059; x=1697651859;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7j5XITIXrvvxgZyR1Yp67hNUsMKkfoy7Ri4I+RKHjI=;
        b=NKEe6HvxZGT1kpOJsPtq7c6cOMe61FCRW2AbHrc5F+yAILZAqekDJvSv8/uOZqmUFY
         W4TTxzDdVTCUT5faOZ6egymGm8jwYC9/GfvQac/DQ9oO/in4+FXlVSm7JEtlcIWX7Rtf
         eYU/WMJPguhEpY/NJCxNmq4Yiez1Y4bIi8FUZng3P0JoU4wQIqV2j5A/GZTRwqa7yIhx
         IlY8y4LOhpqF8DoaBdRJPXBHqnYeSbFyJuKE2zvjNlZbnhk7pTtLDhEIpAcUrYbGW3s9
         etQMfpWdF2Bgr7Q1ScD+GBLaEMZT+S8vnqhRi+ZKnke4Vbh+hlnfmbzCy0Cl7L9ZUhRk
         H9oA==
X-Gm-Message-State: AOJu0Yw9Pk3dBd19/6V9RgeazsuvmhL7MkIQRyJXxqwVBdzXEsy+9cQi
        ILo1/1HJxe0xTo575zGycbJTeUvVD5zwzRf+IqdqH5XJP3ffVus3tWXrk9ThAxuk5obevUxNpmb
        NTOVqiMGkYrFp
X-Received: by 2002:aa7:da44:0:b0:532:aaca:d39d with SMTP id w4-20020aa7da44000000b00532aacad39dmr18583279eds.6.1697047058749;
        Wed, 11 Oct 2023 10:57:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuUvWbyCMfuD4kRBEJDo03ovo4IRPhoUpjQbapRDtBBQYmkxWQikNgw8Zeu1AqU//bOOU0iQ==
X-Received: by 2002:aa7:da44:0:b0:532:aaca:d39d with SMTP id w4-20020aa7da44000000b00532aacad39dmr18583271eds.6.1697047058456;
        Wed, 11 Oct 2023 10:57:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id d13-20020a056402400d00b0053def18ee8bsm578952eda.20.2023.10.11.10.57.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Oct 2023 10:57:37 -0700 (PDT)
Message-ID: <7c4b1c78-de74-5fff-7327-0863f403eb7e@redhat.com>
Date:   Wed, 11 Oct 2023 19:57:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <169595365500.1386813.6579237770749312873.b4-ty@google.com>
 <20231009022248.GD800259@ZenIV> <ZSQO4fHaAxDkbGyz@google.com>
 <20231009200608.GJ800259@ZenIV> <ZSRgdgQe3fseEQpf@google.com>
 <20231009204037.GK800259@ZenIV> <ZSRwDItBbsn2IfWl@google.com>
 <20231010000910.GM800259@ZenIV> <ZSSaWPc5wjU9k1Kw@google.com>
 <20231010003746.GN800259@ZenIV> <ZSXeipdJcWZjLx8k@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
In-Reply-To: <ZSXeipdJcWZjLx8k@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/23 01:30, Sean Christopherson wrote:
>> E.g. drivers/block/loop.c has this gem
>> 
>> 	/* This is safe: open() is still holding a reference. */
>> 	module_put(THIS_MODULE);
> 
> in __loop_clr_fd(), which is invoked from a .release() function.  So open() quite
> clearly doesn't hold a reference, unless the comment is talking about the reference
> that was obtained by the core file systems layer and won't be put until after
> .release() completes.  But then what on earth is the point of doing
> module_get(THIS_MODULE) and module_put(THIS_MODULE)?

Here the module_put() is called not just from .release() in autoclear 
mode, but also from the LOOP_CLR_FD ioctl.

So the idea here is that while a /dev/loopN device exists you must keep 
the module alive, to ensure that the devices don't disappear from /dev. 
So the point here is to keep the module alive after /dev/loop-control 
has been closed; but if /dev/loopN is open it will keep the module alive 
on its own, and this makes module_get/module_put safe in this particular 
case.

In general, safety is guaranteed if module_put is called while the 
module's reference count is still elevated by someone else, which could 
be a file descriptor or some core subsystem.  But then you're right that 
in many case there seems to be no point in doing module_get/module_put. 
In drivers/watchdog/softdog.c, softdog_stop() is called while the 
module's reference count is still elevated by the core watchdog code, 
which makes the code safe.  But why does softdog.c need to have its own 
reference?  Any attempt to unregister the softdog module will go through 
hrtimer_cancel(&softdog_ticktock) - which waits for the timer callback 
to be complete, just like flush_work() in your patch.

This module_get/module_put _is_ unnecessary.  It was introduced as a 
bandaid in commit 5889f06bd31d ("watchdog: refuse to unload softdog 
module when its timer is running", 2015-12-27).  Back then the core code 
wasn't careful to keep the module refcount elevated if the watchdog was 
still running in watchdog_release.  When commit ee142889e32f ("watchdog: 
Introduce WDOG_HW_RUNNING flag", 2016-03-16) fixed the race for real, 
softdog.c wasn't adjusted.

I agree that in many cases, however, the safety does not seem to be 
there.  I cannot find a place that ensures that snd-aoa-soundbus-i2sbus 
is kept alive while i2sbus_private_free runs, for example (though that 
code is a maze).

Your patch 2 looks good, but perhaps instead of setting the owner we 
could stash the struct module* in a global, and try_get/put it from open 
and release respectively?  That is, .owner keeps the kvm module alive 
and the kvm module keeps kvm-intel/kvm-amd alive.  That would subsume 
patches 1 and 3.

Paolo

