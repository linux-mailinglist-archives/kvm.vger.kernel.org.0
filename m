Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5145697A01
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 11:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjBOKgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 05:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbjBOKgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 05:36:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A0C5266
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 02:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676457368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RD2vdtD2hCDoDpOR7tgSDmxAVUUdTeXI5S6eB2JsfYE=;
        b=AmQiO/QsItbjozenKNqAIR6EXZyfgpRrV15Z77q9gQvWNjTg/oGb/CZ19niWipqati2uDs
        roKD8ABtnc+TxbGCdN7inkw34Wr8gRgHgWmmZUnBq/weysAHajSY1m4NVG7UHLUN79eeXD
        iVZmUVJ1SyaN+eVYtynuA8H2AOT6Q88=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-203-tFMc16paP_mYV1yTbYacmg-1; Wed, 15 Feb 2023 05:36:06 -0500
X-MC-Unique: tFMc16paP_mYV1yTbYacmg-1
Received: by mail-qk1-f198.google.com with SMTP id j29-20020a05620a001d00b00724fd33cb3eso11249450qki.14
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 02:36:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RD2vdtD2hCDoDpOR7tgSDmxAVUUdTeXI5S6eB2JsfYE=;
        b=L/fo2ICsjqkjWHJv8Fywl+of8AkIIYWOGpeJ+NsFvCQGmwnsFSMD+ECmE6q2qqOsuO
         5m0XWD0kSzDQcxH5fTJ5nNJAKHMYU2boAhkpQigZrb/sxtKVoGWl6U1kYsb+xVi7zFd8
         pVIoE8TELTQEJIOScrLnmerq0CgTCVZgw5Ty5xORynPsi+t9WbNToZXp3SsRpMBQ5cCl
         7m0Tq4yxfcteO8i3obY9gfQaxr3WNVjUE6A9J41RwAOKr0YzaWfPsemVsmtFhj37Dl8B
         FGEiSVHqPn6QEJ8GDVKl59wUPAipamN8Tga44nwgUPV8PRWNJo0+qda4NPRZR+qXFf6z
         M4SA==
X-Gm-Message-State: AO0yUKVlN6GAB3L3pOdTAPsfYorHvAMkPH3ElQu8x4ljEHxq5AVENS6h
        DbtdiV0hwoR+9Lep2DHmBzARa/6P1ie2I1fLOSjHqwCS8SMtdkrKirJ2rR17HcV/ptgA0QjzFxy
        5YqmbPASgcP74nN/jAA==
X-Received: by 2002:a05:622a:1c9:b0:3b9:a4ac:9109 with SMTP id t9-20020a05622a01c900b003b9a4ac9109mr2752666qtw.64.1676457365699;
        Wed, 15 Feb 2023 02:36:05 -0800 (PST)
X-Google-Smtp-Source: AK7set8YtHxNeDwl9P8bOMf2Mkat55tTiA0Vw42KGVKRuuQMnOPNV5l9ILnxzk95iBbUd8um7615aQ==
X-Received: by 2002:a05:622a:1c9:b0:3b9:a4ac:9109 with SMTP id t9-20020a05622a01c900b003b9a4ac9109mr2752638qtw.64.1676457365481;
        Wed, 15 Feb 2023 02:36:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k9-20020ac84789000000b003b2d890752dsm12743026qtq.88.2023.02.15.02.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 02:36:04 -0800 (PST)
Message-ID: <f24a826e-2f90-d23a-c3f3-5985e90814f2@redhat.com>
Date:   Wed, 15 Feb 2023 11:36:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5 2/3] arm/kvm: add support for MTE
Content-Language: en-US
To:     Richard Henderson <richard.henderson@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-3-cohuck@redhat.com>
 <ecddd3a1-f4e4-4cc8-3294-8c94aca28ed0@redhat.com>
 <14188fd3-6e97-3e00-7d54-7f76e53eeb22@linaro.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <14188fd3-6e97-3e00-7d54-7f76e53eeb22@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Richard,
On 2/6/23 19:27, Richard Henderson wrote:
> On 2/6/23 03:32, Eric Auger wrote:
>>> +void kvm_arm_enable_mte(Error **errp)
>>> +{
>>> +    static bool tried_to_enable = false;
>>> +    Error *mte_migration_blocker = NULL;
>> can't you make the mte_migration_blocker static instead?
>>
>>> +    int ret;
>>> +
>>> +    if (tried_to_enable) {
>>> +        /*
>>> +         * MTE on KVM is enabled on a per-VM basis (and retrying
>>> doesn't make
>>> +         * sense), and we only want a single migration blocker as well.
>>> +         */
>>> +        return;
>>> +    }
>>> +    tried_to_enable = true;
>>> +
>>> +    if ((ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0))) {
>>> +        error_setg_errno(errp, -ret, "Failed to enable
>>> KVM_CAP_ARM_MTE");
>>> +        return;
>>> +    }
>>> +
>>> +    /* TODO: add proper migration support with MTE enabled */
>>> +    error_setg(&mte_migration_blocker,
>>> +               "Live migration disabled due to MTE enabled");
> 
> Making the blocker static wouldn't stop multiple errors from
> kvm_vm_enable_cap.
Sorry I don't get what you mean. instead of checking tried_to_enable why
can't we check !mte_migration_blocker?

Eric
> 
> 
> r~
> 

