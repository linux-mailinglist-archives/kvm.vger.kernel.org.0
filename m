Return-Path: <kvm+bounces-71327-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOFQFBqjlmk7iQIAu9opvQ
	(envelope-from <kvm+bounces-71327-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF85F15C291
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 48788303CE94
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E807D2C11C6;
	Thu, 19 Feb 2026 05:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jdpwZMqE"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010021.outbound.protection.outlook.com [52.101.193.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB012C08C8
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771479811; cv=fail; b=R+kdfYCif7dq5fjLDUZGxrKsK5jMIzfSTUWlWLlleEOdncA3nlFHmYCmc2o7sLBRWdeiP2Se8Cr4STyFS2qnv8gKo2qZ4KjK61Mxgf9hraPj8Q+r4m8r5rAxnd3KjFctR7ET2qCnhlO6Wej1G6yuZJalj0QLQjxKNLMTVZDXPVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771479811; c=relaxed/simple;
	bh=06Z/BvzrYpRLp6xWdjf7DD/+treodQ9RvO3Gn9BK6EI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FqCsaL3m1cTvoWYd50Q2HZz3ibY4sLzmItppjqldXdVRsnaf7FMR0LEj5BZ56NeT/15aE9lMJfCsqqHnxLNiMpvL5KT/UF7hlaHvo3AQqLMEyfoZc6fnMwKkdBrKkobtgJycy5WNwQpPVXuICsAg3YFwwpKU2LiJWH1HnaObmGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jdpwZMqE; arc=fail smtp.client-ip=52.101.193.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YR+9AnmQF+oDC8pwMoxyeamnBsmxr4kbKkknIdA5bxmYTfKFqN0zfGLv65BnB5Uiuk/8GnXehGSyrlhkQHscx0YI/L1dzntspi71WabPD4TH0qlTelE3un2ER9K81tZ8u+/JtQcsZXKYQVHsqEgPIKmjsqCqqTVOFtQfdD2cH240BKhzMDMva18UnoNkymadA0CMmDIElFZ8QfR1WhZFoRt3pANLRuW+yR9UJji8nPvxyxXEs1Bl741aDEA9cS9y0iDiboqWltCinIEytUajPf/2s62oiTeItrHFe2T14qdF1PEywsfsBWID9AnoUE0MxaiRUXfIltPG/xFM5fmGkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71o6qenLaZ7N1XnkNxV11kgRCkClxcrws2LdMb8phAk=;
 b=qM51Z4QZXO7egccDRUKjVs9Ca+aP6sA0e4XtWxaz4WRLOlgH96yEEHsTzUeM8N8aLJ6ZdYcn3Ja78F925osvSPz03tfzBEBKlppXTGWLX/G6KWd7woxG7R1BZS290m6auwuxfTUUgOg6VtRe1F69j1u5HxGwPAFneEOV8DkdRcvjGaruiXFEh07l46dU+vyehTSmIPk51SgXM2Fj0wjkB6BogBoVcVHFrdci57Pi5QIB4dCTQ7GLj3YYb270PyYSJk/u2A+kju77z4daSjVMSegpdIcdmBWqOQM3LyqKx2YVT3BxHji8AyWNyr4B7FUvLVXFCFhKNF/UpnnBx5YCwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71o6qenLaZ7N1XnkNxV11kgRCkClxcrws2LdMb8phAk=;
 b=jdpwZMqExJZfUdelyCYYDbNTAXwmJ6wAyuMcMxl7S0fiNyONB+QNaUaSp3FCqzNTXWJs7xu57oudhhUTvo8dhPonDoOSb/DsIsuurYWRh42yGzGJcCUSCQUfT6oqnfy64gb+AN2xBokQ/nDtmMZJ62UbFNxQf1mXq92IM/bL9tY=
Received: from SJ0PR05CA0064.namprd05.prod.outlook.com (2603:10b6:a03:332::9)
 by DM4PR12MB6375.namprd12.prod.outlook.com (2603:10b6:8:a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Thu, 19 Feb
 2026 05:43:26 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::84) by SJ0PR05CA0064.outlook.office365.com
 (2603:10b6:a03:332::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Thu,
 19 Feb 2026 05:42:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:43:25 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:43:22 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <qemu-devel@nongnu.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	<kvm@vger.kernel.org>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Marcelo Tosatti" <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, "Paolo Bonzini" <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Richard Henderson <richard.henderson@linaro.org>, Naveen
 N Rao <naveen@kernel.org>, Nikunj Dadhaniya <nikunj@amd.com>,
	<manali.shukla@amd.com>
Subject: [PATCH v1 2/8] i386/kvm: Pass APICCommonState directly to kvm_get_apic_state()
Date: Thu, 19 Feb 2026 05:42:01 +0000
Message-ID: <20260219054207.471303-3-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260219054207.471303-1-manali.shukla@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|DM4PR12MB6375:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bc12135-9b33-4fd6-6586-08de6f79cd58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jSlA4wsCmnL1E+bTUJEoUBcI3d0sthvKw6RPoZ+Eufi7IUc0hQNzGQm/nsp+?=
 =?us-ascii?Q?T1TnnDliV2zJe3TYjZ/zGBpWOEOaRbucCkqaO1hj3wD6osg/b4W02gbFYEbb?=
 =?us-ascii?Q?MiD8bYw6rW2nLsqurw2i7MOkbB5yy+pcYSGDyub/GlbNrrEz6ezwewb7ZeLY?=
 =?us-ascii?Q?vraLdlQ35TkFSooEjx4gsy83Vt2tcRlyIV4OtrlP8Q08YYgoG6fl0sVAeh6z?=
 =?us-ascii?Q?e00jUtAo/v7AMJTU2veS2L9mlkpggVA3RWANDUAk8Lhmi7QtEbLhksuP4AdG?=
 =?us-ascii?Q?JAjzLSV3n8toSU2cI3M8IoLzUnvRKYn7Gwpu7y99DnVvBumn2ZJSQYUIctNM?=
 =?us-ascii?Q?+4D7Kzy9IaIgz8mBpiQiyfn4USuy9qI3uOkZg2uAFfaOeahbf73iMVFJn7ZS?=
 =?us-ascii?Q?Gozo4HNbL/tT0Ui7hVsk3L5BtrZO8CI7ZHNWIOdbNzzSxZQKNjRt6fdHX9g0?=
 =?us-ascii?Q?JOcMREV1SH8+KAEki4GPNSfO97kRfIL25XjEj5Q1Cr70cNtHSHwiZoJ0QrA6?=
 =?us-ascii?Q?mfa9IvF35Jxn+4A9dZuQMaJ/h3m6hoO0ttiJYdPT+sR+UydHc3OYE8aTWfoP?=
 =?us-ascii?Q?u5jZmvUNfZWDgFU9jf6pNBi7wNSaZs8eTPoj1B4218lRGMa79moeWIgNZoJP?=
 =?us-ascii?Q?yXReKQfLzNqrZRvPjHhpHDbz3S89wavZ9neNA3YlBgmN6Am33Fp81Z+dh/vB?=
 =?us-ascii?Q?2R70/t4ca7QDB6LMfGUq3odomOA7/bXC5gzjpKcWWiI95IwDR4ZYZtVAYdO2?=
 =?us-ascii?Q?zuc05u+Bnk+u3RBp08VK3zjRdO8Bl7QYk746B0+vOaErdfTnAnT+ZodPaHAv?=
 =?us-ascii?Q?soKr58o688aJe2eO9PGPcZXnu9IO/DEPTssSHB0cnpl35d7u0fDnR4LDK7Px?=
 =?us-ascii?Q?gRSoxUL9jKAoUPZ6i2XdmyTKUsrAni9/Os/T+1l/rJpeHiqiGlk2B2VjBx0d?=
 =?us-ascii?Q?W3vfLow44ncnNAmEiutzEN5K/mSOkUZZkMSZXO0lNQSvY4h2jv1axvP2L44T?=
 =?us-ascii?Q?5/++ZW61xLgqvrIXpEl4c9PTBZciJ2z1KO73y3/C+MNoygz1bFevWSh+v/Rx?=
 =?us-ascii?Q?qbQTV4ZEqq4sdSR0AdL2+bJmIffNSnk6OIs8rq8PVxWMvV/ZZ+qfZM0GUydF?=
 =?us-ascii?Q?4G4b2M+gmCSJicPuV2zzimZW3EEPrJAaq/lB+4G0D/ySlxeeF/LjEDE06xs5?=
 =?us-ascii?Q?mdhQYhScDMpq03JcBOjLUtaST841hAYMORyyhZR+/5LVzbAQYWKUDQ8IuPKU?=
 =?us-ascii?Q?Z1wT5FAWd37f/eoUnx+6H0KwdFbUg02dzfHN6zrCgPuMKhAHaKxf92HMiWHB?=
 =?us-ascii?Q?2FyLk4r9daA5o+uIHPfnvbBTUIJ8aPr8MOEr4VjysSqfKB/USK+mhww9LOdO?=
 =?us-ascii?Q?dF142vbssYu+i8st1FIPBQstrRBGAwXKnkMBhM3N4s0PgEz4lOMNyunqoDvW?=
 =?us-ascii?Q?E8i2dbW9XX04w1JCrZD5Q5xW/ECymDIsisTbzGXTzkmi4yDBWegfSfN1hZ9Y?=
 =?us-ascii?Q?DFS47Gp8BivISYllLWQ+iuR94YJbgUH54WOOWT+JnOJENpP8eLbYSxkvqKu/?=
 =?us-ascii?Q?paw97dJ+dwNeaEDK2NCxYX9TweQ8aJtzsEpphy3oObyMc23BSvrGGD3Tozbd?=
 =?us-ascii?Q?ugLQH9YnqmnWiY2ODKNHNPFXwsqDVerrRGJzklndDERaYfaJ6HHb5VTylQVL?=
 =?us-ascii?Q?r7SqaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K62JlbuKG4aeIQblucZMx+BGDq1YW51eFwkSjLUMKTmrU6f/j2gKHATuRkRS2VQgbicgStu1dbqfriCzCCSM/XgXtmp7Cy6NSpEC+VtyZkej6EsqDJCffXSuUZVDGCsr+la3aHgLDcVPz59lTAnKPrULL3myMrPJJAyAGiXAabq6xJ5ApcZO8STlCRxCMyhNSGN0DcDw5VyjZoUKm3y/k+oGvXo0bplfIH8OM/0Xxh41u4Y/gMkdysI15f6Lmwe5m7yJzXGKvbqRfVDexZzyoYFY/OI8sgCaWuMGpwS9GKCW5IpZwwoB1BdYLD5TcsUjz1CehV+bMIM/lIwFWmnbiaHt2zjkF7eUTl+RgqpPO9uSt39daODX/gmr2VQnBZQBH4DOwqEgj2tHMydKxuIEAlN2ilYQkIXgSFsZj2pG1WzDNV5npJt2A9wN+XT2V6nl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:43:25.9019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc12135-9b33-4fd6-6586-08de6f79cd58
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6375
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,vger.kernel.org,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71327-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: BF85F15C291
X-Rspamd-Action: no action

Change kvm_get_apic_state() to accept APICCommonState pointer directly
instead of DeviceState, eliminating the need for APIC_COMMON() cast
inside the function.

The caller (kvm_get_apic) now performs the cast once, making the code
cleaner and preparing for extended APIC state handling.

No functional change intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 hw/i386/kvm/apic.c         | 3 +--
 target/i386/kvm/kvm.c      | 3 ++-
 target/i386/kvm/kvm_i386.h | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index c1866c3939..9489614bca 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -60,9 +60,8 @@ static void kvm_put_apic_state(APICCommonState *s, void *regs)
 
 }
 
-void kvm_get_apic_state(DeviceState *dev, void *kapic)
+void kvm_get_apic_state(APICCommonState *s, void *kapic)
 {
-    APICCommonState *s = APIC_COMMON(dev);
     int i, v;
 
     if (kvm_has_x2apic_api() && s->apicbase & MSR_IA32_APICBASE_EXTD) {
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 369626f8c8..ea22aa7180 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5012,10 +5012,11 @@ static int kvm_get_mp_state(X86CPU *cpu)
 
 static int kvm_get_apic(X86CPU *cpu)
 {
-    DeviceState *apic = cpu->apic_state;
+    APICCommonState *apic;
     struct kvm_lapic_state kapic;
     int ret;
 
+    apic = APIC_COMMON(cpu->apic_state);
     if (apic && kvm_irqchip_in_kernel()) {
         ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_LAPIC, &kapic);
         if (ret < 0) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index ecf21c2cc1..00f8ae0ee4 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -12,6 +12,7 @@
 #define QEMU_KVM_I386_H
 
 #include "system/kvm.h"
+#include "hw/i386/apic_internal.h"
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
@@ -56,7 +57,7 @@ bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 
-void kvm_get_apic_state(DeviceState *d, void *kapic);
+void kvm_get_apic_state(APICCommonState *s, void *kapic);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
-- 
2.43.0


