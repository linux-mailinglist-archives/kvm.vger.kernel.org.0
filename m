Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67BA69E9A6
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 22:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBUVlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 16:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBUVlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 16:41:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E82FCCC;
        Tue, 21 Feb 2023 13:41:34 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677015693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2fzZWgj3EgPur0gBH+Eh3AUzBsWUv3V8wkByGQcQZQo=;
        b=V64+K99vkA8eopGHFkYFH3YcKvPLeVZGt3S8Mr+dqi7IeSNEBmkueT1xDVjae9oID4l1nZ
        vMhPwVDwb3XTiYZYqSDfpBWOioB7X0PNMSIN3aEAxIh737LqpKTclVYFOcQW/BnlFHC70I
        ZyIStxoDDt7aA160jIuH9a0p0iWOU+gZUDWxnJW5bHgsc5dobHQtN2Opo4YleW5edvk0D9
        O9DRj4icFj8gpyCFTt8zz+hKDuuqecCJxb6O7AdLWr6+dJ1NxnWmXkAkRZO0RLbEZhM+FH
        5+Jw0zv/4ggMpMpx6FVg3DoE7Ih3ZtMF0ILccmr1UbmyqUFIYx4rXWut8L/7Tg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677015693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2fzZWgj3EgPur0gBH+Eh3AUzBsWUv3V8wkByGQcQZQo=;
        b=jqUZGiR+kD1/71tIkOkW4UWt2pRAnJv517JDzotCmipTM/SnWMHds7nTFmaby08zFiYg0X
        hEsCwswkOubJHAAA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
 <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
 <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
Date:   Tue, 21 Feb 2023 22:41:32 +0100
Message-ID: <87356yofw3.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David!

On Tue, Feb 21 2023 at 19:10, David Woodhouse wrote:
> On Tue, 2023-02-21 at 13:14 +0100, Oleksandr Natalenko wrote:
> (Usama, I think my tree is fairly out of date now so I'll let you do
> that? Thanks!).
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 50621793671d..3db77a257ae2 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1571,6 +1571,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  
>  void arch_thaw_secondary_cpus_begin(void)
>  {
> +	/*
> +	 * On suspend, smpboot_control will have been zeroed to allow the
> +	 * boot CPU to use explicitly passed values including a temporary
> +	 * stack. Since native_smp_prepare_cpus() won't be called again,
> +	 * restore the appropriate value for the parallel startup modes.
> +	 */
> +	if (do_parallel_bringup) {
> +		smpboot_control = STARTUP_SECONDARY |
> +			(x2apic_mode ? STARTUP_APICID_CPUID_0B : STARTUP_APICID_CPUID_01);
> +	}

My bad taste sensor reports: "Out of effective range"

Why on earth can't you fix the wreckage exactly where it happens,
i.e. in x86_acpi_suspend_lowlevel() ?

--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 #include <asm/hypervisor.h>
+#include <asm/smp.h>
 
 #include <linux/ftrace.h>
 #include "../../realmode/rm/wakeup.h"
@@ -57,6 +58,7 @@ asmlinkage acpi_status __visible x86_acp
  */
 int x86_acpi_suspend_lowlevel(void)
 {
+	unsigned int __maybe_unused saved_smpboot_ctrl;
 	struct wakeup_header *header =
 		(struct wakeup_header *) __va(real_mode_header->wakeup_header);
 
@@ -115,7 +117,8 @@ int x86_acpi_suspend_lowlevel(void)
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
-	smpboot_control = 0;
+	/* Force the startup into boot mode */
+	saved_smpboot_ctrl = xchg(&smpboot_control, 0);
 #endif
 	initial_code = (unsigned long)wakeup_long64;
        saved_magic = 0x123456789abcdef0L;
@@ -128,6 +131,9 @@ int x86_acpi_suspend_lowlevel(void)
 	pause_graph_tracing();
 	do_suspend_lowlevel();
 	unpause_graph_tracing();
+
+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_SMP))
+		smpboot_control = saved_smpboot_ctrl;
 	return 0;
 }
 

That's too bloody obvious, too self explaining, not enough duplicated
code and does not need any fixups when the smpboot_control bits are
changed later, right?

Thanks,

        tglx
