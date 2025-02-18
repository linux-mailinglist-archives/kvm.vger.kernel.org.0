Return-Path: <kvm+bounces-38410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5767AA396E6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:21:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B4871894F95
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BED230D11;
	Tue, 18 Feb 2025 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MpsHC0ku"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A5122FE19
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870423; cv=fail; b=bYX2vxsyW6QCWEmEDfhOgSbyJ8CACwwKOE1pMg8rzA4kESHMBhDqEeTwHU0cw+W0wipTCc+Gfz+k3GDePrLjviyyZkS7Dg3qDr+/AVJT8qeCb1KeJ/+PO273lr0C3vsIfUu0IvjM+FElW2BC5gT8YAb02CIKUnNXNRWBkYnsF10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870423; c=relaxed/simple;
	bh=HQIGlAVrs+ezsD84YCkCtS+mRsm0+BOFkJElovcQih4=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FfsQFp5zAU4Hrj4o0800QfV/R8oewmwXlsjGIlMvVO/aBNzEg0YBEa8T8NgHa+JDApD7EntZQIrf77US3lITYyAOepqeHKCcwxfCn/L0cq7J+1zooWPrDdGKnRCAcHFcsaOD6pTxHCcp9GQWN746DT7Eiskf9nUINMFOAXuUUWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MpsHC0ku; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cl9Q/k4xlYZW0YV+PhLcYHFy25jGn18qY/uk8xKviJziJRr8SOjPR6PN0DX39fyWRMs9KO2DaPqU9Ow0vy2tk342S1hFZ+k9C/mVkLTnnsjb5vBB/e8nf2dknvgTEpT+UWIEq35JwUQgAiHDxROjpwrptHJH90oWJ6amGbABz3RNbExQwAzqezxUfKTFU5sNFKXAM1m6on7q8xmTvdX/VMYnMVTpycvoOYH1CrPjHrMAr6CG9zHAuVGqjsXq25EdR/53hwtVlB1qlmDnAsjmyGeetyN8Sd5S6QfjM0AjwRQV2Oi+dQlRrqjC6pw0zXHSznGOw8Vdx9P1atz6jFubUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzhtBmcgZxsn+D5d1axEdsT2LRX1bthrLYK5OqYmDKM=;
 b=ILDRByuN01dZ0KUl5lFU6Gmpm2gzQ3SSWYBNsRZgQiK/MA9du3F7IjSk/O7MPXgod5FO4xGEbPWvYqxpzaHtCpuY+HNn5ZIJ8jS0Z+1HBkoBST0vc/hNnHsorHnlRSZXMrIYIaCoqyHecOE2JBbVf804NTwMehL4oUlbGFMv3YChp8PkBCfY43WNMrU8e/ZGIbQ2CT8qxOsghjZjBkDiapZ4uRC/CcuHqJjkYlCd/ZiMrdeF1SDLQFXsG4357g71q9FWReIlpXUVZUUepUFi5/pjURit+2L3zg3/dlF6CrQMXPSKjrunHKC1Zi82ZQ3HYpswjB4uMGil+WQq4Cgrcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzhtBmcgZxsn+D5d1axEdsT2LRX1bthrLYK5OqYmDKM=;
 b=MpsHC0kuvII62AkgcUZJnrPCJyADyVZlR0gyW0ZPeoFeoFvCgtn7Jm+S+taIMksCEhFW5oEAGO58uS4xzzwogbNEP8Vy2yX1RTR0rELOXkp0XTbPyEf2lFZ0UWr4v9bOTGOewstyETQU3Jdm0gWAoPLdVy7vR12Rd3fYExsJmlE=
Received: from PH0PR07CA0064.namprd07.prod.outlook.com (2603:10b6:510:f::9) by
 DM4PR12MB5940.namprd12.prod.outlook.com (2603:10b6:8:6b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Tue, 18 Feb 2025 09:20:18 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:510:f:cafe::f8) by PH0PR07CA0064.outlook.office365.com
 (2603:10b6:510:f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.19 via Frontend Transport; Tue,
 18 Feb 2025 09:20:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Tue, 18 Feb 2025 09:20:18 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 18 Feb
 2025 03:20:14 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <cd36710b-957e-bfe9-7904-e1041f00d98a@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
 <20250217102237.16434-5-nikunj@amd.com>
 <cd36710b-957e-bfe9-7904-e1041f00d98a@amd.com>
Date: Tue, 18 Feb 2025 09:20:12 +0000
Message-ID: <85bjuzip83.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|DM4PR12MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c6b70f3-0568-4f03-cea4-08dd4ffd7623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sxAiKPNu2yecRzFTt60tryTENH7Qt5XuRwwZRZHKFSzpBROVbz4xvUiAkYZO?=
 =?us-ascii?Q?oHIIKPJoKDMcRrcw2CiaIGkZtira/re3arvJE+uEqfZDp4LxqDMmAUjgO6jc?=
 =?us-ascii?Q?kc25W+Yz1ZdXLyUFyF8QDEaNpc80Z2NSl5FxpnBQ+yRVDtBmD5OsWZjljSa0?=
 =?us-ascii?Q?F2cZ4q/47gTKgfPorjPuxPjzokKdLxQrtjdwCw1TAvdyrszkWvdMyOU1M8xj?=
 =?us-ascii?Q?bxvwhbvXQD7hChjtnhcgDTkMPcmfeGL1xye3zHafQi5hhR0WwM9ongDgMrI5?=
 =?us-ascii?Q?AhK4+GckW9EqEynfaleMvxb8/SjJ8ZSOzzLU9noi/p7uHvBKhfxWlYhicWhw?=
 =?us-ascii?Q?/dCJuj4s2RC0u5NeblHATtLueWfDI9FdtL+5hHhLDZ5SC2KO5O46sxGl+b4r?=
 =?us-ascii?Q?ddao+O0uNIV7lxmTQfkgaU5HwmCenq0sMN+BSvLgGR3TmuG0Kblp8TLo/b68?=
 =?us-ascii?Q?mKjuUrB2+p1+VW6qfsQCv48MthVx+MUoFaYpYswKeKZn6jPb2gSy6nkFCcLj?=
 =?us-ascii?Q?Uj5OnjfySoFKayl1QGSsDUgPScPcUx9RFF4ZgDaxMx9Lgba9ygh5Vh6qpmgG?=
 =?us-ascii?Q?3z7dcteFmSAcLh54Z/bOaOgJJbeoF+OM/WV8veRpTdJPe0KYPrN3aVjRjh9F?=
 =?us-ascii?Q?fMLjVz3otTa4sz25b0s5D+nXHldNQSmuXi9n8kZKQ943LV+80bcSzBdXevuf?=
 =?us-ascii?Q?L+Yw5bqNHpW4ICCUXLYe4EEK/AgGul3TIqfYekb9/raY+2mE3GARyNJJP4jG?=
 =?us-ascii?Q?htNmfREzfV+7lCdC/0DOwd8oRb4TY1Bm67Xr/AdPhbMUEhtK592m5Xb2kBV3?=
 =?us-ascii?Q?lSYUsxpnbSibR54uy31zvrXF8v6dqusbJmgr/wK58rP/lq7sJwSjdTJMph9A?=
 =?us-ascii?Q?mxmHgnH/5HW4CiPQ50YXuiGJOVYCl49EqVirg6uXOeV7H9eatKgJXAsAqUVs?=
 =?us-ascii?Q?aDJP4Wf8DZyzqE0uxSmHo7F/MOZK7o9QvSredQn8N8KT5lxNZ+u4AnLRC9a/?=
 =?us-ascii?Q?EGG0OXh3oOxDQrYbO9LjykMbyGCxc/J4FYaTN7auWClM2NLJCnYwnUqO/w2M?=
 =?us-ascii?Q?d+8MUyxTZ+RO2/xPfc0GGtmGXO7Zfr3a26lko0tZDhMlcS40vXzSJkxJV1Y9?=
 =?us-ascii?Q?sWI7oM9V0jNF9678k5IHeTsXWZc7FmBkgoB9FiJeSJZ0GIR2jRqd8D8o+tZH?=
 =?us-ascii?Q?G+f5yk+ETJNHoAdjl9Itv95L+u0ygf8oa805IVaTJcA4tVvrCXYHaRZuefTK?=
 =?us-ascii?Q?4qpoRJG++FA2i5oNTRmlJYIZJgd4hAQtaBOz4tusIpm3Xra68D7y5e53Sudg?=
 =?us-ascii?Q?4a+mOpoXNnf+CCEdUDC/Yp5gput4CECYA24s8ZQeVCC4nG5WfTYVvqXz4P1f?=
 =?us-ascii?Q?lrzw0qpr7FP8v4V45g8nMnZE8ziX4t2WYGKOUSk3DRZFTd52259JQoyZ5W/1?=
 =?us-ascii?Q?AMMY4grfCWhACg3LuQoyFhyEVhsas6h6UW3yiJCXE2q2JQQO38xhtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:20:18.2138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c6b70f3-0568-4f03-cea4-08dd4ffd7623
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5940

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/17/25 04:22, Nikunj A Dadhania wrote:

>> @@ -3161,6 +3161,20 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  
>>  		svm->tsc_aux = data;
>>  		break;
>> +	case MSR_IA32_TSC:
>> +		/*
>> +		 * If Secure TSC is enabled, do not emulate TSC write as TSC calculation
>> +		 * ignores the TSC_OFFSET and TSC_SCALE control fields, record the error
>> +		 * and return a #GP. Allow the TSC to be initialized until the guest state
>> +		 * is protected to prevent unexpected VMM errors.
>> +		 */
>> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
>
> I'm not sure if it matters, but do we need to differentiate between
> guest and host write in this situation at all in regards to the message
> or return code?
>

Yes, I think we can have something like the below:

+	case MSR_IA32_TSC:
+		/*
+		 * For Secure TSC enabled VM, do not emulate TSC write as the
+		 * TSC calculation ignores the TSC_OFFSET and TSC_SCALE control
+		 * fields.
+		 *
+		 * Guest writes: Record the error and return a #GP.
+		 * Host writes are ignored.
+		 */
+		if (snp_secure_tsc_enabled(vcpu->kvm)) {
+			if (!msr->host_initiated) {
+				vcpu_unimpl(vcpu, "unimplemented IA32_TSC for Secure TSC\n");
+				return 1;
+			} else
+				return 0;
+		}
+
+		ret = kvm_set_msr_common(vcpu, msr);
+		break;

>> +			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");
>
> s/secure tsc/Secure TSC/ ?
>

Ack,

Thanks
Nikunj

