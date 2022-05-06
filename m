Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8A51D82E
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392141AbiEFMw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 08:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiEFMwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 08:52:25 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2052.outbound.protection.outlook.com [40.107.212.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE7A12AB8
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 05:48:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKka/mh1IS23BfI/Rqk2GF4dn58Q5aKWsg7oEzBsmgdLKbjPHn8wH8R5LuZwJLDBIia9MpbhYdHEUlZQN5UAlwj03fnhbkxDy0W4bm+NnA6eDrFXqJyrZcXZ2TNvC5EvZkwJH3BrNkWJqpBqzz6fS/8iqLHoLPOQf3F9VHhUcKXPfXq9XmXEWQ7xFTIZSfm4J859glZNVRba9wMIHaJysaix0V6ZjT0glVMwrZHZ/DAN/Z0X4Ldje+jppOhJFnmxbqbMF0w+tsvQVhJUGb786F3IjmUCy/Ztrkwwp9HTR0h0uEOQY6nGk0MIwP7vKQguYeMOWyukNneBWTUpaVlOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6xKMKbIgvGCehDbi1wLQsPodhknAJKjKLkgXiUeBJE=;
 b=P3iLQF06qFCqYdiPzdiwIXwiHolydUyoO2fx6WMFiA1LjoSliBYH7DNL072cR5gS2YVFbkKa2x6saBB4Dm+soTpyP7am//J0/FajvjnVWD7v2akO6Xi47hAxunjw5T0SxbXxxIsBAJAYfjRvN4bYwRx4rn1M+H+Kc8IhQoRX9bX58xJBSJINxu4vJBIBgKhq1VPebyEpf81+OnYibHDeZRcPD25fyLQ7jPF7sp3jQYA3YPtzpAVWsMwkPJ35AhIYH2rR4Hw9jNPEnxUc/GDEi0Qa244sU6qAhceC9uqz9SlN2SQfQvghDO9CzPB93dNUWV59CTotW24atNphbBM65w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6xKMKbIgvGCehDbi1wLQsPodhknAJKjKLkgXiUeBJE=;
 b=MH6SB1Ho1LRktNIuW7VN0FW1z9yWAkUTvIcPipQe2exDMPN9wCtVumiZ9PO9Ac13yb+zMqrLXqBPtUGk2jrs9kGLaAd+L2IFy6kEZTa4arNLmOYGBXWZHidDOZfO7v6M67FITxV79aiW616eHoCq8HrFO+tPkcAnfi59f0jJXjzb0S1qM94ByK0pByCqiTAdo9y0KPEuao1a7gLAJICw0yV+usPzWpZ9v/nTO81KQxw7XUlT1BLAMtyNM9LUBVulmRMsVR85WJtMFXt9VFQtbxC8iiJDuTPvBYa2jC6Qz542CYE4kgztCN/o2DVDcRvFmUvECXYinA7rT0Hn8etYOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SN1PR12MB2558.namprd12.prod.outlook.com (2603:10b6:802:2b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 12:48:39 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.028; Fri, 6 May 2022
 12:48:39 +0000
Date:   Fri, 6 May 2022 09:48:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220506124837.GB49344@nvidia.com>
References: <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <YmuDtPMksOj7NOEh@yekko>
 <20220429124838.GW8364@nvidia.com>
 <Ym+IfTvdD2zS6j4G@yekko>
 <20220505190728.GV49344@nvidia.com>
 <YnSxL5KxwJvQzd2Q@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnSxL5KxwJvQzd2Q@yekko>
X-ClientProxiedBy: BL0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:91::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b9c3c0e-7e55-4dc8-daf4-08da2f5ebe12
X-MS-TrafficTypeDiagnostic: SN1PR12MB2558:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB255897A692E7EF07D954E600C2C59@SN1PR12MB2558.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXgNTQiNgUDKvk3olNjAEOZYKH9lcZgeKBLjzwOLW5mMFWhmWu/j4gY80MxaAl0CSiOjucXGOZg7hmnzbW9gWUAbu52hz6SZ4Dlf7PDX0uA7INLEeogTazLK+jpRuROtVxFVgJ7raVeJt2KMa7Rscda8TIzyx88Qbzm9BfNFoAPIz0gmIlL6lnvej//Toh2FhOlM8VCP85cMeGwRfDsgVyXHT4YWxVQiAYetXXMyETxhFfSR/kyZl5o0QkeNjdonxUQtXITyzEo7Qmm3DFb3j4bWgf7bsZexNCal0fw+6u2BXgZ9BGTwMgMvj4oVTus3kRsv+j96k0UfmTrA/rT49ZUOblDeKj1G1qAKFqotXte0t7Yxw9MFzJmdVvL8JMm/tl00mO2rWJTSR9jo6cnLk/dJ2wANugjuAFkxk/ABIVUaosacF8l9Z7ej+JaNt15nkSHb6WsOtKJtKVu16YdcmxrexUl8P/ds9m3T7GvXFfLueAHoV8y3h6hNykXuZNhynwqDSycc2doDVty7oQzhjdkJT222nh0zTas1WlVL7z2JX1s7wJK2AkWbMHMpxvZY59nVo8DgQfVLIOf83bLK8++FVGFLxYRZQCilmcoftgSsZUyGdQJdmwa1aveaqitEHi+O+JOMkZhGnJkhTAafHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6916009)(2616005)(6506007)(316002)(36756003)(7416002)(30864003)(66946007)(508600001)(186003)(5660300002)(33656002)(86362001)(26005)(2906002)(54906003)(6512007)(1076003)(6486002)(8936002)(66556008)(66476007)(83380400001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?poe6+PRYvrVrarVoGM7NUON2nQsoVlC++hoSRwSQia1MjyU5ejdQU28tlNE1?=
 =?us-ascii?Q?s7VrWpzZFOvyoZyj4aa1nB1mMxdMO2+GFaqyum/BOFpFbFPCxnodcJvaoXL3?=
 =?us-ascii?Q?MZdXVWMYLeS+Xjcb8s36MAIUMRVHwUZLIXSlwI/1N/vtgWVBGS+ljkAfmCkH?=
 =?us-ascii?Q?AA1T89Z8GHtmwrmL2SGBhWbGTB9fNG7DgZc7FeqP9UihTaOvvpDsV2yqBzXy?=
 =?us-ascii?Q?j5KP/gHG/70xYY0J+Np8vcQyDPk7M4AONWWmfvYBZZUDChWS6P5t1RsdMoPd?=
 =?us-ascii?Q?5F2boFlwB+xVC/FSpitQ+zfR9lxB2o2vJIGjp8fpENUOqkrF6fA/EXOcASD5?=
 =?us-ascii?Q?YX6D2LgsKTkdmcTMY/cmHhOzdz09QBnM0a5sW6pDY/h42eX3/OeOIRsUiszG?=
 =?us-ascii?Q?4odvL74c/aA0cRGQumDWHNNesef85ljB2i3TlgzUzOFJRdI6+pHnBoBsvGSh?=
 =?us-ascii?Q?yW7Nt3bWA6jpjNjkzyuG3BCD2vTjCsPjZlQwhBio8TfTm9fmW4YD81RsXOJg?=
 =?us-ascii?Q?i+Ny6zl5sOxMimdvASJTq3Xm9iUXi/cKXOvsgtWiIXsXm09PwJpjm4xUdorG?=
 =?us-ascii?Q?nW71JgziTFFRJj0omk/SkWFg3nLhcscIOW8Gr1eNTIwxmGVPJTihdcJ84SEj?=
 =?us-ascii?Q?HhN33f3oVqgouxNrIk7r+xIoGVN99PB5yfs/T3OkYSz2eYV0co1JlKYyImsA?=
 =?us-ascii?Q?jGs1Dwg0Ul9fXTTbhqafDRJRO93uSzUxbMlK9B+1Swf3x/oXP9EC/SltwWdT?=
 =?us-ascii?Q?XtXF++h3beIx5ei1+L47Q17FKNlRh07Z5+AuOGnq01TsNZdcseBI3vY4TWHp?=
 =?us-ascii?Q?68UsdqsnfkFpj1Q/a5lM/FYXdIg5d+aub0d8TGJu7nGRL85bQ68hmsyVumEs?=
 =?us-ascii?Q?ZVm5GZB9i307MQ8joJBYzN+4pprhvuThXbisr9QdSnr0cmSTHBTAN43QR5wY?=
 =?us-ascii?Q?gfJ/As2g+x8wA3I5kh0bfDHOp64p/FyzI5HtJhJ75rncLnc8mDkdvbP+T6xe?=
 =?us-ascii?Q?uy/qDi7ugnQqD0UmYebHXG884sJc842siYscuh9n1x5K49PJXbX/MZPVNqWQ?=
 =?us-ascii?Q?b7BDt3E6DIhCwZxgywRlkO0IH/r9g2L4m7S2q4VoWfW74UvtDpUO/ek0NjJt?=
 =?us-ascii?Q?lQFPLZnUayA8a71f49CeZRFQ9ubtWtgaFb3dw57fKojsfk9B6Wu40FNWis82?=
 =?us-ascii?Q?98pfUb/yhaoBGIdxEbp3p+oW2c7ptMtBuEK99+/ajc6vCGf/lDoSYZFyWxyg?=
 =?us-ascii?Q?0ai2Fo1UCFVCesb0RR3ResU8Yj9Zqh6XFe4JKysok400oLIEBedifC85UBdg?=
 =?us-ascii?Q?BP+OI3CUL5mN79rHwRjwcAp6SDdGyb4jKDfAL33sbh0pafZDUFZHjxsgDUTX?=
 =?us-ascii?Q?Zs/qFX9pqTK++WKsl5u0TxpC9YaQMcH9BPdaGzQ0QSpRAediLMs9PWLQWZhN?=
 =?us-ascii?Q?UPar8qar+k2EI/795q5rKl1/s2Fq8JEiTAyuOEruSp/+fuXxplYgwUEplw1G?=
 =?us-ascii?Q?11lT1IaQnl17TxlGrxom8aE3mY5BrnvD1lcMFlZOFHXx0Nd4BBJGC2PiD8ir?=
 =?us-ascii?Q?6sBXbfIkXmFJRS8SXOjW3uVK0UwiU+Y+XffTGe3jV98a0DRcNDrmi52kuR+V?=
 =?us-ascii?Q?H7PVW5tceVCa22TVkxttbN/QAxwvtcExOkJcspwM95PR6gNDuzLeU9Q8QXhC?=
 =?us-ascii?Q?LyeE5ycYXHnv44eVXzeKEZ33O9PK+xR5awrlJExUE4/ijwPcCIV3E2Ik/uBn?=
 =?us-ascii?Q?r9HMEorETg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9c3c0e-7e55-4dc8-daf4-08da2f5ebe12
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 12:48:39.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xm26VSlZQK13FzDVz4u4TQzcTbCocZZy1feambCAbbii0zLMYvADZ7XybX7yXiXX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2558
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 03:25:03PM +1000, David Gibson wrote:
> On Thu, May 05, 2022 at 04:07:28PM -0300, Jason Gunthorpe wrote:

> > When the iommu_domain is created I want to have a
> > iommu-driver-specific struct, so PPC can customize its iommu_domain
> > however it likes.
> 
> This requires that the client be aware of the host side IOMMU model.
> That's true in VFIO now, and it's nasty; I was really hoping we could
> *stop* doing that.

iommufd has two modes, the 'generic interface' which what this patch
series shows that does not require any device specific knowledge.

The default iommu_domain that the iommu driver creates will be used
here, it is up to the iommu driver to choose something reasonable for
use by applications like DPDK. ie PPC should probably pick its biggest
x86-like aperture.

The iommu-driver-specific struct is the "advanced" interface and
allows a user-space IOMMU driver to tightly control the HW with full
HW specific knowledge. This is where all the weird stuff that is not
general should go.

> Note that I'm talking here *purely* about the non-optimized case where
> all updates to the host side IO pagetables are handled by IOAS_MAP /
> IOAS_COPY, with no direct hardware access to user or guest managed IO
> pagetables.  The optimized case obviously requires end-to-end
> agreement on the pagetable format amongst other domain properties.

Sure, this is how things are already..

> What I'm hoping is that qemu (or whatever) can use this non-optimized
> as a fallback case where it does't need to know the properties of
> whatever host side IOMMU models there are.  It just requests what it
> needs based on the vIOMMU properties it needs to replicate and the
> host kernel either can supply it or can't.

There aren't really any negotiable vIOMMU properties beyond the
ranges, and the ranges are not *really* negotiable.

There are lots of dragons with the idea we can actually negotiate
ranges - because asking for the wrong range for what the HW can do
means you don't get anything. Which is completely contrary to the idea
of easy generic support for things like DPDK.

So DPDK can't ask for ranges, it is not generic.

This means we are really talking about a qemu-only API, and IMHO, qemu
is fine to have a PPC specific userspace driver to tweak this PPC
unique thing if the default windows are not acceptable.

IMHO it is no different from imagining an Intel specific userspace
driver that is using userspace IO pagetables to optimize
cross-platform qemu vIOMMU emulation. We should be comfortable with
the idea that accessing the full device-specific feature set requires
a HW specific user space driver.

> Admittedly those are pretty niche cases, but allowing for them gives
> us flexibility for the future.  Emulating an ARM SMMUv3 guest on an
> ARM SMMU v4 or v5 or v.whatever host is likely to be a real case in
> the future, and AFAICT, ARM are much less conservative that x86 about
> maintaining similar hw interfaces over time.  That's why I think
> considering these ppc cases will give a more robust interface for
> other future possibilities as well.

I don't think so - PPC has just done two things that are completely
divergent from eveything else - having two IO page tables for the same
end point, and using map/unmap hypercalls instead of a nested page
table.

Everyone else seems to be focused on IOPTEs that are similar to CPU
PTEs, particularly to enable SVA and other tricks, and CPU's don't
have either of this weirdness.

> You can consider that a map/unmap hypercall, but the size of the
> mapping is fixed (the IO pagesize which was previously set for the
> aperture).

Yes, I would consider that a map/unmap hypercall vs a nested translation.
 
> > Assuming yes, I'd expect that:
> > 
> > The iommu_domain for nested PPC is just a log of map/unmap hypervsior
> > calls to make. Whenever a new PE is attached to that domain it gets
> > the logged map's replayed to set it up, and when a PE is detached the
> > log is used to unmap everything.
> 
> And likewise duplicate every H_PUT_TCE to all the PEs in the domain.
> Sure.  It means the changes won't be atomic across the domain, but I
> guess that doesn't matter.  I guess you could have the same thing on a
> sufficiently complex x86 or ARM system, if you put two devices into
> the IOAS that were sufficiently far from each other in the bus
> topology that they use a different top-level host IOMMU.

Yes, strict atomicity is not needed.

> > It is not perfectly memory efficient - and we could perhaps talk about
> > a API modification to allow re-use of the iommufd datastructure
> > somehow, but I think this is a good logical starting point.
> 
> Because the map size is fixed, a "replay log" is effectively
> equivalent to a mirror of the entire IO pagetable.

So, for virtualized PPC the iommu_domain is an xarray of mapped PFNs
and device attach/detach just sweeps the xarray and does the
hypercalls. Very similar to what we discussed for S390.

It seems OK, this isn't even really overhead in most cases as we
always have to track the mapped PFNs anyhow.

> > Once a domain is created and attached to a group the aperture should
> > be immutable.
> 
> I realize that's the model right now, but is there a strong rationale
> for that immutability?

I have a strong preference that iommu_domains have immutable
properties once they are created just for overall sanity. Otherwise
everything becomes a racy mess.

If the iommu_domain changes dynamically then things using the aperture
data get all broken - it is complicated to fix. So it would need a big
reason to do it, I think.
 
> Come to that, IIUC that's true for the iommu_domain at the lower
> level, but not for the IOAS at a higher level.  You've stated that's
> *not* immutable, since it can shrink as new devices are added to the
> IOAS.  So I guess in that case the IOAS must be mapped by multiple
> iommu_domains?

Yes, thats right. The IOAS is expressly mutable because it its on
multiple domains and multiple groups each of which contribute to the
aperture. The IOAS aperture is the narrowest of everything, and we
have semi-reasonable semantics here. Here we have all the special code
to juggle this, but even in this case we can't handle an iommu_domain
or group changing asynchronously.

> Right but that aperture is coming only from the hardware.  What I'm
> suggesting here is that userspace can essentially opt into a *smaller*
> aperture (or apertures) than the hardware permits.  The value of this
> is that if the effective hardware aperture shrinks due to adding
> devices, the kernel has the information it needs to determine if this
> will be a problem for the userspace client or not.

We can do this check in userspace without more kernel APIs, userspace
should fetch the ranges and confirm they are still good after
attaching devices.

In general I have no issue with limiting the IOVA allocator in the
kernel, I just don't have a use case of an application that could use
the IOVA allocator (like DPDK) and also needs a limitation..

> > >   * A newly created kernel-managed IOAS has *no* IOVA windows
> > 
> > Already done, the iommufd IOAS has no iommu_domains inside it at
> > creation time.
> 
> That.. doesn't seem like the same thing at all.  If there are no
> domains, there are no restrictions from the hardware, so there's
> effectively an unlimited aperture.

Yes.. You wanted a 0 sized window instead? Why? That breaks what I'm
trying to do to make DPDK/etc portable and dead simple.
 
> > >   * A CREATE_WINDOW operation is added
> > >       * This takes a size, pagesize/granularity, optional base address
> > >         and optional additional attributes 
> > >       * If any of the specified attributes are incompatible with the
> > >         underlying hardware, the operation fails
> > 
> > iommu layer has nothing called a window. The closest thing is a
> > domain.
> 
> Maybe "window" is a bad name.  You called it "aperture" above (and
> I've shifted to that naming) and implied it *was* part of the IOMMU
> domain. 

It is but not as an object that can be mutated - it is just a
property.

You are talking about a window object that exists somehow, I don't
know this fits beyond some creation attribute of the domain..

> That said, it doesn't need to be at the iommu layer - as I
> said I'm consdiering this primarily a software concept and it could be
> at the IOAS layer.  The linkage would be that every iommufd operation
> which could change either the user-selected windows or the effective
> hardware apertures must ensure that all the user windows (still) lie
> within the hardware apertures.

As Kevin said, we need to start at the iommu_domain layer first -
when we understand how that needs to look then we can imagine what the
uAPI should be.

I don't want to create something in iommufd that is wildly divergent
from what the iommu_domain/etc can support.

> > The only thing the kernel can do is rely a notification that something
> > happened to a PE. The kernel gets an event on the PE basis, I would
> > like it to replicate it to all the devices and push it through the
> > VFIO device FD.
> 
> Again: it's not about the notifications (I don't even really know how
> those work in EEH).

Well, then I don't know what we are talking about - I'm interested in
what uAPI is needed to support this, as far as can I tell that is a
notification something bad happened and some control knobs?

As I said, I'd prefer this to be on the vfio_device FD vs on iommufd
and would like to find a way to make that work.

> expects that to happen at the (virtual) hardware level.  So if a guest
> trips an error on one device, it expects IO to stop for every other
> device in the PE.  But if hardware's notion of the PE is smaller than
> the guest's the host hardware won't accomplish that itself.

So, why do that to the guest? Shouldn't the PE in the guest be
strictly a subset of the PE in the host, otherwise you hit all these
problems you are talking about?

> used this in anger, I think a better approach is to just straight up
> fail any attempt to do any EEH operation if there's not a 1 to 1
> mapping from guest PE (domain) to host PE (group).

That makes sense

Jason
