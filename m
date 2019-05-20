Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689AC240FF
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfETTPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 15:15:24 -0400
Received: from mail-eopbgr10076.outbound.protection.outlook.com ([40.107.1.76]:49379
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbfETTPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 15:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpuUEF8SK32BLDfo5kQH7p4uoPI4SagKMLE5Tw+pog0=;
 b=pI3r+QkXvZ4sRCEuZOtTFSGT7Ms6WfwtDlv64uF52NLcEsVgiq3Ve4ML1Vt67GPwVugJ7APOxK+31iulCGAUJ7r0LXneB2jlxCj0uvkVziTxX62LLktPP2PYCRe+OICPwkc3kOCXgCmftfQX/XtLqijZFCYTEZ4vjwwFOMnK4Mo=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2207.eurprd05.prod.outlook.com (10.169.133.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Mon, 20 May 2019 19:15:16 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1900.020; Mon, 20 May 2019
 19:15:16 +0000
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
Thread-Index: AQHVDD9madL60+ZwUEG/bwMmAAM2xaZvLQUAgAAqtkCABI5DgIAAewsg
Date:   Mon, 20 May 2019 19:15:15 +0000
Message-ID: <VI1PR0501MB227135A8EE8B0E6CFA7870E3D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
        <20190517132207.12d823f2.cohuck@redhat.com>
        <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190520132911.4d56bfe5.cohuck@redhat.com>
In-Reply-To: <20190520132911.4d56bfe5.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb99d380-de10-4a33-894c-08d6dd577dd6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2207;
x-ms-traffictypediagnostic: VI1PR0501MB2207:
x-microsoft-antispam-prvs: <VI1PR0501MB2207E72F98C1F4D9B4EF96FED1060@VI1PR0501MB2207.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 004395A01C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(39860400002)(366004)(136003)(346002)(13464003)(189003)(199004)(476003)(30864003)(25786009)(305945005)(478600001)(4326008)(486006)(5660300002)(68736007)(54906003)(446003)(74316002)(53546011)(14454004)(14444005)(11346002)(6506007)(7696005)(26005)(186003)(71190400001)(71200400001)(99286004)(229853002)(76176011)(2906002)(256004)(86362001)(316002)(9686003)(33656002)(3846002)(7736002)(102836004)(55016002)(6116002)(6436002)(66066001)(52536014)(81156014)(8676002)(73956011)(66946007)(76116006)(66476007)(66446008)(6916009)(6246003)(53936002)(66556008)(64756008)(81166006)(8936002)(76704002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2207;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pfbydkUQxGdwhQA4RoJzh+hiUyZHnvy+AawbLQJIsat5riuiUNiVg8lxlPD9KWoBUk/it6WQd7TKiF3QgV1Qqk+30/OAaFe+kqmd6BEyl9bZWauzXrLwld4g6DpYAW1oop39NDvq98f9fyvfkAXfp/KuBa6q7Vq0Ii4p/DTV1WkSAifRCdWfHLjv/2CqwEIIKKEEjC4WuHSDspu62aZmAfQz0isV+mybMhRx5kNN5tCsTPIs5rbcp3l6bXXBQqQBPkocICh5zyEslOdVpwZ1QNzPH5vfra0w/wX2UNTPZHaZHbrCz8vikTcIesOVoYB71nu4Rm5qITBj6Gchb10zIfXI/vpSnhdhya1JNTGyIIJ1MliH81CueaE4OIMEwmFh5KM9XmRnd44t2pS/nv5Y+gxMO07FrFlA7Zp1Ky2uPRc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb99d380-de10-4a33-894c-08d6dd577dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2019 19:15:15.9366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2207
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, May 20, 2019 6:29 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Fri, 17 May 2019 14:18:26 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device
> *dev)
> > > >  	dev_info(dev, "MDEV: Unregistering\n");
> > > >
> > > >  	list_del(&parent->next);
> > > > +	mutex_unlock(&parent_list_lock);
> > > > +
> > > > +	/* Release the initial reference so that new create cannot start =
*/
> > > > +	mdev_put_parent(parent);
> > >
> > > The comment is confusing: We do drop one reference, but this does
> > > not imply we're going to 0 (which would be the one thing that would
> > > block creating new devices).
> > >
> > Ok. How about below comment.
> > /* Balance with initial reference init */
>=20
> Well, 'release the initial reference' is fine; it's just the second part =
that is
> confusing.
>=20
> One thing that continues to irk me (and I'm sorry if I sound like a broke=
n
> record) is that you give up the initial reference and then continue to us=
e
> parent. For the more usual semantics of a reference count, that would be =
a
> bug (as the structure would be freed if the reference count dropped to ze=
ro),
> even though it is not a bug here.
>=20
Well, refcount cannot drop to zero if user is using it.
But I understand that mdev_device caches it the parent in it, and hence it =
uses it.
However, mdev_device child devices are terminated first when parent goes aw=
ay, ensuring that no more parent user is active.
So as you mentioned, its not a bug here.

> >
> > > > +
> > > > +	/*
> > > > +	 * Wait for all the create and remove references to drop.
> > > > +	 */
> > > > +	wait_for_completion(&parent->unreg_completion);
> > >
> > > It only reaches 0 after this wait.
> > >
> > Yes.
> >
> > > > +
> > > > +	/*
> > > > +	 * New references cannot be taken and all users are done
> > > > +	 * using the parent. So it is safe to unregister parent.
> > > > +	 */
> > > >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> > > >
> > > >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > > >
> > > >  	parent_remove_sysfs_files(parent);
> > > > -
> > > > -	mutex_unlock(&parent_list_lock);
> > > > -	mdev_put_parent(parent);
> > > > +	kfree(parent);
> > > > +	put_device(dev);
> > > >  }
> > > >  EXPORT_SYMBOL(mdev_unregister_device);
> > > >
> > > > @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject *kobj,
> > > >  	struct mdev_parent *parent;
> > > >  	struct mdev_type *type =3D to_mdev_type(kobj);
> > > >
> > > > -	parent =3D mdev_get_parent(type->parent);
> > > > -	if (!parent)
> > > > +	if (!mdev_try_get_parent(type->parent))
> > >
> > > If other calls are still running, the refcount won't be 0, and this
> > > will succeed, even if we really want to get rid of the device.
> > >
> > Sure, if other calls are running, refcount won't be 0. Process creating=
 them
> will eventually complete, and refcount will drop to zero.
> > And new processes won't be able to start any more.
> > So there is no differentiation between 'already in creation stage' and
> 'about to start' processes.
>=20
> Does it really make sense to allow creation to start if the parent is goi=
ng
> away?
>=20
Its really a small time window, on how we draw the line.
But it has important note that if user continues to keep creating, removing=
, parent is blocked on removal.

> >
> > > >  		return -EINVAL;
> > > >
> > > > +	parent =3D type->parent;
> > > > +
> > > >  	mutex_lock(&mdev_list_lock);
> > > >
> > > >  	/* Check for duplicate */
> > > > @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject *kobj,
> > > >
> > > >  	mdev->active =3D true;
> > > >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> > > > +	mdev_put_parent(parent);
> > > >
> > > >  	return 0;
> > > >
> > > > @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
> > > >  	struct mdev_device *mdev, *tmp;
> > > >  	struct mdev_parent *parent;
> > > >  	struct mdev_type *type;
> > > > -	int ret;
> > > >
> > > >  	mdev =3D to_mdev_device(dev);
> > > >
> > > > @@ -330,15 +352,17 @@ int mdev_device_remove(struct device *dev)
> > > >  	mutex_unlock(&mdev_list_lock);
> > > >
> > > >  	type =3D to_mdev_type(mdev->type_kobj);
> > > > -	mdev_remove_sysfs_files(dev, type);
> > > > -	device_del(&mdev->dev);
> > > > -	parent =3D mdev->parent;
> > > > -	ret =3D parent->ops->remove(mdev);
> > > > -	if (ret)
> > > > -		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
> > > > +	if (!mdev_try_get_parent(type->parent)) {
> > >
> > > Same here: Is there really a guarantee that the refcount is 0 when
> > > the parent is going away?
> > A WARN_ON after wait_for_completion or in freeing the parent is good to
> catch bugs.
>=20
> I'd rather prefer to avoid having to add WARN_ONs :)
>=20
> This looks like it is supposed to be an early exit.=20
remove() is doing early exit if it doesn't get reference to its parent.
mdev_device_remove_common().

> However, if some
> other thread does any create or remove operation at the same time,
> we'll still do the remove, and we still might have have a race window
> (and this is getting really hard to follow in the code).
>=20
Which part?
We have only 4 functions to follow, register_device(), unregister_device(),=
 create() and remove().

If you meant, two removes racing with each other?
If so, that is currently guarded using not_so_well_defined active flag.
I will cleanup that later once this series is done.

> >
> > >
> > > > +		/*
> > > > +		 * Parent unregistration have started.
> > > > +		 * No need to remove here.
> > > > +		 */
> > > > +		mutex_unlock(&mdev_list_lock);
> > >
> > > Btw., you already unlocked above.
> > >
> > You are right. This unlock is wrong. I will revise the patch.
> >
> > > > +		return -ENODEV;
> > > > +	}
> > > >
> > > > -	/* Balances with device_initialize() */
> > > > -	put_device(&mdev->dev);
> > > > +	parent =3D mdev->parent;
> > > > +	mdev_device_remove_common(mdev);
> > > >  	mdev_put_parent(parent);
> > > >
> > > >  	return 0;
> > > > diff --git a/drivers/vfio/mdev/mdev_private.h
> > > > b/drivers/vfio/mdev/mdev_private.h
> > > > index 924ed2274941..55ebab0af7b0 100644
> > > > --- a/drivers/vfio/mdev/mdev_private.h
> > > > +++ b/drivers/vfio/mdev/mdev_private.h
> > > > @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);  struct
> > > mdev_parent
> > > > {
> > > >  	struct device *dev;
> > > >  	const struct mdev_parent_ops *ops;
> > > > -	struct kref ref;
> > > > +	/* Protects unregistration to wait until create/remove
> > > > +	 * are completed.
> > > > +	 */
> > > > +	refcount_t refcount;
> > > > +	struct completion unreg_completion;
> > > >  	struct list_head next;
> > > >  	struct kset *mdev_types_kset;
> > > >  	struct list_head type_list;
> > >
> > > I think what's really needed is to split up the different needs and n=
ot
> > > overload the 'refcount' concept.
> > >
> > Refcount tells that how many active references are present for this par=
ent
> device.
> > Those active reference could be create/remove processes and mdev core
> itself.
> >
> > So when parent unregisters, mdev module publishes that it is going away
> through this refcount.
> > Hence new users cannot start.
>=20
> But it does not actually do that -- if there are other create/remove
> operations running, userspace can still trigger a new create/remove. If
> it triggers enough create/remove processes, it can keep the parent
> around (even though that really is a pathological case.)
>=20
Yes. I agree that is still possible. And an extra flag can guard it.
I see it as try_get_parent() can be improved as incremental to implement an=
d honor that flag.
Do you want to roll that flag in same patch in v4?

> >
> > > - If we need to make sure that a reference to the parent is held so
> > >   that the parent may not go away while still in use, we should
> > >   continue to use the kref (in the idiomatic way it is used before th=
is
> > >   patch.)
> > > - We need to protect against creation of new devices if the parent is
> > >   going away. Maybe set a going_away marker in the parent structure f=
or
> > >   that so that creation bails out immediately?
> > Such marker will help to not start new processes.
> > So an additional marker can be added to improve mdev_try_get_parent().
> > But I couldn't justify why differentiating those two users on time scal=
e is
> desired.
> > One reason could be that user continuously tries to create mdev and
> parent never gets a chance, to unregister?
> > I guess, parent will run out mdev devices before this can happen.
>=20
> They can also run remove tasks in parallel (see above).
>=20
Yes, remove() is guarded using active flag.

> >
> > Additionally a stop marker is needed (counter) to tell that all users a=
re
> done accessing it.
> > Both purposes are served using a refcount scheme.
>=20
> Why not stop new create/remove tasks on remove, and do the final
> cleanup asynchronously? I think a refcount is fine to track accesses,
> but not to block new tasks.
>=20
So a new flag will guard new create/remove tasks by enhancing try_get_paren=
t().
I just didn't see it as critical fix, but it's doable. See above.

Async is certainly not a good idea.
mdev_release_parent() in current code doesn't nothing other than freeing me=
mory and parent reference.
It take away the parent from the list early on, which is also wrong, becaus=
e it was added to the list at the end.
Unregister() sequence should be mirror image.
Parent device files has to be removed before unregister_device() finishes, =
because they were added in register_device().
Otherwise, parent device_del() might be done, but files are still created u=
nder it.

If we want to keep the memory around of parent, until kref drops, than we n=
eed two refcounts.
One ensure that create and remove are done using it, other one that ensures=
 that child are done using it.
I fail to justify adding complexity of two counters, because such two_count=
er_desire hints that somehow child devices may be still active even after r=
emove() calls are finished.
And that should not be the case. Unless I miss such case.

> >
> > > What happens if the
> > >   creation has already started when parent removal kicks in, though?
> > That particular creation will succeed but newer cannot start, because
> mdev_put_parent() is done.
> >
> > >   Do we need some child list locking and an indication whether a chil=
d
> > >   is in progress of being registered/unregistered?
> > > - We also need to protect against removal of devices while unregister
> > >   is in progress (same mechanism as above?) The second issue you
> > >   describe above should be fixed then if the children keep a referenc=
e
> > >   of the parent.
> > Parent unregistration publishes that its going away first, so no new de=
vice
> removal from user can start.
>=20
> I don't think that this actually works as intended (see above).
>=20
It does work in most cases. Only if user space is creating hundreds of proc=
esses for creating mdevs, before they actually run out of creating new one.
But as we talked a flag will guard it.

So if refcount is ok, I can enhance it for flag.

> > Already on going removal by users anyway complete first.
> >
> > Once all remove() users are done, parent is getting unregistered.
