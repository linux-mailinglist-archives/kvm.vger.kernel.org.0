Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720B76258B1
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 11:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbiKKKuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 05:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiKKKuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 05:50:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAD26585
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 02:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668163763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5kPuicOxxmAhYzy/gpJ36mHVtfyGmFmZsq+weM3ZKFw=;
        b=BOu2efkamU+Wuyn6e2vARekAECjLleRzu0i26ZgykFYHytxMq0m2JIxbfPp9YJAdo49U2A
        jTTytZ8hp4XbAiQ+kDT7+bx3tmaAC4i+jQTZZdHmdb8gTfkKfSu1oxPlOtEQMqITrAW8QM
        jXJ1HagkrX0pdhmWovxy5FoOP/szzpU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-_zDJJmOtNTuy7G3Ql3tk1Q-1; Fri, 11 Nov 2022 05:49:21 -0500
X-MC-Unique: _zDJJmOtNTuy7G3Ql3tk1Q-1
Received: by mail-wm1-f71.google.com with SMTP id 186-20020a1c02c3000000b003cfab28cbe0so4228086wmc.9
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 02:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kPuicOxxmAhYzy/gpJ36mHVtfyGmFmZsq+weM3ZKFw=;
        b=nw4sR+W8V8n+pTpvh37pBRCzkaWwVmpe/PpBL85Egpq1trII7sq8O/BgjnP7uekFdh
         MkHqu40jpY/N9LGo9YN+qf0Nr02tysgFtRoU3VaiKQRGySZpFp3t6+VU5Rrm1ZGY3ocK
         PjPvXOJkt3MvuCaDN4gNycNuwKjbhaIYvS0sCIpAgaa5fEY6iXpgm9zUICeq8KCkXxHy
         kyPe+XYAk62+nMUtjmnAst/ef7TSayKtjc8vcwlJwA6WD6Z+q4zE1BzgKQryx+i3eLD7
         CVNS6xHprcjhpHvjTDFhcL9T1aM9b5GnJxVy0OzYyVkjagtUuIiXlrERxu2p3xd9h23s
         54qA==
X-Gm-Message-State: ANoB5plVfm2rWXxio2chHizRryiJt/8jnPg800c7Lvhvbhz3HFGuN90e
        xVnEvjlqU0HGXtB7nV7BxIPcpdFQ3PbskpZ5Jr35RIKLUNOv4aVfZv+PvmHtJhw7mu/3xJGmbTx
        sSrvOvv1Ix10v
X-Received: by 2002:a5d:54cd:0:b0:236:6442:2f86 with SMTP id x13-20020a5d54cd000000b0023664422f86mr880420wrv.588.1668163760382;
        Fri, 11 Nov 2022 02:49:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ja7CP2CzMwNfKVy9fBrnecx2Hq/ZkHE96zYgGmdZp0hUk9rFkGv98Zh6MDvd5f7g03H56kg==
X-Received: by 2002:a5d:54cd:0:b0:236:6442:2f86 with SMTP id x13-20020a5d54cd000000b0023664422f86mr880408wrv.588.1668163760135;
        Fri, 11 Nov 2022 02:49:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id l22-20020a05600c16d600b003cf4eac8e80sm2883353wmn.23.2022.11.11.02.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 02:49:19 -0800 (PST)
Message-ID: <f4db2187-af9e-d417-2639-6641e3c6725a@redhat.com>
Date:   Fri, 11 Nov 2022 11:49:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 2/3] KVM: keep track of running ioctls
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221110164807.1306076-1-eesposit@redhat.com>
 <20221110164807.1306076-3-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221110164807.1306076-3-eesposit@redhat.com>
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
> diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
> index f9fdd46b9d..8d6a4b1b65 100644
> --- a/hw/core/cpu-common.c
> +++ b/hw/core/cpu-common.c
> @@ -237,6 +237,7 @@ static void cpu_common_initfn(Object *obj)
>       cpu->nr_threads = 1;
>   
>       qemu_mutex_init(&cpu->work_mutex);
> +    qemu_lockcnt_init(&cpu->in_ioctl_lock);
>       QSIMPLEQ_INIT(&cpu->work_list);
>       QTAILQ_INIT(&cpu->breakpoints);
>       QTAILQ_INIT(&cpu->watchpoints);
> @@ -248,6 +249,7 @@ static void cpu_common_finalize(Object *obj)
>   {
>       CPUState *cpu = CPU(obj);
>   
> +    qemu_lockcnt_destroy(&cpu->in_ioctl_lock);
>       qemu_mutex_destroy(&cpu->work_mutex);
>   }
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index f9b58773f7..15053663bc 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -397,6 +397,9 @@ struct CPUState {
>       uint32_t kvm_fetch_index;
>       uint64_t dirty_pages;
>   
> +    /* Use by accel-block: CPU is executing an ioctl() */
> +    QemuLockCnt in_ioctl_lock;
> +
>       /* Used for events with 'vcpu' and *without* the 'disabled' properties */
>       DECLARE_BITMAP(trace_dstate_delayed, CPU_TRACE_DSTATE_MAX_EVENTS);
>       DECLARE_BITMAP(trace_dstate, CPU_TRACE_DSTATE_MAX_EVENTS);

These go in patch 1.

Paolo

