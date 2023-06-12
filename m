Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29EC72B693
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbjFLEdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbjFLEct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:32:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E251985;
        Sun, 11 Jun 2023 21:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G88XIdgK7dbYM786YjyBSPIoyhGxD8ae4u/yC3a0HRCbUZpudILnGcL9krvoxozyTAqX3ELBm0pF8RULlQQssL8qgmocpDYyaeQw13mecZDqtmMovcaoZBrKAzLnugE25KXbPkDmeeeXbhaAicxlgig2nVjIiJkFfxdhaRXj54ixYFKYzf9/hV88xmpQRYE9YC/0arHFG3NU9+zO52CgXbEsNQjnGD72/4Nz9kiEkHvDPLyQL/lMd8046+9M9rMFcWrVET/WOf7A0/ptiubmKcfzg//KEf2CZfZkMGkNAaC3HDOvTlnE99mpFSjGaXX3b8C4QRHpYCpDrl8103hK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJEJCtXjTD3p6zQVrVmrCzCQ8ktEmSSTgiuPOntccjk=;
 b=GCablkPMyq91VWPtNUN6bcwXkE7hdCQ1u9D5oaPkWqEZwzKNWLO3ohHc538Bd/Yfbibk+Jk9Kn5VkLm+95xp+BJKDEZnF7r6Eye+Xl6eZ/7bqV7c0gBiDWwTIeHAebR2x4hNa9GePEraZ4qmBBI1ayaD3MdWREO6vQu7p7TjW6LBxJPO2b4fE7oaoeMlbfKit/MU2s9zbRg+HEk03WztIWb1fD3DER1p3S9CK8cWKHDum5KEEtJub+N/2ljs/f+FplQTmSOlpnufKVKjDH4Hkb6bGEAnJXh1qaNTJ8ZBNhUta73tLEtDVfscdRO2b53WEmZcO5CWOVpMAQ6i1sJrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJEJCtXjTD3p6zQVrVmrCzCQ8ktEmSSTgiuPOntccjk=;
 b=oCC2mau1k5WHj2ypSYcugidetyViTxVJEp829Fzw36lXXSriVx8+tsBcALcXbAiWYaZbA9cj3NTYukYgu0gMgqtNtZGEH6ghWzIc/ks3UNjA88lH8KdadbLmdVmmwuXih9gJUrhaL4hAmXoGoVxCk0tomcVRGHe11Llng9Z5TV4=
Received: from CY5PR03CA0030.namprd03.prod.outlook.com (2603:10b6:930:8::25)
 by PH7PR12MB6561.namprd12.prod.outlook.com (2603:10b6:510:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:32:04 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:930:8:cafe::95) by CY5PR03CA0030.outlook.office365.com
 (2603:10b6:930:8::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 04:32:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 04:32:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:32:03 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 18/51] crypto: ccp: Provide API to issue SEV and SNP commands
Date:   Sun, 11 Jun 2023 23:25:26 -0500
Message-ID: <20230612042559.375660-19-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|PH7PR12MB6561:EE_
X-MS-Office365-Filtering-Correlation-Id: 08a2e49d-4b15-4d5d-5508-08db6afdf95c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8tqZ1uVCZaTqtuZtO1IPhsTKT7lYbW5efi5Xli+dF3TsegNHy5ezpWx44nd+PRF4oFxBPmCssmDyKYD1JpZ5rMOZyT8Xapt/BGE9Ik4lqeRztWElaws0x1c6sj1rsD+JFj6XRR96e4rio9SlQ4x8qmnYKTk0twWAHltvx25sGFAfOmmHnjdJfH126a8pl9ahZN79If+cpiizQVVON+nFzU4+p/BYUhlc9029P0poZRlld1lrDdZpbeFuo9RWIHErxea4Gebs4eoyn93/B5KEkNZK9RFQZYniUVrUWMD7vgWiKjz3KrP/gG2a33jCMnxFVymQjsCsb5bpYdWks92M6rnYLo7B83o74e6bErdfcWQKdtSGk+SBW6N/yinCv4zdW1i+QNuJvCurwXKCmlQso4dL08jsh+mOBltXICSb6arVDG0Dd+3Atu1QndSPCxYMAjxbkmHY4sNYsoqEffpRB/ZNodkplzgNQ4ecIEFeCrI1MWDsHS3yDs6L82/AyHzydhBVoQHijtwzP/B9Cpp9bdwxTvD82H4USXyp0+9U0woCyqkNr5y4+DVKUVnwZnfTEUbv91CT7rAdUNqW56Nq17fbQpVgsygMA9YqhIU8+weebDLcuPhw3eopuL5N0uFut5nBYQgje5Mnv80WyfVGSuSidsJ+haqUErN5O3gB771AvzpGjphrVHflpl7SxEoOdIeqP83vWaCPRVgUsf5SKsEnYp8PPATppvdN928VmGWa1qMOD6Z6kTaRh+LpLM4u7X30mrEejm3pou5s89g2nP7hhLChrcUWKAhL5ctk/0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(316002)(40460700003)(41300700001)(336012)(426003)(82310400005)(83380400001)(40480700001)(2616005)(36860700001)(26005)(186003)(7416002)(7406005)(44832011)(2906002)(47076005)(86362001)(16526019)(1076003)(81166007)(356005)(82740400003)(8676002)(36756003)(5660300002)(8936002)(70586007)(70206006)(478600001)(54906003)(4326008)(6666004)(6916009)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:32:04.4342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a2e49d-4b15-4d5d-5508-08db6afdf95c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6561
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Make sev_do_cmd() a generic API interface for the hypervisor
to issue commands to manage an SEV and SNP guest. The commands
for SEV and SNP are defined in the SEV and SEV-SNP firmware
specifications.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  3 ++-
 include/linux/psp-sev.h      | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d3764ee073f3..88c5bf264a87 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -418,7 +418,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
-static int sev_do_cmd(int cmd, void *data, int *psp_ret)
+int sev_do_cmd(int cmd, void *data, int *psp_ret)
 {
 	int rc;
 
@@ -428,6 +428,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sev_do_cmd);
 
 static int __sev_init_locked(int *error)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 06d0619ca442..c8656a36baeb 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -891,6 +891,20 @@ int sev_guest_df_flush(int *error);
  */
 int sev_guest_decommission(struct sev_data_decommission *data, int *error);
 
+/**
+ * sev_do_cmd - perform SEV command
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_do_cmd(int cmd, void *data, int *psp_ret);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
@@ -906,6 +920,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1

