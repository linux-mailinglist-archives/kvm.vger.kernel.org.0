Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B297637A24
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiKXNpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKXNpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:45:00 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1445100B3E
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:44:58 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOD5GYV019725
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JEeJ+jD97Rd3g7UzA5we5gJ+pja2FAM9sK3EP1DoVMA=;
 b=Zb+nlMqqGAjLpuwtxB/+LfE2XId7lXfjCbiEZyL3lTyai5iELnU10Fuo9myqqU70BPcd
 J6hNWVFh88aDLtf6KZzb4JMDHPeF8gYesRPVBwNiCg9XHJmuiYh/hWgAN7dyW91hz8ZA
 esNmCk+wLFczloW9wJI0gOHYiHv4B24u3nkbjNHkT15Bma2K5sPaAAhvNtgjA/WeVBY1
 eVst4g8PhLfiLAiuZ13d/C3D/7kprUss2BcLxjbgRW87GtFcDYaMK+t1sy4KD1U/zuWz
 TIQAktZnA20dviobaJCdzWcyvGWO5tIlLhK6eV+PfX3fB7/+PfPPaN4avHyrMilY3uY8 rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6sgmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:44:57 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AODUOS6019374
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 13:44:35 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10w6sgku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:44:35 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AODZYMK012909;
        Thu, 24 Nov 2022 13:44:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8wyb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:44:33 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AODiU1c393836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 13:44:30 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E54211C052;
        Thu, 24 Nov 2022 13:44:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 032D911C04C;
        Thu, 24 Nov 2022 13:44:30 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 13:44:29 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/2] s390x: test CMM during migration
Date:   Thu, 24 Nov 2022 14:44:27 +0100
Message-Id: <20221124134429.612467-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TGA8RPZWoWsY4teTcwacdhfgCDj2Ilnd
X-Proofpoint-ORIG-GUID: LV1wGl81yk84V29AC7uKXX11gZ--gU7s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_10,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=879 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 lib/s390x/cmm.c              |  90 ++++++++++++++++++++++++++
 lib/s390x/cmm.h              |  31 +++++++++
 s390x/Makefile               |   2 +
 s390x/migration-cmm.c        |  34 +++-------
 s390x/migration-during-cmm.c | 121 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 6 files changed, 257 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/cmm.c
 create mode 100644 lib/s390x/cmm.h
 create mode 100644 s390x/migration-during-cmm.c

-- 
2.36.1

