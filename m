Return-Path: <kvm+bounces-40783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9362FA5CA24
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 17:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9061B3A9587
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4B525FA17;
	Tue, 11 Mar 2025 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1J+yBYLA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3AE3594E
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741708938; cv=fail; b=mQILi3QYnZdC410qiISR6Z6kf+zlXSnCas7Zn0F4e+e8J4re15pl9BzdLO4y0l38mWMgw7EdG2EQI6fMU6oLEE+P/BpTvMeT4Sv0YLR0Kckqc/gs5ETUkrEgOw6Ycwe3qUJZAxJw3bn1WRUfOhLy4tO89KjztlozP/voTepMYFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741708938; c=relaxed/simple;
	bh=iSndnrRuvSztp9/zLO4ApIO6jQ6wfNBaqHIcwuRFSPY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XmQmL0SKyX+e8xBWQtUfPZw+o2tj7l8tYYVtNfsqLVxRJE4/ccoTY+sqRRH97Jxf0Ql4Undsv7uog2akSQ7BuYZiMJCqVfoRoqkLQJb88pjc8rn3GrAbvWJaXKKWwZ4TN1zvFD++GoMYoie7IVpF1xZOJ5+Q3pyG5fSPWwp6svg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1J+yBYLA; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndkhV1z5s58He7Zg3TBHW9Z06NzHTInJXOfwVw5weFw+wl1xbjOV0JvkicLI13tU3ltSvwzxI2l008u4iPCLAGf9geVDkUKhXMiRo4twO1I+PInBd2cGyiImNjhV4O9Be/RBEbU7DFG5bj+7fFJx7pOfNT4k4qzpRTQo6/6vk/TPFMM5cJmpJlUZp5IkNzKruTDI3XY4YAL8I/AMeT/St9385GnmRGjMFB8PX9kXkyKAzx2US/4cNp7qHU9slwY6KezAt28/D+NvpXVFeEQb9wufyI+jNq7REXk6ZiDEGi8giQejDNxthvctnDzxHEhv8jNVNdfNdEWS5158vtmuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gEuX2VPI9CBlgNxHKjuQSoA2pk8h54g1cDbuVnYM5h4=;
 b=uMKKC+O5k6eutqGUQj6/sBencd1diLoODc7EOA3R0IAFaSVVLuDFoI8fp+8Kw9LGiSiD+EOIRFZuXd0YownYMBX2zQ2nj089imiY2fHaF8NMtJ8wiGubyUS5L4wWajJDwA8VrPIHz3DbjFs95gNOED35Ff7SFlZwXL5/5rsdvVEFCdqmbrMnWc7P9HW+TTKHDBPNni0FGuLMT2n+v0CwbiuVRO73FIPRiU1CnS6x/OdeoaA2WXbiSTuxqNKHTqvHG4wQIOkPDuzkmdkPJXmEGus/EMfMCoAhYHOfqE2UajP3s12aLKYfoy/+C4OFU/icIJ63nV8vyawn0WX4/Pk6Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gEuX2VPI9CBlgNxHKjuQSoA2pk8h54g1cDbuVnYM5h4=;
 b=1J+yBYLA/pX2OS0o2H8LBEWHy+LuZqMC6xo4Tpw/ru17oYPHZhLyCvNkXgzmRd303FfxyJgbRhRyYXA+BXl25QUbwOnaaQCKzqAGeB6DvfJtHlVrkF5+6kVKebJJN29TmxqGjS2EXloZQW3r9Ji94oD+a/TEMhgSBuwFbh4r4ZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by DS0PR12MB8072.namprd12.prod.outlook.com (2603:10b6:8:dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 16:02:12 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 16:02:12 +0000
Message-ID: <dd48e6ea-3f85-474b-8c08-7faad7c07e51@amd.com>
Date: Tue, 11 Mar 2025 21:32:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, santosh.shukla@amd.com, bp@alien8.de,
 isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com>
 <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com>
 <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
 <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com> <Z9BOEtM6bm-ng68c@google.com>
 <73c6c8ea-93a0-4e2b-b5fe-74ea972b1a2c@amd.com> <Z9Bcceu2755QY7cS@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Z9Bcceu2755QY7cS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|DS0PR12MB8072:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d602e9d-548a-4d0b-5efe-08dd60b61595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWlMM0tvWlhzV0QvZ1Z5NW43WkFGWVRoekFEdktXeEZCZll2dTFZdTQrS2VT?=
 =?utf-8?B?eEhYcFhHVSs5bXlWVXE4dEE3ZjJVUk01WU82NEE5Ump1T3hXTVU2S0NRRzZR?=
 =?utf-8?B?K3YxRDlNNC8wUzZMSncvTVJsNVRwM2JaSFYxM0V1Vjl6WEpjWVNLcVZOcnZZ?=
 =?utf-8?B?cnI5MVBoRlc2YU1HbHpZNnpFU0dQSkg1eVFXckpDNU9xWG9XTHlkWCtQVUx0?=
 =?utf-8?B?TmdIUTBRMFYwcDRlWUVvZ3ZLNEpzN2pzZEljdVZ4RVMvQTV2dWFieVVnaitU?=
 =?utf-8?B?Rmt4QnZQaEw1K2h2R2F1Z3daaUhrYmxMVm9tTUYwQ0pWREtjcjlhWUg3a0VS?=
 =?utf-8?B?aHB4V0gxMys4bkJqa3FxUGs2T3FmR3ZhWWY4NU4wdFBlK1l6MTI1V21kMUc4?=
 =?utf-8?B?THRnZnJWbnJ4ZllGaldLUDc4YXNkdjlBTkNxbUUzaGxUOXJ0NE5RQ3BYa1dw?=
 =?utf-8?B?RjEzM3ZLanV6L21rUmRocFRRM1JzYnFHOEF0RHNDbjJGNVdjZVdEU0V5S3M0?=
 =?utf-8?B?SkRJUlVwOTdTNGQxUkV5WldaRFl5c2VQVUQzMHpEUXkxZnFXbEk4Yk5jZ2hz?=
 =?utf-8?B?OElybGM4dHBObGFvUlZTZHdmd2FYemZ6YytvRXJqYnArclcvOFhuWERFQWRV?=
 =?utf-8?B?MWgxRHFHNFdZWWF4dmJ6WUtkWE11Y01xWjB4aTJHdmxlRVcrakdSVThaUllK?=
 =?utf-8?B?d3F2SU5HeXFISkV0eTIwWTRMK2F2ai9BcXRJeitQdGhLTkQxOUNpbGtUdERY?=
 =?utf-8?B?YTY2blhXaUZvbTNjTmxpc0NmN0FWVW9kdnlxOEdTdDR1d2tSTjF4VE1GRU96?=
 =?utf-8?B?elVMOVhVVDR0VVdWaXZtZ2xabXV0MkE4Y3NGUjFFYlNFZ2JvUjVGQU5DUkJG?=
 =?utf-8?B?V2djRnpaTXZwZWRkN0UwNFZWVlZvbzZIV0dFRUpkcGRzSThqdm9EK3g4QzJq?=
 =?utf-8?B?TmgvdzZ0MnFMUXc1VjA3b1VnZ2hPalkwWW5sSitNTFRVUHFCdEx2TVI3WFhK?=
 =?utf-8?B?b0s5ajZsT1NYQ1dGTGw2MWVBQmtjdDBlLzUyMEtpUFhVZHlEWXFXc3dNWlJm?=
 =?utf-8?B?Y2R2Q0ZwSjZLdDVsOUJGK0N0ZzVlb0xkV2NrZ2dWUGE2Sm9RMUREd3QvVHdk?=
 =?utf-8?B?TnBnVER3eGswZzlpYmVIekp6NzlLMjA5WFhOb3kzY1J3WVRTTlV4eGZUWUdx?=
 =?utf-8?B?Y3d0am91UWxtZFdNUmxyVU5aZkYxUHBsS3BwdXpnZ0ZTVld5aStVSXk0VGcx?=
 =?utf-8?B?Uld4bFpWT1JreW1sM1kvUXJSMlZCVkR0cEphOXRVUWZBem11MU5ZdGx5ZUZs?=
 =?utf-8?B?RFM5RzJKWjlpNlJkNjZvcUZ0OUZsMjNZSWQ4MU1pMlNzTHowZUE0SnFaMGV3?=
 =?utf-8?B?Vk5tcHNVVGZPbm1ENWtLZi9iNi95bHpJRnVnU3A5MlpKcHF5ZmMrTkpIN3hj?=
 =?utf-8?B?MGcwcTd0SGd4cEpRa3hQOEJpMksvanRwQ25mNDhZU2RxQWE4OUgyc3RsLzcx?=
 =?utf-8?B?bXJiZDk3eUhIUWtsaitET2FNZkxiTlVuRHhOalhyazU3UEdlZkhCcUhKdjJQ?=
 =?utf-8?B?Yzlza05iT3JMTHNGbS9xdmdySzYrN2E0dFU3M0R2WTFpVEFEU3Q4Z25XakxX?=
 =?utf-8?B?L0Z5aFRFOUVhclNkdHY1K05sd1QxZnBZd0JndlNCNUlmU1BiODJlK3RJL1VR?=
 =?utf-8?B?dGtvdDVxWXdZbGZqNEZFRDZHclFFK1R1bFNwQXFoc29hTFlXZHJMVnVuV2VO?=
 =?utf-8?B?VWpFWS9URzVtMXQzWDRBS2laejZ1SHlaamZOQWxYRWZvMG5yYi9YSW5Yd2xv?=
 =?utf-8?B?WkxRdWQwZ1RWa1ZvVE8yTkhOR1A1MEcrZ294SWQ2WkdSc2lhaXhxSkhvYml0?=
 =?utf-8?Q?VJHfCXWjtkgRZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0V5VE1PeTFDanNKUzNocGZ3MmkrdzFFQnJLOE1paDgwSkt6aXgzWGYzZXE5?=
 =?utf-8?B?UUk5ZitGeUQ1dTlnc05xR2phV1N5WTdYVGxGVmYreCtpdG1CVXNmbkNnKzdY?=
 =?utf-8?B?SVdOUFJaN2svSmpHMzVNRHJjUUR1MUJYemd5d1lJZkJJNFNDdnNJS0JzbjFU?=
 =?utf-8?B?YVdRMWtZUGg1OG8yMFlFMGR6YitKTmdyd0h1MFFyZmszK3EyRnkwa0JSZUpJ?=
 =?utf-8?B?aUphTzUxdm8rekRSZE9CZ3RMMXo1L1pFb0hialJiT1VFdGlHUjRNTmJtaUJw?=
 =?utf-8?B?bWVxcENyMUdQMHB0MkVOa1p6T3gzRVFRdjJVbHpzUHBSejdQWWNiUXlzVDZL?=
 =?utf-8?B?REFQc1I0YmQzZzErNTQvZWw2ZFF5R0JvWVJJYjludnBQZGdaYVBIL2p3WHNm?=
 =?utf-8?B?TDRycjdLOS9ZNTdUa2pjd3o2eWI0aUJFc3EyTE9yV25OTUpwb0xpY2FOUGFP?=
 =?utf-8?B?M044OWQ3NUpLTWNmVExkL3NWUHorQUlRU09jbENLRGU0aDdOYXB4N2dsMkU3?=
 =?utf-8?B?TmwxVzNNSC9yWnIyb3RtMWxxQ1RDR2JHTjFIV04zUDZCMUF3NStOdzJNc2w1?=
 =?utf-8?B?RVlidlZ6OU9rQUJnelNJOGpiaE0yYmk0b0VsdEJwRk9ZTVpqRGJhTzduSk1q?=
 =?utf-8?B?bTNVOVNSWEx4MmVJWkZBRE8rUk00ckQ0RDA0UmhYZ1FMZkc0UDZsR1VTMHFZ?=
 =?utf-8?B?aGEvWFdZTjdRRXBWUTFLRHFOWmE3c2JaaXBOOWppeENzTjRFZGtIekY2Lzdu?=
 =?utf-8?B?Szg4dk1YWHJYTzlBWDZLOTNJV1dObUxnVzkwZ0FuNVZQQ2o5ZjFBTjNJdUpD?=
 =?utf-8?B?cG0zUXM2dkhqSmN1elY1OXJOMGJGbG5DWkQrQ0JKRFNJVjlwanJGV3VJd2xy?=
 =?utf-8?B?K3dnRm05QlRzRnNJa0lVTUYvcWxvMWNNR1AwTFpyVzhoK3oxNTFvdVhUNmMy?=
 =?utf-8?B?RWlRNFRFSEVMdDY1eVlwemNvaWZ3U2t6VWU4NVJjcFdoT2dBY09xWUJjWlRN?=
 =?utf-8?B?U0dMNmluMStkOVdzWXhCQjRTTTFoTDNpMU9BNDVGcjkvT0hxMmxUREdmdzk5?=
 =?utf-8?B?eTFXdkQ5MmpzMTZwVlUyQm1Say9uRFA3RmtxZ2NMc1Blc1hWS20rNXdUSTds?=
 =?utf-8?B?b0k4QjhuU0R4SVl4UzZpaXFGci9SVkVwQUpWcTJESEwwVENucjFvdDg4ODJN?=
 =?utf-8?B?a0Juc1E2cGcvS0R1RFg5cVRDTnprTURYRnNqejVaOXZhVU5CWTY2eEtUd2FF?=
 =?utf-8?B?bkF6Ymd5d0NoZWZHVnpBRUo5eUtIcFVQNTRLcUwrUklKNE5qTkpyUHBLV1hG?=
 =?utf-8?B?WG10bkIrTzJWRFJHc2ZmSldBdDF4Z0hoN0hhK1FEVXJ6Tlg5VG1pWFBxVVU5?=
 =?utf-8?B?NUxNZjVBeVJQTkM3d3h4aHB0NkRlQ3VsYzZzdHh0NlZiT2NRdERHaGlJa1RE?=
 =?utf-8?B?dkt4T1p6eS8zK1NPNVpSZU1ldkp2WGg5R0wvWWRSQ1dpUGl5anhmOUNaOTBv?=
 =?utf-8?B?N0kwNTZ5NDFUUjFFMjJFcWIwMjFjaXdGbVB0UVFKWVpodGEvZVpGdFVrSkZN?=
 =?utf-8?B?bXVVK0x6eXhQSmlXWFd5bzNsdUtDcG9rdlJ4U0tUOG5kUWhLUkVMV0FiNkVO?=
 =?utf-8?B?dy9SK20zR3lxalZyek10anlTY29PSUtKQnlnbGFFVWVuZ252VWZ6blhEWmNi?=
 =?utf-8?B?WDZyaFk2aEZrSVZkaml1VHpZSE5SaEdVS1l3UEJqV1NMLzZ4MWo0aDFEVDZY?=
 =?utf-8?B?cTM3bjNtN1lWWGhnYlAwUTVhU1FEQit1NlBjd05mUi9tTDgxR0VYV1VCVGZP?=
 =?utf-8?B?N0lYVWVuWkw4Y21obDZiSDBEbUh0Y3ZuZW04ejlHWmgzdms3NzNVZlQrTVJx?=
 =?utf-8?B?VEd1VVQzZkJ1M20zZmFsTnQwb3JqS0ZHenJ2dVZRK1RtcnFydWZBR2J4VnNt?=
 =?utf-8?B?MURhOXM2bzF4MmJab2ZxZGIxenZrbHdLREg4cndoYlNNc2p3N1pnYXhjclU4?=
 =?utf-8?B?TnQzTGQ1UkR2UzFOeFdvN3ZGMlN6a1VJVDdCM1ZRaFFCV3VQeTlvb0dod3dk?=
 =?utf-8?B?M2dtWHF1UjByYTI3cEUzWU1pMW1xUDY5ek42ZXl3UjY3b1VDRHBORXVEODhj?=
 =?utf-8?Q?HU/f7evouulSkpenswYC5bvvC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d602e9d-548a-4d0b-5efe-08dd60b61595
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 16:02:12.1881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvjKDBmDAwuJg0pwaoju1ENlDC95WevXHR4+c6QcB4Ymwhae3S0mNf9hRHQbimufI/uVRfQeY5TFh5FT1aggGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8072



On 3/11/2025 9:23 PM, Sean Christopherson wrote:
> On Tue, Mar 11, 2025, Nikunj A. Dadhania wrote:
>>
>>
>> On 3/11/2025 8:22 PM, Sean Christopherson wrote:
>>> On Tue, Mar 11, 2025, Tom Lendacky wrote:
>>>> On 3/11/25 06:05, Nikunj A. Dadhania wrote:
>>>>> On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
>>>>>> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
>>>>>>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
>>>>>>
>>>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>>>> index 50263b473f95..b61d6bd75b37 100644
>>>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>>>>>  
>>>>>>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>>>>>>  	start.policy = params.policy;
>>>>>>>> +
>>>>>>>> +	if (snp_secure_tsc_enabled(kvm)) {
>>>>>>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
>>>>>>>> +
>>>>>>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
>>>>>>>> +		if (!user_tsc_khz)
>>>>>>>> +			user_tsc_khz = tsc_khz;
>>>>>>>> +
>>>>>>>> +		start.desired_tsc_khz = user_tsc_khz;
>>>
>>> The code just below this clobbers kvm->arch.default_tsc_khz, which could already
>>> have been set by userspace.  Why?  Either require params.desired_tsc_khz to match
>>> kvm->arch.default_tsc_khz, or have KVM's ABI be that KVM stuffs desired_tsc_khz
>>> based on kvm->arch.default_tsc_khz.  I don't see any reason to add yet another
>>> way to control TSC.
>>
>> Setting of the desired TSC frequency needs to be done during SNP_LAUNCH_START,
>> while parsing of the tsc-frequency happens as part of the cpu common class, 
>> and kvm->arch.default_tsc_khz is set pretty late.
> 
> That's a QEMU problem, not a KVM problem, no?

Yes.

I had missed that KVM_CAP_SET_TSC_KHZ can be a VM ioctl as well when
KVM_CAP_VM_TSC_CONTROL is set. Let me use this interface to set the TSC frequency 
and then during SNP_LAUNCH_START use kvm->arch.default_tsc_khz when using SecureTSC.

Does that sound ok?

Regards,
Nikunj


