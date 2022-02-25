Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCC54C4852
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiBYPJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbiBYPJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:09:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C8407EA25
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 07:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645801727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jUXZmzBpYy5swSUohHDG1AWOxZt7pIKPWxE0sospvwE=;
        b=dx857KxOtijUD7D/dyPlzrpw8QI+HSbFFn8Eq+FYGCU0ld+H4MHgHfWb68qkRqsq0W00Vt
        HV1BvhpK89Pcmu0rosl6k6/DEppm3jv/BtkiTZweLsbXBbFPtlIXimNnd1Yx7fztk0sWhf
        25scOnOYBxcQOtSSR7N1TZMtLw6re1A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-4LN60VKnMvy6wu3P73yfog-1; Fri, 25 Feb 2022 10:08:45 -0500
X-MC-Unique: 4LN60VKnMvy6wu3P73yfog-1
Received: by mail-wr1-f70.google.com with SMTP id v17-20020adfa1d1000000b001ed9d151569so976261wrv.21
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 07:08:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jUXZmzBpYy5swSUohHDG1AWOxZt7pIKPWxE0sospvwE=;
        b=p+dal7q0Ui9/A3LDiZ4xeASgvdWkKcxaEJv4LluNqXBFsg7MCdHWk811jT5WrhYzSC
         uBiOEgxOeQPOrr5xs1jYcA1WA+z869/mwxV1/LZfak2qZmAukK+odz+1JxoAa0brCWo3
         5PDVD/C62oHkisolGXEjGV6SgCS4UwRfkrcsSt1TDHbhwq5+92DR2J5pksKIt2otFqI3
         J4OJ8eAQqbD/0qjZowmF5+8VuFOzX78OGLn9NJP3FDMjloRjmTbXTKBfS+gMprns4JYJ
         iIWNhDqB33gP5sgloTa5uNzeg+2gMth84wWO9cMgfZHc9MA22AG5d02qxilspCkxwuqD
         SEnw==
X-Gm-Message-State: AOAM531zx62DTpZyKxkDtKYi3BaBuZAalC9jBsXy2jlUPKX9Q69I+q49
        e8W2jyR8y3HdgPNbcWr07KppEpSxHEu2oF330/8E8WTwY1MwcPIGtHtlrprOOL1mdduAIzjfuK5
        LSCL+exlo0XsS
X-Received: by 2002:a5d:4a12:0:b0:1ea:8bd1:23d8 with SMTP id m18-20020a5d4a12000000b001ea8bd123d8mr6312207wrq.437.1645801724687;
        Fri, 25 Feb 2022 07:08:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0ykFwyQfmvHSVnN+VCU5IumShwCH3xBplNxcMW70fJjMa2VfuscofmrSCfKdrX9n6G92ZdA==
X-Received: by 2002:a5d:4a12:0:b0:1ea:8bd1:23d8 with SMTP id m18-20020a5d4a12000000b001ea8bd123d8mr6312196wrq.437.1645801724486;
        Fri, 25 Feb 2022 07:08:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id e17-20020a05600c219100b0038114228b81sm4702057wme.2.2022.02.25.07.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 07:08:43 -0800 (PST)
Message-ID: <ed14d672-b6d7-40f7-3329-ccb36f46b01a@redhat.com>
Date:   Fri, 25 Feb 2022 16:08:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Yield to IPI target vCPU only if it is busy
Content-Language: en-US
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org,
        x86@kernel.org, jmattson@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, seanjc@google.com, peterz@infradead.org
References: <1644380201-29423-1-git-send-email-lirongqing@baidu.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1644380201-29423-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 05:16, Li RongQing wrote:
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
> ---
>   arch/x86/kernel/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 355fe8b..58749f2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -619,7 +619,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
>   
>   	/* Make sure other vCPUs get a chance to run if they need to. */
>   	for_each_cpu(cpu, mask) {
> -		if (vcpu_is_preempted(cpu)) {
> +		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
>   			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
>   			break;
>   		}

Queued, thanks.

Paolo

