Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C073677B5A5
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 11:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjHNJkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 05:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbjHNJjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 05:39:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C23C1723
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692005876;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UMVQwV2rUoWUqSvlE90BxYjgE4xdcHRUCKaIBUbHGo=;
        b=FbDw8xi0Mc+mqFP4qq1s/rI74MUVNkboagUZo6pWgYyiTZgfpilvRVASBSKJwkrZZq+HG2
        S4n/peqOh2SE/c6ixFfWaMeteJmAnyUG/OWK0B1T0LeCmSmSTZU3ZDXzTsghENTzk9DOcU
        f7VuaiHfV2TMJCCYBNtuTO+8+B5xYso=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-ZlcxJULiMD6YH25ku9yhMA-1; Mon, 14 Aug 2023 05:37:55 -0400
X-MC-Unique: ZlcxJULiMD6YH25ku9yhMA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-40fdb989957so63355861cf.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 02:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692005873; x=1692610673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6UMVQwV2rUoWUqSvlE90BxYjgE4xdcHRUCKaIBUbHGo=;
        b=GkVnR0Ygv4GkC+V9EaNLpw8Q+UsJkajKMvFtHsLe6lUnL5S0u2IfgXHJUHiSCJt70b
         ZTkfCoSxRdc13uD0OkW/Boz61EwOfO4sT2IMkYbr5mHCsyxsmuK2qFb/yErY/UytyQRm
         Pws4wYlQwr0EPlcempyh3fhEIvPynM+XTH7XCuigl//bhJEA7HX3ODmUXggr2bx693wg
         MM3dRMKiy5aZaN8wRVqNh9mksYhkS/rd2OfX+wXKZPWo54HLvMf2mTM6ZW/FKDnS9aCi
         Tt5KBUJnt0cWbAsRhUrEhhuycrc6uw0M+sVt4EP1eYH2wUOOYzCBis/ErzW3Q5+rLhCy
         /Kyw==
X-Gm-Message-State: AOJu0YyNRnscZiMo8O5tWKbxzLcrLFR6UQqUTe7rp6j+0vlv10dqpS8B
        jyEFCbjXGZiOo4OHfHL+JmxeMEkoA7K981H1SYdAlhRMrQDV/jlqi25nQwMxlIcE1THwaNM08P5
        hqzaYjFBDcoUJJSi7n3cs
X-Received: by 2002:ac8:570a:0:b0:403:6ac5:e761 with SMTP id 10-20020ac8570a000000b004036ac5e761mr12853499qtw.62.1692005873555;
        Mon, 14 Aug 2023 02:37:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0lAfb5V+jcAmkdMUWENM/cDVWzSccIaYQkbJhIrzb3dcQbbMk8WUbXBkdEvwwlbiesHpERA==
X-Received: by 2002:ac8:570a:0:b0:403:6ac5:e761 with SMTP id 10-20020ac8570a000000b004036ac5e761mr12853490qtw.62.1692005873339;
        Mon, 14 Aug 2023 02:37:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id j14-20020a0ce00e000000b00646e0411e8csm1728993qvk.30.2023.08.14.02.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 02:37:52 -0700 (PDT)
Message-ID: <a96a13b5-baaa-3180-9a82-d63f3ccbe7d2@redhat.com>
Date:   Mon, 14 Aug 2023 11:37:48 +0200
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

