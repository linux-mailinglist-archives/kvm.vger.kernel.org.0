Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB2A511E7A
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242774AbiD0Q1g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiD0Q0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:26:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 964F6BC2C
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vVPmAljf4Rq+oNSJqgnV7vXLKD2O/E/5jwKdydcKC90=;
        b=eLzLjRKZ7QnSImdSJgqAwWYquI0mTsFYxYSi+05kFCjakM/aYj9RPJPRzziYvnm69JtU1N
        86wsyE/3MnlsLk/kVt++UmKf+ZOO++D7nnmY0Ws6PBRzC6eOE10IlyuDE1vhHPS3LcRDaK
        gTA0x9qhWBzJGVXnih/QWguHUsYMO4A=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-SWWDyI7HPUWifiWLi9po7w-1; Wed, 27 Apr 2022 12:20:49 -0400
X-MC-Unique: SWWDyI7HPUWifiWLi9po7w-1
Received: by mail-ej1-f71.google.com with SMTP id o8-20020a170906974800b006f3a8be7502so1455880ejy.8
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vVPmAljf4Rq+oNSJqgnV7vXLKD2O/E/5jwKdydcKC90=;
        b=pZfXcOgqLvU+qY+marRGhsNJPCs7mfsIdwomjYcgcL60hFzIpPE87pApZ/PBgzyFll
         bPauJIV8Qi3CU5Jb6runlN2fP0PAx/tZL+e5ORlDaWacAQP3e7ig/poAhBA8j/PgbITK
         T98zOaZZh6jncfmFju5qP4x5RkLPx5XwR+Dvldmol/ZM5VYwW5dsxa19UH3U2vKzsr/D
         EgCS1GfGRg2jcWjlMiG8BZBx8hGBkDFclUBsw2oL/khn5YR96dAr1JLYvHscxS5y3jPs
         g9O71YjMSf4TzkDWrUX6FZFG3luGcJUCIiG7pD+9/Ma7hWs2skT+Ki3lx3ZQDtBn3myS
         dOsA==
X-Gm-Message-State: AOAM533dfwGFilTL6wv/iLkQ3cVADKZji2kApRBGdOLrbYQ0uu1eO5dX
        lHuvkQ3D0QyOe+ZFGZTKKjDysfgUZxGrtkNU6h77LQgSKJnuXHYRu93CdUDGgOvmtoY6z0Q+qMs
        CC+4HYUT3ROpd
X-Received: by 2002:a17:907:2d11:b0:6f0:f39:f647 with SMTP id gs17-20020a1709072d1100b006f00f39f647mr26641611ejc.694.1651076448693;
        Wed, 27 Apr 2022 09:20:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXmviWfjwPmeeCW7yQt3igdzgO0LD3hEcXQeDEytyOjaJsiyJkYY1xJLviJ6oRtfVvEVVy0A==
X-Received: by 2002:a17:907:2d11:b0:6f0:f39:f647 with SMTP id gs17-20020a1709072d1100b006f00f39f647mr26641584ejc.694.1651076448478;
        Wed, 27 Apr 2022 09:20:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 17-20020a170906059100b006cee1bceddasm6870663ejn.130.2022.04.27.09.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:20:47 -0700 (PDT)
Message-ID: <9eaa82a4-3dba-1ab2-ca2c-8f59252c863b@redhat.com>
Date:   Wed, 27 Apr 2022 18:20:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 7/7] KVM: LAPIC: Enable timer
 posted-interrupt only when mwait/hlt is advertised
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Aili Yao <yaoaili@kingsoft.com>,
        Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-7-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-7-sashal@kernel.org>
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

On 4/27/22 17:54, Sasha Levin wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> [ Upstream commit 1714a4eb6fb0cb79f182873cd011a8ed60ac65e8 ]
> 
> As commit 0c5f81dad46 ("KVM: LAPIC: Inject timer interrupt via posted
> interrupt") mentioned that the host admin should well tune the guest
> setup, so that vCPUs are placed on isolated pCPUs, and with several pCPUs
> surplus for *busy* housekeeping.  In this setup, it is preferrable to
> disable mwait/hlt/pause vmexits to keep the vCPUs in non-root mode.
> 
> However, if only some guests isolated and others not, they would not
> have any benefit from posted timer interrupts, and at the same time lose
> VMX preemption timer fast paths because kvm_can_post_timer_interrupt()
> returns true and therefore forces kvm_can_use_hv_timer() to false.
> 
> By guaranteeing that posted-interrupt timer is only used if MWAIT or
> HLT are done without vmexit, KVM can make a better choice and use the
> VMX preemption timer and the corresponding fast paths.
> 
> Reported-by: Aili Yao <yaoaili@kingsoft.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Cc: Aili Yao <yaoaili@kingsoft.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> Message-Id: <1643112538-36743-1-git-send-email-wanpengli@tencent.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/lapic.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 83d1743a1dd0..493d636e6231 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -113,7 +113,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>   
>   static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
>   {
> -	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> +	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> +		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
>   }
>   
>   bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

