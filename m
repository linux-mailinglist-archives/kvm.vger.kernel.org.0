Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CFC68BD88
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 14:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjBFNLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 08:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBFNLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 08:11:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DB71B327
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 05:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675689024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ueZ4lJNVVaAm6E2RadB+Higp5mUiTZD8EnTQrCVDZNw=;
        b=QO1/d3gp7eBqGLK7rFdpmpVQbb0B+Vi0PzEyBBRF64Ct7/bVQpUHSibS4D5dB64YxODmGG
        S2eUbgZg8Y5eaH3Eeh9aIzYIcZ+7fWJniCmEc42/V9Nej8is4aXB+ENn736ppJZERCFNsL
        OSHQ+z2SAryl7fF/GSL2txWeysR49fI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-LSUV7TBTNQeVl0R6d5tZAg-1; Mon, 06 Feb 2023 08:10:23 -0500
X-MC-Unique: LSUV7TBTNQeVl0R6d5tZAg-1
Received: by mail-qk1-f198.google.com with SMTP id w17-20020a05620a425100b00706bf3b459eso7807886qko.11
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 05:10:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ueZ4lJNVVaAm6E2RadB+Higp5mUiTZD8EnTQrCVDZNw=;
        b=sED3fVWuxNoa4lyP5lFdJcuZFoPpQdqSqRE2y8+cSzrDkXPa7ba0Dol1jC6fEXIa3q
         w7TRED2ImpIwgvvRlAUXhfYicnCPu+kpLiJhd463wlfknGJuiIVr2Wpxsfe8MEjmNX4L
         ytT3hUGiojTxW1nWZxy9uDEwDrsj9OfIk/peX/iySWw2sIA8AGU/n9EbQ6BTCEkC6rng
         Ct+qgj6u+wH8mB1HRnU5NNc6CU/SZysczT2/LWgKRPAhGukdTv9jUaDzU7zJSqXNpJYA
         4Rz/m4gpM2wwbHLvIOsmLrlvzp5wuV306UfuY27PjuR/qZ5nE+QRJkpS2MsIWNEo/ume
         xfqQ==
X-Gm-Message-State: AO0yUKWztXw+U+joYpaL/uLBzGysL8gxW2DnWVpcFEF7xAihaE5HXtoK
        CbS7Y9stGIO96d5GE7OPzVgRpPsElNH1LkHxne+Y/fDq8gvsSGHzKReR9lQ84UIdgch8Jdax8pF
        IlXnKb3fmvaRA
X-Received: by 2002:a05:622a:1006:b0:3ba:1360:ec0a with SMTP id d6-20020a05622a100600b003ba1360ec0amr12700687qte.41.1675689023203;
        Mon, 06 Feb 2023 05:10:23 -0800 (PST)
X-Google-Smtp-Source: AK7set/UnmAPcrXR3j+0mFEcIiQLc90TbCFnoszKGV4JDMYWVgMMAHz+UX7Yp11ERyM1ZwSnQhgE5w==
X-Received: by 2002:a05:622a:1006:b0:3ba:1360:ec0a with SMTP id d6-20020a05622a100600b003ba1360ec0amr12700662qte.41.1675689022948;
        Mon, 06 Feb 2023 05:10:22 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id b1-20020ac87fc1000000b003b9ba2cf068sm7267520qtk.56.2023.02.06.05.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 05:10:22 -0800 (PST)
Message-ID: <071ec3a6-cb4b-0dac-87fd-f3c3d00b5e83@redhat.com>
Date:   Mon, 6 Feb 2023 14:10:17 +0100
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
 <da118de5-adcd-ec0c-9870-454c3741a4ab@linaro.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <da118de5-adcd-ec0c-9870-454c3741a4ab@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/3/23 21:40, Richard Henderson wrote:
> On 2/3/23 03:44, Cornelia Huck wrote:
>> +static void aarch64_cpu_get_mte(Object *obj, Visitor *v, const char
>> *name,
>> +                                void *opaque, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    OnOffAuto mte = cpu->prop_mte;
>> +
>> +    visit_type_OnOffAuto(v, name, &mte, errp);
>> +}
> 
> You don't need to copy to a local variable here.
> 
>> +
>> +static void aarch64_cpu_set_mte(Object *obj, Visitor *v, const char
>> *name,
>> +                                void *opaque, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    visit_type_OnOffAuto(v, name, &cpu->prop_mte, errp);
>> +}
> 
> ... which makes get and set functions identical.
> No need for both.
This looks like a common pattern though. virt_get_acpi/set_acpi in
virt.c or pc_machine_get_vmport/set_vmport in i386/pc.c and many other
places (microvm ...). Do those other callers also need some simplifications?

Eric
> 
>> +static inline bool arm_machine_has_tag_memory(void)
>> +{
>> +#ifndef CONFIG_USER_ONLY
>> +    Object *obj = object_dynamic_cast(qdev_get_machine(),
>> TYPE_VIRT_MACHINE);
>> +
>> +    /* so far, only the virt machine has support for tag memory */
>> +    if (obj) {
>> +        VirtMachineState *vms = VIRT_MACHINE(obj);
> 
> VIRT_MACHINE() does object_dynamic_cast_assert, and we've just done that.
> 
> As this is startup, it's not the speed that matters.  But it does look
> unfortunate.  Not for this patch set, but perhaps we ought to add
> TRY_OBJ_NAME to DECLARE_INSTANCE_CHECKER?
> 
>> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
>> +{
>> +    bool enable_mte;
>> +
>> +    switch (cpu->prop_mte) {
>> +    case ON_OFF_AUTO_OFF:
>> +        enable_mte = false;
>> +        break;
>> +    case ON_OFF_AUTO_ON:
>> +        if (tcg_enabled()) {
>> +            if (cpu_isar_feature(aa64_mte, cpu)) {
>> +                if (!arm_machine_has_tag_memory()) {
>> +                    error_setg(errp, "mte=on requires tag memory");
>> +                    return;
>> +                }
>> +            } else {
>> +                error_setg(errp, "mte not supported by this CPU type");
>> +                return;
>> +            }
>> +        }
>> +        if (kvm_enabled() && !kvm_arm_mte_supported()) {
>> +            error_setg(errp, "mte not supported by kvm");
>> +            return;
>> +        }
>> +        enable_mte = true;
>> +        break;
> 
> What's here is not wrong, but maybe better structured as
> 
>     enable_mte = true;
>         if (qtest_enabled()) {
>             break;
>         }
>         if (tcg_enabled()) {
>             if (arm_machine_tag_mem) {
>                 break;
>             }
>             error;
>             return;
>         }
>         if (kvm_enabled() && kvm_arm_mte_supported) {
>             break;
>         }
>         error("mte not supported by %s", current_accel_type());
>         return;
> 
> We only add the property for tcg via -cpu max, so the isar check is
> redundant.
> 
> 
> r~
> 

