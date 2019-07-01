Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F955C0CB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfGAQBr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 1 Jul 2019 12:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfGAQBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 12:01:47 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F218FC0568FC;
        Mon,  1 Jul 2019 16:01:41 +0000 (UTC)
Received: from ptitpuce (ovpn-116-93.ams2.redhat.com [10.36.116.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5305C1F8;
        Mon,  1 Jul 2019 16:01:27 +0000 (UTC)
References: <20190701133536.28946-1-philmd@redhat.com> <20190701133536.28946-9-philmd@redhat.com>
User-agent: mu4e 1.3.2; emacs 26.2
From:   Christophe de Dinechin <dinechin@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Yang Zhong <yang.zhong@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Rob Bradford <robert.bradford@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v3 08/15] hw/i386/pc: Let fw_cfg_init() use the generic MachineState
Message-ID: <m1d0ithhhv.fsf@redhat.com>
In-reply-to: <20190701133536.28946-9-philmd@redhat.com>
Date:   Mon, 01 Jul 2019 18:01:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 01 Jul 2019 16:01:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Philippe Mathieu-Daudé writes:

> We removed the PCMachineState access, we can now let the fw_cfg_init()
> function to take a generic MachineState object.

to take -> take

>
> Suggested-by: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/i386/pc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 1e856704e1..60ee71924a 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -929,7 +929,7 @@ static void pc_build_smbios(PCMachineState *pcms)
>      }
>  }
>
> -static FWCfgState *fw_cfg_arch_create(PCMachineState *pcms,
> +static FWCfgState *fw_cfg_arch_create(MachineState *ms,

I don't see where ms is used in the function. Maybe in a later patch,
I did not receive patches 09-15 yet.

>                                        const CPUArchIdList *cpus,
>                                        uint16_t boot_cpus,
>                                        uint16_t apic_id_limit)
> @@ -1667,6 +1667,7 @@ void pc_memory_init(PCMachineState *pcms,
>      MemoryRegion *ram_below_4g, *ram_above_4g;
>      FWCfgState *fw_cfg;
>      MachineState *machine = MACHINE(pcms);
> +    MachineClass *mc = MACHINE_GET_CLASS(machine);
>      PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
>
>      assert(machine->ram_size == pcms->below_4g_mem_size +
> @@ -1763,7 +1764,7 @@ void pc_memory_init(PCMachineState *pcms,
>                                          option_rom_mr,
>                                          1);
>
> -    fw_cfg = fw_cfg_arch_create(pcms, mc->possible_cpu_arch_ids(machine),
> +    fw_cfg = fw_cfg_arch_create(machine, mc->possible_cpu_arch_ids(machine),
>                                  pcms->boot_cpus, pcms->apic_id_limit);
>
>      rom_set_fw(fw_cfg);


--
Cheers,
Christophe de Dinechin (IRC c3d)
