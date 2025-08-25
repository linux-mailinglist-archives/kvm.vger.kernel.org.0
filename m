Return-Path: <kvm+bounces-55626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C2CB34572
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1557480CEF
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C2B2FC001;
	Mon, 25 Aug 2025 15:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ReKPNpzY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA6A2EAB7E;
	Mon, 25 Aug 2025 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135121; cv=none; b=k+p9gny6K8QUtQRtxU+Gx2bOSTxFjAJpNZITQhsi4mPt7fMV8jNexeVvMthpuAH80oWRF06sb9DWY16A33pxF2ZA+qnJUytauGDo6Y99QTEU3czGeoo9rBuitluUpPYJ9/+7VPoLEfz8iJVAFK68LTZNTWKxoTeDO8zxk1yPl/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135121; c=relaxed/simple;
	bh=Xv1fUR7c7DrH0RCl9qk9w5ldZbgs5roIbDpYAn0dxwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AZEMFDjPSYjl9so9C0KtflxFPAg/JWY2YZaeqlDnpislPZvcO+0hzHvUSSWnGZAUd+6v0odDrS1Z5Cdu4Q9XHsCtEFKDsvrPnGeFuRbAMabRN9Z9edHbv2tix/rEI+brJn/PKvu/Lb+7vluPx1AzEMXxxTWEAYSXAHTq18RbzGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ReKPNpzY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PAjvPN007772;
	Mon, 25 Aug 2025 15:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=bl23w2yYbAM5/0gxI3EGf4H0RF7x/9Y8338nm/aXj
	A4=; b=ReKPNpzYYCzTVspjGrWtjPMIGbOC0o2GnIB+yfnJjO+bCeBdHeQEHSGne
	wlCkhCxgOJOm17Pq+xpEzQiVIEhgTz7HW0uC+fW3GimTlsnO8SJ0FMB0jngOnd/6
	laW1N+3hukIjje6R8tVOekq+0KLAwI9V6vBBE/iCcQDqflA5KiRCSJDsBu0bxwR0
	lla2Xw8LK18++HiLTHGv3dYsfSpKaoNMaDVSde5XYbX1ZB7rOrnzmcitT/JsoUGi
	wGjzeBDsqP+06QfmyElgd0oEkAax+acGHsGUxtrgaVOs33Xb4j/11xOID9kvnPGC
	DSJ4gd4HtfLjcvHtEO+QCRJXCxk1g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hpsk6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:37 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57PEMgVL029982;
	Mon, 25 Aug 2025 15:18:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qsfmecuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 15:18:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57PFIWUe48562678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 15:18:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BEB52004B;
	Mon, 25 Aug 2025 15:18:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CF2C20040;
	Mon, 25 Aug 2025 15:18:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.17.238])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Aug 2025 15:18:31 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v3 0/2] KVM: s390: Fix two bugs
Date: Mon, 25 Aug 2025 17:18:29 +0200
Message-ID: <20250825151831.78221-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX46rnXuQhXDpK
 7ILnHtI47S4ML32P10dGebA/bFc8CG/x6nJ7IUyyghNQB2a2btWGue6LDVvxBhHlPovUJ1FTlNC
 Z0PCwc2uzumJySTTmjlMFZSTv4tBMNjpC/vAtKO8gp6Q+NwsYGmzUGk+4A0t4W6nErA8+Cgm21A
 KszzfKPy94hMCSUmBY5DXfNk6k+W7rV2kqKILJX2vB2XEAZ631Usl4ENuy5Tpt61+iRyi86hSp0
 QPSaXW3vgl+6Azmc/F5PUDsgT+Isj0+LZsBx620mJIWpEx2PcbOw5hnOYRl6KTGMc3mhjtO+s9+
 I8ziOiDcyYTTyX+KKAo5AncCyzZo1pCbjrZA4w/B2x3cEcRJIwCApsVoJjc19T5MbDRK7p2HRfh
 +H7CsQIB
X-Proofpoint-ORIG-GUID: eJOxZD5UMf-DVICznofI6FY1Y5E5vohR
X-Proofpoint-GUID: eJOxZD5UMf-DVICznofI6FY1Y5E5vohR
X-Authority-Analysis: v=2.4 cv=Ndbm13D4 c=1 sm=1 tr=0 ts=68ac7ecd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=cAp4uq1tgFU3EhW9v_kA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_07,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

This small series fixes two bugs in s390 KVM. One is small and trivial,
the other is pretty bad.

* The wrong type of flag was being passed to vcpu_dat_fault_handler();
  it expects a FOLL_* flag, but a FAULT_FLAG_* was passed instead.
* Due to incorrect usage of mmu_notifier_register(), in some rare cases
  when running a secure guest, the struct mm for the userspace process
  would get freed too early and cause a use-after-free.

v2->v3
* Make sure .ops is not NULL before calling mmu_notifier_register() to
  avoid NULL pointer errors (thanks Marc)
v1->v2
* Rename the parameters of __kvm_s390_handle_dat_fault() and
  vcpu_dat_fault_handler() from flags to foll (thanks Christian)

Claudio Imbrenda (2):
  KVM: s390: Fix incorrect usage of mmu_notifier_register()
  KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 arch/s390/kvm/pv.c       | 16 +++++++++++-----
 2 files changed, 23 insertions(+), 17 deletions(-)

-- 
2.51.0


