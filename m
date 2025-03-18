Return-Path: <kvm+bounces-41416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 558E0A67AFA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740A24234C9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:30:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6DE212D6B;
	Tue, 18 Mar 2025 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nZs4DP7H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4081113C908;
	Tue, 18 Mar 2025 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742318984; cv=none; b=Kxb/awfmiWztAeZG/VfxF5zHfNSwN8zgm9CB1xbLDMIjcjmzCUoCMXJtzaazqi76duFQIJ+s7jojo66uMsjUzZaidJqb3HKsVYbaXXj29fqpNO9WePUkCCvWoMpi6FxjvEPawQ0Drlzl3Y7OL5Fh2c05R0N5v9iYWCZFGpMEwVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742318984; c=relaxed/simple;
	bh=l+3cKI1Pbb9aYDDHtKWGxSIx2x/V6YyBxyEjqF+ZFk0=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=lJr9H8KxPpTFgky3uPQietm/aFUOaeZjJdA5bTvWvAIXc3k4FICb58OpJEVXPeTFuMj1o5y8aYFlsiznSM+F4pCDQqYqY7TRhpy/ChHIMp5I6iOS88sC3lnl55Lwwt+mmW4w95YrvnY4v+BJBxHN2Y72qvRbytDN1MzJZr2CTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nZs4DP7H; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52IH0CmN011598;
	Tue, 18 Mar 2025 17:29:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=9ehkTcd0d43Pw/Xfl6py7gyh3x8O
	mdwtD261Y4DK4V8=; b=nZs4DP7HD/JYIUdO4l3LuAjn0J8SbQas17+w6+dmDR42
	u06rMHFb69K0pWq10yzAFf7DyeZIOlotlELcuGxGjEDLrgBOMmtzREQ5xAjwZGcA
	tLKPWw8/PbMzk4GIyAOkAPqexvAjbqJGisMwyd+bS3mu61t1anmm1XcTjB4Eg86L
	Wtbx/8S/MKtWhdfYi5GnXlH/VRE011GawCHuNJS/wqUOsnGEeE6md47ZuLJQIvZq
	nlOmdlpYoMqzkyW1d6xvi/pyyq+9GidPsoa7WOSukkPyUztNDdSu2AiTWU0wrYAw
	lM72HMqT8v5uqh6Rq20dtIErD60Dpng/yUgWopoATQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45eu55w7yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 17:29:28 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IH0XNh031974;
	Tue, 18 Mar 2025 17:29:28 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvtdap1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 17:29:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IHTOOF19202428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 17:29:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5332320043;
	Tue, 18 Mar 2025 17:29:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95BA120040;
	Tue, 18 Mar 2025 17:29:22 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.137])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 17:29:22 +0000 (GMT)
Subject: [PATCH] vfio: pci: Advertise INTx only if LINE is connected
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: alex.williamson@redhat.com, jgg@ziepe.ca, kevin.tian@intel.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, yi.l.liu@intel.com,
        Yunxiang.Li@amd.com, pstanner@redhat.com, maddy@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, sbhat@linux.ibm.com
Date: Tue, 18 Mar 2025 17:29:21 +0000
Message-ID: <174231895238.2295.12586708771396482526.stgit@linux.ibm.com>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GDDIVZyl4q0rZUaHaDFiqrzscpzhIBL1
X-Proofpoint-GUID: GDDIVZyl4q0rZUaHaDFiqrzscpzhIBL1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180127

On POWER systems, when the device is behind the io expander,
not all PCI slots would have the PCI_INTERRUPT_LINE connected.
The firmware assigns a valid PCI_INTERRUPT_PIN though. In such
configuration, the irq_info ioctl currently advertizes the
irq count as 1 as the PCI_INTERRUPT_PIN is valid.

The patch adds the additional check[1] if the irq is assigned
for the PIN which is done iff the LINE is connected.

[1]: https://lore.kernel.org/qemu-devel/20250131150201.048aa3bf.alex.williamson@redhat.com/

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Suggested-By: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 586e49efb81b..4ce70f05b4a8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -734,6 +734,10 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return 0;
 
 		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
+#if IS_ENABLED(CONFIG_PPC64)
+		if (!vdev->pdev->irq)
+			pin = 0;
+#endif
 
 		return pin ? 1 : 0;
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {



