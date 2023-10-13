Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D9F7C84CD
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 13:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjJMLqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 07:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjJMLqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 07:46:12 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED33DA9;
        Fri, 13 Oct 2023 04:46:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO7RbIHNzMJO9CDDv2ahkqSIi/UZ/9Cp2duRrT2zVh4ViRjQmmKgX0/khN1asp92lpMDfT+8LNN4FKI0WTbJRscH7HcaYcZOY26A6gi7SDfn4ccNJ2EypbP2ExXFm9hhl1hGUHt7hJe91eNFU0VaErlS2rQ3C1UCfuHgo98ZYv2ayuc0P1DF7J/7hSC5DH4pCBrljrV8b70ERM6l0aP8ZiUKOsCa93VELI/AKnyweU00uqhb5KJtsge1Mck2Y16sCK+EOG2pw+cYAB3F9QBmHOQb8zr1bxXjOmzEhIfeOT0C0320axQbUvAOao9LSgP5sATreo0+x5wfzVd1QcJgmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLpWqQpdT3AgNCFEw2kRMpvI+qgKyNy9y2JEcJP2MAY=;
 b=YEAhH/pJB/UXpdlRLc9DiXNvY5Llwn1ExcC2oh0tKy4felggngkv4R3C0pgXF3uE4sGU2IHVR4Z0IGDM/mIUxr2qfJHfRuRKFhwI49OnaSAsVNWPK8mJKlx+dwXF6RXu/wVKZSYn7Ha75e+ReKRNahebmxdcbqhnOpJEsEfb87g/vbmDnK/4+lpwnuGMNrjfmRN0ReVKHQUwNZZy9Q3g/vi9dEIhxp/wkDvI1aPj9joecF72WDfNbwDZtLDuML2yavGEGbIHfq4zyKQaBNflHOhBhnP8KwJab6Tqbt/RVwnVs32pwLUrQeULMhnt6LW3lsQSHHGCkZyQAhE9NjZHzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLpWqQpdT3AgNCFEw2kRMpvI+qgKyNy9y2JEcJP2MAY=;
 b=ooQ6tB2C4YWkSxpTXDt1180zmpEE1ao1U7cuzgtE14Dikn0psIQSBj/C2+9BKDtQWwI7bGuVqnzUUDqOftYAVx3kRByMjVF58oksA2ZVvVzGgBP+ETfv1+M4pFebDRTlF2ArlxRNRTeioxu0+KNezuvl4IEqhX+W0oWOSuWBkrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB7747.namprd12.prod.outlook.com (2603:10b6:8:138::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.43; Fri, 13 Oct
 2023 11:46:08 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Fri, 13 Oct 2023
 11:46:08 +0000
Message-ID: <5eb25628-2ad1-4e70-87dd-e61e9826ac1a@amd.com>
Date:   Fri, 13 Oct 2023 22:45:47 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] PCI device authentication
Content-Language: en-US
To:     Samuel Ortiz <sameo@rivosinc.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
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
 <20231012091542.GA22596@wunner.de> <ZSfw+xswgOSaYxgW@vermeer>
 <20231012163221.000064af@Huawei.com> <ZSjPhTJ9N0EKH5+W@vermeer>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZSjPhTJ9N0EKH5+W@vermeer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:4:197::23) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 82521cbe-7e5c-467b-acc3-08dbcbe1fd63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CP6IwGT9bKdpacndfdrDV3SsWcOsGqBOp4mn1TVdWP6hRVsW//ny9yCBaeas+JArBiJTMmXp0QNyQJckJp7DS26K++WcJ6QkAnSpXPbFivHVL3bUyyDEiGdRmoXpkZQLs2pYB0Bm+1C0cgAQwwrbq0DAMjMOq0MuKCUEtYCj+dz+M9N74KA37XqVps+sKBTH49zrTgqRFKO3LVN9NZSUwiE2olH1qrpT7aeAMhrvH2d15EkoSMFnXfpQNdQrziJgBZqeNzw4PN3maI+G7QDB7D41/JDgOyLI0j4zPNMD//qE3nTBfaLId50UUNNmw2OT9Rt5FPgVg7/DjdRJ3LN54z/s0YVLAk27qgATKIPoWYU9Fe2+xp7p2S8GB6SM/x75TDvLGOfnbPyMDA0pKdFG2DAy50Bo1IXq6lHpSZnT3b6dmGUH9oqIEuWUIjEX9+N8qNdJicQtQLoHGaiXraWrSgtdBhTxYYuoNJ8ShoZg21BjQu7aCNBFFf9Yze3LgWauAUQKmDBQ3cr8aP3aF0LYoL/xFbZXCRVxqny/HKX14XfrMTDNuWQoqT40YCYqrhDm4rfwqe3WKvzEy8VNmzeiY7ix12ZOpF+X0a2gs4h+aXLqIUXD1LWb1NmIzf2QNCoLhjFlrGvwP+g5RDtoZZyNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(376002)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(31686004)(6486002)(478600001)(66946007)(6666004)(66476007)(66556008)(110136005)(31696002)(54906003)(83380400001)(6512007)(6506007)(26005)(316002)(2616005)(53546011)(36756003)(2906002)(5660300002)(38100700002)(8936002)(8676002)(4326008)(7416002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk5tU3lYRTBnTnNRdFJXa3VwYzd1OU5zQWpqYU5kcFNXRkZtN2F0c01QNGM5?=
 =?utf-8?B?SVYxWlZJblFkY0tTQ2g3KzlvQVBvbE1zU1BIODdKWENWY3Z6R0ZLYVlWZ0ZE?=
 =?utf-8?B?UGNJN3ptK1pGQ0hmajBGcmpUVnhGWTFqbU1nbE1PTmJtUENrK1h2czFHZW0z?=
 =?utf-8?B?NFlZamZuSDl4RmgxLzNpa0NwbWUwb2JEREF2dzRaM2NaMUNjMDJoMWFXcGdS?=
 =?utf-8?B?TTN2TjhrZHZ0UTlSdWl3R0tTOGVvemVDZjM5N1FJWU5hQ2xrQjgwN2VRMFA3?=
 =?utf-8?B?bytRcVpwc2hqMzh3Zm10MUZuVVJ3RUJYZVVFRnpEeU1sUWk2NDhNOGxvV3k5?=
 =?utf-8?B?U08zWUdtRFFxbERnT1BLQmxsRG5vUUJZTklkc2xGaFJxOHJ4UVA2RHFiSUp2?=
 =?utf-8?B?RnpDclNMZVp3TS9DWTVyOHU4MC9OdEsyNFNJWklNbnM4bjI0RTJMZVlGMURz?=
 =?utf-8?B?eEZ4c3A3aGlWNEh6bFV6N1A4WUdyWDFLYXlUckJFVmdMVkhrWkdMMnpNam8y?=
 =?utf-8?B?R05ucU1JaVd3YjY4WlMzeDFpM0wyendoS2NrK1VhWjBBMHdaZ1I0UlhsV0Jq?=
 =?utf-8?B?RFVsRXZyMFljbTkzaTJMcFkrbzQ3U3Btc2tsVW5sOGczVi9FSTF5TFV3Q0ln?=
 =?utf-8?B?Z0hOdVo4Tmhhb0VZeW9YOEpJQmhOZ0o0UjA1WHR6aWVna010TGFxYythSHNv?=
 =?utf-8?B?ZUdFRExDRnlhVzVsZ2FFYmJCTE01dktGYWVubTFJRG9ENyt5RDIycDJVd2F6?=
 =?utf-8?B?cERKMStNTVQwdEpodTdNTUswZU5lSk1BZ0JEc3JnQjZ4VG9YTXMwR0VtRks3?=
 =?utf-8?B?ZVVITTczaTlkb3E5NnRpaGFqSTNYK1V6SHAybkZDallHNWIyT3lSK0h1M05j?=
 =?utf-8?B?b3RMQ2R3UnhZMzU0RE1vc1JpVjFKRWhjR3VaSjVTQlhYYVRTMU1yUXJkOE1W?=
 =?utf-8?B?YlJKN1lwZnUxRmNYdHBST0tWdWdMeEtnVWlpOTd2NmszdlEyUmZ4WTFYNG9Z?=
 =?utf-8?B?LzRBTzdjMlhqUERSbUtxeDladEJGRTgrQWZRZHNQekw2a3hqMXJwK3h0QThG?=
 =?utf-8?B?Q2kzb0xibjliWlpybHRNSS9zeHFoWkNYd1hTc2dCSWozcW9NNHd2S2J2SmpF?=
 =?utf-8?B?RjNZUWlmRXdTUzg4N2w5MXZMTGtSQkZ6Qlg1TG1VeGM2TFhPT1puVHU1VjJa?=
 =?utf-8?B?S2NsNmMxVmJkWVBLL0d1S0dUK3MwWUhmdUJoYnZNNFZ6a3QxMXNQNXM0K2hC?=
 =?utf-8?B?V2FVUDR2d0lJdzNlZGQwbDhKdXg2bTVhMCtKK3dxMndOYWwrSjBNcEZHYnd6?=
 =?utf-8?B?dUd4VkV1VzVjRWtxRTllQVUwNDhFZHlmeUFrZkxnQkplL2Z1V3Q5YlRPamJE?=
 =?utf-8?B?aTI3U0RrclBWWXI2akVoNE56Q0h3ZFRhTVRmMG9lSTNzclBDb1pobnpRVnlm?=
 =?utf-8?B?TUp5NGliRFE3LzNaQ2x3WlVpUFJsZ2Z3MjVib2tIM2h3Wm1IZmQzT2t2di80?=
 =?utf-8?B?cyt2RlR6N2ptbE52QisyOS9idnhPZndzODViblJjcDMrOXV5UDdvdHUyT2xh?=
 =?utf-8?B?SWdGMHZUNGt5Z3cwRkhIcjJSV2RQeStieVJxdytkL2FpT1huVE1YcjRadC95?=
 =?utf-8?B?NDBaTEhCU0swVWlicDFGWHR2Z0FUcjB6T0pNMCtJN05QTWdUcE8zeWFSNmFY?=
 =?utf-8?B?WU5Gc25ickRPWmdXZDRldDk1TlBuTjZmczJ3ZzI4YUQ3SFhielJHeUV4Y0da?=
 =?utf-8?B?N0Jib0lrZHJ5d2prdmRMZS9yL1FNT3VVQlBuQXhway9hellYMzdsbXp0Y1VW?=
 =?utf-8?B?QnRSUmlBM2xxaXNDZEpWY2JPWHFRS09YM05ldytTUG1wOFRrRU5vV3piQkF3?=
 =?utf-8?B?N080aUJvSFU4NmQyWkVmVW01cnZGRVdoNnM4R0dYVUFWL2xZSjdIU0M5Y2VH?=
 =?utf-8?B?L3RVeHR4MW0wd2xhOXBKWFFlTUs0WENUWlhkVGFwT0E2MnhsWVVzUXAwV1Iz?=
 =?utf-8?B?Q2YwNTAzVlVlZ1hEWHpNcHNhTjVhZFVyaFhZQ0JDYXEwSWtQYUM0YldiY2dh?=
 =?utf-8?B?RHFyczVrNXRHcW9vMnpBNGVod3pZZGI2QlJPampzcVMxMHlFYnFRNmpNMS9R?=
 =?utf-8?Q?e913FykTTzEtXAJYRlhpj55On?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82521cbe-7e5c-467b-acc3-08dbcbe1fd63
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 11:46:08.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRcjjQYXpOP4JnLr92jkRGBALmTj2BroM/RLNVRZNCUSByQG1gxmf+KmisU96FrMzcRGjo+/bma94UZLwOd0fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7747
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 13/10/23 16:03, Samuel Ortiz wrote:
> On Thu, Oct 12, 2023 at 04:32:21PM +0100, Jonathan Cameron wrote:
>> On Thu, 12 Oct 2023 15:13:31 +0200
>> Samuel Ortiz <sameo@rivosinc.com> wrote:
>>
>>> On Thu, Oct 12, 2023 at 11:15:42AM +0200, Lukas Wunner wrote:
>>>> On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:
>>>>> But the way SPDM is done now is that if the user (as myself) wants to let
>>>>> the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
>>>>> as CMA is not a (un)loadable module or built-in (with some "blacklist"
>>>>> parameters), and does not provide a sysfs knob to control its tentacles.
>>>>> Kinda harsh.
>>>>
>>>> On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
>>>> *before* it is passed through to a guest?  If so, why does it do that?
>>>
>>> SPDM exchanges would be done with the DSM, i.e. through the PF, which is
>>> typically *not* passed through to guests. VFs are.
>>>
>>> The RISC-V CoVE-IO [1] spec follows similar flows as SEV-TIO (and to
>>> some extend TDX-Connect) and expects the host to explicitly request the
>>> TSM to establish an SPDM connection with the DSM (PF) before passing one
>>> VF through a TSM managed guest. VFs would be vfio bound, not the PF, so
>>> I think patch #12 does not solve our problem here.
>>>
>>>> Dan and I discussed this off-list and Dan is arguing for lazy attestation,
>>>> i.e. the TSM should only have the need to perform SPDM exchanges with
>>>> the device when it is passed through.
>>>>
>>>> So the host enumerates the DOE protocols and authenticates the device.
>>>> When the device is passed through, patch 12/12 ensures that the host
>>>> keeps its hands off of the device, thus affording the TSM exclusive
>>>> SPDM control.
>>>
>>> Just to re-iterate: The TSM does not talk SPDM with the passed
>>> through device(s), but with the corresponding PF. If the host kernel
>>> owns the SPDM connection when the TSM initiates the SPDM connection with
>>> the DSM (For IDE key setup), the connection establishment will fail.
>>> Both CoVE-IO and SEV-TIO (Alexey, please correct me if I'm wrong)
>>> expect the host to explicitly ask the TSM to establish that SPDM
>>> connection. That request should somehow come from KVM, which then would
>>> have to destroy the existing CMA/SPDM connection in order to give the
>>> TSM a chance to successfully establish the SPDM link.
>>
>> Agreed - I don't see a problem with throwing away the initial connection.
>> In these cases you are passing that role on to another entity - the
>> job of this patch set is done.
> 
> Right. As long as there's a way for the kernel to explicitly drop that
> ownership before calling into the TSM for asking it to create a new SPDM
> connection, we should be fine. Alexey, would you agree with that
> statement?

Yes, sounds right.

>> I'm not clear yet if we need an explicit lock out similar to the VFIO
>> one for PF pass through or if everything will happen in a 'safe' order
>> anyway. I suspect a lockout on the ability to re attest is necessary
>> if the PF driver is loaded.
>>
>> Perhaps just dropping the
>> +#if IS_ENABLED(CONFIG_VFIO_PCI_CORE)
>> and letting other PF drivers or another bit of core kernel code
>> (I'm not sure where the proxy resides for the models being discussed)
>> claim ownership is enough?
> 
> If we agree that other parts of the kernel (I suspect KVM would do the
> "Connect to device" call to the TSM) should be able to tear the
> established SPDM connection, then yes, the claim/return_ownership() API
> should not be only available to VFIO.

Correct. I just want to make sure that DOE mailboxes stay alive and 
nothing in the host kernel relies on SPDM being still active after 
ownership is transferred to the TSM==PSP.

> 
> Cheers,
> Samuel.

-- 
Alexey


