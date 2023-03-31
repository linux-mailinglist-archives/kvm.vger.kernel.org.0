Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA646D1999
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 10:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCaIQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 04:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjCaIQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 04:16:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67DD10E;
        Fri, 31 Mar 2023 01:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680250586; x=1711786586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v3ZcV9GYwuy5k5VcQ/8JsrOY/gK3IH8AVIVGRKqE988=;
  b=GTuulIaoYRiZjS4oZi1Frw+uAynfo5zTzriAIU1jFERbC5rxHmEJW91H
   HQyyC63mi2x68bp2CHC/s7Z2i2P50ZKiKrmnROoLyHsDKFLcJXdUA4gnX
   qzLswVD64aN+JwLgk6t5Nw+5ul5Mw4ofZ9boOuVFrggefu9ZKnhWk3ptS
   33J1AP0Z4nnEfqlGUa3tbpmvzkIr+j3gF9SQl9/eU8R2BffFVmFmUq19r
   LzsFKiggWpDNjCfST5IpQVEv8cA6pKhjM9ofm0Qranju5myUUv2HJKBcA
   AerwUsU5KwfrNhK2VuF0G1xw+S+al8G0eeoicE9tG1HkvmCOU+Jj1r0wL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="427673707"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="427673707"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 01:16:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="774284821"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="774284821"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Mar 2023 01:16:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 01:16:24 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 31 Mar 2023 01:16:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 31 Mar 2023 01:16:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 31 Mar 2023 01:16:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktZ0JzzSfMaWtnH3w/uNZxOuMWGHWHlBH4Pv2YW3d8ZS0sa4k7Sv8MAB2Cqk8ds9muQ6fuCmfvoxbK61LuduABd9r0X9botdowV3S0sn858y+d7VDacgwJC4M+BoMJX07iORXGSv7at0LlPDQR6vLjl6iGwuRNUO54BAP0msfYLQKqohAk0EYzihw8t2n36YKzjztz3XtHL1SKMIlS5+hkCUwco/U1o18Z0HHxuNp6FJTKWej6sVL3WETSNgjbRsGEVOxNs70MP7g9g27a4TLPo5DxK3SghTPkdtXzsAagsLUJnV2GsuwoJH7cNBoijW6h0sSxVMOuScY0w84Iy3DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RDarEzxwvNILH2164epRldDPstKxBXOyzNxco7qX/WA=;
 b=MTZGaFP1o8PPkFFTT0T6qX9TtbZ8kdqmeoi6ijI5tbEGnPDredoji8CxY/n0C7uNaUOb/DENps8th7gs5iwr49AWH34qP9kB8nqhsIidHHLu09ssFrywsEjgybXhyZY98MlIKVsOtXR2YApB4URVeQLmVtcXA8od4s3dFaT+D7J1y/4LIc47fx9UzaafU6RJZeHvNNopAVSce5UrrGsHulM72NIUouZfSG1mkf04oA3oTjjB8z70VrCshDpyLEXSDh8W17deE6hmp91LY2X7xi/JkF5Eo++QG+tYfGcPril2iu0V5VVQPJ/FB5D4HDkCHJZhTs1DPnHtrP4xd2Qg5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN6PR11MB8244.namprd11.prod.outlook.com (2603:10b6:208:470::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 08:16:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 08:16:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 2/6] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v3 2/6] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZYI9Fb3LKkYOj20aMOMUTtKdKla8SMNoAgAJfHFA=
Date:   Fri, 31 Mar 2023 08:16:16 +0000
Message-ID: <BN9PR11MB5276BB3F0494E0CAC07AF4918C8F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
 <20230327093351.44505-3-yi.l.liu@intel.com> <ZCSYqHIo/QrFL70C@nvidia.com>
In-Reply-To: <ZCSYqHIo/QrFL70C@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN6PR11MB8244:EE_
x-ms-office365-filtering-correlation-id: c5d5f1f8-5852-45d9-fc2e-08db31c0331b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 00FZf710fPQSzFTBpV538qCPsYkYp3DzeS7dInQGte73helZ94WtKvjNhasSjsuINJkHLKasruZmxmfuTqtE/ypU8aJgdSRnHMUNe3lkMg2qEhhBfALjem6DyDNpS1H5WXSwN351zgUmmTPrNAh3mVlCivC7iIEqfTcOLwKSWavefgR5jfp0YJx74goQjT3Rpt6EboNNXLuM/GB05d8WhdMxQMJDbIBQhLVigVw86h7nssSWvEjWOPI2nlmSVrklvMD6zNU5zuVN4ZoWH0ZW90LGWGQJDmF4I1YayMzx+Kx/OMi3Lw/ZluDiJiHLFXf7lFgDJLVtNHhSG9WNvje9JdLdNoNnluTIXKlgO4k7bn/pvJdAy/XKEDxubHfFdencffMsUWw7L5WerBDv1fGB0zVbVR8GboYzOGeX/JbQKkOvUwM3X34YJhx5oKPV+4AApyjL1xOuUgrXhVVHT6CXqjO6415/Re1T3Zg2SCEUHEmHkaICrjJJ8TH8SWJchHl6DFmBmGjU9M3CMO8xi0x/0HkaKfC6pa7V6qL9BHFVKlMEVunIot89GJ/0drG9R+P5pVURKL/+DwdOv6gAaAHAfjY7qh6tM5kXeWib2ZHTE7Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(136003)(396003)(39860400002)(451199021)(2906002)(4744005)(33656002)(6636002)(83380400001)(41300700001)(6506007)(66556008)(7416002)(71200400001)(5660300002)(64756008)(478600001)(55016003)(8676002)(110136005)(52536014)(8936002)(54906003)(66476007)(4326008)(316002)(66446008)(76116006)(66946007)(7696005)(9686003)(186003)(82960400001)(26005)(122000001)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nppzlg0PG+tt7ILgk0l0Jfi6yFgWM0AOOXPA9IWB06kYmuRDNrJ386aITsEf?=
 =?us-ascii?Q?0IjFRRvogAs8SdfXWiTLf1q0Imit1V1LAsetfCvsm187yiIh+9xbRwh8jlFQ?=
 =?us-ascii?Q?SGDNF3eNnY8g06gL7mDRFHdVLHBBLLwlxOebwYgt83Mjy3/+FhAdpNPVX1lF?=
 =?us-ascii?Q?u3yKG6IPHzHhlnEVcpQEKnufxMp9bwTvi4NSYf+mc139VU/ykmOG7dwWRnH/?=
 =?us-ascii?Q?FqPp1u6xRXm0tjdxnN7dgfiClPHWhhjKYp8/2hJZEHvZHctWcyNAZch0yuWE?=
 =?us-ascii?Q?Qn7rH2AHwYT09NZIpWHkHql9iho+Dd2i7JbzkdrYM18AdhE6+z5jhsxF3JtA?=
 =?us-ascii?Q?Tvbh9iGcJqsc4n2Xz+IOtGlaaRbeUMx3ClPsu3/7nrcNw/2okqX5RVJX2Uwd?=
 =?us-ascii?Q?sU9OK92+7j2pOYcFgptGoEahUcV/jlQDr9FPJcnsjY96B6E2bzPZASr9HmJo?=
 =?us-ascii?Q?CWV+hcco1cqJKWslGU6rn86PXBZW00A7ulbK3da31gmZw/5zepgZXa9F+lYv?=
 =?us-ascii?Q?EHwdB+vSVrDsk/dl4FpK4qdaf0TZV12E+lxWzvyNajK3tbmuX1Xx6yCT6DOi?=
 =?us-ascii?Q?05UlvoBwkVR8i077BISxrYHXDHyLKo7bE1FqsM96bRgUcOEGJoZEqFolTuPu?=
 =?us-ascii?Q?+8HprNq8oZMGyyXDMN8wzBqQZx2VFjL04m3g4RAgc39Q0B8vEK6BRHPA4lHm?=
 =?us-ascii?Q?hAIxL/aXGruV6gOFps2zanbJ/OX4AT05DwXXvjjad4kE5qmM/xw57EFvY2DT?=
 =?us-ascii?Q?V4IdJxSDueiFNm+BeV7SkZ39RvBb8gfD0eAH3VFhCmQ9wibSOI+dVAbAHJ2p?=
 =?us-ascii?Q?kDUqZfYxbYl4TAuoFOcqn8ND/zcQzMrRLLTpSiHrs6sk4xr7FCZUvt/QLDh6?=
 =?us-ascii?Q?1xHROskPw59VwejMitoiZiC8YoPl85T9JgGQmusKZrnCWsdG6bBChDniiOsn?=
 =?us-ascii?Q?OqpK+KTnI0OKbIy8SqE5AW2GKN+zsCUQu4XnysWZIlp5vYuSHZEbTbG8PMeA?=
 =?us-ascii?Q?QvbZrCtNScOCIwYuEXoUqBcV+I0jtI9JZHN64Y3KLXW5DbDxFyJUwcM4MPoj?=
 =?us-ascii?Q?K+0dY9C+84X8hpSwoikrRI86jxGR2CDfNdzdcuDjVGlFCBMlkawWo8mVw4M4?=
 =?us-ascii?Q?Bs4K9fSUpM+SBUzoN00PwaxzRe9xtYx7VHto5vPhCfmdQhbq277wip1UTp7L?=
 =?us-ascii?Q?A3prvxYuHZ/eazXQ2vF7NRa22TtS5MHZu/W9xH7cm44lZvXC1Edr2+FxKhWS?=
 =?us-ascii?Q?/k9qX0BkzXlD/CyiE22qxbxIK/07AhkIvbUcDtnwpRZLmhbW7zyXh+9s0hCN?=
 =?us-ascii?Q?hRpViTW51wZ6GnvaywD0zJSe+p57XeI7lGidLvFBavH61gFagZh01PT0W3eP?=
 =?us-ascii?Q?XlLH/4jlA55o5cTVIf1WOhgnbHnsg9/W595Yf3jsNRaPktXHuMxg1Eb6YTWl?=
 =?us-ascii?Q?wqUdJuVo705lI5ssJSlrwxdIIV0mPRWjO+8DZ1JmrTpfwDKX8F20gkU2MeXl?=
 =?us-ascii?Q?hgnGAkXrgXT/37nBz4Hg+d5Ay9zExGn51VU7Zd9ppf7sw8AZerGvnYMW5k6z?=
 =?us-ascii?Q?NVKRrh6BNmmAN0ICjfulDlwLM2WSekLdwoXH8XGQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d5f1f8-5852-45d9-fc2e-08db31c0331b
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 08:16:16.3398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+qt5Q3XW3sv//P5ojwno/bfNlhpcuYYOcInsu5snC6MhLwpSEn6C1XiSNYj808x9L1g1a66NU9AYIxB0Asj6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 30, 2023 4:00 AM
>=20
> On Mon, Mar 27, 2023 at 02:33:47AM -0700, Yi Liu wrote:
> > @@ -494,6 +479,30 @@ void iommufd_access_destroy(struct
> iommufd_access *access)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
> >
> > +int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> > +{
> > +	struct iommufd_ioas *new_ioas;
> > +	int rc =3D 0;
> > +
> > +	if (access->ioas !=3D NULL && access->ioas->obj.id !=3D ioas_id)
> > +		return -EINVAL;
>=20
> This should just be
>=20
>    if (access->ioas)
>         return -EINVAL;

the physical path has the same check:

	if (idev->igroup->hwpt !=3D NULL && idev->igroup->hwpt !=3D hwpt) {
		rc =3D -EINVAL;
		goto err_unlock;
	}

If we change here then that one should be changed too.
