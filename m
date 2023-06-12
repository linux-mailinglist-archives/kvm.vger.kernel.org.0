Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C615372B67F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjFLEfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235235AbjFLEfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:35:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A9DFA;
        Sun, 11 Jun 2023 21:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQl1tdIjBibIEFuipN+aaTxMV2HbOsbS8Os/ymr3CFj2GR3isN90l5UOC1ER8OK3ebqzSRJyT6BV+AdHrG/Gy0OfZb6djpIw5GI/d2Ik4bajySzpnIfAXcXNtfLPbV6fOhJbHGL/U2NoyMh/8aEHq32OTW9XLtvHIg0nW+K3Z/3Wpk5jaRrg7f7lY1OzH/ycCKxwTv6cd214eWWyJtF+Pn9YvFgHevKYh7x5Tjkv7FAYOWMHmxhhInonPSoZ19FldaqdQ6QeXVK74nu1U4BTPZJavpXY5Q6x9XP9UqW/mTLZzD9z3rcS54f5Otoljnoq5sSFRvI+CY2IKNC2m4XUTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5PixqsA5QQA7A/TruSoyBOLJ81zSazDzW860FjASDM=;
 b=Vt6jpzBLv1fLwWoqkqmAUQ48nRmNkZM5WfBEORVTyqo/1CDxa/GnLgpzplAcXcTYSTfVPtvBrYuhbZGpJKDqknogICTMrgptEC39FH1wTZOCYCG8YQTgy0gBTnXHRZY53tBwKt1tjqwKfcerzkhbwXSg9U2H1qSfRQCGkY1D+QkhFSdj3wcJacV7RuoUN8JkrhpwmSzBpTgtcHsjpr/rhXWO2SHA3vxjPeQ3ImMuThhJbrlrSBTO5hogZKqBGMpajFK81YII7pRsXBZ5A5w1PNf2YA8VPtC8XKXnvflpMsdOWCWuvA/mU007Mko+P7Za+Bhj8rNNONy5hB//oyBNdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5PixqsA5QQA7A/TruSoyBOLJ81zSazDzW860FjASDM=;
 b=tvRLduvJeIPeBQi00OeM5XF2DKp//bfS7DSmDW6QverV7JVujMsh1uIM3tVuROwUxMn5IJOJckey94lQGzzjL9ehJsmWo7AIoT7PKx2c8qZyy2aUzIGUEgTIVhTetHZZ7pIbS/ZTCyBIfmwQ2qgt+b1bTAPZmV8MxL7b7vAOhHY=
Received: from DM6PR06CA0022.namprd06.prod.outlook.com (2603:10b6:5:120::35)
 by IA1PR12MB8264.namprd12.prod.outlook.com (2603:10b6:208:3f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 04:35:02 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::db) by DM6PR06CA0022.outlook.office365.com
 (2603:10b6:5:120::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:35:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 04:35:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:35:01 -0500
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
Subject: [PATCH RFC v9 22/51] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date:   Sun, 11 Jun 2023 23:25:30 -0500
Message-ID: <20230612042559.375660-23-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|IA1PR12MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: e5162c36-bd59-4262-029b-08db6afe633c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/nzRJqVhQegFZIFjd69mC9F6yvWmKohIrk/5lP+hGKK9DKXj1CQZxEj0Juf6Vq5uEnjlBtsxXjX3U6OrXcOrc/3s338NMCgHVdIKfGeYW9uSU1Wm2bbjCFpZGPacre19SJPpqHNsXPzNTbA82fPg0eAUrUczSilmZxUjqdj0q+4hoeK/FvER6JzTxCcZcM9A3GtmbQN8B+7ZqBHYwDubssca0oA37d9d2Ggakl8ptwxa9blznG6XN4YA9/eud/uWyps2078qpKJPv7BUVOMiqaJ+v1smTxbDyiCdSWgs8ETvNVD45EFfx18KlNo9/+3w47HJbNhsKzW+7+W/HD5HtfaCuG4v1pft72dgAIy2UPxPJF4Jp5MeIkaG/CElIsQra0Okul1/UNT5Xew3Eub2drOqw4uG2Qg5uManqT5oK51tWcr1AweI3TzwZqLaFdzdnMnxvlscvgGZJ17mEdlpJeSHlDu21qzUObv/kTPLGtDTHhSe2yAvIFfDAjjdeyF0NhDybsRH0IxSMKgxRywZ6HeepF9LWPVTjd2h7X70ozvICtrJAQR1nWWxZHNmfXL2aJ4dK/o2JpValyF1zFg8bn081GUAXDcVLK5GnpNUKg1O0xMsKPXuQowMNmbTQaBlRyBTBgwx3hEh68wp9e2cXS7rEOyvxqi0bj7porylowKT4Wd71d8bnGHWxkqkjD6effA96Kp1hKrH7JxG3NXVqK+8o2RnRJ0KuCMFk2vz98EHUoazo0XF2P2DrrvjSfNiFGwDErpC3rtgw6NS16+4w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(70586007)(70206006)(316002)(6666004)(4326008)(6916009)(478600001)(54906003)(36756003)(86362001)(47076005)(36860700001)(1076003)(26005)(426003)(336012)(16526019)(186003)(83380400001)(41300700001)(5660300002)(8936002)(8676002)(7416002)(44832011)(82310400005)(2906002)(40480700001)(7406005)(356005)(2616005)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:35:02.1078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5162c36-bd59-4262-029b-08db6afe633c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8264
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
index 10bb0a7dcfd6..0bfe9721c977 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1767,6 +1767,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -1818,6 +1860,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
index 7d8a2dd20273..4dc6a3e7b3d5 100644
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

