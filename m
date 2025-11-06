Return-Path: <kvm+bounces-62154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4FFC39D07
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 10:29:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55CCD19E0AF9
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 09:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B416D30BF67;
	Thu,  6 Nov 2025 09:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rIjiDnuJ"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6D629898B
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762421309; cv=fail; b=BHfUFk8XuiGNkufTsiggDhB0sVnHQHByh54cU6AsfHrypl4uQzQoBkcg/NW+Av+ku6XtdzJ+1bIWQP1IalPzlOus4187kcxcXqdisHDgws7g83C6wq2BoTTTstWh2WLBdlF39rEqKCMf7Ayr0Sm6qjaiDhDNv6ttIClXdxQmnco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762421309; c=relaxed/simple;
	bh=vqRpTzY1CmmBy5FjwCeNseiOgldFeQHr54cfFdrGXFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Q5nnmsaG75r7Y9Ueqm+2l89lVYc66PUPLFdB6VqVNQA5gHD6Mb5n+XUZ8fSFVjggIa0DuVl7G/9WmlmYmKe9rl6A5+/ayytjGRxurHbpODlme+y1mL2oLEChhDvBOeF4yQ1ueTG7MDllByzLtwKQtjZe/y7uvKD7kv6tglzWZVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rIjiDnuJ; arc=fail smtp.client-ip=52.101.56.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UkK5St08Z4eRmGbtrnzkGPDZ6xvRmy1jjvyE2bYuTHKMYzl0M/aP99eP+92x9Y97vI7A2kRW9yK8JJ5EqYzN9QhEeOjH0m+RQlE/y8DxzjmMckcH3aScvRO//yhciLvLt/R7Vr5vmX7Gn4phdIoV2BZnCvD7zDPhYgDLGRjgCz51cEioozuM9+sQ2oSAVLtQ6uyVgZ5fBwfgoKtohMo6hXGVxj8+UJg0N4CynUc3ZlGZF+TlG3iaMaYidh+VSJX8gLxaxpM0NnfdWSVynyyGy7WL+Z1KfT6yD6HjV+GLpFJmA7PoAbDX3UfJ2eg5e7PvKnGzwQ3cgSZ9/a96oVM+tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MzO3QuhZFdtI9Xzk76AvjDo+5UIzJLa3uEiC/nwQMA=;
 b=qpOxO7eLCQfDxRK3q2ZRsSht2Lm2VvE6fh4A/d7WOK+iSti8KQKhDqQsWBPjIzuld5eYgdZpZrsyb3JrKn3otztTFUlFZhps/9rmhMCgOtm6ihOgW4jNbKi9kHKlNVJk9k9OJA5EvhnVhdxklGXs4tmuyh0NaXrVHBvPOr2QNpOjLsNPfrlPYztLlLHQw9ky1b9sSIBfbXWle/kn19AdHdyWzR0WftshcurhRAA9zHy2TNBoCmVG0M1ybGG+7V3ZkowkJ/JcSUkpsNL0AioLq+kK+DgQ68giNlYexe7wWUmCWFlm+mXaDNQLYBgBcA89r1hWotNXznZgYX0w2NPjkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MzO3QuhZFdtI9Xzk76AvjDo+5UIzJLa3uEiC/nwQMA=;
 b=rIjiDnuJJ5c+jv1HBT8KbUulKwS0SNgwPOWiQK6lr+fk2wgv5T/F5NU68NiaTwgmDZukLHL0ZL1EACxJewPMzxZ+m2DJf4z+EZc0ILwQfU97pV5/eZvSGZjq0hzSlEhmDtVVthpPYYmTxo37i72aA8kDhuW9KsfzwOqGDhoIh0Q=
Received: from SJ0PR03CA0078.namprd03.prod.outlook.com (2603:10b6:a03:331::23)
 by BN3PR12MB9571.namprd12.prod.outlook.com (2603:10b6:408:2ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 09:28:24 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::c6) by SJ0PR03CA0078.outlook.office365.com
 (2603:10b6:a03:331::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.8 via Frontend Transport; Thu, 6
 Nov 2025 09:28:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Thu, 6 Nov 2025 09:28:24 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 6 Nov
 2025 01:28:23 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Nov
 2025 03:28:23 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 6 Nov 2025 01:28:20 -0800
Message-ID: <796bcd9f-6990-4402-a4b3-7391502ae66a@amd.com>
Date: Thu, 6 Nov 2025 14:58:18 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-8-nikunj@amd.com>
 <293a8667840799f396fe4ad445c012e0e33dd189.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <293a8667840799f396fe4ad445c012e0e33dd189.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|BN3PR12MB9571:EE_
X-MS-Office365-Filtering-Correlation-Id: d7c6cddd-6654-4e84-fd99-08de1d16d57d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M29PN0t3RmNjbzNwK1dDRFlUZDNaZDZIZzR5NkF6VEYyN2hmdkpORDhvbmow?=
 =?utf-8?B?cy9pVnJGWGdDMlhmQjE2S0NvRTNGV3pteDJSa1l1TGppSi92a1o1QVg1OHFa?=
 =?utf-8?B?clZ2cG12dy9yZERJN3dxOFd3VFo1MXNNSmNpeC96M09Id01lSzV6L1BSY1dF?=
 =?utf-8?B?L3ZRcXcva0ZxZ0hTK0FVTFl5djJMcmpleXJTUHJLc0paWXhDaHh5UjhOd21t?=
 =?utf-8?B?NWtnMFlldnZhSXlPTURXUWpBakV2YVd0S0JRdXJBR2NndXBkUmNzK2J6dGVw?=
 =?utf-8?B?bDZrdVg0QXBUV3NXU2pWOFcvU0tSVFN0YmFrcFI4bGtmT0U4bEo5TVRQK213?=
 =?utf-8?B?b3VETDFlOGZkWlE0Rk1IcGNYVmV0MzBIRmZtdEZsZ2JYZEVlRWxWcWhGcEd4?=
 =?utf-8?B?RDFQM0JTWlNHYUQyTVhxNU5PQXNvNFZQV1p5RVo4RDc3bVd0ZUhBMUVRaUN4?=
 =?utf-8?B?U1pLK1p1UVltMDZwZFRGWDQxS2dJMm02MlV3VkZxc2p1UHQxbUYvdlBmaUUw?=
 =?utf-8?B?NHNUaUpVaFJ6M2VnczUyYkY4VWdlR1BVbWpXZ1VQZnBER1p0RFh1cHV6V0lH?=
 =?utf-8?B?KzEwRTltOE5aRGYvTWdlRytNTHhYWHZETTE3bTNacXpXZTBuWjYyN2ZnME9K?=
 =?utf-8?B?TjBwMW9HYmcwanJjSzRYc01kanJ1d0xCL3FqNEM4YVF1WFFPeDk4bExXMDlD?=
 =?utf-8?B?M3NuNWZHOU9lQUQ4YURlKzA3QVpmOElqd0x6OS9Ha0ZaWWtYamE0aWlkR1NZ?=
 =?utf-8?B?UmgvOWVNR210V0JtYTArdkNnUVVpb0dTZUplaHBmUC85SUFDNENjbDZEaHgz?=
 =?utf-8?B?UXhaVHBCSEVpK3duOUJPYytXNkdxSEI2L2gxcVplT1lWU28vRDduWldJMjBJ?=
 =?utf-8?B?VXZwNWlSbU5kbHYyeDF1UGdZUkNFbGRJOVE0TG8yTHlrMjZaWjdDMkFScVln?=
 =?utf-8?B?T25VWmxjWGhLdzNLK0pSVjZZNVhQSHRnTEI0a1hnWURXcG9ieXZvQk04eGdJ?=
 =?utf-8?B?MkwrS29hRE94RUxwclZyUUkyY1U3OTAva0pROXhoUktocDlyK2FnQWk0OUx6?=
 =?utf-8?B?bk1FMkFSMmNaZ2txYUkzS2hQSXBpeEo4VEpnaGtRbW5xazlqdFFmd1FYMTVx?=
 =?utf-8?B?K1NmQUh5OXQ5UC8xaGVzdHNyN0JPU1owa2M3akJxOXNzWDQzRXNNbTFBVExF?=
 =?utf-8?B?ZHM0dUlURzc2Z2J1ZmRGZHJsZTBaZkhRV0hGVzJqWWlKTUJySnlWRDB1YnI3?=
 =?utf-8?B?REhMY21iYXZCTlpxL3JaRUcxUU9MeGc2ZWt1b3hOTnRRbVF1VkhOWk5GUmVQ?=
 =?utf-8?B?WnhSS3diVlpNeGNvNk1mWjd0SXpDMVJhOFdlZE1YaDNsQjkrNWYySHp6eVor?=
 =?utf-8?B?T2oreWlPNkhRUzU3WUVwanF2N0t1cGdoNjN3WEhBWVNXcXU5dHBPWVlpTjZH?=
 =?utf-8?B?RjA2cksyb2FTWE9Oa3Jld04zOGEzQ1B0MGtjZEY4U05CUFNDM2RHME5ib0N0?=
 =?utf-8?B?UFNDZWhjVkdJZHkrK01pbTE1ZGgzRzJBMFFlWldLN0J0aDFrQTFnVU9jMnZs?=
 =?utf-8?B?MzBKaGRreERrdTNuTnVnc0wvRDlJWlFUVTRNeTA5RUQyQ3RzeEpNMjkrVjBk?=
 =?utf-8?B?ektaMkk4dGQ3blZINlVsaGJzVnpjRyt0cS9uYmx4MlM5cElleUxLdTNlNUxX?=
 =?utf-8?B?R1J6aXkrL1l2RW5ORHZoSytqbm1EcEhpTmhlRjl0a2I3OU1rbklDSnpQSXp1?=
 =?utf-8?B?YzV3NmNMWHkxVlVWQzVoSm1VRmJQb0ZyOGxtaUd6eEtKeEduWkYrQi8weVNh?=
 =?utf-8?B?SllTMk93c1hROWhINXh5M25GMGp5cEYya1VtWTV1S2tMdUV3TDNBVWZRb043?=
 =?utf-8?B?TXoveWtoN1hjMjA5V1E5QndjRlRLOE5WVnlzVHljbjFOSFVrZHZrZ0R0ejE1?=
 =?utf-8?B?alNXRG4rUzE1dnNNSTZFWlJWTjRDQnltSDJWNngrWElIUDgyL3F0QzBVMVAw?=
 =?utf-8?B?V2dWZXk0K2N2bjlNaUJXQXg0WVVSQmk3c3ZIZkJNOWFwdjdqN01VTGZYdUc5?=
 =?utf-8?B?Rys1WGZSZlp5Q29Za0NNRTRLR08wcDRucnd6bjk3ZVFDTmhFcVVpbzQveEFa?=
 =?utf-8?Q?psPo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 09:28:24.0148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c6cddd-6654-4e84-fd99-08de1d16d57d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9571

On 10/17/2025 10:43 AM, Huang, Kai wrote:
> On Mon, 2025-10-13 at 06:25 +0000, Nikunj A Dadhania wrote:
>>  	if (sev_guest(vcpu->kvm))
>>  		sev_init_vmcb(svm, init_event);
> 

Hi Kai,

My apologies for the delay in responding.

> Hi Nikunj,
> 
> As asked in another reply, does PML work with SEV* guests?

Yes, PML is supported with SEV* guests. Since SEV guest
migration is not currently supported, I verified PML functionality
using a SEV kselftest instead.

The test has an SEV guest vCPU continuously write to random pages within
a 1GB memory region while the main thread continuously collects the dirty
log. Below is the bpftrace output showing the PML buffer being drained:

sudo bpftrace -e 'kprobe:kvm_vcpu_mark_page_dirty { @[kstack] = count(); }'
Attaching 1 probe...

@[
    kvm_vcpu_mark_page_dirty+5
    kvm_flush_pml_buffer+120
    svm_handle_exit+490
    kvm_arch_vcpu_ioctl_run+1993
    kvm_vcpu_ioctl+303
...
]: 1241163

> 
> In whatever case, it would be helpful to describe this in the changelog.

I will clarify this in the v5 changelog and add a selftest for SEV
with PML.

Regards
Nikunj

