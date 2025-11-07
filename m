Return-Path: <kvm+bounces-62275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EECBC3EADE
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 08:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E7B934B0AE
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 07:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C92306D57;
	Fri,  7 Nov 2025 07:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MDq97Shx"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4383054EE;
	Fri,  7 Nov 2025 07:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762498937; cv=fail; b=eWH80FypxAmqHjO+tWaivZX+SgShfPb97WkQpq4yvl860d22CPs89DUFYcLpjrcb90kDUVDaRI7BN+JA/r38LxD6lo/WBZrIaQvEyHS7k6zezKmMWY4xKENqqhmxnfd84h3qygdXeGcVbS8HDjvexw0sz7sSAbj4MRlePDaw4Nc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762498937; c=relaxed/simple;
	bh=0MDi54Q/pHuUs26ElZS+RPUYAaX+ZVTdHp6tZvyM6i0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pYwPAW+lWMtHSIgT0cp8mQSRYXsk/o4a0nZdL5OvlJ6xgF+wHPq7NZdAtQe3yFZq8TEBiC1J9/z9ccFDstGSlpmcbACT2ZP3qZxFGMoKOwu/yb/3gBQWt4wP6WZdEawmtf3Mfq9bWx2CCYutQmdD6bQE9rfjXpTwwupwthfW4/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MDq97Shx; arc=fail smtp.client-ip=52.101.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WOvb64uFEbf9H27+bYbdmSfNulu7HbCbWCbrdG61lAJnnmWpkcowk+5bkYpNhz9Y41SlfqM1ZRWzyM6BcZbZ/B+87GH+jU1w4LVVxE65HQ0YBHk9LFE08cKu8hmXO0R42H5UIDMxmBjoEIiQvcKaNmw/WEdubryHWFssGIv7dwZbLhoRj6mqOhqNzl3qdgpac8mcr/Zqb5kV6eK+TsGhEM884A0ythTuHHaQoOF4wj0NEYJ/WqQuoVjIzXAbdeOGmTHTQQhSEgWC+cDjDJPdDrmdjCvAurr3BzQmMG/eqjyHnSblx9o9ae4LHNS7mZJ8/Cseiex5IqUi00mXmHxtFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTcezy7lq6c6TDknXM9/i28cENTvapnWDwdoAMtUeMw=;
 b=UbAsHZEolL3h0Q0EDJ4Ib86XOSAHXUfEl5r9wZLcoYiXQtqh9qAJSlagkQSCbeCLxG1O8fvkBU2CC6X3LdBsZTjA19R4aCeMYE05hiMvPs7Uuf/+9BOE2adPNwYuQRdb+QxMfs6Iv8PjHrDFVRVLax0M41x7/IshAUQpjsWPy3WgW7PJuHFlCc179uxwrSGbInDqo2n7CBxxm754FoB4z1uEZ3yQ4PiQe862DnjjqgR2//e79idWCxkdfL64WQh38jg+qGmzTceaBP/DLPbmcxkNs9n+n9QKssC+znyjNI4ADV+bEwbx+l9DELBArfQtSrj0eETbCqiehUtHw4bywg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTcezy7lq6c6TDknXM9/i28cENTvapnWDwdoAMtUeMw=;
 b=MDq97ShxgFEpSc7XxnAX99VjDwYuvlF52HwuY1fumkP1qAS1BFwGUdUpsKoF4g7UU/+T6qYGlk7GiP3SBsIzMUrmX9M3VtghIVsmsMxtsT53cu1oQCnouZpv5v5srjyxiS7tGs4YiFqoi4YjYerUWm3OimwLH8FjqBekJG50AEo=
Received: from DM6PR02CA0069.namprd02.prod.outlook.com (2603:10b6:5:177::46)
 by IA1PR12MB6067.namprd12.prod.outlook.com (2603:10b6:208:3ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 07:02:11 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::d) by DM6PR02CA0069.outlook.office365.com
 (2603:10b6:5:177::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.12 via Frontend Transport; Fri,
 7 Nov 2025 07:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Fri, 7 Nov 2025 07:02:11 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 6 Nov
 2025 23:02:11 -0800
Received: from [172.31.180.39] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 6 Nov 2025 23:02:07 -0800
Message-ID: <93211ebf-1b8b-4543-bd1c-f3805a54833e@amd.com>
Date: Fri, 7 Nov 2025 12:32:01 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: SVM: Mark VMCB_LBR dirty when L1 sets
 DebugCtl[LBR]
To: Jim Mattson <jmattson@google.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <nikunj.dadhania@amd.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Matteo Rizzo
	<matteorizzo@google.com>, <evn@google.com>
References: <20251101000241.3764458-1-jmattson@google.com>
 <6f749888-28ef-419b-bc0a-5a82b6b58787@amd.com>
 <CALMp9eQJ69euqBs2NF6fQtb-Vf_0XqSiXs07h29Gr57-cvdGJg@mail.gmail.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <CALMp9eQJ69euqBs2NF6fQtb-Vf_0XqSiXs07h29Gr57-cvdGJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|IA1PR12MB6067:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ce7f5a-5e4f-473f-734f-08de1dcb92ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHVpaXh4V1FrUVIrdlVXaW9tQk1KMGxCTnJoblY1VExuTU01bjgzdHF2b0hl?=
 =?utf-8?B?Z1haaGxCd283Z0UwbzlVM1NIOTNuZkNzZ0xqRjRMVjlmVDNoMVFGTDZCRHRk?=
 =?utf-8?B?UHVHM2ovc2xQZ1AwSmxXbHZlSFlrTTFlQkFIWFVGSFhZY0NBa2tIKytSN2lj?=
 =?utf-8?B?MGloN3h6TGlTOS9hL0pZZjh4NWJEN1Y0Mmk1a1RvaWFCM1Uxc0JHTXJaTEZK?=
 =?utf-8?B?cVF3QUYyZit2QjJKMVpxTXV6Y2FUMEpGVW4rZmtia0JRTk5RbTlMTmpVZ2d5?=
 =?utf-8?B?a3N1bkVIeCtWSFIvSHp3TXJLNGEvU0pZR3dMRDZuMGFxNkdFOU5LTm1vREpI?=
 =?utf-8?B?cXp4SkpZZWdNUnZ4L1hFWEtuL0s1dFE5NHZPMENUMlNYeGNtTWJoR3R3WUZP?=
 =?utf-8?B?cDVHamF1SzM2amU2eDQzY0lDT3JEZHdxZHlTYmlMTjB4ZlRDTkZ1M3Urc2lN?=
 =?utf-8?B?UGxwVVo2dzlIWkZmN0JlNGlxanowSFVmYkFpcmVYTmJvMk9zVnl6a2V2QTRm?=
 =?utf-8?B?VjBIaE1NcHg3MTBuVDNXRUk3MlIrWUd1TzcyWWVlSnRleEtubDdjOGY3dU9D?=
 =?utf-8?B?dENMWjVueEo2UzBiWGJUUExabjFjY0dFYU5iRXU5ZHVjVmg4SnBaejFuNkRW?=
 =?utf-8?B?dnFnVy9ieVk4UU9kQk9wMmFxOU10dEtJQUdrUDdLc2xuTVpjQlBhSUtCZ1Fk?=
 =?utf-8?B?TXVWR25jaXZGeWJwSVgwYmtVTURRc3A4RkNBeVdxWFM1SFR6a3BIM1Q5Mkhs?=
 =?utf-8?B?TkN6ODBaQWF0cnpyY2FkZFVGdmI2TFU1bDdoejlPY014dUNlZHNQQlZHcUdv?=
 =?utf-8?B?Vkh0bjlzY2lJa1hsRnNpR2VCKzR6N1hhMzZQWDhDdzg4S3ZObE9pc3lWaTRR?=
 =?utf-8?B?OWMybEJUemg2YS9hQkp2VFg1dWdzM3Y5N3Z5anJPM1F4bGlNZVM3UFQyQVh5?=
 =?utf-8?B?Y25nT3VMOVhRYzI2RjJNTDZuNTBKQnFjQkdTTTVCVkZLbTM4R293RUFTNk5a?=
 =?utf-8?B?bVJEckVyNFp0cmNIZkJsSXFLZGlVSm0zbk5SWDdwYVZvMzhoOGhMY0RsRGtp?=
 =?utf-8?B?ZHRCTWVWTlVRN3V2REVjMjVieU42UVZVVlVCcHRlbzY1WjBvRVdjU2NjQkFR?=
 =?utf-8?B?b3I0RVlITVNEdUs3dWlXNi9TVVVuNVRpSll3QlkyTGpNY1A3TjNSbU5KTnBu?=
 =?utf-8?B?MmoxL0hJQ0YyWGM3UkFnK2twZnF2ZTlHY09iclI4VDl1SWVIUDA2V0xjbnlL?=
 =?utf-8?B?emMrUkJ5Zy9SdW1aVWExSGljYjhieWlkbzRhR2J2VEhMaGRkVmxhaGVVZnhL?=
 =?utf-8?B?NytudGJac0JBT0E4djFIRUZzZkFZZmJyajFCSzF3UXB1SVNoQkZLaDI1Skxj?=
 =?utf-8?B?eTJoRFd3dlJDcHFqWWlqcUhVZjN6YS9GVnFxdnR0UENWbDFvV3A4a1NqYmdU?=
 =?utf-8?B?T3ZoOWI2ZWl1Um5mdExoRG9ub2JjNXUzaHMvYWIvNGZ6ak1NekVhUnkxSzU5?=
 =?utf-8?B?YTFIcCtVOTZLaVA3dWFFMGNtSVUvcnc2RlVNY25LWnVlVlJZc2VQK3dralhF?=
 =?utf-8?B?TVpoKzdhTzl3SzdvK0h5eVVaRUw5WGJTOWVFSkpQZERDRkZvVVdCeVJMNHYx?=
 =?utf-8?B?dHpKNitoUlI5ZlplYmZUQWdyTUwrOVc5RlA1VDNDa1gvbHg3SEh6ekZKMGdD?=
 =?utf-8?B?MDMxR3pCeHFCbkNOb1FERVVGTGdPTXFuV0cxK08vek5ZUGsyN3pQZ1BadFlC?=
 =?utf-8?B?NnBaMVlRZ2YvQi9NVWVZcWl2SkpMTmdwUkJsQVlhcXhOMXdwRlpUeFVtSDV6?=
 =?utf-8?B?WUkrSDZHcXZ3dkdlSTIvbFlnajF5eElzeWhETXhRU3BlZEczVjJqQXZabDBX?=
 =?utf-8?B?WUs3RmRVd2RCanhteERmS0tPRzl4QXQ3MHBxcFd0ODVwTU9QeXBqRk50VEgz?=
 =?utf-8?B?S3RlVm5WaEJwWkU5cTQvdG1XVWoveEZnaS81TG1GUDJIaitzY0h5Y1hkbHp6?=
 =?utf-8?B?RkxTSEMyRlBwZE1RNWFFaDBtYzZWL2l2THMvYStXdGI5UTQyMWQvTXUwcGFn?=
 =?utf-8?B?cEZlMGVLM3V3VEZ2elEwdUowWWdCQXdUZkZTM0VVenVSWTVvbDlYalpBb2FF?=
 =?utf-8?Q?Aq8U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 07:02:11.2936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ce7f5a-5e4f-473f-734f-08de1dcb92ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6067

On 06-11-2025 23:30, Jim Mattson wrote:
> On Thu, Nov 6, 2025 at 8:09 AM Shivansh Dhiman <shivansh.dhiman@amd.com> wrote:
>>
>> On 01-11-2025 05:32, Jim Mattson wrote:
>>> With the VMCB's LBR_VIRTUALIZATION_ENABLE bit set, the CPU will load
>>> the DebugCtl MSR from the VMCB's DBGCTL field at VMRUN. To ensure that
>>> it does not load a stale cached value, clear the VMCB's LBR clean bit
>>> when L1 is running and bit 0 (LBR) of the DBGCTL field is changed from
>>> 0 to 1. (Note that this is already handled correctly when L2 is
>>> running.)
>>>
>> Hi Jim,
>> I am thinking, is it possible to add a test in KVM Unit Tests that
>> covers this? Something where the stale cached value is loaded instead of
>> the correct one, without your patch.
> 
> Though permitted by the architectural specification, I don't know if
> there is any hardware that caches the DBGCTL field when LBR
> virtualization is disabled.

Alrighty.

Tested-by: Shivansh Dhiman <shivansh.dhiman@amd.com>

-Shivansh

