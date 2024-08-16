Return-Path: <kvm+bounces-24417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A5B9550B5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F5742841CF
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C703A1BF32C;
	Fri, 16 Aug 2024 18:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UcxQHT6A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD0978B50
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832442; cv=none; b=iBl1dIskqRtjcoT0T816mvWZkEdZl8AH4VoyWF78+B8zqJNb9cDj1kZwObvYEjjHRWFliNFzTTUCRj+t3kJNuzfIm8+RqjVBlQ3ntxT1qWlZHORbhIHDzEXvZgmLXQWum7pWgBLFELUNJanRb9dXGkOTIsKCp1R3iwHkndB4WnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832442; c=relaxed/simple;
	bh=IbVmYFoIxyQulrGV2li59J1UGx7YeDN54yW8QQYBykc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h8pk1sgFW7vr1eu636iujUH73UwuoWorCsW4xVozKIdyhbu0Z5lTuC/hEBF/PQqQTsQlnDe75imh43ZGBJ++8Kj9ld5OG4BCtmgkl4GtccA/IzBk1FQtlsJcxGRtorfAIMcM0IpXiqg2pErbzD2daJZLVjzY34myCaOdSHA5Zzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UcxQHT6A; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e11703f1368so3004777276.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832439; x=1724437239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N3tmSlk8QlfN4jJU+Ovee8DLWMKdOuytFzcWHsW6egI=;
        b=UcxQHT6AhAMhgRKwkaWv2qwVvCbCIjDZanMpY+imawmgO+Jy84qqB9RqXLiWMh+PR7
         mjVoZlhSZqm8u+A/3xNbro6CKu+ruI8AaUkfzH0sT9bzkOB6bsWk7W6LRuX2GfbNgvNk
         A21uDumh7dZmWv04IUE42angsxrhbGYkgeUUfRB9EqhJmtzpKrfrK+aTxgVWR+BFJT05
         GKJLPHwY+yHb9ZQBQhN4XqJWohTGj4jJpjbDC+AobV1DmoBn9jGZ3gwzCYxz2F3q5OBV
         /z+GagH5wLXl2thfcFKP3/ibbuQXPf6BzF+X0C7HDQlnb2HbDPWG0cxo+8fNWgchoq+r
         Jb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832439; x=1724437239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3tmSlk8QlfN4jJU+Ovee8DLWMKdOuytFzcWHsW6egI=;
        b=g/8wToXYnLKi+gq25jeeqid7N02tRhjUb4TkrlAJoSjw/zs/bkjfiSm4H/AUKQIwgN
         fe8eWaBqc00NjpGOY4VePO2XZ6RyzuhRAReLjCq7NXd8gBJxgVVGfudsOH28/4DbAcx6
         r4f1wLXKzCGr6jg4bWSWlYk2cs31gdsCmcmZI/gq8xsgjl5QBY6uK3JIePIt4SdnOeum
         1XHOx7HribzkpmDro5Kdniagn3tlyOuZ54Nxd7EL8K29CN8ORGGxuGbyIzE96dW5uHqg
         0bGwAn1s+I9ObPfFjHnspaXL7xUxyKKXSIdIpMn9LF4gbvfbIcT8rF8TJNA0WE241Qt+
         TWyw==
X-Gm-Message-State: AOJu0YyUbewP9ykwLdSLdZUE/Y+yL/WvTWmI8HJy+CiFZKWLWva8rdTr
	mT69zQKXjzDPVTqucYy3UF4uIEKsAgJ6fJJ/ogeLQUl7L5DuUtXF4tZi1y4dzo63LOxrJDyLJ+G
	a/g==
X-Google-Smtp-Source: AGHT+IH53F61lOun6gFWjC7pOAiTbzvO9f/I6y3MGI837xE97OoqGPqg4QBoHrpu5k9vU+7gjfC5O97rXuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2943:0:b0:e11:5c41:54e2 with SMTP id
 3f1490d57ef6-e1180ba7fa8mr6979276.0.1723832439504; Fri, 16 Aug 2024 11:20:39
 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:20:38 -0700
In-Reply-To: <000000000000fd4bde061b17c4a0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000fd4bde061b17c4a0@google.com>
Message-ID: <Zr-Ydj8FBpiqmY_c@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_put_kvm
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+d8775ae2dbebe5ab16fd@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 17, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1695b7ee980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
> dashboard link: https://syzkaller.appspot.com/bug?extid=d8775ae2dbebe5ab16fd
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a4edf8b28d7f/disk-2ccbdf43.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5f9b0fd6168d/vmlinux-2ccbdf43.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a2c5f918ca4f/bzImage-2ccbdf43.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d8775ae2dbebe5ab16fd@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 17017 at kernel/rcu/srcutree.c:653 cleanup_srcu_struct+0x37c/0x520 kernel/rcu/srcutree.c:653
> Modules linked in:
> CPU: 0 PID: 17017 Comm: syz-executor.4 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> RIP: 0010:cleanup_srcu_struct+0x37c/0x520 kernel/rcu/srcutree.c:653
> Code: 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 0f 0b 90 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 <0f> 0b 90 e9 35 ff ff ff 90 0f 0b 90 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc90003567d20 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffffc90002d6e000 RCX: 0000000000000002
> RDX: fffff91ffffab294 RSI: 0000000000000008 RDI: ffffe8ffffd59498
> RBP: ffff88805b6c0000 R08: 0000000000000000 R09: fffff91ffffab293
> R10: ffffe8ffffd5949f R11: 0000000000000000 R12: ffffc90002d778a8
> R13: ffffc90002d77880 R14: ffffc90002d77868 R15: 0000000000000004
> FS:  00007fa719dec6c0(0000) GS:ffff8880b9200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020078000 CR3: 000000006176a000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1351 [inline]
>  kvm_put_kvm+0x8df/0xb80 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1380
>  kvm_vm_release+0x42/0x60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1403
>  __fput+0x408/0xbb0 fs/file_table.c:422
>  task_work_run+0x14e/0x250 kernel/task_work.c:180
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
>  exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>  syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
>  do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

syzbot reported a rash of KVM cleanup_srcu_struct() splats, and while they suggest
that KVM has a rogue SRCU reader, I strongly suspect that something is/was going
sideways with bcachefs, and KVM is an innocent bystander.  All of the splats have
bcachefs activity shortly before the failure, and syzbot has never managed to find
a reproducer.

If if KVM were at fault, e.g. was accessing SRCU after its freed, I would expect
at least one report to not include bcachefs activity, and I would think we'd have
at least one reproducer.

Furthermore, except for the __timer_delete_sync() splat, all of the issues
mysteriously stopped occuring at roughly the same time, and I definitely don't
recall fixing anything remotely relevant in KVM.

So, I'm going to close all of the stale reports as invalid, and assign the
__timer_delete_sync() to bcachefs, because again there's nothing in there that
suggests KVM is at fault.

        general protection fault in detach_if_pending (3) bcachefs kvm		5	52d	52d	
        general protection fault in get_work_pool (2) kvm			5	59d	59d	
        WARNING in kvm_put_kvm kvm				                14	51d	60d	
        KASAN: wild-memory-access Read in __timer_delete_sync kvm		5	14d	81d	<= ???
        WARNING in srcu_check_nmi_safety kvm				        255	51d	104d	
        WARNING in cleanup_srcu_struct (4) kvm bcachefs				3567	51d	105d	

#syz invalid

