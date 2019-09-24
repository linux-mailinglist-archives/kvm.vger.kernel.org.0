Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7515CBC8C3
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505038AbfIXNUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:20:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505035AbfIXNUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:20:08 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6942185362
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:20:07 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id w10so565098wrl.5
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMkGwJ185A3EufEUUOg0LyczKk+WAbEF69Eb8rs7OnA=;
        b=LoE83dxH1Zj8BaA6vl4jiw1I5/5/0BXoWzqK6/uIEvfQ5bsScsdzSLQSfIGxyDUN7W
         ZJ+je6AVcV1O875OFJgu9lLZIb70nT4bjRgc3XpC8NV2Wx9XY9TmqYkC2U4Dll03ikiQ
         N9qKyW00QiKU/MiWA40mW3ceMZoR5y4yZFb62B8rKKAS8kVdgEewoVTmnjSZdgRJozxO
         E00Z/Nt0cSnnqFc0Qv5w2oGy3CO1OD5QBkcyi+LC/5DSU+/NiBxsDTiq73Mrv2pswQnS
         8T3VAPMqXVvCJmcV412CtOnfAd4yWwY+x08u5Rmqn9O4raWfLCcoFkzIsVIgbavLSuAV
         wGdw==
X-Gm-Message-State: APjAAAXzKO+eGFThTZb5MzkRjTc8IeMjO8CdurVKenIH8I5WEGenKrfW
        Ovnt2DPvXeBQxr2Vk2ZGxE+WaIQNOJISuCYkeZVuD/PDTd1jEz3L+zk1RIiBAl/qWE+GecUigdl
        1oBjIP3M31AfS
X-Received: by 2002:adf:fc05:: with SMTP id i5mr2366584wrr.134.1569331205837;
        Tue, 24 Sep 2019 06:20:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyyaMvjwlFdhIxoFxQoMzGVN/wkrgJ63ddXRIQ10afUGF5nNdfveLzzGE6odTQNJVQshW/Bbg==
X-Received: by 2002:adf:fc05:: with SMTP id i5mr2366565wrr.134.1569331205606;
        Tue, 24 Sep 2019 06:20:05 -0700 (PDT)
Received: from [192.168.1.115] (240.red-88-21-68.staticip.rima-tde.net. [88.21.68.240])
        by smtp.gmail.com with ESMTPSA id v7sm2055981wru.87.2019.09.24.06.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:20:04 -0700 (PDT)
Subject: Re: [PATCH v4 2/8] hw/i386: Factorize e820 related functions
To:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        pbonzini@redhat.com, rth@twiddle.net, ehabkost@redhat.com,
        lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-3-slp@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <474e1e49-6ae6-bf94-1a92-07c0142aff40@redhat.com>
Date:   Tue, 24 Sep 2019 15:20:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190924124433.96810-3-slp@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/24/19 2:44 PM, Sergio Lopez wrote:
> Extract e820 related functions from pc.c, and put them in e820.c, so
> they can be shared with other components.
> 
> Signed-off-by: Sergio Lopez <slp@redhat.com>
> ---
>  hw/i386/Makefile.objs |  1 +
>  hw/i386/e820.c        | 99 +++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/e820.h        | 11 +++++
>  hw/i386/pc.c          | 66 +----------------------------
>  include/hw/i386/pc.h  | 11 -----
>  target/i386/kvm.c     |  1 +
>  6 files changed, 114 insertions(+), 75 deletions(-)
>  create mode 100644 hw/i386/e820.c
>  create mode 100644 hw/i386/e820.h
> 
> diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
> index c5f20bbd72..149712db07 100644
> --- a/hw/i386/Makefile.objs
> +++ b/hw/i386/Makefile.objs
> @@ -2,6 +2,7 @@ obj-$(CONFIG_KVM) += kvm/
>  obj-y += multiboot.o
>  obj-y += pvh.o
>  obj-y += pc.o
> +obj-y += e820.o

Isn't that commit d6d059ca07ae907b8945f88c382fb54d43f9f03a?
I'm confuse now.

>  obj-$(CONFIG_I440FX) += pc_piix.o
>  obj-$(CONFIG_Q35) += pc_q35.o
>  obj-y += fw_cfg.o pc_sysfw.o
> diff --git a/hw/i386/e820.c b/hw/i386/e820.c
> new file mode 100644
> index 0000000000..d5c5c0d528
> --- /dev/null
> +++ b/hw/i386/e820.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (c) 2003-2004 Fabrice Bellard
> + * Copyright (c) 2019 Red Hat, Inc.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to deal
> + * in the Software without restriction, including without limitation the rights
> + * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> + * copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
> + * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> + * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> + * THE SOFTWARE.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "qemu/cutils.h"
> +#include "qemu/units.h"
> +
> +#include "hw/i386/e820.h"
> +#include "hw/i386/fw_cfg.h"
> +
> +#define E820_NR_ENTRIES		16
> +
> +struct e820_entry {
> +    uint64_t address;
> +    uint64_t length;
> +    uint32_t type;
> +} QEMU_PACKED __attribute((__aligned__(4)));
> +
> +struct e820_table {
> +    uint32_t count;
> +    struct e820_entry entry[E820_NR_ENTRIES];
> +} QEMU_PACKED __attribute((__aligned__(4)));
> +
> +static struct e820_table e820_reserve;
> +static struct e820_entry *e820_table;
> +static unsigned e820_entries;
> +
> +int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
> +{
> +    int index = le32_to_cpu(e820_reserve.count);
> +    struct e820_entry *entry;
> +
> +    if (type != E820_RAM) {
> +        /* old FW_CFG_E820_TABLE entry -- reservations only */
> +        if (index >= E820_NR_ENTRIES) {
> +            return -EBUSY;
> +        }
> +        entry = &e820_reserve.entry[index++];
> +
> +        entry->address = cpu_to_le64(address);
> +        entry->length = cpu_to_le64(length);
> +        entry->type = cpu_to_le32(type);
> +
> +        e820_reserve.count = cpu_to_le32(index);
> +    }
> +
> +    /* new "etc/e820" file -- include ram too */
> +    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
> +    e820_table[e820_entries].address = cpu_to_le64(address);
> +    e820_table[e820_entries].length = cpu_to_le64(length);
> +    e820_table[e820_entries].type = cpu_to_le32(type);
> +    e820_entries++;
> +
> +    return e820_entries;
> +}
> +
> +int e820_get_num_entries(void)
> +{
> +    return e820_entries;
> +}
> +
> +bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
> +{
> +    if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
> +        *address = le64_to_cpu(e820_table[idx].address);
> +        *length = le64_to_cpu(e820_table[idx].length);
> +        return true;
> +    }
> +    return false;
> +}
> +
> +void e820_create_fw_entry(FWCfgState *fw_cfg)
> +{
> +    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
> +                     &e820_reserve, sizeof(e820_reserve));
> +    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
> +                    sizeof(struct e820_entry) * e820_entries);
> +}
> diff --git a/hw/i386/e820.h b/hw/i386/e820.h
> new file mode 100644
> index 0000000000..569d1f0ab5
> --- /dev/null
> +++ b/hw/i386/e820.h
> @@ -0,0 +1,11 @@
> +/* e820 types */
> +#define E820_RAM        1
> +#define E820_RESERVED   2
> +#define E820_ACPI       3
> +#define E820_NVS        4
> +#define E820_UNUSABLE   5
> +
> +int e820_add_entry(uint64_t address, uint64_t length, uint32_t type);
> +int e820_get_num_entries(void);
> +bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length);
> +void e820_create_fw_entry(FWCfgState *fw_cfg);
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 10e4ced0c6..3920aa7e85 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -30,6 +30,7 @@
>  #include "hw/i386/apic.h"
>  #include "hw/i386/topology.h"
>  #include "hw/i386/fw_cfg.h"
> +#include "hw/i386/e820.h"
>  #include "sysemu/cpus.h"
>  #include "hw/block/fdc.h"
>  #include "hw/ide.h"
> @@ -99,22 +100,6 @@
>  #define DPRINTF(fmt, ...)
>  #endif
>  
> -#define E820_NR_ENTRIES		16
> -
> -struct e820_entry {
> -    uint64_t address;
> -    uint64_t length;
> -    uint32_t type;
> -} QEMU_PACKED __attribute((__aligned__(4)));
> -
> -struct e820_table {
> -    uint32_t count;
> -    struct e820_entry entry[E820_NR_ENTRIES];
> -} QEMU_PACKED __attribute((__aligned__(4)));
> -
> -static struct e820_table e820_reserve;
> -static struct e820_entry *e820_table;
> -static unsigned e820_entries;
>  struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
>  
>  GlobalProperty pc_compat_4_1[] = {};
> @@ -878,50 +863,6 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>      x86_cpu_set_a20(cpu, level);
>  }
>  
> -int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
> -{
> -    int index = le32_to_cpu(e820_reserve.count);
> -    struct e820_entry *entry;
> -
> -    if (type != E820_RAM) {
> -        /* old FW_CFG_E820_TABLE entry -- reservations only */
> -        if (index >= E820_NR_ENTRIES) {
> -            return -EBUSY;
> -        }
> -        entry = &e820_reserve.entry[index++];
> -
> -        entry->address = cpu_to_le64(address);
> -        entry->length = cpu_to_le64(length);
> -        entry->type = cpu_to_le32(type);
> -
> -        e820_reserve.count = cpu_to_le32(index);
> -    }
> -
> -    /* new "etc/e820" file -- include ram too */
> -    e820_table = g_renew(struct e820_entry, e820_table, e820_entries + 1);
> -    e820_table[e820_entries].address = cpu_to_le64(address);
> -    e820_table[e820_entries].length = cpu_to_le64(length);
> -    e820_table[e820_entries].type = cpu_to_le32(type);
> -    e820_entries++;
> -
> -    return e820_entries;
> -}
> -
> -int e820_get_num_entries(void)
> -{
> -    return e820_entries;
> -}
> -
> -bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
> -{
> -    if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
> -        *address = le64_to_cpu(e820_table[idx].address);
> -        *length = le64_to_cpu(e820_table[idx].length);
> -        return true;
> -    }
> -    return false;
> -}
> -
>  /* Calculates initial APIC ID for a specific CPU index
>   *
>   * Currently we need to be able to calculate the APIC ID from the CPU index
> @@ -1024,10 +965,7 @@ static FWCfgState *bochs_bios_init(AddressSpace *as, PCMachineState *pcms)
>                       acpi_tables, acpi_tables_len);
>      fw_cfg_add_i32(fw_cfg, FW_CFG_IRQ0_OVERRIDE, kvm_allows_irq0_override());
>  
> -    fw_cfg_add_bytes(fw_cfg, FW_CFG_E820_TABLE,
> -                     &e820_reserve, sizeof(e820_reserve));
> -    fw_cfg_add_file(fw_cfg, "etc/e820", e820_table,
> -                    sizeof(struct e820_entry) * e820_entries);
> +    e820_create_fw_entry(fw_cfg);
>  
>      fw_cfg_add_bytes(fw_cfg, FW_CFG_HPET, &hpet_cfg, sizeof(hpet_cfg));
>      /* allocate memory for the NUMA channel: one (64bit) word for the number
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 19a837889d..062feeb69e 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -291,17 +291,6 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
>  void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>                         const CPUArchIdList *apic_ids, GArray *entry);
>  
> -/* e820 types */
> -#define E820_RAM        1
> -#define E820_RESERVED   2
> -#define E820_ACPI       3
> -#define E820_NVS        4
> -#define E820_UNUSABLE   5
> -
> -int e820_add_entry(uint64_t, uint64_t, uint32_t);
> -int e820_get_num_entries(void);
> -bool e820_get_entry(int, uint32_t, uint64_t *, uint64_t *);
> -
>  extern GlobalProperty pc_compat_4_1[];
>  extern const size_t pc_compat_4_1_len;
>  
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 8023c679ea..8ce56db7d4 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -41,6 +41,7 @@
>  #include "hw/i386/apic-msidef.h"
>  #include "hw/i386/intel_iommu.h"
>  #include "hw/i386/x86-iommu.h"
> +#include "hw/i386/e820.h"
>  
>  #include "hw/pci/pci.h"
>  #include "hw/pci/msi.h"
> 
