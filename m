Return-Path: <kvm+bounces-37824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DBAA305B1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:25:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 923FF1884A03
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CF71F03C5;
	Tue, 11 Feb 2025 08:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iO8nYdkb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B8C1EF0A1
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739262292; cv=fail; b=edD58AKeeQiJQnSree6LjFs3c5FaKTqbTxOvT8F0w5hF+BtNvO5UFz+NjopDnm8Wnm0LVsOoA9MfKd9yNJYaY0fa8mNljpUl60kxI8qZS18zJFWcm0i2qE7GBNzJx54MyoSdq8HU++DooI/zlgeP5qFPXly1o3e9oBT57+xTdzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739262292; c=relaxed/simple;
	bh=yIsip7f352L9lHt1mos/+R7dtDaU0g7zMu5vHXv3ofk=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=PqDqKnNiKF9aNRPEARQzmkQlyCR694ZFmMkwngaTZx3yB8udvUnnpPykiSfeauRhINNx5wUb/RjFiEAACNHoRHaJ8akjl9vRyK1YPTB+ekICsljaXRxlF55HCL5HnwPqbacOjPotLiwMmrGxQtha4WjgPSqddU3OJq7VAPtd5mI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iO8nYdkb; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7QEEo6GioiyxjnSE7zBgHTecWDNBdIIgNxi71STprPa6TQzUQIr9x3dB06bmVONzPhpxk6D7pQwy22gkg950DCPkdNihU6Uu7CHjddUITSod2tWgmqtvmjjZaoMojNYue3pTFd7tJSfHfEZUcF2D7yW/+CvHmNut6Q0hL6sGoaTRoGTASBaoJF1e6L3pepQOq4DLGjjR3/8mSW10PYEkCZjNP2OkMN/WWrzTjyO1+pkK8SsRek8n078SuQxu/edn3C3AoaDARXAve0zIdeK3HidizV2N7VqIWdwNYeapIIfTm739Vev154eboQpvsjj5KZz3ct9232xgxlXlcFusQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYF7zI5GwNGH5wG1qPlBJOAu5J++CcbWnD7P4xqyYCo=;
 b=iluWfw3ho313ZuJPyiP33UV89Z6AeQzs69pabj9lCnFaEQgTDW4EtX9yvxVO9+5SelKANJhlRlJ+BSKnJVgDvwkbVLar9k1ssqe8PADmQj+Pq+W+9Jo77Ktu52ImAoEyw8Gq0MZRma5iWiTHv909dcFmJtSV8LQPUYnc7xR8FCJPELoJ4QFxLrDa35YKxQZY01/LgropMT2kHhDPjtoiPFcDZRGZDS2UP5l5ASaII3nu78z2T4PT51grBcaFELzjXWLHnhmaetlUXyXpECivnumNnHHERrO3f3oVQegFLJM1ItRhPwZ76JsUqpO/SK0HC68ZUdLVeGnP4CVAGF8uaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYF7zI5GwNGH5wG1qPlBJOAu5J++CcbWnD7P4xqyYCo=;
 b=iO8nYdkbQJ2E4YKbsGQHHrnJM2RzanP2oX8ZevydRs392OwQVwS9+75IjQMM8KB/XX9dc1z7yMaGfQpfdY6kMq6Gxgw7t5M3elEs+fT33Brish5mh6JyeLDJ7yRa3Dy4uZDDvkqUivN6Q9A+tZuHfT93T5A9fjM4Kv54qc75Ccc=
Received: from BYAPR01CA0013.prod.exchangelabs.com (2603:10b6:a02:80::26) by
 PH7PR12MB6859.namprd12.prod.outlook.com (2603:10b6:510:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Tue, 11 Feb
 2025 08:24:47 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::8a) by BYAPR01CA0013.outlook.office365.com
 (2603:10b6:a02:80::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 08:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 08:24:46 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 11 Feb
 2025 02:24:42 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <santosh.shukla@amd.com>, <bp@alien8.de>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com>
Date: Tue, 11 Feb 2025 08:24:35 +0000
Message-ID: <85ed04ubwc.fsf@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|PH7PR12MB6859:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e07cc13-ef4a-4354-4004-08dd4a758b3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CzLOOUUzNRzfjda4+D6fmb2K+VuW5yaZSDyMquJAGmygq8GPwG2TcCKmrOrg?=
 =?us-ascii?Q?kwvkL4+iISMBt6b0dOdUPAujPqKiMrQBHoWgNJPvjQWbU2urH/WqqN8R3c1q?=
 =?us-ascii?Q?E1HbXNcqYayT0L+Ar085oWQCtOCNXWxjkqUvNSaQ/Erziti2yFmAFU66XxjW?=
 =?us-ascii?Q?OCARXXpLL+jFADrpaAFZhDOs9+vCQyTAq3AiVMM2zLNkOX9tvn6pA2Aj576l?=
 =?us-ascii?Q?eNI6MB6u0hAQcPEH9tQc4v9oIqFzBkmUd8SqTbtTYx6tBX0cntLVKYMj7XuO?=
 =?us-ascii?Q?36+p/AwGXDocbeF/MOqsHEuqkt0RaKo6aUaj5IWnsl4d9zXtN9MlWSCngBeH?=
 =?us-ascii?Q?AnOzZbMzXNmmbgsRpWEcYFfc+GWJzDvfACopdQ7yF9IYNhKK5gpSn0nZoPfC?=
 =?us-ascii?Q?ldjkTwDW4BWGdqYUUgpiWp9byMfRg0ckRhxIjjsV/drb/PfHsti/vej55SJI?=
 =?us-ascii?Q?BYQNhNPBkNcUCjm0oet5yY2CMGOuuByZVnQv3vFt4WyP9hwKNTIKQZHW9XgQ?=
 =?us-ascii?Q?FW9deZfbz0cG7NgFOPIxtPwJq/qxLcZ91c7zRyWyAdCzuqTK2kT+mf0QBUys?=
 =?us-ascii?Q?QzzJsANW+y9pzD/YhkpMdUUu4/l/+uwoYtmLNqv1mXFYRf3xQZIa110/YIIF?=
 =?us-ascii?Q?lxnGEPgLiLEcr9oitSmIgOUZKdRUCF6fIcdT8LmSTbsuLF02z85Atv0+R+1g?=
 =?us-ascii?Q?wgdyccTY/jBRZCs4InNVOHczO2jm/yI7FrgX2hPwF0XbTb47pF2QCtrEu5Fk?=
 =?us-ascii?Q?HWI6UhTNcOG6V5328PYGdEqH15XLkb4aNztWgglQ7vkAftc2Ua10r5a9zFid?=
 =?us-ascii?Q?L36WRI1VoJcOhFv/T1dH1UhPeSPYnW0sVZISOXRfSnYbodeZyZHihVCte/ZR?=
 =?us-ascii?Q?lw1W/3qtlo4HlrUdGoSJph+n+ti+VsHJIx4h1oagQ/CUI1QKShEtWnHJpwG5?=
 =?us-ascii?Q?1cQr5Ir2ySWVyEt+CmW47fvVJ7YcQRmp0/UrqXExrngVOZnxmMCSwTX++sm6?=
 =?us-ascii?Q?Dc2/pxXoeGYwTrZXOB5dd/pQVYrGcCBL/ULtDQ5jHsNQm3rPf1Y/XBAZY/WJ?=
 =?us-ascii?Q?QbBJyQ/CKjycd77zU71zV/MU+JkA/iKnww4sfSN9d2aoxXDKwuhv+sYQ/e7M?=
 =?us-ascii?Q?1aVw3QdP/z/cY4S0dfubI7FqK04J9TAP2SK912DLsgNPpgYcYhbALXWKFLGt?=
 =?us-ascii?Q?NbSeYtkeuivJkPiA/plYipw4PZnz2uuFxEhcwGgLU45iDF5Y7L2XAmnTztnO?=
 =?us-ascii?Q?okqEB61QEYArFWRLCTIqn6VhSOo4bKmWHTbagJjubJm+Yi/x2x3NsAzA+0f+?=
 =?us-ascii?Q?tu/a+1aqke57PCfpn5flL2rNgmV8GSXtUCh5wEY2b382lvA2TaDoJe+MoHsv?=
 =?us-ascii?Q?vq29lc23H77epqHD8ZC/ECxqCueHi6A8E1fuaZnck+7/UxoWMSb9mbEt07Op?=
 =?us-ascii?Q?srFwLPuAvARSHsECQHeSWGrP/tdcSsLWYlX0C+E4L3h1diCBEAGQ2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 08:24:46.2460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e07cc13-ef4a-4354-4004-08dd4a758b3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6859

Tom Lendacky <thomas.lendacky@amd.com> writes:

> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
>> writes are not expected. Log the error and return #GP to the guest.
>
> Re-word this to make it a bit clearer about why this is needed. It is
> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
> will ignore any writes to it and not exit to the HV. So this is catching
> the case where that behavior is not occurring.
>
Sure, will update.

>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>> 
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index d7a0428aa2ae..929f35a2f542 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3161,6 +3161,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  
>>  		svm->tsc_aux = data;
>>  		break;
>> +	case MSR_IA32_TSC:
>> +		/*
>> +		 * If Secure TSC is enabled, KVM doesn't expect to receive
>> +		 * a VMEXIT for a TSC write, record the error and return a
>> +		 * #GP
>> +		 */
>> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
>
> Does it matter if the VMSA has already been encrypted? Can this just be
>
>   if (sev_snp_guest() && snp_secure_tsc_enabled(vcpu->kvm)) {
>
> ?
>

QEMU initializes the IA32_TSC MSR to zero resulting in the below
error if I use the above.

qemu-system-x86_64: error: failed to set MSR 0x10 to 0x0
qemu-system-x86_64: ../target/i386/kvm/kvm.c:3849: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Once the guest state is protected, we do not expect any writes from VMM.

Regards,
Nikunj

