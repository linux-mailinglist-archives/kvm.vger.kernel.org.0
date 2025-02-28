Return-Path: <kvm+bounces-39681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B90A494B0
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4FF1170FBB
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7C72256C95;
	Fri, 28 Feb 2025 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lFui7bVZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AE424A046;
	Fri, 28 Feb 2025 09:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740734412; cv=fail; b=a3iJmaZ1PYRKjYYSdnYh+zlfaFJfUaDhuBBFNwLvjgw+M6P0ffX58Bj2QDEx+lxzPhARjRQwpjOtMvcgQbJh4QOeEet9W2kRsuxqrDAceCJQ2i6WDc9XmJ5YpURnf+16FqjxFOQ/Zl95Ur95E2puua9gsOyb71j66LCK7GRkU0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740734412; c=relaxed/simple;
	bh=rEC0FQUnur/2ZX1Tf325HoNeMuvn1BfVbCvsH6F2kHg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1lFjSAHACzjB1Bzyu9X69Lp+oliBcN2GravzAwFFL/BPzu0l9j62e24s5sXnAsP6QKa4cUxGfCu6ufxqthTAugxeoT0QN/tSoBDOjO2vkiLAwAwBN+GXT3HyL2iih4NI/QAF5XqTAFUj9L4f0wBl26SiDS7zDoQ5UC/aldJdhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lFui7bVZ; arc=fail smtp.client-ip=40.107.93.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5QoNEIaBX+HoZdDX3Dw4J1LTM6K9hS/3jYyT+ZxyOldG4Y0JP5ozuJqu/kT9Cp2kpuNHeURPtBr4yM7xlN9xbYmProwj+aKKRGZAXMIZiBRfTBzAMhjFDbdljclPTW8pimRyyhcb5u8+bnz3wXr/yV1HIKZSB3GnlNKZE66oP5TuZZ0vhBReIDT2qf8Kp35VvDM/5fnmL1LCWeNVIeeLlV2EyIiGvIeaPRpL6Be8Ovvm1JYxMEFfkITWBrkIM1kXgGZOuR4K+AAYk3cWWNRc/qrdldhnSEL0PdjoY+Bn4Fnwd0fIIrNlfpUXtgW20Rc+HNSjJnq+RBZptEUfkd42w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iV4dUZWIb4SIYuyRMmbjDJ9dqKszHI/fEv1ypcKKJRA=;
 b=dXWKr2SB2x2XZ6Sr7Px9jgelskBNqX1/t1IJlLDrQPU9Ay5AU/jaV+KR6TCEUatFCB19rlwEj3niTgvFjsPxTAFhfWkXYhXsFei8SKsZT1IgNFzKL9fDMc74ndervKgfzb9YSv0TeAj5hQX6YIMAqH36+dZuWgEd2+wuOMT4SFK52Ey2b2Me/4fJGt1hrFZ6TbxoOe/XbOg71AZoKk4SgKVqrBH+3/w3bFiluTmcouh92A9DZnC3fPsCMmtfUWor/rgdBS5JZHUpxzJ36OiqvTQP/lfGm/MJnW/rffPj9DHUL+jXDv8RVJ4AdhUmQCip6zkIZ5riwPfZbnWTy655ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iV4dUZWIb4SIYuyRMmbjDJ9dqKszHI/fEv1ypcKKJRA=;
 b=lFui7bVZ+gur/pgYfMM9HbwGhS6fwVtsaq+mlBXwil4OkBhp+FoWYXB+NmFXf5V97BlSMBuFJlYosX37MHIOg/q+nEjQbtFuL6jj+4hKPKO7i5W2LrLVgmtsdgWKtbWsxCinEVhWF9QL2K8Ddy64beM5tIcinE+WNBSGH2+p6Wo=
Received: from SJ0PR05CA0048.namprd05.prod.outlook.com (2603:10b6:a03:33f::23)
 by PH0PR12MB7907.namprd12.prod.outlook.com (2603:10b6:510:28d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 09:20:07 +0000
Received: from SJ1PEPF0000231B.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::22) by SJ0PR05CA0048.outlook.office365.com
 (2603:10b6:a03:33f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.10 via Frontend Transport; Fri,
 28 Feb 2025 09:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231B.mail.protection.outlook.com (10.167.242.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:20:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 03:17:45 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 15/19] KVM: x86: Secure AVIC: Indicate APIC is enabled by guest SW _always_
Date: Fri, 28 Feb 2025 14:21:11 +0530
Message-ID: <20250228085115.105648-16-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231B:EE_|PH0PR12MB7907:EE_
X-MS-Office365-Filtering-Correlation-Id: 50557dd6-7189-4aee-85a8-08dd57d91772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HOIpdHFbCKA8lgWJfzNXfbUqMmkQxqVcA98zyODBP4zYUTyqpcJdiH5fyL3E?=
 =?us-ascii?Q?HrAUEkDOlsJenwroAot3lRxE/QLDD02fOIPaYsDAXdSD7Lj9yeggDGw32+Uh?=
 =?us-ascii?Q?CB5GUiMFpQDmKgbnd/18kvjvy9fkB6UQcxGXkU8WSFDON1SXCYQOoliPlMVR?=
 =?us-ascii?Q?jcQzqZ5/TDJAUG408pXjuTK8PfadGJB/KO9M8Ugmx4rsVd5cAlT7L56IyDnk?=
 =?us-ascii?Q?fC7i2CyNyKxZMp2TT8SR6w6zpmWxp0mIG9+zwzBATcR+ljlxf6mpSWA/yJkE?=
 =?us-ascii?Q?KprG494FhnPSj5Nw88ag785GTV+nLgXT1zhPOG6qqbptZ2cApIir79Xzpi0t?=
 =?us-ascii?Q?21Fm43H+ZYE/uwgo9JQ/W6EGqYrS3GLse3fS9s1KKdcB3BKRX895LI0vj5op?=
 =?us-ascii?Q?FpAgSVb2+JOpes9RAfWVw8egsNoIw79s1VMIFbK198msRS9wIyO91LQCSJVw?=
 =?us-ascii?Q?zuBj4esQkl1bucxZZpVjnDXvpWm6CGnM85x64+LCjIbk9Z4zG5dtmd2ky2pz?=
 =?us-ascii?Q?/sPID8s7al/x2xLKHN6Btv4vIcG20VMAZMOBahMZEo3tRmnq9a2lCpZzauJ8?=
 =?us-ascii?Q?lsl3hIhj7D02aPTGCRNsCzqtK+nbDPqRmfYdsSfreNcgzPKK13G8rlfeH4mz?=
 =?us-ascii?Q?5xUZhwp1Hs8nzRij22apBDKGORChyz9tju7RlSIIc6XmllEGymTC88avq3Ya?=
 =?us-ascii?Q?9nE1vxNFhB3zRUeLAaWsVGpG2PEqHadmt6dtvHYFZK1vfhZ5sOtPIrxnF2vA?=
 =?us-ascii?Q?dMs1YTksdft+jrbEAwqFte20Xrx6SO2xBI2tWFeHSw6EwgxzF9CwhiY8O0Zx?=
 =?us-ascii?Q?7zWeAQnYKHdFXMHOpqIjuH0aETAneOV7Nd+FOZeHGyZx7nvBUPWb2jJvyY0F?=
 =?us-ascii?Q?RYI3+0hNASQ/Kzu27SdGAmnlMoAq4He20UnKzFHUhvCHdTC3fCwt9Uxftbt6?=
 =?us-ascii?Q?jkmNPGq/aR4okJViP1VnJLnuYpFlXCsaMohA1IIkss9mTztjhr9MacUcQQvR?=
 =?us-ascii?Q?qaM/gYPtFbKvd8/od9d3J0lFaJwHK/TPiH75I4KKVSrabPWcegLYXphISNd2?=
 =?us-ascii?Q?3dQbAb5g4HM2sRbql+EhuPHt7dEzUqP873aP3mmjLGWyGj1+iH2AnTNuQODS?=
 =?us-ascii?Q?JakyRYfILzjZLaREnYbLYUdUHGiJS4rVaEGPKWjBtKXPCO73I33Xsn2ZQEMD?=
 =?us-ascii?Q?GdWasqv79BlkzZGwt4s7+6Fb2WdQJUQ19t8kneDFhX3wrRzO8ZV0e7VW2TdI?=
 =?us-ascii?Q?QLVlZsBWyKj3JOzMPTBxw7ZkLYluR2ZfIIjKcLMN+yVvabYVLMS6Rgu6QBQk?=
 =?us-ascii?Q?W+ZyTdGtEtmLeuGOyodOl+2oTcP5GnSzVQei8GqsjiDrRn1XKmfNvdZFir8C?=
 =?us-ascii?Q?z4eCe4ATfNoN21YikQXu29gaYZnzrtEJSr/cFPmNhfPfn0PaZV4aX/13x1/k?=
 =?us-ascii?Q?vEBpPNSyv++9iNWtoaDEHSuk38Hx3YFAHb0zm4L5NS90sjgyBV9aAm3HQnVT?=
 =?us-ascii?Q?7hm/9zja47/wR84=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:20:06.7817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50557dd6-7189-4aee-85a8-08dd57d91772
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7907

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Guest SW indicates APIC is enabled by writing to APIC_SPIV (
Bit 8: APIC Software Enable). However in the case of Secure AVIC,
APIC_SPIV is not propagated to hypervisor as Secure AVIC HW
itself can detect whether the Guest SW has enabled APIC or not and
handle accordingly.

To handle this case where the HW handles APIC SW Enable in the
hypervisor, always return 'true' from kvm_apic_sw_enabled() if
Secure AVIC is active. This would let hypervisor assume Guest SW
has always enabled APIC and prevent it from taking actions it
usually does when Guest SW has not enabled APIC.

This is especially used when accepting interrupts to be injected to
the Guest and for injecting LAPIC timer interrupts.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/lapic.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c9ef9bce438b..a1367689d53c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -206,6 +206,9 @@ extern struct static_key_false_deferred apic_sw_disabled;
 
 static inline bool kvm_apic_sw_enabled(struct kvm_lapic *apic)
 {
+	if (apic->guest_apic_protected == APIC_STATE_PROTECTED_INJECTED_INTR)
+		return true;
+
 	if (static_branch_unlikely(&apic_sw_disabled.key))
 		return apic->sw_enabled;
 	return true;
-- 
2.34.1


