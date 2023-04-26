Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4486EF04F
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbjDZIeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbjDZIef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:34:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E643AAF;
        Wed, 26 Apr 2023 01:34:34 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q8QtIB007098;
        Wed, 26 Apr 2023 08:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=OA0kC+GRdHv/rQTH3I+pDcRXjeEQsXOkdcLnz7/ESEg=;
 b=q712EucZsVA5+mVj+FHddKzhj8PNmbX46YpqOS2t6+LNldXc37XgNcJQKA+fAmsnroEK
 3alpPewH4u+FKdwAETx0cI4f6eRVlcb0EImEPuiWuWjKwCoyOCLyRTYoz1JlhPezFseJ
 zu1qAzo1LxfEKcD9MN0DfSiCqGtjFF3iRKhPHIupZSjCYpTWf/fCH5EAU0k6PNYF+HDl
 5iLXdXt1cKgcwtv2PDT0uK7OrDCFj7aYAI0ml3IdIjpaOWeyKj/+iST+R7Vfi/tDOCqv
 R/BLdTbE7Q30jsXF/zcdTeqr4uhLqb8ddy4y1Y+ybOf/ai6vcX1MqrahOu8Xw0QuALTK VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6yvc1aku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:33 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33Q8RRhl010430;
        Wed, 26 Apr 2023 08:34:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q6yvc1ajw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q3rnDY006233;
        Wed, 26 Apr 2023 08:34:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q47771unq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 08:34:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33Q8YR6X15532782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 08:34:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F6622004E;
        Wed, 26 Apr 2023 08:34:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF9B220040;
        Wed, 26 Apr 2023 08:34:26 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 08:34:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v8 0/2] S390x: CPU Topology Information
Date:   Wed, 26 Apr 2023 10:34:24 +0200
Message-Id: <20230426083426.6806-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: o6sY8KpvPSgwlWHJPY4wiVrQD2OxmsBM
X-Proofpoint-ORIG-GUID: 0l5A3UPcqq-DOo1VpTByYdW50XJDrug4
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxlogscore=855 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 adultscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304260064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the kvm-unit-test s390x CPU topology series.

0. what is new in this new spin
-------------------------------

- Checking different entitlement for vertical polarization

1. what is done
---------------

- First part is checking PTF errors, for KVM and LPAR

- Second part is checking PTF polarization change and STSI
  with the cpu topology including drawers and books.
  This tests are run for KVM only.

To run these tests under KVM successfully you need Linux 6.0
and the latest QEMU patches you find at:

https://lists.gnu.org/archive/html/qemu-devel/2023-04/msg04568.html

Note that Fedora-35 already has the CPU Topology backport for Linux.

To start the test in KVM just do:

# ./run_tests.sh topology

or something like:

# ./s390x-run s390x/topology.elf \
	-smp 5,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 \
	-append '-drawers 3 -books 3 -sockets 4 -cores 4'

Of course the declaration of the number of drawers, books, socket and
core must be coherent between -smp and -append arguments.

- Running the test on LPAR has been getestet on a46lp21

Regards,
Pierre

Pierre Morel (2):
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/sclp.c    |   6 +
 lib/s390x/sclp.h    |   4 +-
 lib/s390x/stsi.h    |  36 ++++
 s390x/Makefile      |   1 +
 s390x/topology.c    | 516 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   6 +
 6 files changed, 568 insertions(+), 1 deletion(-)
 create mode 100644 s390x/topology.c

-- 
2.31.1

new in v8:

- define PTF_INVALID_FUNCTION
  (Claudio)

- test every single bits for specification in the ptf instruction
  (Claudio)

- test vertical polarization twice
  (Claudio)

- add an assert(read_info)
  (Nico)

- changed skips
  (Nico)


new in v7:

- better checks using device attributes on commandline
  (Pierre)
- use builtin to get the number of CPU in the TLE mask
  (Thomas)
- use Elvis (not dead)
  (Thomas)
- reset before tests
  (Nina)
- splitting test_ptf in small functions
  (Thomas)
- check every ptf function code for program check
  (Nina)
- Test made on LPAR
  (Janosch)
- use a single page for SYSIB
  (Thomas)
- abort on wrong parameter
  (Thomas)
- implement SYSIB check with a recursive funtion
  (Nina)
- diverse little changes (naming, clearer checks
  (Nina, Thomas)

