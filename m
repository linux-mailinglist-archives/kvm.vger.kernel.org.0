Return-Path: <kvm+bounces-55575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1539B32E11
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 09:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCE50482A30
	for <lists+kvm@lfdr.de>; Sun, 24 Aug 2025 07:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788082528EF;
	Sun, 24 Aug 2025 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wzr7G/H8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054EE246779;
	Sun, 24 Aug 2025 07:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756022140; cv=none; b=dgRJvaT3K3C0P1YuC4T3/EoyJLaTS0RQoKLH7njHccGABGAJeREkBTjaggm51oVpsQk4ZI6zdewi/Xgpj/LyH7vPqs+qI/6vcTWPp5qFiLuw2ElaXwuOhBfEjxj8W9s5aaiD+Jmqt0uh+8IbRAKubgQs3aSN9k1XehowBQB9Sak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756022140; c=relaxed/simple;
	bh=HkOwPrnpT35Y+SygLffQ1fNvcHF3cTPZvHTC0IEJSgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bq2+cAu4j1PQgqtbyFyIjpCnHHcMPOqbWwrvf1XJ9G/XbDXG2JMaC0X0TbT2vq4d4M/fbRKAiZ9Fmqzu7NlJJydsQSfPviapMS7m9+DKGlmWd2HsJpB6HQlw3lewvYCsJq3+LavbVXtQdOonwICg1NUYQY4d1wdDQksMcl3kjm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wzr7G/H8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57O7SOGQ031274;
	Sun, 24 Aug 2025 07:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=uYFiLZpnFBJ3JfM/i2bkB8bD0x2ex
	s7tUASSBQUSHtg=; b=Wzr7G/H8ru62O7TJAniWTJAshR4YTqnSPx8OoPsouANOO
	dCp0E6K9C4XgJfLxvpls2tmZZgBuICnDKAZFLalozWuw/cWaPFdCGKgGen6nDUIH
	3sf2+0nbSbCVkn4ZTFYEc1aHTdNY1AEZw3XCyjS3uj7ntlw7UqrlkUZ5mmF4v92K
	tlPFwAZCEK/xQWH60WOWBGsq0X43cLq072E1VkIc0nsHFcRtwXNOhufAZbQR8oI0
	BSv760l1oOXLhPGfwMeEBrwR2a5SvrOaQ+wKMjZgOJGx4ckjBqCXRwgaLqhit9H2
	45h5RXYBYDQ+QU8GDGCNo02hbv3Vm82lq4/hL98hQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48qjv2ravr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 24 Aug 2025 07:55:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57O5AGS7014743;
	Sun, 24 Aug 2025 07:55:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q4373rrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 24 Aug 2025 07:55:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57O7tUE5012602;
	Sun, 24 Aug 2025 07:55:30 GMT
Received: from ca-dev110.us.oracle.com (ca-dev110.us.oracle.com [10.129.136.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q4373rpb-1;
	Sun, 24 Aug 2025 07:55:30 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, rdunlap@infradead.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: KVM: fix reference for kvm_ppc_resize_hpt and various typos
Date: Sun, 24 Aug 2025 00:54:48 -0700
Message-ID: <20250824075455.602185-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-24_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508240075
X-Authority-Analysis: v=2.4 cv=Rp/FLDmK c=1 sm=1 tr=0 ts=68aac574 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=oA-75tQ_D-ToXw_PklIA:9 cc=ntf
 awl=host:13600
X-Proofpoint-ORIG-GUID: Q8packPhZK1We2etAZb4frkiMpQ2a53F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDE4MiBTYWx0ZWRfXzBjy5tcMqmbw
 BaDdrW1gY7OXk67Xf1cmXyFklJvaR+1kgONfHrJf5w39bNHBS0mdi7oXkxRT1nvc0XmsGK37TzX
 gL9ds4ltfpjLPntVA7/L2mLElgtrbOx1qznlb6dsy2K62Gr9bX1S7Px7oZcFdsDHvuS891j3HSl
 FmJ30wFq/eDhQ9Z+g7zPgauNuq55bI6uk3N0Ywjs6uxoyw1IrsqYyGeFvI+J4BGixmEU0bOH7Ov
 tFHRamsof3cISVPP8Terc4SxCq3V520t01rLVJszUf6XiKu1n3xxwmAaSoO1931MNc1VPJrcYTO
 GZ6IxoYUT26yhD+ZBSV239VQm0G1MH6Y0ZwZpWlvNCtsumVzElE6vqRNkeD7PZ5B6J3NijQXdmx
 6Q0/npNQMT7g5J0pIp/EfoCYrKfIBg==
X-Proofpoint-GUID: Q8packPhZK1We2etAZb4frkiMpQ2a53F

Fix the incorrect reference to struct kvm_reinject_control and replace
it with the correct struct kvm_ppc_resize_hpt in the documentation of
the HPT resize ioctl.

Additional cleanups:
- Fix "change" -> "changes", "VPCU" -> "VCPU", "Serror" -> "SError"
- Fix punctuation issues (missing brackets in CPUID leaf reference).
- Remove duplicated words ("this is ioctl").
- Correct structure names in error descriptions (kvm_reinject_control ->
kvm_ppc_resize_hpt).
- Fix grammar ("than" -> "then", "is there" -> "if there").

These changes improve clarity and accuracy of the KVM API documentation.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 Documentation/virt/kvm/api.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4ae..22542ceaf5718 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -88,7 +88,7 @@ the VM is shut down.
 =============
 
 As of Linux 2.6.22, the KVM ABI has been stabilized: no backward
-incompatible change are allowed.  However, there is an extension
+incompatible changes are allowed.  However, there is an extension
 facility that allows backward-compatible extensions to the API to be
 queried and used.
 
@@ -1198,7 +1198,7 @@ pending until the guest takes the exception by unmasking PSTATE.A.
 
 Running the VCPU may cause it to take a pending SError, or make an access that
 causes an SError to become pending. The event's description is only valid while
-the VPCU is not running.
+the VCPU is not running.
 
 This API provides a way to read and write the pending 'event' state that is not
 visible to the guest. To save, restore or migrate a VCPU the struct representing
@@ -1293,7 +1293,7 @@ ARM64:
 User space may need to inject several types of events to the guest.
 
 Set the pending SError exception state for this VCPU. It is not possible to
-'cancel' an Serror that has been made pending.
+'cancel' an SError that has been made pending.
 
 If the guest performed an access to I/O memory which could not be handled by
 userspace, for example because of missing instruction syndrome decode
@@ -1832,7 +1832,7 @@ emulate them efficiently. The fields in each entry are defined as follows:
          the values returned by the cpuid instruction for
          this function/index combination
 
-x2APIC (CPUID leaf 1, ecx[21) and TSC deadline timer (CPUID leaf 1, ecx[24])
+x2APIC (CPUID leaf 1, ecx[21]) and TSC deadline timer (CPUID leaf 1, ecx[24])
 may be returned as true, but they depend on KVM_CREATE_IRQCHIP for in-kernel
 emulation of the local APIC.  TSC deadline timer support is also reported via::
 
@@ -3222,8 +3222,8 @@ default-sized hash table (16 MB).
 
 If this ioctl is called when a hash table has already been allocated,
 with a different order from the existing hash table, the existing hash
-table will be freed and a new one allocated.  If this is ioctl is
-called when a hash table has already been allocated of the same order
+table will be freed and a new one allocated.  If this ioctl is called
+when a hash table has already been allocated of the same order
 as specified, the kernel will clear out the existing hash table (zero
 all HPTEs).  In either case, if the guest is using the virtualized
 real-mode area (VRMA) facility, the kernel will re-create the VMRA
@@ -4434,7 +4434,7 @@ base 2 of the page size in the bottom 6 bits.
 :Returns: 0 on successful completion,
 	 >0 if a new HPT is being prepared, the value is an estimated
          number of milliseconds until preparation is complete,
-         -EFAULT if struct kvm_reinject_control cannot be read,
+         -EFAULT if struct kvm_ppc_resize_hpt cannot be read,
 	 -EINVAL if the supplied shift or flags are invalid,
 	 -ENOMEM if unable to allocate the new HPT,
 
@@ -4488,7 +4488,7 @@ ones will monitor preparation until it completes or fails.
 :Returns: 0 on successful completion,
          -EFAULT if struct kvm_reinject_control cannot be read,
 	 -EINVAL if the supplied shift or flags are invalid,
-	 -ENXIO is there is no pending HPT, or the pending HPT doesn't
+	 -ENXIO if there is no pending HPT, or the pending HPT doesn't
          have the requested size,
 	 -EBUSY if the pending HPT is not fully prepared,
 	 -ENOSPC if there was a hash collision when moving existing
@@ -8925,7 +8925,7 @@ This capability indicates that KVM supports steal time accounting.
 When steal time accounting is supported it may be enabled with
 architecture-specific interfaces.  This capability and the architecture-
 specific interfaces must be consistent, i.e. if one says the feature
-is supported, than the other should as well and vice versa.  For arm64
+is supported, then the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
 For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
 
-- 
2.50.1


