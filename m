Return-Path: <kvm+bounces-58449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D30FB942DE
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 06:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4F222A3D77
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C2F275B16;
	Tue, 23 Sep 2025 04:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w0Ar6nN2"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961991E502
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 04:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758601133; cv=fail; b=XFOFJalaJM1umvUKIMIOF4mwflSfeEHVlF0EFuiNl7Gs6jJaX87F96VdJOQWWiooO0BH7NLaiwmhFz8QBhqCIEv8U8ooO9lhYMZN0X0yN15AKQeUMvD2DEoSeFNbti/OnCM1jrs8OKWAGDfTy425fKNeRJzK5oTC6oGa4g9Z2I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758601133; c=relaxed/simple;
	bh=gqkTFMHjqxSeHh9427KCJt0wmo9FfSpH6qsfk4X96to=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=roU1qcq21Ct8BJxZZcgc8LR1Z+vQaftjehg7dhhrv4bkIt1chZlkv1QC/Wltax3D0XMO1vj0z36rBWXIzrwkVThGdAz7RxwzkHdmX5S5JQ4BboIYxrmh9Fl+aCtf4jw/ubm34AuO5MzwFpR55k9o7Mo7ebmVjNwSfQgAs16O/zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=w0Ar6nN2; arc=fail smtp.client-ip=52.101.53.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tDSTQepSoH/g8uxzcT4tt87tyVIxPwYq3LqEaoOGy4Ls8vGI/1peiNTmcyLlPh5T3Fz8NwIx46m/eBzpehXP64AjyMJe7bmXG3envFEL66n64GYxsEvy/PYDliaxkWTUdkKgCwKcePp2WCr+sYDTNirtiLCGf8YxkAGc5tkUyS2C0+Qp5AAb9UtcyTIX1ryWE1XHk83B7Rt5Rj5eT49j2wqdptaTnMdjdNifBigrmATezzOU50fxXZL4bHBZk58zuYTnwYICAv5Oye6cayoiXzNQlwg4nZ/krHswllBUP37WRV1azqOgkQ5m2suP/N9KP9arUzezGZGclUc76qV8Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7tUHmMozLYj2kJMrVTY7GKcxahS9k+pcMc22fSLPqQ=;
 b=QLeNz3Z4+jKp3LKz5DWU/DeFz2ZtiRDE/a4vP69t1B/28VNB0d0PK3N+QroBVlJoMVRLDoCF5p3hPVqvxG7++3hAv55MGZW7nTS1W2T2D8se4UVWBpzdIaM6qtun1d4fCQ+aK7uWJQyghWee6nyFifyCZQRMgn9L8scC1YHOGkbI9yjD00lfxCXMcbguF7XUV1bkgdtUzSTySpSNjNwvKojt9SfoCEL8T7/kHKufL3qmISP6Vk2AZkRvbXPIsr2IO+/WoG0QCCei+Qoz0Goo0po4CmivhIS1Lho/RHqWzSyoTSVhrWEXZiZkwlXSUU6lE2vkakHdaGdiwDGgWIjDFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z7tUHmMozLYj2kJMrVTY7GKcxahS9k+pcMc22fSLPqQ=;
 b=w0Ar6nN2qkTsRknQC0GL4JUtuGX/DBe1VVHhB2FAOyxJ4k/6s1eocCqxsWIKkaa2mWG4Eu+cjX+D44za5W7NAQ6NSRn5PAls4qr10WRGIJsxZTuuimvL/JO3e47/tzLnEN2Azw7vwI1FXHpylCwRqeJPT1WKwAlRmyx9MHGZ5rg=
Received: from MW4PR02CA0026.namprd02.prod.outlook.com (2603:10b6:303:16d::25)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 04:18:48 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:303:16d::4) by MW4PR02CA0026.outlook.office365.com
 (2603:10b6:303:16d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.20 via Frontend Transport; Tue,
 23 Sep 2025 04:18:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 04:18:47 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 22 Sep
 2025 21:18:33 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 22 Sep
 2025 21:18:12 -0700
Received: from [10.136.37.89] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 22 Sep 2025 21:18:09 -0700
Message-ID: <4f3f7b7d-f6bf-49de-8c3a-96876e298ad5@amd.com>
Date: Tue, 23 Sep 2025 09:48:07 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
To: Tom Lendacky <thomas.lendacky@amd.com>, "Naveen N Rao (AMD)"
	<naveen@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Eric Blake
	<eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>
CC: qemu-devel <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, "Daniel P.
 Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, "Zhao
 Liu" <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>, Roy Hopkins
	<roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <6a9b3e02d1a1eb903bd3e7c9596dfe00029de01e.1758189463.git.naveen@kernel.org>
 <412fce46-e143-4b71-b5ac-24f4f5ae230f@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <412fce46-e143-4b71-b5ac-24f4f5ae230f@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: ebdf07d1-5ffc-47fc-1ffd-08ddfa584af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3dXSWtpM0wxRldYSUpnOGFXOHFHVUpGVERVakJ0UnVyUnVCa2tKck1Ncmhl?=
 =?utf-8?B?bEtBZU1uSld5eU5lNXZKQnpWWldVTDJjcnYxSWsvK0ZISWNwZXgvU3FDeTEy?=
 =?utf-8?B?ZDBVTVdCVGNKT2pkV2ttc3FhQWsvR3NaQTgrTkxiREpxb0Q4Wm0rcHdnSTBY?=
 =?utf-8?B?bEREd3RkTUtwZjhXcnhVUDdIZjFkWUt0TEJ5cmhDV29sY2VpeDMyeDV5TkRG?=
 =?utf-8?B?T1dVZ1hlVURxbWxHdU1XQWNJYTRqUHY3N0l6ajZkVEorRkpVSUpVb1FiMjl2?=
 =?utf-8?B?SklQakNhK2k0MTBMZkJIUUNJRFUyWVN6UzArcDQ0TzFjQitZaGxxN0Y1Zkk4?=
 =?utf-8?B?Z2NoUXRxbHR5UWZkeGJlS3BWa1hOZVNad2pDa3BWaUMwTGNUMi9hdVRKRjk0?=
 =?utf-8?B?czNJdjJCeDBWM0IyZXFWT2gwQjh5dXFEbnhHNjF6UFREMVJFK1hMQnlodkYr?=
 =?utf-8?B?Vmd2dmx4bFhXNXA1bGZ4bk4yMGNwOTBucjgvekQ3c2c3SmxEL1F4MVNVRVcw?=
 =?utf-8?B?aWVUREJIeldITEN2OWZTQmo2enpUcTlZaWZ0bFp2Y1FhMVVHaDRiL213MGhy?=
 =?utf-8?B?dytCY0xpV3UxZ0V3OGV2aWZzTU40UmNoN1ArckNEc3N0N3lTamxTazFOTWUv?=
 =?utf-8?B?dG9UTDZOZkN2SnB6ZWVZWkpnbkR2Q1VzS09McWNzUzNmd1BaQmlWMkFTc3JG?=
 =?utf-8?B?WXVYNlB5ZjFYRXI2cDRKYkNXNlM5RmdWc3dpWjU1WEl4eGR2SnNQanY0a21W?=
 =?utf-8?B?RTcwL3VyWE9naTFmdVBDTTlUdHNFSytBZzNSUG1uWGxKbHppSlRaemVDM1gy?=
 =?utf-8?B?UUEvcmtMMXJqOWNyTjZYWkZrekljR0hTNGVPS1B4RzJOSmtpZ2dVdktXSG9N?=
 =?utf-8?B?Tk1BYU5DdHpLTk1JTlhSazdVMEtZTk1aVzB5N0xJb2ppTlkvREp1OXI4ZzFo?=
 =?utf-8?B?MUZCTk44T1A5S1Z4V3dabnc1MUx2ajAvNGh6NFR4eVpucG1QNVJndDhSMXBQ?=
 =?utf-8?B?b1Y5a0lRNHVra3NYbE92WDdLU0U3Q3pHR2VIdDVXbWtJVG9lUHRBWVFiVWRI?=
 =?utf-8?B?cmRUSGJ0djNFU0NkNkVLOGlOdDRJQUFvRUp1UlF1eTFyVUlieHRZdVkzOHZo?=
 =?utf-8?B?VG5mUTZ3eklKMzZ3UDdGOUI2SU51a3FGbjNwSUtqK0VsZUE1Um92b0dQdjhm?=
 =?utf-8?B?c1lreU4zQW4vSDgycFY2Nnl5TklSbkoranlMblhQU3JzVW5OYXJGM1lzdHNY?=
 =?utf-8?B?WmFjeXZmSVZ1VWhFTnlaMC9PNVk2RHFXWVQ1UzVQUDlsRngwQUhNQkhIQkEx?=
 =?utf-8?B?R3VVeXkxQU5jS2dDRzBTbXY1UWo1cmkyMVRzN3JEdTBlRjJzVW5lMU9mWDdz?=
 =?utf-8?B?SFpqR1VQT3dyNStXYk9iVTROR0N5VXZDTjMxWEhTbEM4STJBcmt5WkgvQmE1?=
 =?utf-8?B?VkY4N2NnYnJpWmdqdkV4TWhrSmhjVjBObUpWZUNwOXAyVkV2eUx0QTVyUDZP?=
 =?utf-8?B?aGQ2dVRxWmdnQ0tFNUNmVWxQdkVZeEZ6bGMzZkxpWDFyK2JySEc1eFpYTEZT?=
 =?utf-8?B?UHRKWGhNTHZRaytRWlFKVHJpRFRVZlkxU2FPOGpTRGdER1VsY2FoVythZm5X?=
 =?utf-8?B?VXpYaXE2V2JjUDI2VGdKQkdQdFRuVmtWMklrcFoxOW5nM2hCdHVNRVFzYkNN?=
 =?utf-8?B?d2dVNktVOFExcjVpRVo4cGNYM3B3R01UaWFNUWN3SWx0ZnNDR0d4RWJobmVk?=
 =?utf-8?B?bVlHb25iN3B3UUNLSm54Z0ttQ29Wc2ZzYXRlWjAzd25OMkpMVVBsUGhSUzhQ?=
 =?utf-8?B?K05XZEVLWHpGRjRWSGkrZDZjQWN5WWJhVHc4cEFrZVlvVnZOYXh0Z0JmSmo0?=
 =?utf-8?B?eWVQbVI0VkNrbzlYWlRMNGUrK05maUZ5UFphUzNPQmdTUVRPNkQzMHdHR1M1?=
 =?utf-8?B?K01qTDlINlNyK212VElkZVFmWnBWb0dFK214LzRVNlhIelVucW9ueGxWcXFP?=
 =?utf-8?B?eHZmMEQxaTFjaWdGYk9pQ3JBWTNHbmErWjZHNGxOT2tXbWRaRmFXRGNlUXEy?=
 =?utf-8?Q?KJJnqA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 04:18:47.7053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebdf07d1-5ffc-47fc-1ffd-08ddfa584af9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226



On 9/20/2025 3:36 AM, Tom Lendacky wrote:
> On 9/18/25 05:27, Naveen N Rao (AMD) wrote:

>> @@ -1085,6 +1093,18 @@ sev_snp_launch_start(SevCommonState *sev_common)
>>              return 1;
>>      }
>>  
>> +    if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC)) {
>> +        rc = -EINVAL;
>> +        if (kvm_check_extension(kvm_state, KVM_CAP_VM_TSC_CONTROL)) {
>> +            rc = kvm_vm_ioctl(kvm_state, KVM_SET_TSC_KHZ, sev_snp_guest->tsc_khz);
>> +        }
>> +        if (rc < 0) {
>> +            error_report("%s: Unable to set Secure TSC frequency to %u kHz ret=%d",
>> +                         __func__, sev_snp_guest->tsc_khz, rc);
>> +            return 1;
>> +        }
> 
> It looks like KVM_CAP_VM_TSC_CONTROL is required for Secure TSC. Should
> this cap check be part of check_sev_features() then, rather than waiting
> until launch start?

If the user has not provided tsc-frequency, KVM_CAP_VM_TSC_CONTROL is not required.

> 
> And does KVM_SET_TSC_KHZ have to be called if "tsc-frequency" wasn't set?
No, this is not required. This patch has changed a bit from my original version, we should have something like below: 

if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC) && sev_snp_guest->stsc_khz) {
...
}

Regards
Nikunj



