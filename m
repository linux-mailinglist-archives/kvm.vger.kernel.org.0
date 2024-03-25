Return-Path: <kvm+bounces-12620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9853088B2E6
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24E6A320A37
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 21:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C464C6E61F;
	Mon, 25 Mar 2024 21:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J2ihXEfn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29D16D1A3
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711402601; cv=fail; b=iPcHx330eEtY/UnHNhXZ7cNQKAGHGgVGCIIp8dHwPl+ZPsi5jZhjnhNlwRljMi238y4K+HWozn5S5HgkQg5P0JxvWgI3UvhJaDv0z25iMdRf/K+yNEeHpQeCFb3ukoZ/JbJSkJ5AvxXGeVAntjDBNyNd85FtTLEV/GvuFwNH5S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711402601; c=relaxed/simple;
	bh=BPTD1ZBN4UidcF8/23Yvrh2qeceyzCwLPAOvVWKyDjs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c/5Izr55vJ8VximSEP74KNKhDVQU4A3LNqDg74oW4IWgERzCLdPR+pYI5gqqSe6OfNYjRgI0BOi2AO903CHIPcTV7prKOJPeLL9WCG5MWdkklnW7Tjgh6L6k9yOFz0yLVtYavl2RVNzjpnzH2jXqFjEYPU8s4/cpUu6JGo78qz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J2ihXEfn; arc=fail smtp.client-ip=40.107.102.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJV0PI4HPUPdZgwDX9qwxj19ikTqRIVb9d6AGRYRQoi2zYZAYpCFaLodmbmQ0Oz+mkQh1MqUE6/tTNt405kM3aQCCMMAw0bojWucX3EFwRGfmyiXSZqDkonUgM7/RcLw18MGEMY1WL5MUPRz55WsF6KeK2H7zZKbWYbH8TZ/5k9b6vGa07k1XRmeE+E7mJ62KFQCYPp8BZ5QNCF4Zmw14DjHu5HD6jVgw+wKhqqfuy8wRyDXdwK151KZjQZ+xIG2pnULXryNVjjQ6iclrzIJ+ZiM8nmNolwH1av4pt4gvUpbIxUNNseJb3CoSnJaFkIf2mqfxdy1a3WlMWhP+65t+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dj+7sgR/FMLXpZPyamJPlDKwwPyI2oaqk7WisA5bjBw=;
 b=lnlCBywcz0bY/xxrHScGgVKQjTVlgjTCde2mxmb1DkY+tMLYC/CKmal2Yo9fpW6gH1lJTt4VhKzufStJhuLlkUXUbIjOC2lawN0fsyfoYUEwJS3YlQRDIydkRubTckBjaziu2bZTcKFCM5ru6KWvUkj6OVYZiB3UM0I/OoJhufLizofMg0G6lRSwoc0r2ZLvRE7Gtmlq6huSyQz32YmXH9HiDG0vtIlC+qTZpfBABKOqB0c5Ftd8z9bhQ7FEjdo8gvlRUqDH+saJ2uYPpv8Um7bd3w3clBkuj1DHkErB1046YLbX6NyiKVkmZT7PtLIt8q4UDb1vlE67HqsWyVPF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dj+7sgR/FMLXpZPyamJPlDKwwPyI2oaqk7WisA5bjBw=;
 b=J2ihXEfn4FoiwxurqtFirsHWh9nimwZIg4M3F7GOi4YclKDDg572MddVJC4zVDKBpLHgroGw0NXiflkXxk3qL03x3iwo9gJsmFnKxxgw3+yg+KBOAVPHhMtkiwJyOOTlPBedC5Rs0JCUTQKJ4y1Lp8jWBNxRF1o3Iz3W/0WPG/I=
Received: from SJ0PR03CA0069.namprd03.prod.outlook.com (2603:10b6:a03:331::14)
 by DM4PR12MB6376.namprd12.prod.outlook.com (2603:10b6:8:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Mon, 25 Mar
 2024 21:36:37 +0000
Received: from CO1PEPF000066E8.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::a1) by SJ0PR03CA0069.outlook.office365.com
 (2603:10b6:a03:331::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Mon, 25 Mar 2024 21:36:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000066E8.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Mon, 25 Mar 2024 21:36:37 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 25 Mar
 2024 16:36:35 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <pbonzini@redhat.com>, <andrew.jones@linux.dev>,
	<nikos.nikoleris@arm.com>, <thomas.lendacky@amd.com>, <michael.roth@amd.com>,
	<amit.shah@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [kvm-unit-tests RFC PATCH 1/3] x86 EFI: Bypass call to fdt_check_header()
Date: Mon, 25 Mar 2024 16:36:21 -0500
Message-ID: <20240325213623.747590-1-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E8:EE_|DM4PR12MB6376:EE_
X-MS-Office365-Filtering-Correlation-Id: 402c5583-82b4-482e-a942-08dc4d13a68f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jixcjF7hfN2sYOgkOHGwP4tL5Qu6pgSs5DBNHWDXSMIN/1cqlRgEd3NfDZkhqU3QVpF51qjRIec+3rMsI4r3LQu0l3u1NjiCD6MEfIqQdrEr2pxvyL4ZCi4jB5bfLfqQxdhXzdKf3du0jzSyGSaJeXyPFBXsxXG4z8CcnyIROaO5nnACcA/dUSOu3UnxhZenFlS0DkSHysg2YMtIwhbDhN/+bo9Hckco3UG77mudDPVO2RK7wKLvWdzzpLK65rhVns/TyhXavu6tOWsxh53yFx1PstP6w1S24veHO8NMeEuRFsIRhaZMNxeU3Q15LWju1IkyJXNg3/Oc8nZogRQsZ23FC7CCBmGS5O9VoNiEt1TbiQeHP9MRRc6fQCwmxKACZPA31U40z5pem4E86QoAmTVMbmI61RJxsF80TF3DE7lIzdaeSg+V3QNMameCJqWX/Z5xDbsyT98tzevgf0Du4/JLISfthPh1X2RwbWcSiEZZlDHi8F/raiKpZDzESHL51BNhpOQN4+2KNhCQ4mdEKUvNrBljt6nuBsaEQ6K948AaQWSuOZXAwaVMjqbEjJ/HTqfpsFJSnL1y+PZLhnfM5+3Iz2NhbzuD/wznHS0F7guDfxFAE+F4o0auF2SUeX73gSzfO/w/jgIvXm6QQnhRCHO9+RXgPSSSkJS2RBcyJ2uWBToRT7LhJetanbrsfJxQLT401vM+dp/FvaQsFNjZfy0yPdMZhRw37+9HQLaqJnZtY+EP57Awi2Wt70/uyp9p
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 21:36:37.2511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 402c5583-82b4-482e-a942-08dc4d13a68f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6376

Issuing a call to fdt_check_header() prevents running any of x86 UEFI
enabled tests. Bypass this call for x86 in order to enable UEFI
supported tests for KUT x86 arch.

Fixes: 9632ce446b8f ("arm64: efi: Improve device tree discovery")
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/efi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/efi.c b/lib/efi.c
index 5314eaa81e66..124e77685230 100644
--- a/lib/efi.c
+++ b/lib/efi.c
@@ -328,6 +328,10 @@ static void *efi_get_fdt(efi_handle_t handle, struct efi_loaded_image_64 *image)
 		return NULL;
 	}
 
+#ifdef __x86_64__
+	return fdt;
+#endif
+
 	return fdt_check_header(fdt) == 0 ? fdt : NULL;
 }
 
-- 
2.34.1


