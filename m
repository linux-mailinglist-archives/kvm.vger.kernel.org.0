Return-Path: <kvm+bounces-18636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D38FB8D819D
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E51FB22D20
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F318E86158;
	Mon,  3 Jun 2024 11:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="haRc06Ik"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4186136
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717415575; cv=none; b=KmNK1alng3ZaRH2aQ1mtP+alSV+sB9I+bof6mrzTHKgE/YtoYZbJW5HxznuKdSbX6W4N160MtwngO5VEWRTxF1RKUUUBYWGDbCrQuTcmDyzfiwbLL4X2IZXjcPFqe4Wj5zOOW3EHpOmraFyjysTqlumh2we3mHFfrl+bGCqg2Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717415575; c=relaxed/simple;
	bh=OxFfKwt/5+HHW78VNhbqlHXnuSTq3NVCzLFFlnSjGDo=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=ZqLkLTVdYaeXh9LT6AqZvubhkIDRxd7Cnjw8GO7f9KTQ1vwyjTrFjbBeu0dAZWCaZJhrQeyw8O5ujZ0BCA4B7NpMLc2fH1H3023gjlwEJG5kdJkXyS3VyuM8idgAdli/AR3yF2OekWjS7L7vFq810jdQO6ycfQaByReqjJb1GtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=haRc06Ik; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453BTIY6026484;
	Mon, 3 Jun 2024 11:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : message-id :
 mime-version : subject : to; s=pp1;
 bh=Wnp8U7NIKWaUhM9c3TbO1vWHG0cSSHKFt8MbqKwlJx8=;
 b=haRc06IkMNIi1P/WZ151UEJkGKCVa0bf69LzgfUK8FWnQqKaC3YM8JH/ponEPXE3ebyX
 rcqlyLY5Q/mT5Oxa2kn2fM1nRqJRm5JaAjXqN6l9rLOtsrqCQS4nQuF8Mu5Gfu+ZZWPE
 j3BrFJ4qtIZgBy/8y+nBGp+T3oZ46X1q2UWedThOKBkrlC/soKacETvY5uV8DWWJLJrH
 o1qQJLJKYbxBSU9TMyG99vrfAQjI+LMNW1eUQPurCAEvk7FlIqFRsWoUudkKMXosJ98m
 vDUy4JvzCajCZQbvfRTRV2fjT8mPQfOCzPFlHL7CbP16P2k7isqUtiCFfq4RCQTVFPTv gg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhcyh81wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:44 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BqhaX006568;
	Mon, 3 Jun 2024 11:52:43 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhcyh81w8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:43 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 453BC8P6026513;
	Mon, 3 Jun 2024 11:52:43 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yggp2q5r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:52:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453Bqd5p31916566
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:52:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E72A20043;
	Mon,  3 Jun 2024 11:52:39 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E55A720040;
	Mon,  3 Jun 2024 11:52:37 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:52:37 +0000 (GMT)
Subject: [PATCH 0/2] ppc: spapr: Nested kvm guest migration fixes
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org
Date: Mon, 03 Jun 2024 11:52:37 +0000
Message-ID: <171741555734.11675.17428208097186191736.stgit@c0c876608f2d>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L2qsxaO1ar0TBWirwF1QFFWePUBOHC3p
X-Proofpoint-GUID: XSm3BDUuls6AH45HNc06d8QprYaR9IrW
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=942 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 clxscore=1011 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406030099

The series fixes the issues exposed by the kvm-unit-tests[1]
sprs-migration test.

The sprs DEXCR and HASKKEYR are not registered with one-reg IDs
without which the Qemu is not setting them to their 'previous'
value during guest migreation at destination.

The two patches in the series take care of this. Also, the PPC
kvm header changes are selectively picked for the required
definitions posted here at [2].

References:
[1]: https://github.com/kvm-unit-tests/kvm-unit-tests
[2]: https://lore.kernel.org/kvm/171741323521.6631.11242552089199677395.stgit@linux.ibm.com

---

Shivaprasad G Bhat (2):
      target/ppc/cpu_init: Synchronize DEXCR with KVM for migration
      target/ppc/cpu_init: Synchronize HASHKEYR with KVM for migration


 linux-headers/asm-powerpc/kvm.h | 2 ++
 target/ppc/cpu_init.c           | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--
Signature


