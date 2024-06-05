Return-Path: <kvm+bounces-18922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2579D8FD22C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 17:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F66A1C2376D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 15:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CA81494BD;
	Wed,  5 Jun 2024 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tr/ap1GQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B327701
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603063; cv=none; b=p9VJA8JKYm4Qg3yj5Vr9UJTtnWyXkDKwZK6zJ01edz/Dq+raLGMXjSc9rRF1jHc22Z0EXYt+ga06dU+FSyfUYoqIc1SfzjoA8k1REAnjczxfIW+OQ9rjUQ70bFUeHPJhSH8tfpraSPjKtbDZYzBHakCIqYpkOYPFlynBumKUMwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603063; c=relaxed/simple;
	bh=C8pLGnC6QpHETz6QX+ubBlwlub9nbW8r1dxJb6w3nyY=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=kJNbHSTh3D4/aPWMFb9h5kdLlDRcdY5GeZbfiLfj/v660DwAjzJ6Mdx+DYI612+dyi42T+pZotcBmwiFJvbLep3Ksuijj6ILKTX2cnWLkicWiChxPsJwNsuPY4+az5gk4/ZascR0dBWgazBZIZUfuU2VfUB3cz7IfXQ+hOGjzPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tr/ap1GQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455FqICS001883;
	Wed, 5 Jun 2024 15:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : message-id :
 mime-version : subject : to; s=pp1;
 bh=eQzecx9tK5kngUBNovzpWPyLbSmWodqoOv5mm6wvIhQ=;
 b=Tr/ap1GQyHhKmkOXvxuPdwyK/CUiq4pfFttBdMPm58AvC1fuh78yu3Fgb1dqPL8WFSTI
 8myafBkEddaoCPwGqIjlkL0l+Uf0Srv0scbvVl+SUw2CX+2VNWgBWwOmRjAoVtP1Ps/c
 4/2lcO2PFfdQu8YqXZhqMc3b1SEJ4grOICE+Q7qsDQcoZlOwGBTuibViX1sMn9s/nyls
 WNkgrX1GuXTz+pO+Xz/VcMdPY446ywDXQ/HhWbjIbOsn+H27ls55u69ovihdwmldcgcI
 ZekzFOaTXVo2msAyKaNjvYMlK7XfR0TvmJHks37Vw43hgv9SdLpWhAe2WMCh5GZuFPid Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yju1j8121-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:57:35 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455FvYiR011021;
	Wed, 5 Jun 2024 15:57:35 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yju1j811s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:57:34 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455DQLLt026624;
	Wed, 5 Jun 2024 15:57:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn4wtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 15:57:33 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455FvR9B53936434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 15:57:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BC3A20040;
	Wed,  5 Jun 2024 15:57:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00F7D2004B;
	Wed,  5 Jun 2024 15:57:26 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 15:57:25 +0000 (GMT)
Subject: [PATCH v2 0/4] ppc: spapr: Nested kvm guest migration fixes
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: cohuck@redhat.com, pbonzini@redhat.com, npiggin@gmail.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: mst@redhat.com, danielhb413@gmail.com, qemu-ppc@nongnu.org,
        sbhat@linux.ibm.com, harshpb@linux.ibm.com, vaibhav@linux.ibm.com
Date: Wed, 05 Jun 2024 15:57:25 +0000
Message-ID: <171760304518.1127.12881297254648658843.stgit@ad1b393f0e09>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8N4GLVwxOJIfayiWieQxcQBWzbYaya57
X-Proofpoint-ORIG-GUID: 5NcF4-0GSJgsB-xV8wEE_OPbqRzjU5Nk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_02,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=989
 suspectscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050121

The series fixes the issues exposed by the kvm-unit-tests[1]
sprs-migration test.

The sprs DEXCR, HASKKEYR and HASHPKEYR are not registered with
one-reg IDs without which the Qemu is not setting them to their
'previous' value before vcpu run or migration at destination.

The first patch updates the linux header with the IDs[2] for
current use till a complete update post kernel release. The
remaining three patches in the series take care registering
them with KVM.

References:
[1]: https://github.com/kvm-unit-tests/kvm-unit-tests
[2]: https://lore.kernel.org/kvm/171759276071.1480.9356137231993600304.stgit@linux.ibm.com

---
Changelog:

v1: https://lore.kernel.org/qemu-devel/171741555734.11675.17428208097186191736.stgit@c0c876608f2d/
- Moved the linux header changes to a separate patch adding
  definitions for all the required one-reg ids together.
- Added one-reg ID for HASHPKEYR as suggested

Shivaprasad G Bhat (4):
      linux-header: PPC: KVM: Update one-reg ids for DEXCR, HASHKEYR and HASHPKEYR
      target/ppc/cpu_init: Synchronize DEXCR with KVM for migration
      target/ppc/cpu_init: Synchronize HASHKEYR with KVM for migration
      target/ppc/cpu_init: Synchronize HASHPKEYR with KVM for migration


 linux-headers/asm-powerpc/kvm.h |  3 +++
 target/ppc/cpu_init.c           | 12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

--
Signature


