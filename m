Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836E144DEC2
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhKKX5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:57:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3404 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234507AbhKKX5M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:57:12 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABL0kiE015490;
        Thu, 11 Nov 2021 23:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=883xBD/ihbbKgrvxwcqQpMp87eJMnWmZjp/dnSjCn7E=;
 b=zb1+D2k9w//noh44Q6iJA1bh5+CMBMg+hX4GZIWtap+GcUv6xQQcGY5562lYKR7EaOdW
 zowctfBtbP/qgGvp+18tuEujnLNRiAfPnpT/7TQjnC68QV6SK+HIyrh8gyXwZLD9o3o8
 x52hWkUcwCK3gFpeJv3ODNI/JmaVmPRu3y9QNhqGwxD57XR8xXYYZws2hKYZraJNKBim
 nnk7fHagxB0bbsj7z1vEBDXsCCKh8obOVhFSAYz+CIfRUYxQfGbfHayvJBeT0VmxEPE6
 uyF4Fton7+E4GrBIXRA5PhndqVzk+01Vtrpudd2u4ZUztbXn4H/8w/9eAxHId1D6/tTG sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7nt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:53:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNonOj143714;
        Thu, 11 Nov 2021 23:53:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3020.oracle.com with ESMTP id 3c63fwthxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSbZCDht2PBtGeHl8GWD+6lsYCh1m0gNjRQ3y2ZFvgyncIWN3PNxzOsXVS8RFE7yF4g3RC4G6RRgOs1BUXsFAXFmM7xJl8nQAxLKlPbSelP0zhQazw9b5D9mJmnMUNOukBUcHSqQDSVWEV3pb74NFRLzb/fHHlHLFTkmh1X8Ncq6i4AA5y9C4rypPkl/8uioS/UUtzQKQS55gUoyWo6XZmlTtQHiopEl1bOuykR/HYJHzMb/7thQFMGr0H8fK6symKNVNQl7Oz/MabI/KLs0fo/PgJhrIsUowKTkPfBdtIscb4AdiYQw2PUm905bYmF6DEg1FgK0LRsWRt6Ta/b4rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=883xBD/ihbbKgrvxwcqQpMp87eJMnWmZjp/dnSjCn7E=;
 b=fk7qoWnDbxydHuMrkiIaRuIfdttHfArby4c5IoqcZmrchWWNGy25V1FeLk1GAa3U9WornvnUQIL514rui1JOjxrCuVQDr6jYCFvzytpFYlGbCwt5VuXsSVbycuFKkuaJfnZIU4kC0t/fmziYWQLrdURsRVdeCzHShQrJTDINMb2HikYGW25NZou2Ep6zCL4K7JsxD0Nr1r+PV5mboBFaeam9xUWWK5gK8ca1paPu7b2CHDaMzMU7lLnGs+D0sfa3t63GZUs46bEjemJLvBKdOInK8WUMlOOmBL1TMyMOqqQwvMk3Mdu1PJaz5ifAX+PWNpaioYSgUtou6IQOalq7xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=883xBD/ihbbKgrvxwcqQpMp87eJMnWmZjp/dnSjCn7E=;
 b=Y58OFnFlBHk2BjjG9xOQ+Wkxb4TUsyKe8U4xq65EFtwxjnYcEV/H9pM+78/k6rUad/ojvzE0anCzp8cORH4PKvZfE3/klsLl3ytvElf3suO293xK938dGbaPXAvjmwdgmFtU7XyxRDjWHzcI4g1q92OPU4m0h/oq/43yuKUPhkE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:53:38 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:53:38 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 00/30] KVM: Scalable memslots implementation
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
 <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
 <YYnNA5lZNXXdX/ig@google.com>
Message-ID: <f3bc3bfc-37c3-bbfd-25b4-ef0a72e534ba@oracle.com>
Date:   Fri, 12 Nov 2021 00:53:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YYnNA5lZNXXdX/ig@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR0202CA0042.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::19) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AM6PR0202CA0042.eurprd02.prod.outlook.com (2603:10a6:20b:3a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 11 Nov 2021 23:53:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c1800e9-ba52-46f9-d908-08d9a56e7b3e
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB49385F981B74133E932D36FAFF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Px/GRps/nTCCR4Dge/vd7jZsPJ4DwTc7yH//vBeCNyIpWZKBI2vNIa5nl6KVr71nzEkO0PBzXr0rJpGmBWtyJuLSZ26IYejF2JpqbC2XSfSsMTkQH9TE5GKU9YPuYubcMpz3Mci7tSdAEyy8Ckedczz0LwTxn5ynK9CJejHmumByYlbKN4xRECSAINvQU2qIBZbUmktucn68+EVK86U3q7oZrMiZTvKf+p5KUF9ACpcZRS+qIwx8sWM7igfINQEkzOxiq1mTTb3Bvj5ppQjgJKecED6PH/Cd5zUAt1NQgHSHAlpBX9FqMC6tfJXaz78rLjbFEkM0EGuAj+YLfkLJREC7guDrTUez+A7bxPdGQXXxtISvQCQWzKt3HYd3F3ZiDT5tfyvSEc3GpDwxLfaHCfJuJjnys/4ljm0v4tpw12wiY5jWv1s/Z+tiNRnFKIbNvBcQaMvhvx6ENa2g3pr+S6dBsTg5p8tlhUl0bu7ye+0b77MDiC7ouarRWnIDQOb3uVbMyehoRUd/Z1/a0cAtWsJPprKi2UnXuio3OsJ1/YKTSRcxCTECBRHzCY3WITT4FAAptf6S3tUz/nY049zXQv9gbyOJrM1FWC9+0hbyb1tUnwEybu+skBvGdi4SqnR5wpBfdjrvA3KykMdxvns9wNuOjy7Zy7oZLOkWYgNNYBCfnhUBd8orn+SLOlxF5Yt2mR16uSl1JacbeycbuLjTEnad5VykjxKGb2VBbSE5E8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzZTcG5hK1FnU1VxSTUwcjk2SWxhc2RNNFRrQ1oxMkQzOW9zdzQ3aW54WDRt?=
 =?utf-8?B?RnUyRTBBTnpZNHpoektvUzhNUWpZTy9OMFk2eC9meks5YzkrdkY1NDVxUHlP?=
 =?utf-8?B?QitvL3NDTlZPNThpQTRDQnlPbS9LcjBEV2lZQU9WWlRpaysxOENxc0h1Z1dL?=
 =?utf-8?B?WXFWMUdBZm02Q3pOMlJTSVJVRHREcnZrSlZjQml2N1N4NVQxanBpdkJxVlZ2?=
 =?utf-8?B?T1pQLzhaWnZJdXZXVksvUkxKY2lKa29JckxLWklyY0hrb2VsTElMOVNEWmRr?=
 =?utf-8?B?VDNaRS9tWnRyRjZhRDlIbS9NbEZtWkMvZ1hOby9FZE9COHdnWDZyd3RERzVG?=
 =?utf-8?B?dG0zUUhDUjkrc2lJTlNab0p6N1VaeWNlWHBCS24vTTRGeHNsRU1pd2pjNkFi?=
 =?utf-8?B?S0MvVlc4RUp1bE95d0lJcVJRTTBnN0JIeUs2YW4xcUl6aXJYU3V5K3JhT1hv?=
 =?utf-8?B?QUtXL1pKemRrUGJVdXZWdWRLMllLQUdqbGdVTyswcmRpS2k1NnJEUWNzMWQy?=
 =?utf-8?B?bWZIWWt1dGRwSS9SNm5uNHFGN0tvclp0aHd5eE56aXVHL2ZiemhpRDJqTDda?=
 =?utf-8?B?eVd4YlpSMUc2Rm43MmozajdBbTJwbVUzM2s5RkhDMVZpK3NwdnVPSXdoZ2Fo?=
 =?utf-8?B?cFJiSlVROWFQK2JRZXJES3pEOUxBcFhTUXBEdVR0V29EcnpoU29JekF1RlRh?=
 =?utf-8?B?eXRja2JYYXVGQktPZTBhd1h4WlpzMDR0QTRCK1FJcnNoOVNRRHlhT2lDMVVZ?=
 =?utf-8?B?ZTMrZUV4Vy93K0R1QURsaktMY1l5VnlmUkNzaWdKdUxtMXovOE96MjhlUnJM?=
 =?utf-8?B?YVlaSUxSTG93QlZqWUN5UkhQWEdJQXA1Nk1oUEhBcXgzbjFoQW8rcEtHbWs4?=
 =?utf-8?B?c0hybVYwVnJDTmx2MUVqTks3Ykg4YUVDMVRJRkwxZHpTb0doRlV0REZhTVJN?=
 =?utf-8?B?Zmhna2VNZVVXZWVseDUxbitXc0xKckJMODFDNUtSOTNlemlJVXpxcVNaYjV6?=
 =?utf-8?B?S2E3VU5iUW9kek5DN3czTW1BVlQ5TXhJMlYrRnNXNmZLQ0FOcnAyVzRsZUkw?=
 =?utf-8?B?SXZseXRBdm82Tm9sREFrOVZ1ZWZEL2JpZzBvWWV6TWpodDBoWmVkRXV5US8x?=
 =?utf-8?B?azdvRENFcER3bVhEcHY1ZkpNUzFXeXlKMXZ4Z3c5aEdpejl2R0UzTEtYM2Vx?=
 =?utf-8?B?TVpPdzNxMmpma3hRL1l1NlRmWURqRzBEV3dFU2RJblVYSUc3UWhxTHdWd0Fp?=
 =?utf-8?B?aTE3eWJjR2tiNnhIZjB6RXZMQkpHaWYxYXNEZEVDTTk2eFRiZmJIK3hnbHJ5?=
 =?utf-8?B?WGZwQ01OK1JFRi9kVkRTbEs3Q1JsTjY4OTl1Zyt2OXdXaEZmelRiVHkrR0dR?=
 =?utf-8?B?U0hVdGRYNXl0QVJKSlJVdVNXMktMZ3RQdlU3MHByWWw2a3o5ajZyQ1ZrUFoy?=
 =?utf-8?B?V3N2NUVGbVpTWVVEQlYyQ1ZCaE9EWlUyOHpFSGFueTV4Mkt2UnhYQkloQko1?=
 =?utf-8?B?dUJ1amxMV1BRaWxueUVBREhFZnJJK2ppQk5RbUhGRkM5ZG9pOGRuVno4ZXlR?=
 =?utf-8?B?dmFnanpuZkNta2psMG0zSHEwaGR4QkJLbzJ0SGlxZVgzdVdKTVhhY1h6S3ZP?=
 =?utf-8?B?K2JyTWkwOExmRng4U0lIQ2N6WjdETlhTbkM2a3dZc0dtVGM1ejNjbDE1bDcw?=
 =?utf-8?B?SUFEcHY0S2dPUngzYkVnOFVVTFU5eVVTV2RVcVpxRERITzhoODl5UElpeHlV?=
 =?utf-8?B?S04rb1JRWUFlVUFKSFVNR0wwdCs0Y1YwNmpFdEpFUm1qQXJJZS9Ea0RJSXZE?=
 =?utf-8?B?NTN3Y0ZPMS8xVlJQbVVvSEhuTWFGQWdwU09RMlNOMzVjRFpveXJ6WmFxR1Yx?=
 =?utf-8?B?SUpTMjJDOVdrODY5Qmw4ZUpoaVB1VXA2NmhGODVuZlhtM3J2MkR1cUdGb2p6?=
 =?utf-8?B?RWZIU09yQWF0MWNjemhTVTNiTXNvTXJ4dytVVm44dVJyaFZrd3VUbzhaQlRm?=
 =?utf-8?B?K3lHTVRaTnY1aVBKUDNxOXh3eFpWd3JndkZFUGZuOElOeHVtUEJpMm9KOEhs?=
 =?utf-8?B?RHJJR3gzTXhYNC9UMndRNWJqUW1Zek9yeFQxbnhEaGNYLzFWQ0xnZWtlMTlz?=
 =?utf-8?B?N0txL1VTa1oyOExOM2lpT0svUWIwUXRUYXZ3VlJxdjZpend6S3dsZHg5OVhZ?=
 =?utf-8?B?TnFlS3N1N2ZNS1RsbHJ0aFZQSXZXcGQrb3A4a0xibmdCRG9VUk9Id24vVEdv?=
 =?utf-8?B?eHRFRTZqZmpTV1RURnRhVTYzcnpBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1800e9-ba52-46f9-d908-08d9a56e7b3e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:53:38.3387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jvqnoe+QG8zqEFHExkEA4QNwAIYcW2RZKQU/7XZtalMVvnk4dWhTGqKA847ewg2GZrSmC+2+TwMyNsXR4CVwo/lieFkKdL24KAQNBlB9mMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110121
X-Proofpoint-GUID: EnCa112P2k9mAM_mwzLcoUmdfrvHPwk-
X-Proofpoint-ORIG-GUID: EnCa112P2k9mAM_mwzLcoUmdfrvHPwk-
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.11.2021 02:21, Sean Christopherson wrote:
> On Tue, Nov 09, 2021, Maciej S. Szmigiero wrote:
>> On 04.11.2021 01:25, Sean Christopherson wrote:
>> By the way, do you want your patches and my non-invasive patches (patches
>> below number 23) merged without waiting for the rest of the series to be
>> fully ready?
>>
>> This way there is less risk of conflicting changes to KVM being merged
>> in meantime while we are still discussing the remaining patches.
>> Or worse - changes that don't conflict but subtly break some assumptions
>> that the code relies on.
>>
>> For this reason I am strongly for merging them independently from the
>> more invasive parts.
> 
> Merging them as soon as they're ready would also be my preference.  That said,
> I'm hoping we can get the entire implemenation queued up for 5.17 sooner than
> later.  I'll do my best to respond quickly to try and make that happen.
> 

Finished going through all the patches, with small nits they do make sense
to me - thanks Sean.

I will prepare an updated (and tested!) next version of this patch set,
however this may take about two+ weeks as I have other, more urgent work
to do right now.

Thanks,
Maciej
