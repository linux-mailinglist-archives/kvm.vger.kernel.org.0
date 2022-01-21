Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29566495BF2
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 09:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379591AbiAUIb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 03:31:26 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:25966 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349730AbiAUIbX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 03:31:23 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L7EDDw009111;
        Fri, 21 Jan 2022 08:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=rlmrGivoj1aAbUFf+q33AOvFTVTy7RuPgJO6Jht2H4M=;
 b=l+bERGCvuiPyaV2XKoBLuDkiNz+coDjgqiOOpu3PxK0n3/RXUZw2KMMpflgmNlXg5kR7
 DjihEiOxd37s7uevYXbLg8r9fDR0B4+dLYeDqHT0SzW0+lM6EE4C0KK4u3c11ru/FHwd
 5xxp7klEI6dexdKK7Ao4UGDzsCMQ3Na+dBLIcftxw5gTC1B115wSi5iuIiFcdwlwjGsd
 HSD3kI1RnVulEoEAoB7xg8kI5FI9p1bpCXDsIvuS8wtn94nHtTdJDBGmS5hinkqW1z+8
 EA2sMWMy6NkjqmJc9ScjxaiOqTjsc2J6pdrp4g9WwaDE4KV8JFo23SmbmRtptU7vrQQW Gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrp74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 08:30:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L8L27j028839;
        Fri, 21 Jan 2022 08:30:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 3dqj05r4ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 08:30:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgilE/ELtEeqFJ3YfWRCRcgBkULIOM0LmuAViA08ny+//wu8hJQiA0OqNZeUJQD1xiujiUhXvDbjPG5aIvy1VugqvHhkQtZYE/WzEwqrSVxxNubrv1SVF6Q1VB5n3EQ+dfbCu5CTElZ55OXoGRp2x78E6L1TNLUJFWCB7ZR5+XpJMcZItvqDJbPIehbv7GZs7BLfCmXv+KJcEOMwqxc5ezhZa3+YJBY/f8f8XLo/x2Ng/u+AvBMK3IpAekoFH79v8M2W6T7Sn7l2PTikQohbatIXtv2WL7jBGIXjSlR+xd+0UrK1EgVsOhEK12wnuuUHRO6KPSmKPj6vGwGL/VsKyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlmrGivoj1aAbUFf+q33AOvFTVTy7RuPgJO6Jht2H4M=;
 b=iNSo1sv/+D9Oaj7lUis5eBRUHeoC5b8QBZD/XG4Hy1HMkh2MqG4CHdu/APiigwKDQAsUhZ3HinzzewRv7Bgtavgskp5/eE0lncmGrIrXzjBm9LyHE5ZzmUFT9nGkX69nlMNNdBHeTyMcoEMsIe0ryTqn9UpQ5bB2bKfh3jhWZ7CwjF+4TGKRAIv78EgX1Oqk7ZFTcaUmGV7M8C4LcEEfqpeKrMfcfr7QSD8bX0hhAafAvzBecHTfl5YYAUKIwDDE+v1DwQzkNGQcdWySfk4LZHj/MoMzVGexPwol8kZ1b5akuFxY2NdUiC4cdAsAE+yd7Aucg+JoEkWIex8CHg2zRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlmrGivoj1aAbUFf+q33AOvFTVTy7RuPgJO6Jht2H4M=;
 b=yNPILAnGcIrF3+qkxuxePdZQwB6+4mqhyy5qG7ivrgd2i9Qsykx23IkPb5ZTYEXnMQV4eBRCFez3LvjpIPXysGcqv3GBPHonv6AEVjEbtNUsYaaeyjvLae40NX8qUa00+v3qMOp8yXz3MO6k8ihhKngxRLPm0dMSPaGtzlL0Rjo=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by BYAPR10MB3302.namprd10.prod.outlook.com (2603:10b6:a03:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Fri, 21 Jan
 2022 08:30:38 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4%4]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 08:30:38 +0000
Message-ID: <76fc2a33-f985-6f38-2c17-3b437ea0b0fc@oracle.com>
Date:   Fri, 21 Jan 2022 08:30:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/9] KVM: SVM: Fix and clean up "can emulate" mess
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
 <d02e3982-b34c-c529-11b5-4c788af480d2@oracle.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <d02e3982-b34c-c529-11b5-4c788af480d2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0051.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::20) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47b33458-84bb-40bc-d554-08d9dcb84d5c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3302:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3302420FDA0751FDEC858460E85B9@BYAPR10MB3302.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHavrposrqpAMkbaOcXYZ4q2azUoW4G4Q1c6RX+cLOEJbmW6XvOZWxbxAPTAQBWQOsyJ9P99EVgwV07QRJf3y6hsWrewAl1F8jXy8Aciul59z2EgfoxKPeYxVRuWISkjW50nWBeyEHGzc15e8mPrGSAX0QIV8gpV3XfcAEBU1bmYmIiYMJt2MweIlPk300grP8hpr+sYLeNIrSV8qHHJE9Yaux3cSwYhylrfSooT/M1Rknb6vQytdJK93FcN1aaGIHBbnZ/aqjkVB5b0rDAf3VQPUo5ZNaoz7SCRUU4RAoirP0SOeQqMLxH4pEhs8hnHk6jkFuaBeueK+sHmXtYFCQj7/SZSqC3W6wQ1x5RNSElS2y+V88+DrjHe3eHV6HedmJWD8wggvTAzGpvOv7vTLQoxcW6wz6ynSuOysogYccunPUy3Ky/wcQrNujWpadM/vM4OKLs4S9Gvz9KKG2M/Nl5RQkORdamL5oGXyHxrvCY2k9zL06ye2d2tnwH5yey9Zs6lkZToy5Co6GOBs33u9tKqyq1oy0qbs8CJUZwE1LIutVKaxL9wgaP4KUTidSEbIhefu0FvN9noBsOzH+jVvlwANehNtEGQywc5IDuLx06vXyfAeMAzUSyDt0DMSUIQEx9d8pqIPj8XgJnO3JZf5GzfXrceep5yH0Dc4zVIggTuLVEQUiekZdSCEX/9ZxvEb+Ij7tbfHLYk5EVNpThEHTJZ2L7l9qZe5EKVR4cAnhelqiOq0vt9tdN9ZL5rsyiFhIuiW7whLGtXEy5WVSH0aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(38350700002)(38100700002)(66476007)(52116002)(66946007)(54906003)(110136005)(316002)(2616005)(8936002)(508600001)(8676002)(4326008)(2906002)(5660300002)(6506007)(53546011)(36756003)(44832011)(26005)(31686004)(86362001)(83380400001)(7416002)(6666004)(6486002)(186003)(31696002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d01scWJ2WlQ5Ym54WDZKVmJPWURRTWkrb2hzTlJEeDJGRHZnYzJ3SGlmbFc4?=
 =?utf-8?B?YU0vMndpUittTzlOZEFucVhXenpOdDdBd21ITEgxelhCZWNqS1p4dEo1cEFq?=
 =?utf-8?B?cVZibFNsOWdVdHNqYjUvb2tjM2xrRzFLd1JLOTU4bDZNR0tMU0hpSjBMMXRn?=
 =?utf-8?B?V0pOSFJFemJPVlFHU1JRSFNDaTZONmdSQVhjQXovcml3dDA5Z1A0RVA1OEVN?=
 =?utf-8?B?VzBxNlVPY0R1NGhlQjNwZGNKSXEveWNGaSttSkE4UVRYNnF6anNnUHVPOUcw?=
 =?utf-8?B?a3JycFBoQmo0WU5FT2ZOVjhnbmZHMUF4MEZZYmc1RnMrUW5RRHQwZWpxZnVL?=
 =?utf-8?B?Q2xveG54cHN3NTJOSUdKOFdjRVBhbGhtYVBETmwyK1BnYUxucmJEMDBGMkVD?=
 =?utf-8?B?VGhPRE9pS2lrMlZsUWV0OEUxNytYZzc0M1ZJRVFpRTBXRnkzZkIxTkNKQVZL?=
 =?utf-8?B?UjAvK1EzRENEQkdvSENvR0djbkhjUnRoTEk1YU9xOG9EWXQ3RmlCaXhPVHFy?=
 =?utf-8?B?U0gyQThWSkZNcWVGdW1Dd01id1czbWFrZTU4MENjNDRDbGI1eVRBR1l6czBH?=
 =?utf-8?B?aU55NG5UQlZlclBYT0NHa1U5TVpRdWZEOWpYejBRWEdFNW9PTVpYVXBEeEVD?=
 =?utf-8?B?Y0JsMys5MjFtOUUrczlSWnBWZlJXckNXM3BvME90ZFp2M2lrTTNqQnVJb2dv?=
 =?utf-8?B?QUJFS1JGOVVwS3RHUGRHTmRONU1RejZuZDgxZzY0bXY2dER6M3BmQmFlejVX?=
 =?utf-8?B?dFR0L3VnWGpJRzVadXgrS1oreFdYL01td0NETXVxZTd3SUgxSzdheTl0UnVG?=
 =?utf-8?B?S0l5MTgvRkxpNU5IUnJOa2U3eVpsS2NTVXFYUkNNMFVyYkgrTkdpcHFmTVRC?=
 =?utf-8?B?aitRY2lCSFdNNjlXR0Y0dklyNGc0S3IzTWVUVjBVdGtvenVoOXpjU1dibXdB?=
 =?utf-8?B?L3lJNGlBenEyeEdDVE01cUU3dXJZNGxNQ20zUVN3OTl2emZLNXA4ZkEzTkI4?=
 =?utf-8?B?RUM2bHNKb3ZsR0xCVUNMc0l3WXR2ZXEwOG44ZDZTbnpjVUtST3ppZVR4dHlZ?=
 =?utf-8?B?d1Q0UHVQR2ZVc0o5RzE3RXVncG5iL1Y5V0RVVEhnbUpGdnZLbTgzZTlldVIw?=
 =?utf-8?B?Zk5raGdTeUp3NmNUeWpBZnY5NERKcjRUUC94N25PQUU3bUx3WFVOZmJFVy9D?=
 =?utf-8?B?Y3o2NU1FYW5aMy83bFkwNTJZOWdLQ2xxclNyN25aY0pOdU1aUit1VDh5RGZ2?=
 =?utf-8?B?RWpnbGFtdERJNGFQblhDeFk5Vk1HbExtaW92NmZXRCt6SnM4cDg4OGxQUnFq?=
 =?utf-8?B?cThFY3hzSzM4allTaDZMVlN6VDRkSE5jc2RVZkVlWU1QNEllVHBCb202dFBW?=
 =?utf-8?B?S2lLUk93RktVMStqSDh5TWRoVkJLL09PNUdvNTdENVdoWW9rQzhZWWN1VlBy?=
 =?utf-8?B?YlgwajNPNk5ZcHRWS2tINVZibmdCWHdzMVQzYVU2OS9aci9CSXFVRDc3b21Q?=
 =?utf-8?B?ek1RQmVMOXZIeHdoOWRBRW9ManpxYUxGU0JLWXdwVjlQR3hlc1JXZDVVV2Vv?=
 =?utf-8?B?c1laU1JXM2dtQ0ZUbUJFRzRUaE4xMHE0aXBIS3p6UGhidE5LZ1F4TkhSN3FL?=
 =?utf-8?B?MDlTMVhZN08rWEdRV1dnbTVZaW82Q05QcEhlSEZHK0ltaXNqb05TVWJQamdW?=
 =?utf-8?B?NGZJTnhzZ05aaWpQTjlUUUtqbys5Sm1wcmk3YkFFVDdjMEhjUStYYWpWeXo4?=
 =?utf-8?B?SEwyWjJUQW4rSVJFck45aVhCdXlwRXFSUStGV0tlNXZ2cHRmeHpadTY2SDJ0?=
 =?utf-8?B?a3Z1cmd1NW0rUDJCTlo5Y09ZVVdMek1KVEpybTEzT09wbW5VVFBPeUYxR3Y2?=
 =?utf-8?B?T1NQZ3ZrTENsWWZFQjFzTXNXV1VHcmg3UXgvcmVNUHp5MXBmVHAwM2pndEUr?=
 =?utf-8?B?a1cxaXFZQlQ0cjJ1RCtDMGdEMkVjVXNucWtkMDEzY0R4TWtCZm5LZDFFa3FG?=
 =?utf-8?B?NE9vTTAvYS9GVWtCTEQwT2NtZGl2bnlaZ0VweWkvR0ttWDlQdUVKVXpPYnJF?=
 =?utf-8?B?NHZCZmdRd3dKZUdvU1crMVB1VXZlVXRYTStBYkh6c3EreDBldkNNWC95QlBm?=
 =?utf-8?B?aEE4SlVNMEVKbjM2VVU1K0s0RG9xT0dBRUF0SzRmdmpvaTRjMG1XbnNEVHZp?=
 =?utf-8?Q?3tZA7bHMgGmd6eBdD2ltX/M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b33458-84bb-40bc-d554-08d9dcb84d5c
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 08:30:38.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sgMQKAzrzRaTAoYyGe6+PPjQVH6ggL+vi1jwsVFKXGnaME20XGPNh6Y9TJ89lM08PQDf82q/AZDd5bgAZjqaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3302
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210054
X-Proofpoint-ORIG-GUID: zVMiGodvtBJMc7lrC16-9S3dPS8ilTru
X-Proofpoint-GUID: zVMiGodvtBJMc7lrC16-9S3dPS8ilTru
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 16:58, Liam Merwick wrote:
> On 20/01/2022 01:07, Sean Christopherson wrote:
>> Revert an amusing/embarassing goof reported by Liam Merwick, where KVM
>> attempts to determine if RIP is backed by a valid memslot without first
>> translating RIP to its associated GPA/GFN.  Fix the underlying bug that
>> was "fixed" by the misguided memslots check by (a) never rejecting
>> emulation for !SEV guests and (b) using the #NPF error code to determine
>> if the fault happened on the code fetch or on guest page tables, which is
>> effectively what the memslots check attempted to do.
>>
>> Further clean up, harden, and document SVM's "can emulate" helper, and
>> fix a #GP interception SEV bug found in the process of doing so.
> 
> 
> FYI: I've applied all 9 commits to a 5.15 based branch (applied cleanly)
> and the 3 stable candidates to a 5.4 based branch (applied with minor
> contextual conflicts) and have been running my SEV test case (sysbench)
> and kvm-unit-tests without issues for a number of hours now.
> 

Tested-by: Liam Merwick <liam.merwick@oracle.com>


> 
>>
>> Sean Christopherson (9):
>>    KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
>>    Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
>>    KVM: SVM: Don't intercept #GP for SEV guests
>>    KVM: SVM: Explicitly require DECODEASSISTS to enable SEV support
>>    KVM: x86: Pass emulation type to can_emulate_instruction()
>>    KVM: SVM: WARN if KVM attempts emulation on #UD or #GP for SEV guests
>>    KVM: SVM: Inject #UD on attempted emulation for SEV guest w/o insn
>>      buffer
>>    KVM: SVM: Don't apply SEV+SMAP workaround on code fetch or PT access
>>    KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode
>>
>>   arch/x86/include/asm/kvm_host.h |   3 +-
>>   arch/x86/kvm/svm/sev.c          |   9 +-
>>   arch/x86/kvm/svm/svm.c          | 162 ++++++++++++++++++++++----------
>>   arch/x86/kvm/vmx/vmx.c          |   7 +-
>>   arch/x86/kvm/x86.c              |  11 ++-
>>   virt/kvm/kvm_main.c             |   1 -
>>   6 files changed, 135 insertions(+), 58 deletions(-)
>>
>>
>> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
> 

