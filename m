Return-Path: <kvm+bounces-70525-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKBqKql5hmmVNwQAu9opvQ
	(envelope-from <kvm+bounces-70525-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:30:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2397C10424D
	for <lists+kvm@lfdr.de>; Sat, 07 Feb 2026 00:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 80E2E304A044
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 23:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FE2312828;
	Fri,  6 Feb 2026 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZHDYV0I4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7302045AD
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 23:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770420637; cv=none; b=ZsQAUfhnxOxwdNb4Rc1egak/H9RCRSP63PMJ+rFb7MAcQPq7rQR+QxajBFeRc13S7v1DYZ991+sXFSexaNeeasggWytcZ03DtnMW6MWk2dlMoQ49Id6QdwphUNf9qJ21ybH6vFsQvia+syiJ+ucMHgWEIDFG8+QokYvbHbHXTZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770420637; c=relaxed/simple;
	bh=KpLWbxfYOE8V2qeD7vR5Z9o4TwoyF48WXFCiXeX7ThI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FP4fvS8rfCPyQ90vT/XI08lwotQ1n0cN9cd59BT4mVIYM1Nxh9WuQfn3dcdzCb+nVt/ja7bi7PwQLWXEx4ilLp9Xt5wbaGtJrbT6Xlp7fqf/Gw3OPX0lbLRCdx9PmFUxMTjJSfmpQ3P8pTm83j5zs4jexMiu49IjWOEEBRys5uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZHDYV0I4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c617e59845dso1527584a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 15:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770420637; x=1771025437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgrTE5TrTuy/06caIVNLEx0DVtgtOfona8wcOqlYSXA=;
        b=ZHDYV0I4I9qtLDPH6XiwkjQs6cjz/PCMa0VwpTH7H09B/iUpX9q/02TDyxfuqkG2Pu
         Qb5gKYy+0ksxulN33/4E+mgLEmQiWaiHj+FoSmH3YmJg/FHR5CNKg0YGOuoGIhR0XDPb
         imO0prqMwofyJ2TuEkFVAREdMz3VZIVCvmMjOjOen1jvaZlGEdWHx7yyUgErl9+2pqdg
         1VwFYTasIq4sS9xrxwxianiFxFmsAwSAQeQGAejOEbm2lVZ1IMJ90Wv01lWWHWMLgg7W
         +yLIVmJBP06wYhlNngm/6SOLPltNdgy5AEhcByi41F0PvOrdm7eqvHkpdKqOpaV6G0BD
         p6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770420637; x=1771025437;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pgrTE5TrTuy/06caIVNLEx0DVtgtOfona8wcOqlYSXA=;
        b=WCFqD10NJp9Jv2c7km0WhvbzBfHSXOZdQLi76I49j24a/n1AZJazeiJ6MkPt1ATuTY
         BZWm51tdsQdlTvK9cb58+BBCJTr+Za2mC6haSfkR5jStMCeQ2FZwRvh1ns/n39hHsoyn
         c15X++EuWG/CCmJjolujMvMsS+Aiwzeq2iMoUenMPhuXrWbjQMajk8LHCT0eAQa4lDKE
         osnq+SmPtm2O8X/gF40ItfcdwXmiKsBqqUF03Rmvvh4wxtxOY+r+9+N6jGbcDS+MYtVa
         Ngq2RFSK3syz8BBpaKypkkTr/a4shBDlC8+xmd/xiJfbff8Y5hPpz1xnNbN7TaoCZUB9
         +kHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsfL83EnmNyxfqmxbYaUFbg+k/zNSOwZWrvL9Hd6KblN0w0z2Qizx1xdna/c3+3yS8JVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxolz5elg1HIBr099u/xltxcDArOWxAeO23e5BvpJo+vePmbant
	gkFL9/rt0YqbLHnGMAN58qCvoMofJabucfTsuKfErf3ymkBwMELVa59i9tldGJIZNXA29coYVQO
	EbQTCug==
X-Received: from pgbj2.prod.google.com ([2002:a63:5502:0:b0:c66:4fdd:d41a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6194:b0:38e:8878:91bb
 with SMTP id adf61e73a8af0-393acfaf374mr4485291637.4.1770420636897; Fri, 06
 Feb 2026 15:30:36 -0800 (PST)
Date: Fri, 6 Feb 2026 15:30:35 -0800
In-Reply-To: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
Message-ID: <aYZ5m5iJ_h_2wqw_@google.com>
Subject: Re: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
From: Sean Christopherson <seanjc@google.com>
To: Zhangjiaji <zhangjiaji1@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>, 
	zhangyashu <zhangyashu2@h-partners.com>, "wangyanan (Y)" <wangyanan55@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70525-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,qemu.org:url]
X-Rspamd-Queue-Id: 2397C10424D
X-Rspamd-Action: no action

On Mon, Feb 02, 2026, Zhangjiaji wrote:
> Syzkaller hit 'KASAN: use-after-free Read in complete_emulated_mmio' bug.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
> Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984
>=20
> CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h2627=
.eulerosv2r13.x86_64 #3 Hardware name: QEMU Standard PC (i440FX + PIIX, 199=
6), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Trace=
:
> dump_stack+0xbe/0xfd
> print_address_description.constprop.0+0x19/0x170
> __kasan_report.cold+0x6c/0x84
> kasan_report+0x3a/0x50
> check_memory_region+0xfd/0x1f0
> memcpy+0x20/0x60
> complete_emulated_mmio+0x305/0x420
> kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
> kvm_vcpu_ioctl+0x413/0xb20
> __se_sys_ioctl+0x111/0x160
> do_syscall_64+0x30/0x40
> entry_SYSCALL_64_after_hwframe+0x67/0xd1
> RIP: 0033:0x42477d
> Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007faa8e6890e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004d7338 RCX: 000000000042477d
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00000000004d7330 R08: 00007fff28d546df R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d733c
> R13: 0000000000000000 R14: 000000000040a200 R15: 00007fff28d54720
>=20
> The buggy address belongs to the page:
> page:0000000029f6a428 refcount:0 mapcount:0 mapping:0000000000000000 inde=
x:0x0 pfn:0x9c37
> flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
> raw: 000fffffc0000000 0000000000000000 ffffea0000270dc8 0000000000000000
> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000 =
page dumped because: kasan: bad access detected
>=20
> Memory state around the buggy address:
> ffff888009c37780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ffff888009c37800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >ffff888009c37880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                                                  ^
> ffff888009c37900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> ffff888009c37980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> Syzkaller reproducer:
> # {Threaded:true Repeat:true RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Sa=
ndboxArg:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cg=
roups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false Ni=
cVF:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:=
false Swap:false UseTmpDir:false HandleSegv:true Repro:false Trace:false Le=
gacyOptions:{Collide:false Fault:false FaultCall:0 FaultNth:0}}
> r0 =3D openat$kvm(0xffffffffffffff9c, &(0x7f00000001c0), 0x0, 0x0)
> r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
> r2 =3D ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) syz_kvm_setup_cpu$x86(r1, r=
2, &(0x7f0000fe2000/0x18000)=3Dnil, &(0x7f0000000080)=3D[@text32=3D{0x20, &=
(0x7f0000000000)=3D"44c8df2020c020c003000000000f22c0671e26653e360f2224660f6=
5b600000000b9e0450200f5e8f5e8f30f1ed6c744240000100000c744240200000000c74424=
06000000000f011424eacf5700000301b8010000000f01c1", 0x59}], 0x1, 0x27, 0x0, =
0x1) ioctl$KVM_RUN(r2, 0xae80, 0x0) ioctl$KVM_SMI(0xffffffffffffffff, 0xaeb=
7) (async) ioctl$KVM_RUN(r2, 0xae80, 0x0)
>=20
>=20
> ----------------------------
> Hi,
>=20
> I've analyzed the Syzkaller output and the complete_emulated_mmio() code
> path.  The buggy address is created in em_enter(), where it passes its lo=
cal
> variable `ulong rbp` to emulate_push(), finally ends in
> emulator_read_write_onepage() putting the address into
> vcpu->mmio_fragments[].data .  The bug happens when kvm guest executes an
> "enter" instruction, and top of the stack crosses the mem page.  In that
> case, the em_enter() function cannot complete the instruction within itse=
lf,
> but leave the rest data (which is in the other page) to
> complete_emulated_mmio().  When complete_emulated_mmio() starts, em_enter=
()
> has exited, so local variable `ulong rbp` is also released.  Now
> complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , and=
 the
> bug happened.
>=20
> any idea?

Egad, sorry!  I had reproduced this shortly after you sent the report and p=
repped
a fix, but got distracted and lost this in my inbox.

Can you test this on your end?  I repro'd by modifying a KVM-Unit-Test and =
hacking
KVM to tweak the stack, so I haven't confirmed the syzkaller version.

It's a bit gross, as it abuses an unused field as scratch space, but AFAICT=
 that's
"fine".  The alternative would be add a dedicated field, which seems like o=
verkill?

I'm also going to try and add a WARN to detect if the @val parameter passed=
 to
emulator_read_write() is ever on the kernel stack, e.g. to help detect lurk=
ing
bugs like this one without relying on kasahn.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c8e292e9a24d..dacef51c2565 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1897,13 +1897,12 @@ static int em_enter(struct x86_emulate_ctxt *ctxt)
        int rc;
        unsigned frame_size =3D ctxt->src.val;
        unsigned nesting_level =3D ctxt->src2.val & 31;
-       ulong rbp;
=20
        if (nesting_level)
                return X86EMUL_UNHANDLEABLE;
=20
-       rbp =3D reg_read(ctxt, VCPU_REGS_RBP);
-       rc =3D emulate_push(ctxt, &rbp, stack_size(ctxt));
+       ctxt->memop.orig_val =3D reg_read(ctxt, VCPU_REGS_RBP);
+       rc =3D emulate_push(ctxt, &ctxt->memop.orig_val, stack_size(ctxt));
        if (rc !=3D X86EMUL_CONTINUE)
                return rc;
        assign_masked(reg_rmw(ctxt, VCPU_REGS_RBP), reg_read(ctxt, VCPU_REG=
S_RSP),

