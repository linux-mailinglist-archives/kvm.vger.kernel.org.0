Return-Path: <kvm+bounces-49349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9DF6AD7FDF
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E47B43B70DA
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61541CCEE0;
	Fri, 13 Jun 2025 00:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2K2bfTUX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663A21C6FF9;
	Fri, 13 Jun 2025 00:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776209; cv=fail; b=ONla4FxE7bE3sGuocaHACbdfScBGWQJbMnGEzBGwD73/agfAOBRR+FKftGHUwWzZJUQQzHUHwcRKxo9tmKJVMfRaV01+Y1J2KSOolMrj9SkbPlJIIKMAadJ4pBjm82vlzfdePRhC+2ZNsA7+9uqW5N0rja8wYqXDAZuWT/IGfj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776209; c=relaxed/simple;
	bh=7VJTw98OOdwTw8S1os3LS9y3DJtHpYVdH+V4SpgQFN0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6eZ2sG2vcvDrqX+lrHAEg/9ueUrIHYFkYhh2nNjN9MuIgSihhsS0k8541fiz9W6c6poWU9qWYsINx9xfdFk+ObuQmnlCvM8gdfkzrqbLIURbtxJtVQpTOfX4O3+EvdiLI2Tn9krW00tB52SBaJsCCGQWVyvT+Q3Kv5hGVM+tcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2K2bfTUX; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BByjYdhnpTBshvtgKwM4iOhMsxmmA1BGNCBUySv4yYjZQuJvWV8v5ca6qTm9hNx/JskpKdIpx4kwyYOXzEvRy/Rg/MUTcElGnHmQ9UQI0IG9UMT3XBG7F21MS8q4mbHhjQz+jvkxy0ADUukw2Oo6WSdnu2I7oJzUyRUPxHOJpO/fqVAq8JXrh5n10k0NsOBV0kbJb5xtovs30925jowuSNeTKVvEfQd2JdyvhSDd5TgD8mGMPlBzvVo0j4IiPkOHbJnIn5oXHsB4BauGU25zNNDu606yZDD6RO/W0+Va5OOARSp/EbInpt751TwrQ/Kl+jTU9gEKe/5WrhEWf2vH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sylXUDhMR/lZnNcq0AeJVAD3BUXD5ZUf1tH0EXVDnJ8=;
 b=A9mGDFDabu0qUJoAq+jhxgXAlhOKmk0pRETNKsQYq+LgnZ+df6eMi8m38e5LzneV3doNtW78BXLGKZFxRvLePkAiH46aHxQgOtHDf4qBANXBqnyob/fhcDNRgxFhZgjxEIqOwTtA/gz70JOJQuJCtZBnHtVwhHtqkvyJFj4vNnwAZIuJTJjwvEV6lKe4H5YLhhFrHqrCfJE3IjmKuK8QnIHKqWgsLnh7+55NCYOLFdtccno0DZPii6XEI3ksAIQXiy6P+e0kIgkTS6/tWEgq62ZKGzKUz0ZGfmNKOxZNpSZ/4TeyXlQo/P/NRPlrEwR9i9Frt9m6HUWTToDpfJj6xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sylXUDhMR/lZnNcq0AeJVAD3BUXD5ZUf1tH0EXVDnJ8=;
 b=2K2bfTUXeflql7yEBc0fzmq3q+AzlcB0M5ZF1UuJ1UCNvOC2tjtQ8dBFNBDRNaLZFtu170lEY/Ns0qfFAd+jiJY0NOjYFJnoP6SberuUWWa4tXn1EgNr8Dx+ub0vOgcUsZj0qOSpKhQqfMOu1mp2wO5TBnQGA3Ng7Q8CV0sEEAQ=
Received: from BY5PR20CA0007.namprd20.prod.outlook.com (2603:10b6:a03:1f4::20)
 by SJ5PPFF62310189.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Fri, 13 Jun
 2025 00:56:44 +0000
Received: from SJ5PEPF000001F0.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::4d) by BY5PR20CA0007.outlook.office365.com
 (2603:10b6:a03:1f4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.25 via Frontend Transport; Fri,
 13 Jun 2025 00:56:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F0.mail.protection.outlook.com (10.167.242.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:56:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:56:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 4/5] KVM: guest_memfd: Don't prepare shared folios
Date: Thu, 12 Jun 2025 19:53:59 -0500
Message-ID: <20250613005400.3694904-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613005400.3694904-1-michael.roth@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F0:EE_|SJ5PPFF62310189:EE_
X-MS-Office365-Filtering-Correlation-Id: c24ce6ca-0add-41d6-fb9d-08ddaa152adb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FXmcCCuFeVt4C5KHOU/Nco6uDGWEJmMo69d5cTcZypPWrNvC/89MPvypWWXY?=
 =?us-ascii?Q?I4vw7Dvu4jQjE3W1a9HMjJfSYuBtdIhYeAyCeh2u968jRSrQvSUbLoiQD6lW?=
 =?us-ascii?Q?ZM5ZdKCPN2Jh3uMTyhnqrOV8gHFeCWBjpGIKG0EMotcdGmON6PQytphhh3XM?=
 =?us-ascii?Q?yTww0fdWewkwuPICAGK+I5bXPjRSUxe2HbRDCPU8IXnS/nybTr+SH37reUyy?=
 =?us-ascii?Q?lamcZv7cFOnuAtaiiWlT6uJ98Ye1o75nzX7piOCLuM44jNa9q03ns/Cjrpv+?=
 =?us-ascii?Q?/kj+LAYfHlBh+Er1R3+9B3eQbYMsgKzp/O44dNbBI31ktQKblptlCFhVJ3KI?=
 =?us-ascii?Q?YeRtsQpJKiY+5JJgUVSy4JUJElt0h9bjn+mu0Z4k51bKLYjS3Uyn+ObPM6B8?=
 =?us-ascii?Q?m3/QBvuMvO2Gbdg860vSODU0xkgXPpxP+lKjsUWr+QiHaIQarXfsiBLy6jz/?=
 =?us-ascii?Q?IUYuhFPgZfrAVl8QTp15cLanapLaoyVyEVu6qdsUBPStnc2hO00EpkhZQFUv?=
 =?us-ascii?Q?ux6zXx1Y7UEy7iekq1a3Saphw92Cef6uuAGkMeJaGgK6n0mXlE+GW1KCQVMo?=
 =?us-ascii?Q?UlDgzT9Q7OouQfPR9ZHFWnMFL1ziVSmQfNTLYrGffitHrdLCqDzFnLei86Q2?=
 =?us-ascii?Q?mxjJ8lwWajNs9fFg+iLCu+cGUDwFg8E3dckxV5yvANgOLNSMo2k6lrA3u8tj?=
 =?us-ascii?Q?Wjj1tF6/hFNPjmlcJ+93p9FN1nEUpH2LGXsENoo7QjkZQ9S+yRYRdMCD98nf?=
 =?us-ascii?Q?5RnHqfijKsqAsu2CCgURL0ZFPfzD+NxUNEJOmDKZVSHImzpDQY7aOMFcpArA?=
 =?us-ascii?Q?5x+Jbv5PjNhknSeMDguETqyT7oyNQ4+Nsex04lfPCcr6hkdlEREIqe8nXX+5?=
 =?us-ascii?Q?2EzPsVaOV1lN7k5WcM9V9kBTnrjWu3Rgz4qDWD97g19r+umI8vGdhI2kuP4C?=
 =?us-ascii?Q?NyrtRrlanotQGZwmw2bfsGFE4w36GCMNvCgEvlbJG71Q/mAqeHyKz0TKQkpu?=
 =?us-ascii?Q?hNaS70FQJcTlFJzy0CC7ErUX5Fk3KBGznbD+9YpyXPH37QfyiRQgUFaNx8Zw?=
 =?us-ascii?Q?img+9AJT9EL+3PxymryxJjS0i3hIA2gW8Vz92RmEHxiveF9O66Dq+voOLeYk?=
 =?us-ascii?Q?Pk/vXklzcidGUZll8JItC75T0qGcJ4UvORG70FeQB/rHXWaxnZ8FAAHe6G+L?=
 =?us-ascii?Q?krwbfYm1WymcciOIrEXE9yepWkT5ZHFHIxqonMAIQ/NSthRP2OXE3/Jqrvdk?=
 =?us-ascii?Q?Zz4X9XYTeKzId1n+rra8gjkqdiV5Pxv0hR3MuSZiMN4rMy1uynWbIvTQKD7h?=
 =?us-ascii?Q?l2Pa2+H+K6HeTlEW7VEx4M34xnQ6M5rogKxClPVi6+CSFam2i29RvEagTD15?=
 =?us-ascii?Q?LHXKPvXO7imnwo73CN0TSAx7KDT9dCf4ANERa3v0oMwz8waxuBnxLMw5g2UT?=
 =?us-ascii?Q?wsR7hoTXglKMj/hOxSPxOmimXU2P8ZglFReuAww71z/xuLAVat5KiM0io6Ep?=
 =?us-ascii?Q?Z6lsrmox4KrXXc1atCfD21ZU2s/P0HVmAYpM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:56:44.5293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c24ce6ca-0add-41d6-fb9d-08ddaa152adb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFF62310189

In the current guest_memfd logic, "preparation" is only used currently
to describe the additional work of putting a guest_memfd page into an
architecturally-defined "private" state, such as updating RMP table
entries for SEV-SNP guests. As such, there's no input to the
corresponding kvm_arch_gmem_prepare() hooks as to whether a page is
being prepared/accessed as shared or as private, so "preparation" will
end up being erroneously done on pages that were supposed to remain in a
shared state. Rather than plumb through the additional information
needed to distinguish between shared vs. private preparation, just
continue to only do preparation on private pages, as was the case prior
to support for GUEST_MEMFD_FLAG_SUPPORT_SHARED being introduced.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f27e1f3962bb..a912b00776f1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1376,7 +1376,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_shareability_get(file_inode(file), index) == SHAREABILITY_GUEST)
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
-- 
2.25.1


