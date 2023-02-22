Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBD369F475
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 13:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbjBVMYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 07:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjBVMX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 07:23:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD78D3A0BD
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 04:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677068460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goul4Fhvfk43vCc860FayPZUVbj7HGLTXeMvhYOcsh0=;
        b=dI6Oac8vGqnp7uVTlLWgTh9nhLcSUXf93mgdJBKJO+yFIDxi7wUnnfKT7ICHlCQeShhQPl
        k1NQk9oSQrmuh9KM8luEd1CNJ2mFTtIX/09/a4a089kAdjPDhHjhJ1UP8Md3sjARtIAfc7
        43N/JSQHODp1UcBhlWPrJ3vI+I+ggZY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-juvcDhpYMHC9-B8P-YOBHA-1; Wed, 22 Feb 2023 07:17:29 -0500
X-MC-Unique: juvcDhpYMHC9-B8P-YOBHA-1
Received: by mail-ed1-f71.google.com with SMTP id r6-20020aa7c146000000b004acd97105ffso10716018edp.19
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 04:17:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=goul4Fhvfk43vCc860FayPZUVbj7HGLTXeMvhYOcsh0=;
        b=ATRgJsmLVQoiS51p43O1a4imUyuDtNo6pvAZ0qWNdtqxonhdBz23zKOGLf07KTklE2
         ZNDIqOlFYHWI2Id0rYYKuyGDBk+IY4YFmlJ/ZVoCY+eKwvVDKsb2M0IPCyKTQXMv1cCa
         tojOjTMh83z2iPMkY6MFth/wQbsD1CJ/vf5eS4LrVoVm84QckYHUTwbRoHE6QEluMZ5H
         dMym0lgH4c+YAPjtw+fb0YurqEqbjd1qjN8fAHb/LX5/0k0xEsQp/BIJL9GLsm8ujJT+
         DQM+4aqOg5ljW1MWfQYgGZVx9ngDU0GMV9EUyG2Ej1bz5KnR8hzEFi8nnl0UVeOWvXs+
         dcMA==
X-Gm-Message-State: AO0yUKXYyfFaOB1ayi7gf5Ta/eH27cSftXR/hT9fg3y6ux1lW8ublVIc
        pE57+bDFuS/BU13C6bQnCg2iQ9Y/GYegKuYNtHq6Rkq9LzEty6sRAZvtrotNncRYlYMM6393qud
        qyqZexDcBahAL
X-Received: by 2002:aa7:ccc6:0:b0:4ad:d4b9:f8f4 with SMTP id y6-20020aa7ccc6000000b004add4b9f8f4mr8172173edt.8.1677068248252;
        Wed, 22 Feb 2023 04:17:28 -0800 (PST)
X-Google-Smtp-Source: AK7set+3d7Z+mzeZfVcH9q2/QwKk/+Du//iEo4lNyoG0L3TyJI3S5+479TSrRz5mFMr/NTPfpxKX0w==
X-Received: by 2002:aa7:ccc6:0:b0:4ad:d4b9:f8f4 with SMTP id y6-20020aa7ccc6000000b004add4b9f8f4mr8172146edt.8.1677068247919;
        Wed, 22 Feb 2023 04:17:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id m27-20020a50d7db000000b004acc61206cfsm2594721edj.33.2023.02.22.04.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 04:17:27 -0800 (PST)
Message-ID: <a9623c91-a28a-d91d-5311-fcfc4bd13247@redhat.com>
Date:   Wed, 22 Feb 2023 13:17:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-7-zhaotianrui@loongson.cn>
 <cbd95763-ec38-63f7-89bf-c8b01aa7df77@redhat.com>
 <abfa3fbc-e234-d0ab-ec35-90d9c251bf79@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 06/29] LoongArch: KVM: Implement vcpu create and
 destroy interface
In-Reply-To: <abfa3fbc-e234-d0ab-ec35-90d9c251bf79@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/23 02:52, Tianrui Zhao wrote:
>>
>>> +    vcpu->arch.guest_eentry = (unsigned long)kvm_context->kvm_eentry;
>>> +    vcpu->arch.vcpu_run = kvm_context->kvm_enter_guest;
>>> +    vcpu->arch.handle_exit = _kvm_handle_exit;
>>
>> Here as well, whatever is constant must not be stored in struct 
>> kvm_arch_vcpu.
>>
>> Paolo
> 
> Thanks,  we use this in vcpu_arch because the vcpu_arch is used as 
> argument in switch.S' methods, we can quickly access the guest_eentry 
> and handle_exit by using the  KVM_ARCH_GEENTRY, KVM_ARCH_HANDLE_EXIT 
> offsets. If we change to global variable ,  we should relocate it in 
> switch.S and may lead  to lower accessing speed.

For guest_eentry and handle_exit this is correct so you can add a 
comment in kvm_host.h, like

	/* Pointers stored here for easy access from assembly code.  */

However, vcpu->arch.vcpu_run is not used in switch.S so there is no need 
to store it in struct kvm_arch_vcpu.  Since you're already going to move 
kvm_enter_guest out of kvm_context and into a global variable, please 
give it the right pointer-to-function type instead of using unsigned long.

Paolo

