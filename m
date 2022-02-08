Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD84ADDDB
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 17:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381557AbiBHQBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 11:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379034AbiBHQBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 11:01:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8CE7C061578
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 08:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644336102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZCxf9PogYRxXOjDxxxMs4w2YeOFcdmHp0JN35V5WWMM=;
        b=JZ/cNt+7ReGzuLZidZ0puC0BIxJjZ7i3teQWjgJ2NTZipsyP4Av/GJYxZ6e0TvFu4U30Rh
        2iJAA+pcKRj925O2DM3EMT5FI1nf+KPt1MfL8wkY1wv57xkx6IFvFRy5mMBQRDulgGS8ML
        zqsMoefjnqpJhEI2okeziMRuq3dOsYE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-kvgNcv2-N6OIizU27SZ1AQ-1; Tue, 08 Feb 2022 11:01:41 -0500
X-MC-Unique: kvgNcv2-N6OIizU27SZ1AQ-1
Received: by mail-ed1-f70.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso9971190edv.12
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 08:01:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZCxf9PogYRxXOjDxxxMs4w2YeOFcdmHp0JN35V5WWMM=;
        b=rv68d55l/S/3KkMQrhbTaCQPCN9qkqanDCjf9lVIR2XGbh1lEp3WLyXJjYWBRqEfTp
         vprdACXHgW8fI99Zjs8NWbT5IIdikEbiIPdMlV2TZQpEqY+wXBg3YZ3YHx66vcjMlICN
         bbVtVrYetrinVJcXjp00E3vG8R1lpcMIWQZz3R2WlyWXVtpQ96aiyRdNess19JkRIPCd
         PkKBGJrXtyrtGyV/8rkJ6AJr6L5BxNyqJQrJXFvDjSFAdaXy44ABNvxIq3yyJO2Lgj+T
         e+b4O9cBtqDaFqXB+mmH7byx9sZTWHDxmnUyWsn/wnkJ8uDfWxCVdFO6xvMh5ODsnPXm
         AQRA==
X-Gm-Message-State: AOAM531U4YAjK8krBjeROx4k74z+XDS/FePtIojYaxyNCPZDb2Fvuqgm
        e6s9PcRB72ANG3rifF16C8U+WeFB1B8mzAcwN895KeU5awK5MP7mjJOOj4dwZ/MilutPapHI+wK
        OfrG5Ga09nCrqo3v6/2P6ACCK88Ln7s41uvXbomNw8lbd8soA8M5B3UovOapkZPez
X-Received: by 2002:a17:907:608f:: with SMTP id ht15mr4322558ejc.484.1644336100054;
        Tue, 08 Feb 2022 08:01:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyE51kdktw9gByitSD9Qv3Lh3HqeP4N1cUv6GdJop/VgdauVm1PnLwGj/f3FaQnKepRF60IDQ==
X-Received: by 2002:a17:907:608f:: with SMTP id ht15mr4322507ejc.484.1644336099601;
        Tue, 08 Feb 2022 08:01:39 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ot38sm2553508ejb.131.2022.02.08.08.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 08:01:39 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: warning in kvm_hv_invalidate_tsc_page due to writes to guest
 memory from VM ioctl context
In-Reply-To: <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
References: <190b5932de7c61905d11c92780095a2caaefec1c.camel@redhat.com>
 <87ee4d9yp3.fsf@redhat.com>
 <060ce89597cfbc85ecd300bdd5c40bb571a16993.camel@redhat.com>
Date:   Tue, 08 Feb 2022 17:01:38 +0100
Message-ID: <87bkzh9wkd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Tue, 2022-02-08 at 16:15 +0100, Vitaly Kuznetsov wrote:
>> 
>> "hv-vapic" enables so-called "VP Assist" page and Enlightened VMCS GPA
>> sits there, it is used instead of VMPTRLD (which becomes unsupported)
>> 
>> Take a look at the newly introduced "hv-apicv"/"hv-avic" (the same
>> thing) in QEMU: 
>> 
>> commit e1f9a8e8c90ae54387922e33e5ac4fd759747d01
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Thu Sep 2 11:35:28 2021 +0200
>> 
>>     i386: Implement pseudo 'hv-avic' ('hv-apicv') enlightenment
>> 
>> when enabled, HV_APIC_ACCESS_RECOMMENDED is not set even with "hv-vapic"
>> (but HV_APIC_ACCESS_AVAILABLE remains). 
>> 
>
> Cool, I didn't expect this. I thought that hv-vapic only enables the AutoEOI
> deprecation bit.
>
> This needs to be updated in hyperv.txt in qemu - it currently states that
> hv-evmcs disables posted interrupts (that is APICv) 

EVMCS disables (not only) posted interrupts feature for nested
guests. To be precise, it disables the following:

#define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
                                    PIN_BASED_VMX_PREEMPTION_TIMER)
#define EVMCS1_UNSUPPORTED_2NDEXEC                                      \
        (SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |                         \
         SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |                      \
         SECONDARY_EXEC_APIC_REGISTER_VIRT |                            \
         SECONDARY_EXEC_ENABLE_PML |                                    \
         SECONDARY_EXEC_ENABLE_VMFUNC |                                 \
         SECONDARY_EXEC_SHADOW_VMCS |                                   \
         SECONDARY_EXEC_TSC_SCALING |                                   \
         SECONDARY_EXEC_PAUSE_LOOP_EXITING)
#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL                                  \
        (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |                           \
         VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
#define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)

> and hv-avic only mentions AutoEOI feature.

True, this is hidden in "The enlightenment allows to use Hyper-V SynIC
with hardware APICv/AVIC enabled". Any suggestions on how to improve
this are more than welcome!.

-- 
Vitaly

