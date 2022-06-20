Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFE85527A6
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346545AbiFTXHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345964AbiFTXHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:07:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D5823149;
        Mon, 20 Jun 2022 16:06:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIM83dDoK2rXLnu6HWps3nSLaiSxzhItbB1Bt3VcL1vcmQ5Oi0+s/LZMnZ9Lk8pI27BWAKv2u1L0H7lVuHD5Y6aOcodMpd03Ut8lGMonMy+SmR4gasUaNLuurMFnzYNwhiXaln9zIgXXYZCaxfTPOn3jzgnP16I4NV8+X8uQhgWB5ccMd+KYXr2qUx7IWOsqgJxsW9of6qG6ueywkHWD68CaxijMVntydmf3Kulz81ugQ17Jb7LfVj6cvCiUBJpFekF56zp8zrCnOELOqlltIE1wQ0uRsWlGq210JBzf9fPgVqquls8mpNOGfj4KUcowpblWiBDovzf5AszxMRaS6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBNfDh+2rbC7KG1PO38BnOGuwj8LuGBYWC9qdEiU/Vs=;
 b=TvJ7nkCrhjCIPNfhEYWfEPGtzOAZgziTUWrC3g+RUsXdKSOuiycCv3ePUj1UCHtdZvon1w3btGnF1q33xDM5HEajPouzxMeOMwArUsbI9Oa0GGkulFyPQFsnhranV+oSeSwjKLDmPAuAYg6AWJRnPK7+XVzsuxbP8n4CQX3+zU/ZkRbNmCoyWQzgXMzC+v7bBz9N/IEzU252Mqhzk6EYDcqUTZEc7aslTFMnBHJxl6EAbDRuBD2ww8ItGGwP3q+paRqpQbmXcUEYMUFlu3JzNeWcU7txVH7XydEbfnPxlLXs0s5GTjBwt//gSuMvDfZXRPB4BTEdF8zXEQrz8c66Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBNfDh+2rbC7KG1PO38BnOGuwj8LuGBYWC9qdEiU/Vs=;
 b=EK2j8FmYhvjy6/aD68FLMDaqdbVHJ/ZVkUEEBUSP7sqxiK26+4qSxzH8WizGSvMstXp2Ua86IVe8YjGJ10nctb+m43GIOpCTK4fTusC1JLGb3l90ZSskE9/FSV6F//II0/ll5yRyqJCVFIK9DlzcNPVXOaeWjux6+gmigsppp8c=
Received: from BN7PR02CA0011.namprd02.prod.outlook.com (2603:10b6:408:20::24)
 by MWHPR12MB1837.namprd12.prod.outlook.com (2603:10b6:300:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 23:06:18 +0000
Received: from DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::95) by BN7PR02CA0011.outlook.office365.com
 (2603:10b6:408:20::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.21 via Frontend
 Transport; Mon, 20 Jun 2022 23:06:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT029.mail.protection.outlook.com (10.13.173.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:06:17 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:06:15 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 18/49] crypto: ccp: Provide APIs to query extended attestation report
Date:   Mon, 20 Jun 2022 23:06:06 +0000
Message-ID: <afae5980fd4adf52932a9d639a0b0bfe83255c0a.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dc03e35-0198-4071-ff0f-08da53117b4c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1837:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB183714CC043FFD6E6AF618968EB09@MWHPR12MB1837.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p3anTE3ZuqT5hLAY3gLH/ADxa7gVFC+KKXqbLW+rdsV21cUWfJIN8KtQZlc2fyfnK6LQOfRXBzibsRXgA94LXi3AqU41wbSB9p1o+bkGEJzRwLFlBjfvFR888xKxMVQVxgDNM27UGFW8yaeSthn4V66vzSR0dcH2BAgf6hUpmQ0VsaSIwEmq70qvrZYDCVWKxSEUZJ+SAod4hCyzuhDIw4Fxmq9IhRdnGDEKsoFNOnh6dtxOjYFoS0zhIK474FM1HtXYH+oJZeA6SPlHw2Rw7vFXXHoVJjqhAX6SqIhSAdu0z0zKygUUqUTcSUeSjJnRemuc2dLmb9oXt5o52mXtcc3/S0nmRehwaKyzaiYCvbcdZ4gBeITAdJM958eozqO0syXtkeMPIcmtEKFIby0SatG5433JgoDYzOFkJuE47xuvzYz7fcN3QAm6BMTPx4ChJydwl/yWSAWjTQwZY9xbpGJYvNv1gZS4Q1XRjnMjhFGPqDMOLfDjaZL2IN4ih9o5K6GK9cdphiy4nV4WyY6BJoM7HPgtRBZkhenpeUqrOPjPWzjl1XVyY1iaPo30JWu6xCD36p8FV0T+/HmkO9HZI6NYxeuKgDoYjorAIlqo2G9OzuAEgxWxx+xPbauSik1cHl1SjCirQFrJEwgPx977SGkXTfck4w56B2X/IqoYa2smBF5zF8a/rIzasJC5RMGDf/ZlFVEfDRNTD1pBIN9LVXf6fIQLRDtiLzE+0ChjAmsLA/lgD+VtRh31k4FqU99k63GjPe+CNfGJlFfunKHumQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966006)(40470700004)(36840700001)(8936002)(4326008)(478600001)(70206006)(8676002)(36860700001)(70586007)(40480700001)(7406005)(54906003)(86362001)(110136005)(41300700001)(186003)(36756003)(16526019)(316002)(82740400003)(2616005)(83380400001)(47076005)(426003)(81166007)(5660300002)(6666004)(336012)(7696005)(40460700003)(356005)(82310400005)(7416002)(26005)(2906002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:06:17.3602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc03e35-0198-4071-ff0f-08da53117b4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1837
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
 include/linux/psp-sev.h      | 24 ++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 97b479d5aa86..f6306b820b86 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 
 #include <asm/smp.h>
+#include <asm/sev.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -1857,6 +1858,48 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)
 }
 EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);
 
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
+	if (!sev->snp_inited)
+		return -EINVAL;
+
+	/*
+	 * Check if there is enough space to copy the certificate chain. Otherwise
+	 * return ERROR code defined in the GHCB specification.
+	 */
+	expected_npages = sev->snp_certs_len >> PAGE_SHIFT;
+	if (*npages < expected_npages) {
+		*npages = expected_npages;
+		*fw_err = SNP_GUEST_REQ_INVALID_LEN;
+		return -EINVAL;
+	}
+
+	rc = sev_do_cmd(SEV_CMD_SNP_GUEST_REQUEST, data, (int *)&fw_err);
+	if (rc)
+		return rc;
+
+	/* Copy the certificate blob */
+	if (sev->snp_certs_data) {
+		*npages = expected_npages;
+		memcpy((void *)vaddr, sev->snp_certs_data, *npages << PAGE_SHIFT);
+	} else {
+		*npages = 0;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(snp_guest_ext_guest_request);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index a3bb792bb842..cd37ccd1fa1f 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -945,6 +945,23 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
 
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
+ */
+int snp_guest_ext_guest_request(struct sev_data_snp_guest_request *data,
+				unsigned long vaddr, unsigned long *npages,
+				unsigned long *error);
+
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
 static inline int
@@ -992,6 +1009,13 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
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

