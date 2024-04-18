Return-Path: <kvm+bounces-15161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D228AA379
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 220511C21628
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 19:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2E71A38E0;
	Thu, 18 Apr 2024 19:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="axHW9D27"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D52194C8B;
	Thu, 18 Apr 2024 19:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469816; cv=fail; b=GhKGboApEdkwWBzTPj6Fb4uq7s7RJaeTETHYgfi9XwtCcFbqkK0bEAhNd5qe3SXEHydkD5bGXQAQwq2R3wyN96FbMA5gt8cOGuSraBZS+smLqAxVHQLlLDXHmzKe1uqdiZrQwYaIWla5yxB9AFoCwOYRgK9WoOZitwYGdTHXAm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469816; c=relaxed/simple;
	bh=vaHHEsrhMA/Xpgza418hhGIcqmt/2Jjj8ayB4z1oEWE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Olt+JOh2qVwn977l2/NF2kr8wbksWN/7WYFgghIy0LN7ZRyoKfsKrtkHTPUOgU6IuvR30mENQJy0gx+jegWhhsiProy4NqGtaKNy+lb1DkRl0Qrp6s2harLIUA80ED1uMNSELSn1PsUz9dIY63lXT5Ym9/YoLIRgM1M+pb/Tsu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=axHW9D27; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArW/QJmcftebVVT+YaYhc+WQR+6QM3Ub46I26PmShJxNcJZx+J6doFIoqNLUN4XXkMSu0+1qHdqUplhOUMa05d/BiIufqL0DpQJbVHicozvY1Uuzge6jp1+rC+U3U1Ype0sFej7kZNtl2KEkqsmp2wxTdksvZEtsfvlNX+a/UejlXeX8lMNADJ2B6CzXThlYgSjYyhrSqkVpHm0X+lEgKZ7W9YHqbKc78BFuH2OMxVppZUiqTtHb2UM1V7uwaIlJmEvUAk/yX8uYlemLPGWyvC9yK2zJVyJqHYwAHKl/Uh5Nq9QjGajY7713aajIowQrsaXX3we5/cg4sO7Dv8McJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8a8r+wGlAmKowsHm+qAwzHuLfc+YE/a2x4mxZShjlo=;
 b=dFeyur45glfe41yYBwVkgGd0QyA7OOp4ndmJkgKAhqmcXsvniX0VPNdex+OyX3obHx5+d1D2F1zzNSSrYVMmBXz3xOBTDU1fIBtdpNGla0hwsV3i2ZBofTVSn04OgxAsM3pD0LgatQvaNMtH5QFYxTqRzwix2mgP6tXTkNKmvG22VM/bJwXicT+KFAtt5KjHFY2m2I+xEdkRSWwoQLv3yg5UbtzPFbjgr4V2WXG1Wj6YCfRGd4na4xu1ZP29dN3B44zuAv9vzJz2Zk+LlQFxyP8Z5GO4u8LaL4caiEAgYBhoenhlbtjjX5TKlGSE66dn57rKDjH6rp20KPR3CpaCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H8a8r+wGlAmKowsHm+qAwzHuLfc+YE/a2x4mxZShjlo=;
 b=axHW9D27GZCy8kT4B4cHVIZcTY1b2/rS1c8RRUeU4Ao5axgZSS1sge7V+oK76qvdvvhdEbwU8/5fYQQzEMJ2k0XqUNwIeydLtSJ6sKRlswYSM2dJLRejUbVnpmFhJNn/6RD0Dc+Yr1Nw2hqNMciE8svrWgQZCoTH4dw9Hio55wk=
Received: from PH7PR10CA0016.namprd10.prod.outlook.com (2603:10b6:510:23d::8)
 by CH3PR12MB8260.namprd12.prod.outlook.com (2603:10b6:610:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.42; Thu, 18 Apr
 2024 19:50:10 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:510:23d:cafe::e9) by PH7PR10CA0016.outlook.office365.com
 (2603:10b6:510:23d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.28 via Frontend
 Transport; Thu, 18 Apr 2024 19:50:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Thu, 18 Apr 2024 19:50:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 18 Apr
 2024 14:50:03 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v13 04/26] KVM: guest_memfd: Fix PTR_ERR() handling in __kvm_gmem_get_pfn()
Date: Thu, 18 Apr 2024 14:41:11 -0500
Message-ID: <20240418194133.1452059-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418194133.1452059-1-michael.roth@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|CH3PR12MB8260:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ced7cc6-6aa5-4de6-1ac2-08dc5fe0c117
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NKhIbCxqTv+HIaCagIxk2HAwJ0NRLH5I1SEvS4zpkAScXl/gqj3Vfo/X0FvL265ezKqC1k4P9ahcncXXZQl3B+gbFDvNYBt7VxGpwA3Z3jYnPZydtX1gFYlSIfeu5HPu5bnv/et/efQqjzqqbpNCb899Si/UJ0QvGOYVIn5rc9yIsdf4go30wpHsk2F+fiB7UYD6Tr/aErVWMRYYA8ES9ZRkO45PcVw18rvNIsFZLUnI5ByMq1gRy3R0Ea/A4kHhZ5KXhMqyh3qBGTnejhlwc/T4TOFJeTG+X4AYKcoiR0YV+fEJu5S1V6qQ+kS+iO52hAc4nqhyu0eR8dzY3ihA0+tcJokT2PjVZG1/OGYHEMpFdCRSIgKaueFprwc/MdBv3Gtc66COZ1SAgftajJ1v7PhI0OSBnIzxeeT8cYw3DLt4iqIXDniM2pH6xEQb4FeLDPhgmP1xXKaWsXJ31YqaeAD6F3Sg19WSU9GQEnZvLQ5Dx+O5Nkt/3e/PimC8M5jD6j0HNHvH3w67ArZTvFKbqPV83Z0rD2YaPqF5oT++iqyRdO9+7vppBEoX8HHgW3SyLUBGpsXX3XYCwWsb9wOGugdnGczuE24z3SrHTyuQNTlIhVDbqaT2f60HbM11sRhQs4bdQKepxO4LK3rTf1u+XdFKlEkVMHRorivrmORDyQ9mC+Yel74cvJMhPAqCjQ1INAcExWMioJvWoMQj2oSJbDEFNm0Opy6VzELGB7no4Pv3NB2X8mmITugng/6VLjuj
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 19:50:09.5972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ced7cc6-6aa5-4de6-1ac2-08dc5fe0c117
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8260

kvm_gmem_get_folio() may return a PTR_ERR() rather than just NULL. In
particular, for cases where EEXISTS is returned when FGP_CREAT_ONLY
flag is used. Handle this properly in __kvm_gmem_get_pfn().

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ccf22e44f387..9d7c6a70c547 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -580,8 +580,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	}
 
 	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
-	if (!folio)
-		return -ENOMEM;
+	if (IS_ERR_OR_NULL(folio))
+		return folio ? PTR_ERR(folio) : -ENOMEM;
 
 	if (folio_test_hwpoison(folio)) {
 		r = -EHWPOISON;
-- 
2.25.1


