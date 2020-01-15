Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A05813CFF5
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 23:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgAOWP3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Jan 2020 17:15:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728925AbgAOWP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 17:15:29 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206215] QEMU guest crash due to random 'general protection
 fault' since kernel 5.2.5 on i7-3517UE
Date:   Wed, 15 Jan 2020 22:15:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: kernel@najdan.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206215-28872-C0IslhFHTB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206215-28872@https.bugzilla.kernel.org/>
References: <bug-206215-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206215

--- Comment #2 from kernel@najdan.com ---
(In reply to Sean Christopherson from comment #1)
> Created attachment 286833 [details]
> 0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch
> 
> +cc Derek, who is hitting the same thing.
> 
> On Wed, Jan 15, 2020 at 09:18:56PM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=206215
> > 
> >             Bug ID: 206215
> >            Summary: QEMU guest crash due to random 'general protection
> >                     fault' since kernel 5.2.5 on i7-3517UE
> >            Product: Virtualization
> >            Version: unspecified
> >     Kernel Version: 5.5.0-0.rc6
> >           Hardware: x86-64
> >                 OS: Linux
> >               Tree: Fedora
> >             Status: NEW
> >           Severity: blocking
> >           Priority: P1
> >          Component: kvm
> >           Assignee: virtualization_kvm@kernel-bugs.osdl.org
> >           Reporter: kernel@najdan.com
> >         Regression: Yes
> > 
> > Created attachment 286831 [details]
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=286831&action=edit
> > relevant logs
> > 
> > Since kernel 5.2.5 any qemu guest fail to start due to "general protection
> > fault"
> > 
> > [  188.533545] traps: gsd-wacom[1855] general protection fault
> > ip:7fed39b5e7b0
> > sp:7fff3e349620 error:0 in libglib-2.0.so.0.6200.1[7fed39ae3000+83000]
> > [  192.002357] traps: gvfs-fuse-sub[1560] general protection fault
> > ip:7f9cd88100b2 sp:7f9cd5db0bf0 error:0 in
> > libglib-2.0.so.0.6200.1[7f9cd87de000+83000]
> > 
> > Please note that kernel 5.2.4 work fine.
> > 
> > Tested guests with Widows Server 2016/2019 & Fedora 31
> > 
> > Attached logs show the DMESG output of the guests
> > 
> > Attached host files contains a WARNING thrown upong first guest start on
> the
> > hypervisor:
> > 
> > [   49.533713] WARNING: CPU: 3 PID: 966 at arch/x86/kvm/x86.c:7963
> > kvm_arch_vcpu_ioctl_run+0x1927/0x1ce0 [kvm]
> 
> Between the WARN, which is
> 
>   WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
> 
> and the total diff of arch/x86/kvm for 5.2.4 -> 5.2.5 is
> 
> --- 5.2.4/arch/x86/kvm/x86.c    2020-01-15 13:37:05.154445843 -0800
> +++ 5.2.5/arch/x86/kvm/x86.c    2020-01-15 13:37:08.190438719 -0800
> @@ -3264,6 +3264,10 @@
> 
>         kvm_x86_ops->vcpu_load(vcpu, cpu);
> 
> +       fpregs_assert_state_consistent();
> +       if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +               switch_fpu_return();
> +
>         /* Apply any externally detected TSC adjustments (due to suspend) */
>         if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
>                 adjust_tsc_offset_host(vcpu,
> vcpu->arch.tsc_offset_adjustment);
> @@ -7955,9 +7959,8 @@
>                 wait_lapic_expire(vcpu);
>         guest_enter_irqoff();
> 
> -       fpregs_assert_state_consistent();
> -       if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -               switch_fpu_return();
> +       /* The preempt notifier should have taken care of the FPU already. 
> */
> +       WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
> 
>         if (unlikely(vcpu->arch.switch_db_regs)) {
>                 set_debugreg(0, 7); 
> 
> 
> that's a big smoking gun pointing at commit ca7e6b286333 ("KVM: X86: Fix
> fpu state crash in kvm guest"), which is commit e751732486eb upstream.
> 
> 1. Can you verify reverting ca7e6b286333 (or e751732486eb in upstream)
>    solves the issue?
> 
> 2. Assuming the answer is yes, on a buggy kernel, can you run with the
>    attached patch to try get debug info?
> 
> > [   49.533714] Modules linked in: vhost_net vhost tap tun xfrm4_tunnel
> > tunnel4
> > ipcomp xfrm_ipcomp esp4 ah4 af_key ebtable_filter ebtables ip6table_filter
> > ip6_tables bridge stp llc nf_log_ipv4 nf_log_common xt_LOG ipt_REJECT
> > nf_reject_ipv4 iptable_filter iptable_security iptable_raw xt_state
> > xt_conntrack xt_DSCP xt_multiport iptable_mangle xt_TCPMSS xt_tcpmss
> > xt_policy
> > xt_nat iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> > intel_rapl
> > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel sunrpc kvm vfat
> fat
> > mei_hdcp mei_wdt snd_hda_codec_hdmi iTCO_wdt irqbypass iTCO_vendor_support
> > snd_hda_codec_realtek snd_hda_codec_generic crct10dif_pclmul crc32_pclmul
> > ledtrig_audio snd_hda_intel ghash_clmulni_intel snd_hda_codec intel_cstate
> > intel_uncore snd_hda_core snd_hwdep intel_rapl_perf snd_seq snd_seq_device
> > snd_pcm i2c_i801 r8169 lpc_ich mei_me snd_timer snd mei e1000e soundcore
> > pcc_cpufreq tcp_bbr sch_fq ip_tables xfs i915 libcrc32c i2c_algo_bit
> > drm_kms_helper crc32c_intel drm
> > [   49.533760]  serio_raw video
> > [   49.533764] CPU: 3 PID: 966 Comm: CPU 0/KVM Not tainted
> > 5.2.5-200.fc30.x86_64 #1
> > [   49.533765] Hardware name: CompuLab 0000000-00000/Intense-PC, BIOS
> > IPC_2.2.400.5 X64 03/15/2018
> > [   49.533784] RIP: 0010:kvm_arch_vcpu_ioctl_run+0x1927/0x1ce0 [kvm]
> > [   49.533786] Code: 4c 89 e7 e8 1b 0b ff ff 4c 89 e7 e8 d3 8c fe ff 41 83
> a4
> > 24 e8 36 00 00 fb e9 bd ed ff ff f0 41 80 4c 24 31 10 e9 a5 ee ff ff <0f>
> 0b
> > e9
> > 74 ed ff ff 49 8b 84 24 c8 02 00 00 a9 00 00 01 00 0f 84
> > [   49.533787] RSP: 0018:ffffbe4e423ffd30 EFLAGS: 00010002
> > [   49.533789] RAX: 0000000000004b00 RBX: 0000000000000000 RCX:
> > ffffa044ce958000
> > [   49.533790] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> > 0000000000000000
> > [   49.533791] RBP: ffffbe4e423ffdd8 R08: 0000000000000000 R09:
> > 00000000000003e8
> > [   49.533792] R10: 0000000000000000 R11: 0000000000000000 R12:
> > ffffa044d38f8000
> > [   49.533792] R13: 0000000000000000 R14: ffffbe4e41ccf7b8 R15:
> > 0000000000000000
> > [   49.533794] FS:  00007f117953f700(0000) GS:ffffa044ee2c0000(0000)
> > knlGS:0000000000000000
> > [   49.533795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   49.533796] CR2: 0000000000000000 CR3: 000000040e8c2003 CR4:
> > 00000000001626e0
> > [   49.533797] Call Trace:
> > [   49.533817]  kvm_vcpu_ioctl+0x215/0x5c0 [kvm]
> > [   49.533821]  ? __seccomp_filter+0x7b/0x640
> > [   49.533824]  ? __switch_to_asm+0x34/0x70
> > [   49.533826]  ? __switch_to_asm+0x34/0x70
> > [   49.533827]  ? apic_timer_interrupt+0xa/0x20
> > [   49.533831]  do_vfs_ioctl+0x405/0x660
> > [   49.533834]  ksys_ioctl+0x5e/0x90
> > [   49.533836]  __x64_sys_ioctl+0x16/0x20
> > [   49.533839]  do_syscall_64+0x5f/0x1a0
> > [   49.533842]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [   49.533844] RIP: 0033:0x7f117d1fb34b
> > [   49.533845] Code: 0f 1e fa 48 8b 05 3d 9b 0c 00 64 c7 00 26 00 00 00 48
> c7
> > c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48>
> 3d
> > 01
> > f0 ff ff 73 01 c3 48 8b 0d 0d 9b 0c 00 f7 d8 64 89 01 48
> > [   49.533846] RSP: 002b:00007f117953e698 EFLAGS: 00000246 ORIG_RAX:
> > 0000000000000010
> > [   49.533848] RAX: ffffffffffffffda RBX: 0000564f2cb65ba0 RCX:
> > 00007f117d1fb34b
> > [   49.533849] RDX: 0000000000000000 RSI: 000000000000ae80 RDI:
> > 0000000000000019
> > [   49.533850] RBP: 00007f1179f20000 R08: 0000564f2b7e5390 R09:
> > 000000000000ffff
> > [   49.533851] R10: 0000564f2ca7a710 R11: 0000000000000246 R12:
> > 0000000000000001
> > [   49.533852] R13: 00007f1179f21002 R14: 0000000000000000 R15:
> > 0000564f2bc66e80
> > [   49.533854] ---[ end trace a562473b18c9b742 ]---
> > 
> > /proc/cpuinfo
> > 
> > processor       : 0
> > vendor_id       : GenuineIntel
> > cpu family      : 6
> > model           : 58
> > model name      : Intel(R) Core(TM) i7-3517UE CPU @ 1.70GHz
> > stepping        : 9
> > microcode       : 0x1f
> > cpu MHz         : 828.296
> > cache size      : 4096 KB
> > physical id     : 0
> > siblings        : 4
> > core id         : 0
> > cpu cores       : 2
> > apicid          : 0
> > initial apicid  : 0
> > fpu             : yes
> > fpu_exception   : yes
> > cpuid level     : 13
> > wp              : yes
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> > cmov
> > pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp
> > lm
> > constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc
> cpuid
> > aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16
> > xtpr
> > pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c
> > rdrand lahf_lm cpuid_fault epb pti ibrs ibpb stibp tpr_shadow vnmi
> > flexpriority
> > ept vpid fsgsbase smep erms xsaveopt dtherm ida arat pln pts
> > bugs            : cpu_meltdown spectre_v1 spectre_v2 spec_store_bypass l1tf
> > mds
> > bogomips        : 4389.89
> > clflush size    : 64
> > cache_alignment : 64
> > address sizes   : 36 bits physical, 48 bits virtual
> > power management:
> > 
> > -- 
> > You are receiving this mail because:
> > You are watching the assignee of the bug.

Sean,
Thank you for the quick feedback.
In the zip file I did attach DMESG logs with latest vanilla kernel with same
behavior:
5.5.0-0.rc6.git1.1.vanilla.knurd.1.fc31.x86_64

If I'm rebuilding the kernel I'd rather spend time on the most recent one ?

Can you confirm if I apply the patch on kernel 5.5.0-rc6 ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
