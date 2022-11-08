Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C59621952
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiKHQ0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 11:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiKHQ0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 11:26:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398711FF92
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 08:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667924741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jQy74ZlfgTAGdlikZL4pyUPBXZ8/ebOOwzW3CX4iwk=;
        b=YMFtIxavRISVyaWvagEdaK0sG8RXtwk8352bLolj9MCsV9rGEPPSlU08A6sq2YsZnYBjHX
        4EQFspiufX65jF5fqNBB4jUvBt/u/cPpyHnIYQOzUJqZDgB6GvARNJwJSXlI5ztM/g9/KL
        sxqHQD7drQWQmTYmNWgB2aKUA4XlKnc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-3uOVuMZnOyWO6o4dVkg0ag-1; Tue, 08 Nov 2022 11:25:39 -0500
X-MC-Unique: 3uOVuMZnOyWO6o4dVkg0ag-1
Received: by mail-wm1-f70.google.com with SMTP id c10-20020a7bc84a000000b003cf81c2d3efso4037210wml.7
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 08:25:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4jQy74ZlfgTAGdlikZL4pyUPBXZ8/ebOOwzW3CX4iwk=;
        b=l9rFScgsAiGTP9lRi0AyuMsJuc25ineq59RXhi6OPXP7DOStnN2XqQ3jeODxZlFADc
         9U8nYWI1n9pnFLRASHFpFrUZsXSQ7ypnLGf2keKyqRIErZBrYJHM9GZhtepj1hyCGzux
         IqmaP0AvRb4Mo4eraE/l1sT1/3KjU1JMf0snRBBdD7xf6/Z9j7Atj2UuRAPKByZx7Ygn
         qkXm5psgsALQl0BlFWMzqr8zSNyS/D4Ty7FpyQ2NHFZClXskhHeEv6/SAdHV0lkbrmRJ
         TOSJ8NBmLLBoZYNHrdV5h+J9wcHMYpTiXv/7p9v3K60qsoI4bIW5+1UrAXKoxLvVfZ9c
         gPHg==
X-Gm-Message-State: ACrzQf09jCq8wLWEjnvKcstcTZ799oQTRo13saMYJlOlF3gukM33vbKu
        3f9jThmn8xLUNH8pv2vVg73q0vXldlXNduG4IslHIjisNMIDleYC2ACZLOwlCmQ4nhD+/VgV7Qm
        PDCcZ/P02YRub
X-Received: by 2002:a05:600c:1c1e:b0:3c6:fa3c:32a9 with SMTP id j30-20020a05600c1c1e00b003c6fa3c32a9mr47405725wms.203.1667924738607;
        Tue, 08 Nov 2022 08:25:38 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4wN1CbSK2UwZVMADUtaPh0RFDoA7/DTsc453ktjQjnO9KW8VMErardGfZu4ufvb8J3cKZZ+Q==
X-Received: by 2002:a05:600c:1c1e:b0:3c6:fa3c:32a9 with SMTP id j30-20020a05600c1c1e00b003c6fa3c32a9mr47405704wms.203.1667924738384;
        Tue, 08 Nov 2022 08:25:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05600c351300b003b4ff30e566sm34421532wmq.3.2022.11.08.08.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 08:25:37 -0800 (PST)
Message-ID: <8e3bd959-bf0b-9104-2ca2-b745c0d9ff48@redhat.com>
Date:   Tue, 8 Nov 2022 17:25:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 3/3] kvm: Atomic memslot updates
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221104151454.136551-1-eesposit@redhat.com>
 <20221104151454.136551-4-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221104151454.136551-4-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/22 16:14, Emanuele Giuseppe Esposito wrote:
> +    g_assert(qemu_mutex_iothread_locked());

Please add a comment here:

     /* Block further invocations of the ioctls outside the BQL.  */

> +    CPU_FOREACH(cpu) {
> +        qemu_lockcnt_lock(&cpu->in_ioctl_lock);
> +    }
> +    qemu_lockcnt_lock(&kvm_in_ioctl_lock);
>   
> -    kvm_set_phys_mem(kml, section, false);
> -    memory_region_unref(section->mr);
> +    /* Inhibiting happens rarely, we can keep things simple and spin here. */

Not making it spin is pretty easy.  You can add a qemu_event_set to 
kvm_set_in_ioctl() and kvm_cpu_set_in_ioctl(), and here something like:

     if (in_kvm_ioctls()) {
         qemu_event_reset(&kvm_in_ioctl_event);
         if (in_kvm_ioctls()) {
             qemu_event_wait(&kvm_in_ioctl_event);
         }
     }

where in_kvm_ioctls() returns true if any (vCPU or KVM) lockcnt has a 
nonzero count.

Also please create a new header sysemu/accel-blocker.h and 
accel/blocker.c or something like that with all the functions, because 
this code can potentially be used by all KVM-like accelerators.

Paolo

