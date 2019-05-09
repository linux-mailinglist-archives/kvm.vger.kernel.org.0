Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6797918D9B
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 18:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfEIQDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 12:03:53 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:39870
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726469AbfEIQDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 12:03:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWG2+XPaKjij3YbTcNc0fne8Viz99AMX0aeVdfbYeKM=;
 b=Fbt7IFFddcW5XO1QOq3+oDRCbFNYRDW3mA8qin/jfgG02zGVZKKAcdCjiUshtvRyXO6z39sYxeEAYNzATzEZLYsFN8xxCa1NBzDZ+L0U/rBRB0xiXghRkyIchWCJ1WTotsS6ZAvVfqyKgeZ3Zt2KOFk4o16tTCXTlg/WnQPdjDE=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2797.eurprd05.prod.outlook.com (10.172.15.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.20; Thu, 9 May 2019 16:03:47 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1878.022; Thu, 9 May 2019
 16:03:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHU/6cO6K7GzrI04UmIa4WtImP3kqZiI2OAgADVKSA=
Date:   Thu, 9 May 2019 16:03:47 +0000
Message-ID: <VI1PR0501MB2271FF4628CCBE945BEB40F0D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-11-parav@mellanox.com>
 <20190508204605.17294a7d@x1.home>
In-Reply-To: <20190508204605.17294a7d@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 952ec7fb-5a2d-476e-3b3f-08d6d497eb5b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2797;
x-ms-traffictypediagnostic: VI1PR0501MB2797:
x-microsoft-antispam-prvs: <VI1PR0501MB2797F91ADA7A0579233F0188D1330@VI1PR0501MB2797.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(396003)(346002)(13464003)(51444003)(199004)(189003)(14454004)(54906003)(478600001)(76116006)(102836004)(53546011)(6506007)(7696005)(76176011)(99286004)(52536014)(66476007)(66556008)(64756008)(66446008)(73956011)(66946007)(74316002)(6116002)(3846002)(86362001)(53936002)(2906002)(305945005)(316002)(7736002)(68736007)(8676002)(81156014)(81166006)(8936002)(66066001)(6916009)(6246003)(4326008)(25786009)(5660300002)(71190400001)(71200400001)(14444005)(256004)(30864003)(446003)(486006)(11346002)(476003)(26005)(186003)(229853002)(55016002)(9686003)(6436002)(33656002)(76704002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2797;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EGdqkqeljz3E4JnoNMzcrTGvhhU1cW7LvrTTa4qQ1hn3XbWhS3tnqsPpp9GFa2zzNgoPvNAKMsEll3s81oFNJj7F6bYqalm9ux9RuU5BdImZdGgyV07//pzlMLumbZXAi87oExtnx4qcuPQcHCubnNulZ8rCLNSP4js5zDCoAhujuqhrm2nyQalSs7tv0dOhO0Dzl3PEP9aBPG+Vw8EKTPeV3W/aZxZtnZKkdYzsMpXpbxsJ5uGSRH/33d5n0cKtjWhg5ZUnn1t8N3oomTkzJXDHpys9kajJM7KzTTPRLxjEs7rS08tHygvRZWlbDGw4/HsH7Yabu5yxPx1IHkg1z3U/1tcaT5sd2bzLn16suSSOJl61S05RcFZUntrZoephj97iVgR4fOAwd64wdgjvvubj6FrUQnxv92iNSU3LErU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952ec7fb-5a2d-476e-3b3f-08d6d497eb5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 16:03:47.0976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2797
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, May 8, 2019 9:46 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Tue, 30 Apr 2019 17:49:37 -0500
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > In following sequences, child devices created while removing mdev
> > parent device can be left out, or it may lead to race of removing half
> > initialized child mdev devices.
> >
> > issue-1:
> > --------
> >        cpu-0                         cpu-1
> >        -----                         -----
> >                                   mdev_unregister_device()
> >                                     device_for_each_child()
> >                                       mdev_device_remove_cb()
> >                                         mdev_device_remove()
> > create_store()
> >   mdev_device_create()                   [...]
> >     device_add()
> >                                   parent_remove_sysfs_files()
> >
> > /* BUG: device added by cpu-0
> >  * whose parent is getting removed
> >  * and it won't process this mdev.
> >  */
> >
> > issue-2:
> > --------
> > Below crash is observed when user initiated remove is in progress and
> > mdev_unregister_driver() completes parent unregistration.
> >
> >        cpu-0                         cpu-1
> >        -----                         -----
> > remove_store()
> >    mdev_device_remove()
> >    active =3D false;
> >                                   mdev_unregister_device()
> >                                   parent device removed.
> >    [...]
> >    parents->ops->remove()
> >  /*
> >   * BUG: Accessing invalid parent.
> >   */
> >
> > This is similar race like create() racing with mdev_unregister_device()=
.
> >
> > BUG: unable to handle kernel paging request at ffffffffc0585668 PGD
> > e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
> > Oops: 0000 [#1] SMP PTI
> > CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted
> > 5.1.0-rc6-vdevbus+ #6 Hardware name: Supermicro
> > SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> > RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev] Call Trace:
> >  remove_store+0x71/0x90 [mdev]
> >  kernfs_fop_write+0x113/0x1a0
> >  vfs_write+0xad/0x1b0
> >  ksys_write+0x5a/0xe0
> >  do_syscall_64+0x5a/0x210
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > Therefore, mdev core is improved as below to overcome above issues.
> >
> > Wait for any ongoing mdev create() and remove() to finish before
> > unregistering parent device using refcount and completion.
> > This continues to allow multiple create and remove to progress in
> > parallel for different mdev devices as most common case.
> > At the same time guard parent removal while parent is being access by
> > create() and remove callbacks.
> >
> > Code is simplified from kref to use refcount as unregister_device()
> > has to wait anyway for all create/remove to finish.
> >
> > While removing mdev devices during parent unregistration, there isn't
> > need to acquire refcount of parent device, hence code is restructured
> > using mdev_device_remove_common() to avoid it.
>=20
> Did you consider calling parent_remove_sysfs_files() earlier in
> mdev_unregister_device() and adding srcu support to know there are no in-
> flight callers of the create path?  I think that would address issue-1.
>=20
parent_remove_sysfs_files() cannot be done until create is completed becaus=
e child mdev are under the parent's supported_types/../devices.
So once parent directory is removed, it removes the child link too.
And doing mdev_device_remove_common() on such child (for whom create was on=
going), results in warning.

Secondly, I dropped the srcu approach because srcu are slow, and call_rcu()=
 is not helpful,
because once mdev_unregister_device() is completed, we want to be sure that=
 there are no references to this parent device.

> Issue-2 suggests a bug in our handling of the parent device krefs, the pa=
rent
> object should exist until all child devices which have a kref reference t=
o the
> parent are removed, but clearly
> mdev_unregister_device() is not blocking for that to occur allowing the
> parent driver .remove callback to finish.  This seems similar to
> vfio_del_group_dev() where we need to block a vfio bus driver from
> removing a device until it becomes unused, could a similar solution with =
a
> wait_queue and wait_woken be used here?
>=20
mdev_unregister_device(), removes all the child mdevs by first by detaching=
 from the drivers, followed by calling remove() of the vendor driver.
once those remove() call completes, there shouldn't be any active reference=
 to parent.

Once mdevs are created or removed, they drop the reference to the parent.
If we keep around the reference to parent, than parent cannot publish that =
it is going away.
An additional refcount or another sync mechanism is needed to achieve that.
I don't' see what would that buy us.

> I'm not immediately sold on the idea that removing a kref to solve this
> problem is a good thing, it seems odd to me that mdevs don't hold a
> reference to the parent throughout their life with this change, and the
> remove_store path branch to exit if we find we're racing the parent remov=
e
> path is rather ugly. =20
Mdev's are anchored to its parent. When parent is going away, its removing =
the child mdevs after ensuring that no removes() are progressing.
so remove_store and create are not very different in what they do.

> BTW, why is the sanitization loop in
> mdev_device_remove() still here, wasn't that fixed by the previous two
> patches?  Thanks,
>=20
The loop still exist because remove_store() does't hold any reference to th=
e struct device getting removed.
So it is very much possible that remove_store() didn't yet invoke the mdev_=
device_remove(), but such device is already removed.
This sanitization loop for now helps there.
I want to do more sane things for remove by uuid (similar to create file) a=
nd not by self-file, but at later point...

> Alex
>=20
> > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++------------
> >  drivers/vfio/mdev/mdev_private.h |  6 ++-
> >  2 files changed, 60 insertions(+), 32 deletions(-)
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 2b98da2ee361..a5da24d662f4
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -78,34 +78,41 @@ static struct mdev_parent
> *__find_parent_device(struct device *dev)
> >  	return NULL;
> >  }
> >
> > -static void mdev_release_parent(struct kref *kref)
> > +static bool mdev_try_get_parent(struct mdev_parent *parent)
> >  {
> > -	struct mdev_parent *parent =3D container_of(kref, struct
> mdev_parent,
> > -						  ref);
> > -	struct device *dev =3D parent->dev;
> > -
> > -	kfree(parent);
> > -	put_device(dev);
> > +	if (parent)
> > +		return refcount_inc_not_zero(&parent->refcount);
> > +	return false;
> >  }
> >
> > -static struct mdev_parent *mdev_get_parent(struct mdev_parent
> > *parent)
> > +static void mdev_put_parent(struct mdev_parent *parent)
> >  {
> > -	if (parent)
> > -		kref_get(&parent->ref);
> > -
> > -	return parent;
> > +	if (parent && refcount_dec_and_test(&parent->refcount))
> > +		complete(&parent->unreg_completion);
> >  }
> >
> > -static void mdev_put_parent(struct mdev_parent *parent)
> > +static void mdev_device_remove_common(struct mdev_device *mdev)
> >  {
> > -	if (parent)
> > -		kref_put(&parent->ref, mdev_release_parent);
> > +	struct mdev_parent *parent;
> > +	struct mdev_type *type;
> > +	int ret;
> > +
> > +	type =3D to_mdev_type(mdev->type_kobj);
> > +	mdev_remove_sysfs_files(&mdev->dev, type);
> > +	device_del(&mdev->dev);
> > +	parent =3D mdev->parent;
> > +	ret =3D parent->ops->remove(mdev);
> > +	if (ret)
> > +		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
> > +
> > +	/* Balances with device_initialize() */
> > +	put_device(&mdev->dev);
> >  }
> >
> >  static int mdev_device_remove_cb(struct device *dev, void *data)  {
> >  	if (dev_is_mdev(dev))
> > -		mdev_device_remove(dev);
> > +		mdev_device_remove_common(to_mdev_device(dev));
> >
> >  	return 0;
> >  }
> > @@ -147,7 +154,8 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
> >  		goto add_dev_err;
> >  	}
> >
> > -	kref_init(&parent->ref);
> > +	refcount_set(&parent->refcount, 1);
> > +	init_completion(&parent->unreg_completion);
> >
> >  	parent->dev =3D dev;
> >  	parent->ops =3D ops;
> > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device *dev)
> >  	dev_info(dev, "MDEV: Unregistering\n");
> >
> >  	list_del(&parent->next);
> > +	mutex_unlock(&parent_list_lock);
> > +
> > +	/* Release the initial reference so that new create cannot start */
> > +	mdev_put_parent(parent);
> > +
> > +	/*
> > +	 * Wait for all the create and remove references to drop.
> > +	 */
> > +	wait_for_completion(&parent->unreg_completion);
> > +
> > +	/*
> > +	 * New references cannot be taken and all users are done
> > +	 * using the parent. So it is safe to unregister parent.
> > +	 */
> >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> >
> >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> >
> >  	parent_remove_sysfs_files(parent);
> > -
> > -	mutex_unlock(&parent_list_lock);
> > -	mdev_put_parent(parent);
> > +	kfree(parent);
> > +	put_device(dev);
> >  }
> >  EXPORT_SYMBOL(mdev_unregister_device);
> >
> > @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject *kobj,
> >  	struct mdev_parent *parent;
> >  	struct mdev_type *type =3D to_mdev_type(kobj);
> >
> > -	parent =3D mdev_get_parent(type->parent);
> > -	if (!parent)
> > +	if (!mdev_try_get_parent(type->parent))
> >  		return -EINVAL;
> >
> > +	parent =3D type->parent;
> > +
> >  	mutex_lock(&mdev_list_lock);
> >
> >  	/* Check for duplicate */
> > @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject *kobj,
> >
> >  	mdev->active =3D true;
> >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> > +	mdev_put_parent(parent);
> >
> >  	return 0;
> >
> > @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
> >  	struct mdev_device *mdev, *tmp;
> >  	struct mdev_parent *parent;
> >  	struct mdev_type *type;
> > -	int ret;
> >
> >  	mdev =3D to_mdev_device(dev);
> >
> > @@ -330,15 +352,17 @@ int mdev_device_remove(struct device *dev)
> >  	mutex_unlock(&mdev_list_lock);
> >
> >  	type =3D to_mdev_type(mdev->type_kobj);
> > -	mdev_remove_sysfs_files(dev, type);
> > -	device_del(&mdev->dev);
> > -	parent =3D mdev->parent;
> > -	ret =3D parent->ops->remove(mdev);
> > -	if (ret)
> > -		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
> > +	if (!mdev_try_get_parent(type->parent)) {
> > +		/*
> > +		 * Parent unregistration have started.
> > +		 * No need to remove here.
> > +		 */
> > +		mutex_unlock(&mdev_list_lock);
> > +		return -ENODEV;
> > +	}
> >
> > -	/* Balances with device_initialize() */
> > -	put_device(&mdev->dev);
> > +	parent =3D mdev->parent;
> > +	mdev_device_remove_common(mdev);
> >  	mdev_put_parent(parent);
> >
> >  	return 0;
> > diff --git a/drivers/vfio/mdev/mdev_private.h
> > b/drivers/vfio/mdev/mdev_private.h
> > index 067dc5d8c5de..781f111d66d2 100644
> > --- a/drivers/vfio/mdev/mdev_private.h
> > +++ b/drivers/vfio/mdev/mdev_private.h
> > @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);  struct
> mdev_parent
> > {
> >  	struct device *dev;
> >  	const struct mdev_parent_ops *ops;
> > -	struct kref ref;
> > +	/* Protects unregistration to wait until create/remove
> > +	 * are completed.
> > +	 */
> > +	refcount_t refcount;
> > +	struct completion unreg_completion;
> >  	struct list_head next;
> >  	struct kset *mdev_types_kset;
> >  	struct list_head type_list;

