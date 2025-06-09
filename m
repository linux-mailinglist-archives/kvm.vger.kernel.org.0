Return-Path: <kvm+bounces-48734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51CDCAD1A55
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00B29188C746
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DCA2512D1;
	Mon,  9 Jun 2025 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mvOeR54B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71BF2505BB
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460295; cv=none; b=bLqgKV//R5VAa6yVs9tOie7uIvOstq26UGVmg1tPhiRi8bES+nb9BH338P/uczNq4R4gTXpaQG0XOe5nVBSbWjiAbeNDaDBzXVVSqO1aihW3dB73T/wd+OJK008tmwW36OvBU9Dk61Z0X1vFrVkHhyWgW25CguHsEvnWpGB3xb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460295; c=relaxed/simple;
	bh=wi205Fa8ZiLX3nj1bFB1UMxhXFlJ8avhlYdAmRcKEKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWl1/K+einztHRawZowgOthRez9+Q6Dy6lGEMNrpAMy9ocJtNFy/KalIpl9JH8cDdeYtUuaEdRi4ORs2chVny70pA/nFWH2pBhnzlNV0i4a7plTN8zI7OTKulLOgeyy48cVv+otje5NQyG+zhFtXd6SFVe9URTapiPJioe6SPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mvOeR54B; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5593fW4u030944;
	Mon, 9 Jun 2025 09:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2+GH7
	UijAB1MSuqc1tPmAYaEF6ycXjTd53egp0SflTQ=; b=mvOeR54BR0uSouKYtb425
	tXf04UNphZARXiGaow2vatjGwFj1v17O3U0XNXnsI7RiD4sTjEIzBIP/Pjc052oe
	W/nNtX/X3hHImTn8s7ey8HJwlnzzs2jGmOUuLeKJ6fCVk3AZtIDgxmrZmbWQpyFF
	1KYzZGJzQP8gavqknDDH2gREBOhA8bzDPExPzmADx9V/oiA2ClI2q/TI/4HLx//s
	ICD+z1z/k0TfyC4TY1/Cojb2Bl9Lb0DqkRnv6wCvstDEPX7zAcuqv8BLeL7v4jEj
	/4BIgvCvBnVOJ2UNNqOzj3a70mkIPalFHc/iwL8rRb5M9t++nkslIM9x0mchq5Av
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1v1sfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5596kFnB031327;
	Mon, 9 Jun 2025 09:11:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv77nfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5599BMj5030518;
	Mon, 9 Jun 2025 09:11:26 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv77nds-4;
	Mon, 09 Jun 2025 09:11:26 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH v2 3/3] KVM: fix typo in kvm_vm_set_mem_attributes() comment
Date: Mon,  9 Jun 2025 09:11:21 +0000
Message-ID: <20250609091121.2497429-4-liam.merwick@oracle.com>
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
X-Proofpoint-GUID: zFm78BbRd16gvRldpiYgjlK57OufbpIC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA5MDA3MCBTYWx0ZWRfXyxdeUT0ShuM2 ACTcqKRrJ+z/e256wsCK3KJiAKbejFL5pSvtw+HNO8Io7gsVdCV3cseX7r7vp3qIlVqKaH7hfTW oRyEMiHYbG8W5W3DL1MCEab2i1zbghQGl26NNcOnvaoi9c+TZ2faUXh9iC3JkaWeNyOduNYbmI4
 dnR1sBfGd0yA4x3iZG8fNV1rH1mAxdr+GoQ6kCiFBQKTQis+b+St2T8z7tgrDKBdZpbAJ4bnw29 JX7ip0+V+GVLMfos4QQTdQqNd6SfGkRa2uEJEywxk1OsnLXudU6SWRYZ8ocnIkd9HJC7Ib6+Qc3 CIjKN2VgeRfH9OrgJ2Mi7Gt5FWdCkf9Jj2iZgOTUD4e9YkakF5rT6kibY1LZwXkrZeSwuItPa8C
 +r5lsSX3BIhiN54lSLGtP/e2QmBwkJknePChpskqIN0l3z+2nftcPWYDmKA1krk+jPqMFeXm
X-Proofpoint-ORIG-GUID: zFm78BbRd16gvRldpiYgjlK57OufbpIC
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=6846a53f cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=shpGOsIX7GbQuHb7yLIA:9

It should be 'has' in the sentence and not 'as'.

Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 09d4217410fd..d030ebbdc91c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2547,7 +2547,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	mutex_lock(&kvm->slots_lock);
 
-	/* Nothing to do if the entire range as the desired attributes. */
+	/* Nothing to do if the entire range has the desired attributes. */
 	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
-- 
2.47.1


