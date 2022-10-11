Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7477A5FB272
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 14:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJKMb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 08:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJKMav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 08:30:51 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03AB642E8
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 05:30:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RuC+wVxtCnbV3vT6gpJxIY3pTKliGiabbMEC6GI1Yujvh4+WZTvhyog7jEZEM+0WZ2f4eUemXT6iyERjVVplIpqe0Ggv6KtYQ9z2Qv7XjBKO07BBK1UtW6JG/xtkczVXRuBWKEnRVOnue7oNe2kSQtarCu8HI/P7R8OY1hzs80zMtR2a7yUWKEWZz/BbxuIJbb3i6EIdXt55oJpmewRn1yXjHxGO1VfjfeDnmIXqJAmMdcxhnbQS10P/Qy43cBKDr3/viRl1Iwh6gDGMAO2Vo0kLw97iu7uAj3T1St4wkfJEZiBSweghLL3tl/3Ky2NZHlfT3kNz75P5JDS9OQ/u5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIwTs5h6AqURjF8SCmPjybogRLgo1DKC621vzzeasa4=;
 b=lmmjFsdcqI09GSvwXqlIKcdGpwPRKq5w/4aAijcIUFDUhmvbSC6ixT/mI4UAKmZVzBEPgDUfiqGR4L22lXjt4wOjSkKPL7Wr80xpr5+jgji8SAC+F5Uh28Gz+/zFoWoudrIzz21yq869upNq7oNqIEo9+fUTSEAHreB21GOJ1B4mh/X6AyXtxjvezjyfvBrcS/LylMkZhWRigSxQkY6B3QAItKKbMpw+cC3PDgUdL4CubjnoIUWoQXPh6MowbWdlBen3EamgmOtYklmgFltM8TygOkCBo4wKAZBXsAllZB4rMkbB9qJ1lYxUV7d70UAkS+Vr88cKrtAWwmFeNCWLwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIwTs5h6AqURjF8SCmPjybogRLgo1DKC621vzzeasa4=;
 b=m8cUFw9h4NUeRFswvPS76Lqrka0SGEoy/POSwoEiBaqAi4gJcJ0NklX5wjYXC4i4Ohz0sRB/AMSW/kPmXQVOpDMVRMe/zIYft4u6Mrol2Bd/NpH+jiR+EAusuyIHqvOpyCJQlJLuNbEusPraAVmHNgtsjIQrcW+up48RWgEQE+PA8Uph9Z1OY7pJaKm+j1DkEDJN1B6jGWp4SXGWoHMOP13HGBDlf31mWXGQ6vrX/CbSuZOKUBIbxXgCptGLoNprqT51ZW+9KBlDsvCp+WoRvoTUcz/qTCyybbNqjkAcmY4WQaVbo9vHT4KHjKFBIf5B3F//prFJuGi9LxKRRnxghQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7557.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.35; Tue, 11 Oct
 2022 12:30:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Tue, 11 Oct 2022
 12:30:45 +0000
Date:   Tue, 11 Oct 2022 09:30:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Y0Vh868qUQPazQlr@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com>
 <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
X-ClientProxiedBy: MN2PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ff303b8-c79b-4a43-37a7-08daab846b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aK5xloj3wWg7Lj61NNe/suKyle2pnbgjhzWXBSwuRbZ/03394Jp92TJrNtTcgWlAMghqTfFnjCOvnRWUJNVs5j132TTo+inh+u8jlgYEYfbzhliPCAxP2elInefSaf7AWJByayNcSSKDxc4BB1g4igDFXd1I9JMuW0fdOBee1T/dWybV0R/mr/JrVYWOeSYv5p2b9O4jUACoq1FyK2E8UomsJlHICWjCB91Oxdzyg5Pj4eE8P1yO6OTmLOC/GOeco4B2lUJaXZsf+pXJClM2lPSH9hgZcF2LA0xfoR7LZzPtQazigauBw8dEctRJjnJfuOgFWclrfvURqIo57TheobrVDp6MLcPSrWWYmaNw9/BAcypppkYp8cgbqCotvw3C4VSULvo3nE2DZGqVHqEQnZc/EuVt3gsMmzFEb7lnm1BwChTlbYa2epJAF7ZF0+c24E0PiiMUG/IIVHvPlfSs1rcOpG0aw6c5KgGzgYzRYnNqJ/yphQriU8MTOpIhQH59JJiqE34xXaw2iRysMS4W0wggrOp83W3pHuaYPUbUF0CLvk4yNgprScYWvRW08pc01/ZqPd2GTphW+j8b3fp2dJXWTR2PuFXQYYE190ex2o4+4v7/g8pHlY+Kxdmxu5+dPgAQVcituPYr3Lq1xEz/GuD43VBdyG+N3YVdZGaA1/dn0toeinoCmYfwfzwXo4d9VkbwoA7+1UMwg3Y0uRoa7nQdAn1VKZ9kXcStCpWnLVfJ2f4iEypsQyWZcfOI7tym
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(86362001)(38100700002)(316002)(6916009)(478600001)(36756003)(54906003)(6486002)(8936002)(7416002)(5660300002)(66476007)(66946007)(66556008)(4326008)(2906002)(41300700001)(8676002)(83380400001)(6506007)(2616005)(6512007)(26005)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aMfF0nIaVoUWFoIteL+Q2Bius+311z3Cz/cluPVkZKPJj7t6IQbnfffPT2lP?=
 =?us-ascii?Q?JjUljI5qmWIe7hp4GTg++davk6Id1/yh7YWZtRvm1GvMzJCD7MzZNG+0pQHA?=
 =?us-ascii?Q?R69gqRNib3IDCyde736CTBVRVxOk82HwLeRt0oJyq0cjfct3TS+ECqIjFiuF?=
 =?us-ascii?Q?e6SBxE/tEvPu4Ve9i1IfsM5twNexzCicbD7BEbR5d7prJfcFgoXjWIrdmeUU?=
 =?us-ascii?Q?fGkVnG0LV2lo+ivhGA9Tt75+O+cKFITVCXKyIfiwGsTEM//W5ywaj5SMn3cm?=
 =?us-ascii?Q?G+U13jkpImPyITHLNu8/ST9Ydl3tFLYHBZ32D5YFtJrW1C9NlchXP9oUFslB?=
 =?us-ascii?Q?Hp3UESaW1sHcxiyvGNLenNyMP0pwhqzbcSOdTdUv9ZCMo41zT0aOKZ5lyBLo?=
 =?us-ascii?Q?dnl8J3KY3PxIZIquBT0DK+hZrPz0OwM4kT1ytbb3bwhvve0cOCvx5QXIm/OW?=
 =?us-ascii?Q?Y92/gw9TMi8w6VBJho/5WIX08nV0yQZJsa/GMAee9fvQ98IAOguVPWCRAGHm?=
 =?us-ascii?Q?k54ZD2LobXZTgYxV74vflqBTVRCgYUgiSetoDSl/AvhPimIgcuH6s+squsXl?=
 =?us-ascii?Q?sUk+Cr6kBCYElq5OSSCqJU30ex4iZdwtdXNwleNXYR3vo1tCDdHrG5Ekd/w4?=
 =?us-ascii?Q?L8ocv5WF7+EJ7ujm7KKB/fZQCG6EMXhAimIde6aMVSUBg4FOmi7L6emxadwu?=
 =?us-ascii?Q?/Q/Y6+EEBFICtqWFaGs6mpcX4zGCfbnqVLvzTm0fbU57VS4skcibqzVq3l02?=
 =?us-ascii?Q?+SlOwO0eYQE3LkVh768L28ma+/yDoBVW5BLwydlfn59+vfGPwUP59E5iDGB3?=
 =?us-ascii?Q?2+wogzhOZpAUiF138NNcPxxn9Mz3oGUmfGAp19lvVykSs2dKpn4hDLxFbFo5?=
 =?us-ascii?Q?N7BGZNiskmABu4OZDGyePincYRJTptxn1jgcaE7N8hXdOG72OwD1bc73evoy?=
 =?us-ascii?Q?ePdB8dgWtApENpuD1DTPS2fK5IF+fWEd07Sw+X3QT7IRUWygXEKJ1rcrYBF6?=
 =?us-ascii?Q?9nd8mA1aGURi9RRgrnvUafNOinQNR1kuj3TkDvEgD8ejEl2bHC4vFN/xLCEC?=
 =?us-ascii?Q?KXX0vPa8UR693P40dmDd7mJfdTzEXrKSur1pGGz7cXIZw9eVvf+FFt89OY3H?=
 =?us-ascii?Q?L5jBfxzfx1/Z8GmeTXc3piIk8JNanfY/K7iBn4wJv8cy5f1rwWB1v1RBW8Su?=
 =?us-ascii?Q?6vyOPM4g4ZOfIM4m5KN6SwjKis3UrwWAbAjmBXPbSGznPkF/K/0uZAGDAsYp?=
 =?us-ascii?Q?1vd5Ven0PR5Nh6QPu0LO49WGXTXkA1vwJ2LFlkw+8/w1nEH/7MqlfFyb1EP/?=
 =?us-ascii?Q?yUEDlkkkERs89EsikjDdlUMXt9sWmZa1/Io1c0opBOUQ1i+wDC4yVFWn9wYS?=
 =?us-ascii?Q?jTMa5OE1MchGAQp2JU0gGvKTv4xVsZR2GJYWxkDYpx9RQx0xCguv3dlT9hsv?=
 =?us-ascii?Q?8J9hxR63aIa7p6iz/t46msWUayryx6b9fcRmtR7CLIlVRHDVZzYHr/Iyg1ZC?=
 =?us-ascii?Q?dW8T55VkPjs+sNU3OmWPekcu2vb4cyD8NyKK+IPWvVElykHC9iVtcpOYRDga?=
 =?us-ascii?Q?52f0gi6qQB6tGWLlRUs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff303b8-c79b-4a43-37a7-08daab846b0d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 12:30:44.9063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKApZ/bS1BiZ7NQSF9eoLHSXbarDXYg0JgnGrSTKr3Y+vYtt8Txa4vW7GtalqdCe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 04:54:50PM -0400, Steven Sistare wrote:
> > Do we have a solution to this?
> > 
> > If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
> > 
> > Aside from the approach to use the FD, another idea is to just use
> > fork.
> > 
> > qemu would do something like
> > 
> >  .. stop all container ioctl activity ..
> >  fork()
> >     ioctl(CHANGE_MM) // switch all maps to this mm
> >     .. signal parent.. 
> >     .. wait parent..
> >     exit(0)
> >  .. wait child ..
> >  exec()
> >  ioctl(CHANGE_MM) // switch all maps to this mm
> >  ..signal child..
> >  waitpid(childpid)
> > 
> > This way the kernel is never left without a page provider for the
> > maps, the dummy mm_struct belonging to the fork will serve that role
> > for the gap.
> > 
> > And the above is only required if we have mdevs, so we could imagine
> > userspace optimizing it away for, eg vfio-pci only cases.
> > 
> > It is not as efficient as using a FD backing, but this is super easy
> > to implement in the kernel.
> 
> I propose to avoid deadlock for mediated devices as follows.  Currently, an
> mdev calling vfio_pin_pages blocks in vfio_wait while VFIO_DMA_UNMAP_FLAG_VADDR
> is asserted.
> 
>   * In vfio_wait, I will maintain a list of waiters, each list element
>     consisting of (task, mdev, close_flag=false).
> 
>   * When the vfio device descriptor is closed, vfio_device_fops_release
>     will notify the vfio_iommu driver, which will find the mdev on the waiters
>     list, set elem->close_flag=true, and call wake_up_process for the task.

This alone is not sufficient, the mdev driver can continue to
establish new mappings until it's close_device function
returns. Killing only existing mappings is racy.

I think you are focusing on the one issue I pointed at, as I said, I'm
sure there are more ways than just close to abuse this functionality
to deadlock the kernel.

I continue to prefer we remove it completely and do something more
robust. I suggested two options.

Jason
