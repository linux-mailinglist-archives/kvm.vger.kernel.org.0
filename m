Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF369D32F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbjBTStq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjBTStZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:49:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897C61E2A8;
        Mon, 20 Feb 2023 10:48:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4WRyFoqpowrNCmAvcBEOaTwVqCkS5Ypqsn4gb38RX8P0f6PzeLVf5NI6XeuXVMK2AHlpy5AZ1DNU1/AbA0oVrEk4PHPBD8auQIIwfdOL6UXhGwCrnUq2s+2VUSF01d+LKNLCnkMYGs3Ox3MRm6Z9jurkLvOzyEYsi8iTjS6PjoLR5bKSXmVZD2MRQlNIfmZZqy77u8Y9rfpAV0zdcOXLS9lW/VfDv65QnyWeW+wsqwoO4Q+VxSsJSWGHakPSL8HrQMvUgO1FpDwS4VRGDKZI2hls1Vq2klXptmCxWsB0qYTA11VaYe45cCUYFFAIjgA+uh3id1HAEvQf4yuH5aGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRY9S+poCqn/XGHRQP5gYUrdAtRxMsAtv6+gdzhKppY=;
 b=S639+u09irAeLBT3E7PmVG6QyYmWQnpPOiIz3k9Gg7PM/jv95TzoUDUJ9Hr5Q7W/lGiZDXdrCdiJEXcE/kPq9d1NZp57qMQLrEHJV4YBi/a8UeicNoVkkwYa7TI/DBpsKJOS4ECMEtlpye2UM/UF+PC/5HuDkijb8PGh7l8x8grGbu6IzLgHK4uWZ2bi9pUYTH6ArPyWyBphdOJFpoK0IvLcWEGbSnBTkpuoeoN8KrCZyqho1+cea1gT966q4QOGlXoBh/hl+AEhYib9aBU+2siRXyhk/Tsnv+AqHHh4iKo+wbdLRMyLyjICWp+zZ2OmYLZSohlMV6VM/f/6IbS+vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRY9S+poCqn/XGHRQP5gYUrdAtRxMsAtv6+gdzhKppY=;
 b=aqKl34TRfitl6kPjGIpLHPd3bbZlcFzAolP8XprAUROMje9WJZMx+hSG1LZqCloBHLsaLFzXWlB6SNg7v/t/SEqaR0u4NcbQxNY1oRh3A18MZwJXkiNFyYfLgrPnoXSux+Ce+NalmdCGFU7mchHwrgi6qjiZ3S4qB0WBF+24J50=
Received: from CY5PR15CA0022.namprd15.prod.outlook.com (2603:10b6:930:14::30)
 by BL3PR12MB6428.namprd12.prod.outlook.com (2603:10b6:208:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 20 Feb
 2023 18:48:27 +0000
Received: from CY4PEPF0000C96B.namprd02.prod.outlook.com
 (2603:10b6:930:14:cafe::7c) by CY5PR15CA0022.outlook.office365.com
 (2603:10b6:930:14::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:48:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96B.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:48:26 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:48:25 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 22/56] crypto:ccp: Provide API to issue SEV and SNP commands
Date:   Mon, 20 Feb 2023 12:38:13 -0600
Message-ID: <20230220183847.59159-23-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96B:EE_|BL3PR12MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c5e00d7-69eb-427f-5169-08db13730d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ROLlBfG8ETRc2hPOlTR95vXUNCQojg43+RtuuS0+z+uh/NaBTz8V4XOAVNuBzYhjc4SzJCCUCJhZOhBsfMKIxr/mCRp583BgCE0CuFKKixmFTDrj30ntX6ZB5CGVukcmeZI514egIC8CYuxw7azfByKM+uhDPeMTc+fG6bqMvCxGaXj5w6J9KhodP0EQUFGPTYuNHpmK9J5ociVT4Ok1KTDccznH6pH5Tc+6lbtHxUQb1SnV1scBgucQtreuJpq4hRVCw0b37/YPZDGpNJiJzh29mqSMKej3A550RZtmPZ3RPv37jfYX2JiLr3/scu2QLVa92rJ8ciKyjj1Q3K6C9rxyvYX0nPg1jZhq2LSrg+gQGT/c/LF9S/IEnBudAhLRYu0O6EFdGepb+XndXKCzlIREulZpfHkNOf52FD99gtlcFeeYC4esODCkBzMawg8PzgT3gDa/2G/C6PfxFLIpcIOgpH15qlL4ETkCr+Jwgy0veepbhDEWohNxlOM5qbsMCT6rYj1J5eu3UU6NlEdxKB9asgVYBypQ6YMui4b+sNFibR1BUNIhJn4UPiOk1TiW1cB9U2L0ca18/hRYmzu0Ki+BPNKKvzkwp/vVKStosM2FGgeooHmLS75XSVgjJiMNi684ikwCk+Z4zB718h05B4F4xj76UdOcIrxxqkVb7XIAJwT62XtnCcQo8+WCbWLDjoSkPr86+J3ClBJywiczhQ6lr1TjW1WJZQ3Nl7o+Ubklg5/WAxiMUWZ1DNBFBTwIH1QVEmbyxsNuEUEteqPU1w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(86362001)(6916009)(8676002)(7406005)(47076005)(41300700001)(54906003)(44832011)(70206006)(40460700003)(8936002)(36756003)(356005)(70586007)(316002)(1076003)(2906002)(2616005)(16526019)(186003)(5660300002)(26005)(478600001)(81166007)(6666004)(4326008)(7416002)(36860700001)(336012)(426003)(82310400005)(82740400003)(83380400001)(40480700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:48:26.4483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5e00d7-69eb-427f-5169-08db13730d22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6428
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index af20420bd6c2..35f605936f1b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -415,7 +415,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
-static int sev_do_cmd(int cmd, void *data, int *psp_ret)
+int sev_do_cmd(int cmd, void *data, int *psp_ret)
 {
 	int rc;
 
@@ -425,6 +425,7 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sev_do_cmd);
 
 static int __sev_init_locked(int *error)
 {
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 8cfe92e82743..46f61e3ae33b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -907,6 +907,20 @@ int sev_guest_df_flush(int *error);
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
@@ -924,6 +938,9 @@ sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENO
 static inline int
 sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
 
+static inline int
+sev_do_cmd(int cmd, void *data, int *psp_ret) { return -ENODEV; }
+
 static inline int
 sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
 
-- 
2.25.1

