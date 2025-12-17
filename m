Return-Path: <kvm+bounces-66168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3621FCC7DBC
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 14:37:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 60B0E302653A
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74163659E8;
	Wed, 17 Dec 2025 13:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czd1ZjIv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Buc8EGhu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C1A33D6F1
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978366; cv=none; b=eWH/+y9NccWEP4G1xOLRXQHkCaz1l9bmsoWCi4/AhSqsF/7PUPuJm7dNFO/ysmURUln8k5ToCi6Wlc1Xtwr3WVRSt0ptIUwhOayI2FgwdOSUeplOiXXOZK4si0hvcIH5eYj0NiqQvI1USfGbu6r4M5qB1Kk+JhcGpEafp+DC470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978366; c=relaxed/simple;
	bh=GcmYvmQqjnAaAu8m8L0HtAe5fJnCcmQQ8b/cUpuilfA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2yOGSo/YcaD+fPDex938IlQOzjj2wB3ro7rppAswh+h1DtNzvhWZ0AmmzD2ypMQaBXaCFFafLfE1AUdkv+sQoiUEIYmzbqE5U9Xbn4fT/RXoQbO6tZBZSEzANFaRNy9rqY9Rt5F284krDoC3YTuvM03payc8Napi1WeKyza1SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=czd1ZjIv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Buc8EGhu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765978363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y88grvNyA6vLs9Q+keb1EkjPRPpjjnzTbnJK7zRddLU=;
	b=czd1ZjIvozLa31vvMaJKyMrXYDqSAS4HT2ZyIg8iz6qyQZjsU3mgNC9nBgWp8timCyL+4m
	/Z2R2F7UVsVS4scVYWmP87FmuS3YPAVQIGZyDxdKeat8xNSMkJMyzYzuo0hm889MLe3Ohm
	Exy9aEZmbOmp+eAlJsee748pdb3HFto=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-LVuia9QwPvud129LSaySgQ-1; Wed, 17 Dec 2025 08:32:42 -0500
X-MC-Unique: LVuia9QwPvud129LSaySgQ-1
X-Mimecast-MFC-AGG-ID: LVuia9QwPvud129LSaySgQ_1765978361
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477cabba65dso37473255e9.2
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 05:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765978361; x=1766583161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y88grvNyA6vLs9Q+keb1EkjPRPpjjnzTbnJK7zRddLU=;
        b=Buc8EGhu5W/YPvSGzl4iVYnLcjHaYVEgT0YnU15TkoBR/zphu4+r02DDymFx680SyV
         5SY5xWMVpGfODkst+MI7jyS7/08Owi0MaC4gxWbESyrE5Y9yfm8mFHVftjpWhnFx4MiN
         bVRP1O6YWuvDophSg5w5KXK4GouEpBvFqqNwvDyD1uhD9M9Le+yKTWhNj51R32WsenIt
         vL3/eyWasZeJCc2voZIq96vGYZgoUo0tNBtvA9wrSDTTh4rsQpEak7JCcn71MCojHM2r
         PpdNoaLjdWdp1s99U8aOcRWcPCCes/TPibAXoBzFAF3LbITCtQp18ywRNpBovWTBP//S
         7edA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765978361; x=1766583161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y88grvNyA6vLs9Q+keb1EkjPRPpjjnzTbnJK7zRddLU=;
        b=NnWYuAJTFMT5Zyf5oASGXDBXaVnddbUKET9w2b9w97flEw14mvgOAI2VDP2okwcCwN
         ef2Ku1TWSiD80obZePic129rr29oOPvVKDKADRwpISY6T4fF3+lXyEkzfduZBGV2ko85
         tZ2nZUixV9uGSlcka+GdeiWFBa3pee2jz3FjxnfRprHmBhEkJBC4AG/NF0jFQ/S4fB7H
         3jGmlNQNhdwf1IKYRYSJF8egYgYIzE5yFaySseKwrMEEIT80ayuCxOlQSdEsoAhwXlAT
         L30ITCXuUThdYir4Ne1Z+EBRvTaUQrz5a59g0YQIpQ38avsMl5scWK9EwCxld7MGrYuV
         HJtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtlU2mURoCqf3DMIxrprdXugit0U41SoIsExI7flfVWihp9V+ElptGAXFE7T4DTVB+KMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRmYtQS2Rw1qELXJ/08JLtnz8dFmVFjxDXLRKPL59yq2+2y/iF
	ng4EDLC23wkAtvxx9SzqhGeVMBcW1/rA5jdPLvAbsWuCybgqEOelHTamEsAeQzY2yv5R1OWqgOF
	ju5TjArSwy+fEOjOH+fXIZWj0eAy2zRSIcItbG9Q1pDYj1a5wH6QjXA==
X-Gm-Gg: AY/fxX6oBnyBllcZZMBkDQPPPNMwoZ+xxovQl5lFlPyildb/cCdI4PTekXM4wFh0tys
	IXAVnO6P8fJxfzNc8SgD9hILQN4umVWLguwbQLVjGfhqCmaUdZe1J0Darl8LdClb1MV7xKk3uxl
	JklioxspH1XAn3gcC4fPyN4LtpuJjZDjgfEnH0Z2qXhcB9L1Pw9C3rPHYEP/oXSGMuTFF9krZVB
	5zFk7Cyf9H3ACwvX/YcdkY8/ktHu6WUExk1+YQzBmOjghOTXNhrvEE1SYnsANLFU35fDsTTacQs
	qdNO09jclaRZbqjgYmA4YHknm7ThpS+FnFIHqYc5dmR4ORn5O1TyzlL84JgdnAIX9TWK7Q==
X-Received: by 2002:a05:600c:4f90:b0:477:9dc1:b706 with SMTP id 5b1f17b1804b1-47a8f9055bfmr166586265e9.19.1765978361060;
        Wed, 17 Dec 2025 05:32:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1DBxXjUwAXD60W++JB0qTpdlbwvJgM0HJ5acxEXUSUAiFGW/S+fxK32pWtLvkiy3PWkiKnQ==
X-Received: by 2002:a05:600c:4f90:b0:477:9dc1:b706 with SMTP id 5b1f17b1804b1-47a8f9055bfmr166585685e9.19.1765978360422;
        Wed, 17 Dec 2025 05:32:40 -0800 (PST)
Received: from imammedo ([213.175.46.86])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bdc1de9cesm39837815e9.8.2025.12.17.05.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 05:32:39 -0800 (PST)
Date: Wed, 17 Dec 2025 14:32:37 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?=
 <philmd@linaro.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Thomas
 Huth <thuth@redhat.com>, qemu-devel@nongnu.org, devel@lists.libvirt.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org, Richard
 Henderson <richard.henderson@linaro.org>, Sergio Lopez <slp@redhat.com>,
 Gerd Hoffmann <kraxel@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, Laurent Vivier <lvivier@redhat.com>, Jiaxun
 Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, Eduardo
 Habkost <eduardo@habkost.net>, Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Weiwei Li <liwei1518@gmail.com>, Amit Shah
 <amit@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, Yanan Wang
 <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, Palmer Dabbelt
 <palmer@dabbelt.com>, "Daniel P . =?UTF-8?B?QmVycmFuZ8Op?="
 <berrange@redhat.com>, Ani Sinha <anisinha@redhat.com>, Fabiano Rosas
 <farosas@suse.de>, Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?B?Q2zDqW1lbnQ=?= Mathieu--Drif <clement.mathieu--drif@eviden.com>,
 =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>, Huacai
 Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>, Mark
 Cave-Ayland <mark.caveayland@nutanix.com>, BALATON Zoltan
 <balaton@eik.bme.hu>, Peter Krempa <pkrempa@redhat.com>, Jiri Denemark
 <jdenemar@redhat.com>
Subject: Re: [PATCH v5 03/28] pc: Start with modern CPU hotplug interface by
 default
Message-ID: <20251217143237.7829af2e@imammedo>
In-Reply-To: <20251202162835.3227894-4-zhao1.liu@intel.com>
References: <20251202162835.3227894-1-zhao1.liu@intel.com>
	<20251202162835.3227894-4-zhao1.liu@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  3 Dec 2025 00:28:10 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> From: Igor Mammedov <imammedo@redhat.com>
^^^
given you resplit original patch, it's better to replace this with you,
keeping my SoB is sufficient

> 
> For compatibility reasons PC/Q35 will start with legacy CPU hotplug
> interface by default but with new CPU hotplug AML code since 2.7
> machine type (in commit 679dd1a957df ("pc: use new CPU hotplug interface
> since 2.7 machine type")). In that way, legacy firmware that doesn't use
> QEMU generated ACPI tables was able to continue using legacy CPU hotplug
> interface.
> 
> While later machine types, with firmware supporting QEMU provided ACPI
> tables, generate new CPU hotplug AML, which will switch to new CPU
> hotplug interface when guest OS executes its _INI method on ACPI tables
> loading.
> 
> Since 2.6 machine type is now gone, and consider that the legacy BIOS
> (based on QEMU ACPI prior to v2.7) should be no longer in use, previous
> compatibility requirements are no longer necessary. So initialize
> 'modern' hotplug directly from the very beginning for PC/Q35 machines
> with cpu_hotplug_hw_init(), and drop _INIT method.
> 
> Additionally, remove the checks and settings around cpu_hotplug_legacy
> in cpuhp VMState (for piix4 & ich9), to eliminate the risk of
> segmentation faults, as gpe_cpu no longer has the opportunity to be
> initialized. This is safe because all hotplug now start with the modern
> way, and it's impossible to switch to legacy way at runtime (even the
> "cpu-hotplug-legacy" properties does not allow it either).
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

tested ping pong cross version (master vs master+this patch) migration
with 10.1 machine type, nothing is broken, hence

Acked-by: Igor Mammedov <imammedo@redhat.com>

> ---
> Changes since v4:
>  * New patch split off from Igor's v5 [*].
> 
> [*]: https://lore.kernel.org/qemu-devel/20251031142825.179239-1-imammedo@redhat.com/
> ---
>  hw/acpi/cpu.c                  | 10 ----------
>  hw/acpi/ich9.c                 | 22 +++-------------------
>  hw/acpi/piix4.c                | 21 +++------------------
>  hw/i386/acpi-build.c           |  2 +-
>  hw/loongarch/virt-acpi-build.c |  1 -
>  include/hw/acpi/cpu.h          |  1 -
>  6 files changed, 7 insertions(+), 50 deletions(-)
> 
> diff --git a/hw/acpi/cpu.c b/hw/acpi/cpu.c
> index 6f1ae79edbf3..d63ca83c1bcd 100644
> --- a/hw/acpi/cpu.c
> +++ b/hw/acpi/cpu.c
> @@ -408,16 +408,6 @@ void build_cpus_aml(Aml *table, MachineState *machine, CPUHotplugFeatures opts,
>          aml_append(field, aml_reserved_field(4 * 8));
>          aml_append(field, aml_named_field(CPU_DATA, 32));
>          aml_append(cpu_ctrl_dev, field);
> -
> -        if (opts.has_legacy_cphp) {
> -            method = aml_method("_INI", 0, AML_SERIALIZED);
> -            /* switch off legacy CPU hotplug HW and use new one,
> -             * on reboot system is in new mode and writing 0
> -             * in CPU_SELECTOR selects BSP, which is NOP at
> -             * the time _INI is called */
> -            aml_append(method, aml_store(zero, aml_name(CPU_SELECTOR)));
> -            aml_append(cpu_ctrl_dev, method);
> -        }
>      }
>      aml_append(sb_scope, cpu_ctrl_dev);
>  
> diff --git a/hw/acpi/ich9.c b/hw/acpi/ich9.c
> index 2b3b493c014b..54590129c695 100644
> --- a/hw/acpi/ich9.c
> +++ b/hw/acpi/ich9.c
> @@ -183,26 +183,10 @@ static const VMStateDescription vmstate_tco_io_state = {
>      }
>  };
>  
> -static bool vmstate_test_use_cpuhp(void *opaque)
> -{
> -    ICH9LPCPMRegs *s = opaque;
> -    return !s->cpu_hotplug_legacy;
> -}
> -
> -static int vmstate_cpuhp_pre_load(void *opaque)
> -{
> -    ICH9LPCPMRegs *s = opaque;
> -    Object *obj = OBJECT(s->gpe_cpu.device);
> -    object_property_set_bool(obj, "cpu-hotplug-legacy", false, &error_abort);
> -    return 0;
> -}
> -
>  static const VMStateDescription vmstate_cpuhp_state = {
>      .name = "ich9_pm/cpuhp",
>      .version_id = 1,
>      .minimum_version_id = 1,
> -    .needed = vmstate_test_use_cpuhp,
> -    .pre_load = vmstate_cpuhp_pre_load,
>      .fields = (const VMStateField[]) {
>          VMSTATE_CPU_HOTPLUG(cpuhp_state, ICH9LPCPMRegs),
>          VMSTATE_END_OF_LIST()
> @@ -338,8 +322,8 @@ void ich9_pm_init(PCIDevice *lpc_pci, ICH9LPCPMRegs *pm, qemu_irq sci_irq)
>      pm->powerdown_notifier.notify = pm_powerdown_req;
>      qemu_register_powerdown_notifier(&pm->powerdown_notifier);
>  
> -    legacy_acpi_cpu_hotplug_init(pci_address_space_io(lpc_pci),
> -        OBJECT(lpc_pci), &pm->gpe_cpu, ICH9_CPU_HOTPLUG_IO_BASE);
> +    cpu_hotplug_hw_init(pci_address_space_io(lpc_pci),
> +        OBJECT(lpc_pci), &pm->cpuhp_state, ICH9_CPU_HOTPLUG_IO_BASE);
>  
>      acpi_memory_hotplug_init(pci_address_space_io(lpc_pci), OBJECT(lpc_pci),
>                               &pm->acpi_memory_hotplug,
> @@ -419,7 +403,7 @@ void ich9_pm_add_properties(Object *obj, ICH9LPCPMRegs *pm)
>  {
>      static const uint32_t gpe0_len = ICH9_PMIO_GPE0_LEN;
>      pm->acpi_memory_hotplug.is_enabled = true;
> -    pm->cpu_hotplug_legacy = true;
> +    pm->cpu_hotplug_legacy = false;
>      pm->disable_s3 = 0;
>      pm->disable_s4 = 0;
>      pm->s4_val = 2;
> diff --git a/hw/acpi/piix4.c b/hw/acpi/piix4.c
> index 7a18f18dda21..a7a29b0d09a9 100644
> --- a/hw/acpi/piix4.c
> +++ b/hw/acpi/piix4.c
> @@ -195,25 +195,10 @@ static const VMStateDescription vmstate_memhp_state = {
>      }
>  };
>  
> -static bool vmstate_test_use_cpuhp(void *opaque)
> -{
> -    PIIX4PMState *s = opaque;
> -    return !s->cpu_hotplug_legacy;
> -}
> -
> -static int vmstate_cpuhp_pre_load(void *opaque)
> -{
> -    Object *obj = OBJECT(opaque);
> -    object_property_set_bool(obj, "cpu-hotplug-legacy", false, &error_abort);
> -    return 0;
> -}
> -
>  static const VMStateDescription vmstate_cpuhp_state = {
>      .name = "piix4_pm/cpuhp",
>      .version_id = 1,
>      .minimum_version_id = 1,
> -    .needed = vmstate_test_use_cpuhp,
> -    .pre_load = vmstate_cpuhp_pre_load,
>      .fields = (const VMStateField[]) {
>          VMSTATE_CPU_HOTPLUG(cpuhp_state, PIIX4PMState),
>          VMSTATE_END_OF_LIST()
> @@ -573,12 +558,12 @@ static void piix4_acpi_system_hot_add_init(MemoryRegion *parent,
>          qbus_set_hotplug_handler(BUS(pci_get_bus(PCI_DEVICE(s))), OBJECT(s));
>      }
>  
> -    s->cpu_hotplug_legacy = true;
> +    s->cpu_hotplug_legacy = false;
>      object_property_add_bool(OBJECT(s), "cpu-hotplug-legacy",
>                               piix4_get_cpu_hotplug_legacy,
>                               piix4_set_cpu_hotplug_legacy);
> -    legacy_acpi_cpu_hotplug_init(parent, OBJECT(s), &s->gpe_cpu,
> -                                 PIIX4_CPU_HOTPLUG_IO_BASE);
> +    cpu_hotplug_hw_init(parent, OBJECT(s), &s->cpuhp_state,
> +                        PIIX4_CPU_HOTPLUG_IO_BASE);
>  
>      if (s->acpi_memory_hotplug.is_enabled) {
>          acpi_memory_hotplug_init(parent, OBJECT(s), &s->acpi_memory_hotplug,
> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> index 9446a9f862ca..23147ddc25e7 100644
> --- a/hw/i386/acpi-build.c
> +++ b/hw/i386/acpi-build.c
> @@ -964,7 +964,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
>          build_legacy_cpu_hotplug_aml(dsdt, machine, pm->cpu_hp_io_base);
>      } else {
>          CPUHotplugFeatures opts = {
> -            .acpi_1_compatible = true, .has_legacy_cphp = true,
> +            .acpi_1_compatible = true,
>              .smi_path = pm->smi_on_cpuhp ? "\\_SB.PCI0.SMI0.SMIC" : NULL,
>              .fw_unplugs_cpu = pm->smi_on_cpu_unplug,
>          };
> diff --git a/hw/loongarch/virt-acpi-build.c b/hw/loongarch/virt-acpi-build.c
> index 3694c9827f04..8d01c8e3de87 100644
> --- a/hw/loongarch/virt-acpi-build.c
> +++ b/hw/loongarch/virt-acpi-build.c
> @@ -369,7 +369,6 @@ build_la_ged_aml(Aml *dsdt, MachineState *machine)
>  
>      if (event & ACPI_GED_CPU_HOTPLUG_EVT) {
>          opts.acpi_1_compatible = false;
> -        opts.has_legacy_cphp = false;
>          opts.fw_unplugs_cpu = false;
>          opts.smi_path = NULL;
>  
> diff --git a/include/hw/acpi/cpu.h b/include/hw/acpi/cpu.h
> index 32654dc274fd..2cb0ca4f3dce 100644
> --- a/include/hw/acpi/cpu.h
> +++ b/include/hw/acpi/cpu.h
> @@ -54,7 +54,6 @@ void cpu_hotplug_hw_init(MemoryRegion *as, Object *owner,
>  
>  typedef struct CPUHotplugFeatures {
>      bool acpi_1_compatible;
> -    bool has_legacy_cphp;
>      bool fw_unplugs_cpu;
>      const char *smi_path;
>  } CPUHotplugFeatures;


