Return-Path: <kvm+bounces-48530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 29D51ACF2FA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A87B189399B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDA11DF725;
	Thu,  5 Jun 2025 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJpChBzE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80381BD9D0
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137115; cv=none; b=UGcp0KMk1gPWfQ/Zf1MNYLnYB13jlt5W0OBRDoANnrhtKA6NCZa6sGF07YNXJtcAH7zmMQ4TnOkDvTCrhMOKqFK6Soi1M0s1gdGgXoIHEV6OEUs5g7dXW9mRDbymNM9l8fc3MiL1TzI/6tIt7qg9RllLd6D99OHnGR5MrqPChm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137115; c=relaxed/simple;
	bh=m4iz7jRUWrMlw8duduSxoawfe8EC0jbEDxSYVQuZ87o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA+sNKs/LB3xLjdwYnIwWsB8yb5x78jXElIrbKRN0PtAWvciMnrz24TThCgRg775fPedCw0WdTgR89eNbUCp3RxGGcNj10oSdRipwYqsxLOH71bUa6bXNY0mXuexNy2llZTwv+7CqXVGi2xgonGQ/8mfmbj8Pui4UxaWTQWtgf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YJpChBzE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtVkk032029;
	Thu, 5 Jun 2025 15:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=SDTiE
	Rnc0Auu9HXB5u1EVour+XQZeV+2kZRosebJjm8=; b=YJpChBzElE0xv1RUKjWFl
	/X9PsfmQ+ThgFGk3wcTmSKah9rHSltXIggL1wDwJK5buth/UZACOmLl7yIiIfYk2
	Yq0gXlvrpG+rmquNH2czvfDVuQhazB6SVh4qtFnpdllg52ycCukOE/rH+3GQ3+zx
	ACx8AG9+vrR18ow5xf8K9jGGs16dMxH7M5RybYZEQcOYEcyTXW+0O6ku11PQQY9J
	dP6FDLjXPjKyAT9oWG/Aft2bk5eBcVu5Ea/G0isxuHtWRhJzXz+n32xSTspCrWJI
	4dSLsrQp6zit5T+0iNQlvzJqE4dqSlfGnTwuGHbvElbmbXkrYSMkBA8+FoDQGu7p
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8geajb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555DpTZJ039442;
	Thu, 5 Jun 2025 15:25:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c8bx9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:08 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 555FP4lw016227;
	Thu, 5 Jun 2025 15:25:07 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46yr7c8bt3-3;
	Thu, 05 Jun 2025 15:25:07 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH 2/3] KVM: Add trace_kvm_vm_set_mem_attributes()
Date: Thu,  5 Jun 2025 15:25:01 +0000
Message-ID: <20250605152502.919385-3-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250605152502.919385-1-liam.merwick@oracle.com>
References: <20250605152502.919385-1-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfX7Zifs0xLVipE pxU4u74y87p3FfnCU5LyYtL/y0FdPCtvH/0BVTZZvkDK/kL1I5N1rPLRwztk9z/1+lQFmS9QGji GY3tfwgSlzcLzlBPN8kjm+mAY90WCQVRjCSb4L611u8Zcajoq/N4U1i9wRWrS1AhQmdrkqONbe0
 JQjrVSmwGoHaB+/+WJzjgZpChJYwP1NbFtWnywVNZibPvJH+ObQGYp+sG/7+syqqC/wAE/BVeFW luM7GRsxz9SBJdlxQrOQeKqQDaMENbKQTpv5vWWdkD2VQljFtIoJdDQUTtNPDssZ256Lo6wDtnD k6dswuBkwBesU21TVOjGGLwUkUJxtET7pWEhpKZQU+JXX7s718VjQzq57X1uIPDTObpfdbRsVkZ
 nwa57yvPbCXnkMQbZYEls+nt9GW/YOwqEEb9QdpKMDgWG6VxkVuIWvKBqrRZidzAlrrgOnaJ
X-Proofpoint-GUID: 60KlyE_s3pb8bDhiKmuCwoBCbDv-LPMa
X-Proofpoint-ORIG-GUID: 60KlyE_s3pb8bDhiKmuCwoBCbDv-LPMa
X-Authority-Analysis: v=2.4 cv=H5Tbw/Yi c=1 sm=1 tr=0 ts=6841b6d5 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=xXynH1Qyzpsyf0xykmMA:9

Add a tracing function to display the attribules being set for
a range of guest memory.

Sample output:

   <...>-12693   [059] .....  1342.536361: kvm_vm_set_mem_attributes:  0x00000000000000 -- 0x00000000080000 [0x8]
qemu-kvm-12693   [187] .....  1342.747651: kvm_vm_set_mem_attributes:  . 0x00000010000000 -- 0x00000018000000 [0x8]
qemu-kvm-12693   [040] .N...  1366.473790: kvm_vm_set_mem_attributes:  . 0x00000018000000 -- 0x00000020000000 [0x8]
qemu-kvm-12693   [009] .N...  1390.350362: kvm_vm_set_mem_attributes:  . 0x00000020000000 -- 0x00000028000000 [0x8]
qemu-kvm-12693   [008] .N...  1414.154231: kvm_vm_set_mem_attributes:  0x00000028000000 -- 0x0000002da80000 [0x8]
qemu-kvm-12693   [136] .....  1430.988101: kvm_vm_set_mem_attributes:  0x000000000ffc00 -- 0x00000000100000 [0x8]
qemu-kvm-12693   [024] .....  1431.029798: kvm_vm_set_mem_attributes:  0x00000000000000 -- 0x000000000000c0 [0x8]

The '.' before the addresses above signifies that the initial request
was split into multiple operations. Originally it was requested to
set the attributes on 0x00000010000000 to 0x0000002da80000

Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 include/trace/events/kvm.h | 33 +++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |  4 ++++
 2 files changed, 37 insertions(+)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index fc7d0f8ff078..701bf1f88850 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -473,6 +473,39 @@ TRACE_EVENT(kvm_dirty_ring_exit,
 	TP_printk("vcpu %d", __entry->vcpu_id)
 );
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+/*
+ * @start:	Starting address of guest memory range
+ * @end:	End address of guest memory range
+ * @attr:	The value of the attribute being set.
+ * @indent:	If true, indent output displayed (printing '.' is used to
+ *		indicate that the transaction was split into multiple
+ *		operations and more are to follow).
+ */
+TRACE_EVENT(kvm_vm_set_mem_attributes,
+	TP_PROTO(gfn_t start, gfn_t end, unsigned long attr, bool indent),
+	TP_ARGS(start, end, attr, indent),
+
+	TP_STRUCT__entry(
+		__field(gfn_t,		start)
+		__field(gfn_t,		end)
+		__field(unsigned long,	attr)
+		__field(bool,		indent)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+		__entry->attr		= attr;
+		__entry->indent		= indent;
+	),
+
+	TP_printk("%s %#016llx -- %#016llx [0x%lx]",
+		  __entry->indent ? " ." : "",
+		  __entry->start, __entry->end, __entry->attr)
+);
+#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+
 TRACE_EVENT(kvm_unmap_hva_range,
 	TP_PROTO(unsigned long start, unsigned long end),
 	TP_ARGS(start, end),
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6e6d404a7d7a..464357ea638c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2568,11 +2568,15 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
 			size = SZ_512G;
 			size_remaining -= size;
 			section_end = section_start + (size >> PAGE_SHIFT);
+			trace_kvm_vm_set_mem_attributes(section_start, section_end,
+							attrs->attributes, true);
 		} else {
 			size = size_remaining;
 			size_remaining = 0;
 			section_end = end;
 			WARN_ON_ONCE(section_end != (section_start + (size >> PAGE_SHIFT)));
+			trace_kvm_vm_set_mem_attributes(section_start, section_end,
+							attrs->attributes, false);
 		}
 
 		ret = kvm_vm_set_mem_attributes(kvm, section_start, section_end, attrs->attributes);
-- 
2.47.1


