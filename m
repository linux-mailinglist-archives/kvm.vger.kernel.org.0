Return-Path: <kvm+bounces-20691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC3391C659
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 21:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2ADB1C233BA
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 19:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC23A7441A;
	Fri, 28 Jun 2024 19:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Px/GRSCP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192AD27E;
	Fri, 28 Jun 2024 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719601614; cv=fail; b=PBvk6aocLz5ZIgrS03v7yl+SKGWlhpaz5LRye+o/jPoA3LN2fghjfHeGLry8DBsAvfvFwPAYCcOV78ahqKV6bxwWbTBrkLo3fuaAKKCjh1SA2mPktn6wrxzest80MEfcfr3w0iUufaygRB6u6sYdBJq+zbWKBGQM+/0dxbtHJcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719601614; c=relaxed/simple;
	bh=dKEsU33jsIjh+XHYLPbWaaJLpPVwZNvyB6frkNuXIeA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CxprPhBukXKGcQm8ihV3Tjx3p42889jKFsI6q7xQ9SOJoTz/7QfmHZjowLB0faVMiCMJ/MpFklMrYXs/B66A5eOaE8brpV+BPL9UzSQ4akOk8aa+poslJAGuJIiPgKyFHtORZDidogx1jECxqxIbsS32vWzHbN16x73YyoCl8NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Px/GRSCP; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biaFdhR0W+CzHDsSs2/4BD8a86YqLcHABk3zHCaTqsA8p4jhl88DWxnlljCkJ+ilaOODArO4zMSQ7tNnAGHMsJn7MOvOhnBXtvo4TkyeOAiTPQYXsKjrOvDDC9N36xGOKwU/2eZzN8oBuK9vXkKXGLFoMdtf1kAXzwDRH8jPWxbHWBR8fWMXh8/ilNyeyc8arCC4Y2SBDd0AS0GUqUVPBdqn4zP+RS/kgjyuqIADgu5WdtCxHQG6RNaKCNmqm87yC/DZCzhG9wTGYUdCALgvwkJHpunFXLz4rCLDOEtomF7Y+2tGHIZcWjREryHBm3jpud2Uxcm0zZcDJqFxYJlpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFag7PWqpD1WuWWUVdOArPNI+rh/2LhK5MCMPKuga+k=;
 b=FAytB5V0qk6aBOLFXYhX/42sMcOd+scpy1rMvFCmiT0GggzvMB/tRpEdJ0I1jJEKBBQqmxwWfTO6OwfzkKbcZ2Kt5A/HnB5YRa3OnBy5bXSzrklHYE+nTZsBNKioNnBECdkDjVynzyGa5N+5EyudQ+sfPjBj04fSG0mgJMZo1/OsPm6FUmsjwDevhndB7oQgIu4+b9gZ7/Umg4b6gExhDArYMz8CXhTaU7pxkqkx+c92ZfWwtH68ORmlUS/L327zOupsE/TS/he1uWY0BWrh+LGP8OF4CnG22jPEb2aSDGf98y12ZQeb+JvI8WH9KdhpZuj7j6p+wy63EbZregaPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFag7PWqpD1WuWWUVdOArPNI+rh/2LhK5MCMPKuga+k=;
 b=Px/GRSCPSXFIMO9WP6WV5t6mmGCnT7dadQjuFIch+KBPYxNR1UDF5k1k1nn/FMczTDVZUOYctJv/P4PAFHc+DG/ehgHqw6Tg+A6aNIzeqrNbKylKYFHxUaVASgQK2RhN03QF1cGU5xC2bA7GeCuUMDM9JpCpxmoA9GXDgW3Ff8A=
Received: from CH5PR05CA0003.namprd05.prod.outlook.com (2603:10b6:610:1f0::16)
 by SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Fri, 28 Jun
 2024 19:06:48 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::24) by CH5PR05CA0003.outlook.office365.com
 (2603:10b6:610:1f0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.16 via Frontend
 Transport; Fri, 28 Jun 2024 19:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 28 Jun 2024 19:06:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 14:06:47 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: [PATCH v2 1/3] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 28 Jun 2024 13:52:42 -0500
Message-ID: <20240628185244.3615928-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240628185244.3615928-1-michael.roth@amd.com>
References: <20240628185244.3615928-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: 4675ad44-ea11-4c73-6df8-08dc97a575de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EmHPGA90QPWUiNtaa5BnanE6HI6lfQ9u5VNkmVISpeLv7Hs6odRrvabPfrZU?=
 =?us-ascii?Q?N6Z+XqXnrayYJbOfdUxpBlVDlmz1xUpo7TWrHkGgy6jDhK2bex/OknTKbzH1?=
 =?us-ascii?Q?OHJLrF22LjYgZYD/swJnl14oDmLpqt+kK5hXf/UukxZo+aIJb4pzitr1uQKm?=
 =?us-ascii?Q?VJfE4mJRFeurGqQQuVAmaWW7oBOTR2GQ//NEfEnZmQkXQVgJy1AJrwjUUzwi?=
 =?us-ascii?Q?l2eEBOJeQI2ggvgIaJseuFmfvCDzVf44a+ys1UgnTioEfu0OJ092KgSuoymn?=
 =?us-ascii?Q?tqaKWaqyirTBTuxXCNFpnq4Fv8QqLJ5ZtAFmRXqXlfMAZ6qliQ0coPi1dxGt?=
 =?us-ascii?Q?LbHkJWWvR+qATg6AUylS7JaVLfBNd7R8O332VEIM6zEjQGj/BK2AVZASRHjF?=
 =?us-ascii?Q?K+uDwQBYVUr4pNUVH0v1A+bvyMqM7qe7RZuL10PZhW0bxFxQph+upConNvKN?=
 =?us-ascii?Q?PeSW0HYgA28/mtYa1Nf/bJR/YeEOOYAl01SQqQ7agfRg7U2DwXvRvQQjeGUy?=
 =?us-ascii?Q?HDzjM0CE1pm1Xw+Rx0kWLNc58NSkdXw0iIGDbJjtI2Uo591grDu5PtjE4MwN?=
 =?us-ascii?Q?46TVvdcENO7kSazrDXNMLrT+5A/JzoqJLubtYfOt+FHDvLMN1SSjjWGU5sul?=
 =?us-ascii?Q?FyZyTmEstGt/4dWLY71wrwh/a8HOfhdSkHEyjLWpr5pvr6cj49L/nFiDFafr?=
 =?us-ascii?Q?KXrXB1fO3/WDbXzM27ZKkAXPc7yayQF6SiQ+5sDeytrWhUUpcOghYo26o3n5?=
 =?us-ascii?Q?9er2wj1PmpxoAQmFDolJ9I0w0OSZHhnN8JCZtFEAw98sKv9f3at/3ZhpmAGt?=
 =?us-ascii?Q?k7yK22a6GnlwbzM0FoWALbjgiaMINK+cnEBPmWsf+vZHj2j2Ws2SOrtGVl23?=
 =?us-ascii?Q?6OEjNJLPH9MPUcGyZl5vF7S7p+2Ia59RTiG2cfe4EBpUlcr9zJYnGRIGTlnn?=
 =?us-ascii?Q?qOdZrc8zy6lQhXShUkiiLWz5IX9Hrpv7ueCo6Rk/SiNFmiBHMO5qhHwDejOC?=
 =?us-ascii?Q?+GspOkSHKXJKvba804L0jCgjgNgf60w63tSliQMLwNH+8XFqFnW14NXVt/wm?=
 =?us-ascii?Q?rCMH/Q/vG0vwCek+/Nt42QKHFOpgWSG2/rIvZAU6Zw57yfqKvMhkcVHJg0ut?=
 =?us-ascii?Q?idtqTyJcFN90cXMMC4KgQpTZ6ltPLG9r5cT2pIACqHccKRj1OOjeZUyA40tR?=
 =?us-ascii?Q?8gYBnHjDDn4oOmLT8I7SDAl5r/e9g39a65/rOV9lYS7KkymJyc3rfMmGcpaP?=
 =?us-ascii?Q?Qy6njglNPkRVQJmKhCQRhTSEZ37TQjZ4UDhE8S1A5Y9bPH87aSz5G06Hwts0?=
 =?us-ascii?Q?rVZbjUgQaqJBjQlzRn+S0rsgTtxByoPJJMQ+jyQhPAW6kRhMXklSOVw2RMs7?=
 =?us-ascii?Q?zdDgQR3oxhTMySw85u6DSKRfq74fy9vn5wMRZRW6oikSrK51eJroh3Xhbvqy?=
 =?us-ascii?Q?UtyoqNy9GjklhyC/MGL72NonAP5EIHKS?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 19:06:48.1739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4675ad44-ea11-4c73-6df8-08dc97a575de
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made are opaque to the
hypervisor, which only serves as a proxy for the guest requests and
firmware responses.

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
 arch/x86/kvm/svm/sev.c         | 131 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h         |   3 +
 include/uapi/linux/sev-guest.h |   3 +
 3 files changed, 137 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index df8818759698..e7f5225293ae 100644
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
@@ -3321,6 +3400,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3939,6 +4022,51 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
@@ -4213,6 +4341,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
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


