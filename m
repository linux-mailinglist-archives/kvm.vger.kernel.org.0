Return-Path: <kvm+bounces-27769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6359498BB4E
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1743828136B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ABE1C2DD8;
	Tue,  1 Oct 2024 11:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cuJGJWOv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A21C2DB4;
	Tue,  1 Oct 2024 11:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727782519; cv=none; b=jhXHHLDPqX42apaTBhTw2euLBWAgBRgZ1nSDiPJrVesiiFr0Nx/dvJW6ZwR5KcVup/efUY4rClMaM3B43FKDpidveMBm4BZMkecD1WC69BPHDHRRAMI1f0qv9wYNcuVHN+KydljYvvGcoPXbyTRklNHl+ZeOPrTxqhsJ5o5uNLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727782519; c=relaxed/simple;
	bh=PLCfu9k2nrqK0Q23eCcS61S+UCWbhfJU+ryvhWPppaw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=XEnwf7GE990+Dgh9MMxbPC8QJXo3a71TxfhGXu4FnhUah6VEhmQz1c01ywD+DnWLXcchFJsNRn1Zs2Tfy1x8jiWoD2DpftTU3Bks4jS5gy8AFzmXyAgRttaTLPtLUYSSLaOtBhFWWzgzMjM60M3+2sMOA5+gCYH+tFETq3Y1tvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cuJGJWOv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A215C4CEC6;
	Tue,  1 Oct 2024 11:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727782518;
	bh=PLCfu9k2nrqK0Q23eCcS61S+UCWbhfJU+ryvhWPppaw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cuJGJWOvGtuy95w2CKuaTFpyUid4icwEMHtbAyOEd1SBP7T3ALRPCsctRnLg3yM8P
	 iCZnl1sN6HzCcahiMymrWhb6zvpjtn7kRTI+CEEV5vNHlGUFG1me+IkGsZZJ/pHaJM
	 VmW8I3FPpnoErlyQS4+CXDVl3LkmEFfG2MCQMArLnI4/li4dHOUOlcc7imoBT2gMw6
	 oeosrCrdIEuuAvU11L9j7ri8ih2y/RK4DYUiRqpW0QCgDOrVZht/FuuI59+fG+q7aM
	 ifEpF9KFVK6ZA11o0c44kU2gjmaVelyl8SG9/cc1ct5ubuW+ARJ2BsAyno5maDgk75
	 yyroMfbYk1HfQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE0F2380DBF7;
	Tue,  1 Oct 2024 11:35:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] RISC-V: KVM: Don't zero-out PMU snapshot area before freeing
 data
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <172778252124.314421.2392376531840304330.git-patchwork-notify@kernel.org>
Date: Tue, 01 Oct 2024 11:35:21 +0000
References: <20240815170907.2792229-1-apatel@ventanamicro.com>
In-Reply-To: <20240815170907.2792229-1-apatel@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: linux-riscv@lists.infradead.org, palmer@dabbelt.com,
 paul.walmsley@sifive.com, atishp@atishpatra.org, ajones@ventanamicro.com,
 anup@brainfault.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Thu, 15 Aug 2024 22:39:07 +0530 you wrote:
> With the latest Linux-6.11-rc3, the below NULL pointer crash is observed
> when SBI PMU snapshot is enabled for the guest and the guest is forcefully
> powered-off.
> 
>   Unable to handle kernel NULL pointer dereference at virtual address 0000000000000508
>   Oops [#1]
>   Modules linked in: kvm
>   CPU: 0 UID: 0 PID: 61 Comm: term-poll Not tainted 6.11.0-rc3-00018-g44d7178dd77a #3
>   Hardware name: riscv-virtio,qemu (DT)
>   epc : __kvm_write_guest_page+0x94/0xa6 [kvm]
>    ra : __kvm_write_guest_page+0x54/0xa6 [kvm]
>   epc : ffffffff01590e98 ra : ffffffff01590e58 sp : ffff8f80001f39b0
>    gp : ffffffff81512a60 tp : ffffaf80024872c0 t0 : ffffaf800247e000
>    t1 : 00000000000007e0 t2 : 0000000000000000 s0 : ffff8f80001f39f0
>    s1 : 00007fff89ac4000 a0 : ffffffff015dd7e8 a1 : 0000000000000086
>    a2 : 0000000000000000 a3 : ffffaf8000000000 a4 : ffffaf80024882c0
>    a5 : 0000000000000000 a6 : ffffaf800328d780 a7 : 00000000000001cc
>    s2 : ffffaf800197bd00 s3 : 00000000000828c4 s4 : ffffaf800248c000
>    s5 : ffffaf800247d000 s6 : 0000000000001000 s7 : 0000000000001000
>    s8 : 0000000000000000 s9 : 00007fff861fd500 s10: 0000000000000001
>    s11: 0000000000800000 t3 : 00000000000004d3 t4 : 00000000000004d3
>    t5 : ffffffff814126e0 t6 : ffffffff81412700
>   status: 0000000200000120 badaddr: 0000000000000508 cause: 000000000000000d
>   [<ffffffff01590e98>] __kvm_write_guest_page+0x94/0xa6 [kvm]
>   [<ffffffff015943a6>] kvm_vcpu_write_guest+0x56/0x90 [kvm]
>   [<ffffffff015a175c>] kvm_pmu_clear_snapshot_area+0x42/0x7e [kvm]
>   [<ffffffff015a1972>] kvm_riscv_vcpu_pmu_deinit.part.0+0xe0/0x14e [kvm]
>   [<ffffffff015a2ad0>] kvm_riscv_vcpu_pmu_deinit+0x1a/0x24 [kvm]
>   [<ffffffff0159b344>] kvm_arch_vcpu_destroy+0x28/0x4c [kvm]
>   [<ffffffff0158e420>] kvm_destroy_vcpus+0x5a/0xda [kvm]
>   [<ffffffff0159930c>] kvm_arch_destroy_vm+0x14/0x28 [kvm]
>   [<ffffffff01593260>] kvm_destroy_vm+0x168/0x2a0 [kvm]
>   [<ffffffff015933d4>] kvm_put_kvm+0x3c/0x58 [kvm]
>   [<ffffffff01593412>] kvm_vm_release+0x22/0x2e [kvm]
> 
> [...]

Here is the summary with links:
  - RISC-V: KVM: Don't zero-out PMU snapshot area before freeing data
    https://git.kernel.org/riscv/c/47d40d93292d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



