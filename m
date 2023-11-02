Return-Path: <kvm+bounces-368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF357DEC76
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7181E281AA7
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B05846BF;
	Thu,  2 Nov 2023 05:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="woUiTk7W"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2341FDC
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:48:19 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFCC116;
	Wed,  1 Nov 2023 22:48:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Agh/Gfpzd70V/GMuT0EvPIrYWYIljN8SR4qqzGTcrUPlJgZAwKHmujoQBXDpxB12LLQ6zQ3mOFH8T8PA2K7j9caag5P2OmsZRtgCwEa2yzkAi3yQywDDQJ/aE6yhl/pSjAeN8vN+F1ZvxoshCnHcCBbogXTDWEHd3wv6RN2pOrWmVs1dwzhPPMTG/uAigHz/+0GYTRRz5FxQdIPGK/750bkcStd2Ay771FRYDYE7Pjavu0aSGGtXAeNP+5m0AtrQN4qweWksFGRj+ihMkgSO8eDg9vluJsv8a/jPQvNq70rK1w/jfgX74N93IjycMsKlleo75ve8wtNpKyi5xjJ2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Cna0tnAB/uS+4u1fvOdgSdcVdEMaHBEXWerrQ3ok8U=;
 b=fxgMOvHHe+8P9pK+CY1YFerPOgPx0+bMRSN9b2DMzD0S55dDP82V10zJmBzyj6Vx8tA4tFf7NJg71TuCkJHLGlmPxf+QvukpkHU4+KBvZUtxsDvjwlmG6Ms8npSK204E1e6nCqXPhz6j8HpCJ1eNoQtTgq3dnFY9TNxTM2dOgi+xS2vETwXnajomq+upahNpP/+p279gk+/5Cy4EGVmXcJLHb3kv928AZajLjbY9i99DViG0tdcOQ8pOJuPp5DVFvsbGYUfl2CLQIREBCYCEcMXRNSLQBj6X5slju1Z9fOuaqt8JES6b+8s9AhqtYeCMV2spiiXmYnhFVh7HVeL25g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Cna0tnAB/uS+4u1fvOdgSdcVdEMaHBEXWerrQ3ok8U=;
 b=woUiTk7WxnHB9mqfU/2qSD0VLum1dGrWtEOKCwVz4BlNB5RFs0f7JHGqOe1EcmFJ4g3HmsWshgylpnTloZKSOBXnGIQK/iWkzPsatM/Z/c7LvXk/lRA0xN3x/GkqQzohALeZUzfgpFRjISGpxvHSmQoXYgUVjR+bMnDhiccvJUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB5781.namprd12.prod.outlook.com (2603:10b6:510:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Thu, 2 Nov
 2023 05:48:07 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:48:07 +0000
Message-ID: <9acf1f56-f8d8-40e3-8fec-fa982db1a7a1@amd.com>
Date: Thu, 2 Nov 2023 11:17:55 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 11/14] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-12-nikunj@amd.com>
 <8bd907ec-3f91-2e3d-de7c-ef753a005ea7@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <8bd907ec-3f91-2e3d-de7c-ef753a005ea7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0013.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de6921a-8c06-43b2-7a11-08dbdb674932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cu4XTD3lCVLzLYb4BFOVDGRHaHSGtv+VJM7bdeSCFVTmR9DGYrrlRxROM4TAgM4NUHSYRQznl9kUso5/cGv2nx5ZXA1DAQeBpU3aWsjdYdvhfZLeR+ZDRl+W/2E9R9/Ms+4+im4aB3DgcOBk0HsXPM5DO3anXkOmpWlpsz5GRb2Nq+ape6hcdw/eHwrTi1qXOyYjDPhl0m7c4BKQHhchrGtl3y08/5yckGxlc6KgUdiVj1noLRAmq+ciOyFRu02qcMMUQtbPrZq8WrUzMQaRZtBxrUxetPanTci8nn2aBXXHe+0w5grOk9o+Khsff0QktnEkVmPNfLerEyp4ywXeeAMg636CIZ/zU72occMG2Izl57b2LuHzOpcJ9XR3nLiAyOgJgVaaGoc1vZ2OZQN1YUZUNoLhFfJ8IhZj7dadC4EsbnoKSMEgZx3CPAerKOxikbCHsLuXiWpH84m5h0k+cm/lK3EIngNfVOiA0CDpFeqgNz3H9+D7MW3Py2yEJQTQRdCtilLiE3jDsoGMgI+e7zhTW9R88DzaxSbTgGrAGEBo8og02fRVkvCWlU7fo8TzdvN3GjHVBMNt33hcIVfRfrJURXtucHmDayTuhyacsEnkylUqPrMsuXGoiRKRa2Qzcdce9ihmLHpBYsHiAyMCag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(396003)(39860400002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(31696002)(31686004)(6512007)(66946007)(66476007)(53546011)(6486002)(66556008)(26005)(8676002)(83380400001)(8936002)(36756003)(4326008)(6506007)(316002)(2616005)(478600001)(6666004)(5660300002)(7416002)(3450700001)(2906002)(41300700001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2IvUlFFNENJZENycWxHd1lwS3RPMDV6bWhkQzdzSGIzaEQ2b2x6VXBOYlpJ?=
 =?utf-8?B?WE5lQVh0ZXJpOG8vSC9IVk9laUNEbU1HQk5xQW9vWnQxNE4rcUpCZWRlSkJO?=
 =?utf-8?B?U05rcFZsOVl6RHQxQjl5WVFDSVJ5cE8vbTRMR21KWFFzYXpBUXZEdy9CeElh?=
 =?utf-8?B?WU1oeXNZUjhoeHJxMDl1djhSMDlRVjdKOVRUdnBiNlMvM1NwbWl1VWhjL1A3?=
 =?utf-8?B?MEZNakloemxGaEhQZndzcTM2ODV2STVhTnlrWlVrWWg4bEZ3QVJicVdPaUF2?=
 =?utf-8?B?bkZHVEhRdFo4WDlvTjJ6QVVLNHhVYXBZaUFBcHp3UVNwaXBHZkVDL2JiNVVK?=
 =?utf-8?B?M2NTTkg1V0R5SVNKaTNsKzlCZnNiQ2JwaGJ1ZzY0Z3JaVU5wY0lVYzEyUkhl?=
 =?utf-8?B?bnpSbFh5cGgvVzJ5aWlNQ0pnZngreXRMZnEwRW1SKytoNEJKR0UxaUZ1cVdx?=
 =?utf-8?B?YUtQMXErRmRXakFESU1Gbk8xdk54d2owdm5WaGJmVVR4QllKdmFQZW5YMmlo?=
 =?utf-8?B?SnVXa3J4eTBFdzNZOC9vbzhLV1ZUVitQSzBRWFdNMGVVOXptYzRZT0RiWUxC?=
 =?utf-8?B?Wk9HdlBOTU5oRmkxcFZ0ZjNJSGlvaUg1VkRJN0VKU2REOVJwbTdzd3Z0cW5D?=
 =?utf-8?B?Z25TbGdwWVNUQ0RBLys3TmcrZHdkbERRYjdha3FrSzF5WHY5Uk9VZGR5MmFO?=
 =?utf-8?B?WWdYUmY3emVqREZsNkhXZnFDNmpKcnpkcnI5MUF3MmRENDFEQ20vZFdSNG5S?=
 =?utf-8?B?QTErZWVSMG9BMXpvN3ROaitralB3TmFUMXcxYmF2dFJ5bDVab2pjVzVWQU9C?=
 =?utf-8?B?RjZTZFR0R1Q3aTNLSkdDSGo2TnhiNlBMNUgvU08xWHVuTDh4c0s1YTd2dHc1?=
 =?utf-8?B?MTJQc1Z3SUk3ZllNNHJUaTI0a2hLby9EWk9NMTJDV1JmN0xNM09NS0FMTnVK?=
 =?utf-8?B?M1YvdEltM3NSenZwWlIwaEJyVTIzbXM4SjV0aXRoNHp1ZU9GMG5YSUNEb3Qz?=
 =?utf-8?B?MnZFTkpWN3J3dEVZT09jUjBFUzRMdDJzVXJtNUM4Zlk5Szcya0MwK2tubWlD?=
 =?utf-8?B?dWt1TzBiN0oxYVJKYUFDeWtnVDIramE0UDM1cWJlMlZZQ3hLNnV3SGVweXNj?=
 =?utf-8?B?VmNDTEJRTEZZSFJUVElkY0hRZ3VicVRJa0VDNVllUXVSMHBpT0hsMFlmZVpu?=
 =?utf-8?B?U1BFRHVOaU1lQm45dHFHZmtZcTd6RTdHU29tUFUwcCs3NEtwM0hVaWtNeUZ6?=
 =?utf-8?B?MXBmdzVlYkNuY1ZDNGh2UFY5dkREeWhqYUNiSTNocjZDTTlzSlVMMXhQZ2s3?=
 =?utf-8?B?RUJKWk9IdHk4b3dOTmtXdFQybHMyeWJuYk80dHloclZSR011dVNtRU5GRmQr?=
 =?utf-8?B?RWYwZThxdzUwTWkwUUdwaGIvWTNlcmZMeFV6R1Axck5jYnhRN2wvc1NKNHJi?=
 =?utf-8?B?NUlxNVpLNFFWRi90OFZIeTUyblc3UDVtZE42YjBUWjdBeDM5aUNLY1BtdlhD?=
 =?utf-8?B?OXFsbkF3eXptbmNDdGM4Sk83U1lock03cmxCUUY5dE85aTVQSzh1ajhIUjRv?=
 =?utf-8?B?eU8yUlFMVzEySGZ4OXpJdElUZXhRRG9JZWFNRmNxT0tsd1NFcHRUMkVUSGlU?=
 =?utf-8?B?ZWwwOG16aitsUW44Z0hRazRsUURTOE5NZC8zTFRTQzdYeC9UaWtUcVRBejB6?=
 =?utf-8?B?dXZ6NUZkZ1ZXRU1Ba1FaY2JpLzlhcWVua3h1c3B6WklnS1BRRk4xMXhzSzJE?=
 =?utf-8?B?c01hVVhuK1A3ZHZoa0p3ZEtPY1dkL2tOazNXOEU0L3VuQnN5RDlVbGV3Wi9k?=
 =?utf-8?B?dDZ4Tm0xaUlOZU16cERrVkpXeEsvUU1sMXhia2NoVGJjNU1PSDUxYWx1bHlr?=
 =?utf-8?B?bGVjT05hVWlYR2FYT2Q1UHpGQm4yak9UUHZkeVIyWXMvQVY5WGR4ZlBMQkN5?=
 =?utf-8?B?cGRtNUhMTXFvTW1LcDNCYXAva2Y1dURwaW50aGoxYW05eVUxVTFOVEJBOS9t?=
 =?utf-8?B?TjI3U1h1akRnRkEwNTRFR2xoK0JXbkJqVHFHNjZYK1h2cUdkYmlDUmJHYW1r?=
 =?utf-8?B?OHNxbzByUkJQeXU0TmlvdlVpb09MVTl2eEM2OCtNbkhYQkhHV28vWGJoQk11?=
 =?utf-8?Q?hzd0Lm30Cb0lpnoByRSt7z49E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6921a-8c06-43b2-7a11-08dbdb674932
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:48:06.9959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yB8P+nZFm8QqWd/1lMpLYo+oyQnnhjnTIcvR/c2Qzpjo9IqOzY/QiLEKxm8OXG2X+rNa7Oxzntz8lhhYzG2i1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5781

On 10/31/2023 2:02 AM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
>> is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
>> instructions are being intercepted. If this should occur and Secure
>> TSC is enabled, terminate guest execution.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/kernel/sev-shared.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index ccb0915e84e1..833b0ae38f0b 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -991,6 +991,13 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>>       bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>>       enum es_result ret;
>>   +    /*
>> +     * RDTSC and RDTSCP should not be intercepted when Secure TSC is
>> +     * enabled. Terminate the SNP guest when the interception is enabled.
>> +     */
>> +    if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> 
> If you have to use sev_status, then please document why cc_platform_has() can't be used in the comment above.

Right, for sev-shared.c, cc_platform_has() is not available when compiling boot/compressed.

Regards
Nikunj


