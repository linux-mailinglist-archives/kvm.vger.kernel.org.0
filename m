Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850AC419DF8
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 20:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbhI0STI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 14:19:08 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:53056
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235930AbhI0STD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 14:19:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eL0cHgPstp5UFgFVar66NO4vIBroGHPAqBBcJVI05SEuIOpOMi/nbWIbjK/ap6eZUV+zZ+0eXZPBwZNr7t4H69AJjCziTr4tT8+GDrmrsWQO9gc6EXR8brmEXQrd6MPUwEOg4Hzbl7/99n2vb8/74qurnmFI2bgoVo+6lM3JtCHBf2mnuKJJeRCc5csGfk7s9rRkAnAsvJgfmHmGE+tnRMZhRZVjAS0IqVG1/ESUJFwU9uQyg/uU2kL1ArCRU1aWFqYrJL2RbgdZyACn1aIvbM+5h+dLwUeaX2+z0xufZaMqjghZ+GpGHX6qPTmAiPL04Fb1f6MtNRcUacMzeTbfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XHKm6BEhtnl5lrn2s0PiRYFdq3O20nFIszxp2Hk+yVg=;
 b=kRgkkHg9e0IzJNDthAn4oOeBu+fedqeqbUjJ3D3JlaqiuzZ7Sz4G0s8ZtCw2YZn3kanqI2jpArXWlZdEPM9fpgdnL61cpXknDrxLDoFJG2KGBAFzkOa0zZNATsyzYOu2WpseENz6GXKRgouuEfOJvmKmYEWoNg77xjTCfahzwbkH9vWw00nzdsKQJC/RzCuEsCWfCXOQ+2wyZwhWPd3NU1UT8P9cQCx+K3cQIiG5XRA6G/ijO+cilz4/7gsZsDdTrMBWDOH+QAIdpNf8DJLrShTvhv6GjF5kRDe7clNmjQBQ0metW7eCa0DupMePrPwopTsn5eVIT/33jQHY3/4IXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHKm6BEhtnl5lrn2s0PiRYFdq3O20nFIszxp2Hk+yVg=;
 b=St6Ht2O1clBDpxeTN+8HiItFzUfqAC0GeY+XqsStBD+KcHjR+GylP8ciitENUDYVerSxMQl7zVKcRLrVOzhAmzczulpS0IYBVE/ZIg4dyfEqMoYzO6Vj6QsJVxs4E+p5a71jhyeshrm+bveTc+q2T+Or8HbFnictL5VRSPn7KoFdBsSLOeLwOl/wuAs3hXwXVRmmzQpyR88Xq+0TralthYA1UVoDM7innvH/pD2O9mltOYYNU85Y246cJIPuyA1TIFTQIpucXLk72KxTH/VSwRDodUC4sgKDcRKmfMopVs/0LaVwBYczTz9wVTsBFLdIh7GlsPOwPzbJksgsep2Hag==
Received: from MWHPR11CA0017.namprd11.prod.outlook.com (2603:10b6:301:1::27)
 by CY4PR12MB1654.namprd12.prod.outlook.com (2603:10b6:910:3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Mon, 27 Sep
 2021 18:17:24 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:1:cafe::31) by MWHPR11CA0017.outlook.office365.com
 (2603:10b6:301:1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Mon, 27 Sep 2021 18:17:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 18:17:24 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep
 2021 18:17:23 +0000
Received: from localhost (172.20.187.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Sep 2021 18:17:22
 +0000
Date:   Mon, 27 Sep 2021 21:17:19 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <YVIKr48e8G1wSxYX@unreal>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
 <YVHqlzyIX3099Gtz@unreal>
 <20210927160627.GC964074@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210927160627.GC964074@nvidia.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8230b56-53fc-40a3-621e-08d981e30e13
X-MS-TrafficTypeDiagnostic: CY4PR12MB1654:
X-Microsoft-Antispam-PRVS: <CY4PR12MB16543A905D849C278701076CBDA79@CY4PR12MB1654.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHAldMQ8e8wWD+NMJMunQbACTgLhCDgnrQwyRpQ7VQZKOyukXbESC7b/gkk+9aD3rksFagrQacB/lK9a8CDauZFEtg+0GRH3JGkZ+uV4POC0Kp9Eo63Ib5MeGD4EJWk2dwXGC029YOQvQ+ICkpfRbdL4b6kF/qznEDImU1WqxuDHVbYLi92dioL9+kMjj/AUfNqgOfB029ONIT3bowWmS7wYzimRwqYJTHFSqRPj1o3Wldm9dmp1xClzO7ydDSsY+TMHwFrHxP6zuFknSH9ETGDxaMvG7aAUkTEho2HXuzThE32jl9gnt6b8UG1Gb10rke3TzTDSRbu9LrA8xf4rNpecpUujrlcFSatLRYbgKkbhwjd2fATMbVrJ65QFoq5JPjyI80gzujrXmVbR+FMn7slXwW8ejny6hO9dXt42UScyT78MAsaRwn5gwPJUWjkDr+urZgyPrA/9ZxXw0XUk/PIxcfF9bKb5zY8poqQ+opFtFv0OBK7UOeQOfm2KceL6YkjqscxT3IXp0tl2/RRLHRFnlh4VifwQN3TCEQKhMNW7z4c7g+RmDH/TT1kJZw4TDzPJXj/fXi5aZMq6BE4TMgHizxQwfk5zp4qq57kR6mtaDrwMdfOLXx2IWESK9v5RPqvLSfJC+/V0e9lu1u7VVnexHM0h1qQjAM9cyO+7C0cjasU+gf+XjeDQD3xJvYPQbdwfswgIfAWujCZGlO3UpQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(26005)(336012)(8936002)(508600001)(33716001)(426003)(70206006)(47076005)(36906005)(5660300002)(6862004)(4326008)(83380400001)(6636002)(54906003)(9686003)(16526019)(36860700001)(70586007)(356005)(6666004)(8676002)(316002)(86362001)(7636003)(2906002)(186003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 18:17:24.2357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8230b56-53fc-40a3-621e-08d981e30e13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1654
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 01:06:27PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 27, 2021 at 07:00:23PM +0300, Leon Romanovsky wrote:
> > On Mon, Sep 27, 2021 at 12:01:19PM -0300, Jason Gunthorpe wrote:
> > > On Mon, Sep 27, 2021 at 01:46:31PM +0000, Shameerali Kolothum Thodi wrote:
> > > 
> > > > > > > Nope, this is locked wrong and has no lifetime management.
> > > > > >
> > > > > > Ok. Holding the device_lock() sufficient here?
> > > > > 
> > > > > You can't hold a hisi_qm pointer with some kind of lifecycle
> > > > > management of that pointer. device_lock/etc is necessary to call
> > > > > pci_get_drvdata()
> > > > 
> > > > Since this migration driver only supports VF devices and the PF
> > > > driver will not be removed until all the VF devices gets removed,
> > > > is the locking necessary here?
> > > 
> > > Oh.. That is really busted up. pci_sriov_disable() is called under the
> > > device_lock(pf) and obtains the device_lock(vf).
> > 
> > Yes, indirectly, but yes.
> > 
> > > 
> > > This means a VF driver can never use the device_lock(pf), otherwise it
> > > can deadlock itself if PF removal triggers VF removal.
> > 
> > VF can use pci_dev_trylock() on PF to prevent PF removal.
> 
> no, no here, the device_lock is used in too many places for a trylock
> to be appropriate
> 
> > > 
> > > But you can't access these members without using the device_lock(), as
> > > there really are no safety guarentees..
> > > 
> > > The mlx5 patches have this same sketchy problem.
> > > 
> > > We may need a new special function 'pci_get_sriov_pf_devdata()' that
> > > confirms the vf/pf relationship and explicitly interlocks with the
> > > pci_sriov_enable/disable instead of using device_lock()
> > > 
> > > Leon, what do you think?
> > 
> > I see pci_dev_lock() and similar functions, they are easier to
> > understand that specific pci_get_sriov_pf_devdata().
> 
> That is just a wrapper for device_lock - it doesnt help anything
> 
> The point is to all out a different locking regime that relies on the
> sriov enable/disable removing the VF struct devices

You can't avoid trylock, because this pci_get_sriov_pf_devdata() will be
called in VF where it already holds lock, so attempt to take PF lock
will cause to deadlock.

PCI code assumes that PF lock is taken first, and VF lock is second.

Thanks

> 
> Jason
