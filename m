Return-Path: <kvm+bounces-34355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA30A9FBE9D
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 14:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39B75188C235
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 13:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8BF61D9329;
	Tue, 24 Dec 2024 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="VLtYo3hm"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4746838F91;
	Tue, 24 Dec 2024 13:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735045886; cv=none; b=q6VYbfY+1PsXoHod1+72vVfnu4552GcQL9oisEe9jXGSBRsQF8r6I+F1nY5SGdzJmT4lfymgQQxih/Fzq7VtcLzz1uCx6QtPh1Qbopq+x1NuIa+WyRxPGHTvZb0Ogpo+cnJirAZRwE2GeGLdNsFvEziGlpICDzRBF9HNZRN6IaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735045886; c=relaxed/simple;
	bh=S3dza6LGiDd+B9kHi0kU6e6794JBIJkBOMg+YvzrIqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YMINd/eMeJBPyVOtqMoMd8BYKe9XxRASInabwp6gsedhRUe0qGp5yIL/NAQvvA5DpaETveBoaIG/Vkbk4z2tsf5J8ndmpMe+J6UqNpIM+t3koqeDscSTtf/dfiZB0BYrBw8Idqp0i8mZ2sE4xny6KBrjIdreu/1hJPZBPX7AUec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=VLtYo3hm; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=Bo+/k
	jUvBYmRPEpZsbOJzmmFcXBQIxwA1XmmVxjrpTg=; b=VLtYo3hmsK4E7fHRpzNUl
	yKh2/DJEnghjuItK0jnzGLod2pdlVdwx4YlDPCznXCVCVH/8Mj7deNhxG3e4O87C
	3BjM8bKU58agMJ8UCVEEWaqxgR+zUS7FxerooxRauc8MYn9CTITxTqWDzxHSa5ZS
	NawZlkxxOV9bSn9UvN7JvE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDX16y8smpnX4B5BQ--.21884S2;
	Tue, 24 Dec 2024 21:10:22 +0800 (CST)
From: Jinyu Tang <tjytimi@163.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Will Deacon <will@kernel.org>,
	Anup Patel <apatel@ventanamicro.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinyu Tang <tjytimi@163.com>
Subject: [PATCH RFC] x86: avoid one cpu limit for kvm
Date: Tue, 24 Dec 2024 21:09:52 +0800
Message-ID: <20241224130952.112584-1-tjytimi@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX16y8smpnX4B5BQ--.21884S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF1fZFyxKw1kWr15tw1rtFb_yoW8Xw48pr
	WIk395KF1UXF9Iya4UJFWxCrWj9rs7C34xKa1DuayUJa15Ar18XF1vqrySvFyjgrWrZ34f
	trW5KF4Fvr10y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piX_-PUUUUU=
X-CM-SenderInfo: xwm13xlpl6il2tof0z/1tbiTQu-eGdqZSnG1AABsT

I run kernel by kvmtool but only one cpu can start in guset now, 
because kvm use virt-ioapic and kvmtool set noapic cmdline for 
x86 to disable ioapic route in kernel, and the latest cpu topo 
code below makes cpu limitted just to one.

For x86 kvm, noapic cmdline is reasonable, virt-ioapic don't
need to init hardware ioapic, so change it for x86 kvm guest to
avoid one num limit.

Signed-off-by: Jinyu Tang <tjytimi@163.com>
---
 arch/x86/kernel/cpu/topology.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 621a151ccf7d..a73847b1a841 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -429,7 +429,9 @@ void __init topology_apply_cmdline_limits_early(void)
 	unsigned int possible = nr_cpu_ids;
 
 	/* 'maxcpus=0' 'nosmp' 'nolapic' 'disableapic' 'noapic' */
-	if (!setup_max_cpus || ioapic_is_disabled || apic_is_disabled)
+	if (!setup_max_cpus ||
+		(ioapic_is_disabled && (x86_hyper_type != X86_HYPER_KVM)) ||
+		apic_is_disabled)
 		possible = 1;
 
 	/* 'possible_cpus=N' */
@@ -443,8 +445,10 @@ void __init topology_apply_cmdline_limits_early(void)
 
 static __init bool restrict_to_up(void)
 {
-	if (!smp_found_config || ioapic_is_disabled)
+	if (!smp_found_config ||
+		(ioapic_is_disabled && (x86_hyper_type != X86_HYPER_KVM)))
 		return true;
+
 	/*
 	 * XEN PV is special as it does not advertise the local APIC
 	 * properly, but provides a fake topology for it so that the
-- 
2.43.0


