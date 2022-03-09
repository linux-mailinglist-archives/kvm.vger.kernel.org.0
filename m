Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313464D3632
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiCIRBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiCIRA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:00:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D013105287
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtHZAmMaUYAx0LRBNry1Z8g5yS/lTA9TMVV6Zdqr9HI=;
        b=asmY6VW74wbpHaXred6vhkSQ0VARTFlu5/Cv6hZbED/YxgvP7e62MFXhqivqk3cJBZJEsa
        ohIv4SsdvNeigyMxzlIR+K0NWE3vI4pkpAK13nQnnu5IidhQbzLEienUYT0nrV/VbAvy/O
        cem0iQY7BPNFhrEN7zHOkyiBbct0k2g=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-k3-1firDMnGC3uH8wfOJxg-1; Wed, 09 Mar 2022 11:47:39 -0500
X-MC-Unique: k3-1firDMnGC3uH8wfOJxg-1
Received: by mail-ed1-f72.google.com with SMTP id cf6-20020a0564020b8600b00415e9b35c81so1581723edb.9
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:47:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GtHZAmMaUYAx0LRBNry1Z8g5yS/lTA9TMVV6Zdqr9HI=;
        b=CFb2p21jaqcF7Fn1/qqlOSRBgCyqnAiB5f3pFd5FUt/sOPaypsLmLEBzaBqRcefJ4U
         qjYYuljPpz8Kh2Pxt/BPrF8Tul9lpndTdKl4Fk16zMw5a5lRYihzGTpNprBUp3yzhBDI
         Qjsoo5eiWYiuHGBBHmooTMzo0v0gpvs+4YRHU7ctK9DrBBsmlOh+x5bCUwepOFWI5wvc
         G24xHwoP229TOFlzmYlcAZzTf5gM8k+6uAe+8/jSpywK4frq/ODYNPfDFwqS7vJmKYKx
         iaV79lrNoZZqMTjIUcygUaFaPFDCxbyLTyw2Xgy9ysqs/T0ntruawZq7sXv1PGov4OTV
         hZug==
X-Gm-Message-State: AOAM5327hBDijzCnYQ3ORZmR3JT1iFq/+xlXeKJKWxQmp+fpOV//t5c9
        xX6soryAx0InRB/Pzf6N7kxPzQnMCjJgATDzdSAG9XoY83TngUkLgJyXClwyLR0yiS769XdSuQJ
        Sg6XUdopVsVt9
X-Received: by 2002:a17:907:60ca:b0:6da:8f25:7983 with SMTP id hv10-20020a17090760ca00b006da8f257983mr631821ejc.106.1646844457793;
        Wed, 09 Mar 2022 08:47:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7W66bmqFbu8gYAU5N0gz7/+fCQJtGeEoAcf1WlMCvUxsd/Rx1EWoj8m+ZeeL+r81lz05NDA==
X-Received: by 2002:a17:907:60ca:b0:6da:8f25:7983 with SMTP id hv10-20020a17090760ca00b006da8f257983mr631795ejc.106.1646844457559;
        Wed, 09 Mar 2022 08:47:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id t14-20020a170906608e00b006d1455acc62sm908648ejj.74.2022.03.09.08.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:47:36 -0800 (PST)
Message-ID: <63493d06-0b6c-9993-2315-64033dd041d6@redhat.com>
Date:   Wed, 9 Mar 2022 17:47:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15] KVM: x86: Yield to IPI target vCPU only if
 it is busy
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220309164632.137995-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220309164632.137995-1-sashal@kernel.org>
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
> index b656456c3a94..49f19e572a25 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -565,7 +565,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

NACK

