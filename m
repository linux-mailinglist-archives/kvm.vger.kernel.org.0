Return-Path: <kvm+bounces-57569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 812CAB57AD5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9D7A3AAE11
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBABE30C347;
	Mon, 15 Sep 2025 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="chg9d1BB"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1D430ACEE;
	Mon, 15 Sep 2025 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757939083; cv=none; b=d2AvIQ2q/yrx7TIqYDBKqVS2nleG582HBg83LfCZTDwHhX6LLogzTqAopDufrVXgYASgar4MvFDG4P/j91SLe7F1BadtIaA4OLxU5WsPWDRA89N+NMa9C1gtitK56EeZxqDBws/yIdFJy10WskCr/+0wwdeLTKfgjhp4C2zCgXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757939083; c=relaxed/simple;
	bh=XNZL1+d+Qc/BZHek/35MEzGZGMUx6EA9t85VdCwsxeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nwidC6ABESU3zFO/I+agwQOJzJH3S5Bl4EwKBw1mZaPJDUy5G31DHIxW0Erw/hMvD8T5Su0n204cGrAJz39QSSPDvXaSADHv4USM05zif/zZM94wAn99H74KyHHRNXWUercYhhtr8YBXYRXkmj2lq/wSzSJrILp//YVcGtTjKCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=chg9d1BB; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=sj
	SqrG5JGVjvm9XZFoJOiIfn6ve0j4UMsIKI6ctHudQ=; b=chg9d1BBpnn4ZrjdV0
	WUky7UkIjXQoZESll/Y9skCu57lKq2VeA7G9TP4OzH6PxFJcCYj17HL7//VfXddT
	hsemxghAV/vPoq5xTGyI4Zh7SwX4qKS8d5BF218UGMM2q7j89pffcYPEG8qMCHVe
	G0ex2BOTUbyGgAIDZ8xWbDF/A=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3_2xJBchoOwBzBQ--.20956S2;
	Mon, 15 Sep 2025 20:23:39 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Tianshun Sun <stsmail163@163.com>
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH] KVM: riscv: Power on secondary vCPUs from migration
Date: Mon, 15 Sep 2025 20:23:34 +0800
Message-ID: <20250915122334.1351865-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_2xJBchoOwBzBQ--.20956S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tryDXF1UtryxXF4UXw48Xrb_yoW8CrWUpF
	4jkrZY9395JFW7Gw4qyw4kuF4YyFsYg3WaqryDZryjyr4Ygw10yr4kKayjyF95Xrs5Zwna
	vF4YyFy8Crn0ya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiTgTJeGjH+nKkeQABsA

The current logic keeps all secondary VCPUs powered off on their
first run in kvm_arch_vcpu_postcreate(), relying on the boot VCPU 
to wake them up by sbi call. This is correct for a fresh VM start,
where VCPUs begin execution at the bootaddress (0x80000000).

However, this behavior is not suitable for VCPUs that are being
restored from a state (e.g., during migration resume or snapshot
load). These VCPUs have a saved program counter (sepc). Forcing
them to wait for a wake-up from the boot VCPU, which may not
happen or may happen incorrectly, leaves them in a stuck state
when using Qemu to migration if smp is larger than one.

So check a cold start and a warm resumption by the value of the 
guest's sepc register. If the VCPU is running for the first time 
*and* its sepc is not the hardware boot address, it indicates a 
resumed vCPU that must be powered on immediately to continue 
execution from its saved context.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
Tested-by: Tianshun Sun <stsmail163@163.com>
---
 arch/riscv/kvm/vcpu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 3ebcfffaa..86aeba886 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -867,8 +867,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_trap trap;
 	struct kvm_run *run = vcpu->run;
 
-	if (!vcpu->arch.ran_atleast_once)
+	if (!vcpu->arch.ran_atleast_once) {
 		kvm_riscv_vcpu_setup_config(vcpu);
+		/*
+		 * For VCPUs that are resuming (e.g., from migration)
+		 * and not starting from the boot address, explicitly
+		 * power them on.
+		 */
+		if (vcpu->arch.guest_context.sepc != 0x80000000)
+			kvm_riscv_vcpu_power_on(vcpu);
+	}
 
 	/* Mark this VCPU ran at least once */
 	vcpu->arch.ran_atleast_once = true;
-- 
2.43.0


