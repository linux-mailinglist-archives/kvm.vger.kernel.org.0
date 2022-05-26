Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9A53557F
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 23:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiEZVao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 17:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345240AbiEZVak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 17:30:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F29BC1EC8;
        Thu, 26 May 2022 14:30:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn2Ba7933YZ80lgOCsyjxmMa700bwddaTRmIPVjTaGZ4qBA/LErGTL7BkKKWzzLNgbCLmjlE5V1ClPXowKCI0elG/6bhur9DFNtl+kuKiaakSONtxNsonWHT7p7Tx5z2AGjRNIz/twEe1m8G76i1o3b8zpOsfwOKzs+6gXcXYrtw6+1NY7EVlXqkU5PVhkwHm7iMWEu2F7EV0LQU1mbi7JIYXS5HYJscZxbMWXs85jRsSjG6CnI54ySQUsQka65erGWxJu4myAAXYBT566RREfwPbOI72adHC21ReNfyJ1kCsMEj0vLj7eIpXuU2Uc5C+Njg+LDEO2d5n6+Gjjf9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjUfjbrXrZm0cbzh+Pu2PDdKDV4S5/XQQm8YBj2AEcc=;
 b=Nmwu4MBD+uCutXZLafguYjYANl/qa+kzx8PAvHcIpcpu5lgWWNRojMg2sk5cSEVbWYJdRQPhCUXTIMorBUR9QUeGB0EegXkmNbYfkL3mmti1WWZnRstiaVYAzkfM2gAQMvWzG0AmozrZdnyg2jgo7dThGpQ19LvkEjNdfAjo5FzgbecU4NyFQnaXdRaMeLn4D/J7dVSgc3aOd4kw8QGtoMAf2EIYcLBx2hPA/0ilsabDWkH8xAy4IUo7YRwSFbeKJ0Gz+h4W94j4S49fHARY3l7I628y+yXdGGhbjUNxyBMTpK+INZ83JOihNqLiopBNwdgGLROD0fULSINSXSrXWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjUfjbrXrZm0cbzh+Pu2PDdKDV4S5/XQQm8YBj2AEcc=;
 b=32SPeSQSkKsKvpHmUHoeFQ8QxzKj18D8YQEs8+BMyY33TJBRzlMYBG6OQlAIfdgeJnsYJXoHJPfuSuuO+2hMe+2NZBqTxRh1zLjjthwKm+Musv0p0iGfkcmfnaJS773/CheqJQRrC27M2EHDvs89l/rtF7yE/fcsDQPJ+rn3DLg=
Received: from BN9PR03CA0847.namprd03.prod.outlook.com (2603:10b6:408:13d::12)
 by CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 21:30:36 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::b7) by BN9PR03CA0847.outlook.office365.com
 (2603:10b6:408:13d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Thu, 26 May 2022 21:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5293.13 via Frontend Transport; Thu, 26 May 2022 21:30:36 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 26 May
 2022 16:30:34 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <mario.limonciello@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: Only display message about bios support disabled once
Date:   Thu, 26 May 2022 16:30:38 -0500
Message-ID: <20220526213038.2027-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 162c310c-06bd-4d44-8f58-08da3f5ef8e3
X-MS-TrafficTypeDiagnostic: CH0PR12MB5266:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB52662B913C4F41DA8E25603DE2D99@CH0PR12MB5266.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2tnJlQErOmYPYIzAozRUz/RMxOIt7TNdSa2vB9A2FxjpaIzqW9VzvDUVNuUsuNHCoVaxyahfLpN6iB8QosPXTzIE4qTjaWyc0t4MkjzUpjYu7efM15jR40TTwZ91PzT8bYbZ3L52jxdMX81p4SINQMYDrpRt9vI9sOMD7JCwinyDp0xaFhIua8f7gTrVlFtSjYXYqHYqiEvrrow5ejzr6jy/ikyHg1tivK9G0Rev36hJfdWaMR3X1SpZhJRkHUd6E7/SSp2OCC0zUe69tq5fNb+/Cnej8GcS9fXcqcbt7pqVpiv9k/oqytJv+6Zn+mIbia7xix1dDwKnYB3v3s/NeZsLIJE+pCBKK2jQzowwctKPCMyeLgRh5F6hzI5H+V2fdJnRsMbumU6WfyRsL9SDEWYKvwfujZb8y8KtGI59p/OxvzzDEDdhDWe7D3PVmQvrmaQVdD/eOmEcRja9rY2tHiKhLwGjfdho/niTr3TCQU9xT8o9s2Ob8R1YTkOX7efCLUFBZr4hNpx3aHc6SFxuwcp0x352YOilmCgXlkwh6Std7jkfLBlMpC+S3poFg10KPJHi7wqB/UDeX03G6gLTdwKvMraYjsejj/rjMXQxhhEJUd/prf6uUJVZYtq2OVM1UYezCMZu7Pi1JvSUhID9PJiRvA1gU8rkQK6BAQsen4osYO4+lkL5E5orMcfRHiBYaFJyKWktGm0B5hZnPUKYcIAN1tTnASAkNHNplZrByEpRVOfX7T2NdIPY6s8tZGXJVuiVjoUfX8ZEAvPtVLlTOQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(5660300002)(8936002)(7416002)(316002)(921005)(82310400005)(86362001)(44832011)(4744005)(2906002)(356005)(81166007)(15650500001)(36756003)(7696005)(26005)(110136005)(47076005)(2616005)(508600001)(70586007)(70206006)(43170500006)(1076003)(83380400001)(16526019)(336012)(426003)(186003)(8676002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 21:30:36.0703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 162c310c-06bd-4d44-8f58-08da3f5ef8e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On an OEM laptop I see the following message 10 times in my dmesg:
"kvm: support for 'kvm_amd' disabled by bios"

This might be useful the first time, but there really isn't a point
to showing the error 9 more times.  The BIOS still has it disabled.
Change the message to only display one time.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4790f0d7d40b..80a8ea13f09a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8887,7 +8887,7 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 	if (ops->disabled_by_bios()) {
-		pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
+		pr_err_once("kvm: support for '%s' disabled by bios\n",
 				   ops->runtime_ops->name);
 		r = -EOPNOTSUPP;
 		goto out;
-- 
2.34.1

