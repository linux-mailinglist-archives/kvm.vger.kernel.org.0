Return-Path: <kvm+bounces-14216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB348A09A9
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:25:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43601F24BDD
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A83813E407;
	Thu, 11 Apr 2024 07:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e5eFim6E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F059613DBB1;
	Thu, 11 Apr 2024 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712820323; cv=none; b=ihIMwqyPVVONff3bpDijYLumGtpDrevA7iAEtfKppKvc518awPgLlS9puOwtZZEVpn3qiZpMw5TXmvl37yA6v9l2Sy+WUBOpsgTYUZ6CLVZCDYWVsZJSrmT5AYk0Za2dKibfamzvusvEfYekfy49uzTceRXKHbg9edg1MnZuCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712820323; c=relaxed/simple;
	bh=6mwx4ZptoWeBdE7Uw4CKuzXPvoq1OIBVM0SrKdhpFVo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rdvyeaq5943U6IBgKVrsrtPoUO6ziZD94F/23ngT6ixYl4s3uTYqVlcCAp2B68xqGt3AKGWCrhTV1HvoAagsbgEQL1IV8jWy/SiTF8QGIK/DUmgu77gEUvRvnef58j1eLxrkoauozRVlaH5MbhJz6ORBY3b813GbfCZSMEnjBFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e5eFim6E; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43B6E0AM007560;
	Thu, 11 Apr 2024 07:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=lnwdpFPDwDwPRlXtxxrN+weoWOb9YtGRdlGy/ntNYTo=;
 b=e5eFim6EB82WRsdIBzsU+wCgnSefXFq1fDckwuLls5TLExv8beDHwHtN0cLwemew8wJV
 wh9l/stTjfY3Gr9gqU5TwTnf7E9okaERsSwIEYii4qc1SCFzU1/AvGey+lwqC8r7j3O8
 +HLMv6wRoIgl2S/RYyPQ2kdxQcCmi8BflNw/YXUfkYn9G73MWB7B/qjzCRxJhK2JyLKk
 fUZAJKWq6Lc5jkunILhxLd3uOL9Jpt9hndUAD8Vqmt/rrGPOrn2O1ePOEjcGVfojpQas
 43z9trZxLO55KvCoPdzYmwKYrd2nHmVDTq5rtPoBwaTdWyZzXi9Cydyw1fV1xb+ewj5S nQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxeds347-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 07:24:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43B6sLxj039988;
	Thu, 11 Apr 2024 07:24:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavuffdpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 07:24:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43B7Omtd030222;
	Thu, 11 Apr 2024 07:24:48 GMT
Received: from laptop-dell-latitude7430.nl.oracle.com (dhcp-10-175-60-243.vpn.oracle.com [10.175.60.243])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xavuffdnp-1;
	Thu, 11 Apr 2024 07:24:48 +0000
From: Alexandre Chartre <alexandre.chartre@oracle.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, alexandre.chartre@oracle.com
Subject: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected by BHI
Date: Thu, 11 Apr 2024 09:24:45 +0200
Message-Id: <20240411072445.522731-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_02,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404110052
X-Proofpoint-GUID: J38Ol2hH7iRACtHNqOkjjXgSFLZcRMdR
X-Proofpoint-ORIG-GUID: J38Ol2hH7iRACtHNqOkjjXgSFLZcRMdR

When a system is not affected by the BHI bug then KVM should
configure guests with BHI_NO to ensure they won't enable any
BHI mitigation.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 984ea2089efc..f43d3c15a6b7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
 	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
 		data |= ARCH_CAP_GDS_NO;
 
+	if (!boot_cpu_has_bug(X86_BUG_BHI))
+		data |= ARCH_CAP_BHI_NO;
+
 	return data;
 }
 
-- 
2.39.3


