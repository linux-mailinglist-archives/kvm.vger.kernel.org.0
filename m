Return-Path: <kvm+bounces-50409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 082B9AE4D64
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181563A203D
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 19:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B962D4B7B;
	Mon, 23 Jun 2025 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fBWcktR8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CE92727FD;
	Mon, 23 Jun 2025 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750705950; cv=none; b=YkrIibZDRVZKmBl79SY+Y19kAl2fjEyBZU2TLxONR9Zld3q1vFJAT08Txxt7JOSakEKulC3dXrAcaAknOG/e8J+OkbM/fxJ2nFhBsbtcxno7JOxCgh+HgvHedTKfdPYLQzJ4365nPVRHIiWDM8LNzb8DMCQetgt1vmB3FnNAVmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750705950; c=relaxed/simple;
	bh=RdggrAt2yYgHrCd62EHlXKceXTIAXB4Ir7vZpqfo490=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mWfIOEIjHgtGRnPZjd/w6SiEvwC2va08e0r4B8S5Zq159HCEH3+qyD8HVBXPypuLNx4+XV2TSF2O5exVJg5f3GO1x8MVBEOxhj8K6SzTuEtpuP2lO2jo0Xn26YF7Di7NhfEq7Yrj1PqqzwU03POAma7m5eU8v9VP539T6dsjvHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fBWcktR8; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55NGXxxi001720;
	Mon, 23 Jun 2025 19:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=y98GQGHSKG5hc43qPhCGbhubyGowZ
	oek17bECxnnf40=; b=fBWcktR88KCuUdEcYAowh6PWNVi1A70oitpF7oz0kERyD
	s4KZtEe5fS6FroFsdaVdkzh2eMoHWEPKyDoWvrLnVJmNcTGuKF5Z7C+amPsuw2gY
	8ZSZJliZJj8ILHD27Xnkiuxmf8vN2SqSK4B8rzbMWa5GuXc13xn1rMr0IEOHhXjm
	4d7ze9jUiZRgNILjUNpb1b7IrltJX1L03ML25m0D2GdoZrxYnqO4x5KOqU7LVz6K
	dotiH6Bk8X+SlB28B5aehk6Qq1DDd55N54FEA7ufpLbctOQO0bdVJBrB18GEaUxt
	rzzLKHxTlaM3Rypa6K3jBm2uGcTQFjyijNELPRWNg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7uugf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 19:12:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55NIjeET038894;
	Mon, 23 Jun 2025 19:12:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47ehr3qwvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 19:12:22 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55NJBsPM037652;
	Mon, 23 Jun 2025 19:12:22 GMT
Received: from ca-dev110.us.oracle.com (ca-dev110.us.oracle.com [10.129.136.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 47ehr3qwvb-1;
	Mon, 23 Jun 2025 19:12:22 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH next] Documentation: KVM: fix reference for kvm_ppc_resize_hpt and various typos
Date: Mon, 23 Jun 2025 12:11:47 -0700
Message-ID: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_05,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506230123
X-Proofpoint-GUID: Wb1bCTVf9O-FdttwSNE3QwfcLxufiVJy
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=6859a718 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6IFa9wvqVegA:10 a=yPCof4ZbAAAA:8 a=zi7eKOD_ebcX24jqmWgA:9 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: Wb1bCTVf9O-FdttwSNE3QwfcLxufiVJy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDEyMyBTYWx0ZWRfX+OYpCfb891dj gmFNOkYZk4Mpntjg6yFrXqwhTmCt9voEZcI9YYkfRqfBJIyyCjEQeQso59aER7hwG03cjYeo1qm oSHXifj2FvSW/yIsvlYuLlsW+Fxdu73x84dE5w/jpCjo+WGAgIuaSzokFaDDkU1HqNxFt1dagU/
 f/7XOGuCdf9oGg/HE7FY25eTiTBwy8Akdh4FncX4fLb+k46kQ6Ru+WpwDCIEWIJ8u9a22U7ZBkG xbGLYtDwGuZJJQz82wHWnWAksRkMNsf61wgCkObqGfiF7b1OoUukD9rbc4yw/KJWsp8mxBwqCmF A1upSey9zSTpALroxxkuHwJv01Xsx/IhWVtR53EtY1vF7uewbf+xNbn1/XYVYo4APAgjpLXuNTJ
 9eIomI9Vx3qRZB2hljzdwBrgpXgFZ3Yeu3TnTBo/lI5kRgLv1DgEmebpIbmJ48iXJ/yUsjDS

Fix the incorrect reference to struct kvm_reinject_control and replace
it with the correct struct kvm_ppc_resize_hpt in the documentation of
the HPT resize ioctl.

Also correct several minor typos throughout api.rst, including grammar
issues, capitalization (e.g., "SError"), and punctuation fixes.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 Documentation/virt/kvm/api.rst | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0d961436d0f..04ac699e7885 100644
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
 
@@ -3215,8 +3215,8 @@ default-sized hash table (16 MB).
 
 If this ioctl is called when a hash table has already been allocated,
 with a different order from the existing hash table, the existing hash
-table will be freed and a new one allocated.  If this is ioctl is
-called when a hash table has already been allocated of the same order
+table will be freed and a new one allocated. If this ioctl is called
+when a hash table has already been allocated of the same order
 as specified, the kernel will clear out the existing hash table (zero
 all HPTEs).  In either case, if the guest is using the virtualized
 real-mode area (VRMA) facility, the kernel will re-create the VMRA
@@ -4427,7 +4427,7 @@ base 2 of the page size in the bottom 6 bits.
 :Returns: 0 on successful completion,
 	 >0 if a new HPT is being prepared, the value is an estimated
          number of milliseconds until preparation is complete,
-         -EFAULT if struct kvm_reinject_control cannot be read,
+         -EFAULT if struct kvm_ppc_resize_hpt cannot be read,
 	 -EINVAL if the supplied shift or flags are invalid,
 	 -ENOMEM if unable to allocate the new HPT,
 
@@ -4481,7 +4481,7 @@ ones will monitor preparation until it completes or fails.
 :Returns: 0 on successful completion,
          -EFAULT if struct kvm_reinject_control cannot be read,
 	 -EINVAL if the supplied shift or flags are invalid,
-	 -ENXIO is there is no pending HPT, or the pending HPT doesn't
+	 -ENXIO if there is no pending HPT, or the pending HPT doesn't
          have the requested size,
 	 -EBUSY if the pending HPT is not fully prepared,
 	 -ENOSPC if there was a hash collision when moving existing
@@ -8884,7 +8884,7 @@ This capability indicates that KVM supports steal time accounting.
 When steal time accounting is supported it may be enabled with
 architecture-specific interfaces.  This capability and the architecture-
 specific interfaces must be consistent, i.e. if one says the feature
-is supported, than the other should as well and vice versa.  For arm64
+is supported, then the other should as well and vice versa.  For arm64
 see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
 For x86 see Documentation/virt/kvm/x86/msr.rst "MSR_KVM_STEAL_TIME".
 
@@ -8924,7 +8924,7 @@ KVM_EXIT_X86_WRMSR exit notifications.
 
 :Architectures: x86
 
-This capability indicates that KVM supports that accesses to user defined MSRs
+This capability indicates that KVM supports accesses to user defined MSRs
 may be rejected. With this capability exposed, KVM exports new VM ioctl
 KVM_X86_SET_MSR_FILTER which user space can call to specify bitmaps of MSR
 ranges that KVM should deny access to.
-- 
2.46.0


