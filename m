Return-Path: <kvm+bounces-18480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D54488D5975
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479961F25A90
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400BF79B84;
	Fri, 31 May 2024 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ztUaIbIr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5C26AF3;
	Fri, 31 May 2024 04:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130040; cv=fail; b=gDasfRqBiJQ5oSkbb9lbKwEvgTlCk2XpAojru4/hiBWntNwDug0x3ypqBpfUdfU2YmhDAZOiyuOSXv/k5HL08DF/c7yRIE1ami8xlCjvvdUHxThxiNA1dImLMN3nbQ6mM8Jl/w2nBOtq9HbdyKNbzilw/lO7ijHcu27yhoUht0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130040; c=relaxed/simple;
	bh=ccu/iD6nItxY3BYgOpxo6AYx5fNxf7HvItDUSewofT0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5KL+KoRnrm0ELRF2ZeLw2ypXtsT/F4oBfiQS12duSkB7C/E46HKWk/VkkiXEcJlXWHs4VZCSc9bm6gMsmJDsE75fB8B6N2uUJILUAXifvMp2sMAxO8JY+ndCr6N21HHSFT+5vxIvgc43r1OVjGfB7Q5wFsjJdK5mxkbu6F7qcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ztUaIbIr; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAVSGuqMWPQSIRN9soXrCqrg5TMSnvxAHMgSHrH07lbfpL5sHoYaa7nTCuuvT9etSOWJz0reAI0Kq8rLRnPj7PBXXxKFvomQUcRPFNXj/dbBA80TV3NwdVA93A0L7A+ZCBzo6KtcSsRVvNqlr7V9rv/kSdVKldj9H9ToPkXqENbwPEZCy2z4S3o03p0RNzQMuKUmt3U/KXRrwe1Fu3PLx4UiJsuOOPo2ITxShAzp11uBAoD1y732gTofQiKAB69PG/PVR+TqxjC4EwxiwqMXAS7R0D4igBtiXZRq/Vc3M/1/EjPj6QrcKbBcsudy5UySe5p5z1oZF1wktvbWyx59Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8q10YdaCRaxRK67WXaizn8btLQ9ZFTUZ6u0E1DkQSys=;
 b=f3R62ZJYclKobxJ5d+sz7XecYq+Vm972CFXmNerfqF3mBQaU+PbbOykoJEZ8rB4UR9H0KJCZctV/M7sq37i/MBcZldd9jXA2MXG2mcqj97ddNBeCseGUbDcb0Vr8+JtJSKbb1meaSDyyQkBfYlyLyGJ+owxjQPPBrtM2/a6GMN6DQTOK56w5AwFm7y75yJLUJg/i7najqEb0+cc+gxV26GRtVDWdraUYjjCQ+4TgOobvg11DblkywTuP/+D3b+mBsHOpH7DeNnAGZoIXUsFDTGWBY58VcJusSYyN4ptIyuSSy/PgDoY6D1WgDLU20HtYHPHG8GKWJj2LdZh6xqWFMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8q10YdaCRaxRK67WXaizn8btLQ9ZFTUZ6u0E1DkQSys=;
 b=ztUaIbIrM+abbltXo6HmTsT/s0gzU9OohYRv6CV/k5fx2YIfIxZUUSzqusLD3gkl6GFOKpWZ7NpOooHDx487/qLvFNjqDDCT8yJuGf6OjNtwvIz6/qt+3l4CshrVpiUPpmwu4SiqHqPDujA0jgzH9DgAVVadaG5Moemopxbjd+w=
Received: from DM6PR08CA0057.namprd08.prod.outlook.com (2603:10b6:5:1e0::31)
 by CY5PR12MB6228.namprd12.prod.outlook.com (2603:10b6:930:20::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Fri, 31 May
 2024 04:33:56 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::6f) by DM6PR08CA0057.outlook.office365.com
 (2603:10b6:5:1e0::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23 via Frontend
 Transport; Fri, 31 May 2024 04:33:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:55 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:14 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 12/24] x86/sev: Make snp_issue_guest_request() static
Date: Fri, 31 May 2024 10:00:26 +0530
Message-ID: <20240531043038.3370793-13-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|CY5PR12MB6228:EE_
X-MS-Office365-Filtering-Correlation-Id: 6019402b-64dd-4896-82a0-08dc812ae20c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|7416005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SJPOiMzZV7qilS46OZraeknWN8Zh4+C/jyUFrUEVCW4SxWiTZ2Jm1Hkf6h2l?=
 =?us-ascii?Q?D81l5/fSLZE+rXl0GfgZGZ3MHweICxUJVk3jZjdQoioTI0i6BFRHN5LyljbK?=
 =?us-ascii?Q?OlnIot4PwGtqiR2m8rArJEzyXOir7/ahqo93xpqdMGjr+wKKFDPcfxXP5Mqr?=
 =?us-ascii?Q?IRhNSEx8S8jSFoGjJNwbH6+TuKNvfKjlxf/fPoaImBnJ8Z1h+Xw5oFgiCjqh?=
 =?us-ascii?Q?xU/1ftFzqR9UwE9qwcqkx2Tx3not1BkS3AaA6db8uvvtzF07tZ9oHVlYnu0R?=
 =?us-ascii?Q?KHVpJJzs8/TZP2v+u7eW+smofTQBQtquR4SbxuRRCMeMdUG9dH+dmZiaQu+3?=
 =?us-ascii?Q?6GC/b4BI6/Y00xmY6vWe2AaA3uInAFqo2osUeDG0uaaa4n3IcRg/YiBrEA35?=
 =?us-ascii?Q?qNVOC4ghp/0RHRrjqWMhYOEPItAHOYWI1Tx2UdVuZl6ClAsNcIseSL+wdHgh?=
 =?us-ascii?Q?kisrhjm9cTCqt1rxgXKfsiDsouzTMh2coySx5q8slj+e8XvzVwjAdIfON94w?=
 =?us-ascii?Q?N2mGVBkRuTSYH2K8iHhnVTxqhlEZTSbSinNidsLCldb6VzLx7dJ/cXpPmwaq?=
 =?us-ascii?Q?LXiUSF7MQR24Mbzd5MeR+9ndXETZjcmdqbfYY72zPGEWjmoYSYt5dOSS67Uf?=
 =?us-ascii?Q?54f738hIJANR/fflpF6K/40OXDpwfVnvx9Z7POFxn9VUtR3qUMmC3BirVqOi?=
 =?us-ascii?Q?AvTMzuB2KDGWXiZdPbFlVGyZUNsDR8ilrZuI0/bBrX9PXp+Ok23zwoGoCNxv?=
 =?us-ascii?Q?rSg8lex1PoknH/3/dUSls+JVoWR184gsB8RwtRH//MF79KcWhbOIZRkvFTFW?=
 =?us-ascii?Q?EaHk25UIlgAaN2JPjGFhQndqUtVbUnW8jHHLw6x/6Qv35ldOoh184t2rJOr6?=
 =?us-ascii?Q?e75Xq8Ihz0SNtOeKFlKhIJRPYDUWQGPCyUlPZudVS7KQPWfEVaWfP9m3bHQp?=
 =?us-ascii?Q?xo1IVUlOwvt94tZsERckNIdHcwZpDB0Crp8vQfZW7CfckqxOENnxCTwxR30K?=
 =?us-ascii?Q?6IqACBARPM8SRTvAC0YKhzekWPAN4UtYoCHHuwHWCPP9raGzz7ZSyrMtwf36?=
 =?us-ascii?Q?G01j8sOA3tbujKCZNvTbUVf9GzzDEEbkj0GV6iDZdDMK3Z2cVeUyQUtXUc8w?=
 =?us-ascii?Q?b+lJg/W/WkuFPS/IIvd18aMGZcjecBVCOcrnwyST0XTNPfFZgvzqNfkLaSvu?=
 =?us-ascii?Q?wLM5U2LebPO8R6ETXjItrgxVbarRLAYal3N2FDj4B3QxvnpyUWYvGs6KmSE4?=
 =?us-ascii?Q?i4tatWiser5GzzLCL2dONaIMUINYQ1F8MgGZUHzYIleCb8MdPf8xSw0V9f9B?=
 =?us-ascii?Q?cRmx7/SivjvNmJ/ahu4bGTvYwt24uffAohPjzbrKsk6TkuAxLzDTg3tQYQCj?=
 =?us-ascii?Q?r+GzOajDyPJ2qQF4jzVjBC+cFTjZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:55.9910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6019402b-64dd-4896-82a0-08dc812ae20c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6228

As there is no external caller for snp_issue_guest_request() anymore,
make it static and drop the prototype from the header.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h | 8 --------
 arch/x86/kernel/sev.c      | 3 +--
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9c5bd8063491..109185daff2c 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -318,8 +318,6 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -382,12 +380,6 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline void snp_dmi_setup(void) { }
-static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-					  struct snp_guest_request_ioctl *rio)
-{
-	return -ENOTTY;
-}
-
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index c48fbc3ba186..c2508809d4e2 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2192,7 +2192,7 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
 			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
@@ -2255,7 +2255,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
-- 
2.34.1


