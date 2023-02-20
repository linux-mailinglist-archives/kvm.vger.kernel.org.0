Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F2769D342
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBTSvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjBTSvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:51:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF362195D;
        Mon, 20 Feb 2023 10:50:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7rUmFhUGWCoS0j2blag4pWFWPnTKKALKdu31EBSwXwhfL43Gwq7EbvG7z+qY5YbtUC5aqe/fcCQ3id3UjLwW4f7gq2KZkf2TlwYNibGZw3t+t5edpXJ3EJFM8lOIeIub+AQVQiENnh6i/PiDAgBfc1GKflSijpt6tWnCe1ui2dxTPfAGeMIImCiwUaBtjNlkwi39vZceD7YOcX3IXY/WRZUuFB5WOqTvXlkfUlpLb0nNhWNgDs/Ex71Jkww/z2zYZd93Tis4fZq+d5VTDlXHLVyDYYLqqOKYX5ZDmG9/6wCvRrRjbVswonfspq98N/h079C+gJGX2zxbSwIgM1i4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6nUTrm8qRU265S2b9i11RIXRilPZluYGpyCcCYUbZI=;
 b=DT55adSncfuYZAvNtwtsCK21oPfuqDUYbCh3hF3/OOibDkvA9YQdG5+Yv69tXNPj1JDKf/j8oRDucqcgTCugeHkaELAH/lxXtO5wJPQwsRLAVoFLf1JdhfKMZ/bvlpLuKJseT0kJLRamkIoOTqplT6uU7eu/wdpwFG0KKTRJP0KJGLdcufhelgweite5k46EtwB15omzTHQPGyuY0hTynyzZGNN6DTmlnkmq48ikSmamba7SIN1ixkyAOzEF4qTrJDPF4Wq5TqSjI691uC74yQTDBsA8RH1Po0C7b1/6C9ydJvUSjosZvxIE7LBxcv03hvpeAZcum34N4CKvSapjbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6nUTrm8qRU265S2b9i11RIXRilPZluYGpyCcCYUbZI=;
 b=myXUbkaGLcZZEp+GqoboL3oEnzYReDwkCGQfcwHZd0VSjOYIDIRGwUxyEJ4n49+qwTiwVl0ZrqgY1C+gMfjjlrPi7WG+SIVDSNLh0XgUMW+rMSEBtVnf/E+4eEo/mv9hNrDSpo/CQLjW9OD20cC+ehWQaU5ldsA1h5XgOp+0n3Q=
Received: from CY5PR16CA0020.namprd16.prod.outlook.com (2603:10b6:930:10::16)
 by CY8PR12MB8339.namprd12.prod.outlook.com (2603:10b6:930:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 18:49:50 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:10:cafe::bc) by CY5PR16CA0020.outlook.office365.com
 (2603:10b6:930:10::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20 via Frontend
 Transport; Mon, 20 Feb 2023 18:49:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:49:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:49:49 -0600
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
Subject: [PATCH RFC v8 26/56] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date:   Mon, 20 Feb 2023 12:38:17 -0600
Message-ID: <20230220183847.59159-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|CY8PR12MB8339:EE_
X-MS-Office365-Filtering-Correlation-Id: 572a6838-83f4-445f-5a8f-08db13733f35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4Pwn1EA8k8uQpJy4IQguQMuRi3vhQrKhjXkxXiY/voFmKskqwK5J2EA/gpYQEdd5CGnnh8ZRx9+iZ5IB8n8Sdapo4Z6RogYno4GSchyHn5SLhPPWqloAHA3ZAHUbY3Pe2dN4fblHhF9Nsm+zQla3FK+D5D4YtWYwcCmIuVOfrjQk4AhdEscXRKyMnQ1MrQ/fe9rFt2EAoPrLfbL4nDp5GBjvnBCKLgNalRLdvr84shbJ+lhncK54lCnDM9kZj6nuLiAOqkOsvpW+X1zXSqam1H+Glg2/updeSfPfHTfnaATQ69s2S0BwVN7hHcJNKK+1+GsPjhjZfISm2IeVmZkNNQ8BzIiwdaC4leprQH1dQLGiyBO7VJdJvTitWgA0UjEaob5a9Faxe+/ofU2gZrK8ti5JPVDTExerrqXZabCdqt7owLSjFhkDqvDf0ow7sZlIG+1L9H/FKXgb8sq0tffjjShmOTuykFJJNXCe2yYXBvohL6lULbHWTXnfLSxz7U0sEZTVCqgbfRCK5MuztqX825x9qDkKMSiIST69CLJeNvWW4dK0qFm/5kwWf2+20VMj9pSddFdFchQpgAl1uZamQPff/Tjyn0xO5HK3yAJYvxD+TY3SrNOnnHG3GQhZV4fLtyAqV1PrE96SEU8//yl+i0btj4nNY14QBryS1BadnIbp4NGdqW0cknd4uozOfGj+JvQKnnd++vK7dVqKeAxCJn1usAUcY57Ybi+8EFFiYA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199018)(46966006)(36840700001)(40470700004)(2906002)(26005)(186003)(41300700001)(356005)(16526019)(82740400003)(1076003)(6666004)(44832011)(81166007)(2616005)(7406005)(5660300002)(7416002)(8936002)(36860700001)(40460700003)(316002)(86362001)(70586007)(70206006)(8676002)(4326008)(6916009)(336012)(82310400005)(478600001)(426003)(40480700001)(47076005)(83380400001)(54906003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:49:50.4591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 572a6838-83f4-445f-5a8f-08db13733f35
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8339
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The command can be used by the userspace to query the SNP platform status
report. See the SEV-SNP spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 27 ++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 45 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 3 files changed, 73 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index bf593e88cfd9..11ea67c944df 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -61,6 +61,22 @@ counter (e.g. counter overflow), then -EIO will be returned.
                 __u64 fw_err;
         };
 
+The host ioctl should be called to /dev/sev device. The ioctl accepts command
+id and command input structure.
+
+::
+        struct sev_issue_cmd {
+                /* Command ID */
+                __u32 cmd;
+
+                /* Command request structure */
+                __u64 data;
+
+                /* firmware error code on failure (see psp-sev.h) */
+                __u32 error;
+        };
+
+
 2.1 SNP_GET_REPORT
 ------------------
 
@@ -118,6 +134,17 @@ be updated with the expected value.
 
 See GHCB specification for further detail on how to parse the certificate blob.
 
+2.4 SNP_PLATFORM_STATUS
+-----------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_data_snp_platform_status
+:Returns (out): 0 on success, -negative on error
+
+The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
+status includes API major, minor version and more. See the SEV-SNP
+specification for further details.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fd8893af6ed7..65e13a562f3b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1751,6 +1751,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_addr buf;
+	struct page *status_page;
+	void *data;
+	int ret;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+	if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
+		__free_pages(status_page, 0);
+		return -EFAULT;
+	}
+
+	buf.gctx_paddr = __psp_pa(data);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+
+	/* Change the page state before accessing it */
+	if (snp_reclaim_pages(__pa(data), 1, true)) {
+		snp_mark_pages_offline(__pa(data) >> PAGE_SHIFT, 1);
+		return -EFAULT;
+	}
+
+	if (ret)
+		goto cleanup;
+
+	if (copy_to_user((void __user *)argp->data, data,
+			 sizeof(struct sev_user_data_snp_status)))
+		ret = -EFAULT;
+
+cleanup:
+	__free_pages(status_page, 0);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -1802,6 +1844,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID2:
 		ret = sev_ioctl_do_get_id2(&input);
 		break;
+	case SNP_PLATFORM_STATUS:
+		ret = sev_ioctl_snp_platform_status(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index c66f7c372645..5adfaea7df97 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -28,6 +28,7 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SNP_PLATFORM_STATUS,
 
 	SEV_MAX,
 };
-- 
2.25.1

