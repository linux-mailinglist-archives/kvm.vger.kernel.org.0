Return-Path: <kvm+bounces-46522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 088BDAB71B6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:41:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D7C9175AA5
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FF6281370;
	Wed, 14 May 2025 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OR0RCHb9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA818C011;
	Wed, 14 May 2025 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240747; cv=none; b=Qw4+og2TDloY0AANSytca3Jk+jZ2M1qad+Zot++VKbQrqewd9QpnsRAkigIb5mh7/5NETZjvTdjL+K1n/bxYbLzPDSLjz/HA3cbeGDDPVxTBLj8xxy9mZFHt1WxkxOd23SLQgFTHdot5ZPYPYIzB56jWKji92S6dckzs7PBIesM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240747; c=relaxed/simple;
	bh=G60b3ECJ7wnNCGvp6dLGMelR55TedPtrt178s8wBAjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4k+7j6UD5QeS56McFKgSxjC+DThk8XhPjodrj0+xoPg/CGeouCXMZZ/aByfee1HztpcIqhLwQFn5PLpblSWiwYqFJ/BzWP8WgopJHW76Mp7ZJqEAej8eIhFuDysVYFDDok79i5tSSxfCyTgx2tXnGknS6D+Ya9rJZYjVHNKVZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OR0RCHb9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EEiVle016990;
	Wed, 14 May 2025 16:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5fz9ydSZjyCZWvdkL
	a28gUUo3haPpqVuA8Xt7kmDnQM=; b=OR0RCHb9jv8SW/pgkpR+woXwCkFOUZSXB
	kYfRcNgrcsWA2Kom1rnk0DszSuh0ds0pa++ZBhdD20EEYNSuG/S3Ko/5CnRFmAGf
	fzxvwrp0EaXRRiPclt08AMvfcpbfLtcOCP9NgWa7fORdrj3ELV0JaTdQHZI4WW4T
	HIfLS20d7piOUdKJ7E8/DsthwUAjQpWx3tdx4M9663ntttGSiihBxLX8HVeQ9ueo
	kN1ttoA1GSVFkwqsGGG2T/Pho2qEH7o2hVxyD8xdrlOFQ+ULrwRh4IVaM1xWcue4
	gIduZH0tGzDi7zcyLJSAIGCe3E10MBPciyA5dFtbk1w2oOgZ/nLSA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbq8nn8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EGcJGl024279;
	Wed, 14 May 2025 16:39:01 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfs59jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:39:01 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGcvJe28639776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:38:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F7B620043;
	Wed, 14 May 2025 16:38:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAB1B2004E;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:38:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com
Subject: [PATCH v1 2/5] KVM: s390: remove unneeded srcu lock
Date: Wed, 14 May 2025 18:38:52 +0200
Message-ID: <20250514163855.124471-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250514163855.124471-1-imbrenda@linux.ibm.com>
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4xL1AtLynSzsmBhHUhtre0eVzbqZXfAk
X-Authority-Analysis: v=2.4 cv=GrRC+l1C c=1 sm=1 tr=0 ts=6824c726 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ELDMwNJArE-rEd5HdXMA:9 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0OSBTYWx0ZWRfX6PTtbMi3mZLO LfCYfCyuQO5H8KnJdnVlcsep2OJCj5r/2y3hl/oRFdM3zMflYx9XQMGqwmWRnvHpPFG6stEjk8M WFa/ZUGcYtGduEjFK3tO+BroriOkynZD6q8L0kmIktGpLTzN/FDNqcsRbNwcRrvVfmcBe7QDiNa
 hul+SbslcUyxqAOaTiuy1WF3O7Hdje1lRk0pF2J+jMQEYPhJSIHQiMzRIjGd0eCSddYIeOEpgJm Z9zuZ647ZkGtAHPScp8+I9I90NjCksiejF6EJ8O1+fFttzsxb0i8tq8IxWxMZWWYqBTId+FlqlS RsMgPbaYxgdlRo7jsc4u5jZUMRw/J4yuUJumghvXJAzMnwngLTtj2kpK9RNTloznI3/4yJB4qnS
 znZLVtVgEHbj+0P42DBhPWz0nsFTTnQYVCnk8KawVJhlgqPUuKnbe6Iv+ptFkDjAnvW7UudT
X-Proofpoint-GUID: 4xL1AtLynSzsmBhHUhtre0eVzbqZXfAk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=667 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140149

All paths leading to handle_essa() already hold the kvm->srcu.
Remove unneeded srcu locking from handle_essa().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/priv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1a49b89706f8..758cefb5bac7 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -1297,12 +1297,8 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		/* Retry the ESSA instruction */
 		kvm_s390_retry_instr(vcpu);
 	} else {
-		int srcu_idx;
-
 		mmap_read_lock(vcpu->kvm->mm);
-		srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		i = __do_essa(vcpu, orc);
-		srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 		mmap_read_unlock(vcpu->kvm->mm);
 		if (i < 0)
 			return i;
-- 
2.49.0


