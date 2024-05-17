Return-Path: <kvm+bounces-17566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1C28C7FB2
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 03:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08C6E2842B2
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 01:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510A579CF;
	Fri, 17 May 2024 01:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="IwtZStbS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1354C69;
	Fri, 17 May 2024 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715911064; cv=none; b=umZwTusOTMNkFrc3RyIjERoVWd7YvhAudOnsmdeLDI3UGM+fU1YxU3A0GFzuNzkWrbLPQtu7s1WvTe3aByBMqRBH7JVuYjf+USJpqbHR/QVm8dHokLY7JomNBRoL1KdSGJ6TT+IZ0DXyPrJlccDjrpWZVCEmzqp79yAsq+MtxsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715911064; c=relaxed/simple;
	bh=TeQwxcoJKMhlE7MRgBjHwcLfIU5flh55tSEr1OeVZTQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=oLX1Hja3UwEd9WNeMwocfueOXuv+rJfQYxJ218Os2bqUS4FsIl4rqCYuNTGYl854OupBvGBbUxFfB7h/mypTZ/4YkJ6XXFvROIyT9wI5CicLHnvQlo0L0jlzYCrRVVy3vx+tpoZ1KO5tK3rNrhGncEmyG83hKsE/Pb6rRwegYXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=IwtZStbS; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44GKMTnE014892;
	Fri, 17 May 2024 01:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	from:date:subject:mime-version:content-type
	:content-transfer-encoding:message-id:to:cc; s=qcppdkim1; bh=4Xn
	mAg2zsv4MMPg4ePcXWEN4bz039q9JRraQWkgbVw0=; b=IwtZStbSk3JYJzAeF0I
	1mIEr7hmVeHiiFavZnE5+ZnApGP7Sv+azVQpMXZ//cJrZfedETwAax8+f74sj52k
	RrIqFEFgq688rkyDe3M735wNDvr+YFzaJQgAYdMblvUpYilBZjgpbQvrCrYX610/
	2JOPwJn3jEroQ2zyOZmrQO0CxWBtIumawuNuzrvjRA4wNTHwUyqFDYknOoPlr4QX
	xAa8y2UI9dYwY31GFmGxHJeSohzR+QdvbDPsYCSZFVbsVmg7wyLpjQdAShOeuL1Y
	aqkY0kiY0jcm9C+z47rjwNgPVKfRTdCLYwK+JjwpeRiZ10RaR+mbNIoGHbHkq8V7
	GeQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3y5e9ct0gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 01:57:34 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44H1vX5K025147
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 May 2024 01:57:33 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 16 May
 2024 18:57:32 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 16 May 2024 18:57:32 -0700
Subject: [PATCH] vringh: add MODULE_DESCRIPTION()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240516-md-vringh-v1-1-31bf37779a5a@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAIu5RmYC/x3MQQrCQAxA0auUrA1M21HEq4iLzDR2AnYsiZZK6
 d2NLh98/gbGKmxwaTZQXsTkWR3toYFcqI6MMrihC10Mx/aE04CLSh0L5tifQ08cEkXwfla+y/p
 /XW/uRMaYlGouv8ND6nvFiezFivPHU9j3L1yS0c+AAAAA
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux.dev>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: yXUsnD5gIMwD8PMfWK8PGk4evjt5EaRT
X-Proofpoint-ORIG-GUID: yXUsnD5gIMwD8PMfWK8PGk4evjt5EaRT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-16_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1011 mlxlogscore=805
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405010000 definitions=main-2405170014

Fix the allmodconfig 'make w=1' issue:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/vhost/vringh.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/vhost/vringh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 7b8fd977f71c..73e153f9b449 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1614,4 +1614,5 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
 
 #endif
 
+MODULE_DESCRIPTION("host side of a virtio ring");
 MODULE_LICENSE("GPL");

---
base-commit: 7f094f0e3866f83ca705519b1e8f5a7d6ecce232
change-id: 20240516-md-vringh-c43803ae0ba4


