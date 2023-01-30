Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310DA680362
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 01:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbjA3A6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 19:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbjA3A6F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 19:58:05 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09DD8A66;
        Sun, 29 Jan 2023 16:57:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjqXO3fRRFF1aEYBsHMjBAOY3sxGdKbM9I5AS5rCYA4Qo4itbpcXWRx9xhpB2LaUPgES9uWnDolE2bGI+o+5hFieSR/0kFcxYaSegEczb9cIUlTQEa4he9CPHG/rfSuAdtQ0riPZnUHntR1dP1wr6/AgsB8PXR/v61DUcY8tHvpe+KaDmMddqQk7/OIB+f7mu96bgtP6stRCAeeNuMZH/gdxeFJJ4CoXIVWB84aq+88jZLUU3rEYoZGefXatDOnFqBzsKUW+8HttVrD3iR+Wxu2VDAk+0YmiuYqj9Cf9jDg/THjqOTm4HFfFB6abV+rLlEcPjPNCJU1wEfBKo53VjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybmRIfJ5scbovy7aZdLi0AMom2u5BHBlwYJ8RlMG8LM=;
 b=WggRpl7uWKgwS8v/yZkhtOveyan4mjPC5o1+oi8Pm+qokOW+426iKh4boyRQh65Tl37TA+SqYSJP6UuMSUy9Pdh2P0kzSiVg8Ec4uyKWI8/1L9pweb5ynIA1rsKf3wd6jEvozrk63rxFW+LbE4qteRQlbNflzsw3NfqMO4WhBPX1A0/Y70wtMYB3RPa0u1xCVHu5vGOTVpFcPH6z8awse5TjlhaQ5xFXIGEeb9VYwCYMeD7jsa7yqSJ2xfKtt9ZhH3CQ1NWtRJ7b899Sn4k3x4zghJ4LpweKD+H8wTTcUEl2neQ/aajWzYCTtEIhDa6wrXvpmTdwX8w8zIh6Pr60+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybmRIfJ5scbovy7aZdLi0AMom2u5BHBlwYJ8RlMG8LM=;
 b=wzPZipKouPszOXG7y3QA2gqQCXc4bvbcagrj0X8Dh737Jk/RN/26UpS1MMe98J1NgxZDJljS8N+cYqYA6LDTc+8sIg+gjGYRKMVJAK9rvYFBL9hUMSZbbW45Ldv/csEjkkK1jg1apPU6UrKI/whPLRfkp0BuHTokzaM7FHdyKi8=
Received: from MN2PR14CA0002.namprd14.prod.outlook.com (2603:10b6:208:23e::7)
 by CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Mon, 30 Jan
 2023 00:57:51 +0000
Received: from BL02EPF0000EE3E.namprd05.prod.outlook.com
 (2603:10b6:208:23e:cafe::19) by MN2PR14CA0002.outlook.office365.com
 (2603:10b6:208:23e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 00:57:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3E.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Mon, 30 Jan 2023 00:57:51 +0000
Received: from aiemdeew.1.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 29 Jan
 2023 18:57:43 -0600
From:   Alexey Kardashevskiy <aik@amd.com>
To:     Alexey Kardashevskiy <aik@amd.com>
CC:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Nikunj A Dadhania" <nikunj@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH kernel v4 3/3] x86/sev: Do not handle #VC for DR7 read/write
Date:   Mon, 30 Jan 2023 11:56:57 +1100
Message-ID: <20230130005657.989935-1-aik@amd.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120031047.628097-4-aik@amd.com>
References: <20230120031047.628097-4-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3E:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b5c4782-d39d-4122-8043-08db025d0346
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHktdcMMRGdgGzea/fQmByd49mTJD7zIvTyw4qhBvvtbnCsOcFh+swE8gsi2C09mx945B7EbBM76faSxwhTKrA4GwDk4smBncue4mEcXj2rtYqEC/f5FVVbDXJM1wDwRTL+SjhXuMhoj7wv+xKRRNYzQFqTXVkbO0CWB8pwiotLtSU5V/c6veTGscwfNC/ymfkfsN6BtEm0iWd6zKxlmM3J2IzdOeAcpE7W05goiGvCDs8z0vlBvizP0jjt+dWGcY/AOUKpkhWpytKFHwWuPTJAuUzeztql7KM5eTTzDkJahRAy84zheHWpFovw1Ozml9DEVy/X3MmmKyeBvx4K7g9RGqIT2Mb+OC5hGvZE21rhz9bHqFXQoAGjuLYcjUeB+7IxLr0FmNM+2NrPdROFUfzIEjqF+t+Wmt6+gvScTui3qqnIvB8R5kVYoY5KE15lmRNzGvX8akcbinF6yxVgyDskdGnjZUIUyzxDJfNeq1PXuTcme+M9/bitUSSOFGiKnMCvwhiOQinAX0NpZtyXh7J0xtFPNTxg38oytcm0evh+dbsJRTh3Dde1vJas2SddVPn17VN35Xl+5bh1uU0WIVn7pn4w6g78Mqnqc+YSb5JTCRrOv7ur5kkPsurlzzPn936heZzXRKXFVGKHne72PEhNwxr/t9puAGpXphkKZL/j9FJN29vqLM/U7L7fAPM23Sp1iFtnDwFatb/1eYPNUSV82s315CLcaIEGPXS1hqQE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(40470700004)(46966006)(36840700001)(2616005)(7416002)(82740400003)(40460700003)(36756003)(1076003)(16526019)(186003)(356005)(81166007)(26005)(40480700001)(6200100001)(6666004)(2906002)(478600001)(82310400005)(7049001)(316002)(37006003)(54906003)(5660300002)(70206006)(47076005)(36860700001)(41300700001)(4326008)(6862004)(70586007)(83380400001)(426003)(8676002)(8936002)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 00:57:51.2754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5c4782-d39d-4122-8043-08db025d0346
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With MSR_AMD64_SEV_DEBUG_SWAP enabled, the VM should not get #VC
events for DR7 read/write which it rather avoided.

Update the SNP_FEATURES_PRESENT mask with MSR_AMD64_SNP_DEBUG_SWAP so
an SNP guest can gracefully terminate during SNP feature negotiation.
For SEV-ES (which does not negotiate features) and enabled DebugSwap,
fail to handle DR7's #VC and return en error which in turn causes
panic() as there is no goot reason for the HV to keep intercepting DR7.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

1/3 and 2/3 are the same as in v3 and fairly independent from this one.

The question now is what should SNP-feature-negotiation-aware guest do
when KVM enables DebugSwap.

"x86/sev: Add SEV-SNP guest feature negotiation support" is going to
reach the upstream long before any of these three from this thread.

It does not matter now as there is no SNP in upstream KVM.

---
Changes:
v4:
* rebased on top of SNP feature negotiation

v2:
* use new bit definition
---
 arch/x86/boot/compressed/sev.c | 2 +-
 arch/x86/kernel/sev.c          | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index d63ad8f99f83..ac86f458951d 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -315,7 +315,7 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT (0)
+#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
 
 void snp_check_features(void)
 {
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 679026a640ef..f29e60c496d7 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1618,6 +1618,9 @@ static enum es_result vc_handle_dr7_write(struct ghcb *ghcb,
 	long val, *reg = vc_insn_get_rm(ctxt);
 	enum es_result ret;
 
+	if (sev_status & MSR_AMD64_SNP_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
@@ -1655,6 +1658,9 @@ static enum es_result vc_handle_dr7_read(struct ghcb *ghcb,
 	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	long *reg = vc_insn_get_rm(ctxt);
 
+	if (sev_status & MSR_AMD64_SNP_DEBUG_SWAP)
+		return ES_VMM_ERROR;
+
 	if (!reg)
 		return ES_DECODE_FAILED;
 
-- 
2.39.1

