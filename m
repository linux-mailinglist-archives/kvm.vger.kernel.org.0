Return-Path: <kvm+bounces-4265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4A4380F932
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 22:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 120411C20D64
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 21:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5E764150;
	Tue, 12 Dec 2023 21:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GBd1BqW8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A91B9;
	Tue, 12 Dec 2023 13:25:29 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BCK2Tp1030525;
	Tue, 12 Dec 2023 21:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=CEaMm5o6vNTyRxNK2pqMXNNjXA1BgQFDyA+wtWmQ9Rk=;
 b=GBd1BqW8qTW7XX4yhod3BE8asiY75t1mD95R4t3Xk7SKm9961EFKM32dGIUFUio6m4zj
 9973V4W2VyjXhZy/fkhASbTTlU+pgNx+D8ORDNQXkM5hu6y/RUPkcqHD11X8SbeS/iv3
 Alm9YHvtMAh38kjEnU6h0nlrdcrZsW7boV/elyJ/Vo3p/q/5sTnm35EvwOyjEJd2WfYA
 VqcRV7C1BQVlt5BiNlbotoJVvTNhn0RAjs8hexixaerIxjB6EgaLg9kphAG9BMEuPwt6
 gQMWfrblDnJuVsjCEKhtYaTCjNbvptAgYxdiP6+O9nTxXvjVMQu2Pm0wmtA/uv6f5kSM 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uxx6usyn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 21:25:27 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BCLCZ8R016814;
	Tue, 12 Dec 2023 21:25:27 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uxx6usymr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 21:25:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BCJ37xe012599;
	Tue, 12 Dec 2023 21:25:26 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw3jnv48p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 21:25:26 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BCLPOOK18219554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Dec 2023 21:25:25 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F0F658067;
	Tue, 12 Dec 2023 21:25:24 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFFFC5805D;
	Tue, 12 Dec 2023 21:25:23 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.187.43])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Dec 2023 21:25:23 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: [PATCH v2 0/6] s390/vfio-ap: reset queues removed from guest's AP configuration
Date: Tue, 12 Dec 2023 16:25:11 -0500
Message-ID: <20231212212522.307893-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WglTkjzc_-8NoLq5n3wnfWMofzrG3NS_
X-Proofpoint-ORIG-GUID: 5St5TEpbrv5nTB6NOmNWczhYowmjq_vf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-12_12,2023-12-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312120165

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

Changelog v1=> v2:
-----------------
* Restored Halil's Acked-by and Reviewed-by tags (Halil)

* Restored Halil's code refactor of reset_queues_for_apids function in 
  patch 4

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

 drivers/s390/crypto/vfio_ap_ops.c     | 268 +++++++++++++++++---------
 drivers/s390/crypto/vfio_ap_private.h |  11 +-
 2 files changed, 184 insertions(+), 95 deletions(-)

-- 
2.43.0


