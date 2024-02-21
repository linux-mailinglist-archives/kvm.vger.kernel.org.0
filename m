Return-Path: <kvm+bounces-9310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E8685DD39
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:03:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A9161F2298D
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 14:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EBD7E774;
	Wed, 21 Feb 2024 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ij2N9qP2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89A67D3F4
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 14:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524143; cv=none; b=f1sTIiFMy/l82kLIx3r4gaIZrofcuwQ0vhHk39lEwnaOI8ApU4Vgx6FfTD73ykTV3KUw2/GCVsS5bJoj6SXVhvkRP8eAT6RQTkyeC3IFZKqhmULzbFjH2K486vBeonfIoFjwaPUkqD7oqfuxHeSHAQukKxnKvugBbX8OGh08UCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524143; c=relaxed/simple;
	bh=dTek2E7jXJK0EGI3Wlek8LmLnzUne7yFDDD7rfKMk9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gY+5iDjESbenB4batdbCJJexyMm/pTrzatuAX6xBBSBWU/NU9RTelzh312ktWteFAtXVlUqgzN8RHPvNJn6YJV4MwB+Jzag9yYkT/0qd7cvNK4PBNn5Vebe7Sv8570ZX1k9pm30SBPpzq0D3xpf/LISN7zQso48IaZnRD8zmmW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ij2N9qP2; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e3a5d1ca1eso2848407b3a.2
        for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 06:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708524141; x=1709128941; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFcAXLxuJ2hj6tXb8HK3JEiOXAeHYKmjz7J6WSMN/44=;
        b=Ij2N9qP2A2iGkxWp3/tW9QeiHVH0rqGDlPaw3ZUam21NEZHPm9K3kKq8S7YtGf289f
         8kyIu/SwztpjUq+83T2P81qvJI/31dKbsFk38xpkgV61b/K6HrplKFmK0VHRJsQ21eJA
         FA/1TIhXPGFYvcQ0s2bS9yOoU3i/1VqpkTh4bKzJVsAsExsE7Cc9uFIbMi7yCTgvp1de
         6bteDqQYgNkeV1GX+Sa6joFeOnnL237iGPsu9zdf4N7bV4SmGed8lKpNzDmCfxqNg1dr
         JPZBwKBHNuWyzbT2KZyoEvXfF1ejbDF9xi6JNyJjBCiVSuv+7niABez2rRqTtVW16QNb
         WT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708524141; x=1709128941;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFcAXLxuJ2hj6tXb8HK3JEiOXAeHYKmjz7J6WSMN/44=;
        b=DkLtn5lMj3G+jVhFoa8H71moXzaFRBJH3/r4VdWL7tnbzX3Hrb188EjQq3YFaWSyM9
         y3tvG4AOEmaUe3xvPSLUenTAiJI9ot9Tsj+N9y4ZeZ1KjjYySJJzgh5PTkRR2NjNv2UU
         gv6z3RWg/q9OdZw3naYd9f8KD09596beb5dlejuxK/bKUJv0W4foIXs8+Zxvvocrydfu
         P4t5BrBmFKfhN4/eVaI/THy8tub8dZap7+8XjSiG6PAgueN93DCk5h6vmeXh6se78Hhf
         qcpm6fAHP2Cf1HzyVqOT90BD/yvVQm+wNZqhlIS/fdX03cJRMCgXFqd0DFAVecR+NS8z
         jxlw==
X-Forwarded-Encrypted: i=1; AJvYcCX7DhUzkJ8NIQxTCi/ZsL8Qq0NOw6q2eyWDu9MLCRHFZFlNk22BvvoWlnBDrae6rwFwcFqWfDLVxwx5lfI1kEUeKvP0
X-Gm-Message-State: AOJu0YxEfFRKrEKXqJZjfPzg9gxyYchvBV5Oq00dcL9txrAMQdmfObOW
	ofmGTpSMAo/EOPbd7CUeYq0lEgSRV/BcTVYo9qbTnx2mcJD11h/C/NQuG2QwcijnHjPB2KVPRHl
	KyA==
X-Google-Smtp-Source: AGHT+IGRBUSegRKWvY9k/MUiR2zPJpvxmSAVwmL409Aq1G+pJ/bRUUEiomtWWOZYvhWEyQpKPyyiJsTtiU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d2a:b0:6e4:8fd5:e415 with SMTP id
 fa42-20020a056a002d2a00b006e48fd5e415mr41118pfb.6.1708524141325; Wed, 21 Feb
 2024 06:02:21 -0800 (PST)
Date: Wed, 21 Feb 2024 06:02:19 -0800
In-Reply-To: <000000000000bc78610611e4bba1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000bc78610611e4bba1@google.com>
Message-ID: <ZdYCa0AbpLMPNX-1@google.com>
Subject: Re: [syzbot] [kvm?] KMSAN: uninit-value in em_ret
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+ee5eb98a07d2c1fb30df@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 21, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b401b621758e Linux 6.8-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15cd41c2180000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1b015d567058472
> dashboard link: https://syzkaller.appspot.com/bug?extid=ee5eb98a07d2c1fb30df
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c32ff3cbe7ed/disk-b401b621.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/17621a870a21/vmlinux-b401b621.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/b06ad3ca55ee/bzImage-b401b621.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ee5eb98a07d2c1fb30df@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in assign_eip_near arch/x86/kvm/emulate.c:829 [inline]
> BUG: KMSAN: uninit-value in em_ret+0x124/0x130 arch/x86/kvm/emulate.c:2238
>  assign_eip_near arch/x86/kvm/emulate.c:829 [inline]
>  em_ret+0x124/0x130 arch/x86/kvm/emulate.c:2238
>  x86_emulate_insn+0x1d87/0x5880 arch/x86/kvm/emulate.c:5292
>  x86_emulate_instruction+0x13c9/0x30a0 arch/x86/kvm/x86.c:9171
>  kvm_emulate_instruction arch/x86/kvm/x86.c:9251 [inline]
>  complete_emulated_io arch/x86/kvm/x86.c:11208 [inline]
>  complete_emulated_mmio+0x70b/0x8b0 arch/x86/kvm/x86.c:11268
>  kvm_arch_vcpu_ioctl_run+0x1837/0xb890 arch/x86/kvm/x86.c:11380
>  kvm_vcpu_ioctl+0xbfc/0x1770 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4441
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:871 [inline]
>  __se_sys_ioctl+0x225/0x410 fs/ioctl.c:857
>  __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:857
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x63/0x6b
> 
> Local variable eip created at:
>  em_ret+0x37/0x130 arch/x86/kvm/emulate.c:2234
>  x86_emulate_insn+0x1d87/0x5880 arch/x86/kvm/emulate.c:5292
> 
> CPU: 0 PID: 5793 Comm: syz-executor.0 Not tainted 6.8.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/25/2024
> =====================================================

#syz fix: KVM: x86: Clean up partially uninitialized integer in emulate_pop()

