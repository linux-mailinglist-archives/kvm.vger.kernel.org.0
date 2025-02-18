Return-Path: <kvm+bounces-38401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B678A39489
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BD32188D059
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45BA22AE5D;
	Tue, 18 Feb 2025 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Adfvx59e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92722ACF7
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866216; cv=fail; b=TxDnLNoO8CB/P/U/Nwj9X5CYac4e5lrvu05PxQrNT1Nr7gfEBSxzZdU00sELUjNSqEP2E7YFqykqrq7dQSTKLZcjqfC3GhDTbw5GWkL6iT0uHbi425iZND8ZGFhT+lZFkwscVL7PmSJGGyBI+sgBMHmXqamZamtrAdcIqXntG1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866216; c=relaxed/simple;
	bh=+FnxOdgNlWAIIPHHML/i/h+hYErQoVbNqPhqMDfhP3Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YahImtM4LVkkZnaOlUEINic9rz7DgiAZHWrfUenAmhzhDWku+j4oCjJKWsqn+Jtks9MzLNjj3N32/7qQG0DcwkXZQysmKzBMHmfFFRBYgg/i1jS5cFrWLZ7RJg/hnD7eENoHmfddZabK+dHc/OVZWrEHy7Tzaq37EYV51rRpZ5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Adfvx59e; arc=fail smtp.client-ip=40.107.94.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clyL8W9nyhE2GGfmaGK0Qxg/Lj3G8e5Q752Y6V0Q3reWF3aQ0OiP0IbcDR0v1ux7YX2O+IejmtWVnUzojoZgN+SrwgjdJStVu3uxB5zLNsbsTW9QTCtEvcJsakoLk2+0yGB6fiRf/Ld0eZGMM8YpYqSmfEBwe2tDMCzj4RMHA+tY18GkuKHrwHFkaXY7LjHg5s3oBPzQu+W/o13B2OHc8L6bBVCpixQOC7hd88puI7ej0krr4qe0pZ8oEn2ZkJUDZyyMyzfnKQjT9J2Fsc03WMH0yez+U6X+PzNW4xkNEtMaN5KqG0AzTjsihybhyaeb2MJkq3wdbL6xyVywFiENGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZBP9wlm7AoA85BSesrwYisDiPtVClVi1TXfdsZUHxQ=;
 b=a1tBBhU6QyJKE/T3p4V46qQ/ZReUvqRkp/w9YOg+YkMTQf5HvpkOhKF6cfC4Pzfg/L4uG9KbIFNpIkkYm0dTJUW8dgA+ZbKe08AnjCmlvVp+H0iTfLWh47kpp32Yqs6Bc7v7MhNLHJoaO+XKLRxqhHfVGOi6YOohd25JMuLVEK7ylYKny2JK07/Sej+7RXwH+mLpVrwV81fcZIzM7y7Iwmkmeo/hZiVtYe+vRgZxIVEVwxH8s2klvX1/1thGKGSBiw75QvfGy0KLZgct+7qdBvZbyAHCOXgPZbJFsgo9T/h5SUABIXDksVHp2PbYMejdPF4V76D1RmaRLKSHY4F6zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZBP9wlm7AoA85BSesrwYisDiPtVClVi1TXfdsZUHxQ=;
 b=Adfvx59eYSUdoBkSHw2iW+AvisffWzdxIMKgPHCH0rzUQdT7ox43e6b9RtD8ygF4lY4fLbkA/K+C2UYASEo6+gbPQ5B9UrSkjRbVi4NsprFFEwG2MPdaLvr2nd0YU5Q/k7gmGQ99BJtwUiroRJF4WOXdAT/F/r/f0oG71IN2DBA=
Received: from SJ0PR03CA0253.namprd03.prod.outlook.com (2603:10b6:a03:3a0::18)
 by CH2PR12MB4055.namprd12.prod.outlook.com (2603:10b6:610:78::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 08:10:12 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:3a0:cafe::1a) by SJ0PR03CA0253.outlook.office365.com
 (2603:10b6:a03:3a0::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.16 via Frontend Transport; Tue,
 18 Feb 2025 08:10:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Tue, 18 Feb 2025 08:10:12 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Feb
 2025 02:10:09 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 5/5] KVM: SVM: Enable Secure TSC for SNP guests
In-Reply-To: <fcd943d2-9c6e-1662-6b6e-37e5235fe57f@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-6-nikunj@amd.com>
 <fcd943d2-9c6e-1662-6b6e-37e5235fe57f@amd.com>
Date: Tue, 18 Feb 2025 08:10:06 +0000
Message-ID: <85eczvisgx.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|CH2PR12MB4055:EE_
X-MS-Office365-Filtering-Correlation-Id: e71d6c02-75a5-4768-d4a6-08dd4ff3ab0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VS5gBWds/Y3QHKop3FlfmqWzGcYqBTVFjUXf5hunFeIOkkLEQcwsbQBkq+45?=
 =?us-ascii?Q?hAVUyU5Pc+rgQF6khOMLMn2eCn2hCUbSQaiorUUyuTyupanXvcDoqReV6vsW?=
 =?us-ascii?Q?0Y1Gzg2UZWi8lwl/rcpF7iWd+sLxSHX268pClifFQdzZLjfnUt5K6hC7kYG8?=
 =?us-ascii?Q?Psx7rT0s6KAXaU5RyzeIXPekGy7i3Uyyv3gO8PLH2ALvfIxlILhlwghdpzNi?=
 =?us-ascii?Q?0kHMsGNRk8xa4IaAhDcXB3EsqHuQKkcjrR5oa8DEi7vECa1j0Wb5LjN5Fgiw?=
 =?us-ascii?Q?CUAm5+dOVxf//jtz9IXc+fIRfs5rOphzt3iW0I8ofVaewuz8B4T5Re9qaQ1Q?=
 =?us-ascii?Q?N4IumQC380YditxZE6HjlG4nmJJDM+hL+Mtw3mbnZvq2uEW1r8MsdXptNWUS?=
 =?us-ascii?Q?ozNnI0lwpACVgzQjmF0Owt9QYGpLrbo+gzVQvloPWDcUy3Xhwoqud4Xi/ype?=
 =?us-ascii?Q?EhXf7rzuEDZGEjCC0NAUGpKRyx2sc6uKLbRwGwq96T0u1cOPzQBxSj0fnn2h?=
 =?us-ascii?Q?0drFP02t9KpMGcYIuVN3rz9uit7tMkGMpk2rzek0FW9XymJgnSNnlj2dibXj?=
 =?us-ascii?Q?ePZaOADenhSesXFuArC1GcJk65kUYe4MveRzSvJZN43jZHJBY+L0FZdwkFsZ?=
 =?us-ascii?Q?ZQVFJsIXb0X+arsS1efBnyI9rzZMk9YIr0AjleI2mB34tD2e4UZHgYwa/5LP?=
 =?us-ascii?Q?MZauREeE2OqYXY71/6dDhM7Zxg4/QL6uBjDklZmgUskZwZi1eVWfEFzC9ekX?=
 =?us-ascii?Q?vE5HE5wVBkejrMFQiM0EsbFeE0ID+am8fPe3zxxrGWpxd8U4/A3DBy7JBjkn?=
 =?us-ascii?Q?8GMLtv8jQNbBSg/g9rdBmGPrnjZq5+4dvLZRVytYNLYTvcLHlqjAxGznFf77?=
 =?us-ascii?Q?jlKC/o0orFnNippIhSJEtiq0uzDGVi8Cwsimr4glfexwbkbMSdcf/mrc/gOV?=
 =?us-ascii?Q?vnCbJ0z7hgtXVuinzQ5BVVhFv7ZzUEvcO4VsM5rNNyWa+yA4lPovfObanKfo?=
 =?us-ascii?Q?HdbqXxPyJgrB2ABi6P2CM/e/iGf+vp+IGTPeeJDZgllld3oGUtjBWauECjXW?=
 =?us-ascii?Q?DOqS3iFFM97ZSPaDeMpqZ3ExqWPb59dwou6DtmlPmfnYrCq9ppTO/enOHIQY?=
 =?us-ascii?Q?Shr/GXnK4JGVDFoFu+JZvXEgjgtfkmX7ovc0gwOiaepAYb8QyUlx+WJjmyAK?=
 =?us-ascii?Q?YUGX8+MhwawnCGAfNcJ+vXACEmCdOPH6vYVNvTQwgPjM4IHyRaQtyukBwEgm?=
 =?us-ascii?Q?k8EYALzhBxz/vEDOfr9uqKFdEeh21w8JhoZ7WKJGeAptVLqC3lbFdYAN72ir?=
 =?us-ascii?Q?yiNgOsujoOKDkuR28trOv2JvYS0crA9/iG8tZkwBXsZj5bzcPM2nKYj4BRQ/?=
 =?us-ascii?Q?6aFhkkZyPDhN5mnmsSksG3Y791dx8lQlZWEuroJVIcE9LZjBSf63BP0ZOd9c?=
 =?us-ascii?Q?IXQg01/nDxIcqAOF4lZ8YU/7grkZJDWY2/gHr7TvJCd3s+Upe43I8EYLA+x9?=
 =?us-ascii?Q?lHekltv0xDuJ5lI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 08:10:12.0620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e71d6c02-75a5-4768-d4a6-08dd4ff3ab0c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4055

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/17/25 04:22, Nikunj A Dadhania wrote:
>> From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

>>  	if (rc) {
>> @@ -2929,6 +2943,9 @@ void __init sev_set_cpu_caps(void)
>>  	if (sev_snp_enabled) {
>>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
>>  		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
>> +
>> +		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>> +			kvm_cpu_cap_set(X86_FEATURE_SNP_SECURE_TSC);
>
> kvm_cpu_cap_check_and_set()

Sure, I have updated the patch.

Regards
Nikunj

