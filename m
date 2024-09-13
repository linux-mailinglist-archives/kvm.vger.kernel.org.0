Return-Path: <kvm+bounces-26806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A392E977E9D
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2427E1F21010
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6908D1D88C1;
	Fri, 13 Sep 2024 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iDy3JP42"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0AF1D7E3F;
	Fri, 13 Sep 2024 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227588; cv=fail; b=S/2RObrsDSe3BnjiCiIYmkVdlazCZ/nFvb/fOwfRE8d7a+MOv6ifrI99lleBzUfXRCXAkWsPAsruOmmp/gh5m/3p/tlMuzYMzPGt3jorp+YgDE/+Jw1UyrexeSjnQdVVI3qTXcP2ZtkHT3K5WW54Tl/fmADpdGugI5Sirw7TSBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227588; c=relaxed/simple;
	bh=qPS2UKcXpWFapAZDS0TrZ1R28NMnEMGQa5KRNQXQEFM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WcHhB+46msek8TYpz2zxdPU++Th2DNTETLKzwpe4UZkvue6xbRTkEsMEnKyhTXwtjqPkOFP6X/NQTcSHLzYBBxTu+XSmM5fl6sPIN01aomS4y9cCepQIDPH0Ca6bLpVB4aBaNcADVIyZP1SztU92zcOcGwhtFQ0mfWtGleWX9Jw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iDy3JP42; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LejDpnz/hH+q3opYBIpWSY7bdKZDrz2YXX6OTmE6s+FaSV1KWjghRVMSSRqd3BhB0cgu41I87ybo3faTglyq4YCxr4cfcNjEECK0u4dOwytVxhYGEI/A+qiKr9lhYVQRocFPWAlqV3N73vcpJgS7tLWHucX+WDblrMNZ/0SfAWxjHCU9IMcMa1AkoxNToryhW08ytZlYp80225E2FdZDEpMAjribizEcnXjeisEoS12FbK7dtJpbey5hYf7YEKgRK4AE6D11+OkccF4+3AiKd8OTkvFfCpRd3YdXuwt+QT5k7blqCQcy8glqUkqLp/zWlEe/rmBGnu7EYTZpad4+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ccrGtcravS2b69ecuyF8dTeUkQAbnHDqFr8wMofnE8=;
 b=aRPgueqSoQIYqbsookEdXB/lj4QAKLIWMEGT+949UcyqgOcgUKeVWfjRnenyMZxyhvYo/aqpjd/QXQ+ZjplhlwhigMsBaReLDTJ9zNb2qBJ42zMlvZp5mxwkDNW+axOY18mGh2rlYBKRg5IkWG/pgBEx9Sr8n7fUm/LU4t19LdfiLUU/vCrq8JY7xrFjDEV6SrPJuko4C+DjIpKscn4ClYnEg/wI0TERa7BT7GQnQ/Mq5LiOXSpxIuSWcJQvqnDWMG4SusBUlGBwo1Oebg9wY4earHIqxryjHAYgGWbUGuvll6tOU7bEZyzBlaRgKS4Xf9F7ik13sidNG29a61juXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ccrGtcravS2b69ecuyF8dTeUkQAbnHDqFr8wMofnE8=;
 b=iDy3JP42tKEGHKPK/cJzwVo3h4JnaWWOODYHYLhdRNI4NmwJhVE1owX4ogu31nBTl8HoodatAUes+56xqdLHFeejtlowaBXibxK3nK7pnXYrv6yHm0fpZLKcYeu74GHBLVoE1gJbQkJtcFHq53qGigM/WlxYZ+m6xtECczeiW4U=
Received: from DS7PR05CA0050.namprd05.prod.outlook.com (2603:10b6:8:2f::9) by
 CY8PR12MB7416.namprd12.prod.outlook.com (2603:10b6:930:5c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.18; Fri, 13 Sep 2024 11:39:42 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::40) by DS7PR05CA0050.outlook.office365.com
 (2603:10b6:8:2f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:39:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:39:42 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:39:36 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 08/14] x86/apic: Support LAPIC timer for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:59 +0530
Message-ID: <20240913113705.419146-9-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|CY8PR12MB7416:EE_
X-MS-Office365-Filtering-Correlation-Id: 27386697-c622-4cf9-142a-08dcd3e8c22e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y/klL495o2Jcql9xSdO9+vl3E7uXkIPPEBJFV4dSgwyPFWfs77XzKM7UmLha?=
 =?us-ascii?Q?D2ufDdxbAGCmpNEwVFfPSMcioW7J8FLPZG6H/DPQ2mfYmj93y4ax3bbEYWIe?=
 =?us-ascii?Q?tSZj8taSJEIv3NjcH4NNUUjQI4KhLG1Rm1iHb6hDhfy1o50rvTNJgjA+RVbR?=
 =?us-ascii?Q?UOrUlvCtmK6wkxJxgrZWdBw2YoMQjTErQsKasIHRFhVoetrqWsI7N9x/iMXK?=
 =?us-ascii?Q?yU6w765gfmQMSHZl3PmPiNRZlfkTCNmcJ4Uv/nfpx7thbEAaJGYwzutZWJjR?=
 =?us-ascii?Q?022QzbH9Gb2d2sJYbVoKlBM+CRcaW4FrmkwY6youz+3DaLkz35EpAHUd/85+?=
 =?us-ascii?Q?RkDljlt9LJYX69hGfE3M+bU/tJ3tPAB3Pn7u33LkMMVQbFkfzy7SBLde2h62?=
 =?us-ascii?Q?YJ7pjfK9VnbpV4UzuvJT0h7cm03dWRRgiDQ2Ee2R84yQm1P9ioBGSRGQ23JP?=
 =?us-ascii?Q?xK/XKUnHuRPNGzYCHOITi1+GPJC7S2I7/kyreb8k46kIAHIg+nL05DDZMV7x?=
 =?us-ascii?Q?4bzSm5Ci43XWfcPa8Cml6nsuDaPSqXicgH/eeiER5aTjGdiWWFjU7LBHSzFY?=
 =?us-ascii?Q?hqNuq1ldc4UyrrdSHOvRK8fRLBcMm/hCw1l+e07a8jSoNfOUkN3EUkFaNzjg?=
 =?us-ascii?Q?XROKOjwZ/h7kJLSBV8pTLIQdhq4EEtzQScyguaFHSWhfJZo1ywtV5DZZHEL0?=
 =?us-ascii?Q?P2oYpTONQn07EN2ovfgXXxL5gzhK3GKWmI2XAPDtpVQv+XYOIfneS0jnJkw1?=
 =?us-ascii?Q?rv/qlEa+DjYxM6Dh7SIS9vZOLR2qytPJCjX8nKsFVMrbp4Z2tCJLQbD3KTW4?=
 =?us-ascii?Q?HlqKYgNWH8qETEu3dIzIu5rzHTo+IQnGAk8ZtoJh4g8KGv1M2svqK6d0VGh7?=
 =?us-ascii?Q?AI8ULyKKaVKuPiYxVx55ujCFVD1e8OsQvPalTcWbSxjpDfo3Pbc0MSTE6wch?=
 =?us-ascii?Q?iHVlggUs3zkYhiPjdwWRVu4gfdkbfUM1c9oU3XYmrsvpJsV/IkrsVeNrNR8o?=
 =?us-ascii?Q?cSiNMe+uqk2FmnTIoTltSTdxAqlLhg2ej4rWRPA3t3rImt8AspPFo1/rvVrm?=
 =?us-ascii?Q?bKwLm3OuDPpbbx1IwDOP0GWKe0qF5YWQ5Ph9nSx+Xeq74cF890ThxPZ9mDjE?=
 =?us-ascii?Q?hWAXnJgdjoceRTnnvV6Y9anhyLup/QxKA5DAuMXYIDFu57e0Dkq4C7TwHMZ2?=
 =?us-ascii?Q?Y8fx4aj+2a2gzgVrRGeGlFRvHmXm88OqxYY5SKl3EUVwQ/T5VsqJy00+c3OU?=
 =?us-ascii?Q?1DaTOjI/4Q9vJxNToGW0UmJyTgoprKzNPVuvCmI7lbcOqVMmupuYCBXDL43W?=
 =?us-ascii?Q?Adh2eSfoLObAXOd+Xybvp1xcZoMCGKWz+pI+DVflmMh2Vr7NBG/jyUr5PMRn?=
 =?us-ascii?Q?NtzLPMX7LZQflraVD93n3f9KH15tKoLCrGlVJNC/r+s7GrBNFrC95hiq4lEk?=
 =?us-ascii?Q?JkOvlZaiYaw/+ha4eN5JLHVCzfJ+0Fq/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:39:42.2503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27386697-c622-4cf9-142a-08dcd3e8c22e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7416

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC requires LAPIC timer to be emulated by hypervisor. KVM
already supports emulating LAPIC timer using hrtimers. In order
to emulate LAPIC timer, APIC_LVTT, APIC_TMICT and APIC_TDCR register
values need to be propagated to the hypervisor for arming the timer.
APIC_TMCCT register value has to be read from the hypervisor, which
is required for calibrating the APIC timer. So, read/write all APIC
timer registers from/to the hypervisor.

In addition, configure APIC_ALLOWED_IRR for the hypervisor to inject
timer interrupt using LOCAL_TIMER_VECTOR.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kernel/apic/apic.c         | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b47d1dc854c3..aeda74bf15e6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -579,6 +579,8 @@ static void setup_APIC_timer(void)
 						0xF, ~0UL);
 	} else
 		clockevents_register_device(levt);
+
+	apic->update_vector(smp_processor_id(), LOCAL_TIMER_VECTOR, true);
 }
 
 /*
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 30a24b70e5cb..2eab9a773005 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -94,6 +94,7 @@ static u32 x2apic_savic_read(u32 reg)
 	case APIC_TMICT:
 	case APIC_TMCCT:
 	case APIC_TDCR:
+		return read_msr_from_hv(reg);
 	case APIC_ID:
 	case APIC_LVR:
 	case APIC_TASKPRI:
@@ -142,10 +143,12 @@ static void x2apic_savic_write(u32 reg, u32 data)
 
 	switch (reg) {
 	case APIC_LVTT:
-	case APIC_LVT0:
-	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
+		write_msr_to_hv(reg, data);
+		break;
+	case APIC_LVT0:
+	case APIC_LVT1:
 	/* APIC_ID is writable and configured by guest for Secure AVIC */
 	case APIC_ID:
 	case APIC_TASKPRI:
-- 
2.34.1


