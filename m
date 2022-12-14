Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C32064D0F8
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiLNUSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiLNUR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:17:58 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2425131DC9;
        Wed, 14 Dec 2022 12:07:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbQLn+VJnHIjl9WVgBRxskwSZndsejssP2IWZp5LuMB5kB8ncDyoq+F+DbbQTaeoZ5oCyvNrtYHzI7KszPR16LLP6YE2eUvZfOBKCJyJuDoDi9H4z485BvB9GAjyQNVTXAYC1SN+qkBWkPLbRWTppZIDRJY74Jmfz03kc5ZxKuHkG1smu5bCwVxicnvbMojxsrgFrrSAJQcWb21Oq416DPVH0AF7tDHL1y4hRTr7e6WaCJOnXh27Fr1K2nFdgCGKWXY5zjcBoDr3/ZmJ2skMdFaOkPlbNlDDgoMjO+CIJ5bTQALp/ttFcBSojUiMMRhoCv+54EAhBPyYE5xrbU1Cqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioS3JfXIHvi53uaP/Fbu2qHHPrFAosADMMkceWONob0=;
 b=TjH9FYCbaNzDbRX94foNLuCxy72qpM+HbBMjNrnsUawqek4MT8mBUChhM/8YdvT8xnhfCkfiB+unHoEnFgnI1nFK7cAsfVaSxTiiTEWg55CFActPjAKx5vRznIdxnHSeoLncx3yHyS4/CBu6VeEe1OMvOGvWZ3o4ooW03T/inAiaRbJZ2hlyo0yhUx3PyKM1sYWuIzOnZpoMUIAit/SzNa2wTGX4Y02YImVsOj9GsdbA2oMmux95b/oIgRr5SZRZk9sh1WYzHAS4Iik1l2EnSzTGsAoB0m1/NyErNThsIH38NLo1qP+JThgfX5yeCJPaDnWjarPr832QizGlw9FX9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioS3JfXIHvi53uaP/Fbu2qHHPrFAosADMMkceWONob0=;
 b=kOxijL+ysI31uYr3jlgxDE+wAeZ5wxatP97v7RjdEBWcqWb7o0YD3QjYmlIk0WxXLvvAy+z2kYL+lYfE6NeLpbS7nZJBZmwdkoCECmGvolzL9mHfGu8OiunZ5UTrPWMR70VDxxXaUau14u8aH2JdRSBXj7wytBPFX06xD0wmmSE=
Received: from MW4PR04CA0083.namprd04.prod.outlook.com (2603:10b6:303:6b::28)
 by SA0PR12MB4590.namprd12.prod.outlook.com (2603:10b6:806:93::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:07:03 +0000
Received: from CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::2) by MW4PR04CA0083.outlook.office365.com
 (2603:10b6:303:6b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT085.mail.protection.outlook.com (10.13.174.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 20:07:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:07:02 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: [PATCH RFC v7 61/64] KVM: SVM: Make VMSAVE target area memory allocation SNP safe
Date:   Wed, 14 Dec 2022 13:40:53 -0600
Message-ID: <20221214194056.161492-62-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT085:EE_|SA0PR12MB4590:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cebb3d1-104b-47e1-3ac2-08dade0ec461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lP7wMEXnyaSdlL8IKDf50YW5/Nma7+flujihY8HEpHwwOQDVgzIeS5OMSo5R04LDbH26iYBZUiY94TxvRWWCIZwv3Sh5bzqouPkpPnF5VGE6MnAkgAWUSVOoWVHP7d5qiCxT21hS4CyZ8tpGITb/tv54na/eTsaEfII+D/kx+sX+u8MAkda4lauQZzdnLvySsvaSl6YwCeB+NKcfCqmoz70RZcgGiOM2zmHnH6J1acFTnDsSuMDPGMKLYO0qWoiKudCbNr7u8/CuEcdMGV3LQ639wGmmbeK/lk8Oy7akxGh9DS5gZZTBkcsiNrGaVXB+k4+K8TM6TGTeNs3etFtNhrhxP/otSiv/nUG+CUZrEd+ei+Tkijk8o6E5xEh73FHVISMdOgcmKWDUz2p1nbeZceS7vzPa1XiKcT72jB8BtGMsnuKHBiX5r0XsXwC1cUGGL6nYuGtHwC1oZg0sJGUPDBe2suV/JHvhGBjBh2BAT1fzFDYomZ0pGwJkasHTqz6yNCNDleO3lD2n2Q32n931R11Q38SQjgbQk8v0EE4O1Mtfp/Giofb2E2W6FP+LQUgnJ4L7DHC/HHwT0zDexuuZZqNuLLBqe8c/HE2g0C2qoCmf+UHQWmh+u9L0fHva+nHmfkTGSr/z4ackX9fxeVHeuAosqBHsueqIr3x78MveizGeSyNE31YPP8WQp1UxyO2nMiQ/GPLHCDPlay5sDu/q+cyTXMr+9WvxCXj7/WzgxzM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(6666004)(316002)(6916009)(54906003)(478600001)(336012)(2906002)(47076005)(70586007)(186003)(7406005)(70206006)(4326008)(1076003)(8676002)(41300700001)(2616005)(16526019)(426003)(83380400001)(5660300002)(7416002)(44832011)(8936002)(40480700001)(82310400005)(36860700001)(26005)(86362001)(82740400003)(36756003)(40460700003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:07:03.0398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cebb3d1-104b-47e1-3ac2-08dade0ec461
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4590
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Implement a workaround for an SNP erratum where the CPU will incorrectly
signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
RMP entry of the VMSAVE target page.

When SEV-SNP is globally enabled, the CPU marks the VMSAVE target page
as "InUse" while the VMSAVE instruction is executing. If another
CPU writes to a different page in the same 2MB region while the VMSAVE
is executing, the CPU will throw an RMP violation #PF.

Use the snp safe generic allocator for allocating the VMSA target
page which will ensure that the page returned is not a hugepage, as it
is already being used for the allocating the VMCB, VMSA and AVIC backing
page.

Co-developed-by: Marc Orr <marcorr@google.com>
Signed-off-by: Marc Orr <marcorr@google.com>
Reported-by: Alper Gun <alpergun@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 543261c87eb3..1d4a723d5def 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -653,7 +653,7 @@ static int svm_cpu_init(int cpu)
 	int ret = -ENOMEM;
 
 	memset(sd, 0, sizeof(struct svm_cpu_data));
-	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	sd->save_area = snp_safe_alloc_page(NULL);
 	if (!sd->save_area)
 		return ret;
 
-- 
2.25.1

