Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E7494FF7
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343654AbiATOSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 09:18:16 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24248 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229657AbiATOSM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 09:18:12 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KDEJxG032605;
        Thu, 20 Jan 2022 14:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7vANypFO1hbtSTKiZQyXSaA+hUSHaMV88zbJzMlYgjA=;
 b=FCC/6J+Ui6cBAl+jGkG365rG7PUZ0fq9cTkLb+rk5nTL6tz8/hpBCrvtQZDR4EE1hGS2
 SPYRRrItE6tK6qg2jUuZ4pn2/4SKuxwIQGkpleT4VeKiy8whLo64MvzzwV/asNR2JLxr
 Ou67su5RRl/N3VWtWx4t/4h+9mDEfv2BWBIIr+APKrmV+R8XyGXhk0ukXEoSRiQkbOoe
 Ajif1Q9TGlrIWu5QwJuf7eduzal4dSUajSDlrx5xqU90fQY/kHrGEVd4UPXa17yuI93l
 duQVQWVR/1Ox/Nw3sT8+cK7CF4tAFr2/SXRHNxPnYomhHSB39ZDMUhOzCzAiQMtPeuvJ nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4q8guy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:17:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KEAUxo121187;
        Thu, 20 Jan 2022 14:17:27 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by aserp3020.oracle.com with ESMTP id 3dkp37pkcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:17:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldkTQj1M6ZCQOQjRkrl4N+J/JLeBygbwUjgm7iUUKCjYMebTYjJKr141/ttECXtpQe7pE7tD2SuaPjmDyy9G4mZBAxsZzzZ4STzC6Pm8PoJrXoAaina0TLQVBW3wUOEZcsnjsEFqIV6X/KUu/Ng8rD39Ov/GMZtUCPA6fq3iO1+1eg5cmSkZ67a0p80ew7wqpd8AaILMiXWPtLHvmvIh1g6nAn5ngF48UEHqiRjauDjw91VJW6upeUwZR3LmKSGND/DyiNsjfmm80d6aNR72z/tbKRNUOrW6I19aspdmWAvTXBu2yaoJMvYHIh6r4YlfDsv9UriNqKpjWln0M02U5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vANypFO1hbtSTKiZQyXSaA+hUSHaMV88zbJzMlYgjA=;
 b=Mxo5sbHq79mJT/CoxhZ4b+lICQj/5jKr5z8B6TOsSImeY7ppwgJZc+cHvEHAUdu5o92R4nThUcVUjbXA9XJdsdr9ksJ56yAAiL0NhBw8dcbynsAmbyHegbpssKs/7Ku79o227acz7ScFCdktCeUYx98RlPsEGGrres/1Y1crYDS1p/La/4zMffXfS7Pkml5OmP7PlQuEaBxqjtDnFrafKr8GVPCKgm6QrRRSSwOM4BGMnwgiq7CNlkeLudnRkSwcKBbhBPg1pqClc08m8CW0lC6MD5hTgErpwwBnYZmLAdXsBX/E/bNJIXvQJRuBQfMyC65EA04VnAcE864X+YFaPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vANypFO1hbtSTKiZQyXSaA+hUSHaMV88zbJzMlYgjA=;
 b=xslY0IqY5JIf9grOt/TtK1OC8H9vCJBrwoquOQRUO0JaxL6NCvnW+cMmf2PnIp1FirKyKHSOySL3Xu3QBEVHf8UgKtcpQCzTCr48HpacxTnxFYoG3gtvxQeQ5qk/W9k2o2koZt2IlXXFL07Pzx839yEKMmsMqBar4EDntBxs7UA=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 SN6PR10MB2781.namprd10.prod.outlook.com (2603:10b6:805:d4::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Thu, 20 Jan 2022 14:17:25 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 14:17:25 +0000
Message-ID: <9752a433-5a48-3139-0e3e-40bb73d31ec4@oracle.com>
Date:   Thu, 20 Jan 2022 14:17:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/9] Revert "KVM: SVM: avoid infinite loop on NPF from bad
 address"
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20220120010719.711476-1-seanjc@google.com>
 <20220120010719.711476-3-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P192CA0022.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::27) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58df1784-4ed4-4ccc-c987-08d9dc1f950d
X-MS-TrafficTypeDiagnostic: SN6PR10MB2781:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2781B30F9F6DB2E8197D6F01E85A9@SN6PR10MB2781.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHxKph7xLe3dXHf4Evkcc3L96BWtYqVr6qmyq5ujzNzMF9uG6utf1OHanvgcG66U0TD8H4R00PgQoeIFNgP5/mrgXx5KAkV966ptEkxhW69GkjJcKHi23HgAFn0hLUl6ecLo5efSgElGxh6Us7vg1RfRHFPldn3Wu72q5bOpLKW8lOH/+20kFnhXXYFkazxTMhRj1MvOXU2bQsnIHXjcX1GY6dWd5gyqd9Jwe6fOv5DtB1Q3Ve4fB5f5hje/AZMVLJzKJNeHLG/kdmAEPt9sE1VPC9ta4L3nsib3EtjDQP+/DDATTpNuSA/siRg+GI+f56DmFzoYD5pA/9XcuMEcw5ICALoBSQKsH5mS0wtfdOzYlCSqA9f09d2/ZD0hTSFHk/E0XMaDFDHhML4je7/stLr/gDKh4rxf4O0iCVSzV0+KlPcNOyv9lB2rcCLNMaq+DvQizEJL/jZM66Sm+7Sm+AvM692S9pL8gIoJNPgluLaKtjvOUX9FM+6PzTq0hxePr2fjk05h6Qtcen1cmNscI5Qo36du1JjSONO08WbxdJyyxNgVMsSg0R5OUdZbsqhHr+bkYL5SslNSubly7q5sWiiBfdCVi3syKDur0o8dnDY6TB5qed15ATH5FVmTE9gIErhDhZ+WZkQADlzkUOGNQskAp0EHdfw3YR2iYU1F8vMy2CiKcbv41XOcHbMmcQ0Ty1A5xXFRlrRnIRRfAPHwj7AGVeueSZ6dAem9xP0hk0sRp8yec8r8BJBnr4+gzommfLvfmaW0nM/fRcnzwydWvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66476007)(6486002)(6666004)(86362001)(83380400001)(44832011)(8676002)(31696002)(6512007)(66556008)(4326008)(66946007)(2616005)(36756003)(8936002)(53546011)(38100700002)(508600001)(5660300002)(6506007)(38350700002)(2906002)(31686004)(186003)(7416002)(26005)(54906003)(52116002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXNIQWg2cDIwTnZVTzlRblViamI5clZ2WTZ3MFJPbjFXSTF6MzFFY2JEcEJE?=
 =?utf-8?B?YWI4UEx3MFl2dTBNcW9yQit1NDVYMDRPRUVxVllqaDNGOGtaOVhxNzlqeDZu?=
 =?utf-8?B?TU9xZ2ltdTRmY3RLMnorVHlvQjhrMkIzbFRyYjgvUTRLUDJyZ3JTeG9DTVNR?=
 =?utf-8?B?NmQrOGNyYk5nVTdoOGpSV0VYdStrYUl5eFF6aUlkRnhMb2pwS2c2d1dnTVAy?=
 =?utf-8?B?NThDenA2Z2VBVWUwVlRTRFVYT3dVRzNyM3ZNNXV6Smh6OE51aU1pQUhNamtU?=
 =?utf-8?B?eXZYTEd4RGY4c3RWR2VoVGNhdHJWeXVyYTQ5aXJDYzhnYVpRUWFtWUlRY2J6?=
 =?utf-8?B?cFA5UVNjOWpPSktDbEY0citsR2FDQ1oyM0tOamV6ZUhNOVNXd0VyaFg5cFBt?=
 =?utf-8?B?c3d2MENrbzZhbmRvUGF4ODJPbi9EUG41NzB6ZXcvMlF3WjlVSUZwOFpKeHlk?=
 =?utf-8?B?QlFONStrenNIY1UzVkdNcmhvOE9xQkczTDZZWWlYYXJsREtUSEp5aUZReFdr?=
 =?utf-8?B?UzI2ZitYWXM0ZkEvUmR3M1dnNWN3RnZneUdFd3lvbFVqenlwUWRtN1MvZTYx?=
 =?utf-8?B?QXVhRm5WMzNRQVNSdXFETk5zcjhjMmxiL1QvOFAvUXJrbDh0enBqU2NGc01q?=
 =?utf-8?B?ZjdpZGdLaG9wcTlyNGhUd2hURW5WNGhLdEhacW5sUzB4azZRanRCUUM3a0NG?=
 =?utf-8?B?WGM3TnBIbkt4TWVMamdlRDhEWGdBM0ZhLzdyUlZWYjc5Uk1YZ205YzBYVjJT?=
 =?utf-8?B?dGg4ajRsZGtiMVBXd3R0UGM1U1c4OG5yYjIySUQveEFqTHBFOVlEMmtOTmhi?=
 =?utf-8?B?ZUJ0QzA4S05lT3NDeTNCalgwZitmVDRKeXhwLzRlbENIU1BFdEpaNDBsSDdD?=
 =?utf-8?B?VDBKOUxUN2RxQVVlV2owUFpTQmJQblllYkVuays2QXpqeEE0NjdqViswSzdE?=
 =?utf-8?B?VXArM3RGbnlWWE1aak83L2J6bWNnRURyUmVxbHp4SEREMHlmVGVtcWIvalJU?=
 =?utf-8?B?Q0Npb2JSVjZpWUgramY0UllkZFV4NFA4UVNSK1dkbjBrWnJKNlErOFBxaFBH?=
 =?utf-8?B?NUszcmNmemxSYnhJN3p2T0pXUFIyRVEwMkpXeHRGcUhqY2VsUE50aC93d1RC?=
 =?utf-8?B?eUZSTTJ5N0x5R3lHT1l4UFZYS1Q1SjhtNzcvbDBuMU1mSFI4Y3pBKzQ2SkJu?=
 =?utf-8?B?Q2lYTEV2NjJnQkJwejVqWFI5RW1YWXRUOXRYczdvdTd5cnhJNFBIc0RMYW0y?=
 =?utf-8?B?ZnRnUjh1WUp3RVorSmd6WUFUTE1CS1NVMy9qQnU4S3lxNXNBc09uNXV3ZE1o?=
 =?utf-8?B?YTBOM201SWgwWU9JUXpacEhPd0ZqS2U5bCtseTM1aTN5cHUwTDN1YTRMQ3NP?=
 =?utf-8?B?ZlEvb3V6WUY3K0d3bWRnL2lPU0ZjUkk1UUlwUVRKcEJWRHJhSmhrbnlIcGFx?=
 =?utf-8?B?SmNZSmtUUTI4cXhGRlRkbGRTV3AzcEFEOEFYcmM0WUxwWUlxcEZVczUzbzk3?=
 =?utf-8?B?MWdMcTY1Mko1bW9lRjBxREVBZ3U5R3BrTnprbHRaL2hsTnhRanhtMTNkZkJT?=
 =?utf-8?B?bHJuczAxbnk3bUFiUlRnUHU5Rm5iaFhISUs2N3RhT0QyZVhuUnY2MWZSRFVN?=
 =?utf-8?B?LzRtSWRZcFcvK3ZaN0ZOZnd5ZHArcUN1bjg1Z21YcFdOZm1CRkJEcG8xdER2?=
 =?utf-8?B?NnRJVFlWaFZsV3d0M3cwcE9WN2JNYkxqc2pudFdWdmtZQjQxWmllSHBxSUFn?=
 =?utf-8?B?bFRUdlBUa3g4MU14cmdYYWVWaWpKWlZxYWtMQ3I0a0RCQTQ3REJwMzNaN09w?=
 =?utf-8?B?ak4wOEVEcTRicFJaV28rS1NGL3NiZXlDdWlWdlVGNUhrL1hvN09vZTM0eWtP?=
 =?utf-8?B?ZjRqbHZ3VXdacmR4RjUyYWNUYkh3RXZrc1hScjU3czgwYVFGMXBqNTAvY0wx?=
 =?utf-8?B?S1VJREszeEtpY2VCRmRzcTBsUVVrcDV6Y0E5UTlybU9LbWxjSUpwb2l1bHhn?=
 =?utf-8?B?TFd6dkMvRFovczhaVHp1VVllZGQrdGJpRC9rNTRDeW1RK1VPblI5a1ExSWZs?=
 =?utf-8?B?UGk1bldNb1A4akw4ZmtnSEtMYlFoVDN4L2taQ09sR0hCMGhaVFcrVVRLSThP?=
 =?utf-8?B?U0psT0V3dFQ3WEhrRWcwandDbDh2V2xhK2ZOcEJMTWF0UUE1c3VWL1QrNHFO?=
 =?utf-8?Q?3OohORjBUbIvIiXA61GNjhU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58df1784-4ed4-4ccc-c987-08d9dc1f950d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 14:17:25.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+5WKVYtp4s2FSr5+byLvm9tIOPtKBvxk/AAQcNuLJgC9dgpvtEj6855ZOfjKfPyWt+qXzkGuJEivVH4y3N/pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2781
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200075
X-Proofpoint-GUID: ZwL1CuDrFu4wcvzXuq4oLkY4p3XGYaLc
X-Proofpoint-ORIG-GUID: ZwL1CuDrFu4wcvzXuq4oLkY4p3XGYaLc
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Revert a completely broken check on an "invalid" RIP in SVM's workaround
> for the DecodeAssists SMAP errata.  kvm_vcpu_gfn_to_memslot() obviously
> expects a gfn, i.e. operates in the guest physical address space, whereas
> RIP is a virtual (not even linear) address.  The "fix" worked for the
> problematic KVM selftest because the test identity mapped RIP.
> 
> Fully revert the hack instead of trying to translate RIP to a GPA, as the
> non-SEV case is now handled earlier, and KVM cannot access guest page
> tables to translate RIP.
> 
> This reverts commit e72436bc3a5206f95bb384e741154166ddb3202e.
> 
> Fixes: e72436bc3a52 ("KVM: SVM: avoid infinite loop on NPF from bad address")
> Reported-by: Liam Merwick <liam.merwick@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   arch/x86/kvm/svm/svm.c | 7 -------
>   virt/kvm/kvm_main.c    | 1 -
>   2 files changed, 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index aa1649b8cd8f..85703145eb0a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4311,13 +4311,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	if (likely(!insn || insn_len))
>   		return true;
>   
> -	/*
> -	 * If RIP is invalid, go ahead with emulation which will cause an
> -	 * internal error exit.
> -	 */
> -	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> -		return true;
> -
>   	cr4 = kvm_read_cr4(vcpu);
>   	smep = cr4 & X86_CR4_SMEP;
>   	smap = cr4 & X86_CR4_SMAP;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 5a1164483e6c..0bacecda79cf 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2248,7 +2248,6 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>   
>   	return NULL;
>   }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>   
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>   {

