Return-Path: <kvm+bounces-68926-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFWsEiBrcmnckQAAu9opvQ
	(envelope-from <kvm+bounces-68926-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:23:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E3F6C522
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:23:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07ED430268A8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C340431E0EF;
	Thu, 22 Jan 2026 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HkVv4Wd1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57C636F43C
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 18:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769105468; cv=none; b=mIreVVtK/ONKS8oIvkdg6B76jpzp7qVhP27PaNl+ZqaUojFzUmT+deWeul2As2ftuhRjevdE8YuLD0O9qTxk8aQSzQ45nbMzBO/mZW/vROo8Ctej4Q3j4Lz/o0yg50psaiazz7QfMWCNyMqxNNHnMDV0TOlWCWOOpmHfGV9lGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769105468; c=relaxed/simple;
	bh=LQ1cU5dBiwli7RSyDmTu900APn5ruS/L8VoEFOvJKl4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SFmBLcbFrxK/B0/oJFpHQqKyjmk93M7pqwL0iH2gPo+t7I5l4bqZASmAzTaZfqlX9HYK6ua5S/E7DJTzpapJ37/ozR4lEQcWtGYO+BDwzaYXyl4nJslNoxy6YXfR2ERcdgNMOTzhGzseI6A5HDQOiEUCooN1NfkOfExn21avZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HkVv4Wd1; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8230e2c00dfso289791b3a.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769105455; x=1769710255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qin2VUt3SQDMRyPCezwz5AWwO3yWBYolVO5X/rukkgQ=;
        b=HkVv4Wd1GQ1gezAWIDuCeFRgMpp47qleOnE+u54FPmDgtdD3U+QiHrzl1Ac58xpA8F
         Y0RTpWMM3ufQsgI4QuGwKTi1Dnb6WUbCiJIKC+yO2zSza2c2UGHiiQyLOyErCzf6zr+s
         o9MWC/Puzp/IaNdQxGd5S04C8J9y9ncHAoiAGDCcbqjLI7N+R6VqxPgCn6k8v9BjxoOI
         AyD+R6M1jUFDbAwG/aASbBSTnAROOYPkMMMy/HmbeNpi2YXFg/0BJ4LYh+Oh/mE93YFt
         j+AuNzLPzG+wmpTvVLsQWdpN6oNXbRKwnUXSV5LkkvtTVZNNtDuNMe5J8UAUm21SZovd
         F4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105455; x=1769710255;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qin2VUt3SQDMRyPCezwz5AWwO3yWBYolVO5X/rukkgQ=;
        b=DJ8ro8jr1QkWMWTIWUDAd4Tyw+6kVg8V1db7AYjqXZ4DUrXN09lypbWCVlC9DhjwFO
         HwZujoZKOBNTBLyeasZv1GqpoYagvAS/z/p1rXBL+YSFkWVFyGZkBg36F9GaHjfMwoc0
         1KoPjT+CZ59x4t3w2LLJxUtRJvtyMeu6ZAwM0qMqZ+Ofk11o9kzt+iYERuhFjPGKcHSX
         m7rNTDR8OFCDa5H865NFGxIqU543j9rUXfO+B2AJYEP59WyLCdsmQIUY0Q8E/L3o4RFM
         zrQGhHihgcTojYFzsiM4wVEXRHK6knL8Ma/+3uq2sam7rJHnWtWMjRt1wM2s7R9GQeCm
         Uyuw==
X-Forwarded-Encrypted: i=1; AJvYcCXuzLqc1TzpgA4kVznZmhX3RqJWaQEgtiIzfH4q6kSnuuQy6LatoCLUm+XXGmvZdFYJ2fc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo0ZKHpichAmkI/nIsPWq/P9+QIt840uMvSrGag5KxpLmIDS5T
	OaZiGtpbsY1twrhsja1f+lSexYW6VGHmrg30qohpq0FTqD7ZoyZpwy0OaJfqZ/8VS31vVZIHBYF
	ZyzUZog==
X-Received: from pfnu10.prod.google.com ([2002:aa7:848a:0:b0:821:813f:e13f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1c88:b0:81f:82b2:ecf8
 with SMTP id d2e1a72fcca58-82317ed8d49mr159949b3a.63.1769105455159; Thu, 22
 Jan 2026 10:10:55 -0800 (PST)
Date: Thu, 22 Jan 2026 10:10:53 -0800
In-Reply-To: <CAG_fn=Vz+xPd2jzRPL0jRsb8usA7NzusP_3NsfeAPCZqOgMJeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6925da1b.a70a0220.d98e3.00b0.GAE@google.com> <692611ac.a70a0220.2ea503.0091.GAE@google.com>
 <aSY3RJI6uvrbh92_@google.com> <CAG_fn=Vz+xPd2jzRPL0jRsb8usA7NzusP_3NsfeAPCZqOgMJeg@mail.gmail.com>
Message-ID: <aXJoLen8Vkih4yBA@google.com>
Subject: Re: [syzbot] [kvm-x86?] WARNING in kvm_apic_accept_events (2)
From: Sean Christopherson <seanjc@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: syzbot <syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com>, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68926-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,storage.googleapis.com:url,appspotmail.com:email,googlegroups.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm,59f2c3a3fc4f6c09b8cd];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: B8E3F6C522
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Alexander Potapenko wrote:
> On Wed, Nov 26, 2025 at 12:10=E2=80=AFAM 'Sean Christopherson' via
> syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Tue, Nov 25, 2025, syzbot wrote:
> > > syzbot has found a reproducer for the following issue on:
> > >
> > > HEAD commit:    8a2bcda5e139 Merge tag 'for-6.18/dm-fixes' of git://g=
it.ke..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1604f8b45=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Da1db0fea0=
40c2a9f
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D59f2c3a3fc4=
f6c09b8cd
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909=
b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13ecf61=
2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13d9cf425=
80000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/d900f083ada3/non_bootable_disk-8a2bcda5.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/fc3f96645396/vm=
linux-8a2bcda5.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/e20aa7be5d=
33/bzImage-8a2bcda5.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 5495 at arch/x86/kvm/lapic.c:3483 kvm_apic_accep=
t_events+0x341/0x490 arch/x86/kvm/lapic.c:3483
> > > Modules linked in:
> > > CPU: 0 UID: 0 PID: 5495 Comm: syz.0.17 Not tainted syzkaller #0 PREEM=
PT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debia=
n-1.16.3-2~bpo12+1 04/01/2014
> > > RIP: 0010:kvm_apic_accept_events+0x341/0x490 arch/x86/kvm/lapic.c:348=
3
> > > Code: eb 0c e8 32 da 71 00 eb 05 e8 2b da 71 00 45 31 ff 44 89 f8 5b =
41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 10 da 71 00 90 <0f> 0b 90 e=
9 ec fd ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 4f
> > > RSP: 0018:ffffc90002b2fbf0 EFLAGS: 00010293
> > > RAX: ffffffff814e3940 RBX: 0000000000000002 RCX: ffff88801f8ca480
> > > RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
> > > RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff814689b6
> > > R10: dffffc0000000000 R11: ffffed1002268008 R12: 0000000000000002
> > > R13: dffffc0000000000 R14: ffff888042c95c00 R15: ffff8880113402d8
> > > FS:  000055558ab60500(0000) GS:ffff88808d72f000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000200000002000 CR3: 0000000058d0b000 CR4: 0000000000352ef0
> > > Call Trace:
> > >  <TASK>
> > >  kvm_arch_vcpu_ioctl_get_mpstate+0x128/0x480 arch/x86/kvm/x86.c:12147
> > >  kvm_vcpu_ioctl+0x625/0xe90 virt/kvm/kvm_main.c:4539
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:597 [inline]
> > >  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > RIP: 0033:0x7f918bd8f749
> > > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f=
0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > > RSP: 002b:00007ffc74a3c2a8 EFLAGS: 00000246 ORIG_RAX: 000000000000001=
0
> > > RAX: ffffffffffffffda RBX: 00007f918bfe5fa0 RCX: 00007f918bd8f749
> > > RDX: 0000000000000000 RSI: 000000008004ae98 RDI: 0000000000000005
> > > RBP: 00007f918be13f91 R08: 0000000000000000 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007f918bfe5fa0 R14: 00007f918bfe5fa0 R15: 0000000000000003
> > >  </TASK>
> >
> > Syzbot outsmarted me once again.  I thought I had made this impossible =
in commit
> > 0fe3e8d804fd ("KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked check=
 to KVM_RUN"),
> > but now syzkaller is triggering the WARN by swapping the order and stuf=
fing VMXON
> > after INIT (ignore the EINVAL, KVM gets through enter_vmx_operation() b=
efore detecting
> > bad guest state).
> >
> >   ioctl(5, KVM_SET_MP_STATE, 0x200000000000) =3D 0
> >   ioctl(5, KVM_SET_NESTED_STATE, 0x200000000a80) =3D -1 EINVAL (Invalid=
 argument)
> >   ioctl(5, KVM_GET_MP_STATE, 0)           =3D -1 EFAULT (Bad address)
> >
> > At this point, I'm leaning strongly towards dropping the WARN as it's n=
ot helping,
> > and userspace doing odd things is completely uninteresting.
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 7b1b8f450f4c..df2a69da11b7 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -3521,7 +3521,6 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
> >          * wait-for-SIPI (WFS).
> >          */
> >         if (!kvm_apic_init_sipi_allowed(vcpu)) {
> > -               WARN_ON_ONCE(vcpu->arch.mp_state =3D=3D KVM_MP_STATE_IN=
IT_RECEIVED);
> >                 clear_bit(KVM_APIC_SIPI, &apic->pending_events);
> >                 return 0;
> >         }
>=20
> Hi Sean, this is still biting us.
> Have you made up your mind on the above patch?

I'll properly post and apply the above.  I have some ideas on how to preser=
ve
the basic gist of the sanity checks, though I hope I wrote them down somewh=
ere,
because I can't remember what they were...

