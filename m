Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2457D7BF1D2
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 06:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442104AbjJJEIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 00:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjJJEIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 00:08:05 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109F492;
        Mon,  9 Oct 2023 21:08:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCEM/mTGm52d0SRJoaxOhUGznmw2u85aUAbpDcdyjUbIEHlIzhI76jnZJ4YMTpVYUFk80Gp9RtY0vuomfwDguJLh8/uZrq6xbNc25hzOQFjfypf0lNsinFqSFkU2ThRNokdQfI7EkSw6Cigqm+6kMCh5ta9n0byjc7jCkf+JY5bD/0u4o+87dZ4X4QmfULOg2aTs8CviZFMvqTRqEZKKIITIdfLgsK0mmD/c5sJFwrhnJbk8ysDZiKofZPuWwdKUZ8cmqjsiYkXqdUoUd22MECtA5d8+j4KdyyGmqCDr7eRJVSoypiFbtOe4Q/ymqOiEoVCAsNYptovdS1OJpJ/Wyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBcj8tCTAtputGgpp5zkWwW28RAAc4nYDKcZ5yMj1ng=;
 b=klijszL8vmjtxnQKNrMfuyjpfSPb2RYAHlnpVP533QWbqF0eR1Wcv1dgsJYf0vntsMsNKhULU0rC4C5G51XChzqHJsf5XMHdPONMm9xh19wy4o8NeuWWh7IXw4spVVJEJVpXzUccw471XoeV6PMYl+BP/Sm/tYVD5a2M9j2xJLCSta2mzvIQ54z5YFidY/wEaEZxO7B+Qug5tK5UpcgDG8+6XVfB6NoS3QZC93iigBn3gMUXLVkbccqZ3eZw/3yPBBbNgEB8k4q5Ms3TjrlD7gp0qOVrJ739CCRQZ1Qh6bcmkGgd4zyQyJe1/BwDAE1wfH4nr6KqIctSBW9ZTSkhaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBcj8tCTAtputGgpp5zkWwW28RAAc4nYDKcZ5yMj1ng=;
 b=UpQxTBRxvFatL+3lslW9FqSGAxbkPnLLWmnFKTSH6VVeWdVeogpyOGLEs3fkm/L7TMXwimPJA1VNOByML21UyPppJVqyFkzOuH6hFkNLbm1nV5UbaByGaxszGMhaVb2RZ54Ewf5bHs1mDqTaORwHHIkeH9FhWicim0BMZbQkrmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA0PR12MB4591.namprd12.prod.outlook.com (2603:10b6:806:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 04:07:59 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 04:07:58 +0000
Message-ID: <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
Date:   Tue, 10 Oct 2023 15:07:41 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] PCI device authentication
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
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
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20231009134950.GA7097@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0021.namprd18.prod.outlook.com
 (2603:10b6:806:f3::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA0PR12MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 0841404f-5fde-437f-801b-08dbc9467c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O8l+1vn0l6M+buheCDl+oikQGKva8lgUMZKtuFLw3Ozk+exkKPmnxusDeopnrc30Mb4DYoPSCRNRBZeBu2rsedMYLSTN5glxuOPGTXleK0tZoc68xs5lRB9KOogms0l2KU2hVMORPCa9A8IZ/EaX1PxHOxvdOXoYpFtvYsjXXFe4qRHhMAYFQFDPtfLWnsNqJgmMJ1kwEjdDtlKdrQfwzAOOALvcTiZPZ5vvL6k4IgPPRMREA1oQfs1IC8H8nT2O3Ed6G4Ax8mBX+hRfpYR03wXF5tbqapQeQ9dIB6txevIkeJJAqD7J+8C6GQ83MxJFoHNG6Oj0CasV6IR8bujKExy//QDFexYDyy+jQ0APiAiMJhkRh/ccJ5TcNU9Snq06ue6RYlIx+ekaY7C2yzmqsPIt9y9+hf+QkxcDWy7LJRzjfQtl2+xrax01hvWtXHnWh4rTsslA5fcz+6BtwqYNy4iZBHoDXlLNxaneTlrrKJ+rQ7ecapfvIVp0tenU7WAH4yo9UF37HBFMH3oBPpW7HlemvGmFb+o+jZ5pqY/fcaWcuTBwEcYMbzn3V/awyk8g+XzaT7RwCwP8eq6UVEYeIbXdWtfXgPgZ6Rr+hMcnl7SU6CvRNulFGVH8OvArERWg7At2V05jG4NGLScLV+Rudg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6512007)(53546011)(2616005)(6506007)(478600001)(6486002)(6666004)(26005)(83380400001)(7416002)(2906002)(5660300002)(110136005)(54906003)(66476007)(66556008)(66946007)(4326008)(8676002)(8936002)(316002)(41300700001)(36756003)(38100700002)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTFscXh3OW1JbVYwWm1RQTB0VzQ5dkVvR2hDa0N0dHRwWS9Jbkh2MWtiRjl2?=
 =?utf-8?B?NVp6N2JaR2RSK1ZoL3Nad1p2eERJU2RRaWdGTy9KdjVtbWpqL0RTWlpDZEZU?=
 =?utf-8?B?dm9HN2dCR1liaHRIR1lwSnZvbXordHphQUZhSUcvcENVdWp5VTViQXhDTlh1?=
 =?utf-8?B?aE13dG5IQmlOS2J3UDZtRjBhcE4ySm5HLzVPcnZaT1RwT0RoVlNTS0FzSjRK?=
 =?utf-8?B?VU1iTHh0TStsbzQ4WVl5amtiMGNTN0ZhWTUxeGFJOVhLYUpNeEd2eUIxTEhI?=
 =?utf-8?B?VnFpNklOUDZPQUJ3TUlhWFZyTWhjMlhyVTd3eVlwaFZPR2tUMHZJL1BJektL?=
 =?utf-8?B?MHoxL0V3U1liZGc4RmNZa0JrQlFhM3doeEJ1c3M2em95RVJzbkJwSlhLQVRH?=
 =?utf-8?B?OTR1MjdlamZEeW8wWTVHandCUnRMMjkvTk5Cclg1UEpMbFBGbGxWMnhXMTg1?=
 =?utf-8?B?bGhrVVJTNEhybThHL1BzUWVVUWNUMmg0cFc2cHVsY1Uza0Y4a1FQdWQxbXlm?=
 =?utf-8?B?ZWwzM1hFeVB1SnNmRGh1anRqWEl0L3gyR2lPdU52aWJIUnVKTHRjdWt2dGp0?=
 =?utf-8?B?RFhqMjlrTlo0dmRuQlYvMXNXN1RoYXZNcnBjSDhHeWp1OWNMV01SeVZIdk80?=
 =?utf-8?B?UzVpUkIvZTZrUWJJOVd4dCtnUmdzaDVTZ2dPTWwra1IwK1dYejB5WVNDNVpF?=
 =?utf-8?B?Y1JJMVE0eWJNei9pSzJzbzF6YWZvTlhJTURnOUEyeGZvbTBDWWQzSzdSZ1hN?=
 =?utf-8?B?bFlMZmZzQ1IvblFOT2Q0Y29lUmdnZUU2eE8xN2diYUhmeFJYclFhSk8xMUND?=
 =?utf-8?B?Ym0wTmhpQVhNYUYvS0F2TTNITFRRZHozaTdEY3UrMmZWUHpIM0xUVGpjSHNu?=
 =?utf-8?B?YnlUYWNXR3J2VjdyYkxHalhjL0EycUtkNU5HY2wyRjFDdml5TUh1THVRSTFD?=
 =?utf-8?B?OXA3aHU2eHdhMng2WHJPeTlnVzdYcUZEYnhPazFJSXVjYzFGUllMVGl2WmZI?=
 =?utf-8?B?bHd4amRpMkRFTTJKRWJ4THdobEg5a2dNemg4TGlSTjBYUXNMZGlKRzM2U0RX?=
 =?utf-8?B?N3RjN0NnQWxtbE1ZMU5DVVhSMWM3dEdkNktldDdGN1lCS1FzbWZOV1lubzZT?=
 =?utf-8?B?VlBUbE9NVjNuT1hCdFQxSHF5Zm5IbVRDUmRXUFpmZDZ2RENXS0QvN2NGakVV?=
 =?utf-8?B?NFVGaXo1R2JheU1yOTV5YitlMGFOKy9XaGNkS2FsMHk3Q0s1bWlMSmpXdHYr?=
 =?utf-8?B?dlFSSzhhcHdDSm5xQ3dGNFIvQllGbHdQY1dYdFI4ZXc1MFZvZlpNRVJTSm50?=
 =?utf-8?B?OVpIODQ1NGx2K0V3UGs5YUl5YlRGVkhEdkhlTzRSLzVkZ0VaU1VIUGFIbjl3?=
 =?utf-8?B?MmNUUlA5bHpvUmg5bnRiNVJmaGIzMmFvTlMxMHZveGdkVmp5eXVOYWdKMGhQ?=
 =?utf-8?B?Y0c3YTU2TXFiRXgvSko1ZzVudjdOSmJsZDRpTnNDamYyVGdESEdhWTdrRVNO?=
 =?utf-8?B?eEtRRnpkTHJrd0Z0dWNPNEpyZjN1M3lNR20vdlpRUTlIanJ5RTNEb2ZYZGJM?=
 =?utf-8?B?dHMrayttN1VndXV1Tlhqd2JXbWkzMVFSTmRvVlNadXd1eXNWWmE4SE5RdHJI?=
 =?utf-8?B?TS9sL0tETzJ3UFcxZ3hPWS9ZVTZ0RGdpZjJJSEFXKzF4L3JmbGpqRXNWcnQx?=
 =?utf-8?B?bFFPRmc1QnowKzhjS1BETVVvRElYazhoem9EV0dTdWR2YytLVnZuWGlOLzRJ?=
 =?utf-8?B?M1g5L1E1REpzRWs4d2YrbSt4c24vYlI2a21BRU9IRXJoSGg2dXpjMmlYeHR4?=
 =?utf-8?B?dy9VMXhiK1NsQjlIc2NsWGpiTjhSM0dDL29qN1p6UWhMVnJXQjcya1B6UVRE?=
 =?utf-8?B?S0tTQms5ZkVXWjNydG9BbzJ6akR5UXBWNElXMTAyZWV1cnpmNlYya2ErUmgv?=
 =?utf-8?B?T0FraC91Z2IvOHdkUkR6bG5pRmhnQTE4VnVuNDhJMFdjNElGeURiN2ZWdmtu?=
 =?utf-8?B?MlFaMjZMbG5YU2F1dC83VGV4V0h0ck1MQUdHT2laNXlZNnNZOEpCc1hxUERq?=
 =?utf-8?B?VFVNV0wzeDhGLzlDTTJxUURVTC91OXdVdFhiZHdTV2dnTTRsYWJSVm0zQXNM?=
 =?utf-8?Q?2sXJaay40Xbo3z+uTMLc/kIXp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0841404f-5fde-437f-801b-08dbc9467c94
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 04:07:58.2609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aF9yNIV4yXER+Zr8s1GApZAZ2PeGjHELtyqfXCC8tILrwU1Zdz0mzbo5Wsu7Yg0/QyQ+Boo5W4yKDJxrTAjvyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4591
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/23 00:49, Lukas Wunner wrote:
> On Mon, Oct 09, 2023 at 12:33:35PM +0100, Jonathan Cameron wrote:
>> On Sat, 7 Oct 2023 12:04:33 +0200 Lukas Wunner <lukas@wunner.de> wrote:
>>> On Fri, Oct 06, 2023 at 09:06:13AM -0700, Dan Williams wrote:
>>>> Linux also has an interest in accommodating opt-in to using platform
>>>> managed keys, so the design requires that key management and session
>>>> ownership is a system owner policy choice.
>>>
>>> You're pointing out a gap in the specification:
>>>
>>> There's an existing mechanism to negotiate which PCI features are
>>> handled natively by the OS and which by platform firmware and that's
>>> the _OSC Control Field (PCI Firmware Spec r3.3 table 4-5 and 4-6).
>>>
>>> There are currently 10 features whose ownership is negotiated with _OSC,
>>> examples are Hotplug control and DPC configuration control.
>>>
>>> I propose adding an 11th bit to negotiate ownership of the CMA-SPDM
>>> session.
>>>
>>> Once that's added to the PCI Firmware Spec, amending the implementation
>>> to honor it is trivial:  Just check for platform ownership at the top
>>> of pci_cma_init() and return.
>>
>> This might want to be a control over the specific DOE instance instead
>> of a general purpose CMA control (or maybe we want both).
>>
>> There is no safe way to access a DOE to find out if it supports CMA
>> that doesn't potentially break another entity using the mailbox.
>> Given the DOE instances might be for something entirely different we
>> can't just decide not to use them at all based on a global control.
> 
> Per PCIe r6.1 sec 6.31.3, the DOE instance used for CMA-SPDM must support
> "no other data object protocol(s)" besides DOE discovery, CMA-SPDM and
> Secured CMA-SPDM.
> 
> So if the platform doesn't grant the OS control over that DOE instance,
> unrelated DOE instances and protocols (such as CDAT retrieval) are not
> affected.
> 
> E.g. PCI Firmware Spec r3.3 table 4-5 could be amended with something
> along the lines of:
> 
>    Control Field Bit Offset: 11
> 
>    Interpretation: PCI Express Component Measurement and Authentication control
> 
>    The operating system sets this bit to 1 to request control over the
>    DOE instance supporting the CMA-SPDM feature.
> 
> You're right that to discover the DOE instance for CMA-SPDM in the
> first place, it needs to be accessed, which might interfere with the
> firmware using it.  Perhaps this can be solved with the DOE Busy bit.
> 
> 
>> Any such control becomes messy when hotplug is taken into account.
>> I suppose we could do a _DSM based on BDF / path to device (to remain
>> stable across reenumeration) and config space offset to allow the OS
>> to say 'Hi other entity / firmware are you using this DOE instance?"
>> Kind of an OSC with parameters.  Also includes the other way around that
>> the question tells the firmware that if it says "no you can't" the OS
>> will leave it alone until a reboot or similar - that potentially avoids
>> the problem that we access DOE instances already without taking care
>> about this
> 
> PCI Firmware Spec r3.3 table 4-7 lists a number of _DSM Definitions for
> PCI.  Indeed that could be another solution.  E.g. a newly defined _DSM
> might return the offset in config space of DOE instance(s) which the OS
> is not permitted to use.
> 
> 
>> (I dropped ball on this having raised it way back near start
>> of us adding DOE support.)
> 
> Not your fault.  I think the industry got a bit ahead of itself in
> its "confidential computing" frenzy and forgot to specify these very
> basic things.
> 
> 
>> If we do want to do any of these, which spec is appropriate?  Link it to PCI
>> and propose a PCI firmware spec update? (not sure they have a code
>> first process available) or make it somewhat generic and propose an
>> ACPI Code first change?
> 
> PCI Firmware Spec would seem to be appropriate.  However this can't
> be solved by the kernel community.

How so? It is up to the user to decide whether it is SPDM/CMA in the 
kernel   or   the firmware + coco, both are quite possible (it is IDE 
which is not possible without the firmware on AMD but we are not there yet).

But the way SPDM is done now is that if the user (as myself) wants to 
let the firmware run SPDM - the only choice is disabling CONFIG_CMA 
completely as CMA is not a (un)loadable module or built-in (with some 
"blacklist" parameters), and does not provide a sysfs knob to control 
its tentacles. Kinda harsh.

Note, this PSP firmware is not BIOS (which runs on the same core and has 
same access to PCI as the host OS), it is a separate platform processor 
which only programs IDE keys to the PCI RC (via some some internal bus 
mechanism) but does not do anything on the bus itself and relies on the 
host OS proxying DOE, and there is no APCI between the core and the psp.


>  We need to talk to our confidential
> computing architects and our representatives at the PCISIG to get the
> spec amended.
> 
> Thanks,
> 
> Lukas

-- 
Alexey

