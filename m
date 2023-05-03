Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA056F557A
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 11:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjECJ6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 05:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjECJ6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 05:58:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDC51FCF;
        Wed,  3 May 2023 02:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683107879; x=1714643879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yT1IqnEN2KJ3zIVETKisEIVusxrGC5UD6yKm0XCd+r4=;
  b=gIs7o79ArnPTAJe/VpEIlySvZjpn6pn0t9f2DhWjli/yofR3KHXEFq1b
   T5SJ/TfFzxNfQVM+YbvgPWPVrwBwGqSbLpzw62fldXulsgNgrfuEMe3EB
   5uEUbT6xdxvOYdIHBZi/uWL13/WJ2jOVeq6eFIbGzIXOvd81cH5x3to1X
   NRgSZIDnEQE34sinI9PpfXu3q3Uh/J2V2FNzR3L7pKMtdeL8xV1TSTUy3
   eFQZUnfQ4vD2rCIu4Axsoih9fxYpPr0IuhaHfkRhAeXFp2hS6NrcISRwa
   c57NXLy+LhwGQ8hotJmPseonwExhTtLIKEb7EGoRepKmvys+Li4ChuvRW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="332978586"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="332978586"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 02:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="942787563"
X-IronPort-AV: E=Sophos;i="5.99,246,1677571200"; 
   d="scan'208";a="942787563"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 03 May 2023 02:57:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 02:57:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 02:57:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 02:57:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 02:57:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKsOgSdot4vk9jrFn0VmfiBMAWqyWOdCePesKVI+jF0/sn8ADjZoy6ZyoSXaQQtqfpXVfG5R3Ew1ll0sxC0q3axMmH+OVeuF4dfProXp/apc1H65hqDeRNz9YPSPU3VGx1ILdxx/mCy/4D1d1e6ANpYM0ypl9G+n+8Fpbg7dk0g73u32tROY3G21uwXNC6NmuiZ1HPWNu/tFgvTZGwOV2R8wrxQ3ou71VZKPGZJMqtc7g5cU74z/oPPW2XEvd0ij742iu9XcaecWqHQdCCfsihV03zDdKaM36moJFt2cUekA4Rse+OWGw8owc0+AyjqMLkiXQIe8Q/lMj+ypUvV/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OUzAvPA3cmhTusmmlCwBTexsPdN1zndask9WQ3Pnmtc=;
 b=iGk9bpqzShpOqlYJuOQ1TYUUkGmzVL+tfo5XaE5hEFxkhpGW19NBksWo46DrvyPSjeWoDA4LBLFDRBHca4vif6aW8XUQJ6aH+cfzxiO6s4XQCITNCbfMwBENxvlFcjvZD3nsnz1J8w+3N8ylMAPX0BXDKCGL94Xv7JBCaCHgOzzM8tNPwmg0jkEQywiosMk/HdzE/OMzlu/1zQ4ms/lSF2WCAcAyNN1/Loxq41n/s39NSEmjFWZSOUjVZe5u/2VQjsKVSfU2g2AcTncUm8YDVUQjKn20VZbH2udL8lBCzlQO/ZEynPvCP6rZ/3PPn1CiM73Qmcr3+ddR1cbuxlY0tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6941.namprd11.prod.outlook.com (2603:10b6:806:2bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 09:57:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 09:57:55 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Topic: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Thread-Index: AQHZeE8IlpbqU+0d80ea2xcAM3D0DK8+tVeAgAAAlECAAMaWgIABa6mAgAZtMgCAAQLm4A==
Date:   Wed, 3 May 2023 09:57:54 +0000
Message-ID: <DS0PR11MB7529B4E4513B1A56A90F111DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <c203f11f-4d9f-cf43-03ab-e41a858bdd92@intel.com>
 <ZFFUyhqID+LtUB/D@nvidia.com>
In-Reply-To: <ZFFUyhqID+LtUB/D@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB6941:EE_
x-ms-office365-filtering-correlation-id: 1f657ac9-56c4-41e9-a43b-08db4bbcddbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNt1VtgOA6FhPQc5hSg79NawALZhB6bp4kIURzy466JQa+v11TT7Ro3NALE3Rfw2xaqsIQIYy2cHfXBJZiv7+S7sCLY03awGFdEAjruov6dOZ5A+aPm7dGyS59xY+72j2mJNRzzwQs0nFKimfEeUD1jGoSLalSZ9R57fpn/t72igJxAzou5Wbqjby06BRSpz4zXppUGH18p9Zse8XCFaPJzt5piYmDnneUQeK+lGjyJM766fBMVdNpSex0XDK/sJ/gNA0oyauV7YeeT7HKtQnqHydexR3moXerV3hjZt575vBvSne5sqecQTFCTUHGCYfcLQEHuMhfAuuL7RCnnm/J1remWf9ce6P2H0NBvC6CxFhkjSUVLdrFqKo8fXO4gANoVxiEE+QpPz8syLllPzO2cCOFV46o+AyGwZvmS6X+GklGl4PGlGuATxwXWhASYwdjy+vMDcwGNFEX/pCKmyp6kMhdekTarPUYSZDhOCgvP+H2hgvf3Hy48bZ3L21BS7SdcuLJaD6TK7vgAp39OJE+OEtRD5cw5vr/axR5tOokisR4OXiXy0uORC1a4bDJzFYiiuKsGBGhZ0p94KDG5IEvkuQWIB1nqKcsxi6EgGKSoE7slXz5jUnTeBEMUCZ8bwRD7EBfaXBZJpNqnw2nxNMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199021)(41300700001)(316002)(64756008)(6916009)(66446008)(66476007)(4326008)(66556008)(82960400001)(76116006)(122000001)(66946007)(55016003)(2906002)(38070700005)(8676002)(7416002)(8936002)(52536014)(5660300002)(38100700002)(6506007)(9686003)(26005)(7696005)(186003)(71200400001)(966005)(83380400001)(33656002)(478600001)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qlx5cKnxXeUkzbCXwrB7u2a+yNUqcdJ8DUKJUrFeorC2SKbvoW5OAuLYpxst?=
 =?us-ascii?Q?JGuUNe2kfaGmgkXi734uwZTrsBgb9xHJds9GgUioCiuNk3MO0gvY9QtwA4QO?=
 =?us-ascii?Q?y+Z8i7o7l/1iJNA9/TGL4rNcOScrU2AZkCcz4rNtqZDO+pefQNEvaubQMKy9?=
 =?us-ascii?Q?Wbn1K+EasJvEU6KdXhW3gv9W/c0Nd9IGf7c7S7oGu/vnCTDusrnwPWCQHcRt?=
 =?us-ascii?Q?af1SZKCsxOR8kMLLQ6pY9m+CbPqoss22X9zaZOAvDc5uXjiZArDXyPGsmDBx?=
 =?us-ascii?Q?QLX5jHtQvx7q57PMrM+xQtj+VSiCUjqnFhOyBLItcXTuhtM1SSpWHKZD01sY?=
 =?us-ascii?Q?9Z+9UZOd+rik78a2MYSaIBdBXw4mglDB8zP4QRQu5nN5P19Wf4hxjvgmRSsn?=
 =?us-ascii?Q?kULr8zv6bU2I8j8+UFFfZIMSvhR80detGFvDjBePpp2qGyNonmZQ/iROe0Ea?=
 =?us-ascii?Q?YOf4j2NudFMekIS7WvD8sG9h+n9kvxUr3niANWZMC8BNcRCkQ2hwA8qAX8cW?=
 =?us-ascii?Q?/GjBeGC7dVVwZr94wwK9L/PXH1R3AylCtu2GVUAxZV48yIO+e4vcPPpc+r6Y?=
 =?us-ascii?Q?UYZMXPKu/AqYO0BH12Gkjlp37ZtBVu9rD876j+1eB8/5F1mbv4AP+9qrGmNf?=
 =?us-ascii?Q?edkUs6zTWijCAcubCyfyq70R9Qjhq1NimHavh5WDAlr9UA89s6KR1WW1PhpQ?=
 =?us-ascii?Q?jM9/r+7wpzsg2O65CoCvgiucxBIr/7qI/3QNt8QJabhW/YXGdets8h5+C5rB?=
 =?us-ascii?Q?c1ldfjkDG9kMXR7GJml5V7ejpVAQYf/yXj7C+lu7lu0W269G8bCUDPAmM/cZ?=
 =?us-ascii?Q?8gVTmQ5bFUVGbkVFgN5+avEleOcd2sceTcvwD/ywIZyhE0RLPeXFCbIngBIA?=
 =?us-ascii?Q?SGTcTnx4mM0/7WZW09NI0YttZbQFlHVTeIfv/Po3Ph03ZQAOmlU/8iqBi1MM?=
 =?us-ascii?Q?cVsUuy4dexBTSYparygmhVrRHNWu0HfENJAI2RpOOeBGW7EOfM1Tv/QXfjU5?=
 =?us-ascii?Q?lMLGpOx6R2JDUW71e/IRceiDMW7sFZNVWTKchphyLoh5DgYaSetIoX4DBzZJ?=
 =?us-ascii?Q?hkAlKbdguB6bFXLU7x5FD5VJNOIq1qMDse+IX0OWO6f6MYRoEylleAwNTA+3?=
 =?us-ascii?Q?yMRvKkbrNhTrMwC9jhshRbR9ql8l3wJUA2Lil1yJ9cdeM4jtex3uDJRi1qmp?=
 =?us-ascii?Q?G3PBPHvSaqjYvrulYBSEqN/LCeUDo14jMNMHnJYcC+LLU34nb5knb5g56XJZ?=
 =?us-ascii?Q?HC+itH5nDjcK2w7o6e3ZHf71Itl1FMZfqGObz5BXxKUazh/Ydyt3hjVAenY7?=
 =?us-ascii?Q?6MYN+p3oEfdBw2ZQAKDsN9OKVBFSUstBZDz0yevCcdoD+WpauiSgT5hOdKq9?=
 =?us-ascii?Q?h8G0+ndfuynNqFycfFhQIs9NGGM7leU3ek8Vp8B8nRi7BkpV308TscxBsGFk?=
 =?us-ascii?Q?v67UWoiV6+umelpvEm3RFUUvtbAO+juwZ9Hr6MHpYpxrXHcIfcByDeaQQF6g?=
 =?us-ascii?Q?b9weCu2Q2ICm0hLZwJ7Z6LbXruFEFFHsTp9Yn1SRz0bYCP2bk0fYyN7dQ0Sk?=
 =?us-ascii?Q?/FSTLRyEDKqZZGPt8BoKKaoHpEqzWZCT3ae+QfQ6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f657ac9-56c4-41e9-a43b-08db4bbcddbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 09:57:54.8611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9FnLgsKYLlkWev9iyOqiSywYXdp76PkxtLTYP4bbv6yt63kJ4jO/IgpG8VcbHFuU4iVoQLgk1W1c6gb1F8VV5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6941
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, May 3, 2023 2:22 AM
>=20
> On Sat, Apr 29, 2023 at 12:13:39AM +0800, Yi Liu wrote:
>=20
> > > Whoa, noiommu is inherently unsafe an only meant to expose the vfio
> > > device interface for userspace drivers that are going to do unsafe
> > > things regardless.  Enabling noiommu to work with mdev, pin pages, or
> > > anything else should not be on our agenda.  Userspaces relying on nio=
mmu
> > > get the minimum viable interface and must impose a minuscule
> > > incremental maintenance burden.  The only reason we're spending so mu=
ch
> > > effort on it here is to make iommufd noiommu support equivalent to
> > > group/container noiommu support.  We should stop at that.  Thanks,
> >
> > btw. I asked a question in [1] to check if we should allow attach/detac=
h
> > on noiommu devices. Jason has replied it. If in future noiommu userspac=
e
> > can pin page, then such userspace will need to attach/detach ioas. So I
> > made cdev series[2] to allow attach ioas on noiommu devices. Supporting
> > it from cdev day-1 may avoid probing if attach/detach is supported or
> > not for specific devices when adding pin page for noiommu userspace.
> >
> > But now, I think such a support will not in plan, is it? If so, will it
> > be better to disallow attach/detach on noiommu devices in patch [2]?
> >
> > [1] https://lore.kernel.org/kvm/ZEa+khH0tUFStRMW@nvidia.com/
> > [2] https://lore.kernel.org/kvm/20230426150321.454465-21-yi.l.liu@intel=
.com/
>
> If we block it then userspace has to act quite differently, I think we
> should keep it.

Maybe kernel can simply fail the attach/detach if it happens on noiommu
devices, and noiommu userspace should just know it would fail. @Alex,
how about your opinion?

> My general idea to complete the no-iommu feature is to add a new IOCTL
> to VFIO that is 'pin iova and return dma addr' that no-iommu userspace
> would call instead of trying to abuse mlock and /proc/ to do it. That
> ioctl would use the IOAS attached to the access just like a mdev would
> do, so it has a real IOVA, but it is not a mdev.

This new ioctl may be IOMMUFD ioctl since its input is the IOAS and
addr, nothing related to the device. Is it?

> unmap callback just does nothing, as Alex says it is all still totally
> unsafe.

Sure. That's also why I added a noiommu test to avoid calling
unmap callback although it seems not possible to have unmap
callback as mdev drivers would implement it.

>=20
> This just allows it use the mm a little more properly and safely (eg
> mlock() doesn't set things like page_maybe_dma_pinned(), proc doesn't
> reject things like DAX and it currently doesn't make an adjustment for
> the PCI offset stuff..) So it would make DPDK a little more robust,
> portable and make the whole VFIO no-iommu feature much easier to use.

Thanks for the explanation.

> To do that we need an iommufd access, an access ID and we need to link
> the current IOAS to the special access, like mdev, but in any mdev
> code paths.
>=20
> That creating the access ID solves the reset problem as well is a nice
> side effect and is the only part of this you should focus on for now..

Yes. I get this part. We only need access ID so far to fix the noiommu
gap in hot-reset.

Regards,
Yi Liu
=20
