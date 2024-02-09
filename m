Return-Path: <kvm+bounces-8488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6B384FE2A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:07:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 138D11C22542
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 21:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5353817BC8;
	Fri,  9 Feb 2024 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GiHQOwb8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C614F6C
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 21:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707512844; cv=none; b=eQvURNTKUc+mDxjJbM0vlyjm7IJS2eDI80jGyPUKY4Pf3saVFrkQPeXuy8yKDyK9/bqu4xf1YBvl7WcYN2iHnQZulGtfMcJDhoCL8XbjlnoStDP0K0h5smUXeQ7oNP58BT0JV/9t5CrkSkRbDFlDzAFPwHe6xjnGxXL1HCFHd2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707512844; c=relaxed/simple;
	bh=EsssZPfuAofzCYmifTEhn5L6k/IYT1EjOB6B81GWfQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LlbVZbGEpzpQHUSBVrk2pb7ZR5uKBjhMti9VUEgMEdZ8KYqRAQqShGztU4OGo2XdktJTcqfPgv68OMBBBRiAIzbUaWsjzu1z2Es4+nDQuGulEis16S6nzT+Ws1Y+UZ3mFJfJYpVlTjZvFjpWmgX4ZhuPGVIt+2/O/Tm4CFz0UBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GiHQOwb8; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269b172so3215010276.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 13:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707512842; x=1708117642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJVA7E4OPiD00glr6A2eE7hMnsJp0FoP1xE3INulbjM=;
        b=GiHQOwb8WUG6fBVWqqW7XtV8lwwikpuA16Jxl3d7GkbymzzcSG3J/57H77NC6LRg5j
         2MFc9d8a8BbJvXryVliz54FXtqBWFov0iws0K3O37FzybhWocI9D6usdBFLQpoqbkhIk
         u1S4d7Q+k8huoAWe/ZTpVElj1bUXQh0DLrQWhpPg955Iwue6vwiF6mf6kh2d/tDRmgje
         1RQgtICQMo9k5XEzYBjrESRQWOjXjMQ722yWs6bQB9rT4uQRO1iqUXnBoAhTHBBei1t+
         D723gS4+zXizbPqFRq3/wdKrX+Zzz6BksPNQP0pvkp7j/Nvu8pnGhyOIg/C4ylEpj11O
         4jUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707512842; x=1708117642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJVA7E4OPiD00glr6A2eE7hMnsJp0FoP1xE3INulbjM=;
        b=PZwN6jfAATEKcBRf0u8XsQNqkeyYL+bjvWoUVmVssjnzSA1uaLyBYwzyw9VckrAW99
         J+09GbsIC5b2VrGXHD3psHTAziGF42oSNe01L38CYXp0qSGUgruWca6Qpiv+WNOmKyMS
         +BQ7Htl+tQGVTmiXqb93N40DO+Tj58hs40FR4fywNltVwIRFHERhXuSZ7mgEB++z1IwW
         NkGuaJOV8TauU/ZjgdL7uRTfaX9IHkG5Q0sAkZKUFae1PuLoClHsZKJZVrUwBicJk9Tr
         KhcIpHGaT00/PHI0jqjb4KLB6ZcJvHhw/VyLlspHdHMkp6F3U1QJLN3ekl5fCS29iNHl
         Cd7g==
X-Gm-Message-State: AOJu0Yyk4efLBjOOmhUgXItBoLDl59CW6/uBGavNa6ti/4MKHdgdRszT
	i09nlMJnePYk4F1iLq0PKkNw/PlYWBQex2J8yWZl63AOGCaJiwQJs530CDuJCjPav7KLdcN5+eL
	0+g==
X-Google-Smtp-Source: AGHT+IGUHHBgahILEYWs+MFS2D8cEf65K6zPE01Gf0qcohepgEWrWwH95oTQfWnppRqpfBG3AOVVBhi0ZVA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1002:b0:dc6:e884:2342 with SMTP id
 w2-20020a056902100200b00dc6e8842342mr79952ybt.5.1707512842181; Fri, 09 Feb
 2024 13:07:22 -0800 (PST)
Date: Fri, 9 Feb 2024 13:07:20 -0800
In-Reply-To: <000000000000f6d051060c6785bc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000f6d051060c6785bc@google.com>
Message-ID: <ZcaUCPka_WL4ruTq@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_mmu_notifier_change_pte
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 13, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f2e8a57ee903 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14fdc732e80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e56083f7dbe162c2
> dashboard link: https://syzkaller.appspot.com/bug?extid=81227d2bd69e9dedb802
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129d09cae80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b8afeee80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7b75e59fc59d/disk-f2e8a57e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f853580d61be/vmlinux-f2e8a57e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8c893ce02e2c/bzImage-f2e8a57e.xz
> 
> Bisection is inconclusive: the first bad commit could be any of:
> 
> d61ea1cb0095 userfaultfd: UFFD_FEATURE_WP_ASYNC
> 52526ca7fdb9 fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs

#syz fix: fs/proc/task_mmu: move mmu notification mechanism inside mm lock

