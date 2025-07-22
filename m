Return-Path: <kvm+bounces-53167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B834DB0E413
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 21:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99CB41894D9A
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 19:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D82284B4F;
	Tue, 22 Jul 2025 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dbWEyBdJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F269727FD48
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753212252; cv=none; b=cf0vGSr+fanRo9JPHgkNiAZbsM0+FAQi93KApAs01KW8WxL88DXl4yZtDF1rbWyIhJRAJO3cHfTcxNHUzYv0yZU2eNOFbZG/m7MPacEZTusHWL/rYxJl+5lslUPOVj1dixZqr8cWzQFg73CI0PdzAp6B7DOcwOd1TYZJQicTXSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753212252; c=relaxed/simple;
	bh=A32hbVnyJUL/EIxxvz8NZtumv2p18qbLzg216awHUCo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEVvyt8gvpDG6z3ZfDDTGcsgL/i3YO2qQMzEaJ9rRcSwLh+LYFtt4mSZQQd4vvTe+HnPt3Zt5y/Pnbyk8hkzMryWZGf0lVZJ5rmnE+YSIhtLyZfO5BZ0YHeUyiwUxeTb0UYRcvxLBvdpzuaC713HetVQxPFCyiD4aT5WYbPRbLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dbWEyBdJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753212247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VoPpnzfO/x9/yJX0rcftjTQw+19C2QQbHVAgxYrYBgE=;
	b=dbWEyBdJPD1JlnaK6oiP/WxaumEl6ftmeZLQLvKBfSEn5GVR5cvV33u9Mae9Ht5xv9t7Ce
	s5iFIt2FvXA6zQl8tLu9fKfAxYHqpqYj30u30zfyxJ4qtaf0KdoKvvryUhBkAvWPnDjbvW
	m+IFFtQ4KZ93xsKEScuqidOYAf13lEQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-B7CfRVjZMl-E5BjyxssqBw-1; Tue, 22 Jul 2025 15:24:06 -0400
X-MC-Unique: B7CfRVjZMl-E5BjyxssqBw-1
X-Mimecast-MFC-AGG-ID: B7CfRVjZMl-E5BjyxssqBw_1753212246
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ddc47aebc2so12707755ab.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 12:24:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753212245; x=1753817045;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VoPpnzfO/x9/yJX0rcftjTQw+19C2QQbHVAgxYrYBgE=;
        b=usM8oNKxKGP9y2z/8fwU7b/gUGmzHqKKFJXHKvBfbcJ/NBcaDLZBiZqjVMTPN2Hzk3
         4s1771dCWxL4rZLennunB1Zgg8LZXqb0S08c6AgrnWtaBQ7zgWRHelzSE/Q1oh/ZpDXF
         zPEY+nj6nFrcVVABvmB6WLy87q30G+YnJC52Q97EtuqQqouI89slK6F9L9JVTB7XYFQN
         gH86KWkMRACq4xNEpFOy2vn4ZVmhwR/0H37810VWCRNh8J06KU8a3SDke5GeH+q4vBDx
         1hxmCYuCFVelvfprwVWCVzK/+TI+RDy/lIVGB3Rhyq54HlweGLMlq/ljnNCesS3ReKvj
         cytQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfFVXOX3foMSG4NRHrSH8io31gzdPA9ncylBdJ6++6hfeVywNZKJsC3gwBLM1dVWu/hOY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHe1SlTI79Kbs/IUkwNdqq0LKJ2WtV3YsSAreoRR07S5ZlEZpX
	xq9OkK7NsEhcYtm0fZGm42w0AVu7DACiJB78LBfbGo0SMu/BveyjjoeOg67F/qS3qtzB6IwH71H
	4JUnM51k9B8vQrggwWTAcVb5FYomdvQjl5lpL90Dkqw24XORtqBI61w==
X-Gm-Gg: ASbGncvUg34jUNeKu43vPMMbUDBH35KyYehiP0/IpOAmVvcru+oug0P+Iv/WxQNtc46
	J85Tv/0o64bYc5aTiG4q9dg/rsg17Ch+njMxqyJnBmUO0SWdMPUxW8lKcCtDwjH6+wDZXqCDrjS
	/rzHa8EwuntKEv4XMA0iIFftalHQNa3NZBZVDUAbHo0b3TgTvNyS+xASfYlkIgDqvbTDfGS/wdX
	ZIu5wQ6zdRN2VwfdFXgSDdj0ImZ0M9AnreeL1h6g5lx0/VmV8XbnHqpsWJPCxM/hE/OW6w1idkq
	O89niOZEW79oUVwqseVXalba9vy7itGoHQIRtb2Oo2E=
X-Received: by 2002:a05:6e02:b4e:b0:3e2:b511:1257 with SMTP id e9e14a558f8ab-3e32fbe6d02mr1429605ab.1.1753212245308;
        Tue, 22 Jul 2025 12:24:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtVPfNQQZe8DOqCr9vtTkI2cNKOF9UOY8F0gy0NieHMIPzKntZTVJ6/MWE3j5uJcQHKrMd+Q==
X-Received: by 2002:a05:6e02:b4e:b0:3e2:b511:1257 with SMTP id e9e14a558f8ab-3e32fbe6d02mr1429355ab.1.1753212244681;
        Tue, 22 Jul 2025 12:24:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5084ca61845sm2706151173.126.2025.07.22.12.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 12:24:03 -0700 (PDT)
Date: Tue, 22 Jul 2025 13:23:58 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: lizhe.67@bytedance.com, akpm@linux-foundation.org, david@redhat.com,
 jgg@ziepe.ca, peterx@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Message-ID: <20250722132358.5ab61377.alex.williamson@redhat.com>
In-Reply-To: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
	<20250710085355.54208-3-lizhe.67@bytedance.com>
	<1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 22 Jul 2025 12:32:59 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > When vfio_pin_pages_remote() is called with a range of addresses that
> > includes large folios, the function currently performs individual
> > statistics counting operations for each page. This can lead to significant
> > performance overheads, especially when dealing with large ranges of pages.
> > Batch processing of statistical counting operations can effectively enhance
> > performance.
> > 
> > In addition, the pages obtained through longterm GUP are neither invalid
> > nor reserved. Therefore, we can reduce the overhead associated with some
> > calls to function is_invalid_reserved_pfn().
> > 
> > The performance test results for completing the 16G VFIO IOMMU DMA mapping
> > are as follows.
> > 
> > Base(v6.16-rc4):
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > 
> > With this patch:
> > ------- AVERAGE (MADV_HUGEPAGE) --------
> > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > ------- AVERAGE (MAP_POPULATE) --------
> > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > ------- AVERAGE (HUGETLBFS) --------
> > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > 
> > For large folio, we achieve an over 40% performance improvement.
> > For small folios, the performance test results indicate a
> > slight improvement.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
> >  1 file changed, 71 insertions(+), 12 deletions(-)  
> 
> Hi,
> 
> Our CI started flagging some crashes running vfio-ccw regressions on the -next kernel beginning with
> next-20250717, and bisect points to this particular commit.
> 
> I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not something else lurking.
> Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (after starting/stopping
> guests with an mdev attached), before eventually triggering a BUG() in vfio_dma_do_unmap() running a
> hotplug test. I've attached an example of a WARNING before the eventual BUG below. I can help debug
> this if more doc is needed, but admit I haven't looked at this patch in any detail yet.

Thanks for the report.  I'm out of the office this week, but I'll keep
an eye on how this progresses and we can drop it if we haven't come to
a resolution in the next few days.  Thanks,

Alex


> [  215.671885] ------------[ cut here ]------------
> [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
> vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
> rc7-00005-g4ff8295d8d61 #79 NONE 
> [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
> [vfio_iommu_type1])
> [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
> [  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
> [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
> [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
> [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
>            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
>           #000002482f7ee55a: af000000		mc	0,0
>           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0  
>            000002482f7ee562: 0707		bcr	0,%r7
>            000002482f7ee564: 0707		bcr	0,%r7
>            000002482f7ee566: 0707		bcr	0,%r7
>            000002482f7ee568: 0707		bcr	0,%r7
> [  215.672006] Call Trace:
> [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1] 
> [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1] 
> [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio] 
> [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio] 
> [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0 
> [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0 
> [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0 
> [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0 
> [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30 
> [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> [  215.672058] Last Breaking-Event-Address:
> [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
> [  215.672062] ---[ end trace 0000000000000000 ]---
> [  219.861940] ------------[ cut here ]------------
> 
> ...
> 
> [  241.164333] ------------[ cut here ]------------
> [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> [  241.164358] monitor event: 0040 ilc:2 [#1]SMP 
> [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
> vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
> cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
> s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
> vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
> zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
> sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
> configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
> [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W  
> 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE 
> [  241.164403] Tainted: [W]=WARN
> [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
> [vfio_iommu_type1])
> [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
> [  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
> [  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
> [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
> [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
>            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
>           #000002482f7f1326: af000000		mc	0,0
>           >000002482f7f132a: 0707		bcr	0,%r7  
>            000002482f7f132c: 0707		bcr	0,%r7
>            000002482f7f132e: 0707		bcr	0,%r7
>            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
>            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> [  241.164458] Call Trace:
> [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1] 
> [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1] 
> [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70 
> [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100 
> [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340 
> [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90 
> [  241.164481] Last Breaking-Event-Address:
> [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
> [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops
> 
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index 1136d7ac6b59..6909275e46c2 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iommu *iommu)
> >  /*
> >   * Helper Functions for host iova-pfn list
> >   */
> > -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +
> > +/*
> > + * Find the highest vfio_pfn that overlapping the range
> > + * [iova_start, iova_end) in rb tree.
> > + */
> > +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> > +		dma_addr_t iova_start, dma_addr_t iova_end)
> >  {
> >  	struct vfio_pfn *vpfn;
> >  	struct rb_node *node = dma->pfn_list.rb_node;
> > @@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	while (node) {
> >  		vpfn = rb_entry(node, struct vfio_pfn, node);
> >  
> > -		if (iova < vpfn->iova)
> > +		if (iova_end <= vpfn->iova)
> >  			node = node->rb_left;
> > -		else if (iova > vpfn->iova)
> > +		else if (iova_start > vpfn->iova)
> >  			node = node->rb_right;
> >  		else
> >  			return vpfn;
> > @@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> >  	return NULL;
> >  }
> >  
> > +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
> > +{
> > +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> > +}
> > +
> >  static void vfio_link_pfn(struct vfio_dma *dma,
> >  			  struct vfio_pfn *new)
> >  {
> > @@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
> >  	return ret;
> >  }
> >  
> > +
> > +static long vpfn_pages(struct vfio_dma *dma,
> > +		dma_addr_t iova_start, long nr_pages)
> > +{
> > +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> > +	struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
> > +	long ret = 1;
> > +	struct vfio_pfn *vpfn;
> > +	struct rb_node *prev;
> > +	struct rb_node *next;
> > +
> > +	if (likely(!top))
> > +		return 0;
> > +
> > +	prev = next = &top->node;
> > +
> > +	while ((prev = rb_prev(prev))) {
> > +		vpfn = rb_entry(prev, struct vfio_pfn, node);
> > +		if (vpfn->iova < iova_start)
> > +			break;
> > +		ret++;
> > +	}
> > +
> > +	while ((next = rb_next(next))) {
> > +		vpfn = rb_entry(next, struct vfio_pfn, node);
> > +		if (vpfn->iova >= iova_end)
> > +			break;
> > +		ret++;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Attempt to pin pages.  We really don't want to track all the pfns and
> >   * the iommu can only map chunks of consecutive pfns anyway, so get the
> > @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> >  		 * and rsvd here, and therefore continues to use the batch.
> >  		 */
> >  		while (true) {
> > +			long nr_pages, acct_pages = 0;
> > +
> >  			if (pfn != *pfn_base + pinned ||
> >  			    rsvd != is_invalid_reserved_pfn(pfn))
> >  				goto out;
> >  
> > +			/*
> > +			 * Using GUP with the FOLL_LONGTERM in
> > +			 * vaddr_get_pfns() will not return invalid
> > +			 * or reserved pages.
> > +			 */
> > +			nr_pages = num_pages_contiguous(
> > +					&batch->pages[batch->offset],
> > +					batch->size);
> > +			if (!rsvd) {
> > +				acct_pages = nr_pages;
> > +				acct_pages -= vpfn_pages(dma, iova, nr_pages);
> > +			}
> > +
> >  			/*
> >  			 * Reserved pages aren't counted against the user,
> >  			 * externally pinned pages are already counted against
> >  			 * the user.
> >  			 */
> > -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> > +			if (acct_pages) {
> >  				if (!dma->lock_cap &&
> > -				    mm->locked_vm + lock_acct + 1 > limit) {
> > +				     mm->locked_vm + lock_acct + acct_pages > limit) {
> >  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
> >  						__func__, limit << PAGE_SHIFT);
> >  					ret = -ENOMEM;
> >  					goto unpin_out;
> >  				}
> > -				lock_acct++;
> > +				lock_acct += acct_pages;
> >  			}
> >  
> > -			pinned++;
> > -			npage--;
> > -			vaddr += PAGE_SIZE;
> > -			iova += PAGE_SIZE;
> > -			batch->offset++;
> > -			batch->size--;
> > +			pinned += nr_pages;
> > +			npage -= nr_pages;
> > +			vaddr += PAGE_SIZE * nr_pages;
> > +			iova += PAGE_SIZE * nr_pages;
> > +			batch->offset += nr_pages;
> > +			batch->size -= nr_pages;
> >  
> >  			if (!batch->size)
> >  				break;  
> 


