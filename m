Return-Path: <kvm+bounces-72336-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sC71CEEgpWnd3wUAu9opvQ
	(envelope-from <kvm+bounces-72336-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 06:29:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C561D3178
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 06:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92EA7302924A
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 05:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2C4314D35;
	Mon,  2 Mar 2026 05:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ep7PnoiU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD5D30DD2A;
	Mon,  2 Mar 2026 05:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772429324; cv=none; b=gXFkeqRHJ4/Q5H7Df7lVLEcBJMKwwQ2VcDQQT3FJArytBv/pS+czd0e1bSdhgxAYfrZLI8kAPp/G4CjEAG5Y3ffOLzpRl2bcN0ke0htxpGwG8nxOho5URHOKjWDkriMsCUacSmkqS7GonGCGFRTUjGFtmkkRqMVbzaOdQGp6o3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772429324; c=relaxed/simple;
	bh=ZCT89nZPytlep91Zs1EEAPJcdzZJoMlFmYgtrRCKYcc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CrLUF77NGEAnkqATf4zd1bVVfeJbrv4L+ONXTFigENWVN64MCbmvpPZD+PZPf6GffDuP92U8xkehZz1gB41eFGkEQzW/eg7bmxigF5eZ6+HMsnz9AurTgAVOtJ2tKgnpMlPBWaPeOShFMddKdPtG0rkRT4cXW4D9i5S9efo440k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ep7PnoiU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72851C19423;
	Mon,  2 Mar 2026 05:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772429323;
	bh=ZCT89nZPytlep91Zs1EEAPJcdzZJoMlFmYgtrRCKYcc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Ep7PnoiUspZc4/Jgkwm3a30OfkVeOUprThRQzgloQhmtv2uWj0rveePhgYnNuPj4U
	 ZPYyqSzP1yqtLW387FYa58Ruxm+8S6rl0Nqa5i32PRMohiuHdJXMqGYlPqesgcueoX
	 /CQotlEauRIfYkXITVaNprMjbJLAEWI3Gwqb5SNNZXFR0Kj9VKJJtKf/r8kUnXECZd
	 0TEU0mmPgUwiA7UZ+zlgob+bVPTFhRz3ID3LTUtfVioYHhhedwTlTCnImpPjxBBosp
	 r6XwRvpYv1CWS0y8J4wuHeiB6MuKoLsOdZPy+ptOfocBcMBXWdnA7vLm72R8WrqBwL
	 ENlvGJsyqyymQ==
Message-ID: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
Date: Mon, 2 Mar 2026 06:28:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
From: Jiri Slaby <jirislaby@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev,
 Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
 MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72336-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jirislaby@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url]
X-Rspamd-Queue-Id: 76C561D3178
X-Rspamd-Action: no action

On 26. 02. 26, 11:37, Jiri Slaby wrote:
> On 06. 02. 26, 12:54, Matthieu Baerts wrote:
>> Our CI for the MPTCP subsystem is now regularly hitting various stalls
>> before even starting the MPTCP test suite. These issues are visible on
>> top of the latest net and net-next trees, which have been sync with
>> Linus' tree yesterday. All these issues have been seen on a "public CI"
>> using GitHub-hosted runners with KVM support, where the tested kernel is
>> launched in a nested (I suppose) VM. I can see the issue with or without
>> debug.config. According to the logs, it might have started around
>> v6.19-rc0, but I was unavailable for a few weeks, and I couldn't react
>> quicker, sorry for that. Unfortunately, I cannot reproduce this locally,
>> and the CI doesn't currently have the ability to execute bisections.
> 
> Hmm, after the switch of the qemu guest kernels to 6.19, our (opensuse) 
> build service is stalling in smp_call_function_many_cond() randomly too:
> https://bugzilla.suse.com/show_bug.cgi?id=1258936
> 
> The attachment from there contains sysrq-t logs too:
> https://bugzilla.suse.com/attachment.cgi?id=888612

A small update. Just in case this rings a bell somewhere.

We have a qemu mem dump from the affected kernel. It shows that both 
CPU0 and CPU1 are waiting for CPU2's rq lock. CPU2 is in userspace.




crash> bt -xsc 0
PID: 6483     TASK: ffff8d1759c20000  CPU: 0    COMMAND: "compile"
     [exception RIP: native_halt+14]
     RIP: ffffffffb9d1124e  RSP: ffffcead0696f9a0  RFLAGS: 00000046
     RAX: 0000000000000003  RBX: 0000000000040000  RCX: 00000000fffffff8
     RDX: ffff8d1a7ffc5140  RSI: 0000000000000003  RDI: ffff8d1a6fd35dc0
     RBP: ffff8d1a6fd35dc0   R8: ffff8d1a6fc36dc0   R9: fffffffffffffff8
     R10: 0000000000000000  R11: 0000000000000004  R12: ffff8d1a6fc36dc0
     R13: 0000000000000000  R14: ffff8d1a7ffc5140  R15: ffffcead0696fad0
     CS: 0010  SS: 0018
  #0 [ffffcead0696f9a0] kvm_wait+0x44 at ffffffffb9d0fe54
  #1 [ffffcead0696f9a8] __pv_queued_spin_lock_slowpath+0x247 at 
ffffffffbaafb507
  #2 [ffffcead0696f9d8] _raw_spin_lock+0x29 at ffffffffbaafadf9
  #3 [ffffcead0696f9e0] raw_spin_rq_lock_nested+0x1c at ffffffffb9d8c12c
  #4 [ffffcead0696f9f8] _raw_spin_rq_lock_irqsave+0x17 at ffffffffb9d96ca7
  #5 [ffffcead0696fa08] sched_balance_rq+0x56d at ffffffffb9da718d
  #6 [ffffcead0696fb18] pick_next_task_fair+0x240 at ffffffffb9da7e00
  #7 [ffffcead0696fb88] __schedule+0x19e at ffffffffbaaf00de
  #8 [ffffcead0696fc40] schedule+0x27 at ffffffffbaaf1697
  #9 [ffffcead0696fc50] futex_do_wait+0x4a at ffffffffb9e61c5a
#10 [ffffcead0696fc68] __futex_wait+0x8e at ffffffffb9e6241e
#11 [ffffcead0696fd30] futex_wait+0x6b at ffffffffb9e624fb
#12 [ffffcead0696fdc0] do_futex+0xc5 at ffffffffb9e5e305
#13 [ffffcead0696fdc8] __x64_sys_futex+0x112 at ffffffffb9e5e932
#14 [ffffcead0696fe38] do_syscall_64+0x81 at ffffffffbaae2a61
#15 [ffffcead0696ff40] entry_SYSCALL_64_after_hwframe+0x76 at 
ffffffffb9a0012f
     RIP: 0000000000495303  RSP: 000000c000073c98  RFLAGS: 00000286
     RAX: ffffffffffffffda  RBX: 0000000000000000  RCX: 0000000000495303
     RDX: 0000000000000000  RSI: 0000000000000080  RDI: 000000c000058958
     RBP: 000000c000073ce0   R8: 0000000000000000   R9: 0000000000000000
     R10: 0000000000000000  R11: 0000000000000286  R12: 0000000000000024
     R13: 0000000000000001  R14: 000000c000002c40  R15: 0000000000000001
     ORIG_RAX: 00000000000000ca  CS: 0033  SS: 002b


crash> bt -xsc 1
PID: 6481     TASK: ffff8d1759c8b680  CPU: 1    COMMAND: "compile"
     [exception RIP: __pv_queued_spin_lock_slowpath+190]
     RIP: ffffffffbaafb37e  RSP: ffffcead000f8b38  RFLAGS: 00000046
     RAX: 0000000000000001  RBX: 0000000000000000  RCX: 0000000000000001
     RDX: 0000000000040003  RSI: 0000000000040003  RDI: ffff8d1a6fd35dc0
     RBP: ffff8d1a6fd35dc0   R8: 0000000000000000   R9: 00000001000c3f60
     R10: ffffffffbbc75960  R11: ffffcead000f8a48  R12: ffff8d1a6fcb6dc0
     R13: 0000000000000001  R14: 0000000000000000  R15: ffffffffbbe65940
     CS: 0010  SS: 0000
  #0 [ffffcead000f8b60] _raw_spin_lock+0x29 at ffffffffbaafadf9
  #1 [ffffcead000f8b68] raw_spin_rq_lock_nested+0x1c at ffffffffb9d8c12c
  #2 [ffffcead000f8b80] _raw_spin_rq_lock_irqsave+0x17 at ffffffffb9dc9cc7
  #3 [ffffcead000f8b90] print_cfs_rq+0xce at ffffffffb9dd0d8e
  #4 [ffffcead000f8c98] print_cfs_stats+0x62 at ffffffffb9da9ee2
  #5 [ffffcead000f8cc8] print_cpu+0x243 at ffffffffb9dcbe73
  #6 [ffffcead000f8d00] sysrq_sched_debug_show+0x2e at ffffffffb9dd1b7e
  #7 [ffffcead000f8d18] show_state_filter+0xcd at ffffffffb9d91f4d
  #8 [ffffcead000f8d40] sysrq_handle_showstate+0x10 at ffffffffba60b750
  #9 [ffffcead000f8d48] __handle_sysrq.cold+0x9b at ffffffffb9c4f486
#10 [ffffcead000f8d70] sysrq_filter+0xd7 at ffffffffba60c237
#11 [ffffcead000f8d98] input_handle_events_filter+0x45 at ffffffffba766c05
#12 [ffffcead000f8dd0] input_pass_values+0x134 at ffffffffba766ec4
#13 [ffffcead000f8e00] input_event_dispose+0x156 at ffffffffba767046
#14 [ffffcead000f8e20] input_event+0x58 at ffffffffba76ac18
#15 [ffffcead000f8e50] atkbd_receive_byte+0x64d at ffffffffba772e6d
#16 [ffffcead000f8ea8] ps2_interrupt+0x9d at ffffffffba7665ed
#17 [ffffcead000f8ed0] serio_interrupt+0x4f at ffffffffba761e0f
#18 [ffffcead000f8f00] i8042_handle_data+0x11c at ffffffffba76316c
#19 [ffffcead000f8f40] i8042_interrupt+0x11 at ffffffffba763581
#20 [ffffcead000f8f50] __handle_irq_event_percpu+0x55 at ffffffffb9df1e15
#21 [ffffcead000f8f90] handle_irq_event+0x38 at ffffffffb9df2058
#22 [ffffcead000f8fb0] handle_edge_irq+0xc5 at ffffffffb9df7b95
#23 [ffffcead000f8fd0] __common_interrupt+0x44 at ffffffffb9cc2354
#24 [ffffcead000f8ff0] common_interrupt+0x80 at ffffffffbaae6090
--- <IRQ stack> ---
#25 [ffffcead06bcfb98] asm_common_interrupt+0x26 at ffffffffb9a01566
     [exception RIP: smp_call_function_many_cond+304]
     RIP: ffffffffb9e63080  RSP: ffffcead06bcfc40  RFLAGS: 00000202
     RAX: 0000000000000011  RBX: 0000000000000202  RCX: ffff8d1a6fc3f800
     RDX: 0000000000000000  RSI: 0000000000000000  RDI: 0000000000000000
     RBP: 0000000000000001   R8: ffff8d174009cc30   R9: 0000000000000000
     R10: ffff8d174009c0d8  R11: 0000000000000000  R12: 0000000000000001
     R13: 0000000000000003  R14: ffff8d1a6fcb7280  R15: 0000000000000001
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
#26 [ffffcead06bcfcb0] on_each_cpu_cond_mask+0x24 at ffffffffb9e634f4
#27 [ffffcead06bcfcb8] flush_tlb_mm_range+0x1b1 at ffffffffb9d225d1
#28 [ffffcead06bcfd08] ptep_clear_flush+0x93 at ffffffffba066e13
#29 [ffffcead06bcfd30] do_wp_page+0x6a2 at ffffffffba04c692
#30 [ffffcead06bcfdb8] __handle_mm_fault+0xa49 at ffffffffba055c79
#31 [ffffcead06bcfe98] handle_mm_fault+0xe7 at ffffffffba056297
#32 [ffffcead06bcfed8] do_user_addr_fault+0x21a at ffffffffb9d1db6a
#33 [ffffcead06bcff18] exc_page_fault+0x69 at ffffffffbaae99c9
#34 [ffffcead06bcff40] asm_exc_page_fault+0x26 at ffffffffb9a012a6
     RIP: 000000000042351c  RSP: 000000c0013aafd0  RFLAGS: 00010246
     RAX: 0000000000000002  RBX: 00000000017584c0  RCX: 0000000000000000
     RDX: 0000000000000005  RSI: 000000000163edc0  RDI: 0000000000000003
     RBP: 000000c0013ab080   R8: 0000000000000001   R9: 00007f0d9853f800
     R10: 00007f0d98334e00  R11: 00007f0d98afa020  R12: 00007f0d98afa020
     R13: 0000000000000050  R14: 000000c000002380  R15: 0000000000000001
     ORIG_RAX: ffffffffffffffff  CS: 0033  SS: 002b
     RIP: 000000000042351c  RSP: 000000c0013aafd0  RFLAGS: 00010246
     RAX: 0000000000000002  RBX: 00000000017584c0  RCX: 0000000000000000
     RDX: 0000000000000005  RSI: 000000000163edc0  RDI: 0000000000000003
     RBP: 000000c0013ab080   R8: 0000000000000001   R9: 00007f0d9853f800
     R10: 00007f0d98334e00  R11: 00007f0d98afa020  R12: 00007f0d98afa020
     R13: 0000000000000050  R14: 000000c000002380  R15: 0000000000000001
     ORIG_RAX: ffffffffffffffff  CS: 0033  SS: 002b



crash> bt -xsc 2
PID: 6540     TASK: ffff8d1773ae3680  CPU: 2    COMMAND: "compile"
     RIP: 0000000000495372  RSP: 000000c00003e000  RFLAGS: 00000206
     RAX: 0000000000000000  RBX: 0000000000000003  RCX: 0000000000495372
     RDX: 0000000000000000  RSI: 000000c00003e000  RDI: 00000000000d0f00
     RBP: 00007ffcf8a71aa8   R8: 000000c00005a090   R9: 000000c000002700
     R10: 0000000000000000  R11: 0000000000000206  R12: 0000000000491580
     R13: 000000c00005a008  R14: 00000000017222e0  R15: ffffffffffffffff
     ORIG_RAX: 0000000000000038  CS: 0033  SS: 002b



The state of the lock:

crash> struct rq.__lock -x ffff8d1a6fd35dc0
   __lock = {
     raw_lock = {
       {
         val = {
           counter = 0x40003
         },
         {
           locked = 0x3,
           pending = 0x0
         },
         {
           locked_pending = 0x3,
           tail = 0x4
         }
       }
     }
   },


thanks,
-- 
js
suse labs


