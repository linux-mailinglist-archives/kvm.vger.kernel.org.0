Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3E07CB372
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjJPTqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbjJPTqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE2FB4
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697485513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZ+lM6qiUe430iAXN5s22ta/PRg8BuZiUs2eY9X5sX4=;
        b=TybcCOhhIEEA1rZXE2ppZ2w5ER3UWMZSc+G6GVo/EF4Ys8vY+MYX6gD7zcR2nIkAid+s88
        PI7HDkNRflqxUCk0FEFGE5SyO+6/t6FgadEIm+hsLblJVj5baW4QQxNlAhMNbwYOl4WG0f
        Z8FKR7/CK0EYspPGZt0JXQXvRE4NpAQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-t8iQ2S6oPxiKWcj9xNaBQA-1; Mon, 16 Oct 2023 15:45:12 -0400
X-MC-Unique: t8iQ2S6oPxiKWcj9xNaBQA-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4199725b054so58337061cf.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697485512; x=1698090312;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZ+lM6qiUe430iAXN5s22ta/PRg8BuZiUs2eY9X5sX4=;
        b=mw0PRt51jylJRp1kZxAYq9jcxtjvSvgSYVCyQxMifi3c/xB4nIuBeJPT6mYwbYjUbt
         mVDvOg8VoKAQgQnK4nbViJBmSrE9Hxb9U/qd3SyP8TblHxKBqJknObyghrCDbC12kytE
         pn56wUdkx5ktwB3kK+b8dx8F8JTTFybMVlbFbSN2ehFThmpGI//TCfIiBLghSb4icWQR
         H23KCUjhmgZ6LEBJ7WFj05AyK6AJmMXZKUO8D9z5o7PL0NZ13Ur4MJICSuIWmjSk/0us
         Fb8kGVq+xPJRYohpWKcM9muJo5QcoMKyFFI3r492lvGXnbEMGwzZPHQvlecfdjPqlUmn
         4MZg==
X-Gm-Message-State: AOJu0YwuDt5AiL4jlw0sCtAB8cQ0NsRB0Rx4Ltj16PA1SpjTC3I6bMwb
        qOC8jyX8+krUtSmY0f5HCCvxxXI5AXmnjFp2FYsYheLVBB61uVcBoV7T+GuTd8B2lk3Gd1xaw0M
        ueFEIK4p3NSzz
X-Received: by 2002:a05:622a:1647:b0:40f:ce6d:775e with SMTP id y7-20020a05622a164700b0040fce6d775emr358697qtj.42.1697485511799;
        Mon, 16 Oct 2023 12:45:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+BVq+KUxheztoApR7LQWN+TLgEn9lkpkOXaqFKlCFxMhMymfU8fkOizIZF+6mTbltVn/Xxg==
X-Received: by 2002:a05:622a:1647:b0:40f:ce6d:775e with SMTP id y7-20020a05622a164700b0040fce6d775emr358668qtj.42.1697485511520;
        Mon, 16 Oct 2023 12:45:11 -0700 (PDT)
Received: from [192.168.43.95] ([37.170.191.221])
        by smtp.gmail.com with ESMTPSA id h10-20020ac85e0a000000b00418122186ccsm9852qtx.12.2023.10.16.12.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Oct 2023 12:45:10 -0700 (PDT)
Message-ID: <76f9ca4a-a805-0b15-78ff-f1a50282abba@redhat.com>
Date:   Mon, 16 Oct 2023 21:45:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 01/12] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-2-rananta@google.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20231009230858.3444834-2-rananta@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
> 
> Introduce new helper functions to set the guest's PMU
> (kvm->arch.arm_pmu) either to a default probed instance or to a
> caller requested one, and use it when the guest's PMU needs to
> be set. These helpers will make it easier for the following
> patches to modify the relevant code.
> 
> No functional change intended.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/pmu-emul.c | 50 +++++++++++++++++++++++++++------------
>  1 file changed, 35 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 3afb281ed8d2..eb5dcb12dafe 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -874,6 +874,36 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
>  	return true;
>  }
>  
> +static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> +{
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	kvm->arch.arm_pmu = arm_pmu;
> +}
> +
> +/**
> + * kvm_arm_set_default_pmu - No PMU set, get the default one.
> + * @kvm: The kvm pointer
> + *
> + * The observant among you will notice that the supported_cpus
> + * mask does not get updated for the default PMU even though it
> + * is quite possible the selected instance supports only a
> + * subset of cores in the system. This is intentional, and
> + * upholds the preexisting behavior on heterogeneous systems
> + * where vCPUs can be scheduled on any core but the guest
> + * counters could stop working.
> + */
> +static int kvm_arm_set_default_pmu(struct kvm *kvm)
> +{
> +	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
> +
> +	if (!arm_pmu)
> +		return -ENODEV;
> +
> +	kvm_arm_set_pmu(kvm, arm_pmu);
> +	return 0;
> +}
> +
>  static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -893,7 +923,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  				break;
>  			}
>  
> -			kvm->arch.arm_pmu = arm_pmu;
> +			kvm_arm_set_pmu(kvm, arm_pmu);
>  			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
>  			ret = 0;
>  			break;
> @@ -917,20 +947,10 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		return -EBUSY;
>  
>  	if (!kvm->arch.arm_pmu) {
> -		/*
> -		 * No PMU set, get the default one.
> -		 *
> -		 * The observant among you will notice that the supported_cpus
> -		 * mask does not get updated for the default PMU even though it
> -		 * is quite possible the selected instance supports only a
> -		 * subset of cores in the system. This is intentional, and
> -		 * upholds the preexisting behavior on heterogeneous systems
> -		 * where vCPUs can be scheduled on any core but the guest
> -		 * counters could stop working.
> -		 */
> -		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
> -		if (!kvm->arch.arm_pmu)
> -			return -ENODEV;
> +		int ret = kvm_arm_set_default_pmu(kvm);
> +
> +		if (ret)
> +			return ret;
>  	}
>  
>  	switch (attr->attr) {

