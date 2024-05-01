Return-Path: <kvm+bounces-16314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 583BB8B8730
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D952B1F2428F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271E6502B2;
	Wed,  1 May 2024 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lhc4i/Iy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE0E50283;
	Wed,  1 May 2024 09:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554315; cv=fail; b=Q9+ln2p9m2IOaJ3y/Qke7xTRRMCi1PREsOsKia4MaRHXyLu4ghP9YUyZLARxrUakVNmrv1OnC0K/R1ihzMkWSabwWAK7fytmTeg7tk7kAczL1g11XI9GjIznh8nDhN5pX0foaJYwfIl1IcOJLN8liwTGgz+2BXD1++z4aQ5KNHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554315; c=relaxed/simple;
	bh=SlGqphJ5aFaJcRjcdzvzVwD8OjnQRzyqkLhLSvgNfIw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRWlKjsb+htiUON/Hm7sFgmAlba0FilH9XK8kC6rN7ac+pe4uZpMFTEFGlsCUdy8j13Al2hH0mgva9pH+rR/F/FwhwqqSrLAsWKcFawnaXiKDsftmspnRwZyKo2Cua2a5CQMEbNHxUJLhfIj0wB/YI0hkBX4u0gOE3vloBOYnHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lhc4i/Iy; arc=fail smtp.client-ip=40.107.236.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGqTL+/a1ei8TmW9zsnae+oZbxhPQcuZvK54/zYj2IXBs5JVU+0C93l0mNyghvF48LiT9dN2DSW+7g1gP7WPSW1n6toAZylUgbDuwENiUYydOOO5eaUo3eCedNYj8dVI8iJMmbuD1qY+xQdhyEUYRMp7zeVRYFl70tnLfFfVkJwr5pdY5XHB2LoEu+4rO0BCxA0V30vFxLRIwFA4NFgid2z5Za4JJbdeFRSzeI0FwhvOotJR/5BswAkWyD99ymJTS1AHDwAqXKWE1ENUOiPs6ReWfnxivufUpW6PMYoB67n56lkCNZbZya/MSAaN0rxOyu7RvPTp7qW0qMQJEpFUZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RY+enspJL5gaYp4jenQZ4TzSk3E82OmppXhPjsVB6o4=;
 b=H1viPb2TbQf9vDgtH6KOQ472zmC0rcVYqHJHlefsfDsKX0d0vpziwU7TD2+3OoK4IDafWolVjwuu3f7bGZV4QyKVLkug/c1CdvLvKIAf7w5JW/6/nE8ECPQiOd6Ru+g4xDwqLsaG57YShZor6foAxSrSzpVTjr/MUMWODIYaRiYdNu4rGjw9czxPlNgMoOGMbaaNcdGsRjZaXj2MQVVUPArOzuaCnMqOmaBDrbXJ5nO0H88tmyNyYAJnCD/f0Q2M8D65kfQWRSAKAjmgUS9g9pgQvT6QRn3tGd2WgFtcadHV/wlhqENxlfEAREISfQPmyYnm+eXeg0icM6RmKTG80Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RY+enspJL5gaYp4jenQZ4TzSk3E82OmppXhPjsVB6o4=;
 b=lhc4i/Iy930I+1DDrpTX2BWCM2fWLehn2UkBVWL1/+rRetesGWacU9xyGa7PF8IZSrxstyN/miMXc13fqcnZf0ZoFKaWvc+UMK+vqSgRlZLP6vA3aEaTB4KJgyHKyDhMbHSgH2z7e8roEg72+7vkTgi2H4J0iH7SSgqtIuszg3E=
Received: from BN8PR12CA0015.namprd12.prod.outlook.com (2603:10b6:408:60::28)
 by SN7PR12MB8101.namprd12.prod.outlook.com (2603:10b6:806:321::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Wed, 1 May
 2024 09:05:11 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:60:cafe::90) by BN8PR12CA0015.outlook.office365.com
 (2603:10b6:408:60::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:05:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:05:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:05:07 -0500
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
Subject: [PATCH v15 16/20] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Wed, 1 May 2024 03:52:06 -0500
Message-ID: <20240501085210.2213060-17-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|SN7PR12MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e60ccb4-a7a6-4f96-35cc-08dc69bdcde7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|36860700004|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7EXutAV9z67jxAWXY+EEe0xFLLyq3DxCCTrXd2Gim0fkdxNG0DkiyHoI30K0?=
 =?us-ascii?Q?XCenP1WOnlZsL9C9OjbZcbmvFGjnrKXCv4bg5tZpXFLukuLFiYx7FEzdfFHl?=
 =?us-ascii?Q?eFg3uhfB+ZEZow5mmTOD5QPVFavrzHgrQccpzsm4MU+Ytwv2XiTNeUO1fg59?=
 =?us-ascii?Q?/ZDs/FVFO5KCwj/O/GsrLLGJhdUIvbKxNLg0oKFcSi+ZIyo0evUw9RVUnipa?=
 =?us-ascii?Q?q75/MwM5wLwKIJriVGRhFfcxhhArV4TboRHLpQMa3gJd4uKvcNlXrQ+S5g9l?=
 =?us-ascii?Q?MOCqic1eKsq/NFZVOn/hxaL9XG15mVbpLYIDWCbkJIw2QL38dt4T+9VTLCUH?=
 =?us-ascii?Q?VrUyAa3XL9PwZUBs4SfDHua6yIFwQVljDdjbBdXZqiJQjYHfyMEvtwTTxylM?=
 =?us-ascii?Q?ol2xWxdeFPHHh2AFz7InoRxrUzQyjj+HMJzd9B+lK56yF7PVwW03RGjv2iUX?=
 =?us-ascii?Q?IwroXcyZSDupKdzdLeXIOrq8usfYE8o0GQx+pvjU0TYeAQ2qCs8xsp4AvRvW?=
 =?us-ascii?Q?kEVwPGEetIKKXhvdsuaVBSEaKMh8b9azw8ji2qEhVK98WaTkrayTWvK2C0iv?=
 =?us-ascii?Q?f0s7YsGaPAL2ohhZQmxLrPuN6Nt/kPYYwmf7Y010nk5Hy8P64E58TfEljGXW?=
 =?us-ascii?Q?S/eb4yvm3Ol3eaxjYI73wIOPEYKCemOWmXlmLvNcLrKkSWWDy8ZTtDqNuWdq?=
 =?us-ascii?Q?mcbo/Ws381xLQFSmX43dcBFqWDwvvvz8KL/E3yvKjMhBKZoRuoRFEclYOun8?=
 =?us-ascii?Q?3xDFDHjIjODGbCYzMBqKw0Is+a0vfTGAdvPsUd1l3GSXXbm83PBEZfpvjsY/?=
 =?us-ascii?Q?hdYE7k25CXExVOt4kep7Nzdszp9AWThZbu2zG6qX8gQth7JUh/psFUfrDSPk?=
 =?us-ascii?Q?9xHorGqco73XF0KH62+0r19dRYhqKAFYlMjocD+Cp2AFi12RkNiGNMtLldAS?=
 =?us-ascii?Q?/N1c6/Oqiq86lgE5N+A92WwYBO0hoph70mS22EDmskMBqWzQpTFJufRrxWfM?=
 =?us-ascii?Q?VBfnd+taxz3HDlMSwT0PgIfIzgn5GF4HeatyOjb3abekS+rYdwprZWaj1btH?=
 =?us-ascii?Q?Nm3PKl/6KA3so+Rqdu9tldYjF30SdjJJ8/4m2ng2S3qx5Z/N9TQqg11ioijl?=
 =?us-ascii?Q?C9AgskkM1SAmUFCvd3zNFzc893lnEoob6pQuPtaCpmEyoVXW6GvJkUgiKoWE?=
 =?us-ascii?Q?GKiymObP5z/bkjdLsVTAnbv5PvnrhTrliV5UmtYhTmQddK28r9fmGKsm2AlH?=
 =?us-ascii?Q?sLd5jkGaU3Z8UwyWzPb1j4sSlMEvC7pPezP6Cg9T7gcQXGTPkzJC9Ts/qxCY?=
 =?us-ascii?Q?owsEQ0SeSz/eKG5072C4i9Mc6SFsRXncH+QLN/9YHLKgMa1wih9F68n6tOrc?=
 =?us-ascii?Q?I0GGT9k=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:05:10.3203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e60ccb4-a7a6-4f96-35cc-08dc69bdcde7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8101

From: Ashish Kalra <ashish.kalra@amd.com>

With SNP/guest_memfd, private/encrypted memory should not be mappable,
and MMU notifications for HVA-mapped memory will only be relevant to
unencrypted guest memory. Therefore, the rationale behind issuing a
wbinvd_on_all_cpus() in sev_guest_memory_reclaimed() should not apply
for SNP guests and can be ignored.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
[mdr: Add some clarifications in commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 224fdab32950..e94e3aa4d932 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3039,7 +3039,13 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
 
 void sev_guest_memory_reclaimed(struct kvm *kvm)
 {
-	if (!sev_guest(kvm))
+	/*
+	 * With SNP+gmem, private/encrypted memory is unreachable via the
+	 * hva-based mmu notifiers, so these events are only actually
+	 * pertaining to shared pages where there is no need to perform
+	 * the WBINVD to flush associated caches.
+	 */
+	if (!sev_guest(kvm) || sev_snp_guest(kvm))
 		return;
 
 	wbinvd_on_all_cpus();
-- 
2.25.1


