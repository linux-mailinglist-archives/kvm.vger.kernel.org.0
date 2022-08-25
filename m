Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6E15A11B4
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 15:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242434AbiHYNQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 09:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242429AbiHYNQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 09:16:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B82A99EC
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 06:16:07 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PCx3NL019284
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8qwGLlpvWI9hi21F4ewUDUo4JmXVtxDCP2E6eRerLpg=;
 b=QjMYbbWQFrPtXZZ2ZRYz3xOZJCqamr/B248cp8M0PxK4RIwQUE8S3/LC6nQWEnEAlnVQ
 kZtCb+Ns6/qefvXDw4x6gfU3+5SJjGkmCe1L5PmWcXRzfUSF8Qc1Z1DiFfiTgkxoAvvk
 8a65X0mK4TWY/WzVfjKAaJgBLYZSeb2FM4CO0ZkaQkuocSIgCMJvhXKR2uCR5KYkZOGn
 VsNPZqUtTnN621HafJTnG/9uFr8kZaTlRlp+Wi5bCVra2YlO3EYgVdIcWeRv1r0aGxKJ
 Aom9FieDwJFcVf3/7CPjjZ3ee5Y6IpZaXYzS/4ZMjvYiiAwr2jtlrCJO+etbFvGm7oxV Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j69jn8p60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PCxhvH022186
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 13:16:06 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j69jn8p5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:06 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PCp4JZ025342;
        Thu, 25 Aug 2022 13:16:03 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3j2q88vqt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 13:16:03 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PDGL1k41550332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 13:16:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95C3E5204E;
        Thu, 25 Aug 2022 13:16:00 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 55EDC5204F;
        Thu, 25 Aug 2022 13:16:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: dump support for PV tests
Date:   Thu, 25 Aug 2022 15:15:58 +0200
Message-Id: <20220825131600.115920-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vOUrKZAUazRMebsXFwghqwQJ_BsKY4U6
X-Proofpoint-GUID: MM9J1tV6M_4M-odqrXpmt5XNqW7QrO7j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=509
 impostorscore=0 clxscore=1015 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
---
- add newline after genprotimg_args (thanks Janosch)
- add a comment explaining what the CCK is (thanks Janosch)

With the upcoming possibility to dump PV guests under s390x, we should
be able to dump kvm-unit-tests for debugging, too.

Add the necessary flags to genprotimg to allow dumping.

Nico Boehr (2):
  s390x: factor out common args for genprotimg
  s390x: create persistent comm-key

 s390x/Makefile | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

-- 
2.36.1

