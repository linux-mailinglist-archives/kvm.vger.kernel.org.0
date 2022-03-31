Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CC4EDE58
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239587AbiCaQGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 12:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiCaQGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 12:06:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EB8B879;
        Thu, 31 Mar 2022 09:04:34 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VERdBO005291;
        Thu, 31 Mar 2022 16:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=xxWjSJIC5HPxU+s+k4q/7q9CXiXld8PtClwLKCKWZIs=;
 b=aV6lY9i2W/4wiD6SXXbz71GNNvIYI5o9WGIYs31Fz1c9rKHUQx+oGUTYlauKut1LysPw
 zC2xfKb3ockTbL55s3t7+6a0Z84CJ+l4sJpw41TALkf4EzrrW5CAcjVO7DjRMQHthT/D
 Kq1e6tAJDV6KU+Vg7HXFOzRXA0De+2Ju39zHAUBlbsRev3YNSH4M2wSqaFTmGKS7IEdT
 xKQ84bUldnTxmfpbPdNjhHRF8R8kHPP5wZ96ny6Ns0NWKAIdE07iYxOPiMXwY/6Gq0xa
 a6AjDWwt0zRPTRK9wFbam8mCqq19hB2WPPDhUIS+DHyOnGUTS0V0ZL0r49JtWlpGvDhs 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54c2y1kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:33 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VFoajp004570;
        Thu, 31 Mar 2022 16:04:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f54c2y1jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VFxhxO004585;
        Thu, 31 Mar 2022 16:04:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9k52j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VG4ST551511562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 16:04:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1431C11C050;
        Thu, 31 Mar 2022 16:04:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A3DB11C04A;
        Thu, 31 Mar 2022 16:04:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 16:04:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/5] lib: s390x: Refactor and rename vm.[ch]
Date:   Thu, 31 Mar 2022 18:04:14 +0200
Message-Id: <20220331160419.333157-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Zk4z6PHDLFUnTVLmQPBIP9pCCuz-XJbp
X-Proofpoint-GUID: qHE1SBcLfPyRkEp7rORhhx1fRV7GdrPG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 adultscore=0
 mlxlogscore=579 malwarescore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor and rename vm.[ch] to hardware.[ch]

* Remove some uneeded #includes for vm.h
* Rename vm.[ch] to hardware.[ch]
* Consolidate all detection functions into detect_host, which returns
  what host system the test is running on
* Completely remove obsolete z/VM 6.x check from skey.c
* Rename vm_is_* functions to host_is_*, which are then just wrappers
  around detect_host
* Move machine type macros from arch_def.h to hardware.h
* Add machine_is_* functions
* Refactor and rename get_machine_id to be a simple wrapper for stidp
* Add back get_machine_id using the stidp wrapper

v1->v2
* new patch to completely remove obsolete z/VM 6.x check instead of
  moving it into hardware.h
* do not add macros and functions for all known machine types, z15 is
  enough for now

Claudio Imbrenda (5):
  s390x: remove spurious includes
  s390x: skey: remove check for old z/VM version
  lib: s390: rename and refactor vm.[ch]
  lib: s390x: functions for machine models
  lib: s390x: stidp wrapper and move get_machine_id

 s390x/Makefile           |  2 +-
 lib/s390x/asm/arch_def.h |  7 +--
 lib/s390x/hardware.h     | 55 ++++++++++++++++++++++++
 lib/s390x/vm.h           | 15 -------
 lib/s390x/hardware.c     | 69 ++++++++++++++++++++++++++++++
 lib/s390x/vm.c           | 92 ----------------------------------------
 s390x/cpumodel.c         |  4 +-
 s390x/mvpg-sie.c         |  1 -
 s390x/mvpg.c             |  4 +-
 s390x/pv-diags.c         |  1 -
 s390x/skey.c             | 37 ++--------------
 s390x/spec_ex-sie.c      |  1 -
 s390x/uv-host.c          |  4 +-
 13 files changed, 136 insertions(+), 156 deletions(-)
 create mode 100644 lib/s390x/hardware.h
 delete mode 100644 lib/s390x/vm.h
 create mode 100644 lib/s390x/hardware.c
 delete mode 100644 lib/s390x/vm.c

-- 
2.34.1

