Return-Path: <kvm+bounces-34791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CEDEA05FFB
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2233A60BC
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3F31FECAA;
	Wed,  8 Jan 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X1Pv4Cqf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F041A9B34;
	Wed,  8 Jan 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349839; cv=none; b=KXJ6TOF7c2oY0BFGN0WCbGZuLsVZ6PStbVZ9yAxbi5gyEVU7ESyS8TDwPdGvqBMcOwSrgHHC59lHtrRmOOYjdf/QV0JWvR8dZe8Hmq93g4Yln8sp0YXX3ZvF+t7jirefQpqjzZF+DMmnanKrztPJ94fhACEn3tYSUD7MxFsEX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349839; c=relaxed/simple;
	bh=iMUxerrqrfkVUUYtVgzMh2ctb6A9pRjnY4+sArm+b+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SD2bvcdzU9OxwDvaK1JIyO/stbqCY/phu8ovzzADYeV2ASUNgYttjGutc9N76bjLzd0CdP/8Lq8uITzpRoROuTddr2omwD4dvveR6ROCyqjCzfsJc3FtHUd8SkSCWkkZrNP/eG4h0/KadcyTTItV/0DbFnSlzPnYBWk9Llh5rDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X1Pv4Cqf; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508E6leV001175;
	Wed, 8 Jan 2025 15:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pSH+w9+M5hyayJq+I
	u250hklFRz744r/hnqui2FvNlw=; b=X1Pv4CqfLAt0qHrsozB6sRmxnet8DAHuF
	Cn4CF2c8+W9mBPYwEQkEQyhhzqmp5yNNLCptb0NVwhnkyoXp18/fNB+v7zKS/Osv
	ECHFoOcpIg94BfbUadavYekWO1zYhlqINpwsSH0Vt8hr/TRNHxX9oZC/z3w33EGZ
	1uwXP8MuuUmKMb9vdm2z2Hk5l3iqMBBdm5p3FGskwLCIpACWQuSAFti+rn/Yo0Y1
	83S22HGd/BFpKZvxo6TrRxO35Ks5ay3Ok1Xqo/9bdjkD9zra2enBo9XAxGIQQH4q
	WwUjdpPrmxPr7VFNzV9nkwQ3oxTy1uvhpLPtuaGFYhdD7w+BRuC8Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441tu5gbqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508DYMch015798;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm083g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNp8p32244408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4758A20043;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 280C720040;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:51 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 4/6] KVM: s390: Reject KVM_SET_GSI_ROUTING on ucontrol VMs
Date: Wed,  8 Jan 2025 16:23:48 +0100
Message-ID: <20250108152350.48892-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108152350.48892-1-imbrenda@linux.ibm.com>
References: <20250108152350.48892-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XCzX4Ypf_rVSFJyEMP6rBDnUTE8FaFhb
X-Proofpoint-ORIG-GUID: XCzX4Ypf_rVSFJyEMP6rBDnUTE8FaFhb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=674 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Prevent null pointer dereference when processing
KVM_IRQ_ROUTING_S390_ADAPTER routing entries.
The ioctl cannot be processed for ucontrol VMs.

Fixes: f65470661f36 ("KVM: s390/interrupt: do not pin adapter interrupt pages")
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Tested-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241216092140.329196-4-schlameuss@linux.ibm.com
Message-ID: <20241216092140.329196-4-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 3 +++
 arch/s390/kvm/interrupt.c      | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..f15b61317aad 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1914,6 +1914,9 @@ No flags are specified so far, the corresponding field must be set to zero.
   #define KVM_IRQ_ROUTING_HV_SINT 4
   #define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
+On s390, adding a KVM_IRQ_ROUTING_S390_ADAPTER is rejected on ucontrol VMs with
+error -EINVAL.
+
 flags:
 
 - KVM_MSI_VALID_DEVID: used along with KVM_IRQ_ROUTING_MSI routing entry
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 22d73c13e555..d4f031e086fc 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2898,6 +2898,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	switch (ue->type) {
 	/* we store the userspace addresses instead of the guest addresses */
 	case KVM_IRQ_ROUTING_S390_ADAPTER:
+		if (kvm_is_ucontrol(kvm))
+			return -EINVAL;
 		e->set = set_adapter_int;
 		uaddr =  gmap_translate(kvm->arch.gmap, ue->u.adapter.summary_addr);
 		if (uaddr == -EFAULT)
-- 
2.47.1


