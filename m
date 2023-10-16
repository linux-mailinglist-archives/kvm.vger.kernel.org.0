Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B6D7CA97F
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbjJPNc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbjJPNcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:32:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF26113;
        Mon, 16 Oct 2023 06:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fuzp+IXwgjlj3Edgkly7UVmdc42Nfj505mpiPaESNNYNY5qrbTIbeegN2vya+RHu6Uh0A55JFTgjaWWZ/p69/Ws3wBVfjOAqaGDX4Hl7T7rWUBGoGog5647qFiT+JplUHCwCm6FVV8a4WtUJIx+sD1Q02dnGTmCIlG3ufvASZ14T+MfXN0vgY/psIRXVlq60LPcF5GR7gagxn3rOZBBhVgb1Ic0Y/oC68NwdaPI6yWNFPulRezMt7gMVPglKzeFlLK7JKVGRUFWh0lgdlUc4JidY+FoBQmk2RgHuV7+/rGOPo0F6pjFNCDwBh0zME1pfuIxoexVycGkrjF3hFBoYow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMVnZdaIedORILVsVs2LBp9XD6mE89r1G8/d8uG0pK0=;
 b=UhCvJbJPo3yhjkcLBqoPg+QGdut7J6FJWhtOeBEfWgpIqqR857qo6XyCkbH0Wf17Ys5j103MhlA5BH3ZTwECzchY+9+d+hGnNfeeUUbHZyH4WsKqfKiB+8h6+pjuOEB8UMPtVZ5dWpI+UxCCkMT2CuSwUzLsgkt1fKDo6aRuIcdSdWd3hGZKT30xnwNbdIy3lu9hmG2tveK1/FjjFhxN9vJCUUWNNinwYpU/yf7K4RuZazre7OzHIGuNTl349xJiFdecXrZEwk4qkn46pLMXA/9CnW/Cn+IoyAMZPA5opY/53uzvTlZBgHYPybRnA9nW3iInvW+gPv1SDPTGh3X7KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMVnZdaIedORILVsVs2LBp9XD6mE89r1G8/d8uG0pK0=;
 b=D4LypZbwtyjnujiAKST5xnD+8tCROT0eI540JUIRnbDvlsKNZEWAatzkUe/N/yxw8EtFyf+1vnSEOhiwmFkuIn8fi7It/0hFkpLvDDAO4i7AnLuhsWmbF/Bg940tazsk17fQxOwcO36kxRugynFwwotxJAn6VRSxUne3xAq57wk=
Received: from MW4PR03CA0291.namprd03.prod.outlook.com (2603:10b6:303:b5::26)
 by PH7PR12MB7870.namprd12.prod.outlook.com (2603:10b6:510:27b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:31:56 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::f5) by MW4PR03CA0291.outlook.office365.com
 (2603:10b6:303:b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Mon, 16 Oct 2023 13:31:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:31:55 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:31:54 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 15/50] crypto: ccp: Provide API to issue SEV and SNP commands
Date:   Mon, 16 Oct 2023 08:27:44 -0500
Message-ID: <20231016132819.1002933-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|PH7PR12MB7870:EE_
X-MS-Office365-Filtering-Correlation-Id: b0701ea1-c92c-4e7f-e5e8-08dbce4c43db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1QAkLh19SkfcyEIiUIBAdWjGPTI6CMFDrzy7VJrS5+eG7rJVsIPsN2tziCi+uzcttl0a6zyAZ+jH/BBtG2ySCvSfGEyPBmAY6Zenf+RsBZQoPt0vZOZMzpPf5qTKXMgTepEmmAsBeLyBHgC4fMoA14HyAz+bBVWYZd/PDyPEWvmjEUWPr0Vv4yykyFQlImofKXKXFiF6Egq+mdnli6v6LYqliBNbICI1l3qpMN82kHoIJqKHImeKmC+gaR+So7EAZYh33rO6UTYudSWVs6xvX1FZ5VYwlvqCT7WeTWQLZvVRK+P5AXvLK505erlHL7hJCmsL2Z5Hv3XlEDJjVkRqa2Q98fZh8aHOQWRjNuCMpsJzVQEsNdDtI4ll6uPU971ASEOSzPGNrhZdXKNFgkJqfTENOqMlqTXL9ZGcWdZ0jxNqLqziJXTsEvb0SQUXHpLfsJNC+FcMACOnaAmZPoo/AaIhtcYyC52p8eFz5K2rsStuj5xinlCNOQHT/92LkkeqiY3qszu7owZ1V/5thxlIiQVacfkBTlZ7Dzj6gos23Kml14IVjfwEQX+X3hO2QGGEv97iJQeywLHB3DLJFw/AI3mGLxEp+PXTtEraWtuYxfLxaeYEvovgCjXz2u6RsSXey2t9e73d+VMcbuiuemenqcFeFGon7m+d2xM9/XsL6yrz7RBwRvZrviEVLzyHsDjIrgckfhDKzf/7PiF6nJZk8r1M0QMFJa6whEXLnNFWVIuc7CAsTkhnkrcy5xdb28Qqu+6b4Sk3YC1ZjC6rlzwPFhYu/cNNuOm0Pv1QKVwdLNY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(82310400011)(186009)(64100799003)(451199024)(40470700004)(46966006)(36840700001)(54906003)(70206006)(70586007)(478600001)(316002)(6916009)(336012)(426003)(1076003)(2616005)(16526019)(26005)(5660300002)(8676002)(8936002)(4326008)(6666004)(7406005)(7416002)(44832011)(2906002)(41300700001)(86362001)(81166007)(356005)(36756003)(82740400003)(36860700001)(47076005)(83380400001)(40460700003)(40480700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:31:55.2971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0701ea1-c92c-4e7f-e5e8-08dbce4c43db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7870
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
---
 drivers/crypto/ccp/sev-dev.c |  3 ++-
 include/linux/psp-sev.h      | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fae1fd45eccd..613b25f81498 100644
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
index a7f92e74564d..61bb5849ebf2 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -883,6 +883,20 @@ int sev_guest_df_flush(int *error);
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
@@ -898,6 +912,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1

