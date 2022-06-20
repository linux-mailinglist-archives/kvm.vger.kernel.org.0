Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE055279C
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345548AbiFTXG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbiFTXGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:06:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF60E1EEDD;
        Mon, 20 Jun 2022 16:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1H8hhIAldWtNU/7o8YMsBOtZbAmxfMm7w4EcnQdg2V1zdfD42yQmFb5BSaT+m4tsru9WlC29FplmcOkr9J9zgTSxMFy4wbSH9tWyC8BBcjtJxk7QzP/bv0jrlY43c2Vsl65xsz/OCQbkFSTc26HnMYLZLQbY/z2CFm95Qe5W1NrPQwok1gglIUSluhZ3/YtL6IUwim0ls7ofjeDzJyAovin+1SDtd/WSlUDlbQfeetHkfgmJgIfdxtrPavn0QGerkQ/4HcYuOJArbkOy6qwf2mBLQngkWBdLWuLyFRa5NSgIR0f3Cb8E8+t+NAlfi5H08UFYwIinAr4kM9LhABOng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yv0nKBdWQw+T1EIoCqSvrFwqRDssw0EpQbhEDIYe7TA=;
 b=LoqgrMqm9OYgQz4GXgg24zpuE/SQL6JFK3BpL14vP/cZAK9aimn6hxgbQRGawDEd/0Lf+Zr/SKV7n2VpvZ0ZyRtgRfm+NDX4VoVQYACQnRjm03WeZ7ym+K8tvqGvs7EnmadAuuFQR5xxNz5ZqS5xSCg9lvPd6g19Sx5Nuvt+TuBhlnDP2kdCXRbRKs+3ECNKCCfsZk50q1xR8OTUQioAKyZRKe+CewvhUOcuzMw0J8JP71nwKbr5+8s6c866gD86z1meB/cW3f89SlY3WugCuVsBW1F6KwUxKbtwXIQafUmt519CaNjZZ3rI1eEDTfnzF00nqR2zh/eRXJfJbVrq6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yv0nKBdWQw+T1EIoCqSvrFwqRDssw0EpQbhEDIYe7TA=;
 b=JFdOxixIiLd3J2fWv2viMfyNNkf3Pgte2+5r65WkrvyoExyGcQ/MK5F2d6NfBiHuECgMaHsQcUrDOBuG815fquXmqmOAbQiHGDu0nQ4iFO9/lZjnd9AJUklarhKIW8xM74QReDbAc9Pgqa5fOSCkRa1N1EwHyi6EhlqmxeoWzQw=
Received: from BN0PR02CA0029.namprd02.prod.outlook.com (2603:10b6:408:e4::34)
 by DM6PR12MB2889.namprd12.prod.outlook.com (2603:10b6:5:18a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 23:05:46 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::93) by BN0PR02CA0029.outlook.office365.com
 (2603:10b6:408:e4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Mon, 20 Jun 2022 23:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:05:45 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:05:43 -0500
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
Subject: [PATCH Part2 v6 16/49] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date:   Mon, 20 Jun 2022 23:05:35 +0000
Message-ID: <218510ae39b529e19570c1af57bef86775e28c7e.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: b3cf6084-e0e1-4942-3802-08da53116883
X-MS-TrafficTypeDiagnostic: DM6PR12MB2889:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2889A911C83F9D2DC41A55F98EB09@DM6PR12MB2889.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rX3yr4pDyRrHDA3U1G6n6mRD3Z+qQ0BT37AJrkf+LTw73n3qgpKLigKQm7Z08hSaIh6dzV5tr10dX3PvWQCJ/OlbKjwihIHpMRfwVXmVLk6cojxFHPeGVgDLPNcoSTqQEDSjk1h7a7FI18IB8jz6ENw/xmbFcEBUIWRgrW6F64JpZJXGZgVru4YprArs0qsXhETnVW3PHK5hojQybVCn9wQNq6Mxx5FXYOMAnAwEoRTS36GPXnpKwpxtRE/PtOjABGmX1xFnXC6PQC7/2LrrBFFwR9fWq1cTAqlqEs0AWizkg+r/OcbXdhRHjsHxUn3KnnVpptbAz623oRN5M457xKl4rA9kQVouEn+M3UIsZ9xfFBf3C3j+0YoIv8ZzbzXgrGRvDw4V7JCD/cv/Hzvy5ZSDVQ+r1FGOzmnbRpmiP3zCsKpIYHUVqHTuzbkgtAGgOc38RuwzktRLhl9t/SzHAXfQSvIFZYF88N3ebMqSawhGLtu5ob01Cu6naQSg4j8DnsG+5Ruc3SS7zm8YSUacoFif7hX+0Lr+4QlNgr9fPGUF/0IzGgQmn899dQqash84mLrzuhYYMHaUF8gzu10uwtPyNHHrYQvFRMU4iBJq2i/dPTF3T/EKfvnMCpiguIv0JEai/FuKwkLo4iPO6aVw83EDcE4P7vOG+NNWd5D9NMYUDPrpLle/knYHjigTD3ACScEYEtDVs7hNgqEolOrP0SDkry2mWWNUzGbmy5AVndDMCVU4NX+be8h9IxLsTPwhak9g5H/o5EgyptI623UPSg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(136003)(396003)(36840700001)(40470700004)(46966006)(316002)(70206006)(2906002)(110136005)(8936002)(54906003)(5660300002)(86362001)(8676002)(7406005)(478600001)(36756003)(4326008)(26005)(41300700001)(70586007)(2616005)(336012)(47076005)(36860700001)(16526019)(7696005)(81166007)(40460700003)(83380400001)(82740400003)(82310400005)(7416002)(6666004)(40480700001)(426003)(356005)(186003)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:05:45.8232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cf6084-e0e1-4942-3802-08da53116883
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2889
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

The command can be used by the userspace to query the SNP platform status
report. See the SEV-SNP spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 Documentation/virt/coco/sevguest.rst | 27 +++++++++++++++++
 drivers/crypto/ccp/sev-dev.c         | 45 ++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h         |  1 +
 3 files changed, 73 insertions(+)

diff --git a/Documentation/virt/coco/sevguest.rst b/Documentation/virt/coco/sevguest.rst
index bf593e88cfd9..11ea67c944df 100644
--- a/Documentation/virt/coco/sevguest.rst
+++ b/Documentation/virt/coco/sevguest.rst
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
index 75f5c4ed9ac3..b9b6fab31a82 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1574,6 +1574,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_platform_status_buf buf;
+	struct page *status_page;
+	void *data;
+	int ret;
+
+	if (!sev->snp_inited || !argp->data)
+		return -EINVAL;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+	if (snp_set_rmp_state(__pa(data), 1, true, true, false)) {
+		__free_pages(status_page, 0);
+		return -EFAULT;
+	}
+
+	buf.status_paddr = __psp_pa(data);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+
+	/* Change the page state before accessing it */
+	if (snp_set_rmp_state(__pa(data), 1, false, true, true)) {
+		snp_leak_pages(__pa(data) >> PAGE_SHIFT, 1);
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
@@ -1625,6 +1667,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
index bed65a891223..ffd60e8b0a31 100644
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

