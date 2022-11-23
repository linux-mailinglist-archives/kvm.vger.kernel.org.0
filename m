Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C950635317
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiKWIrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:47:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiKWIrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:47:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AE832BA3;
        Wed, 23 Nov 2022 00:47:16 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN73YMN029626;
        Wed, 23 Nov 2022 08:47:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=lvAu0qQITZS7YGSI88/im/srfSVK9ZZRRA1sDeDUD9E=;
 b=bAvXinH0a0xnFZuJeLbw4pMg8e6v++sH+8dCj9ah8LeFyBLoIiNZNmzYSRmILxQcq0QL
 24sb8LWdLGF1P3IvZl74hnhDjrYhK0DHVEIvljnQe1CzRyRJYbnH3d1H3xAiq6EZNvTY
 h84RNXSRKebLX0bDSX7+DHTnHo1G1qWBMIPklKe5e5NAC+/Ksg/RNdI3dIKR8RAiC9s0
 SZUdrLnnXm/AhTF3vmGeZmM9jhRUvVhBxh6m/5sJdoqI+mz0d7FhnXiviKk1unhhlDLH
 L+R9UVCKB3QoY1oYEzDPscm1E40NwiFjSRW4oud8sf4KZ6EDuUDRbLWMQGcl6nehm7/n 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sqmyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:15 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN8k3EC021148;
        Wed, 23 Nov 2022 08:47:15 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100sqmxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:14 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN8ZM8Z021561;
        Wed, 23 Nov 2022 08:47:13 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8uxbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN8l9a965143102
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 08:47:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B97EE11C04A;
        Wed, 23 Nov 2022 08:47:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC0C011C054;
        Wed, 23 Nov 2022 08:47:08 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 08:47:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/5] s390x: Snippet fixes
Date:   Wed, 23 Nov 2022 08:46:51 +0000
Message-Id: <20221123084656.19864-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: U7eWxK6QtOYIgrCbMeWmfiVGrqx4_VZT
X-Proofpoint-ORIG-GUID: D0uZQ0pw4I04yMVMMiAS3fDXj1gZ4ZJe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=803 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A small set of fixes mostly related to the snippet support and error
management.

Janosch Frank (5):
  s390x: Add a linker script to assembly snippets
  s390x: snippets: Fix SET_PSW_NEW_ADDR macro
  lib: s390x: sie: Set guest memory pointer
  s390x: Clear first stack frame and end backtrace early
  lib: s390x: Handle debug prints for SIE exceptions correctly

 lib/s390x/interrupt.c       | 46 +++++++++++++++++++++++++++++++++----
 lib/s390x/sie.c             |  1 +
 lib/s390x/sie.h             |  2 ++
 lib/s390x/snippet.h         |  3 +--
 lib/s390x/stack.c           |  2 ++
 s390x/Makefile              |  5 ++--
 s390x/cpu.S                 |  6 +++--
 s390x/cstart64.S            |  2 ++
 s390x/mvpg-sie.c            |  2 +-
 s390x/pv-diags.c            |  6 ++---
 s390x/snippets/asm/flat.lds | 43 ++++++++++++++++++++++++++++++++++
 s390x/snippets/asm/macros.S |  2 +-
 12 files changed, 104 insertions(+), 16 deletions(-)
 create mode 100644 s390x/snippets/asm/flat.lds

-- 
2.34.1

