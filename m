Return-Path: <kvm+bounces-22061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DECC5939247
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 18:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DFF8B2155B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2024 16:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E31C16EB56;
	Mon, 22 Jul 2024 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PIV3CdW7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E30F16DC18
	for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721664512; cv=none; b=hRGxKVnZDR7dRsO7k3SExIgXQ4IEEZOt3SXI77pQhKv9l4tSQ2RXAayAfXrExJUBGl6OrHBX0vFwB/vLQkJTpzzq6Vn2C2sCnd7ry53OIj1t4v8XWNk+ddOhp20yNXo10/1dmlmLZWkvXiorrQyq+EU4PFzpS1iCUdJsvYtXbUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721664512; c=relaxed/simple;
	bh=5DrGW5y3s1MDwA4zyVvy5rjfh71EWIwldHEYpJTmY7I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nojTNuT8NphBQqP3qwVftpibUC3T7+it3JJ8wN8X4bs4ZOWIBiOZkvi6I90lPap8l7OBmoxbfLmMCQbwC0RFfAPb8FoGrt5WlYqoOJQ3K2F7rARUiPRFzJ/wfEqmw5557zXUA7IoEUtxvns2vtty7rGFlyet4DdcOQ62H9kEOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PIV3CdW7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a1914d0936so817423a12.3
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2024 09:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721664509; x=1722269309; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SHjA12uUy2t4HmbYb9TqFAgcCYS18JQb0D5l20oqKLQ=;
        b=PIV3CdW7QyNezxaynfOt0MhKXKzOqaHdV7OgA11hbz/9boPOJ5gl289UuF4xIH2xQx
         XL3gdcjNg9mYEBAUHsveEJq4lJtFTiBWgfCzXWPswV0KJD70eeYDFtWMo28NMRycX/V5
         45Ps1NAc/roa7rSicb6as4sNB+uNDd/x0eolFXwzrjXcKalz5Rgcv9nNoN1Xk8Jq2uR4
         zQSXYR+wRkLSLdw5UES8CEZpCJdM04NwRGTpinnBFO71Ii8wh2orsLvqsU00XIJSnh8n
         VgBfAtmxv7S19Oev75ellClPopfDZD81Rp4WUSZLlYdF2+29dGdXkF2KIhSvS6bBvekn
         Wgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721664509; x=1722269309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SHjA12uUy2t4HmbYb9TqFAgcCYS18JQb0D5l20oqKLQ=;
        b=dRdX7hQ3QhIxjoB/pio8o4LnJYcmzBkjZnoyFtcGI1H82RFnUnwyHu/Qi1ttPOQ5iH
         OGFHSNpSiki4Uerg2uFz3q3GcS0+bq8bBBG4+32Xccg50dbb+hNfycFZ8gaHpvypHLJP
         Femi4v7UQz8ER+TeGCnEGMEpXP8AkHAWXy2H9j9Rv6MLFeb54om3FeWwqD6gpi//HBc/
         vj8p39TIkMBbyg7/ni1K2932QpZcgk2EcyzoTR1xQI8zv4BfOyeIGgbdJYbNBDOBpJZH
         ZXjbv9wUFjCD4gmRgG2s9yjwrA3ccLDzGaUS+HI8xJkTfZ3AipT0ebtUa4pdciCB7uAY
         hPlw==
X-Forwarded-Encrypted: i=1; AJvYcCXSSjfdKOCK9307YH4K7IDvDF0icy/FETgZWV/UF/IKo31S5+hrTfusfAddK4iEQGJQJ8OMgdDodrmWqPLR02oEY6CN
X-Gm-Message-State: AOJu0YzHdFyj3U7C5EoZXPYLJjHyW4JM6JTaBm90XVFNqmYgO4LbX+WY
	j1SY2qjV6KZvf4Q1ooA4OUAeh/uKdM8dcPQR+O9/RIWnHs+APe7dY6AgIPDKY8QU52bYtN3hU+X
	o2w==
X-Google-Smtp-Source: AGHT+IFn3IjX6LNFU/HOyilDC5Bp05oGP4c/6vIFGEeeWyYwxDvO+62kcYk8lJQ6l/vYZ7KxMlFO5ZMmOGg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:9254:0:b0:7a1:95c1:de3f with SMTP id
 41be03b00d2f7-7a195c1e0bdmr10587a12.0.1721664509221; Mon, 22 Jul 2024
 09:08:29 -0700 (PDT)
Date: Mon, 22 Jul 2024 09:08:27 -0700
In-Reply-To: <0000000000002b84dc061dd73544@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000002b84dc061dd73544@google.com>
Message-ID: <Zp6D-7aABU1Q1fIG@google.com>
Subject: Re: [syzbot] [kvm?] general protection fault in is_page_fault_stale
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+23786faffb695f17edaa@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 22, 2024, syzbot wrote:
> Oops: general protection fault, probably for non-canonical address 0xe000013ffffffffd: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: maybe wild-memory-access in range [0x000029ffffffffe8-0x000029ffffffffef]
> CPU: 0 PID: 11829 Comm: syz.1.1799 Not tainted 6.10.0-syzkaller-11185-g2c9b3512402e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
> RIP: 0010:to_shadow_page arch/x86/kvm/mmu/spte.h:245 [inline]
> RIP: 0010:spte_to_child_sp arch/x86/kvm/mmu/spte.h:250 [inline]
> RIP: 0010:root_to_sp arch/x86/kvm/mmu/spte.h:267 [inline]
> RIP: 0010:is_page_fault_stale+0xc4/0x530 arch/x86/kvm/mmu/mmu.c:4517
> Code: e9 00 01 00 00 48 b8 ff ff ff ff ff 00 00 00 48 21 c3 48 c1 e3 06 49 bc 28 00 00 00 00 ea ff ff 49 01 dc 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 6d b7 d8 00 4d 8b 2c 24 31 ff 4c
> RSP: 0018:ffffc9000fc6f6f0 EFLAGS: 00010202
> RAX: 0000053ffffffffd RBX: 00003fffffffffc0 RCX: ffff88806a8bda00
> RDX: 0000000000000000 RSI: 000fffffffffffff RDI: 00000000000129d3
> RBP: 00000000000129d3 R08: ffffffff8120c8e0 R09: 1ffff920005e6c00
> R10: dffffc0000000000 R11: fffff520005e6c01 R12: 000029ffffffffe8
> R13: dffffc0000000000 R14: ffffc9000fc6f800 R15: ffff88807cbed000
> FS:  0000000000000000(0000) GS:ffff8880b9400000(0063) knlGS:00000000f5d46b40
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000576d24c0 CR3: 000000007d930000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  kvm_tdp_mmu_page_fault arch/x86/kvm/mmu/mmu.c:4662 [inline]
>  kvm_tdp_page_fault+0x25c/0x320 arch/x86/kvm/mmu/mmu.c:4693
>  kvm_mmu_do_page_fault+0x589/0xca0 arch/x86/kvm/mmu/mmu_internal.h:323
>  kvm_tdp_map_page arch/x86/kvm/mmu/mmu.c:4715 [inline]
>  kvm_arch_vcpu_pre_fault_memory+0x2db/0x5a0 arch/x86/kvm/mmu/mmu.c:4760
>  kvm_vcpu_pre_fault_memory+0x24c/0x4b0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4418
>  kvm_vcpu_ioctl+0xa47/0xea0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4648
>  kvm_vcpu_compat_ioctl+0x242/0x450 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4700
>  __do_compat_sys_ioctl fs/ioctl.c:1007 [inline]
>  __se_compat_sys_ioctl+0x51c/0xca0 fs/ioctl.c:950
>  do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
>  __do_fast_syscall_32+0xb4/0x110 arch/x86/entry/common.c:386
>  do_fast_syscall_32+0x34/0x80 arch/x86/entry/common.c:411
>  entry_SYSENTER_compat_after_hwframe+0x84/0x8e

The amount sanitizer code in play makes it difficult to read the assembly, but
unless I'm misreading things the explosion happens on

	return (struct kvm_mmu_page *)page_private(page);

which suggests that vcpu->arch.mmu->root.hpa is garbage.  Lo and behold!  Just
before the explosion, there's a malloc() injection during kvm_mmu_load().

Not sure why syzbot can't get a repro, but I'm pretty confident the bug is that
kvm_arch_vcpu_pre_fault_memory() doesn't check the result of kvm_mmu_reload().

I'll send this after a bit of testing:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..ee516baf3a31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4747,7 +4747,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
         * reload is efficient when called repeatedly, so we can do it on
         * every iteration.
         */
-       kvm_mmu_reload(vcpu);
+       r = kvm_mmu_reload(vcpu);
+       if (r)
+               return r;
 
        if (kvm_arch_has_private_mem(vcpu->kvm) &&
            kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))


[  363.075965][T11829] FAULT_INJECTION: forcing a failure.
[  363.075965][T11829] name failslab, interval 1, probability 0, space 0, times 0
[  363.089953][   T53] vhci_hcd: release socket
[  363.094422][   T53] vhci_hcd: disconnect device
[  363.117979][T11829] CPU: 0 PID: 11829 Comm: syz.1.1799 Not tainted 6.10.0-syzkaller-11185-g2c9b3512402e #0
[  363.127841][T11829] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
[  363.137917][T11829] Call Trace:
[  363.141207][T11829]  <TASK>
[  363.144137][T11829]  dump_stack_lvl+0x241/0x360
[  363.148907][T11829]  ? __pfx_dump_stack_lvl+0x10/0x10
[  363.154103][T11829]  ? __pfx__printk+0x10/0x10
[  363.158689][T11829]  ? validate_chain+0x11e/0x5900
[  363.163722][T11829]  should_fail_ex+0x3b0/0x4e0
[  363.168410][T11829]  should_failslab+0x9/0x20
[  363.172915][T11829]  __kmalloc_node_noprof+0xdf/0x440
[  363.178111][T11829]  ? __kvmalloc_node_noprof+0x72/0x190
[  363.183574][T11829]  __kvmalloc_node_noprof+0x72/0x190
[  363.188869][T11829]  __kvm_mmu_topup_memory_cache+0x4d9/0x6b0
[  363.194801][T11829]  kvm_mmu_load+0x115/0x26e0
[  363.199416][T11829]  ? __asan_memset+0x23/0x50
[  363.204038][T11829]  ? vmx_vcpu_pi_load+0x13b/0x8c0
[  363.209381][T11829]  ? __pfx_kvm_mmu_load+0x10/0x10
[  363.214447][T11829]  ? __lock_acquire+0x137a/0x2040
[  363.219511][T11829]  kvm_arch_vcpu_pre_fault_memory+0x4c0/0x5a0
[  363.225862][T11829]  ? __pfx_kvm_arch_vcpu_load+0x10/0x10
[  363.231674][T11829]  ? __pfx_kvm_arch_vcpu_pre_fault_memory+0x10/0x10
[  363.238267][T11829]  ? __pfx_lock_release+0x10/0x10
[  363.243305][T11829]  kvm_vcpu_pre_fault_memory+0x24c/0x4b0
[  363.248941][T11829]  ? kvm_vcpu_pre_fault_memory+0x16a/0x4b0
[  363.254748][T11829]  kvm_vcpu_ioctl+0xa47/0xea0
[  363.259422][T11829]  ? __lock_acquire+0x137a/0x2040
[  363.264461][T11829]  ? __pfx_kvm_vcpu_ioctl+0x10/0x10
[  363.269663][T11829]  ? __pfx_tomoyo_path_number_perm+0x10/0x10
[  363.275672][T11829]  kvm_vcpu_compat_ioctl+0x242/0x450
[  363.280962][T11829]  ? __pfx_kvm_vcpu_compat_ioctl+0x10/0x10
[  363.286780][T11829]  ? __fget_files+0x3f6/0x470
[  363.291474][T11829]  ? bpf_lsm_file_ioctl_compat+0x9/0x10
[  363.297023][T11829]  ? security_file_ioctl_compat+0x87/0xb0
[  363.302765][T11829]  __se_compat_sys_ioctl+0x51c/0xca0
[  363.308053][T11829]  ? __pfx___se_compat_sys_ioctl+0x10/0x10
[  363.313859][T11829]  ? lockdep_hardirqs_on_prepare+0x43d/0x780
[  363.319981][T11829]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[  363.326322][T11829]  ? syscall_enter_from_user_mode_prepare+0x7f/0xe0
[  363.332919][T11829]  ? lockdep_hardirqs_on+0x99/0x150
[  363.338116][T11829]  __do_fast_syscall_32+0xb4/0x110
[  363.343221][T11829]  ? exc_page_fault+0x590/0x8c0
[  363.348095][T11829]  do_fast_syscall_32+0x34/0x80
[  363.352937][T11829]  entry_SYSENTER_compat_after_hwframe+0x84/0x8e

