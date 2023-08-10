Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA36D777313
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjHJIg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 04:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbjHJIg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 04:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26552107
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 01:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691656547;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jk538eFMrHIWa3w11rqlSGvFFMXijrmVWJBtVe7uM/A=;
        b=RSr3MXVpHUiWLc9b8sXs810C3Pvsbh8QQd4q86BrY7mmFHv+m2Uu+dAYY6iihu9YUYLqKR
        /OnIKwhmIsZiPxS0R+IEKK5sntaWYDyA9wH2TJJKKqL6Mt4x7/T7YttWmAonVBq0s9MuyT
        WrUJl3Di7i71z1nfaj7pHA3Pvdrq3Wo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-8r6cZyZXMqmhOhhdW2-E9w-1; Thu, 10 Aug 2023 04:35:45 -0400
X-MC-Unique: 8r6cZyZXMqmhOhhdW2-E9w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe2477947eso3841705e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 01:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691656544; x=1692261344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jk538eFMrHIWa3w11rqlSGvFFMXijrmVWJBtVe7uM/A=;
        b=LQCRWs4hR/Ff47p1X3M7svEFmbpRcjIAEs/JgRrGPFYqK67LFtzam/f09HBNFSt3Th
         0/Q72amQVCbjVnu8Hi+3fgSAM6aqQJmq4nnIm1g7/EgBTx+HM4ms7qRJB4L4VYc3Vr+1
         x8OGMWFYOpJltOld8Bnjc/Zol6r57cut4QieuHUsHkO9Q0kMopxzBwxpDcp0Thh5UYhU
         M+ldx12gXemMcoMLwsVzyo/OcY+6ASXh5/ifEw608pogS6FV+ZXf9FYLP83JqHqPCjtz
         jkoztKAQCNnJ0h3Zjg/zPX4vCEJbNHFfOK46oUSMcP64Adt97I7vdDlFBBrd8tNHF5PN
         4Bnw==
X-Gm-Message-State: AOJu0YwfJWuwBW9D1mBdSyGKituD2gwZswkk2cmvlSWB+AARmNltb2/O
        lCFkM3zlZU46awR7rOgYdyLM/Wr229XOzTbt6ZS54jNg5bL2A/cA/No/pxAdy0pyk4ib66nA7fM
        yB+Ya8Qyqgio4
X-Received: by 2002:a05:600c:2295:b0:3fb:e356:b60d with SMTP id 21-20020a05600c229500b003fbe356b60dmr1385046wmf.38.1691656544717;
        Thu, 10 Aug 2023 01:35:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKj1rJEmsV9LAdJXON8lV0H8i55xE2G2qoBc8w5J7RMLtkQJBRrLaKFMG6nBkIeF2lX3uNwA==
X-Received: by 2002:a05:600c:2295:b0:3fb:e356:b60d with SMTP id 21-20020a05600c229500b003fbe356b60dmr1385038wmf.38.1691656544383;
        Thu, 10 Aug 2023 01:35:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n20-20020a7bc5d4000000b003fe2a40d287sm1413364wmk.1.2023.08.10.01.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 01:35:43 -0700 (PDT)
Message-ID: <2a751a64-559e-cb17-4359-7f368c1b42ca@redhat.com>
Date:   Thu, 10 Aug 2023 10:35:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 23/27] KVM: arm64: nv: Add SVC trap forwarding
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-24-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-24-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/8/23 13:47, Marc Zyngier wrote:
> HFGITR_EL2 allows the trap of SVC instructions to EL2. Allow these
> traps to be forwarded. Take this opportunity to deny any 32bit activity
> when NV is enabled.

I can't figure out how HFGITR_EL2.{SVC_EL1, SVC_EL0 and ERET} are
handled. Please could you explain.

Eric
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/arm.c         |  4 ++++
>  arch/arm64/kvm/handle_exit.c | 12 ++++++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..8b51570a76f8 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -36,6 +36,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/kvm_pkvm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/sections.h>
> @@ -818,6 +819,9 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
>  	if (likely(!vcpu_mode_is_32bit(vcpu)))
>  		return false;
>  
> +	if (vcpu_has_nv(vcpu))
> +		return true;
> +
>  	return !kvm_supports_32bit_el0();
>  }
>  
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 6dcd6604b6bc..3b86d534b995 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -226,6 +226,17 @@ static int kvm_handle_eret(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_svc(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * So far, SVC traps only for NV via HFGITR_EL2. A SVC from a
> +	 * 32bit guest would be caught by vpcu_mode_is_bad_32bit(), so
> +	 * we should only have to deal with a 64 bit exception.
> +	 */
> +	kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -239,6 +250,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
>  	[ESR_ELx_EC_SMC64]	= handle_smc,
> +	[ESR_ELx_EC_SVC64]	= handle_svc,
>  	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
>  	[ESR_ELx_EC_SVE]	= handle_sve,
>  	[ESR_ELx_EC_ERET]	= kvm_handle_eret,

