Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5E4D3627
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiCIRFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbiCIRDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:03:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D0CF1B2AFD
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ciXf/kDeXmAL/6RIvTYI6KZ9lH0wgG0xeQwUhPXRPo=;
        b=Fr8PVEWzW23g589L41311HRt+hUngvzSxPNGaHcwQ5okgisvfHclXg7yG9lXaY+mjmTLZ0
        bV77WQDF7E6gvs9GtaFBlCxht1s6I9DrMbb5dpuOum34uSWC2Q2hwH142tV/gKse8zuamJ
        25fcuB818slZk9whDmtlikE/i0DLhF8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-noRUaNOMNAORtxw33_d8BA-1; Wed, 09 Mar 2022 11:51:14 -0500
X-MC-Unique: noRUaNOMNAORtxw33_d8BA-1
Received: by mail-wr1-f69.google.com with SMTP id m18-20020a5d4a12000000b00203731460e6so950603wrq.3
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0ciXf/kDeXmAL/6RIvTYI6KZ9lH0wgG0xeQwUhPXRPo=;
        b=g2xb7imSUhmUWFizQLTg+hFYfg8RhvD/ZBtxYGyExc1NDmYGod26d/Vi1DQBKRVG1I
         4RxTCD/ajtkIM3jXjEubJKMG2Nuc3zxNQuVYG6vZI2nFnmyWHmvbov/MfRNFDNm1GhdE
         VYq/rxaM9WXiC5dNvVu1i4Dhk+Cb0USPXXmsBanWvnKehZlZ+qPq9TGB8zFEwT4bRjSp
         s0F+ZQTirE8mSPTBZ/QFVErPKR7+CvItnQMjGKMQy7wW089aTkYDuSWT/+bb7X8XbtJy
         w+BPydKogQ8s8dIyn+3QLqoRwe4FJ6x9/3ETdO6QgxnoCur6HNECr5iurRhymnZyxCbc
         dHcA==
X-Gm-Message-State: AOAM531O4SuNr8Y9aJXfqreCctAwR4TI26T9gL5hcU5f/0hr2WBHg/tC
        em/LPi15OWw7Z66f5rM7L1IoabAxk3Dsmj4vi2xbsDwgoIevIA4fU60Ehj05bOiyHoDYPWt7pqs
        QszT2xeahc9Cr
X-Received: by 2002:a5d:638b:0:b0:203:787e:c17f with SMTP id p11-20020a5d638b000000b00203787ec17fmr424782wru.250.1646844672783;
        Wed, 09 Mar 2022 08:51:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwA+tfh26XUx+xmyq2nalkKMHvS2HVfplNvpDg8s9jAzd4fUnvCw/p4zg7E4ldS/LrrMS6S9w==
X-Received: by 2002:a5d:638b:0:b0:203:787e:c17f with SMTP id p11-20020a5d638b000000b00203787ec17fmr424763wru.250.1646844672560;
        Wed, 09 Mar 2022 08:51:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n15-20020a05600c4f8f00b003842f011bc5sm5877090wmq.2.2022.03.09.08.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:51:11 -0800 (PST)
Message-ID: <e2917bf1-ec0c-65b3-0bb5-a03ed01b0856@redhat.com>
Date:   Wed, 9 Mar 2022 17:51:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10] KVM: x86: Yield to IPI target vCPU only if
 it is busy
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220309164645.138079-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309164645.138079-1-sashal@kernel.org>
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
> index 7462b79c39de..8fe6eb5bed3f 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -590,7 +590,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

NACK

