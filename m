Return-Path: <kvm+bounces-56413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090C3B3D8C2
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 07:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1D2C16DCA4
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 05:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A86B923C8A1;
	Mon,  1 Sep 2025 05:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OjZQaXVx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6846B237707;
	Mon,  1 Sep 2025 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756704409; cv=fail; b=C6XAUJM3GtzSwrV2X/y5lO95U9EAyUfkBT8Yc0CXSRltXU+zjpfjFGdMDLR4RGea7oUOtTkgpWy/OIB0iKU46GHxkSv4gX/BILqjHbmCaVIr66hFZXcuMkUXXfkv3y0dSPc/XsIG0so1HrJJfZ1QlZr+9Pgq3vSlAHMHiNtMRA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756704409; c=relaxed/simple;
	bh=SK+nO04lINbWwl9dYy1FbToZ3lySpVm913wk1Koso0A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QEkmwLg4J1iHikRtiNfiwvASOkm3ieZGRImCwZ9bY9L7sBlAY3OA4q1ilUe8q4Rk/eS4d3w//S/Mn+s0jYCaSTj9FXhI/2lFzIVtJrzNnJBum8NQTWdPBW5HJbdmvhTi1SkVidmAmGqqZC10pcwIxJ43b/lz9zE005v8YxOnxT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OjZQaXVx; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjvjUVz00Wd+dUFpEF/nMv9ouuraDXnTrDz+RaCEbIYGoNrGDDI/XZB4UoA2/CJELJEk6Cnj13TOmZAFDcnC8x/LnAvs9qZ20nIDgMq0Yq+uD9tyzg4SfZh2E0LlaHDjRP6Ryto5RXapYC4oEM7RQvZF0ijt7hk1qnNVxzJKt0JFIfYUbooo1OChiObeDs8iHv/PsP5U/Mi+fscbXnZLp+d5mM04yp+52UeJB2mWqu02oA4NUofbuYVUf1wHfTxDIH8pNx4+3k+zwzCvQagODrqH1c5hz6xMFptKxj6gDc0EC1eFGd3IGkygW4o2hV+cj6fmFiPn4tO7Q8DZmxErLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWOvjQIrXiIFZR8ntNgh/yarX/qNVa2fItPvblWY+oA=;
 b=wVFXWrYMlTFrxFJvo6BvDsEBv4hxLPXgViEkJKIZjAnpmbHI9YyHuxO7nkknk6Rb7e6K1enjwikNqKHmK1+WZmM0A9DZSrbx8z1Zwaw7hUA2yWVlIN+ZuyzmWbyFqcjdWlyWwiZHo7h6EtA1aMu1RBylxn+sLKkBcqOktRnIEj7xhytm0rLECKJFa2fsBWum/XOqQVDQ3repqMGjJyaIaukChsdw3Qf37W7mTob8rs8hn/8yGbka9Xtez9iFXukxcqrtGoNotNLnTIb/yEaFu8QvPSpdxIxc8SHRLezX9LIUVpMTLWpXxGlzUVwBwFO6GaZbgNX6zZqyY0JIBrwJgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWOvjQIrXiIFZR8ntNgh/yarX/qNVa2fItPvblWY+oA=;
 b=OjZQaXVxXuNF+hJWj4vHfFV9NZcACatpcqgDbfSUb105YU4+vQOkXxQGItQopSS1EB6C4xI37e7OkMlAsX8EUV4xCf8pPG6aYgX41lwvvabwoZhXmn0iEn9Vq7UAwix/2E7F9FpMQ/Uak4NapDNI19vQR7pG2DWNhKQLkgH2mCo=
Received: from SJ0PR03CA0040.namprd03.prod.outlook.com (2603:10b6:a03:33e::15)
 by IA1PR12MB7589.namprd12.prod.outlook.com (2603:10b6:208:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.24; Mon, 1 Sep
 2025 05:26:45 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:a03:33e:cafe::83) by SJ0PR03CA0040.outlook.office365.com
 (2603:10b6:a03:33e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.26 via Frontend Transport; Mon,
 1 Sep 2025 05:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Mon, 1 Sep 2025 05:26:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Sep
 2025 00:26:44 -0500
Received: from BLR-L-MASHUKLA.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 31 Aug
 2025 22:26:39 -0700
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v2 12/12] perf/x86/amd: Remove exclude_guest check from perf_ibs_init()
Date: Mon, 1 Sep 2025 10:56:25 +0530
Message-ID: <20250901052625.209277-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901051656.209083-1-manali.shukla@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|IA1PR12MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: a26f3166-339a-4fe0-59f0-08dde91823c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mWYbdnPEchLWwaZ5iOoWUqHapjIgSjVSE8tGzkHNJJfeuiewxUGIjsQytU1V?=
 =?us-ascii?Q?RweLjFHDwN0z9XTDzZftWh/PWMV6TP5scgjidaEZSHeO0sQqLBrXXLQUGwgf?=
 =?us-ascii?Q?8tflF6jmVAC1eceSdToxhxIVN1kRz4Wf9b/yd3sUCez7ajZyOkbnG8ZEGGze?=
 =?us-ascii?Q?w7bXib2pHDVGj4e8PUI1KtreHwRWuCFQsPEot81Az+0aODnrJCIKIbCuMTcb?=
 =?us-ascii?Q?/1SlK47yBsqEJACrgRBKE9e5MQXPafWRndpR6bVv4GjMwXyj3E5PbQJvr7ei?=
 =?us-ascii?Q?M57UCdoQGMBANnisU6mSDzSWr3sznPAuEaU0ku7M+QbyVYBIrIpmk3fG86HM?=
 =?us-ascii?Q?IMkh64hKFGWtPoiMd6MgmUZgS5V89x2x6eWUwSlRl8UUUq2PQn1qwrH54deI?=
 =?us-ascii?Q?BlAfqIzLuqxtTWeQJPJ3BWxrMM+v+IOKJNvHHLxSkH6kFJblI/nw1AKUnlZR?=
 =?us-ascii?Q?RJVfS1H+Kft2oCBhR48WFxc3vpVF1qlRGAA77XZcr90KvFqvoB+/QVe0VFEj?=
 =?us-ascii?Q?CtRGTv1BkYBuOa0GsWinJIfPEYBR1pDqiQKEqHICi864KEuKDum/qNoF64zn?=
 =?us-ascii?Q?4zGi/aJS47I0/NemU+uStjOitPuhwPIlpiltnkmixC+GhmGslKNyLe49TpAP?=
 =?us-ascii?Q?WG3jzFv7XfTnlzE1+xeQXVO2kK4A/SIF1whaS5d6L7sA61ZSt9uSiefCNudT?=
 =?us-ascii?Q?ON/cY0h+V1fW+bs2/WCkDEiMetMxqEZDLg6Wy3A5HbV9m0wPmaXjqpSHJVgH?=
 =?us-ascii?Q?XnIZaX+k1Ejw0H7F6ES3L7PgRg6wUYUPXhn6aC1Ps5KNV3gjJBUnclu31EDl?=
 =?us-ascii?Q?Jumf1foDTfo/fTdvQLrV6tIeLHBsQZOjMTFFsTpl7pHXK02NAEifZzXjW5uB?=
 =?us-ascii?Q?tgNhP+hHYE7i10ETHZ3xXmL+XzIvPep5fEUEiUheRcOYchvv7/2QJRTAj/Ot?=
 =?us-ascii?Q?B86HosnusqcBfbfAzcdlR41QBUDFy2cjxxM77+4mLNBIabip67HEqd6ba566?=
 =?us-ascii?Q?qnJZIeRiN8xP9FI6Nw5AN9rMORTk3eC7gLP64BWWwRe0b6hdwrsVwZRY72pu?=
 =?us-ascii?Q?tJoxdiDKEbXakKKNmLBkeC64v7rxqxSOa9b6TDQrN+J0uNhwqCEsHewQDGp8?=
 =?us-ascii?Q?C31vwpOe4sbwoy9WXnGC+knhJTYrvoaBsEOzPb/AQpbd0GGpMVQyKNjsRZKC?=
 =?us-ascii?Q?m5SSh/gcHmMtuRFctePeiciOBUPzmgSaQ9YiE1E/I4wgBbsufLUp7PvdFuXe?=
 =?us-ascii?Q?Bfiad5A+u/LltsYJy5oXKKfRySII8VgCAOz2ezPAvaUl5GJ0Y7bttr5n/XA/?=
 =?us-ascii?Q?PiSKw0BN8xxRTGAhn5UuhXTavGLXnwOx4AJwiuPzQZlLM1BxS2z7c97hLG2r?=
 =?us-ascii?Q?d9J7k17073RpbNP9qX3AU2+dWd7Ych7KCLGKIwUJBpd8AZ9Vx6ZttGuEaFuq?=
 =?us-ascii?Q?v++9MSj/Y7w+PdjhjG2wkax5LbfhsYZ47YlUyyoiCQO4nCUI7E+eG9uA7ttv?=
 =?us-ascii?Q?6V7T29VhmTt5IZZgP7/ldP248YCZMBMZRpQ8?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 05:26:44.4226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26f3166-339a-4fe0-59f0-08dde91823c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7589

Currently IBS driver doesn't allow the creation of IBS event with
exclue_guest set. As a result, amd_ibs_init() returns -EINVAL if
IBS event is created with exclude_guest set.

With the introduction of mediated PMU support, software-based handling
of exclude_guest is permitted for PMUs that have the
PERF_PMU_CAP_MEDIATED_VPMU capability.

Since ibs_op and ibs_fetch pmus has PERF_PMU_CAP_MEDIATED_VPMU
capability set, update perf_ibs_init() to remove exclude_guest check.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/events/amd/ibs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 6dc2d1cb8b09..fad2200ddc72 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -300,8 +300,7 @@ static int perf_ibs_init(struct perf_event *event)
 		return -EOPNOTSUPP;
 
 	/* handle exclude_{user,kernel} in the IRQ handler */
-	if (event->attr.exclude_host || event->attr.exclude_guest ||
-	    event->attr.exclude_idle)
+	if (event->attr.exclude_host || event->attr.exclude_idle)
 		return -EINVAL;
 
 	if (!(event->attr.config2 & IBS_SW_FILTER_MASK) &&
-- 
2.43.0


