Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B311D0B7
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 22:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfENUeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 16:34:19 -0400
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:40134
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbfENUeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 16:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUm2B6JSK1BUEX8vtK31Zs7TzjekHBfW1Q8Lj1202+g=;
 b=haSNr98tL7lFfdQUVJg5Y2cDo8zrgcqkeYWr8bdsn32vMhA2JrK6/A6vAfuDfPZNgqPPP3kDngx1RnkEAdbq7GqdImm7Yi+0tYPyaNW6r1oA6v/bOZ1AcBG3limB4PFTgIdxGHxyUkCVPOLv8gLfFdschk1Q6y0DauNjcQtBSDE=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2207.eurprd05.prod.outlook.com (10.169.133.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Tue, 14 May 2019 20:34:12 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1900.010; Tue, 14 May 2019
 20:34:12 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: RE: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Thread-Topic: [PATCHv2 08/10] vfio/mdev: Improve the create/remove sequence
Thread-Index: AQHU/6cMznXkHMKRl0CFAIkpWMX/sqZhgmuAgABOd4CAALynAIAAkxbwgAgGLjA=
Date:   Tue, 14 May 2019 20:34:12 +0000
Message-ID: <VI1PR0501MB227132A392D9CA41792AC44BD1080@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-9-parav@mellanox.com>
        <20190508190957.673dd948.cohuck@redhat.com>
        <VI1PR0501MB2271CFAFF2ACF145FDFD8E2ED1320@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190509110600.5354463c.cohuck@redhat.com>
 <VI1PR0501MB2271DD5EE143784B9F94D446D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
In-Reply-To: <VI1PR0501MB2271DD5EE143784B9F94D446D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0217f7b-be0a-4957-10e9-08d6d8ab863a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2207;
x-ms-traffictypediagnostic: VI1PR0501MB2207:
x-microsoft-antispam-prvs: <VI1PR0501MB2207C5EA2012F91F0D4AC4E5D1080@VI1PR0501MB2207.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:169;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(346002)(366004)(39860400002)(13464003)(189003)(199004)(51444003)(446003)(11346002)(71200400001)(99286004)(71190400001)(33656002)(4326008)(476003)(6436002)(54906003)(486006)(25786009)(74316002)(26005)(305945005)(186003)(9686003)(53546011)(76176011)(86362001)(6506007)(55016002)(7696005)(110136005)(229853002)(30864003)(316002)(68736007)(102836004)(66066001)(14444005)(3846002)(2906002)(52536014)(66476007)(66556008)(14454004)(64756008)(66446008)(5660300002)(6246003)(73956011)(256004)(53936002)(7736002)(478600001)(81166006)(8676002)(81156014)(76116006)(66946007)(8936002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2207;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aMriLYqMTgLfkGMse+uiMr7GsEjo+0QW06RglmqqUjplsSxyA9QFYPNlHXLTv5XMQeBTXXwXTnDCVytH074/ZPdHe/m3bJjTNvAlIwIhaCOoJJ8XiEH07N0dNtGIELXvydcMdMCBkd/ttDhq9AVYCzZEAfPeiW4U+6MeSC4qbqyc6vBKD9ArK8HLZydHWt82Ar9wUviChddUIdi3Wwxf/7gSmXXj+ieZJwvuluI82wh3mPCgv5IBM1F/Ml/XtSX3DgpM9foSCp5wM8J71iiu1GIAuN2uSONsIDvQRMC1bBhNlbuyeJr50hFtGe8cWIhljCfVQr2UXReARvXvgIxjPAnVQtAZnGCwSzs85iy31L+mZrIQvflD6F1640z4WYY/ZOj+Zu1dLfLs4R3XFfnVTd3I89KPlBjqGNZD2HAxZvw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0217f7b-be0a-4957-10e9-08d6d8ab863a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 20:34:12.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia,


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-
> owner@vger.kernel.org> On Behalf Of Parav Pandit
> Sent: Thursday, May 9, 2019 2:20 PM
> To: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com;
> Tony Krowiak <akrowiak@linux.ibm.com>; Pierre Morel
> <pmorel@linux.ibm.com>; Halil Pasic <pasic@linux.ibm.com>
> Subject: RE: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> sequence
>=20
>=20
>=20
> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Thursday, May 9, 2019 4:06 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com;
> > Tony Krowiak <akrowiak@linux.ibm.com>; Pierre Morel
> > <pmorel@linux.ibm.com>; Halil Pasic <pasic@linux.ibm.com>
> > Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> > sequence
> >
> > [vfio-ap folks: find a question regarding removal further down]
> >
> > On Wed, 8 May 2019 22:06:48 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >
> > > > -----Original Message-----
> > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > Sent: Wednesday, May 8, 2019 12:10 PM
> > > > To: Parav Pandit <parav@mellanox.com>
> > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > kwankhede@nvidia.com; alex.williamson@redhat.com;
> cjia@nvidia.com
> > > > Subject: Re: [PATCHv2 08/10] vfio/mdev: Improve the create/remove
> > > > sequence
> > > >
> > > > On Tue, 30 Apr 2019 17:49:35 -0500 Parav Pandit
> > > > <parav@mellanox.com> wrote:
> > > >
> > > > > This patch addresses below two issues and prepares the code to
> > > > > address 3rd issue listed below.
> > > > >
> > > > > 1. mdev device is placed on the mdev bus before it is created in
> > > > > the vendor driver. Once a device is placed on the mdev bus
> > > > > without creating its supporting underlying vendor device, mdev
> > > > > driver's
> > > > > probe()
> > > > gets triggered.
> > > > > However there isn't a stable mdev available to work on.
> > > > >
> > > > >    create_store()
> > > > >      mdev_create_device()
> > > > >        device_register()
> > > > >           ...
> > > > >          vfio_mdev_probe()
> > > > >         [...]
> > > > >         parent->ops->create()
> > > > >           vfio_ap_mdev_create()
> > > > >             mdev_set_drvdata(mdev, matrix_mdev);
> > > > >             /* Valid pointer set above */
> > > > >
> > > > > Due to this way of initialization, mdev driver who want to use
> > > > > the
> >
> > s/want/wants/
> >
> > > > > mdev, doesn't have a valid mdev to work on.
> > > > >
> > > > > 2. Current creation sequence is,
> > > > >    parent->ops_create()
> > > > >    groups_register()
> > > > >
> > > > > Remove sequence is,
> > > > >    parent->ops->remove()
> > > > >    groups_unregister()
> > > > >
> > > > > However, remove sequence should be exact mirror of creation
> > sequence.
> > > > > Once this is achieved, all users of the mdev will be terminated
> > > > > first before removing underlying vendor device.
> > > > > (Follow standard linux driver model).
> > > > > At that point vendor's remove() ops shouldn't failed because
> > > > > device is
> >
> > s/failed/fail/
> >
> > > > > taken off the bus that should terminate the users.
> >
> > "because taking the device off the bus should terminate any usage" ?
> >
> > > > >
> > > > > 3. When remove operation fails, mdev sysfs removal attempts to
> > > > > add the file back on already removed device. Following call
> > > > > trace [1] is
> > observed.
> > > > >
> > > > > [1] call trace:
> > > > > kernel: WARNING: CPU: 2 PID: 9348 at fs/sysfs/file.c:327
> > > > > sysfs_create_file_ns+0x7f/0x90
> > > > > kernel: CPU: 2 PID: 9348 Comm: bash Kdump: loaded Not tainted
> > > > > 5.1.0-rc6-vdevbus+ #6
> > > > > kernel: Hardware name: Supermicro SYS-6028U-TR4+/X10DRU-i+, BIOS
> > > > > 2.0b
> > > > > 08/09/2016
> > > > > kernel: RIP: 0010:sysfs_create_file_ns+0x7f/0x90
> > > > > kernel: Call Trace:
> > > > > kernel: remove_store+0xdc/0x100 [mdev]
> > > > > kernel: kernfs_fop_write+0x113/0x1a0
> > > > > kernel: vfs_write+0xad/0x1b0
> > > > > kernel: ksys_write+0x5a/0xe0
> > > > > kernel: do_syscall_64+0x5a/0x210
> > > > > kernel: entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > >
> > > > > Therefore, mdev core is improved in following ways.
> > > > >
> > > > > 1. Before placing mdev devices on the bus, perform vendor
> > > > > drivers creation which supports the mdev creation.
> >
> > "invoke the vendor driver ->create callback" ?
> >
> > > > > This ensures that mdev specific all necessary fields are
> > > > > initialized
> >
> > "that all necessary mdev specific fields are initialized" ?
> >
> > > > > before a given mdev can be accessed by bus driver.
> > > > > This follows standard Linux kernel bus and device model similar
> > > > > to other widely used PCI bus.
> >
> > "This follows standard practice on other Linux device model buses." ?
> >
> > > > >
> > > > > 2. During remove flow, first remove the device from the bus.
> > > > > This ensures that any bus specific devices and data is cleared.
> > > > > Once device is taken of the mdev bus, perform remove() of mdev
> > > > > from
> >
> > s/of/off/
> >
> > > > > the vendor driver.
> > > > >
> > > > > 3. Linux core device model provides way to register and auto
> > > > > unregister the device sysfs attribute groups at dev->groups.
> >
> > "The driver core provides a way to automatically register and
> > unregister sysfs attributes via dev->groups." ?
> >
> > > > > Make use of this groups to let core create the groups and
> > > > > simplify code to avoid explicit groups creation and removal.
> > > > >
> > > > > A below stack dump of a mdev device remove process also ensures
> > > > > that vfio driver guards against device removal already in use.
> > > > >
> > > > >  cat /proc/21962/stack
> > > > > [<0>] vfio_del_group_dev+0x216/0x3c0 [vfio] [<0>]
> > > > > mdev_remove+0x21/0x40 [mdev] [<0>]
> > > > > device_release_driver_internal+0xe8/0x1b0
> > > > > [<0>] bus_remove_device+0xf9/0x170 [<0>] device_del+0x168/0x350
> > > > > [<0>] mdev_device_remove_common+0x1d/0x50 [mdev] [<0>]
> > > > > mdev_device_remove+0x8c/0xd0 [mdev] [<0>]
> > remove_store+0x71/0x90
> > > > > [mdev] [<0>] kernfs_fop_write+0x113/0x1a0 [<0>]
> > > > > vfs_write+0xad/0x1b0 [<0>] ksys_write+0x5a/0xe0 [<0>]
> > > > > do_syscall_64+0x5a/0x210 [<0>]
> > > > > entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > > > > [<0>] 0xffffffffffffffff
> > > > >
> > > > > This prepares the code to eliminate calling device_create_file()
> > > > > in subsquent patch.
> >
> > I find this stack dump and explanation more confusing than enlightening=
.
> > Maybe just drop it?
> >
> > > >
> > > > I'm afraid I have a bit of a problem following this explanation,
> > > > so let me try to summarize what the patch does to make sure that I
> > > > understand it
> > > > correctly:
> > > >
> > > > - Add the sysfs groups to device->groups so that the driver core de=
als
> > > >   with proper registration/deregistration.
> > > > - Split the device registration/deregistration sequence so that som=
e
> > > >   things can be done between initialization of the device and hooki=
ng
> > > >   it up to the infrastructure respectively after deregistering it f=
rom
> > > >   the infrastructure but before giving up our final reference. In
> > > >   particular, this means invoking the ->create and ->remove callbac=
k in
> > > >   those new windows. This gives the vendor driver an initialized md=
ev
> > > >   device to work with during creation.
> > > > - Don't allow ->remove to fail, as the device is already removed fr=
om
> > > >   the infrastructure at that point in time.
> > > >
> > > You got all the points pretty accurate.
> >
> > Ok, good.
> >
> > >
> > > > >
> > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > ---
> > > > >  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------=
------
> > > > >  drivers/vfio/mdev/mdev_private.h |  2 +-
> > > > >  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
> > > > >  3 files changed, 27 insertions(+), 71 deletions(-)
> > > >
> > > > (...)
> >
> > > > > @@ -373,16 +330,15 @@ int mdev_device_remove(struct device
> *dev,
> > > > bool force_remove)
> > > > >  	mutex_unlock(&mdev_list_lock);
> > > > >
> > > > >  	type =3D to_mdev_type(mdev->type_kobj);
> > > > > +	mdev_remove_sysfs_files(dev, type);
> > > > > +	device_del(&mdev->dev);
> > > > >  	parent =3D mdev->parent;
> > > > > +	ret =3D parent->ops->remove(mdev);
> > > > > +	if (ret)
> > > > > +		dev_err(&mdev->dev, "Remove failed: err=3D%d\n",
> ret);
> > > >
> > > > I think carrying on with removal regardless of the return code of
> > > > the
> > > > ->remove callback makes sense, as it simply matches usual practice.
> > > > However, are we sure that every vendor driver works well with that?
> > > > I think it should, as removal from bus unregistration (vs. from
> > > > the sysfs
> > > > file) was always something it could not veto, but have you looked
> > > > at the individual drivers?
> > > >
> > > I looked at following drivers a little while back.
> > > Looked again now.
> > >
> > > drivers/gpu/drm/i915/gvt/kvmgt.c which clears the handle valid in
> > intel_vgpu_release(), which should finish first before remove() is invo=
ked.
> > >
> > > s390 vfio_ccw_mdev_remove() driver drivers/s390/cio/vfio_ccw_ops.c
> > remove() always returns 0.
> > > s39 crypo fails the remove() once vfio_ap_mdev_release marks kvm
> > > null,
> > which should finish before remove() is invoked.
> >
> > That one is giving me a bit of a headache (the ->kvm reference is
> > supposed to keep us from detaching while a vm is running), so let's cc:
> > the vfio-ap maintainers to see whether they have any concerns.
> >
> I probably wrote wrongly.
> vfio_ap_mdev_remove() fails if the VM is already running (i.e.
> vfio_ap_mdev_release() is not yet called).
>=20
> And if VM is running it guarded by the vfio_mdev driver which is the one
> who binds to the device mdev device.
> That is why I shown the above stack trace in the commit log, indicating t=
hat
> vfio driver is guarding it.
>=20
> > > samples/vfio-mdev/mbochs.c mbochs_remove() always returns 0.
> > >
> > > > >
> > > > > -	ret =3D mdev_device_remove_ops(mdev, force_remove);
> > > > > -	if (ret) {
> > > > > -		mdev->active =3D true;
> > > > > -		return ret;
> > > > > -	}
> > > > > -
> > > > > -	mdev_remove_sysfs_files(dev, type);
> > > > > -	device_unregister(dev);
> > > > > +	/* Balances with device_initialize() */
> > > > > +	put_device(&mdev->dev);
> > > > >  	mdev_put_parent(parent);
> > > > >
> > > > >  	return 0;
> > > >
> > > > I think that looks sane in general, but the commit message might
> > > > benefit from tweaking.
> > > Part of your description is more crisp than my commit message, I can
> > probably take snippet from it to improve?
> > > Or any specific entries in commit message that I should address?
> >
> > I have added some comments inline (mostly some wording tweaks).
> >
> > Feel free to take anything from my summary as well.

I want to send v3 addressing commit log comment and take updated descriptio=
n from Cornelia, if this 3 patches looks reasonable enough.
What do you think?
