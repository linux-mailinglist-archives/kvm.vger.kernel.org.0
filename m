Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A744B134763
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgAHQNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 11:13:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729395AbgAHQNa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jan 2020 11:13:30 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 008GDPS3041702
        for <kvm@vger.kernel.org>; Wed, 8 Jan 2020 11:13:29 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xdg1bntw0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:13:27 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 8 Jan 2020 16:13:22 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 Jan 2020 16:13:19 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 008GDIbh47251896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jan 2020 16:13:18 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FA0BAE051;
        Wed,  8 Jan 2020 16:13:18 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02A0DAE045;
        Wed,  8 Jan 2020 16:13:18 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.108])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jan 2020 16:13:17 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/4] s390x: SCLP Unit test
Date:   Wed,  8 Jan 2020 17:13:13 +0100
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20010816-4275-0000-0000-00000395D739
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20010816-4276-0000-0000-000038A9C4E0
Message-Id: <20200108161317.268928-1-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_04:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=806 bulkscore=0 impostorscore=0
 clxscore=1015 phishscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080133
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
 s390x/sclp.c             | 462 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   8 +
 6 files changed, 500 insertions(+), 7 deletions(-)
 create mode 100644 s390x/sclp.c

-- 
2.24.1

