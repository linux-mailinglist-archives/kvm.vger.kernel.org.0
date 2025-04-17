Return-Path: <kvm+bounces-43564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 112AFA91B97
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF33D1892E16
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969BC23FC49;
	Thu, 17 Apr 2025 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHatTKY9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFC123F40C
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744891627; cv=none; b=OVdh0+XuBgM/J5PACVkEVqd4sjtK8fl66XUXShK0W83AYM1dlbJ0IkidO37bxvPxJjP6DsyZV1RfgpmPX/6bwU7wII8QzA7lxW/R5mAB76N2fF/xy8mm9AnV6Ep7C2B9bEeVXX7m7T/r02ra3xyHwa7LMbxynJEH8J4QHk9jgFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744891627; c=relaxed/simple;
	bh=HfH3B/AbhXuNvTdiUGOWBy7cqi8xsk6DOeZQsegDd0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLxGcyHHcxSGXtY/D8DcTeH4v4MycKO+BUXeImG/sdi8kOHSrlZL1UPtCeaW0owj/nh7gh+r4SxnUQ16bfH2o7AGSqs7jabVZRgK0dCPz85BEGYBqXUcQAjdrD72DJXnwhuorLy6Uhqcqaumla5NB4MLliXBN/ibtbIx3aFSs3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHatTKY9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C30C4CEE4;
	Thu, 17 Apr 2025 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744891627;
	bh=HfH3B/AbhXuNvTdiUGOWBy7cqi8xsk6DOeZQsegDd0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lHatTKY9kVV6xeYdcBs49I3lnM1oRvmhnf1Gg+kXPJc4k6sr/1Xvz/3PAfQ8Pi7s7
	 mYE3rC8au9YIUdyIHePbtqAGzogROotsgXuHZ2us6CPuS6MTFW9AD2V+5KVcxTHBUi
	 nA7uOcvumSUsYxEYHwbSnf94K6BABb/QNX2vxfBkIpCZk+eZo8Ekgk56F+scoGFlYr
	 iwT/yFiAx5PBjjkfr7ct38wyMEvq4dkLi0lngaQ+/W7mr28BD0cy4xD8B68sD1jjaI
	 rvOl6WCnhYgshM0QAfIc+qSz8nS6jbid8yZNBuZxyaiWf0pNTvGaDA58Xi13wCSOqx
	 Tz5Fp4KchCiVQ==
Date: Thu, 17 Apr 2025 13:07:02 +0100
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v2 1/2] cpu: vmexit: Handle KVM_EXIT_UNKNOWN exit
 reason correctly
Message-ID: <20250417120701.GA12773@willie-the-truck>
References: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224091000.3925918-1-aneesh.kumar@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 24, 2025 at 02:39:59PM +0530, Aneesh Kumar K.V (Arm) wrote:
> The return value for kernel VM exit handlers is confusing and has led to
> errors in different kernel exit handlers. A return value of 0 indicates
> a return to the VMM, whereas a return value of 1 indicates resuming
> execution in the guest. Some handlers mistakenly return 0 to force a
> return to the guest.
> 
> This worked in kvmtool because the exit_reason defaulted to
> 0 (KVM_EXIT_UNKNOWN), and kvmtool did not error out on an unknown exit
> reason. However, forcing a VMM exit with error on KVM_EXIT_UNKNOWN
> exit_reson would help catch these bugs early.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  kvm-cpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kvm-cpu.c b/kvm-cpu.c
> index f66dcd07220c..7c62bfc56679 100644
> --- a/kvm-cpu.c
> +++ b/kvm-cpu.c
> @@ -170,7 +170,7 @@ int kvm_cpu__start(struct kvm_cpu *cpu)
>  
>  		switch (cpu->kvm_run->exit_reason) {
>  		case KVM_EXIT_UNKNOWN:
> -			break;
> +			goto panic_kvm;
>  		case KVM_EXIT_DEBUG:
>  			kvm_cpu__show_registers(cpu);
>  			kvm_cpu__show_code(cpu);
> -- 
> 2.43.0

This breaks SMP boot on my x86 machine:

# ./lkvm run
...
[    0.628472] smp: Bringing up secondary CPUs ...
[    0.630401] smpboot: x86: Booting SMP configuration:
  Error: KVM exit reason: 0 ("KVM_EXIT_UNKNOWN")
  Error: KVM exit code: 0

 Registers:
 ----------
 rip: 0000000000000000   rsp: 0000000000000000 flags: 0000000000000002
 rax: 0000000000000000   rbx: 0000000000000000   rcx: 0000000000000000
 rdx: 0000000000050654   rsi: 0000000000000000   rdi: 0000000000000000
 rbp: 0000000000000000    r8: 0000000000000000    r9: 0000000000000000
 r10: 0000000000000000   r11: 0000000000000000   r12: 0000000000000000
 r13: 0000000000000000   r14: 0000000000000000   r15: 0000000000000000
 cr0: 0000000060000010   cr2: 0000000000000000   cr3: 0000000000000000
 cr4: 0000000000000000   cr8: 0000000000000000

 Segment registers:
 ------------------
 register  selector  base              limit     type  p dpl db s l g avl
 cs        9900      0000000000099000  0000ffff  0b    1 0   0  1 0 0 0
 ss        0000      0000000000000000  0000ffff  03    1 0   0  1 0 0 0
 ds        0000      0000000000000000  0000ffff  03    1 0   0  1 0 0 0
 es        0000      0000000000000000  0000ffff  03    1 0   0  1 0 0 0
 fs        0000      0000000000000000  0000ffff  03    1 0   0  1 0 0 0
 gs        0000      0000000000000000  0000ffff  03    1 0   0  1 0 0 0
 tr        0000      0000000000000000  0000ffff  0b    1 0   0  0 0 0 0
 ldt       0000      0000000000000000  0000ffff  02    1 0   0  0 0 0 0
 gdt                 0000000000000000  0000ffff
 idt                 0000000000000000  0000ffff

 APIC:
 -----
 efer: 0000000000000000  apic base: 00000000fee00800  nmi: enabled

 Interrupt bitmap:
 -----------------
 0000000000000000 0000000000000000 0000000000000000 0000000000000000

 Code:
 -----
Warning: symbol_lookup() failed to find symbol with error: -2
 rip: [<0000000000000000>] <unknown>

 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <fa> 0f 09 ea 08 10 00 98 8c c8 8e d8 8e c0 8e d0 66 f0 0f ba 2e

 Stack:
 ------
 rsp: [<0000000000000000>]
 0x00000000: 30 00 00 f0  30 00 00 f0
 0x00000008: 30 00 00 f0  30 00 00 f0
 0x00000010: 30 00 00 f0  30 00 00 f0
 0x00000018: 30 00 00 f0  30 00 00 f0

 Page Tables:
 ------
 Not in protected mode


