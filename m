Return-Path: <kvm+bounces-9949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D23B3867E96
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:33:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 473B01F2507E
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3646A12D751;
	Mon, 26 Feb 2024 17:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7DRkw44"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755212EBE8
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 17:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708968768; cv=none; b=r1cf1IJIJwMnx+sVSdql27yL3HG3xl+3XxxX9kk87DNhauOmh5bV4Ma2bN/DKpzSW0R7AENYSHe1+CezvNVFanfc8bb3R53W8yOi2LuDob2J0EoW62LcxUu+7+YvLnKfZ2TP9nM8ktCxuqIPwwrubBMzb+ib5TtXdQgE9G9JRjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708968768; c=relaxed/simple;
	bh=0Ba/9K2KuoV40sLwpd8cP9hSr5/ntf0VbGqvJ6RC6ug=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cjjdr7wLDdNvDWwr88I72t+pal+KphlE9OmxrE0z/f7+Wf+/ocnR4Ea0PmnPf0DJJPQ7LWtDRQwYJdqzn9Cfq/QZsddbP6gEZXtCfsbTyU1IR49DJ4oy26UA7RCNs1JRzoYOfna3H3tfPcIcgMATF7ZcOgHqGrMxNYhFWxQjxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7DRkw44; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708968765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jjX5ODwMNKFdWrkJxr6VORv+MaO7Rg0pnbcoAEeofYk=;
	b=E7DRkw44e/srfSFnPGV3hcE6CGDFEba7QIJlakwkqqJuWevFGqzJrcZtt3w3UEY4gxnZcS
	TwRK4CCOn4LX3QzYHlhsDU7bzgYYFjb367p3VLZkrciUTopWat/EFZEh8a0Gah9hmnvLMM
	+3t9NOkMkWR2/uOmiSFkpFcJANfn7XM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-8EHFCyTbN4ay8IU7ThlUJg-1; Mon, 26 Feb 2024 12:32:44 -0500
X-MC-Unique: 8EHFCyTbN4ay8IU7ThlUJg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c7a2788749so198280539f.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:32:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708968762; x=1709573562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jjX5ODwMNKFdWrkJxr6VORv+MaO7Rg0pnbcoAEeofYk=;
        b=wliTqyqN9AsYeHoAe7yD+kMd1BHTv6AbyqDOBPShsrEMk1RSHJOYyThqIKMJn69srF
         zRSWnCNGKh1zLdXg0mTlkCUWh7IJ8uae4Dx4Ggg1b3CWa3qZlhRRKijMSsGnTejgyVAd
         2nSMUKDmD3rI3Ehe26SCyoKTgE2wDPQICMmhYdh41nQkgpusA0FaYrQ0WkXb93gtA/jy
         WtfNlk582iv0ppC7w41xzGLfXxhj/G9ZLO2J/sf7g8GQ41h+B6SH1LNrW91v1JzEnaaQ
         jinj56ocICAeVts9ccDDglfwemtNbgngTLNXYBmoidbWFKQj1YW+CuO5Zjlre+qy3jL8
         C8lg==
X-Gm-Message-State: AOJu0YxvNGpKoF2iD7u+iIJNCntjq5Y9+kyFJzofThiM0MPe2YspTrt/
	Bv7O6lm+aDQGCz6/m6+WvHOXLhyd6oIiozLdHwYZdmgv33rpCsqwN/0Ls1XI1VnDGFKG7Tn3CaA
	W6MVJCqLMdRj4+l3bcFc+UzSF0K4Ord1CttRbAXIbgjaSNe5cVg==
X-Received: by 2002:a5e:9918:0:b0:7c7:ddef:e11c with SMTP id t24-20020a5e9918000000b007c7ddefe11cmr1182614ioj.13.1708968762172;
        Mon, 26 Feb 2024 09:32:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3PtDchAWOks2wYjwP0Dxg5ziZwMLLpYh1GoHJItPvKLJWbBcCVrM6sR+YAQ8RAultSmbccg==
X-Received: by 2002:a5e:9918:0:b0:7c7:ddef:e11c with SMTP id t24-20020a5e9918000000b007c7ddefe11cmr1182575ioj.13.1708968761491;
        Mon, 26 Feb 2024 09:32:41 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r17-20020a6b4411000000b007c7a2b8ee98sm1356778ioa.2.2024.02.26.09.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 09:32:41 -0800 (PST)
Date: Mon, 26 Feb 2024 10:32:38 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yisheng Xie <ethan.xys@linux.alibaba.com>, akpm@linux-foundation.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
Message-ID: <20240226103238.75ad4b24.alex.williamson@redhat.com>
In-Reply-To: <e10ace3f-78d3-4843-8028-a0e1cd107c15@linux.alibaba.com>
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
	<20240226091438.1fc37957.alex.williamson@redhat.com>
	<e10ace3f-78d3-4843-8028-a0e1cd107c15@linux.alibaba.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 01:14:54 +0800
Yisheng Xie <ethan.xys@linux.alibaba.com> wrote:

> =E5=9C=A8 2024/2/27 00:14, Alex Williamson =E5=86=99=E9=81=93:
> > On Tue, 27 Feb 2024 00:01:06 +0800
> > Yisheng Xie<ethan.xys@linux.alibaba.com>  wrote:
> > =20
> >> We meet a warning as following:
> >>   WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 try_grab_page.part.0+0=
xe8/0x1b0
> >>   CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  5.10=
.134-008.2.x86_64 #1 =20
> >                                                                     ^^^=
^^^^^
> >
> > Does this issue reproduce on mainline?  Thanks, =20
>=20
> I have check the code of mainline, the logical seems the same as my=20
> version.
>=20
> so I think it can reproduce if i understand correctly.

I obviously can't speak to what's in your 5.10.134-008.2 kernel, but I
do know there's a very similar issue resolved in v6.0 mainline and
included in v5.10.146 of the stable tree.  Please test.  Thanks,

Alex

> >>   Hardware name: Foxconn AliServer-Thor-04-12U-v2/Thunder2, BIOS 1.0.P=
L.FC.P.031.00 05/18/2022
> >>   RIP: 0010:try_grab_page.part.0+0xe8/0x1b0
> >>   Code: b9 00 04 00 00 83 e6 01 74 ca 48 8b 32 b9 00 04 00 00 f7 c6 00=
 00 01 00 74 ba eb 91 8b 57 34 48 89 f8 85 d2 0f 8f 48 ff ff ff <0f> 0b 31 =
c0 c3 48 89 fa 48 8b 0a f7 c1 00 00 01 00 0f 85 5c ff ff
> >>   RSP: 0018:ffffc900b1a63b98 EFLAGS: 00010282
> >>   RAX: ffffea00000e4580 RBX: 0000000000052202 RCX: ffffea00000e4580
> >>   RDX: 0000000080000001 RSI: 0000000000052202 RDI: ffffea00000e4580
> >>   RBP: ffff88efa5d3d860 R08: 0000000000000000 R09: 0000000000000002
> >>   R10: 0000000000000008 R11: ffff89403fff7000 R12: ffff88f589165818
> >>   R13: 00007f1320600000 R14: ffffea0181296ca8 R15: ffffea00000e4580
> >>   FS:  00007f1324f93e00(0000) GS:ffff893ebfb80000(0000) knlGS:00000000=
00000000
> >>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>   CR2: 00007f1321694070 CR3: 0000006046014004 CR4: 00000000007726e0
> >>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >>   PKRU: 55555554
> >>   Call Trace:
> >>    follow_page_pte+0x64b/0x800
> >>    __get_user_pages+0x228/0x560
> >>    __gup_longterm_locked+0xa0/0x2f0
> >>    vaddr_get_pfns+0x67/0x100 [vfio_iommu_type1]
> >>    vfio_pin_pages_remote+0x30b/0x460 [vfio_iommu_type1]
> >>    vfio_pin_map_dma+0xd4/0x2e0 [vfio_iommu_type1]
> >>    vfio_dma_do_map+0x21e/0x340 [vfio_iommu_type1]
> >>    vfio_iommu_type1_ioctl+0xdd/0x170 [vfio_iommu_type1]
> >>    ? __fget_files+0x79/0xb0
> >>    ksys_ioctl+0x7b/0xb0
> >>    ? ksys_write+0xc4/0xe0
> >>    __x64_sys_ioctl+0x16/0x20
> >>    do_syscall_64+0x2d/0x40
> >>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>
> >> After add dumppage, it shows that it is a PageReserved page(e.g. zero =
page),
> >> whoes refcount is just overflow:
> >>   page:00000000b0504535 refcount:-2147483647 mapcount:0 mapping:000000=
0000000000 index:0x0 pfn:0x3916
> >>   flags: 0xffffc000001002(referenced|reserved)
> >>   raw: 00ffffc000001002 ffffea00000e4588 ffffea00000e4588 000000000000=
0000
> >>   raw: 0000000000000000 0000000000000000 80000001ffffffff 000000000000=
0000
> >>
> >> gup will _pin_ a page which is PageReserved, however, put_pfn in vfio =
will
> >> skip unpin page which is PageReserved. So use pfn_valid in put_pfn
> >> instead of !is_invalid_reserved_pfn to unpin PageReserved page.
> >>
> >> Signed-off-by: Yisheng Xie<ethan.xys@linux.alibaba.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu=
_type1.c
> >> index b2854d7939ce..12775bab27ee 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -461,7 +461,7 @@ static bool is_invalid_reserved_pfn(unsigned long =
pfn)
> >>  =20
> >>   static int put_pfn(unsigned long pfn, int prot)
> >>   {
> >> -	if (!is_invalid_reserved_pfn(pfn)) {
> >> +	if (pfn_valid(pfn)) {
> >>   		struct page *page =3D pfn_to_page(pfn);
> >>  =20
> >>   		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE); =20


