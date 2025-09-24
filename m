Return-Path: <kvm+bounces-58677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05559B9B00E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 19:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C2B97B6F22
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 17:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBCE3191C9;
	Wed, 24 Sep 2025 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="siNqHZt8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C992315D52;
	Wed, 24 Sep 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758734202; cv=none; b=EL5I/AUp8hhS4Igu4XK4CiVLc7eNmawWgSNu2Jt0t1V/RBJXMlgRsf3XsUzRMuhcd/BUClcEQBY+cT/D3Dv6Xkq883YYPrHHauF1ZhYflTE+vkD+Rha74pNBfLVP+JRL8oHsReo2NB8aTowFEUz5zueHXxJl6K9ywEVoTrbBvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758734202; c=relaxed/simple;
	bh=YrxQ0WJe9dz6q4E5eGvh+vYwNIxItsbwqGpJD/pFKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+mw1CQ1/u+jnzfg+LQWYWFpn26naEi+7MUvjXcG806zkhZwcPvM9CHYg7OKSTabW7aK5u5Zl2jtpuaLn6A/rh/cYJhACpGVF8r9XwuP0UjK2E4TsZh+qXYm15kOvz63jeImCvAayOE3VjI74NphtD0+/oqkPn8hBhZacpZrAHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=siNqHZt8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGDqok017273;
	Wed, 24 Sep 2025 17:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AVUF0BZZovq5IEjar
	f6BmNZ9GqdqEzXVBXdFy793V6o=; b=siNqHZt8z1iqbCPptlxhnxn9+C8q9NSfd
	2volqaDSyMjUlctbQ4aJYa50BHP/CD9Pi/v/DTtHTdAMmDLBdcTfiGp081hidB1Q
	QYQSZcNAq5RIWPkz6Vt6zsrkV9baJxcj/9Hr2fp91evXLERtvVr2wyF/AdrkGLVA
	04mADBn6WqMFEe0s1d0T/IexcE435rLOS6MhUEjP1T5y/rrz63LI4bRibRjbONcP
	UiZz1+1hycC7BoJjaoo32stjHncD/ZWHR0UgQGxHxAVHgHKbUy1UUZllZgzLsIDk
	K6RnMfOzsB4s/+fw7cy67RalBzCHylcLLII2eLZ2vbS7guMvWZmiw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc11p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OELggF030367;
	Wed, 24 Sep 2025 17:16:35 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a9a19f4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 17:16:35 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OHGYdl28508918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 17:16:34 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B53805803F;
	Wed, 24 Sep 2025 17:16:34 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ECDC358056;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
Received: from IBM-D32RQW3.ibm.com (unknown [9.61.252.148])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 17:16:33 +0000 (GMT)
From: Farhan Ali <alifm@linux.ibm.com>
To: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        alifm@linux.ibm.com, schnelle@linux.ibm.com, mjrosato@linux.ibm.com
Subject: [PATCH v4 02/10] PCI: Add additional checks for flr reset
Date: Wed, 24 Sep 2025 10:16:20 -0700
Message-ID: <20250924171628.826-3-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: JKn4S1BCIprkwT72N7oGBPZJFW-37Q_t
X-Proofpoint-GUID: JKn4S1BCIprkwT72N7oGBPZJFW-37Q_t
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d42774 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=8GLQ0EcgPjaQrAEZ2hkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX0OdcpLij4fSa
 POqoYEkGOe5d/N7HWkVhHK0s465/9dBgRfK5A/B7wfoqMZPCegJOURmDDjSkdtvdNreFmGaUZFQ
 Rcs9L+8X6zmXuysPQjyQQyIaac2YK0EMWkG2Au8gGeQ0l0SnRLWijUsrxEC2TaW34U9Prh373H7
 ta0XngsNkx5gKrzsvzaITm/cElPas8gzM546KvQiY1PowT73ylGo6CAeTmpkWtCE093rT06vaBV
 50mQCDr9Qkm5dQTKZs7kY4ZZZd7MsQdOWB9X/J/cFiM/EV6aVtX/En9vyIEnKJv7G+2lk/IVEzW
 BXVgJbjzycLz+H6Kg/0tjji8usGeZy37vHzpJqbfT0nfg1IGdkfVWKxGXAahc9j4/8HHBcFq7kB
 L83Dxlv+
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

If a device is in an error state, then any reads of device registers can
return error value. Add addtional checks to validate if a device is in an
error state before doing an flr reset.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/pci/pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a3d93d1baee7..327fefc6a1eb 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4576,12 +4576,19 @@ EXPORT_SYMBOL_GPL(pcie_flr);
  */
 int pcie_reset_flr(struct pci_dev *dev, bool probe)
 {
+	u32 reg;
+
 	if (dev->dev_flags & PCI_DEV_FLAGS_NO_FLR_RESET)
 		return -ENOTTY;
 
 	if (!(dev->devcap & PCI_EXP_DEVCAP_FLR))
 		return -ENOTTY;
 
+	if (pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &reg)) {
+		pci_warn(dev, "Device unable to do an FLR\n");
+		return -ENOTTY;
+	}
+
 	if (probe)
 		return 0;
 
-- 
2.43.0


