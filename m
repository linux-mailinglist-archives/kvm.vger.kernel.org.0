Return-Path: <kvm+bounces-17346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6018C46C1
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 20:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20B691C22818
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 18:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D974A36120;
	Mon, 13 May 2024 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hmOHVHuP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBBF381BD;
	Mon, 13 May 2024 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715624409; cv=fail; b=tlsk1O6tADaedFD/ww+0QYMlYbGJY11IwUELkFLL4JULdjyt9gEzH9aPqt4WgTsgLNZ1k0SUioHdaikt/6mxwjjvcf8p2SaqiejgEg/KyYYHzSN4ShDQxUDcF5Yfk7Re+GN5hwPfeDvFga2srePU2/ej44M/Z6CazGfK2XBhpOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715624409; c=relaxed/simple;
	bh=IXp105klcdDEAaLR8Ywv1xJLz3hn+QHeyZz15f/UAns=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OlhxM+1AuAfjwZj+CqiQfvjCNHf9Whi3i9BsNSzTeI5gdRmQR9B70VDlyQ96wk/RUwuygpFqrEXWfuoupVyQA3Fuwsuew2mPyw+wJFEMY8G3iNz5h68P1QgLXUY3tf9PeykiCGsFdDvpVAv2pfTnQP/HHGsCIxRqhDtdpUHcbjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hmOHVHuP; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRaVxPf20gUrTXlS9RGYAEfQZlBVpMvs3dhPespjgLjPSqzDy7r7ASX+bXf4hvJ6BPVNLKwRu8/WfgAIS8yZUkk0ZNcU9lI+HiRnP2kfyZCAMWfwHot6SEiC9Q4HAj9eWLaO/pjaJuIKhmUToldT0t1p0vAI1/EFIuRMvArMo8lWpeYnmxmeBEGk7ySqWohThVZdufcNq39e1/d1l6LM07S7ugDcS9OVYtU1hRPXIaRtJwl1y/02n0SOobsckOQ5XNM+GnDviSKy38i9z7/NO5W+VCqmvvUsKmZiHcg1S/C3spl2MoLQ+jicOqP4S0tkHUAt9YlsLqbtV+PAG/GeGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbgyawJm6sz098MO/ajzKlH6Es8z4+0gm12yCzNVxAU=;
 b=gTdf6lviGTJtlwN/fDOgOU4EnruXQ4jfEL7OSlmaPPaL4yD4a5ULcnV4D+dUgB6IAGSeQERdeq0uhzjtxRSBXdPMXRPMe2xjD7e2+LidbrmLI8sEyXK/Pc0j5UsG5TVXaox6Lf9otAZUsviBmXwXBaOgOaoldQ25lT0WBTihHv+FMtxZGpcfBuyTS9nozl9aKfHyH3J+vTZSOjeqCscRvM6Ube7BqVizGboqBdKb30b+Z1LS6JrFziqJ+OosMouZa9Uq1uFvlDlHwL2XckYplNKK8Qg0sm0Xvq63tyTGYUc8jZSrm05ZghMuUOGcjAKUPruP4B1oEryF9NGhQZrO+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbgyawJm6sz098MO/ajzKlH6Es8z4+0gm12yCzNVxAU=;
 b=hmOHVHuP3MKyQnGT5UI9caSaVh5zQ3qq+73eGBChO38YzFB9RP3a27yzoZKLn6X3s7RFdJzjT6uIShlm140BE1cLc9wGvwA3C6TAf7iK7yWbXjDzyNTi7tG1ueo06CHUFYBUFtEG+S5cuzvIxJ97MmPg1pdZPStrAgOPTelo7yA=
Received: from BN0PR04CA0167.namprd04.prod.outlook.com (2603:10b6:408:eb::22)
 by DM6PR12MB4466.namprd12.prod.outlook.com (2603:10b6:5:2ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 18:20:02 +0000
Received: from BN2PEPF000044A5.namprd04.prod.outlook.com
 (2603:10b6:408:eb:cafe::83) by BN0PR04CA0167.outlook.office365.com
 (2603:10b6:408:eb::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 18:20:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A5.mail.protection.outlook.com (10.167.243.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 18:20:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 13 May
 2024 13:20:00 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-coco@lists.linux.dev>, Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: SEV: Fix unused variable in guest request handling
Date: Mon, 13 May 2024 13:19:28 -0500
Message-ID: <20240513181928.720979-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A5:EE_|DM6PR12MB4466:EE_
X-MS-Office365-Filtering-Correlation-Id: 245cd088-b6e3-40fd-c1bf-08dc73794eb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xdFf62ZoEJaavF/Rtdg4aDHDt0ZUoXLBA/kj3Zf/pMEg8Vp40ILMk1Wz0aav?=
 =?us-ascii?Q?S27xgUEMHzOyw8/w4ejlxu0Jzhx28h2WKpCuKnh8JRGr2W+IkdBznU8d1sQ6?=
 =?us-ascii?Q?RxnSoVXno4lCrBHr1lIVWnrMal8HFEDsAzSCfqLw/I9RBeonvWbjKkPBrvzX?=
 =?us-ascii?Q?yvrgBbsdkDkdZVLyyHKlekJx3Op3Tz3UIcJnpJi9fQQ95JQyOz2eDryohwab?=
 =?us-ascii?Q?XuRr1nRpC61FK7CphAt2bLegarKOAIIaJju0bxaDu/QRbhMh4CD12DUschWZ?=
 =?us-ascii?Q?QzbXR3NX+cs89WyhT1jvgPoi6AYmz0I6kk/LnYxVS7QkWhodAvQRLETqYq7c?=
 =?us-ascii?Q?+tJ7GuzjE46rQbpCmZCRK3NDHo8n5a2nbF/YsBmV3r+CBZvxDoTTDwBDgX3u?=
 =?us-ascii?Q?t4fRTykRGfL4jZuXlYHt2NWYJwI7LngIP6xTH5iY7mafEoa96xsl2uQoAIfz?=
 =?us-ascii?Q?QQ760N8qgxQrc6r5/mwaOm+MPTWeoTqba3OFuLiGSKl0k10/a4IbcPTcpf7r?=
 =?us-ascii?Q?QGT/x6Es3CPNQeW81RtVfPfP+I6VFcrbB0STJOuIXOGQRSvf6wZWTPho8R8j?=
 =?us-ascii?Q?iAFn0cIFOpH5ESkMpUsugwkixybPLnb+c6rE1gf9QR6RvuSFHDwelqVt+mg5?=
 =?us-ascii?Q?P584xEUmg2v85c13U+s8xnX3zku/QEBqMqtpEG8tW6B+/SrtILxwLbrVe6qj?=
 =?us-ascii?Q?M/bSo+2SVDzZndvnou8aatqIWrwOQ+5gsfufkNVerOJXWfMGaqQMrvul8Z4z?=
 =?us-ascii?Q?aynUIo+3e5sOXsmT2fB0s1ar7nQEmzlsoRqbgFnQqeOPao6Hw3CvfCx7jEzK?=
 =?us-ascii?Q?rjMU2mNv9BqHdBlxCt4i21qiLI+v8Fy1WABo7i2YgkZZPuG8zSIZa/GJdfId?=
 =?us-ascii?Q?ZiNkH3pDwLUhKwOMK3+fs7Rt+WsQ9+jlLCmTOLODsoupzh/7ZhGiB8kBm2gx?=
 =?us-ascii?Q?n/+Dl5iCFmyh2RqSALZZJlm6q40Hnp/X+2qaUq/WiTMxGDkkC/68TqcDvL/X?=
 =?us-ascii?Q?5SnqAU6dEgJtAJH4K1GOJo2Q4kQZSmluNjNFCDYaIkUb8MKRLTwuRARU1gYY?=
 =?us-ascii?Q?has3gTyOYzrldCFuCcdaOs+0Czl1TgVlHlLzeMWa6OpgvlUtrcy9PbxNZyUn?=
 =?us-ascii?Q?9bGcKdlNxH16suMQoZ0pug2SG0NyZd4LlaKyhycojdPvib9gBto8uLmOlmda?=
 =?us-ascii?Q?5CrxlWSSmKtBSY6155UcHzBGjp2v0/9ZEN/FBtvYQPs731QXErYMAKWLAW9i?=
 =?us-ascii?Q?WrvNlVVuEg/Bok9V/+huIcex35nhTXIzPlgUFMtEvFtZeXJIV1kTLI2aZm96?=
 =?us-ascii?Q?Hs/4geWXlJ3r23jSm7QxPp5e7h0pmDPc5Ije5gCETz2r4NEAi/yIlXpjp8BN?=
 =?us-ascii?Q?K1wa0LE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 18:20:02.8030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 245cd088-b6e3-40fd-c1bf-08dc73794eb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4466

The variable 'sev' is assigned, but never used. Remove it.

Fixes: 449ead2d1edb ("KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event")
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 59c0d89a4d52..6cf665c410b2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3965,14 +3965,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa
 				  sev_ret_code *fw_err)
 {
 	struct sev_data_snp_guest_request data = {0};
-	struct kvm_sev_info *sev;
 	int ret;
 
 	if (!sev_snp_guest(kvm))
 		return -EINVAL;
 
-	sev = &to_kvm_svm(kvm)->sev_info;
-
 	ret = snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa);
 	if (ret)
 		return ret;
-- 
2.25.1


