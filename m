Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB02AC7B7
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 22:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgKIVzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 16:55:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731509AbgKIVzP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 16:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604958913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JzdO2G+arlSt6R0bcNuR7A1MaYq1ALuOCryQWcCm8k8=;
        b=OJGSYp9J/JE3EwEm+/BElT/qoAYUNzTgRVMhB4nCnrd8UuWikB4faShYFbDgzCIjpqhnOC
        /ZFeO67D3Y1vXGnCscIbhfM+1Lvha7iqx610QhudPAla5x6AFOouZZf0hPezAp/GFIKWn1
        EkmFC7fvcPrx38WS79+qq6S0SAi9wQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-KwxTtFLqNnKu434UTiOgRg-1; Mon, 09 Nov 2020 16:55:09 -0500
X-MC-Unique: KwxTtFLqNnKu434UTiOgRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E92D8030BC;
        Mon,  9 Nov 2020 21:55:08 +0000 (UTC)
Received: from ovpn-66-145.rdu2.redhat.com (unknown [10.10.67.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D856960E1C;
        Mon,  9 Nov 2020 21:55:04 +0000 (UTC)
Message-ID: <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
Subject: Re: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
From:   Qian Cai <cai@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Cc:     Boris Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        x86 <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Date:   Mon, 09 Nov 2020 16:55:04 -0500
In-Reply-To: <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
         <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-11-02 at 11:18 +0000, tip-bot2 for Tony Luck wrote:
> The following commit has been merged into the ras/core branch of tip:
> 
> Commit-ID:     68299a42f84288537ee3420c431ac0115ccb90b1
> Gitweb:        
> https://git.kernel.org/tip/68299a42f84288537ee3420c431ac0115ccb90b1
> Author:        Tony Luck <tony.luck@intel.com>
> AuthorDate:    Fri, 30 Oct 2020 12:04:00 -07:00
> Committer:     Borislav Petkov <bp@suse.de>
> CommitterDate: Mon, 02 Nov 2020 11:15:59 +01:00
> 
> x86/mce: Enable additional error logging on certain Intel CPUs
> 
> The Xeon versions of Sandy Bridge, Ivy Bridge and Haswell support an
> optional additional error logging mode which is enabled by an MSR.
> 
> Previously, this mode was enabled from the mcelog(8) tool via /dev/cpu,
> but userspace should not be poking at MSRs. So move the enabling into
> the kernel.
> 
>  [ bp: Correct the explanation why this is done. ]
> 
> Suggested-by: Boris Petkov <bp@alien8.de>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>

Booting a simple KVM guest using today's linux-next is now generating those
errors below inside the guest due to this patch. Are those expected?

# qemu-kvm -name kata -cpu host -smp 48 -m 48g -hda rhel-8.3-x86_64-kvm.img.qcow2 -cdrom kata.iso -nic user,hostfwd=tcp::2222-:22 -nographic

guest .config (if ever matters): https://cailca.coding.net/public/linux/mm/git/files/master/x86.config

[    6.801741][    T0] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x1e3bca858ab, max_idle_ns: 440795282452 ns
[    6.804371][    T0] Calibrating delay loop (skipped), value calculated using timer frequency.. 4194.90 BogoMIPS (lpj=20974530)
[    6.806956][    T0] pid_max: default: 49152 minimum: 384
[    6.814328][    T0] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    6.814328][    T0] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    6.814328][    T0] x86/cpu: User Mode Instruction Prevention (UMIP) activated
[    6.814328][    T0] unchecked MSR access error: RDMSR from 0x17f at rIP: 0xffffffff84483f16 (mce_intel_feature_init+0x156/0x270)
[    6.814328][    T0] Call Trace:
[    6.814328][    T0]  __mcheck_cpu_init_vendor+0x105/0x250
__rdmsr at arch/x86/include/asm/msr.h:93
(inlined by) native_read_msr at arch/x86/include/asm/msr.h:127
(inlined by) intel_imc_init at arch/x86/kernel/cpu/mce/intel.c:524
(inlined by) mce_intel_feature_init at arch/x86/kernel/cpu/mce/intel.c:537
[    6.814328][    T0]  mcheck_cpu_init+0x21f/0xb00
[    6.814328][    T0]  identify_cpu+0xfcb/0x1980
[    6.814328][    T0]  identify_boot_cpu+0xd/0xb5
[    6.814328][    T0]  check_bugs+0x6c/0x1606
[    6.814328][    T0]  ? _raw_spin_unlock+0x1a/0x30
[    6.814328][    T0]  ? poking_init+0x2b5/0x2ea
[    6.814328][    T0]  ? l1tf_cmdline+0x11a/0x11a
[    6.814328][    T0]  ? lockdep_init_map_waits+0x267/0x6f0
[    6.814328][    T0]  start_kernel+0x372/0x39f
[    6.814328][    T0]  secondary_startup_64_no_verify+0xc2/0xcb
[    6.814328][    T0] unchecked MSR access error: WRMSR to 0x17f (tried to write 0x0000000000000002) at rIP: 0xffffffff84483f3a (mce_intel_feature_init+0x17a/0x270)
[    6.814328][    T0] Call Trace:
[    6.814328][    T0]  __mcheck_cpu_init_vendor+0x105/0x250
[    6.814328][    T0]  mcheck_cpu_init+0x21f/0xb00
[    6.814328][    T0]  identify_cpu+0xfcb/0x1980
[    6.814328][    T0]  identify_boot_cpu+0xd/0xb5
[    6.814328][    T0]  check_bugs+0x6c/0x1606
[    6.814328][    T0]  ? _raw_spin_unlock+0x1a/0x30
[    6.814328][    T0]  ? poking_init+0x2b5/0x2ea
[    6.814328][    T0]  ? l1tf_cmdline+0x11a/0x11a
[    6.814328][    T0]  ? lockdep_init_map_waits+0x267/0x6f0
[    6.814328][    T0]  start_kernel+0x372/0x39f
[    6.814328][    T0]  secondary_startup_64_no_verify+0xc2/0xcb
[    6.814328][    T0] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    6.814328][    T0] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0

== host CPU ==
# lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              48
On-line CPU(s) list: 0-47
Thread(s) per core:  1
Core(s) per socket:  12
Socket(s):           4
NUMA node(s):        4
Vendor ID:           GenuineIntel
CPU family:          6
Model:               63
Model name:          Intel(R) Xeon(R) CPU E5-4650 v3 @ 2.10GHz
Stepping:            2
CPU MHz:             1980.076
BogoMIPS:            4195.25
Virtualization:      VT-x
L1d cache:           32K
L1i cache:           32K
L2 cache:            256K
L3 cache:            30720K
NUMA node0 CPU(s):   0-5,24-29
NUMA node1 CPU(s):   6-11,30-35
NUMA node2 CPU(s):   12-17,36-41
NUMA node3 CPU(s):   18-23,42-47
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2
ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm cpuid_fault epb
invpcid_single pti intel_ppin ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority
ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm
xsaveopt cqm_llc cqm_occup_llc dtherm arat pln pts md_clear flush_l1d

> Link: https://lkml.kernel.org/r/20201030190807.GA13884@agluck-desk2.amr.corp.intel.com
> ---
>  arch/x86/include/asm/msr-index.h |  1 +
>  arch/x86/kernel/cpu/mce/intel.c  | 20 ++++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-
> index.h
> index 972a34d..b2dd264 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -139,6 +139,7 @@
>  #define MSR_IA32_MCG_CAP		0x00000179
>  #define MSR_IA32_MCG_STATUS		0x0000017a
>  #define MSR_IA32_MCG_CTL		0x0000017b
> +#define MSR_ERROR_CONTROL		0x0000017f
>  #define MSR_IA32_MCG_EXT_CTL		0x000004d0
>  
>  #define MSR_OFFCORE_RSP_0		0x000001a6
> diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
> index abe9fe0..b47883e 100644
> --- a/arch/x86/kernel/cpu/mce/intel.c
> +++ b/arch/x86/kernel/cpu/mce/intel.c
> @@ -509,12 +509,32 @@ static void intel_ppin_init(struct cpuinfo_x86 *c)
>  	}
>  }
>  
> +/*
> + * Enable additional error logs from the integrated
> + * memory controller on processors that support this.
> + */
> +static void intel_imc_init(struct cpuinfo_x86 *c)
> +{
> +	u64 error_control;
> +
> +	switch (c->x86_model) {
> +	case INTEL_FAM6_SANDYBRIDGE_X:
> +	case INTEL_FAM6_IVYBRIDGE_X:
> +	case INTEL_FAM6_HASWELL_X:
> +		rdmsrl(MSR_ERROR_CONTROL, error_control);
> +		error_control |= 2;
> +		wrmsrl(MSR_ERROR_CONTROL, error_control);
> +		break;
> +	}
> +}
> +
>  void mce_intel_feature_init(struct cpuinfo_x86 *c)
>  {
>  	intel_init_thermal(c);
>  	intel_init_cmci();
>  	intel_init_lmce();
>  	intel_ppin_init(c);
> +	intel_imc_init(c);
>  }
>  
>  void mce_intel_feature_clear(struct cpuinfo_x86 *c)

