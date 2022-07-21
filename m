Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF76057D100
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiGUQNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiGUQNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F688770;
        Thu, 21 Jul 2022 09:13:26 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LG6diZ005804;
        Thu, 21 Jul 2022 16:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dw+zf2Bl0iLJuaLcROPWUvvOxVr9TDq8FrZayalj8+M=;
 b=bCwUQ64GklLbzCB7TMXRNYEKzHp87W5Aj8LTC8P7t8cfg7b3TzQVKphLXdv4BVHZgpcQ
 0mfrGJ61QabZhnuswXxxdQju/XdjOg0gBAfmsTQDbsXEDoK9VQFTSyVBZs7qzHnMqsnd
 h1uJzrXCO5HZDITCUBohlLSFtlt93frwbUMaqqBYiZblclZJki4c/bigrwGd2pi8Kn5S
 EjfhafvHry+tpx6BpPvJvxb+PXUtY/n7WPVnfxTyi/Y+VxZ8hymN2QwLuT3V5tcVFQHI
 xe2eYbyPko+xQZ5HXaVsMvqSi4G0hCqnYTn2pzdspIcj8DneKoJOx+9lV7m3v6GDciMF HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:25 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LG6tow007683;
        Thu, 21 Jul 2022 16:13:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9tfgfjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6iX8029928;
        Thu, 21 Jul 2022 16:13:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDJWe22020600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36C8EA405C;
        Thu, 21 Jul 2022 16:13:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A591BA4054;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:18 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        kernel test robot <yujie.liu@intel.com>
Subject: [GIT PULL 24/42] KVM: s390/pci: fix include duplicates
Date:   Thu, 21 Jul 2022 18:12:44 +0200
Message-Id: <20220721161302.156182-25-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2Qch6JvXGLtWauAMd10KTgLSRvKDuOoU
X-Proofpoint-ORIG-GUID: cdjLWNEwhB9SYTebJy-vMJpcEe6mgA_1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 mlxlogscore=641 clxscore=1011 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

remove the duplicate includes. While at it sort the includes.

Reported-by: kernel test robot <yujie.liu@intel.com>
Fixes: 73f91b004321 ("KVM: s390: pci: enable host forwarding of Adapter Event Notifications")
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/pci.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 0351382e990f..3a3606c3a0fe 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -10,11 +10,10 @@
 #ifndef __KVM_S390_PCI_H
 #define __KVM_S390_PCI_H
 
-#include <linux/kvm_host.h>
-#include <linux/pci.h>
-#include <linux/mutex.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
 #include <asm/airq.h>
 #include <asm/cpu.h>
 
-- 
2.36.1

