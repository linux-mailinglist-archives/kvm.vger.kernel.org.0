Return-Path: <kvm+bounces-7068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1476B83D3B1
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:48:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFE7128546B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1E2D26B;
	Fri, 26 Jan 2024 04:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GytQ8apd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E79C2FE;
	Fri, 26 Jan 2024 04:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244390; cv=fail; b=jMZ/sCx97zyf7QygvFyGQFe2EHvVdbSZeHuDmW9dhH7MaiGuyW291jKbxfePgoZYkclUcnN/nJALFEDAy2x83q4PpessDi7iEMMFjMoj2IyHUZS7cuTZlN4LxUlrS0LWXpnQC+MP6+4Qs4n+R8yD2V8FpChN43fR6p+eHjNJ95U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244390; c=relaxed/simple;
	bh=nsqAmjMDpFI7POL03oJKlspAd8clB11tHX4Cd62+CA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MbES20uYJGQIlrlqafImkr2VOwyOMoeh6wSmyss6+UvDVs7BlwH7aGVf9h0KViwTeh7DOVhyoXZah8i296NRsDmvyV1z6ZQ2otmqXTF5fQI6tkROIR62T6pt1nsOOBI+c/YwggFHxYoEA027vq7phtOWps1OyxV9FGYJHPsnNrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GytQ8apd; arc=fail smtp.client-ip=40.107.237.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxfMNnaM7qw8N1rfbjsJ5zhXRMD57BGXeNmaMHAdFAhgQ1VSGMZ+VZsJ5D7NBGAu+O6z9fSzGAon6VkbYQeEsP8AHjsmeXn9e7nsAkGP7htkVE8C/UK8O4bUDNe3K/8Z/vWSRcRLMuylaj0asRmKM622ktOlR/7oUHnUEJpGz/lhEHi8/Nndrixj2QLCbSgqa/e/JzuHM3qxZL0EiZeJhdFLOYVENfatRSJZPwoPo0i4z5X4JQDwpRvFBhSleb3CxMDeGN3Gvmjy3Fv3UBhu6mc9tKnIyo9mCGxhbcVlVjPyi3Cecc5o7/cqDph5P/pzKzDWOvkVGykrm02EP+sFjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UU3BHFRlkhMspS3Gn0J+D66WgUTsZEWbGuYOYJ2bfmM=;
 b=kPlzX1veup/YkDDfqKcNObGXy+sXg6K8Whx7jF4jitMhKo6yUT0+sjjaA4ufwO23+ilTZddyGtTXqZo7yK0vLA0tJsLhagUL25WXMYeldZrd7x9lNAZzNQDyeA79xt5w2vsAF1mhzgXdrvXCvCsV92TtX/lbViAtoi/W3l5JQqQD+LJrcI/CjBAq707Dq5gNumkPt5nsGfEYiQCL/3tnh9ntKrkqkNFfOd3axZlV2PinTWeSRcAIILsymtQ1fTf9nH/IWc+wbz3vaE8ReevfRIqkRCPAXn3xRfwp4lcRBCzreeTz3TKGrRixnEUtCbhqZjsjOEtPj2gxkpjnf0shBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UU3BHFRlkhMspS3Gn0J+D66WgUTsZEWbGuYOYJ2bfmM=;
 b=GytQ8apduQsxhzzccJeUkUh25wh9JHkyGp46O8LjRZID+yMbuYVx6VDg8u6wyKpHNbkUxn5hilYR9veCbVWC0ANH/Vfb2SDvjA1lcx9BQm3KCFpXunZZauSSO7OLSi1PqLaNzJzLyaYULYhs+rzllqd7LuIs3nit/31DnmErFz0=
Received: from DM6PR02CA0166.namprd02.prod.outlook.com (2603:10b6:5:332::33)
 by MW4PR12MB7467.namprd12.prod.outlook.com (2603:10b6:303:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:46:24 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::fd) by DM6PR02CA0166.outlook.office365.com
 (2603:10b6:5:332::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:46:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:46:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:46:22 -0600
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
Subject: [PATCH v2 24/25] crypto: ccp: Add the SNP_COMMIT command
Date: Thu, 25 Jan 2024 22:11:24 -0600
Message-ID: <20240126041126.1927228-25-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|MW4PR12MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: 7864d932-96d5-41e2-b8bd-08dc1e29bf8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VKQb21dAilhTE1lfdCFY/CEwt2l2RaTvjiYFvU+Hj0/IPAEgG/9axsuY3xxe8uvvJ5j/b8sRw1T7O7qcyAupl30W4iGL2QNf7iPoVSKqnz72rznp1TPjT/a3g8rGppnpsi6MejcwPq/tsLy10RrRjaCla9m1AVNb2zbb9aNOftUWefRlLUMwo9nzD3M9P+OjWlnKcgSqJA5ulk8N7Dkko0Vs0xTsmZbxgg0LU9FsZKSR1jThC91TpYRqPzea2kY1TZo69aEM4f+YSYZtEt1DEYaZ4soAqhW8d39PL4/aIBrpx3rzx5JOzxsbidmeRsOuQYoHSa8b00IqKRyDncRs79vkMGimF2mcTvZ5DGr1DTfPsIiMS1W890LKtPxLNrNiHZECO8XnxsMP2AbswZFXXvv/kx0iujKJbKg2Jby1rX9+ODZ5ELNoRKACNqPsN/f3WZPBw7pb0NMoFpkxm5T2lSp6SSHICfkYpAG+4+GTDOTmoZWJ+fhUHb8MzgNE5vYuHM2odGFw26AkM38nt94HDa/O+aGmuHfolpzFhxbgBilVzfAobolLnt/EEx+ad38/uXt7op0BmS9+CtsPXhwBnJXtrXVpGk+BnQPQOL3x90NG6F8CMk864j6Nx0bhwep8JQRi4lwXiSC9b1qEOQFu4JgpTKCyHU01780l+UviB2qYTFgpUkKd7oJjg2dkiROhjQx7+5EgNH3rAS3ZhYOXAVhNxIWAl9rFXstE9rMAHHv66BL0EsbhWY2wRkP29gMcMkQZHUQJN3RhDHhQ9b/J2g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(346002)(376002)(39860400002)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(46966006)(36840700001)(40470700004)(47076005)(83380400001)(1076003)(2616005)(16526019)(426003)(336012)(26005)(82740400003)(36860700001)(4326008)(5660300002)(8676002)(8936002)(44832011)(41300700001)(2906002)(7406005)(7416002)(478600001)(54906003)(6916009)(316002)(70206006)(70586007)(36756003)(81166007)(356005)(86362001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:46:23.5346
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7864d932-96d5-41e2-b8bd-08dc1e29bf8f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7467

From: Tom Lendacky <thomas.lendacky@amd.com>

The SNP_COMMIT command is used to commit the currently installed version
of the SEV firmware. Once committed, the firmware cannot be replaced
with a previous firmware version (cannot be rolled back). This command
will also update the reported TCB to match that of the currently
installed firmware.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: note the reported TCB update in the documentation/commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 11 +++++++++++
 drivers/crypto/ccp/sev-dev.c          | 17 +++++++++++++++++
 include/linux/psp-sev.h               |  9 +++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 4 files changed, 38 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 6d3d5d336e5f..007ae828aa2a 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -151,6 +151,17 @@ The SNP_PLATFORM_STATUS command is used to query the SNP platform status. The
 status includes API major, minor version and more. See the SEV-SNP
 specification for further details.
 
+2.5 SNP_COMMIT
+--------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Returns (out): 0 on success, -negative on error
+
+SNP_COMMIT is used to commit the currently installed firmware using the
+SEV-SNP firmware SNP_COMMIT command. This prevents roll-back to a previously
+committed firmware version. This will also update the reported TCB to match
+that of the currently installed firmware.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f6ee0d24781..73ace4064e5a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -222,6 +222,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
+	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	default:				return 0;
 	}
 
@@ -1968,6 +1969,19 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_data_snp_commit buf;
+
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
+	buf.len = sizeof(buf);
+
+	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2022,6 +2036,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_PLATFORM_STATUS:
 		ret = sev_ioctl_do_snp_platform_status(&input);
 		break;
+	case SNP_COMMIT:
+		ret = sev_ioctl_do_snp_commit(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 7f9bc1979018..beba10d6b39c 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -788,6 +788,15 @@ struct sev_data_snp_shutdown_ex {
 	u32 rsvd1:31;
 } __packed;
 
+/**
+ * struct sev_data_snp_commit - SNP_COMMIT structure
+ *
+ * @len: length of the command buffer read by the PSP
+ */
+struct sev_data_snp_commit {
+	u32 len;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index f1e2c55a92b4..35c207664e95 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -29,6 +29,7 @@ enum {
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
 	SNP_PLATFORM_STATUS,
+	SNP_COMMIT,
 
 	SEV_MAX,
 };
-- 
2.25.1


