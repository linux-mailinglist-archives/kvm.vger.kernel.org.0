Return-Path: <kvm+bounces-52532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3225FB06643
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 20:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA20F3AE464
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718A92BE057;
	Tue, 15 Jul 2025 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="coooAKnf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D61B042E
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 18:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752605213; cv=none; b=lAEsglnXFTJ4IGB5zeGz33L9dBzfJEk+kJcBzogDbf7XXYd8IkXE9HzYETNc4q+AAYcdawl90X7G5ZEEyE74f1/ybyNlCBPiaSbaL+vt7yrvr+819IJcPzfRY25wcmBsb4SKyTO2emOZCjFtXhISlJ5rBqhi+4DMMpvGf8eL6xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752605213; c=relaxed/simple;
	bh=GOJACDJXUMisUR1fmp0MKPRTPk/DYcVVDYSoJX5CKXY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Tnp8PEsjOgJrqMivO+qqafn6NfLbJXHdbU+YMhvRwYv9YHupCLPpS3Y278sPJBfLYZiviuuBaK8IoyZIhRuQFS3nQNRqHaeStTYuDw6PSf9MviNd1Q2hKrpfDig7p0T89/hoSEqNMqsy8Rli/MTWrBnNs9o3HnJc5h5GMKN6D0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=coooAKnf; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 56FIbeeC024291
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 11:46:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=KZjDm1wvJ23syPo4uo
	j8WYyxyPTvBVBLLxkdCEZKbuU=; b=coooAKnf1GO/VeaczDmMFPv4n1NoIg6C57
	de5wPPx1SlSreWGiNSRzSaAo2dY+7JKQCW+HtokF9Y2jMpug9T54JxIY+3/QGSa8
	4oGi6puQEjBsDQ+/DUgSDzwJCucNotjK84AIonYkFOm8Te6P6L3Pz4x8KfpEzQB5
	GQFwvpNtNZihffo4fDrRKCW3kej7BfR7cV+ryhRVB8ffpHoyOnod4tbD1vDhr2ro
	41tT5gZXwXeQWV8QNT2sNdHPC0YoFaxez6LME2CTITItPLAydFh9vUn8JiyuDpZg
	BPhDDVWdeciZe7ZsinpzZ1coSjQCaiMQLbslooOs2Ta1vHoCjdrA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 47whwjnefm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 11:46:50 -0700 (PDT)
Received: from twshared78382.04.prn6.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Tue, 15 Jul 2025 18:46:35 +0000
Received: by devbig1708.prn1.facebook.com (Postfix, from userid 544533)
	id 9DA2714A4DE5; Tue, 15 Jul 2025 11:46:22 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <paulmck@kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Date: Tue, 15 Jul 2025 11:46:22 -0700
Message-ID: <20250715184622.3561598-1-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDE3MyBTYWx0ZWRfX6DqeNB/Hgnpz UmJ1cZv/Hbbyxpy1Jp/VvIufWXphXRJiZfUnmVCQLoYSzaQ3p9gg/nAeongKgSbgGofReLjYobZ LYWJdF3fbfGmfgGOhT2QJIkYk7OlYcvk3KjHgk5t1dpf1/PqEvXBnWDmolHMfaqa+9qFX8AosiW
 qnx/oN/xRlRN21gK6clHTGRHjQnU3AH1haJDqqfZ71T/zSp7KGY4bsWLpplQGgsYiIN2UDSuqZ8 uGgcFiBdZLmUrhLcQ6fTKaAsJbd40p4govHssMWfwdt2vNxNRL7cW6D1U8VSUaCdI7umjaHQpcg 7mosJGmjP/Hrp7EZqlaD/Am9nKzM6ypPgmkjrQEHqENILrImGONY3GvrZJNoBO9CZAis9+W5TRl
 hXMPQ+kFTtmQdJsQzlA/pd9Hc4pcq2LXS/W97Qo0jkARplYDaJGcoiaWRP02zHpw1yp1L2nO
X-Proofpoint-GUID: qIVZ9IwXSpK_WAVcRBumjspvSTvIw_rL
X-Authority-Analysis: v=2.4 cv=SMtCVPvH c=1 sm=1 tr=0 ts=6876a21a cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=De36-Z_BrdwR9qEJ7zUA:9
X-Proofpoint-ORIG-GUID: qIVZ9IwXSpK_WAVcRBumjspvSTvIw_rL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-15_04,2025-07-15_02,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

A large DMA mapping request can loop through dma address pinning for
many pages. In cases where THP can not be used, the repeated vmf_insert_p=
fn can
be costly, so let the task reschedule as need to prevent CPU stalls. Fail=
ure to
do so has potential harmful side effects, like increased memory pressure
as unrelated rcu tasks are unable to make their reclaim callbacks and
result in OOM conditions.

 rcu: INFO: rcu_sched self-detected stall on CPU
 rcu:   36-....: (20999 ticks this GP) idle=3Db01c/1/0x4000000000000000 s=
oftirq=3D35839/35839 fqs=3D3538
 rcu:            hardirqs   softirqs   csw/system
 rcu:    number:        0        107            0
 rcu:   cputime:       50          0        10446   =3D=3D> 10556(ms)
 rcu:   (t=3D21075 jiffies g=3D377761 q=3D204059 ncpus=3D384)
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
v1->v2:

  Merged up to vfio/next

  Moved the cond_resched() to a more appropriate place within the
  loop, and added a comment about why it's there.

  Update to change log describing one of the consequences of not doing
  this.

 drivers/vfio/vfio_iommu_type1.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
index 1136d7ac6b597..ad599b1601711 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -647,6 +647,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *d=
ma, unsigned long vaddr,
=20
 	while (npage) {
 		if (!batch->size) {
+			/*
+			 * Large mappings may take a while to repeatedly refill
+			 * the batch, so conditionally relinquish the CPU when
+			 * needed to avoid stalls.
+			 */
+			cond_resched();
+
 			/* Empty batch, so refill it. */
 			ret =3D vaddr_get_pfns(mm, vaddr, npage, dma->prot,
 					     &pfn, batch);
--=20
2.47.1


