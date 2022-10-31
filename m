Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE25861317C
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 09:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJaINu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 04:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJaINs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 04:13:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584009582;
        Mon, 31 Oct 2022 01:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gh6K/p1QsyFUw5SVZkR1FyxU+naakpo7ZsIYSYfKROaW2zzHLZkF5A4ZHUyCPpppKRmu7DwcVPMpD7y48xbMYHUT3A/yhRB+VIh4GrWYJwhhS5PGmakiXTr5MLr2VJCCkTHNgLZ81rViN0wnVF6mBOd2xYKLBMUQKKqsiWL6Wzcp0ukIYbhme/rG4Zc/22uFcrU1068+U6xzsjrH7q0OOL5Ev1c6DP1tG471hO70byOe0HbWQSfkmeFwzqFkUaItKqQbxktX2uQVslXaBQjwccsllKxa3q+HouWoQg6N2TlccslWDcI5HyBJAyCZkKjH60QiQk4uUzlKRr6dk42Aeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enKG2I8PkHM6Hfy28OHOeX1xWL/JPgJLyBXY7/avDAU=;
 b=J1QySLCFCqkp9i8jYs700QK/Jhudy64Qp3CkOqKkJS3INarPl8PCijIR40MenZLCiWCaO798bvDOylYdPzoSYWjo2TSymGWcak+zbSh5X2chq/AyZF+FHivPRVJzwj/cC9zb8uy75RqkvapXCQUhN94ltk1jFwoUIhdI+U2poFn7sUXd6fjxATNDlskJ2U9y1/Dsy/7hbucV5Hhad/WDbe0aVpm34bT8+qRyT8zOf8K6/sRRpJLdWaQEdj859Fu2t3If2BBrzxQMfvNzH/u0eIhknpVXjFCc1wQzFhUgobjEbMOFo7BWPB9jkzplbnFA1D/P9NpIUybCokznQU+J8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enKG2I8PkHM6Hfy28OHOeX1xWL/JPgJLyBXY7/avDAU=;
 b=t1kK6seX9WuOxrS+YSyP2enraOYoMRQ8WVre+XwzL1DwWJralfwqBuuGikvpQIB1PMdRfP+dfW3m/4JgH2vch//m3OUmTBNxTohRtn2epAhqTUkfwUabYagRVFDZvZbt+aNCTYcGWFUcPssH4Dtc5KYvC6TUi+RSFphSTH27c1A=
Received: from DM6PR03CA0097.namprd03.prod.outlook.com (2603:10b6:5:333::30)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 08:13:45 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::c4) by DM6PR03CA0097.outlook.office365.com
 (2603:10b6:5:333::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19 via Frontend
 Transport; Mon, 31 Oct 2022 08:13:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5769.14 via Frontend Transport; Mon, 31 Oct 2022 08:13:45 +0000
Received: from aiemdee.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 31 Oct
 2022 03:13:39 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        "Pankaj Gupta" <pankaj.gupta@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel v2] swiotlb: Half the size if allocation failed
Date:   Mon, 31 Oct 2022 19:13:27 +1100
Message-ID: <20221031081327.47089-1-aik@amd.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|DM6PR12MB4943:EE_
X-MS-Office365-Filtering-Correlation-Id: 063e1eb9-79b6-4bfb-2d03-08dabb17d4f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BY1ezcwaC646LmbgyEifZKrn2UdSGN167avli6vvA7D47D9k5JMU0rXCQjqBxjJx4cj06zXwQ3RPDVOQ5z1r2KHLfpxTLw/pUJu1ytFSDZhQ9Xq+M1pDPMJThUFbr+12mbSnNg/20jpApiWdp9CarLcyUbP0vVua/nT6Vc9OM5OlNYY44BJEjCeQ1Gt2ulFB3Ma/O592aGQNEyvEJcvprE9/UJCvy7xbbEumzBt9BgnHlpjPGsi2GXhDxfjWda3Oy17VrItbg+B4MxrYMQDmHzniy9PE3NxoXd1I5O7zFAngLIVV28Gh2W8bHcakCpMNgJt+zgoi/ExUZ2vPGjEKfTD7j5EjNiaviIsqSGLe3K4AdD8maoGDUFe1pAkN4lFHr/68ZzQo+1zZQuZoRlhILd/xc7xzpjJhHpx0l6PqACdLtC134iVTF/MLR0GVq0KvcP4mnLJBt90C6OZulomg6FiaebVaA/mEgJRctknpzRpyouXLU8Yo+/LIurhLQvuYHsyAFllfLLMYSilG0qBMstVBgC/bncmtnvSv3smDGXe1P3AhzCRix2D1sxfQS35hhcTw0VxIsmMxxm3+V8Ia5CKrMM0hwcmiIH7CQbBKoQaochCjQY+dDYOBEktxBx42qvsi1y+OeQJk7Zmq2iTjPkXzrZJ6rX4TxP9ZtnU9Hl1DhuKBKPkBkWvvMiaa+t5JnIyXXiJ0fiKZ1B3KQR2ycKN6OpE20HvGfMuL88gPVUNF1W7hcQ36VKlIi6xr9L7l/sF7E6VvxzsZhmcXMs0dOExltj5fKSnP2AFnJLUJKBOo4x7vewb3c5jYq/F+ZOnn
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(70586007)(41300700001)(5660300002)(8676002)(70206006)(4326008)(36756003)(8936002)(40480700001)(478600001)(316002)(54906003)(6916009)(36860700001)(83380400001)(356005)(81166007)(82740400003)(6666004)(7696005)(26005)(426003)(47076005)(2616005)(40460700003)(336012)(186003)(16526019)(1076003)(82310400005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 08:13:45.6913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 063e1eb9-79b6-4bfb-2d03-08dabb17d4f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4943
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

This moves alloc+remap to a helper and calls it from a loop where
the size is halved on each iteration.

This updates default_nslabs on successful allocation which looks like
an oversight as not doing so should have broken callers of
swiotlb_size_or_default().

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
--
Changes:
v2:
* moved alloc+remap to a helper as suggested
* removed "x86" and "amd" from subj

--
I hit the problem with
QEMU's "-m 16819M" where SWIOTLB was adjusted to
0x7e200 == 1,058,013,184 (slightly less than 1GB) while
0x7e180 still worked.

With guest errors enabled, there are many unassigned accesses from
virtio.
---
 kernel/dma/swiotlb.c | 66 +++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 339a990554e7..53fc6e7d3aa5 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -300,6 +300,36 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 	return;
 }
 
+static void *swiotlb_memblock_alloc(unsigned long nslabs, unsigned int flags,
+				    int (*remap)(void *tlb, unsigned long nslabs))
+{
+	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
+	void *tlb;
+
+	/*
+	 * By default allocate the bounce buffer memory from low memory, but
+	 * allow to pick a location everywhere for hypervisors with guest
+	 * memory encryption.
+	 */
+	if (flags & SWIOTLB_ANY)
+		tlb = memblock_alloc(bytes, PAGE_SIZE);
+	else
+		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+
+	if (!tlb) {
+		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n", __func__, bytes);
+		return NULL;
+	}
+
+	if (remap && remap(tlb, nslabs) < 0) {
+		memblock_free(tlb, PAGE_ALIGN(bytes));
+		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
+		return NULL;
+	}
+
+	return tlb;
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -310,7 +340,6 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
 	unsigned long nslabs;
 	size_t alloc_size;
-	size_t bytes;
 	void *tlb;
 
 	if (!addressing_limit && !swiotlb_force_bounce)
@@ -325,32 +354,19 @@ void __init swiotlb_init_remap(bool addressing_limit, unsigned int flags,
 	if (!default_nareas)
 		swiotlb_adjust_nareas(num_possible_cpus());
 
-	nslabs = default_nslabs;
-	/*
-	 * By default allocate the bounce buffer memory from low memory, but
-	 * allow to pick a location everywhere for hypervisors with guest
-	 * memory encryption.
-	 */
-retry:
-	bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
-	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
-	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
-	if (!tlb) {
-		pr_warn("%s: failed to allocate tlb structure\n", __func__);
-		return;
-	}
-
-	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
-
+	for (nslabs = default_nslabs;; ) {
+		tlb = swiotlb_memblock_alloc(nslabs, flags, remap);
+		if (tlb)
+			break;
+		if (nslabs <= IO_TLB_MIN_SLABS)
+			return;
 		nslabs = ALIGN(nslabs >> 1, IO_TLB_SEGSIZE);
-		if (nslabs >= IO_TLB_MIN_SLABS)
-			goto retry;
+	}
 
-		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
-		return;
+	if (default_nslabs != nslabs) {
+		pr_info("SWIOTLB bounce buffer size adjusted %lu -> %lu slabs",
+			default_nslabs, nslabs);
+		default_nslabs = nslabs;
 	}
 
 	alloc_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), nslabs));
-- 
2.38.1

