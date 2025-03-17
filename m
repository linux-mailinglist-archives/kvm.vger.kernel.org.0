Return-Path: <kvm+bounces-41327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27D4A6631E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D853B6BFE
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 23:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E3120AF80;
	Mon, 17 Mar 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ao92b092"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CD920967B;
	Mon, 17 Mar 2025 23:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742255523; cv=none; b=XQlqMzn8Yfqs1nvr6eF8ayfyHMvxYN9anG8LjPYg/jS7rdHv2arJ+gtR4R2XhpCdUxhuUWdqtNNDA5ZNI/IiS7JGXll6Op/vnAE/AelDU6a0hLe7n3S8Qn7WV3EuYcaBqfkZMrbX0V/M28vIkbjsyunPQ9zEiz6nq3B4HQuCJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742255523; c=relaxed/simple;
	bh=fwr8OqvAlKugsufZvHpZOeNEgA7dt65mCk1pC0dH1Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfV4dXi6wBEdWxZ3oQko4gyQNTBvZv0LIk2c8jEf1Y2qaQ65Q34/VBYop4yzdbTmE8YIPp0SaELSSlbBAhbHQcv0u6UokkxdOzMqL3Up6FMNN+QiMOMYN/hGKWbZH04xkngCx0EkQMBpBBtKJZaSgcE3msuMm+QRBNVkc/21Jxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ao92b092; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLujE1010125;
	Mon, 17 Mar 2025 23:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=3NjNL
	hMvEyqe/yXAgspbGPylieUE1KvOmQHbOi6+uLk=; b=ao92b092p15JtWACWjBxV
	LcG7KRjCWri3p3HhGkjF3W42QX4/XTba7EvF+oRHi9J/B3JPyRAwEmMc6nk1ixra
	ioQUrr+f2Nx4Lc2l1FCG5qKfI3YF/5IxOcAwAl+lNznfMw3APnCSR4dsRWXDBEqM
	U+q3o8Km6EgwkCx0Hu8XDO9HYGcDagsPH4ISnmtSLUtkUPtjG7xqAgl220tB8EWk
	6/Ixa2YXWq+tEiBVR3HYdnWBdUm2g+1vpcM/FQ2SXQkui+/2cqoNIwLTqMQ7DePS
	xYF9rrZfaF8PpRq82H2sim08r0CIxLBPM49WFVPy2LYjNu5ZkbgsNF2sGzN2i4v3
	g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8m4g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLLhQY023004;
	Mon, 17 Mar 2025 23:51:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeekfc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 23:51:52 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52HNpi31016519;
	Mon, 17 Mar 2025 23:51:52 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeekf68-11;
	Mon, 17 Mar 2025 23:51:52 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] vhost: add WARNING if log_num is more than limit
Date: Mon, 17 Mar 2025 16:55:18 -0700
Message-ID: <20250317235546.4546-11-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250317235546.4546-1-dongli.zhang@oracle.com>
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503170173
X-Proofpoint-ORIG-GUID: WaqfLMnVAkuUIrEbUQJA3WCXU5PRamji
X-Proofpoint-GUID: WaqfLMnVAkuUIrEbUQJA3WCXU5PRamji

Since long time ago, the only user of vq->log is vhost-net. The concern is
to add support for more devices (i.e. vhost-scsi or vsock) may reveals
unknown issue in the vhost API. Add a WARNING.

Suggested-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/vhost/vhost.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index db3b30aba940..8368370b40f7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2553,6 +2553,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
 		if (access == VHOST_ACCESS_WO) {
 			*in_num += ret;
 			if (unlikely(log && ret)) {
+				/*
+				 * Since long time ago, the only user of
+				 * vq->log is vhost-net. The concern is to
+				 * add support for more devices (i.e.
+				 * vhost-scsi or vsock) may reveals unknown
+				 * issue in the vhost API. Add a WARNING.
+				 */
+				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
+
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
@@ -2673,6 +2682,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			 * increment that count. */
 			*in_num += ret;
 			if (unlikely(log && ret)) {
+				/*
+				 * Since long time ago, the only user of
+				 * vq->log is vhost-net. The concern is to
+				 * add support for more devices (i.e.
+				 * vhost-scsi or vsock) may reveals unknown
+				 * issue in the vhost API. Add a WARNING.
+				 */
+				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
+
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
-- 
2.39.3


