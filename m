Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10CD41ED4C
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 14:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354142AbhJAM0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 08:26:55 -0400
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:36799
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353397AbhJAM0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 08:26:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8BUVr63IXdZZ1bTaZAjUiP4BdFXzGUWxUjqtaODgfmZDmTDNVQV8ZR+5qekbuhUzB7uBVsdB/O28pOMVIhSqkRcimsH0ipGnwT6pOHMKnuCbDdedkh65jcu346csNE9MAtCP7sSHY36RJozpvdhq6GcBk4rk6wHKOM0t0JNgjMWK7dqTqC8tdsvMS9hIHfVi4oOZ+kF/Vc9gNa3wNvc5uyKKyrLUX1PEEGMxQ2hXePuRCJoxhwoqlnwjBlxJl2tgvA9CoaW/rjr4dowf+Up5TFbiTvye38cZhcXLncx6OBq7AGwLNtnTjcxcZ8MvxbahtYQz2aMFJdp9PU0lMMASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5KdaXXU01TbykcnrlKwzvMH7gueP+w2qMpdPLrzO4c=;
 b=GjEHHLufA+vPgIPv3ufPab+100JJYmcLOT/tyUheGAQTrAYcskWayghC179Svm1ecwWkvFZdsHXRSfJzfjxoIX4FS4yUP0pl6XZWrbu7VhdJNNOtgeg2lDT5I+fGA5iPm+pYzli7qIH3AcKYxksfxoPMYYvZmD/zzaPen3bopfhfz0rTHrWhNeUADvfmD+nifNq90Qt2yn+XsQ8IJvJEeU6xUMZFQRFnRAoIMwTN4uLG4yLpD2Xk+4osnVW8vt+hEY883nVJtT8mirNuaG/oulwHjFwiFUdH8YYPgvfIfnDqY+A3sN1xXa6zNhDVvAC9mn6vOfpjmytAjENuoMZ7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5KdaXXU01TbykcnrlKwzvMH7gueP+w2qMpdPLrzO4c=;
 b=kdzCiaG/4IVg54G6xokWk2epQUnP5h+p7Sob3xJgZqUvkkcdzHfeAf9oPoMtPfgR+WKlf5bPsoS362RmUg0LonEGSkcqgApZuJvhNbnFc7Ub0wM+uQoJjC8yyETfirIfHxoaPS0ppp3ag/HKR/4IujrZHznI86sdn5Pz+otXegRToYjbJf5M3OtRMK6qZHrb3ccFdobLiFyl+twhF3H18PfGfTUaoUx683wzAjnensK79Un1+K0uviCmcLgaJeAxXPjyjEI7Usp9jEpkkikwbWujEm2r4csppYjo2aRwf2wDzKQ+vluKktuZ+lxen/9m5RuCRsiVJoXwSKSeEyV8IA==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17; Fri, 1 Oct
 2021 12:25:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.019; Fri, 1 Oct 2021
 12:25:08 +0000
Date:   Fri, 1 Oct 2021 09:25:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20211001122505.GL964074@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922140911.GT327412@nvidia.com>
 <YVaoamAaqayk1Hja@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVaoamAaqayk1Hja@yekko>
X-ClientProxiedBy: MN2PR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:208:23e::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR14CA0027.namprd14.prod.outlook.com (2603:10b6:208:23e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Fri, 1 Oct 2021 12:25:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mWHb7-008PPI-PB; Fri, 01 Oct 2021 09:25:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 125c7018-dba2-49af-751c-08d984d68123
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB504837A7487F7641985A0CCBC2AB9@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8Njp+Xe3LYKyFkdhKrNheC4gIeeF0f0PEov//4ZBBjFzq22jY1Y2WzqJwX3pVaP/S5RxuoN4VaglQ7C6oxNaVYDf1zzOZ+PYwyUrx+vSr1G11ZI7XQbySx1OnOmHHGdxyu2Nyb4tvE0fb21T6JcRNp/R/sqVXNyS2DmOMw2ZplX1zezzT87TzkLuHAmeGcBpmcdRBt7mBPU6CykJFoAw0oi0LF9xaRFtWsz82HaBmWMe7v0qGpq5OZTPIr9qC4fl/8HXVoOIiT4sto6AAcsyBw/cPOTyuYsmdmUQ4mTArqMFfc1sfltHxksMhR7L/csWvZhda4/c2Iye6/G+6Z3NZiDXpIOW+4N1CXW6Aj5Lzw/SaNHbCc4/JTbRHExvdvPNMCoa9k01RA+mwtSN9O7Dl7IB/nkrILOsvSLTbwGWcEy6MlJxnzakZ7+snFoD9werHxGmuj7eQuaA2MLtIRfyj5yoY2CQoltFkni1du8wu2YVbvcYAn98KoflE7bRgkn033TJ+JFQ6kGtp6pLf680Nd0ufjrFGwp+AAG+XEuG3MXPtXYwfy3bmNFGZZGN3qVqIsh2TYPxNWH46oS5xk99UyxRtQ2Ha2PMgUs0mJgIu02DLxcem3coUHGGDJy1SGXNU2yLKfoXcNxPeFbRsBib9s1fa69/CZ80WP5RVWiLwaBXdz++qINNZWIrUKfYJ6Ikc8bmTbfRyah4uApRIqBhUl0CCA3/ZIWSvIWbtKxcpjffd8wVr2cMdsIdmpMgWjW1mWRLcQD3AYmtysEffnchWiDFIjNiR94wi1gEE4GRv1vvkU7qREnx736tmA+3bPX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(107886003)(86362001)(26005)(966005)(5660300002)(426003)(2616005)(4326008)(38100700002)(186003)(6916009)(54906003)(9746002)(7416002)(8676002)(33656002)(66556008)(508600001)(83380400001)(66476007)(36756003)(2906002)(1076003)(8936002)(316002)(66946007)(27376004)(84603001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NFSSJC8XvtlFI56LfVjiK6LtddS+IUPLpB+GR/QYZ+Da+B/IiIEd2w5y7fw2?=
 =?us-ascii?Q?ptTQKbHU0G3EzOOKKBQy/4qZvoiR6p8zYVo5oLNgMfRyVWeGiLsOLtv9jn67?=
 =?us-ascii?Q?YWKZqw9X3bzpCDSVcoiREXPptJmhsC61hMn+BdtDoI+TFDxjAanhIcNQJ3DT?=
 =?us-ascii?Q?t0Zna15AZJnKBd6RHk36gtCd7uApDXu5pH8i6ieZx8PZFkleP3Ni0CqMnMky?=
 =?us-ascii?Q?hEy8b93Yo59/GjaJZkNUcRkz15AFnFtSgoSIvjIugMsSO9zqfGk82WwDb2JE?=
 =?us-ascii?Q?/A1xw7T5nbrbp3/fiP//NtkoTzih+85t8rCQcJO0HRlwd2T2HF6BleMv+4DG?=
 =?us-ascii?Q?YQH8lomajexEIqtZQADrqyNxVL0RHSPVvoTmoCQO5AnNQVK2Z+2nFnI42KZW?=
 =?us-ascii?Q?w31ZybQGvdxFbnQNExfaXb6u/9CJ4ssuhiIA8MCU8b7D8nNRuPfpA1klFVXC?=
 =?us-ascii?Q?O/UA25HVsmUA+Gclhyl9Kz1vGMt27r4mXchJ7jwo/ViFSaRdeKcwPD8CTAAq?=
 =?us-ascii?Q?Bsz+g56aS9c6VETIpyMZy618gIbBybRwK8+HOp8NyoQ/YuFjzHjMmyRQOXTB?=
 =?us-ascii?Q?UdPFugerepKyzEj7M9ut2uy6dzUkSdTmU7E6S/OjkKjq0lL9+nPR4gATn+VS?=
 =?us-ascii?Q?KTkswbjO7hqtzjRs7OFSFbMNRA5TtJOUs6Y08niBBw3mjmkTfBbe2VJMndWL?=
 =?us-ascii?Q?twTgidLyY50Ng0LE33wl50MDbB9H0Klu0WRIfMavMkyyPVH//vMAFPt2MjC2?=
 =?us-ascii?Q?WxAjpDUYW3gLL463VvCN82WmiajD/BoLK3IL1f8UpB0y8z5rpXaECwqew3j+?=
 =?us-ascii?Q?EZDV2rm3BbTphjmbgO25lFL8+vxAjZrgLYCoNfMARxgeLbB4HhE4DTdF7HYB?=
 =?us-ascii?Q?FUvSRk78QDepM201a7o0doieBhggApZk7ydtODItZum0Lo/UtwW7PLc7qxd7?=
 =?us-ascii?Q?rhkyKIifdUUQh8NxUaFrI1D6M9o29kgbtWAq/KLiesnNLW3h0QXAF1r38fOx?=
 =?us-ascii?Q?gKFlQnj0BK5/u9oPd5V3lpKuQ3m2qLsgy+ijBDLa6lp5RBPYcgKr2kcYcyjo?=
 =?us-ascii?Q?Jxxv2PKJBdQsadxMWUhBVMqCzpECkgjC+6Ir+gg6lG2kniywizYP3nbRLfh8?=
 =?us-ascii?Q?TMqq2zZ3PVTvjnJLJzWRR6OqrUzVJJcfsOvmAJf2x8UCXvQhSuhozUN+9/Qc?=
 =?us-ascii?Q?HZfa+VPSp4BvJMAa8/h4PvJVyJpOZZcTI0U8IpYHsDrefW3OpvXPUCIWP2Lp?=
 =?us-ascii?Q?UCQBHzojAX5F1wHPmtHOxv8ogme3xuhV0bUl9szy2IDPuRPNwNBHkVOea8Zt?=
 =?us-ascii?Q?Tpd0UEuP/Pi4xYso/ASXif7G+LXEBoi/B4WAWHP/usZBXQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125c7018-dba2-49af-751c-08d984d68123
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 12:25:08.0340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s46tZC5ax4P1M0BET1v6sUcsqpb3IBiIuf/YkNzIZhGl7bAuXd+iPmHkPTin9VJD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01, 2021 at 04:19:22PM +1000, david@gibson.dropbear.id.au wrote:
> On Wed, Sep 22, 2021 at 11:09:11AM -0300, Jason Gunthorpe wrote:
> > On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Wednesday, September 22, 2021 1:45 AM
> > > > 
> > > > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > > > This patch adds IOASID allocation/free interface per iommufd. When
> > > > > allocating an IOASID, userspace is expected to specify the type and
> > > > > format information for the target I/O page table.
> > > > >
> > > > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > > > semantics. For this type the user should specify the addr_width of
> > > > > the I/O address space and whether the I/O page table is created in
> > > > > an iommu enfore_snoop format. enforce_snoop must be true at this point,
> > > > > as the false setting requires additional contract with KVM on handling
> > > > > WBINVD emulation, which can be added later.
> > > > >
> > > > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > > > > for what formats can be specified when allocating an IOASID.
> > > > >
> > > > > Open:
> > > > > - Devices on PPC platform currently use a different iommu driver in vfio.
> > > > >   Per previous discussion they can also use vfio type1v2 as long as there
> > > > >   is a way to claim a specific iova range from a system-wide address space.
> > > > >   This requirement doesn't sound PPC specific, as addr_width for pci
> > > > devices
> > > > >   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn't
> > > > >   adopted this design yet. We hope to have formal alignment in v1
> > > > discussion
> > > > >   and then decide how to incorporate it in v2.
> > > > 
> > > > I think the request was to include a start/end IO address hint when
> > > > creating the ios. When the kernel creates it then it can return the
> > > 
> > > is the hint single-range or could be multiple-ranges?
> > 
> > David explained it here:
> > 
> > https://lore.kernel.org/kvm/YMrKksUeNW%2FPEGPM@yekko/
> 
> Apparently not well enough.  I've attempted again in this thread.
> 
> > qeumu needs to be able to chooose if it gets the 32 bit range or 64
> > bit range.
> 
> No. qemu needs to supply *both* the 32-bit and 64-bit range to its
> guest, and therefore needs to request both from the host.

As I understood your remarks each IOAS can only be one of the formats
as they have a different PTE layout. So here I ment that qmeu needs to
be able to pick *for each IOAS* which of the two formats it is.

> Or rather, it *might* need to supply both.  It will supply just the
> 32-bit range by default, but the guest can request the 64-bit range
> and/or remove and resize the 32-bit range via hypercall interfaces.
> Vaguely recent Linux guests certainly will request the 64-bit range in
> addition to the default 32-bit range.

And this would result in two different IOAS objects

Jason
