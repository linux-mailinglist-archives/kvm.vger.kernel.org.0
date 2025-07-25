Return-Path: <kvm+bounces-53433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 095CAB118CA
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 09:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CF491715E1
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 07:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABC029116E;
	Fri, 25 Jul 2025 07:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QWUSCpTM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D93F25B1FF
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753426880; cv=none; b=LqsWg1gvWlFqkTd+dmMnMJ66IVFHUUweqQZLVsfcOpEY3nk2sGdY/LBPJALggGOaxc2nVxnaCfFdJYp2WIlIDl+7BVTSdVmUIW1th32Tsjj1tAup2w+D1WyzLaKe/NHgrbVoh/gFAn6PmduGAqO2dfd3E1z11hJ0N0CYuqPTs/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753426880; c=relaxed/simple;
	bh=glUOTthuBg0Mj75i5FhFtm+1COvY/f2AwzlZB6LD8Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiXvnmwWedv3B2hqIfaaShPAOsvUIiH+d+vLb/6RiwWVJafJIH09YotFGifVVw9mB4p1EYkW8VJLmlf/hULNuPB9xiRFVTsQ1XuaFLYNOa82N8zm1OcWa6Q4k7Bj3BBhj2+tSNzLbLSeGAOs8CMGZ7TYcwFOg9u2piqn3M+ji0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QWUSCpTM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235f9e87f78so20295415ad.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 00:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753426878; x=1754031678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uC8VgqJ1hxS3HBaKIpxr+jz/YhcoEyBsA0EuNdN/npA=;
        b=QWUSCpTM44v7Hv8DffmDdaPGZ/9kP6d6QUcNVu2DN05+K1u5vDMCQl0JBeXclt6qAS
         CLUo1u1+8zhDxG6FamZC8Kz+qoeIz7SAupc+m7XoipEj7YcWmw+JpSgWGaLMhPxwU/o9
         4r/o30vTZMaNRx6+f83vT+h9eTr0mZOtLAGjyAUnTsTFm1FdTpQgSzCGAhynuMCQjmr0
         oDh3bIEQFNZ5QICD37TwUP5jFcTgeaVRATMn43vslfmlRYjYhjqG0gxLylwTNByf9hPk
         nisuCWQHipVtDPpU4DaPXQl9fnGwGK5QArVjGlxR1Y43HdZ+ubq6A31JPZf2kKxJ7jwn
         6V7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753426878; x=1754031678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uC8VgqJ1hxS3HBaKIpxr+jz/YhcoEyBsA0EuNdN/npA=;
        b=DcJgs4SOOtQn2A0zRytI0hb7+CxM06cSWMqqf2YO/NqVsJt2PAG8Zgdc8eYHHBN1Mo
         UudVIxuRxFg27hG/FV4e/1M5xCywpM5Yy7mwK6eRYcCbXgBkF+gTednStNaCjuO0H+jT
         6vY3eYS1K3B0+mJLplSXByGgKvHqwmI/ENl9bSqI+ackvxCiLeDVvHO0lVM/W6kUOISj
         Qb+dpg0pH6ElbmgsgLrXf44HT21lowQMb0WPo/DlGAncTAsuxHReE6ex+NUKsAxF6ZB9
         oqWbVNVxTprdBFoVctIBkpjAzbkPUB+E1r19Sh6lWZbZ1NYsjClKa/h1LbwylTFIwqSt
         SFvA==
X-Forwarded-Encrypted: i=1; AJvYcCXZINbjW43fGhHdD+RVcDCqoeg/Zf9gnSzH3ndwksoA+qNUEOa7SLSpse97HT1bRKTeu+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgXEhAYvXKFC9rqVp/S3GQyAX0MJ4Ft/POVlxJZRmRkj4znakt
	m9xdfk5lecf2TlvJvjGI4PTTbOAhPxq0aECAj80zpd2fGcS2ICiOSJL+Ip18dYEr32k=
X-Gm-Gg: ASbGncsB5Oiot+1/K/lAszzUDWiwtpXyciAYXLJaXJ1O/xR8WCaX6Cm7P7KYF8Nof0X
	WvBIQMRd4NJS7o/DUe369saL9klyhfj4MmK7Oe4X+fu3IPu5IcRBBzp78Y3BYtBjI9oeGnSGc0g
	afdnjqmavXcbs7Hvevdz2As+of8k4rZTgAXOWZsFYTxD+MKS6R0XueyD81DS3lJ3ilRo6I7hTWN
	H4cCO9DdUQtPuPt1pedqMuMGMk5iHRakkU+6JPUAbb3nYlnvDpSoNZfCxlENxWusHYmQRdbXb8a
	lacV1jrBqFeFqgfS9MXVYlDJLX8H0dmpEiBnthsbaZZr/XcTLr0UwcvbJUH393Lq9wiaho1e0q5
	vf2x554WXJh8lXxuaNqpysnXUNCbaQRJv+Jfy7JO4Oqxy0UdrYuc=
X-Google-Smtp-Source: AGHT+IHH6bvAYxaayBdPgxZosRavvzvKeFt758W686KNMaUVJWeBq1sUpAZ0vLh2LG58pdoikFczFQ==
X-Received: by 2002:a17:902:e801:b0:234:bef7:e227 with SMTP id d9443c01a7336-23fb302672cmr12010825ad.18.1753426878039;
        Fri, 25 Jul 2025 00:01:18 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa47846c7sm30252765ad.72.2025.07.25.00.01.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 25 Jul 2025 00:01:17 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	farman@linux.ibm.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: [FIXUP] vfio/type1: correct logic of vfio_find_vpfn()
Date: Fri, 25 Jul 2025 15:00:54 +0800
Message-ID: <20250725070054.66497-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724105608.73b05a24.alex.williamson@redhat.com>
References: <20250724105608.73b05a24.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

In commit 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()"),
we changes vfio_find_vpfn() from exact-iova matching to the interval
[iova, iova + PAGE_SIZE), which may cause the following problem.

[  215.671885] ------------[ cut here ]------------
[  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.c:1204
vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
[  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
[  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: loaded Not tainted 6.16.0-
rc7-00005-g4ff8295d8d61 #79 NONE
[  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
[  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dma+0xde/0xf0
[vfio_iommu_type1])
[  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c80 0000000092ffad20
[  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c80 000000008f3b1cc8
[  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c80 0000000092ffad20
[  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be0 000001c8b36c3ba8
[  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,00000248af72dee0
           000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
          #000002482f7ee55a: af000000		mc	0,0
          >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
           000002482f7ee562: 0707		bcr	0,%r7
           000002482f7ee564: 0707		bcr	0,%r7
           000002482f7ee566: 0707		bcr	0,%r7
           000002482f7ee568: 0707		bcr	0,%r7
[  215.672006] Call Trace:
[  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_type1]
[  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x5f0 [vfio_iommu_type1]
[  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180 [vfio]
[  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfio]
[  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0
[  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0
[  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0
[  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0
[  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30
[  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340
[  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90
[  215.672058] Last Breaking-Event-Address:
[  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_type1]
[  215.672062] ---[ end trace 0000000000000000 ]---
[  219.861940] ------------[ cut here ]------------

...

[  241.164333] ------------[ cut here ]------------
[  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
[  241.164358] monitor event: 0040 ilc:2 [#1]SMP
[  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_common vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath loop nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s390 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey autofs4
[  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: loaded Tainted: G        W
6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE
[  241.164403] Tainted: [W]=WARN
[  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
[  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_unmap+0x4aa/0x4b0
[vfio_iommu_type1])
[  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 0000000040000000 000000008cfdcb40
[  241.164418]            0000000000001001 0000000000000001 0000000000000000 0000000040000000
[  241.164419]            0000000000000000 0000000000000000 00000001fbe7f140 000000008cfdcb40
[  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c0 000001c8b4177cd0
[  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
           000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
          #000002482f7f1326: af000000		mc	0,0
          >000002482f7f132a: 0707		bcr	0,%r7
           000002482f7f132c: 0707		bcr	0,%r7
           000002482f7f132e: 0707		bcr	0,%r7
           000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
           000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
[  241.164458] Call Trace:
[  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_iommu_type1]
[  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vfio_iommu_type1]
[  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70
[  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100
[  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340
[  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90
[  241.164481] Last Breaking-Event-Address:
[  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_iommu_type1]
[  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops

This patch reverts vfio_find_vpfn() to exact iova matching, thereby
resolving the issue.

Fixes: 492d1e9f0df7 ("vfio/type1: optimize vfio_pin_pages_remote()")
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 6909275e46c2..827e0987fab5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
 
 static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t iova)
 {
-	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
+	return vfio_find_vpfn_range(dma, iova, iova + 1);
 }
 
 static void vfio_link_pfn(struct vfio_dma *dma,
-- 
2.20.1


