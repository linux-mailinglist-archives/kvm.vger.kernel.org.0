Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE8C7272CB
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjFGXSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjFGXSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:18:30 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BFE10EA
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:18:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gazsuysUFAwI0K9MfW/fJy19r876NGRVbk3nZlNearrPtfGg2ermg5jLicCTlC+R2vGvXlJtundgjd3tV2XnxdZK+kc7Ep4aDAnjdYt5k9YuoH+KRRN7bVxAHj04NVNlA6gwwsNBpUlQrR8DhSEc7MjtKs+X/Rlnrj38NWM5qlelTsVnXdt0k00+qptOcuPgYEnzXa27VZzH3LgX55zLRQufQU5sMQOwrVZsq9kIVPNqYDHUyqmjEo1uiA/j/B7boZSDyfjnt84sHbD6ULLywSiK7qk+Sjdat/uGzQjoVmxJkPNibA3HPXFv8aCc5we0/hvKEft45GAEOXJ6fQyCFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnTrhIvol+Sjm+PcmXB6rhdTCaAKOEbhBrbPZyXO7Ds=;
 b=YU7OyhnQ2zUL014syHPKZO2qE7Cj4vFpQQM/PUxVX36akw6Nq3+BF+pfDu3XIqWFXwfZFY7yI68BHcPYaWj2OE++UFA6Mkva6VX7r0rfzZ+7GOJ54AiqorjI7zMOGQ1UMbHH9Pd5Gz19NHLpou39nOJkuE1RITbzgKYU3DP/FwpqL+S4+w8xZ0lVvX0QEO6YvLnaI0hcUhAY2WmBs7si+cKDLNxk8m0ixkeClfib/JmEU58Y28V8lcWT03DnGi1SjSKyTw7U+n+N9EvpBwr/+8AfFHp2gTM76+T8I9OF+WWFfbWV5WMhJDHHV4Tqrxj3h76RAh4QLK4qirfdGkx1JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnTrhIvol+Sjm+PcmXB6rhdTCaAKOEbhBrbPZyXO7Ds=;
 b=Wrb5GwZUJWw183Asvb0iN8r804Gx/tgjRT6sGOpBPs0XFOK6y/BTaGVu3dSzoRmCB3LjiyKAhm1YzIsddX6XZMwvZOCRuv4HU0IetbyUmJb5SFMbKYG4DlaYdtQw4TnJVwK9uHg7r5j+KnLZTaLVY5d3MEuy0GLUFH9shYRz6sM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Wed, 7 Jun 2023 23:18:23 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::ff22:cffa:293:5cef%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 23:18:23 +0000
Message-ID: <d1269899-7e74-f33c-97bf-be0c708d2465@amd.com>
Date:   Thu, 8 Jun 2023 09:18:12 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: RE: KVM Forum BoF on I/O + secure virtualization
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>,
        "Giani, Dhaval" <Dhaval.Giani@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        "steffen.eiden@ibm.com" <steffen.eiden@ibm.com>,
        "yilun.xu@intel.com" <yilun.xu@intel.com>,
        Suzuki K P <suzuki.kp@gmail.com>,
        "Powell, Jeremy" <Jeremy.Powell@amd.com>,
        "atishp04@gmail.com" <atishp04@gmail.com>
Cc:     "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, lukas@wunner.de
References: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
 <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <647e9d4be14dd_142af8294b2@dwillia2-xfh.jf.intel.com.notmuch>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <647e9d4be14dd_142af8294b2@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P282CA0112.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20b::10) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: ffab2d1d-5264-475b-d4c3-08db67ad7cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2dCOYrclWqjz3A5wVpo3M5FFlLZmlDAD5PNzkhZi4WnJosb0/gK/R3ZRv19VB3v5a1qNSQyN6rZOQveV2TxTQQ6mE9T/OhZD4lwRQncXC9IQ3Q8sbuol7OZ9nwJe6aNkL/btRUZaPnUt4jtoCNXV3adDXQqCabE3skq1cCd/obz288gVbpLvTO33TdM5S8Mz2lOEaB+/nl6d6CNwLUF6B2Gaga2yu8eTAVn7uVduFp98YKLrF1X1RL2AY9enIJ4HSH7KKbu4Bg44yw9NjYvGnbGyiJn+/S0feOEmxm4qH7ZaWJTgNtxDThaj9jVpNs7iK25sORUnOq0HIv3mt6A2S1Lvks3HulXTPzS1YJK7N422JxTob5z+f55J3kFMD0zpMkstnGRqwdnQDnaK5lW/ZAkzTXdHQa2aGYxO9I/TcijMv1GGvsBWooovUetOPsCryyCZuAgCHXq9tCphsb8WellznGUJJZPbyP1nNj85qSFAnz/Cqveo7/PYtlNeIR32jn6v2DaXtTvRgJMA2pRrDrVMQKrfT5oIjH96nnvOcYwiU1QiCfIIuv9mbxWVaoGkYTojKZmbJBo16RaYiZRMiDfJtrDVrjhZ7qweHOayvXVltZkcSLcR1wanKfBkGBWk1KvRBBtxGoaxrgf4ulO5bro7TSe3jfM7FrzJdl46T+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(31686004)(26005)(6512007)(186003)(41300700001)(5660300002)(6506007)(53546011)(36756003)(316002)(4326008)(66556008)(966005)(66946007)(6666004)(66476007)(8676002)(8936002)(2616005)(478600001)(54906003)(110136005)(31696002)(2906002)(6486002)(38100700002)(921005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VURGZTRSUUNzdkN1Tk1VMUovUHFaV0diWXVRekxpdFZrY3g1VjU0cDlyblNw?=
 =?utf-8?B?YzRNVThRaHorZDRvMmhxZWFZNVZzWkUyeEpUdDU1NExGV1duNzJCLzNsNnk5?=
 =?utf-8?B?NEZlT3hVWDBWU1dzakdldlFYOWZ3bVlYMDJBeEFBL0RadXFvNkFwbFYwc0pV?=
 =?utf-8?B?a2Y5Z2VOZzM1S0hsZmZiVkVJcVNoVHdFNWJybWxpNUFoamFVbDBEcTJscXAx?=
 =?utf-8?B?alQzdmptLzlhcExMM3JPS0YreHdIOUwxRGFkdVU3SEJINzdrZURVUEFFOStz?=
 =?utf-8?B?L29EK1g1VHJHQmlkTzVpYktIM2RsRUxaUTBLU0ZIYWswQ3dJc1pMRThkMmpV?=
 =?utf-8?B?dWdHSzlQN1gvM2JtRXNpTHBialo0OHRBMXU1U3JlN1V1SUJUU3VNZzRTSm5Y?=
 =?utf-8?B?SGNsVlgvb0kyYTdRTkNhd2g1QkRuMnpGL2gvWkg5QStycW4za2dFblN4bWlo?=
 =?utf-8?B?ZlI4V1hwTVo4L2UrbFIyb0txTkF4NnRuLzRLNHRsYXVKQlhMOGxCcDAvVERC?=
 =?utf-8?B?MHhDU05FTW5FTVZEN1QrRXlCdkREV01MOHFpdDU1dHV5NWFpRFFFbHVtaFBI?=
 =?utf-8?B?OWRaM0VxWHF2QlkxajY1b2RtSjFuYkY2OFNOZSs2WUZRME10TWpBSEUvcEV2?=
 =?utf-8?B?a3FKak1GZlUvOWJYbTJLMWhBeVpYaXRUL2d2VDFuaWJxMVpMMnQ5c3o2MmlK?=
 =?utf-8?B?UnhHN2pWRk9INHBsQVpOMEF4ajFXNFAzV1AzYVF1aTZ2c3dkcGpVTTM0RGpT?=
 =?utf-8?B?QmhoWlZzR3Q0VVZKQVB5TW13ODBwajc1KzZ2N3dXSEtRWFlPY0JWMS9EU0Za?=
 =?utf-8?B?SWx3VGNVQVU5REwxcnFQdmpvdlNwSWh1cStReFpZeHZQWnAzbEpEd1hMT0xK?=
 =?utf-8?B?WmhOTk56THl6L05rS2hZWWlqd3JsK1AyeExsRVpwZzNoWmNjSVZuVnJpMFNO?=
 =?utf-8?B?Qm5oRmh2MTdBWFk3TStmSXJSNVlqZjgyT09jUzVkV2RsS2JpNi9PQmRXTFY0?=
 =?utf-8?B?a2NqaHI1YXkyRmp6dlJUWDNFb1o5WVpxbXo4U3hWei9uUFlzc2dQZmdaclFj?=
 =?utf-8?B?VTZQOVJPalVNZ1oydEEvV25wRkMzNVR3aDkva09WS2RUMmtnNUVnWDh1MHFO?=
 =?utf-8?B?a0NBa3pKdTAwUjdRZUVpWTFKN1NEUWdvVCtmN2lta2REWXZUYTRQOXNMRmZR?=
 =?utf-8?B?c1FuNzBzQWh3a042U1ZhbmRRUnFVZWxqL05uODc1MUVoYWdBQlZTcjJGSnBD?=
 =?utf-8?B?L3JRVjdCbDNGdldxK2FRQWdFYmgyM3NkTkhUbkQ4NiswUW1Sdit2VkdyODJ3?=
 =?utf-8?B?UVpHN1F6QVdMd3QwVUZIOGF0NmxjQmpNUDFyaGtOSTdESHZ2cjYzbmR0dmI0?=
 =?utf-8?B?MVM5alhOQk9QcTlCUGJETzB4UjNETlFpTHhvL3NJSnB2UjRHMzUyMmY3UHNB?=
 =?utf-8?B?YW9WcWlNK01rRmVQTkNiUk16RjBoUXJvaHVYRElZaDg3VU5vM1ZjZTVxWDg4?=
 =?utf-8?B?MlcwRGtKVnJ5VGttSGhMVS90dk9FL2thZ3pObjlpdzZhK29LRlc4dm83a2ww?=
 =?utf-8?B?NEtJNlVhWHJFU3RHNE9PUFc1Umh0bWNnbW4rVEE2RzJxbWxCZjlSanFTM3FG?=
 =?utf-8?B?TTJwL3ZGc04yblhibmZ2VTlFNy9MaDdyR243a1ZGM0ZheFJhY09vVUNOSkR5?=
 =?utf-8?B?b25pT0VyL28zcS9BNHc0MnJJbUZENjRDc1JnejlkM2pXWGhPTnFrYmNmejNl?=
 =?utf-8?B?Y3Y1THg4SW8xREwzRkd5RVVEL0NpSnR0SUhyUDhCUTlZa1VmeUNCd3Vya3RM?=
 =?utf-8?B?ZitkaFlQMy9aZlFwUXQ3R0pyR3VqZ0pLYkUvRjd2TDc5T1FNWENxZ2dZRkxQ?=
 =?utf-8?B?aDhycDBVbS92N25TSDgzZWl1T21KN0NsRDEwK0MvSDIzUzV4c3R6bTdEeGlY?=
 =?utf-8?B?RFp3RmxrVjkyNWxxakcySmNqczc5dnBIWTF6Vlc1TU93ZHFYMW1sakR3MldJ?=
 =?utf-8?B?akl1ckRNS1YwTW1zUmFRcjZpcTlpR1JSakdOQWhDRjA5UDI5Vi9tYVBHM0hW?=
 =?utf-8?B?bGcva1l4aFlaVDBZLy9ya1JvS0F4UjVJMWtKV0hIbHpnNEwzblAzamtLcFM0?=
 =?utf-8?Q?aVIAqQAL8kx85pBa1h3CHdFEb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffab2d1d-5264-475b-d4c3-08db67ad7cfc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 23:18:23.1058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJQskop3jB1JPO5CwVclVNOdmS5NnjP/Lsm8EO3kvXp+BXqRtyYNAUqTvpdcTMTB2h1ROL57xhqdqWCCFZnESQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/6/23 12:43, Dan Williams wrote:
> [ add Lukas ]
> 
> Giani, Dhaval wrote:
>> [AMD Official Use Only - General]
>>
>> Hi all,
>>
>> We have proposed a trusted I/O BoF session at KVM forum this year. I wanted
>> to kick off the discussion to maximize the 25 mins we have.
>>
>> By trusted I/O, I mean using TDISP to have “trusted” communications with a
>> device using something like AMD SEV-TIO [1] or Intel’s TDX connect [2].
>>
>> Some topics we would like to discuss are
>> o What is the device model like?
>> o Do we enlighten the PCI subsystem?
>> o Do we enlighten device drivers?
> 
> One observation in relation to these first questions is something that
> has been brewing since SPDM and IDE were discussed at Plumbers 2022.
> 
> https://lpc.events/event/16/contributions/1304/
> 
> Namely, that there is value in the base specs on the way to the full
> vendor TSM implementations. I.e. that if the Linux kernel can aspire to
> the role of a TSM it becomes easier to incrementally add proxying to a
> platform TSM later. In the meantime, platforms and endpoints that
> support CMA / SPDM and PCIe/CXL IDE but not full "trusted I/O" still
> gain incremental benefit.

TSM on the AMD hardware is a PSP firmware and it is going to implement 
all of SPDM/IDE and the only proxying the host kernel will do is PCI DOE.

> The first proof point for that idea is teaching the PCI core to perform
> CMA / SPDM session establishment and provide that result to drivers.
> 
> That is what Lukas has been working on after picking up Jonathan's
> initial SPDM RFC. I expect the discussion on those forthcoming patches
> starts to answer device-model questions around attestation.


Those SPDM patches should work on the AMD hw (as they do not need any 
additional host PCI support) but that's about it - IDE won't be possible 
that way as there is no way to program the IDE keys to PCI RC without 
the PSP.

If we want reuse any of that code to provide 
certificates/measurements/reports for the host kernel, then that will 
need to allow skipping the bits that the firmware implements (SPDM, IDE) 
+ calling the firmware instead. And TDISP is worse as it is based on the 
idea of not trusting the VMM (is there any use for TDISP for the 
host-only config at all?) so such SPDM-enabled linux has to not run KVM.



>> o What does the guest need to know from the device?
>> o How does the attestation workflow work?
>> o Generic vs vendor specific TSMs
>>
>> Some of these topics may be better suited for LPC,
> 
> Maybe, but there's so much to discuss that the more opportunities to
> collaborate on the details the better.
> 
>> however we want to get the discussion going from the KVM perspective
>> and continue wider discussions at LPC.
> 
> While I worry that my points above are more suited to something like a
> PCI Micro-conference than a KVM BoF, I think the nature of "trusted I/O"
> requires those tribes to talk more to each other.

-- 
Alexey

