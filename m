Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F18774FA6
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 02:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjHIACL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjHIACK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 20:02:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F03A1;
        Tue,  8 Aug 2023 17:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691539328; x=1723075328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M5z4qsgxY2letyLvUgNJbpYlfYRxCOqedMRHzQgBbZk=;
  b=WOkTdvM/F8L7E26FkYtU2OJmyq8JpDn0mn8Be6aB12gpcmXr87UD3lK1
   80GPEQkaGf+mJcz0ROf+7J1HC/NlFgYLTlbpewxQpdDGtFE5hwkc7d7Zh
   GajnwyV3X7W5TfcQLuvzzM6EwiqcsKUsLEYyUAZ+wN1dJLg72t9pxqgs3
   FWinyGiIfKpsfOXZIlRbCxfDnYg2iV+enktVXxkSdTWBQ4R+IeSP8o2ab
   rv5TLfuWbVZnPdh4tFifeu8KjSOedIRHCNM6kBGJrUZcmJNXZuEn3IqPE
   CIA+3en3bShfSSR02saDsvbCb3SKMkS7DIdtSGGwP1OCM+BweHHFZ9nab
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="370976534"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="370976534"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 17:01:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="761130308"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="761130308"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2023 17:01:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:01:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:01:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 17:01:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 17:01:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhAbyAYWP12sMaHhPhTnX8wl1JzRqkjY/bhRNgwfMP8lrrjlFGRaMuaLRVnW4n2gkRzyF9iIDMjeu9oS5Un6XmJjAG5tSs/AbaayqUqkcl+6mcpw0wlXhKF0ofrx5v+IzdYo7dOxB2+0jjpBFHYL2trWnEXe80EHA0do6UI1aWyyVh5Cdt7wwE1sVom6CYyMpnTajIFaPYLLiakgcJIzg7u4vfKVz5WqSkw04T6iamjNV1cAbO4HbwqkjkGwN4rf3BgCC4/L1/2G+60ys3Q+8YuWqmWzOAzgZqMFMp05BbQPOvsbSceoy6H3vZbhR/tekhzDoHqwgQoz7lzE8/V+Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PC5RxCLw5VPTEsbjU0KB8AyRAeHObBDcVguUnWbylWQ=;
 b=ORSiFXUcK+JQjpmyoXJ2AAr6akyRNUsZaviH9RDtKZI/9gMw2aZ7gKPzQYpLiFXg142x6iKm2MykKDo2LZbbY93WkV50N6FZhIl6b2Lh9thgbiX/jQd363/evC3ZJyAg0Ho7quuDLIFAR5no2pBx112f5K0qjSj5+qCz4qxHXFtnfeivXRikdwcpaBOOr8nMGSQwSPXfe8/xLBmNyC9wdK/+XAkyzE8yorMpP6i3aOb4dEzL3eW2tReBbMonAu4FX/LAiVvFPRPgEru39vrOpSb0m4eRj5anmjM0sHj5qeFR2/MygE4HB7JbEUWYzq9WMVr36u6ZXXPCuitExEWx1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 00:01:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 00:01:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Topic: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Thread-Index: AQHZwE5XwmTCizFL9kGoEloX5eLFx6/YPsPQgAE/24CAAA6WQIAHQY4AgABZl1A=
Date:   Wed, 9 Aug 2023 00:01:52 +0000
Message-ID: <BN9PR11MB5276DA9E6474567FAFE9424B8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <BN9PR11MB52767976314CC61A0F8BEFD08C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <faad1948-5096-c9d3-616a-cd0f0a4b5876@linux.intel.com>
 <BN9PR11MB527614E61BC257FE113EFE358C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKL6hGRZT9qfV1K@ziepe.ca>
In-Reply-To: <ZNKL6hGRZT9qfV1K@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4873:EE_
x-ms-office365-filtering-correlation-id: 3b14effe-01a8-4f71-a97b-08db986bd63c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ft8BnhbvTQOFUQB8kN7xCCQtC2WL0dmqFyUt6bpnWxRE1k/StgMM+YaNC6kxCPGO1koNtE1yLiOKhRtfW7UX2zslnhcSkI+qGKb/vORtPYkCQjClyeb2erPWwLMZEf6qd0Rfd/hR744bZtABBiKjedEXGlmqCrSRzxIqNHVeqKT4Th4KMY0WWJB8nVkBbg7cFo1sF8m6rVaMlscSbxl2rMF/33KnpZlVJZYsLH4GBW+QlwHJghPFtR6XgNNd8HVmy2VH4L1aEIy/CnmXYqC9ZySa6DwlHKCok7rZjz88pKdUR9hYlOnloXaFDzEWn6t4XElsPHBrgxN1JAFv3iPGWGPrtd+9s0eMdDfUwmrOB/uiANZD2ttjopGEj3J1l6heNPmhFtkGXwgWv2E56oyV+gQPA1Kir9i8dMF8wyBP3lazoYHwXe5Xuf77avZhoLKS/Jzi+xit4EjfZUwilGcKgw+XQSUUdbaTHlRMS/0DwHeGl3qgBF10T3nTlobrJTcbi2wEFjUJv+DwDNogOMIZH9cYegswAsTqqhimGOEwEnxrsAO4nLd804TlB8Kc+e+7m2i1oKcqOCErSvwq2HAl+H8IFN81hiOqiUJF6jorBSUwin0NGMfTq+9u1j+JyvF8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(1800799006)(186006)(55016003)(38070700005)(33656002)(71200400001)(86362001)(53546011)(26005)(6506007)(82960400001)(38100700002)(122000001)(478600001)(2906002)(4744005)(9686003)(7696005)(54906003)(52536014)(76116006)(5660300002)(66476007)(66446008)(64756008)(66946007)(66556008)(8676002)(7416002)(8936002)(41300700001)(4326008)(316002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oop466vHNNVs/tZH9eLssW1SAL4V5+iez5Pcn7SExyC2NffM+ZKiWm/ix+Wf?=
 =?us-ascii?Q?TifZfQu0bJODadce7FQRXn+4fF+AQgT3UJ0I6W9lT5g4A4YPHT4JrmrP35+U?=
 =?us-ascii?Q?jQDoBIcqwOiwQcELZhGk5cMZogH1d60PrfZzA+86AX7EwOW5zmz3a0q0dc/f?=
 =?us-ascii?Q?qrrTHHXcYkvCeUphu7cgtkHOJ+D10BlyQ2J+X47eBXz3r4rJ0tbUoSmJE5YK?=
 =?us-ascii?Q?lICvHgfoHwLLjgKin6DjUQ4/g0pLL44zZNj36cwzoFQaci2SP8U2b3OjY9dl?=
 =?us-ascii?Q?8Q7+aOVToRSDh7q5q6Q6OPcTGVK8bV/F1AUebGCyY93lGwqoi/tAW3HstsEk?=
 =?us-ascii?Q?B/mhrMsBQnSx4f0XP0BfzG//LsGZgyDCRcLNfoI9TpB1Qlq9nzG1HmYJJw62?=
 =?us-ascii?Q?jPUHU3ORA0KMRsETJnQeiPInU1hQvQe6FSm1kIkJHNE12dhJT6WyMEtwpB2k?=
 =?us-ascii?Q?UuEW77KA/p9lAaVpztl0xi3kGs84ydgwrKv7qSoYaj+6Q8FJA2I0dgNZ9sPN?=
 =?us-ascii?Q?KdtTKVXZ0HZz/iJgtbDTRjXHugUw9tmiyhoUlKh1nsHfExUnAfCPBO54DTjY?=
 =?us-ascii?Q?2G4XiRVskgIpyKfMTRkYz5pRO1BmFTchRyrcusCehq9KSLm8G44cAxuHYHnq?=
 =?us-ascii?Q?mvrK7cqjgvYhhOf0JH53Kyfdtcx3y9ewvdsYCKW6NlSHuHyP64BpBWHnYvSL?=
 =?us-ascii?Q?UhcGYGwmwWIsd5lyZ2DeivkK0S2VnKlzJfreKeFJpmdzRcpxYYwcZp1R8Dke?=
 =?us-ascii?Q?VskTtw2t2IAZNZoCQh5k5WCo4Qn/K+yxIapFtf3ewTrwC9JO8hRleOIqov50?=
 =?us-ascii?Q?fRWkIjgfqfsd1+Gd2ErgVuk4QPcFurpDbyxEhX05ty4D849J7+L0Qsc91+Vv?=
 =?us-ascii?Q?T1AA/RDXx2zv6lsZTU9DX4pw6V8UouLIEzsx1YLkn9BUwAe5DgYYzJvn/IpL?=
 =?us-ascii?Q?lqwk7RmYabCyHDFh4rbl6em1cpntsiF4jmtVm9yT4y+/sKsiqG63Ak6J3PNa?=
 =?us-ascii?Q?u28kmntb8KBoCbzToaIo+6Q0kcnFa/2b9vYrIla9rktei65674Yifqvbpdjm?=
 =?us-ascii?Q?Csxc4LgFrzpmDAQrwNmNGKMy7h6hi6253PH+bTfTmt6fKOtC6goGEE8kbm98?=
 =?us-ascii?Q?65jx6iWfVqyJ3cKuw36zuOEbjMpk8MMt5wfFmWAaWsrbcM2HI1UsoNYP/zpm?=
 =?us-ascii?Q?Y6Z+jK6+6gdMb6aaOn5CpHKFZ6hG949bAomzfqhobZ5tBNfhB/vXTS/bXPz/?=
 =?us-ascii?Q?3gKYn+ILsUGz+C9vsQQr3ikCwzmpiRmQi/jS9QNMIljHrxaGQynCDrBSXY8J?=
 =?us-ascii?Q?KYonoxi8xLba7nJMaQszcVFf9zDHwJf5d+e2hj8asGMOT92GvFG9kW9WQSVa?=
 =?us-ascii?Q?fRkkbIMAWxrYekTA2baA9Gzsov/lw11UdvCG/ZJ8f/LAvq1APvSm+nmrYwve?=
 =?us-ascii?Q?iZx00k6zySZh7/kPLwkL5EG0hJJpQXRNTlQxzTkpGYpU2g9BJWWM3sofZMYW?=
 =?us-ascii?Q?G/Dwhr4aK1s7LZeT7g86TAOXiwFHXgOnzCwnDNl5BmYlS71qRjU+oivnt8ia?=
 =?us-ascii?Q?9cOaOse5bXprntW5Vyj++tiHkmcD2dwztmyFe7wW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b14effe-01a8-4f71-a97b-08db986bd63c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2023 00:01:52.5857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUIe7vHFrRGNggPVtG+xJACn5AnSej87tBC9P/9Twgc6Rv6SZuiPG7/k1L8jok8hG2Ni7hj/YSDyf+N98TEUzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Wednesday, August 9, 2023 2:40 AM
>=20
> On Fri, Aug 04, 2023 at 03:51:30AM +0000, Tian, Kevin wrote:
> > > From: Baolu Lu <baolu.lu@linux.intel.com>
> > > Sent: Friday, August 4, 2023 10:59 AM
> > >
> > > On 2023/8/3 15:54, Tian, Kevin wrote:
> > > >> From: Lu Baolu<baolu.lu@linux.intel.com>
> > > >> Sent: Thursday, July 27, 2023 1:48 PM
> > > >>
> > > >>   struct iommu_fault {
> > > >>   	__u32	type;
> > > >> -	__u32	padding;
> > > > this padding should be kept.
> > > >
> > >
> > > To keep above 64-bit aligned, right?
> > >
> >
> > yes
>=20
> If it is not uapi we should not explicitly document padding (and __u32
> should be u32). The compiler will add it if it is necessary.
>=20
> If the compiler isn't right for some reason then something else has
> gone wrong.
>=20

I thought this will be used as uAPI later. I'm fine to leave it be and
add the padding when the uAPI is introduced.
