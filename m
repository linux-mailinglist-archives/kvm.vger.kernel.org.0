Return-Path: <kvm+bounces-1356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F8477E6F90
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 17:44:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9E41C20BA4
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 16:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C002233D;
	Thu,  9 Nov 2023 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bcCdtrPk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D271DFF3
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 16:44:44 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB473A8F;
	Thu,  9 Nov 2023 08:44:43 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9Gdien013694;
	Thu, 9 Nov 2023 16:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OKSdRTYTvtH95EYBaVFlAipwQj0eF65mxwIHlNhJWcw=;
 b=bcCdtrPkyqJRH2vOWRcbo4xgZmzAF3KvcXnDGWHDYFyP1D2Xppo39sgH4ojhpbuHkAqu
 Z02o8ybXAS7X6bGInrpVHk7WeJ0Vd7piXb492C+92oQVSmwQWkQlNq9C4Z9cxeevlq9m
 RkambuzevA6oljhAp8X//2mcTPkqe5VNLkpRD1CFg9ViTzh9e9M9Q/+EnYqoZr96vO1B
 8kpnVCxKwUI/T3Q8cl2ldGOUGq2OtsShSVO7A164zTHGshz2J5yErtAhYI8jfXFjMs36
 2Vnm6hgFoI77bv2aHH/7BJOxr1Jlo5OQS2OAh8WNWHv8hkQDf0OpLG2wVbhlEChGdPid Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u934y07mv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:44:42 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A9Ge85w015224;
	Thu, 9 Nov 2023 16:44:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u934y07me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:44:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9EI7Af004183;
	Thu, 9 Nov 2023 16:44:41 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w2151p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 16:44:41 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9GieA617891980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 16:44:40 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95B2B58052;
	Thu,  9 Nov 2023 16:44:40 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D7525805D;
	Thu,  9 Nov 2023 16:44:34 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.74.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 16:44:33 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [PATCH v3 0/3] s390/vfio-ap: a couple of corrections to the IRQ enablement function
Date: Thu,  9 Nov 2023 11:44:19 -0500
Message-ID: <20231109164427.460493-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9JNMSpWsiIHHyrJ-ud8-VNQ_EvR42W8m
X-Proofpoint-GUID: Uv87Ub5TXabUUhZ9ZzhRYx6pj9f2tn5P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_14,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=966 impostorscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311090127

This series corrects two issues related to enablement of interrupts in 
response to interception of the PQAP(AQIC) command:

1. Returning a status response code 06 (Invalid address of AP-queue 
   notification byte) when the call to register a guest ISC fails makes no
   sense.
   
2. The pages containing the interrupt notification-indicator byte are not
   freed after a failure to register the guest ISC fails.


Anthony Krowiak (2):
  s390/vfio-ap: unpin pages on gisc registration failure
  s390/vfio-ap: set status response code to 06 on gisc registration
    failure

Tony Krowiak (1):
  s390/vfio-ap: improve reaction to response code 07 from PQAP(AQIC)
    command

 drivers/s390/crypto/vfio_ap_ops.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.41.0


