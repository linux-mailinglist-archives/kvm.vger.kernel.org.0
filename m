Return-Path: <kvm+bounces-19845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7053E90C522
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40A04282AD6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 09:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D961155382;
	Tue, 18 Jun 2024 07:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ShRId9hx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1C4153BF5
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 07:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718695436; cv=none; b=gLbU72OZ1b/rlTDfq9sCHuxx0SH87/uaYnANFzZlgMhqwUrP29rfmMmXsjuXkLW5GxijpERX2vhufVVwiuanbKbNKIvVXvOZfVadH2xi3yXWWfN2SbcxnTNupYD2ksEh30DwbtdFgJaAJSUzdArx/VzCn1GwrUr8GTVoSvqq5VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718695436; c=relaxed/simple;
	bh=jtutfQ/YnGXYiZoliavf4txQTcAFOGOJa0KhiybXy94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XjzJAJYAAI+d+eWl5oRNPTvDdXrE5Xgf6cXvnOhwwD0CWd1Ug/ENdzeRZAWmLZNuPZJ06XApa5oxDSySrrp8uShh04JhxwKQncXLWVBQ8oRUfvi9U/8XMFX66pkTqCC+wlc9h4RYkyyp8mSxQOXOW1a3iUT5ZLurzbYfw/6vPFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ShRId9hx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718695434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ektUs2o9ZwmGp4QGKP67xVqU+KCA2sw3x/s+8mFOJyU=;
	b=ShRId9hx0CLm7kILlqGDkQ3bL1L9MJ8nwT1PH//OeIgihNeRRhZl0mEv4fQkDwsE9RMuis
	QcE3nrm87lpYppnE/YzwZk8FXSSO+wUgnE9Brl48BtTTjy//drOFqvTtMNhgEIgrxU3GqW
	CmXHbwbh8aMfTGbGnHEIj9wEJdhBhio=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-Jh4Lh1l_Osm-LTFgYCqcIA-1; Tue, 18 Jun 2024 03:23:50 -0400
X-MC-Unique: Jh4Lh1l_Osm-LTFgYCqcIA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-254aa52a15eso93358fac.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 00:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718695429; x=1719300229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ektUs2o9ZwmGp4QGKP67xVqU+KCA2sw3x/s+8mFOJyU=;
        b=OpWcNk0OuXUuGMOgY0266aR8aBtNuxSkn934/sGY+JaLQOfYAFiQnlU7AC1xCis7NI
         cSGY/VYVa2mEta838//ncwbJ7TyhrhcQIQc/87+I5cNwYfw7fT/PAiLqGuR3mk20tvh1
         zNbBfUZ12QsNfk7fR28anub8lRE3IwvAsMLKr3uWN+s7pGyxCnHUV5ASEWss/94FC/pV
         zwWtdK2IUcbHT2Nk66pfnMcivPPwIgH7uRWJqrbdSgWcbdvzA2+ivWHSJuC1h2U5pLjv
         NIc5yO6cL6wBQBi56mXAEHRa2P1IM4FduOwauBVpaFplDD439Czo/G6QkOyKNvgovLA/
         4kTA==
X-Forwarded-Encrypted: i=1; AJvYcCUjfThsEfBtMS9Q6Ym5YRB2PHrSPgJuxxQupph2BZyExEzOuQoFh4Ym8zmvfDDoHj2GD4ILEJlkNfUQeJB1U8CK8vcG
X-Gm-Message-State: AOJu0YxM9JXdEkXpuTM7iGHe+wsIecqK0XLz3pH0sXsfdwrYsele8d8U
	Tv1tkq2lZ+sACei4nZqlHCAvlYTHuKHWV8MaMhOfDXuIE5NWXUz4gzOx9kRtRGgX2/kXdrCADWF
	wzLMG5gj2p90gn4DyFxOS2kh9b9tHDerxTrYTbeREcQcCqSIVEg==
X-Received: by 2002:a05:6870:9a25:b0:254:a7df:721b with SMTP id 586e51a60fabf-25842cfc466mr12492786fac.5.1718695428992;
        Tue, 18 Jun 2024 00:23:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGzh9F+irOsR5lWcnREhTCTKn/pzQg2Hw7QKb2g0z70Pr0m1XAmIppde3Pf/VUtv48DRUNuQ==
X-Received: by 2002:a05:6870:9a25:b0:254:a7df:721b with SMTP id 586e51a60fabf-25842cfc466mr12492771fac.5.1718695428566;
        Tue, 18 Jun 2024 00:23:48 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb3cda1sm8387767b3a.117.2024.06.18.00.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 00:23:48 -0700 (PDT)
Message-ID: <25df0c92-8c02-4804-b4a0-7ec7a6790a89@redhat.com>
Date: Tue, 18 Jun 2024 15:23:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/3] KVM: selftests: aarch64: Add invalid filter test
 in pmu_event_filter_test
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Eric Auger <eric.auger@redhat.com>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240613082345.132336-1-shahuang@redhat.com>
 <20240613082345.132336-4-shahuang@redhat.com>
 <CAJHc60xpGAA1pmz0ad_Fq3a5M-pQMiyxQ4hdNhc6vQrgpSjGww@mail.gmail.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60xpGAA1pmz0ad_Fq3a5M-pQMiyxQ4hdNhc6vQrgpSjGww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/18/24 08:01, Raghavendra Rao Ananta wrote:
> Hi Shaoqin,
> 
> On Thu, Jun 13, 2024 at 1:27 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Add the invalid filter test which sets the filter beyond the event
>> space and sets the invalid action to double check if the
>> KVM_ARM_VCPU_PMU_V3_FILTER will return the expected error.
>>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
>> ---
>>   .../kvm/aarch64/pmu_event_filter_test.c       | 37 +++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
>> index fb0fde1ed436..13b2f354c39b 100644
>> --- a/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
>> +++ b/tools/testing/selftests/kvm/aarch64/pmu_event_filter_test.c
>> @@ -8,6 +8,7 @@
>>    * This test checks if the guest only see the limited pmu event that userspace
>>    * sets, if the guest can use those events which user allow, and if the guest
>>    * can't use those events which user deny.
>> + * It also checks that setting invalid filter ranges return the expected error.
>>    * This test runs only when KVM_CAP_ARM_PMU_V3, KVM_ARM_VCPU_PMU_V3_FILTER
>>    * is supported on the host.
>>    */
>> @@ -178,6 +179,40 @@ static void destroy_vpmu_vm(void)
>>          kvm_vm_free(vpmu_vm.vm);
>>   }
>>
>> +static void test_invalid_filter(void)
>> +{
>> +       struct kvm_pmu_event_filter invalid;
>> +       int ret;
>> +
>> +       pr_info("Test: test_invalid_filter\n");
>> +
>> +       memset(&vpmu_vm, 0, sizeof(vpmu_vm));
>> +
>> +       vpmu_vm.vm = vm_create(1);
>> +       vpmu_vm.vcpu = vm_vcpu_add_with_vpmu(vpmu_vm.vm, 0, guest_code);
>> +       vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64);
>> +       __TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
>> +                      "Failed to create vgic-v3, skipping");
>> +
>> +       /* The max event number is (1 << 16), set a range largeer than it. */
> nit: s/largeer/larger
> 
> Also, perhaps not in this series, but we can also check for -EBUSY
> situations such as setting a (valid) filter after
> KVM_ARM_VCPU_PMU_V3_INIT and after the vCPUs have started.
> 

That's also a great test, we can add it in the future.

> Besides that, Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>

Thanks a lot for your reviewing.

> 
> - Raghavendra
> 
> 
> 
>> +       invalid = __DEFINE_FILTER(BIT(15), BIT(15) + 1, 0);
>> +       ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
>> +                                   KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
>> +       TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter range "
>> +                   "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
>> +                   ret, errno);
>> +
>> +       /* Set the Invalid action. */
>> +       invalid = __DEFINE_FILTER(0, 1, 3);
>> +       ret = __kvm_device_attr_set(vpmu_vm.vcpu->fd, KVM_ARM_VCPU_PMU_V3_CTRL,
>> +                                   KVM_ARM_VCPU_PMU_V3_FILTER, &invalid);
>> +       TEST_ASSERT(ret && errno == EINVAL, "Set Invalid filter action "
>> +                   "ret = %d, errno = %d (expected ret = -1, errno = EINVAL)",
>> +                   ret, errno);
>> +
>> +       destroy_vpmu_vm();
>> +}
>> +
>>   static void run_test(struct test_desc *t)
>>   {
>>          pr_info("Test: %s\n", t->name);
>> @@ -300,4 +335,6 @@ int main(void)
>>          TEST_REQUIRE(kvm_pmu_support_events());
>>
>>          run_tests();
>> +
>> +       test_invalid_filter();
>>   }
>> --
>> 2.40.1
>>
>>
> 

-- 
Shaoqin


