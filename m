Return-Path: <kvm+bounces-25413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C64589652D4
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D958B2333C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 22:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6E81BBBD4;
	Thu, 29 Aug 2024 22:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="C1AwnNLY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD121BAEDE;
	Thu, 29 Aug 2024 22:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970277; cv=none; b=MQG4gDxlsJHViQMWO2SjnkznIXUCo8BrAx7x4ytF86axJNvqTYvEAJpkOftpm/PDRal2nNl1NRpaT87iNCWzyitVeOKh0qE0m1e96qyaWMPYMWTCPhJbF/JcuUppJ9CkmILmWzqMAbRmrXdvUM5ybtQw+yuSQfpULO8LTZKM5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970277; c=relaxed/simple;
	bh=Y/VGX0u7JSsRBTCC3cXYvYlXH0MeuOZ4hyXlo5DJ76s=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=W5OVXCUvdD6KTQNS69K7F78/theIm4QXlsdMDadwEpIP2W/GdIDVBxF3Ul2f0UQbj3Y0HSCTQZ/7/H0AwvTPuYswtG+tHzyWBdBl7BsX3SkXJkEc0tJOWrE1FzyvrHyD7dSsjEFBKI3AwONXaCJl2G3L5JlxAdnLE617zDzK0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=C1AwnNLY; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47THchVs027493;
	Thu, 29 Aug 2024 22:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=7iq3GRLIa6xNJ+/ns9duml
	S8c3TCTwTI8XA/iSqTdxI=; b=C1AwnNLYfH58zBji0xxrjpQbVJ3DjOL3CCE86W
	QiR4/7I0yKP1GtADipPXrEhymUw+tzqmB4etl03sQwV6N4mj4iCFaEtkN0Cb9UKv
	T+7pHMdV1QKm0tCIFW7TpaJna5+ZhWp2Oqk/sWXok09clMFnCtQrY+9pjV0LKAkT
	8b9RY2s40QB1Qafa6PKjlGxERZ7Ow/Qh7/0NcBMplBiYVC9WZz/ls2mDL6d0sVnn
	winJjfGnWUfDB96FArxNxi0XrJxe358GVrvFaeNoIaMacOFallIsq7vlV05gCmPF
	vY6ypd4V7E0hZ19eP5tZxIOcLFdNvg1ecEkBD5VMI/q1Yyog==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 419puvesnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:12 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47TMOBHN014608
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Aug 2024 22:24:11 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 15:24:10 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Subject: [PATCH RFC v2 0/5] mm: Introduce guest_memfd library
Date: Thu, 29 Aug 2024 15:24:08 -0700
Message-ID: <20240829-guest-memfd-lib-v2-0-b9afc1ff3656@quicinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAj10GYC/2WNwQrCMBBEf6Xs2UiyJFY9FQQ/wKv0UJNNu2BbT
 dqilP67IVePb4Z5s0KkwBThXKwQaOHI45AAdwXYrhlaEuwSA0rUskQU7UxxEj313oknP4Q2xqN
 Wyjh9gLR6BfL8ycY73K4XqFPYcZzG8M0vi8pVFh6l+RMuSkhBpsFTo703rqzeM1se7N6OPdTbt
 v0A3eI4lrUAAAA=
To: Andrew Morton <akpm@linux-foundation.org>,
        Sean Christopherson
	<seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov
	<bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>,
        Mike Rapoport <rppt@kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-arm-msm@vger.kernel.org>,
        Elliot Berman <quic_eberman@quicinc.com>
X-Mailer: b4 0.14.1
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: _yYbQidiBAnKOeD_gPtq4BTytlypn2jq
X-Proofpoint-GUID: _yYbQidiBAnKOeD_gPtq4BTytlypn2jq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-29_06,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=797 priorityscore=1501 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408290158

In preparation for adding more features to KVM's guest_memfd, refactor
and introduce a library which abstracts some of the core-mm decisions
about managing folios associated with the file. The goal of the refactor
serves two purposes:

1. Provide an easier way to reason about memory in guest_memfd. With KVM
supporting multiple confidentiality models (TDX, SEV-SNP, pKVM, ARM
CCA), and coming support for allowing kernel and userspace to access
this memory, it seems necessary to create a stronger abstraction between
core-mm concerns and hypervisor concerns.

2. Provide a common implementation for other hypervisors (Gunyah) to use.

To create a guest_memfd, the owner provides operations to attempt to
unmap the folio and check whether a folio is accessible to the host. The
owner can call guest_memfd_make_inaccessible() to ensure Linux doesn't
have the folio mapped.

The series first introduces a guest_memfd library based on the current
KVM (next) implementation, then adds few features needed for Gunyah and
arm64 pKVM. The Gunyah usage of the series will be posted separately
shortly after sending this series. I'll work with Fuad on using the
guest_memfd library for arm64 pKVM based on the feedback received.

There are a few TODOs still pending. 
- The KVM patch isn't tested. I don't have access a SEV-SNP setup to be
  able to test.
- I've not yet investigated deeply whether having the guest_memfd
  library helps live migration. I'd appreciate any input on that part.
- We should consider consolidating the adjust_direct_map() in
  arch/x86/virt/svm/sev.c so guest_memfd can take care of it.
- There's a race possibility where the folio ref count is incremented
  and about to also increment the safe counter, but waiting for the
  folio lock to be released. The owner of folio_lock will see mismatched
  counter values and not be able to convert to (in)accessible, even
  though it should be okay to do so.
 
I'd appreciate any feedback, especially on the direction I'm taking for
tracking the (in)accessible state.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>

Changes in v2:
- Significantly reworked to introduce "accessible" and "safe" reference
  counters
- Link to v1:
  https://lore.kernel.org/r/20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com

---
Elliot Berman (5):
      mm: Introduce guest_memfd
      mm: guest_memfd: Allow folios to be accessible to host
      kvm: Convert to use guest_memfd library
      mm: guest_memfd: Add ability for userspace to mmap pages
      mm: guest_memfd: Add option to remove inaccessible memory from direct map

 arch/x86/kvm/svm/sev.c      |   3 +-
 include/linux/guest_memfd.h |  49 ++++
 mm/Kconfig                  |   3 +
 mm/Makefile                 |   1 +
 mm/guest_memfd.c            | 667 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/Kconfig            |   1 +
 virt/kvm/guest_memfd.c      | 371 +++++-------------------
 virt/kvm/kvm_main.c         |   2 -
 virt/kvm/kvm_mm.h           |   6 -
 9 files changed, 797 insertions(+), 306 deletions(-)
---
base-commit: 5be63fc19fcaa4c236b307420483578a56986a37
change-id: 20240722-guest-memfd-lib-455f24115d46

Best regards,
-- 
Elliot Berman <quic_eberman@quicinc.com>


