Return-Path: <kvm+bounces-7069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0535983D3B4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:48:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 706CF1F2957B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD88125A8;
	Fri, 26 Jan 2024 04:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eWPMk9It"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E210E14271;
	Fri, 26 Jan 2024 04:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244412; cv=fail; b=XgCYqAwir+rmuLhjhS74be4gEBZ9rasGXyFcdJx2+snMqVXllDlIIOfD8SwJBaDRvh81EsoFjkuPCypuGMygnD4Xw6uLKSQdHIuM88zENuqe2OSM1hBl9QyPBQeBSIPpahc368jBQ6PZlzwqaQDaRdNLwrs8COnmr3RFjuP5fas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244412; c=relaxed/simple;
	bh=VU24DfSeAgjL9+DHk5qcdoEQmTL4bXdHyHSZfDKxPRU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kNvzUpY8gCwrsSwBJsMmGL2jXJTmc4P7YFPdFcWIPsmOEaNkTdp65PbDvD6zq4KZ428lUwI1pdqqppCQ8YESQTwvm3GvdSVphJop7m2OaWDz0q5BZ6+z+PejVy8/4g8vRkzDsylfa8odLr2h5aKTtMp5HOl22rhTBsvE03XKs5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eWPMk9It; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7TaOS+T6xv4IAh7SPObQbVcd9elXaUW7IQFoDXlEe+v9TBQARTepxRKpbsc+pndrcp3vvZEZtiT/9EykVbto/E8wamWzFmgZ/585snUMIXQ6iFgiBP0QUNT6B/8PcqpT0MU02fpuD5NI5PzqHKaFprqph8u5miqoMoa8GQBGjnMXT7dKRyN8dzSXX3tCP82eE+SPWtenB5IDY0Mjq5kDfG1htL3xLEVpUaqhTGxFtDoVF5ezrqmUOfcuMS+YXMdUxIyOcT8ywyngEzVt0QeNfXR3uDJcfDqR/aTukSk3XIRvEsPHMIr+VgsOWZmMPcgEzKRXYm0vNa2wExtm5SCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDeqv0Rd+NQEOVYZuoLg7AnInMZUEU9WR2h7GI/0rZw=;
 b=eLkiNoctUIsw/hJPkI2fmS6mYF+G2UFx/O9oG4FBZOSeyAj2Re8pem/U1kn0bL9aHmGHiYTaQuI64b4G+JczHoC5RQcgMT/RItsPyTi3SOot2kBmb+7QHFJlUoytR9Lif3am10Cbeb+2IPlgsTqfyHjvGMUSsL/s2BNg8laxsbZw5Vql8BqMFjt1P3EnhaVxqeqyjT517516URug6g0WL+C0swA5AeAfq1OXuczDiClB8cfZjD3DvP4ehj+ZaWp7N4IF0AfPOBdLS+vkZ+3kT8/+wBh5hpGPqQ4+6r/qtst9BdSJOQWvro8lQ3Nq87VQnmnmQ3DdvpmOjUhSwRbUxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDeqv0Rd+NQEOVYZuoLg7AnInMZUEU9WR2h7GI/0rZw=;
 b=eWPMk9ItwDqFSwJb3jUb6+LgwVjQw3GJBqSzw7C37mQzf5cFfhT0BEOmVJTKxLFgRQQa3VF+ylzbSbThlrqUkTFZrdir1tIuyCB6Aim9/npxvF494ip/+yWsdHjFz3XiGzjej5V3/q87J2QvsTAO+rOXGM0YQ7h0jtVQfSsYQdg=
Received: from CH5PR02CA0017.namprd02.prod.outlook.com (2603:10b6:610:1ed::19)
 by BY5PR12MB4869.namprd12.prod.outlook.com (2603:10b6:a03:1d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:46:44 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::7a) by CH5PR02CA0017.outlook.office365.com
 (2603:10b6:610:1ed::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:46:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:46:43 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>, Dionna Glaze
	<dionnaglaze@google.com>
Subject: [PATCH v2 25/25] crypto: ccp: Add the SNP_SET_CONFIG command
Date: Thu, 25 Jan 2024 22:11:25 -0600
Message-ID: <20240126041126.1927228-26-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|BY5PR12MB4869:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f7e2305-fbb1-427c-3cff-08dc1e29cbe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aqDsBcSb6NdQLynCq/UCIeCeSzRx6k0iglwucgxYu3q5U+ZjM/2IC9biXlr2W4l2hoxIn1+6GoNzOud2aritAeAmA9A/ZIp8Nf1oI7LKwlss3YvIkqls/+suAnc6nry4/9nc6NteXOcfMJRLFBVN9t/IlNPHZueu8UAOUdA2TpOy1Lll3ibu5rx3UdTZozYRrqJbr9t83Q6GSyRGNEIGdmx/M3qJB+TzNvE/Ff732vMkkdGb5WkwTK3gt10bIfKdiID7OpBSNFLWxqjw8lNrfdHo7aVuPsTCgc45BhBIAYrEIvSNpJyUxKv9yVjeoiJ6faOovaw0tjzO/B2XwAhyHXDY5KtxxnfKfhOlXp40NVcYI7SI0v6Q0nVuLOFtKWlxBQBJpWwPRQDg5f+KHLxoTmxDCmgam49qCzwuRWRJMK40guZgpmQ89aFPHGaETiCG6F9i1aQchJAi6tzOy05WfqznMha/a1XHVB5aahYF5Hitw9qj4vxAyA3Vzkm5vRqZ5EW6wVpQYJJaGIJBrWuqqdOCnmyTgwCUYqlbM3fA5TsJVshoj+1O9aOVrxt2OGhs72HcZP7j6/OmutAlUWQI7Q1o79vWghBOjpxbXB2EbxmgOt6/thTATIA93R4pUzmWNWr5iZv40h+vMDWWf0rzAbLofTAmLCs+4AGq1xNknEwxdJWI/X0yaWA8lPThLg6IvUaByyOWq2b644x69SO0QmXSwadGKO9t2nEy9kiHX8BqrMUE15lkerf5wGmYFbfoxsnFt0iH1Exs0wiUqUfg+A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(1800799012)(82310400011)(64100799003)(186009)(451199024)(46966006)(36840700001)(40470700004)(82740400003)(81166007)(2906002)(36860700001)(5660300002)(44832011)(7406005)(36756003)(7416002)(356005)(86362001)(426003)(4326008)(2616005)(336012)(26005)(16526019)(478600001)(1076003)(6666004)(41300700001)(47076005)(8676002)(8936002)(70586007)(54906003)(83380400001)(70206006)(316002)(6916009)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:46:44.2252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7e2305-fbb1-427c-3cff-08dc1e29cbe7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4869

From: Brijesh Singh <brijesh.singh@amd.com>

The SEV-SNP firmware provides the SNP_CONFIG command used to set various
system-wide configuration values for SNP guests, such as the reported
TCB version used when signing guest attestation reports. Add an
interface to set this via userspace.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: squash in doc patch from Dionna, drop extended request/certificate
 handling and simplify this to a simple wrapper around SNP_CONFIG fw
 cmd]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 13 +++++++++++++
 drivers/crypto/ccp/sev-dev.c          | 20 ++++++++++++++++++++
 include/uapi/linux/psp-sev.h          |  1 +
 3 files changed, 34 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 007ae828aa2a..14c9de997b7d 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -162,6 +162,19 @@ SEV-SNP firmware SNP_COMMIT command. This prevents roll-back to a previously
 committed firmware version. This will also update the reported TCB to match
 that of the currently installed firmware.
 
+2.6 SNP_SET_CONFIG
+------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_user_data_snp_config
+:Returns (out): 0 on success, -negative on error
+
+SNP_SET_CONFIG is used to set the system-wide configuration such as
+reported TCB version in the attestation report. The command is similar
+to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
+the firmware parameters affected by this command can be queried via
+SNP_PLATFORM_STATUS.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 73ace4064e5a..398ae932aa0b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1982,6 +1982,23 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
 }
 
+static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_snp_config config;
+
+	if (!sev->snp_initialized || !argp->data)
+		return -EINVAL;
+
+	if (!writable)
+		return -EPERM;
+
+	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
+		return -EFAULT;
+
+	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2039,6 +2056,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_COMMIT:
 		ret = sev_ioctl_do_snp_commit(&input);
 		break;
+	case SNP_SET_CONFIG:
+		ret = sev_ioctl_do_snp_set_config(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 35c207664e95..b7a2c2ee35b7 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -30,6 +30,7 @@ enum {
 	SEV_GET_ID2,
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
+	SNP_SET_CONFIG,
 
 	SEV_MAX,
 };
-- 
2.25.1


