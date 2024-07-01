Return-Path: <kvm+bounces-20810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3962B91EAD5
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E9A9B213AF
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 22:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4647171664;
	Mon,  1 Jul 2024 22:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D1O4eZEC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C216171095;
	Mon,  1 Jul 2024 22:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719873238; cv=fail; b=PxdCyJszezgu7jefrSVlExUnGFD1++po0lW1PWtOTdhDCa3wKkM+T7rrzC8AFeCYPcYzjKbY8FBzgiyIQwvbyFVcjwGRkwCCVkGKQWq+Z5Meq2i1wP6DR3ibwirOJ70+0NkCdmeEdgJO5d0delp9TS7XZvKtSL1kpN/6/i4jVpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719873238; c=relaxed/simple;
	bh=02EN1tw1S2lZnKUP8fSPNPRBnjkpzLPGtE4iIIPOGdI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nm57MD1fy2eOkCOKp9m2sSe8UwFDPHfvnlZruPRgxGA+cuVTGVY1iC/vD+n8eoxDqEM/qHNemFaaDKf6BmlWvceIaNqnc1ANIprgyQtRwzTRom752NlIS5BgIcqRqLdGgLpOSiyb3MWyNtt+d0mcYJCLqig578SKdlbee+WQ1p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D1O4eZEC; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9/+pSBvBZCYWhMLH8iVJxP6gNxnLIs3jD7GLU0kgN/ujot5rKutElnwFx5ItFoAsENIGmAg59La1Dwiuab+HbnjzAxY9vqvsyRNLybSnnDi0YqSkVte6Q5JIVMY4ctt//syYyi0yQ2GAEO+asrduVmcS1EL3C/829LaBuTo6PHGaFHXn0Ut/0q0i6NrGiI3lzxdhzsdRn2dWXdHe4R6XBnD2zlAgcjzXS3aENmW5p0zpAUvQ9Cal07WpMGWIhLoP9GD+t2ZWTyHAQspxj09aVCRNAbXjw0eOibjNy58YxKg54+UY6Xhmu/T9ep4syXR75xdFDzs+5/RvQVFydTZVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hLcihS5u7UqpZhrXlXNEX+XSJAoLCbIzhklmQxeVY4=;
 b=hNz6R7KQ3E1MgDxQ2EbKMokUEZIotkVwJg7f2c4Gzyn207BsWEcg9Jfj5QEr/aGi0J2Rn4hnuzjirUSgwBXVhXmfhDc1dXAhUjJsG2cqjq0RbDgDVLpQcbeaTj5KTXHZo+vFKI0+46R2VjBJhlarZY9awAdoprT+szuFr/N8n0ULtftAD6GobSGfyyKnAOSdVisV8i+E4splPVTE2wEEGpm/dtg6R6OCgjch8aEy4T1R/xexzSz2OGvbxOpjaGTi8KRTZ6ojK4IBfGkQFcVjZiuzx/GnnRFPJoafz+p0ATLmWqyJEQd5Tw3K3p83YilTx1TsEhp9vk1UdJKMT6//1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hLcihS5u7UqpZhrXlXNEX+XSJAoLCbIzhklmQxeVY4=;
 b=D1O4eZECgXCdXbb+kfOMXrXBwQXjl1MUtDsrYjvnHiG9eXO0iYJeJ4TUURSlpED75TMn7qLVv1GJA/cwqUuWJx2lAiyJEuCJjFBD4E5JzUrTmSdVMsQUlJ4h4DIy1HkNO5WLYySCFry0+iCrGj4gxlLUldzq/Swu4OYFbYg9q+U=
Received: from DS7PR03CA0024.namprd03.prod.outlook.com (2603:10b6:5:3b8::29)
 by CH3PR12MB9453.namprd12.prod.outlook.com (2603:10b6:610:1c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 22:33:53 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:5:3b8:cafe::29) by DS7PR03CA0024.outlook.office365.com
 (2603:10b6:5:3b8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32 via Frontend
 Transport; Mon, 1 Jul 2024 22:33:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7741.18 via Frontend Transport; Mon, 1 Jul 2024 22:33:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Jul
 2024 17:33:51 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: [PATCH v3 1/3] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Mon, 1 Jul 2024 17:31:46 -0500
Message-ID: <20240701223148.3798365-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240701223148.3798365-1-michael.roth@amd.com>
References: <20240701223148.3798365-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|CH3PR12MB9453:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad19ece-533d-4c87-3365-08dc9a1de2a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/VJCMiqzx1v+AwVrZCjrQjMOQYHRb20+zDlQL3g6cwMFFhI7rUtCTVN+LqcE?=
 =?us-ascii?Q?ecNGeVlafLZeMG6r5PEeVYuJBZYtYnwR4qz1Eo+8IcSllZMFoGunvufZ7Ygs?=
 =?us-ascii?Q?dBRu51GoEfudpiCZyxDPYhsX1ntXim7MFOpeXe6NUS0SdQe2t0t8oNHpFzEE?=
 =?us-ascii?Q?a5vo/sYlUMJuC396jLM0VPXx7XbGprthIHpE9qxvL8Y6wuHTzBw8vqs+lSNk?=
 =?us-ascii?Q?z4mZ8Mut/Dm2ltsMs7ZmHWbFpALVTMzmyl4/dDwlpaafzcLJ5jLDdWDmxvj2?=
 =?us-ascii?Q?EiR/qRE5M36o+W+a0pOOpDz98/lkcgNxdagHNxnktU1CHcVB99kOGsNgDk1E?=
 =?us-ascii?Q?AKfJ47btgh2Iy/ZKwvCMb3WiU3dDuY7flGm4xK5p3130nS6PXohBPpPIg/h7?=
 =?us-ascii?Q?Xt+t610sN+qk3riVfUv+4P5bnAq9WcIAMceNhLwcoTjQOuheCFfQb/bz45Xh?=
 =?us-ascii?Q?EW3ASOw9Dr2zzaff+qT+4c/v4puv+hLEKqgAB6zqxaG/M8JsUsRvvAiiMhHL?=
 =?us-ascii?Q?TqXK2NYOECkJCkPxc2xgqeobYK7u3KvPDIJI2q8oPhWVNLzPyo8JHNgXpQbM?=
 =?us-ascii?Q?QCf13lEwigAqwcp0YuWPv9QkSrFTXk0OfGqKvXUO9g/vmN0MSyWSU4/zYCSU?=
 =?us-ascii?Q?sALi7/gpkNLUjDHZjjLTr7tlLoYsWZxEkrT663yAuWYTLjcFeanrYZOcwH/b?=
 =?us-ascii?Q?/+J9h3x+iEMB0D5VW5oCoAzx3TPwcoww20hs4sopZwN07A2SoIvUULyAQgkK?=
 =?us-ascii?Q?3Upt6YFiv3JDgkBufCV/rkO63DHLtlnyOaNm9PnOz8hmiO1PoaB8vKX5ESGk?=
 =?us-ascii?Q?MPiQXG+haV+rE0pjvocvQYyflj6pc/AbimunrkjQd5k+WbNhUVpQzAvqKGAG?=
 =?us-ascii?Q?V2xYvGwaIggm3zQtUb9kevqh5k714fTRtlZsWoKCUM0yacwMvhv47jxesi8h?=
 =?us-ascii?Q?EoAwzscX72+EwdOSUUzF3ihAf+mcG6eqijX6bPlHMLSL3CBheBQw0Ji0GQ/Q?=
 =?us-ascii?Q?jgVGa65AbVYBj/uNImYyAIC/E+x9ic1s7wdvq0W2qMpGBrLCIh4ow513vF1U?=
 =?us-ascii?Q?z/oouPtYp8LadMS1sviG4SKeMLdiTao8MZKqfs5DYPh3iS2gqUlHmcSb+7nv?=
 =?us-ascii?Q?ZuqNCiGJwOClYlz9Ms5AvEtQeV+meE5X7OCMLpWlWi2WW+ggCixxePnNHwo7?=
 =?us-ascii?Q?mVR2qfQahiBdwhrZO9Rf5H+jFO+lwKb2QhdsKEHmTAYxmaVkWKOI66EB+E/g?=
 =?us-ascii?Q?khPnQ6RgJMQDHWbbPqagdC5xc8bC5/qieeMYD2Dn0OwPCLAL3wYIlUA7oAzm?=
 =?us-ascii?Q?8B/mjNT2n/iQDK4M49YrJF7GySJwoYy84q3+xEB2Bt1+C64WEQUgkfwDE2/9?=
 =?us-ascii?Q?f+gP5OW0e+VANaae57C6XX+h17WnwOWVsad5qUL7hlUtRmfJSjkNeLw0GUoJ?=
 =?us-ascii?Q?FZIKpI4250rjg+8ozhVC3VQVGUAxCxsa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 22:33:52.6298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad19ece-533d-4c87-3365-08dc9a1de2a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9453

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through the hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made generally does not
affect how they are handled by the hypervisor, which only serves as a
proxy for the guest requests and firmware responses.

Implement handling for these events.

When an SNP Guest Request is issued, the guest will provide its own
request/response pages, which could in theory be passed along directly
to firmware. However, these pages would need special care:

  - Both pages are from shared guest memory, so they need to be
    protected from migration/etc. occurring while firmware reads/writes
    to them. At a minimum, this requires elevating the ref counts and
    potentially needing an explicit pinning of the memory. This places
    additional restrictions on what type of memory backends userspace
    can use for shared guest memory since there would be some reliance
    on using refcounted pages.

  - The response page needs to be switched to Firmware-owned state
    before the firmware can write to it, which can lead to potential
    host RMP #PFs if the guest is misbehaved and hands the host a
    guest page that KVM is writing to for other reasons (e.g. virtio
    buffers).

Both of these issues can be avoided completely by using
separately-allocated bounce pages for both the request/response pages
and passing those to firmware instead. So that's the approach taken
here.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c         | 134 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |   3 +
 include/uapi/linux/sev-guest.h |   3 +
 3 files changed, 140 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index df8818759698..190ee758dd6a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -326,6 +327,78 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
+/*
+ * This sets up bounce buffers/firmware pages to handle SNP Guest Request
+ * messages (e.g. attestation requests). See "SNP Guest Request" in the GHCB
+ * 2.0 specification for more details.
+ *
+ * Technically, when an SNP Guest Request is issued, the guest will provide its
+ * own request/response pages, which could in theory be passed along directly
+ * to firmware rather than using bounce pages. However, these pages would need
+ * special care:
+ *
+ *   - Both pages are from shared guest memory, so they need to be protected
+ *     from migration/etc. occurring while firmware reads/writes to them. At a
+ *     minimum, this requires elevating the ref counts and potentially needing
+ *     an explicit pinning of the memory. This places additional restrictions
+ *     on what type of memory backends userspace can use for shared guest
+ *     memory since there is some reliance on using refcounted pages.
+ *
+ *   - The response page needs to be switched to Firmware-owned[1] state
+ *     before the firmware can write to it, which can lead to potential
+ *     host RMP #PFs if the guest is misbehaved and hands the host a
+ *     guest page that KVM might write to for other reasons (e.g. virtio
+ *     buffers/etc.).
+ *
+ * Both of these issues can be avoided completely by using separately-allocated
+ * bounce pages for both the request/response pages and passing those to
+ * firmware instead. So that's what is being set up here.
+ *
+ * Guest requests rely on message sequence numbers to ensure requests are
+ * issued to firmware in the order the guest issues them, so concurrent guest
+ * requests generally shouldn't happen. But a misbehaved guest could issue
+ * concurrent guest requests in theory, so a mutex is used to serialize
+ * access to the bounce buffers.
+ *
+ * [1] See the "Page States" section of the SEV-SNP Firmware ABI for more
+ *     details on Firmware-owned pages, along with "RMP and VMPL Access Checks"
+ *     in the APM for details on the related RMP restrictions.
+ */
+static int snp_guest_req_init(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	struct page *req_page;
+
+	req_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!req_page)
+		return -ENOMEM;
+
+	sev->guest_resp_buf = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!sev->guest_resp_buf) {
+		__free_page(req_page);
+		return -EIO;
+	}
+
+	sev->guest_req_buf = page_address(req_page);
+	mutex_init(&sev->guest_req_mutex);
+
+	return 0;
+}
+
+static void snp_guest_req_cleanup(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+
+	if (sev->guest_resp_buf)
+		snp_free_firmware_page(sev->guest_resp_buf);
+
+	if (sev->guest_req_buf)
+		__free_page(virt_to_page(sev->guest_req_buf));
+
+	sev->guest_req_buf = NULL;
+	sev->guest_resp_buf = NULL;
+}
+
 static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 			    struct kvm_sev_init *data,
 			    unsigned long vm_type)
@@ -376,6 +449,10 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (ret)
 		goto e_free;
 
+	/* This needs to happen after SEV/SNP firmware initialization. */
+	if (vm_type == KVM_X86_SNP_VM && snp_guest_req_init(kvm))
+		goto e_free;
+
 	INIT_LIST_HEAD(&sev->regions_list);
 	INIT_LIST_HEAD(&sev->mirror_vms);
 	sev->need_init = false;
@@ -2850,6 +2927,8 @@ void sev_vm_destroy(struct kvm *kvm)
 	}
 
 	if (sev_snp_guest(kvm)) {
+		snp_guest_req_cleanup(kvm);
+
 		/*
 		 * Decomission handles unbinding of the ASID. If it fails for
 		 * some unexpected reason, just leak the ASID.
@@ -3321,6 +3400,13 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm) ||
+		    !PAGE_ALIGNED(control->exit_info_1) ||
+		    !PAGE_ALIGNED(control->exit_info_2) ||
+		    control->exit_info_1 == control->exit_info_2)
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3939,6 +4025,51 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
+static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm *kvm = svm->vcpu.kvm;
+	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
+	sev_ret_code fw_err = 0;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -EINVAL;
+
+	mutex_lock(&sev->guest_req_mutex);
+
+	if (kvm_read_guest(kvm, req_gpa, sev->guest_req_buf, PAGE_SIZE)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.req_paddr = __psp_pa(sev->guest_req_buf);
+	data.res_paddr = __psp_pa(sev->guest_resp_buf);
+
+	/*
+	 * Firmware failures are propagated on to guest, but any other failure
+	 * condition along the way should be reported to userspace. E.g. if
+	 * the PSP is dead and commands are timing out.
+	 */
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
+	if (ret && !fw_err)
+		goto out_unlock;
+
+	if (kvm_write_guest(kvm, resp_gpa, sev->guest_resp_buf, PAGE_SIZE)) {
+		ret = -EIO;
+		goto out_unlock;
+	}
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(0, fw_err));
+
+	ret = 1; /* resume guest */
+
+out_unlock:
+	mutex_unlock(&sev->guest_req_mutex);
+	return ret;
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4213,6 +4344,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d2397b98bbf0..1090068f8f70 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -95,6 +95,9 @@ struct kvm_sev_info {
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 	void *snp_context;      /* SNP guest context page */
+	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
+	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
+	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index 154a87a1eca9..fcdfea767fca 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -89,6 +89,9 @@ struct snp_ext_report_req {
 #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
 #define SNP_GUEST_VMM_ERR_SHIFT		32
 #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
+#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
+#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
+					 SNP_GUEST_FW_ERR(fw_err))
 
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
-- 
2.25.1


