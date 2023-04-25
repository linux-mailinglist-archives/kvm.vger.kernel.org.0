Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0976EE4A6
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 17:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbjDYPW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 11:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbjDYPW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 11:22:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338A100
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 08:22:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnScHBiAEu6S1Cyqq97w+XMmFPo2MbopToxF4YdIKCrdWuYmSWyI6Tyvi8Znkj+9+RCeI5gFo+xYV1+RexDHkMhjdKRwASvR1TSSFo2z5Yo8PAjttKraxl7BO1M5r7n7D5zSFShdqBKca8Dn6FoYLAFmW/h/1WVORyEbVS971e/piAQ/PeOFSpkFqFfWPgiWprTsIfxGOB6iyXPDLsAwjrDPgpb8kGNAm1qkEoYX74K0ZWHI/ia48/tkzWd6jIWHbOfU25liT3moURVwG6akmJBw6pq9rf3gRPRdwLjuqChN9dHwbSzN0XUVbkdV+hRDTk52LbaO1NE9a9Y9SL4H7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHy/urKHOAksFyD2nJwv78kahqVGYamaV9TXSAua2rI=;
 b=buSADmme5wDsjJMPUzSf0ANjdpil3OonPUtcPyuHL2U7kxFaVmtnZbsY/1HwJYU6Dt7aoUE+4851dIr9Sr/y7V/p7c95aEGp8SWn2fDY4pJfx7ePSO17roKu8LvggBry1JwtZisjHwqR35wqZtlajcmp+AcUNXiUno/Vk6/Y3w3Omzrxo0eLTnlPrtyzF2LhrPi0motHDxUF3VkKBFYYgrFwDMQWibXpsDDR8aPVeus/EhtjFL/iAsGhyr25oMZ3ssTkpSBfHEnhmiuVxbpoiC71Mg9y3aCOMq+L3dfQRQdX2SGgYqa7VEy5nk46qFUC6FA5XG0lP9KFVhfle4Ii2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHy/urKHOAksFyD2nJwv78kahqVGYamaV9TXSAua2rI=;
 b=jtQiy4iI1AuZ4qfGqDkBvzSycR0OteHse2ToHuCJGZ23txtLoGqd+aztjqHr9kPsNNFqYHpOxesnXfU7kxgo1cxudPbxoR7draWU2vSmACPvY71QeozxSiavlAh7bCzAo+S0+SXt/Tjq/0C0oaGb3tlrAnbb/sZ8nGXo3TrOZko=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA0PR12MB8280.namprd12.prod.outlook.com (2603:10b6:208:3df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Tue, 25 Apr
 2023 15:22:53 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 15:22:52 +0000
Message-ID: <68ec523e-72bd-3d5f-49f6-ef4d77c618ac@amd.com>
Date:   Tue, 25 Apr 2023 10:22:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3 1/7] target/i386: allow versioned CPUs to specify new
 cache_info
Content-Language: en-US
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
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <CA+wubQCGyXujRJvREaWX97KhT0sw8o9bf_+qa6C0gYkcbrqr9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0113.namprd03.prod.outlook.com
 (2603:10b6:610:cd::28) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA0PR12MB8280:EE_
X-MS-Office365-Filtering-Correlation-Id: e56c8d68-2e36-4a0e-0cca-08db45a0eff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJTPsM9OCTeGL7QVkaTOeJN+Hk/OeclHnPDZIRO22h6p27xHKSpDwztQMP3al+E390LiOnGM7xE2sUgtZuxzMOPF4FJyqheXtiOkkOWaJggAuGyXGLXDdiunwMznogeME+SG8HJkvQnrenQOkJKNTyZtL3WI5Zer97v4z2Fvy0peOUd0dzdt3wYF1bLzZWEePJD3UUAFuPXJN3GVIMmyvOdFlu66tFcZOvKo/T03hUzjzZXQpwWxgjgzghEzWqr25DqGzzUQeHIdqsJ5Esne5GaBBa2Qw4B+rKLHI7Y+remGv2aTJsIBLogWpCcA5GMVbl19TQWgwfVIMqdLr18hJectBAbTktXiCSdeSuVrr3N0XdoKWDurOJ7gf9FMk3CQ/Drh6c71ftiClipOBF0J4CD3VUYCbiUB5BTsBpGw7Eu5OEr/y6wd+w+qqrZ5vsOpviEF4RACrOrkr0LG1wfAFRCCxRyfKOeZYmtUDOZC+bvrScfSY7s1k3H9EY83lAKWJOVLjRcL8bvCyfySR3f0tIpXFDVcRvVo7IoNecq3h/8SppjSPhAhYWA8Ba7kTew5JYg1x0lwC+2YU0bJkpT/9opYSxWtgA/iD6ilmS72+5eVAf9vWfbgRpV1XuW6KW1qSjhJ5DBN+Ijh+wyQHcc1pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(478600001)(31696002)(86362001)(36756003)(186003)(53546011)(6486002)(26005)(6512007)(6506007)(4326008)(6916009)(66556008)(316002)(6666004)(66476007)(66946007)(83380400001)(3450700001)(2906002)(38100700002)(8676002)(41300700001)(31686004)(5660300002)(8936002)(7416002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlVVb0tnbTdvejFhTE9QUnA0Ym51eVUxbS9HTStEQU9UcVVoa0daRlQyT3lu?=
 =?utf-8?B?bHMzWEZ5OXhuWFd4WkJSbTlwOW5QQUVubWZuemE3NGY1VDdFNUJmLzcrenNz?=
 =?utf-8?B?ZG9INmxRQWI2ejloVG9jd3MwV3R1c2ZxU3pzZndYcXFNbktHSW4rcFlpWXBH?=
 =?utf-8?B?SDNLbVdjeVViQzdmanNldVNma2RKZjk2Z2w0MG9iSkpRMGhIMUU2VWsyMEpO?=
 =?utf-8?B?NWFoMmsxMU16UHBTK3IyZUUzVXZBMU5GbWZsaEFjT2NFVXU4Z2ZwOUIvVmdG?=
 =?utf-8?B?WE9WV3VFcG9rb3RYb0lDYzR0bE9nTTMrVGh6Y0h0SU10OUlUS0NBaW9Oc2Zn?=
 =?utf-8?B?dWZIQlZ3bFRaY3I0R2FBTkx1WDAzL0RqOTRybUxLcEtKYkNpamdJNmJnWE9D?=
 =?utf-8?B?OU1HUHpYY2Rjc2loLzhmQi9kT3dwK2hFRVpKMEtaRnRNVnVsKzlYM3U0QXFY?=
 =?utf-8?B?Wk55Z3EyMjlSOHp6TDgvNFhzUkNWdC9qUVozTGphM2hnOXVYdTR0WWJNMUln?=
 =?utf-8?B?YUhQY2g5TXRQdzRhVzZ6TUhDM1BpMDM1eElnZ3N3OGlLdStnTWdqNjFGcFZF?=
 =?utf-8?B?SGlzalNTbkovRmVKWkxGeHNDTU9sb1VPWm9OeXZraytUOTRzNjdDbmFlTFoz?=
 =?utf-8?B?REpmWldnZm1EVEQ3S2hHS0IvMHdLK2oxWE1BL1A0VHk3M3BLMkdsTmg3SFhZ?=
 =?utf-8?B?eENUM2lQNVgvcFhPVVpqWGl2NG15dUFBN1hOWVRTbGZBWVI2Y3A1dlJRK3Vj?=
 =?utf-8?B?YWx1cTV1Zzg2MjI3UWNOeHZoWFU4R0gwa0RWNkZFTFVucXc3UDRLalQ4aVg3?=
 =?utf-8?B?MElMSWc5bHBzWWNvNFFoQ1d3d3lpT1JjTUNTZG9sdHBpVXo3VkpzamJFbFZn?=
 =?utf-8?B?dDVHWXlzZmpveEE0bEdyam1wTUZUYllmZGhOQkNpOUZ1Q29veFBML0daa05y?=
 =?utf-8?B?MCtyUnVTSkRDck10ZDA0QzUvMDNnZDQ0clpzRlhSY2M0QUVCYWlxLy81Vktu?=
 =?utf-8?B?OVFrRzNoVlRzQWN3WUxZVmpXQVZoTXI0OGQ2NUZQa3M2R0E5eVBBMDB1WHVv?=
 =?utf-8?B?NmVGR1l5QkI4bnk5SWlhdzJTTllBTERqeTJUZlNTMDNNWjh4NzVaUU1lWDNP?=
 =?utf-8?B?NEU2eWlyUUVYTk1LNVprd2NtS1ZrKzNwbkx3bDJFK1lRemNKdW5hTnNnVStt?=
 =?utf-8?B?ek5Ia3RWejFSRDVxQmduakJkSTJueXFrakJQNFZaaG1zekhBeWdwbTQ5amEz?=
 =?utf-8?B?RVo3YjJtalMrMFhUU0xsWGtoZG0wZTJ4T2Nhcnk1M3dOOFVRUDJvYnhrS0w4?=
 =?utf-8?B?b1hvVURvNEFDVW1JME5BWXA2ejg3RDlWVjlpZWlmRHBUTUVOeDMvWEJFQnlZ?=
 =?utf-8?B?cmVTU1J5R0RPVCtLUFYzYUxjNHM5T0NNZWJvWDRXTDdHWnczOGkvbWlxaEtC?=
 =?utf-8?B?aWJhcHdiMXRKcHVBK09qSEdwL0tBVUY1SU5MSW05ZTl1OTlCUDZ3N3d3RCt4?=
 =?utf-8?B?SzNqa05CLzNLMDdDQThTWEVGVGRVZU4xaUhFK0xTaVRjZGpHYVhwWkRDU2JP?=
 =?utf-8?B?VnJCeWMrUXBEU2dCRGdFRzNoT0Vzd2JYN2MwazN3VUwzek5pSHo2NWNvTzdF?=
 =?utf-8?B?cTBBNWwxQURQTzA5RGY1TG0vcmZGeGxpYmVnR21WNk1JeVIvM3dQeXE2U29C?=
 =?utf-8?B?MnBaR2c2bTVVMGxwS3ZRbW0xdUVvcGx3Ti93Q2RNK2RWUjNmUy9DL1A5K3NS?=
 =?utf-8?B?cmw3bW5NcFJyZ1MxdWMyYUU0SFM5U3FTYXhYaTAzaHlOaGVDbm1od0c4NmlU?=
 =?utf-8?B?ZU91WHFqdXFsSFZGTEwyUThueW15bnpJbWhoYndKdGtWYVhsUGQ0cEpFR0lh?=
 =?utf-8?B?ZkJEZDU4Q0Y4djdQRzdiMzlqSEZ5Mm84dFlabkFFbVd4bUVOK3NuTkZlS2E5?=
 =?utf-8?B?dDRqMDV5MmFRR0h4d093VTBQaXp2V3JzZXMxWTFBY2prOGFTYVpBZWJWQnhS?=
 =?utf-8?B?dzI4Q3cxdkdqa1FoclJGdkZtTEVrcEUwQ1FYVW94TTNRZ2QwTWltLzhCSWJR?=
 =?utf-8?B?K3VoTDdJTER4RnZ1NUUvaHdicjdEU3A2ZzdEK3BoZ3Fyek5MVVZwekN2VE1s?=
 =?utf-8?Q?fEKE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56c8d68-2e36-4a0e-0cca-08db45a0eff1
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 15:22:52.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXoGWV3tFLi7uK5ziZVSqU7sSsMqOuagLpcdIyENbDX0UxKI4poakX62nFaNuwI5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8280
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

On 4/25/23 00:42, Robert Hoo wrote:
> Babu Moger <babu.moger@amd.com> 于2023年4月25日周二 00:42写道：
>>
>> From: Michael Roth <michael.roth@amd.com>
>>
>> New EPYC CPUs versions require small changes to their cache_info's.
> 
> Do you mean, for the real HW of EPYC CPU, each given model, e.g. Rome,
> has HW version updates periodically?

Yes. Real hardware can change slightly changing the cache properties, but
everything else exactly same as the base HW. But this is not a common
thing. We don't see the need for adding new EPYC model for these cases.
That is the reason we added cache_info here.
> 
>> Because current QEMU x86 CPU definition does not support cache
>> versions,
> 
> cache version --> versioned cache info

Sure.
> 
>> we would have to declare a new CPU type for each such case.
> 
> My understanding was, for new HW CPU model, we should define a new
> vCPU model mapping it. But if answer to my above question is yes, i.e.
> new HW version of same CPU model, looks like it makes sense to some
> extent.

Please see my response above.

> 
>> To avoid this duplication, the patch allows new cache_info pointers
>> to be specified for a new CPU version.
> 
> "To avoid the dup work, the patch adds "cache_info" in X86CPUVersionDefinition"

Sure

>>
>> Co-developed-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Wei Huang <wei.huang2@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>  target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
>>  1 file changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 6576287e5b..e3d9eaa307 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1598,6 +1598,7 @@ typedef struct X86CPUVersionDefinition {
>>      const char *alias;
>>      const char *note;
>>      PropValue *props;
>> +    const CPUCaches *const cache_info;
>>  } X86CPUVersionDefinition;
>>
>>  /* Base definition for a CPU model */
>> @@ -5192,6 +5193,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
>>      assert(vdef->version == version);
>>  }
>>
>> +/* Apply properties for the CPU model version specified in model */
> 
> I don't think this comment matches below function.

Ok. Will remove it.

> 
>> +static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,
>> +                                                       X86CPUModel *model)
> 
> Will "version" --> "versioned" be better?

Sure.

> 
>> +{
>> +    const X86CPUVersionDefinition *vdef;
>> +    X86CPUVersion version = x86_cpu_model_resolve_version(model);
>> +    const CPUCaches *cache_info = model->cpudef->cache_info;
>> +
>> +    if (version == CPU_VERSION_LEGACY) {
>> +        return cache_info;
>> +    }
>> +
>> +    for (vdef = x86_cpu_def_get_versions(model->cpudef); vdef->version; vdef++) {
>> +        if (vdef->cache_info) {
>> +            cache_info = vdef->cache_info;
>> +        }
> 
> No need to assign "cache_info" when traverse the vdef list, but in
> below version matching block, do the assignment. Or, do you mean to
> have last valid cache info (during the traverse) returned? e.g. v2 has
> valid cache info, but v3 doesn't.
>> +
>> +        if (vdef->version == version) {
>> +            break;
>> +        }
>> +    }
>> +
>> +    assert(vdef->version == version);
>> +    return cache_info;
>> +}
>> +

-- 
Thanks
Babu Moger
