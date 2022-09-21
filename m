Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89BE5E5699
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIUXKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 19:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiIUXJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 19:09:59 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A96E83F35
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKCtAGEoitP5pBfaFn6qC+kb97YRxrN3ud+vPBq/cHI2M1p4X2ESUHMSJcWr8ntB/XmW68rP6orI8nijvQk+aRnMVw8u4ScBOgpMUjJCHtvODGn/XXnHNHtojIyMkuWNk4u5QeSsdO6Wn7PIFh7onjQ5o+fG5X4YjWZ/SHkjICY+8Qf0tTxzOSG0eTW/VUZ1GbhF4c9/uILvN5CFsC/Xqcl9d+Sycg7+eF2AaRDGCojU7Hdd7MEmgXasZrqmwMDNNnaYq79PHzO9fNPJtgnv9iG47c+1nQS1fLC3mZlSLxRRb7nAlSwQ10psln9XSjiRxYX1xIKMCE6tlRpwLMrx1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKUMu79L2qUpJ36/XQiBpn+GBUQXNkRafJWiZ9A8PxQ=;
 b=j4TQCk/D+LJXqc/S/PL1tEieC9iSXUM2oBsr9LFmMPSV+iR+FrcDaAi1+U2/HLLpYX4hK6hEoRBbEpd1Tb+Fl75GcuJqWEjOkC5XeopT+pAKhwGlEj2puDk+TM3qc0zX07X3NhJD36Fv/wzOyzV9JCDIoBFdbGtwxtKZ1lE7hVXjccHFShd5xC9Bl/dpkcSuSB5dPimaTsuXjgmOUMDQc6YgsLHU7swrHDwTb2DL8j/V8/mwCcesm60sZznMkVlYg8o25IRrpvlnecxpMPhDf/19zhxgGrqpqkkoPWP4ObPstL6bUAckk65gJK7Y7YkwdAtNfkm3t58h3KgpqRfDVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKUMu79L2qUpJ36/XQiBpn+GBUQXNkRafJWiZ9A8PxQ=;
 b=gZgdkgux2JEvAC1sT37ZFFEOWir1Kor4BDMZCnM/tgXijKPS3+S2cR0USrWgc5kYgtrGHPu2MtlwVipQAbVz+PEToRHpcKpgIQqeXPl89v2muQEKGn4Wyd1BuIIJ1kv8n4IO74dgmnmY/61zDne5j2uEbJTDiALX8azRJHC5En9sZ0uqjJzXC+pz5nuY1BgaZGDwXiExVVChrKeBjOskDeMFnN3sJCQSCMlbQhtJ0qzMTZUSBeTuyUy+K1/Mm7GJ1hS1uEFE4SbESudPIrkLul/V6h6bMJP5KWQmM0Erk6ZfzZ/3NfgF6CH0QJn2+myGNj8eeq+wss4HB2j9gFWceg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 21 Sep
 2022 23:09:56 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 23:09:55 +0000
Date:   Wed, 21 Sep 2022 20:09:54 -0300
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
Message-ID: <YyuZwnksf70lj84L@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
X-ClientProxiedBy: MN2PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::15) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: fa39726f-f286-4fbf-b269-08da9c2665b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGJuP21e//YnIiRG3Sb9+viFPZCmeVdR+Epb0XSD5ENTZRRW1F4gy+OfDyUive3mrMRFl895BdGcrPxDS30Fj/WPnBHubJhuHo7TrmIs0ehzT6qx5koNfGIfFKDsC4H3GhJNq+BEmLp8/rvw3pckHiiT8ItyfdtN3KbkWJ+To9BysQ+fpsHth8ksdzvTXGyOd+znVuNXHnuN1RlRR/fBvTC0Z5x7NSBzz5pKcaXzemULrZr2VkaVOaT1fT+kE61GIORcJ9j5eLo+aGuEC2GYinA9JvMbn0gOGa3ugjbMqh84ZPFIoAMMTLAySYAYKSPE9Lx0w9dtBLXCWvbCSIgWBSNft6/UJxQSfO8s1Jvx1SJOjubBsAqwL4WLnTikIWeL9pFyJg12wpV/M6pHEudug8I28a3P6DqYcZWP4kpJE/Z1HZ2Stj6O27mOjPgoUhdwGn5eHQ3uqYvv7VEtU7qXJUaYkUnaJLjbNvFRvGAxRsMpy/e/EOjUeWmi93Qed4FonPvlKWAUUTsgGTk9ENA8rINYI6VbakX3/8QAKdYS6TUauZu4U22LGJBWwFo4DzcQ9MryAbuWd1zzX/EYhSwQMOim8Uaa8jjj4bVvHju9AwHsSVcrYkNjI0EpJaiKjFS2Hpdvqsr+35uccv9eMPwgX1Pbi3RnEVSm+2rlUrGPfdmpIlVsG+XIIsrP2oCzgz7MdPE5frN8NC+ikon/p8WzDelb5egboAsZjj6NRh9a7MsyTlOx3rdMPyT/Tn+Q/vU5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199015)(6916009)(54906003)(316002)(4326008)(86362001)(36756003)(7416002)(2616005)(38100700002)(6486002)(66476007)(6506007)(478600001)(66556008)(186003)(8676002)(26005)(41300700001)(66946007)(6512007)(8936002)(5660300002)(83380400001)(2906002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krTl8twl2sK9wyC11eOSP9uQIHZSKBPEQb264q/uPYPBQIfjGJz/Ik3byq/v?=
 =?us-ascii?Q?j05C6JDwdrYP3CPo9kk8s6B4SP9APlPQgrsSKOBb9aaX3+DRM2+sv0P9oeBZ?=
 =?us-ascii?Q?U5BoQnYz0wuoxF3p+xZOoN0cQa2h7VVyA5qCTYzzSVdbwCdVtsoKLjU3X6om?=
 =?us-ascii?Q?c/v6//Yh8Eq/nbDpDHaShfKKZtzy2Su+8V18j7n+V0QnJNwZhiKxuCjwfZLx?=
 =?us-ascii?Q?+H+1Sxi7qc5Bu82yHLNe9T2dTgn9Hxg79+JSGDwDR3h1SsIPJxI8fe9Anxg3?=
 =?us-ascii?Q?BujBZJMJw0/xScDCtPtGiYLhY7S9SmW7GkpghW0ecPV/0wZpVoWviqDy29HE?=
 =?us-ascii?Q?jDGFLV/FMPmg56UojJPf1wpvRkoYNJpVnsNQGCErQbQPuLLGczW96sI6urNl?=
 =?us-ascii?Q?yFTyMWUSTcXqC9JjeSGydWKx8yAk8piHjBVtilV6M7Zg97phSzWMEVh8Fc/S?=
 =?us-ascii?Q?g+LEo+COHgV+ocoK4/wXJLSxzgMte/Cn2IJfQOk4yYmYuwkCrqm1eyHFUhym?=
 =?us-ascii?Q?aumPlX7O8IDgYDmR1uJjY7Yg25KN3n0MKJlfHblQfbgJ4LuINluhu/VzEl7w?=
 =?us-ascii?Q?PYzh+d7R7rw+rRXp9xUlZzjpunccstIgPuRQLQlgjgHkhOFNl7afGCyD9ToD?=
 =?us-ascii?Q?LVFDybD4eHiIjpBUgpATvb6f3JuavXGMS90a3LVwPatwYPu+uFuMDMIosM8d?=
 =?us-ascii?Q?Xbwj/ltwp9SCb+ensqhrygTXL0vCV7wdT4qOsW6K/y1zrVP8DS4+ZW/e2aLP?=
 =?us-ascii?Q?6iFze5A68CY8nAvXtY99vfB7FxzaWvJ4+y1oAias/FzHWkYqzCRmELd5EDzg?=
 =?us-ascii?Q?oQG4oDVzMxqmo4qvaDsoEvXE93TivCYzfn9dW3hYoBoBo+a6eYtj2HuThT1h?=
 =?us-ascii?Q?vxdJraxZ0fWytnWnLgGs40+9amCbvB3cLmY20PKAcwYgsNG2SzJPUN09c/b/?=
 =?us-ascii?Q?T2gzTm52rPfR7+dFp5xD455mp42UUZWGvk/0uNWuTeNYpyrMuWFn4yCnJRdE?=
 =?us-ascii?Q?31p/DOYM5TFVgJIByV4OzxyQS908k4+ym+xyC97nN14rUQO3YYqC8CdBTQoZ?=
 =?us-ascii?Q?xhdTuz5OM3DlpxSrmczj2LK5SNb3WeEq3xvVBp1n81bMV2aHIv8GI298xUDx?=
 =?us-ascii?Q?2w1GKuQPYUFewENGWjAPnwzB4sOqa+hXETaozAXQjRq1mRDJYkSaWN/qOWef?=
 =?us-ascii?Q?vURcVXl3h30xwPfZeL9Qvk0VbGayqoBp/tLWyxrmBq3SRYpyzsydgNs/KBIl?=
 =?us-ascii?Q?oeeB1T53UsYqz6kY5OC6GVGA6DQtOgaFEs8xjnpk9obY7goif9UUJie11kcL?=
 =?us-ascii?Q?dLxrrE4UJGZFKtUF/rX99lduYMhsnbZzt+sFpUCWFQPImtVMcDCrsSTxws0P?=
 =?us-ascii?Q?GWp+WE5Q6NI5/p06hMqYr2gdfuxFFvImjKPKGjatP9GzdrFFm5ReX8/p3T++?=
 =?us-ascii?Q?HRkEj1XI2xbl9ggW5rU6mqSIuUbH1Eyw0xANzjKGGLh246CS/7BaxWiXFozh?=
 =?us-ascii?Q?DmD3+nURjqM5S/E3UI/SzESAzvv5YPD6WnlVWgK7O56Jw5ZBxerRLoFuGFeR?=
 =?us-ascii?Q?HHGNix5/ao055eTXMKTiHRLtF97lHP6COHI7pklK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa39726f-f286-4fbf-b269-08da9c2665b2
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 23:09:55.7433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f0BtUOJWs+NVnqKw+/HGRxy+Ab8RGpOaNg3C+LS25vU9GEdRhAVmN+EjLfkXKaBr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 03:30:55PM -0400, Steven Sistare wrote:

> > If Steve wants to keep it then someone needs to fix the deadlock in
> > the vfio implementation before any userspace starts to appear. 
> 
> The only VFIO_DMA_UNMAP_FLAG_VADDR issue I am aware of is broken pinned accounting
> across exec, which can result in mm->locked_vm becoming negative. I have several 
> fixes, but none result in limits being reached at exactly the same time as before --
> the same general issue being discussed for iommufd.  I am still thinking about it.

Oh, yeah, I noticed this was all busted up too.

> I am not aware of a deadlock problem.  Please elaborate or point me to an
> email thread.

VFIO_DMA_UNMAP_FLAG_VADDR open codes a lock in the kernel where
userspace can tigger the lock to be taken and then returns to
userspace with the lock held.

Any scenario where a kernel thread hits that open-coded lock and then
userspace does-the-wrong-thing will deadlock the kernel.

For instance consider a mdev driver. We assert
VFIO_DMA_UNMAP_FLAG_VADDR, the mdev driver does a DMA in a workqueue
and becomes blocked on the now locked lock. Userspace then tries to
close the device FD.

FD closure will trigger device close and the VFIO core code
requirement is that mdev driver device teardown must halt all
concurrent threads touching vfio_device. Thus the mdev will try to
fence its workqeue and then deadlock - unable to flush/cancel a work
that is currently blocked on a lock held by userspace that will never
be unlocked.

This is just the first scenario that comes to mind. The approach to
give userspace control of a lock that kernel threads can become
blocked on is so completely sketchy it is a complete no-go in my
opinion. If I had seen it when it was posted I would have hard NAK'd
it.

My "full" solution in mind for iommufd is to pin all the memory upon
VFIO_DMA_UNMAP_FLAG_VADDR, so we can continue satisfy DMA requests
while the mm_struct is not available. But IMHO this is basically
useless for any actual user of mdevs.

The other option is to just exclude mdevs and fail the
VFIO_DMA_UNMAP_FLAG_VADDR if any are present, then prevent them from
becoming present while it is asserted. In this way we don't need to do
anything beyond a simple check as the iommu_domain is already fully
populated and pinned.

> > I can fix the deadlock in iommufd in a terrible expensive way, but
> > would rather we design a better interface if nobody is using it yet. I
> > advocate for passing the memfd to the kernel and use that as the page
> > provider, not a mm_struct.
> 
> memfd support alone is not sufficient.  Live update also supports guest ram
> backed by named shared memory.

By "memfd" I broadly mean whatever FD based storage you want to use:
shmem, hugetlbfs, whatever. Just not a mm_struct.

The point is we satisfy the page requests through the fd based object,
not through a vma in the mm_struct.

Jason
