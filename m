Return-Path: <kvm+bounces-68248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B028D28715
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E9B23015015
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C308B322C8A;
	Thu, 15 Jan 2026 20:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XjqpCsa6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C131A551;
	Thu, 15 Jan 2026 20:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509445; cv=none; b=tPCrXqJp4MnOZgugt/1ux7O9/5BYPIrMt+4ZbAQojS3+p6xHEgDCVEMS7DzEw5vW13ZKN6fecB5asvqsWETLuQKi/nksSQWp77Y6/5Jez3MDz3QFCjscF9unxDDt5SfyMce0YccVmoRP7llTI/WCKCo1Niz/8z+p5SntXXBiVno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509445; c=relaxed/simple;
	bh=lc3f7DV9sc+W17mcjj6+m4I3HVHtr1i4kaGQk8ODWQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W85KPjygSArQD/s8cH61AVuHKY0CHoY6T9u5IQmkMb4TWcbgEwgk6bGjNBgpUSbjLENabbzdbgbjkQoOBG3UqqqchLXhwN2Aemw5f1nWJsEKofbaXPrrJikNINuPi4543hb662kBrXpw3zVsNVZP43alW6D8Xk9JJHoyXB26kF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XjqpCsa6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FHiSR81295896;
	Thu, 15 Jan 2026 20:36:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=QC/91
	MSBOB2DNGOWstwT0cbVUA1uplJlunnyCp736ZU=; b=XjqpCsa6CcVIuhty6O8tM
	YYXFqjkHIzsHjZI4DPlg+iATeCKQrEgh4modbndq17zwlDTaMBb6AXfDrOeUdW+N
	CPVIOyR39KSHevs2izTZWhRZ3LW3UNfxVEvxptsHfXgEnUeCYplsRS8RmWGqlIaT
	qYs6qFtSVSc93NSPmNWE08GryVnevqIf5uRGvvUsOsVZsm1uWcEaMwYVS8BlE3Hu
	uvPWQ9Zw/X2p6KiOk1sXFX8KT7EfHcqBzpSx4HN0Stfyw119j42qSaemSDNQyBQd
	JeOiyjo2KVE5V6jtQD2eG6v+Kk9vOiGACEmxjODY2TnfaWWt42pwTzJIIh62nCsM
	Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3wu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJP62d035258;
	Thu, 15 Jan 2026 20:36:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bsw4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60FKXKQT010408;
	Thu, 15 Jan 2026 20:36:02 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7bsw14-4;
	Thu, 15 Jan 2026 20:36:02 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dwmw2@infradead.org,
        dwmw@amazon.co.uk, paul@xen.org, tglx@kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        dongli.zhang@oracle.com
Subject: [PATCH 3/3] KVM: x86: conditionally update masterclock data in pvclock_update_vm_gtod_copy()
Date: Thu, 15 Jan 2026 12:22:31 -0800
Message-ID: <20260115202256.119820-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260115202256.119820-1-dongli.zhang@oracle.com>
References: <20260115202256.119820-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150161
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=69694fb3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pBOR-ozoAAAA:8 a=yPCof4ZbAAAA:8
 a=szI7cAD4plzaKaVT9zkA:9
X-Proofpoint-GUID: lMbUBmmtxeRRS-rQ2u2vt4KodpoM0GnS
X-Proofpoint-ORIG-GUID: lMbUBmmtxeRRS-rQ2u2vt4KodpoM0GnS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MSBTYWx0ZWRfXz5vQN6j0l/4F
 9fZTIv+q7Kun7e6XAhYBBv3fluO2RNorEaQ1QbqZUZZpm2Bo5JFH1ACljkI4NnoyjrwAWXRy/pZ
 n4RqbDG5L6JEtv8Di63PrIEM3AccI1uHLOixj4Yo1RF3/3QChLzS5AzkhAqYCY7FkYF/M2yDAfU
 qy7UvhYdsfMVnScC5SYwQHdLf92gD8svgV78vqkTxmHZsb5qrrEJBUXAD5XMNkzkDEAyUFVXtju
 dlkJRBNbUOeTtuz7NMxr3yy0tPojsuEBWukovsWTM/QMKwBULkdQjfwJZTtRzMdeWtRePc1wBIR
 G9RtsJSzLw8OA0rMskptIdpAtQCILrhFfTod0R5cQ6G938kbWMlBHzs7bYB+MePQXk9fP3PVETP
 pOv1xPFSv+bi30D/l4iKc9dwGeKQfV2alM992fiMQuZkQZRN75gIHTs1VGKwMr749S2LbwnEQd5
 fKKSSGwIx/QSlgezvUg==

The pvclock_update_vm_gtod_copy() function always unconditionally updates
ka->master_kernel_ns and ka->master_cycle_now whenever a
KVM_REQ_MASTERCLOCK_UPDATE occurs. Unfortunately, each masterclock update
increases the risk of kvm-clock drift.

If pvclock_update_vm_gtod_copy() is not called from
vcpu_enter_guest()-->kvm_update_masterclock(), we keep the existing
workflow. The argument 'forced' is introduced to tell where it is from.

Otherwise, we avoid updating the masterclock if it is already
active and will remain active. In such cases, updating the masterclock
data is not beneficial and can instead lead to kvm-clock drift.

As a result, this patch minimizes the chance of unnecessary masterclock
data updates to avoid kvm-clock drift.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/x86.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0599949a7803..d2ce696abf55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3108,12 +3108,15 @@ static bool kvm_get_walltime_and_clockread(struct timespec64 *ts,
  *
  */
 
-static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
+static void pvclock_update_vm_gtod_copy(struct kvm *kvm, bool forced)
 {
 #ifdef CONFIG_X86_64
 	struct kvm_arch *ka = &kvm->arch;
 	int vclock_mode;
 	bool host_tsc_clocksource, vcpus_matched;
+	bool use_master_clock;
+	u64 master_kernel_ns;
+	u64 master_cycle_now;
 
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
@@ -3124,12 +3127,26 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 	 * to the guest.
 	 */
 	host_tsc_clocksource = kvm_get_time_and_clockread(
-					&ka->master_kernel_ns,
-					&ka->master_cycle_now);
+					&master_kernel_ns,
+					&master_cycle_now);
+
+	use_master_clock = host_tsc_clocksource && vcpus_matched
+			    && !ka->backwards_tsc_observed
+			    && !ka->boot_vcpu_runs_old_kvmclock;
+
+	/*
+	 * Always update masterclock data unconditionally if not for
+	 * KVM_REQ_MASTERCLOCK_UPDATE request.
+	 *
+	 * Otherwise, do not update masterclock data if it is already
+	 * active and will remain active.
+	 */
+	if (forced || !(use_master_clock && ka->use_master_clock)) {
+		ka->master_kernel_ns = master_kernel_ns;
+		ka->master_cycle_now = master_cycle_now;
+	}
 
-	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
-				&& !ka->backwards_tsc_observed
-				&& !ka->boot_vcpu_runs_old_kvmclock;
+	ka->use_master_clock = use_master_clock;
 
 	if (ka->use_master_clock)
 		atomic_set(&kvm_guest_has_master_clock, 1);
@@ -3179,7 +3196,7 @@ static void kvm_update_masterclock(struct kvm *kvm)
 {
 	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
-	pvclock_update_vm_gtod_copy(kvm);
+	pvclock_update_vm_gtod_copy(kvm, false);
 	kvm_end_pvclock_update(kvm);
 }
 
@@ -7189,7 +7206,7 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 
 	kvm_hv_request_tsc_page_update(kvm);
 	kvm_start_pvclock_update(kvm);
-	pvclock_update_vm_gtod_copy(kvm);
+	pvclock_update_vm_gtod_copy(kvm, true);
 
 	/*
 	 * This pairs with kvm_guest_time_update(): when masterclock is
@@ -9773,7 +9790,7 @@ static void kvm_hyperv_tsc_notifier(void)
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		__kvm_start_pvclock_update(kvm);
-		pvclock_update_vm_gtod_copy(kvm);
+		pvclock_update_vm_gtod_copy(kvm, true);
 		kvm_end_pvclock_update(kvm);
 	}
 
@@ -13206,7 +13223,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	pvclock_update_vm_gtod_copy(kvm);
+	pvclock_update_vm_gtod_copy(kvm, true);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
-- 
2.39.3


