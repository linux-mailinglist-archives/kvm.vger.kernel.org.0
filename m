Return-Path: <kvm+bounces-13250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41A0A89351F
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBD0128CC0D
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8883A154458;
	Sun, 31 Mar 2024 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+pNu5gn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF2D148312
	for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 16:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903910; cv=none; b=bIFTLckF6JzwOSzR9jWgU5M6IKJb+z5KVZ815thgvq+MVjYTUL7fFeU7q5gVJFa3vXAQAnafasWIo49OM00pP48t+08iLGGGuE9dkmOtSB4POdZBQkfCEDRHqEhhvMLiio/rpL/9NNuT1SwKjsZ4SiVa3A6eBxZMP4PtmabIF9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903910; c=relaxed/simple;
	bh=dG7TnYERaAQFIVxnhKFSS43cH5VbX048ejCIIW68bkw=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=jYAYfGJb988ucBSJH2sq0vlEh653MRK8DONpM4x0GRxwUEmdobgx9ZmVVkba1NCJiN17p25MXw2o+WPjbQUbYbjpnrZcERSm0EMFGI/5HRujrIQ9GYZapLNQdDapFCC0l0JS/aVDF3fEOCBbPtPZghxYFDNfOZBsDGE4gXm7UdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d+pNu5gn; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e89e1db773so109306a34.1
        for <kvm@vger.kernel.org>; Sun, 31 Mar 2024 09:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711903907; x=1712508707; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:references:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p9IE4LKcrDDdHGNAoEwac6BCQiLbZYI9uxnr5Sr/GCs=;
        b=d+pNu5gnk778bd0YXn8Qwbt6Vs7lXo5RMmC9HUAghAWB/6fk+vk2Z+czVKnuviaq/t
         uBogoycR0uMeq8OTUgcGwkm/IbZ25FUCZllANuHOr+i6xqvWIpw+2wPlj/8BhfBz8OS9
         lKav5NHkrsmM84cnti8XBqtHPUI6klj9OmQ5qqAQsK8swMpwrgoaC9iIGpnmMH29PzDy
         Fu4u9i00D7qOvJJacuwROOhLCnqNwQnXxvRnS91m5UFxBbPgI2D8lXFIEmJvV0VGAzWU
         Gsk6QVkYnxhfgnHlRwMIK48MX796oTgIpfhDi9jRf9r0eTT0u5kFEvSGx5F6Rcj+72Av
         MtqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711903907; x=1712508707;
        h=in-reply-to:from:content-language:references:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p9IE4LKcrDDdHGNAoEwac6BCQiLbZYI9uxnr5Sr/GCs=;
        b=rjiOXh59DE3DyYDG+/w5Qhu8nsElNXLUbKgD9VAETbD8FEf+wZqPP4eLjsjyBsHbPL
         pzGll8R885KGhtR2IP6cN0Lg2Eloc+9H0uRUZlMS44L+pWUNrHCNk02MYp7aj1ygGEbV
         h3Yjk24q9l7KmuFW4VrE/pupXiO3vWwIGQfP/k/L38ivpGlRw8zdesrefcaNKJjZQRq8
         CubcldhkL0QpicDwO40/FTOxSwoXPOIDh4L4Hmw7RJmS49vnf+Ex3AsWP9WgBQ7FEBmE
         zTdO9JVtNbRnSl398XY6ik8MQBxCMmTNuKha/akMu4W4ymj1vNd+gF/cmcdznU88OIQ4
         +M4w==
X-Forwarded-Encrypted: i=1; AJvYcCX6sx1YMzQn8pqSpZU5Edh0Z1Wdv7ypnM5bAXMOT42fZO/x+ZzMtbUMSPe1dw4mIMAiozNrMhf8E9k09QUKqAsYLhez
X-Gm-Message-State: AOJu0Ywjt/yiXyFkT0CMYwczQKkbVdJG3kF2w6rNT/nOH1NvuDs/tQ0y
	ocdMwc1rufU7j06rHuizDRqcQLmfP5okCJQswZTIGXSb4ql8E4CgJ+aChO2k
X-Google-Smtp-Source: AGHT+IG9tL/Jf9362Rx9tbfwK6Zuaf7jBGNrSPWdkQELR/6vP8tKGNi/HNlllMeowuulk+CvC7tLGw==
X-Received: by 2002:a05:6358:7406:b0:17e:f422:5e48 with SMTP id s6-20020a056358740600b0017ef4225e48mr8561099rwg.13.1711903906776;
        Sun, 31 Mar 2024 09:51:46 -0700 (PDT)
Received: from [192.168.1.146] ([116.86.31.222])
        by smtp.gmail.com with ESMTPSA id cx14-20020a17090afd8e00b002a20b83bd46sm5368765pjb.41.2024.03.31.09.51.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Mar 2024 09:51:46 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------0Srbdrxap7UJtBQyUy5GzTR0"
Message-ID: <31e473b8-8721-4421-9ebc-e7053e914030@gmail.com>
Date: Mon, 1 Apr 2024 00:51:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [kvm?] WARNING in mmu_free_root_page
To: syzbot <syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com>,
 kvm@vger.kernel.org, seanjc@google.com
References: <0000000000009b38080614c49bdb@google.com>
Content-Language: en-US
From: Phi Nguyen <phind.uet@gmail.com>
In-Reply-To: <0000000000009b38080614c49bdb@google.com>

This is a multi-part message in MIME format.
--------------0Srbdrxap7UJtBQyUy5GzTR0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/2024 11:55 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    928a87efa423 Merge tag 'gfs2-v6.8-fix' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=127c0546180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f64ec427e98bccd7
> dashboard link: https://syzkaller.appspot.com/bug?extid=dc308fcfcd53f987de73
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110481f1180000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177049a5180000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-928a87ef.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7979568a5a16/vmlinux-928a87ef.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1bc6e1d480e3/bzImage-928a87ef.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dc308fcfcd53f987de73@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5187 at arch/x86/kvm/mmu/mmu.c:3579 mmu_free_root_page+0x36c/0x3f0 arch/x86/kvm/mmu/mmu.c:3579
> Modules linked in:
> CPU: 0 PID: 5187 Comm: syz-executor400 Not tainted 6.9.0-rc1-syzkaller-00005-g928a87efa423 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:mmu_free_root_page+0x36c/0x3f0 arch/x86/kvm/mmu/mmu.c:3579
> Code: 00 49 8d 7d 18 be 01 00 00 00 e8 8f 32 c0 09 31 ff 41 89 c6 89 c6 e8 13 e7 6f 00 45 85 f6 0f 85 5d fe ff ff e8 25 ec 6f 00 90 <0f> 0b 90 e9 4f fe ff ff e8 17 ec 6f 00 90 0f 0b 90 e9 79 fe ff ff
> RSP: 0018:ffffc90002fb7700 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff88801e0186c8 RCX: ffffffff811d855d
> RDX: ffff888022f9a440 RSI: ffffffff811d856b RDI: 0000000000000005
> RBP: ffff888024c50370 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff938d6090 R12: 1ffff920005f6ee1
> R13: ffffc90000fae000 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007fe2bd3e76c0(0000) GS:ffff88806b000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055ccab488ee8 CR3: 000000002d4ee000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   kvm_mmu_free_roots+0x621/0x710 arch/x86/kvm/mmu/mmu.c:3631
>   kvm_mmu_unload+0x42/0x150 arch/x86/kvm/mmu/mmu.c:5638
>   kvm_mmu_reset_context arch/x86/kvm/mmu/mmu.c:5596 [inline]
>   kvm_mmu_after_set_cpuid+0x14d/0x300 arch/x86/kvm/mmu/mmu.c:5585
>   kvm_vcpu_after_set_cpuid arch/x86/kvm/cpuid.c:386 [inline]
>   kvm_set_cpuid+0x1ff1/0x3570 arch/x86/kvm/cpuid.c:460
>   kvm_vcpu_ioctl_set_cpuid2+0xe7/0x160 arch/x86/kvm/cpuid.c:527
>   kvm_arch_vcpu_ioctl+0x26b7/0x4310 arch/x86/kvm/x86.c:5946
>   kvm_vcpu_ioctl+0xa2c/0x1090 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4620
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:904 [inline]
>   __se_sys_ioctl fs/ioctl.c:890 [inline]
>   __x64_sys_ioctl+0x193/0x220 fs/ioctl.c:890
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xd2/0x260 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x6d/0x75
> RIP: 0033:0x7fe2bd42e06b
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> RSP: 002b:00007fe2bd3e5710 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fe2bd3e5de0 RCX: 00007fe2bd42e06b
> RDX: 00007fe2bd3e5de0 RSI: 000000004008ae90 RDI: 0000000000000006
> RBP: 0000000000000000 R08: 0000000000000007 R09: 00000000000000eb
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000080
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000006
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
Shadow TDP

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
--------------0Srbdrxap7UJtBQyUy5GzTR0
Content-Type: text/plain; charset=UTF-8; name="free_page.patch"
Content-Disposition: attachment; filename="free_page.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11
L21tdS5jDQppbmRleCA5OTJlNjUxNTQwZTguLmI0Mjc1ZGMyMmQyMSAxMDA2NDQNCi0tLSBh
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMN
CkBAIC0zNTkxLDcgKzM1OTEsNyBAQCBzdGF0aWMgdm9pZCBtbXVfZnJlZV9yb290X3BhZ2Uo
c3RydWN0IGt2bSAqa3ZtLCBocGFfdCAqcm9vdF9ocGEsDQogdm9pZCBrdm1fbW11X2ZyZWVf
cm9vdHMoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX21tdSAqbW11LA0KICAgICAgICAg
ICAgICAgICAgICAgICAgdWxvbmcgcm9vdHNfdG9fZnJlZSkNCiB7DQotICAgICAgIGJvb2wg
aXNfdGRwX21tdSA9IHRkcF9tbXVfZW5hYmxlZCAmJiBtbXUtPnJvb3Rfcm9sZS5kaXJlY3Q7
DQorICAgICAgIGJvb2wgaXNfdGRwX21tdSA9IHRkcF9tbXVfZW5hYmxlZDsNCiAgICAgICAg
aW50IGk7DQogICAgICAgIExJU1RfSEVBRChpbnZhbGlkX2xpc3QpOw0KICAgICAgICBib29s
IGZyZWVfYWN0aXZlX3Jvb3Q7

--------------0Srbdrxap7UJtBQyUy5GzTR0--

