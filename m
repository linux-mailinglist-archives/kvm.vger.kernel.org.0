Return-Path: <kvm+bounces-39261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 820CEA459A4
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52B027A4CA1
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2A7238177;
	Wed, 26 Feb 2025 09:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c/pTMwIK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F41238144;
	Wed, 26 Feb 2025 09:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561042; cv=fail; b=azIvP4umhOvB1RrBPSd0lmb9X8EUAfuATNo6JtdVM5cDbVLbDb/3owF0wXkx+MZeRiiHG+xed5EGov/elyD0ENd/CqDa3gsZ5DJuyj8nf14UNlxt/XFj4YvCnTmuNh4JqP8BVdR9jEQzA1M8u7DjRT/HP4lLaMi70hnfjuWwWlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561042; c=relaxed/simple;
	bh=+Xfnr8MphZpO5UPasZrEyvdfar6bs/DjsXE0jSJEj7E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gG0o7Blcq3zF3zJGLP2bIYGtRoK20qkXAPT7Ad4eGg2wH6yJGtGljbaXpAXnmxes3YVlCXP4lezey3OcnK+c9XOzCc16ZPzA4dMqwm+pF5ywNvcHKu2JorTmi9VeAE/XWCrLl9ELW5l+q5bjYtpf9QNv28FfKRAGli70HKZq40M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c/pTMwIK; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSRfFXn85JaTKiUX+7UJFIgKYbF9yrUKFZJ1kVlBpn0+qO0busxOpa6qhavkH7iYKFbmBGHQn0PVztE7tuMk8uEq1SvLJegUU6M1shtQPJ29rFEYsO4n1fsVZ4cvsTH00NxPEroZMV32zj8qlVEDZvaG2z40iB4xYgDeFBi4+VDgEAAqT6Z4gCnI0I+CifC2WLnJdJF2eqB0AR1amDJeCORnFjWH/NUwEeWwHuq+fjXVlRyvOAbjSdtcFBhrJoRfCSDCA1gDi7hKnwz3mqsq0vK4lNCV4GRCVV4C+yRc9ZJW5TGQ3jLs40ot/RgvKHEUB3gYBQ2XnoZl2r1e1UDl9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBAORP36+LI/H8y1KciXv1sNQQQDjvx7jAtkOVOA/No=;
 b=fU/b1K4cTJI6LJ0FXGuNaee+Jd+qVnSrIZv7139wXasAAmap7ZXGZDHHHpQQDMeui8XB0Wu4Fi6sFrkZQ+kt8xAosT4E8M/XZLpfdn/XbPhkQ3+4y9iwsCH+rT68iJqLzgu6P+Ho62Gf4mcW+5iSBpCAPb1kQp48edy8oB5hr9NNd90iPxH1A0+cijGSRsZxdEOUkZjmXbp/8tJntlxU0Bwb7bLwkPv6bdjPH1WPVZN7fDLKGvFGCmNE1rpqxMK8l6rv41pCC7BUs7PAxO5hKXcre3gHgYU7TpYDdWbRnaNqXM6AY1O+VVDbgYPbaKjANWxV5DE0bg1wZNaCMRjfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBAORP36+LI/H8y1KciXv1sNQQQDjvx7jAtkOVOA/No=;
 b=c/pTMwIKh1qs3qX+9TC6Z/YpoQlg2IaOEwvW1cnruDAYnip8F2qT4bhendvdaPP8D/Xnie/Zd4xMKJ+4tZnXu/2/1ctSD/xqnwvgcMeIbwQCMlfwA31edyVKXrei680ecfvBshOuNUY7YG8I6kZ8/4cEf/wuMZkw4LZJkxy8cfM=
Received: from BYAPR06CA0055.namprd06.prod.outlook.com (2603:10b6:a03:14b::32)
 by DS7PR12MB9501.namprd12.prod.outlook.com (2603:10b6:8:250::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:10:37 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:14b:cafe::60) by BYAPR06CA0055.outlook.office365.com
 (2603:10b6:a03:14b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Wed,
 26 Feb 2025 09:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:10:36 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:10:30 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 16/17] x86/sev: Prevent SECURE_AVIC_CONTROL MSR interception for Secure AVIC guests
Date: Wed, 26 Feb 2025 14:35:24 +0530
Message-ID: <20250226090525.231882-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|DS7PR12MB9501:EE_
X-MS-Office365-Filtering-Correlation-Id: cc209ac2-03ce-4090-1978-08dd56456eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ARd/OCJOZlIee13PvjpqdGSIfm5FPwLJ1zb1NZP2LzOAlrQdnzVrY7OGVg5K?=
 =?us-ascii?Q?K+76/RQSkC6GcMEgNlFsFpcX8jB2fSTQNBlOtC7rReEfoXCRF7mh5SsZx3jC?=
 =?us-ascii?Q?TIcq4l+shVakGQj1UebXQZqDsCLO/Rlw6XftngsbIp2qlstkJqXhOoe46VJD?=
 =?us-ascii?Q?PvoMSL1IsizfG1K7+ldqEkbHcAggfn1JLDYDCU0E1jrfpih7OR1cLJgHXubr?=
 =?us-ascii?Q?oSqJyhUQCijtTEzrU9LibS6nwvYCyIPYRk4WyOqiUqOZjH54bESs0U7/Qvzh?=
 =?us-ascii?Q?t1sNQY6hjGXQZrteq9rJdnLQszF3NGjsr+BjcWMZoP58yZMxgGIzDmhuipto?=
 =?us-ascii?Q?39XDlDgHYNLhxA71vCQJfsJP+KP+PpUu7fq/sH4XlJEaBfaPfVoTOXCBjfJH?=
 =?us-ascii?Q?46t93WYxHFdglGih/rxFe9UVSnAJ8x1In7zpX/kdnD5vJ5fhHLXwOxnF6jXz?=
 =?us-ascii?Q?1+cdtBtNq5yzzXMRCjTXirJPbDfWGDvpgZEkuxjk0Doyzn7cSNV1cxBbOy/j?=
 =?us-ascii?Q?VA9UeAeUxr9BcDCxauUEMfFBY18Oa4a+faWRqCK+GWltvXbiJ/WeANeEIU5B?=
 =?us-ascii?Q?R5lAsD9H4R8pyDmRq90md4lVOO2zEDlEkBrGWCB2UGbKJb2JHMI6pCWQG6/X?=
 =?us-ascii?Q?xz+AQpCS6GHjaSdcsk73TBDPcr4crjUf5/AN7NtzviCOCstGzlnytsbIyoRh?=
 =?us-ascii?Q?xXMFy5lQ/EG5RosKzMgrShXC4OVMagS/H3hMjvVD4WNFV0SL+FtGIr2wCeh7?=
 =?us-ascii?Q?vpXXxSgkg2yIl5NazEF8WHNCOjm0LhKny98Bh7YSA6w7IkZgX4mJH+hrKrBy?=
 =?us-ascii?Q?INJB8gT9xDC9iREnIgpX5dJF7YAeZqB/at+2GchxRj5uNd/hBY+OwAtbhcim?=
 =?us-ascii?Q?tS4h7a9/8RwsP1QF7NQzUYaTWa4TLdVilwpq+IS3uyCX5+v8ApSC+e3KIXyw?=
 =?us-ascii?Q?q6P+i65lq3bLXR02YGBOyQ/YUtymrJZbaN4IgTQJ9mZ+GjQqs2bOBPiLqXEX?=
 =?us-ascii?Q?AtMUZfo3Fpg2MiLROEIEQH/sk0Oxp/n8ej1pd6Dqjb/9NjZivxoMCgkTjEyv?=
 =?us-ascii?Q?dwK4p7k4Z6xv78PM3vpaNQHgylFpuQjLM1aXrjeOPQz155f3pIfRpR/URWwx?=
 =?us-ascii?Q?u+jl6F0jSV76yLwQ7ksPl43BiSxB76+azjL9zXfbRlDXeoVQ3ri1St8fhhDO?=
 =?us-ascii?Q?6z8y5qIq5B7sYB2nZfCcD/qCa/vkE1CBiQcZ3mMEId+A0aOiH49g0SyKqQns?=
 =?us-ascii?Q?FKofoU4OUQc6wc7enU+6CoJAn9b2U+5HamSko+uMfTY6XCuNeX4MnJkZV9xb?=
 =?us-ascii?Q?UpGQdbPDscL4TMyXG7ndIqJPGJfW2lCkvOsZsbrcDSadYRQbh9/5x8WMUEQF?=
 =?us-ascii?Q?lcn96JR7F/sjxrVOAEvIPi9f6K8FTKU4mJsrw+A48GDW9k4R3QK+2kCLcnqA?=
 =?us-ascii?Q?s6rSTg7xgF2xyfCCjqo4Aem5NLWygyPo0BB+vecd5WBOdlSgXnB15yQNpmTq?=
 =?us-ascii?Q?JaZKIoPhjhXmHZE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:10:36.5010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc209ac2-03ce-4090-1978-08dd56456eb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9501

The SECURE_AVIC_CONTROL MSR (0xc0010138) holds the GPA of the guest
APIC  backing page and bitfields to enable Secure AVIC and NMI.
This MSR is  populated by the guest and the hypervisor should not
intercept it. A #VC exception will be generated otherwise. If
this should occur and Secure AVIC is enabled, terminate guest
execution.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - New change.

 arch/x86/coco/sev/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e48834d29518..0372779dae70 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1483,6 +1483,15 @@ static enum es_result __vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt
 			return __vc_handle_secure_tsc_msrs(regs, write);
 		else
 			break;
+	case MSR_AMD64_SECURE_AVIC_CONTROL:
+		/*
+		 * AMD64_SECURE_AVIC_CONTROL should not be intercepted when
+		 * Secure AVIC is enabled. Terminate the Secure AVIC guest
+		 * if the interception is enabled.
+		 */
+		if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
+			return ES_VMM_ERROR;
+		fallthrough;
 	default:
 		break;
 	}
-- 
2.34.1


