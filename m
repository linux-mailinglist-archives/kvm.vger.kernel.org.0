Return-Path: <kvm+bounces-57345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B6449B53B7C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 914D94E3333
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2568636C09D;
	Thu, 11 Sep 2025 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WOnYSsoQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC56248891;
	Thu, 11 Sep 2025 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615597; cv=none; b=A1thi1LXIDyrFyx+xPg+Fwa9ECBMzvvo0TQYKroqZM+cY6gz7ow9pzPM3XtE6PfagH7iyZ949AWZDcc1Hj1jh9zZ9AUehcVTJAXYGPt2VGC3SESyICVT0shfUUfZjIzNXWpPtnIE1qnTfIIqUkoSEPT/xA2zWep/ZlNUrusM1RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615597; c=relaxed/simple;
	bh=tVxKYpp9mqC89SBvbFtEfvrwRZWcJQBcFJ4zP92d8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDl8b7RJmOcS9pTmTRCn4v/nENez7Yz278jdHJays7cd1i77mONJokPob5eVZ8mmRTLylt0BbixBa7D0l19FKxENKC9k0PYUOoOY2qIHTGFQigdtu+UAKdsPRrQfjqrv+oECPG0FQL10g2CZ/YS0B1o7Vt/s7NSf7nvztZG/zYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WOnYSsoQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BGMJAU030119;
	Thu, 11 Sep 2025 18:33:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MB/690h1TmnHT3IRM
	wyhXMcnu5RN6hzXZqJq2XyjfTo=; b=WOnYSsoQQ665Ld9XOF4JoKKu5xc20pKby
	ikyX5CtpccPFV+9JxrStO52xiNkekP1rsZ9cByngQtL12UthbypExT5/XJe0fT0i
	XtESBuoYrG5azvpdlMOZlqmh39fbZncXcDMP4cafKMgrhwsrVE1ZyHm+tnrTYGOZ
	teN1aNStnkDqRBznTL0TUek/gm3OBArrndLeHFLKAlWTlYcHuN8xO5Dm4qqKFZ9Y
	Lpm+P6wmetdzALUUHDn6Zl5SlPdiRU4qa3W6HTfn6+4txFeJFayzQQ3aQlyeXx1G
	IJ1yQPMFTKycBmzBlquqnpyweAbi91CS45/nKN4ePwsdDSCKKua0w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukeu8j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BIJf1G001172;
	Thu, 11 Sep 2025 18:33:10 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203q0ar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:10 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIX9uc18088628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:09 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38FD758059;
	Thu, 11 Sep 2025 18:33:09 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8157558058;
	Thu, 11 Sep 2025 18:33:08 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:08 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 01/10] PCI: Avoid saving error values for config space
Date: Thu, 11 Sep 2025 11:32:58 -0700
Message-ID: <20250911183307.1910-2-alifm@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250911183307.1910-1-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX/29pfwtsYXQo
 6AOtezG1CEVVJMmemLRSRp3Dq3hyKEGce8Fcw/jNBKYBbGX7WsCEAYkv+FrM0fG2Rhp3hoP8P9T
 oi9qHbmwpJg6K3J50Yy+PdzBC8bAP7DF3gDm6VXHpNfi/PG9YwNlZQsU7N0hIWDHzUEV8nIKPpO
 RdApmWbrb+D40Z5WFJ6g0YUdhbSw4ELBX8jzzv09SZoH+N0maT5WcsT41clO12HrPfgk34/wDVw
 aj40efKV+6Hl50e0+c8eAoP2fxcCKGZX9sqDTJb5v1HP7mzVl7GQ6HplrV6zytTn0W5RRo6c2Tf
 msBzwvInfv/HX/PpNTdXBINFfN//j1VJq9CrvVHUcIyLT2eOK0wMyDpdrxFqDu0HH4cM8qjB+fm
 9mWZK+oh
X-Proofpoint-ORIG-GUID: Xs7WaiZhO0jIyDMYWySz7t3iesq7jDsX
X-Proofpoint-GUID: Xs7WaiZhO0jIyDMYWySz7t3iesq7jDsX
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c315e7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=fYhOAy_zjFLNdzqrsEIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

The current reset process saves the device's config space state before
reset and restores it afterward. However, when a device is in an error
state before reset, config space reads may return error values instead of
valid data. This results in saving corrupted values that get written back
to the device during state restoration.

Avoid saving the state of the config space when the device is in error.
While restoring we only restorei the state that can be restored through
kernel data such as BARs or doesn't depend on the saved state.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c      | 29 ++++++++++++++++++++++++++---
 drivers/pci/pcie/aer.c |  5 +++++
 drivers/pci/pcie/dpc.c |  5 +++++
 drivers/pci/pcie/ptm.c |  5 +++++
 drivers/pci/tph.c      |  5 +++++
 drivers/pci/vc.c       |  5 +++++
 6 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0f4d98036cd..4b67d22faf0a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1720,6 +1720,11 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring pcie state, no saved state");
+		return;
+	}
+
 	/*
 	 * Restore max latencies (in the LTR capability) before enabling
 	 * LTR itself in PCI_EXP_DEVCTL2.
@@ -1775,6 +1780,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 	struct pci_cap_saved_state *save_state;
 	u16 *cap;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring pcix state, no saved state");
+		return;
+	}
+
 	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_PCIX);
 	pos = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (!save_state || !pos)
@@ -1792,6 +1802,14 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 int pci_save_state(struct pci_dev *dev)
 {
 	int i;
+	u16 val;
+
+	pci_read_config_word(dev, PCI_DEVICE_ID, &val);
+	if (PCI_POSSIBLE_ERROR(val)) {
+		pci_warn(dev, "Device in error, not saving config space state\n");
+		return -EIO;
+	}
+
 	/* XXX: 100% dword access ok here? */
 	for (i = 0; i < 16; i++) {
 		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
@@ -1854,6 +1872,14 @@ static void pci_restore_config_space_range(struct pci_dev *pdev,
 
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
@@ -1906,9 +1932,6 @@ static void pci_restore_rebar_state(struct pci_dev *pdev)
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
index e286c197d716..dca3502ef669 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -361,6 +361,11 @@ void pci_restore_aer_state(struct pci_dev *dev)
 	if (!aer)
 		return;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring aer state, no saved state");
+		return;
+	}
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ERR);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index fc18349614d7..62c520af71a7 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -67,6 +67,11 @@ void pci_restore_dpc_state(struct pci_dev *dev)
 	if (!pci_is_pcie(dev))
 		return;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring dpc state, no saved state");
+		return;
+	}
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_DPC);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 65e4b008be00..7b5bcc23000d 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -112,6 +112,11 @@ void pci_restore_ptm_state(struct pci_dev *dev)
 	if (!ptm)
 		return;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring ptm state, no saved state");
+		return;
+	}
+
 	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_PTM);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index cc64f93709a4..f0f1bae46736 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -435,6 +435,11 @@ void pci_restore_tph_state(struct pci_dev *pdev)
 	if (!pdev->tph_enabled)
 		return;
 
+	if (!pdev->state_saved) {
+		pci_warn(pdev, "Not restoring tph state, no saved state");
+		return;
+	}
+
 	save_state = pci_find_saved_ext_cap(pdev, PCI_EXT_CAP_ID_TPH);
 	if (!save_state)
 		return;
diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
index a4ff7f5f66dd..fda435cd49c1 100644
--- a/drivers/pci/vc.c
+++ b/drivers/pci/vc.c
@@ -391,6 +391,11 @@ void pci_restore_vc_state(struct pci_dev *dev)
 {
 	int i;
 
+	if (!dev->state_saved) {
+		pci_warn(dev, "Not restoring vc state, no saved state");
+		return;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(vc_caps); i++) {
 		int pos;
 		struct pci_cap_saved_state *save_state;
-- 
2.43.0


