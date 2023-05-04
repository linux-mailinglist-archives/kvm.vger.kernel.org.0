Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FE6F7793
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjEDU4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjEDUzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:55:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE46D1FCF
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:55:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ll0HBak061VsTv+KZnmjRfbwLhTgujlMI/VTy9OTQoPQAR18lk0yZaSy3I0y7oDxpM56ikC6KzDi4CuB2DLxVdmNoKMXtlhCLlu1PmjslT3B2TgbfUvr2TIoG0B8pKgX31TbeE5rDrh38zTzQxaKwiqAxWY/KaQMTkqruL97HE/2NNWs9RYYR/0VDQddQKH28lJJeuYLNNmu5qXcdPzL9W03m5bfr2nTg6HeidHqChBzpgyDdZ0DU1JBBvgF8mpF6E2xwyDYmuN1+2dQu5bI/ITAWmS9xSYf6k0tgY9v7sEYTx9X+bFyAkzCn0htSR980mPwOt/JQ2Zk9FU6IDWdjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXudzEINngTuoXi9qjIkIWaXUIjjmUqid0rjUb/YqEg=;
 b=CNtrtO5oY5l4WLoo0eslIGyKvrbSc+m+NAzXsQhU2E1ahJ3liTYa8Ak9cPuckUga3x+ul861fZAsgpxoAs6UcoPCZepWKU/3Br+uTM1r8WLw/fBBs6BeQ6dtGlJgZV7xDV8uSdawPO8C28mJmMV6eYR4NOXo5eKxGchh8V3GEDvUscNnXoAxJxRfeMOOWQKktgQ/5kaAxK3K/XxGxWo/TzLMgaFdJK/K5pFjYKCK9iQxPME4OuZhMGRVYsSvJgP3BqeyHqvmnbEB31cXcGaFOoQPX0WZO/KDyIay9k4Qi4ndAaNnETWxkP9xI+IHTOtkeEBVO38UpUck6p3/z7cZ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXudzEINngTuoXi9qjIkIWaXUIjjmUqid0rjUb/YqEg=;
 b=KVolLN/FDAxs6EmvYPUhXVqfJHfFgEJAtK3TLJQClbevR4kkxgPmiQoWoq21bfnEztf2L20Hesf2Wtj1J6AkoTuZZgraofGBV3Qhqfh7fzD4gdPIITB81miBS4IGTSajPOk2zZowO56vi1Dg0EXlVan3v0H16K2kv4/mUExzc6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW3PR12MB4348.namprd12.prod.outlook.com (2603:10b6:303:5f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 20:00:55 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::216f:6f0f:4a21:5709]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::216f:6f0f:4a21:5709%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 20:00:55 +0000
Message-ID: <c590c4ff-552a-c223-6bce-a0e567942813@amd.com>
Date:   Thu, 4 May 2023 15:00:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3 1/7] target/i386: allow versioned CPUs to specify new
 cache_info
Content-Language: en-US
From:   "Moger, Babu" <babu.moger@amd.com>
To:     Robert Hoo <robert.hoo.linux@gmail.com>
Cc:     pbonzini@redhat.com, richard.henderson@linaro.org,
        weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com
References: <20230424163401.23018-1-babu.moger@amd.com>
 <20230424163401.23018-2-babu.moger@amd.com>
 <CA+wubQCGyXujRJvREaWX97KhT0sw8o9bf_+qa6C0gYkcbrqr9A@mail.gmail.com>
 <68ec523e-72bd-3d5f-49f6-ef4d77c618ac@amd.com>
In-Reply-To: <68ec523e-72bd-3d5f-49f6-ef4d77c618ac@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:610:cc::34) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|MW3PR12MB4348:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c33eaa2-69cb-414b-1c13-08db4cda451c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmK4WdM6HulengEUXRvzZLZuFcBZYetdmn4P1Nki2cZo3BlTej0WrvSXW5x+oRoxwxq81Vw/Os+yJfeVOHATiT5qt7+pz5fPl03I6OpQAkP02PXOlXV7383fkRnmhkjC9VlgDcT66xQGsmNlsMqmYz2LO6J2C94ORdWwvZppXa8VZjd2ZyqBEXyZoBEtE4q4je4uEIg1xWbB3aNWsOHiIirD+FSB4wOSj9V82/h1zq33nPGwncTMFbjDWBBR+NZLSV+sxY9ft+9GFz8TXXJTb3GWFo7fqUndyv0NWaj/jZuJX8mAmwq6XO+XBqMZNedhipOPEij8L7XrQ4SR0nOyQ7Q2B7LcMeNw0r823kZ+C4uP4liGcQNHJPOB2AstaC8LMkiKtT98sPknVBrUwMWwy5IMqgrUiGgMl7X4lPVyfrpZ0H1OKR1OtOzFb6y0vfqXGtP8IYyvBcrIsrGvAXyiBo/BRDBAIgYdAhkqVfwRgrzqvuqRQC6oZvi6u0laSG6GSMSbc4KNxQ+FN1TMTmajksIRI5nhiiRmIJD/X/6ollEU12VRIULFr1fAp4UdAPx7V1HuiW+RvXQpILtx8R9TyeDD494o2/AxEgtW8gcjFaALOHRQfcE6myIrlYAWPQqqZBP5XfqB/Sq/34Dc1sKDDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199021)(2906002)(53546011)(6512007)(6506007)(26005)(2616005)(31686004)(3450700001)(186003)(83380400001)(7416002)(5660300002)(66946007)(66556008)(66476007)(478600001)(38100700002)(8936002)(8676002)(41300700001)(31696002)(86362001)(6666004)(4326008)(6486002)(36756003)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFNaU3l2NlFNL29Va0s0RFN4b3I3cURoc2RwNDNOeUNIenk5cUVwc0plcFdR?=
 =?utf-8?B?NFQzcGFGcEdaZU1WMktHNnA3bFVtcldYM21PV0dPdVYrUEFHUkp2MTMzMmpI?=
 =?utf-8?B?ZzJ5ckt1blpHeWV6aHUvOEZiVlZLc05Cak1iajdkQm9GbU82QjMvbmxoQ0FG?=
 =?utf-8?B?R1VKeE10M2c0Qm9aQWpoRmtDNS9HZGo4bEh4dEM2Y1J4REdNMEh0UUVQYnRK?=
 =?utf-8?B?Tk1UTngyRytFVTc1dU4yNEQvOGFlMmFaMFhmbnhzQXpKM01MQytlQktnbEVY?=
 =?utf-8?B?dnU5cVc1dWNHZFBlM0lKOERZRmVGSUozMTZDYkl4VC9tRTZDTFBiYTlNcGlM?=
 =?utf-8?B?Sms5a0RiOGtod0FMM2laNTZvYUQyeHpUYVkyc3J4eml5NHdOc09XbmZ4MTdY?=
 =?utf-8?B?b0cyU3cxcjBQc0l4MEprK05ZOEJySm50RWZkY3FFdThnQVdyOGJLQ2ZSclBj?=
 =?utf-8?B?QVF1YklNZ3g2SzU5TDl0M1M3MTg3YzVJZ2IrUVdScDVWSGRNUGNmS004Zitx?=
 =?utf-8?B?Y3kxNi9WZnB1Q2RzSFBHUFlhYy9UOVlrd3F6RDdCK25CQmw4UFdFZ09RZEdB?=
 =?utf-8?B?ZVhrUnR4dmIxOVMwVUw2NWRHWWs1ZzNKQTZ5aHdTZ0RyVWY1VWJqM0s2YzJ2?=
 =?utf-8?B?cDdRNWp6dlcwcXdSTzRBR3A3aEJMY2NFaDdabzlWdkZtT2Z2cXQxMWw5RldS?=
 =?utf-8?B?dTVOaUhGOVRhWDJuSUU3OS9MVXh2ekRlMG4zRUhuUFoybGtTNmFvbzZlbFcv?=
 =?utf-8?B?V1pSK1o5RmFNejZnSXJNa0ZFaE5VVGZOaEJqcjZBSnludTlsOGwxbG15ZU5I?=
 =?utf-8?B?YUZLSjdPUkhrUG5ueFREUS9IWm42NXo4TDJCcnlOdEtvOUxLeTlBUzEyNDhQ?=
 =?utf-8?B?cFlKajM4dUdVa3FnakNUVWJMalFJYUZZWFhpTnpSVU56ckR4YzVQSVFVSE9i?=
 =?utf-8?B?SFUxdzFvNGgwTDZuVE56blYzS2pyYS9SNjh2N0Y5S3lkWWFFUWFZOWRINDF4?=
 =?utf-8?B?NFRvdHdpOEEvQjhIeGtXUTdkT3p2YUVTVElPTVNOTmVQb2hPVmliYllEMk04?=
 =?utf-8?B?dzBUZnNOZ1B6cEM4L0ZQR1B1VlVCNWFxcnVKSC9sZjBDUTVDMmcxdElIdXAv?=
 =?utf-8?B?TXJvaXpDc1pBcmd6QUFxejdxcjl2aUp3NkRTRTRJaGdMbnFBYU9UWm02Uncw?=
 =?utf-8?B?ejZ2RndkcnhtVmJORjdyalZObk9JZmZ3NUZBZDNianp5QUxVenN1MURoMVVi?=
 =?utf-8?B?OUx5d0xRQUpwM0s2MGVSeUUzL2JFN0tmQ3NGRm42bUFQQ1o1WnpINzBoaUxF?=
 =?utf-8?B?TW4yTDE4YytlQjNNRkR5UW1nYk84VWM4NW0yZ0d4UFByTkd0MlBYWkNSMEhx?=
 =?utf-8?B?ajErVU5ySDhkdVdHL1gwU1lDd1RyQUxBT1JrVnM4U3FlQzJzTnRpRXdFamJT?=
 =?utf-8?B?K0wrMnVrRFBwNmtFZVBibFR0MUNXK1FCaG9PSGFaclZTOE5LWmVRUitDcVdy?=
 =?utf-8?B?QUgyOTFwNVQ2SzdnZ1hkR0RlNkM3cENmMWt5cnBrb1lVQkFENTZDRWk1UFZq?=
 =?utf-8?B?MDhNZjlXNm15VWFsKzhRWmlpc0JXZlplWktkYzU2dFNqalhXL2g4MEVDcVR3?=
 =?utf-8?B?YWVTUGRNRlB3WEJRTTZuNEg0VXF5aWdQRlpYaTh1UTdKTG1EZUF1KzB4RHBZ?=
 =?utf-8?B?T0dqSmtGRTBaa2lOakdhbnNYTzFnSS96NmU4Qmc0ZFNCcCtycUpPVEZjYVRp?=
 =?utf-8?B?U0VCemttSHFSVmZzTVViRWhySTZib2l0Ykk1c0RidTYwSk9RT0l4Ti9XWGxz?=
 =?utf-8?B?R2d4cUVOWDFlN2M1VTh6amNXd1d5cXlsaGNSUFpuNEhvQzIrd1FYVmtsbTVU?=
 =?utf-8?B?dDR2QTMvNDdzdkI0OUprVVR3WWZnWnZaVkFkaUkvMmdTMzRRN3FqY3RvdTRt?=
 =?utf-8?B?a2FzdHg5QkhqNy9NQnpRQnJqczZmVlRHMVdrN3AvNjAwL1phY0h3UXVOem91?=
 =?utf-8?B?NnZvdnp5V2h6aTB3YjhlTWhBWHlvMHAxOVdWVG1zMVZTNlJIZlhnL0VQb0pY?=
 =?utf-8?B?UkVOYkdKaHJsZ0VmUWJZR3dPck53N050YkRkZFVnSmZ4c2ZweXI2alBIdFRB?=
 =?utf-8?Q?BLQY=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c33eaa2-69cb-414b-1c13-08db4cda451c
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:00:55.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5Rjvk7Ncjwm9jP5CBrdxAfSVxr2EIdVS2gvO6jEVjAe0qXSLE6SP4XUTFFWSfad
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4348
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robert,

On 4/25/23 10:22, Moger, Babu wrote:
> Hi Robert,
> 
> On 4/25/23 00:42, Robert Hoo wrote:
>> Babu Moger <babu.moger@amd.com> 于2023年4月25日周二 00:42写道：
>>>
>>> From: Michael Roth <michael.roth@amd.com>
>>>
>>> New EPYC CPUs versions require small changes to their cache_info's.
>>
>> Do you mean, for the real HW of EPYC CPU, each given model, e.g. Rome,
>> has HW version updates periodically?
> 
> Yes. Real hardware can change slightly changing the cache properties, but
> everything else exactly same as the base HW. But this is not a common
> thing. We don't see the need for adding new EPYC model for these cases.
> That is the reason we added cache_info here.
>>
>>> Because current QEMU x86 CPU definition does not support cache
>>> versions,
>>
>> cache version --> versioned cache info
> 
> Sure.
>>
>>> we would have to declare a new CPU type for each such case.
>>
>> My understanding was, for new HW CPU model, we should define a new
>> vCPU model mapping it. But if answer to my above question is yes, i.e.
>> new HW version of same CPU model, looks like it makes sense to some
>> extent.
> 
> Please see my response above.
> 
>>
>>> To avoid this duplication, the patch allows new cache_info pointers
>>> to be specified for a new CPU version.
>>
>> "To avoid the dup work, the patch adds "cache_info" in X86CPUVersionDefinition"
> 
> Sure
> 
>>>
>>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>> ---
>>>  target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
>>>  1 file changed, 33 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 6576287e5b..e3d9eaa307 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -1598,6 +1598,7 @@ typedef struct X86CPUVersionDefinition {
>>>      const char *alias;
>>>      const char *note;
>>>      PropValue *props;
>>> +    const CPUCaches *const cache_info;
>>>  } X86CPUVersionDefinition;
>>>
>>>  /* Base definition for a CPU model */
>>> @@ -5192,6 +5193,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
>>>      assert(vdef->version == version);
>>>  }
>>>
>>> +/* Apply properties for the CPU model version specified in model */
>>
>> I don't think this comment matches below function.
> 
> Ok. Will remove it.
> 
>>
>>> +static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,
>>> +                                                       X86CPUModel *model)
>>
>> Will "version" --> "versioned" be better?
> 
> Sure.
> 
>>
>>> +{
>>> +    const X86CPUVersionDefinition *vdef;
>>> +    X86CPUVersion version = x86_cpu_model_resolve_version(model);
>>> +    const CPUCaches *cache_info = model->cpudef->cache_info;
>>> +
>>> +    if (version == CPU_VERSION_LEGACY) {
>>> +        return cache_info;
>>> +    }
>>> +
>>> +    for (vdef = x86_cpu_def_get_versions(model->cpudef); vdef->version; vdef++) {
>>> +        if (vdef->cache_info) {
>>> +            cache_info = vdef->cache_info;
>>> +        }
>>
>> No need to assign "cache_info" when traverse the vdef list, but in
>> below version matching block, do the assignment. Or, do you mean to
>> have last valid cache info (during the traverse) returned? e.g. v2 has
>> valid cache info, but v3 doesn't.

Forgot to respond to this comment.
Yes. That is correct. Idea is to get the valid cache_info from the
previous version if the latest does not have one.
Also tested it to verify the case. Good question.
Thanks
Babu Moger
