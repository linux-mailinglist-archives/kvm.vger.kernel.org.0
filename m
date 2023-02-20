Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273E069D349
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjBTSwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjBTSwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:52:22 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6FF1E9E4;
        Mon, 20 Feb 2023 10:51:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzfNFo0skAl9ryEW7VmRogVluaIfIX3HMt2YCg1/A+NiP11xkya6o4d0rT11Wf3l8inBnhoooMl1Kb8cxbvX6r0Iyn3VhkOnER6jGxXaGwkYp4Nf+JGvpjaB5faTuhPkHdbH687uTgOh3IwllKCcCnFMpO9PXLGWatnR6cUdm5Oyb4NStyxzfGSCXADCtJdBKfjC257tXGGVyoaqkx8Km9LCNKEHWAKM1Bm21pG2M9RpznggoWJrcL8X2CcOB1760lPuvtGk8GHzLft2kaeoz1AuNEXcu1Xdk5CguB2dOWpZsK/jCYjBm2yLEE0BKw4wAipirxesLJCm8KwO5BzkCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjpNkINyZyAw+Ocb5Ohq8zU+vpUdm3APUpg0cCkBwOo=;
 b=GT6TLuRyYXmDWuzKsB/W/LgVm5U6c37sx6xZD4H9ZqhnoJmpAKjexICdf+G2axA7HX43auEa0TJSgrIlAZnR97p9t7/WibYobGyWFehRLISe+uwg5IpfZg5N5osiT1etnLL0dQm3zRiV/MGv4m4fvPmY/u0DZMMoyedZA1KtMxifbaBmvv5GCJJA3G5RVq9l4Nk2gIf1LruNfzX39qm5KoL5fUDEl2zBg9QJkqWBaGOZz5WLYez9D082vd37d9yThC1T3L1Y1fF2gDtXgP7TtSs1O9M75bQo0lNhJ0CcQfSFebjbTFRuYCWRYxsk3hY+mlaT13MsCrruhW7buRO7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjpNkINyZyAw+Ocb5Ohq8zU+vpUdm3APUpg0cCkBwOo=;
 b=nToGGUcrYxj4uc5JaTMuXWlwsnhb2vFuB1n7M7H8YrVdt2hguh4HkO0SQyK936Evd204wXOnUpgWBIG9q8ZESlFHntc6JLh8gI6Gn/MPxA7bKM97eGwXKNejN0cUYdNqXnNkNo6ply7zZFgN0rb1ANhNbMcoa+VqtVmfJ9n6oN4=
Received: from DS7PR03CA0140.namprd03.prod.outlook.com (2603:10b6:5:3b4::25)
 by SJ1PR12MB6362.namprd12.prod.outlook.com (2603:10b6:a03:454::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:50:32 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::a6) by DS7PR03CA0140.outlook.office365.com
 (2603:10b6:5:3b4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:50:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 18:50:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:50:31 -0600
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
Subject: [PATCH RFC v8 28/56] crypto: ccp: Provide APIs to query extended attestation report
Date:   Mon, 20 Feb 2023 12:38:19 -0600
Message-ID: <20230220183847.59159-29-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|SJ1PR12MB6362:EE_
X-MS-Office365-Filtering-Correlation-Id: f23e4168-cfca-4023-1009-08db1373583e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oPlKutr988IhZ/sgWNcgrSwNoZX1IDwAm8zzME/FIAexsxr8JqaTEgFeUrul11rn/Q88NVgwUnnLJ9Sjt+2AxJOY3rM/J1OHVBx8PMlA/wCeA3bAld63buhMKj2FDeyakQenN6eHsX3MqWNZX6EjeQXGFdv1qyasrpVXKh6iVBuiHpnSaL3On3gf/36iuoC470bVSbdStAP5PR7pAJq56+YloOCanEElybqTuggYOL+yva5CbASXTRJ1fYg78chL02c3rPqG2+hsZE1izg8pfHxkmTWOCs2gDx5Te8LMYpbipRPLdvDKSGaFElzjNkguslBq8gL4KdzYNlW/kBKL5YA/Q9ECBDF5loA+xLSL2SApwGKFbeNVEM7oyxeOQoSmRODc4UzEpjK8ismJWoiEVrYVfvGI8QSy5jgWWvCe5N9z6zzi7Z8N5WQIBwE+E20Xm53j1jCgi2eLzEn4wgsSzsr6QPBn3FgXNlifKz9AAQuBEBThaE2Ul7B1v47R/xy45vKvOAjO2mMVULlp7prrB37NW7mEDl7/gs5qJ9AluRW60Ef5GWvdJLg+NQ021StUYn43gZjusP5KGE6Qffq1k47jrdDEHdKrxfNDL5Y++3Qv94e/LJKGXyHNQHguKm6RfokflEbrBPaXVpIRtYZl4xBMc4jWYe2o0tJAA+E2VkYxU1KE9ZLU/+GtvTAeNTSSwB5WlV6vzhX3FCwUpLRuj56Tu4YemQTS+lDgNtDsDLHMYMQxdKkDbHfKCf3ngSDPf8UbDWoKJU9xcJ+aPoYwcA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199018)(36840700001)(46966006)(40470700004)(6916009)(83380400001)(36756003)(40460700003)(86362001)(36860700001)(8936002)(5660300002)(7416002)(7406005)(81166007)(426003)(356005)(47076005)(82740400003)(82310400005)(40480700001)(2906002)(478600001)(336012)(2616005)(70586007)(26005)(1076003)(4326008)(6666004)(44832011)(8676002)(54906003)(16526019)(316002)(70206006)(186003)(41300700001)(36900700001)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:50:32.4905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f23e4168-cfca-4023-1009-08db1373583e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 33 +++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b56b00ca2cd4..e65563bc8298 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2017,6 +2017,53 @@ int sev_guest_df_flush(int *error)
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

