Return-Path: <kvm+bounces-33675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBB59EFF74
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1AA2287E92
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063EF1DE3BF;
	Thu, 12 Dec 2024 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJ6Zrlh6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8B81DE2BF
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 22:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734043170; cv=none; b=ThxPKZ/Jw3lRY2GHOWot982LnrpKgW/ZwI9x/OlubB0aKSlOump0nLCsU5gIfb4H0q4dtGIxVVwff5cudb2zjoJ0P5Hv+v9J/7lEDB8hxjnsULpnVAIGTbc+OgVcF283Rf5B0cyFIG63JPSZHL1emy25Ujm/0JbRC68SeHeBtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734043170; c=relaxed/simple;
	bh=Dx1pCgOKfCM6Pfwcm0hvidzjoLxwUGW6oVYngdYvDnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdVf6l9y7UV1gSiLy9iOOYgzg6bRIhzHM3rqAkQZTuco521T9tslqXy+9MXSXQHuTJSQBlG4GUwsE5z2owIqBiZMKMKwFMCwo7jPl2ZDU3y+BzGQs1IQbOuqgD7BCOgp3U272gfHaE2AlASej86OjMVJtGfcUoPv1e0Gn2KkSlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dJ6Zrlh6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734043168; x=1765579168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Dx1pCgOKfCM6Pfwcm0hvidzjoLxwUGW6oVYngdYvDnM=;
  b=dJ6Zrlh6MO3lnsi1cWshRPwtivguozesQGrXyR176f+Ien0hBrzHLQdn
   UouqYLID4qvDyDFev5ozXltRdGGFZV6t0cUti/mnnvQzyxRiRs9Trik5c
   zc/c51WsCzz9Lfth6qLXnvD0CpFNjh9SRJvq0YD+DgkU/V+jRUeC271ik
   hmriFg26KseDDTnjoKj2KWD4LXkXxPD2eBrazH4V1zASnQcoFvCHRUK4c
   sBwstUDdZUwQKCqzMpP2mDdwb7kqRTSkGTN7vu5f8/gUoeG6xqrf87V93
   31YrIuOG4ba3l7lHYNToVxS14hF/p7WN2JGXmxnl0tZbk6ftdSkA577KJ
   A==;
X-CSE-ConnectionGUID: c3rRIr4ITI+afjOvwc/svQ==
X-CSE-MsgGUID: 8n6TQ/YtRd2/dPwzgp/V3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34402281"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34402281"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:39:27 -0800
X-CSE-ConnectionGUID: xhPMYdLvR1WtXCHM1WHLFA==
X-CSE-MsgGUID: BiYusKpFQoib9L/irnMkzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100522690"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:39:25 -0800
Date: Thu, 12 Dec 2024 16:39:23 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 41/60] hw/i386: add option to forcibly report edge
 trigger in acpi tables
Message-ID: <Z1tmG63P4TR0UYO8@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-42-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-42-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:23:49AM -0500, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> When level trigger isn't supported on x86 platform,
> forcibly report edge trigger in acpi tables.

This commit message is pretty sparse.  I was thinking of suggesting to squash
this with patch 40 but it occurred to me that perhaps these are split to accept
TDX specifics from general functionality.  Is that the case here?  Is that true
with other patches in the series?  If so what other situations would require
this in the generic code beyond TDX?

Ira

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  hw/i386/acpi-build.c  | 99 ++++++++++++++++++++++++++++---------------
>  hw/i386/acpi-common.c | 45 +++++++++++++++-----
>  2 files changed, 101 insertions(+), 43 deletions(-)
> 
> diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
> index 4967aa745902..d0a5bfc69e9a 100644
> --- a/hw/i386/acpi-build.c
> +++ b/hw/i386/acpi-build.c
> @@ -888,7 +888,8 @@ static void build_dbg_aml(Aml *table)
>      aml_append(table, scope);
>  }
>  
> -static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
> +static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg,
> +                           bool level_trigger_unsupported)
>  {
>      Aml *dev;
>      Aml *crs;
> @@ -900,7 +901,10 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
>      aml_append(dev, aml_name_decl("_UID", aml_int(uid)));
>  
>      crs = aml_resource_template();
> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> +                                  level_trigger_unsupported ?
> +                                  AML_EDGE : AML_LEVEL,
> +                                  AML_ACTIVE_HIGH,
>                                    AML_SHARED, irqs, ARRAY_SIZE(irqs)));
>      aml_append(dev, aml_name_decl("_PRS", crs));
>  
> @@ -924,7 +928,8 @@ static Aml *build_link_dev(const char *name, uint8_t uid, Aml *reg)
>      return dev;
>   }
>  
> -static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
> +static Aml *build_gsi_link_dev(const char *name, uint8_t uid,
> +                               uint8_t gsi, bool level_trigger_unsupported)
>  {
>      Aml *dev;
>      Aml *crs;
> @@ -937,7 +942,10 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
>  
>      crs = aml_resource_template();
>      irqs = gsi;
> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL, AML_ACTIVE_HIGH,
> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> +                                  level_trigger_unsupported ?
> +                                  AML_EDGE : AML_LEVEL,
> +                                  AML_ACTIVE_HIGH,
>                                    AML_SHARED, &irqs, 1));
>      aml_append(dev, aml_name_decl("_PRS", crs));
>  
> @@ -956,7 +964,7 @@ static Aml *build_gsi_link_dev(const char *name, uint8_t uid, uint8_t gsi)
>  }
>  
>  /* _CRS method - get current settings */
> -static Aml *build_iqcr_method(bool is_piix4)
> +static Aml *build_iqcr_method(bool is_piix4, bool level_trigger_unsupported)
>  {
>      Aml *if_ctx;
>      uint32_t irqs;
> @@ -964,7 +972,9 @@ static Aml *build_iqcr_method(bool is_piix4)
>      Aml *crs = aml_resource_template();
>  
>      irqs = 0;
> -    aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
> +    aml_append(crs, aml_interrupt(AML_CONSUMER,
> +                                  level_trigger_unsupported ?
> +                                  AML_EDGE : AML_LEVEL,
>                                    AML_ACTIVE_HIGH, AML_SHARED, &irqs, 1));
>      aml_append(method, aml_name_decl("PRR0", crs));
>  
> @@ -998,7 +1008,7 @@ static Aml *build_irq_status_method(void)
>      return method;
>  }
>  
> -static void build_piix4_pci0_int(Aml *table)
> +static void build_piix4_pci0_int(Aml *table, bool level_trigger_unsupported)
>  {
>      Aml *dev;
>      Aml *crs;
> @@ -1011,12 +1021,16 @@ static void build_piix4_pci0_int(Aml *table)
>      aml_append(sb_scope, pci0_scope);
>  
>      aml_append(sb_scope, build_irq_status_method());
> -    aml_append(sb_scope, build_iqcr_method(true));
> +    aml_append(sb_scope, build_iqcr_method(true, level_trigger_unsupported));
>  
> -    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0")));
> -    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1")));
> -    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2")));
> -    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3")));
> +    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQ0"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQ1"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQ2"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQ3"),
> +                                        level_trigger_unsupported));
>  
>      dev = aml_device("LNKS");
>      {
> @@ -1025,7 +1039,9 @@ static void build_piix4_pci0_int(Aml *table)
>  
>          crs = aml_resource_template();
>          irqs = 9;
> -        aml_append(crs, aml_interrupt(AML_CONSUMER, AML_LEVEL,
> +        aml_append(crs, aml_interrupt(AML_CONSUMER,
> +                                      level_trigger_unsupported ?
> +                                      AML_EDGE : AML_LEVEL,
>                                        AML_ACTIVE_HIGH, AML_SHARED,
>                                        &irqs, 1));
>          aml_append(dev, aml_name_decl("_PRS", crs));
> @@ -1111,7 +1127,7 @@ static Aml *build_q35_routing_table(const char *str)
>      return pkg;
>  }
>  
> -static void build_q35_pci0_int(Aml *table)
> +static void build_q35_pci0_int(Aml *table, bool level_trigger_unsupported)
>  {
>      Aml *method;
>      Aml *sb_scope = aml_scope("_SB");
> @@ -1150,25 +1166,41 @@ static void build_q35_pci0_int(Aml *table)
>      aml_append(sb_scope, pci0_scope);
>  
>      aml_append(sb_scope, build_irq_status_method());
> -    aml_append(sb_scope, build_iqcr_method(false));
> +    aml_append(sb_scope, build_iqcr_method(false, level_trigger_unsupported));
>  
> -    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA")));
> -    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB")));
> -    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC")));
> -    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD")));
> -    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE")));
> -    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF")));
> -    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG")));
> -    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH")));
> +    aml_append(sb_scope, build_link_dev("LNKA", 0, aml_name("PRQA"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKB", 1, aml_name("PRQB"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKC", 2, aml_name("PRQC"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKD", 3, aml_name("PRQD"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKE", 4, aml_name("PRQE"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKF", 5, aml_name("PRQF"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKG", 6, aml_name("PRQG"),
> +                                        level_trigger_unsupported));
> +    aml_append(sb_scope, build_link_dev("LNKH", 7, aml_name("PRQH"),
> +                                        level_trigger_unsupported));
>  
> -    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12));
> -    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16));
> -    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIA", 0x10, 0x10,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIB", 0x11, 0x11,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIC", 0x12, 0x12,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSID", 0x13, 0x13,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIE", 0x14, 0x14,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIF", 0x15, 0x15,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIG", 0x16, 0x16,
> +                                            level_trigger_unsupported));
> +    aml_append(sb_scope, build_gsi_link_dev("GSIH", 0x17, 0x17,
> +                                            level_trigger_unsupported));
>  
>      aml_append(table, sb_scope);
>  }
> @@ -1350,6 +1382,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
>      PCMachineState *pcms = PC_MACHINE(machine);
>      PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(machine);
>      X86MachineState *x86ms = X86_MACHINE(machine);
> +    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
>      AcpiMcfgInfo mcfg;
>      bool mcfg_valid = !!acpi_get_mcfg(&mcfg);
>      uint32_t nr_mem = machine->ram_slots;
> @@ -1382,7 +1415,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
>          if (pm->pcihp_bridge_en || pm->pcihp_root_en) {
>              build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
>          }
> -        build_piix4_pci0_int(dsdt);
> +        build_piix4_pci0_int(dsdt, level_trigger_unsupported);
>      } else if (q35) {
>          sb_scope = aml_scope("_SB");
>          dev = aml_device("PCI0");
> @@ -1426,7 +1459,7 @@ build_dsdt(GArray *table_data, BIOSLinker *linker,
>          if (pm->pcihp_bridge_en) {
>              build_x86_acpi_pci_hotplug(dsdt, pm->pcihp_io_base);
>          }
> -        build_q35_pci0_int(dsdt);
> +        build_q35_pci0_int(dsdt, level_trigger_unsupported);
>      }
>  
>      if (misc->has_hpet) {
> diff --git a/hw/i386/acpi-common.c b/hw/i386/acpi-common.c
> index 0cc2919bb851..ad38a6b31162 100644
> --- a/hw/i386/acpi-common.c
> +++ b/hw/i386/acpi-common.c
> @@ -103,6 +103,7 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
>      const CPUArchIdList *apic_ids = mc->possible_cpu_arch_ids(MACHINE(x86ms));
>      AcpiTable table = { .sig = "APIC", .rev = 3, .oem_id = oem_id,
>                          .oem_table_id = oem_table_id };
> +    bool level_trigger_unsupported = x86ms->eoi_intercept_unsupported;
>  
>      acpi_table_begin(&table, table_data);
>      /* Local APIC Address */
> @@ -124,18 +125,42 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
>                       IO_APIC_SECONDARY_ADDRESS, IO_APIC_SECONDARY_IRQBASE);
>      }
>  
> -    if (x86mc->apic_xrupt_override) {
> -        build_xrupt_override(table_data, 0, 2,
> -            0 /* Flags: Conforms to the specifications of the bus */);
> -    }
> +    if (level_trigger_unsupported) {
> +        /* Force edge trigger */
> +        if (x86mc->apic_xrupt_override) {
> +            build_xrupt_override(table_data, 0, 2,
> +                                 /* Flags: active high, edge triggered */
> +                                 1 | (1 << 2));
> +        }
> +
> +        for (i = x86mc->apic_xrupt_override ? 1 : 0; i < 16; i++) {
> +            build_xrupt_override(table_data, i, i,
> +                                 /* Flags: active high, edge triggered */
> +                                 1 | (1 << 2));
> +        }
> +
> +        if (x86ms->ioapic2) {
> +            for (i = 0; i < 16; i++) {
> +                build_xrupt_override(table_data, IO_APIC_SECONDARY_IRQBASE + i,
> +                                     IO_APIC_SECONDARY_IRQBASE + i,
> +                                     /* Flags: active high, edge triggered */
> +                                     1 | (1 << 2));
> +            }
> +        }
> +    } else {
> +        if (x86mc->apic_xrupt_override) {
> +            build_xrupt_override(table_data, 0, 2,
> +                    0 /* Flags: Conforms to the specifications of the bus */);
> +        }
>  
> -    for (i = 1; i < 16; i++) {
> -        if (!(x86ms->pci_irq_mask & (1 << i))) {
> -            /* No need for a INT source override structure. */
> -            continue;
> +        for (i = 1; i < 16; i++) {
> +            if (!(x86ms->pci_irq_mask & (1 << i))) {
> +                /* No need for a INT source override structure. */
> +                continue;
> +            }
> +            build_xrupt_override(table_data, i, i,
> +                0xd /* Flags: Active high, Level Triggered */);
>          }
> -        build_xrupt_override(table_data, i, i,
> -            0xd /* Flags: Active high, Level Triggered */);
>      }
>  
>      if (x2apic_mode) {
> -- 
> 2.34.1
> 

