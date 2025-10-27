Return-Path: <kvm+bounces-61220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A353BC11330
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 20:41:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702F7564FEE
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4BF32D0F3;
	Mon, 27 Oct 2025 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YR9rgfuO"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F82432D0E1;
	Mon, 27 Oct 2025 19:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593675; cv=fail; b=u4bLdXJlaVdhtbkjfBhIxl9kg2+wMVYOVbT46Jsjz3vBjUnT5a8d5GSqvaOvhPSzFP9EsxFR/QcQsszWaPmNATBLtG68F2PDuNvi09fdJNdLdc7Jnp0QBUS0FPo3RPNwqb7FTpOc15J/DbDSk319n+XdcX1GOPkSCF9pKJa5v6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593675; c=relaxed/simple;
	bh=jfVv8eUbMpYQPc19AZIybk6tgpUv/6iKfkAxD2kIuMI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/O/UoxfdkwAP3HAYfVKcuYtlTES54C8WVeTriIq0vnlt6MtKmdHPhs6vzCBlA5u6zkhltxj1ChhFIGBul2QlQG7i/U7SNFCJsgXoRF1BRleO9o1QOUjcdRwT/bVzBZ9vck29W7ANFlOTRlvI+c5qD6ORb3hYgFyLgd24a/JFtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YR9rgfuO; arc=fail smtp.client-ip=52.101.46.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGOn6B1WgEGOGSSgbkGROpapYJ/B755P6mU739ZPcwlITB/qZKcf4YTREAKACISC0FL5ViH2wppkKWIXoKq+615eL1Vpzvm3JD8VLrMRN/6giFgTUo72JtVHEDVbE3O6tJ4lutZrqUToCGHDpdegienvp1rLybZY2UlgJy1N6S1hyyhc1ZVDP5HAGOlwfalle+v+5bRXDl3FTGKA5Bmu5b1xKfKn1tQ0cUDfxiyZR/TknbhftTCtOF6C4EYg/R9yVuKDtoQyhfgzKaTheL0xtbLNs6egTnSd9WXy8wElUlLJu6BM778Agdr6b5ZbiCHhGbRvr7Aiz+FXPJfBLyqm5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LO6769yM7Bcgo9npLcgs1h3bJKJozksfuK358JTJu3M=;
 b=VkjXnSDdTXFGRxEvvVk5fFW3T0qn6AsTwNqpF7xf94GJ3HEncbSrZ/lkjmuasfv5hcao2jPNcXx1YzF6W6eXIDT2slSbGsBJ5dJLso4FxMCLxe3bmpXlW4uivKk3+2cFP53iasFEJlIWxLgDwEWPp53w2mXLFytqryD8n4yTbb1Hj40Wu5vjOl8NtDrzr9r8UkNOFAOdXyDMOedD4vhbniVeMg7foaGLbqxH+yc0shrCvTtQrt6667gGcis/QDqip7YE3x5GdZphrHBER9MwfHk1a+UWIj8ye55w+kLdrrC72Ky0dIapL33r6egFHAvJUL8EA6r+AHsy02wdt247ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LO6769yM7Bcgo9npLcgs1h3bJKJozksfuK358JTJu3M=;
 b=YR9rgfuO/hSivRuLNgNsHnFzt8Ii933GTT5u8bxyaxWra044gkFwvmBFPPjGYw32fEgKYKrOcFzLFtzgK2dean5sJGWiT2kFn2Sa5h9iSMohNd9rsNV9QDOrZq/6SWTNr/fKNpGc4Q+lule/L9kBVOxbOpXEkAwzxhKC02J+RPY=
Received: from BL0PR0102CA0059.prod.exchangelabs.com (2603:10b6:208:25::36) by
 MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:34:28 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:25:cafe::ea) by BL0PR0102CA0059.outlook.office365.com
 (2603:10b6:208:25::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.18 via Frontend Transport; Mon,
 27 Oct 2025 19:36:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Mon, 27 Oct 2025 19:34:27 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Oct
 2025 12:34:26 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v4 3/4] KVM: SEV: Publish supported SEV-SNP policy bits
Date: Mon, 27 Oct 2025 14:33:51 -0500
Message-ID: <c596f7529518f3f826a57970029451d9385949e5.1761593632.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b7105f0-40ab-4bc1-98ab-08de158fd7bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x3IjaUSQDa8dQhef70qcPdCI8u74lt1gQ4W/Go4IFkNlJbgb0t2Ruymxqulj?=
 =?us-ascii?Q?lY9Z8bgQu8709brENZdfPRjW0O9fzHDOosTTAwJN43A/Er8AH5S8AWH8HU19?=
 =?us-ascii?Q?tmw4ENi21c/4iWPpwSUlgfQpDzvNc26GPWVdMLxtPWVVY/uE5lNNMN1W5m+A?=
 =?us-ascii?Q?AhcWwUNvauOTVE3hlgriJhG1zghZExoi1gJ1q9DIysyCInpipZ/lanGOKmqI?=
 =?us-ascii?Q?Ahrd6CODmhKb0g9rWY7nPCDwjkm4D8FftWTGnKCOw3LE7wWvwaNePOy67ONF?=
 =?us-ascii?Q?Qoyqrio8sHHt+5MEUT2/QTHFb7eVom+XGU+nSzOsMrUmJXqIgcPd/eoj1IE5?=
 =?us-ascii?Q?SekKsAple30qzzGKPxAIYgZ1IG862fHEQqetZAjR3Y57D/ar1HgZXD5IKowo?=
 =?us-ascii?Q?6ULulmF5fw9/lSaDu8SLECx6MJzdVsOi9iqZsH83k3biabg0ziB54mITnssK?=
 =?us-ascii?Q?Fzr9xFcaM/4+rGdRR2YVpwpHawwKr+snMQYHQ0ZqI9LlZFb0sb3I7FuHQk5K?=
 =?us-ascii?Q?uI5eqcwlUtm/ZcajNj+tXNVXcy/csCKCl1A+X3pGAitOXGSBC4kJvP3/bIuT?=
 =?us-ascii?Q?hovd8+5Ks2kEfi10WyeQEsHAqLB9UVlJLs3HF6UfS85r5AEIERpCXEyRfg3Y?=
 =?us-ascii?Q?UMDEQfIN85x88yrZkLHnOuosyT4P4IGo3Dd4RW2l+lsAu15a6a8daihvEjtB?=
 =?us-ascii?Q?d5vWpAa9jh8MTkJ94HkSWsbRepEfmlACzqwY/ej4KKPSbqdZfdu6J4aXCoUk?=
 =?us-ascii?Q?JPqKg6+T5/6igasyktoJdi5GzFeoNUeL8lkEmTon4k6aMiwSwbiCn7F/9qm7?=
 =?us-ascii?Q?ClU9cBdQCPNzaS+jijyRGQFmNFXcCanaf7Gtrmuz+dFjquYGMES0pLbjHjZR?=
 =?us-ascii?Q?SSrafip6O6nmOkz+DWb+Lf4lNVBaDgGWCm4XE/fy8eVR3GrJ16uMhBUY8W6l?=
 =?us-ascii?Q?fdM+SUA4jn2buhThpIC62oF2QpyODdFIQ4Nf+KRdKUQTwlgQE4Y2BANc/Goa?=
 =?us-ascii?Q?3NlTJewEEYr+rL/MxvHTTKpB7W+DuXUU3Ec0v0aCW8LzbCo5uRcAq+Ah1TCd?=
 =?us-ascii?Q?vfT2pM7IJEzQWpCdcrY/MVqWp46KmJUKiXNdEbTYRcwgad7QUy9Uik1KUgbw?=
 =?us-ascii?Q?iPkatmcEYVX/W+gZD7CBwR/YAv4qJJpPFv+9/EqfO5D/K2yGcLiSdoXQ+wpy?=
 =?us-ascii?Q?vrGRxKqsdkxHQS9IBkeFBlhcceELBMP2JRMHIhcBTuTin939buRtdTSTvlHW?=
 =?us-ascii?Q?HmwD3GrbUPeBhsMFLeHmWCrnJVyXM7kO8OfApx2hCDxpGSQqQ2mwQe05snUg?=
 =?us-ascii?Q?MjdOu4JGVyz8tjmToXPtB9nkpFLrWUWepSWuByT4JSG8SPkuHU3IgrUAQcrC?=
 =?us-ascii?Q?J52Dun2j8IQJDC2H4/j9+R9OU5g/5nlGk8tmIJS6XK/lRzt4/JNmqmkBrmYc?=
 =?us-ascii?Q?MHjHOBns5nz5X/KT8dPPFQ/BMaFNy8gfFK1vPbjwxMaYzanr6HhwA35KJGTc?=
 =?us-ascii?Q?pHbS9MbUSO5gwvdWJO9JndyNJWiY+HL0rF1wMu4EqlHzBmffvUpJna+0okfD?=
 =?us-ascii?Q?k0OPukPFN18wmAW5XVY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:27.6717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7105f0-40ab-4bc1-98ab-08de158fd7bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213

Define the set of policy bits that KVM currently knows as not requiring
any implementation support within KVM. Provide this value to userspace
via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..7ceff6583652 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -502,6 +502,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f04589ae76bb..a425674fe993 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -72,6 +72,8 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+static u64 snp_supported_policy_bits __ro_after_init;
+
 #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
 
 static u8 sev_enc_bit;
@@ -2135,6 +2137,10 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 		*val = sev_supported_vmsa_features;
 		return 0;
 
+	case KVM_X86_SNP_POLICY_BITS:
+		*val = snp_supported_policy_bits;
+		return 0;
+
 	default:
 		return -ENXIO;
 	}
@@ -2199,7 +2205,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	if (params.policy & ~KVM_SNP_POLICY_MASK_VALID)
+	if (params.policy & ~snp_supported_policy_bits)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
@@ -3092,8 +3098,11 @@ void __init sev_hardware_setup(void)
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
 
-		if (sev_snp_supported)
+		if (sev_snp_supported) {
+			snp_supported_policy_bits = sev_get_snp_policy_bits() &
+						    KVM_SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
+		}
 
 		/*
 		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
-- 
2.51.1


