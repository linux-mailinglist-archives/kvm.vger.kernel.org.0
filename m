Return-Path: <kvm+bounces-72811-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPf0MupuqWnH7AAAu9opvQ
	(envelope-from <kvm+bounces-72811-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:54:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD09210EBF
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 12:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id AFEC1303AD92
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 11:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63BB0396D27;
	Thu,  5 Mar 2026 11:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKbZLE3Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88392340D91;
	Thu,  5 Mar 2026 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772711616; cv=none; b=bbfhU0DT3/dlOLDrUPJ5tjs5Bn+HVchFwaCjTb2HsSzO9IljJlRq/iMtz0bkxJyeMwj3ayBG2C1vuz85Kh8p83Q4QribgY9rswNZOikwCMeYiO0Lu6IhfkleSaJmV/X2lNMMllw49aoajEdVdnUrppsWu+cvagUbnvPCaLy1tEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772711616; c=relaxed/simple;
	bh=bHzWPu2tgqIVPOT/zW23BzJx/HTToPbjaHnOTKbgVRk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ts/twzgjL3UEwvsBksWWFwp/ioJ84RSdyHkGUEu6fFV8jGvdL2xaURs2iRVQYY+DbnW11jCqf0ULT5blHEC17k/B1ghcYiOK604DAobAAjtuEAuKk1ApxpN0BKqBWqSkEBR2gAQXCbjx0w7LEsCIYHUI08NyBjAaK5/AB6cyiu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKbZLE3Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C02C19423;
	Thu,  5 Mar 2026 11:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772711616;
	bh=bHzWPu2tgqIVPOT/zW23BzJx/HTToPbjaHnOTKbgVRk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=LKbZLE3Y6PF9tx56DlEbeoSX44T2AEAV+2S227flNu8CmWfxqE5Z3wfEEmPSBiGeG
	 k96eCs0LrUHim1RuARfMnRNxrzM4NzXUxYYjUoMyTsKdUPU0xvmkYmPxh523in+ghg
	 RrY5Aw0Fezh6bNn9KulEv8iSqxTfZ+qs64l3x1N4KZy1vyhHgeWLm9HI8aTeBWg04N
	 3cN00OMxoOa373QsliXDdluDb75VqywlA7bihO9Zo0vBVhhQKKzloHViIvrMWzCdo0
	 moLiAOmakiZ/XkGdxCZzZHGZk8jb+qeyAd0vmGTiGth0NMKagF034kUu/1/4UN8lDT
	 MxbBe/nWUzxnA==
Message-ID: <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
Date: Thu, 5 Mar 2026 12:53:31 +0100
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
To: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>
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
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAD09210EBF
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72811-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jirislaby@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:url,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 05. 03. 26, 8:00, Jiri Slaby wrote:
> On 02. 03. 26, 12:46, Peter Zijlstra wrote:
>> On Mon, Mar 02, 2026 at 06:28:38AM +0100, Jiri Slaby wrote:
>>
>>> The state of the lock:
>>>
>>> crash> struct rq.__lock -x ffff8d1a6fd35dc0
>>>    __lock = {
>>>      raw_lock = {
>>>        {
>>>          val = {
>>>            counter = 0x40003
>>>          },
>>>          {
>>>            locked = 0x3,
>>>            pending = 0x0
>>>          },
>>>          {
>>>            locked_pending = 0x3,
>>>            tail = 0x4
>>>          }
>>>        }
>>>      }
>>>    },
>>>
>>
>>
>> That had me remember the below patch that never quite made it. I've
>> rebased it to something more recent so it applies.
>>
>> If you stick that in, we might get a clue as to who is owning that lock.
>> Provided it all wants to reproduce well enough.
> 
> Thanks, I applied it, but to date it is still not accepted yet:
> https://build.opensuse.org/requests/1335893

OK, I have a first dump with the patch applied:
   __lock = {
     raw_lock = {
       {
         val = {
           counter = 0x2c0003
         },
         {
           locked = 0x3,
           pending = 0x0
         },
         {
           locked_pending = 0x3,
           tail = 0x2c
         }
       }
     }
   },

I am not sure if it is of any help?




BUT: I have another dump with LOCKDEP (but NOT the patch above). The 
kernel is again spinning in mm_get_cid(), presumably waiting for a free 
bit in the map as before [1]:


[  162.660584] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
...
[  162.661378] Sending NMI from CPU 3 to CPUs 1:
[  162.661398] NMI backtrace for cpu 1
...
[  162.661411] RIP: 0010:mm_get_cid+0x54/0xc0


7680 is active on CPU 1:
PID: 7680     TASK: ffff8cc4038525c0  CPU: 1    COMMAND: "asm"


CPU3 is waiting for the CPU1's rq_lock:
RDX: 0000000000000000  RSI: 0000000000000003  RDI: ffff8cc72fcb8500
...
  #3 [ffffd2e9c0083da0] raw_spin_rq_lock_nested+0x20 at ffffffff9339e700

crash> struct rq.__lock -x ffff8cc72fcb8500
   __lock = {
     raw_lock = {
       {
         val = {
           counter = 0x100003
         },
         {
           locked = 0x3,
           pending = 0x0
         },
         {
           locked_pending = 0x3,
           tail = 0x10
         }
       }
     },
     magic = 0xdead4ead,
     owner_cpu = 0x1,
     owner = 0xffff8cc4038b8000,
     dep_map = {
       key = 0xffffffff96245970 <__key.7>,
       class_cache = {0xffffffff9644b488 <lock_classes+10600>, 0x0},
       name = 0xffffffff94ba3ab3 "&rq->__lock",
       wait_type_outer = 0x0,
       wait_type_inner = 0x2,
       lock_type = 0x0
     }
   },

owner_cpu is 1, owner is:
PID: 7508     TASK: ffff8cc4038b8000  CPU: 1    COMMAND: "compile"

But as you can see above, CPU1 is occupied with a different task:
crash> bt -sxc 1
PID: 7680     TASK: ffff8cc4038525c0  CPU: 1    COMMAND: "asm"

spinning in mm_get_cid() as I wrote. See the objdump of mm_get_cid below.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1258936#c17


> ffffffff8139cd40 <mm_get_cid>:
> mm_get_cid():
> include/linux/cpumask.h:1020
> ffffffff8139cd40:       8b 05 9a d7 40 02       mov    0x240d79a(%rip),%eax        # ffffffff837aa4e0 <nr_cpu_ids>
> kernel/sched/sched.h:3779
> ffffffff8139cd46:       55                      push   %rbp
> ffffffff8139cd47:       53                      push   %rbx
> include/linux/mm_types.h:1477
> ffffffff8139cd48:       48 8d 9f 80 0b 00 00    lea    0xb80(%rdi),%rbx
> kernel/sched/sched.h:3780 (discriminator 2)
> ffffffff8139cd4f:       8b b7 0c 01 00 00       mov    0x10c(%rdi),%esi
> include/linux/cpumask.h:1020
> ffffffff8139cd55:       83 c0 3f                add    $0x3f,%eax
> ffffffff8139cd58:       c1 e8 03                shr    $0x3,%eax
> kernel/sched/sched.h:3780 (discriminator 2)
> ffffffff8139cd5b:       48 89 f5                mov    %rsi,%rbp
> include/linux/mm_types.h:1479 (discriminator 1)
> ffffffff8139cd5e:       25 f8 ff ff 1f          and    $0x1ffffff8,%eax
> include/linux/mm_types.h:1489 (discriminator 1)
> ffffffff8139cd63:       48 8d 3c 43             lea    (%rbx,%rax,2),%rdi
> include/linux/find.h:393
> ffffffff8139cd67:       e8 44 d8 6e 00          call   ffffffff81a8a5b0 <_find_first_zero_bit>
> kernel/sched/sched.h:3771
> ffffffff8139cd6c:       39 e8                   cmp    %ebp,%eax
> ffffffff8139cd6e:       73 7c                   jae    ffffffff8139cdec <mm_get_cid+0xac>
> ffffffff8139cd70:       89 c1                   mov    %eax,%ecx
> kernel/sched/sched.h:3773 (discriminator 1)
> ffffffff8139cd72:       89 c2                   mov    %eax,%edx
> include/linux/cpumask.h:1020
> ffffffff8139cd74:       8b 05 66 d7 40 02       mov    0x240d766(%rip),%eax        # ffffffff837aa4e0 <nr_cpu_ids>
> ffffffff8139cd7a:       83 c0 3f                add    $0x3f,%eax
> ffffffff8139cd7d:       c1 e8 03                shr    $0x3,%eax
> include/linux/mm_types.h:1479 (discriminator 1)
> ffffffff8139cd80:       25 f8 ff ff 1f          and    $0x1ffffff8,%eax
> include/linux/mm_types.h:1489 (discriminator 1)
> ffffffff8139cd85:       48 8d 04 43             lea    (%rbx,%rax,2),%rax
> arch/x86/include/asm/bitops.h:136
> ffffffff8139cd89:       f0 48 0f ab 10          lock bts %rdx,(%rax)
> kernel/sched/sched.h:3773 (discriminator 2)
> ffffffff8139cd8e:       73 4b                   jae    ffffffff8139cddb <mm_get_cid+0x9b>
> ffffffff8139cd90:       eb 5a                   jmp    ffffffff8139cdec <mm_get_cid+0xac>
> arch/x86/include/asm/vdso/processor.h:13
> ffffffff8139cd92:       f3 90                   pause
> include/linux/cpumask.h:1020
> ffffffff8139cd94:       8b 05 46 d7 40 02       mov    0x240d746(%rip),%eax        # ffffffff837aa4e0 <nr_cpu_ids>

The CPU1 was caught by the NMI here ^^^^^^^^^^^^^^^^^^^^.




> In the meantime, me and Michal K. did some digging into qemu dumps. 
> Details at (and a couple previous comments):
> https://bugzilla.suse.com/show_bug.cgi?id=1258936#c17
> 
> tl;dr:
> 
> In one of the dumps, one process sits in
>    context_switch
>      -> mm_get_cid (before switch_to())
> 
>  > 65 kworker/1:1 SP= 0xffffcf82c022fd98 -> __schedule+0x16ee 
> (ffffffff820f162e) -> call mm_get_cid
> 
> Michal extracted the vCPU's RIP and it turned out:
>  > Hm, I'd say the CPU could be spinning in mm_get_cid() waiting for a 
> free CID.
>  > ...
>  > ffff8a88458137c0:  000000000000000f 000000000000000f
>  >                                                    ^
>  > Hm, so indeed CIDs for all four CPUs are occupied.
> 
> To me (I don't know what CID is either), this might point as a possible 
> culprit to Thomas' "sched/mmcid: Cure mode transition woes" [1].
> 
> Funnily enough, 47ee94efccf6 ("sched/mmcid: Protect transition on weakly 
> ordered systems") spells:
>  >     As a consequence the task will
>  >     not drop the CID when scheduling out before the fixup is 
> completed, which
>  >     means the CID space can be exhausted and the next task scheduling 
> in will
>  >     loop in mm_get_cid() and the fixup thread can livelock on the 
> held runqueue
>  >     lock as above.
> 
> Which sounds like what exactly happens here. Except the patch is from 
> the series above, so is already in 6.19 obviously.
> 
> 
> I noticed there is also a 7.0-rc1 fix:
>    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on mode switch
> But that got into 6.19.1 already (we are at 6.19.3). So does not improve 
> the situation.
> 
> Any ideas?
> 
> 
> 
> [1] https://lore.kernel.org/all/20260201192234.380608594@kernel.org/
> 
> thanks,

-- 
js
suse labs


