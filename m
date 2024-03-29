Return-Path: <kvm+bounces-13106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C875489260E
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 22:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557611F2277F
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 21:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4589613BC02;
	Fri, 29 Mar 2024 21:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2AxYTXet"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2069.outbound.protection.outlook.com [40.107.95.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AF13792C
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 21:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747756; cv=fail; b=nXch+0VAZUf8LTNBJR7M8CxHmW9ulhfR8fgdH+cvihsUgy8JRUyQq4fIGdJQ8uPwNyaktk4OKJPhKPVRIc75vY+CATAU1cuyItUfDXpLE94XWq2kpBW0jWlcBySuy6KopBeC+nG/pv6X73d3ctfTekVzSZ4L7vNFyULsoA8mhRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747756; c=relaxed/simple;
	bh=5s4kK/WP9ZqeYVhiSqxoJ57SFYiFP7JevhkyTaq6wRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7BO1T3BO38asbpLYLqjqj0jeHM/BLyQ3dbtF7b8eIuqHErLbpv57HfkMUp8rZJcDiK0aaxSp8e23VzBvEBQn7HrUGL3B7k4XXmELwEMcvW4+duUARpe2O4FTWMcJIzp3eSAFkvU1CUIn7QBufBlWhuQh0QiM1LR5kDyBe4LKL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2AxYTXet; arc=fail smtp.client-ip=40.107.95.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzFk5wGTClgL1Hsoxgk+gRVGgXrTLnTk4J3YtRzeH7uc8jNP5hjhuAik2fH78W+2A9OE0MvJqeiDJxMOSPpJiKOPUIjw2L5mHnCoa1r4nhyKnCUREJs4v8Os2xFOhhPKzy8jkeZNa1bAxs4JefCH/vGCTL7MPCBrdmmFZ25OUe0pyy7qvYeLtbO/WQhZRoAOgvo3KWQcnbmpfyT4hHcZE9cPszLb0zBj5XNxDKoG+r2C1sRsTPWyj6eUvL8vPgovGRdrf77nEaF328DmZFpG93CY/tmLE44vz0uSG6BDATikiTiokz2L7BC99/H+towz3rLcAlHsuA68+iWKSKZkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=biAfkB++kZWlpmZvTkqedIFy/Mxtmn0mW1+CED4pjEM=;
 b=b7qfre/S7SOzVo/q85OBvkSc3Z27f3wsPsjSsJqxyyub9HScSkBzmSsrZBOgp8JXFu4VYa7hcR3fO7qJqkOWLFNh+VX3ORTbamGOKWSJ673EZueJRjYJNVoXxyypVEZB+t7OPx4rWzwlMZlxhuO0Cpsy/m/kYgB5NK18N8nfUbQ+f1yAL46BFQGVGLGfxnJS5BO2/Uyl/QDCTTqxc1B924fYQtDEuz8kEZNsaC/qMlM0Y6yh8BuYLy33KpMvBhRUBIFCXz56zFh3gMDj9h3uPayYY+lOFTzamxYHnDth/SF8pjYJTKfTWTtiFj1RS8Rd5hxmqk9fAQ2dhpklHyRwqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=biAfkB++kZWlpmZvTkqedIFy/Mxtmn0mW1+CED4pjEM=;
 b=2AxYTXetQ2rCsVx/j7Cf4m12osbVgY9XeUi6XY3HF176i5NVLMf1HMa17l5NDa9UmlNT5WAngnVA35jCLnnfztYSKKjj3axfxSi0InEgXbzHu8kNXn2iM4lpPrYulHqQPjXUke69sSW4JAh0ueyS3SYN12CJRlS3OmQyb4cPT4A=
Received: from SJ0PR03CA0020.namprd03.prod.outlook.com (2603:10b6:a03:33a::25)
 by PH7PR12MB9074.namprd12.prod.outlook.com (2603:10b6:510:2f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 21:29:12 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::94) by SJ0PR03CA0020.outlook.office365.com
 (2603:10b6:a03:33a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 21:29:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 21:29:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 16:29:11 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Binbin
 Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH gmem 1/6] KVM: guest_memfd: Fix stub for kvm_gmem_get_uninit_pfn()
Date: Fri, 29 Mar 2024 16:24:39 -0500
Message-ID: <20240329212444.395559-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|PH7PR12MB9074:EE_
X-MS-Office365-Filtering-Correlation-Id: 6faefce5-2934-40f6-fab2-08dc50374721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aucdNKPI2+QfE6zc/gdeUopuMm8nDykSkS3U7QocOC997HqVzQENeA4OUaENpZ6cbrHzqLAFayu0qE2gdXADnsrAcCPH3mkTnxRtBCX4MoYrN17IkPIg5R/bOd6IyuWI+wL+HQr2UeRlM6/kv+CrRAN/rT4+Rj4dCCy6BgOqC+dzieug/jKVHdNbgbR/DHq00s2PpM2RNHkqjH7pahmW/EPBSpnkLkkcFmOCQgDTzEVe+dqbKjiD+z9g1kZBtFDwMWJxw9f8iRZ4e0cGBy1oXSguE1PorQ2/lBBtSD/ara3mY6WjeuiT59v5QwFAU6Q6+IeSVY4eSuzVfdxhNCYVBArtlUUOmdKSlN9XS0zeeZic8Tw8GctMqsGCgoVAAQw/7HNq8tln255ylP7PujXuUZ5CTWA0tG68C2z01y8okR4RFkx5Vpy21niauJUcG0zd7Z0yvK6tbuaBdffzQSqCHmoH7+0QxBIoheGiGsHCdEo62UhUOQkSi39J2MLN2qYzSlZz2dEXQeLkSR6Ln4DzxdtuZe2fcvLUmlsFmiTXQ5Pd+wgTbvBEEwXOyFn+Mu8Uoy5iv3kQ9nRq9PrOajQ9QXVnxkmEwfu9Vrpv1GSwCixuYpYa96yfq8zu+IOfkpKOwh1DgDqR3ucsTKSLa+Q4OttrgxTvoTi6Bu7VBxgPrywn5xwMxM67sOlbWF10jj6M6JZNIftcSD2n5zZ6QuAs8n8HO82kPq88WsKxDP5bXjKAYDCalVybC+XPvwsusKzP
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 21:29:12.5350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6faefce5-2934-40f6-fab2-08dc50374721
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9074

The stub needs to return an integer in order to avoid breakage when
CONFIG_KVM_PRIVATE_MEM is not set. Add it.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/linux/kvm_host.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 73638779974a..2f5074eff958 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2459,7 +2459,9 @@ static inline int kvm_gmem_get_uninit_pfn(struct kvm *kvm,
 static inline int kvm_gmem_undo_get_pfn(struct kvm *kvm,
 				        struct kvm_memory_slot *slot, gfn_t gfn,
 				        int order)
-{}
+{
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
-- 
2.25.1


