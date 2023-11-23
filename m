Return-Path: <kvm+bounces-2340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 944557F5565
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 01:36:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4793B281713
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 00:36:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2039E17EF;
	Thu, 23 Nov 2023 00:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CpNtRGSp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1C7D4A;
	Wed, 22 Nov 2023 16:36:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T795ru13brCgtgGycGGwVlrOk9/jtMK6jgNuRbjsiI7wEfMJsAwOK9KuXmRD254ylZsvUwfNt/KtSozC+Bb7u1xKQ8DRAz0qRUkV/9TZn5HJZv/kpbc7goyGdVtUpyazg9bvBRy1SajmzDjiu3yt8V0VuMajd+jqtCmTdVNbZHkF981py3TdKaWgqKwmFdU7JPL0eL307/OkOyQcQTt1wgKEUe+1iIO2hVvCMbjOiaStOxQGCj/8jvLycFdUcE4AYUD5Mujm6LhupyAAlZ+8g3LFUWunTX42uiDdj6k/MscN0C8/7yYYZa2lMUVeyTtSQgaGACRgOpkp/BPRWRP/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/bZyWHQoKEw5iy9xhVjRwl4/N9WhdB8iG6w+9HFKPQ=;
 b=j02nSSEIVVSWLIsSG1oaoYWkcBiV/SynQm58HWSAhTVmFkvQlSO/5txqAhVifpKyptkkB6CJaR/X/ydxaR5tB37cPrAj2LweI1aRcTOxJVQbGIu4AxRVga1WeTMaG9/bWgPCirlCTgbSN2n94x9eA9Owt7yffcOCmd+EyxiryxpZ2siUYShmBC9LuQv5qQVlWIpI0z0vE5hgV/wg+HyZr6L22mzwso5RESYoED41mXRNoDGGEjLvuldElWXUPe9rSBr0wKESLJTRm7BPFSfiVHbMzZ9wMEAvWqetslnL+kRSGYuRUZ+fnWMg7GvFXSd28NQQkvVMHZwSSf6izqeBsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/bZyWHQoKEw5iy9xhVjRwl4/N9WhdB8iG6w+9HFKPQ=;
 b=CpNtRGSpPfd6YgUdsJFWiQv50qtgpjXd1ZLAzfVLG1i+6yOtV4y4pG9Bd/yC+1C5ZojnhKNRTrSHF60HENgY0vefFnr+OI7Gqa44yVFxo1q3/J4FjRCMIJ12Dp1am4bUa5TaRMyd5TB5gT8rCJ4Vk9DyJD06P2zksS8jKAdUqtPCebwkO/5QKRCPBmdPS+QH9chEA+3L88S/n5bdrNBL5W1IU3udSMzcohkQ7JKzf2CDZyZ+ePoECyVxLaEOGCJu1kt8AIvjYOlji/e9whoBjS6JjFcZLwpZHG4a9T4xOD48XmHNgTaUgWonRhCsOFXhu17buCSmXyGxZ6F0cyQPCA==
Received: from PH7PR10CA0012.namprd10.prod.outlook.com (2603:10b6:510:23d::26)
 by IA1PR12MB8518.namprd12.prod.outlook.com (2603:10b6:208:447::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.20; Thu, 23 Nov
 2023 00:35:58 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:510:23d:cafe::81) by PH7PR10CA0012.outlook.office365.com
 (2603:10b6:510:23d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19 via Frontend
 Transport; Thu, 23 Nov 2023 00:35:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.12 via Frontend Transport; Thu, 23 Nov 2023 00:35:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:44 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 22 Nov
 2023 16:35:43 -0800
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 22 Nov 2023 16:35:35 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<naoya.horiguchi@nec.com>, <akpm@linux-foundation.org>,
	<tony.luck@intel.com>, <bp@alien8.de>, <linmiaohe@huawei.com>,
	<rafael@kernel.org>, <lenb@kernel.org>, <james.morse@arm.com>,
	<shiju.jose@huawei.com>, <bhelgaas@google.com>, <pabeni@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <anuaggarwal@nvidia.com>, <jhubbard@nvidia.com>,
	<danw@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>
Subject: [PATCH v2 2/4] mm: Add poison error check in fixup_user_fault() for mapped pfn
Date: Thu, 23 Nov 2023 06:05:10 +0530
Message-ID: <20231123003513.24292-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231123003513.24292-1-ankita@nvidia.com>
References: <20231123003513.24292-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|IA1PR12MB8518:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f53125-461b-4c1f-db98-08dbebbc2911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EY9H1jv+Y3CS+Oo0Z12esoY6jKBtgObbS6VLgRO+a1sYZa6HurFqt4BTb4ZwjRTzHyHt962CZ7KF8vOORuclbCC96P0F4697PrIjSm69QDfe5Gy29V8zkY2YManNfCUcVBhmL4zYBiu3AgQQKa9E9Iw2hiKhLm6dpgZQENnrC/XeHk5gwIo8ctHzIXqh9Mz/LVNmc1sMpTpAONvOL85IccvTDfat/JqUE092g09nMT2j6K6h8GKIjXgoQWZ2RAtiUhO6XV+bpasbuQr69UHxUcN+socMn0rvCs3HOSRIEcRWcKdSIVWMIE4bnB3YV8wI4xdq6RkYv2dybGUTBJma7hJpVf15er3aRqBp0h611FtAhJd1//9mKaTpG3QzESyClQq8ogrFwoEpPB6oDnvSq1QxJxjseC7f5SW9/N9h0r8NnNgxpxLXvhoqpVxaYqVLoHRF8oGIXsLosLAvz+n2H03WteVYNePRMakxZ9KluRnaq8YxsGy1NiHZGACNpOAAZXmQcYVqNdh0EHiQnqzV7WYDcQngGAs4+8LgPzSKNV5iZr/+JkFkM92AQHs1Ap6MWOeLlLb7Q34ZmtOlTEptkzH4wmWP08+Ry0/dZX9JWQZ5zrSNBjwPEW6o8sxZtz11GzacngEs32CqT5lC3o2JTwL955OkFKdIUWKik8DGZgn8UXhWY0woy3IBZSGGNAtNZq0O30vwCwemAHS9uKXy1SlgkcI9PJ1YndYjSVoxNwahrt+9aODgQ4n+CR7m1dzSXLxxrosQZady6+E6D73lOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799012)(46966006)(36840700001)(40470700004)(40460700003)(110136005)(316002)(54906003)(70586007)(70206006)(7696005)(36756003)(426003)(6666004)(336012)(26005)(1076003)(2616005)(478600001)(921008)(82740400003)(7636003)(356005)(83380400001)(36860700001)(86362001)(47076005)(2876002)(2906002)(7416002)(5660300002)(40480700001)(8676002)(8936002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2023 00:35:57.7222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f53125-461b-4c1f-db98-08dbebbc2911
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8518

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
index 231711efa390..b78af20a0f52 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1414,7 +1414,7 @@ int fixup_user_fault(struct mm_struct *mm,
 	}
 
 	if (ret & VM_FAULT_ERROR) {
-		int err = vm_fault_to_errno(ret, 0);
+		int err = vm_fault_to_errno(ret, FOLL_HWPOISON);
 
 		if (err)
 			return err;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..2ff067f21a7c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2731,6 +2731,12 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
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


