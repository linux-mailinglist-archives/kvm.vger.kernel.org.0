Return-Path: <kvm+bounces-12232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D579880D69
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD5B71C22865
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E82939ACC;
	Wed, 20 Mar 2024 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FdoiOHtQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978E38DE8
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924347; cv=fail; b=gUjeXfZ7WWJnxxZRO2HMPqCfAIwCV8mGortcX/bOAQjaX+2S7fSNtnIlnpDm8lO4kSz/8eG9qcBroylWCFn8tEJAq+gKv5Rjhmy8S2EENenECsFcWwt275BvQHOYBb3TsfcWbZb1cQXmLdd+I75F3y8+1Iu7wTgNnDw6nsh1T0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924347; c=relaxed/simple;
	bh=9BxA3WFUw61dHtL4+8qVwV3krjXmSmbRE5pX9saEwI0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=edIDJPDZn9EcgZ0E8CkpMny5+dKCTk0et4ZjcB3H5lBYc31NlMurDVKkkBV8cEA9+G92NiYsEF+yLeULRoBMR2d50sZaVToe3WXf9G86//r5Ns0YVuI51yqfMPLZHvwg1mb+7pByU4peu2MUChm5rMWAPh4JKH9eg38eTpnqiVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FdoiOHtQ; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyqcTASDmTOY4hkTbHNP1NbfV4Zv6g1Dei62zVAaXOf/6AfAId5iY1OR+u7txAzzHZ6Yvu7r48420DyVE730eOMNRrAzE2fLuU1RsU2idCd167cCupoOkjKBa2YqZP8NjLtSNj362X1tR36ovzDO9pGpoQGhoUY5nWj34IZXTGHaNcR9o5v8u7NwYtCGpUbg4F1Z/glj8LngW3cHzAp4H7x0SQ2Y5xi23yv+uXV5mkNHt6u/iv9HklGOyZqHkQ6HjeP+DEBv56asPKqrtWRmew/IOwXKB6a7WBINpL7+U7t4yQi+e+Omx0LhdDrB6zBinIM7/fjhBM3oF8wdzZZDBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hgqQeEk4/yxOnObN4oS7g1WBS8gHjZbQRquku8TOVwE=;
 b=nFlLxVJj4lAl3qXIHkMluT3h+2T2d7nJGjaNEGENY6SJY1QE7owhhh4aPxS7HSeD+NSCR7sGP1ELoPhv03f1syBRgs11r6Z6vpXygEG3mJ+4J1p43tUm3UqkAcv/PTWVXo6GM8RIIc4wz5CkBDQfq1+2Bej6hUWsFL5IH11QkFJ23yH3UE1EYD9XcTfRH7yD4LfsBF+g2VxMSG5gSMKPf4FhXWwtvOq2FGwE9xD7UyUVlUzw6R2tk8z2xV2L/Dpb09I8E2vvoOUyT/p35O45onfp6OsKQEQqM8WapVVnbUNfW6c/23L2ZEKdRxyaiixAU+wwmrzVpKiB/lA1LwueTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hgqQeEk4/yxOnObN4oS7g1WBS8gHjZbQRquku8TOVwE=;
 b=FdoiOHtQpVhZ+3rv2dyhfoPPS8w3aUXBqKcx8oRhGo2cIL9PChQKW6im75qODpJLm6uLoDfT+qtaUA1sFfyoiJk6WxHmNW9wfm8bSNh4R4c5Tdwq/eJccgj1AZUboKFHT0ol939exUx7G5+uBWK8lFkyWAgqddluQ7AVS2YLVuw=
Received: from MW4PR03CA0289.namprd03.prod.outlook.com (2603:10b6:303:b5::24)
 by SJ2PR12MB8737.namprd12.prod.outlook.com (2603:10b6:a03:545::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 08:45:42 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:303:b5:cafe::57) by MW4PR03CA0289.outlook.office365.com
 (2603:10b6:303:b5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:45:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:45:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 01/49] Revert "linux-headers hack" from sevinit2 base tree
Date: Wed, 20 Mar 2024 03:38:57 -0500
Message-ID: <20240320083945.991426-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|SJ2PR12MB8737:EE_
X-MS-Office365-Filtering-Correlation-Id: 34965a5c-78c1-4656-a00d-08dc48ba2009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nljCWTAUP942QdTqIU7DPmGgTGf0yTFFURTiG1bfK2oVFoc2Bls0+UC19aVQUjeL8eB02KHLIkV8leBqTJJ4e026IM9LZO5SHaqTxjTF7mw0U0ZvNARuUlp7aDGOSnyFhwcqHNB3XFrs3gFQC65QYx2zQvoN6G93Mgz3WRHfkkSi2snZ1/Mv0ZExG31lV2YvdtrfkZzuoXYUuZvzPjFSskH1zuQzi9N6xZAZqbXdOweAgKM28f6CGSbGoaoO6UGNPCFllAkBpt4LzIXfLIzKnLsFU+HlPe+0/1HnM69c4miy2jX/HC63wRiYx3XUVakeYn5mlQhj//Kd/PwBDOiCK/3uS6lko6wNwZMXfX17jqNtX2/AP38nWY32mQvDZAK5MWqfd5XOQvGAukeQofNPDVfA/lWM3TCIecONFyKGlf4Ja7IjMMuSl514Eqy14uKgYSrheDneRVpxuNxTTZ0hHIXZHJ/fSm+ax3V0wm4dBVSgaUKlIuAO6VnF/QGepfcKWcb3Ps52Y1Aao+qz26PM5sz9pqDkI86EM1gSwjos2JX0/BtceNN7OzguLNd0xZWZfyKDpFeKJ+TF46XUfhZ+zwQu0dyAo+ixVMso8kmZaTu8fHoDrZ8F00/gtwwIil7XVS4TSxEwIwWCMrE5mroFZ39pzaQle2kaUn0sGXoqtpYksNUxChSx0VJwTXMrmnGimpiOnp/kSTScRqPEuftsb1aSSPAL1ywHNgpsYkCJIPlVshWtArPOawAajCG8JsxD
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:45:41.6823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34965a5c-78c1-4656-a00d-08dc48ba2009
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8737

TODO: Either apply this in advance of sevinit2 patches, or drop this in
favor of a separate preceeding sync of 6.8 kvm-next.

A separate standalone linux-headers sync will be used instead.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 linux-headers/asm-x86/kvm.h | 8 --------
 linux-headers/linux/kvm.h   | 2 --
 2 files changed, 10 deletions(-)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 8f58c32d37..003fb74534 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -562,13 +562,5 @@ struct kvm_pmu_event_filter {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
-#define KVM_X86_SEV_VM          2
-#define KVM_X86_SEV_ES_VM       3
-
-struct kvm_sev_init {
-        __u64 vmsa_features;
-        __u32 flags;
-        __u32 pad[9];
-};
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 5fd84fd7d0..17839229b2 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1865,8 +1865,6 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
-	KVM_SEV_INIT2,
-
 	KVM_SEV_NR_MAX,
 };
 
-- 
2.25.1


