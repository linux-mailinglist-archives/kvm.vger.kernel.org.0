Return-Path: <kvm+bounces-34681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 425EBA04413
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 16:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F50D165FEF
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 15:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E84251F2C4E;
	Tue,  7 Jan 2025 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvSpjF2x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44BD1F37B9
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736263135; cv=none; b=kNIvYh5NyNKDUbeqA3B8gNa6zFf3qieqi5ZcVy5IlcSsEIzQveIIiqs5kG4V8IRTdt39tjG/D0cupYntE8Gi7ZxV7/XsyuZnXDjbxz+j2yy4tVP97eWepySAURHreE2byLKnqt53OlYwejorfcLP0/gArDyxoP4BsSpaVGqQgdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736263135; c=relaxed/simple;
	bh=J4jOUVbgufS94ifGA4xJigzAXfhzQ+YnL7s4a7AMLio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OGMNAbQIKf1TkFbpgMxSmA/5zM4N/CVv/EV5O4dqalRm0AdqRDQ1zasikFog82u0oogv8cXtqMnGZAuQREOAW2oI/MDeGeVVjoIZjmJsJMrGgmpRAXyagGKSUQcLwXQ3N8iOoNIvnaxGSG/mrE6gbmicsjMnaLQwt9jX+/7wbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvSpjF2x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216266cc0acso201894735ad.0
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 07:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736263132; x=1736867932; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sFafl1QWxUnle1/ua59LWS6z4kylo3bgxeWEmB+11cc=;
        b=kvSpjF2xfYn4NF3UEqUCoN4G32o0uX1L8gSrOSSwCiALmoPNVdYAwshDFK9eeD/kj4
         ojh0Z2JLHyTaN9xNnDcA1D9hwCuqOt0iZ1leUp3P/xkJk0KVyAaaxMISajzYC0qTp+4h
         QZYUh6mZw14yoYO+m0VKnVvVue+g72d1Gvp3VFsn91XJ3lO80vhmILo/xDjTw45IrnAp
         rYvgZKc5r693pBjRD70lSSjvFhOb2BnLtGhpqS67/kWXx1jqi8iap2oGrvxktZdHwNKd
         oQCQ5jnkEOWbBoqwbPLQj0fNpBwzUKXozphDqiJZTG1vyFQ1Igwcso6micH2GayHkUCg
         W69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736263132; x=1736867932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sFafl1QWxUnle1/ua59LWS6z4kylo3bgxeWEmB+11cc=;
        b=p4w6+fXK1UAsDn/OW55Z1nXZvbiltpmhmWMxaPpLT9xTjYXYM0yRPoP0noJoDNORse
         1g+A7iGCM8xn6YIftAe6NuiFu/1zUY91uKp7yTmt1HPk45FTqTfrssZ6Z/eUISjXamhN
         wuKTsdsw8dYArZaIt4GV+6ziklcByeqTNh18vyN0Lr5VN5mBxONw2qyc3JMMb1sbeN08
         gs0q/U/+I0mfH3kX/fKYI92Uoyi3k9wc3wEZotdyvdZFzVLbStrxGI9uqM97hf4BAjCN
         sER0P+jLGSyll+/RdpaCiYUR0DklFgCuPM7NaLd+hiihefr/y4fckpqWLxNbyveOffgi
         rNBw==
X-Forwarded-Encrypted: i=1; AJvYcCW4klB9VfjX95NA1JN7mWhQ6+jmg/yZMxTGl/6QXfdxyjZGsVu6yN4eMWRKbrYPlBfVoUE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj96xk4IdKypgJGSLM35Win90KKQDj49Fsbqes1e1yWGLj/Y8l
	C8WmlRqOukRdHY6ewVy43FlJCZZQDA6ss4m7NKpYq98Qodzs/MZ4HCxkal/hUIDxl2R+jUYmB/I
	Jsg==
X-Google-Smtp-Source: AGHT+IGbTRPtM0SvGqY7/2mgEJq63zWasFW8wLdEOl9y7KW09Vqr/JJXHtOsKgxwaA6qNsIuR7B6za2F2FQ=
X-Received: from pfbbw26.prod.google.com ([2002:a05:6a00:409a:b0:725:d8bc:33e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1412:b0:725:d9b6:3952
 with SMTP id d2e1a72fcca58-72d1039943emr5838123b3a.3.1736263132172; Tue, 07
 Jan 2025 07:18:52 -0800 (PST)
Date: Tue, 7 Jan 2025 07:18:50 -0800
In-Reply-To: <677c0f36.050a0220.3b3668.0014.GAE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <677c0f36.050a0220.3b3668.0014.GAE@google.com>
Message-ID: <Z31FmKRs73jh44Q9@google.com>
Subject: Re: [syzbot] [kvm?] possible deadlock in kvm_arch_pm_notifier
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 06, 2025, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0bc21e701a6f MAINTAINERS: Remove Olof from SoC maintainers
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=163abd0f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=86dd15278dbfe19f
> dashboard link: https://syzkaller.appspot.com/bug?extid=352e553a86e0d75f5120
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0bc21e70.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/7552d06d3231/vmlinux-0bc21e70.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0d1494ecdf2f/bzImage-0bc21e70.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.13.0-rc5-syzkaller-00012-g0bc21e701a6f #0 Not tainted
> ------------------------------------------------------
> syz.8.2149/14842 is trying to acquire lock:
> ffffc90006bccb58 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_suspend_notifier arch/x86/kvm/x86.c:6919 [inline]
> ffffc90006bccb58 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_pm_notifier+0xf5/0x2b0 arch/x86/kvm/x86.c:6941
> 
> but task is already holding lock:
> ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust kernel/notifier.c:344 [inline]
> ffffffff8dcbeb10 ((pm_chain_head).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain_robust+0xa9/0x170 kernel/notifier.c:333
> 
> which lock already depends on the new lock.

Huh.  I was going to say that this is essentially the same underlying problem
that led to commit 44d174596260 ("KVM: Use dedicated mutex to protect
kvm_usage_count to avoid deadlock"), where taking kvm_lock in notifier callbacks
is prone to deadlocks that are all but impossible to hit in practice.

But this is the per-VM lock, kvm->lock, not the global lock.  I don't see any
reason to take kvm->lock in kvm_arch_suspend_notifier().  vcpu->arch.pv_time.active
and vcpu->arch.pvclock_set_guest_stopped_request are protected by vcpu->mutex,
not kvm->lock, i.e. accessing those fields is racy no matter what.

