Return-Path: <kvm+bounces-53606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE55B14955
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C61F18A0200
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 07:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C69221554;
	Tue, 29 Jul 2025 07:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QE/edrQb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75022265284
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 07:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775108; cv=none; b=ttNH4los7jcNB/TSFiy0sC/lLrWNM0bP2EexO/z5C66Bytl8SQvxkd37lTqEen+EMD+blF8MIOmTgQYO6msfToeLe+0YNNv/uVqjc0e310C7p5lzwNwJqdOwJTIzaBhi8ifCLPVUVxs1UcoDkOXo+wmdglFAGg5tzRfHxh/ofCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775108; c=relaxed/simple;
	bh=MMi5FiGdzDvVkxMbm2UbMQGRSTDM28atu70FgTFpdjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QYvSQgWM5BOgqSPQy9G8EF8MO3ceE6cbrceoZEoomiF8CPhiZq5Pc/o06LuW00aqE11F1tM8pwrd8NWTZFqGT/JViV6i3PckpvYnkQl9xeoZ91qmjsehDimJ8z+9IKVOpyYRtBbipxBIZGaXexWkwuZ7Ec0cLNTSdfKB6acDm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QE/edrQb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753775105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ob3idF9XXWHk4RqOxwwtYc9gevjLswJQaGVAnhZiFrA=;
	b=QE/edrQbeE/eTQDhuKP3BWs4enGvOflmC6vuChfkp+XuRIMg6PB8/sog0nlU2mwOCjzCBs
	39Au458rjvci+S/gCkXJTnAzGKhhq057RlPLNegOWzxe1iDPFcyPw7r2J2AS4aPw3NX4a5
	Q7GHXRHXe/9E2qDFBGqoulizAScuo4U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-stkxG34JMPi-N2MWDH470A-1; Tue, 29 Jul 2025 03:45:03 -0400
X-MC-Unique: stkxG34JMPi-N2MWDH470A-1
X-Mimecast-MFC-AGG-ID: stkxG34JMPi-N2MWDH470A_1753775102
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3139c0001b5so4965606a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 00:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753775102; x=1754379902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ob3idF9XXWHk4RqOxwwtYc9gevjLswJQaGVAnhZiFrA=;
        b=mu7KNk3zn6mkqPxid5FAiRNJnJc7yO5WA8Fi4dlw+Y8/7ta9SBJ03ErGdxKSWbji5o
         at3OGqCym3HxOTz7plkZow/nHqIuELe+jxSHxRIA8bzRWkeZIqB4KobjdfUDNSdqy4TP
         +P1UXCfcUgYWlqHwI9rW6SmsBZnoP0TnhXBk9HuCAGnnJU25XgCKK1APAFYY6CGHdt99
         EwTdzXAaJw/Z1vDmAwhff4ckMWsSBTVHoi37vRGfMLUIYZzDqj3sDdSIrib7RWbyXbIJ
         8tsXG2QSq7u3bQTL1FSBDbaskhMT47w9xtlGCr2aTXHUByj4D75L8Ve7zKu0Q03NGrwi
         LZ9A==
X-Forwarded-Encrypted: i=1; AJvYcCWlormFiE7ZZLz7EHLmpQzhmE5bzeNTm8KmN92ahxDNT4U68dMMAsDvG8J2T9nMDQgyqzs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz85i/G2T6LojsNJZXYmhMUQ44FEgilhatOMhiUFAF9hFMtsFSd
	UNJgpmxSpB8HIMKOwnz3n/cA3NFMm4sDd4JV6oXwbAKkBtIaT0+qYVQPMFMOe3qXJLIDZV1lyhm
	tqilFqXEOqBbbJ0z8g38p7HlTkg756CPqrFC6mksQdoBeExHxMwcSYeZXt6EBMsoL+I8e1l9EKe
	1OA9ZXhGm93T8IodcgkoiYs8kJ3XQ5
X-Gm-Gg: ASbGnctfDIRyUFaAw/nePmtbnypXdfw3lkSorn70rMNpX7BZDelizTSlrOzcRZniVev
	bbVtdlbC42bTjoiV93NJcyGAp94zAp8d8+bG3ssG+mFlCR0l82C7xhHEtYWYk8WA7/YN0G+r843
	0fjcBiN5xVlbCJn8nNuQpwAQ==
X-Received: by 2002:a17:90b:1c07:b0:313:15fe:4c13 with SMTP id 98e67ed59e1d1-31e779fcf83mr20671448a91.27.1753775101866;
        Tue, 29 Jul 2025 00:45:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGc0H8yIs+OFrF04eJQmZ357iPQi6PoOh4VywSUV7VBBrzQ9k5oFdZEBMd1ZkclzA66YT8nwWTYVBp6Ky1rnWw=
X-Received: by 2002:a17:90b:1c07:b0:313:15fe:4c13 with SMTP id
 98e67ed59e1d1-31e779fcf83mr20671423a91.27.1753775101413; Tue, 29 Jul 2025
 00:45:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c>
 <20250724034659-mutt-send-email-mst@kernel.org> <CAGxU2F76ueKm3H30vXL+jxMVsiQBuRkDN9NRfVU8VeTXzTVAWg@mail.gmail.com>
 <20250724042100-mutt-send-email-mst@kernel.org> <aIHydjBEnmkTt-P-@willie-the-truck>
 <fv6uhq6lcgjwrdp7fcxmokczjmavbc37ikrqz7zpd7puvrbsml@zkt2lidjrqm6>
 <CAGxU2F5Qy=vMD0z9_HTN2K9wyt+6EH-Yr0N9VqR4OT4O1asqZg@mail.gmail.com> <bvjomrplpsjklglped5pmwttzmljigasdafjiizt2sfmytc5rr@ljpu455kx52j>
In-Reply-To: <bvjomrplpsjklglped5pmwttzmljigasdafjiizt2sfmytc5rr@ljpu455kx52j>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 29 Jul 2025 15:44:49 +0800
X-Gm-Features: Ac12FXxdPFfyNXZ2ozgXF3pRalQ2Njghxuxni5Ee1R5WFJM0fsuLnvYb-CxqMuk
Message-ID: <CACGkMEt0ZBtcAUgc1RBU7Gd3JGvC-eszEOexee-kx7TgoiMGtA@mail.gmail.com>
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
To: Breno Leitao <leitao@debian.org>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Will Deacon <will@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 9:50=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> On Thu, Jul 24, 2025 at 02:52:08PM +0200, Stefano Garzarella wrote:
> > On Thu, 24 Jul 2025 at 14:48, Breno Leitao <leitao@debian.org> wrote:
> > >
> > > On Thu, Jul 24, 2025 at 09:44:38AM +0100, Will Deacon wrote:
> > > > > > On Thu, 24 Jul 2025 at 09:48, Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> > > > > > >
> > > > > > > On Wed, Jul 23, 2025 at 08:04:42AM -0700, Breno Leitao wrote:
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > I've seen a crash in linux-next for a while on my arm64 ser=
ver, and
> > > > > > > > I decided to report.
> > > > > > > >
> > > > > > > > While running stress-ng on linux-next, I see the crash belo=
w.
> > > > > > > >
> > > > > > > > This is happening in a kernel configure with some debug opt=
ions (KASAN,
> > > > > > > > LOCKDEP and KMEMLEAK).
> > > > > > > >
> > > > > > > > Basically running stress-ng in a loop would crash the host =
in 15-20
> > > > > > > > minutes:
> > > > > > > >       # while (true); do stress-ng -r 10 -t 10; done
> > > > > > > >
> > > > > > > > >From the early warning "virt_to_phys used for non-linear a=
ddress",
> > > > > >
> > > > > > mmm, we recently added nonlinear SKBs support in vhost-vsock [1=
],
> > > > > > @Will can this issue be related?
> > > > >
> > > > > Good point.
> > > > >
> > > > > Breno, if bisecting is too much trouble, would you mind testing t=
he commits
> > > > > c76f3c4364fe523cd2782269eab92529c86217aa
> > > > > and
> > > > > c7991b44d7b44f9270dec63acd0b2965d29aab43
> > > > > and telling us if this reproduces?
> > > >
> > > > That's definitely worth doing, but we should be careful not to conf=
use
> > > > the "non-linear address" from the warning (which refers to virtual
> > > > addresses that lie outside of the linear mapping of memory, e.g. in=
 the
> > > > vmalloc space) and "non-linear SKBs" which refer to SKBs with fragm=
ent
> > > > pages.
> > >
> > > I've tested both commits above, and I see the crash on both commits
> > > above, thus, the problem reproduces in both cases. The only differenc=
e
> > > I noted is the fact that I haven't seen the warning before the crash.
> > >
> > >
> > > Log against c76f3c4364fe ("vhost/vsock: Avoid allocating
> > > arbitrarily-sized SKBs")
> > >
> > >          Unable to handle kernel paging request at virtual address 00=
00001fc0000048
> > >          Mem abort info:
> > >            ESR =3D 0x0000000096000005
> > >            EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> > >            SET =3D 0, FnV =3D 0
> > >            EA =3D 0, S1PTW =3D 0
> > >            FSC =3D 0x05: level 1 translation fault
> > >          Data abort info:
> > >            ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
> > >            CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> > >            GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
> > >          user pgtable: 64k pages, 48-bit VAs, pgdp=3D0000000cdcf2da00
> > >          [0000001fc0000048] pgd=3D0000000000000000, p4d=3D00000000000=
00000, pud=3D0000000000000000
> > >          Internal error: Oops: 0000000096000005 [#1]  SMP
> > >          Modules linked in: vfio_iommu_type1 vfio md4 crc32_cryptoapi=
 ghash_generic unix_diag vhost_net tun vhost vhost_iotlb tap mpls_gso mpls_=
iptunnel mpls_router fou sch_fq ghes_edac tls tcp_diag inet_diag act_gact c=
ls_bpf nvidia_c
> > >          CPU: 34 UID: 0 PID: 1727297 Comm: stress-ng-dev Kdump: loade=
d Not tainted 6.16.0-rc6-upstream-00027-gc76f3c4364fe #19 NONE
> > >          pstate: 23401009 (nzCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=
=3D--)
> > >          pc : kfree+0x48/0x2a8
> > >          lr : vhost_dev_cleanup+0x138/0x2b8 [vhost]
> > >          sp : ffff80013a0cfcd0
> > >          x29: ffff80013a0cfcd0 x28: ffff0008fd0b6240 x27: 00000000000=
00000
> > >          x26: 0000000000000000 x25: 0000000000000000 x24: 00000000000=
00000
> > >          x23: 00000000040e001f x22: ffffffffffffffff x21: ffff00014f1=
d4ac0
> > >          x20: 0000000000000001 x19: ffff00014f1d0000 x18: 00000000000=
00000
> > >          x17: 0000000000000000 x16: 0000000000000000 x15: 00000000000=
00000
> > >          x14: 000000000000001f x13: 000000000000000f x12: 00000000000=
00001
> > >          x11: 0000000000000000 x10: 0000000000000402 x9 : ffffffdfc00=
00000
> > >          x8 : 0000001fc0000040 x7 : 0000000000000000 x6 : 00000000000=
00000
> > >          x5 : ffff000141931840 x4 : 0000000000000000 x3 : 00000000000=
00008
> > >          x2 : ffffffffffffffff x1 : ffffffffffffffff x0 : 00000000000=
10000
> > >          Call trace:
> > >           kfree+0x48/0x2a8 (P)
> > >           vhost_dev_cleanup+0x138/0x2b8 [vhost]
> > >           vhost_net_release+0xa0/0x1a8 [vhost_net]
> >
> > But here is the vhost_net, so I'm confused now.
> > Do you see the same (vhost_net) also on 9798752 ("Add linux-next
> > specific files for 20250721") ?
>
> I will need to reproduce, but, looking at my logs, I see the following
> against: c76f3c4364fe ("vhost/vsock: Avoid allocating arbitrarily-sized S=
KBs").
> The logs are a bit intermixed, probably there were multiple CPUs hitting
> the same code path.
>
>            virt_to_phys used for non-linear address: 000000001b662678 (0x=
ffe61984a460)
>            WARNING: CPU: 15 PID: 112846 at arch/arm64/mm/physaddr.c:15 __=
virt_to_phys+0x80/0xa8
>            Modules linked in: vhost_vsock(E) vhost(E) vhost_iotlb(E) ghes=
_edac(E) tls(E) act_gact(E) cls_bpf(E) tcp_diag(E) inet_diag(E) ipmi_ssif(E=
) ipmi_devintf(E) ipmi_msghandler(E) sch_fq_codel(E) drm(E) backlight(E) dr=
m_panel_orientation_quirks(E) acpi_power_meter(E) loop(E) efivarfs(E) autof=
s4(E)
>            CPU: 15 UID: 0 PID: 112846 Comm: stress-ng-dev Kdump: loaded T=
ainted: G        W   E    N  6.16.0-rc6-upstream-00027-gc76f3c4364fe #16 PR=
EEMPT(none)
>            Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MODULE, [N]=3DTEST
>            pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D=
--)
>            pc : __virt_to_phys+0x80/0xa8
>            lr : __virt_to_phys+0x7c/0xa8
>            sp : ffff8001184d7a30
>            x29: ffff8001184d7a30 x28: 00000000000045d8 x27: 1fffe000e7e88=
014
>            x26: 1fffe000e7e888f7 x25: ffff0007e578bf00 x24: 1fffe000e7e88=
013
>            x23: 0000000000000000 x22: 0000ffe61984a460 x21: ffff00073f440=
098
>            x20: ffffff1000080000 x19: 0000ffe61984a460 x18: 0000000000000=
002
>            x17: 6666783028203837 x16: 3632363662313030 x15: 0000000000000=
001
>            x14: 1fffe006d52e90f2 x13: 0000000000000000 x12: 0000000000000=
000
>            x11: ffff6006d52e90f3 x10: 0000000000000002 x9 : cfc659a21c727=
d00
>            x8 : ffff800083c19000 x7 : 0000000000000001 x6 : 0000000000000=
001
>            x5 : ffff8001184d7398 x4 : ffff800084866d60 x3 : ffff8000805fd=
d94
>            x2 : 0000000000000001 x1 : 0000000000000004 x0 : 0000000000000=
04b
>            Call trace:
>             __virt_to_phys+0x80/0xa8 (P)
>             kfree+0xac/0x4b0
>             vhost_dev_cleanup+0x484/0x8b0 [vhost]
>             vhost_vsock_dev_release+0x2f4/0x358 [vhost_vsock]
>             __fput+0x2b4/0x608
>             fput_close_sync+0xe8/0x1e0
>             __arm64_sys_close+0x84/0xd0
>             invoke_syscall+0x8c/0x208
>             do_el0_svc+0x128/0x1a0
>             el0_svc+0x58/0x160
>             el0t_64_sync_handler+0x78/0x108
>             el0t_64_sync+0x198/0x1a0
>            irq event stamp: 0
>            hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>            hardirqs last disabled at (0): [<ffff8000801d876c>] copy_proce=
ss+0xd5c/0x29f8
>            softirqs last  enabled at (0): [<ffff8000801d879c>] copy_proce=
ss+0xd8c/0x29f8
>            softirqs last disabled at (0): [<0000000000000000>] 0x0
>            ---[ end trace 0000000000000000 ]---
>            Unable to handle kernel paging request at virtual address 0000=
040053791288
>            ------------[ cut here ]------------
>            lr : kfree+0xac/0x4b0
>            virt_to_phys used for non-linear address: 00000000290839fd (0x=
2500000000)
>            WARNING: CPU: 41 PID: 112845 at arch/arm64/mm/physaddr.c:15 __=
virt_to_phys+0x80/0xa8
>            Modules linked in: vhost_vsock(E) vhost(E) vhost_iotlb(E) ghes=
_edac(E) tls(E) act_gact(E) cls_bpf(E) tcp_diag(E) inet_diag(E) ipmi_ssif(E=
) ipmi_devintf(E) ipmi_msghandler(E) sch_fq_codel(E) drm(E) backlight(E) dr=
m_panel_orientation_quirks(E) acpi_power_meter(E) loop(E) efivarfs(E) autof=
s4(E)
>            CPU: 41 UID: 0 PID: 112845 Comm: stress-ng-dev Kdump: loaded T=
ainted: G        W   E    N  6.16.0-rc6-upstream-00027-gc76f3c4364fe #16 PR=
EEMPT(none)
>            x23: 0000000000000001
>            Tainted: [W]=3DWARN, [E]=3DUNSIGNED_MODULE, [N]=3DTEST
>            pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=3D=
--)
>            pc : __virt_to_phys+0x80/0xa8
>            lr : __virt_to_phys+0x7c/0xa8
>            sp : ffff8001a8277a30
>            x29: ffff8001a8277a30 x28: 00000000000045d8 x27: 1fffe000e7e3c=
014
>            x26: 1fffe000e7e3c8f7 x25: ffff0007bcff0000 x24: 1fffe000e7e3c=
013
>            x23: 0000000000000000 x22: 0000002500000000 x21: ffff00073f1e0=
098
>            x20: ffffff1000080000 x19: 0000002500000000 x18: 0000000000000=
004
>            x17: 00000000ffffffff x16: 0000000000000001 x15: 0000000000000=
001
>            x14: 1fffe006d53920f2 x13: 0000000000000000 x12: 0000000000000=
000
>            sp : ffff8001184d7a50
>            x29: ffff8001184d7a60 x28: 00000000000045d8 x27: 1fffe000e7e88=
014
>            x26: 1fffe000e7e888f7 x25: ffff0007e578bf00 x24: 1fffe000e7e88=
013
>            x23: 0000000000000000 x22: 0000ffe61984a460 x21: ffff00073f440=
098
>            x20: 0000040053791280 x19: ffff80000d0b8bbc x18: 0000000000000=
002
>            x17: 6666783028203837 x16: 3632363662313030 x15: 0000000000000=
001
>             x22: 0000ffe6199a459d
>            x14: 1fffe006d52e90f2
>             x21: ffff00073f7f0098
>            x20: ffffff1000080000 x19: 0000ffe6199a459d x18: 0000000000000=
004
>            x17: 54455320203b2d2c x16: 0000000000000011 x15: 0000000000000=
001
>            x14: 1fffe006d52bb8f2 x13: 0000000000000000 x12: 0000000000000=
000
>            x11: ffff6006d52bb8f3 x10: dfff800000000000 x9 : 77521a2bd3e0b=
e00
>            x8 : ffff800083c19000 x7 : 0000000000000000 x6 : ffff80008036b=
c2c
>            x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff8000805fd=
d94
>            x2 : 0000000000000001 x1 : 0000000000000004 x0 : 0000000000000=
04b
>            Call trace:
>             __virt_to_phys+0x80/0xa8 (P)
>             kfree+0xac/0x4b0
>             vhost_dev_cleanup+0x484/0x8b0 [vhost]
>             vhost_vsock_dev_release+0x2f4/0x358 [vhost_vsock]
>             __fput+0x2b4/0x608
>            x11: ffff6006d53920f3
>             fput_close_sync+0xe8/0x1e0
>             __arm64_sys_close+0x84/0xd0
>             invoke_syscall+0x8c/0x208
>             do_el0_svc+0x128/0x1a0
>             el0_svc+0x58/0x160
>             el0t_64_sync_handler+0x78/0x108
>             el0t_64_sync+0x198/0x1a0
>            irq event stamp: 0
>             x13: 0000000000000000
>            hardirqs last  enabled at (0): [<0000000000000000>] 0x0
>            hardirqs last disabled at (0): [<ffff8000801d876c>] copy_proce=
ss+0xd5c/0x29f8
>
>
> > The initial report contained only vhost_vsock traces IIUC, so I'm
> > suspecting something in the vhost core.
>
> Right, it seems we are hitting the same code path, on on both
> vhost_vsock and vhost_net.
>

I've posted a fix here:

https://lore.kernel.org/virtualization/20250729073916.80647-1-jasowang@redh=
at.com/T/#u

I think it should address this issue.

Thanks


