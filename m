Return-Path: <kvm+bounces-12224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3041880D51
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:43:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E361E1C20A9B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF3F738DD7;
	Wed, 20 Mar 2024 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IT1y4LLi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DFA381AC
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924177; cv=fail; b=lWTiJg+ua+wvH5mdwwuzHd2eQi0ZqSCk1g13ej5nDYSTjZB2gH/axl7tKxO/OkOOJ4x7eL2NS9ZBxRLZ1ep3AA+J6TgwcndbWETjaXna/glJFI+Gqe4eXgRX5ODqw9ZRGQ0/wwi2TriInPBAMesCAjYDW3usYv+W2ca9HdQkZEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924177; c=relaxed/simple;
	bh=jQKqFnu+XYAHgCZkdYwpkcD4qdlkbUvBvsDNryXsPDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ez1AuX33z7IibpyM94k67siKt0IGubEmlywLdueGCC48vQzwV5M1bI2bh89GBopNj/3SKCtBZMqaMN4egdZwTk0t7muViMt6v1vgamix2ZyTbOHGfvLJFd8cIPr1BgB2zjRF/cYlhXfMf/f0CefwUzgohiaCUKicP2eD8AkUSHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IT1y4LLi; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X31F+fhXMSab3s8rapvM+tGMnBWe8F+fBvZyBfVm7zLtvE7wap48zw/DTVHjAiC8ha154Oh+H6jRemYtdVNVEBpa13U5oRYo1Y8MOo7VCmSZTLIJ0G6OoIxmkYwjhrqB4mLpS5TJtZehy6v3T6uF4XfiHTw36U7zfda/pDJCKl/swBHZsYWMdvxQdMCMxCClQaNZiZKWILfj9aTXGe6RfObQTyaRs/hFQu02s85X3XS7h83/axmW3Rrnz70poQ7Pylfyufr4Cmi0jyS1EqG88rgBtteshhpuoHWtiN9Xkls7soAQeh4Iweaxp7N0Caj5DkNJsYqR1O6BoSDHZY0bNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n5MP0Hwjr8JvwXkWYuZYjiKDtDbq37GHEbSfFGNOkw=;
 b=PHxi33vsrw8R59ut3FGYWLTcBGFCrDsBQSHG+o/FhypOjnWctHOKdCJQtIFw27qhkoB2yPyNaPj396zuYDAfpLyoqWAu3i7gVZ9qwGaivVJcnvj09cZYH6TEwSrXs/iPyh5y4y4hupvyTFY/KNFi8QH0BMJm63hHDKRVLQSjds2y/Xa1EGHK7+u4PSaUtGj4QK0E9G8WyrQQ1qQKVn+sbCqvNw6Vnl8M5rDFxUGDKM0S5Xwzzzw1l57Eguff8IvbCPpTTPsKzO//czxYfAj6FvCkYOflEHmD9lygXYIA8sruprY/rFpfsvcBkxvUrU6T5dF+dH/xJ8vbnTEENPKXEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/n5MP0Hwjr8JvwXkWYuZYjiKDtDbq37GHEbSfFGNOkw=;
 b=IT1y4LLiq9F34sh0Zn1kBSz8mYGG3RL7Zz71S1gaf3Jq7k+SSRuZbApd6QZ46MIQT1hy83+Le48G9FCcaRWkCCaoAOxc/nhQ0SbwTOxxN/nkD8QSuGy3EbrpPvuLpKwsRi4j+C9xd+h/YudBwCy8BjYEYCf1zER/w+p703/x6+Y=
Received: from SA1PR02CA0003.namprd02.prod.outlook.com (2603:10b6:806:2cf::9)
 by SN7PR12MB7449.namprd12.prod.outlook.com (2603:10b6:806:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:42:53 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::6a) by SA1PR02CA0003.outlook.office365.com
 (2603:10b6:806:2cf::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:42:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:42:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 13/49] [FIXUP] "kvm: handle KVM_EXIT_MEMORY_FAULT": drop qemu_host_page_size
Date: Wed, 20 Mar 2024 03:39:09 -0500
Message-ID: <20240320083945.991426-14-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: af3cfb24-c77d-4b43-4845-08dc48b9bb92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vNcKNic03ixGx+QiTuD3tD+T8XhVPE5oTRXuwvNrl26krf9BFTHA51VSGtgXRXln8lnclCBJg36RxjGxSJA+28yQR8pabbPut0yo4/54Yv6Ka9Hbm2PTwFgjFyNSN6Z7AAURvRhLmSLskPr9TaJKPBjBtH18NV/u6mG8tOXR2sEHnxMEjtU0Okzr0EypkCNllJEVDVaHkxy/tkLs1FWR6s1X/a9wZPdee4zZYovbgrMHpVt9aIV3gNUDFDRXKZ9k+cgV+cLaThx/rBRtZGY1v8o5oIatS2T6y1pkVva66BMDkAQMLQpGo6F30qTB2qGyDktye6PbwyGqZSl8m5sdssIAbTCGYwbp/trNzHj0qDSKKlSksx501hnQzwQUlknrRI1DJBp37fQ/KoBlMa4tq7zlA85mbSUvZd9LF5Siuktzyf6D+C6KkWGVF/kopBVHKmlqb+Tsg3Na10z+qNGlEz1GhmwmalhmOOEVnvvp1WSVURzibGHvtuLE/AQkO2B6NkB0oylEgR8PXP4sDzEMb9pEIJDw3tl22oqPZtUKVQ6g4XXWzBSuGySNSQrlXjH7z5DEnL3urNZgbpVkHtbZkvW5uelVkvS17VDVrqbRya8mv5clu+kT8olsLIJNHvaGgJTFV70s859vV/ukS7FfAS4JN+vj9qnWIG2YZBwtPHI4GjbHGD/xP1ylBgLLO4jlV2PQ17sA8nRXnxuzpJI76Vu8fJlrILXsPpHNKO+E4ISlCN5q8zCjQCx4TXmw8Y74
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:42:53.2218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af3cfb24-c77d-4b43-4845-08dc48b9bb92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

TODO: squash into "kvm: handle KVM_EXIT_MEMORY_FAULT"

qemu_host_page_size has been superseded by qemu_real_host_page_size()
in newer QEMU, so update the patch accordingly.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 2fdc07a472..a9c19ab9a1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2912,8 +2912,8 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     void *addr;
     int ret = -1;
 
-    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
-        !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
+    if (!QEMU_PTR_IS_ALIGNED(start, qemu_real_host_page_size()) ||
+        !QEMU_PTR_IS_ALIGNED(size, qemu_real_host_page_size())) {
         return -1;
     }
 
@@ -2943,7 +2943,7 @@ static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         rb = qemu_ram_block_from_host(addr, false, &offset);
 
         if (to_private) {
-            if (rb->page_size != qemu_host_page_size) {
+            if (rb->page_size != qemu_real_host_page_size()) {
                 /*
                 * shared memory is back'ed by  hugetlb, which is supposed to be
                 * pre-allocated and doesn't need to be discarded
-- 
2.25.1


