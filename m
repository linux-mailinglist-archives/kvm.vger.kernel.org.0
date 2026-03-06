Return-Path: <kvm+bounces-73013-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHwxKaapqmniVAEAu9opvQ
	(envelope-from <kvm+bounces-73013-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BC52121E8F7
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 11:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D741F3024BD6
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 10:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A3337CD50;
	Fri,  6 Mar 2026 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xmt0GMjh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5CD37C11F;
	Fri,  6 Mar 2026 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772792194; cv=none; b=N90kJnDse/ZZWfGKV/u05Uz1ePyJU9XNYSSjqtMhq6i/zNHYcO5/rxvyBzu978EpJ14bJ3cBaoIhEm37XKkA7P43HXZPyduyd8n89KYmoCABaM+hNs0thPhSa9IwTlzSsUVeYkghLLLVJlU/Pj6YK81fHveQrf7mY59OXN3E0No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772792194; c=relaxed/simple;
	bh=KcgMfF7ZM4VqH7fJnj+rSnyOLy++ifGMapgl61iKpgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHAafdN7823i8fQqy4OUXVVs+YXcA20ffhPDYmNUD4CoPHvcDI27+d5OCDqvd/RSmcXpOQ1tVHwkkVXtlQsswC1Pr5RMj7+W6f7MmS9VuA8A0wSF3t9mH+Y9kAMG2lyPjX8H1gGh4svSs4PK40czLpWh4ko+aa3SbbKtI7XURMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xmt0GMjh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58644C2BC9E;
	Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792193;
	bh=KcgMfF7ZM4VqH7fJnj+rSnyOLy++ifGMapgl61iKpgQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xmt0GMjhpqh5cAK7MhORAl/l38pmJgOpJPUGYUgBzUO11vPC9s+aAuH+W2AFxhx55
	 RB1fI0kEb31KIAoq5pBEoxrhqWLiHcVNa4/toH1xlLD+vJu1U1bwizV5rPCc73GMT/
	 mWblRctVi1RRnncX/901QqNuXtld/naPNkmQGOfq5LJTQBZSy6bv2HfXovrki+Byik
	 5xPPre1UDK4Yi9c3fBY02wVimAT1nisRi4ISkLlpYKNedWIFJwP2Bsye9GoMxfmQe0
	 CnntTkhHdO2AzblmtPqBUdTxKEy7tIyp/GSIIMPQ68VIicNlWmmlI/JthbfRCYIRlJ
	 CxTa4S2iZryiA==
Message-ID: <babe39d9-aeb4-47ae-83fb-eae6193fb3aa@kernel.org>
Date: Fri, 6 Mar 2026 11:16:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
To: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Matthieu Baerts <matttbe@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <87qzpx2sck.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC52121E8F7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73013-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jirislaby@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 06. 03. 26, 10:57, Thomas Gleixner wrote:
> On Fri, Mar 06 2026 at 06:48, Jiri Slaby wrote:
>> On 05. 03. 26, 20:25, Thomas Gleixner wrote:
>>> Is there simple way to reproduce?
>>
>> Unfortunately not at all. To date, I even cannot reproduce locally, it
>> reproduces exclusively in opensuse build service (and github CI as per
>> Matthieu's report). I have a project in there with packages which fail
>> more often than others:
>>     https://build.opensuse.org/project/monitor/home:jirislaby:softlockup
>> But it's all green ATM.
>>
>> Builds of Go 1.24 and tests of rust 1.90 fail the most. The former even
>> takes only ~ 8 minutes, so it's not that intensive build at all. So the
>> reasons are unknown to me. At least, Go apparently uses threads for
>> building (unlike gcc/clang with forks/processes). Dunno about rust.
> 
> I tried with tons of test cases which stress test mmcid with threads and
> failed.

Me too, with many artificial pthread or fork or combined loads/bombs 
with loops and yields.

I was once successful to see the failure in a local build of Go: using 
"osc build --vm-type=kvm" which is what the build service (see below) calls.

It's extremely hard to hit it locally. So there is likely some rather 
small race window or whatnot.

> Can you provide me your .config

Sure, it's the standard openSUSE kernel, i.e.:
https://github.com/openSUSE/kernel-source/blob/9c1596772e0/config/x86_64/default

source version,

It happens with 6.19+, the current failures are with the commit above 
which is 6.19.5.

I added 7.0-rc2 as well now to:
   https://build.opensuse.org/project/monitor/home:jirislaby:softlockup

Well, it already failed for Go:
  
https://build.opensuse.org/package/live_build_log/home:jirislaby:softlockup/go1.24/617/x86_64

So at least it is consistent, and not stable tree related ;).


If that helps, I would be likely able to "bisect" the 4 your mm_cid 
patches if they can be reverted on the top of 6.19 easily. (By letting 
the kernel run in the build service.)

> VM setup (Number of CPUs, memory etc.)?

For example, the currently failing build:
https://build.opensuse.org/package/live_build_log/home:jirislaby:softlockup/rust1.90:test/openSUSE_Factory/x86_64

says:
[   10s] /usr/bin/qemu-kvm -nodefaults -no-reboot -nographic -vga none 
-cpu host -M pc,accel=kvm,usb=off,dump-guest-core=off,vmport=off 
-sandbox on -bios /usr/share/qemu/qboot.rom -object 
rng-random,filename=/dev/random,id=rng0 -device virtio-rng-pci,rng=rng0 
-object iothread,id=io0 -run-with user=qemu -net none -kernel 
/var/cache/obs/worker/root_4/.mount/boot/kernel -initrd 
/var/cache/obs/worker/root_4/.mount/boot/initrd -append 
root=/dev/disk/by-id/virtio-0 rootfstype=ext4 rootflags=noatime 
elevator=noop nmi_watchdog=0 rw ia32_emulation=1 oops=panic panic=1 
quiet console=hvc0 init=/.build/build -m 40960 -drive 
file=/var/cache/obs/worker/root_4/root,format=raw,if=none,id=disk,cache=unsafe,aio=io_uring 
-device virtio-blk-pci,iothread=io0,drive=disk,serial=0 -drive 
file=/var/cache/obs/worker/root_4/swap,format=raw,if=none,id=swap,cache=unsafe,aio=io_uring 
-device virtio-blk-pci,iothread=io0,drive=swap,serial=1 -device 
virtio-serial,max_ports=2 -device virtconsole,chardev=virtiocon0 
-chardev stdio,mux=on,id=virtiocon0 -mon chardev=virtiocon0 -chardev 
socket,id=monitor,server=on,wait=off,path=/var/cache/obs/worker/root_4/root.qemu/monitor 
-mon chardev=monitor,mode=readline -smp 12



The with-7.0-rc2 Go fail above runs:

[    4s] /usr/bin/qemu-kvm -nodefaults -no-reboot -nographic -vga none 
-cpu host -M pc,accel=kvm,usb=off,dump-guest-core=off,vmport=off 
-sandbox on -bios /usr/share/qemu/qboot.rom -object 
rng-random,filename=/dev/random,id=rng0 -device virtio-rng-pci,rng=rng0 
-object iothread,id=io0 -run-with user=qemu -net none -kernel 
/var/cache/obs/worker/root_12/.mount/boot/kernel -initrd 
/var/cache/obs/worker/root_12/.mount/boot/initrd -append 
root=/dev/disk/by-id/virtio-0 rootfstype=ext4 rootflags=noatime 
elevator=noop nmi_watchdog=0 rw ia32_emulation=1 oops=panic panic=1 
quiet console=hvc0 init=/.build/build -m 16384 -drive 
file=/var/cache/obs/worker/root_12/root,format=raw,if=none,id=disk,cache=unsafe,aio=io_uring 
-device virtio-blk-pci,iothread=io0,drive=disk,serial=0 -drive 
file=/var/cache/obs/worker/root_12/swap,format=raw,if=none,id=swap,cache=unsafe,aio=io_uring 
-device virtio-blk-pci,iothread=io0,drive=swap,serial=1 -device 
virtio-serial,max_ports=2 -device virtconsole,chardev=virtiocon0 
-chardev stdio,mux=on,id=virtiocon0 -mon chardev=virtiocon0 -chardev 
socket,id=monitor,server=on,wait=off,path=/var/cache/obs/worker/root_12/root.qemu/monitor 
-mon chardev=monitor,mode=readline -smp 4



> I tried to find it on that github page Matthiue mentioned but I'm
> probably too stupid to navigate this clicky interface.

I haven't looked into the details of the github failure yet...

thanks,
-- 
js
suse labs

