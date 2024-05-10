Return-Path: <kvm+bounces-17147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E87D8C1C75
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 04:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44ABA2818B9
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 02:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F82148857;
	Fri, 10 May 2024 02:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ROoxQmT0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97D13AA59;
	Fri, 10 May 2024 02:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715308616; cv=fail; b=imBTpJafssT/pU//3TnGPHxMGJyJor8Vd0zVuRJKS86ymX0c3TAM7GggQ2PQN/emlCTHqGj7Q+mDHFiJWLJfHQetDTzRLEeRjgp6ew61vfLfT/rKNVKw5TPXpNeA4zPnSLi4+aW5B9PO39n4Pu3vrTGhuiqaHCW5LVm2HiK0RNc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715308616; c=relaxed/simple;
	bh=qyC92NCTcb/drIn+9pUWVVSjmECl++xQMMQhQPc7LWI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aG2HC8UtSK7l3prZPaBmhhQ3CauRLvTs4+Gxp68KalrgIh3Rm8ukdMax++zgS5f2oI54kl/Cyh6ZN4nWoy82Wwn2YkEBBXUxjBuEBlCd++mSr+NwQaY4JmYo4A5OTNZVoYbs/HENIMcqjF71Al9kbgv2BqgqjL0tMX3sR4/2pdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ROoxQmT0; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+UadS+/M2eRRByO2OUQVTfpMF5Fb/cE7te72mmU7fSSvid/CoBIbR8Q+CXSfc7/Iv39LFpE6qdmlulRU/LOQC7JqyMsnFeHRaNqxrgf63ZbWot1aIQ24CIjkFvulFUrk10ZbYpyiyHIE72vkw/uTYgtt6sedpZ+3WLYTYWf8qtedYkMyVHxh/GgRzRcX2iRhMW7xji2x5cAzNbHHoTjEz8qo7JxELjQTJHi2wndx36Qy75SJ7L94JaJ8e2oDxIrZghxdZwpg7k3Qje2o96c47HsUqF4zpYUKTlWUDiQ7HgkBLdISgO36NpkC8KUTLmp3f6WaiziFeor48lDJYxMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGhmcL2OHBdWCaoWb6sS59iIQkpm0AUCFdadplIl+MQ=;
 b=n3FouW/fLxN02CoFU7L8uW3fCgBY4nVYPMmdwSB3OvpaRsaS8qVrvem/R/4Pa7JtdaWimcaoL/5xIYlc9iDsuci+Kw67sKoUHuKm3SgsICEPJXpCyFnun1p/iYcntMvUuRl5vUSmNULFEBhvDdJp0G7RUhKYn802/Jm627SBXsI1HPw1G8x2dX2HmDxV29h7pvZoXSBbNqe/kygg9y0Ba+gw5X+maHeEqvM2FK6As9R0oVndzuOGsLKwgjrR8BlZGKZT9MzYfnkSNvRg6QdOOQx0DjKFN5lNpHYby436JCKWE3AGD+IbALBxEYRPfubPz9uazYWhMr75NRmCVFYYjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGhmcL2OHBdWCaoWb6sS59iIQkpm0AUCFdadplIl+MQ=;
 b=ROoxQmT0RQxlklLagkVC3KBCjgGKp1TIOO2IuLkfOGZ91ZFJjhyf3JjwgwGcyBtOsOMowjF/S1lLk5P2DpPsh0bBxR1h96edawekySFwdPlORA4Gn9HNi97meX3GNBLTiZU8NFZ31e1/JGPbThrWMl7z/6VlYmDfqPVRptoRRSA=
Received: from MN2PR15CA0021.namprd15.prod.outlook.com (2603:10b6:208:1b4::34)
 by DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Fri, 10 May
 2024 02:36:51 +0000
Received: from MN1PEPF0000ECD5.namprd02.prod.outlook.com
 (2603:10b6:208:1b4:cafe::65) by MN2PR15CA0021.outlook.office365.com
 (2603:10b6:208:1b4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43 via Frontend
 Transport; Fri, 10 May 2024 02:36:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD5.mail.protection.outlook.com (10.167.242.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 02:36:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 9 May
 2024 21:36:51 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for RMP nested page faults
Date: Thu, 9 May 2024 20:58:21 -0500
Message-ID: <20240510015822.503071-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510015822.503071-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD5:EE_|DM6PR12MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9c8d35-b30f-42e9-9162-08dc709a0c80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|1800799015|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EgVtHvT1lXFKVIEJsVvgCk1Xmagu/sbxizEvRBk63+ce2YPkqcym+ULPL/Nn?=
 =?us-ascii?Q?GxRbqHR8bzqcNQpHv7TOm2URqJEkJbw2NB2hEBVkAQEwjYNGmh3sdyB+5+IT?=
 =?us-ascii?Q?ih0PcX/OwPMtU37u4UoTVZr84KS++zaL9EZYmMZgSIMQmtJ+sMe4TLdC1UuH?=
 =?us-ascii?Q?ptsc5EsmVJe7IvSKJfxlzv7wx85TszTXszhXMeSUH2xY7Z4cAJXVrxNt+5kh?=
 =?us-ascii?Q?ZIh3wZ9tkLEkUiwlKM2sEhBOyLO7JokZJSVv0dVGF4io8Brh6E2kE43BZPZ8?=
 =?us-ascii?Q?z9Z/ueGRyroSML7N/oXPB/w/fFVt/Yz0bVFvQhuMUvL752xAa5x+7QMm/QGD?=
 =?us-ascii?Q?beVS3xtafufX5Hp0Cpc1wOxbNentSAe3dBzlSfqIlK2gu8A5AT9kVHsYvWHV?=
 =?us-ascii?Q?AByU1PU9JOu8zQ8e5syMaPVs8srbElkJLue6v4lm8vp+TGj9TS3rw2g1FMs7?=
 =?us-ascii?Q?XusgosKp13tMix7MJOgLthJUPc/mkcvgkkeARJqXAciuHr79lE5nT6qS7uoE?=
 =?us-ascii?Q?DtnTrasngD3XhgAl4MQJ2KMnqzgfHCxgPH15wcgmxrYCX8VvIaJM0047j96/?=
 =?us-ascii?Q?u6GZk1hIX7FSIOisM9LG4asv4HP0OSNB/usrpLSjcAHI14UrLedlfxMZv9uv?=
 =?us-ascii?Q?aUTuYpbCjilkkjdvrfeZvQuMnIaGex9GNK1p/XQ/Ok1VbsGJs912ISIXTJRx?=
 =?us-ascii?Q?LCsvd4ngsVGNERiVQzSGjrDC18ikFd9r0XBkaPGT2wTOyx3ZelipAVjbQ/3a?=
 =?us-ascii?Q?q3R57f+12EV+tQcLxLCOaGGSHfYgX9kVwFEWan62dCfjMsd+T3bmN4W+ckOC?=
 =?us-ascii?Q?+K7iowdGG0he580JEe1aK86myLl/R8D2lDuFgeQRexMZVht/wCyHJCFZovtL?=
 =?us-ascii?Q?XqjyQGzsGBJ4Qz5kbjqn6Gw/OZjBdCXBSgqfQS2I2eHj5zN959NO3NXZHNbh?=
 =?us-ascii?Q?JrrUfb4MlpL7xOd6gogJ4xnRxHYw8MYrjoiDER2JH/DDcXGFI/7MRxV6XMeX?=
 =?us-ascii?Q?gZ+evK6BLYWNZUJBd74EETEj4r5jIJKhZU+Hh8kbFbU/kvQygKybp9deaL9W?=
 =?us-ascii?Q?n4EsumOfA6tkacowYw6IVuhpBt50MBxZSyrm/fwKgJCisWUvO0576cw0vPs0?=
 =?us-ascii?Q?oUYU1yreJlxN5X+Jw1BJeKZLXkVzGK1+OBCyXR3E54jLjf1jAbLXf5C2/eJf?=
 =?us-ascii?Q?mw1x86vopym+Q7dMjceH+TOyKrTeiHzg6BBbyD2ni4QSDgUs3OAGiJODvMIz?=
 =?us-ascii?Q?KKOcgWqi2yejzTa9vGuWYSzseiOZneVLqmRzIoZl8GEhzgdLEDQGz1ah37hZ?=
 =?us-ascii?Q?/ZeFHYSefCLRPC5GJdDdtwoEM8GiFbWVdcdO4BFqaTbWzB3wFS/7s/hwL0Dj?=
 =?us-ascii?Q?mHErZ873By/PUUiXmXKDdnBNi0ZY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 02:36:51.6169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9c8d35-b30f-42e9-9162-08dc709a0c80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316

The intended logic when handling #NPFs with the RMP bit set (31) is to
first check to see if the #NPF requires a shared<->private transition
and, if so, to go ahead and let the corresponding KVM_EXIT_MEMORY_FAULT
get forwarded on to userspace before proceeding with any handling of
other potential RMP fault conditions like needing to PSMASH the RMP
entry/etc (which will be done later if the guest still re-faults after
the KVM_EXIT_MEMORY_FAULT is processed by userspace).

The determination of whether any userspace handling of
KVM_EXIT_MEMORY_FAULT is needed is done by interpreting the return code
of kvm_mmu_page_fault(). However, the current code misinterprets the
return code, expecting 0 to indicate a userspace exit rather than less
than 0 (-EFAULT). This leads to the following unexpected behavior:

  - for KVM_EXIT_MEMORY_FAULTs resulting for implicit shared->private
    conversions, warnings get printed from sev_handle_rmp_fault()
    because it does not expect to be called for GPAs where
    KVM_MEMORY_ATTRIBUTE_PRIVATE is not set. Standard linux guests don't
    generally do this, but it is allowed and should be handled
    similarly to private->shared conversions rather than triggering any
    sort of warnings

  - if gmem support for 2MB folios is enabled (via currently out-of-tree
    code), implicit shared<->private conversions will always result in
    a PSMASH being attempted, even if it's not actually needed to
    resolve the RMP fault. This doesn't cause any harm, but results in a
    needless PSMASH and zapping of the sPTE

Resolve these issues by calling sev_handle_rmp_fault() only when
kvm_mmu_page_fault()'s return code is greater than or equal to 0,
indicating a KVM_MEMORY_EXIT_FAULT/-EFAULT isn't needed. While here,
simplify the code slightly and fix up the associated comments for better
clarity.

Fixes: ccc9d836c5c3 ("KVM: SEV: Add support to handle RMP nested page faults")

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 426ad49325d7..9431ce74c7d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2070,14 +2070,12 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 				svm->vmcb->control.insn_len);
 
 	/*
-	 * rc == 0 indicates a userspace exit is needed to handle page
-	 * transitions, so do that first before updating the RMP table.
+	 * rc < 0 indicates a userspace exit may be needed to handle page
+	 * attribute updates, so deal with that first before handling other
+	 * potential RMP fault conditions.
 	 */
-	if (error_code & PFERR_GUEST_RMP_MASK) {
-		if (rc == 0)
-			return rc;
+	if (rc >= 0 && error_code & PFERR_GUEST_RMP_MASK)
 		sev_handle_rmp_fault(vcpu, fault_address, error_code);
-	}
 
 	return rc;
 }
-- 
2.25.1


