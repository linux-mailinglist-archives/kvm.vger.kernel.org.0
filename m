Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B240454AEFA
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 13:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352133AbiFNLFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 07:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiFNLF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 07:05:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1198F424AE;
        Tue, 14 Jun 2022 04:05:28 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E9VkJg011291;
        Tue, 14 Jun 2022 11:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=d4kFP/o4mLaqrLpvjS5rGwx9s2nLny7osOn3PO9cBeE=;
 b=EdGSULKiZ2f5QRxzzHmX5We8uJn0hkc53q9yoVzZYSDgnhBUVv3VuZm++YyNbNFJLkk5
 hs8loQeA/XvdQ2UM1M2U2EjVgcLi/+md2qnx+utgtYlxDkLdEjPu+r6XuRNS6FY7oJGL
 pIk3eSB6RuIt/qwa8Ep8msa8e4jWRi9dXI1pOUgAqv7u1LWuGeE2kpd+dJjiV9lydeER
 0XCZ7/LWpEWO2KRBm/05pg617O/6NV4ffMjhk8PET8pu6DJkBAZ8QctvB2ig2zX2ZCpo
 r7q6PLNFUaQqI6Wo+7s7s9aa3ikmaeMO0vD9FCfCM7Q2R2spsM1caddR2HTE2jLvAWnx 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqnb2hmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:28 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EAj1v1024411;
        Tue, 14 Jun 2022 11:05:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpqnb2hm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EAosB7022582;
        Tue, 14 Jun 2022 11:05:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3gmjp946u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 11:05:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EB5MKZ16449894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 11:05:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2020042042;
        Tue, 14 Jun 2022 11:05:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C694242041;
        Tue, 14 Jun 2022 11:05:21 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 11:05:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 0/1] s390x: add migration test for storage keys
Date:   Tue, 14 Jun 2022 13:05:20 +0200
Message-Id: <20220614110521.123205-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m28jHzmD4iEnVysx15Gdr0vb8YxmWdpo
X-Proofpoint-GUID: XPjn6XxGanoEpEfDv9DpE3rPqGsUffbv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206140044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v5->v6:
----
* add comment to explain why reference bit is ignored (thanks Janosch)

v4->v5:
----
* don't print message on every skey tested (thanks Janosch)
* extend some comments (Thanks Janosch)

v3->v4:
----
* remove useless goto (Thanks Thomas)

v2->v3:
----
* remove some useless variables, style suggestions, improve commit description
  (thanks Janis)
* reverse christmas tree (thanks Claudio)

v1->v2:
----
* As per discussion with Janis and Claudio, remove the actual access check from
  the test. This also allows us to remove the check_pgm_int_code_xfail() patch.
* Typos/Style suggestions (thanks Janis)

Upon migration, we expect storage keys set by the guest to be preserved,
so add a test for it.

We keep 128 pages and set predictable storage keys. Then, we migrate and check
they can be read back.

Nico Boehr (1):
  s390x: add migration test for storage keys

 s390x/Makefile         |  1 +
 s390x/migration-skey.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg    |  4 ++
 3 files changed, 88 insertions(+)
 create mode 100644 s390x/migration-skey.c

-- 
2.36.1

