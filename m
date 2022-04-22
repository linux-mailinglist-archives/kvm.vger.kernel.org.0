Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C309750B5AD
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446929AbiDVK54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 06:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344416AbiDVK5y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 06:57:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE863A2;
        Fri, 22 Apr 2022 03:55:00 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23M8E7MT007509;
        Fri, 22 Apr 2022 10:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=evssS65znSL4US0yutJ2bW4WDBbDhdYge6WwoF0UEVw=;
 b=rmoOw5bDt0LqI71AmC1bJ/Y+rEwxIp/e6WiDkbbo+UpSbAN+2wq781Nxgh6ZsBJ61bR0
 GU08E+5IVGjzDH3qWlE1gNP+y6xVFUzAOchUqHt90KGdV5nsvKK0uWa7oT6utgIm5sND
 p2ZNlZ/J5nua656jfYXcNes3JU3gav0RQGW6FJkEA/4b/NSxYedGjbQBSQC3BpGGTm6Z
 GXdrDFPfXhkKTGOA7S/fEZMSFZs5UnDhealns+BmqcCSapSC8A5UNiQUQNeVcfMMd0LY
 S/mJmtEhNNqt6OYzsNd6RnhXEz4HPotjSNFxuuf/2/TqTi+uzr0D96VN9EdILJMx7n3e Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkdg4wjqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:55:00 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MArZlS022639;
        Fri, 22 Apr 2022 10:55:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fkdg4wjpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:54:59 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MAsBDm010198;
        Fri, 22 Apr 2022 10:54:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8ybfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 10:54:57 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MAss0n16843028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 10:54:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38AA4AE05A;
        Fri, 22 Apr 2022 10:54:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BDE4AE059;
        Fri, 22 Apr 2022 10:54:53 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 10:54:53 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/4] s390x: add migration test support
Date:   Fri, 22 Apr 2022 12:54:49 +0200
Message-Id: <20220422105453.2153299-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ydIuzWOuMcD3TX4H11OgXN824bR7hXgP
X-Proofpoint-GUID: VX69jzyXMPmpBnrSTkWZD_KdPQE6Cf97
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog from v3:
---
- Rename read_buf_end to read_buf_length (Thanks Janosch)

This series depends on my SIGP store additional status series to have access to
the guarded-storage and vector related defines
("[kvm-unit-tests PATCH v3 0/2] s390x: Add tests for SIGP store adtl status").

Add migration test support for s390x.

arm and powerpc already support basic migration tests.

If a test is in the migration group, it can print "migrate" on its console. This
will cause it to be migrated to a new QEMU instance. When migration is finished,
the test will be able to read a newline from its standard input.

We need the following pieces for this to work under s390x:

* read support for the sclp console. This can be very basic, it doesn't even
  have to read anything useful, we just need to know something happened on
  the console.
* s390/run adjustments to call the migration helper script.

This series adds basic migration tests for s390x, which I plan to extend
further.

Nico Boehr (4):
  lib: s390x: add support for SCLP console read
  s390x: add support for migration tests
  s390x: don't run migration tests under PV
  s390x: add basic migration test

 lib/s390x/sclp-console.c |  79 ++++++++++++++++--
 lib/s390x/sclp.h         |   8 ++
 s390x/Makefile           |   2 +
 s390x/migration.c        | 172 +++++++++++++++++++++++++++++++++++++++
 s390x/run                |   7 +-
 s390x/unittests.cfg      |   5 ++
 scripts/s390x/func.bash  |   2 +-
 7 files changed, 267 insertions(+), 8 deletions(-)
 create mode 100644 s390x/migration.c

-- 
2.31.1

