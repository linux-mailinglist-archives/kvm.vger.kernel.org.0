Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F59A13763D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbgAJSk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 13:40:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727927AbgAJSk7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 13:40:59 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AIbI4K066516
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 13:40:57 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xerexcw3c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 13:40:57 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 10 Jan 2020 18:40:55 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 10 Jan 2020 18:40:53 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00AIepne48038082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 18:40:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C1F5AE053;
        Fri, 10 Jan 2020 18:40:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30101AE051;
        Fri, 10 Jan 2020 18:40:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jan 2020 18:40:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v7 0/4] s390x: SCLP Unit test
Date:   Fri, 10 Jan 2020 19:40:46 +0100
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011018-0008-0000-0000-0000034854E2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011018-0009-0000-0000-00004A689F5A
Message-Id: <20200110184050.191506-1-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=1 clxscore=1015 bulkscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxlogscore=876
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset contains some minor cleanup, some preparatory work and
then the SCLP unit test itself.

The unit test checks the following:
    
    * Correctly ignoring instruction bits that should be ignored
    * Privileged instruction check
    * Check for addressing exceptions
    * Specification exceptions:
      - SCCB size less than 8
      - SCCB unaligned
      - SCCB overlaps prefix or lowcore
      - SCCB address higher than 2GB
    * Return codes for
      - Invalid command
      - SCCB too short (but at least 8)
      - SCCB page boundary violation

v6 -> v7
* renamed spx() and stpx() wrappers to set_prefix and get_prefix
* set_prefix now takes a value and get_prefix now returns a value
* put back some inline assembly for spx and stpx as a consequence
* used LC_SIZE instead of 2 * PAGE_SIZE everywhere in the unit test
v5 -> v6
* fixed a bug in test_addressing
* improved comments in test_sccb_prefix
* replaced all inline assembly usages of spx and stpx with the wrappers
* added one more wrapper for test_one_sccb for read-only tests
v4 -> v5
* updated usage of report()
* added SPX and STPX wrappers to the library
* improved readability
* addressed some more comments
v3 -> v4
* export sclp_setup_int instead of copying it
* add more comments
* rename some more variables to improve readability
* improve the prefix test
* improved the invalid address test
* addressed further comments received during review
v2 -> v3
* generally improved the naming of variables
* added and fixed comments
* renamed test_one_run to test_one_simple
* added some const where needed
* addresed many more small comments received during review
v1 -> v2
* fix many small issues that came up during the first round of reviews
* add comments to each function
* use a static buffer for the SCCP template when used

Claudio Imbrenda (4):
  s390x: export sclp_setup_int
  s390x: sclp: add service call instruction wrapper
  s390x: lib: add SPX and STPX instruction wrapper
  s390x: SCLP unit test

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |  26 +++
 lib/s390x/sclp.h         |   1 +
 lib/s390x/sclp.c         |   9 +-
 s390x/intercept.c        |  23 +-
 s390x/sclp.c             | 472 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   8 +
 7 files changed, 518 insertions(+), 22 deletions(-)
 create mode 100644 s390x/sclp.c

-- 
2.24.1

