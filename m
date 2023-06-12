Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD39172B714
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbjFLFB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbjFLFAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 01:00:53 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC561FFE;
        Sun, 11 Jun 2023 22:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGKg4VRglm7w5OTKYyS0K1SdAzDUmCd/9Ld80KGxPNgUly0//ZLWuKdOd+trJX1RTUipKcf3C458Ra6LmEmyLDg1l1V5M9pFnlUS+yZAjm/KDQIaauL62F5QqTCZTZKc2dsr5vRI+8+Czd5WNXh+vDXO83OTMBT3+oC3z3eRbUz4X8sxIBv1d2AL4u5Kamhq7holAS+by4b1xbqw7nG3S31Nb0BHBj3U4i1fV9MTkUs6Or5jwpSDl+bdiH+p3pVolHYohxT7Egt2sjtE8zEFy7y34vzgYthf8gFtGgvpX/6j2WtxXxr+tQ6ctBUiNr/9ye2zqu9axjKkmlWeD7zH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkCAa24YyiWlkukD/LaO5dOR1Z6gqOaYm5Qyl4UEKYk=;
 b=AXP82GuEEG5gjQda9i0jKKagsCn1/axvwc//tHsK3wAZjcoGZem7q5cyPCRVdGTvzTtMmuLuIKFk+YaPlU6pcgOWfsCxBzI22XqCH3CvLVrZN61JHmYpoJB5YvCawO0BuYY82aTc4UdR/tvIje4vgtldnR5A+20ujlpeWz7MEHIOc8wbIDe7NtgqTQCPVuVV974gDWzG64YOnA4CiuwZ+kAb9k/N+WyhQUpQzhl0plC5EEkuDVikEl3tzCuYqdQDKMPWsYaRW7tMZbdRqA6M2Xewif0V9v9vj3WDRUYBko3XhfEuUiVS5skhXw2dxD1o90xFGVowHWUsxOgOrlLhVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkCAa24YyiWlkukD/LaO5dOR1Z6gqOaYm5Qyl4UEKYk=;
 b=GcxrSPZvj/0Dcy3Cuh6cSWUJy/83nPOH9MXyUj1HRVqrke+c+O+fIKJNnVxpzSivyX6KcybJFSlvykIAi6hpdrPZ/jempsc93KzRQtQ/Q4YlKgeDaxmTJPhXNIFcZpe1/DbQDNvqQZfzbJGZQG1crQ2SfkBWt0m45TjMdRWYYZs=
Received: from MW3PR06CA0028.namprd06.prod.outlook.com (2603:10b6:303:2a::33)
 by PH8PR12MB6771.namprd12.prod.outlook.com (2603:10b6:510:1c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 05:00:02 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::17) by MW3PR06CA0028.outlook.office365.com
 (2603:10b6:303:2a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 05:00:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 05:00:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:59:55 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH RFC v9 08/51] x86/speculation: Do not enable Automatic IBRS if SEV SNP is enabled
Date:   Sun, 11 Jun 2023 23:25:16 -0500
Message-ID: <20230612042559.375660-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT012:EE_|PH8PR12MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b215c0-b78c-4111-db5e-08db6b01e11a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSzdUl9gWvMpdS01A5WUdoWi5VSKEY+M/DIT8NKlYs5wNCB5MG4aqVMw1tn8Rsjz7NPYLs0ui2xLLBMe5chKrEosF8SUF76emJ/C9vVkrrz/y7tqU+kFUcQknCxMW4a8tJW2JC4k0NoLsNxxX6Bl5CiPvUeYb6W8tCTSA0ceGokW7SsAlCBHUEHx4S88My+Ii4eY+BZ0aLibwwg+9erzpUew4V6dPDPg+R+05yqV37VmtGBjj9rMjzsdgjr1iLmA2BdooEpVm6j8veAMpc8ipqRtBvIcoXZAeDGUcBcEgYp4kkn3pxGlAsm3kw+Lwew4/3pz26mR6DYJt/WN1/rya0VC4vu16OEM2THI7MmFo4iwu7OUQ8EYhq4sTFr1Auw4K34ik/s9FWhvwbERJsg7GqgSlPv7+kXFE/InXyraRDRFhYwbTLqL7niyQspUG2U9tdzZ5b6VfzOl1GSiKgAAr/+IPFOLhaR2LL+wlrapZbsPS4sVWQJv39B+TBfSKCVkXdNuV86yK90tt2f2cyZzDim9sUOGQ9X5O+YRGRBgE9fmc+hu7jFM/gh6oV2Jg3VejaybhiqlGE2qpGEY60TkoOReb26gXlVxG0or60J/KKgb60vc/iTEJqJHb6+cn+ujeXJRQq87nb9TR9vm29PRPJkgPt0DVd1cZGSy2u6k1d94gXaC7BcxVbC1fFd+nH3/bRSX0ggyqv1QYNOKiIIK4S1odBYIsLkvohJRPy5CouNw6Jqd2HncgIFYIXHluEgAoRhjQweNiVVw6rMpPO4QWA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199021)(36840700001)(40470700004)(46966006)(426003)(336012)(2616005)(47076005)(83380400001)(36860700001)(356005)(82740400003)(40480700001)(36756003)(86362001)(82310400005)(81166007)(40460700003)(478600001)(54906003)(44832011)(6666004)(4326008)(8936002)(8676002)(2906002)(5660300002)(7416002)(7406005)(70206006)(70586007)(6916009)(41300700001)(316002)(186003)(16526019)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 05:00:01.7267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b215c0-b78c-4111-db5e-08db6b01e11a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6771
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

A hardware limitation prevents the host from enabling Automatic IBRS
when SNP is enabled.  Instead, fall back to retpolines.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kernel/cpu/bugs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index f9d060e71c3e..3fba3623ff64 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1507,7 +1507,12 @@ static void __init spectre_v2_select_mitigation(void)
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
 		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
-			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+			if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP)) {
+				msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+			} else {
+				pr_err("SNP feature available, not enabling AutoIBRS on the host.\n");
+				mode = spectre_v2_select_retpoline();
+			}
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
 			update_spec_ctrl(x86_spec_ctrl_base);
-- 
2.25.1

