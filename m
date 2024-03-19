Return-Path: <kvm+bounces-12143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B6487FF19
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:53:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E44F1F2354D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9459681731;
	Tue, 19 Mar 2024 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="CgQCONdW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCED180BFD
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 13:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710856370; cv=none; b=u3HPUSSBikm+2y2NLN/pA0A/nE5Iu5ITvbi17hFhy4Na7ds2E7XHTAfqeVDMjEognw98xF7qpbPZuDw2A9zsgTgYM4sKBGK8SdN3Y+xHE0FvqhemKa7gESosBSSjJmGQOeH3NK49V7Pzu6k30WTfdGxM8HI3G4CRGssJX5JRppY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710856370; c=relaxed/simple;
	bh=PcG3jFbqv0ADhPWyUGZnOImkMAkNB3NPh4hM6Mbrikg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFyZXizHwLa+/e59yXwl8W7Msp0Bg6WoIbAxIMx8Xfjs/S5SlgiAQLylePmN8f3B/9fQ/CHqTZiqvTu15903GxX5AZlqwp+LdGPRB9SHzVH7AOACpHiibDuRoPmFk9A9oV+KBovCzB6XHYndL07BRhGy5DSSnRmwZq/0gNkoQUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=CgQCONdW; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2d23114b19dso68205881fa.3
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 06:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1710856367; x=1711461167; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ut2L92w+ObuYD4zPtPTxf87RPDeymugk8HmMDNtUuFg=;
        b=CgQCONdWAchmHt8jPmBMcNksquEauyQbI16PwNwXTIPufqI6paZRHtkZr1BhxNkVcf
         kIXUpjaQzHsWlp+/xxERS3UkP3Idb0F6cRIcx9kM+pmvL6Hpk4cQZCkm0vK/OpjNSr/8
         u3ZtrucKaCPDbGdNjEAGa/etP5exyk8+NKuCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710856367; x=1711461167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ut2L92w+ObuYD4zPtPTxf87RPDeymugk8HmMDNtUuFg=;
        b=D5xCFF0Sv/vkPcUw52QfVJDrniN+jbp7BNxJL0E0l54qGIgEn/C0Q3TW2i7yjx81/t
         Qf9rUkgrnnmUiwCvOgSTKfQXuFj3/AsdGUYzBK0PgaQ/1+79oCkF10PLbeyrj0+fZ8SP
         cNMjU0HqKS+Kn2BOF0OYEkQT6dzk5aijPuVEkYoXOIi8z9tGL06KokT3p6SgzVzfaJoC
         M8PJZvvDKEychFjsI7pqJfECqw9qXuqfI9re4GITFSxhgMxolZeekAbLenkwa4V6m/gU
         TVGNxidE4+RE1TeMV3Jon0kDm9ijrt3JRNLaXtgjY9pZ94dy5DrFkIDv3+0Lp9/Qlqr6
         mW8g==
X-Gm-Message-State: AOJu0YyC82XHKYMk1UmqVhVDqaFl4BJ5cbv4aNvZa1WvYpx/KpZQzGi/
	JxHqNX6KXdhThd0ZxUZE1BICl+T9vXTW175VKWAkd+PtXYarcgXGaXJprEHhDWhdvmwA3FkN5m6
	hOqcfcqW7yyF9arPHhagcdp1ZMtnxNEvqMcDt
X-Google-Smtp-Source: AGHT+IFXHxgD3fXqutUxcbGPNF7lCHHbHvdpYnRAQbeX/Dh/4OYt1xBfYn2yNdQj0qSxPddGgEipTsmHaV3Vw2ydS2Q=
X-Received: by 2002:a2e:9396:0:b0:2d4:6c1a:ee6f with SMTP id
 g22-20020a2e9396000000b002d46c1aee6fmr11047346ljh.35.1710856366998; Tue, 19
 Mar 2024 06:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <65f98e5b99604_11543d29415@willemb.c.googlers.com.notmuch>
 <CA+9S74gRyDn3_=aAm7XkGKEzTg7KF=pPEHFsvENYpv80kczqZg@mail.gmail.com> <65f995ec3cd43_118bb1294f3@willemb.c.googlers.com.notmuch>
In-Reply-To: <65f995ec3cd43_118bb1294f3@willemb.c.googlers.com.notmuch>
From: Igor Raits <igor@gooddata.com>
Date: Tue, 19 Mar 2024 14:52:35 +0100
Message-ID: <CA+9S74heujyHmUJ6-+9xWNN+nFvtTO8mX2N5pWyhO-4hu9dFQQ@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 2:41=E2=80=AFPM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Igor Raits wrote:
> > Hello Willem,
> >
> > On Tue, Mar 19, 2024 at 2:08=E2=80=AFPM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > Igor Raits wrote:
> > > > Hello,
> > > >
> > > > We have started to observe kernel crashes on 6.7.y kernels (atm we
> > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where we
> > > > have nodes of cluster it looks stable. Please see stacktrace below.=
 If
> > > > you need more information please let me know.
> > > >
> > > > We do not have a consistent reproducer but when we put some bigger
> > > > network load on a VM, the hypervisor's kernel crashes.
> > > >
> > > > Help is much appreciated! We are happy to test any patches.
> > > >
> > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > >
> > > Did you miss the first part of the Oops?
> >
> > Actually I copied it as-is from our log system. As it is a physical
> > server, such logs are sent via netconsole to another server. This is
> > the first line I see in the log in the time segment.
> >
> > >
> > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > [62254.183743] Hardware name: Dell Inc. PowerEdge R7525/0H3K7P, BIO=
S
> > > > 2.14.1 12/17/2023
> > > > [62254.192083] RIP: 0010:skb_release_data+0xb8/0x1e0
> > > > [62254.197357] Code: 48 83 c3 01 39 d8 7e 54 48 89 d8 48 c1 e0 04 4=
1
> > > > 80 7d 7e 00 49 8b 6c 04 30 79 0f 44 89 f6 48 89 ef e8 4c e4 ff ff 8=
4
> > > > c0 75 d0 <48> 8b 45 08 a8 01 0f 85 09 01 00 00 e9 d9 00 00 00 0f 1f=
 44
> > > > 00 00
> > > > [62254.217013] RSP: 0018:ffffa975a0247ba8 EFLAGS: 00010206
> > > > [62254.222692] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000785
> > > > [62254.230263] RDX: 0000000000000016 RSI: 0000000000000002 RDI: fff=
f989862b32b00
> > > > [62254.237878] RBP: 4f2b318c69a8b0f9 R08: 000000000001fe4d R09: 000=
000000000003a
> > > > [62254.245417] R10: 0000000000000000 R11: 0000000000001736 R12: fff=
f9880b819aec0
> > > > [62254.252963] R13: ffff989862b32b00 R14: 0000000000000000 R15: 000=
0000000000002
> > > > [62254.260591] FS:  00007f6cf388bf80(0000) GS:ffff98b85fbc0000(0000=
)
> > > > knlGS:0000000000000000
> > > > [62254.269061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [62254.275170] CR2: 000000c002236020 CR3: 000000387d37a002 CR4: 000=
0000000770ef0
> > > > [62254.282733] PKRU: 55555554
> > > > [62254.285911] Call Trace:
> > > > [62254.288884]  <TASK>
> > > > [62254.291549]  ? die+0x33/0x90
> > > > [62254.294769]  ? do_trap+0xe0/0x110
> > > > [62254.298405]  ? do_error_trap+0x65/0x80
> > > > [62254.302471]  ? exc_stack_segment+0x35/0x50
> > > > [62254.306884]  ? asm_exc_stack_segment+0x22/0x30
> > > > [62254.311637]  ? skb_release_data+0xb8/0x1e0
> > > > [62254.316047]  kfree_skb_list_reason+0x6d/0x210
> > > > [62254.320697]  ? free_unref_page_commit+0x80/0x2f0
> > > > [62254.325700]  ? free_unref_page+0xe9/0x130
> > > > [62254.330013]  skb_release_data+0xfc/0x1e0
> > > > [62254.334261]  consume_skb+0x45/0xd0
> > > > [62254.338077]  tun_do_read+0x68/0x1f0 [tun]
> > > > [62254.342414]  tun_recvmsg+0x7e/0x160 [tun]
> > > > [62254.346696]  handle_rx+0x3ab/0x750 [vhost_net]
> > > > [62254.351488]  vhost_worker+0x42/0x70 [vhost]
> > > > [62254.355934]  vhost_task_fn+0x4b/0xb0
> > >
> > > Neither tun nor vhost_net saw significant changes between the two
> > > reported kernels.
> > >
> > >     $ git log --oneline v6.6..v6.7 -- drivers/net/tun.c drivers/vhost=
/net.c | wc -l
> > >     0
> > >
> > >     $ git log --oneline linux/v6.6.9..linux/v6.7.5 -- drivers/net/tun=
.c drivers/vhost/net.c
> > >     6438382dd9f8 tun: add missing rx stats accounting in tun_xdp_act
> > >     4efd09da0d49 tun: fix missing dropped counter in tun_xdp_act
> > >
> > > So the cause is likely in the code that generated the skb or somethin=
g
> > > that modified it along the way.
> > >
> > > It could be helpful if it is possible to bisect further. Though odds
> > > are that the issue is between v6.6 and v6.7, not introduced in the
> > > stable backports after that. So it is a large target.
> >
> > Yeah, as I replied later to my original message - we actually also see
> > the issue on 6.6.9 as well but it looks slightly different.
> >
> > Actually while writing reply got 6.6.9 crashed too:
> >
> > [13330.391004] tun: unexpected GSO type: 0x4ec1c942, gso_size 20948,
> > hdr_len 3072
>
> This looks like memory corruption
>
> > > Getting the exact line in skb_release_data that causes the Oops
> > > would be helpful too, e.g.,
> > >
> > > gdb vmlinux
> > > list *(skb_release_data+0xb8)
> >
> > Unfortunately we do not collect kdumps so this is not going to be easy
> > :( We will investigate the possibility of getting the dump though.
>
> No need for a kdump. As long as you have the vmlinux of the kernel.

(gdb) list *(skb_release_data+0xb8)
0xffffffff81a36088 is in skb_release_data (./include/linux/page-flags.h:247=
).
242 return page_fixed_fake_head(page) !=3D page;
243 }
244
245 static inline unsigned long _compound_head(const struct page *page)
246 {
247 unsigned long head =3D READ_ONCE(page->compound_head);
248
249 if (unlikely(head & 1))
250 return head - 1;
251 return (unsigned long)page_fixed_fake_head(page);

