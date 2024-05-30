Return-Path: <kvm+bounces-18402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E558D4A34
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAEFA1C20A93
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B243B17E46D;
	Thu, 30 May 2024 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="V/zkpIDV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E598171658
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067817; cv=fail; b=L4NK9dv6q8hc3ak/a4nF1zU1VsRo47gjZ9cwffh4Vhq+++0NIpUi/uz/axSBaOySEQgFZz9H8NSzePLK8HMBBO8zh2dq5tXKd1hi4w8zt3f+kbm4y/qhvPq7CkDeZhXVCmb/nxdD8wzen+42iZxE3G4IRPcaBWrfq62dE1M9hVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067817; c=relaxed/simple;
	bh=5aZt+CHlBJLu84arZWJL/fAUg+05ZGyWQPlwCsGfgq4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYnlMARny+rZcoezWHRoSgvybZyb7MMujN7B4hfOoMBDZsViM0R677B+ZnxnqrXwOv9lAGiy1rXGOE5/AW0Xa3EE5iJQa8bCLnBaUWOVLQ/t8BaGK703UxqFEvox3j0L9mlrDOxXulo+94mcBYWvj7/sWhFYl0u+5l4DcFI/YcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=V/zkpIDV; arc=fail smtp.client-ip=40.107.223.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmOdtJt2gRyCeg2vfp4TTZB4sgev4CkAzFJx63V3IWjVvgDHRvkIdp0oNPZxPA1/eGO03w7BGKZY463V0VUvJdlCHJOnrpoi+R8jwMroyUngq7OtvOE87IQc4TFfCrK6XEnNeEZKP8Cekvo9xEkZFykXHMBlUIyt/EUwrDQilmH0gtVHhDI81T+OAuVTa5f5zT3NbbijUtg56MHOcWM5A2yviI6LV5Ml+p2VQ+9j2SnMaREvjDTyo1mR4bNgenAJZuP2Sby4hmxsEroWQEvgsFShtExtNwLwTXRJVkDVY161VtYcdFkUP3sTTduHxevhOcrA37Y5k4jxrkfA1plLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jPt2T6cryWo9KjhitSay5ciELP8aw3+zeHDLWWGJf2A=;
 b=dyxfglWpHJPzHg50hHES/aL8UdTwMW5Udcz6hlGHi/VbRVnayYn7yIrf7a0joE1TvQIcV5Pr3/y4ah6lAJaK/Y9pxyrrlYl7UVkboS+/0kTeN9qn+mR4wBBrPM19PSn/ozJ/gNRPDP3jNRtDr7zmAgoysRRoquOzECV44E94Yw85xA9AnGdjCRimh5t0Hc+J5WST07mg90joalW4AY0EG2NZmZLytgI6Pnfcumi8Qor+8NDsn7TpIbSRmb1Q1pABvoeIZsdLt09zdieOgud+ZeTEvOFdQmJWf86FIWN4bFYzpMgtPwLqEMEm2V1suQDLv0hUimwLmLxM6NK4sScNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPt2T6cryWo9KjhitSay5ciELP8aw3+zeHDLWWGJf2A=;
 b=V/zkpIDVw0/MgSn5Z6d8H5L1J50UElIqECdrhQ6Ch5DQpJrlDBJ4FXKNRrjY4AINKu40TKwliqx+0vaUcKm2C7292laXT+SPLPjxq9FImmaIcDmkSsLhWcBC7VQypWQh1RE84I9GEpI79of1csjEpPJ7wn0SJR+BxFbkQ7jffWQ=
Received: from BL1PR13CA0112.namprd13.prod.outlook.com (2603:10b6:208:2b9::27)
 by SJ2PR12MB8009.namprd12.prod.outlook.com (2603:10b6:a03:4c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.33; Thu, 30 May
 2024 11:16:53 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::ac) by BL1PR13CA0112.outlook.office365.com
 (2603:10b6:208:2b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:16:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:53 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:52 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:52 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 13/31] i386/sev: Add a class method to determine KVM VM type for SNP guests
Date: Thu, 30 May 2024 06:16:25 -0500
Message-ID: <20240530111643.1091816-14-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|SJ2PR12MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: f4bf1467-3181-4306-1595-08dc809a0240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LP/HBjsh9aYyauFMNmFy4uLVEgmc3/S/imfQxSCt7xCQ1wxBU6SRQMfOj7lc?=
 =?us-ascii?Q?isXhMMO6ppmvq6FxbYYJ5Vv+j68Xyu1npu9SrDOJPNJhDPOuHK6zd0e5GfZZ?=
 =?us-ascii?Q?pZPPcj4rp0wZ16Lb+0HKadk9ihpRTn0nWr0KNC1fGV+EuKLZ17MEJhEoWxSt?=
 =?us-ascii?Q?gqs6GPPZj/kpGDefwE4c5t+Y6RuKQpcx20zuj5HvrmUPe53emnJ2FkwMi6a0?=
 =?us-ascii?Q?7eQvNtxvNPwxtXdXNNGBRDhxR90vwezDmVTHGbhgorjVJNBYeKPV2HvXrV4U?=
 =?us-ascii?Q?TVrmmDX1w7c/cLcuip0oDzcQl5VBpbHyQgTLwpf03E9cuHgFlIm1y1Izmztc?=
 =?us-ascii?Q?utnH9hX+Y0Uf2fKm1LlVEGj/7LnPRJSOW6UdqNVNsyF3aDHqOGxdQRKGoXh7?=
 =?us-ascii?Q?KvFEB2tS74/ob6+gIP+82HTndUXARyZt7+Y0D2haNYR9CLpTS726ADoh02Qu?=
 =?us-ascii?Q?JtD1y+lQZtB8gt2aQfBcdkjBYfzMC9MCFhP7CczYvUUaTdSa4h6CZgdEAC15?=
 =?us-ascii?Q?nVHW+bndkKkkBhpySwOQXre2hMRwB9ySEWV/dQB4GDFlJNxN+A0S9bAD/NuT?=
 =?us-ascii?Q?48lM6H2mvEVRAf8BWzpoLGc9Ebuup+x37EvLF5WwhIPNCndyiq75kd57fDpI?=
 =?us-ascii?Q?6ZSbLMxIZw+AQJNR43KZPcaS5M40WvNrOoCXuQbqFOfB2ZK95ZQcfhbxbn5R?=
 =?us-ascii?Q?1aa4xDdeeR1B/WY+9gEwwfcTdIFArMxyChtqv5tTYQ9265o9rw+1wX32PO4F?=
 =?us-ascii?Q?ysNNkz0Wy7Q8oJx0WW04qeDPwciVu2Tcfp32P+f84j+OUZM19BCUrMp7eTF1?=
 =?us-ascii?Q?V4IpfoqfCyUSHq0hMYHElZyDeQc0bL4wo8d1FWTwUUsgiGjvnx/DQeV9PNT1?=
 =?us-ascii?Q?XJFZW1e7ZBOZgyiMzfodQB2T1qSoJEd/9QED9MXL0p5pn4IT8TRTSVnceHbl?=
 =?us-ascii?Q?Q5ODIxwzGlt3doQPhsAPPP63lrrwVKK7aB0rMAeT0SddiL9sLYB0zulaZuQX?=
 =?us-ascii?Q?+dBd9sgncJ+eBDaTN2oyE9M/j0NYnFRDAu9z8k+oYEdyBjzWWkuSQ0YhNxdI?=
 =?us-ascii?Q?FI2jysxtSOiZzJ3ssy/rd8TC6For/qujV9L2lKsMy5K2oAQLf2lOIULroUjE?=
 =?us-ascii?Q?XWwwSYCHNjB+sgqwwgjiItAzsGQPe9IR/HQE5es7kbauvpL3UsvFHS17KEDv?=
 =?us-ascii?Q?tmkdp0xGJ5Dd1TtwvTWLMcG9ueYXMAC4dToTqMQCap2jwTIjTpFWnV5tNqfm?=
 =?us-ascii?Q?tycMJ9zGb74fZAp+QClbU39nvfBS2cbHz+8r1IcekhwyKYfP8j49MnM0M1+f?=
 =?us-ascii?Q?L81dyfSYOWTjTiUxjU3M8ynPNv8yVhYY4WTwf1SsHTD13Mii0sZTpHR8AVEH?=
 =?us-ascii?Q?ui5CPno=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:53.0372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4bf1467-3181-4306-1595-08dc809a0240
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8009

SEV guests can use either KVM_X86_DEFAULT_VM, KVM_X86_SEV_VM,
or KVM_X86_SEV_ES_VM depending on the configuration and what
the host kernel supports. SNP guests on the other hand can only
ever use KVM_X86_SNP_VM, so split determination of VM type out
into a separate class method that can be set accordingly for
sev-guest vs. sev-snp-guest objects and add handling for SNP.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 458ff5040d..8ca486f5d2 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -100,6 +100,9 @@ struct SevGuestState {
 
 struct SevGuestStateClass {
     SevCommonStateClass parent_class;
+
+    /* public */
+    int (*kvm_type)(X86ConfidentialGuest *cg);
 };
 
 struct SevSnpGuestState {
@@ -117,6 +120,9 @@ struct SevSnpGuestState {
 
 struct SevSnpGuestStateClass {
     SevCommonStateClass parent_class;
+
+    /* public */
+    int (*kvm_type)(X86ConfidentialGuest *cg);
 };
 
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
@@ -893,6 +899,11 @@ out:
     return sev_common->kvm_type;
 }
 
+static int sev_snp_kvm_type(X86ConfidentialGuest *cg)
+{
+    return KVM_X86_SNP_VM;
+}
+
 static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     char *devname;
@@ -902,6 +913,8 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     struct sev_user_data_status status = {};
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
+    X86ConfidentialGuestClass *x86_klass =
+                               X86_CONFIDENTIAL_GUEST_GET_CLASS(cgs);
 
     sev_common->state = SEV_STATE_UNINIT;
 
@@ -972,7 +985,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    if (sev_kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
+    if (x86_klass->kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
 
         ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
@@ -1451,10 +1464,8 @@ static void
 sev_common_class_init(ObjectClass *oc, void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
-    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->kvm_init = sev_common_kvm_init;
-    x86_klass->kvm_type = sev_kvm_type;
 
     object_class_property_add_str(oc, "sev-device",
                                   sev_common_get_sev_device,
@@ -1539,10 +1550,12 @@ static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
     SevCommonStateClass *klass = SEV_COMMON_CLASS(oc);
+    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->launch_start = sev_launch_start;
     klass->launch_finish = sev_launch_finish;
     klass->kvm_init = sev_kvm_init;
+    x86_klass->kvm_type = sev_kvm_type;
 
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
@@ -1781,8 +1794,10 @@ static void
 sev_snp_guest_class_init(ObjectClass *oc, void *data)
 {
     SevCommonStateClass *klass = SEV_COMMON_CLASS(oc);
+    X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
     klass->kvm_init = sev_snp_kvm_init;
+    x86_klass->kvm_type = sev_snp_kvm_type;
 
     object_class_property_add(oc, "policy", "uint64",
                               sev_snp_guest_get_policy,
-- 
2.34.1


