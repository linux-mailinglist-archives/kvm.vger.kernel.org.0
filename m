Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D9F6D8580
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjDESB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjDESBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:01:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7AD6EA7;
        Wed,  5 Apr 2023 11:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk16Qisdbe0+HbJZYZO05tRGYuqSxSSQgAbCYG8g2V4dm1cQkMry7SJ18tDQOJaCImLF+pJv63LIaFDPLoNT0ownDmto3e/MKi737P2PrKEx40C+FDLf27VjqJj34aUvX2In01Qlg82jQ1rykt0vSu08s/B53lMu5kWFZUVi5MbuFae+4qdTICjIZGW7WFo3twhRXEKaF2D9Tl6SrJukvzkrhFOxtvJIn44K6j68AmFJIY7HrWkS1b3Y/qbSf5NlvWRj5N8PMnRRUk3Wtquf1I1NXDOIx9v2KdsBF6DXMLhLabT8FSqnvgfuXlLquGWkOv8+toSYjX+9q0ahJJYk+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lbn51B6boribzXbBrYXY0Ya6Hm0KLcNEK2K3S+ou5C8=;
 b=MKlLjpD1L6tzVVgw49KWnibuzszKo6yzrPmPTuD+yI7JO/kusH141CPSsleVyjHNue5MDhbW/hhZJ6qRt5W/fmW45P4FuG0IuVM+apc2jWhWKNsgR6B0ET5zlRDRIwHxOq6N0umSZOCVrhtAkNvM28eGHyf1JtSMbQoWn1Ib4B8X432QdUj/zYlrLg7F+4VziDR3s7RdC3/XzTovyHuYDnRSetoMwcvl3kfq1Pn/74IXy40eg3coI4Wd5OkYGS/7EqcbgluybjBBTYrIjCbDcIwvEiU8/HiIBMk6LNGXdvvbqtjW3toP/pXw4+1h0+nrr9myIti7W7Zefvv5Ji4Org==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lbn51B6boribzXbBrYXY0Ya6Hm0KLcNEK2K3S+ou5C8=;
 b=PZcCFz0qH8qNoVLQKhvqdFll5wU0Zc6tG/mKK6JvTISQIxEPlHJGF7RUsxyRSJ6KMxJvWZfASuArYA9Xf+Q1dgycobpZNV4H1LzkkkxQn6qE7K5qLxvBdRzHXUP/dVU3NccSeKhDQi/KPcCtrYgxIwp0cUERNzuQ75OmVXRhNROZ/djX2/3KWQTJT1vGD6cMYnpipuDz8D5DXA4zlQtpvli5n4e6vMVfsgR2QeXoC6M4po/3sG1vzxSbB0kvssNs1ziW0LZAKJlS59Jv/5d3VpvTmpTOdGcTVrMDI3cUnwrjsl9tTfPqfF6f1gGzewAgnyec0ButMXzqcuhQlH5oJQ==
Received: from MW4PR04CA0250.namprd04.prod.outlook.com (2603:10b6:303:88::15)
 by MN0PR12MB6271.namprd12.prod.outlook.com (2603:10b6:208:3c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 18:01:49 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::88) by MW4PR04CA0250.outlook.office365.com
 (2603:10b6:303:88::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30 via Frontend
 Transport; Wed, 5 Apr 2023 18:01:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.30 via Frontend Transport; Wed, 5 Apr 2023 18:01:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:36 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:35 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:35 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 4/6] mm: Add poison error check in fixup_user_fault() for mapped PFN
Date:   Wed, 5 Apr 2023 11:01:32 -0700
Message-ID: <20230405180134.16932-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|MN0PR12MB6271:EE_
X-MS-Office365-Filtering-Correlation-Id: d58cd556-1e24-452b-abca-08db35ffd3c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPrqo7iyZ1LzNwd2UFOiHjb3KLRpX/sJApbPGFn+XwlHp+Y9BEaCIuP9RUIldtiCozRqkdlmVSRETW/yA/eHUVbyu34ZvGx/9M9ynBGhLPUrKE8D1xhramLu3R14fw7CBWXzZYwKiwOD4fFGmVxnQrAtmvhBOZmAyiXqdRZZLlFilsSEwi5qztlj6z7kWCobJPVe4KGU7uXEwxOuXXhtZumpWzUo+U4pVV/D59VfdxChneSMlN/JRGOWXNd4rFrDohvPjEr1ujQgeenMln4S01W9CjZ79wCi2T6bO7Sf/8+MeEzQLr0yPNK8otUKAz8of0+QkeS+5Tlqn+aR4eX29QvM4o3qz3JsAIOvSS38Li/CQz0kI0OjhygiWIlBF9mqg9vYSALxFycMqvDdeIQTDOQk9f81DJ8zna4PcPbd4ZPxW6+3iCI2YkedWnBZpZOweU/EZQBZGiHYSVe1mV2gjns7e0L4pCImHw/A/WQy+eSy6OQgMXX4B6fDJjSI3RPL3qUR7irH4vVOhZkCafubX9DpHToB3w2l1rr+gwA+7r2zK5gcgiClbN4I4u9OxsAyMQBj+jeCMIMAkeMvAuqIDHLUceKp/5O+2UziNnzbv3njsWzQ7H4O+49S2UftdS+H50HMZG5PRDbHXIaRrLOh93AmY7lu0GFIoqMOJ1jYLDNFx+UP+VU8JoZSjbV7r32IC9Hiiz/RzhegDkAus1f9M4mRpnr1x6Cf+jG02sFcCmf72Kkw2ZQ8TXtaHNAlwJ4L
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(2876002)(2906002)(82310400005)(36756003)(86362001)(36860700001)(40480700001)(2616005)(336012)(47076005)(186003)(426003)(83380400001)(6666004)(1076003)(26005)(8676002)(70586007)(478600001)(70206006)(40460700003)(5660300002)(4326008)(82740400003)(356005)(41300700001)(110136005)(316002)(8936002)(7636003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:01:48.8221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d58cd556-1e24-452b-abca-08db35ffd3c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6271
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The fixup_user_fault() currently does not expect a VM_FAULT_HWPOISON
and hence does not check for it while calling vm_fault_to_errno(). Since
we now have a new code path which can trigger such case, change
fixup_user_fault to look for VM_FAULT_HWPOISON.

Also make hva_to_pfn_remapped check for -EHWPOISON and communicate the
poison fault up to the user_mem_abort().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 mm/gup.c            | 2 +-
 virt/kvm/kvm_main.c | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index eab18ba045db..507a96e91bad 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1290,7 +1290,7 @@ int fixup_user_fault(struct mm_struct *mm,
 	}
 
 	if (ret & VM_FAULT_ERROR) {
-		int err = vm_fault_to_errno(ret, 0);
+		int err = vm_fault_to_errno(ret, FOLL_HWPOISON);
 
 		if (err)
 			return err;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..09b6973e679d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2688,6 +2688,12 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 		r = hva_to_pfn_remapped(vma, addr, write_fault, writable, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
+
+		if (r == -EHWPOISON) {
+			pfn = KVM_PFN_ERR_HWPOISON;
+			goto exit;
+		}
+
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-- 
2.17.1

