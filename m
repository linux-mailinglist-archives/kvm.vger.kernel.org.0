Return-Path: <kvm+bounces-58678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE3AB9B018
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E64F1BC0410
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64CD431329C;
	Wed, 24 Sep 2025 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XyQTvwlZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF33164DC;
	Wed, 24 Sep 2025 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734204; cv=none; b=kzY3Ex1dw9ggMS3qIBjXBxab7ddrvAYLS81jsdXmOpl0rUrashDHFF2xxt6SLqZHvPciaQkr9iL8fzUX7WKrIlJXipVeS20Xt6JUVVqXlMKVBsfpevQ6+vj1Xi4DXBFpT8Hqa9tA7+fH8M5sRHQZmamOim0UBvweiMUKON5GP2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734204; c=relaxed/simple;
	bh=iUFfcJwCG6FBfxs5hXpJ5ztskkQYyvOnk7gsFW82Vys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6qua+zCjeG2MMiU/jHN3PujRNT8M7hS5Tn2qEQda0iP3Ms05hnCODJJt7jHbeTw1X5kzYlBMIJK/s1+xmjsfe5xRb/2uQv/VZ6KuPELTvmUgqWzx4mK0QDmEPLB1nl//5haFinvWE9whF2VYFi7Un9utKUyetMXz8SQW0yRwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XyQTvwlZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGgJcU028853;
	Wed, 24 Sep 2025 17:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AZlxxd1WcazOIdq8Z
	AxncA3t4iY+7RfS/CJBSa31jKo=; b=XyQTvwlZ7q7F3eVG2N2iEpwlHpFV/Oolr
	od3vqvsTsnQQ1Qlx8yl3tc6ZKUa5P3eFPbocgCR1fRcFcZaSHt7xp9eKoopxHEYD
	An0+BZO2Z9RS2ucPpHSteup29mI36G51rZa2+X28m4PynmBpKQ++7brAiz+0A2dG
	FhmuffOcjaOGznAyD/uql9PjWP+wsGWtI9hZdHwX1f40KYm96/+b9g0B2tsoWMvV
	0uDnIVqAJCV/PnL/HzzLGwzeSitma67pkbVWKXWUhkj/l1v+EW3SbV+UcGYMvC9r
	lsUPuM1lrS0UCd46HDCxlpKjfqh8ruxyGMiLQnBTclmNwPNCaSr+A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqggbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OE45UZ013329;
	Wed, 24 Sep 2025 17:16:37 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49cj348u51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:37 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGZjn32440602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:36 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3F575803F;
	Wed, 24 Sep 2025 17:16:35 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0FFF58056;
	Wed, 24 Sep 2025 17:16:34 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:34 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com,
        stable@vger.kernel.org
Subject: [PATCH v4 03/10] PCI: Allow per function PCI slots
Date: Wed, 24 Sep 2025 10:16:21 -0700
Message-ID: <20250924171628.826-4-alifm@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=FrEF/3rq c=1 sm=1 tr=0 ts=68d42776 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=K-1LnuYzVcpd1HOvht4A:9
X-Proofpoint-ORIG-GUID: HM120vcbSZvdrKj5Wv4otrRYOMcwZwrV
X-Proofpoint-GUID: HM120vcbSZvdrKj5Wv4otrRYOMcwZwrV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDIyNCBTYWx0ZWRfXy2zHvKEOOjLx
 ctOAjEpa/zeaeOo5llDRtZdYjhZo8cG80sQ+unKuH5PJdFkeoEX4WhfxSgVYwgI5km72HF6rxpd
 7I/6aB7jABreLVdkuhPeRrspgxR9Y93XNv20K3GTV2CLUIGETjEvPKk9ziefT8M9XMyfi7gFISR
 YFpiGsvrK0QfG5LWAvLgZCLby4b6+ZEglJB9VI06wZORAZe7c2unfdY4xaKPxhOFx2aGZehLWBU
 Hmzq8VE9LPn3RvtxDRu+AHUCzOf2kPpq5jMP46YGbp5a7rqGrXAvOxjf31lEfhICQs/Q0XHIt/y
 1QpDJj1AFk0iUAfzIAe32dr2bw8K5VgEwMofOxPndz4mCIdEe1j95HVISYT6+sbqK/HSjeOjYA3
 Ei9HJN2x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509190224

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
Cc: <stable@vger.kernel.org>
Suggested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/hotplug/s390_pci_hpc.c | 10 ++++++++--
 drivers/pci/pci.c                  |  5 +++--
 drivers/pci/slot.c                 | 14 +++++++++++---
 include/linux/pci.h                |  1 +
 4 files changed, 23 insertions(+), 7 deletions(-)

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
index 327fefc6a1eb..530a793a332c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5057,8 +5057,9 @@ static int pci_reset_hotplug_slot(struct hotplug_slot *hotplug, bool probe)
 
 static int pci_dev_reset_slot_function(struct pci_dev *dev, bool probe)
 {
-	if (dev->multifunction || dev->subordinate || !dev->slot ||
-	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET)
+	if (dev->subordinate || !dev->slot ||
+	    dev->dev_flags & PCI_DEV_FLAGS_NO_BUS_RESET ||
+	    (dev->multifunction && !dev->slot->per_func_slot))
 		return -ENOTTY;
 
 	return pci_reset_hotplug_slot(dev->slot->hotplug, probe);
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


