Return-Path: <kvm+bounces-52333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B26DEB04185
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B35B4A5EE9
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 390A52609D4;
	Mon, 14 Jul 2025 14:21:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B6225B67D;
	Mon, 14 Jul 2025 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.120.2.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752502911; cv=none; b=iZ64zKxppXrYSh6JARmxD2o7SZq3rNqJUhvxhYbbdLShdB7Mv2YeZtintDOp2HSH9rJLuR2uAGQiT65qwNH+GiCXN7+d9cqaq6QqQg8uG5a1xrnotl+KhA5qChZvOvYwCngTjRyfEZ9zABQ9mAinT6R0ByzS3ADFbz317RMcem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752502911; c=relaxed/simple;
	bh=MJhPyBPJffxuH0kZd/ed3DDAXWNlbw953m5XyamjTA0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=i+21o42zuXDvZTg6Dc1pu1PnMcaFSGL/vHvvtetC616CMmItJikNH3mRBYJiST0/HHiWfu0p8wumdeFQ/IkKH6Oc+lMhkPftynJZjUtxp+i8S7TAZTF3iJ512qaJsudYKfebIVRYqv8VmvzF6ep8Ya+pC5V7VOU4gvfnqA0dcTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn; spf=pass smtp.mailfrom=sjtu.edu.cn; arc=none smtp.client-ip=202.120.2.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id F0A87102CD484;
	Mon, 14 Jul 2025 22:12:45 +0800 (CST)
Received: from smtpclient.apple (unknown [202.120.40.82])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 234FA37C929;
	Mon, 14 Jul 2025 22:12:45 +0800 (CST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [BUG] NULL pointer dereference in sev_writeback_caches during KVM
 SEV migration kselftest on AMD platform
From: Zheyun Shen <szy0127@sjtu.edu.cn>
In-Reply-To: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com>
Date: Mon, 14 Jul 2025 22:12:32 +0800
Cc: seanjc@google.com,
 linux-next@vger.kernel.org,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F7AF073C-D630-45A3-8746-DE66B15FC3E1@sjtu.edu.cn>
References: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com>
To: "Aithal, Srikanth" <sraithal@amd.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)

Hi Aithal,
I can reproduce this issue in my environment, and I will try to resolve =
it as soon as possible.

Thanks,
Zheyun Shen

> 2025=E5=B9=B47=E6=9C=8814=E6=97=A5 13:21=EF=BC=8CAithal, Srikanth =
<sraithal@amd.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello,
>=20
> While running the kselftest for SEV migration (sev_migrate_tes) on =
linux-next (6.16.0-rc5-next-20250711, commit a62b7a37e6) on an AMD-based =
paltforms [Milan,Genoa,Turin], I encountered below kernel crash while =
running kvm kselftests:
>=20
> [ 714.008402] BUG: kernel NULL pointer dereference, address: =
0000000000000000
> [ 714.015363] #PF: supervisor read access in kernel mode
> [ 714.020504] #PF: error_code(0x0000) - not-present page
> [ 714.025643] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
> [ 714.031303] Oops: Oops: 0000 [#1] SMP NOPTI
> [ 714.035487] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Not =
tainted 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 =
PREEMPT(voluntary)
> [ 714.048253] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS =
2.17.0 12/04/2024
> [ 714.055905] RIP: 0010:_find_first_bit+0x1d/0x40
> [ 714.060439] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa =
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 =
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
> [ 714.079184] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
> [ 714.084409] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: =
000000000000f7ff
> [ 714.091541] RDX: 0000000000000000 RSI: 0000000000000080 RDI: =
0000000000000000
> [ 714.098674] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: =
00000000000002aa
> [ 714.105807] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: =
0000000000000080
> [ 714.112939] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: =
ffff95e087e8ac98
> [ 714.120072] FS: 00007fd51a0f5740(0000) GS:ffff95ffd53b0000(0000) =
knlGS:0000000000000000
> [ 714.128156] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 714.133902] CR2: 0000000000000000 CR3: 000000014f670003 CR4: =
0000000000770ef0
> [ 714.141035] PKRU: 55555554
> [ 714.143750] Call Trace:
> [ 714.146201] <TASK>
> [ 714.148307] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
> [ 714.153544] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
> [ 714.159115] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
> [ 714.164817] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
> [ 714.169896] mmu_notifier_unregister+0x53/0xf0
> [ 714.174343] kvm_destroy_vm+0x12d/0x2d0 [kvm]
> [ 714.178727] kvm_vm_stats_release+0x34/0x60 [kvm]
> [ 714.183459] __fput+0xf2/0x2d0
> [ 714.186520] fput_close_sync+0x44/0xa0
> [ 714.190269] __x64_sys_close+0x42/0x80
> [ 714.194024] x64_sys_call+0x1960/0x2180
> [ 714.197861] do_syscall_64+0x56/0x1e0
> [ 714.201530] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 714.206579] RIP: 0033:0x7fd519efe717
> [ 714.210161] Code: ff e8 6d ec 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f =
1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f =
05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 a3 83 f8 ff
> [ 714.228906] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000003
> [ 714.236472] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: =
00007fd519efe717
> [ 714.243604] RDX: 0000000000420146 RSI: 000000000041f05e RDI: =
0000000000000029
> [ 714.250737] RBP: 0000000002622e80 R08: 0000000000000000 R09: =
000000000042013e
> [ 714.257869] R10: 00007fd519fb83dd R11: 0000000000000246 R12: =
0000000002623ed8
> [ 714.265000] R13: 0000000002623ed8 R14: 000000000042fe08 R15: =
00007fd51a147000
> [ 714.272136] </TASK>
> [ 714.274326] Modules linked in: nft_fib_inet nft_fib_ipv4 =
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 =
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl =
intel_rapl_msr intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm =
rapl wmi_bmof i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si =
k10temp i2c_smbus acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid =
sch_fq_codel dmi_sysfs xfs mgag200 drm_client_lib i2c_algo_bit =
drm_shmem_helper drm_kms_helper ghash_clmulni_intel mpt3sas sha1_ssse3 =
raid_class drm tg3 ccp scsi_transport_sas sp5100_tco wmi dm_mirror =
dm_region_hash dm_log msr autofs4 aesni_intel
> [ 714.336656] CR2: 0000000000000000
> [ 714.339975] ---[ end trace 0000000000000000 ]---
> [ 714.379956] pstore: backend (erst) writing error (-28)
> [ 714.385093] RIP: 0010:_find_first_bit+0x1d/0x40
> [ 714.389625] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa =
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 =
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
> [ 714.408370] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
> [ 714.413595] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: =
000000000000f7ff
> [ 714.420729] RDX: 0000000000000000 RSI: 0000000000000080 RDI: =
0000000000000000
> [ 714.427862] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: =
00000000000002aa
> [ 714.434992] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: =
0000000000000080
> [ 714.442126] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: =
ffff95e087e8ac98
> [ 714.449257] FS: 00007fd51a0f5740(0000) GS:ffff95ffd53b0000(0000) =
knlGS:0000000000000000
> [ 714.457344] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 714.463090] CR2: 0000000000000000 CR3: 000000014f670003 CR4: =
0000000000770ef0
> [ 714.470223] PKRU: 55555554
> [ 714.472936] note: sev_migrate_tes[16663] exited with irqs disabled
> [ 714.479189] BUG: kernel NULL pointer dereference, address: =
0000000000000000
> [ 714.486145] #PF: supervisor read access in kernel mode
> [ 714.491281] #PF: error_code(0x0000) - not-present page
> [ 714.496421] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
> [ 714.502082] Oops: Oops: 0000 [#2] SMP NOPTI
> [ 714.506267] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Tainted: =
G D 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 =
PREEMPT(voluntary)
> [ 714.520593] Tainted: [D]=3DDIE
> [ 714.523477] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS =
2.17.0 12/04/2024
> [ 714.531131] RIP: 0010:_find_first_bit+0x1d/0x40
> [ 714.535662] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa =
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 =
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
> [ 714.554409] RSP: 0018:ffffb9a769b7fcd0 EFLAGS: 00010246
> [ 714.559635] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: =
0000000000000000
> [ 714.566768] RDX: 0000000000000000 RSI: 0000000000000080 RDI: =
0000000000000000
> [ 714.573900] RBP: ffffb9a769b7fce8 R08: ffff95e0a54ff670 R09: =
0000000080100001
> [ 714.581033] R10: 0000000000020000 R11: 0000000000000000 R12: =
0000000000000080
> [ 714.588165] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: =
ffff95e089d95a08
> [ 714.595296] FS: 0000000000000000(0000) GS:ffff95ffd53b0000(0000) =
knlGS:0000000000000000
> [ 714.603381] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 714.609130] CR2: 0000000000000000 CR3: 000000014f670003 CR4: =
0000000000770ef0
> [ 714.616260] PKRU: 55555554
> [ 714.618963] Call Trace:
> [ 714.621407] <TASK>
> [ 714.623516] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
> [ 714.628741] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
> [ 714.634315] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
> [ 714.640008] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
> [ 714.645088] __mmu_notifier_release+0x73/0x1e0
> [ 714.649532] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.654323] ? sched_clock_cpu+0x14/0x1a0
> [ 714.658338] exit_mmap+0x3b1/0x400
> [ 714.661745] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.666536] ? futex_cleanup+0xb0/0x460
> [ 714.670375] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.675166] ? perf_event_exit_task_context+0x33/0x280
> [ 714.680307] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.685100] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.689890] ? mutex_lock+0x17/0x50
> [ 714.693383] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 714.698177] mmput+0x6a/0x130
> [ 714.701148] do_exit+0x258/0xa40
> [ 714.704385] make_task_dead+0x85/0x160
> [ 714.708134] rewind_stack_and_make_dead+0x16/0x20
> [ 714.712951] RIP: 0033:0x7fd519efe717
> [ 714.716532] Code: Unable to access opcode bytes at 0x7fd519efe6ed.
> [ 714.722710] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000003
> [ 714.730276] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: =
00007fd519efe717
> [ 714.737409] RDX: 0000000000420146 RSI: 000000000041f05e RDI: =
0000000000000029
> [ 714.744543] RBP: 0000000002622e80 R08: 0000000000000000 R09: =
000000000042013e
> [ 714.751673] R10: 00007fd519fb83dd R11: 0000000000000246 R12: =
0000000002623ed8
> [ 714.758807] R13: 0000000002623ed8 R14: 000000000042fe08 R15: =
00007fd51a147000
> [ 714.765942] </TASK>
> [ 714.768132] Modules linked in: nft_fib_inet nft_fib_ipv4 =
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 =
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl =
intel_rapl_msr intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm =
rapl wmi_bmof i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si =
k10temp i2c_smbus acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid =
sch_fq_codel dmi_sysfs xfs mgag200 drm_client_lib i2c_algo_bit =
drm_shmem_helper drm_kms_helper ghash_clmulni_intel mpt3sas sha1_ssse3 =
raid_class drm tg3 ccp scsi_transport_sas sp5100_tco wmi dm_mirror =
dm_region_hash dm_log msr autofs4 aesni_intel
> [ 714.830455] CR2: 0000000000000000
> [ 714.833773] ---[ end trace 0000000000000000 ]---
> [ 714.886371] RIP: 0010:_find_first_bit+0x1d/0x40
> [ 714.890899] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa =
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 =
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
> [ 714.909647] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
> [ 714.914871] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: =
000000000000f7ff
> [ 714.922004] RDX: 0000000000000000 RSI: 0000000000000080 RDI: =
0000000000000000
> [ 714.929138] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: =
00000000000002aa
> [ 714.936271] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: =
0000000000000080
> [ 714.943400] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: =
ffff95e087e8ac98
> [ 714.950527] FS: 0000000000000000(0000) GS:ffff95ffd53b0000(0000) =
knlGS:0000000000000000
> [ 714.958613] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 714.964357] CR2: 0000000000000000 CR3: 000000014f670003 CR4: =
0000000000770ef0
> [ 714.971490] PKRU: 55555554
> [ 714.974202] note: sev_migrate_tes[16663] exited with irqs disabled
> [ 714.980397] Fixing recursive fault but reboot is needed!
> [ 714.985708] BUG: scheduling while atomic: =
sev_migrate_tes/16663/0x00000000
> [ 714.992580] Modules linked in: nft_fib_inet nft_fib_ipv4 =
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 =
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl =
intel_rapl_msr intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm =
rapl wmi_bmof i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si =
k10temp i2c_smbus acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid =
sch_fq_codel dmi_sysfs xfs mgag200 drm_client_lib i2c_algo_bit =
drm_shmem_helper drm_kms_helper ghash_clmulni_intel mpt3sas sha1_ssse3 =
raid_class drm tg3 ccp scsi_transport_sas sp5100_tco wmi dm_mirror =
dm_region_hash dm_log msr autofs4 aesni_intel
> [ 715.054914] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Tainted: =
G D 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 =
PREEMPT(voluntary)
> [ 715.054918] Tainted: [D]=3DDIE
> [ 715.054920] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS =
2.17.0 12/04/2024
> [ 715.054921] Call Trace:
> [ 715.054922] <TASK>
> [ 715.054923] dump_stack_lvl+0x70/0x90
> [ 715.054928] dump_stack+0x14/0x20
> [ 715.054931] __schedule_bug+0x5a/0x70
> [ 715.054934] __schedule+0xa0d/0xb30
> [ 715.054938] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 715.054941] ? vprintk_default+0x21/0x30
> [ 715.054944] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 715.054946] ? vprintk+0x1c/0x50
> [ 715.054949] ? srso_alias_return_thunk+0x5/0xfbef5
> [ 715.054952] do_task_dead+0x4e/0xa0
> [ 715.054956] make_task_dead+0x146/0x160
> [ 715.054960] rewind_stack_and_make_dead+0x16/0x20
> [ 715.054962] RIP: 0033:0x7fd519efe717
> [ 715.054964] Code: Unable to access opcode bytes at 0x7fd519efe6ed.
> [ 715.054965] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: =
0000000000000003
> [ 715.054967] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: =
00007fd519efe717
> [ 715.054968] RDX: 0000000000420146 RSI: 000000000041f05e RDI: =
0000000000000029
> [ 715.054970] RBP: 0000000002622e80 R08: 0000000000000000 R09: =
000000000042013e
> [ 715.054971] R10: 00007fd519fb83dd R11: 0000000000000246 R12: =
0000000002623ed8
> [ 715.054972] R13: 0000000002623ed8 R14: 000000000042fe08 R15: =
00007fd51a147000
> [ 715.054978] </TASK>
>=20
>=20
> Below is the culprit commit:
>=20
> commit d6581b6f2e2622f0fc350020a8e991e8be6b05d8
> Author: Zheyun Shen szy0127@sjtu.edu.cn
> Date: Thu May 22 16:37:32 2025 -0700
>=20
> KVM: SVM: Flush cache only on CPUs running SEV guest
> Link: =
https://lore.kernel.org/r/20250522233733.3176144-9-seanjc@google.com
>=20
> The issue goes away if I revert above commit.
>=20
> Regards,
> Srikanth Aithal sraithal@amd.com


