Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69636AF9A8
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjCGW7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 17:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCGW65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 17:58:57 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3A8B32BB;
        Tue,  7 Mar 2023 14:56:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcTkyMUBMvhShSCPr++Ww3xy/5+SzV5RwddUIde1m6momLqCE0WqUAzK+GDk+Apa5DcfNBqt3JXvcUEVV5GQi8kJ51j1Tb09/nQm6r6JqWGMA1nlK9726L591ami/qHNO09yTVTg0nckjnHQirPmh2GakJt/FfYR6MkFAhS0Jih+xexrc/Xgho4ch01ErVh6P3UC2KFY6EM6RZJwUGcRXFYEoqyp3Wce1dLuPk//AqBvLBLEUN+aMMQ6PmdZcV0g3cPt46BZ5kAtsp0CpUflDXK/3io2TfsP90SS1jmAKJo6ebYRZaIWXVuHaiJ0DOvz5cmg7xESawh2XcWGgRSUig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deaFiqqXJ/IQSeWCnYgkmJ6i+J7OB4naPISInv74jeo=;
 b=oH+zljN9mF04qpaVZqNFoT16sZaD3jCPd3n7STbWAtGaVVZmgyI6i1nDonltqB3wmwovR1NRVoC8zfUwh2IUCmOh8TCOYf1XUKiL/mtrLY6SC9K7twQeeyzQzs08d3/ynZLvTpwPHCUIUxiTaDAVXP4iDIp0302gV8MUWT91ncGGncdGtkGy2PVY+vbdQAyIZGxinSveoGxTgsV3NUQ+n2beypdAe5yiLpItnx+d+x12oT369Tp8Q/EYjUH61pqd3Hq9DfIz578tX+k0OMsWv4syr3ZBqvowrb5MZHuNSJ+RdrIOFm5tKLPlZ3Tq9WT8rIW2HMyuFMjLnI13OBDfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deaFiqqXJ/IQSeWCnYgkmJ6i+J7OB4naPISInv74jeo=;
 b=DGkovre7uLmwu9k/qnEp3fam2SrHDVGyGmW4lE9YT5kG7rAng7frAg3CXJzuuSAQEKx/EX0grZ7qh97IN2o4QK9o4uPWdPfWLL+US/y6xNWu0VFRJeHZ1flqIBJP+1r6ZOmJHoRValvWr4RK2pVfq7JONLxgIoDpODumIyCmbj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9)
 by SN7PR12MB8132.namprd12.prod.outlook.com (2603:10b6:806:321::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 22:55:34 +0000
Received: from BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::47e4:2d8f:4458:500c]) by BL1PR12MB5221.namprd12.prod.outlook.com
 ([fe80::47e4:2d8f:4458:500c%5]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 22:55:34 +0000
Message-ID: <39f23da7-1e77-4535-21a6-00f77a382ae5@amd.com>
Date:   Tue, 7 Mar 2023 16:55:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v13 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "brgerst@gmail.com" <brgerst@gmail.com>,
        "Rapan, Sabin" <sabrapan@amazon.com>
Cc:     "piotrgorski@cachyos.org" <piotrgorski@cachyos.org>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
 <faa0eb3bb8ba0326d501516a057ab46eaf1f3c05.camel@infradead.org>
 <effbb6e2-c5a1-af7f-830d-8d7088f57477@amd.com>
 <269ed38b5eed9c3a259c183d59d4f1eb5128f132.camel@infradead.org>
 <0c56683a-c258-46f6-056e-e85da8a557db@amd.com>
 <3bfbbd92-b2ed-8189-7b57-0533f6c87ae7@amd.com>
 <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <1975308c952236895f2d8f0e56af9db288eaf330.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0366.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::11) To BL1PR12MB5221.namprd12.prod.outlook.com
 (2603:10b6:208:30b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_|SN7PR12MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 07269dc0-f55a-4187-efc0-08db1f5f0f2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tCZGTD+c2M/qaCaeJYRWzSxbYsxGFV2L6P8sqm2NAYfT0JeL7c0lwr+SwNx8cWbXjCgEvgJQW9usv6rBQGXpViYlVMBJz3pHKgyYz1JuWedHB5ffbIqXuUWp624dxVjoJIMWTG40MUpG4YVmFMDuxDOO1+m4DizeJmq1QOulYJ0P/ipJhdMLh5fXm12mexpstwawHwHEI0P7yqpWFzBb1ZVRQYsb1ENB2O2zUeKP7LVaF0Tb8j6Ogbd+mipen6tnfPNmwgpe/WC7GwbixMsZvXqed7SoKIXioM1CHgeiu+0iMonkBciOGC2YVMR+AkcJ8T1Wfm1FvoEv1gmwkvmigahOLqxetg5cXagdt1Ri6WsfNwTY75PRbU6nxTNZFmyqJ2tUQltQj3EHM5uOXdAMPdx5TTMyozQ5XTkThmFDlwSsW++3Rv6o/VdA3IX+yY+S7n/2qXHE1Ru144LvbzwF2lUdOkH7LLy5IOx9+7UE1b4XDLuAJ2AFm6KYcJQAqyeNT5dCYSMrqukWapnpG0wOGeQLjuoMIBgTPxDwgyhFUflSP6nVUGpCw8VQsFqiuHHj1ZzpIjeZubX+s4hSeZdBWA5PVEeHMWIBjWtyVHxt09s3LJNeSAFI0Th7QQ/eLZS7hnY1OKut9LyZIky2QwPBMwMvS2TYyZcYL5asrNqVYpk1cHSeqx2p7Y2Y5nMTM/zmrNEcuqR4KoAM0DzypPt7ogM+liqj2WuXagAfqNXhUsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5221.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199018)(478600001)(5660300002)(7416002)(186003)(26005)(83380400001)(2616005)(6666004)(53546011)(6512007)(86362001)(31696002)(2906002)(36756003)(6486002)(6506007)(38100700002)(41300700001)(66946007)(66476007)(66556008)(8676002)(4326008)(316002)(31686004)(8936002)(54906003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHVNbkpOVU1OUktJTnFuenFjNkFTMk5TMDRtRWFHckVrRW4vR3FDMlN3VEMv?=
 =?utf-8?B?aHlEaTk4T1VONVhXZzVjRklCVmlEdlVxVnlYOHV6UEtwcE4zbFFISnFCWm5j?=
 =?utf-8?B?U1prVjVvY3hWM25IeUVLenhIVFNnazhreGdFVFpud2trRm9YbFFmMEQrNGw4?=
 =?utf-8?B?Q21XY2tQTjR3OS9BMExvQnBmdXpxcU1lS2Q5QWQxMGg2ZWNqanJsSXdBQnBu?=
 =?utf-8?B?UDJBd081NklGOW9Cc05uN0NjUGQwSFBVbEM1bkt5QllZS1pPS0ZES1JEL3V0?=
 =?utf-8?B?RUNwd245dUh0SFVyd0UvQUU3ME1HQnVHVVl6UnZiNFNvQUhCb0tLMHVRYjdm?=
 =?utf-8?B?SW44QmZleFhNbVNGYzZnWTd4cDVUSEVlK1I0b2VEbGlMaWtkM0JTU0oyMlA4?=
 =?utf-8?B?L3FGM0M0cHN5bzMyYmdtNXliVERaeWtCRi9ncDVLUFhqK0U3b3NpckJRYmRu?=
 =?utf-8?B?MjNtZFp5Qk1mOVZGQ25LaENHNTkzak9Bbm14akRFZ2N3UGRoQ2NNcS82R0Rp?=
 =?utf-8?B?N09hUjFwbDBkWG9ObVNoSU8wZ1ppMThmL09jQkxGN0p5S1JzY0dJd0xMZEZw?=
 =?utf-8?B?WDRiZVIxODNpdzNYOHM5SkZlVGFIcDU0UnlHd05SN3VkbTlCa2FrU216dGRq?=
 =?utf-8?B?ZFRLNGI5YURvZ2pNYVZId0wxRHp6dy9MeU80QkVKSnRWRUNhV1IwdDNiMVJ5?=
 =?utf-8?B?UmlMVWppVUFIZzk0R0VieWJ1UzZwRHRDbmk5TDVlUjBhMVozZWNBU2VleEpL?=
 =?utf-8?B?aDk0YkdCQ3BqVHhVQlhNZlluTDcyTzhBQUVuVVl0Z2U3MlhVNE9NQjNuc2tF?=
 =?utf-8?B?Y29POXZsR2h4dzJ0UFJiVk5ZZkhhR0x6dkp6bkxLZ3ZJQjVlOWlHZUlDdjlj?=
 =?utf-8?B?Zk1HcDdpSG96T2lEQXlOYldiTWxVSGN2c0ZVU2w0NHpvci9jZjdOc3NOSXFS?=
 =?utf-8?B?UG50Y3B0WWVPNEVHeXJRUmxjTmI1emFHZXFpZWg0S3ZIdEhMOERJcXMvT0ha?=
 =?utf-8?B?ZTBuOUlZNlc0MEFiMjdyTDhLa2gvWlZiNHMzOVBTUmQvRHNmenFvQ1VURmMw?=
 =?utf-8?B?MzdiaGdtTzZ6T3VVSGxaWHhwUjlyVjkyVXUyY3M5MXNLRzluWDd4R3FKeFhU?=
 =?utf-8?B?eDhRcEhsYVI3MHBLdW11aE9RR05ZSDhqWjhHN09BeWNaQkQ1RmU4VWtlZFE0?=
 =?utf-8?B?RmdzTGNhZEE2cVlzOEU4SnkzWWRhQU9Pb01wWE5GTjhtQ2xCOVpPZURtQ1pl?=
 =?utf-8?B?NVdDRWhpOEt1ai8wZys1SVpnWjdLSGc1MytoVDhDVEZDNEJFTDRUNDA0WjhO?=
 =?utf-8?B?UlZRN0VPbTk2TXJ6a1htSUFxbE9sSWdWUnhEa1pZTkZjZGk2dnk2aFpVMFRo?=
 =?utf-8?B?U01SbVFpZ2oxV3dJdXA1WjRCMkhMTDlYcEsvbnh1WGs3UG9oMi9rL21QUi83?=
 =?utf-8?B?Qm16V3BSMk0zUmFxS3BIRmxJbWJpUzRIODJiSzNxTlVua3E2d3ZYYUhWMStK?=
 =?utf-8?B?dGpwWnljL25QM3Z2MnhYSFB1cWdES2tNYkFyS050QkwvaGFpSHh0MVVFdDk0?=
 =?utf-8?B?UWJrV244Yy9kSDMvaU5jY3E1QXZTc1JqcWhNNjJaQ1BoRXY1NU9pUzZlZ2dN?=
 =?utf-8?B?aHE2Y0hzODlGZWkvblJQaHVUbzUzQUFXUlpxRGMrVGhUdzNibEhsM2pFeUth?=
 =?utf-8?B?ajVGeW5XSG5rQkRyQkpraFdMcVRuZFlyRjlzNVlXbW1aVE9LQWFuSVJwV0p0?=
 =?utf-8?B?eVJCcXhVMjFJU1VMWjBHNUppR1lFRlliQlpOWXFtVmdwWXE2ZTFwS2RyVm5Z?=
 =?utf-8?B?NitZcmRtcU42ZHErUkltNXltbm9HUXg1T2c2T0cvVld1akFHdVRvT1N0VDR3?=
 =?utf-8?B?djl3d3dmN0FFSUFMdHlxeG1venF3SDhnUHBsNmtTZ3JvdEwyS1VMNmZ3MXJv?=
 =?utf-8?B?SS9JdzE4Q3UyOTIzU2RSZmMxekMxMWF3cU1aNGNSRjVhQUN6S2RDdTNFVmMr?=
 =?utf-8?B?QWkwMW9FR2gyLzFNK29WK1RNRElobWcxVFI3R3RwUDVtK3dsWVdrZXZ2SEVu?=
 =?utf-8?B?ZERHMit6MzU1RzdCV0hDNytlQisySkNjcjg1NVJpS2JxRStuY3l6K1oxdFUz?=
 =?utf-8?Q?2nYzajmGeTSTSYlHZrFD3ohl/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07269dc0-f55a-4187-efc0-08db1f5f0f2e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5221.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 22:55:34.3283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yY7whsbNzQer4J31LVAmxvQlQpKzUIPpxtip4yBXRrHOggCHxulxNNNl2yg6hEVe0oGHlaJKaNMVa2hpFIveqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8132
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/23 16:27, David Woodhouse wrote:
> On Tue, 2023-03-07 at 16:22 -0600, Tom Lendacky wrote:
>>
>> I did some Qemu/KVM testing. One thing I noticed is that on AMD, CPUID 0xB
>> EAX will be non-zero only if SMT is enabled. So just booting some guests
>> without CPU topology never did parallel booting ("smpboot: Disabling
>> parallel bringup because CPUID 0xb looks untrustworthy"). I would imagine
>> a bare-metal system that has diabled SMT will not do parallel booting, too
>> (but I haven't had time to test that).
> 
> Interesting, thanks. Should I change to checking for *both* EAX and EBX
> being zero? That's what I did first, after reading only the Intel SDM.
> But I changed to only EAX because the AMD doc only says that EAX will
> be zero for unsupported leaves.

 From a baremetal perspective, I think that works. Rome was the first 
generation to support x2apic, and the PPR for Rome states that 0's are 
returned in all 4 registers for undefined function numbers.

For virtualization, at least Qemu/KVM, that also looks to be a safe test.

Thanks,
Tom

> 
>> I did have to change "vmgexit" to a "rep; vmmcall" based on my binutils
>> and the IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) change I mentioned before. But
>> with that, I was able to successfully boot 64 vCPU SEV-ES and SEV-SNP
>> guests using parallel booting.
> 
> Thanks. I'll look at retconning that rework of can_parallel_bringup()
> out into a separate function, into the earlier parts of the series.
