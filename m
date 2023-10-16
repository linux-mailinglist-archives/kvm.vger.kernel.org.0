Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54597CA98E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbjJPNd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjJPNdq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:33:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B006115;
        Mon, 16 Oct 2023 06:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PAi2buTiq+H/izJ5fTh9M/590/HAlqHbRsPLPVoHoFsuqHMpdJvFCNeJKMXgUzVeEnl3ex0RmtnV2bfRJ2JAXEGLxVLBWAS5kow2dEOniO++UYTYfIpaKCwk/R3nybC4/bz9BMYUXt7TLVPUtTVi4aZg8McoSTsXFTFCqjxfWnvoP8XXWEwR7Q/3fuRz7AGNUzf+XmJViN1ufEpmTXThR0ZCcfqAw+4jNoSD7FZgcqR9gcLWPLQ6Y7RF84v5cdag7j0nV7HH2g+ygFkYvuUQWBxNrmCmSLlE8aO5zVS80F4FJokCaDBJmDYTgkpC/jyKUgdw+XZN5s63X0j+oNZThg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXcQILof/l/QK7fWQXg1rZMQQPkO2ffgeXV/f0lvuGE=;
 b=dOlrx26Lz/9XO/jh9T3olTyLeX45bHVRdbFRj7HLuwaJs8a+qGzDZuPd3JcbAanKuizmbR/AXzpqkLVob+9C8T5CCa9Zmo2ZQmx0Siu6KSNxFHcfj1yTi9fDx36k27LMWbhfKGxYwuWE5fiC7anI0q5/sKKBxaOt+iq8UEtN/P6kXJ6iWFUImaW9+Na0v7GaHN6CCvI5Ld33XYLyfseF+hbNddUHZA4CUyiSuq0dNlWN+j8BtjlmnlDyWfgEWxYqPk2sp7OW2KLaXFv9bt5YKAXL1epXV9ZAJ6bquxHBHuP0NMDmwDw7UkOigQASq7EDWUNJsOVaEmoTUiDIpBM2ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXcQILof/l/QK7fWQXg1rZMQQPkO2ffgeXV/f0lvuGE=;
 b=UQ+m/DXReuJWwVnSZqfEaxaaS/DT4PGmu4UtpHyYuygWqsRJAzl55pd2kOO++G5X6wKYGE/2mWfuXtbQQh0kBchiuqaqnUKVQwbRgDPV7FM/tX30wJEjleAoYT/nF4Ur5k/eJBPiQoXNDdNtskZv9k6S8Sk6iPvkJIormAUzujM=
Received: from BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30)
 by BN9PR12MB5353.namprd12.prod.outlook.com (2603:10b6:408:102::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 13:33:41 +0000
Received: from MWH0EPF000989E9.namprd02.prod.outlook.com
 (2603:10b6:a03:14b:cafe::49) by BYAPR06CA0053.outlook.office365.com
 (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.30 via Frontend
 Transport; Mon, 16 Oct 2023 13:33:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E9.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:33:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:33:39 -0500
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
Subject: [PATCH v10 19/50] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date:   Mon, 16 Oct 2023 08:27:48 -0500
Message-ID: <20231016132819.1002933-20-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E9:EE_|BN9PR12MB5353:EE_
X-MS-Office365-Filtering-Correlation-Id: d08bd776-4bdd-4783-3ec1-08dbce4c82bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k5ni9QG62QhO6o74mEm1Gp7OruyYUd2gjPYuuqRf9ZEDMmQJpDFu46Ld+6oHdKATJw5G0qM040mtNevV23pecK8eq426fEgEC0DBeEzchndd0QaIKUb2FPhCDvdsEVLJuPdnUBOSWCafXVoujCkFv3vix25i/lvXyN3WCL2N7MeQWPg/aW/Mdg3Ccpk9niKgyDr5zxgZOX5F/UT17RrF2sR7MidzgfS/AfdkUwphXvl7E53eRhraAxmJBXX3RVZGdPj60P51ZhyEwhz8chRVJfz8+x/FwWIeJWhf0EdcQnOFxnOZZnd4NSuEZul4c3UeuONhq8+6iwHJD7QHgr31LvgUVG6AUWv2wBvZ7YUsnjJBAEKY9bOxxuWXVP7pBoOgdC3DaFh31d467fPFTzEF2cxEEFuAPAYVx8LTpCFNd4jV7iZjcyvL28RVAa0npzMV7PQM1KifRDrsgHXhDKHfQyCCsKs3h0wrolbO23vcv+MWQVYdwZhWnD0Ux0t9XPSJ/ROh1sUyvtUh4wADNFo00k68u4mVGqdipq4SEVRYxmlXM75wCcCfOs+F5xiGPpqjuCdtHSCJwNFESej65QseaLN7RiB2zsgx8JZqGoPNbt9XlSlVs9g1xNSxy6Djud7evNrnoiI/c+5YOgXWEQ4DD1npyP9zUQZv4XKz63mr7hCEndDdVprkoWgU024n0vsXC9LCEFyWPEepQA9QP+2EazMdbuolBInzX1M9kG59njGTAvowAODlmr9zVJBGZQS1X7kHVARFiYFbEquFZKlQyg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(136003)(396003)(230922051799003)(451199024)(82310400011)(64100799003)(186009)(1800799009)(36840700001)(40470700004)(46966006)(40460700003)(40480700001)(82740400003)(356005)(36756003)(47076005)(36860700001)(83380400001)(6666004)(16526019)(26005)(70586007)(70206006)(6916009)(54906003)(316002)(478600001)(2616005)(1076003)(426003)(336012)(41300700001)(44832011)(7416002)(7406005)(81166007)(86362001)(2906002)(5660300002)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:33:40.7705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d08bd776-4bdd-4783-3ec1-08dbce4c82bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5353
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
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
---
 Documentation/virt/coco/sev-guest.rst | 27 ++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 45 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 3 files changed, 73 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 68b0d2363af8..e828c5326936 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -67,6 +67,22 @@ counter (e.g. counter overflow), then -EIO will be returned.
                 };
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
 
@@ -124,6 +140,17 @@ be updated with the expected value.
 
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
index b574b0ef2b1f..679b8d6fc09a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1772,6 +1772,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -1823,6 +1865,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
index 48e3ef91559c..b94b3687edbb 100644
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

