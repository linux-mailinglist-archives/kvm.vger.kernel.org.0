Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3565E471
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjAEEKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 23:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjAEEJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 23:09:56 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C382187;
        Wed,  4 Jan 2023 20:09:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/pTw05r82aL7TQHnyv5IdCeCnoMn/W9BgIBAdb4FXdDuj8TMmcP572nLlVzXoyppbX/BUeXOLKad/vTW6yHP999nH1b5qMeM6aeNiAjo2xMCHADZ9f72kYX9dk4t81Y4a3omqEk0wTN0MpxFkNbqf5R3la+K75uTV9gtvm3ElMOarBUwwFFrxinmiB9veQq9eoKYEIQTQTSHJgf6RU7oeY/ozh2NFRaBNmDACdaDPaOetJGUytLGn1nrf8M5HdpuCAZzXTSvRW4DejFz2nmzWD7gK0AU0SlhnGfj/Gepwk49bAoVXV9gdJT8WX11Fi/iU/sv4LC65yfV8BS04NN2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhjdCs/X1URr21YOdKq89LYugObO0Exoi+NO7mvCbG4=;
 b=la75HLjv1BM5+9YSmR56o+QZ0xmxndgfgti8ZYBtv6U+S4wM9SOC7ilmBDFqAQ7NkaWfwyM+PGHyM9ZE1N5u1sgR+E4a4wjscJnXbHP9nvTzR9QiFot3nrvRrFW4dhIp2V/zrcjBYO5g9WLvy8aAzzNruvhoD4Jf88QCqR6ePr7F05rexJWvg891PCk5+SA+qyycj4aUaDuDMsRmZxyIJ8sSuqnItBlKQ/7qblDq/e623lyfdLDo+1g2HcFRbQjCGryTUI7grtf3U0SxG3ld7FAmLRoRx7tNx/xxD5vAMUi+oMHWB3E6ERSrDe/XDLh7X4j8WGRmJQXpxD4RzC7yuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhjdCs/X1URr21YOdKq89LYugObO0Exoi+NO7mvCbG4=;
 b=xNNGfga70GJPWy9h8ow1dKlhGN+veRfJiy20srxqqJClTmYc61j2LdIhGgU2xKweNANvWEpxZUs39OsL/SS1xNSEC6VA6kVres9qld9VG/hI63Ncf5KcMxRqG5wvL6q4Ai6uaM0o5eHuvsVBUV4gmax7In2m6NwAL/HpGdovpFo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH3PR12MB8510.namprd12.prod.outlook.com (2603:10b6:610:15b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 04:09:24 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 04:09:24 +0000
Message-ID: <2ebc9510-d7bf-a46d-6e78-f9e528b79501@amd.com>
Date:   Thu, 5 Jan 2023 09:38:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 01/64] KVM: Fix memslot boundary condition for
 large page
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, ashish.kalra@amd.com, harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-2-michael.roth@amd.com> <Y7VqgbTE34/Sxupw@kernel.org>
 <20230105033451.GA2251521@chaop.bj.intel.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230105033451.GA2251521@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::12) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH3PR12MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: cab18f80-ea90-4bd2-633e-08daeed2a119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mWGzZHWJk3qZAq7trzqQHAyqKwHTtXnRYJGtFrPnNZr161pIvYTwUxrqv+fQ8A0L+sAFoGIlFRdc/YWV/ot+k+YLNM6RyZa10G4ZLy8z/WEcWVf51fKIjLJqbHmDoaemDllH9WTAzG437vbintMQ+HZTfkig3fNIQ14MzYwdU+KLPmyc9C9k5HxWICp4rr6yDXY71qA2xjDHiPICYD/7jFqxCXPNNP4Pj2O3VPTGLjDjI2h+fu+M9zje6T4WqXE/Iz4rQwtBxU361ef2KB9zHz3LSzTbSLH15qv6EYvdn8JFr/6i34mdBex2i/0SRsYKZUOHEec67pwqXLihZ6eLZSMESx//p7hRBlgYOpOt5sOmJn4TtQVslHGfTZqFHaGGICUtd/1ozFNLRgxQ2UoVBrBg4ttmAu2MyicBwKhhtVWuZW5Tn0jnsa4j/wMMRYp9gFOw479q5y4Sc8BXOP2t6k0ubUoIOhAQJ/Ndteh51hug7aRbTTzZwmwUSbG8yMqOCEJThRC24uqSUeuTPWsp7mHNE7FlhwUIKx8yLppAVzqoRx0dk7p4FtV6NS3O1Vf9qxE502Lc7QZLmtH2Gw/SN0/sxdDj12gnnQ18F7GisZycxTQvkieRsm3FeM1jFZmxVSzIIqvOph/onTAH61oinesW2tq1M7aIFO0kmgruL3uqpeR9HbbGDOSNA9udfh0qcffodgoQEginXC3ysMglXm7CoifVwL9W+3WFmSx2qqJ3d2pnrNdrVKAQn7w5WMnVuzGasXqoWnV7+wM4uH9lRpKw4eBEaoGn3x0/7AmUOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(2616005)(83380400001)(6512007)(186003)(26005)(38100700002)(31696002)(36756003)(2906002)(110136005)(7416002)(66556008)(5660300002)(66476007)(8936002)(66946007)(8676002)(4326008)(316002)(31686004)(7406005)(53546011)(41300700001)(6506007)(966005)(6666004)(478600001)(6486002)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmZ0UzVpR0toeDk0ekp0c2NmcHhIaDJrN1ZhMWF2LzJZeWZrRjBKQUtGSnZX?=
 =?utf-8?B?dnNDTG5udzZQaTZjbHF2Z21EaWxVdy9jRDQ4d3h0bExuSUZ2aFBOMTRFYjBO?=
 =?utf-8?B?ZjkzWHN6VkNVM01lWWlPWVlJT2xaL3ltdUpNSHMrUjBlYkw0Z2V4TndVSnor?=
 =?utf-8?B?MFQyNmZRcDFRWUFNejduTEFBZnJmMkg3U2lKU2xZTzZGclQ0b1hNeWJZRjJW?=
 =?utf-8?B?YkRESmRDYjJzOVY2RHRNSVlJcHY5RVpOVkJxL3NuNGlxMHBKTzFDdndiVkxG?=
 =?utf-8?B?TXZTd1NOaVhnd0VTYkFFQVV2WE4wTWFvcXpnSXZIODk5MmREYVM2MEZ2YkVB?=
 =?utf-8?B?MnBOKzNYN0Q2aVJKUVkydUlsOE1SOTBqa1FWY0dDd3ZVN29vVDMyaWJTcWFO?=
 =?utf-8?B?aUdDY1I0UnlTelFBbzM5bzVMb1BKdnBCcVN2VVlSNlIzYUx1QlpjM2Q5cFRH?=
 =?utf-8?B?V1p3d3NRbUdOYjZieHJFMkg3VUlxL1NLMHl5OXYrS2hwU2FFTFZRMG5CbEVp?=
 =?utf-8?B?YUVBZ2dEZHUrbXQ5dzRvc2hBWDJ2WExsZnJDVjhXSUoyNDZkdWFBZklBOWl0?=
 =?utf-8?B?dC9DellRT0pjaS9QRysvaW9aNkJvNXd1NDZVN2F4RUszOUIveDBpZkZONSth?=
 =?utf-8?B?YXRKeEc5Y2dSa3BLZGpsNG55eTRtdy9LZWZyaytiMGNZNThLQWpCOVU2SXNo?=
 =?utf-8?B?MVBhU1FYNTNrM1VrVkNNNURZZ0E1N3VIeGZBaTdEWVN0VmVwNVU2MUVLSzdz?=
 =?utf-8?B?aDFvKzhyR0NHZ1JqZnpxYnNXRUVQeFUzL2NPUG9kbWxHZ0E0WGNpd2ZpNDI5?=
 =?utf-8?B?ZVlLNzA4QW4vWXlXTCt0cnlpYjZrSDNTeXJCQzFpYTFhbWNUT3pmeVNxZUcx?=
 =?utf-8?B?SnhYTllCOHRuWmU2RjB4ZHJFd2cwcEszNCs4VkdOWlNncFJmbm9ZTWROTENT?=
 =?utf-8?B?VE1vbFdNaWg2MTdGMFk0TEdNQlpOcDZKeVRhNTFITFAzMHpybHp5MEovSGFy?=
 =?utf-8?B?SG4wRzFCSnZSRStzdXdnSytid0k1UngxV24yZDQ2ZGxQcGErNVRxVkJXZml4?=
 =?utf-8?B?S2dWSjRuTWlRRTI1WXB1ajZPODVYaG5yS2dNYUhrY2szaEI4dXhVeDlMZ0o5?=
 =?utf-8?B?VWpWYXMydzVrS01RZzFZejJod2Z2bmt4Qk9CV1JnZ2tNdWxYNWo2eTAvUzZR?=
 =?utf-8?B?T2l1dG1NUkdSa0V1blVaZFQySFFpandKY2w5SUVoOUF4WnRLSEo1UGE4YkZX?=
 =?utf-8?B?RXQ2eWMrdWVTS2FEYTZmbHhaMEprUzVTaSt4NjlqOGtzNG55clpPWm9vWmJO?=
 =?utf-8?B?MDd4VHVEZW9BcjNUQjhQckJmSWF0ckZSNWFtUFllcVJTQ0lYM3RTVGlPTGV1?=
 =?utf-8?B?QkR6bkIwYUFnU2pFbFRtL2hEeE1pQ3BETGQwTnJlakZMaSt4WUMyQWVONFB2?=
 =?utf-8?B?b29iSm1ubW1tck1IRGJuaFowbG5FRzRqV0NVUHFqZ0k3TkNiWlA5eEQ3dzhZ?=
 =?utf-8?B?Wko4MlpMcUU5cWlzdTQrU3l5WDRobi9ocHFxK3IrREczY28vb0tDTFJadDJF?=
 =?utf-8?B?SVRLbUsxWXROV3dxa25leUlRbml2S3ErOFpWekFKdWErdTZ4Lzd4aWVCTzRY?=
 =?utf-8?B?b2hNc1gvUHJ2UTFqRXNBV2ZweTAwL0tpTlZXM0FVN0M5dld5OHpyZ1ZXV0hw?=
 =?utf-8?B?eklrUVcraEFKekd6U3QwM2tHeWUxS3M0NmM1YlViUzk5dGJQbUxDVVV2OWhi?=
 =?utf-8?B?V3NldGZ5RkJJZldHT1h1OXpLU2VRamFUUWFJaGFhdFRZVVFTV3M1Ujh5VnFT?=
 =?utf-8?B?alJ2S05CVzNwclJGVUxuTUxDSU1zUGxhZkwyeTlKQTZ0RFFpS1dwTXM5WmNI?=
 =?utf-8?B?Um44alZYT2xpVVlodk9xN1AyMUF0bGFBV0lJaG90d2kycUVSZFdTcDdsbmNa?=
 =?utf-8?B?WDF2Y2VERGxza3BCd3o1SnZOMFE4U1hHbXNPWlBxYUtiOW9uL01PQjJpQlk5?=
 =?utf-8?B?dTdJVUZwVXF0dHN2ZTlDN3lzZnlyOGxYaU1uaytxclI3TWUwNEdFZnlOdWVj?=
 =?utf-8?B?SzdpMHhGOUFTY0M3NWVpaDZkVEhFSU4vMVdXL0NJK0s2b2lScE1mRGFzZktk?=
 =?utf-8?Q?WlA8Xsn1j0BgF/7KXQMJ88mSm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cab18f80-ea90-4bd2-633e-08daeed2a119
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 04:09:24.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwHPlDwhuKOV4SRQxFvRZfsGOFs3IPj1CDkhTA8QTbD+IXH5xxE9xfOvbXSb+2aNZmTmy4rZ0WYKuGJuTJN0hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8510
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/01/23 09:04, Chao Peng wrote:
> On Wed, Jan 04, 2023 at 12:01:05PM +0000, Jarkko Sakkinen wrote:
>> On Wed, Dec 14, 2022 at 01:39:53PM -0600, Michael Roth wrote:
>>> From: Nikunj A Dadhania <nikunj@amd.com>
>>>
>>> Aligned end boundary causes a kvm crash, handle the case.
>>>
>>
>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20221202061347.1070246-8-chao.p.peng%40linux.intel.com%2F&data=05%7C01%7Cnikunj.dadhania%40amd.com%7C7a95933fac1b433e339c08daeece6c2c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638084867591405299%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=vDEu9Uxs0QRdzbUkJbE2LsJnMHJJHBdQijkePbE2woc%3D&reserved=0
>>
>> Chao, are you aware of this issue already?
> 
> Thanks Jarkko adding me. I'm not aware of there is a fix.

It was discussed here: https://lore.kernel.org/all/e234d307-0b05-6548-5882-c24fc32c8e77@amd.com/

I was hitting this with one of the selftests case.

> 
>>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>> ---
>>>  arch/x86/kvm/mmu/mmu.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index b1953ebc012e..b3ffc61c668c 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -7159,6 +7159,9 @@ static void kvm_update_lpage_private_shared_mixed(struct kvm *kvm,
>>>  		for (gfn = first + pages; gfn < last; gfn += pages)
>>>  			linfo_set_mixed(gfn, slot, level, false);
>>>  
>>> +		if (gfn == last)
>>> +			goto out;
>>> +
> 
> Nikunj or Michael, could you help me understand in which case it causes
> a KVM crash? To me, even the end is aligned to huge page boundary, but:
>     last = (end - 1) & mask;
> so 'last' is the base address for the last effective huage page. Even
> when gfn == last, it should still a valid page and needs to be updated
> for mem_attrs, correct?

Yes, that is correct with: last = (end - 1) & mask;

We can drop this patch from SNP series.

Regards
Nikunj
