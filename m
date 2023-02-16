Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C60C699B57
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 18:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBPRc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 12:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjBPRc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 12:32:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3EE4C6FD
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676568698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yE6DWjPA0uy4lEukhtsKQioBOeWxaIDMJ6RIjkMzS6I=;
        b=LQrgZ6a3P6q0DT2l2DRVQOtAeg4jK5h0yTmYTpk4qbiOBEevsbaj270/QXHrWpjhv0T/4Q
        bdMLiD3CRR4MYWH0gfvZwlA9PJnNgg/K82Kw00rrRVNoE211jZQuV28qqOCGpIuBzCqI+0
        cRiaJIg4wLSOvaEM/gljEumkz4HCXqQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-641-cHhGlerQOyWN5D7dw0ZHuw-1; Thu, 16 Feb 2023 12:31:36 -0500
X-MC-Unique: cHhGlerQOyWN5D7dw0ZHuw-1
Received: by mail-wm1-f72.google.com with SMTP id bd21-20020a05600c1f1500b003dc5cb10dcfso1089154wmb.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 09:31:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yE6DWjPA0uy4lEukhtsKQioBOeWxaIDMJ6RIjkMzS6I=;
        b=ACOzkzZg086RBxMnN91fVs47qakNbsF6WfyksPe96t/dLRviqzC+7Ft4PJsCqpVswV
         doRcNokTg8BO4bUBpAKiCW9q8+wAEwdkm8zOnNiQzWOmPpWltxtCfjBM4AOghHGmNugp
         msEIt9Vw5hX6+gJTAqQ/PUYyvIrug6hXAKOX4JMhgZwwXAZ+boU6Lt3r/1xf3drLfBSz
         LwLqOC4RIvdkuklvcT7L7eMy5jyjkNWpK1P1qld6YT/vnfWJdiNgTQJe84WjZ2c524WF
         B0nX1aYuihDouOTIZsyM1H8adISFiwdjq08eWNVEXSMEWjM5HLVhyEY7xa50i53dHoHj
         zm5Q==
X-Gm-Message-State: AO0yUKVeafZddxoiDgK5jt3E3enTQc4PFlTdP2wcDon4HYJM4S6etue0
        9MowUxDB9eyUkZ12NzuvmU4w41GJijOqcFiPyi31KvfQtl9tefcUCMYfA8UnzBwsJXJBT9n8GdQ
        zqVPgeKnVA/G/
X-Received: by 2002:a05:600c:130f:b0:3dc:557f:6126 with SMTP id j15-20020a05600c130f00b003dc557f6126mr6187463wmf.4.1676568695667;
        Thu, 16 Feb 2023 09:31:35 -0800 (PST)
X-Google-Smtp-Source: AK7set/otRAECTqXJPXEsgsAqmAtspfX2AhpRFul1h0yU9uRtRM6LIOtKZh2cacHdNND69qu7NTrzg==
X-Received: by 2002:a05:600c:130f:b0:3dc:557f:6126 with SMTP id j15-20020a05600c130f00b003dc557f6126mr6187448wmf.4.1676568695373;
        Thu, 16 Feb 2023 09:31:35 -0800 (PST)
Received: from [192.168.10.118] ([93.56.168.140])
        by smtp.googlemail.com with ESMTPSA id n6-20020a05600c500600b003dc433355aasm2406256wmr.18.2023.02.16.09.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 09:30:59 -0800 (PST)
Message-ID: <3da18729-519c-3c66-2274-0c2844b02e05@redhat.com>
Date:   Thu, 16 Feb 2023 18:30:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] kvm: initialize all of the kvm_debugregs structure before
 sending it to userspace
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
References: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/14/23 11:33, Greg Kroah-Hartman wrote:
> When calling the KVM_GET_DEBUGREGS ioctl, on some configurations, there
> might be some unitialized portions of the kvm_debugregs structure that
> could be copied to userspace.  Prevent this as is done in the other kvm
> ioctls, by setting the whole structure to 0 before copying anything into
> it.
> 
> Bonus is that this reduces the lines of code as the explicit flag
> setting and reserved space zeroing out can be removed.

Queued, thanks!

Paolo

> 
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: stable <stable@kernel.org>
> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/x86/kvm/x86.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..50a95c8082fa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5254,12 +5254,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>   {
>   	unsigned long val;
>   
> +	memset(dbgregs, 0, sizeof(*dbgregs));
>   	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>   	kvm_get_dr(vcpu, 6, &val);
>   	dbgregs->dr6 = val;
>   	dbgregs->dr7 = vcpu->arch.dr7;
> -	dbgregs->flags = 0;
> -	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
>   }
>   
>   static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,

