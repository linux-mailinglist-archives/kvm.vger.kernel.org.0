Return-Path: <kvm+bounces-65002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DB007C975E7
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:51:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE8D1343EF8
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDF7322C9A;
	Mon,  1 Dec 2025 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qi/UFCdo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25149313525;
	Mon,  1 Dec 2025 12:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593122; cv=none; b=tksehC4Psm6AZlhsFptxJNHoBS1PJd6kmOaiZbcE9FiJFI6pg2m3rqZ+eX2LjKpI/wBau0VTTdHA40ABw/7djvXgy0JhJdd/GaJquMrF10EOxc0DDoFbRcnoRT5GzfTrgjwJRWxmfZb7wiJQOCToaSTULfm49hCI+2tejrB9LC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593122; c=relaxed/simple;
	bh=MIxbwnOmkQfp9pYdSU2ywXWUkH8knNaSMlnnAknw70U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsIXcqlNQelAhYo+MhBWSm37v7MM9vc8higxyOrSKgAKX/aE9o3vZeR/XyXzguJQ5MDm5WGhnr+Bx0GUFYfDhe+O+wOsOG3CTEfMiw3tr1t5Dg5nNmdA1f8fCc66sGUHMUpXyPXVhr/LeDYp07f3szOaJluJcuseWkKok4rxNwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qi/UFCdo; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1Cdo3p010952;
	Mon, 1 Dec 2025 12:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JM2O/e3Y+Rfa/fnB6
	zWjcTyYwUsZt6TaSv0KVqiPqLY=; b=qi/UFCdoMZa59OWEyBQ2GBqHZGAf3Rzmb
	PoLsrswrIGfWcwfLvz6JGxWkQ4CwylvfDyT/iqjaevI/LdD+E90P/HMEyGdJmPrT
	gLCgKZfU3xx1eZfrscOWuWq1Ur7lITNWWWIB39+f5O8v6QRBegNXiP0RhT3FiM9H
	8qvJzb2AtNwgG525F5eZldabv99ATZ7dbO2HstmRwBdn1w3nwhOa2bZElNJz4uim
	Nr8LE0vegPy8MsbkTf5uLavEIXZ/tdXy7wqvjJW70Yq8q3ii+uRu/SnkdN4NESz4
	T4XUSXRmzHW8wUPsuJZ1cDgu1X53ZD42wzjGcU2fFuYFW44zlfAvA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrh6q3py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1CG9WH019035;
	Mon, 1 Dec 2025 12:45:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4arbhxpfq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:16 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjDF224641806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 053C120040;
	Mon,  1 Dec 2025 12:45:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BABE20043;
	Mon,  1 Dec 2025 12:45:12 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:12 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [GIT PULL 08/10] KVM: s390: Add signal_exits counter
Date: Mon,  1 Dec 2025 13:33:50 +0100
Message-ID: <20251201124334.110483-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=dK+rWeZb c=1 sm=1 tr=0 ts=692d8dde cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=G-lmFN37WTdQfOt6kDkA:9
X-Proofpoint-GUID: Srn4eFlzuaFnJSvkeu2koepa_BKPCrcw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMCBTYWx0ZWRfX0R43SV0PPzVw
 82DJ6JCj6zlXYF7d2eUIxpcE/WpgNkSXAO4usD8Y+6TMdWDNQNwW+qBSVsTiHuscn8CdiVOwkMs
 ya9u8ugN54vCBBBhWMESwHRuHl9/pPfXjzLvbv+nJQgr20AWfRazfqw9UNQkpgwajcKiuTkcoNg
 jbp0qcVvrNJTstjSy4GRjlWu2v5KFB5VKy+5GWM/dSA/5wxCrLdjmnxaDSywaV1Bfvs4urAjP0E
 GBEM181p55XH7FucJbEDwz3wQbcqjQe+TvODFFwsWr62+jl7BTsUJZQM2wZp//77qDrIkqxrxdO
 m55k9FAvZGsEuAVlEg6JmQwwQHArSH2VPXfqzzo2hrSqWK7+Ouh2T5/idmqEFBzNh8lwHCv1b1W
 HtfJsRJP4r8yfj0v3hjEoAtWPCZlGw==
X-Proofpoint-ORIG-GUID: Srn4eFlzuaFnJSvkeu2koepa_BKPCrcw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290020

From: Andrew Donnellan <ajd@linux.ibm.com>

Add a signal_exits counter for s390, as exists on arm64, loongarch, mips,
powerpc, riscv and x86.

This is used by kvm_handle_signal_exit(), which we will use when we
later enable CONFIG_VIRT_XFER_TO_GUEST_WORK.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 1e4829c70216..ae1223264d3c 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -146,6 +146,7 @@ struct kvm_vcpu_stat {
 	u64 instruction_diagnose_500;
 	u64 instruction_diagnose_other;
 	u64 pfault_sync;
+	u64 signal_exits;
 };
 
 #define PGM_OPERATION			0x01
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56d4730b7c41..8db37e508a71 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -185,7 +185,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_308),
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_500),
 	STATS_DESC_COUNTER(VCPU, instruction_diagnose_other),
-	STATS_DESC_COUNTER(VCPU, pfault_sync)
+	STATS_DESC_COUNTER(VCPU, pfault_sync),
+	STATS_DESC_COUNTER(VCPU, signal_exits)
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
@@ -5251,6 +5252,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	if (signal_pending(current) && !rc) {
 		kvm_run->exit_reason = KVM_EXIT_INTR;
+		vcpu->stat.signal_exits++;
 		rc = -EINTR;
 	}
 
-- 
2.52.0


