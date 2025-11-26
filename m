Return-Path: <kvm+bounces-64605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 69222C8829A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C03223516DE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:34:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0853A314D1B;
	Wed, 26 Nov 2025 05:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nf2M7moR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CB74C9D;
	Wed, 26 Nov 2025 05:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764135233; cv=none; b=a4ll+vFF9r1B/a+gZk3SZatuja8v0zFLPLP9+TaaPakLZeCYMaaRuGKrGRhDvH+PNdIZwkI9iY1KNjcL5WawuURybcTfhhVDN3jKGjZJkJNXEH3CBdtYuEXWkEcofJsLZoC1APEddBZZeOFAHWj+61eW8l9VNpUNniC2Kdk6rf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764135233; c=relaxed/simple;
	bh=/bQY4JxjE3ovZu4vHbWaRRcB1GnDomvnpTH3IqUkf1Q=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=osmE5Hx55//Z/JmHQ1O7K2ktZ9oPf7CjgDHy5g2Wz6CyopCVLcza1OETq0rmn9G4TYaCsRq2R26EsnlvHP2FpAvb3RXcJZu0xyzwTbaJautZ4Qu8/6hUIG/K/gTBNkLCoSozWWXPn35C8pQM664XGO36EoRut5BR9jq1gn8wxGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Nf2M7moR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5APK7hnX021895;
	Wed, 26 Nov 2025 05:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=Gu2gily6vcH8nxownTzSqSEjA3+Z
	C6TaZ7RNEM0Vww4=; b=Nf2M7moRY1Xn0lh/QftxsMR/KhvNGnn5Os4aOvNYERFb
	pTi44cx3AWsCZCkIw1vRqEKdLq6/Kwhfy2yQo6BHsJJ8SGKAHyDWFDWZpp1SSTTP
	m/GZ4v1DgiqKoKohi1UArMN7Iza67mNDrKg6w+c+BZfwdWsgA8xeU+/53xmjxzuy
	XJWwz6RhML5TNNPLye3X1e/ShAZU/H+ZfnlghCh8XvTHzI26koU9fg5xtI4oXWsq
	I6RzsihG5dGf/YfNSw9XgEsD8ZjMzql0m94zoX1p++eD1hJCkqF96VCitAWy1r5b
	e4GZwz67AS8a7bWTFeS4Cle+fZnBEApr3jxT+cRcwg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak3kk14j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQ3LU5T025083;
	Wed, 26 Nov 2025 05:33:39 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt71fy9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 05:33:39 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AQ5XcZI48824732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 05:33:38 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B84A58056;
	Wed, 26 Nov 2025 05:33:38 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E855058052;
	Wed, 26 Nov 2025 05:33:33 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.90.171.232])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Nov 2025 05:33:33 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH v2 0/3] KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK
 entry helpers
Date: Wed, 26 Nov 2025 16:33:09 +1100
Message-Id: <20251126-s390-kvm-xfer-to-guest-work-v2-0-1b8767879235@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NsQ6CMBSF4Vchnb2kt6VEnHwP41DwAg1CTQsVQ
 3h3C5Nx0fE/w3cW5skZ8uyULMxRMN7YIYY4JKxq9dAQmFtsJrhQiFyBlwWHLvQw1+RgtNBM5Ed
 4WteBJF3qvOKkecai8HBUm3nXL9fYrfGjda/9LMht/c8NEjiUebSl4qWW6nw3wzSnpuzTyvZss
 wN+eOKHh9HjBYojapnliN/euq5vxx6HnxoBAAA=
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
X-Proofpoint-GUID: RwYL8bja8nrCF3-26EEzmlOuqQCIIOtC
X-Authority-Analysis: v=2.4 cv=frbRpV4f c=1 sm=1 tr=0 ts=69269134 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=dCP-iVU0ufJp51HjtDEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RwYL8bja8nrCF3-26EEzmlOuqQCIIOtC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwOCBTYWx0ZWRfX8NzNvy5nNKcB
 jlimIJD+jPxdwgyrmAN432pWhkfJDFi5kuYTdMnBGylamvyGmczC4tuds5EFeGFVBgj70M0R+L4
 MSag+Jjo0iAsb7bCVcb69IglRZEXkgKF6wSJ0h6rT3hoPqQvtRClteZi7CrDdYuod441h6diTX9
 NWJvPs8LFtcLgY2C+kjgd1RLd3bDXlJhpnrGGjmQdFJiGxplQCBBCic2E2N7WzDITrJlcZjh13R
 oRvGBL9jl1hZdIeDPXyVpsKoaOBoDl4lZ6rSpT0fcUBVHtAamaqRltmvOB9U77kXSPJsh/Gqmdm
 144rLfmUVp/2IbgNgAdgehe/fMPgMIirxqoXvy9c4KXDt366vbt5DggSmsX1HemARCkLk7vxWQX
 yGnXMK/caAFyQaW4tNSvRq36NVsriA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220008

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
Changes in v2:
- if work is handled, recheck for outstanding work with interrupts
  disabled before entering guest (Heiko)
- Link to v1: https://lore.kernel.org/r/20251125-s390-kvm-xfer-to-guest-work-v1-0-091281a34611@linux.ibm.com

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
 arch/s390/kvm/vsie.c               | 18 +++++++++++++-----
 7 files changed, 40 insertions(+), 18 deletions(-)
---
base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
change-id: 20251105-s390-kvm-xfer-to-guest-work-3eaba6c0ea04


--
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited


