Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1433159D0C2
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 07:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbiHWFxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 01:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbiHWFxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 01:53:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001BBD6E;
        Mon, 22 Aug 2022 22:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661233999; x=1692769999;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l/IUy+nXbvDqXTMzRL/jlZ/lTGUO9kFQMmBLwJjb3zA=;
  b=kKtUI1RSbBrpfR8zUw5siWrEyRFVsFuhWP2N0iPRkSM/9syVeNVsUmH0
   XH4xc0iBnPPfGntSFVOgR7d9lp/YSA2R6aM+y2ned0JAPGja0+ALNDlEZ
   BmNDjDWevj0WinWSiE5UJOfiZ2PxvtVwJX7wknm6ncPbyk9c85j7Gg17R
   u3TR9kCNVWEPNSh6dLJvvLL0Jt8RGwkPM05qb/vVf7CQZ7xcuXQHmWK7L
   UKcMcDjtOuqbIAs/d5M8WHAAw0UfAf9HvV23Sjbp/P+OhQ7I849iydhZ/
   NrZP8ZjXz0f2dHf8SNGGQR7TJWdHQwZYUjHh/fsmECrRIdyeVC/D3CxXh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294882232"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294882232"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 22:53:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="585837194"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2022 22:53:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 22:53:18 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 22:53:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 22:53:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 22:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcbErUZF8v6H24e5kaVPtsA+RSgWunmw0HZQbQLAWX9kUZjwk1iqRDuS36WEBUuCkoCYQbMc9W1TPkUGefHI6vhplDKwnCkB+j2evD7gxMiH80D+hnl5GnlIeZ5xNRORHLB8oMV9k7nNVq/kvveQC02S1WT7uooxTlhUNR4YpHC7sYEPcFKNNNX9XAaeQp1kTU9QGIZFzdvqDyN/DYd2GuKQKerM/z+ctvoj85pwIsZilgyHu7G6E4sjQ5aaiTAMyKVDUUbRWo41k+ztPPKw55o7Z8sERJ1e1AZQrGBIETieyegHVms8Zp12pP/IrK1jqoK5J6vOrXtnan8hnwNvRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAfmcg8l4E+TFqb68H3Skr9GwLfiWQzZmHzKu1j008A=;
 b=VaAlXBr33zL6fms51HmYn4ET2MilqzfR310Xv1p0F0hxSGxRKbaFglHRCMyqlogyy+kjRHr/EegyauRy3jGNq17ZYpkilbFYlIOyLWkdocZUKL1NCx9/+vri+JEVcd3t5xJopF8K2/iwTHU0YiOhkAttKMUCJxIkdQ7HuA8bDchNuv9+qdFnsd3l5S/6CxP7psKM4u5lBDMV6IGB2RrKA9qVyXJ3tnLk5ZYcQfH7RcobhaAnMPXdFt/YaMVf5Dueprm6A95HJrQG4bh5ujpxdiD1no2+/Q7mBkKTS7ha+G5d+uHtKLX33A+8CCxo++9inUKdzhbE7/v86dWIIpKf4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 05:53:09 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::b002:7084:f022:9152]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::b002:7084:f022:9152%6]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 05:53:09 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 05/14] vfio/mdev: simplify mdev_type handling
Thread-Topic: [PATCH 05/14] vfio/mdev: simplify mdev_type handling
Thread-Index: AQHYte/KB7YhzUhsnEyymvWWm3tJoa27ybzw
Date:   Tue, 23 Aug 2022 05:53:09 +0000
Message-ID: <DM4PR11MB5502308793A102A470A91CF888709@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20220822062208.152745-1-hch@lst.de>
 <20220822062208.152745-6-hch@lst.de>
In-Reply-To: <20220822062208.152745-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6844108f-895e-4a0c-ba16-08da84cbc226
x-ms-traffictypediagnostic: BYAPR11MB3734:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fY4cP5rAFizD+r3oiMthH54d8A/5Sc9O+vIEdcfJ9y5a62vVRQyrP/DWuBEN5sH7WZmPuKomOV1l+0/c4Nm/zHlqQmrqTZYOknBnylYN4iOhxG1YByt5FmzpgCT+EZaP9nDNQVdlv25tKJDs2dERVSXeV0ZjErzgqkPxNhZw0jGN9jrz6++SrdAA45Fl5wgJIcTH0eppJvj1o3RrrlA7tN0mAS5QzXJBECJo1pGjtCdzTCtTViRNWTfXuKYyHQD7yx5r+H+ju/5y4hjKpPg6GsugE+LI6G2yjzzFoIyEFz6coArgjc36DYWYChMCPQmYTh00+LbPi7nyt2ANW7q9QBd2EUKGFZQuxhjzBz71pwwgoCwyjCyNmoUctBvFFyKCvGuwXbOBoO/KptegF/LP5EtL02t2JVkfN1vznCprk5DrBVEVQQHceBSqPyiJUe5nI7cvhP3hnWdjAKUR6niOVWRloUM1oF3IA/L2aAYBfu7frh2HzGnlsZj2p/29bnF9/yhZToIr9dcPbzKNusagcRXPURLcWtAHtXGLgYoR7qfy3ypiUD2EzLzaf1f7ZxQguRti5HoamFryvuhj2kdNa+6/HCGJwQW2ybadBcgSMEOwhDbs8OWql0joGxSFf0aq8bHaU7Ygyq3QNybyy0tqDmlA4E9ieUHXGWP/sg72enr5liLCpAkCsLxm+N7ya8rzYzhuV+x/pCa4BjVR9fh9yK4sSDgU/3AmgB24SwwU3BfcXUm1vWf2VkWXzUKri8T0rCa3Xa+v1mowS6MOLjtug0f2VE85foKxWIpMouXJRjQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39860400002)(366004)(136003)(396003)(86362001)(82960400001)(921005)(38070700005)(122000001)(38100700002)(316002)(54906003)(110136005)(52536014)(7416002)(5660300002)(66476007)(66556008)(66446008)(76116006)(66946007)(64756008)(4326008)(8676002)(2906002)(186003)(8936002)(55016003)(478600001)(7696005)(26005)(53546011)(9686003)(41300700001)(6506007)(33656002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oZoEJSypU5QX2Q8c0x9OT4NvaqaSAxGNGHRGi+73k9GXOcVQ4HZyHKkbbMGm?=
 =?us-ascii?Q?pEJt3wgBkCnqI1UV95Q6JLhFKUdEpy0GI/iLy8xnyqJVmCov+ORGi6rTIp+B?=
 =?us-ascii?Q?p4Ou5ba+sH+oTOQ0paYVRBSaqnMueJjr1QmkERZXmQieCwLB+dOAwdh1h/bk?=
 =?us-ascii?Q?Mb79fZNZ6/ZLfEpxCJyufzVnqQQtzKLQyazHI/PhmpMWMTsSi0H8ScnIjQtk?=
 =?us-ascii?Q?Vuqz97ASolp3z0p9eN811gqDtTiVSRWPVyZbeocoZeULo/4oUR7LcTKCAGyx?=
 =?us-ascii?Q?OZv+jtYtPj9YzC88zgOAjIUaN7P2PUvX7RIwHcruWqin8MxsHIvCxkCZsLrj?=
 =?us-ascii?Q?rf+nthLFrug/dvuIupBBUoqFqtJ8+ZKifEosV2Qs2wK1pqzL7LTlVuS+npPa?=
 =?us-ascii?Q?dy4P+qA6SVh8kRzRzm55sbi+n9HjSDfMzFk8OSrsdqyc8+N7z4v3q/lz1EAg?=
 =?us-ascii?Q?z3EiC3ySfGvL/sBZwBvabtAdYjew/QE2+p/jOdgtVy4EYPxAIJcQTs8dgASi?=
 =?us-ascii?Q?pZImPGhJbc6lpo6CRjVtLwItTm/Ll9s0r5dh5oMrUpaEY9eSEqJZNFzMk1XA?=
 =?us-ascii?Q?7wzz1rUU2A6GaGhJ7jNUzYAqbnY7RqzpfVhfGc6hDuTqODMt/kwYlpWedMBD?=
 =?us-ascii?Q?oq2LiltU7RY1dqX9aDMazK2VbHSuYAQl7eiqTlMEyFbhvDAQS7deY/lUhmeW?=
 =?us-ascii?Q?CKIwY+u/p1HxxnG/bhyKkE7oHCKiO5zSqtfFxdJSyvzK/nkzGy/avyWqj1BQ?=
 =?us-ascii?Q?cw7gLSk/ZaVcNwcthsie/FcoyKvlxtiZIr64AJMGIEc5sMfpby3luWcpyTK5?=
 =?us-ascii?Q?fo1lYt/cDU97pC4kAGm+3yzAXA0r2GPg+BAYmEwNkx/PWsUF47OrMIPIqSWi?=
 =?us-ascii?Q?3/nC2d6FfSlE9vc5G2ZfX6b/E1OOY+rluege1Y7bK8Ewy343CpFRt2ZKhUaC?=
 =?us-ascii?Q?Ebxe+xJ8GXzQR7FGn0PUil5fWJftrY28LT8H5g66UV/0beTsgZ8zgn1QQiPo?=
 =?us-ascii?Q?5fwnHs8qhUa/adeU1j2NuN4nW1Ee+mlO2SFpacCjRD+i89JHvmVqLZnUern9?=
 =?us-ascii?Q?Iuayd53YnTovFdINLnkIzd3Kv5rB2dqBDSIqauLmD0ry3Fusv9brwIYxsbB2?=
 =?us-ascii?Q?uIAM4UoeAmxyVQyOPcpc1rU/H6O/aJxei3/6dUVZlRDwJ4XuG0d7O1l1AYnS?=
 =?us-ascii?Q?ZR2S/NcxoZaIDYiKQW0jt9T+Bx92QiFdvSbplIUQMtyCYorxAUCkILAnTGGv?=
 =?us-ascii?Q?DFTcBHSwMTAzKtm9Ugdj7GsT4HDvj/feMKXqdQr52G1MI8u7c1DsrL66eYLe?=
 =?us-ascii?Q?Tdx0PqcInX5p/FCPwzTG4uHe8SihPPNZubP5Ff1zwSt6AmpqUx4Q5010nuyv?=
 =?us-ascii?Q?Nqooc0gLQQo5dsLtrjpLBRw5iS67diMDsiUDUuw5HJBEX1tXULATvVzy/HOp?=
 =?us-ascii?Q?qSlD1W09jDbnMQQV7vWdYDcdIaS3vpVaHk8gw0Poi9YIuP9b1fKtisbcFbv3?=
 =?us-ascii?Q?3WH4ITVH2d7sI9FDT0QhgcvHA87LtKq244WVkgDIb/MRzZx0eIwvrCHXVN8A?=
 =?us-ascii?Q?VRL4LF5E4aKRfBzjDaCvJPf69vR6Ou2E9Xv10nG9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6844108f-895e-4a0c-ba16-08da84cbc226
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 05:53:09.6267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0neLYvl6Xhq6lIJ9PONAlw8mFL/Bsc0zd2BUL0VHd+CQso4yFJ4KXQclBJU5BmF3+/zSpg3FqJcSZHSqgrKAmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3734
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, August 22, 2022 2:22 PM, Christoph Hellwig <hch@lst.de> wrote:

>  /*
>   * Used in mdev_type_attribute sysfs functions to return the parent stru=
ct
>   * device
> @@ -85,6 +65,8 @@ static int mdev_device_remove_cb(struct device *dev,
> void *data)
>   * @parent: parent structure registered
>   * @dev: device structure representing parent device.
>   * @mdev_driver: Device driver to bind to the newly created mdev
> + * @types: Array of supported mdev types
> + * @nr_types: Number of entries in @types
>   *
>   * Registers the @parent stucture as a parent for mdev types and thus md=
ev
>   * devices.  The caller needs to hold a reference on @dev that must not =
be
> @@ -93,20 +75,19 @@ static int mdev_device_remove_cb(struct device
> *dev, void *data)
>   * Returns a negative value on error, otherwise 0.
>   */
>  int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
> -		struct mdev_driver *mdev_driver)
> +		struct mdev_driver *mdev_driver, struct mdev_type
> **types,
> +		unsigned int nr_types)
>  {
>  	char *env_string =3D "MDEV_STATE=3Dregistered";
>  	char *envp[] =3D { env_string, NULL };
>  	int ret;
>=20
> -	/* check for mandatory ops */
> -	if (!mdev_driver->supported_type_groups)
> -		return -EINVAL;
> -
>  	memset(parent, 0, sizeof(*parent));
>  	init_rwsem(&parent->unreg_sem);
>  	parent->dev =3D dev;
>  	parent->mdev_driver =3D mdev_driver;
> +	parent->types =3D types;

This would potentially introduce a bug. Types is passed from the parent and=
 memory reserved for it is
managed by the parent driver, while if you are doing so, it will be freed w=
hen types->kobj is released in=20
mdev module, i.e. in mdev_type_release, types will be freed as a chunk of m=
emory in heap.=20
This will lead to unpredictable behavior and require a fix,  either in here=
 or in mdev_type_release.

Thanks,
Xin

> +	parent->nr_types =3D nr_types;
>=20
>  	if (!mdev_bus_compat_class) {
>  		mdev_bus_compat_class =3D
> class_compat_register("mdev_bus");
> +static int mdev_type_add(struct mdev_parent *parent, struct mdev_type
> *type)
>  {
> -	struct mdev_type *type;
> -	struct attribute_group *group =3D
> -		parent->mdev_driver-
> >supported_type_groups[type_group_id];
>  	int ret;
>=20
> -	if (!group->name) {
> -		pr_err("%s: Type name empty!\n", __func__);
> -		return ERR_PTR(-EINVAL);
> -	}
> -
> -	type =3D kzalloc(sizeof(*type), GFP_KERNEL);
> -	if (!type)
> -		return ERR_PTR(-ENOMEM);
> -
>  	type->kobj.kset =3D parent->mdev_types_kset;
>  	type->parent =3D parent;
>  	/* Pairs with the put in mdev_type_release() */
>  	get_device(parent->dev);
> -	type->type_group_id =3D type_group_id;
>=20
>  	ret =3D kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>  				   "%s-%s", dev_driver_string(parent->dev),
> -				   group->name);
> +				   type->sysfs_name);
>  	if (ret) {
>  		kobject_put(&type->kobj);
> -		return ERR_PTR(ret);
> +		return ret;
>  	}
>=20
>  	ret =3D sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
