Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F452198B01
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 06:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCaENC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 00:13:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbgCaENC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 00:13:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02V47IIq161990
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 00:13:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 303wrvrwsn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 00:13:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <sbobroff@linux.ibm.com>;
        Tue, 31 Mar 2020 05:12:52 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 31 Mar 2020 05:12:49 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02V4Ctaw46596210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 04:12:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BB99A404D;
        Tue, 31 Mar 2020 04:12:55 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9B27A4055;
        Tue, 31 Mar 2020 04:12:54 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Mar 2020 04:12:54 +0000 (GMT)
Received: from osmium.ibmuc.com (unknown [9.211.70.38])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id E32E2A01F9;
        Tue, 31 Mar 2020 15:12:46 +1100 (AEDT)
From:   Sam Bobroff <sbobroff@linux.ibm.com>
To:     kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     aik@ozlabs.ru
Subject: [PATCH v2 1/1] vfio-pci/nvlink2: Allow fallback to ibm,mmio-atsd[0]
Date:   Tue, 31 Mar 2020 15:12:46 +1100
X-Mailer: git-send-email 2.22.0.216.g00a2a96fc9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20033104-0012-0000-0000-0000039B5A44
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033104-0013-0000-0000-000021D864CB
Message-Id: <6183bf8ec2dd0433f213e081911ab8fd5cac2dcb.1585627961.git.sbobroff@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_01:2020-03-30,2020-03-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1011 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310030
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Older versions of skiboot only provide a single value in the device
tree property "ibm,mmio-atsd", even when multiple Address Translation
Shoot Down (ATSD) registers are present. This prevents NVLink2 devices
(other than the first) from being used with vfio-pci because vfio-pci
expects to be able to assign a dedicated ATSD register to each NVLink2
device.

However, ATSD registers can be shared among devices. This change
allows vfio-pci to fall back to sharing the register at index 0 if
necessary.

Fixes: 7f92891778df ("vfio_pci: Add NVIDIA GV100GL [Tesla V100 SXM2] subdriver")
Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
---
Patch set v2:
Patch 1/1: vfio-pci/nvlink2: Allow fallback to ibm,mmio-atsd[0]
- Removed unnecessary warning.
- Added Fixes tag.

Patch set v1:
Patch 1/1: vfio-pci/nvlink2: Allow fallback to ibm,mmio-atsd[0]

 drivers/vfio/pci/vfio_pci_nvlink2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index f2983f0f84be..ae2af590e501 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -420,8 +420,14 @@ int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
 
 	if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", nvlink_index,
 			&mmio_atsd)) {
-		dev_warn(&vdev->pdev->dev, "No available ATSD found\n");
-		mmio_atsd = 0;
+		if (of_property_read_u64_index(hose->dn, "ibm,mmio-atsd", 0,
+				&mmio_atsd)) {
+			dev_warn(&vdev->pdev->dev, "No available ATSD found\n");
+			mmio_atsd = 0;
+		} else {
+			dev_warn(&vdev->pdev->dev,
+				 "Using fallback ibm,mmio-atsd[0] for ATSD.\n");
+		}
 	}
 
 	if (of_property_read_u64(npu_node, "ibm,device-tgt-addr", &tgt)) {
-- 
2.22.0.216.g00a2a96fc9

