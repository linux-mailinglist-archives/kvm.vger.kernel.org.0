Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E5263EB87
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 09:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiLAIsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 03:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLAIrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 03:47:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F3E88B58
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 00:46:50 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18Bw0c031308
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JxafbpRcHn6F0tOrm0JSCNZgdVGKekZuHIrbkY8/3BE=;
 b=IXUAF8d5oqni5ilb30HOoninryE1w6HdWQogWr+1k2u7Y98xGtagZ9AhwSQD6QrV0Zru
 9PFoif4J1BEb4fwZn2jMTn26BEE0M+szmoUZ1Cd++ppof4B6a6rxPJVbpIVSNsAwFUjm
 0ES52Jo/CiAGIEWY0I0g0BgxC1LwsO5vCAR/ZFZYnnVvwNDbV3nKoWfNZjrmdbhAJkqs
 Ks9yi+B2DtK2oZ9t4LWmJrIfAuFsg+96izhlvDaYs6pRAnOXMEzgGuegV23sFTuHvWnj
 m/R822eLN2mN/d29uBUwqY9k3q9B0nReQJOLcO4OEWxawAQhNYhOPKR88EqneDLHwVml MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6rhxgxhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:46:49 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B18KIKT029199
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 08:46:49 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6rhxgxgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:49 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B18ZqWm004378;
        Thu, 1 Dec 2022 08:46:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3m3ae953py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 08:46:46 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B18khuL9175774
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 08:46:43 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46412AE04D;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05697AE045;
        Thu,  1 Dec 2022 08:46:43 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 08:46:42 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/3] s390x: test storage keys during migration
Date:   Thu,  1 Dec 2022 09:46:39 +0100
Message-Id: <20221201084642.3747014-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5xQd2Nhlrhq0HB8v9plZ082WWceXIPz2
X-Proofpoint-GUID: HTBfjLG5TnDk6HOtp8raRLa4jeRq6CWi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 mlxlogscore=740 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test which changes storage keys while VM is being migrated.

This series bases on Claudio's new PSW macros ("[PATCH v3 0/2] lib:
s390x: add PSW and PSW_WITH_CUR_MASK macros").

Nico Boehr (3):
  s390x: add library for skey-related functions
  lib: s390x: skey: add seed value for storage keys
  s390x: add storage key test during migration

 lib/s390x/skey.c              |  94 +++++++++++++++++++++++++++++++
 lib/s390x/skey.h              |  42 ++++++++++++++
 s390x/Makefile                |   2 +
 s390x/migration-during-skey.c | 103 ++++++++++++++++++++++++++++++++++
 s390x/migration-skey.c        |  44 ++-------------
 s390x/unittests.cfg           |   5 ++
 6 files changed, 252 insertions(+), 38 deletions(-)
 create mode 100644 lib/s390x/skey.c
 create mode 100644 lib/s390x/skey.h
 create mode 100644 s390x/migration-during-skey.c

-- 
2.36.1

