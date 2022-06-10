Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844DF545DB8
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 09:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346946AbiFJHoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 03:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245507AbiFJHn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 03:43:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D627213AF10;
        Fri, 10 Jun 2022 00:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654847036; x=1686383036;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y4oREmctMEj4Sc7rTGAsjZLXLsLmvdTYxsO4iv7kPU4=;
  b=S9UEyebKH/DLNi3U29K33qgCGp8FhPhXj+cabl/pKT+rRyGHGeF9oI2e
   eoCEY8c6PeCWCpb/2Moko/UnlIvff8+Em5Ei9+k0DcjE95lIjB/epQ0C6
   8oG9bBOq9LBgbtxA5KHsgQ/cQ/k+OMRegDVr5clYa4DDLiktM/qKF3Gez
   d2Jp5f1a4KQ2ZheL0gcOCOeLCTDJlsTiGUcNJgfoILDJb1QNZktWE44En
   uTddiFnD6KoJRN4tFg5cz4oKJB2n1v5ruvmj2Ij348RNoFpk83XzxaWaH
   /zPx+BSdmTpcKPF3RSN8bZYlR7xLNR3Di74PEpTcFB1Z5sg5ecCFy130H
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="260669021"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="260669021"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 00:43:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="671727594"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jun 2022 00:43:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 10 Jun 2022 00:43:49 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 10 Jun 2022 00:43:48 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 10 Jun 2022 00:43:48 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 10 Jun 2022 00:43:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYuJ5KrQg8j4IFd+FFEgdmA8/32gH2aPOr25ahN3MvwXmLw6IuaGhHmQNvW0672MmlX+vMtlNkKgFU/ENck91ocqOuYEzk6+9ZsWVgOe0HrM6ViGO3N6k+7wAvqcGUjx3+Ci2WZHj2LbmpgPeW2aYnPHhkbyg5Ovv9rBR+DkFiSIBZfypvBM/Ck/7RMm53g9iOQLJBRYM2HEB278KBOMjZeX8anxgamJRgq4cewdo0FXvVRSYDEF1JS2MdYSZj6gy9b35w/z1NrP8uM3IHwPMDUoKnbP/k97SgElfgqM+EAaeP/J9394IrQcODL2tvHkkEr7++qp6Fisc1PjM7MFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4oREmctMEj4Sc7rTGAsjZLXLsLmvdTYxsO4iv7kPU4=;
 b=OaqgazfAJdFRIhUDuRXTod9+9fo7zqvdwbF3C4iPSidDdBFjEUpHV2SpIzjBFJiXWGhPvyUtZ7MAoJUXF8wAH58yNVcMLjb2TrGF2jDLvV17GTwdzxTPPRFiFhY1rKNLibyPTDR1tWheReMCUHekVpv8eNK0/B4Z+mrZjvzKK+t4xJl0pb5uqx4h1yF/nNl1CIktJv6AHjr1NbNwBTaDFMUiWUb50TgM16qMON4ZNeGweyy3AanY6xV7IIjspBXof+v+zJELO+7fngeYcrOjcybzhx04D5VyvDbT45m2YFrO7MoEpGtZZ//F3BTNAHl5CU5Mav4i8HeoPkE3JDNRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3454.namprd11.prod.outlook.com (2603:10b6:805:c1::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Fri, 10 Jun
 2022 07:43:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 07:43:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v1 14/18] vfio/mdev: Add mdev available instance checking
 to the core
Thread-Topic: [PATCH v1 14/18] vfio/mdev: Add mdev available instance checking
 to the core
Thread-Index: AQHYdqUz5WDlyYMPBEmY+ZzzQgTAva1C02IAgAAF7QCABXFLEA==
Date:   Fri, 10 Jun 2022 07:43:46 +0000
Message-ID: <BN9PR11MB5276228F26CC7B9EBE13489B8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-15-farman@linux.ibm.com>
         <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
 <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
In-Reply-To: <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3e36bfe-cffb-43e7-7b61-08da4ab4f3bd
x-ms-traffictypediagnostic: SN6PR11MB3454:EE_
x-microsoft-antispam-prvs: <SN6PR11MB345438BE56D1CC7C1F61C5888CA69@SN6PR11MB3454.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfqjccWz8bFNh1qRxtTC8SI6KG53xOYD+0Te643HHmdnWtQuzRZzHFDTMWuTyzkkGciTyRMZRI1utLj8KT/pJ+P3c2nOuXnfBPphur6cTL0RaJFrU/QdLukPF/TZnlyuixi9YGjcBxEnSjqokkOh4Gum0q9zSyBD7W02z4VtTeFX0krOB0ng01lam/R85nOAfN0RWPONFpb6fefH9qT8CzFfRaqWAT7jrIGpUsaVTRBjYxschm/NTi1D2oqItqwme7NSpJXxI7MJSn3pASS83KAgMUOYgl/SiOZQmlOh45skLImJ4pWniTVd+fSEEvVhDIvlRlGMQYxp4Rf6JuYBDyZlZY6zO2WYptHM348at3zns7q+e0/5nAj/rhzTk5X4jhCp5d3aFuwgjsy5ny3arUywokdtTep5EA+n76fAScI8qkYZzP/QZ/YJA1vo7JWX1o3QGMCYbbtX9wjxBk15X8xnigJjKgerBPRS1zD9SiIvT+GFpzuPMzW4EkKbArmho+gQeFXPfm3lEeAIfk7rdWD1YLuzymNWqvIXblVUn4D1pFHi4Sb2PmWemmPmyQInCT2vR10kkbXrgg9Qo03xa1Xf7fpfSKyDJd+8oZRmvUlnr7CGfOsZE4K3SStLuQNozXZR78JLN3F6sImX98P5klYj+Xk4QYKOkXwDZ31tB2fWUcPjYa0dle3yuiLOANthzvvV3FvtbiSmZthNUwiaXQez1f14esZSTCQziL7sh7oc6ThyK5n2OlGky5Va5hJ5s6ll68SPOawmAZPzOlPKBUBNMw1hY9IDK64PFCjo0AwvRSmkd/ie0q8YVq+BOce+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(82960400001)(52536014)(122000001)(2906002)(508600001)(33656002)(5660300002)(54906003)(71200400001)(110136005)(966005)(316002)(38070700005)(6506007)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(86362001)(53546011)(7696005)(4326008)(7416002)(8936002)(55016003)(186003)(8676002)(26005)(9686003)(131093003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M3h5QS82V1ZVSEp1R3J6b0dwVjB5ZW1SLzQ0NnU0RVUvdVMrZkhOK3Y1RHJm?=
 =?utf-8?B?bDNFc3RBbFpFcjBicVVVTnVuM2pMdXZrUCt2Rlpid0RaZlIvaklSTS94RnFD?=
 =?utf-8?B?VGVmaDNES1lYOGRhMFY4TFNQWE1JU044SGFFZnVjMURYb0E0bEtBbVc5MXc3?=
 =?utf-8?B?Z0Q1aE44eU1oOWJ6dEd6Y05BNlB2MFl1Mm5GWTJweUg5ZEhkbENuc3EyWmR6?=
 =?utf-8?B?OVZndjEzK2JuT01pRmpxdkh4R04xL0Z1MjkrLy9Mb0hyWTE1NE5jUmVEaG1M?=
 =?utf-8?B?Z0dhZUs1SXk4ZHRjMGV5TjlFUnhacGc1THlScEZ2L0htRi8vb0hFLzROSVFn?=
 =?utf-8?B?SlYzdjVOUk9QektQalFuQXhxeEN5WTBVVFdrdjQyZ1lncWFZaTBNUStJRzFK?=
 =?utf-8?B?MjkvSEcraWU4dzVVQjUvMWgyR05pV3hnN3JxeUtqNkxBTUIxdGMyTUhYRCtO?=
 =?utf-8?B?QktReENGdUtEVjBIYW5yTG5teElidnhUVkNVd1YwNlI1ZS9kRkJFVWdjNHA1?=
 =?utf-8?B?QkZBVXM5Q2UvVlRlVmtXMmNicTlSUzV1Znh1YmR1c0cyYnNIY1M3ZjdRS2pl?=
 =?utf-8?B?S3IxMXlBNHh5RjZBY0RiN1oyTFhpYnB6SlFHWVhvQzRPNm5pOFpDREl3OXkr?=
 =?utf-8?B?aWZWTjdac0FBTnZLSlRkR1hPU0xXdnJPMEJRMEd6NVJjczZpUWo0Z000YldY?=
 =?utf-8?B?VWZnRHlNZ25PNVAvdkttZ1VSb2cySnpwWWJ5anZwb2E3RGs4b1FzeXRKSG9V?=
 =?utf-8?B?a2crWXRCRXZKMEtYdWFYVkZKcnVVT2RYUlU4cHY3TzF6bHdpcXk1UU1sM29Q?=
 =?utf-8?B?WjBweWFSaVVwM29SMElmdnJVNkxyL3dUallhaHhabWZxM0hqeW02cERUOS9a?=
 =?utf-8?B?ZDBWb3luTHBoam9WTlkzZzNlR00rY0ZuMmhLVU1hNVUvZXh0bTNHT3QxWWRa?=
 =?utf-8?B?WTR0R0lGTHdtUWJvUWFZeXZEQi9VaVVIbXYyZmg0SmQrY2ZEeHViSDIrNW1h?=
 =?utf-8?B?bDB5MUo4eDFzeWhBRGVibjl1NnNjWUhldXRxQkVwczFVaDdHOGxHWHU2bjBh?=
 =?utf-8?B?VmhGbkNSN21qYS9NMkRXUjJLalJIQUUyQ1F0a0VFU2dMRXg4Q0FTMjVGcXN0?=
 =?utf-8?B?Zkp4NXExTDdvUkRweHUzOFpYZVdUUVVEbHVVQ0cydzdGZW9XVWlCY2cwTG9K?=
 =?utf-8?B?NVM2ZCtjdHFPdzdYeVFGUmhvTkZ2NWpYcFBBWUIyRUdiUVhNemRjOGk0YzJo?=
 =?utf-8?B?cXZwdUx4OXBjREo4eEV3UEVkVStZKzZsUFdDamRGYTkzRE1aaVpKNlNjL1VB?=
 =?utf-8?B?WlJHNzEvVEt1QnNkQmpWWmYvZm55WFZnN0s5STZXVjVIWEFaNTdxNUNvZGZr?=
 =?utf-8?B?bGlKdE1MVzBNYUg3TCtiZnBZU1lLY1ZFSHFsZGMvdmxiN2hGZGxRVEVUQXdR?=
 =?utf-8?B?TXVqQnV3OUdkTkNoV0IrV1A0cnJnZ3BncGlweDdzcC9EdzJOYk9kclFpRGVw?=
 =?utf-8?B?UnY0U3lXb3Ird2dOcXp6QmJ2bEppWmJlVkVxSlRGRGVMZkhabFdPcDVlbG1V?=
 =?utf-8?B?YjdvYmpVakNKV1NYMkVtS0hwV1JpQ0xGc1JsSGVNS3c3bUZUWUtWZkNrZVh0?=
 =?utf-8?B?UlVlWUpWenVTSlRvWDRxdzZlb2tyRGEwZyt6SXFQbHhxSjZmOUFZOWZJK0Rr?=
 =?utf-8?B?ci9VZGJBRmNmRnVhOVlsaTlnWU9RYjcvL2Q2TkZSZVgrYklZcUEvajRIWDUx?=
 =?utf-8?B?VUQzeWplM21FN3U3ZzUveUJWU3RZcUxyOVRlbE9nTTJ4Rk53V3lVWW1sR2Jl?=
 =?utf-8?B?M2JmdWNhQjhwZEF3SDZlay9KdUtNTTBlNzF4aGFaMFQ1WTZyT3lzU0Zsdndj?=
 =?utf-8?B?Z3hZb05SRFFublpYdzhxZEpiK29JSDJKMzF0dVgwTXFSVEtnZEFLRVhpTlBm?=
 =?utf-8?B?KzlpRXk0cVdVN0sraG1tTzM3RUJybW1BTFQ5dG11aTB4SWNFbW9mUC9WRzIz?=
 =?utf-8?B?d28xdjZNZm5RM0E4QVZBTFVUZkxIV09XMzd3ZnhWemw0RDdacThrekRUcmFu?=
 =?utf-8?B?Nys1K2hPL2ZqNFVlRDJZaVh1S3BwY3VKbWEzdWF3OUh0N1lUZVFWd3BpM0oz?=
 =?utf-8?B?dXliYktrQkRsS2kxSGd1ampsd1RWbkp2M1liSHppdlhFVUZTOFE1cGpLbFMx?=
 =?utf-8?B?Q3J6NXI4ckV4Y2ZQcDEzazRZYVhEYXVYVjlOQXRLRE11K1BQTlpFNlljUkw3?=
 =?utf-8?B?STYzM1NLWG5pS3k3V3ZOS296Ny93QlJzM0swZjA4ZXZFM29BVXlsL0hlT2ZV?=
 =?utf-8?B?NDIwV1pNNFRSUGcwUHFBb3FCcnhYb0hCS1FWNmwzTkVUWldmQ3VvQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e36bfe-cffb-43e7-7b61-08da4ab4f3bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 07:43:46.9886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y7ZnGxW+J9z2YKNBpc51iclpyBLpBClpZZg6fJ8a4NzzsUqOz+kaFYC8S9JhwCw6fiYMT9tjsuG09lsvQWxSPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEp1bmUgNywgMjAyMiA0OjI0IEFNDQo+IA0KPiBPbiBUdWUsIDIwMjItMDYtMDcgYXQgMDE6
MzIgKzA1MzAsIEtpcnRpIFdhbmtoZWRlIHdyb3RlOg0KPiA+DQo+ID4gT24gNi8yLzIwMjIgMTA6
NDkgUE0sIEVyaWMgRmFybWFuIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFzb24gR3VudGhvcnBlIDxq
Z2dAbnZpZGlhLmNvbT4NCj4gPiA+IEBAIC0xMDYsNiArMTA2LDcgQEAgc3RydWN0dXJlIHRvIHJl
cHJlc2VudCBhIG1lZGlhdGVkIGRldmljZSdzDQo+ID4gPiBkcml2ZXI6Og0KPiA+ID4gICAJICAg
ICBpbnQgICgqcHJvYmUpICAoc3RydWN0IG1kZXZfZGV2aWNlICpkZXYpOw0KPiA+ID4gICAJICAg
ICB2b2lkICgqcmVtb3ZlKSAoc3RydWN0IG1kZXZfZGV2aWNlICpkZXYpOw0KPiA+ID4gICAJICAg
ICBzdHJ1Y3QgZGV2aWNlX2RyaXZlciAgICBkcml2ZXI7DQo+ID4gPiArCSAgICAgdW5zaWduZWQg
aW50ICgqZ2V0X2F2YWlsYWJsZSkoc3RydWN0IG1kZXZfdHlwZSAqbXR5cGUpOw0KPiA+ID4gICAg
ICAgIH07DQo+ID4gPg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBjb25mbGljdHMgd2l0aCBDaHJpc3Rv
cGggSGVsbHdpZydzIHBhdGNoLiBJIHNlZQ0KPiA+ICdzdXBwb3J0ZWRfdHlwZV9ncm91cHMnIGlz
IG5vdCBpcyBhYm92ZSBzdHJ1Y3R1cmUsIEkgYmVsZWl2ZSB0aGF0DQo+ID4geW91cg0KPiA+IHBh
dGNoIGlzIGFwcGxpZWQgb24gdG9wIG9mIENocmlzdG9waCdzIHBhdGNoIHNlcmllcy4NCj4gPg0K
PiA+IGJ1dCB0aGVuIGluIGJlbG93IHBhcnQgb2YgY29kZSwgJ2FkZF9tZGV2X3N1cHBvcnRlZF90
eXBlJyBoYXMgYWxzbw0KPiA+IGJlaW5nDQo+ID4gcmVtb3ZlZCBpbiBDaHJpc3RvcGgncyBwYXRj
aC4gU28gdGhpcyBwYXRjaCB3b3VsZCBub3QgZ2V0IGFwcGxpZWQNCj4gPiBjbGVhbmx5Lg0KPiAN
Cj4gQXBvbG9naWVzLiBUaGlzIHNlcmllcyB3YXMgZml0IHRvIDUuMTggYXMgdGhlIG1lcmdlIHdp
bmRvdyBwcm9ncmVzc2VkLg0KPiBCb3RoIHRoaXMgcGF0Y2ggYW5kIHRoZSBwcmV2aW91cyBvbmUg
aGF2ZSB0byBhZGp1c3QgdG8gdGhlIHJlbW92YWwgb2YNCj4gbWRldl9wYXJlbnRfb3BzIHRoYXQg
Y2FtZSBhYm91dCBmcm9tDQo+IA0KPiBjb21taXQgNmI0MmY0OTFlMTdjZTEzZjVmZjdmMmQxZjQ5
YzczYTBmNGM0N2IyMA0KPiBBdXRob3I6IEphc29uIEd1bnRob3JwZSA8amdnQHppZXBlLmNhPg0K
PiBEYXRlOiAgIE1vbiBBcHIgMTEgMTY6MTQ6MDEgMjAyMiArMDIwMA0KPiANCj4gICAgIHZmaW8v
bWRldjogUmVtb3ZlIG1kZXZfcGFyZW50X29wcw0KPiANCj4gSSBoYXZlIHRoaXMgcmViYXNlZCBm
b3IgdjIuDQo+IA0KDQpidHcgd2l0aCB0aG9zZSBsYXRlc3QgY2hhbmdlcyBbMV0gd2UgZG9uJ3Qg
bmVlZCAuZ2V0X2F2YWlsYWJsZSgpIHRoZW4sDQphcyBtZGV2IHR5cGUgaXMgbm93IGFkZGVkIGJ5
IG1kZXYgZHJpdmVyIG9uZS1ieS1vbmUgdGhlbiB0aGUNCmF2YWlsYWJsZSBpbnN0YW5jZSBjYW4g
YmUgcHJvdmlkZWQgZGlyZWN0bHkgaW4gdGhhdCBwYXRoLg0KDQpbMV0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsLzIwMjIwNjA3MDU1NjUzLkdBODg0OEBsc3QuZGUvVC8jbTgyY2FhNDIzZDcy
OGJjZTA3MjliOGM5ZThkOGFmZjc2MjUwZWM5YWMNCg==
