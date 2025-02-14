Return-Path: <kvm+bounces-38168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 257B6A35EAB
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66A4118953DE
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B53C265CD6;
	Fri, 14 Feb 2025 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rotjHjcz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BC123A992;
	Fri, 14 Feb 2025 13:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739538691; cv=none; b=eu7M4Gw9e9BmAPYhUP2lX/xrflv8tb1oHlyi1trDY7c74srWB6YVT2QDIGYj0XWsIxSI0pVRvWtGfOVDRWJoQlzTf/W5ZjOQq+RoJVeYT0BM762+TPzV7K1XV+Q33BTo8wVY2ohvcCY2fTJQ7VbCMGt1+XFh7y2TdNdgmfxfSTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739538691; c=relaxed/simple;
	bh=oZzm7bjnXY99I6Zc3jVr5s2rPCWnBBpDlteWHQeKPAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WGrnl+CkhgFO9RM8HcDx6gt8evUU8aqGwZyeC/FUU6kTIUUKhMdFcFtsHFOb2yFG/Vo2yx1wb+69uiLWEiRPqTfwRBZaFi3P4aei015Dd7hwy7qMj09R5HR/xn/lx8koRUBM3ZeGB1AUkrgT5tKUkEfNZ8iTOJ5bj4ZomN/9xjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rotjHjcz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51E44kDs015865;
	Fri, 14 Feb 2025 13:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iQNQDA
	TVZJVA7sMUS+nMqNiPw40LRstanI4kXZIak5Y=; b=rotjHjcztgpss0h9YnYueE
	fH2y9zIuCZGV/2X4lQySlVSw9Uw9MUzZxhtUW/J6wWPWVGEbqCKTU1tyEHFBOmNw
	RpGLCayrLEGrVMqA8RfGS6slP2Qf28tD9ORr6tBL2tf5lboa4+Tup0l1L0Z0fslG
	ceDoKGdLHXmhb5gWlYm3hTwWOnAPxRjS82N/vZDqv2j/wLxwfPBl1z5prePxggL3
	ieNm5pG+dSefWzOKI7xiA4iqH6YUGl1o0nEdsKRlhPxgS+8sJlNAfaD7VvGDfnho
	FFjxb0RFVjqEkuFZW4SheItIxRCFWb8fk4MfiHScdliDFXZlM66iASvqsJcWb8KA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44skjuwe49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:13 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51ED9RZW019399;
	Fri, 14 Feb 2025 13:11:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44skjuwe46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51EAK5cH028221;
	Fri, 14 Feb 2025 13:11:11 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44phyyuug1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Feb 2025 13:11:11 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51EDBAnZ29426278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Feb 2025 13:11:10 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C19D5806B;
	Fri, 14 Feb 2025 13:11:10 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E71458052;
	Fri, 14 Feb 2025 13:11:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Feb 2025 13:11:07 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Date: Fri, 14 Feb 2025 14:10:54 +0100
Subject: [PATCH v6 3/3] PCI: s390: Enable HAVE_PCI_MMAP on s390 and
 restrict mmap() of resources to mappable BARs
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250214-vfio_pci_mmap-v6-3-6f300cb63a7e@linux.ibm.com>
References: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
In-Reply-To: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3239;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=oZzm7bjnXY99I6Zc3jVr5s2rPCWnBBpDlteWHQeKPAg=;
 b=owGbwMvMwCX2Wz534YHOJ2GMp9WSGNLXOzx05VXpUpY6Pt1s8m0+ztVTdd9OSeXY+bDWV8JHg
 zvJPsWno5SFQYyLQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIm8y2RkuDz5b+HScxEHFm2S
 6Vt5T77nbanDil93WVZHHVfV/LD0fDDDPy3rYoVurirDs88tE1kfZ0yZ1BcnsTKE7cQX/djkxLI
 cVgA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: l-dImMFPgbWZdTA0gSjIhc-jmoW6UfA5
X-Proofpoint-ORIG-GUID: MicYpK5s-NuHQl-dwLUgCzVIoGTeeour
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_05,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxlogscore=651 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502140096

So far s390 does not select HAVE_PCI_MMAP. This is partly because access
to mapped PCI resources requires special PCI load/store instructions and
prior to commit 71ba41c9b1d9 ("s390/pci: provide support for MIO
instructions") even required use of special syscalls. This really isn't
a showstopper though and in fact lack of HAVE_PCI_MMAP has previously
caused extra work when testing and debugging PCI devices and drivers.

Another issue when looking at HAVE_PCI_MMAP however comes from the
virtual ISM devices. These present 256 TiB BARs which really can't be
accessed via a mapping to user-space.

Now, the newly added pdev->non_mappable_bars flag provides a way to
exclude devices whose BARs can't be mapped to user-space including the
s390 ISM device. So honor this flag also in the mmap() paths protected
by HAVE_PCI_MMMAP and with the ISM device thus excluded enable
HAVE_PCI_MMAP for s390.

Note that most distributions enable CONFIG_IO_STRICT_DEVMEM=y and
require unbinding drivers before resources can be mapped. This makes it
extremely unlikely that any existing programs on s390 will now suddenly
fail after succeeding to mmap() resources and then trying to access the
mapping without use of the special PCI instructions.

Link: https://lore.kernel.org/lkml/20250212132808.08dcf03c.alex.williamson@redhat.com/
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 arch/s390/include/asm/pci.h | 4 ++++
 drivers/pci/pci-sysfs.c     | 4 ++++
 drivers/pci/proc.c          | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 474e1f8d1d3c2fc5685b459cc68b67ac651ea3e9..518dd71a78c83c74dc7b29778e299d5c8cabcc59 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -11,6 +11,10 @@
 #include <asm/pci_insn.h>
 #include <asm/sclp.h>
 
+#define HAVE_PCI_MMAP			1
+#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
+#define arch_can_pci_mmap_wc()		1
+
 #define PCIBIOS_MIN_IO		0x1000
 #define PCIBIOS_MIN_MEM		0x10000000
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index b46ce1a2c5542cdea0a3f9df324434fdb7e8a4d2..7373eca0a4943bf896b4a177124e0d4572baec2b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1257,6 +1257,10 @@ static int pci_create_resource_files(struct pci_dev *pdev)
 	int i;
 	int retval;
 
+	/* Skip devices with non-mappable BARs */
+	if (pdev->non_mappable_bars)
+		return 0;
+
 	/* Expose the PCI resources from this device as files */
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index f967709082d654a101039091b5493b2dec5f57b4..9348a0fb808477ca9be80a8b88bbc036565bc411 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -251,6 +251,10 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	    security_locked_down(LOCKDOWN_PCI_ACCESS))
 		return -EPERM;
 
+	/* Skip devices with non-mappable BARs */
+	if (dev->non_mappable_bars)
+		return -EINVAL;
+
 	if (fpriv->mmap_state == pci_mmap_io) {
 		if (!arch_can_pci_mmap_io())
 			return -EINVAL;

-- 
2.45.2


