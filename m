Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545B84D16FC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 13:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbiCHMOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 07:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237459AbiCHMOy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 07:14:54 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4D369E9;
        Tue,  8 Mar 2022 04:13:57 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id q17so24198608edd.4;
        Tue, 08 Mar 2022 04:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ULast/mtgP3p8AMVarXOT+P6lpKHlA0007QiXUEdEFE=;
        b=Wk6UyfUlZnL5SElRH1/AfODLHHDCAsfnpsm7tMMPXyzbSIFQQqmACnv95Du8iVRA7i
         KOVWxH6W9Zflw31j0dQhp4/QeQFp9EoLI5aKRhINYRwWbz6ux2ikSN5+8H0dDRCsh7HE
         PXQHUkG3omcQ8G1KroCdf1K0FM9jSSgcVP+JUGfxQ0q1Z+Pkh7vo9Y2UvM8VvOlOee1r
         HUDtN2TxC2SMIhvUfo+0aJas5zWdQOGmwy0TrzVduKfEzr4MBJrKleNx9ES9fEjDCnFY
         bbeLB7yp8yXEEjlq/9SJ9dvU8PWfw+FWnc+r7TeptTzRbPgLSMADmdPlBwsID7jFp3Nw
         eSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ULast/mtgP3p8AMVarXOT+P6lpKHlA0007QiXUEdEFE=;
        b=7sfVtj79g/56Jl9SoMUP3sz9BC4atvXElIHcpYzcYccEu25RlI8PrglBqegGcC83N+
         MjAMHIhLENEivY+d9LBxMgSkJwi4I4b3+7l50Bj98/xCk1S1GULq7dS34E+siS3QFH0t
         hc1GeTJwnyTWaOHF4x8zSnAWNMWSplC5FLriH3OZp8ozS+11DKJqQO0xfnyJXBMNbaqd
         y57pcxmKCTLQYecAy4LODsiSQJTfvUBo/5NvodB1PbdsuuYj7co2HxVsvrieHULjdAn4
         orT6MKiAGPOnivf1R5UKPcOanDHAuKNUDIZhfl3AJNO5Ab/y7cirMEgj+fIp36HncPml
         E/xA==
X-Gm-Message-State: AOAM533zknjiL7YzC33lYv0uQltZaeTYMlM0e85jHVI23zeZ46t2wNAy
        XBOjg+3I24h4R9bNxd62cd0=
X-Google-Smtp-Source: ABdhPJys53qTU70vOv4UGAljmorZflfU+Rp0CDA2yjzlzyY9aerrFgS941NSU0EEibz7NS8WnkfGvQ==
X-Received: by 2002:a05:6402:374:b0:415:e849:2935 with SMTP id s20-20020a056402037400b00415e8492935mr15560448edw.47.1646741636190;
        Tue, 08 Mar 2022 04:13:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id qb30-20020a1709077e9e00b006d6f8c77695sm5705595ejc.101.2022.03.08.04.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 04:13:55 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <6e57aad6-1322-8a3d-6dfa-ff010a61a9a9@redhat.com>
Date:   Tue, 8 Mar 2022 13:13:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86/kvm: Don't waste kvmclock memory if there is nopv
 parameter
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1646727529-11774-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1646727529-11774-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 09:18, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> When the "nopv" command line parameter is used, it should not waste
> memory for kvmclock.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kernel/kvmclock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index c5caa73..16333ba 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -239,7 +239,7 @@ static void __init kvmclock_init_mem(void)
>   
>   static int __init kvm_setup_vsyscall_timeinfo(void)
>   {
> -	if (!kvm_para_available() || !kvmclock)
> +	if (!kvm_para_available() || !kvmclock || nopv)
>   		return 0;
>   
>   	kvmclock_init_mem();

Perhaps instead !kvm_para_available() && nopv should clear the kvmclock 
variable?

Paolo
