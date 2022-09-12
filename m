Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3605B55A2
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 09:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiILH7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 03:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiILH7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 03:59:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684C92D1D7
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 00:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQLm5dofKWoNIk1i/o1Os/34VLdrFrLOVbxZmxEjtHu53MR5XwfIuoYvxM46EDvJKdR/Hjx2gXDGMbbK4oC+45GgDSzcnR0ce+vJOtEDEyikJ9eXKui41W4hUgS0EHjeLqY3BQpituPYk/f+h8uy9pCj9Eowt88YU2zizoDkLuMQ0ILVyRxVfyHsRnneDHxa3p8ykq+KSobijTWvYtfzs0rnPqvoEKdEYTOc612htXvk9kneDe7MBugxm0naTEv0NOMMgv6pFzGDYXWfp+UI8uOd1OIPvd7SeXk4a7lGCCGpXOIfyq54PGuLd+rlcWqN095l45+11FW7kFdPk04jCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hyfFm7aae/piJYwAwWw6KJ6x+rtXX/F2LfGBVbOxyk0=;
 b=oH+MvdQ+ZLg3QPkGQtvSeWk6jr3RxWUv+cHmC/miBYnRKc/XaSVI0gFunqn0WWiq8znrEs7WuYTlW1z7xTcy9LuqosWHdqbxI0s93Oduhlgp2SwUlJclDXdrLho4n7YcSnuBUDgeahA9uAYXvjNeLi/adFc6qDtejMwGdXJmOWMfmVKKgfdjBm+tcnEW2bvpR4ixA8csnFGlFfsvBYR3q+EFjIl+OOdoedhmEqnfhl9VLSCicgemvb7chneMR/9gZyB+Xhq5mYJLtCF4yl3sBXcLkRKL4L+EcchK8sthR151vdH4az7r+WYTwcNda+CJTx0mbu6uRTFS7+5CSnydfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyfFm7aae/piJYwAwWw6KJ6x+rtXX/F2LfGBVbOxyk0=;
 b=eOZZLX/BjNAmXOVVZJRGHua1bi1Snx20x4UPHD/hfnKaQDQQfhpM7guFPBJGqW664RPhELQkY+GA/A6AXO+zML0QiWL+GSsyDU9JfY3T2vSPJ94aKucamdClmDlg9htNheIMsoD32xjcGSP/WoLlGdjHF3F2tHdG/s0yBICC/Ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11) by SJ1PR12MB6362.namprd12.prod.outlook.com
 (2603:10b6:a03:454::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 12 Sep
 2022 07:59:06 +0000
Received: from CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::dd6a:ad02:bcf4:6758]) by CY4PR1201MB0181.namprd12.prod.outlook.com
 ([fe80::dd6a:ad02:bcf4:6758%11]) with mapi id 15.20.5612.022; Mon, 12 Sep
 2022 07:59:05 +0000
Message-ID: <8eaabd66-1292-4edf-259d-5b79640b9058@amd.com>
Date:   Mon, 12 Sep 2022 09:58:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220912075219.70379-1-aik@amd.com>
From:   "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20220912075219.70379-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0394.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::27) To CY4PR1201MB0181.namprd12.prod.outlook.com
 (2603:10b6:910:1f::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0181:EE_|SJ1PR12MB6362:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb2f8e9-d42d-42eb-1269-08da9494a956
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dq0XM0Dj4RI2jI6ppKnuAQ25LuFI6YMG0yZsciaCPivFG05tdLJfsfozD0GX9lRKWnvJLgjmi60jGe4FrrqEPSHYqTSY1zMucnt3IzK/VEKTZr5CMkgwGeKh7Txv5Y6ksoxZ5bBQe5Hm8Qe8lRxGgcxst5vd46D43drKTUXRQLgQIUHmJBUvo6fLecIygtnUCC/KidmFku/wfur4mDzGXz9ialWFtRd5rzUZnDcXfmqVRZdJTxWFm+s3yJEazrZOdJ2Q7/JJ8ws1Ejtd1jnwk/Q+cpKV1j101R7Z8U9dl6NjKmk0qLvDl1bMBgjuHRa4YLmJEys6rNxpCHWzD6D8HYg9uAnkKM+s01hPDXeMAe8JgHqnNj6vDY6BrA/eL0H3aQa6y9OtsikLrJwYEiKys6K8coc07oxbmV6c53wAIxOKC6P5Tont0yKc5HISK2Mc2riOy0SiRm1BAZno9PD9t7bERohBcJ1TxxJsGezdFNPnYdBIozSqbVFtqDtEYBy8DsScjuzjGqyP3UF/OT2BFN8eP7sP4rF32SH237+yB8OXpl/cbhPWndqlKS9+HI/mPtL5PSgVJQlllxkEUoxMPVnwFb+rBGx+74gtbXJ/eDVs+aK8rGNeeDGlHcY6IbkZtd0TUU/CN0cDOVksMxflS25NklOiFulC5Ptc/0/A4ZJLK3tmxyo36JrKJ4qypzj+0SF8sjW6wfTsjptmCwDTZvM178wA9i+a0XMlBwFL4gvhhkTADENIFLkdDx5voCZMEhTbLH0G7gnJBtNA6qA4PLAb1ISK2APySlbQQ5IUF0Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1201MB0181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(6506007)(8676002)(66556008)(478600001)(4326008)(66476007)(86362001)(31696002)(54906003)(6486002)(66946007)(38100700002)(316002)(83380400001)(8936002)(41300700001)(2906002)(6512007)(2616005)(5660300002)(36756003)(26005)(6666004)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akdTZ0U0S0V1UXdYWEtiNUNFcG1UQnBNTjdVYnhFR1ppblNpdSthYXl0RDBV?=
 =?utf-8?B?b0FCUEthMitnMUxxSjV1STBjYUx2VmJJWE0yWTN4N2hQZ05pMVVIeHIzSE1q?=
 =?utf-8?B?c2N1aVFKLzJMREdqYk5YS09BOTFxR05PaUhXV09PUDFLakUxQnRHR0V4L1U3?=
 =?utf-8?B?UmtNc2g2Mk0reWJCTCtpS2QyYjRSSVdPMThzVitkb3c5V0owKzl2dndBNDRp?=
 =?utf-8?B?TWVjTWRKTDcwZUdRQVI4OWxTZm54SUN3N1dQSk5CQVhLcmxxbmpvUElGck4x?=
 =?utf-8?B?cW1uUVVuNnUreWpWMWxyTEtCS2ZVS3MzR29pTVhETUN1eE9NekFiRG1xYnI4?=
 =?utf-8?B?QjlWZjJnNE40ZGdiQlFtSlBuOXZMbDFMeDNCN1pQMVNPaGFUS1cxQTFCdkhP?=
 =?utf-8?B?TzBTdFdkYTJ6c2djZ0tydGVFTGxxN3JHTWIvUUVHNU05aDRRNlRueUttR0Fi?=
 =?utf-8?B?emRsa001RlJxM1RRQmdHanJCbjBuZW5ZRWhXWmpiQkwwdzYvN2Z0azlaZita?=
 =?utf-8?B?QW1CQWJ3cnQvWmR2RzJ3YlN1Zi9vVjFPTXh5bXljcXRBc0RwdFVFcEJvU2pJ?=
 =?utf-8?B?VWtUK0FPa3BVZXNZWGVHb1JyeFdKeVhLTXNKOG03NlZ4N2ZHdk9qOFl0K3E2?=
 =?utf-8?B?Rk8vT3Q1NWgrSytMbmNER0x5bGl2Qk5qaUV2ZU84UzF1S2RpNE5sdm96TUZ1?=
 =?utf-8?B?WDdJeHo1cTl2TFZNb3JwQ1dlMTNiU2g0QXR3am9DYUFLMHJ0SGgzUlZzUGlK?=
 =?utf-8?B?UHoyQ21YdmJJWkovcWFUbXg2OC9MK1ltd29ybDAzSGdxbEU5UncvaEFUbzdY?=
 =?utf-8?B?cExwTzg3ZWE2TUhoTW44SVczd2NjNnFHeTJBYkRlbjA0OFpZeWozc3A5VmFu?=
 =?utf-8?B?V3N4SHZPZ0FXWnY3M0FVSFZ1NEM2bjhsYytsRkJFajdOV0h6NnZiV0xGK2N3?=
 =?utf-8?B?MmtKVy9sR0lpcHV2TzhQMSt6WEIxeHBmYXkzcklNT0wrYitNZ3grdG5NUURV?=
 =?utf-8?B?cG90WVliYXM2VnZ5NlpoTTRCVFRPVFdHeFdjSzQxcWJNdzVobDdiaGxvZzhU?=
 =?utf-8?B?VEovZG52UHUyOTdmSGxsa1ltand4T2dDUkcvVFhVM2RQT2l3Q3R6cGNDcGg0?=
 =?utf-8?B?RUduWHFBSm1BNk1McjBYRFc2T29uSTFiSGM5aVFaK2ZGbHR2WEx4UkVrb3Vi?=
 =?utf-8?B?bGYzTlJvTUJKK0ptNFBhb09qQTIwaDFESkVCRjZnKytPamluckVOTEN5aVJy?=
 =?utf-8?B?djNwNUZ6bFNBNkVXd1BZekFQTktOYzh3blZNM0w5UHV2UG1ObVQrb05KR2V1?=
 =?utf-8?B?V1M2MzErZnlId0RaY1QxZHVVSDluOXZhdmI0Nkd6YkJoaHMwV2lBQUNHWk8y?=
 =?utf-8?B?M2t4ck83NUt6YzJPcVhza0RmQm1nMUpkWWFXWW9jdXhCck54S2RsYmVPUGNy?=
 =?utf-8?B?dHpFQVRoTTJsNHRpYkVuNUs5UjBjNHJ2WjZNRXVqUHQydWF3VnNyNnJMb3pq?=
 =?utf-8?B?WmpMaCthZlg4MnFkR2ZIVmVFK0Q3azRaY2krTEd5QWtVYlZHOVorTCsxbis1?=
 =?utf-8?B?NFlEa0RUTGZyRmFSMHhPd0tmSS9DdnUwVUg5T2ptSXpKY213dm1LVm8vZG5j?=
 =?utf-8?B?TUlwRHMvNzlEZkFJVEVGQVNNcFFyMnBKZ1ViNElkbzl0SStObUxWbjcwT1J3?=
 =?utf-8?B?VkFHNWNOOVh2UDJaN1R1Y1lhZjBTUzRJRkpNOHAzbGs2QmoxRVZmc2FsMXk0?=
 =?utf-8?B?dFMxQ0VHNVg4QWJBZ3MzWjZxMjJoOUg2OU1hVHBYZ0tlTlJjMlJHNUJ2TWZ5?=
 =?utf-8?B?RXFEcWVqSVpaTVZtK2dTcFdiaUV3VEJ1T3RMQ0dXUWZ1cGlCZlAzVXBvdTBR?=
 =?utf-8?B?cU0yclNBYXhFdDFWOXdjSGlyK3pMNGRCOWJiYll1Vm8zQmxpTDZRL3dhM1hm?=
 =?utf-8?B?V1ZSZThwNXlYMDkwYy9JWitjMDZDRHhiRERGQ3U5TDR5K05BeEhSc01zY1lJ?=
 =?utf-8?B?WmxhRDEweGRKeDJmaVgvWFJBUG1pMTZvaFRPTHVtSW5aU3NWQ1N3c2RHVmRu?=
 =?utf-8?B?a0F6YkVuOUh3amlzbGRvdHV2YmRCUittUlJIN0c4YTlBM0x5Vk56UkJSSHdm?=
 =?utf-8?Q?XIhaGyZ/C2sMTQKG0KHP9fXa+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb2f8e9-d42d-42eb-1269-08da9494a956
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1201MB0181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:59:04.6219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5S5dhrCMFJrB/oS/BmDtDIxbgPeXMA/CukvYBOXcPLqYysI9M5SmfTpd418Jfc7ibHhpYo6u7DVbhDPBPVPViA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> A recent renaming patch missed 1 spot, fix it.
> 
> This should cause no behavioural change.
> 
> Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 28064060413a..3b99a690b60d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>   	/*
>   	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>   	 * of which one step is to perform a VMLOAD.  KVM performs the
> -	 * corresponding VMSAVE in svm_prepare_guest_switch for both
> +	 * corresponding VMSAVE in svm_prepare_switch_to_guest for both

Also, observed this while reading the code but missed to send a patch.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

>   	 * traditional and SEV-ES guests.
>   	 */
>   

