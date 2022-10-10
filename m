Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5F15F97E9
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 07:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiJJFl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 01:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiJJFlg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 01:41:36 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9B221820
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 22:41:28 -0700 (PDT)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29A32VSb004643;
        Sun, 9 Oct 2022 22:41:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=5uitn+KUw71q4DvYreiFKm4kuYiTf2lCnAsYjG43i1E=;
 b=nFLI9fUTB1KBD5BJUkUEfgv9l5mmskR/NK2pzmtu6ARyaSDEwye1hqmejTUFlhq1sBBX
 /mB1s6+mxZyqMlr4GVdGvJDy1iYqlnUlnhf4HcvflEnah4Y/yD2QUHU70/e/eny9tEii
 yt2dOJI/Hhdj5QB9DM1zV1fMRUr4r3pwBX1ipFl1M8sck+TWG5EXmxSSIoPbHRS2Hs5w
 dPlpOZJ4l1AyaP6+4F4ac24Zspw5qWnedwBxDB/sSETsOMIc9lSegR5KQSJebvOQIqjJ
 0UG6K+yLe0jRnpmH+WxIOEVjT8zMIEpfYtvbJPZ7k5+w1XyxX3lmbm7MyN1xhG61TiTP Yg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3k3546u995-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 22:41:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFWkzxaLHVYJ4Ul3MW7G2a6W1k4fumNhMPFJFPCbLnkZMFACFhVgajt/eUmqKKiLukPvucyEBLiZCJRkkchAt97vpjMrKgreTUfzT1/vN9ceMWb/zX42+xe5OAvVc8CmIVnn/YGL8BTCeMHYFVIdGRCNc2jpPQVg3x8SpaWYNGz2ekDqqiZHf11/Vy211/xoEVif0+y+Xs7ihzUjwEIdIr6n7sW+Ywe/lwaqqFaJmqRZE/EbWKY9gXw5KVjVw1TBrazWzOa6xxqU+BdiWDn4bsDXAoOLIn1nnlUxHzzLcsYWfrPgoZu9nipfuVnAfdZMw0KS17jI5nMIWVCxsnxmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uitn+KUw71q4DvYreiFKm4kuYiTf2lCnAsYjG43i1E=;
 b=BtO2yZXEnSPlWtv+bbu8BYCrpciwR2cEnkm/w54B5xWwhiMwxrtFrbw5cXpoc9BJuTp3Gd2/OBW1+qqvd8pgKIwr2nPCTTL4hpBE8UXJF8uUifW7EsOZ9bWtvV3zPo3OklzZC9l02chsfF32JIQN/dsKpuQxP4ciBlUj84aqVBwnFDMZ+niNKjBLZvlVkhKKY+5Cj0qFYCw0vRwZbln1JVM9ZQNt2WDYjBQW2kSCKj/DFxr7+q38Qxo+RV+nwD75EXoLnhlEUDnrIey4nEvX/jZ8uWaof5g18IEA1kdvKaB3hqBf4F1KIaF0WVY+VINNNeGqSMYSz2mKPhdrVEX4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH0PR02MB7916.namprd02.prod.outlook.com (2603:10b6:610:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Mon, 10 Oct
 2022 05:41:14 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 05:41:14 +0000
Message-ID: <21fce8d9-489f-0d7e-b1a6-5598f92453fe@nutanix.com>
Date:   Mon, 10 Oct 2022 11:11:03 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20220915101049.187325-2-shivam.kumar1@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::12) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH0PR02MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d35ef6-88f1-4696-300b-08daaa820b50
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yx4EXQhbeU+Jv7ltlQSNksWfdWmUMQM8kH8/yLH5TO6Jy9fXOGdHIrqFvGG6X6bRaCuFfK2Hq/b4R7eJCMlHEcbm4Q2gArRfv/W15e5A2G1huI+Yb+hD+AbI1gXS6MgQjvoKwVRiCe1k+0beJGdtaDlVZXzaU9+yn7Vpaja0yekUlhQ673GyG6g9qMBJM5DGKpwaHsCS5wkP5LbGxGGGtpiWwETOt/+KaV8Vspnz+RJCAdRgAFlIQPy8zHSmy/3kE+FPFExjQY7keKSbQW7uMdi6I/EaC4SQ2QzjeyvWlsCFBP9rH7EhUdfKf9n7xpoOZiaQZg4jEi5kfsJUfXbicckCKp8GSb/TGIswIEBscmC9yoo1TqHYCm+7EGYuFNm29TGuy48JtQCDIBhOpOKoaHJ1WEPPq9VJ8JlE5zTU3RhuYE/MsYwExB9Je1snLmx0e3spOzWt8s9zzQ+2JjE9GPLAuOcE8QTt2gZuzbt2g2K3VzYG1ztXZGsJHYjUlNV58B87GyJE2AYiqYmPyW0fF+7EQIFLeDQY6Lc/iiYALQM6AHP4jL4BindjXlQzNpMUqtwUiVHt+Jt26zvnfNHuUXJ322ZBM4+AnhlZmkEmy2Du2E8TDmAf3TlvPNDTDiV7IaSvg6SeHKm4cnWviT9F+JBRKuZVBIKI2297AgQyLHI7bYaHP63tRQd6/TDVDgArWeme8SgCmu0fhcv2gqfc55p++NqKCwYcitWAzD9U7TVUYjz95yWiEdgau13khojCBXvg1MkGB+Ph7RHjzKiQYSpAIokIYyxf++bRs9tmRrzxOCX+dKPL5sODdas4kUcHH7GSzyE1QktE1/ug2wt1ESo3M01WGLOOEBVSIUD6jKI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199015)(316002)(2906002)(31686004)(83380400001)(15650500001)(4326008)(86362001)(66476007)(53546011)(66556008)(66946007)(5660300002)(6506007)(107886003)(41300700001)(36756003)(8936002)(6666004)(38100700002)(31696002)(8676002)(186003)(26005)(54906003)(2616005)(6512007)(966005)(478600001)(6486002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkNGbkVIemxVOTZjMnNrakhNSll0VzFGZ09idnFpQkpmWG1jVUpESThUZ2l5?=
 =?utf-8?B?d0h3bHZiRFc1UURCR0pXVjBnZ2NPd1B1MWoweDFySHNUVmt2NU5waHFBaGtP?=
 =?utf-8?B?VnNyTFNrekt2eVAySzIyeERET3pMZUZYUnFGRE9zbmNjVzM0UW5IVDk5djhk?=
 =?utf-8?B?QnpJcXdNeXpLOTM0MGZtemk4SkFDV0NOOVhyWERINHZscGtUR2R4YVN6Qzhr?=
 =?utf-8?B?eGFveHh2MjFsNFJsMUYwdDFIZy9uaCtpRzh4RzFZWXhoTWk5MDg3ODYvdTJ0?=
 =?utf-8?B?WWgyUC9kdHNNSHVtMkxQY2RaaDZIS3E3UVRLVC9vWWgvK2VLYlFNR2J6a1Bs?=
 =?utf-8?B?a2t0a1NZeHUyb1k2YWNsZlMxaWlrd1g4RTI0Sldqb0tHQk5FNTcrTTBOQkVu?=
 =?utf-8?B?V0V1WDg1QmR5Nm9iWTJJL3hmN05DMHF1cUEwaTI0aUFYUjN2WlhKdExNR1h4?=
 =?utf-8?B?cVcvNTVnTGJkWmxmQTlKNzFMRlpUTWZtVGRpQWdyb05VMlJjNjRHaUZFckxk?=
 =?utf-8?B?NnA3bWRvTjY5YnhsWkRiNjE1V0R3Q0RQR0o1bDlUaGJMM0EreCtNalJuN1JJ?=
 =?utf-8?B?REVuUXlDbmwvWTdXM29ucFFTNUtRNWhYNEhjS3l0SDBXd3g1MFRuZGV2amty?=
 =?utf-8?B?NzFNOHplRmNidWlYbEhXd29acFBvenZLUTJWVWtXZEhhajFXbDkzTVdQVjVI?=
 =?utf-8?B?ajJaNTExNDlsUCt2bG1mU1RQNHJXYWY1MmkwajQ3KzViT3dxeG1tYkdva0lF?=
 =?utf-8?B?K2VMZDVGM3hCVU9RUHFlUXY1bjFXcU1uUDl2L0wwaHpFV0Y3Slp0aGQwNDNo?=
 =?utf-8?B?dzZTWnFDTmVwQUVPOWNLTldtNlFmRWMzaWNFcG81TW1rbFFDSFJVdi9TUkJs?=
 =?utf-8?B?eG5lYkUwZ0JpS3F4c1pVQU9oQnpWUGFtUEhUeWk0bmI3Uzl4a080bmZvazll?=
 =?utf-8?B?ZDh1UU8xdDUzWUFQVTEwVWZ4Y1p6Vkd3WmhMNzVDODQ0eVhzN2RlcjJrTmZh?=
 =?utf-8?B?UVYzOUhmQytGcGJSSkdld002ajRBbFo2a1lQSDkvcHhWbzkzOGRYWFphdFZw?=
 =?utf-8?B?MDJtRHF1Y2Y1Z1NTTUdmdU5Qb2RpV3JRZHZFSURhY01mczRpbXErTVVVZ2FF?=
 =?utf-8?B?WDIxSFR0YzUrbzB4V29Ma0RHVTF1cm1ndzV1enNBSjB1UmJ4ZUJ1c1QzM28w?=
 =?utf-8?B?ZTIzWWlWelFvZElCY2tCV2dsdVladWJsVlB3S0dHMmhkT1pNQWVqcm1Wa1Ri?=
 =?utf-8?B?YUpmUzV2bkRtMUVFTjRSMWl1T0w4Y3hjb3JBMVphK3VNTUtmcDh6UzVOUnht?=
 =?utf-8?B?ay85WTZNbHN1YUFGNFo4bUFyejhSdTA3M1dQVnhPZXFXcHd3Z05ncFJUQmpG?=
 =?utf-8?B?UWtsNlJwM3dBTXh3eHcrYmIwNTArejRpbnJtWHNNWDhqbDVHM0NwaDZIaEZs?=
 =?utf-8?B?TXFJYnFJV3FiazBFaVBqb3NsU2lBTHNSTFBzU0R5QXUrWTUzeExFQTV4d3Y3?=
 =?utf-8?B?aFdjUWVTWU5iSHdrVGMxVE9hZHpmSFBqU3puUVhuTlBucjNabC80YzByREJP?=
 =?utf-8?B?bkNVcGZtS28yMGxhSWVLd24zSnNSSnNBYTdvMEQ3VkZwNTh4d01xOFJMK2Vi?=
 =?utf-8?B?b29lUzdtSTZKL1pLdzZuZzhXYTV3clZRQlpvSlRIUzZsOFlCVysxeFA2bVpk?=
 =?utf-8?B?N3JPQU5WakQrVW84RlJVand1QXNrNmFoY0k3Q3lKU2RscmsxWnZOaGFULzVv?=
 =?utf-8?B?WUdUMFZnRzgwbEgxTk8zZlhkS2p6b1NIVEZyVGFNM1F6T3I0aVdPa3J4ZEw5?=
 =?utf-8?B?b0Z3dUpmbUl0dEZNVXZsZUtTclNvS1d6dDZmQ01UL0R5ZjZnMHJWVEdCT28v?=
 =?utf-8?B?K1dmaUh3dTVnWVU1MmNiTlErc3JyVGdrM1pQZlc3b3ZNbHBZZUNrcVVwTjlo?=
 =?utf-8?B?MllVSXNqLzVRQ1l3NWxLczNUaEZRM28wKzJxcnBYT3RiQXk0TXVocHdQb3Ay?=
 =?utf-8?B?QzZrcjNqeCszaEloR2orSk1TZGJhUy9VVGN6ZVFWR0M4dElnY1ZJUnRvWjNN?=
 =?utf-8?B?dm5qdjYxdW85UHVTeG5LN3FCWUZydGNGVXZ3dVRJWXE1U3dlbDIrQTY5MVRl?=
 =?utf-8?B?TU82QVdWenc5UTNUSWZqYzcxeWgwYWc3OWJ5SmxxS2tFNkQ1VHpVSzdDaThS?=
 =?utf-8?B?Ymc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d35ef6-88f1-4696-300b-08daaa820b50
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 05:41:14.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s36+hCdq8//emaWmRVdxiQ3VIleLyPS3WxiXnJeeivbNdn3l4foXU2IDU/TtpG+yPFg2sibdlyfQID4UFizYv4t4LDOzqXJeehSuvKBEOeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7916
X-Proofpoint-ORIG-GUID: 9MlR3eVZ_pYt0hbzSy_quK6AfTuDA0iV
X-Proofpoint-GUID: 9MlR3eVZ_pYt0hbzSy_quK6AfTuDA0iV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/09/22 3:40 pm, Shivam Kumar wrote:
> Define variables to track and throttle memory dirtying for every vcpu.
> 
> dirty_count:    Number of pages the vcpu has dirtied since its creation,
>                  while dirty logging is enabled.
> dirty_quota:    Number of pages the vcpu is allowed to dirty. To dirty
>                  more, it needs to request more quota by exiting to
>                  userspace.
> 
> Implement the flow for throttling based on dirty quota.
> 
> i) Increment dirty_count for the vcpu whenever it dirties a page.
> ii) Exit to userspace whenever the dirty quota is exhausted (i.e. dirty
> count equals/exceeds dirty quota) to request more dirty quota.
> 
> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
> ---
>   Documentation/virt/kvm/api.rst | 35 ++++++++++++++++++++++++++++++++++
>   include/linux/kvm_host.h       | 20 ++++++++++++++++++-
>   include/linux/kvm_types.h      |  1 +
>   include/uapi/linux/kvm.h       | 12 ++++++++++++
>   virt/kvm/kvm_main.c            | 26 ++++++++++++++++++++++---
>   5 files changed, 90 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd7c32126ce..97030a6a35b4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6614,6 +6614,26 @@ array field represents return values. The userspace should update the return
>   values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>   spec refer, https://github.com/riscv/riscv-sbi-doc.
>   
> +::
> +
> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
> +		struct {
> +			__u64 count;
> +			__u64 quota;
> +		} dirty_quota_exit;
> +
> +If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
> +exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
> +makes the following information available to the userspace:
> +    count: the current count of pages dirtied by the VCPU, can be
> +    skewed based on the size of the pages accessed by each vCPU.
> +    quota: the observed dirty quota just before the exit to userspace.
> +
> +The userspace can design a strategy to allocate the overall scope of dirtying
> +for the VM among the vcpus. Based on the strategy and the current state of dirty
> +quota throttling, the userspace can make a decision to either update (increase)
> +the quota or to put the VCPU to sleep for some time.
> +
>   ::
>   
>       /* KVM_EXIT_NOTIFY */
> @@ -6668,6 +6688,21 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>   
>   ::
>   
> +	/*
> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
> +	 * is reached/exceeded.
> +	 */
> +	__u64 dirty_quota;
> +
> +Please note that enforcing the quota is best effort, as the guest may dirty
> +multiple pages before KVM can recheck the quota.  However, unless KVM is using
> +a hardware-based dirty ring buffer, e.g. Intel's Page Modification Logging,
> +KVM will detect quota exhaustion within a handful of dirtied pages.  If a
> +hardware ring buffer is used, the overrun is bounded by the size of the buffer
> +(512 entries for PML).
> +
> +::
>     };
>   
>   
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f4519d3689e1..9acb28635d94 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -151,12 +151,13 @@ static inline bool is_error_page(struct page *page)
>   #define KVM_REQUEST_NO_ACTION      BIT(10)
>   /*
>    * Architecture-independent vcpu->requests bit members
> - * Bits 4-7 are reserved for more arch-independent bits.
> + * Bits 5-7 are reserved for more arch-independent bits.
>    */
>   #define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_UNBLOCK           2
>   #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_DIRTY_QUOTA_EXIT  4
>   #define KVM_REQUEST_ARCH_BASE     8
>   
>   /*
> @@ -380,6 +381,8 @@ struct kvm_vcpu {
>   	 */
>   	struct kvm_memory_slot *last_used_slot;
>   	u64 last_used_slot_gen;
> +
> +	u64 dirty_quota;
>   };
>   
>   /*
> @@ -542,6 +545,21 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>   	return cmpxchg(&vcpu->mode, IN_GUEST_MODE, EXITING_GUEST_MODE);
>   }
>   
> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->run;
> +	u64 dirty_quota = READ_ONCE(run->dirty_quota);
> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> +
> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> +		return 1;
> +
> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> +	run->dirty_quota_exit.count = pages_dirtied;
> +	run->dirty_quota_exit.quota = dirty_quota;
> +	return 0;
> +}
> +
>   /*
>    * Some of the bitops functions do not support too long bitmaps.
>    * This number must be determined not to exceed such limits.
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 3ca3db020e0e..263a588f3cd3 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -118,6 +118,7 @@ struct kvm_vcpu_stat_generic {
>   	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>   	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
>   	u64 blocking;
> +	u64 pages_dirtied;
I am reworking the QEMU patches and I am not sure how I can access the
pages_dirtied info from the userspace side when the migration starts, i.e.
without a dirty quota exit.

I need this info to initialise the dirty quota. This is what I am looking
to do on the userspace side at the start of dirty quota migration:
	dirty_quota = pages_dirtied + some initial quota

Hoping if you could help, Sean. Thanks in advance.
>   #define KVM_STATS_NAME_SIZE	48
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eed0315a77a6..4c4a65b0f0a5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -272,6 +272,7 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_RISCV_SBI        35
>   #define KVM_EXIT_RISCV_CSR        36
>   #define KVM_EXIT_NOTIFY           37
> +#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -510,6 +511,11 @@ struct kvm_run {
>   #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
>   			__u32 flags;
>   		} notify;
> +		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
> +		struct {
> +			__u64 count;
> +			__u64 quota;
> +		} dirty_quota_exit;
>   		/* Fix the size of the union. */
>   		char padding[256];
>   	};
> @@ -531,6 +537,12 @@ struct kvm_run {
>   		struct kvm_sync_regs regs;
>   		char padding[SYNC_REGS_SIZE_BYTES];
>   	} s;
> +	/*
> +	 * Number of pages the vCPU is allowed to have dirtied over its entire
> +	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the
> +	 * quota is reached/exceeded.
> +	 */
> +	__u64 dirty_quota;
>   };
>   
>   /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 584a5bab3af3..f315af50037d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3298,18 +3298,36 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>   }
>   EXPORT_SYMBOL_GPL(kvm_clear_guest);
>   
> +static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
> +{
> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> +
> +	if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
> +		return;
> +
> +	/*
> +	 * Snapshot the quota to report it to userspace.  The dirty count will be
> +	 * captured when the request is processed.
> +	 */
> +	vcpu->dirty_quota = dirty_quota;
> +	kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
> +}
> +
>   void mark_page_dirty_in_slot(struct kvm *kvm,
>   			     const struct kvm_memory_slot *memslot,
>   		 	     gfn_t gfn)
>   {
>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>   
> -#ifdef CONFIG_HAVE_KVM_DIRTY_RING
>   	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>   		return;
> -#endif
>   
> -	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
> +	if (!memslot)
> +		return;
> +
> +	WARN_ON_ONCE(!vcpu->stat.generic.pages_dirtied++);
> +
> +	if (kvm_slot_dirty_track_enabled(memslot)) {
>   		unsigned long rel_gfn = gfn - memslot->base_gfn;
>   		u32 slot = (memslot->as_id << 16) | memslot->id;
>   
> @@ -3318,6 +3336,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>   					    slot, rel_gfn);
>   		else
>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +
> +		kvm_vcpu_is_dirty_quota_exhausted(vcpu);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
