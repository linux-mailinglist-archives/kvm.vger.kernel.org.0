Return-Path: <kvm+bounces-48733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECEAAD1A56
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB40A3A23CF
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F096524EAAF;
	Mon,  9 Jun 2025 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mvUVE0oj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FF924EA9D
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460293; cv=none; b=vD6jth5+ECcUasiUqvsGTUYOzvipPinExzZpgdIibDcozZg6YqH3AHe4KLKw2dJ+FjXlF7/WBO3OtD48HdA4UZZyb5stsjQbsH6BpAyOu3JdBngIGOhK3H78JqPyX+kRIKLuulZkeRF/kbeTux9Ozcpba8mI2ZXn8bzOMOxcBiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460293; c=relaxed/simple;
	bh=PS+StBhbgP0RAH7odgtdGBXw9fU450CDVeaVJEOj4hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNCnbchgL0Wy9mckdopCjLGBQruuoZs4I1gtwhp0EdVMCwSAn8irajlVW4OBZoNfJXwOMiSIFnj7e95nzycIgaYTaU+jerEvEFHUWccSraezw+otPUXdPak9UV8W4DYbjs4avTLCNCNH7tEcguVVPxdTXcwmlw1zokRp5N4mYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mvUVE0oj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5593iXlu006086;
	Mon, 9 Jun 2025 09:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=YJB3V
	72ox9DmvRogb4B3NH8d3lfWdxNY9UT2ml7hi5I=; b=mvUVE0ojnVirIN+I76//B
	9acVjIh7rH6kZzZDRmI9a4X+Dyb+rv9jq2nm/Cz72hVsmWeE2tLkR116bWmVO+um
	xBaW/wlbKPenSBFJPUIyU9pYUDVEFeOKsPcHchoXOghWWrUvyhJmaOhB+X+kjd7m
	aUgr5k6jofpuJAxvncfBNsuMj9WuviSlUkxxHb0ZRY7XZmf0YT79Vnax3YAkoott
	jouZVr+ZhFTnGKPptmlO9tfVjA4s8bBSRUmuXZxLlQBF0wChzoooHEyWw0elMAnQ
	Cv8QE+ShXm8gOhYy7IhnFu/KU/Da0P8rQE8wVtGZ7/W/oAk4jiZOytFccTDqvtq/
	A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xjs3x9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5596UdQw032053;
	Mon, 9 Jun 2025 09:11:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv77nf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5599BMj3030518;
	Mon, 9 Jun 2025 09:11:25 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv77nds-3;
	Mon, 09 Jun 2025 09:11:25 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH v2 2/3] KVM: Add trace_kvm_vm_set_mem_attributes()
Date: Mon,  9 Jun 2025 09:11:20 +0000
Message-ID: <20250609091121.2497429-3-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250609091121.2497429-1-liam.merwick@oracle.com>
References: <20250609091121.2497429-1-liam.merwick@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-09_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506090070
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=6846a53e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=CFrF5bRVCPIDv62-1HEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA5MDA3MCBTYWx0ZWRfX8RTCqM7yqjkB tcHSjmnNtc1GBwmLnSu5uSJbuIfIyZMsn1hiSaTBQUiIBp/AyHZbReF+OsmQWF3pJYIK2QB/4/X FCY8CSkpByPVfECaCIL17GIvvDdQVyJYFoPlVb/jLGS32ywc8p0eDR3wBS3msseNfLw8aSPYJJU
 fWsRbjAdRI0oplSY0RJKOve2CjYkFlwp7UoebOdkpLyHXkSRVVfy7qx2gcqgtITvNK+GWOEacoB XWGWCu7tBox9kieEZRwPCYFxbRbsNAhA5ti706MmXUwDspXc0plmz6mHOkCPnayrw+pS3vvyA74 nY3F7s2iCSj9yza0I9wGUUGPYw+feKxYGAeFkiBER17PUHahjcrj2tov5urfnetakxhDMGd2ss8
 rmRktAN77x9DpYyAEtp/gW08VyBKCFnYb6+6KJkKbh5O8LBaLqBDxKmEeM2WtIO/uG21GHlN
X-Proofpoint-ORIG-GUID: uj8bvsMQ24Qwl8q1KNuPw1jFn-7k2Lad
X-Proofpoint-GUID: uj8bvsMQ24Qwl8q1KNuPw1jFn-7k2Lad

Add a tracing function that, for a guest memory range, displays
the start and end addresses plus the per-page attributes being set.

Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 include/trace/events/kvm.h | 27 +++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af4..dfaad67d2c0a 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -438,6 +438,33 @@ TRACE_EVENT(kvm_dirty_ring_exit,
 	TP_printk("vcpu %d", __entry->vcpu_id)
 );
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+/*
+ * @start:	Starting address of guest memory range
+ * @end:	End address of guest memory range
+ * @attr:	The value of the attribute being set.
+ */
+TRACE_EVENT(kvm_vm_set_mem_attributes,
+	TP_PROTO(gfn_t start, gfn_t end, unsigned long attr),
+	TP_ARGS(start, end, attr),
+
+	TP_STRUCT__entry(
+		__field(gfn_t,		start)
+		__field(gfn_t,		end)
+		__field(unsigned long,	attr)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+		__entry->attr		= attr;
+	),
+
+	TP_printk("%#016llx -- %#016llx [0x%lx]",
+		  __entry->start, __entry->end, __entry->attr)
+);
+#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
+
 TRACE_EVENT(kvm_unmap_hva_range,
 	TP_PROTO(unsigned long start, unsigned long end),
 	TP_ARGS(start, end),
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index aba4078ae225..09d4217410fd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2543,6 +2543,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	entry = attributes ? xa_mk_value(attributes) : NULL;
 
+	trace_kvm_vm_set_mem_attributes(start, end, attributes);
+
 	mutex_lock(&kvm->slots_lock);
 
 	/* Nothing to do if the entire range as the desired attributes. */
-- 
2.47.1


