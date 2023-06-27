Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D69A73F6ED
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjF0IWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbjF0IWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:22:08 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D49D1FC3;
        Tue, 27 Jun 2023 01:22:03 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35R8BHPC011257;
        Tue, 27 Jun 2023 08:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KQICVt43VMdWCZaYBJ3FihIkO4Ais8LuVFB6x5RA/Fk=;
 b=eLTcPevp4OYHKpzJTMA3hQLrFxT5ublyEHRSWi/SMgLb9EEb6B0kLvcD2RdgUcpYpieM
 j54J5DniYdoQ3PJkPNlK20OyayQgKmrp4fbp5h4gOxHQ5O2hsSyDfEqYGbkBENG2hl7T
 tXNIygEDPfqXP8H9pEd+LgVdZG08v9Sl9gNatSWZ2h67diug1kly4bOlrAXyiUJaZu+3
 4ogT20PjqqoROQrywP9bV2CdlGryahXPZGlhIA+MnlO9fdBU8FG7Ze8xsD3lnVmRzyHW
 D0sL3l3LtSZJKNgk3xSldZIhbJ1QD+UKpDqKCbYDur0RnnRnwlkjk21Oiss3lmZkea8J Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfuuxgfgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 08:22:02 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35R8EbMI022523;
        Tue, 27 Jun 2023 08:22:01 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rfuuxgffw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 08:22:01 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35R4mKvR010013;
        Tue, 27 Jun 2023 08:22:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3rdr459b8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jun 2023 08:21:59 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35R8Lu3w37356166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jun 2023 08:21:56 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21D5E2004B;
        Tue, 27 Jun 2023 08:21:56 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D171220040;
        Tue, 27 Jun 2023 08:21:55 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com (unknown [9.152.222.242])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 27 Jun 2023 08:21:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com
Subject: [kvm-unit-tests PATCH v10 0/2] S390x: CPU Topology Information
Date:   Tue, 27 Jun 2023 10:21:53 +0200
Message-Id: <20230627082155.6375-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TcRzulZ2Wa6ifUMWdQ4r89plYmIqoujN
X-Proofpoint-GUID: hvxyjROb1hmLc7d4N-a1W3CIrksPBIiy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-27_04,2023-06-26_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=810 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306270076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

new version of the kvm-unit-test s390x CPU topology series.

0. what is new in this new spin
-------------------------------

- the configuration tested in unittests.cfg is compatible with current
  QEMU. A later patch will be needed to use full topology when QEMU
  patches are mainline.
- one of the tested configuration using 248 processors will failed
  until SCLP bug is corrected
- use of -cpu max instead of z14

1. what is done
---------------

- First part is checking PTF errors, for KVM and LPAR

- Second part is checking PTF polarization change and STSI
  with the cpu topology including drawers and books.
  This tests are run for KVM only.

To run these tests under KVM successfully you need Linux 6.0
or newer.

Note that Fedora-35 already has the CPU Topology backport for Linux.

To start the test in KVM just do:

# ./run_tests.sh topology
for the topology ptf tests or for the topology stsi tests
# ./run_tests.sh topology-2

or something like:

# ./s390x-run s390x/topology.elf \
	-cpu max,ctop=on \
	-smp 5,sockets=4,cores=4,maxcpus=16 \
	-append '-sockets 4 -cores 4'

Of course the declaration of the number of drawers, books, socket and
core must be coherent between -smp and -append arguments.

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
 s390x/unittests.cfg |   7 +
 6 files changed, 569 insertions(+), 1 deletion(-)
 create mode 100644 s390x/topology.c

-- 
2.31.1

new in v10:

- unitests now compatible with current QEMU
  (Janosch)

- use of -cpu max instead of z14
  (Janosch, Thomas)

- colapse prefix_push and report_info
  (Nico)

new in v9:

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

