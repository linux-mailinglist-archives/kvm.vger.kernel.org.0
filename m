Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8043063A319
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiK1Ibo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiK1Ibd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:31:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B926167FF
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669624293; x=1701160293;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P5nQw3Li4haqqUtOA9mK+5b6PeakAW/6aWmx/rQM4EE=;
  b=lhLrj3KYmIP3fCEbv3hHrMlOnXrfnHhsh7HCmSB0cLjxQuwd8400rQTW
   d/rlBWQQCX60XERNURp0zwq69CpnNvjFCD298JI0xqX8wz1JcAo39aI1Z
   5Cgcma740hs4jHOGjpDhqP+sV0SeIN6Sj5AqWmcBreK4pbZus7+OmtZW6
   wI1ixXG9iGvpVQJHo9yE+5YEaT8ds2rswG4uekPuQlrRpUGM9AdeqEzBW
   SahJhb9ImiVOZ3JF2VFU0p77Xj0Xv/eeqUWzHNuvlgOHGKNKWD7R3I+9I
   YxOI+TKdkPxcApS+SBKJj1VU2yeY3aTLZvg8854J0LF3FmIWwm3TQf5d7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="341690169"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="341690169"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:31:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="972173724"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="972173724"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 28 Nov 2022 00:31:31 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:31:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:31:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:31:31 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:31:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLJAJDySoAw4FH/eHWCNy+tkvVCTOkW21BTkzvQ3e4Q6d8DmdPVPRfAaiJIx9n4ywY8lLq3jyv5R2uKyjhWiPjg69fZeM6UQjdUwSzfN4kU/MMZwGl2RGsErxiZI09MBlmuNsRDNFatwBknJr9zD/wloxPIWziD1Y3Wc4PZCPe5jyWfj+t2aDSsjvIJHRY3V01sdG7kUHoJLA65tpBuPBl8H6sBmyAnGoj82XaJQCNB0Y19nsRllUsEp6QXP8I5c0AM73NLczbhPRTAyCQvFyDhnkqt6xdlkt3Ik/52mGLJnpwUikAEV+t1H62EakkHoGG5qi84ea3/WQftWy1o+7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5nQw3Li4haqqUtOA9mK+5b6PeakAW/6aWmx/rQM4EE=;
 b=QnQ4cXaDgi//h88BA0lo0OrikuADD4V74VyDI6UHz1KbGd8HZKWV5MlQYfdb2Nfan6EHmBe392Dxq0SMMYj28MwjCfAQLFo24akYoDnBfFbPRdFH5BEwwv/Knj5bY9+XkVPs/rcaoS6OTdFvZf5yAVq0nZQrKw/x3lXkbmNpdFQN3De98CB2r1EnfbxHJP9KQ9av7yO7KkqbmkvHSnoIELttnLyHa1nioa7yTTKN/JG7MagsYzzHHqsQ16zRbNceD/5HkTutcOrRBOZ1SsSMD2+muV32VonCO6/7depIHXr1Zel52rj6Ti5PbyHZfOKFiIPMyObNlkxtksFW+O4lQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6379.namprd11.prod.outlook.com (2603:10b6:510:1f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 08:31:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:31:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Thread-Topic: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Thread-Index: AQHZAAAZ+oX497Yw4EuINBzCkR2rra5UB35w
Date:   Mon, 28 Nov 2022 08:31:27 +0000
Message-ID: <BN9PR11MB52760DC8D983C4E95C3184018C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-9-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6379:EE_
x-ms-office365-filtering-correlation-id: 73da2891-649e-428b-a4d3-08dad11af1b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCDKCVqrvro8e0zlGSvncp9QXQc5Jkrfi1jxC1Gd8xVeXq3IlPcAfW1oQj4GZuyY/wqbuDnFicPF68SOrDIsxu6EjR79z/HQbztoatTf/h4S8kKrwI9SnyMAeS248YbYexJI5nrBe3cuUqHP8x8oweKOL7xEimERjLEI56BixiyMvPQH0BVyBMnZwl5fHmGAH3bky1565PCQV1QP6exlzjncwPcgibdi0izCA/71M3ir9lNgA3WpMZ1IdRzgZLlnH185ITIhw4ROKW2A0qvEUkk5X4EHHNgzaZW30d35uOLSR7j2kUs6uZB5kkeM4AEY80zsU5UU2R03/Bl4bEV0TrgSfTmmjlBe5Bovg9AIqXK5xns0AhgSGyNNKRLZ6AZZdlgeDgekVW1n5Dtp8ZpTl83UPA8h8FFASOKyiPq3mddquReJgZNXyJ9fMl42nSGIE1Sfa0tDKvipWELotbUn2Wa5Y6cUgoVwuG2+vg1hu0M+9FimJLy2gZpo/a2HaCVpsreekBP4h0cNppPkugeGKugnj+1/FIa/pJfbDLcJbYrS7ixFsnCTm8ggPn28NRGq8JgbMquhBDKym8IbHv8DeKfe+ajyc0wsZ9L14kuwhxJG6Xt6pAv8H9HSeR95NF5oaN35jIlDvL9ZldWfHDggVTu9dpNzzKDVzFSMKK4bdMvd12zfPns2vXxoSqPAUp+V+cUWijzm9h5yzp9pWkstKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199015)(8676002)(66556008)(66476007)(64756008)(66446008)(52536014)(41300700001)(110136005)(54906003)(316002)(4326008)(76116006)(66946007)(5660300002)(8936002)(26005)(9686003)(7696005)(6506007)(478600001)(122000001)(71200400001)(186003)(2906002)(558084003)(38100700002)(33656002)(82960400001)(86362001)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?26G5h9kR37EmeRmBXTNzFiLdAsGrD/PwH0uYnS/AzzoGybjEZW77Vk0Lb3mg?=
 =?us-ascii?Q?wfJHWjI0bg9mTssMoJLzMOluBCTCZKjLfUIF627pVr9/x0bzy0vogdK/Oek/?=
 =?us-ascii?Q?cRwAG0kJ9Kco9OiVXtTiPUgdAdMM8GdBgNEZ2IxcbdprHDmSW9A2T9R7mZa8?=
 =?us-ascii?Q?l+tOn02ChUZRIy+V6nN6bpevO9BjApYP3n/78/mV9jQ4ey4XOlkUbd/EojdE?=
 =?us-ascii?Q?0poGO/EuFtNqKbh7ZLnkufZlZd/8dzo1+LwJVbXSSfIBBwserroRYnVG8On7?=
 =?us-ascii?Q?uXBLGU4C2jv8YoUqf1zY3sjYNk42SOaBMFuB+IZneQ/M19LwvIWAPy012Jef?=
 =?us-ascii?Q?j0L6hzu/MJJow1mIzxVxj1Jrpb+N/+g97fr9txqm9UQ2sJEMlQaM+88q/RQo?=
 =?us-ascii?Q?F24DlkgTqRAOx1BD/qeAssyfmRwzuvw2d5L/i4GQR/6W1CYvcuikgcdv9Tbh?=
 =?us-ascii?Q?Q1K9lS3OA9kZZNKKQZP8OBQvsZE4Kg2K4kg/xIbHdRXEM2LR86ggmDpNJksb?=
 =?us-ascii?Q?pGICrwutj11pFXcmBDyvtefF8S5vx4t1iiKbxa0JtaNrrFa2ypqQ7daP5k3w?=
 =?us-ascii?Q?edVLUbkkvgtXv6TVrWT6dNhG7HZ9STu3m6+ODCArQ6oUR3tw/Mz9Leqa1+0P?=
 =?us-ascii?Q?mXdstNATPm4W2XfD0ogBk4ecEEsqvHIjBd5ru/RGUgmJx4+A/Kf05EBR/L9x?=
 =?us-ascii?Q?B8t4cNsncrJT5fVzc/TmXtpo8tGW6JrbwUobPLYxGXRQQkjlRF8X1kVu8GU9?=
 =?us-ascii?Q?DSa/4R93epfY7QnWs9+kBCsZrkalzSMueFLIp8Z+MNbz3gji04VVbWarrl/K?=
 =?us-ascii?Q?PV87676XnMrxBGQT5lu/lo5m0uvyCXoxEdmkhBaZVPVgEgpnUeSqayi3D/mk?=
 =?us-ascii?Q?ci21Jh0j4nuAJTGhcKFY5bKgRnz6TPiRVXsRXb6NnWuQzMU9QHAXnaKvCQRy?=
 =?us-ascii?Q?GYBPxpkhTCA0PzVAYRErXcOexCD4GxEeldCF+QzC/JUyzITEk3pfxeWcUuOa?=
 =?us-ascii?Q?48bKoK/9/hVnxRWkOprLxeaMM4vdtIoYSCwwoxQlCsjdGedJ3HWTX9OLj6OA?=
 =?us-ascii?Q?7ygZtr0OBOdtSd26nr5DTxJ4ArnSJNBJMj8oT9nPJjHiGGgMxUTcdxKXmPh9?=
 =?us-ascii?Q?VTX9TSZ3irFuFQDRCbOgIJYY/Igs5hiekEQygGBwb3n3C0fhWdm0avvW1AW3?=
 =?us-ascii?Q?nJYiFPiTYBB2JsJMNT4JGbIUOAfvoLSLULqZcDfgz+OJufjO21ft+wDe28ow?=
 =?us-ascii?Q?/pgDV8V4Nzawy2i3JUQcHyGTGYvcw68XjYymLlqI1ZO2ieXC24tPfKXPizRt?=
 =?us-ascii?Q?Y4GAvuY23ybb76YLIbTtBUWZ4wwSI/OxE6QfRx5PKklfMLvWLPccjqCzyP1u?=
 =?us-ascii?Q?lvnJR6PSsDnMhaC47dzU1dAJw3N5dQWBjwwU9rwCDivvXCdFgYkdtl0dGBl/?=
 =?us-ascii?Q?mznqZppYTv5flQPCVB/mrmjoaPLaSDUxdtyVtufvd+i878B6dl2ba9zYpaF8?=
 =?us-ascii?Q?lH6Cdbn20yjCVh4mAlGaktZeBmB+O7H+xW28u5jyTYpKn6SojhH/a+t1R6kb?=
 =?us-ascii?Q?ah9BZN3Qw5o2WROD6SN0JMT8lS87Nu2OCARgbTwf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73da2891-649e-428b-a4d3-08dad11af1b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:31:28.0118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: evklpFwaTPdrtVF5JDjKvGQKLqR2DmF8DP9lqkp7zVFCiUZYf9wjEFhVJtU3qDLfIvLGjMvOdzFBFVDbWEvWHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6379
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> To prepare for moving group specific code out from vfio_main.c.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

it's not easy to review this patch with Jason's further change. Will wait
until next version
