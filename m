Return-Path: <kvm+bounces-8815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BAA856CA9
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51C82B28885
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8606C13A248;
	Thu, 15 Feb 2024 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH4PhfY9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614D61386BF
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 18:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708021650; cv=none; b=h7Y76jP4QF/gsX03iEjTzmh8zCkYvZFNfSiGjXV6JhMkNCD7o0ezqOmnOZekCttEjVk5ijK9t2eB2lpLdXtH4TTpxIzwnhxemoArObCBIdgr47qiURNMuei9w44oVnNVZLIhdPlAnee+YVwk2Qs+6pBmER2RZeagiPcr6Y8rU0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708021650; c=relaxed/simple;
	bh=2wCnvjkhvn5BKoVcdNdw7iQW17hpGsSpN4YYTCOKtus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LOAvqspUw0HfUa8DYh6Jd6elNPhK7hAZzA1SdXubcrUA42Ze8WRRattuVF9qJ7V3hXT7iwmCPUp5geS7iNvlaGfzt+Vrn8S4nXgtFiwxHzr95a7rcli49RX/v9y+A0kcpfgMfVUQ1l9N8DB760bxwBfM8fUp57DEF4bESS7s2MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH4PhfY9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708021646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5rcuei6vVHQzEyNnihSudUV2QF1nleva1UrlbPjP+8U=;
	b=YH4PhfY9hnjyophTCH+oPPxrmHCjBS+U+PO+g15wFlxQDwHSzwLA4bm20+giq3hVMzKpfm
	qabzGeuf6RiYyDCmyRnJiH71lgkYLU4+Yj/GFlKWVAZr6iV02zuYyCtT7qiCzmlJPSL/BW
	iCA9qfx/zRBlOrFIs/ApCsissBqoW2Q=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Gis7vut2OZq_Y-f3dT3gkg-1; Thu, 15 Feb 2024 13:27:25 -0500
X-MC-Unique: Gis7vut2OZq_Y-f3dT3gkg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c0a8d3925eso1887238b6e.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 10:27:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708021645; x=1708626445;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5rcuei6vVHQzEyNnihSudUV2QF1nleva1UrlbPjP+8U=;
        b=Ej3RkE9Oouos6O+FSF7dntBg21SxQi+WCwvRxKL3BiMENZfrYgqLd73nQ7TvztizBL
         x1tdzu6KLloReIFecAEMcNDI8auKdRdYkpET2VmB/fGg1q8RrldFSBJZEBMDLDSj33B4
         I+kpE/uSZKeW78K1mCERCJtHi5MLnyYTStVYBCBYBuuVM1vBhugOYiEPDB4sc8oUYcH3
         Sbt9eaov0T0Ac6qd3jNtow3LzZ45rwfCt5iodN7gyRU+tzYKsNOgOn98bag0LkQ+WshJ
         3XW1CC4bk8NMeLaUMJpFLb7idG1DlcdcJ9PTbxFLkHEwlnX+QcNZQQb/re2L/DLjfv/W
         Gxyw==
X-Forwarded-Encrypted: i=1; AJvYcCVydNrbBBs0I4n+Ui1HEafPM14l0GnaQB6W8ur7OHceweO8zYLRDS9v4UgtlLGam/0VSLEL3W8Cs1dLAaCSyYNgR3Tm
X-Gm-Message-State: AOJu0YySHmbDUNaVU9z4LxEwiY8mRoDNiGpTtHERXn8iZxTfm8cpK3Ep
	gOBbSLzaem28EtrEHdAYNchJh0MEKQ2OuT+u8/IuNhsBLpZcrxevZFsnCuoLGlfjkZGO9zq+h+Q
	yyOQ23tcBVv2uxPWb3mPJ+UJPPtv6bPm/FPcaYcfagbKGCdroCg==
X-Received: by 2002:aca:1204:0:b0:3c0:4056:a2ed with SMTP id 4-20020aca1204000000b003c04056a2edmr2420204ois.52.1708021644918;
        Thu, 15 Feb 2024 10:27:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZKI2Y5bw/n2gWg9WROC85Pjasnt5QCGU2b+OlWiTw1ItcyAVVMjpne9JYAbwflkR7xSrc1g==
X-Received: by 2002:aca:1204:0:b0:3c0:4056:a2ed with SMTP id 4-20020aca1204000000b003c04056a2edmr2420190ois.52.1708021644653;
        Thu, 15 Feb 2024 10:27:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q15-20020a05622a030f00b0042c7f028606sm795543qtw.32.2024.02.15.10.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 10:27:24 -0800 (PST)
Message-ID: <94ae4343-487a-4782-8b15-6f1201eed882@redhat.com>
Date: Thu, 15 Feb 2024 19:27:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: selftests: aarch64: Add invalid filter test
 in pmu_event_filter_test
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, Oliver Upton
 <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240202025659.5065-1-shahuang@redhat.com>
 <20240202025659.5065-6-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240202025659.5065-6-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 2/2/24 03:56, Shaoqin Huang wrote:
> Add the invalid filter test includes sets the filter beyond the event
s/includes/which
> space and sets the invalid action to double check if the
> KVM_ARM_VCPU_PMU_V3_FILTER will return the expected error.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  .../kvm/aarch64/pmu_event_filter_test.c       | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> index d280382f362f..68e1f2003312 100644
> --- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
> @@ -7,6 +7,7 @@
>   * This test checks if the guest only see the limited pmu event that userspace
>   * sets, if the guest can use those events which user allow, and if the guest
>   * can't use those events which user deny.
> + * It also checks that setting invalid filter ranges return the expected error.
>   * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
>   * is supported on the host.
>   */
> @@ -183,6 +184,39 @@ static void for_each_test(void)
>  		run_test(t);
>  }
>  
> +static void set_invalid_filter(struct vpmu_vm *vm, void *arg)
> +{
> +	struct kvm_pmu_event_filter invalid;
> +	struct kvm_device_attr attr = {
> +		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
> +		.attr	= KVM_ARM_VCPU_PMU_V3_FILTER,
> +		.addr	= (uint64_t)&invalid,
> +	};
> +	int ret = 0;
> +
> +	/* The max event number is (1 << 16), set a range largeer than it. */
in  practice it is 16b on ARMv8.1 and 10b on ARMv8.0 but obvioulsy the
check below works for both ;-)

larger typ
> +	invalid = __DEFINE_FILTER(BIT(15), BIT(15)+1, 0);
space between "+"
> +	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
kvm_device_attr_set() as commented by Oliver
> +	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
> +		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
> +		    ret, errno);
> +
> +	ret = 0;
> +
> +	/* Set the Invalid action. */
> +	invalid = __DEFINE_FILTER(0, 1, 3);
> +	ret = __vcpu_ioctl(vm->vcpu, KVM_SET_DEVICE_ATTR, &attr);
> +	TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
> +		    "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
> +		    ret, errno);
> +}
> +
> +static void test_invalid_filter(void)
> +{
> +	vpmu_vm = __create_vpmu_vm(guest_code, set_invalid_filter, NULL);
> +	destroy_vpmu_vm(vpmu_vm);
> +}
> +
>  static bool kvm_supports_pmu_event_filter(void)
>  {
>  	int r;
> @@ -216,4 +250,6 @@ int main(void)
>  	TEST_REQUIRE(host_pmu_supports_events());
>  
>  	for_each_test();
> +
> +	test_invalid_filter();
>  }
Thanks

Eric


