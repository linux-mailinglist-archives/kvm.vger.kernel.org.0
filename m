Return-Path: <kvm+bounces-58-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0529F7DB608
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 10:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EE59B20C9C
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 09:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BFADDA3;
	Mon, 30 Oct 2023 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KXt/3h41"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D4D8835
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:22:31 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DA1A7;
	Mon, 30 Oct 2023 02:22:30 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39U8dkl9029922;
	Mon, 30 Oct 2023 09:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=xYp5j6JaDmSLU0rCkU/L24F97cUjtLsyKSWKmOrGVtU=;
 b=KXt/3h411cAEs4SRbIqKiiJFJhOOMRrACNSp0HKRnUTlFSCtj6rJOiWm5Ab49AYwy37o
 AdcIHMaS2ynCRpRoYhFOBvjj19V+Epkhod9kNh8WwU3K+wFus/VAX9nvQPEabJ23uYYC
 D+cYCOW0zw0n9iWXHKwfQ6C/7B8m47pW/1K4jnhR+O07kyXowdLgDnIrPCJruDIRIxP5
 54UmJLnpeN0n3LbppcZ0Yo8jf6TSaDcaLPEcDqusKPMKq13kxlYytygj84t32HFycv11
 gqRdvih+Y+ZQsxFR+sXcN6HWsS6xvnqldkQET72dfVSoXl2UhiURb8/k0Fn+RYHFoGRk kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u27834mge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:30 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39U9F1vM007519;
	Mon, 30 Oct 2023 09:22:29 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u27834mfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:29 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39U8CUQH019881;
	Mon, 30 Oct 2023 09:22:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1d0y87p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39U9MP0m6488732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 09:22:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F356420043;
	Mon, 30 Oct 2023 09:22:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7254420040;
	Mon, 30 Oct 2023 09:22:24 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.67.230])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 09:22:24 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, nrb@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/2] KVM: s390: Changes for 6.7
Date: Mon, 30 Oct 2023 10:08:37 +0100
Message-ID: <20231030092101.66014-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Yty2AKsy1auTczTYScNkem57x-6afbb
X-Proofpoint-ORIG-GUID: 4ynvrgdgeHTO9blLP1Fa9b_0dPNMs8kj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_08,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxlogscore=614 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300071

Paolo, please pull these two patches for 6.7.

They introduce counters and a tracepoint into our nested VM page table
management code. Debuging nested page table management is notoriously
hard but the added low-overhead debug data will allow us to get a feel
for the problem before deploying deeper and higher overhead debugging
means.

I've held back the patches for a bit since we had suspicious CI fails
but they turned out to be unrelated and have been fixed at the end of
last week.


The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b70:

  Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.7-1

for you to fetch changes up to 70fea30195168fd84e7076720c984f0ac1af5b09:

  KVM: s390: add tracepoint in gmap notifier (2023-10-16 14:54:29 +0200)

Nico Boehr (2):
  KVM: s390: add stat counter for shadow gmap events
  KVM: s390: add tracepoint in gmap notifier

 arch/s390/include/asm/kvm_host.h |  7 +++++++
 arch/s390/kvm/gaccess.c          |  7 +++++++
 arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
 arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
 arch/s390/kvm/vsie.c             |  5 ++++-
 5 files changed, 51 insertions(+), 2 deletions(-)

-- 
2.41.0


