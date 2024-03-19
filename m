Return-Path: <kvm+bounces-12141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5524C87FEFA
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C06CCB2374F
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11C08062C;
	Tue, 19 Mar 2024 13:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hL+LykcB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DCB2B9A3;
	Tue, 19 Mar 2024 13:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710855664; cv=none; b=erXJiyxoKKVfb7XRCVeRqkfbxoKuEWM/A7kWIGNznQei2+ZDZV60E+wk/MxVFSphDNLmD8x0dj5tUC3+/FNF1fdIMaT/0/bTgTRGskpGQUryraML+WIHYSbta3O6vZb/Vz2Eam4WsHKcxVmXUvqwcB48NARb6Jk6X51aLOh6NBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710855664; c=relaxed/simple;
	bh=Q1XpBD3D1Jad9jOW0GmlYCOj7oP3jP/DT7Prrxxmgx4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=BnWnsmY/zDVybk/+z4YPWb+VQCpgSK0aihGIkEN+qhRT4324SqWpcf08HtJEPZUHH0e7d/UAl+07UMaCo9+VUEM2wBs5KqgTRHJFgiSbL0bLGnqPHMMNlWhCY/Qka5yp7uAn1vwmZo9HYTVnjIObhlx3oHNwWcALbGyzzjcpNOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hL+LykcB; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-430c4d0408eso15533641cf.3;
        Tue, 19 Mar 2024 06:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710855661; x=1711460461; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbcBnDm8ZRm6YnoxkvmlEycMh7Xj3p+WQ/ZP4BNyxIg=;
        b=hL+LykcB//JmdDnoZIlsy/laZJ97SVmOb1Eb6169gbb9B0P4BRoa44i803nuPWIcUo
         BUtbsMuwhGc5F+tU0PAsrykK7kGkjDJvlulR6+qHomq/nBBxtWfpniShkZaVosTHmsLK
         QPjwoJ2f4Ta3URVoSHFWBh4CJAApXvFSDJQ31gf0Ib6gsXI91ecKgWZEppNvKD3HdUg9
         l3yREzWI1sGmEtRQoYMCaLncT4AcvxCFL2xhEQXXJK43dz+pGoDBylOFXSG9rLcySUuG
         ZydG0osvVSrArnodM1KMuOeShPWqi26pv5cqAfT+M0oYlKQWvZWaZULtRMuAsn5jneAH
         jaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710855661; x=1711460461;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QbcBnDm8ZRm6YnoxkvmlEycMh7Xj3p+WQ/ZP4BNyxIg=;
        b=pdPSVzbqjnCmb5ZZauv4R/VzwTVuq0mJiwWiqfoZ2blYlWAaqZlQk72BrchAIWCl+8
         AwLE3b/a3jOPxpvcqr7U+SLjXYwJAY/4IO7aAJM7Klvb0grC4IhFsE2BrMYc0va/eHyH
         Ki6kwSc+H4Tj85Pu0+qH0uWjtLfYMAnk/5t9RnPTUi7dFfM+JBvCQcanZEdvgGRPn20b
         PdFS37vBwLPqObkZsbcAbBWy/UhbD5rud1Hn8t8cofwuqph/aP9i2ku9454cDEU1w7sT
         Au4BryjAU+PMh3uHNNzqB4qHQPU0xVswY8llvpidGr3sZ+mIJUY23bHzpRghQs4zwSoq
         HgBw==
X-Forwarded-Encrypted: i=1; AJvYcCWiouJ9fSInvWDkKc/sb8pqaEtiZKw1OQktmnmA5Qf3uxRiQT55F8XNR0cuIonVpcgVxEkgMv4f8JSg42udmozx2pNnPqfT
X-Gm-Message-State: AOJu0YxQLHf6MeeYFZTvwLG92M5hJ40msJJVbRDds4mLPaxCcJ3MKc3g
	LT4Ks8zmod4Bdosxqv3wHmdwGhXiX6sRAwjB8NQkIT8oSPPLRc/v
X-Google-Smtp-Source: AGHT+IGi3U6WNo1j5ecpIsH904oBsScvxORHbm3VLJVUIZP3ULrWkZeT4ZMr/qlGUPjIiWw7NSAtbQ==
X-Received: by 2002:a0c:8ecc:0:b0:690:6ce7:42b2 with SMTP id y12-20020a0c8ecc000000b006906ce742b2mr2405139qvb.42.1710855660818;
        Tue, 19 Mar 2024 06:41:00 -0700 (PDT)
Received: from localhost (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id jp9-20020ad45f89000000b0069124fff14esm6431990qvb.138.2024.03.19.06.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 06:41:00 -0700 (PDT)
Date: Tue, 19 Mar 2024 09:41:00 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Igor Raits <igor@gooddata.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Message-ID: <65f995ec3cd43_118bb1294f3@willemb.c.googlers.com.notmuch>
In-Reply-To: <CA+9S74gRyDn3_=aAm7XkGKEzTg7KF=pPEHFsvENYpv80kczqZg@mail.gmail.com>
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <65f98e5b99604_11543d29415@willemb.c.googlers.com.notmuch>
 <CA+9S74gRyDn3_=aAm7XkGKEzTg7KF=pPEHFsvENYpv80kczqZg@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Igor Raits wrote:
> Hello Willem,
> =

> On Tue, Mar 19, 2024 at 2:08=E2=80=AFPM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > Igor Raits wrote:
> > > Hello,
> > >
> > > We have started to observe kernel crashes on 6.7.y kernels (atm we
> > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> > > have nodes of cluster it looks stable. Please see stacktrace below.=
 If
> > > you need more information please let me know.
> > >
> > > We do not have a consistent reproducer but when we put some bigger
> > > network load on a VM, the hypervisor's kernel crashes.
> > >
> > > Help is much appreciated! We are happy to test any patches.
> > >
> > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> >
> > Did you miss the first part of the Oops?
> =

> Actually I copied it as-is from our log system. As it is a physical
> server, such logs are sent via netconsole to another server. This is
> the first line I see in the log in the time segment.
> =

> >
> > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > [62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIO=
S
> > > 2.14.1 12/17/2023
> > > [62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
> > > [62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 4=
1
> > > 80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 8=
4
> > > c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f=
 44
> > > 00 00
> > > [62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
> > > [62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000785
> > > [62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: fff=
f989862b32b00
> > > [62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 000=
000000000003a
> > > [62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: fff=
f9880b819aec0
> > > [62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 000=
0000000000002
> > > [62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000=
)
> > > knlGS:0000000000000000
> > > [62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 000=
0000000770ef0
> > > [62254.282733] PKRU: 55555554
> > > [62254.285911] Call Trace:
> > > [62254.288884]  <TASK>
> > > [62254.291549]  ? die+0x33/0x90
> > > [62254.294769]  ? do_trap+0xe0/0x110
> > > [62254.298405]  ? do_error_trap+0x65/0x80
> > > [62254.302471]  ? exc_stack_segment+0x35/0x50
> > > [62254.306884]  ? asm_exc_stack_segment+0x22/0x30
> > > [62254.311637]  ? skb_release_data+0xb8/0x1e0
> > > [62254.316047]  kfree_skb_list_reason+0x6d/0x210
> > > [62254.320697]  ? free_unref_page_commit+0x80/0x2f0
> > > [62254.325700]  ? free_unref_page+0xe9/0x130
> > > [62254.330013]  skb_release_data+0xfc/0x1e0
> > > [62254.334261]  consume_skb+0x45/0xd0
> > > [62254.338077]  tun_do_read+0x68/0x1f0 [tun]
> > > [62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
> > > [62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
> > > [62254.351488]  vhost_worker+0x42/0x70 [vhost]
> > > [62254.355934]  vhost_task_fn+0x4b/0xb0
> >
> > Neither tun nor vhost_net saw significant changes between the two
> > reported kernels.
> >
> >     $ git log --oneline v6.6..v6.7 -- drivers/net/tun.c drivers/vhost=
/net.c | wc -l
> >     0
> >
> >     $ git log --oneline linux/v6.6.9..linux/v6.7.5 -- drivers/net/tun=
.c drivers/vhost/net.c
> >     6438382dd9f8 tun: add missing rx stats accounting in tun_xdp_act
> >     4efd09da0d49 tun: fix missing dropped counter in tun_xdp_act
> >
> > So the cause is likely in the code that generated the skb or somethin=
g
> > that modified it along the way.
> >
> > It could be helpful if it is possible to bisect further. Though odds
> > are that the issue is between v6.6 and v6.7, not introduced in the
> > stable backports after that. So it is a large target.
> =

> Yeah, as I replied later to my original message - we actually also see
> the issue on 6.6.9 as well but it looks slightly different.
> =

> Actually while writing reply got 6.6.9 crashed too:
> =

> [13330.391004] tun: unexpected GSO type: 0x4ec1c942, gso_size 20948,
> hdr_len 3072

This looks like memory corruption

> > Getting the exact line in skb_release_data that causes the Oops
> > would be helpful too, e.g.,
> >
> > gdb vmlinux
> > list *(skb_release_data+0xb8)
> =

> Unfortunately we do not collect kdumps so this is not going to be easy
> :( We will investigate the possibility of getting the dump though.

No need for a kdump. As long as you have the vmlinux of the kernel.

