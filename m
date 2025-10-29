Return-Path: <kvm+bounces-61377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF91C185E3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 06:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4F8AE4FA9FD
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 05:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233E02F90CA;
	Wed, 29 Oct 2025 05:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="laAmT2Hm"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A94421B9C0
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761717499; cv=fail; b=Z5eYtgWSjEfncU5XM2nFZmPerGUJJllNWUqfbXIRcBRBAC18QE4qkBGvykk0ywg8SmcB2Hh33Tri1oVhw6uT4qnBUXPdqFQn3XG4hiDHB+TXJMnl+zSfL1HsH0t2ey0FziemekIyV3EPbNxT7vIhE8CFo2IKHMKsIpK7fxKZGbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761717499; c=relaxed/simple;
	bh=x2RKI/wrXysF7Z/HDCtjaPUm8Mz4rFt2S4Y49vG0PWk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jnVKr5kSK0YJOtO1yNwTb/sXDcDFmobQoL3PeK84h3KUhkfaIYILMUkArqgVjDSvudqQdM4j3fiFWKMEs9YB0PYwHxVPmCaZOp3vK2x1kaWXAfhNwFOjrid0q+vU0K0vqgqTj/nrQoJaF2IUy4QtoKdlZVr+MQdvpZZFVVRIEx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=laAmT2Hm; arc=fail smtp.client-ip=52.101.62.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiTmJSHPZtMpptj/VFSg0BxeUDpPPSd/Hdx3YXVO6/vM/ObSVC6YmJ7IqgXU7U2qrV6tgtoIgTDUvcwErJfUt7ghxjeuG3IjgTlbvGz7x7HHv3ImHSxrhzPfEziUMbd462oyL+aRS2kurPo+sTjqtyMpGJ1qt8Yvoqf3LU5GjAQTwgfh1Ym+XWTUVGLjB/X15Z5CPFoQI3zBaGl7o1eNwzxg6eotNF5o6uS3gGjY3qqrHm72a5X0F5I8WZFzNlGGFigsLteH/H1s1gqu0CE4Xezmg1//ZKvSDIjge/VUPmDJzEXkuBmhp1uWekSZcQoaMz0nW4Pob9y9L60vcjpZgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vr3k57pg/dIrnPh0eD3PDxu4cCWA7pUK+/tBk3zZxWQ=;
 b=qK/3aGt3OJ3mDd+oFDALIn4VIzlgyyUw6CA/FJbDz4K7OJRoMzyzbQezkX0BviAhTnvCXAzJVlPW8wc+oOqLHCMB9i200b6Gl5a9Hqwb+3QN9N4HDXOYzhzMvX8qFeeL5xBaAarh7JAApP3PiiGnj8BxWwJmSeFrRmAdpycOMznd/SWTgcuY8ddBuHSHAGBWWNFID5/xh///HHoAmCz0tjCEyj8Oc8SdJTJlrBo+3h1JeiM/eP9B1VMH8Y1jWG+N3ga/RZ2JhI4tPIVMzT0umAeVj+vUV9KLFmtIvDtGMnhn82h9Qw1wgT8hUUvwhWDT6TovXv0YaittOp+CT4UH1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vr3k57pg/dIrnPh0eD3PDxu4cCWA7pUK+/tBk3zZxWQ=;
 b=laAmT2HmVvCRVyWjgvCgRbKE2Kf4LwQlnoUS3LpkDeXPt2nXi3aSN5Q09P4HUG4HvKYlpQ9SrGyAwMf+2YkGl6N9Uk1mco2D0fuRZANThNELfrKk2XzI9lP59hY8RZ3POcFspCSs1UAb+sgWi3No2E2+jEvtk6hg4/EA4J8JeU8=
Received: from PH7PR02CA0019.namprd02.prod.outlook.com (2603:10b6:510:33d::25)
 by DM4PR12MB6589.namprd12.prod.outlook.com (2603:10b6:8:b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 05:58:11 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::b1) by PH7PR02CA0019.outlook.office365.com
 (2603:10b6:510:33d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 05:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 05:58:10 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 28 Oct
 2025 22:58:08 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <nikunj@amd.com>
Subject: [PATCH] KVM: SVM: Add module parameter to control SEV-SNP Secure TSC feature
Date: Wed, 29 Oct 2025 05:57:53 +0000
Message-ID: <20251029055753.5742-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|DM4PR12MB6589:EE_
X-MS-Office365-Filtering-Correlation-Id: 3610d0e8-dd5f-45c0-688d-08de16b023e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mBTGxFLvtq8gOyv7gEng2dMo0aME74BFa/ei/IUXdWSHixTXPCFXzed5BXq5?=
 =?us-ascii?Q?mYp81jxZp+RJWKx7sVbWEVH2KR6isyt6ZPhw3n01HqfDYC2FXchjGiPH3DV8?=
 =?us-ascii?Q?qk76Cvzo/ff/Efl4ajVF02JuKUX0OzrxUp8v+ClCuGrJjg0k2h26czLGzgbE?=
 =?us-ascii?Q?MPoE4NC70wL+zqMlh0eeO95p/uA8skUCOVDZq0AB8y7F5XvPDI7fPSA4hnlT?=
 =?us-ascii?Q?3ikIbYX4+YRBYoBjrOypPokMo+azyaBezIevddrnaQ4sXb15B0uHmWuzbVhU?=
 =?us-ascii?Q?eRj2wTEvYqO7p1nQwNo/kcj9XJUxZrRyw2nz8Mvfn3wi5e0J2EZd7zN8KHfX?=
 =?us-ascii?Q?ZsNvZ9HotA/lCvtzDTEK2ga5auCZ4xrd2as/ddq+0GauPJC6e5gFVlY6+dWU?=
 =?us-ascii?Q?HVyWQlECLJeo3r9S+OfM7dRucaee127+r71dIHmqbmbmxFGT6mV7upI7HTXI?=
 =?us-ascii?Q?ch+D9hRu6b+DV8v2P3uAWQsNuj38M0wtJAC3wPkst5voGPQb77pWQijdAZ6d?=
 =?us-ascii?Q?pgksISudWFdy1tSIMmnk1oSbh+kR6Cg8lAPK+EI86eYJPe+I0JZ3MdwZm3S2?=
 =?us-ascii?Q?T+K0gE3i3WR2JNQrfidPq486V1fUNvCPke+VjWYvbDhqcafkmIblV6q62/s2?=
 =?us-ascii?Q?a3XVu+Lg+Qb5Kh5dRA+D1mpJmLqh3XMi1qdkkf5Tkwr5xAWhFEoxmhcfB1Ky?=
 =?us-ascii?Q?UvSaM4/Jkd1ny5ncdi5RVhVBFd90KEIVDG+09k1sVGFzFegRuie58Da6jK3k?=
 =?us-ascii?Q?XKrSOuKYCy4vj2EtF4hpe+ll33TKRMTWk0zeYQ6oJBYf/qfiOFA44o599QqB?=
 =?us-ascii?Q?BmxQN0xdzuzsHWw5lmYkkHq72n5pGmQR1JRE1uADcnaxvJnbpw9xLMiFNg5X?=
 =?us-ascii?Q?dR9J5MR64JfhojT54NPgeI1VRLsp5W69WyBCAB6FF9s4kZSch1UiNsIrvvq/?=
 =?us-ascii?Q?EEAme/3RkIdBSRJ72KvFzetFyYmJQKJonrV1hGs+dhSt4gOR3FmUrhH50+5m?=
 =?us-ascii?Q?DzxFTnUNkFqSRDQRZ3ORr3HmzuupXEr8MYxHU1WdLEjDnNpBgrSDwL8hzG8t?=
 =?us-ascii?Q?EWiNjByqbGo+rOHnet9MppLciQEMlfDkuvFzarsBgMGbgQSNFCpGkpIsXs9i?=
 =?us-ascii?Q?e104sWG6hYw8P3amY6KgazugEI++1PNCVvDDEJdAZjEBNObo/Bk9Or0VFdYG?=
 =?us-ascii?Q?5iZoNvVFcpr2/Xu47eF8QsTSOYOwKHe2+3wXlPwCfdRuRnpqBicpJd0mF80Q?=
 =?us-ascii?Q?rzG8aabURvI3gjsXssqJ/JTPLUBll6P+iXTFBZBXVL0UHVc3oJ5MO4mzK3Wc?=
 =?us-ascii?Q?Hmogm0PaU7N0w6Ei8JpIKZXJod8uK9P17wdxIg0s1ycxRuHCo2MNnaIu+tUc?=
 =?us-ascii?Q?0GjcbNdbpOZs/KeKsawFNLKMYHbWzWpbq/6X/zVyq/sxyXVR0UzZhkBBd96b?=
 =?us-ascii?Q?PbvXLaW/dna9AkXUmwEwTCPWy1shhL5aIuxKfJYzUPSvS9YRqWbAOrY2K5Wh?=
 =?us-ascii?Q?sOoRKg0vJz/iDhSg8gwIQc3Gf9CNSH9u5EZDuTLE5RyRmX14hYfQTqv/P70M?=
 =?us-ascii?Q?qDSBTBKGrE/0HsKuj6M=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 05:58:10.5080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3610d0e8-dd5f-45c0-688d-08de16b023e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6589

Add a module parameter secure_tsc to allow control of the SEV-SNP Secure
TSC feature at module load time, providing administrators with the ability
to disable Secure TSC support even when the hardware and kernel support it.

Default the parameter to enabled (true) to maintain existing behavior when
the feature is supported. Set the parameter to false if the feature cannot
be enabled to reflect the actual state.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0835c664fbfd..1f359e31104f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -56,6 +56,11 @@ module_param_named(sev_snp, sev_snp_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
+
+/* enable/disable Secure TSC support */
+static bool sev_snp_secure_tsc_enabled = true;
+module_param_named(secure_tsc, sev_snp_secure_tsc_enabled, bool, 0444);
+
 static u64 sev_supported_vmsa_features;
 
 static unsigned int nr_ciphertext_hiding_asids;
@@ -3147,8 +3152,11 @@ void __init sev_hardware_setup(void)
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
-	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+	if (sev_snp_enabled && sev_snp_secure_tsc_enabled &&
+	    tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
+	else
+		sev_snp_secure_tsc_enabled = false;
 }
 
 void sev_hardware_unsetup(void)

base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
-- 
2.48.1


