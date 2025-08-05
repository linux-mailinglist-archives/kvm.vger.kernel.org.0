Return-Path: <kvm+bounces-54013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A31CB1B62D
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DFA37AD3F5
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17A5276056;
	Tue,  5 Aug 2025 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RuLX46+B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E65274B22;
	Tue,  5 Aug 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403475; cv=none; b=VgVwInyIrCUP9dA7wGAF2plA/iEdR8k+f9+v5cnHIcFoBi4m42h2tWWziw9S0XHaS64IKbqsfa7BMW6FZUezqAND4Ee8gx2uOsOrzkz+8OShbPfQWggGZC7f7/fxcSAP+gHPylbYaKwPwx7Fj4Hzf3dXjaWpyyTxB8KQaUR1fhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403475; c=relaxed/simple;
	bh=wC5WUGRqq7V8dY40pHwWpcG1qpmyossIkqsDP7cHAeI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HRxQdbqeg0L3XZDnXrg7YF7EvEkfXYmP+2In/ZwWCguoplVK1WIDjH8w/d8BiJltbmNHvBtr7wBsrSMc0/qhzcrEvVF1jhWHbofics5AIXTfynjypQdI4FIdQQ8WWPe5EJNoF7xxQuC0B+tdwFMNajNNxrwd8LUAt1zR8+JIGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RuLX46+B; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5754U0A7012306;
	Tue, 5 Aug 2025 14:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=GtO/jIo5S152YwOSiAWXn02tVKzTJVSsMQbAx4m1t
	nw=; b=RuLX46+BNEof/3h5q7q64LdIVxc6zqJ8waugPPDwu9PV0X6gzj615JQ6w
	gjwXKS4xq5uQzakbIP8u+LkIqsjc/t1iUB6otKl+36J9zYzYAu3LoRQgyuyIy6Dl
	aJ91NA/Xi9kdHFBMVpw/tS/340L7H/WBQtLwBgIFkDEulJij9W9IGOJfVAXhEO7o
	2H9QOLI2foIE1wDhWP59QoA7pDDPkVCqnPnHP+r/MXfhg8iLUHC1b1Wyx2KFujQS
	MTVPF/XRmRliOdjpXSW43OZt0i7PJHhNpGxyytwdt/nyTKxI8hxYrtthXa/hXDdS
	MOaF8wdRETyJ50Mk1Dp7mQfp0xkcw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 489ab3pwjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 575CjeNp009442;
	Tue, 5 Aug 2025 14:17:50 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 489w0tjwa5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 14:17:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575EHkgR52888044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 14:17:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D407E2004E;
	Tue,  5 Aug 2025 14:17:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99CEE2004F;
	Tue,  5 Aug 2025 14:17:46 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Aug 2025 14:17:46 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, schlameuss@linux.ibm.com, hca@linux.ibm.com,
        mhartmay@linux.ibm.com, borntraeger@de.ibm.com
Subject: [PATCH v2 0/2] KVM: s390: Fix two bugs
Date: Tue,  5 Aug 2025 16:17:44 +0200
Message-ID: <20250805141746.71267-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z+jsHGRA c=1 sm=1 tr=0 ts=6892128f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=cAp4uq1tgFU3EhW9v_kA:9
X-Proofpoint-ORIG-GUID: 8EvSJF1wfV8PuQzOGO5mpUiZGZufn8p7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDEwMSBTYWx0ZWRfX0ba7HN+NkPyl
 Em8CiiqqajPRdt7IyhKVTBowmXzVvVvk3xo4nFmRHe1D8P4HR7lUGQKHL8ZZLMBF34NWYGnTsIl
 gxBmaZE/ymnLmbHTqxcFXieA944lf5LuqTX8vVodJTjJ+tyro/eWZSb9gURHMy1L9A4QhKh9sGk
 XE4x6gX7ueo6tWyIga8ICsvELwW119Xv12eHTW20X7RhawwgojJ8x+AWyg96/syY3FBZnEokQu3
 H83ZmakCeC3ELKP4ZFdVXV+ORvjNBWqndhfiqeLKW5ylg9he9PLNuwW9w6ZCXTNTbS4fHx/DDIF
 xFuUrAVOMVNuYWGPbDrh0GfvSQt4Mbp0x91TKzzb+6epsHLv41nQvr/lnsOXwoCNG6FOOJCadzv
 7oxbGHluza/COhwaFpaSUFf87IFrDs0x4nUiB2O/EVZ3iH6kV/dC4YTFiGY09cglzdwefL2q
X-Proofpoint-GUID: 8EvSJF1wfV8PuQzOGO5mpUiZGZufn8p7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 mlxlogscore=686 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050101

This small series fixes two bugs in s390 KVM. One is small and trivial,
the other is pretty bad.

* The wrong type of flag was being passed to vcpu_dat_fault_handler();
  it expects a FOLL_* flag, but a FAULT_FLAG_* was passed instead.
* Due to incorrect usage of mmu_notifier_register(), in some rare cases
  when running a secure guest, the struct mm for the userspace process
  would get freed too early and cause a use-after-free.

v1->v2
* Rename the parameters of __kvm_s390_handle_dat_fault() and
  vcpu_dat_fault_handler() from flags to foll (thanks Christian)

Claudio Imbrenda (2):
  KVM: s390: Fix incorrect usage of mmu_notifier_register()
  KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 arch/s390/kvm/pv.c       | 14 +++++++++-----
 2 files changed, 21 insertions(+), 17 deletions(-)

-- 
2.50.1


