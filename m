Return-Path: <kvm+bounces-16306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CC008B8713
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A5941F235B3
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA32B502A8;
	Wed,  1 May 2024 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uxy8Olep"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7A950288;
	Wed,  1 May 2024 09:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554147; cv=fail; b=oAFWFNeBV3hnyYIAUHx6d7vlGHz7OKXmx4nmSIz43bO/S2TS+qeNojAIc7USiwYkBb3wciAowJNmj63E1sIObGLnHblSyqHkARc0QU8nbLGaAHuGnIpiOt8aMF5CjrkZx/uhjSSTrA+0mx8P+HUF92syb0qmGyx+QeAnrKW3JXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554147; c=relaxed/simple;
	bh=vDgJ6yzjZQxXkKig1glRTC6baWdSj5iWeNpILl2GWcs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mr6T1r0YP4o3W3uzNWVoVJUKiU99j4Av79m96Mq4TamhV3VYiYvgyTi5GmYNWfGdFx/L2caoGx2321GhX4uDt1s+ZrT6ss8I+3BuThs7lZRIdGTf2HvKlJhQLK6d+PqVYY4E1oUpjxW7pov3AhNIm6iaAdSvN6s8xYTYblYNWjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uxy8Olep; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G4ryxOPEzp3+sS5EGNwVMD5wDnXIz1Rm3MsBAEM/7gj/MqeybA9fT+EgCl/6+2quVjNQEh739Wx0aGEM6xchcTgJorzo6bVY/oOZswXngVOPkBYdPkcbYJoKZJ+rI7L7xwhOP944VQ91RGSTkD1EDNEEVIXvYhxHaucXjx/DL5Q4r1Ly3WiOydnyxQccVqdVZmZ/sPDqzIfHnyggeexkPFoFt8FzmSqQgEX8NdHBcsFy+Fo7peg3xMqtVA4ylTyNohrSexVPr1DnedGCFXUgvkDjJrQvWQqH+6KUaVn3WrZQMkn/WISrLJTo3WPCbeRgIJiYB+jLbpavzNTkmskh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bK20vcWucIreIaSDh3sNBwKjRQE7GxXQ728dKk/YFZA=;
 b=D2bz4TxCz0J2PktU/C7cWimAfVsdH8Mcdl0HFVO5qxQ7BFC63x7DT5APGRqE8FYPdh8i7RQd0QNi0LlVND6/Kf2xw5pwyexAgf6e9uEq+XbrFoaYjXhQ+V/+59ZazgTdWveOwIOV7VMIdAWqu88YS38LkzHzptUMBn6qa1tIUvaufzUs/KIPztENL/S6cug93lJITtg69mv/+ivGGoeqDvxdG0+GI/FZCjfvdSLTS2daux4BkCeuGSJNBGUVyQUgGeDaH/2Vcz/GE4fIQKyNjA/QTSmzQiTb00IyFyOTjdxs3zt9+HcvBZzq1dAxnl7jJDlJK0GMbjcH4ncObq3OQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bK20vcWucIreIaSDh3sNBwKjRQE7GxXQ728dKk/YFZA=;
 b=uxy8OleptnA5XhKkoZXWbEBz+BDGiDOt0sME/G37M2DsU/vKG4/R93IoNMt0GBssh7rkAF3W23dsp6fErLwPRNNINoGBTKnZLYrYZJSFkHx2v0yJJm3qJ+vlctLWHHaXadVVBkTp1PgX89kjdgu7DArvBPqELHLlYJejdMpztLE=
Received: from BY3PR10CA0021.namprd10.prod.outlook.com (2603:10b6:a03:255::26)
 by PH7PR12MB7794.namprd12.prod.outlook.com (2603:10b6:510:276::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:02:15 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::a1) by BY3PR10CA0021.outlook.office365.com
 (2603:10b6:a03:255::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:02:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:02:15 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:02:14 -0500
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
Subject: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Wed, 1 May 2024 03:51:59 -0500
Message-ID: <20240501085210.2213060-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|PH7PR12MB7794:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ed4a01-1b45-4bfc-24f2-08dc69bd65af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|1800799015|376005|7416005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ls4uveIgbbjXe+xVN9H8hYDP49MkXr8mngw4l+xatvlPXX0Hgg3W3bfbVhNQ?=
 =?us-ascii?Q?/kA5uo62F6gk/55N6bHbw3VnUwO0e0KyNtvRJXyN3mvi4jqdixMMwX/Yopf1?=
 =?us-ascii?Q?tk9ZhTKokWSXsDH4tuYtylRLbFzgSqM3oOr8PFYSDVUOo3bO0IP67aaNrKFn?=
 =?us-ascii?Q?T7BujQOaZAywsRcFdOEyixzqyw5SfQP30dtke0+prINgOi9xHRZqFy5oTSNm?=
 =?us-ascii?Q?rTfoVtX+OenaIz6vy7rI3x0SRdCT6JKWIpbNOobAiiUU38LhdcFTYN3i9o5u?=
 =?us-ascii?Q?B3OtJNinTYHnXtKRAbvJWVkiJPoVusMgiqsLWc4Y9clLjMF98FSvdyhq+wjr?=
 =?us-ascii?Q?wT6UzBNBrbbO9mQMt3C2i6Np2tpv6Dv02wL4qD6zXXejxe5QI/25dUaxKesl?=
 =?us-ascii?Q?9aizP9cIhu8cGvD9HbrpfAKVWW5Kar7OA2NB4swOouC6ToRjh5PFEX1bfE6O?=
 =?us-ascii?Q?Fa54aSJsIH1HWvIqZd41et0+Ftq1tO+w4AT5FxlBffENg3QpUjmBf6HjC12B?=
 =?us-ascii?Q?vbQlIWy+biTn1ILKdNG/dAVpwqCaBN9Di7bH16fMACiZxqES0U3QF0sElVAF?=
 =?us-ascii?Q?vl6rfhVuV8CyaC6/nOxMDjlpU7G4wvfN6FH0pq7Vp+SquxKNFA6yR16KeC0t?=
 =?us-ascii?Q?avUTNv+dxDsZPPJ0IyYMI4tLQr8heAyLL26q6MqYQtyqNMqEk2+LAKycFome?=
 =?us-ascii?Q?OTGfFUJyCGZ7pFL9OEnoOFsHhkI59x25ATQNGFVILbsQPpMjPZR8Zw+X1oO7?=
 =?us-ascii?Q?oWvjYrwJbFTaO8sWZqTtaI20iehkB7hAYMv9+nY5eOa2xRs0ZkLpP3Dqrv+H?=
 =?us-ascii?Q?Fs9JTQIGCBXBcHFTfNkxzB/QfcasfwjqoHylWWx0oRKq+8sawG/9hc8vejvM?=
 =?us-ascii?Q?aZqk3nDvC3OyucJA8BjKa0BPnBw7CyXrQqAsJC7+E4DjHvxMOO0Gn8w34m2x?=
 =?us-ascii?Q?Sg+CY6kyHphOdcgDzAFxisjxLlB5XZzXGWn+PGyY5Lc15Ude2pn5jEqWs/dN?=
 =?us-ascii?Q?41v8I+fwc6IYFSk3s9LTY6bA0QBBWJRhWdLy/t/7lJSozQQ/iJTN0DjmlIxU?=
 =?us-ascii?Q?eYOCCxvW3Rn6hvBgv0dO1u6ZSxLkczHrofkvmqs9OnMeATKnrzrtIDgouA0B?=
 =?us-ascii?Q?0URiSDfarcgN7d8goIslL53REvpc9bhnWWs4sed1Ay0SpKtSIlup2iZalHpt?=
 =?us-ascii?Q?BIY6YgCzvchm3Io/cXNDFLYYWJnZmo4xxDSz0DAo0DFYKK8KwkFmv+vYpHu+?=
 =?us-ascii?Q?M32Y8RW/vsvZjGZwOW0+sDURmcumULYSs1R+4T4WAMa5s8qinu/qF9uiPs9V?=
 =?us-ascii?Q?dPzRVyhkrxRwPCFClU2UaJKM19YIwHN28c2sVfRoQNQH5Z37xzYfjM9tOxuG?=
 =?us-ascii?Q?PW1r6ubgg+lMyybeN3kWGE7WBTaG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:02:15.3761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ed4a01-1b45-4bfc-24f2-08dc69bd65af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7794

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

When using gmem, private/shared memory is allocated through separate
pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
backed by private memory or not.

Forward these page state change requests to userspace so that it can
issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
entries when it is ready to map a private page into a guest.

Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to deliver these
requests to userspace via KVM_EXIT_HYPERCALL.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++++
 arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1006bfffe07a..6d68db812de1 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,11 +101,17 @@ enum psc_op {
 	/* GHCBData[11:0] */				\
 	GHCB_MSR_PSC_REQ)
 
+#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >> 12)
+#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> 52)
+
 #define GHCB_MSR_PSC_RESP		0x015
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 
+/* Set highest bit as a generic error response */
+#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
+
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e1ac5af4cb74..720775c9d0b8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (vcpu->run->hypercall.ret)
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+	else
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
+{
+	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
+	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+		return 1; /* resume guest */
+	}
+
+	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+		return 1; /* resume guest */
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+	vcpu->run->hypercall.args[0] = gpa;
+	vcpu->run->hypercall.args[1] = 1;
+	vcpu->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
+				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
+				       : KVM_MAP_GPA_RANGE_DECRYPTED;
+	vcpu->run->hypercall.args[2] |= KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+
+	vcpu->arch.complete_userspace_io = snp_complete_psc_msr;
+
+	return 0; /* forward request to userspace */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3566,6 +3608,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		ret = snp_begin_psc_msr(svm, control->ghcb_gpa);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-- 
2.25.1


