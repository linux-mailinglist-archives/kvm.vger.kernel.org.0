Return-Path: <kvm+bounces-26105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278D89713E5
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 11:36:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4881284F85
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 09:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71441B7901;
	Mon,  9 Sep 2024 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=clever-cloud.com header.i=@clever-cloud.com header.b="W9O/JWrX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B81B78F8
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725874400; cv=none; b=A5TzXyoc+Lvh87fi46L53qd8BFHwVwWEO8Z0dvpkrJTgXuF3RA7Sc4ILJSGe480EPTvs3j2n1W1ODVzQ6gw4bq2/I7yIWzKfktl7kgxA+jtR+gPqGlD4LYY6mDFY9zlqr9symHtgiR9l/NGdpH5md0kwB/pEk1MkHkDubnbX5AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725874400; c=relaxed/simple;
	bh=U502pxvteMv6NC/yAOfZ73UBXzTGYZhT9/eop8Qdx9k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=p3jbNGDvcAVwiRhz/e8dOy1r2OD8NZ5RzvAW2EbBgr/jvgMFvOm4a10zugPYnNlqowzmlsU4rS6SE5r7JffWMbfvv5gWBsyqTZhrAVMemqNfaiqGcsb0AqlnT6YEP+4JPQ2glfIHebVyq4oIV4cVPrexIWiKXVyPCczXzYw59V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=clever-cloud.com; spf=pass smtp.mailfrom=clever-cloud.com; dkim=pass (2048-bit key) header.d=clever-cloud.com header.i=@clever-cloud.com header.b=W9O/JWrX; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=clever-cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=clever-cloud.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d5f5d8cc01so2773291a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=clever-cloud.com; s=google; t=1725874397; x=1726479197; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aKuFNr1L5Ufqfrn7VlHdPR0IRVu8hXrKTZWESEd4/CE=;
        b=W9O/JWrXNWiabLyAEqk/huiL4g/a7VRChCYlGfRV/8Am6bqRLlRXFf2K5LALHVEGYT
         Hl9eHiuGszp3WmbrGtI2TUQGhVfWdAp9NZ6erS7Zm7xVpEiDBEWUrY+wjxjx+A9HfZBq
         yUnw0bOEKYCt8MwwCQa6OE6Tr7v3Sp8kc7q7VqELwiEykWR2C7gF7yhAPwcYzAhoJ0Qo
         CdLmWP/YxTou7zlP9I8wC4lpofoy7dYZLSwhKSVNJ/li5ECrH4jOMv2qk/21WHubM94X
         wRXjLSFeN6gPBdICl9lJSW5xscM7k7HZme99eSBD4PqwoP7qML6FOXTTBMtiaFMCAeJf
         4iGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725874397; x=1726479197;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aKuFNr1L5Ufqfrn7VlHdPR0IRVu8hXrKTZWESEd4/CE=;
        b=g9ZM5+LPW843GYdjold7mIVXwWOwCAvKBCyuHYQaQIxX21p1AE0Wez9Fqp8cGu7eV8
         HtAnd98rltvSw5rKzEnH863rCMsZByK25OjX8KTRIn0V/jxmSVzgV7rUt5AaW3X9du93
         WRZ/4wQ8SBKQaAkip+w/M9FFfqmTbrZJUMEmpVwAwff3uhQVzsQcDeyCzIwReS3dj27G
         ZkZcxorE2tNSfc76vjQoCgkCLiwHY8P2Nf0mP29/fLmSFD91CUTPEE9JPSVvXf2ugUGa
         nPtBWOOxRMFaEN1BbZn3FUhmj/L33pFBiuSKpweoa1nHKsRoVmrkry07OEAwrFwRelvI
         sGBA==
X-Gm-Message-State: AOJu0YzP7AY9L46Cm4qcEOoRJK0wtpRv/E3Iz7sPvvximB0u14KfyHQ8
	16QUqJS261L3PmE9EHQphtay8jW4fa/rWeGe/uHp63Mo9vF0Byp8U3xZBP9jScAvNsx/rnUz2ts
	E
X-Google-Smtp-Source: AGHT+IFXhN2gxDIApWKzpuvlb5d+EvWoab888PBpI2Oe6HngCgifGRqeIK5ve3wmaxZqNiDPqCR7xw==
X-Received: by 2002:a17:90a:8c89:b0:2c9:36bf:ba6f with SMTP id 98e67ed59e1d1-2dad4f0e52fmr15585293a91.3.1725874396579;
        Mon, 09 Sep 2024 02:33:16 -0700 (PDT)
Received: from exherswag ([2a01:e34:ec5f:fb40:444:4ec2:4805:836f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadc110527sm6184099a91.36.2024.09.09.02.33.14
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 02:33:15 -0700 (PDT)
Date: Mon, 9 Sep 2024 11:33:10 +0200
From: Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>
To: kvm@vger.kernel.org
Subject: Nested guest VM freeze with lots of spurious pages fault
Message-ID: <464ypq4jfxiwczufrfvbjrk4sornuzszosadhoupvju6c4p7fb@wthqsezyygds>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline

Hello,

I'm currently having trouble in a nested virtualized environment with L2
guests randomly "freezing" for a couple of minutes before behaving fine
again.

What we've seen is that, from time to time during certain workloads, the
guest L2 would freeze: it can be a complete freeze or partial with only
some frozen CPU. L0 and L1 hypervisors are fine during those
events and continue to operate normally.

Our setup is currently with VMWare ESXi as the L0 hypervisor, KVM as the
L1 hypervisor and the final L2 guest. We use qemu on the L1 hypervisor
to boot our L2 VM. Our L2 VM are basic systems for load balancers or
databases, web applications, ... . We are using Intel CPUs.

The VMWare L0 hypervisor is running v7.0.3 (which is the latest version
to my knowledge).

For the L1 KVM hypervisor, we've seen the issue at least with the LTS
branch (6.6.48) and the stable branch (6.10.7). We've had similar issues
on another setup more than one year ago but we didn't have time to
research it extensively, so take it with a grain of salt. But we would
have been on either 6.1 LTS or 5.15 LTS on our L1 back then.

For the L2 guest, we had the issues on both 6.8.x and current stable
6.10.7.

We've noticed the guest would often freeze during memory operations and
print kernel messages like this one:

watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [haproxy:323752]
Modules linked in:
CPU: 3 PID: 323752 Comm: haproxy Tainted: G             L
6.8.12-clevercloud-vm-dirty #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:strncpy_from_user+0x9a/0x123
Code: 85 c0 75 be 0f 1f 00 0f ae e8 49 b8 ff fe fe fe fe fe fe fe 48 89
df 48 ba 80 80 80 80 80 80 80 80 48 83 e7 f8 48 39 c7 74 5f <49> 8b 74
05 00 49 89 f1 4a 8d 0c 06 49 f7 d1 4c 21 c9 48 21 d1 74
RSP: 0018:ffffc90006037d90 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000fe0 RCX: 0000000000000000
RDX: 8080808080808080 RSI: ffffffff81000000 RDI: 0000000000000fe0
RBP: ffff88810110e020 R08: fefefefefefefeff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000fe0
R13: 00005635358a6f90 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f13dd136280(0000) GS:ffff888333b80000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056353597f710 CR3: 000000018d1c6004 CR4: 0000000000170ef0
Call Trace:
  <IRQ>
  ? watchdog_timer_fn+0x1b1/0x21e
  ? __hrtimer_run_queues+0xd4/0x16d
  ? hrtimer_interrupt+0x8d/0x15f
  ? __sysvec_apic_timer_interrupt+0x8c/0xd2
  ? sysvec_apic_timer_interrupt+0x5f/0x79
  </IRQ>
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? 0xffffffff81000000
  ? strncpy_from_user+0x9a/0x123
  getname_flags+0x64/0x1a5
  vfs_fstatat+0x54/0x89
  __do_sys_newfstatat+0x43/0x7a
  do_syscall_64+0x80/0xe2
  ? clear_bhb_loop+0x45/0xa0
  ? clear_bhb_loop+0x45/0xa0
  ? clear_bhb_loop+0x45/0xa0
  ? clear_bhb_loop+0x45/0xa0
  ? clear_bhb_loop+0x45/0xa0
  entry_SYSCALL_64_after_hwframe+0x78/0x80
RIP: 0033:0x7f13dc8c8ffe
Code: 0f 1f 40 00 48 8b 15 09 4e 0e 00 f7 d8 64 89 02 b8 ff ff ff ff c3
66 0f 1f 44 00 00 f3 0f 1e fa 41 89 ca b8 06 01 00 00 0f 05 <3d> 00 f0
ff ff 77 0b 31 c0 c3 0f 1f 84 00 00 00 00 00 48 8b 15 d1
RSP: 002b:00007ffdc20faa98 EFLAGS: 00000246 ORIG_RAX: 0000000000000106
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f13dc8c8ffe
RDX: 00007ffdc20faaa0 RSI: 00005635358a6f90 RDI: 00000000ffffff9c
RBP: 00007f13d33f8640 R08: 0000000000000078 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 0000000000000000 R14: 00005635358a6f90 R15: 00005635358a6f90
  </TASK>

We have additional traces but they do not all "originate" from the VFS
subsystem, it's a bit random, sometimes it also has kcompactd in its
stacktrace.

So we started tracing what was happening with KVM on the L1 host. We
noticed that during those events, KVM would get a lot of EPT_VIOLATIONS
from the guest and treat them as spurious (those logs are not related to
the same event that produced the kernel messages above):

qemu-5791    [023] d.... 3602162.971191: kvm_entry: vcpu 7, rip
0xffffffff820fe612
qemu-5786    [029] d.... 3602162.971193: kvm_exit: vcpu 4 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5786    [029] ..... 3602162.971194: kvm_page_fault: vcpu 4 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5786    [029] ..... 3602162.971194: fast_page_fault: vcpu 4 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5786    [029] d.... 3602162.971194: kvm_entry: vcpu 4, rip
0xffffffff820fe612
qemu-5791    [023] d.... 3602162.971197: kvm_exit: vcpu 7 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5791    [023] ..... 3602162.971197: kvm_page_fault: vcpu 7 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5791    [023] ..... 3602162.971197: fast_page_fault: vcpu 7 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5791    [023] d.... 3602162.971197: kvm_entry: vcpu 7, rip
0xffffffff820fe612
qemu-5786    [029] d.... 3602162.971199: kvm_exit: vcpu 4 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5786    [029] ..... 3602162.971199: kvm_page_fault: vcpu 4 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5786    [029] ..... 3602162.971200: fast_page_fault: vcpu 4 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5786    [029] d.... 3602162.971200: kvm_entry: vcpu 4, rip
0xffffffff820fe612
qemu-5791    [023] d.... 3602162.971203: kvm_exit: vcpu 7 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5791    [023] ..... 3602162.971203: kvm_page_fault: vcpu 7 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5791    [023] ..... 3602162.971203: fast_page_fault: vcpu 7 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5791    [023] d.... 3602162.971204: kvm_entry: vcpu 7, rip
0xffffffff820fe612
qemu-5786    [029] d.... 3602162.971205: kvm_exit: vcpu 4 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5786    [029] ..... 3602162.971205: kvm_page_fault: vcpu 4 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5786    [029] ..... 3602162.971206: fast_page_fault: vcpu 4 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5786    [029] d.... 3602162.971206: kvm_entry: vcpu 4, rip
0xffffffff820fe612
qemu-5791    [023] d.... 3602162.971209: kvm_exit: vcpu 7 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5791    [023] ..... 3602162.971209: kvm_page_fault: vcpu 7 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5791    [023] ..... 3602162.971209: fast_page_fault: vcpu 7 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5791    [023] d.... 3602162.971210: kvm_entry: vcpu 7, rip
0xffffffff820fe612
qemu-5786    [029] d.... 3602162.971211: kvm_exit: vcpu 4 reason
EPT_VIOLATION rip 0xffffffff820fe612 info1 0x0000000000000184 info2
0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
qemu-5786    [029] ..... 3602162.971211: kvm_page_fault: vcpu 4 rip
0xffffffff820fe612 address 0x00000000020fe612 error_code 0x184
qemu-5786    [029] ..... 3602162.971211: fast_page_fault: vcpu 4 gva
20fe612 error_code F sptep 00000000fd98c937 old 0x61000034d4fe877 new
61000034d4fe877 spurious 1 fixed 0
qemu-5786    [029] d.... 3602162.971211: kvm_entry: vcpu 4, rip
0xffffffff820fe612


That particular event, we traced during ~200 seconds and we got a total
of 6275430 traces matching 'spurious 1' with the following repartition:

$ grep spurious ./traces | awk '{for (i=5; i<=NF; i++) printf "%s ", $i;
print ""}' | sort | uniq -c | sort -h
<snip>
5      fast_page_fault: vcpu 7 gva 1386001 error_code F sptep
00000000e955370b old 0x61000012eb86877 new 61000012eb86877
spurious 1 fixed 0
6      fast_page_fault: vcpu 0 gva 1384d26 error_code F sptep
000000004d5f1b76 old 0x61000012eb84877 new 61000012eb84877
spurious 1 fixed 0
20     fast_page_fault: vcpu 5 gva 1384d26 error_code F sptep
000000004d5f1b76 old 0x61000012eb84877 new 61000012eb84877 spurious
1 fixed 0
711132 fast_page_fault: vcpu 7 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
720948 fast_page_fault: vcpu 3 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
739082 fast_page_fault: vcpu 1 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
764741 fast_page_fault: vcpu 2 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
781260 fast_page_fault: vcpu 0 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
830163 fast_page_fault: vcpu 6 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
839176 fast_page_fault: vcpu 4 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0
888879 fast_page_fault: vcpu 5 gva 20fe612 error_code F sptep
00000000fd98c937 old 0x61000034d4fe877 new 61000034d4fe877 spurious 1
fixed 0

Also, we recorded the various /sys/kernel/debug/kvm/pf_* counters. At
the start of the event, pf_spurious was at 9020471475 and at the end, it
was at 9189105724, so a difference of 168634249. It seems like a lot and
really different than what we have collected in ftrace. Could it be
because our tracing was CPU bound and some events were lost? (we used
cat /sys/kernel/debug/tracing/tracing_pipe because we had issues with
trace-cmd but cat is usually maxed out at 100% CPU)

All pf_* counters difference between start and end of the freeze:
/sys/kernel/debug/kvm/pf_emulate: diff=0
/sys/kernel/debug/kvm/pf_fast: diff=168634218
/sys/kernel/debug/kvm/pf_fixed: diff=1181
/sys/kernel/debug/kvm/pf_guest: diff=0
/sys/kernel/debug/kvm/pf_mmio_spte_created: diff=0
/sys/kernel/debug/kvm/pf_spurious: diff=168634249
/sys/kernel/debug/kvm/pf_taken: diff=168635430

So the guest isn't really frozen because its CPU seems to try
running the same CPU instructions. The RIP of the guest displayed in the
traces doesn't change a lot, though I've seen it change from time to
time but it seemed to still be "stuck" on the same memory address.

After a certain amount of time (could be a few seconds to like 40
minutes), the guest "unfreeze" and continues operations normally.

Note: We are running the same setups on other nested environments (L0
KVM -> L1 KVM -> L2 guest, L0 XEN -> L1 KVM -> L2 guest) or even in
baremetal and never had such issue. We only encountered this with VMWare
as the L0.

The only way we could reproduce~ish the issue is by using stress-ng with
various memory stressors. Current one is "stress-ng --fault 4
--sysbadaddr 2 --memcpy 2" which produces a freeze every few
days. We did not come up with a better reproducer yet.

Would you be able to point us a direction to further investigate the
issue? We suspect an issue between VMWare memory management and our L1
kernels but our knowledge of KVM is lacking, even more in nested
virtualization.

We are able to reproduce the issue in a test environment and compile our
own kernels.

Thanks a lot for your help and time!

