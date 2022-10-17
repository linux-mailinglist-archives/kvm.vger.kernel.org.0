Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC5A600648
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 07:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJQF30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 01:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJQF3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 01:29:23 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08EE537D2
        for <kvm@vger.kernel.org>; Sun, 16 Oct 2022 22:29:18 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H47I8B025382;
        Sun, 16 Oct 2022 22:29:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=bOvulvt9ZzeCDYByCvEzDcpKSS09gNbp2ZknjDWjeh0=;
 b=fNZGuTsCrX2H6zDxDucxsTC7odbhtzY+Qnks27iHc+gjOHP54ldQPu9oqByCe7JZ43oa
 bBtgl4BwqvROk4tKd+kN+ymH6pUiX6x/K/O5xnPSwpxfWthgXb7Ol96hNkw607KxnDp1
 R3Lw7yupnnuLsybIaV+Fne1Mj9nA1lCAAda8TjCAvo1xE5za3Sdxu8GtaZeBUpjdcJjt
 HXtxeJl50n226DER4UV1n/c6J8r3OI+5DK7gMsYDvIaErx/zmOjwE0JhbRdtFOGAECtG
 Wd/lN81xa5ZAbQJsdJm3ZSaLFMPu+dtv1AT2p1Cdj+4e5x/ujOapTH7mnzFvaGCGkta0 8Q== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k7ve0bck2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 16 Oct 2022 22:29:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgzWba/OwnAmHtS2/42hFTow3yjCuhIxqqcu3ctiBYIloSj4TaR/nD8DqkjuVm1y59aWrP2N+tCI10sKK0cWSYh3p1aYOLapkbaD9EXU7Odzk5sKVyyv/F3wa1Xh1BXjdx3ydp2s7gu7zqsCZlOj9QU3U9JwDlFmDmjAEkhELA1JUkOw8AJ1v6CXhu7apUc8R0sFP9DIhdyYeZ/LwBqm67lUFTHkVEw3BlSAmxUKzY5gFA6H1OlItCbFmpBMdYibAxUbgR8baIhlkETomDB+JVUyU+LSXDN4HDp9/OHtpnAFBIi+wy6F6s+1zpDHuKudhixoclNSXt/2NYnBOoPzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOvulvt9ZzeCDYByCvEzDcpKSS09gNbp2ZknjDWjeh0=;
 b=jUaZi9deEqxTmCxJ/CGTNEtXkgO4PP1WToVlxP0LNOlA+IU/sI+DgWVzRzA3TJWu/DlWQlGpeGeHkg/cAEdEIE9R2I7tfhnim62uFMxXgx/35qayuxw0rHhp4F6gFQuEmw17gGx/lBIL6YTpY9k7SUIWxHS+4wWo/LRxiyGJnqz10WWRP7ZlVRCX3KOemOL9IBIgTomb4BwGWQ4dqruqNGu2pYbuil7YRbX27yuJJsww+hpXOcU29b+wdwTDFKxVGF3QI7KQStTAatDZ5u1TmL6t5ZSBmytKExqhEQAuPAy4F7t0l2imtXNZzAVTdQqqyrKt1IJ6HYeeIITUN1SV6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8253.namprd02.prod.outlook.com (2603:10b6:408:154::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 05:28:58 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::a337:4fdc:23fc:f21a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::a337:4fdc:23fc:f21a%7]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 05:28:58 +0000
Message-ID: <1231809b-d214-ba10-784b-d2b015a69e09@nutanix.com>
Date:   Mon, 17 Oct 2022 10:58:46 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <21fce8d9-489f-0d7e-b1a6-5598f92453fe@nutanix.com>
In-Reply-To: <21fce8d9-489f-0d7e-b1a6-5598f92453fe@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::7) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BN0PR02MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: d54f23f2-c756-4f2a-5b3b-08dab0007da7
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4Fvr7leTRpG+lVdzVE05YcTqZyhIhMo2xNB5PghWJ4UWmIC+scahzRl2MtUuSRMhzaPX6XQ9iTeeAvBG4Ror1Ud1TNcUbem+aW7/gLuKwYeDfCYA7kptGmbVhME5aTaQJo5XeObmEgIq1JKHpw7PErYSbLlTMxhmImjwY7rnvpeN+8W2QculcoxrTVZIoOVShg6yI+rnPk5Mc66wpFG+4lPQjNB3ytn40vbBzdDwN8r9eciVMLWk0DWgPN9EMu4A9C41z5mx/3iyi5MSEWyK8UGtTobREvZn3iLufw8rCx6o/PEn3z5ku1kNjUSm0OaPYel0GfFnOmkfMj7fwVHVeNHfxD8xHiHwPQtlT+krDIU+Y3StxF8dDVtWOOFQ2sN19DHj33rZ9XlDvq72BkVQrTv8rS2qy6axKyy+J7yDqXEGeZYd2aO+aYLxIBK9JL9rUmRwol41YWJuzFV7aesqPYOFl9lleClewRMnTzXhScujCCQJlV9bM8Pq2wChAYZA7/ZiNw6Irins9oFfDH7B9dapoQT1tVSXJkk0uax18V9TfeS6ViDva8WswDCqbWccjfpi9X+/JSQZkN8qUZDGC/nE2CuTF+nceI6gLoPUcArTf2O3htXj2D6GyJ/soq9aHq42EiuC1qXaFIrPXlNKhLHvN2x4OBIdX+2eBkV1TFPZ1QwHgBfgEQB8HSwFBSNjRWkSp4mUCxRib37MNYC5fLgXk1jXKUVXyz3RX0YYgvAl61Kdx7LYXTeObmp00Q8odlbtBduRwAOCvdhFBdjehpRwQhMQv6TwwtdZ5Sc0btTdNkolyoqzh+yxajtiJeHHnPDZUGtZnER/gKNO1OQMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(31686004)(5660300002)(316002)(66946007)(66556008)(66476007)(54906003)(8676002)(4326008)(6506007)(41300700001)(26005)(53546011)(966005)(6512007)(6486002)(186003)(2906002)(8936002)(2616005)(15650500001)(36756003)(38100700002)(478600001)(6666004)(107886003)(31696002)(83380400001)(86362001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUY5Umc0ZmlLRkhVKzV5M0V6Y1NFQXcvN3p5TmhGbEZxWHlod2wwcVM5d1Ra?=
 =?utf-8?B?NVVnQ1FvVVJMYlZDNU1QbkpXZmZXeG5QdkYvek5nampXVk5sc2ZSVjRqQVdz?=
 =?utf-8?B?akJXeXlQRkZvYVNLTXV1bnlieTBUN2djVksxeEcwZVg4VlNHeWVhdmludmNt?=
 =?utf-8?B?TUllNDBhSjc4YitrS2RuUkZ1WVRqZmhZVU4xQms5YWlkVHErZjQwejVJNWZm?=
 =?utf-8?B?eEZyaURiVkEzMHZOT3dNT2h1WFV1cmJId1JuamZMdGIremF5ZzE3UExaNEUx?=
 =?utf-8?B?NTZoaXBlQU9lWHlVVmt4aVRkaE0yK2hnblNtYnBSWWIxUjRpS0F2bkVuZDc0?=
 =?utf-8?B?eFlVQ051QzY4OWYwZUlEZVlPcnhKNFJpdjY0VmJoaEFwa1NGZkR3UzJoN0lz?=
 =?utf-8?B?TjJKbU5WL0VFRzQrdWd1L1dOU2k5QVFhWXRqZ2gxNXFFTHF5UUt6THJSS3lY?=
 =?utf-8?B?THQ5M05xY3kwZ1ovWXgzYUV2NGt5NTNvSWdmRWJTNW9NSjgzUThHLzhTN0VG?=
 =?utf-8?B?R3dhSkkxZE53ZHY3TFcySUd5YnJHd3haSUtnQjhkV3UrL202ZVJjOEdaaVJr?=
 =?utf-8?B?YzhKZ09KMTh4TmJTbUdCQnVmY1ZJenRGdThFYisrZ1hYQng0bkpaOUUvbjFI?=
 =?utf-8?B?Vm5UOWxvT29sVlY5U3gyaGNSM200aG9Td3pGeUZZMHQvZzZjVG44MmozaTUz?=
 =?utf-8?B?LzJ0bDg1UGhIUGRMbkJMSFN2TmZienJCak1qTUd0REE4aVhtbTBYQm1tTitV?=
 =?utf-8?B?ZWhZSHJzWUQwSFMxZkdHUVJYMkdITXVrdmVNeDR5QWZZQlpkUlFGT3JqclVw?=
 =?utf-8?B?UXFPZ1ZpbG5IU1o3aGtMZ1NCbGVLMHIxdHRJV0F5RHdBUVZaZGhncyt3Sm9D?=
 =?utf-8?B?UWN5bUI2L2xLd1Myd0NFOXRhNmVzQThWcFhHclpRNnlnSDF4ZVQ3azFkclhT?=
 =?utf-8?B?ajFUcXh1ZzRtNkxTS0dhVDYvczFZQzJVbkMxSnlHd2ErTktKa2xGcG1RVEtU?=
 =?utf-8?B?QldMZ3NHejlkRHZFVVEyMUEwR2pBeXZKa1NGVGRSQitrcDVKbWpqbHBKem5v?=
 =?utf-8?B?M3Zqb3dhdXNCNzI3Q05VTEtxa1A0aEgxK2tMdktJelFJRDRjeGJhemcrMWQy?=
 =?utf-8?B?TmlhbDFpY0NYcHlHMDFFUFdya1g3dXBxUTNFcWgzTXd2bytycGx6VDFidExs?=
 =?utf-8?B?aDl5QnNCZDFZeUtZVjZLdzdHbXU1b0dFZHlIVW9maVNicnRnSmZwbGZOc2ND?=
 =?utf-8?B?RGMrMFhHdXJFeFhHN0ViT1lxbmRFcXZDVHM1STc0a0p3c0d5Vy9Bemd3N2Yx?=
 =?utf-8?B?VXF3dTlGdVJnd2tFVXVscEIrSFhyM0JPMTFRVzlxL3hjVVUwZi81ZHExUDB5?=
 =?utf-8?B?enF6MWpSYWpSVlp0SUY2cmt1cjJLWnRXYzROTFZkbERZZkRPeWtGQW9RQ24v?=
 =?utf-8?B?NnBTOUlNWEZzci8weFV3K25JNHc0SmhpblMwdU40NzF2VjlLTVFkckx1c0Iz?=
 =?utf-8?B?cFIyajBZZGpLRkFRYndOL1RnTVFCM0dLNTZYZ3hjaXMzalZlQjJubkZndlo1?=
 =?utf-8?B?MVI0bWYxekVVOXQ5NDlEQjNGL3lEQnhEUmxrN1JkYnNxSGNyYys2NHN1MXFF?=
 =?utf-8?B?a2dibm41MVFrbVdWWTNNZWZrRWo4UjYrRU8zbjFvZEwrdHhYd2Rta1F6RFlr?=
 =?utf-8?B?ZDJQUUY5RUxnZUZUNlBRZlFpT3JDOXpMOFp2YVZvNnRUUm43ZXJKcU1UUFpQ?=
 =?utf-8?B?N1RPKzhYQThpZ1c0a0hwYUlNUm9tbERUMjJBOWNrZWxLSG92ZmZWRCtFWE00?=
 =?utf-8?B?RjF3MEtqSzlxdXZDVWlyUDRTU2NKTG0wTTRBYXpZZXVSY1lKNWo1cWpRaDFW?=
 =?utf-8?B?b2NZNWdDVzZsM3BFbHB2T01JTUZYMEdaTkxsdVdCU2E0alJDenR6YisyWWxk?=
 =?utf-8?B?a0RWQXNJd2NEek4zYWsyaWZSclhpbzF1MVhHVEN5K3I4TGJqOUhRRzhnM1Rt?=
 =?utf-8?B?bXhNREhHTXhrbVVoM3pYRSt1dFFPVkdMNVR0ejJVc3hMNGZvK2RaM0dhbjJS?=
 =?utf-8?B?bzM3Ujg4MVJqY1RhczEzSEJOZnJUQ1BKZFEwcCtzQUEzWUZkWVlFV0pybk5V?=
 =?utf-8?B?T2p4VitjOHNLZXhKMmxXWGZQYUVkS0RKa0U3d2VtR3NQdnIwZjhNTHEvdTk2?=
 =?utf-8?B?Z3c9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d54f23f2-c756-4f2a-5b3b-08dab0007da7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 05:28:58.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U79/EARFcvNl6HBkO/OZN1YZZmCSfAWx5nt0+IUgtKCYZyGi0QFreSobpaHOma+19KsAYr1we2A0qXb19o9JNCA8dkV14ar3Np8EfYQRsQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8253
X-Proofpoint-ORIG-GUID: 28I0Cv4nB1-oq2kzLR5OQPZ0bx3wPloD
X-Proofpoint-GUID: 28I0Cv4nB1-oq2kzLR5OQPZ0bx3wPloD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_03,2022-10-17_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/10/22 11:11 am, Shivam Kumar wrote:
> 
> 
> On 15/09/22 3:40 pm, Shivam Kumar wrote:
>> Define variables to track and throttle memory dirtying for every vcpu.
>>
>> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>>                  while dirty logging is enabled.
>> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>>                  more, it needs to request more quota by exiting to
>>                  userspace.
>>
>> Implement the flow for throttling based on dirty quota.
>>
>> i) Increment dirty_count for the vcpu whenever it dirties a page.
>> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
>> count equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
>>   include/linux/kvm_host.h       | 20 ++++++++++++++++++-
>>   include/linux/kvm_types.h      |  1 +
>>   include/uapi/linux/kvm.h       | 12 ++++++++++++
>>   virt/kvm/kvm_main.c            | 26 ++++++++++++++++++++++---
>>   5 files changed, 90 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst 
>> b/Documentation/virt/kvm/api.rst
>> index abd7c32126ce..97030a6a35b4 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6614,6 +6614,26 @@ array field represents return values. The 
>> userspace should update the return
>>   values of SBI call before resuming the VCPU. For more details on 
>> RISC-V SBI
>>   spec refer, https://github.com/riscv/riscv-sbi-doc.
>> +::
>> +
>> +        /* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
>> +        struct {
>> +            __u64 count;
>> +            __u64 quota;
>> +        } dirty_quota_exit;
>> +
>> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that 
>> the VCPU has
>> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run 
>> structure
>> +makes the following information available to the userspace:
>> +    count: the current count of pages dirtied by the VCPU, can be
>> +    skewed based on the size of the pages accessed by each vCPU.
>> +    quota: the observed dirty quota just before the exit to userspace.
>> +
>> +The userspace can design a strategy to allocate the overall scope of 
>> dirtying
>> +for the VM among the vcpus. Based on the strategy and the current 
>> state of dirty
>> +quota throttling, the userspace can make a decision to either update 
>> (increase)
>> +the quota or to put the VCPU to sleep for some time.
>> +
>>   ::
>>       /* KVM_EXIT_NOTIFY */
>> @@ -6668,6 +6688,21 @@ values in kvm_run even if the corresponding bit 
>> in kvm_dirty_regs is not set.
>>   ::
>> +    /*
>> +     * Number of pages the vCPU is allowed to have dirtied over its 
>> entire
>> +     * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 
>> if the quota
>> +     * is reached/exceeded.
>> +     */
>> +    __u64 dirty_quota;
>> +
>> +Please note that enforcing the quota is best effort, as the guest may 
>> dirty
>> +multiple pages before KVM can recheck the quota.  However, unless KVM 
>> is using
>> +a hardware-based dirty ring buffer, e.g. Intel's Page Modification 
>> Logging,
>> +KVM will detect quota exhaustion within a handful of dirtied pages.  
>> If a
>> +hardware ring buffer is used, the overrun is bounded by the size of 
>> the buffer
>> +(512 entries for PML).
>> +
>> +::
>>     };
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index f4519d3689e1..9acb28635d94 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -151,12 +151,13 @@ static inline bool is_error_page(struct page *page)
>>   #define KVM_REQUEST_NO_ACTION      BIT(10)
>>   /*
>>    * Architecture-independent vcpu->requests bit members
>> - * Bits 4-7 are reserved for more arch-independent bits.
>> + * Bits 5-7 are reserved for more arch-independent bits.
>>    */
>>   #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | 
>> KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | 
>> KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_UNBLOCK           2
>>   #define KVM_REQ_UNHALT            3
>> +#define KVM_REQ_DIRTY_QUOTA_EXIT  4
>>   #define KVM_REQUEST_ARCH_BASE     8
>>   /*
>> @@ -380,6 +381,8 @@ struct kvm_vcpu {
>>        */
>>       struct kvm_memory_slot *last_used_slot;
>>       u64 last_used_slot_gen;
>> +
>> +    u64 dirty_quota;
>>   };
>>   /*
>> @@ -542,6 +545,21 @@ static inline int 
>> kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>       return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>>   }
>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm_run *run = vcpu->run;
>> +    u64 dirty_quota = READ_ONCE(run->dirty_quota);
>> +    u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>> +
>> +    if (!dirty_quota || (pages_dirtied < dirty_quota))
>> +        return 1;
>> +
>> +    run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +    run->dirty_quota_exit.count = pages_dirtied;
>> +    run->dirty_quota_exit.quota = dirty_quota;
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Some of the bitops functions do not support too long bitmaps.
>>    * This number must be determined not to exceed such limits.
>> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
>> index 3ca3db020e0e..263a588f3cd3 100644
>> --- a/include/linux/kvm_types.h
>> +++ b/include/linux/kvm_types.h
>> @@ -118,6 +118,7 @@ struct kvm_vcpu_stat_generic {
>>       u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>>       u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
>>       u64 blocking;
>> +    u64 pages_dirtied;
> I am reworking the QEMU patches and I am not sure how I can access the
> pages_dirtied info from the userspace side when the migration starts, i.e.
> without a dirty quota exit.
> 
> I need this info to initialise the dirty quota. This is what I am looking
> to do on the userspace side at the start of dirty quota migration:
>      dirty_quota = pages_dirtied + some initial quota
> 
> Hoping if you could help, Sean. Thanks in advance.
I think I can set dirty_quota initially to 1 and let the vpcu exit with 
exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED. Then, I can set the quota.
