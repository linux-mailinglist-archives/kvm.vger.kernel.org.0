Return-Path: <kvm+bounces-6306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2BAD82E865
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 05:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 41836B21B71
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 04:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3ACC79E2;
	Tue, 16 Jan 2024 04:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TlIC598w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805F279C1;
	Tue, 16 Jan 2024 04:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705377915; x=1736913915;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=PmF7R1D/OpCff71q0v3OfMS8MEdcHDacMxC+ENKx5jE=;
  b=TlIC598wQ2zF+ogUt7ZqWqjQ33MlSaqB7qNXbfQlf4wFXGgk93SNhiuB
   yNVIiZvEzBPA8E7ZKsGMQGQ87v6QYdm8viQDVpUfw0GkSfJjZHsQee7pG
   pqmvzXnUQ+BCtSkXVj1vJ5/HJcA0iBPIjjKMaRhCZswRn3cHl7snXaBLI
   zjRUNJn3xwXgT1f1Q6ttXQ72rLhfALA7nMuK3+GZdg70sQAyktcUvsF22
   9iVm7SqhnouqGWXlfYOSOp7+BzCwH7ufc0ocQsVw/Jxb0J5xfo+vP1iZJ
   cwyqNDcjnjWfadkxhTwCytSNAo5wDghOJhq/pJ+QhVTA8PE99pX9LujTH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="6844853"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="6844853"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 20:05:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="818030380"
X-IronPort-AV: E=Sophos;i="6.04,198,1695711600"; 
   d="scan'208";a="818030380"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2024 20:05:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 20:05:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 20:05:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Jan 2024 20:05:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Jan 2024 20:05:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MC8665R4kp1MmPuFEdYVfQf75DXPv22aooH0qcHlbeCRrS+ZIHs2wuO93aHqptFlxpSjIYDf2C0eVtNN+f1Qzci22GRDCv8Avh7ppDxQ5sBjhWf8a8uK/YvMw9hOQ9qF8bHuWQlkPw6zCm+Wa5C8KL1k7AbGZ7kOR59vO0SP9u2Gw9wtDolSZ61WgUmn1nkwg6LGIZmt7EuJ9chrculUlza2riCEVHkkt7TqfWzx1zmngV6lvRPcubxgAOoitCYwlVk3OW9yP1gRl82BeoYXrb6v24JYjlqK5jY+i8P7fvdijwOADoSBJ0yWXfwqMWv7i8laLLn8VS4o2DN+MT2gXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmF7R1D/OpCff71q0v3OfMS8MEdcHDacMxC+ENKx5jE=;
 b=htQ9EB91kRfcJcpkJicZXp4vU/pRoqwpqb0VVVPMTJiZIi5gnfeZbGr5+jTv9em3seRQVm6hWh+bzZRp/VQGx/VCpYaFGK8XXO0T/TwTJJIbaY4ESOtbRpzhjcc0/6HtzjCM+77EWh6/CNpvVcvMLVs63bJXtAszZiJBipxsqPgsoy3ydyZC34tFkLByizrnpHYFJr4fkDtsB4vApqQnTvd/DRhWqDrv2xwCKXmB9IHW1Nq+HqDKVtMUdtO4cA5r7dSKAZm6HmLlkM61vJ7dmpHngcNIskE89y7tmdRqthPgmU09/D/4/16mZSkD4BHeb6pXW6Garo7GI/Xb8/36WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7813.namprd11.prod.outlook.com (2603:10b6:208:402::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Tue, 16 Jan
 2024 04:05:08 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7181.022; Tue, 16 Jan 2024
 04:05:08 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "olvaffe@gmail.com" <olvaffe@gmail.com>, "Lv, Zhiyuan"
	<zhiyuan.lv@intel.com>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>, "Ma,
 Yongwei" <yongwei.ma@intel.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>, "jmattson@google.com"
	<jmattson@google.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"gurchetansingh@chromium.org" <gurchetansingh@chromium.org>,
	"kraxel@redhat.com" <kraxel@redhat.com>, "zzyiwei@google.com"
	<zzyiwei@google.com>, "ankita@nvidia.com" <ankita@nvidia.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"james.morse@arm.com" <james.morse@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: RE: [PATCH 0/4] KVM: Honor guest memory types for virtio GPU devices
Thread-Topic: [PATCH 0/4] KVM: Honor guest memory types for virtio GPU devices
Thread-Index: AQHaP7tymmMn9RzSAkmqnV+LZ1Ybo7DLoueAgAPOSYCAAIYUAIAAoD4AgAAM2ACAAB54gIAKXh0AgACHppCAADe5sA==
Date: Tue, 16 Jan 2024 04:05:08 +0000
Message-ID: <BN9PR11MB5276B5603D9D777F01D64EDA8C732@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240105091237.24577-1-yan.y.zhao@intel.com>
 <20240105195551.GE50406@nvidia.com>
 <ZZuQEQAVX28v7p9Z@yzhao56-desk.sh.intel.com>
 <20240108140250.GJ50406@nvidia.com>
 <ZZyG9n0qZEr6dLlZ@yzhao56-desk.sh.intel.com>
 <20240109002220.GA439767@nvidia.com>
 <ZZyrS4RiHvktDZXb@yzhao56-desk.sh.intel.com>
 <20240115163050.GI734935@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7813:EE_
x-ms-office365-filtering-correlation-id: 78d05ba9-2ca9-45ee-1e7e-08dc164853e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jDJSrrGjdp2kWU1pfTSAD84ey9EWELdtYT7oICcc1QxdcQccGwBe3rZ+PJaSUFKhiNx/hPghsyMykvxgpUp2uNLvTVLOWAWg1WWbALinfiHRcAQIiCdPPnS1FrbnCxm1ljBtsyRd2dWsCbzNS6U/iaSFkCtMIhHKfCWslL3x0XfvTl3GsHZZ5McbbvvKM8Jnu7lRnbMQD144cBzMImA6pEoieXUl+xXCN/HwTk2GTdFxJ6jSHg4naKHElD+Y9nEWJ+l+QLIjjiGyFiw7wQCaGZwKLPsbRGErfZ67XzCWvGnLLMB5CT4E5C76I9P4VuS9/ue25ooceFL9Gc1A62fQmM82pRm1PnCnbeX32/0j36CXY5xZo8iPE8URtekSEuOjSaSdPlkYW5ItPGfB3ikqvQBgFlm3pBEE8MlGA26mnlg7QmsXgxfJaD8ZzxliH1wr5Z8r9Nwq0Ars1AV4id5juFMYN19SYcML/CgC9t9OCQinxevv5QqFKPQDmwmu+H95/f7+aVSb4l0tj+ermRaBXDcohZXper2vk2HivbeuC5bzRAqAIqzq4lpDHQSqWrRSrqup4/eR5cKxOZyJw+xegUMug5XyvJ/uZ5aEgt/LXdQ2qyn7lj/4I6DaqV70FB1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(366004)(376002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(38100700002)(71200400001)(83380400001)(26005)(122000001)(66446008)(66556008)(64756008)(8676002)(66946007)(66476007)(8936002)(52536014)(4326008)(76116006)(110136005)(6636002)(316002)(54906003)(6506007)(55016003)(33656002)(82960400001)(9686003)(478600001)(7696005)(86362001)(2906002)(7416002)(38070700009)(5660300002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nWBN9rNHMm/JMd56MFiD5/X02nuuSfiRbKPchMYHJtp4YGrnsQ7FQsrQlc/k?=
 =?us-ascii?Q?8Dhq6P6alJTVaA6TQSnOKcR9xn/k4jHYeh4nkK2kZur2SnBXryzrDIRZqCO6?=
 =?us-ascii?Q?9PE9Jv2GEP8HpYyva2lMyPvdQMpg6N3QcfMMitEsDLGeNBMImhxKZInYg4A5?=
 =?us-ascii?Q?XY332RZOX9Tksno8rWRvJd7BC5Ml3r/zttJjku1wNsENLyS4ZI7Cy+7dPCYv?=
 =?us-ascii?Q?3fblsjXzWmtR2ozNU8wIcY8ddKJedAMhOrNoI34XxTcZlRfbORJtJ4YqomGr?=
 =?us-ascii?Q?kRAeJOIFMB+cXlklu7MIfsvO9SWnuaPI7bS8cbEHSKgmmgQCTp8ozoh2CTFV?=
 =?us-ascii?Q?iJsaKTWFrpcJhCOk4Z/PjYZJz8x8P6f6XT+iZD49Vy7XsO8gpdoDcW2ysOXX?=
 =?us-ascii?Q?4IqD+wcJZIpJ976llC2Z95jVcT2wDcEvgKayYZ3x1qUwzkkKUbYrTSSZ26zB?=
 =?us-ascii?Q?NTqdZUhoX6e0iMOHV6Sn7CUrShSAiDZ0QxX1yhGnWoMvTX29jeF/osb5mXlh?=
 =?us-ascii?Q?lnzm43HOYDixtolqiSKO3o3rtEQEb/T2NPKEUWQF61Aetd+AF1JVhV8oSDjL?=
 =?us-ascii?Q?w+OyNDbo1ebIZe4BwQDg2fPtJgQFAzrGbkh6RsYNVqOg9KwomQNWkpAHX49i?=
 =?us-ascii?Q?Cjtiz7oP4xMjvqjMK0z1nIc34qjj8+Z7GK4SKTefJVDBSckoGE9fdaAxOiC3?=
 =?us-ascii?Q?1+R7Lt0EIc5NZ5X93OOFmZ3QR5Ofzk7VrU8B4Uylk+QLFur6KQPFDGDcIt92?=
 =?us-ascii?Q?0sZPKr4Rm8ewYAybBuou8MZ+JeVK5qzw8C31mUe52zX3XSO2s2l4o8+oOTWU?=
 =?us-ascii?Q?2VMP4ftYbveipUA6lai8SzBOvV6DMWnL0SEKRl2I/w24+zm2CJLBiw1ZF6zP?=
 =?us-ascii?Q?PiGBi4FRTszHfP6rIYv7tV8ao92ZNfpJ6nEz9/btb9Tor5+jtmmdvwIuhUr1?=
 =?us-ascii?Q?6mjB0x7cdOtOk/AVWa1uAXIocym4xfaHKz+9IBaaLXK5u9UOSTZMRoXbUGQ9?=
 =?us-ascii?Q?aFwPxr8o1QLgTmqr+M12cFVdO4sPS3qx6m3qCGuPiu6436xu23FAnnbzCeIC?=
 =?us-ascii?Q?6bkiZfdX2IdFsee662GwBvRhn2rRehdfzyW5j1cNtH9i5jSxFnBzs2q5tr9s?=
 =?us-ascii?Q?wjGVewnj2f8KNCKWA4gvtcavm7LQIiIOtoDD5xF/D63+Q64HAC5AnBGGAQ2p?=
 =?us-ascii?Q?pPW0edlSO7SbJ/tCL8sL+lYe87Ugg1x20de67tIrYG4Kbr8t51XWRZ3j4dDB?=
 =?us-ascii?Q?XSOIIP3c5szGWFyHkTYuqO8rmU0iVkJNKjcxU7WN8LbiuP4Fgpzr67qIh0LV?=
 =?us-ascii?Q?vxYgZyZ93la+fBqkPj5S1i8c5MFY06HPu37iMvHvncAens/oanO0AZVQWyP4?=
 =?us-ascii?Q?WYRIeuHSDoWxb5l1sHOMjhRVIIcsI6lReiF7bIAVJuuYP3xWkbi8OZYq7ruD?=
 =?us-ascii?Q?I9sqSbNpgTVtlJeewXSIUL7+utRGE/Fn5vL2DZrTFDOCqOvrnRdFystZXo5z?=
 =?us-ascii?Q?67OA2xN1w0TAXYfR21iXKWGnlV1JdESyVVQVCiowCjZTM+e+6wC+QFsg7ki4?=
 =?us-ascii?Q?Q7Uy2eka93bbvw7XEVi+bqQL1WhCLfulZWWhax3K?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d05ba9-2ca9-45ee-1e7e-08dc164853e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2024 04:05:08.0886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHCXk+8JyUcK2wZrzBvZk3nhP7VMhG0cvw9FgbqyLxQv/ZVsZg0V3w3JM9YY7eejUpwfdYkCnHE2sa16H4wmFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7813
X-OriginatorOrg: intel.com

> From: Tian, Kevin
> Sent: Tuesday, January 16, 2024 8:46 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, January 16, 2024 12:31 AM
> >
> > On Tue, Jan 09, 2024 at 10:11:23AM +0800, Yan Zhao wrote:
> >
> > > > Well, for instance, when you install pages into the KVM the hypervi=
sor
> > > > will have taken kernel memory, then zero'd it with cachable writes,
> > > > however the VM can read it incoherently with DMA and access the
> > > > pre-zero'd data since the zero'd writes potentially hasn't left the
> > > > cache. That is an information leakage exploit.
> > >
> > > This makes sense.
> > > How about KVM doing cache flush before installing/revoking the
> > > page if guest memory type is honored?
> >
> > I think if you are going to allow the guest to bypass the cache in any
> > way then KVM should fully flush the cache before allowing the guest to
> > access memory and it should fully flush the cache after removing
> > memory from the guest.
>=20
> For GPU passthrough can we rely on the fact that the entire guest memory
> is pinned so the only occurrence of removing memory is when killing the
> guest then the pages will be zero-ed by mm before next use? then we
> just need to flush the cache before the 1st guest run to avoid informatio=
n
> leak.

Just checked your past comments. If there is no guarantee that the removed
pages will be zero-ed before next use then yes cache has to be flushed
after the page is removed from the guest. :/

>=20
> yes it's a more complex issue if allowing guest to bypass cache in a
> configuration mixing host mm activities on guest pages at run-time.
>=20
> >
> > Noting that fully removing the memory now includes VFIO too, which is
> > going to be very hard to co-ordinate between KVM and VFIO.
>=20

Probably we could just handle cache flush in IOMMUFD or VFIO type1
map/unmap which is the gate of allowing/denying non-coherent DMAs
to specific pages.

