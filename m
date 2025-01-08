Return-Path: <kvm+bounces-34795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE00A06002
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D96E1667C0
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C8C1FF1B3;
	Wed,  8 Jan 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ln41+ynh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A4919F133;
	Wed,  8 Jan 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349841; cv=none; b=aIO+tTNRdwt1uWmyYg4EqbVehU7Y5U2sKXCABkoJosPm+7mKp257mBUfuOwpheKVi+iiBijYXo7tVQ7te0/oryyCRlwHBVs9fETeYr6WaQ0ZhAs5lazXPVWnOOcPZnbGcTXLGLBhbTQ323EVseBqQq6WO77PBrdJtxuU+78u3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349841; c=relaxed/simple;
	bh=5wp1aejWz947W7fFRNs9ANTt78EoV8JSKa9kIdIqSHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+SBCZo4LAMAptNDx1n6Q7pbLPWkX0l+W8Naz3+ErB340jl9HOEAqDEQqSHTpjiVvcPTTjJxiJyAvakmJiWfGO5Fz8bazUe5tEij+/ipwJRuX2L1fT3aDothJLoZB8+qJHNP9lFOafq/uwjUlzVz+iEEy+/47i36J/qIM0NLlfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ln41+ynh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508CnMB0023475;
	Wed, 8 Jan 2025 15:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DegW+32bwHLf85W2I
	Apu45vvASOxXf1swwsJVojmsrU=; b=ln41+ynhcYhTNJJsXc/Ck5XEgbanczqqF
	xmqpAWdiuU+reoXJaTJKJrUR214+oTmbmF4kns9oxmDFZaCaHnvI2unNrguwwFfE
	U+r9bd8Mf6dDeQDRtIE60wbtLMAHyqURLjXT4DjJ0U+u3VLfjX4131EtpJ4Zry40
	G/m3O/gsVaIfhYLSF/g2iN75EYOuLLJCmWS41zW5oYLFFNJQ381KoUEbt4HHKQWm
	wJQyNvCWEwqLEEZ2yaDPCXXk8LFlRIk9fEgg1kJqpzspYplba51J6VoJ3mB4pg3i
	AkHEZKBRn+RK8GtyDCO9JGVfv6M0PGzqevNZmAuJyvDDbhPss6Bxw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441edj3qq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:56 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508D0Rgr008869;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq00fkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNpEY35652106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:51 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F27AF2004F;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D43742004E;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 2/6] KVM: s390: Reject setting flic pfault attributes on ucontrol VMs
Date: Wed,  8 Jan 2025 16:23:46 +0100
Message-ID: <20250108152350.48892-3-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: EwCI1w-9nd05jqQmGCc8GPfgXjo-F4CL
X-Proofpoint-ORIG-GUID: EwCI1w-9nd05jqQmGCc8GPfgXjo-F4CL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=734 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080125

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Prevent null pointer dereference when processing the
KVM_DEV_FLIC_APF_ENABLE and KVM_DEV_FLIC_APF_DISABLE_WAIT ioctls in the
interrupt controller.

Fixes: 3c038e6be0e2 ("KVM: async_pf: Async page fault support on s390")
Reported-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Hariharan Mari <hari55@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20241216092140.329196-2-schlameuss@linux.ibm.com
Message-ID: <20241216092140.329196-2-schlameuss@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/devices/s390_flic.rst | 4 ++++
 arch/s390/kvm/interrupt.c                    | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/virt/kvm/devices/s390_flic.rst b/Documentation/virt/kvm/devices/s390_flic.rst
index ea96559ba501..b784f8016748 100644
--- a/Documentation/virt/kvm/devices/s390_flic.rst
+++ b/Documentation/virt/kvm/devices/s390_flic.rst
@@ -58,11 +58,15 @@ Groups:
     Enables async page faults for the guest. So in case of a major page fault
     the host is allowed to handle this async and continues the guest.
 
+    -EINVAL is returned when called on the FLIC of a ucontrol VM.
+
   KVM_DEV_FLIC_APF_DISABLE_WAIT
     Disables async page faults for the guest and waits until already pending
     async page faults are done. This is necessary to trigger a completion interrupt
     for every init interrupt before migrating the interrupt list.
 
+    -EINVAL is returned when called on the FLIC of a ucontrol VM.
+
   KVM_DEV_FLIC_ADAPTER_REGISTER
     Register an I/O adapter interrupt source. Takes a kvm_s390_io_adapter
     describing the adapter to register::
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ea8dce299954..22d73c13e555 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2678,9 +2678,13 @@ static int flic_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		kvm_s390_clear_float_irqs(dev->kvm);
 		break;
 	case KVM_DEV_FLIC_APF_ENABLE:
+		if (kvm_is_ucontrol(dev->kvm))
+			return -EINVAL;
 		dev->kvm->arch.gmap->pfault_enabled = 1;
 		break;
 	case KVM_DEV_FLIC_APF_DISABLE_WAIT:
+		if (kvm_is_ucontrol(dev->kvm))
+			return -EINVAL;
 		dev->kvm->arch.gmap->pfault_enabled = 0;
 		/*
 		 * Make sure no async faults are in transition when
-- 
2.47.1


