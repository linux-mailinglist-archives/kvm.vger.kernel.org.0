Return-Path: <kvm+bounces-58686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65ED3B9B077
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF499326DF7
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CFE320CC2;
	Wed, 24 Sep 2025 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nMTEGq3d"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E99A320CB5;
	Wed, 24 Sep 2025 17:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734217; cv=none; b=mHDZYh0oQjd/qMrMCmzqVVwf1bseLv/wpbwFRc6c8u2F2IGu8QOnpNeNfuHnKeWSL2fCC7yU0a4EGMq3VuetFSZMBUJBMEi92y2nzq7hW2lENcS54w4XyXuaqrYjhIPe+dVH/VQLHfZcgwC9x06QiSWeWo5uuyWMn6aFsCp8qTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734217; c=relaxed/simple;
	bh=HvTt5221H5DQ1X+GZWXY3QkHHnBA6eW/stRkoiAL7gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luWwkTby4op1K2ureeaWYIV75a2WE/wZLEKsFln9eFS3wL8FA6nywlzXqT1TJEKpcgHmnYmQxIQyN/DXBD5PHZ7PwI/1AxYw4DbW9CgpmNPkD+B2FXqcTJpNqqvNXdZE17KeyIyiKdStMAT+3MxCBkiILr+pmQFnoDJeBZfAZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nMTEGq3d; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OBC4E3030655;
	Wed, 24 Sep 2025 17:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+c2kHIW89fFxZMF7i
	igDqHKPq5NHEczv6HmG2G6s5GY=; b=nMTEGq3dFYbBbQvJ9GXFiw6mQfvct6nxp
	aw3KigkApG5BUKVWVh2FLi7guzRJobT9vzJGKJD3pMnVh+yP3UN6o+SANjAexSsc
	lBtWB277l3UaoVmZrOvFWMTGX6E7cywfwHUFxDDwCBBSjoRci1Z2nhvjn/frKEpx
	+6FBbc0ZIsVo3+g2BLKcNgWXiUEZO57voI+LrTTcDv4lakN3q9smzMhQFemlLx5c
	83BqZwoEEbeaqns43uNuuS6pMYgz0iUrmGZmvbr4x1hPuLbI0o78mAeNfkB6XbDy
	bQXF7j6uUBrRCMDWGKkBiohi0xjoYbouvIJ2/RtrFS8cZuxUsQxsw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0jru62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:44 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGqNCp031129;
	Wed, 24 Sep 2025 17:16:43 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vdar45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:43 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGfTi25231924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:41 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82FD958056;
	Wed, 24 Sep 2025 17:16:41 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5F455803F;
	Wed, 24 Sep 2025 17:16:40 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:40 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 10/10] vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX
Date: Wed, 24 Sep 2025 10:16:28 -0700
Message-ID: <20250924171628.826-11-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924171628.826-1-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzMyBTYWx0ZWRfX0X969P0a6iN4
 bG850Eq2l3I5lvYOw5aezrN0xypGlm7dmRoS2mjgjFmVhsnKyn2SA41t7mp2VYdZ/cdbyfTJD46
 VN+PKccWSd+5dSll+cCbxHLFpA5Vum/WLZcypoJZ1EXBXidPxLthqZ2ct3fN4gtcr9n5azWtyeR
 HNViRTycMLtwTQ30y3W/AUTjnjPeMQ0IJ5GfILbQ9KBFuQca5MujjiTizo7Hrvc9fOTzPShOgWb
 V26vx4SNTwUgpFWVVchi4f+Pm2ZfnYgx0gUvlvRUxxta5bs5RSE0VCb0Zm0UoIlLOl49tAYT5+M
 BUCDb26Ev0r6p271ZMz28JXiy/GUPjS5th0CfmdGvOgOeX2eZ8cSIGhUoJHVHG7BBab7ll0pbpq
 XGHe59DF
X-Authority-Analysis: v=2.4 cv=TOlFS0la c=1 sm=1 tr=0 ts=68d4277c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=gONGJyW3jwFs4LhXXOUA:9
X-Proofpoint-ORIG-GUID: 48TChb8nh3rFSuN7J0ZHc9sSROnPXjw_
X-Proofpoint-GUID: 48TChb8nh3rFSuN7J0ZHc9sSROnPXjw_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200033

We are configuring the error signaling on the vast majority of devices and
it's extremely rare that it fires anyway. This allows userspace to be
notified on errors for legacy PCI devices. The Internal Share Memory (ISM)
device on s390x is one such device. For PCI devices on IBM s390x error
recovery involves platform firmware and notification to operating system
is done by architecture specific way. So the ISM device can still be
recovered when notified of an error.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c  | 6 ++----
 drivers/vfio/pci/vfio_pci_intrs.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f2fcb81b3e69..d125471fd5ea 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -749,8 +749,7 @@ static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_typ
 			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
 		}
 	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX) {
-		if (pci_is_pcie(vdev->pdev))
-			return 1;
+		return 1;
 	} else if (irq_type == VFIO_PCI_REQ_IRQ_INDEX) {
 		return 1;
 	}
@@ -1150,8 +1149,7 @@ static int vfio_pci_ioctl_get_irq_info(struct vfio_pci_core_device *vdev,
 	case VFIO_PCI_REQ_IRQ_INDEX:
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
-		if (pci_is_pcie(vdev->pdev))
-			break;
+		break;
 		fallthrough;
 	default:
 		return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f..f2d13b6eb28f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -838,8 +838,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (pci_is_pcie(vdev->pdev))
-				func = vfio_pci_set_err_trigger;
+			func = vfio_pci_set_err_trigger;
 			break;
 		}
 		break;
-- 
2.43.0


