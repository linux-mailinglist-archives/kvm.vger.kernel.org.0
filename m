Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8AB5108F3
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 21:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352459AbiDZTaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 15:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241779AbiDZTaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 15:30:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF43046177
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 12:27:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxhDsoushnFtMRrWiii4fiHVF221kq6ByM8XqflntbYn7kV/s9GMNu/mCM82mZ+ZQwlzEzRKXk4cByOLtzpkghaRnEpt6q22rT8e2mNc6jOHd62gidCVY+NTyrAkuBMwSes7/JosA5Ez9MwiCbkC9ojNdyLPi/FSeReUNsA1crWfIsQ3lqVSks5X4y1bYIL0psV3ie77NBB3f3Ny6ky34BpQcJ+lu6RYtV8ePCoymNil5gZ5h3SKv82q83JbkUoTS+hVR7BAMfSuLf0XjTej4haTQ9/IpvOgtwMMpxWW3zoEQ8JSsMVm/JBCNSnP406G59sA3nEf2yJpkVjM7kdiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBIbmbrGGW3CDQyqCE9iPyPnuWJ2WSlORrLb/SHVAl4=;
 b=fFjT6fTZquh/WtMW12rT2tHR3+Z0gKWy/2GAGt6BAFpf7khKOnQtOm/215IkCo/6kLYHmO30Kw84nxUUczdiukJwp2VqthJ2FnZS/v4mqFQXisWQfEoxvPNDU9xziFLNNHKb+HhmmmGLDi8lOeU0ak8wDP4Jf/hMDwH88r4fgQaje0aQ7O4MYOgs+pmh+7vQK61xVWo6nb13B3EiUnkfa+iIcfVfncGPQsaKAWq34prmTf/DtaApTrg+UEWHCQq6d3oSvkMngmrmazogLGyR1eO1H13Qzk6Df5NqAw7Z0W4OnNP1AAhjWnyrEcJy+OBqqvhUiQW3I3oMaf1Z0e4/DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBIbmbrGGW3CDQyqCE9iPyPnuWJ2WSlORrLb/SHVAl4=;
 b=rZAI3esmn2gHwf66hMnadXmoNiwprWFrn4XeOP9xKxfbAB0C3aOU2Mipy8rrfbpE8UgymM1oC3HYXmKlqUwg/l5+KBW2yROgXah01I/nTSd5uAdVCYd52aJVYulkc2+J09sg3FfdNeqSio//fGvqxhGziSAuJ8fDPMq+35KZXiUlkD6xmbHYh3M/skSSDhG+y5RPhq/HaIPvt0Uqxcc9/HQUes/jZEgs7EotUDAjt3OQS0h8yUZzX/rQ9S1x/r/Kqb/gGYjC2iwaRjxq45dQNqTIh4GiUmap28XA1MBKww/OtGc72kCMCxoBhv7SHQD5ILrOQ+sz0YGAxCSf5bSBiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 19:27:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 19:27:05 +0000
Date:   Tue, 26 Apr 2022 16:27:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Peng, Chao P" <chao.p.peng@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220426192703.GS2125828@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-16-yi.l.liu@intel.com>
 <20220422145815.GK2120790@nvidia.com>
 <3576770b-e4c2-cf11-da0c-821c55ab9902@intel.com>
 <BN9PR11MB5276AD0B0DAA59A44ED705618CFB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220426134114.GM2125828@nvidia.com>
 <79de081d-31dc-41a4-d38f-1e28327b1152@intel.com>
 <20220426141156.GO2125828@nvidia.com>
 <20220426124541.5f33f357.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426124541.5f33f357.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:208:d4::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45648cb4-514b-40f5-9a8d-08da27babf1b
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1607AC87D936E1FB120DF36FC2FB9@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3Y0gIgH4ajDqMmQGLQtab+9qUD7GId4AsHwGbQ8PkwPLjdQ5cCn24GkC/KjxrfQGpSqRe4lY36c59ml6JEyXkCAweFxvrSHGo7cl+aD/9gJOZiRapNl9Hw77kSb2ECkwbBmM/DD79W7+NdMosqI4bAxKmLk+LmzWzQRzBKZX6qmUBtu0tFgjysCNs3Yb3fHSx+FXyoHugo76sHYXXi56g93i2gXRUZCA8JYU2md5hGhIHJDsBZSLLJeNIfkXbIm73Og1QFhF8c2WhJxt85R8vjfKJzToIkh0h5ErzAtBnjOSPn27XFa3S/LE16cTnMQFfKFqaxls8NJdYWdCqakK5ugkWKTYf8iWzC9CkKznRMK3gXAHKc2zc0oeJpsNBOmn3MQ7AUbIxEeIil6fXlKNTysflHbizLrssYPmYMIyAl+bNhctHaKBhuboQpifym4L70/7qe6/TI44+u2r7O3cGRKVxuBFumvWFrWO4SY/Cx2C/cNfF9eL3+kk7jusNTkU3EyVza+UrZmA3KvVsJ00Sz6Bye1jCVcguejjtUhWbea1j/oZVPIAc3pesqVi9xBa8hKxvxmZnreJDMFddetLxSPUSaTWXfpqJ7GEtLlZZxIJeo3zrOtbdtKuB4JM9rbV50lsG7DfUaCffIr2jEH0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(5660300002)(2906002)(6486002)(66476007)(508600001)(7416002)(4326008)(2616005)(1076003)(186003)(83380400001)(38100700002)(6506007)(8936002)(26005)(33656002)(66946007)(86362001)(6916009)(66556008)(316002)(36756003)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mPgazMkRtQyhX/Lqx8Gwn8EQ/8QX2pS11UoRQHDF7sEac0ALOY8kgGG59GHA?=
 =?us-ascii?Q?lY+6EwzT5hCmpGugWQiy5DDyAhIOJWoQN0fc2nmHIH5+vkBHvoXCoZm2KX7v?=
 =?us-ascii?Q?wVRZF72QZG+jQl2UClZirRqzad7i7N26CijaTYOFKYEykDQA/jll+LZG47dX?=
 =?us-ascii?Q?Lvw59/XbsUdSHk6i5LHiJHzSyPE83qnc4OQjUEZTMJyRQuDQxfEIizHejyOU?=
 =?us-ascii?Q?raBzB+MEzAezMwUzuNxNyKArhJf50OWJPCPD1Z8mEE5JCAI8/Su7BfLVZINR?=
 =?us-ascii?Q?0m7wAvslZ8PlyHMc4KJCkjskndA+mdqcRcbGzjdNOPdJhDpjGANec+4Oodos?=
 =?us-ascii?Q?iK+mQKBZRiUEeNzz3IG7xqMRV2hxQLsnwhAqJ3CYGsGk5Go3Bi3Orc3rB1nB?=
 =?us-ascii?Q?Ifq4NeMPnDGMN33wO6Er8jV6Yvj0dJn//PWj9+KyG/naaRaS41wY/Mnfe33I?=
 =?us-ascii?Q?g9swqEcQEj695O6RoRIV7E8HI48IoJTS5TX3ejTmKLQvWn6Jsy8zQNsvbDbm?=
 =?us-ascii?Q?umBELmJ7OUAtL2v6L9LbB4feN7KRSt+YV4teyvKBwym83YjUfenarT+kF2uR?=
 =?us-ascii?Q?NO/kbly19J0qurHIiEGWD2ntqzinh4yN9WPPe50AuUmiH43H6KUIsVSXu1lI?=
 =?us-ascii?Q?GrXpbR9RlGWVc3KyU/O3wFi56KCmUArlNFiXV2032B4NA1SdHQ1zbiHJxHhk?=
 =?us-ascii?Q?UpJr/69Nt3qZdNAkvFUMgm7qjxI/aEHOaRq2EmNAJQ5xWT4n9wM9hn8bNsSE?=
 =?us-ascii?Q?1b6LOUHFdXthdeYPNcMHp5ZPKK8mVfTsD/e7HoCXUAHqO777Nqqy2pg2qUOt?=
 =?us-ascii?Q?BX2UCWuDc071zgLeqfZO3rjrj7yUyASRSmqjrIssSIG0fYz9UsdKvpjxydQG?=
 =?us-ascii?Q?rdxoznlXHEaMpiAwbHx8IC0nCqY8KPH1HeBQQilvdOF2Rv7sJnsDUQXF1tt9?=
 =?us-ascii?Q?uZytK4PQhfkncV7KWsDvwQ8b1OfmbXc5RWlFLi4nm8RpbwHKtcT7X9nBMrqD?=
 =?us-ascii?Q?R4bm0eqoNyzax+9PWxWa1v10lViJSj8MEjXxLeMd4RB2WLhoKJrTdf4X86HI?=
 =?us-ascii?Q?cmOkXfaRZNpOqjZ7E4YB2VVAQojMwN89rqxHTF1ABNI5Gh07+SVg89bLzNQ5?=
 =?us-ascii?Q?f6kF7pOGR7taN7gwkjq3e+koMnmT3BNbPnGR6HWJlXUQo7Ot1Fz0sObgv2qs?=
 =?us-ascii?Q?D9j3KcPm7PF0HQE8N7lmZbMYsfTekdlWf8PTCvTY9rhFr8QhSxMQNDsSpkz9?=
 =?us-ascii?Q?zSzarhd5eCxVRRKqrp4PPgWXIe46zIoNauzmbcJ4KOOtCnx70fL7Zg6BacbJ?=
 =?us-ascii?Q?tzKpa+3YgrDnU1JqQDzSQle/ZIJLYR+SJWJyzCT/h2R7uIgEyb9L51PWlBQH?=
 =?us-ascii?Q?iIAYhwK/DPsLHdCzXUzyUNTMWwArUmQS0ZH9z/sCIo7QBHG6MXlbSaLZBiG/?=
 =?us-ascii?Q?N9zTXgDBBdUxkT+uBiLACn6sCBTo+kqTOPXZ13l/m/RMBd1fUFvbEtGDdXfz?=
 =?us-ascii?Q?4B/GzMWfw33a7u13q+60EA8gOBQuAelODBJaou75mMz9ZEdsc6cs5Ny57w53?=
 =?us-ascii?Q?9Uds/AcTTuawfT+0Jjcg4fBh+DnovFL5HldN/+ozobvGbRK+e/uZaQDjqI5+?=
 =?us-ascii?Q?wKOn9LVmhE4ay9U8NG7N5cUS87C+Ud2kzAWkJU/VRdaMwJ+bI5wlnLtQ2B4c?=
 =?us-ascii?Q?JgwEZXNYMoYsyQqEPdysBn0NbRdcMEIeCMro+dAsTFGh/zymwioRChEhrPxz?=
 =?us-ascii?Q?nfylyEFx3w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45648cb4-514b-40f5-9a8d-08da27babf1b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 19:27:05.1410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkWq/xscWqfr2Zo31funR2EI/EEFviwSppBgjLxmjrf6wBC43+UebFeP265gQFER
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022 at 12:45:41PM -0600, Alex Williamson wrote:
> On Tue, 26 Apr 2022 11:11:56 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Apr 26, 2022 at 10:08:30PM +0800, Yi Liu wrote:
> > 
> > > > I think it is strange that the allowed DMA a guest can do depends on
> > > > the order how devices are plugged into the guest, and varys from
> > > > device to device?
> > > > 
> > > > IMHO it would be nicer if qemu would be able to read the new reserved
> > > > regions and unmap the conflicts before hot plugging the new device. We
> > > > don't have a kernel API to do this, maybe we should have one?  
> > > 
> > > For userspace drivers, it is fine to do it. For QEMU, it's not quite easy
> > > since the IOVA is GPA which is determined per the e820 table.  
> > 
> > Sure, that is why I said we may need a new API to get this data back
> > so userspace can fix the address map before attempting to attach the
> > new device. Currently that is not possible at all, the device attach
> > fails and userspace has no way to learn what addresses are causing
> > problems.
> 
> We have APIs to get the IOVA ranges, both with legacy vfio and the
> iommufd RFC, QEMU could compare these, but deciding to remove an
> existing mapping is not something to be done lightly. 

Not quite, you can get the IOVA ranges after you attach the device,
but device attach will fail if the new range restrictions intersect
with the existing mappings. So we don't have an easy way to learn the
new range restriction in a way that lets userspace ensure an attach
will not fail due to reserved ranged overlapping with mappings.

The best you could do is make a dummy IOAS then attach the device,
read the mappings, detatch, and then do your unmaps.

I'm imagining something like IOMMUFD_DEVICE_GET_RANGES that can be
called prior to attaching on the device ID.

> We must be absolutely certain that there is no DMA to that range
> before doing so.

Yes, but at the same time if the VM thinks it can DMA to that memory
then it is quite likely to DMA to it with the new device that doesn't
have it mapped in the first place.

It is also a bit odd that the behavior depends on the order the
devices are installed as if you plug the narrower device first then
the next device will happily use the narrower ranges, but viceversa
will get a different result.

This is why I find it bit strange that qemu doesn't check the
ranges. eg I would expect that anything declared as memory in the E820
map has to be mappable to the iommu_domain or the device should not
attach at all.

The P2P is a bit trickier, and I know we don't have a good story
because we lack ACPI description, but I would have expected the same
kind of thing. Anything P2Pable should be in the iommu_domain or the
device should not attach. As with system memory there are only certain
parts of the E820 map that an OS would use for P2P.

(ideally ACPI would indicate exactly what combinations of devices are
P2Pable and then qemu would use that drive the mandatory address
ranges in the IOAS)

> > > yeah. qemu can filter the P2P BAR mapping and just stop it in qemu. We
> > > haven't added it as it is something you will add in future. so didn't
> > > add it in this RFC. :-) Please let me know if it feels better to filter
> > > it from today.  
> > 
> > I currently hope it will use a different map API entirely and not rely
> > on discovering the P2P via the VMA. eg using a DMABUF FD or something.
> > 
> > So blocking it in qemu feels like the right thing to do.
> 
> Wait a sec, so legacy vfio supports p2p between devices, which has a
> least a couple known use cases, primarily involving GPUs for at least
> one of the peers, and we're not going to make equivalent support a
> feature requirement for iommufd?  

I said "different map API" - something like IOMMU_FD_MAP_DMABUF
perhaps.

The trouble with taking in a user pointer to MMIO memory is that it
becomes quite annoying to go from a VMA back to the actual owner
object so we can establish proper refcounting and lifetime of struct-page-less
memory. Requiring userspace to make that connection via a FD
simplifies and generalizes this.

So, qemu would say 'oh this memory is exported by VFIO, I will do
VFIO_EXPORT_DMA_BUF, then do IOMMU_FD_MAP_DMABUF, then close the FD'

For vfio_compat we'd have to build some hacky compat approach to
discover the dmabuf for vfio-pci from the VMA.

But if qemu is going this way with a new implementation I would prefer
the new implementation use the new way, when we decide what it should
be.

As I mentioned before I would like to use DMABUF since I already have
a use-case to expose DMABUF from vfio-pci to connect to RDMA. I will
post the vfio DMABUF patch I have already.

Jason
