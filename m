Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D625E74D71A
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGJNLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 09:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjGJNLb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 09:11:31 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDC4C4;
        Mon, 10 Jul 2023 06:11:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kegvXHrmKwl9hsttcg+ISuaS+eB0AyzzBzigit8dDS4kYGdk4GyfoIHfBZCVlNtrf/I2z91ZgM8T6Rf6c6bP0dCr1JJRCp81SvrZ7hjb4jJrAnR0FsrzjgL7XK8sfzwCbSIcZdQSjSk2l4VLC2R65j6R7do38kJi9sbKvzh0W/+DA+c154gwY6X5uW4zq/OSB0YQZthuU9B2EfjpkI8VNiRlFlsRwG91okjvo6vETQpRPSK81VZ0Aa1ZLq9oeOyr9+O+N/8aHF41BjGnnCWxDP9pcyrKvXxbKxy1slHxHorvoQEvbhF+M89uZsBJAWLpwyNGUNAxOx3P55o8yi5H3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9LuWivrCUx2ZzaSRMGJ26Bniz5SiEQBB6xOHqphK9c=;
 b=ULWSBftWi541x8950+u/Dg5VUBkhMVC48fChvoqk24KCuPHymbpNV54HhSeNZuEgxbsBRUPK/3C8hJtH/2ka0Zm/Gf9J1NOsR1KBPXOI9O1Rcv5CBrCkiYydKF/7jAIiGRpep+NXa11pIW0uq3MPNxTvOlC0IQmCE78dPe8msrvtBv5j5OT3X5x86SEHPmP00wVJqNTIybxf1uXNMA5lJnQTKCBFYBTbADUMd5dHF0Pi90DEIcPeNxOz8WkgG4L7fBSjYiXE45QlQz+csUIAIiMhT95HlWpVl3w4tmhZ5DCmYTgq2lZsuC4lSjQH9YyFp22SnaxK4VQsZcHllC59HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9LuWivrCUx2ZzaSRMGJ26Bniz5SiEQBB6xOHqphK9c=;
 b=MhoEyJ/X/1AnrWd8duEd3xBzOi9MiGXBMdOYbSNW4zdhgU/H7CQnXxEpREivCLECfed0hNRbm6j9pFbIMwQIpaft6PqURheH9PZ4Ymy2O1uH0grJ/jRKvjJoP8ywbEF4lbx93yoNOhxWAj/DkwDy6VCC2GiVXPUQkoTPINnZXL0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN7PR12MB6888.namprd12.prod.outlook.com (2603:10b6:806:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Mon, 10 Jul
 2023 13:11:26 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c440:6819:be48:f4b8]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c440:6819:be48:f4b8%4]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 13:11:26 +0000
Message-ID: <6cc8c7b6-1cc6-8425-7c6a-7f2e42d5f78e@amd.com>
Date:   Mon, 10 Jul 2023 08:11:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 05/51] x86/coco: move CONFIG_HAS_CC_PLATFORM check
 down into coco/Makefile
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-6-michael.roth@amd.com>
 <fd4cf001-b600-a09e-050b-2b5ed94922da@linux.intel.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <fd4cf001-b600-a09e-050b-2b5ed94922da@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:806:23::25) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SN7PR12MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: b320061f-45d0-4e12-f5c9-08db814729b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRtFemPiawT7j+HAcu7dWDiXiMzwZHluxYaA8ZTLZ3hxeBopz7NDfCgrTvAKU3pnrPoWI1Kaqzebrq6WQ8fb0QGz0nq2P9PEyeYx0OFsPoAEUAbqmZV2yubKqiH8Ga7LsXHH8PnkRuWngT2DjiL6XVuV53kyit/rltv/0n5dJhRqpJkdF8dR3RIKyo8tWu4i1e/CdYwyKJ8jEgxfiPF93FAV3GPgYxfr+QbMY6CQW/9DX+SwiPjkCgmPaU25HmrQqFa7zO1Eizz7rEzTl+BpWxLcD9IKSzLkgcQ3RKURPnZ9zhFM3idU8LWEmIec9Y2+k8L8vZWbVE34TLbYE4Om5WW3zlOtbUAJsqSdPHApaq0coAsCaUE0x2c2a6KUij1nSpKNpIfAAOxNTh+psxRd7WlVqyWhsRoYoSglQfbX+CTWo+gwL9CAm/yzZpoN2z6g59jOWqTNWfrlx9fYcChwjCG6kRr3kae85QfOG+XTC25NCi1Z8ghhcTnQht0CV+4BtGIIquxm6ye65NKktLXyJOIaTSpKnVd1HMnmezrP1bTOuZd7IV2sFp8mMdhAt3c+bpQZvSEW8UaHICcDvhOJu4K1Bt9mUfLPRdhkcr4olC1UcLZ/5Uq5ge1u/61rJ3RLVPEm9cPIODKZnUBg7XfaDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199021)(31686004)(86362001)(31696002)(38100700002)(36756003)(478600001)(6666004)(110136005)(66946007)(53546011)(186003)(6486002)(6506007)(6512007)(26005)(316002)(7406005)(2906002)(66556008)(66476007)(5660300002)(8936002)(8676002)(7416002)(4326008)(2616005)(41300700001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFYrYzlpTXdnR0hsNmh2bW41RjZ0QnovYy91RjhEZngxcWFkTk56c3RDNTJl?=
 =?utf-8?B?ZHlOdUdrL3VCV0E3eTd5bUZWSmpMQXBtdWMyTDhHNUNPNkxzWFdndjRObXN2?=
 =?utf-8?B?KzZOK3hpc2ptbU1kZHk3bUxIWFVJM0NwdWE1Uk1vRjR6WEVHVzFpRWxyaWlY?=
 =?utf-8?B?d01WN1JxMjFUSnRwbGowaGJjMm0xMTlTY0V6ZjNRQWx2dEp1dUpXRWk2SWk2?=
 =?utf-8?B?algrYU95Q09ZcDZJajJRSHR6WVJqRE9qbXp4cXZGUHcyZ0dzT0tORVpGUytm?=
 =?utf-8?B?V3AvMUZVVjZkT1ZDMFQvUWVlc3plYnZIUTg4MnZDcWxLczZQU2dtWnJzK2FP?=
 =?utf-8?B?SlJXZ0k0K2JTVkx5czJNTXcweHBPS2c0Z2FCSlpoYVp4cGI5dnV1WHVhRk5N?=
 =?utf-8?B?SmNiOHRDaGFnVTdNSHo0ZGl4MVlVL1NWd3R0VXdnNWFMSlFUMTkxbzVsRHpu?=
 =?utf-8?B?dVdMSWMzQVBVNjBTZncwUVg5K3hONjkxMFJNcDhveVA4anFsTHAweTlmNElv?=
 =?utf-8?B?UlN5M3lFSktzM2JmWFZlUjFoV0s4ZDM3a2Qrb1JMd0pRUlJxWFhhdWMxYlBr?=
 =?utf-8?B?TlRqU1ZYOG9WSmwybFF3KzMwcUp6NWVEZlNucENKckF1bm5QcmFhcHNTUnlC?=
 =?utf-8?B?UkdJMFM5bnVUMmN3VmNrZlJaQVNuZ3d6aUpucDNuaTgwVjVKRHZMSHo0THZi?=
 =?utf-8?B?K1owU010U2pONzlERFFhYld5Zi9qanNVT1Axazk4VnJzOUgwbjdIZGJ1L3Vr?=
 =?utf-8?B?eWl4ZXJqaENaalZsdGFGTG0xbkg0VnRaQXFPUDlxS3d4SjlJb3ppRzFpd0x6?=
 =?utf-8?B?TzZxREZuZTNhcG1mVHZiV1F6NlVVa0FFdCs1dHgzL1p2bmJMbnhNS0lyRjdT?=
 =?utf-8?B?VWwrcnhFWkliRVN1RTROTGh5ZURWOWZzQTlSREpFWFQvazgreVgyWUNYUEVC?=
 =?utf-8?B?bWJEWU9kY1BRaFIzWGNmdExWalpxM0tHNm5pWUtpQmVzbTM2KzdHWGFXb2RB?=
 =?utf-8?B?dW1VUmlDeElxUS9NNG1rM0wwNGFBQ2NONXFZREdwZ1lPYUYzZWlicWYrZWNs?=
 =?utf-8?B?c09rOUZXU1JIb281aDFVYmNQclBTbE5VQlZyWEtwNE5peVRZcThScGRPOE8z?=
 =?utf-8?B?VFNtWGNWcUtyNE9tdTVvQ3FxMGdqT3I0b0E4K0VDYjYzSytLU2xFNS95TzJ1?=
 =?utf-8?B?Skc0SFM3dnFEUWZVdzIrTHpzL0JIWGFVb3cxWUxBTlNybG5Wa1pDSXN6VGR6?=
 =?utf-8?B?S3FjOGlOVThvVG9NcU9VeitaWTV4R2tmR3hYMGVuOWhta2NmTzRDM2NzZ0h5?=
 =?utf-8?B?c0c0K3Fua1J1a0lNQzhDNktPVXJQSkwzMkhHQk9Kbk5VMUJja1liMU5udUkw?=
 =?utf-8?B?Ry9QT3BQSEMwczB6YTRMZ01NNjgrK1RndEg4V1A0TktLTGhHQ3lweWNQMGxK?=
 =?utf-8?B?b2FYTERJRUNEeVQ4eWliclQ2aHhzaTZMNlNjaThLbDdBWWFmcnBwenNVRmpJ?=
 =?utf-8?B?YjhWT2d1RjlrTXZUR1NIRjZabEs1M05aeXpvaGpvcmk2a215QysxRkp4QWFZ?=
 =?utf-8?B?RU16UHhRWElXeXV5N3k5VEJUVWV0aFhkMnVxQ0lVTE9kOHBsWFBCNXdrdmNm?=
 =?utf-8?B?aVhGRTMrbTBJaDlCbE5pN082cVZvL1RTR0FqTEsrSnQrSldBWmlPY1I4akQy?=
 =?utf-8?B?S3QzaGlMVERhQkh1Y3BWcU9jMExNU2xnZHAxSFVTVnJmVVpEK1B0b3RXOFBR?=
 =?utf-8?B?UmVpN1lrZzRWbWkwdHRrOWF1TVhUSFNTSE15L0F0TnBhZG5XNW9Rb0VwSklL?=
 =?utf-8?B?UjJFcFZ3eldEd1pZQ0pVMERCaDBjbkZmeWFMR1Fxa09QUERhdTZWZ3hlQXB4?=
 =?utf-8?B?N0kwME40S20wdXpHQndMLzJuT3IzY1AycXYxNkxKQmRBZmhDZGhrNUJudnlS?=
 =?utf-8?B?N084dFAvRG90UkxRQXZiQjAvVDJ3SHE1OVMrU2J2V21NVmkxQ1dYbnFYNFpw?=
 =?utf-8?B?L215WnVESS84c2VkQzBBcUNseDVoQVRabkFiU2VyNnpuSlpNd2lsa01qZ3kr?=
 =?utf-8?B?UGE5S0Y5NWdmZXFYc0s3NWExckF6YWdCNlBFWks2Q2xsaG5GSmFYL1kxLzNV?=
 =?utf-8?Q?7Fh9XpuddxV6OqBCky/+DSMrO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b320061f-45d0-4e12-f5c9-08db814729b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 13:11:25.9543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ey58R+LlnFF/iIeJolIrxcp99kF8rAIB/e2Cir545OObBOI+8+VadmfxjxZJD24XiwOPGQrnM61bVFUTUdv8Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6888
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/23 22:05, Sathyanarayanan Kuppuswamy wrote:
> Hi,
> 
> On 6/11/23 9:25 PM, Michael Roth wrote:
>> Currently CONFIG_HAS_CC_PLATFORM is a prereq for building anything in
>> arch/x86/coco, but that is generally only applicable for guest support.>
>> For SEV-SNP, helpers related purely to host support will also live in
>> arch/x86/coco. To allow for CoCo-related host support code in
>> arch/x86/coco, move that check down into the Makefile and check for it
>> specifically when needed.
> 
> 
> I think CONFIG_HAS_CC_PLATFORM is not meant to be guest specific (otherwise,

Correct, it is used in bare-metal for SME support, so that needs to 
continue to work.

Thanks,
Tom

> we could have named it CONFIG_HAS_CC_GUEST). Will it create any issue if
> we enable it in host?
> 
>>
>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/Kbuild        | 2 +-
>>   arch/x86/coco/Makefile | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
>> index 5a83da703e87..1889cef48b58 100644
>> --- a/arch/x86/Kbuild
>> +++ b/arch/x86/Kbuild
>> @@ -1,5 +1,5 @@
>>   # SPDX-License-Identifier: GPL-2.0
>> -obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += coco/
>> +obj-y += coco/
>>   
>>   obj-y += entry/
>>   
>> diff --git a/arch/x86/coco/Makefile b/arch/x86/coco/Makefile
>> index c816acf78b6a..6aa52e719bf5 100644
>> --- a/arch/x86/coco/Makefile
>> +++ b/arch/x86/coco/Makefile
>> @@ -3,6 +3,6 @@ CFLAGS_REMOVE_core.o	= -pg
>>   KASAN_SANITIZE_core.o	:= n
>>   CFLAGS_core.o		+= -fno-stack-protector
>>   
>> -obj-y += core.o
>> +obj-$(CONFIG_ARCH_HAS_CC_PLATFORM) += core.o
>>   
>>   obj-$(CONFIG_INTEL_TDX_GUEST)	+= tdx/
> 
