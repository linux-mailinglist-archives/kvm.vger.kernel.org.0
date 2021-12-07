Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF9A46C5FF
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhLGVIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhLGVIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:19 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KMDtV030324;
        Tue, 7 Dec 2021 21:04:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6RpY75ZP3cCWRNfgc+A/YuYK4UkB5oOiEZCyKfk0RFs=;
 b=SeLERxuqgvRjCG7I45dxSkCsAWI9ZcNq+8DtEdKYTV/QMz4TW8YbhwxEmdmt0zk+WfJc
 LUwweS9A+Td6ggoKk5NIoPydUaIVpvOHBYUQFLMe3AFk9VBTHLeguLXdePU+hAt4BRzw
 Y0tX6CIFJxi0GK3ZP5c0trvQx2huNpctDCq3Su7hydkuU+LsvdKouF8nBLmY/zdOzMhu
 zyk0ZPOZKF2md8E0eqzmAxHyrsB6Bt2AwEy56q/mZvUnoeEWAMt0cQL52lwT9b3AYmH5
 9/QhAjb3Ytjuoaq1BX4YCTA3aBmKoMTjtOCEf60ZKazA++AfbSq5bEjYwVdFTLyRlpU0 Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctek98rpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KO4qF010488;
        Tue, 7 Dec 2021 21:04:41 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctek98rnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:41 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvoDu031451;
        Tue, 7 Dec 2021 21:04:39 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyamrgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:39 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L4cP955378382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:04:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F114AE066;
        Tue,  7 Dec 2021 21:04:38 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8E79AE064;
        Tue,  7 Dec 2021 21:04:34 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:34 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 01/12] s390x/pci: use a reserved ID for the default PCI group
Date:   Tue,  7 Dec 2021 16:04:14 -0500
Message-Id: <20211207210425.150923-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DagEidRJ8c7TaL2qxdYdPF7ul_ZSxmcd
X-Proofpoint-ORIG-GUID: -D1GxPlRp-N75_vyrO2UWiOTJMvtLC3i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 adultscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current default PCI group being used can technically collide with a
real group ID passed from a hostdev.  Let's instead use a group ID that
comes from a special pool (0xF0-0xFF) that is architected to be reserved
for simulated devices.

Fixes: 28dc86a072 ("s390x/pci: use a PCI Group structure")
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/hw/s390x/s390-pci-bus.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index aa891c178d..2727e7bdef 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -313,7 +313,7 @@ typedef struct ZpciFmb {
 } ZpciFmb;
 QEMU_BUILD_BUG_MSG(offsetof(ZpciFmb, fmt0) != 48, "padding in ZpciFmb");
 
-#define ZPCI_DEFAULT_FN_GRP 0x20
+#define ZPCI_DEFAULT_FN_GRP 0xFF
 typedef struct S390PCIGroup {
     ClpRspQueryPciGrp zpci_group;
     int id;
-- 
2.27.0

