Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B4536EF55
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 20:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhD2SOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 14:14:38 -0400
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:43585
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233578AbhD2SOh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 14:14:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRSXR/kn7tA2WIb943VoDxigToX40CtMWwKJ8FlZBIeL4y2BUCVH3vzUA5vi3zQiK44k0mE4pVxoJl0Y/AbFLJEiLXBpW/hqS6aFQf1qDRv43kJBBMaEJFcSnwRQehUs33i3INBG2ZAplnRVQolm//nmp51Ws4YOKKQqqgdLDaUu37+wZkudDhsHULfK60tFx84V16X9jpn26cyReTtQAcAFH8MofCJnU/KY/sl52tQ+OtszUxNOh3mkqBkmddQt+L2WW/fFUjzEBZizAU3a3Cit3ulc77kNgI6jXQYT8BY4jTrRGe6OEgzcP6BmDU94h+pglTqqgTZenI7+FzB5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KCVSmacbaaA18cA3e0+XaUK5mPAxV0znstcPBPIdPs=;
 b=U3eQI+YCZ5lB+nM0JtoZUp79lHihn5R+TD3jJMFd9ACbzimFe+1+RQrc1nS5xpD5+rLP1dFOITM8g0xZxVYCMWSET+Hl+z8wo2823kpPoDFLQ1SWzFwdNYYqXJCuX4/dsaN2LFLXQZbE9P9C7Vp7CPeZW58dZZwHkPe+2YEQTd/+tEFSqQ0xw1Dr6IE0XL3UQm+nRoXbJRpsWUNxdJlAYyEDsxydJS/0C8KtYvForXIMq0wy3TggSp010SOR1QuS1a4N4AskPxV9Iw7Xywhuc1PpR0umrEZ7Fi1qPk9XgyqrXrwMgobFq7Maivo+psOb40acYS69oDhDuu3Lc0Svsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KCVSmacbaaA18cA3e0+XaUK5mPAxV0znstcPBPIdPs=;
 b=EFP4EzTJxdTPx4LUfuxZFmEriUrrc1KfiIVVrKm5s2DZes+bOhcKF52TbMFGzN/uIeTmc+PmvQ+6wCMrAbBRFT0Ekl9YLsogCOpTOW2QdzCB0g63LjeuT7wBgkNta6/3yZneT3r65Ay3tVxayFTie6gA2NSCRDrfaTU6PkM6IYIsbqdNMNvzzpYiE3m+VFHXtjh03267NrLZYJqPh4Jol6uXvs7jxvk4CMzBMMP6u/QLG09BYwnRha7V0jHmakV54y6SP7ouBXrCRvJbyHOMhYGDZ88gIcxe2L7ksjeeW2t782PO1u3gKZKbqVVrTSt9XkJ0eCL/JovNxNSyDxifVw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1241.namprd12.prod.outlook.com (2603:10b6:3:72::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Thu, 29 Apr
 2021 18:13:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 18:13:49 +0000
Date:   Thu, 29 Apr 2021 15:13:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210429181347.GA3414759@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
 <20210428172008.GV1370958@nvidia.com>
 <20210429135855.443b7a1b.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429135855.443b7a1b.cohuck@redhat.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0266.namprd03.prod.outlook.com
 (2603:10b6:610:e5::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0266.namprd03.prod.outlook.com (2603:10b6:610:e5::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Thu, 29 Apr 2021 18:13:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lcBAZ-00EQ7i-Oi; Thu, 29 Apr 2021 15:13:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8db6699-962e-4422-58b2-08d90b3a8953
X-MS-TrafficTypeDiagnostic: DM5PR12MB1241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12419B220879607F4CCAF4C8C25F9@DM5PR12MB1241.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSm8sKgnUxzvYerOpiaEbAadvjjGZUmNJu09tC3XIyaZE/O82wwRKG+3HVWH51RKawrW7wn3CgMeWBPQZmCfGhHan84asyjQeCcDRgNpHDvvutiD6mk8CuCqK1rEuR2owFb71nBAJ1d+IXPdOg779PAdhFitTwz+Ntu2UWnAw6OU1nI3+pyW+lg+c9h4FIBQIjlGsKWrz0gSFNfMLTJLMtad+lDIwnjssvf27Pc8o5hvDayPwRPVteifWOOOcXQCQVFUuBCsXttHXmR5d0lNcGpaDq9Y1eZ1O4nCkvIeiGKgZb2fCklky7MC342oAI5ATZVenu/NdA+/KOoZD3qsaBCOaOW/h/3u/LIPCNUeZW1TSY/f4pb/1xOcwZKRjxYbDX+goddysXDlwtMzmkgRScq6qNRknwfh1u8KbjRjz2EbfBHWbRcLKOVuaC2ylCsM5oNh5tmwUX/2J/Z4k34ZMPGuHic9buDlCX/n7hp2LzTvwAdvpLGqIuXknTarSF01PrCcI6RvN7sLdSAJMLHlfowitzQ9V4/msXALEcNkj3KQSFoh9j2yxme51DOpf78Cm5PXfE1DRSyaynvQ6XZXXJW2mBEbJeEuOulC77cAzDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39840400004)(346002)(136003)(396003)(1076003)(38100700002)(36756003)(9746002)(8936002)(33656002)(316002)(66946007)(7416002)(107886003)(4326008)(66556008)(2616005)(54906003)(426003)(5660300002)(6916009)(26005)(86362001)(66476007)(478600001)(9786002)(83380400001)(2906002)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZS2JKK13uuqB4szSJO0R9DMI09LSNj3Qin3Hn2emba0XyaY4t5S59LNHAnp+?=
 =?us-ascii?Q?m09lkrzuKihzbPUi6icFZngqbKCb9a2OR6bTZcWw91ZBX7dTVldUJVMmPbGl?=
 =?us-ascii?Q?nf5M82wY+0ejwT6cnZoG6bndCMgJCEXAUDtoBjMgfvZWGCjlEoPosl62/KhU?=
 =?us-ascii?Q?lxQu2Np6miIoFXm1fK/vloXpbOml8YJBWpul6Zn5ScIyFg/TmpyPgIH9ldvB?=
 =?us-ascii?Q?n4jZSbEwMq14xGJrxpKL+25txQGUbk5Zpl44eDdmuXgOe9ozrTyZSEFh6TOt?=
 =?us-ascii?Q?Rr/gtOxzIPQWd9fgSLjeXVsCtfgErzbArLH3yIC4GLnuwwAlZ7lm2azfBYkc?=
 =?us-ascii?Q?WPDLwROh6KnAoqTnX4vplO2Qr10h56BL3H7Xonjc4b3nBuvMqiT3JGb4btM/?=
 =?us-ascii?Q?xFlmKmF7U2JY0euiEStek0Wnn/0go4uS6dUjFTKIkjnzL4geP7FTxOIagBBA?=
 =?us-ascii?Q?WhxyPFiJHkm2HZpL3WaWIFgFVBFfleThbBv1zd3x7HctiDEtYtRajzPDd6c5?=
 =?us-ascii?Q?koh6rSQP2W/v9sM0aPI/j8mRuHyjHR2WhJ98wrrt8gj1LsltiOe3SvGVskS+?=
 =?us-ascii?Q?cMNW4ny7cejDwMBxaOSvH1QxtrrOijOR2/bmg6BWsFfwuQxmGdqRSaKiQcIs?=
 =?us-ascii?Q?lKLGqZnG3FH4Q4pelAeJ8jmsvio/qxg9BKO10v5Dg+8rguZ5lu8wPTRrlWL4?=
 =?us-ascii?Q?gFsWHzBx28I/t3xX7yrkA8a1sQrffUHK5w3KRVcy3xCH2Bemd1RTSUhucDBX?=
 =?us-ascii?Q?Tnv8+ryoiK5sSNRh+/J2EMWbQi7k3FQ4CstkFAaLBa+wqrnsxT5CxMnbEPG4?=
 =?us-ascii?Q?4Dapu9uMoa8+KpJf8NWX8+kcN+6G8n5X9c1QvKirkx5on+q6N7D9DPGJFT8n?=
 =?us-ascii?Q?BZaslmR4kMO35t6w8VLw6BLEQmwRo+RgluQ/H0PUWW08QJY8eTp3EOhAju15?=
 =?us-ascii?Q?ikEP1sSh0UZCFQ26Jiq62LdlbKkmLrf1mFDYNQfxwN5rn0RYoyOQhjMGcCmA?=
 =?us-ascii?Q?KV6+jqZEJlyPPHh3n8ziXdf3VnBoB2Je59i99JVgB2arOkJd0UVTHL07pZtr?=
 =?us-ascii?Q?VymiLXhuCM0zOQCfRiFdMN2YTDw5AjCe7VhRE5fTCLeKnXfnMYDgWUTV3NjQ?=
 =?us-ascii?Q?19wZo/IGQwNZ6mjG4/Q/bliKO4A4mv/4zbWJ53b/T8cuB2x4ru2N83zQmcxe?=
 =?us-ascii?Q?+cQ/OkNL52ZOk8EiFj3hriL3kYZDoL+ptekFccaDNrAReZQs4WxR4yb1H4+U?=
 =?us-ascii?Q?kgp5C1+SQhpT2+g7LeIsMjiQz2qZUnWM8iREGNukUNnyUCP+t29rtuyznGQP?=
 =?us-ascii?Q?xnqnNXESe7jxjMNJEcL8rUyX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8db6699-962e-4422-58b2-08d90b3a8953
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2021 18:13:49.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqYfxNjn/hzhPx8ep+lX2DBDdQeE2MfevmWlRjgWL0YYSD8EI5w3JErVtc/GU2wG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1241
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 01:58:55PM +0200, Cornelia Huck wrote:

> > This seems like one of these cases where using the mdev GUID API
> > was not a great fit. The ccs_driver should have just directly
> > created a vfio_device and not gone into the mdev guid lifecycle
> > world.
> 
> I don't remember much of the discussion back then, but I don't think
> the explicit generation of devices was the part we needed, but rather
> some other kind of mediation -- probably iommu related, as subchannels
> don't have that concept on their own. Anyway, too late to change now.

The mdev part does three significant things:
 - Provide a lifecycle model based on sysfs and the GUIDs
 - Hackily inject itself into the VFIO IOMMU code as a special case
 - Force the creation of a unique iommu group as the group FD is
   mandatory to get the device FD.

This is why PASID is such a mess for mdev because it requires even
more special hacky stuff to link up the dummy IOMMU but still operate
within the iommu group of the parent device.

I can see an alternative arrangement using the /dev/ioasid idea that
is a lot less hacky and does not force the mdev guid lifecycle on
everyone that wants to create vfio_device.

> > I almost did this, but couldn't figure out how the lifetime of the
> > ccs_driver callbacks are working relative to the lifetime of the mdev
> > device since they also reach into these structs. Maybe they can't be
> > called for some css related reason?
> 
> Moving allocations to the mdev driver probe makes sense, I guess. We
> should also move enabling the subchannel to that point in time (I don't
> remember why we enable it in the css probe function, and can't think of
> a good reason for that; obviously needs to be paired with quiescing and
> disabling the subchannel in the mdev driver remove function); that
> leaves the uevent dance (which can hopefully also be removed, if some
> discussed changes are implemented in the common I/O layer) and fencing
> QDIO.
> 
> Regarding the other callbacks,
> - vfio_ccw_sch_irq should not be invoked if the subchannel is not
>   enabled; maybe log a message before returning for !private.
> - vfio_ccw_sch_remove should be able to return 0 for !private (nothing
>   to quiesce, if the subchannel is not enabled).
> - vfio_ccw_sch_shutdown has nothing to do for !private (same reason.)
> - In vfio_ccw_sch_event, we should either skip the fsm_event and the
>   state change for !private, or return 0 in that case.
> - vfio_ccw_chp_event already checks for !private. Not sure whether we
>   should try to update some control blocks and return -ENODEV if the
>   subchannel is not operational, but it's probably not needed.

All the checks for !private need some kind of locking. The driver core
model is that the 'struct device_driver' callbacks are all called
under the device_lock (this prevents the driver unbinding during the
callback). I didn't check if ccs does this or not..

So if we NULL drvdata under the device_lock everything can be
quite simple here.

Jason
