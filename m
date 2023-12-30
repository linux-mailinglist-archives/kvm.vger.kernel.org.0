Return-Path: <kvm+bounces-5362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB4D6820760
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 425F3B21D6C
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08E315AEB;
	Sat, 30 Dec 2023 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e+TUBCNy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956A315AC5;
	Sat, 30 Dec 2023 16:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqxBW5KRjNmIwx6folFiFWBt4jAyC1sAi9EH5nJJRFAJTYQV2DyRTplcWpkZRP9GqUvIaqlJbMBISax4wb89qfgnrM9RxYpU/rVI5jTvne1Lnp2+sS7rS4voDtALJTVXBp1S+oK0CIwmyXVMoIGgSSsNw8A5AXW7/nN87SwF0AlZf9MQJdi2lra9/JEoxSukXtjuHDUokHJAJpbXY/L4csJ4M56A8Z+v881dHGVHzqfqyHE660BooP9bz0iMXtSZtWFhKqYYDCS1d5z+1UUkzAEoHELPa5UXq32BR7qb3CBY6k0St8RwZvj8U2S0T/ZqkOBAWEV6mkEywIzMLDU22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HRK4QFVzuwysPEJ6g24TxyO83Z9D4pVegKGwtG3IRI=;
 b=lOhNXnXirKuRLFbHJhAUwyAnA6noJQDkznsqYDM1Rao366xsjjHFZlRa1HXtGjox60AueyQBivHVOYNKaFJryYsFb/jbDa0L8SyJet6xps7Sj17J5Tc+3QGU4IAvo6wJWlkZqbXacT53fb189EQspt+DInHQ6REq/oppXpZ1pulOWvBe5RucsiUYivLmDEOi1ZXTKdxAfnRpI+SCHk/nqLQ9m1SbqYtKFo7hY7e+W8EfNk3vdDwPrjaMQZqYIuZ8iQAcNwTDq4QNyLqG4sqreQ9x0oWc7utSdySH4/MmarzgzRxCAT7ARd7sijglDfr4IDhFtWdRCljnZOGGSgNX9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HRK4QFVzuwysPEJ6g24TxyO83Z9D4pVegKGwtG3IRI=;
 b=e+TUBCNy2ZLJ5EtEdUdnA0TYh3Ke+tns3orq+8SuFdWt5orNpY2I/Yhor4FcPRt8wz4lR7TahQn337CVDhB7kWAlTUvoVRu4Ax8dmmldl9OeAHBNNvheIMnpqybTLfJUapNPtDhtgYRvagVx6yGVBsQICuQDxc8LQquWWaT21HY=
Received: from DS7PR03CA0216.namprd03.prod.outlook.com (2603:10b6:5:3ba::11)
 by IA0PR12MB8227.namprd12.prod.outlook.com (2603:10b6:208:406::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 16:28:01 +0000
Received: from DS1PEPF00017096.namprd05.prod.outlook.com
 (2603:10b6:5:3ba:cafe::dd) by DS7PR03CA0216.outlook.office365.com
 (2603:10b6:5:3ba::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22 via Frontend
 Transport; Sat, 30 Dec 2023 16:28:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017096.mail.protection.outlook.com (10.167.18.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:28:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:28:00 -0600
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
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>
Subject: [PATCH v1 26/26] crypto: ccp: Add the SNP_SET_CONFIG command
Date: Sat, 30 Dec 2023 10:19:54 -0600
Message-ID: <20231230161954.569267-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017096:EE_|IA0PR12MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 1636d343-8966-4580-b80d-08dc09544a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dPhh2KRSw37/HaErMzCmJTsnzeUXr0kvWj1EuT+B/5kelbTimLSQIEfsjS/G4mkDbRZnnc9Qq2sjSFBn5qgCMvlhxbthL+WQrgW513k10E8qjEXJYwJ+Y2IznFOhD+q4bvp7FclaENDXHJedDaizBS5n1ti6Obr0gc6oym9DXWAcglXvVZVRblHnXiLsTC9/wOCid5twPWvkduxKyuAr+16YobVAGObsBt1sdwWPAGnM+6Om3k/62+TKmNSvvRsg+tHZBenKtKCaQ+reTqz22JCXjhXsOWhDz9NJ55sly8r0g9phfCLSePCjoinjmuW+/rzhngA4D1AfUy8e+1dsDUIEKAszz/TAxo8FWIUblYmnQozA49MQN2Vne5ceh76qf62X519VKIg0XQJWxl9frZtBTcpJiKEJTYIfj3DHbX/kQ3rwUrFvJvBiHiFp9CKQrEVLjb01V0mEgujyUF0+iBTp2QDliwQ8J/PaEa5/yRBDUdfsQJS9GbphtvGmWKCiGoBVT0kIlT9bMrXCQ+ZmWNy5o5sZIJSFeNc+SvlPMl3mWaq/eS7bLMuzHDmyqLYElPpYUkCzWIP2gGud5s0SHZ73L3gra3UsnnoeXqwDrakFi++d72nvGBHt1ZXx55O+sjMpcLhkb5rqsUIpadAUKeaYLWCCxmIOWVFB3u/yQSjYfYl4/3uZnEhlyTJ/paJDyWzcDTLmwtmFJEvJ7VbiFYv340HYqbziNAi94XXdPYVIPdQ9qIUda9+QhfQyCVo9sjjojcFtXg/+o4Q6Bnf0Tg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(376002)(136003)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(36840700001)(40470700004)(46966006)(2906002)(7406005)(7416002)(5660300002)(41300700001)(82740400003)(478600001)(36860700001)(2616005)(40460700003)(16526019)(426003)(336012)(40480700001)(83380400001)(26005)(1076003)(6666004)(47076005)(8936002)(8676002)(36756003)(4326008)(44832011)(6916009)(356005)(70586007)(70206006)(81166007)(316002)(86362001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:28:01.2018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1636d343-8966-4580-b80d-08dc09544a92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017096.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8227

From: Brijesh Singh <brijesh.singh@amd.com>

The SEV-SNP firmware provides the SNP_CONFIG command used to set various
system-wide configuration values for SNP guests, such as the TCB version
to be reported in guest attestation reports. Add an interface to set
this via userspace.

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
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
index 007ae828aa2a..4f696aacc866 100644
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
+The SNP_SET_CONFIG is used to set the system-wide configuration such as
+reported TCB version in the attestation report. The command is similar to
+SNP_CONFIG command defined in the SEV-SNP spec. The current values of the
+firmware parameters affected by this command can be queried via
+SNP_PLATFORM_STATUS.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9c051a9b43e2..c5b26b3fe7ff 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2018,6 +2018,23 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
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
@@ -2075,6 +2092,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
index 01aab4b340f4..f28d4fb5bc21 100644
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


