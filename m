Return-Path: <kvm+bounces-58676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E454B9AFFF
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:17:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E5B717013E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF183168E5;
	Wed, 24 Sep 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AJ6hpUAr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55521315D4D;
	Wed, 24 Sep 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734202; cv=none; b=L5js0ysJ4z0RhDMQ+aDFGdMGQbp8+LEDJvG+JYTckPR9e46IHj4/cuSsia/6l562u5GDWp57KIvwZbfAYhK9rNWowGbEIPkPRVYkLwlIk0tLZF+lMpm5peA4uJtdsnBrsRt77JoY8qPrIlC6MNjQCckKArzNGKJJS0nKmoa16t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734202; c=relaxed/simple;
	bh=8h6W/NxGRfhYZPUFoRt1M1HE4BoDsDTuTn4z2vyWDiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk6yLezliv5u1hx8P/3n7+FsdBgR460+t5pYAFUbZ00Ffdgsz1BfkCawP6yNf+76FSJ/Kjws4liYNUgOH2jswzqXMqwXpmpfanHFoF6YUFu78Aevb2LXmBJyJ/THc+E5ADSshfCJLqAE5Ki9MaL/ixDI+7DnqRuxyLUp79yWS7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AJ6hpUAr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58O8VVXd009954;
	Wed, 24 Sep 2025 17:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=V4Gf2KInXPKS1c8fY
	bgOafCGDztl/YMJ+4YMF+tdaRY=; b=AJ6hpUArXsLFVLMoxctmcIHKUBjGGoLhb
	x7jDV9ITTZatI7WRYy1C1ehjKudBF7H/aQHpWn/DdTW+a8B3m1dzZ+KYx70Y9hWh
	6uQU6NalhjooGCO0lua2mAtxacpLflBabLV5c7qwLdV+2YRPijFk5/reGDZ+wiI5
	BLJ5wMq9SpegmKDaUBxMJnc+PsqCoBPZTPK5Qc075XN5lG4ajhB6Hw74CvU1zbjK
	peCYYRNAo2D1oy9Yo+VYwIDzV0GCRb+TRlYgfRQl2mF/zl5Aps6q7oF8Xv/K/wtg
	SoCGCGD9+07xJxsgk0wjt96ym+BHIHF3cbv+3ekhCCCBYEbpTRhmg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499n0jru54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OETxsF013599;
	Wed, 24 Sep 2025 17:16:34 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a8tjhgxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:34 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGXUs21692972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:33 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFBE25803F;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EC635805A;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Date: Wed, 24 Sep 2025 10:16:19 -0700
Message-ID: <20250924171628.826-2-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924171628.826-1-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzMyBTYWx0ZWRfX/sdkH6OHo2PC
 cK86U1Cr/hcZH+xtfLg1WIo0XGmLpNHs//6lflMaETDjnSxhyifawrfPN/Dphcn95iczfe6A384
 idi7sFyZi59oYGCMg2yJsEpZGZojzTaTXe2a9ZiGg2jRqHS2VPX4gdiWOclGBcCMoRM2sKqln8U
 QJHPai/ehrfeYaS9au9IiDuxDT8xKBEELr30/pqXc42IjRVDuWVkE6VIK7Zw+SXRJfl7Ls08oCl
 mfQ31VUetYUsBDHUlrcJAFjy1m1nltDIeGmudcQrqITC98UAC6qn2DOvwHbzrW/x+0lbkBaZwyY
 F3ZcnsZQF9x4IcJl38G1m+1CMRMiDP6SfBUfzpPIcSa5curZlxGI/bK8LaUce/v18qo48RYPOce
 V37wqqzz
X-Authority-Analysis: v=2.4 cv=TOlFS0la c=1 sm=1 tr=0 ts=68d42773 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=HJkUYhVlXSnv9HZcNckA:9
X-Proofpoint-ORIG-GUID: 31nBXQQjTugvPz0NcQR0ocnXgWhWt-JT
X-Proofpoint-GUID: 31nBXQQjTugvPz0NcQR0ocnXgWhWt-JT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200033

The current reset process saves the device's config space state before
reset and restores it afterward. However, when a device is in an error
state before reset, config space reads may return error values instead of
valid data. This results in saving corrupted values that get written back
to the device during state restoration.

Avoid saving the state of the config space when the device is in error.
While restoring we only restore the state that can be restored through
kernel data such as BARs or doesn't depend on the saved state.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c      | 25 ++++++++++++++++++++++---
 drivers/pci/pcie/aer.c |  3 +++
 drivers/pci/pcie/dpc.c |  3 +++
 drivers/pci/pcie/ptm.c |  3 +++
 drivers/pci/tph.c      |  3 +++
 drivers/pci/vc.c       |  3 +++
 6 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0f4d98036cd..a3d93d1baee7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1720,6 +1720,9 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
+	if (!dev->state_saved)
+		return;
+
 	/*
 	 * Restore max latencies (in the LTR capability) before enabling
 	 * LTR itself in PCI_EXP_DEVCTL2.
@@ -1775,6 +1778,9 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
+	if (!dev->state_saved)
+		return;
+
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (!save_state || !pos)
@@ -1792,6 +1798,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 int pci_save_state(struct pci_dev *dev)
 {
 	int i;
+	u32 val;
+
+	pci_read_config_dword(dev, PCI_COMMAND, &val);
+	if (PCI_POSSIBLE_ERROR(val)) {
+		pci_warn(dev, "Device config space inaccessible, will only be partially restored\n");
+		return -EIO;
+	}
+
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++) {
 		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
@@ -1854,6 +1868,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
 
 static void pci_restore_config_space(struct pci_dev *pdev)
 {
+	if (!pdev->state_saved) {
+		pci_warn(pdev, "No saved config space, restoring BARs\n");
+		pci_restore_bars(pdev);
+		pci_write_config_word(pdev, PCI_COMMAND,
+				PCI_COMMAND_MEMORY | PCI_COMMAND_IO);
+		return;
+	}
+
 	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
 		pci_restore_config_space_range(pdev, 10, 15, 0, false);
 		/* Restore BARs before the command register. */
@@ -1906,9 +1928,6 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
  */
 void pci_restore_state(struct pci_dev *dev)
 {
-	if (!dev->state_saved)
-		return;
-
 	pci_restore_pcie_state(dev);
 	pci_restore_pasid_state(dev);
 	pci_restore_pri_state(dev);
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index e286c197d716..e6023ffbf94d 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -361,6 +361,9 @@ void pci_restore_aer_state(struct pci_dev *dev)
 	if (!aer)
 		return;
 
+	if (!dev->state_saved)
+		return;
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index fc18349614d7..e0d7034c2cd8 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -67,6 +67,9 @@ void pci_restore_dpc_state(struct pci_dev *dev)
 	if (!pci_is_pcie(dev))
 		return;
 
+	if (!dev->state_saved)
+		return;
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 65e4b008be00..78613000acfb 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -112,6 +112,9 @@ void pci_restore_ptm_state(struct pci_dev *dev)
 	if (!ptm)
 		return;
 
+	if (!dev->state_saved)
+		return;
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index cc64f93709a4..c0fa1b9a7a78 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -435,6 +435,9 @@ void pci_restore_tph_state(struct pci_dev *pdev)
 	if (!pdev->tph_enabled)
 		return;
 
+	if (!pdev->state_saved)
+		return;
+
 	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
index a4ff7f5f66dd..00609c7e032a 100644
--- a/drivers/pci/vc.c
+++ b/drivers/pci/vc.c
@@ -391,6 +391,9 @@ void pci_restore_vc_state(struct pci_dev *dev)
 {
 	int i;
 
+	if (!dev->state_saved)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
 		int pos;
 		struct pci_cap_saved_state *save_state;
-- 
2.43.0


