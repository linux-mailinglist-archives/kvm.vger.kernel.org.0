Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00529640881
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiLBOd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 09:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiLBOdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 09:33:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF64DCBDB
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 06:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669991534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=koItVlGu+1a/7vo9JIQM0stiBr7/5n7yzQpCFYzOrVs=;
        b=O+zebGU42mOh9C0AIEgRYzzxwJ2eOz+cYOFvg2ji7mvSF/KuxpUnR0jtSA3aXgfB+kVdLc
        pIyP6DoRW97XDgIZ52hTIrbN0Y7ez6KXMSZgyRLuZAjjVrDmcT+w+q7ycUW5W/3P7ashqe
        8DETltFU4m8BrQ3ByArY/Cm/WluD5sQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-_JALDLo-Mly5Gvx8rZbloA-1; Fri, 02 Dec 2022 09:32:13 -0500
X-MC-Unique: _JALDLo-Mly5Gvx8rZbloA-1
Received: by mail-wr1-f70.google.com with SMTP id d4-20020adfa404000000b002421ca8cb07so1116780wra.2
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 06:32:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=koItVlGu+1a/7vo9JIQM0stiBr7/5n7yzQpCFYzOrVs=;
        b=r34Qd4TD3Qp3BhIiMW5lWoOcoaGL0Q5dXD7wTKvLnz+T++eh382ROg2J78hAe2xuPL
         WS75I7e7gOh2yoBwetM9zLEC13LOQrCXX8JmWMrsPCRGswQZm3vvyyeaqKPI3cWhcV9I
         yddMLxtwdsK2uDs5mTCsOgEV0E3NcOYQIRezVubqIl89z4un/MI/Sky1/EZGzGtFe47a
         MXT4bZKF/mmY5/iyu6323ufP8YXGGBCiWus8TnIyxif+JYl9nDGpGJ3hqYb9o1SgVO3L
         KFZ3UF6F8y3cqdJsoO82lGIEQ1jrnBn1E4OE6xd/Ehe7g3ONUb7eDtRt8R7mg6dUdbl5
         kfEg==
X-Gm-Message-State: ANoB5pnX8/z1FJ5Nzjk21xW7IfAFyugfc+kSlbOSuc8/eQEozMPVzWvY
        oXWdTodRLSgJtrIxyfwG0hUdfHp/qyPK/6oZ1E38782/wRGYujO091Y/OXj7aBc9fYCtOQrPbel
        AzeSoYLY3R55p
X-Received: by 2002:a5d:42c3:0:b0:242:32d7:85f6 with SMTP id t3-20020a5d42c3000000b0024232d785f6mr6165953wrr.645.1669991531930;
        Fri, 02 Dec 2022 06:32:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5XdZB7BSSc6lg2fXLp8fzZOhjZSrFh3hrAlxoU7gYMrUbcfzV8a/07FDJrMVpugQI92fK1Cw==
X-Received: by 2002:a5d:42c3:0:b0:242:32d7:85f6 with SMTP id t3-20020a5d42c3000000b0024232d785f6mr6165941wrr.645.1669991531751;
        Fri, 02 Dec 2022 06:32:11 -0800 (PST)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c458a00b003cfd4a50d5asm14245431wmo.34.2022.12.02.06.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 06:32:11 -0800 (PST)
Message-ID: <047d6a47-8c7b-0936-95ab-478afb61c21f@redhat.com>
Date:   Fri, 2 Dec 2022 15:32:10 +0100
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
 <22042ca5-9786-ca2b-3e3d-6443a744c5a9@redhat.com>
 <0022a85f16c1f1dc14decdc71f58af492b45b50d.camel@linux.intel.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <0022a85f16c1f1dc14decdc71f58af492b45b50d.camel@linux.intel.com>
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



Am 02/12/2022 um 14:32 schrieb Robert Hoo:
> On Fri, 2022-12-02 at 13:03 +0100, Emanuele Giuseppe Esposito wrote:
> ...
>>>> @@ -3032,7 +3035,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type,
>>>> ...)
>>>>      va_end(ap);
>>>>  
>>>>      trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
>>>> +    accel_cpu_ioctl_begin(cpu);
>>>
>>> Does this mean that kvm_region_commit() can inhibit any other vcpus
>>> doing any ioctls?
>>
>> Yes, because we must prevent any vcpu from reading memslots while we
>> are
>> updating them.
>>
> But do most other vm/vcpu ioctls contend with memslot operations?
> 

I think this is the simplest way. I agree not all ioctls contend with
memslot operations, but there are also not so many memslot operations
too. Instead of going one by one in all possible ioctls, covering all of
them is the simplest way and it covers also the case of a new ioctl
reading memslots that could be added in the future (alternatively we
would be always updating the list of ioctls to block).

