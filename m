Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5413D99D
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgAPMFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 07:05:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbgAPMFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 07:05:35 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GBvfHT023764
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:34 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xfaw2cp9j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 07:05:32 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 12:05:28 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 12:05:24 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GC5N2544761290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 12:05:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC6815205A;
        Thu, 16 Jan 2020 12:05:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C2E0952052;
        Thu, 16 Jan 2020 12:05:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/7] s390x: smp: Improve smp code and reset checks
Date:   Thu, 16 Jan 2020 07:05:06 -0500
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20011612-4275-0000-0000-0000039813C6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011612-4276-0000-0000-000038AC129A
Message-Id: <20200116120513.2244-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_03:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 mlxlogscore=465 bulkscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's extend sigp reset testing and clean up the smp library as well.

GIT: https://github.com/frankjaa/kvm-unit-tests/tree/smp_cleanup

v2:
	* Added cpu stop to test_store_status()
	* Added smp_cpu_destroy() to the end of smp.c main()
	* New patch that prints cpu id on interrupt errors
	* New patch that reworks cpu start in the smp library (needed for lpar)
	* New patch that waits for cpu setup in smp_cpu_setup() (needed for lpar)
	* nullp is now an array

Janosch Frank (7):
  s390x: smp: Cleanup smp.c
  s390x: smp: Only use smp_cpu_setup once
  s390x: Add cpu id to interrupt error prints
  s390x: smp: Rework cpu start and active tracking
  s390x: smp: Wait for cpu setup to finish
  s390x: smp: Test all CRs on initial reset
  s390x: smp: Dirty fpc before initial reset test

 lib/s390x/interrupt.c | 20 +++++------
 lib/s390x/smp.c       | 47 +++++++++++++-----------
 s390x/cstart64.S      |  2 ++
 s390x/smp.c           | 84 +++++++++++++++++++++++++++++--------------
 4 files changed, 96 insertions(+), 57 deletions(-)

-- 
2.20.1

