Return-Path: <kvm+bounces-17224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1EC88C2BBE
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C555B1C23A90
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAB013C3DB;
	Fri, 10 May 2024 21:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cP2WSBG0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388CA13B5A6;
	Fri, 10 May 2024 21:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376056; cv=fail; b=MZQDaWDwgxt6964Y4spq4k2wS36iLA1T5nUKvr47DsVJU5+Eu1JfNOC9TZOI6ixfSj5ayWud5u5TynIdGx+zl3kvoGqtiAXkhpzAv1Ijb9/xfbMUgpFP6h5jofVh6I21mtNJhVHFY7lUlpJm0E8MspQIDVgXkx/whK/09cnHLGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376056; c=relaxed/simple;
	bh=GkwynivJtpJ8XgE1UM4Ex0+ult6S8BjL8QUFmNQEwl4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReOKoNKoHBoMQCzsqTzCaCCZGIVmN7QkbINPHwHj7Frb+LRCmPb1ba3/2frdJxVYe5VZR13cjvkCwaRBdWzj3hNsLnQkWkQvuY92/huGWj6ovzgEIrudlHoyTic5n4DDRZdASlD97bxAwjQ9X+TURLQYWX9YbZ1lnwI5Dk/1PG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cP2WSBG0; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5B4L4Rx67GsfgzdHOdNjGaQxBCVXQTDS7zFB9XND3S4pUaVWmNVfRSmdRZ2OcpBZeqjqaSklE5NMGLuikChG/5gH7eVZ1V8+JTG0yvHLUr7BzT+gSip01xK2DcpB+XhZ4biUSDzqrlbHMWnr0zc098uJx+zkTfKteOANOG4AkDmSlvUivEuqJHzp3i5GXaywt0QKGXt2LfpVQ/AzGazS3fl4+2J4eqO2hS8/F8XTURFLgCDD1or4kxRNtJtliGvb8MNG8gLEfUSIFIwzN4oMLp3vGPYuaD1NUO6JknyRERSX6CwK9AKa2NwUSfZv3NxXrNAiTyVaGd9ppDeNssKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ns2sQkcbmDWzhmrSPu1qFteenxs2iF4nPKD6ofsKTD0=;
 b=P5GmIhhEacD1Lnhv6DDRvHnMmKYCcO9iRO2ouRVciDAndv7ngEXuuvxY+0PRDWpvQONTE/qpUE8yfDKewcyb25tARBqy1mnGwhiFc4L2WLy0eN7MLOe6LKqI9bNPVj/WaAZaRm8iD3GjLNtoirI5txWZUREcI0i3p+KsiO8FHA9C8gXImAqyo8SP/bym0Ojfsb3BchMxnIBmLmrht7WgnLVdffDbPI2GXuV5Lu+0SkEgf9zY5nnjcWav3PLz9xBE3yPYqf3PCrWJU+1BVmM5/fU0oqdXo+gORx2ChWEQv//Zdz/D9MYPZVTE9VQmpRm2jh8dXcxdgviOkSKbevv7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ns2sQkcbmDWzhmrSPu1qFteenxs2iF4nPKD6ofsKTD0=;
 b=cP2WSBG0YzTGElBPCgI0ASgwC7bmsfdX5Z42WZ3T9tMgvw10L7VhNHntZLGspOCjdq2RzYXsrDmu30HLZ/jyhv6oDZjrEwLZcSqI/Vzx6IvncTe54zD6Tc8QAHR0gaqqS7NB/IBteFZOOvOesiNFcf+QLvWexFz5/tUsP2VHxN8=
Received: from BN9PR03CA0075.namprd03.prod.outlook.com (2603:10b6:408:fc::20)
 by LV2PR12MB5845.namprd12.prod.outlook.com (2603:10b6:408:176::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 21:20:52 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::f8) by BN9PR03CA0075.outlook.office365.com
 (2603:10b6:408:fc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:20:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:20:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:20:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PULL 01/19] KVM: MMU: Disable fast path if KVM_EXIT_MEMORY_FAULT is needed
Date: Fri, 10 May 2024 16:10:06 -0500
Message-ID: <20240510211024.556136-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|LV2PR12MB5845:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f648a8-7d9d-42a7-0bd0-08dc713712a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bUU1MP+oOHJSMFeL+c9sPmZ2O8N6M/PmudORzxvkYfiUK1haJsXfBcEDf5tV?=
 =?us-ascii?Q?uzKCQV35pz1ygHnyE+lksPd5ZspDglN7bJtUOTDp9KdVEFUMvXTT8TxPbzgO?=
 =?us-ascii?Q?mwvfDw6yLaNFUGCXKZkh9D0oUKgNRHildputvHZqgIfNe19K9OXjb6OA7MoB?=
 =?us-ascii?Q?HsguMylVaIOgsz315asvzf7ItDfvyvXXFlSFgaUmR+aZddts6ebnfcG2f38R?=
 =?us-ascii?Q?SF0HEVc/m3ENlzLDfTXc0HOf+cJfXYGrDF19nbz8e97AKSbF9oDwgMx02zdv?=
 =?us-ascii?Q?v0/c1p1vzpBRDy0c3OmiHWJV/1eQdO64WebM0j/ugdVdK7FXpL1ZfMFegwIv?=
 =?us-ascii?Q?2270z7QTTLuwRU+TjbQiiM6leXm1guh8SkQ05oYnVGiV/jbZUKiPVaqi5Y2o?=
 =?us-ascii?Q?Ib5x3tgPI/N2vyZGswBdopd1rheXqDzzDay/uQlWxyVTIqvg73XCveGfY9Sn?=
 =?us-ascii?Q?so+buS0wfR4QXDJVsQB2xOTzFAjVdBl091i7MgWFYNd+c18e6Uazm9ZDSzZv?=
 =?us-ascii?Q?LKUM6TPDM92TxP2H43pr9qRM4mmVXjTRlsvpftdNZbA5Vu8yOnuhZgff0ZW/?=
 =?us-ascii?Q?rWn+kjLVswai5UfP6UIcs6IYHi0Xt8ZqdEDLH3+h6sye/IU1runUeVbHPrwA?=
 =?us-ascii?Q?+w4reEYVXMupA3Z0SByuLN8Je24Jq7Jq+RH90vJ+QSt182/pLh6GTbD5XbH7?=
 =?us-ascii?Q?6bL1vJFm1PCEKtTeO2zffXiwZA/tqfvUKKwZSROUk3LOFiGCO+Ip66PgCJ00?=
 =?us-ascii?Q?j8zuu2/tsypevNM9bSEmoQAEfa2arp3rmPEU2OHaRrqsCuwRg903Czjuw8qv?=
 =?us-ascii?Q?cwhuMeIvkHIfTSzyZzxvLTfRtB6b0WePwM3vOBZGMTMVKsXjd8sJjO6ZhWaW?=
 =?us-ascii?Q?YoiktRF2nAtIWlqV5AB3KsQflRL0ymDX7Ff+UOf2KEGZ9afIA+KHq+OMamse?=
 =?us-ascii?Q?N32aq6wZy4hcDjTMUQwdn3rr89ZiNu5S7E81J1bblEEYYzBGy5Cm9T0J4CHG?=
 =?us-ascii?Q?ZYXuG5wXAdDYP/1ND0GEvSNVhcn+5GvGziFZCcw6UXASmdpwzQDDnysQCrQo?=
 =?us-ascii?Q?woXIveOuqucTjjluwfwK2/xa/T2PgG+WPSl5n0MqY/5tBQ2+YakcNIcfsHJu?=
 =?us-ascii?Q?sRI3klKpy42g9i8k/bR9AUNirKgvIMmkhjdsZTiFsfBOvGwGrMYVIzyQsz8G?=
 =?us-ascii?Q?QIi/Ac/igkgHy17o/KuUUp69tRYlOLLJTGTsqeiYtvDjOPWADFX1zaXVhW3d?=
 =?us-ascii?Q?EF3H0bIEyZ+V5FPShyUvqrUz5eLn444xtBZEB8u0lgEs6UjHZyJAD/mxP3cb?=
 =?us-ascii?Q?q9cTKYFoHGHK8vkqDcaOQF0CBI8CbEwZvf4hjkF7fzUvKg95x6pN2+GB4OqT?=
 =?us-ascii?Q?ZRJHsTw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:20:52.9048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f648a8-7d9d-42a7-0bd0-08dc713712a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5845

For hardware-protected VMs like SEV-SNP guests, certain conditions like
attempting to perform a write to a page which is not in the state that
the guest expects it to be in can result in a nested/extended #PF which
can only be satisfied by the host performing an implicit page state
change to transition the page into the expected shared/private state.
This is generally handled by generating a KVM_EXIT_MEMORY_FAULT event
that gets forwarded to userspace to handle via
KVM_SET_MEMORY_ATTRIBUTES.

However, the fast_page_fault() code might misconstrue this situation as
being the result of a write-protected access, and treat it as a spurious
case when it sees that writes are already allowed for the sPTE. This
results in the KVM MMU trying to resume the guest rather than taking any
action to satisfy the real source of the #PF such as generating a
KVM_EXIT_MEMORY_FAULT, resulting in the guest spinning on nested #PFs.

Check for this condition and bail out of the fast path if it is
detected.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4ec88a2a0061..9c7ab06ce454 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3296,7 +3296,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	return RET_PF_CONTINUE;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
 {
 	/*
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
@@ -3307,6 +3307,26 @@ static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
 	if (fault->rsvd)
 		return false;
 
+	/*
+	 * For hardware-protected VMs, certain conditions like attempting to
+	 * perform a write to a page which is not in the state that the guest
+	 * expects it to be in can result in a nested/extended #PF. In this
+	 * case, the below code might misconstrue this situation as being the
+	 * result of a write-protected access, and treat it as a spurious case
+	 * rather than taking any action to satisfy the real source of the #PF
+	 * such as generating a KVM_EXIT_MEMORY_FAULT. This can lead to the
+	 * guest spinning on a #PF indefinitely, so don't attempt the fast path
+	 * in this case.
+	 *
+	 * Note that the kvm_mem_is_private() check might race with an
+	 * attribute update, but this will either result in the guest spinning
+	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
+	 * case might go down the slow path. Either case will resolve itself.
+	 */
+	if (kvm->arch.has_private_mem &&
+	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
+		return false;
+
 	/*
 	 * #PF can be fast if:
 	 *
@@ -3407,7 +3427,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1


