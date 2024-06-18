Return-Path: <kvm+bounces-19892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2230790DE62
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E4181F218A6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516AC17D89F;
	Tue, 18 Jun 2024 21:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KQ3WluGD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5764017B40F;
	Tue, 18 Jun 2024 21:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718746069; cv=fail; b=MIv+5oK2FMhAKn9Q1+UnWWfpJGmQT5sXXk2fmS9ct8nt9VcsycnmRgTFf7Nm4+6ViOKA36mEBrW2ZmW1RZjJHObWlvRH1eDBX9Y6mLS06EEj0KNHFDEJghqkSDKMh+4eegAuF2s5Z0OFlE+ieq9uBc9zYIE0DsIUucSVlH7IQqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718746069; c=relaxed/simple;
	bh=fbps0/3IQ0WUSGHruIbdC7MQcrZKdLb9i0EnhGsKAHg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=PlXpTCtmfihSTwMlondxmIYKnj6+SEwj8iGjiccLyoyerHcKbSvFf1sWzKqBl8YFh7PGxebA7UMwtmaaPFfSaLHCFA+sIDf9UpQI8eW+ZLQHfidpeL/amh/PGhH/jCLk5GogA13A2b7UNWo0dZVVlhbsWat7DNmhJzFnKkRKqEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KQ3WluGD; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBV9cQJga98vyPQaB+C3/+NLFvLt0xwQp+GG0Ruy5DtTQarTPNNIHDQb7A2F/+25JCqIBNja5poxn/8VAABlScZsaXyjbHvrJ+ICEGum5HzoYNcGkEwD78yQssxITom28S8HSHvqOWsFb0DkuOdHXI6RdAMc+Bkl/j52WmW1jjss5WKjPghBTYV8qutPzSHcmd90dx3xFBlRXS+dSod9crEyxZ/gg4qdjKQxFs8//JlKorsIs8T/ksnUiyP6kGJaPAM13v6n3wOYLl6S2/waa27c5gS1zatxWXMuQNI8gOpJbYu5KsC/bJWVWNWeBNsK2pc1YV0XyWV+KqxAbmiVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axTb7u52WvSlwn8H5ol2SVkrZYPRFVXy0FkWz0zxO6o=;
 b=mZCZIafxW1WHBVTEAcdyz4diGZdlKZKUk5VDNXGbq+OGTzAdUTKLj7WlKhIdoAl14CTzQdwPQAgYHAZZhduvj+cJiQZooHR0tr+Q8+Y3PZrFVUVZS0JhzbMAnuzKHIL9/26C6oefgtYX4xOIU1r5wksn1k6vU9Bgcm6HaMXVVVavTwOSOrl8yZyWikRJfNb6GJ1FvS+qmP9M5dQS9Oqs+sxlFF6oPbs5p0SPmN+S4blKCiYTSRdwcTc0u7C4LDR9QO3+rYNmgOaZ/EBbeEgytkTSJRuFnsa8mWCWsgEueqZjvx6457ALyk/8HzNlnmHUms8R0U3cuZ5ddgATkkzTSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=axTb7u52WvSlwn8H5ol2SVkrZYPRFVXy0FkWz0zxO6o=;
 b=KQ3WluGDww6DY9qMQ/GLdW8yZaZLCMflu9MtxBQU/5GfI9c8KjKRmaJK5NFEPsYAtqwQfVrN7NIjt5LC2tOlshpy/tEwgqRf7j9g1AbO+i3YDCHYu4wlKTzqV9cBIO/bGSnNYL8FmgIrIy0LwosvpmHYJNm2ByczXWBKV3SUtVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA1PR12MB7245.namprd12.prod.outlook.com (2603:10b6:806:2bf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 21:27:42 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 21:27:41 +0000
Message-ID: <64164798-3055-c745-0bc1-bbecc1dd0421@amd.com>
Date: Tue, 18 Jun 2024 16:27:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-7-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v9 06/24] virt: sev-guest: Simplify VMPCK and sequence
 number assignments
In-Reply-To: <20240531043038.3370793-7-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:806:20::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA1PR12MB7245:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d091780-9d41-48d7-c32c-08dc8fdd7c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|7416011|376011|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WThhbkZrWEpQbUtlNUhqSVMzcDJCZkQwbnREb0tXMFhpdmZzUk1xWXBQa0xY?=
 =?utf-8?B?YjNEL3ZGTERFekx6Z2hIV3ZPQXZBZlVHcHZyNWdKOEFQaUhyTnVDb0V6WlF3?=
 =?utf-8?B?eGRLNUxhSmR3QllpRE9jRFJpVTQwZ1FVSk1nNFVDSXVWYmhkdlRpT3p5NWRz?=
 =?utf-8?B?d0l1cjFHLy93Q1hzUnF1RXBLNWpyZzZZTXlLQjgrbXNsdW5uNHloSmJueUt5?=
 =?utf-8?B?QlpZSlUrM1lLVjR6UzkzQzgzZ3FlUlkzREErU0VUUU9XMVUxNFczSUhIUnNx?=
 =?utf-8?B?emJZSitGcWVWYm9ubkovUjNEdUtnT3IrY1gyd3RTWmJITzVWUnN5YkhwVy8y?=
 =?utf-8?B?c3dJWGdjSDJ0S1ZIZU1BMkYwaXZpbDM3VTV4b3pXb0RIM0tDR3JtTzAxN0Zu?=
 =?utf-8?B?UGxhNXNCOFJEVWppK1c1NWtRbjNJUUFId1JTMjh4WUNqaWIwQkNqMGYyRlVJ?=
 =?utf-8?B?QWc2WjhxT0NEZ2RNL3hYNjhMdVZGKzcrdW13Umlrb090Z05pWUQwUnRTS1FX?=
 =?utf-8?B?TXNuUmZLRmpwS2xrVDZWSU5qTE5pckVPcnZYbVdOM0paaGlFNzBVZy9lZmhw?=
 =?utf-8?B?cXNTZjJHbEExTnZqYnFxdVJHTExqK1JMSWJURjkvVWtYTTVXdEhlSFFOVFBa?=
 =?utf-8?B?dXNwbmYreFZRS3RTT1NqNHlISGxBYUNCeEI0VThnOS9oamlQY0xxb2JFbkF3?=
 =?utf-8?B?dEx0TklxK3VVMlVwRHc4NVdYR2JTVTdkR0tROENPRkZ4UXpjQkFhNDhuRzRz?=
 =?utf-8?B?SzhiWHNobEJoZHU3RGdrcE5UWW9MN0RKUUJ3TVZzYTZaN0VJTGhLbFNmQlZr?=
 =?utf-8?B?Uy9WRXJhTVFHQXU3dGMxZnFOMWhkbVZhcmQ0YTlJS1FSWGozRGJ5cWc3NjFa?=
 =?utf-8?B?QXd6cGFtRnhYaDRxYzQxb1FnSDBoQU1HTTIzRTROa0tuMlRYSXBtOGlOWHlU?=
 =?utf-8?B?MjlESTRySHlZTnNmRFlCL1NGdFoxbWMrbGorRFh5eGtlVXFCVG8zMnJIbzVM?=
 =?utf-8?B?eFJSM2dWZE83bHpqUVM4bkhMdjVDQ0twNVZpSnp6L3JjUjQyYTM0eW4vOElM?=
 =?utf-8?B?amR4Q01MYVB1RjNHKzlmV2ZqVEE5bkxRRUJMREJOZm9IWTRxN1VpTGVweUxY?=
 =?utf-8?B?bFBnYWRmbWJ2blh1NU9zaVllNHFwbTYvdFpmL3lhWEV4TGFMQlkrYzBhcVA3?=
 =?utf-8?B?VDZ1NnhVUHU2cUVWanpPdjRTWG53bHN5SWlsTitjamh0WHRtM0prNzhLbTNs?=
 =?utf-8?B?Wk5FK2l5R0ZvUWpjMDRpWDBKM0RyQldWZFBPMW5ybGxtZzU2cUhGaFpqcEpi?=
 =?utf-8?B?WFBvTlkxbGpWWU9RN0syclB3WXdFSmVWcEZuM1lGOGlVYTVXcWFVMzZrUW9y?=
 =?utf-8?B?Z0x5U1hqRGw1bDZZbk1Salc4NE1LVkVacG0wWUs4OStKcFFaM3VGeUlwREpW?=
 =?utf-8?B?QS9BK2lSMlZHaWwzMldUV1hpcW5rZGFTTTVpUmpnWGt5bVdyZTFsS1ZDOHU2?=
 =?utf-8?B?QWJRcU16UFUxeTd0cUc1bEpHVDZ5Q0lRTGg4MXZYdEtGWFc4bzFXc2huTzhO?=
 =?utf-8?B?YTdZQTh5WTVUUyt1ajBFa1BxbzZWTnBWcWs4M2E3d0pHZEhQbVd0V1dmd0ph?=
 =?utf-8?B?UDh1b29jYlUyNUY1ZnlwNytGc2Z4QTQ2VU9wUXF1WExFR0tmcmhPdnNsYjUv?=
 =?utf-8?B?cWpuejhMRWUvTmh6ekp1QU51Y0cwQS9hR2dFMzB5OUFMVmY0ZnJMNURHaUNu?=
 =?utf-8?Q?3uQk1ixfwf8tRYQQ51bJTLPDmJkcXS2N9/P8DIx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(7416011)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NERWL1hwa0ROL29TNDRjdUgwa2tFSU1mRThvNVMyYm5URlJzUGQ0azI5eFRk?=
 =?utf-8?B?TVU0UDYxV1Jydm9DUmtPZjRkZmFrZUhtaXJaY25XRWdBdlNmQ2tZZTJRZ3FZ?=
 =?utf-8?B?WmwvTDhUY09BQmJ4YzFtK2FQVE9JRG1RNTB1cml0WjJ2QnhpWUhXaVRDNEFk?=
 =?utf-8?B?Y01rTVdldGNLMWNQcTR6SHlCVDB3Z3NmYzhxdTU1bVg1TGhsalJGRGxlNWFs?=
 =?utf-8?B?TjlzNHJ5bllYLzVmdVNnQmUvdlNJMHozZlQybCszcE5XL3RJdHZjQU9LWks2?=
 =?utf-8?B?Lzl1WG0vZXhmVHVJd2paOVpBTUt6UzF2NW9NRXpEMk9idmltMTZLU1U0SUs1?=
 =?utf-8?B?OE1HZnpzeXhJUUxtejlZeDRKVy9jQWdTWkV2dG9lbHBlM2pHeWNOak5XbURh?=
 =?utf-8?B?VHp5QWNzbDZPeFJGNUxFU1AzbUtpdk1SMTc2c0p1T05JaUpuR25ZcHJCLzdp?=
 =?utf-8?B?RnhIUHFyUWVVdHljWHhjZ2tPZ2FGNFk4Q0lkazdxTzF2K1pKQnVwMkdNNmlS?=
 =?utf-8?B?N1hxOEdoeUlaMkRnM1Y2N1ZWUXBkUUdoZ3hPSktTbzVkYldjblhZUnptZDE5?=
 =?utf-8?B?ai9rWG5LUi90MlFSVWw2WTY0aWdKZ1UySXhreDdQR2JYUkJKUVdZZmpKZURt?=
 =?utf-8?B?T2s1RndxYm4xZEdrb1Fxb2RScVVBbFVNMUZuZkpRRDM5SzljREhjc2M4eXFV?=
 =?utf-8?B?MGVhQWM5Rk45eUhJVndKSmhsY1RiaXZRTnJ2aGNPREtJSXBEeldjZDRXWXl6?=
 =?utf-8?B?QzRQY3hCL1VOMEtoaEJjZlNXRGJQOFVHK1BTaFJ6WDNBaXQzbUkrOEphRWJa?=
 =?utf-8?B?YUJSNXhKSmdQemlPdm5PWVBySVNDM2VIRURJMmR5WHZSQTZmUWRBRE5xdHpz?=
 =?utf-8?B?ck5lVG1jRlFaVnB3NjA3NUJjMWRjaHdFNUswQitVbWRCb3hYdHg3WjE5Uy91?=
 =?utf-8?B?QlhsQkhrTmVhdnU0WmNsZ01XU29ueklhTTdoSkQrWnNTNjlVQXBURktNb0ky?=
 =?utf-8?B?VDhsd1p1b2RmWG1Ja0tJcTVyYWg0dGNJYlhXc015T05lRVU4aGZtTG5KNEdz?=
 =?utf-8?B?VDZmR29rb2xXRlF2b2QyNk9nSFIzSFBaS052SjEyaktWSXc3dnRQYVlNb3gw?=
 =?utf-8?B?c0VzV042azJFdHJzUTh5RDZGalljb0RSQmw1UWcwVVloVW5yaUh0ZFprZkVO?=
 =?utf-8?B?WmtxZ2xlanVHdmFGVThzcE1IMnNtd3hYem9SRXR6MWxhOTNFLzNBakx1dmdO?=
 =?utf-8?B?NmdnQlltLytiMEZrbjR3TVhDeDgzS1cwZnpHclBERUZiTWhqSytlbC9EUmND?=
 =?utf-8?B?Y0FEaE9WeEowVnRsN3Z2ZithWTlBNkVPUXVHWXNNcStUSFNZeExCWHNVNXFN?=
 =?utf-8?B?ODR6Q0p3eG83VDAvK2NhTCtiVndUeEFFdEd6Y2ZnSXZRUW1KaFhYS3RZaFJL?=
 =?utf-8?B?M2tUSEFJbFpzVGRtcXVsNFdVN3lnRjBpVDhyb29qbVlOUGVNTmZiWjl4RHJl?=
 =?utf-8?B?WkFWNEsxRStzOFdKT1RaWEpOU25SVHBVVzlELzFBK0pLbkQrY24rMGxzMnd0?=
 =?utf-8?B?YWJkWEI3akZrU1NGckZjcitOaWNRcVd5ZTdka2ZHVkluZFZvb3VOQ2FsakdS?=
 =?utf-8?B?TVdBeGZtUktkYm5HeXloNmYyNGlLMGY0ZVBYQUxjUlozTVRyQmQyR3BEVWk4?=
 =?utf-8?B?Z29WekZCdlJSenVTdExpMXZBbEliS1lMS0hXcWxoV0JLQVhWUnNITGd0SFdT?=
 =?utf-8?B?UU9CMk5GUGh0aDA1WTZaUEo0Q0FwUFIwWGViUEtYbkVub2V1R2Zid2UrQmpF?=
 =?utf-8?B?Vkp3STlOQ2NiZ2JuYlY3dEkrTnUvcXZxWm5oVTJvbG82MVEvL2h6cWlSZDQ1?=
 =?utf-8?B?NE0rZUdhZUo2VHN5NzlZK3Jla1Y3RFZwVDI1NXRNYWJtWTQwQkd6QTBPNUZF?=
 =?utf-8?B?REU4MWcwN01EUkQvRkFjZzFXcnVkQkpYNXM1R0tiVG9oakJSVEZzN0EzZ1Bq?=
 =?utf-8?B?YUc1bHVYdzlXNjNHbjY4TlpJVE9BZXNjdTZQcEEzL25sSGZkTFZTSEhaQTF0?=
 =?utf-8?B?RUMyZ0NoYzEzdjZKa28zcXZQZE1aR3dmRnVVdzk2RjdsM0NCb1R1MitFYUJa?=
 =?utf-8?Q?ZfjCKcisp8zEkWMHSDWqLH67R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d091780-9d41-48d7-c32c-08dc8fdd7c01
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 21:27:41.1891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EY/Z19oCGPCaPYp/EAYca0OqaxCqBygikuvJC6b/IE4uxwSpF037caeFexbvd7MkTfEcBbWVizUsgarhSV0Qcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7245

On 5/30/24 23:30, Nikunj A Dadhania wrote:
> Preparatory patch to remove direct usage of VMPCK and message sequence
> number in the SEV guest driver. Use arrays for the VM platform
> communication key and message sequence number to simplify the function and
> usage.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

One minor comment below, otherwise, for the general logic of using an array:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h              | 12 ++++-------
>  drivers/virt/coco/sev-guest/sev-guest.c | 27 ++++---------------------
>  2 files changed, 8 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index dbf17e66d52a..d06b08f7043c 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -118,6 +118,8 @@ struct sev_guest_platform_data {
>  	u64 secrets_gpa;
>  };
>  
> +#define VMPCK_MAX_NUM		4
> +
>  /*
>   * The secrets page contains 96-bytes of reserved field that can be used by
>   * the guest OS. The guest OS uses the area to save the message sequence
> @@ -126,10 +128,7 @@ struct sev_guest_platform_data {
>   * See the GHCB spec section Secret page layout for the format for this area.
>   */
>  struct secrets_os_area {
> -	u32 msg_seqno_0;
> -	u32 msg_seqno_1;
> -	u32 msg_seqno_2;
> -	u32 msg_seqno_3;
> +	u32 msg_seqno[VMPCK_MAX_NUM];
>  	u64 ap_jump_table_pa;
>  	u8 rsvd[40];
>  	u8 guest_usage[32];
> @@ -145,10 +144,7 @@ struct snp_secrets_page {
>  	u32 fms;
>  	u32 rsvd2;
>  	u8 gosvw[16];
> -	u8 vmpck0[VMPCK_KEY_LEN];
> -	u8 vmpck1[VMPCK_KEY_LEN];
> -	u8 vmpck2[VMPCK_KEY_LEN];
> -	u8 vmpck3[VMPCK_KEY_LEN];
> +	u8 vmpck[VMPCK_MAX_NUM][VMPCK_KEY_LEN];
>  	struct secrets_os_area os_area;
>  	u8 rsvd3[3840];
>  } __packed;
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 5c0cbdad9fa2..a3c0b22d2e14 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -668,30 +668,11 @@ static const struct file_operations snp_guest_fops = {
>  
>  static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
>  {
> -	u8 *key = NULL;
> -
> -	switch (id) {
> -	case 0:
> -		*seqno = &secrets->os_area.msg_seqno_0;
> -		key = secrets->vmpck0;
> -		break;
> -	case 1:
> -		*seqno = &secrets->os_area.msg_seqno_1;
> -		key = secrets->vmpck1;
> -		break;
> -	case 2:
> -		*seqno = &secrets->os_area.msg_seqno_2;
> -		key = secrets->vmpck2;
> -		break;
> -	case 3:
> -		*seqno = &secrets->os_area.msg_seqno_3;
> -		key = secrets->vmpck3;
> -		break;
> -	default:
> -		break;
> -	}
> +	if ((id + 1) > VMPCK_MAX_NUM)
> +		return NULL;

This looks a bit confusing to me, because of the way it has to be
written with the "+ 1". I wonder if something like the following would
read better:

	switch (id) {
	case 0 ... 3:
		*seqno = &secrets->os_area.msg_seqno[id];
		return secrets->vmpck[id];
	default:
		return NULL;
	}

Just my opinion, if others are fine with it, then that's fine.

Thanks,
Tom

>  
> -	return key;
> +	*seqno = &secrets->os_area.msg_seqno[id];
> +	return secrets->vmpck[id];
>  }
>  
>  struct snp_msg_report_resp_hdr {

