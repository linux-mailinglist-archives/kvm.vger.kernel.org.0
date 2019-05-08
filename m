Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5A181EB
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 00:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbfEHWGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 18:06:54 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:27223
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726837AbfEHWGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 18:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSdSc6L9tIzoHZJxGXHoLstHmkg0gdPd5Fmw98bxymw=;
 b=CCeeoIxH9I4cbgRHc2o4PllXjPa4q0NlQVl/dLSUBnXvLLFu7+fxC8oadXNeNHQX0zptXM2d27M8mQpAVo+wMIoXF5MeRnjnp+tn+Q4w+trsA+Ko/z8oaDqCRKxyy9onJpMNO4cHX38MZts8BtO/iy05etZIUNBgoPDe6t1V0FM=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2637.eurprd05.prod.outlook.com (10.172.13.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Wed, 8 May 2019 22:06:48 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1878.019; Wed, 8 May 2019
 22:06:48 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Thread-Topic: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Thread-Index: AQHU/6cMznXkHMKRl0CFAIkpWMX/sqZhgmuAgABOd4A=
Date:   Wed, 8 May 2019 22:06:48 +0000
Message-ID: <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-9-parav@mellanox.com>
 <20190508190957.673dd948.cohuck@redhat.com>
In-Reply-To: <20190508190957.673dd948.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 765a47f4-757f-49ef-a24f-08d6d40177b2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2637;
x-ms-traffictypediagnostic: VI1PR0501MB2637:
x-microsoft-antispam-prvs: <VI1PR0501MB2637A6F6DAFB754E6323F8A3D1320@VI1PR0501MB2637.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(346002)(396003)(189003)(199004)(13464003)(51444003)(5660300002)(52536014)(7696005)(99286004)(229853002)(478600001)(76176011)(68736007)(8936002)(53546011)(6916009)(11346002)(102836004)(476003)(446003)(9686003)(54906003)(316002)(55016002)(81166006)(81156014)(33656002)(53936002)(8676002)(73956011)(486006)(26005)(6436002)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(14454004)(86362001)(4326008)(66066001)(6246003)(25786009)(186003)(6506007)(2906002)(7736002)(305945005)(256004)(14444005)(71190400001)(71200400001)(6116002)(3846002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2637;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wGuOUAy80Q3SNlSipPRYh5TNOUBQHrvXO9ghy1LGcQFhcEvThjnbMSdl8Otr73wCYl0Px0K/uI6MfZKaFLc9mAPnJRpHQG89C7iFPxO9u+whVnP93isgsNT1uywHV/cQEldLWBkzdmsX7fS7YaLpl+Aw9G5AgaTk3ipQTjsVpy6WfK8PSBXTv9h95LNrKg/ipsj8C47kLR7vhjrAhtrjN4MasCp65LU7z1iwD1LhnT6xm+hVNnHX0oOlfvpA8pKqGHXm8i8mtH9DhiQQ+2dMmQ1B5hSnaiviY1iv13oCwo3tE1ut8DFkFmPub8n2O/5POaJsZid4GRDsuOJr+5xtl/n2seWXIc8oa0oyzhR1u0QmF2VBqVIEFnxidB/dZhOIEglb4f/92hCo1f7iRXfqfCljjqgHFda5VnIwToRlGt4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765a47f4-757f-49ef-a24f-08d6d40177b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 22:06:48.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2637
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, May 8, 2019 12:10 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> sequence
>=20
> On Tue, 30 Apr 2019 17:49:35 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > This patch addresses below two issues and prepares the code to address
> > 3rd issue listed below.
> >
> > 1. mdev device is placed on the mdev bus before it is created in the
> > vendor driver. Once a device is placed on the mdev bus without
> > creating its supporting underlying vendor device, mdev driver's probe()
> gets triggered.
> > However there isn't a stable mdev available to work on.
> >
> >    create_store()
> >      mdev_create_device()
> >        device_register()
> >           ...
> >          vfio_mdev_probe()
> >         [...]
> >         parent->ops->create()
> >           vfio_ap_mdev_create()
> >             mdev_set_drvdata(mdev, matrix_mdev);
> >             /* Valid pointer set above */
> >
> > Due to this way of initialization, mdev driver who want to use the
> > mdev, doesn't have a valid mdev to work on.
> >
> > 2. Current creation sequence is,
> >    parent->ops_create()
> >    groups_register()
> >
> > Remove sequence is,
> >    parent->ops->remove()
> >    groups_unregister()
> >
> > However, remove sequence should be exact mirror of creation sequence.
> > Once this is achieved, all users of the mdev will be terminated first
> > before removing underlying vendor device.
> > (Follow standard linux driver model).
> > At that point vendor's remove() ops shouldn't failed because device is
> > taken off the bus that should terminate the users.
> >
> > 3. When remove operation fails, mdev sysfs removal attempts to add the
> > file back on already removed device. Following call trace [1] is observ=
ed.
> >
> > [1] call trace:
> > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > sysfs_create_file_ns+0x7f/0x90
> > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > 5.1.0-rc6-vdevbus+ #6
> > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b
> > 08/09/2016
> > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > kernel: Call Trace:
> > kernel: remove_store+0xdc/0x100 [mdev]
> > kernel: kernfs_fop_write+0x113/0x1a0
> > kernel: vfs_write+0xad/0x1b0
> > kernel: ksys_write+0x5a/0xe0
> > kernel: do_syscall_64+0x5a/0x210
> > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Therefore, mdev core is improved in following ways.
> >
> > 1. Before placing mdev devices on the bus, perform vendor drivers
> > creation which supports the mdev creation.
> > This ensures that mdev specific all necessary fields are initialized
> > before a given mdev can be accessed by bus driver.
> > This follows standard Linux kernel bus and device model similar to
> > other widely used PCI bus.
> >
> > 2. During remove flow, first remove the device from the bus. This
> > ensures that any bus specific devices and data is cleared.
> > Once device is taken of the mdev bus, perform remove() of mdev from
> > the vendor driver.
> >
> > 3. Linux core device model provides way to register and auto
> > unregister the device sysfs attribute groups at dev->groups.
> > Make use of this groups to let core create the groups and simplify
> > code to avoid explicit groups creation and removal.
> >
> > A below stack dump of a mdev device remove process also ensures that
> > vfio driver guards against device removal already in use.
> >
> >  cat /proc/21962/stack
> > [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio] [<0>]
> > mdev_remove+0x21/0x40 [mdev] [<0>]
> > device_release_driver_internal+0xe8/0x1b0
> > [<0>] bus_remove_device+0xf9/0x170
> > [<0>] device_del+0x168/0x350
> > [<0>] mdev_device_remove_common+0x1d/0x50 [mdev] [<0>]
> > mdev_device_remove+0x8c/0xd0 [mdev] [<0>] remove_store+0x71/0x90
> > [mdev] [<0>] kernfs_fop_write+0x113/0x1a0 [<0>] vfs_write+0xad/0x1b0
> > [<0>] ksys_write+0x5a/0xe0 [<0>] do_syscall_64+0x5a/0x210 [<0>]
> > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > [<0>] 0xffffffffffffffff
> >
> > This prepares the code to eliminate calling device_create_file() in
> > subsquent patch.
>=20
> I'm afraid I have a bit of a problem following this explanation, so let m=
e try
> to summarize what the patch does to make sure that I understand it
> correctly:
>=20
> - Add the sysfs groups to device->groups so that the driver core deals
>   with proper registration/deregistration.
> - Split the device registration/deregistration sequence so that some
>   things can be done between initialization of the device and hooking
>   it up to the infrastructure respectively after deregistering it from
>   the infrastructure but before giving up our final reference. In
>   particular, this means invoking the ->create and ->remove callback in
>   those new windows. This gives the vendor driver an initialized mdev
>   device to work with during creation.
> - Don't allow ->remove to fail, as the device is already removed from
>   the infrastructure at that point in time.
>=20
You got all the points pretty accurate.

> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
> >  drivers/vfio/mdev/mdev_private.h |  2 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
> >  3 files changed, 27 insertions(+), 71 deletions(-)
>=20
> (...)
>=20
> > @@ -310,41 +265,43 @@ int mdev_device_create(struct kobject *kobj,
> >
> >  	mdev->parent =3D parent;
> >
> > +	device_initialize(&mdev->dev);
> >  	mdev->dev.parent  =3D dev;
> >  	mdev->dev.bus     =3D &mdev_bus_type;
> >  	mdev->dev.release =3D mdev_device_release;
> >  	dev_set_name(&mdev->dev, "%pUl", uuid);
> > +	mdev->dev.groups =3D parent->ops->mdev_attr_groups;
>=20
> I like that, that makes things much easier.
>=20
True.

> > +	mdev->type_kobj =3D kobj;
> >
> > -	ret =3D device_register(&mdev->dev);
> > -	if (ret) {
> > -		put_device(&mdev->dev);
> > -		goto mdev_fail;
> > -	}
> > +	ret =3D parent->ops->create(kobj, mdev);
> > +	if (ret)
> > +		goto ops_create_fail;
> >
> > -	ret =3D mdev_device_create_ops(kobj, mdev);
> > +	ret =3D device_add(&mdev->dev);
> >  	if (ret)
> > -		goto create_fail;
> > +		goto add_fail;
> >
> >  	ret =3D mdev_create_sysfs_files(&mdev->dev, type);
> > -	if (ret) {
> > -		mdev_device_remove_ops(mdev, true);
> > -		goto create_fail;
> > -	}
> > +	if (ret)
> > +		goto sysfs_fail;
> >
> > -	mdev->type_kobj =3D kobj;
> >  	mdev->active =3D true;
> >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> >
> >  	return 0;
> >
> > -create_fail:
> > -	device_unregister(&mdev->dev);
> > +sysfs_fail:
> > +	device_del(&mdev->dev);
> > +add_fail:
> > +	parent->ops->remove(mdev);
> > +ops_create_fail:
> > +	put_device(&mdev->dev);
> >  mdev_fail:
> >  	mdev_put_parent(parent);
> >  	return ret;
> >  }
> >
> > -int mdev_device_remove(struct device *dev, bool force_remove)
> > +int mdev_device_remove(struct device *dev)
> >  {
> >  	struct mdev_device *mdev, *tmp;
> >  	struct mdev_parent *parent;
> > @@ -373,16 +330,15 @@ int mdev_device_remove(struct device *dev,
> bool force_remove)
> >  	mutex_unlock(&mdev_list_lock);
> >
> >  	type =3D to_mdev_type(mdev->type_kobj);
> > +	mdev_remove_sysfs_files(dev, type);
> > +	device_del(&mdev->dev);
> >  	parent =3D mdev->parent;
> > +	ret =3D parent->ops->remove(mdev);
> > +	if (ret)
> > +		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
>=20
> I think carrying on with removal regardless of the return code of the
> ->remove callback makes sense, as it simply matches usual practice.
> However, are we sure that every vendor driver works well with that? I thi=
nk
> it should, as removal from bus unregistration (vs. from the sysfs
> file) was always something it could not veto, but have you looked at the
> individual drivers?
>=20
I looked at following drivers a little while back.
Looked again now.

drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in intel_vgp=
u_release(), which should finish first before remove() is invoked.

s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c remove()=
 always returns 0.
s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm null, whic=
h should finish before remove() is invoked.
samples/vfio-mdev/mbochs.c mbochs_remove() always returns 0.

> >
> > -	ret =3D mdev_device_remove_ops(mdev, force_remove);
> > -	if (ret) {
> > -		mdev->active =3D true;
> > -		return ret;
> > -	}
> > -
> > -	mdev_remove_sysfs_files(dev, type);
> > -	device_unregister(dev);
> > +	/* Balances with device_initialize() */
> > +	put_device(&mdev->dev);
> >  	mdev_put_parent(parent);
> >
> >  	return 0;
>=20
> I think that looks sane in general, but the commit message might benefit
> from tweaking.
Part of your description is more crisp than my commit message, I can probab=
ly take snippet from it to improve?
Or any specific entries in commit message that I should address?
