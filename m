Return-Path: <kvm+bounces-19736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4AA2909B76
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 05:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A9161F213DF
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 03:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8997F16C85F;
	Sun, 16 Jun 2024 03:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="HEvHPqJn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1169323DE;
	Sun, 16 Jun 2024 03:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718510205; cv=none; b=Urkx1gwPkoULyuMuRiS7qkL77nNFJyRekD5bhQf6Ze+d10fxPQC0juX17qJCWevBvKSZ3PwFb2vesFGCb+fOyqvjgwpXSC0p9ywELvRireggEFrK8e2FmF6ZgHZBp06H38Fk1kn4VKZAhHi2lw9bN2T3N2sPxmrj6Gn7uYp5gJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718510205; c=relaxed/simple;
	bh=zyj28ZdBdLsprALNDulm47FtBs8Z6Fa29+dkGlWI8Uc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=Yg49TdWg3EXL1odPH0XggxoUm6ydpHyo/EylRGGYQcqCe4EHxvRfykZxX9fZYpPr8/+uVOK28DlG2lB57bY4Jq/haURAK/RvqpOVyOLP8eRvP6sROZf/6Ui4xej8zy7Orpm6lroYQiwEXTU9KnyBX/ko29TwZ43V0XlHBpHJlUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=HEvHPqJn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45G3iJIa019941;
	Sun, 16 Jun 2024 03:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=znENymMhwszNDOMUoKUBbj
	CnhU8Sw35VzJoGHQUcfdU=; b=HEvHPqJn4349m86OiNs0tDaqQYTIOR42hVunWr
	XlTTdWOd1zW1DGfE3ZKI0CyFLTKsrTaACJa6Rp55gl5DDEqoYBZx3J+RbDbYLmAb
	nZy0Ea5jo8cAknWuLVQlHR57xXAzY2YdIR6sVTpXpo0KPoDt/weIoxDAWJcINUsV
	S3rD/zz6ZuLkmNDAxN+5JJDbGYFuwPh3Q1CjpRl676seQpR9LasXfxMJ6s9OHUmH
	s6Q/bF+piNjlH72u8OXp4JThx5h7ruuutb9ah15v9/Ys+DsDqTPenNU3gMXX9QRR
	VxqXRDCFZ3mILwDU4XaKyvjj3oFHtMsXD5HwM7+h9TrX6tkQ==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys2hx9dps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 03:56:40 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45G3ucL6030525
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 16 Jun 2024 03:56:38 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 20:56:37 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 15 Jun 2024 20:56:35 -0700
Subject: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAHJibmYC/yXMwQ6CMAyA4VchPdtkDDDgqxgP3ValiQzTKiEhv
 LtDj9/h/zcwVmGDS7WB8iImcy6oTxXEkfKDUVIxeOdbd647nBJaMzhMKgur/RFlxqYbegqhd54
 SlPylfJf1t77eigMZY1DKcTyGT8mfFSeyNyvs+xc9nQBXiQAAAA==
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
X-Proofpoint-GUID: CRWY2JA3YqQT6AZpaG3M8O6YCOivrVYg
X-Proofpoint-ORIG-GUID: CRWY2JA3YqQT6AZpaG3M8O6YCOivrVYg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-16_02,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=870 clxscore=1011 priorityscore=1501 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406160029

With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/ccwgroup.o
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/s390/cio/vfio_ccw.o

Add the missing invocations of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/s390/cio/ccwgroup.c     | 1 +
 drivers/s390/cio/vfio_ccw_drv.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index b72f672a7720..a741e5012fce 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -550,4 +550,5 @@ void ccwgroup_remove_ccwdev(struct ccw_device *cdev)
 	put_device(&gdev->dev);
 }
 EXPORT_SYMBOL(ccwgroup_remove_ccwdev);
+MODULE_DESCRIPTION("CCW group bus driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8ad49030a7bf..49da348355b4 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -488,4 +488,5 @@ static void __exit vfio_ccw_sch_exit(void)
 module_init(vfio_ccw_sch_init);
 module_exit(vfio_ccw_sch_exit);
 
+MODULE_DESCRIPTION("VFIO based Physical Subchannel device driver");
 MODULE_LICENSE("GPL v2");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240615-md-s390-drivers-s390-cio-3598abb802ad


