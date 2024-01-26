Return-Path: <kvm+bounces-7060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F66783D399
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8EABA1F24C68
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F04C2FE;
	Fri, 26 Jan 2024 04:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OKvSFvVn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1F412E57;
	Fri, 26 Jan 2024 04:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244221; cv=fail; b=StVNFYx/wrtusTCMX7ViJH9bjhyFQgVI+iBx5aYseax9GeSOUNMO48a1hGnn91VUgrC+8wL9W55JYIhHXEfXfUSmpC3QvVAw6gIiiBr+uZ5OeD3rZquRP/i5nVnmX2e+gXudptdDhRA/QWXTDVgfE4EzFouU8LW/FTPoBphR4MA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244221; c=relaxed/simple;
	bh=saMGE6bdug/PGW0w0Emy6Su9nen7L9YcnAD/sElEGkQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElWUXG/hmKwPqDuEFAjdcNUmZ2z9aBX1/laNQtnWE3ZXrzOhBGa/N+TEiCfxWjjDA+t7ov6Qr8Z1tgofMTh1u8O6jT7ckeA1ZUxyNcLUsDPAkhU9f1Lif7wssFHYPYCHq37ZOHHEN9nSbtPs/ewDgtZ5TRnxxGYTO/6iaq0gvBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OKvSFvVn; arc=fail smtp.client-ip=40.107.220.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZju9EyRpQlWkrbNPzthYSmTDyDjjKPgkKhok7b3UV565n/SW6gCyBicC+dJZ79t6sBHF1r3+1qhvIwr2Lwvx9zc2rx5X9k6jGFPAv8jEhU4Y3PyW2SNDV5nY8A4oCZFqT162fBTXJ0NZED7PjYjb5SV0KI+sRjxxxwtFYZftA3LV9/n5cOQ2YVb5j8bI/FuxGOSrsKLDdoclxUkmGys63f5BT1lfHhH8jycXyu3hGDtPeS2aL/Sr5R8wlyAfqakmUIgT7qJCctNypS18LL+rId+60cj/1cSUWc8Mr1FV8TJ/ulSfkosXKBJNf5tU4HfeFITRFHbMOBcTZbA8UE/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12SpdQ0B6iDjFBVE/dIRbaDpCG3fJ02n914HbZOKUFs=;
 b=LejprowJvt7gKKRUb1VEfrSx9M7r4F6C0M1tAR3Awrjf+dw4ay3p3hNVH9pn7rFdfODZp0+sAQbXJ/XRd3SrJtiXOnYP6cMuv16cLopI+2w1d1Rro8oK0HD9afcqdNu90tvQ9Z5nhuMJYa2H132ihNZ7a3iTUC0w1RsFRY/sHPedWnt6o9Nd5Vrqx0PGQPYCnwqc9HwRUSPVYswpnWz5a/kq8qWKkEWvtJQOiU4f4HJr5qr2YlN4T2fenCb3r8i7tL9xVv08OK+VJ7ZSmeNdAuNxZFvCgo1n2f0P3Rh7tKukjRRGy5klnNARz4/LIEna57gsPSPuzuDxhylVzLz6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12SpdQ0B6iDjFBVE/dIRbaDpCG3fJ02n914HbZOKUFs=;
 b=OKvSFvVnwjxw6+V3be4CFPOnxvkhKaQXYCw9nR2SOUVavQrbFNt7rPl6bhjLyW1ni4W149pRThOGPAXEMC9UXQ65WfU7ROQ0XQUpF8551vF2G2bWAl5jJW2ku+MHk88qbWzOwCTc1MP9nPA+al9h3/ZxR7QdEvX3X/ShPuof8WU=
Received: from BY5PR16CA0005.namprd16.prod.outlook.com (2603:10b6:a03:1a0::18)
 by MW4PR12MB6850.namprd12.prod.outlook.com (2603:10b6:303:1ed::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.28; Fri, 26 Jan
 2024 04:43:37 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::a5) by BY5PR16CA0005.outlook.office365.com
 (2603:10b6:a03:1a0::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 04:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:43:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:43:36 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v2 17/25] crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled
Date: Thu, 25 Jan 2024 22:11:17 -0600
Message-ID: <20240126041126.1927228-18-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|MW4PR12MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: bee9c4d1-4669-46f6-7291-08dc1e295c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mppbisoawNh0OTtF/pO//rH5L6WWYGjlUeRh17RS7ZByZqvooUaRwMyl5dn8StYTadrOcX9s0F38DUuxrNzZ1Mt0u+L88qAjaVtBggll/xnZdoOmKZnCTkPdy6GphDpf85Fypj9vREM2OaIDtIPWJy0US976A2Bc4EXF3qYAJgE5aE/iSBjgNCHEMOvZQG9NH8s9xW51hL4zw63c9KXnVlA2I49yR2UshjtDXE41NMlRNhr/Je664CAPGRgxXvJGdqDI8b72SVxXVicvWOFH5tyHdWo6IrjOm1TqWm7qqQ51ijAfNjGk6wtMEkehBlR8p34QXL40Basj4qCaatcADu4IaQx+TH2GyFUCrZYe6x0GzRvpCcaVN7g3fIlXCPLEM4Q6uzJlPLxQG9j1j7VqH8IrK3x+oPubX7kosZoJlqDQ8rK2HnNsd/W08DZSWs64lof9VxB62svVFg+oSdXR2a84VXLqtJfLfW2EzOekFGmP6x0UlQT+mx4CwsTidvfvgB1sx6Mr46BbA4XLR5Bgiksqz2TVayD+13uXBREJ3FE17WCx+ayyfdeQa0JObUcaUeikPwsb5/PZ68puHl8X29kz1oJb7nHQDoCI1+TXR3ATctG9kn9N9an6YO5/A1U2zKg1A4Bn+nh1V6sbYd6/qY24A9y8pv0wnYnMxOrjh+Cr7rBAkgRkTHvsB0mDsOxfYIVFn3lao+nG6lAsdFGLPF7xapnrvvJnwa0gciUNROdTIvIilXNlnaQXkNC+qXHJDZYJq6lNVc11q7syvemHvw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(64100799003)(1800799012)(82310400011)(451199024)(186009)(40470700004)(46966006)(36840700001)(336012)(426003)(41300700001)(40460700003)(40480700001)(16526019)(26005)(6916009)(1076003)(4326008)(36860700001)(36756003)(82740400003)(83380400001)(47076005)(6666004)(356005)(478600001)(81166007)(2616005)(2906002)(7416002)(8676002)(70586007)(70206006)(316002)(44832011)(54906003)(5660300002)(8936002)(86362001)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:43:37.2120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bee9c4d1-4669-46f6-7291-08dc1e295c76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6850

From: Tom Lendacky <thomas.lendacky@amd.com>

For SEV/SEV-ES, a buffer can be used to access non-volatile data so it
can be initialized from a file specified by the init_ex_path CCP module
parameter instead of relying on the SPI bus for NV storage, and
afterward the buffer can be read from to sync new data back to the file.

When SNP is enabled, the pages comprising this buffer need to be set to
firmware-owned in the RMP table before they can be accessed by firmware
for subsequent updates to the initial contents.

Implement that handling here.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index fa992ce57ffe..97fdd98e958c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -785,10 +785,38 @@ static int __sev_platform_init_locked(int *error)
 		}
 	}
 
-	if (sev_init_ex_buffer) {
+	/*
+	 * If an init_ex_path is provided allocate a buffer for the file and
+	 * read in the contents. Additionally, if SNP is initialized, convert
+	 * the buffer pages to firmware pages.
+	 */
+	if (init_ex_path && !sev_init_ex_buffer) {
+		struct page *page;
+
+		page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+		if (!page) {
+			dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
+			return -ENOMEM;
+		}
+
+		sev_init_ex_buffer = page_address(page);
+
 		rc = sev_read_init_ex_file();
 		if (rc)
 			return rc;
+
+		/* If SEV-SNP is initialized, transition to firmware page. */
+		if (sev->snp_initialized) {
+			unsigned long npages;
+
+			npages = 1UL << get_order(NV_LENGTH);
+			if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer),
+						    npages, false)) {
+				dev_err(sev->dev,
+					"SEV: INIT_EX NV memory page state change failed.\n");
+				return -ENOMEM;
+			}
+		}
 	}
 
 	rc = __sev_do_init_locked(&psp_ret);
@@ -1688,8 +1716,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	}
 
 	if (sev_init_ex_buffer) {
-		free_pages((unsigned long)sev_init_ex_buffer,
-			   get_order(NV_LENGTH));
+		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
+					  get_order(NV_LENGTH),
+					  true);
 		sev_init_ex_buffer = NULL;
 	}
 
@@ -1743,18 +1772,6 @@ void sev_pci_init(void)
 	if (sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
-	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
-	 * instead of INIT.
-	 */
-	if (init_ex_path) {
-		sev_init_ex_buffer = sev_fw_alloc(NV_LENGTH);
-		if (!sev_init_ex_buffer) {
-			dev_err(sev->dev,
-				"SEV: INIT_EX NV memory allocation failed\n");
-			goto err;
-		}
-	}
-
 	/* Initialize the platform */
 	args.probe = true;
 	rc = sev_platform_init(&args);
-- 
2.25.1


