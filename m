Return-Path: <kvm+bounces-40213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6BFA54211
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6938F1881AAE
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 05:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5C619E7E2;
	Thu,  6 Mar 2025 05:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pNgJvThj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEC1991B6;
	Thu,  6 Mar 2025 05:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741238938; cv=fail; b=myDokpi4efvaXFLJ4eBfQUkHdqGg9ZnFlg7BqjNvwRAdMjIgTxzpyFFuUjANuOO0Aw33k0wncdbG0ySqGCcAOmwTJmrWnC8hAwDW8vsQBg1tBlcxxx187hjkT66LSO/+DAEcdBkUKnomnfT7y1PqIYw/zsndN/qFQxlNkeDKB90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741238938; c=relaxed/simple;
	bh=lUEhogYcJTrKU7Z61atLuciDN0CUFlPwYtBgp8yaJDE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fuYr7fRAhjWKQ0cynOSgVJt1DS3UyCr9n9REUUXI2hcwh+PGCZpyQbVSvM9S+L3eHzmUPfgJCHzzx7DveOHG0Vl0q2niSEgwBc9a8rRbc70pqbZiv5Ze+L1JVV+2yqS/cXHxZy/VEQFk8KtPJf7d6C1OIlhSjF7NZRO3PoppJUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pNgJvThj; arc=fail smtp.client-ip=40.107.94.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGQxpIz+/HP27G3q5SyxyY7emrKV41bqQjcONz4W4lViaxHxskTR5fLjI2lJRX0BcTTas/s0cDYhDHfJn1LdbgYZJtVFeo47ZQN8jjwhHs6Agx+T30rdDGZYpHGzFIPydRE35w0n8YTN7VtQsiVLaDJ0hEnpW+ncaOu3gUZUiJjiYyFgBYOupiygzgjtL7Tiq0ps0VX9ybpxwp4N8F8XZKeG0GuO4gyxZQO2CTWUdRwzpvLdpDxCvZxxkmMzzwbaIkMbiyX2RRxOmBBmuiRNM3TFLdG8WH6RCeKueRCfNvNB7DeTTAM52CdJzU2imSl/EQTkqqz/0/ReIL+2dPHkIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlXra29ipkzlrHP0XQrCMouJ9GevCEIRQ2USg5r23dc=;
 b=nnApV4PiWsT/8Rn72+SKHSFq9MPXbGvrAS/tihkHitzn9XUk5W7BucK6r7vtpM/XOydjGVoLxAe3NQ4v2TaxD1gVRnzitXc9WQo29+QMS1M+QgECZTNYdSTKt/7UNE5cgCfM0dq36Hz5qhHN6HjHqXLEIMTFtsfhfIqvPbDR/KMHO71YVw/XGWLP4OjmV5FHJRu7Bj+yKr2pDVTJw8Y9F7sRYNzBjwjiPyTmrLY9wEM0LJieqjnoTMG0syX1QLVd8+g4EjJJK3knRnjOcrp6cKEJcxUXh457Rl/zkfZBjyTHeNntkqfccCUmwUbbX8uVI1pkzoxYFhTLgnZmBImtCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlXra29ipkzlrHP0XQrCMouJ9GevCEIRQ2USg5r23dc=;
 b=pNgJvThjOsepWNeqqxtvjCfOfS6ncy/m40EOXWnwDHubbBNzXfb/Zwe4aTLU5kybVUOogbt4D10muFymZJ2eFk5wfImisC2RPdvSArpDECVHS1Z+jUS9VCcQIWGyh2Vb0kWYE8OFqMF7wffXlfwXaKC0ppg/iwnLmAS5eniKWZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Thu, 6 Mar
 2025 05:28:55 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.025; Thu, 6 Mar 2025
 05:28:55 +0000
Message-ID: <1d240cf7-a270-4cfa-b4bc-a41c8872416e@amd.com>
Date: Thu, 6 Mar 2025 06:28:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/cpufeatures: Add "Allowed SEV Features"
 Feature
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-2-kim.phillips@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250306003806.1048517-2-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::12) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: b49f2d7c-2089-4897-a813-08dd5c6fc9aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFF2dWVlUE5xdUo0SHlaVFUxL1NEODA1d1ZtTjJYQ21OWGx5NiszUGw0cm13?=
 =?utf-8?B?ekFGSUR2dzNCRHVka0U3d0d0aUpYbVIrRDBrYkQ3RmwvU1dmV0FFWDFod3Qv?=
 =?utf-8?B?eGxzZnVaYjdBOElVUnRmRGNTdysxQ25YOTcyZXY4eVF4UHdKbHZGU2ZDdUpa?=
 =?utf-8?B?dzhUYUZCSi9HQzRDbFB2UE1KbUlwd2NxdWNtRUdTVGRMTCtlY0pMMUIxNThB?=
 =?utf-8?B?V1krMUpnNUI5T3ZLcktZSkU4UjdqNXFQZWRITzhUTkMrZEFEdnZVMGd3Ykwr?=
 =?utf-8?B?NVpsVmhTRGxWclJqWWtPbjdFWjZlN2VPVkhGRDBadkdISXc4bGRvSHZvYnZB?=
 =?utf-8?B?WGJaOE1QZGVVYkI2U1k3azlZeUV2RUhBcUkvbUY2TVptUk1uTVFQYmd6eDlH?=
 =?utf-8?B?YVNZZGw5VE84dTdQcGkxaDlaQWh2R0VQUGNIMEJ5WE9JWU9va1dsWm5nN0RY?=
 =?utf-8?B?TFE3dk9odmVZZ1pzUlRqMEkzbEhLZHRQYlN5K0pETlV0RTMvLzVwYW5EQUlE?=
 =?utf-8?B?THVaRDNxNGRkTnNXRjRQc01mUzR5djRUZXk1RTV2WlBtcmJzMXYxSDM1Nzh5?=
 =?utf-8?B?TEhhU1d1SDlTWmt5Ui83RUdPSDU3S1cyWS9UUG1ya3JmQktMNUtseTlzbEtI?=
 =?utf-8?B?bUNyUTRGb20reCtHUHc4ZkRSeVpUM1pYY0s2a3ZJdXZEbXJCZWUvd3ZGZUI2?=
 =?utf-8?B?Uks0Y2ZKcWxIOU5HUFQvbVZzWVVHMWkyOC9UV2lYRWVqSDU1R0t6eE0rNUp2?=
 =?utf-8?B?ZW1qTGNtYkh6UERaeWc4K1Vqd1JiUDIrU1RaWTFpTmJDeWxkOWkzdURnQkdB?=
 =?utf-8?B?RFlIMjhkU0hCUXdpTzRmQ2JQaGhjcEUrVTBpQVpnUkc1WHErbG42UGFMeDJp?=
 =?utf-8?B?c3JjdkM3OGJud00zU2F5R1hhSnhubDlZMVpQRXhLUkdQQ0F1Q0JZekRXc3FY?=
 =?utf-8?B?RWJmRXV2NG5PRjY5Uk1KeG4yWDhMQTZvYURkMjY0ejRJWm00ZzEwM2pZWmFS?=
 =?utf-8?B?V2NZcjF0Qm5lOEVNNkRhSVJwS3ZRM2ZwWWRIL3R4QVBPVVpuMk5ST3FGckFQ?=
 =?utf-8?B?RFp2MzdiVGNDTGVBRERnd2RRWHZ1NVpsSURvVkxuWUxjNEhPc2Z6UkJQS3V1?=
 =?utf-8?B?d1dUTEFDTGhpTHMwRmJpRUs4OGV1aTE3WW13OFdRaG9KaG1JS3QwTUpHNG5m?=
 =?utf-8?B?dE5ueENHbjRrdUVSbTFhWE5aeE9KU25kUGJ4YUFFYk5XbVFMT3ZpZXJMNGlk?=
 =?utf-8?B?aHhieFdtKzMxclpyVjNzUXk4RlB4QnFzK3lNMWQ4WjVPeTcrSlhSQjVsYnFm?=
 =?utf-8?B?d1gxQU8xOWhkNDBCMERUZ21icWtzdVk3ZXdVWXRqK2ZvQ25XN09scDVYdnll?=
 =?utf-8?B?WkpUdjcxdW9jNnNOUzlYS3lEb0ExOURDOUZ0aUdSTE1sNFNTQzlMcUtwMXV5?=
 =?utf-8?B?Zi9hNkg4R1luWlkzbXBxT0VOWUpBa1dxZnI4RVpwOWpMYyt6U3B1a1RMTTJ4?=
 =?utf-8?B?RXc1MTJkdzJQdm5SMG1RMERzUnQ5OVE2MjB0U2J5Yk5RdkVuSkU0cmQ3ektU?=
 =?utf-8?B?ekNEakRjSW82SEtnQXdseGMzV2d0bkFIakczNzkzc09SdGhZRFQxdFBNN0o0?=
 =?utf-8?B?dEo3SW8ybmcxUmtYZXIrZ21mckg3azBsaGxtODduUlFwYVJBN3hDWS92b1dZ?=
 =?utf-8?B?MHNtQ1Y3cTdyVHhNYW1QaE42OFdRTXFsb1ArYTd6VUt1c2NHaU5kdHd0U3Bo?=
 =?utf-8?B?MFJGeTBnL3dwbG1jUVlHNzFNL0RyWUp4cjFDbHhmcWRzRS91dmNIeEQ2SXFH?=
 =?utf-8?B?RENaY1dSVzFiU1lJdmNKN3ZBQnIxS0V4cUwzMDlBS1ExdSt5M1VRWjJZNGRk?=
 =?utf-8?Q?MNQXFJLYEUfKY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUNUMDF6ZWswS3JwNW0zK2NtTGdQeUxnb2RzS2o4T2oyT1J5amdQaXcyK0s2?=
 =?utf-8?B?QkFjTHU2UG53OGFpVW90Mk1MTTg3UHpFUWh2SmoxT2hTekEyYUhPU1ArM3hH?=
 =?utf-8?B?aHdWZ3pQcFNkaTQyb2NYWGMraUNRNmhkdmVVRWZpVGs4dEhsT0UyTk4rY21n?=
 =?utf-8?B?OUMwTmZkYm9EODJuemJjVXhpb2N4bXdFYXIvTzkzaWVRT2xNd2kwbTZKaWZM?=
 =?utf-8?B?UytjMTJKVUxIUnQ4OEhEd0pGQmNDM05CNEhnMWlDMVhEOWl5aGpqeVF3cm00?=
 =?utf-8?B?bk1odHRHdXB4OFRvK29pcjkvRjZVZG5QYTgzTDJhbHl3MzJ1MzNGNG5LNUE0?=
 =?utf-8?B?UjBsbXN1NzhybzZGenNPeU44eUdOcGt5ZDNHc1JRWERIQldPU2FpS1I4OVpF?=
 =?utf-8?B?MkFBaUFrRzF5dzRSOTdpT3RoV1pLNjNLa3gxWDdSRldGY2QvRVR0V0lNZkMv?=
 =?utf-8?B?c2xicVdXMUsrWHo0UmcvUDVtbXpoaC85VUc3RFF0Z0FoUDhEVkFsMkZnTXE5?=
 =?utf-8?B?OFExUEtlQ3hKSW5nVUtmRWN3bjVjbzl3dzdBd0hVZ2JES1ZKaFNUWDVWUWIx?=
 =?utf-8?B?N0N0SU5pZTMwY0l1TVA3L0JtKzFXMnlmWXFGcVNtK0xhcU8rTC9DdnIySi9a?=
 =?utf-8?B?ZGVSRkhJdU54N1lESkJmOXNLOUxYYVltZnVkNWlUd3hZOEZNSFZiWEQ3eFZJ?=
 =?utf-8?B?MnlZVEozdlRFS3AxRHJBdEpONTNLTVhia3dPcWtGaHZKMnk4Y2QvMFRkcVZN?=
 =?utf-8?B?dk8zZmN6Nnl3REcrRVdmR2ZPQmk5SzlNQ3BJTVlXRU1NOUhoMGJZbG5SUm1I?=
 =?utf-8?B?cWp1aGl4Q0U5LzZtWU0zMjNMdnJDNTJLZXBKd1A2aHhEQUNQSTF4RWVkVE1K?=
 =?utf-8?B?Yk1iTzgxKzdOTGZXbkYrWk50NVQwS0JvV3NRZVg3cm4zVTNMZy9ibjdEbnU3?=
 =?utf-8?B?Tng0cUg5OW1aVGIxbS9TdnFXZTVEenNaOUoxazE2UDQzalZJVFYrRUo3emdV?=
 =?utf-8?B?ZHRyd090VHhNaG5LL29zbXVndThCNlhoNDRoMm9GODFZRWZKcE9ZY1I5QXJr?=
 =?utf-8?B?TXptalhkQnRzVzA3a0J6MTR1bWcyVVpBMlYrRTlrc09FdlNjUFE2WDArUWo5?=
 =?utf-8?B?UktXcnRzL1hDY21FUzBaOU9pbzBQeHBWbytoa0ZyaXVtZ3hQVVJLQkg4bURD?=
 =?utf-8?B?S2lSR2MxVW92REQwT2U0SmRHdURIL1JOeE43b2RiMFpIWlNCK2o2U1o2NHBa?=
 =?utf-8?B?NDJvM3R0V092OUYzNUhUL0liSXk2Q1YxZTUxdUlXSVZQMWU0YVVyV2xBWWh2?=
 =?utf-8?B?WkFOMktQWW4vci96YVFUQ3pQQ3lCSnc2SnROeVk1cTh1WTFiTDFBM3M0N2JL?=
 =?utf-8?B?UWZiZzZoWkRBVzZ6OTluUjVtKzRML3l5RXFwUFdOclljTnlnY2xTOWFaYjI3?=
 =?utf-8?B?RUV1Vkh4c1dNM1ZJY2QxSS9IVStTQ3ppQ0JKc2U3c3ZVa2x5azZCN0ZKbyty?=
 =?utf-8?B?NGVmK0tWUzV5V2E3cHFzZGIzck5nV0xBM2NjVnIrSUd3UE9udFQwN3lkQm4z?=
 =?utf-8?B?TGNnek4rSHpwVFZDZnJXa0I0NVpJNWhrcDhwamtLVHVhVUFaZDYvR2VlMzRS?=
 =?utf-8?B?WkFLVXpCSi9LL1QwTzZ6Q3FyMGF1WkxjWjcxWitNNmw5emI0OE9iZXQ2aFhm?=
 =?utf-8?B?a3RwQjRyRGpRWTVXZlFBMnBQRDZHTHBBajdwOU9KMU9hY21hY1VKOVcyQThD?=
 =?utf-8?B?ZlZiazNlb1M0cFRGMEpOS0l2QktNSmovbmo1cFp0VlpxUU9GU21BeStRaXoz?=
 =?utf-8?B?MFhKYmhrR2g5RHZQSDRvb01qd0JXZTRlUTI5SFJWWG4yWTQ1Uk1qREkyb0d1?=
 =?utf-8?B?MEJ0cmg0WWIveVpHSnVyZjl6Y04zVzhvTFpoNXMyU0xOUXRqN2tGQjRJVzFN?=
 =?utf-8?B?YzRRaFdDUGgvN2JJM2NCQ0syK3BFRWdsenhoNVNqaTB2Y1lrZVk2U0dYQUQr?=
 =?utf-8?B?U3hlZ2xyakNGTW5BajFzZ2p1a29UQlowSEQ4dzljbkpvdWJveHRMZHZ1VEJa?=
 =?utf-8?B?TExvYUM3OUlwMFhjMVJKVHpxM0phQU9NUWtuNzFTTUNrRGk3YjV3c1lqRVRS?=
 =?utf-8?Q?MHHUBjWNrDkzEjb1UWSPS8AO1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49f2d7c-2089-4897-a813-08dd5c6fc9aa
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 05:28:55.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NTSx7fvT8+LTWv1CXo/DOlPlSqHWfPIKu5nGr6gqPeOsCsehhxRB9mPBPuWlQhXLE3Cgc1N6hvfl6P6+ny/yyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

On 3/6/2025 1:38 AM, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Add CPU feature detection for "Allowed SEV Features" to allow the
> Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
> enable features (via SEV_FEATURES) that the Hypervisor does not
> support or wish to be enabled.
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8f8aaf94dc00..6a12c8c48bd2 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -454,6 +454,7 @@
>   #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
>   #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
>   #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
> +#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>   #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>   #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
>   


