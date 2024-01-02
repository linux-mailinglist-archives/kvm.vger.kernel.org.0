Return-Path: <kvm+bounces-5416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E3B821CE1
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 14:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCFDC1C22167
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 13:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FDD12E7E;
	Tue,  2 Jan 2024 13:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZyoGXdtq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7329315491;
	Tue,  2 Jan 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 402CPnXo012353;
	Tue, 2 Jan 2024 13:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=hhQg8wlC3ighU+1ER2ShdOKOScZzbZYkpI2bUVYNHO0=;
 b=ZyoGXdtqyH8yyizGuiEWSBsn5SXSn7WttcOfQTKJDn8HEOEXm9D/DBMciCQLuYxDxfxs
 fQW+RyAdCHJ0o99wak5gZP0nzUWYNqucrxHlHfLGeHKZVIicgIp3paJmQK5QHEnj9rI0
 LXPlSwiyymch8VsPGKVuIbv4RCSxRbgmwwD8di5/e7c+Sh++5rPncm6c7L5UCphn5YyQ
 kUPkCpe9RXdtSAOie/jWGdOWBkkoh8Sqpe8tRlUHRoCouDdgOZl3PWP1f49QR9mb4Di4
 D+7ef5MChjui4+fgSpOjpDX1/eqwbQSJfIDH/9jS4gZhvJMKGnpfayqm+6LdNRTXWhVG xA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcf2j5q7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:39 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 402DW07C002720;
	Tue, 2 Jan 2024 13:37:39 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vcf2j5q79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:38 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 402AEI5g017830;
	Tue, 2 Jan 2024 13:37:37 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vawwyn42x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 02 Jan 2024 13:37:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 402DbYbT23396970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 2 Jan 2024 13:37:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93DD62004E;
	Tue,  2 Jan 2024 13:37:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 098442004B;
	Tue,  2 Jan 2024 13:37:34 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.18.26])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  2 Jan 2024 13:37:33 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com
Subject: [GIT PULL 0/4] KVM: s390: Changes for 6.8
Date: Tue,  2 Jan 2024 14:34:51 +0100
Message-ID: <20240102133629.108405-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2NUKVFM46rWOUGZHYQTFuut-iriExgtx
X-Proofpoint-ORIG-GUID: ojXBQDE9FCatl4QW7BCUDFv5gZeVuXrB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-02_04,2024-01-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=932 clxscore=1015 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401020104

Dear Paolo,

please pull the following changes for 6.8.

The changes are fixes/cleanups that didn't require a fix pull and
hence landed in next.

-The uvdevice didn't return a firmware return value to
 userspace. This didn't matter since that value was unused but might
 be used in the future.

-The stfle vsie code was not 100% spec compliant because it checked
 for readability of an area that was larger than the one accessed by
 firmware. Additionally there was an issue with a mask being applied
 to early.

The following changes since commit 98b1cc82c4affc16f5598d4fa14b1858671b2263:

  Linux 6.7-rc2 (2023-11-19 15:02:14 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.8-1

for you to fetch changes up to 10f7b1dcdfe05efcd26e90e337daf1bfd8f4a6da:

  KVM: s390: cpu model: Use proper define for facility mask size (2023-12-23 10:41:09 +0100)

----------------------------------------------------------------
- uvdevice fixed additional data return length (Steffen)
- stfle (feature indication) vsie fixes and minor cleanup (Nina)
----------------------------------------------------------------

Nina Schoetterl-Glausch (3):
  KVM: s390: vsie: Fix STFLE interpretive execution identification
  KVM: s390: vsie: Fix length of facility list shadowed
  KVM: s390: cpu model: Use proper define for facility mask size

Steffen Eiden (1):
  s390/uvdevice: Report additional-data length for attestation

 arch/s390/include/asm/facility.h |  6 ++++++
 arch/s390/include/asm/kvm_host.h |  2 +-
 arch/s390/kernel/Makefile        |  2 +-
 arch/s390/kernel/facility.c      | 21 +++++++++++++++++++++
 arch/s390/kvm/vsie.c             | 19 +++++++++++++++++--
 drivers/s390/char/uvdevice.c     |  3 +++
 6 files changed, 49 insertions(+), 4 deletions(-)
 create mode 100644 arch/s390/kernel/facility.c

-- 
2.43.0


