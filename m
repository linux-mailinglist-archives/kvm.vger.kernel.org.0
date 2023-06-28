Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CBD740CAA
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 11:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjF1JZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 05:25:26 -0400
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:50752
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231824AbjF1H4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 03:56:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axT0IUP+Y4pRSNohenGNbEWqdVrmlmlUhhofU8HMr237+Mp+uR50iQoZf/9cs1doSKi8ybecMb2pqbShz0x0fABNQ77KRl/YdPRTiAg/PfrJ7HrcWZHY3MMM0nNaszsISEb9itZce5X++2zdXBvOr14PoF7fRUj5H6YavO0I39j22duGrDRq9Rnj9CFAXLuskZMAilyCZEOb/7FLWNCd2hKt3qaPhqLRIKjdBvHXIjMCQqnwI/P7fyadVpGQT0EuIa/IW67gQTOQNdcRKzZNEvrVMpyKrQQhvrnZmn7yRlPKYr4ZVHeh+XW9CqpV1p6uuuwsZKOkggwOmtZvitjuGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfcs+ltquahgPIxJkL+ckQnhWscaYAHJVhnIIvv3HwU=;
 b=F7vVWr6jU8y+aog5gFQYwoVOs69eFjWNaLMNb//CKK6d7u300w6kENiLP9wr4d2sjkm9jcH+2YvZEHxYjcmavqH5hV+deYd+fs/3Z10xi56PA3eW0pwcWJZ9Gq+mo5/hvFFEPyKFiwLfbFKN3q2WTNahFtHxTq918J01ZLHSqMFhqPAWNldWBPWzeCvVA4JyJ/UaqUHhj3TWPAgP5/6Y6yfNA0dX3uH3eW/193g0AJCu05xcvjtShcERjNnWkgQVqxsAIvR2Od6IVHDs7MT6cg2kGQBsIkUTgZEdWcCOTUMHec20U9Yp/s4qufshNvowxe7vSJzYZeNIHChTg5P31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfcs+ltquahgPIxJkL+ckQnhWscaYAHJVhnIIvv3HwU=;
 b=EJcRfseb8mTW7oA/EgQOUdC3HqYEINeqeb/+lVO4QZ5nx+AAJjIZ/Gcc4UkfpedCf6rs1gnU3naJobFrA9rpGwRQfz/GYerdGGGTtqRaKTAH80QaMG7akm27qxpxTZQc1oymKwhoGYME380nYlg/ML61sRi2A/uiIZilKNxYLEEbDefehJ0mFPz9jOJzeits0OVBZpavScmd05ljkoYEY1SoWQYfkNKydPxADpeaiMZYKuej1292HUYUr7vDfQGVmlJiRR1uL/NvYpIIVzJ8mlu5GJkxAFLQyoKT0QL8ZKQM2YiRCIhDM3T5pWUeBX5YSShz90XUNHxEW01xNFNmXg==
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Wed, 28 Jun
 2023 07:39:47 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::5bd7:bda4:3ce6:2eeb]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::5bd7:bda4:3ce6:2eeb%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 07:39:47 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: RE: [PATCH] vfio/mdev: Move the compat_class initialization to module
 init
Thread-Topic: [PATCH] vfio/mdev: Move the compat_class initialization to
 module init
Thread-Index: AQHZqDNKYwVXJ0w/tEKdivaIYavkq6+f1tWQ
Date:   Wed, 28 Jun 2023 07:39:47 +0000
Message-ID: <MN2PR12MB42061DB24FF650531A6E780CDC24A@MN2PR12MB4206.namprd12.prod.outlook.com>
References: <20230626133642.2939168-1-farman@linux.ibm.com>
In-Reply-To: <20230626133642.2939168-1-farman@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4206:EE_|MN2PR12MB4374:EE_
x-ms-office365-filtering-correlation-id: 04eca650-d74f-4dcd-42d4-08db77aad8f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MBdFlPceYTD5CgRa8d/1lSQpezKUzDZNNJx5Jjs//blibKbGqozJ/Y1JaG55tJDz6Fy+Y29IlvmzL1+1REd4KZmMlZ3DG2OcNPr7OFPo9bDzPcRp1saDkmZFt7B+mW+JOX302bfGmAoBto6CccVld4DoVIu0qMoMFAYIl6Zb04oF/3fvb7tMU3VACTwVZ3dnkvyLvPCE+1u48tUJ152WQ45S0SltHmpnevmSWKGqCsLquWiHjfx8Ejg/htTIrw4jC8euYD+tNnaZb0uoFMqg9nX1Pl16RNgyKVWCU+j+CLRU0PkzTF3v+obAGXwnqkJgjhfqp9Pfy5Pwwnze4Kr8/3FkIZrPIlgW+wEBOBE4UpUqiUZpUnkKnyHkp87geF4gCiK/8kJziDzV0+g1i44PdePyGlx4sZo41CHaE7RwCzDRLHNX7KfSkwibHcDoiMDtld+TMbKlEnKQnpVzrNdLXt+jDDqXU0eZ4STD6HsXWd56kd+QMRg1xFTBYDGKfM949DLsCcbnjhBk7tCue5gFg6azCJYe5wHg9LDzDZXbKriqGDFEJHAcATONLbQAI8ZhwzretRnbYnuL5pLFo4QYS/wztJlw62RTtse1aaFBsio0qgsjrlwsdL0Va730rpjn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(122000001)(38100700002)(38070700005)(83380400001)(33656002)(86362001)(54906003)(8936002)(7696005)(110136005)(41300700001)(71200400001)(66556008)(66446008)(66946007)(64756008)(55016003)(76116006)(66476007)(8676002)(316002)(53546011)(9686003)(4326008)(186003)(6506007)(2906002)(478600001)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cXk2PlCkUYs5fBb4qisHLm5GVe70PzNYE2EKzRcJcdKplPpEWV2+JhVtfza1?=
 =?us-ascii?Q?yhsxLdZrrFUf6IrnnvTtsXw27T2K2z472LKm7TTlH6QZI7sXjLJqpnN3UtxI?=
 =?us-ascii?Q?t2Jerv6vbDu0mgz+F3FSUgIPgamiF5dOMP510wrLcrG+sjS/bsflXbgotZ6U?=
 =?us-ascii?Q?MWC743QTVSOdb15HmZss4xXlvJF/gD4Xr6zq8ipwl2/zdqHIQ+PiV1e4nuIK?=
 =?us-ascii?Q?ypHKpbJXIpZUV08YcAXj5oHM+WrnyQ7MoUnJZ0rQ8Q7OGONBc74kVCbtuRNj?=
 =?us-ascii?Q?psUnXY3jZvI0RbRZNroAKcHsoW5GtLop5aytW9PcSlfO2akGmNlATMyk50Aj?=
 =?us-ascii?Q?wO0LCOt0KexkTKeJ+vL2pjVoIdyi55zL7fCExqs7LN4vGzxzbN1pbm72Wg0n?=
 =?us-ascii?Q?YWBmo5x8cyjRkwPH1szZKN9j3FJszcJiP+93X7Jb6LbACtSJZEhJHL9lSK/b?=
 =?us-ascii?Q?2r4p+bK5af3UFZqNrOFAKkaOISUqjZaKqD4zwblALtedMTrmT+oNK969btZq?=
 =?us-ascii?Q?C2LDvMRc2qkikvkXP46LNUilrGrO2U3wk+LKht3ChhMWOoCsA4h6ba0VeTEh?=
 =?us-ascii?Q?ApGFwWBuYzO+JBdJRrp5n7UjxGlJlsr1QRZBBYtt79csQv1/3JD7ZXLMLabX?=
 =?us-ascii?Q?zILkcSGWTWb3KuSACHLG3b+3SaJ8Xwmw2VZzeN4Ev8lvomD3D3URMD86xpov?=
 =?us-ascii?Q?nKplPvwSRYaSFYUsAMctIOhJGX24vCNJqOGfew0dOj12XyWwwtNSSeLeyhoI?=
 =?us-ascii?Q?0MF4S135by1QL6Rl8IFrsSFyj7tOsuJ8m7XriUqKdvMVmWekgDyY+dvSa+n0?=
 =?us-ascii?Q?YyEMVWW56EXRaww4mVvuX+R1Ckj/LRAtU26Dj4TEP1xmu8SXYv/69EkjRTCI?=
 =?us-ascii?Q?u+sl7hJc0QXpM+28BvuBO/DQS0dHCTlUTwvOFl83zmmU0CGXiZvGdYKlEnar?=
 =?us-ascii?Q?vXQm962xfDRx5j0oqfsMF1nAuD4Wlk8KL9NnDgEhzIgq7HkGWZClR7LFA+oZ?=
 =?us-ascii?Q?FyRjU/l16i6YRI0lpPkCH7qwJ8SEm7evzDVEa9p8niUzH6YQdRN5+8fOrGj2?=
 =?us-ascii?Q?no7MgosQPdteEEjAnIVorr5nEfhESygFSASq3NM7oU8yDgY/ci8fVnlqMC6U?=
 =?us-ascii?Q?xgIuejYBun26nTm17xSmVNbZVEPwm1z3JfhqmCtPcQc/mnpm3L+z7zsVs7mm?=
 =?us-ascii?Q?Otdc3zFjsXEDOXnW+qnvCfXRByFPtGCCJs741ZflWMRI0+8PI45uEe7wu+i/?=
 =?us-ascii?Q?ZMeNCOXcA+vX4KvX6m0K6s+XVnpgtKKI34KoZsf0HOmqkBOw86EFihtulgW3?=
 =?us-ascii?Q?zzeuHb10o+uvJ/jn+SsrhA2DjtdhfRA7fvEbXuEVBqUxDlwI5MqvDj/KkH3q?=
 =?us-ascii?Q?t2mzGOlasXRDoxfIoEAafz/RmRERvz3Jn2i8zneMLW6830TeZCgpJrStgKHq?=
 =?us-ascii?Q?bYJ4xwU9Wuqdws1F1F51dHISncW9YnulF4CtWLOQ/x4K1pOKlvF2hUShgB7V?=
 =?us-ascii?Q?VkWCz9iQIamgpVtY4Re1xwVsodN1n3BA02Tjrk8IHjN2VGuXp+O5U/Roqxjs?=
 =?us-ascii?Q?IqREWe2ODFS/55lh1fqjrhXa4D67117LZBsG4ALgm2JQf+ykR+nVZOFzYmq/?=
 =?us-ascii?Q?60hNfFn8QYHl92qy47ECvYP4IfuInhCVQDydv606pl2p?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04eca650-d74f-4dcd-42d4-08db77aad8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2023 07:39:47.0995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZAFc0FBFK7eLcsNJuqvG7F0DAL69CD98KDvHbCVFwFeLwdQQPhv7Z7SvdO8/mekbjj+jTQOXl0xPEHtYfSmKUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> -----Original Message-----
> From: Eric Farman <farman@linux.ibm.com>
> Sent: Monday, June 26, 2023 7:07 PM
> To: Kirti Wankhede <kwankhede@nvidia.com>; Alex Williamson
> <alex.williamson@redhat.com>; Christoph Hellwig <hch@lst.de>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>; Kevin Tian
> <kevin.tian@intel.com>; Jason Gunthorpe <jgg@nvidia.com>; Tony Krowiak
> <akrowiak@linux.ibm.com>; kvm@vger.kernel.org; Eric Farman
> <farman@linux.ibm.com>; Alexander Egorenkov <egorenar@linux.ibm.com>
> Subject: [PATCH] vfio/mdev: Move the compat_class initialization to modul=
e init
>=20
> The pointer to mdev_bus_compat_class is statically defined at the top
> of mdev_core, and was originally (commit 7b96953bc640 ("vfio: Mediated
> device Core driver") serialized by the parent_list_lock. The blamed
> commit removed this mutex, leaving the pointer initialization
> unserialized. As a result, the creation of multiple MDEVs in parallel
> (such as during boot) can encounter errors during the creation of the
> sysfs entries, such as:
>=20
>   [    8.337509] sysfs: cannot create duplicate filename '/class/mdev_bus=
'
>   [    8.337514] vfio_ccw 0.0.01d8: MDEV: Registered
>   [    8.337516] CPU: 13 PID: 946 Comm: driverctl Not tainted 6.4.0-rc7 #=
20
>   [    8.337522] Hardware name: IBM 3906 M05 780 (LPAR)
>   [    8.337525] Call Trace:
>   [    8.337528]  [<0000000162b0145a>] dump_stack_lvl+0x62/0x80
>   [    8.337540]  [<00000001622aeb30>] sysfs_warn_dup+0x78/0x88
>   [    8.337549]  [<00000001622aeca6>] sysfs_create_dir_ns+0xe6/0xf8
>   [    8.337552]  [<0000000162b04504>] kobject_add_internal+0xf4/0x340
>   [    8.337557]  [<0000000162b04d48>] kobject_add+0x78/0xd0
>   [    8.337561]  [<0000000162b04e0a>] kobject_create_and_add+0x6a/0xb8
>   [    8.337565]  [<00000001627a110e>] class_compat_register+0x5e/0x90
>   [    8.337572]  [<000003ff7fd815da>] mdev_register_parent+0x102/0x130 [=
mdev]
>   [    8.337581]  [<000003ff7fdc7f2c>] vfio_ccw_sch_probe+0xe4/0x178 [vfi=
o_ccw]
>   [    8.337588]  [<0000000162a7833c>] css_probe+0x44/0x80
>   [    8.337599]  [<000000016279f4da>] really_probe+0xd2/0x460
>   [    8.337603]  [<000000016279fa08>] driver_probe_device+0x40/0xf0
>   [    8.337606]  [<000000016279fb78>] __device_attach_driver+0xc0/0x140
>   [    8.337610]  [<000000016279cbe0>] bus_for_each_drv+0x90/0xd8
>   [    8.337618]  [<00000001627a00b0>] __device_attach+0x110/0x190
>   [    8.337621]  [<000000016279c7c8>] bus_rescan_devices_helper+0x60/0xb=
0
>   [    8.337626]  [<000000016279cd48>] drivers_probe_store+0x48/0x80
>   [    8.337632]  [<00000001622ac9b0>] kernfs_fop_write_iter+0x138/0x1f0
>   [    8.337635]  [<00000001621e5e14>] vfs_write+0x1ac/0x2f8
>   [    8.337645]  [<00000001621e61d8>] ksys_write+0x70/0x100
>   [    8.337650]  [<0000000162b2bdc4>] __do_syscall+0x1d4/0x200
>   [    8.337656]  [<0000000162b3c828>] system_call+0x70/0x98
>   [    8.337664] kobject: kobject_add_internal failed for mdev_bus with -=
EEXIST,
> don't try to register things with the same name in the same directory.
>   [    8.337668] kobject: kobject_create_and_add: kobject_add error: -17
>   [    8.337674] vfio_ccw: probe of 0.0.01d9 failed with error -12
>   [    8.342941] vfio_ccw_mdev aeb9ca91-10c6-42bc-a168-320023570aea: Addi=
ng
> to iommu group 2
>=20
> Move the initialization of the mdev_bus_compat_class pointer to the
> init path, to match the cleanup in module exit. This way the code
> in mdev_register_parent() can simply link the new parent to it,
> rather than determining whether initialization is required first.
>=20
> Fixes: 89345d5177aa ("vfio/mdev: embedd struct mdev_parent in the parent =
data
> structure")
> Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/mdev_core.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.=
c
> index 58f91b3bd670..ed4737de4528 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -72,12 +72,6 @@ int mdev_register_parent(struct mdev_parent *parent,
> struct device *dev,
>  	parent->nr_types =3D nr_types;
>  	atomic_set(&parent->available_instances, mdev_driver->max_instances);
>=20
> -	if (!mdev_bus_compat_class) {
> -		mdev_bus_compat_class =3D class_compat_register("mdev_bus");
> -		if (!mdev_bus_compat_class)
> -			return -ENOMEM;
> -	}
> -
>  	ret =3D parent_create_sysfs_files(parent);
>  	if (ret)
>  		return ret;
> @@ -251,13 +245,24 @@ int mdev_device_remove(struct mdev_device *mdev)
>=20
>  static int __init mdev_init(void)
>  {
> -	return bus_register(&mdev_bus_type);
> +	int ret;
> +
> +	ret =3D bus_register(&mdev_bus_type);
> +	if (ret)
> +		return ret;
> +
> +	mdev_bus_compat_class =3D class_compat_register("mdev_bus");
> +	if (!mdev_bus_compat_class) {
> +		bus_unregister(&mdev_bus_type);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
>  }
>=20
>  static void __exit mdev_exit(void)
>  {
> -	if (mdev_bus_compat_class)
> -		class_compat_unregister(mdev_bus_compat_class);
> +	class_compat_unregister(mdev_bus_compat_class);
>  	bus_unregister(&mdev_bus_type);
>  }
>=20
> --
> 2.39.2

Reviewed By: Kirti Wankhede <kwankhede@nvidia.com>


