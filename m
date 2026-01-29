Return-Path: <kvm+bounces-69599-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFzALPO1e2kNIAIAu9opvQ
	(envelope-from <kvm+bounces-69599-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:33:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2FCB404A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F301303DAB4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30123271EB;
	Thu, 29 Jan 2026 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L6abealG"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968232D0601;
	Thu, 29 Jan 2026 19:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715096; cv=fail; b=NiNmqjXCG41NyhrrT+SWTuDpeL7n+Sxrl+zpfIHEIL1xeOKr9SaUlmBXt/94zFmXGMuknvtswazhEUPSwJ2lk2oT7ZvHnacJphMnSwCV8xBAPXeMq2zTDPNyFUDnZQeFl5df17jYuQeAPiGorrXYg1nDoVlKp883gQE3GreaWbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715096; c=relaxed/simple;
	bh=69psov2bu8FwLTwF6tfhrQqun/LJ2mCPmmXVu76DaVM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lJkq7n8e1lL+iQhupfj5W10tOtpWZ1A2xLI/b7ou5IkJuupMSE8b/zRB7t6UEX/GsY3rm9FKQHh1d2l6Ahp/1NjoO0SSRipeN4ftqJhJ/VWHac0fUDM0QYhWNzkjmSn0n+7OaCAlvuUOjfVVMJP+nD5VMUklbHdny7bDxL+ZVYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L6abealG; arc=fail smtp.client-ip=52.101.56.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qAFRx74pTn5LJfx590kaDSuzol1pQS7AaLGufLNlxEFHxIycugj6cUNaieSFU7qvZzD4bWEyhrrWm7IsbYgGODlxRgbq9F89fPVBhXXbdyOWoZQYN/oQGxZhwVYeqihB6gs1+tWk0Bah9clk+H0Xc9WUrYFHtStYrmluoKKPDldvH1av3qQrun6IpPHuNm1o26WY/NhCmwa4s+g4/3LWjI2fCodb1SlgSUxC6x9PRg/+hSf8Ce8y6zNu6/eYHU79M2IOwDVjxtXxX1kEc3HfS2IJH6ubXwS6Y4zemMxNfqA+hgcHuRJg/QAn/O0MV8PRUr67nxcnWfL3shnBszL9sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QybeqSe28vhAS93MCYOQk+ADH2V22r0BC+tOXPrvZIA=;
 b=S4IOi2snV+R1H0iW3SyAZ6pZXg4qUzvAzu464vug2XPMKHws7AgglGFx5l4rAxRGgNrYAMXLI7eJavv7ggNu2/MbhLHH1Ox/Ea8/nJ2izT4ht8V34EurVN22LYwgbIp+8XWZ7LiQhIj6dQSaQiMOlu2svVdckBfOusy+p/V6tqcJlT+5Ciw27VxxT5rdecoKA7fBPF53RUoNTbCe0ctsABV+Q3SfmgP3OA4Omhe0HY77B3Hogs2ALWC1oVbYnYOJHQi+do3XtYIFGJiYKtJ1IHa7jN8K7DJEM0n4D9L/uZDHxP4Yt8pZyageSOUa+14ghlKy9IJD0tQo8MsyvmoOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QybeqSe28vhAS93MCYOQk+ADH2V22r0BC+tOXPrvZIA=;
 b=L6abealG0h+EtVvDaxuW19bLJ53g4MNd6xAaagGpRvSIZ0zGKocZDxHvQjAeGRQ/5QDvBTWt4EW9b7/l8Krwfo7wsVHY1UYRLF99yfuedENgiUR4W5vLnp2XJQISmBBb6l6cs9ke9gYY3bxvV/W/f0eiLQy4ER+jlhb9kzI3CXA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by IA1PR12MB6090.namprd12.prod.outlook.com
 (2603:10b6:208:3ee::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 19:31:30 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Thu, 29 Jan 2026
 19:31:29 +0000
Message-ID: <53abadfa-a429-401d-b9c8-71149b0b960d@amd.com>
Date: Thu, 29 Jan 2026 13:31:26 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
 <aXqHs0Mm5F9_R4Q6@agluck-desk3> <aXus-rG1BX8QWh_G@agluck-desk3>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <aXus-rG1BX8QWh_G@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:806:130::30) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|IA1PR12MB6090:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0a49f1-60c7-42e6-28d9-08de5f6d0073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkhkS2J6NXJZQUVwMHE4T0NseWZOenRYbmNwajJlZlJiRGYwOTJvSWxoUGFD?=
 =?utf-8?B?RmZJaXhZdkw2Zlh3Wm54VDVKc0E2WnVmVVMxWVB6RzVhZDJzTm5zWVBxU1J0?=
 =?utf-8?B?eUQzSGUzUFFxKzRiWUJUamJNZkZnZFB4cldIOXBMK2dCOE9wYkF3MHRkblVp?=
 =?utf-8?B?K2xIbGxGKzlndmNVTVhJL2tQc0tQMUpPQkJRVnllajlPY054eXVSQ3NOeTY4?=
 =?utf-8?B?d0kyRUxXd0lmb24xbFB3MFBMaHNnWU5Fdzc4Rmt4aTR3VWRuYWpCam1RWW9J?=
 =?utf-8?B?S1dRZ1pYajFNczUvckFKWks4Zmt5cXlrbllRbGNOTThaTExybEtHRW1MSDgw?=
 =?utf-8?B?TUNmOThndzMraHUvS3VQWVIzQ1gvbmJrRkZkWFdaV21OK1Jtd2s2VmtSOEZQ?=
 =?utf-8?B?VjNvdUpiZHhTNXhJMGR5NDg4eWRKN1ZSRGh1akhNTkNueUVEcVR4aG85SURJ?=
 =?utf-8?B?U0xyNHBIajdZTUJ2SjhPb1RZMlp6b1RadGExUzFkeVZ3eENBaU84c29KMUwz?=
 =?utf-8?B?eGIxbGVxelI3L0ZLbVIxRXB6KzRrUUYrRzBtdk5IeFQ0VUw4QllESEZhcC9M?=
 =?utf-8?B?VnV5UXg3NUh2cG91dmwrWEV2U1VhbmUrby8wcHVpMVNRd2dmd3dYVkE3Ympq?=
 =?utf-8?B?KzBXZ3k2UDlFdDBnMG15MUZWREs2ZXpBQytIRUl3R3RXRTRyTlEyczdnVWs4?=
 =?utf-8?B?VWlTaEhkR0NTdktITFlZVkkwZVZQZXV2UGdHVTQ0Sko3OEZJRFM2RDRmcnhw?=
 =?utf-8?B?QlRGakN0NU9ldXgzbTFKNTVYUU5WNEwyQ2tBK1hPUExHcC80TTl0VjlYVVdl?=
 =?utf-8?B?MTRudFcrL3BaNmtQb1B1RlJ1alMwWnQ3TE9sZDIxdXZuY3k0TlcyTzNCeXo0?=
 =?utf-8?B?dVhFOVQ2SU82RE9NOUpqWTNiT2JwSUtRbmFZVXJpbTgraEF5MS9vb3BjMXUr?=
 =?utf-8?B?WlB4TjRPdTJEM08rRmp1Q1ZVUktPMStYUFJxY0lIUWdJK2JaaS9IelVKWWJW?=
 =?utf-8?B?M2VSNmliQzVvdngzeWtIQ0VKeVliQllZMElaSXJaaW11SC9qOXY3R2xqRFBG?=
 =?utf-8?B?TDZrTTF1L2pnbWEyaXRpL3RrTGpqUXpkWHJqSnpvQ0RyYlZUUkVuSEhURmxG?=
 =?utf-8?B?UDNUMitudThCUGpsdUczTTN2K2VUQ0p6V1oxUWpUYms1NEdJYlRteVRIT1Nh?=
 =?utf-8?B?V0k1YTl6eFBxT0Q3aGhIUVlXdHlaeHg1T3V2QkpjMkp5UkJyc2lDWjRaQ3J4?=
 =?utf-8?B?NnFzK1JjV0JDeFN1UlUzUXAwNnV5WGdhZ3Y2RzNVZnBXbTVSZjFWb1oxL3NU?=
 =?utf-8?B?YnkyUE1LUHVkR1NYQmVzOWhMdnhrZ3B0dzlabHArSGRraEdZRU5QUVdISFhh?=
 =?utf-8?B?UUlBSFpZVGUzbmdCQkhMUk1ENlI2RE14SW5jYUF4UGtoVTMrSzZkOVVWalUy?=
 =?utf-8?B?YWo0SGtKT215TGthbWVxRjZNYWdtdkdaRUE4ZXVUNVJ1Z1U3MldKeVMyUGpT?=
 =?utf-8?B?RjhNZ0duNFd4azJmcWhOc1I1NTJsRS9XcWhHcVZwdWVxNWpQRENOUzhhUEJy?=
 =?utf-8?B?TnF2a1ZjcHk0U05VdE9ZZjg4Z09YQlVLdno4bHkvRU84czlUUXZncWVFNXlY?=
 =?utf-8?B?Rkp2UitPeUZSdkwxaVpxcjQrVEVQL1IzOXJIVVNtbitBQjJuNWc3ZzNXa2Nz?=
 =?utf-8?B?MzhVbm1MQUx1NlkrWUJxdllNWmh4WEVLMWYyOEM2R1h0cm5KWU1hR1dUMmo5?=
 =?utf-8?B?dkwwZHBnLzhtVVhSQVlzUFZMT1ZkcXp1RmMwVDBIL3hQUGNVUXdISnZVMnJM?=
 =?utf-8?B?cjIrN0F0aUVOOEdOOCt2cmRucXNlWnFLNGx6YzlSakFZS3FvNFdiRlJnK05n?=
 =?utf-8?B?NnJheGtxMWh1eURSN0Z1citSNGZ6eGtQYUZnTFA4Smphc2VkQmQ2K0ZhUDRE?=
 =?utf-8?B?aEk1RVhQb0s4bDZEckY2K2RHOWU0ak14aHpKYzI0UVBLWCsvckM1d0ZFbVBs?=
 =?utf-8?B?cWE1SjVJK0p6RWppblMwVk9mL2JvM25NWWk2MXNNaTF0bzJyZkY1NUhhMEFy?=
 =?utf-8?B?dWVZUStPMlgrc2VMQnlTYWlFd1pRbnlBL1V0SWw3OVZIZEJzWmxlRHFBTmVn?=
 =?utf-8?Q?hYac=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUJnYzNOSGE1T2cvUm9wNDhUQlQzdEowNWVVdXp3eUtxWUptNDllS1dCeWE2?=
 =?utf-8?B?c04xRC9NSVVEUHpYWVEvWjFGTkFMWFpyWVhtU0IwYW9yblptbTlOL0VtT3J2?=
 =?utf-8?B?cG80anlpTE01ZjVXSXVuakJ0dGtNM1JJdG9lTmxiYTIvRFdzWVIwVW95TjVM?=
 =?utf-8?B?TUwyOW90U2hnN1RvaWxKdmRWTzVKcEh4WGc3NDhoWk5DZlJaWjI3ZkplVXlV?=
 =?utf-8?B?dDF0dWN6MXN3a0t4UjdUai9LWkpmVGxHbXBaT3JYSTBJelRxekl0ZmUyVGV6?=
 =?utf-8?B?RFpCTS9Gem1YQTN3T25nZWN4R1BRRkhyeEp6c3J1MFZNWTU1alpkQ0hUUGdS?=
 =?utf-8?B?bHp1dmEwSEtPT3JzZWpNYWYxZ2RHV3VxUEUra3RaUC8wSk15OGVtVXBGZHZj?=
 =?utf-8?B?NEhWZENab0VzVUtLTnowa2dwNXd0YitCQS9HZEVPZnY1blZ0YkZhTGhUWkNW?=
 =?utf-8?B?VzM2c01NSitXZlVTaGRub0RERUxBMFpkNkw3RGpwdXpmaDlRbHZHeUFjenIz?=
 =?utf-8?B?N1lMd0ZEdk5BZTBDK0JNZ0h4ako4Q1lITW44UHNSMnY4QVl2SWdoWllMNkZl?=
 =?utf-8?B?NGxFRmxPTTZSQlh2VGh6TmRhNzF2TDJWUVh4ZHQyNXcvOHFOU0lLOG9Lc20y?=
 =?utf-8?B?bnhTYkJFNVFQemtZVHZrQ2pzRjZZcG10ZFR6K1AzaGdxVVN6bDdEMlZWcWEv?=
 =?utf-8?B?NE52WnpKU3A0TXg2M001RDM0SEpDblJpTjFUZ0lUaWFJY1BUdFU3YnZBa3ln?=
 =?utf-8?B?NE91clh3ZXg0YmIvZ1JOdS8yVjJ5L05FNlBQVThIM3Nkd0cwVjlmTy9wQlVz?=
 =?utf-8?B?VjhLcTJmdlVkV2hISWlXKzRVQ2VOaERETEJrOXlRdE9ZNy8wUkMyQndzOHU5?=
 =?utf-8?B?aVVtMEhWUEZ5Mm0wTTFMdHVVMGJKbi9TUE1NdGI0eXVQMHZ1WlZJSm1TbGxy?=
 =?utf-8?B?Ny9tUy8vL1h5dGsvWm1ZZDUyeSsxMldUZVpKYmswR1FEYTZ4S1dLWml4UGEr?=
 =?utf-8?B?Mi9acWpKSUpkblU1ME1RQTFrNWRnenRVenRzWXp4ZWxMamNabDRLYVdHUkhK?=
 =?utf-8?B?Vndtd0dwQzBsNWpYd2hlOTJSclYzaDF0bFozS1duKzJRb2dWU2cxR3lvUGdY?=
 =?utf-8?B?TUszUnA2clowZkdJRUIxYjdzYzBqbDl6NmFJbmVCc3ZpbXg4MDJlOWVVOHM1?=
 =?utf-8?B?YXAwYitMRFNoZjlRUDlyTnRQd0ZTN3hhdGlDYURzNlRnZmI0Yk5WWGxlNjFI?=
 =?utf-8?B?WlRoeS9GRkFPbXhFYlk2Njk5ZC9pZGgvY1pQRzZQYTJwVzNydTNoa1lpYUdK?=
 =?utf-8?B?aWZBOCtpZUYyS0h1ejR4aXNSbWRiUnQ0K2xMZW9DakRlYnFEOWNnaEF2a2Iv?=
 =?utf-8?B?NnJGWGlvcUkzL3BVMWw0cUlPQUw5Z0ZaZHY1RDhlQWZOdTBRcGZiZHZ6NXI1?=
 =?utf-8?B?N0Mrd0FLSVJZeTFybWpYWlZOQ0FIRFVERmQ3WmczUWQ2dGQxdUFPZWFPdXF5?=
 =?utf-8?B?a2FLOFkzelBUQmRPYmZLR2xGVHlrSFJrQ3VGYkV3bHVhckZrQXVBa2FGWE9o?=
 =?utf-8?B?M3g2Q0IybUNwVVNzNzI1Q1JmSkFCUFBvUVBNU0loZ2JPbGdPUk1sMnhwazhT?=
 =?utf-8?B?TzZQMDNHWjlaVWkwRnUvTVJoQ1hQT1RCMUZXMVA0dmF2cEliamNrbEdjOExm?=
 =?utf-8?B?RFpHZlV2WTZxNzdKRysrc3h0cEtpdi9DWW1HL3RjeHMzUEJ1MlVRTEs0bUs3?=
 =?utf-8?B?WlVYNVgrK200UE5uUHVFSWdGTC83bW42S1EwMUxaeERtZUNoVHlvenc3ajdT?=
 =?utf-8?B?TkFoMlJNV0o1L2dQQ0doUFlndjB1QmloWEZ1d05OTlp6Zm1OT3pET2QzcENm?=
 =?utf-8?B?M3FHbHR2UDNwQTdKdHhCT2Qwa3YrWWxUZGY5TncwbzZIUnJTZHltSjFCNjZw?=
 =?utf-8?B?a1ZhUjdCN1NtRlN6UERXSTkxQmE1bzlTcHBpVERtOWk5ODdOUnU2N3FaakNq?=
 =?utf-8?B?QUVoUUJQVDRzREFsY2FUU3FyektHamN5YnF1UjZsMTVzUEpDWVhXNzlDQlBz?=
 =?utf-8?B?WG1EWjFOR2JQakFNUFNGd1ZVY1dIV1RzcWlkWXZObmpvbGNrTzNkMlRLd0dD?=
 =?utf-8?B?bklBNXZrM05JTU5sR1lCN2x4RFRodmRIdzJ3a0tIVEVVQk9yVjRGZXR1ZzVI?=
 =?utf-8?B?YldzdFRkK0JjQUxJREM4c3hmWnVod3hFN3V6MXNNRVd2Qktvby9ndEdobFNS?=
 =?utf-8?B?VHluZGRScFlhTGkzcTJLTk5Za0NxTEdzNHVFRjRYSDJZY1dPeVM3SENlT0J5?=
 =?utf-8?Q?Xyw9LHPZH7uIkbX3iS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0a49f1-60c7-42e6-28d9-08de5f6d0073
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 19:31:29.8512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jVQpuu7PRiodymErFEGK875yPExZ5NFIR8ibrVXl7yMwzZt6Tlf4RiqjWbWHDgYe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6090
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69599-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 1D2FCB404A
X-Rspamd-Action: no action

Hi Tony,


On 1/29/26 12:54, Luck, Tony wrote:
> On Wed, Jan 28, 2026 at 02:03:31PM -0800, Luck, Tony wrote:
>> On Wed, Jan 21, 2026 at 03:12:54PM -0600, Babu Moger wrote:
>>> Introduce rdtgroup_plza_write() group which enables per group control of
>>> PLZA through the resctrl filesystem and ensure that enabling or disabling
>>> PLZA is propagated consistently across all CPUs belonging to the group.
>>>
>>> Enforce the capability checks, exclude default, pseudo-locked and CTRL_MON
>>> groups with sub monitors. Also, ensure that only one group can have PLZA
>>> enabled at a time.
>>>
>> ...
>>
>>> +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
>>> +				   size_t nbytes, loff_t off)
>>> +{
>>> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>>> +	struct rdtgroup *rdtgrp, *prgrp;
>>> +	int cpu, ret = 0;
>>> +	bool enable;
>> ...
>>
>>> +	/* Enable or disable PLZA state and update per CPU state if there is a change */
>>> +	if (enable != rdtgrp->plza) {
>>> +		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);
>> What is this for? If I've just created a group with no tasks, and empty
>> CPU mask ... it seems that this writes the MSR_IA32_PQR_PLZA_ASSOC on
>> every CPU in every domain.

Here is the reason.

Some fields of PQR_PLZA_ASSOC must be set to the same value for all HW 
threads in the QOS domain for consistent operation (Per-QosDomain).

  The user should use the following sequence to set these values to a 
consistent state.

 1.

    Set PQR_PLZA_ASSOC[PLZA_EN]=0 for all HW threads in the QOS Domain

 2.

    Set the COS_EN, COS, RMID_EN, and RMID fields of PQR_PLZA_ASSOC to
    the desired configuration on all HW threads in the QOS Domain

 3.

    Set PQR_PLZA_ASSOC[PLZA_EN]=1 for all HW threads in the QOS Domain
    where PLZA should be enabled.

      *

        The user should perform this as a read-modify-write to avoid
        changing the value of COS_EN, COS, RMID_EN, and RMID fields of
        PQR_PLZA_ASSOC.


Basically, we have to set all the fields to consistent state to setup 
the PLZA first.   Then setup PLZA_EN bit on each thread based on current 
association.

> I think I see now. There are THREE enable bits in your
> MSR_IA32_PQR_PLZA_ASSOC.
> One each for CLOSID and RMID, and an overall PLZA_EN in the high bit.
>
> At this step you setup the CLOSID/RMID with their enable bits, but
> leaving the PLZA_EN off.
>
> Is this a subtle optimzation for the context switch? Is the WRMSR
> faster if it only toggle PLZA_EN leaving all the other bits unchanged?


I really did not think of optimization here. Mostly followed the spec.


>
> This might not be working as expected. The context switch code does:
>
> 		wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
> 		      RMID_EN | state->plza_rmid,
> 		      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);
>
> This doesn't just clear the PLZA_EN bit, it zeroes the high dword of the MSR.
>
>> It also appears that marking a task as PLZA is permanent. Moving it to
>> another group doesn't unmark it. Is this intentional?
> Ditto assigning a CPU to the PLZA group. Once done it can't be undone
> (except by turing off PLZA?).
>
> -Tony
>
> [More comments about this coming against patch 16]
>

