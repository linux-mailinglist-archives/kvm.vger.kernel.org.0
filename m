Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52A96C702E
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 19:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCWS2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 14:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCWS2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 14:28:47 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B32A10AB8;
        Thu, 23 Mar 2023 11:28:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDzSJRXkOHD5fm9OdAVJIrn3OQ+xGPYOnIEjEI+XAjyxeKfAP/5+fkvukanBk7SgqHw6nlsMxojJeVh7ho+v4ejw9BZPnINn409FsYQEEkodO0O2Q0M26vBzDvDm7oDmpOM5LgfYJ8CyCofe+Pp5Lsmg4nkBgK/I5CbMYCyzbva+6jFv+qr55FHU00dczZJnXm029TDq9Bn3d+qDdFflret0rJBhbrrSc/aaRBfZZ7DqFQ6i+Tw44Kq52UjXotE56aRn/2/6gEwHeOSPuoO0GglS16S/wAROeyiMbUzmchD6BqrE02XWWiok7OpR42pfYK46ZHFnNBJ0As+SmjyLTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wl227QzWtprzs2Acd+G561gMA+OsNwnDcjRriI5KEM0=;
 b=I+luw208awt8LMCmzTTG/EXlsMNzea6KXRrduKRlRYC55Bn0iKDRNkChqr+WXLeRHk6JODF3pogtG5Eljq91TA1O258ZLchaPLIlj/L1EN4uAzCu8mKI6RIKR7TuG97WGZd1or5S0Yn6QDEjMI08D/zxwq785BBZP+3bpAotKQ+6vlVXQVHgn2be0DpKxDotVf0HiaT/lOEpmQDySwJ7ArLt4m4KpHY+5j4/RtVnRUdYVEWnqgTjTEYWT+ukV+dhROEmvUUJ/9AL6A/4O0IUouov5U1viwtYogUawRG3wfDwuc7LK//HSYPaN/n+GpO1+gsBKwsCvB5OGN+dRCkajQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wl227QzWtprzs2Acd+G561gMA+OsNwnDcjRriI5KEM0=;
 b=2udb98OBPLsaoCHM+qe4oCn6oV9o8sbpyHFfeu3zAKb8mWhXS4juusU5UZpwgdysimRg14lDvKj8SatVlIKaxdg/OxskduFB/I0Mq/jkIu9KulsQ/KxF/JeThQDJ5Pv+XcJ4AbNfwVempvSkz3hc5lZ+0ePa3DfQAvQkJvD6eMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MN2PR12MB4536.namprd12.prod.outlook.com (2603:10b6:208:263::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 18:28:42 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 18:28:42 +0000
Message-ID: <19ec60aa-fa11-c44e-a6d1-9583f2e7707a@amd.com>
Date:   Thu, 23 Mar 2023 13:28:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v16 8/8] x86/smpboot: Allow parallel bringup for SEV-ES
To:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "kim.phillips@amd.com" <kim.phillips@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "gpiccoli@igalia.com" <gpiccoli@igalia.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "Rapan, Sabin" <sabrapan@amazon.com>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
References: <20230321194008.785922-1-usama.arif@bytedance.com>
 <20230321194008.785922-9-usama.arif@bytedance.com>
 <20230322224735.GAZBuFh9ld6FuYEyoH@fat_crate.local>
 <2c3dd773-31ca-d4b1-78a2-b39f3785c7c5@amd.com>
 <751f572f940220775054dc09324b20b929d7d66d.camel@amazon.co.uk>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <751f572f940220775054dc09324b20b929d7d66d.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:610:60::32) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MN2PR12MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 42f9d9e4-52a8-4570-1a69-08db2bcc6dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pu/INOTsl8/YVKgz5vShmTDkF5PkPJtig4WiH5t/dLzCUaMHKsYBI57pgqDkX9MIA9q4EAe3RfBLD655vQBqcjMCyhno7BKcChPLW2F3WOamkdHou8B4OTdwO6DAM4jcWcUnR5tBuD7uOHY/IyRPpP6vf41xEOtT+5Dty3wGvtLk+bjbrlFncTJHB+rk1dMorXGzCfjcPB27ZLUh9RfEPuJUkpD2edK69Hs5LMrqBwuL7n7LoCj4LJS3PP8QYEYsKiq2R34g+0DHAHMaPgj/2EIL+D/GjOk5av3GW09xePmwMUVeVQiQ53Yxa02MuJi/SiJtd4dNMm8DP3dPciPLj1PaPiO5+BEhdBMqByxLSJLYM1hItjiVglxaeyNWjGYTH4TVbVE4VFntqupCp4fJ89Um1eXR+8owvQp30voh3lRLukaN0sdTfvJdJqGMUCCgGw/8T+vhRb5OnrTMS2/VX1Zq5KdbOzGKqX+6PUNlaoZHBPVOyECCGbSAZtwlNgM217ymNjzlZ5elej7hfY3nQjL/EZPPTGP3amyvoKy3Y45a1xIXI1erWRmMrDoKOVJ2Ar8B9Z7P7pTztNosarjYgDgAg2/IHjErhySDyWkS8km+FGOaky3qXbqewkEtLxq6eVPO0XpsbOUBXyePqkelr4TJJHF+U561UvmvWnWx7T0lq5fezcphi+S6wbNo6I7mx5Pr6LdZqnAfviW/xmdAzy0Q/6HkStPA101JjqY/0Rs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(31686004)(8936002)(66946007)(66476007)(66556008)(41300700001)(4326008)(8676002)(86362001)(36756003)(38100700002)(6512007)(6506007)(53546011)(31696002)(26005)(83380400001)(2616005)(186003)(6666004)(316002)(478600001)(6486002)(54906003)(110136005)(5660300002)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2N1N29mcU11TkJXd3ZqbnZkQVg2RmVPcURIWTZ0S2M1TEM2aW5POTFIS0pY?=
 =?utf-8?B?Nmk5ekg0Und6QUp2azFmRDQxb0pOYnR1dDJjbHVXeFJHUFQ4N21KMDAya1Vw?=
 =?utf-8?B?OTZVbllSWGJVeG1HOWhvRjNyUjM4UlJWamtlSWdkVmJ3enR1aFRyNmRjNkw4?=
 =?utf-8?B?c0h4cm9Id3p0SWQxclNOUFRDQXY3VnIveTJZeDhaaDhGa2kydEdZSjQ5K2E1?=
 =?utf-8?B?VkUzUmloL3p2dmRGN3VsVndXSmVxU2hrN2JNYjM5cSt1bWVJUy81ODQvRnN2?=
 =?utf-8?B?QUFmVzJuUEVzUm1GN1BjZlFzbDVEbmo2VlpWeFlSZDFUc1o0cFF6bUFsOHEw?=
 =?utf-8?B?amRXaW55T3NJWG5KZFRUZjh1UGx6cUM3VzQzeXRBb0YrUUx5dmhKL1dKNnA5?=
 =?utf-8?B?bUYyc0NxVi9scmwzRU1QSXE0OWJIQVp3MEVsSUFacVpMQi9GbGM0aENzZ2pV?=
 =?utf-8?B?YWR1UEVxdy92OXV4a3E4aVlURDYzNDdrTmFraEJ5U1g0aWExTzI3VnlqT1FF?=
 =?utf-8?B?eGF6aFRkajBzZnA3eWNQempYN2JVZkVqTXBFUkhNa214R0FNZ1R1QzdnMkZL?=
 =?utf-8?B?dnpDRlE5UlNYV0tKMEloeVVLNGVJd0RqeU5BR1ZsaXl4V0dVMGl1dXZwS2hI?=
 =?utf-8?B?VHErL2RxMFE3OHZoZUZVd3EvS3Q3R2pNRjhxMnA5UytWcHFEay9lbVNtdzdv?=
 =?utf-8?B?RkZZRUZsMDJpeWtwVVZRUTJYdHp2NEJaUjE0WDJ6aGVyaEl3QWJsRFJkdUZn?=
 =?utf-8?B?UEUxOWFwaW8rNDFTWjRZbnByWmpHR2M5MTNqNHdFV2ZoKyt6Zm9FUlBxS0Zl?=
 =?utf-8?B?OFR3R3dUMklFYitOSFQ0R0xJWWh6YzZ3Nk42ZUtmNkFIOTB1a0RnMnNHbUlQ?=
 =?utf-8?B?d25oMlVJZ3FIQ2xGdEcyQ29QZHZMVFpDb2N5YWxmekFsL2w3ZXplOGlKdTdk?=
 =?utf-8?B?TGo0ck1LYnZUcUFXbnlSUm1IM014dXYvN2w2MzRaUmdpeFlVYS9CUWg1Qzlj?=
 =?utf-8?B?cDdvWkttSHE3U252TE40elBHWm8xQjRoNXNmL1NLdkZaWjc5cjBOS0dvd2JB?=
 =?utf-8?B?ZFk5amdRRGJrVmpaZXlZYWRhSStyM05zVkdzd2ZWSUdWNGg5RlAreHJydnlw?=
 =?utf-8?B?MUZjT25rYlFpSUpPaS90bGFCbktpd1ZHRUZQNVFwWDRPR1plQ0plUzhGSVA1?=
 =?utf-8?B?Wmg5aW5mWDJYc3dtOERJWHBGUDRuUThCVGtwZXpZRkJjZTVuSUpkMHJ0K1Zy?=
 =?utf-8?B?OC9JSFhLVXFTZTIwandXM0ZiWjNMS2pDME12alhRdGxPMWk2NmFrN0d3bXB6?=
 =?utf-8?B?S291cktOMlI5cEROZHFidU45Ny9BclR0RVFuWHNPT0Y2R21sTnpqbmp6TUl5?=
 =?utf-8?B?VUZTS01yWFlOOS9SNENlSHBwTXpGamQvaHdDM2x5NEJtSUZuRGpEK2QwRW5N?=
 =?utf-8?B?UkI0N1NrSG1OdWtsaGpEeGVidkZMeXdkNHhYSGppcnF3dFFPakQ4dkdvWjhr?=
 =?utf-8?B?MjlaVVp6dVVocFlkVDQvYWJMZFJUdkVYdUR1ZHhZUUh3cCs2QThIUHdmQm9p?=
 =?utf-8?B?NDlWOC9JcldWN0xVNUNrZ1lIZmNYLy9RbDRUcngweG1HNkZ3ekVjM2VMWHk4?=
 =?utf-8?B?bTVRLys1OHRwYUNEdHB6b0UycDRKNFNzL0pMR0t3SjdRUUpJRXV4dFA4YlJK?=
 =?utf-8?B?bVdtTXAxblpwL3dzVTZZWHBXa3luQWZESUlnQzNqMnRiTmdsSzlzSTFURGcr?=
 =?utf-8?B?TkVhS0xrakhuZjR0OWF3RVh1SGtRQXNZOXc1UFpXSUhxUll2OU1vSXY4aFJn?=
 =?utf-8?B?UUdCaGRuWnJuaVJ0ai9teG5Oc2JMcjFvQVFxMjlXWXVkaUV0SGpPT1pPVjZN?=
 =?utf-8?B?M1hlWUV3QVRIVFMvZys5NE1Qc1dyL0YzVmZHejVTd1hVQTUySnJLUk5uV2hP?=
 =?utf-8?B?Nndtdm91M1M1ckw1QWJzOXRLR1h2bWY1cG9nZXJqVkxvRjdEMnhSM0hEdkRs?=
 =?utf-8?B?NndSWVFvVHc3cEVmUkovWmpvYThlQ3lpN2cvenptYjFHcVA0TW5wd0Z4TmlV?=
 =?utf-8?B?VGF1eVdQb2N3WTVnNkZDRDEwWlVHQmFOREJLVTlmdVpCQU82ZjRCeVo5QnRs?=
 =?utf-8?Q?kM0jJttCjvFiemv5KGDMfg/Lh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f9d9e4-52a8-4570-1a69-08db2bcc6dd9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 18:28:42.0886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kf7Bw4+8wyD+HUjouyRiRcHD800WtQJoOts/crp+KvmJcJc1Z2xrdgcQtwaJ3GY4vpUrkJvCKQgdXTOZK59TVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4536
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/23/23 10:34, Woodhouse, David wrote:
> On Thu, 2023-03-23 at 08:16 -0500, Tom Lendacky wrote:
>>
>> Maybe call this sev_early_get_cpuid_0b() or such to imply that the MSR
>> protocol is being used and only retrieving / returning edx.
> 
> Or indeed sev_early_get_apicid() since that's what it's actually doing,
> and the caller doesn't care *how*.

Sounds good.

> 
>> Also, since it is a function now and can be used at any point, the current
>> GHCB MSR should be saved on entry and restored on exit.
> 
> Well, I don't know that it should be callable at any point. This is
> only supposed to be called from head_64.S.

I agree. But once it's there, someone somewhere in the future may look and 
go, oh, I can call this. So I think it either needs a nice comment above 
it about how it is currently used/called and what to do if it needs to be 
called from someplace other than head_64.S or the MSR needs to be 
saved/restored.

Thanks,
Tom

> 
> 
> 
> 
> 
> Amazon Development Centre (London) Ltd. Registered in England and Wales with registration number 04543232 with its registered office at 1 Principal Place, Worship Street, London EC2A 2FA, United Kingdom.
> 
> 
> 
