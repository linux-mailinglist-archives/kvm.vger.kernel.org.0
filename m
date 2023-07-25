Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F7F761F5C
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 18:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjGYQrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 12:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjGYQrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 12:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2AC2D49
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690303503;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvn6KHlfQDuo3hpCXTqrMNakv6fvts1e1JRxx8Q4D20=;
        b=c51loiJUUpM8MkmT3uYhpuA4tFb85+NU3aVSgq5LJFefKBaM89baX9s6JwUv1VGiOnEyQI
        Vb3bru2q4hE0I4s2FqqoKQoQv6+2FZJfWddEjNMSEouwuOIhdY0jbXliPbjtBWJl1BEmDj
        R4z+FjPahvjed3r/GiDJCR2GsRC9G7o=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-gzoL-KYLNWWE8RqLGVHdCA-1; Tue, 25 Jul 2023 12:45:01 -0400
X-MC-Unique: gzoL-KYLNWWE8RqLGVHdCA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4fb76659d54so4927869e87.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 09:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690303500; x=1690908300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvn6KHlfQDuo3hpCXTqrMNakv6fvts1e1JRxx8Q4D20=;
        b=T14pgg4c1X2txWnshvxzKmS8RcCBMe7WYONaPGYWYFtggh3DQ4YLgraWFh9BJKx0fc
         1f+8xR3ziAdue30o1Y2Xcn4I6f8DFkWpGSgblgrCvFJpL9FIF+nkzHvwmDFZeQ2e6357
         ptrWxY2nWXAr+u2vfwnFnQQa2UzMJv/hKLX0lAZYUw9gqbzWXGLoWfK4382RQ4ai5o5X
         dI485Ny3BXeDGIQ2odDR4qeA2EwlNdGlDONG24Eqr7OYFFn6kTGDO9sFikRokBqxCUcb
         JYR3I9KlLFwX7e0V958iGMDMa9z6jdJEMurqVajMzYXoCHgSCrn2lA3MMZm9GEVO9j8m
         sFoQ==
X-Gm-Message-State: ABy/qLYGkdnOAxqDc1uglXIK+KHNnDkjCEt3WswVmdknw0U50CgNhQ29
        210zrjGhuIHg8GzFArtNI22+TqpP/yUndWGxbm1BXYD4v7oJTj+ho2ncLGL0lfAnC3VS7lItzD2
        Nf3YS1NY3EkZa
X-Received: by 2002:ac2:5239:0:b0:4fc:6e21:ff50 with SMTP id i25-20020ac25239000000b004fc6e21ff50mr7111887lfl.55.1690303500073;
        Tue, 25 Jul 2023 09:45:00 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEby/vcaKSjGkDJ1lyXqDzRuHrqzwbjpqloRTr9TiHpIvTT/1kpST/4Zd3MSPrUL8HU9FBzgQ==
X-Received: by 2002:ac2:5239:0:b0:4fc:6e21:ff50 with SMTP id i25-20020ac25239000000b004fc6e21ff50mr7111854lfl.55.1690303499680;
        Tue, 25 Jul 2023 09:44:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id t2-20020adfeb82000000b0031759e6b43fsm9082752wrn.39.2023.07.25.09.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 09:44:59 -0700 (PDT)
Message-ID: <b8189658-4fa9-d3b9-8d24-bf04781ad0cd@redhat.com>
Date:   Tue, 25 Jul 2023 18:44:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 17/27] KVM: arm64: nv: Expose FEAT_EVT to nested guests
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
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-18-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-18-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/23 16:58, Marc Zyngier wrote:
> Now that we properly implement FEAT_EVT (as we correctly forward
> traps), expose it to guests.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/nested.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 315354d27978..7f80f385d9e8 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -124,8 +124,7 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>  		break;
>  
>  	case SYS_ID_AA64MMFR2_EL1:
> -		val &= ~(NV_FTR(MMFR2, EVT)	|
> -			 NV_FTR(MMFR2, BBM)	|
> +		val &= ~(NV_FTR(MMFR2, BBM)	|
>  			 NV_FTR(MMFR2, TTL)	|
>  			 GENMASK_ULL(47, 44)	|
>  			 NV_FTR(MMFR2, ST)	|

