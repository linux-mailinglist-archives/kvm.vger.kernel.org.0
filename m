Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE26BB025
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 13:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjCOMP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 08:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbjCOMPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 08:15:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7865E7F01D;
        Wed, 15 Mar 2023 05:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678882550; x=1710418550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=veyKwZ/GZzVPRcrEl5TrVtzSO4kOKrmLKG205ZtBC5c=;
  b=L1Oanm2AC4Sj+Sl6bohR/T4hAmsxMzZyDKCtv7wHTxQVzAMHnMRjAkMy
   U+9VDR/G0jgWKEnuVCztmeQNguGQvwWTi2QYX4YnuZYGUUUJwKlO8M+4M
   4c5Q8D7SCkPg8VLhwoNo8ZglIuEgYjiDdrZsFopMDdXoYJrD10ziXIzAK
   bS1qu3Vh3H0X5E7nd2QGdlY2qHWMtzVDpQlvfSuWTkhnU1C7O4fVgX1cw
   6pk7Rt7wqPeRSmeF12fxgiNW68+QAZd2Xs1KfX6Bnk2z6DkiO0w86Dm8Y
   VFhQ1zvsxnBc7551jzJJ3Q/MhOrnvOqGheKWQxOvTLYqBjt8FO8Ui2s7I
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="326042949"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326042949"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 05:15:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672715663"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672715663"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2023 05:15:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:15:49 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 05:15:49 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 05:15:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 05:15:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmQrEtyVMh0V2Snao7dB8t10fFnJg71Qd+Oz8lKrs+Bib/ryxxutn0c8pTn2oFxzn8wCiekXe6iK1lbNctmU+ZIRYxeb1LJX1TKzWlNuXtDN3JcWYbSvBk9pRY9XguoJl6pKE2KZ7nOGggJRDC6I/kGyv+J/GoY/GzikDze5ZJ7JZFfZ9ersfiGI7rq1X9VRogSUdxqC/gRWrSoaQd8iAqiITVryt4KTFYfQbuOIguPnbnzWosB/w4tQaEN8jnTmjLnoS294LeRedajpp8OJ5afAoNb2dD68WCT7atiicroCNR4Wl7YCb9rn0t8dFM6I93x8bJl3q4w6kCScTVqWZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0DfJw2hf+tXtsi38czftAgnLLQbDt9YGKVo00lDn/YM=;
 b=D4XWhA29y+eQC95KN84RtntAhidfVoyAQ0lH/SKbaNme71KYm018MCr981oAPwy1fqSkAOeWzm0vm4vnrhuuLRexB+nRwPQnUzb8sGZgGL7yoLPVqOehqHuzGRk/d0ivV6GxUgrYFvJicB4/YMpT5g2AKXg6p0jls/UbdfOWMaVL94jvJvBdXmPoSCbt7n5XYH38zvKG2g/sQvjtLr3/EvizxOsVUL6wqscMwMdjvqwByWD8dmEORbGgNOYBsT8ofRg5PmPk51fpQ3zcvyl7uL4OXO5igW02rna7pvHx7AevGhgli7tb0pKiH42RUqUN+PlpFNkW4pJ+1arRMzGarg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7401.namprd11.prod.outlook.com (2603:10b6:208:433::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 12:15:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 12:15:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Topic: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Index: AQHZUb/ZXIdaaei2nkeVnEly49jVo670SymAgAd/HDA=
Date:   Wed, 15 Mar 2023 12:15:46 +0000
Message-ID: <DS0PR11MB75292F64622E825CF39D15B8C3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com> <ZAtrbaWqtngJkuKQ@nvidia.com>
In-Reply-To: <ZAtrbaWqtngJkuKQ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA0PR11MB7401:EE_
x-ms-office365-filtering-correlation-id: 6cd550f4-493d-4443-05b0-08db254f01b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PICqpo12fM+urjI/QKVil5/RosfunLLV0ZhesNtTQvNz3bmPwh144EyxOsPtdgjPwji536EHPKZPmH3KJNqq4b+GQmYkE8LhVT6kqA2wlOnpU4IOUJUN68M71qedKxrbC0Sw87aMmDzpAVJUJcgUMmDkt6qiKiYdWEZF+TYdQLhk/KJkHEpF0kw7BPL4mdqAjU2RrRj8n0WfFefgM/pvcTX95LZItManMZAtH8iEiv+Hj5+trPhNBEaRp07nw4R9jDq7PzAuFqzdqTDm1xdxhgpVhvH4jPU35U0yA+BFCQFuWhWLbZtJcFzcQxprd/J7TgSCFaA3Xr+kd5aNPtaZyrDg0tl/NZNGThKCg7F+rBt7JHq1lC9QOyC44Ua6l/kLa+S4ZQCaUw7JGQqLib/lP00rPiCXOG7GevSZkruIVGvNeTDNvl5xiffD8Ev4KOp2bQhy+e48Cz2ZVyRGzIOjiNxyxxk1EZG4MKxzHJQr0MH9Ukiklviv+Nxh/iKrJZC6IdFzEQDw7i6POvWVWuoaaKFlniMtNEY3pKqptEm3asznMdmP5ZbyNcqwn1LHbQ8VgJiTPGOtDYeWYa8Jha4+2cy/JSvQSlJCzn38YafPcO/mvcoWMyxP2WwZ8LAB+iUGyyz2RdDwwysxwYny92KFP5nVGx95V0UNUAVG3CgJY0ZTtVD8ft21pYAcW5hMbSuebcrZGnPt2IUSReWJ2lV9O7h33Lf0km2E3r65PMWmHlA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199018)(71200400001)(33656002)(122000001)(6506007)(26005)(966005)(9686003)(76116006)(82960400001)(7696005)(66946007)(66476007)(66446008)(64756008)(478600001)(66556008)(4326008)(8676002)(55016003)(110136005)(316002)(5660300002)(86362001)(83380400001)(54906003)(38100700002)(2906002)(186003)(52536014)(7416002)(8936002)(41300700001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2lH5SSVZwq4yx07nbjQWkpoJ8LZ5AhrXs/1+yf721Np1+vEpXm5rRkC19vFR?=
 =?us-ascii?Q?hPsJwGta6KsnHBhS3HWpIAYko2jBZFy+heE9ZVK4Jy9DvRP/EHCmaQMsroXu?=
 =?us-ascii?Q?xML/o/TGA86cHscc/qMTqDsrSuGmhSlGvQvf7Fslz3/hhlbMq9clFDMj/IUd?=
 =?us-ascii?Q?hPqYd8I1IJtT9nAhWNsgllsz2ydsqJ0lKj8d29RwF8O8L74cCVTqFA79XuIn?=
 =?us-ascii?Q?ZTzRGf/X1M2MmEE2pfCmqtABjJ9ii45NAmtOqHiKx9IgJAdjr8sGcWcdKGyz?=
 =?us-ascii?Q?TbHDR0yObQyNwutyBl9Bg/saovNRlwgSRVjL9vwtL/GO88PveOscHgQA8Lfl?=
 =?us-ascii?Q?bA0btLjC9Q3KmF5L7HpKw2B8MbH9o7+XGmc82m3opx5trRUO9UwyrE2d2csC?=
 =?us-ascii?Q?OGiwR86pOLBC/JjYMLOBKTNcXj3czui77i4VpuyqyIKk+WIKh7F6nI65gUI1?=
 =?us-ascii?Q?1dxSqxcbxviKl/YIdV2ExMaXH+79rNKIj8CiB0/7gZOwlMDwvAjeigMKtSId?=
 =?us-ascii?Q?VmWvS251713CjzBiIOQH9YlZyR7fjA98ieR/DLtEbMNKSz0DTWUjSzjIjmza?=
 =?us-ascii?Q?3blF59HyO16v+cyIgPNssLKUq9nEu6xTT9k7i0zwz4dTwC568NYp7GFD8FAq?=
 =?us-ascii?Q?NtmRCfu2TD63RofymLoQkZaa+XBXkRG+TCSX/+O3/vnn6DJP189LqkYiKfSb?=
 =?us-ascii?Q?A/cPbbWjHIg0Z3EFOHvr4uHPBrrXxTO7tbXPrYxpNy3exjisKG6X2r/kbZOA?=
 =?us-ascii?Q?wrlWIgoEuffR7HFjFofS8o7oVKQkbIjc/Vt9G6Kek0dbsRK9zWhTc1WLbEJs?=
 =?us-ascii?Q?KA7b9UnD35GU16s5g9i+moKxXMMmsEGzBhPFXayoQBkndVXlCC6Zj0d8NXkM?=
 =?us-ascii?Q?lq1dCeDbnhZy0EU9S4R26j0FudoVVnaRxV0BlfmpCeS0mnlGUo/YSlqQKwO+?=
 =?us-ascii?Q?qf7XxcYvw6rcAujIRzvdvQvlvj02sQi6+oJUaB2ECovhNLLnxo3QwJL3IOeA?=
 =?us-ascii?Q?oXv2x5ECD6FDv/GZCxuZrYfXiTnG8O6+j6kpNwWektV6oJxnyx8UgaE/QUb7?=
 =?us-ascii?Q?FrqNE6dAqsWRCDodW55QZaixeVpDzZ639idQ75T4WmOoibBwmnhMHHZxwwu9?=
 =?us-ascii?Q?JHc7OdXKWul3CaGrCjG6a75nyJgXCI1J3JRBh4I4rWQZJ42xcvJgLxra8E2Y?=
 =?us-ascii?Q?sIYg4En0oz9ciwc6dIXh9/aCXcgkyCoGeD+PkdBOtMDDq1XmojS72kkR40BC?=
 =?us-ascii?Q?uk0Ch1dGDJ8FYgXvCSaH2YMzlkYnh1E8FLyofaNgwTxg+bSez8ZTJJLMpB8Z?=
 =?us-ascii?Q?dQn5JMxzRFaIN3Dggc1kTuKxso2vgB1/4M/Ju+7G4lNKm9Mt1Tsd5VUHFTBx?=
 =?us-ascii?Q?tzH9Xqix7Wc2eYzboL03oU4G7r19gWpa5pPGnmFtZABoVl9W5PPBu1j+fG6c?=
 =?us-ascii?Q?7coaztmgkXJjoS3+rAirJw5o1DQ073TY0xee4JNTpVqbZpIKir9+uIJ4BBm6?=
 =?us-ascii?Q?l/bejb0hjxv3TYSW/fPs5CoFdIZoul+9cypnVbStbr/1NN/t04OJGNL9qCAv?=
 =?us-ascii?Q?bTNcz7SJpUfFlWXJqnrfxrG65zmoPg7HavYtLuGN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd550f4-493d-4443-05b0-08db254f01b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 12:15:46.3766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pN7WRfmx7S1/gu3qMRwNoCIGNjfG3Hh3LykwkrPPcBDqOSNsXBfJgRSKgrLv4x2dSBIvbOEU46xdzYel10K0Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7401
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 11, 2023 1:40 AM
>=20
> On Wed, Mar 08, 2023 at 05:13:40AM -0800, Yi Liu wrote:
> > After making the no-DMA drivers (samples/vfio-mdev) providing
> iommufd
> > callbacks, __vfio_register_dev() should check the presence of the
> iommufd
> > callbacks if CONFIG_IOMMUFD is enabled.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_main.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Alex, when you take this can it please go on a branch that will also
> have the cdev series?

Hi Alex,

I've got a cdev v7 candidate in below branch. It has three sub-series per
the suggestion in prior cdev review.

 - cover-letter: Add vfio_device cdev for iommufd support
 - cover-letter: Introduce new methods for verifying ownership in vfio PCI =
hot reset
 - cover-letter: vfio: Make emulated devices prepared for vfio device cdev

https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev_v7_candidate

However, there is one open on Nicolin's patch in below link. So I need
to wait for it before sending v7.

https://lore.kernel.org/kvm/ZBGJzefTm4p%2FReIu@Asurada-Nvidia/

Regards,
Yi Liu
