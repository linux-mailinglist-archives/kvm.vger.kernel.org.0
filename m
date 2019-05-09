Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B6318DD3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 18:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfEIQQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 12:16:25 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:13892
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbfEIQQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 12:16:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6sV3l9uhUqWDawQ7SG1EG9ZIkxAehoJV1ranh5CDMQ=;
 b=ot7zEqiLQh1WkjG2J2+ZscZHwJpqHHKDE/vRfFubalhVaBVOYOJHyGQlYY7W3fDr3K78qHH/szn3X2wPaDxv2p0/5t4yN+K+agT83T/He/5DVnHoAQ8gMIIGYI+vzJ12Fbg3R/BEdcSBNb8d6jp1V/LFE9+cj7bseXbWtd8vESM=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2864.eurprd05.prod.outlook.com (10.172.12.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.12; Thu, 9 May 2019 16:14:40 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::8810:9799:ab77:9494%2]) with mapi id 15.20.1878.022; Thu, 9 May 2019
 16:14:40 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHU/6cO6K7GzrI04UmIa4WtImP3kqZiI2OAgAB2PYCAAGjOgA==
Date:   Thu, 9 May 2019 16:14:40 +0000
Message-ID: <VI1PR0501MB2271A16961F015FF122EF6E0D1330@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190430224937.57156-1-parav@mellanox.com>
        <20190430224937.57156-11-parav@mellanox.com>
        <20190508204605.17294a7d@x1.home> <20190509114917.5e80e88d.cohuck@redhat.com>
In-Reply-To: <20190509114917.5e80e88d.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61781923-287c-4c62-f8ed-08d6d4997093
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2864;
x-ms-traffictypediagnostic: VI1PR0501MB2864:
x-microsoft-antispam-prvs: <VI1PR0501MB2864A0C0E0ECA62435B6D672D1330@VI1PR0501MB2864.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(39860400002)(376002)(346002)(51444003)(199004)(189003)(13464003)(7736002)(74316002)(2906002)(305945005)(186003)(33656002)(256004)(102836004)(26005)(11346002)(25786009)(14444005)(68736007)(14454004)(316002)(99286004)(53546011)(54906003)(110136005)(446003)(3846002)(6116002)(6506007)(52536014)(6436002)(81166006)(86362001)(81156014)(4326008)(476003)(486006)(71200400001)(71190400001)(5660300002)(7696005)(66066001)(478600001)(229853002)(64756008)(66446008)(8676002)(66556008)(8936002)(66476007)(9686003)(73956011)(66946007)(76116006)(55016002)(53936002)(6246003)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2864;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UsW0M2BY1sifrD2ZXvpDwifhH0/u053LbYAWzV+K8UI5w7wEzGjH8zjrE3Va03tkveggzoDgqxPgC+9/36EnhjhVa8wbnUS+C/9adQaCeCTST/7X4UdYS9cztl92Gu6Cv+kml+oMq/b+V9iX0su9rm02OfniiBQovc32szgzxaI0Oatv1wk0Olh1X64iGYcso4W+rH7wUrG3t4fihctI8/NIzkH26vsNmqTuCYd7iK7+TFp/46TjAtrqcXsMduyPYPLq7C4nUYU49xvyezT6WVh9r5z/XOu6dAH48Zq0GdlsWuvmY8ctmf1KpAeFTVnwvbhacNxrl6fdPk+wBr6uCrfASdaurbn2d9W8/KZyVe1piMiTRfyegfd8op3ZN7yZiXHeis1uSxt7WGSRacBCgriixHY+8B//RYYBRZ4SLFM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61781923-287c-4c62-f8ed-08d6d4997093
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 16:14:40.1883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2864
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Thursday, May 9, 2019 4:49 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Parav Pandit <parav@mellanox.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; kwankhede@nvidia.com; cjia@nvidia.com
> Subject: Re: [PATCHv2 10/10] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Wed, 8 May 2019 20:46:05 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
>=20
> > On Tue, 30 Apr 2019 17:49:37 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >
> > > In following sequences, child devices created while removing mdev
> > > parent device can be left out, or it may lead to race of removing
> > > half initialized child mdev devices.
> > >
> > > issue-1:
> > > --------
> > >        cpu-0                         cpu-1
> > >        -----                         -----
> > >                                   mdev_unregister_device()
> > >                                     device_for_each_child()
> > >                                       mdev_device_remove_cb()
> > >                                         mdev_device_remove()
> > > create_store()
> > >   mdev_device_create()                   [...]
> > >     device_add()
> > >                                   parent_remove_sysfs_files()
> > >
> > > /* BUG: device added by cpu-0
> > >  * whose parent is getting removed
> > >  * and it won't process this mdev.
> > >  */
> > >
> > > issue-2:
> > > --------
> > > Below crash is observed when user initiated remove is in progress
> > > and mdev_unregister_driver() completes parent unregistration.
> > >
> > >        cpu-0                         cpu-1
> > >        -----                         -----
> > > remove_store()
> > >    mdev_device_remove()
> > >    active =3D false;
> > >                                   mdev_unregister_device()
> > >                                   parent device removed.
> > >    [...]
> > >    parents->ops->remove()
> > >  /*
> > >   * BUG: Accessing invalid parent.
> > >   */
> > >
> > > This is similar race like create() racing with mdev_unregister_device=
().
> > >
> > > BUG: unable to handle kernel paging request at ffffffffc0585668 PGD
> > > e8f618067 P4D e8f618067 PUD e8f61a067 PMD 85adca067 PTE 0
> > > Oops: 0000 [#1] SMP PTI
> > > CPU: 41 PID: 37403 Comm: bash Kdump: loaded Not tainted
> > > 5.1.0-rc6-vdevbus+ #6 Hardware name: Supermicro
> > > SYS-6028U-TR4+/X10DRU-i+, BIOS 2.0b 08/09/2016
> > > RIP: 0010:mdev_device_remove+0xfa/0x140 [mdev] Call Trace:
> > >  remove_store+0x71/0x90 [mdev]
> > >  kernfs_fop_write+0x113/0x1a0
> > >  vfs_write+0xad/0x1b0
> > >  ksys_write+0x5a/0xe0
> > >  do_syscall_64+0x5a/0x210
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Therefore, mdev core is improved as below to overcome above issues.
> > >
> > > Wait for any ongoing mdev create() and remove() to finish before
> > > unregistering parent device using refcount and completion.
> > > This continues to allow multiple create and remove to progress in
> > > parallel for different mdev devices as most common case.
> > > At the same time guard parent removal while parent is being access
> > > by
> > > create() and remove callbacks.
> > >
> > > Code is simplified from kref to use refcount as unregister_device()
> > > has to wait anyway for all create/remove to finish.
> > >
> > > While removing mdev devices during parent unregistration, there
> > > isn't need to acquire refcount of parent device, hence code is
> > > restructured using mdev_device_remove_common() to avoid it.
> >
> > Did you consider calling parent_remove_sysfs_files() earlier in
> > mdev_unregister_device() and adding srcu support to know there are no
> > in-flight callers of the create path?  I think that would address
> > issue-1.
> >
> > Issue-2 suggests a bug in our handling of the parent device krefs, the
> > parent object should exist until all child devices which have a kref
> > reference to the parent are removed, but clearly
> > mdev_unregister_device() is not blocking for that to occur allowing
> > the parent driver .remove callback to finish.  This seems similar to
> > vfio_del_group_dev() where we need to block a vfio bus driver from
> > removing a device until it becomes unused, could a similar solution
> > with a wait_queue and wait_woken be used here?
> >
> > I'm not immediately sold on the idea that removing a kref to solve
> > this problem is a good thing, it seems odd to me that mdevs don't hold
> > a reference to the parent throughout their life with this change, and
> > the remove_store path branch to exit if we find we're racing the
> > parent remove path is rather ugly.  BTW, why is the sanitization loop
> > in
> > mdev_device_remove() still here, wasn't that fixed by the previous two
> > patches?  Thanks,
>=20
> Agreed, I think not holding a reference to the parent is rather odd.
>=20
> >
> > Alex
> >
> > > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > ---
> > >  drivers/vfio/mdev/mdev_core.c    | 86 ++++++++++++++++++++----------=
--
> > >  drivers/vfio/mdev/mdev_private.h |  6 ++-
> > >  2 files changed, 60 insertions(+), 32 deletions(-)
>=20
> (...)
>=20
> > > @@ -206,14 +214,27 @@ void mdev_unregister_device(struct device
> *dev)
> > >  	dev_info(dev, "MDEV: Unregistering\n");
> > >
> > >  	list_del(&parent->next);
> > > +	mutex_unlock(&parent_list_lock);
> > > +
> > > +	/* Release the initial reference so that new create cannot start */
> > > +	mdev_put_parent(parent);
> > > +
> > > +	/*
> > > +	 * Wait for all the create and remove references to drop.
> > > +	 */
> > > +	wait_for_completion(&parent->unreg_completion);
> > > +
> > > +	/*
> > > +	 * New references cannot be taken and all users are done
> > > +	 * using the parent. So it is safe to unregister parent.
> > > +	 */
> > >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> > >
> > >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> > >
> > >  	parent_remove_sysfs_files(parent);
> > > -
> > > -	mutex_unlock(&parent_list_lock);
> > > -	mdev_put_parent(parent);
> > > +	kfree(parent);
>=20
> Such a kfree() is usually a big, flashing warning sign to me, even though=
 it
> probably isn't strictly broken in this case.
>=20
Devices are removed, create files are removed. Parent is taken off the list=
.
So who else can access this parent?

> > > +	put_device(dev);
> > >  }
> > >  EXPORT_SYMBOL(mdev_unregister_device);
> > >
>=20
> I think one problem I'm having here is that two things are conflated with
> that approach:
>=20
> - Structures holding a reference to another structure, where they need
>   to be sure that it isn't pulled out from under them.
> - Structures being hooked up and discoverable from somewhere else.
>=20
> I think what we actually need is that the code possibly creating a new md=
ev
> device is not able to look up the parent device if removal has been alrea=
dy
> triggered for it. Same for triggering mdev device removal.
>=20
This is already present in the patch.
mdev_try_get_parent() API looks up the parent during creation and removal p=
ath.

> Do we need to somehow tie getting an extra reference to looking up the
> device? Any extra reference does not hurt, as long as we remember to drop
> it again :)

A single refcount publishes its parent's device existence.
If we want to hold reference to parent until the life of child device, than=
 we need additional plumbing.
Additional plumbing advertises when parent is reachable/getting removed and=
 also waits until create/remove is completed.
I think if we can justify the need for this additional plumbing, it makes i=
t easy to think what to be done.
