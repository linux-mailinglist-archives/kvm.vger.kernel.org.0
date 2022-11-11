Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5836258AD
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiKKKtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiKKKta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:49:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492845F94
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 02:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668163711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xZXYzX//SCthjxfoxPXs7VbypzGHRDY565s7tRX7fI=;
        b=IyPV51sg6cpPms1II6zA8Zwz14fJg+xDklH1al44QL04iqYn4+1vPUliG2UeehEpz475nL
        M3Qa07e6cWAEq4GRgSL6e70NOxl7f9Hcq7EkhhvgBqp0FMcMeljPcFDjyPIvh51zPcFjsC
        MjKnubo3jx2DDq6/zS4yXMNr64ef+FE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-h75uTowROKGMIdw3v4T0vw-1; Fri, 11 Nov 2022 05:48:30 -0500
X-MC-Unique: h75uTowROKGMIdw3v4T0vw-1
Received: by mail-wr1-f69.google.com with SMTP id v14-20020adf8b4e000000b0024174021277so127581wra.13
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 02:48:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4xZXYzX//SCthjxfoxPXs7VbypzGHRDY565s7tRX7fI=;
        b=2UggJz6xcK4nAgOrQPwacxY+rgPJH/JwlYsglIEXthULfw6NdheW8vf1M6PMqW2qsh
         Zz1UYSj6SE94bc6I/wke0OP9gzEVlny6QxumIAyWAmGvWqAAWIFBQyuccdfx3QovUtPp
         40FivMSbFhBNqLdcypYdwOIhvz7kdyWiPa+8ZJaRfezbSeQp1D4I+pM4MF0rrxt1UtY+
         FSzIn4AnRDWlBD61RZQFGI030L1ZsC72clYdgBzlUO+pKaw7xrSt4h9lIIqODq/LAN7N
         KTj5a/qDiKiNroT9FSwLwnzgIgL2Y46cZRpE+s/KYneAcqByT+LrG6Yd25ercw+2q4LO
         /7TQ==
X-Gm-Message-State: ANoB5pmm4ONSKXT+EsCjiCJrh4bp0Z5zBmh31vumU6W2tMfZTyeIepcc
        1EJNGa0qGk9pttD9UYegMZdjZ/DL1mWddvrm+yE/VK9gKupj5OjGflVdnhXezGBQ28VEJSrpfFS
        r4tV08FJ2Qxuk
X-Received: by 2002:a5d:4c82:0:b0:236:56a6:823e with SMTP id z2-20020a5d4c82000000b0023656a6823emr870608wrs.495.1668163709071;
        Fri, 11 Nov 2022 02:48:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UIf/FE35s97C3qgAJi8XmxKJI7BAtYamrbZSPQ2i8PaD7UqbY+0IJoMS/ROo9EGxDaDyUSA==
X-Received: by 2002:a5d:4c82:0:b0:236:56a6:823e with SMTP id z2-20020a5d4c82000000b0023656a6823emr870595wrs.495.1668163708800;
        Fri, 11 Nov 2022 02:48:28 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b0022cdb687bf9sm1319651wrb.0.2022.11.11.02.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 02:48:28 -0800 (PST)
Message-ID: <9e6288e1-0c51-bd3f-5cee-c71049ffa684@redhat.com>
Date:   Fri, 11 Nov 2022 11:48:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 1/3] accel: introduce accelerator blocker API
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221110164807.1306076-1-eesposit@redhat.com>
 <20221110164807.1306076-2-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221110164807.1306076-2-eesposit@redhat.com>
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

On 11/10/22 17:48, Emanuele Giuseppe Esposito wrote:
> +/*
> + * QEMU accel blocker class

"Lock to inhibit accelerator ioctls"

> + *
> + * Copyright (c) 2014 Red Hat Inc.

2022, you can also add an Author line.

> +static int accel_in_ioctls(void)

Return bool (and return early if ret becomes true).

> +void accel_ioctl_inhibit_begin(void)
> +{
> +    CPUState *cpu;
> +
> +    /*
> +     * We allow to inhibit only when holding the BQL, so we can identify
> +     * when an inhibitor wants to issue an ioctl easily.
> +     */
> +    g_assert(qemu_mutex_iothread_locked());
> +
> +    /* Block further invocations of the ioctls outside the BQL.  */
> +    CPU_FOREACH(cpu) {
> +        qemu_lockcnt_lock(&cpu->in_ioctl_lock);
> +    }
> +    qemu_lockcnt_lock(&accel_in_ioctl_lock);
> +
> +    /* Keep waiting until there are running ioctls */
> +    while (accel_in_ioctls()) {
> +        /* Reset event to FREE. */
> +        qemu_event_reset(&accel_in_ioctl_event);
> +
> +        if (accel_in_ioctls()) {
> +
> +            CPU_FOREACH(cpu) {
> +                /* exit the ioctl */
> +                qemu_cpu_kick(cpu);

Only kick if the lockcnt count is > 0? (this is not racy; if it is == 0, 
it cannot ever become > 0 again while the lock is taken)

> diff --git a/include/sysemu/accel-blocker.h b/include/sysemu/accel-blocker.h
> new file mode 100644
> index 0000000000..135ebea566
> --- /dev/null
> +++ b/include/sysemu/accel-blocker.h
> @@ -0,0 +1,45 @@
> +/*
> + * Accelerator blocking API, to prevent new ioctls from starting and wait the
> + * running ones finish.
> + * This mechanism differs from pause/resume_all_vcpus() in that it does not
> + * release the BQL.
> + *
> + *  Copyright (c) 2014 Red Hat Inc.

2022, you can also add an Author line here too.

> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + */
> +#ifndef ACCEL_BLOCKER_H
> +#define ACCEL_BLOCKER_H
> +
> +#include "qemu/osdep.h"
> +#include "qemu/accel.h"

qemu/accel.h not needed?

> +#include "sysemu/cpus.h"
> +
> +extern void accel_blocker_init(void);
> +
> +/*
> + * accel_set_in_ioctl/accel_cpu_set_in_ioctl:
> + * Mark when ioctl is about to run or just finished.
> + * If @in_ioctl is true, then mark it is beginning. Otherwise marks that it is
> + * ending.
> + *
> + * These functions will block after accel_ioctl_inhibit_begin() is called,
> + * preventing new ioctls to run. They will continue only after
> + * accel_ioctl_inibith_end().
> + */
> +extern void accel_set_in_ioctl(bool in_ioctl);
> +extern void accel_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl);

Why not just

extern void accel_ioctl_begin(void);
extern void accel_ioctl_end(void);
extern void accel_cpu_ioctl_begin(CPUState *cpu);
extern void accel_cpu_ioctl_end(CPUState *cpu);

?

Otherwise it's very nice.

Paolo

