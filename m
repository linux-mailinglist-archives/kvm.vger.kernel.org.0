Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0044702D5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 15:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242175AbhLJObc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 09:31:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11038 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238667AbhLJObb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 09:31:31 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAE8cMc002191;
        Fri, 10 Dec 2021 14:27:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8uaT/HvlykQi87nugbQ+BiLnzAdXPi/C1zdlgbAy9Ao=;
 b=cfSuo4T7OrqUgiHIhtVjNIWufX98mUmdPJXXxmDu70vNzL0NyIYlWZUIlVTb3qrzm1/S
 5zBvnU6Yx/SKksW4f6rfdbxLni6p+QBIGjxG/0r1w/pLgLSucDdtYqgzDd7VV4II0RDQ
 kH4et8M/RUOAHS1S08OFsqdtdQIeZSO/KvqnsB5biXdjZIZx1LyKaTQMzo+fVzJi0wRx
 YiM9sMjdiU4jHv+qLOPcFIO65I3Msa2JuGrFEisH+UOcvVD46vNuAx2vgLRL4YJ/qb3P
 O311TF4m9zkvUe3loDdRb6NUnHnAIfK16y0/1OURbftugBJtZrx/l+olLd3QybMe8fOL NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctrj2xetf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 14:27:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BAEGpP1186694;
        Fri, 10 Dec 2021 14:27:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 3cr1suaj80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 14:27:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glXEbO1tisTt4/1BWU8eSSoi33UVvLrs3KAMo/mB12n+bGFw9YIwU//afvFOy3TNo/np2zxHbIp073t04Jt3kAqEQZAG+WFEkmIXpBCFDYXDK/awwdSMGRqGD64ri/zhOqS1rlVDT+C8sCg8B+tHbuYiM0pEr1oKswmOQiSxeh+r3FSQwMXxbK0ozNK4pWR7Jn38d5pIAz42GvxVihotDbQLlLMWQbRBSG7SclyNjXOYVl3PWFKx1uGmy8zeGkAGdXgQ9tss/o6QVYAlBk7IdrNBsQT/UU1FeFx6XZo3dMkSA5Q+d4ZNjcBnZ0rUtCvo+rDDpDFhT+xYOF3ZMPjXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uaT/HvlykQi87nugbQ+BiLnzAdXPi/C1zdlgbAy9Ao=;
 b=edagig2/ZKyiAErmbQPbtgSI71ocZC2BFZfVbnQR8iK0I3z+CsB9goaYPvuSuFAHGsNwXRPDCLuOVjaau/hBv16f49Qho2u5/oY+65uUNSYead5ZPQLqkG6ug/LO3oumP01/1wkKigPdXQXiTrbaXQHuFLvr5KjB1tA+p7wiERfa7N1L345jyCNQ/A8wYTEtSfoWOUGSen9W86lhxRAaSroIIfVrlK0uDS1RV9RG9IxZ470cg/ceKy+tb14YpjsU/S6odM8ZbCTH8+KG6+T9JWjOO/DBQGRVO+vn7azqGafkudgu0gGRTRytokESItLNlMcaWeK48uFDDw92KAApPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uaT/HvlykQi87nugbQ+BiLnzAdXPi/C1zdlgbAy9Ao=;
 b=ffsjsms/IW7XcPyEFcElQS2fnCx1k/bRYAsFDepCxx2SD4GRGNTE5OtZ9HmD14tDj9yFE6OQUJccuX7wMHy11Visp10/eHhDBjaflLyMFX80pNs5hG+czpbKnzOInh7X/9F+DzrpmkJWqLUc4enuLZ22EZCSA6n9pnVYxhid6fY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MWHPR10MB1776.namprd10.prod.outlook.com (2603:10b6:301:4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 14:27:09 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::8cb9:73cc:9b75:6098]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::8cb9:73cc:9b75:6098%8]) with mapi id 15.20.4778.013; Fri, 10 Dec 2021
 14:27:09 +0000
References: <20211020170305.376118-1-ankur.a.arora@oracle.com>
 <20211020170305.376118-8-ankur.a.arora@oracle.com>
 <b955c5c4-bc4b-9f43-be1c-3a45973de259@linux.alibaba.com>
 <87czm5ulcc.fsf@oracle.com>
 <acc75c62-b919-12da-25b4-2b65ecf89ab6@linux.alibaba.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     Yu Xu <xuyu@linux.alibaba.com>
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        mingo@kernel.org, bp@alien8.de, luto@kernel.org,
        akpm@linux-foundation.org, mike.kravetz@oracle.com,
        jon.grimm@amd.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v2 07/14] x86/clear_page: add clear_page_uncached()
In-reply-to: <acc75c62-b919-12da-25b4-2b65ecf89ab6@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 06:26:58 -0800
Message-ID: <87wnkcsfgt.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 944d27b1-d2f5-4f4b-c049-08d9bbe9261c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1776:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1776D74404F389D261DF0AA6CE719@MWHPR10MB1776.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nnKwqcFRqBGeqLjmp8j1qoqPXBHU/ckQK1A5FW40/wJw0pckS+sXNvT13xIRhLxTNvsPMlEb9+ajmFrauguB3C2jf4vxrexjiefgkvAwtr6FeJFaYnD6VjZ1rtS8XaRgGC1YBwmZOlLE0ziRmGi9RfNFE4DeoJTiu5xO1h+AqYuCm7lhgIyOu54DKWLP2PBhfXNrO3EI+h9u62wM9CJ1tUFHlTIJzs6YTWj6/bG7Qn3912rU9XwsBbaTRqrZ7fp9vv6OsZc/RY1tiwnjPhvMMwAipWvyT/DMIOEMKlsBTERJgEd5PCiTt98JNhOK7MKtqBg635JdXKInPUxcOFCz05emcWMcHHHfz1weKlq6ljxVio8WSFa6qSrgs0m2B9vu0FP4JDUpuVTDRG8XtCazhXxscmf/qmCxCs2HXpkpZLhOYl1IfljHZgvrf5uyw5nHqbFiOJSXjvVYFae4uSsxw2wDLlgfhVfW3/fPm8jOpcEhdP5rTe62VAyH1jbISQnPOeBo+IfOf2mp/FnNORp42JasKHt0HerO+wCDMCZNprPUW6p40JY2UPhSfS/4n+xbPiP/0DNMwL6EhKxBzpHqarj5sGuv0+3So97NoMX3gIRIhrFQ+y10/WxIu/pV8cHL+OkOK3sbdS80InKwe1UIb7zYeKiYkAB5saGJftTtWivuOdO89EGs375Ri+ZMMrDga20ho2Z/vlkQ+wprEaaViA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(5660300002)(66476007)(4326008)(2616005)(6666004)(6506007)(53546011)(508600001)(6512007)(38100700002)(8676002)(6916009)(2906002)(107886003)(26005)(52116002)(38350700002)(6486002)(8936002)(66556008)(7416002)(316002)(86362001)(66946007)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TX5gdpeWGG5piOAfa2y/GHv36ydWsLytvtlUYjoIiSpWtcfjhcGfHy1ioJlQ?=
 =?us-ascii?Q?iGrH3H9Lnj2DFH3DmbIKJwOwD5UahQj7HK+bRfjxyaU9LtUGo5aU1EyIXh6l?=
 =?us-ascii?Q?OLG3qMbg4OKplcbD5vYFFYswAhNMgT12y/Kn0CcR8QIq7i5kmGv0YDnAkPoJ?=
 =?us-ascii?Q?HSVmbDihJRqgYhdovHIaKTf7iWJAw+HHNFlLffZKhQ6LzhIAhcUd6vqjm5IT?=
 =?us-ascii?Q?h+zQDgqZuUadem9IxVBGg6t4yulqEZGYPMxQEeKXMc0GGNQomaHmZuUkxpZh?=
 =?us-ascii?Q?aooc4W8HOatsm+XS0Zc8LwPytZ3bebNwg+4RgdjOk6xr9kldxpL/fej6tenv?=
 =?us-ascii?Q?4i0Cb8uFgtM12IJlSYCu9o+AXofVkHBIoF8Pv3n+z1jLNxdheX56HeYEEUbp?=
 =?us-ascii?Q?A0mv6RLRyQAPSvl0VNVmyxT8g5krAtDiAygyECAO1AW9p9EN7+ENQ9EmmUon?=
 =?us-ascii?Q?bL3NM7Y2YUo8JPrFyd53ERLFODW5yBn6VH/pcyQT8Vs8q2kML+YbCBEsHGQt?=
 =?us-ascii?Q?YB8lG9e2++qnInpGqW8SmWAIieUMWQonZhDmlcwL7B5K1X2DG0NQP5/yR1b3?=
 =?us-ascii?Q?Ac1VhUpcVL60Zw+/sKYK1+h4SXHoeo14RXkJDv86qLNQrT8hdpJzJ/SCRb+y?=
 =?us-ascii?Q?S+ygwo/0lk2/t0fAQOF9rI8Qeva3XQ6wtxXy6JiwZIs6MkS6PrvoHvdIqg4a?=
 =?us-ascii?Q?k8bvOIkzMxPRjgRZLHwcFscbCAjUAWjIqUAJcptCF1FujBL3tPv/IDI49GM/?=
 =?us-ascii?Q?yAQS+2GrJN4md3bzRqh1p18uHOvPAgn8xk21Jm977L5vljfY2oCAHOb/3fND?=
 =?us-ascii?Q?r3YrckJxrPM2ajTCu7f33jeB6oNuYzzR8nb+Ad4QTnGg3zpjA610nAY1kfsH?=
 =?us-ascii?Q?3VxwGTLP54K1PG7LZ9gjCy2boG2ECUReaDlqLHIL53jEvTZICYCxghqiLp26?=
 =?us-ascii?Q?3j7BIVIHm0vO3IqaasiLZs/YPGthj+dpmzC09LSW3r/HWsHHq0jtZvpsR3UU?=
 =?us-ascii?Q?uXLA+F3HIyZlaeqGXnn+bf8lntNORZVaB1l9NLrQ3AwufDFw0f8YozTA/GOc?=
 =?us-ascii?Q?BKr273CK6NhsZhqS9WBX78OhLFkV9Ex7w43al06VKy4aH2Ca8G0KHBbk+sWg?=
 =?us-ascii?Q?n7TkckEEJjurYNPBcbOPfuZfj/HSDwH0llUxkbfd5rPDMMVw+oaaXMX8VCpu?=
 =?us-ascii?Q?Vao/sh1ujeIgo0e1e821jns3TVr23qXul9evLHq60QD7sidKRMl6mGUi51vc?=
 =?us-ascii?Q?mxJ0djdHLakP61WmUn12sfaCIxyFhvwGWOYDOg1RtjnK69Are/wUQgs1KFsU?=
 =?us-ascii?Q?rhYyhIwIrH5hgp6i3d5F9KLanWrEUlumqEZxz34L9JjjyoCb39VFzWwsEJLr?=
 =?us-ascii?Q?G5BI4nVX88SCrkYBctxf2e2J2nUyuPX1H34ine0JBJMAL/qOIP2fOmzFKVMi?=
 =?us-ascii?Q?h1BzjaNYfHQpuuaGrGdifR2HtTs8W+yyoTO0TX5zTWo6dQSytLb/v1yatRRF?=
 =?us-ascii?Q?72RsXcLJ8Z1j4smUJto1INi955AkH1FdpqRgkyE53v+8x1JOWpW/J1Og3Wa9?=
 =?us-ascii?Q?Sfa9MN9OrEpS/XN7Y+CIgi8YK+uluan57a0ilxaPFdz6BzQt3pNhVkpfg2qj?=
 =?us-ascii?Q?qF21F9403nIz7/mNk6jK01ghOAv6MwqG+hVY5J/0TvT+Swf+9cQ8FSGNItea?=
 =?us-ascii?Q?gETyiw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944d27b1-d2f5-4f4b-c049-08d9bbe9261c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 14:27:09.2871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6R09OEeqqOxwfrV6ZwoJpdliplDBf8kDwmd2G+brwZDpdwWk8ewTxQt3UwRalaAkhXhUL8TGopA//fcfzAiOpy3eSmX41PnVYmyt7KfADds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112100082
X-Proofpoint-ORIG-GUID: knPKZex8pKECZlOskrHu78mpbU-FHmfY
X-Proofpoint-GUID: knPKZex8pKECZlOskrHu78mpbU-FHmfY
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Yu Xu <xuyu@linux.alibaba.com> writes:

> On 12/10/21 12:37 PM, Ankur Arora wrote:
>> Yu Xu <xuyu@linux.alibaba.com> writes:
>>
>>> On 10/21/21 1:02 AM, Ankur Arora wrote:
>>>> Expose the low-level uncached primitives (clear_page_movnt(),
>>>> clear_page_clzero()) as alternatives via clear_page_uncached().
>>>> Also fallback to clear_page(), if X86_FEATURE_MOVNT_SLOW is set
>>>> and the CPU does not have X86_FEATURE_CLZERO.
>>>> Both the uncached primitives use stores which are weakly ordered
>>>> with respect to other instructions accessing the memory hierarchy.
>>>> To ensure that callers don't mix accesses to different types of
>>>> address_spaces, annotate clear_user_page_uncached(), and
>>>> clear_page_uncached() as taking __incoherent pointers as arguments.
>>>> Also add clear_page_uncached_make_coherent() which provides the
>>>> necessary store fence to flush out the uncached regions.
>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>> ---
>>>> Notes:
>>>>       This patch adds the fallback definitions of clear_user_page_uncached()
>>>>       etc in include/linux/mm.h which is likely not the right place for it.
>>>>       I'm guessing these should be moved to include/asm-generic/page.h
>>>>       (or maybe a new include/asm-generic/page_uncached.h) and for
>>>>       architectures that do have arch/$arch/include/asm/page.h (which
>>>>       seems like all of them), also replicate there?
>>>>       Anyway, wanted to first check if that's the way to do it, before
>>>>       doing that.
>>>>    arch/x86/include/asm/page.h    | 10 ++++++++++
>>>>    arch/x86/include/asm/page_32.h |  9 +++++++++
>>>>    arch/x86/include/asm/page_64.h | 32 ++++++++++++++++++++++++++++++++
>>>>    include/linux/mm.h             | 14 ++++++++++++++
>>>>    4 files changed, 65 insertions(+)
>>>> diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
>>>> index 94dbd51df58f..163be03ac422 100644
>>>> --- a/arch/x86/include/asm/page_32.h
>>>> +++ b/arch/x86/include/asm/page_32.h
>>>> @@ -39,6 +39,15 @@ static inline void clear_page(void *page)
>>>>    	memset(page, 0, PAGE_SIZE);
>>>>    }
>>>>    +static inline void clear_page_uncached(__incoherent void *page)
>>>> +{
>>>> +	clear_page((__force void *) page);
>>>> +}
>>>> +
>>>> +static inline void clear_page_uncached_make_coherent(void)
>>>> +{
>>>> +}
>>>> +
>>>>    static inline void copy_page(void *to, void *from)
>>>>    {
>>>>    	memcpy(to, from, PAGE_SIZE);
>>>> diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
>>>> index 3c53f8ef8818..d7946047c70f 100644
>>>> --- a/arch/x86/include/asm/page_64.h
>>>> +++ b/arch/x86/include/asm/page_64.h
>>>> @@ -56,6 +56,38 @@ static inline void clear_page(void *page)
>>>>    			   : "cc", "memory", "rax", "rcx");
>>>>    }
>>>>    +/*
>>>> + * clear_page_uncached: only allowed on __incoherent memory regions.
>>>> + */
>>>> +static inline void clear_page_uncached(__incoherent void *page)
>>>> +{
>>>> +	alternative_call_2(clear_page_movnt,
>>>> +			   clear_page, X86_FEATURE_MOVNT_SLOW,
>>>> +			   clear_page_clzero, X86_FEATURE_CLZERO,
>>>> +			   "=D" (page),
>>>> +			   "0" (page)
>>>> +			   : "cc", "memory", "rax", "rcx");
>>>> +}
>>>> +
>>>> +/*
>>>> + * clear_page_uncached_make_coherent: executes the necessary store
>>>> + * fence after which __incoherent regions can be safely accessed.
>>>> + */
>>>> +static inline void clear_page_uncached_make_coherent(void)
>>>> +{
>>>> +	/*
>>>> +	 * Keep the sfence for oldinstr and clzero separate to guard against
>>>> +	 * the possibility that a cpu-model both has X86_FEATURE_MOVNT_SLOW
>>>> +	 * and X86_FEATURE_CLZERO.
>>>> +	 *
>>>> +	 * The alternatives need to be in the same order as the ones
>>>> +	 * in clear_page_uncached().
>>>> +	 */
>>>> +	alternative_2("sfence",
>>>> +		      "", X86_FEATURE_MOVNT_SLOW,
>>>> +		      "sfence", X86_FEATURE_CLZERO);
>>>> +}
>>>> +
>>>>    void copy_page(void *to, void *from);
>>>>      #ifdef CONFIG_X86_5LEVEL
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 73a52aba448f..b88069d1116c 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -3192,6 +3192,20 @@ static inline bool vma_is_special_huge(const struct vm_area_struct *vma)
>>>>      #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
>>>>    +#ifndef clear_user_page_uncached
>>>
>>> Hi Ankur Arora,
>>>
>>> I've been looking for where clear_user_page_uncached is defined in this
>>> patchset, but failed.
>>>
>>> There should be something like follows in arch/x86, right?
>>>
>>> static inline void clear_user_page_uncached(__incoherent void *page,
>>>                                 unsigned long vaddr, struct page *pg)
>>> {
>>>          clear_page_uncached(page);
>>> }
>>>
>>>
>>> Did I miss something?
>>>
>> Hi Yu Xu,
>> Defined in include/linux/mm.h. Just below :).
>
> Thanks for your reply :)
>
> This is the version when #ifndef clear_user_page_uncached, i.e., fall
> back to standard clear_user_page.
>
> But where is the uncached version of clear_user_page? I am looking for
> this.

Sorry, my bad. There is a hunk missing. Not sure how, but this hunk
(from patch 7) got dropped in version that I sent out:

    diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
    index 4d5810c8fab7..89229f2db34a 100644
    --- a/arch/x86/include/asm/page.h
    +++ b/arch/x86/include/asm/page.h
    @@ -28,6 +28,16 @@ static inline void clear_user_page(void *page, unsigned long vaddr,
            clear_page(page);
    }

    +#define clear_user_page_uncached clear_user_page_uncached
    +/*
    + * clear_page_uncached: allowed on only __incoherent memory regions.
    + */
    +static inline void clear_user_page_uncached(__incoherent void *page,
    +                                       unsigned long vaddr, struct page *pg)
    +{
    +       clear_page_uncached(page);
    +}
    +
    static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
                                    struct page *topage)
    {

It is identical to the version that you surmised was missing. Thanks for
the close reading.

Ankur

>>
>>>> +/*
>>>> + * clear_user_page_uncached: fallback to the standard clear_user_page().
>>>> + */
>>>> +static inline void clear_user_page_uncached(__incoherent void *page,
>>>> +					unsigned long vaddr, struct page *pg)
>>>> +{
>>>> +	clear_user_page((__force void *)page, vaddr, pg);
>>>> +}
>> That said, as this note in the patch mentions, this isn't really a great
>> place for this definition. As you also mention, the right place for this
>> would be somewhere in the arch/.../include and include/asm-generic hierarchy.
>>
>>>>       This patch adds the fallback definitions of clear_user_page_uncached()
>>>>       etc in include/linux/mm.h which is likely not the right place for it.
>>>>       I'm guessing these should be moved to include/asm-generic/page.h
>>>>       (or maybe a new include/asm-generic/page_uncached.h) and for
>>>>       architectures that do have arch/$arch/include/asm/page.h (which
>>>>       seems like all of them), also replicate there?
>>>>       Anyway, wanted to first check if that's the way to do it, before
>>>>       doing that.
>> Recommendations on how to handle this, welcome.
>> Thanks
>> --
>> ankur
>>
