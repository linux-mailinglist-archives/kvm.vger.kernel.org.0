Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0465E449FB8
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbhKIAmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:42:43 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22140 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234386AbhKIAmm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:42:42 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9028c6010234;
        Tue, 9 Nov 2021 00:39:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Raoh53wwbNdnFJhg8NiuISThCsUcsHOoO/5AmRQn4UE=;
 b=fltPuB+h36I/ivSGl5oxqQl1D4HGK/kosVrwl/RhX68rvo5l6PLMop1bwEifqTrUNmgY
 G6bhJaGzqeZUvlDXQolBBLuSznwIOEfKv/eb3uofUCOylbqt539MxvsMh25x7fVEwaN6
 CSY3+tRqcKK5I+BHn0vOzukUjDzBR9PKN1DHTeidfAsoI7LqSVK2CzSEjssqrqWQy8Qq
 vPUjBMW5V4SOdtldhfEf7uRxfzcDSwfkgRbRBjd3D3YKxFYhkBS09mWmunQstioAH/m8
 nXtEpw9M5+1Nsi7QsXfbkuvUJcMhpsMaF3VEKM0fueI/6M5cW5OcdMuKnNZu6mL1GVYt SA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnfjjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:39:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90ab1f054251;
        Tue, 9 Nov 2021 00:39:00 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3c63fs5dsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:39:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SXcXufoWtEeD31Uf+WXUSdlC3MEEWnrLgNMs8/cPIQCkTzXDBcELZd8ys9F/19YsjstHqxNHaZAaLNNiBGiyYWOY9fDh5Pove+xeVKNKyIKQSbpdb0r+b5b7OezmI/vNl9C4ESmMwZACcNqNN9vixcQnX6UUhpvcB+K3FqREE5RpbQ4EiMddS1+Gl/69CKZve3Sy7h1ih4Pu+pl4OTomlATgf3wBiugNMqvEHx2B7abcAuSL/pwNUaCu1CQmMC+y9pVXBtOG4jCfFMuejOV+DQHOocLtRjuWVuoErjE2NZpHGw/qvfdgn623TiV04gkJKc1zt4BrhwYvnlbE1SuWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Raoh53wwbNdnFJhg8NiuISThCsUcsHOoO/5AmRQn4UE=;
 b=IqDm37VF62UiA4lyRo41x1CGX/41jKNYIykEm+osb05o5WK2H9cfH9sjBFDwmYnzOWaI+mK4fJgxtIdDaLtoE7sg5IxNYwwwAOMTWY0/23+iHaBcQ62feWzcfctcwvkHOBwb/1Zllm+tbeDn1RcLLXMGh0DTb8vTIG/eRU7sOtZP9YReSQPoJnw/nz75np7NgJzQjzaTHdSdJJl2Dt/NkCKo8clyBdHQ7vborEpH707IS5Gjs1YtOjSxZshrPzoG/s9dH2iwyFx2IlKvB5gMsjr/o/wEccfPoo4gR/EWA77F6LzsBrQ4RgKhhoP3dOM4Rx0eJa/bAIqlr3kmVNfRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Raoh53wwbNdnFJhg8NiuISThCsUcsHOoO/5AmRQn4UE=;
 b=jryC9068d1uJWjVCyLOau4ERaM1aOnxQy6UZsdwaOJHLqfCh+1ssTsObUP/flDjinFn31OpMkmV11Zwt7S4wQViPs0R+2CTVeW07Lc/RJ4mzkJH6JCW6iidh/JvkNqdgrIPf9i8imMlcQb1d/2BBZYe8nM6vpMYbCoQ07VK6Tl4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4972.namprd10.prod.outlook.com (2603:10b6:610:c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Tue, 9 Nov
 2021 00:38:57 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:38:57 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 05/30] KVM: Resync only arch fields when
 slots_arch_lock gets reacquired
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-6-seanjc@google.com>
Message-ID: <aae78856-6a7b-6812-029a-32ddb6ad6866@oracle.com>
Date:   Tue, 9 Nov 2021 01:38:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::12) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by FR0P281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.14 via Frontend Transport; Tue, 9 Nov 2021 00:38:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3441a56c-32ad-4a60-3844-08d9a31950c4
X-MS-TrafficTypeDiagnostic: CH0PR10MB4972:
X-Microsoft-Antispam-PRVS: <CH0PR10MB49720B9A38268E81D9E920F8FF929@CH0PR10MB4972.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMoql/D0ecEyZqLrO8i2/58EkdIIuDNJnXWGAriaDF7/EV/CKXjvapesP5RpiTqNdrSYYz9jX+QRzAa6YTfqrFx5EifaSINeCDyoeF0wFAA5LF5aOTZQVVTklpH5vUayUVwRLAuClpPC2f+KTgKVK6ubxLhKJZmyLJkmQQON2i7fNqmGVxsPP462cdgQ/DcWZoDgqH7lgMxhYuCOayhb92bvZ23LRh0O/x0IFY8MCRYfs/Wg3/yGMcOgAyiFWwIzJb+hEpAi94lHYn+rVA2uGpDyHvkZ6ctVE6bo20g7WojAc90m0h4I+0BLeeAab82B69iXRDEl1n8gwwrRS71saYpdrx3qmM+B4/erjzZAGlR1gWFgoqSNTHUs1j9i2Fw36lKxm8BfgI/Vazz/fn1Zr/GcRtnyt5Y7uSUJzYy3A4IsWRikWyl2TiNEw/19UPiJ8IfvNHKK+Rmuw5vgtwFuza4L3JhxR6V2Ik2Me/3GYhEsebjZL5GAf3N7QSePE9hP/vy0+cVQPTG//j/tAL4z+UAovLuYDQD0Y/LzkAU/vPN0QGgNORqQtmqlpJw1VxooD8Bayqxu1msa5lBLpadnvYWcyvkdEcgimLpQd9vRvxYGbRpsfQErR0/hyY4H7JT8XRWjGGFHOUiznhP+H9s15i1QCOWhmo9iBR91+QWjGWln42owd/YwxrG9tKlALG0xPLdw6vHxliYcxa/S3Izb7Pw21R2wyYh8FN95I+FZ9mM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(86362001)(83380400001)(956004)(2616005)(6486002)(26005)(66476007)(8676002)(66946007)(54906003)(186003)(66556008)(36756003)(53546011)(38100700002)(16576012)(31696002)(508600001)(316002)(4744005)(6916009)(8936002)(5660300002)(4326008)(7406005)(6666004)(7416002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFwMXdqTEpabGhURnFjY3V6NU04aFlMR1JmOGhHMVJFeFpRR2NYUzh2VXdu?=
 =?utf-8?B?UDlNWDRRdmlFbkR3eTJ4dnkyZEhDU2xCWjJOQzgxbXpFYXlzazk4ZUs1d01H?=
 =?utf-8?B?VUhwaXg0Um1XM3UxYS9UeVRpbzdOVFlENy80b0tFZ21DelBYTFZ3Q1FaZDNQ?=
 =?utf-8?B?YXZCWXM3VW1aRVRaYVBON1RrYnNOLzNaN21ZLzNxY1U0Yk9VZk5EcXBGUG5V?=
 =?utf-8?B?NWV2c2p6bWsycmZXelk1RmRjREEyZVFhOXE5c2JraytBeVF6eHd5UGsrYU13?=
 =?utf-8?B?ODBVQWppNkFuZmgreXB5akVhUDVHQ2h3UTJKREF3Z0dHVndrYnBlMVBnQ1ZR?=
 =?utf-8?B?ZFhmdDc4aTBlbXRVUzdxK1ZaS3o5TXdnKzRZaXZVakpmMVNPWDJQdG9oZFpH?=
 =?utf-8?B?cUxTdncyUGV4M29YMVhvNmVGdXhKc1RUTW55NWREeUthNnd5SUVGYkVOR2xE?=
 =?utf-8?B?ang5YmtiSUsybGk3MjlWNWRVZUtYem50WUV3VitZYVBrcHJnMk5vclRQM2VM?=
 =?utf-8?B?RXhUZStwYi8vQnpBWi8zWEVIWnczbEF1S3BNSGhXWnRURklISy9WcU5PVXN2?=
 =?utf-8?B?R0svdVpJa1A5UklIdzE5azYrdUF5aEVVK2NpYXR0aVdPTE9sTlU1elJVa3Vr?=
 =?utf-8?B?dHJySHptck5VOGxrOUxHcURReTlwSkFUQ0dpQ3NXTnNvWEZKc1Q1aEJhTmRQ?=
 =?utf-8?B?SHExb1E1R0xwUy9kc1RPeTRGbXFiOXBnWnJsK0xnRW8yelVKOGlaZ0lORk0z?=
 =?utf-8?B?SGFEN2F1Y01VS0ViSHFQZWZjVjNLMlZoM3hLaGdXb2Z1UzVGcmIzUmtNRjlZ?=
 =?utf-8?B?YXJJeVRHTDROR3FCeG9MNHFqUndmKzhQVktiR0NqZU1kd043OVVXckp4SDZW?=
 =?utf-8?B?RkVBOElWbDRqcWtQeHdIT00zYjNoT21OMFA1Z2s1MDFiOUsxSDRuUHRSamdv?=
 =?utf-8?B?RXBHMUs2RERoWTZrQXRhamFjUWZNeTdVQ2RDdlVnOE1YcFhOdnQ1VktyRkdK?=
 =?utf-8?B?VXZRd2ZvUy9jWkN5VGRuclE3RUY5S2thSXJYNzBZOERBNC85ajhMS0FPTFUy?=
 =?utf-8?B?MnVsL3lyNDhKSFhaNGdBZ0xNSHpMOVVXdTN5WVB6bU9EKzVUVm52RUtMcFY4?=
 =?utf-8?B?OG0vUXp2SmhMUWlwc0dRcUNaRk9vVlN0Qk4rek12UWR3eU5idVlwTmhOdldN?=
 =?utf-8?B?ZWZBemEyckJYcTRKRlgzcTJUOVRlR21EOUVIY3RmeVFLalVqcVpYWGR6anl2?=
 =?utf-8?B?Q3RQckxxVFg0NzZGNzIvbm9IKy9Zc1djYUcrbTFlTEdyT0lrVS9pQjZoR1lh?=
 =?utf-8?B?NzIrSjVRY0xLVHJzSlRTTTlHKzRidndET21FMlNZbXJIRE11eTFKR2FCbEhB?=
 =?utf-8?B?YjArNmxRNTBiams1b3hMcncwelVGV2F4M011QTlkS1R6OFNsMk9CT2pGMTE0?=
 =?utf-8?B?NmVmKy8yTWhJdmhZT2ZmeVplRXFWamNOSDMwZmhKcU9NNGNFV3JtSndvWklz?=
 =?utf-8?B?ZFNrZ1hSWDdyQmhZcUFveC9QaThVcXpaK2Q4SkYvV1hNVktSeGF2OTZyb3NE?=
 =?utf-8?B?djBkWm9xODBsdzRnUHgwMHJBRFRBdGVlY1FHcU9lQnZpMjVGeWxVQ1VrRmk2?=
 =?utf-8?B?M2txQTQ0bHF4cmNMMTRycUgrcnFDb2NyQ3hndGlZSHZMYU5FSkRhcFlEcE1u?=
 =?utf-8?B?TU96R3FjSVZYdHVwa3N0TWFrUWpoWlpTMHEzRjJzV0Vremg3bS95S0RFeEQ5?=
 =?utf-8?B?ajdZelB3K2lzeXFlWmUreTNieUNxUHlSZUVZdUszbTdSc1VjZTJ5eGVreTlr?=
 =?utf-8?B?ZEpBZmhrbVhCZ3BuNnVxaEZNVEowdE1qcDVtcU9aTmQ0UEErbEtOOWErd3c3?=
 =?utf-8?B?b25RVXdXRWUreUZrdlAya0V5NkYrTmpJblZoTjF2WHhDQ01IUlg0c1p1OCtM?=
 =?utf-8?B?UEpMRGZNUmp6OXhsdTdVVEJFRU1xa1lPZFNRdmFlOGx1ZU0wUmFlKzFDR2FQ?=
 =?utf-8?B?UFlrNWxWNzhtcWVqRHExWjZzcnlyYU1XLzIvY3Z6dURqdjQybW9nU3ZXVEJM?=
 =?utf-8?B?cE9zZEVsY25ZcjlFYndyaTZvQXR3YXVtcW85TzNISXhEVnNFVUxJdFkxUnBF?=
 =?utf-8?B?K3lPU3ZTUUpSL1Q1eDFSWEtnemhyZ0xTeU9xZUZBanZiU0QyNUpNdTNXbkRV?=
 =?utf-8?B?M04rZnlFa3M5TEY5LzNjWmNnQ0dQc0NFV3plWkhXVHFITVhXSFVJUk8rQUVV?=
 =?utf-8?B?ZEZmeEVXS3NBa1gxZ2Jad3Z1YzhBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3441a56c-32ad-4a60-3844-08d9a31950c4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:38:57.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jn6egdifO/4r7HRHAGMoHprYYlhZZeK8Is2aykeIaw3ds59BjkacvoWUQz+BZoKhHr63cMYKQvWFcv0MGUs5QXhYcIaxvMfNPOSV5ck2NDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4972
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: 5uVYKBidq-XfHMrMm_54fUal1SAStT6s
X-Proofpoint-GUID: 5uVYKBidq-XfHMrMm_54fUal1SAStT6s
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> There is no need to copy the whole memslot data after releasing
> slots_arch_lock for a moment to install temporary memslots copy in
> kvm_set_memslot() since this lock only protects the arch field of each
> memslot.
> 
> Just resync this particular field after reacquiring slots_arch_lock.
> 
> Note, this also eliminates the need to manually clear the INVALID flag
> when restoring memslots; the "setting" of the INVALID flag was an
> unwanted side effect of copying the entire memslots.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: tweak shortlog, note INVALID flag in changelog, revert comment]

This updated patch also open-codes kvm_copy_memslots(), which my
previous version didn't.
I think it's worth mentioning this in the change log, too.

Thanks,
Maciej
