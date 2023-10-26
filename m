Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD37D8654
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 17:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjJZP4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 11:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjJZP4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 11:56:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71AD10A
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgluBz/nhivnZ/SZu3VVZTX4jDrKqyoSLwTQlAvt9bDtEd2dMrOM02rcpHBGLP+7/PKjXudAl2aGCkVI5ikoWkAQtMeYWGZERys2g2ynBgjzuLyrh3OE/5icqwSa6TelEEv9lHUIeR2CJUm8X+KKLLwXOGurG0p8bGzIfqrfRmgNpsqUph8tfuVXMuhqxBIUhcyjkC6eGbOkAn7jtf7YgDpYk2hdQ1z4nEEATL7J6Uz2+JY8DZ8LU353zgOeQuU4BCQPjRDkAk0SoUYwgZz2qOL4UISpjaOUdXEgM8wM/Pn/i/5U3GN2Z/Han4TjlirdNtftdk7rIBGdyp6BuDnj0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1lrMKUgybX4g4sLbmQfu5XHsQ7a3pV9zqe8vAlLPcE=;
 b=c3U605oL3P4PVUEA1zUo0YgIoatoQZwkFRNEwgkiUAS2lWsRt3ZLKivFI4Hct2Tro0NPmjYWgeM3P+KaUdAjfdGuH97GLSnceYUXdm3e3rrtgaTCn+j3u/LBPTHEkQMXFaO2bXICnWIclzoceZbedG+O2/7y+NIQ8y8l9zmZqsNOIMA1kMNBAhRHuhIfEWjN/S2DBTnEqxz/29k4pu7nAQvN46UhdrswCJpL10lB94fKciodo3bMNkDAvLpHom9Lf6vjPr+232/aiKlYZXKdMhvz/swXdJilRSOXq7T1M2/pHeAeVssxxstkdKG165YJhtGAdGTLpDGlHUig4uv/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1lrMKUgybX4g4sLbmQfu5XHsQ7a3pV9zqe8vAlLPcE=;
 b=DJLPcwPpgLrMNopL6anfA6iBtD18MzcHbE7DwiMe8zEPTwPqXmwsp9q1I307C3yDRBi7C8l46ykDVRNDw2CEogyvjJLxR0vmIStnktTeqtegcKLFLGEkQl+0n5XGs+aagqHtv/PbMdc58LLKcgIMJ/KHhyew+GIB9pdX0KD0PeqG2YuLECtnU3kELuf7hqssDaJMFEJ6YMepxn08o6i3mZv7L+ByVFPunDnoP6k0BBUj5OA/tPJSzErZqFLMhKAX4WKmK5xyN3Ftj6i/pNO6LyC0RTGfgNf/oSx3kr0MKBxDEq9MXmLTovhHRgvrWdmMKvSMX8CdPoLjQfafuHB2Bw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Thu, 26 Oct
 2023 15:56:37 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::cdcb:e909:74a4:be7c%4]) with mapi id 15.20.6933.022; Thu, 26 Oct 2023
 15:56:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHaAP/t3dG05nYg50S7FQsh4+CEA7BZZo+AgAE4i4CAAE2RAIABG4MAgAABLoCAAAcq0IAACmMAgAACvMCAABw+AIAAADOAgAALAoCAAAJmoA==
Date:   Thu, 26 Oct 2023 15:56:36 +0000
Message-ID: <PH0PR12MB548152F168B06A94A4E2DB11DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20231024135713.360c2980.alex.williamson@redhat.com>
 <d6c720a0-1575-45b7-b96d-03a916310699@nvidia.com>
 <20231025131328.407a60a3.alex.williamson@redhat.com>
 <a55540a1-b61c-417b-97a5-567cfc660ce6@nvidia.com>
 <20231026081033-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481E1AF869C1296B987A34BDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026091459-mutt-send-email-mst@kernel.org>
 <PH0PR12MB548167D2A92F3D10E4F02E93DCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026110426-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54819C408A120436010F608FDCDDA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231026112804-mutt-send-email-mst@kernel.org>
In-Reply-To: <20231026112804-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SJ2PR12MB9086:EE_
x-ms-office365-filtering-correlation-id: 0011391b-45cd-45a8-7b20-08dbd63c2283
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KO/1kdU7KpNJgIeelsE3EAGbFE/Vm5aZPecjcR7BRU+dvWzfl4+/FVzrY85YzTbJ86cilx6Os8kooyZ80cx43tT5Llp2rKWW51IGcDOG0u/PZSOjR2uaEVl0Ipzb660kUDqV3bpcf2Mz58+IQzj1YgNGqxmoxlVv3wEVQcMJ6z3bK2zL2ObAmZEEk2/NUJ9TARqOBi45lZLQbJU+bYn3ltkzwtrNoC8hJQuPCZnqzbVEnvvOC/6Al4aGmDiouGkciAVkfYZkbJcaFKHTQjKN1aY9mLURYKEJzDapBzX1u0Qi3hRKY5/wktsgA2bnIgwZlzZAKrUbOut3TQFHgjRo1xY6yfHnl5XiXCofZwIDzBcyYewJ/6fYyAUoJRidaC5vcIWTHR5YFgeKVi4X2agB8IwOEggY/Qz5VaN4eujgzxcI5SzbOGB9nY73dxSCHEkmnW4nlyFNai0wZnoadTGMljqO7anVHkvh911/rO8BaAcPAcPwQUujha2Qc7kWk3MbJQLSDEnozmTOOLee8inGFUbb4fd2s/jI62Kc8+YiPkq8nrsF96If1F3QFNIad/kf9gK9uIf2QYzle2Hi+tvJjC5qUO44PO+OhAnPcC/5ixCRz3wXk3fjqyqiMTefua7yVwk1VMIwxu3Ve/C3p1eEqhqJU6XsQJoJsCqkOGXFf1A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(346002)(136003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(33656002)(38100700002)(2906002)(86362001)(83380400001)(55016003)(107886003)(5660300002)(9686003)(41300700001)(122000001)(76116006)(66556008)(66476007)(66446008)(64756008)(54906003)(66946007)(6916009)(316002)(52536014)(71200400001)(7696005)(6506007)(38070700009)(8676002)(966005)(26005)(478600001)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lrnBABqYeZTHGLz7kXBQl7Rk3kMIs6l9bTKuAfOT2Evyvo8b5Kg7bdzWgOF0?=
 =?us-ascii?Q?UFy5LNnfYSB7DamZyhFq42LkeG4JR9ghHjvA2hcJ6a2dj2VKLgoo1hjxP34D?=
 =?us-ascii?Q?/ER2vl7ZVVRFPxs4KpVs1x8Rn41THqwMltp+I94PFyiuA0nlZybVMojvOZAC?=
 =?us-ascii?Q?66jaDQ6GToVEaT22+lp5sDO/S9yZ+b3n1fhmAdpcDWc/EbNVOjtpH4UKoT5p?=
 =?us-ascii?Q?Xq8n9VQpb3Qwr4imth6DZXrn2oArlOuzf/ll98/a5uaWae4yg8nmdgB3Q57k?=
 =?us-ascii?Q?E4BtWL13F8YjY0agjJmheqZjQS3IMtG6Q0ZtjmePebc9DI+gn/mEFAFFaNi1?=
 =?us-ascii?Q?b2KT4AyvzFslwjkz5ZYiBuxAz1ACwoa//eDY/TCxtNA9o+USBToyCh4xpkZk?=
 =?us-ascii?Q?cVJXaqBhXSgZsPOJLtu7qn/nE1xLHlqAiughFG+3V17ihCgMYFkslk/viYX7?=
 =?us-ascii?Q?fmeP4pq+wn3jMd1K5CHRpA9HtTWhm04VzVEUj2NoG3ESCE212XP6Gllw8dCC?=
 =?us-ascii?Q?xoHVPeOYOJ1G/hQ0rLmy5anOCOTByzUkSu4teAnRFCrg2bLuHHAL7O59dcc/?=
 =?us-ascii?Q?1D24zHdDzETZlul+aqVTzbwbFjR8tNomcbVXJ0lgEYjz05uyQljMDJ3M9l88?=
 =?us-ascii?Q?1mv5KIZfNqfnvuQTUM35seVtEGN5fVvz03dU4EzuRHZF5AK3Ha+FTnR92mcD?=
 =?us-ascii?Q?wpOnQMhS4Ta3zJREgYnj+/O8MPKyonhN5dIgnGoI/T95o5LYhPhfMhwpTJwA?=
 =?us-ascii?Q?XaRkTyQKqShMbH8QDdWphfTS62IRWYySeNLDq3PoLoDsiUZmgXhL13Q4M2GD?=
 =?us-ascii?Q?4H5KYNQ7vkq98ZfQqeUEPXqZ6RyFDBsGaXwD/pizIIxFUhMeEE3x19woAC0Q?=
 =?us-ascii?Q?T3cKclci8w5jwBiBBDnAuNnKerwIP/hRnXH5bbsBFjnp6a6xdKcVqDIHUupr?=
 =?us-ascii?Q?whX5LHE8DI1xUJK14AcCD+crmQ+6jYXaIyGSSigmSeZCoe61eyCzUjhtSqqy?=
 =?us-ascii?Q?lGKt/oXRvthqU84KeJ2WD18mJsXRK+vCtw+MRbSdQaZyJUcNFfiBg/mPKMYv?=
 =?us-ascii?Q?w5D3jqp8SoKI5pL27O+nv/08sMIAr/QMoSSIv//m+UtiSOQoMSu+3xV5uFS4?=
 =?us-ascii?Q?4vCDllM5Dm4TWFxysrgrA4l3ZzNrZ4AbCAgJL2aCLXj3zruDreOtHFkWDGVo?=
 =?us-ascii?Q?itG2snrTpHkFuXNCxNOSaxxa+5D3ShSacw0Ty5hug7wnGVWlFc4MVkW/dw+9?=
 =?us-ascii?Q?Tsft+lGrSu/PvsDJZq6h7fXWHsDkcKA5onPow5iGUQOJwwZYsm1rxtlkMFFu?=
 =?us-ascii?Q?0N5MnkGb60C7MEaMm4fNcQEp8g6VtwKBcerdSHhTCQz26vAQ3Y4rHGjSCksk?=
 =?us-ascii?Q?JTsFlSv2FJ6+pfmsVVjKqL06hE1vI1TC3qXhE8mWW7O5NeotvThznhc8shJA?=
 =?us-ascii?Q?rcVOCAt0R5UXN5XFo61XxkCsLzay1YXDcRq3OwT1eLTsNAYRQDMCruJ9WwQo?=
 =?us-ascii?Q?Mfu/VaxMTc/ok2An2kO7jXWAicMIoEUOmyK3qIea3OqVpMKuNANL+M4sMkbK?=
 =?us-ascii?Q?Exq9CcPxbunEp3FJ+FM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0011391b-45cd-45a8-7b20-08dbd63c2283
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2023 15:56:36.7921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MvPTyhgiegbD+Ft7FrXEN6APKz6Mx/acenQtKsNa+SNYHfNUKIh0rvtIYD/M8/wSqWJLH3D29q56bAnFnKz0sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Michael S. Tsirkin <mst@redhat.com>
> Sent: Thursday, October 26, 2023 9:16 PM

> On Thu, Oct 26, 2023 at 03:09:13PM +0000, Parav Pandit wrote:
> >
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Thursday, October 26, 2023 8:36 PM
> > >
> > > On Thu, Oct 26, 2023 at 01:28:18PM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > Sent: Thursday, October 26, 2023 6:45 PM
> > > >
> > > > > > Followed by an open coded driver check for 0x1000 to 0x103f ran=
ge.
> > > > > > Do you mean windows driver expects specific subsystem vendor
> > > > > > id of
> > > 0x1af4?
> > > > >
> > > > > Look it up, it's open source.
> > > >
> > > > Those are not OS inbox drivers anyway.
> > > > :)
> > >
> > > Does not matter at all if guest has drivers installed.
> > > Either you worry about legacy guests or not.
> > >
> > So, Linux guests have inbox drivers, that we care about and they seems =
to be
> covered, right?
> >
> > >
> > > > The current vfio driver is following the virtio spec based on
> > > > legacy spec, 1.x
> > > spec following the transitional device sections.
> > > > There is no need to do something out of spec at this point.
> > >
> > > legacy spec wasn't maintained properly, drivers diverged sometimes
> > > significantly. what matters is installed base.
> >
> > So if you know the subsystem vendor id that Windows expects, please
> > share, so we can avoid playing puzzle game. :) It anyway can be reporte=
d by
> the device itself.
>=20
> I don't know myself offhand. I just know it's not so simple. Looking at t=
he source
> for network drivers I see:
>=20
> %kvmnet6.DeviceDesc%    =3D kvmnet6.ndi,
> PCI\VEN_1AF4&DEV_1000&SUBSYS_0001_INX_SUBSYS_VENDOR_ID&REV_00,
> PCI\VEN_1AF4&DEV_1000
>=20
Yeah, I was checking the cryptic notation at https://github.com/virtio-win/=
kvm-guest-drivers-windows/tree/master

>=20
> So the drivers will:
> A. bind with high priority to subsystem vendor ID used when drivers where=
 built.
>    popular drivers built and distributed for free by Red Hat have 1AF4 B.=
 bind
> with low priority to any subsystem device/vendor id as long as
>    vendor is 1af4 and device is 1000
>=20
>=20
> My conclusions:
> - you probably need a way to tweak subsystem vendor id in software
> - default should probably be 1AF4 not whatever actual device uses
Ok.
It is not mandatory but, if you and Alex are ok to also tweak the subsystem=
 vendor id, it seems fine to me. It does not hurt anything.
