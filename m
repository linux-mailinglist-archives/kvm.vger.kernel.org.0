Return-Path: <kvm+bounces-15448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6055B8AC0AE
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:11:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B993CB20BBB
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333243D0C4;
	Sun, 21 Apr 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lQ739nUT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC6376FC;
	Sun, 21 Apr 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713723077; cv=fail; b=NkCFVF3DpSdWYMSZbfhJnFOIa64DISnC9LVZFxGQ5EW3fkc1WXMJHlHbpH90ESzRkaYvIyBRUBAXh5VwjTs5xRZ6mrofENwl/sKBAZTvIYD4NpqV11cD5fQrRhVZ5cXlboc4hR/Kht8j92dBW/8HMrgWRwmMJRWVAMgxcmlWgNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713723077; c=relaxed/simple;
	bh=t0mq2QnXSE6Vel1/VZ7mnSDN7v9dGDrTKuhiwRhiNBk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7zFc9XrIgRqeAw4xZWSiRnMslC24wVpzAI3yg8rer//FTukJUWdK7qP/KfLK6bKwMv/8Mf17XMcVQrmsouy0h6szM1Qn5xIhiu0LPw1wbUynqWO16NPQTxsabGSrzBtzgzGvr/6syEV9Mvgvfmqi0fCKRhnMyrHl4wJ48pkaqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lQ739nUT; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkmHTnDXGqvKb959gGSGuUntybW7bHMgjgHEUxAqc7yIwsVpfuQcPwWimYLcd074WoeBmbJ5a2YC/Y4slDxcmoeLnw3yvXAc06381K9gXdgaOMyLrQoAjFuotcfpGjB6bbhvAuUKMUxmzY+paabb1WV7LaBtGu+QnA7MkvN9vIaLkykVOGhYje8cSvVFOCX4sozdpKe1Kl5TKXKemOhOfiLDvjJI4sbhdzHEg+34nZ1a1HvfND9egczISAcMGjCVjKVoI7Ycfxlc3Ak3blUo871Q8YCg1yDwyPORfgpVRcSeTGLeBk8dT18n5WiMG79efTuotDxgcE5oAHaMUlJd6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkoJgGls1EeSRyZ3p+3ldCDDaRRNh/kfCmt+Ww644qk=;
 b=bEYnOSJSVHwVm4XAhcGzil0fFGNdP1+RlJteGyAKlBzGmh6f6u/G1+XP7WdZK1qKFvBXJ+zj28iXy9eEVeDNmoJp/b54U8ZrFj1r5/PPmBPq/SZc3FPoD7U5VziDZvRIHHiVvkIunwV1VtKvjX/0oqYIxudcpiOmqy6huvaV6g2kA+gImkI3fYRyOWmyRM+oCGTbgfy7O2O1Ygrk19aJpvu21ICvQ5ii/gcdlXNyPcnkAf5KywFcZf67r4JfmjtMASuGPpljYP3DQFSJ7CaTjkfM0UFZEXoqiwOz8+zU3Qo0jJ3rqifv9KxgRMeHaIUB+kCE4yuTKoD2tnlupFzkCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkoJgGls1EeSRyZ3p+3ldCDDaRRNh/kfCmt+Ww644qk=;
 b=lQ739nUTldDzCkPUu8sUao43YNzc0giCUNmuOFtUPrQCbBFR75WMKbpiCDXovrO+jXL9uNlS+9xzQbzlAuojVsrlZRQ8h+yETRVAc9YcntUo/yI8v5W81pk3VXrPXXCKHhQbP1rsUC3qJqwksFoFNXJbF1RfKar6ZjSidccNZeQ=
Received: from CY5PR15CA0018.namprd15.prod.outlook.com (2603:10b6:930:14::14)
 by SA3PR12MB7805.namprd12.prod.outlook.com (2603:10b6:806:319::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:11:11 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:930:14:cafe::14) by CY5PR15CA0018.outlook.office365.com
 (2603:10b6:930:14::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:11:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:11:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:11:10 -0500
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
Subject: [PATCH v14 08/22] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Sun, 21 Apr 2024 13:01:08 -0500
Message-ID: <20240421180122.1650812-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|SA3PR12MB7805:EE_
X-MS-Office365-Filtering-Correlation-Id: 548ed092-99a8-41d2-9a19-08dc622e6d03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Oi8Q8RS29bk0s3+zAJZUIn6DdIMOwHdrPgBVFKPi1q2boPyn/W+w/V8aqaEp?=
 =?us-ascii?Q?9t8oiuXPOwtZn2DS9YdESSeT8zKInYqSOYPz/lBB8LSvqMTwZLc8vDNRgMKt?=
 =?us-ascii?Q?39eJ2Klo0mukQSQCMx3ob1BVllJ9Papi20zjerw5DZk9ZwQY1hPHbPgS84Zq?=
 =?us-ascii?Q?OfhHZbBIIB8POr5SFnqgvN3eybQXzYsT66npLv3pgmUX9H56zsWA/QTyfQyS?=
 =?us-ascii?Q?+Dg7b7/2Nu3aQHd7ktd9+chHvuFmzkB0eRWBLgz+fjfU/Gl0D09GkUtL8T9J?=
 =?us-ascii?Q?bH+IMLkrPsYjeFLR6Usi4Oteh34dFbavfAxZ8PwUUi7c+aR3aKMzke4AC+h7?=
 =?us-ascii?Q?we89WAuaR0CTOgapEaIRoU1N6aBD6tnWeGHKNj8UNFTGXDex1mjATAEMsNZk?=
 =?us-ascii?Q?T3pUcuUWlclqATMIvuAuaAG4AafRA6bHlX+gU7WypJKaF7IzLPEjaYy4R+jC?=
 =?us-ascii?Q?2VmpplwHhz+yi0TYML//IIIm38Z2nl+tdKr80yIZ+aGrHziFYWLMX/DAG2zd?=
 =?us-ascii?Q?zc6m8CpOug5PFCeuCrkt6UgwO0PGFmmBY/hIuUJTecBeDOaQepaTn3i9H2JB?=
 =?us-ascii?Q?B8ANa4WebIzxJpVUZKQ1AlaHC7gvjn2r2/L54FLORG8yUXhgEdf178IjkauP?=
 =?us-ascii?Q?wE1mB7v6NsWkKEG/UFhMP++pVG2tMyMUa0FtwkoTvL/c6m9EKuZkIrYjxVPE?=
 =?us-ascii?Q?sZr15Rul5TuAPJMOdaVOXPEUwxbYCUSOktb5BpzyP+mRzw8qUpH1uDbdtgKA?=
 =?us-ascii?Q?r15hRg4WIV08HZ8rtJfhu6Mq76zFChROhygN4RtFzthk3suJTsO3qGlWrJ2e?=
 =?us-ascii?Q?QboRyTy+KHxECt6UaMMAND63OEj761DihpxNEGPq/ib1vRpUaIWYzXRQ57SW?=
 =?us-ascii?Q?7kPPNZM7czAj2Xb7OH/knvi9nqqcOdqMva4NCV7y+M4tWWi5gSVqflxzHivx?=
 =?us-ascii?Q?ToWHU3EA9vufsmTsWlm6BVpgMH/oRCXwwcjqEecw/l/V/rL4l3rDxKv+7pTz?=
 =?us-ascii?Q?GnZQs/N95jtJvXqnhGBfMJfSCugeMGcUC6pIdtQfVpwIn0DApZloOQ3MrIpA?=
 =?us-ascii?Q?GaR7w1z5cBIY6CfJDReta80rEaL8BYjXJHxVkYmM99b0r2FjI8xN07hQa1fZ?=
 =?us-ascii?Q?NXrOO5DBYgsj0oD4XKpRXCBqWBFeKB1Yt/ohytb+hXQX0tXoYjI2mEbkHq+F?=
 =?us-ascii?Q?ZMzbf7zwVJB147ySfUpyny9plH5wesm6ohicuEpqGjmOzcUdLDsgO/D2w/Fs?=
 =?us-ascii?Q?iSYuCbN0lejW6k4DigymjoT3vPUeWFPhAY3a1HHk0KuxHB1C/mEoDosOq225?=
 =?us-ascii?Q?vcDH4+SofjFXY5cBddL1iLVdGppayEU+HF+3PH8z6tuTWxEhGKfDunxKQYGr?=
 =?us-ascii?Q?VQTLfN0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:11:11.5800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548ed092-99a8-41d2-9a19-08dc622e6d03
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7805

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
index 6ca1b13c9beb..76084e109f66 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3541,6 +3541,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
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
 
@@ -3604,6 +3624,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


