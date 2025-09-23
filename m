Return-Path: <kvm+bounces-58459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F44EB94485
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 437001894DAB
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1C330EF7B;
	Tue, 23 Sep 2025 05:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q5cqgBad"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012070.outbound.protection.outlook.com [40.93.195.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEF2274671;
	Tue, 23 Sep 2025 05:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603974; cv=fail; b=tlVfiHWprBi3XZMv/trdnFWP1qy1yWIoE7y1bbD7d1vWQhp/L472aCNXH2E9OnU1E365NXxilAB6quMmTRK9EU+JEb/LWRuUzxSPo50sOiz5s8YaCqIJejngZj96SwvLV6d3zT1/zm1NOSC39IfuGJVYquNwkk7J/GdKW/Asx5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603974; c=relaxed/simple;
	bh=QIdR+pPWCwfA4WStVaE174DLrBroidVyv2aRWaoACuA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F8IwgdQLSYK+5waM17V9ulsYWaWa3HDv6E/z5/Nn8xMMxOyJP02HmWywAGZe65ywoOcN1zgFc0cviSbAK3p9R9rN+Wn+JCjXRCC+akA2j7oEs0AXQFeiQklaF4nxhIHom/KHrhvuSD5nCrjMe0O1m/iV+HJeRswWQUu8J79Qwc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q5cqgBad; arc=fail smtp.client-ip=40.93.195.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FHuDm/xRt38rltbioZ/+IIe/dPie3AOfKPt7ctjf4rn6bQfV760bXBr9ubmORBYM3mvU9mToQCf8WHCK0jY0vQ3nKqbHk20AOJftw7oc/FJPdfv7k/ZZi3FIysXFnZYFcZMPSD0vIQUmoEnaUnVXn2iI5YZfHhCZslhk1H96HaPjV2zwu8/FqAhgkuF0phur3WS0sHRB7PJxN5N6lBzx0iePe8+xBehZl1S06ubXmgf7etNW2YhPYz4VTKELGABp3H/yoNft0j100lEAhQ5WCMXmVRTprYVWKQNs/OaI7zZpzWaahKVD/dQv1xm3wCNDXxjh7dPmN0IejLX6CwQn9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWcD8pjSMZDbeBThKlCrGF0+GLpyAyx4lzkRG2X1Xxg=;
 b=xX8iJLciERnlA9P8IPYOU5qqlupP/4+nOHscz/ChqoeaK5iwo7OaIVNEq43WIlrZLg3rl1gx6c5jZ9AYSPqJq/sQfjO/P+YteO18Bt4pIdx/ensVlRduuRbgrSo2r72CI8LicaNVixGEFRNlIGXUHts8BnhUb70fqZF9Ga4UOuRgAS+PuRjd/guq0c/oftsyhzXxKo8J0AC7E/eDd+HkiuVj6IVdZ4vVJeQUJGs9hQ+cjZtOwHrACSGnloE0AGb7aPsSzb9MZq4dVAIKElD+sI32tLYpvqJDIonsLBII/gGahmOGZhuS51zn2KTgfeHxWNuCxBL9IR+XTry1MutCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWcD8pjSMZDbeBThKlCrGF0+GLpyAyx4lzkRG2X1Xxg=;
 b=q5cqgBadchEgp+KpYnVyLsmhecasIvh+W9U+rgGbmwtwzEuu9hybEu0tbJEK476/Uj2FogJKFcwNgGlswM6mcLYsuCzfugVKF16614MGDW6xoDKYzgPX7cpokekZF2WeTD7yqQapQ0MJSMJbJv+pqTlc/j2QrkuwxYSZOUm/IHQ=
Received: from BYAPR02CA0013.namprd02.prod.outlook.com (2603:10b6:a02:ee::26)
 by BY5PR12MB4098.namprd12.prod.outlook.com (2603:10b6:a03:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:06:09 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:a02:ee:cafe::c3) by BYAPR02CA0013.outlook.office365.com
 (2603:10b6:a02:ee::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 05:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:06:09 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:05:58 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for Secure AVIC guests
Date: Tue, 23 Sep 2025 10:33:09 +0530
Message-ID: <20250923050317.205482-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|BY5PR12MB4098:EE_
X-MS-Office365-Filtering-Correlation-Id: cce6148d-7dec-4efa-ceba-08ddfa5ee896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y7FhqbQEL0riFgE6M25m5HAq3fuEH3CtRReVGMzCXJyxqBzZRHuyWWWM8qjp?=
 =?us-ascii?Q?H897iCCloQzKOmFHHH91DJUtTa933I7FJOrrUz/CYJemQQAYEbPZKOdCNAw+?=
 =?us-ascii?Q?75kKcclK32S6DHgjDAv16mgbZV5QFCXzrAG6XUv3jUaZ1qg0OMLEmcYsDKeM?=
 =?us-ascii?Q?vKyf7nYWWpNjeMO0t1/cY9BEnQ+tYeW98O8sSstkFB/KH9pV0wni/4b1htfb?=
 =?us-ascii?Q?F/dIRPhe1kv8l7P3GTEZy0B3AQB/x0ucE1IwIKYm8233GwqmV7Z7Gx1pUxUa?=
 =?us-ascii?Q?HL/72MKZG8+grpqMjYvNPO8PIBcR7P+lYD/CQAYUg9hyaTTJTHVH3GGxXcWL?=
 =?us-ascii?Q?FYTT1ZKbxVrB2uDlip17dXZtxL3lzz3kLuY7qJAa1jEFEEjqUxSf/XHoqby5?=
 =?us-ascii?Q?trpL0fF/Lcb66Ro9vI+o1mddAqUAy/T5Bity3SSLFfnvI4q2V6qj4lP0cyaW?=
 =?us-ascii?Q?i5QLx3+I+boUHo2iNASJXMqVwJcrwFfDFJOg4sRKVwe8DFETlG4ZPL5Fnb8n?=
 =?us-ascii?Q?gJ0zR/sIX6c8de03BbGKr+VHoBf9uM8Vv7MIAX0XT7jukERlx3oY4j1aGcCK?=
 =?us-ascii?Q?2/4+yiVrqU9KHhAs1vzKtlqpW7Uv//Hf4rr0vNAqrV54zFFby++ieyvCj3um?=
 =?us-ascii?Q?YYbKj1x6EN06UpVbzP5BPMKAYZMOKvgaK3tKDd2I/L5XVhxrhnK5W03sjFUj?=
 =?us-ascii?Q?x1Oz2ASoJKYdD/kyy3aS4vIMCGL7BBycD6uYE2wpnZYDdClpYB0h9vOjtmDk?=
 =?us-ascii?Q?/3sLy1Rse9h4HGj8J/e4G/7z9lI2zqyPVerhn4dxSXOaizj7zFqevX/tJ6ae?=
 =?us-ascii?Q?Y+fkj5Yuii9ISLdUS3R+3xa7LyCx3TnlPYVNIqqS4W6fuOlpkXTO3XXrg/B3?=
 =?us-ascii?Q?PvyXj4bOQdSfKtVTi4ROWciYFnPVP4IrVR1z8GXAz+Cjs8c9SM6T3pwyOqy2?=
 =?us-ascii?Q?T/bLYjywWORSjhB8Nff0RwvXwiy5kTBBFKLwBEKCll227wjYXB0dsigCYWwP?=
 =?us-ascii?Q?kLye7gLA8K7di+Ld1MtfV5UjaFnOefiVNQshqDZI5OLFlQU26Pu9qIcLXgh8?=
 =?us-ascii?Q?zmslqJF5tfe7qsUsLtEgiy+5xNpbhmsm3PeDGZAWuV/AXjWSlHCmQ10lFF+A?=
 =?us-ascii?Q?1oivZ3UM7aGmyqPxMnK2hWj6bD1X27oCdLlWq7Wau4BMAtvmpm/gKICK2HbY?=
 =?us-ascii?Q?YtcYHQcYnlmRR6Xqkbi7Yq/APMhJiKJIakzunLc8v0UQ9Rzv4kh59TqJA4Jc?=
 =?us-ascii?Q?AJnxihmVHTBAtFN42csS5dJT/hepBAAe/es+Dam9M18GW03fa5Q/ZxXTXocD?=
 =?us-ascii?Q?QTTtPiNorjgzN73JteLTfSLRnp1bivbdv/8X9cPTnswezP2qenyVQlkliyfb?=
 =?us-ascii?Q?luzW4nbGjI2UhDcFrJ4wQl7UqD3T2Lam2EUUSp1WiSLFRZNbe5g8PgzFRsp/?=
 =?us-ascii?Q?uJRbEZmdqH+UEtW+DRUbw8C2Y2L0E5kKZX6EBAHiTXhPUyLcwF8ZOTA/ikE8?=
 =?us-ascii?Q?IJDvYsMEAI5yGWJrBi6HHrqYxWWaXStuy7lQ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:06:09.1114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cce6148d-7dec-4efa-ceba-08ddfa5ee896
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4098

Exceptions cannot be explicitly injected from the hypervisor to
Secure AVIC enabled guests. So, KVM cannot inject exceptions into
a Secure AVIC guest. If KVM were to intercept an exception (e.g., #PF
or #GP), it would be unable to deliver it back to the guest, effectively
dropping the event and leading to guest misbehavior or hangs. So,
clear exception intercepts so that all exceptions are handled directly by
the guest without KVM intervention.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kvm/svm/sev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a64fcc7637c7..837ab55a3330 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4761,8 +4761,17 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	/* Can't intercept XSETBV, HV can't modify XCR0 directly */
 	svm_clr_intercept(svm, INTERCEPT_XSETBV);
 
-	if (sev_savic_active(vcpu->kvm))
+	if (sev_savic_active(vcpu->kvm)) {
 		svm_set_intercept_for_msr(vcpu, MSR_AMD64_SAVIC_CONTROL, MSR_TYPE_RW, false);
+
+		/* Clear all exception intercepts. */
+		clr_exception_intercept(svm, PF_VECTOR);
+		clr_exception_intercept(svm, UD_VECTOR);
+		clr_exception_intercept(svm, MC_VECTOR);
+		clr_exception_intercept(svm, AC_VECTOR);
+		clr_exception_intercept(svm, DB_VECTOR);
+		clr_exception_intercept(svm, GP_VECTOR);
+	}
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
-- 
2.34.1


