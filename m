Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B8563D800
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiK3OXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiK3OXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:23:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66313F03A
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:22:59 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUCK1nq011342;
        Wed, 30 Nov 2022 14:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=Upc3+TTUZvNSxx+EgH7E9d2xAcpMJOfngkQYZGdn47s=;
 b=YlLqZyq/jO50j4qr4HXXsLDtxy4iOuJBpwOAPuP7yXe7RhGSg6yN60pMlhXO3j9CFPHK
 41WrVLmyOe2hgDQGLRjmE8lCoTBN+X1DqmqzLLUnfizKnioPmDuqp5QM4Y4OleuezXAv
 J/fgzGEN+jSlyV/kbG8JkEDpVoV/WcoDKcz4yqx0gJwHH6fNuTJ6L/WAKaWBtyxIDIF2
 t0thLFcztKoKwJp/JdvV7bVcdTUV+PRFGFAgzeuBdDie0zy8jBuz9r3959kbPuzke4qQ
 djqAP8uWFhaMBb5A6MZ7zhUx4vr7GyiGYgfCXxwEOLEyWAe3jtkxNSJxd81pyP7OC1B2 +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abnmum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUD0W4o010830;
        Wed, 30 Nov 2022 14:22:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65abnmt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUELNVX014655;
        Wed, 30 Nov 2022 14:22:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3m3ae9c9g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 14:22:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUEMoFc6816478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 14:22:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D800AE051;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09AD8AE055;
        Wed, 30 Nov 2022 14:22:50 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 14:22:49 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/4] lib: add function to request migration
Date:   Wed, 30 Nov 2022 15:22:45 +0100
Message-Id: <20221130142249.3558647-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h5zUifUJNXGPoojP6JVolNSMxwVLU6Cz
X-Proofpoint-GUID: rkbgnzzdcWwDdOo1I-CT5cCNWPKBDq99
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=716
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this series, I pick up a suggestion Claudio has brought up in my
CMM-migration series[1].

Migration tests can ask migrate_cmd to migrate them to a new QEMU
process. Requesting migration and waiting for completion is hence a
common pattern which is repeated all over the code base. Add a function
which does all of that to avoid repetition.

Since migrate_cmd currently can only migrate exactly once, this function
is called migrate_once() and is a no-op when it has been called before.
This can simplify the control flow, especially when tests are skipped.

[1] https://lore.kernel.org/kvm/20221125154646.5974cb52@p-imbrenda/

Nico Boehr (4):
  lib: add function to request migration
  powerpc: use migrate_once() in migration tests
  s390x: use migrate_once() in migration tests
  arm: use migrate_once() in migration tests

 arm/Makefile.common     |  1 +
 arm/debug.c             | 14 ++++--------
 arm/gic.c               | 49 ++++++++++++-----------------------------
 lib/migrate.c           | 34 ++++++++++++++++++++++++++++
 lib/migrate.h           |  9 ++++++++
 powerpc/Makefile.common |  1 +
 powerpc/sprs.c          |  4 ++--
 s390x/Makefile          |  1 +
 s390x/migration-cmm.c   | 27 ++++++++---------------
 s390x/migration-sck.c   |  4 ++--
 s390x/migration-skey.c  | 23 ++++++++-----------
 s390x/migration.c       |  7 ++----
 12 files changed, 88 insertions(+), 86 deletions(-)
 create mode 100644 lib/migrate.c
 create mode 100644 lib/migrate.h

-- 
2.36.1

