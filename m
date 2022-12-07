Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72683645CE7
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 15:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiLGOuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 09:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLGOuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 09:50:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9A2A73E;
        Wed,  7 Dec 2022 06:50:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQ7jyeySMhH+ej2mhpHxUxHflR8KH1K5zaNXgG9f4T46oZE+9bDg/7G0AmQ3gKRFFSb1Kr7+jc6yM/E6aOJYsAuxrvqAPIqtK65uZ3UXWlIHmASmcvfZZ15GNfYUnLQD85TE190mFeTHGs9SUYMzQuz05qQfEMqvHClOutq38bGTiPXgtQpGAHp4IanS1NQRBd5HakHd+zSN19rtH04efsts7iXJ0YQwgMBcJZBQ9KKO2d6xxa6WQVKotm9qBGdzhgi5o3ZKGMUriqAyyPdH162AYffTjxcAqq5LbWamfqOjE/AJ15etHMxiabERxzEjFtnbdjqd1WrLr1NFr2YSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alIEnyvyuWfs3wUHyAimL7vmw1ZIf2GKS8TPqDPpe/U=;
 b=gB+XgjIf0o+Es73nLaE2QOLVEcUd6ILl5OW8A6QVqmjUFc5paEp/JrWroSc/TNsvyBmWytzitXEQ69rrOU5Azgl327/db8dPPyCOKe8ckorFZ2NC5a2tJoYZ7Gxrd6WXrbFXehI8ChVj018Y4QJpAflYncQP66YPirWDyYKCaCeho54z+iOF873ElowMLCv1M6BmYdQs6RQZP3MZ3bjHVr7tNPn0Y7Scv6zqidl7fGafAWWyAKKVy/6vIWdhWJEdyCmFm3N7izLbQs4SMS6PT92XmH1RR6tDUiJ+WJSMynjLqa7P5xV3/j7ADu0W885O5+wA3xYVhLbW+vvrgqIwVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alIEnyvyuWfs3wUHyAimL7vmw1ZIf2GKS8TPqDPpe/U=;
 b=is3QpAIwpnkuKwFMRnKK3v462sB0rCvTJdBFFifaEE33IMDsDypFGFEJXViRiX0o4JXBpjvRLw7DVk9I7llaAUQhkm3+m/7/kXRs7NfPOwqU4wGW+CIXqT6cR00tvzXQmDIkBTZkoeHjHC1U41zpon55Sm3MkrNha9o45U75rb7w3PnQ4MjVbbK7DvT/XH754wxcM6IRIckaL0qhl3CFfx63kLqsbLpylDCfpCTOsLkcCMFxMK00EyVgdfUzounImwmPUT8XfRjO7zATt6o6qFVzM4RjvJiJVZ/83h2VlPWuZdj/Lkq1qVqfgbO2X+n4ZHfi/lJnaNuLGFicomMpXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:50:11 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%9]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 14:50:11 +0000
Message-ID: <d28a7848-b284-6c86-a2ae-ab79de3675d4@nvidia.com>
Date:   Wed, 7 Dec 2022 16:50:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Lei Rao <lei.rao@intel.com>,
        kbusch@kernel.org, axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
References: <20221206061940.GA6595@lst.de> <Y49HKHP9NrId39iH@ziepe.ca>
 <20221206135810.GA27689@lst.de> <Y49eObpI7QoSnugu@ziepe.ca>
 <20221206153811.GB2266@lst.de> <Y49k++D3i8DfLOLL@ziepe.ca>
 <20221206165503.GA8677@lst.de> <Y4+U3VR2LeEh2S7B@ziepe.ca>
 <20221207075415.GB2283@lst.de>
 <4f11e0bb-e090-bf9b-4f98-578273865200@nvidia.com>
 <20221207134644.GB21691@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20221207134644.GB21691@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0255.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::27) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|LV2PR12MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: e0332c3d-2158-489f-5ac7-08dad862573e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qz4g+HpZKP8PXaZ39q27Iljdl7BEA4PZx6nIeHBCKn5DBcZZQG9bCV/QqH/MChXtVkXbyEzCZxw7h8FvV7xkPDWUo2qnSra97DkE9rqD+oSsQtDUrXN6FIt5mpF3iCvAwQMR4qvRouYErz7q6pWsHo2zNVQH4LMYpKIcBdsIWmCd5X0vWLMVOYSkv3FQx9BTwFOTBnYUflGPQwgrhVyYlQqWrFHAZUmEmDXUbBuVyVEYGKVfOep7fg/3p+gthvyW3RdKbNTfrR1m5eFj2ZiPS6zmq4XL0Izyln4m+ltNgNNgD7cA0Sk16hoWb3R4IlGy0vobbzIuSR+YJYo+OoPUBQxhvekKZl4HXGS3gjKmvEunx4x/p7/XzDqKe2vN2I5knSlUqJP5z4x6Uv97E+PUTc8I8jzHh9GxG50aKUYD0Xv+y1uSmQTd1zjafOA6h2mixRW/xolRyRFnG6EcHNzr264QLTOQ0ZcCuTJWliRvCngxJ/Al1JVvOBEwIIBFQgm1Qgp+xnW56xtBTBMeKEBfSt335ZzBieB4A1jZKJIAOvyJE5wAkBQcI0Eaze5B3mRdWVEZwKhKCnHr9/qhLGP4FbrtuREEifs4+Wc4Ck+UcrPD00SpBHIriWElwgNiH4s7tXhooQ+3T1LnZ9EaJkr98jf5+cHcDsyK5F68Klj6Cf4BO0rWEeTqpPtNp61ef1NqddFOGTvMgr53f3yv37QIHhocDu+NcHs5QCeCn+QSsl4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199015)(2906002)(41300700001)(83380400001)(5660300002)(8936002)(36756003)(31696002)(86362001)(38100700002)(6916009)(316002)(31686004)(26005)(6506007)(186003)(53546011)(54906003)(6512007)(66946007)(66556008)(66476007)(4326008)(2616005)(6486002)(478600001)(6666004)(8676002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RC9mYmVoMG9ydklJSkFkTkUwVjlweUNkMXVycFdVK3d4ck9ZNmgxbkJvWGF0?=
 =?utf-8?B?cDZrblRrQklOeFNxellFRW9FaGY3SG4xdFBMN3ZCZ1k5d1pkODhpdkZucUgw?=
 =?utf-8?B?blF2ODc0WU40Q2I3TldMRFdqQ2NTTmJOdy8rbXdYeHpzVThYYkVOa1NiR2U4?=
 =?utf-8?B?cm9oK1F6NW1ZMGVuMG54TFJlQXpOWnN5RHBMenk0WGVxWGlKbklZdWc4UU5x?=
 =?utf-8?B?NXVqMHM4SDdHVTNHYTIwOXRqNkFjTTN6RXZ5R3BIdkc5YUFIY1UzdU1Fc1Ru?=
 =?utf-8?B?TFJIVWNEeW9hamRHaWVrTCttYXFyWUVIZko1SnpaTkdmV2d0S05XaE9QM21U?=
 =?utf-8?B?Q1huWG1TeCsvWlRBcENSQWhlZnNnTDkrenRoZ1NjQzVyU0pSYVg4Q2lvRXpn?=
 =?utf-8?B?aDhzTStmYTdiZDZyakJ1Wk91YmJjcGNsbUtFWnRPS3orUGVXMXoyeE1iMldx?=
 =?utf-8?B?b2trRFdHSmZ4UklxNnFaRUQyNW1OaFJybjFlcyt0UUJyTWZlNW51VHZ1dy83?=
 =?utf-8?B?aXpZM0FQZ1NCRHF1cUE3N1hlSW5iSTB0dU5vSEJOcE9ZRlVFVlZWVXZQSEVq?=
 =?utf-8?B?WVFxaDcrV3ZldDhBcG10S3RFY3FPZHcrS2k1SlRhczlWenBwNHhvdXRxa29V?=
 =?utf-8?B?UXowR3VSYnAwNFFoWHpqN3BOdVpnbDRxeWVvZlBiMzVSL0lwNDBza09WN2xu?=
 =?utf-8?B?VVZnNjZDRVprZENYWnlNWmNXZzA5N2h2eVpIZ3ZFQjdJc1ZpcFM0UzI2SUh6?=
 =?utf-8?B?YkNOQ2tId1RBTzk1a2J5aHhhK0lQSWo3QWlZNk9DblVYQnFjNEVhQ0dqT2VO?=
 =?utf-8?B?NGlpZVB5c0pvTXQwVmpZcG51UlJPTk5ZZXI4NTZrMHpVMDlKSEs5eS9DTjdI?=
 =?utf-8?B?MndMaEJuSXBhOXYySndkeTZ4d3k5ZkczRXNLTTZXZ0t3TEpkUFI3STgyeGVy?=
 =?utf-8?B?dHJPWnZYM05KbjZqNjBGOVRZTGNzZkNJVE5IY3JsdllScUR3RVFmcUErYlND?=
 =?utf-8?B?NTV0TzBzMXhmUEw2eDQxMU5yeXRNQ08xcVJRM3IvVXVtMDFydE5nUTNlWWF5?=
 =?utf-8?B?Z3FPZGhYZzhPL1czZEUvaythTnpFcE4rZzg5S2dVWjVkTnVWQmhvTnVHRERK?=
 =?utf-8?B?MHJwZWlYOWszSlE4SkxrR0dEOS9FU0k2YW1aOFg2Z3lyTjU0V2drcTY4VlZm?=
 =?utf-8?B?YXpEd1NCVGNJeUZ5ZEx5Z0FmaGRTdlU4cmMvTGFnNWl6ODg5NktQVktGd0ZO?=
 =?utf-8?B?VDVEUXpSVlpJbmprU29wRm5iK1pXSngvWkNFS3FiK1NnNVpVVjdjTjNxUFdh?=
 =?utf-8?B?N0pndmhVU3lLK0ErSXdWTWp3N3NyUnJLbkF1RXlkNDAyaUhvZkJWTXV0Qm1m?=
 =?utf-8?B?blNDRUZhV3c2YUY5WE12bDgzbUk1LzJFcGJQN3BOS3ZJTU5UaElVV1lVVWdZ?=
 =?utf-8?B?NnMvSUkvcktjQU93a2piTDI3SnRMK2V0TkhueHlPZjZFM1M5QzBTRGdnNUJZ?=
 =?utf-8?B?cGZvYlB6U3BPYVU2M0plZ045K1VJS1h2R3N5dUpiem1lOS9lTXlKUkpCTzFC?=
 =?utf-8?B?cEZiMkJsb0tuQ3ZhUFlKM1YrRkdpWi9JVmtELzBGWUp4aFRDNzBhTEh1Rjg1?=
 =?utf-8?B?N0g0THRSRndWU0x2MUFpa1k2V2VSdUpyRXhXSGZoVGJjT2QwamtHU3BVOVUy?=
 =?utf-8?B?YnNBSWpCbkpwdGhtaUpPLzU1Rkx3czZUbHBGdjl6ajlZd1dOWVpUUjdJcGwx?=
 =?utf-8?B?NnJQaDRneUNRTE1HeFdkcTZHZkNtT3FFRnpZNjlFclZ2YzUwSjFyQnFiRmor?=
 =?utf-8?B?OCtqaFo3dXRtNG40T0FMTlFkT0ZUUHFGSzF6ejdGdFk2VXM0WitJbDR3UHpC?=
 =?utf-8?B?M2cyYlAvUy9PTnlHOUpIOEhRN24xQTVyQ1BoK3diTEREaFk2L0JMeXBmQll5?=
 =?utf-8?B?VmdOSVZFYlZ4Z1VOY2RvWEc0NmhJbUlHZHlLVHIrcG5QbDlkR0xXaWplNE0w?=
 =?utf-8?B?Uy9nNjIwK2xxbldXb3ZWRkQ4dGhhMHVmVUVaSTNuWjZ0MVJwZ01TNGhkaFRD?=
 =?utf-8?B?eFl0SGN2NWdlNXZhMm9nbDFHdjM1NlVvWU5YNzdlWnMwZEJCejU1MXF5YmpR?=
 =?utf-8?B?Q0VycnJ2MVM3eERaVWRuQ1Ixa2FMRGNZeEd4Vy9PRS8yYTNjOU1sZTh1ck9P?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0332c3d-2158-489f-5ac7-08dad862573e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:50:11.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yY1NzTZwMJVvEnxIrQOTLxjJol+0U+FIjcu01eGroV573me17FOeVGTcFKabCVBs7hMY9n+NsYVWGuQ15TXlhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/2022 3:46 PM, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 12:59:00PM +0200, Max Gurtovoy wrote:
>> Why is it preferred that the migration SW will talk directly to the PF and
>> not via VFIO interface ?
> It should never talk directly to any hardware, but through a kernel
> interface, and that's probably vfio.  But that interface needs to
> centered around the controlling function for all the reasons I've
> written down multiple times now.
>
>> It's just an implementation detail.
> No, it's not.  While you could come up with awkward ways to map how
> the hardware interface must work to a completely contrary kernel
> interface that's just going to create the need for lots of boilerplate
> code _and_ confuses users.  The function that is beeing migrated can
> fundamentally not be in control of itself.  Any interface that pretends
> it is broken and a long term nightmare for users and implementers.

We're defining the SPEC and interfaces now :)

Bellow is some possible direction I can think of.

>> I feel like it's even sounds more reasonable to have a common API like we
>> have today to save_state/resume_state/quiesce_device/freeze_device and each
>> device implementation will translate this functionality to its own SPEC.
> Absolutely.
>
>> If I understand your direction is to have QEMU code to talk to
>> nvmecli/new_mlx5cli/my_device_cli to do that and I'm not sure it's needed.
> No.
great.
>
>> The controlled device is not aware of any of the migration process. Only
>> the migration SW, system admin and controlling device.
> Exactly.
>
>> So in the source:
>>
>> 1. We enable SRIOV on the NVMe driver
> Again.  Nothing in live migration is tied to SR-IOV at all.  SR-IOV
> is just one way to get multiple functions.

Sure.

It's just an example. It can be some mdev.

>
>> 2. We list all the secondary controllers: nvme1, nvme2, nvme3
>>
>> 3. We allow migrating nvme1, nvme2, nvme3 - now these VFs are migratable
>> (controlling to controlled).
>>
>> 4. We bind nvme1, nvme2, nvme3 to VFIO NVMe driver
>>
>> 5. We pass these functions to VM
> And you need to pass the controlling function (or rather a handle for
> it), because there is absolutely no sane way to discover that from
> the controlled function as it can't have that information by the
> fact that it is beeing passed to unprivilged VMs.

Just thinking out loud:

When we perform step #3 we are narrowing it's scope and maybe some caps 
that you're concerned of. After this setting, the controlled function is 
in LM mode (we should define what does that mean in order to be able to 
migrate it correctly) and the controlling function is the migration 
master of it. Both can be aware of that. The only one that can master 
the controlled function is the controlling function in LM mode. Thus, it 
will be easy to keep that handle inside the kernel for VFs and for MDEVs 
as well.
Although I'm not against passing this handle to migration SW somehow in 
the command line of the QEMU but I still can't completely agree it's 
necessary.

