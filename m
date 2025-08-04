Return-Path: <kvm+bounces-53888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2202CB19E87
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6EDE188A7D3
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADF7246768;
	Mon,  4 Aug 2025 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xH+A+soL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C939242D9A
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298627; cv=fail; b=C3m0eTnAvDSNZtCGq/OnSYjXMtzPONb8ueATIXtMGokSIJ5GdA8AX/ypSXAkaVXd3lnScDsYi9hnGqHiPSSPrjCT6nZGUgoJzZTqy1l5SGy3/Ms6joMxugNtqVKtx/irWaafoXxGnk7OGlvbrgNHOrV1yXzyZlx0ZzYc4uMLnTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298627; c=relaxed/simple;
	bh=OAvynG9HzpLED2e4IEXLvKOXtxnMsdvQuD2MCZmFw8M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eTM1WY7vHKSl/IdBkOqGQTWjfMvq89iiEAB45v4Et6OA3GXM0DN9QIuPZZ6/JPGmrcrFueY2nQApdfYhOnxv8qRZ1EzDOqC1iYGSlhFxrlTXxudJY4Nc797t6AyoaXzE45OZydn1V7hePp4xqidgSA36QjRYWCxhe8ZEfJkn5hA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xH+A+soL; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qsHcoJXvPbQdxxN/fjmcygXwIlG7yq6X4iSNFgBOsj9I36ZdzCIBav1DunPun2X+Z5lEogRkhejJgRzetwDQEUb2bNQUmHx0m0LNoMFHWNKHbvdGIxUVFr1kXNvWOLnOzp7d790lhMzi8xd01bAD9yb0wxGq22kE/LXJnC1eI1FCRUtfLeCat5yAUVnxhBiaV1Qd6s+sHj1uhaghE4KOTj3LGix9bsWD3hOUduPyYph0CnRH7G3yh1zPXbh+pTDExNIYTR5Ao65jj7CcsPrxCtulN2Qh6H5WpC+pXfATjLPP0RNjakzcO8pZASyu0EFWZjRnydZOUL4BlSwuVtV/GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EdNKtk2kxi07YxpvJY9KBItSSLbt7FrJJztHrdCNGw=;
 b=lHT6QOnQtwpR7D+vC4VzYEgNVD+5Jwz6yiyW87l8cIgWxo766ng8zSRsj/14rgZVhOq7pDjCgBkf9NcnLM2HNI9Er2HstYxCr0RubCtrQOqgJNMAUvJbRviy4TM9LhPaIufeC2UjAHmfNfvTLptLzzVjzztP+/DDwsV9n57AazTjXo9rr3f72cf3SB9pSW6R7DDG5ruG5fC39GUWwYNIxUpF40wt4aVAEtyv+CVjMH+Ei/fpbXHf7P1abL0rS6hOLYcnYNUc5buNkWqEFV8X/MgJSY/rH9AxrTMEOaiCKoolhvO3EKYsQI+c4tz3miD7eOoHJi5szAA8C8gv5nWbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EdNKtk2kxi07YxpvJY9KBItSSLbt7FrJJztHrdCNGw=;
 b=xH+A+soLHOX74204XottIlj6zzVlZvVv/P4C9OyPibGIXcC3xg5Ku6B/8zCeR12FHcm86HeXkSBbO94cRMtrMg+WL0CgnJ8UUlgs5EoNsKxquANnE49NIIkk8medZXzxG1ugX4jAUNyGyZQ92RuE9M+zR6LqE/oVHkwXhGco/qw=
Received: from CY5PR15CA0187.namprd15.prod.outlook.com (2603:10b6:930:82::6)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 09:10:18 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:82:cafe::a4) by CY5PR15CA0187.outlook.office365.com
 (2603:10b6:930:82::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Mon,
 4 Aug 2025 09:10:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Mon, 4 Aug 2025 09:10:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 4 Aug
 2025 04:10:12 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [PATCH v3 1/2] KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
Date: Mon, 4 Aug 2025 14:39:44 +0530
Message-ID: <20250804090945.267199-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250804090945.267199-1-nikunj@amd.com>
References: <20250804090945.267199-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a3a80d-90c6-4a47-bea6-08ddd336bb7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fEoA7PfdTBz7tGIGkncfB0bjnpCX8iJ+sko0ov4G0qwizLdUwh2w9dfrgwjw?=
 =?us-ascii?Q?pz3BG9+TwezZGpXBRGp+PU7QLVGndLma4oURwtv8l/AgT3HxZ9H5qbEIYDfH?=
 =?us-ascii?Q?Wfl/jySu8axpAOrHABCpun2/NcBWiS0X1Znj8IY6kKJUbIYO3Z8Qxh8z21RO?=
 =?us-ascii?Q?FJoJAmdgyoea7Lmug3lC+8MY0JEuftBgFHwlbQ7ix0r03ls55NQQJi7Dcjha?=
 =?us-ascii?Q?yqt5WYaXq03wLSRUgpjFhC1kTcVLq/WYQ1MwivT+HsAF+zklbdOAUmYc73XS?=
 =?us-ascii?Q?mFhBwYjaJ8H0lZvIGYCLgp8sLCoW3uWkMho6hcgrsfQburQu8R56GmpwcPbp?=
 =?us-ascii?Q?kepkaGakoRRZvlS+vSsEVnsLbo7mR/PFsZsqiwoR0MEuzrG9OSSjs9hJo9ve?=
 =?us-ascii?Q?KB3/Xpuu74pajRf+LRw9ucCyXucwexhv+NbSUptuA5e+OoBjF1qYV4CcYVkO?=
 =?us-ascii?Q?kCSdhpXAdTgAKbOh9cpx/1q/gSQw9ynHIodbV5nGhww11yjo3gTL30a0YI5+?=
 =?us-ascii?Q?RfLACHfLXNPmqQY/wc4umnAVzda6tlZ5DxaJWr43LGhAHjzWsSqtCX112yQE?=
 =?us-ascii?Q?QyvIt9NOAE3JviD1OtKa3G/xP6ilNRZN48ELOgi1PyN9K0PH5K1SkCIKHKk8?=
 =?us-ascii?Q?bdD/5mxHMJY+9PiSyop7pxyt2gxFRLtLGkZ9S4ZU793rXOE5ke9RydNREp0/?=
 =?us-ascii?Q?31NfHc2aI86UD19KPP1YBkQ0A2tcFgbkv7c6vy/iU/vq7zFv/s/tZffnxVph?=
 =?us-ascii?Q?8D+npCQNESeUeJ+V/QuzcKa5YyxkqJsg/oJw+FTXLZSFd3vwyEOhwO8wdLrT?=
 =?us-ascii?Q?lfbYh6n/xWUVJS8FE4vqgOdlM8ItPO+jze0BNADFBYe5T7GqJ2/zhDjpUaeg?=
 =?us-ascii?Q?7tz4jceJVhyMHFkniguve/93Geqz4dPMVXHSfPnBwRH+vJSNnkXwXWwfQ5Pt?=
 =?us-ascii?Q?+628/Cp/PZMDiXHRF5r9S9G7EehSubQU5f2SHxxN5vrI80lrGjWp/ixSjlZ1?=
 =?us-ascii?Q?nxj0iJ1ILJvEU3Z6Dy62rvHITNirYuAGGj0OXZUKrLCyYdi6OXM3Eyzmd5t3?=
 =?us-ascii?Q?h+s0QqxatkNV5mkn/kqXpFxxUFdvoglvZN6hd43NLTmY70HewYVouuPEy3A2?=
 =?us-ascii?Q?ki2M7YF9Ct7/iTEL3wr28DsEQU2I83yML/YRVmysNL3FhV1hwZdtAEkUQdk7?=
 =?us-ascii?Q?H63gx302MRWgjE2B3cA9FZtFl/pSmbmdV6uNBXgiWenpLijKd85/R8ue1VR0?=
 =?us-ascii?Q?AvZ1sy7q12ZHBstWotZKTOCEtSVO0NTUI3Xrid2+fEK7k+lTYkmmpeurs7b1?=
 =?us-ascii?Q?iLIoFioDXpkkozsbYJwbp6Au5+ZPZsKRFPqRAy0KN6DI1matSJPPuym0DIxw?=
 =?us-ascii?Q?rs3F+mtg6/rSrZTgvwgJPQbZZTZPkcPYMhEtz86ts9b+T5/1dQ9p+PhrQZ8N?=
 =?us-ascii?Q?R+ajFVAh3e+rb40w5hpboXPvMbwXG68i6PLd1tupT2LyYe9LNwvpVOb8f1MW?=
 =?us-ascii?Q?olj+71+DIZRoxMvvavPsaJN80vPGd6cUDPGh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 09:10:18.3012
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a3a80d-90c6-4a47-bea6-08ddd336bb7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989

Remove the GHCB_VERSION_DEFAULT macro and open code it with '2'. The macro
is used conditionally and is not a true default. KVM ABI does not
advertise/emumerates the default GHCB version. Any future change to this
macro would silently alter the ABI and potentially break existing
deployments that rely on the current behavior.

Additionally, move the GHCB version assignment earlier in the code flow and
update the comment to clarify that KVM_SEV_INIT2 defaults to version 2,
while KVM_SEV_INIT forces version 1.

No functional change intended.

Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..212f790eedd4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -37,7 +37,6 @@
 #include "trace.h"
 
 #define GHCB_VERSION_MAX	2ULL
-#define GHCB_VERSION_DEFAULT	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
 #define GHCB_HV_FT_SUPPORTED	(GHCB_HV_FT_SNP | GHCB_HV_FT_SNP_AP_CREATION)
@@ -421,6 +420,14 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active && data->ghcb_version))
 		return -EINVAL;
 
+	/*
+	 * KVM supports the full range of mandatory features defined by version
+	 * 2 of the GHCB protocol, so default to that for SEV-ES guests created
+	 * via KVM_SEV_INIT2 (KVM_SEV_INIT forces version 1).
+	 */
+	if (es_active && !data->ghcb_version)
+		data->ghcb_version = 2;
+
 	if (unlikely(sev->active))
 		return -EINVAL;
 
@@ -429,14 +436,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->vmsa_features = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
 
-	/*
-	 * Currently KVM supports the full range of mandatory features defined
-	 * by version 2 of the GHCB protocol, so default to that for SEV-ES
-	 * guests created via KVM_SEV_INIT2.
-	 */
-	if (sev->es_active && !sev->ghcb_version)
-		sev->ghcb_version = GHCB_VERSION_DEFAULT;
-
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-- 
2.43.0


