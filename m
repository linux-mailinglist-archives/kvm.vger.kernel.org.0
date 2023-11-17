Return-Path: <kvm+bounces-1962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 775427EF506
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:20:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9EE9B20B0E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E8937174;
	Fri, 17 Nov 2023 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="msU9VZ3m"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0BFD56;
	Fri, 17 Nov 2023 07:20:00 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFAw2F032727;
	Fri, 17 Nov 2023 15:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=KXauD0E8clPPZRroXgFKohZ76btumq7rs+fcoJOPbSs=;
 b=msU9VZ3meNCghnmXGiT8I7YGBqMZq1KMaSHE/32ee1Yfujo0T5lMV9DVu/zZSc0Q1z43
 cLk+hOH9VawKXrJ+yREGc9BExvNey1WZikuvOzRj2QMltTbjp57HoNa+WkjJ29tmSgB5
 /cLM/e9fMEfYdULtwfhk0gLESr1u+842rYKiDO3OpnJG1MUz6Ippw8HFoTZDdeFz/oQx
 j/BN3PfrTW7OG9SqMiAdFDqbt42f5LUbIFYuZf8hdvK+/KblljAJscIOFUou0QDSGCmw
 pJ77IZwur2+NWTOArCm1IIQarSdQaV0yO3O5YyPZ901auw1Lw/3LSS3zPDSRNZdpOmGg 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8ynk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:59 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFBHjM001731;
	Fri, 17 Nov 2023 15:19:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueaah8ykv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:58 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHD42iS005177;
	Fri, 17 Nov 2023 15:19:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uakxtf7v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:19:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFJsTi6816266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:19:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFFD12004E;
	Fri, 17 Nov 2023 15:19:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EE5520043;
	Fri, 17 Nov 2023 15:19:54 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:19:54 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/7] s390x: Add base AP support
Date: Fri, 17 Nov 2023 15:19:32 +0000
Message-Id: <20231117151939.971079-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s6KA7sZPLlEAJucOtSSuB7QDcFAHkjEo
X-Proofpoint-GUID: cTWw1TFezRx3htvK2NPTF_hnPXd8uQpb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=987 phishscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170114

As KVM supports passing Adjunct Processor (AP) crypto devices to
guests, we should make sure that the interface works as expected.

Three instructions provide the interface to the AP devices:
 - nqap: Enqueues a crypto request
 - dqap: Dequeues a crypto request
 - pqap: Provides information and processes support functions

nqap & dqap work on crypto requests for which we currently don't want
to add tests due to their sheer complexity.

Which leaves us with pqap which is partly emulated for a guest 2 and
hence is a prime target for testing.

v3:
	- Renamed ap_check() to ap_setup() and added comment

v2:
	- Re-worked the ap_check() function to test for stfle 12 since
          we rely on PQAP QCI in the library functions
	- Re-worked APQN management
	- Fixed faulty loop variable initializers in ap.c
	- Fixed report messages
	- Extended clobber lists
	- Extended length bit checks for nqap
	- Now using ARRAY_SIZE where applicabale
	- NIB is now allocated as IO memory


Janosch Frank (7):
  lib: s390x: Add ap library
  s390x: Add guest 2 AP test
  lib: s390x: ap: Add proper ap setup code
  s390x: ap: Add pqap aqic tests
  s390x: ap: Add reset tests
  lib: s390x: ap: Add tapq test facility bit
  s390x: ap: Add nq/dq len test

 lib/s390x/ap.c      | 278 ++++++++++++++++++++++
 lib/s390x/ap.h      | 119 ++++++++++
 s390x/Makefile      |   2 +
 s390x/ap.c          | 564 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 5 files changed, 966 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h
 create mode 100644 s390x/ap.c

-- 
2.34.1


