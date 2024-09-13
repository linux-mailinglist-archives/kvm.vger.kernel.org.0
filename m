Return-Path: <kvm+bounces-26843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD759786AD
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F2B2B23B49
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827A0839F4;
	Fri, 13 Sep 2024 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RsksWC6p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C8F8060A;
	Fri, 13 Sep 2024 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726248369; cv=fail; b=Il1qEoN3tZEWjKLS3DDgqamNFHeZRcH2/ekYBLpp1OVDME2ENGi3F/6CqEnrk9+VKW5/tCsHk2dyrPh4xvzEPAx11+ekzgaySsMwLw7UbS0hwbebR+EiaM1/tO6BLNtCdmegZCf2xKLmxCePpszYDo/NhxHtROApA0Z1LWNLxpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726248369; c=relaxed/simple;
	bh=RAyymMvOsm1D+qn5K+liVCxQ5SYRuiCgGETz/A+N5RI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=st3FN7sLib9hawsc4VjTwlgveMe6BA7Jwn9KcrP5pN/yinFyVvEPSh534HIUD82GMXUFEbJPgfXlz0hD1iqQ+UrZEIu5Cy60H7sSebKhVTS4JECvg5uP7h2JjXQF2f/S9L4aHnUUkxV+0DUUShruhv6buA8542EiDvkvZ2uDS4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RsksWC6p; arc=fail smtp.client-ip=40.107.244.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyGvYZy+XVwj1EZVRMbEk6sjiR7aaBh71Bg8G7mmkIh5w/mY69kOjlOKVHPN0jqnHRerpmFnQ7UL2IBvmIycfiakfSWsvLYP6AgctK54ken5YODYJXDJ9ww9PofFdKj1s0T1FmOUMZgZ50dWNhTDl7C6svAZrhDug3/yp1i5kkVFilToDZuTanrX/wkwTbSrOebIC2EH6wJkqYzCNTNooBaplNSGM6a58nyE8dzK9/KxvIKyLwnGI1XJuGADjeVb0DOeYA1ZTh3FrEZdhK2DPRto2kUtdpgqu9ic7ADyKt6xfw1MigQSAutwbFa8PCYcYhlWi7tg00oHuGHUlKsw7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGaimIOYRm0l3rhTSZ9hRAD+Vla4TuFb15ynj08/4d4=;
 b=rrOAtFdUswqfTPMnW72VCAmpvX55aUMuu560MjvRc8lIFW0p6owNuzi7aG8G0ehYmac8oVgFRw1l4XLKMYYdW5cVQkSRigXgIaz18FMRgQMD2G34PvSguEZkzCUl61cUTcERbLp0zV5vd+CtgVpNFjwwKuh7SE68oldkKAw26VJHZDUsu12p5stR9dA8iPcrLcxwE8q2kN1OAcgf6KxM37eq/QH3uuseZ4IciMqhNXflAmYm+Tk8tmMwMTsnz64JrlOlOgRpPWEesWsAAd0GntjKyf3OMBxskjqkNygfTdDqRaDcyfsgFnsvPbTmomrhuquLIO3r1D/vmtZppCNQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGaimIOYRm0l3rhTSZ9hRAD+Vla4TuFb15ynj08/4d4=;
 b=RsksWC6p3gOv79pkio+4ZhwL5n6pIWyjAlCeHQj0xs30n16W8vZPVUpuRO6opZpeP/1JfEZKTX5CpkCovKMA194n+axWS9toR8N5ljuCORIttLXDwPWHxndK1UHmYOdfaF/jKCvy83TTDgTRqTkG1GL7r9GywujGV44OPLT6tyE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA0PR12MB7074.namprd12.prod.outlook.com (2603:10b6:806:2d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 17:26:00 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 17:26:00 +0000
Message-ID: <7760b846-068e-a790-6d8f-fe13caefa794@amd.com>
Date: Fri, 13 Sep 2024 12:26:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 03/20] virt: sev-guest: Fix user-visible strings
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-4-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:806:28::8) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA0PR12MB7074:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9079ce-e6df-457f-d51e-08dcd41922ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDBhaUxDT3hic3V0TjR3U0RxRnRST20rcC8rT2Vkb1oyWFhlc0Y5ZmlQWVc0?=
 =?utf-8?B?RTlidUJtNHN4cEZrcVVRcm0wQU04T3BrcVVwRHV1UjEwaVNKUnM2d2Y0RFNs?=
 =?utf-8?B?SnppYTJMeFFmcHVpTEhUWXJMVHhNczlqQXJVYlZHQjdXbTBNSzQ3dTMzWUN2?=
 =?utf-8?B?a2RxdWhzUHppVlZJVm5vdWpxV2NFVW5qbDcwRDlIdDlUMUVCVmdETGFtbDJh?=
 =?utf-8?B?Ulowd0RvWWNTaGZBY3pycWhSWDJxT2crVGRrUW9PRHNUWk0xT0paNHJNd3pq?=
 =?utf-8?B?UHVuQVpqWXFDbGtCMUxvS1ozcWNwUXlRbEVMV3MwMlByUy96K1lQQnBtYndQ?=
 =?utf-8?B?YXpUWkw2anJZdmpqMTh1cThyUzl0V2RKK3ZoVENLSzNFM05ZUUxrTFAvQ3Jp?=
 =?utf-8?B?SWIvMHdCNlM5bVhPRjJBMThoZjRPS3ljekMwcnpBMmlOcldYNGJtYVBXT2VT?=
 =?utf-8?B?d3phRmNMQ0t4cUV6TEk2RVV0WVE5UEM4dk9MQXFQOVZKajFVdzh3bllOdzIy?=
 =?utf-8?B?ckRzY3BYS2NxQlZuZG5wYmlUUlZuZjgvREVCU0xDZDF4YjFzSElUWlFRMzFw?=
 =?utf-8?B?SUxSQWZQL01NZVJMYU5UL2hnUXlvaitQOHlNZEVyOXR5T0IvdmM4cnMrRWln?=
 =?utf-8?B?bTJJWkRqanFKK0owaWY2SldTVzJsRER5eUFZR0VQMjhRTXdCNjBBL2VGT2dU?=
 =?utf-8?B?TFBlMW1IbWdBa0kxL05LWEtGY0xaMlRhSW9tVEtrbFBmdno2ajlJVXh0MWc4?=
 =?utf-8?B?MHB4czVMYndFSTFlTlNoV3FkSmc4cnFlc3NtRWVzQUpVL0RaK0xIT3dlWHY5?=
 =?utf-8?B?dlFKZ3dRTTY2Z0ZkVlBPK0hsaXNDQlFrMmhMczBZeElwNUFRTWYxMGZIOWcx?=
 =?utf-8?B?STVuVnlUR2s3OUs4enUxZ0RGN0FwaU1GY1R3WEZuQ2dwZmpXRFExMWRzMXFK?=
 =?utf-8?B?ci9BdmJpS1NKRkt6QVVTNUJVaW03czdUQk83cTlOWTVLdjBVVk5JQTZOaE5F?=
 =?utf-8?B?MHdHS0hBV3hBcW9WRy9lekNJYmEyTE03VzNEcDdjalY0allxMEYwQ09PcnlQ?=
 =?utf-8?B?WHAzRmpEaFg1REsrL01VVnVXaXJRMGNWK1R6VEdpZkUwQTVPMVBsOHFCeklj?=
 =?utf-8?B?dDAzdTluQ1R2b1Fob3VDNEFWOEJmR1VYeFhnR2JkUkx0WVBabEdJZFQxK1ZK?=
 =?utf-8?B?bzFtTDJ3SU9YazJkNTBrVHE0aGlLT3MveldDYnkreU43cUxkb2xEOUVnWGJF?=
 =?utf-8?B?OGNESnVaT1g4UURVdjJHWmczQkVoVnNoN2k0Nit3VXVPWkJFTEFEaEVicXZN?=
 =?utf-8?B?RzJlU0xCMmRuQ0xha3REVlRlQWhRc3V6QnhkMmExWE5UV2luQllnUStVWnoz?=
 =?utf-8?B?S0duV1BBY21heHhTR1Rrc3dUd001b2JibU9qM21IM21oekdTSzVzM0c0TzdO?=
 =?utf-8?B?K0RpTXAxNndIejdiRW5BeGs2RExHbUJwaHd5QWlVTUV3c0hQWWVLZ0g3NjZ6?=
 =?utf-8?B?ZTZ0WnFqRk9MSGx0VUxjaldCQk5JVERJYjlxTDVsWVRnSVRiZmNPc2tPTFhL?=
 =?utf-8?B?RlFHUUdzcWZTQkpxbDhwNTlLUlFHcE1HVmdEU1p5UkxLSGpZVmxzaVRxdC9T?=
 =?utf-8?B?TUd4ODlOeGV5dENpRm5McFY1Rnpsd2NsUjlybUg3NThHTGZhMVJMN3pQZFVK?=
 =?utf-8?B?aFl3SmNEdlQrdXM0TW5kL3FvNFpzc04yY1BVSFZQdHF0elpFOE0wZ21PZDBq?=
 =?utf-8?B?UlBOR1dSekt2bXhKSmJKSGRHM2FpVDhXTEJ6aHY1QjBndXBWVTZKcCtHNGtH?=
 =?utf-8?B?YWtLc0RsWFcwV0l5YTBFdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0x6UmNoNnJrZGlZRTZub2FqaUY2NG5hNnpMRU8yU1dRLzhUR2NMTTFwM3lP?=
 =?utf-8?B?ZDNaRGpxK0JxNW1wNHc1SSsvNUp6bDZpZXZVQURMbDRlN05sdDFIbmd1cTVv?=
 =?utf-8?B?UWZ2WkRFMWVTRVBpRC9BN25walhaclQ1QjRtOGN5MzIwWXNPN2NhTDQ1bFJZ?=
 =?utf-8?B?SEVYN2l6bHZIUjRRejVJVENZQ3ZJY2NUdGI4KzFOa1BuYnQyRE1XREV0dk9N?=
 =?utf-8?B?dXhiUG5paVhJejJneVFyMG15ZzY3WDR2Q0RmUWJOckdEOXdWRkNBbDlwS01B?=
 =?utf-8?B?YW9UN2wzdTZKa1NqOVJmOXVVa2hqNk9nWm81eHc4NGMwdENCb3BWRk82SVlz?=
 =?utf-8?B?ZGV5NEJSYlJ2cWxPbDBlb1kzamZ5bDBSeFl2T09sdUFHbVo2NlE1S1RvbkhZ?=
 =?utf-8?B?U0VoUGF4S3NDS051TGtqZ09wZmN6QVF0QU1vajRpbUt3YmVia2tnRDNqVDE2?=
 =?utf-8?B?RC9HaXUyVFBBQkRMakozaVNHODdjd1haZlpPeFV3SzR6M1hTc3B5WnpCL3dl?=
 =?utf-8?B?UEduVEMvYVJJemhuNEUwcDcrUkFHcE4yZTQyQ3NnUlBERU5OcWVrYmFiK09J?=
 =?utf-8?B?ZzlLM2xMZy94NExBNDZDbEFMSlZUaVN5OEI3L3NBQWw1QW8ySGg1YlhNcjMw?=
 =?utf-8?B?UVdiNTc5ZnZ0bG9TbmVSVEFpN2xNZU53Q0hmN2s0MFEwY2tuR2VJcXhUTnpV?=
 =?utf-8?B?NHFKQlhiSzZhOFBtWUhzU3RKdk5DbXVRbmliUC90K0orRExwcVQyM3hFRmw4?=
 =?utf-8?B?NG9rVnU1YkZ3WW5BR1Axa2lrTXBqZVJUNEN6SGo2djBQMmlJQzJWWGp6bVVM?=
 =?utf-8?B?K0gwYUtnMm40OW5qbGd1eFVZOWN6YkZWQjU1WDRQQ2dwWHRrbzNxa0ozdWNl?=
 =?utf-8?B?S2pDa1MvS3U0alhMaTYvWjczRTlWMUhhQ1I5MGZTcCszMjdFZ2dqK2Q2a3Fq?=
 =?utf-8?B?S0M3RDIwbWVTUTBpOWFCdS9NMkwrc1hmVkd4bFVqdkNCZmpjNW5KdE8xMlRv?=
 =?utf-8?B?Wk8yWGVaWXFFdDV1ZXE4d1FxWnpLeG5Pd2VVMDk2cHRMM2RJci9mZHJFcVp5?=
 =?utf-8?B?QUkzdWN5S1RGVWRGa25GVm1CMFNHeUhJZDE0a1h3RjFMQWtUeXVSZW5qemg2?=
 =?utf-8?B?QjNJb2pSWVZsb2NMNVZQUDRqYjQvUFczbTZ6RkgyR0M1b2psSkxzbE1jN202?=
 =?utf-8?B?MTB1ZTdmbURid0ZoS1V5VFU5Y2VGU3kzdGdGSGs1S1dUcFJBbTdOWVFvb3Bu?=
 =?utf-8?B?YmtGbWsyMnYyU2FobENmNFQyckh2YTYreXQwajZ3R3kvWFFzQnY4ZmRpdnc2?=
 =?utf-8?B?bnVLeEF5Qy9QUXlLQTRmTk5xTGRrUGQrdndMcUR5WkUwVlpOUlowSWFSVER3?=
 =?utf-8?B?NzVwMzFRaVpkQThXU1ZBSkRXbEZCWjJlMEwxcVo2ZmhXVU1QOXAxemkzZFZC?=
 =?utf-8?B?amxYYVM5eDQ4TGcwUHBxS3lLR3AzZFA1RGdTZXZ4QlY1UWRxdFZkV1ZCK2V5?=
 =?utf-8?B?MzcrOEZxOHIzVXc0a21YTVhGVzlmZHA4b1ZIa0lOenZtSHdFTmRBVm1mRE5m?=
 =?utf-8?B?ZVVrbXNUTnpibFRjQ1VwM0I0VHdacmFZYWpmdEtDcFlBbWVGZ0pmblZKa0RC?=
 =?utf-8?B?ODhmTnZPbkRaNUk5QWNMQ1FRN3c5ZDFlRnBPS1d2eTUza3Nhb1pqY25DYWZH?=
 =?utf-8?B?RUlTeUQzbXFTSHhqZDhKNHVKa2pxQ2VUbnV5clFaVmVlSHUyTlJ2cWpUZzlt?=
 =?utf-8?B?QVlaTGYzQ0YzcmhNZWlzZlAzdmVLd0hqWEpubm45Y1orSHN5bWlMZ3lpM3FH?=
 =?utf-8?B?Y2loczc1dlJrSGJYVlgwbGkrcVY2ZHB3cWl0RUYyQ21qRnNxV2hiYnpJM3B3?=
 =?utf-8?B?bTQ0NG12dnV6SGo1SHJ1N3NTSnFEeDlBVDVobTljclAwVi9MUzl2ampKb0xM?=
 =?utf-8?B?Q3hEQzBpbDl4aytocjFLRkhPcG1BVlJRUWx3eGU0dEF2aXhtSDFhdXBPVG8w?=
 =?utf-8?B?MmdubFFOOStiQlBtbW9wVFNLeUtaMFNHcGZvZ25ncWJnRE9QTVc2WjV3TFJU?=
 =?utf-8?B?WVJhWW1FcVhrN09NUXFTdDFHbEdPMTRlTlo0V3BKREtnUFdHUjYxTVlNNUFi?=
 =?utf-8?Q?2D3bi2FG9c8own59kLN+qGsSz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9079ce-e6df-457f-d51e-08dcd41922ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 17:26:00.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDwCYtqggVfUJl+M39bs1ul934iJJ7V37NGsgBmff1XZtUteuKlIs1KDGSaTm00dAdXnTepxAMiaHuRUm1UHBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7074

On 7/31/24 10:07, Nikunj A Dadhania wrote:
> User-visible abbreviations should be in capitals, ensure messages are
> readable and clear.
> 
> No functional change.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

