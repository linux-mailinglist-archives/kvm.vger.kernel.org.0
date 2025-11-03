Return-Path: <kvm+bounces-61916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD2CC2E34F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 22:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F5073BC4AD
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 21:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178B52D6612;
	Mon,  3 Nov 2025 21:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PeOwxnqV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695E1917ED;
	Mon,  3 Nov 2025 21:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762207123; cv=none; b=S9epNxI9M/h0bwVfHRTSKI2Pn6kZVFHozJ+DPa/zBjoD9AwST/94zNGwDPdJ14NdaD/sCR18YtHRGbyGZcrFLvdIRwtQlcZ5Ng88WvOP1KpiLLDRAlhh0m6PJDAxMLg9wEuOWJRBZ1t6MXrZR0fli0jFHfmYioJKGx8hBeJZVJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762207123; c=relaxed/simple;
	bh=PfXU/jh66uDBoYjeoG+dYeM131MAN3sH+/yAuxBWU+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tHLG7WAo5w0ZXbfDNdlVqZdWQYB0d41sw4xXVI/LfqXQrQr0WlqBqXvW5pfvOXbcWgYdBTAVS4ZZrRGuXkVVmvrX6lCbSKA9Kfe1rk2j9hNeNDmuBssBQguO/IDTyEBl4kkg+2JgwdhyaGpDnFnYY1pDak4UqK7esf22r+wk/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PeOwxnqV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3LsFHf027741;
	Mon, 3 Nov 2025 21:58:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=XRx1Ysmz7tjQyomBspsIRzLkLsakV
	p13MOixsdHybeo=; b=PeOwxnqV3FOq3lR+jZkioExPJ3qGkUA9CtjvOJk0/9p9o
	A3oXajTPQ0c07zgkDrYZzR0V13+tMHO01AWKpj/mcUxaMqxCJSDq+WDqGqBJM2ZF
	WzEh7ZaSbGhw7XW0DgdGDghGUcZf45ujQvBZoSdbhMH1f7I+N3X5pCE9OjkoYB2/
	YVa+oSPYq7u7gvVJ2b2X4CuLkwn85rOrh98iuoYJd7zSIMj2MjPG7LeNweIKr12M
	wXyswtLUVnVqUTtwhgtasH/W9CeIsUtKpixjIczUXQUxVBq5NvNdCidKJYemnUQ8
	JU0Ejd8do7C1RhMA5ZYJQqUOaOetJdEaa26DWnkkA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a74qg80ac-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 21:58:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3Kiara014974;
	Mon, 3 Nov 2025 21:44:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n8g5pp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 21:44:31 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5A3LiUU4038655;
	Mon, 3 Nov 2025 21:44:30 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4a58n8g5pd-1;
	Mon, 03 Nov 2025 21:44:30 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        joe.jin@oracle.com
Subject: [PATCH 1/1] KVM: VMX: configure SVI during runtime APICv activation
Date: Mon,  3 Nov 2025 13:41:15 -0800
Message-ID: <20251103214115.29430-1-dongli.zhang@oracle.com>
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
 definitions=2025-11-03_05,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030193
X-Authority-Analysis: v=2.4 cv=V7dwEOni c=1 sm=1 tr=0 ts=69092574 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=mHEEIGHzy4QsYcnjCaUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE5NSBTYWx0ZWRfX1SXgacrUFcgQ
 EXDRgePCpKiZpM2KzZOmAjwzaZaIjB9Qbw2nc8o68rqGl5YLKcvELxx9u7J6aFR6e3dQSQEr/DB
 A0SJ4lFQN9/fj4y1Rab0j39nhO9xoXbGh6JcTM4pIm7t+pNxiViVIXxnvc22dbS6HYF/JSc1Fe4
 awQADh3afU3nwPCgxuLMAFX/2u7TfyzpLtUXgucGhPXRJ4LA0i1R/RfrSwRPKW0ZQaxS4GenpID
 csUwgDq/QSc1oB0luuy5/be0BLMN2dcBSfWyDbWc/oHH2AVzk4yCpMk6907OlO8WR9/R7X6V5uL
 2KwyhtDSbuwHqb77RLXNdJC/iUaPfeXD1kcMnOXaqTINc5qgsFnTbYR5HAi/KobLsHOdl5VJsIt
 EFrdgGoSnk6989B+K8GbUAriaCrdLQ==
X-Proofpoint-GUID: eCW0CGtaAoyD_slSOp9s6ssaML17vbYU
X-Proofpoint-ORIG-GUID: eCW0CGtaAoyD_slSOp9s6ssaML17vbYU

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
AMD SVM APICv is not activated until the last interrupt is EOI.

Fix the bug by configuring Intel VMX GUEST_INTR_STATUS.SVI if APICv is
activated at runtime.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..a20cca69f2ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10873,6 +10873,9 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	kvm_apic_update_apicv(vcpu);
 	kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
 
+	if (apic->apicv_active && !is_guest_mode(vcpu))
+		kvm_apic_update_hwapic_isr(vcpu);
+
 	/*
 	 * When APICv gets disabled, we may still have injected interrupts
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
-- 
2.39.3


