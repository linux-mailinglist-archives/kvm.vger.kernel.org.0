Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B864D084
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiLNT7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbiLNT6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:58:50 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2F41F606;
        Wed, 14 Dec 2022 11:55:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK11vb6meTxeW+oVjJuBRbv38+t33FkmJTeq84XPKeIFIX76vwcuCLwtCjR4dzR6J+j/gyhfrz7js+hZ+gvOqYc2sbbmWCRiV+eCmg+xaVDnzjxcNH/6PQkdB+UFzQ07WQI+5LhhxNWrmkHO6tVRZkCVnDa/TQJuEuKZ2qmsCruS0jtMDVZPotBfK0b/6Cl6WG6uZHwfI2OrA/eHCbzX9YvT2jetaup6Nk0ucjCvSUlZGi/SlxFs/SYtwZ4/dgoySAV43fYu9MTe1EjtuvfluUEM/eu8A3N7yFefsNDzu9FOdSYdjjpQ9Mjzba1VOhhnzOH23D3KLZKwQquGdJK9SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyPA4dikpCpaB//lg8u/dlw5GszNJ+XYmnU5P9RFUVc=;
 b=AymKQ712l2f78FTTDcE0i46rwSBk6lrsw9mO93kCGYCMcPiGIwPvSXC1qRFcwr3yX6S5KtmqdEGNVWeaO7Gpg2N+0mY2hsPcGGMhmsf4nwS5HNz5v6tEgc7BxzAR8ZsMmskNAmRqhukabL+Lczj1xfPpkxJ3NvULDMWggmIOIIxyeMFfpg/fqMHLGt9goBsCoB5Dk8wn9gKoOnP5Vg1f5+hmu7w4myJq5ux1u+1H8lCyWZA0xioNxLDHO8/XrNaIem/ehWvyK3EE+NTtIf+f6oXvhu6emr+7jblBV4CU+oy9vENA3pBs95/GDWV2/bFHX/yqKF2ztzpkXuxZ1IcHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyPA4dikpCpaB//lg8u/dlw5GszNJ+XYmnU5P9RFUVc=;
 b=R7BqV4VJdhT9K745gODLDUMpZRQKz5n/8a3SmDuiNt9OCgsRrkkv//XJC0kgP0rl4l+Wc6W+bE5I2j8+x3OZBCykti42NMF/sSrI52s1K1NUFwa9QWEcrqQaQFUdxXvLTte+L0RLITwsD4s6SJ24J0PAX6XSygVIQSej8XbvoQc=
Received: from MW3PR05CA0027.namprd05.prod.outlook.com (2603:10b6:303:2b::32)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:55:53 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::e9) by MW3PR05CA0027.outlook.office365.com
 (2603:10b6:303:2b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.7 via Frontend
 Transport; Wed, 14 Dec 2022 19:55:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:55:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:55:49 -0600
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
Subject: [PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended attestation report
Date:   Wed, 14 Dec 2022 13:40:24 -0600
Message-ID: <20221214194056.161492-33-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|BL1PR12MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c5f475e-4351-47e9-d608-08dade0d3510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CKV0dUR15uZvChzEiCNt59C7iFdFrM4IZ4IiyJPq3Y91qrfqS9cbH0XgBCIObWA6X9qmbUd4TFQKcL1oOfapQOzjl9l2779wMEKbfKklSTIlt+2GVeOYktnB65vv3+6U8XLjBsuQHGaMFDNmE8YpD/UzXdnKPsT50+wxbFCy98IEgM514pAw6mHqNHAnxwqfKMMgA9Wprcf+l3UAY/ZWJ2XaGlsPeCUKpnlcidfmK/QYDXCnzMlVQY3DLOOK/Rst84jLqCXsjvHGG1ekI0lWvF8j6ikQPXekqWeGoPkXqM7/TSE28s8776U7Ddpw+76xrRghgclsai0npfvEmXxgCLJvGKg1io1g1ARfl2SxhtmKSsxM1oIh6/FBzBA8WIDV5TrNLAMlVXN74m5YvPAOTmvJe1oWtWMhrBp//tFDY3kcDe0PGOF8zqjkJOy0Lrs22+gH+IvoyOH8pEKHRd/LwTUEUVXfQLCRY22qNQagXnEVuv5TM7Mqjcl7UGrNrjkzBQSJNqt16+jPc/qLI1bIJZWoROSwjkVfiiBFKNBNLF7TZIOxNoWCKX63lCRx5w/wkLLQZoNGc1ZKCPL35GPfmf0kkSZkicBNrxZTQsW9HjtBsohpq1pM950/B7Ge5AVzFKJXgf0zCIIqLKclxvAUyDeG57K50ktUAGPqalhq4RDyjjxztpPJntKYdiQAl+me+6nH0ovXXI1uugRQMN1nNh0DI1Rnvn+/Lhh4m84+xx5qxR0UzDWOzwQS+uhovruAY3tyUQzzb60A4+5He5QXGw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(6666004)(316002)(6916009)(54906003)(478600001)(336012)(2906002)(47076005)(70586007)(186003)(7406005)(70206006)(4326008)(1076003)(8676002)(41300700001)(2616005)(16526019)(426003)(83380400001)(5660300002)(7416002)(44832011)(8936002)(40480700001)(82310400005)(36860700001)(26005)(86362001)(82740400003)(36756003)(40460700003)(81166007)(356005)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:55:53.1177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5f475e-4351-47e9-d608-08dade0d3510
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
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

Version 2 of the GHCB specification defines VMGEXIT that is used to get
the extended attestation report. The extended attestation report includes
the certificate blobs provided through the SNP_SET_EXT_CONFIG.

The snp_guest_ext_guest_request() will be used by the hypervisor to get
the extended attestation report. See the GHCB specification for more
details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 48 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 33 +++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d59727ac2bdd..d4f13e5a8dde 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -27,6 +27,7 @@
 
 #include <asm/smp.h>
 #include <asm/e820/types.h>
+#include <asm/sev.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -2016,6 +2017,53 @@ int sev_guest_df_flush(int *error)
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
+int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+				unsigned long vaddr, unsigned long *npages, unsigned long *fw_err)
+{
+	unsigned long expected_npages;
+	struct sev_device *sev;
+	int rc;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	sev = psp_master->sev_data;
+
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
+	mutex_lock(&sev->snp_certs_lock);
+	/*
+	 * Check if there is enough space to copy the certificate chain. Otherwise
+	 * return ERROR code defined in the GHCB specification.
+	 */
+	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
+	if (*npages < expected_npages) {
+		*npages = expected_npages;
+		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
+		mutex_unlock(&sev->snp_certs_lock);
+		return -EINVAL;
+	}
+
+	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)fw_err);
+	if (rc) {
+		mutex_unlock(&sev->snp_certs_lock);
+		return rc;
+	}
+
+	/* Copy the certificate blob */
+	if (sev->snp_certs_data) {
+		*npages = expected_npages;
+		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
+	} else {
+		*npages = 0;
+	}
+
+	mutex_unlock(&sev->snp_certs_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d19744807471..81bafc049eca 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -931,6 +931,32 @@ void snp_free_firmware_page(void *addr);
  */
 void snp_mark_pages_offline(unsigned long pfn, unsigned int npages);
 
+/**
+ * snp_guest_ext_guest_request - perform the SNP extended guest request command
+ *  defined in the GHCB specification.
+ *
+ * @data: the input guest request structure
+ * @vaddr: address where the certificate blob need to be copied.
+ * @npages: number of pages for the certificate blob.
+ *    If the specified page count is less than the certificate blob size, then the
+ *    required page count is returned with error code defined in the GHCB spec.
+ *    If the specified page count is more than the certificate blob size, then
+ *    page count is updated to reflect the amount of valid data copied in the
+ *    vaddr.
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+				unsigned long vaddr, unsigned long *npages,
+				unsigned long *error);
+
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int
@@ -968,6 +994,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+					      unsigned long vaddr, unsigned long *n,
+					      unsigned long *error)
+{
+	return -ENODEV;
+}
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.25.1

