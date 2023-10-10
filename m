Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAC67BFBD3
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 14:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjJJMxi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 08:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjJJMxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 08:53:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8CAB4;
        Tue, 10 Oct 2023 05:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWOiiDDp6Ha+YttfnflYBO20krMzHolBKZOHLgUmXxyDRvCep5Ek6nQhPuZ9UMaHx+dyVdq+uYAx54WHkAXFwZmjFf26OpgGTXTO+b7abLRt28TiIqKJVqc5Kej+cyPAJBwJHu1oZreNfMrakwWFSfvz/bgcpV6TtZmEfs8rjaB3LiwBiPh6yhDY/IAiJNtmbr627AFcW/zibViQfWQJhqaIyQuMA7IbA1PnCRIyAkhUBhjtafU3S7jyBtu/uY5iR4AdHg6hGlgP/Y3VE3a90Zi/C8YwXie39wJDLo7CqqVRUvZK2UT43qgYb8+kV4/C4/DlaZjnTb/aGZ5UCS/BHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=feQBOLwSu+tjrOw9JyUuvSfWWF55ZRNCgjceaK/xEHs=;
 b=Ox7T/GgB23YTe9aMzGv9S9IMArkP+zEPlMW5j7RPaysE/L9HcKhoFhdDlW4Cjs8FP6BWZLHdywkSM1ZBDKXmTvoyZOdWQkZIZWZn0AShWzuPkJ83gN+jg6UREJZL1RY6AZz5W00Nj8d5gCJYwvOlARWZ3IFu92f/2YwF+GtaVOLN8xGI7ELoe9f38oV7D3sKi8if2Fr1nD7mKFCwYp9o3NfUvXeVsF8YmmXTMSgu+Eykmf3R3bZp3BjAFii96nUkv9+FqQUXbhoB6qsOuUFuZvP3JxPsUA0/2poECsJRDj8jdUE99p0285JuRBPdosnnZklKp/dUDce8FV1T3jK3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feQBOLwSu+tjrOw9JyUuvSfWWF55ZRNCgjceaK/xEHs=;
 b=0l0f6o0Wko1U7FJ8FcJu63WpR0ZH3wyu6UGEbhosWfyY5JyViAX2YuYvB0ISruQnZ6yOQMy9td2bnhAaVs/UD8UmlInHZmxJbdXCpygox+giNEuJEC6/ll4LPLv5rL0BcXA+IcQpU8sY1jx826JGxR3zPl/j9U+AFCol4fkZ5fs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM4PR12MB5389.namprd12.prod.outlook.com (2603:10b6:5:39e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 12:53:31 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 12:53:31 +0000
Message-ID: <2a21b730-9ad4-4585-b636-9aa139266f94@amd.com>
Date:   Tue, 10 Oct 2023 23:53:16 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] PCI device authentication
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
References: <cover.1695921656.git.lukas@wunner.de>
 <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
 <20231007100433.GA7596@wunner.de> <20231009123335.00006d3d@Huawei.com>
 <20231009134950.GA7097@wunner.de>
 <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
 <20231010081913.GA24050@wunner.de>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231010081913.GA24050@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0176.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c4::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM4PR12MB5389:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f27cbf-815c-4f94-3790-08dbc98fe7da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G946Cg5LwMHJbtVSq922vA1lLi74SL0eMxvcOJ88g3k1WsdYOc++PoN39x6Me/7u33DDQv5P6P8QjNrti8kEz9ubPUVCa8174s/J+wrWBz9wE2PUcspNdNx4oj8np19bCyvzMEDYAIjN2Ffd5sAR0tVvMksjFemmb/L1vm+Xxtljy+Y59BE0Ed3gc9tN0kFdV4WxUlXKjYCtltZ7rXWln+hhysyDHS/b00PEAhVJQVIBhsMn82WtgviOLFITLW/qmvp+UpkgPSUZFd2dgt0JedplRi+SRf5XFOfVI2XF4OcdBs2saSZDptv5zur9byHwuQ2RyhGR6magH0uTSER2xoeCNklUNwY7/yd/XIRsACa8E0YRz9QC6bx4pRnKg4KaA+8PKad6gBBTFYLv26frnS4rymQR3tm7cXOv28F/ovdBFKoimycPJn0RZkUKUUrhyRTV7fySVNpklCW9ME6SS/YwpErgIK5KMnrofPHsqRxw8N1NWUxg1lU2qJFNDBlWiXu17r3z8jhny/evMmlvcZQHMNRHjZtbAn0kCbKJ47TMJTzOcrwbUeUno8J2KWVfpy1SDTyghwcH8tkEURL+N6VS5peGZRbRSzRdWrsItkv1EhiqOXR1DavAENHmbkAJF5GSnfcH5QzCZIMKKAMjPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(136003)(366004)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(53546011)(6512007)(36756003)(31696002)(38100700002)(26005)(2906002)(7416002)(83380400001)(6486002)(6666004)(2616005)(6506007)(478600001)(316002)(4326008)(6916009)(8936002)(8676002)(41300700001)(5660300002)(66556008)(66946007)(54906003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVl3ZzRQOUVLckljbyt6T2xiNzZuelB2Vm9nZDhIekg5YkZTeGdYUkZidFBV?=
 =?utf-8?B?TC9oVXFZOTdIZUttSUhBdnRwb2NOZldRRTV2UWhRcWk5MGNreEJlbGVjOWFm?=
 =?utf-8?B?UUNKRkNvWERDSDcrMFdIM3NnSkNzaGhQZ3JNMTJESjlCQ01DNllZRmVPVUxX?=
 =?utf-8?B?YjhsZ3Jib0IwUkw0UmtTSWlTV3ZvNVU1dHVWMWxBUGZMNEFjQ2VRam9jdk1H?=
 =?utf-8?B?YVlQK1hKU0JJTVMxemNEWUJIcDhEU1g5MTlLUkhmOWtjUzlIa3JyMzg2WDRZ?=
 =?utf-8?B?SkVsL2p0VEIwbE05STV5UHh6UXVLbENxbVFrWG5pTS91dUl2eGN5Tms1YzVn?=
 =?utf-8?B?UlQ3ZmZqVnBxSzdzTU1KSDlrd2JpYktkUUNRQWhaQi95dXF2MUN6VXNOQndh?=
 =?utf-8?B?QTlIZ1RvRjYzNDl6bGpETi94cE0rYjRBdkxubllLcm50L2tlSkJtbndMU09M?=
 =?utf-8?B?cXJaR0MxU3BzWkQ4czZEM3JYQ2NQdzI5c0FCOWxFQjNlajhzTVlJcjBGSGMy?=
 =?utf-8?B?Mk1zS0JTaXNsUEFhckMvQlk1djhIbW1rNStBNGdCT1hyTEdRZEQxU245LzhS?=
 =?utf-8?B?QmZDcklpWlBybEVvb05NODc4bzR2UEM3R3JoZ3NrdU1rT1ZGN25BWEdRODhX?=
 =?utf-8?B?aDVpbTNQYjYybjIyWm9jdi9vY0VaQUNCSk9sNHhLRjlMZFlYNWZHekNYa3Uz?=
 =?utf-8?B?VkpRVjVEeVBrL1J1YTZFVk5GTGhoNk1DYmhDN3VZNUhzLzh1NFJVdTUwR2lr?=
 =?utf-8?B?SzNCeFpveHR6UmRXT3JSYUtlMlA4dDloM0ZOZjRJcDAvbS83VFN3VTJpWVoy?=
 =?utf-8?B?bzNJUDh0SkF2RS8rM0xjR1dCamdvcFZpVmRUQmdwR3R3WFRCZG0zZmh0RXkv?=
 =?utf-8?B?c0lMUjh1WnVHZWh0b0hrNFI3U0lweW83dTlpVCtaaVJSYlArSVdkRE4xYzcr?=
 =?utf-8?B?bG9WbkxjbXFwU2VSVEg0L2ZnT080R2Z3dGdmK1VkM0NEVENkOGFKRnNZNHA5?=
 =?utf-8?B?bEoweGszQ2ZaYXprcE1GOWRzQ3QzMmlXTEdjVjM3U203WU43bjBVaTRtVHdq?=
 =?utf-8?B?djlQUUdqY1Zlc0dXVGRwb0JkSUQzS3VhcDg4R1JlNlloTzFrYUlXY1NlbEpx?=
 =?utf-8?B?YnZTMGR3QUhFaHBCQmx3U2crUG9pZUVHa29zRHVZQVBLdDNHMHR3eW1LSEpX?=
 =?utf-8?B?aHJxT25QcEtlVytuMTFKUURRVWFhNm5nUy9XclJUMzVLWFIvcDVieUtBajhm?=
 =?utf-8?B?NUgzVnR0NWZZOXUzdkJjT0VyMmt0R3ZsUStNM1diY29ha01sRGhBMUdVaC9q?=
 =?utf-8?B?RTRXU3pUb1VZOVBlMFIwYWZjVHlDTm8wRjR5OExrMFZ3SFlhQTZ5dmNWdlE5?=
 =?utf-8?B?Sk5vR2R1N1Mvd2NwT0ZtNTVsYXNJSVpvaEVMRUlpQ2RJZ29rNVJBNFo2bHV6?=
 =?utf-8?B?WGszcUhlWk9xaXJTcnY2ditSM1RoSDhhVjYrb1VMVXZ5dlcweWxyTk1GU2Vq?=
 =?utf-8?B?c3djMUd3dDFwa0RwM0hvWUFpU3ZieGJtNCtoRVlqK2tyMmNpQ1pDVEEwcTJL?=
 =?utf-8?B?dW9EaEJQOHlWeXV6bmVVeTI0SWhhTmlETy9JVEtjY0srRGJ2VWxrd0dqRnBq?=
 =?utf-8?B?V2h6Q2doUVFZMG1lZ0xHNjd6Zjd3ZmFtNW12OHJJNkpyS210MDdOK3p5ZFdu?=
 =?utf-8?B?K3FNMFRsTG9jUzdvYWltODVlVkxSNTZkTkp0UlFLWWxVK3ZsclM0L3JqNFY5?=
 =?utf-8?B?UGVzWnAvN21NU3hicU0xc3NhNDVldi8yTWg1bktPYzdFbG1GK2U2OXdYdFhy?=
 =?utf-8?B?YWE3UjljUXhhRVRnblFBK2Q4U2xpWHJRdlUreG50UExhZkR2RUhhOFV6SDNS?=
 =?utf-8?B?azhmTlF1WTA3eWEwYlVCa3FYTjZOcUt1RnE5RGhUSWpQMDUzemloM04yS1dh?=
 =?utf-8?B?YmlTc0lDRjdLZ0FldUgrRUZ1YUtRRGM4aDBicE9PTW5pSm41eGk4d21YYlN2?=
 =?utf-8?B?OUhJbUtWTVEra3h1Z0VGdmJud2NNRklKc0prWUdrY3Fmak52eVgrVUtaTVFi?=
 =?utf-8?B?TExPQ0dCNEpuVnNyMzNRem81dEN3M0NGZWxoMWJCaGxid2VaaHR3RWxPUWo0?=
 =?utf-8?Q?VVFLH+6MBev54jtI/mC7EtIv4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f27cbf-815c-4f94-3790-08dbc98fe7da
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 12:53:31.1923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtHXf5Cd4YHKeT0xfncnVvUbN794KB74B3cSCz822Iqxm+GEN7apIMcc2ZFLHnOdsE07O687c2QCFx2GV3sb7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5389
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/10/23 19:19, Lukas Wunner wrote:
> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
>> On 10/10/23 00:49, Lukas Wunner wrote:
>>> PCI Firmware Spec would seem to be appropriate.  However this can't
>>> be solved by the kernel community.
>>
>> How so? It is up to the user to decide whether it is SPDM/CMA in the kernel
>> or   the firmware + coco, both are quite possible (it is IDE which is not
>> possible without the firmware on AMD but we are not there yet).
> 
> The user can control ownership of CMA-SPDM e.g. through a BIOS knob.
> And that BIOS knob then influences the outcome of the _OSC negotiation
> between platform and OS.
> 
> 
>> But the way SPDM is done now is that if the user (as myself) wants to let
>> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
>> as CMA is not a (un)loadable module or built-in (with some "blacklist"
>> parameters), and does not provide a sysfs knob to control its tentacles.
> 
> The problem is every single vendor thinks they can come up with
> their own idea of who owns the SPDM session:
> 
> I've looked at the Nvidia driver and they've hacked libspdm into it,
> so their idea is that the device driver owns the SPDM session.
 >
> AMD wants the host to proxy DOE but not own the SPDM session.
 >
> We have *standards* for a reason.  So that products are interoperable.

There is no "standard PCI ethernet device", somehow we survive ;)

> If the kernel tries to accommodate to every vendor's idea of SPDM ownership
> we'll end up with an unmaintainable mess of quirks, plus sysfs knobs
> which were once intended as a stopgap but can never be removed because
> they're userspace ABI.

The host kernel needs to accommodate the idea that it is not trusted, 
and neither is the BIOS.

> This needs to be solved in the *specification*.
 >
> And the existing solution for who owns a particular PCI feature is _OSC.
> Hence this needs to be taken up with the Firmware Working Group at the
> PCISIG.

I do like the general idea of specifying things, etc but this place does 
not sound right. The firmware you are talking about has full access to 
PCI, the PSP firmware does not have any (besides the IDE keys 
programming), is there any example of such firmware in the PCI Firmware 
spec? From the BIOS standpoint, the host OS owns DOE and whatever is 
sent over it (on AMD SEV TIO). The host OS chooses not to compose these 
SPDM packets itself (while it could) in order to be able to run guests 
without having them to trust the host OS.

>> Note, this PSP firmware is not BIOS (which runs on the same core and has
>> same access to PCI as the host OS), it is a separate platform processor
>> which only programs IDE keys to the PCI RC (via some some internal bus
>> mechanism) but does not do anything on the bus itself and relies on the host
>> OS proxying DOE, and there is no APCI between the core and the psp.
> 
> Somewhat tangentially, would it be possible in your architecture
> that the host or guest asks PSP to program IDE keys into the Root Port?

Sure it is possible to implement. But this does not help our primary use 
case which is confidential VMs where the host OS is not trusted with the 
keys.

> Or alternatively, access the key registers directly without PSP involvement?

No afaik, for the reason above.


> 
> Thanks,
> 
> Lukas

-- 
Alexey


