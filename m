Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4662E53A
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiKQT2P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239456AbiKQT2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:28:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270BC8A152
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668713229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CCGejm4H6jUhB5nUPWvzJPFgNnOlz+t2gtXDuwkn3kM=;
        b=NMo4gO4cO+W0Hb5Yoww+6mXtvkJ4c7Mv5qAUqtS0ktMmfF7tad3WnGnMLSvp3KPlaiJN4r
        tpcR9J9P9ftZg9oa2WeZvScxfKch9txX49E2V6nRIGn0kMNxVO8XuTz22Iq9GMikqFwvHr
        i8NmrFcEkGYEgP9jOzxfYy9uz2Hh1Ag=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-96-TagVHDfCN7-Jo9a7uKxZeA-1; Thu, 17 Nov 2022 14:27:07 -0500
X-MC-Unique: TagVHDfCN7-Jo9a7uKxZeA-1
Received: by mail-wr1-f69.google.com with SMTP id g14-20020adfa48e000000b00241bfca9693so24651wrb.8
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 11:27:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CCGejm4H6jUhB5nUPWvzJPFgNnOlz+t2gtXDuwkn3kM=;
        b=2qZqPhyJDIf991nEtfqxfHfJZnazxxy3M5jRRLSU08LVxsA1xK/kRANE3/V3zJoPMC
         xphLWlZBMyQhUIcg8zV1lbabKD1wfSERoMmk0mWwd0/C4WP0JcsLnu1dF3d8xS1ddBLe
         dfpt6zJrbhh2grx7Ei6paG1iA37WDQoE8dQB07ntbDXmnIseJ+id8+4aPWbUxePiH5H0
         47FtRnjOfx4Dy8Dmt3QGv+/dGUJbG6Lj03kjPXtlJ5+M3AMI+95H947zOKhjvx49a3oK
         e1sXo7eZkDWTZeNFy3Ok7wG/rNbjofTiJRsCxJ37yuIoxQy2XvE+/Bqn3YtU2FJZdh1L
         mmSw==
X-Gm-Message-State: ANoB5pn+efjUin+piLePpTR+fVm1JDmqp819r289N8Vj17yMw+Vm8XhY
        XfCHdQMXsVFQX/6wCjqNWoKAEFsqpAjXOcpVrsiUWgaFkznFQvMm1z6Shb1Ly6Aamivg7LouyZ3
        1aqiH0bvonI3h
X-Received: by 2002:a05:600c:21d2:b0:3cf:b2b1:3c7 with SMTP id x18-20020a05600c21d200b003cfb2b103c7mr6212969wmj.176.1668713225735;
        Thu, 17 Nov 2022 11:27:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4z7fgvECPb0vsHQ4kEvE/oJxvyNe046/uFz9ieGX7DY4/GbnzIbO4zVAekqsR7mu0Qcrigqw==
X-Received: by 2002:a05:600c:21d2:b0:3cf:b2b1:3c7 with SMTP id x18-20020a05600c21d200b003cfb2b103c7mr6212950wmj.176.1668713225318;
        Thu, 17 Nov 2022 11:27:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:5200:39a9:b834:27c1:4ede? (p200300cbc707520039a9b83427c14ede.dip0.t-ipconnect.de. [2003:cb:c707:5200:39a9:b834:27c1:4ede])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b0022e66749437sm1693816wru.93.2022.11.17.11.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 11:27:04 -0800 (PST)
Message-ID: <8a7521c2-2335-4070-8555-954aa2a71422@redhat.com>
Date:   Thu, 17 Nov 2022 20:27:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3 2/3] KVM: keep track of running ioctls
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221111154758.1372674-1-eesposit@redhat.com>
 <20221111154758.1372674-3-eesposit@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20221111154758.1372674-3-eesposit@redhat.com>
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

On 11.11.22 16:47, Emanuele Giuseppe Esposito wrote:
> Using the new accel-blocker API, mark where ioctls are being called
> in KVM. Next, we will implement the critical section that will take
> care of performing memslots modifications atomically, therefore
> preventing any new ioctl from running and allowing the running ones
> to finish.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

You might want to drop that and instead mention something like "This 
patch is based on a protoype patch by David Hildenbrand".

> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   accel/kvm/kvm-all.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f99b0becd8..ff660fd469 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2310,6 +2310,7 @@ static int kvm_init(MachineState *ms)
>       assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
>   
>       s->sigmask_len = 8;
> +    accel_blocker_init();
>   
>   #ifdef KVM_CAP_SET_GUEST_DEBUG
>       QTAILQ_INIT(&s->kvm_sw_breakpoints);
> @@ -3014,7 +3015,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
>       va_end(ap);
>   
>       trace_kvm_vm_ioctl(type, arg);
> +    accel_ioctl_begin();
>       ret = ioctl(s->vmfd, type, arg);
> +    accel_ioctl_end();
>       if (ret == -1) {
>           ret = -errno;
>       }
> @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
>       va_end(ap);
>   
>       trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
> +    accel_cpu_ioctl_begin(cpu);
>       ret = ioctl(cpu->kvm_fd, type, arg);
> +    accel_cpu_ioctl_end(cpu);
>       if (ret == -1) {
>           ret = -errno;
>       }
> @@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
>       va_end(ap);
>   
>       trace_kvm_device_ioctl(fd, type, arg);
> +    accel_ioctl_begin();
>       ret = ioctl(fd, type, arg);
> +    accel_ioctl_end();
>       if (ret == -1) {
>           ret = -errno;
>       }

I recall that I had some additional patches that tried to catch some of 
more calls:

https://lore.kernel.org/qemu-devel/20200312161217.3590-2-david@redhat.com/

https://lore.kernel.org/qemu-devel/20200312161217.3590-3-david@redhat.com/

Do they still apply? Is there more?

-- 
Thanks,

David / dhildenb

