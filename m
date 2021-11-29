Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FAE46241E
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbhK2WQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhK2WQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:16:34 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337E7C08EB30
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:44:29 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id z8so8889583ilu.7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 13:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=+tZPlWE+NyonFzg7vXNGZxsfebD/3TcNdF5jtKl/7TM=;
        b=GMx6kwu0XRAMrNy1+wL6ld9HXQ+WydJtcUaL+Gch9k2nidS9gqurQsq6Jyrm3TlUQI
         a+V0RcFfbk4G+GpEEFhxOzhqIRXUoP6WHu75IVdM4APkdBGQEFaGGM5/km6Pb/GZKVTf
         oKqH2Bdhbmdu+aYJFKB+aeCI5Z5v5IeM1bt9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=+tZPlWE+NyonFzg7vXNGZxsfebD/3TcNdF5jtKl/7TM=;
        b=SsZoh8ZUHWJ5mUZJDn8V5oRriUKx+LrG77RORoNkW+3TIY3lwGJs/YeE4ney6FeEAt
         i92Bpb60mtKIvnDlSbTxi/Gc8AffOM97/TyRZZtSzu5C1SMfpYnC8+tLZo5rdZVCeZpQ
         X0bCXAYcpZ+ZQjeXZy/It4NUH1sqP1hRcH1e8sfE6krWPONiYz6KmJqxn81x2WDdQoWL
         95K9w7oa2WmK5/lbQIIoecYCqXy38PeIs99QmrwGIzNTY6gQo0MYTM65Hv4oZYmME84i
         FfLWHeVr13MabvVoTeOmfuwZ4awFlFKumibf00+7roIF+no0+idtZfqmADYtuY9lXjfu
         l2ow==
X-Gm-Message-State: AOAM531RyYTKnoo18VJuHDpIRc1XzPeToPiZGm3r9TNbBXL/Po6uyKeQ
        3WgKUQyxZqyfejHKQ/uHJoe/TdAj+mbA2JgeobZIBQAXes8K0w==
X-Google-Smtp-Source: ABdhPJzBev26iOXxV2yLF2dVIORAmviqI0eYPkYWyIhh+B7nPk2fMg5aGiqhIpWoWFoEGPg2TVC3FL9HDcr9x8yLzlA=
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr56374333ild.309.1638222268352;
 Mon, 29 Nov 2021 13:44:28 -0800 (PST)
MIME-Version: 1.0
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 29 Nov 2021 21:44:17 +0000
Message-ID: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
Subject: Potential bug in TDP MMU
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     stevensd@chromium.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

We have recently started to evaluate 5.15.y kernel series and here is
what we occasionally get on kernel 5.15.5:

[177243.621744][T1995658] WARNING: CPU: 7 PID: 1995658 at
arch/x86/kvm/../../../virt/kvm/kvm_main.c:171
kvm_is_zone_device_pfn.part.0+0x9e/0xd0 [kvm]
[177243.647435][T1995658] Modules linked in: xt_hashlimit xt_connlimit
nf_conncount ip_set_hash_netport xt_length esp4 sit ipip tunnel4
nft_numgen nft_ct ip_gre gre xfrm_user xfrm_algo tcp_diag udp_diag
inet_diag fou6 fou ip6_tunnel tunnel6 ip_tunnel ip6_udp_tunnel
udp_tunnel cls_bpf tls xt_NFLOG xt_statistic nft_compat veth tun
overlay macvlan sch_ingress raid0 md_mod essiv dm_crypt trusted
asn1_encoder tee dm_mod dax nfnetlink_log nft_log nft_limit
nft_counter nf_tables ip6table_nat ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables xt_nat iptable_nat nf_nat
xt_TCPMSS xt_u32 xt_connmark iptable_mangle xt_owner xt_CT iptable_raw
xt_state xt_bpf xt_mark xt_conntrack xt_multiport xt_comment xt_tcpudp
xt_set xt_tcpmss iptable_filter ip_set_hash_net ip_set_hash_ip ip_set
nfnetlink sch_fq tcp_bbr nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
8021q garp stp mrp llc skx_edac x86_pkg_temp_thermal kvm_intel kvm
irqbypass crc32_pclmul crc32c_intel aesni_intel rapl
[177243.647594][T1995658]  intel_cstate ipmi_ssif sfc intel_uncore
i2c_i801 xhci_pci i2c_smbus acpi_ipmi i40e mdio ioatdma i2c_core
xhci_hcd tpm_crb dca ipmi_si ipmi_devintf ipmi_msghandler tpm_tis
tpm_tis_core tpm tiny_power_button button fuse efivarfs ip_tables
x_tables bcmcrypt(O) crypto_simd cryptd [last unloaded: kheaders]
[177243.831600][T1995658] CPU: 7 PID: 1995658 Comm: exe Tainted: G
      O      5.15.5-cloudflare-kasan-2021.11.11 #1
[177243.831609][T1995658] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U/T42S-2U MB (Lewisburg-4), BIOS 3B16.Q102 02/19/2020
[177243.831612][T1995658] RIP:
0010:kvm_is_zone_device_pfn.part.0+0x9e/0xd0 [kvm]
[177243.886990][T1995658] Code: 00 00 00 00 fc ff df 48 c1 ea 03 0f b6
14 02 48 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 0f 8b 43 34 85
c0 74 03 5b 5d c3 <0f> 0b 5b 5d c3 48 89 ef e8 c5 68 72 e1 eb e7 e8 ce
68 72 e1 eb 9b
[177243.919270][T1995658] RSP: 0018:ffff8881ec51f300 EFLAGS: 00010246
[177243.919276][T1995658] RAX: 0000000000000000 RBX: ffffea003d52e900
RCX: ffffffffc143242e
[177243.919279][T1995658] RDX: 0000000000000000 RSI: 0000000000000004
RDI: ffffea003d52e934
[177243.960080][T1995658] RBP: ffffea003d52e934 R08: 0000000000000000
R09: ffffea003d52e937
[177243.960083][T1995658] R10: fffff94007aa5d26 R11: 0000000000000000
R12: ffff88b03ffd9008
[177243.960085][T1995658] R13: 0600000f54ba4b77 R14: 0000000000000001
R15: 0600000f54ba4b01
[177243.960088][T1995658] FS:  0000000000000000(0000)
GS:ffff8897a9b80000(0000) knlGS:0000000000000000
[177244.017687][T1995658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[177244.017691][T1995658] CR2: 000000c001503000 CR3: 0000001a1fb38006
CR4: 00000000007726e0
[177244.017693][T1995658] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[177244.058771][T1995658] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[177244.058774][T1995658] PKRU: 00000000
[177244.058776][T1995658] Call Trace:
[177244.058780][T1995658]  <TASK>
[177244.058782][T1995658]  kvm_set_pfn_dirty+0x120/0x1d0 [kvm]
[177244.111155][T1995658]  __handle_changed_spte+0x92e/0xca0 [kvm]
[177244.111274][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177244.133938][T1995658]  ? sched_clock_cpu+0x15/0x190
[177244.144289][T1995658]  ? _raw_spin_lock+0xc8/0xd0
[177244.144299][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177244.165796][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177244.165906][T1995658]  ? kvm_vcpu_release+0x4d/0x70 [kvm]
[177244.187769][T1995658]  ? deref_stack_reg+0xe6/0x160
[177244.187779][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177244.209044][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177244.220140][T1995658]  ? update_curr+0x18d/0x5f0
[177244.220148][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177244.240784][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177244.251827][T1995658]  zap_gfn_range+0x549/0x620 [kvm]
[177244.251922][T1995658]  ? zap_collapsible_spte_range+0x520/0x520 [kvm]
[177244.273410][T1995658]  ? smp_call_function_single+0x271/0x370
[177244.283892][T1995658]  ? _raw_spin_lock+0x81/0xd0
[177244.283900][T1995658]  ? _raw_spin_lock_bh+0xe0/0xe0
[177244.283904][T1995658]  ? vmx_vcpu_pi_load+0x14c/0x3b0 [kvm_intel]
[177244.313033][T1995658]  kvm_tdp_mmu_put_root+0x1b6/0x270 [kvm]
[177244.323097][T1995658]  mmu_free_root_page+0x219/0x2c0 [kvm]
[177244.332862][T1995658]  ? ept_invlpg+0x780/0x780 [kvm]
[177244.341982][T1995658]  ? _raw_spin_lock+0xd0/0xd0
[177244.350556][T1995658]  ? handle_pause+0x250/0x250 [kvm_intel]
[177244.360080][T1995658]  kvm_mmu_free_roots+0x1b4/0x4e0 [kvm]
[177244.369396][T1995658]  ? mmu_free_root_page+0x2c0/0x2c0 [kvm]
[177244.378777][T1995658]  ?
kvm_clear_async_pf_completion_queue+0x2f/0x510 [kvm]
[177244.389571][T1995658]  kvm_mmu_unload+0x1c/0xa0 [kvm]
[177244.398156][T1995658]  kvm_arch_destroy_vm+0x1f2/0x5c0 [kvm]
[177244.398238][T1995658]  ? mmu_notifier_unregister+0x26f/0x330
[177244.416160][T1995658]  kvm_put_kvm+0x3b1/0x8b0 [kvm]
[177244.424372][T1995658]  kvm_vcpu_release+0x4e/0x70 [kvm]
[177244.432743][T1995658]  __fput+0x1f7/0x8c0
[177244.432749][T1995658]  task_work_run+0xf8/0x1a0
[177244.447257][T1995658]  do_exit+0x97b/0x2230
[177244.447263][T1995658]  ? _raw_write_lock_irqsave+0xe0/0xe0
[177244.462773][T1995658]  ? mm_update_next_owner+0x750/0x750
[177244.471117][T1995658]  ? _raw_spin_lock_irq+0x82/0xd0
[177244.471122][T1995658]  do_group_exit+0xda/0x2a0
[177244.471126][T1995658]  get_signal+0x3be/0x1e50
[177244.471133][T1995658]  arch_do_signal_or_restart+0x244/0x17f0
[177244.502424][T1995658]  ? audit_log_exit+0x2690/0x2690
[177244.502432][T1995658]  ? shmem_evict_inode+0xad0/0xad0
[177244.518403][T1995658]  ? get_sigframe_size+0x10/0x10
[177244.526157][T1995658]  ? __seccomp_filter+0x117/0xd60
[177244.526162][T1995658]  ? audit_alloc_name+0x440/0x440
[177244.526166][T1995658]  ? get_nth_filter.part.0+0x220/0x220
[177244.526170][T1995658]  ? __audit_syscall_exit+0x794/0xa80
[177244.558471][T1995658]  exit_to_user_mode_prepare+0xcb/0x120
[177244.558478][T1995658]  syscall_exit_to_user_mode+0x1d/0x40
[177244.575193][T1995658]  do_syscall_64+0x4d/0x90
[177244.575197][T1995658]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[177244.591189][T1995658] RIP: 0033:0x4890ca
[177244.591199][T1995658] Code: Unable to access opcode bytes at RIP 0x4890a0.
[177244.591201][T1995658] RSP: 002b:000000c000508608 EFLAGS: 00000216
ORIG_RAX: 000000000000011d
[177244.607705][T1995658] RAX: 0000000000000000 RBX: 000000c00003e000
RCX: 00000000004890ca
[177244.630001][T1995658] RDX: 0000000036466000 RSI: 0000000000000003
RDI: 0000000000000010
[177244.630003][T1995658] RBP: 000000c000508660 R08: 0000000000000000
R09: 0000000000000000
[177244.630005][T1995658] R10: 000000000676b000 R11: 0000000000000216
R12: 0000000000000009
[177244.630007][T1995658] R13: 000000c00129d8b8 R14: 0000000000000001
R15: 0000000000000000
[177244.630011][T1995658]  </TASK>
[177244.679411][T1995658] ---[ end trace bf693a2532f213e4 ]---

Then immediately this KASAN warning:

[177244.798046][T1995658] BUG: KASAN: slab-out-of-bounds in
workingset_activation+0x2b2/0x2f0
[177244.809161][T1995658] Read of size 8 at addr ffff8881749ab3b8 by
task exe/1995658
[177244.819636][T1995658]
[177244.824947][T1995658] CPU: 7 PID: 1995658 Comm: exe Tainted: G
   W  O      5.15.5-cloudflare-kasan-2021.11.11 #1
[177244.838672][T1995658] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U/T42S-2U MB (Lewisburg-4), BIOS 3B16.Q102 02/19/2020
[177244.857210][T1995658] Call Trace:
[177244.863733][T1995658]  <TASK>
[177244.869871][T1995658]  dump_stack_lvl+0x34/0x44
[177244.877583][T1995658]  print_address_description.constprop.0+0x1f/0x140
[177244.887430][T1995658]  ? workingset_activation+0x2b2/0x2f0
[177244.896156][T1995658]  ? workingset_activation+0x2b2/0x2f0
[177244.904809][T1995658]  kasan_report.cold+0x83/0xdf
[177244.912778][T1995658]  ? kvm_is_zone_device_pfn.part.0+0x40/0xd0 [kvm]
[177244.922553][T1995658]  ? workingset_activation+0x2b2/0x2f0
[177244.931236][T1995658]  workingset_activation+0x2b2/0x2f0
[177244.939785][T1995658]  mark_page_accessed+0x44a/0x6a0
[177244.948022][T1995658]  __handle_changed_spte+0x64c/0xca0 [kvm]
[177244.957192][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177244.966249][T1995658]  ? kvm_vcpu_release+0x4d/0x70 [kvm]
[177244.974930][T1995658]  ? deref_stack_reg+0xe6/0x160
[177244.983013][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177244.992167][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177245.001249][T1995658]  ? update_curr+0x18d/0x5f0
[177245.009268][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177245.018454][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177245.027556][T1995658]  zap_gfn_range+0x549/0x620 [kvm]
[177245.036055][T1995658]  ? zap_collapsible_spte_range+0x520/0x520 [kvm]
[177245.045907][T1995658]  ? smp_call_function_single+0x271/0x370
[177245.054992][T1995658]  ? _raw_spin_lock+0x81/0xd0
[177245.063045][T1995658]  ? _raw_spin_lock_bh+0xe0/0xe0
[177245.071332][T1995658]  ? vmx_vcpu_pi_load+0x14c/0x3b0 [kvm_intel]
[177245.080861][T1995658]  kvm_tdp_mmu_put_root+0x1b6/0x270 [kvm]
[177245.090147][T1995658]  mmu_free_root_page+0x219/0x2c0 [kvm]
[177245.099215][T1995658]  ? ept_invlpg+0x780/0x780 [kvm]
[177245.107719][T1995658]  ? _raw_spin_lock+0xd0/0xd0
[177245.115776][T1995658]  ? handle_pause+0x250/0x250 [kvm_intel]
[177245.124919][T1995658]  kvm_mmu_free_roots+0x1b4/0x4e0 [kvm]
[177245.133974][T1995658]  ? mmu_free_root_page+0x2c0/0x2c0 [kvm]
[177245.143143][T1995658]  ?
kvm_clear_async_pf_completion_queue+0x2f/0x510 [kvm]
[177245.153754][T1995658]  kvm_mmu_unload+0x1c/0xa0 [kvm]
[177245.162289][T1995658]  kvm_arch_destroy_vm+0x1f2/0x5c0 [kvm]
[177245.171426][T1995658]  ? mmu_notifier_unregister+0x26f/0x330
[177245.180637][T1995658]  kvm_put_kvm+0x3b1/0x8b0 [kvm]
[177245.189087][T1995658]  kvm_vcpu_release+0x4e/0x70 [kvm]
[177245.197744][T1995658]  __fput+0x1f7/0x8c0
[177245.205096][T1995658]  task_work_run+0xf8/0x1a0
[177245.212916][T1995658]  do_exit+0x97b/0x2230
[177245.220332][T1995658]  ? _raw_write_lock_irqsave+0xe0/0xe0
[177245.229016][T1995658]  ? mm_update_next_owner+0x750/0x750
[177245.237583][T1995658]  ? _raw_spin_lock_irq+0x82/0xd0
[177245.245731][T1995658]  do_group_exit+0xda/0x2a0
[177245.253265][T1995658]  get_signal+0x3be/0x1e50
[177245.260585][T1995658]  arch_do_signal_or_restart+0x244/0x17f0
[177245.269239][T1995658]  ? audit_log_exit+0x2690/0x2690
[177245.277218][T1995658]  ? shmem_evict_inode+0xad0/0xad0
[177245.285295][T1995658]  ? get_sigframe_size+0x10/0x10
[177245.293162][T1995658]  ? __seccomp_filter+0x117/0xd60
[177245.301157][T1995658]  ? audit_alloc_name+0x440/0x440
[177245.309224][T1995658]  ? get_nth_filter.part.0+0x220/0x220
[177245.317678][T1995658]  ? __audit_syscall_exit+0x794/0xa80
[177245.325968][T1995658]  exit_to_user_mode_prepare+0xcb/0x120
[177245.334463][T1995658]  syscall_exit_to_user_mode+0x1d/0x40
[177245.342837][T1995658]  do_syscall_64+0x4d/0x90
[177245.350176][T1995658]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[177245.358991][T1995658] RIP: 0033:0x4890ca
[177245.365778][T1995658] Code: Unable to access opcode bytes at RIP 0x4890a0.
[177245.375596][T1995658] RSP: 002b:000000c000508608 EFLAGS: 00000216
ORIG_RAX: 000000000000011d
[177245.387085][T1995658] RAX: 0000000000000000 RBX: 000000c00003e000
RCX: 00000000004890ca
[177245.387092][T1995658] RDX: 0000000036466000 RSI: 0000000000000003
RDI: 0000000000000010
[177245.387096][T1995658] RBP: 000000c000508660 R08: 0000000000000000
R09: 0000000000000000
[177245.387100][T1995658] R10: 000000000676b000 R11: 0000000000000216
R12: 0000000000000009
[177245.387103][T1995658] R13: 000000c00129d8b8 R14: 0000000000000001
R15: 0000000000000000
[177245.441910][T1995658]  </TASK>
[177245.447826][T1995658]
[177245.447827][T1995658] Allocated by task 182586:
[177245.447830][T1995658]  kasan_save_stack+0x20/0x50
[177245.467811][T1995658]  __kasan_kmalloc+0xa4/0xd0
[177245.475233][T1995658]  fib6_info_alloc+0xa2/0x1d0
[177245.475240][T1995658]  ip6_route_info_create+0x29f/0x1a30
[177245.475243][T1995658]  ip6_route_add+0x18/0x100
[177245.475246][T1995658]  addrconf_add_mroute+0x157/0x1b0
[177245.506016][T1995658]  addrconf_notify+0x6a3/0x1510
[177245.506021][T1995658]  notifier_call_chain+0x9e/0x180
[177245.521427][T1995658]  __dev_notify_flags+0xda/0x230
[177245.529175][T1995658]  rtnl_configure_link+0x125/0x200
[177245.529181][T1995658]  __rtnl_newlink+0xd3d/0x13f0
[177245.529186][T1995658]  rtnl_newlink+0x5f/0x90
[177245.551464][T1995658]  rtnetlink_rcv_msg+0x378/0xa40
[177245.551469][T1995658]  netlink_rcv_skb+0x125/0x380
[177245.551472][T1995658]  netlink_unicast+0x4d0/0x7a0
[177245.573756][T1995658]  netlink_sendmsg+0x724/0xc00
[177245.573760][T1995658]  sock_sendmsg+0xe2/0x110
[177245.573764][T1995658]  __sys_sendto+0x1a8/0x270
[177245.595271][T1995658]  __x64_sys_sendto+0xdd/0x1b0
[177245.602600][T1995658]  do_syscall_64+0x40/0x90
[177245.609544][T1995658]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[177245.609549][T1995658]
[177245.609550][T1995658] The buggy address belongs to the object at
ffff8881749ab200
[177245.609550][T1995658]  which belongs to the cache kmalloc-256 of size 256
[177245.609554][T1995658] The buggy address is located 184 bytes to the right of
[177245.609554][T1995658]  256-byte region [ffff8881749ab200, ffff8881749ab300)
[177245.609558][T1995658] The buggy address belongs to the page:
[177245.609559][T1995658] page:000000009030f8e1 refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x1749a8
[177245.682919][T1995658] head:000000009030f8e1 order:2
compound_mapcount:0 compound_pincount:0
[177245.682924][T1995658] flags:
0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
[177245.705180][T1995658] raw: 002ffff800010200 dead000000000100
dead000000000122 ffff88810004cb40
[177245.716738][T1995658] raw: 0000000000000000 0000000000200020
00000001ffffffff 0000000000000000
[177245.716741][T1995658] page dumped because: kasan: bad access detected
[177245.716743][T1995658]
[177245.716744][T1995658] Memory state around the buggy address:
[177245.716747][T1995658]  ffff8881749ab280: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
[177245.716749][T1995658]  ffff8881749ab300: fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc fc
[177245.716752][T1995658] >ffff8881749ab380: fc fc fc fc fc fc fc fc
fc fc fc fc fc fc fc fc
[177245.785224][T1995658]                                         ^
[177245.785229][T1995658]  ffff8881749ab400: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00
[177245.785231][T1995658]  ffff8881749ab480: 00 00 00 00 00 00 00 00
00 00 00 00 00 00 fc fc
[177245.816146][T1995658]
==================================================================

And after that:

[177245.816196][T1995658] general protection fault, probably for
non-canonical address 0xdffffc0000000011: 0000 [#1] SMP KASAN PTI
[177245.854054][T1995658] KASAN: null-ptr-deref in range
[0x0000000000000088-0x000000000000008f]
[177245.865836][T1995658] CPU: 7 PID: 1995658 Comm: exe Tainted: G
B   W  O      5.15.5-cloudflare-kasan-2021.11.11 #1
[177245.865842][T1995658] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U/T42S-2U MB (Lewisburg-4), BIOS 3B16.Q102 02/19/2020
[177245.865845][T1995658] RIP: 0010:workingset_activation+0x175/0x2f0
[177245.909096][T1995658] Code: 80 3c 02 00 0f 85 58 01 00 00 4a 8b ac
ed b8 0f 00 00 48 8d bd 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 48
89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 0d 01 00 00 4c 3b a5 88 00 00 00
0f 85 c3 00 00
[177245.936452][T1995658] RSP: 0018:ffff8881ec51f3c0 EFLAGS: 00010206
[177245.936457][T1995658] RAX: dffffc0000000000 RBX: ffffea003237e480
RCX: ffffffffa25388a6
[177245.936460][T1995658] RDX: 0000000000000011 RSI: 0000000000000246
RDI: 0000000000000088
[177245.970834][T1995658] RBP: 0000000000000000 R08: 0000000000000001
R09: ffffffffa6ced907
[177245.970837][T1995658] R10: fffffbfff4d9db20 R11: 0000000000000010
R12: ffff88983ffde000
[177245.970839][T1995658] R13: 0000000000000000 R14: ffff8897a9bbbde0
R15: 0600000c8df93b77
[177246.007059][T1995658] FS:  0000000000000000(0000)
GS:ffff8897a9b80000(0000) knlGS:0000000000000000
[177246.020326][T1995658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[177246.020330][T1995658] CR2: 000000c001503000 CR3: 0000001a1fb38006
CR4: 00000000007726e0
[177246.020332][T1995658] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[177246.020334][T1995658] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[177246.020337][T1995658] PKRU: 00000000
[177246.020338][T1995658] Call Trace:
[177246.020341][T1995658]  <TASK>
[177246.090639][T1995658]  mark_page_accessed+0x44a/0x6a0
[177246.099947][T1995658]  __handle_changed_spte+0x64c/0xca0 [kvm]
[177246.110177][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177246.110274][T1995658]  ? kvm_vcpu_release+0x4d/0x70 [kvm]
[177246.129880][T1995658]  ? deref_stack_reg+0xe6/0x160
[177246.138925][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177246.139020][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177246.158926][T1995658]  ? update_curr+0x18d/0x5f0
[177246.167666][T1995658]  __handle_changed_spte+0x63c/0xca0 [kvm]
[177246.167762][T1995658]  ? alloc_tdp_mmu_page+0x370/0x370 [kvm]
[177246.187453][T1995658]  zap_gfn_range+0x549/0x620 [kvm]
[177246.196673][T1995658]  ? zap_collapsible_spte_range+0x520/0x520 [kvm]
[177246.196781][T1995658]  ? smp_call_function_single+0x271/0x370
[177246.196789][T1995658]  ? _raw_spin_lock+0x81/0xd0
[177246.196795][T1995658]  ? _raw_spin_lock_bh+0xe0/0xe0
[177246.234516][T1995658]  ? vmx_vcpu_pi_load+0x14c/0x3b0 [kvm_intel]
[177246.244565][T1995658]  kvm_tdp_mmu_put_root+0x1b6/0x270 [kvm]
[177246.244680][T1995658]  mmu_free_root_page+0x219/0x2c0 [kvm]
[177246.263832][T1995658]  ? ept_invlpg+0x780/0x780 [kvm]
[177246.263923][T1995658]  ? _raw_spin_lock+0xd0/0xd0
[177246.281421][T1995658]  ? handle_pause+0x250/0x250 [kvm_intel]
[177246.291062][T1995658]  kvm_mmu_free_roots+0x1b4/0x4e0 [kvm]
[177246.291156][T1995658]  ? mmu_free_root_page+0x2c0/0x2c0 [kvm]
[177246.310225][T1995658]  ?
kvm_clear_async_pf_completion_queue+0x2f/0x510 [kvm]
[177246.310297][T1995658]  kvm_mmu_unload+0x1c/0xa0 [kvm]
[177246.330051][T1995658]  kvm_arch_destroy_vm+0x1f2/0x5c0 [kvm]
[177246.339422][T1995658]  ? mmu_notifier_unregister+0x26f/0x330
[177246.339434][T1995658]  kvm_put_kvm+0x3b1/0x8b0 [kvm]
[177246.357081][T1995658]  kvm_vcpu_release+0x4e/0x70 [kvm]
[177246.365745][T1995658]  __fput+0x1f7/0x8c0
[177246.365751][T1995658]  task_work_run+0xf8/0x1a0
[177246.380735][T1995658]  do_exit+0x97b/0x2230
[177246.388056][T1995658]  ? _raw_write_lock_irqsave+0xe0/0xe0
[177246.388062][T1995658]  ? mm_update_next_owner+0x750/0x750
[177246.388067][T1995658]  ? _raw_spin_lock_irq+0x82/0xd0
[177246.413105][T1995658]  do_group_exit+0xda/0x2a0
[177246.420604][T1995658]  get_signal+0x3be/0x1e50
[177246.427936][T1995658]  arch_do_signal_or_restart+0x244/0x17f0
[177246.427943][T1995658]  ? audit_log_exit+0x2690/0x2690
[177246.444593][T1995658]  ? shmem_evict_inode+0xad0/0xad0
[177246.444601][T1995658]  ? get_sigframe_size+0x10/0x10
[177246.460403][T1995658]  ? __seccomp_filter+0x117/0xd60
[177246.468231][T1995658]  ? audit_alloc_name+0x440/0x440
[177246.468236][T1995658]  ? get_nth_filter.part.0+0x220/0x220
[177246.468239][T1995658]  ? __audit_syscall_exit+0x794/0xa80
[177246.468244][T1995658]  exit_to_user_mode_prepare+0xcb/0x120
[177246.486130][T2343516] BUG: Bad page state in process dnsdist  pfn:3ac443
[177246.492473][T1995658]  syscall_exit_to_user_mode+0x1d/0x40
[177246.500835][T2343516] page:000000000df8ed4b refcount:0 mapcount:0
mapping:0000000000000000 index:0x1 pfn:0x3ac443
[177246.510416][T1995658]  do_syscall_64+0x4d/0x90
[177246.518772][T2343516] flags:
0x2ffff80000000a(referenced|dirty|node=0|zone=2|lastcpupid=0x1ffff)
[177246.532071][T1995658]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[177246.539574][T2343516] raw: 002ffff80000000a dead000000000100
dead000000000122 0000000000000000
[177246.551516][T1995658] RIP: 0033:0x4890ca
[177246.560640][T2343516] raw: 0000000000000001 0000000000000000
00000000ffffffff 0000000000000000
[177246.572553][T1995658] Code: Unable to access opcode bytes at RIP 0x4890a0.
[177246.572556][T1995658] RSP: 002b:000000c000508608 EFLAGS: 00000216
[177246.579708][T2343516] page dumped because:
PAGE_FLAGS_CHECK_AT_PREP flag(s) set
[177246.591667][T1995658]  ORIG_RAX: 000000000000011d
[177246.601947][T2343516] Modules linked in: xt_hashlimit
[177246.611442][T1995658] RAX: 0000000000000000 RBX: 000000c00003e000
RCX: 00000000004890ca
[177246.622186][T2343516]  xt_connlimit nf_conncount
[177246.630505][T1995658] RDX: 0000000036466000 RSI: 0000000000000003
RDI: 0000000000000010
[177246.639127][T2343516]  ip_set_hash_netport xt_length
[177246.650831][T1995658] RBP: 000000c000508660 R08: 0000000000000000
R09: 0000000000000000
[177246.659146][T2343516]  esp4 sit
[177246.670801][T1995658] R10: 000000000676b000 R11: 0000000000000216
R12: 0000000000000009
[177246.679548][T2343516]  ipip tunnel4
[177246.691327][T1995658] R13: 000000c00129d8b8 R14: 0000000000000001
R15: 0000000000000000
[177246.691332][T1995658]  </TASK>
[177246.698177][T2343516]  nft_numgen
[177246.710054][T1995658] Modules linked in: xt_hashlimit
[177246.717376][T2343516]  nft_ct ip_gre
[177246.729337][T1995658]  xt_connlimit nf_conncount
[177246.736385][T2343516]  gre xfrm_user
[177246.743566][T1995658]  ip_set_hash_netport xt_length
[177246.752511][T2343516]  xfrm_algo tcp_diag
[177246.759923][T1995658]  esp4 sit
[177246.768447][T2343516]  udp_diag inet_diag
[177246.775861][T1995658]  ipip tunnel4
[177246.784702][T2343516]  fou6 fou
[177246.792590][T1995658]  nft_numgen nft_ct
[177246.799633][T2343516]  ip6_tunnel tunnel6
[177246.807521][T1995658]  ip_gre gre
[177246.814891][T2343516]  ip_tunnel
[177246.821906][T1995658]  xfrm_user xfrm_algo
[177246.829831][T2343516]  ip6_udp_tunnel udp_tunnel
[177246.837687][T1995658]  tcp_diag udp_diag
[177246.844899][T2343516]  cls_bpf tls
[177246.851988][T1995658]  inet_diag fou6
[177246.860054][T2343516]  xt_NFLOG
[177246.868476][T1995658]  fou ip6_tunnel
[177246.876205][T2343516]  xt_statistic
[177246.883435][T1995658]  tunnel6 ip_tunnel
[177246.890967][T2343516]  nft_compat
[177246.897928][T1995658]  ip6_udp_tunnel udp_tunnel
[177246.905366][T2343516]  veth
[177246.912707][T1995658]  cls_bpf tls
[177246.920424][T2343516]  tun overlay
[177246.927451][T1995658]  xt_NFLOG xt_statistic
[177246.935692][T2343516]  macvlan
[177246.941990][T1995658]  nft_compat veth
[177246.948848][T2343516]  sch_ingress raid0
[177246.955617][T1995658]  tun overlay
[177246.963226][T2343516]  md_mod essiv
[177246.969540][T1995658]  macvlan sch_ingress
[177246.976443][T2343516]  dm_crypt trusted
[177246.983523][T1995658]  raid0 md_mod
[177246.990026][T2343516]  asn1_encoder tee
[177246.996500][T1995658]  essiv dm_crypt
[177247.003663][T2343516]  dm_mod dax
[177247.010435][T1995658]  trusted asn1_encoder
[177247.016794][T2343516]  nfnetlink_log nft_log
[177247.023445][T1995658]  tee dm_mod
[177247.029892][T2343516]  nft_limit
[177247.035861][T1995658]  dax nfnetlink_log
[177247.042663][T2343516]  nft_counter nf_tables
[177247.049640][T1995658]  nft_log
[177247.055470][T2343516]  ip6table_nat
[177247.061129][T1995658]  nft_limit nft_counter
[177247.067401][T2343516]  ip6table_mangle
[177247.073987][T1995658]  nf_tables ip6table_nat
[177247.079498][T2343516]  ip6table_security ip6table_raw
[177247.085277][T1995658]  ip6table_mangle
[177247.091991][T2343516]  ip6table_filter ip6_tables
[177247.098034][T1995658]  ip6table_security ip6table_raw
[177247.104695][T2343516]  xt_nat iptable_nat
[177247.112034][T1995658]  ip6table_filter ip6_tables
[177247.118039][T2343516]  nf_nat xt_TCPMSS
[177247.125004][T1995658]  xt_nat iptable_nat
[177247.132376][T2343516]  xt_u32
[177247.138705][T1995658]  nf_nat xt_TCPMSS xt_u32
[177247.145715][T2343516]  xt_connmark
[177247.151843][T1995658]  xt_connmark iptable_mangle xt_owner
[177247.158146][T2343516]  iptable_mangle
[177247.163422][T1995658]  xt_CT iptable_raw
[177247.170185][T2343516]  xt_owner xt_CT
[177247.175921][T1995658]  xt_state xt_bpf
[177247.183751][T2343516]  iptable_raw xt_state
[177247.189765][T1995658]  xt_mark xt_conntrack
[177247.196014][T2343516]  xt_bpf xt_mark
[177247.202024][T1995658]  xt_multiport xt_comment xt_tcpudp
[177247.208091][T2343516]  xt_conntrack
[177247.214620][T1995658]  xt_set xt_tcpmss iptable_filter
[177247.221195][T2343516]  xt_multiport
[177247.227181][T1995658]  ip_set_hash_net
[177247.234862][T2343516]  xt_comment xt_tcpudp
[177247.240694][T1995658]  ip_set_hash_ip ip_set
[177247.248244][T2343516]  xt_set xt_tcpmss
[177247.254108][T1995658]  nfnetlink sch_fq
[177247.260257][T2343516]  iptable_filter ip_set_hash_net
[177247.266823][T1995658]  tcp_bbr nf_conntrack
[177247.273564][T2343516]  ip_set_hash_ip ip_set
[177247.279798][T1995658]  nf_defrag_ipv6 nf_defrag_ipv4
[177247.286054][T2343516]  nfnetlink sch_fq
[177247.293537][T1995658]  8021q garp
[177247.300146][T2343516]  tcp_bbr nf_conntrack
[177247.306851][T1995658]  stp mrp
[177247.314280][T2343516]  nf_defrag_ipv6
[177247.320726][T1995658]  llc skx_edac
[177247.326501][T2343516]  nf_defrag_ipv4
[177247.333200][T1995658]  x86_pkg_temp_thermal
[177247.338746][T2343516]  8021q garp
[177247.344900][T1995658]  kvm_intel kvm
[177247.350878][T2343516]  stp mrp
[177247.356981][T1995658]  irqbypass crc32_pclmul
[177247.363642][T2343516]  llc skx_edac
[177247.369407][T1995658]  crc32c_intel aesni_intel
[177247.375433][T2343516]  x86_pkg_temp_thermal kvm_intel
[177247.380949][T1995658]  rapl intel_cstate
[177247.387818][T2343516]  kvm irqbypass
[177247.393792][T1995658]  ipmi_ssif sfc
[177247.400823][T2343516]  crc32_pclmul crc32c_intel
[177247.408402][T1995658]  intel_uncore
[177247.414816][T2343516]  aesni_intel rapl
[177247.420895][T1995658]  i2c_i801 xhci_pci
[177247.426998][T2343516]  intel_cstate
[177247.434174][T1995658]  i2c_smbus acpi_ipmi
[177247.440133][T2343516]  ipmi_ssif
[177247.446447][T1995658]  i40e mdio
[177247.452828][T2343516]  sfc intel_uncore
[177247.458764][T1995658]  ioatdma i2c_core xhci_hcd tpm_crb
[177247.465315][T2343516]  i2c_i801
[177247.470986][T1995658]  dca ipmi_si
[177247.476630][T2343516]  xhci_pci i2c_smbus
[177247.482924][T1995658]  ipmi_devintf ipmi_msghandler
[177247.490884][T2343516]  acpi_ipmi
[177247.496448][T1995658]  tpm_tis tpm_tis_core
[177247.502266][T2343516]  i40e
[177247.508870][T1995658]  tpm tiny_power_button
[177247.516227][T2343516]  mdio
[177247.521960][T1995658]  button fuse
[177247.528752][T2343516]  ioatdma i2c_core
[177247.534017][T1995658]  efivarfs
[177247.540736][T2343516]  xhci_hcd tpm_crb
[177247.545945][T1995658]  ip_tables x_tables
[177247.551808][T2343516]  dca ipmi_si
[177247.558097][T1995658]  bcmcrypt(O)
[177247.563798][T2343516]  ipmi_devintf ipmi_msghandler
[177247.570085][T1995658]  crypto_simd
[177247.576506][T2343516]  tpm_tis tpm_tis_core
[177247.582311][T1995658]  cryptd [last unloaded: kheaders]
[177247.582349][T1995658] ---[ end trace bf693a2532f213e5 ]---
[177247.588090][T2343516]  tpm tiny_power_button button fuse efivarfs ip_tables
[177247.671277][T1995658] RIP: 0010:workingset_activation+0x175/0x2f0
[177247.673366][T2343516]  x_tables bcmcrypt(O) crypto_simd
[177247.682978][T1995658] Code: 80 3c 02 00 0f 85 58 01 00 00 4a 8b ac
ed b8 0f 00 00 48 8d bd 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 48
89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 0d 01 00 00 4c 3b a5 88 00 00 00
0f 85 c3 00 00
[177247.691625][T2343516]  cryptd [last unloaded: kheaders]
[177247.691633][T2343516] CPU: 30 PID: 2343516 Comm: dnsdist Tainted:
G    B D W  O      5.15.5-cloudflare-kasan-2021.11.11 #1
[177247.691639][T2343516] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U/T42S-2U MB (Lewisburg-4), BIOS 3B16.Q102 02/19/2020
[177247.691642][T2343516] Call Trace:
[177247.691645][T2343516]  <TASK>
[177247.699575][T1995658] RSP: 0018:ffff8881ec51f3c0 EFLAGS: 00010206
[177247.724584][T2343516]  dump_stack_lvl+0x34/0x44
[177247.724595][T2343516]  bad_page.cold+0xc0/0xe1
[177247.732606][T1995658]
[177247.746616][T2343516]  rmqueue_bulk+0x8e5/0xe00
[177247.746627][T2343516]  ? find_suitable_fallback+0x470/0x470
[177247.764885][T1995658] RAX: dffffc0000000000 RBX: ffffea003237e480
RCX: ffffffffa25388a6
[177247.771268][T2343516]  get_page_from_freelist+0x18ff/0x2920
[177247.771279][T2343516]  ? __zone_watermark_ok+0x340/0x340
[177247.777285][T1995658] RDX: 0000000000000011 RSI: 0000000000000246
RDI: 0000000000000088
[177247.786537][T2343516]  __alloc_pages+0x2ac/0x5b0
[177247.786543][T2343516]  ? __alloc_pages_slowpath.constprop.0+0x1e20/0x1e20
[177247.786548][T2343516]  alloc_pages_vma+0xbc/0x570
[177247.794244][T1995658] RBP: 0000000000000000 R08: 0000000000000001
R09: ffffffffa6ced907
[177247.801816][T2343516]  __handle_mm_fault+0x14d6/0x3a00
[177247.801822][T2343516]  ? vm_iomap_memory+0x1d0/0x1d0
[177247.801827][T2343516]  ? down_read_trylock+0xeb/0x180
[177247.807247][T1995658] R10: fffffbfff4d9db20 R11: 0000000000000010
R12: ffff88983ffde000
[177247.814873][T2343516]  handle_mm_fault+0x1cc/0x650
[177247.814878][T2343516]  do_user_addr_fault+0x303/0xd40
[177247.814885][T2343516]  exc_page_fault+0x52/0xb0
[177247.823577][T1995658] R13: 0000000000000000 R14: ffff8897a9bbbde0
R15: 0600000c8df93b77
[177247.834904][T2343516]  ? asm_exc_page_fault+0x8/0x30
[177247.834911][T2343516]  asm_exc_page_fault+0x1e/0x30
[177247.834915][T2343516] RIP: 0033:0x557a8ea64f19
[177247.843738][T1995658] FS:  0000000000000000(0000)
GS:ffff8897a9b80000(0000) knlGS:0000000000000000
[177247.852290][T2343516] Code: c7 80 04 ff ff ff 00 00 00 00 c7 80 18
ff ff ff 00 00 00 00 48 c7 80 20 ff ff ff 00 00 00 00 48 c7 80 28 ff
ff ff 00 00 00 00 <c6> 80 30 ff ff ff 01 c6 80 38 ff ff ff 01 c6 80 39
ff ff ff 00 48
[177247.852295][T2343516] RSP: 002b:00007fff6f3f11c0 EFLAGS: 00010246
[177247.852299][T2343516] RAX: 0000557a9840d0d0 RBX: 0000557a92334cc0
RCX: 0000000000000000
[177247.852301][T2343516] RDX: ffffffffffffffff RSI: 0000000000000000
RDI: 0000000000000000
[177247.852304][T2343516] RBP: 00000000000099d4 R08: 0000000000000000
R09: 0000000000000000
[177247.863709][T1995658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[177247.871673][T2343516] R10: 0000000000000000 R11: 0000000000000000
R12: 0000557a991452f0
[177247.871676][T2343516] R13: 00007fff6f3f1420 R14: 00007fff6f3f1440
R15: 0000000000000001
[177247.871680][T2343516]  </TASK>

After this the machine starts spitting some traces starting with:

[177247.871683][T2343516] BUG: Bad page state in process <some comm
name>  pfn:fe680a

And eventually gradually locks up:

NMI watchdog: Watchdog detected hard LOCKUP on cpu 81

The comment in kvm_main.c before the code mentioned in the first
warning states that the warning is there to indicate incorrect usage
of the function - and probably it is, given the consequences.

About our workload: this bug is most likely triggered by gvisor [1]
with the KVM backend as we don't have any other KVM users on these
systems.

We suspect it was not triggered before as kernels before 5.15 did not
have TDP MMU enabled by default [2].

It seems we even want to remove this warning as overaggressive [3],
however it is indicative in this case.

Unfortunately, I couldn't easily reproduce the issue synthetically
(tried both running the KVM selftests as well as gvisor KVM tests).
Any help/pointers would be appreciated.

[1]: https://github.com/google/gvisor
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=71ba3f3189c78f756a659568fb473600fd78f207
[3]: https://lore.kernel.org/kvm/20211129034317.2964790-5-stevensd@google.com/
