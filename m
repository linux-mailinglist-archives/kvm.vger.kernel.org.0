Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7776061EF61
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 10:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiKGJoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 04:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiKGJoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 04:44:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD4713E1A;
        Mon,  7 Nov 2022 01:44:00 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A784emu008616;
        Mon, 7 Nov 2022 09:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6Q5qpTDHhRVei6uKryPLFEL8h18FwawYjLmVI7rjbi8=;
 b=Uh1F4oVJQXpna1EQKfKeGjy3VAckobMsGHFCDtgNnbQAseqRy5MTvFBmpQaBPZL+yb2/
 pD1Vk5DYOi42EP3C4t+Ql3oTS9Tmfl9p0nWN3anvXSIewsgmSwE2ECJ5PD8j2lyk96Di
 m8PoeLmg+el6lhC5kIpXX/HZZd2G43uBL5U1pwmuYEI7ds7rkVAgPygTbHstBuBTyCTf
 P6fX9afMQEssV6+XNKwfFjZO/gU6XyAKb98kvPM4I3qNpadQxUOJUdkczrhuyy7OXs0E
 5MYtX+3RAXXAnLJPzZLpbaCd8sPKLxETYWv9fS+ac/STeo8gA2FmCeFcnx7IIihNWR8L 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kpx6c2mnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:43:59 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A79UFd3000394;
        Mon, 7 Nov 2022 09:43:59 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kpx6c2mmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:43:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A79ZwJY007110;
        Mon, 7 Nov 2022 09:43:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kngncacpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 09:43:56 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A79iV5C50594098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 09:44:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7E5D4C044;
        Mon,  7 Nov 2022 09:43:53 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 444374C04E;
        Mon,  7 Nov 2022 09:43:53 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.94.163])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 09:43:53 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Rafael Mendonca <rafaelmendsr@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [GIT PULL 2/2] KVM: s390: pci: Fix allocation size of aift kzdev elements
Date:   Mon,  7 Nov 2022 10:43:29 +0100
Message-Id: <20221107094329.81054-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107094329.81054-1-frankja@linux.ibm.com>
References: <20221107094329.81054-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c3-SxatJa-XdrK8ZwYTnb8_55OYBwTEG
X-Proofpoint-ORIG-GUID: hh9psIlcgeHQn_0HogwJgobc063_0n7Q
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 mlxlogscore=785 bulkscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

The 'kzdev' field of struct 'zpci_aift' is an array of pointers to
'kvm_zdev' structs. Allocate the proper size accordingly.

Reported by Coccinelle:
  WARNING: Use correct pointer type argument for sizeof

Fixes: 98b1d33dac5f ("KVM: s390: pci: do initial setup for AEN interpretation")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20221026013234.960859-1-rafaelmendsr@gmail.com
Message-Id: <20221026013234.960859-1-rafaelmendsr@gmail.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index c50c1645c0ae..ded1af2ddae9 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -126,7 +126,7 @@ int kvm_s390_pci_aen_init(u8 nisc)
 		return -EPERM;
 
 	mutex_lock(&aift->aift_lock);
-	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev *),
 			      GFP_KERNEL);
 	if (!aift->kzdev) {
 		rc = -ENOMEM;
-- 
2.37.3

