Return-Path: <kvm+bounces-12184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D08D88060B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 21:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0ACBB2209B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 20:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D882F3BB38;
	Tue, 19 Mar 2024 20:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IP8id2+E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF743A1C4
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 20:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880220; cv=none; b=mchApidlsaDlXZDNiD5c4t69iPIWa5veRWynXDn555Ghf4DlrbOVm14MJnBOFdPgVHZC/ssR/D4lEYilZLRgKp9+vZ9UzSOIva8CLH6W+dIHEciHAn9ycxlIu8xuOcwmtXlJQuvtiFPzTI1MFAjFGztp3LvswucJRec+zXwbqT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880220; c=relaxed/simple;
	bh=IRIfD3+L1gRgBkauZWudIzMbGpwAbCl9haZpcCUCOZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J7GDh9Mucw4tgN5i2muHmg/OCTchGuZXS30MISDz3F74r7XvKI10x4dUCf3reOUyzVraCSXKDkbT1rcKPBT89SyHCqxRU8saGMhzPBTG6pYj9yH/nIjGPPc7zhhQPFU9Zku1gd19r7R3eTgZGh1rYZZ/7d6ZWkSef0M0ySQCXds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IP8id2+E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710880216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJcKUBP5KtgpxkjAttKx3Lfn/GnCpsO3wNpLIAcoyKg=;
	b=IP8id2+EcV251trI/k1O3i5gkaWZmYJBBj2EkLtaGE+kacIYLNTsB0rT43/4Su9nEo6hog
	VgTsyP9jFYkwHH1k2LLlH+m5PN5Bi9FV/Alg+pg5o2ktGbXXczsf9/Lq+hoqRLkvNo9vXD
	h5Bn14EwTQPEuZLr8EOXbRHr2svJgcg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-UeHW5R3ANGGWa0g5D_hiLA-1; Tue, 19 Mar 2024 16:30:14 -0400
X-MC-Unique: UeHW5R3ANGGWa0g5D_hiLA-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6962ffd74e6so4428006d6.1
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 13:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710880213; x=1711485013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YJcKUBP5KtgpxkjAttKx3Lfn/GnCpsO3wNpLIAcoyKg=;
        b=fk5yKpy4sCIAKBxoH/Er2Qbzb/LJR+Da0oOhzTla83EgRkTsSnKZWw9MY8nNfvccHq
         58Dgj6bgxp3IUWW/IPRIE7CMM+1klDcs1UkRnHtZOHBpPwYMvIUBBGwT1lPcPw+w8kp0
         +RoelFGOX0XawEBnDFSaZhGVZ58fMisAuNH1FlXSZmOXoz4s7fgW6+hseH66yAtgv6Ru
         MW6+ujG5OLMdOv6V1hZ4dQw2gB0GZBc17876FfNkEDCK6hOB/jSxwAFgQ7zwqJKexEpw
         rGwGU6yHivg9cqH2eEkXWUhcjPu6yly2lBKaJAKS/NJOPXo/Ja7/Bg3XCggkUeK78dOW
         3upA==
X-Forwarded-Encrypted: i=1; AJvYcCVsR1KZjBeWYTcxp3IS/sjgP4nvVCcR600f6Z3nYOPk3yPKMwebyHre4ejorFWmZ5j/eYfwN6CVo6Pfy8zy71JSdDxW
X-Gm-Message-State: AOJu0YwXfCs4MzuRSppGrLkaEa+DCY1+0XHDTooVUwQU84yMLPN+PT4q
	60OZmIqjjaZKLq+I5rqDtuL/TFIh7h6Sb1vtsrJOf6F/NoUZpCxxY0hqlvKudTEVV8lbFqmDx/o
	ugfyU++nzM5HbA7sIr0+Om8yAipksQGOqjZhVkqoajkzxl7kQpA==
X-Received: by 2002:a05:6214:20e9:b0:696:2134:95e5 with SMTP id 9-20020a05621420e900b00696213495e5mr6880929qvk.3.1710880213432;
        Tue, 19 Mar 2024 13:30:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+Q8Bm9oZUORJeL5W/Q3SGx2NF/EAq09INGQaoFBMQT3hmjqIot8jrQhEf4vtzZp+fEQaMVw==
X-Received: by 2002:a05:6214:20e9:b0:696:2134:95e5 with SMTP id 9-20020a05621420e900b00696213495e5mr6880899qvk.3.1710880213108;
        Tue, 19 Mar 2024 13:30:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q15-20020a056214194f00b0069183f7fc99sm5075947qvk.144.2024.03.19.13.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Mar 2024 13:30:12 -0700 (PDT)
Message-ID: <b140af6e-7594-48c6-8021-800cd1d0f2c7@redhat.com>
Date: Tue, 19 Mar 2024 21:30:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] KVM: selftests: aarch64: Add helper function for
 the vpmu vcpu creation
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, Oliver Upton
 <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20240229065625.114207-1-shahuang@redhat.com>
 <20240229065625.114207-2-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240229065625.114207-2-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 2/29/24 07:56, Shaoqin Huang wrote:
> Create a vcpu with vpmu would be a common requirement for the vpmu test,
> so add the helper function for the vpmu vcpu creation. And use those
> helper function in the vpmu_counter_access.c test.
> 
> Use this chance to delete the meaningless ASSERT about the pmuver,
> because KVM does not advertise an IMP_DEF PMU to guests.
> 
> No functional changes intended.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  .../kvm/aarch64/vpmu_counter_access.c         | 33 ++++---------------
>  .../selftests/kvm/include/aarch64/vpmu.h      | 29 ++++++++++++++++
>  2 files changed, 36 insertions(+), 26 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/vpmu.h
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> index 5f9713364693..e068a0a7a43b 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> @@ -16,6 +16,7 @@
>  #include <processor.h>
>  #include <test_util.h>
>  #include <vgic.h>
> +#include <vpmu.h>
>  #include <perf/arm_pmuv3.h>
>  #include <linux/bitfield.h>
>  
> @@ -426,18 +427,8 @@ static void guest_code(uint64_t expected_pmcr_n)
>  /* Create a VM that has one vCPU with PMUv3 configured. */
>  static void create_vpmu_vm(void *guest_code)
>  {
> -	struct kvm_vcpu_init init;
> -	uint8_t pmuver, ec;
> -	uint64_t dfr0, irq = 23;
> -	struct kvm_device_attr irq_attr = {
> -		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> -		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
> -		.addr = (uint64_t)&irq,
> -	};
> -	struct kvm_device_attr init_attr = {
> -		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
> -		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
> -	};
> +	uint8_t ec;
> +	uint64_t irq = 23;
>  
>  	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
>  	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> @@ -449,27 +440,17 @@ static void create_vpmu_vm(void *guest_code)
>  					guest_sync_handler);
>  	}
>  
> -	/* Create vCPU with PMUv3 */
> -	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> -	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> -	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
> +	vpmu_vm.vcpu = vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code);
>  	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
> +
>  	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
>  					GICD_BASE_GPA, GICR_BASE_GPA);
>  	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
>  		       "Failed to create vgic-v3, skipping");
>  
> -	/* Make sure that PMUv3 support is indicated in the ID register */
> -	vcpu_get_reg(vpmu_vm.vcpu,
> -		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> -	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), dfr0);
> -	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
> -		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
> -		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
> -
>  	/* Initialize vPMU */
> -	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> -	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> +	vpmu_set_irq(vpmu_vm.vcpu, irq);
> +	vpmu_init(vpmu_vm.vcpu);
>  }
>  
>  static void destroy_vpmu_vm(void)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> new file mode 100644
> index 000000000000..0dfcc7ab1c4d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <kvm_util.h>
> +
> +static inline struct kvm_vcpu *vm_vcpu_add_with_vpmu(struct kvm_vm *vm,
> +						     uint32_t vcpu_id,
> +						     void *guest_code)
> +{
> +	struct kvm_vcpu_init init;
> +
> +	/* Create vCPU with PMUv3 */
> +	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
> +
> +	return aarch64_vcpu_add(vm, 0, &init, guest_code);
> +}
> +
> +static void vpmu_set_irq(struct kvm_vcpu *vcpu, int irq)
> +{
> +	kvm_device_attr_set(vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +			    KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +}
> +
> +static void vpmu_init(struct kvm_vcpu *vcpu)
> +{
> +	kvm_device_attr_set(vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
> +			    KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +}
> +
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


