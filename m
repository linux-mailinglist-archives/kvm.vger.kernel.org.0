Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9915F4812
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJDRMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJDRMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:12:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CABC5C968;
        Tue,  4 Oct 2022 10:12:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4iamDXCmtFxKzqCJU3XUWOCbBAuQBx4tWXQEKsnSpPHgcoy0zQEW8qgft1OdF6i++alUGi6uHCfKGID/dxaX5tCv028daqNjqzKrngw40+hREdGvgbKOdQ3CaGhDoQR7oJluA8z9inQfiD1Ix6s52NuFRt9IzzTvK6KTWZk/iDNAMSZDpzkCjrZihhg8d+Np0mgw5DHYh9sPlkzr9LWAkta4Ep0Yb3I9M82ymPmuWLSRDEZp+TCGAdegrhtDVlSocW6UIIKhycG3wKGi1/cc8MYLcsH1aSWMZU21aXWd9g99FiMLBtbQGItwuya4ZlnXKObcbfmJpz0IjbGoJkAIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pdVdUYQguczGIuPQx/0Pr0fXAwVGSXntNZ68ZaAul6Y=;
 b=oNX41FWve+Rv8aLyu8vqVOFwyBHuqDCKGyBnL3JuXYYp9yt3Ga28AwyscmHtd6aOxLhHbattI15odhByLOiKlhRlgILP6LcB0kyUx8erXVlOWSjgdsip56tbbT9L/9LqQTNaR5xg/GRy1CmtDhPC3fjzYADdjhcnmRqAjvqjnQqnxpNpS7wuZjKvz9/1emgEXgKotVou6N9G7jMQv0HUIYQGoHxUHRQA9PRpWLZED6dzxnWYossoRBXgINM5ZjqELwSnYAa/FhjvoRnfRszMYotoa3E7Y0CXHFUTBGX6ZRugui2NT/LaM26K3eDuEPpbqDjN5tTU5pGSG4nMMbuehQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdVdUYQguczGIuPQx/0Pr0fXAwVGSXntNZ68ZaAul6Y=;
 b=ajozF4NobhvlACX1gtFYERrqOA2/N92iZclNXFj3WvOowVdyNGFmD+/ZGeThHfjFjKcfosBirpkxT6C5pzXzum+APcll8ebdTq7FxvwiskT4wu0QDyVT4nx2tw1Rcdf98FR5vfTWdHpDCIaXFxT18L/fxUGq2TQJ90dtJ3D5rr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 17:12:14 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649%6]) with mapi id 15.20.5676.019; Tue, 4 Oct 2022
 17:12:14 +0000
Message-ID: <49227bcd-3e54-4a4d-5416-dcb9315a1802@amd.com>
Date:   Tue, 4 Oct 2022 12:12:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
References: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
 <dd357565-d428-499f-fa0e-e35aa043449f@amd.com> <YzxfdQ7DrT9X6t7j@google.com>
From:   Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <YzxfdQ7DrT9X6t7j@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:610:5b::31) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 7853656a-8188-4aa4-0d43-08daa62b94e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afK/Oihq7c7aDxYWP92+7njBcP/xVrwmZ2xVxi0Rnx/8Klu2FbZUnXfdPOEQFxKiFk5nl/iRcxf7dMBCYL4EQO6KC9QHIazGAk3xDhfhZMtLxx1hvmLIbjdRLsvFu44tuqHgh0nVc5Kakscfl/1HzCG7MLNOdKaCWnXzC+rksfy8iULWsGuXz0c5ZdLD0kkuIiqzkhje18uPWOjLD4WyTM6yYk6A3id2YH6RFbUMcMFxX1hIBFrcvPXoRQ4YE2O7mUpvnHqKIV5/Y5Mm9GfMdB8TDmtnQi4bGe5mahbuKmVQvtM220x8KcZL8aNFOWKrYgE+3Q3btBiIJwyW7QNXZ5e3isD7x7ktk7SM+TMgYaleTnaPOsA+wLClF5IqezEkwmZEoqJvk2nvskCs2bJluyONhVwDCcoBYeTRYB+U96uAih8mHDdy/hqM97IsBdk4AFRtm6BrRNrFbQCpenJivpoXBNkU5uUrcVjIokNkG/08rElHkeBB0OJLNWodkPIsHtQHYfVWFrm/bh6xjIMZyl52EHtBOlZF+UO22LkkOLiT4mjFpX8ypcWElEQKs/m5esEo+uLLvhkylwp9J8RRAQXI+XJgtdiGcO+Sx3NkmljWD9e2WF/bwJccez4hQWjODFeXlowob2aJuIFSERH4R98rEYYRVQKOm2sl6TINnOYz92048gja9rGfoy70TPfeg88xittrWS++og6fCPwD/WyNStWTnIvQwpZZsHfLUVOI6h8tPGpqBGoI9CXEd8tw1Wu1hkKx+1t/FOVMNghF5+j8FGGNPhRKVgaU0bGoHTc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199015)(36756003)(44832011)(53546011)(2906002)(6666004)(41300700001)(31696002)(6512007)(5660300002)(2616005)(26005)(186003)(38100700002)(6506007)(83380400001)(86362001)(8936002)(7416002)(478600001)(31686004)(4326008)(316002)(6916009)(66476007)(6486002)(66556008)(8676002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWpSbWEzdFJyK2xWRm9GWmkzZ1lHT2pOazNyVGFxbTJ2SVFjOVFhTFVtWTBX?=
 =?utf-8?B?Y2MzdGF6bjhnMjRxSkRjakc3eExlYjQvc1BHL0hURmRqWmV3WERUdDdZWGNL?=
 =?utf-8?B?R2owZ0tOODRTWm9sdm1xZDUvMjdIb1pxMFF0ZFJ5K0VTck8zNVZyMER5Yk90?=
 =?utf-8?B?UUFESnZMTDR5dHM3cm13cE5Xb0R3RVU5Y1g2aEJJUFlFT0VyNGZ5OTU5MFpD?=
 =?utf-8?B?eVU2VnFNUkN6YUJ4NVl2ZGlHWmNXTmJwQUNFbVA1K21SY3RTSk5PSVZmVE13?=
 =?utf-8?B?eGJUVG1OZ3gxbUVvLzIzcVk1Zk85OVZtcTdubVVCUjdBcW5PTHNYaEJOdDlu?=
 =?utf-8?B?d3BRRHRGRnR4SXpOUldoQVJjemJTd2NxUzdRQitBdUNudzRCTzA4WHVvMlU0?=
 =?utf-8?B?dDVZZlJRT1gwbXgzRTRIZlA3cWhDcEhGN040NjZxV3IvTElXRmUvcHdIbUtC?=
 =?utf-8?B?VXhIb000ekJQOTZPbm1sM1ZJUUdZS0wrUTk2UFI4TFVYNksrai9SaHdqNGFi?=
 =?utf-8?B?Zy9yYTNNaVMwQlRtZWJaYVRyRnJMVkZlLzBSQzJxR3AxSjlEaXd5UHhucEkr?=
 =?utf-8?B?d3p6RXh4Q2RjbjlBdlU4MXRuWm9JTEtDbnN2dm91VndhcWNxOXpMTWREZHFm?=
 =?utf-8?B?REIyQ2lXSUh6c2FyOFlwbUpoV3dnVEVXTVlGdG9uZ0hicDJXZjE0aUN5RXBk?=
 =?utf-8?B?NmtrRzVSQTVTVDBMbVJraHB2cTBNV1BrbllqUkprZkNmSW9weHVRblZNUVQz?=
 =?utf-8?B?bU1PWlhJakRBOVVPSUJKUmZ2ODVoaklYTzRLaThyZVRKV1RHMElyWXpWQnl2?=
 =?utf-8?B?R293STRVNTJOM0o2NzhFNi8weENINWdTSDhwM0I1b0hOM2g4OHE1b3o1RVJw?=
 =?utf-8?B?UjlwQ0tlY2hjWlI3Q0JkS040OHR1SVM2eXlkbHJqS1RnenRwWG1HRWphZkZh?=
 =?utf-8?B?UXpPMWdYREJQY3pmRXZjaGhXb0FkUlVRTHlZZDZXb1pjamcrRVErNjlxblg3?=
 =?utf-8?B?UFBxL2lRQ0wyNTR0QTJMWUc1VDMrV1ZGUVVtREVHWTk0T2pacFNwVWJvQnhz?=
 =?utf-8?B?RUJtTkJxb2V3WW94QTBrQWhxS0kxN0xFM09zTHBhLzBBejJSY0QvczgrR2ZE?=
 =?utf-8?B?S2pYekNsWnZzTEpnTFpxZ0h3RGY0SG1WZjh1eElFRXFsdnJxeEhBcXc3V2Zv?=
 =?utf-8?B?cCtIWkFMY1B1SUMvYnIrb2xyd1ZPOG5TR1pLUUExWkZiNzM3RlRRb3RveWtr?=
 =?utf-8?B?QUVLT05oY3V1SWQ5VXVKTzVGQjFqSmZtZnBCQUJiQS9XVDIrWVJsV0RKS1hh?=
 =?utf-8?B?NEpXTUxFY1RSb1I5bEhieG5PVmlIcWNKTll0Nm9oT05nSDZEeDY1MVVmOS91?=
 =?utf-8?B?dGowSFJWUU1lQS9EKzJxbFZINUdGMXE4eElRS0Z1OHRlaUgySG5iOHRhZTAx?=
 =?utf-8?B?VURGcnI0Q1FoOFhBakZpL1JQVGhKVWl3MTFWLzFGNyt1ZDl4dFY4UURlTTEx?=
 =?utf-8?B?SHk4Z2xuUFp5VEJHUHhObXIyVTZtbGhmWkhDckVUWmEzKzl1ZEh4a3N3QXVp?=
 =?utf-8?B?TGp4RmpVM0dRQnNXOUFleE42cTNqMEdXOWFGQzRybkJpM053dGtGMmQ3TEwx?=
 =?utf-8?B?TGszc2FpNHVQaUtuN3cxcFBWNTNqZHpuUVpmUlNrd3k5d2xTVTNMVTZCSldI?=
 =?utf-8?B?M25PVHI3ajJLcUcwUjNxaU91c1JoR1ErY1ZyL2hMS0N2RXJBUUhpSU1Ec2pJ?=
 =?utf-8?B?bDdEcmlNOFZ5dlZVN2lnTGJsS1RlU2FpNmZuYzhrVnAzbjNpOU5XUEtOWHlk?=
 =?utf-8?B?c3pndEIxb0lZMFJoMmRIalFveDVzK3hwMzVMeUkrNEVhN1NzL3l1Zm1IZ0Iv?=
 =?utf-8?B?R00vYkt6bFNrbzVJTWh4ZVZIdm1FaUsxQUpMU3pCY1JYNEg0emNsWFAyVm92?=
 =?utf-8?B?bjh0WHV4cVlTRDdEVVJEUS9RU3BBM25ZL0RCRk5EdnZvUFQ2MVBtMXNzSDlq?=
 =?utf-8?B?OGRCM3FiS1Fmb2xGbGozVGVXdDdzTjgzN05LRmYzQithTHdwci9xUHNiQm9h?=
 =?utf-8?B?emxZYi8wN2RrdVJKOUw4UnFXNE4wT0h4TlpMM2lkMFNURG03cm82Z1ZkVzNW?=
 =?utf-8?Q?KD6UlZZoW9OSp6fqfsWIXV0eP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7853656a-8188-4aa4-0d43-08daa62b94e4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 17:12:13.9530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcLX/V5hR7QiOLIE5SOUzpnhNvdSiiHV5QvtU1qDDA/cRALIw4QDUirvdMJ32bT/bVF6nzInhLI9dgOFHbefiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/4/22 11:29, Sean Christopherson wrote:
> On Tue, Oct 04, 2022, Carlos Bilbao wrote:
>> On 10/4/22 09:05, Carlos Bilbao wrote:
>>
>>> Reserved fields of struct sev_es_save_area are named by their order of
>>> appearance, but right now they jump from reserved_5 to reserved_7. Rename
>>> them with the correct order.
>>>
>>> Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")
>> Actually, there is no bug, so this Fix tag could go. Thanks!!
> Fixes: is appropriate, if we think it's worth fixing.  Personally, I don't think
> it's worth the churn/effort to keep the reserved numbers accurate, e.g. if the
> two bytes in reserved_1 are used, then every other field will need to be updated
> just to accomodate a tiny change.  We'll find ourselves in a similar situation if
> field is added in the middle of reserved_3,
>
> If we really want to the number to have any kind of meaning without needing a pile
> of churn for every update, the best idea I can think of is to name them reserved_<offset>.
> That way only the affected reserved field needs to be modified when adding new
> legal fields.  But that has it's own flavor of maintenance burden as calculating
> and verifying the offset is a waste of everyone's time.
>
> TL;DR: I vote to sweep this under the rug and live with arbitrary/bad numbers.
Well, the discussion on what is the most appropriate way to name reserved
fields is orthogonal to this patch, IMO.

This change just follows the prior approach (reserved_x), but correctly.
Keep in mind that the existence of reserved_{1,5} and reserved_{7,11}
implies there's a reserved_6 (there isn't). Why knowingly keep something
that's wrong, even if small?

If the maintainers think this is worth changing, I will submit a new patch
without the "Fix" tag (nothing was broken) and with a new subject line
(instead of "Fix reserved fields" I will use "Order correctly reserved
fields").

Thanks,
Carlos
