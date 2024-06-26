Return-Path: <kvm+bounces-20542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D43CA917F6C
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 13:18:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 036701C23709
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2BB181BB9;
	Wed, 26 Jun 2024 11:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KpUfueRC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9F4181335;
	Wed, 26 Jun 2024 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719400607; cv=none; b=b55cDv2SaZeNwJ9er7VEMPn/flTKo5EDpN3eKHmmMch9Juqe9FlNaEKTBBQ8NzUjdDkALqHnvMsU/j4bO1BQO3nnlBm2zKpVkc3Cji8ZCUXj9Vu3YLM7QX6CGINpCackxsvMjwYdoWDmvt4ut24RX4fg78knYwrImpdxAwXC4d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719400607; c=relaxed/simple;
	bh=FGKEpTleFBSSK7WUxdG/8JzLVsEa4P9Al0JqlCWeNms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QagmcUu30PBi/GTl8j8W1un9Cppo3/h6CXYPaik+6X4WmgwYASSdU23CtjsBvjm3Oa8PGoF5w8azODlomjIyYQwZEepZqCTMNK15EqMZbPL1BMOk5hIJbW0HAA4Xp7F6PwDXDlXQNny5pC+nVJzqqZFWBOcmD4F2hk/pzpK7g+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KpUfueRC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45QAx4P1014733;
	Wed, 26 Jun 2024 11:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:date:subject:mime-version:content-type
	:content-transfer-encoding:message-id:references:in-reply-to:to
	:cc; s=pp1; bh=CRbUUMxJyaC8a9NNtMcOFepASjt8GcUVVwxXCIDFCfA=; b=K
	pUfueRCBs54kLwuO7NCwNU6TIDg9yPuppEnqW32rBXYAYPEVVCaCP85PuQg3inyc
	lNp6xzUNzMrFYR8h0iuKTRSpSoZsr8T9SGQaXkCXb0px1EivXxAn6ScVVi0I2xaX
	KMV1WVHHBZkL58O/RjPW1yFNgCPGxjMgHFULhtKduP426kJJtZ75Y4eDM+wd9U7X
	DBPMDe3w+L/E+yATrozDgQ2RzMkJt3d8rBYJTSMGQ5fxpKOGhHtQ3lrJCRbdqipg
	QBgd4SYOPnUNUX2yAC0XeVzHpwQN+iIKfAgXqUoijc3WG6zQiutUaDjnbSqwvdFl
	yZOf/oBBB3mwCaHYNeYKA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400hq801ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:38 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45QBBoSm032658;
	Wed, 26 Jun 2024 11:16:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 400hq801gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45QApCpB018131;
	Wed, 26 Jun 2024 11:16:37 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xucb6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Jun 2024 11:16:37 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45QBGXqV26411660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Jun 2024 11:16:35 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D1C258043;
	Wed, 26 Jun 2024 11:16:33 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA72C5805F;
	Wed, 26 Jun 2024 11:16:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Jun 2024 11:16:30 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Wed, 26 Jun 2024 13:15:50 +0200
Subject: [PATCH v4 3/4] vfio/pci: Disable mmap() non-compliant BARs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-vfio_pci_mmap-v4-3-7f038870f022@linux.ibm.com>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
In-Reply-To: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1430;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=FGKEpTleFBSSK7WUxdG/8JzLVsEa4P9Al0JqlCWeNms=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGNKqf1SGnPmhwH/3DufOxBtPHKfP0Knnk/rYaMqjpbfw/
 ZnF/r8vd5SyMIhxMMiKKbIs6nL2W1cwxXRPUH8HzBxWJpAhDFycAjCRg7oMfzh/ztbq47pecvFg
 aZRrlbPApnyxA633Hvx02jkzdQ+PfREjw6a1fGkpnQ4Kc1bYmFm/VRbO2lgTtEhmsqpXh9kJg4J
 YfgA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5xPhy27Id4zsREc5JTQQScMMW9FJVpoF
X-Proofpoint-GUID: 9I-fN2YW-onVCe69b-p7MwxO01tNXvcx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-26_05,2024-06-25_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=774 impostorscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406260082

When VFIO_PCI_MMAP is enabled for s390 in a future commit and the ISM
device is passed-through to a KVM guest QEMU attempts to eagerly mmap()
its BAR. This fails because the 256 TiB large BAR does not fit in the
virtual map. Besides this issue mmap() of the ISM device's BAR is not
useful either as even a partial mapping won't be usable from user-space
without a vfio-pci variant driver. A previous commit ensures that pdev->
non_compliant_bars is set for ISM so use this to disallow mmap() with
the expecation that mmap() of non-compliant BARs is not advisable in the
general case either.

Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 987c7921affa..0e9d46575776 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -128,10 +128,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 		/*
 		 * The PCI core shouldn't set up a resource with a
-		 * type but zero size. But there may be bugs that
-		 * cause us to do that.
+		 * type but zero size or non-compliant BARs.
 		 */
-		if (!resource_size(res))
+		if (!resource_size(res) || vdev->pdev->non_compliant_bars)
 			goto no_mmap;
 
 		if (resource_size(res) >= PAGE_SIZE) {

-- 
2.40.1


