Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCFF480281
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 17:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhL0Q5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 11:57:52 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:39869 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229644AbhL0Q5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 11:57:51 -0500
Received: from [192.168.0.2] (ip5f5aea86.dynamic.kabel-deutschland.de [95.90.234.134])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 42C6E61EA1922;
        Mon, 27 Dec 2021 17:57:49 +0100 (CET)
Message-ID: <9a47b5ec-f2d1-94d9-3a48-9b326c88cfcb@molgen.mpg.de>
Date:   Mon, 27 Dec 2021 17:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
References: <20211215145633.5238-1-dwmw2@infradead.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211215145633.5238-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear David,


Am 15.12.21 um 15:56 schrieb David Woodhouse:
> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting for
> them shaves about 80% off the AP bringup time on a 96-thread socket
> Skylake box (EC2 c5.metal) — from about 500ms to 100ms.
> 
> There are more wins to be had with further parallelisation, but this is
> the simple part.
> 
> v2: Cut it back to just INIT/SIPI/SIPI in parallel for now, nothing more
> v3: Clean up x2apic patch, add MTRR optimisation, lock topology update
>      in preparation for more parallelisation.
> 
> 
> David Woodhouse (8):
>        x86/apic/x2apic: Fix parallel handling of cluster_mask
>        cpu/hotplug: Move idle_thread_get() to <linux/smpboot.h>
>        cpu/hotplug: Add dynamic parallel bringup states before CPUHP_BRINGUP_CPU
>        x86/smpboot: Reference count on smpboot_setup_warm_reset_vector()
>        x86/smpboot: Split up native_cpu_up into separate phases and document them
>        x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
>        x86/mtrr: Avoid repeated save of MTRRs on boot-time CPU bringup
>        x86/smpboot: Serialize topology updates for secondary bringup
> 
> Thomas Gleixner (1):
>        x86/smpboot: Support parallel startup of secondary CPUs
> 
>   arch/x86/include/asm/realmode.h       |   3 +
>   arch/x86/include/asm/smp.h            |  13 +-
>   arch/x86/include/asm/topology.h       |   2 -
>   arch/x86/kernel/acpi/sleep.c          |   1 +
>   arch/x86/kernel/apic/apic.c           |   2 +-
>   arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++++-----
>   arch/x86/kernel/cpu/common.c          |   6 +-
>   arch/x86/kernel/cpu/mtrr/mtrr.c       |   9 +
>   arch/x86/kernel/head_64.S             |  71 ++++++++
>   arch/x86/kernel/smpboot.c             | 324 ++++++++++++++++++++++++----------
>   arch/x86/realmode/init.c              |   3 +
>   arch/x86/realmode/rm/trampoline_64.S  |  14 ++
>   arch/x86/xen/smp_pv.c                 |   4 +-
>   include/linux/cpuhotplug.h            |   2 +
>   include/linux/smpboot.h               |   7 +
>   kernel/cpu.c                          |  27 ++-
>   kernel/smpboot.c                      |   2 +-
>   kernel/smpboot.h                      |   2 -
>   18 files changed, 441 insertions(+), 159 deletions(-)

Thank you for working on this. I tested this on a MSI MS-7A37/B350M 
MORTAR (BIOS 1.MW 11/01/2021) with a Ryzen 3 2200G, but nothing was 
printed to the screen after the GRUB loading messages, so it crashed or 
hung somewhere. Unfortunately, this device is used by others, and no 
serial console is connected and I do not know how to capture the Linux 
log with other means.


Kind regards,

Paul
