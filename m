Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD9545A5FC
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhKWOrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 09:47:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40190 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233939AbhKWOrj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 09:47:39 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANE6qn8004389;
        Tue, 23 Nov 2021 14:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=p76DA36z/rVXjTA4bh4mm+3JzCOWdEhJ5+VeV1OUNg8=;
 b=Vpdk3tOSTAxQxBv9A3g9podUKp/uP1pjEgbAt5S53s+YjfWDmYF9vyIv9opEf1Vuvlrg
 gRDQn8gUKXKJ2v0PJU8PA3+wB9Da+tMiGjV/MY0ftRRj1MY/3lrVUH29BEOb4dhX0tOV
 f7e9sNeG2U98yM+ol+88TROIorMCdKRHcMO+u68Jatc7uL1FkiyQFjq8CNGXlwdqnC/2
 7FkCiFtur+hldgn1MsR62HNeYC5GY3YBErdo5n+LSiRK5ifl1VBHSsKzd/ueLUh2kWJ8
 C19D8PpmLLhU0Zv7ANP/4ET/gy76IHJwycglFoDIMzMSyv88PZPQDXdQztIP8Mwbt0Jp EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg3059gr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 14:44:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ANELQDS072777;
        Tue, 23 Nov 2021 14:43:01 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3020.oracle.com with ESMTP id 3cfassme0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 14:43:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUHzvtJjcgdd9XVb5hudm6sEgm/y5hkgj2DUWMTAGQ2Od0GRu7C6bRmdWBH3FzYZlzMpwxeda823pZczVT/c66vlBP5E7Jw2TMAJa0av1o5l/ovsPls6cZh9TkJdTh+OVk4I/ZeyN/S9UPbur4GHws3agiD4xtR1sJCL8CNCUYHqIaLax9U4x9+0MN8k9UbAWsj5SoppfvyUqfZtdCc8m7fHg7hsF2DeZTCHs8BaFgb8UMptcPEX3/vSjKbyf9vdsjAV3lhz/4dAmcquOJ5CasRCTYDpJ+U0S0/gKS3M9Ad/qSYF+ZeDiKMR8THwfRFJY1hxAM1BWmL7wBQUuYfV0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p76DA36z/rVXjTA4bh4mm+3JzCOWdEhJ5+VeV1OUNg8=;
 b=Hf9V13YB2GaxzNum50spBmhkAxdUisBD6IeMYxAwHfIHQqCs7K540Li8RWTqFTEsxYfpv6xb6Wb/o6QCU+7xl8/tKgeUZFfzvTFBGfRiWdkAnNvSEkzNciAcqs+/aOWKJhIVxiz3AnjAtEbQa9p3vmpsuriAb/15DF+3+Z/MR+fuz7pna5hIG/tfSB6shU8krkXQMij7dMG7LqdJEieX1AAqmc+quspTedxx2xCvVtk6ZFdxjSSWlcVmAWycL1zHemDr3TeIREMpJTDV7DkOHVmdX74WIucxn28xQH0UqjJUQkKoAQOnBOMuFJ7ku+6zpqjmyzwmDQJ9lNTGSb4wiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p76DA36z/rVXjTA4bh4mm+3JzCOWdEhJ5+VeV1OUNg8=;
 b=qsTVuijfz1vbdW2a1uBBzrKuQQNiKHYeMClbcIcrJfuFU1iRTLrou1/oUYecYiz3rfwnuC79C2LYhpYiC8+ifvHIyCSG8Ewa8iYBmHaL3xAtBSYMiLclt6J5Dwi0TTzhkNO99K2/OxYAAuNwjAzqKNVa1Q7N+8dDUgtvFiLJH6Q=
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH2PR10MB4165.namprd10.prod.outlook.com (2603:10b6:610:a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:42:59 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::dd4c:c1ef:d6ad:12da]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::dd4c:c1ef:d6ad:12da%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:42:59 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 00/30] KVM: Scalable memslots implementation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <cb4f5d6e-9535-dd57-d8ee-3b593a81f3a6@oracle.com>
 <YYnNA5lZNXXdX/ig@google.com>
 <f3bc3bfc-37c3-bbfd-25b4-ef0a72e534ba@oracle.com>
Message-ID: <5129f02d-7c0e-8e88-797f-95e8d968df88@oracle.com>
Date:   Tue, 23 Nov 2021 15:42:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <f3bc3bfc-37c3-bbfd-25b4-ef0a72e534ba@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0335.eurprd06.prod.outlook.com
 (2603:10a6:20b:466::34) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.170.208) by AS9PR06CA0335.eurprd06.prod.outlook.com (2603:10a6:20b:466::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Tue, 23 Nov 2021 14:42:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a542391-d0a3-4262-d303-08d9ae8f8ae9
X-MS-TrafficTypeDiagnostic: CH2PR10MB4165:
X-Microsoft-Antispam-PRVS: <CH2PR10MB4165ECB424D817FDD36D72B0FF609@CH2PR10MB4165.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDjOwuq3GQ8hSJO/6vMiP3iHhDuvIdKmDyKYd4XGP7MxLmR6wx1pF7MWjrFuxU7hutPKqO0+HBZVx6k4oT6O/cEH/oQvROBkv/XeZXRf4IAXU0s6J26leuVBmLTApFhajoA4a16tJssMN6xxKWt81hCdjWYYP2zmipdE7FcSzM7SqFZSkNdqdWmNOMFlYxc3beJf+FcyJ/BZz3n2cUClh0x1ow/AINMlJAKPE5QY8DoObRO4h9rOaZVqw/RbzVAq5kHhXWdaeeoWnyUiWIKk54hKUX0/Zo2IfoJFGaeaQwud6bJLPnkVx+PC6+720eJx2oue8Mo/2nhfQbBbpj4xUdeA+In5K0uPjWCBqP37zcno+mC+adzB/MWHwmPwOe4AkykHBlRyfMwg5FK7QkRCj/wWlUnp7QZEn97MziD6O1icRcXwA3SNMX9jyERo+5Pz5gQ9L9NVi0mCXnDBjOaPmGr0x500sfjPhmNxtVRxhXMDTCIlBE+aVFCbjEdJaWWpN6tFqe2kyd67FeAPQFK6A6zB2V5tZDkJ+42lj1fQuO7UNN5SnYZ2isKi1jvoCNOnZRSe6jPPa8cxLEe1aurXkP/CL7OEGQUCjibX1xFzbsHpUmP2eP5NzuNpriBdlKpixPocIoosWze1+knOI1aciWNvfwAQwnlJTR7MRAN+gu1as4aCEDIQUhsrHR+0i0VDSqZBswfD6m866ZdzXFjnSQJ7/eUaBm6aADhd5XYiZKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(316002)(8936002)(2906002)(31696002)(2616005)(83380400001)(66946007)(7416002)(5660300002)(558084003)(956004)(6486002)(38100700002)(26005)(508600001)(186003)(6916009)(31686004)(54906003)(86362001)(8676002)(16576012)(6666004)(36756003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djQwUkQ2ZTdOSnFKMFA2VU9LS280M0F1ZDI5WVc0c1UrN2I2WiszdVJDaUlx?=
 =?utf-8?B?QkxLeUJPNG1Gc2ZrWS9BZUZ6QS9OY041VVU1ZmpTRTk3eXB1eUx1NVY3bWRI?=
 =?utf-8?B?aWVMTEFTRU40MVJuM3ZHTzIvcGN4ejBRRjRlSk12a3dPY3I1bTlObjFGUldj?=
 =?utf-8?B?K01jaldVdzVINmpVR0xKdzYvRmJ1L3gwT3BRQmYxeWFBU2grQ2V5VFR0dTg4?=
 =?utf-8?B?V2RBZVk3T1I3VzlEa2c2RGlaVTd2QXZNcEpHa1VKWm9vL3F2SGRud25nVUV2?=
 =?utf-8?B?MDlCT1QwS0tSemppYmFaWVJHZDdxOHBnVlhlR1A2KzFXcDdwWmJ3bTZBT0Vw?=
 =?utf-8?B?QlE0bTJZK0p6dDh6KzZQVUwraFhNSWw1ZER3MHVyeGVES2JUV243Y21ubnBF?=
 =?utf-8?B?RERTYTFnREtDT0V5aytpb3pTNiswTmNmak5NaEVoWlNDdC9Qalgrck1tbUZn?=
 =?utf-8?B?alJIN21DS3dzRmo2dFRPTTA0Nk1ia2x6R1dBZmRzOUZIK3JtZUJvaVo4SS9Q?=
 =?utf-8?B?S3hmaUdpa205T2tsZURTS3Y0UzZmK2drNEJBN2ZSOWRUOVVMZWNFbFZBeDlL?=
 =?utf-8?B?Z0VMbTNqdU1CcWpkMjBYVWxDbFdpRHdaTU5IYmoycFZTR2EySlBtaXR5RG1h?=
 =?utf-8?B?Rnd1R0wyMEdweElLWkJjOUd1S2RhSXJzQ09oclR3RzFUNHZtamU2MHhQSWNM?=
 =?utf-8?B?TzlRRmlSd2hlUFVsZ2FkUXhVYVlFNEh1c25IYWwrbU9iRlVlWDZMUDY2WDNs?=
 =?utf-8?B?RG5VY2Jyaklpdks2c1Q1RDFRTmxGQXZ2cDlJVEY4cVZrT2xLZENYNm5tZXFI?=
 =?utf-8?B?U3RvR3k2VDJ1U2diUkFKeUtrZ1hsKzhVNHNUUHBpQVZHVk1OQkVBMnZiMkZT?=
 =?utf-8?B?ZFdFKzM3Slo0SGIwMWtBcmxGdGlLNUJZYTZMZnRObEttRjRXeEhDdC9YTjQ1?=
 =?utf-8?B?Unp5eC9JdHBqcTBuNG9OKzhmWjh1MDRwMWkxa2tNQmxjSnRuMW1WOWZZcDRH?=
 =?utf-8?B?TVBITHJNTjlaUDJVcGZ6clRjNWxXeGhYRjRkWUZHMjQrZ0ZRL0lDZCtoZjY5?=
 =?utf-8?B?RUtNZzJIRXdNNEFOeXJEOHRWU2p1ek5MSk82K0ZYNUIvdWhucE5ERWdCZEpj?=
 =?utf-8?B?b1B5U1hyVlRJTFYzM0xjV2ZDSWMyb2dvL1JuSUx6Y1NnaVBPak9SM2J6UzdJ?=
 =?utf-8?B?UHdCWmZDUUc5K2RwQWdhcWlXb001WFluY1pMK1pRVXRCNTFxTlJERk91SThp?=
 =?utf-8?B?WmhrSkswMS90UU1ISjJ3ODJtMHpzZ3Zhb0RTWUhsMTE5bk9TNytjODU3UkxB?=
 =?utf-8?B?V2Jub2FqMzRGakc3MGRVSVhHSHR3WnpLekM2dDB1eEpGdGVCanJQcWJsSHlx?=
 =?utf-8?B?UHo5VytNd0s4aVVpNFJzK0ptMWZVdkZtcm9zYjVlM3FQYVFXeitoLzBlbWlx?=
 =?utf-8?B?d0RFOGh0Z24vU0Q2SnJibFpYWFlvbThLWGtyQzNVeUcvelg2Y0drbXRmdEI4?=
 =?utf-8?B?bEg2eWsvbjhJUWI2T2NsaGZDME9EZU9vSWdybjdsckl1RERhMFVQamxmYnd2?=
 =?utf-8?B?ejdQQnFTSDQvNm1KRjdWOVRwMVdmc0xxOWhRaklCbW1FZ1dpaklPSW42WmFr?=
 =?utf-8?B?ckVnZERkUHVoSit3SHVJczNSM2tza0ZPUU5najN3aHROdDFRK3hTTzJWcncy?=
 =?utf-8?B?QmJBM2tDN0JLTFB1bnNFZ1pKYkxYNnZaVDUyNTdKUnFsTkJLUENGSE9LbUJm?=
 =?utf-8?B?aXpIZm5QdEdJSHNvbHhDeVNEclVYWTZSNGRlUVBSSXJCTUhUdVJLM3orS1Vv?=
 =?utf-8?B?MjB2Y3pMaFUxNGJLb3NUbnAwaTV5c3dIQXNGVURIQXFuNFpYdzR5VnNJVW1H?=
 =?utf-8?B?SDZRU2JZM2ptMlR6bWMyaEhJVlFGajdoR1hCVWQ5RE5BQmcvYlhkZHpacUFR?=
 =?utf-8?B?VjIzT3k5ZkdraTVvaW1ha0lxMFM0cUlDVzAwVW9LY3ZHK3l3Q1NxWll6YzZh?=
 =?utf-8?B?Qm5ZTjdXZmhiNXpUeC9qTlF0bmk4Z0pvZUx4dVlla3hUK3UyNmFpR2JRcytx?=
 =?utf-8?B?MjFFekxBc2twZ21IVittNjlMNm1EOXRuV2xOMWcvWGR0SGtXSkRvaFA0Mi9P?=
 =?utf-8?B?SUtlM016NHFmQ0xoNEN1dTFKUW0xNGwwUGMvVzJHbmMzODNqREkzcnA2MDZS?=
 =?utf-8?B?ZU5LeXNxZ2tudzMrTFhGNnRIU2d2bXdLQStJekJnUzJWZ050SWZQTFB0VjdS?=
 =?utf-8?B?RDJqSmxWYysvNHdpTjR5UVpiU09RPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a542391-d0a3-4262-d303-08d9ae8f8ae9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 14:42:58.9008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImrN6l0cjzLUCztuJf4UslFZ9fmgIwbq0e+9YbpIo9h6mtyWTa30iIzSxidFhsII5KoVlqdEFq0nt7/pyrLP4em/ntuR+6sSMtXCC+PVwjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4165
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10176 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230078
X-Proofpoint-GUID: 6fkbzw79O1UlqaUStVDEnP2azUQMJIwF
X-Proofpoint-ORIG-GUID: 6fkbzw79O1UlqaUStVDEnP2azUQMJIwF
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

I see that you have merged the whole series to kvm/queue, even though it
still needed some changes and, most importantly, a good round of testing.

Does this mean you want all these changes as a separate patch set on top
of the already-merged series?

Thanks,
Maciej
