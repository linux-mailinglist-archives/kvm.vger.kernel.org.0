Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBB1495294
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377069AbiATQrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:47:22 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60784 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233174AbiATQrW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 11:47:22 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFgc4E003007;
        Thu, 20 Jan 2022 16:46:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZJfbkB9unH+bs8o/iN12YzbI/44fJlynFPXxaSQU4NQ=;
 b=YqRRIbL0Exj5RFRsCBd2BgKZQ3lAgdGniYvMMBIeogbS6gacK89smA/lZhgADUuTan4X
 X3PrHeHBtvHWmYRus2/yl70+V/Y8lpHdP+9fwOmGXGmPvE9D9GC4Tupd96Co5iQ8Mhh0
 NkKIPSfF17YgpCskX09UF9+SgAxhRA43/W+6ENgl2rT1JNxaZkwugllgXL7Bh3GU09Ki
 af6nLUi5OqxLByW7xdY8LkcZigV3tWLSF9C5NgA5rW9r5oe9AX4tPHcrS6+dib4boi/v
 lJNG5sRe6H3gOuvVh7+nT79ADL2l0wEuL4trJXlQU/VmSWKM0miw1iL5NMz8pqoW6efT lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqam9g6qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:46:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KGeCgE070831;
        Thu, 20 Jan 2022 16:46:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3dkqqsqkvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:46:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWNR2m8k41hFizm0QnZXLiHMGaUiqCXMPX3ZQPLTdFgEdTuH775Yhe44rnnIRobxZigCxH8B9I9sYWmNq3uqn4VStOT3JuJcAZ/LzbGfPdSEg+d24vdunEsZYdG4+rgmi99T2EdTy+pXc2pq8pOGbOtyhFI0DOSZS3yiH5jXPGHeunQ6LwhA5PckkBGm4hboUBspEto09T/1ew6+cPvsLYXpbcUaVMnwTfrwO+P3epPadYsAr1wdMh+4iIeeribb+Yd+jt4Na7/R66iRw3d5FKP8RA0tmbGuWVgYPir/lRkcFBaz9RUgulSuC2A+7zPA5AcovfjoVYaC5SbrCkNF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJfbkB9unH+bs8o/iN12YzbI/44fJlynFPXxaSQU4NQ=;
 b=da124q05yPIfhak64F9YZkNpvifi94L+JJeMUWxWuGWgaI0BHFNNqN1kA3xMn5diKNc20frwG2+krTq9qNNy0AEGi024CDGYvEl4hAZl7S8cCZI8YOqzGhcP9vcnXJko4BNcPsFNJAYBRldQ9pRti83RzgUnHna9/EnpBVNTUalrnCDtuAklwE/C3Xsz802R6aqLSBPoZ8fAP7p7Pv+3/jByi+oaxYFEW+jEs0RTbZOiQHpWVanw+G61NlTHi7d1JqPFM7Vxq3bzRXqbs9BTK6B4fJJKGjbBK+9muEFbO0LOQ1o2AyTkoKPu/vRS/etGt0AauUsWKv0CotIFW3SygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJfbkB9unH+bs8o/iN12YzbI/44fJlynFPXxaSQU4NQ=;
 b=YeSwRyPdFI2ydaYQ5ryy1iQPQA8ArDkbmNT+Zj5qYQvYfw1979kclHUhI38E1cgNGMuUrWdVdjZ+4ISPGf0QEnPufU+koVk4N3vMDGfQ2EIyuwN8vuxWefAiszBB4swY9LjZrXOjLje3NFufP5ixGgrGoLsYzj7XN8mi2mJZGZo=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 DM6PR10MB3867.namprd10.prod.outlook.com (2603:10b6:5:1fe::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Thu, 20 Jan 2022 16:46:42 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 16:46:42 +0000
Message-ID: <7f55f8cb-caac-ab81-82f2-f0d29e4a0c6a@oracle.com>
Date:   Thu, 20 Jan 2022 16:46:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 9/9] KVM: SVM: Don't kill SEV guest if SMAP erratum
 triggers in usermode
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
 <20220120010719.711476-10-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-10-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0231.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::20) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98477578-f3dc-4202-bf73-08d9dc347015
X-MS-TrafficTypeDiagnostic: DM6PR10MB3867:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3867EBC71EFC4D61E2E4B80DE85A9@DM6PR10MB3867.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLorpMR7PF8iTZ2YgXYDBw1ml0Ycv8uFw0R7+nsCQJWrmZHGmJcUAD+8x4gBQW0cLwOC2kjynNUtafgrUWFGXJC4ciY23FxkqWhpBaPhN86xbFFe5ZlyO3yFxp8tDsY2heazVElPvTgRZwk/binBX+9h2qhwwzsfcVXrhI+I/rL3+fIfKFQAmfDtEipCwemO3UiMBGyfbbjN50aSukFFQyatVT8K6rxES4lZ8Fo0ak9DW+hViJs/qChurGgGb1Afa5cPJeUXkbe3TM0U2ZBfh66ClJ4qS2ILwBwhE0CRtWTRfN7WutrCeuVCHctPUgLfARWVL25ZgrQoGUZXHPau4VK/OEhNFiCpLSmdzfgkgyqhwMTkgdyQMIkFzMEzfEaa1mW0LpEIAAu+ZF/IIj+oLOGk7h4ijdxPAg+awg4bYo6N9iwjZZ9hPYqNEGAtYzEf6q/2Qd1H99EBN8Rf/DfdZIujGfccBfwzzFeuKi6KuSmbKHOlxVnmgO0WB1aslzUH4QZyqZ+ixCcs5HXL4Yhfsfm+8BDDjA2+u9o8G1R03lUoOXVyb+xGG2A+xVVzGvoPg0FMEbTOrW8JPsf79g+cCEQiRm3kdUDzsDENYtp34hlPNd1finYCLLRVus+BFzKLf+zvPvxHdlnvxsKCXqmoFA9tqflzW7bBFf0r8VcBv6b0IlAhLASiNvcCyhqJganveWzJ+jaSrAiCvEhWNAzFnVEUr6NbRHlsdtEm48TVv1bWGSUIwJqZSXhhqf2t8cNrOu96Q6W+6RYco3jfysrEFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(7416002)(31696002)(83380400001)(6666004)(107886003)(52116002)(8676002)(66476007)(66946007)(6486002)(6512007)(66556008)(316002)(44832011)(5660300002)(2616005)(36756003)(186003)(38100700002)(53546011)(26005)(31686004)(38350700002)(4326008)(2906002)(8936002)(54906003)(110136005)(6506007)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3BEWmFUSEowUmR6d3gySWFVSy9nUmJIM0VTWkJmZUQ0SFhnSzZGeWlqYmc5?=
 =?utf-8?B?bldWVkpGaWpEZ090Vi9XRDBCUmZZaVh0dTd1dnZVcElaTm45RDV2Mnl1Vklw?=
 =?utf-8?B?YytGWll0UFdzOXIzZm9KaXZxZVpXQUQ0OC9JNUpWcUFJenFrbDBjbnJoQVh3?=
 =?utf-8?B?VnRsc3FORk4vcy9PMDM2eUdFaXU4SmRlRmRVNlZEdkg2c0RqUElCNk9zamtq?=
 =?utf-8?B?a1hiZ01sb1JxWkVaUFJuQXpRQmR3Yzczb3dXOS9sY0RxTDJndVV6Mlpnakty?=
 =?utf-8?B?MTl6dkh1Z0xGVmVZY2sxMG5FVnZIK2JEVktkRWd6U2RycFgyTFRUemRKdzBl?=
 =?utf-8?B?ODE2aVVwVWw1V1hxWUZlNEdVTUtTeGpwbG9EU1hRNndtbnA4Rk41M2F3VmpN?=
 =?utf-8?B?eWd0bDV6Rm5pM0gyREdLbmhYTzhjUjNDRlYyRURBTVRvcXo1K1hKNFFwUDRr?=
 =?utf-8?B?VCtIQnU5S1Z4ZTIwUG1sWk8vM3dJQ3pSb210K0tkYXljYktRbTlZaUMwZHpR?=
 =?utf-8?B?V21UZTlPUGh4SmVtT2V5aU9aNmE3ck1rVktMdWUrMDU5QWRycEQ5WWl4NEI0?=
 =?utf-8?B?clh2V2VCU2hnbTNGWUVaU2xVNnJLUHgrbzlFTHA0Zk1GK3dEMVFleE11VTNz?=
 =?utf-8?B?aFZHUEhUV3hkNGFEWHZjbFpKZmx5Z1BldDdCa21vYm0xZlMweWt3TTdTRXJy?=
 =?utf-8?B?UmdqQWhVU2kzZjd5bXo1RURVNjBwVE9pd3FTR2xtMEJKOEJFYjJzUTVVN0xn?=
 =?utf-8?B?QlZQemluUmJUVS9LZDJDdEtZSGV1Sm0rZFdaRTlGVFdrNVJVYnRkSEgvQkg3?=
 =?utf-8?B?OTk4MEtxVjJEUW54M0FxS1krUGFndU5QT1U5TjZRQzkyM2ZQWmVoWlJNVHEy?=
 =?utf-8?B?TmVXQ1FmYjNRMnhrMGhkZXFUUTdneEo1U202S3lRQmRSUy9nbzM1YXh2bTE2?=
 =?utf-8?B?WWVIUXJyc1R6NzdkZkI1OVZBSVE5UnZzWU1EVzZUZHBjeG4vWkZvL2M5VTZQ?=
 =?utf-8?B?YVBXTU9tUllHK0k4VE0zTkhKUkdkdmlCRnZWL1Jpa1ZaNGN0aEs4a0podFFu?=
 =?utf-8?B?TU4wT3BtbkhKaDBqaDNpclRkY1BQWW45YjlSQXdHbXgvY2VyM3BDRXVjdGEy?=
 =?utf-8?B?V1czNW50T1Q5ZGhFSDRHazRnS05BeDV3ZWRxUG01NnRhY3NjN09tMDk4Yk95?=
 =?utf-8?B?Qy9tZU4wVXBZbUFJWkVtOHUwbzRwL3U5UG5jZ2RFMkhYVEtITnJpanNXUGNQ?=
 =?utf-8?B?YzdlcEVVNlBsS3NGTU9Mdk8weUVVTUxyQ1JKUWZ4U2ZSZ0FJSEZiaXM2MFlu?=
 =?utf-8?B?OTFaQ00vcGg1V1JGQ2JMd1BZWlZsdTVBQ1ZwTlUwZ0dGYUl0OHlXckdLaHBR?=
 =?utf-8?B?ZE9qNUkvc3VhV3p0THZkajVuZUFOekwwM0Zyb1RVRUlXK3JmcFRxR1RRM0hp?=
 =?utf-8?B?OHhtZFhEOVgxaGZiK3JocXFZRXRvNnJReHJZMU4xd2x0akpIVlFGQkpNYmp5?=
 =?utf-8?B?eWZ1RFBHWi9MajRTVC9wS01EakprNUNlZkRXalY5ZnNBNjZ0eFZzajFsd01F?=
 =?utf-8?B?RFVtRXhLNzhlS1lLNmxSVzJCWGtKUVBUYkVHVXZCQTIxMks5WHVZeUgvK2dR?=
 =?utf-8?B?L0ZUOXVmWXVmZUljVHcrMnJBaWJrMUpHVXNNSmR3QWZxK2xpYzR0OTVpV21E?=
 =?utf-8?B?YTl4WjlIVTVBYVpPT1JpVWJzaUlyUXdyZ3FOZmhqd1c3QkhCMHRxaHdTZFJB?=
 =?utf-8?B?K2pJRWsySWNNNG5BbEFyT0JLdk1EZnBwVlJNdDlwYlBCSGs1c05oKzlSRkhk?=
 =?utf-8?B?MWczUUVIeEc4VXl2c2N4OWQyd0U5bWhPRFZxRzlVMHVKbEFsT016cC9iekhw?=
 =?utf-8?B?MkZVVDY4L2gyV2hES0NpRUQvN3FlcWdieEM5Q1l4S2pkL09zZ0ltanJDNUJO?=
 =?utf-8?B?aGdYQ2o3YUFzNDBTUDh1RWRzajkrRDkyNzBuUlJ0YkZPRkNWc3pyd1hyVDNa?=
 =?utf-8?B?aWpVT0R5SVQ4Y1AwOE9jRFVQWUY0Mlo1WjVsbmFwa0NObStPWnNSMkZPaVV5?=
 =?utf-8?B?WnVtdHU1WHJKeEFVanA4WTc4bWlUdEZrS0hpMGRpeW5PNXBiV2hYR2h4TWtX?=
 =?utf-8?B?dmJyYzV1N08zMVlSekJNQmhRRnR2YW9SL0tGbllFbklOZVFlSTgvVFcrVTQw?=
 =?utf-8?Q?1lrUks0WLgm4ByivOUE0t2c=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98477578-f3dc-4202-bf73-08d9dc347015
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:46:42.8394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pa2ckOEg2uLGfo3hCWWLbzXk0DqOBvoQ7SsIBf9bZl2gjGV6nEj92Nl04/zstaBKNO2i0IYPZGleLr9rTUA/6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3867
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200085
X-Proofpoint-ORIG-GUID: y0F08YyB7zA7sg34oTHQ0rN7yNfPfEWQ
X-Proofpoint-GUID: y0F08YyB7zA7sg34oTHQ0rN7yNfPfEWQ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Inject a #GP instead of synthesizing triple fault to try to avoid killing
> the guest if emulation of an SEV guest fails due to encountering the SMAP
> erratum.  The injected #GP may still be fatal to the guest, e.g. if the
> userspace process is providing critical functionality, but KVM should
> make every attempt to keep the guest alive.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a4b02a6217fd..88f5bbb0e6a1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4357,7 +4357,21 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   	is_user = svm_get_cpl(vcpu) == 3;
>   	if (smap && (!smep || is_user)) {
>   		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
> -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
> +		/*
> +		 * If the fault occurred in userspace, arbitrarily inject #GP
> +		 * to avoid killing the guest and to hopefully avoid confusing
> +		 * the guest kernel too much, e.g. injecting #PF would not be
> +		 * coherent with respect to the guest's page tables.  Request
> +		 * triple fault if the fault occurred in the kernel as there's
> +		 * no fault that KVM can inject without confusing the guest.
> +		 * In practice, the triple fault is moot as no sane SEV kernel
> +		 * will execute from user memory while also running with SMAP=1.
> +		 */
> +		if (is_user)
> +			kvm_inject_gp(vcpu, 0);
> +		else
> +			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>   	}
>   
>   resume_guest:

