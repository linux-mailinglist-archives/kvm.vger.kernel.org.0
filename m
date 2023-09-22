Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98337AB27D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 15:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbjIVNAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 09:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjIVNAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 09:00:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E93139
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:59:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RK8xUWMcDVWpDsMe9B9c40lshMHzf8KZl/TZM+V3UIzIY/HzTbWo68727saqcADs7Ms0qBntzOyuKbc0XdGL80mERcyt1nZqo3NvNKm+R7D3A4w7/iHEQCTTLXE8tzzZGmNy3YSrmHFfXo3e8q+jPhvehjDrExFFdmTeBVMTy+pC4CPxBqwd8ScXUFlrvvIau/27+CXQPhhWsGiGbBI4To0x2zjSnUtYDVzY00gNUCV8tcplT6TXkDLuvqsfq52fGOXUkZ4DpeWOm0IhE9BHZ6Yr6340YhcEP6jB8lu6EvJjGe/xTKyQ1iCGU3TTsFZRwBht0uOl06ouDElPrDjbag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu08pHM3uKOdm/WODPlgMXTMjLDASNDHm820VFExjrE=;
 b=DBAmxH5Ww4lC3FmfnUqusJcnUlqDCTbIrnEJiBH4VeYpNoxmt3Nu7EYn4kaaQQvMgfEJR2nOL6QNetiIYoZOMrnFFljfMxi+vfogZs8ajgYnA9MN6mZi1bfUThNRPkrGRhw2fLVGQy3VgtfHn3WxxYYbKTspYeNToHmE0L6UlSXHO13JvvBb0goW8tNajrAXKpSDvd22tC4enuFyxpje2cpeahQ4x7tz340HE3FGWgFgEAbzVmbmvGdM9CFT1a0bJysEzJfux3JcBNCybMG5G8PmYAOqtXPpMWJFGd0UPrDEO8+PuID/D/16S03c4ZkAYXV6T0jsUsMo5D8tihaZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu08pHM3uKOdm/WODPlgMXTMjLDASNDHm820VFExjrE=;
 b=qg7hRvdNxG3ZS24WON/ROG1qTX3sE5AhOODYjK76T6wkuorPO+JawVXxwW2LWSpeMgAzM7FJj5Y0WVl7eqKQZDz4TPIAksbpQGj/Guqn53m4LO7hwcMuffMbhjEjm9YR51ejqtdZBBfXWQNZjlpqGYFiYvt4xzku98ao06i5eeBWAH+Tdeg22QyXoV7G9s6Ml8tM79fa1LLP5h4KH7meSqxOYheg9kpMVQ9uPu+bslxvrWIdewSUJ3eSBELTa+S34LAbJ2n4HbHDpan1mueVdBnUg4MkxvvMQQKbyfJXtZmZUnHNrpJqf6Hh5kiUUZbuFajQMGHJmgHohNWOfOS3CA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM3PR12MB9389.namprd12.prod.outlook.com (2603:10b6:0:46::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.23; Fri, 22 Sep 2023 12:59:55 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::4002:4762:330c:a199%7]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 12:59:55 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: RE: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Topic: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Thread-Index: AQHZ7IkPl5ENqOgMC0yEzkOHANq/CLAlsuwAgAEXAQCAAAXCcA==
Date:   Fri, 22 Sep 2023 12:59:55 +0000
Message-ID: <PH0PR12MB54818AC9940CDEF6817DE4F4DCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921135832.020d102a.alex.williamson@redhat.com>
 <20230922123708.GA130749@nvidia.com>
In-Reply-To: <20230922123708.GA130749@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM3PR12MB9389:EE_
x-ms-office365-filtering-correlation-id: a474aae6-2e99-4417-8f60-08dbbb6bd151
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mIoHWOKGsavUonIBEb10OHr+QpqP5E4Dl49ZX7gzkhQWNXFGOxriGbheB3AS4VS6HQzJusUaN47D4eDuZyqgsDS64Ta9ReQ/Bsodp9k3nLKitkBv/QTuAUmn9OFQGKqd9RrcR00IPYDa+DlqqIOT/6sQwMEUM3Ri8IpTWUBs3TYU8DQjBafj6OAfUm/iXpqcDQFsROovjzGRvZrJmqrV9mqSl+wSjz3LzTQbtPFY7g1DGZF+neIt4Sw0urrFYKWlgyNb/V2IoM/b3K2js1c7m8CNb/CUV0wbBnmMmIFzaS45sjRS6uODs/T5EK35qZokcnEw1bg6X7p9e+PjnN+HTbr5vPTGnd+31n6gCSQcqgc7F3RqLyrChlfL5Lh/OjfZZaWxsaSg9ZIBJQvBhyqYiNqPnDS24IVPHauUBaNeXIjPw9cu+cR+RExNyXfyGq9H6ZrOyjow6PxhvIR3yj1LJqJtJ2GH5UnTAV2mfZ8DI6dDQIaA47/aQTfizwReKHowLvpng9gsOmjVFH2Wkq3WS1NNYUGv4wUxBZXLgV8mRe1goMaTuQSWepENloPB0yJMxPJQLCtmsSGQCTbM6baRaPVmGV78q1jTYb5z+KRQNutdjj9/3tYVWB4w/iTlfiB5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199024)(186009)(1800799009)(8676002)(8936002)(86362001)(38100700002)(52536014)(4326008)(5660300002)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003)(64756008)(110136005)(316002)(41300700001)(2906002)(33656002)(38070700005)(83380400001)(478600001)(55016003)(9686003)(122000001)(71200400001)(26005)(107886003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lxg5C3vd/V8KIT/nJn8y/Z3kRukfbSMSq19DeEjzNCD1gBdZGy1BrbiL1usu?=
 =?us-ascii?Q?wDlVsfuuHx4ebId5Ym+LRdDDIAUfLfFf7zNeqgufm9WtY6U1axmLCYA0lr9E?=
 =?us-ascii?Q?rSC8ATI0GF9B36FmOmScjaMOhfqRQAL9l2b8VtxvAZadGGqZEpiJ/K4QlpMy?=
 =?us-ascii?Q?YChj0YB+hU6zG+woVWS5oOsM8o/M3xF509VQe8GRPbzwLOWIoQ6pWNGlllUX?=
 =?us-ascii?Q?v9AUIjWBfgtfA1kGWsJkA409Y6PnrfVwZQ0ul/IaSoDT+PMUhSaX3rmUUFyU?=
 =?us-ascii?Q?cZ8f8krFaeIFJAu5RzPd7ufDwYkn01RGmupz4iiU6FJaFFPKfaefTnhYUvow?=
 =?us-ascii?Q?lFpaMNFB/+ik06Y6QlpxZ+dMlt1PxrGOtm+pDaOfNPYcQbF9ucJ6wtbZTqyL?=
 =?us-ascii?Q?BH8KEsL3MLtZPVcZnTbTWb2XKYXAEFhcj9DIMGXq2lK2HGO53WITNeuutJd+?=
 =?us-ascii?Q?R38knfkM2BKEwGnWqF7GFs4B/j1/IdtoaESsK6SgZPnF59gGuvL2oTPkzVcA?=
 =?us-ascii?Q?TBYh2IZApvA/7GYpSPlIBJZR/O1iOZoOnQNqq7hrDBafsYBcjIp+GDIeHgIz?=
 =?us-ascii?Q?xIM9IWsx3FTH5oOvRoiMOf0NV491LKspfeZ8fLsyOkGrsAFYW5C9ZmA3r+n6?=
 =?us-ascii?Q?OHwIitdF+FTSojVJIaFhZa93pa96Oc9Qs/XG9VMXMSVwykDEqMaKmqrSJCZC?=
 =?us-ascii?Q?Q9gscAc3syVnwqrzVL9x8qw+wV09sgFpALc1xIsU5V5tyw72ADDU3AfrgjfS?=
 =?us-ascii?Q?+uEUi/3Vb7t1HWmd7LQ4tnkbFVG0UHX7V2y93hokUSW4dJVe07/oe2moe5Lq?=
 =?us-ascii?Q?zWW2uePGoVpPxqhdjzp3JYaLFXo6OADoKNBUd+rGIvOQ3Q3zUl8WzPj8L5Vz?=
 =?us-ascii?Q?ub7UnBBoXpklqSdRFOj9VIvFZcb1qYY6m6tiqDCYyWyA+9Xgr6lQpoICdSUl?=
 =?us-ascii?Q?0W2vdOkfYdSHsgFC/BaJUtCbivvicbslJWZRFnUiqL/Hn2GDDnMZ4cIS5K1r?=
 =?us-ascii?Q?RgHJaq9Rtdcd1V6SShlewDfmmv3KTzVtL6+TjbsNDiuJB9Z4B3eEThp7baa2?=
 =?us-ascii?Q?PLYx6xAsS+H6lIuRvlgPrXUIRRFhVKp9wHaiyJk98gX6GqwI13vL8aW26yHU?=
 =?us-ascii?Q?gUkS8M7DvFcVBKgHAITiBxdRht+yhV5jcT6Zix1nHMWNHK7T0O0cWxnpYdUx?=
 =?us-ascii?Q?ZPFcv0B5mNXBtwsGvrnbysYxyf7wjBzBOLMCwE92pJozVyAPG5DyebJptUOm?=
 =?us-ascii?Q?N2uHKNC3429ue6mbJiETIJVQKMkAolaYtulZptUQPIjRyuymsxEZN/vvMtzr?=
 =?us-ascii?Q?Ga3LJiA5YO/VXyv22ItMhIOen0sj7AVbL/+OUD7o3ckDv8cfCstTYVJnjZtS?=
 =?us-ascii?Q?qFyja9H2IwhcH6FmCL+cT5jiawxtQKlsLGSfBdPTpkwAhQQKPZQKS6F7s+S3?=
 =?us-ascii?Q?vUfvW2LV+XC/tjEc37dOyw5DGHVcGN5yqV1hlpZrB1ty71UOJQTIhb2+5hbM?=
 =?us-ascii?Q?PVGL44vLi2iRh3+0/9NCaM1l4WwYDCjKX8HKdZtVJR3NeGyNOh/uXayNWQJu?=
 =?us-ascii?Q?9nlyv3Al+1wCAbS/VkE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a474aae6-2e99-4417-8f60-08dbbb6bd151
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 12:59:55.0308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uMC/yq1lf82nbnH4YKrpZ2aq6kZaHu7k+62TLjivR2/XQlvDzaqyZPYglg6DNRNH5/vMYyMoP9N4WGbK/yGgSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9389
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, September 22, 2023 6:07 PM
>=20
> On Thu, Sep 21, 2023 at 01:58:32PM -0600, Alex Williamson wrote:
>=20
> > If the heart of this driver is simply pretending to have an I/O BAR
> > where I/O accesses into that BAR are translated to accesses in the
> > MMIO BAR, why can't this be done in the VMM, ie. QEMU?
>=20
> That isn't exactly what it does, the IO bar access is translated into an =
admin
> queue command on the PF and excuted by the PCI function.
>=20
> So it would be difficult to do that in qemu without also somehow wiring u=
p
> qemu to access the PF's kernel driver's admin queue.
>=20
> It would have been nice if it was a trivial 1:1 translation to the MMIO b=
ar, but it
> seems that didn't entirely work with existing VMs. So OASIS standardized =
this
> approach.
>=20
> The bigger picture is there is also a live migration standard & driver in=
 the
> works that will re-use all this admin queue infrastructure anyhow, so the=
 best
> course is to keep this in the kernel.

Additionally in the future the AQ of the PF will also be used to provision =
the VFs (virtio OASIS calls them member devices), such framework also resid=
es in the kernel.
Such PFs are in use by the kernel driver.

+1 for keeping this framework in the kernel.
