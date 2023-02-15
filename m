Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E50697F9B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 16:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjBOPjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 10:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBOPjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 10:39:12 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2106B273C;
        Wed, 15 Feb 2023 07:39:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxhDbxNm+Vy+I9eq9Hr330npFtPE+9Fc4ufP1cATa2WNpo2BQyRw8B44/4wfYnDo7tFuw2zK7oo2Y7MhWgrcfVLVWtClr1yg61kWXlVbSEp0BgBPt0P8uWnmV6YMm8lT1lnnyTw8zCMg5Bnf6YKAWZjbKvShZCiq1wjgzROTbkDHYT5LCRkXaQE/mvTaCib6gRBsQXngoRnPxLJ2qbrHwNabcVkuNuKNsjzP9x2SOkZpkqX/AgUGv3X2ufcHzj0xSpEERv9Hgvf0MJzzFoU3cwH0kzCqOYDvLAm7gSzY7w37Gqh6Iax+WuSTH1TcIhVoCbpCKN+H2kLQGwUMsUqyIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4FfkR0vR5QYMB4I7NBjvzsahF0kzjJGDCfHAwKkAco=;
 b=Yz87Cy+TWYUBrOqXDa8aRdxD8pQlAWGnfogJfNfom40OUhrVnPIy3/VyJFdttl7nlWsQmpkXWgsXVx0GXCxcjin7DsdBx6FX0TfdIlkzUA7S9X3nzDOVf4GmLC9VAx3ZB9U6NLAdi/NR3DNjQDqYAtpB04uaunxzarTwB2TYHZg8nRCwfH6qa0CtqRrYqHn4xetYbgMznwVGSXJaHjZwJeX4OWa6XrFrI/WwI9KsCUvp30ImZtkbrphULr4TUvbZmh6XkgAskWDECDnyctUkNbB03Cqt2L9vmWF7Pemlt5x87jh7vk2rCTGNmknV1nzmVpHPYW06o+aSBAmdcpDIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4FfkR0vR5QYMB4I7NBjvzsahF0kzjJGDCfHAwKkAco=;
 b=v7JFiv2uOWCq2uwcSKfU++JwkIvNpk6PDTUvr7mZEei5tpeL9vizE87RVz9rJy7rRjokL9Reo3mvFspqjVPUb5GjSl2L0LLzbO7DK7ExuWTnDSjM1pOuU3KdaJXEBRD25XDsoRNV2k2tb83xBJ4mCnVBAl8eVGUgohpNG5dEqFw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 PH7PR12MB5949.namprd12.prod.outlook.com (2603:10b6:510:1d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 15:39:05 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c4fa:4cd7:4538:e54b%6]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:39:05 +0000
Message-ID: <80dc58d3-0ea2-652d-7881-32a4526b5c14@amd.com>
Date:   Wed, 15 Feb 2023 22:38:57 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/3] KVM: SVM: Fix a benign off-by-one bug in AVIC
 physical table mask
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-2-seanjc@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <20230207002156.521736-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|PH7PR12MB5949:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a8c88a2-05e2-4d94-38e2-08db0f6ac529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jPc0dsoiQqNajQMiyfRlKxPRWeilm+U30qOw5hyGhgKwgq/iB7vGjthWh1uK7NacMo6umyDTU4TOskHrnyqOpri+uE+3XPlZIZMrqf+lVPpiR6E+SiGf/Z23QLAHtMdcN1q8j5cEQGzIsUfTQxu/RW9h68nh3QKYc1OVG7SUjxhzx7ZJc8+t4mFLREqxvqQutBbUsm5TKildwhMbKI45AIPnvq0QvScqWuA04ZfdSMlMeRBcsbytjUQnOJx5EL/LMR11dPk5Qsqjx6Mkk0EzFtXjMv40tYupHzXcsLBaWxvIgadRYipBPjt7vlEUqK1caTe0veNS9bqawe2pZQX0SkGqNHL2A+RxP3CtbsrD++QSo1e6qaA6AnVrkJe0dH5kkd9+STE4wVxOPXWIKUMVkxjPj/ufpAIVz6v+fRUETJyBBscSAFv+QEBGEvINF+LUghUH+f1TYU/HQq4rl6QQXQtJ0ih8/K/RNVi/WYOjebPZZnD5iiiKEt3oOAb4EX7oZf60HMtQz7w+Pga01MuP4LFWCwtgF1BYLUkmagFLx7YBvOsxOt+aHflKf9DNIauwk1jM7URLvU+CuQs0pZQDSC5m9EpTHMrqz6uZ93NebQT367FEHyTauQlf78eIUrcPH0QnMHOiteyEXxgELtLM7uj6FZuIdXVkFwiLPe7eiXF5nP7wASwuwlKI0fj6Brvvmh24moBybpUfu9K0WGjOUXD/8TCxkflQ5i/Ru5pgpU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199018)(86362001)(36756003)(31696002)(4326008)(8676002)(66476007)(66556008)(66946007)(110136005)(6506007)(53546011)(83380400001)(2616005)(6666004)(26005)(316002)(31686004)(6512007)(186003)(478600001)(6486002)(2906002)(8936002)(38100700002)(5660300002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ni9oVzBBV0wxMzlUTVJSTlB1QW5vWnhDUWQzYnhKc0doblZJc1RZQXpKa2U3?=
 =?utf-8?B?VEFEbzYwTjdMMzJyMHdDRXV6eGlNN1BLTFlYVmRiUE5haVlSeitCQ0ZZTzFy?=
 =?utf-8?B?QWlQNjdMcXF2aFJ5ZzNOWHhINDBTSk9ZT2toT3NHTEgyemNiem0wZ0gxVkJy?=
 =?utf-8?B?ZXFhSE90TzAybk9BY20xbkFqQ1lqSGtiZTJZZ0hwWUZYaUtLcGJBdjNFODM2?=
 =?utf-8?B?Z1dvQzNXSFdVczZad21JTkE3VXUxSElRZk5SWkZvWW1qRDhsQ3hOMmxvS1Ra?=
 =?utf-8?B?R1Exa0Ezei80NnJ0QW1PYkN4dVpzd0YrR2hTWG1sZmwrWFRBVVQ4a3hJTzZ1?=
 =?utf-8?B?Qkw3TFNza2R2SGdjWld3K0dyMDByc1FtUFFnbFBHZFh3LytTdkFZTmN5YmZE?=
 =?utf-8?B?Q1k4TWtMQTZOSUFxcHJNb1gxcnJNQ0ZTUzlFWCs0VFFGRG01a3E4empweEc4?=
 =?utf-8?B?REpRaU03ZTRlMktCay9uUCt2bi8wY29nRGlsUUhaMDN1OTBYSTBtT1JuQzRl?=
 =?utf-8?B?NDlpOWFNbWtKdzVsdUlZcjI3VFNMcGdmK2FpZDdjVXJuQ0k5UkpZcFkzM2pX?=
 =?utf-8?B?OGVYRFh6dVVBdy9lTW1BeTN0aTB1SDB4enpGOC9yWDJVMHZ6YTJ4MXdRTW5W?=
 =?utf-8?B?K3NKWkE1d2xJSXIrKzFCWS9ScW1VOGw3TldoSjdLRmdyU2xSVUNPMHR3eElw?=
 =?utf-8?B?OXg2VHVvWGdIUFZYbC8zQ2hVWW0yZWZSUEpzVVBCVzFNam42VnFieGg2eTcx?=
 =?utf-8?B?Vzk3Sy94QnEyeHRkOFRYa2F1WkdvKzFreVJ2OVprN0ZsMlFPem1kNkpHVTJB?=
 =?utf-8?B?eFlPak5zeU9vRmxUbkkvNkFEemx4cUdlaUw3Mk9iUTZUMlVhR0xtM2V5SnBS?=
 =?utf-8?B?ZHVDT1hNREZoNmF1Q0hYS2lSVGM2RXp1bVdRUEdjZzUxblBwVXVJU0c2aGNS?=
 =?utf-8?B?cTlsNHRrdGNQRVRkNCtLSFBQdHQwZFVRSXNnMHhwZmJJTWV4VlZlWDdjNXpx?=
 =?utf-8?B?eWlhUzIrUEx5Vk5LN0dZaURtdFF1Qnphc3JTNHJFM1l4Zzh4eDhaNFhldHgy?=
 =?utf-8?B?VVRUd0hHWHdEVEp0T3ZUOVJpMkRUdTJBWlNzZ2lZUVZ1VDBnbEtZTTJYdDJy?=
 =?utf-8?B?b1YxL1N2MHAyKzA0cWZadFZRNm00SXhOZVFyeUJlREZ6YW1OalpTa09ybHJq?=
 =?utf-8?B?bHFlelFZc3h4a3FJVHJuUlVmNCsybFdmUjZvUVV4SjdvVXJyZ0Q4TktSNUZM?=
 =?utf-8?B?b0h2TUJsdGtBUXlVZFoydDlBTzlQakg2MWtoZDFiQ1F6WDF3TzZtMDJCYlRu?=
 =?utf-8?B?M3YydUZDUGNqeE9mR0duakJMNUw5MWFtRmJHMFdFbVVPVy8vUzZ2dS9EN3lZ?=
 =?utf-8?B?c0JpUkIwZzl6eWNxRGJMQm9SY2Fza2xFUG90VmpuSzFabk5rYXh1OGpCZ1pH?=
 =?utf-8?B?TlREaDZHbEIzOFRsRVlCLy9WWDhucUNFSVErWWVBa04vVXpFYUp6dFdMa05U?=
 =?utf-8?B?K3FQSWlpYTBCOHFNSEppNWdnUWVQdEZHS3hzRnQ2WGdCcmgzeTFwdnNFVTZx?=
 =?utf-8?B?RkhZM1N2dk1TT0djRWFwOUo2cjFBNzBnaWhYOWdWUE5NYlV2MHEwSG56ZHl4?=
 =?utf-8?B?Sk5wTFBrSkgyeSs0Vys3WENXYU03cVpnbHUxZWJmdTBUK2FNYVhCeFZEM09K?=
 =?utf-8?B?c3lBWVhFQUNnS2htTlhkaVBNZUg5TWhaR1R2aTN0d2M5MnhZVm16aXFhU2pv?=
 =?utf-8?B?TjBpSEVqZVV6UW9qK3VnUU40SVpIVXF3Zk5HVGdvdC9XVGJHRmxFaHFZMncr?=
 =?utf-8?B?eGJVLzhzUHZ0NTI2MFkybHZweFBpSS9JT2JiVkFPZEl6VkFMU2czV1pGbXRR?=
 =?utf-8?B?SXZFRkc0WHNEQjRHSzc4MlNIZ1VMTWg0VmtOL3RlL3hQSDN3WFV1MG5BQ1Uz?=
 =?utf-8?B?WVNKeUtMeEtuUGc0MTJqLzdBSU1HT1R2djlTMVpqYzZhUk5HY05oSkl2elpJ?=
 =?utf-8?B?SzVFaE9zR1pxZEt5dEpZMWlWajV6WGw5OHp3OG9UTFM3RmZ4MllGUCtqaUJH?=
 =?utf-8?B?SUExZWJ6TE5LYWtHc2JGWnI0cW5xUUdDbUI4TS9tRVFHY0VmWWxZczJjWHEr?=
 =?utf-8?Q?8JQ86t2VefJOe4CEGwMPfq+MB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a8c88a2-05e2-4d94-38e2-08db0f6ac529
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:39:05.6350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADogxtbl04hDfg5r/m6RyMo4mDHramW33eViiWUNHY8LbSZFnqe2uUlAT+2pu631n5QMu5ietfOPcJ3CZU3QUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5949
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/7/2023 7:21 AM, Sean Christopherson wrote:
> Define the "physical table max index mask" as bits 8:0, not 9:0.  x2AVIC
> currently supports a max of 512 entries, i.e. the max index is 511, and
> the inputs to GENMASK_ULL() are inclusive.  The bug is benign as bit 9 is
> reserved and never set by KVM, i.e. KVM is just clearing bits that are
> guaranteed to be zero.
> 
> Note, as of this writing, APM "Rev. 3.39-October 2022" incorrectly states
> that bits 11:8 are reserved in Table B-1. VMCB Layout, Control Area.  I.e.
> that table wasn't updated when x2AVIC support was added.
> 
> Opportunistically fix the comment for the max AVIC ID to align with the
> code, and clean up comment formatting too.
> 
> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
> Cc: stable@vger.kernel.org
> Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/svm.h | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index cb1ee53ad3b1..770dcf75eaa9 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -261,20 +261,22 @@ enum avic_ipi_failure_cause {
>   	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
>   };
>   
> -#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(9, 0)
> +#define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
>   
>   /*
> - * For AVIC, the max index allowed for physical APIC ID
> - * table is 0xff (255).
> + * For AVIC, the max index allowed for physical APIC ID table is 0xfe (254), as
> + * 0xff is a broadcast to all CPUs, i.e. can't be targeted individually.
>    */
>   #define AVIC_MAX_PHYSICAL_ID		0XFEULL
>   
>   /*
> - * For x2AVIC, the max index allowed for physical APIC ID
> - * table is 0x1ff (511).
> + * For x2AVIC, the max index allowed for physical APIC ID table is 0x1ff (511).
>    */
>   #define X2AVIC_MAX_PHYSICAL_ID		0x1FFUL
>   
> +static_assert((AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == AVIC_MAX_PHYSICAL_ID);
> +static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_MAX_PHYSICAL_ID);
> +
>   #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
>   #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
>   

Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
