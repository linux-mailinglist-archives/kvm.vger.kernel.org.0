Return-Path: <kvm+bounces-48531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD4FACF2FD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75EAE172FF4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B4B1C5496;
	Thu,  5 Jun 2025 15:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K0DxcwWR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5791A8401
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137119; cv=none; b=YKp9qkqtjsJUh8TRMkQ/wycNdHQL+g4Skkvexa5UAy7lue+UI1p7fXWW/pOC+IYc/mKSpMb2GBOPxAs7LUP3fs3e1ctctjB2fbYTkzr4SiuR4+VsmmZfxFUl6wpToN57Fv84UuVAbk2UBhsdpyzz/bzyRN5VbM4BC8zyQaKDmaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137119; c=relaxed/simple;
	bh=Fj1QXzojtmc/Fj316hBE2HhvJnfxueNkP8hzn709ix8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We2OiMc59KW5EVwM41hR4Va+yJfERIhdLxLhcAdSvoGNjFkH53psGDK7ssNyl0qCdlcQeu/oJ3IcZMxNbFp0OKhBMEFxet1Pd7cIq8qD0Y5IhoNZ5/DTg+65srKZO9GGZqcVjB2FXYrFZGAkFuxFea81W+3qHQEg+IsIB6ZJfxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K0DxcwWR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtVbs001094;
	Thu, 5 Jun 2025 15:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Nqx/g
	rG7fAAfJogoyJhnMDOwlCfUS5mLajFAqWjjQuI=; b=K0DxcwWRJXCb66toIu7zE
	K6gw9vGaVW+Oup3yvJ6PjYpNK+ebC4K0u/4K+Ya0t9B79eqOjJU5fH00tUrRmlsz
	72GH01JansdsAENDZhk83wejJgHJ0oIa0+NgHBQc+Oe4J3q3Gpa0Ke9kSjG4qeTA
	lzWQlsDf0BMBBstvwmSZfd5TPUx46gYCSrB0DW3CVqryd7B1Ve8wbXQhvWNlfg49
	KgTwP8iUS7XpeI/UsMGP2j2tyMqQk5ZlKDPvgoyOy1y8mdrtYRt0WMBI0p+w5lkj
	aRkxzK5Y8QtDTW7RSQmSEcdJxf5F8/TSh/D6kfm01dHXfJNQdEuOIQd6HjEVrc9q
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8dxdqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555EhbYF039164;
	Thu, 5 Jun 2025 15:25:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c8byb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 555FP4m0016227;
	Thu, 5 Jun 2025 15:25:08 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46yr7c8bt3-4;
	Thu, 05 Jun 2025 15:25:08 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH 3/3] KVM: fix typo in kvm_vm_set_mem_attributes() comment
Date: Thu,  5 Jun 2025 15:25:02 +0000
Message-ID: <20250605152502.919385-4-liam.merwick@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=Va/3PEp9 c=1 sm=1 tr=0 ts=6841b6d6 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=z1lGUEqvtmmE0QunZHoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfX+8bJ2rlLQnpR ymED/dLb2up2fsPS60tWgWpsBi94qdK6/FV7TmHyzlK8UGNmvmlaBmhPxGQuLqDISscE8NXWdjV 4RkYkgBvVzJr5neIvDUjhFClR4jrGATyWs8kY47hXvsegIzoaS4UY7qj6XsOxN7ca8+CVikyWD0
 4sTj0Jq950EWr67uQNLAt9hkVfNfTkiMLXNO5rIKsLdXldbsBQAvLqEBtSmhkR41Z0jQ8gwQJwS PHLPX+q79yYkbxoUZoCVse81iUDAgm84x5nhWtTpyFnIqQ9oFzS121A9T7an0qadyW3u1IRCEfV nEqMK4frRkpTvpf9sHLVgZjNvzdknUJ8mAeUHB6kvdjhotKhvKUIiGaIlmZxm+9wplCKZGRHfTa
 7x43Brxs+xutxvaw71ZzFXi9FB3qm697OqO615Oj71ofHfdywQb00/XQ+8EQP1Y8q6A1MHNu
X-Proofpoint-ORIG-GUID: 9Tudwx1Cemd0OXn3FVdexYM_csE50_Ws
X-Proofpoint-GUID: 9Tudwx1Cemd0OXn3FVdexYM_csE50_Ws

It should be 'has' in the sentence and not 'as'.

Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 464357ea638c..be8cf9d5864d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2501,7 +2501,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	mutex_lock(&kvm->slots_lock);
 
-	/* Nothing to do if the entire range as the desired attributes. */
+	/* Nothing to do if the entire range has the desired attributes. */
 	if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
 		goto out_unlock;
 
-- 
2.47.1


