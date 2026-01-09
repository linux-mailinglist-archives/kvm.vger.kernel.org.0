Return-Path: <kvm+bounces-67644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 02643D0C848
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 00:19:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 230E63015145
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 23:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112D7339B3B;
	Fri,  9 Jan 2026 23:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4G4ZXYDI"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5C426E71E;
	Fri,  9 Jan 2026 23:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768000724; cv=fail; b=FGIWeomdnxpfN21V4nH38lvyOhKjxlcjaztUjaOltoc+091UnQRvQq7RGZKyMg4L4IJmaY2nlU6joXt+DygXmVH7SH5mRdwNc23RjAFItlpTi9MJ9mipd3yq85gpxcH9QjE0C2zkOIMOtcsW92CZlLwp0c557wqBk3/MSnVmQ7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768000724; c=relaxed/simple;
	bh=HS4dGD4DO6r3zG1qjj8X+6TajspIvgXx9kdwVAmD2P8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cUfaRmTv4HfJBksQXkz9o3A8PxsF1v+39M1ZWQPNHbytGp/ad7pRTaiAa1MvB35YEO1S1+6BZ/sqMDJIlU/fok7hszmdTXbNItuqEQQ9sJhKKhXnO4vH1M6lcgNPvAioTgVsgeewMhj9jx/6zbjEcR05cionXWOYF99BReHiykk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4G4ZXYDI; arc=fail smtp.client-ip=40.93.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/KjGm5FxmOhDTxnUOJz1nWV1eYhibzmDZ922RGHnDAvpT+ziOOuDCa97pBROL6jFmc/qF4s8sYYJe64fANGrrpP5AResBdVheQktRW9T+a+qkoOjsss4BeNYdVT2HmebZ/sh8VU5DDrLs1GJ6yheNbk8MS1dcBgKal8QYX9s+cyYdiCO6c+kQ1QpjswCg9vXMuztl9X67kCJNLiqfrrEl8veLhgaYkFz6Rr/eUVQmA9kSB2PKHH/OgY9FDRGT8MEqZnTo2iSeWNQtcQyRK4B7a6vWbHS00ewMDZ8j7kXqxHkQi1jklML2ZyO6t9P7eNTKVa/7itPe8USQw7OvnqZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Axc3rals8qbiJHSWdLCpnPzoDIyaa43dVNbP3EZC01k=;
 b=gumzi5rCCBC3Bx+YCyFhVa4o5H8nZ6aAfB7MDX5WQmk/YoCL95MMlEOWrLPk2fHXs3fUBJn1EBEtxBpETsEYCZ8EKpkMDnnPFtqi3XDnRrZqgAzH3Dado1FFiC7yyFvvAoWTjE7Q+v7/ONa86mg5ke64VH5m/3cq4tP5OubOvkjnwVscHuG+6keM4CDSTe49QqmAmeB/5GXtTjVPbccDei1uw73WSl0aFL/O6kZ+cecg2YG+z6HuEuuW6rYY6ipBKknKGi39nMje23Sd8moGY0lw44vhEvVcrfuN5rVMzqZM7X0r1GYXrAbngCmuhJ6p1sVr3QlHGwSKgnd63uWCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Axc3rals8qbiJHSWdLCpnPzoDIyaa43dVNbP3EZC01k=;
 b=4G4ZXYDI9UNKCWermVim0tuhLA89ZknOfAmjbA49KhAcFWp7XKx308cMSrgJt0sn1NujY/7HZVCH13UHJq2gnlRsEk7gLexCpChNc7Ba4Ov3nhoFlbQYD2BzFc1AxEmf2e2R3HnmRm+0jsqrg/RCY800cqFE2hNaTsS4eEv+4x4=
Received: from BLAPR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:32b::13)
 by SN7PR12MB7979.namprd12.prod.outlook.com (2603:10b6:806:32a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 23:18:38 +0000
Received: from MN1PEPF0000F0DE.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::77) by BLAPR03CA0008.outlook.office365.com
 (2603:10b6:208:32b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.5 via Frontend Transport; Fri, 9
 Jan 2026 23:18:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DE.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Fri, 9 Jan 2026 23:18:38 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 9 Jan
 2026 17:18:37 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <liam.merwick@oracle.com>, <huibo.wang@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>
Subject: [PATCH v7 1/2] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
Date: Fri, 9 Jan 2026 17:17:32 -0600
Message-ID: <20260109231732.1160759-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260109231732.1160759-1-michael.roth@amd.com>
References: <20260109231732.1160759-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DE:EE_|SN7PR12MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0f64a1-314b-452e-9651-08de4fd56b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ELWcwAhRd6SN1Aa9CI6CuZthV0kH9SoZNRIKIarEk4153pBdCmnfLnjnnTU2?=
 =?us-ascii?Q?dWTjQSTZ9+3aNHEw5KB/J3PuzG2hPT1He8+pmclcwoGaDFp8wHBqIfh/eT9C?=
 =?us-ascii?Q?yFqI+a4fdVmHGZRGQPq29HlnLXkqC1Cqy+qFMG53H9JjWE7U2Zr095UxCNup?=
 =?us-ascii?Q?KH46vGGGThQCqhEFoKpwqCTPk6VQKUf+PXT/2y/6zyV8TC4ccTuYIVPUmE0/?=
 =?us-ascii?Q?cPyDbTupMpOkC2MGo9BpJGDCLqg+Em4ApDMCx/MRYBvQMEUwlQq/PbY5AMRJ?=
 =?us-ascii?Q?tnsshYioQr5UhWwkMDhxRFgqe8LOcl34ITd+DiXw0pQQirWCtzHFuk5MrN+k?=
 =?us-ascii?Q?jyZl9pV4uahLXRmvlNBnYLKzdlx5OVXPrdWuzIcMzA0SfqcNSDn+X4pVcT+X?=
 =?us-ascii?Q?4snh3HYrkPsRy2XfmPF607WCmo23g5mgM/QpY7mInVe/ctRjqQS0o8oFx6Jn?=
 =?us-ascii?Q?woUpiIPuYiwXGmAtXZKvcLoJH8YrTzt8+YcQBZWhXKH7dx1lVbiO276yErtS?=
 =?us-ascii?Q?sG7eUDfMircpeAB/FXuq+yiUF7h9OtFACYVfPyXzTjbOOIjeLATcWFP5WrtO?=
 =?us-ascii?Q?ZM+CEkB+RrcYnXsPZevpSuq1Rjce9X3iyjQes95dueoMRo5rim5rI1KQVV0N?=
 =?us-ascii?Q?MLMFLt1eKYFu9lh9tz5vKfd/uT6H4CnQvf5cbZqbtPLvOWzrR6ZPXAMSZixz?=
 =?us-ascii?Q?owQpKxfeve+UlDuiK2rE34b/rvHxkN3Gl0EdDhvrO5v9Ylmvhl4ZcKOY01bh?=
 =?us-ascii?Q?biWg/qEBrOsFCFEgWhhPB0uTl1UCcxqfALALmtlSt1Xxlp9NffDuz0yeXyPH?=
 =?us-ascii?Q?1K7OCirRCmWh2sq+IkwYJCpINU6T6UOfcwNd2I6W+rstOqQl40HMsxKWLqJI?=
 =?us-ascii?Q?EwWhmjMlQyH/Vtm9mi+zc6CQWok6iGxL857DFS1zRCwKsSDrGiPpVIRWT1+s?=
 =?us-ascii?Q?LMjMs0ASSoYuhzGAUorYxLveiPXkrluXnhpNanihF7WJ2P6vo40aNE4Stm8j?=
 =?us-ascii?Q?+Ddd5K98mQyGQmCD8mLzNtmB1tt2nFIHARSyNumh4kRa0aKNbRso+gQT8pzN?=
 =?us-ascii?Q?UEhrM04sbySmnHgiC0LzC8bWPmXjcVUUg7VV/ibiu9qHZC3qxI6v131QA46u?=
 =?us-ascii?Q?/6HjjOj4eVhqKYkAAXHL9neq4iaHXE3aIoxCyAsVwF8JbUf86GNCPm9Ur5S9?=
 =?us-ascii?Q?kdDUzv3UXtr5+pUdfemPim75JwHgFKPLVnlp7JAOmGv2hb2w2h8G/35Yvkqv?=
 =?us-ascii?Q?dSFBzYyKVfR319Q1qE7zYpx/H0T/GRWxG+357qGuJ+SM+ZQNv324uDwd9gpX?=
 =?us-ascii?Q?UE46CGnAmIryP8dbELPDsCjIsQoNMWFNcOTeKKB4ZmtlgwhSYnSSv+ia7s3b?=
 =?us-ascii?Q?MwLtXE8aiNZAJSRUwG33YJl1owl8H1JasbzyUwLLZBsRoVlwvI/E5tIENWyK?=
 =?us-ascii?Q?5dHF+HqLdAObbeDdjhj2uaosxclUgLO6OgxYqgjBixoxtiwzVk8S5NO1wDVo?=
 =?us-ascii?Q?DgwxNJ+Kcp+T9zgwzmcR/JC8xH8a8MDxOUoiXA5pXABQjycE8tHpAbNdewNo?=
 =?us-ascii?Q?1IUdku5uSEyjnWtiTno=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 23:18:38.0086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0f64a1-314b-452e-9651-08de4fd56b54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7979

For SEV-SNP, the host can optionally provide a certificate table to the
guest when it issues an attestation request to firmware (see GHCB 2.0
specification regarding "SNP Extended Guest Requests"). This certificate
table can then be used to verify the endorsement key used by firmware to
sign the attestation report.

While it is possible for guests to obtain the certificates through other
means, handling it via the host provides more flexibility in being able
to keep the certificate data in sync with the endorsement key throughout
host-side operations that might resulting in the endorsement key
changing.

In the case of KVM, userspace will be responsible for fetching the
certificate table and keeping it in sync with any modifications to the
endorsement key by other userspace management tools. Define a new
KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
the buffer the guest has provided as part of the attestation request so
that userspace can write the certificate data into it while relying on
filesystem-based locking to keep the certificates up-to-date relative to
the endorsement keys installed/utilized by firmware at the time the
certificates are fetched.

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
[Melody: Update the documentation scheme about how file locking is
         expected to happen.]
Signed-off-by: Melody Wang <huibo.wang@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/api.rst | 44 ++++++++++++++++++++++++
 arch/x86/kvm/svm/sev.c         | 62 ++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h         |  1 +
 include/uapi/linux/kvm.h       |  9 +++++
 4 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..aa8b192179c2 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7353,6 +7353,50 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs {
+			__u64 gpa;
+			__u64 npages;
+			__u64 ret;
+		};
+
+KVM_EXIT_SNP_REQ_CERTS indicates an SEV-SNP guest with certificate-fetching
+enabled (see KVM_SEV_SNP_ENABLE_REQ_CERTS) has generated an Extended Guest
+Request NAE #VMGEXIT (SNP_GUEST_REQUEST) with message type MSG_REPORT_REQ,
+i.e. has requested an attestation report from firmware, and would like the
+certificate data corresponding the attestation report signature to be
+provided by the hypervisor as part of the request.
+
+To allow for userspace to provide the certificate, the 'gpa' and 'npages'
+are forwarded verbatim from the guest request (the RAX and RBX GHCB fields
+respectively).  'ret' is not an "output" from KVM, and is always '0' on
+exit.  KVM verifies the 'gpa' is 4KiB aligned prior to exiting to userspace,
+but otherwise the information from the guest isn't validated.
+
+Upon the next KVM_RUN, e.g. after userspace has serviced the request (or not),
+KVM will complete the #VMGEXIT, using the 'ret' field to determine whether to
+signal success or failure to the guest, and on failure, what reason code will
+be communicated via SW_EXITINFO2.  If 'ret' is set to an unsupported value (see
+the table below), KVM_RUN will fail with -EINVAL.  For a 'ret' of 'ENOSPC', KVM
+also consumes the 'npages' field, i.e. userspace can use the field to inform
+the guest of the number of pages needed to hold all the certificate data.
+
+The supported 'ret' values and their respective SW_EXITINFO2 encodings:
+
+  ======     =============================================================
+  0          0x0, i.e. success.  KVM will emit an SNP_GUEST_REQUEST command
+             to SNP firmware.
+  ENOSPC     0x0000000100000000, i.e. not enough guest pages to hold the
+             certificate table and certificate data.  KVM will also set the
+             RBX field in the GHBC to 'npages'.
+  EAGAIN     0x0000000200000000, i.e. the host is busy and the guest should
+             retry the request.
+  EIO        0xffffffff00000000, for all other errors (this return code is
+             a KVM-defined hypervisor value, as allowed by the GHCB)
+  ======     =============================================================
+
 
 .. _cap_enable:
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..2405c6fad95c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -41,6 +41,16 @@
 
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
 
+/*
+ * The GHCB spec essentially states that all non-zero error codes other than
+ * those explicitly defined above should be treated as an error by the guest.
+ * Define a generic error to cover that case, and choose a value that is not
+ * likely to overlap with new explicit error codes should more be added to
+ * the GHCB spec later. KVM will use this to report generic errors when
+ * handling SNP guest requests.
+ */
+#define SNP_GUEST_VMM_ERR_GENERIC       (~0U)
+
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -4155,6 +4165,36 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_req_certs_err(struct vcpu_svm *svm, u32 vmm_error)
+{
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_error, 0));
+
+	return 1; /* resume guest */
+}
+
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	switch (READ_ONCE(vcpu->run->snp_req_certs.ret)) {
+	case 0:
+		return snp_handle_guest_req(svm, control->exit_info_1,
+					    control->exit_info_2);
+	case ENOSPC:
+		vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_LEN);
+	case EAGAIN:
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
+	case EIO:
+		return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
@@ -4170,14 +4210,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	/*
 	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
 	 * additional certificate data to be provided alongside the attestation
-	 * report via the guest-provided data pages indicated by RAX/RBX. The
-	 * certificate data is optional and requires additional KVM enablement
-	 * to provide an interface for userspace to provide it, but KVM still
-	 * needs to be able to handle extended guest requests either way. So
-	 * provide a stub implementation that will always return an empty
-	 * certificate table in the guest-provided data pages.
+	 * report via the guest-provided data pages indicated by RAX/RBX. If
+	 * userspace enables KVM_EXIT_SNP_REQ_CERTS, then exit to userspace
+	 * to give userspace an opportunity to provide the certificate data
+	 * before issuing/completing the attestation request. Otherwise, return
+	 * an empty certificate table in the guest-provided data pages and
+	 * handle the attestation request immediately.
 	 */
 	if (msg_type == SNP_MSG_REPORT_REQ) {
+		struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 		struct kvm_vcpu *vcpu = &svm->vcpu;
 		u64 data_npages;
 		gpa_t data_gpa;
@@ -4191,6 +4232,15 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto request_invalid;
 
+		if (sev->snp_certs_enabled) {
+			vcpu->run->exit_reason = KVM_EXIT_SNP_REQ_CERTS;
+			vcpu->run->snp_req_certs.gpa = data_gpa;
+			vcpu->run->snp_req_certs.npages = data_npages;
+			vcpu->run->snp_req_certs.ret = 0;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			return 0;
+		}
+
 		/*
 		 * As per GHCB spec (see "SNP Extended Guest Request"), the
 		 * certificate table is terminated by 24-bytes of zeroes.
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 01be93a53d07..eac1cbd3debe 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -115,6 +115,7 @@ struct kvm_sev_info {
 	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
 	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
+	bool snp_certs_enabled;	/* SNP certificate-fetching support. */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..8cd107cdcf0b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -135,6 +135,12 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_exit_snp_req_certs {
+	__u64 gpa;
+	__u64 npages;
+	__u64 ret;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -180,6 +186,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_MEMORY_FAULT     39
 #define KVM_EXIT_TDX              40
 #define KVM_EXIT_ARM_SEA          41
+#define KVM_EXIT_SNP_REQ_CERTS    42
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -482,6 +489,8 @@ struct kvm_run {
 			__u64 gva;
 			__u64 gpa;
 		} arm_sea;
+		/* KVM_EXIT_SNP_REQ_CERTS */
+		struct kvm_exit_snp_req_certs snp_req_certs;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


