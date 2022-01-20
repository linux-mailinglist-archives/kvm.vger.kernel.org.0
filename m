Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A3B495061
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 15:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbiATOix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 09:38:53 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12916 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353695AbiATOir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 09:38:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KEatxs018330;
        Thu, 20 Jan 2022 14:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xzf4TwvMw6GDS/E92br7ujXEOtJWJ6kO3A3DoNJIuVM=;
 b=ygbM+neVuRSrnWQHSoiYyHR7+UQYA2eh+y5/vAbfUj6Cgk6ts0hm41TCXDl8+0Cu3qvt
 fsxdS23dqBTiPcbUc1DlHBjOlY+NmXzEYje3qzQloAP8LVMdSaNlydPpjs7K1Vttg9S0
 SSL4jYarLj4K8/l3kgH+vvXqClgeVfrradvaA9gFVHIElwHeuKDjJrvZXh4IqVe749bk
 O2iNiEGhvvFCfxFgj5A+mGCuFUbdt3NUWLZNg2KrjTXtwxTGgOedUButf4JnIxggoOD3
 CYfunZmYq031eMseJL0FJK1agFGcLfwAQ+JkPhqc4x96ijTJn/TPTb55WGG6MJf6djdM lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q8juc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:38:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KEV1Ju042905;
        Thu, 20 Jan 2022 14:38:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3030.oracle.com with ESMTP id 3dpvj267qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:38:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwWOHOkMsgVQGYjZIhs9Zn/0jfRh0bqG+1VRfdM5U2R6J/dtDrtM+J3A8lnVKOkgA+L+a4bwZ9Yl4OXEW56ZLjSQWAdyHfHDdcjnrCWy58JnoO0KQdASYQgTdyYbrc5ShRIdk7tp3Uoh5vb+tx92VnkpZxqNcs4fKf+2A1hfMvmzXYnUTDQi7yVuRq3f3l808jTXFhTMh7g+Y2pKsykw+yyhjpD+idlWeEOYE2Eo+lW2myszlJrJ9zSWbC3EFeXdJiKky+ekA+QmbWVTyM23i14tKU90LhCht4EQDddbH+CHq9DB8B3nW38Vp0E9wiMetswzMf3rImVGDxOUBsSHlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xzf4TwvMw6GDS/E92br7ujXEOtJWJ6kO3A3DoNJIuVM=;
 b=MtCKAlU5lPZbzcRzhLe9lcX/2QiAZzZYrk+RUqRK+SJgdvbENCq6lpLeOvhdcwDZFf51cSdNW8v5giO81WELWeU7SvIDSU1349qvxfqDHeXb+0Et9OoYpR4TPuqYZXph4QQ8mpVoJtjnJFXDsG67atCG3USpuyPvOSUBCgfZX+DAWs2Rrgln9yX//8rbakmZMYjxqp5BZFS7KZQAi7hDO1fHueXAitELcHlkhvIzHE1VgGeDdotbvYcCspqmpTFJwRKQfy+uA+1opDvK9w1CsjBO+2+8XDpMghUU09Rmgo2A5XtxBDnGjXGTxDAL7QU2W2EzutY5dxNHU/owEoliKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xzf4TwvMw6GDS/E92br7ujXEOtJWJ6kO3A3DoNJIuVM=;
 b=u8B/wUaae6Jk1+4K8+BNU+jMUp59YsPv06VyPCU8AmVHzHzjhZ+E8dT+LQc155ctiqlTi/5etySc2GyDpLt09xqb2utu9wjKjcYvTX7UqpyjcjxC2RjkQ4hAX4gGjJkBHtzdZZCr/0x1JehHV6/AsQ5Mc6RaOLSfTayxGF2+R0M=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 PH7PR10MB5831.namprd10.prod.outlook.com (2603:10b6:510:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 14:38:12 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 14:38:11 +0000
Message-ID: <4922135a-cbdf-f27c-5408-ccbecc623130@oracle.com>
Date:   Thu, 20 Jan 2022 14:38:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5/9] KVM: x86: Pass emulation type to
 can_emulate_instruction()
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-6-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0165.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::33) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a723457e-24fb-48d6-30b2-08d9dc227c02
X-MS-TrafficTypeDiagnostic: PH7PR10MB5831:EE_
X-Microsoft-Antispam-PRVS: <PH7PR10MB5831A17CC2B5238D13BD372BE85A9@PH7PR10MB5831.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eCDEdpv2eNdtExdOq/catoz1RlUPMQDPYtIwfLmgjgdkzbjMShVIVORm5neRXJ6fhwEzPBXqq0O3NzOkRp9PzxZkObNTamSpQO2tE+0e7OsLxP8E+OKbbZspaTwKivKOGQDn6JuH0VTk4Ql+Pg90ZSiY33R6tQ/zde0FyQsqQwHsJNF6ZMVw/VAjg8YM08wM0UrCenfNiJel6U46bA1IGquuBfonWkvYBckGNBgZdrCMg2qQRHG2P3RzcB9m1jvlnzbTJmvstW8UQ1k/D/T8Hbq7epWhE4JXA6hAjbBSWO4JVU3sxMfutcE/XiOsvKpxJmKfAMmZWgwhN/Km13H+xc2K1W9qWBENfbqxdtmalqHvaHVEIqw/PPZmVqcNcEiHxtOx5WJiVUzzeeFseRMK9sz1ybBuc0TXHteu+GswlVMjA/g5hKImITk3o3JrUsMVLmpXYPmQJFmgpBFd7sZjVYMnBvUc0Aq4uTQKtPZ9GLaYhP4jx53XqG0n9Gof+p/yPqtEeFm8casZ6s5iXR8SQhfzf5IsWwFxulgncVF5znOQvSReP5PtZF9Nf+1IkqNFfrFbFo/r15PCqkBuJNBSspVy4fXXn1aAxG7gHwQR4r0vXEdq0XXgHU/Q7FvORNGEzGy9zwD8rV7rFaPj2q+mrXHEmssa5xik2ACWHeaFp8bxgPQwW4i/qKr8n3iPta9i4rc9o2+Xu2CpBoqWgWOw5TxVY0xZmhV3Xv1dBL9RJMJ6GqlWjA5ywXEb3HN+F2i2PwrqzBDAPaMFoyzv2VTLXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66556008)(26005)(52116002)(8936002)(86362001)(31686004)(110136005)(6486002)(31696002)(38350700002)(38100700002)(2906002)(6666004)(8676002)(186003)(2616005)(6512007)(508600001)(44832011)(54906003)(107886003)(7416002)(5660300002)(6506007)(4326008)(83380400001)(316002)(36756003)(66476007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkJadjRSejhLZW1MaS9BVGZ6TlMrcmVySFp1R3BzUGRwRW84R3ZyUHU5N1JX?=
 =?utf-8?B?a0U3WXpyeDFKNU5ubEZ4TmVzQkVJSHZBWTQxYkF4UzI2bkJob1NqUjM3SnFH?=
 =?utf-8?B?c3BEOWloT0k5MHQ2bnM3bTQwWDlPekRPV28wMWdzNzhnMW93ZXpZWXpKeURD?=
 =?utf-8?B?OFlWbklMZDA0bzl0SjhWZk5RUkJoRzBaek16cVgxTWlqYjhtMU8zMDRVZkNv?=
 =?utf-8?B?NGoxamlySjBMUkRORS9GdGVraThqV2tUZk44Nnd0UEp6cWZjZ3ZmV25EaFgw?=
 =?utf-8?B?UkZTclpZbGRUbVFnUSs5ci85MGlpdVcxYnlrR0JiZFdCVEs4eEthV3RaYVVt?=
 =?utf-8?B?SkhXVGZ5ODFtb2RoN1UxaCsrU3VhZ09tamF3VFloQVhrRDBIUnZydEVBdUUv?=
 =?utf-8?B?Z2haZmZ5RVNJQkFsSlMrMXdvSDFTNkJUME5NSTZIU1hweitqZHkrcUVqVlNa?=
 =?utf-8?B?aFhoZXo5T2VKWnNGbU5FdGgwQ2tlNzVPMHB0KzF0UElNY2c5RHpFRFRmd1JK?=
 =?utf-8?B?WHdncVQ3YzAvTTQxSktESThzZHk2Vzdyc3FGV3p2ZTlYOTh5Y2VHYkpzcVVw?=
 =?utf-8?B?VHlQNGJHRm5pUGd6M1VxeU1sSmRmdEdTQ2NIcFl0SW10ZUVRNW92b2lsWlkv?=
 =?utf-8?B?VlBaL3Q0UWl1VXBGZ0lyQklHcHV2QWdydExmY1ErdUUvL1FWeWpKajhad1dq?=
 =?utf-8?B?ek9jY2NCaUIyQldPRVpUYkFJWjYrSUdzdDI1R1E2bmh0a05WL0ljTC9iUzhh?=
 =?utf-8?B?bUNwUmIxTmRRcFd5RDkwajJUZFd2ZWh0b0RqT0FlZjB0YmVJWHNyN21LRkw0?=
 =?utf-8?B?aFM2ZFJOWnVOcExVRHR1aGJ3bVF2SUtKcXo1YWtyVS96RjNTVk5ySjk4RU9W?=
 =?utf-8?B?QXhnOHNiYUNFbFZxbWNmVDJHcExsY3Rzc3NHR3ZhVEJ5ZURNTWlyMWp4OHlX?=
 =?utf-8?B?Y0Z1ZnV3dnpUYWZuRUlNVloxVGVHT3R4RUJWaCtWSURZbGpyZlFQUlFVVElF?=
 =?utf-8?B?MTZUazNjNk5KK0xOdEFISEZwN2JEZ0RMNlpNVnpFUFNCb0xvQW5HRmE0NVN3?=
 =?utf-8?B?anVrLzBLWUVWeTU0R1ovRnBRRVFVM0tWWWFQR1lQZFAxcmJLWVdlTk5xVzFu?=
 =?utf-8?B?YnhvMU4wdUdtT2hYQTN3UWhmaCtsTys2aFNCSkpwV09EdEdDUFpVMGNvMER0?=
 =?utf-8?B?cWxlamxtcEp0OWFxVEhsRGszNWR2c3AzaGp1bEJvN3NUVjQvbVJnZE05L3dC?=
 =?utf-8?B?Z2JaUzBTd2ozLzYvbDFxQ0FQdlBVTHJQNmJoZ3BZNlRnY2hVcWNNdCsyQ1Ni?=
 =?utf-8?B?WnJaKzNXcFJIU0xDU2I3WDYxWWhTMlpWbzVuMTdSNnY1SG90ZHhtZW1LZEhs?=
 =?utf-8?B?Z0g1Z3ZiK0d0WnRTdC8vR2hGVzJWOU9qdEdnTXJKbXNrNmt1TGpPMFZoTEZj?=
 =?utf-8?B?WTAxMXEvb0t2OGx4c1JBUzRvbzY0ZmQ3c3locnZka2lUL01vNjFZYTY0UW9P?=
 =?utf-8?B?Qk0rYW1MM1ZVVVZVODNVaktYL3dIZ3lMWkc5b1NVQTFZaDVyUkZSZ1FXTDhy?=
 =?utf-8?B?VVgvYkpJNGo0TUNKSlIvRWFXcXhMU3dTQWVTcGhmRGNlZm9paXpETDBwUDBl?=
 =?utf-8?B?d3FTM2s2QnFqcGJ3Yi8zUEdVbmVNYjJVZHRzNlJlV0IvN0JZNGJaUFhsUFN4?=
 =?utf-8?B?N001Y0JaWGdWZ0tNTXlpbkVqNHo4S0FmSjBJb3RXQjZKZUc1SkxwRW42bW8y?=
 =?utf-8?B?V3BXWmM3cjJvNGxBV1VzN2VMVG5uNndCYjlvaldDTjFUYlAwL3I0SWw2blIy?=
 =?utf-8?B?emlWYW1OQURtV1VEaUp1TUVLeFdPSVBzOExBb0VIOHFEb21RY25qemFyblJr?=
 =?utf-8?B?Qkh2Tmx1aWNGYVJNREsza1l0ZC9wWi9UdzZjSjdOVmVpeFppMHgyUGhWeTdw?=
 =?utf-8?B?N093NTdqM0tCNHp6NGJFZWphMGl0UldHejVwbWR5dW1NVjY2RjNJMGpiZENE?=
 =?utf-8?B?dlY5N1lmVmZxTCsvTFR2MExKNWxleTU0dWlCYWlJUW84UUhnVU5UNURtdkd0?=
 =?utf-8?B?Y25xdEExU3paMmk4QTlWMkIvdVJaajBGeEhqKytvYUUwUG54eGd1aExsL0lh?=
 =?utf-8?B?OG01SEtUTUl2dWVyM2tPSUpqcnVxRCsrWDdRUk00T243M0FFamxsbHd3NWlY?=
 =?utf-8?Q?8rE4xTN2ry9jAfoOvVLhz0c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a723457e-24fb-48d6-30b2-08d9dc227c02
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 14:38:11.9183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuGecRcoOETgAh+j+wFC1nb8iFMcb+27ANZaQIT9BX7KaNpsLPgIAkG8Vws/CgQBMLj1/2dvhjO9crEByOHPiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5831
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201200076
X-Proofpoint-GUID: YcOc-JTTWIlsMF9yTg9SNI76FUezA44w
X-Proofpoint-ORIG-GUID: YcOc-JTTWIlsMF9yTg9SNI76FUezA44w
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Pass the emulation type to kvm_x86_ops.can_emulate_insutrction() so that

typo in function name - should be can_emulate_instruction()

> a future commit can harden KVM's SEV support to WARN on emulation
> scenarios that should never happen.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/svm/svm.c          |  3 ++-
>   arch/x86/kvm/vmx/vmx.c          |  7 ++++---
>   arch/x86/kvm/x86.c              | 11 +++++++++--
>   4 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 682ad02a4e58..c890931c9c65 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1482,7 +1482,8 @@ struct kvm_x86_ops {
>   
>   	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>   
> -	bool (*can_emulate_instruction)(struct kvm_vcpu *vcpu, void *insn, int insn_len);
> +	bool (*can_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
> +					void *insn, int insn_len);
>   
>   	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
>   	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index edea52be6c01..994224ae2731 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4257,7 +4257,8 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> -static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
> +static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> +					void *insn, int insn_len)
>   {
>   	bool smep, smap, is_user;
>   	unsigned long cr4;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a02a28ce7cc3..4b4c1dfa6842 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1487,11 +1487,12 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>   	return 0;
>   }
>   
> -static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
> +static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
> +					void *insn, int insn_len)
>   {
>   	/*
>   	 * Emulation of instructions in SGX enclaves is impossible as RIP does
> -	 * not point  tthe failing instruction, and even if it did, the code
> +	 * not point at the failing instruction, and even if it did, the code
>   	 * stream is inaccessible.  Inject #UD instead of exiting to userspace
>   	 * so that guest userspace can't DoS the guest simply by triggering
>   	 * emulation (enclaves are CPL3 only).
> @@ -5397,7 +5398,7 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>   {
>   	gpa_t gpa;
>   
> -	if (!vmx_can_emulate_instruction(vcpu, NULL, 0))
> +	if (!vmx_can_emulate_instruction(vcpu, EMULTYPE_PF, NULL, 0))
>   		return 1;
>   
>   	/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..2fa4687de8e4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6810,6 +6810,13 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
>   }
>   EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>   
> +static int kvm_can_emulate_insn(struct kvm_vcpu *vcpu, int emul_type,
> +				void *insn, int insn_len)
> +{
> +	return static_call(kvm_x86_can_emulate_instruction)(vcpu, emul_type,
> +							    insn, insn_len);
> +}
> +
>   int handle_ud(struct kvm_vcpu *vcpu)
>   {
>   	static const char kvm_emulate_prefix[] = { __KVM_EMULATE_PREFIX };
> @@ -6817,7 +6824,7 @@ int handle_ud(struct kvm_vcpu *vcpu)
>   	char sig[5]; /* ud2; .ascii "kvm" */
>   	struct x86_exception e;
>   
> -	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, NULL, 0)))
> +	if (unlikely(!kvm_can_emulate_insn(vcpu, emul_type, NULL, 0)))
>   		return 1;
>   
>   	if (force_emulation_prefix &&
> @@ -8193,7 +8200,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   	bool writeback = true;
>   	bool write_fault_to_spt;
>   
> -	if (unlikely(!static_call(kvm_x86_can_emulate_instruction)(vcpu, insn, insn_len)))
> +	if (unlikely(!kvm_can_emulate_insn(vcpu, emulation_type, insn, insn_len)))
>   		return 1;
>   
>   	vcpu->arch.l1tf_flush_l1d = true;

