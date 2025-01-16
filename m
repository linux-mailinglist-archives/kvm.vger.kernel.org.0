Return-Path: <kvm+bounces-35681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E68A14156
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 19:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0C693A2F98
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 18:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF6C22D4EC;
	Thu, 16 Jan 2025 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i5NjK2p8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B41428E7
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737050492; cv=none; b=hXdb03hocm5zzicKxRpD6yj9FHqtGFoIkwnAV/eA4lYPxFy4rTcK61gGP4jT8irMzNZDtRbp5bimWr71uUeZSXh/sQmo5gNCTtRxuu/+YYaj207WZW49a5BYtUt6ABSI6XCKfMb+aHjkK3x32M9kKD8YI5qDKf1OQAd9nWie+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737050492; c=relaxed/simple;
	bh=FVCcM1bmP8n7igPwyVgnG98h7VYBXJXDmiuOC6CuOWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OM3b1ePICDNN7+beIwckNjLGcVrYtihcD/1CPkDF3omiRZpH6zZRAV1QSupbgWXUTIIkopSPtrwYMbHrK2mRtW0zmXwoV87iJpQL2veDKFHC9LDF9OEd5yoJ8wpmtKEItBegrsrMyIFggLckDz0+F5RXIyg6sFmn/bNTMSpBtuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i5NjK2p8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so3844935a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 10:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737050490; x=1737655290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G9SH9U0n4ScQtvRfb8QH6l3/ztf+u3MBKmjQCKoC3O8=;
        b=i5NjK2p8qbaijujbVQkdCAEIMCBV7mfHf2Ve+OH2bDODyxeT649syAiTRYJwA2fkIt
         J29Q4qHbNURdnXpF8HwPjimgRtaTHd55MY+GH56BTVIRQ8xW/sdRcfnhsXf7fsuRt01x
         mY6JZU1oosaY40yLMkTysvshJazMk3jsxMdgGylwiH/5Xw0LvQnnoWl4Iu1Iu4H0/M3R
         JaS29i5i500Hx3cFUN2OV5u8dDmK9aPT6xOElI9ydpQA5CUvovdcaMtwsQZQ3Wl548FD
         4Cmq8ROZyAxfOoVJrfGJOmjPNBRK6F3mz0HioGg3pQMRwYhsFLqRPN0XsI9P+PeTZ5C9
         UwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737050490; x=1737655290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9SH9U0n4ScQtvRfb8QH6l3/ztf+u3MBKmjQCKoC3O8=;
        b=lM5L0UZcaLdMPo/EOppH94N1dFgBVM04klULoFmaYaRfB4VzxJAGYM838YezXUaLu9
         nQvyolCtNco9XLAYoL9t6Q5vOvs8k9u6Wpemie6lys67Y+1RPeZrVSOnHFrCvMQ/9ho2
         JgQnFWsJh73pdSj372WaWhxU7RvXujzDztOXZ5rrzH9ZTPerXOVVu8PoiM5z1vSItXtw
         NNUeDnqpUVRmS44/fSHbmcrGpGrOiuOgY7Ql7FyTUhwgb/iMHAtk+wyqRF0HiXvwK0ZI
         ba/FiqPedh7N5m6KvJJoA53R5fQBiDYAsAtW9BWG5c2mdusJ4pkH/El9J50tnBFKqA4e
         fUNA==
X-Gm-Message-State: AOJu0YxBD8TrTJiyS/nPoHnO4LHmjXRoTEeE65MY1YX5KL7+fR2S2HMe
	KZM5N9BjWrLVPlvLuPechbpN8k3VBKtKOtK3tEogMcHjDKYQxVDpslW9b17Ia9ruxlefT/CkIrC
	0kw==
X-Google-Smtp-Source: AGHT+IFnz5qkkpbHKHvIY9X2JNZh7fL9mYPfmEoDm+fvqAKga7ijY8uVwKZwhhO9TzX0EcG4kdHIUKjHDx0=
X-Received: from pjbqn5.prod.google.com ([2002:a17:90b:3d45:b0:2ea:61ba:b8f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:37c5:b0:2ea:3f34:f18d
 with SMTP id 98e67ed59e1d1-2f548eae685mr51210908a91.10.1737050490089; Thu, 16
 Jan 2025 10:01:30 -0800 (PST)
Date: Thu, 16 Jan 2025 10:01:28 -0800
In-Reply-To: <6719eaeb.050a0220.1e4b4d.00a0.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6719eaeb.050a0220.1e4b4d.00a0.GAE@google.com>
Message-ID: <Z4lJeDIHfFT9_GG6@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_put_kvm (2)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+4f8d3ac3727ffc0ecd8a@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 23, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    15e7d45e786a Add linux-next specific files for 20241016
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1397b240580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c36416f1c54640c0
> dashboard link: https://syzkaller.appspot.com/bug?extid=4f8d3ac3727ffc0ecd8a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/cf2ad43c81cc/disk-15e7d45e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c85347a66a1c/vmlinux-15e7d45e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/648cf8e59c13/bzImage-15e7d45e.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4f8d3ac3727ffc0ecd8a@syzkaller.appspotmail.com

Yet another bcachefs shutdown problem.

#syz set subsystems: bcachefs

[   88.514126][ T5826] bcachefs (loop1): flushing journal and stopping allocators complete, journal seq 4
[   88.569826][ T5836] EXT4-fs (loop2): unmounting filesystem 00000000-0000-0000-0000-000000000000.
[   88.618725][ T5826] bcachefs (loop1): clean shutdown complete, journal seq 5
[   88.807819][ T5826] bcachefs (loop1): marking filesystem clean
[   89.094513][ T5826] bcachefs (loop1): shutdown complete
[   89.339441][ T6085] loop3: detected capacity change from 0 to 32768
[   89.629580][ T6096] loop4: detected capacity change from 0 to 40427
[   89.700754][ T6096] F2FS-fs (loop4): build fault injection attr: rate: 771, type: 0x1fffff
[   90.062540][ T6085] XFS (loop3): Mounting V5 Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
[   90.081642][ T6096] F2FS-fs (loop4): invalid crc value
[   90.127830][ T6098] tty tty20: ldisc open failed (-12), clearing slot 19
[   90.438369][ T6096] F2FS-fs (loop4): Found nat_bits in checkpoint
[   90.558422][ T6085] XFS (loop3): Ending clean mount
[   90.619095][ T6115] loop0: detected capacity change from 0 to 128
[   90.643095][ T6085] XFS (loop3): Unmounting Filesystem c496e05e-540d-4c72-b591-04d79d8b4eeb
[   90.671995][ T6096] F2FS-fs (loop4): Mounted with checkpoint version = 48b305e5
[   91.300054][ T6117] syz.0.30 (6117): drop_caches: 2
[   91.503301][ T6118] syz.4.29: attempt to access beyond end of device
[   91.503301][ T6118] loop4: rw=2049, sector=77824, nr_sectors = 144 limit=40427
[   91.556455][ T6096] F2FS-fs (loop4): inject lock_op in f2fs_trylock_op of f2fs_write_single_data_page+0xd20/0x1bd0
[   91.604651][ T6096] syz.4.29: attempt to access beyond end of device
[   91.604651][ T6096] loop4: rw=2049, sector=77968, nr_sectors = 112 limit=40427
[   91.632912][ T6091] ------------[ cut here ]------------
[   91.638499][ T6091] WARNING: CPU: 0 PID: 6091 at kernel/rcu/srcutree.c:681 cleanup_srcu_struct+0x404/0x4d0

