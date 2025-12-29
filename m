Return-Path: <kvm+bounces-66793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E52CE7F98
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 20:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2AE59301EC55
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 19:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD96E32BF5B;
	Mon, 29 Dec 2025 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lj8SxOeh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A227AC28
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033825; cv=none; b=mmadU/ESrX15eRwQnO5DWVZa5avPSSF3pntJkTKlD9JFjv4tseS72fu2hfiEyWoaxisEAGqYTLhuCQWSFntvVUxQqVNYcN+kewBECg6X45JcU9fhrolwLO51hmqw3G5ppnn9b/Sg1MQ4mawFv8D+M43XVRUmlA3QE6KDQA3tAcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033825; c=relaxed/simple;
	bh=Wz+2pwviLEhPTrbS5vzrOFXD35f+OhfvE0Fol2fc7i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TTmAIWRboUJssnKPUh5DtlGQe6hj3LV203Uf7w5Pivbs2sjCRJekkj2etmDU25Oo2pcs+dI6ooTZ9ez38taRu7/IG7UNSmqZZxUBRMzSwHhmBmGQwR9EIwmv4Ak0H3z3ny5m54j/LGIqaMHozYE2bqCNNnemF9DsMvSlcBSgsGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lj8SxOeh; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d0788adaso83169245ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 10:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767033820; x=1767638620; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uwn1Ia6i5f2r6o+NnwihSUzXHLhls41F5p1+a1eMrFQ=;
        b=Lj8SxOehcb2dVFz+NwrKfaqdRx9YOJiEsyG5cT8196zBi5fv0NQJbOqc8L5KHtM0ha
         hmo5BI0SoNtQcqjEOQavyXXhBGvgn100HMpIr83v7EOQPSR0lL0GHoMxjKxAFd8HpNUZ
         M7O6XXCk5NRNuTd8xgS5JdxVWYNEXRXex9aidHjOers++BZjc0gAy5PTQA759J2uEZNq
         RijdVv1jGZgAGAR5gYmM5lvHCPAsHf+jMdfyLyqLWXjXOWNXFSrgbwpjGDYzfjKH20aH
         8/ABMIFsekBqlszqWrcaLu9b+55NtS0YAkKYeBG/vA+Vq5nhWApWGGKNOCtNUUPGw7Sw
         IJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033820; x=1767638620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uwn1Ia6i5f2r6o+NnwihSUzXHLhls41F5p1+a1eMrFQ=;
        b=mljJjZIZR1iM6KOIZRZJ8GagncB8d9aVFi2My4XCoExpZ2EHzT2X8NWr+TZYSw8OCq
         mRhzOeS5TJltwI8oz9Z3tE4pP9s511H38aYuFS41cDV8Tm4eBU9pQ55ubs0w3G5Yp3rM
         Ao0NJE/zUDFJAzWIhWHhstCNMVA2UcqGLUqZshcDmxUW6ANz9w19KaWRvJt16SuGsW2s
         4JsQ2YIvYc/ppsmKhBFX7FjoeObVCBeP/rkERtNLT0eU/ZJsA9X5Unl5V8Luma8S2A/R
         AB82J4Q2GFpRAU5uCJenEawKD5B7DuRNNELmV1ye//jSIE1UObHxqbrVyGVWzw+crCCY
         FYJw==
X-Forwarded-Encrypted: i=1; AJvYcCWeOiSQNOsVodKcWDxw4TKNml2Bcab8B4R1RhlJq/HamBuUIXexRRENZT6jwnvqSTWFAH4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv+BVbHaf91ZYSB8YKeja1fhRC8itbxnuiccxcTGtQ2ROoYr6H
	igutwfH6WbIluBLk3iLVH3JQaKfkpC+OI/5r2PedE78HtTanRJzMI5ebbzCFPrPzqmY=
X-Gm-Gg: AY/fxX6USTzCVaSEakpywld9ex8zFFzKwW/iboVqgK0MOILl0PfClkFrdd2ex86lbZM
	/GMwTK4K4VNUkLM+wCZ8NaIsjU7/mwOcVunOzNbyQqod9USb2FyZc5vlKpvBNOHcK4nUBYv19k8
	yB70PYsUw+/QYOgeVxbarnEVLe6tLewFt5CFEkKxPFCYYbXDWjUl9F6oQdQ+RkwV9CcWp2nPr4S
	BYcPYISJONGhqSix4llDnftLownugl4gzfyMuLz1UvZsHI6OLMqyizVJJAnRDcexa0M7+xICXY5
	bOsK8uoCe7jq/0XzEGM9TcWKMvIHbvQPg+LGe7f7++cUkckXrrZIZz3hF7NnwywBF096CL+xj9i
	qK3ON93XQv/BveaXZRIgziQTc/G7EwnzyUa6W7/kFFWI9s6wuqmV8oSBxj5AokaBut3c/h0oj4Q
	no6cPqeqczdgynBR9xq0vOMm1AHdZjD+TLY9wso26k/CG4DOik4u7k/uYt
X-Google-Smtp-Source: AGHT+IH38YtqoTF7wx7s38i2m+/OSaoP7yEHgGhDuk2Zgmj+fK7stjLK8Nlx5s43A/87PIrNe3VV5A==
X-Received: by 2002:a17:903:1a2e:b0:297:d764:9874 with SMTP id d9443c01a7336-2a2f222bfebmr313442345ad.21.1767033820186;
        Mon, 29 Dec 2025 10:43:40 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c83325sm281846545ad.34.2025.12.29.10.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 10:43:39 -0800 (PST)
Message-ID: <f9a6ac85-f3d5-4e14-a717-bd2183cda1d6@linaro.org>
Date: Mon, 29 Dec 2025 10:43:38 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/28] hw/arm: virt: add GICv2m for the case when ITS
 is not available
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-5-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-5-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:53 PM, Mohamed Mediouni wrote:
> On Hypervisor.framework for macOS and WHPX for Windows, the provided environment is a GICv3 without ITS.
> 
> As such, support a GICv3 w/ GICv2m for that scenario.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/arm/virt-acpi-build.c |  4 +++-
>   hw/arm/virt.c            | 16 +++++++++++++++-
>   include/hw/arm/virt.h    |  2 ++
>   3 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 03b4342574..b6f722657a 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -960,7 +960,9 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>               build_append_int_noprefix(table_data, memmap[VIRT_GIC_ITS].base, 8);
>               build_append_int_noprefix(table_data, 0, 4);    /* Reserved */
>           }
> -    } else {
> +    }
> +
> +    if (!(vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) && !vms->no_gicv3_with_gicv2m) {

check patch reports:
ERROR: line over 90 characters
#31: FILE: hw/arm/virt-acpi-build.c:965:
+    if (!(vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) && 
!vms->no_gicv3_with_gicv2m) {

>           const uint16_t spi_base = vms->irqmap[VIRT_GIC_V2M] + ARM_SPI_BASE;
>   
>           /* 5.2.12.16 GIC MSI Frame Structure */
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index fd0e28f030..0fb8dcb07d 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -959,6 +959,8 @@ static void create_gic(VirtMachineState *vms, MemoryRegion *mem)
>   
>       if (vms->gic_version != VIRT_GIC_VERSION_2 && vms->its) {
>           create_its(vms);
> +    } else if (vms->gic_version != VIRT_GIC_VERSION_2 && !vms->no_gicv3_with_gicv2m) {
> +        create_v2m(vms);
>       } else if (vms->gic_version == VIRT_GIC_VERSION_2) {
>           create_v2m(vms);
>       }
> @@ -2444,6 +2446,8 @@ static void machvirt_init(MachineState *machine)
>       vms->ns_el2_virt_timer_irq = ns_el2_virt_timer_present() &&
>           !vmc->no_ns_el2_virt_timer_irq;
>   
> +    vms->no_gicv3_with_gicv2m = vmc->no_gicv3_with_gicv2m;
> +
>       fdt_add_timer_nodes(vms);
>       fdt_add_cpu_nodes(vms);
>   
> @@ -3488,6 +3492,7 @@ static void virt_instance_init(Object *obj)
>       vms->its = true;
>       /* Allow ITS emulation if the machine version supports it */
>       vms->tcg_its = !vmc->no_tcg_its;
> +    vms->no_gicv3_with_gicv2m = false;
>   
>       /* Default disallows iommu instantiation */
>       vms->iommu = VIRT_IOMMU_NONE;
> @@ -3533,10 +3538,19 @@ static void machvirt_machine_init(void)
>   }
>   type_init(machvirt_machine_init);
>   
> +static void virt_machine_11_0_options(MachineClass *mc)
> +{
> +}
> +DEFINE_VIRT_MACHINE_AS_LATEST(11, 0)
> +
>   static void virt_machine_10_2_options(MachineClass *mc)
>   {
> +    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
> +
> +    vmc->no_gicv3_with_gicv2m = true;
> +    virt_machine_11_0_options(mc);
>   }
> -DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
> +DEFINE_VIRT_MACHINE(10, 2)
>   
>   static void virt_machine_10_1_options(MachineClass *mc)
>   {
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 8694aaa4e2..c5bc47ee88 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -130,6 +130,7 @@ struct VirtMachineClass {
>       bool no_cpu_topology;
>       bool no_tcg_lpa2;
>       bool no_ns_el2_virt_timer_irq;
> +    bool no_gicv3_with_gicv2m;
>       bool no_nested_smmu;
>   };
>   
> @@ -178,6 +179,7 @@ struct VirtMachineState {
>       char *oem_id;
>       char *oem_table_id;
>       bool ns_el2_virt_timer_irq;
> +    bool no_gicv3_with_gicv2m;
>       CXLState cxl_devices_state;
>       bool legacy_smmuv3_present;
>   };


