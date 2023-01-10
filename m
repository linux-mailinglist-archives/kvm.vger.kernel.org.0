Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00EE66378B
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 03:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjAJCxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 21:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjAJCxt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 21:53:49 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0810841658
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 18:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673319228; x=1704855228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OiUSTPXGQ+1Wvn0eEeI62/EYwkfiEBAV+YekyxXz+PY=;
  b=lQkP1bUehN45a6PXegj5Verv1hWR059+U6wqMoU62JSR0++ZOotXkLw+
   k03/mwcP60ZlVbkwlBxdyPcaDG66Jn0k64s5o4UM8W0CJenxWtiNgXruz
   /8AJhe01OfqKdxtFbiA+DCCMENOj6XYxiiokZAAGXRXqslB3i7CrlIslB
   V853WnxWW84TpSRTUc/Y20XNcX79RYZt+shqFWlJRKFqk+B7M9loZn/9J
   lkGDpRat5TSggbCGNPwWS5kTN/QRAZM3exWLJDNke+J1ILb7XDQAZQsqz
   mnu6G1cU/QjywWyK5XY6uY70FtxknHoLWgcb8c5f8MELl1UgcTsUxQDbS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="325051477"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="325051477"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 18:53:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="606799016"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="606799016"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2023 18:53:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 18:53:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 18:53:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 18:53:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 18:53:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdtUVCgWRi9zPaj8k1ShU9/2/N7G0b8XCY4ZAnPUmtVuhkU8g565r9zZl21i09ZtwQI9Tk6h1a19LbhMK0oLwQkchPLtwunlMPsT69WIUMxkBXF4fNhgvLGEHsBW5T4673+TWoL7WrX42dK3SlR4XJaUQf04fuAqGA0TQYaa4Xh0NPSfGEZeyp5XSjPrRShPjpWyx3EYNu7asDjmoAvhCZPCDkl6hOOlUtf/KOiy5+8F6q/g1VMZyDoDuVKPPuyuzcodMw0A4sS8ShkFQeqhuWppStcsMGCkDMGAz7RSe5NhegP3lh6q5G7be1zL5WwnoXv+LRKPZ8pobDL+dKyMow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT6BgeDch5ZlBSXUhS67WXgmaW2b4STAscsiS83CNuU=;
 b=W8NpPG1SiyPkwpoyw+M4JkI28K9H3V1Vz3Ef2NNEbutrRq2QfIGMMX2DNwHt5alJK94NyVLah16YWHoRew/Iff3ReRo/36IKXConIeFhRfJ7jen1rZii2kj+V0kNOeqorWH4+Fy37VisRPlv9skOA/HSkpo1qvJgcQcoLl3gjYr/5HIWk0Ep7gExUy9rE8DDFtQFTxbbyoijsNxLhcXqiZhyB2r8vKnO00OTq4ExmSi5HgO6+kLA78lGXxMq8X6pEo9NhtDQOdnEvPmsPR3AhKunoXk6ZQUtCeTDQtOIx4NxVWVqGzay/9wZr/tUXgP4H/Nhsvzs1w0Ed2eWCs8/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7145.namprd11.prod.outlook.com (2603:10b6:510:1ec::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 02:53:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 02:53:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [RFC 08/12] vfio: Add infrastructure for bind_iommufd and attach
Thread-Topic: [RFC 08/12] vfio: Add infrastructure for bind_iommufd and attach
Thread-Index: AQHZE4aWtV3++O7lVUOmGXijTuyi6q53wxBAgB5wYICAAOHhcA==
Date:   Tue, 10 Jan 2023 02:53:43 +0000
Message-ID: <BN9PR11MB5276BE9F4B0613EE859317028CFF9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-9-yi.l.liu@intel.com>
 <BN9PR11MB52768928D8FF45129AF8D7CC8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y7wUyUbilYc67M8L@nvidia.com>
In-Reply-To: <Y7wUyUbilYc67M8L@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7145:EE_
x-ms-office365-filtering-correlation-id: 161f6c6a-a08b-4141-a9d2-08daf2b5e306
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GVxn/ctkDeMTLPhF4lPQAn5NbZQl4rItrrO0nMOvIFNCT0nVI+NyV23xalQExzEa8tV6f8NcLOZ4MvAJ+NMmarX6Ld/efebyLef7ModnnuriXyERLpU9N7/jffgDTyDvkYzaODOpWmb0j0DCWmoGID2qXI3Pp4WI5m4OJ3cA1GsAs02lb5E765RolzppM5mCQ20Wly/QjWFJok9RavpoenucvBGAPMkqlizBjlqwDatn5ufY4hnpzD5M6Kl7KG6GaiDAugF7yVLCEqTxhCufHeQQy8+bCKY2SqU6/XNOESeEB1EpTiIwAqUo1J4HLTy8DE5dpuf5JiRCwuWAV9Vc0IQhOXivL1pAV2IWGnHH12JDTIuf4XSsyiB68DuUyAuRzIaAPpB4u5NBaV/5snfvzMgMadcrvlc9WHz9Yd11bJvl72FWBVXiM/8v/hLZiozMs93pbwt5ldm8KEaqNLZBBBiwIPAz1P5IxKIz1yq7OorAJAEEyB0KrtxXgGl2i0Q+Jhb/es90DkOH7H4sjBK+zT7C/eg7SRclw8pP1Dx5+JB5/+VSirs5FNeGeJgkz5Rq0A3J9MpObkwTIuLJQgU2UlmC31XmYTTb92XR5USg1WUIxjXealX9l96+EnSs/YitZ2wIfkcwKxc+SgVRthKYNiUVI1LPr0nr+cJ3EwpW/vryiXQh2E8nenwP0fmUAh0PdpTI9LJEv2kZqpXyQDPRwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199015)(38100700002)(122000001)(86362001)(38070700005)(33656002)(82960400001)(4744005)(8936002)(5660300002)(4326008)(8676002)(66446008)(52536014)(2906002)(64756008)(66946007)(76116006)(66476007)(66556008)(7416002)(41300700001)(55016003)(6506007)(26005)(186003)(9686003)(54906003)(6916009)(478600001)(7696005)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XRxgnvVcEHMa8rCtmrHjJyNNxc/vP/j7ECXUrD4hdSYUk6MVesu9XH9fnfjh?=
 =?us-ascii?Q?+leFKcBUd+cjhITxCCNnas3CdyAkXEEnryUNKoOkEaya80IMurzekBqSkUpY?=
 =?us-ascii?Q?rrQ5w7GhbDYwe82Mnx4RS4CYo7zZWjZNEi52B5fvIWJ24zlZufl9/v54cmuJ?=
 =?us-ascii?Q?p7eI8YGMvlEYLSoVgbGM4XhkuQ6hCXCVbL2Eebc8gGARdhhwBuML9HHsrCj7?=
 =?us-ascii?Q?PvUsGGgcATxf4qWbbjK4OS/1T+XVosQux6zA28iNrn61QiVpGvcsko8M/pY7?=
 =?us-ascii?Q?S65nZ0f74uxgblkWa0t8fZSsGXTY3uzOJ58pfo2ddgfJ5oJyjAuGwo4WKQy6?=
 =?us-ascii?Q?25dALU6nSfnSIW+utS6s3QriVP3MWZbnxad9+wvMiFRgevhg8c/Yy7TbQ1Xt?=
 =?us-ascii?Q?Fm0gP3lg4kcNEKTAsX8tclGndvrBvLr4O8d75HX8MxLU3O4DzFx1v3JwGlAZ?=
 =?us-ascii?Q?2qxudXz1HJAjG4QrHc6YMJxnbmjACNk3xZdBAkhNIKaA2G/MfRJQOVgZ8weH?=
 =?us-ascii?Q?37+Xc3BCgA3OxwhtF82WdPlvyuiKGAkbHPMqavuI8kGoH5ogSqskhsHFEOXy?=
 =?us-ascii?Q?fw5umnMGo+k88J9zZguWX07VRZKOVC7X2lGNn1FHSF0fwY8/uDtrrfCfWrcD?=
 =?us-ascii?Q?+TCe/4fbtedzkp9rt2dor9LCbMN3zNvdvOzpEWsJpwNJjmDUYwaYvxkwndCA?=
 =?us-ascii?Q?CAOGol6bReqPWiu6fGr0GARjES+gKTE484f8o8yGvZChYsTdEYwQ8Rx1ktPl?=
 =?us-ascii?Q?rb5+Y5ou2XCgu4lgSL9u0YhE23Cnl9DHTV8Rvegd2r+KJWxLuQymN+uF9fBN?=
 =?us-ascii?Q?ou4bWF34c52LQKqi68mo/xjGInGc99RlYZB3I8TcRV7Zr10gTHo9GkBBKnsC?=
 =?us-ascii?Q?y1UwhOh3894guDGNicj1hmsmhbu5Yp6qqzo/Aia4Q0CBkvNmyt4a83JAStrK?=
 =?us-ascii?Q?DXx7ksxhEJl76TkizPT+2PMCm90UoU4lg2S5+fVwrZunc+8Nu/kC48TN9nEf?=
 =?us-ascii?Q?pyvWIKV5Pij7w8w5zPoISHM4Pmu4jWqrJb2j8/KeP+krDaKq3helOAwHd+DQ?=
 =?us-ascii?Q?UjHVPmRUcQn0jDp4Ma/dsep/O8wYb/bTLvt79K6hwmFEtFuMySeQI58VggeS?=
 =?us-ascii?Q?1j6mlUNQuaaMcbQQFblpWOFw4Bg1t4MpdhHYbD60dGifUdlDc4jnv/RBEgDO?=
 =?us-ascii?Q?r5RwPAWAwYZLUyixaLG0mlVEI9wuqb1TNqmWj+ihSwFvQyZUQWH1yD+PupTY?=
 =?us-ascii?Q?fT3KeeeeIMQ7MMIjhfeeuJJSg90t6uCJRfsqRv8Xnb2B05x95x8tqPrHm9PI?=
 =?us-ascii?Q?H2WVk+OdgJWCdhD1tJbHALHumLl7upkJJrPJCDdjdLyDV0AnsqSw/KSgJFij?=
 =?us-ascii?Q?P5MIlBHDIR+6rRuwfqfpNjr93QBjTlQrkFdT2V1zfHwkmT0xJEBm8DQdwKtL?=
 =?us-ascii?Q?MRvkolgAU6izq1hwZ2kvhBznvdp4icTTJX56N7eG8jYwkoRE0FnXXRkMO0EN?=
 =?us-ascii?Q?54djXDJfqIesVAMvzIPKTqPxdtSX7o//fRBkvlj3PU4mCwTrYvLJ/Qt9Iyw7?=
 =?us-ascii?Q?MWv2UAkrPCyFXZHxiwC7sTwJo+LeOnSdS9HYNBYu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 161f6c6a-a08b-4141-a9d2-08daf2b5e306
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 02:53:43.7744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PyHrkBuH/DPx3U1PnwXg5JLX3u72+TaychTeYu+S7dtg6Z5ja2F25PQH3V5gJcDH1NXOl2SDRd0WIoS1k8inSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7145
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 9, 2023 9:21 PM
>=20
> On Mon, Jan 09, 2023 at 05:46:04AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, December 19, 2022 4:47 PM
> > >
> > > This prepares to add ioctls for device cdev fd. This infrastructure i=
ncludes:
> > >     - vfio_iommufd_bind() to accept pt_id, and also return back dev_i=
d to
> > > caller.
> > >     - vfio_iommufd_attach() to support iommufd pgtable attach after
> > > bind_iommufd.
> >
> > Please mention that pt_id=3D=3D-1 implies detach.
>=20
> Oh, do we want that or a dedicated ioctl? -1 isn't a u32..
>=20

looks my comment was incorrect. 'detach' is marked by pt_id=3D=3DNULL
in vfio_iommufd_attach() while pt_id=3D=3D0 in vfio ioctl. In the latter ca=
se
u32 is fine.

aside from that I don't have a strong preference on a dedicated ioctl.

would like to hear Alex's opinion.
