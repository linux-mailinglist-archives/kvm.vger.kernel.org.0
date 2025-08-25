Return-Path: <kvm+bounces-55661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F84B34868
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83175175BE3
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA52308F3D;
	Mon, 25 Aug 2025 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bfQhkosn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4763054C8;
	Mon, 25 Aug 2025 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141966; cv=none; b=LCW8UzV5s6gEBHuGBGFI5222LiCwNN05AxJ1Zapw0WIcHkCDLclvuhgddkaEfZpXMH3ANF7wg7lCVZFfvqcwgD4YBWBtD3+CsEdAWzE9EzFqkdCfW6k7Wo978i9ZDtiPHtz222/OJ4gQGooe2nBnm1d6r4nnfXgeWqRPlxqo9Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141966; c=relaxed/simple;
	bh=NzQE0JrNlIZtKxZDh/CaFkHSC/E5PRD30PkB+w2hkB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaYWErIX38MrlPGAeCKM6foAIpXvEJ8QlrT7MonCVDsLHcNsw4M/vG7NjufhuKv4ZYBjIS61w/buQSC8P/0YwCTU0VRuvzOK31kVRwXlsqXTaYakH3+grg+ijJoXpr8/lKsjOcQps2aFQPJP4S7u+5n41lUtCvsUJEEJx1g5mvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bfQhkosn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PCimsp021280;
	Mon, 25 Aug 2025 17:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IjwZ53nzS+82KSHX1
	vCRae+coPn2P/6vTVF240yzO2Q=; b=bfQhkosnnq/NMNb/bGkPpHbmxq1R5XgSR
	o9qUF9/yOsPyfZS0Du+LClfrofdW09YW6DootgTmam+dCalks1jAi91GdzCFPjXs
	NY//jm9pPxYNfIt8XRObp39O+4rL/vvycK3EKuiz7TODrPmnLMHJ1WlstUzhvkJn
	O3evcvr1JHOPEqqzQOyKjXGWiEgE9UFB9aqF3XNxL0Loc2MAmyZw+nz+bUul+rO5
	qgfLamGTlTax/+AVLy4jFZm0SdVOUlSWICzBO0Nsy7JR1dBlk3Pj3KAAh4gftYyg
	IYQZOgizrWWtIHx0bNg41wpGKh4U81DNez3AQUq1gIaaBvzsaMuHQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q9751jxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PGg1nA007443;
	Mon, 25 Aug 2025 17:12:36 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyu74qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:36 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCZmS590476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:35 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A22A5804E;
	Mon, 25 Aug 2025 17:12:35 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D49A58054;
	Mon, 25 Aug 2025 17:12:34 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:34 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 6/9] s390/pci: Store PCI error information for passthrough devices
Date: Mon, 25 Aug 2025 10:12:23 -0700
Message-ID: <20250825171226.1602-7-alifm@linux.ibm.com>
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
X-Proofpoint-GUID: r7YP_xOdU2giQxu_M-tgYySbnm_XzMvU
X-Proofpoint-ORIG-GUID: r7YP_xOdU2giQxu_M-tgYySbnm_XzMvU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX43/yvd5mSAlj
 Zwtk88nz5/6Rl+A2Y8PldarIHz0NmKKMXWxY5MzQGKiUtMElMIG1vJKpWegidHmaWGnEY6TCvX8
 lWRYTeYHTDUuOM0mVntv5TFdwo8g5D0pnld7G+tbCQ3d0B9ih02SyN0016HM1ZnibcRF22g4+70
 alcf+aqNVUnNcNJ1DCElLY9LS6WhJzsrR1oSvNtElD4nHsYDIYNRPpqkTBQ9dcdTwkmir06xPFW
 qUpCQos/wBl1aemI5j9VAqwyWSXoyFk8wt5OHfhNFzXdmfCoZ+5iM6o9GZltD4ZuLPep2eitu5p
 cZA0/2DqgJHoXcsG2SXsL/iWGs9yQtOHJFOMEq/LG/nxKWr06YNYoVtn3kgTJ7rlE2oltVq4cxX
 JFPA52Ba
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68ac9985 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=AhHhU-3714CzMtceQIIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071

For a passthrough device we need co-operation from user space to recover
the device. This would require to bubble up any error information to user
space.  Let's store this error information for passthrough devices, so it
can be retrieved later.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      | 28 ++++++++++
 arch/s390/pci/pci.c              |  1 +
 arch/s390/pci/pci_event.c        | 95 +++++++++++++++++++-------------
 drivers/vfio/pci/vfio_pci_zdev.c |  2 +
 4 files changed, 88 insertions(+), 38 deletions(-)

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index f47f62fc3bfd..72e05af90e08 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -116,6 +116,31 @@ struct zpci_bus {
 	enum pci_bus_speed	max_bus_speed;
 };
 
+/* Content Code Description for PCI Function Error */
+struct zpci_ccdf_err {
+	u32 reserved1;
+	u32 fh;                         /* function handle */
+	u32 fid;                        /* function id */
+	u32 ett         :  4;           /* expected table type */
+	u32 mvn         : 12;           /* MSI vector number */
+	u32 dmaas       :  8;           /* DMA address space */
+	u32 reserved2   :  6;
+	u32 q           :  1;           /* event qualifier */
+	u32 rw          :  1;           /* read/write */
+	u64 faddr;                      /* failing address */
+	u32 reserved3;
+	u16 reserved4;
+	u16 pec;                        /* PCI event code */
+} __packed;
+
+#define ZPCI_ERR_PENDING_MAX 16
+struct zpci_ccdf_pending {
+	size_t count;
+	int head;
+	int tail;
+	struct zpci_ccdf_err err[ZPCI_ERR_PENDING_MAX];
+};
+
 /* Private data per function */
 struct zpci_dev {
 	struct zpci_bus *zbus;
@@ -191,6 +216,8 @@ struct zpci_dev {
 	struct iommu_domain *s390_domain; /* attached IOMMU domain */
 	struct kvm_zdev *kzdev;
 	struct mutex kzdev_lock;
+	struct zpci_ccdf_pending pending_errs;
+	struct mutex pending_errs_lock;
 	spinlock_t dom_lock;		/* protect s390_domain change */
 };
 
@@ -316,6 +343,7 @@ void zpci_debug_exit_device(struct zpci_dev *);
 int zpci_report_error(struct pci_dev *, struct zpci_report_error_header *);
 int zpci_clear_error_state(struct zpci_dev *zdev);
 int zpci_reset_load_store_blocked(struct zpci_dev *zdev);
+void zpci_cleanup_pending_errors(struct zpci_dev *zdev);
 
 #ifdef CONFIG_NUMA
 
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index cd6676c2d602..f795e05b5001 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -823,6 +823,7 @@ struct zpci_dev *zpci_create_device(u32 fid, u32 fh, enum zpci_state state)
 	mutex_init(&zdev->state_lock);
 	mutex_init(&zdev->fmb_lock);
 	mutex_init(&zdev->kzdev_lock);
+	mutex_init(&zdev->pending_errs_lock);
 
 	return zdev;
 
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index 541d536be052..ac527410812b 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -18,23 +18,6 @@
 #include "pci_bus.h"
 #include "pci_report.h"
 
-/* Content Code Description for PCI Function Error */
-struct zpci_ccdf_err {
-	u32 reserved1;
-	u32 fh;				/* function handle */
-	u32 fid;			/* function id */
-	u32 ett		:  4;		/* expected table type */
-	u32 mvn		: 12;		/* MSI vector number */
-	u32 dmaas	:  8;		/* DMA address space */
-	u32		:  6;
-	u32 q		:  1;		/* event qualifier */
-	u32 rw		:  1;		/* read/write */
-	u64 faddr;			/* failing address */
-	u32 reserved3;
-	u16 reserved4;
-	u16 pec;			/* PCI event code */
-} __packed;
-
 /* Content Code Description for PCI Function Availability */
 struct zpci_ccdf_avail {
 	u32 reserved1;
@@ -76,6 +59,41 @@ static bool is_driver_supported(struct pci_driver *driver)
 	return true;
 }
 
+static void zpci_store_pci_error(struct pci_dev *pdev,
+				 struct zpci_ccdf_err *ccdf)
+{
+	struct zpci_dev *zdev = to_zpci(pdev);
+	int i;
+
+	mutex_lock(&zdev->pending_errs_lock);
+	if (zdev->pending_errs.count >= ZPCI_ERR_PENDING_MAX) {
+		pr_err("%s: Cannot store PCI error info for device",
+				pci_name(pdev));
+		mutex_unlock(&zdev->pending_errs_lock);
+		return;
+	}
+
+	i = zdev->pending_errs.tail % ZPCI_ERR_PENDING_MAX;
+	memcpy(&zdev->pending_errs.err[i], ccdf, sizeof(struct zpci_ccdf_err));
+	zdev->pending_errs.tail++;
+	zdev->pending_errs.count++;
+	mutex_unlock(&zdev->pending_errs_lock);
+}
+
+void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
+{
+	struct pci_dev *pdev = NULL;
+
+	mutex_lock(&zdev->pending_errs_lock);
+	pdev = pci_get_slot(zdev->zbus->bus, zdev->devfn);
+	if (zdev->pending_errs.count)
+		pr_err("%s: Unhandled PCI error events count=%zu",
+				pci_name(pdev), zdev->pending_errs.count);
+	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));
+	mutex_unlock(&zdev->pending_errs_lock);
+}
+EXPORT_SYMBOL_GPL(zpci_cleanup_pending_errors);
+
 static pci_ers_result_t zpci_event_notify_error_detected(struct pci_dev *pdev,
 							 struct pci_driver *driver)
 {
@@ -169,7 +187,8 @@ static pci_ers_result_t zpci_event_do_reset(struct pci_dev *pdev,
  * and the platform determines which functions are affected for
  * multi-function devices.
  */
-static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
+static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev,
+							  struct zpci_ccdf_err *ccdf)
 {
 	pci_ers_result_t ers_res = PCI_ERS_RESULT_DISCONNECT;
 	struct zpci_dev *zdev = to_zpci(pdev);
@@ -188,13 +207,6 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 	}
 	pdev->error_state = pci_channel_io_frozen;
 
-	if (needs_mediated_recovery(pdev)) {
-		pr_info("%s: Cannot be recovered in the host because it is a pass-through device\n",
-			pci_name(pdev));
-		status_str = "failed (pass-through)";
-		goto out_unlock;
-	}
-
 	driver = to_pci_driver(pdev->dev.driver);
 	if (!is_driver_supported(driver)) {
 		if (!driver) {
@@ -210,12 +222,22 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
 		goto out_unlock;
 	}
 
+	if (needs_mediated_recovery(pdev))
+		zpci_store_pci_error(pdev, ccdf);
+
 	ers_res = zpci_event_notify_error_detected(pdev, driver);
 	if (ers_result_indicates_abort(ers_res)) {
 		status_str = "failed (abort on detection)";
 		goto out_unlock;
 	}
 
+	if (needs_mediated_recovery(pdev)) {
+		pr_info("%s: Recovering passthrough device\n", pci_name(pdev));
+		ers_res = PCI_ERS_RESULT_RECOVERED;
+		status_str = "in progress";
+		goto out_unlock;
+	}
+
 	if (ers_res != PCI_ERS_RESULT_NEED_RESET) {
 		ers_res = zpci_event_do_error_state_clear(pdev, driver);
 		if (ers_result_indicates_abort(ers_res)) {
@@ -258,25 +280,20 @@ static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev *pdev)
  * @pdev: PCI function for which to report
  * @es: PCI channel failure state to report
  */
-static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es)
+static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_state_t es,
+				  struct zpci_ccdf_err *ccdf)
 {
 	struct pci_driver *driver;
 
 	pci_dev_lock(pdev);
 	pdev->error_state = es;
-	/**
-	 * While vfio-pci's error_detected callback notifies user-space QEMU
-	 * reacts to this by freezing the guest. In an s390 environment PCI
-	 * errors are rarely fatal so this is overkill. Instead in the future
-	 * we will inject the error event and let the guest recover the device
-	 * itself.
-	 */
+
 	if (needs_mediated_recovery(pdev))
-		goto out;
+		zpci_store_pci_error(pdev, ccdf);
 	driver = to_pci_driver(pdev->dev.driver);
 	if (driver && driver->err_handler && driver->err_handler->error_detected)
 		driver->err_handler->error_detected(pdev, pdev->error_state);
-out:
+
 	pci_dev_unlock(pdev);
 }
 
@@ -312,6 +329,7 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
 	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
 
+
 	if (!pdev)
 		goto no_pdev;
 
@@ -322,12 +340,13 @@ static void __zpci_event_error(struct zpci_ccdf_err *ccdf)
 		break;
 	case 0x0040: /* Service Action or Error Recovery Failed */
 	case 0x003b:
-		zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
+		zpci_event_io_failure(pdev, pci_channel_io_perm_failure, ccdf);
 		break;
 	default: /* PCI function left in the error state attempt to recover */
-		ers_res = zpci_event_attempt_error_recovery(pdev);
+		ers_res = zpci_event_attempt_error_recovery(pdev, ccdf);
 		if (ers_res != PCI_ERS_RESULT_RECOVERED)
-			zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
+			zpci_event_io_failure(pdev, pci_channel_io_perm_failure,
+					ccdf);
 		break;
 	}
 	pci_dev_put(pdev);
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index a7bc23ce8483..2be37eab9279 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -168,6 +168,8 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 
 	zdev->mediated_recovery = false;
 
+	zpci_cleanup_pending_errors(zdev);
+
 	if (!vdev->vdev.kvm)
 		return;
 
-- 
2.43.0


