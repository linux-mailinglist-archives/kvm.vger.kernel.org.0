Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38AE3C183
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 05:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390923AbfFKDXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 23:23:22 -0400
Received: from mail-eopbgr10047.outbound.protection.outlook.com ([40.107.1.47]:14819
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390856AbfFKDXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 23:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6zPxAO5xW9AMbXEn90LpqnSru44qNDErPVbRjW23fM=;
 b=GoV+9RwtNUNg8PayKAAm8iX+rqGH0ImchGc831f5tnP3qkng80AcDGqqoeiiW7SKhYNTRdy5rDGM2Xp71fNRlXdQysZGzd7molDbg6KD6ZdhZpeARniM1eELhW65ZYCUqBTN4AgMjOMVTpbwcpwYAKKd2UOCHJHCq0oFB5Q2UtA=
Received: from AM4PR0501MB2260.eurprd05.prod.outlook.com (10.165.45.148) by
 AM4PR0501MB2753.eurprd05.prod.outlook.com (10.172.217.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 11 Jun 2019 03:22:38 +0000
Received: from AM4PR0501MB2260.eurprd05.prod.outlook.com
 ([fe80::bc36:32d1:e149:5838]) by AM4PR0501MB2260.eurprd05.prod.outlook.com
 ([fe80::bc36:32d1:e149:5838%4]) with mapi id 15.20.1965.017; Tue, 11 Jun 2019
 03:22:38 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVGj4q7+/NzeZHEUWGN8sRZjbLIKaK/b4AgArXHIA=
Date:   Tue, 11 Jun 2019 03:22:37 +0000
Message-ID: <AM4PR0501MB2260589DAFDA6ECF1E8D6D87D1ED0@AM4PR0501MB2260.eurprd05.prod.outlook.com>
References: <20190603185658.54517-1-parav@mellanox.com>
        <20190603185658.54517-4-parav@mellanox.com>
 <20190604074820.71853cbb.cohuck@redhat.com>
In-Reply-To: <20190604074820.71853cbb.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.52.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48e4ef88-454b-43fe-63a2-08d6ee1c0df5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2753;
x-ms-traffictypediagnostic: AM4PR0501MB2753:
x-microsoft-antispam-prvs: <AM4PR0501MB27539D1AAFD6F91FB7758632D1ED0@AM4PR0501MB2753.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(366004)(39860400002)(376002)(199004)(189003)(13464003)(68736007)(76116006)(9686003)(73956011)(478600001)(6436002)(25786009)(7736002)(86362001)(6246003)(53936002)(52536014)(66476007)(66556008)(66446008)(64756008)(305945005)(4326008)(66946007)(55016002)(229853002)(5660300002)(71190400001)(6916009)(71200400001)(33656002)(54906003)(8936002)(81166006)(3846002)(81156014)(8676002)(66066001)(6116002)(14454004)(446003)(11346002)(102836004)(486006)(476003)(316002)(186003)(26005)(2906002)(256004)(74316002)(6506007)(7696005)(99286004)(76176011)(14444005)(53546011)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2753;H:AM4PR0501MB2260.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mmFvnUheqj4434kXYYo+Sz3KN/QCRz2ocaMsMHOMSr7sftF4I225QyO7OuYUoV+0WQ/r4ziRnlPVycq3vgfe1w4PqbSVI4Z5tmLRXv3DQGls0FcdPFpPolvU6Q6pnFwc0zg96y1aEdv6rSbL6M6lWTfr4vxh5UR61+9i1/jgPjKoyMIEXvFwI2+gI9XhPhnHpYS/EU/ANPdozOz7TjO3ZKdNCVKJIrVHcvvhmQAm3YTX3MHBFfZdUPclrKYScXGvZGIzbxP/sv4ltsZKXsu1S4JpBMtabImEEo2IkFI2zLOkbYA9imxnIJ1J0kgyU8ozHhaO1RsLYnIlG+vT6srN6tpz1Tpy272Yv+G8XROj9wGfp5j3E6Qkn1dkYQjTzHsOV1Ym1FgkUmjYOIr18GqcOTAEgzRjT0ByIEZzFTJT0cI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48e4ef88-454b-43fe-63a2-08d6ee1c0df5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 03:22:37.9123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2753
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, June 4, 2019 11:18 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv6 3/3] vfio/mdev: Synchronize device create/remove
> with parent removal
>=20
> On Mon,  3 Jun 2019 13:56:58 -0500
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
> > unregistering parent device.
> > This continues to allow multiple create and remove to progress in
> > parallel for different mdev devices as most common case.
> > At the same time guard parent removal while parent is being accessed
> > by
> > create() and remove() callbacks.
> > create()/remove() and unregister_device() are synchronized by the rwsem=
.
> >
> > Refactor device removal code to mdev_device_remove_common() to avoid
> > acquiring unreg_sem of the parent.
> >
> > Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 71 ++++++++++++++++++++++++--------
> >  drivers/vfio/mdev/mdev_private.h |  2 +
> >  2 files changed, 55 insertions(+), 18 deletions(-)
> >
>=20
> > @@ -265,6 +299,12 @@ int mdev_device_create(struct kobject *kobj,
> >
> >  	mdev->parent =3D parent;
> >
>=20
> Adding
>=20
> /* Check if parent unregistration has started */
>=20
> here as well might be nice, but no need to resend the patch for that.
>=20
> > +	if (!down_read_trylock(&parent->unreg_sem)) {
> > +		mdev_device_free(mdev);
> > +		ret =3D -ENODEV;
> > +		goto mdev_fail;
> > +	}
> > +
> >  	device_initialize(&mdev->dev);
> >  	mdev->dev.parent  =3D dev;
> >  	mdev->dev.bus     =3D &mdev_bus_type;
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Now that we have all 3 patches reviewed and comments addressed, if there ar=
e no more comments, can you please take it forward?
