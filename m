Return-Path: <kvm+bounces-25326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8701F9639F8
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 07:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40AC828568A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 05:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65FD11547D1;
	Thu, 29 Aug 2024 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BmUknXh7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C83148FF2
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724909903; cv=fail; b=IV0M/KX/luW6eJzdMuvp9nSWELPp0Qro+IsAumZKFMZqw8kY1d4WSQoBr8LehZheBVxS3fWym9NT5cUQbR9aiafaBHj6SjUbfwC491L6HN6/PkrTHFvoYYWYaBaS/NPjs9LUVz6rlNvC5krr694GRXeKNJHBz7MtAro97AqmrkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724909903; c=relaxed/simple;
	bh=8cU6tUztytdv7oVW71eX0DEixx8hB+fomIzmuvjhrIY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6uEp167NwTaR0AXFK7VBaA7488W7Jy4nWuKZuo0baEaebq4NH9bY+NGYitFkKI//46B36aVlc7+fQ6oqkjXY5zjL5G4XEefuYSxpTjQXJtoHvhyNu7LwQT4FHo3Rg5mMNqmiwr+CY8NP8Sxk4VBHIwhGolDSCETAFiVyJAC1nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BmUknXh7; arc=fail smtp.client-ip=40.107.96.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjQvJhd3dLIQQRJrQvUY3gb0Ot7V2o13dghEaNZ/WsGtlms+x8YlMnwdrtvTCSGWSFNLqUtT7RiV/g/lTkmf7v5h8fpPfC9qEKQ68i9Pp09iX/KOFXK+9fNt8165/zVUoV2mkwsUd2YgdQGJ16k2QKNY+Z3arJ70kCWX8LXdAqKJbryEuqyKhglPlRuQNUaltRmqY9iuEJF20tJbN/D04iqXb5zQihZVAcAd8b3s1xaNcXGsc6f2qmylN6tFZDrJm0Mwb/wKQ/sBR+TC7w5Mszj3LzpUAbScxXSnQrCYia6q9+nRjv6cPnACUCK4MrrihN40dDd4wheHUGYM+JwcaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vjy5FDPqJkWODdJSxNnYbQRBeSa24iYZQcA17jH0eA8=;
 b=R9W70C4urrrul8qdM9IgLiYwYgTFHykCGuk+EELiUfbC5xmqC8O3pMcAec3fF2Z8PD0KXypwKk88+pSgZSsWl8yX2exlStPapJDtROV8aloJzEpYJyILWnaHblH7RhGwZHrJV/pHvyPOPAp7aEOh/FTW3nFXazQc2i7rCyqSia+1Pi7VCdirIUOnCrvYLeAfzWPndrWjbG7y5zgCNH/kdP83RdEiCzZQ9IxVBSK6VGZHOfHLapomBTMzTh5JYK1wD1z/LNTolfA0yYeMRMBvpg14kWBBvNArTs2ZnxglEejNBcxYe66PpZABtz7ENLkYGiygnGeHZ7d3Go8LSmPfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vjy5FDPqJkWODdJSxNnYbQRBeSa24iYZQcA17jH0eA8=;
 b=BmUknXh7zFc2fekAY9Q5C8X+zAY29DtP3SBEgduQvTbFWZVT0HhwqYfNfdc26FGN2pE8Y1bbzTsENCntALqOtsP26KOXqzWPuuoJ7Lz5D19r83uV1EVeLqQUWb7quZ9xBbg7iYNeroBwulubTeOsxZU6Zhlo0y6NUAXY6IHNPW0=
Received: from SN6PR01CA0018.prod.exchangelabs.com (2603:10b6:805:b6::31) by
 BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 29 Aug
 2024 05:38:18 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:805:b6:cafe::de) by SN6PR01CA0018.outlook.office365.com
 (2603:10b6:805:b6::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27 via Frontend
 Transport; Thu, 29 Aug 2024 05:38:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 05:38:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 Aug
 2024 00:38:13 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>
Subject: [RFC PATCH 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled
Date: Thu, 29 Aug 2024 11:07:47 +0530
Message-ID: <20240829053748.8283-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240829053748.8283-1-nikunj@amd.com>
References: <20240829053748.8283-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|BY5PR12MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: 5153be79-b74b-4fbd-22e9-08dcc7ecc977
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4/xst17xSqXxTLfQt2oeE3ytPgcYRVFhZ7z2zGlwzj7h4SVlQzFHJj9KgExG?=
 =?us-ascii?Q?clP4Zk+JeK4lncsMjo9if/qW2hePHVnufPUD2tlzXaX/A8/e40tJAH84WrxM?=
 =?us-ascii?Q?aP/Yg/a91I+HpR62qnOLYioCVttHbaLC47Ah6dvzA+HQ2Ho6LuhNfjFglJGC?=
 =?us-ascii?Q?CipeCvjTT8A9yezGX2T7vKNVbM+uI9wa8y7Xdb2Ikxb7Z4584W8OPmxWufLZ?=
 =?us-ascii?Q?QUsgq6VVF4Kt2VrB9NLReNSE8JlGosPrPM8RHZfJRSSCgbiMTdy/nVMeO8h5?=
 =?us-ascii?Q?9QWD3ocRzvDFuXNuZARMNv0lDy0j+zPo568Rk0VqPgYDplb68k2F7DL1jC3e?=
 =?us-ascii?Q?6lZppv39GvBGwOXdU1Rj259Ak7nTMzUqrqk6fzDk/jqOryQHg6ADvk7+SczU?=
 =?us-ascii?Q?MASAvMyc8CrLY2vQgRiQRnPQ1IsvkXKWQUgLY5rzTTZ0dohO0o2DOuUHUkn4?=
 =?us-ascii?Q?EUhJUh/147gZCsVUjq5km1XUh/rEb1Cay21ditJa+P+yeHe2TC4lEb6dIY9c?=
 =?us-ascii?Q?X3LDAVrrLf7Y9XaIVsK5lhetzMYBUOX6fQ32Cq/5uUKAfZcQtdRray9thmbN?=
 =?us-ascii?Q?RoXyT9c/yHHpoXNU7f92Rw+cOoymt8VrnZrLo8d1ce/OUKAtNQwo2o0/wVYA?=
 =?us-ascii?Q?GKntljircMGjoQNI4LQ7Sx4KDFLt8DyQEd9YK1hz1lXQy5HA218yDPYMFBae?=
 =?us-ascii?Q?VeIIX0gu0ASxr4j1PUpdx9t54BtQbW9jvxIX1EWvp8akcB0gXN2DdrsRH969?=
 =?us-ascii?Q?6at4AAtiPBh+G9DMSR5qiQ8aA7kF+NVuTR6gYQgFcghTfPJ/XV7W3QLRgQ0O?=
 =?us-ascii?Q?K5lMDu7inFirRQ5AooqCmuyV4lYW7UM4NDT5To/HR960smFUzI43zfRocQcV?=
 =?us-ascii?Q?uIPnP19z4a95pvONnQsBS+4NQ/CYA5X6+RkD2ltSDbYUPXjgXEFIOAded9Ig?=
 =?us-ascii?Q?JcNYuWLWfIFp8hskGdMX6OUZ5et7iphMlrxfedDksTj2JbDx6LzL9SZmq7oM?=
 =?us-ascii?Q?UUhLY1yOHP9/mt0gfOmh1X/QbkSuwJyVvs/WLBopomCgWLkoUwQjow2VFNNg?=
 =?us-ascii?Q?4AzcIFcRrBcuS00QkklPD7e2jocOUlXRjPjv2KBqdrWlodTG2k8pVRXnMGIo?=
 =?us-ascii?Q?UqcC85e49cTI3uS+SjPhQNh1wE8FVsqndvHQqhb4Jw/1+4elpV90kgKn8L5p?=
 =?us-ascii?Q?+dF5xz0+Z0Y9hKpE5euJO5Bs3rb1ZphcJ9p6ApO8v8CZL0Qlop9maIy3qXim?=
 =?us-ascii?Q?nMVhkoDh/NDbIZrAv2Okkk9QOZS5enwGTp+HeWwA/8tucyAA1qrnPq0Hrqql?=
 =?us-ascii?Q?rFBktqFZEQ6HTbFf/0+mYRr/GISYLw9eh/LwBeuqTWzeAPCYj68jZKFfNDax?=
 =?us-ascii?Q?7c+pSuDOYFHcP1fFNKkTXkXqwXfCBTztYXzEdvlW0dz4swGxZ3Jvti+Vrr/0?=
 =?us-ascii?Q?WH1Cu/483CM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 05:38:18.3973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5153be79-b74b-4fbd-22e9-08dcc7ecc977
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066

For a Secure TSC enabled SNP guest, writes to MSR_IA32_TSC is not expected.
Log the error and return #GP.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bf86410b2f43..f9b2c1956a60 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3151,6 +3151,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_aux = data;
 		break;
+	case MSR_IA32_TSC:
+		/*
+		 * If Secure TSC is enabled, KVM doesn't expect to receive
+		 * a VMEXIT for a TSC write, record the error and return a
+		 * #GP
+		 */
+		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
+			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");
+			return 1;
+		}
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!lbrv) {
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
-- 
2.34.1


