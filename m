Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A641D5BB
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348244AbhI3Iwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:52:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348052AbhI3Iwx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 04:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632991870;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=enboltUA+a2UXyd2ev7IOjW3eWnVQILj4KtkTqyYnes=;
        b=gkI1PGbJEhgd5hXecWfxhUUFCErGBW7IU3QcAhWy/5PKiT+VDjF9T4HFcFEuJxk7dgGBgW
        1gyyuQ0r6lMo4Ct57C4gU22FkuS9DWdfprs8o4OasF2HPxb4uPtwwrTqybS7SlPYDt8Eyd
        Ka8ARVLBtm2KwnehBIs9jEA2tuet0lE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-e1Y95RQvNlqQ8YZyq6fN9A-1; Thu, 30 Sep 2021 04:51:08 -0400
X-MC-Unique: e1Y95RQvNlqQ8YZyq6fN9A-1
Received: by mail-wm1-f70.google.com with SMTP id k6-20020a05600c0b4600b0030d2a0a259eso1259142wmr.6
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 01:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=enboltUA+a2UXyd2ev7IOjW3eWnVQILj4KtkTqyYnes=;
        b=m1g96D43630bTHS/enkIcMROxKAe6EcIkdjdfP8pU59UYVMAhOTwwzczS7mIxSZMAs
         Nln/Pwt2sEg66W6/51ZaSKHri0SM+jjgKAnKQuEBHrfWVX0iYdJByOCIsCOujyclweqv
         Ck3s2ewx2VxxlCdc0/JkJJ0WZN2SAseMXT0LJDOLYrrjWpW/4Q+EoIrtvJLPq+Jpv2dU
         WyQVDiBf2RIHgnWUaWtopAPqHuaqoP5nGmdz91hSa6qE+cy/BYmiZrrlQEGCPRLW32uH
         KvGAb0hTN+9x9l7vkd2FJFs5F+U1rNBKgYXlun/s4Znhp9GiHGvQjB50OCFAfMH7g1Ll
         keVQ==
X-Gm-Message-State: AOAM533EtcdjAYFPKtgCuKeT87s5HUXoCuKk8V09+exkSPbjD69R+367
        UPd1Bg1eUDPtD4UbhmNda35HjT4Z5QCGiHsiMX/QDKZ50sJbTx4gUh9FmaZTw+4Klz0zEo+Z5dC
        qqYLt8YsyokmO
X-Received: by 2002:a5d:5552:: with SMTP id g18mr4749178wrw.188.1632991867660;
        Thu, 30 Sep 2021 01:51:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJRtTvop+yA+0hkKKZHSCU+xbXl8QpnQFT7wUWD5EhjNiBLYscMcOCJ9ssbH/VORwXH9Iz1A==
X-Received: by 2002:a5d:5552:: with SMTP id g18mr4749162wrw.188.1632991867471;
        Thu, 30 Sep 2021 01:51:07 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i92sm2300002wri.28.2021.09.30.01.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 01:51:06 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: selftests: Add tests for GIC
 redist/cpuif partially above IPA range
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-9-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <420f5eb6-4ed4-7c0b-266c-03b62a441b95@redhat.com>
Date:   Thu, 30 Sep 2021 10:51:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-9-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/28/21 8:48 PM, Ricardo Koller wrote:
> Add tests for checking that KVM returns the right error when trying to
> set GICv2 CPU interfaces or GICv3 Redistributors partially above the
> addressable IPA range. Also tighten the IPA range by replacing
> KVM_CAP_ARM_VM_IPA_SIZE with the IPA range currently configured for the
> guest (i.e., the default).
>
> The check for the GICv3 redistributor created using the REDIST legacy
> API is not sufficient as this new test only checks the check done using
> vcpus already created when setting the base. The next commit will add
> the missing test which verifies that the KVM check is done at first vcpu
> run.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 46 ++++++++++++++-----
>  1 file changed, 35 insertions(+), 11 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> index 92f5c6ca6b8b..77a1941e61fa 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> @@ -31,7 +31,7 @@ struct vm_gic {
>  	uint32_t gic_dev_type;
>  };
>  
> -static int max_ipa_bits;
> +static uint64_t max_phys_size;
>  
>  /* helper to access a redistributor register */
>  static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> @@ -150,16 +150,21 @@ static void subtest_dist_rdist(struct vm_gic *v)
>  	TEST_ASSERT(ret && errno == EINVAL, "GIC redist/cpu base not aligned");
>  
>  	/* out of range address */
> -	if (max_ipa_bits) {
> -		addr = 1ULL << max_ipa_bits;
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 dist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
> +	addr = max_phys_size;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 dist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "dist address beyond IPA limit");
>  
> -		ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> -					 rdist.attr, &addr, true);
> -		TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> -	}
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG, "redist address beyond IPA limit");
> +
> +	/* Space for half a rdist (a rdist is: 2 * rdist.alignment). */
> +	addr = max_phys_size - dist.alignment;
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 rdist.attr, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +			"half of the redist is beyond IPA limit");
>  
>  	/* set REDIST base address @0x0*/
>  	addr = 0x00000;
> @@ -248,7 +253,21 @@ static void subtest_v3_redist_regions(struct vm_gic *v)
>  	kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
>  
> -	addr = REDIST_REGION_ATTR_ADDR(1, 1ULL << max_ipa_bits, 0, 2);
> +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size, 0, 2);
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		    "register redist region with base address beyond IPA range");
> +
> +	/* The last redist is above the pa range. */
> +	addr = REDIST_REGION_ATTR_ADDR(1, max_phys_size - 0x10000, 0, 2);
> +	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> +	TEST_ASSERT(ret && errno == E2BIG,
> +		    "register redist region with base address beyond IPA range");
s/base address/top address
> +
> +	/* The last redist is above the pa range. */
> +	addr = REDIST_REGION_ATTR_ADDR(2, max_phys_size - 0x30000, 0, 2);
>  	ret = _kvm_device_access(v->gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
>  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
Why this second check?
>  	TEST_ASSERT(ret && errno == E2BIG,
> @@ -608,8 +627,13 @@ void run_tests(uint32_t gic_dev_type)
>  int main(int ac, char **av)
>  {
>  	int ret;
> +	int max_ipa_bits, pa_bits;
>  
>  	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +	pa_bits = vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
> +	TEST_ASSERT(max_ipa_bits && pa_bits <= max_ipa_bits,
> +		"The default PA range should not be larger than the max.");
Isn't it already enforced in the test infra instead?
I see in lib/kvm_util.c

#ifdef __aarch64__
        if (vm->pa_bits != 40)
                vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
#endif

vm_open()
> +	max_phys_size = 1ULL << pa_bits;
>  
>  	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
>  	if (!ret) {
Eric

