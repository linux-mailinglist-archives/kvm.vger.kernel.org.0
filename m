Return-Path: <kvm+bounces-5360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3774782075A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC26E1F21ECB
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248BB15491;
	Sat, 30 Dec 2023 16:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wsJVXz4G"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77FA156E4;
	Sat, 30 Dec 2023 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmM+A61qSXMJdZjfqamIWL+zpgtpsMsWbcPMHSJ2nB9/IlDQ7iY2k6gqNoy9ntnBfDBkUg6aj3a6+31/Qy+kDwbMrRbdkuIsO4+zVLFk6CezyzNccqS1DRa5h/fkk19tWBR0wZvwWPpvAxUAeyOL4Bf5UHgmCgo+zNh6A+vA39o8h8AviKxtsNIAj8DH1fdPFVkCbcQOaMos8eYelSKABjGqVa9ZunJuP9yPAjeKDih+39X5UVXmSd+f9TdXACDNXWlKf2Uj7hXeETkMktVGW5zRrSPHdukxxqysB0DVb8uPmbyp4TvMFrEow9AdG3i1M27N2IMW6yH0VpDoG1dAIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC882HahkUuPDg43NBnsT5u8DchdzXWMhXsoEAnYflE=;
 b=ik5RaV9dBC5ar/u9ZzxT8khroESMJVhxuN8/P3njGD8fbddEe8mGejsbZY71m/bE6qcG1zzc+RB+kvmF/qVC5Ovw5h98c2WcrzhFUHjAzEj2uOR9+4CSbpIn8wJMgC+KhTtCty5cyrfyab1xNBJYq8pDUEOGznwwOt1H3A7fqj+XrrnnJZM9idtGtxGRUGn0c9BOgA/ePl7ROTzkTLeHOitiZBlZbgmreD0TtwQTBm7G0ROnlJydi7ozH5zDAB5nzHD3v9kZ85sbnpcJghZJ9iX84sPtLDVh2dvzxd7ZqCBKJdWI+lvJozE4Iio9yg4A+JU6I8w+go9j0eJ+mCPVsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZC882HahkUuPDg43NBnsT5u8DchdzXWMhXsoEAnYflE=;
 b=wsJVXz4GgykaSVYhR5FeXgpK5ouBDIpPCJkZ1hp50DMO/8brLMSp/kSgEhG8OEUuTraFrgeJ0lr5HRxbNrYo9upwNYbslo1yVVROJOgChyLc1SCBA9glSAKIVQCjn/xXIJkS0sR6srqPe2vuzmxWblcsUthsPOz0dmm3cQwTlb8=
Received: from DS7PR03CA0341.namprd03.prod.outlook.com (2603:10b6:8:55::23) by
 CH0PR12MB8486.namprd12.prod.outlook.com (2603:10b6:610:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:27:19 +0000
Received: from DS1PEPF0001709B.namprd05.prod.outlook.com
 (2603:10b6:8:55:cafe::53) by DS7PR03CA0341.outlook.office365.com
 (2603:10b6:8:55::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:27:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0001709B.mail.protection.outlook.com (10.167.18.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:27:19 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:27:19 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v1 24/26] crypto: ccp: Add the SNP_PLATFORM_STATUS command
Date: Sat, 30 Dec 2023 10:19:52 -0600
Message-ID: <20231230161954.569267-25-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230161954.569267-1-michael.roth@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709B:EE_|CH0PR12MB8486:EE_
X-MS-Office365-Filtering-Correlation-Id: a470a868-98e7-4700-57db-08dc095431c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YD3dx5NMv+p7pFkVtHnzIwYftRGjH76FJOEEHr96t6IDyF7Umi0CcvEOhNn9JyG/NWnewLdmSw5GGfdCfZP/ZwutQ4mS7XWDbCVklmifmHU/eywEKOlx3aK1GWBLKAKqG5sncKgh43DQOdYwDIR+GUY6uaiPgHlblFY5DTRq7RUPmVZR14v0hylxebfh2kQMkZrV8pOBzGfbByxE/RBetsqn4FSFHKQHBXZh2/6cpGwJ9IzMpGcZ8Vpjkj0DCQV2RkmsmUG/oedKoMl+E4utbjJt39ZiMCdMHe8cR9nLZ6GGqwakt3keD0upiDOusb5bQqoOpXST9RckCw5hkhq6bw4d69Q33Q0K6kHNzOres4Y+sSCQ5xnyjFE27RWWNCA0rc01nVGEBA4H+kkcsl7K1XD+PQ+kU0QCxjzYCqSvsfzqmYh503RVk3Ao7ih69SvjLMv4n+TXmPqBLZ3jy5Bk6CjzbqzZ26ntvHzTilHdJjmTSRTqriqh61wS105e9rAiE4Z5fO5jf1Ll2AOk3TLLrtV/UNPlAbThh59p0zEMfEtfNx6qratvDY6jcKnOywgQh0WpY3PAkYFHfx5lU8e4ZtTBd80xb5rZKra0TH4HqxIDLlSQencpxDfg/AVQgKH6VPr/Xl6BCHlzNiyl4X4mivat3CLUybDzreM7IblAq4yfhxknQ5VqzUof/s9mrRBG1Mp9wjTvmV39/aouyJxF1vTGPVV6GuY0dHQgEBfMNYarBUzgnMDDb0dwwLTmkYpbqWoKcZRYT6v9HWNLVUGhWw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(82310400011)(1800799012)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(2906002)(5660300002)(7406005)(7416002)(4326008)(8676002)(8936002)(44832011)(316002)(36756003)(54906003)(6916009)(86362001)(478600001)(40460700003)(40480700001)(41300700001)(6666004)(16526019)(1076003)(426003)(26005)(2616005)(336012)(356005)(83380400001)(81166007)(47076005)(70586007)(70206006)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:27:19.5643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a470a868-98e7-4700-57db-08dc095431c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8486

From: Brijesh Singh <brijesh.singh@amd.com>

This command is used to query the SNP platform status. See the SEV-SNP
spec for more details.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 27 ++++++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 45 +++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 3 files changed, 73 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 68b0d2363af8..6d3d5d336e5f 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -67,6 +67,22 @@ counter (e.g. counter overflow), then -EIO will be returned.
                 };
         };
 
+The host ioctls are issued to a file descriptor of the /dev/sev device.
+The ioctl accepts the command ID/input structure documented below.
+
+::
+        struct sev_issue_cmd {
+                /* Command ID */
+                __u32 cmd;
+
+                /* Command request structure */
+                __u64 data;
+
+                /* Firmware error code on failure (see psp-sev.h) */
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
+:Parameters (out): struct sev_user_data_snp_status
+:Returns (out): 0 on success, -negative on error
+
+The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
+status includes API major, minor version and more. See the SEV-SNP
+specification for further details.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 598878e760bc..e663175cfa44 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1962,6 +1962,48 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
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
+		ret = -EFAULT;
+		goto cleanup;
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
@@ -2013,6 +2055,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID2:
 		ret = sev_ioctl_do_get_id2(&input);
 		break;
+	case SNP_PLATFORM_STATUS:
+		ret = sev_ioctl_do_snp_platform_status(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 71ba5f9f90a8..1feba7d08099 100644
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


