Return-Path: <kvm+bounces-55105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A6EEFB2D70C
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 10:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 941065E0935
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 08:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730932D9ECE;
	Wed, 20 Aug 2025 08:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="26+t9Dfq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DBE27602C;
	Wed, 20 Aug 2025 08:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755679709; cv=fail; b=W0SqJ5+CcWazhi0rNRCygMW/ZBxBX46jlU7X0XmUC1HR28rit482WWxbRUNPY38DanQ+74ZsQ+uOyqhSVVXcBpnMPyv/yAx2ad7RzVMTzaWPgf3TE4v0JEjes10c26latnzo5y9MW1DA1sHBpVAcdCfeaJGW0D8t2Qh73GhfYyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755679709; c=relaxed/simple;
	bh=RGrw1t9Vuz3kpObjQa8TWiw1P2xg/dBXTC8smhoYg7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RSJURe4aAFNbHOgwR2ZtWNyUYEwnNh7Rq+f2eTBeEc8q02jSVTuuOZnOcO19QcQg5OIfaY8nLZzZ9lnFOgxVX6y/AC3YTtOem+7Gt615nNxCQf9jsJ57kz9664hy+wuTcLHPckbygzEUuhSbD0j6V45dxocbWFUBbjcAnOn1F2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=26+t9Dfq; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFwIXjnWGPSD5XhJxy5GStkIj7ThTwmn0NWLmKaoYRg7b1YMsF+GOuKrKFWl3JBh+A5u7VkgY0kAcUz6nhubp1iRRnUxeqk/gWANqrAVztKLMqCuwEeZniZHK/4DFItz/uM1xDd3JDMph1dmEQ5tgQEam79mQeBmgeFXy3yQUUpLVrsUtwMMOQMJtGhahkglD1L7LF3Y9gtVWH6mNmfwq7Uov+fVwnytrYKdITX6lOU7X2xSVtW9qbPmJ4Z5YuPutAuC+/A+8YSZgRC/e4LoPrAHAJqAHibJ5lY5VCfL4+jje7vhoE3MjqxzsjfGVQUy15DeJlmT7/PlnAijETIVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJJFbytIS6V7LZ6gtkYEbC6tAkZ6cwPeIpbym1nnb80=;
 b=AG2CKxa35uuVNO0gY1o5BYDzbNAo5VzDjWJptRKzh2FtgO+U7E3rCBSIMulKKQXtdUeZCgChcQD9G5xdmt54UQ2M5Co34RKhBTnrs5RYcjE9izdaR4dJMLeR0kfWxtKoQ4z/93DG0hRHO43vlLvMUw4R16l2DtlnXrDn8TVeiMm0JMH5Tkzh2cFIPBOcn1kgYNBjy01gMt7W1K6EtkiDaRET+1fl8oI6oZtfaNqJAEJrYrVzBlXIVRSb8sOgteKJAGfpx+3grqMEAudZTIZs8CsZmo4T/mZI/e7pR9H+Svf15AwoSqq4qkoIG88AKvNmwrcjmQu8S/LjEajJbk+S8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJJFbytIS6V7LZ6gtkYEbC6tAkZ6cwPeIpbym1nnb80=;
 b=26+t9Dfqo8AEESBNojA284kblfbCcDFR2R/VT0A+WWDjBcg0DfcI+yDkxn/i1An1jmPrT5ICHWaChYqaHiX77N29CCPwgSsHyGvVkxUWQJftbV1B8fj0HGfL5looEETvsz7RiB1ZfckTW5qoDGa9eIOZm1HtRnJgzMwIKfxyTKk=
Received: from SA0PR11CA0178.namprd11.prod.outlook.com (2603:10b6:806:1bb::33)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Wed, 20 Aug
 2025 08:48:23 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:1bb:cafe::9c) by SA0PR11CA0178.outlook.office365.com
 (2603:10b6:806:1bb::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.25 via Frontend Transport; Wed,
 20 Aug 2025 08:48:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 08:48:23 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 03:48:22 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 03:48:22 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 03:48:19 -0500
Message-ID: <afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com>
Date: Wed, 20 Aug 2025 14:18:18 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Ketan
 Chaturvedi" <Ketan.Chaturvedi@amd.com>, Kai Huang <kai.huang@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 40228313-f40d-416b-748c-08dddfc65229
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXpWc2VhK2FJZUZtbS9rS2hXbnFDQ3VpVDlXSUIwT1l1aW9UdnVIbnBpMGQr?=
 =?utf-8?B?ak1NbHk3QUcxdXpXeFVUSjlZUml6ZE1hVW9PKzJ3c3RsbmtVSFpnU0RpTnVi?=
 =?utf-8?B?QTc1ai82UDFWV0JmSEhTR2w0RjdCd3BDRXp4OFhmSmpYeFVrUHhQd3RMYkpa?=
 =?utf-8?B?SUI5OGtQWFlQelNDRlFmczNZRU50MXlMZjJVdkJlV2YwSjM3eldsTktmSWpN?=
 =?utf-8?B?UzFiTUdHYTc0Ull0aTB0SmkzYnV3N05xRjJxZXNJQ0dBVHVSWDBCcFBGdkxj?=
 =?utf-8?B?V3FOdGFwOHNPRUN3Q3ZtS3RlbDZYM3grOTVOck5EeWNpR2pWejhzd0E5Y0Uz?=
 =?utf-8?B?S2ZId0VKQ2tkd1JZd0h2Mnp2QUZKbnhWR1NySndLUE90ZXRuWWttcFFLK3Bh?=
 =?utf-8?B?ZE95OWJXSjQwK2Y2ZGp3alNXSHhlbkU1anBwaTl0ay9nRXpmQ0xOY2dEZ2cz?=
 =?utf-8?B?eUZiUkt3NkVtR1RoM3VBWjk0QSszQlNOTUF0eitrc09QbytsOXFCZk9RSXZM?=
 =?utf-8?B?UnBXVmJDMWlsc2hRMlZoaWJiZTlsS0FKRzJpNHkwRlpYbXdyQVd4cUE1YURT?=
 =?utf-8?B?eG9YSitsMTJhMTF0S01IRWpPM01TM2dGcVhiZTh0NjBOSnAzTGVramZDa2Nn?=
 =?utf-8?B?NlB6cFRvanF2SURLTWZjb3VYVGJTenI4UlhQOWZEdzgvQTFXOHVFWHFOZzQw?=
 =?utf-8?B?YnI2dDlUZ1o3OG1CWmFTRWM3NzFCMUdNMmZpcGVjT09hN3FjVlFSUDZ0K1hq?=
 =?utf-8?B?NjUvQllPbWRFdUttMWdwTEVWakFoQ3hISU0yNzMxTWcxSmJ4SU1UMk44S2ty?=
 =?utf-8?B?U2l3M3YzVEJwMVZvc1dSMTFHdmZ4V0pxZmZpM1cwZThWR1FEQk5QRFMxMFFi?=
 =?utf-8?B?Wit5UjVuVXo5RWRiT0ZLK3pTcVc4OTVhLzV4N2lxaFlaZGFLdjdySWxXUTR1?=
 =?utf-8?B?K2pnbTZiRnE4U09wMGpPRVROQ1JJL1ZmT2FBK1dhWDRpVTMvMjUwT0kwempT?=
 =?utf-8?B?YytwRGhVVjVrQmpZeHZTMElwL2JlOFhTWm0rekgxRG9oSENHOVorbkdDYmQ0?=
 =?utf-8?B?Vm1HWEd0azYwaTFZQjJJbDNqbUlFYktjeFBHQ1VQZHZmNjd0anJrc2wyVmQ1?=
 =?utf-8?B?QS93VGYyS3paMGMwTzNOWWljR2RtT05NOHVMOVVNRlFzL2tBeXg3VDY3eTBP?=
 =?utf-8?B?RG1rL1BBVHRlMXZjVnBWYTRZUC80Y0FpaUk4dlpRTHJRWjZ2TXY2dkpqNXdw?=
 =?utf-8?B?MHpnUE45NW1mY3FZTHhCaFpWaHE2N3kvcG5jM0wvUWpuOHJVaWFDcCtzT0c2?=
 =?utf-8?B?UmZSeHFEbVJYV0pSOTFuUE9URWVMaDJ5TVVTRHFoUjBudnkxYWttMjlUbUQz?=
 =?utf-8?B?YXdFSTNqLzgzZU44c2VvaHRzTnhvdDZjUFdwWHFrTXd2S1pSRVdRMWdZd3B2?=
 =?utf-8?B?MFF4QXhPQURMbTF3VUlISTJNb29NbVFMQW4xMFY0UFlCN2dQM0h0Zm1VSmN1?=
 =?utf-8?B?enR3VnVLZ09oNGdtditESlR2VG9Za2c1dEtwUnIycXpmSjk2SnVNU1BEMm9N?=
 =?utf-8?B?QUFabzNESWdBZEw0TnJtZFFZd09kTXVCV3JrQ3N2R2ZNL1hxbkJBK2JkS0RI?=
 =?utf-8?B?S2dwd2Ntc0I2T2kybEI1dEpOdVdMMC9yWS8xMm9HV2p4TEFSdEg0SnRLV2k4?=
 =?utf-8?B?bXl4OXpZNTVjWG9GTXBWY0J6N1BIanRvM0NPaGRzdERYZkkxVHlTY0NhcThi?=
 =?utf-8?B?SzBHV0VkbkxnSHBpTVpxWXd6ajd3YnpvRnVrajdORHY1TnYwQmNQcUpsOWM2?=
 =?utf-8?B?NWo0c3ZZKzVFN2JHTFVNbXp6QW1KMSszaGtlNmlOUG5uRWNxdFBTd1hWSjFL?=
 =?utf-8?B?a242a3Jxa0JjdFVSYmtrMEE1Y0JiM0JZdUFuMmdXbFlVMWt5VzcyZGdpTXpM?=
 =?utf-8?B?aDUrWmJpSFMxNTdINitwODJSanNaRzFocnMzRXlKQXpEdVBvU0g4bHFwZ0pQ?=
 =?utf-8?B?Uzd5Yk5iZyszQUpSUEtYYVJ6UE5RZVlCdHIxVllWRlRpMzh4Ujc1NldUTElE?=
 =?utf-8?Q?aWbIou?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 08:48:23.0762
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40228313-f40d-416b-748c-08dddfc65229
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> This is a combination of Nikunk's series to enable secure TSC support and to
                       
                          *Nikunj's 😊 (close though!)

> fix the GHCB version issues, along with some code refactorings to move SEV+
> setup code into sev.c (we've managed to grow something like 4 flows that all
> do more or less the same thing).
> 
> Note, I haven't tested SNP functionality in any way.

Tested SNP with and without Secure TSC, guest works as expected.

> 
> v11:
>  - Shuffle code around so that snp_is_secure_tsc_enabled() doesn't need to
>    be exposed outside of sev.c.
>  - Explicitly modify the intercept for MSR_AMD64_GUEST_TSC_FREQ (paranoia is
>    cheap in this case).
>  - Trim the changelog for the GHCB version enforcement patch.

>  - Continue on with snp_launch_start() if default_tsc_khz is '0'.  AFAICT,
>    continuing on doesn't put the host at (any moer) risk. [Kai]

If I hack default_tsc_khz  as '0', SNP guest kernel with SecureTSC spits out
couple of warnings and finally panics:
 
 Persistent clock returned invalid value
 ------------[ cut here ]------------
 Missing cycle counter and fallback timer; RNG entropy collection will consequently suffer.
 WARNING: CPU: 0 PID: 0 at drivers/char/random.c:931 random_init+0xe7/0xf0
 RIP: 0010:random_init+0xe7/0xf0
 Call Trace:
  <TASK>
  start_kernel+0x5e9/0xb80
  x86_64_start_reservations+0x18/0x30
  x86_64_start_kernel+0xf5/0x140
  common_startup_64+0x13e/0x141
  </TASK>

...

 WARNING: CPU: 0 PID: 0 at arch/x86/kernel/tsc.c:1464 determine_cpu_tsc_frequencies+0x118/0x120
 CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G        W           6.17.0-rc2-stsc+ #1063 PREEMPT(voluntary)
 RIP: 0010:determine_cpu_tsc_frequencies+0x118/0x120
 Call Trace:
  <TASK>
  tsc_init+0x2ba/0x430
  x86_late_time_init+0x29/0x40
  start_kernel+0x70b/0xb80
  x86_64_start_reservations+0x18/0x30
  x86_64_start_kernel+0xf5/0x140
  common_startup_64+0x13e/0x141
  </TASK>

...

 Oops: divide error: 0000 [#1] SMP NOPTI
 CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G        W           6.17.0-rc2-stsc+ #1063 PREEMPT(voluntary)
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
 RIP: 0010:pit_hpet_ptimer_calibrate_cpu+0x1be/0x410
 Call Trace:
  <TASK>
  determine_cpu_tsc_frequencies+0xc1/0x120
  tsc_init+0x2ba/0x430
  x86_late_time_init+0x29/0x40
  start_kernel+0x70b/0xb80
  x86_64_start_reservations+0x18/0x30
  x86_64_start_kernel+0xf5/0x140
  common_startup_64+0x13e/0x141
  </TASK>

Regards,
Nikunj

