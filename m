Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3947778A9
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 14:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbjHJMjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 08:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbjHJMjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 08:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121DA268E
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 05:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691671112;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0Wo4ft2/DV+pES3oEs9VkOI6CJR3CbB7D53EzyrdWY=;
        b=BV1ALE3AtVXZRZjebwOkQKd/3fEvgBcNDLN0TfdLsyOSLeh4I+EhmFoKuR67ZsBmreke15
        dkoiNtWDadlfQZniT0CBlAtvmzAE3x7oVslcquh/j5ChVS+g56GmSkS+kYahUavJg7QT/x
        yMhvBtwQfzQONanIf/kZ2S/4PSA3BKk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-Ik-a6oBMOLeI124tkgeIsw-1; Thu, 10 Aug 2023 08:38:31 -0400
X-MC-Unique: Ik-a6oBMOLeI124tkgeIsw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-317b30fedb0so525715f8f.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 05:38:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691671110; x=1692275910;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0Wo4ft2/DV+pES3oEs9VkOI6CJR3CbB7D53EzyrdWY=;
        b=Pmt7JOTIlW3mDwtDwx3wQnaa37pMT0sIgvvldYYvowfQmLRtSfqmP2ASyzVWvl1LA9
         qaKMUG7yeqexlybOcClMgBvBpQfFvou80Dmi29fNVNl7P/bbfmfYb8vaNZ73StfKBl1N
         UAtCAl0AQj8sVJ6HK8tW01P8ZrgGYdKN1Pess0L8v/DzN3Oo3pGKhokASGTSGQpmonBT
         6aPSQtTyuh0iQqGrb/f3lANcfVHSyk/rjgw+mEKLOf9CLHtpiLd+Nkn0WC7vwkb88nd/
         jXLs/cC3IX/ADUtoPIG35OciGV/ixFzzj3TLPte+ylMDum9G5nqg7d/yWcgReIQ2eDjY
         RS9Q==
X-Gm-Message-State: AOJu0YzxVJrNoCnDYMZH06bnZHhYgM9z11Y32i4uJKP303DWQoImDVVJ
        G7GhNNtTi7GFvfHXlQGSuUnBgf7xp66iIAFuQYr2+x0QQvziM6G+UrjPMYAyb3Agii8OQqEvqJX
        7FyquQA4r5P9p
X-Received: by 2002:a5d:61d0:0:b0:313:f463:9d40 with SMTP id q16-20020a5d61d0000000b00313f4639d40mr2256910wrv.65.1691671109948;
        Thu, 10 Aug 2023 05:38:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbXiWhGp1spWUmxlRDOb6WbdU0xknSGtpi8pHz6NkVFa/AtQ/PIb5TpAiXANZhMbQnGi8aQw==
X-Received: by 2002:a5d:61d0:0:b0:313:f463:9d40 with SMTP id q16-20020a5d61d0000000b00313f4639d40mr2256889wrv.65.1691671109649;
        Thu, 10 Aug 2023 05:38:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f18-20020a5d6652000000b003143ba62cf4sm2051508wrw.86.2023.08.10.05.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 05:38:28 -0700 (PDT)
Message-ID: <15fc525c-7357-7457-c3c2-a8211619e787@redhat.com>
Date:   Thu, 10 Aug 2023 14:38:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 26/27] KVM: arm64: Move HCRX_EL2 switch to load/put on
 VHE systems
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
 <20230808114711.2013842-27-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-27-maz@kernel.org>
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
> Although the nVHE behaviour requires HCRX_EL2 to be switched
> on each switch between host and guest, there is nothing in
> this register that would affect a VHE host.
>
> It is thus possible to save/restore this register on load/put
> on VHE systems, avoiding unnecessary sysreg access on the hot
> path. Additionally, it avoids unnecessary traps when running
> with NV.
>
> To achieve this, simply move the read/writes to the *_common()
> helpers, which are called on load/put on VHE, and more eagerly
> on nVHE.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index a4750070563f..060c5a0409e5 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,6 +197,9 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX))
> +		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +
>  	__activate_traps_hfgxtr(vcpu);
>  }
>  
> @@ -213,6 +216,9 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>  	}
>  
> +	if (cpus_have_final_cap(ARM64_HAS_HCX))
> +		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
> +
>  	__deactivate_traps_hfgxtr(vcpu);
>  }
>  
> @@ -227,9 +233,6 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
>  
>  	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
>  		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
> -
> -	if (cpus_have_final_cap(ARM64_HAS_HCX))
> -		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
>  }
>  
>  static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
> @@ -244,9 +247,6 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
>  		vcpu->arch.hcr_el2 &= ~HCR_VSE;
>  		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
>  	}
> -
> -	if (cpus_have_final_cap(ARM64_HAS_HCX))
> -		write_sysreg_s(HCRX_HOST_FLAGS, SYS_HCRX_EL2);
>  }
>  
>  static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

