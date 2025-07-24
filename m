Return-Path: <kvm+bounces-53366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCD1B10AB6
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1286A3AD381
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C3812D5427;
	Thu, 24 Jul 2025 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XdMFeb2m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7DB2D46DA
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361545; cv=none; b=q8Zgr96OnS0qk2b/cb1srr5LPMkCUkkL+7N/AE28fxv4NVnPjrPEC8uo3BSXEIzvR4KbStVWGutB242bS19xBLYiJkVgPk0QodlhTdIrrcbPTXlsennpc9+elp9IjOy2Zi377vQPDZBNe54jTDPJcXc4eVyintiTo128ZgnESrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361545; c=relaxed/simple;
	bh=BT20HzWX+V0L1vB//2tVipRHixFnss8XHnnXe1uy9sA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O7uqkqyVOGjLiII9QiUNCtkH7ANNAyWrsxrI4kips2hSAL9ovkTyEYgL9CiaOag2smEWmFpi/Od/aXGR1ofpyEB2S1n/XybiiaHFuTyKcrCFlVy57Opw7gE2A4aBDVUX4Fd398O/HcIdCVOtL2hOcqohbPgdY/IJOPuc3U1VJtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XdMFeb2m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753361542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M+yXn2Dd03JRNhm/5JyeMXOZKFuYEN81fHuvdMRTIp8=;
	b=XdMFeb2mGwcipMQfGwdrzGFbHjpUq6XKO0qFx+/NK8gwaxGp5CBCkn9FjXGmmwoMF4fWNs
	VFa1FZzE80s7Tlb8ret+ADJ2YVZqXsVN5AG7D/zUlBO8k2lB0nEBjCqs/KIP+MqcCYzy8x
	eIBqWMv3YWeSb2WQc1OH4FJGLuSvSAY=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-sUpLBncOO1Klo-sSleOhoA-1; Thu, 24 Jul 2025 08:52:21 -0400
X-MC-Unique: sUpLBncOO1Klo-sSleOhoA-1
X-Mimecast-MFC-AGG-ID: sUpLBncOO1Klo-sSleOhoA_1753361541
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e72b0980138so1327329276.1
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 05:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753361541; x=1753966341;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+yXn2Dd03JRNhm/5JyeMXOZKFuYEN81fHuvdMRTIp8=;
        b=YWh0POS+o7y0hoa3Nt5ks5hAb34SQ/a657xxZZl7elDce19CgplT+Rch22m4puG8Rp
         +hrMFsYzcNiA9k9VapXRTaVvsGscLvKOH1kDtckz3sM1CDIpysXiJ/07aZAIuiCB0S0J
         7YWMXrHn1YfEiNNN9t4BaP7nxIcRWS2mcE84Be8sFG9clZ6bQPdopX2GVWE+MCUxXE/B
         CUsbXqbelnDaSVWrYWyPdXeMG9CaVCLv24oFyxV8iJgF1K9XLv33xzOOlfC6DO7C7rmu
         sd+PODS9WC7Oh15x/GOhsxSMhPJ3Rn7eJdtZvXJhKlCn9OxYYL08kIR88pmo0w/f966/
         4g3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUA7tNaFnIMjRFuQxDOkmNqz+pQbjSmTZhKXgGSv0C6LSD2xCOVl7n3RzBrohw6KqmtKDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSN6K8qhvyWCH2S0r4Oi2t0CA25CH3m+g6GNPrwLGFDoCakaqi
	XOheV0euSYaUtqaU51amX9NFlqz/j2S/afQoADYD25Qyc3sYd+atABz7RKzFObl/B7HmbpLzJwO
	ZwUIPo2JqQ5+Eam1bOiSq4GEcIaonaV8dmB+d5X6UMe72OEAGVQzplCHlaPfZSynaSET7GjGLYA
	hk7IRXkpgXusMKyKQVtUc0ucQVQGP+
X-Gm-Gg: ASbGncsahwZ4JWST3kwLRNuCFTC52UZNXHW4/aTymhDI6kfuZDg8JhNwG6Zr4/RssYO
	1cUyBhgDkHZmxEPEcY8bvt9TanFkkQTbWzTTvaBXRtCshuvcaAHuU9VJeVpUYey4ulTvAQJg8Lg
	u1wCCf4PArvqRsVAiOjTyr
X-Received: by 2002:a05:6902:4a7:b0:e87:9bab:25d with SMTP id 3f1490d57ef6-e8dc5b5c9a3mr6055896276.39.1753361540482;
        Thu, 24 Jul 2025 05:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+sxi2SF54aHzw0dd7QBG7rNJyq5RlA5zJNp/TA3A+qcVSys8/eRIZSECOlpj/89ZnMMKBfoWNEee5wXBQRqA=
X-Received: by 2002:a05:6902:4a7:b0:e87:9bab:25d with SMTP id
 3f1490d57ef6-e8dc5b5c9a3mr6055873276.39.1753361539934; Thu, 24 Jul 2025
 05:52:19 -0700 (PDT)
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
In-Reply-To: <fv6uhq6lcgjwrdp7fcxmokczjmavbc37ikrqz7zpd7puvrbsml@zkt2lidjrqm6>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 24 Jul 2025 14:52:08 +0200
X-Gm-Features: Ac12FXwbtWtqNIZqXPX4jKNjmg84cpnD3-Y4W9qdqMU4Zw6KtEs0EheiQJT1DQo
Message-ID: <CAGxU2F5Qy=vMD0z9_HTN2K9wyt+6EH-Yr0N9VqR4OT4O1asqZg@mail.gmail.com>
Subject: Re: vhost: linux-next: crash at vhost_dev_cleanup()
To: Breno Leitao <leitao@debian.org>
Cc: Will Deacon <will@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, jasowang@redhat.com, 
	eperezma@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Jul 2025 at 14:48, Breno Leitao <leitao@debian.org> wrote:
>
> On Thu, Jul 24, 2025 at 09:44:38AM +0100, Will Deacon wrote:
> > > > On Thu, 24 Jul 2025 at 09:48, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Wed, Jul 23, 2025 at 08:04:42AM -0700, Breno Leitao wrote:
> > > > > > Hello,
> > > > > >
> > > > > > I've seen a crash in linux-next for a while on my arm64 server, and
> > > > > > I decided to report.
> > > > > >
> > > > > > While running stress-ng on linux-next, I see the crash below.
> > > > > >
> > > > > > This is happening in a kernel configure with some debug options (KASAN,
> > > > > > LOCKDEP and KMEMLEAK).
> > > > > >
> > > > > > Basically running stress-ng in a loop would crash the host in 15-20
> > > > > > minutes:
> > > > > >       # while (true); do stress-ng -r 10 -t 10; done
> > > > > >
> > > > > > >From the early warning "virt_to_phys used for non-linear address",
> > > >
> > > > mmm, we recently added nonlinear SKBs support in vhost-vsock [1],
> > > > @Will can this issue be related?
> > >
> > > Good point.
> > >
> > > Breno, if bisecting is too much trouble, would you mind testing the commits
> > > c76f3c4364fe523cd2782269eab92529c86217aa
> > > and
> > > c7991b44d7b44f9270dec63acd0b2965d29aab43
> > > and telling us if this reproduces?
> >
> > That's definitely worth doing, but we should be careful not to confuse
> > the "non-linear address" from the warning (which refers to virtual
> > addresses that lie outside of the linear mapping of memory, e.g. in the
> > vmalloc space) and "non-linear SKBs" which refer to SKBs with fragment
> > pages.
>
> I've tested both commits above, and I see the crash on both commits
> above, thus, the problem reproduces in both cases. The only difference
> I noted is the fact that I haven't seen the warning before the crash.
>
>
> Log against c76f3c4364fe ("vhost/vsock: Avoid allocating
> arbitrarily-sized SKBs")
>
>          Unable to handle kernel paging request at virtual address 0000001fc0000048
>          Mem abort info:
>            ESR = 0x0000000096000005
>            EC = 0x25: DABT (current EL), IL = 32 bits
>            SET = 0, FnV = 0
>            EA = 0, S1PTW = 0
>            FSC = 0x05: level 1 translation fault
>          Data abort info:
>            ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
>            CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>            GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>          user pgtable: 64k pages, 48-bit VAs, pgdp=0000000cdcf2da00
>          [0000001fc0000048] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
>          Internal error: Oops: 0000000096000005 [#1]  SMP
>          Modules linked in: vfio_iommu_type1 vfio md4 crc32_cryptoapi ghash_generic unix_diag vhost_net tun vhost vhost_iotlb tap mpls_gso mpls_iptunnel mpls_router fou sch_fq ghes_edac tls tcp_diag inet_diag act_gact cls_bpf nvidia_c
>          CPU: 34 UID: 0 PID: 1727297 Comm: stress-ng-dev Kdump: loaded Not tainted 6.16.0-rc6-upstream-00027-gc76f3c4364fe #19 NONE
>          pstate: 23401009 (nzCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
>          pc : kfree+0x48/0x2a8
>          lr : vhost_dev_cleanup+0x138/0x2b8 [vhost]
>          sp : ffff80013a0cfcd0
>          x29: ffff80013a0cfcd0 x28: ffff0008fd0b6240 x27: 0000000000000000
>          x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
>          x23: 00000000040e001f x22: ffffffffffffffff x21: ffff00014f1d4ac0
>          x20: 0000000000000001 x19: ffff00014f1d0000 x18: 0000000000000000
>          x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>          x14: 000000000000001f x13: 000000000000000f x12: 0000000000000001
>          x11: 0000000000000000 x10: 0000000000000402 x9 : ffffffdfc0000000
>          x8 : 0000001fc0000040 x7 : 0000000000000000 x6 : 0000000000000000
>          x5 : ffff000141931840 x4 : 0000000000000000 x3 : 0000000000000008
>          x2 : ffffffffffffffff x1 : ffffffffffffffff x0 : 0000000000010000
>          Call trace:
>           kfree+0x48/0x2a8 (P)
>           vhost_dev_cleanup+0x138/0x2b8 [vhost]
>           vhost_net_release+0xa0/0x1a8 [vhost_net]

But here is the vhost_net, so I'm confused now.
Do you see the same (vhost_net) also on 9798752 ("Add linux-next
specific files for 20250721") ?

The initial report contained only vhost_vsock traces IIUC, so I'm
suspecting something in the vhost core.

Thanks,
Stefano

>           __fput+0xfc/0x2f0
>           fput_close_sync+0x38/0xc8
>           __arm64_sys_close+0xb4/0x108
>           invoke_syscall+0x4c/0xd0
>           do_el0_svc+0x80/0xb0
>           el0_svc+0x3c/0xd0
>           el0t_64_sync_handler+0x70/0x100
>           el0t_64_sync+0x170/0x178
>          Code: 8b080008 f2dffbe9 d350fd08 8b081928 (f9400509)
>
> Log against c7991b44d7b4 ("vsock/virtio: Allocate nonlinear SKBs for
> handling large transmit buffers")
>
>         Unable to handle kernel paging request at virtual address 0010502f8f8f4f08
>         Mem abort info:
>           ESR = 0x0000000096000004
>           EC = 0x25: DABT (current EL), IL = 32 bits
>           SET = 0, FnV = 0
>           EA = 0, S1PTW = 0
>           FSC = 0x04: level 0 translation fault
>         Data abort info:
>           ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
>           CM = 0, WnR = 0, TnD = 0, TagAccess = 0
>           GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>         [0010502f8f8f4f08] address between user and kernel address ranges
>         Internal error: Oops: 0000000096000004 [#1]  SMP
>         Modules linked in: vhost_vsock vfio_iommu_type1 vfio md4 crc32_cryptoapi ghash_generic vhost_net tun vhost vhost_iotlb tap mpls_gso mpls_iptunnel mpls_router fou sch_fq ghes_edac tls tcp_diag inet_diag act_gact cls_bpf ipmi_s
>         CPU: 47 UID: 0 PID: 1239699 Comm: stress-ng-dev Kdump: loaded Tainted: G        W           6.16.0-rc6-upstream-00035-gc7991b44d7b4 #18 NONE
>         Tainted: [W]=WARN
>         pstate: 23401009 (nzCv daif +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
>         pc : kfree+0x48/0x2a8
>         lr : vhost_dev_cleanup+0x138/0x2b8 [vhost]
>         sp : ffff80016c0cfcd0
>         x29: ffff80016c0cfcd0 x28: ffff001ad6210d80 x27: 0000000000000000
>         x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
>         x23: 00000000040e001f x22: ffffffffffffffff x21: ffff001bb76f00c0
>         x20: 0000000000000000 x19: ffff001bb76f0000 x18: 0000000000000000
>         x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>         x14: 000000000000001f x13: 000000000000000f x12: 0000000000000001
>         x11: 0000000000000000 x10: 0000000000000402 x9 : ffffffdfc0000000
>         x8 : 0010502f8f8f4f00 x7 : 0000000000000000 x6 : 0000000000000000
>         x5 : ffff00012e7e2128 x4 : 0000000000000000 x3 : 0000000000000008
>         x2 : ffffffffffffffff x1 : ffffffffffffffff x0 : 41403f3e3d3c3b3a
>         Call trace:
>          kfree+0x48/0x2a8 (P)
>          vhost_dev_cleanup+0x138/0x2b8 [vhost]
>          vhost_net_release+0xa0/0x1a8 [vhost_net]
>          __fput+0xfc/0x2f0
>          fput_close_sync+0x38/0xc8
>          __arm64_sys_close+0xb4/0x108
>          invoke_syscall+0x4c/0xd0
>          do_el0_svc+0x80/0xb0
>          el0_svc+0x3c/0xd0
>          el0t_64_sync_handler+0x70/0x100
>          el0t_64_sync+0x170/0x178
>         Code: 8b080008 f2dffbe9 d350fd08 8b081928 (f9400509)
>
>
> > Breno -- when you say you've been seeing this "for a while", what's the
> > earliest kernel you know you saw it on?
>
> Looking at my logs, the older kernel that I saw it was net-next from
> 20250717, which was around the time I decided to test net-next in
> preparation for 6.17, so, not very helpful. Sorry.
>


