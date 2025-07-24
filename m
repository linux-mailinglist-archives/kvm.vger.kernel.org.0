Return-Path: <kvm+bounces-53385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5266B10FFF
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 18:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CA321CE6559
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 16:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7762EAB66;
	Thu, 24 Jul 2025 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TIUt/9/U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA4E2EAD09
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753376180; cv=none; b=e4EnYBUObD1Gcy/Q5Q/csy9SfFg5TJ2EunLZLMoavDkjIrevL2WG3GWWrULBlJ0C2pW5G1q6f0lWHbSQZQVxOLFbaRSmz5HA1AvTyEjjeSTPWtVD/81WECzplCQtFUl5LQT41L2RXSgjmnFCC+RJGjh24KZF7Ou9XQLGmGkg7x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753376180; c=relaxed/simple;
	bh=rA3d3kaQIb9v1p9v5mbR1it5GObbe671eQdfZ5daY7s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DV/xRyDHAMEgb+Dp28bOMq0Jm03QaWpFPW0S0J7xV+aAcy+VFKwbHK4AyG45Zt4jvrgfTt3lKSgeM43j0TA0QtWUP1zZTvU1qS0g2ZozkqPqwfcrA0e8w0dHptcFkGLdgVS6XqtPqONUq4MW1Og7G4s56KIv6B4b+q2eQ0mV/L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TIUt/9/U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753376176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYHoGtuRw7WdZoej8GrGyP1iXAhvqZMicdBMuztBHmE=;
	b=TIUt/9/UTGpmV5ZWyTdVntvnUMLYQHL1rKrRbDzVB4mkBiSfaExUDn0zw02lTm3uu3VlbT
	BzcsXUksRSJHlEtzqvfFrwZbBiFc3D5LxKUfyi9qcuvw+oxf4Az4Z486DRm8d5Eg6iTAPT
	Pvt8Uh/Ofy8tk4XpGbgawvk3JaRs4c4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-WuLQ5leNMAWaGLN5NIqnWQ-1; Thu, 24 Jul 2025 12:56:15 -0400
X-MC-Unique: WuLQ5leNMAWaGLN5NIqnWQ-1
X-Mimecast-MFC-AGG-ID: WuLQ5leNMAWaGLN5NIqnWQ_1753376174
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3df57df1eb3so1682885ab.2
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 09:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753376174; x=1753980974;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYHoGtuRw7WdZoej8GrGyP1iXAhvqZMicdBMuztBHmE=;
        b=YXJRIwqxSJn8jyD7IpH09u+LkIs5xRXry6+W97v5HLiJToQa8vqFa2lYoknVaQ4GVH
         vkzJ3ZnZEfxmfpb7QFI8FsEAUb6Q6Xq6mv8P+bEvzGyelVUjLZe/meY/J6z9HG4itH45
         XaY/5s4PJU9wmh27W1uhPL1Rw18rnpnPf71hQ70WFrRSvW8TtDh8wp2F+bPlcCYhGtQd
         fHbBrM6vinTyU+ORBpp77KJBT51sfbj8VyYqcv+siCXeYTiGjrVunFd3dwLLSu5xhkYL
         yZZbnNIwruuLWvVO2auLvyniH0tWo+rB9jyQeSpVqg7hr4POFnMx5ravAtBKhzonMej+
         Xh4w==
X-Forwarded-Encrypted: i=1; AJvYcCWU7cstroTsLDqFWKIzatM7VQ6I3wgW7bRD6WXD3cVvIJ5pdKy932BWVfS91v18//RLjxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXsQlFNlyrnH6X9KmUtu6NSFFSBtlfKyDwRil/RWMzn15NgTYN
	bbgAEl71RykZ/NSpBSmdzCtlaorq4JwoC6c4VaR/Or2WolzesH4GaOB2W+N14nFnl5o+SU0wwWn
	L0NGEtvNp2ftE14UiL2efYlJ9VcnXIoF8WZ/PGRPA8JOnUZfV7XqbTA==
X-Gm-Gg: ASbGncvftbHkhBV3cb7z9H+L4L3oZX4sOsiS93+NG9+hurp0IcujL8nbUNFrIu/XNkN
	R8ESPNRG5A0owP+Nj4vqaKho+APXyePCHbt1Yj6zG6r4mQ2Qnc6a9Er4BD4x8HsIaHgVycKHbJ9
	Glm6+R5VqCfpAUXSwXD7vZIB5rsdIaiPHwBfHvWjQAoddRcAFmkbp7nVpWE6Am3p0D3UTnJorPn
	zmy/33pSaoWjXk+KPqEduIm7PNJuJnuCIG9tSbJiL6nW2CdDzcc8nZuSW5DrAN5djUoLEGKj2t+
	F8uhEwdwd6GbZmnZAX9NBWYkalUuYoyWk6wSwPrZI04=
X-Received: by 2002:a05:6e02:1b0e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e336270ddfmr33899255ab.7.1753376174076;
        Thu, 24 Jul 2025 09:56:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeSdBI2UmvcdBRmfm8Po6mbiFyGezwzFECqf7+XyZFuhtgfyr90kLcOCgnM3T65hbDWKQVJw==
X-Received: by 2002:a05:6e02:1b0e:b0:3dd:ce1c:f1bc with SMTP id e9e14a558f8ab-3e336270ddfmr33899085ab.7.1753376173425;
        Thu, 24 Jul 2025 09:56:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508ae900b01sm523324173.0.2025.07.24.09.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 09:56:12 -0700 (PDT)
Date: Thu, 24 Jul 2025 10:56:08 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: farman@linux.ibm.com, akpm@linux-foundation.org, david@redhat.com,
 jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250724105608.73b05a24.alex.williamson@redhat.com>
In-Reply-To: <20250724024038.75436-1-lizhe.67@bytedance.com>
References: <f22a8b5b50a140339222bed77f4b670d9008f29b.camel@linux.ibm.com>
	<20250724024038.75436-1-lizhe.67@bytedance.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Jul 2025 10:40:38 +0800
lizhe.67@bytedance.com wrote:

> On Wed, 23 Jul 2025 10:41:34 -0400, farman@linux.ibm.com wrote:
>  
> > On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote:  
> > > On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> > >    
> > > > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:  
> > > > > From: Li Zhe <lizhe.67@bytedance.com>
> > > > > 
> > > > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > > > includes large folios, the function currently performs individual
> > > > > statistics counting operations for each page. This can lead to significant
> > > > > performance overheads, especially when dealing with large ranges of pages.
> > > > > Batch processing of statistical counting operations can effectively enhance
> > > > > performance.
> > > > > 
> > > > > In addition, the pages obtained through longterm GUP are neither invalid
> > > > > nor reserved. Therefore, we can reduce the overhead associated with some
> > > > > calls to function is_invalid_reserved_pfn().
> > > > > 
> > > > > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > > > > are as follows.
> > > > > 
> > > > > Base(v6.16-rc4):
> > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > > > > 
> > > > > With this patch:
> > > > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > > > ------- AVERAGE (MAP_POPULATE) --------
> > > > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > > > ------- AVERAGE (HUGETLBFS) --------
> > > > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > > > > 
> > > > > For large folio, we achieve an over 40% performance improvement.
> > > > > For small folios, the performance test results indicate a
> > > > > slight improvement.
> > > > > 
> > > > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > > ---
> > > > >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> > > > >  1 file changed, 71 insertions(+), 12 deletions(-)  
> > > > 
> > > > Hi,
> > > > 
> > > > Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> > > > next-20250717, and bisect points to this particular commit.
> > > > 
> > > > I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> > > > Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> > > > guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> > > > hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> > > > this if more doc is needed, but admit I haven't looked at this patch in any detail yet.
> > > > 
> > > > Thanks,
> > > > Eric
> > > > 
> > > > [  215.671885] ------------[ cut here ]------------
> > > > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> > > > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > > > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> > > > rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> > > > [vfio_iommu_type1])
> > > > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> > > > [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> > > > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> > > > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> > > > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
> > > >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> > > >           #000002482f7ee55a: af000000		mc	0,0  
> > > >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0  
> > > >            000002482f7ee562: 0707		bcr	0,%r7
> > > >            000002482f7ee564: 0707		bcr	0,%r7
> > > >            000002482f7ee566: 0707		bcr	0,%r7
> > > >            000002482f7ee568: 0707		bcr	0,%r7
> > > > [  215.672006] Call Trace:
> > > > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> > > > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> > > > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> > > > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> > > > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> > > > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> > > > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> > > > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> > > > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> > > > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > [  215.672058] Last Breaking-Event-Address:
> > > > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> > > > [  215.672062] ---[ end trace 0000000000000000 ]---
> > > > [  219.861940] ------------[ cut here ]------------
> > > > 
> > > > ...
> > > > 
> > > > [  241.164333] ------------[ cut here ]------------
> > > > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> > > > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> > > > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> > > > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> > > > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> > > > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> > > > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> > > > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> > > > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> > > > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> > > > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> > > > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> > > > [  241.164403] Tainted: [W]=WARN
> > > > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > > > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> > > > [vfio_iommu_type1])
> > > > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > > > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> > > > [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> > > > [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> > > > [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> > > > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
> > > >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> > > >           #000002482f7f1326: af000000		mc	0,0  
> > > >           >000002482f7f132a: 0707		bcr	0,%r7  
> > > >            000002482f7f132c: 0707		bcr	0,%r7
> > > >            000002482f7f132e: 0707		bcr	0,%r7
> > > >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
> > > >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> > > > [  241.164458] Call Trace:
> > > > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> > > > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> > > > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> > > > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> > > > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> > > > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> > > > [  241.164481] Last Breaking-Event-Address:
> > > > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> > > > [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops  
> > > 
> > > Thanks for the report. After a review of this commit, it appears that
> > > only the changes to vfio_find_vpfn() could plausibly account for the
> > > observed issue (I cannot be absolutely certain). Could you kindly test
> > > whether the issue persists after applying the following patch?  
> > 
> > Hi Zhe,
> > 
> > Thank you for the quick patch! I applied this and ran through a few cycles of the previously-
> > problematic tests, and things are holding up great.
> > 
> > It's probably a fixup to the commit here, but FWIW:
> > 
> > Tested-by: Eric Farman <farman@linux.ibm.com>
> > 
> > Thanks,
> > Eric  
> 
> Thank you for your feedback. Also I anticipate that this fix-up patch
> will leave the optimizations introduced in the original submission
> essentially unaffected.

Hi Zhe,

Thanks for the fix.  Could you please send this as a formal follow-on
fix path with Eric's Tested-by and documenting the issue?  Thanks,

Alex

> > > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > > --- a/drivers/vfio/vfio_iommu_type1.c
> > > +++ b/drivers/vfio/vfio_iommu_type1.c
> > > @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > >  
> > >  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > >  {
> > > -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > > +       return vfio_find_vpfn_range(dma, iova, iova + 1);
> > >  }  
> 


