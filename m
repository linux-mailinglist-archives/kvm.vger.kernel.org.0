Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA13060EF78
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 07:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbiJ0F1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 01:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJ0F1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 01:27:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F1015A32F;
        Wed, 26 Oct 2022 22:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJ9srAZ6ORKkm1vI7P4Oy3A2fXOXJlm+Mz8e4YHfYnBhwyitMVo5Pfydyq0I3s3Oqu2X6CXeW05A7H7m7H3xY7Gl/5T/LNal/bXj+88+po9g2HlOm4PEZIzjXMlTNZBRZw8z3pgSgpcGxucp1MIQxlEQWH32VoI6Eak76UjIkPDlRRK4cQv+EHn6AI8GML6aK5k3SQ0rxW+dtPHqn5kK2OXX8kfCo6Att1HtyQr3nt56YS1nvrzVapqJTIN+5roUktQovfrmC4RFKYFE7M1a4lIX3znXWVdR2hAjgSelNJaMJbonhMXw2KV+GqQUt8s1TkX7/jGa5HhKB/O29szaDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxpVqRrbQX2vXuNsDMd262iijiw3r66biyRCkfVIHyk=;
 b=N1FJdUhZFy7LE4dXP6vP3vVs8nB1JMbP4+y1hbuYc4/wjSoTG0B0dvXP/ebq+Iet6IGesRvmakmkVmEH7zuH2vq1YY+uG0RMoJ0OkaeLRuaAqZ6UewGs04F0fb6eHDgQlPjW74v9fKYbFvIDDp8dhtwVnv0nr1fDwu8eRX6YGoe3MORqBneaSnpfXoDOVyNrnauMlsim7qmQVGkecwFITLvcvpC58LrYDnTgUPzokJ3ZJTN/A7cREvJXxuLDUnPC4JHfnExy9v1JJ0+iwWGmR4Vni0axCOmqJEVQi2ube/1nY6JPEKfRUZjFrvS52H2WdC1kucZp1CeACNxJBjrspw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxpVqRrbQX2vXuNsDMd262iijiw3r66biyRCkfVIHyk=;
 b=sDlD4i3rpiPmFToP/FUJBg2MAGHMeY+AZo3pRjSNYysu6opZPMWqSD05snyj7bQbwh9XRKdqsDuqhrfnkMXE2zL4prAbBMXlJTbPKS3Ch6AMdSvf3R+TNV2RgXWZWAYiMgYguoELyKrhLDX498wipmbQYRAe4gcqbfAAVjeTmwc=
Received: from BN7PR02CA0030.namprd02.prod.outlook.com (2603:10b6:408:20::43)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.25; Thu, 27 Oct
 2022 05:27:11 +0000
Received: from BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::e7) by BN7PR02CA0030.outlook.office365.com
 (2603:10b6:408:20::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.29 via Frontend
 Transport; Thu, 27 Oct 2022 05:27:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT115.mail.protection.outlook.com (10.13.177.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Thu, 27 Oct 2022 05:27:11 +0000
Received: from aiemdee.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 27 Oct
 2022 00:26:57 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     Alexey Kardashevskiy <aik@amd.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux.dev>, Ashish Kalra <ashish.kalra@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH kernel] x86/swiotlb/amd: Half the size if allocation failed
Date:   Thu, 27 Oct 2022 16:26:07 +1100
Message-ID: <20221027052607.260234-1-aik@amd.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT115:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: a41ba58c-7a8d-409c-4d8c-08dab7dbe639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xi5uS5xgtzxV7Voi1Js4DS1E2fKZd6buCbl/GW8IyIxep5zzGLTdX+PMnabfofFG6fOdqFY9lp4Gdu/oHYFggMe0Cg16fDrUwdxCLdBVKyW8B12Xe7OTClBUHYkE1hs6sCgycVgxgRAoqP1tpPzIdR/rRo+tKIWgpEX4FI3o/DA8xh7hJGu4rhjUjP/LzSwmSUHNRta6i0MdYNuQhBR4wA/dR9tb54KPzu/M3TFPNkP2KXsZ4UqxkSfYM1sO8IF3oE0yOznRo4YUCtQf8Y59Zbfd4XE+K96Ulm5BKvCqEyqfACkFLj69x5knfJAgCfRTqDyz6Y+iPmnjfyhfL929+/C3flb0dsCwlMCMFWF/nYZus1HIlUWUQsIrQ4CGqivC8Edj0ti77tf3TM2FJoLhuH3rmI3thmS1ee1CMGH9PlNOeQ9GC233me9R+IBZDqd2J/ExiN1cy3HxL8/iTLv5VwmjxuIqTbE9QSsvG2u7nSSdCqHL4SlPOdeZ9ghSxHEXKOHPvSmwoloE+JA/ufezINKnis8s5DCUHOmiX1+gCimQLBeWu62KqHhYLeG7IXzXe7wmTbJs93SxkSdLLO8dDivyba5QN/qi2hLW2dZ0fcsw+VAt7OZjLDThswMeDIQkBJH7A6DP5n8yG3pKpY+SwdkbGanfq+PmZXzbT+Vx6f4xfnpfscDaJlF6eQ04V/ehmxB3eXSgyvUlY08vku4glvp9fJZFDFK/D4do6fthmg/yTK3RsWdW0dD2hmKd4lwY77grnDX3q2dgPoFerCLGv6zBR50WiPZR9NTZh9UssscMHjRcDLJxfB6n6qmd3AWL
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(2906002)(82740400003)(54906003)(47076005)(81166007)(5660300002)(41300700001)(8936002)(8676002)(70206006)(316002)(70586007)(4326008)(6916009)(336012)(40460700003)(83380400001)(426003)(1076003)(186003)(2616005)(36756003)(478600001)(82310400005)(40480700001)(36860700001)(26005)(356005)(6666004)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 05:27:11.4113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a41ba58c-7a8d-409c-4d8c-08dab7dbe639
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment the AMD encrypted platform reserves 6% of RAM for SWIOTLB
or 1GB, whichever is less. However it is possible that there is no block
big enough in the low memory which make SWIOTLB allocation fail and
the kernel continues without DMA. In such case a VM hangs on DMA.

This divides the size in half and tries again reusing the existing
remapping logic.

This updates default_nslabs on successful allocation which looks like
an oversight as not doing so should have broken callers of
swiotlb_size_or_default().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
--

I hit the problem with
QEMU's "-m 16819M" where SWIOTLB was adjusted to
0x7e200 == 1,058,013,184 (slightly less than 1GB) while
0x7e180 still worked.

With guest errors enabled, there are many unassigned accesses from
virtio.

---
 kernel/dma/swiotlb.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 339a990554e7..d28c294320fd 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -338,21 +338,27 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	else
 		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
 	if (!tlb) {
-		pr_warn("%s: failed to allocate tlb structure\n", __func__);
-		return;
-	}
-
-	if (remap && remap(tlb, nslabs) < 0) {
+		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
+			__func__, bytes);
+	} else if (remap && remap(tlb, nslabs) < 0) {
 		memblock_free(tlb, PAGE_ALIGN(bytes));
+		tlb = NULL;
+		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
+	}
 
+	if (!tlb) {
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
 		if (nslabs >= IO_TLB_MIN_SLABS)
 			goto retry;
-
-		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return;
 	}
 
+	if (default_nslabs != nslabs) {
+		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
+			default_nslabs, nslabs);
+		default_nslabs = nslabs;
+	}
+
 	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
 	mem->slots = memblock_alloc(alloc_size, PAGE_SIZE);
 	if (!mem->slots) {
-- 
2.37.3

