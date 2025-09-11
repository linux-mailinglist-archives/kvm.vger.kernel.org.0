Return-Path: <kvm+bounces-57347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E340B53B87
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 278911CC6687
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010E43705A2;
	Thu, 11 Sep 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qvIhTzhf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC5C36C07F;
	Thu, 11 Sep 2025 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615599; cv=none; b=Zo4BtzpQe8+zk42nslf/al2CvORBvdlNQul900d4IImb2+9SvirP2ZNiUPiBePpdxBnbRxtvw6pHcfHREJUcFWmwFX1y/zGHmurTvKLBF1Ah9oWl0DZ9Ni6A22nEjZPt6KJxTap0lsvS14A4/tFku7JCDavSrIZJfNg61qBiWOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615599; c=relaxed/simple;
	bh=A9xi35BB90o7/iR3ITPX43udqTkT3mvfgeueyjrnk3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqtBRgreXMZpDqx2cxHaWI0p2Y9RReqNeR13/MvbuIlqE8zshSQSP3rfYZTyztepbJyS9BIsXxUfUZEwYDfDi1ED9JjmPYHslvcmOZix6YVo4eW6jmWr9jyI+pswvj+Q4JvOIhJfNb51MqPpqJADE063moSD2uwPQov7I2BX2aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qvIhTzhf; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BEBo59024558;
	Thu, 11 Sep 2025 18:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IiIsVKX9sgPnPaf1w
	huJxpybFaYB+X/PfUp+yLazCiE=; b=qvIhTzhf9+vR+dJY4ZC4b7y61nlWdeCm0
	sokX1+D/EGxTw/W9mToO540S13VpMnI0vHuy+NVZp5D0rhYCIbXyQN+btf8idnqx
	H4g+JeVexCHJyhmq/y/LqhPMrmoC1Xnm/GxKA+eornny+72SWzsyKuHzFmeacxG0
	kqjt8KS+o5uto3yRCHwkBRY/Iw0CJgqxPuUchahC1rLjMBd04d/lwFpcwKpmMk8Z
	KnUK6MYY7hyCGsPbpg6WQP7niEg1HzgLEAXq+kHqbA+Qxh81SGYqfjq9fa32yp6J
	BvePu17g5YSOdXigrUI8mMSufyBgL7UZn6FS9QAzoSMYNLN2T0fwA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx6n90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BI6ZvG017218;
	Thu, 11 Sep 2025 18:33:12 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmq2c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:11 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXAV326673812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:11 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D69D158059;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32D7158058;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 03/10] PCI: Allow per function PCI slots
Date: Thu, 11 Sep 2025 11:33:00 -0700
Message-ID: <20250911183307.1910-4-alifm@linux.ibm.com>
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
X-Proofpoint-GUID: HQVFu9CRau-j72qfXJG45PcMar8KGwTU
X-Proofpoint-ORIG-GUID: HQVFu9CRau-j72qfXJG45PcMar8KGwTU
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c315e8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=K-1LnuYzVcpd1HOvht4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfX/cuZaSKBQIp5
 FzXTCQNI9zNbt2jwzsK+12hL4Y9IqSdhJUklaouWCV/X8iaCqym33DlXa1OxczZiV6yHHHdnwAU
 8QSLk+2qAlC4Ul4SnX3QTGbhcWiOo8GEVGJmSxHRXLZ1Oz0Ru9V4spqtGkQ9lo7NpDHVTzBZE8S
 GsHBFtA3dlnTHQmKjBRaist6zh39btovCX9Tgn5ONyWNkZign5jv35uWlsOYuBPTYYz/+t5Nilf
 LsANlxNybyUB2ZmUHEy7qBRL6mDEGqCwhthtJma9MrsxZJVB23KpsGIuyb3ydxS71EXXU0hyEG3
 DUUoBM1oyc8Gp4F9Ti1pSY1oDqsj4C0oMlrWoqqxLMyfMkSHC4qQ/iJVFMTAHc1OVbkTHagvKEB
 SkeSR2NV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

On s390 systems, which use a machine level hypervisor, PCI devices are
always accessed through a form of PCI pass-through which fundamentally
operates on a per PCI function granularity. This is also reflected in the
s390 PCI hotplug driver which creates hotplug slots for individual PCI
functions. Its reset_slot() function, which is a wrapper for
zpci_hot_reset_device(), thus also resets individual functions.

Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot object
to multifunction devices. This approach worked fine on s390 systems that
only exposed virtual functions as individual PCI domains to the operating
system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
s390 supports exposing the topology of multifunction PCI devices by
grouping them in a shared PCI domain. When attempting to reset a function
through the hotplug driver, the shared slot assignment causes the wrong
function to be reset instead of the intended one. It also leaks memory as
we do create a pci_slot object for the function, but don't correctly free
it in pci_slot_release().

Add a flag for struct pci_slot to allow per function PCI slots for
functions managed through a hypervisor, which exposes individual PCI
functions while retaining the topology.

Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
Suggested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/hotplug/s390_pci_hpc.c | 10 ++++++++--
 drivers/pci/pci.c                  |  4 +++-
 drivers/pci/slot.c                 | 14 +++++++++++---
 include/linux/pci.h                |  1 +
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/s390_pci_hpc.c b/drivers/pci/hotplug/s390_pci_hpc.c
index d9996516f49e..8b547de464bf 100644
--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -126,14 +126,20 @@ static const struct hotplug_slot_ops s390_hotplug_slot_ops = {
 
 int zpci_init_slot(struct zpci_dev *zdev)
 {
+	int ret;
 	char name[SLOT_NAME_SIZE];
 	struct zpci_bus *zbus = zdev->zbus;
 
 	zdev->hotplug_slot.ops = &s390_hotplug_slot_ops;
 
 	snprintf(name, SLOT_NAME_SIZE, "%08x", zdev->fid);
-	return pci_hp_register(&zdev->hotplug_slot, zbus->bus,
-			       zdev->devfn, name);
+	ret = pci_hp_register(&zdev->hotplug_slot, zbus->bus,
+				zdev->devfn, name);
+	if (ret)
+		return ret;
+
+	zdev->hotplug_slot.pci_slot->per_func_slot = 1;
+	return 0;
 }
 
 void zpci_exit_slot(struct zpci_dev *zdev)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3994fa82df68..70296d3b1cfc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5061,7 +5061,9 @@ static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, bool probe)
 
 static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
 {
-	if (dev->multifunction || dev->subordinate || !dev->slot ||
+	if (dev->multifunction && !dev->slot->per_func_slot)
+		return -ENOTTY;
+	if (dev->subordinate || !dev->slot ||
 	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
 		return -ENOTTY;
 
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 50fb3eb595fe..51ee59e14393 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -63,6 +63,14 @@ static ssize_t cur_speed_read_file(struct pci_slot *slot, char *buf)
 	return bus_speed_read(slot->bus->cur_bus_speed, buf);
 }
 
+static bool pci_dev_matches_slot(struct pci_dev *dev, struct pci_slot *slot)
+{
+	if (slot->per_func_slot)
+		return dev->devfn == slot->number;
+
+	return PCI_SLOT(dev->devfn) == slot->number;
+}
+
 static void pci_slot_release(struct kobject *kobj)
 {
 	struct pci_dev *dev;
@@ -73,7 +81,7 @@ static void pci_slot_release(struct kobject *kobj)
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &slot->bus->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (pci_dev_matches_slot(dev, slot))
 			dev->slot = NULL;
 	up_read(&pci_bus_sem);
 
@@ -166,7 +174,7 @@ void pci_dev_assign_slot(struct pci_dev *dev)
 
 	mutex_lock(&pci_slot_mutex);
 	list_for_each_entry(slot, &dev->bus->slots, list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (pci_dev_matches_slot(dev, slot))
 			dev->slot = slot;
 	mutex_unlock(&pci_slot_mutex);
 }
@@ -285,7 +293,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &parent->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot_nr)
+		if (pci_dev_matches_slot(dev, slot))
 			dev->slot = slot;
 	up_read(&pci_bus_sem);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59876de13860..9265f32d9786 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -78,6 +78,7 @@ struct pci_slot {
 	struct list_head	list;		/* Node in list of slots */
 	struct hotplug_slot	*hotplug;	/* Hotplug info (move here) */
 	unsigned char		number;		/* PCI_SLOT(pci_dev->devfn) */
+	unsigned int		per_func_slot:1; /* Allow per function slot */
 	struct kobject		kobj;
 };
 
-- 
2.43.0


