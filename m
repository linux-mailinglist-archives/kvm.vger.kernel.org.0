Return-Path: <kvm+bounces-50835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D983CAE9DEC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 14:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C541189BE3B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 12:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378B72E5407;
	Thu, 26 Jun 2025 12:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eRNMsI1r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB33A2E4264;
	Thu, 26 Jun 2025 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750942654; cv=none; b=h8mfywCKet1AiaxFT+t8mTONtSEmSXCrmyhOrj99BgkPWqxw0kAQ8xwasE6/39Zx3HfzDshKypkC/QXXan+jCsFroNthiYphiZWxxbFQVhEHaMrwhzYgFHtmBkxPe+fneLNPgSWz/LA3RdYLEUKgpcG6/+QB0Ih8/nL/Bj59YzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750942654; c=relaxed/simple;
	bh=348dpTNH5EI2QYtQc665ca/rWQy2fAD9t1O1+/rdjEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TrawQUNb+jrkRzMN84BH+Km70NpfBAlgYco9SJ1NDMMNGl0U7PGVBdqGY9EQ5jJfTKqpFoWqBw/uXoUtsuTDaytae7gBtVTK/efhlMw9KRS/DjPlpcQadygCSZgGmJYoDI7IOcEsdlr2EE7LNjCFdwWtcjAHu1E/ihOE/e0Bqyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eRNMsI1r; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QCaZHm012705;
	Thu, 26 Jun 2025 12:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=fmSXiDDkUbgQdL1yycJSuUcPLS/wg
	k3Svbi/xoLXzP4=; b=eRNMsI1r1lRUmXeenL4cudV06tO0JyltLiITzoCTY7FOZ
	DXrq2f7pmpRKzlH8zh42qZj6m8iww7P3g3tSMQmy+oRjA6mOE9wvC/4iD2kgwNL0
	uSG1jq2Z5b/UIkeqjXtvmlozLZKsI5EhMqt/0+BBIecB44IB0JQLFCsaPLA94a2Y
	BzqE/xSqKypH5v9AVsiOwQnuo1yVEoROwNfC74dlaunJAmf6UUzWe2uIiZz+ioX8
	gIECUOJLq6u3A78bePAcyM75Y6ueYTnp9MPop3A9tao/uLpb8L4qjczGlOEnXN9R
	tQmpybL45n1knG5sueGS73djHncrc4pcm8Ynfp08g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7v1uw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 12:57:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55QC1G9Q016945;
	Thu, 26 Jun 2025 12:57:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47h0guw5j5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 12:57:24 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55QCvNDD036282;
	Thu, 26 Jun 2025 12:57:23 GMT
Received: from laptop-dell-latitude7430.nl.oracle.com (dhcp-10-154-185-106.vpn.oracle.com [10.154.185.106])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47h0guw5h0-1;
	Thu, 26 Jun 2025 12:57:23 +0000
From: Alexandre Chartre <alexandre.chartre@oracle.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: seanjc@google.com, xiaoyao.li@intel.com, x86@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        alexandre.chartre@oracle.com
Subject: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on AMD
Date: Thu, 26 Jun 2025 14:57:20 +0200
Message-ID: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_05,2025-06-26_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=844
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506260108
X-Proofpoint-GUID: 6a_RGHxLDHvPWTezhA1AHM7frizJruN7
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=685d43b5 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=HadWVcXipCZVIetjCJAA:9
X-Proofpoint-ORIG-GUID: 6a_RGHxLDHvPWTezhA1AHM7frizJruN7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDEwOSBTYWx0ZWRfX1ypo/LKKPGAu 8F6KQzCr4YIU8JVRXxUto7/hgtrLk8Lc0w7ZA+/QK0fUyPbFjseOxB8497bX9V2qM0dx/7IMkaE 5keLGRqQvMKvU702dKt7cKtE+rn4dp5rCxkbsW2webuZULWURuzdAcXflRBuXClKOMS586DKRh3
 S8gBSk2KOhkpJYA9D1j5Hux1EBU9NL7jIB5N98eow359p2NhZ+K2yS9ityDGGb04RE3gJ+J9AtO 2tVLQ2+1YZEEebkwYX8pf0m+hQDK3RcTbLhD2a3st0PJRtt3gjy+wVm2ZRhtp4/zndhRC+0+DXl V7O+EGaK0WI46vbObiUd7e+Ris8Mr+d3ZClwlSiZdsupS0YVjwcxQp+mDmbOga6jHVizUujkPQX
 0i4Jll/8mLSj7UVt4hOA6zq6ltgdRRqTxDJsxoOKmSL30S0ggcQKCtaI5oWVqHv56oHFPZnO

KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
so it makes no sense to emulate it on AMD.

The AMD documentation specifies that this MSR is not defined on
the AMD architecture. So emulating this MSR on AMD can even cause
issues (like Windows BSOD) as the guest OS might not expect this
MSR to exist on such architecture.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---

A similar patch was submitted some years ago but it looks like it felt
through the cracks:
https://lore.kernel.org/kvm/20190307093143.77182-1-xiaoyao.li@linux.intel.com/

I am resurecting this change because some recent Windows updates (like OS Build
26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
just because the ARCH_CAPABILITIES is available.

---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab9b947dbf4f..600d2029156e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5469,6 +5469,9 @@ static __init void svm_set_cpu_caps(void)
 
 	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
+
+	/* Don't advertise ARCH_CAPABILITIES on AMD */
+	kvm_cpu_cap_clear(X86_FEATURE_ARCH_CAPABILITIES);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.43.5


