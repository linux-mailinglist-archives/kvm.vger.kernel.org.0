Return-Path: <kvm+bounces-55660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C73B34861
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FC1C1A84AC6
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9C41308F1F;
	Mon, 25 Aug 2025 17:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b+8Mxnqb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408DE305E21;
	Mon, 25 Aug 2025 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141965; cv=none; b=MUOdGThPOmtqgY3mmqi9Otxk8Dj7pl7vB1Vo5cB90Td5vpjznaLTdwRAQoi8d0VlHMShSBExGGpp96jL+33kv6nsMJrGmxXTXu4XVZ+wJQnMvKOhO1uTnnHLbb5TvRaRbNNf6439aNqWEDDWgISgDiavcQuU2r3645xTgHfgH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141965; c=relaxed/simple;
	bh=ytFXbNEKbWNWIa4e99DqMpdEgtgPube/J3VaS5HzAEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u30gbGN5PkfUD6XN3RgtJjF3gSEVOq6DKFRODxb9yJPOxk2c/UR4ifxCooE+0Gt/9iiet82KqhqE9onHNl9dRAJC/iVHEPHbAOLIRpiH7xqrTkidMSlANuKdPA0o53513QzQTwxoIBTUkjiHTkLJI6AX7W7C/tFVhwbn92kp+nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b+8Mxnqb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PBu3Vu032397;
	Mon, 25 Aug 2025 17:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wJWMYHMfvbzU5BQsW
	YZErSvZaRLa/7xMVP6aVFziDXk=; b=b+8MxnqbxnHFXft1I8gfs8FtCKCXmERbp
	fIipRT/eTQBJHkn9/gj+lV3tF36tiypqM9qOeO7KTQ27BePhSPaohn916DGN0CLJ
	953x3H65AkQlCVBISGiRT8q2A08W+9owK1Jo4jT5Ao0CfiYCneMHamla8x+d/3OV
	77i0l7gOiGGoe1fqgu1h3MMnjnb8pYBy1oY6yDBB6p5ACSnmg8rp+fiSB4YKhfyT
	a2m4iGbQTb7pc1RkBWe2iNs0Zn9EFn48bNO1iSZ669YsmbV3A51/XUiF4sLQvXQi
	aK87uPRYbfp2ZIv9stjPEQSg+4VHct7v1UJj+gQ3tcGhXX78lJ/Aw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5ava7ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PDoxva002492;
	Mon, 25 Aug 2025 17:12:39 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qrypex8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:39 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCbhO10945346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:38 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0CD858062;
	Mon, 25 Aug 2025 17:12:37 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA6225804E;
	Mon, 25 Aug 2025 17:12:36 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:36 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 8/9] vfio: Add a reset_done callback for vfio-pci driver
Date: Mon, 25 Aug 2025 10:12:25 -0700
Message-ID: <20250825171226.1602-9-alifm@linux.ibm.com>
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
X-Proofpoint-GUID: y4Jlc0_SDS9QSYr3sj42wzE1B7ILMrZV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfXxfRH8MAuc+3D
 9hiU9mJOWX/EBJNwBL4mWV7EGAZUS/aLqyVsNJver4nGAxEG6ihzhGkstt99hzyY/LrwI23Q/Gb
 VD1HNmnAWTjVpRYlzRVLU+hG6RtojroHEE5lkk2gYLtOB+rMULSQ/kThAxF+Ei+ga8Oq9LAk8EG
 rsOdDvo0eHi3u25OcqTcHKr+X2YLNYzPTXKdkF2Uk8SW6sbRlG8NTObmABTtSyu0NJFj+Adh8qp
 yJSDTkdi13DDNz9incwLNT3dZV5yTGHP4/9vK0BkDXKiIHQqv5ArphngMG7frd8yQSIBewrfrqF
 gtQ8kXQ5T3byJL2uWiuTpCZwOubmVMgwN4B/Wz1roV4Ba0qt8UC+n+AAc59Bk5GLiPJe4S/bBp9
 WwUxG4CS
X-Proofpoint-ORIG-GUID: y4Jlc0_SDS9QSYr3sj42wzE1B7ILMrZV
X-Authority-Analysis: v=2.4 cv=SNNCVPvH c=1 sm=1 tr=0 ts=68ac9988 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=hcTHx3Z5Akp3fEzgVBYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230021

On error recovery for a PCI device bound to vfio-pci driver, we want to
recover the state of the device to its last known saved state. The callback
restores the state of the device to its initial saved state.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 378adb3226db..f2fcb81b3e69 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2241,6 +2241,17 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
+static void vfio_pci_core_aer_reset_done(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+
+	if (!vdev->pci_saved_state)
+		return;
+
+	pci_load_saved_state(pdev, vdev->pci_saved_state);
+	pci_restore_state(pdev);
+}
+
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 				  int nr_virtfn)
 {
@@ -2305,6 +2316,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
 	.error_detected = vfio_pci_core_aer_err_detected,
+	.reset_done = vfio_pci_core_aer_reset_done,
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
-- 
2.43.0


