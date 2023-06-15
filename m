Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A06730F90
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbjFOGnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 02:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244066AbjFOGmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 02:42:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BED2D5A;
        Wed, 14 Jun 2023 23:40:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2JHHOxAY7DSxY0YTfC29pE0o8LlxooTiQbXYkDg8XQOBf6+sf4rnJl637z6A7KkZPzhkrdAMmByy5OAgDVWaAigQF+OPtbX9FJ/lIKZi2WQNbsd/Vczb4Ur9hX/EEh54PsyNjjCXBc+zDYa6sLDW1xnQpGjAzBX8miTPRqxvp+U2sDI0SACMDzqIhsxqCSg4sWp0l1X7XlQ4svVPXr+OlIttgDoiJ3CcO7WHe7jwTDwHxJRHnNxQM+ZDPMdFqEhMuYZOXnMjHq/PagtoKfx4PR2K4ntoYHp1pgIxYJbmgURaa8Se0HQT7z9hlm8D19inO8TZLLvYpEVyVubeFa+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySSvHF+Kt6SA8jUjxcgvyZ9/NMqnoIUJuAV194EDdUI=;
 b=bzSBDPbhylSG59jtlGtbmV5mJ7ubsJm9N2sxX6fedWC4rTy9IOGKLE/8kxvtEhWX339pvU+6SGywPHeUNKWp6kNemg1wRWdZuXgAVdBTh+Q+IoI7zVA6WQErc8otG2e5inG7MTfPcs7EmfdZM1dq6TsfEjRy3CMMDDXOzDOc1xTaq85/6+jerVrLO8TyFyXqu2iNFYixbPGmSeMwhGbl/1k750WsnnbfNxycOGEIQjc+SR0JbfqYlPicwaLQz4LVUeEklV85CTKWq7igeTS8Ly/t4JoC9F23QzFrALo+GhJbCubdLIR79xSCXd9vnZVJc3s0N7QIbpt3UUZIy8fZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySSvHF+Kt6SA8jUjxcgvyZ9/NMqnoIUJuAV194EDdUI=;
 b=RQnliIUwBvie59Y7J/3NUoP9qJF7MbggDGB+YCPvM94FptBYZyT77oJsaWegoBNI23BAUwJKGV8KHY/c1OYpSyQelzzAfP+59rTeKIHAKfee9sYaL+W/pAV+MQwjR7mA+aHikPciZYc6GubMArlKLOyupu33U/BSPSOV55wUbbg=
Received: from SN7P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::19)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Thu, 15 Jun
 2023 06:40:44 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:124:cafe::1e) by SN7P222CA0006.outlook.office365.com
 (2603:10b6:806:124::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.38 via Frontend
 Transport; Thu, 15 Jun 2023 06:40:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.27 via Frontend Transport; Thu, 15 Jun 2023 06:40:43 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 15 Jun
 2023 01:40:40 -0500
From:   Alexey Kardashevskiy <aik@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        "Alexey Kardashevskiy" <aik@amd.com>
Subject: [PATCH kernel 3/9] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about swap types
Date:   Thu, 15 Jun 2023 16:37:51 +1000
Message-ID: <20230615063757.3039121-4-aik@amd.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615063757.3039121-1-aik@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: a708e515-c8ff-450b-ac7e-08db6d6b71ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4nUhyx5QltgfzH0eTbyHPuqcGWGQQQ66AA+oYERzxVUUsiLMXGGR5tUusrOG+3ZbYLBzbKUC5Zalz5eEkYWDTgLF0q662NttxjyNV5qboA1LH6xxHCDYAUVHqw3kxTIH4aTZvlHGYIoJob5RH3ifo60CnRSW+m2TLe5wr2K4ltbWYRO24UiZrbkWJmbQDN/8EbJBz0L1BArUBiASbcNIgj+OolMdTzf3eSbJF/MZW6nRZLeNSNJ9YRyhMojEONAIJ9f6eaUPafIRYzIhV4B+QzmIdLxDvmUYm/l4IXBEz/ZOqt1GezsJe4R08xBBICG95WlUbJAUz3+QVBbVSUTDo/AOBmJ6wyvDfPMQNmbrKEq/8ypl1wsXdyGWiVomTeIMpopRpIs553cOPVhkf+eRLZx+XUljcNJ/96JNWCisIvhw6dHJiOVHZZFr2AGx8ipvYS2oM8+rMP3CKENTZoncByVoT/ElBmjjz4T62P7DGSLc85cr1gd/mzf19qVatUlPBGEGiVVUudxf2IYLuu0WVKvOFVLVLY+jg9V6sQzWSQhRi2vpiN1LQuK609Ztrsm92Xa2sDStz0eDeBh9/ROR6GPnXyMbB6KMY4ie5GP8pghrljHa+Uyt4iXFH3LLRW66yo/+AiS7SlA+hQ/eVLcgkIEOwxuMGOqeZKvmVbYMJCO/4oblxJCdvqCRmoCvWahaW+vzVLA7zmbHWM0ewABrfQjDw8Tt9uPCxuxqZgpxK+pShwbvs+loUT63Gg+NuVwOLf3iK/6RpGQ3Y39N3UvyA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199021)(46966006)(40470700004)(36840700001)(36756003)(47076005)(478600001)(4326008)(6666004)(6916009)(54906003)(70206006)(316002)(70586007)(356005)(8676002)(5660300002)(82310400005)(40480700001)(8936002)(41300700001)(2616005)(2906002)(82740400003)(426003)(186003)(26005)(81166007)(1076003)(83380400001)(16526019)(36860700001)(336012)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 06:40:43.9419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a708e515-c8ff-450b-ac7e-08db6d6b71ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Rewrite the comment(s) in sev_es_prepare_switch_to_guest() to explain the
swap types employed by the CPU for SEV-ES guests, i.e. to explain why KVM
needs to save a seemingly random subset of host state, and to provide a
decoder for the APM's Type-A/B/C terminology.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v6:
* new to the series
---
 arch/x86/kvm/svm/sev.c | 25 ++++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c03bd063aecf..36fe2fcb4698 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3020,19 +3020,24 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
 {
 	/*
-	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
-	 * of which one step is to perform a VMLOAD.  KVM performs the
-	 * corresponding VMSAVE in svm_prepare_guest_switch for both
-	 * traditional and SEV-ES guests.
+	 * All host state for SEV-ES guests is categorized into three swap types
+	 * based on how it is handled by hardware during a world switch:
+	 *
+	 * A: VMRUN:   Host state saved in host save area
+	 *    VMEXIT:  Host state loaded from host save area
+	 *
+	 * B: VMRUN:   Host state _NOT_ saved in host save area
+	 *    VMEXIT:  Host state loaded from host save area
+	 *
+	 * C: VMRUN:   Host state _NOT_ saved in host save area
+	 *    VMEXIT:  Host state initialized to default(reset) values
+	 *
+	 * Manually save type-B state, i.e. state that is loaded by VMEXIT but
+	 * isn't saved by VMRUN, that isn't already saved by VMSAVE (performed
+	 * by common SVM code).
 	 */
-
-	/* XCR0 is restored on VMEXIT, save the current host value */
 	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
-
-	/* PKRU is restored on VMEXIT, save the current host value */
 	hostsa->pkru = read_pkru();
-
-	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
 	hostsa->xss = host_xss;
 }
 
-- 
2.40.1

