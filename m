Return-Path: <kvm+bounces-12252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE65D880DE4
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A9001C203BE
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA8C3E49B;
	Wed, 20 Mar 2024 08:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i5IbIviP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FD83D3A5
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924765; cv=fail; b=JnL60fs8AEbnn7Uj9g8mwcUuSMHYIao24ZX5B4TQQhK4AHfj0A7Vw6VSGnDzVXmTt655n99ndUe2WwccE0lQw724CcqgqTqzc7UgVq0yODvKD8hH5jOYNtFiTfAn61Dny3YaQkTcs9aWdK1NXGoLyJzHtsAdBpIEYYik90uYMhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924765; c=relaxed/simple;
	bh=pRCsLvxNivUJgkW27cPMphdcSs8wLQDJaTTMKpk5OhM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lt7VpzAgDAT+uKMr2AX9AN8QqYryhCDB8mnrHjDXZiR7eMZBcPwSp4GAAg9NrdW3jkjg4ot98Q7iADzpbID9szdXtLqQJo//WGwmTbBKz5cGjuIl3dfCh0fvjTGBwIirJw+gcLC89QKptMabI0Feknd6vyM3mNjaUr2XqK4V8Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i5IbIviP; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f+fjLeXVVV8jEnz+Y1Q/OMNNzffmtQTRk6G6BJbO8zU3T+gvQAilqRtxJN845MfWqZt+k7al/NA6/u+qUy6ovupzN034AEKaTMTeaA0X3yPRg05eSVbGrRSB7Qoq3sp9iTUpQpSZW9QGJpdJ4Lf4T6F3cL/3NIT6s8bHvWlVHLtYGUnDgG+okTjwf9T0HHqi/tdvMoqmKNk9lK6o2esHD15RRWuHEHJxe0y7mxP5ctJMZ++Iy+FKLj0ksMeKHOGE0tQ6i7KfcmXJstfaHgMRkuizGXLaD1JRYtV2WhYKi7JMve6uW7/0Ce48Exa7YS06Vlj7fW1yzbY2ZL/f+2uQEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5sFgg2keTwg82pvAJk1aZ1yzKgIfDd8vGO2ZlrZ5EU=;
 b=dzO8PA1snGXuFWpELC1fAf8MRijgetrI4bMLQhg4khfuun18GduLHl8cCHA4w7dUe+APt9H8hl7OUPi1uOwgiHfZZterrdQrXJfUlKSaCAExrDB1F4ev0gBghyuIWoFcVVcMYQtnv++EgeERLY320YsW93denpvqFu+HU18AnVOpr+nRizSXO1IdcJgzYbXZ6RE0X+00klI2PY2h6n/2djc4zZUbntKmGk4jih+snvoQmBOD2566iw9eiDGkXmLu1q9szWMQSFS/uJGZ3Rsmeeq2lSZyQ2SJvhDo5syCA19AduZFkwdta5nnoAeHBP3ypfYIGGYacqTvzNaci9+sbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5sFgg2keTwg82pvAJk1aZ1yzKgIfDd8vGO2ZlrZ5EU=;
 b=i5IbIviPMDfNN2PcWndpn4u/NIt0aOBBQZcWykKjIC+Imd9bq0zEwLZp5myqFgPtt7hsTjM8ZlDzmeZhSEIhAzJochJ19DupvMOpJ4t6gBALGRQ64ktIu+mV22amMFqoru0T2U4CD4atqXW9AXv4RYD02TTbdbf2egD+abjsk98=
Received: from BN8PR12CA0028.namprd12.prod.outlook.com (2603:10b6:408:60::41)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:52:41 +0000
Received: from BN1PEPF00004681.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::40) by BN8PR12CA0028.outlook.office365.com
 (2603:10b6:408:60::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:52:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004681.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:52:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:52:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 39/49] i386/sev: Set CPU state to protected once SNP guest payload is finalized
Date: Wed, 20 Mar 2024 03:39:35 -0500
Message-ID: <20240320083945.991426-40-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004681:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 667dd3d2-0b93-4e37-f67f-08dc48bb1a02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n4Wuq03sN4zKfmofXU9eEMpqz1oPHQYXDBc/ZWe2+LyruV6YEWaxHi3o/L/Wj1DrRNPJGTOWDLpXi1WRvBRlKKTG0nvZHBtGBe/RD2el7Jro3sfM65B+EiNR5kfCrffbfYUcngAI67qYyAMaUUPCjwPyzDhkhftt+MLPA/UuMpRXJ5rqFH1IqMunpjp53B2tmVQhe6Z0mtQuR4AwHAhWrhS7WCQHD/OPiTj7TzvcQqHQmCE45BLDyWHq3WXU9/m0WXW/QHGYgINVDO8evKN18P51hx5PGtLIk5U1ML7fm4zR+Z8tYRlyQimb3U8/L7hj8DgfK4qLtw9rY5bAJkuv8mzApII7nNVkX3PtarYj+BeUDHJaGYRetMl8BpwvAcInlhQZM9ugBKa0qMMZcnvFIFdRxFkKE3n18wmBw8FKA8YLZjC9eYOORJ4fpjZbugwtzDrewoqXmKkBUnaCgxrou+M7clQxVEYroYtlSEzeHH26AeijrJmM6/HD0fdr+C0Njme3EUH0meA71mPkQc2gLeOxw++R2S1iFapd0VlxIztlZgJPGypK8WNDnyxekO2lSoMXs8o+tlTbvyJOMK7OhtikaO53ghYJElsGGWi8XM1N+9d5qFlpl5Wp70aUzHMzoSd88WIzHu9ZUO1NPkKWBKn8Siy2ypgoU/LQVhZJBnbSKJj4+1wMCrw4i1tG2mPR/snmvgvhYKQoPe/LZvPZnsDGzocfbo1HuDaFCJTNovoVN8Eh8jA5x6bvsSvV+W3b
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:52:41.1785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 667dd3d2-0b93-4e37-f67f-08dc48bb1a02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004681.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858

Once KVM_SNP_LAUNCH_FINISH is called the vCPU state is copied into the
vCPU's VMSA page and measured/encrypted. Any attempt to read/write CPU
state afterward will only be acting on the initial data and so are
effectively no-ops.

Set the vCPU state to protected at this point so that QEMU don't
continue trying to re-sync vCPU data during guest runtime.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 4155342e72..4d862eef78 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -975,6 +975,7 @@ sev_snp_launch_finish(SevSnpGuestState *sev_snp)
         exit(1);
     }
 
+    kvm_mark_guest_state_protected();
     sev_set_guest_state(SEV_COMMON(sev_snp), SEV_STATE_RUNNING);
 
     /* add migration blocker */
-- 
2.25.1


