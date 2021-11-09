Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2FC449FDF
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbhKIApa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:45:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47560 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234370AbhKIAp2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:45:28 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9028dR010234;
        Tue, 9 Nov 2021 00:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Bm+mAC3d76RWBoTYKke/glnHHsUOItRK/TffVledKkA=;
 b=1FXMDiw8iQjoT+yapivIrTwArPyw1Jm6tY0TDtYLtDD5vu3zEk1dXjROoIka5TCxoCV1
 hEqKIFMYIpniWS3m7bbHNjKFAfSS73EMPk69iSqWLLl5ctcWyWkPiMb+WJpGAC7CY5LD
 SWHLpsxmkMuq5hxoAYcN14qgZmbQUNeXxoMeYGhnXIsJTP4HeoWKwBfJYlnmcmmIJAi/
 xk5oP3Vt9wmLsdYfDaeAYa3FRvS4Yryvs+0BBoIULb5JWetXCG5a8HeqTwaK3RVjOUez
 vTXbHEfp7r1dJswzaqpVmBnFP1xBSnHYm75vGOXS/Fvdmje21mgELZFYZw7w3BQtxbMk iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnfjwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aEfs062830;
        Tue, 9 Nov 2021 00:41:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by aserp3020.oracle.com with ESMTP id 3c5hh2v7b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gapewEGjMr6+4m1IcxjIPjYT7sTxV7+STZzc8rVu56jfio5jj50O1cAhlrC7giNrFpo0R14yy2ZX0aKnInLSu3IKZyA8S+1uhBneTBLuZiiC3uDmGlWAcbaeb/GZh74e5T6JBAg2cXdpXgDji8RoXX9dUjPaLmue4POxf4ui3vQrm8IHlHGPV3hAs6xVys/HUyXdymcEVrSFqQhcDUbJRLPT90Z9M3KzeNFuP7lnd1IrG/o01DgPoQN6ajltF85IKxgbmPrBaSYN1eV2SMBnkyVwpH911V0AOwSM5I5kImmo8yKwpJ9W6aYDg/Vf8J6OVqvyJc5gfonGkenETjweRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bm+mAC3d76RWBoTYKke/glnHHsUOItRK/TffVledKkA=;
 b=EeL3dO4UZ/awQyqNNtWP3G9vX6i0szDMyT9vDk9Dmop5XdlH3+yvsb1mMLfljj9dvOyJUBKgMQx9O2xaTqTEzleIYTLQiMOyg7cQlTjOIkHosu6M575BDG/XzKZjnQZHRRK/zhCwlnJ0fXQktCwkDJ98N9MmCFZmqtxbyRK9yrrFsyPWzNlLcr13eEIkj+KIs6vTiuLau9DtBYN/4uRSpxuIBrJuvhOUxdVMGZytIQ0LrPUb44vQlo3GkkTIqp5mHsjHl8Lqyo3xTZePHPWcOyFZnklmC0o1t8rbX3WeNzObpUvsXYqyedoPozKPxh2bmwdaapREiMExBvvcOXdG0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bm+mAC3d76RWBoTYKke/glnHHsUOItRK/TffVledKkA=;
 b=cWRk5D7IZYwOwPjsmXMMdulKSPyY66K7oSmbLq1c3+9+8NKekqsbQQpO4OZa75G3q7DK/u8ZMoy//hXfr908cEQvoAw9pNLgSPDjXx0QcBaQkrC+f8zH4scQwc3mro6hTIvFU/+2bZOzxaNqJLAp5hUZUJuTfTcaJeabhKs2Amk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:41:50 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:41:50 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 20/30] KVM: x86: Use nr_memslot_pages to avoid
 traversing the memslots array
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-21-seanjc@google.com>
Message-ID: <88d64cd0-4db1-34a8-96af-6661a55e971e@oracle.com>
Date:   Tue, 9 Nov 2021 01:41:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-21-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::20) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM6PR08CA0008.eurprd08.prod.outlook.com (2603:10a6:20b:b2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 00:41:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e2a617b-9ed6-460a-e683-08d9a319b7c6
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB5273F70DEF5781AED56989F1FF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LafLw9XABhqFNxIdYgqLDc8h0EmFhsmd97fPTnQ4A9t47u8exmBpaLzLFI/pBeHLq6LazJSqRMEFxtSCMyn6KOqjKn5MDUDftmIXz3P2FW8rv+R+844zGGckifwytihh4SFHBbvpb7zJ+UN5UjeXSJqQ4isC4vjEiOYD1Cbr5diJqdvWUA4bsa9pycBg+hDpkMTHFHWTqt7gFlcHxDlYxMKRK/KwQVwpRK+XZ7Wpghhgk7Bidg5CQ6/x7c87VWW004v/rxHDt1ADFykBAdUuOm3kE/ola8nKe9xkPTHNYTba3y+16uzsoLFUPOble6iOTg+a5QyHiCkLYnmmHIlsYiyvcgGtlkjQs1t7V8izNCTLe9oKNmGYaD8d5vYK9CVXT0SWj+9cjB+aWmH1wYMjaExaofg2oVy60FV0FL5j1p4x74gF7iYSyfkrT452bkRKBxaKmGaRv0FjnTQobZH3PF8rPJDRbNj3aT9YUxIohwlPLw2wE9XO2O4ZVnxb8GYbHRT/5NMNfq2ZSV9XvxCpiMyI3oTpqXKvEG/KG2OSKCFGkW6zYLX+4UtM5XjtSuSKBScCvTwArd8ir0bvSmiUyywjeGMIse18uKExwf1o134HsZlRewysiYRTXDYNoTZKXVvd8/FAfMO8KiaVMGVT2FTdXL/p2rVC1HVroVc45MzRVOp1/ONuZhRbzXC5EgMC7UEPg6GZdChOpLIWKkHpYrFMa9qA3xv0Tt4NkcqLOow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(83380400001)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a25CM211U0ZCbWdTYkpTZ2dnUklyUUx1cWJVN3VoQ1VjRjNtSEYzUTNWbVI1?=
 =?utf-8?B?b1hjazFHSUVNbmZpR3pONVkyOU9hazZydTQ5WmFxTFNDbTcxZnVpSU9UY01W?=
 =?utf-8?B?a3pnQm5acHMvV2pvYTVSN2h0dGs4eENZMEUzWGJKTHNqK2p4cjhYeFVGaHhO?=
 =?utf-8?B?eGU5ZEIzRjB3UHZWTnZoUFd1VDRZWXU5T3JwYlhnMnlGbDI5NE5aYUpmSnBp?=
 =?utf-8?B?ZTJkYUEzL2RjQ1NWeVRhSTBBdGc1RkFLRHlOMzlYWUp1VC9qUzBDcnYrUWhI?=
 =?utf-8?B?UTdnakZKbjZGWnJtekRlaGlwdXhFNEtWZ3U1RDFGZkpvU2NkZXdRNm45UlVv?=
 =?utf-8?B?NFZkc3Q5UmhRVlJabTEvYm83VEF2QWprMWMzRTdHYVZNZHJrVlFoWGhlc1VD?=
 =?utf-8?B?RnVKeFpaMXJobk5rT0Ewa0ViM0YvbkF1N1JLZ0JiNjJHL0xNTGRKMThrV1J1?=
 =?utf-8?B?MUJSUTFpdHF2NURPdEpzQXkzSFpxZC9OZm9CWWZpUURINSs0Vy9kTFo5MVU4?=
 =?utf-8?B?RGRuQkRZSHZ1SEdENnRmVkFEdHU2bm5ZRUdwS1lrNmY1ZTNCdnFRRDJudDYy?=
 =?utf-8?B?WHNRYXVVdXdmTXZCU0phbkxpS3AxeWtoNm1yTkNhQ3ZqaGFCeDZQTzJ6RUJI?=
 =?utf-8?B?WjZGYlVucml1allwSmpnQUIwWmt5elZPWXNNNWFRQlhjMndJM3ppQlBiMkFr?=
 =?utf-8?B?a1d1WmpYQk5uR1Z3cFFMSGVzSWpHaCtLaFFpdEtTcmZMTG1JWkNGTzloRDlE?=
 =?utf-8?B?dU9YanZLTmE2U2NLeW4vWW9DTUFwVCtGUXQvcmN4Q01wNHNvT1dSSlRkbDJY?=
 =?utf-8?B?b3I3dmxhc1Y2VitCYVF4eEN1MkZKWFVYV0tJbCt6NTRBOWdnbTI5cHBMWnhi?=
 =?utf-8?B?QldLZFpRRHlrQmlBUkFPWUsybzVIWXlOME1IV05aaUZMK0pnRFlLWGYybGow?=
 =?utf-8?B?a2ZaOC9SUjhwcFVubzg5RGo0WVYrUFBrNEU0cUJ4aUhaUHBaREMwV2ZnODRw?=
 =?utf-8?B?VFhVYmwrVXYxTEpLaW5QL2JHQ1JGQjE2eUZkYyt2UW9QN09rK2pHNENFdWNU?=
 =?utf-8?B?WlNlVzl5Um1OblZ4L3BFNlk4cThlRnpKVzlNa0QwcWJTUHdIN2t6QzlFejE3?=
 =?utf-8?B?VUdOczVHbUlDYk9aRjE0YVUycjZ0ckNtdzZCSFd4emR5Um5mOUVidWZkcWVi?=
 =?utf-8?B?S2lKSU1PUS96dXFyZElXa210aTZxOFdpREFPcytKN0FwVWx2SEMyNE1NYzJp?=
 =?utf-8?B?L3hqUXZBV3JBR0tWSU1SNzlQSlppK0IvTC9yN2pJbHRpQm9IbGV2dVhsc0s0?=
 =?utf-8?B?ZHpmL1ZvU0hSUjhlRGZ2VWt3V0JrQ0NYVnRPdkFVME5vQnFpaTBVRTVuVERX?=
 =?utf-8?B?b3kwang0K2NZQ1dlRmdZamp1S0M2Tm05SGlyV1pDd0V1cm1JM0tBRGRjWE00?=
 =?utf-8?B?TEVTN09XdHJiWDgxanZrbi8vNGtzdlU0a3ZGSTUwSU5WU2tNUXhWRWNZMUI0?=
 =?utf-8?B?TGFHbGpwQmJobnB0UVdzMzAwOUhJckx4amRqUkh1RnQzazBRTDJwT0NvYlM5?=
 =?utf-8?B?SDhCdDg5elFvMW1GR1BlOEI3aWQ5eDJ4TytJbThhdml5TzZycXY3SC9EbUE5?=
 =?utf-8?B?OHgxdDkwcVFpRWpIbHNBRGJIS2dBdTNSNFZFYXRobHBKdGVxdTF3UjZINkti?=
 =?utf-8?B?d09pQUxvcnVzNWdIK0ZzbGU1OTlJVUJaYlJHYVkyQUZTZjRRNDB6bXhYa3Mx?=
 =?utf-8?B?bXlSQXQxSFU2WlN4blNYREp6d3V5MUNyN1pnUE55UUI5M1lMTTRhSEw2UGZq?=
 =?utf-8?B?b3FPTEtmTGJRZkhwMTNnNWJqU1R5bEhBS3Q1WGxnbFNBQ1lGMzJKSFJEMGND?=
 =?utf-8?B?bSs2TzBSS1BiaE5CMUVvQVBWS2NXUTZmYjlhZXZNMmsyUEZMdk1FTGJ3N0ZP?=
 =?utf-8?B?ajVDUFEvQ29Kc1BYY09SeU4ybWNpTFZMaWdhNWpiTHN3ZWtqUDlodlVWU0lz?=
 =?utf-8?B?cThxV0VaS2g2SVlUZDJ2MGRkTDZZNFU4WFNiU2VqYitDblZxOVp0OEJkNWdD?=
 =?utf-8?B?WVk5cWQ0ckp1SlU4UldhRWtBQjY4R2pnSXhGVU5SeEVXdHVNbEdxeis2MUxT?=
 =?utf-8?B?MExiMm10eVpRMzNuT0lHbGVRdlgwM1NKeWNUTXJHZzlwZ2o3Z1lYdldYanVD?=
 =?utf-8?B?dCt6OUJtb0JxUERuanhDUU9mbUQ5bEpscEpIRDlra3JNMTZBZEVJdWx5Mm15?=
 =?utf-8?B?VlY5WHF6cG9BOGkzeVpTLzA2WmFBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2a617b-9ed6-460a-e683-08d9a319b7c6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:41:50.3860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJ68Q+431lnFB/aBcfN5vb3IpCnMaR5kY9mf6g1LRbfAFhRokw1dBMu17pAtXsiDknEkTedOoMeocQmY8BqmsZlLSQjJ36Q8PwpIsgMA8Ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: _FDJKq0tagRUiKvih7u9eE5v2LTFKUkn
X-Proofpoint-GUID: _FDJKq0tagRUiKvih7u9eE5v2LTFKUkn
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> There is no point in recalculating from scratch the total number of pages
> in all memslots each time a memslot is created or deleted.  Use KVM's
> cached nr_memslot_pages to compute the default max number of MMU pages.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: use common KVM field and rework changelog accordingly]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 -
>   arch/x86/kvm/mmu/mmu.c          | 24 ------------------------
>   arch/x86/kvm/x86.c              | 11 ++++++++---
>   3 files changed, 8 insertions(+), 28 deletions(-)
> 
(..)
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11837,9 +11837,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   				enum kvm_mr_change change)
>   {
>   	if (!kvm->arch.n_requested_mmu_pages &&
> -	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
> -		kvm_mmu_change_mmu_pages(kvm,
> -				kvm_mmu_calculate_default_mmu_pages(kvm));
> +	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
> +		unsigned long nr_mmu_pages;
> +
> +		nr_mmu_pages = kvm->nr_memslot_pages * KVM_PERMILLE_MMU_PAGES;

Unfortunately, even if kvm->nr_memslot_pages is capped at ULONG_MAX then
this value multiplied by 20 can still overflow an unsigned long variable.

Thanks,
Maciej
