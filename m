Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5752A4DEA02
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 19:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243873AbiCSSWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 14:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243872AbiCSSWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 14:22:49 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21881267F88
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 11:21:27 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22JBNGak024479;
        Sat, 19 Mar 2022 11:21:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=IyrBxgnZSQueXBXJUaRAEPjPs5hjoPD/dgq584s1Tyw=;
 b=ioXUwiXctf5tas5hvkH0yrHx/RFQ5SFEdHsk28benDwyaPYP9iEBbdxhC/iFTlyRGEPf
 4NrtYIJthog1AZy1dWDubhAueIiga31CR2nyOue4ZjhvvSx//UxE9iuP8AVzl/SqamtW
 GauR7BrJrWA4KeJOtsMF+ZjsjyWqsgAM033p3BnDa2lIH4IPtAn9XdpC7NMYzpeTRK+6
 vsuz+bA59MdPPRKSJ9/AzXuN6NBXczzaRRLOky8oZRxyEsDGMJ2g9j54YatKN77RkgQ7
 7/AbRLZHoGGDI7HLzz63NEk2CmATr1rrXoVhZyBAgHTNGFkMZ/KOe0oIty1/XtuAW3HK Zg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ewe8erdxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Mar 2022 11:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpg4ltmKBtOx0/lirpOxNi0byeSAZMrnOe41Li6Sv9IAvSEhJYjWj8qivtFTnNNAeaIijMToEs7eGkaLppNuM1nzE6mKNsi/CXJlGdQdvUKmWZaXByu9EFU1t35BC8ztZiatvun/yZiwF4id9po9cbj6md6YCEw5KDI+XNRmFeNKl7ChNCMlI+jWdUjiYnFh6KZknn5LJuR/sO8suxtB/kWs3z13FpE15MABgM/FpTBPa+17ogFkShCVVnNKRTonTvkX5tYUEW94WV2f4KTJ8D3Q5hWp9Vj+iYVPR7UxrebaulTdtEumSHCCJ3O5LcSeI4KQdnru4qPaT8QaQvTliQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IyrBxgnZSQueXBXJUaRAEPjPs5hjoPD/dgq584s1Tyw=;
 b=Itzxm1AggIZux+tAciPIvbrFqUYFc17r79kmUF9dMDl+TjChgb42X1nfRfpiBm3sYZG4MQMTJAe8Ogz1IBeL+Bvg6IyiKsXsbq0qRrlKl6qRbGa3eQMiBCVqlLgv401kdv3mfscRb7dEEHs41jnNx0yXpE3lg8Sg3AIvp2ky0vKyc/BqSGSEbVJa+b6/9s3STUHzL+e1LeI4IElDrVxYVLSZUb1gRV72DXlRNTV4i0eMRQKjN/HsCtGYd8pZVS9Ssk1gj2e3lD8cfs4G4i/b2CRV65U7mlaIsGtlqX9j9ha/aHDbbcd5WxYMLgbi7YfW22LA02UNH9uw7ECMJ+8o4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM5PR02MB3896.namprd02.prod.outlook.com (2603:10b6:4:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Sat, 19 Mar
 2022 18:21:22 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::44f7:8b85:7e8a:b4e6]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::44f7:8b85:7e8a:b4e6%8]) with mapi id 15.20.5081.021; Sat, 19 Mar 2022
 18:21:22 +0000
Message-ID: <949aa1f8-696a-bbdf-7f74-8bc1f7597fff@nutanix.com>
Date:   Sat, 19 Mar 2022 23:51:10 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 0/3] KVM: Dirty quota-based throttling
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0160.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::15) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2169d1ac-df37-4414-fc49-08da09d544ed
X-MS-TrafficTypeDiagnostic: DM5PR02MB3896:EE_
X-Microsoft-Antispam-PRVS: <DM5PR02MB3896669FECA42E0E35AA2455B3149@DM5PR02MB3896.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6x/xbMsyMfIho6p7lwZ8L+B6opQ/QtOnZ+7RkuW7o43aBLZfEwcP+8F/ox7Oz8slfPe0P5WmeV1HVcXW93vRy6qCf4T/eneekxIaMpBrUpPhzljnoZGnw+lkeplpoxGwLrwvVFVRSLQhq51wNJ+15mj4Rr44f55zhtvnwxuzf4bwvOWzylx7CopibGbcQ6LtqnNwnyT1aSh999MbZS6CazSQEFFtFY0oK59szGj5G1HQnz2+EgkpsLjnvbuMAkBU2XjkaByl0w8sVJw3AluvAI6IFklFEcu4QA1/9vg7uSa7H8egxcwgx2BVUWASTh4n5LZWzonqasnuaxr0SSYdKm/ym/pQCLKGXZaEV5VfHwVozuakcYsQkKz6iz4IylSyWVfEA9BUaJMOA6b/EzcosJ4lBErFi0Pe3DagowLUZojMDLMPcDRI0ufIKNwDe7PXInOJ6TiqSdxz9iaTORsc8rC4/0Qu4TC6BZvSY88FjBnTIUl8UFWKacpP+oEKRgjGBanKbTqUxiXDLP1ZIVZqCMvpPG7qcHz5mlOpHuhErAORKYk7ql+l1511Cx0DHDsRaAL2q5BcGNZpNW6+cmMpkDHcDQwua5wutv+mJ02V3qNhtE3eGG3hZgwV2dVPyCdkhla6WzmmmJhXddG4sVvH+7Zrv3RS1J01/B4fmCKdL+Sln8fqZkL4JJNWFrXZRdvmNh4HMJgdbgq2KuZ2f9qLY6cMOv7aBL9WFtuJFemRfv0lY1d0O7oDpq4qrxd5Yi0s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(83380400001)(15650500001)(36756003)(2906002)(31686004)(5660300002)(8936002)(86362001)(6486002)(6506007)(66946007)(66556008)(2616005)(4326008)(8676002)(66476007)(6512007)(53546011)(316002)(6666004)(31696002)(508600001)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHRFRU1xTDFYZlVWZEkxRDFQcEMxZXcyZTFtcmlZajRnZWs2N0lzbEhKQUlj?=
 =?utf-8?B?eWhvTmxHRjJvWDVXSVVnUEtzbEU4aWdENkgyOTlkalA5K1o0UnFzQ3RJdU9v?=
 =?utf-8?B?TW9WQ2orejdMbldFWnBRdmpJNEhoUU1semFTLy9FVFkxTXkzZUd0TE1IZjRx?=
 =?utf-8?B?dVpCTm80ZG85bjVBaUNqSDBkeTJnSGZldlZnbVJwQnRQdGVpdXZ2L1dBWmcy?=
 =?utf-8?B?Z21QRW96VTNRZ0xzVkNuK2EvZWRYRWJTcWJBZlo1bHp5T3lDeXZ4dnBveUpT?=
 =?utf-8?B?RXVscGhKYUlkVUhnSEFlM2daV3VCQjRoa242NGVZNCtPVGlWZldnQldNWHVj?=
 =?utf-8?B?RE1SUjdRYUxUM0Ryd1M2RTB5Ymh4WnUyL1lpZUQwanM3alR5eTIrOElkSjQv?=
 =?utf-8?B?TzNwOWdGMWoyRkQrRWpweEsvb1BObDRkUlhDajE5US9NSnVkUHpjWXdGZDNi?=
 =?utf-8?B?cTJvQ2s1SmoyK3dXYjZTSnV2bXEwYS9FTGdZS0dyZnppb3IzQ1hqUTgzUU40?=
 =?utf-8?B?eHNCS2NsSUFRMHVMNTU5dEFwWDBwV3JNMVlSTHR2TFYyU2UvSDdMZXhzNjJD?=
 =?utf-8?B?NzFXcXdsWkNOTXc5V3E4TUt0NVJ6cVl4VGd0RUE5MVdIQnpCN3o2MHM4TXdP?=
 =?utf-8?B?Z25BL2lOakd3R2h3U1R4Yk5VT3JTN0g2eEJDQmhtZ2tHbSt5aFZkNWx2aW1Q?=
 =?utf-8?B?aFR0MXZMbVpHYkRJWG05aFBuQjBmTmRZOTZaY3J2ZkJ3MWhrL0dGNGFyckMx?=
 =?utf-8?B?eFVkbWM3RDBzcXAxbXBacDZpVndCSjgwbVdUVzFjRWRaWkVpbUhUMngwenZx?=
 =?utf-8?B?VitlQ3ZOTlZNeTNGcDdWVmY1NGVlZDhFN05jTjZvMVZaQXJRVXhWRlhKY0VE?=
 =?utf-8?B?aHJ6d0psbTNSL1ZQMG1Edlg3UytGRXpabE1tNWJ3WkZtaVNqZ3YzVDEwVDRY?=
 =?utf-8?B?c3Q4dERYU21nbGthYk9TL1JvS0c3TmdnRUNQY0ZXUEJjTWI2M3VEUjVPTU9a?=
 =?utf-8?B?M0JVeVF1VDRKSkhhL29xeC9IU2hZeDZuOXErSUdOOXM3N3dYb3R3U1RpUzQ3?=
 =?utf-8?B?MFA5cGsxUCtFbFR1bXpQUG4zdG9WTFlBMFBpVG1uelVldVJ2cVhQYlBjTE5I?=
 =?utf-8?B?VERDelJ4d0UxcnE4L2hmMTBBdkFiWEZtMXk2UnlTdWJNZ3JmUit3VGZYZ0ha?=
 =?utf-8?B?TWFHaEFPYmE2bmFwMlhiR09QaDlnZERKOU1oOWJVdmdwbVZUSW5scWd3eEJ4?=
 =?utf-8?B?aW93YjkyOGwxQmZmK0pnQlNzVHJIZDFSUDFsVkNrVlBQbExEcWJ4WXBCc0JS?=
 =?utf-8?B?LzJHNWJLR3lUcjBMYUxvd1pJL1pob0hkbEkzWWsrRDM2L3NJMWkrYkJ0OGxs?=
 =?utf-8?B?TmV0bmtrVUF6cVEwRFNRNm1OMU5ETVVlWXdyTFYrbTNzRzVxa2tQQ0pvcEt4?=
 =?utf-8?B?K2Z1c2VYYUZzY20xMVZZai9lZ28yWGVtR2hhNUZ2UzBhajh3b083YVJLYlp5?=
 =?utf-8?B?ZWlDa3BEcU4yVHVBbXYwT3FSRlgrS0JQRGlLanRQeFhQUE5OdS9QK2xGM2w2?=
 =?utf-8?B?eWttam8zeW5iYlJSNFNaaDRtUk9JLzZNbE8vMjlCWGhFM3dtWXVBS045WnRp?=
 =?utf-8?B?c2xQc1JpdFBXSzlCc2xEUDYvbHp1SDNqd0cxSGhXVTdycmJnR01aeFdrZXpZ?=
 =?utf-8?B?ZWdTN1dRU29FS05hRmdzM3Q4Y3lqTHE3OHcrbk1WZWU1SzBPVXowbHJ4SG9N?=
 =?utf-8?B?Z2F1NXhLL2Y2a0tEMVZ1bzlva1I5WFVnKzd0NGh4ZTc3T3RUNi93S1d5N1Ru?=
 =?utf-8?B?ZU9OdUNCNXJCQ1VHNzYvNDNhVTNEQnh0Tkl2cUFEbk9LRk5lV1Bxdjg0VDhF?=
 =?utf-8?B?TzJ1RlV3MTBYWG1UZTluWWc5dDJKSE13Vm1RODlYQzNzdExuYlJBNmpJM2o2?=
 =?utf-8?B?VkJUWjhIcE05OXNNeSsxTks0N25nNE03S0tpNkdPU0djNDh4emJBRzJrd2tT?=
 =?utf-8?B?T1I5bytQNk5SRnBIaktLUUxNQndCWVVmVmhGem1wR1ZvWUNwbC9hdHJ1Z1hQ?=
 =?utf-8?B?aXNjMFcySEJOWVlzQ01yZzlOeHFZL0ozNHRaZz09?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2169d1ac-df37-4414-fc49-08da09d544ed
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 18:21:21.9239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnpj63QJ8PRexeZ6yXBfnvgxXBG/nNHBnRftyk56BuH7H9uS8d6Q/uNUlExeho6Lkqx1ewaLmhczn00F/C1ugr3nq9B00l+Lm0Y9SD6/EAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3896
X-Proofpoint-ORIG-GUID: d14ikUp0xf5MwPqK-VtZ5qTiBHR763KT
X-Proofpoint-GUID: d14ikUp0xf5MwPqK-VtZ5qTiBHR763KT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-19_07,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 07/03/22 3:38 am, Shivam Kumar wrote:
> This is v3 of the dirty quota series, with a few changes in the
> previous implementation and the following additions:
>
> i) Added blurb for dirty quota in the KVM API documentation.
>
> ii) Added KVM selftests for dirty quota throttling.
>
> Shivam Kumar (3):
>    KVM: Implement dirty quota-based throttling of vcpus
>    KVM: Documentation: Update kvm_run structure for dirty quota
>    KVM: selftests: Add selftests for dirty quota throttling
>
>   Documentation/virt/kvm/api.rst                | 28 ++++++++++++++
>   arch/arm64/kvm/arm.c                          |  3 ++
>   arch/s390/kvm/kvm-s390.c                      |  3 ++
>   arch/x86/kvm/x86.c                            |  4 ++
>   include/linux/kvm_host.h                      | 15 ++++++++
>   include/linux/kvm_types.h                     |  1 +
>   include/uapi/linux/kvm.h                      | 12 ++++++
>   tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
>   .../selftests/kvm/include/kvm_util_base.h     |  4 ++
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
>   virt/kvm/kvm_main.c                           |  7 +++-
>   11 files changed, 145 insertions(+), 5 deletions(-)
>
Grateful for the last reviews. Would be great to receive some feedback 
on this. Will help me move forward. Thank you.

