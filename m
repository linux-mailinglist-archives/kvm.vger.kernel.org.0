Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62333FCF57
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 23:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhHaVzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 17:55:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:41054 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhHaVzC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 17:55:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VIiLmK015217;
        Tue, 31 Aug 2021 21:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=51WQopyHxrUHxbuFYqFW/Gn9zpog58h30WJj6VWUzjc=;
 b=n31YxURlL601vBiNwABeFTnP8T848W+E01uAyox4IN4oK4B+U5RzMpSBejLxfqTvUmh2
 iGE2sK2XIXbjIN+08MH4/gGAbfXS8bm2Busf76cT58yyfagQ2Sknb6q3wRsjlTG6AW8+
 /0wuRHwRoSjDvsFfQj/xC2Om3Ydv0ssgspWXfUKc7bnTQccdfNUm86fKMk9mYrdW8wMu
 hE7Fu7mPZhfq8hjs+rhFzkhbVFZZrSDr/NQ5k6hSy+a2+ZXxjclTa4R9hT6pBwybPX35
 wq2e/dc+D5GRUzdmpYS+semjvxkk6blS7Q8qME8LO/qlW+SQV4QFkczm4ZOVl7tU1JIl 5g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=51WQopyHxrUHxbuFYqFW/Gn9zpog58h30WJj6VWUzjc=;
 b=MxDurJXQ/Lhdl4VtNHH9yoLCFfQrOCCGMH3WgACXWML319ple2gQa+JE3LPWEXn5UFPM
 iAt68kitx2+QLx95uCKbX2DL3inr4EUxEuFUVd3sf78LIKq88C2XoXfoxxE3b7/9C/Bd
 OGnNhkSew9K4VAFM7jZkdhzk61kebIxaVvzO7pErWas68h/Tj6dCpvGPxFu6RJVpPA6W
 PG3nsuOH8up1fHez9kaWRvlfMTBT2A4tHnvEaDAPDXTwewGtJp2Tfv4b8hM5BjHcAKod
 CllJDrPd6H0LUIB0aXgeQBFJewSDbDSxvv8nzHvIBBYERwx9QQPCjwoIX+vBBG9acu/R +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aseedjjvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 21:54:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VLZd81073624;
        Tue, 31 Aug 2021 21:54:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3aqcy5ga1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 21:54:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMk/GymqyNQK0f+UlFKLqPJf0J6aGOhOq9+aQ7JufNX93UMGX1UT5GCeMHv7XRMcI2gZL6cU1oonpHzmcLfoE3DncN05GqqmkSRrp9vjm8298Y1yOOgruxjZHK8ZzQvBgasSe8H/eQQ2LoNhGvKQzR7e3sFxmhvxcvzLdJ5hT0w5BFX/yrAtrQM5R2fpRA6baU+FfCgRnVrkIpZnlG7SP09+hUj5VvsRmNJQ2ZdVyNtyYxBRJ5RlQvdwgOUKnOv9bsqs9TsBfdr5dtQCC/K8/lwm79+B4CTBsSe3nS5Q5si7pi3nDVGZ2/BTz5IbVoYFwSenJCxgL7l5f4mxDcMJMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51WQopyHxrUHxbuFYqFW/Gn9zpog58h30WJj6VWUzjc=;
 b=WayQR0z6xoMBM4Afs7iUCS/996Ho/arjCCxMcQJWLvrZsKUc/e9lwKTLAAI2pFegd2ETZHfQhG8EvP6xltNJH+5Kobg2QDq3hOnSfRi6xLk3H7KtKnejbrE42lQnYZKtLQiP5j21ji6nOt2OQlS3DZBXL9K4N++M44q9JT/4VZZQGpQ5lyy4ftwPxhqoYpViP/4a25LF3BckYuJyqP80a1pfcdyv2/U/nQf/hlGKfsu9Q8+Y9t4nQiuW80K/CHyjZKoVBYj3hP77pQLMgWM92n/AqSpzs6e5jzIXpfbwLWMVE8Zz7Ooz+GYxcX9R3UO4qo2YiGYkTa8oy9m5l90DKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51WQopyHxrUHxbuFYqFW/Gn9zpog58h30WJj6VWUzjc=;
 b=SjxeJln5sM0od5lGLOmkPZPXvZnj8X+dkjLGxy17jo+n7eqB+SRqhAvMduRKIoUncObBPwzMwSpgDPgXkDXHD+p9sEpA7r8HWh4wJ+EWJ25nXtkjiOrxEsSTkORwkBmxQCM8V17KzBfduUsk5pxhSAy59OcG0liYho6Y4uyI4vc=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15)
 by BY5PR10MB3857.namprd10.prod.outlook.com (2603:10b6:a03:1b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Tue, 31 Aug
 2021 21:54:02 +0000
Received: from BY5PR10MB4290.namprd10.prod.outlook.com
 ([fe80::c86c:6a5e:eac0:236]) by BY5PR10MB4290.namprd10.prod.outlook.com
 ([fe80::c86c:6a5e:eac0:236%5]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 21:54:02 +0000
Subject: Re: [TEST PATCH] KVM: selftests: Add a test case for debugfs
 directory
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, liam.merwick@oracle.com
References: <20210827234817.60364-1-krish.sadhukhan@oracle.com>
From:   Liam Merwick <liam.merwick@oracle.com>
Message-ID: <c30eef0f-e87a-f312-e961-0a25985f6689@oracle.com>
Date:   Tue, 31 Aug 2021 22:53:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210827234817.60364-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::14) To BY5PR10MB4290.namprd10.prod.outlook.com
 (2603:10b6:a03:203::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.223.232] (141.143.213.45) by LO3P123CA0009.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:ba::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Tue, 31 Aug 2021 21:54:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d39a21c-9a01-43af-046f-08d96cc9d88b
X-MS-TrafficTypeDiagnostic: BY5PR10MB3857:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB385724EEFB854CA2916DA9D8E8CC9@BY5PR10MB3857.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:246;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zw1PWEw/f+91JM5POW4Nh83l40nsWM5XpPBKG4ABFsSMdoFNKvXlqCR3zHFRD3cfyQnRGV+qvzOvJwkwr1+ue5AJKz1uwrKeKvfCT9AwS6v3hxXi5uhRkAUeppQt74BEdPes9EkWYs2poN2lNAnswhBhcHTs5qyI5JT3Ip6P9iHf+S86strnsTU7p+nuVjHpaVJt+B1EqNb8dKhRr2qFYc2JlYKNuAJUoajS2OMs7efzgtYx7lIxGuL+G5snTBcoMGidrgG7wnK/Z/4SwjnXVzxeqU/BEoLdm9m8LSOXtK3YFPXS4V+zPyLSUzDPQX3pcX3UYbMuUsXhX2nAm6HFcKTQqyqo7c21TdDq9ie9zAZ41P2QYDGHLSZsRrCtuUVDwmC5hV5Tv+Vs8GJCXM8kcGGiryqv02B7Qec54f80lfJ0HlbNQQp0IClbSWL9SDf1efJg/bwhtZ4Ox0v7r2XssAzXWaTHCN/odZrTqUbwSPV1YTiSjRYZzOVgr4XW+vdktTD7Kqr6pytmGNSR7axsMejsxCaOjb7mBhFjzh/AHMvD/6dXq9vtdeiKeXJG/3DDHpjM0XCy3RfkSHzwNAwrmiGTnLqkiK2+ljSVuxrl6vuMnGpna03v28aGLPExxE7hJtihezWc9T/mwTjhTNoUTIeZ+U8fp9UKI9YCekjwftWCFU2jZCJpS52Ibn8mx9UcYrSIICsUkW4STBOwT04ug7ir7lPv56az2rr8vyN0p4MqG5XZ6yVREPBzTfJ8VQa/qLFS+nGepYu/ZqGxy6WfBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(376002)(136003)(6666004)(38100700002)(316002)(38350700002)(31686004)(956004)(16576012)(6486002)(186003)(2616005)(53546011)(36756003)(83380400001)(66946007)(66556008)(26005)(86362001)(66476007)(8676002)(5660300002)(8936002)(107886003)(52116002)(478600001)(31696002)(2906002)(44832011)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0RVT0JRVmFTNHdkRkRIRWxDeDU5QVBMN0FCZnAvTHBESGFSa0JWZmh3cGlZ?=
 =?utf-8?B?SmFBcG1adm1ZdnNJdDcwV0h5ZFpVWE5VRG8xY04vNDBOS2o3dHNVS05FanN0?=
 =?utf-8?B?RlhFRXNjSmtFZC9jNHNwZGMxV0JFY0oyVTlwUWFyak9DalRMWFRHNlI0QTdP?=
 =?utf-8?B?WGgxTCtaWjFwVDVoMnFVbHZXSk1YNWRiM2luZEl6dXpWRUZYTjBZeU5KaHdI?=
 =?utf-8?B?M1VQYjFYQU5OSFRsNkdjdjRNRTNIc3NVa1psMC9sblNIcWlYWUlKTzRsdzJk?=
 =?utf-8?B?WnVtT2JnM2xCemxobWJ2Q3JRb1pnVTd6QlNhRlVCR2dLL2tTdkZDcXh1OE12?=
 =?utf-8?B?MDlmTU5TUTdBOXZkSkpoZVN6TEdPVnFlRitqY0RRME0vVTFXTkdJaEhEQU12?=
 =?utf-8?B?VGI0eHhDOGJYV1JJL3FrTEVZYUxKamRRVFlETGZtc1N0bnpDTWJZaHRINDhT?=
 =?utf-8?B?dUxMcnlqZVlsNERMKzZTMGd2Q2xqbExpaEkxbkVSYmNUUS93cnViRUFIczNt?=
 =?utf-8?B?Q1BXeWIzWmdyK0sydGR2S2thSnV2SXpiMkNWZU5Id0pyYXBmMTA1b1lPcDFi?=
 =?utf-8?B?TmQxSXpGWUc3bzh2REM2VkdvOEYvaUltdHROTStNYlI1R3p6ZlJUTEpBbG13?=
 =?utf-8?B?eWM1cm5BN05zb2NnaUJmVFhHU1hyK3RFSCtjQm8rV1BDNkl5Mks0TjZDdWZo?=
 =?utf-8?B?SXFoNlhTUzBpM2wybHdMQ3FhZGFDRSswUjlOR0NSaC95WmhzT0Vzb1R5TjNI?=
 =?utf-8?B?WE9ON0lCTnh3a3RiSXRoZjFGVFdGaGREcHBhd0tVczE1Z1BsTHIvekRhREVU?=
 =?utf-8?B?cHJWaGdhd2ZDVTJhaUNwQW91cWJrVmNEemdwZ3dMSDErRDhDeEdhanNpTytQ?=
 =?utf-8?B?K2htcHhwc3cvMXd1cUo3VFlCY2M4cTFIR3MzTGZhU3oxUmkzSDA3YzJtMFdx?=
 =?utf-8?B?dE1zemZVNnNMWk0zOHMra3VMbmRTV0p3NklUVk5aN2xuMDZuZUJZQmtxRnor?=
 =?utf-8?B?WFBIVEtDK3BmakxoM0xtNHhSeERDd0htWG12ZzBFWVVOSVlFRTBuU1dSckhY?=
 =?utf-8?B?L0ZodE9wMGd2ZFAzQUFjYzlVQjNheEphaW1LQ0lwVk9vQWprMHkvaFEzMjhq?=
 =?utf-8?B?NitrbkxFbnZPeDZjZjV4WVo1Z25YeW9LT1JRRFpBZkJ5MzRsWDY5WDhQMkxh?=
 =?utf-8?B?d2x0WGdyZWxXNXhva1JERk12akQrYkpqbzVFRloxdE95T1YxazRjbEJuWHVN?=
 =?utf-8?B?MWtMZkFYb3VwZnd5SDlxWDZ6NnJnVGRIRG5sYUZVV1hMRVdZa0FQckJvSUJQ?=
 =?utf-8?B?L1ZrUVJqbGh0c1JoWndIbUV4ck1GR3I5bStyL1JpS0pFZ3BrZjRZbUZ1Nmx2?=
 =?utf-8?B?dlhJdFBOcWpBR3B0VjVHNW5wbWVSRGRqTGZTdnBlMlc2cGFRejZPdC9IV2FE?=
 =?utf-8?B?OFFTVjFIN2dCZFVvTEh6UmNmRnpCSlk0ZUxscUJKSndRbHgrNlJ4cmxtSlh6?=
 =?utf-8?B?dkxwR3k3dGxocHpZRkxZeTF3ZEQ5ZVpGTlM0NExFeE1ZR1FlMlZjdnRLQ2dy?=
 =?utf-8?B?MFltTkFSaG9TYjk0Z3pEaEZqVm5idEJ5K3dLaUF3SlBibDN1N1NDOGdMQ2Rp?=
 =?utf-8?B?anpUNXR0WXRTczliUVRzS0d4YzB0Smd6RjIydmkzeWU1Y0tJRDZmWXdmSFo2?=
 =?utf-8?B?V0loYjRWMTdQQ1U1UFVxR3BpcjVqb043TWUwMDU5K1A0QUhqcFQzWVRDTUVD?=
 =?utf-8?Q?Cmoag06p4IZZ5mZ6ZTK+ph9qHLCi+r/iyUTD2yS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d39a21c-9a01-43af-046f-08d96cc9d88b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 21:54:02.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e30fo47JVnSd7bPYZdjf/znfmj6oXoVHOIu7CmEN45GXc1+4v4wyRuVzfGXvQYscasaHvlBm3hdtvzuuhW4qDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3857
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310118
X-Proofpoint-ORIG-GUID: kdnqQ_LRIC_FLIbjIlUluZmLrqMKWbOJ
X-Proofpoint-GUID: kdnqQ_LRIC_FLIbjIlUluZmLrqMKWbOJ
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/08/2021 00:48, Krish Sadhukhan wrote:
> Along with testing the binary interface for KVM statistics, it's good to
> do a small sanity check of the KVM debugfs interface. So, add a test case
> to the existing kvm_binary_stats_test.c to check that KVM debugfs contains
> the correct directory entries for the test VMs and test VCPUs. Also,
> rename the file to kvm_stats_test.c.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |  6 ++--
>   .../testing/selftests/kvm/include/test_util.h |  2 ++
>   ...m_binary_stats_test.c => kvm_stats_test.c} | 31 +++++++++++++++++++
>   3 files changed, 36 insertions(+), 3 deletions(-)
>   rename tools/testing/selftests/kvm/{kvm_binary_stats_test.c => kvm_stats_test.c} (88%)
> 

Binary name needs to be updated in 
tools/testing/selftests/kvm/.gitignore also

Otherwise

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>



> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 5832f510a16c..673e1f6d20f4 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -82,7 +82,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
>   TEST_GEN_PROGS_x86_64 += memslot_perf_test
>   TEST_GEN_PROGS_x86_64 += set_memory_region_test
>   TEST_GEN_PROGS_x86_64 += steal_time
> -TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_x86_64 += kvm_stats_test
>   
>   TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>   TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> @@ -94,7 +94,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>   TEST_GEN_PROGS_aarch64 += kvm_page_table_test
>   TEST_GEN_PROGS_aarch64 += set_memory_region_test
>   TEST_GEN_PROGS_aarch64 += steal_time
> -TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_aarch64 += kvm_stats_test
>   
>   TEST_GEN_PROGS_s390x = s390x/memop
>   TEST_GEN_PROGS_s390x += s390x/resets
> @@ -104,7 +104,7 @@ TEST_GEN_PROGS_s390x += dirty_log_test
>   TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
>   TEST_GEN_PROGS_s390x += kvm_page_table_test
>   TEST_GEN_PROGS_s390x += set_memory_region_test
> -TEST_GEN_PROGS_s390x += kvm_binary_stats_test
> +TEST_GEN_PROGS_s390x += kvm_stats_test
>   
>   TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
>   LIBKVM += $(LIBKVM_$(UNAME_M))
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index d79be15dd3d2..812be7b67c2d 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -59,6 +59,8 @@ void test_assert(bool exp, const char *exp_str,
>   #define TEST_FAIL(fmt, ...) \
>   	TEST_ASSERT(false, fmt, ##__VA_ARGS__)
>   
> +#define	KVM_DEBUGFS_PATH	"/sys/kernel/debug/kvm"
> +
>   size_t parse_size(const char *size);
>   
>   int64_t timespec_to_ns(struct timespec ts);
> diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_stats_test.c
> similarity index 88%
> rename from tools/testing/selftests/kvm/kvm_binary_stats_test.c
> rename to tools/testing/selftests/kvm/kvm_stats_test.c
> index 5906bbc08483..4b73e7d5ac0f 100644
> --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> +++ b/tools/testing/selftests/kvm/kvm_stats_test.c
> @@ -13,6 +13,7 @@
>   #include <stdlib.h>
>   #include <string.h>
>   #include <errno.h>
> +#include <sys/stat.h>
>   
>   #include "test_util.h"
>   
> @@ -179,6 +180,7 @@ static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
>   
>   #define DEFAULT_NUM_VM		4
>   #define DEFAULT_NUM_VCPU	4
> +#define	INT_MAX_LEN		10
>   
>   /*
>    * Usage: kvm_bin_form_stats [#vm] [#vcpu]
> @@ -230,8 +232,37 @@ int main(int argc, char *argv[])
>   			vcpu_stats_test(vms[i], j);
>   	}
>   
> +	/*
> +	 * Check debugfs directory for every VM and VCPU
> +	 */
> +	struct stat buf;
> +	int len;
> +	char *vm_dir_path = NULL;
> +	char *vcpu_dir_path = NULL;
> +
> +	len = strlen(KVM_DEBUGFS_PATH) + 2 * INT_MAX_LEN + 3;
> +	vm_dir_path = malloc(len);
> +	TEST_ASSERT(vm_dir_path, "Allocate memory for VM directory path");
> +	vcpu_dir_path = malloc(len + INT_MAX_LEN + 6);
> +	TEST_ASSERT(vm_dir_path, "Allocate memory for VCPU directory path");
> +	for (i = 0; i < max_vm; ++i) {
> +		sprintf(vm_dir_path, "%s/%d-%d", KVM_DEBUGFS_PATH, getpid(),
> +			vm_get_fd(vms[i]));
> +		stat(vm_dir_path, &buf);
> +		TEST_ASSERT(S_ISDIR(buf.st_mode), "VM directory %s does not exist",
> +			    vm_dir_path);
> +		for (j = 0; j < max_vcpu; ++j) {
> +			sprintf(vcpu_dir_path, "%s/vcpu%d", vm_dir_path, j);
> +			stat(vcpu_dir_path, &buf);
> +			TEST_ASSERT(S_ISDIR(buf.st_mode), "VCPU directory %s does not exist",
> +				    vcpu_dir_path);
> +		}
> +	}
> +
>   	for (i = 0; i < max_vm; ++i)
>   		kvm_vm_free(vms[i]);
>   	free(vms);
> +	free(vm_dir_path);
> +	free(vcpu_dir_path);
>   	return 0;
>   }
> 

