Return-Path: <kvm+bounces-49347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A29DAAD7FDB
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 232543B6C54
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F7D1CDFD5;
	Fri, 13 Jun 2025 00:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NCckkxXj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2046.outbound.protection.outlook.com [40.107.100.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FB81C84C4;
	Fri, 13 Jun 2025 00:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776174; cv=fail; b=i7aofjk6C1zSPslwOrDB2v0yUIXRUfy0MQLqXbfZGGgQcIkSRGWDwZsIqp+2RJcp7ym1NUCPmjgLXzwVQIxQaX0p14ZvjK8Oz0eL9Zq8hWDTWChMrkxlWzre7yeyXgVd0vDtV/UDp8yRIe4s1NkbKrXik0v0JbZhXzAP/+CGRIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776174; c=relaxed/simple;
	bh=AG/BGR530wAPT1XxvFExkP9qvzLtxGc00SmeHLY/ub0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oRBIR/SH35B0/45fIoamsoMmqsvOFJL6bZ7FIAwT0cvAwxeT9g7zuMGRd4DNJKd6CQyNlU/XTw5y/V5RV+t9tk2T2onKFgdFMvhC9QJ+tJ0qc5O/epxD63iZSkAoINlF1A8tQ3PB92PaR39WqlfTrYWSikD5ljcw74ye1AU4oes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NCckkxXj; arc=fail smtp.client-ip=40.107.100.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tj0FFh+UPABXNSxgbzUpzFEx5wrdVy6IMB3hozuJ7sZCcJYBnqvGKUtflEVslcleb6x+kh4HyxcvCLnwPdb6N6wlIPOUo1sxh7jQ3398hupFtoqWtMVwIrnbB4I0VimiWkTetw0rpRQkzM/mcdH50g6d12irdl5wafwVDhNQKSJQHlRiXcsTYORtd4t1jCUK1YMS7hCAb10kizt7HNKZej2eco0R6U6dbrWybVhX8YWYC3u0lNVFkmPe3RmDxuwl4VacS6ZMupTZTiIJqsoG0IgC/9Lf8YTIUihb/OAY8ubiSez7Kwq9Yxq4Bqx/WIolhz4wdToFGt+P+0DETIaTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojB82e/6aYnnJurKtM2byMu4AkhgvZx9DM0Sk18ntN0=;
 b=MGHDpjBLwBKWPSIWYAsmN/4AlSehiuC+7vuq/Y9NuvaTL98uu9a4QUzAy2Vk8n0wB4p3Tc1PNFCWze/5+zwlDZETYtMPrcGF49cV5QK3dWdClNb/wyynkeG4Jd1xzIjfjo0Ec6yLUHfljpRnwDWsXcf8/2GkyXEvlZGUSm/VGi6dT6vISfErNEl0NgN8CSqd2uGPNJAqEnrxTLPlxIKvRqfyPOSDrArAey9lvDGcJwmfYjsj38Sdr1DEk+2l+AsA3YqrYN4M+1K2oRrPioMzigShYnPSCcaK0Hib2LdRN90k45BXGlYcNCnb+aWqax7lLyaH9jB1w8udSfn9OlhiNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojB82e/6aYnnJurKtM2byMu4AkhgvZx9DM0Sk18ntN0=;
 b=NCckkxXje9nTT/w9ocDPY7RcbPVu5vW2+8M8k6NqNHOxACoJHUXtgdBNY5y+0w52Io41bKNNKS4X+jpTnHrJX5CLyOAdURMmeMj1c2EGQin60pl1UPZ7vh6D5OqF9RWRb0LnRSJgMYZZKablCs7zcrwCbFZGuFKPb6gMW+hRvHE=
Received: from BYAPR21CA0024.namprd21.prod.outlook.com (2603:10b6:a03:114::34)
 by SA0PR12MB4478.namprd12.prod.outlook.com (2603:10b6:806:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Fri, 13 Jun
 2025 00:56:07 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::a2) by BYAPR21CA0024.outlook.office365.com
 (2603:10b6:a03:114::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.24 via Frontend Transport; Fri,
 13 Jun 2025 00:56:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:56:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:56:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 2/5] KVM: guest_memfd: Only access KVM memory attributes when appropriate
Date: Thu, 12 Jun 2025 19:53:57 -0500
Message-ID: <20250613005400.3694904-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SA0PR12MB4478:EE_
X-MS-Office365-Filtering-Correlation-Id: 37fea1a6-fcf8-46c8-3ea4-08ddaa151471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CqGj8TXvuMb2b7Hgd15Ut1kUVVJRg0AcrlnjglfpgvTLlS92Es0cHnwnMpBh?=
 =?us-ascii?Q?7+gIJhAcdEb1vxhNZjQBgRO5NI365BuBuQOO4vD/FNw7bfcs/3f9EusfmJ27?=
 =?us-ascii?Q?LAlYEuJQnSS6e8Uie4Eb3/6HYlPM+7xyfpMh9KY9WNuy2v8TRaBLVq+C1t2S?=
 =?us-ascii?Q?RUwW6IPKGrloUUteMdW8vqH9acknXR3Vsxn6fsQA8T1ZcTVn3LF1MW2LW85I?=
 =?us-ascii?Q?G5Ek09cd2heevKYQASP/SRKgsopj/jsjyYF7u9VkAXVBwQQMDUF1bvIK2Nst?=
 =?us-ascii?Q?F0TmKOK9o3ShtGAmZAOrIU5ORDKTrsTVjl6XR7YjJR8TQfZIfcAhaDa9bCSI?=
 =?us-ascii?Q?ppTuMZw/TnUG7o4jYU/DmpeT0y/UNYQSVIFflXs5Qnr5tYQRYfRAwfPEYVvC?=
 =?us-ascii?Q?BVkbZ3vVsHKJJepd8JFg5hWWgze4p+VcYLvJMGxN/HBe6rWePpx86K1JUyqD?=
 =?us-ascii?Q?0aVNCGuKNiupA2WOadNyKYmhx0BTuGxfnpdrV3zMUq1zmH7slDehOq/D2Sx1?=
 =?us-ascii?Q?+IKjNHrZLb+09CzTavOkfKLjPa5zc6eQp9ChxvE9Gzk9f3zIB3nmIowO6fbH?=
 =?us-ascii?Q?5SZB0ECmd06XyELTNWXnn1x5UWYv6NeGaw2jCSV8gJBT4DWY63ZDGPqf8ZPp?=
 =?us-ascii?Q?V1fJTdbPbs7y5vf8WndxErZj7V/uEvESDdO+5Lh1CkMrMLMl90g1nl31/vir?=
 =?us-ascii?Q?r2xLmKFIS7/4+IPDzSseICfNKPpcNRMBUWcr9vexPp0QTJeYpZRRCxfocIik?=
 =?us-ascii?Q?wk9AH8UEkA1JxygErC/C1QeyVnaWHnhTKkH8/1BsCoE2N2nYVI9/GUaZbiMN?=
 =?us-ascii?Q?93ppcH+d+XO2v2ciN/3k/HXTQ9B7XORtbCIopQEdcO3GzhtkNkdgNQ1oxxpQ?=
 =?us-ascii?Q?us2Al1ZDBx8CFGezwOgTve5oM19MQ4Ot/EJIyijaYG0C8T/zdjwTm5biXTMU?=
 =?us-ascii?Q?3zf91PEhIP/nhXZuTmitoJeTd0PjTNYOwtfQgH6d8lYc0/80jc1JsMZ4ONXe?=
 =?us-ascii?Q?Th+MtUOADvNBnIHZcWUdnRf0iyoyOMIL13TUcdC28bb9QAbqqW7xgqoTibJl?=
 =?us-ascii?Q?1IBM6YySmyv8JXulUezKiAzM/8KcSO61pP13U24L3a84wL9TaLDWvWbvYcBK?=
 =?us-ascii?Q?IMwKMbWnJjNqry1wDFqqoqzfcO2IW4XElN3xrDabOqwfhr1x5nh1uFDntlhq?=
 =?us-ascii?Q?aH0/QF73sYtGsGE73O5SmtkhGLPyvxhClp96TVmXI+r9fjs9cGln1nwmAlC6?=
 =?us-ascii?Q?ghZK18oK1F4dRpTI5RNVlEAptOv++Wpw7sK249ZjLEVGp0basFqjOyjEylfP?=
 =?us-ascii?Q?qwOskVzRtIiE3gUaGKpG24FUPmsjR3vaUSOeZdWoy1qi7CLDBAz8b0YBiz2w?=
 =?us-ascii?Q?c36J5H0dfTisCOiHir62JWOuv/Dxb6fDCDkpKOn4s3vSIvToNroTx/EfY+Yv?=
 =?us-ascii?Q?UlDHUr5kn7Tcnk08pfSp7YL7gB8y+mLokj2bHT5OzrQxykVRQFl04P4s/IQe?=
 =?us-ascii?Q?D0BhJOlkoRZUIFAY8wCqidh5GWezX97OQu7Q?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:56:06.9199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fea1a6-fcf8-46c8-3ea4-08ddaa151471
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4478

When a memslot is configured with KVM_MEMSLOT_SUPPORTS_GMEM_SHARED, the
KVM MMU will not rely on KVM's memory attribute tracking to determine
whether a page is shared/private, but will instead call into guest_memfd
to obtain this information.

In the case of kvm_gmem_populate(), KVM's memory attributes are used to
determine the max order for pages that will be used for the guest's
initial memory payload, but this information will not be valid if
KVM_MEMSLOT_SUPPORTS_GMEM_SHARED is set, so update the handling to
account for this. Just hard-code the order to 0 for now since there
isn't yet hugepage support in guest_memfd.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index cc93c502b5d8..b77cdccd340e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1429,12 +1429,16 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
+		if (!kvm_gmem_memslot_supports_shared(slot)) {
+			while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
+								KVM_MEMORY_ATTRIBUTE_PRIVATE,
+								KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+				if (!max_order)
+					goto put_folio_and_exit;
+				max_order--;
+			}
+		} else {
+			max_order = 0;
 		}
 
 		p = src ? src + i * PAGE_SIZE : NULL;
-- 
2.25.1


