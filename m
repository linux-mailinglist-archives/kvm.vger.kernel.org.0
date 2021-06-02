Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639703991CA
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhFBRg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:36:58 -0400
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:42849
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229604AbhFBRg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 13:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdYlwEqEdZy3eptjiw9zK2h6MHOVeBsDojdPsT8Ic89pab/UFC9INH08kwtKvkTLwutEsTkNAKXXybyGIGm5M3jMlULRrjOFmpEV3lbes+uvFGbHsjqF6+yxOyw1s7120YidnwSdHBi/8AxHV5vJkSa9TJs9U6m33IkBCEhkJHV/FtfwbAS77aUaYhCn7U4qqgu7urBH2AWOAEUC6tXx/j8gdGcd+thq4TvlOiIuMZDlvjxnROYrcPz4UdFh7n/of22qFwGzUTstDixrQ/wniqfegMzqwzc1j+fdOVmHLZGQVrtYEdTD+iFFJ7rwUZb2qo0oWfAWs5jRDOdLwmZNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sAAQZbsxkyuTeOSdh8MO2naxa0/ImDVyUDbW7qlVAo=;
 b=RuVO5Vjoj6UqswwrBDd9wbxSBPbd4UCp/ygg9vnOmF3/v7L5XvfIbi3TG/6iSaJZob8WXcdYo+ImfUbSFfWwYeGzxSEFjjUNoOsV6HfDZraA5OW91T18n7LGAoICLWX7LQTINHAdBXTjz3/fmfCBeEKuBqjDFxl1csdQC2DdAJ48LvaXa8dqjF5e4qwI5Y3aNlw3Rjl7YPCMcECgfBpRqwP6SQuSK+bWzizItMVOo+OT6hibe4oCYlHeTkf2YO1cVnPuqst4igyXH7YrIPOqfl35DYou0RvcWGS5j7pYsuJkrt2hGwOsiF324s4hLQY78noS6LCVFhWAZpWBHkrM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7sAAQZbsxkyuTeOSdh8MO2naxa0/ImDVyUDbW7qlVAo=;
 b=ojsgfsqyESWZmibImn+3IpF9dM4dsNXgdSDzV2dt6xzMSIIRBgEwSzpsnu2e+nIaFjjtCsyH1vyiG+XnCllOESzwgR3ENgDuYYDrwkCWlIM5xPyhsGwSCbGzBYdYjaY06VKx7eGvkONVEUjgJlpeH9l4Xd1cv9yfuvEyCCyvQUd8cJfFFJkd8XEq3JZWTcYMUkxctQqU04rOYEhI6u3B0gnLzexz08II2RQQ0eLn9tULf/kP3ZxNktV+thIl5/1MURYvqGXxa71E2WMz0vXQ9sw/LKfegwN3Xe26QHUYPvApN+W77wBNyQkwbB/EsSsjk/q7sFm53hlabiNkzsirtQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 17:35:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 17:35:12 +0000
Date:   Wed, 2 Jun 2021 14:35:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602173510.GE1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
 <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160140.GV1002214@nvidia.com>
 <20210602111117.026d4a26.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602111117.026d4a26.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR19CA0047.namprd19.prod.outlook.com
 (2603:10b6:208:19b::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR19CA0047.namprd19.prod.outlook.com (2603:10b6:208:19b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend Transport; Wed, 2 Jun 2021 17:35:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loUlq-000IeH-ND; Wed, 02 Jun 2021 14:35:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76f3de1d-c168-45b1-8c6e-08d925ecc68a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143A24F88AEE4320BDEB561C23D9@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nwP+NFOdVAUqjE9GYDz/XUQYoN/i/VIRrFwDXb8Y01f1lI5xu1xhgItzEYSKTQGiU7lfN8g2Ku6Soasg9DpYMSHXBsUJX//p+M12G2kvuyW4+PyRthtGhEEF+NzZnEIw59pXiGSRRci/Fs/XV6RcY6ASe+z+gBapEmlcQ12IKGJZQfpDmsoWku00x1XiWCtx5zyGG4cqUPlVVp/GaKu2zRFGA4TXb0jVLzMt0jfmGO4yW361Ibn26ZxzQS/cJ030sSSG3pVap+lfrXP0zrVj4AepVoPvOxmcsef2ZczHRkougLasyeyXcOixkur/Txxcy5oem6bYJtSC2UoSZS6DKM8ozpBbV/EOghjx9OEIXvATtxCUwIAqVOApvwWmJA+Fuw1FQAyczp8kSsb1DA2rLFhpDWinmz9pH1BPHQDnsGsozKOAWlSzvj2bweqMSYyKbNbYH1Rqc+vVcDWbSOoi4LNklBfIDfH47JPPgLQhBrxBdPh3RO84V/4OXeusNQp/PVtRJJJn2RHH+r0vza8+KZUy68MfsIp0v0VkDj8AEPsbZChUtv3vFyaRBC+iU5jNS6Wz6gNXba7rphegwvq4OzxxSh3AO6DRKHjaVgTk/v8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(38100700002)(6916009)(7416002)(86362001)(186003)(9746002)(9786002)(8936002)(2616005)(8676002)(66946007)(54906003)(478600001)(426003)(5660300002)(66476007)(4326008)(26005)(1076003)(36756003)(2906002)(33656002)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IXM5Goh5zkkowFaR1gN50BBx7zrCqwvAF4Uy4niDgaFo+3RK0KI8mg1zhubc?=
 =?us-ascii?Q?hHDP9GqyA7S8bRaxU22UO5FvzPoIIJq0qh0A3QI9okkuTABRXE/jSBxwa9M8?=
 =?us-ascii?Q?lgD+9+TayXEykUj/EMJhIHhTSpThLKJ3vOARVpMOse3sxQg5Q4MXUTxnSq/e?=
 =?us-ascii?Q?FtcXkY/Wjx79VCu6CJ23vXpTITSKrbDfCQHdNFLzPlXbl3eR1CCKeDeRZflj?=
 =?us-ascii?Q?i5LQVT/Mecom/0qEV9y3TVvRQMPdH7xSQKr1ZI5PYoQ/tlQrdWJzf+oeJA/p?=
 =?us-ascii?Q?Hbksb0CUb99cs3I6+Cko24Wg+tTKh97dYnuK1B/8kCZByzu+praRjootk+at?=
 =?us-ascii?Q?QxhUupkdM+no+XdqY1fmNB5i1eL77xz3xQcbOzFknMFlCbqehxNYZhB+lGxS?=
 =?us-ascii?Q?icw76srR2EXXipOIie/OhtEo+AgmLGThIWAts2Y8gW5E2CnYaHLP6Il3CMsi?=
 =?us-ascii?Q?7OdK20KYPW1tOG5Zw35/L8DCtnTE0S2kBeW7i0ktrzteVfOXRaAe3rJkwWnu?=
 =?us-ascii?Q?eSG77df46GZ6VIS7e3teW/5DkihaiE0NDXAyVpdoHh/KOYJp7OAXndsGgvag?=
 =?us-ascii?Q?aovE+dDAssha9Na0OTXTVBxtXTsLbuIJ75x6YkhdBhgiXCkfPJbUx5CeN10p?=
 =?us-ascii?Q?oMvDBRLBvUEuJyDQFvn0z2vuwVuPvXaVfWmi3oVUbsLoateIv3aNh7etq9lf?=
 =?us-ascii?Q?ZS0+3ZM32dcYcv74ld0QHoWVsGJZUe2p+wa5ngTbNkvdmVeR4NnAnIHxurFC?=
 =?us-ascii?Q?or+xDd0LZ+1SLqWavNJPO40EoHKzpQlqBuaJrLM7+j0r9LGUImI3h3/oLyYb?=
 =?us-ascii?Q?2fkqkCfkxvKX8MAqGXg69ZZnAgKD8ILEIKUleFoK1kBn7F6959flkoB4rG16?=
 =?us-ascii?Q?P/Sc7GVT7R6MgPR3UI3Vw8plb0QS58T88g0kx0hP8RLgJKVvzmbrS1vlAnsB?=
 =?us-ascii?Q?3RbkmBvnUlvrJ+DRRAqXQWvlhkeBsjwdbq8t/UxGF1IX7fAbV4YJHtUm4ftv?=
 =?us-ascii?Q?RdgQYmlWLizcz4iH549mEnOiGMguKpcjAar/hdtRzMt0ZgEBzwWhEeMW4Z2V?=
 =?us-ascii?Q?eI7zPkRk9o/ZxvaScbgcHw5y9sIw8PZzWSGvkstkOy3KmmYN6lMKA6XbIPfk?=
 =?us-ascii?Q?HcBGgiKiXrv5JsRF1DgRoykByttg9STxtiayEdlLu0RKMc4HmuXsa915P+wP?=
 =?us-ascii?Q?uakrGqYP/8CoFDGrypvBBHKeBuayR9mJFpYRxkopGaYq603EtsPh6jite0va?=
 =?us-ascii?Q?HEQOKCoseoIrqemr6uuYleXT2f21xEJuwj15h1HItTMz/PZJ7ryKlqDTpyOW?=
 =?us-ascii?Q?Wa1RbAwQC5DXoDgrLg0ovbIv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f3de1d-c168-45b1-8c6e-08d925ecc68a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 17:35:12.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y02WsSMBe81ALIxfTcMeDRx2nKQ9xxuC5/m452P70zEzRAPhsbVj4WrdD2/G3CAl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 11:11:17AM -0600, Alex Williamson wrote:

> > > > present and be able to test if DMA for that device is cache
> > > > coherent.  
> > 
> > Why is this such a strong linkage to VFIO and not just a 'hey kvm
> > emulate wbinvd' flag from qemu?
> 
> IIRC, wbinvd has host implications, a malicious user could tell KVM to
> emulate wbinvd then run the op in a loop and induce a disproportionate
> load on the system.  We therefore wanted a way that it would only be
> enabled when required.

I think the non-coherentness is vfio_device specific? eg a specific
device will decide if it is coherent or not?

If yes I'd recast this to call kvm_arch_register_noncoherent_dma()
from the VFIO_GROUP_NOTIFY_SET_KVM in the struct vfio_device
implementation and not link it through the IOMMU.

If userspace is telling the vfio_device to be non-coherent or not then
it can call kvm_arch_register_noncoherent_dma() or not based on that
signal.

> > It kind of looks like the other main point is to generate the
> > VFIO_GROUP_NOTIFY_SET_KVM which is being used by two VFIO drivers to
> > connect back to the kvm data
> > 
> > But that seems like it would have been better handled with some IOCTL
> > on the vfio_device fd to import the KVM to the driver not this
> > roundabout way?
> 
> Then QEMU would need to know which drivers require KVM knowledge?  This
> allowed transparent backwards compatibility with userspace.  Thanks,

I'd just blindly fire a generic 'hey here is your KVM FD' into every
VFIO device.

The backwards compat angle is reasonable enough though.

So those two don't sound so bad, don't know about PPC, but David seem
optimistic

A basic idea is to remove the iommu stuff from the kvm connection so
that the scope of the iommu related rework is contained to vfio

Jason
