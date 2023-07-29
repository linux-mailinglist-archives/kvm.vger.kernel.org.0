Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE96B767B66
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjG2B6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjG2B6C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:58:02 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9ED4222;
        Fri, 28 Jul 2023 18:58:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jL0nIA70sACzjov2SYq2hUEXz9NHfO9WwoY3i1DqXU+BLqBrJvdJZA5bMECfWGTO3RN3tUzhhlwktfeTq9kkjKkw1S+JbwJm6FcocTVZg3SiBo03KbYmB9peB62PiQvch0BHjeWeaCMW9aAqZ8RyhrSGHpz9+TXEmoBqkNKILfCd/nbbtvvHKFv6pAASUh+rbbLhlsi7wXsLOeFCPdKAuc5PRNPB/gFuETQycegbVjZIuU8nxIRwrRLbc/z5RDHg9rZdb3hiIu8wNYbJjaFTi+G+ExkmpCBfOnvOyVjwkfRgwHTyeYiyUfQFUZ82qL5sOPqHkgONS3FA/vxv401rRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvL+De0sdhb9vC+b2xMp9INYd2gOrUUC2SZWHuvaClU=;
 b=A6HLa/P2REVG2TExYzmM7cA95iusfL3KeSwPZSGWY/Z0S+1xG9rzCLmGy74mL44B5wduQc82WUr6ewRb+KTRPGff8ZCh1YytUm6EN+F1h+L2Uaq5NikCDUghYn0l3Oae86LTJvZaZL0XBSdnleE2G7FxLXwoMFWKuCKmDTMWe0kCwrY1zxYlAoD2kg15+he/32Av+2gkNMRivEn7i+pSr7auj9stEsL625g/8zBPVdmeweXpP/udV6pEmhZpTfFJX939ELLAIC/PkoJjLOEeUS84yKaJJbBXp0L5+RiLDlOJf1hARmydDUvT6d43ehlcTE59av6F3fFVPAE5wSOn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvL+De0sdhb9vC+b2xMp9INYd2gOrUUC2SZWHuvaClU=;
 b=Ahy272i4dwLJC+S4TKUnwZ4MJQHxemXyrKgzVe16yWH86LsjQvlycz+SOSUac2nPlHdCGHbQhFN8SEnS6og+eIwN4hAURKj0mRBtNpyg3A9YT3QpRw4ZrPdLeDwZDvMjIR0wVmn7F6ubWDQbSNDunUoGULt1/SFKJfEZD0qpPig=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 PH8PR12MB6722.namprd12.prod.outlook.com (2603:10b6:510:1cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Sat, 29 Jul
 2023 01:57:55 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::8eef:8dde:e1e1:2494]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::8eef:8dde:e1e1:2494%3]) with mapi id 15.20.6631.026; Sat, 29 Jul 2023
 01:57:54 +0000
Message-ID: <2b41fef5-8e77-74b6-e43f-3da4929734b7@amd.com>
Date:   Sat, 29 Jul 2023 11:57:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [PATCH kernel 0/9] KVM: SEV: Enable AMD SEV-ES DebugSwap
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230615063757.3039121-1-aik@amd.com>
 <169058576410.1024559.1052772292093755719.b4-ty@google.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <169058576410.1024559.1052772292093755719.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0003.ausprd01.prod.outlook.com (2603:10c6:10::15)
 To DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|PH8PR12MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: cca56653-13f6-4f0e-9c7b-08db8fd73955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZI0xx7Hpf0nbOoD9hX5tzq+19TbaGpXk3apa4bqytWZQtcHj+k3oiP/SzyaBdGtGRGcKnc1yUUGuIPdKOUXQjETd0TXf+CH69/jpkRqhNZQge2KGFR7UOsLcLGOm+rGS10iQ6UTFlaxQ9bATEjow6Cf7Ipet+fQKvVvo6URy4yWKkRTNURgOdb5ESQ6IBlCKLPRwABE4KXjGvci8/feXrIsx+Hgrx1Dl5ODoTG/Ky7k2qpvgttsYkKzZcUJWQuKmLwtU+23x0a11tpjSyW/FPtClsivqQHT05ILYtUhe+n5AnVXVOFe3WArGUl6eXD10Gvgq6Tqn7bRxch/ofE4ERfE2juJStzOOgWJ7ViUwFNs+QBujia4nVFO8TC24dAjyPxFAro3AKkfXjkJjkj7Tyb8ZYBDyhc5ZWRWle+dB+f7KJVaPSIqkCQXphAlXXCDo3HLEkD3oKgTSFFaQmGJ45itkSfDUm6xmCMaVYx3FYNPIxnoW/zxYste+mnIcQpRr6kVGnI5qACklnTv2kj3KQxo4I71jsCmoM6d2BeixJnCAWX2d71+5ZWIjRpQlw5/99LOtltaOk1dwAXOBwFpFXCM5rYRIr3xl4FdLo+iqlGFEEargCWRY0+5hCYCTC6sWDDGNmkzT/8Ax0EzVzu9xY0OjwlrkDztrzmrXYogz7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199021)(31686004)(83380400001)(478600001)(31696002)(5660300002)(8676002)(8936002)(36756003)(2906002)(41300700001)(2616005)(38100700002)(66946007)(4326008)(66556008)(66476007)(6506007)(316002)(6512007)(53546011)(966005)(6666004)(6486002)(186003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXp3NTlkeW0zOE1ISldIVkxiSmplSmU0NFBDdnZIdFdXSDhDQkR0N1JxTmdP?=
 =?utf-8?B?KzhiV1p6QTlrY1hpSmFiRElaWG52WDJjL0tZbGd0WThsZU5IYVFVUEF6T2hL?=
 =?utf-8?B?MUhqYXB4NlpqSThNZzkxdGFNQ2VqdzY2L2kwSTFKOUVpT3NJaXdYMEFoOWQ0?=
 =?utf-8?B?anZ1RVpIK0llQnRrUG9Ybm5ON0xIRHVaQUVFOG5JMHdYdjcxb3RiUWY4bVd2?=
 =?utf-8?B?cjlrUVpVcUJaK1V4SUNna1B0ak1ISUw4blFKZ3ZXc21EMDJveS9FeGJBL3g2?=
 =?utf-8?B?REtLS0xiL3BEWk1mME1kYVZSZEdlRHBwcGdrY1JLRi9PNEx6NzRpOGpTYzVQ?=
 =?utf-8?B?ODVDYSt2Mnk5U3hrRFlDQ1dhdWZPUEp0YVdJRTlscktsaEYxZzdYaDZJMWVj?=
 =?utf-8?B?c3EyMnhMdU40ZUJkNVh5ZkVuK2NpNEYydkFNV2NWWkhzSWNHWlZvVFdWd1VX?=
 =?utf-8?B?cGIxcEFIY1A5dTJ3S0dhNzdVQUtTaHZFQTBzS3J6MUVZWG5JRVovbEsya2pu?=
 =?utf-8?B?QUswM1ozNkpVL2FOcERtdjZGTVYwTFp5NktCSlJxcHZsWnBiZDN5Snpvdmxw?=
 =?utf-8?B?R1RGS2lLN0p0ZHJFMXFhbE10L2xQOUFDbUFGbHRLa1c0djNnTG5VbjRLaW5J?=
 =?utf-8?B?Vy9Gc09rb2xGWFBDelZzVmU4eHoxYzd1WXJaVUtGTm8xSk8vS09pR1ZFdFk4?=
 =?utf-8?B?dDRzbE0za2REenV3Q3NmQmRwWW5UaGZnSk1PaHA1SlovTzdPVmQ0Q0N0bXBB?=
 =?utf-8?B?cmcwNlNRL0orY2JBeFNvcGVmaVoxQXVWMEk4K1JRbHNib2hUOCttaGtaYThC?=
 =?utf-8?B?YkNQYjkwellZZDEyTVM2MWxibDlWZkxJNkhmQjZNbWRtYXlQWENOSysrSThh?=
 =?utf-8?B?VWFQdENmV1Q3R1ZpeHNBYW5EaVZvSUhsRnZ3L2g1dVdEMDVDSHlEcHJ6UGlq?=
 =?utf-8?B?SVc4djVUMXNMMFY5N1RaMEpXNjcyNmEzaTNrZ1laQkhOVUU0dG5oVjVBTkNB?=
 =?utf-8?B?L1BrZ1Jyd0E1MTNZdDg2UTQ1UU5iekxsZWk1aW5ic1VFSzh4TkJYWTdPSUdE?=
 =?utf-8?B?SXZjajNudWpONzNubDV2VUhQRnRnL3JQUzhOam5aVDJWNHRHbDQ5UGdhSkVT?=
 =?utf-8?B?NHVjY3I3RW1jaEhPOWtCWE0wZXVUc2g0ZVNOc3psQ3BiOGJ3bTZpT1o0RTBo?=
 =?utf-8?B?c043TUFCNTYwQ3V1d01lMUh3QnRDUGtRZUdJWE9wUGJST1FVRDl1VERiTk9n?=
 =?utf-8?B?Zk9ZTVc5MlJtYndONWx0dXN1K0FIbWE2aThPTnpTRFA4WFNZbVQ5d2NXYi85?=
 =?utf-8?B?cnIzWHNhMU1aWkF1UGtsb2F4WGZtNms1aXltRWlXSTRVeEhTZmY4eDh2d0NL?=
 =?utf-8?B?elhvSjAxcWV6SklydURuVDNLendtWnpmbjNsVU4rV2U5aEFvQnlSTmhxekVy?=
 =?utf-8?B?bVFBU2J4bU1Xb05IUVpDMEpvU2lXeGhNRnFGbXJkeFVpZXhpbk4yQldkV3FY?=
 =?utf-8?B?M3RqOWJ2N1FLUWQzQUhDOStKY0R2V0t4YzBCVVlmVmxsNTZzd1ZYb2x6YXFH?=
 =?utf-8?B?bTJreUtmY2JVbkVpdkhGWTFiKzE4ME4zMFNSRzdqcXlrb1U2T1g3OWUwZCtC?=
 =?utf-8?B?VXBuN2pVMkZGMW9vZ25yYjBZUG5tdCtBRnRhcW00SnA2MGo2VzRNVkhNa01W?=
 =?utf-8?B?WHNvcDhUVjhiSlFPd3Z3MC9hMG5RRlM1RXJPVncrbGUvN3luODVCTVg2dTdu?=
 =?utf-8?B?UlZuQ2ZpWlYyQUcyZkt6NXlockhKZ1FMQWcrMWVwRDM2V0NlUEhsTE5Ic2ps?=
 =?utf-8?B?TWlsclRWTVhzNFVVL05MUGhJZVRVWU1FQWoxQkZ6aXFobVNoM2RadjFRT0M1?=
 =?utf-8?B?cFpxVG1TYWhhVWJUM3dyRDRVQm5BeGVWeFFoQlhPNmRkcU5HamgxMVcreDVi?=
 =?utf-8?B?ZExDMnc0Wk1SMGExanIrcVllRHRGOVY5T0owN1Nycjh3cTFJMFFlTkhhTnFi?=
 =?utf-8?B?bmlBWWJ6VVUrMTdsb1pPZ3U5S05paERrNTZFa2JpM0pBU3l4ZTBKZW1aMUNj?=
 =?utf-8?B?NXlmbng3YklBOUt5Wm9BRUlhOU1vZWpySWxtU2g3dFJvbXczUjZpR2tLbUlQ?=
 =?utf-8?Q?4r85qRd1FJn7R1FDNUj+tKj/L?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca56653-13f6-4f0e-9c7b-08db8fd73955
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2023 01:57:54.8515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfDszr2i4bgtG1u8fA+Vw8SaUvj9VWI/gD8C6XmHHUZDk/Hg78XW2JKomlC4LNrKiEnjBe4yrPZJrh5ZAREdeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6722
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 29/7/23 09:49, Sean Christopherson wrote:
> On Thu, 15 Jun 2023 16:37:48 +1000, Alexey Kardashevskiy wrote:
>> This is to use another AMD SEV-ES hardware assisted register swap,
>> more detail in 6/9. In the process it's been suggested to fix other
>> things, here is the attempt, with the great help of amders.
>>
>> The previous conversation is here:
>> https://lore.kernel.org/r/20230411125718.2297768-1-aik@amd.com
>>
>> [...]
> 
> Finally applied to kvm-x86 svm, thanks!  Though I was *really* tempted to see
> just how snarky the pings would get at week 5+ ;-)

Thanks!
Here is a gist what it could look like:
https://www.spinics.net/lists/kvm-ppc/msg20903.html :)


> 
> [1/9] KVM: SEV: move set_dr_intercepts/clr_dr_intercepts from the header
>        https://github.com/kvm-x86/linux/commit/b265ee7bae11
> [2/9] KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV
>        https://github.com/kvm-x86/linux/commit/29de732cc95c
> [3/9] KVM: SVM: Rewrite sev_es_prepare_switch_to_guest()'s comment about swap types
>        https://github.com/kvm-x86/linux/commit/f8d808ed1ba0
> [4/9] KVM: SEV-ES: explicitly disable debug
>        https://github.com/kvm-x86/linux/commit/2837dd00f8fc
> [5/9] KVM: SVM/SEV/SEV-ES: Rework intercepts
>        https://github.com/kvm-x86/linux/commit/5aefd3a05fe1
> [6/9] KVM: SEV: Enable data breakpoints in SEV-ES
>        https://github.com/kvm-x86/linux/commit/fb71b1298709
> [7/9] KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled
>        https://github.com/kvm-x86/linux/commit/8b54cc7e1817
> [8/9] KVM: SVM: Don't defer NMI unblocking until next exit for SEV-ES guests
>        https://github.com/kvm-x86/linux/commit/c54268e1036f
> [9/9] KVM: SVM: Don't try to pointlessly single-step SEV-ES guests for NMI window
>        https://github.com/kvm-x86/linux/commit/e11f81043a12
> 
> --
> https://github.com/kvm-x86/linux/tree/next
> https://github.com/kvm-x86/linux/tree/fixes

-- 
Alexey
