Return-Path: <kvm+bounces-29912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1B39B3ED7
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 01:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 412021C22395
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 00:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03662114;
	Tue, 29 Oct 2024 00:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6Z4hoJv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE981361;
	Tue, 29 Oct 2024 00:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730160458; cv=none; b=gjFDuDII6nLoLuIw0MRc2j9dLtyWN25z6R2XwRqQHG27KFekKGE7ZJBV3T03N2lJCtUsYAXMCy6Iwq3I9yFtp0fgQHbUaD4bKk5ut5NERpF1U8Rojgj2Zih2KFBUQ1PaX18KK0uWZ4ESxkQg6RdcpONKjzt4xTTbL2O3kCz9ayY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730160458; c=relaxed/simple;
	bh=KptdeRRbU7AnepZinMT4SpFDd5VqMpOu7a8/xVk6MK4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Md38/4u/pkoYHguG84e4Uq5lfSJwLI6oAcWGajEkgeA6rv3S9Yy0EXYeKuI1QBfzy8zvy/sOXGcr6x1wvDDTPwyj/m1Q/s4RtwBQFKZMMm/ra3ccbYUHy1SnfHwMpR3FaTHVcDVR0mF4wJu375nREKV0O+c0YEMrQ9vlyyQovbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6Z4hoJv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BF1C4CEC3;
	Tue, 29 Oct 2024 00:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730160457;
	bh=KptdeRRbU7AnepZinMT4SpFDd5VqMpOu7a8/xVk6MK4=;
	h=Date:From:To:Cc:Subject:From;
	b=D6Z4hoJvuhwdU6BN12XsAPkOdT8qQOy2s/6Mz48u0SWvK/ahHhi4JTD7lbdNvbhqG
	 Xm7gGykod2Uc7jTvvQm5kfE9kFRrbpRV5kZHoXnCCyGKMgCJ137HAtTs6QFMQ8mS5c
	 kyfuw4mE+NooBFilKTDILkam9WXAODVCr8SnCf21eEjMOuIa80MoXcIZSysYBghwhr
	 3T9arPC/Xjf1XwyF1p8ddk4cflUPHIDrSX5Ck5UZt80lPWbKb19vRJsZraiUbfErN9
	 zLQUD2IyT78WTsjG72CVpZ37NHjdfJiCTX9o6N3CXSFziA2rbYc8t8bIF6iBirOH7i
	 WLyCX2RLcNPVQ==
Date: Mon, 28 Oct 2024 14:07:36 -1000
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>, Luca Boccassi <bluca@debian.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: kvm@vger.kernel.org, cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	linux-kernel@vger.kernel.org
Subject: cgroup2 freezer and kvm_vm_worker_thread()
Message-ID: <ZyAnSAw34jwWicJl@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Luca is reporting that cgroups which have kvm instances inside never
complete freezing. This can be trivially reproduced:

  root@test ~# mkdir /sys/fs/cgroup/test
  root@test ~# echo $fish_pid > /sys/fs/cgroup/test/cgroup.procs
  root@test ~# qemu-system-x86_64 --nographic -enable-kvm

and in another terminal:

  root@test ~# echo 1 > /sys/fs/cgroup/test/cgroup.freeze
  root@test ~# cat /sys/fs/cgroup/test/cgroup.events
  populated 1
  frozen 0
  root@test ~# for i in (cat /sys/fs/cgroup/test/cgroup.threads); echo $i; cat /proc/$i/stack; end 
  2070
  [<0>] do_freezer_trap+0x42/0x70
  [<0>] get_signal+0x4da/0x870
  [<0>] arch_do_signal_or_restart+0x1a/0x1c0
  [<0>] syscall_exit_to_user_mode+0x73/0x120
  [<0>] do_syscall_64+0x87/0x140
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  2159
  [<0>] do_freezer_trap+0x42/0x70
  [<0>] get_signal+0x4da/0x870
  [<0>] arch_do_signal_or_restart+0x1a/0x1c0
  [<0>] syscall_exit_to_user_mode+0x73/0x120
  [<0>] do_syscall_64+0x87/0x140
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  2160
  [<0>] do_freezer_trap+0x42/0x70
  [<0>] get_signal+0x4da/0x870
  [<0>] arch_do_signal_or_restart+0x1a/0x1c0
  [<0>] syscall_exit_to_user_mode+0x73/0x120
  [<0>] do_syscall_64+0x87/0x140
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  2161
  [<0>] kvm_nx_huge_page_recovery_worker+0xea/0x680
  [<0>] kvm_vm_worker_thread+0x8f/0x2b0
  [<0>] kthread+0xe8/0x110
  [<0>] ret_from_fork+0x33/0x40
  [<0>] ret_from_fork_asm+0x1a/0x30
  2164
  [<0>] do_freezer_trap+0x42/0x70
  [<0>] get_signal+0x4da/0x870
  [<0>] arch_do_signal_or_restart+0x1a/0x1c0
  [<0>] syscall_exit_to_user_mode+0x73/0x120
  [<0>] do_syscall_64+0x87/0x140
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

The cgroup freezing happens in the signal delivery path but
kvm_vm_worker_thread() thread never call into the signal delivery path while
joining non-root cgroups, so they never get frozen. Because the cgroup
freezer determines whether a given cgroup is frozen by comparing the number
of frozen threads to the total number of threads in the cgroup, the cgroup
never becomes frozen and users waiting for the state transition may hang
indefinitely.

There are two paths that we can take:

1. Make kvm_vm_worker_thread() call into signal delivery path.
   io_wq_worker() is in a similar boat and handles signal delivery and can
   be frozen and trapped like regular threads.

2. Keep the count of threads which can't be frozen per cgroup so that cgroup
   freezer can ignore these threads.

#1 is better in that the cgroup will actually be frozen when reported
frozen. However, the rather ambiguous criterion we've been using for cgroup
freezer is whether the cgroup can be safely snapshotted whil frozen and as
long as the workers not being frozen doesn't break that, we can go for #2
too.

What do you guys think?

Thanks.

-- 
tejun

