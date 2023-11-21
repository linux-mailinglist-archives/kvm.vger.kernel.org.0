Return-Path: <kvm+bounces-2163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E255B7F28E5
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 10:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CDA91F24BEC
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 09:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528AD3B7BA;
	Tue, 21 Nov 2023 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="kYRjaIBT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2103.outbound.protection.outlook.com [40.107.220.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB0B13D
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 01:26:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCR2QV6dHIms8EqBZW5FPsTDmaL7GOsjWTeQDUtSFG9x7vJHj9RGFc88qUVcA8ojKJLV5Z8iN4iapBYb4upX0ceOg6IoUtPIfsiITSYRBTKn6ztpPXMzvd1gzhFpFsjd9byiHwLIN43oTT8pZFA9bkQJRoMG8mhVVUN9hruK8Ka6lAU1u9zIoIqFprULGzOJM78PciGM/2GWjyOK+1hU5vWN9aPCRy9vPy7HMsdMYTPxa0Zdo/6TrOAZQEG3MLZmIzajfM+OANmfo9JrreSPvtLKRTNhToiSr7gTAfhA+tTJqtkpVNtGw99ueBewhA4pyC90FzUU6eGHkpPBba5gug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQbh201Oh13VsWl6gefsWnccPoSPssTsUJV4y8B3U00=;
 b=LV/7tNlxuE599HdV881Fp1HIFXBhCVVDwGQZ4aC2WRzIC2xna7JSj3EjQ/u3g/0lmPc4Rj7KGjL5FMT2lUSDbVNgAZnul2KhIyAV/3fiDUUQrurEHEU3z/oVexuXzZXEVAF0b5JOaYsexIeFxp1zwSheWnesqAPSp+yw0+bjBpWtjvQRFDdlodlzdh41kyoWgKnyRw33Cdk6I3YES1Tl2TN51Ojq9+zuTTXbeb8GLGW0Z7ZUmTEzXY3OtmNg8Dp3VUw8XCxe+Cg25fvrZZr4Bvc9TlP1oS2BiZOkD3fpg8mmyKyGWAJ99PkiY9YjCsn2+hHrnPzZ23bsuB+1SkapyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQbh201Oh13VsWl6gefsWnccPoSPssTsUJV4y8B3U00=;
 b=kYRjaIBTXI9cz1rNu8Wst2SgozvYG86AUpCdSQqRn8jHTvzE71m6PDNWxYYLD7zOoqH7yHYtZxoIVJpB2xAYmAsg1twQlBVCACFGVgrjaY59y4re+0/4KmecUxeTTYmdT4pFHYQe8Uw4WPg7DktdIX1fqPjTieyTMR1Vdq0fcSo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH7PR01MB8543.prod.exchangelabs.com (2603:10b6:510:2e6::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7002.27; Tue, 21 Nov 2023 09:26:34 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 09:26:33 +0000
Message-ID: <67082409-f432-44b6-bf40-1af9b4b7b569@os.amperecomputing.com>
Date: Tue, 21 Nov 2023 14:56:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <a44660c4-e43a-4663-94c0-9b290ea755e3@os.amperecomputing.com>
 <86ttpfzd5k.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86ttpfzd5k.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:610:4d::20) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH7PR01MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 77d068a0-f4d8-45e3-73bd-08dbea73f31b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4+MrUOjVqenW1qIO5doCw5OkhmZ+tTH3++gf/2r4FaAJB1OcXKYGR/0OwFZP4f/XUhxA4Q/BBZ5Jumt9yZWvQWiQldqkdMNoV1/DdvLX6VO3KQN7b5jlHj1mRZgYaVZoNeb8RFlsTKPv3vJx3lLkBvQ4Rh49MIheD49PoQHJV4woiTHZROfCkkEKe78dsRe2CrANRINphlmvTpXDZysgYTlw6r1GAZq0iWo+etqZYX+5zpGtkbA7oe8DN9m5Mwfvv07+R0UhEddKm1okuywel+jruKVvAWzGd+ljXEq28uPTJRSSkQdwYk2Oa8AjNqaV4B2qdsupxZmRSHBViMbVhy0zkuk7NOBDX+IOHwqvAmWg7oYd+l1EaD5s/DCsqNwxoQpIrcReiqWpPWlkrDagNAIQRdrL2UIaEIKpTIvkCN3a7H5MkkC2t8MMyzGDibHRbXHs5WGLyKYrJjDPXSAMxpOh5iI9NdU/CzONPOkB14uoAE374RRWtypG3ZR/xSsoh2rkaeXesN0E3moZX/kN2I2lnY42sJqsTugKvZkox9ELRSGB+DUB/oCTLW+rlMp5hgvrMHYuverCkXX6+CQXCK5tJcHnbbMlHZvdRl6AQT8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39850400004)(346002)(366004)(396003)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(4326008)(7416002)(6916009)(66476007)(66946007)(66556008)(54906003)(8936002)(5660300002)(8676002)(316002)(83380400001)(26005)(6666004)(53546011)(6506007)(6486002)(478600001)(2616005)(966005)(6512007)(41300700001)(2906002)(38100700002)(86362001)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1JQdUhVdW1tckJjWDFabWljU2NYTEQ5ZkFZMG9EcGxpR2dmVlYzWWkvSlpz?=
 =?utf-8?B?VjN6NXlYcEdYVGFnQVY1ZnUySzJoazlBaHhXTFh4ODVMdW1PbndGVVo5cGhN?=
 =?utf-8?B?T05qTWxUN1RWT3BiMmI4dTZpR2tQclVtVUptUUpaQnJrdVhmTlNhNThRci9p?=
 =?utf-8?B?Zk85eEFmOFNQYStFbkVwT3VySzFmRG44eVB4bkxYVFhvWG11K3RlOXVnNHlO?=
 =?utf-8?B?ZFFtckRFdlNlZlA3MjJRMTdjeFBwRDZHK0dxQmU3NDUvR0VrTlo0bS8zQnlj?=
 =?utf-8?B?bnlmSzJpeDhwL1lUZ1E1eWpIWUEveUdKdS9OR3hReTBSdU1EeVJRb1ptcklB?=
 =?utf-8?B?QzhOWnhCRDR2c2E0OC9TSGx6cndZbWM3QmprV2hqK0Fva05NRkRnOEFjR0dR?=
 =?utf-8?B?U2xWMlByemFjVy9uWGxTWC94d3drTFBKdHVmM1J5WjhhZWFSaG9LOWVLTTNu?=
 =?utf-8?B?YTNvTE9oQm1haTljdEFQeTNLTU1hNnlPWGdDcnhXKzF5VEdIM2xteU9XZEll?=
 =?utf-8?B?aFVycDFheWQ1SVFRcWRzSjVxTWcxTHBtV3pkOC9BNXRIcGdydmNzNUZCd2NO?=
 =?utf-8?B?amk0RDlEYnNVOWJqQSttZm9mMVVXZDFnUVhhV1VnbUJZU290UmlETnV6dytx?=
 =?utf-8?B?czl1d3FER3R1QWNFdmJra2FOYk9rUnJSMENUT0FrVSthUmg4cUFRNE9PeXhy?=
 =?utf-8?B?MmVTQzJrNXhMcVlSN21Sbld1SGlvTWh2UHo3UmgzK1NkTXRBNDBoVTBlRU5D?=
 =?utf-8?B?Lzd3NWdhN0IvcFU4eDVxY2Nmb1NVSVFVRXpPK2JXZzFkWVJPc0U2aFRJNVJJ?=
 =?utf-8?B?TFpqd25OSkV0dVdlMVBJZTJVN2cxVWJMQjMrR0phNnZZZjBqK2ZxS1dIeTdU?=
 =?utf-8?B?NkV6MEZqa3g0ay9sc1gyZEdSS3N0T0R3OCtZbjlUcytnckNQTFY3SG5xVXZX?=
 =?utf-8?B?Vk9rSmlCak5ZVmFaaDJlajZWRHZpMU4yNzMrQnNyLzVLR2oxS3h6OFhRUStS?=
 =?utf-8?B?SDh5YmFjZ2daTGFSVGwxUE1uQVUzZjlRbGhhd3QxR251QS85NFBFYUlSZWkx?=
 =?utf-8?B?M0VsTWF3c0hRWFFkU0RvYklmNHZSSnhXdEtZeUZTY1lhZEdLV05zT2FyQTZa?=
 =?utf-8?B?VWZrRlFlNDkyMEhONnlrUWp6eTZMYTNncjYyL2t5cEZWbUxSVXFhQXBEZFZX?=
 =?utf-8?B?TTkxb0FSQXlMTGt0bkpCaTJvTEg1UCt2c2Q5Y0huR3lwQkt6RnJEdFk5Lzhi?=
 =?utf-8?B?SmtsNDdHS0xQR1g1NFk2L2NLT010WUxaUmgvbXFvZXhkZ1dMNkg4Q2szOGtK?=
 =?utf-8?B?QXltalFrcnlXdDR0YUxKWWZXZXBKREd2ZFhrMkdBb29uYTA3My9PWHJ2blds?=
 =?utf-8?B?MHFhS3hDcStVc01zTyt4cndZeEFQODdOTVlYYTVyeVhnYVdZbng3YkxFRkRs?=
 =?utf-8?B?ODRuQ09qeHBEdE5obVpkS0E2djhYSy9meTBmM2owNG1ObDlhdnFxK0dXYllP?=
 =?utf-8?B?MUhoQlVuajVpU2hvYU9PS2FjQ1hwbXRoWU9IcVF3Mi9OVERWQTJZM1hZU0tY?=
 =?utf-8?B?eEVvNEdkZGJGVFVoRlhtRUFWZGtONmE1M0pHSWt3dDEvWm44dmI5U09YM2Na?=
 =?utf-8?B?aUJzL3dVRlNjTmVyeng2QWE1SzlsWk9HWHRnOGdGY2JYRHhuQWFUa3AvRjNp?=
 =?utf-8?B?cEJDL3RxWk5idlNVRUcyK0NtZ0FXUk1XS0hBOXpoeUFKZ05DQ0wyWmtDb0Q3?=
 =?utf-8?B?Qm14ZCtLT3RBaDdsTmUwNTFUdWFSZzFhQSs2MVNGMTBLRTJiTGhuYzNJWm1h?=
 =?utf-8?B?M1V1dmVLMy9TRDg0dFZYRWhNS1FXOHN1THBuSlVOZSsvblcvV0UzQVRQMVNr?=
 =?utf-8?B?MGMxYkVTcEQ3M25UK2R4K3krVE05ZGZUcmQ2c0ZKdFlRT1dGd01FWmNDTGtm?=
 =?utf-8?B?bnRJaFRWa0hoTnRyYWNoNjh0b3VVV2NyNzJmS3pKK29uelo2VDBpZUJWNjZ6?=
 =?utf-8?B?Ykg1MHFSdnB1RFgzNnpMWGRqT3p2K1lLbXRyYUh4OEJmbGRHR2QvbklkWm1i?=
 =?utf-8?B?YkVJTDFaR21HWXFBdGZDZ280eWNVUzJYcnE1dE0vNS9jTnI4WE92QTV6TVBG?=
 =?utf-8?B?OXFFd1Qva1VZbDQ5NWR1RVJEaStHenh6dnZjTk1iTS85NDhKQzNTRUJGdXVq?=
 =?utf-8?Q?LTmV2tot9hTu04Z7C0WmVj97dcy+dfgMGAmw+/hwafMU?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d068a0-f4d8-45e3-73bd-08dbea73f31b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2023 09:26:33.3709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZGK/zgT0eEKde7JyetpVCrZV/MtPphVte5tRenoCLfMUlf9Y4+cEnsyg8T8912kYiJE0csARdsqKANoBqhxT2eTSF9llBU+MX8U9Pu3HZWPtgk/qRm4ZAXBPv7WLXRu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB8543



On 21-11-2023 02:38 pm, Marc Zyngier wrote:
> On Tue, 21 Nov 2023 08:51:35 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>> On 20-11-2023 06:39 pm, Marc Zyngier wrote:
>>> This is the 5th drop of NV support on arm64 for this year, and most
>>> probably the last one for this side of Christmas.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>     it without FEAT_NV2, and the architecture is deprecating the former
>>>     entirely. This results in fewer patches, and a slightly simpler
>>>     model overall.
>>>
>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>     is gone.
>>>
>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>     access.
>>>
>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>     than per-vcpu.
>>>
>>> - Fix the EL0 timer fastpath
>>>
>>> - Work around the architecture deficiencies when trapping WFI from a
>>>     L2 guest.
>>>
>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>
>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>     per-MMU VTCR)
>>>
>>> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>>>
>>> The branch containing these patches (and more) is at [3]. As for the
>>> previous rounds, my intention is to take a prefix of this series into
>>> 6.8, provided that it gets enough reviewing.
>>>
>>> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
>>> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>>>
>>
>> V11 series is not booting on Ampere platform (I am yet to debug).
>> With lkvm, it is stuck at the very early stage itself and no early
>> boot prints/logs.
>>
>> Are there any changes needed in kvmtool for V11?
> 
> Not really, I'm still using the version I had built for 6.5. Is the
> problem with L1 or L2?

Stuck in the L1 itself.

I am using kvmtool from 
https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/log/?h=arm64/nv-5.16

> 
> However, this looks like a problem I've been chasing, and which I
> though was only a M2 issue. In some situations, I'm getting interrupt
> storms when L1 gets a level interrupt while in L2.
> 
> Can you cherry-pick [1] from my tree, and let me know if this helps?
> This isn't a proper fix, but if L2 starts booting with this, I would
> know this is a common issue.
> 
> Now, if your problem is with L1, I really have no idea.
> 
> Thanks,
> 
> 	M.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/nv-6.8-nv2-only&id=759d2e18f8954f4c76eb1772f38301df6ed8fa5d
> 

Thanks,
Ganapat

