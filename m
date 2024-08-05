Return-Path: <kvm+bounces-23254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1BC19481C2
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 20:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F38C1C21E20
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 18:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B99C16BE04;
	Mon,  5 Aug 2024 18:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="LRkRIKQx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCBC166F36;
	Mon,  5 Aug 2024 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882943; cv=none; b=GDN11WUKekfkjRxcgHft/WKbRUGoh3x/UYp9aWrpR+fdOweS9ndrYOTMpXTDlJqK7qAJwr0CKTn2mQv+eH1lHV6NMjPRzXSLr6sZ/GhjHZ515IbZwc6Ea+UExNFuRH4Fg9s1yrhwuo2H8yJT6w32ic2DngI6aMIm5xAj8+Wj2i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882943; c=relaxed/simple;
	bh=B0WaNJ1Pc9zmW8PoMmlFcBTTnW7jQjlmKXCZIRSU9D0=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=Zf+N8w4OeSQWzl3sG7QuoIQdkvH//FUNZoCer5DYYJZDGRwzsbSn3ihEHwdOyZzkkZ4N3iCZXqnaSe2JDVQanaMYV+qmj2/pJ7VhmuagaAFl1Uq2TsvUhe5R2sRT5i4Z69rnoPLfAKYJLBtaRxJCgvzxnXQxmFurqE13LUvQy7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=LRkRIKQx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475BBeYv021385;
	Mon, 5 Aug 2024 18:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=r1Jd5ecBU1I1wroHu3btrY
	E6ziJSo4C5naGxUPxOtXY=; b=LRkRIKQxkuxOp5y88KdgvjnEmrtEwJVWEtZM57
	+083NUsvEeaCGC7eKS0PxZcTuuVO3htoMAzE/340ZHNaqPo65yYQMQzBoA14MRQ/
	U1WfcRLOZtgGvg1WtlRU9fel8AnoTknmJlotV31MzTYYjM3AQgHnO6XkiPBR1xaS
	5MsrDJAdLkXhQQk2fYp82s429C9PzucPRoY8z6738/suHI1TF1MXouTWuSWMk9g0
	MXcWGdwPNImZ6469/0EXoGD1g1z3KFsEm9ovxe6mBGTcy+7IwXUB8dW5EYA871T9
	qQMtkgwZY25EofZZx6SmwzZDtJh0xUOuEG0NvjoQVTHV7NFw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40scmtvywa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 18:35:31 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 475IZDPw029432
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 5 Aug 2024 18:35:13 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Mon, 5 Aug 2024 11:35:13 -0700
From: Elliot Berman <quic_eberman@quicinc.com>
Subject: [PATCH RFC 0/4] mm: Introduce guest_memfd library
Date: Mon, 5 Aug 2024 11:34:46 -0700
Message-ID: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEYbsWYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxMDcyMj3fTS1OIS3dzU3LQU3ZzMJF0TU9M0IxNDQ9MUEzMloK6CotS0zAq
 widFKQW7OSrG1tQANa8cfZgAAAA==
To: Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Fuad Tabba
	<tabba@google.com>, David Hildenbrand <david@redhat.com>,
        Patrick Roy
	<roypat@amazon.co.uk>, <qperret@google.com>,
        Ackerley Tng
	<ackerleytng@google.com>
CC: <linux-coco@lists.linux.dev>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <kvm@vger.kernel.org>, Elliot Berman <quic_eberman@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: -UsEeCYgAlnHOpTqQsok4USDujEu93kb
X-Proofpoint-GUID: -UsEeCYgAlnHOpTqQsok4USDujEu93kb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-05_07,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxlogscore=448 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408050133

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
arm64 pKVM. The Gunyah usage of the series will be posted sepately
shortly after sending this series. I'll work with Fuad on using the
guest_memfd library for arm64 pKVM based on the feedback received.

I've not yet investigated deeply whether having the guest_memfd library
helps live migration. I'd appreciate any input on that part.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
Elliot Berman (4):
      mm: Introduce guest_memfd
      kvm: Convert to use mm/guest_memfd
      mm: guest_memfd: Add option to remove guest private memory from direct map
      mm: guest_memfd: Add ability for mmap'ing pages

 include/linux/guest_memfd.h |  59 ++++++
 mm/Kconfig                  |   3 +
 mm/Makefile                 |   1 +
 mm/guest_memfd.c            | 427 ++++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/Kconfig            |   1 +
 virt/kvm/guest_memfd.c      | 299 +++++--------------------------
 virt/kvm/kvm_main.c         |   2 -
 virt/kvm/kvm_mm.h           |   6 -
 8 files changed, 539 insertions(+), 259 deletions(-)
---
base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
change-id: 20240722-guest-memfd-lib-455f24115d46

Best regards,
-- 
Elliot Berman <quic_eberman@quicinc.com>


