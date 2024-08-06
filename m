Return-Path: <kvm+bounces-23363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF90948FB8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D32211F23130
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A461C7B64;
	Tue,  6 Aug 2024 12:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ThmMHlx3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111231C68B6;
	Tue,  6 Aug 2024 12:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948932; cv=fail; b=Z9ifxgsSKdajYmHu88nsVp0eZuWWGiYPCE3WlJ00AES3I+l9RbojgaA8solzL7TRMI0xjmOzCrsdqXwDAJyL/EdGQQOblmq/qoKsHVsJaVnOK/X+tVphBZFVvd6mqyMec5J9HM8ayvGzw9u2dba4+zy6og1MNMIAKaxHw7+LOv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948932; c=relaxed/simple;
	bh=k4NMd9/Oef2ZoLEoL8QQaXmxAC2WZcEykKDVWYdf/Ok=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pMFXn46KDp0DU+/q5XxtJsLIb1uQRr/ywfX2Q/MN6nX06MCx4hzD5Ye6XJzNsaNlUzjRYam2hhnobRAnPAoOpmEPkJ6Dpq5t1NS88y+i+456H++yFrh5QzHjPqwCzPX7HlfZd3uc20iK3ccJ20ZxgFQCHn2Nxsdpm4T/p7sqL28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ThmMHlx3; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSW30tHM6xfD2dwWMFgJsTw+oH3aQVPqkyNpuagalT/iTDGEW1GwxMctPSsFs/9Hwlvyv5CWr+PyYv3eeTaFGaA1DkIiPJIHzmTuC44ZIwLGuNK7v8zOWASLVRuiYynq4i+siWAqYfR5rZBlUu64o4+0c4Vbe8jvg9+yY0zywLWgegzlo+BvnkblqwO5AizfnrgosMEeGVuSBhrOaP7CuPiJQHextMGs+SMiMVs57GXgF+xQNRp6B+EyYjknUO50ncnvg1j27iA16ReFr/CYpB5m6u1DVoRFoYvrfocC78o96zzfxl0xOgjVwNPwvnDV13JDW/tVljNUNzKlgKGE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlu7IB+HJKWz/T/yFB5c1oCldbQ3ZFftyFTeoVgbgpg=;
 b=ELwCtbvao9NAAjzFpBpbRzhtA0U/yUYulRuk+HQKKENxzbPLOVPxpCcPknnW/1HhUD3pqwoy31qt4ugfhLETlt66YJDxHZeErp9u35T8FvrxwrEib3TKpFQIauHVoY0Xl/P8x9MSnVSyIWPQ02KWyPRWBbsVmqr9fU+gq3g1sL2Yx46l7XvA4rOeMX7KLdxwPm00ABGcHsQq4QRuDk5VCKBNcF7YoWAi5CsrOdmndHnuNCpzd2PbBV22JFPkJvtiGNElgfZEPQ2sDj4jy+lz2zOvabluIXA1i22xXdjD5LKYO5h0Sj+kLtT/Y7fkYfCwxov6WFHg372SeMaoH/ucww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlu7IB+HJKWz/T/yFB5c1oCldbQ3ZFftyFTeoVgbgpg=;
 b=ThmMHlx3BPbqntefzqlM1XhbASUvp0qrHP1x36A1x3+bzAYuRV8kI72bgG2B8UoRnNNvUaU2xhiAeoYfRBKm2S+A3QUuQUlTA10+gQd1SGdn1+icxNmAFPneLODTXtUSx3HgUc+X97Afo9QOt6rccTZWFRvjHPuRnlI97cEpo4o=
Received: from SJ0PR05CA0091.namprd05.prod.outlook.com (2603:10b6:a03:334::6)
 by IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 12:55:27 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::23) by SJ0PR05CA0091.outlook.office365.com
 (2603:10b6:a03:334::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.10 via Frontend
 Transport; Tue, 6 Aug 2024 12:55:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Tue, 6 Aug 2024 12:55:26 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 07:55:19 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>
Subject: [PATCH v3 3/4] KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is missing
Date: Tue, 6 Aug 2024 12:54:41 +0000
Message-ID: <20240806125442.1603-4-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806125442.1603-1-ravi.bangoria@amd.com>
References: <20240806125442.1603-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|IA1PR12MB8189:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ff212b-c720-4d93-8a76-08dcb6170b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M52xhugRWgzKHd3FrOdv8p4CkTLS+KqPQABgIM5SEP8XajOY24gBNbpWqbxg?=
 =?us-ascii?Q?45/WEND3ajHfE5IjBdMlAkSO5M4UtMxbyWVXNH9zCh9irp+WbLJV32CzOW7K?=
 =?us-ascii?Q?xuNxl/OULyhKYtUCMFCYeus4av8YPFbS+hxC4z9u8p+VoQOIhwGhMz/9wEuV?=
 =?us-ascii?Q?1XL9wi6KA2vUBrOj5GMBtH0Qn69+O2wpjOky4ZrQlnxOq/Pg1nKdsOPg/hrf?=
 =?us-ascii?Q?eS9mXlhaW8kTM1Mt16hz/C+PTM02mmOHGIQZrwgabxFa/LUO+ym9qwIDtOfV?=
 =?us-ascii?Q?ffYj1M3UmeXJYHM94QPCkcgfCOutO/9Ys8lQ3Q+UcIRp3+ZDssFKbRg879Ns?=
 =?us-ascii?Q?0KMjCutVPBgg7XXhtPp+YXfhf9TMEwvWlc6zcjhI5LjEpB8T3BtsPM6ZJaXj?=
 =?us-ascii?Q?y+b+be6rrizg1m7K0u1Gr6dNngIc5ZtYWcYuuOXvq/2lHBXLnXqZC3jlT1E+?=
 =?us-ascii?Q?BmKb710lk0yaOCHDi0Zj5W+WnraAjEzJ9iw8Fxg/yqRCliInKgutIoX9l1BZ?=
 =?us-ascii?Q?4099Tfqg9kz2foZSjc0K8pPWWY8d8uIvgB+9TdZi6gl8aYFplXrPPN6YIT7q?=
 =?us-ascii?Q?F+kopEDRV70hIXqBiCMV2O9e2KCkIUOXSWa/opEeZC+R1Yp43U2l6Xtgg0+r?=
 =?us-ascii?Q?LD+3pXgSBPk0yvwq5NzIAo/MKDSduV/IqP7adD5y17sCzNQSlwYdRDtNvU0H?=
 =?us-ascii?Q?wzuc0cjpEhA8+6P6CR8QqE8Rw9/Zl5ep3qm+9TSXqRjDqoe0c5d+6bumNV6w?=
 =?us-ascii?Q?8PyqHarto/922kWy+Lc3z1hS2JsszEMJ3orW11LWQ9SkOz5bifYFpXu1n98S?=
 =?us-ascii?Q?ialhvp12ajOAv2wuOHMbujb9ZqadQ4VY7JuXnF5PMeXPbve5eCwVGoGOX6uC?=
 =?us-ascii?Q?ThQX1g99PIbe4gLwMUc8n806cK/4JeTBS4nSNpI5BONlZBEVHpESDWp9KITa?=
 =?us-ascii?Q?gaIjwuy7aZcAh9/QZp3+o5Wz2nQenQnb8dJNvl4NjEfiIUisd4YZn8vKMg/l?=
 =?us-ascii?Q?rnaYedm+ojHdip6sARNHYRQ3FQzHf1DnmIdTIQKlY3RcEMXCMyijympen6ZK?=
 =?us-ascii?Q?G+LtBzJ/A71m4U2pI91iMNr1xXCBn8Cmt7CELJLs2eyf4EKief7cyLcq/yN0?=
 =?us-ascii?Q?zLZ742LCMYZoNqsrZqfzC7S4mdEgz4hdqSY0Ofx/RGmUYVCKKVxDsycaXRg5?=
 =?us-ascii?Q?BUAoUiOy+qLxkuePISVn6trjOLTUw39jb27e7lPu8x8KcJvIJR0oUZrQr52p?=
 =?us-ascii?Q?uE9aaD0CBNA7zLqKJqCe5nsBP/NRLgwhLyKvdE9AUa7egYr8SB2aPvLdz6PR?=
 =?us-ascii?Q?XkmCcEc3hp4SeICqmJaDR3QQq11Gu6UZ8lHed+Jrm+EjOEMZ8oaYR8LTUd+I?=
 =?us-ascii?Q?HP1KutG+hywhyc7kC7Ioelpeq9eqo0b3A/pnEXJPNvvmquELfw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 12:55:26.9347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ff212b-c720-4d93-8a76-08dcb6170b5a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8189

If host supports Bus Lock Detect, KVM advertises it to guests even if
SVM support is absent. Additionally, guest wouldn't be able to use it
despite guest CPUID bit being set. Fix it by unconditionally clearing
the feature bit in KVM cpu capability.

Reported-by: Jim Mattson <jmattson@google.com>
Closes: https://lore.kernel.org/r/CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com
Fixes: 76ea438b4afc ("KVM: X86: Expose bus lock debug exception to guest")
Cc: stable@vger.kernel.org
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..85631112c872 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
 
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
+
+	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
+	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 }
 
 static __init int svm_hardware_setup(void)
-- 
2.34.1


