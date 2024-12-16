Return-Path: <kvm+bounces-33867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E0469F36BC
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB5C51657B0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 16:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619DF20765F;
	Mon, 16 Dec 2024 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2r1LDg/2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB51B4124
	for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 16:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734367849; cv=none; b=F17btEO7d8WBQcdLrJWbaGYuX+prlfG7Yfyx0CY6h+wgpltjbdWn+5a5RSVz4AFQbnXrAXET2FYmXI727qeZ7mo6kNCV8oarau2UMkiwpvm4NtJ4SRyi4dDocO2LjEDkA23GuogfnNwA5b8lVjxhhbjsR5I6MruWAC6fn7t+EPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734367849; c=relaxed/simple;
	bh=Ws7MFMOo1yp0zcdnE+z67WTJ71dQGMM1e4ky5oUz3/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eN92d82bqMEYyGYmTXwGfRjGfzatxpVJXvxwUEunJN+W9N+ltDZ7LHlRQE10oih69OBhVkvGhFpHWDdtXdzgE4LZ/b7Da/HG94dPCVqWzgAzKueCfETRBX9PYs/awWknkdhXxYWk2Okdv7ItvY2ipJdzRjk3LiqySDqTsN9IZek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2r1LDg/2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so5900816a91.3
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 08:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734367847; x=1734972647; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJosb+4Wbiprv0ODxaMx5IvZrjA8SClHnMgL0HeBnaY=;
        b=2r1LDg/22YicpZFWUeimC5wtgD3d8kGgwIoCBbRnMaUrG19c4VuPA1f+zWdVw8QWLj
         D7E20VhrFypatuFfkPl1/Zjq6uX63QBgCKQ/1Qt/ogllwvFjX3iygSxpfITqJY1BGZnj
         TmU93N1S9ED+eT3DGCi3nc02d+Ig4PymgMbGI+RlKoAoGpwY5eOiAxnNeDdKmvK+R4A9
         epgaZq7OUSupphGbz1HR7DnOXgl65e861Zh4MPS+htOwGpSR1hot9BaIALhnXasBpArf
         yn2MFWu0VBYHyqUQG6AZ/jQBd7hbvpOdpv7gRee6c039NPyXa0WbfXOXlWY5+oY66Us+
         Ivvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734367847; x=1734972647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vJosb+4Wbiprv0ODxaMx5IvZrjA8SClHnMgL0HeBnaY=;
        b=cA+mQWCUJW68sG0UlxCIg4TG/ryiF+jMdh3fKn9I+9ODwQ7bDJxG3+7DVT/gICdiRJ
         crDSlzerQ+DJUfoL2R8dCvMIO1ZZHtc8TWXk90LUm2YPP6GibK0WBCqfN/KUdbFovvBM
         Vvlg38jGOBC0pDxYxx+p3c/SO+cVXuPceuyljJ4HGYZZO/hphjdcXXG0XKrLY6esSQJN
         LsC2zg0jjsFq6LGqpGwfBF56TMEwnT6Qgx1F4sdTnkqRSRY8RePFBo/uG+KrY53Er5p/
         71mOFo65/t6wTxqQJ82ImF9wm9A8wJQ5+ZD070SZozYGWY2+ZqWHpORTiAFeNnFgHy9P
         8i3w==
X-Forwarded-Encrypted: i=1; AJvYcCX3V442EVJO/qZchlZrMWlfQncwRiFAZ/6HE7jV5j6vwYbhLBWDqPuDWAC3F3Gkv7Kcs24=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbLShNqjc7hbevCVRB6Ahl1GpZwtt4C6PZH5mwBG9VxZrBytnv
	pookaVLGgofhKO+FV8JavqMtoGcb/6s91NcM4Itj6PAzHBL2heVUOI/APTfo4PP5eyi8/Enz5YI
	aRw==
X-Google-Smtp-Source: AGHT+IE+GQ4hpyr2SyTZPDfVu3iw4e4PoTjMGkYTGBOyTwq6Rx4HMxnTZuidojWjumXVntbHNHmCJouC/MY=
X-Received: from pjbqa16.prod.google.com ([2002:a17:90b:4fd0:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ece:b0:2ea:3f34:f18d
 with SMTP id 98e67ed59e1d1-2f28fb6e6e6mr21248228a91.10.1734367847198; Mon, 16
 Dec 2024 08:50:47 -0800 (PST)
Date: Mon, 16 Dec 2024 08:50:45 -0800
In-Reply-To: <gvam6amt25mlvpxlpcra2caesdfpr5a75cba3e4n373tzqld3k@ciutribtvmjj>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <jGQc86Npv2BVcA61A7EPFQYcclIuxb07m-UqU0w22FA8_o3-0_xc6OQPp_CHDBZhId9acH4hyiOqki9w7Q0-WmuoVqsCoQfefaHNdfcV2ww=@ranguvar.io>
 <20241214185248.GE10560@noisy.programming.kicks-ass.net> <gvam6amt25mlvpxlpcra2caesdfpr5a75cba3e4n373tzqld3k@ciutribtvmjj>
Message-ID: <Z2BaZSKtaAPGSCqb@google.com>
Subject: Re: [REGRESSION][BISECTED] from bd9bbc96e835: cannot boot Win11 KVM guest
From: Sean Christopherson <seanjc@google.com>
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ranguvar <ranguvar@ranguvar.io>, 
	Juri Lelli <juri.lelli@gmail.com>, 
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>, 
	"regressions@leemhuis.info" <regressions@leemhuis.info>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 16, 2024, Juri Lelli wrote:
> On 14/12/24 19:52, Peter Zijlstra wrote:
> > On Sat, Dec 14, 2024 at 06:32:57AM +0000, Ranguvar wrote:
> > > Hello, all,
> > > 
> > > Any assistance with proper format and process is appreciated as I am new
> > > to these lists.  After the commit bd9bbc96e835 "sched: Rework dl_server"
> > > I am no longer able to boot my Windows 11 23H2 guest using
> > > pinned/exclusive CPU cores and passing a PCIe graphics card.  This setup
> > > worked for me since at least 5.10, likely earlier, with minimal changes.
> > > 
> > > Most or all cores assigned to guest VM report 100% usage, and many tasks
> > > on the host hang indefinitely (10min+) until the guest is forcibly
> > > stopped.  This happens only once the Windows kernel begins loading - its
> > > spinner appears and freezes.
> > > 
> > > Still broken on 6.13-rc2, as well as 6.12.4 from Arch's repository.  When
> > > testing these, the failure is similar, but tasks on the host are slow to
> > > execute instead of stalling indefinitely, and hung tasks are not reported
> > > in dmesg. Only one guest core may show 100% utilization instead of many
> > > or all of them. This seems to be due to a separate regression which also
> > > impacts my usecase [0].  After patching it [1], I then find the same
> > > behavior as bd9bbc96e835, with hung tasks on host.
> > > 
> > > git bisect log: [2]
> > > dmesg from 6.11.0-rc1-1-git-00057-gbd9bbc96e835, with decoded hung task backtraces: [3]
> > > dmesg from arch 6.12.4: [4]
> > > dmesg from arch 6.12.4 patched for svm.c regression, has hung tasks, backtraces could not be decoded: [5]
> > > config for 6.11.0-rc1-1-git-00057-gbd9bbc96e835: [6]
> > > config for arch 6.12.4: [7]
> > > 
> > > If it helps, my host uses an AMD Ryzen 5950X CPU with latest UEFI and AMD
> > > WX 5100 (Polaris, GCN 4.0) PCIe graphics.  I use libvirt 10.10 and qemu
> > > 9.1.2, and I am passing three PCIe devices each from dedicated IOMMU
> > > groups: NVIDIA RTX 3090 graphics, a Renesas uPD720201 USB controller, and
> > > a Samsung 970 EVO NVMe disk.
> > > 
> > > I have in kernel cmdline `iommu=pt isolcpus=1-7,17-23 rcu_nocbs=1-7,17-23
> > > nohz_full=1-7,17-23`.  Removing iommu=pt does not produce a change, and
> > > dropping the core isolation freezes the host on VM startup.

As in, dropping all of isolcpus, rcu_nocbs, and nohz_full?  Or just dropping
isolcpus?

> > > Enabling/disabling kvm_amd.nested or kvm.enable_virt_at_load did not
> > > produce a change.
> > > 
> > > Thank you for your attention.
> > > - Devin
> > > 
> > > #regzbot introduced: bd9bbc96e8356886971317f57994247ca491dbf1
> > > 
> > > [0]: https://lore.kernel.org/regressions/52914da7-a97b-45ad-86a0-affdf8266c61@mailbox.org/
> > > [1]: https://lore.kernel.org/regressions/376c445a-9437-4bdd-9b67-e7ce786ae2c4@mailbox.org/
> > > [2]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/bisect.log
> > > [3]: https://ranguvar.io/pub/paste/linux-6.12-vm-regression/dmesg-6.11.0-rc1-1-git-00057-gbd9bbc96e835-decoded.log
> > 
> > Hmm, this has:
> > 
> > [  978.035637] sched: DL replenish lagged too much
> > 
> > Juri, have we seen that before?
> 
> Not in the context of dl_server. Hummm, looks like replenishment wasn't
> able to catch up with the clock or something like that (e.g.
> replenishment didn't happen for a long time).

I don't see anything in the logs that suggests KVM is doing something funky.  My
guess is that the issue is related to isolcpus+rcu_nocbs+nohz_full, and that KVM
setups are one of the more common use cases for such configurations.  But that's
just a wild guess on my part.

The hang from [4] occurs because KVM can't complete a memslot update.  Given that
this shows up with GPU passthrough, odds are good the guest is trying to relocate
a GPU bar and the relocation hangs because the KVM-side update hangs.

There are some interesting/unique paths in KVM's memslot code, but this is a
simple hang on SRCU synchronization.

   INFO: task CPU 0/KVM:2134 blocked for more than 122 seconds.
         Not tainted 6.11.0-rc1-1-git-00057-gbd9bbc96e835 #12
   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   task:CPU 0/KVM       state:D stack:0     pid:2134  tgid:2114  ppid:1      flags:0x00004002
   Call Trace:
    <TASK>
   __schedule (kernel/sched/core.c:5258 kernel/sched/core.c:6594) 
   schedule (./arch/x86/include/asm/preempt.h:84 (discriminator 13) kernel/sched/core.c:6672 (discriminator 13) kernel/sched/core.c:6686 (discriminator 13)) 
   schedule_timeout (kernel/time/timer.c:2558) 
   wait_for_completion (kernel/sched/completion.c:96 kernel/sched/completion.c:116 kernel/sched/completion.c:127 kernel/sched/completion.c:148) 
   __synchronize_srcu (kernel/rcu/srcutree.c:1408) 
   kvm_swap_active_memslots+0x133/0x180 kvm
   kvm_set_memslot+0x3de/0x680 kvm
   kvm_vm_ioctl+0x11da/0x18d0 kvm
   __x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:907 fs/ioctl.c:893 fs/ioctl.c:893) 
   do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1) arch/x86/entry/common.c:83 (discriminator 1)) 

And in [5], the host hang that first pops is also on wait_for_completion(), in
code that is potentially trying to queue work on all CPUs (I've no idea if
cpu_needs_drain() can be true on the isolated CPUs).

	cpumask_clear(&has_work);
	for_each_online_cpu(cpu) {
		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);

		if (cpu_needs_drain(cpu)) {
			INIT_WORK(work, lru_add_drain_per_cpu);
			queue_work_on(cpu, mm_percpu_wq, work);
			__cpumask_set_cpu(cpu, &has_work);
		}
	}

	for_each_cpu(cpu, &has_work)
		flush_work(&per_cpu(lru_add_drain_work, cpu));

  sched: DL replenish lagged too much
  systemd[1]: Starting Cleanup of Temporary Directories...
  systemd[1]: systemd-tmpfiles-clean.service: Deactivated successfully.
  systemd[1]: Finished Cleanup of Temporary Directories.
  systemd[1]: systemd-journald.service: State 'stop-watchdog' timed out. Killing.
  systemd[1]: systemd-journald.service: Killing process 647 (systemd-journal) with signal SIGKILL.
  systemd[1]: Starting system activity accounting tool...
  systemd[1]: sysstat-collect.service: Deactivated successfully.
  systemd[1]: Finished system activity accounting tool.
  INFO: task khugepaged:263 blocked for more than 122 seconds.
        Not tainted 6.12.4-arch1-1 #1
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:khugepaged      state:D stack:0     pid:263   tgid:263   ppid:2      flags:0x00004000
  Call Trace:
   <TASK>
   __schedule+0x3b0/0x12b0
   schedule+0x27/0xf0
   schedule_timeout+0x12f/0x160
   wait_for_completion+0x86/0x170
   __flush_work+0x1bf/0x2c0
   __lru_add_drain_all+0x13e/0x1e0
   khugepaged+0x66/0x930
   kthread+0xd2/0x100
   ret_from_fork+0x34/0x50
   ret_from_fork_asm+0x1a/0x30
   </TASK>

