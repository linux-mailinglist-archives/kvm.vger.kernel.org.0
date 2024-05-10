Return-Path: <kvm+bounces-17219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 592168C2BB1
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:20:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B42CB2647C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706B147F73;
	Fri, 10 May 2024 21:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L1CBDA1U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA8013B5B0;
	Fri, 10 May 2024 21:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375956; cv=fail; b=brUnQiHzZigI7WIyY5afsc5+N8LxZwjoGhfCACCuBuoMuKFvmsxLCv4Eskhe6VYoft/vgxWHdLY9WrzDMxIRuEH8gEIJpFJ0cm0o5+NQ1oCXEVLK750Oem79eKwZLWFI9Tw3r+f2CggJttFoiAcH97inQMcZdrWhL1EEV1IfuLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375956; c=relaxed/simple;
	bh=94yTgcGA/ly16/FIngwjmMi5u6ODPosk4CvL8YUcyxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wknb8fCsrw0Eq4wEFRDqQD5ydV/56Q/JtKqQHvhBRIe1/V7qKblqzh3VocR+mU0YmDr9hSTw6LI0+7dUjzSWzP2EsM42yfIsIaFoUak4WnT4k6i2IxV/sgsbbsiRbX+HgPn69V0u8wbV/hV9LRg9p0G4jV9bo2c33LGB4KiG0B8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L1CBDA1U; arc=fail smtp.client-ip=40.107.237.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXVWcCpAtgG43RygsXvYPrF/iIenO6CZ5KUgpn6FFx9FhQrH+DI8npmWhLOCh4EUE9gARydHY+l76qtyQCwv58F3cFKwbroU6BW8lOryph2uK4Rws4g4IiqgnCzaxjQOLDSzw4wtc0KYq7By0y7rUUUQxv60J0XeKB5scVK+pTpRZ2SWxiHhcziYDTmoSawtDjFcQQBEzeYcHsaqZxKTpqYgyxpYMiqv+40OANkGCv3xCwdz491mw+BHlCqLpjQfESTccR8RJA2ItGG7lOKdMLvzs8GUkpGVDsUqv2Wy8WRZlS09n2n4cyIuhHCJNhS9qsAzxZqi7Tf1kWWEVRqldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rthMVXzmZSrOVfdB/bmr414hVb92xCnklO7UjIWGDw=;
 b=gHpyQiKVsEmp6YFtYpGaKDlL2i726H/FzqfD9bQJf6XOQr3CXuWJOBoUn7DAL1FWhlMFxrXxHVwmwETWQlcyr5Hc58V812OH5O5AU9UTQLqOtCj4YeIisNRjdqbxZ6SwIEDmKU8TxXx6U9/JTpRcrLc5G08MDcbA8Uox0sbyXvf8ZfYYYZci4ldS8f5IlG8nL4qClp3t8izlII4b5mYjak5OSajkwPLMdPTemoRu1qdNTpy5Qgs4uDUCBE4C6/ZpW+mTDhB0dgDZKW8epgU6+q8qe2eXQO0zgZiC0uuthwVnS4Ue/csKU9MxAe8FObEC37YRNA7+KbT2JowErF3Zhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rthMVXzmZSrOVfdB/bmr414hVb92xCnklO7UjIWGDw=;
 b=L1CBDA1Uwz0LtpwduH1qUk4NaOpkbLsWDUTC6hXTTzgbYl0TsVWU3mkXWxv3vtceoUd9wb2r1tvmlryuja0PJJWq9ypqA2SgfM0aBoF3sXMNtqh/YJXqD6TM80Ls7t/m0h9aP7/Ruxv1Sn+lCTyPg/enkOwiUpmiWgyO4ai1r1k=
Received: from BN1PR10CA0017.namprd10.prod.outlook.com (2603:10b6:408:e0::22)
 by IA1PR12MB6457.namprd12.prod.outlook.com (2603:10b6:208:3ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51; Fri, 10 May
 2024 21:19:09 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:e0:cafe::61) by BN1PR10CA0017.outlook.office365.com
 (2603:10b6:408:e0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:19:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:19:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:19:09 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Ashish Kalra <ashish.kalra@amd.com>
Subject: [PULL 15/19] KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
Date: Fri, 10 May 2024 16:10:20 -0500
Message-ID: <20240510211024.556136-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|IA1PR12MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f34a3a1-bcea-4765-bce1-08dc7136d4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W+OOe4yggnrTXdgFevbmTZ273Gvtq4w8EhYMhK/htKMGKRBNINQuITVroqOb?=
 =?us-ascii?Q?tjVifTh3a4e7e9j7E0wJBEHyNvD+Y1Rbu5rjn6wYxylH+6T/ktqbNwQ5A8eE?=
 =?us-ascii?Q?Fg1S4J4jO+QKWc9I1dpJSm+FITy1bb3swGf0nAtOaegOzUwP5BFgP6gE8mKv?=
 =?us-ascii?Q?EL/KqEBAeTDpk46X51FEtKIpWh51gTvIsZDbtf/XFd6SllJ1Naa3Yp5iON7h?=
 =?us-ascii?Q?SRW0LaC7bIeIWJ0HOo7Iss6R1DWnyN1CJXEdDkmUb8cMM68ufrKBCVQuW0O6?=
 =?us-ascii?Q?rX0HYghS857Nirmqge4lAYBoDx3Fn+rHXV2nLrrqXhOKK3MlmBPFvAMGi3Z0?=
 =?us-ascii?Q?TJR29le7ainq3M0IPJO6/BYQEIn9qtJSCxFZXO11cQFhsB2pPgNMPZPhiMaF?=
 =?us-ascii?Q?iKAbb+81A36PQZqOHckmwrxDzl19NQsfAwgbv0vZoh7kDg0kl6awYEinc8zq?=
 =?us-ascii?Q?bLSrHf4M7+jZ0ViDjvTDc+vDhwM9Z4fnitGWy1Ex469fBGHZt7oHGU6jHouq?=
 =?us-ascii?Q?k2IyzvsPiz7rfA7SqOiu+l9aF+bcGJphH42qF4wyioRBY+rLF3Bs3y52JGP0?=
 =?us-ascii?Q?pl5jKWHs0t+wRTO/mh867ZcqIOWEKCrtPBWYH8Q0w47WZ/Ewnt8gcVXNI+/e?=
 =?us-ascii?Q?+pWNjzgA1o8Gbv0h0uOdhLehRrsvm7oN8ljq8Cu8jVWs0WmvuzhCzFpPoLBF?=
 =?us-ascii?Q?X8XwGNGmDHjoqQ0yiZxzCaLUqN48+eCpuyamMDu/V5o/yfabSMBgvaVWZBUM?=
 =?us-ascii?Q?idXOGwL4Qbg73293A+BpazhjEPZYL+s2QaHlF9y7LA1CJK7+lELrrXqCSbvp?=
 =?us-ascii?Q?lmtdtKnOeF16NmXOh1H6GNAwbXcQiwWWzOJa6cMOZ17PBTE4Z92CSCxiP2up?=
 =?us-ascii?Q?cYCqbum9OHqZ9//vA7BKFAAAnHp1vA/8DBkwT6kNU6L0CKpvZH6/83wveKuR?=
 =?us-ascii?Q?sqjkXwXrbpfXbi9QHgAVv2C2Lx0eQ+Z/kzrExh050+dZJ+pdnh85IZM5EHkZ?=
 =?us-ascii?Q?TcTei0UsZeH5+v4gy0GWmosDjJJ16LpsuhwoavNQU1fJjGj5cMY7fOS2uX30?=
 =?us-ascii?Q?tD9Bto9QT3YImKThrnI7e3MLcok2oB7Kt8fxGtTp+hpNQqL5CUsRrvHUft3P?=
 =?us-ascii?Q?g7g3m4wBPFNdB2ikJi9p+nRwKSzv5leH7r55htQ3uTczOvwHvhMGx2NyRb5w?=
 =?us-ascii?Q?PFxlmJmsACRLbl2lECs+ZTc5w/bLsqanJ7T6Lv6i0frTXfkFB+D2UbjEWZL1?=
 =?us-ascii?Q?f/Yoc8HEX/UQEdN6SffDSJNbHROJFrV6EP0tofLfCoOAg621oku0VJWUS32N?=
 =?us-ascii?Q?aMtjyxbbI7OcxurTWVp9QcEtByvfTDYuSAA54ARXXewY8IWZiHvJz2mG/Wao?=
 =?us-ascii?Q?DOtfQd0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:19:09.4673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f34a3a1-bcea-4765-bce1-08dc7136d4fa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6457

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
Message-ID: <20240501085210.2213060-17-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d603c97493b9..2b88ae9a4f48 100644
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


