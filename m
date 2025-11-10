Return-Path: <kvm+bounces-62488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 250B3C45186
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 07:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F04F04E6964
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 06:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7AE2E92C3;
	Mon, 10 Nov 2025 06:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k+knjV4Z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC11E9B3A;
	Mon, 10 Nov 2025 06:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762756599; cv=none; b=F5HMc5qP7TloAn+TriMIppHvENO5Aj0w44fXKaflEN2ZZ/833F2ju7hqGfYSAzzTW5wL4t71Cl5zBs7wsFPfNRMgCgZHNkXW8GyUh0ZkuuGBIE6k/Yak7V7kn1zaIVjb6nZSDFrX3NACGYwhCIQ8hm4l+IFKpf+APbGj1UT0dpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762756599; c=relaxed/simple;
	bh=BF8AGVxjXagG8CDMrjpmpEX5NBU+aG0VlGTv+qVDQSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YWwHwSIIQkF+EF01B3M8javse13rh+8xB9nezLpQVT72kcZD6vJjpJWWvt9sYTweMxFoHcllv1zq3xtcYJsnY1NRPyx8g/gksWCTpmjNvjDEcx2Gm5BzA4LWuxktUpK1i/6ZtltlKvJDLpSg3lLOBDa0g7ZlIBdC2wPJB7Uazko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k+knjV4Z; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA6ICtp016040;
	Mon, 10 Nov 2025 06:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=qB2gRdRWWZQuS6hhGI2svmpQs+w3S
	U/Fedj5Ew0g5GE=; b=k+knjV4ZimGjYJErcgfz/eTgRSXLKzwMd5BpM2PtHOj/j
	nlJZ7qMHp81p/ypiJuP433s4MvC5EnsKXIrGrrjKsLmZElGVzdANLygkLWzS0Ld6
	V4epB2Bb8emM+nx2+p92BTG4QM7ZxP+0s9etw/V3yEPQDyJBLkNSvySWlwk27bWG
	7QvAL1r5XQih0S/eejE4d6Pt1Fp22Yb7YY71Hz7lIpI2avn1jRqKzRZOGpp50ju9
	20HcdX6qm0478f495gmzHPkuP6vl/CXQjCgx7noyGCUfSjaXrd+PSF3zhDnNsHWi
	I7ZBQM7JeK3h3RnyNZXUqgmp8k1h+ZWDxVu5FwnmQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ab899080x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 06:36:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA51PAV020907;
	Mon, 10 Nov 2025 06:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va7qxpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 06:36:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AA6a7nE027536;
	Mon, 10 Nov 2025 06:36:19 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a9va7qxpe-1;
	Mon, 10 Nov 2025 06:36:19 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, chao.gao@intel.com,
        seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, joe.jin@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv activation
Date: Sun,  9 Nov 2025 22:32:12 -0800
Message-ID: <20251110063212.34902-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511100056
X-Proofpoint-GUID: 2bIu93AptfZOH12qEOXsUbwwElvhjhAM
X-Authority-Analysis: v=2.4 cv=C4/kCAP+ c=1 sm=1 tr=0 ts=691187e5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=dhBlWXeqEOJ0AjUelTEA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDAyOCBTYWx0ZWRfXyK7bKXRI9/RB
 l+g9blH87m3IvYB1QtGGiJRRMS/OJnxfhD3Mlk/P/HhbDEiXhQibW73EfGwLFOjGjrQhm96jHkh
 +UhENFSF3YNTgt6ZEKcKdKrdR4KFnINa1i1rwDOeU2cA5FdktLpqmTCs+xzrVelSbvbam6tINBT
 ExTBbjqAfQHE1dbQYRHoRIf+iElX+B7S4DHBexymTmpGvClkYOEyjT31s5hx7gtPUem20a4wcsd
 +U0Lq7QRIYg5kz3pGH9Ej2pCxFGG5St+BPsZbOlMjthauhxIMsbMa8vvgMpXuqXGqJvXlawzfcO
 gq3mzAIEUSHpFn8ycHKSWxgbIn+U2OCfHt8QngGgfEvMhsO7F0X66iqUthFjh07O+zigpLVW8Hz
 HTtuHUoVt1lT7yvm/uIBP75LrgZhYQ==
X-Proofpoint-ORIG-GUID: 2bIu93AptfZOH12qEOXsUbwwElvhjhAM

The APICv (apic->apicv_active) can be activated or deactivated at runtime,
for instance, because of APICv inhibit reasons. Intel VMX employs different
mechanisms to virtualize LAPIC based on whether APICv is active.

When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
and report the current pending IRR and ISR states. Unless a specific vector
is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
KVM. Intel VMX automatically clears the corresponding ISR bit based on the
GUEST_INTR_STATUS.SVI field.

When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
to specify the next interrupt vector to invoke upon VM-entry. The
VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
VM-exit. EOIs are always trapped to KVM, so the software can manually clear
pending ISR bits.

There are scenarios where, with APICv activated at runtime, a guest-issued
EOI may not be able to clear the pending ISR bit.

Taking vector 236 as an example, here is one scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. After VM-entry, vector 236 is invoked through the guest IDT. At this
point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
interrupt handler for vector 236 is invoked.
4. Suppose a VM exit occurs very early in the guest interrupt handler,
before the EOI is issued.
5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
vector 236 has already been invoked in the guest.
6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
7. Unfortunately, GUEST_INTR_STATUS.SVI is not configured, although
vector 236 is still pending in the ISR.
8. After VM-entry, the guest finally issues the EOI for vector 236.
However, because SVI is not configured, vector 236 is not cleared.
9. ISR is stalled forever on vector 236.

Here is another scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. VM-exit occurs immediately after the next VM-entry. The vector 236 is
not invoked through the guest IDT. Instead, it is saved to the
IDT_VECTORING_INFO_FIELD during the VM-exit.
4. KVM calls kvm_queue_interrupt() to re-queue the un-invoked vector 236
into vcpu->arch.interrupt. A KVM_REQ_EVENT is requested.
5. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
6. Although APICv is now active, KVM still uses the legacy
VM_ENTRY_INTR_INFO_FIELD to re-inject vector 236. GUEST_INTR_STATUS.SVI is
not configured.
7. After the next VM-entry, vector 236 is invoked through the guest IDT.
Finally, an EOI occurs. However, due to the lack of GUEST_INTR_STATUS.SVI
configuration, vector 236 is not cleared from the ISR.
8. ISR is stalled forever on vector 236.

Using QEMU as an example, vector 236 is stuck in ISR forever.

(qemu) info lapic 1
dumping local APIC state for CPU 1

LVT0	 0x00010700 active-hi edge  masked                      ExtINT (vec 0)
LVT1	 0x00010400 active-hi edge  masked                      NMI
LVTPC	 0x00000400 active-hi edge                              NMI
LVTERR	 0x000000fe active-hi edge                              Fixed  (vec 254)
LVTTHMR	 0x00010000 active-hi edge  masked                      Fixed  (vec 0)
LVTT	 0x000400ec active-hi edge                 tsc-deadline Fixed  (vec 236)
Timer	 DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
SPIV	 0x000001ff APIC enabled, focus=off, spurious vec 255
ICR	 0x000000fd physical edge de-assert no-shorthand
ICR2	 0x00000000 cpu 0 (X2APIC ID)
ESR	 0x00000000
ISR	 236
IRR	 37(level) 236

The issue is not applicable to AMD SVM which employs a different LAPIC
virtualization mechanism. In addition, APICV_INHIBIT_REASON_IRQWIN ensures
AMD SVM AVIC is not activated until the last interrupt is EOI.

Fix the bug by configuring Intel VMX GUEST_INTR_STATUS.SVI if APICv is
activated at runtime.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v2:
  - Add support for guest mode (suggested by Chao Gao).
  - Add comments in the code (suggested by Chao Gao).
  - Remove WARN_ON_ONCE from vmx_hwapic_isr_update().
  - Edit commit message "AMD SVM APICv" to "AMD SVM AVIC"
    (suggested by Alejandro Jimenez).

 arch/x86/kvm/vmx/vmx.c | 9 ---------
 arch/x86/kvm/x86.c     | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f87c216d976d..d263dbf0b917 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 	 * VM-Exit, otherwise L1 with run with a stale SVI.
 	 */
 	if (is_guest_mode(vcpu)) {
-		/*
-		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
-		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
-		 * Note, userspace can stuff state while L2 is active; assert
-		 * that VID is disabled if and only if the vCPU is in KVM_RUN
-		 * to avoid false positives if userspace is setting APIC state.
-		 */
-		WARN_ON_ONCE(vcpu->wants_to_run &&
-			     nested_cpu_has_vid(get_vmcs12(vcpu)));
 		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
 		return;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..08b34431c187 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10878,9 +10878,16 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
 	 * kvm_check_and_inject_events() is called to check for that.
+	 *
+	 * When APICv gets enabled, updating SVI is necessary; otherwise,
+	 * SVI won't reflect the highest bit in vISR and the next EOI from
+	 * the guest won't be virtualized correctly, as the CPU will clear
+	 * the SVI bit from vISR.
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	else
+		kvm_apic_update_hwapic_isr(vcpu);
 
 out:
 	preempt_enable();
-- 
2.39.3


