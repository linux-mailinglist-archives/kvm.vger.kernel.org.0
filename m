Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1EF7546CE
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 06:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjGOERM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jul 2023 00:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjGOERK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jul 2023 00:17:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331F235A5;
        Fri, 14 Jul 2023 21:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689394629; x=1720930629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0qon23Zl1nKbBEdoLBuo1fQ0h66+LiV+0lzi8P+rbhQ=;
  b=VnF+ctlfwZFeKRxPaKKoix/4Ym3UWrQWj+1UAaRCqp5pnVV2exXDNCUP
   77PoFSrMYr/cJmcnpbYV9m0majj/oovTY/akXfGMuN4NvCaMeU69/p7SB
   SqdN9cg2MplIGM4+NrkEwRt+mN+C25YEwDTVm7oekTYLnitYC+8QZWu7a
   4wdxoyjISvfA686El1Y4Tva5DSCn94v5q1blT/wkKUZsz+abqE14SjRiA
   r2o393lxymfJFmlqDB4eu75poP5L/Ar8GXggSJJGhTqcNJSON4mj5ksMA
   jNyCXDXBMUsvbm9xaA34Yy4H/zMzvJO48gyg5IjDoZbUw6xfHko56Pfaz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="431808164"
X-IronPort-AV: E=Sophos;i="6.01,207,1684825200"; 
   d="scan'208";a="431808164"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 21:16:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10771"; a="699915865"
X-IronPort-AV: E=Sophos;i="6.01,207,1684825200"; 
   d="scan'208";a="699915865"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2023 21:16:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 21:16:56 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 14 Jul 2023 21:16:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 14 Jul 2023 21:16:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 14 Jul 2023 21:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNSCiH9hRsmMlQa+kRCTnoUUAsA4aUffLsvL3zzfEY25c3uBa+nhj+qZcvaSoDsjm0zySdN9CAC6avzoY7XpjmiGra7sdPwRN6Z1QnMZcvMMrpxrj0PpC0OORsywtEFl4RzbsF9ICFF0UhgiJ7jVDQG2lQIC+1o3TjJB5eTtOEQ6+cW1Cd5KJjp/XhVGvKcj2zNFYOJjyY8+Y1Lr+u3LqAUVlGiqZa/TgnpX4jVw3v2XpRcxTXooxGgCe6Xg39hHy6+lzL8oCUK1OWCbLM2EtgG4NTHPNUJfTgEcwwPp7+8KMkUspcx8OSJKab6sBqkQtA+N2IZwZMe9SOt9i8IIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUjFI8Sz1dQ0Fa25TJB+reikUZkOAtpS35qQcqO0wZI=;
 b=JcC4qHJHeH+iu28Qrdle5mhMpfrGGpjaKvfs7Ij7e1Vyp2n5uic0a3lu/NDhcFU8aaKjqSgcadfuM3uHC6escE2PkyC7yfNO4Pp0k9wx/g6eJDIh33wSfXTUXnVLfpR9rD/H8w3MmN0j3jA0AL6g36fq+8oMB1MiCuqKRRWxeqG0K863Z7i2rGjO+1cCLSGxBE/ad1gWt5p/5DBf3zKt132n1A3aZikgE/2envcX4w3xtT1Jjc42mcqa/ww78pANtmhIOYTj9l7OuS0wzQHHiLqi1aJRlMRnk/RMDaBllLtkL+49BH4i5lb4eEhQLUANpOCuehBVP5Ll9i4LeZ4fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB7574.namprd11.prod.outlook.com (2603:10b6:a03:4ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Sat, 15 Jul
 2023 04:16:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::806a:6364:af2:1aea%7]) with mapi id 15.20.6588.028; Sat, 15 Jul 2023
 04:16:52 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v14 22/26] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZs6PJ5wkagZbV3kqhRW+Tv/kBJ6+5W3MAgADiPuA=
Date:   Sat, 15 Jul 2023 04:16:52 +0000
Message-ID: <DS0PR11MB75297BF68F3FAD4B9EEA483AC335A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-23-yi.l.liu@intel.com> <ZLFewHxO8DSelEml@nvidia.com>
In-Reply-To: <ZLFewHxO8DSelEml@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ2PR11MB7574:EE_
x-ms-office365-filtering-correlation-id: 1bf2b1a9-4865-47e0-f3c4-08db84ea5155
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uwI9aEi7hV5RYAqXG/3eXqkvu4rvmzH4QRs5+fuMH3SPoIevmcdnUTYQbnnu4CJ1lU+rlPy+hAojsonr4AU5bvWSlgsgdhbSaxWZMr1e4mvS0eWhOClAjOZQT/JecKhBgpRC5EG4AbIQGvYC8O4MXZrY9c707vaRfjA3ZqTXDk9YuJvKQxu1x1ReYrq6XI/VGkzDiw+ZOh4fgBwvmsgHogaeqbt8uwIzxfNEmvAddbxydgsBznFdt6xm3HAY8+3uKVL543YxNdFuUen3Inq4tUuETSkGm2DLSD/+gL/1xiFnItBOorc2BnRoCba96emDejW2R7R1NefjFEUPMq4enf3TihT7fj8Fa0PHRqE+7tKPSfQ2DHfdy13mkHoIIIDruKpLKdRnr/aiGm2BAxt7Yi6gOUlbV3KxamVu/7BwtToIE+t9f2gvFhfXR0lV3+pi+rgXq8NKGJdc8VKCXsSTsyD6cyA9FoasI5YQsb4gSDSrCOD+HuUEcJie9bzQX2tt5YRfjJ8t0AaBmjKHkCFrFuuJMdq0KcsxL0R+JIrWlAMpTSv+oZfQYxLUFSGoTJF7c/GCO8I1LSYHkuSP8BWR+qXyywigniq6+7x0psNJTNwL1DP7/ArW1UwqPiDx7GbxwyzV0XMfS8QCXKpq9TcefA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(76116006)(2906002)(7696005)(7416002)(5660300002)(52536014)(9686003)(71200400001)(186003)(6506007)(26005)(55016003)(54906003)(33656002)(82960400001)(122000001)(38100700002)(86362001)(8676002)(478600001)(38070700005)(8936002)(316002)(66556008)(4326008)(66476007)(6916009)(66446008)(64756008)(41300700001)(66946007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U0JJVqwpXkpFJhucvr+pyBulcaqhabJo2ha8X4fnhAAge8IEMrVhPPhxK+4L?=
 =?us-ascii?Q?OqAy0ZOWMvWgtb/18I6IoObRNYOl90c8yArZp3MRdFiispvXnO5vYYPL2JBD?=
 =?us-ascii?Q?xYBXB4f3FjeWahTV3F/J+puLlEHYpH6PaYqbbZ8WGbeYmtQquW6HVutg4/W6?=
 =?us-ascii?Q?7QpALBEorkfO1u36ht4lfdZM3Jd0cT7rWlChNeJDKuNgMOJGTVhI9tZk7DAB?=
 =?us-ascii?Q?r/EoTQ9l67ha1asJzR6jybX/odPaFrHPUb+Jv8Z9maXFw66gAESOcumrZwKu?=
 =?us-ascii?Q?SMZt4X5zx/11CeC0OCGF2HaSnHoLFdGFryf9Q8J0KO2hJbEq5bCDUy6mS7QT?=
 =?us-ascii?Q?9q9BYJr6r0TPl1AreiHpERyWD+SOdjRvTcmJZVSbXn8UpoQeGI9XEGrBMc9Q?=
 =?us-ascii?Q?o0YvsYhltrYPcz0KKYB1gFK5vC+/mvo3yC+2qS5p0yIGAGaK+pOV023gItXW?=
 =?us-ascii?Q?6c46NPs3iz2IziEH6Os4iRvIgE9G+WIg570p+K9I84lT4CxhiOM1Bvt37pct?=
 =?us-ascii?Q?336BV4hx6UBUTvqUuhO6khsXmvcNqIaEqzPHiPlthBhbCLTrq3gCJVbhIvnN?=
 =?us-ascii?Q?FQV/FiPFScs4noKc8KGJpEJsi6xoUn0DJMovTjZc/PXZ/7TbsQkC4JJ/nKd1?=
 =?us-ascii?Q?pUPBR5YinLyLEF3ZfJOa6SNyV3a13CVXd5lJ2Lm+fIVsgpE8V/Bz/gC3cyCi?=
 =?us-ascii?Q?/NmVAUy0OT/Ryz5DqPFhtvtC/vY2ddt2QuINThJc5B3Asq6yZYQC7NvjMIa/?=
 =?us-ascii?Q?eTY0rTohvPvA2pwZtg8IAOa2p5/WGFvfSW1L8Iqf5sXGnlLdd5KmWZ4n/18P?=
 =?us-ascii?Q?g7TlsQPy/AIVBpnTTk9E6Coy4hfLCda7LVIrs/FrzCkwwxLZvG4Ao/abCfoV?=
 =?us-ascii?Q?JUPz5bXiNrCBTl2FYDCcAjWBisU6ho2DfpStBJ/MWkJszuSN0F8lqC048REE?=
 =?us-ascii?Q?xGCWX8OYkQiO+rd7g049mqkJa6t+E91d1uzfW1Ta6E7KLttdeYdTvBRQNaMT?=
 =?us-ascii?Q?deemvrY+WzyQSXw5tJ1osTOpm1UOdKV0EucuKhmf7voesSnfnWJV7kla5Hwa?=
 =?us-ascii?Q?Zt9Y02I4PdRnKfsOShuhfp+9OFzO5HT2hV+933c8ot5pCP5uXcxA/ngEUo5M?=
 =?us-ascii?Q?78quhecv1wgGv8nBQYyLwBnBO1jQfebCl2tXnGt3CLCepFi31a7i0XqlGpzO?=
 =?us-ascii?Q?5zHHYLywieFn8P0wIoLy8+/MCjyWWm2NE3PX7MqgSDniu4Ts4I4w/rU7ZfnE?=
 =?us-ascii?Q?5H1SMagWAzR+SIt4wXikKtwjA0MYyTxLn3ZizfGhicLf5bA/01AJrUqeyigk?=
 =?us-ascii?Q?/+YBr99ggQByEVZo3md2H1xcTspslUigrKSGiBipqyDapuEdrn+Iktja1SyC?=
 =?us-ascii?Q?YHC76yGdsB4L6sCnkLUBB8Sr5VbahuJR22E9ktSSDEtS2QBQzagFEBvWNYl6?=
 =?us-ascii?Q?399nb7wcFERfZNmwHq46XRvK74XCLkeYfZS+ZNe6T1/jDks3ICYWAtji3rCT?=
 =?us-ascii?Q?YHFXDGMjPEXGa/CSgUuuS2XuU2Ya1Xn8lpCWpy3WDcFeWIXJo9PvsaMb4Z0b?=
 =?us-ascii?Q?hw2HFzDVSn7X/dO+El8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf2b1a9-4865-47e0-f3c4-08db84ea5155
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2023 04:16:52.4639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ES+Pfi/xdSjfKnloQns7NjehEhcmD3IWstVCrDNnau/w35ogcEyiu4qteh492aVv7Jw82dQepdL6u7XS+Sis/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, July 14, 2023 10:42 PM
>=20
> On Mon, Jul 10, 2023 at 07:59:24PM -0700, Yi Liu wrote:
>=20
> > +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file =
*df,
> > +					      struct vfio_device_bind_iommufd __user
> *arg)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
>=20
> This should be -ENOTTY

Okay. Since there are quite a few stub functions in the drivers/vfio/vfio.h=
.
Let me check the rule. All the stub functions should return -ENOTTY in
the !IS_ENABLED(CONFIG_XXX) case, if the function returns int., is it?

> > @@ -1149,6 +1151,9 @@ static long vfio_device_fops_unl_ioctl(struct fil=
e *filep,
> >  	void __user *uptr =3D (void __user *)arg;
> >  	int ret;
> >
> > +	if (cmd =3D=3D VFIO_DEVICE_BIND_IOMMUFD)
> > +		return vfio_df_ioctl_bind_iommufd(df, uptr);
> > +
>=20
> And this function has a mistake too:
>=20
> 	default:
> 		if (unlikely(!device->ops->ioctl))
> 			ret =3D -EINVAL;
>=20
> Should also be -ENOTTY
>=20
> All the implementations of the ops already return -ENOTTY
>=20
> However, I think this is all slightly not quite right, the proper
> return code is supposed to be ENOIOCTLCMD which vfs_ioctl() then
> translates into ENOTTY for some reason..
>=20
> It looks Ok otherwise

This is not in the scope of this series. May need a separate fix patch. @Al=
ex?

Regards,
Yi Liu
