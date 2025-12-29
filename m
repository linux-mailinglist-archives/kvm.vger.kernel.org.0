Return-Path: <kvm+bounces-66794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CDBA6CE7FAA
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 20:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B3F1302BAAA
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 19:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F4D2EF64C;
	Mon, 29 Dec 2025 18:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JyryG4N3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7E23321C1
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033913; cv=none; b=pQAmImW762djLI4pVTAC+uUuk5Ms40J2RD8uv7sgCvn27PTxK5RWUUHb7CcFMWNUliQCxPPPNKJSCfHZ7nYb/9o4mKmyA63IEYjB43lJzqEOvfTvMiOyl09b1ggTNklfVddbVdbaqum44fLTx7h7z0jlYwlElOdMk+H4L470mrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033913; c=relaxed/simple;
	bh=LfHwiOYTXdh6VEESV+TofAVzBrJ1OupvTivnwGb6Aew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UUWKHCkw3q0kOqepWR3gESCSi+g988fHbFSnkh18XZzDZawTUhA/6PzaMAUg5+GjCWbGfAFGUHwcDZh1Gzn3hCR1b9d4F3QIfl4uNJnpXbO7iNWVUWoj+2bVRSwesVdjINAdacZKe7ZYr0U+g7nbTxbAly3W66ekImUZBOumZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JyryG4N3; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0d0788adaso83182045ad.3
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 10:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767033910; x=1767638710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L5b0ZmnLwNNT+g6DJnrDN46+Pb4pwpxsVnlZ830iB9g=;
        b=JyryG4N3+5EyP3maC9yNZXysACm6ZHdKj7mvWCxc5ST9DvGhVkcZuHMPq5m+IhB4Kb
         QsY2R9iphaCo+L2+GYk7YoE6oWer+VWDYj0gR7IHxSXgI8N82L6Mkr7neSJrrvu56dOS
         r1nPOhxuCK8YogFPC7nGkmwN24kekOtWNVFHwgOliZYKNB5w+f53NFv44dTY4qRSEYl3
         BNNXnfOmr9zNbMY3/ac9yQgoGWQ/VFYjF3VxHLNTUJu9Si4yTHuMyKEcilppNxI9k/hx
         mnwfNEI6tYXbYRvfMZ55PYcQzpzI54kkgYPdrLfR3Gdcnt4QShzJsd4xrzj2ytSgNdI2
         AbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033910; x=1767638710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L5b0ZmnLwNNT+g6DJnrDN46+Pb4pwpxsVnlZ830iB9g=;
        b=f8nS9ZiadoTVjBpx94ZQ+AjNnbQHmHhFR2tyC57Ew5HmHJYsEIYSTrZv1Y5VDSZAUz
         9eab2XoYamgdXOyKpSCtJlMvyGmernr704eMOBFvwxXv9TrnAMnImxq69mAslCQO0AW8
         t2eDe595KCozXaU4uxWGfrU9O0qI1ids4zCqtpuQWGdHJ5inwMxKiEOy3lrueirRQQ+x
         y0n7cFWdRnnDLKVpnyIlq8ja0RSFYauwKEZ2XrTR08DAye87tjWXguEZYvOUc9KfL6cv
         xhIP9zlUE5Q7YdNYmro2maYchphK2SNyhyDcPE6QN92VPAQQliDGG6w1ng6UXF/+3Sj7
         RofA==
X-Forwarded-Encrypted: i=1; AJvYcCXfpB51dhh4hj93DH9tIs0Batc9O2yr/dXxIYAqf/lIXJeakymuGU9HBE77BmT97z4tEss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn9/yLBMNv8G9cQodcrZHLxtJHLjwu8474bukjB3FtSjC6snao
	PyUCePrcvmzmF02qTUZt4mXBaXegKPZx7Qvxr4Iyo4bo9WwChhZuq6wWJKyP43VZdVs=
X-Gm-Gg: AY/fxX5705ayqWoYZpID1/VgshOBBfNPLlK+dBQ++oGtE9HfkZ/waAYWKkSpQz53vs7
	H4mCr4Y8xcKlZsyc0H7JMspzYVL68sohRur5CCeE4ugkor7qs5EYajkc6O9en/XvN9EoPTturn+
	yCf65tbQkjuPpGG8c2XgG2i4ORmBZ7AuejPyQG2ADctLa+LnPnSBvZiHlA8PFOK+7A41la3ht8w
	aFAecqGy6eJyi/W7HHxaJNHft8Z8fBDkJsq9ESQNYNu4ZOptxN38EN9OcEIEGbmD4FCAxHQylrR
	KD0VpoEMQaluY7p/O5P6p+IdBUlHRiM4DCrZD8xe2h5bpNzAQLRR9FVB3iVoKu+DQ58SBMoIe5H
	fl2gQxBBN4OCAm8/YZh46xqyM1JtomI9Alaw4TGDUA8O94TuFAEZiQ+g+AeB6KHvFrEHLdduBJi
	Yk7+ylxLMhAxuirmVfPodALKJZPuHysOahhrU3mwjOnyYB8AoRGA+PN8Me
X-Google-Smtp-Source: AGHT+IExCqEi/ChGsKnsoyZoiipt0DrI7F6rVRq1e9X0KXF+Rj/pzZvX2cLlIQiAOX+og9f6vzqWRA==
X-Received: by 2002:a17:903:b8b:b0:2a1:243:94a8 with SMTP id d9443c01a7336-2a2f2a4f102mr333447125ad.49.1767033909492;
        Mon, 29 Dec 2025 10:45:09 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5d663sm278943885ad.77.2025.12.29.10.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 10:45:09 -0800 (PST)
Message-ID: <e250a18d-9b08-4cb9-88d6-c21d0b8ed60b@linaro.org>
Date: Mon, 29 Dec 2025 10:45:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 07/28] hw: arm: virt: rework MSI-X configuration
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
 <20251228235422.30383-8-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-8-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> Introduce a -M msi= argument to be able to control MSI-X support independently
> from ITS, as part of supporting GICv3 + GICv2m platforms.
> 
> Remove vms->its as it's no longer needed after that change.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt-acpi-build.c |   3 +-
>   hw/arm/virt.c            | 112 +++++++++++++++++++++++++++++++--------
>   include/hw/arm/virt.h    |   4 +-
>   3 files changed, 95 insertions(+), 24 deletions(-)
> 
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 86024a1a73..f3adb95cfe 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -962,8 +962,7 @@ build_madt(GArray *table_data, BIOSLinker *linker, VirtMachineState *vms)
>           }
>       }
>   
> -    if (!(vms->gic_version != VIRT_GIC_VERSION_2 && virt_is_its_enabled(vms))
> -     && !vms->no_gicv3_with_gicv2m) {
> +    if (virt_is_gicv2m_enabled(vms)) {
>           const uint16_t spi_base = vms->irqmap[VIRT_GIC_V2M] + ARM_SPI_BASE;
>   
>           /* 5.2.12.16 GIC MSI Frame Structure */
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index dcdb740586..80c9b2bc76 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -966,12 +966,12 @@ static void create_gic(VirtMachineState *vms, MemoryRegion *mem)
>   
>       fdt_add_gic_node(vms);
>   
> -    if (vms->gic_version != VIRT_GIC_VERSION_2 && virt_is_its_enabled(vms)) {
> +    if (virt_is_its_enabled(vms)) {
>           create_its(vms);
> -    } else if (vms->gic_version != VIRT_GIC_VERSION_2 && !vms->no_gicv3_with_gicv2m) {
> -        create_v2m(vms);
> -    } else if (vms->gic_version == VIRT_GIC_VERSION_2) {
> +    } else if (virt_is_gicv2m_enabled(vms)) {
>           create_v2m(vms);
> +    } else {
> +        vms->msi_controller = VIRT_MSI_CTRL_NONE;
>       }
>   }
>   
> @@ -2710,32 +2710,95 @@ static void virt_set_highmem_mmio_size(Object *obj, Visitor *v,
>   
>   bool virt_is_its_enabled(VirtMachineState *vms)
>   {
> -    if (vms->its == ON_OFF_AUTO_OFF) {
> -        return false;
> +    switch (vms->msi_controller) {
> +        case VIRT_MSI_CTRL_NONE:
> +            return false;
> +        case VIRT_MSI_CTRL_ITS:
> +            return true;
> +        case VIRT_MSI_CTRL_GICV2M:
> +            return false;
> +        case VIRT_MSI_CTRL_AUTO:
> +            if (whpx_enabled() && whpx_irqchip_in_kernel()) {
> +                return false;
> +            }
> +            if (vms->gic_version == VIRT_GIC_VERSION_2) {
> +                return false;
> +            }
> +            return true;
> +        default:
> +            return false;
>       }
> -    if (vms->its == ON_OFF_AUTO_AUTO) {
> -        if (whpx_enabled()) {
> +}

ERROR: switch and case should be at the same indent
#63: FILE: hw/arm/virt.c:2713:
+    switch (vms->msi_controller) {
+        case VIRT_MSI_CTRL_NONE:
[...]
+        case VIRT_MSI_CTRL_ITS:
[...]
+        case VIRT_MSI_CTRL_GICV2M:
[...]
+        case VIRT_MSI_CTRL_AUTO:
[...]
+        default:

> +
> +bool virt_is_gicv2m_enabled(VirtMachineState *vms)
> +{
> +    switch (vms->msi_controller) {
> +        case VIRT_MSI_CTRL_NONE:
>               return false;
> -        }
> +        default:
> +            return !virt_is_its_enabled(vms);

#89: FILE: hw/arm/virt.c:2735:
+    switch (vms->msi_controller) {
+        case VIRT_MSI_CTRL_NONE:
[...]
+        default:

>       }
> -    return true;
>   }
>   
> -static void virt_get_its(Object *obj, Visitor *v, const char *name,
> -                          void *opaque, Error **errp)
> +static char *virt_get_msi(Object *obj, Error **errp)
>   {
>       VirtMachineState *vms = VIRT_MACHINE(obj);
> -    OnOffAuto its = vms->its;
> +    const char *val;
>   
> -    visit_type_OnOffAuto(v, name, &its, errp);
> +    switch (vms->msi_controller) {
> +    case VIRT_MSI_CTRL_NONE:
> +        val = "off";
> +        break;
> +    case VIRT_MSI_CTRL_ITS:
> +        val = "its";
> +        break;
> +    case VIRT_MSI_CTRL_GICV2M:
> +        val = "gicv2m";
> +        break;
> +    default:
> +        val = "auto";
> +        break;
> +    }
> +    return g_strdup(val);
>   }
>   
> -static void virt_set_its(Object *obj, Visitor *v, const char *name,
> -                          void *opaque, Error **errp)
> +static void virt_set_msi(Object *obj, const char *value, Error **errp)
>   {
> +    ERRP_GUARD();
>       VirtMachineState *vms = VIRT_MACHINE(obj);
>   
> -    visit_type_OnOffAuto(v, name, &vms->its, errp);
> +    if (!strcmp(value, "auto")) {
> +        vms->msi_controller = VIRT_MSI_CTRL_AUTO; /* Will be overriden later */
> +    } else if (!strcmp(value, "its")) {
> +        vms->msi_controller = VIRT_MSI_CTRL_ITS;
> +    } else if (!strcmp(value, "gicv2m")) {
> +        vms->msi_controller = VIRT_MSI_CTRL_GICV2M;
> +    } else if (!strcmp(value, "none")) {
> +        vms->msi_controller = VIRT_MSI_CTRL_NONE;
> +    } else {
> +        error_setg(errp, "Invalid msi value");
> +        error_append_hint(errp, "Valid values are auto, gicv2m, its, off\n");
> +    }
> +}
> +
> +static bool virt_get_its(Object *obj, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    return virt_is_its_enabled(vms);
> +}
> +
> +static void virt_set_its(Object *obj, bool value, Error **errp)
> +{
> +    VirtMachineState *vms = VIRT_MACHINE(obj);
> +
> +    if (value) {
> +        vms->msi_controller = VIRT_MSI_CTRL_ITS;
> +    } else if (vms->no_gicv3_with_gicv2m) {
> +        vms->msi_controller = VIRT_MSI_CTRL_NONE;
> +    } else {
> +        vms->msi_controller = VIRT_MSI_CTRL_GICV2M;
> +    }
>   }
>   
>   static bool virt_get_dtb_randomness(Object *obj, Error **errp)
> @@ -3062,6 +3125,8 @@ static void virt_machine_device_pre_plug_cb(HotplugHandler *hotplug_dev,
>               db_start = base_memmap[VIRT_GIC_V2M].base;
>               db_end = db_start + base_memmap[VIRT_GIC_V2M].size - 1;
>               break;
> +        case VIRT_MSI_CTRL_AUTO:
> +            g_assert_not_reached();
>           }
>           resv_prop_str = g_strdup_printf("0x%"PRIx64":0x%"PRIx64":%u",
>                                           db_start, db_end,
> @@ -3452,13 +3517,18 @@ static void virt_machine_class_init(ObjectClass *oc, const void *data)
>                                             "guest CPU which implements the ARM "
>                                             "Memory Tagging Extension");
>   
> -    object_class_property_add(oc, "its", "OnOffAuto",
> -        virt_get_its, virt_set_its,
> -        NULL, NULL);
> +    object_class_property_add_bool(oc, "its", virt_get_its,
> +                                   virt_set_its);
>       object_class_property_set_description(oc, "its",
>                                             "Set on/off to enable/disable "
>                                             "ITS instantiation");
>   
> +    object_class_property_add_str(oc, "msi", virt_get_msi,
> +                                  virt_set_msi);
> +    object_class_property_set_description(oc, "msi",
> +                                          "Set MSI settings. "
> +                                          "Valid values are auto/gicv2m/its/off");
> +
>       object_class_property_add_bool(oc, "dtb-randomness",
>                                      virt_get_dtb_randomness,
>                                      virt_set_dtb_randomness);
> @@ -3515,7 +3585,7 @@ static void virt_instance_init(Object *obj)
>       vms->highmem_redists = true;
>   
>       /* Default allows ITS instantiation if available */
> -    vms->its = ON_OFF_AUTO_AUTO;
> +    vms->msi_controller = VIRT_MSI_CTRL_AUTO;
>       /* Allow ITS emulation if the machine version supports it */
>       vms->tcg_its = !vmc->no_tcg_its;
>       vms->no_gicv3_with_gicv2m = false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 394b70c62e..ff43bcb739 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -101,6 +101,8 @@ typedef enum VirtIOMMUType {
>   
>   typedef enum VirtMSIControllerType {
>       VIRT_MSI_CTRL_NONE,
> +    /* This value is overriden at runtime.*/
> +    VIRT_MSI_CTRL_AUTO,
>       VIRT_MSI_CTRL_GICV2M,
>       VIRT_MSI_CTRL_ITS,
>   } VirtMSIControllerType;
> @@ -147,7 +149,6 @@ struct VirtMachineState {
>       bool highmem_ecam;
>       bool highmem_mmio;
>       bool highmem_redists;
> -    OnOffAuto its;
>       bool tcg_its;
>       bool virt;
>       bool ras;
> @@ -217,5 +218,6 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
>   }
>   
>   bool virt_is_its_enabled(VirtMachineState *vms);
> +bool virt_is_gicv2m_enabled(VirtMachineState *vms);
>   
>   #endif /* QEMU_ARM_VIRT_H */


