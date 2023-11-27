Return-Path: <kvm+bounces-2507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6616E7F9E0A
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 12:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8977D1C20D78
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 11:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1858518E0A;
	Mon, 27 Nov 2023 10:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="JKyyr8U1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8CC10F
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 02:59:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXjrQm8ks56arJtK1T2PIm+YeWq60gV6Pl/3refGplyePLq8nA113f4Xg34kn68u0G87c+dQ9J2Ne/5t/eoajzAYNzD7iGWVzVhtL8BHJ6HyPfIBuLJP/encHQ+Ioc7dfxubyhuHPDBrH9s34+1ZH864EKspT/bgQvjY+TOQTcPY9qsyWve4sG2SFcg7ke6eOH3/6q8Znq15L3gqe6gE4Ks3sbM4AbwmXKPzRHV3Lk/l5tQWrDbHaOoHY/6dUbfwm71AHVeg58nwqrmuEyBdNLigvO9+8D6Q9vixFcXrEiD7HaUdkIbI6xBJBArET7LtLhqHMeLbLpHrrYcV/azgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YiXXTAtbIILrAqQXQ0NPzUqRIuncb3OKrqbQlGbF2E=;
 b=UoIFU7KWwDOVUKsR0Y9MhPpsBHrQftOemOdUAuSjvi674vKDLvjKdFKlkngtdFNtBesKwpUxNO86K9fzHHZc79YbyCFHQU+Jq0FgHuss66j+X+KxDjYXX0vzze0Pz3VKtacjri8qZJQn52jQiZk9TSjaAtjTPBlTsW77ygH1Vl259FmOrfBQmX7A1N8+egeXtPXlWwT6m7FKdTk5JMFYH0zsO5Glkh2gl3HbKEf3DrryEzHPeMt7AnS68B5Rl9CLJfuCSBWQ2ckpUh3q7zk3Qwany75FgtfkvQ9WbByLI0Q3ubbMwAintHV80nyYmKt2T5W7G1wdcdqlYoELZ1ZYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YiXXTAtbIILrAqQXQ0NPzUqRIuncb3OKrqbQlGbF2E=;
 b=JKyyr8U1QbhJdgLBYww3U+VGEL89lFTmTUSCg4P0OrVhBACHkelbdH6+chJgMW4dbPVC+5f2gpOYuKBwg1fxeg55wdGkJjN8NqA0mnMjgmNzko1G00biaS8jBkjrumoaLy7zFyd0Hqa24h5BME/sWUBKVr5e2SROG7rJi9EqaDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH0PR01MB7489.prod.exchangelabs.com (2603:10b6:510:f0::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.29; Mon, 27 Nov 2023 10:59:47 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.022; Mon, 27 Nov 2023
 10:59:46 +0000
Message-ID: <1fe79744-f8a4-466f-8f1a-32e6fab78be9@os.amperecomputing.com>
Date: Mon, 27 Nov 2023 16:29:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
 <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
 <86a5r4zafh.wl-maz@kernel.org>
 <134912e4-beed-4ab6-8ce1-33e69ec382b3@os.amperecomputing.com>
 <868r6nzc5y.wl-maz@kernel.org>
 <65dc2a93-0a17-4433-b3a5-430bf516ffe9@os.amperecomputing.com>
 <86o7fjco13.wl-maz@kernel.org>
 <e18700d4-061d-4489-8d8d-87c11b70eedb@os.amperecomputing.com>
 <86leancjcr.wl-maz@kernel.org>
 <9f8656c7-8036-4bd6-a0f5-4fa531f95b2f@os.amperecomputing.com>
 <86jzq3d007.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86jzq3d007.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::10) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH0PR01MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: 913fb0b3-54ef-4a5e-68ac-08dbef37f7c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L93Iu0OYxJg7yUfOpzhc8yPtEwWjRZmKLJtO/2Sijyf00LLmmRqpGpru+s6nnwhUpWO9DKVPR8p3OWh2GBEytVrAwJp6zlZDTjrwy/2KN30zLW6GNJi1ghhYQJJyRay24MXiUGh5VWVCEmkCUj7pbSHqoCTy2eozF4aMBI7nuMAPlW2Z6Kwe64DSmW/g9CLLQXJsWMz69WKEFyovh0mUJagJVNUD6aIFePXvcJFj/vazJ5m9L4qwE5B40+uth68//haEpchugxAMe3m2OTShw3v7C2UZRfcYGTOSVaSroDEb1hVrlMTSE5NhoA9i9S1KDmK4Jj4n/vFGIs0x8WOg0aUfcLLX5tChMIJnuyKpJtMbzfRa8R7hBc3gzTQ0EViZocQCQGK/7FZbYvQ3ClSnB/OBIfKIZUE6Bf9NqZaCNRypZCEK3lMzzuUZrxs5D9Xn9w10Rl/bGyZEXF6rlxfAOCVVRzulqSGmgRh4+8bqnmF6L6VsHHDvM7OAyEdirZO2JINPFiOGXE8RIGFtlkLvCFI+n8ISmR6ljt0TaKla/3XhfhsyKS+tzVPmvsB7jPeq9+eOK3JZCdLmNA6TWO3WQ9NltIZnH16u6UgKBl85zzL2G7s0QPIwObzgSDg0b6AL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39840400004)(136003)(376002)(396003)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(31686004)(41300700001)(6666004)(86362001)(31696002)(5660300002)(2906002)(7416002)(83380400001)(4326008)(8676002)(8936002)(54906003)(66476007)(66556008)(66946007)(6916009)(6486002)(2616005)(53546011)(478600001)(316002)(26005)(6512007)(38100700002)(6506007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlhEb2dwaTRMWHNWaDBkcHNCQURrMUhiN2dsYWhSWU13Y0hqeG1mdnBpSEhQ?=
 =?utf-8?B?cXR1U0tCemcxN29qTTNUalRwaCtDOHF6TWhvKzVLQ1UxdnhBR1ZlWmJPOExO?=
 =?utf-8?B?dDhCb0hraTh3cjBINXdja3BNbkVzVGpnRk5HSENPL1UyaGJwcnArbGF2NWJL?=
 =?utf-8?B?L3BZa1FkVDY1djdlUS9KV0tzTVc0Q01kV0c5RURxbUg2YzBjV2Rxd3BYSHRi?=
 =?utf-8?B?bEE3OExKSnN1c3llUUt5SlNnSUJYeEFzNk0zZlJqR3JxRWg2Q3NhNkdwMWtv?=
 =?utf-8?B?R2ZWQ29oVVNXQ3F6bXZjZndwblhuOVYvSHpleU9kelZaeGw2MWk5V0gyRUhs?=
 =?utf-8?B?c01xcTFpWThIMlJwazhXL1M5VS9EcWxjMFRzdDFvQWJuSkI4WHJ5UmdVYlpz?=
 =?utf-8?B?aUdMNkdlMEhUbkg0bzRoNjFFQ1Avc2o0L0FtTVFGMkpFTjBiRkpEWTEzYXkv?=
 =?utf-8?B?aFgxK3poVWQzYW0vYkdUeWRJSlJBVE9Zb2hTNVNPSXlSUGtBb1hvSE56K0Ju?=
 =?utf-8?B?OG5WNlRuRVY0Zkd0Q3A3d0puSWZtQm5lNmdWN0ZUSjJtSERLV2VPUENKU2hD?=
 =?utf-8?B?eXBoTEFkUjBrZ3I5cEJFN1hhVUFsQXhnWG5kTE4vRjFacGV2dFZEWUNlemZz?=
 =?utf-8?B?KytqanFXd3VtQk1CRXdLeGdzTDNlN1U3N2lxNUw4VDNlbHNhYnBTQkJGWXpj?=
 =?utf-8?B?Y1B6dDU5alpQeDVUbzZPbkZFUW1KSHl4Sm1zUWQzTVhZUnVsWHhrOEpxblUv?=
 =?utf-8?B?L2NYVTg0S2lqWmtUL2RUT29rM3hXalNmSDU2cE0wd3R1UWMxYjc5Q3BmRnVJ?=
 =?utf-8?B?d2NPWmg5TEhXZVQ1YzBBYU1yZnJUMXVleFVISVJXUk9EVEdNdFV5Nk5IOUFl?=
 =?utf-8?B?ckZhMlRHS2h4WE1FLzFRRWdIR2dRQ3A4akRuTkhKS1c4c0dkVXBpSEE3LzAz?=
 =?utf-8?B?UDlWK3pFTVlFaWM2L2FMUXJWTkJtYTZpejlGUmVKK0VlcVJ2SGhYNFRmZVhB?=
 =?utf-8?B?RG90Y2Uvdm1jWnZIS29QSThkcXhuZkMrVHNVWEU2RVdGcDY5cFVRL25VRXFP?=
 =?utf-8?B?WjE4bnlNdzd4eTdTR3R1Z0paSWltMW90VkpYTWI0dWRScHBWV1lOaytOQnhk?=
 =?utf-8?B?WnFFRjlva0VPSDh1YUlsc2Rlb2ljanFDc3dwb01yVVQ1emZmcDZZcHBJK3R3?=
 =?utf-8?B?M0U1QnNKTmRUang4WDlCdFhMUzZTNDZjcHNyWnlSNUhjRWdVUUg1YzRVVGRX?=
 =?utf-8?B?TUVJcktRQnczaHJQZ3lXSzM2dUhpT0RIOTFMZkEvMTZPYkZQUkY3Y1N6VGpE?=
 =?utf-8?B?SkdoSFp1eDlPT05La3NHRWFrQ09hbUxGeTdzTWJrUitpbTd1clp0TllLUHNR?=
 =?utf-8?B?dTRPODN2N1lobm56MWEzdnFRMjFCMHZRWWdwdVhvbGxWZ0Jsa1RmUzMvTnhs?=
 =?utf-8?B?TDRhOW4wRE1ra3NKUzhyT1ppRUgxR2x0NFk0Mjg0OHc0R2ZpTEprZ0ttMFl6?=
 =?utf-8?B?RCs1NmhZY0lLNitTc2pmZzhzRUlBWHNCdnJZYTZuekRSOWJXa0ZHaDh5R3RH?=
 =?utf-8?B?UHMyTFI5eTV6QW8wUDZxU2JKc3hDcGg0QUN5bzE1QTV5MHdKT1U5MS9GaW1o?=
 =?utf-8?B?RlNOZldVZk5DK1I0UVhqWUZTSnZZQ2V1dU52U3VxcE9VZERMeXJ5dGRqVEFu?=
 =?utf-8?B?cjloaDFvbUhTN1FzbUM1bzVnNmRLREFnaUgyM3kxSHlEYkp3RjdSOThvRHUx?=
 =?utf-8?B?cTlRN2lJODZ4aEhSUklkQitqcHJQUGR5VDgwK2w3UHA2VUhEalFCZmNqQ1Jp?=
 =?utf-8?B?L0llQWVCY3Y1dEZVa044N2t5S1RselIwQ1lsc1hISk9xT3VGN0F4YWFTOU9s?=
 =?utf-8?B?U1JQQlNYV2NZRTQ4TSs2WlZPcUxTa3ZrWG90TlhjQlVtV1VScVpGU2ovMGxz?=
 =?utf-8?B?cTVQMzdXOUIvTWcxVEt5TXJJdkZLTFdYNmZ3TmtjZXhEdlRyVExOeGF3QU41?=
 =?utf-8?B?QXppRnRxbkwvUko2K0EwTjduYTRZNXF0Y0JEYXpIQnRKMTY1R1V4cWZaVTlh?=
 =?utf-8?B?YVlKWVUzU1FLMVRETU8zUHVjWm5WVENDZWtuNzI1NjVjSmR0aXUvR1BmNG1n?=
 =?utf-8?B?Y0dEMERaYjBKaVpjaWkvTXJvNHQzWTJuUzZBV1lFQ3QvTlF2K3h6TGVnNkNR?=
 =?utf-8?Q?8PSQzHfDVnKSHjKSt8HOduMjs6Fb5b3c3bkk5KixoFVq?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 913fb0b3-54ef-4a5e-68ac-08dbef37f7c4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2023 10:59:46.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYtHxhyxtnJ75Au7uU1dyZukzttnWgce88loVWzx5TBx7v+H2HMCdQjNXH41OPOO+tzPlThMqz0vLyPIRX5oPumjPelJd4HxAXbcuzNlR0wvpqvBK2vKWfr9m0LIr27u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7489



On 27-11-2023 02:52 pm, Marc Zyngier wrote:
> On Mon, 27 Nov 2023 07:26:58 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 24-11-2023 08:02 pm, Marc Zyngier wrote:
>>> On Fri, 24 Nov 2023 13:22:22 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>> How is this value possible if the write to HCR_EL2 has taken place?
>>>>> When do you sample this?
>>>>
>>>> I am not sure how and where it got set. I think, whatever it is set,
>>>> it is due to false return of vcpu_el2_e2h_is_set(). Need to
>>>> understand/debug.
>>>> The vhcr_el2 value I have shared is traced along with hcr in function
>>>> __activate_traps/__compute_hcr.
>>>
>>> Here's my hunch:
>>>
>>> The guest boots with E2H=0, because we don't advertise anything else
>>> on your HW. So we run with NV1=1 until we try to *upgrade* to VHE. NV2
>>> means that HCR_EL2 is writable (to memory) without a trap. But we're
>>> still running with NV1=1.
>>>
>>> Subsequently, we access a sysreg that should never trap for a VHE
>>> guest, but we're with the wrong config. Bad things happen.
>>>
>>> Unfortunately, NV2 is pretty much incompatible with E2H being updated,
>>> because it cannot perform the changes that this would result into at
>>> the point where they should happen. We can try and do a best effort
>>> handling, but you can always trick it.
>>>
>>> Anyway, can you see if the hack below helps? I'm not keen on it at
>>> all, but this would be a good data point.
>>
>> Thanks Marc, this diff fixes the issue.
>> Just wondering what is changed w.r.t to L1 handling from V10 to V11
>> that it requires this trick?
> 
> Not completely sure. Before v11, anything that would trap would be
> silently handled by the FEAT_NV code. Now, a trap for something that
> is supposed to be redirected to VNCR results in an UNDEF exception.
> 
> I suspect that the exception is handled again as a call to
> __finalise_el2(), probably because the write to VBAR_EL1 didn't do
> what it was supposed to do.
> 
>> Also why this was not seen on your platform, is it E2H0 enabled?
> 
> It doesn't have FEAT_E2H0, and that's the whole point. No E2H0, no
> problems, as the guest cannot trick the host into losing track of the
> state (which I'm pretty sure can happen even with this ugly hack).
> 
> I will probably completely disable NV1 support in the next drop, and
> make NV support only VHE guests. Which is the only mode that makes any
> sense anyway.
> 

Thanks, absolutely makes sense to have *VHE-only* L1, looking forward to 
a next drop.

Thanks,
Ganapat

