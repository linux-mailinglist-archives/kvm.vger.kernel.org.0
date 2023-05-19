Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D970966B
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjESLW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjESLWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:22:48 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B58310E4;
        Fri, 19 May 2023 04:22:45 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JBB7Et010087;
        Fri, 19 May 2023 11:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=mwAFw64s1R/mLe7viL/uIsDZ+8vYN2r3Z6OEnQJ0boQ=;
 b=fHJkVOeDEc1BOFGxc7dKxIcQYeiE/t1u861njDNf42Q5jcnkPUBJ/2y11U/DmYl3tcEz
 kT3oEcDOKtFFVS3jWzy4MsPgUbTDZAPYAQ9ZuFmZd9x4xgef6qWXKdJaQEIzq3nhe4UB
 Cqlr34ec2UlHHfbvTdUCbMwC26GBdF9n0k7jAZG1pePTuAhHhqDJAlPu8C+r2ZxajCri
 mUIIB2gPIy9LAd8WJ9rh0CRLGBDbkR3mUJbyxyYS9UIhscInkIXdpP1gUjr8TKNAF09z
 yIrTrblqqDdWzZFL1bHP+XBEnNo0DXtubgYZxAwqr54RsH6TxBbo08cTHqNLTFVnMuOw RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp6fpjfbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:43 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34JBDNdA016505;
        Fri, 19 May 2023 11:22:43 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qp6fpjfaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:43 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34J9bCSI011002;
        Fri, 19 May 2023 11:22:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qj264u4wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 May 2023 11:22:41 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34JBMchS46924186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:22:38 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FB7920043;
        Fri, 19 May 2023 11:22:38 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BC8920040;
        Fri, 19 May 2023 11:22:37 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.54.120])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 19 May 2023 11:22:37 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v9 0/2] S390x: CPU Topology Information
Date:   Fri, 19 May 2023 13:22:34 +0200
Message-Id: <20230519112236.14332-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: W_2_3qLqyyIT61hL5xwgLFfrDBHgBaM7
X-Proofpoint-ORIG-GUID: hsShoEz3ALyM0C-sKbVAH7j7xu9IN9L0
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_07,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=662 mlxscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the kvm-unit-test s390x CPU topology series.

0. what is new in this new spin
-------------------------------

- more configuration tested in unittests.cfg
- one of the tested configuration using 248 processors will failed
  until SCLP bug is corrected
- several cleanup

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
 s390x/topology.c    | 515 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  14 ++
 6 files changed, 575 insertions(+), 1 deletion(-)
 create mode 100644 s390x/topology.c

-- 
2.31.1

new in v8:

- use report_fail instead of report(0,...
  (Nico)

- add 2 more configurations in unittests.cfg
  (Nico)

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

