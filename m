Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C729764D060
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiLNTxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiLNTxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:53:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98382CE17;
        Wed, 14 Dec 2022 11:51:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTwXfETNoFwoz1+ZXziugdKfKKpQNYrcj9jUGIaNnQf5jPCC0gk78tp0X4SZAOSj8pD/KUtaJpmILBZulmZOKvlODqck4h8MDf0iGrPpoXcviZkGOMUJjn8KejkXSE1dpYPSMZCp/1pOUbd93rO5KDb2Ojv3FDdSSuZi4nO9nbFlg5Io5CNt3q038jjYq54/CPhJJvGUaG+POG1ZsmzADhVcezh3NPThfk8eP6tJ39OkFSF8Fav7mDDwkH7d+lpcjEor5SL4STGTSddUvjgwlNmQrPMU+jAtkdk/IeUAeAwO3DvLKQ8jKHvpN3D+YOGM9C1yv7+KPdgrPbZaMYSMbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoL7U9aX/ZvjtfMqXC9xO2mIT6ugo3HADJUjSNzOi8M=;
 b=GvSaNkIPHydlqEE6TPkPQF5+B1JP+WuNrkmwZVkTkLWh0UQTa4MkCsK0MSWXku3pQisECHhig16pOeB3zmjEL5gpdKTYUNcNpn/H2pDQz5s/aHRjQZFJzGcYsPBLyAIUFAGKhJHKRz+BaSV6DTUP2nQ0XBupMKbs6xM6N4FAcu1vmVby02DiVxFrA9sjIOXjNVJqTn3M6AqHsNQ5hRcqCUGr8yGi6kq5Lcib1MzzJyrfLB737yPUiDXzcMuWQuqD4NgA6IXx9JLr86CoFAYRIFeAxUL9zL1nG1+7N1l3TJVnqc3lruC64EO70z0w25x8xkmf+TwK6UvNreUBMiKe1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoL7U9aX/ZvjtfMqXC9xO2mIT6ugo3HADJUjSNzOi8M=;
 b=zYTEtxrR3cZvihAXnCr8tT9Ec+nQUB8WQWQW1GTwLqTZrKiWTcwma6jTKgrgpF7QzMgJ3zP1W/1sRsTasEMEmwqqKN0MKsr4WaSqWCeJ7cu9Fi59tcu9C1HKcZBwe9Mt15rHDxxIJinUnc6xwY6dmr9jOSNvCE/UdKAN17SvvmY=
Received: from CY5P221CA0084.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:9::14) by
 DS7PR12MB5840.namprd12.prod.outlook.com (2603:10b6:8:7b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11; Wed, 14 Dec 2022 19:51:17 +0000
Received: from CY4PEPF0000C97B.namprd02.prod.outlook.com
 (2603:10b6:930:9:cafe::32) by CY5P221CA0084.outlook.office365.com
 (2603:10b6:930:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C97B.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.9 via Frontend Transport; Wed, 14 Dec 2022 19:51:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:51:16 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for large page
Date:   Wed, 14 Dec 2022 13:39:53 -0600
Message-ID: <20221214194056.161492-2-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97B:EE_|DS7PR12MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a6e300-a89e-4609-a3c4-08dade0c90a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wwr/Osxya313jUmgCuc3sqjBWHW8EXeDnY7cdpayxzFLy1+VeZA/pCb5+Fsw+MsxrYsuhPLyeIibDIDJ374pgFCsAVvPS8twEp57yWCt8NG2eSuawP/nyYWIkbUFs0KZ4rMXhJpivO7pI02UH42m6jriJK99qxIxO3VSR/FFpEN0UuJVufXiqMWrFYnXeLKAVLM3IdOlZdlnJuMCl23EWeK6+sqAakZ0oi0323njRf0Rj0cfzhqv9ipBteuXHiSyB4Yt8Jthuq3Ht3DqTGg92a2CNPrxTzd7p7uCph1QRmvNsYXJcjpE0lnJIdKNr3UawzCP1lwPOL0VtM6v8vXk+pKUFe6v44Br4yEROFPgfCs3TBP7xAVGGMRQo0DhyA4/F+4sIZqyOxk0qvpiVPPaU36B8Fk8cQLVJARFCodY4fwTGYCU34wOjy4tX9LQ9DbTmFTjyQ0U+x5Umkm4X8H/0B6fwJTWMmPnMsHHLzjT7A7Ai8OdTDggcCNmn1rN+7UJvqlBjRZQTvNm4Tf918tX4JYBVBtvcKLXgkC0tNB15WNhVuF6nM7djAcanRDm+f/ZEl2oGQVSr4DjBEV07fHHgtwdn2OsdgTodg3BPjeeoG1jboNWWzRqlFKzYGhw9k/joynyspwWovUVIWR2ry37YV1HsbBM+nZ1uoMxPaVwQ4dmi4LkxZ0QXB9yLvbyYQeoj4OEXcAA5RIcLuzgnR3WhaIowRdhiWR1EWfDugamr1Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(36840700001)(46966006)(40470700004)(83380400001)(336012)(2616005)(86362001)(47076005)(81166007)(82740400003)(8936002)(36860700001)(7416002)(356005)(426003)(41300700001)(44832011)(5660300002)(1076003)(4744005)(7406005)(40460700003)(40480700001)(26005)(82310400005)(16526019)(478600001)(6666004)(4326008)(70586007)(70206006)(8676002)(186003)(6916009)(316002)(54906003)(2906002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:51:17.2466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a6e300-a89e-4609-a3c4-08dade0c90a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

Aligned end boundary causes a kvm crash, handle the case.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b1953ebc012e..b3ffc61c668c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7159,6 +7159,9 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
 		for (gfn = first + pages; gfn < last; gfn += pages)
 			linfo_set_mixed(gfn, slot, level, false);
 
+		if (gfn == last)
+			goto out;
+
 		gfn = last;
 		gfn_end = min(last + pages, slot->base_gfn + slot->npages);
 		mixed = mem_attrs_mixed(kvm, slot, level, attrs, gfn, gfn_end);
-- 
2.25.1

