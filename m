Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8481F5EC23C
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiI0MQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 08:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbiI0MQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 08:16:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801FE5D0C6
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664280956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4gIdW+kaZcPShts03UbtZEYp9VcUaij+8/o4jlcQpT8=;
        b=YJL0MwpB6a6JMRXjhjrXOEKBxA1751wg7lIsw02lD54hA6bXToV1V9Evorb39OCY2yNmU6
        2KFOe3roJ0A+XKwAE7hC94sfWAyjq91750d38VRNGHKp908a9EayVndczej09Fy700B+ua
        h0KFVcDi6JQm+98YzVgfqkF4Yy0hcqo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-Z_FgGJhAPOS1GRVArr80Lw-1; Tue, 27 Sep 2022 08:15:47 -0400
X-MC-Unique: Z_FgGJhAPOS1GRVArr80Lw-1
Received: by mail-ed1-f69.google.com with SMTP id t13-20020a056402524d00b00452c6289448so7678477edd.17
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4gIdW+kaZcPShts03UbtZEYp9VcUaij+8/o4jlcQpT8=;
        b=WMrvcQeMCGsMp/Em0VIdUfzFp2Zr23eoOgZJKY/sgUbuiHoikGbY6RKvOcQqeh7Z/z
         xIh3X1wv5dBTwa6e1bDN8iws/9b9+Ju/rdA57uXYH28x3GUxPNOZtcaF8yPdj7AzoO9Q
         LwKtGTCDDm4YejDJdjsxTNN9ufHIdIwIiPUmi7PvoljUGn7OiVaYyw1wdJwozJ4SseCx
         jXygBtUXHyp6HAgkx/ROWA3suQkPzGA1tAT/UNt8wycoaLazz+tsP7PlJacCxb0xxZNf
         YMCsF4CWQTlsZMixvDLx5e9bnCm2gIAYvCWl1f4fRq7eAVl4uJsZTvxt/cBdwrFOsJtY
         3aNg==
X-Gm-Message-State: ACrzQf0i1Yu4Dbm+lLSdTszIxNgrnfgmbCvOSaeC+9D7S6bKeUYKQ5S0
        aCJ2GyVdRVNTBV+vGKjNLGFHIBMA5S4zgBWt38iQYY3Q/owwt5L78GgDmJM7unaQ3yTDlHJQ3rK
        xevN7JnZrg7ZL
X-Received: by 2002:aa7:d790:0:b0:457:25de:50e3 with SMTP id s16-20020aa7d790000000b0045725de50e3mr12417976edq.152.1664280945937;
        Tue, 27 Sep 2022 05:15:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6WRRL9WNXxWKIRW7sJNWzLtOxmettBeppob8L4CjVHnCsisEj16cSQYHXTTx3bSZHvNl2sZw==
X-Received: by 2002:aa7:d790:0:b0:457:25de:50e3 with SMTP id s16-20020aa7d790000000b0045725de50e3mr12417965edq.152.1664280945713;
        Tue, 27 Sep 2022 05:15:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id v2-20020aa7d9c2000000b00457c321454asm806885eds.37.2022.09.27.05.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 05:15:45 -0700 (PDT)
Message-ID: <86fa4914-5a47-6bf7-6b31-fffc69e2071c@redhat.com>
Date:   Tue, 27 Sep 2022 14:15:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] kvm: vmx: keep constant definition format consistent
Content-Language: en-US
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <CAPm50aKnctFL_7fZ-eqrz-QGnjW2+DTyDDrhxi7UZVO3HjD8UA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAPm50aKnctFL_7fZ-eqrz-QGnjW2+DTyDDrhxi7UZVO3HjD8UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 17:03, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> Keep all constants using lowercase "x".
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>   arch/x86/include/asm/vmx.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..d1791b612170 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -296,7 +296,7 @@ enum vmcs_field {
>          GUEST_LDTR_AR_BYTES             = 0x00004820,
>          GUEST_TR_AR_BYTES               = 0x00004822,
>          GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
> -       GUEST_ACTIVITY_STATE            = 0X00004826,
> +       GUEST_ACTIVITY_STATE            = 0x00004826,
>          GUEST_SYSENTER_CS               = 0x0000482A,
>          VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
>          HOST_IA32_SYSENTER_CS           = 0x00004c00,
> --
> 2.27.0

Queued, thanks.

Paolo

