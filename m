Return-Path: <kvm+bounces-55656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E506B34855
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA5F83B8E8B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3144302773;
	Mon, 25 Aug 2025 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tPWMRt//"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52FC303C9E;
	Mon, 25 Aug 2025 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756141961; cv=none; b=CUVWurF5WKdAW1HtQs89qL5LA+dLBWjL/Zhg9aik2l2JUGfuqG7aMiWIvVC0NnRw8Dz2286qXXZSKMKeVO1p5G1x6uPVYGnj6TEATcU576z9xUnIvYGn4uxiiISUjAT+Dg/ebW1tohJuilQqbzZnpwzlDNDczvLK9qjRcTrdE08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756141961; c=relaxed/simple;
	bh=gxQBDm9CkrMlpO1c0Xc+fy37AaNeGPLTPSTrcJJYpss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw3SV9pmShf9xxu9jj5BLYdZEBJzg6nD/FlHG2Moq4dg9HI3rnbwLzg+36FmeMqDoW9jMUrrc08MMcPXft1sl9+y6SAB+xcZ0hEOpkwXa+ybFkrFfXBTmxJ6X6p2pilB2gra9KW0klI9dRAIuMh7xXbN2M7fqQ95h138rsELNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tPWMRt//; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P9AkeK019463;
	Mon, 25 Aug 2025 17:12:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AxGqz+wOzYX3hTjME
	Ke8dNpYA1otWEGI86p16x8pqJ4=; b=tPWMRt//8ry90MFMpLTK+d4D6aQQDAg9j
	1ZvrhaxOBLEYSicQb/vxZ3m2zgydwvWnAevOTU+UEsLk036yQ4El99KCQYKxyIsc
	pfjAFWoXVNNy1VBWoQeB/XR4F4auTbetActA9GTJ0ol3CCQHY6K+v9g5avclwtGx
	yenimntNYDMhFDh0M464i1GeRWbi7OPD0+PG+tu17EMEBhisru4ubj8h0Qazcrpl
	zklaCIPWY+wbNUYl1Sqk+U9jSSgtpzsDmFUyNWVWjYkLfDCfFiug87dd7hrdYbap
	WaTBmtrJK8LBhkQeWpim9YJfGk/k+BziKVX/5T6KwPHIcHu3ZRCzg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557t98u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PEkQG1002473;
	Mon, 25 Aug 2025 17:12:33 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qt6m6q6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 17:12:33 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PHCW6q13632014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 17:12:32 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A0A658054;
	Mon, 25 Aug 2025 17:12:32 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 011FD5804E;
	Mon, 25 Aug 2025 17:12:31 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.255.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 17:12:30 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v2 3/9] PCI: Allow per function PCI slots for hypervisor isolated functions
Date: Mon, 25 Aug 2025 10:12:20 -0700
Message-ID: <20250825171226.1602-4-alifm@linux.ibm.com>
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
X-Proofpoint-GUID: G8-qkalkm8D9a4AG629WOFz6yyrtvCLj
X-Proofpoint-ORIG-GUID: G8-qkalkm8D9a4AG629WOFz6yyrtvCLj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX5VmsT49mF984
 KkkZhRMO8UYbLczP22AdZ6cfH771DwbBV/4NMfnhPoOjyTZUsWQGbaVXFdYn58aGg/Hoz9KZGgO
 63sCwkbc18t5kL3BPUOMjfbtQuQ/WSAmmA/6T/EKPd7PRRMOVxRUmUA//r1kwyvy+w/JvX2tbjU
 tx3qZy5GR98M+fe4Nv6xlfWBPp0rhoWshbazbTLE2K5mKQVCAOowqm928tjX4FE115RJySXkx0j
 LQQ8l/zhqgW54QstIPFObpfzzy8wr6ppLOAxP13FROsnglToV3ojcwemo6JCihl363hwWoIxOu7
 HJCYL11bTdJNd8S8kYF/7yZaatdmHUhzyiHhbl7Svq/acRtl7soZkmSibii5GsOuC+doUJ7lgGA
 qAOXCmrv
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68ac9982 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=cH6R9-kdAAAA:8 a=yKnoY3V09h4Zs0NVWIYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

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

This patch adds a helper function to allow per function PCI slots for
functions managed through a hypervisor which exposes individual PCI
functions while retaining the topology.

Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
Co-developed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/slot.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 50fb3eb595fe..991526af0ffe 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -5,6 +5,7 @@
  *	Alex Chiang <achiang@hp.com>
  */
 
+#include <linux/hypervisor.h>
 #include <linux/kobject.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -73,7 +74,7 @@ static void pci_slot_release(struct kobject *kobj)
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &slot->bus->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (dev->slot == slot->number)
 			dev->slot = NULL;
 	up_read(&pci_bus_sem);
 
@@ -160,13 +161,25 @@ static int rename_slot(struct pci_slot *slot, const char *name)
 	return result;
 }
 
+static bool pci_dev_matches_slot(struct pci_dev *dev, struct pci_slot *slot)
+{
+	if (hypervisor_isolated_pci_functions()) {
+		if (dev->devfn == slot->number)
+			return true;
+	} else {
+		if (PCI_SLOT(dev->devfn) == slot->number)
+			return true;
+	}
+	return false;
+}
+
 void pci_dev_assign_slot(struct pci_dev *dev)
 {
 	struct pci_slot *slot;
 
 	mutex_lock(&pci_slot_mutex);
 	list_for_each_entry(slot, &dev->bus->slots, list)
-		if (PCI_SLOT(dev->devfn) == slot->number)
+		if (pci_dev_matches_slot(dev, slot))
 			dev->slot = slot;
 	mutex_unlock(&pci_slot_mutex);
 }
@@ -285,7 +298,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 
 	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &parent->devices, bus_list)
-		if (PCI_SLOT(dev->devfn) == slot_nr)
+		if (pci_dev_matches_slot(dev, slot))
 			dev->slot = slot;
 	up_read(&pci_bus_sem);
 
-- 
2.43.0


