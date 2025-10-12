Return-Path: <kvm+bounces-59842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C512ABD0030
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 09:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB3CD189494A
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 07:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0153212572;
	Sun, 12 Oct 2025 07:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mWaJR1Gm"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEA221F00;
	Sun, 12 Oct 2025 07:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760253393; cv=fail; b=WFBaOM5M0zDu5Xz+55MfHEoN8Xbsci5JB6i+ZDZm7QngOpc/K4kwj1ily4tPaBBDbql6lbGGvYapkCtuE2deKalzXhwhqgUVwsbDBk6TApqMRNoiQPWpXeFvzMoovLR6MLbJjHWyB5J1PO0MKZB/eiligSLiFfaaYlngcZIIjQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760253393; c=relaxed/simple;
	bh=WCuGq9eFpjNcOdEn6S9sKF1OKFW5aP0ZojeN2zUGjZM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgMxVstxZnGwzrLSL3hBDJSJkAm0IKNGoPUvHlGXfmfPVHzUD1m7rLjUVXIwy0VbKaGAHhQ6+pMcwmWhwkMD0lQfiw4+fJJ59Kp1f/I+Lr/x4/Ekg5FFbYs+ficy9n0nSqHcNjToXPL9AIU5d8+WAGJq646Ais4NJW4ZQ2WHYlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mWaJR1Gm; arc=fail smtp.client-ip=52.101.48.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YFWyHhm4A87mEbwbJoPIpQqpc0wFoE9dWg3C63R4eE7OTB58MSvwYcpXeH831I/JdH7kRLook/dGJzWUZjOFgmeoW6R9FoCisPzglt0qM3hQ0tv42DuZKv/mbF24AFMqSyMI+HQuOdacEkOLMja1CdM1uI8IKSKucScKMZITRApHwa/PiBSrgz+U69l49I+ma9CQrwp6IVJZBbFc/XQIDSkkTx4mse1ch4osh5InnEP/LMSB2Ib7OEYufllWuki7aM10sFV+EStzXxQdXmVUzmsAl3jAnyisjtL0wIBBq5wvrSw3aCB1Sa5SEMp/vyjUOTXsdr7v36xlsilE1Dek3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRFQz9hut+AkMJmBn+s9xdbz26IfbQCH4yE0DcrJur4=;
 b=pQGz8kZlVUAIynmHy0y2YtwdLWXoBQW8ad6YKMkhVPKTIjgJgvWwxmQ2mQPmwe0eZ6JR0TcY0RIPn0RjmJZlBTzAMgUQVEv3OD9oGIFmxXPfw0uYFKMJq7B7Yqb+22aVqU3ZnVz5uQQvEtGKW068gwH/xRzLkWZ0epdD/N8Frhki7RP8lg9a/MpmYv/nN+dHvhp5sSiRdKyxRm05ZmZInAO83MFmlnxIPTLqos8/pwhLkimh+zo5Ts6lauV1zp/0dSli5J0UJTbL7JRLLLEOFbyFT2kyO/DTkw6lfkeOVtavK/6WZMEo1MHxfbaNJADqNvH0hHabYX7hW3dKAPnEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRFQz9hut+AkMJmBn+s9xdbz26IfbQCH4yE0DcrJur4=;
 b=mWaJR1GmjBoKSdGVzBJAOxkMme5Me4K1AXqrOJFuqLOPbF5iQGT6GkNrXjqX3qZV7j71o5JAr4niL1xzOb+XA/jql9bQVwEpWHXH3Wv9PupAVUP+HVqqH+s0Kt8A/F5GqRBEvJNH8wHGRdsgvzavsmptJ9VqNswhxRLFceTmMuU=
Received: from MN2PR13CA0036.namprd13.prod.outlook.com (2603:10b6:208:160::49)
 by CH1PR12MB9597.namprd12.prod.outlook.com (2603:10b6:610:2ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Sun, 12 Oct
 2025 07:16:28 +0000
Received: from BN1PEPF00004683.namprd03.prod.outlook.com
 (2603:10b6:208:160:cafe::3b) by MN2PR13CA0036.outlook.office365.com
 (2603:10b6:208:160::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.8 via Frontend Transport; Sun,
 12 Oct 2025 07:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00004683.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Sun, 12 Oct 2025 07:16:27 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 00:16:24 -0700
From: Shivank Garg <shivankg@amd.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>
CC: <david@redhat.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <shivankg@amd.com>
Subject: [PATCH V3 kvm-x86/gmem 2/2] KVM: guest_memfd: remove redundant gmem variable initialization
Date: Sun, 12 Oct 2025 07:16:07 +0000
Message-ID: <20251012071607.17646-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251012071607.17646-1-shivankg@amd.com>
References: <20251012071607.17646-1-shivankg@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004683:EE_|CH1PR12MB9597:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f10301-0eba-4873-e3c7-08de095f42ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ko5eEqNNnfLi5BViBLiq4YGzHt4Y6tw1BNW2mMDCk6a48M2pZWdh9beJURRX?=
 =?us-ascii?Q?0jLpTizZS/iKO0xpb4xHUNrkuhoBGs/3NkXSGHyqcfBuGA5eXncl2vnyzXmd?=
 =?us-ascii?Q?BuKH1sbmKHAWWK0NkJraCqMmHRgFAgYWDeKWX9+Tsz3NyixsnSvnM/66NC9k?=
 =?us-ascii?Q?UKCfZ7kaCCci+9QFY+rwJHSOypRNuqFRLWSHHMOXHFpFtE1ETpBMM4KFD1hx?=
 =?us-ascii?Q?Np4A7ouqMLHbE1GUWB12Y1hnlTESZKYhg54ZdwrnKrOYZgNWYn2PUQCHnSVQ?=
 =?us-ascii?Q?AO37cAzYOuq4mTQoNbNtYvMyXKSe65RTbYq+PnmWzw3Xv5lg9t+xgQ5L2Xq+?=
 =?us-ascii?Q?5csmWaXMDQfkviSIrTZhtK5P8z6Rs+SGnDazR3VEFs7Jsji2uSz93A1ziZxD?=
 =?us-ascii?Q?lJKRh3h03H44TaCTuScDQOnLOBDsCCb1xKowcZ+AfIWczfp/PdMM9Da0IZEO?=
 =?us-ascii?Q?/UnIPXhozW9OH9k5/fuhfkqEh7ux8kk+6Hq0XtcWCry0D9IeEBC9NG3Z7xe+?=
 =?us-ascii?Q?iGUGADF6hUdxJw8VN8mfkzc4+1njnwuzt6nslPFiyAVJl43YlC/M+S+/AUAN?=
 =?us-ascii?Q?Fl3MW3MuZhOWov7AlOEOWxbtllnHzJzL1Husotu1YzQr5/5OwxhFt+PsnUCG?=
 =?us-ascii?Q?rjlKn1bi3XQwX6bF/ncXJW8K9AqSWzYXSxgw69H4YJSOHocC1VAyMp1djOf8?=
 =?us-ascii?Q?wL5pChR314yS0ZpCxN7faRw6g81BPt7xjA4sAsRdOSL+z/A8M5h0m3GTHK1o?=
 =?us-ascii?Q?XLM5TNsEAB6UUGxm7bloV6fh8ne3e53y0tMbzh1etoNZ18OIPE5OlRzYwtjb?=
 =?us-ascii?Q?Nk04cMpMOB5Is7SOu7IiDWRoWKuEwFbn7r7L5wkirR2MmRuR58HBqRTpP/7j?=
 =?us-ascii?Q?NZqan7akNsucu/I0Aji23AoXL4YOB8LwYYtSu1XhoLhQXjANv9awuW2YR7eY?=
 =?us-ascii?Q?owVbOk9ih8QcY77HQrR9pK52S8veH0RBjCUgISZz4JdZijiSGUuh8SccGcHg?=
 =?us-ascii?Q?62pAO3XQ+8okuBoYeyoaLoqfL7rNWWbq0ollCnddlyDNCIAdSYB4df/i9jur?=
 =?us-ascii?Q?KNmNHQ3URCCdAA5Uj/TpWnjIGGU7dygUGoTFXyeJI2OJNKQGimFm37cg8fBM?=
 =?us-ascii?Q?ODIX7B+ngRXkKtCr2AU2oO/iBRJsPut9mRLuX9HSlu5BEVs0+fLF5+mdgIK0?=
 =?us-ascii?Q?KsdUTP+aX54f5EHPYcNjrm59NTejaYn1nLDSzDKbtrg1lp8KV810WZrgyZFP?=
 =?us-ascii?Q?IanQqch0n9R2fwGKXlBvUW4GtzFuZClczVzfN9DKqEAbSeXvekfx/HqzAtIv?=
 =?us-ascii?Q?lzzeIg3fbJ3HuEVb1QefkRyXp7FRJnPsav3D7XaZnWrXzDUYGl0HLs2wK1aG?=
 =?us-ascii?Q?5BexcZ5P4EK8Fih5RzK1GQaHSvwLSQHl5qAFOFDAxAsH06NM/69yKafsJova?=
 =?us-ascii?Q?zc1yj8qkc+UlONmKnYXfQV3juj2s3KOGCytje8C4ujVG4gu4IJoMYQaQTqiN?=
 =?us-ascii?Q?Os2XpUW91LawRxyxDLQ8jyFY4EqZIT5W2k4KquDoqs7KxpXGYCjGfXvXsBKa?=
 =?us-ascii?Q?PsEOryT2YTohvQH4lyVaCb68yImilxb+Cej7j4jj?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2025 07:16:27.7996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f10301-0eba-4873-e3c7-08de095f42ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004683.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9597

Remove redundant initialization of gmem in __kvm_gmem_get_pfn() as it is
already initialized at the top of the function.

No functional change intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---

Changelog:
V3:
- Split into distinct patches per Sean's feedback, drop whitespace and
  ULONG_MAX change.
V2:
- https://lore.kernel.org/all/20250902080307.153171-2-shivankg@amd.com
- Incorporate David's suggestions.
V1:
- https://lore.kernel.org/all/20250901051532.207874-3-shivankg@amd.com

 virt/kvm/guest_memfd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 22dacf49a04d..caa87efc8f7a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -668,7 +668,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EFAULT);
 	}
 
-	gmem = file->private_data;
 	if (xa_load(&gmem->bindings, index) != slot) {
 		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
 		return ERR_PTR(-EIO);
-- 
2.43.0


