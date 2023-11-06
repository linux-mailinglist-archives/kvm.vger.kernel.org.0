Return-Path: <kvm+bounces-656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B004F7E1EC6
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:46:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66771C20B89
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E1B18037;
	Mon,  6 Nov 2023 10:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v7s14S2h"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8B1799C
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:46:20 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CBDBD;
	Mon,  6 Nov 2023 02:46:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDHbmricIHQcJUfe8GngZ0yeCY+h3FjmehE8jpKCCAnkE20HYlru0g8EDuYfU2I6qBTcucpDzAKZXtcs0WXlRLckvSYvNg8/c8hMFfRC/AIBNvDSGJNAhp1/NG9MK4kCrFMknNSkqpLZiwC9RIyHg3lZQ0PHsbZK3F6IDf9hh/mCeQKbIJo4tSrWArHXsaMMXpXpaLoqexwyvteh0zQt+vS3f4v1GU6VHNkhc02NoDEH4UIimI2hwqETmwgsG6lhj2FmCTyNGdPXYwx04ks7t1vJwxgzH54iZaaWDf7OlQi9Bz3/q3TljAXKHT2LP8sJ4rM7NIy1jZadco91JK5YHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uULAWIoFdKd4fHFLheJLLul05NZqoVH4DUVdnTsRU5Y=;
 b=H3k7sle6w7//DKC+YFHxvkGj6JL1Zyhx4HJYFdEbTZ7+JrZaryFL4Pr6+QJziYOgkqlNwp7Bz9az618voEsdfuKtdlPHSO9i2RRwI2wPnXlKV99vNf/IIwSXGU9cAZXtWLE7vmZMfeHizgN/xjq+26Z+hrTdFrLclVCKYYzqjoK84qPYv+3VlFXuVPe+7kb2+vdZJAP5O4EHNUKiyHAb9N0maR32j0ALQGaROhcivyghMK6od/KCUKK31u4Nv6fVP/vwjAkDZqSlDd+CoLbjO39LQWHc6nRw1KWKzwg/91kOMFGosVWKpTJceFJ1WB2nkpbxJhj4gSr38fBMKqT9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uULAWIoFdKd4fHFLheJLLul05NZqoVH4DUVdnTsRU5Y=;
 b=v7s14S2hmEXCxJlFgpyx+1nobMyIayg/WtGyvF+xZVQ2sAiEBtucArZ8IqA1VA9tzOMs0OYn4C489Ym6CZyHjBNGvxsogf5BJYXxneCnENiptHXpBHNwozOk/9p2WT+8u2m1u/mAzH7VetaULncpsDowjgzKPcbkswsvmO2rgNw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ1PR12MB6292.namprd12.prod.outlook.com (2603:10b6:a03:455::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 10:46:16 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 10:46:16 +0000
Message-ID: <d419893f-3167-4a8f-aa4e-06e8ecd390d1@amd.com>
Date: Mon, 6 Nov 2023 16:15:59 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 09/14] x86/sev: Add Secure TSC support for SNP guests
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com,
 tglx@linutronix.de, dave.hansen@linux.intel.com, dionnaglaze@google.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-10-nikunj@amd.com>
 <b5e71977-abf6-aa27-3a7b-37230b014724@amd.com>
 <55de810b-66f9-49e3-8459-b7cac1532a0c@amd.com>
 <20231102103649.3lsl25vqdquwequd@box.shutemov.name>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20231102103649.3lsl25vqdquwequd@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0081.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::21) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ1PR12MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e0de175-d46e-4c87-e4a1-08dbdeb599db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kO3sn8+Aixvvk8G2/Bex5uIK77DTlGHqj/sKKj/uvG/0CNAAkRJibA9KSkV8mEhUKo/L+qw7+sRYDp3ZtOv8kzkdqytLaJVcEQTpH2tksNPw0vgqqc7tWL8GJHe9KN1hSCCsS4UR7SO+17EJyAwMhODEO+iIlMBtb5cIRDZQN4X/YW7b5tDD731Q+paY8xVLIzT+FsDzHM+9LlTYeqD1MXuxvx6CTsFPYWtGYniGp+s09wvlKAjLrEj98cJwz7ooyTauLyd28G0qXg7yXflUntrCoJqi6+UodY4ifTZu+BmrERtGvqfO8jh5+riLcl97V/JmpwULf4vKOzNTzVnsA9uoW3rKnFB6bTlH+UkJuNfe9h6rhL9Tbd50Xt4UdtJ9B3NtCyJV+SMo0yIzT6aDefYiuW0mv8EoW8lg6++Jz60Z9vf98vbROTsGsNCJgRDSl/zJsoEDZc9iUWMOxnZvPjE7DQsDJ6qpEWUpHEc/kJDIxurNTbXYo8OUqqIGtpjsmNEz5UyNTue2c7XH2/oJzc/AwsKg72R7GcDqcbKcskS1oIlVTwfeIkSqzPwzyUDYRNSfdTYtq0HPOmWQGGJj7eKIKLMbrk8EQ+hkZUKq2ItWfkAyq+Q38zmhctjEaEeAIMIhvY+GMKHOpuABMRYgjQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(39860400002)(366004)(396003)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(31686004)(6506007)(478600001)(53546011)(2616005)(6512007)(6486002)(6666004)(36756003)(38100700002)(31696002)(5660300002)(66946007)(66556008)(66476007)(316002)(7416002)(41300700001)(83380400001)(2906002)(3450700001)(26005)(8676002)(4326008)(8936002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0EycTVuZlN0RVFKN2pFSUhQS0YxcW9uSW5rMERBT2ZlVm5DRS96ZnZiVTE2?=
 =?utf-8?B?N01mekdoRWlMLzVrdWRvbmdKSG5DM0IzR3J1MDdCc2I2ZnNTaElLQ1l6MEVG?=
 =?utf-8?B?T1ozcDFleHEyU3VKWldtU3MrUXZBcEd6SDkvYjRRa0RBUzdralFxVU1ENVd4?=
 =?utf-8?B?T3hyT29rdFBISkdrM3lXbCt1RmFiVjdXR2tjaVd1ODJJYW1iVFhmTmI0L1Jj?=
 =?utf-8?B?MzFXOGdyNXQrMTlVYUZEWHEwUjlXSE1yMW9qZFFqZVFVUHpsS2tBKytmQmFv?=
 =?utf-8?B?MzNFZ09YdENYQWg3c1QvbUVRRTVxeXhPTWdSbjdlZVJ5MktMWXVjNUJOSTZ0?=
 =?utf-8?B?RHZXaUR5djJ0aXZNcVFLQUV0VFE3NTlUbDVQN2U2ZTUrMVM4NWVtSkNmWEls?=
 =?utf-8?B?V1BQaTVZWGUxWU1INnptLzZ2bkplanBRWXdBMVhDS0NYUmg0V3Jnd1l4RWxq?=
 =?utf-8?B?WHBXeEJUc2JKMDFyd2NJT3UvYzU4c0grR2RQWmw4cHBiVDU0b01CdWtEYUdN?=
 =?utf-8?B?bjBoU0dDbDVjcW50YVRCWTZyT2VON2N6bG1DL29tOXd0amdDUFZHdmJjWEVO?=
 =?utf-8?B?d3d3L09lYUo0K1JiU3FsVUk4cy85WHV3YnE1d0pGUEZPODNZaDMra3NYTnFN?=
 =?utf-8?B?bk9VbENJV1gySGtzZW9zTUZnajlqSDFRWkhGWEZzbUhLTDVuRFlKSTVBSG5k?=
 =?utf-8?B?Yit0Z3kzeGNYQWRUYkN5QUFGWGRjT0dkUWw5NDdqOGgrcWRpU01QQmk2b1Ru?=
 =?utf-8?B?NVIxR0xEVGZCOU9JdERSeFRHZm9qSUdzT21ndXJncFpDa3Nnc0pDdmRuS0hl?=
 =?utf-8?B?ZnllUjhwTHhRa2cyZndPR0xOSU41Vzl4cW5zdnpTTm50SDkxdnF5QzlpRFZK?=
 =?utf-8?B?MGFDd216TGJvNGJhTDFUNWV6UnZYR2l6dlFIeldUeVdpaGRaQXpJcW5MdXhF?=
 =?utf-8?B?eG5KekxxVXpWZjZVOWpBMnZmclA5LzRoUHdFb0x1c2xVNkZLN2FMQWFjUnFa?=
 =?utf-8?B?UGRVUEs4ZXMyWVluMjZzN0p2Rm9jTmtuZEJiSGtnUVFwNWprbk05VUVYSkFU?=
 =?utf-8?B?S0NoQXlCaC9icms0K1RxU2JSKzdwbWp6c0QrbVBlejlRZjNHYk1UTlA1MndR?=
 =?utf-8?B?eDVwTVBxUFpUSSszK3B6YkZYenNmZmQ2c3E1NkljcVYrNWpSVytPREtMamxv?=
 =?utf-8?B?UHU1RzBLY0MyTlZZM2NNR3B0M1lPWVpZY3FnS1Yvc20zbUNXWFpYNzlNS3hR?=
 =?utf-8?B?bHlCNmlYT1ptc0xmN0lZMmpkdVI4REdWelI5TjY1Zno2UzkzWEFHREhrMUlY?=
 =?utf-8?B?R014YWwyZzBBS3hhSHliQTZMalQ1R1dpRVh0aUZubGJXclFrMW9RTFQ1dHlS?=
 =?utf-8?B?T1pYVGprQlJjVFNhYWQrTTY0UUo1cW5pbGE2VFBQandQVnY1MVJadnJxWW92?=
 =?utf-8?B?YXZyak5SVXlFRUtHQUdpUE5HbVlVUnR5MVZhOGp5cy95ejBUdlV0Znp2Y2RD?=
 =?utf-8?B?QVN6VjUrdzBjSkRrYnFDck5FY3VLOG1yMU5PVk45Y3dJWGhoZCtYT3d1bHVD?=
 =?utf-8?B?YTMrQVlqSU5GK01oeHdHZ0ZqenY4aWJTY2h0alR2VmRJTWJpREJ2WVlQOEoy?=
 =?utf-8?B?bmUxV3dsR2loQUg2dFFJeE04U2Y1YmRXQm9Ic2tWc0VXcGs1Q28rN2swV3E5?=
 =?utf-8?B?NlJtcUo5algwcHpNM1ZjVitYM2NxYTZNdGVuck1TS3hDcmJaams3LzJvUjF6?=
 =?utf-8?B?a09qdkhIM3JEMzdXYi9wZDc2eHdyYjYyUUs4TXAzYjlEV0pFTUlvRXl5M3ll?=
 =?utf-8?B?bXBpNnlWWVFRWE9hL2VVc2NPV0JtL09yTDgweFI3U1JucHB2dXlIZTdENFRU?=
 =?utf-8?B?VHdLbStQWWR5eWhzY2xQbkMycEFvM3ZOQ3RpTjNUeTc4QWV2VWNBZkhSVmt4?=
 =?utf-8?B?VHNqejZveW9nVUcvc2s0cjhQRWhtRGsxU1VMRER4d1Z2SnJET3c5cytpZlQv?=
 =?utf-8?B?Z0hudzRacHRUT0hpa2lMUkh6WjlKTHhTWkMxOVN6K3VEZWxjUTVkdm9samsz?=
 =?utf-8?B?WURXV1I5bUpyRWx2S2lYNWZNSWZBVFJrVVQ2N0NBZEtEUnRkV2oyeU9HL3Yz?=
 =?utf-8?Q?f3B7WLFMHWYEDJ5Ep3qNPK/iI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0de175-d46e-4c87-e4a1-08dbdeb599db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 10:46:15.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIDCl8JVSeRg1ke9sau94iIF/o0jZmImS0+0KBIZT6eZKzwjvCmj5rjkOwoGjMocEfzG0KIHjV2BzMJWdKfG+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6292

On 11/2/2023 4:06 PM, Kirill A. Shutemov wrote:
> On Thu, Nov 02, 2023 at 11:11:52AM +0530, Nikunj A. Dadhania wrote:
>> On 10/31/2023 1:56 AM, Tom Lendacky wrote:
>>>> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
>>>> index cb0d6cd1c12f..e081ca4d5da2 100644
>>>> --- a/include/linux/cc_platform.h
>>>> +++ b/include/linux/cc_platform.h
>>>> @@ -90,6 +90,14 @@ enum cc_attr {
>>>>        * Examples include TDX Guest.
>>>>        */
>>>>       CC_ATTR_HOTPLUG_DISABLED,
>>>> +
>>>> +    /**
>>>> +     * @CC_ATTR_GUEST_SECURE_TSC: Secure TSC is active.
>>>> +     *
>>>> +     * The platform/OS is running as a guest/virtual machine and actively
>>>> +     * using AMD SEV-SNP Secure TSC feature.
>>>
>>> I think TDX also has a secure TSC like feature, so can this be generic?
>>
>> Yes, we can do that. In SNP case SecureTSC is an optional feature, not sure if that is the case for TDX as well.
>>
>> Kirill any inputs ?
> 
> We have several X86_FEATURE_ flags to indicate quality of TSC. Do we
> really need a CC_ATTR on top of that? Maybe SEV code could just set
> X86_FEATURE_ according to what its TSC can do?

For SEV-SNP, SEV_STATUS MSR has the information of various features
that have been enabled by the hypervisor. We will need a CC_ATTR for
these optional features.

Regards
Nikunj

