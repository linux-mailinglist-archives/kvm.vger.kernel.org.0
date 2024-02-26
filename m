Return-Path: <kvm+bounces-9944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 227BC867B68
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0CF1F2D607
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D5D212C80F;
	Mon, 26 Feb 2024 16:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXQiRXnM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72EF12C819
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708964089; cv=none; b=bq5FmA2yFXVHha8Z6GfMOa2jCwx/A2PNlkQ3poAMoTa58c1hMwFEpLvsr2/ZPcnqCbbJW6e9P4Ieet97BQPCHbYeID9NnpR4A+ZTb67uH+0XjhV3QcE+p5iWZP/1IOMwwpteQwqx/SENvAAxOG+JEdAo1tR+4xGwYkCSP2/g8/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708964089; c=relaxed/simple;
	bh=zj0XwpMIin7pGrxcYK98c2JcaJFWjsXaHOvdPbxbwpI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frAFYG0PAZqmepp3tAFgTlBUmLjf6Dfwdyobxhb4j0DDF5LORHwA8g9bq7zzRs7utpUrgnxCHl7vNKknUhfHRBuuDMXt2v5ToII60WsLv5aOkr7oJJx8LWiBH32nzu6Yxf0cDi3ZucxSTz9mEwGVq1mUapYlUnEdJnVEu7mFlP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXQiRXnM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708964086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zh3mDtCIv3auLG9zPOiKdCdk64UMolNzMr0oDDvC2P8=;
	b=EXQiRXnM1D8XHZSCt+qJ/LijwK9uMlep2ni30Id6eaWCc7NSGFSW06FKOlUmi7xCw7Dnjg
	g8JPJS4YfYlhxBh/apqr87xYlhQbQlOUnazR+/WZ+8cDti/+swOi7yqNOByuRrJgzrRb+V
	peUvBhw94n9A8maIW3q5v2JyxZ5KXsA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-Zr07GbzTPq6nTTuyfNAtcA-1; Mon, 26 Feb 2024 11:14:44 -0500
X-MC-Unique: Zr07GbzTPq6nTTuyfNAtcA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c78573f2e9so352418539f.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 08:14:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708964083; x=1709568883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zh3mDtCIv3auLG9zPOiKdCdk64UMolNzMr0oDDvC2P8=;
        b=aK6Pkrcpt6jhv9Pgp34abysWt5xDaoE9kLhKnjv9Qf3zbLxUyW8CqZQfDp1hb+lcNC
         Ycf28IkRKg4GG4nYVlvnBvkdr30iN/Jrz6uA8SttKF3xIoQ8TPlBrRBSSPXMA0YRJlfI
         g4Fo/aluMIZHtUKmNYZ0iMv3vSNse0zGXPuBjLuP+Bi1hxP5T4miy8OOBN+sz4TM1oqB
         SaU2pQ60Yg1Rcii/4mCYFpV6m6BQTUVuBmGSf4ShX5IY9OIPN01JtUOfLIIQY98hTkqF
         RDay1X1f6T3XNT/WbazPB0P0fKxcThDf8S7ZVpnkWRtch+cOKuY72hJKPoMXGJgxkVB5
         ESUw==
X-Forwarded-Encrypted: i=1; AJvYcCUExOMrDsngI5IBnPI7ocaRsGme22oILjs8b7na2CkbyF6f5KRyGVcs2aDvx4B+iSReHRMssYJZ4QfDyCB/JT9Jr/bA
X-Gm-Message-State: AOJu0YzYGw8xHtfH41Vo5lj1Aj5CjvfP0C4GAj1GletI3HZ9cz0Z/eEN
	UHGGjAwVMH1DMj/zfhMwC+1hJiwYhY5p2BIIuhPsOliS2CPoWZeAgtV3dzZXmjBcu6eZ91v5ZD5
	QSs0fg3kzTD3uFDCUuqA+uozZiyz+X2r6qSapXYFFcRkod5B9oA==
X-Received: by 2002:a5d:83c3:0:b0:7c7:ba20:5590 with SMTP id u3-20020a5d83c3000000b007c7ba205590mr5460960ior.14.1708964082707;
        Mon, 26 Feb 2024 08:14:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGEOWu1T2z+J1Gp1UZDUyQh8NW65H7pvXhZJgZkO41DXiNpZ6UF/UvqLLU6+ypJXEHMrDXlQ==
X-Received: by 2002:a5d:83c3:0:b0:7c7:ba20:5590 with SMTP id u3-20020a5d83c3000000b007c7ba205590mr5460947ior.14.1708964082433;
        Mon, 26 Feb 2024 08:14:42 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id fj33-20020a056638636100b004747eb13d6fsm915292jab.41.2024.02.26.08.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 08:14:41 -0800 (PST)
Date: Mon, 26 Feb 2024 09:14:38 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yisheng Xie <ethan.xys@linux.alibaba.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] vfio/type1: unpin PageReserved page
Message-ID: <20240226091438.1fc37957.alex.williamson@redhat.com>
In-Reply-To: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
References: <20240226160106.24222-1-ethan.xys@linux.alibaba.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Feb 2024 00:01:06 +0800
Yisheng Xie <ethan.xys@linux.alibaba.com> wrote:

> We meet a warning as following:
>  WARNING: CPU: 99 PID: 1766859 at mm/gup.c:209 try_grab_page.part.0+0xe8/0x1b0
>  CPU: 99 PID: 1766859 Comm: qemu-kvm Kdump: loaded Tainted: GOE  5.10.134-008.2.x86_64 #1
                                                                   ^^^^^^^^

Does this issue reproduce on mainline?  Thanks,

Alex

>  Hardware name: Foxconn AliServer-Thor-04-12U-v2/Thunder2, BIOS 1.0.PL.FC.P.031.00 05/18/2022
>  RIP: 0010:try_grab_page.part.0+0xe8/0x1b0
>  Code: b9 00 04 00 00 83 e6 01 74 ca 48 8b 32 b9 00 04 00 00 f7 c6 00 00 01 00 74 ba eb 91 8b 57 34 48 89 f8 85 d2 0f 8f 48 ff ff ff <0f> 0b 31 c0 c3 48 89 fa 48 8b 0a f7 c1 00 00 01 00 0f 85 5c ff ff
>  RSP: 0018:ffffc900b1a63b98 EFLAGS: 00010282
>  RAX: ffffea00000e4580 RBX: 0000000000052202 RCX: ffffea00000e4580
>  RDX: 0000000080000001 RSI: 0000000000052202 RDI: ffffea00000e4580
>  RBP: ffff88efa5d3d860 R08: 0000000000000000 R09: 0000000000000002
>  R10: 0000000000000008 R11: ffff89403fff7000 R12: ffff88f589165818
>  R13: 00007f1320600000 R14: ffffea0181296ca8 R15: ffffea00000e4580
>  FS:  00007f1324f93e00(0000) GS:ffff893ebfb80000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f1321694070 CR3: 0000006046014004 CR4: 00000000007726e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>   follow_page_pte+0x64b/0x800
>   __get_user_pages+0x228/0x560
>   __gup_longterm_locked+0xa0/0x2f0
>   vaddr_get_pfns+0x67/0x100 [vfio_iommu_type1]
>   vfio_pin_pages_remote+0x30b/0x460 [vfio_iommu_type1]
>   vfio_pin_map_dma+0xd4/0x2e0 [vfio_iommu_type1]
>   vfio_dma_do_map+0x21e/0x340 [vfio_iommu_type1]
>   vfio_iommu_type1_ioctl+0xdd/0x170 [vfio_iommu_type1]
>   ? __fget_files+0x79/0xb0
>   ksys_ioctl+0x7b/0xb0
>   ? ksys_write+0xc4/0xe0
>   __x64_sys_ioctl+0x16/0x20
>   do_syscall_64+0x2d/0x40
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> After add dumppage, it shows that it is a PageReserved page(e.g. zero page),
> whoes refcount is just overflow:
>  page:00000000b0504535 refcount:-2147483647 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3916
>  flags: 0xffffc000001002(referenced|reserved)
>  raw: 00ffffc000001002 ffffea00000e4588 ffffea00000e4588 0000000000000000
>  raw: 0000000000000000 0000000000000000 80000001ffffffff 0000000000000000
> 
> gup will _pin_ a page which is PageReserved, however, put_pfn in vfio will
> skip unpin page which is PageReserved. So use pfn_valid in put_pfn
> instead of !is_invalid_reserved_pfn to unpin PageReserved page.
> 
> Signed-off-by: Yisheng Xie <ethan.xys@linux.alibaba.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b2854d7939ce..12775bab27ee 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -461,7 +461,7 @@ static bool is_invalid_reserved_pfn(unsigned long pfn)
>  
>  static int put_pfn(unsigned long pfn, int prot)
>  {
> -	if (!is_invalid_reserved_pfn(pfn)) {
> +	if (pfn_valid(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
>  		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);


