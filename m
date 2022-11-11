Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1554A625D8A
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 15:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiKKOxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 09:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbiKKOxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 09:53:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1335B5B9
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 06:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668178365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PXmRF2vssYN2uZDCe/oG8i2Xy9JC/kO7icx0j+fkicU=;
        b=IgIUDSjQ/nu42c7YFpv2SJ3Rd5Z/ha8tBv+tMeG8JSDawE7atN4mNI4zSuuMpHe2q0Ud4i
        Jo3fTn4Vb6dLjR9FtNHtSmrT1HIyQWed4cOx2BKkErf4HTCQ0Sr8y5/LMIVqr4+2vR5pQy
        vK/ON7Iy2VPUSVvj6vNfl40itIwpdV8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-F9oXdq4zOqCSog-JFuCk7g-1; Fri, 11 Nov 2022 09:52:44 -0500
X-MC-Unique: F9oXdq4zOqCSog-JFuCk7g-1
Received: by mail-qk1-f199.google.com with SMTP id bs7-20020a05620a470700b006fac7447b1cso4908613qkb.17
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 06:52:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXmRF2vssYN2uZDCe/oG8i2Xy9JC/kO7icx0j+fkicU=;
        b=DYUY626+Tm4mGEfsuFiw28AckkZ+adUDTr75VH0I9A2ShAfGIROtSiuiT1o5c/pdI7
         xgf+1eG5XnKRnDsqUsp6Nt7xgSdiN0eQBpr8+r2JjZOUhamO4LuVN9h2tFcskrz3L/zz
         4UZmWFiukUlEZUVSomiKAELKWxki9ZnbFi6fJlMxZbuyeQIkQBfz4A75aSpovPjJDux/
         WC2ZlftDbjPU2Gk0QQiZXL2o0JOFKskV0U8j6eUdhntxLm9B0lv87+VyNRmuRnm6Z2oH
         NxvpTHahGIp/2gSbgqVg/HGPYjWKTOd1MnbPZ5WZleDxURqVE6Fp8vJVZY73CNPjHCAD
         MiIA==
X-Gm-Message-State: ANoB5pnexwv9K0/pFgLNKSlFmLpvivtJbVx4+mULFnzM3Av6ITPbfLA7
        m7L/hTydbAb+LkZL71R6LZLeXIJiI1Leov8SmHgwKNpR5S4Gu29KFvVtQfsdPZDZTWuXPe7V0CA
        FxH3116iOBCi5
X-Received: by 2002:ac8:5381:0:b0:3a5:73b6:9184 with SMTP id x1-20020ac85381000000b003a573b69184mr1505831qtp.602.1668178363853;
        Fri, 11 Nov 2022 06:52:43 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5QigCdP9CghrmOkufDV8OpJdPpLWxlWaxsmnQd5QWj6cn2mT3kRDeUMF3Jpl/sSKgFieUkDA==
X-Received: by 2002:ac8:5381:0:b0:3a5:73b6:9184 with SMTP id x1-20020ac85381000000b003a573b69184mr1505809qtp.602.1668178363625;
        Fri, 11 Nov 2022 06:52:43 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bv11-20020a05622a0a0b00b00398ed306034sm1326667qtb.81.2022.11.11.06.52.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 06:52:42 -0800 (PST)
Message-ID: <9b727d28-7fa2-ccd0-73b7-d5a3de9fec47@redhat.com>
Date:   Fri, 11 Nov 2022 15:52:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/3] accel: introduce accelerator blocker API
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221110164807.1306076-1-eesposit@redhat.com>
 <20221110164807.1306076-2-eesposit@redhat.com>
 <9e6288e1-0c51-bd3f-5cee-c71049ffa684@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <9e6288e1-0c51-bd3f-5cee-c71049ffa684@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 11/11/2022 um 11:48 schrieb Paolo Bonzini:
> On 11/10/22 17:48, Emanuele Giuseppe Esposito wrote:
>> +/*
>> + * QEMU accel blocker class
> 
> "Lock to inhibit accelerator ioctls"
> 
>> + *
>> + * Copyright (c) 2014 Red Hat Inc.
> 
> 2022, you can also add an Author line.
> 
>> +static int accel_in_ioctls(void)
> 
> Return bool (and return early if ret becomes true).
> 
>> +void accel_ioctl_inhibit_begin(void)
>> +{
>> +    CPUState *cpu;
>> +
>> +    /*
>> +     * We allow to inhibit only when holding the BQL, so we can identify
>> +     * when an inhibitor wants to issue an ioctl easily.
>> +     */
>> +    g_assert(qemu_mutex_iothread_locked());
>> +
>> +    /* Block further invocations of the ioctls outside the BQL.  */
>> +    CPU_FOREACH(cpu) {
>> +        qemu_lockcnt_lock(&cpu->in_ioctl_lock);
>> +    }
>> +    qemu_lockcnt_lock(&accel_in_ioctl_lock);
>> +
>> +    /* Keep waiting until there are running ioctls */
>> +    while (accel_in_ioctls()) {
>> +        /* Reset event to FREE. */
>> +        qemu_event_reset(&accel_in_ioctl_event);
>> +
>> +        if (accel_in_ioctls()) {
>> +
>> +            CPU_FOREACH(cpu) {
>> +                /* exit the ioctl */
>> +                qemu_cpu_kick(cpu);
> 
> Only kick if the lockcnt count is > 0? (this is not racy; if it is == 0,
> it cannot ever become > 0 again while the lock is taken)

Better:

accel_has_to_wait(void)
{
    CPUState *cpu;
    bool needs_to_wait = false;

    CPU_FOREACH(cpu) {
        if (qemu_lockcnt_count(&cpu->in_ioctl_lock)) {
            qemu_cpu_kick(cpu);
            needs_to_wait = true;
        }
    }

    return needs_to_wait || qemu_lockcnt_count(&accel_in_ioctl_lock);
}

And then the loop becomes:

while (true) {
        qemu_event_reset(&accel_in_ioctl_event);

        if (accel_has_to_wait()) {
            qemu_event_wait(&accel_in_ioctl_event);
        } else {
            /* No ioctl is running */
            return;
        }
}

> 
>> diff --git a/include/sysemu/accel-blocker.h
>> b/include/sysemu/accel-blocker.h
>> new file mode 100644
>> index 0000000000..135ebea566
>> --- /dev/null
>> +++ b/include/sysemu/accel-blocker.h
>> @@ -0,0 +1,45 @@
>> +/*
>> + * Accelerator blocking API, to prevent new ioctls from starting and
>> wait the
>> + * running ones finish.
>> + * This mechanism differs from pause/resume_all_vcpus() in that it
>> does not
>> + * release the BQL.
>> + *
>> + *  Copyright (c) 2014 Red Hat Inc.
> 
> 2022, you can also add an Author line here too.
> 
>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>> later.
>> + * See the COPYING file in the top-level directory.
>> + */
>> +#ifndef ACCEL_BLOCKER_H
>> +#define ACCEL_BLOCKER_H
>> +
>> +#include "qemu/osdep.h"
>> +#include "qemu/accel.h"
> 
> qemu/accel.h not needed?
> 
>> +#include "sysemu/cpus.h"
>> +
>> +extern void accel_blocker_init(void);
>> +
>> +/*
>> + * accel_set_in_ioctl/accel_cpu_set_in_ioctl:
>> + * Mark when ioctl is about to run or just finished.
>> + * If @in_ioctl is true, then mark it is beginning. Otherwise marks
>> that it is
>> + * ending.
>> + *
>> + * These functions will block after accel_ioctl_inhibit_begin() is
>> called,
>> + * preventing new ioctls to run. They will continue only after
>> + * accel_ioctl_inibith_end().
>> + */
>> +extern void accel_set_in_ioctl(bool in_ioctl);
>> +extern void accel_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl);
> 
> Why not just
> 
> extern void accel_ioctl_begin(void);
> extern void accel_ioctl_end(void);
> extern void accel_cpu_ioctl_begin(CPUState *cpu);
> extern void accel_cpu_ioctl_end(CPUState *cpu);
> 
> ?

Ok, makes sense.

Thank you,
Emanuele

> 
> Otherwise it's very nice.
> 
> Paolo
> 

