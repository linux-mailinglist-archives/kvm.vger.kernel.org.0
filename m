Return-Path: <kvm+bounces-18900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8028FD09D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F8B8B2D0F9
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 13:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1066649622;
	Wed,  5 Jun 2024 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WACDZTdS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4A19408A;
	Wed,  5 Jun 2024 13:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717592787; cv=none; b=gMfRZQEdHaEOt8u3vBRADlL7XP18+Typ10vWWnq/hp75d65dwaRKVEvBUuIr2Og2yit1aRWOAeiFvanK5DeJGlPaks0fMkCkfWysU22/ILzo1BBLINKDM+Vjzev4QBn84p0GXYRLBwKdTWt2b0LXrpHQv4/5G6ZZzr1hcIb/hfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717592787; c=relaxed/simple;
	bh=jR+CbMI3Ukgr5lwIwmEEJFvYHkEZZKhx6zW6IaMlfD0=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=G2bMg3220qcak1Mref42mAcTEwN/5vJxmzt2NRMP5DW9iNn6V1/SYrs+Rlo8fPiUw1hViiOakApBJtpQJGGLlagz6/AeBqAxVRd8+ppkzMM8RC+wm/H3Ge23yIJXJpf+FWgpscLADOPkr7Lpye1jzJUItwpMiBSM42YURC6zCq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WACDZTdS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4559rSvJ022091;
	Wed, 5 Jun 2024 13:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : message-id :
 mime-version : subject : to; s=pp1;
 bh=rNaqCrZ8VkCrTSUz1srEIHGfpxPqUW/VbEDWIXQIZg0=;
 b=WACDZTdSFDX5LXI4qxLk9CM6jOrOmxvKoFCfOqINcGbdQesjJm2lw40duw0sQvJlBs0V
 U/05v80Zbl4Iy7yA37hGAof0NuPOh0NL+qWhpvq2k+1cWa9tpYFw3arY+Jusr7neahQb
 328KP9Xf+7BJPO6ZsHJgOdKSZLM+TByV4x+Lfpd7A1sPvEsWoaw5C7g/gkJCjm/MSvYs
 mi/rod3lsZ52Bd/AL93F5eLvLWIh/P2dNfRUdvqn6lsajsl/bAbM6ZKXZ0U1Ob8MTCuf
 gglu6iTvRNCmD1d8uoJRzKysYJgDPnN4OgiAU3KSEaoaR7SR/LaZ/kADh3P8JUBBgkn8 ew== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38ehm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:10 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455D69ba021172;
	Wed, 5 Jun 2024 13:06:09 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjns38ehf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:09 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4559YkrW031147;
	Wed, 5 Jun 2024 13:06:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypm7v6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 13:06:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455D63mX53150180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 13:06:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3169F2004B;
	Wed,  5 Jun 2024 13:06:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F39C2005A;
	Wed,  5 Jun 2024 13:06:01 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Jun 2024 13:06:01 +0000 (GMT)
Subject: [PATCH v2 0/8] KVM: PPC: Book3S HV: Nested guest migration fixes
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com,
        christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au,
        namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com,
        sbhat@linux.ibm.com, jniethe5@gmail.com, atrajeev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2024 13:06:00 +0000
Message-ID: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: usujUYPXPSZC1j1m1N83Obvb62lwIZV-
X-Proofpoint-ORIG-GUID: vi58BNYDMLwa3X9OeEw_8w-YXSJNnj-z
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
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 impostorscore=0 mlxlogscore=807 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050099

The series fixes the issues exposed by the kvm-unit-tests[1]
sprs-migration test.

The SDAR, MMCR3 were seen to have some typo/refactoring bugs.
The first two patches fix them.

The remaining patches take care of save-restoring the guest
state elements for DEXCR, HASHKEYR and HASHPKEYR SPRs with PHYP
during entry-exit. The KVM_PPC_REG too for them are missing which
are added for use by the QEMU.

References:
[1]: https://github.com/kvm-unit-tests/kvm-unit-tests

---

Changelog:
v1: https://lore.kernel.org/kvm/171741555734.11675.17428208097186191736.stgit@c0c876608f2d/
 - Reordered the patches in a way to introduce the SPRs first as
   suggested.
 - Added Reviewed-bys to the reviewed ones.
 - Added 2 more patches to handle the hashpkeyr state

Shivaprasad G Bhat (8):
      KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
      KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
      KVM: PPC: Book3S HV: Add one-reg interface for DEXCR register
      KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in sync
      KVM: PPC: Book3S HV: Add one-reg interface for HASHKEYR register
      KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHKEYR in sync
      KVM: PPC: Book3S HV: Add one-reg interface for HASHPKEYR register
      KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHPKEYR in sync


 Documentation/virt/kvm/api.rst        |  3 +++
 arch/powerpc/include/asm/kvm_host.h   |  3 +++
 arch/powerpc/include/uapi/asm/kvm.h   |  3 +++
 arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++++++++++++++--
 arch/powerpc/kvm/book3s_hv.h          |  3 +++
 arch/powerpc/kvm/book3s_hv_nestedv2.c | 18 ++++++++++++++++++
 6 files changed, 50 insertions(+), 2 deletions(-)

--
Signature


