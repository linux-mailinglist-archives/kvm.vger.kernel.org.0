Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ED04D3797
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiCIRBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiCIRBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:01:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 689DC105AAF
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+Ih3YtGyWyTixz3Aclx/Os2sciMyuCYkFjO6tpHUqw=;
        b=KwMOtDO26Zwl7OTFklV1K/LVIPiy9rZ8yEdBOfXTRzhbcEpGEWdmHMxAHXpPOpT8zG2scP
        q3lp99z3ha3AQ5bEXlAAPwiJ+hbwbjbNoL25/18r/nxorQZ7afEUCIZXvuNxH4WwvKVPgB
        /rKoehpAveAPB0Q4A+3iBJrczc/4X54=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-k0pVoWalMtGsbaTXC3qUyw-1; Wed, 09 Mar 2022 11:47:47 -0500
X-MC-Unique: k0pVoWalMtGsbaTXC3qUyw-1
Received: by mail-ej1-f70.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso1606401ejs.12
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:47:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R+Ih3YtGyWyTixz3Aclx/Os2sciMyuCYkFjO6tpHUqw=;
        b=YS6yB1Qt2cSt1RbTCif29mHqYw4OMsNEpZbBep9KKGCGW/Y13Aq8V72DgdG0KFEFc9
         9AdU1NT1wgu3quKnX/rkKwxC2Y/i7Pq/QR4rTRdPPn7QfebqolgQO5I1OPqG6y+0BhCu
         nckzWvGyk0wrTxREQcBgEti1TtsoqC2u3M0lrYjh7teFkW3piJ1A1s8sQsyA0vO9UQ97
         zQn8HM7DAN+Ylj0ID9uE8sZJRNZ7MP+hyahBUIUAgt5r0y2MFmaCZwmtlcmxthI1kUUd
         jjCY/+vlpbUT4paxpP0hi7BVFHa+PUTnHhS8i/7ogJHnbOonRdHvmG+9WFf/1UyH3/1f
         l9eQ==
X-Gm-Message-State: AOAM532EjD0Bg2IVTSZnVLObOm4wBlM4BYZX2sc6rQAc6E/vCyEnrnqs
        BTi8xIh8uYsenU5DhxHNed5XocCRaj2akKe6HVjhYQvKscfORzG9IYlxqTVY/QjcwgsIT+Agt8g
        yvOcc/FbPeO46
X-Received: by 2002:a05:6402:6da:b0:3fd:cacb:f4b2 with SMTP id n26-20020a05640206da00b003fdcacbf4b2mr347238edy.332.1646844465039;
        Wed, 09 Mar 2022 08:47:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv9CwpdD58CoUfTld7CeyhBYPnaNZPQgN9uEBEcu4bVuCDmHzx51HtCSC/TfYvP+E3+h9ELQ==
X-Received: by 2002:a05:6402:6da:b0:3fd:cacb:f4b2 with SMTP id n26-20020a05640206da00b003fdcacbf4b2mr347214edy.332.1646844464775;
        Wed, 09 Mar 2022 08:47:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id f5-20020a17090624c500b006cee6661b6esm950257ejb.10.2022.03.09.08.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:47:43 -0800 (PST)
Message-ID: <4ca2844c-c9df-8eff-5773-17340759d8ea@redhat.com>
Date:   Wed, 9 Mar 2022 17:47:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.4] KVM: x86: Yield to IPI target vCPU only if
 it is busy
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220309164655.138121-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309164655.138121-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 17:46, Sasha Levin wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> [ Upstream commit 9ee83635d872812f3920209c606c6ea9e412ffcc ]
> 
> When sending a call-function IPI-many to vCPUs, yield to the
> IPI target vCPU which is marked as preempted.
> 
> but when emulating HLT, an idling vCPU will be voluntarily
> scheduled out and mark as preempted from the guest kernel
> perspective. yielding to idle vCPU is pointless and increase
> unnecessary vmexit, maybe miss the true preempted vCPU
> 
> so yield to IPI target vCPU only if vCPU is busy and preempted
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Message-Id: <1644380201-29423-1-git-send-email-lirongqing@baidu.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kernel/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6ff2c7cac4c4..77e4d875a468 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -543,7 +543,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

NACK

