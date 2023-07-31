Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506A2769A47
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 17:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjGaPDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 11:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjGaPDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 11:03:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF34E78;
        Mon, 31 Jul 2023 08:03:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzXx/jbfjukySgMQg2r/oSy/c5UQK0sbY+YlOSOUVD5bc0hbCZMrXLzNNUCkwKlj1A91XYE7DdcUpx7A8lTCI5uWTi+IGhcoTW4a4thUj5Az4qgt3H4NyLQBSYixZmoiRARbCsttke6x88TwKORW95979UGVaHY2N5+0iaQtX5gwq0qy7NapVoujMrOYEK6D32JrkyjpKT7qLYOaeTnrmFDl9inaFbCpSqRo0/NWSQzsjv0wtw1Idv/U3J2UxgCLkYYoaqvzVWiYW0Xs9fywiwdU/30dJkWFYaXwogNETC/gD5DehTX223fgLnNIcRT+JqZJ/Ce9b5sLs6lbDcMStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14mnzZdoY1dMOMiDpm6QshQHB1zFJDufgwCdZkCO3pw=;
 b=S5Vsv8BxOW10NaYXBz/nS/NcWw74nXvWsPDKvtmURyad2G8OmN+QHGg2qGoZD8ZSAZJX02D4+BslnD0NODJCa9oMSJFOJOa+cWrNoJN0/8pv0LEnaPyCqoFzFxywCfNT89bSklVGV24JBslq/dARvavNrj9gkG+XQC4VksEs+2jtAR6VHHLsTNEl8IukAl8bjtPNNMYLC8c9DDn6mh2n+iQOC2ZtaIOMbsy/ngR+yn6uiKHJNSqU8JVN0JY8RFrt0G5qUYHWGUbO71Wpl8f2PrNr6zflPyv13nNhpXyzDXau5v6JKS479k5JuDOhQZdr2iF2RZg8Abbl9RYb7FY2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14mnzZdoY1dMOMiDpm6QshQHB1zFJDufgwCdZkCO3pw=;
 b=xjbRe1NUeFpENjj4LephnS6W0rCFHIHvrn9IQTec78gKTcZrhOd8BGV+pX2+6CE+o42Z7m2KevNc0hUpexb/cSoaQskFWBeK7+cgc4rY8YlG2M0amCDsvbhtF4DezYv2Ea+GH49G3Y7SSz8E9r/VnRwYjUU1n8KqJLBT6cz8x7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA3PR12MB8804.namprd12.prod.outlook.com (2603:10b6:806:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Mon, 31 Jul
 2023 15:03:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6631.043; Mon, 31 Jul 2023
 15:03:37 +0000
Message-ID: <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
Date:   Mon, 31 Jul 2023 10:03:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
To:     Sean Christopherson <seanjc@google.com>,
        wuzongyong <wuzongyo@mail.ustc.edu.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZMfFaF2M6Vrh/QdW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0024.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::20) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA3PR12MB8804:EE_
X-MS-Office365-Filtering-Correlation-Id: 4634bdb9-d5db-4a65-73de-08db91d75151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnHtHzbPVN6jo6hl8S7I78P3xfoW3Hz5vZjyIO9D9mssvqnmnjK3AHrO2MHivviBHKKVLo9IPCMIdspODXAtxUN+Nvpw4SVP35QKQYntSOySOnW8pxkPsTYz17pN8Ge9N8LlfxegGJ76CxdukSuVlP/xDfG5HYo0mH7n9S4QujSY2VGajiGi5s37JrRxels4tZbKelAx6iSxI4j/jSWUXM+0iiNEUPOluY20q2SeIcCnaD9LBydpNwf0KhI0LgkrCgsQk6RkothhqAiNB78J8YOk5rmeS6OF83scbv4WGvfBbBBvBIrEUvyHJtFqR8q8g6cbhgX6GOPo0R4OXv5jGPCQc7w1TuZg0hPbq7Ai8LEgnCAoDnkaYWKMRz4DywHiiOtTJwb/FafqLdYgy0xKAZSsCPaE14cWjVmUUmn1eejeaWlA/72B6yvHBwDvQ2vuv4G2cKSlvwBcHGhJL749aoAiTknImDaZrBe897s8UwlPtN0qguCXpeqmAnxGY7tLbXMS4iTpZfJB19GTPVY7PWfCTH1R7VEV813vV7YStY2TnEyzR2U5lO/+8xVUyQuFBouM1z6/v8MW+BoG2B0Q3L3y7mGwKAMRJKxJFwBzuD4V7sxM8+SVizcuwHrFhKSB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(2906002)(83380400001)(6486002)(6666004)(38100700002)(36756003)(2616005)(186003)(5660300002)(31686004)(86362001)(31696002)(6506007)(316002)(26005)(8676002)(53546011)(41300700001)(8936002)(66476007)(478600001)(66556008)(4326008)(66946007)(6512007)(966005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3gyTWJ2SnFUaS9GT3BYUFVDQ3ZXMkk5bkl0ZVhnS21SWHc3QmtLTC85UW1w?=
 =?utf-8?B?b3FEWSt6R2Z2QTRZeWc2S3d1L0hIa0I3RERRWmE4VDJKYzhpRk1UT0RWdzg1?=
 =?utf-8?B?UzZSWUtUQWMyRjFVVnpCSlBkbDl0U3Y0NytjWm9GN1Y0Sm5hUUFkRE8zRFY4?=
 =?utf-8?B?VkJ6R1dMQTdjYTdFUGVEWlZ2NjRpY0RMdWRBOVF4bzViUWx1b0dLTWVWNDBB?=
 =?utf-8?B?dDYxaDl0Q29ETXp6b1JWZTZDVVdiOE1XcjdmeHp4YVZJaFdUMkFPNVZ6T3dZ?=
 =?utf-8?B?eTNEU2JKWEUxdFhZQWJvYzhNaXlGc3YyWis5VmtTVVVpeHk1SSt0b0x3b1Nx?=
 =?utf-8?B?N3ovWi9BdXJQUXpLM3Q4Q0RxemJYMnRlOXpaZ3RDVCtKR0toek9lbkNGYy9S?=
 =?utf-8?B?MDZmTDB3bFY5SVRsWFd4NzIzOERDR25HWVhEWWZxb29Oc0wxWHQzTEQydFpw?=
 =?utf-8?B?R2FsbHU2M3I0djhUeWZrd0J4dEoweTgwN3haTlhSNjZnQ1l2aUdIRHJxNWdQ?=
 =?utf-8?B?N0gxTEhoRStwMGtCaTB4LzNXVTZYc3NvN3FlWm5EK1hZQm9WdjdUaFNYWUJ3?=
 =?utf-8?B?U2NVd1AzZzNpY21XSGk0dGczRkJGbm9tK1hLSlVYL3FDZmhXQ0c4VlBxQjlu?=
 =?utf-8?B?UHZFL2kzMzlyTGcrQU1nM0RIQXlseC9ObUY4Y3hULys5SWhBVVhJdEpsVmhN?=
 =?utf-8?B?TjdrOEh1aGZHNWV0U1JLeU9SSWR4d0Q5OGRIeEVHc1R6Um9uelVabVdiZHoz?=
 =?utf-8?B?cFRxTGpWbkJFT3MrN0c1MDJFSjNCUStWVGVBci9hTGVmdjJRZE9sSjBwc3M0?=
 =?utf-8?B?ZFdvN3VRVTRleGdsWVpzSzNHZHpjdnAxeXB6b01aTTJLNkxOOWo5UWROM3li?=
 =?utf-8?B?a1QvMmF0bGkwaFkvUjJ0UlU5N0dtVHBUMnNtc2x4MjhzODMzVlVvT2dzZGVj?=
 =?utf-8?B?VXhTSE1wRVFHQURROXBWODkwWHc1QnZId0d6RFB4R0dBTWdGbllwQmh3ZVlp?=
 =?utf-8?B?Z2txY1k0Vkd5QTlremhUWEpHa1RXVXdlMk9DR2dHbVFWUU1KbG1ITHFBUi9W?=
 =?utf-8?B?Q3FlSGhNTUlXRlh6NmZVWWozaGlORmlOMmUzR3d2YmlZUHQrdjRYRU9NK0NE?=
 =?utf-8?B?em91aDNuYjNiY1ZuRTRyNExDWk5waDgxdkIya3haN3VVRk93MkxUWFZ4WUgr?=
 =?utf-8?B?eWh1WjQxNFphRmRnQlFxQ083V0pGa2xYdXNOUUhPRXJiOStCOVRMWHI0Mkkr?=
 =?utf-8?B?Q2E2bmxyUStnbDNhSEtXTTVCMjdaS01VV1pJSkYrR2s5OEFyNFdqZFV3WCs4?=
 =?utf-8?B?N1ZDbW5udlZldlY5N3VnTk9hc21PaTNOTCtJZHJoYnJUaWRrQXByeDNjeGpp?=
 =?utf-8?B?R2ZVWndvOTgrUlpTWkdIT09SalpXYXdnQmtEaDhxNHM2dC80SGZJaEwrcXkv?=
 =?utf-8?B?cXFiZnJneWJHMG5ndkYrTmtBaEN2Q3RwdGZGNmVRUXpoUlkyTHBmVzJJbThv?=
 =?utf-8?B?VFh0bXlTRlROZ1R3Ty9rcFh5QWZ4VFpDOVpuclpvSWh1TnZUbkZwZlo3Y3h0?=
 =?utf-8?B?ZjluUjRCWGhNdm9DRW5oTUlTcXJvdGhtQy9nZnhDU3ZxQ0JkRHQyaHJKY1pQ?=
 =?utf-8?B?ZGltbTBIU2NUSm4ybTVVT3I0UyttNmJlaXRRcy9BUnVaRFdvMi9wNWNIS3Za?=
 =?utf-8?B?bjZuTjlLTTllK1NXa1orY2xjaHZhR0N5Zk5pNTI0YW5wWFNYVFFidjIrQ1F3?=
 =?utf-8?B?ZzlveDQ1VmUwUmsrYlBzcnQ2VGhBNEFZdXJ0bXlWMlBuWWNqVTE0L3pyblZH?=
 =?utf-8?B?SG8ySkxPdXZaSm9MQzE0UHAvRkJTMVVFZk9OSys4NmxEb1AxWm5uMHpQdDRx?=
 =?utf-8?B?M0ZRTmpJSGx1dlg0cEMrcTFOcFN2MGx1eW9LbGZHY3EzM2paRzUyZkxiMmxI?=
 =?utf-8?B?eWZ4WDZjcmhFRldOVVZIWnFiZGpCUnVxY01DNUYrMkltQUVTajdQaGl1NGt0?=
 =?utf-8?B?dFJhQms4REtJSVdsT1NiZHdicjI0SFNxQVJqY25ZRDJYdDdXVEltUFBJU0hm?=
 =?utf-8?B?UXVqTzg0a09GM1FjMVp3SVV6Nm9mZnpyRXhKcE9qdW52SUlKa0hpczFyQ3V2?=
 =?utf-8?Q?VPuaALK5ae52iVCra14/qihpd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4634bdb9-d5db-4a65-73de-08db91d75151
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 15:03:37.3202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxbuVkOFkeNZUX5wXXmbNw1VtMl4a+DBVCTbA+Kuz0bVOkXg9xkTU0Ts414KiF4sb9xF9xZr69GtUj4/3uI0cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8804
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/31/23 09:30, Sean Christopherson wrote:
> On Sat, Jul 29, 2023, wuzongyong wrote:
>> Hi,
>> I am writing a firmware in Rust to support SEV based on project td-shim[1].
>> But when I create a SEV VM (just SEV, no SEV-ES and no SEV-SNP) with the firmware,
>> the linux kernel crashed because the int3 instruction in int3_selftest() cause a
>> #UD.
> 
> ...
> 
>> BTW, if a create a normal VM without SEV by qemu & OVMF, the int3 instruction always generates a
>> #BP.
>> So I am confused now about the behaviour of int3 instruction, could anyone help to explain the behaviour?
>> Any suggestion is appreciated!
> 
> Have you tried my suggestions from the other thread[*]?
> 
>    : > > I'm curious how this happend. I cannot find any condition that would
>    : > > cause the int3 instruction generate a #UD according to the AMD's spec.
>    :
>    : One possibility is that the value from memory that gets executed diverges from the
>    : value that is read out be the #UD handler, e.g. due to patching (doesn't seem to
>    : be the case in this test), stale cache/tlb entries, etc.
>    :
>    : > > BTW, it worked nomarlly with qemu and ovmf.
>    : >
>    : > Does this happen every time you boot the guest with your firmware? What
>    : > processor are you running on?
>    :
>    : And have you ruled out KVM as the culprit?  I.e. verified that KVM is NOT injecting
>    : a #UD.  That obviously shouldn't happen, but it should be easy to check via KVM
>    : tracepoints.

I have a feeling that KVM is injecting the #UD, but it will take 
instrumenting KVM to see which path the #UD is being injected from.

Wu Zongyo, can you add some instrumentation to figure that out if the 
trace points towards KVM injecting the #UD?

Thanks,
Tom

> 
> [*] https://lore.kernel.org/all/ZMFd5kkehlkIfnBA@google.com
