Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15D739798B
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbhFAR6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 13:58:31 -0400
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:39431
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231331AbhFAR62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 13:58:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCs1lP5D1Z/aiSQl8pKyB9fyy6wKE8w5a2XXYnHnuTk+VHtvVqQHJYAbAvFb+RaLWBK+7bE+HUiKg1KJ+OZ/hdxMdvvEnXbE3y6SuJ2+aELIdKLl7T1JVvVNptoCOFV+s1P3TtkjlyYfSul47ykB8VFQhuUoxF4rdJ3JS0o8dmJn+MK0xHPm4kpflqd5HLLapiOnJ9rPVOhOg7YIGjF5j+OBYDvaaxBhNCvJdLImwMcOUiFKlYlK4yuMRn5u88fqUuPoOYtXD11paS3GuDTYYkpv5BKYxgkT5D1G74VYjWQ/iNiRGt9t2FiuT6sBbxyKKSTqOibgf7pBuqV/dzNzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqn1oB1oJ0AIQdc6LdudrbdLjcWNvzx4saNKRvdE/kY=;
 b=UwsmGKPDKq8wwPr7D9Skf1ANEu4jLoIGAJnJyyu+fMQBUrQlf5CughDLzmjBfJ4zUd8sAcO7msCpyTOIefJWOErMbApmePF5o7MD6oalCtxVoG6bws10ZaCIQ68fADBxm+QM6glY7kGTV05x2mA4wX0LX9t8Bf3Tvemky21+lBIj/ytJbrfwkidy4gUvoYG2L+gQj+JEFPgB9dKN5SBL+xPReACcHJYniZJVJOKUVMCZq5MjjlmqByd57LqK3dreNkCbn/+SjlXJXHEWfQcACYWSSdwYXXqmvhMQIEBZM7zQZNQ+c02066Q1luLzGzx8BQ37yUxwzV5HlId86Yvg+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqn1oB1oJ0AIQdc6LdudrbdLjcWNvzx4saNKRvdE/kY=;
 b=gVvlLva+JzclUI5bHLzSICL7wo5lq4q7xE+U/rghmOIb2u3MpFCiX9lGMFCM7t8UDZr13V/ujAQpxjSWugFkturiJ42c/Z1yFIHIfWWfEoM6sU3oWB1f8r4oHFHUX3whuwUPsidfChuQXJuuX05aqEIVxJccMsGU7qvFfU0cIObtIjgXVqCzKuSn3xo4waoYePOHdZuU9yxoS7C8R1nII12bmKQt9LT+GCEfG9ud7UeYrG697FYr0sHWGmBBIfWsy4ajMdeMQ2GhsAGAvJS9oh2bb/jj/ATruVDNY951/BK9Ho82dpDmxNA0P1Z5xHNNJwKTXx0mUFSPlS9i2nuBaw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Tue, 1 Jun
 2021 17:56:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 17:56:45 +0000
Date:   Tue, 1 Jun 2021 14:56:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210601175643.GQ1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528195839.GO1002214@nvidia.com>
 <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A17F36CF744857C531148C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:208:d4::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR04CA0020.namprd04.prod.outlook.com (2603:10b6:208:d4::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 17:56:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lo8d9-00HY2N-Ik; Tue, 01 Jun 2021 14:56:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd27302a-6924-4c0c-5239-08d925269e9d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5238BC5111DCC3713034682EC23E9@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/zdm+xEqN95KJIhqS5Ul4b5v+2ykee1obtXzhO7xuAx1qaPL/sVpuNV2Vr0OTaPKIInNVjzwIq63KKfFci8ZJR0vMSbXopnfAc5DuYOa5UJjHAq5EXbpMzJQb0gF2HPYDqyTAqoyXeupjXf1edPGMdrOKhTmBxPB+b/6q9DqzEDivXLOHqaZhiqZU16UE0sTTGFT5gXk9ZX6jOtgkXLpCsfrmiMMfSnRUP0iTKjJibuUseXIcdfGPceFyUcmwJhpofDMpUgqUI8xsp/xBnS69zqxnQq1uZVRYz/AocTo5LW3JgmQD275xvbWjl/uYpb1zZY4WSZ0yL4MYCNavFSHE+pEQkle8CcPflHm/wetmG3D8YH5P9x5+sNXASwZe3VHctFlbw2m9R+85sQnOYBhOu/fYL4lvaPgwmgPonNbx02aWr/CCxI8ZOgwa0I/AVQzSbC+8o1Ql9Tbeq0/ejhA3OYcKAywL+7HQwN0wADyAW/84ZVjy/5ONTBCGR1UZ8xdPnx9fVip6h+356AWDJJGbx/6wzzqYcTq0SWpT+DzzODivJqt32mo2fdJAN/iQftvIkeOuPT/+SResoEaYPPx6++CWoJCOAlmlrTNwvDSRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(7416002)(2616005)(478600001)(83380400001)(86362001)(38100700002)(8676002)(9786002)(1076003)(316002)(9746002)(6916009)(4326008)(33656002)(5660300002)(2906002)(8936002)(186003)(26005)(36756003)(66476007)(66556008)(66946007)(426003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D0WMg6lLmpCg7hzNSIBDhY5UqKcWRX7OdeUebSZuc7YzJaipP9ZaSNnA6pN0?=
 =?us-ascii?Q?q6dIzW3k/x68PVZjK2zIPBXGCRqBiULQNaBZHoL5KAlndtGrmMoCRg6hkamm?=
 =?us-ascii?Q?p5wjUZ1h02O+DgHvS4zrUoa0iN7rtlZU0o2+Vmcc+wNNJtmdripTn6TU00+k?=
 =?us-ascii?Q?Xkv/1X/nA58vTlzYMV1HXs/H2/IdPbNmr9MrtqF3RD+goCVcyB+n/q2cal61?=
 =?us-ascii?Q?ZUbQaa7BP+rU6ju92r2Emyj4tlc00CivNgBKZkVQQ5ySQsEsPKoxfEfLvXUN?=
 =?us-ascii?Q?hWdb58IAz7PUopy4SzM+yM4caxz6SvCFVtCCwpVAKQU4YJx9m2OqyrNG7PY/?=
 =?us-ascii?Q?7jsetOMiH26hp9VyWWLpXJoGM89O5vNVK9KNdnjNaPFOfWEsSEvIUxLzrnHG?=
 =?us-ascii?Q?ZNy2+lEg8BXzkr76fhb4K9C+QkZePSkteKeyes78DjGYW+BfcUSmEdjhPjV3?=
 =?us-ascii?Q?0PXxkbcfSYl4kP1Vwcd3xpcdntPnXfw2fB+pL4Vq//xZo+vGsb1BJz8jkUcQ?=
 =?us-ascii?Q?+C4A+uA9UpfSNFyo+OItDrGo2ke0W+nBiVQznBvoYPVoBri0a/f7AygDwNTc?=
 =?us-ascii?Q?FiJsnObo+mzy41G4oDeM9GZIUCt5ywBdRUKRTwzMMjIlPhe0BQv7ZMlMnUrz?=
 =?us-ascii?Q?PMwcfVAd5TUM6Q9dq+Rc5M2Hkvc23PlxbtV8xaQPTPoycWu5emEjrPqQ82nx?=
 =?us-ascii?Q?BPC8seOFN1gwk9YDniX7VRUXOdGtN+0wsSDUOUMPmlEyoLVxgNWG5NfatzAR?=
 =?us-ascii?Q?1pbUW9b5uIwaccCKh3XQHMN65KKCUzFdOBb10mIEmaGqJqxsdt41oAgvcL0B?=
 =?us-ascii?Q?YUbX3c7dt34bijrdX0bBkAy/Ke4qvSt9iW7w5xYu0HQR+QVclN8JPseCOPVV?=
 =?us-ascii?Q?hqJNn4IuXAF5f8n8/FzlVoLiaGhAAbeoP1GHgb4Ds1AIG1mUrdH9+72NUl0O?=
 =?us-ascii?Q?rZjSDU3Xr1eGOYlugXjGDlqeieLxNFCuU+n94G3BC7RULmr2lxTS2o11gb7t?=
 =?us-ascii?Q?b2NfrjrMQi6uVSCFhndbkVPZ4V+tf/1+N07xdByc9AIBkm5Tn13n5tBoGYTJ?=
 =?us-ascii?Q?bEGn0YB38RUv4Ba55X/JC1/VlvEfWVsV2OqU9fJFqoyKKnh9FLV8deX3pwqI?=
 =?us-ascii?Q?Mck7dD9yemSFBSDn2/pgbkdIxJWHTkySJj1UC0ZbgCQ7ztH91TRPFEAE6uBI?=
 =?us-ascii?Q?jFYp3hsrF3NIet0PSs1Zaa2lJXOCKMxj/8P3q9CqgEFQRBQoztlE2lb6gBUZ?=
 =?us-ascii?Q?1RM3CKxUXghRsx6kCJUkIdz9hcgH48yHp3il/tCLaezwhLAAMs6MNczu0Uae?=
 =?us-ascii?Q?/MvByootrZS02AT/8+7/SD7+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd27302a-6924-4c0c-5239-08d925269e9d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 17:56:45.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADhebesglV10d8DtpVNtPIAgJxtJi1F2m3bet+7Uc7qD5Vl19ZzzTemlZqrnP8AE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 08:38:00AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, May 29, 2021 3:59 AM
> > 
> > On Thu, May 27, 2021 at 07:58:12AM +0000, Tian, Kevin wrote:
> > >
> > > 5. Use Cases and Flows
> > >
> > > Here assume VFIO will support a new model where every bound device
> > > is explicitly listed under /dev/vfio thus a device fd can be acquired w/o
> > > going through legacy container/group interface. For illustration purpose
> > > those devices are just called dev[1...N]:
> > >
> > > 	device_fd[1...N] = open("/dev/vfio/devices/dev[1...N]", mode);
> > >
> > > As explained earlier, one IOASID fd is sufficient for all intended use cases:
> > >
> > > 	ioasid_fd = open("/dev/ioasid", mode);
> > >
> > > For simplicity below examples are all made for the virtualization story.
> > > They are representative and could be easily adapted to a non-virtualization
> > > scenario.
> > 
> > For others, I don't think this is *strictly* necessary, we can
> > probably still get to the device_fd using the group_fd and fit in
> > /dev/ioasid. It does make the rest of this more readable though.
> 
> Jason, want to confirm here. Per earlier discussion we remain an
> impression that you want VFIO to be a pure device driver thus
> container/group are used only for legacy application.

Let me call this a "nice wish".

If you get to a point where you hard need this, then identify the hard
requirement and let's do it, but I wouldn't bloat this already large
project unnecessarily.

Similarly I wouldn't depend on the group fd existing in this design
so it could be changed later.

> From this comment are you suggesting that VFIO can still keep
> container/ group concepts and user just deprecates the use of vfio
> iommu uAPI (e.g. VFIO_SET_IOMMU) by using /dev/ioasid (which has a
> simple policy that an IOASID will reject cmd if partially-attached
> group exists)?

I would say no on the container. /dev/ioasid == the container, having
two competing objects at once in a single process is just a mess.

If the group fd can be kept requires charting a path through the
ioctls where the container is not used and /dev/ioasid is sub'd in
using the same device FD specific IOCTLs you show here.

I didn't try to chart this out carefully.

Also, ultimately, something need to be done about compatability with
the vfio container fd. It looks clear enough to me that the the VFIO
container FD is just a single IOASID using a special ioctl interface
so it would be quite rasonable to harmonize these somehow.

But that is too complicated and far out for me at least to guess on at
this point..

> > Still a little unsure why the vPASID is here not on the gva_ioasid. Is
> > there any scenario where we want different vpasid's for the same
> > IOASID? I guess it is OK like this. Hum.
> 
> Yes, it's completely sane that the guest links a I/O page table to 
> different vpasids on dev1 and dev2. The IOMMU doesn't mandate
> that when multiple devices share an I/O page table they must use
> the same PASID#. 

Ok..

Jason
