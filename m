Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3F43FB6B
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 13:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhJ2LfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 07:35:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39070 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230492AbhJ2LfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Oct 2021 07:35:02 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19T9shFf002201;
        Fri, 29 Oct 2021 11:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ASL/5ZgHammi5DIVzEszdXatehiW9Vna3ApAnWoSmLs=;
 b=Ege9Xx5xyb0F+KDwp7dkM47y5oqAGDadKj4i8VrqBO2sddejVQRt9lK9/y08O3bsBm7I
 7UjfxCpg9uscAO3IIgADppVaBuiTJWLYIjq6XrfWpCcYvwh/oIBzdcGr1usbDZKAqf4u
 6HRHXktb9FyxYi/tENUbbqZuNInrKT1C9wjNAQEz4XR2wp9LKOOd5o2iFRMa/jfG+4WE
 ezd4h+sF45COdYkgkvle6z/dynKY/iuf5/Jmb19iAqV76PDuU6JJvMXSFdvH9aVK2q19
 eSoLBgYXzohQGvTeS84QFdOZj6pqTVTfSgY9QRbntE0jIpok6y8xmXAnb88pHOBL5EbN gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3byj7s08b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 11:31:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19TBM4Vo079655;
        Fri, 29 Oct 2021 11:31:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3020.oracle.com with ESMTP id 3bx4guc5pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 11:31:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRW/VJD3XoNrVSatX26kYq9JbMzcOAR2PDIRlCJdrhbkYgc76Vi99zJonv4XrTF5Thj1Ks/72/+KcGDUumwSn+Ppr0ua11KSbKyk4MYoVWWKW/U2p6xH1DxcxOSYFgG/3DGKVYK3nj8aOrTh7qbPdYJQvArXJaFU/UYdmd7zgowRFnuda+s5rBTKSUAuNdX6hl9wdg4JzyD6daLEDA/jiz2E/70ZHS7hf8LavD5Yq6kxtCVtZe989x3Wg+REZRCaIE9FCu2POLJJ6Zealp6NQ7S9BS+uCOk0ZmXSry49/MRlq+lZyBYDvXxi772PpLaIdUdigQawgJsWKU/Af3KqvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASL/5ZgHammi5DIVzEszdXatehiW9Vna3ApAnWoSmLs=;
 b=j2W3bBh7bb+1Wo/a2PYoHCGPNOyVEQJ2K9NCJKGdqHFcTx+rfwnd+dBoV5pcYuDJLYaJgBGVS6/VnHGfxKd19b0ob6s35N/q2E/jEh/pBcDlfx0506UgUfeMlvhJRNgo6S0QZbf18UzjpBmrJy4y+/21NquUpeYrfROkt8vT+QHlnqF/ZNn/jLLhw0+Kj+g85J3ZQMPrggWfMijkIPzU2s5HunR6hNEXyOrO2I0VIQUrsK3gL0D5LXKbCGSrq+xT1ssL5dYUycfFPkWdjZJ/3zB+jH2eojq0i/NM89xMIBI60Lmj/Q+cD6OY+ouhgzp4GK3o47skw5eVfvJSUFbd4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASL/5ZgHammi5DIVzEszdXatehiW9Vna3ApAnWoSmLs=;
 b=0U2CzUmJmslmT+k7TG+G8zJP9eop/RcOOIIeYUvVXcyd7TxEDsDrdG13UX23vZKS6MsLIgrUJn+3Gm+7BIZ2Bc2TeAI0WXlMAuhDCuzmfprk8tDwRKONsrrshqrajogugkR+yUzgyhWED0mWBwjJAqrHaEHSHH+7/G6ZQoeuaVI=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3854.namprd10.prod.outlook.com (2603:10b6:208:1b9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 11:31:39 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 11:31:39 +0000
Message-ID: <99c7d806-4642-c329-79d4-0ff9f04d56ce@oracle.com>
Date:   Fri, 29 Oct 2021 12:31:32 +0100
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
 <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
 <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
 <2e7bcafe1077d31d8af6cc0cd120a613cc070cfb.camel@infradead.org>
 <1d5f4755ea6be5c7eb8f59dea2daef30fc16b173.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <1d5f4755ea6be5c7eb8f59dea2daef30fc16b173.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0114.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::30) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
Received: from [10.175.170.77] (138.3.204.13) by LO2P265CA0114.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 11:31:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb9638c4-1664-4fc5-f356-08d99acfac1c
X-MS-TrafficTypeDiagnostic: MN2PR10MB3854:
X-Microsoft-Antispam-PRVS: <MN2PR10MB38548B699CFEEB1D2770C11ABB879@MN2PR10MB3854.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NLVPyA7GckAOw+UA6YC6M3UY1jTHwfZ6MZK+594aIiDikbUw51pfZBlccKKyqpDOM9Qic0I5m2+2lLHy2oVKnsp1V/wjYcY/ixspzpWR8yDK0pE5g3Gj8O/PW6iucVPmk+G7+5iHPw1JlnzfGfL5LLsl+JtA3Ea5/+Ch0TiyFESKPTZy9yXNbICIxj8VoOcMMH/j1L2WqqD8S+jEjsj/9TWbgI0OM9FVse0aL6sjH3vHTDEV+HVCkyhXgZNHfCgQP59djLDHebFK5auWPUH5hxCMfEJDvEQGWM5dAhMfBlSuWG6P0U0zb7+PvTVxWhoAxAbCv9yXvzefa33WCFk7HJadqU5zTHLr1OxxXNKn1oRfIwkoelZVEkMVF5laWq0KRr4/PWkvwLDCoMBXpHMFsnl+NRzyh3sy+zfPHi2M9W0Af8tDtgZBbcHHQWPuXhJ22Y0S7NulO+eI7fs2MpJ+FktHmB5f0uWhPXYgjga1MN8MP/l2qjs/o7p77JofiZTzihijodA51NP4pRHlPpwVSTyRGxzZweQ8v44Yv2e5eNHl/+cp5s2zc0Ye/13HxEcnPhv8djGTqWKAXZQe4jwwYpgkAhLXCgGPKpaWH119Y15xzd1TpgxjKI9oGsk63y4Uyup6pFtf/s9+eIQe3RG1+FBiaA1K6CYslOxFm13iKhq6SpuhHSVZ/feNPbtFKii50tRf8vgOh5M97U3igAcUFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(26005)(4001150100001)(66946007)(8936002)(66556008)(66476007)(8676002)(53546011)(6486002)(186003)(31686004)(31696002)(5660300002)(2906002)(86362001)(7416002)(6916009)(107886003)(4326008)(16576012)(316002)(2616005)(956004)(508600001)(54906003)(6666004)(36756003)(83380400001)(66574015)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTJCZDF2RW9yT01WZ3Fyb2Y3ZHlIUzYwaXpsT2ExRjgrMWR2YXpUOS9rNWVo?=
 =?utf-8?B?NWJpTWsydk4xODVlb3VLd1FrSXZpWFhwYU9HcGwwWUtFWWZuTHVXYk9IWENQ?=
 =?utf-8?B?NmhMbmlYenlKUXRQMHBJeUNsTFRlcCtlRUdYNnhCQW4xRGR4Y2E1QU1pOFAr?=
 =?utf-8?B?SXZMSm85ZTRNRWFDTjhjMnFsMlptaHNZSlBxaXdqclZUZ2R5d2hlUEg1RlFz?=
 =?utf-8?B?MmQ0NWJhV1B0RE5Wa29SY21JYmttWWI1N2JwTXA3M1BremxKL1ZnMjkwcVVl?=
 =?utf-8?B?RFFEcjQyMWZEQ0JiVHJjUHFzVld0UFdsU1VLN0FtNjh5dUw2d1pOYVRNdmU2?=
 =?utf-8?B?ajc0SmZhakRRR3dES0R0ZmVqb1NJQkNTQzRLd3ROSnhXT2NjdlBPc09mQ3JU?=
 =?utf-8?B?ckNFNVJYNmlRdnFmMFdMY2Y0WklNcGJCUlgrMHdXSW10dWYvb3B2c09NSTJO?=
 =?utf-8?B?MlRkdFpRR2VLR2hzSUkzMGlRdU9uTjYvQVBkK1paZVlQWWw5WXJaSnk1UnlW?=
 =?utf-8?B?SVhrRlk1a25RMWhVaVNMQ1RNVGxjMHJuNWE4c2RndDgweEtsTTMvTkNCb0hp?=
 =?utf-8?B?TWlaRmk5WWpZQUhPbm9GR013dVR4N0pZTTZGQ3AyZEM2aktHbDMyVEtmMnAr?=
 =?utf-8?B?TkhaSmQ5V1NNam1SbG9IQnNxZ1lvbDRvY0FwTWw5eS9uTTNGQ2RJODJTb25s?=
 =?utf-8?B?SFNNZFAxZ0w2VmhHTXdZa01sNHg1MU04YldxT2kwWG8vQ0RKckN2SXA3czNa?=
 =?utf-8?B?cHZOdUJwekNOQmhRQWJJclFDRnUrL2xHQUNkcU5xRU1uMERIL3grM3BZSmtQ?=
 =?utf-8?B?c05aWW1IRG84RWQvNFl3V2UwR2lQSy9VZ2VWSHlNVnpzZVVzUlhEZDM3OEhF?=
 =?utf-8?B?eVpuL2RmdHl0d3NHdTFBcGJJZTNDdXhxRmh3dURLU0R5WXJGYWU1VHprMFNq?=
 =?utf-8?B?Z0FZazErU2R6eHpKNFhDWFJlK2U3ejFIS3J2ZzFYSFdVVXBvVTdadThoNmpk?=
 =?utf-8?B?cWlzVWZWaHpBRnUvSUR1cXF2SjJ0SVo4dlc5RWg0dFdYOUhVdExDRlRYZXUy?=
 =?utf-8?B?K0lZRWlWTzVVSTZMcXQvcFlDbHlCNWxhWkF0L2VsRFg3ODFXSlB6b1ZiWERU?=
 =?utf-8?B?WlFST0gveWlLRy93OUNKNGlkNjI5V29QZkh2MGFJOXhMaHpMY1V3ZER5ZDZH?=
 =?utf-8?B?M1NsQnJaY2xsdW9Zb3M1UExzK2Y2ZXE0OFhtZWVSOTM3R0RmOHNlRU82aVRI?=
 =?utf-8?B?Q08vWjhYanZ4MjVyRXFpRGpvZUpvMStMakJqa0F0bkNFbXlaK3k0aGozQkpF?=
 =?utf-8?B?YzBPTWs2OWJ2b2s4eFlQWXI5bEdULzBxR1VUdUkxbWl6VEhFTjZGM1pQQ2wy?=
 =?utf-8?B?ZHRkYSsxdFMyVmxSUXZ6NXlSZlFjZ2F4ZkcvNkd2Wjd4ZFAxTjA1M1JKT2or?=
 =?utf-8?B?RDV0WUVSVWNBa0JGMlRYT0JkWFRMd1dLYlYwWVJwZWZpUGcwei9pa2hSUDN1?=
 =?utf-8?B?QmE3R0Jaamc4YkRxSjltQ2U4Sysxb0Q3bUtrV09uMnZ2M0RVYm10SGdQQ1d0?=
 =?utf-8?B?TEk0aFVLc25rN1p6dmdHTVU5SEo4blVOMVRVTnJEbjFPdy9hb2V0aG5YbWlZ?=
 =?utf-8?B?c1BkSTA4RDVFYm1MNkFhbGpqQ0hIT3JxcjU4emtqWTdmL1hUaEt2RGppK1Fl?=
 =?utf-8?B?MXVET293N3U2Sm5Gd1BDWHlyL0RSMzFYTUlBZ2VROThJM0h3RzhBamdyMXFI?=
 =?utf-8?B?YmxjUW84akgrUjFvVlFlVTBPRUs1Wkc5cVB0MzhsajNLOEg2UTFkdEhFMy9D?=
 =?utf-8?B?M2ZYYnVCUDlmMnl4R3lYUnVMaXEwZGJ1ODZqeDd2UGMvVzhuL2VYRm1XVEhx?=
 =?utf-8?B?aHJ2RWxiSXJrWTlzcFE4dlFMUmhIblJJMVZUc240Wjl2WlJhV1VuUy9tSDBw?=
 =?utf-8?B?NjNCM0IvaFIzY3ZWcWo3VGRRK242RFBOMWIwS01VZjl1VUp5M3QwbXI4OEFy?=
 =?utf-8?B?VTAydUVLQmFDQzc2anM0elFwdUdCdHRrWXIxb3ZKdzlKcEkydUpERnNBS0g4?=
 =?utf-8?B?UmgxSGhubkNsdlJkeWJEREZhdmx4Nk9Bdy9yTHZCQ2FYMEJ4UmRhU1k3ZWhq?=
 =?utf-8?B?MkNMcjhVelEzZUl5UFN2bzl5dlpkUlU1bitPUTR6bSs4OHV4cVpGQjlTblB2?=
 =?utf-8?B?eFJSL3NqcVdQV0VzNTdzZXBaOUVuYjA2NWxpcmtoYkg2S1U0VWxWN0h2MXk3?=
 =?utf-8?B?V1RQYkwwSzdlUEZBRUEwMHdQMHdnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9638c4-1664-4fc5-f356-08d99acfac1c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 11:31:38.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr12qEQRo/NX5/Vyshd10OyGIEDSHYuYsQmI9ghOnbAOXqEwbj+LAUdDNitfVZUaVWZLW8YeuWRAKThdaCOw2gXOxvuWUvlNTx4J31o1sNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3854
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10151 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290066
X-Proofpoint-ORIG-GUID: YPPGqexcgZSFLdK1HssSlqqpebMinJ0c
X-Proofpoint-GUID: YPPGqexcgZSFLdK1HssSlqqpebMinJ0c
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/28/21 23:22, David Woodhouse wrote:
> On Mon, 2021-10-25 at 13:19 +0100, David Woodhouse wrote:
>> On Mon, 2021-10-25 at 11:39 +0100, David Woodhouse wrote:
>>>> One possible solution (which I even have unfinished patches for) is to
>>>> put all the gfn_to_pfn_caches on a list, and refresh them when the MMU
>>>> notifier receives an invalidation.
>>>
>>> For this use case I'm not even sure why I'd *want* to cache the PFN and
>>> explicitly kmap/memremap it, when surely by *definition* there's a
>>> perfectly serviceable HVA which already points to it?
>>
>> That's indeed true for *this* use case but my *next* use case is
>> actually implementing the event channel delivery.
>>
>> What we have in-kernel already is everything we absolutely *need* in
>> order to host Xen guests, but I really do want to fix the fact that
>> even IPIs and timers are bouncing up through userspace.
> 
> Here's a completely untested attempt, in which all the complexity is
> based around the fact that I can't just pin the pages as João and
> Ankur's original did.
> 
> It adds a new KVM_IRQ_ROUTING_XEN_EVTCHN with an ABI that allows for us
> to add FIFO event channels, but for now only supports 2 level.
> 
> In kvm_xen_set_evtchn() I currently use kvm_map_gfn() *without* a cache
> at all, but I'll work something out for that. I think I can use a
> gfn_to_hva_cache (like the one removed in commit 319afe685) and in the
> rare case that it's invalid, I can take kvm->lock to revalidate it.
> 
> It sets the bit in the global shared info but doesn't touch the target
> vCPU's vcpu_info; instead it sets a bit in an *in-kernel* shadow of the
> target's evtchn_pending_sel word, and kicks the vCPU.
> 
> That shadow is actually synced to the guest's vcpu_info struct in
> kvm_xen_has_interrupt(). There's a little bit of fun asm there to set
> the bits in the userspace struct and then clear the same set of bits in
> the kernel shadow *if* the first op didn't fault. Or such is the
> intent; I didn't hook up a test yet.
> 
> As things stand, I should be able to use this for delivery of PIRQs
> from my VMM, where things like passed-through PCI MSI gets turned into
> Xen event channels. As well as KVM unit tests, of course.
> 
Cool stuff!! I remember we only made IPIs and timers work but not PIRQs
event channels.

> The plan is then to hook up IPIs and timers — again based on the Oracle
> code from before, but using eventfds for the actual evtchn delivery. 
> 
I recall the eventfd_signal() was there should the VMM choose supply an
eventfd. But working without one was mainly for IPI/timers due to
performance reasons (avoiding the call to eventfd_signal()). We saw some
slight overhead there -- but I can't find the data right now :(

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index c4bca001a7c9..bff5c458af96 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -207,6 +207,8 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>  
>  int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  {
> +	unsigned long evtchn_pending_sel = READ_ONCE(v->arch.xen.evtchn_pending_sel);
> +	bool atomic = in_atomic() || !task_is_running(current);
>  	int err;
>  	u8 rc = 0;
>  
> @@ -216,6 +218,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  	 */
>  	struct gfn_to_hva_cache *ghc = &v->arch.xen.vcpu_info_cache;
>  	struct kvm_memslots *slots = kvm_memslots(v->kvm);
> +	bool ghc_valid = slots->generation == ghc->generation &&
> +		!kvm_is_error_hva(ghc->hva) && ghc->memslot;
> +
>  	unsigned int offset = offsetof(struct vcpu_info, evtchn_upcall_pending);
>  
>  	/* No need for compat handling here */
> @@ -231,8 +236,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  	 * cache in kvm_read_guest_offset_cached(), but just uses
>  	 * __get_user() instead. And falls back to the slow path.
>  	 */
> -	if (likely(slots->generation == ghc->generation &&
> -		   !kvm_is_error_hva(ghc->hva) && ghc->memslot)) {
> +	if (!evtchn_pending_sel && ghc_valid) {
>  		/* Fast path */
>  		pagefault_disable();
>  		err = __get_user(rc, (u8 __user *)ghc->hva + offset);
> @@ -251,12 +255,72 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
>  	 * and we'll end up getting called again from a context where we *can*
>  	 * fault in the page and wait for it.
>  	 */
> -	if (in_atomic() || !task_is_running(current))
> +	if (atomic)
>  		return 1;
>  
> -	kvm_read_guest_offset_cached(v->kvm, ghc, &rc, offset,
> -				     sizeof(rc));
> +	if (!ghc_valid) {
> +		err = kvm_gfn_to_hva_cache_init(v->kvm, ghc, ghc->gpa, ghc->len);
> +		if (err && !ghc->memslot) {
> +			/*
> +			 * If this failed, userspace has screwed up the
> +			 * vcpu_info mapping. No interrupts for you.
> +			 */
> +			return 0;
> +		}
> +	}
>  
> +	/*
> +	 * Now we have a valid (protected by srcu) userspace HVA in
> +	 * ghc->hva which points to the struct vcpu_info. If there
> +	 * are any bits in the in-kernel evtchn_pending_sel then
> +	 * we need to write those to the guest vcpu_info and set
> +	 * its evtchn_upcall_pending flag. If there aren't any bits
> +	 * to add, we only want to *check* evtchn_upcall_pending.
> +	 */
> +	if (evtchn_pending_sel) {
> +		if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
> +			struct vcpu_info __user *vi = (void *)ghc->hva;
> +
> +			/* Attempt to set the evtchn_pending_sel bits in the
> +			 * guest, and if that succeeds then clear the same
> +			 * bits in the in-kernel version. */
> +			asm volatile("1:\t" LOCK_PREFIX "orq %1, %0\n"
> +				     "\tnotq %0\n"
> +				     "\t" LOCK_PREFIX "andq %2, %0\n"
> +				     "2:\n"
> +				     "\t.section .fixup,\"ax\"\n"
> +				     "3:\tjmp\t2b\n"
> +				     "\t.previous\n"
> +				     _ASM_EXTABLE_UA(1b, 3b)
> +				     : "=r" (evtchn_pending_sel)
> +				     : "m" (vi->evtchn_pending_sel),
> +				       "m" (v->arch.xen.evtchn_pending_sel),
> +				       "0" (evtchn_pending_sel));
> +		} else {
> +			struct compat_vcpu_info __user *vi = (void *)ghc->hva;
> +			u32 evtchn_pending_sel32 = evtchn_pending_sel;
> +
> +			/* Attempt to set the evtchn_pending_sel bits in the
> +			 * guest, and if that succeeds then clear the same
> +			 * bits in the in-kernel version. */
> +			asm volatile("1:\t" LOCK_PREFIX "orl %1, %0\n"
> +				     "\tnotl %0\n"
> +				     "\t" LOCK_PREFIX "andl %2, %0\n"
> +				     "2:\n"
> +				     "\t.section .fixup,\"ax\"\n"
> +				     "3:\tjmp\t2b\n"
> +				     "\t.previous\n"
> +				     _ASM_EXTABLE_UA(1b, 3b)
> +				     : "=r" (evtchn_pending_sel32)
> +				     : "m" (vi->evtchn_pending_sel),
> +				       "m" (v->arch.xen.evtchn_pending_sel),
> +				       "0" (evtchn_pending_sel32));
> +		}

Perhaps I am not reading it right (or I forgot) but don't you need to use the shared info
vcpu info when the guest hasn't explicitly registered for a *separate* vcpu info, no?

Or maybe this relies on the API contract (?) that VMM needs to register the vcpu info in
addition to shared info regardless of Xen guest explicitly asking for a separate vcpu
info. If so, might be worth a comment...


> +		rc = 1;
> +		__put_user(rc, (u8 __user *)ghc->hva + offset);
> +	} else {
> +		__get_user(rc, (u8 __user *)ghc->hva + offset);
> +	}
>  	return rc;
>  }
>  
> @@ -772,3 +836,105 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>  
>  	return 0;
>  }
> +
> +static inline int max_evtchn_port(struct kvm *kvm)
> +{
> +	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
> +		return 4096;
> +	else
> +		return 1024;
> +}
> +

Maybe worth using Xen ABI interface macros that help tieing this in
to Xen guest ABI. Particular the macros in include/xen/interface/event_channel.h

#define EVTCHN_2L_NR_CHANNELS (sizeof(xen_ulong_t) * sizeof(xen_ulong_t) * 64)

Sadly doesn't cover 32-bit case :( given the xen_ulong_t.

> +int kvm_xen_setup_evtchn(struct kvm *kvm,
> +			 struct kvm_kernel_irq_routing_entry *e,
> +			 const struct kvm_irq_routing_entry *ue)
> +
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (kvm->arch.xen.shinfo_gfn == GPA_INVALID)
> +		return -EINVAL;
> +
> +	if (e->xen_evtchn.vcpu >= KVM_MAX_VCPUS)
> +		return -EINVAL;
> +
> +	vcpu = kvm_get_vcpu_by_id(kvm, ue->u.xen_evtchn.vcpu);
> +	if (!vcpu)
> +		return -EINVAL;
> +
> +	if (vcpu->arch.xen.vcpu_info_set)
> +		return -EINVAL;
> +
> +	if (!kvm->arch.xen.upcall_vector)
> +		return -EINVAL;
> +
> +	/* Once we support the per-vCPU LAPIC based vector we will permit
> +	 * that here instead of the per-KVM upcall vector */
> +
> +	if (e->xen_evtchn.port >= max_evtchn_port(kvm))
> +		return -EINVAL;
> +
> +	/* We only support 2 level event channels for now */
> +	if (e->xen_evtchn.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL)
> +		return -EINVAL;
> +

