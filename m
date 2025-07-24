Return-Path: <kvm+bounces-53380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43732B10BDF
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 15:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8C804E32AA
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 13:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603502DC352;
	Thu, 24 Jul 2025 13:49:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA81E2E36ED;
	Thu, 24 Jul 2025 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753364993; cv=none; b=ep810t40SbXaFvME5eXyz08/TAzQHOaNcCZQzBuyZE0aA6ds/BMy7cyKJHqmWse5CMKsMG2gVm8X8JMDa/EoWRIGhb3uxUKOfibgakRGpkRunKrLt8+wvH7Y5CjS8MiYxvbIUBBxmlflM7+Lq4NWMjHxHCyrtErapHUJgy87XuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753364993; c=relaxed/simple;
	bh=grj/YJNI+meRW4f1gRFJ7UclkMOhpB/E9nQvrHIm1Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpdINY6yefGFo12I+nBYXFGk96esv4gMqbsRG00pA5feKp93cK9UiMIg7/sj4Sx0JwmvjUcb9WWEwnX72E8cRyXfBx2h6cE/iNwAobJcHqYG4ZqOMEyVaRxrrwgw2AvWu8bpywGoE7tQsBm1nRq0JX+KjDOkwZAVoObzzUOk03I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6097d144923so2291092a12.1;
        Thu, 24 Jul 2025 06:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753364990; x=1753969790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPMAVc1TEXwwo2AqDC8mND5efIlxayspoxL+XnJ5jJc=;
        b=qK3Fw7oo4pPGkvTMPVbl3slgWPuk+kgBXZ7X9j0iMYZp0AvNzPLLHH2Ab3dafBU+3F
         GuwrQ4mY8fz0Bv6qBuvPy6M7xuSE+liuOzJsx7LJfHp9OfIqoRjKjUSjr0ZaOkVL0be2
         3Iv3G4f/NgCW2zy1fBdDciI7+eBPODfNA5plpyJ4qAL8JnzqGRTGjsdp/x1yV/eTLb9l
         FUO/cn26S0KqRUxbEW641KBZHr8CWe2gm5hInFX5ynDsD27UJEU+jCqcLjnVdCRm9v7m
         nmG8i8sxvZ2dPv1Q39w5MWYt8BTZZWLTzQDPfIojxZp/ZCQ5d2KTlZdEUlAsTs3ltPGx
         MiRw==
X-Forwarded-Encrypted: i=1; AJvYcCXFYgBvHjQYyr+J/SUnYFpQILmCZ2QcPkPWg3CN4bQv124EFPlSrl+Jpgfl0NSvsIi4sJE=@vger.kernel.org, AJvYcCXV/El8w97DFdHYJFefHFfmLmjeTdSkjinIIE4Mu16jNeDbHUTJ8mn0iuW/vWkKtYdIaO672Gyv@vger.kernel.org
X-Gm-Message-State: AOJu0YzUDSdQM1YK9R9CeA1N2lte8EaZ11Ux2xH/95D4Ghca0aAQUk+w
	vAdSYilV2A34uweYViTIgS6VMBzLU17hm+WCH0XnmI53N1dYqB4KqRV/SZPJh9Qonxw=
X-Gm-Gg: ASbGncsPk2FCnSuIOP7vpm8c5nhAnxkEw3EkpxnUycnBk+QWj3pXv802AJetNsBRWP9
	v2gn+eCnDGVNlFoTFUxN0/W3uIHwQhz2IpzjysAFVY1JfET0ztr9jcp3R4rGVtbhKzMIRLauJd4
	QBgUnU477ZCJbnfDd29tf54AYzDhaw+7BRQh2dPHKIeZHnnFZY0Y9ZylA9rjGDTzDJg95Yxg8CU
	e7TzxYNnw/ouQSav8wyVAr131yQWfEScrcxSwwJ2HsI3JiWG4mgDxSlbTUmOvnj6/6b6i3IZhzA
	PgyyiJ3OZoWy4Zk+z1Sgb+MjDxnn/tLJajchXQM62Q+iFq7m7oWvbsRSuUdU0DFp/Vw9uYPkT5P
	FqYYYBdsBtYgfvg==
X-Google-Smtp-Source: AGHT+IGM2s4sUu/jhN+IOAyKTFmbKAHCm4pptThQJKfKfwXWs66uv+mhI7ywrX5sI8KK9oEJ65TEkw==
X-Received: by 2002:a17:906:6a07:b0:ae3:6e5c:1c05 with SMTP id a640c23a62f3a-af4c490ad23mr238115666b.30.1753364989849;
        Thu, 24 Jul 2025 06:49:49 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:73::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f861477sm114887866b.99.2025.07.24.06.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:49:49 -0700 (PDT)
Date: Thu, 24 Jul 2025 06:49:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Will Deacon <will@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	jasowang@redhat.com, eperezma@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
Message-ID: <bvjomrplpsjklglped5pmwttzmljigasdafjiizt2sfmytc5rr@ljpu455kx52j>
References: <vosten2rykookljp6u6qc4hqhsqb6uhdy2iuhpl54plbq2tkr4@kphfpgst3e7c>
 <20250724034659-mutt-send-email-mst@kernel.org>
 <CAGxU2F76ueKm3H30vXL+jxMVsiQBuRkDN9NRfVU8VeTXzTVAWg@mail.gmail.com>
 <20250724042100-mutt-send-email-mst@kernel.org>
 <aIHydjBEnmkTt-P-@willie-the-truck>
 <fv6uhq6lcgjwrdp7fcxmokczjmavbc37ikrqz7zpd7puvrbsml@zkt2lidjrqm6>
 <CAGxU2F5Qy=vMD0z9_HTN2K9wyt+6EH-Yr0N9VqR4OT4O1asqZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGxU2F5Qy=vMD0z9_HTN2K9wyt+6EH-Yr0N9VqR4OT4O1asqZg@mail.gmail.com>

On Thu, Jul 24, 2025 at 02:52:08PM +0200, Stefano Garzarella wrote:
> On Thu, 24 Jul 2025 at 14:48, Breno Leitao <leitao@debian.org> wrote:
> >
> > On Thu, Jul 24, 2025 at 09:44:38AM +0100, Will Deacon wrote:
> > > > > On Thu, 24 Jul 2025 at 09:48, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Wed, Jul 23, 2025 at 08:04:42AM -0700, Breno Leitao wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > I've seen a crash in linux-next for a while on my arm64 server, and
> > > > > > > I decided to report.
> > > > > > >
> > > > > > > While running stress-ng on linux-next, I see the crash below.
> > > > > > >
> > > > > > > This is happening in a kernel configure with some debug options (KASAN,
> > > > > > > LOCKDEP and KMEMLEAK).
> > > > > > >
> > > > > > > Basically running stress-ng in a loop would crash the host in 15-20
> > > > > > > minutes:
> > > > > > >       # while (true); do stress-ng -r 10 -t 10; done
> > > > > > >
> > > > > > > >From the early warning "virt_to_phys used for non-linear address",
> > > > >
> > > > > mmm, we recently added nonlinear SKBs support in vhost-vsock [1],
> > > > > @Will can this issue be related?
> > > >
> > > > Good point.
> > > >
> > > > Breno, if bisecting is too much trouble, would you mind testing the commits
> > > > c76f3c4364fe523cd2782269eab92529c86217aa
> > > > and
> > > > c7991b44d7b44f9270dec63acd0b2965d29aab43
> > > > and telling us if this reproduces?
> > >
> > > That's definitely worth doing, but we should be careful not to confuse
> > > the "non-linear address" from the warning (which refers to virtual
> > > addresses that lie outside of the linear mapping of memory, e.g. in the
> > > vmalloc space) and "non-linear SKBs" which refer to SKBs with fragment
> > > pages.
> >
> > I've tested both commits above, and I see the crash on both commits
> > above, thus, the problem reproduces in both cases. The only difference
> > I noted is the fact that I haven't seen the warning before the crash.
> >
> >
> > Log against c76f3c4364fe ("vhost/vsock: Avoid allocating
> > arbitrarily-sized SKBs")
> >
> >          Unable to handle kernel paging request at virtual address 0000001fc0000048
> >          Mem abort info:
> >            ESR = 0x0000000096000005
> >            EC = 0x25: DABT (current EL), IL = 32 bits
> >            SET = 0, FnV = 0
> >            EA = 0, S1PTW = 0
> >            FSC = 0x05: level 1 translation fault
> >          Data abort info:
> >            ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
> >            CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> >            GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> >          user pgtable: 64k pages, 48-bit VAs, pgdp=0000000cdcf2da00
> >          [0000001fc0000048] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
> >          Internal error: Oops: 0000000096000005 [#1]  SMP
> >          Modules linked in: vfio_iommu_type1 vfio md4 crc32_cryptoapi ghash_generic unix_diag vhost_net tun vhost vhost_iotlb tap mpls_gso mpls_iptunnel mpls_router fou sch_fq ghes_edac tls tcp_diag inet_diag act_gact cls_bpf nvidia_c
> >          CPU: 34 UID: 0 PID: 1727297 Comm: stress-ng-dev Kdump: loaded Not tainted 6.16.0-rc6-upstream-00027-gc76f3c4364fe #19 NONE
> >          pstate: 23401009 (nzCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
> >          pc : kfree+0x48/0x2a8
> >          lr : vhost_dev_cleanup+0x138/0x2b8 [vhost]
> >          sp : ffff80013a0cfcd0
> >          x29: ffff80013a0cfcd0 x28: ffff0008fd0b6240 x27: 0000000000000000
> >          x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
> >          x23: 00000000040e001f x22: ffffffffffffffff x21: ffff00014f1d4ac0
> >          x20: 0000000000000001 x19: ffff00014f1d0000 x18: 0000000000000000
> >          x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> >          x14: 000000000000001f x13: 000000000000000f x12: 0000000000000001
> >          x11: 0000000000000000 x10: 0000000000000402 x9 : ffffffdfc0000000
> >          x8 : 0000001fc0000040 x7 : 0000000000000000 x6 : 0000000000000000
> >          x5 : ffff000141931840 x4 : 0000000000000000 x3 : 0000000000000008
> >          x2 : ffffffffffffffff x1 : ffffffffffffffff x0 : 0000000000010000
> >          Call trace:
> >           kfree+0x48/0x2a8 (P)
> >           vhost_dev_cleanup+0x138/0x2b8 [vhost]
> >           vhost_net_release+0xa0/0x1a8 [vhost_net]
> 
> But here is the vhost_net, so I'm confused now.
> Do you see the same (vhost_net) also on 9798752 ("Add linux-next
> specific files for 20250721") ?

I will need to reproduce, but, looking at my logs, I see the following
against: c76f3c4364fe ("vhost/vsock: Avoid allocating arbitrarily-sized SKBs").
The logs are a bit intermixed, probably there were multiple CPUs hitting
the same code path.

           virt_to_phys used for non-linear address: 000000001b662678 (0xffe61984a460)
           WARNING: CPU: 15 PID: 112846 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x80/0xa8
           Modules linked in: vhost_vsock(E) vhost(E) vhost_iotlb(E) ghes_edac(E) tls(E) act_gact(E) cls_bpf(E) tcp_diag(E) inet_diag(E) ipmi_ssif(E) ipmi_devintf(E) ipmi_msghandler(E) sch_fq_codel(E) drm(E) backlight(E) drm_panel_orientation_quirks(E) acpi_power_meter(E) loop(E) efivarfs(E) autofs4(E)
           CPU: 15 UID: 0 PID: 112846 Comm: stress-ng-dev Kdump: loaded Tainted: G        W   E    N  6.16.0-rc6-upstream-00027-gc76f3c4364fe #16 PREEMPT(none) 
           Tainted: [W]=WARN, [E]=UNSIGNED_MODULE, [N]=TEST
           pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
           pc : __virt_to_phys+0x80/0xa8
           lr : __virt_to_phys+0x7c/0xa8
           sp : ffff8001184d7a30
           x29: ffff8001184d7a30 x28: 00000000000045d8 x27: 1fffe000e7e88014
           x26: 1fffe000e7e888f7 x25: ffff0007e578bf00 x24: 1fffe000e7e88013
           x23: 0000000000000000 x22: 0000ffe61984a460 x21: ffff00073f440098
           x20: ffffff1000080000 x19: 0000ffe61984a460 x18: 0000000000000002
           x17: 6666783028203837 x16: 3632363662313030 x15: 0000000000000001
           x14: 1fffe006d52e90f2 x13: 0000000000000000 x12: 0000000000000000
           x11: ffff6006d52e90f3 x10: 0000000000000002 x9 : cfc659a21c727d00
           x8 : ffff800083c19000 x7 : 0000000000000001 x6 : 0000000000000001
           x5 : ffff8001184d7398 x4 : ffff800084866d60 x3 : ffff8000805fdd94
           x2 : 0000000000000001 x1 : 0000000000000004 x0 : 000000000000004b
           Call trace:
            __virt_to_phys+0x80/0xa8 (P)
            kfree+0xac/0x4b0
            vhost_dev_cleanup+0x484/0x8b0 [vhost]
            vhost_vsock_dev_release+0x2f4/0x358 [vhost_vsock]
            __fput+0x2b4/0x608
            fput_close_sync+0xe8/0x1e0
            __arm64_sys_close+0x84/0xd0
            invoke_syscall+0x8c/0x208
            do_el0_svc+0x128/0x1a0
            el0_svc+0x58/0x160
            el0t_64_sync_handler+0x78/0x108
            el0t_64_sync+0x198/0x1a0
           irq event stamp: 0
           hardirqs last  enabled at (0): [<0000000000000000>] 0x0
           hardirqs last disabled at (0): [<ffff8000801d876c>] copy_process+0xd5c/0x29f8
           softirqs last  enabled at (0): [<ffff8000801d879c>] copy_process+0xd8c/0x29f8
           softirqs last disabled at (0): [<0000000000000000>] 0x0
           ---[ end trace 0000000000000000 ]---
           Unable to handle kernel paging request at virtual address 0000040053791288
           ------------[ cut here ]------------
           lr : kfree+0xac/0x4b0
           virt_to_phys used for non-linear address: 00000000290839fd (0x2500000000)
           WARNING: CPU: 41 PID: 112845 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0x80/0xa8
           Modules linked in: vhost_vsock(E) vhost(E) vhost_iotlb(E) ghes_edac(E) tls(E) act_gact(E) cls_bpf(E) tcp_diag(E) inet_diag(E) ipmi_ssif(E) ipmi_devintf(E) ipmi_msghandler(E) sch_fq_codel(E) drm(E) backlight(E) drm_panel_orientation_quirks(E) acpi_power_meter(E) loop(E) efivarfs(E) autofs4(E)
           CPU: 41 UID: 0 PID: 112845 Comm: stress-ng-dev Kdump: loaded Tainted: G        W   E    N  6.16.0-rc6-upstream-00027-gc76f3c4364fe #16 PREEMPT(none) 
           x23: 0000000000000001
           Tainted: [W]=WARN, [E]=UNSIGNED_MODULE, [N]=TEST
           pstate: 63401009 (nZCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
           pc : __virt_to_phys+0x80/0xa8
           lr : __virt_to_phys+0x7c/0xa8
           sp : ffff8001a8277a30
           x29: ffff8001a8277a30 x28: 00000000000045d8 x27: 1fffe000e7e3c014
           x26: 1fffe000e7e3c8f7 x25: ffff0007bcff0000 x24: 1fffe000e7e3c013
           x23: 0000000000000000 x22: 0000002500000000 x21: ffff00073f1e0098
           x20: ffffff1000080000 x19: 0000002500000000 x18: 0000000000000004
           x17: 00000000ffffffff x16: 0000000000000001 x15: 0000000000000001
           x14: 1fffe006d53920f2 x13: 0000000000000000 x12: 0000000000000000
           sp : ffff8001184d7a50
           x29: ffff8001184d7a60 x28: 00000000000045d8 x27: 1fffe000e7e88014
           x26: 1fffe000e7e888f7 x25: ffff0007e578bf00 x24: 1fffe000e7e88013
           x23: 0000000000000000 x22: 0000ffe61984a460 x21: ffff00073f440098
           x20: 0000040053791280 x19: ffff80000d0b8bbc x18: 0000000000000002
           x17: 6666783028203837 x16: 3632363662313030 x15: 0000000000000001
            x22: 0000ffe6199a459d
           x14: 1fffe006d52e90f2
            x21: ffff00073f7f0098
           x20: ffffff1000080000 x19: 0000ffe6199a459d x18: 0000000000000004
           x17: 54455320203b2d2c x16: 0000000000000011 x15: 0000000000000001
           x14: 1fffe006d52bb8f2 x13: 0000000000000000 x12: 0000000000000000
           x11: ffff6006d52bb8f3 x10: dfff800000000000 x9 : 77521a2bd3e0be00
           x8 : ffff800083c19000 x7 : 0000000000000000 x6 : ffff80008036bc2c
           x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff8000805fdd94
           x2 : 0000000000000001 x1 : 0000000000000004 x0 : 000000000000004b
           Call trace:
            __virt_to_phys+0x80/0xa8 (P)
            kfree+0xac/0x4b0
            vhost_dev_cleanup+0x484/0x8b0 [vhost]
            vhost_vsock_dev_release+0x2f4/0x358 [vhost_vsock]
            __fput+0x2b4/0x608
           x11: ffff6006d53920f3
            fput_close_sync+0xe8/0x1e0
            __arm64_sys_close+0x84/0xd0
            invoke_syscall+0x8c/0x208
            do_el0_svc+0x128/0x1a0
            el0_svc+0x58/0x160
            el0t_64_sync_handler+0x78/0x108
            el0t_64_sync+0x198/0x1a0
           irq event stamp: 0
            x13: 0000000000000000
           hardirqs last  enabled at (0): [<0000000000000000>] 0x0
           hardirqs last disabled at (0): [<ffff8000801d876c>] copy_process+0xd5c/0x29f8


> The initial report contained only vhost_vsock traces IIUC, so I'm
> suspecting something in the vhost core.

Right, it seems we are hitting the same code path, on on both
vhost_vsock and vhost_net.

