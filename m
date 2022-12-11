Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6926493F2
	for <lists+kvm@lfdr.de>; Sun, 11 Dec 2022 12:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiLKLjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 06:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiLKLjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 06:39:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC79DFC5;
        Sun, 11 Dec 2022 03:39:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h//Lef0BXkbsr9/9JiAFQyvTI6ONNYIlAYNwHqpdSRYT9qFzfCdWDkKEW8HAoXFUf4ntFeyPHItUB64x1hiANSYZ7Cf7LWhEf6EdvniraEHhZh6O8ZANsX/5Qy3hm2xa4eqh2L+USawSqmB5mHKbY/Di9IiJCOb+Umk93PKVOmJOmxBf4HHsYIwJEFT74l2rROcuOSLws/R3tsdwieFO0vC8fE2UV67TCOZXRV3nEv4MJP3kGp0iummQ6AOrN1aXwbVt5xpboEioq+DflxpK1soZfgRj193MTr5bNO50Xx8NWZKvTp1k8ydogBPeaLNVmRIeCo9xAEkl4tCDrK04Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfArguyTpK+dBqooC/jWkqt1KR0R3RbfbYkWbhcZOPM=;
 b=W9mLFgJ5AL0MBgbCp8WV7cebjaDabbFyOBfRbZR04iiYghAHxtv0hYkS5+chvTcxrGuQnVTCGhPVKabH0YdCqIF6YRvpHiy8cB09+HgoSQycatbMFVRmQVRkbZMvkYqWP9G7CfZwFPT/hKdmy8h+RO2zmKMm0DSHMyk06muRojrKkSnn5gfKnGLoXymy96F1O3Onn6oaWlBQnvLJQevChTeIH+3MqWNyLSX7ubh7ynpop/PM+scZ6Xv6eUFbZTGPKJFtkY1p1FmwIQnmdXhu+uit/aDYrbBo7GXZjyc1KTAkO221LcG9fnnyobg3XFprBaM2msApBWrKuDJoKWTUTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfArguyTpK+dBqooC/jWkqt1KR0R3RbfbYkWbhcZOPM=;
 b=Jd6YAjVXlqcnveH9jON3zDkL2Id0++eshRypzqFqZAlhd1GhTXBtK/2596UqGWd18MrBPLsz1ZkQJU48oM4VeQUAtPhrnbSjCRNpClLqtgGShqe4PXcr0TvJKY3cHJr82cjtYVYJlcGI32lIzBc+EeJB2MBiWWTACaoumfIUCeRXa3hQqONT9eAYm7vRS/RyMeDE8JoXAv6LalqAbcqybp4QHW9Rl8Tuu6X4GI3FiLkyuT5d81wqT/Je7A3EkSa4TRKGGKMoHak9AE7I8n9wJFYsOVrSgcRIPFm/hiSwB03D9yGuiFq/IdtoNI33o8pbMKzItSyRLd0FviiupqmMQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sun, 11 Dec 2022 11:39:47 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%8]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 11:39:47 +0000
Message-ID: <b2ade627-0abb-08a0-c28b-2bf8eb8e4973@nvidia.com>
Date:   Sun, 11 Dec 2022 13:39:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com,
        Oren Duer <oren@nvidia.com>
References: <Y49k++D3i8DfLOLL@ziepe.ca> <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca> <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca> <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca> <20221207163857.GB2010@lst.de>
 <Y5DOAKArjyfb6Mcz@ziepe.ca> <20221207183333.GA7049@lst.de>
 <Y5DyorZJPdtN5WcX@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <Y5DyorZJPdtN5WcX@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0082.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::8) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: 60111daf-1a6d-4802-d308-08dadb6c67a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQeK2ajitkjBgrMRgmNsa/mxhfxx7Z8PaFs0/IjO6rsGm5vLhHR8iILKrjN5I8BIi6thtXGizS0D1wSmt4OieykSo1fQxBre/NPgwdl57YKNkf8i7W/6WSF13HhP7AIXdj2l30h0Qw9UAQ8jSfAjd/Dhg/eH3xrFpgyodae/24tVRak7El/tHnlP5MJKzE50JJvCcDnY812lhV8IncXK9uvCc1FDcr6m7/T7Qj/prmZmlAdhrcUZ4pCUp3FvBUUH3ihPmrIOM8c9DY+aM1+Wai5azaMRGp6TFo2/RrxRkV8gdUxyb82uSRYM3KqKMt4/pSO67CbPnE04NGZMr3D4HVZo8aqJNXEete6hqLNgQgfhFdbbaUHk5EhKUHe03J0rAJYklTrZ6kYg0ENn4eOa2UMNTmZoQ+nZQ/msJsr8xKnT81qox02EDs3EWTUkil9IzYeohAnYOapNRLR0agJXWUkY4eeu36J53gQsLFXsl/3rL60h+rJBk8JHn5Ne+H2JPTwqrR0iYyGSsQBLA2VmURkUWRi+dsiicT6IowC2PZ0KeCK1ONSL788swPxGaXrPG3WpWpldA40B6xVhmwkgFag7emUbDiGxR1/Zs9SvQ8PLegNbvdB2O+M0ftRiElX2cnMtqLyDs6BE7R4iN2OnsDnBKOzQlhMnct0ocTPDAXLFf+qvQqzpdj5wb572R4H/ElMCdPyPH9p7trh6hwyr3C9IeAFor2wQtXRY1il1cxg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(31686004)(2906002)(2616005)(186003)(110136005)(54906003)(83380400001)(36756003)(86362001)(31696002)(8936002)(66476007)(66946007)(8676002)(66556008)(5660300002)(7416002)(4326008)(316002)(6486002)(478600001)(107886003)(6666004)(6512007)(26005)(41300700001)(38100700002)(53546011)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUJTWjZQeUNwZlU1L3c0aVpOV3BFVFhFMjVSYTRmUFBsRUR5TVVmTG96NCtJ?=
 =?utf-8?B?bU5PZXRhZVU2dXRYT3ZyK0dTTU5NTksvU1MyYkJGRko2dlRlSFlpVzh0UjhC?=
 =?utf-8?B?Z0NoME1tWHY1a0FtK2s5Ym4wSjM5T1dJWC9sNis1R3F4ckVxcTNER0V5cHk0?=
 =?utf-8?B?RldSbHRsNTJwZnJSVTBmMnlJQTE2RXBaWTJ1Qzh3NDVSSjF0MCtENTFObm9n?=
 =?utf-8?B?Z2xtVVZYZWM0Z0pBdmF1ajJWekUrVHgzU3NWanlsd1pRbUN2bDhlZUdMS0VL?=
 =?utf-8?B?VWpNWjRnK1Z1MU5RWHJIOGZWV3Bwa3lXaldEWktsUk50YllCc1lGYzZqaThX?=
 =?utf-8?B?TEJZUFZUVFhDQm0wQno1ZDJub1NJa2Yrd2RpOC9VL2pJQ2x0cXhaZFhCK1Z6?=
 =?utf-8?B?MGthK2F3RW5RUEdYRkRKc09iZncrL3VxRjdERDlNbUl4MC9RdUVHeCt0WUZ3?=
 =?utf-8?B?TFdpYllJOVdUYy9pL0NDaWl3amlXaGdDNFFHOWtLNmNad3B5bnRvRG5sZ1g3?=
 =?utf-8?B?dUdqWVBYaEVtdExBWG9GK0RiNEhpbmg2V2NGR2hiUWxtMTNkUFVzTG9RL2lJ?=
 =?utf-8?B?d3NwRW40WG4wV3F3TmpDMTRFTUNEMk5ET25UQ2FSTDNrSDNwVXRPcnU5QmY0?=
 =?utf-8?B?YmhZdFBSOVZzYnBGZ0FQU3BxM0RCNUk0THNTaEZ0Z3pWUjR0TitBTndRUjBK?=
 =?utf-8?B?SmQxU3RuSXgvUEJ6RmVTZTdPci9TZXRrTXFydTRBRHdDSHNTWm11dlRRUFlp?=
 =?utf-8?B?dXJFSnZSMkFRWWpraTNvdFdHSm9Hb01ZZ0dIb2N0QnlMQjc4dFowNWtHd05O?=
 =?utf-8?B?a2FYWGNrT1RpUXV1Mm84NVB5RHo2bm9mMkkrbWxPcjRweVFOQ1o4Wkpxd25m?=
 =?utf-8?B?N3huRlEvV2NlWVRvSzNINTFEZmwvNFFYVXE1czZybFRhUnN2SXFHZ0ovM0JM?=
 =?utf-8?B?dG5SV09EYjFSREVaaWJ1WFRnSWV0VzQxMTJrZDhDMmptY0tUQXY4MzdpSlE2?=
 =?utf-8?B?NTQ0OTc0M3VhTmIxNm1vdWtUYStISUhraEhCanJUY29EOWNWWlpRWEdBd1ds?=
 =?utf-8?B?U0NKVU05aXFkSzBIeFJNYldEMy9uWmRPc2djcjJCNGNLcUNrTUlkQ0FQL0Zs?=
 =?utf-8?B?SUFEVjM5b3NVUzQxbEk1NEZCZ3E3T05TOE1YbXNrUzV4MDFXZ3QvVG42RExF?=
 =?utf-8?B?U2RYNFdWUTB1ZnJlNFNGVFI2NGt0aFM5cFJpOUJyNnpLU1dZVkVvbC83T0Fa?=
 =?utf-8?B?MDJKdlFPbDhaQ0tTd3NTbjQvSHErZXdvSkdxTW1mclBUUnNLbFdaWmVtMGo0?=
 =?utf-8?B?VE9xamZHcmx5Y2dwWlF3azgrWXJKTjhBVWNUazBWR1ZlVEkzVk9RVWplVkVU?=
 =?utf-8?B?cGtvblZDdlFvR2pkWlRPd2RXU1pMM2ZWUmNyNkt3L3pTVjNTRG1DY0lrSXgv?=
 =?utf-8?B?UldpSitVemtHY2k5UzhlN1IwQW5KWVlvbDh1MU9DazV5K0l2Y2d2ZW4zSjZu?=
 =?utf-8?B?Qjk2ank4TjhDeHprWWlNMTNyVzl0Zm5uTXkyNUdTblVxRUpmYjM2ZGx4WWNz?=
 =?utf-8?B?c0NEalY4a1lmZkprcjI4TzdLSGQ5SDFveXBzMVdwOENIaitxaklsdGdiTWhm?=
 =?utf-8?B?b3QzZUVMWjg2WGE5bnZLT0VpM1FuU0QrL0MrM2FxL2Q2d1NXTGpNNUZLOWFD?=
 =?utf-8?B?UjJlZFZSK0R6dWZBTHFybXJ4N3dJWUpadzFSVmRWZWNSMXR1SStpMXV5UUds?=
 =?utf-8?B?S2tRTkd5dUc4bUlHUnl3WC9aYU5pUnppVHpZZWt0QlNIVDhEZVpMOXJHZ0t5?=
 =?utf-8?B?RmJ2SnFCK3c3bTRFNTVvWm1xVk1UYVFjOU85WlUxdUg1MzRncjdDVjE2K05W?=
 =?utf-8?B?dXArNUFXZVA2T3RvNGJpR0N1UG1CdVJwTEVHckpybGlURHlyb2N5Q0JWam1l?=
 =?utf-8?B?b3lpRlpHYnRyanBzanpGa2ljMXE4UGVzNW5OaG9uQXhHWlU1NXFIdm9GOFdH?=
 =?utf-8?B?WElkZE8yYUhYUC9YT0l5U1p6TlQxRU01eVJ6VVVTcDM3SnNITUVuMms1VnFF?=
 =?utf-8?B?SHNQTWJnK3BCQmcwUjZEcEpNdUYrdnpsRTNrUzdBT2sxTVBldmJHQWQySlFU?=
 =?utf-8?Q?ji60V5flaB+mo9m4AvAhVe3Ps?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60111daf-1a6d-4802-d308-08dadb6c67a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:39:47.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orTfMC06A92m9jsD1vwhVAkJXBvKfMnhbbvuf6FrNTlnDAbVJsBVFx+o5mDu0VHuwEYJi7mefnoxMu0jbtnMYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/2022 10:08 PM, Jason Gunthorpe wrote:
> On Wed, Dec 07, 2022 at 07:33:33PM +0100, Christoph Hellwig wrote:
>> On Wed, Dec 07, 2022 at 01:31:44PM -0400, Jason Gunthorpe wrote:
>>>> Sorry, I meant VF.  Your continued using of SR-IOV teminology now keeps
>>>> confusing my mind so much that I start mistyping things.
>>> Well, what words do you want to use?
>> The same I've used through this whole thread:  controlling and
>> controlled function.
>>
>>> So I don't think I've learned anything more about your objection.
>>>
>>> "fundamentally broken" doesn't help
>> The objection is that:
>>
>>   - in hardware fundamentally only the controlling funtion can
>>     control live migration features on the controlled function,
>>     because the controlled function is assigned to a VM which has
>>     control over it.
> Yes
>
> However hisilicon managed to do their implementation without this, or
> rather you could say their "controlling function" is a single MMIO BAR
> page in their PCI VF and their "controlled function" is the rest of
> the PCI VF.
>
>>   - for the same reason there is no portable way to even find
>>     the controlling function from a controlled function, unless
>>     you want to equate PF = controlling and VF = controlled,
>>     and even that breaks down in some corner cases
> As you say, the kernel must know the relationship between
> controlling->controlled. Nothing else is sane.
>
> If the kernel knows this information then we can find a way for the
> vfio_device to have pointers to both controlling and controlled
> objects. I have a suggestion below.
>
>>   - if you want to control live migration from the controlled
>>     VM you need a new vfio subdriver for a function that has
>>     absolutely no new functionality itself related to live
>>     migration (quirks for bugs excepted).
> I see it differently, the VFIO driver *is* the live migration
> driver. Look at all the drivers that have come through and they are
> 99% live migration code. They have, IMHO, properly split the live
> migration concern out of their controlling/PF driver and placed it in
> the "VFIO live migration driver".
>
> We've done a pretty good job of allowing the VFIO live migration
> driver to pretty much just focus on live migration stuff and delegate
> the VFIO part to library code.
>
> Excepting quirks and bugs sounds nice, except we actually can't ignore
> them. Having all the VFIO capabilities is exactly how we are fixing
> the quirks and bugs in the first place, and I don't see your vision
> how we can continue to do that if we split all the live migration code
> into yet another subsystem.
>
> For instance how do I trap FLR like mlx5 must do if the
> drivers/live_migration code cannot intercept the FLR VFIO ioctl?
>
> How do I mangle and share the BAR like hisilicon does?
>
> Which is really why this is in VFIO in the first place. It actually is
> coupled in practice, if not in theory.
>
>> So by this architecture you build a convoluted mess where you need
>> tons of vfio subdrivers that mostly just talk to the driver for the
>> controlling function, which they can't even sanely discover.  That's
>> what I keep calling fundamentally broken.
> The VFIO live migration drivers will look basically the same if you
> put them under drivers/live_migration. This cannot be considered a
> "convoluted mess" as splitting things by subsystem is best-practice,
> AFAIK.
>
> If we accept that drivers/vfio can be the "live migration subsystem"
> then lets go all the way and have the controlling driver to call
> vfio_device_group_register() to create the VFIO char device for the
> controlled function.
>
> This solves the "sanely discover" problem because of course the
> controlling function driver knows what the controlled function is and
> it can acquire both functions before it calls
> vfio_device_group_register().
>
> This is actually what I want to do anyhow for SIOV-like functions and
> VFIO. Doing it for PCI VFs (or related PFs) is very nice symmetry. I
> really dislike that our current SRIOV model in Linux forces the VF to
> instantly exist without a chance for the controlling driver to
> provision it.
>
> We have some challenges on how to do this in the kernel, but I think
> we can overcome them. VFIO is ready for this thanks to all the
> restructuring work we already did.
>
> I'd really like to get away from VFIO having to do all this crazy
> sysfs crap to activate its driver. I think there is a lot of appeal to
> having, say, a nvmecli command that just commands the controlling
> driver to provision a function, enable live migration, configure it
> and then make it visible via VFIO. The same API regardless if the
> underlying controlled function technology is PF/VF/SIOV.
>
> At least we have been very interested in doing that for networking
> devices.
>
> Jason

Jason/Christoph,

As I mentioned earlier we have 2 orthogonal paths here: implementation 
and SPEC. They are for some reason mixed in this discussion.

I've tried to understand some SPEC related issues that were raised here, 
that if we fix them - the implementation will be possible and all the 
VFIO efforts we did can be re-used.

In high level I think that for the SPEC:

1. Need to define a concept of a "virtual subsystem". A primary 
controller will be able to create a virtual subsystem. Inside this 
subsystem the primary controller will be the master ("the controlling") 
of the migration process. It will also be able to add secondary 
controllers to this virtual subsystem and assign "virtual controller ID" 
to it.
something like:
- nvme virtual_subsys_create --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1" 
--dev_vcid = 1
- nvme virtual_subsys_add --dev=/dev/nvme1 --virtual_nqn="my_v_nqn_1" 
--secondary_dev=/dev/nvme2 --secondary_dev_vcid=20

2. Now the primary controller have a list of ctrls inside it's virtual 
subsystem for migration. It has handle to it that doesn't go away after 
binding the controlled function to VFIO.

3. Same virtual subsystem should be created in the destination hypervisor.

4. Now, migration process starts using the VFIO uAPI - we will get to a 
point that VFIO driver of the controlled function needs to ask the 
controlling function to send admin commands to manage the migration process.
     How to do it ? implementation detail. We can set a pointer in 
pci_dev/dev structures or we can ask 
nvme_migration_handle_get(controlled_function) or NVMe can expose API's 
dedicated to migration nvme_state_save(controlled_function).


When creating a virtual subsystem and adding controllers to it, we can 
control any leakage or narrow some functionality that make migration 
impossible. This can be using more admin commands for example.
After the migration process is over, one can remove the secondary 
controller from the virtual subsystem and re-use it.

WDYT ?

