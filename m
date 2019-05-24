Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF48F29E4B
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 20:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfEXSqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 14:46:05 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:48704
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727465AbfEXSqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 14:46:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wYJRfdiAAsqY7L89a4YQiMnznmrEeASmH74QKvkOQ0=;
 b=Q650k94yVMokFJN4u7Au8g4A1Pselg93rgeFKWjtKUIHnIq4sj+rsi04mnNfryqppiKCD2LjnyDY47wsZUXyKx2nqOFoEC9Ka94NbzNvbVVD3bC+HlrYz4jOCU/ESQo6VUuIdvUPCk26iKdB1atbkWYwZTTWGl1KoQuWngqT7HM=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2413.eurprd05.prod.outlook.com (10.168.134.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 18:45:57 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1900.020; Fri, 24 May 2019
 18:45:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Thread-Topic: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
Thread-Index: AQHVDD9o/mxSVG1oh0uHfLZmDCQyjKZ28DqAgAO4otA=
Date:   Fri, 24 May 2019 18:45:57 +0000
Message-ID: <VI1PR0501MB22718C46D1D3EF0DB97D4DF4D1020@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190516233034.16407-1-parav@mellanox.com>
        <20190516233034.16407-2-parav@mellanox.com>
 <20190522115435.677b457c.cohuck@redhat.com>
In-Reply-To: <20190522115435.677b457c.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.180.107]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fba3a6a9-3e24-4be8-bf54-08d6e0780f35
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2413;
x-ms-traffictypediagnostic: VI1PR0501MB2413:
x-microsoft-antispam-prvs: <VI1PR0501MB24136734833A4AEFA209C453D1020@VI1PR0501MB2413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(396003)(39850400004)(376002)(366004)(13464003)(189003)(199004)(4326008)(316002)(305945005)(25786009)(6246003)(53936002)(6116002)(3846002)(2906002)(14454004)(229853002)(55236004)(6506007)(102836004)(76176011)(99286004)(7696005)(54906003)(53546011)(66066001)(26005)(33656002)(478600001)(476003)(66476007)(66556008)(73956011)(7736002)(9686003)(71190400001)(71200400001)(81166006)(81156014)(66446008)(186003)(8676002)(86362001)(8936002)(446003)(6436002)(76116006)(486006)(68736007)(55016002)(66946007)(256004)(14444005)(74316002)(52536014)(6916009)(64756008)(5660300002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2413;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QCrmldt/CQ3Undw/8KoqPX2MRnV8c2ctZMMnSkYD90iTjY9Hhy4oZF8p7ddAbmKdl3Ffx7HSxZswQqkOZEbiZt0l1Md39uzUcLYZqRwA/T157n/Gtn80zmVOdeoiU+N57rpIcAIdECsKVWokgC02AADOGehMOryoadJHQ2y/+7FfKCLmHKjXsEcBaY8xvzWfsT1H7yOS67odV+bJ7uE4ZNL0g/WtBzIJArRRWAJAtSYtnRaLyfs7j9iKZ515tFTwy8qckaAQXhqGvJs1EzJ6/JYa630zD/GBCnZVjVZs+YnGJR93ShRq34dJNM8ma238Z4oXxrLjxL8FZUxgyIF+h0nJ2qukwLOcD86ssi8/E8dagqgMI/WQJ0gDyKxX1cqPFo/Pi08eqAg693YvyIfdZouSlxwlfpJjcNH9gUq+18M=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba3a6a9-3e24-4be8-bf54-08d6e0780f35
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 18:45:57.3920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2413
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex, Cornelia,

> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Wednesday, May 22, 2019 3:25 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> kwankhede@nvidia.com; alex.williamson@redhat.com; cjia@nvidia.com
> Subject: Re: [PATCHv3 1/3] vfio/mdev: Improve the create/remove sequence
>=20
> On Thu, 16 May 2019 18:30:32 -0500
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
> > Due to this way of initialization, mdev driver who wants to use the
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
> > At that point vendor's remove() ops shouldn't fail because taking the
> > device off the bus should terminate any usage.
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
> > 1. Split the device registration/deregistration sequence so that some
> > things can be done between initialization of the device and hooking it
> > up to the bus respectively after deregistering it from the bus but
> > before giving up our final reference.
> > In particular, this means invoking the ->create and ->remove callbacks
> > in those new windows. This gives the vendor driver an initialized mdev
> > device to work with during creation.
> > At the same time, a bus driver who wish to bind to mdev driver also
>=20
> s/who wish/that wishes/
>=20
> > gets initialized mdev device.
> >
> > This follows standard Linux kernel bus and device model.
> >
> > 2. During remove flow, first remove the device from the bus. This
> > ensures that any bus specific devices are removed.
> > Once device is taken off the mdev bus, invoke remove() of mdev from
> > the vendor driver.
> >
> > 3. The driver core device model provides way to register and auto
> > unregister the device sysfs attribute groups at dev->groups.
> > Make use of dev->groups to let core create the groups and eliminate
> > code to avoid explicit groups creation and removal.
> >
> > To ensure, that new sequence is solid, a below stack dump of a process
> > is taken who attempts to remove the device while device is in use by
> > vfio driver and user application.
> > This stack dump validates that vfio driver guards against such device
> > removal when device is in use.
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
> >
> > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > ---
> >  drivers/vfio/mdev/mdev_core.c    | 94 +++++++++-----------------------
> >  drivers/vfio/mdev/mdev_private.h |  2 +-
> >  drivers/vfio/mdev/mdev_sysfs.c   |  2 +-
> >  3 files changed, 27 insertions(+), 71 deletions(-)
>=20
> Personally, I'd do a more compact patch description, but there's nothing
> really wrong with yours, either.
>=20
> Patch also seems sane to me, although I'd probably have merged this and
> the next patch. But no reason to quibble further.
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

I missed to add your RB signature in v4.
If you send all 3 or just fist 2 of them in 5.2-rc, please include Cornelia=
's RB tag.
