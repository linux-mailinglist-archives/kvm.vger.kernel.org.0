Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58836FB3DE
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbjEHPdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbjEHPdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:33:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED7D91;
        Mon,  8 May 2023 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683559984; x=1715095984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=puSrAVw2spOFq7LEIUrQx/v0gR0EAdaawRidutftb5Q=;
  b=OcDLRYJ2NnBBnIRoWJ8wPBytPtItfR7lWV3KSvmqybYV3/tWPKb6ssHF
   RpHVG70ovKcJGtRfs/khkJobVxtx/gVg+Z5WMI0h4ptYk7LVDCcLI6nAk
   /QO+7SQIcGZl5knV7apJiMerjgB5MxJSupLDN8ulfameDFJ+jZDXIvC4M
   f2mBdOLMr6Ya/AbcZWh0C661U03y8lgGuvRn6jEZbYdR7wbUB3qWq8fnz
   Nya9EcZUvzrRM5dQewYVAhIXF6XFW4Uy/ZCTxR6ODnxMkRVXuHZ/ZToNM
   IgCfHgXnLnDIfhW7Ce/c7jk8hbPgTShbXtb39exjU7g/vjTnOCLw2LgHZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="377773826"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="377773826"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 08:32:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="729121775"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="729121775"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 08 May 2023 08:32:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 08:32:47 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 08:32:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 08:32:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 08:32:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhCW9poEkyXu0S8a9NwLh65ipQ5CMKl2WaHy8RdGaLOr6qsJYY4pQkm6tmxqk0hGi1HDiW5+XzCK4gSPoGJSvChO5ClMQLGqfr+jqk+PbuUurvHiC7Vw1/iFrHXkXSASJHtgQEKwUZ7DLmypfe5Y1BzUdvDwKwK0UHG9XtMRp4xeaHS0OuzyepXJg8tIaAS4PNCs+Cvc2D8aFDlVesEGbmPUfID3u+ijuokJoKOV1k4Yom89jPHndhxK+ZWwWa35qxsHNzaExPiAqC498S6DNfKdFt8kp8OlmbI/2gMMfhEfB2Y7GPWPv4CBBxKNOd68cHgXAF8LXXOB2rM2ktHe6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FdhFq9rhzcdv2H28BIlUf5Uz6Kn9rZec/+Cswp8jm4=;
 b=QAWfOsOYIKGDa32Eaxu+M9lYF9ZgOjRGOeTfAGBjn7g7kYEckN/EG+mspNX7ZJRp82OuxDmZzM7/TPv/U4fYBhF+PC838WiCfHjTyvMG45WqevPEv8iXDfPIJlZ+U3OaeH470Fj494ujtrmjHfZLx309XKpDx0eRH41l2oJXqhbY6T9S60mRKlv7NTKxdjlrvXqZNpMod6MiLr/a+etgCXPmAJByb/2A2cuIEJY5sdxI0ccKhYYGrueViTi4m4YmORHLYSXtRaLX1Ih+YANvOIdEkGbXInN/GV3vPcjraogt3QM7VCqjyOMF7+kn5+0QOSY+SFxxHC2ArtkMiPa0BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.31; Mon, 8 May 2023 15:32:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 15:32:45 +0000
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v4 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Topic: [PATCH v4 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Thread-Index: AQHZeE8RQrH/pDzhz0i6DTTjBkclyq8/ljeAgAADNYCAEPoZcA==
Date:   Mon, 8 May 2023 15:32:44 +0000
Message-ID: <DS0PR11MB75295210DA7C4C2896D1FB6DC3719@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
        <20230426145419.450922-9-yi.l.liu@intel.com>
        <20230427140405.2afe27d4.alex.williamson@redhat.com>
 <20230427141533.7d8861ed.alex.williamson@redhat.com>
In-Reply-To: <20230427141533.7d8861ed.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7904:EE_
x-ms-office365-filtering-correlation-id: 9917198c-6da7-4955-a884-08db4fd9786b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: voT0BCrMgdrvYh4ipsh9as6ugUagfMhz9sdoYiYkKTAZAZ/4DRwue/3NdDjbk8pyjCok3Qox0qZ3Cj5lEZ39Gxl3zX8a3QV41otkyxuZ9OJ7MDiBJ7WXM3yIqA9fn4neBX8Ne6ch8Fjr3nZ9UhocTSbAqYjoLNhQi7IH8vUiELUWRJQ3xywN/oP4CWzSnGsNPPstCGATzSX39ZnEejv6iF64c53XyBy1kKk0FzVgMnpGOO8EDiy2vexy9U3pKIHkVb8kwJqrTiFQX81D6ZRlj0vxrDgy6t3anxA1ARQw19o18oXGMx6awvv0unA9o9cnahsBxi8Q/49q7Eko6rVcj1O5mp488y+7YBLiJ7meFOcnAms2DTGb5w2yDG1ElR6bR884lsSNaUGBDN3iXmYgZh4PlnP2eAcs3RgliIbuesbrVh9oiFQzZ90U+YgDF9ljjJukM2Lng0/jbJOlr/Yws7hlKmyV0UlbTerSnz28anIkA9RRxIAY8alxbDOaDW8hSbLW+sbB14AEnUAj6LWtALqku1Rb5wYhm9Ifum7onIJoPzX1qW5OSL7SShIqq3YwaeiMdq/HoQ9CIoBD7BCaUpum5LoHIUeuMBfZivAUGaSS/jmnrn6DT1QBjqqBBYLt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199021)(86362001)(33656002)(316002)(54906003)(6916009)(4326008)(76116006)(64756008)(66476007)(66556008)(66446008)(66946007)(7696005)(478600001)(55016003)(8676002)(52536014)(41300700001)(5660300002)(7416002)(2906002)(4744005)(8936002)(71200400001)(38070700005)(38100700002)(82960400001)(122000001)(186003)(6506007)(9686003)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Lyb2gIpWyQLqADXjS5qnFqHUzpqHkcx9u4TMqV8CDwG81GPP4+6k4w38GUB5?=
 =?us-ascii?Q?WvfKHkgIUsnpImqJ2aqwEo/aVrr4qtqm3XtOgVcBOGyKB6PnSnNF2xNSH3gq?=
 =?us-ascii?Q?6KD3BLt+ErJFwykGZP3yvnEOmFhePZVvQNtEqgsrKYAGYm59Xk44I+TNQiNF?=
 =?us-ascii?Q?4YMKElvkhucIVzjRIOAqSBKeNVt04i9lzxJPlLIPVZE4YU9ZsSjNsTrmveMq?=
 =?us-ascii?Q?1kru3MZ/wlg5EP0A+T3uIoSivJHYkuRwdoAgnpocFnCLk80AfqvE8nV3NuMc?=
 =?us-ascii?Q?h6W8m537Ds/37QXAlguOc0j6E2qSOpeziSLuTNbeuBve+f7JfDtbg0opp4PW?=
 =?us-ascii?Q?aZYvdK9TeDtVQnTiSBi0tE9wEpxJE1MaKOefVgpAGNDycStHY/JtVQbwJh43?=
 =?us-ascii?Q?o+POZVeYVxRYf4a6U8QjlcyxyUohQv7nncBOthWdro5MoAfE8jwD0xMkXqTH?=
 =?us-ascii?Q?zjBr/qu8GkjTRiXASJeHPLwDEDrWdiuBe9tLgW3kfBWtMKpIlwG0VL2GbUp4?=
 =?us-ascii?Q?Dwhlp5GQKGqkDSE7PpkdG3MC5p3raIOKRY0mbvlnAlWnIv5Kl+Y4NXU1PA9d?=
 =?us-ascii?Q?o/W+QdCOQgsECGZJ0gwu/VntHngCznZVceQvrlKtnKWgWZmIc311u9KPIYhT?=
 =?us-ascii?Q?Ng5Y5uGrd16LbmwzfRxEfgbVf+sENNyDGP9Tfy5o0e/Bblio0hDHpVh0oYfj?=
 =?us-ascii?Q?MTRlvUIv9sWivKYMmUt6tj6/79xRmanDPKpFySLMrXfyGgZy4WqqYX7t3oup?=
 =?us-ascii?Q?lf8jeSycglWzdpwAnbKuabUWwwXD6h667rzrxSUbJFtheNiuS/PSseKMMT65?=
 =?us-ascii?Q?QE43F7BhKdt/gHni/zTZoXEa3A+9zyEW/yuFcVNemfIl+NY9rp1m3NfA7vGa?=
 =?us-ascii?Q?hked2qJ4PWhUd8QFug1PWemlT22MKkWZ8JVcuoMIEREsA2SxRG0M6zjzN6AS?=
 =?us-ascii?Q?KojXqMF8Wq3jRkS3WhJN3zqGc11gmjTi5o6IST5BRTkZDkSkIGHpPlICgi0O?=
 =?us-ascii?Q?T774JJ+esm4JcS3tIfgNGNF04R9HbkBeOSR+Rt74zHjWEwnluws+IyMMbVmf?=
 =?us-ascii?Q?tzAbN9SZCtre10hszzffRhYiWisbmYN/DrQVx8aM/dPZv+0Cjrzdw5xgpUcB?=
 =?us-ascii?Q?CJ3mI6qK1LlTnSRF+4fL/EOy3C1FlxyTt9gE5LlHtcIsi8qXfChtMzUVHcV/?=
 =?us-ascii?Q?OH+UZVw2AuD3LQ3fzpihidE4nziNrRg6ievBsRGhCVqXJlTSiDvM5w151tmc?=
 =?us-ascii?Q?VI2jNduhHiTakFKuPIEk/sKvX4kDMUK0w23RyYXUuLE+2krmfPg/eT9Ickd8?=
 =?us-ascii?Q?ysd4SD5LqMKN1P9NFKWV4/O3NuAol3fpmfZO3e/m+b11F8As9EmHK0U8Chqw?=
 =?us-ascii?Q?X6xJ2hCIZ3DJoTbUviyX6yFMKNqDZkgBz0+ZyLWsq2rp0u6BmegKnQJ/fCDY?=
 =?us-ascii?Q?i2CmYTIMjK3BM1aAu0T9dX5OTv1jniSSA/gzmpnVNOXugDtEAF+caf7MgRXJ?=
 =?us-ascii?Q?FMY0S0+F8PXux3s6XDjV6PFbND5HM/vZRxR65Xqi94NywYVjzGXyMjOLNo6m?=
 =?us-ascii?Q?hfGsnYmiPVr/7bdqdwnINje4unc80YeluoCcxMb2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9917198c-6da7-4955-a884-08db4fd9786b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 15:32:44.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIm8RCU4H4zzReG590zfQgLgGbMYj4pHRblaxSvsazgMyKndBkG+yQVv2B1ThLeS3W9uaJC5uwbv0IQ6RI2mxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7904
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 28, 2023 4:16 AM
>
> > > + *
> > >   * Return: 0 on success, -errno on failure:
> > >   *	-enospc =3D insufficient buffer, -enodev =3D unsupported for devi=
ce.
> > >   */
> > >  struct vfio_pci_dependent_device {
> > > -	__u32	group_id;
> > > +	union {
> > > +		__u32   group_id;
> > > +		__u32	dev_id;
> > > +#define VFIO_PCI_DEVID_NONBLOCKING	0
> > > +#define VFIO_PCI_DEVID_BLOCKING	-1
> >
> > The above description seems like it's leaning towards OWNED rather than
> > BLOCKING.
>=20
> Also these should be defined relative to something defined in IOMMUFD
> rather than inventing values here.  We can't have the valid devid
> number space owned by IOMMUFD conflict with these definitions.  Thanks,

Jason has proposed to reserve all negative IDs and 0 in iommufd. In that ca=
se,
can vfio define the numbers now?

Regards,
Yi Liu
