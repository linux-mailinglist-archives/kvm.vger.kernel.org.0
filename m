Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF2D2F8E7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfE3I66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 04:58:58 -0400
Received: from mail-eopbgr50083.outbound.protection.outlook.com ([40.107.5.83]:3406
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbfE3I66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 04:58:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5v8tFLnqMyXICxDdVIkWXhQnGXr3zFo1jHvIDv/WNY=;
 b=SqciTApf4KF76TpTRKp5ln2wqAN1/nAF9iXs1Hy6798Tl1Ziv0WbMCV7DVqjTxsmUjw0FbGiqMVIxYoFhDdpXieSOGW1A+sz2L3+0rEkNMxlM3UwXNsHRm/VhT+KZ7jL/qx+LwZm2qz3RtNHgekjPAtb0p+5D2Sscr/QSRk5cmk=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2784.eurprd05.prod.outlook.com (10.172.12.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Thu, 30 May 2019 08:58:54 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 08:58:54 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: RE: [PATCHv4 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Topic: [PATCHv4 3/3] vfio/mdev: Synchronize device create/remove with
 parent removal
Thread-Index: AQHVEjiyuDv6ObZt1k6QmGEdbbkCeKaCOPeAgAEtoOA=
Date:   Thu, 30 May 2019 08:58:54 +0000
Message-ID: <VI1PR0501MB22713FD54711E482C8627614D1180@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190524135738.54862-1-parav@mellanox.com>
        <20190524135738.54862-4-parav@mellanox.com> <20190529085633.7fcdf7d2@x1.home>
In-Reply-To: <20190529085633.7fcdf7d2@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.179.25.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ac645ef-82c3-4ac8-bac1-08d6e4dd0afc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2784;
x-ms-traffictypediagnostic: VI1PR0501MB2784:
x-microsoft-antispam-prvs: <VI1PR0501MB2784BCDD2CBB6B5F07589F1FD1180@VI1PR0501MB2784.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(366004)(136003)(376002)(13464003)(199004)(189003)(6506007)(316002)(81166006)(66446008)(66476007)(33656002)(2906002)(14444005)(73956011)(8936002)(7696005)(86362001)(76116006)(76176011)(5660300002)(4326008)(81156014)(53936002)(25786009)(99286004)(102836004)(6246003)(54906003)(64756008)(66946007)(66556008)(8676002)(6116002)(68736007)(26005)(478600001)(71200400001)(66066001)(71190400001)(14454004)(256004)(11346002)(55016002)(446003)(74316002)(229853002)(186003)(6436002)(9686003)(3846002)(305945005)(6916009)(476003)(52536014)(7736002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2784;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lukaKy0BHjZ5osDal/MVZ+9HCtoKvHRTk+pCQmMaEJmab0BNOS5FqQAbnT0lyyX+dRcxumnGfyLaWQdIk+YWINLAnYWiEdX0qt6HEsJGi/kfCMWA5Jszc5gdrhvEiSeI63Gl5LDDao6LuU2QcQ0lZ4t8PiXI7zlh6WfIBOxEb2Q/yO4A+7o2ADB6/RojLSA5GP2nvu5ZNl/9TvexMZHR1bVPqqZYdm1ZibdhoANjAruWFJOyAo+qFBm3wsrxqIn52JI3YmtlA7W3upheqsHLR/SaywluFuljbVjORHY4ncuynnlsSoyuBs9vsB+49Ntg//NLAHcNkE15UgUdk9rdLbPvl1EWoE8dmnK+LNFV2PzRbrmIzIuXr87KVG7b6bwrIFwZLU374mZoolVlqgXAD8KAQQ0NGlG+TCQd/S3swO4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ac645ef-82c3-4ac8-bac1-08d6e4dd0afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 08:58:54.1263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2784
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, May 29, 2019 8:27 PM

[..]
> >
> > diff --git a/drivers/vfio/mdev/mdev_core.c
> > b/drivers/vfio/mdev/mdev_core.c index 0bef0cae1d4b..c5401a8c6843
> > 100644
> > --- a/drivers/vfio/mdev/mdev_core.c
> > +++ b/drivers/vfio/mdev/mdev_core.c
> > @@ -102,11 +102,36 @@ static void mdev_put_parent(struct mdev_parent
> *parent)
> >  		kref_put(&parent->ref, mdev_release_parent);  }
> >
>=20
> Some sort of locking semantics comment would be useful here, ex:
>=20
> /* Caller holds parent unreg_sem read or write lock */
>=20
Added.

> > +
> >  static int mdev_device_remove_cb(struct device *dev, void *data)  {
> > -	if (dev_is_mdev(dev))
> > -		mdev_device_remove(dev);
> > +	struct mdev_parent *parent;
> > +	struct mdev_device *mdev;
> >
> > +	if (!dev_is_mdev(dev))
> > +		return 0;
> > +
> > +	mdev =3D to_mdev_device(dev);
> > +	parent =3D mdev->parent;
> > +	mdev_device_remove_common(mdev);
>=20
> 'parent' is unused here and we only use mdev once, so we probably don't n=
eed
> to put it in a local variable.
>=20
Right left out from previous code.
Removed and refactored the code now.

> >  	return 0;
> >  }
> >
> > @@ -148,6 +173,7 @@ int mdev_register_device(struct device *dev, const
> struct mdev_parent_ops *ops)
> >  	}
> >
> >  	kref_init(&parent->ref);
> > +	init_rwsem(&parent->unreg_sem);
> >
> >  	parent->dev =3D dev;
> >  	parent->ops =3D ops;
> > @@ -206,13 +232,17 @@ void mdev_unregister_device(struct device *dev)
> >  	dev_info(dev, "MDEV: Unregistering\n");
> >
> >  	list_del(&parent->next);
> > +	mutex_unlock(&parent_list_lock);
> > +
> > +	down_write(&parent->unreg_sem);
> > +
> >  	class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> >
> >  	device_for_each_child(dev, NULL, mdev_device_remove_cb);
> >
> >  	parent_remove_sysfs_files(parent);
> > +	up_write(&parent->unreg_sem);
> >
> > -	mutex_unlock(&parent_list_lock);
> >  	mdev_put_parent(parent);
> >  }
> >  EXPORT_SYMBOL(mdev_unregister_device);
> > @@ -265,6 +295,12 @@ int mdev_device_create(struct kobject *kobj,
> >
> >  	mdev->parent =3D parent;
> >
> > +	ret =3D down_read_trylock(&parent->unreg_sem);
> > +	if (!ret) {
> > +		ret =3D -ENODEV;
>=20
> I would have expected -EAGAIN or -EBUSY here, but I guess that since we
> consider the lock-out to deterministically be the parent going away that =
-
> ENODEV makes sense.  Ok.
>=20
Yeah, I agree that ENODEV is more accurate error code as we don't want to t=
ell user to retry so EAGAIN is less appropriate.
Sending v5.
