Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC7774FAA
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 02:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjHIADM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 20:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjHIADM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 20:03:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8848810F7;
        Tue,  8 Aug 2023 17:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691539391; x=1723075391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pSv231r1AjpRiz65tN/dtnEmtEZiA1euU6TEbyh2+sU=;
  b=eXbyBcgWB8gl5J+7oRCdrKgL2KCPXHevMnNTBX6dBGWM0LTOvhR6Z60B
   neowQWcEbQOSD+z/BiLSivakEh2C+ImbwgLa6MOQ7ei3zMdubYDho3dD7
   4GXjrWm1wZUIZvdvfgK8uHms4mRW3EkY8zDo26uKRF7tZnGZLFoCB6xFY
   NPutxanJLFysDZZiP6Mquxi15fcD5lQyxD/Q4AQLQZyO2ghNP+WqwmqFh
   DOa+fVRsoYHhY0LUc031oo4CaXn5VJdp4F99UFR3MBBhMULsmtCbTk6qV
   NtnzdLpJHdmFXkrjVz7QSBgBbOchqcLBjzHsqAm/N3bxS+Lv1Mjx2FXoL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="370976885"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="370976885"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 17:03:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="761130721"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="761130721"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2023 17:03:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:03:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 17:03:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 17:03:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 17:02:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXnUUZE2dXKg9urKZYZ9s3is4vYDMe2A1ie/QMgR08JA32qBqR6/mtE4fdzwwkZh5klygQqMbfscGasVSCpO8T9tpXzfJAULIiEMm0032gPJqAJ6lLpI67aMWNs/vOgqYiW4906KP/nXU/JalJSxiWzZeTsTJUvpzRGv6XqgjRCxNNkUjpxtRzGKqvQ/W+tpI3VVy9QfIWOV7Isbgg5GTV6W/kqg15FmYG7WJnmUWZEEhxwiDwogLq04e5wrYP1aZee6EKIbNywAyV3ApzyQ+UIxP5EklQuxTXkUpJeP9N5GwSzq00ev7LexvbEFibKJZMDF8obEsrpSH1pxy2bhNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pSv231r1AjpRiz65tN/dtnEmtEZiA1euU6TEbyh2+sU=;
 b=OWMBqvbY+EoZbtmNH0eq0ii5lLtrqrCafuiiwwlETYFThIUz4UkbPrN1zi047AJfIJWJuwqnZ2Rmfo4VugqFkb7Ot/hsI2Kt/O7Ve8k9Jok2EkgFpacrhs413/uqf/LtZvH7kryL3hji/0xxlBo7SR4Gk4550rb3s/OsleQTADKP0MirLGO6DlBy3G7mHmP9Oyuvhf6SBnzaYVZE2IaiOkdRE48vcK6b8UlrMMYu2M3NksSzIqoBwRzdcckuneAwYwesh5KrcQcAmE8jTsk4I/AXC4nfOen//srPH61bkOfq5lgAmlC2qcLWOCTAArx15KvUhNx8lQePQsA/G0tsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 00:02:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 00:02:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
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
Subject: RE: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Topic: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Thread-Index: AQHZwE5hR532wMNk30qvLyiBGXN6vq/YQ9iwgAiL+4CAAFj2UA==
Date:   Wed, 9 Aug 2023 00:02:50 +0000
Message-ID: <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
In-Reply-To: <ZNKMz04uhzL9T7ya@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA2PR11MB4873:EE_
x-ms-office365-filtering-correlation-id: a9e81b44-c04c-4640-3bf6-08db986bf8d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: txl2NQQsL+MObFslvg3Alvs/l/XsnH7FORE46794bj7kJd89Ngdb/istbdH2I8nzT+j7ryCUau8Gw27CRhmuM5C7RC5d3Tuj671lI68DcAeZ+ZSscazhLQujDwoFR9adbSHciHI6wbbOk44t2G/GHi2XPu7RI5J0Qjw9MxchQTaYdXloYYVZkxE/lgL+hlJixfx6dQZSPvHyN64mbA86FQBQdroTWCjGcc8To6g5ZE1H5sDESGlTpCv1l7XTSLONeWimWxjLLAzC26jPnZ1wkkNgGji5c4NqEK737FB/mJqH4C+sO4IpRN38DIGGQ/y/YVl4HXU5XTUXeIn9U3Z35dObfW8shRuE5sG35wy9qFKITy1ad/y/CS+tlDem1dWCE40hDLrC3Y2I2rSSFRJkrBv23p4WO7pV9FjbYwc/q4QoIPnJChB/AJJ6FV4pZ7MiJEd16X23v5Bc6dpg0GP14B6ajEeOjT7zsj3vTk4luIBbGZ1o1JUisSiTY926OMsZnEMmpVOIMpGX/4BjKwrOGzPbP/1o0bw+Q0jx49Z0/nR0ULo+rRcaM6Iu5YHj6rSKUPVfQvArxsS6fhHct+UhKuYLXugmnkgLTI8WGUyIEhGfD461FYwV/BySZ5ocFjKR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(1800799006)(186006)(55016003)(38070700005)(33656002)(71200400001)(86362001)(26005)(6506007)(82960400001)(38100700002)(122000001)(478600001)(2906002)(4744005)(9686003)(7696005)(54906003)(52536014)(76116006)(5660300002)(66476007)(66446008)(64756008)(66946007)(66556008)(8676002)(7416002)(8936002)(41300700001)(4326008)(316002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZgtSXzph7BM4fxqJe0IJ/zR9PsY7EE59lWFr+1gnP9R8vlt1B54q6iHIRlJF?=
 =?us-ascii?Q?/J8Z7SK7OZwqUlN3kwn8sTjpamX5ektvuA6rb0vjQQcG/rE3IPo3lvvqi30I?=
 =?us-ascii?Q?zkMJP0DPIg4yC669MMxZl87QikkMtE0XcuOskt3VLkuDszOZf7NqhvxL6HDd?=
 =?us-ascii?Q?NWCX+2pGyKEQ0A1sWSZk8zpdydd0WH0ilCvDS6bmmHZDDSp9gaPHgDe5rugI?=
 =?us-ascii?Q?5SqKfJkZkIIvRcnkabhhXNF6424wRVBSEJk2EQanUReYUQxO9h6LBgd07Bb7?=
 =?us-ascii?Q?3bWToeAeYl0jlUv7H9/OHN0kb58rRd4hoEtkNq6Oa+VT3fY63xNvRkHzcRDt?=
 =?us-ascii?Q?LYzLaGZz3AOsDzDOs3chK9ulBunojaS3g7PKi/DmuSvLsG9y6EtfGetJHr3+?=
 =?us-ascii?Q?cTuKDc+muJbvVyk5K952Dw9ghC50A65zTTJ1FOpcb44uEdr8hm3kwXvT8pD4?=
 =?us-ascii?Q?7BUMDEAXVI3GukCyezbPMQPq7eEP2dhaku6sSQCTO4u+NDJBB6+/pdFPrGEg?=
 =?us-ascii?Q?cUS3VpISLjihktWZ/YrI9uanx5f5AkvNQkppXVOceGSJM7KklKDXZQ2FIGAP?=
 =?us-ascii?Q?FvmXk66+imr7GnPMaU6xdeCwp6JZ2lnXrIzI5AKTp2CzJH2NAMBj1dr1V6Q4?=
 =?us-ascii?Q?sd/noWV8jabrjZfqr8f836ruOXYS4Yq9ZiRUSWIbFiWEoFcgKB+aODRIK8FY?=
 =?us-ascii?Q?jGoc4TkFm5P2WVODZfh466QuQSGfFbCzkhypME7yQ+dhrp6gqHP5B9Ysnjki?=
 =?us-ascii?Q?4tcpCex7+lGA4YqJwp0DiWD3+hbaB2H+CSxCHHLpnSIguDIewMKXTvIpi8X5?=
 =?us-ascii?Q?yh7S++mJOehX72RJnTTyboqaQi8zKn8QF4I0agDOaxXD0PukurNYZ0MI8HHd?=
 =?us-ascii?Q?ROwUUcRlaBmpsK9wk00gWw5K5L3w1r9zifJRkiBp6Py++3gfdVb47UMdMotq?=
 =?us-ascii?Q?9XJiD7Xs4kePi9QB1getowxA/9HJd8qsHoUafDPGvRj8z3q4y9NtnPml+X3I?=
 =?us-ascii?Q?zB/6TJQ2oV8I6MYLDrPf0StWv3+kVcajhGfrSRW2QhiMvH+RNRCoCiJ2ZE3s?=
 =?us-ascii?Q?YKZ7DqlsiLTL2R5RAq1Q9MMCOIeIrAeAYUqMq2RofbeGuUKtjVb9trCJ/+z6?=
 =?us-ascii?Q?V2ywlrSFSTcNxwZfROPrPz0Bks4bWHo5WLMXcSZSvVZrAlnDgJ9ssKPZDUVA?=
 =?us-ascii?Q?NRcSYETkxw+2OufsWvg6RS9wu5SJfUk/AQcdiOBuRJT1xa0u/7+QDu80WS+1?=
 =?us-ascii?Q?s+qaq83RSAHBqTgXlmV1gY6qw/ydLmjJzUZG9Jzh0FlE2L7sfSju/syEYq00?=
 =?us-ascii?Q?BxA8LlR458UuO1v/jjnK7Z8cFwb+2aAxX0r/HMdqHJyNwsU1g8ga1KlpaQ/+?=
 =?us-ascii?Q?z0iS84jnIjxVM/m2kxa9dsjKTPK002pNd7arz8/rOE8s5PCUrzrq+RsrgKg8?=
 =?us-ascii?Q?hxzpgn9oBo0L2My8duyRIuJBINr8Ev/k+0mWaIfUv7vnASovbdGa+ZGS4O3g?=
 =?us-ascii?Q?Xurlm4RQPSGo+rh6ve9ngJHI107H2BVQLyp7LMfDrUF7XfaWmZJ3ItRn+wqc?=
 =?us-ascii?Q?V5RWhc/rRDYRwk6mr+ReATelIUsqZcg+KAvTJ+aa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e81b44-c04c-4640-3bf6-08db986bf8d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2023 00:02:50.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M48tgPuhtBXvvspkmT6eXINGToW/n9vuh4DLBFYhr9WSzARQARaPeLpA37dLMpTeengTFKrHN8o4EZKHvQ+idQ==
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
> Sent: Wednesday, August 9, 2023 2:43 AM
>=20
> On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
>=20
> > Is there plan to introduce further error in the future? otherwise this =
should
> > be void.
> >
> > btw the work queue is only for sva. If there is no other caller this ca=
n be
> > just kept in iommu-sva.c. No need to create a helper.
>=20
> I think more than just SVA will need a work queue context to process
> their faults.
>=20

then this series needs more work. Currently the abstraction doesn't
include workqueue in the common fault reporting layer.
