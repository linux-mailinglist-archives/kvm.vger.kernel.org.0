Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3866C0C99
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 09:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjCTI4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 04:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCTI4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 04:56:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC83511146;
        Mon, 20 Mar 2023 01:56:50 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32K88wAW010747;
        Mon, 20 Mar 2023 08:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=istdSc/C2kq9oGpltGPzxa5vuaH/tbn/Tp91/EzD+/k=;
 b=h5FnHSnRMKSDhFGNqWB8ZnFTpcXXNYAJeSkmxvU6jUeOSZ6shvi6JhKvUdSd/2wjBmJm
 Ig7GcfnehVDT6/hykIILp576A2sw1MdNLtF+xKzX6Gcrq9/rDNJsS4odBrPVCARuZYmz
 qFdLqEdu9qLtaJUVurG8cvs1G0qJGGeP5urIUc+vL99UxiWcs2hRKjz76DQ3WoEDQys0
 OaHaxqb1gS+VxM1R1uRK2slylGNII35kT2WLyE5sm4ZtIB6TPSKn7V+dbROKf6mjm1xy
 9RCT702yRebI4rRgTccEblkijzba77OR29rsFuXGUwKeStjR1EgtDUZynda0mBoDj+Tf TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq812kyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32K8qIhl027348;
        Mon, 20 Mar 2023 08:56:49 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pdq812kxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:49 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32K3mod9016541;
        Mon, 20 Mar 2023 08:56:47 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pd4x6ay3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Mar 2023 08:56:47 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32K8uhnT20120012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 08:56:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6E8320043;
        Mon, 20 Mar 2023 08:56:43 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49C8D2004B;
        Mon, 20 Mar 2023 08:56:43 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.19.239])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 20 Mar 2023 08:56:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v7 0/2] S390x: CPU Topology Information
Date:   Mon, 20 Mar 2023 09:56:40 +0100
Message-Id: <20230320085642.12251-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6zO9D7fSKZppTwp8cuAWkAHR0DI6Xb_g
X-Proofpoint-ORIG-GUID: O0k8niJyHf4MAO32RqvLHLoIwpJarcsb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_04,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 impostorscore=0 mlxscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303200072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the kvm-unit-test s390x CPU topology series.

0. what is new in this new spin
-------------------------------

- Running the test on LPAR has been getestet on a46lp21
- splitting big functions in small ones
- better tests, reset before test
- Diverse rephrasing and functions reordering

1. what is done
---------------

- First part is checking PTF errors, for KVM and LPAR

- Second part is checking PTF polarization change and STSI
  with the cpu topology including drawers and books.
  This tests are run for KVM only.

To run these tests under KVM successfully you need Linux 6.0
and the QEMU patches you find at:

https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg00081.html

Note that Fedora-35 already has the CPU Topology backport for Linux.

To start the test in KVM just do:

# ./run_tests.sh topology

or something like:

# ./s390x-run s390x/topology.elf \
	-smp 5,drawers=3,books=3,sockets=4,cores=4,maxcpus=144 \
	-append '-drawers 3 -books 3 -sockets 4 -cores 4'

Of course the declaration of the number of socket and core must be
coherent in -smp and -append arguments.


To start the tests in LPAR you need to define the loader entry.
For example, under RedHat:

	title topology
	version topology.bin
	linux /boot/topology.bin
	initrd /boot/initramfs-topology.bin.img
	options -drawers 4 -books 4 -sockets 2 -cores 8
	id rhel-0-topology.bin
	grub_users $grub_users
	grub_arg --unrestricted
	grub_class kernel

Output of the test is done on the SCLP console.

Regards,
Pierre

Pierre Morel (2):
  s390x: topology: Check the Perform Topology Function
  s390x: topology: Checking Configuration Topology Information

 lib/s390x/sclp.c    |   5 +
 lib/s390x/sclp.h    |   4 +-
 lib/s390x/stsi.h    |  36 ++++
 s390x/Makefile      |   1 +
 s390x/topology.c    | 471 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  11 ++
 6 files changed, 527 insertions(+), 1 deletion(-)
 create mode 100644 s390x/topology.c

-- 
2.31.1

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

