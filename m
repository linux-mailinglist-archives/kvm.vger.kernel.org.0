Return-Path: <kvm+bounces-15952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD978B26EC
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4241C21F5F
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1BB414D710;
	Thu, 25 Apr 2024 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FvekvzNY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE7714D439;
	Thu, 25 Apr 2024 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714064179; cv=none; b=bjBj3vtsbqZkycS2R6AiME5U9eYrWDGIt/Lg7DOFHxymxzinHLXi6SoOgt465LA6KbJ8yn4hd/ctb6WlDqse6SyYnN6/h2bK0WuL8w9nY8xqNxgXk35lbFi0o3dUMyJ4vsMoizqEv4/krqsvRZvTwXgp17NjU77c9eg8s3GuYWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714064179; c=relaxed/simple;
	bh=aQopQx6OxXFwMj0TdW4oGFIjbPRA8+TCpMM18HBNXxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW+kjVbUzwg5/uc1Lo3vwTxW0qf8oWWc1oKCPTz6bLR7lYpAsJtxOqBYiPhASOMYCqYwv7TBrV7arrw9hCC15wzewngSQ4r1FRVRAB0OB6rmgfJGB4yOsJA1ZAyb4hoONGNxftHeaDierDrfSa+fLw3+OrV4p0WV6GszzHQWEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FvekvzNY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43PGgvWm030332;
	Thu, 25 Apr 2024 16:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Y8BJn3oGmuQTUDxwDR4DcRIKWQiKOWhEiZWZAO/4kmY=;
 b=FvekvzNYXxN+t3plpM6/z9COy07RNhLez6Rg7I5JJd7rlJNS+WOMBqKUvle+gpBg//CP
 SJQy/XUTlwljuAS20cGfYZCGBLNvh3SeWW5X3JeSCp46W+oQguoVC1zLgr991OoRs6f7
 pdWwS6OvT0hv6FpdmMIqh8wPV4AfFkj55gK7Wd8fPlvNFJyTRnK580lZKXT+CEF8FO/j
 gpzhi1peGnYScZAqtD8my7w7ZAYwlDFxAX0cR3bEKK5MXQJiEaCCUU00rWLqTublz1dc
 im6pQg+U008r14CCQACO45hYDWxsZ3Rdrm4SShTF7/lxScD0NkLEy+P4phemBpc9xphD wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtxf01g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:14 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43PGuDEa021044;
	Thu, 25 Apr 2024 16:56:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqtxf01g3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:13 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43PGAcbf015302;
	Thu, 25 Apr 2024 16:56:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmshmjq6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 16:56:12 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43PGu7I450201004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 16:56:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 536002004D;
	Thu, 25 Apr 2024 16:56:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F5AC20065;
	Thu, 25 Apr 2024 16:56:07 +0000 (GMT)
Received: from dilbert5.boeblingen.de.ibm.com (unknown [9.152.212.201])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Apr 2024 16:56:07 +0000 (GMT)
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Gerd Bayer <gbayer@linux.ibm.com>
Subject: [PATCH v3 3/3] vfio/pci: Continue to refactor vfio_pci_core_do_io_rw
Date: Thu, 25 Apr 2024 18:56:04 +0200
Message-ID: <20240425165604.899447-4-gbayer@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240425165604.899447-1-gbayer@linux.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4Z--wod7-PxpjBnLTQGw51X6rFLyhLvl
X-Proofpoint-ORIG-GUID: s8Lq3pCM98slF7tCqobbZAcagwL264wl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_16,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=830 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404250123

Convert if-elseif-chain into switch-case.
Separate out and generalize the code from the if-clauses so the result
can be used in the switch statement.

Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 8ed06edaee23..634c00b03c71 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -131,6 +131,20 @@ VFIO_IORDWR(32)
 VFIO_IORDWR(64)
 #endif
 
+static int fill_size(size_t fillable, loff_t off)
+{
+	unsigned int fill_size;
+#if defined(ioread64) && defined(iowrite64)
+	for (fill_size = 8; fill_size >= 0; fill_size /= 2) {
+#else
+	for (fill_size = 4; fill_size >= 0; fill_size /= 2) {
+#endif /* defined(ioread64) && defined(iowrite64) */
+		if (fillable >= fill_size && !(off % fill_size))
+			return fill_size;
+	}
+	return -1;
+}
+
 /*
  * Read or write from an __iomem region (MMIO or I/O port) with an excluded
  * range which is inaccessible.  The excluded range drops writes and fills
@@ -155,34 +169,38 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 		else
 			fillable = 0;
 
+		switch (fill_size(fillable, off)) {
 #if defined(ioread64) && defined(iowrite64)
-		if (fillable >= 8 && !(off % 8)) {
+		case 8:
 			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
 						     io, buf, off, &filled);
 			if (ret)
 				return ret;
+			break;
 
-		} else
 #endif /* defined(ioread64) && defined(iowrite64) */
-		if (fillable >= 4 && !(off % 4)) {
+		case 4:
 			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
 						     io, buf, off, &filled);
 			if (ret)
 				return ret;
+			break;
 
-		} else if (fillable >= 2 && !(off % 2)) {
+		case 2:
 			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
 						     io, buf, off, &filled);
 			if (ret)
 				return ret;
+			break;
 
-		} else if (fillable) {
+		case 1:
 			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
 						    io, buf, off, &filled);
 			if (ret)
 				return ret;
+			break;
 
-		} else {
+		default:
 			/* Fill reads with -1, drop writes */
 			filled = min(count, (size_t)(x_end - off));
 			if (!iswrite) {
-- 
2.44.0


