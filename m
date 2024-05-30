Return-Path: <kvm+bounces-18394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 572758D4A28
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08AB3281F5B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD6817C7A3;
	Thu, 30 May 2024 11:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YyldVAUY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A13176AAA
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067813; cv=fail; b=mCtnRqxyUjkXfT9rQHfyM7gTOynzAzKBLaGOTDPJsOPXA/kwqTvcDEN7+L2bFIFANT26uM0yvcRvcgtBzXIylLBc/uDGSheZKrk3JXTYAQmlHwPCbFB5E819fBGO8Bgzd0dLl12zzzvFcHlGXVIdW5Rzg+xOJUDo9Xsso19gAvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067813; c=relaxed/simple;
	bh=6RlaGcjpm0vUT/PeSqpajHJw0s3jPUfxGtk8Mx98KWg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a/qYDmBbXfGW0hE/QgFfDOKJfz2T/n+JCCNTjJvaRSwxTK8YDyQRG3TD0rCJ9EMT+Iyv1B1bJmlpYC5Wc3nuhglRZsGr062RDw2xlNiFnKz6gRi78fpIekx2QqXiILdVviOFoZEg4Wvjn8fVs8eClWYFBtWeFpVlGoJDRlbbpTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YyldVAUY; arc=fail smtp.client-ip=40.107.237.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZ25h6nPel6YP1xa92jItvV7H2hpgEftC8oB1bBPLDRV7+LrqTopgKvATwbTROvRquKOAxw9Jwg7Vp3Ir7xzCA+UEJ3y59DBCQH4tswhvIr6ohDlHYvrC0q6rXxaFRimCiFmLvKXMNkeBSbXLKsbCDzv8quCLfY0JR39yyp9/W5ESR0tAEaSnhmHKYgOmOmvy1k8RSY21ovsS3bbJE0WGVPGz4/ult9FCboxmqpPrfIg/nwhhGtJyhkmSuZQVWcAJ38BVXnswjZ5E2qvKkChGKTk4Swa8LJQ3pIDSGbd3oRiF5WpiiwcNGeJP1aS1Jd9v/yn3sXb57QGhwKpeP1C7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5MTmqXtxbAymjMh9a8KMG452ISgw8nzMe9Mhwjt6V/I=;
 b=YC1RgP/ld9V1qutGUPH0lrs/m3s7p6GNPDM7RPyLZbAbm7K2ldev3pkWwrnwE0SGgFcoSqoScFgYKqJ373xDQx6oyT+vHPhHFIKzUy6X8G0euBg+ngpyS/WvTIYNV/q8SIpKAWDBux8lTujefKh2+fkHGYiXTNg7DbmWhz58p4aj7+u7u2wjdlAz5uL6O4JI/8Q4kL9HS5IhCvC1nVjVfEJOMjSAspE3cd1gg40uOFkrvL9CGs+aWj29bYHjvjf2lFh1QiWpqOcyRJFEz6QqMXe+PIUNlU2/Sr1iaNI5WfdmfaQ0x3AlY1XudMIBYh6qE8m9JI036UOFX59X0lgG8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5MTmqXtxbAymjMh9a8KMG452ISgw8nzMe9Mhwjt6V/I=;
 b=YyldVAUYF/v1cIhwOclXF5HbullHbxvGAyxZNvOtV3NO3jls8waNYwmJHH1wCLKbWlCgfYqTChk+Mvbhi5vX+/Ykli/3P7DwuzQv1/yjRCe1HN1P1t/qkNamkWUp8y9xLX1avNZlL6nPfq7x29dZAtKPOg7Q9d+RJpxe4oLGyVU=
Received: from BL1PR13CA0111.namprd13.prod.outlook.com (2603:10b6:208:2b9::26)
 by CYYPR12MB8940.namprd12.prod.outlook.com (2603:10b6:930:bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 11:16:48 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:2b9:cafe::d0) by BL1PR13CA0111.outlook.office365.com
 (2603:10b6:208:2b9::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:16:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:48 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:47 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:47 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:46 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 05/31] i386/sev: Move sev_launch_update to separate class method
Date: Thu, 30 May 2024 06:16:17 -0500
Message-ID: <20240530111643.1091816-6-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|CYYPR12MB8940:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a015c3-100a-434f-990d-08dc8099ff5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j7Pt71R1zo4OBKD/wPCq736LFvjKYl5/P+CeRpHf4esKGcpT3kcQdSiGL3JZ?=
 =?us-ascii?Q?l/6ej1ijXMpwAaZLPYyoyjbVo+g2qO5TQDvoeCSfEKfj6pBrGZ9Jrozzoi/f?=
 =?us-ascii?Q?dvGpTCOyV1ZCBvtdgiN+2eyG7un3oepjz/m1SFpUtsb5mGlbCZVicCXVdEL5?=
 =?us-ascii?Q?+zZoQzICGGqtl0Uw1gIjSnMfsRISzcpeAnZNwx/UhdL8ktihxJUTFykRks6m?=
 =?us-ascii?Q?cPd6dgG+pfqm8qrJhsonQPRwgMUwHWqEFKSQpwTRMmLImiIkHy/s4LMFz2Ap?=
 =?us-ascii?Q?8UEcCBs+6Bzbxls0K4LwlnajHiy++4NOIFrtJN6LDYsbGqRAIt6UITNi96Pc?=
 =?us-ascii?Q?fLYfIzscv1pR6WzY85IIuodDBL/jDpBS1/Oz2FZQbWS8w+MLH6j+5Qpfratt?=
 =?us-ascii?Q?BQeUyuTkfAqjZv4pBxvbEadX58hFVkPkiDzAhyNa3c1NmQNeDEkAIH5abXQu?=
 =?us-ascii?Q?/ymfXRA0PsAZN4VEwUPQaZ436CFBT6JSeDNLuwIi+X51vIaQ+xJbfKAfxTja?=
 =?us-ascii?Q?xU0PXZNASFOU5m88vZelLr8s9lYn5Mwjivs8Axf2w06HI7MVeAl5JwfUeP3q?=
 =?us-ascii?Q?2tfOdhhLYhH+h/IQRozC5CFA8g58W8AxUT/tKQBegYOhuXpkVtUTDWRQbFZt?=
 =?us-ascii?Q?op5AKY54IR4G4n4/yk8/sKsrzBFvDeeFOOvkE9MuBfwbrGsv7DVTe6hAP5as?=
 =?us-ascii?Q?doM4NKQBWZ0PTBbXNk/6p3HbeyNItJQ0/j93bXs1MEd/P+6VKuOXNaj9pCAj?=
 =?us-ascii?Q?XBtm+UTk6YeI6igIlytiJTKXGIMVuUwnfau8q7DQzA6ktGoeBwh/6AInNG21?=
 =?us-ascii?Q?Kd7yOiIUFtU/Q6m+Op8lBZBlEG65gKaEl6ZMYd/s3h+mRlDP9mxRfSMu+B5g?=
 =?us-ascii?Q?jTai7p9Mj+gHnIlcG3m6/k0IyMxS+QMeYENeZydrrQW/yJ8PQkhzMiy81hSQ?=
 =?us-ascii?Q?DSCaA1GfOXNVwPCKl0CyDJRJICF3N4NPMe094K8/edLmCPBodyU/iLOgLnDN?=
 =?us-ascii?Q?NbJNTAE0W6mCWvJyXiQ8uYjJ64Ekaw1pnWxxxpRcIpYlsW5K0egxdydkJhcj?=
 =?us-ascii?Q?TiDTwLAg9HJWSOp0/Krv/EgDkYEwguXZl+Mam8zoiQ34BrqfIpoPPcgc4IJY?=
 =?us-ascii?Q?1ILcSMYazRs3Tur8/8jruCohh/YZ3pvW/dCQe8uxPVQuDBhr7HONQD1pJk2A?=
 =?us-ascii?Q?E9zOgEERVXoCGtTgOQcoSScc5Seb+g7uIluSSJKN46iJ7FL0hIFX6K/iMKsZ?=
 =?us-ascii?Q?n40+x9OdXP83FxueHZN2AsH6rwCt0dX0Eb7424J9Ny19S/UqUfiSeuTq6lVl?=
 =?us-ascii?Q?fPFKJ9XbUbp3pzP9nesuA3niyVwTioOx0SyXMauPX//ebhXAFRUpbaZbhExv?=
 =?us-ascii?Q?iZTdFnU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:48.1778
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a015c3-100a-434f-990d-08dc8099ff5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8940

When sev-snp-guest objects are introduced there will be a number of
differences in how the launch data is handled compared to the existing
sev-guest object. Move sev_launch_start() to a class method to make it
easier to implement SNP-specific launch update functionality later.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 79eb21c7d0..3bdb88f2ed 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -69,6 +69,8 @@ struct SevCommonState {
 struct SevCommonStateClass {
     X86ConfidentialGuestClass parent_class;
 
+    /* public */
+    int (*launch_start)(SevCommonState *sev_common);
 };
 
 /**
@@ -636,16 +638,16 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 }
 
 static int
-sev_launch_start(SevGuestState *sev_guest)
+sev_launch_start(SevCommonState *sev_common)
 {
     gsize sz;
     int ret = 1;
     int fw_error, rc;
+    SevGuestState *sev_guest = SEV_GUEST(sev_common);
     struct kvm_sev_launch_start start = {
         .handle = sev_guest->handle, .policy = sev_guest->policy
     };
     guchar *session = NULL, *dh_cert = NULL;
-    SevCommonState *sev_common = SEV_COMMON(sev_guest);
 
     if (sev_guest->session_file) {
         if (sev_read_file_base64(sev_guest->session_file, &session, &sz) < 0) {
@@ -866,6 +868,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
 
     ret = ram_block_discard_disable(true);
     if (ret) {
@@ -956,7 +959,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    sev_launch_start(SEV_GUEST(sev_common));
+    ret = klass->launch_start(sev_common);
     if (ret) {
         error_setg(errp, "%s: failed to create encryption context", __func__);
         goto err;
@@ -1455,6 +1458,10 @@ static void sev_guest_set_legacy_vm_type(Object *obj, bool value, Error **errp)
 static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
+    SevCommonStateClass *klass = SEV_COMMON_CLASS(oc);
+
+    klass->launch_start = sev_launch_start;
+
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
                                   sev_guest_set_dh_cert_file);
-- 
2.34.1


