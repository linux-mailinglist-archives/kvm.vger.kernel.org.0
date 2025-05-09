Return-Path: <kvm+bounces-46029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB14AB0D2A
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E89C61BC5141
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB104274666;
	Fri,  9 May 2025 08:31:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C100270579;
	Fri,  9 May 2025 08:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746779518; cv=none; b=FcYJRol4Ml/CPvqKguKaTEUYjfmSl//RaiifXr0McthAC0Tg0YhfZLQ2Ov0h9vXY0R5IKzrhqCBpC8POsJyDQcE2h3KLC4GM0gQQBoFjQL6eSQnntaXOAFiHGBJ0/90t/wnLPgM1XOaxkNWW2Zr6j46TiNirjgeXYiVqU8VFdhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746779518; c=relaxed/simple;
	bh=gsoVVqQmM9OvLNkpR6lzFSQD4KysSKLNzbTXMNg3T5M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jZWQJ/NKzVkDNwO5vyFyeIp8fNr8AeUhaEHogx3+RI8ZP3Spn8vGBjKUCvVL2YpzeJ46rLvTdyFIgzaCqfMuMCu/3CC+NjJdHoDBo0jCgUbzPTE1JupHnRHEfFR63T9NBGoAr90x/NJSGVl8Uf17e5YbCjqDjGw4+15X9dSvVSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Zv2F56sdPzQkPv;
	Fri,  9 May 2025 16:27:53 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 65C861402CF;
	Fri,  9 May 2025 16:31:52 +0800 (CST)
Received: from huawei.com (10.67.174.76) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 9 May
 2025 16:31:51 +0800
From: Yuntao Liu <liuyuntao12@huawei.com>
To: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bpf@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <liuyuntao12@huawei.com>
Subject: [PATCH -next] kvm: x86: fix infinite loop in kvm_guest_time_update when tsc is 0
Date: Fri, 9 May 2025 08:19:34 +0000
Message-ID: <20250509081934.33874-1-liuyuntao12@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Syzkaller testing detected a soft lockup.

watchdog: BUG: soft lockup - CPU#3 stuck for 127s! [syz.1.2088:9817]
Modules linked in:
CPU: 3 PID: 9817 Comm: syz.1.2088 Tainted: G S                 6.6.0+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x8/0x20 kernel/kcov.c:313
Code: bf 03 00 00 00 e9 48 fe ff ff 0f 1f 84 00 00 00 00 00 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 0c 24 <89> f2 89
   fe bf 05 00 00 00 e9 1a fe ff ff 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffff888016d8fad8 EFLAGS: 00000206
RAX: 0000000000080000 RBX: ffff88810e242540 RCX: ffffffff901150d6
RDX: 0000000000080000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888016d8fb50 R08: 0000000000000001 R09: ffffed1021c484af
R10: 0000000000000000 R11: 0000000000000277 R12: 0000000000000000
R13: fffffed357281918 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f2a8f6ea6c0(0000) GS:ffff888119780000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000012c56c0 CR3: 000000000dce8001 CR4: 0000000000772ee0
DR0: 0000000000000000 DR1: 0000000000d3eb1c DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
PKRU: 80000000
Call Trace:
 <TASK>
 kvm_get_time_scale arch/x86/kvm/x86.c:2458 [inline]
 kvm_guest_time_update+0x926/0xb00 arch/x86/kvm/x86.c:3268
 vcpu_enter_guest.constprop.0+0x1e70/0x3cf0 arch/x86/kvm/x86.c:10678
 vcpu_run+0x129/0x8d0 arch/x86/kvm/x86.c:11126
 kvm_arch_vcpu_ioctl_run+0x37a/0x13d0 arch/x86/kvm/x86.c:11352
 kvm_vcpu_ioctl+0x56b/0xe60 virt/kvm/kvm_main.c:4188
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:871 [inline]
 __se_sys_ioctl+0x12d/0x190 fs/ioctl.c:857
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x59/0x110 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x78/0xe2

test case:
18.689865147s ago: executing program 1 (id=2088):
r0 = openat$kvm(0xffffffffffffff9c, &(0x7f0000002080), 0x0, 0x0)
r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
r2 = ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0)
ioctl$KVM_RUN(r2, 0xae80, 0x0)
ioctl$KVM_SET_TSC_KHZ(r2, 0xaea2, 0x1)
socket$nl_route(0x10, 0x3, 0x0)
r3 = socket$igmp(0x2, 0x3, 0x2)
ioctl$sock_SIOCGIFINDEX(r3, 0x8933, &(0x7f00000001c0)={'netdevsim0\x00',
<r4=>0x0})
r5 = bpf$MAP_CREATE(0x0, &(0x7f0000000140)=@base={0x1, 0x4, 0x8000, 0x2,
0x0, 0xffffffffffffffff, 0x0, '\x00', r4, 0xffffffffffffffff, 0x0, 0x0,
0x0, 0x0, @void, @value, @void, @value}, 0x50)
bpf$MAP_UPDATE_CONST_STR(0x2, &(0x7f0000000100)={{r5},
&(0x7f0000000000), &(0x7f0000000040)='%ps    \x00'}, 0x20)
bpf$MAP_DELETE_ELEM(0x3, &(0x7f00000000c0)={r5, &(0x7f0000001480)},
0x20)
ioctl$KVM_SET_USER_MEMORY_REGION(r1, 0x4020ae46,
&(0x7f0000000000)={0x1ff, 0x3, 0x3000, 0x1000,
&(0x7f0000fec000/0x1000)=nil})
syz_kvm_setup_cpu$x86(r1, 0xffffffffffffffff,
&(0x7f0000fe8000/0x18000)=nil, &(0x7f0000000100)=[@textreal={0x8, 0x0}],
0x1, 0x0, 0x0, 0x0)
ioctl$KVM_SET_USER_MEMORY_REGION(0xffffffffffffffff, 0x4020ae46, 0x0)
openat$ipvs(0xffffffffffffff9c, 0x0, 0x2, 0x0)
syz_kvm_setup_cpu$x86(0xffffffffffffffff, r2,
&(0x7f0000fe8000/0x18000)=nil, &(0x7f00000000c0)=[@text64={0x40,
&(0x7f0000000040)="26f2a70f3548b807000000000000000f23c00f21f835020008000f23f80fc73eb9330800000f326666470f3880be6cc468550f01cf360f01f80f30450f01c9",
0x3f}], 0x1, 0x0, 0x0, 0x0)
ioctl$KVM_RUN(r2, 0xae80, 0x0)

ioctl$KVM_SET_TSC_KHZ(r2, 0xaea2, 0x1)
user_tsc_khz = 0x1
	|
kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
	|
	ioctl$KVM_RUN(r2, 0xae80, 0x0)
		|
		...
	kvm_guest_time_update(struct kvm_vcpu *v)
		|
		if (kvm_caps.has_tsc_control)
			tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
					    v->arch.l1_tsc_scaling_ratio);
			|
			kvm_scale_tsc(u64 tsc, u64 ratio)
			|
			__scale_tsc(u64 ratio, u64 tsc)
			ratio=122380531, tsc=2299998, N=48
			ratio*tsc >> N = 0.999... -> 0
			|
		kvm_get_time_scale

In function __scale_tsc, it uses fixed point number to calculate
tsc, therefore, a certain degree of precision is lost, the actual tsc
value of 0.999... would be 0. In function kvm_get_time_scale
tps32=tps64=base_hz=0, would lead second while_loop infinite. when
CONFIG_PREEMPT is n, it causes a soft lockup issue.

Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b011a9d0c82d..7a3633c069f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2531,10 +2531,12 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
  * point number (mult + frac * 2^(-N)).
  *
  * N equals to kvm_caps.tsc_scaling_ratio_frac_bits.
+ *
+ * add 1 to compensate for precision loss.
  */
 static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 {
-	return mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
+	return mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits) + 1;
 }
 
 u64 kvm_scale_tsc(u64 tsc, u64 ratio)
-- 
2.34.1


