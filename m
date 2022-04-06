Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1990D4F637A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbiDFPgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiDFPgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:36:10 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FED2E33BE
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 05:50:11 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23650QgL029532;
        Wed, 6 Apr 2022 05:44:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=3OsJK39ihFX4ygJhAsCw2e+Ac5sK21e1IfR403brjqQ=;
 b=y15qZBY6xJIwJL1Zmpr0yTtHBwQ47tflOatRlZt/fqWeqy7Pl8cmJTFZwJQCzCRpnUkr
 J6jkDA+AV0SUrbXBziRntCvwm5dA2YglHuZ55oeW+h4c0PfA47/cahxsr3DWb1Q7bjRT
 R0mRskTvDyhxMYapL1DaJrEcABn4CgWeZHhLp7JC/cNDwKAafV6C9pU4wpZcFGds/7d+
 OOvPr6IaNFaa/8IblGCs/I83ikujWPb5u8F74FqtyOQ6dypVVp1MGvm7bvPoEebxAWOa
 4RvrrWN7pc6niKU2akRxV7fzok9MzF47zXLTbrfYysrhL9fPUFOh69GIJTYFhjiaDQrP 3A== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3f6ntn0cfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 05:44:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igkSajs6p6k+0ylXuKYxBFILGL5i3GvBHgkgoJfXf+Xvs5/Xvacy89p3LIz//V2XHHfUfWm5Bf+xu9HuTiBkHghA3ueRzUMGqgo/SbGMc2YXb/FyZkv1Tuymq3Jx9E3VMCH2B9bBj9bJc89a4CDCxVhg4iCtcFVCN3xMZF/UdmAsfrFnVQRThqOP0U0iJIaYTMoynxdbWMGK5uxoyZxFaHceqdG5Xcxt9cWuiAUj3a23ioXZ/MGPzWxBbrIaeQHB9XQWxf5bzn7CE3vSTARsKRHaM6brPO8mTSOdjkth75/8Otkkzc7ZggbURyfsiRt5mqEGgxWF33I/TCS6Bhybcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3OsJK39ihFX4ygJhAsCw2e+Ac5sK21e1IfR403brjqQ=;
 b=TXi1EDt4ekZRrAtjNEK2p9AWzIXr3JHTzxXH7Dj8W8wb5Z7wtcKroHzakwY+ytv9yCzMN+u7Vt+mnPMMVz7Mg7eqzEy3xXf5VjKOEJkYPICXzMFPi2Cpbb3QKzMLO2O1BJMJAVODtGsuWFX5z7StZ37b2FeZZkss5qiBe9SXE8J8jRQkBe7Av6lZX7LcayJF0sE2NNH2BERjjhsRSjC6PRIdeovF1YfmhpjdbB/vpA49TOySBhdJJqGzzMG11keFl2gwdr1U1NJoH9bhjt6xhcY4k2RadzJ7YK7LflDzkyzTK4VdsnvBb3akdJZcoyH7oL68ST+YjtvUbbCJnMSsog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO6PR02MB7507.namprd02.prod.outlook.com (2603:10b6:303:a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 12:44:41 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 12:44:41 +0000
Message-ID: <86dd90e1-ca9f-c24c-96cc-d51c8a6e5e09@nutanix.com>
Date:   Wed, 6 Apr 2022 18:14:29 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
 <YkT4bvK+tbsVDAvt@google.com>
 <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
 <YkXHtc2MiwUxpMFU@google.com> <YkcC5cDUo7cQQyBf@google.com>
 <92755bf0-0bb6-2a9f-3b92-3b380463759b@nutanix.com>
In-Reply-To: <92755bf0-0bb6-2a9f-3b92-3b380463759b@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0102.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1c7b540-6030-49d8-7dab-08da17cb37ce
X-MS-TrafficTypeDiagnostic: CO6PR02MB7507:EE_
X-Microsoft-Antispam-PRVS: <CO6PR02MB750762F96F4A2C04B50BEA81B3E79@CO6PR02MB7507.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cB6/peY26rn901o4gU2IXcQSv20jyY8Izdll3E4zDk9XswMIku3AZf5AvbWm8CxoBS3fF3tR1obYhRjqEUqCG1wrtB172p5gbHoyRsV05ZH+AyDazN6ZQzgVdL6m8SYIHUgJfluNKRv7H2TYkfWKAYKX30eXLkUO8RYANhZdApq5hYuYgB7pmzByuipCV9Qg4eUqXWTXISlqhZbbQgM41DvUm/JZhR5xsP1KfFDTRugw8AHwGEvjggZUHa0TUV0R7RMGbnHsW3g6D0Vaon1TJ9G+R7ctxCGPzB+nn5xVBmtwtdPRN6gO6cU+gVy02IDWmfYVpZu2E/g4j8WRR5wiUyHxC3TKm7R0spiltnysFFQhOS4+H9+k9ztkk8XCIoJtyyeVUWr/EOYmVKBpJXJ/c4UUwD1sGtv0zyTabVDboyYSBS9pqzcL0s5kxPjnIb2fJ0wNrnkeC2wfzIEkFd4QACbb4iZSgl86seDKmrGbKSkT7COXFhIOXLT4wWw+JqyW3MPLFrXHNTHXQVtkQJcdAN/xKtB0swGu5f1vtSEGDnJ9+aZaWVfkvqcN5HZuy/Gaa7TxwPzIBUSbX2DSLWgHW1QWmxaPCi4nwYv3KKvkSknH6wmFDGrGnDJOhl0SDBWxHxLKNBbC77IGb5Uoo6bpK9+7YEyuWBIoAG8R1kiRRP5go/A0NSCctezl/CBcfLtSGnOxIcmFFC+aWJME0hmjNzwfuZH/nx1YaPGn/TycbN9CeEprDlX+uCRVOPcb8aXzEyw1W18tNCCt93xw3t1iIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(186003)(53546011)(6512007)(6666004)(6506007)(26005)(2616005)(107886003)(83380400001)(2906002)(5660300002)(8936002)(4744005)(6916009)(54906003)(316002)(6486002)(8676002)(66946007)(4326008)(66556008)(66476007)(86362001)(36756003)(31696002)(31686004)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWlHTXBrMDFIWjEranFIZ0t2b254SXgvb1hkc2d1eFBpV2NmWnl3RDVCVTFN?=
 =?utf-8?B?dnRBWDFFTlQ3clczNkVqcEFBTjJjcjZoQ1k3MnRHRjBmM0ZqQ1h4YVdmWWRD?=
 =?utf-8?B?NUhCREpGRUVlY2Rob28rWDBMUU5JQktVOTByOGc3ajJkVVgxNlplWEd6VFlP?=
 =?utf-8?B?ZE1zeTRlcEZ4T2NxUDVZMkhyUHJCUWdkNzMzdkVoMnBDYjIyYUN0TTlwVlE1?=
 =?utf-8?B?WWZ1SWZvS0t4dFA3OVF6WVA4bnZsdnlSNExadW4vZ0lNN1VFS2FVTldzZExY?=
 =?utf-8?B?TUFvd1g4VkIwVWhSd1AxZmM1WkxKT1FuSTNsb0Fpdy94WkhqZXpQUml6MDFy?=
 =?utf-8?B?ZWNGL1RQZEdQNkFiWHBWVWFRcnZ0QzZuV3dQMWZVQkl6ZTBoMHB2TGlLeXUr?=
 =?utf-8?B?aVdYeEpyN1JrMHcyaTQ3WUExaEtTM0s3N1Mwb0RwTUpmUGlNYXdJNmdqQ1Nz?=
 =?utf-8?B?S3dhU095TU53OUIvcGVQeExoR2tZNi9DdGg5V0RpNW1tdGtzdzlKWkhPZmFR?=
 =?utf-8?B?SzN3TnVZaml4NVljc3ZPeEk4Q05hR0ZjcUlUakRRZ2FpN0hGUlFwSWtTYmNp?=
 =?utf-8?B?anM0MyttamhEOWp1bGtQOHhpcUR1RHA0WWJMNmVDbkdSVWEySTJwN3F2VEkw?=
 =?utf-8?B?emtwUllYS204TjNBcC9qTTFnM3V6K1Q0Mk5UQ3RVNExmM2liWHNvT3NvVjdM?=
 =?utf-8?B?bGVabUtqOGM5WHBFNmhEWEJtWVc5bW8reks4N0ppd0ZrMDF5dE9vTXc0TVZw?=
 =?utf-8?B?MzI5bGF4a09tY1Y0bFFobXdoclJRcElRWE50S2JENTJYWGVGRTNGKzAzNXFJ?=
 =?utf-8?B?L0NRYkJYRlpvUVkrVHd2KzFiYVVNT1ZjWnIwb1FnVDNwZjNXaklnbk1hc2JD?=
 =?utf-8?B?T0xFMXRsUExNMnlqUlIvMjJ6V1h3ZHU2ckxlMmVUMlMrQjVZaFlwOUZRQXFv?=
 =?utf-8?B?WTFhZDkvRlRBemYzVURtM0dVNlRoZ0J1dG51Q0VFbUJnUkNFQklJeWF1L2l3?=
 =?utf-8?B?Z3o4VWk0ZEUyWithREFHMjdiQVdZUEM4VmtrZnBFVU93RUUwZzQzbHpSTVFD?=
 =?utf-8?B?SnZxSlM0eWcyQlhsTkZJWi91dWplNGJaSGIzUyt0c2JiZnhNSUxBa2ZTREEv?=
 =?utf-8?B?bm43RzBCY1I0WGJ4SHdsZDhRRGVUVjJyQ2VHN2h1UWZPd1YzZVpqUGxNU0xH?=
 =?utf-8?B?djZsYVg0UkM1MFg4anRlbU53MFYybk5wMFV6UDJRMVBHbHJtS25JalZLV016?=
 =?utf-8?B?azlKWEdXdEljSExvcENVMzNjTWg5TWFNNHl0eDFGWFN4U3B3UDNYelcyMUdQ?=
 =?utf-8?B?SGczUkpzN1RtTDJGS0pMQVEyaHEybE84T0F6YWZXVkFUZ3lDa2tGSGxJZVlT?=
 =?utf-8?B?eWxUb3BVT3B5NFA5MUc3Zm5iM2dUSjFweS9nNnpVc2JaSGRQaGE2d2Y3bGpH?=
 =?utf-8?B?VFdLU0V3K01rUDI3dXRDai9LSkJoOGRaMzZSZURiaFp5R09haXB6ZG5nZFRC?=
 =?utf-8?B?MlNDbW1CL2FVdHlVNzl0MFlHLzNtREt4ZkFsR09QMGVWZDdyWTJRU3BHOU1R?=
 =?utf-8?B?V3FqeWpmcHRMNmFYdTBseURabTg2QisvMGJ4Zlc3QWFic2laNEgwQW9pNzhU?=
 =?utf-8?B?a3A0dEZxTUIzREU2V3grMVpMazVUMHpVYnpINFdPV3lHYmtXeG5UaXVGVG11?=
 =?utf-8?B?dHRSY0ttTWZTN2dZVEV3bGJQSElqWXhSSnJaditaK1RrblJaYnorZ3FaS3hD?=
 =?utf-8?B?SVRDNlUzRUM5NHB1cnE1SWw5c0xKZUpnUDFhT3FHcklSUERHbEh0anl5T3VD?=
 =?utf-8?B?ZmtrZDNNOEpKYXdIK0hpV1BueCtaRW1HdXJWRkRyL216djhhZzhGQmlTNDJB?=
 =?utf-8?B?bWJMTVUvRkpZZWlwd1pla2xFdDgzVy9CbkxTQ0FZMm1pTm01SWtqMWNnOEll?=
 =?utf-8?B?Zit5UzR5eWtqODgxYXJ1aXFScWJCWjNpbllYc0NyWTdKNm5xZnZtUHh4Wmxz?=
 =?utf-8?B?S1VpekNEdTdydW1HUE5teXNVZmJHb2VuWU93T0hPTmIvN2hWK1o2UWhVeHNR?=
 =?utf-8?B?RG94L0xkUE9GcGtqSjdFM0MyMWxzMWwzMjJzKzVBV1JyMXpkb3lpSVBsNXNC?=
 =?utf-8?B?OEVodFk0d3M0Qjd2dG9HSlR0b2VKNDk3dkNsbFdsQ0k3T1FkbFVlQS9keVli?=
 =?utf-8?B?Zk9Uek9rTk5laTg3aUt1SXgwajlIdXlhVy9LV1N6V09reGdqTU5icG1JSDEv?=
 =?utf-8?B?ZTNyeWJQZlBEUml2amJoQVZ3SkNZbmhCZXdhbVJPSGR2NFl3anJpYkhuT0Iz?=
 =?utf-8?B?UTZ2NkFxVHhnbXU2M0hLM1VXMUpMc2JTa2JMZUVVSWNjend0dkUwd1hFTFIy?=
 =?utf-8?Q?hxjCFNMy5RfgGzCg=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c7b540-6030-49d8-7dab-08da17cb37ce
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:44:40.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSB81cw3YEodPyVwXkPZGI/kpmogplsfc1Hs6EpQDuncIoiC99XkZPphYOjrLwFrx5CgwFRB0hEvROWe0r4MRjwj//qkcaiRgLfejYO0qeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7507
X-Proofpoint-ORIG-GUID: qlaRHO891p0QusGcmusmicuw0d6XaDWM
X-Proofpoint-GUID: qlaRHO891p0QusGcmusmicuw0d6XaDWM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_04,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 06/04/22 6:09 pm, Shivam Kumar wrote:
>
> On 01/04/22 7:19 pm, Sean Christopherson wrote:
>> On Thu, Mar 31, 2022, Sean Christopherson wrote:
>>> Oof, loking at sync_page(), that's a bug in patch 1.  make_spte() 
>>> guards the call
>>>                  WARN_ON(level > PG_LEVEL_4K);
>>> skewed based on the size of the pages accessed by each vCPU. I still 
>>> think having
>>> the stat always count will be useful though.
> I thought it was obvious :)
Hi Sean, I'm grateful for your feedback. I wish you could post some 
feedback on the selftests too (third patch in this patchset).
