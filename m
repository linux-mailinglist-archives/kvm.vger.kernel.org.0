Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9763F69E9AD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 22:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjBUVpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 16:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBUVpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 16:45:07 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31B52BF2D;
        Tue, 21 Feb 2023 13:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=YX7b9pxGjZV+pRvwa81ewJRB8vQS4t6gaLrhO0eRYEM=; b=rX25aiw3Y7E6Q0ODQngeJeHnRT
        R5oUiMHwmFJLAEilSVipAi1/TZvfAEJ2JmzGCUoeEQfqCiDVkCfRSI71lZyDUKnqboZBIvG4eb1Tw
        Xb4UUf+Ga6czRq62Gg0cOsFYdwSooYfIzJ40INSDvQdgxl8R5elF4/Ro9igGe8vDFmrsmPECSr63o
        KB7pQEXqSl4RQlUpdgBJaAqznTTT0NIfDy3vhijrq+RKtdKb4F57kxmtGPHi3mOMj7cRNX/wpHVGz
        432c4MHZEKGaIZ6P2KC3mr9GNmXLr4UfPyDLkP/iIgc6jfGMJNPkr0PdyuYvbayOE8pyJAUbs8Eiv
        QPwR4B2A==;
Received: from [2a00:23ee:13a8:1fc1:d4c9:6fd6:506e:1b04] (helo=[IPv6:::1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pUaR1-00CwSm-Aa; Tue, 21 Feb 2023 21:44:28 +0000
Date:   Tue, 21 Feb 2023 21:44:21 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     Kim Phillips <kim.phillips@amd.com>,
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
User-Agent: K-9 Mail for Android
In-Reply-To: <87356yofw3.ffs@tglx>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <67dbc69f-b712-8971-f1c9-5d07f506a19c@amd.com> <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org> <37c18c3aeea2e558633b6da6886111d0@natalenko.name> <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org> <3d8ed6e157df10c5175c636de0e21849@natalenko.name> <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org> <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name> <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org> <ce731b5a4a53680b4840467977b33d9a@natalenko.name> <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org> <3e5944de08ef0d23584d19bad7bae66c@natalenko.name> <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org> <f71275dc809cfb32df513023786c3faa@natalenko.name> <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org> <9153284c37a79d303aa79dbf07c10329@natalenko.name> <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org> <87356yofw3.ffs@tglx>
Message-ID: <EB397FEA-D36D-41C0-809A-A58450DF5967@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21 February 2023 21:41:32 GMT, Thomas Gleixner <tglx@linutronix=2Ede> w=
rote:
>David!
>
>On Tue, Feb 21 2023 at 19:10, David Woodhouse wrote:
>> On Tue, 2023-02-21 at 13:14 +0100, Oleksandr Natalenko wrote:
>> (Usama, I think my tree is fairly out of date now so I'll let you do
>> that? Thanks!)=2E
>>
>> diff --git a/arch/x86/kernel/smpboot=2Ec b/arch/x86/kernel/smpboot=2Ec
>> index 50621793671d=2E=2E3db77a257ae2 100644
>> --- a/arch/x86/kernel/smpboot=2Ec
>> +++ b/arch/x86/kernel/smpboot=2Ec
>> @@ -1571,6 +1571,17 @@ void __init native_smp_prepare_cpus(unsigned int=
 max_cpus)
>> =20
>>  void arch_thaw_secondary_cpus_begin(void)
>>  {
>> +	/*
>> +	 * On suspend, smpboot_control will have been zeroed to allow the
>> +	 * boot CPU to use explicitly passed values including a temporary
>> +	 * stack=2E Since native_smp_prepare_cpus() won't be called again,
>> +	 * restore the appropriate value for the parallel startup modes=2E
>> +	 */
>> +	if (do_parallel_bringup) {
>> +		smpboot_control =3D STARTUP_SECONDARY |
>> +			(x2apic_mode ? STARTUP_APICID_CPUID_0B : STARTUP_APICID_CPUID_01);
>> +	}
>
>My bad taste sensor reports: "Out of effective range"
>
>Why on earth can't you fix the wreckage exactly where it happens,
>i=2Ee=2E in x86_acpi_suspend_lowlevel() ?

Er, that was my first instinct but for some reason I concluded that I coul=
dn't put it back there, and it has to be done later because this was just a=
 function called on the way down to suspend=2E Wrongly, it seems=2E :)

>--- a/arch/x86/kernel/acpi/sleep=2Ec
>+++ b/arch/x86/kernel/acpi/sleep=2Ec
>@@ -16,6 +16,7 @@
> #include <asm/cacheflush=2Eh>
> #include <asm/realmode=2Eh>
> #include <asm/hypervisor=2Eh>
>+#include <asm/smp=2Eh>
>=20
> #include <linux/ftrace=2Eh>
> #include "=2E=2E/=2E=2E/realmode/rm/wakeup=2Eh"
>@@ -57,6 +58,7 @@ asmlinkage acpi_status __visible x86_acp
>  */
> int x86_acpi_suspend_lowlevel(void)
> {
>+	unsigned int __maybe_unused saved_smpboot_ctrl;
> 	struct wakeup_header *header =3D
> 		(struct wakeup_header *) __va(real_mode_header->wakeup_header);
>=20
>@@ -115,7 +117,8 @@ int x86_acpi_suspend_lowlevel(void)
> 	early_gdt_descr=2Eaddress =3D
> 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
> 	initial_gs =3D per_cpu_offset(smp_processor_id());
>-	smpboot_control =3D 0;
>+	/* Force the startup into boot mode */
>+	saved_smpboot_ctrl =3D xchg(&smpboot_control, 0);
> #endif
> 	initial_code =3D (unsigned long)wakeup_long64;
>        saved_magic =3D 0x123456789abcdef0L;
>@@ -128,6 +131,9 @@ int x86_acpi_suspend_lowlevel(void)
> 	pause_graph_tracing();
> 	do_suspend_lowlevel();
> 	unpause_graph_tracing();
>+
>+	if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_SMP))
>+		smpboot_control =3D saved_smpboot_ctrl;
> 	return 0;
> }
>=20
>
>That's too bloody obvious, too self explaining, not enough duplicated
>code and does not need any fixups when the smpboot_control bits are
>changed later, right?
>
>Thanks,
>
>        tglx
