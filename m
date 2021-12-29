Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50E4481371
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 14:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhL2NSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 08:18:33 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50435 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232575AbhL2NSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 08:18:32 -0500
Received: from [192.168.0.2] (ip5f5aecf5.dynamic.kabel-deutschland.de [95.90.236.245])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D5DFC61EA192E;
        Wed, 29 Dec 2021 14:18:29 +0100 (CET)
Message-ID: <ea433e41-0038-554d-3348-70aa98aff9e1@molgen.mpg.de>
Date:   Wed, 29 Dec 2021 14:18:29 +0100
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
 <9a47b5ec-f2d1-94d9-3a48-9b326c88cfcb@molgen.mpg.de>
 <ab28d2ce-4a9c-387d-9eda-558045a0c35b@molgen.mpg.de>
 <3bfacf45d2d0f3dfa3789ff5a2dcb46744aacff7.camel@infradead.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <3bfacf45d2d0f3dfa3789ff5a2dcb46744aacff7.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear David,


Am 28.12.21 um 15:18 schrieb David Woodhouse:
> On Tue, 2021-12-28 at 12:34 +0100, Paul Menzel wrote:
>> Same on the ASUS F2A85-M PRO with AMD A6-6400K. Without serial console,
>> the messages below are printed below to the monitor after nine seconds.
>>
>>        [    1.078879] smp: Bringing up secondary CPUs ...
>>        [    1.080950] x86: Booting SMP configuration:
>>
>> Please find the serial log attached.
> 
> Thanks for testing. That looks like the same triple-fault on bringup
> that we have been seeing, and that I reproduced without my patches
> using kexec all the way back to a 5.0 kernel.
> 
> Out of interest, are you also able to reproduce it with kexec and
> without the parallel bringup?

No, I am not able to reproduce that with Debian’s 
*linux-image-5.15.0-2-686*, and kexec. With this board, 
`module_blacklist=radeon` is needed, as the driver *radeon* is not able 
to deal with kexec – and amdgpu neither [1].

```
[    3.349911] [drm] Found VCE firmware/feedback version 50.0.1 / 17!
[    3.365259] clocksource: Switched to clocksource tsc
[    3.365284] [drm] GART: num cpu pages 262144, num gpu pages 262144
[    3.405159] random: fast init done
[    3.420492] [drm] PCIE GART of 1024M enabled (table at 
0x00000000001D6000).
[    3.427634] radeon 0000:00:01.0: WB enabled
[    3.431828] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 
0x0000000020000c00
[    3.440100] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 
0x0000000000075a18
[    3.458182] radeon 0000:00:01.0: failed VCE resume (-22).
[    3.463591] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 
0x0000000020000c04
[    3.471615] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 
0x0000000020000c08
[    3.479636] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 
0x0000000020000c0c
[    3.487650] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 
0x0000000020000c10
[    3.495990] radeon 0000:00:01.0: radeon: MSI limited to 32-bit
[    3.502008] radeon 0000:00:01.0: radeon: using MSI.
[    3.506906] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.506918] [drm] radeon: irq initialized.
[
```

> And with that patch I sent Tom in
> https://lore.kernel.org/lkml/721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org/
>   to expand the bitlock exclusion and stop the bringup being truly in
> parallel at all?

No, this does not help, and the Linux kernel resets at the same spot.

```
[    1.036036] smpboot: smpboot: After 
x86_init.timers.setup_percpu_clockev()
[    1.037031] smpboot: smp_get_logical_apicid()
[    1.038031] smpboot: CPU0: AMD A6-6400K APU with Radeon(tm) HD 
Graphics (family: 0x15, model: 0x13, stepping: 0x1)
[    1.039366] Performance Events: Fam15h core perfctr, AMD PMU driver.
[    1.040033] ... version:                0
[    1.041031] ... bit width:              48
[    1.042031] ... generic registers:      6
[    1.043033] ... value mask:             0000ffffffffffff
[    1.044031] ... max period:             00007fffffffffff
[    1.045031] ... fixed-purpose events:   0
[    1.046031] ... event mask:             000000000000003f
[    1.048065] rcu: Hierarchical SRCU implementation.
[    1.050642] NMI watchdog: Enabled. Permanently consumes one hw-PMU 
counter.
[    1.051133] smp: Bringing up secondary CPUs ...
[    1.053202] x86: Booting SMP configuration:
```

> Or the one in
> https://lore.kernel.org/lkml/d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org
> which makes it do nothing except prepare all the CPUs before bringing
> them up one at a time?

I applied it on top the other one, and it made no difference either.

> My current theory (not that I've spent that much time thinking about it
> in the last week) is that there's something about the existing CPU
> bringup, possibly a CPU bug or something special about the AMD CPUs,
> which is triggered by just making it a little bit *faster*, which is
> why bringing them up from kexec (especially in qemu) can cause it too?

Would having the serial console enabled make a difference?

> Tom seemed to find that it was in load_TR_desc(), so if you could try
> this hack on a machine that doesn't magically wink out of existence on
> a triplefault before even flushing its serial output, that would be
> much appreciated...
> 
> diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> index ab97b22ac04a..cc6590712ff4 100644
> --- a/arch/x86/include/asm/desc.h
> +++ b/arch/x86/include/asm/desc.h
> @@ -8,7 +8,7 @@
>   #include <asm/fixmap.h>
>   #include <asm/irq_vectors.h>
>   #include <asm/cpu_entry_area.h>
> -
> +#include <asm/io.h>
>   #include <linux/debug_locks.h>
>   #include <linux/smp.h>
>   #include <linux/percpu.h>
> @@ -265,11 +265,16 @@ static inline void native_load_tr_desc(void)
>   	 * If the current GDT is the read-only fixmap, swap to the original
>   	 * writeable version. Swap back at the end.
>   	 */
> +	outb('d', 0x3f8);
>   	if (gdt.address == (unsigned long)fixmap_gdt) {
> +	outb('e', 0x3f8);
>   		load_direct_gdt(cpu);
>   		restore = 1;
> +	outb('f', 0x3f8);
>   	}
> +	outb('g', 0x3f8);
>   	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
> +	outb('h', 0x3f8);
>   	if (restore)
>   		load_fixmap_gdt(cpu);
>   }
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 0083464de5e3..5bc8f30c3283 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1716,7 +1716,9 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
>   	enable_sep_cpu();
>   #endif
>   	mtrr_ap_init();
> +outb('A', 0x3f8);
>   	validate_apic_and_package_id(c);
> +outb('B', 0x3f8);
>   	x86_spec_ctrl_setup_ap();
>   	update_srbds_msr();
>   }
> @@ -1957,6 +1959,7 @@ static inline void tss_setup_io_bitmap(struct tss_struct *tss)
>   	tss->io_bitmap.mapall[IO_BITMAP_LONGS] = ~0UL;
>   #endif
>   }
> +#include <asm/realmode.h>
>   
>   /*
>    * Setup everything needed to handle exceptions from the IDT, including the IST
> @@ -1969,16 +1972,24 @@ void cpu_init_exception_handling(void)
>   
>   	/* paranoid_entry() gets the CPU number from the GDT */
>   	setup_getcpu(cpu);
> -
> +	outb('\n', 0x3f8);
> +	outb('0' + cpu / 100, 0x3f8);
> +	outb('0' + (cpu % 100) / 10, 0x3f8);
> +	outb('0' + (cpu % 10), 0x3f8);
> +	
>   	/* IST vectors need TSS to be set up. */
>   	tss_setup_ist(tss);
> +	outb('a', 0x3f8);
>   	tss_setup_io_bitmap(tss);
>   	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
> -
> +	outb('b', 0x3f8);
>   	load_TR_desc();
> +	outb('c', 0x3f8);
>   
>   	/* Finally load the IDT */
>   	load_current_idt();
> +	outb('z', 0x3f8);
> +
>   }
>   
>   /*

Unfortunately, no more messages were printed on the serial console.


Kind regards,

Paul


[1]: https://gitlab.freedesktop.org/drm/amd/-/issues/1597
