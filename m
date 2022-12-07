Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBD2645863
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 11:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLGK7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 05:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiLGK7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 05:59:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D944C259;
        Wed,  7 Dec 2022 02:59:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8NelfgZ0HOySSC7t3lNyOxCG0luI5Fe4/E4OlUTEd0gkFX6NbHep9rjv1Orb38K+BkkiMK2VSTHmivIFg8T8vmQIr8qJ8ROQ3mJoUl+BWMzHcCtyDbUZuK/rCNv92lICwsmoaasvA6xqQVjqrl/SPqKdrNsLcmCNzzt2F2XCR8fknRPqCitzUYomkjWVnCpCd9he0sHbXhiKF+hvcBJpIkLkaNTrLO7SJHg77Y2Q/iB10rPvxZuz/qJf0IyrbQ9E0SoRftJKuznz6w6OGoh0YmJxevAb1H6rwanAAhEucCIfxqzuZQBnLM9qxxVEYM7Y7RmZfeOHG3a/MQnw4nIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buQqov2WOKSvnZmdP+aca/Az3yliii9pOHdYkR3nwvQ=;
 b=BD9wgMn8bZDiv9wTuz2mQAWTum95oMlM34HcOay/+x1VcEqmVctcNni9a07CCApGSnjHag/6apTjDvNLSdXK3wRCzcgbDxB/9YDjyLtvq4PV88RJ/fIE/SJBWjlEf7Sx9syvV6hgr3eYTes2e/m1sqVqU7h03jlfOKrmUFrS/9EzqcCscJeZWhetr5/Fh3xeT7ZL4/UBu0MUDy509EWgv9wFFIsHmvkU56Oa1iG6MzpgeHCeUMRZWa+cVZcKPwU/V4VGVIIbOJO8eGGqjrzT9J3T2IrD+OdIwakJtJgWwH4kK/FXX9B4zcpzQUmnhlxKl24/a1UDN5e+vrLqlk2fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buQqov2WOKSvnZmdP+aca/Az3yliii9pOHdYkR3nwvQ=;
 b=nqVyeJIvIpJjeBodTdt42qST/Juv/px/Lpg4xAb9VZSI1dRnKkn0QXjIcMQzw1UpdeA33V/3lQv4PTQlPd3FX17auVHW8GHZV6A5fF+OFIanvX9w7Ps3GxiONjXRbKzrzWCq10UuOfN/z1Y4wdp5FhYQp3htfCx2911bebRwq/rNYBox3jILyMGxjVQi7wSG3t5w6QLzORGlD+3BlSs5tHyoJ6Rbak38WHbIn3ZNaNuO4Dcr78b3QWRnqD7nfk1RvHYMxGvXGtT7Rg4ygYw3q2u6HOq3Tt5kdj0ZlyS5fEYn2oqNDbKNVTWOPqX+UEkcGTdfFokpQsdFWVLnO43tuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by SJ0PR12MB5633.namprd12.prod.outlook.com (2603:10b6:a03:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:59:12 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 10:59:12 +0000
Message-ID: <4f11e0bb-e090-bf9b-4f98-578273865200@nvidia.com>
Date:   Wed, 7 Dec 2022 12:59:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com> <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca> <20221206135810.GA27689@lst.de>
 <Y49eObpI7QoSnugu@ziepe.ca> <20221206153811.GB2266@lst.de>
 <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20221207075415.GB2283@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0167.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::6) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|SJ0PR12MB5633:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8970b8-8775-40fd-0171-08dad8421221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8iGFnW0ShFVZyOvyyCF4/gmXAUvwB0ZJFpgjy4+qYpYYN/VVvP/WAmBQG+NE0Aj4dp4TodsTz1xSVv78w6Uqz04EGl7phYcJ25CPPRu13QJtKUMYW57kiHNbiPQpHKSmu/c0THW0YjztKvd2uSkSPJYYTX8TwLedou9jlnZ4J+d9nE9mQ8l/los4H0ycdmPzx+tF28X/zUVkXjN/bl5Svgk8IqBx62HrLRYiJofCXtnMI/7fUBtfaXF3dsXx/tg9Gl2FyQlQoRK4pU13+R8RXrQp8x2JSSkqjBe9LMMlCnIEA8Unm+otE3R4QNmZrP2Wj60faFAVAghXUpBnLz7pI8NfQelsI8uQt5oYWr8xvYZQdFrVl6nvsZm6TcqasFs6AhVQ+yUVv8Pw2Nm3LJdwDoYucECABNk3NDM0ePt25MyrCuisRnb8YG6hHdgRpVgfDezMXA94pMyEOfqkS5o1TChLQE3da1uxEC3qXZlHZj5SBBh+YRUVBGcXPlYEgikHgKl1YNTkmGYc+wkHShaQtMFrgJxogc1rjTcr619MxYt+Bk+niOwSTQqupMgoWvhIV4ZxNnYRETDAGf4NrSpEJsuveNSwaaXCLcfe0NZRfrmzCDdYmAVyOtrxzvibENWNwhXO6uMytS5KfmRCrX7DCH2Ky9+d7pfziwigg/3/bY9I9VO0GsTLMMkyRhaT3ls6dgoj5FBfq/6sxeQvrO0QzIkI6DkBe5GVtR2e7W1uUM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199015)(478600001)(2906002)(6486002)(41300700001)(66476007)(4326008)(8676002)(66556008)(8936002)(7416002)(31696002)(86362001)(5660300002)(66946007)(36756003)(6512007)(31686004)(110136005)(26005)(186003)(2616005)(38100700002)(6666004)(83380400001)(316002)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3YzQWRkRXY5U283Z2V6NmdoN3RPZklEUkxWZEdXWjVxeSt4bm9BRmtSNVlk?=
 =?utf-8?B?N2hFaWw3ZWlxS3lsV0dicTRnMmk5NEU2QTdWRDFnVzdzZU03RDdPVTFwUExR?=
 =?utf-8?B?d0lNaTV3Njg3SE1ucm1Dem1QMjRDb1ZieG9tNkNRazNJRjQ1VDJ3dERLS1dx?=
 =?utf-8?B?Zm9SNWhNbmZxY0JUSDc0L0V6ZXZ0eWExaTJnaHZLVEp5Ym1WbVBWbWpwV0x5?=
 =?utf-8?B?QjZOeVYwUW9UVkRBanJMS0lFNVFkOGE3UG5pblBiVmQyN1ppczk1RWltV1BE?=
 =?utf-8?B?c252MEZCTUs0UWIxVWtFMnVxckpybUlrTDZJWkx5OGgyOTlmNVF2QWVlcjlj?=
 =?utf-8?B?RVZlNGVrUUpHZ0xmR1FGN29XRk8zRG9uYTJrQkt4bG9Ib1diQTVaN0ovWWNM?=
 =?utf-8?B?S3pIWUx1bU81TEQwUU83Um9pTE55eEg2dkp0RVpibUp4Rzd1TzRCcFA0eXpK?=
 =?utf-8?B?emlsZ25CdTFZY1NnWWZsc2dtcEpvaGF4RjQyUTduSzVxRmJWbVZ4L2xpWSt3?=
 =?utf-8?B?SHhRS0FLMFYxdXFvY1pFRFV1d3B3M1gxc1JDSEhTQWhxcUluYkkvUGxPM3pM?=
 =?utf-8?B?WTBvTGlIWnhONHk5ejhYV0locnVnRHptRC9tZUJpUm0wb1huWjgrbTlQa0d5?=
 =?utf-8?B?dGcrNnV6TkhMSHFtYXBMVTg3MkZ5YXZyL2FOeEcrbW9vOGFudUZPTkdnWm5s?=
 =?utf-8?B?VGVYWE8rWWZ5M25teVhVMGFpbUhXd3E1dnZ4VlRONytWQzlPR1FObXVZWDZZ?=
 =?utf-8?B?a2xybmpMTkFuUFBjd2NwWk5lWCthTlpvc3ZXNkNQejJjbDJGSzVwenlkMFA1?=
 =?utf-8?B?cjV2TEJLZFJWM0VaRzNWUjRLUDljeURITm9OTWswaVJZUEpJcWdDRGdsUm1n?=
 =?utf-8?B?ME85RUVRUE5UT0dQMjhzNDJxTmZOdnZ2ejUvQ21WVmxYcm5yYXJMb0pWekZt?=
 =?utf-8?B?RTFUcEcwRGZWaldxVVpDSXZraDRTQ1RKcXplRUlDV25MeEY1T1E4SXNraXdP?=
 =?utf-8?B?TEQ2ZUxKZzJ0amdGVWxSU0VCY0RaczkwN2JlVlRxSTl6YzN0M2E1alhIMnpU?=
 =?utf-8?B?a3paL2xWT2gwSEVCUzhTVER4SUJrL0VuQ1JsTkJEYkFNSmdtWHBNb0dIdXNp?=
 =?utf-8?B?bTlvZ0x5YmZpVWRWSkxTeExFRUZPbUxmeUNFZVFENWh2cGZ1Zlk0Z0hRb1pO?=
 =?utf-8?B?RVRSQUJ1dG1QT0czK3puYU56OURRT3VteVpLREpZcnVnQmx5dy9FVzkwN3RF?=
 =?utf-8?B?dVNjN09KQ2pHQ0hicm9yQWlQY25VVHVXd05lc00wTnlPNzAvTmxZS1NYMHdk?=
 =?utf-8?B?NlNKYlZ5aVk0QVNVWWFXT1pBREYxMkdvSXVRSlJyMURHdEpZTjNwR09UZ3dL?=
 =?utf-8?B?bkZyQVg5WXlVOVZLR2VBZnBraWV4d0xSamVxTUdxQVZFR0dpRm50OStkd0cy?=
 =?utf-8?B?dDVLYi81UU9GUlhiV3oyazdIcmw4RFJvdUVSVDB5UCtuQTAzNWZyMTA0dlox?=
 =?utf-8?B?cnp1bllGYXptNmJrSCtCSldPR0JkY21kTzJuanZPZHV0RnMwaGhDRXlzNjVK?=
 =?utf-8?B?dVA3NS9LUlhRcitMTktpZjg4eTkxdFJ1VGFuWmYvYnhiRjdaM3lOWktTNXZw?=
 =?utf-8?B?ZHBPTnBqYTVLdFdybkwzMHNOWFpEWXB3bmVqUmQ2NjM0czdxazRHWGtkQXln?=
 =?utf-8?B?RjE3ZEl1RnZzL1NMMGlmZlBBMlIvNE9mNGEyTzQ5UDZjU0F0SUtFaXJZdG1Z?=
 =?utf-8?B?dmRxdjl6K3hhVkFjSUVTMGpUdk1uVFRyak1GeElHSDNrTFVEN0k4cWNHNklC?=
 =?utf-8?B?VWZmZjVaa2lTWnpQbkFVcTdkeU5KVXdKR041Q2FhNFJSd3pxaHgvYTY3TGds?=
 =?utf-8?B?Mk1oTThiQjZORVIrOUpPcWE2ZWVYUUhodFBLWFIrMUtldjNlbEtlM0xTejFS?=
 =?utf-8?B?YURlZVYzeUdoMjRJdDAzcEZsUDVDcXFEcVVoSFZ6bFY5S1UrL29GMk4wdC9O?=
 =?utf-8?B?anFUdmVtZDVRYnVOTnB0YjljZXpOVTkwOHhrYzhmS3hsbzVVcW42bHIxMlps?=
 =?utf-8?B?SWpxcGZDL0lNRFNadVJGK0xVNGEyUjEzNTJEQXhGaWNLUGZEd2dsMjlxVEJk?=
 =?utf-8?Q?8VyPs5JzBUamh01wZuvYXiy59?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8970b8-8775-40fd-0171-08dad8421221
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:59:12.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7FGaE/Qel0aY7llTIgbeqvFoXQylyVH6XArUCgfAwk1WSLWSliBME3GyFiZRIhgLG0eD+2CBn3+UsyKYv6wcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5633
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/2022 9:54 AM, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 03:15:41PM -0400, Jason Gunthorpe wrote:
>> What the kernel is doing is providing the abstraction to link the
>> controlling function to the VFIO device in a general way.
>>
>> We don't want to just punt this problem to user space and say 'good
>> luck finding the right cdev for migration control'. If the kernel
>> struggles to link them then userspace will not fare better on its own.
> Yes.  But the right interface for that is to issue the userspace
> commands for anything that is not normal PCIe function level
> to the controlling funtion, and to discover the controlled functions
> based on the controlling functions.
>
> In other words:  there should be absolutely no need to have any
> special kernel support for the controlled function.  Instead the
> controlling function enumerates all the function it controls exports
> that to userspace and exposes the functionality to save state from
> and restore state to the controlled functions.

Why is it preferred that the migration SW will talk directly to the PF 
and not via VFIO interface ?

It's just an implementation detail.

I feel like it's even sounds more reasonable to have a common API like 
we have today to save_state/resume_state/quiesce_device/freeze_device 
and each device implementation will translate this functionality to its 
own SPEC.

If I understand your direction is to have QEMU code to talk to 
nvmecli/new_mlx5cli/my_device_cli to do that and I'm not sure it's needed.

The controlled device is not aware of any of the migration process. Only 
the migration SW, system admin and controlling device.

I see 2 orthogonal discussions here: NVMe standardization for LM and 
Linux implementation for LM.

For the NVMe standardization: I think we all agree, in high level, that 
primary controller manages the LM of the secondary controllers. Primary 
controller can list the secondary controllers. Primary controller expose 
APIs using its admin_queue to manage LM process of its secondary 
controllers. LM Capabilities will be exposed using identify_ctrl admin 
cmd of the primary controller.

For the Linux implementation: the direction we started last year is to 
have vendor specific (mlx5/hisi/..) or protocol specific 
(nvme/virtio/..) vfio drivers. We built an infrastructure to do that by 
dividing the vfio_pci driver to vfio_pci and vfio_pci_core and updated 
uAPIs as well to support the P2P case for live migration. Dirty page 
tracking is also progressing. More work is still to be done to improve 
this infrastructure for sure.
I hope that all the above efforts are going to be used also with NVMe LM 
implementation unless there is something NVMe specific in the way of 
migrating PCI functions that I can't see now.
If there is something that is NVMe specific for LM then the migration SW 
and QEMU will need to be aware of that, and in this awareness we lose 
the benefit of generic VFIO interface.

>
>> Especially, we do not want every VFIO device to have its own crazy way
>> for userspace to link the controlling/controlled functions
>> together. This is something the kernel has to abstract away.
> Yes.  But the direction must go controlling to controlled, not the
> other way around.

So in the source:

1. We enable SRIOV on the NVMe driver

2. We list all the secondary controllers: nvme1, nvme2, nvme3

3. We allow migrating nvme1, nvme2, nvme3 - now these VFs are migratable 
(controlling to controlled).

4. We bind nvme1, nvme2, nvme3 to VFIO NVMe driver

5. We pass these functions to VM

6. We start migration process.


And in the destination:

1. We enable SRIOV on the NVMe driver

2. We list all the secondary controllers: nvme1, nvme2, nvme3

3. We allow migration resume to nvme1, nvme2, nvme3 - now these VFs are 
resumable (controlling to controlled).

4. We bind nvme1, nvme2, nvme3 to VFIO NVMe driver

5. We pass these functions to VM

6. We start migration resume process.


>   

>   
