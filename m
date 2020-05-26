Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE61BE130
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgD2Ofc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:35:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgD2Ofb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 10:35:31 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TEWDYR047130;
        Wed, 29 Apr 2020 10:35:31 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me46av8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:30 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03TEXKSk051293;
        Wed, 29 Apr 2020 10:35:30 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me46av72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 10:35:30 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03TEUZp5019028;
        Wed, 29 Apr 2020 14:35:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu70n48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 14:35:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03TEZPCX7733510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 14:35:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4708F4C040;
        Wed, 29 Apr 2020 14:35:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94ED54C044;
        Wed, 29 Apr 2020 14:35:24 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 14:35:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com
Subject: [PATCH v3 00/10] s390x: smp: Improve smp code part 2
Date:   Wed, 29 Apr 2020 10:35:08 -0400
Message-Id: <20200429143518.1360468-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_05:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxlogscore=760 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's continue cleaning up the smp test and smp related functions.

We add:
   * Test for external/emergency calls after reset
   * Test SIGP restart while running
   * SIGP stop and store status while running
   * CR testing on reset

We fix:
   * Proper check for sigp completion
   * smp_cpu_setup_state() loop and return address in r14

v3:
	* Added some rev-bys and acks
	* Add a workaround for stop and store status
	* Beautified cr checking with loop

v2:
	* Added some rev-bys and acks
	* Explicitly stop and start cpu before hot restart test

GIT: https://github.com/frankjaa/kvm-unit-tests/tree/smp_cleanup2

Janosch Frank (10):
  s390x: smp: Test all CRs on initial reset
  s390x: smp: Dirty fpc before initial reset test
  s390x: smp: Test stop and store status on a running and stopped cpu
  s390x: smp: Test local interrupts after cpu reset
  s390x: smp: Loop if secondary cpu returns into cpu setup again
  s390x: smp: Remove unneeded cpu loops
  s390x: smp: Use full PSW to bringup new cpu
  s390x: smp: Wait for sigp completion
  s390x: smp: Add restart when running test
  s390x: Fix library constant definitions

 lib/s390x/asm/arch_def.h |   8 ++--
 lib/s390x/smp.c          |  11 +++++
 lib/s390x/smp.h          |   1 +
 s390x/cstart64.S         |   5 +-
 s390x/smp.c              | 101 +++++++++++++++++++++++++++++++++++----
 5 files changed, 112 insertions(+), 14 deletions(-)

-- 
2.25.1

