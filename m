Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C7B63EC2A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 10:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiLAJRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 04:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiLAJRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 04:17:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9C949B48
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 01:17:48 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B18hh6q023052
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 09:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=b/SOOhT3dOEyv5vqa71rmT3+uDPlPMex1nHHZeRwUHQ=;
 b=DjCNaskNIgoadqMYYkhkavdJpHJXiXjpMy85FNxsgexhVi4LBpWRBSEftSey57el9pGY
 arLyyCLod9YZ5QRfRAAtUMbjPZ2hDeWIjXW8p/0L6Rcz3ktgn1jiEB4N3HbDiDH+eByo
 8Shi0+b+NPh8b/uYUhrdd3Ny7tvwGHC9Rr2CW0hGAq6hHqcI5iJHZBzp/gO7LskDuYEv
 agKb5g2P0Q6nGQpttEy5o51uMPCLhG7ZSw6zCx+k3ynQgEZdhzqVWCqCkmEKW6G4L+aX
 NhKHZcJRd8B2d6vdbB4KO/7StgAsO612759RvcC4gixU6v3CeJhCpod1qNKLLgSdtwVE aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s0nh5y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 09:17:47 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B191ChK031313
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 09:17:47 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6s0nh5xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 09:17:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B196ss4022110;
        Thu, 1 Dec 2022 09:17:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3m3a2hw4na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 09:17:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B19HgBp3277356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 09:17:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 428BEA4055;
        Thu,  1 Dec 2022 09:17:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AF01A4040;
        Thu,  1 Dec 2022 09:17:42 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 09:17:41 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/2] s390x: test CMM during migration
Date:   Thu,  1 Dec 2022 10:17:39 +0100
Message-Id: <20221201091741.3772856-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CMtMuLybkzrnt6aac6q5V9-6fRJgdhwP
X-Proofpoint-ORIG-GUID: rokReCKowJXI26eBcpUdt0z3l93yjoUl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_04,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 mlxlogscore=967 malwarescore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3->v4:
---
* rebase on top of Claudio's series
    [kvm-unit-tests PATCH v3 0/2] lib: s390x: add PSW and
    PSW_WITH_CUR_MASK macros
    https://lore.kernel.org/kvm/20221130154038.70492-1-imbrenda@linux.ibm.com/
* switch cmm.h to system includes
* move const qualifier before struct keyword

v2->v3:
---
* make allowed_essa_state_masks static (thanks Thomas)
* change several variables to unsigned (thanks Claudio)
* remove unneeded assignment (thanks Claudio)
* fix line length (thanks Claudio)
* fix some spellings, line wraps (thanks Thomas)
* remove unneeded goto (thanks Thomas)
* add migrate_once (thanks Claudio)
  I introduce migrate_once() only in migration-during-cmm.c for now, but
  I plan to send a future patch to move it to the library.
* add missing READ_ONCE (thanks Claudio)

v1->v2:
---
* cmm lib: return struct instead of passing in a pointer (thanks Claudio)
* cmm lib: remove get_page_addr() (thanks Claudio)
* cmm lib: print address of mismatch (thanks Claudio)
* cmm lib: misc comments reworked, added and variables renamed
* make sure page states change on every iteration (thanks Claudio)
* add WRITE_ONCE even when not strictly needed (thanks Claudio)

Add a test which changes CMM page states while VM is being migrated.

Nico Boehr (2):
  s390x: add a library for CMM-related functions
  s390x: add CMM test during migration

 lib/s390x/cmm.c              |  92 ++++++++++++++++++++++++++
 lib/s390x/cmm.h              |  31 +++++++++
 s390x/Makefile               |   2 +
 s390x/migration-cmm.c        |  33 ++--------
 s390x/migration-during-cmm.c | 123 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 6 files changed, 260 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/cmm.c
 create mode 100644 lib/s390x/cmm.h
 create mode 100644 s390x/migration-during-cmm.c

-- 
2.36.1

