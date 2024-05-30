Return-Path: <kvm+bounces-18398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 761268D4A2D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3B8CB244CF
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4DC17D37F;
	Thu, 30 May 2024 11:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u5zjV0i4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104B616F830
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067816; cv=fail; b=dU21gvf05w+rGG5b4ojBRJ5VyfCNuS9fn0iqIv7NXGwJlR/qfpmlvyyV5o7mnnlrGULdaPA+EjYMmpnI5xNvRNwQIGfijgg+Db97ksW+Fp6JMaPlr783WRTGO7+9bOcIhtyZ83btBZQmvj+PrGh+BQtUmmVauT1Olwv9NknXj7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067816; c=relaxed/simple;
	bh=sAIU+LJuDo89LbWWHoAxplRSCVkVx5bprLV5hRQesO4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tH1jgLyuZ9a0MRwlEKykXDCMXe3zfT5f/bhpM1tfbQ3W5WVclbpe4mPwn9ZDeuku3MZdZwcnOQrd04ggTZHiaRkdbdp11SCJptxbzQD6k9H89yztEh9F4cFivawidRuZZxmxEczAdHUH2TIaxJ+/4z52uftINJrEMgGQSGl6LrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u5zjV0i4; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hz8cEvZl5qgoJSYL3doxdbqX65uDVeSdXh0FcroSW3E1Jj4cy+5bOIlPOFBGmUUe/mzZZ1SH1AeoUSAhSJWR2ctTaUX8Lf3CJ/5GlrZ5r812LcEreyvUmXc3TUJq7c5IwIc/ZVAmHUEc70yGIFpknP8Ymr8IhEYICEmendpVcwtgc6OJtTRusvNWbmDYPBGHBWprN+7EDllu8IezRs9KHitqxGA9ScoAVUO5oFFsQfA4CwhqESikMs3Z+2lchbC6Q3gm55oK3OJQ2vSHWELioEEhNLXesoGJeBk8nAEut0d8w6UTvpARCllV0IhRftpElQvlEhMVf0UEVIwVfRWPHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lK582yi5N6LQWquzavDKpZxHAPKtDQeXVB1+CawH+kM=;
 b=A6ykCzzD4A7yxBOBgpxMF7JWMLAjFPfTCGKfwfRg1pXBpHdXzPyOQkQLwh3/1PzR1NknPkVyNSnUX5DrlEcmZ2PmtFs+X4iZ9l8jVM60vVVa+XUmM/gel6UbwA2lG3PrXcD0yQ9hiQNJ43vYf0leHcf1nLoBA2Ee9iniYCXwmy7roYJ7F3AaaC9491Frb6aH3POB91YAXUjr/PdQXSv0UVOH3srWqHBgP2Au5YvQ6TjZ7RSsEcaHJ8fW6GTxdZ16aarq13dLpryx20Wj2H5p8h2W+if/WI2fx8mEH4y0MLbRNiBefUytVxYaF95RqmvEhOufkYf2/d05iVfLP4GWYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lK582yi5N6LQWquzavDKpZxHAPKtDQeXVB1+CawH+kM=;
 b=u5zjV0i4C4ckNvyfNglE+LNCJ86wvzd549E+nnVC6PjkI6pX3aObK3VZ1mDqmffkHJ+YEoALt/3vfbi5NwaKwmPEpiwKngu9hdtBTo8I9Y1g5T84fCacZwAqQ5Zt35KhYK6kMB3YzJKDTyFyexrGR88A1L2n7XURx2DXB1JxvQw=
Received: from BN1PR14CA0016.namprd14.prod.outlook.com (2603:10b6:408:e3::21)
 by IA0PR12MB8206.namprd12.prod.outlook.com (2603:10b6:208:403::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Thu, 30 May
 2024 11:16:50 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::89) by BN1PR14CA0016.outlook.office365.com
 (2603:10b6:408:e3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Thu, 30 May 2024 11:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:48 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:47 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 06/31] i386/sev: Move sev_launch_finish to separate class method
Date: Thu, 30 May 2024 06:16:18 -0500
Message-ID: <20240530111643.1091816-7-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB03.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|IA0PR12MB8206:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f213e2-572e-4c37-d6d4-08dc809a008d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HLr9S2Z2xgXKxeAivEfarl2gcqTVWmXoha7MOSoYTVVZPj7n/VpQlWKCsdbm?=
 =?us-ascii?Q?XuH90b7CmnXUreUmUKFykMWC5Vlbh50i7ivjUo52QnXZbPR3OSxgx9RHnaN5?=
 =?us-ascii?Q?isv5wII7XJTmUknn+FeGPtatkB/xRYYGU+pdofisXKyO87SdsKRTDpQPC9CK?=
 =?us-ascii?Q?cb8rsi8OEvEpfnjAQK2iD2USxxf4e2/YGmW9j4I/aIcDtcROi5VwshXwQuZw?=
 =?us-ascii?Q?C6DbBZ8G4z4RA4zpO5Xsp21dHLGdGVCaXuXdq9QJVnHGjgJPil3ooKjnotzY?=
 =?us-ascii?Q?wkqaAGMVnf0ArArB9ESkLEZkQjGiXUdLJh6qqXx/6mvCDphGWoo95hUKpsOQ?=
 =?us-ascii?Q?XC/1pea8yXMiSUGMzyKCAi2Lx4dgxd+jnv9mQtDTG6G0S7oIyCnv9qCvH+Kv?=
 =?us-ascii?Q?NRuF7tQA2gwGuCI0fM30sN9PtUCyqEhVSH/9AMxUkop5AVxTrD+ZQ68zH7eO?=
 =?us-ascii?Q?FKEcju3InsCP0cqRyKfyKsTpmZ8OMSDSHRJ/fquKx2ngz773Vi7bLVxHYhVQ?=
 =?us-ascii?Q?/6mbrR2P7j7VCzEZ0GsIoOWwiS5GEYKLQrD4Pby6E2kGBrxl97iHfhrUmASz?=
 =?us-ascii?Q?Aem3eWJfjUXf6UtVOIVXaHnxlMqm+bYpi+7ahZAoWMF9UL87MKIUmQHpm4Wd?=
 =?us-ascii?Q?JpC53+kj6po/p3ra3rWIzKknUdkck7y3ttJDGa8fQbvLhOq8qgWangFuGw4D?=
 =?us-ascii?Q?JNz7HraBowZwstDiG5+VI/xt38DvqeTNgEPKH8ZmfxlLePwZdMCBXe9j9U7Y?=
 =?us-ascii?Q?acHSJ7Q3HtpBBe58oqdxNXiNoLgXgIr4feLo4Y9z9opII6kTLqu8zcjCntvv?=
 =?us-ascii?Q?+Ngcy0qRHQcX+kX63GGD6c4J4djBIkhoIo6smE8SJQjH41NGWOl04KwOzlUx?=
 =?us-ascii?Q?/OG5GuDTpUfbfeCP+Q9Kbs/erCRWn1Ky8ctNR1X3J1MoT3sWRAfEp1LiWeFu?=
 =?us-ascii?Q?tlHTWP7kV572xQnVusuzlRPAfwHAukpxa/JsC6dFLLj36PLngN5SiRdHq1BH?=
 =?us-ascii?Q?JYDw8IG2HWx7Dh+fJz7WZM9TY3s2NkSnJw2GHQRfQBjtWNS6AEmuWzR43C0w?=
 =?us-ascii?Q?Vydll70vdvHJ+ahaOj3hZ06wVGS/HLLZgatH5M7cN4TP/PgD7BQEjwzi+3EE?=
 =?us-ascii?Q?yBtpXmsIYqEw251wnP8YaJTuO52xsNCBGJpLMnsoqnwapa2plPLZME5dco3+?=
 =?us-ascii?Q?Jm/CNIKIk5DB5an7GmV6NefrmUvXh+OS6C5V3Tc6n+2eD5IvCTARPQzwWEwW?=
 =?us-ascii?Q?VPi6E3JkuU9tk7AsExitcZYWIgRUATqsbURlYBO14hhgWGSeKkrCrjqgBIO9?=
 =?us-ascii?Q?dVhNkSE3BY+9zhcH4301Uz2ZPOi8U3SjhXwkSZluaYE6MUnBdq3OFOx6oral?=
 =?us-ascii?Q?Q8l6GKQ4GpNN7SvGzFXnPIlmOgrW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:50.2069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f213e2-572e-4c37-d6d4-08dc809a008d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8206

When sev-snp-guest objects are introduced there will be a number of
differences in how the launch finish is handled compared to the existing
sev-guest object. Move sev_launch_finish() to a class method to make it
easier to implement SNP-specific launch update functionality later.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 3bdb88f2ed..c141f4fed4 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -71,6 +71,7 @@ struct SevCommonStateClass {
 
     /* public */
     int (*launch_start)(SevCommonState *sev_common);
+    void (*launch_finish)(SevCommonState *sev_common);
 };
 
 /**
@@ -805,12 +806,12 @@ static Notifier sev_machine_done_notify = {
 };
 
 static void
-sev_launch_finish(SevGuestState *sev_guest)
+sev_launch_finish(SevCommonState *sev_common)
 {
     int ret, error;
 
     trace_kvm_sev_launch_finish();
-    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_FINISH, 0,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_FINISH, 0,
                     &error);
     if (ret) {
         error_report("%s: LAUNCH_FINISH ret=%d fw_error=%d '%s'",
@@ -818,7 +819,7 @@ sev_launch_finish(SevGuestState *sev_guest)
         exit(1);
     }
 
-    sev_set_guest_state(SEV_COMMON(sev_guest), SEV_STATE_RUNNING);
+    sev_set_guest_state(sev_common, SEV_STATE_RUNNING);
 
     /* add migration blocker */
     error_setg(&sev_mig_blocker,
@@ -830,10 +831,11 @@ static void
 sev_vm_state_change(void *opaque, bool running, RunState state)
 {
     SevCommonState *sev_common = opaque;
+    SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(opaque);
 
     if (running) {
         if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
-            sev_launch_finish(SEV_GUEST(sev_common));
+            klass->launch_finish(sev_common);
         }
     }
 }
@@ -1461,6 +1463,7 @@ sev_guest_class_init(ObjectClass *oc, void *data)
     SevCommonStateClass *klass = SEV_COMMON_CLASS(oc);
 
     klass->launch_start = sev_launch_start;
+    klass->launch_finish = sev_launch_finish;
 
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
-- 
2.34.1


