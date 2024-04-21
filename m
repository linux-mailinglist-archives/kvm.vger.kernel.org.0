Return-Path: <kvm+bounces-15427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B248AC06D
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD621F2100E
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883E93BBCC;
	Sun, 21 Apr 2024 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JvRezQBa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302083A8D2;
	Sun, 21 Apr 2024 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722628; cv=fail; b=UatMsZuOsVmIUNyLUAqxgg0lVqPl2ODmZ/CDOszNvlolVwgn1i55WtkkQ9Hd0n2dajFzUOJKzF5lL0IeSeWRof2s6AaHyPIjymnwyoOMMOFGSKV7l5XekO+JL8Bo7Az2qgjDTke48t/mXq9D70Ml2o2KYYdNETeu0DDPg4DaQak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722628; c=relaxed/simple;
	bh=sSorkJ5a3jreJ0pWBnowAWuXMBuft4DJJJHSBt/aevE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFX0yMxodgHWmGsPXBQ5BG5eyi7EeuIBwZ+lhnqts1lE6QSXRd5a9VA/QyXQD8cl3zTpfoKSpr69mEo7CBvsc3l7EpFOOxwCbXhmWx/ac88gWX8yntci4mwX9VI1HqydDvVOKHviQoyVg6vebQX0JQSLcqagiSn0r4zHDiyAL4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JvRezQBa; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWMZxIKKCOTyjKlMfmtFlVAhQRPa+lqPTugnaczSdFJfR0KHafuWDe/r9AnD8us+uxxUQva13zZg1n/vFt6VFl3jYcDHhQjEEZeuz8gHBP4i/+OrSshyesye2rdEB3SYOdvosmH92V7soQ+pJ01XVL94I2KeXuaZxAr/k5NuoNepG3F5/djh2C1GpVwGpqzclV3wazLpV5F+kxCGWF+qg4uxSyjPSGZIxzUuyyWZpB7Q09bGnYEvnwXsdYZfKYYsgWM8m0oxoF7fsJmGebvPP4dmI+YEztRkXJGJsmQPK7J7KkBhQY4MzGjl4faTk3PlWnp/D8U6VYr4mshr2TmweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vbdpkwf3WqWD2bfPQccxax6mE79R6wo8R9w46YmoB1c=;
 b=SRXC3mpifNL6gN2QZS/KHNRTwT8BMtmgFDDkF+LayjFeTMbtzVYgMs+iK9xlxdHe8hvvGZeMQlmP8+7S8OJuZamIMhkniNmGWluH77G5P+ckwtznPHye2IZ6oaFP//WUeUs/Hvhoo6CCaZ1Gkd+GVvc2u+QaSp1wbcAGb0AZ+MW9T7e9WpQclJZzbf5KPMtlNfNoov76UWJgUztajH7b1d1XyvyADpS3sq+x0WTh35RIV9fHyKTqaoorQh9/kwCg0lPdLc3prG+VAb2PWR5RXHPZ4y8yL7JVu3CGLunfusSB8JATc3wyvoAhU1GBMnwVGUZisrUmIb6XA+bzNN0VAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vbdpkwf3WqWD2bfPQccxax6mE79R6wo8R9w46YmoB1c=;
 b=JvRezQBaMPaWbdn4phF41P8uG8BugrQItXisyfdBeHGjsX/EgkVUsKZl8Ddf7uE0/erDs4ECBabR0CzSHrH7regxcU6CHPko1ac/7Ze0rEh082LVk7Ufad/GTqSDy8EtHLu8BAo4dmSjSEPNoAgJKUeIRJn30joYaqpEW/F1TL8=
Received: from BL6PEPF00013E0E.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:f) by SA1PR12MB7248.namprd12.prod.outlook.com
 (2603:10b6:806:2be::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:03:43 +0000
Received: from MN1PEPF0000ECD8.namprd02.prod.outlook.com
 (2a01:111:f403:f902::2) by BL6PEPF00013E0E.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.26 via Frontend
 Transport; Sun, 21 Apr 2024 18:03:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD8.mail.protection.outlook.com (10.167.242.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:03:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:03:42 -0500
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
Subject: [PATCH v14 10/22] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Sun, 21 Apr 2024 13:01:10 -0500
Message-ID: <20240421180122.1650812-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD8:EE_|SA1PR12MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 06924529-0962-46e8-e5c1-08dc622d61d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Mz+RDQ/eZS4yQYkTQY3DfIPzAWcH6JSWdQex/i+0YpBx9ulgiyD0lkw47o0?=
 =?us-ascii?Q?ytsj14sY34po9GX88Mzbe5v9GMlbGA3kVk5qMigXkxHkm5UPzTIh8UGV4cj4?=
 =?us-ascii?Q?P2AK/uDJqSrF24/giWzqLIT7hMgzq0dEpKNpId46GGIJmfl9+5AYMKKnVcFC?=
 =?us-ascii?Q?C9zaMnFvdSNr/H+x8B3jrZ7Ldt2LwBxYqotPmsCHyMYSgk2c9bK+m9oVGUad?=
 =?us-ascii?Q?7JVAfpc48ZeQe1Xtb/Sgskotne5J4DYfruh9RyZXhtIVLBfIJ9kMBpbn7usk?=
 =?us-ascii?Q?h5cuV+NLeRAxNMwK91a24vI/H45S34fiy3gNf0w+Qb4uN/YQ+IIgwo7IEzaI?=
 =?us-ascii?Q?eeNfSvH2OXZPIvkKi+Bwn2SLwjzSUWSbfWn4Ae7KMaJouz5KU6CGua5BW1yw?=
 =?us-ascii?Q?QIvx5vbwcU9prqjKQc3pcwroljCx4TVgec6iuvZaxujfQS4D/AVSlhM+Zk7d?=
 =?us-ascii?Q?RmvOBlOijEGwHoomno92WQIBhW8/YhfNbPKDQ/DfRtTr/2qWfDERmPQtx7Ie?=
 =?us-ascii?Q?GvwzttRSQEFOfkQHzgeEoq8FMYQsV+T3e2EQiM/Lmy4//R1YdX2xcdFHZ8zY?=
 =?us-ascii?Q?e1OKszvTYU/O/g6ALS8pXGauuejMPk08Fcpg5nAXZodS3fUUKsJcj3AZsI2q?=
 =?us-ascii?Q?N4epO53cu4ZIChqyNuFP1T7fQHMwx8zfh71v5XMerofKZ+kEJgZaFfi5HQgA?=
 =?us-ascii?Q?BKJxaNE4o9v/I1m8iSVfl3lg+4g3IJ01GIhp0bTl0MFH+nK3z/Bq25H4u8Ai?=
 =?us-ascii?Q?ivPJK9QZE2FGWV4aF4K0qZdk4Optn/pmI+hU0QlsQ0uXdzEwZoa1TMHUQch+?=
 =?us-ascii?Q?Bz3UNFXNqMjq/rIdgE6Bqbh7R8YBNcZRjXaDFemPDpKEgD7fF9U5gceL/MTP?=
 =?us-ascii?Q?KY/THIHd+sJsb2/HAm3M9v1V3/OXJrwqDoCtIJ7HrwW5j+KeNk01zKTsInkF?=
 =?us-ascii?Q?bWgIYPU1AiDwnBcY1MpVgip2vGu64Cb05eG9cw5RQFfVclkg2LVtdrwfUsR4?=
 =?us-ascii?Q?6v2+w/UQnKciWG0Pf9CgFvjRXDDCtavliayHk+hwiiJAp4hMnNJdTZY5Rlz+?=
 =?us-ascii?Q?Os2xPVQM+AnP/+/3I0aVpLPaoYRvOs8gFofZrGr9tqe29hEVGZ/d2bgqT7Cp?=
 =?us-ascii?Q?BaaHrbzIc1kLCY8unPvpDBqMBaZJaEwlrDacNBrD6uFhEJ9k1gLeM7rJ/tmh?=
 =?us-ascii?Q?pFBxeXdDAQtR7WvmIDAwRUAZVMd44U+DguFsH3kd47y+w6WDjBp1wxbQiPt4?=
 =?us-ascii?Q?GTIpWOIkMWJyzg3hFr4Zpasj6Rtbkv5PYCdjQshax3qB7gZ939R7twbeNk0D?=
 =?us-ascii?Q?b+G/fj4IwOHWlq9/dld4826z/xd2u76DLNigmf5mOulQ4GxIa7X3MrQdEz6r?=
 =?us-ascii?Q?k8KVurc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:03:43.3626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06924529-0962-46e8-e5c1-08dc622d61d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7248

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
index f6f54a889fde..e9519af8f14c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3275,6 +3275,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3493,6 +3494,15 @@ static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
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
@@ -3730,6 +3740,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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


