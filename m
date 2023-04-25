Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F136EE4D7
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbjDYPgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 11:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233442AbjDYPgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 11:36:00 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F671444F
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 08:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj2VvWZj8FSrh4Lx3UY/gJGKzWeYqqhxyzpyvRqN5n4VPO3O8JIVkw2gK9w39djWWeMvub+Q34A9cYW/PviLZ+4VSYUtMVY7X8UUegVoy9seLThAD9UDZLPDVKoM20uB0YlXmsfTbEkri4RT6DgjTvPKyk0HUFhwiH5v01tT0ctFvos3FW9lZPTeFM2qG9MQJOsp4VJgVZbfK6nKTkpkl0Z6k/+9SFsOBrdSg9WQrAgz/c4IYdJ4xWSJ1vzMuAxKrf2BiHRmJe+HwrW7fOZ/2ALddZrBra2Qf+sqqSUqyhImFmrw9J5teEiwuP7cA3vu2Rc5EOXrpDRtx3SmwIpasw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLnmXrc3bDPRMWPrHM8lwLBbuZ65L8iKgOk0YEdTG8E=;
 b=ZaEClV5Ll/WEqagiBe0e7jPelHiTwVdYvmX8n2TmH2NvOUKXkEn9HMnUZhyqbwRBeEwm4G4aW78gaC1HOnddDUMXwcf8B9ZP8T4MBcqVyoy4Xazc/UEQ9c3JYkRtSuKZjHmYXX2CEeyuwpT7Bp7Y85PG2L2PNGL7e5xAg1OIkKoA5e7AcObEGSfuwpmIGVpbxaSJOOdGV+RMgga6cBfTXXg2wGEBAVsA5CUwXXxxgVZy3MjhKCYQIb9mYObsgM0CzqGhW78YgEFgq4d82KZKD8Urv42SH5JC6jOB9G3Ep1MMw4gOGtOq2SY+8huqU+URWsBZ4Q3ICBItqDNxH5ah2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLnmXrc3bDPRMWPrHM8lwLBbuZ65L8iKgOk0YEdTG8E=;
 b=PH0MU/aABsr58NrdpgZHNchX4UBAugXCSo8fzrQUga1DyFfdGhVMZLiU5+LwQB1U80MGm3zmjOEvCoh2xtdIdFdU4QIKVqc/B7/xXCouOmAOZh5Y5yvnXBPly3Zp1Y+BOQKDmur8nffm2hq2lR53MqRnmp5+TsnD9AkjGbHj+ro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by CO6PR12MB5490.namprd12.prod.outlook.com (2603:10b6:303:13d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 15:35:56 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::57ca:ec64:35da:a5b1%7]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 15:35:55 +0000
Message-ID: <87b874ed-d6d6-4232-3214-b577ea929811@amd.com>
Date:   Tue, 25 Apr 2023 10:35:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v3 2/7] target/i386: Add new EPYC CPU versions with
 updated cache_info
Content-Language: en-US
To:     Maksim Davydov <davydov-max@yandex-team.ru>
Cc:     weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
        paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
        jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
        wei.huang2@amd.com, berrange@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org
References: <20230424163401.23018-1-babu.moger@amd.com>
 <20230424163401.23018-3-babu.moger@amd.com>
 <2d5b21cb-7b09-f4e8-576f-31d9977aa70c@yandex-team.ru>
From:   "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <2d5b21cb-7b09-f4e8-576f-31d9977aa70c@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:610:4e::37) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|CO6PR12MB5490:EE_
X-MS-Office365-Filtering-Correlation-Id: 242f81b9-7383-440a-3470-08db45a2c2b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQ+sF1LHT9ucqhCn0SHM42ZXp4ozkRgeMwZ/4zPaFJXRHAjFr+rpZJTgUx/ldUBWzcapM06nU3MBvzv91mJ2N+eED6zM5QzE3/SWzTwsnXE1TUrH285xhKVI7FTbLjBmvcRKo0PuktJsVqbsHLmnQJV5Za+JA4EjrqnIaI+6hPQV22Y14EKcdLdiw/qnMM1wbHOB/uQcHIg7jzuGKoycmWXkOzOONFac2ixrHxvzx3711I4Cbvt2VA+GRwr44v8LFOp3AasBOuYjAxsO6GwgnXMWjB+VcDeAVI0txaJ1tNl/5XVy5Ar3zcTGXMguGEB978x2tbWOhQmLzSQIUdXpeWpohg0K/9Bo/SHNdRCij9T5MiWfBzeznrzooFrOliBFaLt9VeMJyw3Oy9xKkimjQ0JDAMWDC6kwO0NghIDkTb4BDf4yGcWOrFmPWbTfYKdzZQ1V80J0P9IS+HzgK98I7IRjFKipajowxGmYFikV0Kn5m5hWXAUSEqRiTg2qEoZZSplY6+8HHG7bf+z9A1x+n9SrxbAAxNGJVDL7+i3IHwoXnoGV3yqdKn8GSHNdQv3KMGIsX5fvTG8XFVywPGRb/TBXyF+sAQ+MsHQFayUNGjcz3/VRkM6QnwUjg/IuvsWkdhO4+Fh9CRH3+bLSeREUUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199021)(31686004)(15650500001)(2906002)(3450700001)(86362001)(26005)(186003)(6506007)(6512007)(83380400001)(66556008)(7416002)(36756003)(478600001)(66476007)(66946007)(6486002)(6666004)(38100700002)(53546011)(31696002)(2616005)(41300700001)(4326008)(6916009)(316002)(5660300002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlN0S3ZxQTZWbmYrQk5Ncmo0cnNYQk9zZEFwYmRSU1RKRk1neFU3T1RZWStB?=
 =?utf-8?B?K05xaHAvTDNwQU5yWjA5d1gzK05NM09uY3p2dmhYNUhTT3dvRklWK3UzaHJP?=
 =?utf-8?B?aXNvdGdsWndaeXBZNnB6ZURtZUNLaVlENy9NRUViZ2NiMzBpRGhUM0VxQWVX?=
 =?utf-8?B?bEZkVFFWNUY5TTllR0VvNW16TlBIeWxNQ0o3WGlNb01rK3AweXlmUjdkZjFu?=
 =?utf-8?B?dzNlZUpnemhQN1ZuVVIxZFpWTCtlYWJOOThHbGxOUXNvY0VWdEUzaExTRUlh?=
 =?utf-8?B?YWxJWlY4dmVEckNpQzQwNXlQSk5LZVVOeGlTMFlZbUVtTUFmYlZ5MmxMc29p?=
 =?utf-8?B?a0k3aXVnWEVkU3QybmFyR2RDS24rY0ZRelRRZmV3bndQWDBPdVZRUzgzVFFH?=
 =?utf-8?B?aUFNQ1E0UTB5Si8rNkdudU1BbGZFTFJXb2s2QXE3Ymc5dnh0MkEzYUU2dTdo?=
 =?utf-8?B?c2ZLMzcvYXkrdWE1UElqU2xvZlJPNGxlNjk5NU5WWi9wejFtQm5iUytWWk9m?=
 =?utf-8?B?aGc2Y2FKRjVTKzlxS05DbW9QZWFWUzNFRWJ5WVZzSUdILzByZ0xZV3gwbFdS?=
 =?utf-8?B?TWtjUjc4RW5zcWNkeG83VHBuQkt4a1lOcXZEcHI3Vml3T0JwbUVxWWYrekZV?=
 =?utf-8?B?dGdjMnV6MUdQcm5OYzRicFFKUnByVEhWTXBLcURCNk1kTlg4SEdHaFB0NENY?=
 =?utf-8?B?eGJma2FPejZtV2J2Y05TU2EwdEFCUXFCWmtKcWQwSVowZmhabVdaK0RJUmpP?=
 =?utf-8?B?RWZPTVRvbDV6WFFqTU1HYUJ3WEtXZVRmWFkwQ0V3STVUQ0cxZW5hcmtVQXpT?=
 =?utf-8?B?TGNvUVVLT2FDTEZKMWlpZnF1L0hNZVpOZG9UcWZqZnJhZ1g1YVMxWDJxZ2Z4?=
 =?utf-8?B?RjFYV3VSQVlUU1lrSDlQSG9HKy9zMGJReHh3ZDFjU0ZsNldOV2crR2U0bWFv?=
 =?utf-8?B?R2hiZTZpeGlrYm5Dd1RlUHJJbmxFNnRmM3RHSDFMdmJDYm5QRXVjTUs0TldO?=
 =?utf-8?B?NExDS2FaSXJoZGp6aHdnSXRjTWhRT3VxdlZzaTVqSExPVE1QeVJ2L3hLNS9X?=
 =?utf-8?B?QkVjb09FL2Fwa2pUZWFXTHJNMVFNZmI4VnZFSjY4SFBsN1Z6U2ZVMzcrNUUx?=
 =?utf-8?B?eU9wdlpZRWxwaXVLMmNNa0tQUTV3SmVRK1NtVHhDWGduaTMrTUljcnc0cG0v?=
 =?utf-8?B?RU01N3pndjlpSGxWcExlR3V3aUhFaDFESVJwdGJtblkzTk1td1BNUkdrTENK?=
 =?utf-8?B?YWRpTjVodW51aVZ4cGdoWGJEdXFXU0p1OUJ4K3FLaldGaTJNZ0pTa2VjbnFr?=
 =?utf-8?B?d1h2dFRZQkhDeHFGaHFadm9oSFR1eE0yM1ExbWdjblVEVjJXWkV4MkpQK2dO?=
 =?utf-8?B?Y2N6RmNvWERiQ2VEWm5kKzNuTW9xRWd6V1VGR3plUWxqdFZEOU1zR2wxTEtY?=
 =?utf-8?B?VDRRNWY0aGk4ZjROZGlGNFFpUmNJQ3YxRHArT2hwTDRyZ2RoYm1Gdm1PZnZZ?=
 =?utf-8?B?YmlwR3NkbXNoNmU5bUVUemRkSmtlVzRBRzdpbzhQSTdWMUlINXl0RGNBSm9k?=
 =?utf-8?B?bXhreTVaanFIN3pmaHg3Ykw3dndGaEJxRkRyQ1gzM044TkM2Q1JkanhDendK?=
 =?utf-8?B?di9KdkVuZ3JNd3duYjJUM3hndTYrVlZqbUlYaHNuMHIySTBTcnlRVmJTeXpH?=
 =?utf-8?B?ZUlZMEluUFEraGZNUXRpZGk0dnBtOVh3OWN2bHk5SU5GekMrcmdnTXF3Sm1F?=
 =?utf-8?B?UEdQNUxoMWZnamhrZStBb3FBTndNay9Fb3hPaS90VCs4MHN2WDN3Q1liYlBn?=
 =?utf-8?B?dldmRVl1R2ZWT1JEM0JRL1FyNlRDNGREVmR4T2FTSWl3OENuYnNucWFMMXBm?=
 =?utf-8?B?eWVUbThqQ01RMXYxcExxYnBoSnRQVy85WisydzYvNmErdWgrcmFCSllWa0Fl?=
 =?utf-8?B?clprcncxbmJaK3hEYkg5NUVUZUFYODJuNlFBS3hTdGg5L2JpclAxWkp0cVpw?=
 =?utf-8?B?dXdNbDRsMWFiL0dTd29mOTlGQXEzUkRQN0MrdXFVdGY2Um43bFNNTXVrSmhp?=
 =?utf-8?B?aXdpTUtNZUZra1FpZ054SFR4MlJJMW1laStoVzhDLzQ1YzJVQmxQRUFBNm1k?=
 =?utf-8?Q?0ljw=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 242f81b9-7383-440a-3470-08db45a2c2b5
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 15:35:55.8680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eE+UXpYISPOPcnx1Mccbyn8VQRcnMMB80XlM9wDc4HzZVP7Za8k8H5AVSrLNv+Xf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5490
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

Hi Maksim,

On 4/25/23 07:51, Maksim Davydov wrote:
> 
> On 4/24/23 19:33, Babu Moger wrote:
>> From: Michael Roth <michael.roth@amd.com>
>>
>> Introduce new EPYC cpu versions: EPYC-v4 and EPYC-Rome-v3.
>> The only difference vs. older models is an updated cache_info with
>> the 'complex_indexing' bit unset, since this bit is not currently
>> defined for AMD and may cause problems should it be used for
>> something else in the future. Setting this bit will also cause
>> CPUID validation failures when running SEV-SNP guests.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>   target/i386/cpu.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 118 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index e3d9eaa307..c1bc47661d 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1707,6 +1707,56 @@ static const CPUCaches epyc_cache_info = {
>>       },
>>   };
>>   +static CPUCaches epyc_v4_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 64 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 4,
>> +        .partitions = 1,
>> +        .sets = 256,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l2_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 2,
>> +        .size = 512 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 1024,
>> +        .lines_per_tag = 1,
>> +    },
>> +    .l3_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 3,
>> +        .size = 8 * MiB,
>> +        .line_size = 64,
>> +        .associativity = 16,
>> +        .partitions = 1,
>> +        .sets = 8192,
>> +        .lines_per_tag = 1,
>> +        .self_init = true,
>> +        .inclusive = true,
>> +        .complex_indexing = false,
>> +    },
>> +};
>> +
>>   static const CPUCaches epyc_rome_cache_info = {
>>       .l1d_cache = &(CPUCacheInfo) {
>>           .type = DATA_CACHE,
>> @@ -1757,6 +1807,56 @@ static const CPUCaches epyc_rome_cache_info = {
>>       },
>>   };
>>   +static const CPUCaches epyc_rome_v3_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
>> +        .no_invd_sharing = true,
>> +    },
>> +    .l2_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 2,
>> +        .size = 512 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 1024,
>> +        .lines_per_tag = 1,
>> +    },
>> +    .l3_cache = &(CPUCacheInfo) {
>> +        .type = UNIFIED_CACHE,
>> +        .level = 3,
>> +        .size = 16 * MiB,
>> +        .line_size = 64,
>> +        .associativity = 16,
>> +        .partitions = 1,
>> +        .sets = 16384,
>> +        .lines_per_tag = 1,
>> +        .self_init = true,
>> +        .inclusive = true,
>> +        .complex_indexing = false,
>> +    },
>> +};
>> +
>>   static const CPUCaches epyc_milan_cache_info = {
>>       .l1d_cache = &(CPUCacheInfo) {
>>           .type = DATA_CACHE,
>> @@ -4091,6 +4191,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>>                       { /* end of list */ }
>>                   }
>>               },
>> +            {
>> +                .version = 4,
>> +                .props = (PropValue[]) {
>> +                    { "model-id",
>> +                      "AMD EPYC-v4 Processor" },
>> +                    { /* end of list */ }
>> +                },
>> +                .cache_info = &epyc_v4_cache_info
>> +            },
>>               { /* end of list */ }
>>           }
>>       },
>> @@ -4210,6 +4319,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>>                       { /* end of list */ }
>>                   }
>>               },
>> +            {
>> +                .version = 3,
>> +                .props = (PropValue[]) {
>> +                    { "model-id",
>> +                      "AMD EPYC-Rome-v3 Processor" },
> What do you think about adding more information to the model name to reveal
> its key feature? For instance, model-id can be "EPYC-Rome-v3 (NO INDEXING)",
> because only cache info was affected. Or alias can be used to achieve
> the same effect. It works well in

Actually, we already thought about it. But decided against it. Reason is,
when we add "(NO INDEXING)" to v3, we need to keep text in all the future
revisions v4 etc and other cpu models. Otherwise it will give the
impression that newer versions does not support "NO indexing". Hope it helps.

> "EPYC-v2 <-> AMD EPYC Processor (with IBPB) <-> EPYC-IBPB"
>> +                    { /* end of list */ }
>> +                },
>> +                .cache_info = &epyc_rome_v3_cache_info
>> +            },
>>               { /* end of list */ }
>>           }
>>       },
> 

-- 
Thanks
Babu Moger
