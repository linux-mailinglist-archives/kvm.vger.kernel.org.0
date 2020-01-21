Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50FC143E4E
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 14:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAUNnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 08:43:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726968AbgAUNnS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 08:43:18 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LDgYPg053571
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:16 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xp1v599tg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 08:43:16 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 21 Jan 2020 13:43:14 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Jan 2020 13:43:12 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00LDhBqP54657158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 13:43:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BC4DA4065;
        Tue, 21 Jan 2020 13:43:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23889A4054;
        Tue, 21 Jan 2020 13:43:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.211])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jan 2020 13:43:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/9] s390x: smp: Improve smp code and reset checks
Date:   Tue, 21 Jan 2020 08:42:45 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20012113-0016-0000-0000-000002DF61D5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012113-0017-0000-0000-0000334209A0
Message-Id: <20200121134254.4570-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-21_04:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=385 mlxscore=0
 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's extend sigp reset testing and clean up the smp library as well.

GIT: https://github.com/frankjaa/kvm-unit-tests/tree/smp_cleanup

V4:
	* Introduce set_flag() for manipulating testflag
	* Cleanup of stray braces and mb()s

v3:
	* Added patch to introduce cpu loop in cpu setup
	* Added patch that removes cpu loops in favor of the previously introduced one
	* Fixed inline assembly for fpc dirtying
	* Moved cpu stop hunk from first into the second patch
	* Reworked patch #4 commit message and added a comment when waiting for PU

v2:
	* Added cpu stop to test_store_status()
	* Added smp_cpu_destroy() to the end of smp.c main()
	* New patch that prints cpu id on interrupt errors
	* New patch that reworks cpu start in the smp library (needed for lpar)
	* nullp is now an array


Janosch Frank (9):
  s390x: smp: Cleanup smp.c
  s390x: smp: Only use smp_cpu_setup once
  s390x: Add cpu id to interrupt error prints
  s390x: smp: Rework cpu start and active tracking
  s390x: smp: Wait for cpu setup to finish
  s390x: smp: Loop if secondary cpu returns into cpu setup again
  s390x: smp: Remove unneeded cpu loops
  s390x: smp: Test all CRs on initial reset
  s390x: smp: Dirty fpc before initial reset test

 lib/s390x/interrupt.c | 20 +++++-----
 lib/s390x/smp.c       | 53 ++++++++++++++----------
 s390x/cstart64.S      |  4 ++
 s390x/smp.c           | 93 ++++++++++++++++++++++++++++---------------
 4 files changed, 106 insertions(+), 64 deletions(-)

-- 
2.20.1

