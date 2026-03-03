Return-Path: <kvm+bounces-72507-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2CAGC9KUpmnmRQAAu9opvQ
	(envelope-from <kvm+bounces-72507-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:59:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED4D1EA790
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 08:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B5E830B61F2
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 07:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11E038645F;
	Tue,  3 Mar 2026 07:55:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA98B31B131
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 07:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772524558; cv=none; b=cuoBvO6+615Tr8qt92dAahzNtILozwXQXQW48Xe7MYs+o/xVYrccnLv+bu7U/lerG6kYFoesDZbeKAPiVmZTeAljt1z7le918IV2QrNB2BwS+8K+K4Rr1Qh64APNnfwSxmsoTlZ5+zekHuyqQ4jJb7sHFMxECDW+KNvnibwqbRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772524558; c=relaxed/simple;
	bh=Gji/OjmRu0DwoNZkvvQ+kxjDH0bpk0ZgWsanNwBiuF4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QPxcdI/Ckkcse4gkUIxatTeddVG7HDyprmu5lbWZ5V0N9/7RhDBacpXM/n/c3XgfO/HcYFxPRoHZDV+L19MfTmJLGQ47i+fgb4aPCg9qw4nuRKS6x9nImE1JM7fHCCG6JysGetlXAE7oi9Qv0htxdcKkGGqG8vAdShfNAdvsxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d498212845so27628799a34.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 23:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772524556; x=1773129356;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FgQSOpB+ewXh4n0VbeXUwNcBjIkpybIpFZepNJXEjKc=;
        b=ptxCUaIls4jPKUUxxtcWrK7eziSAJUV3dtzErByf/cypZs5YVwL8f7JcRLTpsv0WoE
         fGsGPF0HSfrwkU2OfzDVwXozK0M8c6HeiGG9Znd763PklZr9HpHPkAsT7JoSIMSwIxd2
         BhcieEGY9Qq0QXZIYhAXLbR88zaFeO3uyZaSfnLwEGpjNiFT8busbxfMRvMqOc0oagQC
         iJVhg6ukDQcYkuueUKY4j7sOIoNp7FF+UDrjsMKtHqX5y6vuMayvSrv7izFmsoVAFo8h
         85UbupvwKB/s26y7X08OZpNISWV1BEjwFNG5fHLbYer0kf3tfDOY3m631KDSgYwqqjHP
         R+sQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQKcJX2seyAVu2uC7XPUC080gvRezyKOwXc4sNfpk9kY8xJFKzyhjuOvBugXkDKiyODcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNU0iNdDVodzlIsfI5DMNer/HXYl+h0pbj9sPBPVYScjktcNxK
	LmseCwIyRr9CTjIFu1fVMUDvgutKefIpId51i4TpZJjSmT3exvmV/QpAFRXmQvxwucmWhXXfsxa
	rD5iJ8tGUL/3ObscbeeIkuJgelat7bKMF8+g+W6Z6DlAZ+pfCoE2jf1v+aS4=
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1895:b0:663:1b8:9c74 with SMTP id
 006d021491bc7-679faf8da8emr7462390eaf.68.1772524555798; Mon, 02 Mar 2026
 23:55:55 -0800 (PST)
Date: Mon, 02 Mar 2026 23:55:55 -0800
In-Reply-To: <20260302194926.90378-1-graf@amazon.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a6940b.a70a0220.135158.0007.GAE@google.com>
Subject: [syzbot ci] Re: vsock: add G2H fallback for CIDs not owned by H2G transport
From: syzbot ci <syzbot+cid397fd2b137e247c@syzkaller.appspotmail.com>
To: arnd@arndb.de, bcm-kernel-feedback-list@broadcom.com, 
	bryan-bt.tan@broadcom.com, corbet@lwn.net, eperezma@redhat.com, 
	graf@amazon.com, gregkh@linuxfoundation.org, jasowang@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, nh-open-source@amazon.com, sgarzare@redhat.com, 
	stefanha@redhat.com, virtualization@lists.linux.dev, vishnu.dasa@broadcom.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8ED4D1EA790
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[googlesource.com:url,googlegroups.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,appspotmail.com:email,syzbot.org:url];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.863];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-72507-lists,kvm=lfdr.de,cid397fd2b137e247c];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Action: no action

syzbot ci has tested the following series

[v2] vsock: add G2H fallback for CIDs not owned by H2G transport
https://lore.kernel.org/all/20260302194926.90378-1-graf@amazon.com
* [PATCH v2] vsock: add G2H fallback for CIDs not owned by H2G transport

and found the following issue:
WARNING in register_net_sysctl_sz

Full report is available here:
https://ci.syzbot.org/series/8be7b007-32ae-447a-bb92-b169bb844054

***

WARNING in register_net_sysctl_sz

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      01857fc712f6469cab9cc578120cdc80f1c2a634
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/5374f01b-dc57-486a-a2a6-2fb66c003b70/config

------------[ cut here ]------------
sysctl net/vsock/g2h_fallback: data points to kernel global data: vsock_g2h_fallback
WARNING: net/sysctl_net.c:156 at register_net_sysctl_sz+0x163/0x440, CPU#0: syz-executor/5808
Modules linked in:
CPU: 0 UID: 0 PID: 5808 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:register_net_sysctl_sz+0x1ad/0x440
Code: 00 00 00 fc ff df 41 80 3c 06 00 74 08 4c 89 ef e8 88 36 c8 f6 4d 8b 44 24 f0 48 89 df 48 8b 74 24 10 4c 89 fa 48 8b 4c 24 18 <67> 48 0f b9 3a 49 bf 00 00 00 00 00 fc ff df 42 0f b6 44 3d 00 84
RSP: 0018:ffffc90005357ab0 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffffff90234820 RCX: ffffffff8d01a100
RDX: ffffffff8d05e680 RSI: ffffffff8d05e620 RDI: ffffffff90234820
RBP: 1ffff110212d6810 R08: ffffffff8ff4f0c0 R09: ffffffff8e7602e0
R10: 0000012400000008 R11: ffffffff9a79ce5c R12: ffff8881096b4088
R13: ffff8881096b4078 R14: 1ffff110212d680f R15: ffffffff8d05e680
FS:  000055556a136500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c19e52af8 CR3: 0000000112a0e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vsock_sysctl_init_net+0x13f/0x2f0
 ops_init+0x35c/0x5c0
 setup_net+0x118/0x340
 copy_net_ns+0x50e/0x730
 create_new_namespaces+0x3e7/0x6a0
 unshare_nsproxy_namespaces+0x11a/0x160
 ksys_unshare+0x51d/0x930
 __x64_sys_unshare+0x38/0x50
 do_syscall_64+0x14d/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd97459da67
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffee0fc138 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd97459da67
RDX: 00007fd97459c799 RSI: 00007fffee0fc100 RDI: 0000000040000000
RBP: 00007fffee0fc190 R08: 00007fd9747d9610 R09: 00007fd9747d9610
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffee0fc198
R13: 0000000000000002 R14: 00007fffee0fc378 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

