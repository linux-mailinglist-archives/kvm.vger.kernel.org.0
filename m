Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53629441
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 11:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389806AbfEXJLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 05:11:43 -0400
Received: from mail-eopbgr50088.outbound.protection.outlook.com ([40.107.5.88]:3200
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389425AbfEXJLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 05:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cN1jmAPxA136LV56AEfKRe1mPmmerqEgja2q0j6Aufw=;
 b=QLU2ts/IF3INvFA7TiE4t1tiivFJLSbhtqCOzWVvw0wqCLo1yuaDToMt+yHK5z1lBM6iJAwri+1jrIUKPmFcqSlmxsal72WG/BQIFP3FYug3JYxvWWtVw2/CC9WxyWU953S22jcXMABl9XxhHeaDZI+WvIv7ILuAmCC+B8bh2ts=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2350.eurprd05.prod.outlook.com (10.169.135.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 09:11:35 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1900.020; Fri, 24 May 2019
 09:11:35 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVDD9madL60+ZwUEG/bwMmAAM2xaZvLQUAgAAqtkCABI5DgIAAewsggAA4rYCABW20UA==
Date:   Fri, 24 May 2019 09:11:35 +0000
Message-ID: <VI1PR0501MB2271ED2C6DB6ABE4B6C8A38AD1020@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-4-parav@mellanox.com>
        <20190517132207.12d823f2.cohuck@redhat.com>
        <VI1PR0501MB227162B10E46947E7C4A1C83D10B0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
        <20190520132911.4d56bfe5.cohuck@redhat.com>
        <VI1PR0501MB227135A8EE8B0E6CFA7870E3D1060@VI1PR0501MB2271.eurprd05.prod.outlook.com>
 <20190520161225.5d7321e9@x1.home>
In-Reply-To: <20190520161225.5d7321e9@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [171.48.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5cde445-6c5e-4475-d5a4-08d6e027d23a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2350;
x-ms-traffictypediagnostic: VI1PR0501MB2350:
x-microsoft-antispam-prvs: <VI1PR0501MB2350EA8061F7ED18E8E9DD9FD1020@VI1PR0501MB2350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(366004)(376002)(39860400002)(13464003)(189003)(199004)(86362001)(25786009)(71200400001)(2906002)(4326008)(71190400001)(6246003)(6436002)(7696005)(76176011)(54906003)(229853002)(316002)(99286004)(14444005)(256004)(55016002)(11346002)(76116006)(476003)(446003)(66446008)(64756008)(66556008)(66476007)(73956011)(66946007)(102836004)(8936002)(78486014)(81166006)(81156014)(53546011)(6506007)(52536014)(26005)(186003)(478600001)(7736002)(305945005)(14454004)(74316002)(486006)(33656002)(8676002)(66066001)(9686003)(30864003)(6916009)(68736007)(53936002)(5660300002)(6116002)(3846002)(76704002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2350;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WQP0gVwRGp/fkq4SvsRCn/hADfVZm+TvBY6YzfASBsNbmO0GjToJg3w44j+GoKn56/8OHZmEiPhlNzsFLYxbd4P9k0mtwydjmzc0lQ0gzCmioHSLaJY6lzDwFwogR7QsP1V8Xkbx8fGtl8yt51l/8yhOV7JsU+SuO1p78hD8pVwfES1zRiUtZKY4tsmzVUKsRPXhm+V2zfvfMUczessEzmO7JDpipIboEgUAyvMLBX+f4B/SCDHKQn3C9Ns8VRpG17Eto/dAEeQoQJhY5lXV0/VyP1lsrCg8gyyOF909FBqKMzMV3tNcY+eFxAJY8zgfwhujYcPdQjzslbAv1g+4f9ODbzJDYyqweaOOWsjj+mp3Cz8c3tDkX04GceCH216usocz+NhCdPbxupxz9544A6vzXoFws56EAR7+R+XprEA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cde445-6c5e-4475-d5a4-08d6e027d23a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:11:35.4010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2350
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

I was on travel for last 3 days, hence the slow response.
Started working now. Please see inline response below.

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, May 21, 2019 3:42 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; kwankhede@nvidia.com; cjia@nvidia.com
> Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device create/remove wi=
th
> parent removal
>=20
> On Mon, 20 May 2019 19:15:15 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Monday, May 20, 2019 6:29 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> > > Subject: Re: [PATCHv3 3/3] vfio/mdev: Synchronize device
> > > create/remove with parent removal
> > >
> > > On Fri, 17 May 2019 14:18:26 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct
> > > > > > device
> > > *dev)
> > > > > >  	dev_info(dev, "MDEV: Unregistering\n");
> > > > > >
> > > > > >  	list_del(&parent->next);
> > > > > > +	mutex_unlock(&parent_list_lock);
> > > > > > +
> > > > > > +	/* Release the initial reference so that new create cannot st=
art
> */
> > > > > > +	mdev_put_parent(parent);
> > > > >
> > > > > The comment is confusing: We do drop one reference, but this
> > > > > does not imply we're going to 0 (which would be the one thing
> > > > > that would block creating new devices).
> > > > >
> > > > Ok. How about below comment.
> > > > /* Balance with initial reference init */
> > >
> > > Well, 'release the initial reference' is fine; it's just the second
> > > part that is confusing.
> > >
> > > One thing that continues to irk me (and I'm sorry if I sound like a
> > > broken
> > > record) is that you give up the initial reference and then continue
> > > to use parent. For the more usual semantics of a reference count,
> > > that would be a bug (as the structure would be freed if the
> > > reference count dropped to zero), even though it is not a bug here.
> > >
> > Well, refcount cannot drop to zero if user is using it.
> > But I understand that mdev_device caches it the parent in it, and hence=
 it
> uses it.
> > However, mdev_device child devices are terminated first when parent goe=
s
> away, ensuring that no more parent user is active.
> > So as you mentioned, its not a bug here.
> >
> > > >
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Wait for all the create and remove references to drop.
> > > > > > +	 */
> > > > > > +	wait_for_completion(&parent->unreg_completion);
> > > > >
> > > > > It only reaches 0 after this wait.
> > > > >
> > > > Yes.
> > > >
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * New references cannot be taken and all users are done
> > > > > > +	 * using the parent. So it is safe to unregister parent.
> > > > > > +	 */
> > > > > >  	class_compat_remove_link(mdev_bus_compat_class, dev,
> NULL);
> > > > > >
> > > > > >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > > > > >
> > > > > >  	parent_remove_sysfs_files(parent);
> > > > > > -
> > > > > > -	mutex_unlock(&parent_list_lock);
> > > > > > -	mdev_put_parent(parent);
> > > > > > +	kfree(parent);
> > > > > > +	put_device(dev);
> > > > > >  }
> > > > > >  EXPORT_SYMBOL(mdev_unregister_device);
> > > > > >
> > > > > > @@ -237,10 +258,11 @@ int mdev_device_create(struct kobject
> *kobj,
> > > > > >  	struct mdev_parent *parent;
> > > > > >  	struct mdev_type *type =3D to_mdev_type(kobj);
> > > > > >
> > > > > > -	parent =3D mdev_get_parent(type->parent);
> > > > > > -	if (!parent)
> > > > > > +	if (!mdev_try_get_parent(type->parent))
> > > > >
> > > > > If other calls are still running, the refcount won't be 0, and
> > > > > this will succeed, even if we really want to get rid of the devic=
e.
> > > > >
> > > > Sure, if other calls are running, refcount won't be 0. Process
> > > > creating them
> > > will eventually complete, and refcount will drop to zero.
> > > > And new processes won't be able to start any more.
> > > > So there is no differentiation between 'already in creation stage'
> > > > and
> > > 'about to start' processes.
> > >
> > > Does it really make sense to allow creation to start if the parent
> > > is going away?
> > >
> > Its really a small time window, on how we draw the line.
> > But it has important note that if user continues to keep creating, remo=
ving,
> parent is blocked on removal.
> >
> > > >
> > > > > >  		return -EINVAL;
> > > > > >
> > > > > > +	parent =3D type->parent;
> > > > > > +
> > > > > >  	mutex_lock(&mdev_list_lock);
> > > > > >
> > > > > >  	/* Check for duplicate */
> > > > > > @@ -287,6 +309,7 @@ int mdev_device_create(struct kobject
> > > > > > *kobj,
> > > > > >
> > > > > >  	mdev->active =3D true;
> > > > > >  	dev_dbg(&mdev->dev, "MDEV: created\n");
> > > > > > +	mdev_put_parent(parent);
> > > > > >
> > > > > >  	return 0;
> > > > > >
> > > > > > @@ -306,7 +329,6 @@ int mdev_device_remove(struct device *dev)
> > > > > >  	struct mdev_device *mdev, *tmp;
> > > > > >  	struct mdev_parent *parent;
> > > > > >  	struct mdev_type *type;
> > > > > > -	int ret;
> > > > > >
> > > > > >  	mdev =3D to_mdev_device(dev);
> > > > > >
> > > > > > @@ -330,15 +352,17 @@ int mdev_device_remove(struct device
> *dev)
> > > > > >  	mutex_unlock(&mdev_list_lock);
> > > > > >
> > > > > >  	type =3D to_mdev_type(mdev->type_kobj);
> > > > > > -	mdev_remove_sysfs_files(dev, type);
> > > > > > -	device_del(&mdev->dev);
> > > > > > -	parent =3D mdev->parent;
> > > > > > -	ret =3D parent->ops->remove(mdev);
> > > > > > -	if (ret)
> > > > > > -		dev_err(&mdev->dev, "Remove failed: err=3D%d\n", ret);
> > > > > > +	if (!mdev_try_get_parent(type->parent)) {
> > > > >
> > > > > Same here: Is there really a guarantee that the refcount is 0
> > > > > when the parent is going away?
> > > > A WARN_ON after wait_for_completion or in freeing the parent is
> > > > good to
> > > catch bugs.
> > >
> > > I'd rather prefer to avoid having to add WARN_ONs :)
> > >
> > > This looks like it is supposed to be an early exit.
> > remove() is doing early exit if it doesn't get reference to its parent.
> > mdev_device_remove_common().
> >
> > > However, if some
> > > other thread does any create or remove operation at the same time,
> > > we'll still do the remove, and we still might have have a race
> > > window (and this is getting really hard to follow in the code).
> > >
> > Which part?
> > We have only 4 functions to follow, register_device(), unregister_devic=
e(),
> create() and remove().
> >
> > If you meant, two removes racing with each other?
> > If so, that is currently guarded using not_so_well_defined active flag.
> > I will cleanup that later once this series is done.
> >
> > > >
> > > > >
> > > > > > +		/*
> > > > > > +		 * Parent unregistration have started.
> > > > > > +		 * No need to remove here.
> > > > > > +		 */
> > > > > > +		mutex_unlock(&mdev_list_lock);
> > > > >
> > > > > Btw., you already unlocked above.
> > > > >
> > > > You are right. This unlock is wrong. I will revise the patch.
> > > >
> > > > > > +		return -ENODEV;
> > > > > > +	}
> > > > > >
> > > > > > -	/* Balances with device_initialize() */
> > > > > > -	put_device(&mdev->dev);
> > > > > > +	parent =3D mdev->parent;
> > > > > > +	mdev_device_remove_common(mdev);
> > > > > >  	mdev_put_parent(parent);
> > > > > >
> > > > > >  	return 0;
> > > > > > diff --git a/drivers/vfio/mdev/mdev_private.h
> > > > > > b/drivers/vfio/mdev/mdev_private.h
> > > > > > index 924ed2274941..55ebab0af7b0 100644
> > > > > > --- a/drivers/vfio/mdev/mdev_private.h
> > > > > > +++ b/drivers/vfio/mdev/mdev_private.h
> > > > > > @@ -19,7 +19,11 @@ void mdev_bus_unregister(void);  struct
> > > > > mdev_parent
> > > > > > {
> > > > > >  	struct device *dev;
> > > > > >  	const struct mdev_parent_ops *ops;
> > > > > > -	struct kref ref;
> > > > > > +	/* Protects unregistration to wait until create/remove
> > > > > > +	 * are completed.
> > > > > > +	 */
> > > > > > +	refcount_t refcount;
> > > > > > +	struct completion unreg_completion;
> > > > > >  	struct list_head next;
> > > > > >  	struct kset *mdev_types_kset;
> > > > > >  	struct list_head type_list;
> > > > >
> > > > > I think what's really needed is to split up the different needs
> > > > > and not overload the 'refcount' concept.
> > > > >
> > > > Refcount tells that how many active references are present for
> > > > this parent
> > > device.
> > > > Those active reference could be create/remove processes and mdev
> > > > core
> > > itself.
> > > >
> > > > So when parent unregisters, mdev module publishes that it is going
> > > > away
> > > through this refcount.
> > > > Hence new users cannot start.
> > >
> > > But it does not actually do that -- if there are other create/remove
> > > operations running, userspace can still trigger a new create/remove.
> > > If it triggers enough create/remove processes, it can keep the
> > > parent around (even though that really is a pathological case.)
> > >
> > Yes. I agree that is still possible. And an extra flag can guard it.
> > I see it as try_get_parent() can be improved as incremental to implemen=
t and
> honor that flag.
> > Do you want to roll that flag in same patch in v4?
> >
> > > >
> > > > > - If we need to make sure that a reference to the parent is held =
so
> > > > >   that the parent may not go away while still in use, we should
> > > > >   continue to use the kref (in the idiomatic way it is used befor=
e this
> > > > >   patch.)
> > > > > - We need to protect against creation of new devices if the paren=
t is
> > > > >   going away. Maybe set a going_away marker in the parent structu=
re
> for
> > > > >   that so that creation bails out immediately?
> > > > Such marker will help to not start new processes.
> > > > So an additional marker can be added to improve mdev_try_get_parent=
().
> > > > But I couldn't justify why differentiating those two users on time
> > > > scale is
> > > desired.
> > > > One reason could be that user continuously tries to create mdev
> > > > and
> > > parent never gets a chance, to unregister?
> > > > I guess, parent will run out mdev devices before this can happen.
> > >
> > > They can also run remove tasks in parallel (see above).
> > >
> > Yes, remove() is guarded using active flag.
> >
> > > >
> > > > Additionally a stop marker is needed (counter) to tell that all
> > > > users are
> > > done accessing it.
> > > > Both purposes are served using a refcount scheme.
> > >
> > > Why not stop new create/remove tasks on remove, and do the final
> > > cleanup asynchronously? I think a refcount is fine to track
> > > accesses, but not to block new tasks.
> > >
> > So a new flag will guard new create/remove tasks by enhancing
> try_get_parent().
> > I just didn't see it as critical fix, but it's doable. See above.
> >
> > Async is certainly not a good idea.
> > mdev_release_parent() in current code doesn't nothing other than freein=
g
> memory and parent reference.
> > It take away the parent from the list early on, which is also wrong, be=
cause it
> was added to the list at the end.
> > Unregister() sequence should be mirror image.
> > Parent device files has to be removed before unregister_device() finish=
es,
> because they were added in register_device().
> > Otherwise, parent device_del() might be done, but files are still creat=
ed
> under it.
> >
> > If we want to keep the memory around of parent, until kref drops, than =
we
> need two refcounts.
> > One ensure that create and remove are done using it, other one that ens=
ures
> that child are done using it.
> > I fail to justify adding complexity of two counters, because such
> two_counter_desire hints that somehow child devices may be still active e=
ven
> after remove() calls are finished.
> > And that should not be the case. Unless I miss such case.
> >
> > > >
> > > > > What happens if the
> > > > >   creation has already started when parent removal kicks in, thou=
gh?
> > > > That particular creation will succeed but newer cannot start,
> > > > because
> > > mdev_put_parent() is done.
> > > >
> > > > >   Do we need some child list locking and an indication whether a =
child
> > > > >   is in progress of being registered/unregistered?
> > > > > - We also need to protect against removal of devices while unregi=
ster
> > > > >   is in progress (same mechanism as above?) The second issue you
> > > > >   describe above should be fixed then if the children keep a refe=
rence
> > > > >   of the parent.
> > > > Parent unregistration publishes that its going away first, so no
> > > > new device
> > > removal from user can start.
> > >
> > > I don't think that this actually works as intended (see above).
> > >
> > It does work in most cases. Only if user space is creating hundreds of
> processes for creating mdevs, before they actually run out of creating ne=
w one.
> > But as we talked a flag will guard it.
> >
> > So if refcount is ok, I can enhance it for flag.
>=20
> I agree with Connie's dislike of the refcount, where it seems we're reall=
y just
> using it as a read-writer lock.  So why not simply use a rwsem?  The pare=
nt
> unregistration path would do a down_write() and all the ancillary paths w=
ould
> do a down_read_trylock() as they should never see read contention unless =
the
> parent is being removed. =20
Ok. sounds good. I will send v4 using rwsem without removing kref.

> As a bonus, we don't need to invent our own fairness
> algorithm, nor do we need to remove the krefs as they're at least useful =
to
> validate we haven't missed anyone.  Thanks,
Well if we really care for kref, put on parent kref should be done in mdev_=
device_release().
I do not see how device can be still using the parent after device_del() is=
 done.
Anyways, kref cleanup is different patch in 5.3.

>=20
> Alex
