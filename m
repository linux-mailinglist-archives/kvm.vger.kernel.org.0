Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD262F1E9
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 10:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiKRJy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 04:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiKRJy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 04:54:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80368E0A9
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 01:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668765242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtm+8my2jGPlJK1/kSSl3kwafpY1xwwtsKG2BP16XS8=;
        b=AmNgphL8BC5vyMmkkIegx1UKQbwclZa/frO/G+1Y804IKBf333Zz2ex6vlL01Qm+pzw4A7
        4YyaS7g+4mdsJUB2J0UBTk6DNFAGpOSErjDANw17iciyh8v6TNdEb9mLeBRVqHRo0GGZZm
        R3lmvPuIxBUdVKdD3XaiYh9y6d0fcik=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-6RtQN9-NNJ-IG7F-4f6XnA-1; Fri, 18 Nov 2022 04:54:00 -0500
X-MC-Unique: 6RtQN9-NNJ-IG7F-4f6XnA-1
Received: by mail-wm1-f70.google.com with SMTP id c126-20020a1c3584000000b003cfffcf7c1aso1974479wma.0
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 01:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtm+8my2jGPlJK1/kSSl3kwafpY1xwwtsKG2BP16XS8=;
        b=qlS0H3VgBza3hL2KW7qFzmbZ0JzMs7yc6mNFO2+4zO0joqBAcloFoJ1ouo1tSVfOLj
         53QPzzbL84hrWrvrh+8c+YBk5S3cbCkf+nsZaZW4azgKHUJK8SC/2V0YwYQF4tknhL5x
         FMBiN16eVJZkefTVlBiUyrJ3CLiBm4r/CUQwerkD43F01hX2WLdZ3Ge5GXKwDVbtZHM/
         6zKS+y4I27DAzirU7/aCct+JgMXzfzAQfTLLsTuwdA/cFyQx04LHhHPpBra0aueDWi1A
         NvW1j8wF1c9tj83oBN27eRFyV2vZyVkbkEJ6ezLybbj6oVgTPW7DC+X3LKJxMZRwDXEx
         tLOQ==
X-Gm-Message-State: ANoB5pnwrDIqlnsXXpDp2pxnBtmXBTuBvDJPk6QW78bT65g1Ec639ewg
        cWc5I3WYnM5X6TDuXldCVvRFCls2zeJe9tlhpcfEqjEgPfxC8P8UxkERiwcdMq+ihij0zRV7lM8
        5Ad6RNZ+TFq1d
X-Received: by 2002:a5d:5603:0:b0:241:c2ce:86a4 with SMTP id l3-20020a5d5603000000b00241c2ce86a4mr1034176wrv.360.1668765239808;
        Fri, 18 Nov 2022 01:53:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4CwupHdnR/pHqqNaA2l87qUfn+TqJvESctm0GbP23XKj8AcSW12K0XSsI9ZnCLpicpV142zw==
X-Received: by 2002:a5d:5603:0:b0:241:c2ce:86a4 with SMTP id l3-20020a5d5603000000b00241c2ce86a4mr1034164wrv.360.1668765239548;
        Fri, 18 Nov 2022 01:53:59 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id f10-20020a5d4dca000000b002416ecb8c33sm3116748wru.105.2022.11.18.01.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 01:53:59 -0800 (PST)
Message-ID: <f7a0ee85-5121-6390-1d0c-f406fcb00232@redhat.com>
Date:   Fri, 18 Nov 2022 10:53:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 2/3] KVM: keep track of running ioctls
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org
References: <20221111154758.1372674-1-eesposit@redhat.com>
 <20221111154758.1372674-3-eesposit@redhat.com>
 <8a7521c2-2335-4070-8555-954aa2a71422@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <8a7521c2-2335-4070-8555-954aa2a71422@redhat.com>
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



Am 17/11/2022 um 20:27 schrieb David Hildenbrand:
> On 11.11.22 16:47, Emanuele Giuseppe Esposito wrote:
>> Using the new accel-blocker API, mark where ioctls are being called
>> in KVM. Next, we will implement the critical section that will take
>> care of performing memslots modifications atomically, therefore
>> preventing any new ioctl from running and allowing the running ones
>> to finish.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> You might want to drop that and instead mention something like "This
> patch is based on a protoype patch by David Hildenbrand".
> 
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>   accel/kvm/kvm-all.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index f99b0becd8..ff660fd469 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2310,6 +2310,7 @@ static int kvm_init(MachineState *ms)
>>       assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
>>         s->sigmask_len = 8;
>> +    accel_blocker_init();
>>     #ifdef KVM_CAP_SET_GUEST_DEBUG
>>       QTAILQ_INIT(&s->kvm_sw_breakpoints);
>> @@ -3014,7 +3015,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
>>       va_end(ap);
>>         trace_kvm_vm_ioctl(type, arg);
>> +    accel_ioctl_begin();
>>       ret = ioctl(s->vmfd, type, arg);
>> +    accel_ioctl_end();
>>       if (ret == -1) {
>>           ret = -errno;
>>       }
>> @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
>>       va_end(ap);
>>         trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
>> +    accel_cpu_ioctl_begin(cpu);
>>       ret = ioctl(cpu->kvm_fd, type, arg);
>> +    accel_cpu_ioctl_end(cpu);
>>       if (ret == -1) {
>>           ret = -errno;
>>       }
>> @@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
>>       va_end(ap);
>>         trace_kvm_device_ioctl(fd, type, arg);
>> +    accel_ioctl_begin();
>>       ret = ioctl(fd, type, arg);
>> +    accel_ioctl_end();
>>       if (ret == -1) {
>>           ret = -errno;
>>       }
> 
> I recall that I had some additional patches that tried to catch some of
> more calls:
> 
> https://lore.kernel.org/qemu-devel/20200312161217.3590-2-david@redhat.com/
> 
> https://lore.kernel.org/qemu-devel/20200312161217.3590-3-david@redhat.com/
> 
> Do they still apply? Is there more?
> 

Apologies, what do you mean with "do they still apply"?
Looks fine to me

Emanuele

