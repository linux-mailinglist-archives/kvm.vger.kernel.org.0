Return-Path: <kvm+bounces-6087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5689F82B0C3
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0738C1F2500A
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050E04EB3D;
	Thu, 11 Jan 2024 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M0wQDBk8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CE34EB21;
	Thu, 11 Jan 2024 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BESpE2005896;
	Thu, 11 Jan 2024 14:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zfildR9DnDi32vKf+vQPMujSLE9aUyOrRoF9q0VtweU=;
 b=M0wQDBk8M5UlsiINif+3mvbP5CW2z9hQ7/2AOP9c30XQTK/XOipaxiujZV8vjl+MW2Wk
 sb+jHRnNM3uwf1CMS/dx/gX17kJ9iMqV6dyLFCkqCKZBl6iONYU3bWF+D0ATRfrYXo2T
 X6MMRLHu6abUXmlNTBCEIdLyNNoLkuhxUDVyTkl21HYbGqqW9mEZIr0PVR7E+Ojx2d+f
 us1ue7XJKA9mzgLrk31mIIxqLzM3tXCeyyK9o2heo77AHPtPDeXwdsKGV51ZrPTVqJHo
 qNHmmMYFCT7zcxlUFunFiHCkp5vRB4Qwv/qjphuxlD/helzs1B2WwxiVynPmBxdR3Voi tw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjev85wte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:38:51 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BDSGmK004398;
	Thu, 11 Jan 2024 14:38:50 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjev85wt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:38:50 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40BETZTF022819;
	Thu, 11 Jan 2024 14:38:49 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfhjyv4as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:38:49 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40BEcmdY52167004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 14:38:49 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8FBF058063;
	Thu, 11 Jan 2024 14:38:48 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B58A458059;
	Thu, 11 Jan 2024 14:38:47 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.174.181])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jan 2024 14:38:47 +0000 (GMT)
From: Tony Krowiak <akrowiak@linux.ibm.com>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: [PATCH v3 0/6] s390/vfio-ap: reset queues removed from guest's AP configuration
Date: Thu, 11 Jan 2024 09:38:34 -0500
Message-ID: <20240111143846.8801-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w7nrDayS6I9j88kc4nx2rqknorvmOaeu
X-Proofpoint-GUID: h8j5oelMA5wLJwcdGidm3D-6rT_RuTFN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_07,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=981 malwarescore=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110116

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
* Added r-b's to patch 6/6 for Jason and Halil

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


