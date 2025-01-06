Return-Path: <kvm+bounces-34641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993CBA0316B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E799164EB6
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406ED1DED79;
	Mon,  6 Jan 2025 20:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VT4AHBEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4C21C69D
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736195606; cv=none; b=YyErpk84Qv3xj2SMnUAnKYn3CnxarRr9oDyY1H7OO64cDDPtaXKRiss1YJ4UYsF57JTzJ6UTmJqZ4KdBUUOt6EnIILW758SI0nF83IqzBlEsurtadCmy4iGlL3lDVZsFdcIywMDINe663gyKyhLtpHJ+nuH+rlQNQVXPlyS+ayM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736195606; c=relaxed/simple;
	bh=4b/pSyVLztAmTQ0fAHNYwyMUCzcMxQbBpEzygfmO2rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRYY03oUyqHljdJbsdD0lp4WIKZ4DYLcSEEVvvXwOU1KquS+Q2gFVT7GlfBgljhA6PzP+txx+Y8sTwz0xyQpzHZD82Re2eMLw3XhQbjWKYJayS57vMN9Yfy2/GEp9WZrwQEPokmi4VUZMRaI25mdR1Ext0wG5kBoieovHfYH4hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=VT4AHBEo; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-21683192bf9so210867215ad.3
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1736195604; x=1736800404; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tRChKa/6ydnGwRW0eNjgRJAJvFNapuIamBmUVRUNy3A=;
        b=VT4AHBEoEqWt/qiIX7v3i5dcaxGpg8NDIgGfPyEmWkxymJf8OMv3x6jgAAvPVromtD
         oK6+OI807GZpThktuzcDJUT+K+ftgNc2p0kGF3cI5z7FCtncHzjK4Mxib92Do0Y2qruM
         qMIMdtbYQRHmAsO5N2IC1VxrUjXOi19rXuF++5UjOeGXhynsH+Z8GmqDlZT5ZXqnolvn
         iIXK9Vmu5oT+AQtfTydnYwTfeOYFMFd6IfJbzx2pgM63x3eBiCnQhVvhAdwVgTqXM6r0
         q5JPr7EmVwgLX0hR8PJXnNJsvECIXG+f/7qQwDDVSJFVMO2jJMf1KLZgCwQJOPUMrkae
         UQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736195604; x=1736800404;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tRChKa/6ydnGwRW0eNjgRJAJvFNapuIamBmUVRUNy3A=;
        b=TVYIVnxqCM0GOCUTuTn2y8oqjX+FZS4/ZAp+WqNjq4xVoX7ZfpJ5WxZPrckV+nh3MA
         Ft4kP557+9Zl7clBPz6/eVRtNiHmVCM9YFfM35zuDCtR07+gPUHvLqBsPBOMK17vyN0o
         v1BGAulNY+iZ45qNvDkEuN4QNBKNdyQuehoR6exYP0gKwCjG91ma6IGrBB4d1Okpgf99
         S44nTX+NSFBasuZajC5sYmMUMv6DSG2PDNzdfw/4F/cS18s8klKVdo4Lb59uFVY2xP9s
         jVc9l473qj1S5TukJzLjibc14qfPhYvFw6S5iycioKTtL/2BkM2mrtOSRR88JA/lhFhe
         Oi7A==
X-Forwarded-Encrypted: i=1; AJvYcCXOAfiQwwaNtlcw9YRijeUjzMn8vg+4OzA5WHMSVlnYhsGYde14lOD8+AObF8BYN97jXmU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzszDfSCA/AD7tzxJOJRCb6c6rkQ7Y4C1ZaIipYYnX8eNiVkrBP
	va5iBR2FqPAjJkpQdXlL40WCZNHJGXlK7vn7wirj7iUsYZnh8mwkgdinq2DMoCjiiAJNKIaSDfw
	6yT8=
X-Gm-Gg: ASbGnctt5knl1s8EwpBJ9SupvNOZI8iuWxUBXqZy92JDBVsSiH0K4bfz/wrqceNvCD6
	TJtqAJnuRSxzyLgXfPNc4wvHYNJrOQ0/hFmszlRJgLXNyouxjjPgNw5yUlJWTXkB6LHYxGbNXHX
	JMAUYu66LEJuuy7c1kVf9Woy/Fe2s/KOxam3UWd06xJxfN2zWqZkCFYoaqLCVBl5CGZpwPTK9UC
	NnF8Glfattdz543jyqcEkkd3mPJmppUQOXD9oScPv/0ggUOHBQCA6MckhdgJPvQAFHr12KCowz/
	eKWqtpjRIAgeBWbS9JBqjplUfkN30em4Kmk=
X-Google-Smtp-Source: AGHT+IGIo280ucsBcngxguAyG9JQ9T3VFgxxJUPO1hVz/7EWXjloduoiThjDr/f0vbWxM4+ikOS8ZQ==
X-Received: by 2002:a17:903:2384:b0:216:5cbd:5449 with SMTP id d9443c01a7336-219e6e9e8c5mr891272455ad.13.1736195604239;
        Mon, 06 Jan 2025 12:33:24 -0800 (PST)
Received: from ?IPV6:2804:7f0:bdcd:fb00:6501:2693:db52:c621? ([2804:7f0:bdcd:fb00:6501:2693:db52:c621])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cde66sm296704655ad.145.2025.01.06.12.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 12:33:23 -0800 (PST)
Message-ID: <bd8168fe-c774-4f75-8a94-1a67ec31e38d@ventanamicro.com>
Date: Mon, 6 Jan 2025 17:33:12 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] accel/hvf: Use CPU_FOREACH_HVF()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Cameron Esfahani <dirty@apple.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Alexander Graf <agraf@csgraf.de>, Paul Durrant <paul@xen.org>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 xen-devel@lists.xenproject.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-s390x@nongnu.org,
 Riku Voipio <riku.voipio@iki.fi>, Anthony PERARD <anthony@xenproject.org>,
 Alistair Francis <alistair.francis@wdc.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 "Edgar E . Iglesias" <edgar.iglesias@amd.com>, Zhao Liu
 <zhao1.liu@intel.com>, Phil Dennis-Jordan <phil@philjordan.eu>,
 David Woodhouse <dwmw2@infradead.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>
References: <20250106200258.37008-1-philmd@linaro.org>
 <20250106200258.37008-7-philmd@linaro.org>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20250106200258.37008-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 1/6/25 5:02 PM, Philippe Mathieu-Daudé wrote:
> Only iterate over HVF vCPUs when running HVF specific code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/hvf_int.h  | 4 ++++
>   accel/hvf/hvf-accel-ops.c | 9 +++++----
>   target/arm/hvf/hvf.c      | 4 ++--
>   3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
> index 42ae18433f0..3cf64faabd1 100644
> --- a/include/system/hvf_int.h
> +++ b/include/system/hvf_int.h
> @@ -11,6 +11,8 @@
>   #ifndef HVF_INT_H
>   #define HVF_INT_H
>   
> +#include "system/hw_accel.h"
> +
>   #ifdef __aarch64__
>   #include <Hypervisor/Hypervisor.h>
>   typedef hv_vcpu_t hvf_vcpuid;
> @@ -74,4 +76,6 @@ int hvf_put_registers(CPUState *);
>   int hvf_get_registers(CPUState *);
>   void hvf_kick_vcpu_thread(CPUState *cpu);
>   
> +#define CPU_FOREACH_HVF(cpu) CPU_FOREACH_HWACCEL(cpu)


Cosmetic comment: given that this is HVF specific code and we only support one hw
accelerator at a time, I'd skip this alias and use CPU_FOREACH_HWACCEL(cpu) directly.
It would make it easier when grepping to see where and how the macro is being used.
Same thing in the next patch with CPU_FOREACH_KVM().


LGTM otherwise. Thanks,

Daniel


> +
>   #endif
> diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
> index 945ba720513..bbbe2f8d45b 100644
> --- a/accel/hvf/hvf-accel-ops.c
> +++ b/accel/hvf/hvf-accel-ops.c
> @@ -504,7 +504,7 @@ static int hvf_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
>           }
>       }
>   
> -    CPU_FOREACH(cpu) {
> +    CPU_FOREACH_HVF(cpu) {
>           err = hvf_update_guest_debug(cpu);
>           if (err) {
>               return err;
> @@ -543,7 +543,7 @@ static int hvf_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
>           }
>       }
>   
> -    CPU_FOREACH(cpu) {
> +    CPU_FOREACH_HVF(cpu) {
>           err = hvf_update_guest_debug(cpu);
>           if (err) {
>               return err;
> @@ -560,7 +560,7 @@ static void hvf_remove_all_breakpoints(CPUState *cpu)
>       QTAILQ_FOREACH_SAFE(bp, &hvf_state->hvf_sw_breakpoints, entry, next) {
>           if (hvf_arch_remove_sw_breakpoint(cpu, bp) != 0) {
>               /* Try harder to find a CPU that currently sees the breakpoint. */
> -            CPU_FOREACH(tmpcpu)
> +            CPU_FOREACH_HVF(tmpcpu)
>               {
>                   if (hvf_arch_remove_sw_breakpoint(tmpcpu, bp) == 0) {
>                       break;
> @@ -572,7 +572,7 @@ static void hvf_remove_all_breakpoints(CPUState *cpu)
>       }
>       hvf_arch_remove_all_hw_breakpoints();
>   
> -    CPU_FOREACH(cpu) {
> +    CPU_FOREACH_HVF(cpu) {
>           hvf_update_guest_debug(cpu);
>       }
>   }
> @@ -581,6 +581,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, void *data)
>   {
>       AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
>   
> +    ops->get_cpus_queue = hw_accel_get_cpus_queue;
>       ops->create_vcpu_thread = hvf_start_vcpu_thread;
>       ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
>   
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index 0afd96018e0..13400ff0d5f 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -2269,10 +2269,10 @@ static void hvf_arch_set_traps(void)
>   
>       /* Check whether guest debugging is enabled for at least one vCPU; if it
>        * is, enable exiting the guest on all vCPUs */
> -    CPU_FOREACH(cpu) {
> +    CPU_FOREACH_HVF(cpu) {
>           should_enable_traps |= cpu->accel->guest_debug_enabled;
>       }
> -    CPU_FOREACH(cpu) {
> +    CPU_FOREACH_HVF(cpu) {
>           /* Set whether debug exceptions exit the guest */
>           r = hv_vcpu_set_trap_debug_exceptions(cpu->accel->fd,
>                                                 should_enable_traps);


