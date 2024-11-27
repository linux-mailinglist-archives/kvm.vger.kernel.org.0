Return-Path: <kvm+bounces-32617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2799DAF6D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5A33163C03
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F9620408C;
	Wed, 27 Nov 2024 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3YvJoZZ5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CDB2036E3;
	Wed, 27 Nov 2024 22:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748308; cv=fail; b=cqWCxrprmU+tVg4/RDCK0ggrBOOynp62nDy17teOPZZ108uADXWCkNb95IK5G0g/Ncl1Co6PD4h0pFdObmU7Bndo2mV23Eg13QdF5TVnZsdMIQRMEd+iSrwZ3FDxqJz05HHYhlr2USgIvHTDpH8pxqSFMzlHA1KEf/4H+AMVZUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748308; c=relaxed/simple;
	bh=hMf8Xy8uCOdFVm8cjVZtD2mvkfJo9Q40MXlQx8l7PbI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y9uY/moZisttJoGS3wjgyt2tGcSoElDFgLNEta630+xrCzVBwGe67lJRJMRAVCI6ak1NQWzwSB3aGmNqCmrl1oOtCf/mcDr5g18onk8GmvU9uQmXv/n0F3ObgR0HgYZnoLs1s0eVQYDxTdN0dmtCSrAPxmNqqsg0rgg39wGG9LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3YvJoZZ5; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=prHaFSHUdCE5R/Tm7uIhkSEkAtQ+EBuQu9uu/fDoBEz2L/xfxjclYPy1wmMR3hrzDzI/UJVLPoTTfaKIe4GVySOiYQCnP2x/41TBNoeHuHDgS8w5AcFoFAFoQO3qvjcJImkg6ZhRBgrefMxGx5R8BG8HJN48C2h3e9VNR+/62xiMAPyec/nuHBmBLxiIgadv4KxD33FS1X7M5eGANpUaj3h12LUaloOx0t8gCh56RtpmZ5Fo9PZ2HPF4NxzAXtxGKLDRlrXqUn7uyMo2mnL7fCyEIy51HKSCUFHBVVkOVoq8RpzG5YE7xAmdt7n5xxuwHk6Ee3cktruu7moAN7qbjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epAxFeTsCYoLZvYhuWzuuX5wZ3QKXW3RxkhG4dQUlAw=;
 b=mWaUte+IDgjYpzK97cywMP8C92B5V3bGI8nfRv124FN5RpangRJyef//rxcvoUBRwcN8wh2inJ3rR+5rD5GWJGZxIpeaM4Z9ljSixfIGwbleaAfaZ6tVzeFuH5uXpPbj2fUFGlXs9sHCnclYmb9tz5ZBaS1GUQ7h5yW077pEnMx13BAl50unbNpGwsmZC2u8/jdRRYd7zrfHp+S6dWJY8ZK/TQIZjFTVlkE5D55JIKiI98I89lWgbS70MN8f6QGYyjfxNraR2WsP0eB8vd7h6ziSgJ77gRGljkkHZpZRpOvVZ/QICJO+R3aKuv1530ZYXp1+tGflzDK/8XhM0dNWMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epAxFeTsCYoLZvYhuWzuuX5wZ3QKXW3RxkhG4dQUlAw=;
 b=3YvJoZZ5HTpOGtAjN1PV0dgkohdMPt85+dP5teKQrctRGdeVIAlKIpFELYQR3T51HyArmvahhI+R0ovCvkh204vRPOgTD+UFwFvlF2O6r/Q/rtvZypsTAaiiPULstpJ/fP4MLwo62IUHjpWgkxNYOGit+d1VLhpBQFsI3DZfTzY=
Received: from BN9P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::34)
 by MW5PR12MB5623.namprd12.prod.outlook.com (2603:10b6:303:199::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Wed, 27 Nov
 2024 22:58:22 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:10b:cafe::52) by BN9P223CA0029.outlook.office365.com
 (2603:10b6:408:10b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.21 via Frontend Transport; Wed,
 27 Nov 2024 22:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:58:21 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:58:20 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 6/7] KVM: SVM: Add support for the SEV-SNP #HV IPI NAE event
Date: Wed, 27 Nov 2024 22:55:38 +0000
Message-ID: <20241127225539.5567-7-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127225539.5567-1-huibo.wang@amd.com>
References: <20241127225539.5567-1-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|MW5PR12MB5623:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f442843-1de0-430c-f017-08dd0f36fdfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0yqcJaso/eRuM5KsS2Z6FMN9/qHyFCl1VN38xX8c7eNHxf3KTUQ7S813YbQ6?=
 =?us-ascii?Q?UD5daU887qRjPu7PGfmHbHPN6FhYKN2+v83bSpSV5BNOddCaNDO74tEBjbHC?=
 =?us-ascii?Q?J0yCtY2oMBrSqkM7GViUVTm1p4+hUwIfjx45XHg5ZRW/IGRs0QMwGEehfHMM?=
 =?us-ascii?Q?73CJ2KNnvj0+C6NEPGd0GVeb9WCb26HC2cvMHTmFh6IZsVwNkR89cJIzS8Y5?=
 =?us-ascii?Q?9KNiuTwUGplI6wd1UdH238Qen2WDKY+TuylZwHTTuJaVD8RXBSYzR2Suc9dv?=
 =?us-ascii?Q?FGV6dv/a6u+NC+kbwXnfrKhqTH+fQgDO1De5ThL+DB11kU9N1unB+ao1oFT3?=
 =?us-ascii?Q?togRf0tL89DS/NEPjXY8lxhGYjDNTdZy6snotQDNrYxDZ1m3ooPfnSHwPTWR?=
 =?us-ascii?Q?VegPOwmKDNpHQRQzAW1ixfH7uVdAGNNRuitSyZcRalvsrVCcuXZ2X5VmoI4I?=
 =?us-ascii?Q?naQHrEIZ+9Tu5SX1O3/bkLcXsc6w5j4bJ4JbPcDuNajxxnn9H9aJnplv/fJD?=
 =?us-ascii?Q?N2S8P5AqHZFB5V6hp8w7D+T8IH9DitFGRdf+FBhoy5DJ5xIyCvPoViN71nDi?=
 =?us-ascii?Q?MUYbjsV8tZRaJonbOQxF9U/BcSchlrnvmtLfK+X5dAdF82+PQPFWz+vJZivE?=
 =?us-ascii?Q?mXdylOAR9j8homC0nSrh+tb1Di7CO68JNhcrrVJ60EjJ5iY/xOfWTzSPYvgx?=
 =?us-ascii?Q?F8n6w0yM1NUAbTLkeb3fol9qhGwQO3NTlm60zcNNGmX82ZuhDQWEU0V4GLEk?=
 =?us-ascii?Q?m/x0+35KAsDwKxVJgJoN6NhuBQadLz6b0AsSsBXjI7E6NdV14Z1g0P6uy7tu?=
 =?us-ascii?Q?c8p3BzCybOoTQ4G7jr/rsCi/Rs3Uq3XunUeikoWTqyFKSZxQ2GFFpn+kjbRd?=
 =?us-ascii?Q?jbO1W5RDiOL+THikYZIuQBR2/OvacmX/6xWeEvCsg9a3xjoHjIyfQ0pQtndq?=
 =?us-ascii?Q?aExKN7WWhsjD7Q13Z/aBN8rxNvBSHZzL0N0MqbFmxCX4n15bh04fPZ00hlFY?=
 =?us-ascii?Q?MQ1ZBQeG+uVW7h/NczUOrbE9PNudf7vr3Kf+HX4lJdgSawBrdTL0mrULZXJE?=
 =?us-ascii?Q?qW5kD7UQ4ggUNgFUD908BQwTP6aAyKkv86Rskk/0ud8OClHwx2Q3Evre4Jyn?=
 =?us-ascii?Q?a+ojSlwjib72mcILK612jQACAifKs9yXiS1Yi2ewzhm01OnrriDGY+SgYKI4?=
 =?us-ascii?Q?V+VFqihnHJYahbL4FXwYp68AgXMlyc3WSBJErJlOVIL25He/+Q5b11dAgTez?=
 =?us-ascii?Q?vllIpixE/mB9NGjsys3OZPkZu9SH/F2NIXF8/uQWjBljpnA1uJakI4f9NtUB?=
 =?us-ascii?Q?HvcHb3h05r83QzlYWRIJY/PR4rNYIM91ok/tkAv5eKEvb6/++jXaLCDKr9gA?=
 =?us-ascii?Q?5ULf6CbjFF1E/E1MKIUONy4pdps+sHJaGSzfRfeyUbq8uF+ZL/rAqdYJmjBn?=
 =?us-ascii?Q?+WKR9QTU0WAtKhdiu+HEDY77XtJMo6/e?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:58:21.9560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f442843-1de0-430c-f017-08dd0f36fdfc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5623

The #HV IPI NAE event allows the guest to send an IPI to other vCPUs in the
guest when the Restricted Injection feature is enabled. Implement the NAE
event as per GHCB specification.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  1 +
 arch/x86/kvm/lapic.c            | 24 +++++++++++++++++++++++-
 arch/x86/kvm/lapic.h            |  2 ++
 arch/x86/kvm/svm/sev.c          | 29 +++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 7905c9be44d1..7a3a599d3df8 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -120,6 +120,7 @@
 #define SVM_VMGEXIT_HVDB_SET                    1
 #define SVM_VMGEXIT_HVDB_QUERY                  2
 #define SVM_VMGEXIT_HVDB_CLEAR                  3
+#define SVM_VMGEXIT_HV_IPI                      0x80000015
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c83951c619e..99a45ba1b637 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2417,7 +2417,7 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 static int apic_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
-	struct kvm_lapic *apic = to_lapic(this);
+	struct kvm_lapic *apic = this ? to_lapic(this) : vcpu->arch.apic;
 	unsigned int offset = address - apic->base_address;
 	u32 val;
 
@@ -3416,3 +3416,25 @@ void kvm_lapic_exit(void)
 	static_key_deferred_flush(&apic_sw_disabled);
 	WARN_ON(static_branch_unlikely(&apic_sw_disabled.key));
 }
+
+/* Send IPI by writing ICR with MSR write when X2APIC enabled, with mmio write when XAPIC enabled */
+int kvm_xapic_x2apic_send_ipi(struct kvm_vcpu *vcpu, u64 data)
+{
+	u32 icr_msr_addr = APIC_BASE_MSR + (APIC_ICR >> 4);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	gpa_t gpa = apic->base_address + APIC_ICR;
+
+	if (!kvm_lapic_enabled(vcpu))
+		return 1;
+
+	if (vcpu->arch.apic_base & X2APIC_ENABLE) {
+		if (!kvm_x2apic_msr_write(vcpu, icr_msr_addr, data))
+			return 0;
+	} else {
+		if (!apic_mmio_write(vcpu, NULL, gpa, 4, &data))
+			return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_xapic_x2apic_send_ipi);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 24add38beaf0..29c55f35f889 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -140,6 +140,8 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
+int kvm_xapic_x2apic_send_ipi(struct kvm_vcpu *vcpu, u64 data);
+
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
 #define VEC_POS(v) ((v) & (32 - 1))
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 19fcb0ddcff0..5e8fc8cf2d0d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -34,6 +34,7 @@
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
+#include "lapic.h"
 
 #define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_DEFAULT	2ULL
@@ -3417,6 +3418,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_HV_IPI:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -4193,6 +4198,22 @@ static int sev_snp_hv_doorbell_page(struct vcpu_svm *svm)
 	return 0;
 }
 
+static int sev_snp_hv_ipi(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	u64 icr_info;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return -EINVAL;
+
+	icr_info = svm->vmcb->control.exit_info_1;
+
+	if (kvm_xapic_x2apic_send_ipi(vcpu, icr_info))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4479,6 +4500,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
+		ret = 1;
+		break;
+	case SVM_VMGEXIT_HV_IPI:
+		if (sev_snp_hv_ipi(svm)) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
-- 
2.34.1


