Return-Path: <kvm+bounces-32406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D65ED9D7BF4
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 08:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C194282420
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 07:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BBE189BA2;
	Mon, 25 Nov 2024 07:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hn6xB9QI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87674188006
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732519648; cv=none; b=kLcgIHK7R8VxDWhhX2mXwLqVQiSurDQzTTujwvlzDF1M9yCWqECGUal1YWvwysSi7J14Bs23Dgo/EkXajjwtdhb/E4qvVjge9DNKpphGKio70AXXVrFBaQZL8fcjBgtxyiE932cBNwQZD/I281M2deNhaq64pmZ69828+SbJ16g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732519648; c=relaxed/simple;
	bh=/nnjJpaGCwuNhpECEATFrIwD915CoDEyDwVOTo9KLYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+8HRgYEnbIF/gmgIYUxKcJCI/5Sgn2x6M43agBvOg4OvvkOFbbDucJMx47M1E3V+siY4ZK84b/VECEVkv7avSD45Pkdpbx7wyt5AnKL9aMqlTF34DGyYDt0GW777XK5nWwi7n/y4q/B5wMhztSF9jFraB+KXWVUxj7D0DIRbQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hn6xB9QI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732519646; x=1764055646;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/nnjJpaGCwuNhpECEATFrIwD915CoDEyDwVOTo9KLYU=;
  b=Hn6xB9QIqGMvXORRVEQNn23wBPT0Sw4kWiRNjAy6M6PUeJn+gN0DjTBY
   Tjjv1abOk3K2rjRjiaQu/u8PNZuF/XCgee8+R82Y40WBatQAqj/z8kHzt
   0hOWTpQU76b6uNKeKroWtMOjC4XIedG5jzBjEMf63/qcJPfk2/sp4B0lw
   Caa5RtfABQGehsGbjBGNd6y1ZYGTolilZNvF3g7XrvR+JxTJ4VIVLuwye
   6ro6HWrtRB68m58SQA2xAd/cExxoylv5NHR/CPIgwGDuCVxoulfXU2r2X
   JEu9Rw4YTT35ZGcBkVosqgRNABaqx/mq6ynMnxdZngg6m4NsoDQ9tNtTf
   g==;
X-CSE-ConnectionGUID: tgONy2+gS/GJdWm9rRaJqg==
X-CSE-MsgGUID: mpDFD1ffQWGxm+CGnakOzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="50020894"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="50020894"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 23:27:26 -0800
X-CSE-ConnectionGUID: n0FEg9PXQI+AiOQUFtUCvw==
X-CSE-MsgGUID: +BHEjdYPSgmLsIrForslWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91137263"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 23:27:21 -0800
Message-ID: <68c65132-0f2e-44eb-b084-bf70edd51417@intel.com>
Date: Mon, 25 Nov 2024 15:27:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/60] kvm: Introduce kvm_arch_pre_create_vcpu()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-8-xiaoyao.li@intel.com>
 <fbe5da1d-9a0e-4aa4-91f9-dfb729f39dc9@linaro.org>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <fbe5da1d-9a0e-4aa4-91f9-dfb729f39dc9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/13/2024 2:28 PM, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> On 5/11/24 06:23, Xiaoyao Li wrote:
>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>> work prior to create any vcpu. This is for i386 TDX because it needs
>> call TDX_INIT_VM before creating any vcpu.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>> Changes in v3:
>> - pass @errp to kvm_arch_pre_create_vcpu(); (Per Daniel)
>> ---
>>   accel/kvm/kvm-all.c  | 10 ++++++++++
>>   include/sysemu/kvm.h |  1 +
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 930a5bfed58f..1732fa1adecd 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -523,6 +523,11 @@ void kvm_destroy_vcpu(CPUState *cpu)
>>       }
>>   }
>> +int __attribute__ ((weak)) kvm_arch_pre_create_vcpu(CPUState *cpu, 
>> Error **errp)
> 
> We don't use the weak attribute. Maybe declare stubs for each arch?

Or define TARGET_KVM_HAVE_PRE_CREATE_VCPU to avoid touching other ARCHes?

8<------------------------------------------------------------------
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -536,10 +531,12 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)

      trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));

+#ifdef TARGET_KVM_HAVE_PRE_CREATE_VCPU
      ret = kvm_arch_pre_create_vcpu(cpu, errp);
      if (ret < 0) {
          goto err;
      }
+#endif

      ret = kvm_create_vcpu(cpu);
      if (ret < 0) {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 643ca4950543..bb76bf090fec 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -374,7 +374,9 @@ int kvm_arch_get_default_type(MachineState *ms);

  int kvm_arch_init(MachineState *ms, KVMState *s);

+#ifdef TARGET_KVM_HAVE_PRE_CREATE_VCPU
  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
+#enfid
  int kvm_arch_init_vcpu(CPUState *cpu);
  int kvm_arch_destroy_vcpu(CPUState *cpu);



I'm OK with either. Please let me what is your preference!

>> +{
>> +    return 0;
>> +}
>> +
>>   int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>   {
>>       KVMState *s = kvm_state;
>> @@ -531,6 +536,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
>>       trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
>> +    ret = kvm_arch_pre_create_vcpu(cpu, errp);
>> +    if (ret < 0) {
>> +        goto err;
>> +    }
>> +
>>       ret = kvm_create_vcpu(cpu);
>>       if (ret < 0) {
>>           error_setg_errno(errp, -ret,
>> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
>> index c3a60b28909a..643ca4950543 100644
>> --- a/include/sysemu/kvm.h
>> +++ b/include/sysemu/kvm.h
>> @@ -374,6 +374,7 @@ int kvm_arch_get_default_type(MachineState *ms);
>>   int kvm_arch_init(MachineState *ms, KVMState *s);
>> +int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
>>   int kvm_arch_init_vcpu(CPUState *cpu);
>>   int kvm_arch_destroy_vcpu(CPUState *cpu);
> 


