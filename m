Return-Path: <kvm+bounces-62996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0EBCC56B94
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 10:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ED963B5F6B
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 09:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 487EA2DECD4;
	Thu, 13 Nov 2025 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GDT0A4U1"
X-Original-To: kvm@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856CF1F5EA
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 09:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763027555; cv=none; b=Rxz8EBfRyw28idJumXiP7K+t9Ai18Y5VO6rO+ms+ky64e3ZYka64uUXMl+7WyXKR4bNC0tuudREBE9QgekByQssNZcO3aY+g4jivhyfNGLGKDoTK1QBtLdD2I00G04kqJumwrEgxCSt+/rlZz8tWADvrYYYON9m+ibXFOHaNENg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763027555; c=relaxed/simple;
	bh=LtwLoeQvlFvnsXwpiVOm16Foi8ohrVNxX7fhb9E9s+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=qKPQntTRP1+cTTcBMoOq6RRc+kB4qbBRhRWFrT22KK9yT79oocHL1rZj7gS/l1oErIP8yEF4qcIGvg2L6dNO/C+zihuouZ2tqr59tKNx6hDN3It9Fc/VGr7w35SBc8Jado2gI6+pOWBoxQa1+3wEVVFCX7gwq5fXTzEAvVhtVpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=GDT0A4U1; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20251113095226euoutp01c3cd2f0378457e7e5008012f2b1f0691~3iDZTXdyZ1785817858euoutp01f
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 09:52:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20251113095226euoutp01c3cd2f0378457e7e5008012f2b1f0691~3iDZTXdyZ1785817858euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763027546;
	bh=DfH0s4PJ2lNDp9KjHR2xRGPvl8kyzS0lqJ/ga3aU49k=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=GDT0A4U1bXuTjMEFII1R2qESkSv0qOeA7R+lYzGz2ZHQdtJ0gG3x3sleKF+Azw1Ow
	 tWcr0Rp+NKZncfSDVhbg5C4VYG/kmefbO9XfoPn5/qIXkNP8nh4bitz1GXtp29HUWU
	 TLh1aSi9EPrg+yyvty43DP8uwlPzHnnpgoaQ7NCk=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c~3iDY3I0Qy2231922319eucas1p21;
	Thu, 13 Nov 2025 09:52:25 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251113095224eusmtip11cf3bf4e737456b0cc65926c596b0dac~3iDXpGtVx1837718377eusmtip1b;
	Thu, 13 Nov 2025 09:52:23 +0000 (GMT)
Message-ID: <b618732b-fd26-49e0-84c5-bfd54be09cd2@samsung.com>
Date: Thu, 13 Nov 2025 10:52:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 04/45] KVM: arm64: Turn vgic-v3 errata traps into a
 patched-in constant
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, Zenghui Yu
	<yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>, Yao Yuan
	<yaoyuan@linux.alibaba.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20251109171619.1507205-5-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c
X-EPHeader: CA
X-CMS-RootMailID: 20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c
References: <20251109171619.1507205-1-maz@kernel.org>
	<20251109171619.1507205-5-maz@kernel.org>
	<CGME20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c@eucas1p2.samsung.com>

On 09.11.2025 18:15, Marc Zyngier wrote:
> The trap bits are currently only set to manage CPU errata. However,
> we are about to make use of them for purposes beyond beating broken
> CPUs into submission.
>
> For this purpose, turn these errata-driven bits into a patched-in
> constant that is merged with the KVM-driven value at the point of
> programming the ICH_HCR_EL2 register, rather than being directly
> stored with with the shadow value..
>
> This allows the KVM code to distinguish between a trap being handled
> for the purpose of an erratum workaround, or for KVM's own need.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

This patch landed in today's linux-next as commit ca30799f7c2d ("KVM: 
arm64: Turn vgic-v3 errata traps into a patched-in constant"). In my 
tests I found that it triggers oops and breaks booting on Raspberry Pi5 
and Amlogic SM1 based boards: Odroid-C4 and Khadas VIM3l. Here is the 
failure log:

alternatives: applying system-wide alternatives
Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 18 Comm: migration/0 Not tainted 6.18.0-rc3+ #11665 
PREEMPT
Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
Stopper: multi_cpu_stop+0x0/0x178 <- __stop_cpus.constprop.0+0x7c/0xc8
pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : vgic_v3_broken_seis+0x14/0x44
lr : kvm_compute_ich_hcr_trap_bits+0x48/0xd8
...
Call trace:
  vgic_v3_broken_seis+0x14/0x44 (P)
  __apply_alternatives+0x1b4/0x200
  __apply_alternatives_multi_stop+0xac/0xc8
  multi_cpu_stop+0x90/0x178
  cpu_stopper_thread+0x8c/0x11c
  smpboot_thread_fn+0x160/0x32c
  kthread+0x150/0x228
  ret_from_fork+0x10/0x20
Code: 52800000 f100203f 54000040 d65f03c0 (d53ccb21)
---[ end trace 0000000000000000 ]---
note: migration/0[18] exited with irqs disabled
note: migration/0[18] exited with preempt_count 1
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:     1-...0: (7 ticks this GP) idle=0124/1/0x4000000000000000 
softirq=9/10 fqs=3250
rcu:     2-...0: (7 ticks this GP) idle=0154/1/0x4000000000000000 
softirq=9/10 fqs=3250
rcu:     3-...0: (7 ticks this GP) idle=018c/1/0x4000000000000000 
softirq=9/10 fqs=3250
rcu:     (detected by 0, t=6502 jiffies, g=-1179, q=2 ncpus=4)
Sending NMI from CPU 0 to CPUs 1:
Sending NMI from CPU 0 to CPUs 2:
Sending NMI from CPU 0 to CPUs 3:

Let me know how I can help in debugging this issue.


> ---
>   arch/arm64/kernel/image-vars.h       |  1 +
>   arch/arm64/kvm/hyp/vgic-v3-sr.c      | 21 +++++---
>   arch/arm64/kvm/vgic/vgic-v3-nested.c |  9 ----
>   arch/arm64/kvm/vgic/vgic-v3.c        | 81 +++++++++++++++++-----------
>   arch/arm64/kvm/vgic/vgic.h           | 16 ++++++
>   5 files changed, 82 insertions(+), 46 deletions(-)
>
> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


