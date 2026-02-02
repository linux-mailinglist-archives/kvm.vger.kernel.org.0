Return-Path: <kvm+bounces-69790-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJJlGfb8f2lu1AIAu9opvQ
	(envelope-from <kvm+bounces-69790-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 02:25:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D11CAC7C26
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 02:25:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02E16300341E
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 01:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CF21E8332;
	Mon,  2 Feb 2026 01:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gK1KmXU9"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4234AEE2;
	Mon,  2 Feb 2026 01:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769995504; cv=none; b=Y3tktQOdFPPxH4pvlO9U+72XaG8zi2rfh8ZOjOzEwzBHEdfJV4IyqqdXzggXk+kod5Mm7RT64kLUHN57DbauLId8iMKr1h/9vbd4Glj2UxlO9+v3hKGB09npul1TVATV0dJk7wjxF+7lbJS9btSLTLEdCpS80Rsve6XgxNFpUMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769995504; c=relaxed/simple;
	bh=37LnPPuK+YXyvmA3CxHzBkqPdE6Qln617phYP4fYP8g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Go6wYR93BVLph9pzaPeFUyea8nvn9ST/w8lDboRnlVPdjkXj7E5I4g/8eRvmNtDWPPQ+8YtbYaKHuAZfGT/qyWawnSDfBufPYo/0KnX1xSQc/dzm/N9zkivEFeQQDGDgKphjtMyQFw2SYZfDuW5m9+l0idobOoSL/SWgMCDwsyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gK1KmXU9; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FQ3+XLRHs7vkMMN/TBvaecVisZLJrBpmK1EtzuG5rbA=;
	b=gK1KmXU9km+nKxDg84NaR8ogNCsMuvw7zG+fOj6gtXGRFO8y/3MMGke99BpqSkOHb1i+PFp47
	AvFPvhblDSCsME5KfsnZfMmSIWn3lRE5lWgZ6PN0iHXIlrF8EwFtNgzQ+bwv/JPTklouP0YWoK6
	ncSMPmlGBkmWGZZbOlJbyqc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4f481c609pzRhRZ;
	Mon,  2 Feb 2026 09:20:20 +0800 (CST)
Received: from kwepemj500016.china.huawei.com (unknown [7.202.194.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 151144036C;
	Mon,  2 Feb 2026 09:24:53 +0800 (CST)
Received: from kwepemj100010.china.huawei.com (7.202.194.4) by
 kwepemj500016.china.huawei.com (7.202.194.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 09:24:52 +0800
Received: from kwepemj100010.china.huawei.com ([7.202.194.4]) by
 kwepemj100010.china.huawei.com ([7.202.194.4]) with mapi id 15.02.1544.036;
 Mon, 2 Feb 2026 09:24:52 +0800
From: Zhangjiaji <zhangjiaji1@huawei.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Wangqinxiao (Tom)" <wangqinxiao@huawei.com>, zhangyashu
	<zhangyashu2@h-partners.com>, "wangyanan (Y)" <wangyanan55@huawei.com>
Subject: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
Thread-Topic: [BUG REPORT] USE_AFTER_FREE in complete_emulated_mmio found by
 KASAN/Syzkaller fuzz test (v5.10.0)
Thread-Index: AdyT4riNhTefFgfzSBuxneuHfKKRIA==
Date: Mon, 2 Feb 2026 01:24:52 +0000
Message-ID: <369eaaa2b3c1425c85e8477066391bc7@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-69790-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qemu.org:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhangjiaji1@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D11CAC7C26
X-Rspamd-Action: no action

Syzkaller hit 'KASAN: use-after-free Read in complete_emulated_mmio' bug.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in complete_emulated_mmio+0x305/0x420
Read of size 1 at addr ffff888009c378d1 by task syz-executor417/984

CPU: 1 PID: 984 Comm: syz-executor417 Not tainted 5.10.0-182.0.0.95.h2627.e=
ulerosv2r13.x86_64 #3 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
, BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014 Call Trace:
dump_stack+0xbe/0xfd
print_address_description.constprop.0+0x19/0x170
__kasan_report.cold+0x6c/0x84
kasan_report+0x3a/0x50
check_memory_region+0xfd/0x1f0
memcpy+0x20/0x60
complete_emulated_mmio+0x305/0x420
kvm_arch_vcpu_ioctl_run+0x63f/0x6d0
kvm_vcpu_ioctl+0x413/0xb20
__se_sys_ioctl+0x111/0x160
do_syscall_64+0x30/0x40
entry_SYSCALL_64_after_hwframe+0x67/0xd1
RIP: 0033:0x42477d
Code: 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faa8e6890e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004d7338 RCX: 000000000042477d
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00000000004d7330 R08: 00007fff28d546df R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004d733c
R13: 0000000000000000 R14: 000000000040a200 R15: 00007fff28d54720

The buggy address belongs to the page:
page:0000000029f6a428 refcount:0 mapcount:0 mapping:0000000000000000 index:=
0x0 pfn:0x9c37
flags: 0xfffffc0000000(node=3D0|zone=3D1|lastcpupid=3D0x1fffff)
raw: 000fffffc0000000 0000000000000000 ffffea0000270dc8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000 pa=
ge dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff888009c37780: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ffff888009c37800: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888009c37880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
ffff888009c37900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ffff888009c37980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Syzkaller reproducer:
# {Threaded:true Repeat:true RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Sand=
boxArg:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cgro=
ups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false NicV=
F:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:fa=
lse Swap:false UseTmpDir:false HandleSegv:true Repro:false Trace:false Lega=
cyOptions:{Collide:false Fault:false FaultCall:0 FaultNth:0}}
r0 =3D openat$kvm(0xffffffffffffff9c, &(0x7f00000001c0), 0x0, 0x0)
r1 =3D ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
r2 =3D ioctl$KVM_CREATE_VCPU(r1, 0xae41, 0x0) syz_kvm_setup_cpu$x86(r1, r2,=
 &(0x7f0000fe2000/0x18000)=3Dnil, &(0x7f0000000080)=3D[@text32=3D{0x20, &(0=
x7f0000000000)=3D"44c8df2020c020c003000000000f22c0671e26653e360f2224660f65b=
600000000b9e0450200f5e8f5e8f30f1ed6c744240000100000c744240200000000c7442406=
000000000f011424eacf5700000301b8010000000f01c1", 0x59}], 0x1, 0x27, 0x0, 0x=
1) ioctl$KVM_RUN(r2, 0xae80, 0x0) ioctl$KVM_SMI(0xffffffffffffffff, 0xaeb7)=
 (async) ioctl$KVM_RUN(r2, 0xae80, 0x0)


----------------------------
Hi,

I've analyzed the Syzkaller output and the complete_emulated_mmio() code pa=
th.
The buggy address is created in em_enter(), where it passes its local varia=
ble `ulong rbp` to emulate_push(), finally ends in emulator_read_write_onep=
age() putting the address into vcpu->mmio_fragments[].data .
The bug happens when kvm guest executes an "enter" instruction, and top of =
the stack crosses the mem page.=20
In that case, the em_enter() function cannot complete the instruction withi=
n itself, but leave the rest data (which is in the other page) to complete_=
emulated_mmio().
When complete_emulated_mmio() starts, em_enter() has exited, so local varia=
ble `ulong rbp` is also released.
Now complete_emulated_mmio() trys to access vcpu->mmio_fragments[].data , a=
nd the bug happened.

any idea?

--
Best regards,
Yashu Zhang




