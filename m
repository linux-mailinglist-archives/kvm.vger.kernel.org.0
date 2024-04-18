Return-Path: <kvm+bounces-15140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A91A8AA321
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6192285FF6
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B3E199EAC;
	Thu, 18 Apr 2024 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="diLe2fIO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309381836EF;
	Thu, 18 Apr 2024 19:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469410; cv=fail; b=hSf1SnA394rNvzO0mI3TlYgd834MON2q6FfnKNhR82nK3rBEoo1QKPaJGV9H/Af9rBn/oWqyAyKmCCq74wGGfiTl86XpTZ8S9FdjPcyev3HNx2vO0/nc/XSHq/NT70VR5M2Tsh8+Ms85BVig8Fzvf9gwOKzSWLQlwJn99pGs/d0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469410; c=relaxed/simple;
	bh=Kl8Ejg/lTpR8l5lJ7YNmzHpkD1UWv+K901q9pv6IEZs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKE/Zzl1VIVZOzwBm6mq4Bt8oi2F0wJVyE8W0aHbIAMgYZOxjgd/MxbHbzipD2i+gD/mhmYNbttE4UHoSu4mWMVXydVAFoqc+0mLpcQlIS3FUraY9vvzJYeNVlCNUcUrC+qH4K9Zmvykf+pZ3Z5TO9FpCEzdWhUdtxP/0ZIU7kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=diLe2fIO; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/lgdwILJ4VDbB9RRMYE4VOcf7vXGbclgdOgoWrVKjFm5fL8/ljWfYHzKXApyVil6PE51djC6d+uubTdiy3rBTw2LrrYyOSahf0osQ1n2ZKNz8yTFTAHMcp7J9V7na+Q0Z/v8E8555Cx9THJWuC+Cmeaa28Jntzqluu1cHrxpx2tg8xs72+4zbbtwqAkSUDM1SRbEj2yrPQ5BoE0G6lG+nWVh0xa/XsWVimyrVIeKLj5dBQLrfap7ajZEBp+vTfEDyyxXXudI+IXatCy4gcWAy7NYbif4ymHGbxbYLZrbD3TuTltM3npY8QOm/SlruW5EAhEmmjWmZLEwmrNMus+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bAvTloRu93OvoLbZYR3VRr5XMtYt0A8EUcyw4snn6Dg=;
 b=JEV1DEBFUcsXlai0U5xXfUKhjDEWtcu+H5ZcqaFOWTfh8hTKUzkNrsVHbbrQL/mqqFLWk/rhR+IdDlyuUvmMLVMNrhFp7PvtAqYL4kpkms/uWL8SoJwD0kORFvMSVYlU1aPFCharOl9IWtV8yq4hfGXmU7MAcgCjPJ4T6cEKNUxGQI6nMYJ9bVRa8vra468ZeQM010or7v14gtkBJRcaz8j4IHLnX8XV8ThEiVQpvb31CSCWOzFgmQyJmshGf4CNteG+kLNj3XsjamzNz63UuPOtKgE5HGwYYJZ3s041Z5Hux/6FYM6Vk1vt6PGr/ePfnAFSrd0/vaREkhBqL+yeVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAvTloRu93OvoLbZYR3VRr5XMtYt0A8EUcyw4snn6Dg=;
 b=diLe2fIOCVnPKbmpX3hKja57QcscqumMdZFvdIapKbTx7kZgiLQaMawHpSYHzionR0/ElB7DKLHxCmF6e7Rousl1tkzGTZdbTqhgyODNhl0Q/Cqsjs27g+2PCHVWFZklotWXrQ7TPO4LcjsVSB1dy5j2wNigfUVYm9Mhzigsr+M=
Received: from SJ0PR13CA0108.namprd13.prod.outlook.com (2603:10b6:a03:2c5::23)
 by DM4PR12MB6448.namprd12.prod.outlook.com (2603:10b6:8:8a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.37; Thu, 18 Apr 2024 19:43:26 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::b7) by SJ0PR13CA0108.outlook.office365.com
 (2603:10b6:a03:2c5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.12 via Frontend
 Transport; Thu, 18 Apr 2024 19:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:43:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:43:24 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v13 12/26] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Thu, 18 Apr 2024 14:41:19 -0500
Message-ID: <20240418194133.1452059-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|DM4PR12MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 757f82ed-0a97-41e9-e181-08dc5fdfd0b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eBly+86411/42OlXwgtA8VN6g4j333zrWr4POiO+8SWNojTIh4Sa7Lcrjv6b0cf5dwtBpH7Vz0Nge9U7aIiFDuExahPL0iVuUTUJLnV3qc/2eTzVd8wJHGpG6DQ6S/uvQxeZLBH0El5UVAgvij7Y6XsZg0svbOq9RL5oycoYZULhrml9tTBf0CnwtNPHeNd9yDmeZZHdOs6RHYx7u5T1r+tQqd9Ut0/D8/wXg0oxy20pmq9OX2yRoHFKYWgqbaecYKlJa2OA8DWjfHg789AD/Q2EjGqEcJya3stVWugqW1R31gqIx/ONYEOZTNltVZm29SE96dcnDr+VaLbXVz5ZqeXSCb99koGE0aSKGY04Kbe8rmWrWmnTK8MTugILZ3p5XHzy+e8pw6WoZdNyKPR1POYONMFU0fA/fqKfFPC7Apw5BAl1YiWjtkp3JOd/30juQsl+yex1cvnZlwXtbEsX9AauvHrXcug83kIKkv9QNekn1s87Mc65ARDgIj1tJehRqqfDhfF8Q0NK+7/jKOt3zQHt9KTSj9wlz5fKGX/oU7aCZwrrFOXdQU+2okptf+PFhlVDJSKHH4omJZjEaHdCPlTu86+vq/P3UKEDT6goqp89DVr0BZSxml774Fkog1VvfcWBdvrvGt2mxoPkLenV4Dy20mIL/UMy/usQuJJ5dripXtGy8sJ1KJkTqrCt8dIPFjw9gHMg1ivfUCdmlCP5WpOrTw6hh3mFNEEWICFPuA0P8O3Wtvx1AYU3ZaG91Slz
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:43:26.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 757f82ed-0a97-41e9-e181-08dc5fdfd0b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6448

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 78412c7c6708..bd7f46c61c64 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3532,6 +3532,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3595,6 +3615,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0654fc91d4db..730f5ced2a2e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -208,6 +208,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -361,6 +363,11 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


