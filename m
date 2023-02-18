Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55D69BA85
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 15:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBROzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Feb 2023 09:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBROzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Feb 2023 09:55:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BB2193DE;
        Sat, 18 Feb 2023 06:55:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps/ldELC0PvixDC4lDZ4BgUqXm4XeGW9oCyzvlUjVPx6Sz0QuKOxOoL1k61q5vVjgmRNqEcZ2wk6rByKSthCy8bnEQYaXSM37lsadV1bdEFMnaYaVvQM1/wRCelCDTwTS0jcQ19DUMhS1dv68OmNMAsd4yjzHLb1PZMFEty0XNzelF2CppCNzLU2Lu0Ek5Rd712EHsxocEwnStr1VF9nqfgy4u5Y8dFh4Ab3QfW6RxRB9jDumz9vUhHgZstx9bhfZHaqMqk3HLyvmlgHvhhw2plLrmUsoCtInIOzXPR1V6keEmqsHlGIr23l3YfhZ5hIc7RaxuXVOhBld1GpiHwz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cN4U2dPRmsrmfL0FCdfETMPyvPc2PVxnwB8419YiRTU=;
 b=gvAQLgihqiNcCDgMshz6/V4fn9FXxE66FUa8fS0rMHI+F7Z452g+D3AnUpAcmqr+oh+XfkI9uwJPrXR1zxZXY9sG2HcjNUrgJ+eyF5A28SYEv7+ctU8hfc1FVQkNNdF1fBTXBugtskzHoocEofeb42C8fSthNDrfzNBHxuIsegtToji0DgbTEQtZwSxLFRTSzFr/m1ckBl3ffSgSHf+yCgrLbLWyr6MyfzR+UUHnDa2C1GdnYRmUoQp4is4M3Y8RRzaw5uhgXLifNbkqCtnBUJjgNjYfGxXDKDriOTYUERTzRZWHu4YnjFqMWnnVzqGGmt1+eWK8edz8poMmOz6fJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cN4U2dPRmsrmfL0FCdfETMPyvPc2PVxnwB8419YiRTU=;
 b=wRjouS8oQdRcXmTaI47XS/KMmkGlYoi63ZvWOpBvEf4AyC2t4isx/veo6kt4vTVu8wy4Hll6rVpQkmFg1JpsQ/ok5frkGNO/7IY1EtR78ORgQ6QRGfPIBRVBIt283Dbj68xbXb3rxZlyCPfkzhlrO59nDmz9XJPTSzciX3tW9Js=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by CH0PR12MB5076.namprd12.prod.outlook.com (2603:10b6:610:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 14:55:41 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%5]) with mapi id 15.20.6111.018; Sat, 18 Feb 2023
 14:55:40 +0000
Message-ID: <f4a1531d-954b-ae68-a202-8ae4e7e78485@amd.com>
Date:   Sat, 18 Feb 2023 08:55:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 2/5] KVM: x86: Shrink struct kvm_queued_exception
Content-Language: en-US
To:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230213163351.30704-1-minipli@grsecurity.net>
 <20230213163351.30704-3-minipli@grsecurity.net>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230213163351.30704-3-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:806:121::10) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|CH0PR12MB5076:EE_
X-MS-Office365-Filtering-Correlation-Id: a48763bf-6b8e-4ef7-cf2b-08db11c033bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6Pue0BRJIan/Oa4vAQwlqqDXrWkri61mahdQVvXQyBkf9GMs/6a/XUe945yUnxn9ET6WfzcrWCRx0UNWQ8+K1k1CKA+/T8tHhBwnMD96EeKp41YneIvtAuNdx9HASjY6XmN2A/Z7Znl6TBXYIW/V4ibii8KIwc1fvexDHRAKJ8SH65QmaK2Z97zjK/NTxeo9+5H1PcDKsiT2j/GjVzc82guQ27HVLyTE35LrK9g24Gv5NbcUQEbtKG4nwLAbd9GVo0WgJmxaqoc0Fat6hEJTL6ShYP56OB78fMcORKtrJMXINk2wo3AZFVUtGPGakVpwmTtbDnUvgt1/vTIaJDMt/LfnI/cwl03JEH//vf0rrApMYQ6Xw18+/w9gdjVCYBS7GBvel9uNmIbGyk0RWKBx1bXhLUE97EQvcBAWeCcjS4C2i5Hq40QEf/F685KkFgVuqvK8BIbvCKUuSXSJyxNjrJ7RRnb4pjr7LbjxD4+YaHBGlERuvvhdYq1pwwG28WenQEaXtbuxiqbkPj1Qon7qlBUfzCRDOSk9g7/rOx+V3UjONTwHLm13XLomZT+2m+uFTvX2z8ouTrhhyxHsbRmGTbxvUJAWH+fyfrlHVXDGt/xsKKViOElCIJ2+l6XvWHuEycI/zQcDgV+/rDE48q08Jj8G+Dq+jgPU0LYCEMTh2xzFs4PxjDUsoeEOy0rec4bGTMsQHJljpjLKym3GvfLNn5CZcENfY/wF5NPCCXZXe0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199018)(186003)(26005)(53546011)(6512007)(2616005)(31686004)(6486002)(478600001)(54906003)(6506007)(316002)(83380400001)(38100700002)(41300700001)(2906002)(8936002)(66946007)(66556008)(66476007)(8676002)(4326008)(5660300002)(36756003)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUVsRy81b04vQnN3dVRiUVI2VUp0czVkVGJmUmJpRG9TNEdTWFhtOHZMdDlz?=
 =?utf-8?B?VnBGZWNPaG96alFndDUzMU82YWo1b1hzRHc3emw4a3hlejd4am14Ykk4aWM0?=
 =?utf-8?B?Z3FaZmFrOTRkQ09YcFYxMnF3QmJPQXlpNG9oL0FWY2lpc01UdFlIODhPbitI?=
 =?utf-8?B?dzNMaTdOODRpdGozRXZmL1ZvZldnNVNvUENoWVNHanVZZnovSC9lYVJkMzg0?=
 =?utf-8?B?SUE4VlhVM1Q0VDRtL05zUG9CQ2RlUFBIYnFhQ3JDWVovb0w1OXF5em53dENL?=
 =?utf-8?B?cmhYVmpyTGJteGE1UnB0MGZNanc0TVdVMm1TMDUxNGJMUUZsK2U2aGdkM0pD?=
 =?utf-8?B?bWlWbnZ6a2tpc2dMdHhiZ0lHb3RsTWhSb2VrODBxbzl2cVc4VVZRSFI1QVN3?=
 =?utf-8?B?azUwV2xKWHVVTnJoS212OE1Ub0wwQUZ4SERqc2JROXd0S1lYWjlKdm9rRmxO?=
 =?utf-8?B?dXdURnpJUWh0SjQ3cjBWTlo1SmxCZEtrT21RSVB3Wm02L0d2Nng4ckdUNmRB?=
 =?utf-8?B?dnVSNU5mWWRoZXd3ZVJmYUdEVkdQc0FKMmptd0lWU053L2RxQnJiTjg3VSs1?=
 =?utf-8?B?WTVvK0NrbmZ1T2lsdUlnRUVFZTR6NWNZdFRCOXN5S1YyVWFXMzZhbWVnRm5D?=
 =?utf-8?B?THNvUWFNR2cyYmhxRlNKaTc5Q1hEdElycCtlbXovRlREYnI3VkM4QVJoNmc1?=
 =?utf-8?B?S2RMamJ4c3djQzF4MlE5TjNUbDY0aWJ5M2pzc2FJTkhhcENnYmNXR28rQlF6?=
 =?utf-8?B?T090NFNZbHJIejk0YUFFM2R4QVFUeEVmQmtNejNSWko0Z0pldkFOaWZJL3hS?=
 =?utf-8?B?THd5bUs0bmlGZUtaTGVKVXFXeFUwVWpwTWduWEU1SUhlblloSzl2MDFwdVoy?=
 =?utf-8?B?akRzMEpNalJCMDJhaGREb3pJeUlpNFdyd2xGVWpSS1dPa1pMU3Yzd2lzM1VI?=
 =?utf-8?B?MHJyWFNQd2Q5ektZZjRFRGoyTFczM0YwMm5mL0s0OFlNejBSVkV6RlNmbXcw?=
 =?utf-8?B?MTFaSXZZU0pBZUJKTCtRSFkvWTZpS0JXdVVObEcxWHYzWk82M052YzI2cmJY?=
 =?utf-8?B?b1BiOHUyc2NaNkY3SUpQOUdCNExQN242aHZLaDhkRFZraUdZSWpPdFYxV2Vk?=
 =?utf-8?B?bCs3QW56M0hnaU5OY081eG10OU9PVFlIRzRvK2gwVmg0ZFQzNXhranNNdUpv?=
 =?utf-8?B?MVZEbC9uMG5Sc05GT25XWnZTSC9ycFJUWEFRVXJOQzdZUzFGMG9UTFZYMVRM?=
 =?utf-8?B?YnNiTXUwVUVuWDBVUEErZ2o1bHhqakliRUI0bXkvZHFyK2V5WGNUcnNTTFVL?=
 =?utf-8?B?T0VMZXl3dFo2YkRrdTZlMkdsQkVLMmpKQlhpK0VTQ2VNclpaaWtoQjlCVk0w?=
 =?utf-8?B?TlBBRHRKMlF2cVpEODVDS2EyV1kwS0JDT1lkYUJwWitLa1R5S0FZcjhPS2da?=
 =?utf-8?B?YzJLQUVWd1dmTXpyS1hhTldxZ2IwcmljN0Z0VHpiajQ2QTFvS1RmR1hkR25G?=
 =?utf-8?B?aUxOZlNiTitKcHFKMVhxYmpBR1ZFSm15QVN6Z0QwWnZyUHEzZE1zSWxrTjI5?=
 =?utf-8?B?eW9sZks0QmZJUVJOdEFsVm05d2tkQlU0VmFVM2FPM1RNNll5RG1VU1RXSG9Q?=
 =?utf-8?B?N1lXSEVpZk9ySUROSVl5SmxVcmVDSExPVFU0cnZpemErb0FSc2QzeVdDZGoz?=
 =?utf-8?B?STNDc3VMeTBvUVhtRHJUSmlINlBlaDNaRjZGb1owcDd0QUVweEh0MjIrV2t0?=
 =?utf-8?B?WU56VUtUME5SQWZSY2hHU01EeGdSQ0J1Zzl3eklvSTd0UXJBd2lOQ2dLa3Ni?=
 =?utf-8?B?SHBLRFZsZVhMVFhKcFF3NXZuQTdwaVJ0b29kSzc2bnRrZXdscE82UUh2UDNW?=
 =?utf-8?B?RUJoNjFHdjNFeWRCQ0djcDQ4eGwvdDZtREYvNHZpZzlrd0wrYkk2c0N4dlM5?=
 =?utf-8?B?YTM1RExoNisrbmlPaWxzNjFQdUJwaTFsWkk2cEROVE4wK2VGcUNxVDN6NGUr?=
 =?utf-8?B?dUNYVFBpeDFpTXBQR09DUjhsU3JWTHMyVHVMNU1vVkk0WlArR0JuTzVlOXM5?=
 =?utf-8?B?cjVqejhHRExQaktRS1RPeGVzYmU1ZFovQTRQWE8wbVpKank0VUNRSlBBSVBF?=
 =?utf-8?Q?NnBsJFgY3b7AecDL4flBcfER0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a48763bf-6b8e-4ef7-cf2b-08db11c033bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2023 14:55:40.4806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsPMrmaH6ZyEybkfdS9MwcgPOX+iicCcFbLFn6bIr93RVlntovv0W04eQ5NkTHfw/X1kQzxFJ/gWeSLPLK2qAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5076
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 10:33, Mathias Krause wrote:
> Reshuffle the boolean members of struct kvm_queued_exception and make
> them individual bits, allowing denser packing.
> 
> This allows us to shrink the object size from 24 to 16 bytes for 64 bit
> builds.
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>   arch/x86/include/asm/kvm_host.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 43329c60a6b5..040eee3e9583 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -701,13 +701,13 @@ struct kvm_vcpu_xen {
>   };
>   
>   struct kvm_queued_exception {
> -	bool pending;
> -	bool injected;
> -	bool has_error_code;
> +	u8 pending : 1;
> +	u8 injected : 1;
> +	u8 has_error_code : 1;
> +	u8 has_payload : 1;

I find doing something like this is clearer and easier to read:

	u8 pending		: 1,
	   injected		: 1,
	   has_error_code	: 1,
	   has_payload		: 1,
	   __reserved		: 4;

(you don't have to have the __reserved, though). Just throwing it out there.

Thanks,
Tom

>   	u8 vector;
>   	u32 error_code;
>   	unsigned long payload;
> -	bool has_payload;
>   };
>   
>   struct kvm_vcpu_arch {
