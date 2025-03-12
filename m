Return-Path: <kvm+bounces-40861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEDBA5E7B2
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 23:53:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FB5C1899BE7
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DF21F12EA;
	Wed, 12 Mar 2025 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WMuzWzyh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA35B1F03E4
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 22:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741819984; cv=none; b=MPJd3d5dJZ8w7t2tAs/uzcQIDa51A50YRwD+bPy0S2de9dD+uOBanmrgPCNbKiw4suV7fmubGZYKPsnhqJ4tuFCdNHcZcUc7ynKITUEGK9XYAtRmPRCiniHs9icQs7qNqu4HjPmz9KN7C1C6JbpRl4syD3114w1RZXcAg2XjRd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741819984; c=relaxed/simple;
	bh=hoZhiLRaT03dibrPq0Yn3WJWMlO59LD/uOjv0wF9noE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KmAs8DJ7UqCQvMlwbnRekyINm6blIEAZbeIBS6TJINggENE7zVHYDJKstoOlnC1DhHzRtlToGSH++/1UMpMrv+SOuGGlcvwG9GwThYPnn/1bmZHTqObwsEuR++mAzOurAvoupYf1ewbwRR0lAqsUvDjJtoy7QJoFOZ40Xgm1f78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WMuzWzyh; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52CMBZDg016338
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 15:53:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=Kl7hkD5KMfAcTnkDQa
	3RazR6pgojSxqrZR2wzVHhiQ0=; b=WMuzWzyhKUaaVcIycvDdMYT9v+5dCOlgUQ
	cBVNSnVBD2Ivh1VYUOTNxpTpW3/gaG70wDY2tyTKJD0KSjIVslm9OZoj3tqe6YmR
	MOUMqLKdfXPcKl642ijwkxGJ+LEoS4A7B0ba9XylRB5sa3k/sRc0yXzZZyD1K340
	+g4wDYWHFgJQeqlmtvLQwrbt5T3YfXapF6bitzpKP54PmSLzb7TYEFaqvtvqic+a
	oqSfoTy5z7ExqYjdSFe41PmNprPpZWzVYYgWW2B/EuQbpBBjKJlsWShOUBvosRUL
	sXnlVN6SruaejSmQPjFa21+fnCSzwhzQSy0FEdY787uqfH/VPhQg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45bccqkxud-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 15:53:01 -0700 (PDT)
Received: from twshared40462.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Mar 2025 22:53:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 561091905B414; Wed, 12 Mar 2025 15:52:57 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] vfio/type1: conditional rescheduling while pinning
Date: Wed, 12 Mar 2025 15:52:55 -0700
Message-ID: <20250312225255.617869-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qBZDEUkIjl_YJwOHb-5d7Pi6ScjHdM1N
X-Proofpoint-ORIG-GUID: qBZDEUkIjl_YJwOHb-5d7Pi6ScjHdM1N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_06,2025-03-11_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

A large DMA mapping request can loop through dma address pinning for
many pages. The repeated vmf_insert_pfn can be costly, so let the task
reschedule as need to prevent CPU stalls.

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu: 	36-....: (20999 ticks this GP) idle=3Db01c/1/0x4000000000000000 so=
ftirq=3D35839/35839 fqs=3D3538
 rcu: 	         hardirqs   softirqs   csw/system
 rcu: 	 number:        0        107            0
 rcu: 	cputime:       50          0        10446   =3D=3D> 10556(ms)
 rcu: 	(t=3D21075 jiffies g=3D377761 q=3D204059 ncpus=3D384)
...
  <TASK>
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? walk_system_ram_range+0x63/0x120
  ? walk_system_ram_range+0x46/0x120
  ? pgprot_writethrough+0x20/0x20
  lookup_memtype+0x67/0xf0
  track_pfn_insert+0x20/0x40
  vmf_insert_pfn_prot+0x88/0x140
  vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
  __do_fault+0x28/0x1b0
  handle_mm_fault+0xef1/0x2560
  fixup_user_fault+0xf5/0x270
  vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
  vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
  vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
  ? futex_wake+0x1c1/0x260
  x64_sys_call+0x234/0x17a0
  do_syscall_64+0x63/0x130
  ? exc_page_fault+0x63/0x130
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
index 50ebc9593c9d7..9ad5fcc2de7c7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dm=
a, unsigned long vaddr,
=20
 		if (unlikely(disable_hugepages))
 			break;
+		cond_resched();
 	}
=20
 out:
--=20
2.47.1


