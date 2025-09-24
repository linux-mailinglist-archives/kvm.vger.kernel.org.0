Return-Path: <kvm+bounces-58634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FA8B9A068
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BA9C2A528A
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D118E302162;
	Wed, 24 Sep 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qkqTy1VX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C92FD1B5
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758720305; cv=none; b=qwUE2Tl5f2ikshBAbQmqjcVygIkzwt8IBW363cwaqk9TqDmh9Aj/7Vxf0tweD1MDyyD82jF0fXtMDOF2bnzjggDCTaFptV4CxuSjf0lYRIXwFikaAT+7W7RBdrJuW6TyHDbhPrQCJokIHn9Tbt+nsg4fjHHiFC/rhFxHOnM6Jvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758720305; c=relaxed/simple;
	bh=P+CF1MWt/yF5R0xFK0U0jQjwmJ1wtsNl/D8RaIUP9Qw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bb6WJzJy4Wz7OvVjWIPjv6XmvxdvuXsde0lB3ttxqCTwACYkmrRTpG8JWhGT1YewVLfwXU5WqNDRHHZcjv3NB+fxDkL8qREjZnprmDBZ9FG9mGVPrL+GexuZwnnK4NPNMnK0g24w/QJUnlxbu48LQuMJGWDgPxvFl+tLHDz28iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qkqTy1VX; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5527f0d39bso6502583a12.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 06:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758720303; x=1759325103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ew+O7tf8wnkBKLG+cc0gKdz8zPsvoJzeHD52hJbKBEs=;
        b=qkqTy1VXi0fIQuBlgc0tZ0rv5wL4g6iXCey8cfVNABlRV/vwFri92VRPgXEnj0Jde8
         8n7eKvFuXVCQ51UGxF7sc19hT/JKdK4OaE8rEgYZiXVHYoLB2cbamKk3d4hwI/fU5Xek
         J5sO6yn7bpNdjw1lYIEcp3bQBxMufcUzEpskYUVL3y+6mu3ntY7363ZABXtXRrN9zLJs
         CpfoBLAz1BGvxmPrdj8NvjV7UDoiJrp2tHWnB9OyKgzQHkyNlnDRa3HySmEUj1ycs3Zh
         Y+JTfMH5YcFiF+b2GgaUCY8V05EonmCmADRIsNNOx4GuIHkMpyBfgqNsErzGd6peZvNp
         juEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758720303; x=1759325103;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ew+O7tf8wnkBKLG+cc0gKdz8zPsvoJzeHD52hJbKBEs=;
        b=WNex/g5Q6Mrm1EO1GMo3YWkitW6aiyPS6lMAdr1wpuTWv8FHw8KGZqmW5jgR7iSR9I
         7vS513UpHp0Wt9e7CQNHI++BEAqnbJfnIlI7+skgfd2tNmi/SKbj9Vgm5giyQYsIeAP8
         9Xo3qnuMcIBNQRDH2zDAYuzjc1m+6Is98RdQNTTKQRmE+2xz2PdCGUrOYg+o03BTb40S
         tcY13VKCIW896xG0ZEUV4oYYhGzIZBjtLO1dDi0aZbRh1Cx7Oo5Yi99ZhaW54zaWF/12
         KSCeiEA0FLhVtrolnqnUCADwugsDJwIxx8tgW7Z40/IxeYlxFPEZ0CGFjEJwhoFazee1
         EAeA==
X-Forwarded-Encrypted: i=1; AJvYcCXbekCNP3PdGWwdoUyQqElXA7wMQ93pz+HSQxGXoC7ty/yw5eKyb1qwYbaBDEqqHAnndVU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh6XusWpWeh4bqhN6MyzuaxxWRQRp+o9lWdEmQubavgETo2a2r
	cjOxZ/tjX6nwRm1ZDUaGZQv6iBAGA67gkmz/F1RvWRSWz0q07gEZ6rH0QTty0ficIYaNqmGhEB7
	tQLmS8g==
X-Google-Smtp-Source: AGHT+IEQyRFnQPP+o0XKJ1RGnDTwyJAi4JycOarpv4vDajM8hl05vyvKYPM/lL4EQInAa9aM6dw8fx0JMT8=
X-Received: from pgww20.prod.google.com ([2002:a05:6a02:2c94:b0:b55:7de:e92d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7a06:b0:2db:f868:216
 with SMTP id adf61e73a8af0-2dbf86804f3mr3735154637.52.1758720302776; Wed, 24
 Sep 2025 06:25:02 -0700 (PDT)
Date: Wed, 24 Sep 2025 06:25:01 -0700
In-Reply-To: <e8ace4cc-eb22-4117-b34d-16ecc1c8742d@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <e8ace4cc-eb22-4117-b34d-16ecc1c8742d@amd.com>
Message-ID: <aNPxLQBxUau-FWtj@google.com>
Subject: Re: AMD SNP guest kdump broken since linuxnext-20250908
From: Sean Christopherson <seanjc@google.com>
To: Srikanth Aithal <sraithal@amd.com>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	KVM <kvm@vger.kernel.org>, Ashish Kalra <Ashish.Kalra@amd.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

+Ard and Boris (and Tom for good measure)

On Wed, Sep 24, 2025, Srikanth Aithal wrote:
> Hello all,
>=20
> kdump on an SNP guest is broken in linux-next, starting with next-2025090=
8 [1].
>=20
> kdump on an SNP guest works with the following kernels as the guest kerne=
l:
>=20
> 1. https://git.kernel.org/pub/scm/virt/kvm/kvm.git, kvm/next
> 2. git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git next=
-20250905
> 3. git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git v6.1=
7-rc7
>=20
> The crash log during kdump varies each time. I have attached all variants=
 of
> the error console logs to this bug report as files, as they are too large=
 to
> include here.
>=20
> kdump with other guest types (normal, SEV, SEV-ES) is working fine.
>=20
> I attempted bisecting multiple times, but due to varying error console
> messages=E2=80=94sometimes with a call trace, sometimes just a hang with =
no error
> messages, and sometimes with extensive register dumps including KVM hardw=
are
> error messages=E2=80=94I had no success until now. Additionally, a couple=
 of
> linux-next bisect attempt pointed to a merge commit where the parent comm=
its
> had no issues, suggesting a possible merge problem.
>=20
> I am also attaching the host kernel config and guest kernel config used f=
or
> these tests.
>=20
> Tests were conducted with the following component versions:
>=20
>  * Host kernel: next-20250919
>  * QEMU version: v10.1.0
>  * EDK2: edk2-stable202508
>  * Platform: Milan with the latest BIOS v2.20
>=20
>=20
> Thank you,
>=20
> Srikanth Aithal <Srikanth.Aithal@amd.com>
>=20
> root@ubuntu:~# echo c > /proc/sysrq-trigger
> [   26.686014] sysrq: Trigger a crash
> [   26.687006] Kernel panic - not syncing: sysrq triggered crash
> [   26.688594] CPU: 0 UID: 0 PID: 4235 Comm: bash Kdump: loaded Not taint=
ed 6.17.0-rc7-next-20250923ce7f1a983b07 #1 PREEMPT(voluntary)
> [   26.691788] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS u=
nknown 02/02/2022
> [   26.693957] Call Trace:
> [   26.694681]  <TASK>
> [   26.695320]  vpanic+0x307/0x360
> [   26.696237]  panic+0x52/0x60
> [   26.697065]  sysrq_handle_crash+0x11/0x20
> [   26.698177]  __handle_sysrq+0xb6/0x170
> [   26.699220]  write_sysrq_trigger+0x50/0x70
> [   26.700358]  proc_reg_write+0x50/0x90
> [   26.701395]  ? preempt_count_add+0x42/0xa0
> [   26.702531]  vfs_write+0xf4/0x430
> [   26.703481]  ? handle_mm_fault+0xd0/0x200
> [   26.704602]  ksys_write+0x5c/0xd0
> [   26.705551]  do_syscall_64+0x4c/0x200
> [   26.706577]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   26.707961] RIP: 0033:0x7f4cb8024574
> [   26.708974] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 0=
0 00 00 00 00 f3 0f 1e fa 80 3d d5 ea 0e 00 00 74 13 b8 01 00 00 00 0f 05 <=
48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 55 48 89 e5 48 83 ec 20 48 89
> [   26.713912] RSP: 002b:00007ffdad4f3208 EFLAGS: 00000202 ORIG_RAX: 0000=
000000000001
> [   26.715976] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f4cb=
8024574
> [   26.717905] RDX: 0000000000000002 RSI: 0000564731e37b80 RDI: 000000000=
0000001
> [   26.719843] RBP: 00007ffdad4f3230 R08: 0000000000000073 R09: 000000000=
0000000
> [   26.721797] R10: 00000000ffffffff R11: 0000000000000202 R12: 000000000=
0000002
> [   26.723715] R13: 0000564731e37b80 R14: 00007f4cb810c5c0 R15: 00007f4cb=
8109ee0
> [   26.725658]  </TASK>
>=20
> [1373710140.379273] kernel tried to execute NX-protected page - exploit a=
ttempt? (uid: 0)
> [2800084354.542901] BUG: unable to handle page fault for address: fffffff=
f9a91e731
> [15541331571.597940] #PF: supervisor instruction fetch in kernel mode
> [11262208929.107056] #PF: error_code(0x0011) - permissions violation
> [15541331571.597940] PGD 800000e045067 P4D 800000e045067 PUD 800000e04606=
3 PMD 80000021b8063 PTE 800800000e91e163

This is definitely a valid (i.e. not corrupted), NX mapping.

> [1373710140.379273] Oops: Oops: 0011 [#1] SMP NOPTI
> [11262208929.107056] CPU: 0 UID: 0 PID: 4235 Comm: bash Kdump: loaded Not=
 tainted 6.17.0-rc7-next-20250923ce7f1a983b07 #1 PREEMPT(voluntary)
> [2800084354.542901] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), B=
IOS unknown 02/02/2022
> [12688583143.270684] RIP: 0010:early_set_pages_state+0x0/0x120

Given that a lore search on early_set_pages_state lights up Ard's series[*]=
 to
cleanup the boot code for SEV, and that said series is new in next-20250908=
 (NOT
in next-20250905), that seems like a likely culprit.

[*] https://lore.kernel.org/all/20250828102202.1849035-24-ardb+git@google.c=
om

> [15541331571.597940] Code: 02 02 02 02 02 00 02 02 02 02 02 02 02 02 02 0=
2 02 02 02 02 00 02 02 02 00 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 0=
2 02 <02> 02 02 02 02 02 02 02 02 02 02 02 02 02 02 00 02 02 02 02 02 02
> [12688583143.270684] RSP: 0018:ffffb608807a7be0 EFLAGS: 00010006
> [1373710140.379273] RAX: ffff9ed0bfe53000 RBX: ffffffff9abecbe8 RCX: ffff=
b608807a7be8
> [2800084354.542901] RDX: 0000000000000001 RSI: 000000007fe53000 RDI: ffff=
9ed03fe53000
> [1373710140.379273] RBP: 0000000000000001 R08: 0000000000000001 R09: ffff=
9ed03fe53000
> [12688583143.270684] R10: 000000000f001000 R11: 0000000000000000 R12: fff=
f9ed03fe53000
> [15541331571.597940] R13: 0000000000000000 R14: ffff9ecfcf00a298 R15: 000=
0000000001000
> [11262208929.107056] FS:  00007f4cb7f05740(0000) GS:ffff9ed0a282c000(0000=
) knlGS:0000000000000000
> [2800084354.542901] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [18394079999.925196] CR2: ffffffff9a91e731 CR3: 000800000fb1c000 CR4: 000=
00000003506f0
> [12688583143.270684] Call Trace:
> [18394079999.925196]  <TASK>
> [2800084354.542901]  set_pages_state.part.0+0x63/0xa0
> [2800084354.542901]  snp_kexec_finish+0x432/0x490
> [12688583143.270684]  native_machine_crash_shutdown+0x65/0x90
> [15541331571.597940]  __crash_kexec+0x56/0x120
> [1373710140.379273]  ? __crash_kexec+0x104/0x120
> [12688583143.270684]  ? vpanic+0x2a2/0x360
> [18394079999.925196]  ? panic+0x52/0x60
> [11262208929.107056]  ? sysrq_handle_crash+0x11/0x20
> [16967705785.761568]  ? __handle_sysrq+0xb6/0x170
> [1373710140.379273]  ? write_sysrq_trigger+0x50/0x70
> [1373710140.379273]  ? proc_reg_write+0x50/0x90
> [18394079999.925196]  ? preempt_count_add+0x42/0xa0
> [2800084354.542901]  ? vfs_write+0xf4/0x430
> [11262208929.107056]  ? handle_mm_fault+0xd0/0x200
> [18394079999.925196]  ? ksys_write+0x5c/0xd0
> [12688583143.270684]  ? do_syscall_64+0x4c/0x200
> [11262208929.107056]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [15541331571.597940]  </TASK>
> [12688583143.270684] Modules linked in: efivarfs
> [2800084354.542901] CR2: ffffffff9a91e731
> [14114957357.434312] ---[ end trace 0000000000000000 ]---
> [11262208929.107056] RIP: 0010:early_set_pages_state+0x0/0x120
> [12688583143.270684] Code: 02 02 02 02 02 00 02 02 02 02 02 02 02 02 02 0=
2 02 02 02 02 00 02 02 02 00 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 0=
2 02 <02> 02 02 02 02 02 02 02 02 02 02 02 02 02 02 00 02 02 02 02 02 02
> [15541331571.597940] RSP: 0018:ffffb608807a7be0 EFLAGS: 00010006
> [14114957357.434312] RAX: ffff9ed0bfe53000 RBX: ffffffff9abecbe8 RCX: fff=
fb608807a7be8
> [2800084354.542901] RDX: 0000000000000001 RSI: 000000007fe53000 RDI: ffff=
9ed03fe53000
> [15541331571.597940] RBP: 0000000000000001 R08: 0000000000000001 R09: fff=
f9ed03fe53000
> [2800084354.542901] R10: 000000000f001000 R11: 0000000000000000 R12: ffff=
9ed03fe53000
> [2800084354.542901] R13: 0000000000000000 R14: ffff9ecfcf00a298 R15: 0000=
000000001000
> [2800084354.542901] FS:  00007f4cb7f05740(0000) GS:ffff9ed0a282c000(0000)=
 knlGS:0000000000000000
> [14114957357.434312] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [11262208929.107056] CR2: ffffffff9a91e731 CR3: 000800000fb1c000 CR4: 000=
00000003506f0
> [12688583143.270684] Kernel panic - not syncing: Fatal exception

