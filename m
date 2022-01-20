Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE28494FEE
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 15:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345355AbiATORM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 09:17:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26614 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229657AbiATORK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 09:17:10 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KDKDlQ010647;
        Thu, 20 Jan 2022 14:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=x6TtlcxyczkzShy6FS0BD1UySzG5KjJqoXtMSyCd0C0=;
 b=kUFBLuDBgfrjW2DOHiFy03H+3bru811eRrR/krqcs00ruLoF7yA8DaXnxzMcqMhiCLQi
 E331BVp8R+u8W28dAQlLXMlgdKjD4txLDQkRSlofEShc9l6E5E7/AvWKwu+t0VFpJa+4
 HhXllu89cTmJTSI7kZr3h54v+ZZHuUPckxp6BLZZKGuPApp+Dlz5Pn99sKOCHR86etuE
 yn9y1d8oSZKeA94CrAAXXI8gKYt4g2tiW+L73B7Z4j9IezxBcJ1E0RKQVchoW/8m9+SQ
 r3dRqZykb0bEPqVpC2MEk9lDQ4yCmuIjfYbJjqTkMt7KRywJ4Igm3zPVUCvVa1hbH0Kb 8w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc530ehn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:16:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KEAgVs177624;
        Thu, 20 Jan 2022 14:16:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by userp3030.oracle.com with ESMTP id 3dkkd2bpfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:16:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIFDDn/RTipjajI5uQ1Den72UDc54LoS+NJUNBbQVSHAc1vmZWNlxelxqoCybeGJgdFrRvPwhBWvtFWhhJ7PsmHgf/PPO+AWpnGxWU5aJphZk+awdYFhPvOB19j6fmO7B/EnXXFE02OmuguyNxxrpHskp0xCYwdj0OhcPd3uLMd9gpSpuWm2BG/SkRbPugacAjM8nvguCI/H48oXtt/DfHeGBl9uq8JeStkvfqsXVXQQYB4IbLXWUpsyPFY3ubkW5J4W8JXlrxtNT/zKPXtuJR81Idfc1rNoyHuxcfYM4dWfbs/lJ7y5QsCTmYpBtj5sM1tWSImDRi0ge87UJBpnPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x6TtlcxyczkzShy6FS0BD1UySzG5KjJqoXtMSyCd0C0=;
 b=ioMyfbZnJzjzSbfwjPPB8zOMeFisvKV4+mtka8P6Dl62b74DMqB14l68MQVRXyUiSTlc37vLqWfTCMR60dd4AcFy0oDRDFbY6xN2MAmh5T83nMk1KBTCfdzd32KpKhHKqjqUdaxJ4WiO+hUlVyV63pmPcj+IPKh3w3hhaCAVq0v0cs3DyKzWyQW6NrpIPEpa8nx/AQroOU7pLaV8VpX+tTygF//+rxd1sl7ClVvAvMg41x4tp0nYUC5u5IuLW6+Jh6M1TYADwf5ZY3lX8d8fY07a3It/OzG2iZzhMTZUnF4UqclBSFkdla+IxRz0u1IATWX1OqUEFbkdr0nqjARVvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6TtlcxyczkzShy6FS0BD1UySzG5KjJqoXtMSyCd0C0=;
 b=PukMDc2YYeL8A7pP87SHbYvLgw90hbqk4mHyiaciTlUlWSzTNqCyUR2DKI9lTfNzEBLcwMMrENE5cf5LLRgHlkHwCEF6XwCV2kCPb4fix1R7Qb/lzrIrVjWA+a93F0dIETUFFkhkxU/7Y8zcHiNU+uWrl2DpMipbFIFFhaLaAIY=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 SJ0PR10MB4576.namprd10.prod.outlook.com (2603:10b6:a03:2ae::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Thu, 20 Jan 2022 14:16:30 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 14:16:30 +0000
Message-ID: <a70550d3-65fd-03ca-f342-a4f203d62163@oracle.com>
Date:   Thu, 20 Jan 2022 14:16:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/9] KVM: SVM: Never reject emulation due to SMAP errata
 for !SEV guests
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
 <20220120010719.711476-2-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::25) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fe1ad53-409c-422a-5564-08d9dc1f7455
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4576:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4576C1B48FBFF722313A6D34E85A9@SJ0PR10MB4576.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mf4GfyuPrj4DnmEaZwW0Fa3SaFws4Q6uk1TzVhFXtBgRY8lrruIirvJ+Gy4DcFpwSPjfPDDSF9wiMBaVqpzdiCK84a5Mif8v+labaoWFWYknAHGPDMaMdDj4XQIprcpkjDvL9nfb925Cy+VI9R1cyxuzDdBtOGgVSJSugU4AgOu+729AotFxnm1yyP0R6wawddAqEft7uEx3nVY5xQEhU4NAXLKg9/dKD3kDfIdqdfGFtT407Wj3/XSYZQ4wQ9oxNnFagV3KCCto9eJqkKxkkRJ+8K9gJfqFmcGjkRsHiXQ04Od3QR0TBW2Bloyozp5fdky1CPDqMSn/xWgdE++6Xz9BEM8fcqr41IAGDFAnrOm9yd5dnStA6A331U+XBf4awXsn7NnLDTzxoaxGUGWpswtNFqhnEAPyNUFNL1Qg+s9oRn/gqOFTaets0AxE9VaXH1e2+l27uTUlhNLfjEhx+LMkmrM8btby9qaxWel8w1OyfOHQmXvqV8BG1Ez+IFMhZvu8FgFyJdIYlMPMs/lfkkfbkSaDbRJycW4dGSMoQ07/ZCfp7PqOW1TW/elDc81ZlCpXdNz/Ynr1Md3Y7gF76HrQeCRDNgEZ7PXab4gJ3KRdNYg1BfrE7BsoJ+VLqeyo2Xn9BvNyNFPSTHW/+Ki+POr/Tbq2L82KIiAQEXojcOmV0AO4w2DCqgqKRUDpPp2aLAYFhLHgnwcxpa+3Uzt0i7iFlHRSw4Xx0+RRVp1Mw2Rij1tcg8RGn7GBnVytkWLE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(38350700002)(6486002)(52116002)(186003)(2616005)(36756003)(107886003)(6666004)(316002)(66476007)(7416002)(2906002)(53546011)(86362001)(38100700002)(6506007)(8936002)(31686004)(5660300002)(26005)(31696002)(8676002)(66946007)(83380400001)(6512007)(44832011)(508600001)(4326008)(66556008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1Q1bEN4WWhETWs0VEt4ZnE0VzU0aFU0bmdoWC85eUQ5MUxTNTNRamNjY2xs?=
 =?utf-8?B?elVmNGxvNEphQkJtbkxudVlUNXY0QW5tcXN4a0gwWFEvMCtKTmtpUE1CVXRz?=
 =?utf-8?B?eFVNWko4T1FGdWh0Kzlod0MrNTY5WEdrRTNrWE5sOW00bE9GYkJvVTFJRlBK?=
 =?utf-8?B?Z2JiTFZZWUF5Y3NEblhVd0ZSdGlqVFpLM1dxVFo2VFZJbVp2Y3RZdXM4YTBq?=
 =?utf-8?B?aUlzdHpVODhFVFRFV0g1eTVyakZBNG5LemRZcHFMbDBxa2tqci8xQjBiMEJq?=
 =?utf-8?B?U2FrenBWTjZwa0dtcno3ZjlQeUdHUHRhSHhRUE9DU01CVVk2U1R5Wi93alNP?=
 =?utf-8?B?cm5vaHZvbGhFWmFzclNMQ0dHblN0YUl2ZmluRnpyUDRUZUZEczhheStXT3p4?=
 =?utf-8?B?WU5TZ0VuZThRcDkwTmJQQmRrazFnQnV6a3V0WEZsS2xJU3kyVzhzQTdyMzlP?=
 =?utf-8?B?bitWZS9LRGVodlVCeXdUcHN0cGUwbUlCeXN4WFFZRGRucjdQRlFRR3JMU0M0?=
 =?utf-8?B?Y0FOaTJuQUFTcU9hU3RTMlZGQU5pcTRYRjFqcHZvdXlDUGlYY0IzTE1FQmJ5?=
 =?utf-8?B?aGJkUy85QU5Ec3FrbWNUcEJFaUg0QUhsTEd4ZWtVVmoxZmZkdXJyYXRpWkVQ?=
 =?utf-8?B?ZUlyd1NWckZuRTBoQlUyN2FPZUN2M1U3Y2hVSWx4ZFlKeUxoYnZxMHNaVkNv?=
 =?utf-8?B?Tmd5QW9DMUdROFdKWlA0QzBDak51V2FESzZYUW9TY1BUdWpkTXo5OWlFWDBZ?=
 =?utf-8?B?am42NlAvNG5UazN2OEJmYjVTSFNMelU5aC8wSFNlQXFDdVRQS3lIQWtUMFZF?=
 =?utf-8?B?LzVTNmtqMU5rZzZzZ2JTTDBMQWh1bHZENysrdmMvOTBXeVZzQ00rV0hmVi9N?=
 =?utf-8?B?NnJKVHVZemFBUUJHVXEvYVZyendlQ2tjUHVMaXlDRlA3dVFTZ3dNNnMyQk4w?=
 =?utf-8?B?SEdpd0pOQ1FkZ0VWOWozSVEyd05rVVVpamtSekoveVVKYzkyN0IrK3RlMzZG?=
 =?utf-8?B?T3E0Y0hOVGdHMWRhSXpVNzE4d1pRTFE5WnFWSytVNVZzZmcwcWVYcXdXNGlq?=
 =?utf-8?B?OWEwLzl2TUQ3WkxrUldYMTZrKzVWWG90VUNQUEtnZXZ2NmF0blZRcDBvMS9y?=
 =?utf-8?B?VjY3MUc4dVdocUZLN0dSVnk5VlF4VlUwK29Ed0UvcmwycWtOeVhVYzRWNjht?=
 =?utf-8?B?ajNuK0RkdlM5RXY0dmNiSmI1MnJnM0ZYU0Mwb3V6NU03R1QyVmhqaEphOVBB?=
 =?utf-8?B?QWk3eVFlZGlVVjgrSCtjVjlvMzYxRHUzMmg1WDc0VDZsL3ZHYWZJWGhrcmlE?=
 =?utf-8?B?VXFiZ1VTREhzZzl4VkpvVEJkVDJOTHFVa1Zwc01QQnNnL0Nmbi96R09BSDdk?=
 =?utf-8?B?K1pZL1EvNXlaSENYVjNnaGxrK3lvaUd1UnM4aDBVSkY2YUU2VUxzYWNsNjFv?=
 =?utf-8?B?RjB5S3lqbjdyZXRsbTJnR2QxamtZYWQ5OUpyT1FaSFFpd2hzVVBuN1lzTWVj?=
 =?utf-8?B?aXBzcklTcUp0TFVhY2MzblhjbUxuRlMzT3hoLzhPaU1XdUQ4Q3QwdVVHT1dn?=
 =?utf-8?B?bkg5Y2d4WGRjSGtvcEUwMUdUbkpDR1RsM1V2eCtzek1qYkZaQW94UlZoY045?=
 =?utf-8?B?UUNRUVIzZkFkQVpRYS9Rck14enQrU24vMm9OSmx2ZGpqTzJRN0IzZnRuVzA2?=
 =?utf-8?B?bTB6bldoSVlHcDNrZUc1ZG1oR0ZKQTNQOElraGZVYTkxdVZFbEhydUgyN0Vj?=
 =?utf-8?B?eDNSWGJjVkhZT0h2Q2lCUUR5NGtFK0VWbmdXaTVTOThwK3N6ajFNRitMMkRK?=
 =?utf-8?B?ZU4yK2Y5VFlxaERWa1RFemRrdnJONGJwdGpITy9RdjZ0dEVValduRUttRWNB?=
 =?utf-8?B?Mjdvb2pzMTdTaDluSHQwejdndWFGYU9TMzc3R0h5SGVRVm56bEJCNERxYTZw?=
 =?utf-8?B?clNWUTV5ZnBTMy9IYTJRYlF2R2N0MjJsUTB5NkNnMFRkaC9RaG1ydXJEeTBO?=
 =?utf-8?B?K05lMTZjbnk1UitRQWlVMEZlTGVCeGY5czlySm5XaWVnMStyTVhEY0wyK1d4?=
 =?utf-8?B?MWdBK0w3MW1tN3VpcmphOUprZlJ6NEp1d2FoYWFCTzBkbW9tSnprUGIzWWRV?=
 =?utf-8?B?SmZWQ2NCTGhyRjA2RGxpQ2VBN3BpWG9KUTc0R0NLYUMwNEM0OE91dTc0aENE?=
 =?utf-8?Q?2kfXEANdg9VZ37JG5zZa9LQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe1ad53-409c-422a-5564-08d9dc1f7455
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 14:16:30.5981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UkNthxO+o0Mvw5L6eeSe/vYQkDm3u4JoTmcACAVYf78xz9w+swT4OyNtbfa54Qg7Ts+RI0OIVsfItVxW8lkxwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4576
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200075
X-Proofpoint-GUID: i3SonwktJtemWhL3MmzAGRDwknluoWGA
X-Proofpoint-ORIG-GUID: i3SonwktJtemWhL3MmzAGRDwknluoWGA
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Always signal that emulation is possible for !SEV guests regardless of
> whether or not the CPU provided a valid instruction byte stream.  KVM can
> read all guest state (memory and registers) for !SEV guests, i.e. can
> fetch the code stream from memory even if the CPU failed to do so because
> of the SMAP errata.
> 
> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 6d31d357a83b..aa1649b8cd8f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4257,8 +4257,13 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	bool smep, smap, is_user;
>   	unsigned long cr4;
>   
> +	/* Emulation is always possible when KVM has access to all guest state. */
> +	if (!sev_guest(vcpu->kvm))
> +		return true;
> +
>   	/*
> -	 * When the guest is an SEV-ES guest, emulation is not possible.
> +	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
> +	 * to guest register state.
>   	 */
>   	if (sev_es_guest(vcpu->kvm))
>   		return false;
> @@ -4318,9 +4323,6 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int i
>   	smap = cr4 & X86_CR4_SMAP;
>   	is_user = svm_get_cpl(vcpu) == 3;
>   	if (smap && (!smep || is_user)) {
> -		if (!sev_guest(vcpu->kvm))
> -			return true;
> -
>   		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
>   		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   	}

