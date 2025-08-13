Return-Path: <kvm+bounces-54596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DBFB251C0
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 19:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 271471C81D1F
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 17:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D869A2C0F88;
	Wed, 13 Aug 2025 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pv4kyQY8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7616B303C85;
	Wed, 13 Aug 2025 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104910; cv=none; b=ib8tHnfJp4WXTPe3u4JVtYxdaCixVouSguMUT6/EBw+IKxPsLNkFYlaau4d3LHwblu4WwU1G7UgR1BLo9YLx3vYVSQ+pTnKdwqljF1o/jfZzQDCEnAfVz0eeGAmWYeiFruzOMRIFg8/g56p/SezHWrNYjlXTKpR7R40Q3+BDllg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104910; c=relaxed/simple;
	bh=GpTnZzUi7WUVvEXofT8h2Pi8qGUoIzk8UCB5WABBuY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMFLTR/C8RNMP7GCd37HHTY2ljBD45zfjrLbowT4ogQkl+upJI+u+vrdLB293NwpUd56yqptCnFgYbT2dT8h+pMFz+Y0bWWVz+uTsqCFoHOKjFebFWEahzQF2leAuy7zV7JDfRv0CSXpoaHDya7AtyFe8RKD+AEm1X0kDsNirWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pv4kyQY8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCPXDk028484;
	Wed, 13 Aug 2025 17:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/JQ5jQDq4TI8LPK6T
	1B7HMqojffE60cYmDeEejGCZxA=; b=pv4kyQY8BxPD+TFfqokZ21XYbPBL5d0re
	9mAz7WAYDNWbWXxljtxhYluEhmV9A/bLnY57maSMDoDVu5iOZXVtA8rF2hkR7LDT
	IaOgzNCMeA1lGn+6Aqw8eS5Ll03T7P0CZBVLz1wYWCQXCU2Pl41Fy+l7sJhGgKSk
	DigkO7jnmzUsaVmN/5mN9/gM7sjvOyQwm1O4G2JXY3xgG1eOn9S6TuUZ+XvwcuBF
	qYJ1csYHMVlrMQ54W6D7kl6G5j27acwxl6UmvGHSeYD1kbipq4S0aUYHqoicn+jr
	SmP5cHOz7qJmLj/MmC3X+GnDfPIhW9kik/p+KTmipqltv5ZYdqWJw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48durudrch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57DGXi6t025654;
	Wed, 13 Aug 2025 17:08:25 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ejvmg355-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 17:08:25 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57DH8O3u56230382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 17:08:24 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E958B5805A;
	Wed, 13 Aug 2025 17:08:23 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05CEC5805D;
	Wed, 13 Aug 2025 17:08:23 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.61])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 17:08:22 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: schnelle@linux.ibm.com, mjrosato@linux.ibm.com, alifm@linux.ibm.com,
        alex.williamson@redhat.com
Subject: [PATCH v1 1/6] s390/pci: Restore airq unconditionally for the zPCI device
Date: Wed, 13 Aug 2025 10:08:15 -0700
Message-ID: <20250813170821.1115-2-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250813170821.1115-1-alifm@linux.ibm.com>
References: <20250813170821.1115-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5VKREChJFwabw5pmjUPsFrw8FkkC1uba
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX70jzmOP3nnbn
 7UuX9JBcKR5mBKorLZoe9QlvQZUmKUungIozotV2Fioyv93H06O9iShC6r+coaJZPTiubVTd7IE
 HsN5wxrUx37IVWCFUU64RL712bas/wceI+iZXEJbR57dXmbqqSOefQp2cyOrEfgHTewiCsznanH
 qEeyKueqry+/YM4GrTJycInr52BB86p3cGe7uNVdd0TcEy+Y1I7zZfhRHtj6WbKzUhIuzXgWK6P
 zhnigak/A5jsu2Iwoqkfa2JjI8LZlkYpJwCVPpnFoci+MOjANCfTzn2qfUZKI+evOzhWDy5tHVc
 tWr8L+PFaLlfN0vUpgfggF9scq4Jsscv5JiSuwL1J1WVtC14tBUJLpLhN+6ffKWQTMb2+2gANio
 C6/oGjat
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689cc68a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=rU-0L4YOitQFXdO97IcA:9
X-Proofpoint-ORIG-GUID: 5VKREChJFwabw5pmjUPsFrw8FkkC1uba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1011 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224

Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
resetting a zPCI device.

Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
mentions zpci_clear_irq() being called in the path for zpci_hot_reset_device().
But that is not the case anymore and these functions are not called
outside of this file.

However after a CLP disable/enable reset (zpci_hot_reset_device),
the airq setup of the device will need to be restored. Since we
are no longer calling zpci_clear_airq() in the reset path, we should
restore the airq for device unconditionally.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/pci/pci_irq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 84482a921332..8b5493f0dee0 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -427,8 +427,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
-	if (!zdev->irqs_registered)
-		zpci_set_irq(zdev);
+	zpci_set_irq(zdev);
 	return true;
 }
 
-- 
2.43.0


