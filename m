Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 234A66DAFD6
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbjDGPrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 11:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjDGPrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 11:47:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C360A6EB8;
        Fri,  7 Apr 2023 08:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680882434; x=1712418434;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iJHCsfe5uj9eIZfvuG3cvmhcFV1jw0kiDy352aiJC5I=;
  b=jAI4zfjI8OGbPH/9vI6dAlOtRC4QZEzderUhM+GRaida2C6UeEXfOIjJ
   WGldJdndh0MUt9B3LOPRkThqu6e/6AyKgEgwOdjSl4l03eJkOi/76pQrz
   ktXzMYwHu89rXZD4YCswsIRIdwPSmCkOf8PIghtxSsITUb+Es3OvNu+gv
   HkOl2lRn91qGurz2asiJygsUONIxXT1w4HO90kWLnzWOFV2hpX/v56TBF
   F2MMDRj7AvfNKXL5+UDNCMbpFl8kVo9Xy8282sDZn8v8d3ZiS+uBBd9mZ
   vssIaJiZ5npPqz3OGaKiGXAYZEj6Swu6xixTwKkv8gv5iD1/zFTT4HpgX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="429296117"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="429296117"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 08:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="776872207"
X-IronPort-AV: E=Sophos;i="5.98,327,1673942400"; 
   d="scan'208";a="776872207"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2023 08:47:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 08:47:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 08:47:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 08:47:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 08:47:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBNrAguLe6WHcbbzrjjdCSdEY+TycSPKaftncEWaUFiQhtypWIu3/WAIX065AgKAQjuUKfP+Ge3IFSw8Tm4OqCRm2ruc3O52tLBisrM77XKaFY21gtFHx5EBCofSROB+ZYmx7FabGPIiCD9R7M7ODz+cZGCbwwy/d5ugKPMvxWDmlhh0LxIE3WKko4m2gU0xNSxs/Hot/kc6zrTNO7cHF3FdtxCa3mK+LU0cmVS5OySI2fCFBvSj41ttW1XAS/9rVMNMGLm4jJ7ruwzRfbespz0cGDABYv6/rBwfGHr283ity2SS7wyhmT2YvOnPfRqKCpOZHabqALfxl4Ap6egtCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbMsXRE5X5G4qUfnhls3UILX8PuAOI14NVWCe5wG5gg=;
 b=bfglFfGc49ao0M21OydroQ3qaxQ8xKdf4KMCRL0AO/CfTi5meFjBIQw2N4v/kRbn8oH+OgCJhI9iDY9udZE89WIxDmGcRIR3U4PVgJXQTBWNQqOy22VPV/mItXPAIgZa0qHU13JqRU7iQGW/vAS2lnfcAdGde6z+TLpg86oaxB6orAgaQ0+Ro2RTYsumujCXVjGN/Vw/R4omYfSfdYFCAVJCWEddHzCjGG2DNILH5vEHwqkX+Uu6eLO1fvL4GZp0UlSWuQXuDhG8wRJw42qGWnV8LIPZ6bg4sm7Xnj5Rff5Tr5+jUcYMWdjeIa/0ceSHnTEnQhh4goDD93LjMip4sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4810.namprd11.prod.outlook.com (2603:10b6:806:116::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Fri, 7 Apr
 2023 15:47:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 15:47:11 +0000
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8ZTcVQgABjWoCABfZ/IIAAIQaAgAAVGHCAAAktgIAAAk+wgAAUoYCAAAeeMA==
Date:   Fri, 7 Apr 2023 15:47:10 +0000
Message-ID: <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407091401.1c847419.alex.williamson@redhat.com>
In-Reply-To: <20230407091401.1c847419.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB4810:EE_
x-ms-office365-filtering-correlation-id: db1af8d6-81c1-484f-219f-08db377f5998
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sSYuMzYsLoupirb2SwLjbG4Q0NXMMJMgoOe6PyHlrB9yiJJE5AZkE/mvGIOIBG5oNsHOlH3DeELrNroQx2PGH7Kf6Mwwyg2+CkuDCLBbwnsApGwne8sSfGShjaFiv2q4iQzQdNRM2P83fARzEdbqK65E3AMi2skEauxSPFXq25yQRv+0eb8j1gKz3KNKSTNgP2DjytSfN6ncU+jSMzqqxCLnXsDvW790fhnIRRvLnfORPIpHBOZQNgsi8yvN74qrTKKflZtKQr1kDbg7NjrmqGXrDBPCLNPHhsrQ101POJQgVBdQAfFVzkRkFVC3CKK0nGR2dRJamPQiF+xHtGDA4yZERszYj66U/4KtIpPvO0sIEkKZbcw4j0WULHnpUW58F+/kHJIHJe099w7Bhn1SRAc7WYDLYc1CagyzGKRdrEIdrqiXmaey4X7PLiZHhHR/Jqn6hUJ61hSRNLYKI5N6mQ3cM3VarqDwUTPEEpAU+qtUDSXL86JnGY1PTJKXorExSNOKXciyHweR591lNQLeHtaO5bvmiGDjiNJRZLR0FsA8GOcst3fym//LL3f/LcYCgf9eiRAeDDoL0UsN25EckDjlYEPdQI1C+IJLpHuRmp4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199021)(86362001)(33656002)(316002)(76116006)(41300700001)(66446008)(64756008)(8676002)(66476007)(66556008)(6916009)(4326008)(966005)(66946007)(7696005)(71200400001)(54906003)(478600001)(55016003)(5660300002)(8936002)(52536014)(2906002)(7416002)(38070700005)(82960400001)(38100700002)(122000001)(186003)(6506007)(9686003)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Diu51Y3qUhcon3Nwbs/4V14Zj1svZtVQdZC7JW0KH/SeyZfDPK+JdDARvIud?=
 =?us-ascii?Q?h4ghVHRq02m5HCV7fey0bwm2xJfq/WJ81QXaYBs7UMdxijhEIj8qp/OnHWG2?=
 =?us-ascii?Q?NW6K3wxY4oGpMInx9NmWo1SaI5WhT4rxQLHJM/rrvt5aG5AqtJiBHsIgjTGU?=
 =?us-ascii?Q?yZDMS+HvKxUIkt1R2e+S4+TYdXkp9HCM1F7M8DpVMphoDWKB22Vwi1ih9rbR?=
 =?us-ascii?Q?ik0NvhzsRA+C3Ci80fNPNyWOKoJaxGqobtRcZizetG3D3ZXzom4eA4udwgjY?=
 =?us-ascii?Q?t/6wgXJ1cZ+lUZ1MDTCcqM5GkM+KGurJjY5WaBn+jU5HNdPER1CrLBbrzjCB?=
 =?us-ascii?Q?MK0OCRx+BPzTZ6sVu22gJO0+CMdy18vD0YQv45+0bz0nHm26ZcoDkSDmlWg8?=
 =?us-ascii?Q?u1ueMwVukw+XIr/yzuoO/t/ElGx/7YnvBNg0DV7hwG3gN9lbFK/SR4PTA09k?=
 =?us-ascii?Q?XNnIAMeVe0SiApj6XCEy+qVPbTQCbUv7moo6HJfHJBDQb4oRwmzxvpZWotM5?=
 =?us-ascii?Q?HM2m6IHYFSzolBr0SfcZPctL3k+3Cax5UNJJNLnSzn7OYKswl+Nnjdejfabb?=
 =?us-ascii?Q?96yhZFjZt6nV38wV+qfu5miIBxK8o7geOnRJDieFOndYcnWx0J6hFJs6qwkL?=
 =?us-ascii?Q?pexeL7zTUImzy6UVAqRoUNO0dU5TlN/HvGx7LiuYxfkyz0JrW7Bz+763HJDC?=
 =?us-ascii?Q?7HiCsKvbBG8UxouTGE7hmm6mOoufAXUVYy/UoCiRL1o/AoM9752GWVigO16m?=
 =?us-ascii?Q?1xNCu1+D9Eza1TJEwlT+C4ukt8ehVu3XorY993y3SZceauBQkOKDyyhZv8l6?=
 =?us-ascii?Q?W5ltE3cfr6Ktnz3b86YvI+J+Y0mhg77kA2zwqMBIFVKtjQKVjwt9drTH1qVh?=
 =?us-ascii?Q?Iu7r0FNMhBD/qnWXHIC16tJ9zWlMtXBj5Mie/eUffoRMVd+fmZxfVkX4TEBi?=
 =?us-ascii?Q?BdvSlaT/s5XzRg9kC2nCIy3fOfo3nd6jBdYh6suu0JlIUxV+1kyzTVtoO095?=
 =?us-ascii?Q?lfSGANcbf/+3YQU5Iq2KBxP/sF1+UKAln+Edl3wguwLYD89KbJ5b4kk7oh2B?=
 =?us-ascii?Q?oJ1lVlBxdis975S/MU6du7g/8yMfbvSTERvdUjJld5csJPvNE5OLZ1UgRZY/?=
 =?us-ascii?Q?1pVzeNTxLUZ7Qb//JAadpRLwAIWlpjaXGSR+NXZ71RsdQl6HP4jgX83aJXFU?=
 =?us-ascii?Q?3oL4OiVMx0iP5OFpf6H7MN7GFRlzi4Ie+NkxSlgQb3lC9KNcwD9Uf+bVwUzH?=
 =?us-ascii?Q?QlOHhe6YMIXCymX3xUdAAgcsIZ3XR9B6oKPVEoD4FPbmTz/7X2RPtriq3Rvh?=
 =?us-ascii?Q?ee/Se6HVFYz3NeNrvDVb3S4A/PuiR1UOIdUCw2rZDpB/OskNdWblzaXs7Ojp?=
 =?us-ascii?Q?ermrlZbr/orJdb3ltjEpLzuRG0FQQHtruIayaonKwvJD8ARMLcXn+BfRBBIQ?=
 =?us-ascii?Q?5jSqkgbvzQOdZrT0JivPKqL7Bj+3Nf8nkrmpKU5V3WbhcJkawSefYnmFFl/B?=
 =?us-ascii?Q?STcHuqLI3fC8IzGAlWgWy5kInyUR5pMBn8CAlqmveS1Ht2VTt7ka1hGXTA8d?=
 =?us-ascii?Q?0aCyBeioTZ0tVSwQri8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db1af8d6-81c1-484f-219f-08db377f5998
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 15:47:10.6032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ornXm4LhYMa8XGGBiNYo79UWjUvruqFAZy2PSCJHdM7gCTY3WcGPnzIIR/i3nvPuHGby0mVSaSaB2r78mTYiVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 7, 2023 11:14 PM
>=20
> On Fri, 7 Apr 2023 14:04:02 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Friday, April 7, 2023 9:52 PM
> > >
> > > On Fri, 7 Apr 2023 13:24:25 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Friday, April 7, 2023 8:04 PM
> > > > >
> > > > > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct=
 pci_dev
> *pdev,
> > > void
> > > > > > > *data)
> > > > > > > > >  	if (!iommu_group)
> > > > > > > > >  		return -EPERM; /* Cannot reset non-isolated devices */
> > > >
> > > > [1]
> > > >
> > > > > > > >
> > > > > > > > Hi Alex,
> > > > > > > >
> > > > > > > > Is disabling iommu a sane way to test vfio noiommu mode?
> > > > > > >
> > > > > > > Yes
> > > > > > >
> > > > > > > > I added intel_iommu=3Doff to disable intel iommu and bind a=
 device to vfio-
> pci.
> > > > > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noi=
ommu-vfio0.
> > > Bind
> > > > > > > > iommufd=3D=3D-1 can succeed, but failed to get hot reset in=
fo due to the
> above
> > > > > > > > group check. Reason is that this happens to have some affec=
ted devices,
> and
> > > > > > > > these devices have no valid iommu_group (because they are n=
ot bound to
> > > vfio-
> > > > > pci
> > > > > > > > hence nobody allocates noiommu group for them). So when hot=
 reset info
> > > loops
> > > > > > > > such devices, it failed with -EPERM. Is this expected?
> > > > > > >
> > > > > > > Hmm, I didn't recall that we put in such a limitation, but gi=
ven the
> > > > > > > minimally intrusive approach to no-iommu and the fact that we=
 never
> > > > > > > defined an invalid group ID to return to the user, it makes s=
ense that
> > > > > > > we just blocked the ioctl for no-iommu use.  I guess we can d=
o the same
> > > > > > > for no-iommu cdev.
> > > > > >
> > > > > > I just realize a further issue related to this limitation. Reme=
mber that we
> > > > > > may finally compile out the vfio group infrastructure in the fu=
ture. Say I
> > > > > > want to test noiommu, I may boot such a kernel with iommu disab=
led. I think
> > > > > > the _INFO ioctl would fail as there is no iommu_group. Does it =
mean we will
> > > > > > not support hot reset for noiommu in future if vfio group infra=
structure is
> > > > > > compiled out?
> > > > >
> > > > > We're talking about IOMMU groups, IOMMU groups are always present
> > > > > regardless of whether we expose a vfio group interface to userspa=
ce.
> > > > > Remember, we create IOMMU groups even in the no-iommu case.  Even=
 with
> > > > > pure cdev, there are underlying IOMMU groups that maintain the DM=
A
> > > > > ownership.
> > > >
> > > > hmmm. As [1], when iommu is disabled, there will be no iommu_group =
for a
> > > > given device unless it is registered to VFIO, which a fake group is=
 created.
> > > > That's why I hit the limitation [1]. When vfio_group is compiled ou=
t, then
> > > > even fake group goes away.
> > >
> > > In the vfio group case, [1] can be hit with no-iommu only when there
> > > are affected devices which are not bound to vfio.
> >
> > yes. because vfio would allocate fake group when device is registered t=
o
> > it.
> >
> > > Why are we not
> > > allocating an IOMMU group to no-iommu devices when vfio group is
> > > disabled?  Thanks,
> >
> > hmmm. when the vfio group code is configured out. The
> > vfio_device_set_group() just returns 0 after below patch is
> > applied and CONFIG_VFIO_GROUP=3Dn. So when there is no
> > vfio group, the fake group also goes away.
> >
> > https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com=
/
>=20
> Is this a fundamental issue or just a problem with the current
> implementation proposal?  It seems like the latter.  FWIW, I also don't
> see a taint happening in the cdev path for no-iommu use.  Thanks,

yes. the latter case. The reason I raised it here is to confirm the
policy on the new group/bdf capability in the DEVICE_GET_INFO. If
there is no iommu group, perhaps I only need to exclude the new
group/bdf capability from the cap chain of DEVICE_GET_INFO. is it?

Regards,
Yi Liu
