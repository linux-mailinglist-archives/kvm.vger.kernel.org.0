Return-Path: <kvm+bounces-57348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8364CB53B88
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 20:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31CC0AC0A42
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB8F371E9A;
	Thu, 11 Sep 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JfFgvphP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC536CC63;
	Thu, 11 Sep 2025 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757615599; cv=none; b=fZ3htuKBkR0FeaMIV48V31NpF2FnghhyxV0a5C7yvujMe4nQWE5waBOsVXTN7jMwebnvWsMdWt7nKplfh+W9vDDKctpYoQh0nGx0Yefy5HK5p1cxZ3QR8xRWyWMQpdOvcRNhkBlbsVeL8VE2Ph6xDBPVEKKvi7hLhO74gh2D4HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757615599; c=relaxed/simple;
	bh=4D0+y0nuAv/oMRS2SJ1i+o2tSrq0Xli8o900mxZzDyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWLA/C+R3fEIP4D7AbocDML5Zmyt+hqUn35vqxHDtk+Brw7aa10ripTZK8O498KJ53SmV/Ye4BCsmodaEdzLXot1DhebUwdurnVSvYRnJ4pgzbXCH47IolO5XHjn5xX1R6+5ut8U66A8h7nEkfjvWGJdmZXqrfsr46hCdoBeNA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JfFgvphP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BDlHmq002811;
	Thu, 11 Sep 2025 18:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wwtqQl9dJaE0sfRmk
	00O2pgfEIsW+XaywO1jJiYJhJQ=; b=JfFgvphPdLWN6VgaN6vH8gtmzT84TxetK
	eVqURP/pP0j9VrNqK9Nst8ufY0ozw1MfdyIzyI7UOoLxi3RX47yxcxt4tNLTmjFb
	Tq2y9QSE2MqmQ5epuU76iufO02jparlz8aneAM7Bgg8eoTVuEl0Uz1NXYfiql5Lf
	+97mDXgIdGbHDmy/rRoSBFzXbLiK7zAFXaHR/WVvYHgXxl3W2pkl5T9ataH1EFD1
	ouoXlTjOmIXichG8ekNmNoBi4c9ldm1RC4Q83avVtL8KEgGIQfWveAbqHe43Ro6I
	wTxyjREtGi0DZm8LGS9DZKlmEi6YymthhBehqeGQhDjWg+LVecLFQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffpp7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58BI6ZvH017218;
	Thu, 11 Sep 2025 18:33:12 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmq2c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 18:33:12 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BIXBt332375370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 18:33:11 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2AD258057;
	Thu, 11 Sep 2025 18:33:11 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F243958058;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.249.32])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Sep 2025 18:33:10 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, alifm@linux.ibm.com,
        schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v3 04/10] s390/pci: Add architecture specific resource/bus address translation
Date: Thu, 11 Sep 2025 11:33:01 -0700
Message-ID: <20250911183307.1910-5-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 4Oz9sv7fwmDOIfBb-aVG6k-2PPrB1_Vv
X-Proofpoint-GUID: 4Oz9sv7fwmDOIfBb-aVG6k-2PPrB1_Vv
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c315e9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=yYx7OUe3D3zVL1aRsq0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfXxompx4eB6Q1R
 e2kSJHEG5B456HbYZ7y0KWygZjOhwTIuFhtBDNF2UHPUljltFhBAbdvh4PTGjTvrdzWAXEWIb5q
 Nx2yn1fqHApB2tbhQGAG3gJeFQuAwzkW6ovrBK4sC7Srm/bXTlvrOSyVVwRPmDzKS8QctWL3SIf
 siH/FFxIHBpvL65AKJf5BGmSdIBWg2zSFD7g36+i5Dlf6rtpcT7s2T1rnvnD1OTGzovA10MSnxk
 Tg+c3ze5spU7rZPR5rqovKNUrVj2Suv09NXWL3z/TUA/gVZOBlypNqIBACJ4T6C3butRV8P5SBt
 dSwTUD3xuDfdafAICQacas+4L+g4Pij2TMm0f5LpfeohH28FPlbIdt4MUtr+9ecxGyA/9Ys/As0
 sH5GYe2P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020

On s390 today we overwrite the PCI BAR resource address to either an
artificial cookie address or MIO address. However this address is different
from the bus address of the BARs programmed by firmware. The artificial
cookie address was created to index into an array of function handles
(zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmware
but maybe different from the bus address. This creates an issue when trying
to convert the BAR resource address to bus address using the generic
pcibios_resource_to_bus.

Implement an architecture specific pcibios_resource_to_bus function to
correctly translate PCI BAR resource address to bus address for s390.
Similarly add architecture specific pcibios_bus_to_resource function to do
the reverse translation.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 arch/s390/pci/pci.c       | 73 +++++++++++++++++++++++++++++++++++++++
 drivers/pci/host-bridge.c |  4 +--
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index cd6676c2d602..5baeb5f6f674 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -264,6 +264,79 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 	return 0;
 }
 
+void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
+			     struct resource *res)
+{
+	struct zpci_bus *zbus = bus->sysdata;
+	struct zpci_bar_struct *zbar;
+	struct zpci_dev *zdev;
+
+	region->start = res->start;
+	region->end = res->end;
+
+	for (int i = 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
+		int j = 0;
+
+		zbar = NULL;
+		zdev = zbus->function[i];
+		if (!zdev)
+			continue;
+
+		for (j = 0; j < PCI_STD_NUM_BARS; j++) {
+			if (zdev->bars[j].res->start == res->start &&
+			    zdev->bars[j].res->end == res->end) {
+				zbar = &zdev->bars[j];
+				break;
+			}
+		}
+
+		if (zbar) {
+			/* only MMIO is supported */
+			region->start = zbar->val & PCI_BASE_ADDRESS_MEM_MASK;
+			if (zbar->val & PCI_BASE_ADDRESS_MEM_TYPE_64)
+				region->start |= (u64)zdev->bars[j + 1].val << 32;
+
+			region->end = region->start + (1UL << zbar->size) - 1;
+			return;
+		}
+	}
+}
+
+void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
+			     struct pci_bus_region *region)
+{
+	struct zpci_bus *zbus = bus->sysdata;
+	struct zpci_dev *zdev;
+	resource_size_t start, end;
+
+	res->start = region->start;
+	res->end = region->end;
+
+	for (int i = 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
+		zdev = zbus->function[i];
+		if (!zdev || !zdev->has_resources)
+			continue;
+
+		for (int j = 0; j < PCI_STD_NUM_BARS; j++) {
+			if (!zdev->bars[j].val && !zdev->bars[j].size)
+				continue;
+
+			/* only MMIO is supported */
+			start = zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_MASK;
+			if (zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_TYPE_64)
+				start |= (u64)zdev->bars[j + 1].val << 32;
+
+			end = start + (1UL << zdev->bars[j].size) - 1;
+
+			if (start == region->start && end == region->end) {
+				res->start = zdev->bars[j].res->start;
+				res->end = zdev->bars[j].res->end;
+				return;
+			}
+		}
+	}
+}
+
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   pgprot_t prot)
 {
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index afa50b446567..56d62afb3afe 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -48,7 +48,7 @@ void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
 }
 EXPORT_SYMBOL_GPL(pci_set_host_bridge_release);
 
-void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
+void __weak pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res)
 {
 	struct pci_host_bridge *bridge = pci_find_host_bridge(bus);
@@ -73,7 +73,7 @@ static bool region_contains(struct pci_bus_region *region1,
 	return region1->start <= region2->start && region1->end >= region2->end;
 }
 
-void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
+void __weak pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 			     struct pci_bus_region *region)
 {
 	struct pci_host_bridge *bridge = pci_find_host_bridge(bus);
-- 
2.43.0


