Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3E5B5340
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiILEaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiILEaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:30:09 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA1DF588
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:30:08 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28B9fCLm013134;
        Sun, 11 Sep 2022 21:15:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=4RJDZ7uIup3wb/TOfLXnlHZ9SXZFbJyRNlFNgDhj1wY=;
 b=or/VBzXlk1DKGWWJwbO8I8qVLqyScqtt8MiBddkfMXXBBTGaiHkxEynH5Hkq1yxXCksV
 jTs/MQTO7XxiNLz3A6ylE1kl3YKNg5izai4M8x6R8tBDkae2ZFq1SGs2E8O4eMkJV5vy
 Rh15xINN2MPdWodfZw56Dm72t0Tfe3UJFuLNn6W4zM4AAus+mC0EdDDVcf9iR76de7m4
 hQo51Cv+x37Ic7MO0LATKKMHC3HWP9u6HZSBAffPLdzkp18JdsuT45+wXa6yxASwiSlS
 2BuYDwveVOz53EKClg/Ckic89BW5zmo89wtHSkp8lO2odHmO/wsrnSzNh4pFYutWeTPe NQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgrphtsn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:15:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDbddRCFlW6yxdHZwuaVOTvDO5chRLZnOzQ4rirH+oE68jB1NU58vRTexRGPNsOCi+kQ5fvjpYatD0R7K169GzRhLe6vksv5c/u27ArRpLLZaE75MsICU91T38rP2Q1iubmwFSMNsnDM7goBEtA6xAZpqdMyTvHu2a63LUxz2rlxvysfj3akHQxZbsfGwkwsqVheWZHNOVt6znaErl8zVeiUzFOvdCLDUTQyfm8qwTXfbDrooohJ/xyYiunQv5Dm8OER2Xe7ElZRJ/yV+BfGRSVbhbEk6xEucXVD2r0OHUnJgbSXW9S3/tnvokySJff2K4j2cfA5skyTHUIakzW1lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RJDZ7uIup3wb/TOfLXnlHZ9SXZFbJyRNlFNgDhj1wY=;
 b=aurKTukH2LVT2CEQEYDCFik/R926gdIWE89JbtIO1/lThYM25LKCsg4ANBPUrvVrFYXotxDTf3Dt3TorYafccaUjDbOp9bV1PWhYlgr8iqunGcnqDSGDfJfBWRwVkm2telasR5me2q/nmwe9YXCsW8GYZk9I51W25G9FXwdFpqVXvOKhrRtmgX2d0igdTO4z1CT05YSJapw8nC7cEcWhpi654CvcdAFWeqYL2slTccQauCV6Eraxy8NdRmn/MkGNm+6bzwKBO+rnQOr404j4upiUwqCiNnjS2VldxJP3hScnu9tnSmk5cbyNyd8Hwzmf+aZ3taSjEZN2dIqpazv9OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB7320.namprd02.prod.outlook.com (2603:10b6:510:8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.18; Mon, 12 Sep
 2022 04:15:33 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:15:33 +0000
Message-ID: <8cb9cec9-2ab3-1050-8d7e-e61461067f58@nutanix.com>
Date:   Mon, 12 Sep 2022 09:45:23 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v5 0/5] KVM: Dirty quota-based throttling
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org
References: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0149.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::19) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|PH0PR02MB7320:EE_
X-MS-Office365-Filtering-Correlation-Id: bd07638e-d9f0-4d98-c625-08da94756fec
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2lrhMkMHwOfnigmyx+6p+6RlZ7w5pA6ukrY10BvvyeQMcTzxd9SZ6EdAib4C+HNiJKsJrIZ3yT2TQp/62r3zgxda00zfU5BqZbEp1Kpd97Da9mNu36uYR4/BT3Cr7XqEiHBFKEBk98abpVoCTyjKSiwRGmzP4x+ayoIF9LYR0sLUG0QzbfbjPg30MD2Yt7LajTCsr3jfcF4BeEPiiDMlxs24dDZ5jyvts2Ro7B1iG4L5jC27tIwHLOS+NT2Ox/405D7rzVutBGCKPa8PMprz2KWtjwNvVYFER0UjSE2I5ROmxh/Ah0cTFwd6teLIlvYRtU6KkCLf8/kbQhzMwNSLrONM/VqiI/ykJNCbcr8oQayk1yLO8bqzYqk6yp1sLGxIV8TUBgFDsaNgoaLhx+uCU93d9aGmwYHuBK8su4n7My9BRhaXTDzF8lpOXzEwukx+UY7nsuiWCiXQLZwpe4IrsCOuE25MWVBXVEFrrDWRpgHniru6MTMLkaYF47D0e1dOGepw/1HwGPNPRnMLYbDcdeiY/Np2lPxgTu9oM6wk6iHoLxjUW8lrcJXAXBG3z9EQAEfHWdxlWgtI7rPognFOrJpmICxbDcgoO2pahqk5aQjopLHxKkE+IOQXieArXvGP0usYGVX3HhOQ/2nacgRFqnag7FYft0GKxQEhqx/BYexk4S9HGsXDhGC26drX8iemGrwsqKfZMkAU7pIZ3kU40RIHPOAxZMj8duMVhKCymMHKYkNc4JXZaqy2V56WHbv4rgU/kA+3mzjOSEVA95k+rRauqwXJQTVYHmBEQ/8cv9k7wMLddcgq9ZFmfjgFzH5GoiP+C7hxPrzRXRxGH6tZWMYdzbGuLEH33hb0gzwewFagm00Awp5Q6gvE6XtuaMOMGSweHb5H2TKVyvosxq9Oug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39850400004)(366004)(346002)(376002)(2616005)(83380400001)(36756003)(66556008)(15650500001)(66476007)(4326008)(66946007)(2906002)(38100700002)(5660300002)(8936002)(31686004)(8676002)(966005)(86362001)(316002)(31696002)(6486002)(478600001)(6666004)(41300700001)(6506007)(6512007)(186003)(53546011)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1FCRTJlN21oak5hWFdYWU5GbmpRQWRxMVlIaktIRy91WUhsNHlkTkZ1TXFm?=
 =?utf-8?B?SFN0NWUxL01Pb0tQU3F4QzhjVXdIaGtDWDNrVjE0UGpsM0tOSHhSVXJhdy9G?=
 =?utf-8?B?U3FJRWJld3BFS2RRT2NXMjE2RHZ5cVBEcDJsdUVueE9PS2pFRkJpZE5BZjlo?=
 =?utf-8?B?bTFjdFplYXRDSVNqTUs2aHhMZjRQd1RTUHB0ZHFJYnVOMnFsek5ZM0VOMi9D?=
 =?utf-8?B?SWVDOU01K0lJRWk5WXFvSkNTWW9WN0cvUTFDY3djZ0liSUdqbDg5VUlpY3VZ?=
 =?utf-8?B?RDVkL2NWN2JyLythOTU1OFh0ZVk3M0JycTBkaDJKZm5Eb0ZxMFY0aldCdDVB?=
 =?utf-8?B?bUJMKyttbDBNdjVJUXNhc0FmcnpCbW4wcnF3dlBLVCtzcnNRaDFPaWlYMm5T?=
 =?utf-8?B?ZmFlWUY4dUp2VWlGbGFIVlo1ZGwzMGRSYXY4UXlyYkxKS253QThYdnJPQ05D?=
 =?utf-8?B?aWJGS0VGM0lMSFo0LzFoVEh4V29FbDJERHRTRWhzSXZpWmdGNjJSc2c5c0Vn?=
 =?utf-8?B?Rm4yMGpjS2hJYVd1c2lBcVV3MEdRb3ZnZTNvRUdYUldVUGkxR04wSHNRNUdD?=
 =?utf-8?B?cTJtN1V1bmlqOG05a0JsUi9OaEptYlJDYzFrMGZDVEhWVmJkemxMVnpOa0xR?=
 =?utf-8?B?blR2YjNIaDJ1NUx0UUxjUjYxNzhqZTc0NFlMWjdwN2VFei83SHZWUW9Zb214?=
 =?utf-8?B?b3BEdUhxYmpmYXJvUzg1cHdBZVZvSWQyOUV4UGtmWllIRVdyR1Zhc2xHWWIx?=
 =?utf-8?B?cnNjYUFnNHcwcTdJaEg2WndDajM3bnlOVkhGSTBSTXNUd1REZVoxU05yczZC?=
 =?utf-8?B?MUtVekwrR24vWDIyWFZwelYyRTU5TU5OUkp5a2ZndUdySUJrM0JQOW52R2M0?=
 =?utf-8?B?cVRzYjZ1elNnL3hRRElVWWdxVk1oL2pXb3ovUTM0ZXplTnVsWFFPRUd0Zy9n?=
 =?utf-8?B?YmNzUERHRDZwSmV1QlR3TVprYlQxajkvbEV1Sk0yNzAyNGdzT1pHZCtHcStm?=
 =?utf-8?B?T0NWUGZKMUlGUXpJNWIxQ2t6b3JSaVp1Wm9zSjVoYlZrWWZLK1RxNXlHZ2NN?=
 =?utf-8?B?ZUFkQ0pZRWVILzZwOHp2YlBoVkZYYkpjU0RZYjRTano2NSt0TXJ3bmpXUHhx?=
 =?utf-8?B?eEswQUNRZDJ3RXBGN2VObmZOWURFWEJuZTZpZXRBRFRUeE9uMWp1SUIxaXpi?=
 =?utf-8?B?TkZsRmlJWExyTVYvUW9yQmxHSUtPOGduZVVONDI5M1lVMERvNVlxTktqdzBo?=
 =?utf-8?B?TWVyeFI0YnkxdWxSMTVxbWJ2TjhrK0RVazRWbEFiSlNOUFMvVEtCZkJPVmV2?=
 =?utf-8?B?TU5OWFJ5U24rZjFqcm1uVEpyMzErNXFZdW9Qd2x3WGEraTBZUjNRcDNJMkw4?=
 =?utf-8?B?OC9xMXdJQzNMT1VUKzhBVXlPYXk3eHZkdkxyU0x0cVhFb2RudnhHZ1pUQXlZ?=
 =?utf-8?B?cGdlR05GelRsODQzWEZ3eC9xRFpISjV0SmtremY3MHhLZjh2Q2crMG81QytL?=
 =?utf-8?B?WmJKNzU4cCtPU0MxTGlnZVBUTGo5ZG9JK3hTSnE1VGppVmo5RGpkakdocGMz?=
 =?utf-8?B?azR4eVQyaFdOdDVFZW1ISFR5aHpHUXlONXNKQ1hQUGhJV3A1cExSMHcwSHNO?=
 =?utf-8?B?SUVPdC9mUFJqSzNhS2Zhb01ENG9JbVprNGFtUU9RcXpwTjZKdXFsbG5rN2E3?=
 =?utf-8?B?Qm9HdGNwcG5abmZFTkNHZUFBK2FocjNUdjY2Qjc2L25kcm9jZGVnV3p2YWkr?=
 =?utf-8?B?MDg4TVlleFVLNTNZeXJ4emM3Zi9UMzQ3bjYwM2RxVmx0ZjV6WnYzTHp5Vy9U?=
 =?utf-8?B?eGp1L2NlUit4cytXemZQdkRoTVQxUmxRTnR5NVpyT3ZIREIzWURROFJnQk9s?=
 =?utf-8?B?TkRzNk00c2VHdTVuQ2NNdFRLK2dMSC8yQkRlK3VwMTBsMEdFU3NEU2dlTko1?=
 =?utf-8?B?WW1salVxMjJqSkovY0kyQTRyTGRlMFo1ZTlHNXVvZnlQd2pkeGowaEsyY0t2?=
 =?utf-8?B?eklrdjhLNG1YNmRGMmsyS2hYSWNQVHBvc3pzUXNxSXcxd0g2QVBXOUVPc29r?=
 =?utf-8?B?RGdYaFdsd1lDTVNPdnNBUVRpTGlCY2drVFlsa3VmNlVvWnI0NGxoT3hDV0ta?=
 =?utf-8?B?eGtXeDJmUGxUbzVXNjVlL2hTZTJWbGs1RGZKakJ2YXdad3d3cFBrc0ZsWXVy?=
 =?utf-8?B?SzZDMXVwb3hmVzk0bWJNREpVbnQvSTJBNGpuVjFMTDBzNW13MU9IQis5aEpq?=
 =?utf-8?B?RGN4dU03SEdrdzF2MUMxZnRJTnB3PT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd07638e-d9f0-4d98-c625-08da94756fec
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:15:33.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LH2nwJwRpa7WwfX6AMDWFWeFxsPBvSvWiZCuNfhAxJbhG6o3gQkOvFNZLQFHOi9jwRZtYTWLuxJzeMCkHxCKwtk0G9iUs4M+KG2XKzvN6XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7320
X-Proofpoint-ORIG-GUID: LWJZEVEn4kmiwp0i8EF7IhQ6L-HbszeH
X-Proofpoint-GUID: LWJZEVEn4kmiwp0i8EF7IhQ6L-HbszeH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for the delay. I was out sick for long.

On 12/09/22 9:39 am, Shivam Kumar wrote:
> This is v5 of the dirty quota series, with the following changes over v4:
> 
> 1. x86-specific changes separated into a new commit.
> 2. KVM requests used to handle dirty quota exit conditions.
> 
> v1:
> https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
> v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
> v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/
> v4:
> https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@nutanix.com/
> 
> Thanks,
> Shivam
> 
> Shivam Kumar (5):
>    KVM: Implement dirty quota-based throttling of vcpus
>    KVM: x86: Dirty quota-based throttling of vcpus
>    KVM: arm64: Dirty quota-based throttling of vcpus
>    KVM: s390x: Dirty quota-based throttling of vcpus
>    KVM: selftests: Add selftests for dirty quota throttling
> 
>   Documentation/virt/kvm/api.rst                | 32 +++++++++++++++++
>   arch/arm64/kvm/arm.c                          |  9 +++++
>   arch/s390/kvm/kvm-s390.c                      |  9 +++++
>   arch/x86/kvm/mmu/spte.c                       |  4 +--
>   arch/x86/kvm/vmx/vmx.c                        |  3 ++
>   arch/x86/kvm/x86.c                            |  9 +++++
>   include/linux/kvm_host.h                      | 20 ++++++++++-
>   include/linux/kvm_types.h                     |  1 +
>   include/uapi/linux/kvm.h                      | 12 +++++++
>   tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++++++--
>   .../selftests/kvm/include/kvm_util_base.h     |  4 +++
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
>   virt/kvm/kvm_main.c                           | 26 ++++++++++++--
>   13 files changed, 190 insertions(+), 8 deletions(-)
> 
