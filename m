Return-Path: <kvm+bounces-64471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 695A5C83C61
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 08:47:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 380F24E132A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB442D781E;
	Tue, 25 Nov 2025 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cKuqK7fo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9796513AD05;
	Tue, 25 Nov 2025 07:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764056803; cv=none; b=JrPZjP6BhmxLtH9piHhUunNHzKMmnfq08ZXp0aq3kthXkfObUW2S1fMcjJsqzJc7h+LSMwecT0vQ6c9nCth9abGFanHgTeuCl9vCHYFqTCycgT0yRzcg7UJH750WpCXAE0A10RuJMvjrZk9BpUj23p50J0LlYcbW+zIUr+6/k8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764056803; c=relaxed/simple;
	bh=X+G6fC5TETvAhRnUaOk91Qn1cUQLKE+NtomTvfGtCEk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=MkBZt6emblB+20XWXizqisAGC/vIe6E35iYNnHjhkR8paXMBccS3qop04Sv47c3dLU6af4lwuwv1uTksP+6dDmNyY7iHc5IV2xTnPaQ1dBTyTRWgAYoaKdFjdb0oy676EeR8pFNbIhGNXBMXF3i+tVDESEJB+ubbRpGQOsistXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cKuqK7fo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOIefhT025267;
	Tue, 25 Nov 2025 07:46:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=vWBVMD+lm25y/eT1xtjvXX7GJaMX
	+X5iyD2GkYqthUA=; b=cKuqK7foaPZuk9YP6FW4d6t4IL14CgpOPN4r0jDMChZC
	Jt4bW4yK9TGKOX7RG9DP/D+7N0xd+uwtFJ+P0gZ3Jo6Yw49Hd1st/e+zoiLe++wd
	NP+4e87ZeIKj08ldoahOEGq01bOlcCaFNMS+yCc5UCHFnPpsO8lrO7NE6czYB8ri
	BDqBg/TgzYFVZ2oyhwDlA+NrEwIF5r/JAR/APReGg6CzSKpNd+p3miCa2zlcH/tQ
	7r67TExam+dv+/trKXhvZIJJnHNU0hCNPbanq1K79+DDapQAkdmZteL2kArCYlw5
	nqVNdSrUa8AIm6kV96X8NskQ9pPppH0bMjEZPdG9MA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phv4c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AP7VoWn025083;
	Tue, 25 Nov 2025 07:46:10 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt71a2gk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 07:46:10 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AP7k8Ak20513364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Nov 2025 07:46:08 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D05E5805A;
	Tue, 25 Nov 2025 07:46:08 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA35358063;
	Tue, 25 Nov 2025 07:46:00 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.150.29.34])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Nov 2025 07:46:00 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 0/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK entry
 helpers
Date: Tue, 25 Nov 2025 18:45:51 +1100
Message-Id: <20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NQQ6CMBCF4auQWTtkoJZEV97DsGhxgAlCTQsVQ
 7i7lRO4/N/iexsE9sIBrtkGnqMEcVOK4pRB05upY5RHaiip1EVBGoO6EA5xxLVlj7PDbuEw49v
 5ARUba6qG2NAZkvDy3Mp66Pc6dS9hdv5znEX1W/9zo0JCWyVbabJG6dtTpmXNxY5540ao933/A
 qGdlSLKAAAA
X-Change-ID: 20251105-s390-kvm-xfer-to-guest-work-3eaba6c0ea04
To: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@kernel.org>
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfXxevYOlLtTXqJ
 SdLDlGBfAaagGEiUidC1Uwc/JaiPTFmVopDQxt50idorqUA/c+picF7cBybVebjnIfta2h1Bj+B
 o8cuxebcjOzm/rnUAESXCMeMq+vUHVIzgvkZNvxISHOF8Kk+nk9xejwdjVIvev6qfcBsLRl/p5T
 MZDnK25z7Q0r2H6pTAlfAOiJ/hxGf59TpNyjp2isa+RhK1cnJ/wSwcAP2cw207Br8NzdeuXx6UE
 I8RCOpzi5W470odH52ocDk/LTTsXoHKLeKtjaTWEaYiLN/5wZt1FBc1DI9rws5xbxIb5xUDhA/B
 hHP2RyKNnkGDWyxjV1zU/w+iBMsDMNESPde5H2vrSVczb/0Kpv5UPQQWxpz80BoWHBY2Pj0T1VU
 2s7QxTaEKdZJJnigcjucZxAukm2iFw==
X-Proofpoint-ORIG-GUID: q4zwcqKZVcSnn2GNyF9G2CmUhNQgzSNf
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=69255ec3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=UG5J8lQA30gTZpC9Yu0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: q4zwcqKZVcSnn2GNyF9G2CmUhNQgzSNf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1011 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016

This series enables VIRT_XFER_TO_GUEST_WORK on s390.

This requires:

  1) adding a signal_exits stats counter, which is used by
     kvm_handle_signal_exit()
  2) moving the point where interrupts are enabled and disabled in the
     guest entry path, so that interrupts aren't enabled until after the
     __TI_sie flag is set
  3) enabling VIRT_XFER_TO_GUEST_WORK and adding the appropriate calls to
     check for and handle outstanding work in __vcpu_run() and the VSIE
     path.

With this series applied, the kvm-unit-tests suite passes on both the host
and an L1 guest with nested KVM enabled, and benchmarks done using the
exittime tests from kvm-unit-tests show that the impact on entry path
performance is generally small enough to be noise (in my tests, around
+/-3%, running directly in an LPAR and in a L1 KVM guest).

Thanks to Heiko for feedback and guidance on this.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
Andrew Donnellan (2):
      KVM: s390: Add signal_exits counter
      KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions

Heiko Carstens (1):
      KVM: s390: Enable and disable interrupts in entry code

 arch/s390/include/asm/kvm_host.h   |  1 +
 arch/s390/include/asm/stacktrace.h |  1 +
 arch/s390/kernel/asm-offsets.c     |  1 +
 arch/s390/kernel/entry.S           |  2 ++
 arch/s390/kvm/Kconfig              |  1 +
 arch/s390/kvm/kvm-s390.c           | 34 +++++++++++++++++++++-------------
 arch/s390/kvm/vsie.c               | 17 ++++++++++++-----
 7 files changed, 39 insertions(+), 18 deletions(-)
---
base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
change-id: 20251105-s390-kvm-xfer-to-guest-work-3eaba6c0ea04


--
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited


