Return-Path: <kvm+bounces-3923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8918280A8B0
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0341CB20BB5
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B2537D16;
	Fri,  8 Dec 2023 16:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CGBwdKWo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061921987;
	Fri,  8 Dec 2023 08:23:03 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GMA9t014613;
	Fri, 8 Dec 2023 16:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8zqF0vS6DlIKW4qExiCeBWG7s7HEW48Qv8M1MPl9Deo=;
 b=CGBwdKWoH1o/FmOy0GU7uh3lazHU9SKaUl4tU7ku81jmcE8NyLLmZ2QkMEYCQo/zAsmR
 OPRZSlR6VL+Vbkj/nlLeWmBDlvNMomI4D1t9oKENXW86b+CWQRFp9UL9FwajFocQgOx4
 ReFd6cHuytfOAUKqXOrdVJlDkp7qfbIbn/Dkk0BakZZjLNkSQXCBr2T4rqPq13pHcE1b
 GkFNvCZuYZWi3U5102hYa5SuxcCMAoThwhtO6dp2jD03N4QBTC24o2nj1a+TkRFE5Q6E
 /tolTT6PtUTDpQSn2/C+A7PL4dUyM3JdJdF2yhHLOAdoI7xT9y4fsWtevmv+BhYLNBR3 zg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6kng0q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:02 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B8GN1xV018841;
	Fri, 8 Dec 2023 16:23:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv6kng0pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:01 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8GLjU0001561;
	Fri, 8 Dec 2023 16:23:00 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utav2tjet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 16:23:00 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8GMxlL9634412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 16:22:59 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7E615804E;
	Fri,  8 Dec 2023 16:22:58 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 525BF5803F;
	Fri,  8 Dec 2023 16:22:57 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.47.9])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 16:22:57 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: [PATCH v1 0/6] s390/vfio-ap: reset queues removed from guest's AP configuration
Date: Fri,  8 Dec 2023 11:22:45 -0500
Message-ID: <20231208162256.10633-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7H1pX6VpibOUxrBhHmuQZDahddTwufv7
X-Proofpoint-GUID: yEJcYP9YvaqkQnoHn8QrjSW1RFBpJ84n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_11,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=922
 priorityscore=1501 suspectscore=0 adultscore=0 phishscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080135

All queues removed from a guest's AP configuration must be reset so when
they are subsequently made available again to a guest, they re-appear in a
reset state. There are some scenarios where this is not the case. For 
example, if a queue device that is passed through to a guest is unbound 
from the vfio_ap device driver, the adapter to which the queue is attached
will be removed from the guest's AP configuration. Doing so implicitly
removes all queues associated with that adapter because the AP architecture
precludes removing a single queue. Those queues also need to be reset.

This patch series ensures that all queues removed from a guest's AP
configuration are reset for all possible scenarios.


Tony Krowiak (6):
  s390/vfio-ap: always filter entire AP matrix
  s390/vfio-ap: loop over the shadow APCB when filtering guest's AP
    configuration
  s390/vfio-ap: let 'on_scan_complete' callback filter matrix and update
    guest's APCB
  s390/vfio-ap: reset queues filtered from the guest's AP config
  s390/vfio-ap: reset queues associated with adapter for queue unbound
    from driver
  s390/vfio-ap: do not reset queue removed from host config

 drivers/s390/crypto/vfio_ap_ops.c     | 271 ++++++++++++++++++--------
 drivers/s390/crypto/vfio_ap_private.h |  11 +-
 2 files changed, 194 insertions(+), 88 deletions(-)

-- 
2.43.0


