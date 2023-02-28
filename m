Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E076A5197
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 04:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjB1DDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 22:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjB1DDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 22:03:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE80EF90;
        Mon, 27 Feb 2023 19:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677553413; x=1709089413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7EaGcUfyx/YBo0XcUW/1BxKJVdbuntSYKmRVMScFRy0=;
  b=ebNXglgNH2otfzor0L+7Mh4tNXzSozJLkVESubsFNMLdXwi2vliEV6k6
   N5rhKgDJGd+nxEgh9ZmKaMsHhFSU4SnoUaR11BplFE5pEiGNPog0ePe4h
   rVWtYQTA9M6jYo/je179lUbEbHY3XK+X9DGUhl9SKgfTWRnKWKWlE9f7U
   W7ykYNfDtfaha5zobKTq/tMjquewQI7gLxOYgJECubC+acbA/EpZn8sdc
   3OwzQ2obFCe4gzUwioPHp4kL+nghGHOrweyEhXXbNetdjuMNhJYBms9K+
   WjqMKShQZi8rRp8geQ5uETdvrVtQ0nwDo59BfBwt252e2AseTy47VM/F6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="313707760"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="313707760"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 19:03:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="816920270"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="816920270"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 27 Feb 2023 19:03:16 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:03:16 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 19:03:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 19:03:15 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 19:03:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWF7xxiEdUgtsrkVGkpwyzYh25NA9euZtNPZYywxMsA8YW9Qa9PiOV1Vb1RPXcu6KeWnA7/PR91ReRlNR5qv2B2m5GwP7rNAdbF4oWwDMF0f6nqm0/kyFkuDpQTdBZ9h16WXZgdegPVwPazfypR80bA5bvUq4vLpSrYgDL3SEJzdIfMih1HAStO1w7tQ+aY2HWiv3iWvXJ+Kr6V1163jT+x51Kp5Og0d9cyUNYmhbPeQIZK2wxDB/2iETvR8WthFnaMpOhddN6n+ZTuAu3WdxAt0MCnAS7zZDjLw0Wi1N/gp7UqjxpzvuetaL7RoIv520LG3Fx8pGRXJ/MSDNkDu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EaGcUfyx/YBo0XcUW/1BxKJVdbuntSYKmRVMScFRy0=;
 b=f4gaQg1F/QP/2iJxLsEOWsFriyw20eE5WNGGtVYLszgX0RzBGYySKBJAgV0PFHYR5ks7VtSWH7P/UglgYpP7f6HDrn+SlPN6UBw8BC5p/P0zBuScX1zf0oiUlaFa2dJPfepR83GDedjUYcOyzeU9aaSQfEr+YDNnNWICbELQ52iq72D8VKJZ3R227v8zu+5guH/Skj9FhL+QngGE7g94ASld9J54ULBs9Ql0mVlQ6DNhhS5buG3GA6gSayeS26udCmwdmt1Y/WuJosYM1O0NkiuxBDsd0RUSw7f8HKDU2wduniJU7lciPZuaWEfFIZClLqLt9vTBsyLYLtd5WG5J4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6602.namprd11.prod.outlook.com (2603:10b6:806:272::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Tue, 28 Feb
 2023 03:03:14 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 03:03:13 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Thread-Index: AQHZSpxK1lmQCF+hqU67xTFYCSDhDq7jLB2AgACAqYA=
Date:   Tue, 28 Feb 2023 03:03:13 +0000
Message-ID: <DS0PR11MB7529A422D4361B39CCA3D248C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <Y/0Cr/tcNCzzIAhi@nvidia.com>
In-Reply-To: <Y/0Cr/tcNCzzIAhi@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6602:EE_
x-ms-office365-filtering-correlation-id: d72ed26d-dd67-4069-9b7b-08db193854f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rQSe+SorW67QoEAILx0A90gPylO1qzyhZ5WKwXOGnOA7gzpSGAvT6cmSy2Jo7u7GcoqFC8qNneQ/uVKYs1DDVFe2e77tLxFTB9+N4a4x0veKiJCM/kPz4J3xyWejFFg0wvmsov27IkzOUUzPBsPxdJN8rpwl/g/PClDBR8H1UhGzhCEJhwK6hFzrm/YqYj/3jlpaE/owmBTGEqMUNm/25Nmq6iJVikGMvbWe2mvpt3FkGPPlX9xPylj2uNkqXx2mfh1Pu/T7UQiIGtuXtVi2XY8H+jXdqHjfPfWswBoksCV1mQk9nwCLnqOEoPivzoxR2gjSCR5U4/9VfH57+cF9b7cHwCveUs7onWf7bS0E/TLFD3ZeFv61rZ2f9TyaswJewl/QMifsHvBiwoR+rmKR9QleH4Md0FvoDqCgmTJf8G8WIluhuhaZG/yN4uHzX9gBicUxje8E/qrQ/1M1VTSZoQ3y05t9BhhJEd93LXdHpL0w5AWjlBdxfvLhLOwcnJAwdw6AHTi2yHw/OH/kD4YjU29bTbhmkjfdmCK0QuN1yNQE5ozzWzQU2O5bnofhWWy70pL7yI+HZqTY80CxV7te2af/BGjBIhAdBxnNGrFFNX5n8Wj8e9JyALyuGIuStxy2jtg4QktmqZ2CrtPN/kJd8GoQGrzkuWL/6EuOSBZ32x1rPQ8s8/aaB1wSQIu1V3Tb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(83380400001)(2906002)(66946007)(478600001)(66446008)(6916009)(8676002)(64756008)(76116006)(66476007)(4326008)(7416002)(66556008)(26005)(9686003)(186003)(122000001)(5660300002)(8936002)(82960400001)(41300700001)(38100700002)(52536014)(86362001)(71200400001)(966005)(54906003)(33656002)(7696005)(6506007)(55016003)(316002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BDLScEaksdiBOfzzKC63T3o5pjsrSj1sFa+6yC4yFxDXZKMmNhR0VvP3rKHZ?=
 =?us-ascii?Q?1vvnu23f5APTeS0LRa0fxnMPwV7bV9KVqtC34aWnramu0a7b/IYP3amK9MMm?=
 =?us-ascii?Q?1Di/QRbtaO9ptbhRo8W99/fJeWPcWzlKAGBfrOnVmbG9KTnxK9Kq1RrG19Q2?=
 =?us-ascii?Q?RvmG8Cuy4gMNUTDpnshIQ/iMFYAfIiKmL3+/3MnbeUgzsrEkE8FZ7p1w5xzV?=
 =?us-ascii?Q?Rwr5SWybO4EYyZemvcd5kZUHxBd10hijf0GHP3E1v+FLHpry8i/+gR4GnpPA?=
 =?us-ascii?Q?88IqUXqGoMLBDTufW09/8CZOSDFdCRaZ26kJT70ueOwODAdp81WICEg+W+NR?=
 =?us-ascii?Q?8uGmLTPAmllok/6prz1nDdqCo8cuf+iayR1pF51wRkWyPSYcR1uu0PHhJfay?=
 =?us-ascii?Q?9J/TY+DarkHszAevZ19+BKCcQ1W7AMBk+cGQD0H0U3bRDJ2MIT+Xi1juflOq?=
 =?us-ascii?Q?xBr2JxtILd6VaswMNPKOSuYrot+8yXT8gOK2PNkhNcPYj6odHMsUBP7sLyR9?=
 =?us-ascii?Q?xdcKVBS9/IQ9WHhiMn35RU8WGPnFM86JSrCLdYtLp+abjGVjJQ63YSYgQC+w?=
 =?us-ascii?Q?2EMzXnWcS0dgMS2S+2Rr14iu+gLrXkHBoPBnQh+D0JRDsR2rFAM4xUEmZR1o?=
 =?us-ascii?Q?2j17nXAiO4eICPwbe5tls45uHoBrr+9rjiAE8EkXOrebz4UAg5hCzDoOOMan?=
 =?us-ascii?Q?Xo73pi72YML4HpYuXSh+tNkitr58yAjTdemSJwx2wHq4XeuDs+mYJ4NNeVOg?=
 =?us-ascii?Q?Ur6zHNh6npHPeg1s2QoQDO5DhqbdcWZN+b/8jHmEPeX/p/dkxbaK86AhwbTy?=
 =?us-ascii?Q?X7InTHIpBBAT7g9P6MqzOe2TFp5vc/jXzLqhtZoIWHn8eNNXo6cBFMcX7H9z?=
 =?us-ascii?Q?QfJ4Jow+car6yYGC9Tt1fZFm/D63pHjNX4HPqtqkWfl5ptzJA8zv/GAZsKs+?=
 =?us-ascii?Q?YaiQOQu6aHrdHR6QBSm49be7Hpt+Av4u+a5k1O51t/kz+NIorQM2pnMwrEZx?=
 =?us-ascii?Q?dhWfIAY8KMnf6cFCnu+sl5JgkuO4oR1otP8cGNbbxSV9FVUBro6PLS/wLxd2?=
 =?us-ascii?Q?4+eEEZZMD0ustX5LYtoqxz6W3of4kbytC68Xh315yk8HFOhUOnTMwnxQ5WYH?=
 =?us-ascii?Q?lk1ZNl+h3X6qBorZBmUOukyNr23daW0YkbikB0yc9TggJfiVo2eIlfLCjlIk?=
 =?us-ascii?Q?1fN4EOSBMbeFlY9RVGXlVDwXV92IecxTJjcI7iNc71G6qv2trYHEeI1eSHjQ?=
 =?us-ascii?Q?lW50sVv1Yyz/IZ+HIz5RMcv8UDWAPz1MNDVj0NdsfMA0tllrVqhRwpnv7Nqu?=
 =?us-ascii?Q?kWh5uuttyhDZvoNyQKuffij75Ags03uSXwHSjP+Txy5iR72yB+23Gik47wF6?=
 =?us-ascii?Q?AfcyDotuduT1Rvh4D1dxa1Es6zecIjD/dP2ErkTM+mL1lV3KXV4w0ZvTh79k?=
 =?us-ascii?Q?pxqfl9ll8MjWPscmQUgIcZIIHODHg4KWeBpqU/OGQ2A7Ms4yBeYKrkBPijDh?=
 =?us-ascii?Q?/6Dj6qSHZ8dIIqshSsUQ9MBqpBkhlW9cQCvY6C6iRsQFW+7770IWPsGrPrbE?=
 =?us-ascii?Q?w1Q3fu5sjWMufIdKOOWNabnfNzPXp8Lp2oNw62rv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72ed26d-dd67-4069-9b7b-08db193854f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 03:03:13.6727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r0+qflwXltNnSNg1hccm48dNk1HuRyHr3naRTphG9VNoqMkjzibx6I5paqP9jU9xzsM/h5hmtKvlQkAHnkntCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6602
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 3:21 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:16AM -0800, Yi Liu wrote:
> > Existing VFIO provides group-centric user APIs for userspace. Userspace
> > opens the /dev/vfio/$group_id first before getting device fd and hence
> > getting access to device. This is not the desired model for iommufd. Pe=
r
> > the conclusion of community discussion[1], iommufd provides device-
> centric
> > kAPIs and requires its consumer (like VFIO) to be device-centric user
> > APIs. Such user APIs are used to associate device with iommufd and also
> > the I/O address spaces managed by the iommufd.
> >
> > This series first introduces a per device file structure to be prepared
> > for further enhancement and refactors the kvm-vfio code to be prepared
> > for accepting device file from userspace. Then refactors the vfio to be
> > able to handle iommufd binding. This refactor includes the mechanism of
> > blocking device access before iommufd bind, making the device_open
> exclusive.
> > between the group path and the cdev path. Eventually, adds the cdev
> support
> > for vfio device, and makes group infrastructure optional as it is not n=
eeded
> > when vfio device cdev is compiled.
> >
> > This is also a prerequisite for iommu nesting for vfio device[2].
> >
> > The complete code can be found in below branch, simple test done with
> the
> > legacy group path and the cdev path. Draft QEMU branch can be found
> at[3]
> >
> > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v5
> > (config CONFIG_IOMMUFD=3Dy CONFIG_VFIO_DEVICE_CDEV=3Dy)
> >
> > base-commit: 63777bd2daa3625da6eada88bd9081f047664dad
>=20
> This needs to be rebased onto a clean v6.3-rc1 when it comes out

Yes, I'll send rebase and send one more version when v6.3-rc1
comes. Here just try to be near to the vfio code in Alex's next
branch.

Regards,
Yi Liu
