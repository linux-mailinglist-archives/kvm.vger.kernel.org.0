Return-Path: <kvm+bounces-13119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB281892765
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:01:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA02A1C21231
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D26713E6CD;
	Fri, 29 Mar 2024 23:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x1pPgZp/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D46812;
	Fri, 29 Mar 2024 23:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753294; cv=fail; b=exxQRgbOIaW/DBMK24f4Df4FO4XFFt20ppY8Mt06D5PpWgUeXiEZjduLnHRxIrDYw9q+IzbGyQHtrivsS2cp4AcxpgtT3Id3WlswORnhm624LeqYgreGdtXygGL8WDyWqBGEvjJMoAR3rIFEF655A1NcLkjf350GwSHM7ge870c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753294; c=relaxed/simple;
	bh=4qvRWsICDl99zvYHmx2qv8RT7DKMlOjX0woIqVPFkUg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3g6zpjyIoGXBOMy9ZUONFlOjtz0uLPlBZNp+1BpcgJytAncqfkaejREAsxcBpDMMTCtPCv50JhROguzCFDqnOJpT81MGCqlMWtQiGdWhoDH6CCJ3zFg9V4KU9TeTu5voQNhITfOjrUySe7ETr1p3f3PjLxngM+c50SSplKRMsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x1pPgZp/; arc=fail smtp.client-ip=40.107.102.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCfx2pxAPcDIhGGCIIXvEZ+QqpYkKPGB2n28Wt/4FGN8LNmDtzrCdiknSaGy5RDfLaQrfY9qCn08xszP1rgPbnn0KlNbm/PImUFTENEgYOVjZ4N350PQmpYjXgbXNpnCKMG1/v8wdhYUYihr9xfzBpW8Rppy71YE/HtLG+POPGeKfip0NIwX7PoaE+XzBt+qNP+MlI/boxUX4aqwNyMyO9ddXDbdHfKI7/Gz2vpilMR8BAWrMEcbLoaaCuNuVtlFtkAS/u7RXuy0bUTfp2jS4K+PMAeRsL7jqFZxF8FTfuHrhCXRbWSI7HiV+bR5ILxoksgPl0szTNoPUgf6nAqTwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwsQ4vWs9kyckXicEHz0E1bw+FLch5Zb2vNPyuP5js0=;
 b=FBzy9DOPOcBI/CEWKxYDklTuaBIEaQTPcmz72dBaVzcsozW4M+RTXXeKymqWkCshZaFCwBcQDUoWhLBlquQT/fyXtoQ6jqlKLvOnpnRypnTciDFxM3tDSTlCOIsZYUMHGkbIFNNTpBzSi+nN+aKS/pAEJeP+kR+Jm9jtHHyzyC1B/stH7uAKhtR5D056+SEShaqpgscSqZWZz5zBFNE8d9cW9nkiQUQtkYc/fCdx/8br+0vLefo66Iu4B9jI56bbfjuBr2CmWX3e1Udguva91guuoedq8ITOsTwOzGvMMLymIognyXr5W1UHItv/ppyx+2pudV4DN3nNC7pT/zlN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AwsQ4vWs9kyckXicEHz0E1bw+FLch5Zb2vNPyuP5js0=;
 b=x1pPgZp/rwomW2cu5jI2ejo6v6jaaCWo1ZgdojsKzmXwrP7jla768ayEkojYMShDNcs3du/TE4hgNK6GiweydFOxAjizjRUEdhRJmZXoDW0VjFyq0OacZxfgxX+58IuPUHaIiyHXmbuMUWy6THhF/prrfH2WFIh/ruhgslZ8Ee4=
Received: from SJ0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:a03:33a::26)
 by DS7PR12MB6005.namprd12.prod.outlook.com (2603:10b6:8:7c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40; Fri, 29 Mar
 2024 23:01:28 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::cf) by SJ0PR03CA0021.outlook.office365.com
 (2603:10b6:a03:33a::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:01:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:01:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:01:27 -0500
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
Subject: [PATCH v12 15/29] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Fri, 29 Mar 2024 17:58:21 -0500
Message-ID: <20240329225835.400662-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|DS7PR12MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: d3317c0b-19da-4286-a456-08dc50442ab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g2aGuN3u1dfzFksvUQT2M7ocUNjN0bbyE14+lvY6al5Z6FN03fB20cT+zkLqpXFp1xMns/IR/66MM0oHsvm5F6wqdxy16aUt+ZHMWDtembe0QFR5uEzYZOJj2oWH2dVIYMY6ngnmUZDoHtzWflHvKaTizzjiBdxCF/rdj523MZf5YoALBPq/uvBBKa9ncxKb7E4Ew6FVa71bQNzg80CHWGTLLWftjXHO0SbTcoYOFkfe8GNuSYu6LeJINz3k3tbkSmzxt5mukj9afrfjN40oFT2l475UPUGEBmFDkABeZF+Tp2C1DVseN1QQ5gdXyk2zNgHZZhJnOMhygUZbuCHolelU6Td4vqEBu0AjA+bhiNeQwTmuu+850Giwqx1UY0JDrYWsEhblkZa0L5b/dIbxdyXzl2kVhyfHO+j3MCxxY+wu+yhU2xGC9b3RzK5OjN0xsSx3ABlMX+oke/5REbwlHOK5hJN/g3NqW2xqLP8q8kA7WQ2+EdjBEKIlcjVquPmAS2GGzkG0Dptw73Pw8Ny91iTRhq+pV8x7TJGhzoaYYoX+QVfjyn//iMIuIPtENhSqMpVijPpd6VeYNZ0x1mGAIY8KQUhC8rmAdFbrKcr7A7MsGr6f6wPggW6lD9upWtBrLE5jzyMllBl1M7cZf82qxxmsJv+jjIOxSn1ZBf3CKXuHCGCsI/yTg4X9KvuwRFDmjkuqUkmje+FFtL4JL2tGykvGSGualpK8FZDnJV9Mn0NHlx9YhdfWOAhB7P7VtpdE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(7416005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:01:28.3153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3317c0b-19da-4286-a456-08dc50442ab4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6005

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
it is done for requests that don't use a GHCB page.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 Documentation/virt/kvm/api.rst | 14 ++++++++++++++
 arch/x86/kvm/svm/sev.c         | 16 ++++++++++++++++
 include/uapi/linux/kvm.h       |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a7a2945bc78..85099198a10f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7065,6 +7065,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 		/* KVM_EXIT_VMGEXIT */
 		struct kvm_user_vmgexit {
 		#define KVM_USER_VMGEXIT_PSC_MSR	1
+		#define KVM_USER_VMGEXIT_PSC		2
 			__u32 type; /* KVM_USER_VMGEXIT_* type */
 			union {
 				struct {
@@ -7074,9 +7075,14 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 					__u8 op;
 					__u32 ret;
 				} psc_msr;
+				struct {
+					__u64 shared_gpa;
+					__u64 ret;
+				} psc;
 			};
 		};
 
+
 If exit reason is KVM_EXIT_VMGEXIT then it indicates that an SEV-SNP guest
 has issued a VMGEXIT instruction (as documented by the AMD Architecture
 Programmer's Manual (APM)) to the hypervisor that needs to be serviced by
@@ -7094,6 +7100,14 @@ update the private/shared state of the GPA using the corresponding
 KVM_SET_MEMORY_ATTRIBUTES ioctl. The 'ret' field is to be set to 0 by
 userpace on success, or some non-zero value on failure.
 
+For the KVM_USER_VMGEXIT_PSC type, the psc union type is used. The kernel
+will supply the GPA of the Page State Structure defined in the GHCB spec.
+Userspace will process this structure as defined by the GHCB, and issue
+KVM_SET_MEMORY_ATTRIBUTES ioctls to set the GPAs therein to the expected
+private/shared state. Userspace will return a value in 'ret' that is in
+agreement with the GHCB-defined return values that the guest will expect
+in the SW_EXITINFO2 field of the GHCB in response to these requests.
+
 6. Capabilities that can be enabled on vCPUs
 ============================================
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1464edac2304..c35ed9d91c89 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3208,6 +3208,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3426,6 +3427,15 @@ static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
 	return 0; /* forward request to userspace */
 }
 
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, vcpu->run->vmgexit.psc.ret);
+
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3663,6 +3673,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_PSC:
+		vcpu->run->exit_reason = KVM_EXIT_VMGEXIT;
+		vcpu->run->vmgexit.type = KVM_USER_VMGEXIT_PSC;
+		vcpu->run->vmgexit.psc.shared_gpa = svm->sev_es.sw_scratch;
+		vcpu->arch.complete_userspace_io = snp_complete_psc;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 54b81e46a9fa..e33c48bfbd67 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -137,6 +137,7 @@ struct kvm_xen_exit {
 
 struct kvm_user_vmgexit {
 #define KVM_USER_VMGEXIT_PSC_MSR	1
+#define KVM_USER_VMGEXIT_PSC		2
 	__u32 type; /* KVM_USER_VMGEXIT_* type */
 	union {
 		struct {
@@ -146,6 +147,10 @@ struct kvm_user_vmgexit {
 			__u8 op;
 			__u32 ret;
 		} psc_msr;
+		struct {
+			__u64 shared_gpa;
+			__u64 ret;
+		} psc;
 	};
 };
 
-- 
2.25.1


