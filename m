Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2027F6AD9F4
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 10:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCGJLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 04:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjCGJLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 04:11:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E0152927
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 01:11:10 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327718Ip032457
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xd/ezf7YBKfH/srY4BN1tO1Kr3Tkgb5krvJYuokCDnA=;
 b=Zw8QkstJqE7fNuBjmHEUonoGA2mk/Gw4coXmpAMEw0Wuv7PWsvyak6skBb8qVS4pIje6
 ZTDW8J2I1xevj2CRx7Bw4K/BXFREB/DNowF6U9fosWH+uHfmn6dGKiDG4MIK8FcNofNN
 72S2TeE1s14d4dDy54ZWciVj7PJQBU5XyUqUKtZr/9l7NEkJziFDzF54YhAPOEjOiFyh
 IaZ9J6BTVX+g6xTmeIujUle+pgoA1VdCDwEUlSpi1XV70Q4bDTBSADNNyHeg+HEtpgrz
 H++FoDZgsOi+ds9ta4X4IVV91oy6jMNZBEb8RTN0/CpCCLhIasBL/vLKHib8TSjwighW pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4wsx20ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 09:11:09 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3276dfAb001483
        for <kvm@vger.kernel.org>; Tue, 7 Mar 2023 09:11:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4wsx20gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 326Ncjcv001857;
        Tue, 7 Mar 2023 09:11:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p4192b4cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Mar 2023 09:11:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3279B3AI17367626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Mar 2023 09:11:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A24C20043;
        Tue,  7 Mar 2023 09:11:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDF1720040;
        Tue,  7 Mar 2023 09:11:02 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com.com (unknown [9.171.61.17])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Mar 2023 09:11:02 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests PATCH v3 1/7] .gitignore: ignore `s390x/comm.key` file
Date:   Tue,  7 Mar 2023 10:10:45 +0100
Message-Id: <20230307091051.13945-2-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307091051.13945-1-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0h2zMqmp-gcGbgZOAxlAVXYp1bXQeK7G
X-Proofpoint-GUID: k7fiOTdJgkWIhrVAXFd8mesrqbI11nXU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_02,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore the Secure Execution Customer Communication Key file.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 33529b65a7e3..601822d67325 100644
--- a/.gitignore
+++ b/.gitignore
@@ -28,5 +28,6 @@ cscope.*
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
 /efi-tests/*
+/s390x/comm.key
 /s390x/snippets/*/*.hdr
 /s390x/snippets/*/*.*obj
-- 
2.34.1

