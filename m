Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE1F559D9E
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 17:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiFXPqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 11:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiFXPqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 11:46:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95FFC49699
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656085595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6CumnERO4eqBy8vIzJVaqDPkoDfHA8b36dqB7w4cGGE=;
        b=Pc8VTE1lophRAENHPWehGyltX3Fs0+5foZyCiTgOGfHjNbfPOPosHZbcpR/+oY2hiL4qlA
        8xEXYv/qunbo/Jkt55ObRX8ebf4WGYCjMmJ3NaIP4yd7h+LUDCwqwjENpXXv9d1uKbUq5G
        kON/eJx6O3qJ/9910nrzHZQMHVlkpis=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-4tqrZcgKM-Ghqcn_XHidIA-1; Fri, 24 Jun 2022 11:46:34 -0400
X-MC-Unique: 4tqrZcgKM-Ghqcn_XHidIA-1
Received: by mail-ej1-f71.google.com with SMTP id oz40-20020a1709077da800b00722ef1e93bdso1030189ejc.17
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 08:46:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6CumnERO4eqBy8vIzJVaqDPkoDfHA8b36dqB7w4cGGE=;
        b=QX+HpN4n+Xu037oG5vP+QmHlKdnLzNZRTi5qRhGwdIQa8aNKx3UG4yVwhbCc8hORmm
         W0ZQYGzX4MO51v8I0K+lPiKs+4vXZA4aH1DgkfnrKr9RB2ayptXcmaB5HPzOrsonhd85
         GlXxIFyiJY0VEOV2XalYZ8VL+c0g/1g25yYpXV7umrpn5MpJdpzTyCqM8EfDSZXWNa8Z
         NW/WnNtdVzw1P/e1frITno5/CyFn1mRymxOowWZzo01MeZEHGzSjJV0b16gjIaDdtpBH
         eHMv7fMYJkausPpkFr7NIJh0I8dm+LDwKzPQgsLxWUzcp0tI0eUwPNwRzynCXyeSlQe3
         moaQ==
X-Gm-Message-State: AJIora+OMWDQgpf9fGd8v/nXl+hkUC9yuLOOPHuOQZ0sVAWsUewmJLP/
        OSHHryM2kVYc9VznTZ1hnO2JS+ZaBK+VeVQheYtBTLCb8As7zmMepPECpcj/xN+YWa3EfGR3yAV
        wNTxDUEQ/htCW
X-Received: by 2002:a17:907:6e03:b0:718:f3ee:9e34 with SMTP id sd3-20020a1709076e0300b00718f3ee9e34mr14181352ejc.300.1656085593002;
        Fri, 24 Jun 2022 08:46:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tXsdRDKT9WNA57OsmVUvkBfaXw8Jge2MnvOcD2oItvmiVnmWQKBBsc/Rjn/AL2RTGx90hOow==
X-Received: by 2002:a17:907:6e03:b0:718:f3ee:9e34 with SMTP id sd3-20020a1709076e0300b00718f3ee9e34mr14181326ejc.300.1656085592671;
        Fri, 24 Jun 2022 08:46:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id s12-20020a170906354c00b0072637b9c8c0sm663746eja.219.2022.06.24.08.46.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 08:46:32 -0700 (PDT)
Message-ID: <980f6261-60b2-586d-a480-acadffeacb0b@redhat.com>
Date:   Fri, 24 Jun 2022 17:46:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: selftests: Enhance handling WRMSR ICR register in
 x2APIC mode
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com, Zeng Guang <guang.zeng@intel.com>
References: <20220624154535.2736289-1-pbonzini@redhat.com>
In-Reply-To: <20220624154535.2736289-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oops, sent patch from wrong branch.

Paolo

On 6/24/22 17:45, Paolo Bonzini wrote:
> From: Zeng Guang <guang.zeng@intel.com>
> 
> Hardware would directly write x2APIC ICR register instead of software
> emulation in some circumstances, e.g when Intel IPI virtualization is
> enabled. This behavior requires normal reserved bits checking to ensure
> them input as zero, otherwise it will cause #GP. So we need mask out
> those reserved bits from the data written to vICR register.
> 
> Remove Delivery Status bit emulation in test case as this flag
> is invalid and not needed in x2APIC mode. KVM may ignore clearing
> it during interrupt dispatch which will lead to fake test failure.
> 
> Opportunistically correct vector number for test sending IPI to
> non-existent vCPUs.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Message-Id: <20220623094511.26066-1-guang.zeng@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   .../selftests/kvm/x86_64/xapic_state_test.c   | 20 ++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> index 5c5dc7bbb4e2..87531623064f 100644
> --- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
> @@ -71,13 +71,27 @@ static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
>   	vcpu_ioctl(vcpu, KVM_GET_LAPIC, &xapic);
>   	icr = (u64)(*((u32 *)&xapic.regs[APIC_ICR])) |
>   	      (u64)(*((u32 *)&xapic.regs[APIC_ICR2])) << 32;
> -	if (!x->is_x2apic)
> +	if (!x->is_x2apic) {
>   		val &= (-1u | (0xffull << (32 + 24)));
> -	ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
> +		ASSERT_EQ(icr, val & ~APIC_ICR_BUSY);
> +	} else {
> +		ASSERT_EQ(icr & ~APIC_ICR_BUSY, val & ~APIC_ICR_BUSY);
> +	}
>   }
>   
> +#define X2APIC_RSVED_BITS_MASK  (GENMASK_ULL(31,20) | \
> +				 GENMASK_ULL(17,16) | \
> +				 GENMASK_ULL(13,13))
> +
>   static void __test_icr(struct xapic_vcpu *x, uint64_t val)
>   {
> +	if (x->is_x2apic) {
> +		/* Hardware writing vICR register requires reserved bits 31:20,
> +		 * 17:16 and 13 kept as zero to avoid #GP exception. Data value
> +		 * written to vICR should mask out those bits above.
> +		 */
> +		val &= ~X2APIC_RSVED_BITS_MASK;
> +	}
>   	____test_icr(x, val | APIC_ICR_BUSY);
>   	____test_icr(x, val & ~(u64)APIC_ICR_BUSY);
>   }
> @@ -102,7 +116,7 @@ static void test_icr(struct xapic_vcpu *x)
>   	icr = APIC_INT_ASSERT | 0xff;
>   	for (i = vcpu->id + 1; i < 0xff; i++) {
>   		for (j = 0; j < 8; j++)
> -			__test_icr(x, i << (32 + 24) | APIC_INT_ASSERT | (j << 8));
> +			__test_icr(x, i << (32 + 24) | icr | (j << 8));
>   	}
>   
>   	/* And again with a shorthand destination for all types of IPIs. */

