Return-Path: <kvm+bounces-384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D697DF21D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:16:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84FB1C20C59
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 12:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E08E18650;
	Thu,  2 Nov 2023 12:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hV+ChJWp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BFF33E1
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:16:48 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903BE1A8;
	Thu,  2 Nov 2023 05:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSZ/XonWjHU+hkVlvGdlAf9rckvV4G4w7eW8qIOc4dwgMYjUNVAd4YPQasSLMHcbNi6coyqayEaQlzsZvUOlrG8PQBbcva2KtXadK8uskCHhv7xk8cMK/wMomtXRcDRUEEHBPY2QzmHqeYBPYIstmlz51kjQXDtEfMPlYLjD5CbsBunf6V53wA1YBBU9XK+8s7BeLmFh3xEQZufu4796JAq3MIWAv9n9IjZnG8BuljRtZvGsqP+kpJ6eT+aRx0T8x44MV1gA2XSsgc1EjPgius1hugz4izxGMd5cPvqO16EM18ss1SRrlNI/ZwSlnGrp6DGbnDMV25r2UKHQzx9MRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQbqYDf8Zy2qZeUbdQcG9/W5hebeCvBguL+mTPgFoG4=;
 b=FH9d2JWZyQ/752yZt5E1YhvYfFe4LfRvQHC4c359+UZH/N3cbxWJnPqcsfH6G6w9almEsTt+JcMPOytR1lkW+Vg0h7Ri7HlxauOxNAg7V92pHK+Q0yete+EW7UrkfuuLObnD7v9gQSrqEsrnp9ldBPKq6Rsu6Kff+vOJ9dQaKnvARLvQM+6n8sYaAEwgRaYtF7FK+EQGyFTASEvVG+yr1y15K9yOn8KPGGJoKuSA8Cps5lO0o8VWL93YRjj4uTeF87dZSBTuhPIyZAuRB0/xqBkNx95cFbU9KAY99IK7YXTHWogZvypGEbzO+x1y50JFm0+0KgNAlrdBYZIInd4Pvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQbqYDf8Zy2qZeUbdQcG9/W5hebeCvBguL+mTPgFoG4=;
 b=hV+ChJWpIzgFhFClMfY308GriPoWJjS4gqpFUr5OHO/S23v5FbsiN9Ocsg7jdLm3Vd9hcyWWkTbjR8RN/p5rVK8zz0pCWKETmHmr6rkIlfxIlZniKa1bzmMxpBsVc2V+VXVRx4wHQVSZSgPLoDg7AAMvg364C8EB5cFp+zVSaOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8349.namprd12.prod.outlook.com (2603:10b6:208:407::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 2 Nov
 2023 12:16:39 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 12:16:39 +0000
Message-ID: <cf92b26e-d940-4dc8-a339-56903952cee2@amd.com>
Date: Thu, 2 Nov 2023 17:46:26 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 dionnaglaze@google.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
 <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
 <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
 <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
In-Reply-To: <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8349:EE_
X-MS-Office365-Filtering-Correlation-Id: 075d2db2-888a-44cb-66f1-08dbdb9d90a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PPTkFiJkM/WxYDk1iNL1ipH4Ceip2FWpXV83OPZLvyWnpFhfnT2ZDgPINsIJ4Ugs41fiNp7/XIOmDFnSHVWPK8W8u9CoISevITLtyVJlxUBJ4uVkpqfP9odlWPrc2SxW4Kx3pJpYq2HVzPIcuD0GYhwNuYHpyPellHSE58Rw8u/rdFZ4N4rkmlrpHXx5J2A459akzMELDSwqMHS8F/00+faxTQNh9Z4dAYcvbV2R4RWUgzM3BdrOfFZTgrv25RIEOfIdnWq5vLmk7nD4NgjNz9Mf+4Itdn74rsan1R5fDvRFAZHKakC6Mu1gF2PYMF2menLi+oWH0qFdIuRFhU3LQgYwRuYuVQ15a1qDrk4mq1EFdVE4b3H5qC85is5XVMujBvEtRGBMsXFblNvcBCEum3JYqyoeLmoDBEi0vDH2shEBizYM0JWmNSXttgD/3MfsEjY8EVHD9j5LdT8+mFh6FsB0cqVr2nj0p7p5h8TqqyXadsyHTElPYdvYVYPvqYy+8ZWyDfbTnAjIzftVLqQXuZ+xPDzIi3cyKRZ3zS7Z06mRcgszh2b6A1Zvxoge8H62MKx07qb+Unzu3067RVaSmjPOwZKWFMiibsxUGwt/zf9LQc056YWJnOeq2JaN+crOeFvuV5a768RM8CraFLvmHQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(346002)(376002)(136003)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(3450700001)(41300700001)(7416002)(31696002)(5660300002)(36756003)(2906002)(6512007)(316002)(38100700002)(66946007)(2616005)(66556008)(66476007)(26005)(6916009)(53546011)(6666004)(6506007)(6486002)(478600001)(31686004)(83380400001)(4326008)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDZwaTk5STRLdVFnM1BRUzFWWm5qamJ0ZmlTTWNySHNtRGJOdFp1alJmNzNl?=
 =?utf-8?B?K3hNTFZpOXNDdzloUFVBbTR0NWlvdXdMTGhLeU1SZnF2cGJvcllqczk0ajVJ?=
 =?utf-8?B?QzZ4c0svbVRseU1qN2Y0OEE0Y2F2TStOMmxEVVpsU2k0WFJvZVRBV1FBQmVU?=
 =?utf-8?B?OG5vUmdFVVZwTmtWb3BDMTM1MktrOFpiUndRb2Z3OVV2Z0dxMDE0NVFOZSs4?=
 =?utf-8?B?MFhUMWp5NnJtUmhrNzMzdWdsSG9jdi83UDJtalhrWUJrVDNDQ0NKSzd5YmdN?=
 =?utf-8?B?cG9DdUQ4WC81bnNGdFBRM09VTHpMVUNzUmF6R3lJdFRWbGhFZHdQNjQ4Mk9N?=
 =?utf-8?B?SGZLQ0NwZ3hwdWtFMjU4SllJRUMzZlVyOHNqYjc1Sm45NzdCV2YvQUl2eW50?=
 =?utf-8?B?QnQwcWp4Yk8wZXY1QkhETVg4czltWmlQcDh2Si9WMEJpNFZqNFdHc3Z0aFFz?=
 =?utf-8?B?bTJFMU1VL2t0c2kzZGNiVlFDK1ZOWXdIRnpYUFFpbTBlSUlTcDBNekVpTXJr?=
 =?utf-8?B?em9PSGlYekZDaXh4THhFRkU2TDJQVEh1WTU0UFlmRGoxNTVmelBWaDNFUHBY?=
 =?utf-8?B?WW1UUzE5dUhJekorMFZUYTU2T1B4R1lXYWZkMnRQUnNIS1dWUTV0VnlRTWNw?=
 =?utf-8?B?djNNRWxGMjdQY3hNQlRCZ1Q3VUJpOWYwRER5Q2tGWEpUZE9xMzN0eWNMWGVB?=
 =?utf-8?B?aGdyVlFJWVVXUzBqdElLZ0dRMWdsRkhTL3BZeHlUYjcrOS9qNUtnQ1pFVnVF?=
 =?utf-8?B?ZEZQSEFUcEFxNHR3WXhpYlZPSUR3UEFvMFNpM1ZHMkp3d0JiTU5oR2V0VDcr?=
 =?utf-8?B?aWF6YjE3UWNsOEk3bWJMSTA2dmlqeVRiL05qNFBCcGozaG9zNXBZWXRkT0xr?=
 =?utf-8?B?WFhsS0dNaFRxSDhnVDEzWWR3OVhFUzZidHpQWjZrOFY5cmNzMWZCbWp3WGNX?=
 =?utf-8?B?bXQxUXdmT1p6TVlhaWZCM0pOZmtyNHJPRkxJa0JORzdjR2loQTViaXRScjZu?=
 =?utf-8?B?VVBCSzk1a1hMVFNKaFFKTHF4cElPMW1Vek1pL3dIRUdlZUFETjFhdGM1blda?=
 =?utf-8?B?WHFDRFFlQUdBOXVlcXJCRjY5cTJQNk9Zb1BVVmcxS0FHUUFSbWhWODQyb3Rs?=
 =?utf-8?B?VnlvTnlFZkg4ZDZ1Z0t1b05uelY1UUliclRrU2VRaVFxUGozdzAxTUxGTXI3?=
 =?utf-8?B?ZW04UktXaHRXMVNab3dUdGFxMm9FQTFndlRJcUJ4UFRkVUIxR1BuNTFuajgx?=
 =?utf-8?B?MXA5V1NkMDdKeGhPRGZRMWd2L3dSK09Ua21KbDhsYVQ2UmFDUjd3cGdOcnJG?=
 =?utf-8?B?elJ3aGNXRHdPRllRaXJlNFplZFVROURHYWZhS3RpQU5BOEhmWCtYeDBSaVBJ?=
 =?utf-8?B?dTFpbXJKM2pib0FYZnFzRUVTU0MwQ0lGUnFKUkplWVJhZnhDZ1lXWGJHd1hV?=
 =?utf-8?B?UUx6SFhwZ25xY3RyejMvSFRrUlRrUTVYRWZjblYyYThxSC9LR0dTSk9XYS9i?=
 =?utf-8?B?cFBCTVJmVVB1OTFpZ3Jod2ZlWDRqSHpQTElLMXIxekhrMFZWbDVsVkZCL3Vs?=
 =?utf-8?B?TFR0OGdBS0JoTUY4RXFxUncrWmJqUC9YaGZFZW0rYXAyOTF3MFVxcnBPb0pB?=
 =?utf-8?B?N3plR3JlajcrRlpjdG9sNnMyNE9adW9mT0Rzc2dKN2g3a3RIUDhwWGkzZHpt?=
 =?utf-8?B?NEI1c1VXQ0p3U3JEWlErckp4c2IvNW9kZEJNZ21sOTVTWHlXQWpVd1RpM1pK?=
 =?utf-8?B?ZHNEVmtnRUIvYit5ZGEzR3doMTVKQmE1RG4zaWptM1BFa29iclp0bWloY0Ux?=
 =?utf-8?B?dmtIVnNQSFQyVGZEMHFaREtBTWdDRnBIVEkvUjViQ0ZPNGV0Y3pyamhGTnZU?=
 =?utf-8?B?VEJmRW1reVptTW9iODdCUmhJMEJRUlF2Z1ErR3V0alAzV0tvczFTcEpuZllj?=
 =?utf-8?B?SU9LdkVyMFhsbEhNaC9pSHk5WVhmcEVKZExjbjhxQ2RoVnZZNEtIRHowbEEz?=
 =?utf-8?B?Z3hObG4vS3FhZ2Q4T1Jpdi9DSjh2a1h6ZG1aTS96bVdjaHFVYXpubGtQM2tH?=
 =?utf-8?B?aDByQXQ2S29vSVdNNzAyRWNWSGtRbGZLd0ZTdXF3bmhydHVvSGNURGFKNm5k?=
 =?utf-8?Q?bUecwIfshZrMRCJASCZHrv6JV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075d2db2-888a-44cb-66f1-08dbdb9d90a0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 12:16:38.9529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYRQl6oP0TdhY31qoG6zLB2KCT5oxsrg9v+9zY+l4wzyZi4SaUtC/flbSy6TOYO46tDWdXy43kd2oTWXx2r5tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8349

On 11/2/2023 5:37 PM, Nikunj A. Dadhania wrote:
> On 11/2/2023 4:03 PM, Kirill A. Shutemov wrote:
>> On Thu, Nov 02, 2023 at 11:23:34AM +0530, Nikunj A. Dadhania wrote:
>>> On 10/30/2023 10:48 PM, Dave Hansen wrote:
>>>> On 10/29/23 23:36, Nikunj A Dadhania wrote:
>>>> ...
>>>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>>>>> index 15f97c0abc9d..b0a8546d3703 100644
>>>>> --- a/arch/x86/kernel/tsc.c
>>>>> +++ b/arch/x86/kernel/tsc.c
>>>>> @@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
>>>>>  			tsc_clocksource_reliable = 1;
>>>>>  	}
>>>>>  #endif
>>>>> -	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
>>>>> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>>>  		tsc_clocksource_reliable = 1;
>>>>
>>>> Why can't you just set X86_FEATURE_TSC_RELIABLE?
>>>
>>> Last time when I tried, I had removed my kvmclock changes and I had set
>>> the X86_FEATURE_TSC_RELIABLE similar to Kirill's patch[1], this did not
>>> select the SecureTSC.
>>>
>>> Let me try setting X86_FEATURE_TSC_RELIABLE and retaining my patch for
>>> skipping kvmclock.
>>
>> kvmclock lowers its rating if TSC is good enough:
>>
>> 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>> 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>> 	    !check_tsc_unstable())
>> 		kvm_clock.rating = 299;
>>
>> Does your TSC meet the requirements?
> 
> I have set TscInvariant (bit 8) in CPUID_8000_0007_edx and TSC is set as reliable.
> 
> With this I see kvm_clock rating being lowered, but kvm-clock is still being picked as clock-source.

Ah.. at later point TSC is picked up, is this expected ?

[    2.564052] clocksource: Switched to clocksource kvm-clock
[    2.678136] clocksource: Switched to clocksource tsc

Regards
Nikunj  



