Return-Path: <kvm+bounces-71914-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKf2Bkimn2mHdAQAu9opvQ
	(envelope-from <kvm+bounces-71914-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 02:47:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A99E19FEDE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 02:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 926F03060B35
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F1C3624DB;
	Thu, 26 Feb 2026 01:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXuyqNeP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2873372B44
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 01:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772070466; cv=none; b=kbxqY6S5sCNVn710RlPZL/OvcwBAQFzExorcAzJ/sU0EJ0dhsi7xxmwXsLsgzFOX0nFCC7aYlcYqt620QIZCPkpHeWcjv2rCzCih/V8sYV48r/HdAfFkLg+pGz4OurmMnowVIgPzAb8Gl2gZ/42uU1Xm+YISRh//+Snt+HnKuRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772070466; c=relaxed/simple;
	bh=f134Tod3jaISOuJ/2X6eUVCIIlmvQsjuVXA48eHIo3o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dQcdDPYAZsbDLqQbzai+XXRK48OJqne+VkJS3kls31T+omMAS0+dXdvfrLYbs3SiK1w4Jf8j+Vxk2FTZD5wStgBz5TxFaT0miJPDj3mdGluZJkwy0i1UMR/Qa73UztsX+M4sRYAZfP4UY8NnFrzHsr4lBNcPqd29WWoEsLfS80E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXuyqNeP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358df8fbd1cso241318a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 17:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772070464; x=1772675264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/KnV4oVfH16sVxdEzAUkTHJmU2+lcl4+7S0fmyw+FdU=;
        b=CXuyqNePFFpK1cxDXeV8kW4rBUXHSPmXmqJFhGvYrpeNgXn8OD6rOKo1p+Sev4vk6+
         gxScI9fMaHwpKrGorgsw951lXmZTg6FYjHbpNti/2JGhhv3Z/4dcq5gnZbq6qPWgXEXi
         fnVND3mSJ+aVCCPyM9u0AFQGfeKz1jYxZU1tEtd2AruXQmDTEtMwPSKz0kYY9oXHuo49
         sH+PB4svngmKTfg8B6px64fM6pgw2WwN2n5VWhm0BLTsSxKT8guxB/KoyiYZ3uwK1cGj
         NNHsNAaptBsCi0hFbPIdT1vMoiJOIUP505o99nt4M/PD6EzrkkiQNzILGSO+3/gtNCBx
         ORwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772070464; x=1772675264;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/KnV4oVfH16sVxdEzAUkTHJmU2+lcl4+7S0fmyw+FdU=;
        b=JoKbxfWb/17SDSMJgaL7N5OoiFekApLxYDrJfTp0D9aTXdscWRYJBglzLr1uTOZo8A
         vkGpP558iv1ztWGyuGzIn4+BgwCMECtlV6HK2B55Zs1aKEd/kvZ8psAy4TK5Z/Te9HJe
         QbomToICiNg662h3y4/Y/4ApMSqCKYe8L1HSlXmOnzNZVmMc5FgCnZFqNYNYaCseoYud
         chM8CszmcbHizsw16gp/9/xnKz9Wdrw/hpBhcNNqdT+s67x0OEfdFAVz3DDqhm9Qi84r
         CJODwXFyyrgGqHNVrF4SOWSUytB78NwB1f3xDGYk/Bdw4ASuUAJvWpZRpxLMbUIsfoPJ
         E3pw==
X-Forwarded-Encrypted: i=1; AJvYcCVCOQfp8Zbv/N/5+85MkQlrMMUc0URCEcnrICG8GTVIfoJ+7Mf1vord+z2h+i/YkU8Y2oY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw71Fu2CEFL+ZXV9/GOpNFvq2mZU661q7GMI/r4mrOYKreVbjyA
	HmdTZbDjxO1DiMVYRS4F4SsGC5/UqzHzLVS4Jz0P7/gX6SXiRUIsyGw1U3m3T8URQ5Ndv4Fh0ha
	JipLPIg==
X-Received: from pjbbj20.prod.google.com ([2002:a17:90b:894:b0:34c:f8b8:349b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388c:b0:356:7b41:d355
 with SMTP id 98e67ed59e1d1-3593dab83f5mr593484a91.1.1772070463862; Wed, 25
 Feb 2026 17:47:43 -0800 (PST)
Date: Wed, 25 Feb 2026 17:47:41 -0800
In-Reply-To: <CAG_fn=VDPHArKRYDfpzipbWMQ9Zu1S8GCpAXmmOw=hGEyWnqeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <6877331d.a00a0220.3af5df.000c.GAE@google.com> <aHfD3MczrDpzDX9O@google.com>
 <CAG_fn=VDPHArKRYDfpzipbWMQ9Zu1S8GCpAXmmOw=hGEyWnqeg@mail.gmail.com>
Message-ID: <aZ-mPQ92D_hzpB8z@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_read_guest_offset_cached
From: Sean Christopherson <seanjc@google.com>
To: Alexander Potapenko <glider@google.com>
Cc: syzbot <syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=8d5ef2da1e1c848];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71914-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,appspotmail.com:email,googlegroups.com:email];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm,bc0e18379a290e5edfe4];
	NEURAL_HAM(-0.00)[-0.996];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: 8A99E19FEDE
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Alexander Potapenko wrote:
> On Wed, Jul 16, 2025 at 5:23=E2=80=AFPM 'Sean Christopherson' via
> syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Tue, Jul 15, 2025, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    155a3c003e55 Merge tag 'for-6.16/dm-fixes-2' of git:/=
/git...
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D103e858c5=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8d5ef2da1=
e1c848
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbc0e18379a2=
90e5edfe4
> > > compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils f=
or Debian) 2.40
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D153188f=
0580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16f6198c5=
80000
> > >
> > > Downloadable assets:
> > > disk image (non-bootable): https://storage.googleapis.com/syzbot-asse=
ts/d900f083ada3/non_bootable_disk-155a3c00.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/725a320dfe66/vm=
linux-155a3c00.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/9f06899bb6=
f3/bzImage-155a3c00.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+bc0e18379a290e5edfe4@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 6107 at arch/x86/kvm/../../../virt/kvm/kvm_main.=
c:3459 kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.c:3459
> > > Modules linked in:
> > > CPU: 0 UID: 0 PID: 6107 Comm: syz.0.16 Not tainted 6.16.0-rc6-syzkall=
er-00002-g155a3c003e55 #0 PREEMPT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debia=
n-1.16.3-2~bpo12+1 04/01/2014
> > > RIP: 0010:kvm_read_guest_offset_cached+0x3f5/0x4b0 virt/kvm/kvm_main.=
c:3459
> > > Code: 0f 01 e8 3e 6c 61 00 e9 9b fc ff ff e8 14 25 85 00 48 8b 3c 24 =
31 d2 48 89 ee e8 16 bf fa 00 e9 2e fe ff ff e8 fc 24 85 00 90 <0f> 0b 90 b=
b ea ff ff ff e9 4d fe ff ff e8 e9 24 85 00 48 8b 74 24
> > > RSP: 0018:ffffc9000349f960 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: ffff888050329898 RCX: ffffffff8136ca66
> > > RDX: ffff88803cfa8000 RSI: ffffffff8136cd84 RDI: 0000000000000006
> > > RBP: 0000000000000004 R08: 0000000000000006 R09: 0000000000000008
> > > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000004
> > > R13: ffffc90003921000 R14: 0000000000000000 R15: ffffc900039215a0
> > > FS:  000055558378f500(0000) GS:ffff8880d6713000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000000000000 CR3: 0000000025de6000 CR4: 0000000000352ef0
> > > Call Trace:
> > >  <TASK>
> > >  apf_pageready_slot_free arch/x86/kvm/x86.c:13452 [inline]
> >
> > kvm_pv_enable_async_pf() sets vcpu->arch.apf.msr_en_val even if the gpa=
 is bad,
> > which leaves the cache in an empty state.  Something like so over a few=
 patches
> > fixes the problem:
>=20
> This bug is still occasionally reproducible on an Intel host running 6.19=
.

Gah, I never actually posted a series to fix this.  I'll try to get that do=
ne
this week.

