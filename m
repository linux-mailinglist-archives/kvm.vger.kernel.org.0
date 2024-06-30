Return-Path: <kvm+bounces-20736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 469BD91D462
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 00:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D43F1C2097C
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2024 22:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9486EB46;
	Sun, 30 Jun 2024 22:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QEv2sRNA"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCF35A79B;
	Sun, 30 Jun 2024 22:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719786073; cv=none; b=PiLY9rxlLLM/+NAMc+KbZCYOPCADm51Y90MEwjKVb81zjEBTA06v8HYlNHwiFXl/hZlQlNvHjTZX2G+WYBvidCckInpP7CM6bjJdxzbamCunT3BLEpg7GFlnAlZNxNG6PyKPIVslq3flgSHZnYnj/iBaGoujPCfUe1nVyv4r1ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719786073; c=relaxed/simple;
	bh=n2br2zJs1c7Xzbh9r1poj+Ixq3ewKF/fK5lMmwMgNY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDzFsQpurtp5BSUIYpqjYfVpzBeyaL4eq516OpPY5IbjC4xz40wPNM8VX0/nlF1PzrtLhnbDr87vUCUG6hXCBLklFI3W2I9XfF1UsUz7G80moIRlFyFO+108LM5w0hm/qVm194E/MUu6s3zb13aSBZEJDThRQuazeRAE3AKJP4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QEv2sRNA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=KDMt0EhSkPQZeThOP0Ijk2KXcF7Tc0M6fcnV5k1MF4c=; b=QEv2sRNAVB7BTWp791eChBn2kp
	4/z8wI3nEi7sAXyTFvtwf8F1HdkRRmvyXBDucYfHfCNxBxCurAFGRDE4g00NE335beWuVhJ0r5A4x
	BrL/Bxt5/V6Wu3DSVRTmTSyerwgo77Rm+ClqKDXPZwmM+1fOkrR0fH1vVKhdGE8HTC+9YrICHmO4B
	b3HIKURQy54Fc4qF6y6CtdjdPytTKotzRphjdEjIG4cRKaIvb1LsfJ0z1NIa+4UXOxXKZe5om2ZR9
	pPH3wcBlKbQS146yAs+NDn7fD7q5u3umY2nQ65V/+9RxPf3TwKwjK9bC/py7WLSLfOEcvBYRga4lG
	KqLLQ71A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sO2v0-000000017gA-3nt2;
	Sun, 30 Jun 2024 22:21:10 +0000
Date: Sun, 30 Jun 2024 15:21:10 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org, kdevops@lists.linux.dev,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [Bug 218980] New: [VM boot] Guest Kernel hit BUG: kernel NULL
 pointer dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218
 at arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Message-ID: <ZoHaVmNbFGcejSjK@bombadil.infradead.org>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Jun 24, 2024 at 06:43:54AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218980
> 
>             Bug ID: 218980
>            Summary: [VM boot] Guest Kernel hit BUG: kernel NULL pointer
>                     dereference, address: 0000000000000010 and WARNING:
>                     CPU: 0 PID: 218 at arch/x86/kernel/fpu/core.c:57
>                     x86_task_fpu+0x17/0x20
>            Product: Virtualization
>            Version: unspecified
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: hongyu.ning@intel.com
>         Regression: No
> 
> Created attachment 306485
>   --> https://bugzilla.kernel.org/attachment.cgi?id=306485&action=edit
> WARNING/BUG and Call Trace info in dmesg
> 
> in an regular linux-next guest kernel regression test setup, recently hit
> following BUG and WARNING, likely related to x86/fpu.

> [    1.962383]  ? fpstate_free+0x5/0x30

Yeah we run into the same thing on *all* boots on linux-next on kdevops
as well, Cc'ing kdevops list so folks are aware linux-next is broken
right now.

[   16.785349] BUG: kernel NULL pointer dereference, address:
0000000000000010
[   16.785353] #PF: supervisor read access in kernel mode
[  OK  ] Found device[   16.785354] #PF: error_code(0x0000) -
not-present page
 dev-disk-by\x2dlabel-…evice - QEMU NVMe Ctrl sparsefiles.
 [   16.785356] PGD 0 P4D 0
 [   16.785358] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
 [   16.785361] CPU: 1 UID: 0 PID: 528 Comm: modprobe Tainted: G
 W          6.10.0-rc5-next-20240628+ #8
 [   16.785365] Tainted: [W]=WARN
 [   16.785366] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
 1.16.3-debian-1.16.3-2 04/01/2014
 [   16.785367] RIP: 0010:fpstate_free+0x5/0x30
 [   16.785373] Code: 41 5c 41 5d 41 5e c3 cc cc cc cc 66 2e 0f 1f 84 00
 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00
 00 <48> 8b 47 10 48 85 c0 74 11 48 83 c7 40 48
  39 f8 74 08 48 89 c7 e9
  [   16.785374] RSP: 0000:ffffb4dd80673e48 EFLAGS: 00010246
  [   16.785376] RAX: 0000000000000000 RBX: ffff8eca5fdd0000 RCX:
  00000000801c0012
  [   16.785378] RDX: ffff8eca54bef500 RSI: ffffffff8aa9b92d RDI:
  0000000000000000
  [   16.785379] RBP: ffff8ecabbc72840 R08: ffff8eca54bed100 R09:
  00000000801c0012
  [   16.785380] R10: 00000000801c0012 R11: 0000000000000001 R12:
  ffff8eca605dc800
  [   16.785381] R13: 0000000000030bc8 R14: ffff8ecabbc728b8 R15:
  0000000000000004
  [   16.785382] FS:  00007f26f73a35c0(0000) GS:ffff8ecabbc40000(0000)
  knlGS:0000000000000000
  [   16.785383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [   16.785385] CR2: 0000000000000010 CR3: 00000001175b6006 CR4:
  0000000000770ef0
  [   16.785389] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
  0000000000000000
  [   16.785390] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
  0000000000000400
  [   16.785391] PKRU: 55555554
  [   16.785392] Call Trace:
  [   16.785394]  <TASK>
  [   16.785396]  ? __die+0x1f/0x60
  [   16.785401]  ? page_fault_oops+0x158/0x460
  [   16.785406]  ? x86_task_fpu+0x17/0x20
  [   16.785410]  ? do_user_addr_fault+0x63/0x6c0
  [   16.785413]  ? exc_page_fault+0x79/0x190
  [   16.785417]  ? asm_exc_page_fault+0x22/0x30
  [   16.785420]  ? free_task+0x2d/0x70
  [   16.785424]  ? fpstate_free+0x5/0x30
  [   16.785427]  ? arch_release_task_struct+0x27/0x30
  [   16.785429]  free_task+0x35/0x70
  [   16.785432]  rcu_core+0x499/0x7d0
  [   16.785436]  ? rcu_core+0x434/0x7d0
  [   16.785440]  handle_softirqs+0xf9/0x300
  [   16.785444]  __irq_exit_rcu+0x6e/0xc0
  [   16.785446]  sysvec_apic_timer_interrupt+0x51/0xc0
  [   16.785450]  asm_sysvec_apic_timer_interrupt+0x16/0x20
  [   16.785452] RIP: 0033:0x7f26f74d0858

