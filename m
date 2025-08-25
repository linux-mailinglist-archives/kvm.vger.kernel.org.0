Return-Path: <kvm+bounces-55654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E33B34852
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08FBF170DCA
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767BC302CDB;
	Mon, 25 Aug 2025 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NDvdKq9u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F2301033;
	Mon, 25 Aug 2025 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141958; cv=none; b=lF44LRjaacc3CmBGcp7IQmdqL0phZMBKSQgQ0QfCiMxYDBDB1VpgaQqXmCk5J/xrq6oZPWMa1cRehXqRiKrn/x3rzRjNPnjPpO7eDO0/yZrtQ3tG3XUbs5PceysnuH4rdwIZ4qQo67AeQ4jQOcm/Z4Go94PlDQE05rWR5W8/E1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141958; c=relaxed/simple;
	bh=xaZwswDwgMMYH9vEvK3X/1XYODWeoNo/veR2cT7F7+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knGF7V77qMPOKWvhDj5wTk2W7bJ6mAbV7SzEiP0T1SX3ZPjO7jolzg1FNgffx1lM7DqxKUkXb0dbXUsUzFqU/Vh7sJCkBE1+xpIRMZkzMXJP3aa1NV9SMIesLMrJbhwRCO822nZrAjlQxoK5GtGPCdJiGP82Jt0W6GON00JlIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NDvdKq9u; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PC3x5t001647;
	Mon, 25 Aug 2025 17:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gpWnExHb1upyt8hMs
	xgYZbWheuUsGOwmHno5X8ZygwE=; b=NDvdKq9u4Z6SuAShE+f+BETM9OJ17BTrK
	emFH9KFh1WwkZzWC5oSNMQzka0ESAF7aUPD2AiRirMmR6lL4QvH8NCDDZogVA3Nr
	ZapstH44H8AZkVw5bb4Ajz834HfOXruIEGGZ1loErRWy4yxn81eMbB7vkZqG8zu/
	l6XrkJocVKJLZENzwu1Li5PpF6rt2wYowY80Aq782IUrunNsqoR/cocg+4UDKzBH
	b7dZEkLmh4zA2Wp4W5jZNAmjhPfkROX13flQRxMW7nKAHnRvLXGiPyjDIseOJlLf
	baWEwXcIoL5F7OF3gsIXhIHYYks9M6fKK5OTT+1u28cqZrYu8YtZA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557t98r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PFMVY9018009;
	Mon, 25 Aug 2025 17:12:31 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qtp36n68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:31 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCTLq26083948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:29 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 920DB58056;
	Mon, 25 Aug 2025 17:12:29 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98EC65804E;
	Mon, 25 Aug 2025 17:12:28 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:28 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 1/9] PCI: Avoid restoring error values in config space
Date: Mon, 25 Aug 2025 10:12:18 -0700
Message-ID: <20250825171226.1602-2-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825171226.1602-1-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Fu7oOhOhzZd1Wv1j0pc4HkgObdpetU4
X-Proofpoint-ORIG-GUID: _Fu7oOhOhzZd1Wv1j0pc4HkgObdpetU4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX9b2A7TGCSLnm
 efPLsC4T3Xzz3hiPFQh6nrRSaLBWKdSLWN/RT9lXKScLXeICtsLhYwj9uTeLagaunNRUxV/LS1V
 PWDRj0P2gXSy/bUWY+jqc4Mh8Cj+qHTphSxbJDef+qAhHNMHHm91Bb0NyDe799t4xcj2NXYNQMR
 g9p4DtuC3HNJgvnr7yiwhn0wGN14K95IVT2ZkHUQrxMN9wAnytE3SHEaMJ+5fQ8Hd7ZreFeNuF1
 tASkpuJJYmttJhgdKNFsHx3gSHyq6jiO2d7qBVad4LRXM3S5q+ax/kD1mdw52YXgdb8vp8zcEFn
 XZDfDgSRnX6QtaRem2VP3wL8MXZb4AbUhqTjOSyCyoYBpGjuz5/Z6rzs/YMp/d7fHNDlh7kj91Y
 r3lUVhxD
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68ac9980 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=m1QfOrpfu5IsAf0OiGAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

The current reset process saves the device's config space state before
reset and restores it afterward. However, when a device is in an error
state before reset, config space reads may return error values instead of
valid data. This results in saving corrupted values that get written back
to the device during state restoration. Add validation to prevent writing
error values to the device when restoring the config space state after
reset.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0f4d98036cd..0dd95d782022 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1825,6 +1825,9 @@ static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
 	if (!force && val == saved_val)
 		return;
 
+	if (PCI_POSSIBLE_ERROR(saved_val))
+		return;
+
 	for (;;) {
 		pci_dbg(pdev, "restore config %#04x: %#010x -> %#010x\n",
 			offset, val, saved_val);
-- 
2.43.0


