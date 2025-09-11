Return-Path: <kvm+bounces-57349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7CFB53B8C
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:34:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 306714E32BE
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE097372883;
	Thu, 11 Sep 2025 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XwzImf9K"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E7F36CC9C;
	Thu, 11 Sep 2025 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615600; cv=none; b=QZC0zCZ9YKfOJ5AAznuxb12iLvx005H1Em8AifZv0oS+hSkrqbZ9tGLg4t59VO+yvA2f4QeiZ/DeDpF8iMZw/cCGvaLY5u99PiLvmXJief3Xv67xEgv7nx5QA5Rl4v3woxb0X9XLvioXFsN3THj+8olVox0bd+bjNz1LP9wfaVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615600; c=relaxed/simple;
	bh=BE/Fyb7bqjXOtPStqy41nzTS3JQmUv2CPtP6DDV37Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0u12BTU1FpeToJQZ9Cm8UiWs8VwpsLlIOUlD+mRRdfOHk9P941oWDKAGE2Tk6FcRWN21nV+O5VxrMoM6J1bq/N9cQrtsglSNI4fom40djMlDR22WfL8pElf4HQgS5OTklbGd3X+LkH5HTQHVRi8PyRWVlyQjBa29bEeBS4Kx3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XwzImf9K; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDRAnK015943;
	Thu, 11 Sep 2025 18:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Gtdx3YR1RuO0lD7+S
	BIUxw8c1f6dMRxwCpmb72Rlu48=; b=XwzImf9KBb0bS4gUSRcXEHZwa3BXhIgk0
	QvPCMCtldmxWHn/AFuHQYVZ2TqbWcJABdqQe3i41SQ12DbjJdW70I4UNWCq3tGxN
	5VCW9FsnaQEQGfj1Cq2hjr9JJagWQYtUm/vSxso4+vnW81HTq+E3rYJ0CF6qd2Z9
	x7UWWADTBYS9u1FMJEpBLGS+FDH9XY9g8bkjai2/56vox0tsXL/E3UDFvOCdOtEe
	8iZd8yLAJs1DRw/lcz7pVZkSx3bS1Sg/gkx3JfQWMM160aYbN6JuoEe8T9VZemYb
	3PIvYXmXk2ZwcU25tatLZ+wfxBN2Xm/bd1jVsnIfZ/T/lFmbkKfFw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffpp7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHNMPl007982;
	Thu, 11 Sep 2025 18:33:14 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109py8me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:14 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXCjf33620234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:12 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 733975805D;
	Thu, 11 Sep 2025 18:33:12 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFE7558058;
	Thu, 11 Sep 2025 18:33:11 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:11 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 05/10] s390/pci: Restore IRQ unconditionally for the zPCI device
Date: Thu, 11 Sep 2025 11:33:02 -0700
Message-ID: <20250911183307.1910-6-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: a-e4gsY4stPXg38BSndp-JldLYl69B9F
X-Proofpoint-GUID: a-e4gsY4stPXg38BSndp-JldLYl69B9F
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c315eb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=ove13Onh8FEOJJhcmoIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfXwvUc8iDYaR+E
 q2msXi8GLaY/1oqdnLX0SoXYwKAmqNbR++uDjI01SPhqjnE8TOEvILWkAkjkr18yDb6biepOrVT
 HFLHtM9wGFyReY6GWr7ZuK7U80Xfp4S3XR1PS+olsLOg4ux1qZxN+zTBZjwjQXPLVZd56Zzc9Ic
 zM+tU2oEpaUoXPx1R4U3wNxEdjw/pdymVqbHNK5IC6bojhLjYeoU1YfIyI+170pLJahx51LNeOb
 QmYZEkXecrtra6zQ/2+uGDWCKVA7yj4rKjzfRiZAhP6eLIU+2xfqJQ42iyL0uMyRgMmic109BCb
 Xc9GcDXqucF3YcuMp2YpnhK1at3LsZOMnhSksuhFxpyQ2bTVm42cT6k3X6gvkpMZOYml+glhgPV
 7GFKnP3+
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020

Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
resetting a zPCI device.

Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
mentions zpci_clear_irq() being called in the path for zpci_hot_reset_device().
But that is not the case anymore and these functions are not called
outside of this file.

However after a CLP disable/enable reset, the device's IRQ are
unregistered, but the flag zdev->irq_registered does not get cleared. It
creates an inconsistent state and so arch_restore_msi_irqs() doesn't
correctly restore the device's IRQ. This becomes a problem when a PCI
driver tries to restore the state of the device through
pci_restore_state(). Restore IRQ unconditionally for the device and remove
the irq_registered flag as its redundant.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/include/asm/pci.h | 1 -
 arch/s390/pci/pci_irq.c     | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 41f900f693d9..aed19a1aa9d7 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -145,7 +145,6 @@ struct zpci_dev {
 	u8		has_resources	: 1;
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
-	u8		irqs_registered	: 1;
 	u8		tid_avail	: 1;
 	u8		rtr_avail	: 1; /* Relaxed translation allowed */
 	unsigned int	devfn;		/* DEVFN part of the RID*/
diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 84482a921332..e73be96ce5fe 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -107,9 +107,6 @@ static int zpci_set_irq(struct zpci_dev *zdev)
 	else
 		rc = zpci_set_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 1;
-
 	return rc;
 }
 
@@ -123,9 +120,6 @@ static int zpci_clear_irq(struct zpci_dev *zdev)
 	else
 		rc = zpci_clear_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 0;
-
 	return rc;
 }
 
@@ -427,8 +421,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
-	if (!zdev->irqs_registered)
-		zpci_set_irq(zdev);
+	zpci_set_irq(zdev);
 	return true;
 }
 
-- 
2.43.0


