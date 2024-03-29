Return-Path: <kvm+bounces-13139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6788927B7
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:09:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A74E1F23484
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:09:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BE013EFED;
	Fri, 29 Mar 2024 23:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v3wKXvjw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81C913CF91;
	Fri, 29 Mar 2024 23:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753711; cv=fail; b=EHB9GsZ040Xas6rY2umk3Y5VVIVnOrwrJiOJOx4KzsMDOc/yUCpZx0D7xYh0HyJaMeK1GLqpAsqgemeqSs7pcE0EnMYKyfqpJOHbRsXEJaVhU2TjkdhIJcVzw+kZyrEiIzkj6RdfrVZXOyWhEax++v+/M3LQqDwvI9Gjx1iBNcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753711; c=relaxed/simple;
	bh=9jyBlpemJ+zaOj60S+IFY2XlurhbiNkwpys/qaDlJC0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pvsbUJMIwK2jedjopDuu048EvzCjNOoWOZcHiwLVwyQ2c/HwmulS+nGzFI3wTVtHE5rQ1X30RVXxZ8YOl9umiRpRjWV5SiMY0dxXDJkLMtk8TXAY4v7OWJZNluAAnAOPIdOKObo26RTTLY/d2yLUfE+69LViFIjpEHG73Vevr/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v3wKXvjw; arc=fail smtp.client-ip=40.107.101.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmY81wlUdFCd6qo8wV3jaQpwUUJUakr/xhElDtb4kjNcZ/4ud4qHzFbvyK2is5E/FQVnnf6KpoSJfPB/vqd30Ccf2FhoCfDXI3Flrn4CvHekwe5Pj0WMMCtGlUX1zOAThHtPYmKWS+EhXtxktKRLKs9vzCsmBMlIa3UlkqKgNtAr09TMamfUfL4tyCr2/ILa/JWSWeNwiJMEZTVxPRMZROyNTyNvxgY/Jg9utJOn1R9wF0b3vUc8L6Om35NIWCsIrpsjc7baNfF7e7pZFYlG3XWf00lK8VClhJi29NNcum3Y/5WW9ShYx6RPj8zk7HBw6xavB6k6yF18G1x7ArL+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hs6vtIletVIfLiB2vNU/OSS5KUmsbyBS00A1GGOPWuE=;
 b=fDQ/r1H2tcupVeFXRTxpoevdYPnS9V5tEUMt2PifVARe860rSb44h1JzV7HBXzi/Qa+tauDfVRPvxxESHi7bNVgQFQK8+oSVCcdJCaBZSjIM5f/RaNVMl5DgNLnXqoTb6oAIYjpfTPhnpCBh6UfXlT2OIrehx8quKbmDDqFI2F5PjzGlpsEwq7eN+5ChXwW2/twgov5hzJkCOKg5f8aaOlX4B9qY7GNyczJqcEWS/omWTt1ADIV3UoqgRGWNXX2PJQsfeEyyOI3yteNCmSZQ4UFM7JRZeXjkSt2Xx59g3JIBG/IpetFgHZ+VHXuYUdcp5WspzIfEV7aqmXw+la8crg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hs6vtIletVIfLiB2vNU/OSS5KUmsbyBS00A1GGOPWuE=;
 b=v3wKXvjw9sGO5Q1VIWR6cafX4GbqdyINHexO6Za1gY4It3TBXZYnXGCbAiq5Pbui/K+c0x+ycqK9x0mwC1jK5pMRRmjqeVB30nJpOo1fdfptyIobGIS4FXQSWenIcU7+uOTyiUrmaD+bNaiGlZHd9mWhXlgZjpUnwxAtHQcozi4=
Received: from DM6PR06CA0059.namprd06.prod.outlook.com (2603:10b6:5:54::36) by
 SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 Mar
 2024 23:08:27 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::a3) by DM6PR06CA0059.outlook.office365.com
 (2603:10b6:5:54::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:08:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:08:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v12 06/29] KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
Date: Fri, 29 Mar 2024 17:58:12 -0500
Message-ID: <20240329225835.400662-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b111cea-4cc8-426f-97eb-08dc5045249a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZAVczZOg92p/Mb7vMsVAXeZclps4PTA4ROA/eB8m/Ebt6cz0nvCExFaYLsIT9eTIR2DI0gFBnRpDHlAl37yBFuaMVvRuR4G/HnoFaoMZ+y9BR9BDjVH+Tu5oGzDBKdcyBXcfUf1DikeHiI+XoX6uuXdl7hW6iEojbIfhKG/52+tldu+QyRWzjIWP8wJUPGGlvtpGWgBJOYnuLhtF3R2iJi7rV21+zu6qmFSnfPDUfzuqdXl24yakh7krWQYP1RCWcQ+Uxj9arNjb9ls2/SUSZOb7BBkE/xnFUN8VHpsItE4e6jQaTuQ6+uNI3HCrJzscNkvtQkUgcOUqNuRr2IhE+ZJj33roHsh+wzgWwCZovHBV+cVoJMbEve+n+KjXyIb52pRXnKxIOTQA3S/cZZ02BL/C8AyPehOf2NhTTseWtkRZTcoLDg5mpZbJEHrmxacW2FaK56aeXgsOl2WNms/y5vbhSSXxpswVhGVqq4Pc0c5SRJl82kvmkPgFz04JJ0wSjtjRR8ilwv2JwH6b6/U3qpvSKlwbwb4ekcig57BxEInnGRIBCqBR/4T4TMt43zLlbvER9+1mnlx7nAHSjRRfpCl70VUg5idYo/8UHKdePtRNpmLZfsuj23DFDzKBH28fLtIDV67Fe+AiQiUcfK+zQ1sVTohf3wMKw8U/awUJXLH+IRPOBWHnkUdaxcW7qZsGsRPFe/I4v64NYWUzjqOxvCtZz+qSO6ayPa29mPR5i4XKPkXRKTIeJ/EFra94gUR3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:08:27.5907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b111cea-4cc8-426f-97eb-08dc5045249a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

SEV-SNP relies on private memory support to run guests, so make sure to
enable that support via the CONFIG_KVM_GENERIC_PRIVATE_MEM config
option.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 6a76ba7b6bac..d0bb0e7a4e80 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -123,6 +123,7 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	select ARCH_HAS_CC_PLATFORM
+	select KVM_GENERIC_PRIVATE_MEM
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
-- 
2.25.1


