Return-Path: <kvm+bounces-73169-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFHrAe9Jq2mzbwEAu9opvQ
	(envelope-from <kvm+bounces-73169-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:41:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E9B22811B
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 22:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB4C9303DF51
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 21:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C55833A9E1;
	Fri,  6 Mar 2026 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gm8wSt1D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD62C3AE71C;
	Fri,  6 Mar 2026 21:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772833247; cv=none; b=FsTiJ7lj2y2xr/sb58TBMUubeekQzasHxolQ1lmRQLB1RnO+Xj2A2k5BJYFiSqkFAj18tj3qX8fOLwmtBHl3JgEx5DE+KAM4o1oKUJCTxJJxy+9DTbADRoLQcsDoNcEx1Om3icNnkkBrnuW0ACAUlZdWuBH5XDjgnYngPrTES/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772833247; c=relaxed/simple;
	bh=SlMansMvYm21l9+el1iUabkboO+ZuuXyZDJ+L3iO620=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=lIb0A4DkC2gyD2pqa7EzebDG2cE/Sl8XwAei4n4pMjST+0vi2FPsYfmGJl/sH77FlxlU3fZ7eW6R40Luvughbu1sXIINbfj+TVZ0KP69phfUQCyJTZ9o+m7Kw5BWQzx1nCZ0penK9VS/W92s5HMUTHDL93h96ZMytR3FBLfvZZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gm8wSt1D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB58DC4CEF7;
	Fri,  6 Mar 2026 21:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772833247;
	bh=SlMansMvYm21l9+el1iUabkboO+ZuuXyZDJ+L3iO620=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=gm8wSt1DFQAWn+4WNvztVmCdFhfXSKfdKDzv48hzgL5gJo/VY4OPY9ha2pNN6NzLx
	 NqclRgi3asfWDWhWjoIgqDYS9SQY2JBk81MtEHgCRspDdAOVubQRdPuiPIevc7q15K
	 yIiYGxkNo7fZfTwU/QhC5/zc+1xglRaQZ9J6cqT2L9umiaKFIgYH+oSX5YOuewQvgp
	 jMH7gza/D8MprXztnH7/Zp+v/rCptBdBple2nvcubP3ejB6cSUBuxPnkLs6cM1Kmu2
	 rrPYgYo0yZipztSWhGuNOMBOCKf/1pJQr8IONyzCK5gUy1IszXDxb/Ip87uD8TDRF5
	 OLUYn+PN7k2wQ==
Date: Fri, 6 Mar 2026 22:40:39 +0100
From: Matthieu Baerts <matttbe@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
	rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, luto@kernel.org,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
	Waiman Long <longman@redhat.com>
Message-ID: <0dbc88bc-1605-4220-a959-c0ffa68d3f9a@kernel.org>
In-Reply-To: <bacd7e6a-18a3-4e81-9b37-3e59fb1b2183@kernel.org>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org> <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org> <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org> <20260302114636.GL606826@noisy.programming.kicks-ass.net> <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org> <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org> <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx> <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx> <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx> <9798cb27-0f52-42fa-b0da-a7834039da1f@kernel.org> <bacd7e6a-18a3-4e81-9b37-3e59fb1b2183@kernel.org>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups,
 RCU stalls, timeout
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <0dbc88bc-1605-4220-a959-c0ffa68d3f9a@kernel.org>
X-Rspamd-Queue-Id: 75E9B22811B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73169-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.939];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

06 Mar 2026 17:57:26 Matthieu Baerts <matttbe@kernel.org>:

(...)

> After having sent this email, I re-checked on my side, and I was able to
> reproduce this issue with the technique described above: using the
> docker image with "build" argument, then max 50 boot iterations with "vm
> auto normal" argument. I then used 'git bisect' between v6.18 and
> v6.19-rc1 to find the guilty commit, and got:
>
> =C2=A0 653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")
>
> Reverting it on top of v6.19-rc1 fixes the issue.
>
> Unfortunatelly, reverting it on top of Linus' tree causes some
> conflicts. I did my best to resolve them, and with this patch attached
> below -- also available in [1] -- I no longer have the issue. I don't
> know if it is correct -- some quick tests don't show any issues -- nor
> if Jiri should test it. I guess the final fix will be different from
> this simple revert.

As probably expected, even if this revert fixed the boot issues, it
caused a regression during the tests execution, see below.


[=C2=A0 493.608357][=C2=A0=C2=A0=C2=A0 C3] rcu: 3-....: (26000 ticks this G=
P) idle=3Dd54c/1/0x4000000000000000 softirq=3D214151/214154 fqs=3D6500
[=C2=A0 493.609867][=C2=A0=C2=A0=C2=A0 C3] rcu: (t=3D26003 jiffies g=3D3926=
97 q=3D1127 ncpus=3D4)
[=C2=A0 493.610566][=C2=A0=C2=A0=C2=A0 C3] CPU: 3 UID: 0 PID: 4961 Comm: sl=
eep Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=C2=A0 7.0.0-rc2+ #1 PREEMPT(full)
[=C2=A0 493.610575][=C2=A0=C2=A0=C2=A0 C3] Tainted: [N]=3DTEST
[=C2=A0 493.610577][=C2=A0=C2=A0=C2=A0 C3] Hardware name: Bochs Bochs, BIOS=
 Bochs 01/01/2011
[=C2=A0 493.610583][=C2=A0=C2=A0=C2=A0 C3] RIP: 0010:sched_mm_cid_after_exe=
cve (kernel/sched/sched.h:4026 (discriminator 2))
[=C2=A0 493.610596][=C2=A0=C2=A0=C2=A0 C3] Code: 05 00 00 4c 89 e8 48 c1 f8=
 06 4c 89 4c 24 08 49 8d bc c1 10 0b 00 00 e8 99 4a 90 00 4c 8b 4c 24 08 f0=
 4d 0f ab a9 10 0b 00 00 <0f> 82 b7 00 00 00 48 8b 54 24 10 44 8b 44 24 1c =
48 b8 00 00 00 00
All code
=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 05 00 00 4c 89=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add=C2=
=A0=C2=A0=C2=A0 $0x894c0000,%eax
=C2=A0=C2=A0 5: e8 48 c1 f8 06=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 call=C2=
=A0=C2=A0 0x6f8c152
=C2=A0=C2=A0 a: 4c 89 4c 24 08=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=
=A0=C2=A0=C2=A0 %r9,0x8(%rsp)
=C2=A0=C2=A0 f: 49 8d bc c1 10 0b 00 lea=C2=A0=C2=A0=C2=A0 0xb10(%r9,%rax,8=
),%rdi
=C2=A0 16: 00
=C2=A0 17: e8 99 4a 90 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 call=C2=A0=C2=
=A0 0x904ab5
=C2=A0 1c: 4c 8b 4c 24 08=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=
=A0=C2=A0 0x8(%rsp),%r9
=C2=A0 21: f0 4d 0f ab a9 10 0b lock bts %r13,0xb10(%r9)
=C2=A0 28: 00 00
=C2=A0 2a:* 0f 82 b7 00 00 00=C2=A0=C2=A0 jb=C2=A0=C2=A0=C2=A0=C2=A0 0xe7 <=
-- trapping instruction
=C2=A0 30: 48 8b 54 24 10=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=
=A0=C2=A0 0x10(%rsp),%rdx
=C2=A0 35: 44 8b 44 24 1c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=
=A0=C2=A0 0x1c(%rsp),%r8d
=C2=A0 3a: 48=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rex.W
=C2=A0 3b: b8 00 00 00 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=
=A0=C2=A0 $0x0,%eax

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 0f 82 b7 00 00 00=C2=A0=C2=A0=C2=A0 jb=C2=A0=C2=A0=C2=A0=C2=
=A0 0xbd
=C2=A0=C2=A0 6: 48 8b 54 24 10=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=
=A0=C2=A0=C2=A0 0x10(%rsp),%rdx
=C2=A0=C2=A0 b: 44 8b 44 24 1c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=
=A0=C2=A0=C2=A0 0x1c(%rsp),%r8d
=C2=A0 10: 48=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rex.W
=C2=A0 11: b8 00 00 00 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=
=A0=C2=A0 $0x0,%eax
[=C2=A0 493.610600][=C2=A0=C2=A0=C2=A0 C3] RSP: 0018:ffffc90002957e00 EFLAG=
S: 00000247
[=C2=A0 493.610605][=C2=A0=C2=A0=C2=A0 C3] RAX: 0000000000000001 RBX: 00000=
00000000001 RCX: 0000000000000001
[=C2=A0 493.610609][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000001 RSI: 00000=
00000000008 RDI: ffff8881000aba10
[=C2=A0 493.610612][=C2=A0=C2=A0=C2=A0 C3] RBP: dffffc0000000000 R08: fffff=
fff8185fe97 R09: ffff8881000aaf00
[=C2=A0 493.610615][=C2=A0=C2=A0=C2=A0 C3] R10: ffffed1020015743 R11: 00000=
00000000000 R12: ffffed1021dda7a8
[=C2=A0 493.610618][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: ffff8=
881000aaf00 R15: ffff88810eed3800
[=C2=A0 493.610663][=C2=A0=C2=A0=C2=A0 C3] FS:=C2=A0 0000000000000000(0000)=
 GS:ffff8881cc110000(0000) knlGS:0000000000000000
[=C2=A0 493.610680][=C2=A0=C2=A0=C2=A0 C3] CS:=C2=A0 0010 DS: 0000 ES: 0000=
 CR0: 0000000080050033
[=C2=A0 493.610684][=C2=A0=C2=A0=C2=A0 C3] CR2: 00007ffef3a7dd89 CR3: 00000=
001204a1005 CR4: 0000000000370ef0
[=C2=A0 493.610688][=C2=A0=C2=A0=C2=A0 C3] Call Trace:
[=C2=A0 493.610691][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 <TASK>
[=C2=A0 493.610703][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 bprm_execve (include/linux=
/rseq.h:140)
[=C2=A0 493.610717][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_execveat_common.isra.0 =
(fs/exec.c:1846)
[=C2=A0 493.610731][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __x64_sys_execve (include/=
linux/fs.h:2539)
[=C2=A0 493.610740][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_syscall_64 (arch/x86/en=
try/syscall_64.c:63 (discriminator 1))
[=C2=A0 493.610750][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? exc_page_fault (arch/x86=
/mm/fault.c:1480 (discriminator 3))
[=C2=A0 493.610760][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 entry_SYSCALL_64_after_hwf=
rame (arch/x86/entry/entry_64.S:130)
[=C2=A0 493.610767][=C2=A0=C2=A0=C2=A0 C3] RIP: 0033:0x7fb401448140
[=C2=A0 493.610780][=C2=A0=C2=A0=C2=A0 C3] Code: Unable to access opcode by=
tes at 0x7fb401448116.

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 493.610782][=C2=A0=C2=A0=C2=A0 C3] RSP: 002b:00007ffef3a7da70 EFLAG=
S: 00000202 ORIG_RAX: 000000000000003b
[=C2=A0 493.610787][=C2=A0=C2=A0=C2=A0 C3] RAX: ffffffffffffffda RBX: 00000=
00000000000 RCX: 0000000000000000
[=C2=A0 493.610790][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000000 RSI: 00000=
00000000000 RDI: 0000000000000000
[=C2=A0 493.610793][=C2=A0=C2=A0=C2=A0 C3] RBP: 0000000000000000 R08: 00000=
00000000000 R09: 0000000000000000
[=C2=A0 493.610795][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000000
[=C2=A0 493.610796][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: 00000=
00000000000 R15: 0000000000000000
[=C2=A0 493.610815][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 </TASK>
main_loop_s: timed out
[=C2=A0 503.574195][=C2=A0=C2=A0 T17] rcu: INFO: rcu_preempt detected exped=
ited stalls on CPUs/tasks: { 3-.... } 35898 jiffies s: 8761 root: 0x8/.
[=C2=A0 503.575291][=C2=A0=C2=A0 T17] rcu: blocking rcu_node structures (in=
ternal RCU debug):
[=C2=A0 503.576282][=C2=A0=C2=A0 T17] Sending NMI from CPU 1 to CPUs 3:
[=C2=A0 503.577258][=C2=A0=C2=A0=C2=A0 C3] NMI backtrace for cpu 3
[=C2=A0 503.577269][=C2=A0=C2=A0=C2=A0 C3] CPU: 3 UID: 0 PID: 4961 Comm: sl=
eep Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=C2=A0 7.0.0-rc2+ #1 PREEMPT(full)
[=C2=A0 503.577277][=C2=A0=C2=A0=C2=A0 C3] Tainted: [N]=3DTEST
[=C2=A0 503.577279][=C2=A0=C2=A0=C2=A0 C3] Hardware name: Bochs Bochs, BIOS=
 Bochs 01/01/2011
[=C2=A0 503.577282][=C2=A0=C2=A0=C2=A0 C3] RIP: 0010:sched_mm_cid_after_exe=
cve (kernel/sched/sched.h:4022)
[=C2=A0 503.577295][=C2=A0=C2=A0=C2=A0 C3] Code: 34 2e 40 38 f0 7c 09 40 84=
 f6 0f 85 6e 01 00 00 8b 35 d6 72 d5 02 49 8d be 10 0b 00 00 e8 b6 cc f9 00=
 49 89 c5 41 80 3c 24 00 <0f> 85 5f 01 00 00 4d 8b b7 40 05 00 00 41 39 dd =
0f 83 1e fd ff ff
All code
=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 34 2e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xor=C2=A0=C2=A0=C2=A0 $0x2e,%al
=C2=A0=C2=A0 2: 40 38 f0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 cmp=C2=A0=C2=A0=C2=A0 %sil,%al
=C2=A0=C2=A0 5: 7c 09=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 jl=C2=A0=C2=A0=C2=A0=C2=A0 0x10
=C2=A0=C2=A0 7: 40 84 f6=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %sil,%sil
=C2=A0=C2=A0 a: 0f 85 6e 01 00 00=C2=A0=C2=A0=C2=A0 jne=C2=A0=C2=A0=C2=A0 0=
x17e
=C2=A0 10: 8b 35 d6 72 d5 02=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 0x2d57=
2d6(%rip),%esi=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 # 0x2d572ec
=C2=A0 16: 49 8d be 10 0b 00 00 lea=C2=A0=C2=A0=C2=A0 0xb10(%r14),%rdi
=C2=A0 1d: e8 b6 cc f9 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 call=C2=A0=C2=
=A0 0xf9ccd8
=C2=A0 22: 49 89 c5=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 %rax,%r13
=C2=A0 25: 41 80 3c 24 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmpb=C2=A0=C2=
=A0 $0x0,(%r12)
=C2=A0 2a:* 0f 85 5f 01 00 00=C2=A0=C2=A0=C2=A0 jne=C2=A0=C2=A0=C2=A0 0x18f=
 <-- trapping instruction
=C2=A0 30: 4d 8b b7 40 05 00 00 mov=C2=A0=C2=A0=C2=A0 0x540(%r15),%r14
=C2=A0 37: 41 39 dd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 cmp=C2=A0=C2=A0=C2=A0 %ebx,%r13d
=C2=A0 3a: 0f 83 1e fd ff ff=C2=A0=C2=A0=C2=A0 jae=C2=A0=C2=A0=C2=A0 0xffff=
fffffffffd5e

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 0f 85 5f 01 00 00=C2=A0=C2=A0=C2=A0 jne=C2=A0=C2=A0=C2=A0 0=
x165
=C2=A0=C2=A0 6: 4d 8b b7 40 05 00 00 mov=C2=A0=C2=A0=C2=A0 0x540(%r15),%r14
=C2=A0=C2=A0 d: 41 39 dd=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 cmp=C2=A0=C2=A0=C2=A0 %ebx,%r13d
=C2=A0 10: 0f 83 1e fd ff ff=C2=A0=C2=A0=C2=A0 jae=C2=A0=C2=A0=C2=A0 0xffff=
fffffffffd34
[=C2=A0 503.577300][=C2=A0=C2=A0=C2=A0 C3] RSP: 0018:ffffc90002957e00 EFLAG=
S: 00000246
[=C2=A0 503.577305][=C2=A0=C2=A0=C2=A0 C3] RAX: 0000000000000001 RBX: 00000=
00000000001 RCX: 0000000000000001
[=C2=A0 503.577308][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000001 RSI: dffff=
c0000000000 RDI: ffff8881000aba10
[=C2=A0 503.577311][=C2=A0=C2=A0=C2=A0 C3] RBP: dffffc0000000000 R08: fffff=
fff8185fe97 R09: ffff8881000aaf00
[=C2=A0 503.577314][=C2=A0=C2=A0=C2=A0 C3] R10: ffffed1020015743 R11: 00000=
00000000000 R12: ffffed1021dda7a8
[=C2=A0 503.577316][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000001 R14: ffff8=
881000aaf00 R15: ffff88810eed3800
[=C2=A0 503.577335][=C2=A0=C2=A0=C2=A0 C3] FS:=C2=A0 0000000000000000(0000)=
 GS:ffff8881cc110000(0000) knlGS:0000000000000000
[=C2=A0 503.577350][=C2=A0=C2=A0=C2=A0 C3] CS:=C2=A0 0010 DS: 0000 ES: 0000=
 CR0: 0000000080050033
[=C2=A0 503.577353][=C2=A0=C2=A0=C2=A0 C3] CR2: 00007fb401448116 CR3: 00000=
001204a1005 CR4: 0000000000370ef0
[=C2=A0 503.577356][=C2=A0=C2=A0=C2=A0 C3] Call Trace:
[=C2=A0 503.577360][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 <TASK>
[=C2=A0 503.577368][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 bprm_execve (include/linux=
/rseq.h:140)
[=C2=A0 503.577377][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_execveat_common.isra.0 =
(fs/exec.c:1846)
[=C2=A0 503.577385][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __x64_sys_execve (include/=
linux/fs.h:2539)
[=C2=A0 503.577392][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_syscall_64 (arch/x86/en=
try/syscall_64.c:63 (discriminator 1))
[=C2=A0 503.577401][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? exc_page_fault (arch/x86=
/mm/fault.c:1480 (discriminator 3))
[=C2=A0 503.577408][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 entry_SYSCALL_64_after_hwf=
rame (arch/x86/entry/entry_64.S:130)
[=C2=A0 503.577415][=C2=A0=C2=A0=C2=A0 C3] RIP: 0033:0x7fb401448140
[=C2=A0 503.577427][=C2=A0=C2=A0=C2=A0 C3] Code: Unable to access opcode by=
tes at 0x7fb401448116.

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 503.577430][=C2=A0=C2=A0=C2=A0 C3] RSP: 002b:00007ffef3a7da70 EFLAG=
S: 00000202 ORIG_RAX: 000000000000003b
[=C2=A0 503.577435][=C2=A0=C2=A0=C2=A0 C3] RAX: ffffffffffffffda RBX: 00000=
00000000000 RCX: 0000000000000000
[=C2=A0 503.577437][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000000 RSI: 00000=
00000000000 RDI: 0000000000000000
[=C2=A0 503.577439][=C2=A0=C2=A0=C2=A0 C3] RBP: 0000000000000000 R08: 00000=
00000000000 R09: 0000000000000000
[=C2=A0 503.577442][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000000
[=C2=A0 503.577444][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: 00000=
00000000000 R15: 0000000000000000
[=C2=A0 503.577453][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 </TASK>
[=C2=A0 530.927646][=C2=A0=C2=A0=C2=A0 C3] watchdog: BUG: soft lockup - CPU=
#3 stuck for 60s! [sleep:4961]
[=C2=A0 530.927660][=C2=A0=C2=A0=C2=A0 C3] Modules linked in: nft_tproxy nf=
_tproxy_ipv6 nf_tproxy_ipv4 nft_socket nf_socket_ipv4 nf_socket_ipv6 nf_tab=
les sch_netem tcp_diag mptcp_diag inet_diag mptcp_token_test mptcp_crypto_t=
est kunit
[=C2=A0 530.927693][=C2=A0=C2=A0=C2=A0 C3] irq event stamp: 141062
[=C2=A0 530.927696][=C2=A0=C2=A0=C2=A0 C3] hardirqs last=C2=A0 enabled at (=
141061): irqentry_exit (kernel/entry/common.c:243)
[=C2=A0 530.927711][=C2=A0=C2=A0=C2=A0 C3] hardirqs last disabled at (14106=
2): sysvec_apic_timer_interrupt (arch/x86/include/asm/hardirq.h:81)
[=C2=A0 530.927715][=C2=A0=C2=A0=C2=A0 C3] softirqs last=C2=A0 enabled at (=
140962): handle_softirqs (kernel/softirq.c:469 (discriminator 2))
[=C2=A0 530.927720][=C2=A0=C2=A0=C2=A0 C3] softirqs last disabled at (14094=
9): __irq_exit_rcu (kernel/softirq.c:657)
[=C2=A0 530.927727][=C2=A0=C2=A0=C2=A0 C3] CPU: 3 UID: 0 PID: 4961 Comm: sl=
eep Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 N=C2=A0 7.0.0-rc2+ #1 PREEMPT(full)
[=C2=A0 530.927732][=C2=A0=C2=A0=C2=A0 C3] Tainted: [N]=3DTEST
[=C2=A0 530.927734][=C2=A0=C2=A0=C2=A0 C3] Hardware name: Bochs Bochs, BIOS=
 Bochs 01/01/2011
[=C2=A0 530.927736][=C2=A0=C2=A0=C2=A0 C3] RIP: 0010:sched_mm_cid_after_exe=
cve (kernel/sched/sched.h:4045 (discriminator 6))
[=C2=A0 530.927742][=C2=A0=C2=A0=C2=A0 C3] Code: 02 83 04 85 c0 0f 84 6b 02=
 00 00 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c7 40=
 f5 cd 83 e8 bd df 19 02 <49> 8d be 00 01 00 00 48 89 f8 48 c1 e8 03 80 3c =
28 00 0f 85 65 02
All code
=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 02 83 04 85 c0 0f=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 0=
xfc08504(%rbx),%al
=C2=A0=C2=A0 6: 84 6b 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %ch,0x2(%rbx)
=C2=A0=C2=A0 9: 00 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 %al,(%rax)
=C2=A0=C2=A0 b: 48 83 c4 30=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 add=C2=A0=C2=A0=C2=A0 $0x30,%rsp
=C2=A0=C2=A0 f: 5b=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %=
rbx
=C2=A0 10: 5d=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %rbp
=C2=A0 11: 41 5c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r12
=C2=A0 13: 41 5d=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r13
=C2=A0 15: 41 5e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r14
=C2=A0 17: 41 5f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r15
=C2=A0 19: c3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret
=C2=A0 1a: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1b: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1c: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1d: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1e: 48 c7 c7 40 f5 cd 83 mov=C2=A0=C2=A0=C2=A0 $0xffffffff83cdf540,%=
rdi
=C2=A0 25: e8 bd df 19 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 call=C2=A0=C2=
=A0 0x219dfe7
=C2=A0 2a:* 49 8d be 00 01 00 00 lea=C2=A0=C2=A0=C2=A0 0x100(%r14),%rdi <--=
 trapping instruction
=C2=A0 31: 48 89 f8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 %rdi,%rax
=C2=A0 34: 48 c1 e8 03=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 shr=C2=A0=C2=A0=C2=A0 $0x3,%rax
=C2=A0 38: 80 3c 28 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 cmpb=C2=A0=C2=A0 $0x0,(%rax,%rbp,1)
=C2=A0 3c: 0f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .byte 0xf
=C2=A0 3d: 85 65 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %esp,0x2(%rbp)

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 49 8d be 00 01 00 00 lea=C2=A0=C2=A0=C2=A0 0x100(%r14),%rdi
=C2=A0=C2=A0 7: 48 89 f8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 %rdi,%rax
=C2=A0=C2=A0 a: 48 c1 e8 03=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 shr=C2=A0=C2=A0=C2=A0 $0x3,%rax
=C2=A0=C2=A0 e: 80 3c 28 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 cmpb=C2=A0=C2=A0 $0x0,(%rax,%rbp,1)
=C2=A0 12: 0f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .byte 0xf
=C2=A0 13: 85 65 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %esp,0x2(%rbp)
[=C2=A0 530.927744][=C2=A0=C2=A0=C2=A0 C3] RSP: 0018:ffffc90002957e00 EFLAG=
S: 00000202
[=C2=A0 530.927747][=C2=A0=C2=A0=C2=A0 C3] RAX: 0000000000000003 RBX: 00000=
00000000001 RCX: 0000000000000001
[=C2=A0 530.927749][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000001 RSI: fffff=
fff83cdf540 RDI: ffffffff83eec920
[=C2=A0 530.927751][=C2=A0=C2=A0=C2=A0 C3] RBP: dffffc0000000000 R08: fffff=
fff8185fd4a R09: 0000000000000000
[=C2=A0 530.927752][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000003 R11: 00000=
00000000000 R12: ffffed1021dda7a8
[=C2=A0 530.927753][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: ffff8=
881000aaf00 R15: ffff88810eed3800
[=C2=A0 530.927766][=C2=A0=C2=A0=C2=A0 C3] FS:=C2=A0 0000000000000000(0000)=
 GS:ffff8881cc110000(0000) knlGS:0000000000000000
[=C2=A0 530.927776][=C2=A0=C2=A0=C2=A0 C3] CS:=C2=A0 0010 DS: 0000 ES: 0000=
 CR0: 0000000080050033
[=C2=A0 530.927778][=C2=A0=C2=A0=C2=A0 C3] CR2: 00007fb401448116 CR3: 00000=
001204a1005 CR4: 0000000000370ef0
[=C2=A0 530.927780][=C2=A0=C2=A0=C2=A0 C3] Call Trace:
[=C2=A0 530.927784][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 <TASK>
[=C2=A0 530.927792][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 bprm_execve (include/linux=
/rseq.h:140)
[=C2=A0 530.927801][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_execveat_common.isra.0 =
(fs/exec.c:1846)
[=C2=A0 530.927807][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __x64_sys_execve (include/=
linux/fs.h:2539)
[=C2=A0 530.927812][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_syscall_64 (arch/x86/en=
try/syscall_64.c:63 (discriminator 1))
[=C2=A0 530.927817][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? exc_page_fault (arch/x86=
/mm/fault.c:1480 (discriminator 3))
[=C2=A0 530.927821][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 entry_SYSCALL_64_after_hwf=
rame (arch/x86/entry/entry_64.S:130)
[=C2=A0 530.927826][=C2=A0=C2=A0=C2=A0 C3] RIP: 0033:0x7fb401448140
[=C2=A0 530.927835][=C2=A0=C2=A0=C2=A0 C3] Code: Unable to access opcode by=
tes at 0x7fb401448116.

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 530.927837][=C2=A0=C2=A0=C2=A0 C3] RSP: 002b:00007ffef3a7da70 EFLAG=
S: 00000202 ORIG_RAX: 000000000000003b
[=C2=A0 530.927839][=C2=A0=C2=A0=C2=A0 C3] RAX: ffffffffffffffda RBX: 00000=
00000000000 RCX: 0000000000000000
[=C2=A0 530.927840][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000000 RSI: 00000=
00000000000 RDI: 0000000000000000
[=C2=A0 530.927842][=C2=A0=C2=A0=C2=A0 C3] RBP: 0000000000000000 R08: 00000=
00000000000 R09: 0000000000000000
[=C2=A0 530.927843][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000000
[=C2=A0 530.927844][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: 00000=
00000000000 R15: 0000000000000000
[=C2=A0 530.927854][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 </TASK>
[=C2=A0 530.927857][=C2=A0=C2=A0=C2=A0 C3] Kernel panic - not syncing: soft=
lockup: hung tasks
[=C2=A0 530.958801][=C2=A0=C2=A0=C2=A0 C3] CPU: 3 UID: 0 PID: 4961 Comm: sl=
eep Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 L=C2=A0=C2=A0 N=C2=A0 7.0.0-rc2+ #1 PREEMPT(full)
[=C2=A0 530.960019][=C2=A0=C2=A0=C2=A0 C3] Tainted: [L]=3DSOFTLOCKUP, [N]=
=3DTEST
[=C2=A0 530.960652][=C2=A0=C2=A0=C2=A0 C3] Hardware name: Bochs Bochs, BIOS=
 Bochs 01/01/2011
[=C2=A0 530.961437][=C2=A0=C2=A0=C2=A0 C3] Call Trace:
[=C2=A0 530.961931][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 <IRQ>
[=C2=A0 530.962208][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 dump_stack_lvl (lib/dump_s=
tack.c:122)
[=C2=A0 530.962740][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 vpanic (kernel/panic.c:651=
)
[=C2=A0 530.963120][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 panic (kernel/panic.c:787)
[=C2=A0 530.963502][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? __pfx_panic (kernel/pani=
c.c:783)
[=C2=A0 530.964024][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? add_taint (arch/x86/incl=
ude/asm/bitops.h:60)
[=C2=A0 530.964459][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 watchdog_timer_fn.cold (ke=
rnel/watchdog.c:871)
[=C2=A0 530.965081][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? __pfx_watchdog_timer_fn =
(kernel/watchdog.c:774)
[=C2=A0 530.965629][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __run_hrtimer (kernel/time=
/hrtimer.c:1785)
[=C2=A0 530.966417][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __hrtimer_run_queues (incl=
ude/linux/timerqueue.h:25)
[=C2=A0 530.966930][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? __pfx___hrtimer_run_queu=
es (kernel/time/hrtimer.c:1819)
[=C2=A0 530.967470][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? ktime_get_update_offsets=
_now (kernel/time/timekeeping.c:381)
[=C2=A0 530.968251][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 hrtimer_interrupt (kernel/=
time/hrtimer.c:1914)
[=C2=A0 530.968990][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __sysvec_apic_timer_interr=
upt (arch/x86/include/asm/jump_label.h:37)
[=C2=A0 530.969783][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 sysvec_apic_timer_interrup=
t (arch/x86/kernel/apic/apic.c:1056 (discriminator 47))
[=C2=A0 530.970343][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 </IRQ>
[=C2=A0 530.970723][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 <TASK>
[=C2=A0 530.971036][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 asm_sysvec_apic_timer_inte=
rrupt (arch/x86/include/asm/idtentry.h:697)
[=C2=A0 530.971947][=C2=A0=C2=A0=C2=A0 C3] RIP: 0010:sched_mm_cid_after_exe=
cve (kernel/sched/sched.h:4045 (discriminator 6))
[=C2=A0 530.972671][=C2=A0=C2=A0=C2=A0 C3] Code: 02 83 04 85 c0 0f 84 6b 02=
 00 00 48 83 c4 30 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c7 40=
 f5 cd 83 e8 bd df 19 02 <49> 8d be 00 01 00 00 48 89 f8 48 c1 e8 03 80 3c =
28 00 0f 85 65 02
All code
=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 02 83 04 85 c0 0f=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 0=
xfc08504(%rbx),%al
=C2=A0=C2=A0 6: 84 6b 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %ch,0x2(%rbx)
=C2=A0=C2=A0 9: 00 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 add=C2=A0=C2=A0=C2=A0 %al,(%rax)
=C2=A0=C2=A0 b: 48 83 c4 30=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 add=C2=A0=C2=A0=C2=A0 $0x30,%rsp
=C2=A0=C2=A0 f: 5b=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %=
rbx
=C2=A0 10: 5d=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %rbp
=C2=A0 11: 41 5c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r12
=C2=A0 13: 41 5d=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r13
=C2=A0 15: 41 5e=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r14
=C2=A0 17: 41 5f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pop=C2=A0=C2=A0=C2=A0 %r15
=C2=A0 19: c3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret
=C2=A0 1a: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1b: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1c: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1d: cc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int3
=C2=A0 1e: 48 c7 c7 40 f5 cd 83 mov=C2=A0=C2=A0=C2=A0 $0xffffffff83cdf540,%=
rdi
=C2=A0 25: e8 bd df 19 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 call=C2=A0=C2=
=A0 0x219dfe7
=C2=A0 2a:* 49 8d be 00 01 00 00 lea=C2=A0=C2=A0=C2=A0 0x100(%r14),%rdi <--=
 trapping instruction
=C2=A0 31: 48 89 f8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 %rdi,%rax
=C2=A0 34: 48 c1 e8 03=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 shr=C2=A0=C2=A0=C2=A0 $0x3,%rax
=C2=A0 38: 80 3c 28 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 cmpb=C2=A0=C2=A0 $0x0,(%rax,%rbp,1)
=C2=A0 3c: 0f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .byte 0xf
=C2=A0 3d: 85 65 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %esp,0x2(%rbp)

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=C2=A0=C2=A0 0: 49 8d be 00 01 00 00 lea=C2=A0=C2=A0=C2=A0 0x100(%r14),%rdi
=C2=A0=C2=A0 7: 48 89 f8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mov=C2=A0=C2=A0=C2=A0 %rdi,%rax
=C2=A0=C2=A0 a: 48 c1 e8 03=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 shr=C2=A0=C2=A0=C2=A0 $0x3,%rax
=C2=A0=C2=A0 e: 80 3c 28 00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 cmpb=C2=A0=C2=A0 $0x0,(%rax,%rbp,1)
=C2=A0 12: 0f=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .byte 0xf
=C2=A0 13: 85 65 02=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 test=C2=A0=C2=A0 %esp,0x2(%rbp)
[=C2=A0 530.974394][=C2=A0=C2=A0=C2=A0 C3] RSP: 0018:ffffc90002957e00 EFLAG=
S: 00000202
[=C2=A0 530.975308][=C2=A0=C2=A0=C2=A0 C3] RAX: 0000000000000003 RBX: 00000=
00000000001 RCX: 0000000000000001
[=C2=A0 530.976147][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000001 RSI: fffff=
fff83cdf540 RDI: ffffffff83eec920
[=C2=A0 530.977030][=C2=A0=C2=A0=C2=A0 C3] RBP: dffffc0000000000 R08: fffff=
fff8185fd4a R09: 0000000000000000
[=C2=A0 530.977910][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000003 R11: 00000=
00000000000 R12: ffffed1021dda7a8
[=C2=A0 530.978926][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: ffff8=
881000aaf00 R15: ffff88810eed3800
[=C2=A0 530.979595][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? sched_mm_cid_after_execv=
e (arch/x86/include/asm/bitops.h:136 (discriminator 1))
[=C2=A0 530.980252][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 bprm_execve (include/linux=
/rseq.h:140)
[=C2=A0 530.980941][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_execveat_common.isra.0 =
(fs/exec.c:1846)
[=C2=A0 530.981424][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 __x64_sys_execve (include/=
linux/fs.h:2539)
[=C2=A0 530.981941][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 do_syscall_64 (arch/x86/en=
try/syscall_64.c:63 (discriminator 1))
[=C2=A0 530.982406][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 ? exc_page_fault (arch/x86=
/mm/fault.c:1480 (discriminator 3))
[=C2=A0 530.983097][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 entry_SYSCALL_64_after_hwf=
rame (arch/x86/entry/entry_64.S:130)
[=C2=A0 530.983809][=C2=A0=C2=A0=C2=A0 C3] RIP: 0033:0x7fb401448140
[=C2=A0 530.984409][=C2=A0=C2=A0=C2=A0 C3] Code: Unable to access opcode by=
tes at 0x7fb401448116.

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[=C2=A0 530.985240][=C2=A0=C2=A0=C2=A0 C3] RSP: 002b:00007ffef3a7da70 EFLAG=
S: 00000202 ORIG_RAX: 000000000000003b
[=C2=A0 530.986149][=C2=A0=C2=A0=C2=A0 C3] RAX: ffffffffffffffda RBX: 00000=
00000000000 RCX: 0000000000000000
[=C2=A0 530.986945][=C2=A0=C2=A0=C2=A0 C3] RDX: 0000000000000000 RSI: 00000=
00000000000 RDI: 0000000000000000
[=C2=A0 530.987807][=C2=A0=C2=A0=C2=A0 C3] RBP: 0000000000000000 R08: 00000=
00000000000 R09: 0000000000000000
[=C2=A0 530.988490][=C2=A0=C2=A0=C2=A0 C3] R10: 0000000000000000 R11: 00000=
00000000000 R12: 0000000000000000
[=C2=A0 530.989334][=C2=A0=C2=A0=C2=A0 C3] R13: 0000000000000000 R14: 00000=
00000000000 R15: 0000000000000000
[=C2=A0 530.990257][=C2=A0=C2=A0=C2=A0 C3]=C2=A0 </TASK>
[=C2=A0 530.991655][=C2=A0=C2=A0=C2=A0 C3] Kernel Offset: disabled


More details:

=C2=A0 https://github.com/multipath-tcp/mptcp_net-next/actions/runs/2277562=
7304#summary-66068034344

Cheers,
Matt

