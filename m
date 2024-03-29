Return-Path: <kvm+bounces-13107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62007892612
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDEE31F222B2
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 21:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D768413CC60;
	Fri, 29 Mar 2024 21:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VwnkJXNQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825E413C67C
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747778; cv=fail; b=Alo1KKBPLZIipZ8hq2y5l/BbiGSLGzbscAhy4Ub4SPP4x63Ib7+eBXWXtuIw6PgFOzbU0Z+nTiaM+sG4BF7dYo5aHusPI902RFNreHOgfO/ZPJMG7YBuspeeUy93VsnLnMY+r0sPWKK60d9h+U+LY61/6RNbFF6Z0N/7+8+xzIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747778; c=relaxed/simple;
	bh=CxAlODFYLBjvWGlVzw37m63fgN7tkd/jnzmXELBKHRY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4PY0Q4CVblFH40mwACPA7zPMetxTLuDVESrq9SXG0A/pTu60gcXnHwRtG+nC3wEpKm1dRKp3ZlS8p+Gne6COY/ogSGwjmwFHL3qIiHopPSqhwhzJ2hc6sP6XHIgfm8NG4Eg3x4at3Rgi4wKX8GO7tcy7sgQ8Y6oAxNI4d3ikYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VwnkJXNQ; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fv1HRFaKXQ0wYvkRoDlqRpzgKeyWCJjwv8kA/m5+mxVQyyjBgoGc32aO9uGs6Z0RrJA64yS0qhn8ba1Fl66fDksYv8YtUUxt/Nm6AbbUNhj/y/WWNXGAkzDcAuCsLPbHHqOlAFzGF8jOcGeCN/yO+ptNCKRkLPK2EjpuOWUzvCGR3wo9EaL2f6CsD1Ym3Wgl7Su6s7bORb9Y9hal/5G+R2bxwt5+0k6nxxtz+xE3Kd9odQAkB2UiCYLAgZKUkTd2YevaP19QIt4n/9i0rIl+84YTsG74OOhJkF8RIDM8sNj3Qmn+jK8fjQ7mD7SRWJnW7nQL168/Qhq/LhFk6i0BrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VOrNraY1ABO0bZ1hE/eIRvCR1N1pJSdRPyDLzh6Ego=;
 b=douoa4ReEseT69N+nZ+7yoFzw0R6pXTmmT2B+Q28/npo5+NagCSO7YSKcmFBtbd9vRu1O8iw88q0o3/6+64Pldg3uC+/gfKhXKxCpAhSV47e1gbE+MflcUMLNsUrH/9wjww2W+6rekIFNhZslMm7JI6ADClrcs8vcqQwLuupKWaweSIWHjcxKn9Tx+iMtbuRmwoi4GcR8RotHp+L8pD6ybnb8PD17+4lfJbOWOqGGZXwk0/dhxBWvsQs+P8QjUKr2nxNvT9s+E6iyq9nnhk4JSAscjfRotYv+YDmShkwo8+/qwrCkLAO4YA7mveb/XXzja+/Uaypqw02ibyfSI+7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VOrNraY1ABO0bZ1hE/eIRvCR1N1pJSdRPyDLzh6Ego=;
 b=VwnkJXNQq7b9L7qNU7JwMZS4ex1N1XoEad+GvZJpmBr2/gGybVCVm4hL3aH72UpETctKxbJeBzrUou8Kwo9g8sXxc4z6KMKzTxbjc4TEtAUKnRH81CQgnpU/wIJY8WzTP/SC8vNt11DBojhmgBSIwcjq6CHrR7yCssraWwLUJLQ=
Received: from SJ0PR05CA0116.namprd05.prod.outlook.com (2603:10b6:a03:334::31)
 by SN7PR12MB7451.namprd12.prod.outlook.com (2603:10b6:806:29b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 Mar
 2024 21:29:34 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::c7) by SJ0PR05CA0116.outlook.office365.com
 (2603:10b6:a03:334::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Fri, 29 Mar 2024 21:29:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 21:29:33 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 16:29:32 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku
 Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH gmem 2/6] KVM: guest_memfd: Only call kvm_arch_gmem_prepare hook if necessary
Date: Fri, 29 Mar 2024 16:24:40 -0500
Message-ID: <20240329212444.395559-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329212444.395559-1-michael.roth@amd.com>
References: <20240329212444.395559-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|SN7PR12MB7451:EE_
X-MS-Office365-Filtering-Correlation-Id: ed637ffd-c29d-4f5b-8f5c-08dc503753a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S+BejoOMDew66mmDDM7MwmrXga1bMMypUjDl/17doZ14Ba511OpQldeQUFn/GGeY0gxFNAVVyT4Axmp8RXLO34CvCBrfateRfiC6cPsde0mvw+9U/PZjcILf3ms1n4uf3AQt9TuOjumrxdTZiivxJvrQmUG/g6C4qK/XofWXKfUdDrIMkzzjb1tCpswjOKbReSNB3Z0V9tNeX/yvfLPFTgFbwqcjc3/Dn6xWLCuID8wSOld9rticRnJ4UFlvNEPWYYyRYrO2y8YLyXUXdjdJJehbGSXEYJR1NoBefeDmRAIKdzWZOZlBqKRhp5KEuEj33DwNQGxtc0M+bDo1HeHPMfa4eJDyYnxMsgXdgOYuAVc2gjogWx84Iarm5tTEI2Eow8MMMC4QHC6u0mDb5h9JykVv3GJixPkPjDXqJJ+ZCUy8IxQzN42p1lIvVLAXZC85XW42QWyP6QpnDXj0LkTD2W1UWrRKaeAHlKw96l5vm296LbuRjztX4RD4uSnopuLwk1azhvEPOWt15EiiA/SYmxpTADJnvO1186Lbsis10NiSwFvNe2pOJzUkAstQKJ3/Bdn0ESxCeSRJp+NmJ7cO7mg5Jstehno6ya7Zn0u4htcrJti36tVZ0bJfChTBeusDttUjQ9NO3sjbeQxc0DP6vz0DjL3mRoM5dSbhyCcKFs50wwKziVMsx0x9UM1S18eufqoLnrYlf/+vIFktymyGsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:29:33.5103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed637ffd-c29d-4f5b-8f5c-08dc503753a2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7451

It has been reported that the internal workings of
kvm_gmem_prepare_folio() incurs noticeable overhead for large guests
even for platforms where kvm_arch_gmem_prepare() is a no-op.

Provide a new kvm_arch_gmem_prepare_needed() hook so that architectures
that set CONFIG_HAVE_KVM_GMEM_PREPARE can still opt-out of issuing the
kvm_arch_gmem_prepare() callback if the particular KVM instance doesn't
require any sort of special preparation of its gmem pages prior to use.

Link: https://lore.kernel.org/lkml/20240228202906.GB10568@ls.amr.corp.intel.com/
Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/guest_memfd.c   | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f5074eff958..5b8308b5e4af 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2466,6 +2466,7 @@ static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
+bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
 #endif
 
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 74e19170af8a..4ce0056d1149 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,6 +13,13 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+bool __weak kvm_arch_gmem_prepare_needed(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
@@ -27,6 +34,9 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		gfn_t gfn;
 		int rc;
 
+		if (!kvm_arch_gmem_prepare_needed(kvm))
+			continue;
+
 		slot = xa_load(&gmem->bindings, index);
 		if (!slot)
 			continue;
-- 
2.25.1


