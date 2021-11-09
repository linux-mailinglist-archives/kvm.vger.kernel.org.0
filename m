Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D6449FD4
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbhKIAoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:44:34 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:40872 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235407AbhKIAoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:44:32 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9028dE010234;
        Tue, 9 Nov 2021 00:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3njnT6Ptzi/P3s8Sbbrpdp/sfSC/YPBZ5by8HRF4w4c=;
 b=TrMADD2uaw4Xbt3fe8D9PExAlDh9MtyofndAYKNMCCcaKy0aZO8HPBXve0y7riehvuqc
 DoI6e1NZnbO3Z3x65OPPOfoa2F3SZ2Fiz0AcAwoNI0qDapqsD2iKKjSd3ycOKNe6gxO+
 0oTvTnoWgKqWHDakBIghzYlyVg1wg7bbpubMz+QPsY8IGdXyRUNzJp20cAci0lUng99v
 JQUJBpixV5SQCRbRRK8cWy9YvxG3tOb1esPkSo7UbZM8guhuy+h8gPkZy+o9xVl26fpg
 rtGeNEzYkJbHk7rYIJU1moODAcy+hsNSF6qmC1JsTSNBBRlXU0+OFADu25WdCyYSuJUM Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnfjuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90ZwSx132417;
        Tue, 9 Nov 2021 00:41:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3030.oracle.com with ESMTP id 3c5frd6unc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwQCd4FuMIuw875Ckqh96kdSbGYyCzApRRaxHGbSlUE62ZJIA4Av750Dc3EP5O67f48mAy0oKBYr06K3e+BOfIEO5wo83QPhh2EZvgN8qSdsTveP19xFQmf+OA670z+dqO1jIqTIBpsEZb+9ZOsOBoTXpgOMcflUdfOk2RmadR7jyn6QEUvq0XKPafQ7cFSPWhxMSx+srI1Dxbs1/sA0KnPzpwV38n5gSz2gCQ0kJqpi3GmUADp8gXMxFhOSBRDFo7WF7j+IkfC8Xe8odinK8TIQBOhebTQma3xyg/vvw9evD8wadIfjcvKU17C3gXe5BanO3rqICmxUitIQKG74Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3njnT6Ptzi/P3s8Sbbrpdp/sfSC/YPBZ5by8HRF4w4c=;
 b=TfYtv9cjyhMVknVdTE5l8QOniXcmzcCno+hFMaytL4OIJf9mq40VZMfHeIk+38WFJRZpMTRHCbOc7QiAnHeFg6IqaXAu9YUdSdfCz8kpmGLiLskL69HgEbNFk+G7lp7WKlCX6XFWW+QYgATZMo/fTYzfdvKFCKjTKUmBYwk4GE+Pu4H9xTT/Ebu5B6EokXc33QvOK6sIwcPjGH+sAecmv9IdBe5+7+8FrTR8/YiyJGmwFuCIXVAWJlSX0EdnWHVQlq55Gef1fEUKzwlp/5GyZPY1pDssWo9JRIFMCZ6iVuVS43Z2EMo/qImBuzRo87Tb3v5lg7LZC8j9GsV+LDNqWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3njnT6Ptzi/P3s8Sbbrpdp/sfSC/YPBZ5by8HRF4w4c=;
 b=seEgMHkiYaN0Ct6ek9XwAC693DWa0WsTOp9+WAPOhMueytU11rg/iqtC0AjwpaeoQipxSKIAQysCYZQHqzpUKx0Y0BCkJ7VGkx9GlfbKy24Od7d8Pw5paj6WHxKz5frNWVNiatJLuddkQX6CReqUJUmizNn6JFuD427ktaZLalE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:41:08 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:41:08 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 16/30] KVM: x86: Don't assume old/new memslots are
 non-NULL at memslot commit
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
 <20211104002531.1176691-17-seanjc@google.com>
Message-ID: <623f2d6e-6f75-03a9-2932-61190eebd30a@oracle.com>
Date:   Tue, 9 Nov 2021 01:40:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-17-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0002.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::14) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM6PR08CA0002.eurprd08.prod.outlook.com (2603:10a6:20b:b2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 00:41:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f02a8c77-3f78-416e-69f5-08d9a3199e6b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5273350B8A23AFF43D753E62FF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkigdvUPp2bfJxuRn4LIKOh8vmFFxjKH0eNg8mwF+T/iqw3uoHFVOlj7TrHZsg1uubl00vV4wRTebIZI5XlbASgf2V8yiQiFdDbd8LSrHhkB2ZAOO86zCKlTNOXkQJ02nYKa27lCM+kRZafw6N3ZMKlYDIWNG+JQOe8riOBo73zxI8q3fmz8DBNKzdxxkR0ZBwyOCAUEgYV2MEgEvAuob5Z4Z4d6Oa70dpjJD3b4q/XO3YpT2/gRwVoUyxtsMPA6bcn1Y2C/RK4axj3BKCIytkIfGHNvbwIg9Ble1RGbBzmNSsUhzicyj2OI4XQwOac5HO2hTM35ZX0EAsQju0rDD/qWeTC5eDUUQu9WK31rkIkbs7o8Imtxj43aCXyEIw+geFxOvg8k8tO2TesuNH1VJo7raFTT1JW+Q6PpykXTwivr4BYx9MtGPVvP4/FdB/Y31v3V3jL0AGrV1Ey5ioanQPxSsaFmypRw8scNuxjzS4IvD+eoTvlZB8+sRmTaQY5vTo55IZ8YLBBXNcpoCdAvmsdbYeM9XgDtQX8qp4IOi4MoKWVmJ31TFaXjnjyrfvL7AYVuFHLNVgb0usjkjCw2OmhNocmhc9bBiX9eNLT0fQt/9cIBz3SuI8W8sg52eNhy/qAi3SI/5Kw2jDJqvTgXKu0qLaXbzSV5kFi/OhMx/LJytAMRj5J5jLyiDCVA0aA4PTIHSBWn+dchftE9K2TzLyMaouCDhezPH/v8hF/yco8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjFQakh2STlwR2xwK0h1Z2VablZic20yTENPRHhTUHBKMWpjRlF4NlJpdGZ2?=
 =?utf-8?B?YlowV1NXUlJVUU1KVmliNHJFdHhpaTQ4SEtTcXExdXJzV3pXS29XOTdtSjFW?=
 =?utf-8?B?Z2MyMXFRWDlIYlcxQmRXWkl2RHRqQzhUWVV5YUFULzdGMWI3SHFaZDRIQWxL?=
 =?utf-8?B?UkJ0ZU54elFIM1grQ2JnaktYRytGR1dsOUVjS0RkbkphR2lKVmNza3ZlZklI?=
 =?utf-8?B?eDVUN29oeGRlTENDb3BPbWxPdlIzMGpYUU0ydGVKamp4VkNGUld3dzFuaEFo?=
 =?utf-8?B?RXVQbFNSQmNHVHdRQWE3K1BGWTdpUW5URU4zN3FmOXlWcWJpRThIampYeSs2?=
 =?utf-8?B?T3lqRXNTL0pwVENDZXc2QlBveHNEdmg4bGNrSG9UOXlvd3ZlSDlXREdxRmZ3?=
 =?utf-8?B?bjNwYm1YQU44ZU8yUFRla0ZYRFdHNnRYMU1EQmdGN3VtUWJieHVLS2ttaEtl?=
 =?utf-8?B?dWhMODNNYWpMQWNTU3ljSlliRFFZSmFsMUdKSkdlc1lOTXhKa1ltQ1BRMmRi?=
 =?utf-8?B?OVBUd1p4anlpNlpyM0I0V3dleTVOM1ZmOXhPOWU4SUtHQTdUbUkyRElycUR3?=
 =?utf-8?B?c3dXdG0yNHRzQ3Q1eHVzM3F0Nld6azVpTXVxWUFYVDVIOStQb25tWTNlMXM3?=
 =?utf-8?B?N1BldHdyS2VhMnBHQ1lDYzBUL1VOckJBbnpNUjZpWnRiblFCYnNHNmRoTTFC?=
 =?utf-8?B?SWtCQ0hZV2NaeXlNaGRhNitXWEdZUHJpaEh3TU55TiszRlB5R0tpQUZ4N0xT?=
 =?utf-8?B?dGUrRzMxZ0c4eUlxVmRITmtIOSt2dWpmWnQ5NGdYZ0kxSWpEYlZJQ09aTjdh?=
 =?utf-8?B?bFFtZGJwYm00Sm9aWjdqLzJOcDRhaXF5S3VWdEpVVXpGSFBRVy9UeHd3djJY?=
 =?utf-8?B?VzlyZ2hFTVpYbUZjWWZyWHJwUjVDYWJyTFFkbEpUMFFyOWlOK0pHbjlLSy9M?=
 =?utf-8?B?cmJOSEYxRG5oNzQ1VXdJTlZGWkpWeEtleFZ2SFozQm5Kd0RSMUc0cG4ySDAz?=
 =?utf-8?B?ZHlQRUVuL2dzblhMT0xGa01nOFBjYWJRQVBGRnlRSXYzVk1qam1SSVAyK1ZX?=
 =?utf-8?B?Tk9SM3ZZRmpyZVhvTVF4ZEJtU0IzOUlDc0ErdU5jYzQyVUZweHRtSTRUZGZQ?=
 =?utf-8?B?RGFoUEN1S0hWNDlTS25ZZERLcTlNc2NPeTE4Q2JoN1c2bDBpWldYYnUzNmhB?=
 =?utf-8?B?LzNGbk1QOXNlSnhrTnF2Q08xclpCaXJITlQ5cDVTcHNxZnA2WVZ5T2pMVWYy?=
 =?utf-8?B?SkVMMlYyOEI2M1M1Vi9YdjRkakVaTkhGQ29ZR3hrbzdMSWRrS3RrR2NXNFpG?=
 =?utf-8?B?UzdvbkFnTkRqcHlsekorclRydzkzMTRBRWtZajBBdU0xQ0ZDWjVHUjQ0L1Rz?=
 =?utf-8?B?dzFqd0hSNEp3NGdCcGdzVjhmNUJXWW94dHhXUkFaMFJoczZ3Ym5PQlduVnJV?=
 =?utf-8?B?b3haS0hRR0tBNFdVU01SaFlIZERZYWJHSFN4Z3lSVFdtNTV6Q2sxMDZkZWx4?=
 =?utf-8?B?REhvU3piVGJ6Tmxiem40ejNZV0xxODU5Zk94YjlzUGVxN1dwalhVUzU3Z09q?=
 =?utf-8?B?RS92ZjhkRzFRUkg2Zm9oWldxNmRITUxsVTMrd3VCL3h2VGxnaCsxZVY1STNo?=
 =?utf-8?B?NFRnQlpUbjFQV3F1bFlwMFVTRE1MT3lLRUlySWxNZWl0WDhGcW40OGdPZFJK?=
 =?utf-8?B?NXlOZ0xVOUYyU2xMMUpHSGJzQlJLMlB2SWRFcUdyY0E2dk5vN0Y5Q0t1M2Jw?=
 =?utf-8?B?VVZoL2pMVmplV2FybHI1blVqK3lrQ1NsKzB0T0VvbUNQL0VIZFkyVzJGWFFG?=
 =?utf-8?B?RFpqYnhESkRIOUtIU3R5eTVGVmw5elROZlcycC9rWlpTRDJkV0tJemRkdnRj?=
 =?utf-8?B?YzR2ZGJtaVBuZmh6UUN4QlpNeHFRUlJXdHNhd0tIUHRzWk50STIzTW9hcDd5?=
 =?utf-8?B?dVZOREV5WCtvZ3VpV1VXSjg3S1hpeDNoNUVnb1llRld2Tlh3OExCb2N5dmd3?=
 =?utf-8?B?TkVBOE5rQTEwVWxLNDJ4TjRzeDNCVTFmdWgrTUlFOUUzVkk5OU95MjI0MXZn?=
 =?utf-8?B?eHFYZEk5UWVzQkMweUZlM285K0lwTDA5ZjdTc0VYZ0RwbjRvSTJaRGs5Vko1?=
 =?utf-8?B?ektlZ0dmVysrS2hieTdlT0pybjJrRDV2SGJZVGR5SEYzUTArcjcvQ0RrK2ha?=
 =?utf-8?B?MHZ6LzN0NlhsVk1XYlZwOUZLVXFMaHhCM2NSYkx1TVNhS3l0bXpXWWs1eVdq?=
 =?utf-8?B?eklkVmZ2d2tjTThuRVVscnhRMXFnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02a8c77-3f78-416e-69f5-08d9a3199e6b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:41:07.9913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5clREpClXIKSoVyBVw73jvlgdlVWrdL3tUW0h85cg/XYDM5uZYhj7KDGCVryKWb5CG84jdEqsXn173KOr0oedFR5K24CkmfKspaTvwREYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: PoJFbYJEWeqJE3HC_Y3qRNwWDif6TPGR
X-Proofpoint-GUID: PoJFbYJEWeqJE3HC_Y3qRNwWDif6TPGR
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Play nice with a NULL @old or @new when handling memslot updates so that
> common KVM can pass NULL for one or the other in CREATE and DELETE cases
> instead of having to synthesize a dummy memslot.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
