Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A74B6B0BA6
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 15:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjCHOma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 09:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCHOmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 09:42:08 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AED5AB65;
        Wed,  8 Mar 2023 06:40:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSgh3es5Z5+vlYFO1zPyMdi5FBourMj6biSuvvTnIi+167hoTcETV6MAAGpJdI49b1oVVPKNMMGg6D18I9eXj6XXYXrV2/sNBbsuZ+3xC/YA08Bm6/5oQ6JhDldOwR7N6DByGvKETqenj0GYkFKdtIzBgj9Ll795AFszlW1x/iX7vQetNNhrXFCU1g2PxvA3T4QEEqCThktWGccRFGjAQ9ZXINzCLdEilw0WqCGDd/tlmERMkDBrtHSlyr9B7B6XQH56C8hYhdykfSkGKj5BsIKpzVWPMGIUoSQ+e64QNOsbas4dThdvCVUdVou36R8V5U/GHJDbZNpJ35hcHOTPqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=atBV9oX8EnFArO3sNPcGS/SUQi/AFpC2Ym91MpqwLrA=;
 b=UD5pTTGH4pTv5WevtF6LLG3HAaCf2Msh1hAWH/1xQ6xqtutcwMtKH6nB9h/Gu3z2F7RGJCMjQyrVrDjee5CgQ7N7vDXlLNRyFZNLF9RIR+pepyk6pb5+mlxLTnWaLcllRgXQ+qMe10LI1AogmcyKziYFnhxSIEsgPFq5ngoOAiZXL7TB9Zi1UG0yZn1C6qFPM/vu68MF6H9CUEAyGwI1LuHuyKVs55oN/oq2SOMoROuoMIPwU8Wh70gQjdC7BuFWvP14I6SNtluQ5DMSUEZrd0njLVw5TlhvsfHiWdza+ziiNVIgjsNdzXF7cEiCffjiSHFr9uHI62sUOxUCPDXA2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atBV9oX8EnFArO3sNPcGS/SUQi/AFpC2Ym91MpqwLrA=;
 b=stnY6ehT4ECWT3mIjU2Exz9WqPIEeCTnDmShVLMi908UCyvufM0y0wornZ+oBOXWRSPlu7Nhx9wn5O+o2HcPyDRpirponP6DcCTgA3X/6fzvRv8LvrDAiP2cXTlIZn92OuSu7A2nLiKNXjBK1lp0Ip6vkdfpP4uXB0PSGtQ9kA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH0PR12MB8529.namprd12.prod.outlook.com (2603:10b6:610:18d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Wed, 8 Mar
 2023 14:40:14 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%4]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 14:40:14 +0000
Message-ID: <cd1c741d-101d-ea3f-f5a3-498e2f54af34@amd.com>
Date:   Wed, 8 Mar 2023 08:40:11 -0600
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
 <39f23da7-1e77-4535-21a6-00f77a382ae5@amd.com>
 <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ba8aae2eafdeb09ec1a41d45ab3c2e4cdaf7a28f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH0PR12MB8529:EE_
X-MS-Office365-Filtering-Correlation-Id: 0350dc34-a8ee-4eb5-2d29-08db1fe30747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuLh1bqbpiIoOFo3qtPeGo7l2wzFyQd+QzV2aZ3mVxTspuOuMBFn7EVxFqGPsGKin6s718LgMNFuGW/oTDzG1QY5loO/7EZDSn7nNmdUNv1I505O7kRLKagxbZY0/KLMddKFooWjtSM6d8/ZIZ9LASQjBTSwPkvsWeVWFl/b2pJe9njHW918AXJ/cApHEmpi0NdNO7IcpFiZSQJkCDr28s4ox1znwe10XCQdKDK7iTOKEA3O395YwOduH/XjkMtga2zDpzRfpPCBW5nELd/GnO5ix6Hux9kFati3UgyOzTe4Fz0dMB3eS7j7NUY9DCUvTEj5CGDxzpeXUdabR3uvae2OLo7zAUepK6O6hu1ETPZtdMtE3sFeUaCqbPDW+jE9nz+tpgM+KrmRlXxQwDAR1XeARrAcP3gKJu445oX/8WddOBMuY+sUKSLo9b8RfICrcHFb7Ivfvx0x+rRST615zoa6GwkOrKypIT/nfioKXBzd7z3F870EMLgEcuqjTUYk5n/qo6hgrw3vXfqqEkPFwHop+SHAfb2rtMiawrrN5TK6RtGuiqzyzqFGuaKu27PVE/DDXvDDhxYT/hB7b08cQ8yCfDXO0qhLLjtr90o+iop87SVkmVxlIESb7OZVLOSxAIDUqxL39fJlaivljcbb4IM1pvHkhIfHWK5BsBv8pXiTJ79MF7KzF4j2Po2BuKxFm7ShGjx7ZUu66yAvbhXbXB0xSJkvJ4uHx3DPjEVcWII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199018)(38100700002)(966005)(5660300002)(6486002)(31686004)(2906002)(53546011)(6512007)(6506007)(26005)(2616005)(6666004)(186003)(86362001)(7416002)(31696002)(66946007)(66476007)(66556008)(36756003)(478600001)(8676002)(4326008)(54906003)(83380400001)(41300700001)(316002)(8936002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEI2QUdac2tjWms4MDExdnEzL1dEWVN6cC8yRXA2T0lGTlhZdmxQTmREN0pL?=
 =?utf-8?B?akZFVm1ZdUpiclMwclMzNjhDcnpoMGIyb3JORUJ3MmhVbU1NYkdLdDR6aTlQ?=
 =?utf-8?B?Yis4MVA5cHMvY29qMm5DU0ZUSklhMG1vRldiRHJ1UE9NWFVrMzVLMHk1SHhi?=
 =?utf-8?B?bFFSaXdDY2xGYU5kZFZMemVkVUFuUis1VGJLQ0tld3ozSXYzVmFaR1YxZXN2?=
 =?utf-8?B?SWp6KzcydEpndzRDU3h4VjdWcU1oR0tRdkkzNEZLa25lSCtvUU41cW01VGJ3?=
 =?utf-8?B?YlR6M1hRb2h2UnJZc09GMVVwNkJDNTE3d0lTQXIzZlBVK1V2YWlNaWJiR2t2?=
 =?utf-8?B?K2FxaGlUazBXbWwyL1dYSXpLbGV6VXkzemNYRE5JNzl1VUhuSHFpNkZWSy95?=
 =?utf-8?B?NmVFSzMvdG5iTUdHb0tzVWx4cDd5NGEwTlhYQmFaeXg2bUY0R2VVcUxwUVcy?=
 =?utf-8?B?NVhLL3FLME4zVlNzT1BHS2ZSZ3B1aGZaUW5FdENNL0RUelBiOFNVNFZTcjRi?=
 =?utf-8?B?NjArc1JOd3p2bWs3UFBXU3AyWFN0TnBpYkwvWlZZeGVKOW1QREJLOTJSV2Y0?=
 =?utf-8?B?dlF1R1NIWTJsR2JaajFjUytPck9GU2RnOTAwZE45WTgxODc4cUFGTmkzNHFa?=
 =?utf-8?B?WldSVDEybmxkREV1OEcrdm1GdVZHT2FEUG0yL3pTZmI1QmlWRTB0MU4zdzh0?=
 =?utf-8?B?V3NGeWdWV3dsTzZST0pBZ1VOMXBsNW9GbHNsRWRXZDg3SzU1STFVM2psL0xx?=
 =?utf-8?B?STBHTkVCRm9XWjl1REFKRkd5QUQwcGluL3ZUL1UwbEhERmR1K281dDJuNmM5?=
 =?utf-8?B?VVYwQjdXakhpY2FleXdCUWtFUU5zSXJ4OGIydSt0UTZQVWlTdS9NZS9XRWhC?=
 =?utf-8?B?dytITW1ESmtWKzkzL1BWWHFRTE1lbEJlNkJPcERKaUxMNWhNcHdJUFE5b3Nv?=
 =?utf-8?B?dW9HQ0Y5ZkFSWENlRWZTVWVjQUtSMUNtS3pQM3VhUnYrQjZqTkhPYlArQzJh?=
 =?utf-8?B?djgweDNFbmdzTVpKSlUzejZqUUROd2ZKTFJic04vYkJRQXYvTFZhNU9XL1Zr?=
 =?utf-8?B?UEVseUVta0JiYmlORllEcWhyaVBiTFovdFJEWHY1K2QrdjQxVnQ0Z0hGOHBL?=
 =?utf-8?B?UzhvWjZzeVliL3l2UzVOQnFvSWRKRU51SzFNM01tQUFDZ0xzTjVIb1pxQUhD?=
 =?utf-8?B?b3JoMzhyUEgrWVNndFI3dERkV3NFMlFXbDFuZEpoZTQ2VzRLdHA1R2c1d2t0?=
 =?utf-8?B?a3hYMXZLTFFudFlpQ2MxalVYMG5LM2pLdmNLcFl3Mjk5N2JrNHF2Y09vWkFJ?=
 =?utf-8?B?WmQ1VTQyalQ3bGF3anR1Sng0eHBralg0NW5hbE43eW1wUGg1SjZjYkxBSmJh?=
 =?utf-8?B?ekNxeU1NVzB3alBHZERWS2VPZmlxNDlnL1NKcnpvWVFydmJlMmdOSTdqcGFD?=
 =?utf-8?B?VllNVGpLYThRN0RaeThxbzRTTGJmai9uRnhCak52MUUxUWNGOTJIU1dZZGNx?=
 =?utf-8?B?TjBQTDlQQlRKVjRnSldMWGRBaEw0RUEybXVCZ05nK0lydkw0eElMZUg3UGtj?=
 =?utf-8?B?U2VHTVZzaXN3SFE5OUl5WnRLL0doMi91Y05IRWVaeTFXeWd1d3EvYTZzM2Vl?=
 =?utf-8?B?S3MrWmdIbmhETXdTZHRhbDBVQkIrY1VneTRoWmh0blVoVXJOTUN6MjVVOWtH?=
 =?utf-8?B?bFFzQklXNDBPaVhBeFdCNE9TM3pmaldRelE2N0YxMUV1Ym4wczEyTURzY3NJ?=
 =?utf-8?B?RWJ2aVgvNmRMWUUwUXNIWHk2QWNnb3ZUS2Z0VzlnS0V0OVB3K1REV1ROY3dW?=
 =?utf-8?B?ZFJKSVd5Nk5DbnN2T1puRkpjTjZydzFoQ0NtMnM3VkhaaHBWYzNmWnhCbjNl?=
 =?utf-8?B?Wmt5R3owY0o2VVhmcm1aL0VlNXV1dmpONXgrOVZaMitGNzFqd0F5SEVBYVAw?=
 =?utf-8?B?RWREcTV6bjNESUVWVSt6SFU5aGlrWW9wbnN4c0Y1RHFxTkVSVm1aZ3RhZzJS?=
 =?utf-8?B?Sk1VSlNhaUxDTWlrcHFLR0FQNzBMWDlQY25xcjZ5SGh4dWk4R09xT3E4SU1H?=
 =?utf-8?B?SDZhUzA5Tk55MnlLUkExOWFHdmJBTVh3Ri9OYVExZ09XMm5XaXVNcUFrTEh6?=
 =?utf-8?Q?O6bry/mXwSbzZdF8UNeIR0J4H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0350dc34-a8ee-4eb5-2d29-08db1fe30747
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 14:40:14.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EoW9LaMGRC+IfM78IcXKc59x8lvx8UIHQOXjed6Gwjb5OPZC7OnlKcxbFPLB2PpqKFe3HblLenoq0Bu+fOx4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8529
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/23 03:04, David Woodhouse wrote:
> On Tue, 2023-03-07 at 16:55 -0600, Tom Lendacky wrote:
>> On 3/7/23 16:27, David Woodhouse wrote:
>>> On Tue, 2023-03-07 at 16:22 -0600, Tom Lendacky wrote:
>>>>
>>>> I did some Qemu/KVM testing. One thing I noticed is that on AMD, CPUID 0xB
>>>> EAX will be non-zero only if SMT is enabled. So just booting some guests
>>>> without CPU topology never did parallel booting ("smpboot: Disabling
>>>> parallel bringup because CPUID 0xb looks untrustworthy"). I would imagine
>>>> a bare-metal system that has diabled SMT will not do parallel booting, too
>>>> (but I haven't had time to test that).
>>>
>>> Interesting, thanks. Should I change to checking for *both* EAX and EBX
>>> being zero? That's what I did first, after reading only the Intel SDM.
>>> But I changed to only EAX because the AMD doc only says that EAX will
>>> be zero for unsupported leaves.
>>
>>   From a baremetal perspective, I think that works. Rome was the first
>> generation to support x2apic, and the PPR for Rome states that 0's are
>> returned in all 4 registers for undefined function numbers.
>>
>> For virtualization, at least Qemu/KVM, that also looks to be a safe test.
> 
> At Sean's suggestion, I've switched it to use the existing
> check_extended_topology_leaf() which checks for EBX being non-zero, and
> CH being 1 (SMT_TYPE).
> 
> I also made it work even if the kernel isn't using x2apic mode (is that
> even possible, or does SEV-ES require the MSR-based access anyway?)
> 
> It just looked odd handling SEV-ES in the CPUID 0x0B path but not the
> CPUID 0x01 case, and I certainly didn't want to implement the asm side
> for handling CPUID 0x01 via the GHCB protocol. And this way I can pull
> the check for CC_ATTR_GUEST_STATE_ENCRYPT up above. Which I've kept for
> now for the reason described in the comment, but I won't die on that
> hill.

You can boot an SEV-ES guest in apic mode, but that would be unusual, so I 
think this approach is fine.

Thanks,
Tom

> 
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/parallel-6.2-v14
> 
> Looks like this:
> 
> /*
>   * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
>   * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
>   * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
>   * hard.
>   */
> static bool prepare_parallel_bringup(void)
> {
> 	bool has_sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT) &&
> 		static_branch_unlikely(&sev_es_enable_key);
> 
> 	if (IS_ENABLED(CONFIG_X86_32))
> 		return false;
> 
> 	/*
> 	 * Encrypted guests other than SEV-ES (in the future) will need to
> 	 * implement an early way of finding the APIC ID, since they will
> 	 * presumably block direct CPUID too. Be kind to our future selves
> 	 * by warning here instead of just letting them break. Parallel
> 	 * startup doesn't have to be in the first round of enabling patches
> 	 * for any such technology.
> 	 */
> 	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) || !has_sev_es) {
> 		pr_info("Disabling parallel bringup due to guest memory encryption\n");
> 		return false;
> 	}
> 
> 	if (x2apic_mode || has_sev_es) {
> 		if (boot_cpu_data.cpuid_level < 0x0b)
> 			return false;
> 
> 		if (check_extended_topology_leaf(0x0b) != 0) {
> 			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
> 			return false;
> 		}
> 
> 		if (has_sev_es) {
> 			pr_debug("Using SEV-ES CPUID 0xb for parallel CPU startup\n");
> 			smpboot_control = STARTUP_APICID_SEV_ES;
> 		} else {
> 			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
> 			smpboot_control = STARTUP_APICID_CPUID_0B;
> 		}
> 	} else {
> 		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
> 		if (boot_cpu_data.cpuid_level < 0x01)
> 			return false;
> 
> 		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
> 		smpboot_control = STARTUP_APICID_CPUID_01;
> 	}
> 
> 	cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
> 				  native_cpu_kick, NULL);
> 	return true;
> }
> 
