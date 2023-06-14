Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B9372FFB7
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 15:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244942AbjFNNOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 09:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244917AbjFNNN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 09:13:59 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AC826AA;
        Wed, 14 Jun 2023 06:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686748418; x=1718284418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1+NpWkgTU5ZpI3XuqD4cf527XLFgWT3b58d+3IvvBds=;
  b=nfg9g/Law1J/sc8nG4LTgaV1gBrqg0MIQeor+RZjwWgUlJOTr3p4zRNn
   KqKXpljA1ve0R8zY4yrTH5LI/oqAinmro1C8wdumNh/uCVLlM8J8ydtZj
   PEcqL270RtyrRfY+2ksPpOC/xueFc/CfezO1BteSY+XWa4KVGt9hl12Gd
   pkGP7BZPgkn88VkQfBDOqU4cjBSMplDLDM4uzaZE/A0NNgwRPu8E5nUvg
   8GGjWs6gqwLL/v5sKibC2t6M4Kw7I3c6r3gDn1nNGUyOQqeY+BmH/0Ede
   SMa+pwKSeWyagjnI87hBf++c+aeEiXvYThwksDuCnUhS4D7n1SIL1RfgX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="348266933"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="348266933"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 06:13:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="662398783"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="662398783"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 14 Jun 2023 06:12:59 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 06:12:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 06:12:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 06:12:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 06:12:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lATMMREvO43UtCDy4/omEkqhOLUZQiWR//9Qco1xvd5RnfHZlqoQ4cM2hxZV/UkVZH6IuibdNVC5aEhDD2iwoGKrOnuTzAj0o3SOzgqicY6YiDgD2pMxEIBS1eANdaPjeMUdAJGCp+6wPAfcJayTTim30MtKQ485M2zRqxZoKhVuqJo4KkgK601wRxHt5OSj2lX3HGEJ+xGml8wHjo5BdYAz4OlPThpTP08rZGPbqVUWCayUcvf/rbaE/E4bfL6LbKQINsVElSa3LqLKdR7uvjZrtjZslzmZYUUUz+SeSc0lxyYe66LAQUigRRDwYT5I6whFdpIsH2AShj313Ry5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKXNL9yDpvW0lbXuw1i4S3YXeYV+X5Z9M0UiLqE0xJE=;
 b=PbiKJgspoGfHhGa8H64zhESdwcSjjwgBJKv/Tm+5K+8oi4taj32iHyQSM0C6/UalVD9eNUsFerDbJzi5ZPmqfVOM7i8Q6NEd3GLZNItizytlh0ZIsWFt8U0Ie8EeaGCCuJ9cVrCOAM+wFvObmsvP9DWw5jLqTV+4Ndo7vFq95Uh+J6yEASvG0AId+o5bPFteLWY64yWMQhmW6QnrYnj2lnhZLa0pJvRPCk4pKXu+kLWrxH/1hbveZO7RUGl5o6a+s1PwUmq8n6yGpn+nW2KrBVzMC1GEUxPfpEfKZRSnaj7ospvuzpRYoJsVFSO6Ru1ipNwAFMuK7JxzaA37UZUdGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB7062.namprd11.prod.outlook.com (2603:10b6:806:2b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 14 Jun
 2023 13:12:50 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 13:12:50 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Topic: [PATCH v12 21/24] vfio: Determine noiommu device in
 __vfio_register_dev()
Thread-Index: AQHZlUw5Bdx6t/Ptjk+i/O1PZ4IdNK+H07wAgAB3NRCAAI6EgIAAArTAgAAFeACAAABSUIAABoqAgAAiIoCAAAWUgIAAK4AAgABxqjCAAC4LgIAABP9AgAAFiwCAAGVuAIAADBWw
Date:   Wed, 14 Jun 2023 13:12:50 +0000
Message-ID: <DS0PR11MB7529918D45D6402639F9ED68C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230613084828.7af51055.alex.williamson@redhat.com>
 <DS0PR11MB7529E84BCB100DE620FD2468C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613091301.56986440.alex.williamson@redhat.com>
 <20230613111511.425bdeae.alex.williamson@redhat.com>
 <ZIiozfqet185iLIs@nvidia.com>
 <20230613141050.29e7a22b.alex.williamson@redhat.com>
 <DS0PR11MB7529F2D5EF95E9E1D63C9264C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52761B4E9C401A46FA5B4F2E8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529E50A3F122449AAE5733FC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FF400A7860DD23CF222B8C5AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZImxMHrOHHwbpNmd@nvidia.com>
In-Reply-To: <ZImxMHrOHHwbpNmd@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA1PR11MB7062:EE_
x-ms-office365-filtering-correlation-id: 964318ee-99c9-41bc-1743-08db6cd90e2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +yJaarYliRYmzOR8KgVH9eQPjIJLi4SaOpjOZaGiHOLmIpqDkgcFTUhP79aowXx7c5fLIQLuTlnpedUtkjWCzt/fboXZlmripuN27B6OcciNTsdt0Qu+hznF/BbsLOYk1HuIk52UGxGho3t9OHmn9UX1be8+JcBBoGxNYr/br89n0i1P3xVZj9Y1WVxHw2ysiWHkymShB4Ad+qNDbX+KUA96+nyqqZ/xEC/3pqdCh9fr4KM8Oya2ChNFrI7rIaCqOGjvrlv2h1K0ZtymDQhoAfKMJn5vrTwvpB41i1sndW27y0ZW6NzJeEWvfZULSJkkJkJ4MHIq9abeCW2NBf1p89d4BjYo44yJpkbkWYlU00ykLoQReMtcf+5TsUpuZkGBgKaNIu7tPWBQuI7jpQiQPW9R+JFwwP2WZyYV2+/Z8hZQx/4YGz4B3QHbVCvRX3ZKQEzF2x2jNHPNuJpnhlrVD2JPMpo4G9y72dv2gpLcH8OBTfZEfqgzVKJq/3bpvBMBC9g7Xu/aCNB2pRAVW3l5r2X9W2CGvw/sOop7Qj8ykCHVA51rjTYMmQnLiMviNXeGbGyKgYI29p08Mc9iqqK0pt/I/yU2WglYIDKA7vuInJ2gCsm1EhImRmM+WrrIbXAz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(7416002)(6506007)(8936002)(26005)(71200400001)(52536014)(5660300002)(53546011)(38100700002)(8676002)(186003)(6636002)(122000001)(4326008)(9686003)(66446008)(64756008)(66476007)(316002)(66946007)(76116006)(66899021)(2906002)(38070700005)(82960400001)(66556008)(54906003)(7696005)(33656002)(110136005)(478600001)(86362001)(55016003)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kuIGCkIbAa9JuTivqLdCQjaQBs1zyka0vIxczd5w+vELgoScaZmJIEibm9OM?=
 =?us-ascii?Q?J11BTentIRPJw0ADddbdjI3iRylqUmCY9pnQytzny2PqQBHsXq2I4vPgou19?=
 =?us-ascii?Q?Rsn/+d4cKoka9ySYU2Nase5fd1UCb6RO1UC9qq197yYqwVKOtuJS5vkhIx9Q?=
 =?us-ascii?Q?icXb4Ti/soKd6t7FxQW90CfYLSEPrIhml3Z059bIYfP0aeJYQHxbblZtUn9S?=
 =?us-ascii?Q?34AShSNOB2ek3cXxy4TH1AenVMj6GUcydT0V1sqBGy99Hv5DC6nS/d6NX4nO?=
 =?us-ascii?Q?NPzqhgRz54V6IbU+0sypU/mGsGEY7cf+X1y9QGWKN1JZX7NGEWU7uGPPdfwK?=
 =?us-ascii?Q?tSitIgNxb8ROnUCOf1/nP5wlRQMqshBgAfAK6KlumGm/NeMk08KDuzarIr2j?=
 =?us-ascii?Q?CmQZj4LMD4GSetqpxl8uGcSv7v1NJkHA+uOD8XylOpmckYkkBvtZM6lEw9/4?=
 =?us-ascii?Q?zBj/ie/cXK25exgDgVBkEN4AAlamjy4J8pL2O0LIU1/1oNFMay6uKDJdEPMr?=
 =?us-ascii?Q?5nj99zWiu4LLZzVJUA6h7GVqIwA5GEbwmS9uoM17TKzK/P1aaW95xEJxRlL3?=
 =?us-ascii?Q?cClS0KTzlw33SPEi8KpGE+HnI328bTEG8TNKxQhtpWwhulp+IuszrD0Vcntx?=
 =?us-ascii?Q?SW8yWrACpHCSyF2a9j+Ol+RY8Gu6VJyrmMh9MpOmSnuCKCVh/2TnPF0xtCGp?=
 =?us-ascii?Q?8AsQCeFbJqBZWAK867eIn4JkqtPkRXCB+ioGtri7gdalQBRrvYcKxGADjjKG?=
 =?us-ascii?Q?W/a5A1u0+Epb9zls2DixN13dyHFd2snMN39tKW+654ifgkTn5Uut6pcaE5/P?=
 =?us-ascii?Q?J/RRQvmHfZOEE/DVYhxDZ27ffJ36efD6gG8TO8oTXPvK/L3ZrQQMhP+mY+Vz?=
 =?us-ascii?Q?xbYOLxNVoxZeVUxS+o7e6x57H8BngCh3iKfy780dMSyNu1grwWw353X8RCDX?=
 =?us-ascii?Q?xViFlA1/y+5mK82G/ZE9tUJ/q5+jKBvK0WEDuk2rEoWrksWztzy3p3oTvLu5?=
 =?us-ascii?Q?xtpmbQSAlptKeej/4ec+Tkc1g3AEoslhnFFsxIxnvnbFU2MxCZLU1m/tFjRR?=
 =?us-ascii?Q?0UIULLqMzHCc1h27ha9BlR+vhSSpCmWmpR7VoX7tCEZlbZ5bDD6fTi8xH4mE?=
 =?us-ascii?Q?Nj4kGiPhLtXHU0Lyc/UkV4H8SDaVJQCAie89FOH8RpFNUbVuRcjjeC3Z0Q4A?=
 =?us-ascii?Q?MaIy3zo0jCR9X5RnfXRV9f2XZBnRySoj1QtWBpD4TOlQGk8hhG9O7WCJ10aX?=
 =?us-ascii?Q?2pv7l98z7hAR1QpOLC6yaDIoM20JlG6+Qhw6OpA07oamOkwKwids9DaEdVbp?=
 =?us-ascii?Q?n/Z3Qjuy/wcnJpNXkm8fu1GLdmNMihYlG989y7xIYclAtrehEFHR7mzExJYp?=
 =?us-ascii?Q?OiW8/nrfVrXDPtAlTN5xDYtxRmDX8N3Ck+JkiSiWEQB8W6ikUrSln0qmmEpL?=
 =?us-ascii?Q?NaYPQLLmQH6vX25x/DTOddm68+jiCBIWKYHqJkcbmg6nJ898toewyjKMj2iY?=
 =?us-ascii?Q?kfYBLM8RNteRN0PYMcBSiTVN7uiFVwNaw+lrAe/z4so+jMOvyUFvjR8p0iEY?=
 =?us-ascii?Q?14aQR1F9RHc8zE6/lFcI34RjIOtkkKuxl6oRAIno?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964318ee-99c9-41bc-1743-08db6cd90e2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 13:12:50.4006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WVb1D901+FakZBeg5OnEMp43DDHPekr9lTeTO0kXsf+VCOO4TEV6PHI4ecG4l6JVpE/mGYqbGrTHeG3BGBP1Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 14, 2023 8:23 PM
> On Wed, Jun 14, 2023 at 06:20:10AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, June 14, 2023 2:14 PM
> > >
> > >
> > > > With that I think Jason's suggestion is to lift that test into main=
.c:
> > > >
> > > > int vfio_register_group_dev(struct vfio_device *device)
> > > > {
> > > > 	/*
> > > > 	 * VFIO always sets IOMMU_CACHE because we offer no way for
> > > userspace to
> > > > 	 * restore cache coherency. It has to be checked here because it i=
s
> > > only
> > > > 	 * valid for cases where we are using iommu groups.
> > > > 	 */
> > > > 	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
> > > > 	    !device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY))
> > > > 		return ERR_PTR(-EINVAL);
> > >
> > > vfio_device_is_noiommu() needs to be called after vfio_device_set_gro=
up().
> > > Otherwise, it's always false. So still needs to call it in the
> > > __vfio_register_dev().
> >
> > yes
>=20
> Right, but it needs to be in vfio_main.c, not in the group.c - so
> another patch should be added to move it.

I've got a patch as below to move it.

From 306e71325d255eef34a1c44312bf9cdc8c302faa Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Wed, 14 Jun 2023 00:37:52 -0700
Subject: [PATCH] vfio: Move the IOMMU_CAP_CACHE_COHERENCY check in
 __vfio_register_dev()

The IOMMU_CAP_CACHE_COHERENCY check only applies to the physical devices
that are IOMMU-backed. This change prepares for compiling the vfio_group
infrastructure optionally as cdev does not support the physical devices
that are not IOMMU-backed. This check help to fail the device registration
for such devices if only vfio_group infrastructure is compiled out.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 10 ----------
 drivers/vfio/vfio_main.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 41a09a2df690..c2e0128323a7 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -687,16 +687,6 @@ static struct vfio_group *vfio_group_find_or_alloc(str=
uct device *dev)
 	if (!iommu_group)
 		return ERR_PTR(-EINVAL);
=20
-	/*
-	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
-	 * restore cache coherency. It has to be checked here because it is only
-	 * valid for cases where we are using iommu groups.
-	 */
-	if (!device_iommu_capable(dev, IOMMU_CAP_CACHE_COHERENCY)) {
-		iommu_group_put(iommu_group);
-		return ERR_PTR(-EINVAL);
-	}
-
 	mutex_lock(&vfio.group_lock);
 	group =3D vfio_group_find_from_iommu(iommu_group);
 	if (group) {
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 51c80eb32af6..ffb4585b7f0e 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -292,6 +292,17 @@ static int __vfio_register_dev(struct vfio_device *dev=
ice,
 	if (ret)
 		return ret;
=20
+	/*
+	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
+	 * restore cache coherency. It has to be checked here because it is only
+	 * valid for cases where we are using iommu groups.
+	 */
+	if (type =3D=3D VFIO_IOMMU && !vfio_device_is_noiommu(device) &&
+	    !device_iommu_capable(device->dev, IOMMU_CAP_CACHE_COHERENCY)) {
+		ret =3D -EINVAL;
+		goto err_out;
+	}
+
 	ret =3D vfio_device_add(device);
 	if (ret)
 		goto err_out;
--=20
2.34.1

> I prefer the idea that vfio_device_is_noiommu() works in all the
> kconfig scenarios rather than adding #ifdefs.

But the vfio_group would be empty when CONFIG_VFIO_GROUP is unset.
From what I got now, when CONFIG_VFIO_GROUP is unset, the stub
function always returns false.

#if IS_ENABLED(CONFIG_VFIO_GROUP)
struct vfio_group {
	...;
};

static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
{
        return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
               vdev->group->type =3D=3D VFIO_NO_IOMMU;
}
#else
struct vfio_group;

static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
{
        return false;
}
#endif

Regards,
Yi Liu

