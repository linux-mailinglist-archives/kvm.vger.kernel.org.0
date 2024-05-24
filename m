Return-Path: <kvm+bounces-18091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4BA98CDEDC
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85A921F2112E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 00:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7851F79C2;
	Fri, 24 May 2024 00:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="PV21+wi8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155F19B;
	Fri, 24 May 2024 00:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716510011; cv=none; b=meslyr967TNy+zYKtFIFM2DKbNmDQnwQ8lHdDVMmtulxpQCbx2nqfNsWmVAqkC1iD6W5yxqf6tbJQmd/YBC0+eQRMJBh+KWHNbGR6mWS1afnVHyiTRAjPF5bvTUR7/ZO1PvzaDyXw4gT70p9Ga1VKD27kS3HDd9VtzaauRFkuG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716510011; c=relaxed/simple;
	bh=UISalHEbveHVG2/HSIHQqF9o5XaSlJzmRionrjBFrfw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=NDgUORIZ8ai0wuj9rk8+4tHDebMTTT5SYbdscX3SLLOEH7zP0X7Yp8YIB+R56tUHk8WcfR7i1TU/75OQF0Rcq8zJaGUV51YJ0omo3dMvmkYnUZ969ibYhTsCcgwx/BpAZEB54O5Wg7j1CcX4fcOJv+zELFoFk3AHFb2FJIInV3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=PV21+wi8; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44NNP0cp004106;
	Fri, 24 May 2024 00:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=ZeHxtkw586PaODVHgHJTtw
	yVLvMA6RMOHdQGuTC/h/o=; b=PV21+wi8oEW6fWopGRU9nAhpuEmsn9Cgk8DdAo
	aWR3dWoWfJ6KSCOivMUiTn2PNiWlCCjSCaEbnNPplgSS/ygHHE3cJDWzFq7X0VSJ
	eQMvEH7afwhBT5iCZA2FBW+ozAGuJnodPi8c5z44jye6Gx32/RJ4AUPl9dflW4dj
	rSWXtBrZ3YVV0+l0jIsUd/sxkzociNw7yhS90OKktOOLFtsWYpoKXCjTxbvZXcfM
	v29oM8Cd5Ze/p0W6pDUCuGTRLTIE2T4mboAzHnKLqiQ6s6ivzus4JFyxePNETqCh
	zNIDz66TkoHNEyjxVzBAP7LRrYdUbyXx3LI+3bIrE3Cl9O+g==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yaa8kgr8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 00:20:08 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44O0K7cQ019089
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 May 2024 00:20:07 GMT
Received: from [169.254.0.1] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 23 May
 2024 17:20:06 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 23 May 2024 17:12:24 -0700
Subject: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAGjbT2YC/x2M0QqDMAxFf0XyvICtDmW/MvbQajoDs0riikP89
 2V7uhy45xygJEwKt+oAocLKSzZwlwqGKeQnIY/G4Gvf1lff4DxiSbzYUsGmd6lrY+q75MCUVSj
 x/s/dH8YxKGGUkIfpF3lxfu84B91IcP3YFc7zC8L3u/qDAAAA
To: Kirti Wankhede <kwankhede@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: B-sDN7bfuIo3ZNOaHS6SqkLDMDa7EKL4
X-Proofpoint-GUID: B-sDN7bfuIo3ZNOaHS6SqkLDMDa7EKL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_13,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405240000

Fix the 'make W=1' warnings:
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mtty.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mdpy.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mdpy-fb.o
WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-mdev/mbochs.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 samples/vfio-mdev/mbochs.c  | 1 +
 samples/vfio-mdev/mdpy-fb.c | 1 +
 samples/vfio-mdev/mdpy.c    | 1 +
 samples/vfio-mdev/mtty.c    | 1 +
 4 files changed, 4 insertions(+)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 9062598ea03d..836456837997 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -88,6 +88,7 @@
 #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
 
 
+MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
 MODULE_LICENSE("GPL v2");
 
 static int max_mbytes = 256;
diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 4598bc28acd9..149af7f598f8 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -229,4 +229,5 @@ static int __init mdpy_fb_init(void)
 module_init(mdpy_fb_init);
 
 MODULE_DEVICE_TABLE(pci, mdpy_fb_pci_table);
+MODULE_DESCRIPTION("Framebuffer driver for mdpy (mediated virtual pci display device)");
 MODULE_LICENSE("GPL v2");
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 27795501de6e..8104831ae125 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -40,6 +40,7 @@
 #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
 
 
+MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
 MODULE_LICENSE("GPL v2");
 
 #define MDPY_TYPE_1 "vga"
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 2284b3751240..40e7d154455e 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -2059,5 +2059,6 @@ module_exit(mtty_dev_exit)
 
 MODULE_LICENSE("GPL v2");
 MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
+MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");
 MODULE_VERSION(VERSION_STRING);
 MODULE_AUTHOR(DRIVER_AUTHOR);

---
base-commit: 5c4069234f68372e80e4edfcce260e81fd9da007
change-id: 20240523-md-vfio-mdev-381f74bf87f1


