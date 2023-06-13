Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB4372E629
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbjFMOs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240716AbjFMOs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:48:27 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884D31734;
        Tue, 13 Jun 2023 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686667706; x=1718203706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P5ZShHDwisOFZFLpS8nLo9fPNXRELfcgL1lNo/kRIUg=;
  b=ZGTYY84qoZ61ci+ehCnT+xM2jdN2Sa/yEFF20ITM1Y9oUUBUbT+rD5rP
   ZvdiNueYxY/SBIuXVvgk4YhP0IQKmBfBRlT0h3BR7GFXnNdK2m1jPcpvX
   upia5zwf1aokasUSLjhF9M3JPT0AoFDbCScDRhrI/rIAeJFXA1mO4bchC
   xmWLHbdGydRPj4RZyH3J4SEUcAcxgvfaDk0vxWMy5Vi2+oH5bZGRufh63
   jjfnRUOA/UfOu2VzRaWGpBBmCzOxSb/zLM6NV1EomTL3Y2twyQL1Lsfb9
   wDvdqkVXrKoH3PSqu9qniRVGjL14chIGQv1u3OdPhMUjiqIbXCCVhz6Za
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="337992220"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337992220"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:48:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662034861"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="662034861"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 07:48:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:48:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:48:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:48:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:48:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch80ecqOf1J48WK5wzaJSyY04/fzf3hdS+JA9cpuJu8p0QnqM1sIWEsabAS62zA5+s9J/GM75ogowSx8i4CREcu8hPZFDz7UAL8u4N2xYm6b4iPWK04fosgETHBuqwVbwC1ZuUcVNBx3UYntOPa7MYRmoy1PD8ylCjsnH8VrkA8slQBIF8ZbmzXqhApGgQ0I3HhxGrx+aZS4otOEwQYwPxsCfvV3PxfT6eKoW0NFzX7BQXNswyA8BE6CkbIVG5a/gblARyaqJgxcHT+/Q1nXbtEp0wgArnRKkpmBT6MdXyjj0rKMPRYJDFrwszm50CdtU+c0YK8k3S2KtNCajZvcEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VK0kbx6XfyxbFfKD7Zm5h4bqhaIO65m3B+MyAr1pxWM=;
 b=O193pFqoMdYWU3Hs2o+hoQWj2VM45HAIskuM97+/zu8oZa3MIGxYajJuIhN0TGdJZHXlIj6UOnwN4HPFT2lHOO3NJkbU7oBE8gsJ6PGpsrWwqUUsiGos3TaEpQBANQKrAdxF31EjCFz5MB8WlHbUYVQDPfsqpsVNkHfC+jNcEsAO4U2clcajED/Ei18dDhVePUm9L9ZfDZ2s+zDA/nS00A9nSVnDmo9MRWqxEF8zVNYc/p/oYYlJXCGiedfeMy7saznsrorSGGxt9Y7af4874bWict19fNfdlp5haaCubnVJvFxAkvMXHihVD6QVaxl5hc7IhjXNNcEonJh24/XJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN6PR11MB8148.namprd11.prod.outlook.com (2603:10b6:208:472::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 13 Jun
 2023 14:48:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:48:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: RE: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v12 24/24] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZlUw9Uf04nacAO0q7EN/OKT++06+H2nAAgADVnWCAACregIAABjdg
Date:   Tue, 13 Jun 2023 14:48:02 +0000
Message-ID: <DS0PR11MB75297AC071F2EF4F49D85999C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-25-yi.l.liu@intel.com>
        <20230612170628.661ab2a6.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A71849EA06DA953BBCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613082427.453748f5.alex.williamson@redhat.com>
In-Reply-To: <20230613082427.453748f5.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MN6PR11MB8148:EE_
x-ms-office365-filtering-correlation-id: 3c177a3b-3078-4b8b-e1b1-08db6c1d3097
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zyt+VTZ0ySHqjhCBZUaGyn2+q44bAGzroZGrxpVaxC/9YhmNAdGKfkMXLIjY9DfN7NbWJo4D8JUwFeW2i6XwlzgGSmj9wWl0d/NTEzLC0+Ikuc9dyDVpkcEjRnA0mkUGoNAdNWJDQTSLidpLJGy2EFXNMjoyEkgniNcz35JlW75wdv8tdQsAULqFQGFEHFWM6oWWMULagsM/5eT5Hwyqj2hr1E6ugeNMJBIgqCp+yVUfqoJD6mbsQmYNjz+AFLWIxEzbgv8IpOHL7/J9RzqEjf7ucB8vejlgKCahy7+bR6Y7j6Im+o9yX+l5aQsxhtY4c2jUqOYipvZPQGb78wTyMn2TAnTgAVr8lTsptpmgSFeGuh/XaZ8/BQRw/ceCkbyhqPy0A9siFlGoRtySRzND8DhQNHi7BAhNJvod/6RNdHou3JiYUMUjde2uBZgUPWjqvm/lPdhvEFNInlZtH0E2aqGnyahiAYignAmhbb1BISPo1jfJo0/aVMaFU6v+0aEAF8vzbKU7t9pAumlHW2+8V6PqHaToYKCc5P/AEvVZ6xAEJccH8IodGsRW4DfDA3AUQyIJIcR445IZR8oFBllkE2YfJGqFV0N5zLuwe5B95TCT5sJz+x4nDVL6CVWDyklY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199021)(66556008)(66476007)(66446008)(64756008)(66946007)(6916009)(76116006)(8676002)(8936002)(38070700005)(38100700002)(86362001)(54906003)(122000001)(5660300002)(82960400001)(41300700001)(52536014)(478600001)(71200400001)(7416002)(316002)(33656002)(83380400001)(7696005)(2906002)(4326008)(186003)(26005)(55016003)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NLEisK9X6YzPy+sQxuOdV9Fzv53Gy4FPzWhsB1EDc91uuXRyULP/zA4eN4db?=
 =?us-ascii?Q?jnEQvMLVw2vZoOh1w3bplFNA1dPgK0Ro9s5aY5zn1yJRs5y9PlzB79eGyWQP?=
 =?us-ascii?Q?myRW1r/RQ+XXXtHDkpohxsgi4/paaALhwn90aDC7Mr/dWoMBFg/eruwp826t?=
 =?us-ascii?Q?2y/jJ5L4aOrpK1q6QIqmdtn+BicoInXdSGCsM8l4GBtI7pGmHTV1//Mri50n?=
 =?us-ascii?Q?DXUNwi/12zFLpNXPBgDFPmxF/Ic6ifvAawMxpZDaTY0L7gm2qd2gvy0FkirT?=
 =?us-ascii?Q?Y1Kfh5+RPWVwLe/KEOZ+cX1XKaqWfxrmegJvKTeZN885q+qR3WaVM2PgbR7l?=
 =?us-ascii?Q?Pmjz6FPKP2tvMufxAvJBAPP8GU96PIJLt0Tc2oSr1lgdfcRmygyLPMnNy3BS?=
 =?us-ascii?Q?CEAAq2W40cN+Knqaghdlabe+ixd5Y+ROFZxcDU7WlQI1AO14slBp1gw0wHgY?=
 =?us-ascii?Q?bd7a7f9bPr2BQL63zK7+pS/JD/ByYJhehcKpyU1vjXKfQ+U9X6ycvhgUf048?=
 =?us-ascii?Q?qHlD5MWpjQLSNbZyOEESFtfqyKVSI1oScNGeUORtclksxr3XvuyEhaek57bm?=
 =?us-ascii?Q?4ULdyvbH+17qE6z6/AuE82Sz8zbCZflfazEDXsNAGofto4N3u5sJV/iKiy0g?=
 =?us-ascii?Q?OmNOlnSQ3fEZyIohstkrjTKSeJS5zYQTGumpptuQr4M6ObaKXzjENwNHqxlK?=
 =?us-ascii?Q?fEbjFMhzxfPMv/KefUYDLN0XPbJGDDaqkKbufvJVQBUiu5J/AUa9WSkCZMlg?=
 =?us-ascii?Q?+QhU5ELeGa9E3YOVWSIa9ZX3GE6ShFiFMe/TwIkr55Wt+eKk+1O/IepsXwrQ?=
 =?us-ascii?Q?Z0X1+VNFa1ch85vIjPvF5ewkJ12duNc4tpitz8m/cP0U03R2LLm0QOSI41i5?=
 =?us-ascii?Q?cTg7fzfc9kbQVLgu89y2bpuXn70f5/Yt2eosqDiugZwG52voRuzc+OtjkVvJ?=
 =?us-ascii?Q?5I4eWPeUz2VwLa5pwjrRozfOVQu/u3J9j3tyb4TSjeSVpIt+ZPE8DEvjJubX?=
 =?us-ascii?Q?jjYvk52+M2kCiiJWYFNg7aD5RqtKCl8vTXGP2592z/16ynVys1vgUdApyRgZ?=
 =?us-ascii?Q?NFBfOcdJnksGHBFbxSM+JfojD8QNIQvLCcIflchPu5au3lixvU4gNRzhvwd6?=
 =?us-ascii?Q?CZJIIJrwxp3mS6MesIRcawEeU28ZiLi/PxX+NZEha1gqYZtwmpNV9mOzOWBy?=
 =?us-ascii?Q?l9S6DO2hpttbG2ctP3d61EOov2XV7hpfnNwphblY/Aikz1g3rG3/ffePoxIk?=
 =?us-ascii?Q?sNyUGYBLSRuc7F/KWwyEfINifTi+8c/TG1JlvbGHMgpZfuV/sDVO1mLruPh/?=
 =?us-ascii?Q?XBlaZefn83Ai+wxeFN+xCv9yD5Yx0Oo3y98V0erNOq63hWWxFHCFCHq/JgRa?=
 =?us-ascii?Q?8MhApRbyfGzCzz0GP23zgCT8Y9PezpqBZ41wlxLHIptNa7Fkb+dWNBzgqfO/?=
 =?us-ascii?Q?Xnmuw73UC6Za61jaHWPrpSE1obGbMLiNzPheqAxvy1S23dRjZExzoK4ioMdC?=
 =?us-ascii?Q?55aezWIEqiEndIRwxlnqqy59fvtW+ISUeo98SmTddW+8t5JPOf5n0Y7Czv2x?=
 =?us-ascii?Q?ruX7fzfalX4q/9K3wJuTZHKdQ7FNZP6S88e1DQm7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c177a3b-3078-4b8b-e1b1-08db6c1d3097
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:48:02.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDRy5v3eK569pCW5406vQ/yDZ5jeiWOSpTWgIY+T/rPSavBpEjzMAY7fL6dzKhl2tamOiqhSU2ovbroTxMSD1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8148
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:24 PM
>=20
> On Tue, 13 Jun 2023 12:01:51 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 13, 2023 7:06 AM
> > >
> > > On Fri,  2 Jun 2023 05:16:53 -0700
> > > Yi Liu <yi.l.liu@intel.com> wrote:
> > >
> > > > This gives notes for userspace applications on device cdev usage.
> > > >
> > > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > > ---
> > > >  Documentation/driver-api/vfio.rst | 132 ++++++++++++++++++++++++++=
++++
> > > >  1 file changed, 132 insertions(+)
> > > >
> > > > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driv=
er-api/vfio.rst
> > > > index 363e12c90b87..f00c9b86bda0 100644
> > > > --- a/Documentation/driver-api/vfio.rst
> > > > +++ b/Documentation/driver-api/vfio.rst
> > > > @@ -239,6 +239,130 @@ group and can access them as follows::
> > > >  	/* Gratuitous device reset and go... */
> > > >  	ioctl(device, VFIO_DEVICE_RESET);
> > > >
> > > > +IOMMUFD and vfio_iommu_type1
> > > > +----------------------------
> > > > +
> > > > +IOMMUFD is the new user API to manage I/O page tables from userspa=
ce.
> > > > +It intends to be the portal of delivering advanced userspace DMA
> > > > +features (nested translation [5]_, PASID [6]_, etc.) while also pr=
oviding
> > > > +a backwards compatibility interface for existing VFIO_TYPE1v2_IOMM=
U use
> > > > +cases.  Eventually the vfio_iommu_type1 driver, as well as the leg=
acy
> > > > +vfio container and group model is intended to be deprecated.
> > > > +
> > > > +The IOMMUFD backwards compatibility interface can be enabled two w=
ays.
> > > > +In the first method, the kernel can be configured with
> > > > +CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
> > > > +transparently provides the entire infrastructure for the VFIO
> > > > +container and IOMMU backend interfaces.  The compatibility mode ca=
n
> > > > +also be accessed if the VFIO container interface, ie. /dev/vfio/vf=
io is
> > > > +simply symlink'd to /dev/iommu.  Note that at the time of writing,=
 the
> > > > +compatibility mode is not entirely feature complete relative to
> > > > +VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
> > > > +provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Ther=
efore
> > > > +it is not generally advisable at this time to switch from native V=
FIO
> > > > +implementations to the IOMMUFD compatibility interfaces.
> > > > +
> > > > +Long term, VFIO users should migrate to device access through the =
cdev
> > > > +interface described below, and native access through the IOMMUFD
> > > > +provided interfaces.
> > > > +
> > > > +VFIO Device cdev
> > > > +----------------
> > > > +
> > > > +Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_=
FD
> > > > +in a VFIO group.
> > > > +
> > > > +With CONFIG_VFIO_DEVICE_CDEV=3Dy the user can now acquire a device=
 fd
> > > > +by directly opening a character device /dev/vfio/devices/vfioX whe=
re
> > > > +"X" is the number allocated uniquely by VFIO for registered device=
s.
> > > > +cdev interface does not support noiommu, so user should use the le=
gacy
> > > > +group interface if noiommu is needed.
> > > > +
> > > > +The cdev only works with IOMMUFD.  Both VFIO drivers and applicati=
ons
> > > > +must adapt to the new cdev security model which requires using
> > > > +VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
> > > > +actually use the device.  Once BIND succeeds then a VFIO device ca=
n
> > > > +be fully accessed by the user.
> > > > +
> > > > +VFIO device cdev doesn't rely on VFIO group/container/iommu driver=
s.
> > > > +Hence those modules can be fully compiled out in an environment
> > > > +where no legacy VFIO application exists.
> > > > +
> > > > +So far SPAPR does not support IOMMUFD yet.  So it cannot support d=
evice
> > > > +cdev neither.
> > >
> > > s/neither/either/
> >
> > Got it.
> >
> > >
> > > Unless I missed it, we've not described that vfio device cdev access =
is
> > > still bound by IOMMU group semantics, ie. there can be one DMA owner
> > > for the group.  That's a pretty common failure point for multi-functi=
on
> > > consumer device use cases, so the why, where, and how it fails should
> > > be well covered.
> >
> > Yes. this needs to be documented. How about below words:
> >
> > vfio device cdev access is still bound by IOMMU group semantics, ie. th=
ere
> > can be only one DMA owner for the group.  Devices belonging to the same
> > group can not be bound to multiple iommufd_ctx.
>=20
> ... or shared between native kernel and vfio drivers.

I suppose you mean the devices in one group are bound to different
drivers. right?

>=20
> >  The users that try to bind
> > such device to different iommufd shall be failed in VFIO_DEVICE_BIND_IO=
MMUFD
> > which is the start point to get full access for the device.
>=20
> "A violation of this ownership requirement will fail at the
> VFIO_DEVICE_BIND_IOMMUFD ioctl, which gates full device access."

Got it.

Regards,
Yi Liu
