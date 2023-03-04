Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260D96AA909
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 10:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjCDJ7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 04:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCDJ7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 04:59:05 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF67C66C
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 01:59:03 -0800 (PST)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3247iZVg001278;
        Sat, 4 Mar 2023 01:58:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=nl5Q5J9XQNnrpOb6Fb1SOvZwqoN+QArOqVtiQiu53Iw=;
 b=oeXlwlvPPRYMxA3jthC/yutTDTl7FtNtJhPT7o+vmhhb9pBle4J1hPTgFDncSMJINU3D
 y1WGm+nDzALt9b71sC7gCQ2Y5gY3wi1pZB9GmeotKNobk2ABIqDf8TUFm7b5LOa03/R/
 N1j6JVnE3lEiSXb162IqYXAjCkQ98uGxQ/Bch3AGrH8LaAkVe6PCoWEvK7y1VSYKJtrK
 S08WvY79HqRDFyEH45SeZMix1aYenCE3RSPljK111WwVcM0l/5RR28qhw5SWLv16xQKv
 lghPmDixhvlRRbuEHXOjdeSQZWjh7dUXkbJ97mK0Wc+L3KbFKDZKJ0T6moq2kdXIQ1iP Qg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyjr6e3fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Mar 2023 01:58:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEN6tklUoxtBb4wFL/9lu+38BQA33Q053U+QtlsU2XNHHJaJ12QUQRdBqgleS5AxtPVGPeshrqqloR0qZGw4PWUKLc+sBC34SyQHm83Qr59izKuXGa+I6CqkdK0TUna7VrIsOD7Sljo3IuW9C2exCpXw5/v+slJ2+mHEpJMBHT8tuBVU19HfBJpj6T/IJ4WK8WT3s8GEsK7U4TYOrxzlvve90KVy2+V9pxfdzcKcKKj7riXHRS3iANh6rnwBHmjI1qYw9Tw5KEs7C7GxocLcHFzKTPC6i41R1bq2MHLaHv3jQ+/e0uce9tdH/6ieVXtpUs6PqTCagggpZVi3Tmx6HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nl5Q5J9XQNnrpOb6Fb1SOvZwqoN+QArOqVtiQiu53Iw=;
 b=bExhnrcvVbfyNQxF1NjljK2WSmdrxiB9MIQs0ifTBcg82PdxuDOc1N8KVQwUVRkre2tgO5X5HWuWqJl/O3yO7mVZJmXQKr2PY8G9kmbA/XPJGMz4PGKZ91JLM4LpfGkkpn1F14riaxwqsW7J1/Udik8k3CCRMGobgmZqMXNerIR/cJSunA3Uk/xArFcPhpTPYNAouaJIGyljBN4xbRHee87b4HkG9bTTlU5a+EBKFH7LujI5qhZOpuBSf6LmYDZGG9zHs81+UwQ01mb/yRWE8AtdcKGaoic72vX0fm3BAxEPZwCteuVB+P1QEItu5eRQXtyK+ls/0SeOadbADUkGUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nl5Q5J9XQNnrpOb6Fb1SOvZwqoN+QArOqVtiQiu53Iw=;
 b=rT9YkHlF66AhCDvLKjo+cHCbSsF9vzm5Od6oEXd/pJT4dRPL7MsI4Nswagg6NSAnujPta7PNOILP879wbuFjCkntnasJLVgwO/VHYjDEtLWL5nCRqaolxcDUmd0HwWXPQNU5O7xs9ev0VCCwtqfuus2yrAWRMlm3z5Qe+aKTTKDTGwhIqs7WaqM/wZCU+BTrsuE3Ixgld8O2hhNhqIT66RPRvo4tZ/dpL7wgQ38r5V9TlP/tFi4acNPhR8+pTaEdFrT4m5sG7k8LKT13VnS6v+9a8fivVf5Qy/YBeoKRfBofwNeO4tZCy0HD8fL8sGF423uzMG6Fe2TFNGZ7jER3Yw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM6PR02MB6971.namprd02.prod.outlook.com (2603:10b6:5:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 09:58:37 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%8]) with mapi id 15.20.6156.019; Sat, 4 Mar 2023
 09:58:37 +0000
Message-ID: <8a892216-50b3-4378-1b85-e4bc679d6305@nutanix.com>
Date:   Sat, 4 Mar 2023 15:28:23 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: Re: [PATCH v8 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
 <20230225204758.17726-2-shivam.kumar1@nutanix.com>
 <878rgjev3e.wl-maz@kernel.org>
In-Reply-To: <878rgjev3e.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0163.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::33) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|DM6PR02MB6971:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b20f4ce-4de8-4238-c1ad-08db1c9705bb
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Dj/twg6rKW5I7rRpwbF58xQPZDCjzFPdk8sHtdaaZ+3024Fso3qEPfgRMSNlCCdh0rMEFmRkL2tDVfl9EsZMSzLXnczz8niR1N6kkvlPHApkxGm9scTAs1mo5Ulb4BvVLDbF9nfNuduHmxS6aeQ34wwaDZN47wDEXsxHN0YieS2xfHtEkqpbJSaSqDjL/2Day/xkkOa9B9+O1I1/jIp/uYTKiJIBOdcjcQoorbURo+OSgHYkdgjR2zFc2NV8m5ATRJSeH4s3SikRgD0KjBtF0Jy8qalc4Z2fc8CZRtTYKv2IRPpyZ5mbkCp/TqF2LZcg+9CnOYTnsqiM0qXquG5SjHYnMepn8a+F8lbHfhdC5oh2NnIk/Njqjz8tkzY4tBdFp1SeKcZXxeDpqp0tZNBpFDYAeuzAV4yRlAIIV+ueT2brvwdxQIVaBI0ezkcPvrZcpPNzDWnhkktBYdL78SjoTK+KxhnhDYyZuTJuRrgcVSdkf1bdIOzIpL/4lF7CN14EiFwyQ42dz5Iwq275ABexnIVf7XQue1CsXGBREGdJsHqYGBfXikO2kEOsfOQdGzTb4bPCedT+wqvopEwtvGxjkX/IXFoRmrsq4WW/id7CbHQXg4jxuwiCf/hyLfaFRi3HplojExutB7It7voMQQbyNAhKHRUoI86UeUUcD5dP8svNMEJm+YBy+WqH2Gup9ZnzQBLcWgxgsZUfSXfIRMhEsrgOzFS6dQ+50LX326t0t8tQR7f4+R07RNRl956RW+z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199018)(31686004)(83380400001)(316002)(54906003)(36756003)(4326008)(6916009)(38100700002)(66946007)(53546011)(2616005)(26005)(478600001)(6506007)(186003)(6486002)(66476007)(6512007)(6666004)(107886003)(2906002)(8676002)(66556008)(15650500001)(31696002)(41300700001)(8936002)(5660300002)(86362001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU1QamU3aVIxNW9USStIQjFZaHUxZitIMU0xMVdXY3plUGtZRjZaZnpiQlBr?=
 =?utf-8?B?dWRneUREb09hQm9rb3QyTFMvMVptdEF5bnB6YkFVVlM5Sms2a3loTHVZVXlE?=
 =?utf-8?B?ZEMxWnFLOEpjNnRmSit0ZjZBeks2RE1EQzNUWGpLNnBjZVFCRGdhU0RvVENL?=
 =?utf-8?B?NmRXVmQ5UWNNQTRsbUxoVm1lT1dSanBRUWk2N0lwYi9rcFVwYXQ4Q0YwR1pN?=
 =?utf-8?B?MkZnTGhRMTlCcmFOUTZTYnowYlZHV3F5VWVQTkZoZHJ1Nk1nMHIwWmZwV1lS?=
 =?utf-8?B?cFcwc1Y2V3VVdWVBNnFha0k4ZkRXNTZRM0JvOUFSQk1kR1lYcnRxVHFrZ08v?=
 =?utf-8?B?YllKckxpMHlxem5WSFFVaktjaHpxWnE0aTJiYnFmQkJDT3kvWlQxdFVxSENC?=
 =?utf-8?B?V1UrT2s2MlUwZGIzM0hQdEt3UjdvTE9EZTFNUWRURzNVZStscUVlWlR1TVp3?=
 =?utf-8?B?UzVTWTAwWUNOb2h6VUhvMUtnekNpejRvVnEwSWdMekErOVR0TDBMY3NqY21F?=
 =?utf-8?B?T0xlQldIeXFaN2ZYWWlvbk8wTW9qUjJrVWJ1OTRHa1NpMkt4ZG5zOGdCMmtX?=
 =?utf-8?B?WG5yZkF2YUNwd1BHc1NydmtKWDFYMEZ0ellJMlZjYjlsa2N5ZVp0VktnSjh2?=
 =?utf-8?B?alZucU9kVGh1MkoyQ1l1bjJsSjRRRm56V3gzMWZER253SmJCMHBPdncvYWY1?=
 =?utf-8?B?d1FjY3puK1VZRFZjNXlIVjdiMzEyeUtQWjNlMEg4YVlMeFZ0MEZoV25IZ0h0?=
 =?utf-8?B?U0ZLNlM3UmdhRVkvelBnYW5wRkUzWFRZT2Nac21sZXBOTzZnSmhnYlR6WWNs?=
 =?utf-8?B?SXpnNUZYYWNoazhVSnRjM0dkaUNZaGZEMW1UWFdsRVExbmJkVmY4NUpkL1Zh?=
 =?utf-8?B?eGIxdU1SMTFWN2dHZ0Jjazh4QmRMQnpNZW93WXpPUG1pK0VGREo4L0ErbUpR?=
 =?utf-8?B?TmJheEJIQXNFTXF3dU1kczdmRWRleUlMdWV4V0J1VURvM2VFVXZUdEtZbG1Y?=
 =?utf-8?B?RnJhZzdMV0pwRGNBQldWNEJJemFNVFd4RGE0RGsxSEp2K3kzVUVoYlJaRzNK?=
 =?utf-8?B?Qnd2VTJJSWU4R0hDNlVPR0U2NHFGRVZmcnlIUDJXRURZOHIvT0p4QmxKZXpH?=
 =?utf-8?B?Q2hHNmYyQXMrTVZlMHJsMzdDUHVGeXdGM2VoSkxaSGY5SFUvU0lmNXhGeVph?=
 =?utf-8?B?cHV3bUtTdC8wa0swMWlTai9pY00rNUJGUFB0TGJ6NUpWNmxBNzNIZWl0c3RZ?=
 =?utf-8?B?SHZrVW92RUJIM2NrajJUVVRsQjN0NTQyVzQ3WVl1OEFlR2doc2pOMGMvTFI1?=
 =?utf-8?B?RWdFbmp0SThTTmpDWWdhamlVV0twbEYwUkxmVkpjZFNEN0VaS1FGajlYZkc2?=
 =?utf-8?B?ZVV3Q1EzTkpZd0FkVGlIOXRpVmpnRGZnZ1dYRUduZmxKTWlLQ0NoMDFVSHpU?=
 =?utf-8?B?YkdZL3pSVW15Vy80YmFwWGIzSHZvNUJVME5yRlVWTklabE85NEluWTZUaGdG?=
 =?utf-8?B?bzhGcyttUjUwYi95SXFHZnoxMWkyK3dIZ3haU1BCSGEzN0luSW5BSDR1OTNt?=
 =?utf-8?B?MUV5T0pNanVLTnh5T0dlM0t1a01TRUhoWDJxck8zd3pSZTEzRkRrYnZJVjNF?=
 =?utf-8?B?KzY4NDhUZ1dZWnFJM2xKYWlXaEhpMDNPN3Z4Z2xvb3hPSlh4MzI4anVDckpS?=
 =?utf-8?B?SXZkRG9TYXQ2OUs0WmNEclRYSmkzL1NOVTBBM0o0NVlsUHBvaHV1dURrZVF2?=
 =?utf-8?B?dlQzcS96R1ppZ3krM0g3ckZOMy9EQzNKNDc3SnhMQXNDdmZrWTlhazRNcEN5?=
 =?utf-8?B?cnFORk9pWTNsazl5dmR3dW9UTTR0Q0Jab0wweTlidXpmNitmbUhhcCt0RXY0?=
 =?utf-8?B?a0ZHNDk2UVZpTEd5czJRYVh4eStMeHhMRzZuWCtobmVhM2VTVmprbTVrWmFN?=
 =?utf-8?B?TlprcFVYd1Y2akduTDFtTFU5WVZYRlNvSUZydlZyV0g2MXJ2ZENDTm0wM3Bx?=
 =?utf-8?B?RHdLa1NXRnVrNWIyZ2R4UUdtVlQ2WDcrVjN1UXpuQ0xpb0FiVEMzOGIxUGw4?=
 =?utf-8?B?b2dUc1lXNE9CeE4rTjBPekZmU0wvemJhTExBZERWTWNvcDJIS2lEY1ExMmt1?=
 =?utf-8?B?Z1REdFlXSnVaTDZkZ2s5Wkt1TkQwZ1dULzhFa2VRSXB3elRzVlJLandHT05O?=
 =?utf-8?B?cGc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b20f4ce-4de8-4238-c1ad-08db1c9705bb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2023 09:58:36.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgPz0vNZhgejw/Uzy/JhTilt/fJaIF0uWs8P020G5BC3nwZNemFEfhhGx8/ZkbAQsBUYZ9BQxu9ag+Qqodef00F6At3ath1XYQhp6DnmeKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6971
X-Proofpoint-GUID: 4EN3Njc6dYQVgESe_KBmdn5nGPHGhyNi
X-Proofpoint-ORIG-GUID: 4EN3Njc6dYQVgESe_KBmdn5nGPHGhyNi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_02,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/02/23 7:19 am, Marc Zyngier wrote:
> On Sat, 25 Feb 2023 20:47:57 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>> Define dirty_quota_bytes variable to track and throttle memory
>> dirtying for every vcpu. This variable stores the number of bytes the
>> vcpu is allowed to dirty. To dirty more, the vcpu needs to request
>> more quota by exiting to userspace.
>>
>> Implement update_dirty_quota function which
>>
>> i) Decreases dirty_quota_bytes by arch-specific page size whenever a
>> page is dirtied.
>> ii) Raises a KVM request KVM_REQ_DIRTY_QUOTA_EXIT whenever the dirty
>> quota is exhausted (i.e. dirty_quota_bytes <= 0).
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
>>   include/linux/kvm_host.h       |  5 +++++
>>   include/uapi/linux/kvm.h       |  8 ++++++++
>>   tools/include/uapi/linux/kvm.h |  1 +
>>   virt/kvm/Kconfig               |  3 +++
>>   virt/kvm/kvm_main.c            | 31 +++++++++++++++++++++++++++++++
>>   6 files changed, 65 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index 62de0768d6aa..3a283fe212d8 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6688,6 +6688,23 @@ Please note that the kernel is allowed to use the kvm_run structure as the
>>   primary storage for certain register types. Therefore, the kernel may use the
>>   values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>>   
>> +::
>> +
>> +	/*
>> +	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
>> +	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
>> +	 * is exhausted, i.e. dirty_quota_bytes <= 0.
>> +	 */
>> +	long dirty_quota_bytes;
>> +
>> +Please note that enforcing the quota is best effort. Dirty quota is reduced by
>> +arch-specific page size when any guest page is dirtied. Also, the guest may dirty
>> +multiple pages before KVM can recheck the quota.
> 
> What are the events that trigger such quota reduction?

If PML is enabled or when functions like nested_mark_vmcs12_pages_dirty 
get called that can mark multiple pages dirtied in a single exit.

Thanks.

> 
>> +
>> +::
>> +  };
>> +
>> +
>>   
>>   6. Capabilities that can be enabled on vCPUs
>>   ============================================
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 8ada23756b0e..f5ce343c64f2 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
>>   #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_UNBLOCK			2
>>   #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
>> +#define KVM_REQ_DIRTY_QUOTA_EXIT	4
>>   #define KVM_REQUEST_ARCH_BASE		8
>>   
>>   /*
>> @@ -800,6 +801,9 @@ struct kvm {
>>   	bool dirty_ring_with_bitmap;
>>   	bool vm_bugged;
>>   	bool vm_dead;
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +	bool dirty_quota_enabled;
>> +#endif
>>   
>>   #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>>   	struct notifier_block pm_notifier;
>> @@ -1235,6 +1239,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
>>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
>>   bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>>   unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
>> +void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
>>   void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
>>   void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
>>   
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index d77aef872a0a..ddb9d3d797c4 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -264,6 +264,7 @@ struct kvm_xen_exit {
>>   #define KVM_EXIT_RISCV_SBI        35
>>   #define KVM_EXIT_RISCV_CSR        36
>>   #define KVM_EXIT_NOTIFY           37
>> +#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
>>   
>>   /* For KVM_EXIT_INTERNAL_ERROR */
>>   /* Emulate instruction failed. */
>> @@ -526,6 +527,12 @@ struct kvm_run {
>>   		struct kvm_sync_regs regs;
>>   		char padding[SYNC_REGS_SIZE_BYTES];
>>   	} s;
>> +	/*
>> +	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
>> +	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
>> +	 * is exhausted, i.e. dirty_quota_bytes <= 0.
>> +	 */
>> +	long dirty_quota_bytes;
>>   };
>>   
>>   /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
>> @@ -1184,6 +1191,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>>   #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
>> +#define KVM_CAP_DIRTY_QUOTA 227
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>> index 55155e262646..48f236e2b836 100644
>> --- a/tools/include/uapi/linux/kvm.h
>> +++ b/tools/include/uapi/linux/kvm.h
>> @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
>>   #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>>   #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>>   #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>> +#define KVM_CAP_DIRTY_QUOTA 227
>>   
>>   #ifdef KVM_CAP_IRQ_ROUTING
>>   
>> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
>> index b74916de5183..ccaa332d88f9 100644
>> --- a/virt/kvm/Kconfig
>> +++ b/virt/kvm/Kconfig
>> @@ -19,6 +19,9 @@ config HAVE_KVM_IRQ_ROUTING
>>   config HAVE_KVM_DIRTY_RING
>>          bool
>>   
>> +config HAVE_KVM_DIRTY_QUOTA
>> +       bool
>> +
>>   # Only strongly ordered architectures can select this, as it doesn't
>>   # put any explicit constraint on userspace ordering. They can also
>>   # select the _ACQ_REL version.
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index d255964ec331..744b955514ce 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3096,6 +3096,9 @@ static int __kvm_write_guest_page(struct kvm *kvm,
>>   	r = __copy_to_user((void __user *)addr + offset, data, len);
>>   	if (r)
>>   		return -EFAULT;
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +	update_dirty_quota(kvm, PAGE_SIZE);
>> +#endif
> 
> Why PAGE_SIZE? Why not 'len'? Why if the page was already dirtied? Why
> should it be accounted for multiple times? In most cases, this is the
> *hypervisor* writing to the guest, not the vcpu. Why should this be
> accounted to the vcpu quota?

Agreed, update doesn't make much sense here. Thanks.

Thanks,
Shivam
