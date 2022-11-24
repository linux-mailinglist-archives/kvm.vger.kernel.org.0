Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149236371BE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 06:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKXF01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 00:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXF0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 00:26:25 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6134C050A
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 21:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669267582; x=1700803582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HzRfR/svNuQHFHFFJ6RLwqJd7FDE8aAhASiH7w2UokE=;
  b=eQaHISXZl+AZAQK5vduE/IkX/RapLOa2mcK+wOMXhtwXuZoDakW2fLYl
   AMSJ5/JfoJqgCDhMMpAitHGFgpM2VjmDxMXTXVD6HZXfcZdyOt3W4BCyO
   KYmoMvzXa0c+ZMFIBcv8pt+QCkph8Rqg3L3DbVD476wVuoI2vO7eOcSZL
   SIbvzrNK1d/6jUx5WPdil+f/3B0jBdt3xXyj943U5tYyMtBpMyLh+YJyZ
   pZ0XxBaIkXD7salVX9SqcoUPl67CI1A05Y04opQPthjM+IhqETpkrEq8d
   Db44NjpUjuLfFwru6/pFXXpRq0JA7h5FpJ26oR+VgfFFnOCrmzwePnnT7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301781349"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="301781349"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 21:26:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="748088591"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="748088591"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 21:26:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 21:26:21 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 21:26:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 21:26:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 21:26:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXs2iEQk/e0iLdXHpunDNpm5suFI6XMUK0zOsvlOLnp2XVl8g8T7BtoGGyVOp1nL4ds0GlfOscAOSLJE6f6xDrieYy0C+B5g+q5eJWEsYXq7ARk4DcPA3CA0qpNSFi93HZ3XeqV9V04N6o9ZdAqxxLtHUnerr2krdDHkxcjkkrW/6ook5ZtuRNOAHxIcTVKTqW8mDzvWYVBVne9FxOcLwEO+z1WzdaTxTpq76U+S+qbjIVexY/O1xXB6H4VJfkK0uOh8zhOfCmU/NVIvTXlqHdsqULHq+Z6pMWyxYi1ww5GGDSQuyugD09WrNxXjHk78GSmXxr0DVHSbp+6aawDpkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIKRjc77gTYGa6ratTj2OiUsyetv206kcTNZtcrLQbQ=;
 b=Trv/R9H3PO472yyPj5vxWtZWB+QxmZSURxF7bl0xl765LrpFZMEru/+O1OyYr+pjZU0X85r6NDCyBZb0fPm1nYbfqv/TJ6Qe0HgVuJhbi8YYi7A5vE7Kjg9LxC7WzOU71o72PdWJ3ri/9ggYvCmScl8LOgsRHeQQdmb8I7/DvRtq61n359ByjZpQPb1O4/u0z5/Oc3ZBzjAHNDTAlqc2/QsMi/2u6afuAdqqF1XvtADtEgBZ92ayD/IvrTPBbnhuyHz3rWhyj1jyQ3zjpMJI0GnwGxjUdAhHcavLj4odU1QARzL2K3PM2p/3PuzF9yvmjMwj+bQDxgjshZlEujX/Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 05:26:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%8]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 05:26:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Thread-Topic: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Thread-Index: AQHY+gA1L/qNziGKzEi+LQz2iXoY7a5Djn6AgAFEfQCAAFP4AIAFEScAgAK8z4CAAKDl0A==
Date:   Thu, 24 Nov 2022 05:26:18 +0000
Message-ID: <BN9PR11MB5276A2E9E583E2AD3AF846F48C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com> <Y3544WmLZArbtbLn@nvidia.com>
In-Reply-To: <Y3544WmLZArbtbLn@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6535:EE_
x-ms-office365-filtering-correlation-id: 403b1b8b-79d7-43b0-f612-08dacddc6a49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PeE8+aKBgQerGM0iev2JAaPftdg3p58Pvx4COAycdNfr+J4s1dPaxCmShRjLvRx9EO4lUgY40R/FsPOc5JASWPMq8VrOM1+KPQ8JIcfbYJmZ2qoM57Kov9ENRzEfOvoo+XzPr/rIj1Eb6+rRtY8l5v4Lsp65eYFFDhWhFap/v15PDpL60SEm6TkszpzGF464bcp6xUTEdJ0ufyE02lzOhk9rmdx6enIv9zh3URvRRhRwrSy+4ngugWHecF35LDL4yZGQG0nFfBGQeFU+KZ8Tt6M679kk8oHyCooMUalCHwmKOBUWRZip+XrRbuHiQAunt37VE47zvxuw29Qr4EsBcdqz/JZbjs9P5BwUG4xn0UyyBpKogYaiupzuXIX4OWmraOufVU6ydqz+zlosVdV9eNtMthMX1t2YtqcSYSHbYonjmMtbOdCubSBMUbjJLip5XgP9Le58UNoibcUhmyTMlZbBXnslFw+opTJa1Bws+NwdV/xeP7N2q2OnNkDWFh00YToZD8Jrqe8RaPFemRCxFoWCueAs3MOBliNy+knzogMpezVlvZcGptYHcc7/KY9gYeXIFJwN4dDpt3yo85S+UHzugG+i/pi6zMEvPXIzhPozXz5nMYBVFFe2PLOzM43CmfknfAT1a2O5QHij2PvmN/wsJlrqn0ZPGhInyfGSlGVNGJi6GAVuMvZ880toE8HPLW16lhd4ZydASFPphnoxpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199015)(71200400001)(110136005)(7696005)(6506007)(478600001)(64756008)(9686003)(66556008)(66946007)(76116006)(66476007)(26005)(66446008)(38070700005)(4326008)(8676002)(41300700001)(316002)(186003)(8936002)(52536014)(54906003)(30864003)(2906002)(82960400001)(86362001)(83380400001)(5660300002)(38100700002)(33656002)(122000001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8akoSESOwUIZCSObtn2eSDtQHH6ZukEqrkFTH4kOARRFzjtn9zwtdxvh3/7N?=
 =?us-ascii?Q?i+1Jn1pdaPLGewVje6EY4J2UGbj+254JQHO/0806Np3vc2fJwnHnTjklRMB/?=
 =?us-ascii?Q?YRTW/YzmtPeLEu3hTaBR8i/n6FBhuKBTofLchmuNkI4bHgfqee7LALArNhLm?=
 =?us-ascii?Q?WrKoF0b3eIxrYq6UC7MIh7K0W8YIsDUzjzcm2BuMZOK/kQ6Y8LeWfVEVrPjQ?=
 =?us-ascii?Q?zP3sKhryyIGz3sOxOU9hRneeJF1yFD0Ps0oixyqqPulG0a+Zyb6X1pyibzQM?=
 =?us-ascii?Q?x6cEVeA1FTkOJXcwg5RVuP1mpUC9q9+/DF4wrAkzhuPqZjQ8u0TB9VeV/kwL?=
 =?us-ascii?Q?vNXPqp6H8yRg+kMAyeNKm+hn6TUM4pzrIF4WNbB8//xlbk1zPjXHoP41Awh4?=
 =?us-ascii?Q?vL3gngeHSBQFxgd4rQ6ZQTy7CHF3B8WLf8rvYP4vHDwEFzFde4BkCi2/82dj?=
 =?us-ascii?Q?Oti4KlP7SeJ1pdtrw8tG0hZ0VF+i3OZQMOIx9w24W+iz85ozeRIHUkAfCAGz?=
 =?us-ascii?Q?i6TKgyNJRVKOTQ7wX00Owf+yjqQKJjsTQ6xreZL9kXwViRIkYbVRFgFKQk0b?=
 =?us-ascii?Q?MLf7JYkSD7ihSv8Prb1yeLwDEcijME/xv6yQ0etsZLgyaFOGI8Ph1f2++BI8?=
 =?us-ascii?Q?ckzG6qwiXqVicSEtVgMlZYrHux2QYImhp3PQesG759uBRpDwGFcoyKkTd/mj?=
 =?us-ascii?Q?YkODUQUffjJgjOyiV/89OeOa5qbc/i3p3COT/Mh6iZIOGyvhs1eOF21kxjGw?=
 =?us-ascii?Q?M7WlvU0v3ANlcV5aie/inrYfprls2LoafLSDKxJvZidPFwoTq4rprhtoEWUg?=
 =?us-ascii?Q?HIGJCCcmHOifOsbfjlMyOPDmxmp48BAEwuf0Rvgmdcd/SW8+mUBf4UcHsHR/?=
 =?us-ascii?Q?9nH5BT+fffbtq9x+sIcQaoDs4dlBQShzvhWZEntm/ETmBOuGP5WI4h+bV4R7?=
 =?us-ascii?Q?BEv0yqtDM3nafOLia1mo73SJLoHXYtiEBHk1Bbb3zWjqpaB3g4jrZTIewfzL?=
 =?us-ascii?Q?B26u+2rPFk/IgwlaEkG38poa4hT3UcqygdOYhJAqwQwuQRZv3BA8G5S4L+Ex?=
 =?us-ascii?Q?MzLqGwLx1aNzcXhjQL5qvmYNimXLs/4BdvNfvXBb/TZI5MlnO51sOa294qi7?=
 =?us-ascii?Q?ZMwsvP2nb9wD9xMPvvGwDnWqgWsthUnGYOh6dOHHempq1PEBMdtoaSAdixyb?=
 =?us-ascii?Q?dicZVUqDGHC0PxZU+WX1AqFhWBI11QnGcPwL3HA461SgHTK6kuZedCjcfp0L?=
 =?us-ascii?Q?QSCJMIHbPzU4JfsQIEQbPU6qqmmc/sVoKfedVkFqwLCxWZJiTu5CVhuH4itX?=
 =?us-ascii?Q?iNCI9HGSXRuDT13/exdxhgQLx6sTCy/D3Uymz51EsJ7QNLxzprlLEXcbKr8d?=
 =?us-ascii?Q?KVp0e2laGUSr2RPDCdNpLjn1IsgHv/G5+NKjHJphCgICrW6GPVVrepAWnzwb?=
 =?us-ascii?Q?gO8y3FlZ1WZHRq7xTup1zH7ug9w/sev7zQPMiM5AhgIdH/3TPSQKL8QW4ZFu?=
 =?us-ascii?Q?Q6Q90n+4YUPC99zd+d55VEPdVgyaoqhsW+6ddv8WWtrVLg4Ngo3/3o94M4DL?=
 =?us-ascii?Q?0PL6Dud7luhbb0imXhB2tRRklzlj3KW+38fh6sUu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 403b1b8b-79d7-43b0-f612-08dacddc6a49
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 05:26:18.5764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yJYtZd1E4vAn5yC4bSmfKWnihow4rcPV4ZpA9nMbB7CIfHhzGiwQzfyBGwbo9wOPcoyVG5zfSVddcQT8YJtMlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 24, 2022 3:48 AM
>=20
> On Mon, Nov 21, 2022 at 09:59:28PM -0400, Jason Gunthorpe wrote:
> > On Fri, Nov 18, 2022 at 01:36:46PM -0700, Alex Williamson wrote:
> > > On Fri, 18 Nov 2022 11:36:14 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Thu, Nov 17, 2022 at 01:14:51PM -0700, Alex Williamson wrote:
> > > > > On Wed, 16 Nov 2022 17:05:29 -0400
> > > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > > >
> > > > > > This legacy module knob has become uAPI, when set on the
> vfio_iommu_type1
> > > > > > it disables some security protections in the iommu drivers. Mov=
e the
> > > > > > storage for this knob to vfio_main.c so that iommufd can access=
 it
> too.
> > > > > >
> > > > > > The may need enhancing as we learn more about how necessary
> > > > > > allow_unsafe_interrupts is in the current state of the world. I=
f vfio
> > > > > > container is disabled then this option will not be available to=
 the
> user.
> > > > > >
> > > > > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > > > > Tested-by: Yi Liu <yi.l.liu@intel.com>
> > > > > > Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> > > > > > Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > > > > Tested-by: Yu He <yu.he@intel.com>
> > > > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > > > ---
> > > > > >  drivers/vfio/vfio.h             | 2 ++
> > > > > >  drivers/vfio/vfio_iommu_type1.c | 5 ++---
> > > > > >  drivers/vfio/vfio_main.c        | 3 +++
> > > > > >  3 files changed, 7 insertions(+), 3 deletions(-)
> > > > >
> > > > > It's really quite trivial to convert to a vfio_iommu.ko module to=
 host
> > > > > a separate option for this.  Half of the patch below is undoing w=
hat's
> > > > > done here.  Is your only concern with this approach that we use a=
 few
> > > > > KB more memory for the separate module?
> > > >
> > > > My main dislike is that it just seems arbitary to shunt iommufd
> > > > support to a module when it is always required by vfio.ko. In gener=
al
> > > > if you have a module that is only ever used by 1 other module, you
> > > > should probably just combine them. It saves memory and simplifies
> > > > operation (eg you don't have to unload a zoo of modules during
> > > > development testing)
> > >
> > > These are all great reasons for why iommufd should host this option, =
as
> > > it's fundamentally part of the DMA isolation of the device, which vfi=
o
> > > relies on iommufd to provide in this case.
> >
> > Fine, lets do that.
>=20
> It looks like this:
>=20
> diff --git a/drivers/iommu/iommufd/device.c
> b/drivers/iommu/iommufd/device.c
> index 07d4dcc0dbf5e1..6d088af776034b 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -9,6 +9,13 @@
>  #include "io_pagetable.h"
>  #include "iommufd_private.h"
>=20
> +static bool allow_unsafe_interrupts;
> +module_param(allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(
> +	allow_unsafe_interrupts,
> +	"Allow IOMMUFD to bind to devices even if the platform cannot
> isolate "
> +	"the MSI interrupt window. Enabling this is a security weakness.");
> +
>  /*
>   * A iommufd_device object represents the binding relationship between a
>   * consuming driver and the iommufd. These objects are created/destroyed
> by
> @@ -127,8 +134,7 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind,
> IOMMUFD);
>=20
>  static int iommufd_device_setup_msi(struct iommufd_device *idev,
>  				    struct iommufd_hw_pagetable *hwpt,
> -				    phys_addr_t sw_msi_start,
> -				    unsigned int flags)
> +				    phys_addr_t sw_msi_start)
>  {
>  	int rc;
>=20
> @@ -174,12 +180,11 @@ static int iommufd_device_setup_msi(struct
> iommufd_device *idev,
>  	 * historical compat with VFIO allow a module parameter to ignore
> the
>  	 * insecurity.
>  	 */
> -	if (!(flags &
> IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT))
> +	if (!allow_unsafe_interrupts)
>  		return -EPERM;
> -

keep the blank line.

>  	dev_warn(
>  		idev->dev,
> -		"Device interrupts cannot be isolated by the IOMMU, this
> platform in insecure. Use an \"allow_unsafe_interrupts\" module parameter
> to override\n");
> +		"MSI interrupt window cannot be isolated by the IOMMU,
> this platform in insecure. Use the \"allow_unsafe_interrupts\" module

s/in/is/

> parameter to override\n");
>  	return 0;
>  }
>=20
> @@ -195,8 +200,7 @@ static bool
> iommufd_hw_pagetable_has_group(struct iommufd_hw_pagetable *hwpt,
>  }
>=20
>  static int iommufd_device_do_attach(struct iommufd_device *idev,
> -				    struct iommufd_hw_pagetable *hwpt,
> -				    unsigned int flags)
> +				    struct iommufd_hw_pagetable *hwpt)
>  {
>  	phys_addr_t sw_msi_start =3D 0;
>  	int rc;
> @@ -226,7 +230,7 @@ static int iommufd_device_do_attach(struct
> iommufd_device *idev,
>  	if (rc)
>  		goto out_unlock;
>=20
> -	rc =3D iommufd_device_setup_msi(idev, hwpt, sw_msi_start, flags);
> +	rc =3D iommufd_device_setup_msi(idev, hwpt, sw_msi_start);
>  	if (rc)
>  		goto out_iova;
>=20
> @@ -268,8 +272,7 @@ static int iommufd_device_do_attach(struct
> iommufd_device *idev,
>   * Automatic domain selection will never pick a manually created domain.
>   */
>  static int iommufd_device_auto_get_domain(struct iommufd_device *idev,
> -					  struct iommufd_ioas *ioas,
> -					  unsigned int flags)
> +					  struct iommufd_ioas *ioas)
>  {
>  	struct iommufd_hw_pagetable *hwpt;
>  	int rc;
> @@ -284,7 +287,7 @@ static int iommufd_device_auto_get_domain(struct
> iommufd_device *idev,
>  		if (!hwpt->auto_domain)
>  			continue;
>=20
> -		rc =3D iommufd_device_do_attach(idev, hwpt, flags);
> +		rc =3D iommufd_device_do_attach(idev, hwpt);
>=20
>  		/*
>  		 * -EINVAL means the domain is incompatible with the device.
> @@ -303,7 +306,7 @@ static int iommufd_device_auto_get_domain(struct
> iommufd_device *idev,
>  	}
>  	hwpt->auto_domain =3D true;
>=20
> -	rc =3D iommufd_device_do_attach(idev, hwpt, flags);
> +	rc =3D iommufd_device_do_attach(idev, hwpt);
>  	if (rc)
>  		goto out_abort;
>  	list_add_tail(&hwpt->hwpt_item, &ioas->hwpt_list);
> @@ -324,7 +327,6 @@ static int iommufd_device_auto_get_domain(struct
> iommufd_device *idev,
>   * @idev: device to attach
>   * @pt_id: Input a IOMMUFD_OBJ_IOAS, or
> IOMMUFD_OBJ_HW_PAGETABLE
>   *         Output the IOMMUFD_OBJ_HW_PAGETABLE ID
> - * @flags: Optional flags
>   *
>   * This connects the device to an iommu_domain, either automatically or
> manually
>   * selected. Once this completes the device could do DMA.
> @@ -332,8 +334,7 @@ static int iommufd_device_auto_get_domain(struct
> iommufd_device *idev,
>   * The caller should return the resulting pt_id back to userspace.
>   * This function is undone by calling iommufd_device_detach().
>   */
> -int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
> -			  unsigned int flags)
> +int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
>  {
>  	struct iommufd_object *pt_obj;
>  	int rc;
> @@ -347,7 +348,7 @@ int iommufd_device_attach(struct iommufd_device
> *idev, u32 *pt_id,
>  		struct iommufd_hw_pagetable *hwpt =3D
>  			container_of(pt_obj, struct iommufd_hw_pagetable,
> obj);
>=20
> -		rc =3D iommufd_device_do_attach(idev, hwpt, flags);
> +		rc =3D iommufd_device_do_attach(idev, hwpt);
>  		if (rc)
>  			goto out_put_pt_obj;
>=20
> @@ -360,7 +361,7 @@ int iommufd_device_attach(struct iommufd_device
> *idev, u32 *pt_id,
>  		struct iommufd_ioas *ioas =3D
>  			container_of(pt_obj, struct iommufd_ioas, obj);
>=20
> -		rc =3D iommufd_device_auto_get_domain(idev, ioas, flags);
> +		rc =3D iommufd_device_auto_get_domain(idev, ioas);
>  		if (rc)
>  			goto out_put_pt_obj;
>  		break;
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 5a7ce4d9fbae0a..da50feb24b6e1d 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -108,12 +108,9 @@
> EXPORT_SYMBOL_GPL(vfio_iommufd_physical_unbind);
>=20
>  int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_=
id)
>  {
> -	unsigned int flags =3D 0;
>  	int rc;
>=20
> -	if (vfio_allow_unsafe_interrupts)
> -		flags |=3D
> IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT;
> -	rc =3D iommufd_device_attach(vdev->iommufd_device, pt_id, flags);
> +	rc =3D iommufd_device_attach(vdev->iommufd_device, pt_id);
>  	if (rc)
>  		return rc;
>  	vdev->iommufd_attached =3D true;
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 3378714a746274..ce5fe3fc493b4e 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -216,6 +216,4 @@ extern bool vfio_noiommu __read_mostly;
>  enum { vfio_noiommu =3D false };
>  #endif
>=20
> -extern bool vfio_allow_unsafe_interrupts;
> -
>  #endif
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 186e33a006d314..23c24fe98c00d4 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -44,8 +44,9 @@
>  #define DRIVER_AUTHOR   "Alex Williamson
> <alex.williamson@redhat.com>"
>  #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
>=20
> +static bool allow_unsafe_interrupts;
>  module_param_named(allow_unsafe_interrupts,
> -		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
> +		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(allow_unsafe_interrupts,
>  		 "Enable VFIO IOMMU support for on platforms without
> interrupt remapping support.");
>=20
> @@ -2281,7 +2282,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
>  		    iommu_group_for_each_dev(iommu_group, (void
> *)IOMMU_CAP_INTR_REMAP,
>  					     vfio_iommu_device_capable);
>=20
> -	if (!vfio_allow_unsafe_interrupts && !msi_remap) {
> +	if (!allow_unsafe_interrupts && !msi_remap) {
>  		pr_warn("%s: No interrupt remapping support.  Use the
> module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support
> on this platform\n",
>  		       __func__);
>  		ret =3D -EPERM;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 451a07eb702b34..593d45f43a16ba 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -52,9 +52,6 @@ static struct vfio {
>  	struct ida			device_ida;
>  } vfio;
>=20
> -bool vfio_allow_unsafe_interrupts;
> -EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
> -
>  static DEFINE_XARRAY(vfio_device_set_xa);
>  static const struct file_operations vfio_group_fops;
>=20
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index bf2b3ea5f90fd2..9d1afd417215d0 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -21,11 +21,7 @@ struct iommufd_device *iommufd_device_bind(struct
> iommufd_ctx *ictx,
>  					   struct device *dev, u32 *id);
>  void iommufd_device_unbind(struct iommufd_device *idev);
>=20
> -enum {
> -	IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT =3D 1 << 0,
> -};
> -int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id,
> -			  unsigned int flags);
> +int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
>  void iommufd_device_detach(struct iommufd_device *idev);
>=20
>  struct iommufd_access_ops {

this looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
