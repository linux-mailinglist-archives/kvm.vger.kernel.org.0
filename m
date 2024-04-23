Return-Path: <kvm+bounces-15680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F018AF3F5
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214831C23C68
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB1913DBB6;
	Tue, 23 Apr 2024 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K7W31fdf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4431913D2A1;
	Tue, 23 Apr 2024 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889483; cv=fail; b=XhN+6khdx35hbVp1Z1QQUSy2taqn+AbBxmOBcysyvd7uOP7TujtWeTkDCxhZEseOOsPjxvCZENNDemnGTQI47PCyYBntC6GnpCragQlMu15IsmEkEoAJcqdbLyBd24W47Jxi1F+rzkbkA1tm7tTuvWZ87WKr61IDZMjDkruMBYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889483; c=relaxed/simple;
	bh=ndRHF2MW2URA1oy6abj2zgGr+S+dvl8BfR4LgHAK8YM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GKNcfeSWKbqL8UR+sJIQb5YImPSayPt6H2i3yNIL4F0csjKwxfxKK7L2CwmJ+d4hVucqKTpg/gTBm9rY6ztKcCkLMdrgRp3tgj9XFw4GfhnGNio7UzeGQRJz9MGI0cJmDH65WNZTKL09oseDaIUq/jxNbaArHpQ8diqjT3wuOsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K7W31fdf; arc=fail smtp.client-ip=40.107.212.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/EE16NayFsF+FhtM0Iu4/GSdbjyo4C1iBtsaTcjqL7kI1kZMLW+hJCPfwKUKl+mCBOtfyxknY3wlOsFsB7tF2WPZaYVm0UqOuc0aTYzcTlX2N5inQUzs5LFWSpUnfFQ+gMIsCWXSGz1pYCoOPWppTFwZQJCycCEdJ3sTm22Kt6ePj8gH8jDMNc+mENDYC1IEcP03aat1ZKLaAViHhTQHPxhSyuW7iB6WJKwYvtx+pEwBRTB/+IFPnJeSeIWc+xHOxmo/JBgXjt78XsoPAn/Mmgzvilry1/GC3uyp7/kL/vtEL0o476OZbscihkush4CdVcXytDlj+TL3YweoDJQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BY/I7ozujrmCPZSKVlzIglXdTpwpe1w6o5CGT23N+mY=;
 b=mP3vAyygOeIg7PLdaITMakd8snoad8LNZZQp6LVxqLb9ik73NsQTW8O4Bd9ddSlayeqoy7o2m6NuS4mZ81WMkwvDD9VNQCowHzEykQXaYM8XkAYgArGk8+X5tYk3UO+0bwCRC1IRU+QhS0UDE5CVyS6jNlrZvqnKNiW9S0U3hBAMSB8lMhuJ64iLSVg/CF6AJZk7MbffRKt3IkKButdbr9Va3RvLoGZcBrAjAJjr7pA66JnJ6r7ZWkKyeWRcrvPmkSpHsPU8mZhSvG46o9NJY56lP7Z5orGbFWOf+jpbCcug4ibT57zr0Oeeq0N53jRRTCMp/lu2lRU3o7DseBDyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY/I7ozujrmCPZSKVlzIglXdTpwpe1w6o5CGT23N+mY=;
 b=K7W31fdfdblGwh56Y06HEWZETCOz4akX39lfYFbMpVLqbrBgJ+JMqR0WTcEv0IZiDnDb0OqsFH3W8L89NG0H4w07HiUngKC2UDSeSVMNF0l64JaK6R2XmPmxESK8jVUDZfmqnRxXcX6NZKHGShaj4Wv8wqZuW8rTQ7JUHzHmei8=
Received: from CH0PR08CA0027.namprd08.prod.outlook.com (2603:10b6:610:33::32)
 by SN7PR12MB6837.namprd12.prod.outlook.com (2603:10b6:806:267::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:24:38 +0000
Received: from CH1PEPF0000AD7D.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::54) by CH0PR08CA0027.outlook.office365.com
 (2603:10b6:610:33::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.34 via Frontend
 Transport; Tue, 23 Apr 2024 16:24:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7D.mail.protection.outlook.com (10.167.244.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:24:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:24:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 25/22] [SQUASH] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Tue, 23 Apr 2024 11:21:40 -0500
Message-ID: <20240423162144.1780159-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423162144.1780159-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240423162144.1780159-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7D:EE_|SN7PR12MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb5a873-f16f-4084-e72e-08dc63b1df23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l6waoU2XMOWanTkZ5WtTnMNx+kcSGXWlJf643oUy21oNNktezfgEw97q2sr0?=
 =?us-ascii?Q?J7spJ1O6NkYxXNFOCYq6CaVdZMeGY0y0ExUmD/yR2ts78c17EJyxcwRoPiRf?=
 =?us-ascii?Q?31oDwUI8kyg0Lc4xPyKjcE9SWpwoJxvQVwRJALwRPnQQSkGHrhnEeY6y/GI9?=
 =?us-ascii?Q?EG9g9KgkE7dgAIYulnrw4JjP+X6Y/o8VSQA9+6qMgUYLfdY3ckK8Q8ovNiqO?=
 =?us-ascii?Q?SFOYGW6kdqQxLPzhee8oxgeVoXedV7xQ/s0kloOQKguPc+RABnxSogeGR5oX?=
 =?us-ascii?Q?cDe4eFbcU3ZAW2ubA2tRlPddbOMmMjfBFa1UFgUvw7Nx+PDloU+LGbGAceUy?=
 =?us-ascii?Q?1oRVmEsuy8AzhWbMTGcTl2FA3nXQasbq0BCRv/8pI+NDKEaEXA2wciKAh2TS?=
 =?us-ascii?Q?tB77kMa/krYen79XHNmv/Sf5sOtyPfwjWFnhEAoSJ4Db4ZyYBbXN1Co/48rs?=
 =?us-ascii?Q?IL9AsMTZSQbXJ/MClb+4Hcisz5wIqoMcVmq2kMp+9O9rHFQqpTppUt1zIJKq?=
 =?us-ascii?Q?uGvQUo9etSbocUBBYWQOGrmUZbnYOISMzTJA1T/7RW6i+44EwdxxknlDl4nB?=
 =?us-ascii?Q?yy0d9g/DOBqBwaxjPwi9YF7Nc9u89ytkMzVMymQ5+wmpDOHYKfCFhI+nKDRt?=
 =?us-ascii?Q?I01YdetCEWEx+TqMMoZRJHZ8yTJJb+WOJ/BNXvdgarBLLD6dRNFTx7Bz2QIf?=
 =?us-ascii?Q?+w5DXAiBZb85kyaPac9h4iHSMm8yx6fbJN3BOfl0UAdqs0+oujAppj8VLMna?=
 =?us-ascii?Q?tATvUJUPqkC3Nr5mw31s6yrDXRW8Cy8vuopM04t2MZBnwysomHSWFyHATpNO?=
 =?us-ascii?Q?zpA2fm2Z/w18Z3nPdcr0HDhjIoK3aA0D4fitMaCAJ8EtjUNDWWvD3wJkupkR?=
 =?us-ascii?Q?koOL2ZkJwqAz7xIv2iBDZbn1ebbRCwNJDgzTjZsrhhsM1fPcVy1gwG2CNN/P?=
 =?us-ascii?Q?cIPsiPdM2QBn03ksxudd6jKWJAh4OcQCBHM3UrDYMHhuzSpoZJtBjpyUlv+j?=
 =?us-ascii?Q?a3dXpySm7q/9h1+zaE4mpMViaW+lmdL34YRDqYTZ6MABaClnvNX9gAzDo8Kh?=
 =?us-ascii?Q?y5bQFfKgUVMj3Pkn/POi2x4eq+qfRXbhfLfmFzy1Cpe0hqvyfTTIv2Vg4DMi?=
 =?us-ascii?Q?I/ZwEycmRL5BUGrQhcYxoZcy1atBeoSQ3ZeRYeoxXDNuCxYEfJwpjPhkwOnH?=
 =?us-ascii?Q?OjaDbE2wq5onJzpQb2obusAN93GM7INhRoNzsxddB9WKYK/x9g5mG0XBazFu?=
 =?us-ascii?Q?EVB8EdPGLVYXc1GJd6jF/awoDmylL4OUp7cYdQKUQcMehNgHU9bvWpCNgeRV?=
 =?us-ascii?Q?rdp83BH1OJUqHE5PfiD8m0xzqlxdX+wG2G1wr+xS/zMOAD57r9VPTjDptS53?=
 =?us-ascii?Q?uMR1EuQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(1800799015)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:24:38.3176
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb5a873-f16f-4084-e72e-08dc63b1df23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6837

Report an error to guest if non-SNP attempts to issue GHCB-based Page
State Change.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0d8fbd5e25fe..c00081248ffe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3289,7 +3289,11 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+		break;
 	case SVM_VMGEXIT_PSC:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_TERM_REQUEST:
 	case SVM_VMGEXIT_GUEST_REQUEST:
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
-- 
2.25.1


