Return-Path: <kvm+bounces-53183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E6FB0EB77
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 09:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC2DF1C828E6
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 07:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218132727E6;
	Wed, 23 Jul 2025 07:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="N071rKcL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D7A2343C2
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 07:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753254569; cv=none; b=jK/mdtcZwVS8i9mSqxMYWFa0Qt7heXBIqR8GT7Oc+3U/HgNKhPk3296AfInKzeg07qtlzFn7boSL0rhI4ubAPXBfXaocXLdsasB8udBST1e4kPM9R+hvIFwrOLHLttUVaIn1xO2gJenQhuVwgKeEatgobmX404j+r5kOsNL7LjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753254569; c=relaxed/simple;
	bh=t/Rs/AVdkhaJAqkVjMpydIq/q0lc2Gd++EoaQpby8/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuAJRUUKwcFo0I1Uf9DtVrGkcFPhgyvQe5YQUEjGcuQ0Ctb7bdoztg1PHt9HZ1Taps8C5SLZCjgzKs+330LtWOB+pQwqqNFxC7SEFKihcrlMy5pAh5GU7TA1bXQeqbpO9tihAJwUyFYuk3Uz8DSnMf4Wu02/vyPsrXG3ctscjF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=N071rKcL; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b31c84b8052so6980311a12.1
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 00:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753254565; x=1753859365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3xySD9i0zBLuoTU9OsQHvoeq1mQLETgpejNnwDrr/Ak=;
        b=N071rKcLKk7LIWmysDAGt32WP6muq6vz0qz7/dXjNW1x6ji6HxW1RR1pPzeT52R6+v
         Q80XWslOCq6bLbhZ0Cp6/L9LOiG8D4e2GgULCKqUaFFQhcExqdb8ZlsPIAU4KGw6ob05
         SDzJMME02Ydo29V2OQAAkdzCRIRIb3y3qGxu17sCXjXZtgsceljfmfrMejSpxFz7Fvkv
         dehOjBelb5dBWbT63TRhwFYZIbWxLgID2JhPG7O72ZhqQUQPqxk1Lmu7pRcBOIOuIh37
         3/cp7UCaNS/4wbwSsKogAxNlHFyDnmE6wND41ktWVQJM7LDipqwZioR+42GzD4vrr95q
         /UTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753254565; x=1753859365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xySD9i0zBLuoTU9OsQHvoeq1mQLETgpejNnwDrr/Ak=;
        b=SFmzEIZztnS4YmPquqWONaGk+yEwrPrqwwgyhCb/BBb2f68T2IrLdYY8jRUjVvi7/v
         OmMPSAS2Qw9tVKUqU/EpI6YKQ1oYgvjM4PrASFGCaRMDUrx/Opt//OwYNx5L+VtOkyM0
         HNu+k49zBdslUf4u7I8E0KERPqG+Hm9WqnZO2tftAhA64kkzSr5wBSRtrHoOIjd5Deu3
         UokQtfsLo0P2Iset+lW4pFiv0NxSvEjHhQszte7HpJAscFksVF8viQXrVpbCRmuvfeQm
         VKkQKIyuyjH7T27J+C+appgZMf+6kTWPOvY5b3GDMCADNzYRBsa5YBwS2Z2WcJvR6aaR
         hc5w==
X-Forwarded-Encrypted: i=1; AJvYcCXyiiykgkGEyLKLwsl3hs7C3nK872mLWfXRcReJi1HlJviyaTz7AZY5p5HFPJpdNWUMToc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwguxcBMmYUN0CmJKhj2xm91M4QX6/pmQ6C0UzSTpnxU3GjjNjs
	xXUs4FKjEso96ni6ElGoS9vX0GjuSowqMQHwhWlGk2PeDhq3HpWAxATEqRrtwN/60Vg=
X-Gm-Gg: ASbGnctaMuYgk2cBlp1V7ROXelgf3r+SJ1NGnGH/tZQMc8eyHHUBCthlET2/KZ4Xxhb
	FCfH58PpkBQqr1cQMm3ZdvCRNTktyE5qVn2SD6baPlZbySCNRY86xHyS/rMV0JTHo85OsJ2hlNl
	Z55SoRU30V9Q+Gr0ScL/U3pCU/9Y4p943pBmDc4jrsmCHNS9TOuFRo+jW9wH6L5NzvapZdeuzme
	+zoH2lmULxaOR9uP+7+MZ798vCDg3h0gu4z3l8E+WxlnFZ+BD81TwyaQj10458vC/79M63jc7Nm
	j9YNRDssiVQAEQr4Ljb/JBHzPcUzoXRRpuSsxL4OlGOlVFsqqIUPOnQA+CzT1002LlbPy5zHFSL
	831y8QaEeQXCw6j/VgsHOAje2YhIV8vSghFX3c4yGrAsd0aC4wQ==
X-Google-Smtp-Source: AGHT+IHL72T+VBVk7DX9rybYzc3VQsWLM+dttqmKHB3AfYHJ8PTIIAzerLdGDE0eCtPQQd7V723y3g==
X-Received: by 2002:a05:6a20:cd91:b0:21f:5598:4c2c with SMTP id adf61e73a8af0-23d49032907mr3134107637.13.1753254564948;
        Wed, 23 Jul 2025 00:09:24 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff99ef4sm8307165a12.61.2025.07.23.00.09.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Jul 2025 00:09:24 -0700 (PDT)
From: lizhe.67@bytedance.com
To: farman@linux.ibm.com
Cc: akpm@linux-foundation.org,
	alex.williamson@redhat.com,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
Date: Wed, 23 Jul 2025 15:09:17 +0800
Message-ID: <20250723070917.87657-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
References: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
 
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
> 
> Thanks,
> Eric
> 
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

Thanks for the report. After a review of this commit, it appears that
only the changes to vfio_find_vpfn() could plausibly account for the
observed issue (I cannot be absolutely certain). Could you kindly test
whether the issue persists after applying the following patch?

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
 
 static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 {
-       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+       return vfio_find_vpfn_range(dma, iova, iova + 1);
 }

Thanks,
Zhe

