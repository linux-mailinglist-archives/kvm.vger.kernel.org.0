Return-Path: <kvm+bounces-55655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E92CB34850
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31FA31A85A47
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76885302CDF;
	Mon, 25 Aug 2025 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F/Ye7RKN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5E026E175;
	Mon, 25 Aug 2025 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141958; cv=none; b=gX15TPYCT4HRLsnO8/vejq/2rjrn480/VwSr2JVpFE80Z+B93dJVyh3CE7d+8Get6r8Q/Wi7VS6/3wyqO3DP10TxTTW/I1usVOljF3QL9VWRHUrVU6tO3BtXWPsF0DI4Hj6rc71Az45CQBYwAXloKg4AYj7bZrKnfcucZyTfhbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141958; c=relaxed/simple;
	bh=ltgFhqa+XtMSF+Bjmt4iYmt8qr47pAB7mkYgCNoJoDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppo+W0Mv9RupgM/nVu3gCU6fQNU/tzhB6lKOu4NYHrxJW0KB7vNzKVyhvjVbEtSn5zOieP413KVD0xxa93HtlfqRUPjhZQaMXwUp+zw7xiqoh4uKhyhujk4p8GtJYqEhMpHUt38yHUmt9+py8768W3MGDbDpHJVpF8nKBgiy68w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F/Ye7RKN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PFIbdK019576;
	Mon, 25 Aug 2025 17:12:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=N9e1A7GRC0k3UHgV9
	UW5Oj57qEr5SNvLH8V/m4UDCpE=; b=F/Ye7RKNuEbS9yq81/L9Ugo+vDj3VpMeT
	PoS3riUhL+hLBvnmg/v/HsrZ59vCNWH0hGYytup/cCugdBEGy5jlAuck4lhfzk1I
	8Eg5z3paoGaEHLaqAWeOW1GFbzUoeZ7EAEAgaHQvqDAADTIkIIkimofb/5e/l3Zy
	oUAnb/8qTppCWkF7h2KkDEB/C5K+lhOhfHn9aqXbCF3mZiGIcFxRrWPh7enRfirI
	HHvSkjo35J3PB0bgpugB6u82tf/kioWVF7vWYRmrTZg7UECHVdsdwynOBgHlrtDd
	wvUubHyJ/hEaSpUJWxw3G/900RvCpBUwzDgx12dPB+CxEFYduC/9Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q32vafy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PDroos002561;
	Mon, 25 Aug 2025 17:12:32 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qrypex85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:32 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCUpg21234332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:30 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8C525804E;
	Mon, 25 Aug 2025 17:12:30 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD88158054;
	Mon, 25 Aug 2025 17:12:29 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:29 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 2/9] PCI: Add additional checks for flr and pm reset
Date: Mon, 25 Aug 2025 10:12:19 -0700
Message-ID: <20250825171226.1602-3-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 3K2Au8MkW9NI1CBdIdT1wG-LY7i1zK_Z
X-Proofpoint-GUID: 3K2Au8MkW9NI1CBdIdT1wG-LY7i1zK_Z
X-Authority-Analysis: v=2.4 cv=AfSxH2XG c=1 sm=1 tr=0 ts=68ac9980 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=WWBBxJq8oJm8QP7TXnYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAwMCBTYWx0ZWRfX4W5gxYNMnmOT
 gzcEu1tzNyF7zUnr8Hs8fJtQv4ydQV1tcFGrIt7l/R3sqMunsltCHnjUIbUcLe+rXG2Rx5tO43d
 PXfz8vn0VtWTXAR92hGDOy3oXNJuAYLS3miyPqyw9RoxrKGAql5tZ29gI6R4vXkCqqkUXeDO1Ub
 WV5uVCggjLjGR7I6YEnxP2bWQRAWN+LyN+CEM55i/wvuO3aHr95ZhzDvFKiWkV+bj65EJ1o+IDa
 SiTrrTDETc0jpnatfaEgQVO/x7UaVgQaA0fQqmL7/hw6rzjIhX3fVRyn7VsDeC9SdXqdMLMvucM
 G2KxRN9S1MW1H1XlRu8Dd4W4EQfnAPFszAOGwTDttPUtkw/rBm1KDDbMkM24fuQBZIVNLM7vC8L
 679zn0Hp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230000

If a device is in an error state, then any reads of device registers can
return error value. Add addtional checks to validate if a device is in an
error state before doing an flr or pm reset.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0dd95d782022..a07bdb287cf3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4560,12 +4560,17 @@ EXPORT_SYMBOL_GPL(pcie_flr);
  */
 int pcie_reset_flr(struct pci_dev *dev, bool probe)
 {
+	u32 reg;
+
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return -ENOTTY;
 
 	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
 		return -ENOTTY;
 
+	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg))
+		return -ENOTTY;
+
 	if (probe)
 		return 0;
 
@@ -4640,6 +4645,8 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 		return -ENOTTY;
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &csr);
+	if (PCI_POSSIBLE_ERROR(csr))
+		return -ENOTTY;
 	if (csr & PCI_PM_CTRL_NO_SOFT_RESET)
 		return -ENOTTY;
 
-- 
2.43.0


