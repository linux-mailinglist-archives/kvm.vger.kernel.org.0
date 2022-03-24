Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6EE4E5D19
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 03:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344006AbiCXCOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 22:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347836AbiCXCNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 22:13:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA2E91372
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 19:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648087913; x=1679623913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HaXiVSv3WT8e16knQ8tIyLmllOCfeKyDq+5YPOQs6gk=;
  b=kraXl10Xq0cX9ZzZgBJK3t7/TL2d4RJeubpbrxfUvTw9C3UAX0t6574o
   3e2lsTCvo+E8joY0QoERwrbUZUGY6YjOGB//0WKgHZdxGsE3hKqnCqQl0
   2RuPglGi44rOfGHDstiqdNZjXFY8DdTOSJR3iyDRyiGr/Vvl13EV8f/CR
   FPHHuWz1DpgBhYkYTyytpYPAp3IfpgQ/ibYei1i2usoUKc3AV1q+kilGx
   ZhxibZ5fYQ2fimIxpadGMvFq6ix5B8rqcv/BZ1rPOF5KpmdTH5bHbzM6D
   ht/a4+dt+35Z8iUKuPm7g0ccu7fepJh0iiM/vl7hwr4aypQCZXnBlPanJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="257981495"
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="257981495"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 19:11:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,206,1643702400"; 
   d="scan'208";a="649678697"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 23 Mar 2022 19:11:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 23 Mar 2022 19:11:52 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 19:11:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 23 Mar 2022 19:11:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 23 Mar 2022 19:11:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGgflc3dYtVRsmIwX/aU/QZ3TwmTN39LSrHvEY9hnFsBbH8m/tPQ2+kZ0qkAh+dMxYIfVw1fOx6cC0PA6sYcyhgC2lW9FPEEoWXpdWpk/UgZ+XKEiw8St6AEPR7i3ZMIVnfjVjDmfoF6lwFUj6Cfue5KKnnaVUQ4jnDs64nb+6SxSCPvShvJZMXM8X7ylLRsjvWZsCPN+Ercq8HDxZ5aObc6c9p0hTwtb95FzWETeoPojvSkqCGG4P/famXK6Ag8xQGSkNrg/idFE7F4aLs+vNkS3E6SWuDuJkN44k0Pv6K6XGcIAnDgmZM2jTcVUpj1BA39C7G3pX4GBEJTEehhiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPvSIKdWAVlBNuQIlwrQctZ3NP8YM8yX9SKb93MCwVk=;
 b=AgF+3pqS3YDFBYaCd1FkiN3usJymExmIx8sjXAL3CewKohJ9cASGH6P7pyjFPmiG5KVCzfOhQAE1U8+4B/7vVzBlXhMZOcbkKhlST1tPU5e3jnqT7er6ZM0GTQ3eEUlWkIHRQbakQlE/Q2820GM23Ls9ogj+WY/xrqPQGPSRgBUrvXTSgWt0ikFhgv3+smvyDPj/kIJ0z9g1YEma2NNzHqP1yKJUJuzy//Wbe6sYO1YUF8ueFy2A1BnjWlv+eb0rll+x+Dbrls/xQHb0t+c4fxX/iD8WOtJElUTyqf3XXfQXLh0PosRMVDHiT9KhN01XELv0qL44On67hPUOHJFDYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR1101MB2250.namprd11.prod.outlook.com (2603:10b6:4:4d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Thu, 24 Mar
 2022 02:11:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 02:11:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Shameerali Kolothum Thodi" <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: RE: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be usable
 for iommufd
Thread-Topic: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Thread-Index: AQHYOu2DSsSjQi9eMEu6J1ns8GLP6azLfE8AgAAIMYCAAAjbgIAADNiAgAI1J0A=
Date:   Thu, 24 Mar 2022 02:11:49 +0000
Message-ID: <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
In-Reply-To: <20220322161521.GJ11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07d16303-9235-48ca-111e-08da0d3ba7e9
x-ms-traffictypediagnostic: DM5PR1101MB2250:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB225008368620D26BDA7372DA8C199@DM5PR1101MB2250.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hH1KAN1G+sBA+9SUr2m3Oy4NQC1LV+eX47iJQOQzOO8hJ0X2dXtzCzVrwmyWsr+G4VhLWQqXSBTWAZ7eFt+RUMZN++hJZ4hPmF+bYVO0so6HxrynHsbGlzd4hK5lfIpKRQqqVmoWI+TLPBnxlRHt+PaFebHdkTlW/K37FIt+BvDCyW4+cKP4CCExgv493SBe4j1fWiEdY1g8fTtAAd+rW63zC57W/011Cf9QG1HvCkqyuRZGWfcwYFYSqqPH9RYTHnUyPxynRhYkTkhHEKAc2I+Pm11Em96lOseGt4EKaPT/cNQeIRpwUtArochFQl/v9uvrJy9pe0dcuPPqd96LXXL3YY5Q5bk+PLbnphqO8CEk3Ztcxv9UfDIor64NMU1gawMJ6sgV0PlP/T4BqOl6P2I66ri5GywofvEVbAvLP2A7Ah4sRXPY8aFAUnN26hy/K0pSB6ilPFV6Y9wnn4Ihezk0sIyFPIirrlESFljvbIb9yUSqcglF1Xm2SvjXQpJuULfzpVvlgN446M8aaASImy4JxpSdb7kjREskjw/3etvMnr4C1J012dxoTdgtfb/+c+UuqzPgkLxJcCNQDeKBTMMuryQooq6YTafMfWHEpDKZMXyGe3FdND5tD+z9ANBf3l4fs+pg2H3y8yifTueluF7/BvwtqwkWb1Nab8zrui77TyXOS/PsVRXQmV2n6YgToGdJn3yEkiR10vnJ5DUlIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(2906002)(55016003)(38100700002)(9686003)(33656002)(7416002)(86362001)(110136005)(71200400001)(26005)(7696005)(5660300002)(186003)(6506007)(54906003)(66476007)(66946007)(76116006)(66446008)(64756008)(508600001)(66556008)(8936002)(38070700005)(83380400001)(8676002)(122000001)(82960400001)(52536014)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o5+v3xiME/5ikEJIjAM04jSlhptT7SgDcxuqAICZMkD7XweGzEQaylDnC2o3?=
 =?us-ascii?Q?nyG0ZCe2SleJyqEz0cFR/JI75BAaRAFzo69BQF+evO83/ntL+w6f8Y1DWt5f?=
 =?us-ascii?Q?xuYUYBkUm4Qc5sUy9GuW5LOQ2l/FCfHs3KfZVMJsCAwgYoPCPj34Ocmwy3kD?=
 =?us-ascii?Q?iJn+zn1Fh9hLWrzX2eGfuqVph6Z7ldUGifk9f8t5yau/ZDrLQmyOZL4cunbZ?=
 =?us-ascii?Q?ufC1NL5jEDb5FlHUsd4Y07qVV4OOU2hBtoiOisdYa63WtxgKmmSPgOxAdgq1?=
 =?us-ascii?Q?fpxAc76FRCtXNzOCQ0cwlSmLHJDzhPaZ4YQCMUHYYaVzY892BHzn2TCBT5t1?=
 =?us-ascii?Q?ZzaOLa1pe6uzaoU4IJdYIBlxb8NP6sTzJXMEhdarDfR8rodbcig+qYl+wPvr?=
 =?us-ascii?Q?AyENrdmCUBBySESNWi1sn5okGR7PYoOa+GhyCEI1zhxS87uTgzfF8O0gDC8e?=
 =?us-ascii?Q?7WP/tIwJdLv9p+8VWRt3pQRDUxZ2ZGL0isQKDnDVvqjYMSdIuAkbvDLDK9pk?=
 =?us-ascii?Q?kfiDrSJ17eqTsyHP1vQYZW+rZeyZC75h1XFLNl2QHZyDVS9MIZdmI7rukrk9?=
 =?us-ascii?Q?for/cwN8/wuOf4ugKS+DdAlxgSTURsT6WvKdwRvrLvyO/+82o2iqukXMQ16z?=
 =?us-ascii?Q?a6qVn35NLvBWReMubuHuw9vdo9ctRmEOnXvjASyg2tjj6z762g6vJnf59WNZ?=
 =?us-ascii?Q?eYNt61EjaXVO3cPjDdIdxswAsq3LvKeC4832Cz+8/yPmNrD6BzpJv102sRkM?=
 =?us-ascii?Q?+7ZB6Ozt6qr6YBrkj6jizugpLvaLvhs38Jz4B83hJy7tXZLZnN77EIEIqQKk?=
 =?us-ascii?Q?AXdJS1DsxajGp2KJ30v0TXprY/qLmwe+4OOzIrCYVsDQ0HO+EVu2F1EF5Bpx?=
 =?us-ascii?Q?ybDfRfsRpCJr573Y5mgq6HgPJ9yw2PwiT3vSArSupReBnOYqsBa2Xo9IXxEs?=
 =?us-ascii?Q?xVuKsCQtA1sDtkP4j20U9gIj7fo9xsk1LpEtz2RMEbRzyF1ZVU/LKpCUShLV?=
 =?us-ascii?Q?iLpECg5gd9+Nke8t2t3EfBrnXf+TIy/H3vYwCBEUCGRoRVMRfzK3a17aV8GW?=
 =?us-ascii?Q?vRhFUuPX9r1lHfF2JS95QVoqpdkJcLreEj4gGKK1OGM7bwpBNVG8PRj4Whxr?=
 =?us-ascii?Q?rOVFVq9uzphVTDbBgVDBPp1lS95vhELbqnsxk9SyfBDffvBgy5V+AxT3eP1a?=
 =?us-ascii?Q?CjLrs5sTwB6BLSaN4gc0avTMkCVPKAFYafmqZGLZkLPzErbJfehHGyiw6Uw3?=
 =?us-ascii?Q?RYR37QUD/hEpcIJ19T5XZqn0hEIDAMsI/w8JAIQ3XaBTH/Yz7mulap0h0De+?=
 =?us-ascii?Q?RtKC0cgZyUITMK8UDe7l0UT2YKiAW1A7+lb9Pi4fHTYELVm6u51qiP+L+H0d?=
 =?us-ascii?Q?9Vk9oNsl2A2183pgevzVmkmqvdwBonTF0zeZ2Y0uuHsJhVv3WZC/jh+PjB0V?=
 =?us-ascii?Q?JUy/UsnijPvCWxh8HNdpCCDssPxuXjQZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d16303-9235-48ca-111e-08da0d3ba7e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 02:11:49.6397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PSnEA0647Q9l9n6HvcH3tGaZuzprHC+xdJF+CBeFysO57qp75Rdk4FBkYgAUdBZf6+26I95TKcPQ3HjlUNYhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2250
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 23, 2022 12:15 AM
>=20
> On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
>=20
> > I'm still picking my way through the series, but the later compat
> > interface doesn't mention this difference as an outstanding issue.
> > Doesn't this difference need to be accounted in how libvirt manages VM
> > resource limits?
>=20
> AFACIT, no, but it should be checked.
>=20
> > AIUI libvirt uses some form of prlimit(2) to set process locked
> > memory limits.
>=20
> Yes, and ulimit does work fully. prlimit adjusts the value:
>=20
> int do_prlimit(struct task_struct *tsk, unsigned int resource,
> 		struct rlimit *new_rlim, struct rlimit *old_rlim)
> {
> 	rlim =3D tsk->signal->rlim + resource;
> [..]
> 		if (new_rlim)
> 			*rlim =3D *new_rlim;
>=20
> Which vfio reads back here:
>=20
> drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit =3D
> rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> drivers/vfio/vfio_iommu_type1.c:        unsigned long limit =3D
> rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>=20
> And iommufd does the same read back:
>=20
> 	lock_limit =3D
> 		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >>
> PAGE_SHIFT;
> 	npages =3D pages->npinned - pages->last_npinned;
> 	do {
> 		cur_pages =3D atomic_long_read(&pages->source_user-
> >locked_vm);
> 		new_pages =3D cur_pages + npages;
> 		if (new_pages > lock_limit)
> 			return -ENOMEM;
> 	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm,
> cur_pages,
> 				     new_pages) !=3D cur_pages);
>=20
> So it does work essentially the same.
>=20
> The difference is more subtle, iouring/etc puts the charge in the user
> so it is additive with things like iouring and additively spans all
> the users processes.
>=20
> However vfio is accounting only per-process and only for itself - no
> other subsystem uses locked as the charge variable for DMA pins.
>=20
> The user visible difference will be that a limit X that worked with
> VFIO may start to fail after a kernel upgrade as the charge accounting
> is now cross user and additive with things like iommufd.
>=20
> This whole area is a bit peculiar (eg mlock itself works differently),
> IMHO, but with most of the places doing pins voting to use
> user->locked_vm as the charge it seems the right path in today's
> kernel.
>=20
> Ceratinly having qemu concurrently using three different subsystems
> (vfio, rdma, iouring) issuing FOLL_LONGTERM and all accounting for
> RLIMIT_MEMLOCK differently cannot be sane or correct.
>=20
> I plan to fix RDMA like this as well so at least we can have
> consistency within qemu.
>=20

I have an impression that iommufd and vfio type1 must use
the same accounting scheme given the management stack
has no insight into qemu on which one is actually used thus
cannot adapt to the subtle difference in between. in this
regard either we start fixing vfio type1 to use user->locked_vm
now or have iommufd follow vfio type1 for upward compatibility
and then change them together at a later point.

I prefer to the former as IMHO I don't know when will be a later
point w/o certain kernel changes to actually break the userspace
policy built on a wrong accounting scheme...=20

Thanks
Kevin
