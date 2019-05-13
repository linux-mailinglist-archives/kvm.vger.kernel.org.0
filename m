Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706791B7C9
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfEMOHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:07:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:33097 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbfEMOHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:07:16 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 07:07:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,465,1549958400"; 
   d="scan'208";a="171201036"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 13 May 2019 07:07:15 -0700
Date:   Mon, 13 May 2019 07:07:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Haber <mh+linux-kernel@zugschlus.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux in KVM guest segfaults when hosts runs Linux 5.1
Message-ID: <20190513140715.GB28561@linux.intel.com>
References: <20190512115302.GM3835@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190512115302.GM3835@torres.zugschlus.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 12, 2019 at 01:53:02PM +0200, Marc Haber wrote:
> Hi,
> 
> since updating my home desktop machine to kernel 5.1.1, KVM guests
> started on that machine segfault after booting:
> general protection fault: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 5.0.13-zgsrv20080 #5.0.13.20190505.0
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> Workqueue: events once_deferred
> RIP: 0010:native_read_pmc+0x2/0x10
> Code: e2 20 89 3e 48 09 d0 c3 89 f9 89 f0 0f 30 c3 66 0f 1f 84 00 00 00 00 00 89 f0 89 f9 0f 30 31 c0 c3 0f 1f 80 00 00 00 00 89 f9 <0f> 33 48 c1 e2 20 48 09 d0 c3 0f 1f 40 00 0f 20 c0 c3 66 66 2e 0f
> RSP: 0018:ffff8881b9a03e50 EFLAGS: 00010083
> RAX: 0000000000000001 RBX: ffff800000000001 RCX: 0000000000000000
> RDX: 000000000000002f RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8881b590e400 R08: ffff8881b590e400 R09: 0000000000000003
> R10: ffffe8ffffc05440 R11: 0000000000000000 R12: ffff8881b590e5d8
> R13: 0000000000000010 R14: ffff8881b590e420 R15: ffffe8ffffc05400
> FS:  0000000000000000(0000) GS:ffff8881b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9bcc5c61f8 CR3: 00000001b6a24000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  x86_perf_event_update+0x3b/0x80
>  x86_pmu_stop+0x84/0xa0
>  x86_pmu_del+0x52/0x160
>  event_sched_out.isra.59+0x95/0x190
>  group_sched_out.part.61+0x51/0xc0
>  ctx_sched_out+0xf2/0x220
>  ctx_resched+0xb8/0xc0
>  __perf_install_in_context+0x175/0x1f0
>  remote_function+0x3e/0x50
>  flush_smp_call_function_queue+0x30/0xe0
>  smp_call_function_interrupt+0x2f/0x40
>  call_function_single_interrupt+0xf/0x20
>  </IRQ>

...

> The host seems to be running fine, the KVM guest crash is reproducible.
> Both host and guest are running Debian unstable with a locally built
> kernel; the host runs 5.1.1, the guest 5.0.13. The crash also happens
> when the host is running 5.1.0; going back to 5.0.13 with the host
> allows the guest to finish bootup and run fine.
> 
> Please note that my kernel 5.1.1 image is not fully broken in KVM, I
> have update my APU machine which runs firewall and other infrastructure
> services and the guests run fine there.
> 
> The machine in question is an older box with an AMD Phenom(tm) II X6
> 1090T Processor. I guess that the issue is related to the Phenom CPU.
> 
> Any idea short of bisecting?

It's a regression introduced by commit 672ff6cff80c ("KVM: x86: Raise
#GP when guest vCPU do not support PMU").  A fix has been submitted.

https://lkml.kernel.org/r/20190508170248.15271-1-bp@alien8.de
