Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F49C640657
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 13:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiLBMEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 07:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiLBMEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 07:04:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C874F1B8
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 04:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669982629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HtPg/dh9QYEl6yrHory3nv8jqkuqPr74m3e1GaYIopY=;
        b=PlEGqTXpI+TSxSQVI6KSv6d8XNNHn89cfAdZQsUaXNwHA/r3IvGSwc+zQYVOPl1BUf3w4N
        k4uRdpuxCjUIwFBG89TDJFdK15bD5NAB9bpaC29L1Qsp56OjW596Fvb3IFj1CAFw18z9PQ
        uzslamjEYdse+pkrkJqMvLrMgOP4fX8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-442-G8Deaih7NJeGzMB1tp1qJQ-1; Fri, 02 Dec 2022 07:03:48 -0500
X-MC-Unique: G8Deaih7NJeGzMB1tp1qJQ-1
Received: by mail-wm1-f72.google.com with SMTP id b47-20020a05600c4aaf00b003d031aeb1b6so4027172wmp.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 04:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtPg/dh9QYEl6yrHory3nv8jqkuqPr74m3e1GaYIopY=;
        b=eBMulY7SHAeuw0URC/dm16sGS1kKR3WYo0eZBzFpWFSukff0P0wjB1S5zJq40Ye0pF
         jgSU0OsNc/Fq3moWMX0XInS8iagh53EDQCQdgA9v00RIA8G5cbkF+UfOQwrK6H7UR16S
         4yhX7Ky8jGNrUZx3unr0D8LMFLt1DwSdDJP+YnKWh/Ur4dGymx++om2LeITm45hDFOwq
         lBnthEhb0IuFY1ewodoQdbTapnYA/FAn6RrxqVtc+tuBUOat2+uB0A8t2OIHeRj+b0Fz
         OGXMSpANj7MjraWs1ap1mc0uDaxYWyijKtRNVf6Ygk379a5bIazw91x3tFvc94I9u93Q
         Wshg==
X-Gm-Message-State: ANoB5pm0EBaIsOMYuIi5LfCPetYva/QT8M72DiJrfgcMMVd55RCCAByG
        Nr0epj268vbpqqka27A+rZRxcYzeVJmV+ttzNdEIplEanpy4mhtNcE0PygdaWm3W5qBV48FO2Ds
        RUzbbTmuQ9UOl
X-Received: by 2002:a05:6000:548:b0:242:3f7e:1bdf with SMTP id b8-20020a056000054800b002423f7e1bdfmr3381077wrf.636.1669982627406;
        Fri, 02 Dec 2022 04:03:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7WiVrKEU6X5GazgfxbefEHiHL0FPwlQXsLYYQuh6SIJswQ3+bWWzThEdBs4FVLKhFAGRYfew==
X-Received: by 2002:a05:6000:548:b0:242:3f7e:1bdf with SMTP id b8-20020a056000054800b002423f7e1bdfmr3381063wrf.636.1669982627174;
        Fri, 02 Dec 2022 04:03:47 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id v128-20020a1cac86000000b003cfa80443a0sm8321048wme.35.2022.12.02.04.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:03:46 -0800 (PST)
Message-ID: <22042ca5-9786-ca2b-3e3d-6443a744c5a9@redhat.com>
Date:   Fri, 2 Dec 2022 13:03:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 2/3] KVM: keep track of running ioctls
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
References: <20221111154758.1372674-1-eesposit@redhat.com>
 <20221111154758.1372674-3-eesposit@redhat.com>
 <c7971c8ad3b4683e2b3036dd7524af1cb42e50e1.camel@linux.intel.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <c7971c8ad3b4683e2b3036dd7524af1cb42e50e1.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 02/12/2022 um 07:54 schrieb Robert Hoo:
> On Fri, 2022-11-11 at 10:47 -0500, Emanuele Giuseppe Esposito wrote:
>> Using the new accel-blocker API, mark where ioctls are being called
>> in KVM. Next, we will implement the critical section that will take
>> care of performing memslots modifications atomically, therefore
>> preventing any new ioctl from running and allowing the running ones
>> to finish.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>  accel/kvm/kvm-all.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index f99b0becd8..ff660fd469 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2310,6 +2310,7 @@ static int kvm_init(MachineState *ms)
>>      assert(TARGET_PAGE_SIZE <= qemu_real_host_page_size());
>>  
>>      s->sigmask_len = 8;
>> +    accel_blocker_init();
>>  
>>  #ifdef KVM_CAP_SET_GUEST_DEBUG
>>      QTAILQ_INIT(&s->kvm_sw_breakpoints);
>> @@ -3014,7 +3015,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
>>      va_end(ap);
>>  
>>      trace_kvm_vm_ioctl(type, arg);
>> +    accel_ioctl_begin();
>>      ret = ioctl(s->vmfd, type, arg);
>> +    accel_ioctl_end();
>>      if (ret == -1) {
>>          ret = -errno;
>>      }
>> @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type,
>> ...)
>>      va_end(ap);
>>  
>>      trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
>> +    accel_cpu_ioctl_begin(cpu);
> 
> Does this mean that kvm_region_commit() can inhibit any other vcpus
> doing any ioctls?

Yes, because we must prevent any vcpu from reading memslots while we are
updating them.

> 
>>      ret = ioctl(cpu->kvm_fd, type, arg);
>> +    accel_cpu_ioctl_end(cpu);
>>      if (ret == -1) {
>>          ret = -errno;
>>      }
>> @@ -3050,7 +3055,9 @@ int kvm_device_ioctl(int fd, int type, ...)
>>      va_end(ap);
>>  
>>      trace_kvm_device_ioctl(fd, type, arg);
>> +    accel_ioctl_begin();
>>      ret = ioctl(fd, type, arg);
>> +    accel_ioctl_end();
>>      if (ret == -1) {
>>          ret = -errno;
>>      }
> 

