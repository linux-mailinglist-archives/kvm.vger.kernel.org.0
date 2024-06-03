Return-Path: <kvm+bounces-18622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DACD8D80A5
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDA9928160F
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEF383CCF;
	Mon,  3 Jun 2024 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iHFyeFix"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4677109;
	Mon,  3 Jun 2024 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717413262; cv=none; b=E10Om89+j6v347zHF/4SZcqcBFbqCsj3NiLXW1/3OYsDiv89tmLs/4n/pJPfVgKcTfpmPcx4Gce1hvz1y0ULmybfgEkn5E5dsFh3IEpj0W4NfHy1A/iEJ2qpNkjfTYOKI4ONm7rcYs0ohJK096YSe2uayjBB0e9MRyt/u9lvULg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717413262; c=relaxed/simple;
	bh=9hFyh/WUnI+7pP4rX+7af5V5D8jUcReiL0WrmUDvCc0=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=B0YBQJkx1zGR7AHHX8ZB7BAyBslKFXo9l/RnXJRXpFdL7NGb047t9q6rJY1kmIlX06fLMAoUvp9PaXDmxDMdxghQbyI/v9gwVF3Jt2Ms0DsQsBddH3n3gb4ApBJTa6yI2yv+tx2nQB2yfFyG2vt4K2m3+lPjRTbp73K/Lx9Yw10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iHFyeFix; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 453Alkee017594;
	Mon, 3 Jun 2024 11:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : message-id :
 mime-version : subject : to; s=pp1;
 bh=TOvba2AZcZDOh/jDmm13qSdJvQxdZhqq0H8lnx+HjkY=;
 b=iHFyeFixl3SDFJxS/YtGpz6QBlx3R1I5FUar1tsiA3c/t0gjqljsEzyL4uiZGG5AG9xL
 pGwEQq+KFf4WTE/tfJOUExcBZ04s9gWxj1PxlLHticU/ggRlN08qirewxETCujNt7Uml
 AzE2NdSqeN6qo39eC2ECiUGCfu9h5VrWE5Kbq4K/X8Teew+6BvvwFq5Jpo70hNUYUSse
 lsTbQOrssITwg+pO3ceB3vNWE2y0U1Ti1aQdQUGj6fBHdThicFsUH/pKCv0LGi3heSgC
 Dmu2lyIY1evohniWXh5U4F7S2z4PHQXR3iovz7sg7xWrlhfAjWyziI5lsE0E65RFKWlP Gg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhcctr257-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:05 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 453BBpYf029688;
	Mon, 3 Jun 2024 11:14:04 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yhcctr254-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:04 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4539GYFD031106;
	Mon, 3 Jun 2024 11:14:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeyp7f9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 11:14:03 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 453BDwjl47448372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Jun 2024 11:14:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0C622004B;
	Mon,  3 Jun 2024 11:13:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F8C420040;
	Mon,  3 Jun 2024 11:13:56 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Jun 2024 11:13:55 +0000 (GMT)
Subject: [PATCH 0/6] KVM: PPC: Book3S HV: Nested guest migration fixes
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 11:13:55 +0000
Message-ID: <171741323521.6631.11242552089199677395.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WcbVjiDJE_hXEiNrf85V175ZV6zG-BP3
X-Proofpoint-GUID: juISLmKnx293AYCfFn8reIE_oUNu7aFH
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
 definitions=2024-06-03_07,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=761 clxscore=1011 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406030094

The series fixes the issues exposed by the kvm-unit-tests[1]
sprs-migration test.

The SDAR, MMCR3 were seen to have some typo/refactoring bugs.
The first two patches fix them.

Though the nestedv2 APIs defined the guest state elements for
Power ISA 3.1B SPRs to save-restore with PHYP during entry-exit,
the DEXCR and HASHKEYR were ignored in code. The KVM_PPC_REG too
for them are missing without which the Qemu is not setting them
to their 'previous' value during guest migration at destination.
The remaining patches take care of this.

References:
[1]: https://github.com/kvm-unit-tests/kvm-unit-tests

---

Shivaprasad G Bhat (6):
      KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
      KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
      KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in sync
      KVM: PPC: Book3S HV: Add one-reg interface for DEXCR register
      KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHKEYR in sync
      KVM: PPC: Book3S HV: Add one-reg interface for HASHKEYR register


 Documentation/virt/kvm/api.rst            |  2 ++
 arch/powerpc/include/asm/kvm_host.h       |  2 ++
 arch/powerpc/include/uapi/asm/kvm.h       |  2 ++
 arch/powerpc/kvm/book3s_hv.c              | 16 ++++++++++++++--
 arch/powerpc/kvm/book3s_hv.h              |  2 ++
 arch/powerpc/kvm/book3s_hv_nestedv2.c     | 12 ++++++++++++
 tools/arch/powerpc/include/uapi/asm/kvm.h |  2 ++
 7 files changed, 36 insertions(+), 2 deletions(-)

--
Signature


