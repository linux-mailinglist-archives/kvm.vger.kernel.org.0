Return-Path: <kvm+bounces-349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB777DEAAF
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17E3C281A15
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 02:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B40185E;
	Thu,  2 Nov 2023 02:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xRLJZ1R1"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A11217F9
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 02:28:23 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9390BD;
	Wed,  1 Nov 2023 19:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iz0YFUD4sSrJjGC3vrcexxhLy5fiFaB0ngp+W9XzpItZegynRc4e/RDGD5yUhB3ROdMleuZQ+/sPxDcYi/RWdB643d3jMjUfhCGajSU5DIAAXY/bU7xlahztCDfoMWPkC01j5LAGOUBEoQERQfgh3c7yV4QIiXwPKBRru861peshistwY5lThVp66hoG+QRghcx1vI7md2bUo1TolQO1VrlqhJ9QXvEKscs3a3iGbvn3i22aWu867EZ9hCuKd4ZkG6He7hLV6m37V8bC/fd0ylWcWyi2ejTwhkiHfuEXChyKpQekenbfR7GQSTrM7hEM8UfgaaZiIygkKtUICWGZOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7tp/L6qWgd9KJfY47or6YYO9f24Ne4Alzxk4PeU4U+w=;
 b=BlWEobC8BWraePAI1tIEVja/52dPhAWBmwq430GLkSN9bL98iCBdFF6ptxm7Bt0+Sfhb8pS6zaqh90JHZNuJI2dP1eQ/1dKjIVqdAtJZLIAabf5lUnucjAznSpn0CAE1yJT5roo4zR2g46rzzUVgwB82qi5ilXXkJEhsBa+bTg8NaT4lYdijZY01NSBNDGls42Jt7TWBwzl9Mpi417g7gDnFYukkpfIqu6EMwiI5I2SNnVK02Y6lCAyoOH96Mlb7SPYdq/vDLSLvte8vl0EBiyb4Evf2gkaG5+TcQMzN3kwieJbu9xM+hQ87yFIZQA2WIAtuNZXmhZ3L5pD2QncyaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tp/L6qWgd9KJfY47or6YYO9f24Ne4Alzxk4PeU4U+w=;
 b=xRLJZ1R1pCxUkp8yVuEpVO2TZJDq0DOfpN5fGLvqf4VHiQK1ykA94qHnoiKXRlr3z6ydyfJl4yg+eA/+BOa0mRBjZFBDT3Eq0llLlV0p/bTkEL6ATA0m1uH6N1gnBi5SDQkW6Xr6cLFGXtVwk9cn45G7e3J4aOYTKP0tanYDIPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB9397.namprd12.prod.outlook.com (2603:10b6:8:1bd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Thu, 2 Nov
 2023 02:28:16 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::7e54:2e35:593c:80a2%7]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 02:28:16 +0000
Message-ID: <4cfe829f-8373-4ff4-a963-3ee74fa39efe@amd.com>
Date: Thu, 2 Nov 2023 13:28:03 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: TDISP enablement
Content-Language: en-US
To: Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jic23@kernel.org>, suzuki.poulose@arm.com
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <20231101072717.GB25863@wunner.de> <20231101110551.00003896@Huawei.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231101110551.00003896@Huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0113.ausprd01.prod.outlook.com
 (2603:10c6:10:1::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: 3070b885-fd94-4af4-d4b9-08dbdb4b5ea1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q/sswNVlgVR9HfqMpZnA7ZgdTY7j8T/HUMpQGgnaXF2q18uvO3wRdbmQnxdszhaBrU0aFJ4ED3rd33UlmEtazY9VR0LhrbqeRH+GX52/2GYv2PZlfz+pWioxEfBun2q+2T7K/Y94VDJZVgvqVQnYyt3B1UJPoUN1ERbObYuDVDiXioltpRk014kTBsQW/tj5OBYJljFi14m+KilzhFO+Ih0PzUu5CiKIXb4/cu0IAM+T3ljq0b9z2gogTCicIWtXONvebZS3QBpu8jXMYSJOF1kupBcbUXbFyw/LZcMC2TVoeysVtPUqrYqtV9O3rOEIhpY/6XcrVasCgS5KK007ov6ptIOuPrk2Bt/C1ww2dYHaduehwMdG3zMBv7woqcak2kUFwSiNvQtZrtt1MRXEFT/gGkhCawoi0fSBtSc85Lnl3f5IUzzuLmTuV0eP5lo2USzL3a1AXclRSKQUEHOTqeHvHBXRypYSpAtShtnaHVQsBhng40NcwejQZAdpBFok93nWUZdEJTqDgMecW1NFqcdiUwVjlPGOmfNoUYjm1eTlXYxTWbPWQurOibi+eY7YlXaSUlbh8SZVnPhgCaQ35ign9wua3q9W+FeDbs8k2BR1DteSuxQinenRn4ZtQOMonAgtxVnpZlYhS8F9d1Mkag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(136003)(376002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(66476007)(66946007)(54906003)(110136005)(66556008)(316002)(6506007)(478600001)(6666004)(2616005)(4326008)(31686004)(26005)(8936002)(83380400001)(8676002)(6486002)(53546011)(7116003)(6512007)(5660300002)(36756003)(3480700007)(2906002)(38100700002)(66899024)(31696002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnQvQ2RzUzlrdTIvUnh1TjBwZi9EK2tzUndtbmdWQ3dFdlVtVDcrQUhmcDhH?=
 =?utf-8?B?V3hMejNzQTd4RG9JOGVIVW4vTHQyblRPTGI1QzI0a2tWV0NYWW9Yb05BellI?=
 =?utf-8?B?engzMEpxaU1QMWN0ZEdGY1VpOGMxcUpzOUZ4TEk5VXNSazlxTTZYaTNvcTdL?=
 =?utf-8?B?bUNkQXdaTi9XUHBwNTZDUWtmeWFNL29DM2E0dVUwQTZUemNnVGJpNkZKTFVP?=
 =?utf-8?B?ZlRvN3ZOWWM3WWROdm1nY3gwSnlHdVFxV0dJTHBQVkJ5TTNPbHNHTWsxSTd1?=
 =?utf-8?B?NUErSlhJUlR3MUxRdGVueW1EMDR0M2laNGpNcDNDTUFjdmd0bXFjbDhKczRC?=
 =?utf-8?B?M0pvUjcyMnNhSmFqc1BRZWcxRDZRd1J0U0M4TmhmOHh4NGxpaE1yU01FUnpX?=
 =?utf-8?B?T3lkb2JmR05tTFNoWm54a0VMdTRtUXF2aE5EQkM0bENqdG0yWFVjbzRvK2sw?=
 =?utf-8?B?eTFTYnZ5bzhXdHR0allNYkl0ZUdBZGtFU3QzUGtTSnVFRDlMUGZxTURzTlhX?=
 =?utf-8?B?VUM0N1NaeWxoeGcxTEs2M0lyMDJXNDJmT0hsQy9oY1RBNExFM1BJcUtLVDZQ?=
 =?utf-8?B?K2M3NllmUnN0Q2QwSUoyaE5RaDZ5QXRpWkRDWjRiOWh1NzBzV2drcytQVEp4?=
 =?utf-8?B?OTJGWHZCL2pzU3ZiL0F0SXM1N0o3MkNGaURLYUNxZEthbGl2ekRwbmRWazVu?=
 =?utf-8?B?Q1JTTVRTN3hRcnFxbG5pK1JKVm53cjlVTUNBR2hRR0xTWEc3U1lRcWZUcU1v?=
 =?utf-8?B?ZzhiYStDRnAvNXFYcTlEYmh0M3E0eitDTno0cDBNbzF6SGE0ZGVYN2dKQU9U?=
 =?utf-8?B?bjUzM1lEWEM0SWdSbmRpOXdjbmdDeW15SEpobUFmNXA1T25YME5OaE9MdVpa?=
 =?utf-8?B?bnhZZzRkdks1UUxRU1ZsaHFIZWZqMllRdjNwK2RsMEY1SDBtVTF5N2NlZVly?=
 =?utf-8?B?eW5kQ3pOQUQ5c0QyUlBwSXZmajZqRThVOTZpMmdzYXphYk95NnZaUFdHU09y?=
 =?utf-8?B?akcrVjBQSlltZTBuQTlqR2JPQXg5VkNFRk8xQk9CdmxtL1R5OXZNSUxxY3hz?=
 =?utf-8?B?N0JrYVI4TjBnM25XaFptVGV0bnVtdlprNnlFa2l5eW9sSkZSQWFlMHVhY3pr?=
 =?utf-8?B?a2pBWWw5blNlb09tWEttZDd0Y1ppWjVRcS9NMjd1cWtGM3FLdVJUdlBZTDFv?=
 =?utf-8?B?Y1pKUEUzNERUVzR6ejhoQm1wRkxBb3hEWU5oQzV4N0RGT25ONDFsMEpPOTBI?=
 =?utf-8?B?aGFmM0s0bEJwdXRXd1NVa2tJZTNKT2drdkl3TE40MU9JL3NGK0xyblhLOGdR?=
 =?utf-8?B?cE1jaFh3RHd6ZW4xUjFpUmxjZklQZlVtdEFQRWlzajIwN1ZWYk9QU0RTeiti?=
 =?utf-8?B?MU05QzBFNDJGMEFCeVdiQ29obk9uSzM0SnB5WWtzWnZxY2xDQW5rWFdORmFK?=
 =?utf-8?B?SHNwTG92YzlsUER5WXJvMTFXQkdCcm9PdFIrUFdnR0VEQjJDQzJnTXpZb2x0?=
 =?utf-8?B?UHJrZDVLSncxc0x6bmt5Q2hzcHhMUW0zc09TSDVFWGYrRTMzbXhEdllNdlpm?=
 =?utf-8?B?U1pua3YveU5xVXJ0OUxLcHZ5cXM1UkFpOHdGZldSYWlJbDNyb2lrdFkrc3N6?=
 =?utf-8?B?WW9PeFhrZVdDYTZhNDJZS1pJVnpqS3VVdWlwcjBZWmdoV3NIMkpyZlNPbnM0?=
 =?utf-8?B?bGM3TXUrOGpDWFY4UE5BYkVHOTlmVFBxZE9pb2pPcjFmT1cvNzdLNnFiOUQv?=
 =?utf-8?B?RHdSWmx2VVJOZE5MNDhyT1N6TEN2N0J0ODQ5QkVoOWZXSGZobFc5VTJlVFBF?=
 =?utf-8?B?MGlBRk1HU0VjZmViKysyZDJhRENxd3pZcEdxRzB3RTl6dzc2b0xMU2JscE1r?=
 =?utf-8?B?ZDMxbjJVVk9HUlhsczEzM3BUaVdTVDZCSU1xS1NOSDFtY05xUFhyWmR6YWUy?=
 =?utf-8?B?NXBtQ0tGeVJYVGxGRE5oTUJuanNEYUF1dFNQQmNyR3RsYjFxUGJBVEp1Nml4?=
 =?utf-8?B?eXFBN3hqbkdkcUxxSXBHSm1QRC9LOU9mZ0RkZlNZQ2Q5SmJmQXZlNmZKWGt0?=
 =?utf-8?B?MVpVWUFjcFBBWXpjUnE1Y21qZmc0WCtYc2U4TmJZR2NXeXl0Wnd5WVo3QnFL?=
 =?utf-8?Q?LXHtfgQYTdgZrBEpT+QItEpXn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3070b885-fd94-4af4-d4b9-08dbdb4b5ea1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 02:28:16.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02AbkjNqll62aFurMfa+PigGdVh4D0KfhCyL5rxPNve/xyUtdn+SJvsU545a4sfADBRuAIbBiLLC6TunbrVsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9397


On 1/11/23 22:05, Jonathan Cameron wrote:
> On Wed, 1 Nov 2023 08:27:17 +0100
> Lukas Wunner <lukas@wunner.de> wrote:
> 
> Thanks Alexy, this is a great discussion to kick off.
> 
>> On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
>>> - device_connect - starts CMA/SPDM session, returns measurements/certs,
>>> runs IDE_KM to program the keys;
>>
>> Does the PSP have a set of trusted root certificates?
>> If so, where does it get them from?
>>
>> If not, does the PSP just blindly trust the validity of the cert chain?
>> Who validates the cert chain, and when?
>> Which slot do you use?
>> Do you return only the cert chain of that single slot or of all slots?
>> Does the PSP read out all measurements available?  This may take a while
>> if the measurements are large and there are a lot of them.
> 
> I'd definitely like their to be a path for certs and measurement to be
> checked by the Host OS (for the non TDISP path). Whether the
> policy setup cares about result is different question ;)

Yup, the PSP returns these to the host OS anyway. And one of reasons why 
I wanted the same module in both host and guest for exposing these 
certs/meas to the userspace.

>>
>>> - tdi_info - read measurements/certs/interface report;
>>
>> Does this return cached cert chains and measurements from the device
>> or does it retrieve them anew?  (Measurements might have changed if
>> MEAS_FRESH_CAP is supported.)
>>
>>
>>> If the user wants only CMA/SPDM, the Lukas'es patched will do that without
>>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
>>> sessions).
>>
>> It can co-exist if the pci_cma_claim_ownership() library call
>> provided by patch 12/12 is invoked upon device_connect.
>>
>> It would seem advantageous if you could delay device_connect
>> until a device is actually passed through.  Then the OS can
>> initially authenticate and measure devices and the PSP takes
>> over when needed.
> 
> Would that delay mean IDE isn't up - I think that wants to be
> available whether or not pass through is going on.
> 
> Given potential restrictions on IDE resources, I'd expect to see an explicit
> opt in from userspace on the host to start that process for a given
> device.  (udev rule or similar might kick it off for simple setups).
> 
> Would that work for the flows described?

This would work but my (likely wrong) intention was also to run 
necessary setup in both host and guest at the same time before drivers 
probe devices. And while delaying it in the host is fine (well, for us 
in AMD, as we are aiming for CoCo/TDISP), in the guest this means less 
flexibility in enlightening the PCI subsystem and the guest driver: 
ideally (or at least initially) the driver is supposed to probe already 
enabled and verified device, as otherwise it has to do SWIOTLB until the 
userspace does the verification and kicks the driver to go proper direct 
DMA (or reload the driver?).

> Next bit probably has holes...  Key is that a lot of the checks
> may fail, and it's up to host userspace policy to decide whether
> to proceed (other policy in the secure VM side of things obviously)
> 
> So my rough thinking is - for the two options (IDE / TDISP)
> 
> Comparing with Alexey's flow I think only real difference is that
> I call out explicit host userspace policy controls. I'd also like

My imagination fails me :) What is the host supposed to do if the device 
verification fails/succeeds later, and how much later, and the device is 
a boot disk? Or is this userspace going to be limited to initramdisk? 
What is that thing which we are protecting against? Or it is for CUDA 
and such (which yeah, it can wait)?

> to use similar interfaces to convey state to host userspace as
> per Lukas' existing approaches.  Sure there will also be in
> kernel interfaces for driver to get data if it knows what to do
> with it.  I'd also like to enable the non tdisp flow to handle
> IDE setup 'natively' if that's possible on particular hardware.
> 
> 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
>     a failure in general so reject device - or it might decide it's up to
>     the PSP etc.   (userspace can see if it succeeded)
>     I'd argue host software can launch this at any time.  It will
>     be a denial of service attack but so are many other things the host
>     can do.

Trying to visualize it in my head - policy is a kernel cmdline or module 
parameter?

> 2. TDISP policy decision from host (userspace policy control)
>     Need to know end goal.

/sys/bus/pci/devices/0000:11:22.3/tdisp ?

> 3. IDE opt in from userspace.  Policy decision.
>    - If not TDISP
>      - device_connect(IDE ONLY) - bunch of proxying in host OS.
>      - Cert chain and measurements presented to host, host can then check if
>        it is happy and expose for next policy decision.
>      - Hooks exposed for host to request more measurements, key refresh etc.
>        Idea being that the flow is host driven with PSP providing required
>        services.  If host can just do setup directly that's fine too.

I'd expect the user to want IDE on from the very beginning, why wait to 
turn it on later? The question is rather if the user wants to panic() or 
warn() or block the device if IDE setup failed.

>    - If TDISP (technically you can run tdisp from host, but lets assume
>      for now no one wants to do that? (yet)).
>      - device_connect(TDISP) - bunch of proxying in host OS.
>      - Cert chain and measurements presented to host, host can then check if
>        it is happy and expose for next policy decision.

On AMD SEV TIO the TDISP setup happens in "tdi_bind" when the device is 
about to be passed through which is when QEMU (==userspace) starts.

> 
> 4. Flow after this depends on early or late binding (lockdown)
>     but could load driver at this point.  Userspace policy.
>     tdi-bind etc.

Not sure I follow this. A host or guest driver?


>>
>>> If the user wants only IDE, the AMD PSP's device_connect needs to be called
>>> and the host OS does not get to know the IDE keys. Other vendors allow
>>> programming IDE keys to the RC on the baremetal, and this also may co-exist
>>> with a TSM running outside of Linux - the host still manages trafic classes
>>> and streams.
>>
>> I'm wondering if your implementation is spec compliant:
>>
>> PCIe r6.1 sec 6.33.3 says that "It is permitted for a Root Complex
>> to [...] use implementation specific key management."  But "For
>> Endpoint Functions, [...] Function 0 must implement [...]
>> the IDE key management (IDE_KM) protocol as a Responder."
>>
>> So the keys need to be programmed into the endpoint using IDE_KM
>> but for the Root Port it's permitted to use implementation-specific
>> means.
>>
>> The keys for the endpoint and Root Port are the same because this
>> is symmetric encryption.
>>
>> If the keys are internal to the PSP, the kernel can't program the
>> keys into the endpoint using IDE_KM.  So your implementation precludes
>> IDE setup by the host OS kernel.
> 
> Proxy the CMA messages through the host OS. Doesn't mean host has
> visibility of the keys or certs.  So indeed, the actual setup isn't being done
> by the host kernel, but rather by it requesting the 'blob' to send
> to the CMA DOE from PSP.
> 
> By my reading that's a bit inelegant but I don't see it being a break
> with the specification.
> 
>>
>> device_connect is meant to be used for TDISP, i.e. with devices which
>> have the TEE-IO Supported bit set in the Device Capabilities Register.
>>
>> What are you going to do with IDE-capable devices which have that bit
>> cleared?  Are they unsupported by your implementation?
>>
>> It seems to me an architecture cannot claim IDE compliance if it's
>> limited to TEE-IO capable devices, which might only be a subset of
>> the available products.
> 
> Agreed.  If can request the PSP does a non TDISP IDE setup then
> I think we are fine.  If not then indeed usecases are limited and
> meh, it might be a spec compliance issue but I suspect not as
> TDISP has a note at the top that says:
> 
> "Although it is permitted (and generally expected) that TDIs will
> be implemented such that they can be assigned to Legacy VMs, such
> use is not the focus of TDISP."
> 
> Which rather implies that devices that don't support other usecases
> are allowed.
> 
>>
>>
>>> The next steps:
>>> - expose blobs via configfs (like Dan did configfs-tsm);
>>> - s/tdisp.ko/coco.ko/;
>>> - ask the audience - what is missing to make it reusable for other vendors
>>> and uses?
>>
>> I intend to expose measurements in sysfs in a measurements/ directory
>> below each CMA-capable device's directory.  There are products coming
>> to the market which support only CMA and are not interested in IDE or
>> TISP.  When bringing up TDISP, measurements received as part of an
>> interface report must be exposed in the same way so that user space
>> tooling which evaluates the measurememt works both with TEE-IO capable
>> and incapable products.  This could be achieved by fetching measurements
>> from the interface report instead of via SPDM when TDISP is in use.
> 
> Absolutely agree on this and superficially it feels like this should not
> be hard to hook up.

True. sysfs it is then. Thanks,

> 
> There will also be paths where a driver wants to see the measurement report
> but that should also be easy enough to enable.
> 
> Jonathan
>>
>> Thanks,
>>
>> Lukas
>>
> 

-- 
Alexey



