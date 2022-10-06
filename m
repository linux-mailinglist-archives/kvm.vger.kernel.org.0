Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493935F6B1E
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJFQB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiJFQB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 12:01:56 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7733DAA3DE
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 09:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irqBLHPeEvhti856TgXJmpPU25p+ODn3KgbXgtLtZP9VXO3IoEfLBhTF6fA2zcBJG2nUyPbjBYtO31OE2JCCEvxI6bd4wP8pdgRUJ24iIod1bD2Uoi6eY9MChDNmpXYwrYvu+DAocFF/FuHBB5BctCWr2qre0LhOs/jRJ9G4wSc8DjraZ+IdDgqsyYpwVEBlNHtSm8plTiheMWsZcgI8H8Y2s9DzoPFSWFKaJ9IcOKGyGYtjyZK6aigAnEbbLigrBA5tQHzBbXE1yiUbdCdJ8wu78rmULXn3Rvbi8itI9SnU5QYUWsXPoljHIrWHydVuOJ2F+bVfXJeT89G5tinjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DauMvODYkYX9DS3NzNtRSIHq9N7KeB5ZSPFPPtpxqkE=;
 b=mHaQ4gG/FGM+PXsJHMnClLCGpMybp7p5MvX2Ol6zI2LPHV1rnL4vbUyeUeFaDw4CzdtMoGr8cIdRtIxpEvH0v5wfJGkBd+u2eraQhQMF4k3+zloh2gu774E3HEbZeGKH8NnQzYClmsMz4dMHV7nWifXo2CHCQgJ3lRZ/KnCw2rHeWOyqMgU24dZW01R3KXa3MftEKdusFQBqVlNKA0ZW4fN4/Qd1LGJnlHEn8s4tewNkexMonfBtamvQn/39CVnTSDehx1QSGuFou9c8TfR2QarfZKcacefgSlxqCT8XgC4pPaOruZqLSJ8PresuS48LgBxhfO7HmuV5nXBBX29rLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DauMvODYkYX9DS3NzNtRSIHq9N7KeB5ZSPFPPtpxqkE=;
 b=ZPfmYxkvPurj8dKYivZ9ZnlWwg3dyeeK787OhIGS3JPn23Ni+D5C0mERsUtmMnsXaLzSJzVzR8p/wkeUv6UOn8lvPfSzWw3Xd8FGap0iF7CA9KP1URSzRwYYCYuURsXJ93uj6Am8FO6VZR2dLW31HzJFN25jo7hfUnWhazJfb0Qq46UTHZ6ySCqwqBBtjyKTBtmn2qCSkM6/eGBl1mGXLnNw6Xhl+nCQXt1IRlNo2SLCZA7wPRqWvw+KP8zgb0pRG1BrP709sP50vkYLnBa0q41Em3kikRRWt9ncKtvNW4e2MpC1gEGAzMPuM2uwObY7jxz3hoGoRxPKUY88CKy86w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6928.namprd12.prod.outlook.com (2603:10b6:a03:483::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 16:01:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 16:01:50 +0000
Date:   Thu, 6 Oct 2022 13:01:49 -0300
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
Message-ID: <Yz777bJZjTyLrHEQ@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyuZwnksf70lj84L@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6928:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df6c8cb-01ba-4b28-531e-08daa7b4146d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: secbkF4T2RjPYlBPegzb25tkgqezAQ7Yarbi+cKyArlR5MKKNjJPY7bWjKXuwDNcOYDISis5oC3jBbs5d1LWxMpZBh8xP+7lnECEI6/V6QfiZ5dGs2XEZ8b8wLpG7bp4aS4WSdzfAxqZhK7QPYltBChgmSGXBAAJIRoosAwYVFJUVNPYtotFUdAgMmy3/56dARhw5piGjgyGp9rL4O5on52hyymerFyJhA6mkxQhKqlQh4u1tDX8SbvGBdB/LRBobi5oF+kiQ24ddQLflkrpg9RV3alq1uejxjLJOpzHTejJ+5AzItt51twsy5h4g9+1Eu2bQP+9ru5vaI3HuMEwkiRJSp4aDIqF9am8ZBZ3ZIjmUiPYhzNnz4Q2mlLfzv2nFXoro3kxsRNZv+uvlHMzJyVd3O9LdATjG0eByO12LFr5LCsnb/5aMnInOtDnGpNXmJmGQ7wXUIQws4UF5KPrTJkGL6d/anYyXshRxCtHDfMYuMqtRTMZeDKZpyBbQ29O1Mj4SuYyVq/QKT7VeDA5r1gsiKdkY3E7S7N24Cr8zhDlW7zatWpG7DKoLht43cwc2/hjnWkX74848oUyxL2w2w7Zf3etm+FvTcR27Lul530HuaPID0nRFZV5s1rPk+GNeUh9U9pi91aYmN1dTOpQgz0KdrwsuA2nh/VVk1O+DxffAsCx4F/rvDbUhs8LJf1aWXDB9FL8xnp4GEVeksunWssYbeW6N29MYtnDIWbQYYXNpM0oVkoAvq1iljxR4kM1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199015)(8936002)(5660300002)(83380400001)(2616005)(186003)(7416002)(6506007)(4326008)(6486002)(66946007)(26005)(36756003)(41300700001)(66556008)(66476007)(8676002)(54906003)(478600001)(38100700002)(6916009)(316002)(2906002)(86362001)(6512007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5kYwaY2QGDHI7m9KWHrmqywY4/MvUss2TZNzqLapWjavyduA5fQC/bjDZ90I?=
 =?us-ascii?Q?N0A5ck0r/56vXRacm/2vfCzhHoPTkythrwx6yGUy4dkeasR+jSrKlPOzXbm9?=
 =?us-ascii?Q?p2XFEMiRLkGHMSxeGtWSqzys23C8Hf6JCkPPMyaGzNc+28pQ0Vkl5gR7rjDz?=
 =?us-ascii?Q?lmf5SChyQETKMbP36vZ2wbLyuw/MvZOXDC1NAsAf/HinVKOSVh3txm6gGpTI?=
 =?us-ascii?Q?vm0Ms+B+w+L9J9dlpVTknMJTLgiLMCf2Lo55lUYQk0IwCtzoBwC3MpJ5onwE?=
 =?us-ascii?Q?Vm8QuexyOx3D4EQE9uqeSyvoIisNF/A4LL8q1jrwErTTalwuzxeelWUmXU+4?=
 =?us-ascii?Q?2uzKaQRz6+SmzPBAQXJlJoW4qLCFYdHgAVDUkfp/BgIyHZoisqWh7ZpboVhx?=
 =?us-ascii?Q?E5FKlzvigDQsPDwthtCbd/po/usn5T3h66MtImLBtLmAW8gYVfD7VBwA5nT/?=
 =?us-ascii?Q?ma5JIFFa5WlkJXVlsky57TpNFUVRnJs0ixAuxO1sKdfEhgKcwGx0P9VPxjri?=
 =?us-ascii?Q?dk2WiEWyylYSBbRWl1uxwyD89lmDPoj6yI4OlNtiJTPBP+d75AFygZxyACr+?=
 =?us-ascii?Q?upXU8tMqSOaeVaOtQXxA/2BPJMdHFAtjXrxrc9dRpy6C9RyqClkQj3zKD7eW?=
 =?us-ascii?Q?+sg/1bfnDMWZ6iHC+x5DOgGgy2qLKmkTluz9JWcGZSMG3qBV/9BDtNBoTEzH?=
 =?us-ascii?Q?k0IfBvW577HSZVsSE4Esi3tCUBZxzQIieyjJ2dkd1bXirDT/cOy0t7N3wgvT?=
 =?us-ascii?Q?FXr0a/RtuZYrP23AllBJzh216H090ODCs2zNeVBUfXG7AVADrEcJERT3dDZB?=
 =?us-ascii?Q?QUVWpFS8obW8PIMkVH5nbw6mFMbGDzARgXILm1n/hm4b+jm61n3hSvr6NfFB?=
 =?us-ascii?Q?fsqeHdmS7U9fPZ4PI4v6CG8SGJN8B+v5aPe7AG3ISviCw3c0d2Bhmf8zTbrQ?=
 =?us-ascii?Q?3rn3fYNyFJoq18K7SZ2izHS8q1IPtubEkO0qxtqBydvu5d0J5PyuutnCpQ9x?=
 =?us-ascii?Q?OGmWuVD7XZkHbeJNDtqpw4Q/tREr5I48xeNijXXAIDY4kpzgmY06gwLCMIcN?=
 =?us-ascii?Q?5XaI4o47r4XYigFnYp6QIVYC63I5O04JC/wC5ka/0XVncJGm3fHCt0w+l+Nn?=
 =?us-ascii?Q?Ga471E/tazTRHrZUS3ScXlwAycCb9GxBaRwNz3/OkI8jvo9+0jP9I3E+WT8Z?=
 =?us-ascii?Q?x44DbmFlfN2I/J0rWMKxO3Jh4drB+NjY7sAFcVUpdv2WDGpiCleVCW3QPbLq?=
 =?us-ascii?Q?h2GRBGGChWScbrUFy+heYALhZ7xUyh2OzzQZsrTInaQEsYSpWUpxGSglM6kU?=
 =?us-ascii?Q?mAXAPiycafiPX/omqlduHRzLmC7P9EW8QJY/Vdlzz3We88+iVYUJf/gEQmgi?=
 =?us-ascii?Q?ONEkqw4vHAeYUbMYylwR+gkyfep+b4ylLK5DW2AFwGxB/dBHTp3NtNJitQ/e?=
 =?us-ascii?Q?F+QmKe+bmRbcM+JFNsowWg75zzUHqWWwcbGWGZWi+tzR0TXTxCwW5FnRB6jX?=
 =?us-ascii?Q?I/xRLRD6sQEIDTkjLGykzGBKYuEp7U2t8u5hi7Lppr9c1un81u8CU2Yoodrg?=
 =?us-ascii?Q?tOUm6jNoBf9eE1W8zEw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df6c8cb-01ba-4b28-531e-08daa7b4146d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 16:01:50.6257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2r+Sdli9nbTtHolUve3QBA1lxss50FQ8vXqGNqZJKzZuJrZEsuwK+5Zfc8mnIqU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6928
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 08:09:54PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 21, 2022 at 03:30:55PM -0400, Steven Sistare wrote:
> 
> > > If Steve wants to keep it then someone needs to fix the deadlock in
> > > the vfio implementation before any userspace starts to appear. 
> > 
> > The only VFIO_DMA_UNMAP_FLAG_VADDR issue I am aware of is broken pinned accounting
> > across exec, which can result in mm->locked_vm becoming negative. I have several 
> > fixes, but none result in limits being reached at exactly the same time as before --
> > the same general issue being discussed for iommufd.  I am still thinking about it.
> 
> Oh, yeah, I noticed this was all busted up too.
> 
> > I am not aware of a deadlock problem.  Please elaborate or point me to an
> > email thread.
> 
> VFIO_DMA_UNMAP_FLAG_VADDR open codes a lock in the kernel where
> userspace can tigger the lock to be taken and then returns to
> userspace with the lock held.
> 
> Any scenario where a kernel thread hits that open-coded lock and then
> userspace does-the-wrong-thing will deadlock the kernel.
> 
> For instance consider a mdev driver. We assert
> VFIO_DMA_UNMAP_FLAG_VADDR, the mdev driver does a DMA in a workqueue
> and becomes blocked on the now locked lock. Userspace then tries to
> close the device FD.
> 
> FD closure will trigger device close and the VFIO core code
> requirement is that mdev driver device teardown must halt all
> concurrent threads touching vfio_device. Thus the mdev will try to
> fence its workqeue and then deadlock - unable to flush/cancel a work
> that is currently blocked on a lock held by userspace that will never
> be unlocked.
> 
> This is just the first scenario that comes to mind. The approach to
> give userspace control of a lock that kernel threads can become
> blocked on is so completely sketchy it is a complete no-go in my
> opinion. If I had seen it when it was posted I would have hard NAK'd
> it.
> 
> My "full" solution in mind for iommufd is to pin all the memory upon
> VFIO_DMA_UNMAP_FLAG_VADDR, so we can continue satisfy DMA requests
> while the mm_struct is not available. But IMHO this is basically
> useless for any actual user of mdevs.
> 
> The other option is to just exclude mdevs and fail the
> VFIO_DMA_UNMAP_FLAG_VADDR if any are present, then prevent them from
> becoming present while it is asserted. In this way we don't need to do
> anything beyond a simple check as the iommu_domain is already fully
> populated and pinned.

Do we have a solution to this?

If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR

Aside from the approach to use the FD, another idea is to just use
fork.

qemu would do something like

 .. stop all container ioctl activity ..
 fork()
    ioctl(CHANGE_MM) // switch all maps to this mm
    .. signal parent.. 
    .. wait parent..
    exit(0)
 .. wait child ..
 exec()
 ioctl(CHANGE_MM) // switch all maps to this mm
 ..signal child..
 waitpid(childpid)

This way the kernel is never left without a page provider for the
maps, the dummy mm_struct belonging to the fork will serve that role
for the gap.

And the above is only required if we have mdevs, so we could imagine
userspace optimizing it away for, eg vfio-pci only cases.

It is not as efficient as using a FD backing, but this is super easy
to implement in the kernel.

Jason
