Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1695E63A961
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 14:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiK1NXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 08:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiK1NXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 08:23:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD0964F0
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 05:23:31 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASC6D1W010012
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2EKGZME4M6TonorHHKogq0GKniDkIBch3LZcFy58Bag=;
 b=RWXXHed+9nYPp9ePTBAub+kGZa1PNElM4fix92EgcpVUQbgMzmWCGIHa6qr+AjmvHd8Y
 biCjy7TJBGshh7pkI/fyrpvVjfiDUIDiEMI/OalZQY+DdvB+x9K4BudiyykHboz6iEcw
 YSb0/MF/8Xr6UvAiyQxJzsX51YmFhwYbFTZE4AsyFCcqgnMwTELBq43jq4fSLw3C8KD1
 Ls3TzXlQHV32cXqA1neZ0re5XkRoIhSh3Wxc7JYKMPmT+4wGmqLq/RX9KEgKC2fNDExE
 5cn1nVWFRlkgSXiFyHASGO+xgUnqJcsLVrn/10zbKc27OJ+sHO5g+detGoZA5EgjLXkf tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpkyea5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:30 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASDKZrn029291
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:23:30 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpkye9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASDKhgS022074;
        Mon, 28 Nov 2022 13:23:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3m3ae91v0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 13:23:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASDO6ep51118372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 13:24:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D54B4C046;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 004A04C044;
        Mon, 28 Nov 2022 13:23:24 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 13:23:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: test CMM during migration
Date:   Mon, 28 Nov 2022 14:23:21 +0100
Message-Id: <20221128132323.1964532-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VZvwkeOIjDI5Xm4nQSn8f_4ynEis9Csi
X-Proofpoint-GUID: Qhp3HLGk3G3RXJ3w3Nozgll0LBtDwubD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_09,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=934
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

 lib/s390x/cmm.c              |  92 +++++++++++++++++++++++++
 lib/s390x/cmm.h              |  31 +++++++++
 s390x/Makefile               |   2 +
 s390x/migration-cmm.c        |  34 +++-------
 s390x/migration-during-cmm.c | 127 +++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg          |   5 ++
 6 files changed, 265 insertions(+), 26 deletions(-)
 create mode 100644 lib/s390x/cmm.c
 create mode 100644 lib/s390x/cmm.h
 create mode 100644 s390x/migration-during-cmm.c

-- 
2.36.1

