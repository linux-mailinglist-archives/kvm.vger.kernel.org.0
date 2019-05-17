Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485F6219B1
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 16:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbfEQOSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 10:18:39 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:20545
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728551AbfEQOSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 10:18:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mm3TBZDA2Q002qnFanHX5pFFtUNWy1c/BivoTV0Du3w=;
 b=p48bzSKq1o8D1iEUnzPUzIZ93TqmOrdfIL8s2gi1nj9dDdlwOcrkgnFaoyUETop3Vt4q7/5nkrRVfbCWmduAexzGtPU9bNTrUa4lPozuTIMlrJvgLcIwiVddoPDexDg8cSzP6OSUUxAPBQeft6oKQngnsgM0K9x/h+im/Jh6C3U=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2862.eurprd05.prod.outlook.com (10.172.82.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Fri, 17 May 2019 14:18:27 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 14:18:27 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVDD9madL60+ZwUEG/bwMmAAM2xaZvLQUAgAAqtkA=
Date:   Fri, 17 May 2019 14:18:26 +0000
Message-ID: <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
 <20190517132207.12d823f2.cohuck@redhat.com>
In-Reply-To: <20190517132207.12d823f2.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec80:6500:a571:ac6:a4e8:c74e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29bffd63-dadf-4d25-0b10-08d6dad2877e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2862;
x-ms-traffictypediagnostic: VI1PR0501MB2862:
x-microsoft-antispam-prvs: <VI1PR0501MB2862178D3DC74EABF56AA24CD10B0@VI1PR0501MB2862.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(39860400002)(366004)(136003)(376002)(13464003)(199004)(189003)(76176011)(2906002)(6116002)(14444005)(256004)(52536014)(6506007)(102836004)(68736007)(8676002)(99286004)(6916009)(64756008)(66476007)(7696005)(66946007)(66556008)(76116006)(73956011)(66446008)(53546011)(30864003)(14454004)(74316002)(25786009)(86362001)(7736002)(11346002)(486006)(316002)(71200400001)(46003)(55016002)(53936002)(4326008)(33656002)(6436002)(186003)(229853002)(8936002)(54906003)(5660300002)(71190400001)(478600001)(81156014)(81166006)(305945005)(9686003)(446003)(6246003)(476003)(76704002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2862;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ip+y5rtM/r3SWTKYGhQT0/3NMontIVYd93SR8i66+s+v3xurxw+gF9K6tZWadBoOZndVkG48ZPgpHN503rkhH0iPoxEQUDQsyLBRbNeL3wl7VSH72bdSgevWKkPZccSqoPhX7MRr8PmBlWX4t5oOiEEQ1tJUgRV24IaJ6cOuyI/zqp/oMxKyXoaUKj+6t67nkdqf1i2ykvquFtBkH2J/xsrDTs8TpH+TlbnnC7ENe5n1KQR/m45N3c1UQBwvXCSU6qn9JPFI9Jsc/esf1Oh3Zf5rW6ogciR/OyB6cmIsu1BM6ck2acLpLiBGfIm8r+IZ55azqDTXH/brDrDqWslRU8rbJ/BeC1oxmN+R5kUoLj0MdYohEf1zA9XCPWoC28IZyQsHe/R1pInQV/FPgcxQ7Dbx/wOnKyR56Xpv0NFXB54=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bffd63-dadf-4d25-0b10-08d6dad2877e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 14:18:26.9364
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2862
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Cornelia,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, May 17, 2019 6:22 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Thu, 16 May 2019 18:30:34 -0500
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
> >
> > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++------------
> >  drivers/vfio/mdev/mdev_private.h |  6 ++-
> >  2 files changed, 60 insertions(+), 32 deletions(-)
>=20
> I'm still not quite happy with this patch. I think most of my dislike com=
es
> from how you are using a member called 'refcount' vs. what I believe a
> refcount actually is. See below.
>
Comments below.
=20
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 0bef0cae1d4b..ca33246c1dc3
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
>=20
> So far, this is "obtain a reference if the reference is not 0 (implying t=
he object
> is not ready to use) and notify waiters when the last reference is droppe=
d".
> This still looks idiomatic enough.
>=20
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
>=20
> Initializing to 1 when creating is also fine.
>=20
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
>=20
> The comment is confusing: We do drop one reference, but this does not
> imply we're going to 0 (which would be the one thing that would block
> creating new devices).
>=20
Ok. How about below comment.
/* Balance with initial reference init */

> > +
> > +	/*
> > +	 * Wait for all the create and remove references to drop.
> > +	 */
> > +	wait_for_completion(&parent->unreg_completion);
>=20
> It only reaches 0 after this wait.
>
Yes.
=20
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
>=20
> If other calls are still running, the refcount won't be 0, and this will =
succeed,
> even if we really want to get rid of the device.
>=20
Sure, if other calls are running, refcount won't be 0. Process creating the=
m will eventually complete, and refcount will drop to zero.
And new processes won't be able to start any more.
So there is no differentiation between 'already in creation stage' and 'abo=
ut to start' processes.

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
>=20
> Same here: Is there really a guarantee that the refcount is 0 when the pa=
rent
> is going away?
A WARN_ON after wait_for_completion or in freeing the parent is good to cat=
ch bugs.

>=20
> > +		/*
> > +		 * Parent unregistration have started.
> > +		 * No need to remove here.
> > +		 */
> > +		mutex_unlock(&mdev_list_lock);
>=20
> Btw., you already unlocked above.
>
You are right. This unlock is wrong. I will revise the patch.
=20
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
> > index 924ed2274941..55ebab0af7b0 100644
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
>=20
> I think what's really needed is to split up the different needs and not
> overload the 'refcount' concept.
>=20
Refcount tells that how many active references are present for this parent =
device.
Those active reference could be create/remove processes and mdev core itsel=
f.

So when parent unregisters, mdev module publishes that it is going away thr=
ough this refcount.
Hence new users cannot start.

> - If we need to make sure that a reference to the parent is held so
>   that the parent may not go away while still in use, we should
>   continue to use the kref (in the idiomatic way it is used before this
>   patch.)
> - We need to protect against creation of new devices if the parent is
>   going away. Maybe set a going_away marker in the parent structure for
>   that so that creation bails out immediately?=20
Such marker will help to not start new processes.
So an additional marker can be added to improve mdev_try_get_parent().
But I couldn't justify why differentiating those two users on time scale is=
 desired.
One reason could be that user continuously tries to create mdev and parent =
never gets a chance, to unregister?
I guess, parent will run out mdev devices before this can happen.

Additionally a stop marker is needed (counter) to tell that all users are d=
one accessing it.
Both purposes are served using a refcount scheme.

> What happens if the
>   creation has already started when parent removal kicks in, though?
That particular creation will succeed but newer cannot start, because mdev_=
put_parent() is done.

>   Do we need some child list locking and an indication whether a child
>   is in progress of being registered/unregistered?
> - We also need to protect against removal of devices while unregister
>   is in progress (same mechanism as above?) The second issue you
>   describe above should be fixed then if the children keep a reference
>   of the parent.
Parent unregistration publishes that its going away first, so no new device=
 removal from user can start.
Already on going removal by users anyway complete first.

Once all remove() users are done, parent is getting unregistered.
