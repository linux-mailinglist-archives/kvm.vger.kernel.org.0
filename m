Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44066BF169
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCQTEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 15:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCQTEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 15:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8523E1DC;
        Fri, 17 Mar 2023 12:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88F80612F1;
        Fri, 17 Mar 2023 19:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D8FC433EF;
        Fri, 17 Mar 2023 19:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679079874;
        bh=GmqH690M2GEmxatzGsLC2sSS8wjP1Fth4N2kHK24yv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmtxWztDYGmuWkCj6I1Z5SYJiSx/TQJmB1b77eUn0JejECmu9UJy6BuvdPfEQ3yPK
         FOsTFyZ5YfxzniF+SpvXjo50xWYfvsRixtGOpNeb8xkbBcYQEvnOlnSaUH1gGvN7Mr
         pYFERV6BXS9X2g8DlVg4g0ZjB5dHSC5aolsfm+asOze23kAgR9TaH/92FeQXJJIp49
         QFHmDwuszlyCYAP2Gm4c6J22e7/cIJa7I8f71SypsoNQvBFF43/2ZWkqgKGYqzOLws
         8NYEdIRpvAzJIMC0waraTYOl5Lm2RaljHYtZjRMPYkRavt+h/5mimCXny4pC6FSR4x
         qcGPeitk4G7LA==
Date:   Fri, 17 Mar 2023 12:04:32 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
Message-ID: <20230317190432.GA863767@dev-arch.thelio-3990X>
References: <20230201132905.549148-1-eesposit@redhat.com>
 <20230201132905.549148-2-eesposit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201132905.549148-2-eesposit@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Emanuele,

On Wed, Feb 01, 2023 at 08:29:03AM -0500, Emanuele Giuseppe Esposito wrote:
> Expose IA32_FLUSH_CMD to the guest if the guest CPUID enumerates
> support for this MSR. As with IA32_PRED_CMD, permission for
> unintercepted writes to this MSR will be granted to the guest after
> the first non-zero write.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c |  3 ++
>  arch/x86/kvm/vmx/vmx.c    | 70 +++++++++++++++++++++++++--------------
>  2 files changed, 48 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 557b9c468734..075b5ade7c80 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -654,6 +654,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
>  
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> +					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> +
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>  
>  	vmx->nested.force_msr_bitmap_recalc = false;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..9a78ea96a6d7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2133,6 +2133,39 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>  	return debugctl;
>  }
>  
> +static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
> +				struct msr_data *msr_info,
> +				bool guest_has_feat, u64 cmd,
> +				int x86_feature_bit)
> +{
> +	if (!msr_info->host_initiated && !guest_has_feat)
> +		return 1;
> +
> +	if (!(msr_info->data & ~cmd))
> +		return 1;
> +	if (!boot_cpu_has(x86_feature_bit))
> +		return 1;
> +	if (!msr_info->data)
> +		return 0;
> +
> +	wrmsrl(msr_info->index, cmd);
> +
> +	/*
> +	 * For non-nested:
> +	 * When it's written (to non-zero) for the first time, pass
> +	 * it through.
> +	 *
> +	 * For nested:
> +	 * The handling of the MSR bitmap for L2 guests is done in
> +	 * nested_vmx_prepare_msr_bitmap. We should not touch the
> +	 * vmcs02.msr_bitmap here since it gets completely overwritten
> +	 * in the merging.
> +	 */
> +	vmx_disable_intercept_for_msr(vcpu, msr_info->index, MSR_TYPE_W);
> +
> +	return 0;
> +}
> +
>  /*
>   * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
> @@ -2288,31 +2321,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		goto find_uret_msr;
>  	case MSR_IA32_PRED_CMD:
> -		if (!msr_info->host_initiated &&
> -		    !guest_has_pred_cmd_msr(vcpu))
> -			return 1;
> -
> -		if (data & ~PRED_CMD_IBPB)
> -			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_IBPB))
> -			return 1;
> -		if (!data)
> -			break;
> -
> -		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
> -
> -		/*
> -		 * For non-nested:
> -		 * When it's written (to non-zero) for the first time, pass
> -		 * it through.
> -		 *
> -		 * For nested:
> -		 * The handling of the MSR bitmap for L2 guests is done in
> -		 * nested_vmx_prepare_msr_bitmap. We should not touch the
> -		 * vmcs02.msr_bitmap here since it gets completely overwritten
> -		 * in the merging.
> -		 */
> -		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
> +		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
> +					   guest_has_pred_cmd_msr(vcpu),
> +					   PRED_CMD_IBPB,
> +					   X86_FEATURE_IBPB);
> +		break;
> +	case MSR_IA32_FLUSH_CMD:
> +		bool guest_flush_l1d = guest_cpuid_has(vcpu,
> +						       X86_FEATURE_FLUSH_L1D);
> +		ret = vmx_set_msr_ia32_cmd(vcpu, msr_info,
> +					   guest_flush_l1d,
> +					   L1D_FLUSH,
> +					   X86_FEATURE_FLUSH_L1D);
>  		break;
>  	case MSR_IA32_CR_PAT:
>  		if (!kvm_pat_valid(data))
> -- 
> 2.39.1
> 

This patch as commit a807b78ad04b ("kvm: vmx: Add IA32_FLUSH_CMD guest
support") in -next causes a crash in a L1 guest on two Intel test machines
that I have. The kernel of the L1 guest is a stock Arch Linux kernel at
6.2.6, which is basically vanilla.

$ qemu-system-x86_64 \
-display none \
-nodefaults \
-d unimp,guest_errors \
-append 'console=ttyS0 earlycon=uart8250,io,0x3f8' \
-kernel bzImage \
-initrd rootfs.cpio \
-cpu host \
-enable-kvm \
-m 512m \
-smp 8 \
-serial mon:stdio
[    0.150256] general protection fault, maybe for address 0x1: 0000 [#1] PREEMPT SMP NOPTI
[    0.150787] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.6-arch1-1 #1 bdb4a56fad97b891ecbccb5d194884721c85b4d2
[    0.151356] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.2-1-1 04/01/2014
[    0.151814] RIP: 0010:switch_mm_irqs_off+0x410/0x460
[    0.152062] Code: 00 00 00 00 83 c0 01 48 83 c1 10 66 83 f8 06 75 de 65 c6 05 65 ac f9 56 00 e9 e0 fc ff ff b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e9 73 fc ff ff 0f 0b e9 c6 fc ff ff 65 48 c7 05 26 ac f9 56
[    0.152952] RSP: 0018:ffffffffaae03de8 EFLAGS: 00010046
[    0.153198] RAX: 0000000000000001 RBX: ffff8bbcc107d0c0 RCX: 0000000000000049
[    0.153607] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8bbcc106d580
[    0.154064] RBP: ffffffffaaf02460 R08: 0000000000000000 R09: 0000000000000000
[    0.154520] R10: 0000000000000001 R11: 0000000000000100 R12: ffff8bbcc1fca740
[    0.154976] R13: 0000000000000000 R14: ffff8bbcc107d0c0 R15: 0000000000000000
[    0.155423] FS:  0000000000000000(0000) GS:ffff8bbcdf000000(0000) knlGS:0000000000000000
[    0.155934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.156300] CR2: 000056104aef0f50 CR3: 0000000019010001 CR4: 0000000000770ef0
[    0.156760] PKRU: 55555554
[    0.156937] Call Trace:
[    0.157097]  <TASK>
[    0.157234]  __schedule+0x37e/0x12e0
[    0.157466]  ? _raw_spin_unlock_irqrestore+0xe/0x40
[    0.157780]  ? tick_nohz_restart_sched_tick+0x87/0xa0
[    0.158104]  schedule_idle+0x2a/0x40
[    0.158339]  cpu_startup_entry+0x1d/0x20
[    0.158588]  rest_init+0xc8/0xd0
[    0.158796]  arch_call_rest_init+0xe/0x30
[    0.159055]  start_kernel+0x734/0xb30
[    0.159296]  secondary_startup_64_no_verify+0xe5/0xeb
[    0.159624]  </TASK>
[    0.159772] Modules linked in:
[    0.159971] ---[ end trace 0000000000000000 ]---
[    0.160267] RIP: 0010:switch_mm_irqs_off+0x410/0x460
[    0.160590] Code: 00 00 00 00 83 c0 01 48 83 c1 10 66 83 f8 06 75 de 65 c6 05 65 ac f9 56 00 e9 e0 fc ff ff b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e9 73 fc ff ff 0f 0b e9 c6 fc ff ff 65 48 c7 05 26 ac f9 56
[    0.161756] RSP: 0018:ffffffffaae03de8 EFLAGS: 00010046
[    0.162092] RAX: 0000000000000001 RBX: ffff8bbcc107d0c0 RCX: 0000000000000049
[    0.162541] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8bbcc106d580
[    0.162988] RBP: ffffffffaaf02460 R08: 0000000000000000 R09: 0000000000000000
[    0.163448] R10: 0000000000000001 R11: 0000000000000100 R12: ffff8bbcc1fca740
[    0.163902] R13: 0000000000000000 R14: ffff8bbcc107d0c0 R15: 0000000000000000
[    0.164349] FS:  0000000000000000(0000) GS:ffff8bbcdf000000(0000) knlGS:0000000000000000
[    0.164868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.165238] CR2: 000056104aef0f50 CR3: 0000000019010001 CR4: 0000000000770ef0
[    0.165695] PKRU: 55555554
[    0.165887] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.166406] Kernel Offset: 0x28000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    0.167088] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Here is the output of lscpu from the machine that I did the bisect
against, if that is helpful:

$ lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Address sizes:                   39 bits physical, 48 bits virtual
Byte Order:                      Little Endian
CPU(s):                          16
On-line CPU(s) list:             0-15
Vendor ID:                       GenuineIntel
Model name:                      11th Gen Intel(R) Core(TM) i7-11700 @ 2.50GHz
CPU family:                      6
Model:                           167
Thread(s) per core:              2
Core(s) per socket:              8
Socket(s):                       1
Stepping:                        1
CPU(s) scaling MHz:              32%
CPU max MHz:                     4900.0000
CPU min MHz:                     800.0000
BogoMIPS:                        4993.00
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic
sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht
tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs
bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf tsc_known_freq
pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16
xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes
xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb
invpcid_single ssbd ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi
flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2
erms invpcid mpx avx512f avx512dq rdseed adx smap avx512ifma clflushopt
intel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1
xsaves dtherm ida arat pln pts hwp hwp_notify hwp_act_window hwp_epp
hwp_pkg_req avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq
avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid fsrm md_clear flush_l1d
arch_capabilities
Virtualization:                  VT-x
L1d cache:                       384 KiB (8 instances)
L1i cache:                       256 KiB (8 instances)
L2 cache:                        4 MiB (8 instances)
L3 cache:                        16 MiB (1 instance)
NUMA node(s):                    1
NUMA node0 CPU(s):               0-15
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Mmio stale data:   Mitigation; Clear CPU buffers; SMT vulnerable
Vulnerability Retbleed:          Mitigation; Enhanced IBRS
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Enhanced / Automatic IBRS, IBPB conditional, RSB filling, PBRSB-eIBRS SW sequence
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected

If there is something I am doing wrong or any additional information or
testing I can provide, please let me know.

Cheers,
Nathan

# bad: [6f08c1de13a9403341c18b66638a05588b2663ce] Add linux-next specific files for 20230317
# good: [0ddc84d2dd43e2c2c3f634baa05ea10abd31197e] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect start '6f08c1de13a9403341c18b66638a05588b2663ce' '0ddc84d2dd43e2c2c3f634baa05ea10abd31197e'
# good: [f779d371bee4488a1ec2bda3f6acd32f80c71641] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git
git bisect good f779d371bee4488a1ec2bda3f6acd32f80c71641
# good: [3350cda1809a93651aa3ee85e7fc67d1ccfe7582] Merge branch 'for-mfd-next' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git
git bisect good 3350cda1809a93651aa3ee85e7fc67d1ccfe7582
# bad: [78d98a424a4982f7aa2c6915999070f4101d894b] Merge branch 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
git bisect bad 78d98a424a4982f7aa2c6915999070f4101d894b
# good: [3b3f1d6008e3c19366f3fc1457831a4e9eec3322] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git bisect good 3b3f1d6008e3c19366f3fc1457831a4e9eec3322
# good: [54d3e47985932fa31fa128f6d4d239e56d6e9032] Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
git bisect good 54d3e47985932fa31fa128f6d4d239e56d6e9032
# good: [02c464b73645404654359ad21f368a13735e2850] platform/x86: x86-android-tablets: Add depends on PMIC_OPREGION
git bisect good 02c464b73645404654359ad21f368a13735e2850
# bad: [64c21f80ff6d88d1872150dc3e54d5b2c973e518] Merge branch 'for-leds-next' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/leds.git
git bisect bad 64c21f80ff6d88d1872150dc3e54d5b2c973e518
# bad: [297673fcc1a9e8ee9efed8efe6d4d2b53eeeaf97] Merge branch 'next' of git://git.kernel.org/pub/scm/virt/kvm/kvm.git
git bisect bad 297673fcc1a9e8ee9efed8efe6d4d2b53eeeaf97
# bad: [723d5fb0ffe4c02bd4edf47ea02c02e454719f28] kvm: svm: Add IA32_FLUSH_CMD guest support
git bisect bad 723d5fb0ffe4c02bd4edf47ea02c02e454719f28
# good: [68ac4221497b9a54f32c452a774ae747da908a81] KVM: nVMX: Move EVMCS1_SUPPORT_* macros to hyperv.c
git bisect good 68ac4221497b9a54f32c452a774ae747da908a81
# good: [fbc722aac1ce66960de50c0f488b6ff865a41d74] KVM: VMX: Rename "KVM is using eVMCS" static key to match its wrapper
git bisect good fbc722aac1ce66960de50c0f488b6ff865a41d74
# bad: [a807b78ad04b2eaa348f52f5cc7702385b6de1ee] kvm: vmx: Add IA32_FLUSH_CMD guest support
git bisect bad a807b78ad04b2eaa348f52f5cc7702385b6de1ee
# first bad commit: [a807b78ad04b2eaa348f52f5cc7702385b6de1ee] kvm: vmx: Add IA32_FLUSH_CMD guest support
