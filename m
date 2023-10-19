Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957FC7CF1D8
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 09:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjJSH7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 03:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjJSH7T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 03:59:19 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2082.outbound.protection.outlook.com [40.107.212.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394CD115;
        Thu, 19 Oct 2023 00:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXK4VG1dFhjDYtUX/cgnnSXItiLJ2tKiE6f/7IzXAQzb8Df6a8Jkz2FkZayBa6RlhIqqLMr77qM95sumVfqJ127ApLgSvcCvkF603AvsHcflOWxE3JA6TBDGJJuS/sGEsCD8u66K48l+K9jZtZJJpCJrDRT8rmiK4mbxZOMRCQBWe9GChqQtia81txkfMgVwreHc5huwaZgbO69FNVlj8SGGOywvpBZpiUdh2qVxWNb6+nzYqo46GGfwhqm3dijw1jb47AUjVp1rUnjpaNYFFpNq+y08k2SK/BzJPDXU2dOq3rovPUXcE4B9p03nYD2dS+sg69KLEVzJDATXF3GmTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QHAmxlFJLIR2mo7V348R9DtlGxEENwP09jhhvhi6GNI=;
 b=TkIGb/mySE5+DLQRHsPYOXMp+JI3jpL9kQSA/LRSI1BA3A33HqYrkLqMHZr33g26JcmiuFn86WZEiV3Zsrz8LvOhu+wezAtzXquGf494xxFEMf+l1K7cayNocTLrxI05U7jAMbYumkU0elkap5otQQLHnIS5MwTWOYRfK8IsYH2wRfUlxUe2edeghPVkLhXwjicEM+9LpAehJa9bvBmDJ37ZUQfJSW/K+SaN4a4rhC7TkHSukcKZb17v8+9wFZEHM9YxEa5hlK0YqoE5b8dLOMbkhd2+gkPg6PckkoGAIsXkvJGQotIS/yoVish6ziG6QuAX6t3C+haqa1Mh/jnytg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHAmxlFJLIR2mo7V348R9DtlGxEENwP09jhhvhi6GNI=;
 b=KPNSk+w/PKal9tKbC6xYfOulZ/QLIIlSJj7iPx2/pSiP20bspkP/rbtNngvfFMYzsvcsqrNCWa9MefGpP4Vn0zHKQaDCvEL3g1CtBQTXr0AzpAyZ564Kziw86ruXVY7+Ojblxka0KTikTsgZGggjrJ/SBzV/lho62gVDX2DmruY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB7630.namprd12.prod.outlook.com (2603:10b6:8:11d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 07:59:13 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::16da:8b28:d454:ad5a%3]) with mapi id 15.20.6863.043; Thu, 19 Oct 2023
 07:59:13 +0000
Message-ID: <38d0c5ce-7de2-47fb-bfaf-50f900b7f747@amd.com>
Date:   Thu, 19 Oct 2023 18:58:51 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] PCI/CMA: Grant guests exclusive control of
 authentication
Content-Language: en-US
To:     Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
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
 <467bff0c4bab93067b1e353e5b8a92f1de353a3f.1695921657.git.lukas@wunner.de>
 <20231003164048.0000148c@Huawei.com> <20231003193058.GA16417@wunner.de>
 <20231006103020.0000174f@Huawei.com>
 <653038c93a054_780ef294e9@dwillia2-xfh.jf.intel.com.notmuch>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <653038c93a054_780ef294e9@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::23) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB7630:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ab2573-c898-4ec6-a03c-08dbd07948a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IDUqrjQ1313Kb0j3POvF3LrFYK8vdz9GNEGXQuW/qHz++bBeNLrFckor3a+t0t1tt/5UChUtE5Y1zWVHLJfVl0gfM5jF3DjHryGF8eicRZy91FLpDU020D8pufhSyrwfE+B8qFkyRyqMexkS2vXsIlZOudJixsns19K5vUDR7yI+V1mE9WsKbhJNZ7f2gOFPFi9UFcXkVNZXDNDLtMKtRUfN8FVW9GsAJwrVHxYcasqqhtKFQTA4SXIolnp3lQ/UWmwIL9hRPqK0wxkJ2GVe8MwDpVyTujBSchklCPbASVns47zsBNIpsktgcYv8Y+xiMlEJfSdC9tDa2jZEtNbouCc8gWSqNnhfWOEaOPelJOLz3M0/br9/7XcLdAp2PpnAx/XwkzutapGN9PCpf7Jk71ptViECtUyQVo8zRbKThSrL/M78rWMXPGKwYfsWs/awBqCfyNbbLbob4TckxjjGKxhDaCRDrW0eDVX0YSd7bmNhqP1JmAa2lESYSPRXmawgrYngembkJKvMPl+CkF7QpUKdQGcWV62VJOL8zLZAp/X3NpXdArhH2VkK32gQiiOq5VJImuNTYqqLOF2a6uMhYEDGiIb9yY1EIFgcQr3ObJ0jz9EegQSsMJrZGOvv0iJSc8V81QZAECzvaynfbXH/TQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(136003)(346002)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(41300700001)(7416002)(53546011)(5660300002)(8936002)(8676002)(4326008)(38100700002)(36756003)(31686004)(2906002)(83380400001)(31696002)(66946007)(54906003)(66556008)(66476007)(316002)(26005)(2616005)(6512007)(6666004)(110136005)(6506007)(6486002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm9GNUVJczhLUUhXd1k2QzhNNStHbHpMT1J0dk1PWWNFM29OazgraEZyVlBE?=
 =?utf-8?B?VTJjNzBhMHJYWDE5Tnc4TUhxZHNneVdma3dHdm9zN0xWdENwSGlLanNIMDVF?=
 =?utf-8?B?MnA2Ynl5cm14b0FhU0tFcWJJS3hxdW5BVW5oTmZocTFRcm5YbDErdVRkcllF?=
 =?utf-8?B?VDNObVl1RjY0SjZIeml5TnR3Y3N3UVBHSktrSE5KbmJpV1RibXg0SFpGR2h5?=
 =?utf-8?B?M0piaDQ2MTlnWE85OVpEcElZeGxUcHRtR3N1UHZoQ0VyNkd2cmxjcWZRMFhM?=
 =?utf-8?B?aGpiWFRPWmx0cml3aFhqQnZTR2pzRURBTVVjeGNHbVB2RDA4UzVyNnFSWE50?=
 =?utf-8?B?NVFMQitIWnNvQmZvTVF0MThxem5xbU0rWUl3UnYrVmd3MEIxT3JaQ1ltWG9Z?=
 =?utf-8?B?eC9CNUNnREZkY0VzczhFeDZKa0l3aUlPc29iNVNzUFpvQUNEUWg3eWtEdHFn?=
 =?utf-8?B?VHR5MDhyUTAyRkYwUWR1anBFcUd1eE9oKzJwTjRJbTk1WWtKTFdmcS92eWVL?=
 =?utf-8?B?Vzl0Q3VXZWtvNnZXU250eWlaa1NhU2x4aUVuVjVZWDZDMkNKUWV1c3ZaV0pL?=
 =?utf-8?B?ZDRYTTduN1BndGJ4SFpXRmZLNjBxU2pZU3NWZXdPTDBTcThrYXVCNVdUN0oz?=
 =?utf-8?B?Q1BxMnk3aDhieDhZN0cybHVFNHBhakVKaEdNcGU0UzBvcGJRZFJ3TXFlSElS?=
 =?utf-8?B?Ujh3K2NWWHhFVGx3SDEwbmROM2tIVG43U1RxYjBldjIra0YycmsrWkJBaGFK?=
 =?utf-8?B?Z3dnRHZpWkVPZmJNdnRCWlRsWHF5MUlvbUxZbE12T3FoRzB3eDBrazlnR0tq?=
 =?utf-8?B?NDd2UDVqTzRCK3NyNUltUWxlVEc4Q1RvakhGdXlNbzgrZHBMNmxWMjM4cmM2?=
 =?utf-8?B?OWMrZ3E3OGllZldldGpoQkxXLzYxOUtFZU1SMXJEbHgxSmtxc2J4YUR3ajdC?=
 =?utf-8?B?ZGxyMGdoTWljdnlhMjVkdnU1dCtNeGo1dmVMWXd5RnBtb1dVY2pOSUVLY2J6?=
 =?utf-8?B?ZEpNbG9LOHozUzllbFJPR3dMR2QzRGdobnEraUs1KzNjWjB2NkNoSWtMeCs0?=
 =?utf-8?B?M3pMRTV6Rkw1TlRFWDhiVUozaThFKzdFSm1PMk5pZ3JEOEpDSGRuT1lwMVBO?=
 =?utf-8?B?TkxJcHZxNzNmZDdXaW52b05wSXNwalcrSGtQVDRnUGpIVTFhMjRRV2dkd3lq?=
 =?utf-8?B?L003TzJVelVIcjkwUWJMcEcxb25vUUp0TUNhekkzNEE5QjdiOUpYWkNTS2dG?=
 =?utf-8?B?cmVIN3ZrMndqU2ZTZmpUUk9lYldZeWxlVUF2RnIzcm9jZGZ3SWFWNnl5SHI4?=
 =?utf-8?B?R1ZkVDJzN21SMEVBV09Sc0daUHRYRmpEeDJ1NnU3cFZSckZoSndXNVpMTDFa?=
 =?utf-8?B?cDJaZmtsc2xQb2djZ3A3ZWcxd29DalppSUM3R2dzckhWTm93VVI1YnFSOFI4?=
 =?utf-8?B?dlBLNEhpUkpvKzJSbytMcFBodVFFTVQwaXFIaDF0UkxuMVJHNUZpVkgwRUdX?=
 =?utf-8?B?enhSK0dFZVRTZmVqTUN3WjhOclNyR3d6WmI0bTNJOGd1cWpUVmltRVBkcnFF?=
 =?utf-8?B?eDdNMEtUYWRQUjgySkMvM0ZjWmlNd2ZJYit0SjducVdiQ081ZGlYRm1UV0Na?=
 =?utf-8?B?ZFRQc1lGY2NKOWFGUFdLcFl5WXlTVFZEYWxUT1pBSjYwUkJKczRyTldVK1lR?=
 =?utf-8?B?N0FLRGZ5NldkYVRvV05GRGxSZ2dNR3RYTW1zS25obkk5eWZZQUt1cWRiTmdI?=
 =?utf-8?B?dGFnelJZeEJ1bFMrQUJ6c0hkYnBDb01mdkluQ1NqZ29GaXRSYXNiQlZockFu?=
 =?utf-8?B?Z05FeDBPZDVDYSttSE4xOUhGWkhKaThJbWJpMytQUjM5K3dsWnN2ei9CUDNU?=
 =?utf-8?B?dTY1UnUvN0ZZcXpQdXBjaWx0TkNyYVB3QW00T2NhWUNkUlZ2RlVWeWplMXhy?=
 =?utf-8?B?cWNTZ2VPd0QwL083YkpsVjlDMFY5blJLaXZsQVdyQkczU05zV295RDdaU0Ir?=
 =?utf-8?B?Q1RCTlFOVWIyQjBHcHN4QXdGUG5MSGZadjd3N3RjYUx1TG5MRGorT3ZGQ1JL?=
 =?utf-8?B?SWZYSzc2Q1VMZmZ1ZzJJVDFlYlFYRHFDZW9mK0NTcHNhRitocWhxWnFCbDVp?=
 =?utf-8?Q?aceT1WWKd87kuq2vabtINvBzw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ab2573-c898-4ec6-a03c-08dbd07948a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 07:59:13.4263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2ZoLnxvGDDJWF1YRbLxzGMLKxGIyOQ0HZ5l6rsIz74kGLNY+T/FTwaixa+VbbXUrvwvOTjvOEWKoIni2GBe6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7630
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 19/10/23 06:58, Dan Williams wrote:
> Jonathan Cameron wrote:
>> On Tue, 3 Oct 2023 21:30:58 +0200
>> Lukas Wunner <lukas@wunner.de> wrote:
>>
>>> On Tue, Oct 03, 2023 at 04:40:48PM +0100, Jonathan Cameron wrote:
>>>> On Thu, 28 Sep 2023 19:32:42 +0200 Lukas Wunner <lukas@wunner.de> wrote:
>>>>> At any given time, only a single entity in a physical system may have
>>>>> an SPDM connection to a device.  That's because the GET_VERSION request
>>>>> (which begins an authentication sequence) resets "the connection and all
>>>>> context associated with that connection" (SPDM 1.3.0 margin no 158).
>>>>>
>>>>> Thus, when a device is passed through to a guest and the guest has
>>>>> authenticated it, a subsequent authentication by the host would reset
>>>>> the device's CMA-SPDM session behind the guest's back.
>>>>>
>>>>> Prevent by letting the guest claim exclusive CMA ownership of the device
>>>>> during passthrough.  Refuse CMA reauthentication on the host as long.
>>>>> After passthrough has concluded, reauthenticate the device on the host.
>>>>
>>>> Is there anything stopping a PF presenting multiple CMA capable DOE
>>>> instances?  I'd expect them to have their own contexts if they do..
>>>
>>> The spec does not seem to *explicitly* forbid a PF having multiple
>>> CMA-capable DOE instances, but PCIe r6.1 sec 6.31.3 says:
>>> "The instance of DOE used for CMA-SPDM must support ..."
>>>
>>> Note the singular ("The instance").  It seems to suggest that the
>>> spec authors assumed there's only a single DOE instance for CMA-SPDM.
>>
>> It's a little messy and a bit of American vs British English I think.
>> If it said
>> "The instance of DOE used for a specific CMA-SPDM must support..."
>> then it would clearly allow multiple instances.  However, conversely,
>> I don't read that sentence as blocking multiple instances (even though
>> I suspect you are right and the author was thinking of there being one).
>>
>>>
>>> Could you (as an English native speaker) comment on the clarity of the
>>> two sentences "Prevent ... as long." above, as Ilpo objected to them?
>>>
>>> The antecedent of "Prevent" is the undesirable behaviour in the preceding
>>> sentence (host resets guest's SPDM connection).
>>>
>>> The antecedent of "as long" is "during passthrough" in the preceding
>>> sentence.
>>>
>>> Is that clear and understandable for an English native speaker or
>>> should I rephrase?
>>
>> Not clear enough to me as it stands.  That "as long" definitely feels
>> like there is more to follow it as Ilpo noted.
>>
>> Maybe reword as something like
>>
>> Prevent this by letting the guest claim exclusive ownership of the device
>> during passthrough ensuring problematic CMA reauthentication by the host
>> is blocked.
> 
> My contribution to the prose here is to clarify that this mechanism is
> less about "appoint the guest as the exslusive owner" and more about
> "revoke the bare-metal host as the authentication owner".
> 
> In fact I don't see how the guest can ever claim to "own" CMA since
> config-space is always emulated to the guest.

No difference to the PSP and the baremetal linux for this matter as the 
PSP does not have direct access to the config space either.

> So the guest will always
> be in a situation where it needs to proxy SPDM related operations. The
> proxy is either terminated in the host as native SPDM on behalf of the
> guest, or further proxied to the platform-TSM.
> 
> So let's just clarify that at assignment, host control is revoked, and
> the guest is afforded the opportunity to re-establish authentication
> either by asking the host re-authenticate on the guest's behalf, or
> asking the platform-tsm to authenticate the device on the guest's
> behalf.
> ...and even there the guest does not know if it is accessing a 1:1 VF:PF
> device representation, or one VF instance of PF where the PF
> authentication answer only occurs once for all potential VFs.
> 
> Actually, that brings up a question about when to revoke host
> authentication in the VF assignment case? That seems to be a policy
> decision that the host needs to make globally for all VFs of a PF. If
> the guest is going to opt-in to relying on the host's authentication
> decision then the revoking early may not make sense.

> It may be a
> decision that needs to be deferred until the guest makes its intentions
> clear, and the host will need to have policy around how to resolve
> conflicts between guestA wants "native" and guestB wants "platform-TSM".
> If the VFs those guests are using map to the same PF then only one
> policy can be in effect.

To own IDE, the guest will have to have exclusive access to the portion 
of RC responsible for the IDE keys. Which is doable but requires passing 
through both RC and the device and probably everything between these 
two.  It is going to be quite different "host-native" and 
"guest-native". How IDE keys are going to be programmed into the RC on 
Intel?


-- 
Alexey


