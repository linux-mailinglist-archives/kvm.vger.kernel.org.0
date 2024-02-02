Return-Path: <kvm+bounces-7853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F51847285
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 16:05:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A1F9B246C1
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 15:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6E7145356;
	Fri,  2 Feb 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ISNWLm4g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C471441766;
	Fri,  2 Feb 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886301; cv=none; b=Bo5aTPj4Liq3XpcunTrZXGukm7P27mTjzUljUseTCRqmYnB1djSRWfeuyQOTgEd2EH237stVacWCKrmJPLeoSz4E+mEAA96wMp2TMyfWkjPjT1XkZZEGbzrf8B4GL8Y3p/wpeLVJYUZDeA9zpk24oSwtmVaVQ2URqJ8BW/+zk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886301; c=relaxed/simple;
	bh=y093+iJZDVSnjl1xsJnXxbrQ54gWh/saWt3uo+JQXJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pgwUNFHW4Mv7awV94IcGOdwp+psk5Y26tH0G6RgbyaWlLp4rQWeK+h8quupIDWix4ksqv6WrCkbxo4RQYKvg16Q7JDsb9uBA4EjrupE+4YFVWmCq/D8jqi+7+241YZQzOCYHpofCTFu2dUOqn1nxFIi2XGx9WwtKvICtGBLBMCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ISNWLm4g; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 412EStja031600;
	Fri, 2 Feb 2024 15:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vZS7t3bZjPMk1CqblnrXdYZtm1NYK7jUe9Zl4EktAa8=;
 b=ISNWLm4giMf/JLUSRQJcQ4B6AOQHnv/UvZ2wUQ/TLOx4hDQ2/GPyiZFSqIVI3I5GI8Va
 qOI/Tl8orQ5MxlhPTvEkT3kMA/KKu8+8Nv4YJGHqYx7WzqHBAd4s01ei9Z+9/ugkVnML
 Ek79z4SMu0U9eb3gdhVp9ZzyB1nf+n48iiEGK05ukeO48pg5KkyasQuLrHjNOv+Ugn1n
 opHyrNasO33EiGQcQb1fuvBqrnWaIitQy9F9EVtygb7pWG4YG7N9wHrABUl8JL5nQw7e
 6OJgSIbUdPuqWA60ELf3cXuexDJuUSafJClwHOh3yFR23AwuZOtV9pGXH50XY0C+fTJK Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:58 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 412F08Jd009332;
	Fri, 2 Feb 2024 15:04:58 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w126h8v3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:57 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 412CUd3l017797;
	Fri, 2 Feb 2024 15:04:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj0c4yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Feb 2024 15:04:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 412F4swL18678272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 Feb 2024 15:04:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2DA8E20040;
	Fri,  2 Feb 2024 15:04:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE61F2004B;
	Fri,  2 Feb 2024 15:04:53 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  2 Feb 2024 15:04:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/7] s390x: Add base AP support
Date: Fri,  2 Feb 2024 14:59:06 +0000
Message-Id: <20240202145913.34831-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BsploCpyd5D1jYxAyp4JvDJlxP1DWZNV
X-Proofpoint-ORIG-GUID: bUSBmVzEFsM8nm59biKHFbPTlcp6_hvC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-02_08,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxlogscore=851
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402020109

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

v4:
	- Rebase on the cc dirty series
	- Bumped year to 2024
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

 lib/s390x/ap.c      | 286 ++++++++++++++++++++++
 lib/s390x/ap.h      | 119 ++++++++++
 s390x/Makefile      |   2 +
 s390x/ap.c          | 564 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |   3 +
 5 files changed, 974 insertions(+)
 create mode 100644 lib/s390x/ap.c
 create mode 100644 lib/s390x/ap.h
 create mode 100644 s390x/ap.c

-- 
2.40.1


