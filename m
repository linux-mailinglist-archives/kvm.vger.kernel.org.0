Return-Path: <kvm+bounces-23179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6308947096
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 23:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA4E31C20865
	for <lists+kvm@lfdr.de>; Sun,  4 Aug 2024 21:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A92139CE3;
	Sun,  4 Aug 2024 21:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="K7qxpa7k"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E090AD59;
	Sun,  4 Aug 2024 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722805542; cv=none; b=EfwPDNqK+qvXsXAHtIsDqOINzru/3HISw+CSUkWfCWksMZH4mq4Pvw7wxOvseelsb5U/f8FKVhVyVHe2uhy6ZQg8WfaEwsq09jNHUXheapCfmmRmnykvdSanOLEduI1LIpog5QZWYGrVcZCKZzNQ3Nn6lQ//Bj0NImvWJOUC6Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722805542; c=relaxed/simple;
	bh=q/BSFLz8eHoxXBkeuBMLRyC52BFQiqU7XZq3dgSrmsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=esOADNJLtla09FOdBAUadpQczM0VaRHaIHFKcUQnSrL1DS7dqVTUNMyjNyGjLc/hWU7GdoxEW4l0g5pEHeRV0GCQVXh1a18IdXZB8ux2++Xa+I9GUDI6UmbdnEoustLBaqxa5wX3du2ebxbKdXtzDLQnb/dOLra1xyWEeHOd7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=K7qxpa7k; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1saiQ0-008y6P-MC; Sun, 04 Aug 2024 23:05:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=ZQhn7uV6eRVGdfgQWSoZ3nPn5u0rQ+n5HSP2zz7VgNs=; b=K7qxpa7kAev/YcL2SJHCRZEMsI
	GGW7s/oX0psSYpNuoTx1Hi844EW1cxDokAxyCmYCH4H8sRn87Fk/ccPaMoF8+gX2LfBJXWMVQUJW1
	82IIROBKg5VvKJlW+km+4jNFEf8tiYg8OE7+1kWrGLz4DXtBHP/e+slxSFSl7IL6FJ/hpE68Lc3PM
	XhyxOgwdV9tyeYDpKQYcHjcSgTyJP1r+FHYRa3AuOQsUwxM5UpqBEZYUMhg8/mobeKsQUPH5hHuQ3
	H8TtwpM7fN7wsE8a3Yps4zbibm3cfkhSDuLtwKOH3jvExneGlRhMmy+7JToquEA8kQmElWrO8lmkP
	rYotDPZA==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1saiPx-00017D-7C; Sun, 04 Aug 2024 23:05:32 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1saiPv-00D1Oj-9L; Sun, 04 Aug 2024 23:05:27 +0200
Message-ID: <07987fc3-5c47-4e77-956c-dae4bdf4bc2b@rbox.co>
Date: Sun, 4 Aug 2024 23:05:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: Fix error path in kvm_vm_ioctl_create_vcpu() on
 xa_store() failure
To: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko
 <glider@google.com>, Marc Zyngier <maz@kernel.org>
References: <20240730155646.1687-1-will@kernel.org>
 <ccd40ae1-14aa-454e-9620-b34154f03e53@rbox.co> <Zql3vMnR86mMvX2w@google.com>
 <20240731133118.GA2946@willie-the-truck>
 <3e5f7422-43ce-44d4-bff7-cc02165f08c0@rbox.co> <Zqpj8M3xhPwSVYHY@google.com>
 <20240801124131.GA4730@willie-the-truck>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <20240801124131.GA4730@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/24 14:41, Will Deacon wrote:
> On Wed, Jul 31, 2024 at 09:18:56AM -0700, Sean Christopherson wrote:
>> [...]
>> Ya, the basic problem is that we have two ways of publishing the vCPU, fd and
>> vcpu_array, with no way of setting both atomically.  Given that xa_store() should
>> never fail, I vote we do the simple thing and deliberately leak the memory.
> 
> I'm inclined to agree. This conversation did momentarily get me worried
> about the window between the successful create_vcpu_fd() and the
> xa_store(), but it looks like 'kvm->online_vcpus' protects that.
> 
> I'll spin a v2 leaking the vCPU, then.

But perhaps you're right. The window you've described may be an issue.
For example:

static u64 get_time_ref_counter(struct kvm *kvm)
{
	...
	vcpu = kvm_get_vcpu(kvm, 0); // may still be NULL
	tsc = kvm_read_l1_tsc(vcpu, rdtsc());
	return mul_u64_u64_shr(tsc, hv->tsc_ref.tsc_scale, 64)
		+ hv->tsc_ref.tsc_offset;
}

u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
{
	return vcpu->arch.l1_tsc_offset +
		kvm_scale_tsc(host_tsc, vcpu->arch.l1_tsc_scaling_ratio);
}

After stuffing msleep() between fd install and vcpu_array store:

[  125.296110] BUG: kernel NULL pointer dereference, address: 0000000000000b38
[  125.296203] #PF: supervisor read access in kernel mode
[  125.296266] #PF: error_code(0x0000) - not-present page
[  125.296327] PGD 12539e067 P4D 12539e067 PUD 12539d067 PMD 0
[  125.296392] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[  125.296454] CPU: 12 UID: 1000 PID: 1179 Comm: a.out Not tainted 6.11.0-rc1nokasan+ #19
[  125.296521] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[  125.296585] RIP: 0010:kvm_read_l1_tsc+0x6/0x50 [kvm]
[  125.297376] Call Trace:
[  125.297430]  <TASK>
[  125.297919]  get_time_ref_counter+0x70/0x90 [kvm]
[  125.298039]  kvm_hv_get_msr_common+0xc1/0x7d0 [kvm]
[  125.298150]  __kvm_get_msr+0x72/0xf0 [kvm]
[  125.298421]  do_get_msr+0x16/0x50 [kvm]
[  125.298531]  msr_io+0x9d/0x110 [kvm]
[  125.298626]  kvm_arch_vcpu_ioctl+0xdc5/0x19c0 [kvm]
[  125.299345]  kvm_vcpu_ioctl+0x6cc/0x920 [kvm]
[  125.299540]  __x64_sys_ioctl+0x90/0xd0
[  125.299582]  do_syscall_64+0x93/0x180
[  125.300206]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  125.300243] RIP: 0033:0x7f2d64aded2d

So, is get_time_ref_counter() broken (with a trivial fix) or should it be
considered a regression after commit afb2acb2e3a3
("KVM: Fix vcpu_array[0] races")?

Note that KASAN build, after null ptr oops, reports:

[ 3528.449742] BUG: KASAN: slab-use-after-free in mutex_can_spin_on_owner+0x18b/0x1b0
[ 3528.449884] Read of size 4 at addr ffff88814a040034 by task a.out/1240
[ 3528.450135] CPU: 6 UID: 1000 PID: 1240 Comm: a.out Tainted: G      D            6.11.0-rc1+ #20
[ 3528.450289] Tainted: [D]=DIE
[ 3528.450412] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
[ 3528.450551] Call Trace:
[ 3528.450677]  <TASK>
[ 3528.450802]  dump_stack_lvl+0x68/0x90
[ 3528.450940]  print_report+0x174/0x4f6
[ 3528.451074]  ? __virt_addr_valid+0x208/0x410
[ 3528.451205]  ? mutex_can_spin_on_owner+0x18b/0x1b0
[ 3528.451337]  kasan_report+0xb9/0x190
[ 3528.451469]  ? mutex_can_spin_on_owner+0x18b/0x1b0
[ 3528.451606]  mutex_can_spin_on_owner+0x18b/0x1b0
[ 3528.451737]  __mutex_lock+0x1e3/0x1010
[ 3528.451871]  ? kvm_arch_vcpu_postcreate+0x3c/0x150 [kvm]
[ 3528.452321]  ? __pfx___mutex_lock+0x10/0x10
[ 3528.452456]  ? __pfx_lock_release+0x10/0x10
[ 3528.452642]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[ 3528.452794]  ? __pfx_do_raw_spin_lock+0x10/0x10
[ 3528.452928]  ? kvm_arch_vcpu_postcreate+0x3c/0x150 [kvm]
[ 3528.453303]  kvm_arch_vcpu_postcreate+0x3c/0x150 [kvm]
[ 3528.453663]  kvm_vm_ioctl+0x1b73/0x21b0 [kvm]
[ 3528.454025]  ? mark_lock+0xe2/0x1530
[ 3528.454160]  ? __pfx_kvm_vm_ioctl+0x10/0x10 [kvm]
[ 3528.454543]  ? __pfx_mark_lock+0x10/0x10
[ 3528.454686]  ? __pfx_lock_release+0x10/0x10
[ 3528.454826]  ? schedule+0xe8/0x3b0
[ 3528.454970]  ? __lock_acquire+0xd68/0x5e20
[ 3528.455114]  ? futex_wait_setup+0xb2/0x190
[ 3528.455252]  ? __entry_text_end+0x1543/0x10260d
[ 3528.455385]  ? __pfx___lock_acquire+0x10/0x10
[ 3528.455542]  ? __pfx_futex_wake_mark+0x10/0x10
[ 3528.455676]  ? __pfx_do_vfs_ioctl+0x10/0x10
[ 3528.455826]  ? find_held_lock+0x2d/0x110
[ 3528.455959]  ? lock_release+0x44b/0x770
[ 3528.456090]  ? __pfx_futex_wait+0x10/0x10
[ 3528.456222]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[ 3528.456368]  ? __fget_files+0x1d6/0x340
[ 3528.456508]  __x64_sys_ioctl+0x130/0x1a0
[ 3528.456641]  do_syscall_64+0x93/0x180
[ 3528.456772]  ? lockdep_hardirqs_on_prepare+0x16d/0x400
[ 3528.456907]  ? do_syscall_64+0x9f/0x180
[ 3528.457034]  ? lockdep_hardirqs_on+0x78/0x100
[ 3528.457164]  ? do_syscall_64+0x9f/0x180
[ 3528.457292]  ? lock_release+0x44b/0x770
[ 3528.457425]  ? __pfx_lock_release+0x10/0x10
[ 3528.457560]  ? lockdep_hardirqs_on_prepare+0x16d/0x400
[ 3528.457694]  ? do_syscall_64+0x9f/0x180
[ 3528.457821]  ? lockdep_hardirqs_on+0x78/0x100
[ 3528.457950]  ? do_syscall_64+0x9f/0x180
[ 3528.458081]  ? clear_bhb_loop+0x45/0xa0
[ 3528.458210]  ? clear_bhb_loop+0x45/0xa0
[ 3528.458341]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 3528.458475] RIP: 0033:0x7f2457d4ed2d
[ 3528.458609] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
[ 3528.458783] RSP: 002b:00007ffd616de5d0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 3528.458927] RAX: ffffffffffffffda RBX: 00007ffd616de778 RCX: 00007f2457d4ed2d
[ 3528.459062] RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000004
[ 3528.459195] RBP: 00007ffd616de620 R08: 00000000004040c0 R09: 0000000000000001
[ 3528.459327] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[ 3528.459459] R13: 0000000000000000 R14: 00007f2457e77000 R15: 0000000000403e00
[ 3528.459604]  </TASK>

[ 3528.459843] Allocated by task 1240:
[ 3528.459968]  kasan_save_stack+0x1e/0x40
[ 3528.460100]  kasan_save_track+0x10/0x30
[ 3528.460230]  __kasan_slab_alloc+0x85/0x90
[ 3528.460357]  kmem_cache_alloc_node_noprof+0x12c/0x360
[ 3528.460488]  copy_process+0x372/0x8470
[ 3528.460617]  kernel_clone+0xa6/0x620
[ 3528.460744]  __do_sys_clone3+0x109/0x140
[ 3528.460873]  do_syscall_64+0x93/0x180
[ 3528.460998]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

[ 3528.461246] Freed by task 0:
[ 3528.461368]  kasan_save_stack+0x1e/0x40
[ 3528.461499]  kasan_save_track+0x10/0x30
[ 3528.461628]  kasan_save_free_info+0x37/0x70
[ 3528.461757]  poison_slab_object+0x109/0x180
[ 3528.461875]  __kasan_slab_free+0x2e/0x50
[ 3528.461988]  kmem_cache_free+0x17d/0x450
[ 3528.462108]  delayed_put_task_struct+0x16a/0x1f0
[ 3528.462226]  rcu_do_batch+0x368/0xd50
[ 3528.462342]  rcu_core+0x6d5/0xb60
[ 3528.462458]  handle_softirqs+0x1b4/0x770
[ 3528.462572]  __irq_exit_rcu+0xbb/0x1c0
[ 3528.462683]  irq_exit_rcu+0xa/0x30
[ 3528.462786]  sysvec_apic_timer_interrupt+0x9d/0xc0
[ 3528.462891]  asm_sysvec_apic_timer_interrupt+0x16/0x20

[ 3528.463095] Last potentially related work creation:
[ 3528.463198]  kasan_save_stack+0x1e/0x40
[ 3528.463305]  __kasan_record_aux_stack+0xad/0xc0
[ 3528.463411]  __call_rcu_common.constprop.0+0xae/0xe80
[ 3528.463519]  __schedule+0xfd8/0x5ee0
[ 3528.463622]  schedule_idle+0x52/0x80
[ 3528.463725]  do_idle+0x25e/0x3d0
[ 3528.463828]  cpu_startup_entry+0x50/0x60
[ 3528.463925]  start_secondary+0x201/0x280
[ 3528.464023]  common_startup_64+0x13e/0x141

[ 3528.464209] Second to last potentially related work creation:
[ 3528.464306]  kasan_save_stack+0x1e/0x40
[ 3528.464396]  __kasan_record_aux_stack+0xad/0xc0
[ 3528.464485]  task_work_add+0x1bd/0x270
[ 3528.464574]  sched_tick+0x2c0/0x9d0
[ 3528.464662]  update_process_times+0xd5/0x130
[ 3528.464753]  tick_nohz_handler+0x1ae/0x4a0
[ 3528.464839]  __hrtimer_run_queues+0x164/0x880
[ 3528.464923]  hrtimer_interrupt+0x2f1/0x7f0
[ 3528.465007]  __sysvec_apic_timer_interrupt+0xfd/0x3d0
[ 3528.465091]  sysvec_apic_timer_interrupt+0x98/0xc0
[ 3528.465173]  asm_sysvec_apic_timer_interrupt+0x16/0x20

[ 3528.465352] The buggy address belongs to the object at ffff88814a040000
                which belongs to the cache task_struct of size 13128
[ 3528.465457] The buggy address is located 52 bytes inside of
                freed 13128-byte region [ffff88814a040000, ffff88814a043348)

[ 3528.465629] The buggy address belongs to the physical page:
[ 3528.465712] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x14a040
[ 3528.465802] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[ 3528.465888] memcg:ffff88812c785601
[ 3528.465963] flags: 0x17ffffc0000040(head|node=0|zone=2|lastcpupid=0x1fffff)
[ 3528.466045] page_type: 0xfdffffff(slab)
[ 3528.466120] raw: 0017ffffc0000040 ffff8881002cea00 ffffea00041e4000 dead000000000004
[ 3528.466198] raw: 0000000000000000 0000000080020002 00000001fdffffff ffff88812c785601
[ 3528.466275] head: 0017ffffc0000040 ffff8881002cea00 ffffea00041e4000 dead000000000004
[ 3528.466351] head: 0000000000000000 0000000080020002 00000001fdffffff ffff88812c785601
[ 3528.466428] head: 0017ffffc0000003 ffffea0005281001 ffffffffffffffff 0000000000000000
[ 3528.466504] head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
[ 3528.466579] page dumped because: kasan: bad access detected

[ 3528.466717] Memory state around the buggy address:
[ 3528.466789]  ffff88814a03ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[ 3528.466860]  ffff88814a03ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[ 3528.466931] >ffff88814a040000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 3528.467001]                                      ^
[ 3528.467069]  ffff88814a040080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 3528.467135]  ffff88814a040100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 3528.467201] ==================================================================


