Return-Path: <kvm+bounces-46425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A87AB63B0
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95A044A17C9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B16520A5E1;
	Wed, 14 May 2025 07:02:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C67E20297F;
	Wed, 14 May 2025 07:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747206130; cv=none; b=uVRXXjcVXdHFcjQRyIbnv3eDWuSwkoFbeShKw0bTPipE6mL12cyWyhsNgsh6G2qfwRQdWpa73+csiz0VFqKjOfXlcxnTxYLkPS7igdsRQ+HesSLE62sjQ9BeZXEAX0TlMQraNahPnmWm2tajVfnRBEFmuRq2ge6f99IBbndpjZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747206130; c=relaxed/simple;
	bh=vs5b+EHYKYPsWMhmT/qyRr8Xjgec3HQB2Fry1oY6b54=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HVmsXnteJ9fLxE0i9MHjO/r6SCxuw2gfwhSQ9R6k7O85t1mtH9zciYsIPYvlZDIrX2e4V+oxcyvglpU1YJ4MlwOKCuC06Xs1Rm0zjhBLx+/BYSJCdGK0R+rb9EWVZDHNKyAPv+zTbG21/HXy/mmNnlhFtAudyx4B+xnsnf1LBSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zy40p0dS2zyVKc;
	Wed, 14 May 2025 14:57:46 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 87E68140155;
	Wed, 14 May 2025 15:02:04 +0800 (CST)
Received: from huawei.com (10.67.174.76) by kwepemg500010.china.huawei.com
 (7.202.181.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 14 May
 2025 15:02:03 +0800
From: Yuntao Liu <liuyuntao12@huawei.com>
To: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bpf@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <liuyuntao12@huawei.com>
Subject: [PATCH] kvm: x86: fix infinite loop in kvm_guest_time_update when tsc is 0
Date: Wed, 14 May 2025 06:49:41 +0000
Message-ID: <20250514064941.51609-1-liuyuntao12@huawei.com>
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

Fixes: 35181e86df97 ("KVM: x86: Add a common TSC scaling function")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1fa5d89f8d27..3e9d6f368eed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2605,10 +2605,14 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
  * point number (mult + frac * 2^(-N)).
  *
  * N equals to kvm_caps.tsc_scaling_ratio_frac_bits.
+ *
+ * return 1 if _tsc is 0.
  */
 static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 {
-	return mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
+	u64 _tsc = mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
+
+	return  !_tsc ? 1 : _tsc;
 }
 
 u64 kvm_scale_tsc(u64 tsc, u64 ratio)
-- 
2.34.1


