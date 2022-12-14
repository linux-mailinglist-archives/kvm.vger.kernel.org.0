Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8C064D073
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLNT5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiLNT4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:56:18 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D752C10D;
        Wed, 14 Dec 2022 11:53:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRrLR345INPvxFlhSdSeOpzxiGnpak9+Z/c1uGWs0DYwp0ICxvXEXCd3A6DhYZpVBrPPJrj1MIMHNMgE1DjPC4Tv1M78JD2/OLz3Re+J5zEZsyPbVVBtVCZeHS0Vkmw9RzY6YIrHD1ebhMlUwbnIKheQHCWQwMaNsT0XBgkoGNkb3HV7LN9vJGHAh7uuOFmIAr+i4LfaNGnl5zdlz4E702ByXbwSLOla1a3IoMgpskXK+wm6dpgJLWUyNUHt9NBjiZSiu+kor04kW5U3URTGr+WK9A6TPGR+LXuoDoMH8zA5ejuojg8DGeg0P00eT6ByBPb6LBCz0hif/KQP6Bw+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rRY9S+poCqn/XGHRQP5gYUrdAtRxMsAtv6+gdzhKppY=;
 b=mzCUmD7l7eW0AQ9THCpCmRxX90Z6RVFICk2wGOMqexoVNpSmjYLKO8PZMzviJzZjmQrJeQEa9iyySU57NsWK8vreejo40y4ahq3mmmC9zslEXNFEleN0nzwPDnAC7nTOHGm/ycDXNzTdWDvmGvv05XkKCu4jUxCN3FT3a3pQRb6BCYO/FUCyvE+6NZMXUsEzAGSm4p3yRCwkdWsboAPoFiPIH9R7CNCMLAg37PTEDmlnRIhu0ZF2i+bkWc7Ldh2bCtS3DZAI8jeXu7m2g7Xs9z2ZQxZJjJ3eIDZAI+giu6VDEh21PbsRa2w9v0D4f1GwnELYVrbB5qFjNe1RKsxDfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rRY9S+poCqn/XGHRQP5gYUrdAtRxMsAtv6+gdzhKppY=;
 b=sXvSsfEfC1h83fuOrdHkYJphbRlhDzw/cgN7vUUEUHq9CGWNhaL7tY2Lbber8U81nova0y/pAVf7wJRG2r/HVjqeQRRWPDnyPWDLK6CtahyLoyqkxVjbh6j7rC97Em2rnVHC3xYLZfs1WpFINaKuUmYwZd5w+s0+f9Qj4kEzWm0=
Received: from CY5P221CA0115.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:1f::12)
 by SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:53:23 +0000
Received: from CY4PEPF0000C979.namprd02.prod.outlook.com
 (2603:10b6:930:1f:cafe::c7) by CY5P221CA0115.outlook.office365.com
 (2603:10b6:930:1f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Wed, 14 Dec 2022 19:53:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C979.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 19:53:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:53:22 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 26/64] crypto:ccp: Provide API to issue SEV and SNP commands
Date:   Wed, 14 Dec 2022 13:40:18 -0600
Message-ID: <20221214194056.161492-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C979:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: 05d4b19e-a2f3-4043-3d9e-08dade0cdbe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tM6Q1mGgnRGZlaP1aoFsB2/kzBMnIguwWv3fBO6jnGcQXHdWiCgtsqgXauO1VOFhkbtR1uO4FhPXIpN6IxpuDAiIKFj2vtMED8LnkeWomf4zyzTjKOuHE6RLzLIyH8yL0w+UxGechGev7X4gcUA7beV5COneye89HsLKj5WA8s8e18fBgGjChADSHXVi39MAtBpTORh2p1rCeEa0egvaTSwkGsWarSbWxCVRFpRe/3PoLpPmMHJKNevQe/j7z2t2XZyUKHzf3SZVd322MCo9HW2GbhyBTc9/Sa6y+fNlzGn/8svr4FHzemx1HSQOeV0cvym6Sn8CpBqgdXgXBGTZ+1tQtU0o3UD5lA4M4zijrz4bjaCy/R1KEfgM/ZdobaYXJOfJHfJIBztnBwtc8yZmhpvNSW9+kC5rVLSH6AfmCLcNE63FGD4fASFAwh6+PsvgQvX+jycM4YAVL1O76IFOdeqyMvM2pUgVQqnlNtsz0O2J7+qFKPlb3UScbItsn9QyoJTR2sBlcZtJhz6U+u2KwMRr2iautfHHN15h3+UsHjrC54Qm3OtMMXcqcyQ8Zpa4iZUih1T82E05jsJ4F6qqRNrULdr5l2YmzTHhjsMMmTJ57YM9EpWPXfT/Gt9JG7t/Bg0sN+S8B5lSK3GyF03LrKnNIANFdWVZAqCz43W4iLc43ixlIkjZSPbu/t/KiWj2nU0gRZExDnylrjJR6WBwlcDH+kCfUczHpv6u4HKncpkDDVqyVqElcw3phoNGPaQjwDP58GMT1tstyejEozTPkA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(46966006)(36840700001)(40470700004)(7416002)(44832011)(7406005)(186003)(2906002)(70206006)(4326008)(8936002)(8676002)(41300700001)(70586007)(54906003)(316002)(6916009)(16526019)(2616005)(82310400005)(6666004)(36756003)(83380400001)(47076005)(40480700001)(26005)(1076003)(426003)(478600001)(336012)(82740400003)(81166007)(356005)(5660300002)(86362001)(40460700003)(36860700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:53:23.5354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05d4b19e-a2f3-4043-3d9e-08dade0cdbe1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C979.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

