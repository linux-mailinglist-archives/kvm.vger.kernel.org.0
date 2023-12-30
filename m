Return-Path: <kvm+bounces-5347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D905C820731
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:23:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA4B3B21214
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1495F9CC;
	Sat, 30 Dec 2023 16:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sZNTNGKr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB71DDAA;
	Sat, 30 Dec 2023 16:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMvsXQxUEw5IufQuazpA83VBLx0sXgCzzlbNHLpJ7VQCYFRrri22/CL+dOatjDHNOTmUTiK16GTA9ruw0sPPjNPH2z52MkuDjOklEfTIKREQbpfDM4eLdT4FI4FT5/BTnOCQ4NWJqJod8wTU4m3lx929jUDvEtv5EX0GX1tShOF/JDtCFk8IYOAziZBrnuTBDPjyYp8U3+N94SFgOYt4n2MtNs1bdUTprSX16hTU/OpuX+u1BVrZ4+haiEMeReBhChpAawubHA5pANmjgV5TsUQGkVT60dXOoqwEPNaQ9qSiChJQByM8omzSfdyLlIwJSGodVteDZy92OUxP9kA1/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDcoaHHvBOj+Ex2Pg+Fvdwth5rQZK3cuLwAidF5zoMc=;
 b=j2g2D0qYNlHe8ccZcV3QIgVhsd852FFqm4LWTNOc/4+U324hbWlNKCIqI33G4Ex4iLsqF17aArGQvgT0/uY1dfmiAm1LJL/vr9qDvZUVffuxQrCF1W0gkScWgn5uLIrmebityCMRorLhEh7zj2V32zQ1cM/Tq4Im2GefiyIZyJYgc5Jk/wKspG9jjLON6V8xrW4BZh0vClBPSeET7IHM5M01kQbUI3iNNyIFkrv6GvFIGnSlZYib/qJEnSWxmdgSC/gR9Oh0RUYc8zuoPBllYcA72i8DhJzZuv0949fSb5nkAKw7IaSndri8deUCHUEE3Gl65yRl0cOvkPrpf6arNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDcoaHHvBOj+Ex2Pg+Fvdwth5rQZK3cuLwAidF5zoMc=;
 b=sZNTNGKrwXdBU1ccdT5YLX1yiUQWXmbxoiBHScOYE2vGnFJTsBQ08UD83HZ5teVK7VK1IB+dZpmnHDjAc4DlfEZd6nxIMaMlKC+S/TujLsXm33Re3LOKgdAHpOMV5VTUCdONon8SFOnAVnMgP5qZRzAZs4x+Ulgji3H4mdq4K7g=
Received: from CH5P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::9)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:22:49 +0000
Received: from DS3PEPF000099DD.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::a5) by CH5P221CA0015.outlook.office365.com
 (2603:10b6:610:1f2::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 16:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DD.mail.protection.outlook.com (10.167.17.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:22:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:22:48 -0600
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
Subject: [PATCH v1 12/26] crypto: ccp: Define the SEV-SNP commands
Date: Sat, 30 Dec 2023 10:19:40 -0600
Message-ID: <20231230161954.569267-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DD:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 0355c0b9-a5b5-414f-1f3c-08dc09539072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Aa1gb0ZnIKbl7Ba6RVfbzpbW3/pI+zh7DPXpHSa7lsEmuTou8eNEWLFjo7kEVThEuXHneDeEw7yQ+tA+UhB5w9XPHtVFcUJ9Ett3g0bWE/bv+qgoQZRAx6LTzn3kjzza6uuYm0/p3AHos3urNH/nh21SN0hd6cV0v3dYB5iDqGHbRvQLrSafSsQrY0M3sn+FY2FiTRat7CmZvDz0Yo2BI+rbTZwGoGEixBx8/sfT0j1M9r25iT1McodSpcmy/OgxdM5LMxpUxwYjxYC/rI5UxLgkpA3oX/Cw8ozQEin/ZixCDD8z+BGlRTz2HQutg5DkkScFmXhU1v/dyguAqLDm1o73WGRnpJAalui2Zw/PGqa2dlZldYpaDQY8bo0TenW44EoOKrfKVlQOyeZa5a1BoYnjX+58pEWVo0cTUYcCWnLXXKI3imr6ScxxPjjQ5xfinvcTKiHL7dOhr++a07OZvhNXZ0ZVYcfZVd63yIyHPCTSi47f45A37ZgcxDqhnT+ITIGLvd9Iz+Bm2SNp5a9TKBsDceS3E2AN9zG/ALRizHLsCyy7/MxP+mke2KlK1OwjGsyi0xE3X+jBi8cfw8rofyMbxEIbDl0DW9QAhlokqZKZajkDr/qya+zig+ksn+DFOiAl5K4Y24e2ow/rJfKPQ9plkvp5sEnUbvJgryZe7USndqTjowuEiYhV6CLAGfbeqAGY/4AWEluUO5omCpl6Q3dsVC1pPJqlAisfMN8AGihTCeALToer0C4vxRvjlx/4xAOPW3uhFT7rK8SRwxa1Zg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(186009)(1800799012)(64100799003)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(36860700001)(478600001)(40460700003)(41300700001)(82740400003)(44832011)(356005)(6916009)(36756003)(4326008)(86362001)(316002)(54906003)(81166007)(70206006)(70586007)(6666004)(47076005)(336012)(426003)(16526019)(84970400001)(26005)(1076003)(40480700001)(83380400001)(8676002)(8936002)(2616005)(2906002)(5660300002)(30864003)(7416002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:22:48.9320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0355c0b9-a5b5-414f-1f3c-08dc09539072
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128

From: Brijesh Singh <brijesh.singh@amd.com>

AMD introduced the next generation of SEV called SEV-SNP (Secure Nested
Paging). SEV-SNP builds upon existing SEV and SEV-ES functionality
while adding new hardware security protection.

Define the commands and structures used to communicate with the AMD-SP
when creating and managing the SEV-SNP guests. The SEV-SNP firmware spec
is available at developer.amd.com/sev.

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
[mdr: update SNP command list and SNP status struct based on current
      spec, use C99 flexible arrays, fix kernel-doc issues]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c |  16 +++
 include/linux/psp-sev.h      | 264 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h |  56 ++++++++
 3 files changed, 336 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fcaccd0b5a65..b2672234f386 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -130,6 +130,8 @@ static int sev_cmd_buffer_len(int cmd)
 	switch (cmd) {
 	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
 	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
+	case SEV_CMD_SNP_SHUTDOWN_EX:		return sizeof(struct sev_data_snp_shutdown_ex);
+	case SEV_CMD_SNP_INIT_EX:		return sizeof(struct sev_data_snp_init_ex);
 	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
 	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
 	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
@@ -158,6 +160,20 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
 	case SEV_CMD_SEND_CANCEL:		return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_SNP_GCTX_CREATE:		return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_LAUNCH_START:		return sizeof(struct sev_data_snp_launch_start);
+	case SEV_CMD_SNP_LAUNCH_UPDATE:		return sizeof(struct sev_data_snp_launch_update);
+	case SEV_CMD_SNP_ACTIVATE:		return sizeof(struct sev_data_snp_activate);
+	case SEV_CMD_SNP_DECOMMISSION:		return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_PAGE_RECLAIM:		return sizeof(struct sev_data_snp_page_reclaim);
+	case SEV_CMD_SNP_GUEST_STATUS:		return sizeof(struct sev_data_snp_guest_status);
+	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
+	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
+	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
+	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
+	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 7fd17e82bab4..983d314b5ff5 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -78,6 +78,36 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* SNP specific commands */
+	SEV_CMD_SNP_INIT		= 0x081,
+	SEV_CMD_SNP_SHUTDOWN		= 0x082,
+	SEV_CMD_SNP_PLATFORM_STATUS	= 0x083,
+	SEV_CMD_SNP_DF_FLUSH		= 0x084,
+	SEV_CMD_SNP_INIT_EX		= 0x085,
+	SEV_CMD_SNP_SHUTDOWN_EX		= 0x086,
+	SEV_CMD_SNP_DECOMMISSION	= 0x090,
+	SEV_CMD_SNP_ACTIVATE		= 0x091,
+	SEV_CMD_SNP_GUEST_STATUS	= 0x092,
+	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
+	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
+	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
+	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
+	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
+	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
+	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
+	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
+	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
+	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
+	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
+	SEV_CMD_SNP_PAGE_MD_INIT	= 0x0C3,
+	SEV_CMD_SNP_PAGE_SET_STATE	= 0x0C6,
+	SEV_CMD_SNP_PAGE_RECLAIM	= 0x0C7,
+	SEV_CMD_SNP_PAGE_UNSMASH	= 0x0C8,
+	SEV_CMD_SNP_CONFIG		= 0x0C9,
+	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX	= 0x0CA,
+	SEV_CMD_SNP_COMMIT		= 0x0CB,
+	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
+
 	SEV_CMD_MAX,
 };
 
@@ -523,6 +553,240 @@ struct sev_data_attestation_report {
 	u32 len;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
+ *
+ * @address: physical address of firmware image
+ * @len: len of the firmware image
+ */
+struct sev_data_snp_download_firmware {
+	u64 address;				/* In */
+	u32 len;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_activate - SNP_ACTIVATE command params
+ *
+ * @gctx_paddr: system physical address guest context page
+ * @asid: ASID to bind to the guest
+ */
+struct sev_data_snp_activate {
+	u64 gctx_paddr;				/* In */
+	u32 asid;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_addr - generic SNP command params
+ *
+ * @gctx_paddr: system physical address guest context page
+ */
+struct sev_data_snp_addr {
+	u64 gctx_paddr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @policy: guest policy
+ * @ma_gctx_paddr: system physical address of migration agent
+ * @ma_en: the guest is associated with a migration agent
+ * @imi_en: launch flow is launching an Incoming Migration Image for the
+ *	purpose of guest-assisted migration.
+ * @rsvd: reserved
+ * @gosvw: guest OS-visible workarounds, as defined by hypervisor
+ */
+struct sev_data_snp_launch_start {
+	u64 gctx_paddr;				/* In */
+	u64 policy;				/* In */
+	u64 ma_gctx_paddr;			/* In */
+	u32 ma_en:1;				/* In */
+	u32 imi_en:1;				/* In */
+	u32 rsvd:30;
+	u8 gosvw[16];				/* In */
+} __packed;
+
+/* SNP support page type */
+enum {
+	SNP_PAGE_TYPE_NORMAL		= 0x1,
+	SNP_PAGE_TYPE_VMSA		= 0x2,
+	SNP_PAGE_TYPE_ZERO		= 0x3,
+	SNP_PAGE_TYPE_UNMEASURED	= 0x4,
+	SNP_PAGE_TYPE_SECRET		= 0x5,
+	SNP_PAGE_TYPE_CPUID		= 0x6,
+
+	SNP_PAGE_TYPE_MAX
+};
+
+/**
+ * struct sev_data_snp_launch_update - SNP_LAUNCH_UPDATE command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @page_size: page size 0 indicates 4K and 1 indicates 2MB page
+ * @page_type: encoded page type
+ * @imi_page: indicates that this page is part of the IMI of the guest
+ * @rsvd: reserved
+ * @rsvd2: reserved
+ * @address: system physical address of destination page to encrypt
+ * @rsvd3: reserved
+ * @vmpl1_perms: VMPL permission mask for VMPL1
+ * @vmpl2_perms: VMPL permission mask for VMPL2
+ * @vmpl3_perms: VMPL permission mask for VMPL3
+ * @rsvd4: reserved
+ */
+struct sev_data_snp_launch_update {
+	u64 gctx_paddr;				/* In */
+	u32 page_size:1;			/* In */
+	u32 page_type:3;			/* In */
+	u32 imi_page:1;				/* In */
+	u32 rsvd:27;
+	u32 rsvd2;
+	u64 address;				/* In */
+	u32 rsvd3:8;
+	u32 vmpl1_perms:8;			/* In */
+	u32 vmpl2_perms:8;			/* In */
+	u32 vmpl3_perms:8;			/* In */
+	u32 rsvd4;
+} __packed;
+
+/**
+ * struct sev_data_snp_launch_finish - SNP_LAUNCH_FINISH command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @id_block_paddr: system physical address of ID block
+ * @id_auth_paddr: system physical address of ID block authentication structure
+ * @id_block_en: indicates whether ID block is present
+ * @auth_key_en: indicates whether author key is present in authentication structure
+ * @rsvd: reserved
+ * @host_data: host-supplied data for guest, not interpreted by firmware
+ */
+struct sev_data_snp_launch_finish {
+	u64 gctx_paddr;
+	u64 id_block_paddr;
+	u64 id_auth_paddr;
+	u8 id_block_en:1;
+	u8 auth_key_en:1;
+	u64 rsvd:62;
+	u8 host_data[32];
+} __packed;
+
+/**
+ * struct sev_data_snp_guest_status - SNP_GUEST_STATUS command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @address: system physical address of guest status page
+ */
+struct sev_data_snp_guest_status {
+	u64 gctx_paddr;
+	u64 address;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_reclaim - SNP_PAGE_RECLAIM command params
+ *
+ * @paddr: system physical address of page to be claimed. The 0th bit
+ *	in the address indicates the page size. 0h indicates 4 kB and
+ *	1h indicates 2 MB page.
+ */
+struct sev_data_snp_page_reclaim {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_page_unsmash - SNP_PAGE_UNSMASH command params
+ *
+ * @paddr: system physical address of page to be unsmashed. The 0th bit
+ *	in the address indicates the page size. 0h indicates 4 kB and
+ *	1h indicates 2 MB page.
+ */
+struct sev_data_snp_page_unsmash {
+	u64 paddr;
+} __packed;
+
+/**
+ * struct sev_data_snp_dbg - DBG_ENCRYPT/DBG_DECRYPT command parameters
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @src_addr: source address of data to operate on
+ * @dst_addr: destination address of data to operate on
+ */
+struct sev_data_snp_dbg {
+	u64 gctx_paddr;				/* In */
+	u64 src_addr;				/* In */
+	u64 dst_addr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_guest_request - SNP_GUEST_REQUEST command params
+ *
+ * @gctx_paddr: system physical address of guest context page
+ * @req_paddr: system physical address of request page
+ * @res_paddr: system physical address of response page
+ */
+struct sev_data_snp_guest_request {
+	u64 gctx_paddr;				/* In */
+	u64 req_paddr;				/* In */
+	u64 res_paddr;				/* In */
+} __packed;
+
+/**
+ * struct sev_data_snp_init_ex - SNP_INIT_EX structure
+ *
+ * @init_rmp: indicate that the RMP should be initialized.
+ * @list_paddr_en: indicate that list_paddr is valid
+ * @rsvd: reserved
+ * @rsvd1: reserved
+ * @list_paddr: system physical address of range list
+ * @rsvd2: reserved
+ */
+struct sev_data_snp_init_ex {
+	u32 init_rmp:1;
+	u32 list_paddr_en:1;
+	u32 rsvd:30;
+	u32 rsvd1;
+	u64 list_paddr;
+	u8  rsvd2[48];
+} __packed;
+
+/**
+ * struct sev_data_range - RANGE structure
+ *
+ * @base: system physical address of first byte of range
+ * @page_count: number of 4KB pages in this range
+ * @rsvd: reserved
+ */
+struct sev_data_range {
+	u64 base;
+	u32 page_count;
+	u32 rsvd;
+} __packed;
+
+/**
+ * struct sev_data_range_list - RANGE_LIST structure
+ *
+ * @num_elements: number of elements in RANGE_ARRAY
+ * @rsvd: reserved
+ * @ranges: array of num_elements of type RANGE
+ */
+struct sev_data_range_list {
+	u32 num_elements;
+	u32 rsvd;
+	struct sev_data_range ranges[];
+} __packed;
+
+/**
+ * struct sev_data_snp_shutdown_ex - SNP_SHUTDOWN_EX structure
+ *
+ * @length: len of the command buffer read by the PSP
+ * @iommu_snp_shutdown: Disable enforcement of SNP in the IOMMU
+ * @rsvd1: reserved
+ */
+struct sev_data_snp_shutdown_ex {
+	u32 length;
+	u32 iommu_snp_shutdown:1;
+	u32 rsvd1:31;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index b44ba7dcdefc..71ba5f9f90a8 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -69,6 +69,12 @@ typedef enum {
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
 	SEV_RET_INVALID_KEY = 0x27,
+	SEV_RET_INVALID_PAGE_SIZE,
+	SEV_RET_INVALID_PAGE_STATE,
+	SEV_RET_INVALID_MDATA_ENTRY,
+	SEV_RET_INVALID_PAGE_OWNER,
+	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
+	SEV_RET_RMP_INIT_REQUIRED,
 	SEV_RET_MAX,
 } sev_ret_code;
 
@@ -155,6 +161,56 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __packed;
 
+/**
+ * struct sev_user_data_snp_status - SNP status
+ *
+ * @api_major: API major version
+ * @api_minor: API minor version
+ * @state: current platform state
+ * @is_rmp_initialized: whether RMP is initialized or not
+ * @rsvd: reserved
+ * @build_id: firmware build id for the API version
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @vlek_en: VLEK hashstick is loaded
+ * @rsvd1: reserved
+ * @guest_count: the number of guest currently managed by the firmware
+ * @current_tcb_version: current TCB version
+ * @reported_tcb_version: reported TCB version
+ */
+struct sev_user_data_snp_status {
+	__u8 api_major;			/* Out */
+	__u8 api_minor;			/* Out */
+	__u8 state;			/* Out */
+	__u8 is_rmp_initialized:1;	/* Out */
+	__u8 rsvd:7;
+	__u32 build_id;			/* Out */
+	__u32 mask_chip_id:1;		/* Out */
+	__u32 mask_chip_key:1;		/* Out */
+	__u32 vlek_en:1;		/* Out */
+	__u32 rsvd1:29;
+	__u32 guest_count;		/* Out */
+	__u64 current_tcb_version;	/* Out */
+	__u64 reported_tcb_version;	/* Out */
+} __packed;
+
+/**
+ * struct sev_user_data_snp_config - system wide configuration value for SNP.
+ *
+ * @reported_tcb: the TCB version to report in the guest attestation report.
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @rsvd: reserved
+ * @rsvd1: reserved
+ */
+struct sev_user_data_snp_config {
+	__u64 reported_tcb  ;   /* In */
+	__u32 mask_chip_id:1;   /* In */
+	__u32 mask_chip_key:1;  /* In */
+	__u32 rsvd:30;          /* In */
+	__u8 rsvd1[52];
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


