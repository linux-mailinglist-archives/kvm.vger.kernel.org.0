Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC8255D589
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbiF0PNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbiF0PNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9872B2AD2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656342782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ARdvDRYqFQEpUSYWNh7p3WDzIDlCQtznR2856ZwQR38=;
        b=gW6/t2nJH8PAXDixQuQKnj/aHKA22vqsvEjs2CKz3/J+I8ul3HapcF9EMvCfJOzpnxtSvb
        uuz0iVQXIClDIDSuR+zbt4wqYNr9hy2OcZ08yY8ovSSMY+DeeeIT8ddSJ/rrTvIkZ51A8M
        rGkXTIt27RCmjiGsvEMsEpJVAC7+KoQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-gmHI5mLzO4us29u2vd9IIA-1; Mon, 27 Jun 2022 11:13:01 -0400
X-MC-Unique: gmHI5mLzO4us29u2vd9IIA-1
Received: by mail-ej1-f70.google.com with SMTP id s4-20020a170906500400b006feaccb3a0eso2553062ejj.11
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ARdvDRYqFQEpUSYWNh7p3WDzIDlCQtznR2856ZwQR38=;
        b=FDBb8CV/G9hSpYL5GMiYosymx8qBSkeNw0MqzD9kIzIjq2CYB+EJ6Qj8eNDQNNZcgg
         rFuidjCDasCn6FJ8Qzie5UBOKz9/t54zWdqDJiDNUsbAbSYCKASUP52Lql6LpLNL63yc
         gKARzSIPS+8nHV8e2sghW3rUAkxd3OnWdWxb2ChchhMmgY/GqK/QPJdtIHwCBfm6JRop
         wzggjn7r4YS8yW4OjvpVWl4jfnuKbmotRgpe82fghXQjR88x3lfVE6fcz63E3pOTIEBE
         On6Vnpbl2olCxZX3xQ+AYpTSCvNJz7odSGtM0cIfrGVcvtQlG5vGeR9Va9jIZHypLm3b
         TPpw==
X-Gm-Message-State: AJIora/M44pcRfLasxOsESAZyBoblJXfLRYUd1tvnWvavwy/NjgD4igP
        qhribQag+fRHoSSBCrPqXh9DBE4HSjikFQ+GBhEcXkskGeTc4TgWca6YSPDpymtwoEs9SqXhFXJ
        S6BjqoZNR8xYu
X-Received: by 2002:a17:906:5512:b0:726:be2c:a2e5 with SMTP id r18-20020a170906551200b00726be2ca2e5mr2270027ejp.88.1656342779600;
        Mon, 27 Jun 2022 08:12:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ujLOPA2JVmlJ+R4KMLfx0HjYsH41cRwgwuV7mZUbliS5V6Ns2xRIbDBxPpYaLhiDmvcPjGPQ==
X-Received: by 2002:a17:906:5512:b0:726:be2c:a2e5 with SMTP id r18-20020a170906551200b00726be2ca2e5mr2270015ejp.88.1656342779400;
        Mon, 27 Jun 2022 08:12:59 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w13-20020a170906d20d00b00726298147b1sm5049433ejz.161.2022.06.27.08.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 08:12:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 02/10] KVM: VMX: Add missing CPU based VM
 execution controls to vmcs_config
In-Reply-To: <YrUBYTXRxBGYsd1a@google.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
 <20220622164432.194640-3-vkuznets@redhat.com>
 <YrUBYTXRxBGYsd1a@google.com>
Date:   Mon, 27 Jun 2022 17:12:58 +0200
Message-ID: <87wnd2uolh.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Maybe say "dynamically enabled" or so instead of "missing"?
>

...

> On Wed, Jun 22, 2022, Vitaly Kuznetsov wrote:
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 15 ++++++++++++++-
>>  1 file changed, 14 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 24da9e93bdab..01294a2fc1c1 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2483,8 +2483,14 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>  	      CPU_BASED_INVLPG_EXITING |
>>  	      CPU_BASED_RDPMC_EXITING;
>>  
>> -	opt = CPU_BASED_TPR_SHADOW |
>> +	opt = CPU_BASED_INTR_WINDOW_EXITING |
>> +	      CPU_BASED_RDTSC_EXITING |
>> +	      CPU_BASED_TPR_SHADOW |
>> +	      CPU_BASED_NMI_WINDOW_EXITING |
>> +	      CPU_BASED_USE_IO_BITMAPS |
>> +	      CPU_BASED_MONITOR_TRAP_FLAG |
>>  	      CPU_BASED_USE_MSR_BITMAPS |
>> +	      CPU_BASED_PAUSE_EXITING |
>>  	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
>>  	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;

CPU_BASED_INTR_WINDOW_EXITING and CPU_BASED_NMI_WINDOW_EXITING are
actually "dynamically enabled" but CPU_BASED_RDTSC_EXITING/
CPU_BASED_USE_IO_BITMAPS/ CPU_BASED_MONITOR_TRAP_FLAG /
CPU_BASED_PAUSE_EXITING are not (and I found the first two immediately
after implementing 'macro shananigans' you suggested, of course :-), KVM
just doesn't use them for L1. So this is going to get splitted in two
patches.

-- 
Vitaly

