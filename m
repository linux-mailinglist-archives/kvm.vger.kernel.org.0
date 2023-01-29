Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B691E680215
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 23:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbjA2WCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 17:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjA2WCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 17:02:06 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093171BD8
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 14:02:00 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TCmeTv023085;
        Sun, 29 Jan 2023 14:01:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=3o++nYAInfHvoHmSPcAJZiFlt87jN5TR9KpuW9elRX8=;
 b=HrG90/+XmJAJJua4XfaEq6bXT1Ao6efiRIQnx/ZeFHSzugzCzwLBJd9hq2ZgmMO876Qw
 UfyPilIYG7Bv1WrcVh6jF/xRjEDeY1OT7Tfh5j/Xv3hhzp0RYWDsJmYaNXrQYdT95qBg
 0Wj1Ee5+RSMTYj1/08MPlBuvGfaDEqVKQ4vWLDW4H3c1mNzK2Wd29E+T4shUu1J9h2RK
 hl3QbvA9BRUolsniGmp/Np1y4L1/RrGq0GBX7+OWt8gfIeisloOBA1Rv627Hx50scFVR
 0QK9GOVX6UjrE1s7VMVY/FCC4Xw49g5CM0KQNzQsx3IJgmts/JEsyLsPyVBziDOwnOAB wA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nd453b451-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 29 Jan 2023 14:01:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOZfvQz90mGRkuzbXXAtUVKKAK0xj6H/QxDZCavrSHmkziBDMn4Mt4r2lcjQlWiCeJxMQkFbO8a/HgGAWx18KVHp2CWKLYPbhzN2famuYjKbL5Z3wlJ4U+LTosp+Y+e5QGrHL3D/bVjGJdUBylCqn5mtSVthxgZvv+l6B75Erb4IDNrpJRn8dZAyI5Y3MB4VT+St8BbpnhTAozFhqzsF74WIRDK25Sbgy9IP94ggf9zCNxL0jhkX5U1Ry32lmxurv8Mxo15nOlAcBFTXz5GYptMPR4511m4f+9XZOWT0EvM0YPsOh8sQd2DpNxblUltIF5WvJdVc1pv3+elllDb8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3o++nYAInfHvoHmSPcAJZiFlt87jN5TR9KpuW9elRX8=;
 b=X6WAZgdTvXN7BKDDXLLx5wGZYvg2U4QkTr/MklJhJePeFjR2ukv+/CV8XXHvZrTzXPtSEff8c+xdTAJU8/Pdzk2b3m64sb3u9bOPlupwodeW/IyypBsmf6bpRIMc8TwQNP7MZiSCat6+d2kuXwGYQ/HTKbuvQJS64LpO6BW8y17WTlRUCtklhlsWFUl2A5kaYAzt2rPzJ0n2pzV2zTZ5Bg1PEywSgBwGkD2dcEPk5fY3/0kZKOq8aT2Ams3r2aGqJloSA13JIZuWSKMs0ulI4o1HCowuypPwrYmK5MsOG7gAwyJmMZ3nskr7fNxduSiSFFu532wm7y1M0JPB5GoXNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o++nYAInfHvoHmSPcAJZiFlt87jN5TR9KpuW9elRX8=;
 b=X2hlH9V9hRdcZc9hyml+7eNnJonuJ7MnS0b8RTKAqqq9I/Zi0U/ZEla44qJapBBX1VMzx8x2x4CpFgJMbR/YkhVMIYXsU0YVOZUjn7Bco2ADvr7Dy8xCEyDemCxIzGSipMX8X9Sb+mQpuq+hUR/eyYDrgkhrZgesHl7RbH1iZ4BsdR9T+46a9cmItYu7tEFAIVLT8dV3KdjnpLXJ5QGNxgu7Ux0TADnLZubZBxaClLh1VDnPli8dHnO7DW7l7WxQln0kI5kU12iyt+tbzieyz+Hy14WewQfekDdln52Gv7GlDks0adqYFHn0v+q5bq2dsCcBfMSztmpDBPPsnZKjdQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW4PR02MB7313.namprd02.prod.outlook.com (2603:10b6:303:7e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Sun, 29 Jan
 2023 22:01:17 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%8]) with mapi id 15.20.6043.036; Sun, 29 Jan 2023
 22:01:17 +0000
Message-ID: <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
Date:   Mon, 30 Jan 2023 03:30:58 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
 <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
 <87r0w6dnor.wl-maz@kernel.org>
 <4df8b276-595f-1ad7-4ce5-62435ea93032@nutanix.com>
 <87h6wsdstn.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87h6wsdstn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0146.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::16) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|MW4PR02MB7313:EE_
X-MS-Office365-Filtering-Correlation-Id: 84c31735-dccc-438b-673a-08db02445869
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1P1ZZS3F4DvNv+fikMTLiFbaF8F7Z+b5q42Pw/wEeEk1ooZm93S+5WZvGDeFB4nKzdPEIbYYpxVnSFG2C7vW2TCGeZo00Ct5Cx4oU1rxsUzgnLMk0L6R0vWaD9GLts0+IdziN2xi1hLzkygE3zGZI9GC6DWjxSIVKhYdNfJZO6gLHM4tAl1zdWfsPODOxLGABnRsMsOr8CcBod6aZElI/Zhao7xm5+IYDTFIX7mC0Dg5f1kMXpf6lHmYh3AQSMMOIKKSR8DCD73nB6647bCDTR6ceB7ur6KxLVDDIjIHyCnzdq7NOQZscyaqVwxB9FJpem0kOkRIJco73fRGBewsPNG/GY+3XcTBpaAkaRRfYehMprxuygpmI8LfL1QGXHygrhR9GrzRPHybwZFDmHAwaNPs8BSJcMPDW5QaVKCcOqV0z+mgwWtfYZzTFMyJgH8VeMx5o0xQHwM3N806B9572AoHhcgoFpi0ByhfuDwxnMqIJGaaFwRHGVT278f43tCMHtuwRqY3XJ1IChOl4/peSHUZ5VhN2bddXO4DEmGrxgP2exVU1boGfkgF3L2/tkuj+YoglYohvFhTGJlhnhjDh48WfU6WSQSM/5LSnS+JauhFJf/ciFOVcmsdmTDAGM6CMAllCPenoBOuzeqBto5ZQAKU1eVVvKF+3/GleSj6mDKCEobH+toIRSlEm9CFt6Xc2wLJ7zLK0DoF0hcz6FDUIIMDX5PFbgi+2BamQKO5kUr/UvZ6mGHUyFzbUtsOQGC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(366004)(396003)(346002)(376002)(136003)(451199018)(31686004)(41300700001)(2906002)(36756003)(6666004)(107886003)(478600001)(6486002)(54906003)(15650500001)(86362001)(31696002)(38100700002)(6506007)(53546011)(66476007)(66556008)(6916009)(4326008)(66946007)(316002)(8676002)(8936002)(2616005)(5660300002)(26005)(186003)(6512007)(83380400001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEFBYWFBMEw1d0VOU09LNEVuR3VUSzVlSWJPa3JuSm5oTzFZNDUxTkRzM0FV?=
 =?utf-8?B?NFB3ekNLWlJDWWYva3JQcW9XM1JiWlo1ZlhiK1lOQnp5M0dMSzVUZkE4QXNv?=
 =?utf-8?B?MVRBQUpMK0JFbENxSjVtVzlFMFFJRGJyanN0MWliMjc5dG1XZzZ0aWZvQVY0?=
 =?utf-8?B?bVUwMFZ6ZEdSM2JDNTNJZVVWOEp6bTAzbGNtZlhxR3JKZzR0eko2UTlScVdD?=
 =?utf-8?B?SG9ST0ZDYnRUVFVNejNBckJONk1lODdWZzgvR1VHSUR0QVhqaDdCdjdBM0hr?=
 =?utf-8?B?ZFQ4MlFmNm5sUjR6L3lFcHgrblJmeFEzSFUxdFd2SWdXUnV4aEhlV0l2ZVV2?=
 =?utf-8?B?N2xrbS80Qkh0U3ZlTWdyU0FlMWpNWXYzYmViVkZTRUpST1lWREU5T0tUM3kv?=
 =?utf-8?B?SENzdmlVN0txTWFHUmF2MGl6Y0djcUJ6eWk2VlVZVjFjdEo1ZnZjenU3cGtQ?=
 =?utf-8?B?ME1sUXlsTG9oalhrTHVFYnVhbmJpL3JPcXZaM1YwbmkySHFJMjZmZjlnUTlR?=
 =?utf-8?B?SnpDRjJ5K2lOUEtjU2R4TndiUENDZmd4cnRuYjhQUlkrZ09ESTZia0JNaWZy?=
 =?utf-8?B?Q3orWUtWc05lOXM1SFJtWFNmeVVsaThWODhCOS82OEFaaHViem1ydEdPaWd1?=
 =?utf-8?B?Vm5WRDhCSGVGaXp5L09YVVJ2d3VyUjBVUVRlZHg2Z1lhbzRIV3lBMGxOejhv?=
 =?utf-8?B?SERsS01NeGlWZmdKM1BVRkR6QVREdURiWEQyYmsrQlZjOUxIK2ZEdkhmeHdD?=
 =?utf-8?B?OU9UNC80TFdtNU56QVJPeXhQUExPYjM3MFJaT0NQWGZ5UEc0TkdGVENTRSt3?=
 =?utf-8?B?bnd5aEc4ekpoNGhYbFVvRkY0TWxXN1dKNk1TWGZUdHVSa3pWdVNvdUZWNm45?=
 =?utf-8?B?ajNWTjUxNlNSeTZ6cjNEbStlMnAvVVI0S2JndElCZkhzaFNiOHNlb1ZvZWZL?=
 =?utf-8?B?Um1hVWtYaWJ3MHRJTTdZRVFOREhiNlRDSDRxalpOWEhCNUVpOUV2VkQvTkZa?=
 =?utf-8?B?a1hxTXRsOXJLQ1RWRHB2emEvdkJyemd1TmJERHJzYTZuMzNsQjN2aGdmckFs?=
 =?utf-8?B?THJpbDFnTFZKOVFib2ZKTE94d0xPS3l6MTQrWWVpUHg0WmU5Q0Q4bk5oRGZx?=
 =?utf-8?B?QVFzTzBXd1dxQU4yczM5b0NwVGRzMEpSdVZhQTZDTEhZY0tXaDEyYzMweHpE?=
 =?utf-8?B?YndIaWUzbk5TSkZNalh1VWZSVHVEK0p2eE1UeFJ4ak9LWWo1Y2orVkdyQkVv?=
 =?utf-8?B?Qm9tMVZPd2VKZzhvMVlBbENaM0dub3Z5bjFFcU5QWXZCdE1RWTg1ZTVSRlp1?=
 =?utf-8?B?V1NSL1JJZzVacU50VTdkUDFjc2hjMTVSalNTaWJNRlVTT2FaeElnL0sxQVJL?=
 =?utf-8?B?V2pZVnhHMGFIa0hGL2N3amUrdWFEQURuaHJYMmdqalRVbjJpUmNoYTJhTlBV?=
 =?utf-8?B?elFsajUwRnFRL0xzb2NPemVKajhSOThmTFNnejJuVGVSTTV5VFQ1ZURuUjQr?=
 =?utf-8?B?djIrb055eTJoT0JlZFdqTy9YZVE5V0NjYmFteDBvSUlpcmIzcDAxaVdIQzMr?=
 =?utf-8?B?UUF5M1RqNG1vd3MyV1RxdUNPUkFLWUZaRWJNN2hZM0xHaVJqbHJKV3hoUGFa?=
 =?utf-8?B?NEl2VlVEZ3hpbFJjVlpyRWZlSmdBUEVZSmpaVWV3WkNGSlM4ZmJkaCsza1V4?=
 =?utf-8?B?L2pCMkFWcWVvcXZ2bGJ1dXNyTC9QNG45WGpxYStpa2p1a25rL0tVdjloNmxP?=
 =?utf-8?B?UWRxOExYRk9UUU9rdUtFMFJCcllQQUl4d1VmNThGUUZkaU1JV29OOUUrbE8r?=
 =?utf-8?B?Yk9iREtZdGZWQjMzbTZLMlZ0Q0VtZjBiQUc1bnd1UEdRWmNIdkFWaXdwb2I4?=
 =?utf-8?B?bFdXS0duQUVvaWx5dFhMdFhJUU5hRnFYcnF1ZUJvdWJ5WHFxU2lOeUVWcXhW?=
 =?utf-8?B?ZDZmek5yM1hwVDlab0N1QXNhT0lqS2k3Z0lnTVdYUnVhbkRwcktYa1VDZlJt?=
 =?utf-8?B?M0hSdytxa3BDRjA0Wk5NMWpiM0FGbWVkZy84NE93Rk9RRFdKaVZJTVpzQm5M?=
 =?utf-8?B?VFVNeDRyakxkN1ZXRVFTbTc2ZUZWOGVGdUpWcysrQ0s0RkxJcmU3WHU3SGNT?=
 =?utf-8?B?ZGxwVnYzYVF3K0x2ZnpzVG0rVXRQWHhDVWxGaDF6OGFONDZOTkl4clBjSzI3?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c31735-dccc-438b-673a-08db02445869
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 22:01:17.1315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4wU+bLmklPfc7wmzbaN+rBrmTqMsc/9T4yeuLaB3JtC3nhe0+Xh0gmMP47fIHWzin9vBvDfwdcUm8gb6ZgEnI1qBKuyIGAjLFfMnHUv+QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7313
X-Proofpoint-ORIG-GUID: g8yIjeUyVenfadiLtmZRV1EmbMgCx_RT
X-Proofpoint-GUID: g8yIjeUyVenfadiLtmZRV1EmbMgCx_RT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_11,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/01/23 3:26 pm, Marc Zyngier wrote:
> On Sat, 14 Jan 2023 13:07:44 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>>
>>
>> On 08/01/23 3:14 am, Marc Zyngier wrote:
>>> On Sat, 07 Jan 2023 17:24:24 +0000,
>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>> On 26/12/22 3:37 pm, Marc Zyngier wrote:
>>>>> On Sun, 25 Dec 2022 16:50:04 +0000,
>>>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>> Hi Sean,
>>>>>>
>>>>>> Please let me know if there's any further question or feedback.
>>>>>
>>>>> My earlier comments still stand: the proposed API is not usable as a
>>>>> general purpose memory-tracking API because it counts faults instead
>>>>> of memory, making it inadequate except for the most trivial cases.
>>>>> And I cannot believe you were serious when you mentioned that you were
>>>>> happy to make that the API.
>>>>>
>>>>> This requires some serious work, and this series is not yet near a
>>>>> state where it could be merged.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> 	M.
>>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> IIUC, in the dirty ring interface too, the dirty_index variable is
>>>> incremented in the mark_page_dirty_in_slot function and it is also
>>>> count-based. At least on x86, I am aware that for dirty tracking we
>>>> have uniform granularity as huge pages (2MB pages) too are broken into
>>>> 4K pages and bitmap is at 4K-granularity. Please let me know if it is
>>>> possible to have multiple page sizes even during dirty logging on
>>>> ARM. And if that is the case, I am wondering how we handle the bitmap
>>>> with different page sizes on ARM.
>>>
>>> Easy. It *is* page-size, by the very definition of the API which
>>> explicitly says that a single bit represent one basic page. If you
>>> were to only break 1GB mappings into 2MB blocks, you'd have to mask
>>> 512 pages dirty at once, no question asked.
>>>
>>> Your API is different because at no point it implies any relationship
>>> with any page size. As it stands, it is a useless API. I understand
>>> that you are only concerned with your particular use case, but that's
>>> nowhere good enough. And it has nothing to do with ARM. This is
>>> equally broken on *any* architecture.
>>>
>>>> I agree that the notion of pages dirtied according to our
>>>> pages_dirtied variable depends on how we are handling the bitmap but
>>>> we expect the userspace to use the same granularity at which the dirty
>>>> bitmap is handled. I can capture this in documentation
>>>
>>> But what does the bitmap have to do with any of this? This is not what
>>> your API is about. You are supposed to count dirtied memory, and you
>>> are counting page faults instead. No sane userspace can make any sense
>>> of that. You keep coupling the two, but that's wrong. This thing has
>>> to be useful on its own, not just for your particular, super narrow
>>> use case. And that's a shame because the general idea of a dirty quota
>>> is an interesting one.
>>>
>>> If your sole intention is to capture in the documentation that the API
>>> is broken, then all I can do is to NAK the whole thing. Until you turn
>>> this page-fault quota into the dirty memory quota that you advertise,
>>> I'll continue to say no to it.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
>> Thank you Marc for the suggestion. We can make dirty quota count
>> dirtied memory rather than faults.
>>
>> run->dirty_quota -= page_size;
>>
>> We can raise a kvm request for exiting to userspace as soon as the
>> dirty quota of the vcpu becomes zero or negative. Please let me know
>> if this looks good to you.
> 
> It really depends what "page_size" represents here. If you mean
> "mapping size", then yes. If you really mean "page size", then no.
> 
> Assuming this is indeed "mapping size", then it all depends on how
> this is integrated and how this is managed in a generic, cross
> architecture way.
> 
> Thanks,
> 
> 	M.
> 

Hi Marc,

I'm proposing this new implementation to address the concern you raised 
regarding dirty quota being a non-generic feature with the previous 
implementation. This implementation decouples dirty quota from dirty 
logging for the ARM64 arch. We shall post a similar implementation for 
x86 if this looks good. With this new implementation, dirty quota can be 
enforced independent of dirty logging. Dirty quota is now in bytes and 
is decreased at write-protect page fault by page fault granularity. For 
userspace, the interface is unchanged, i.e. the dirty quota can be set 
from userspace via an ioctl or by forcing the vcpu to exit to userspace; 
userspace can expect a KVM exit with exit reason 
KVM_EXIT_DIRTY_QUOTA_EXHAUSTED when the dirty quota is exhausted.

Please let me know if it looks good to you. Happy to hear any further
feedback and work on it. Also, I am curious about use case scenarios 
other than dirty tracking for dirty quota. Besides, I am not aware of 
any interface exposed to the userspace, other than the dirty 
tracking-related ioctls, to write-protect guest pages transiently 
(unlike mprotect, which will generate a SIGSEGV signal on write).

Thanks,
Shivam


---
  arch/arm64/kvm/mmu.c 	|  1 +
  include/linux/kvm_host.h |  1 +
  virt/kvm/kvm_main.c  	| 12 ++++++++++++
  3 files changed, 14 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..edd88529d622 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1336,6 +1336,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
phys_addr_t fault_ipa,
      	/* Mark the page dirty only if the fault is handled successfully */
      	if (writable && !ret) {
              	kvm_set_pfn_dirty(pfn);
+           	update_dirty_quota(kvm, fault_granule);
              	mark_page_dirty_in_slot(kvm, memslot, gfn);
      	}

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b9b5c251a04..10fda457ac3d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1219,6 +1219,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm 
*kvm, gfn_t gfn);
  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
  bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+void update_dirty_quota(struct kvm *kvm, unsigned long 
dirty_granule_bytes);
  void mark_page_dirty_in_slot(struct kvm *kvm, const struct 
kvm_memory_slot *memslot, gfn_t gfn);
  void mark_page_dirty(struct kvm *kvm, gfn_t gfn);

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7a54438b4d49..377cc9d07e80 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3309,6 +3309,18 @@ static bool 
kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
  #endif
  }

+void update_dirty_quota(struct kvm *kvm, unsigned long dirty_granule_bytes)
+{
+	if (kvm->dirty_quota_enabled) {
+		struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+   		if (!vcpu)
+           		return;
+
+   		vcpu->run->dirty_quota_bytes -= dirty_granule_bytes;
+   		if (vcpu->run->dirty_quota_bytes <= 0)
+                   		kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+	}
+}
+
  void mark_page_dirty_in_slot(struct kvm *kvm,
                           	const struct kvm_memory_slot *memslot,
                     	gfn_t gfn)
-- 
2.22.3
