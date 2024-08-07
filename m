Return-Path: <kvm+bounces-23463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B269949D2E
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 02:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8772B24A8D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662D23D0C5;
	Wed,  7 Aug 2024 00:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JAWwBBlC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B925247F4D;
	Wed,  7 Aug 2024 00:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992363; cv=fail; b=agswE6Qbb2Z+9eFP9wxQni2LO5phY3HvN00GS4+CL09gzRoYJRz4Eb6CrXLCJJDXvTcHxPb+Cscz3Sz74eermr/0V1Q6LqTrnGX1Lq3OCoQv/2cZswBpd1nK/OclxltO/iXlTlFxYUlM8aJ5f4lv7URHUnCk2xRlEsO5A8pl5j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992363; c=relaxed/simple;
	bh=YRxhSZcXzZ3N8gSf6PktoLzo3jlanXKSBRgOvIIXwAU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GwULCkZ2s7WTGIOZy6Kb/svpU2M4YyzxVkOPMMATAz4VeZ059LbuxWpePwM+cpIJYmnvJBWWfDx3LMuTlLfUFQhGGWnnRkILfEwp9r+0CN3Rk+rp6HOquaN3UPsc6TuIyFul8oN6gCQfbONGHTVTAVCysC5aIUo9mnHnglyVqYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JAWwBBlC; arc=fail smtp.client-ip=40.107.95.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PC3ZyMJaCuBJwYC9QqJQVi5p4GeC6ZX2dIDMwqmup1Yeplpmu0EsJ2YzTa1a/CBHdY9E5JQIDZ/vKJ1l5GoiftNgIFsz75R7s39YlFh9Wlgor37aEzt5RVVUja3Qy7l1ZDb2VfE441gxgl+9906X2PZRqLnyTVCwTbpKVVeXQuvLdY0I2JFdlCyGQ4KEBe66EQOJRcIDULlMLDp8UqxGkQ5WVZFldxc1tKrTvtSKUPPFQovDhkFviZv4nY8oMd7PRhqf6ZSLNLqVhEm/v8qNxkBZKbsCM4W4NzzICTCzXHCqOVMk/rYj9C5HHq7OwOU9et7w2g+4yFElwElltehdVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yONzLncC5SPQJ0saSVsx2+agJazN3SngxHHPxFtrDKo=;
 b=xTjFW/sf0Elj15/s2nyh8T0p3vBDt3S+KKUqUZZiY0Fxmaud2qL7KCwn27RCs6P4yNdsqXU2WCAIhA6ySQbzfOH+LKhR6hx23NDzIS16ljGRyENkMD95tM1loOJP9Hlpgo9PZ9lMavnrukF+QQhDzrEYM3F74jrOQCKAcmzgrfOPgxTjksdg7DfjRS/O/NaS9MwGuTkDEP1b8NO0i0sLOmSvE9DaJ++sPOrNNz/W/4y2GomXFduzGVVLYWFB9JcP+wo8LLuQvo4hYODSD5CtX/CVxG0C29u/l7xaz2ulh9bPYHcGNiDLThbFoE5T0VhNbZ/bmMDcpZXT2BuagEFLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yONzLncC5SPQJ0saSVsx2+agJazN3SngxHHPxFtrDKo=;
 b=JAWwBBlCMdNv245PVPHBxiLnnb88oudLg5n+YvaYLf9eYbSaZbXvLKsUSCI/9BPAhqFb88ToNY2RRlNhNEl4k2vfOX57AKjxOyP46aeQL+mlp+q+IJnMnirzi096Am27otsF6gl6TdIF5MHvnhJHz81EPFZGUADftYmhpGnGIh4=
Received: from PH3PEPF000040A2.namprd05.prod.outlook.com (2603:10b6:518:1::56)
 by BY5PR12MB4145.namprd12.prod.outlook.com (2603:10b6:a03:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Wed, 7 Aug
 2024 00:59:18 +0000
Received: from SN1PEPF0002BA4D.namprd03.prod.outlook.com
 (2a01:111:f403:f90c::) by PH3PEPF000040A2.outlook.office365.com
 (2603:1036:903:49::3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.7 via Frontend
 Transport; Wed, 7 Aug 2024 00:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4D.mail.protection.outlook.com (10.167.242.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 7 Aug 2024 00:59:17 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 19:59:16 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Ashish Kalra" <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>,
	"Melody Wang" <huibo.wang@amd.com>
Subject: [PATCH 2/6] KVM: SVM: Add support for the SEV-SNP #HV doorbell page NAE event
Date: Wed, 7 Aug 2024 00:57:56 +0000
Message-ID: <dc0a62a111793c6e1db36ecd92808d5874244f6b.1722989996.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1722989996.git.huibo.wang@amd.com>
References: <cover.1722989996.git.huibo.wang@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4D:EE_|BY5PR12MB4145:EE_
X-MS-Office365-Filtering-Correlation-Id: c047f845-2992-4880-0e75-08dcb67c2a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dIqjzg8hcNehcmf9MCyzTc4spZspgvOuc+6kao+F8PWdlzK6xNSPEd1zq4Az?=
 =?us-ascii?Q?VJOEpG9WXmfRNK9yZ8Xbz0N6gpE8LtWMd3FVJQh8ALeYMBwxH8ewhK7Vwr8a?=
 =?us-ascii?Q?tLrcYN0r/ZduZ/FFrbVHtclcpZaRUe7rIYAX6SkX29cTMacKzXerZw/ELL3b?=
 =?us-ascii?Q?BN7P8k8GVYgONS2m8ywGLu7QrtZa3zBZ/Nog6IbQYRXGE3mMCEMuWDJKSWTl?=
 =?us-ascii?Q?WvdhfQ/J2bQrh+1f0TBWySsELDM9gOjZ9IZVDpOKAe+Qu5wuvOqSGpt6nlie?=
 =?us-ascii?Q?3Z1BOY295vTFQggv3uJDGPsyeyKN4qNT8oL6R4jlHd3iKcXru8JQ+xl83dlx?=
 =?us-ascii?Q?HYauUjYP5FH7q1s4gSBjPpPhMmlyKBkOKu6tkwd32skqbqj41dgph+D1OAHH?=
 =?us-ascii?Q?QbU4X1gRyzZGhEhJa8sWjOsOMnB90kFZOkVju3ZyCnZNYeEHVjy5t7bLDxx6?=
 =?us-ascii?Q?Ap4DGEPnCafUBopX9BylC78O03tIN9ebaJhezQdjOK9FRAnrCeT2gdhJoQDr?=
 =?us-ascii?Q?RrhIdqzYpN4qaYzUpx7SxbBeDeVTK04RLJ3HHp1ImJdr9iQpO2141JrLc/rn?=
 =?us-ascii?Q?lBqWLXHpjWdn6vP29ddIzzTpMyj+ZxJLoRDQ6idm5zvUGcfL/+PVC517RWp3?=
 =?us-ascii?Q?XI8y2DiViQIixmwXOzswmPfOlA8+xnxY4pRK7HVC/h/QdZlHU+/k9CkYlsf1?=
 =?us-ascii?Q?gZuuTlN7hM4h+9+trM4hQQbA+tDraUcOLZTonqrrxuIRrc1VOycnpjE1UzP3?=
 =?us-ascii?Q?LdlIqxiwZhdvc09tRr85Xs9EaPDtADWaSygdflG+wn2uCfjV6HBO5MfJJHbY?=
 =?us-ascii?Q?k0HRQQNWtl4Ydtd8VFuW3HMt5ebasiSb4jB2SZ3m5/oFO4fYs0vmHX/Vmolo?=
 =?us-ascii?Q?b+soJ6Q3b0O131YbOKGq2EeW700NSx+NuosRWyW7r7EUG4HCnPTN+qEwiGqI?=
 =?us-ascii?Q?B3lqCj8F2obgkQ++vXlmZwttkNjLLoHvTMagEvEunpKiI9WvrzMVsHz0y7dx?=
 =?us-ascii?Q?6x3W4X+TyGHwvagFLlUUgeSQKwYlR5/vjPAEKaYCgZ8ecWKiAFDWIdUuqDAJ?=
 =?us-ascii?Q?4lEC6SUycY0gfhOVURLxx5ueQkSUiRnzqSJ9WXPUsYhRqxBHJZCvXCJOGhnY?=
 =?us-ascii?Q?0+dJKONcIt9G/9jCiAh+n6aj9ZXG4wZndPhw+n9Lcp7nEKHGoN9dO1Lo70Dg?=
 =?us-ascii?Q?nhOV31oz9sYc0sV1uq+Getj5m/FOQo0m4hjjrxic1oTFz7Tt6XDhYQ5SF4PL?=
 =?us-ascii?Q?jGt2I8hHBTPuqN2z0tU3vxiTp2LBfLoqPtu6vuGBFXONVR26RRVsjxriPEbT?=
 =?us-ascii?Q?stnTvcTuZyljpbow+1vMwvYgmNhiiL9tBHk7qNIiywQKQ4ydVCcMLJxdh+E9?=
 =?us-ascii?Q?WmGDfr1YAhDTX4QQfPedPD4D3UA5ahyQIlYTLDMvhE0137xwSzZ4VX/28bjg?=
 =?us-ascii?Q?/KHGpCoeCbl2oQ6jx9CEgDCZC/yWnbEw?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 00:59:17.7839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c047f845-2992-4880-0e75-08dcb67c2a21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4145

To support the SEV-SNP Restricted Injection feature, the SEV-SNP guest must
register a #HV doorbell page for use with the #HV.

The #HV doorbell page NAE event allows the guest to register a #HV doorbell
page. The NAE event consists of four actions: GET_PREFERRED, SET, QUERY, CLEAR.
Implement the NAE event as per GHCB specification.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  5 +++
 arch/x86/kvm/svm/sev.c          | 73 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  2 +
 3 files changed, 80 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 1814b413fd57..7905c9be44d1 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -115,6 +115,11 @@
 #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
+#define SVM_VMGEXIT_HVDB_PAGE                   0x80000014
+#define SVM_VMGEXIT_HVDB_GET_PREFERRED          0
+#define SVM_VMGEXIT_HVDB_SET                    1
+#define SVM_VMGEXIT_HVDB_QUERY                  2
+#define SVM_VMGEXIT_HVDB_CLEAR                  3
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 532df12b43c5..19ee3f083cad 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3409,6 +3409,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    control->exit_info_1 == control->exit_info_2)
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_HVDB_PAGE:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -4124,6 +4128,66 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	return 1; /* resume guest */
 }
 
+static int sev_snp_hv_doorbell_page(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_host_map hvdb_map;
+	gpa_t hvdb_gpa;
+	u64 request;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return -EINVAL;
+
+	request = svm->vmcb->control.exit_info_1;
+	hvdb_gpa = svm->vmcb->control.exit_info_2;
+
+	switch (request) {
+	case SVM_VMGEXIT_HVDB_GET_PREFERRED:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, ~0ULL);
+		break;
+	case SVM_VMGEXIT_HVDB_SET:
+		svm->sev_es.hvdb_gpa = INVALID_PAGE;
+
+		if (!PAGE_ALIGNED(hvdb_gpa)) {
+			vcpu_unimpl(vcpu, "vmgexit: unaligned #HV doorbell page address [%#llx] from guest\n",
+				    hvdb_gpa);
+			return -EINVAL;
+		}
+
+		if (!page_address_valid(vcpu, hvdb_gpa)) {
+			vcpu_unimpl(vcpu, "vmgexit: invalid #HV doorbell page address [%#llx] from guest\n",
+				    hvdb_gpa);
+			return -EINVAL;
+		}
+
+		/* Map and unmap the GPA just to be sure the GPA is valid */
+		if (kvm_vcpu_map(vcpu, gpa_to_gfn(hvdb_gpa), &hvdb_map)) {
+			/* Unable to map #HV doorbell page from guest */
+			vcpu_unimpl(vcpu, "vmgexit: error mapping #HV doorbell page [%#llx] from guest\n",
+				    hvdb_gpa);
+			return -EINVAL;
+		}
+		kvm_vcpu_unmap(vcpu, &hvdb_map, true);
+
+		svm->sev_es.hvdb_gpa = hvdb_gpa;
+		fallthrough;
+	case SVM_VMGEXIT_HVDB_QUERY:
+		ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, svm->sev_es.hvdb_gpa);
+		break;
+	case SVM_VMGEXIT_HVDB_CLEAR:
+		svm->sev_es.hvdb_gpa = INVALID_PAGE;
+		break;
+	default:
+		svm->sev_es.hvdb_gpa = INVALID_PAGE;
+
+		vcpu_unimpl(vcpu, "vmgexit: invalid #HV doorbell page request [%#llx] from guest\n",
+			    request);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4404,6 +4468,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		break;
+	case SVM_VMGEXIT_HVDB_PAGE:
+		if (sev_snp_hv_doorbell_page(svm)) {
+			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+		}
+
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
@@ -4571,6 +4643,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 
 	mutex_init(&svm->sev_es.snp_vmsa_mutex);
+	svm->sev_es.hvdb_gpa = INVALID_PAGE;
 }
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..f0f14801e122 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -225,6 +225,8 @@ struct vcpu_sev_es_state {
 	gpa_t snp_vmsa_gpa;
 	bool snp_ap_waiting_for_reset;
 	bool snp_has_guest_vmsa;
+
+	gpa_t hvdb_gpa;
 };
 
 struct vcpu_svm {
-- 
2.34.1


