Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0939041D5E4
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349171AbhI3JCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 05:02:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348335AbhI3JCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 05:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632992434;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moU+7B0e6GAwk20kCPZuVoIHcKpWH+cvFU2qvdImZH8=;
        b=HP0R63llqPA0KlQsCAaU4xfxuzlEJKeUihAMcyNizYQNhLc/tD1z7Iu84ZWCnPcTnv1xJV
        ecBCsRFqBWiFfah3yRDdY0p/aARoOvBDEOC2fGPHJ1M1j2XFlJ6bktbwrelqpvGYUxVKcs
        2/Nxu2nlUaE4d6RXLrVz5BHklwkaWAg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-tDDBXgvQOmeNRGVOcSvgfQ-1; Thu, 30 Sep 2021 05:00:32 -0400
X-MC-Unique: tDDBXgvQOmeNRGVOcSvgfQ-1
Received: by mail-wm1-f70.google.com with SMTP id j21-20020a05600c1c1500b0030ccce95837so1715282wms.3
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 02:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=moU+7B0e6GAwk20kCPZuVoIHcKpWH+cvFU2qvdImZH8=;
        b=RQnv9OUnVWoQ4f2cXlNEsvdqj/N24P6W0nLB7TtSKk8taw9SEwgETylmFbpHHvEsjD
         fXJEDbTiEpbhRwOG21m5sM9ohbwY7Dp66kwTNmynkM5yrvodmdPrMl0MOLFZMS+G7s8o
         UClqj4O8vpeI8nAaNlfiBi5imHqBrBEC8Q8O8GCXnRsqN/iBpYt1QNfoOMjHm8/aHNx1
         gxNf81g7qeYi0WbCVkZWyUcMnUvoeDLDBKTRQjgtUucoyLLFZnfJKmfnbx9i/TyBFZSq
         vG/UQIlhIwc6+yuDEWori6q+m+DRctKJq9AVvbsUvbzdYB91UrwarU4CkyW4Cr657aGP
         GtOw==
X-Gm-Message-State: AOAM530Htf2mxZY+80SCDzoU+PumAfdjQ0x+jBFl1zUBnsYXnrDhe7TI
        TLid+AQwmnsQaQSTL43uskYV9lu6BvwcAXos5CzgxlD4ASV7Yu3nx2cZUKYJcbRSzF+xxcZE5Ev
        m1vc/H/LURF5E
X-Received: by 2002:a5d:5255:: with SMTP id k21mr4845887wrc.421.1632992431049;
        Thu, 30 Sep 2021 02:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOLCH0kASjSLU5nF/dpC0BtrKbKaslmi2d2ORJoeYA7immIc46GSd/795Jm2ytJfdQZ7YycA==
X-Received: by 2002:a5d:5255:: with SMTP id k21mr4845868wrc.421.1632992430873;
        Thu, 30 Sep 2021 02:00:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d8sm2508461wrv.80.2021.09.30.02.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 02:00:30 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 09/10] KVM: arm64: selftests: Add test for legacy GICv3
 REDIST base partially above IPA range
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-10-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b97a5ef9-d598-78f5-3ccf-d650ecc256c8@redhat.com>
Date:   Thu, 30 Sep 2021 11:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-10-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/21 8:48 PM, Ricardo Koller wrote:
> Add a new test into vgic_init which checks that the first vcpu fails to
> run if there is not sufficient REDIST space below the addressable IPA
> range.  This only applies to the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API
> as the required REDIST space is not know when setting the DIST region.
>
> Note that using the REDIST_REGION API results in a different check at
> first vcpu run: that the number of redist regions is enough for all
> vcpus. And there is already a test for that case in, the first step of
> test_v3_new_redist_regions.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 77a1941e61fa..417a9a515cad 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -570,6 +570,39 @@ static void test_v3_last_bit_single_rdist(void)
>  	vm_gic_destroy(&v);
>  }
>  
> +/* Uses the legacy REDIST region API. */
> +static void test_v3_redist_ipa_range_check_at_vcpu_run(void)
> +{
> +	struct vm_gic v;
> +	int ret, i;
> +	uint64_t addr;
> +
> +	v = vm_gic_create_with_vcpus(KVM_DEV_TYPE_ARM_VGIC_V3, 1);
> +
> +	/* Set space for 3 redists, we have 1 vcpu, so this succeeds. */
> +	addr = max_phys_size - (3 * 2 * 0x10000);
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> +
> +	addr = 0x00000;
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			KVM_VGIC_V3_ADDR_TYPE_DIST, &addr, true);
> +
> +	/* Add the rest of the VCPUs */
> +	for (i = 1; i < NR_VCPUS; ++i)
> +		vm_vcpu_add_default(v.vm, i, guest_code);
> +
> +	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> +			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> +
> +	/* Attempt to run a vcpu without enough redist space. */
> +	ret = run_vcpu(v.vm, 2);
> +	TEST_ASSERT(ret && errno == EINVAL,
> +		"redist base+size above PA range detected on 1st vcpu run");
> +
> +	vm_gic_destroy(&v);
> +}
> +
>  /*
>   * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
>   */
> @@ -621,6 +654,7 @@ void run_tests(uint32_t gic_dev_type)
>  		test_v3_typer_accesses();
>  		test_v3_last_bit_redist_regions();
>  		test_v3_last_bit_single_rdist();
> +		test_v3_redist_ipa_range_check_at_vcpu_run();
>  	}
>  }
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

