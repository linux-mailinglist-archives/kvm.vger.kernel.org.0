Return-Path: <kvm+bounces-21648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6DF9317FC
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13B7A1F21EC6
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 15:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B91F1757E;
	Mon, 15 Jul 2024 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Z4fDa/bo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D923B10A2A;
	Mon, 15 Jul 2024 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721059138; cv=none; b=ECZ62uUv3I5EcE+5JL8OwKMTm1Wqzpjg+Gtm95ow6zJbHrQ5vsHhaIOtRSJcYGeEPfl0pgbX8Z7kXmUpoL+vdgBW6A/4x2bV/F81+AW4H+ZaJFfRUYfx2jVIu3OiVk1dMHkuJgoz+p5w/jaX4RZ9zeEm9XAk+aZYDWhtNYqQidU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721059138; c=relaxed/simple;
	bh=jIzimQ9VkGd9YQshTfh4/yRykZp77w+qy7nmHrbQ+40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=OfIy9sjA2n2D25TP1kRoOZFReJac7CVoTtbsHs7Ur8Gav85waZ3YxyJy2WbcVenSwYypg+UHpwkEZOqI12O+O719motA7wuZhm1kZcBUC0DFo5uu5taXbp7WULVP2p0yIyFIuvJSedUsQIIP/w6Bra30QfA1ch6+t14fgJP8nyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Z4fDa/bo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FB88vu006720;
	Mon, 15 Jul 2024 15:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=2J3ELSP9pFwYLUwfbOsAsr
	k1niyWM0/vA1IsyYxnrgM=; b=Z4fDa/boVnr0ZDz6sWVfKYy38QYBkUD4q3Yh98
	AlDtuTZe4wySAHWzOnHNoHCJ/xCtbFjvXDEnbVR/PGMgsGOsKQNhd0AGMsivmOuj
	AEM+0Y5DgrtUCOe2Ic287hFavTGmECjs4bfDiSpwn9zfw+tyid6L2mmFvOEpHlnX
	+TUQBaKaGnaOwgOiZO6LAps1creK8SwCbPvqIt2V/IjiI/47U9WA9avpp/5jk5v2
	OHKi0NigOFAc2ufET2820HgR0aYLbPyubMp69EXruRB2W1QUQm3fpQ2jtpKNKu9+
	A6tGlkPWBHykTlYH0rMQOlGD9w75I3Zuxf1yvjKxHLHhqALw==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40bghrmr3v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 15:58:54 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46FFwrwZ003551
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 15:58:53 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 15 Jul
 2024 08:58:53 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Mon, 15 Jul 2024 08:58:51 -0700
Subject: [PATCH v2] s390/cio: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240715-md-s390-drivers-s390-cio-v2-1-97eaa6971124@quicinc.com>
X-B4-Tracking: v=1; b=H4sIADpHlWYC/42OSw6CMBRFt0I69pnyqWkduQ/DoJ+HvERabaHBE
 PYu4AYcnuTec+/CEkbCxK7FwiJmShT8BtWpYLbX/oFAbmNW8arhl1LA4CDVioOLlDGmH1gKUAs
 ltTGSV9qxrf6K2NF8qO/txkYnBBO1t/0ufJKfZhh0GjHu8Z7SGOLnOJLLvfTHZi6hBNlZJWSDU
 ihxe09kyduzDQNr13X9AlThMNvhAAAA
To: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter
	<oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
	<gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        "Christian
 Borntraeger" <borntraeger@linux.ibm.com>,
        Sven Schnelle
	<svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato
	<mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
CC: <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Jeff Johnson
	<quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: o30blen9uX1LzdQ9vUgnFAUAHWAyKhti
X-Proofpoint-ORIG-GUID: o30blen9uX1LzdQ9vUgnFAUAHWAyKhti
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_10,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 malwarescore=0 spamscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407150126

With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/ccwgroup.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/vfio_ccw.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
I hope this can get into the 6.11 merge window.
I originally had almost 300 patches to fix these issues treewide, and
this is one of only 13 left which have not landed in linux-next
---
Changes in v2:
- changed CCW Group to ccwgroup in ccwgroup.c description
- removed "Physical" in vfio_ccw_drv.c description
- applied Reviewed-by tags from Eric Farman & Vineeth Vijayan since these edits
  seem to be aligned with their comments
- Link to v1: https://lore.kernel.org/r/20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com
---
 drivers/s390/cio/ccwgroup.c     | 1 +
 drivers/s390/cio/vfio_ccw_drv.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index b72f672a7720..66b1bdc63284 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -550,4 +550,5 @@ void ccwgroup_remove_ccwdev(struct ccw_device *cdev)
 	put_device(&gdev->dev);
 }
 EXPORT_SYMBOL(ccwgroup_remove_ccwdev);
+MODULE_DESCRIPTION("ccwgroup bus driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8ad49030a7bf..914dde041675 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -488,4 +488,5 @@ static void __exit vfio_ccw_sch_exit(void)
 module_init(vfio_ccw_sch_init);
 module_exit(vfio_ccw_sch_exit);
 
+MODULE_DESCRIPTION("VFIO based Subchannel device driver");
 MODULE_LICENSE("GPL v2");

---
base-commit: 0c3836482481200ead7b416ca80c68a29cfdaabd
change-id: 20240615-md-s390-drivers-s390-cio-3598abb802ad


