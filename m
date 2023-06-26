Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BD73E596
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjFZQqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjFZQqD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:46:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2088.outbound.protection.outlook.com [40.107.237.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915F783;
        Mon, 26 Jun 2023 09:46:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOphaiEMCoQcwzQLCjSFdEsXvZv90WYqMxAmLPhjjMyqiPS6Py/NgwPzeTumCugcplpoGSQUH/xLM7p7AOGhm8IOIXg8i/julzOFggha4p37q95h1c05Mg3T1a1cWCMoAk/lemBkgm5LOvJx5YBnSMtzmm09d+KQLNwEeSVFWYIXBsalVbP8GF4hC6BXHZ+AnRL3vffSlvub3vjrOKgdyeSUIp6F3fTCh8WiXkrfItlGyQAsxEZ+ui/f5KSM1aIOR0m7Le6MNVaxj3bNFTKjNXb3kNkHGQKGZOtofff4r6Ol1KYq+BgzHRm7Iw+jxCQ6W2Qi8WbKfz9MDwUjTn4few==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RST4zHC4fh1s/ivDYDopxx1Mew/tT6Z4bcYM7Bjw/7g=;
 b=hJn3D+9/AZ+jH8PlTCMdkPi92mSREnC3ehklPlYn77mSDRxI0sK1UHCYGkpCy+xSKbxCsDolS8EmxFsNdOuxZayo7/DE+xKNrZ/snVwkkYPqv21kedQqz2aKeKEIHlEyIGC1lk7KA9Fy1ONEWQiHtBHUGOfHvTKqtHXUR4xnFCn7zqYHiMLIhYDAYcFLx3ZtihzrTQnLMCIPoX6iixgwMp1lo3dyrGaQ0ufvYerI6bw9m3O7JqPV2Mwkg/KZv1UO07ZPRKe0COO5Clz1IwWQeHs8Tzwu/QiSgvO/grURSH2p4FZwJDUE2jvLKwkgHm7IySqydRYwLqE6Beqa2KJgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RST4zHC4fh1s/ivDYDopxx1Mew/tT6Z4bcYM7Bjw/7g=;
 b=Jb9l2tKUxjv0jMbZcvrow+UWlKicfS7FNML/qthpUFnCWw47PZCyxtyxT1AjEsJdx7DmtbrI9zYPAemrVHVynN1UHRZF9tTAWFzUt3cVG3zJEgr9CguC/PjsZrl2AKfYhVyEYydescu6L2tzUQlnokWKaVoK47oa83E24Y7jm1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Mon, 26 Jun
 2023 16:45:59 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1629:622f:93d0:f72f%7]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 16:45:59 +0000
Message-ID: <a8bae991-c9af-ef45-20de-b9369f4dbf09@amd.com>
Date:   Mon, 26 Jun 2023 11:45:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH v2 6/6] KVM: SVM: Add CET features to supported_xss
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
References: <20230524155339.415820-1-john.allen@amd.com>
 <20230524155339.415820-7-john.allen@amd.com>
 <161174d013dff42ddfd2950fe33a8054f45c223e.camel@intel.com>
 <ZINGaJnNJ54+klsD@johallen-workstation.lan>
 <9ef2faeaa38e667bd4daa8ee338d4cade452c76c.camel@intel.com>
 <ZJYaNSzup+yuYxNy@google.com> <52ea8386-8652-dd91-23de-9d35781cb131@amd.com>
 <ZJm64a7IKuSDS9bz@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <ZJm64a7IKuSDS9bz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:806:20::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SJ0PR12MB7458:EE_
X-MS-Office365-Filtering-Correlation-Id: c5ed6f49-26de-4318-d677-08db7664d1eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BiydOMlvGH4I02BZdgu8t6Ww3lynwVvMG6QBQQJ1JHhLLuKHGlyptwFS0aiYuzAwzPQN/DriU3eHdLq0RrF4BueVdq/57P3kDu3UjkcWbI5NWePVUhn5ffU7+GfWHvMtV8ffjJFtS0XDY6PiJHiqG5pAlMzJRnZrspyoqssPUcxnjr4A01Mmyc5cgfMRXYGyOf4FZz7GL+KfnHpkFFtxud2LZk2OOS01ZP72I6nNG4Rf20i+sD3Qi0tjn7jeCHwqEQZWobplB51uJZGjLjPVhVP3CNACsfeTKl5xuu4Afpp6usNV2vCZg+AF4EsR3iheELmvqqPvREOGpj8AwVD4VPg+5Wj7KT9SD7xoDKa8SlpSfP1S7J1VQTfEWlYJn+G4pr9H8niN2IF0jUGEH5K9mW6jEmpT+NjruwEP5ToLzJzuUze16vgM89ykZrJEBrAuwhoSi+hnU5g25adCpCjBRBmUf8A66FPgLdMUWFTbT/hac/ZPFHgy0z1m9hIVtiH3TRRoqK8Dfd35QhMwzngjTVBtb1gSoRUORlN5HjQq8xulNCEEAMlIP+W1+LURBxgHUdiWqd40VPxUNDF43QhTgeN49LlIhmlak7HihA/GdnQV50+xB4udwiHUmMPgwURbQ/t8n9RXw0dOfnbQVZepWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199021)(6666004)(6486002)(2616005)(54906003)(478600001)(83380400001)(26005)(186003)(6506007)(53546011)(2906002)(5660300002)(36756003)(38100700002)(66946007)(316002)(31696002)(4326008)(66556008)(8936002)(8676002)(41300700001)(86362001)(6916009)(66476007)(6512007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGFwenZTcG4ydmlGbGdkNWQyMVI2c2pacXZjYUoxL0JrUFJibzIyd1dZN0R1?=
 =?utf-8?B?ZUMvWmhuclpULzJoUzE3b3A3Nk1hbDV2ckU5ckdaSmdEdHk4SjZGQWZ1RzBn?=
 =?utf-8?B?TTlRV25Rc0pwTlc3RDBvaHdMZ2FYZG4yaGZNc1QvclVTNWpWWGViTlB0eW5E?=
 =?utf-8?B?bTdMS3R1SzZRcytwbHNPNElrQjZsbDhPQ1ZKL00vSHBXZEI2MU1FcTUyMFFs?=
 =?utf-8?B?WVhGZVdKd0NTdERzN1kyMlRVd1E1dFVCN3ZUVURwWE1Zak1sRVZaL2R1RUd4?=
 =?utf-8?B?azBCMlpxRHJyaGgxaFZwWUJmVGJ0UnhHM1ZqakxaSTEvdVJ3eHJDNWNIMDZB?=
 =?utf-8?B?TWhZQ1JGdjZGZ29aUmFudHJodVlZSTRMamI3TkR6TUZOU3cyR1lZbUg4RmEx?=
 =?utf-8?B?REYwM0V1NlVDeDVvQXFoWktwQmJmZUdsWU1CZmxWZS9OTFNrOGlYWTZjM0RW?=
 =?utf-8?B?dG41SWtodFZ1UW9pdEI5TlZFWDVZRlFaQlFVV1JkOHlZMVlNSTU4MDFnZ0Rh?=
 =?utf-8?B?TGVSOWdVUU9vZTRmdWZTZFJMTExzV1QvWldrL1A2MGVtNytlcFdoR1UrZ1ZJ?=
 =?utf-8?B?R20xbE8wRXlRdy9hL1VYMERrWGpzNTFUaEgyVDdtQXZkTHVJLy9HVW9VeUp2?=
 =?utf-8?B?eDI1M3ZEMjZLcjFrUHdhd0Z6OU1VL0VxMng2R1dSekV1UGxwR0RkQmNReTFk?=
 =?utf-8?B?QjEwejdzc1lVeDRqTEpuV3IwdVhYcHJwS1Vyc0hEQ1NpUnZiNnFSZy96SlAv?=
 =?utf-8?B?U0V1bGxlbS9mN0NpZ2thdXBFeFBidUJLazdGRDcweEJlREJwZTFMRG5sU0VN?=
 =?utf-8?B?T1RiV040SkJPYWhCRVBiMWJFMWJFSkk1M2VJMDBlaWJScGM2MWkyMnBidkhJ?=
 =?utf-8?B?NGU5ZGRNUDlqcU9qdzE3Y2Z2bVNRelNVTnJMRllTL3JPbSt0K09TVGdpOVRa?=
 =?utf-8?B?bDVCcTZNeHpzcVlpUVg3aTRNZTVaRmRDeXY0ZzdxcS93dklER0hLbkpyWVFh?=
 =?utf-8?B?YTBWODA4bnBYRUJzZFdZNUIzZ2ZwSkc2SzVsQWNUVDRZT0VUeHBoRHk2SkdM?=
 =?utf-8?B?UGdBaTFJS0cvN2xXY0xSTWxYcVE2bkUzdVEvd21hdkZIQ3dvbWJwRkl1c2Vx?=
 =?utf-8?B?YTVZNDMzM051N0NsalZrSjFRUThNWUoyMXFYR2FjaVYxalZuUGFsY1JJUElS?=
 =?utf-8?B?aHgxcXRqMU5Ic1NITFhUYWJZZ2VxNFJ5YWFSbmE2eDFRZDFXNlEzYUxBaXhB?=
 =?utf-8?B?eUNVR0hRMWtSdHFYS1FsS3BCdjh1ZW04L0p6eGoycWw0UHJ5SWlOZEJyY28w?=
 =?utf-8?B?MlRhT2dkMCtUWDdBNm0rQWVpYS9CRGlXTTl0RmpkZWcyZnZrUUp2dm12Vi8x?=
 =?utf-8?B?eHNDbzBtdFF6R1VOWGQzaFRHYlBBM0JZa0dhRXkxYnFXZmgzNWFHdnhuaGVy?=
 =?utf-8?B?bHBEd2VGSFpNMXZreUpmNU5leWhKZXhqaUI0TW9wSE9pK3kzQ3FuMUp2cHlq?=
 =?utf-8?B?Um4ydDY5NzVIbmxDTXU0eXJSVjZmQmRPOE4zMTFOZ1JrTFBmRjlvK2hKY2k2?=
 =?utf-8?B?ZHNkMTBSVG92RVlGWkJpSlJJU1lRekRtRVVvNkR3cktkTndIeFA2RldISUFS?=
 =?utf-8?B?OEl6OERDbmhIb0pmLzlHMlVGbXY0U3hXWTBBUGJpSjI2K1c2RVNBOFowSVhq?=
 =?utf-8?B?eE1TR1I4L3ZmcUxZQW5UZU9CUWdsM3dZcHBGUUczK2wrWWZZdFV0Q2ljR0FU?=
 =?utf-8?B?bFNYdGNaY3h5L1RiL29HMmpUVlFDYnU2VEdmSko1QXNhaFllakNGLzQ2cldG?=
 =?utf-8?B?TVFjcC9jTUdhRXhZVTdaVGJWK2VjZThjTXFXb1lmb1ROaTZDU2xLYlNHMFk0?=
 =?utf-8?B?dTRXNkdYRW01aGFHK0VNUnBuSXpMZzF2RGZpV252MDk3VWdaVEhDZU1kRDkr?=
 =?utf-8?B?QzlEUnB1QjZxQWNidUxMNHRyUUlQUXl4WndTUVdlb21rdnpoSUk2R0w2cndN?=
 =?utf-8?B?UFIvSGk0S2FDSVgxUzJZcHNQK25ySHpIR0pTdU95ZHUwQVZEK2dDVUdUMzBm?=
 =?utf-8?B?RUJjdVdrTk9PcjJJVU9scm0xRGRES05hNUpWTjhNQXNCWGlOWHpRaFY1TDNk?=
 =?utf-8?Q?bjZsvwDo1888hfOOmVyJRtaUc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ed6f49-26de-4318-d677-08db7664d1eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2023 16:45:59.5098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHMUER76sdzDAAdAm70oyVUSdFyo/2RxjSZqtWX2f+2V6TxDz8d5Vkb41KDeeA1BUziZbVqgMEpUUApLMfxFQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7458
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/26/23 11:28, Sean Christopherson wrote:
> On Mon, Jun 26, 2023, Tom Lendacky wrote:
>> On 6/23/23 17:18, Sean Christopherson wrote:
>>> On Fri, Jun 09, 2023, Rick P Edgecombe wrote:
>>>> Also, since the host might have CR4.CET set for its own reasons, if the host
>>>> handled an exit with the the guests MSR_IA32_S_CET set it could suddenly be
>>>> subjected to CET enforcement that it doesn't expect. Waiting to restore it
>>>> until returning to the guest is too late.
>>>>
>>>> At least that's the reasoning on the VMX side as I understand it
>>>
>>> The APM doesn't come right out and say it, but I assume/hope that S_CET is saved
>>> on VMRUN and loaded on #VMEXIT, i.e. is the same as VMX for all intents and
>>> purposes.
>>>
>>> The host save state definitely has a field for S_CET, and VMRUN documents that the
>>> guest values are loaded, I just can't find anything in the APM that explicitly states
>>> how host S_CET and friends are handled.  E.g. in theory, they could have been
>>> shoved into VMSAVE+VMLOAD, though I very much doubt that's the case.
>>
>> Yes, the host value is saved/restored on VMRUN/#VMEXIT. Anything that is in
>> the VMCB Save Area (the non-SEV-ES save area) is fully virtualized (unless
>> noted otherwise) and doesn't require special processing to save/restore the
>> host values.
> 
> Would it makes sense to add a column in "Table B-2. VMCB Layout, State Save Area"
> to specify whether a field is handled by VMRUN+#VMEXIT vs. VMLOAD+VMSAVE?  I can't
> find anywhere in the APM where it explicitly states that VMRUN+#VMEXIT context
> switches everything in the Save Area except the fields listed in "15.5.2 VMSAVE
> and VMLOAD Instructions".
> 
> "15.5 VMRUN Instruction" kinda sorta covers that behavior, but the information is
> either incomplete or stale, e.g. for host state it says "at least the following"
> 
>    Saving Host State. To ensure that the host can resume operation after #VMEXIT,
>    VMRUN saves at least the following host state information:
> 
> but for guest state it says "the following"
> 
>    Loading Guest State. After saving host state, VMRUN loads the following guest
>    state from the VMCB:
> 
> and then both provide incomplete lists of state.  A pedantic reading of the guest
> case suggests that there's a large pile of state that *isn't* loaded, and the host
> case isn't all that helpful because it's way too handwavy.

I'll communicate this feedback to the folks that update the APM volumes 
and see what can be done.

Thanks,
Tom
