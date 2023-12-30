Return-Path: <kvm+bounces-5361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613DF82075D
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0EC3B21BB3
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EE06C2E3;
	Sat, 30 Dec 2023 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OsZn3j78"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C971915AC5;
	Sat, 30 Dec 2023 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeDb10RjCKjxt320fmj8iOD8HPLM8Z7T6vqxT0Q016Gd3sSngLAR4TwkwaDgf9HzECM9ZBp/PrJL9WC2WsesfKwEQAsnm8rsDspKcGF2Rs4vH1Wg7z1G91A8E/D9oSmiIwsQEJpNe1PnM0i64UvfH4J1NQP6tQufGl7E9imRAhI1nPdeikaBS/UbTrhI6y4RsX6YyVteA7X987Nh6usav2/HooBGR1N1KgYKZRgeOWZyKK+Ftb38+LOJFfdjsk08mRvSnlha9xvSQ5sRVU3noAtYkgtm3VK2q5VjOTeCMRMlMU6PeOurXBcmUuWSR/EZH9Re5jHlA+BO4uxCRXjX0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aI8y6mFONT6qHjzuT7xGTTcqPhBWFfrOeNpYdGUXeq0=;
 b=GCGkiZ8r66vhZqMqXxHBQq0QKLzydn6FfjlmlCfsGRIYOvFxB0/QL2hycdO/2okk7w4MNKLEiywN6LRTq62RcYZqD1QWUeeZZB1TD3XozEaMIduDLn8oTUc+SlZrRTtgBCukdqk8IHDF2SjOMtZk39eUBnvzKGwehQiZwJT5gKdCf2/WaqWUI0JU1jx880u+LD+mtHoEnmJfPU3S/5PJEABd4NSxvziq48brNUSjyGPj+tLLu8hZStYTmM2Eie89jqXy7qOBiGo/wVlglygPpI0ka1qOxKzLe2UU8w67EZ7pscSr+zohwJIMZiYZfTS3XTPi/TTB7jnDiFWBuKSauQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aI8y6mFONT6qHjzuT7xGTTcqPhBWFfrOeNpYdGUXeq0=;
 b=OsZn3j78DKfi+UjwhMHRXmjPiSs2mgJNVxWNMPaojZ6ARjpMx0J+KcOBZNXHKr3aM+tDI9UmqZdqYLkTITsWTOJNK5JLi02khVgXPugUjXr23INPKBoKPnGkgvL2Wn8u35WbJcqINr6mrP6m/tVZjtfYnaJUiQcy7wqRWLKU4K0=
Received: from DS7PR03CA0224.namprd03.prod.outlook.com (2603:10b6:5:3ba::19)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 16:27:40 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:3ba:cafe::40) by DS7PR03CA0224.outlook.office365.com
 (2603:10b6:5:3ba::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 16:27:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:27:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:27:39 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>
Subject: [PATCH v1 25/26] crypto: ccp: Add the SNP_COMMIT command
Date: Sat, 30 Dec 2023 10:19:53 -0600
Message-ID: <20231230161954.569267-26-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: e49042f9-9122-40bd-0fbc-08dc09543e1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hCU0OMPJQvOc256MBcXNB5pjx76tAhD4pyWz/40sE07ZnijXfuwDOS9IeIUdnn7xgtV53ZJ3KEcoRS/O7sC7LpIa1717U2HC0+XspSktYusyDP7hlbtYBTO8RX2RxRQw8wlHN/tIoEgPjYfH5l7pvrmEdrRp6sgh3yfI72GQUc51iXc0lmFY4gNzpXfKu6/0XZvTOf5bREl/TxAtYD5I1ChuX3mLqnN9jP4KVCWeXPb0orPits6S91VY2gC8yGXd2sM1rbfklRPjuRe3LLl2JEVAt6ukfhUN/plFQvjBegWOzVpMh/mETERQyIGP2oSw25YndZmcdIPTsM6AqyC+P+nLPKhj2GuZ257UEZKVfSN4R56YEcj1ZIEvEXuFU4r8Sv0L5iWrJ9oV97PviikKsBnHjkWT8TmSLNG6321GLDCJ2w+pnhoaew/0MgumyPHn0QV+ghmfGLDZYo2p0sLIm68nl7JQI8txEYG7zjHC4al9Qlb1uFOWqR3+o9HL4sLxJTlhn3VPnRNglngCrG49Nn+u3KLQah0MrqxS4Hguyffqbu2MuQC7GXPtJzTgK4aI9CobXQ0NLFHZw3jNDlY+GQnWlKDXx/ynxmDzbDWBQxM2ak2d7GCYRlJjAb38hO/7cyt66zNqdOvATxX5zOVfckOrf1iVooe6kTLD7XB2/Sw7Nng8kGhYijdiezzyhC3vsyORTJYXp19pg7CX6J9zFt9Uuj6xLG4ALW0XphA7zSqq+un5eH4G0zbcyThaAMz3fiiCt9evAH1pE/4ImVJmKA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(136003)(396003)(39860400002)(230922051799003)(186009)(82310400011)(1800799012)(451199024)(64100799003)(40470700004)(46966006)(36840700001)(2906002)(5660300002)(7406005)(7416002)(4326008)(8676002)(8936002)(44832011)(316002)(36756003)(54906003)(6916009)(86362001)(478600001)(40460700003)(40480700001)(41300700001)(6666004)(16526019)(1076003)(426003)(26005)(2616005)(336012)(356005)(81166007)(83380400001)(47076005)(70586007)(70206006)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:27:40.3268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e49042f9-9122-40bd-0fbc-08dc09543e1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555

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
index e663175cfa44..9c051a9b43e2 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -224,6 +224,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
+	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	default:				return 0;
 	}
 
@@ -2004,6 +2005,19 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
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
+	buf.length = sizeof(buf);
+
+	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2058,6 +2072,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
index b14008388a37..11af3dd9126d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -787,6 +787,15 @@ struct sev_data_snp_shutdown_ex {
 	u32 rsvd1:31;
 } __packed;
 
+/**
+ * struct sev_data_snp_commit - SNP_COMMIT structure
+ *
+ * @length: len of the command buffer read by the PSP
+ */
+struct sev_data_snp_commit {
+	u32 length;
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 1feba7d08099..01aab4b340f4 100644
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


