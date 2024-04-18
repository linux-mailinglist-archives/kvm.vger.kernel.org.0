Return-Path: <kvm+bounces-15143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C368AA32E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C7351F236D0
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBEB190670;
	Thu, 18 Apr 2024 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W2NMs6Um"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5481F180A91;
	Thu, 18 Apr 2024 19:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469455; cv=fail; b=NzN8th2HH+iX3ntLBYEkB2iml4+9DlRzAjCt3zx0cAwJXAQ6EMuj12oJj2VPoXFRD1fPmxa446/k0oYxnTXe1uKlGjD2yTEdpCbLnYO07wvKpHQyZvw+8Oq4chzvB53AL+PSLWpfPulo/LeZhnoPyKrBmfTXA5xzOJwCfzBTeyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469455; c=relaxed/simple;
	bh=NlxgjYlTSO1Cr3XhhetXI+uHu5U7sabvwe0aabou9hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuJfuHM/NCrkicrhQbbbQn7x32pPe0L/Cl0+KQ1G0VIjS3V1RCOyl0VhzRosH2T5p4uzTPpRb0Thmg90yZcQUOL3QMjYWZBh1J8/+TsQe+sdSsGscUXGR0fIScV1Y0fnboZ8+vaTJ/mxp/JIVc8Yx69tLRl1ZZyJYL6DjfCGrIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W2NMs6Um; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eV5kZykt9jr/mFrNj/tLrPp69XqBMtbEFdZ6Uh405mWq6Zj9otz/zgMKZ0K6BGLAiKjndNa6He+dvcgXu8HTaeXxHed4Ee4JMdapYq2HPkQU96ImvnW7pifsScmVLmL2BzFlJ3IbdpRzWZHg07Nn2sGlsBtzV1ijGnOshNOe+u5zKQ5kMN4dUqzF/zNFehF6+iKiXNjmu6vWtdlVTnuchCTm4S5SsIoMh4zSNCAYNtysgfYlha3hz61VeGz77uC3eTEpkLVFFSz0f5q05zdeibocm6/xjLmRCwQlBLcNs6vvNIpFoPk3u+ttu+eNkDxPP2XV5NlioBVaYXihri365Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+YMl+OqmHHJKwXYIR17ZTGKqiyBV+wF+b5Kiw15zh4=;
 b=cFI5UioEbvUegm9d6BeHQrSEenUacg1pMLYpOqSpbP+oQqbUvA8xOTWQnpx8sIdBMt+FKafoWGIoYbXEpil5QXhwUUtP71SysnWmS1tWJgoYLv5UKFUL85PgK7t38992J1d978vjzuAQCbrERjH9KZLYDQAG51cRSBc+QsYIaB8odZr86sShz/S2l6DvhYRGRIJvI7sm+0BmTp7iQ1+lz+ER/oNCp2wax/ZJV/8+dvaQNQEMc/VoAvGEX1GL8csEpW7+TTZ3hk/b4tynSzksjrOoFeZoV64Vu10scHUNOOG6Za7HSlpx/iKZl2LvcW8+MMNqhicGcQTfoPT/8NsnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+YMl+OqmHHJKwXYIR17ZTGKqiyBV+wF+b5Kiw15zh4=;
 b=W2NMs6UmwO3KmFwNiKoMKIg37DM6d1IOahpLQO8LVnrAuFtk92NZTOi8l6sPn5qSJYGEBhVQ3O4B8zB+ccieWC0zMyQT526uSlH+DupmUTyxU1v67X3qzNGY/l42DXYcysCCgPZICIdgXM/x2VSal341z0NTDkIsyqX5Yx+DG5o=
Received: from SJ0PR03CA0158.namprd03.prod.outlook.com (2603:10b6:a03:338::13)
 by PH0PR12MB7472.namprd12.prod.outlook.com (2603:10b6:510:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Thu, 18 Apr
 2024 19:44:10 +0000
Received: from SJ5PEPF000001CA.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::78) by SJ0PR03CA0158.outlook.office365.com
 (2603:10b6:a03:338::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Thu, 18 Apr 2024 19:44:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CA.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:44:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:44:09 -0500
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
Subject: [PATCH v13 14/26] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Thu, 18 Apr 2024 14:41:21 -0500
Message-ID: <20240418194133.1452059-15-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CA:EE_|PH0PR12MB7472:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a57e676-5a0f-49a2-8889-08dc5fdfeaf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zKYysmAWyC6BnAcDIF+mvOCejiJhyylLPhsblWgT4M+EYqxL16279s/TJDqrlM/TRQVvezBBHsB+QULMmf8Bwa+fIJl7zYnJ6hGtYTiBYhgkNIOAEYoWZkYVBp3RTkhHd6gTUbikXNysyUDEEHBDu/o5INf0yMexJu1R04vKXWB/t8FrZdqdrrLjkXNOLI4msB1zI6IK3ylSM0tU6QbMolI8pBMsTaXOptABPBwiWe47uqBfwKu+Skxfzs1o+KEqYXcZeqwainxTBgHS6POXlQD13JRfZesoKDtkmSdScCLKL0fLO50sJGYj8vKnp3rgMgR4Lsy+X2Ts+DKf8TV7+9yc2SkspvrORHwnt1nTMQDopkyzT0RQkhT/TGJyEV/YehVgUWO354fYJ93B8JrXNawcO8Cx+hgm0GcYBJColiZnaXBY5qXCK+eljeRVmigYaIZ+hffpuDfs5jAJO7lKCBYSDLGr+6BW7fa7z0IIE6aTYDKDWskYheKdwrB2QEiwbGuOZmHIjFrC+X8qmxsMaj8l2m5oo78N9UvuQJIs5rBTO7FJD20Bc9vKww3h5k217H6ZC8RqaiPy278daY2w7LHag9ToJtt31unwcLqvpUtGYUISH6dUwQ/hEQlsYszQMXgcfkUloUI95R+DVHkdUj6QbFePm06OQxq1obSYyAXIf/43qn1tKXVibuFCZjCwM5bxXt7HW5kum+32ee0lbMf4HzmsClIEpOgxmcaP1Bmv7xTiEka8hujAObATe2x8
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:44:10.2954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a57e676-5a0f-49a2-8889-08dc5fdfeaf7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7472

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
index e982468554cb..96e24a1e34e3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3266,6 +3266,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_PSC:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3484,6 +3485,15 @@ static int snp_begin_psc_msr(struct kvm_vcpu *vcpu, u64 ghcb_msr)
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
@@ -3721,6 +3731,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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


