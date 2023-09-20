Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2F7A860B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236325AbjITODF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjITODA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:03:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A92BE0;
        Wed, 20 Sep 2023 07:02:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZLxeAbGMoe0MueMDiUeG7cAr3ofxm+KiMY0ulFs3FwJ8IHlNQ2dR615VoVjbFKloJxn0AVsfhWqp+dz5WTroCVwOsanITYQxg65cgGXqkNXdgg/NHpLHJ5He1pIz30HI1c7Xnf+XaZgjXSf47uULXZMpRwiQPgsw7+8xTqP12mhlrN+6ZyhLzWXjtRZO+n/yOAI8rcNCCVjX8Mv8fIGM6ipsckLNrGtu9LluTFSbfDbmw++ihPFeBwDMRtQhd3JUJE9yE2bYWHAAjBKFEDYz1R100CanfUczcl3uQDmmRbddqOE4UOoGigEs9khcP563t2xW3h7fXEE/eipt4HXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIG/Gq5YZPbCV92/HN+i3wEWEJiFnj6txDrJHePjssI=;
 b=PRn42Kud+MLQPYTNFFQI1P+isrIYgAcPFnfZdcOeytFvu/cqkI+DA96w4YcQ+cCH3K6Pw53yTUhUiMqqxCr7ieFjuwk0l1xKS2BGu2B3ipVf+24lcepxLSWXUjkvHrekCVRka7lV+CNa34bLKyieeByLWZFHBHy/z759LwEm/Dh2YY1Y2DKTOh7xC0FrMIgI6LPZUlwrmk5HDWmKKz3yh+/nC04MB+7rBjhsuGJeN5xW76YzbnqCDzH6SDXIN9uFp+pZkZlPga2YXJtZFMZa45ptCMm8GPP7XIPpmiImhFNKdoACxqmqGZJAcWLKrNZbVn79z/dHbAH7ar1KdcSY2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIG/Gq5YZPbCV92/HN+i3wEWEJiFnj6txDrJHePjssI=;
 b=Y9GzWAjk0zyDHTmj9C4+Ek+E8jyGmU3ZtOtLpkL+FI7Jm/AT8wJBosRQpNqytJN4uDZeAJj0fGczqA08MJN+p0nwNNGKCYeXEp5t9DVvjIS9rOL/XDLz2E68bCDwGsx9V96g8KwXbpUDL2an7l9Vo78X4Mdewhe3CcAH03ZH/aEoY56fe0MjWcp9d/5AkJWMNpRbTdI8BbgInR99kj9PP69cM/kEoIQ/Ma1ulrojKJI0aNaFWVsat6u7X0gsPRqtf0L4rSOVmjphEY1TiKoq/pi3AUkhc61EriaxSa2Rf+7WJ8m60GdWyT5hp1xKnK41Ekas5MD+4/XLHruhsYLuRQ==
Received: from CH2PR14CA0013.namprd14.prod.outlook.com (2603:10b6:610:60::23)
 by BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Wed, 20 Sep
 2023 14:02:46 +0000
Received: from DS2PEPF00003443.namprd04.prod.outlook.com
 (2603:10b6:610:60:cafe::e8) by CH2PR14CA0013.outlook.office365.com
 (2603:10b6:610:60::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.29 via Frontend
 Transport; Wed, 20 Sep 2023 14:02:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003443.mail.protection.outlook.com (10.167.17.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.20 via Frontend Transport; Wed, 20 Sep 2023 14:02:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:30 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:30 -0700
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 20 Sep 2023 07:02:25 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v1 2/4] mm: Add poison error check in fixup_user_fault() for mapped pfn
Date:   Wed, 20 Sep 2023 19:32:08 +0530
Message-ID: <20230920140210.12663-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230920140210.12663-1-ankita@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003443:EE_|BY5PR12MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb806d4-28ed-438c-0c44-08dbb9e24445
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/SSvjLpNYBbgXSacNhW9nrr0LphHgHDkpLTK4rTXsP3MT9kYoUOF6Wie8AIIDQ5m/36KOfqfOi9Yk1iF0BwezREN/+oQRBvZSo205Wl4sgLmffcOtGrln1kSzyc/mA+Iy/sPxWYXrZiO0lZxufXNZp5NRSWVco7CgmzEt/vWxe2ApXtOhEFMT/T5W+ubtNT98dp9EMvQC/ME9D5gTkqShzlq5+/bdUfnsWYgd2XdbHqKjSx0Dhp+sHRIfehuso3ePJ42c4ElEpNnpV7ao9Q5Upx7s8RxQul1TA8/an5AtzXcXYfzvwj/SVgNGs5w9Nl0eZkpjalk1064th+nRnv+neERZwmnqBs4UD2dIAboFun++qt8//YV36Ghg9/IHcffIJgHRplcDGyEUBLeSbXtURyFgBdFId7o67/rNUQX6E1y2E174Y/StcnpPCPJMn9mTgcknAFkPJdHXRRLE1sVD0sl32WVc7p3bIlACo33edc2CLjPcag9QZZQKGEDqq2qTKKDbyTKyyA8vyE4eAsqRvcitUFh9ywFgxJdGRsPTo6+e1+EtWM131ha6v9K6Nq1CZQf7dilWSxrAJHs/l9UGCE9tm+Ye6/CO0qT4K0Pr9vMrypfDmNleamcL2x9umv41r0cniN+hVA1cNWHkVyAC3uzxCcOgP57kFBSDgy2i4TAKvKkgEMrudLwf5ZBV+rVadwlbZtxmViQ6JzNFfafjGv/khT/o+vhFcXFqsWiDzmDnJqSQme5Ivddbi2jUp9cD0QXgTKmZ3spAujCCn4Xw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(136003)(39860400002)(376002)(82310400011)(1800799009)(186009)(451199024)(46966006)(36840700001)(40470700004)(478600001)(7696005)(6666004)(83380400001)(47076005)(26005)(1076003)(2616005)(426003)(336012)(2876002)(70586007)(54906003)(70206006)(316002)(8676002)(110136005)(7416002)(41300700001)(5660300002)(4326008)(8936002)(2906002)(40460700003)(36860700001)(40480700001)(86362001)(36756003)(356005)(82740400003)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 14:02:46.0617
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb806d4-28ed-438c-0c44-08dbb9e24445
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003443.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
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
index 2f8a2d89fde1..fe469326dbe6 100644
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

