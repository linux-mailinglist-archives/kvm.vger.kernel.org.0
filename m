Return-Path: <kvm+bounces-20617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C180B91AEB0
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 20:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A6E21F226B2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 18:04:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C305A19AA53;
	Thu, 27 Jun 2024 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RV3ccAhz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC43718040;
	Thu, 27 Jun 2024 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719511448; cv=none; b=K4LVqU/h1srF+Yz+3HzrymrXOkK/SpHitLgCTpqotI2ysp/8TYR2v9yD/BDzJKNVYhQodbkVkmlgnz9alL24yqKPQQ94ecFWBNHYV57CmOI78GKj0YH+RotldBhEhTYp0p2TkVcuxiCgSoTSOqXo8TdeKJdLqS7+xLUDdAuhpCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719511448; c=relaxed/simple;
	bh=i5IyIMea/IEEE5QY53xB+//vUtELV1fsEJ3/cqqg7eI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s8Kl6kjzHGgGfEDiJERFGB3762jWRJRiQ+Uf+1iTLG7tXE1t+zUXmWXxbqp7kwwM+NPd4jTTjAoxtB1TRyQFdUfU8SG1czxijJXjZaPeJKYR8lRvJuvmwpK0nlZVbgKwanFrcTjUNAg8E+Mkk9So5iPIjBttLDYgboJSyCZt0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RV3ccAhz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RHkMol009023;
	Thu, 27 Jun 2024 18:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=v+WEvBRLas2ArOOC4enxr7YC3w
	vbzqILQqAiQmn1e4Y=; b=RV3ccAhzMlYN36wxot9wd3njnj3kqvN3jdvnNz8fjs
	133ndvgLfWVXBOReofYVrbK70Xax2FItZy5UKFbGHBu+8tvETUfEAtnEyGr40ZV6
	3znZjqk0Ua2Ijr9qzsvmDd4rFBC0ScHOAbFjdWVqnnck/89vyMh4z60kXcI83YSC
	IhxjPhzwYGD//o32zxu9WDisi6NHB/g3G0Kp1y2W5XksvlZ/F/wQAHeT9aWndK59
	7WUssI3+8+KPrCW7olWNAvB36T+dyjPc3LZvAI7V1cR1zBnfGQ6F+p8XHFGeJeQ4
	9EMIfNHvE+f2BHGWs+hy2UG//0KykHFgNSimU0Jk7YTg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401aaf0f4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:54 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RI3sXY002995;
	Thu, 27 Jun 2024 18:03:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401aaf0f46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RHaiJv018115;
	Thu, 27 Jun 2024 18:03:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xumakq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 18:03:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RI3ldK41287952
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 18:03:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A63172004B;
	Thu, 27 Jun 2024 18:03:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B33E120040;
	Thu, 27 Jun 2024 18:03:45 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com.com (unknown [9.43.107.18])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 18:03:45 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Fix doorbell emulation for nested KVM guests in V1 API
Date: Thu, 27 Jun 2024 23:33:34 +0530
Message-ID: <20240627180342.110238-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rpiGQc0FhiqDD1tr2Kn0MpPZqea5JeBC
X-Proofpoint-GUID: IwfwpZLI6IeHGF2MaR_GGO7hf8sJMYKt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_13,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=536 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270132

Doorbell emulation for nested KVM guests in V1 API is broken because of
2 reasons:
1. L0 presenting H_EMUL_ASSIST to L1 instead of H_FAC_UNAVAIL
2. Broken plumbing for passing around doorbell state.

Fix the trap passed to L1 and the plumbing for maintaining doorbell
state.

Gautam Menghani (2):
  Revert "KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1"
  arch/powerpc/kvm: Fix doorbells for nested KVM guests on PowerNV

 arch/powerpc/kvm/book3s_hv.c        | 40 ++++++++---------------------
 arch/powerpc/kvm/book3s_hv_nested.c | 20 ++++++++++++---
 2 files changed, 26 insertions(+), 34 deletions(-)

-- 
2.45.1


