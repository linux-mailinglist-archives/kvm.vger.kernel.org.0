Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF263A260
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 08:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiK1H5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 02:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiK1H5c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 02:57:32 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A520CA46B
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 23:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669622249; x=1701158249;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jI+JuA1vapxy87qP8hi/W72nD00XOo+jUujd0IoCwcQ=;
  b=X9r/90clwm6v73jFc+zp09KbdljdHo3ONJZBqTH6IB2hLpfikzhywBki
   iK5mUxvR9u1LORA8zdNC9GHdvsOpvypGdoAczlNocSTKGxVWjL4/VlIlp
   XM6icXosEHOyZk9cDNzJUwrraPEINlK0ii71YHVFsn3q1EXQ4cKdJ0ef4
   0kgK2bNlL4t14XD8QopjhsU5N5CYkvWMkTSLutU0R+tO8Y9SbRpiIYP17
   qW8vPuZyBYLFIXNPKTyDxE/PjmbyKgTR3plnrilzwc9ndVJ9wXhzWPXWx
   LkqRCvk0VS+aIetfPfWk5MJKc6gB4FO/M+UYcQbTdKJI5F1cLp+62eXH2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="302348290"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="302348290"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 23:57:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="620956094"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="620956094"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 27 Nov 2022 23:57:28 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 27 Nov 2022 23:57:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 27 Nov 2022 23:57:28 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 27 Nov 2022 23:57:28 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 27 Nov 2022 23:57:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQIeC3ekXLP0eVrCKodd0s778R5L61Rk2WZZ5ANO/m+z+0nrsR8rI+6LRf8MkkIf6loPTM2f+tRcwJDsMYaf2uCcHhPCyIkkzKOClMgyBwMAO2DropRUA4fMHJUUfPC+nIbB+bPYcENmv5uY9pMYtbmizRBiL037nHwMmujwNH8CkuEA9Ya1wTZ83qW0An5DNVv3Ta/8qwk+XPpAfJ9kV1joZt8ziWfGe6lmyus2PALyfKEz5DcDzUYy90LAap18W40us6lNnlX78kgygY48tE+tNU+RhHxIAmWPbbeVleio0/IlO7clFxlqjCQXp04VKWSDQr8lJlogphYhLzAcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jI+JuA1vapxy87qP8hi/W72nD00XOo+jUujd0IoCwcQ=;
 b=BpKV/WL51GJriisgq0/EYx2ZZuyFHEkgpIlXXjs3qidtZQetdvtBJ0vibacqyar4IWxOtAe+2m/zsFM4N3+l1/1qlj44/yLZ629gcjf1lkn9LcJnt0argZusw8/15/+DP65JCNASk/ESNJtP21PvPwaDEsR80zHEzx69ZABlrU/lYnLNJWSHV6cFs/a0OZ0ghqRl0O3rE6fD3CTsfe0EO/MCQiUw8I4W2IuA6h1/0xaN2TXYCYQf4H22F8c6cmCcNxDjTgeZ5u1b49OqklyGHojvpwBWhSsuO4SBcvL1v4j1VdDoauuE8imb0gHQEzJHiueKzfclFKBVqYwoeyBcFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5548.namprd11.prod.outlook.com (2603:10b6:408:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 07:57:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 07:57:21 +0000
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
Subject: RE: [RFC v2 01/11] vfio: Simplify vfio_create_group()
Thread-Topic: [RFC v2 01/11] vfio: Simplify vfio_create_group()
Thread-Index: AQHZAAAcUiOA5I3r4kKuAcA/IuUWka5T/K+w
Date:   Mon, 28 Nov 2022 07:57:21 +0000
Message-ID: <BN9PR11MB5276A61FA21759A3F140293B8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-2-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5548:EE_
x-ms-office365-filtering-correlation-id: 5ce883e7-9962-40d3-829e-08dad1162da3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PuDpnrlgMYTNkiLN3WEAbeAf6BpIzEdAgvJU6Z+g7aZv2y8UVlTL+U34OWAATw72DZe0/Vn64UBe8APUndyJ71FFJKVmvn+0x8c70ZSTGe0ahITO5/wVTpIP2u8nSprAEhpRdftjnzfTtECXIXpM35booHa++oyYNPcKcfQgKpiGOijtL3CZb1HLMjDWrf3TY5MzZJsSNvQaBzpOe1vSlsNW5YqXbs79YgqhdDlCGsyMqUOdj38RQ6sfcGrvqllpPFAfI4kGS5QS+7EhphhRPaZFQY02bNJMofpzHLq5XuHvlGYYhrfXx8GBcnMer22C5Ujah1bVK38Kn1Fwr5Bs11XSY3GkYHsN/7kIn2V8CK+4D8OzclejHOYQgUK5LoSisv1OeFgf0qaUckI/tMOtpZwAYs9IEoR2OHlTtsutwl5KnssO/ZC8LlBU/UykAUAHlp+iTWOpU4Oj6SHXr93+MVXNSpsmYAXE4sOEzxrb/mxx5cjKBL8OTRL5pruIG+G18ZB1/cFUX5SPn48h2XpZZF6DkSVKlpJiwDsSJ7V1nNtIglbXWY4AWgdLfEGZmdgwUevVtlaCX6nff9fNQzyE8LTp+PAzmJmwl9QbA3Ie1Z1rwnGnto52udNVLTHN2SBvb3goIEdtLqSCbCg2x+IrcZjL4xBKPZpRzW+VbCrC6anc1pbZeJhZ77KtwI6MuaSwpHTyx8nPb++OuG1wAqL/5gVr9c5nXbr6PMZ2U0gvuuM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199015)(2906002)(4744005)(186003)(41300700001)(54906003)(66476007)(4326008)(66446008)(8676002)(66556008)(66946007)(64756008)(316002)(110136005)(52536014)(8936002)(76116006)(71200400001)(33656002)(5660300002)(9686003)(26005)(86362001)(478600001)(966005)(7696005)(6506007)(83380400001)(38100700002)(55016003)(122000001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pe7tIoCMAhrs8oLhM5V+Xt+oPk92ulT7weWIZ2lTl4LIrD3sEXuMuonSr83p?=
 =?us-ascii?Q?QgYGG2esubdLD69c7iUxqk3guTIKnj0pFwI8xXrpl4T/cB2iTz18l7CljcMl?=
 =?us-ascii?Q?vknRSqBMc40xSaN1g1MbLvk9Zqb8pswceAQsbcCl0BFiO36ndVmaUbmRb+Qd?=
 =?us-ascii?Q?/ncdktdmhxuH1MWtuaZZS5Qqy9AwrsFy5rUxn7guw2WyVeoi6205ihv13U13?=
 =?us-ascii?Q?W2YUEEFMMiXXpZAZf+ftSTno2LrOuHgapgxwKsTjgaVUXpa+MRVDaslF4IPu?=
 =?us-ascii?Q?NXcIU+tbg+UvX0IuPa+hRPL4tHb+42/l8VbXOZWqZ3SUpHbQ9pMC7qvvXcNR?=
 =?us-ascii?Q?LLAchrPbprcms2JKEEHasWtGBCicbRVLbIq4sv456VkJKQwiZUii5luEmA1n?=
 =?us-ascii?Q?SQyeG6aHWacHngwPmCt36maR9GSlvFx1FiQB+QmcO9TROMvIHcHxcRa47SYT?=
 =?us-ascii?Q?3hW9U3tlmLhuZ2wJClyQWnVcrSEoRc4WG3aoqdb2m2ZvLlwUl9tP23GN3luZ?=
 =?us-ascii?Q?GO6VEJF4wBGawV/XGoUISneqSr8ipaHNoIdwUUUKU6tKLlGbEIHmvWEelFAK?=
 =?us-ascii?Q?w9+6H5xXfnCtvXKew3YicpFKC30ChwhZZsfP901zMTrJY+ZH15TCJxm9dYtI?=
 =?us-ascii?Q?Y1OSZETv4dBtoHBIIJoN64oiBFdK/OyuMWgwOkQjbVV3CX/HgVhhUH39M6BH?=
 =?us-ascii?Q?MicRTXLe/GR/Ld0GpAksqfbWA+M8Dk7TBNaikIsbftckgvhbeutbT3fJu0rh?=
 =?us-ascii?Q?QuCSzViaHhKO/RnlxWMZOIcD7Noap7z93VMzFvbOztfcnPdcCoRUCOQEUcTm?=
 =?us-ascii?Q?jlLpiXDXI3VML7TW64FR5kH6y6W1ZQgUdEGQ3es+LRv25oBZ/qwoIKQespD1?=
 =?us-ascii?Q?s4k/jh8KdjgMBjMLR6Qpafosy5uraJYJw3B4PEjZaR6lpmDxX63Bdn3Hu2Gn?=
 =?us-ascii?Q?yeSVhXFB5imwYiovcUJ/iLdHzflGEg4W+adQxA36cTnrQqyyJvsFnHSVnvrG?=
 =?us-ascii?Q?65lgM86nts5Nq+v/Zt0V60x+N6ZdMUc5pCyQGYVkUU56rFbsuuahQ/e2ZF2E?=
 =?us-ascii?Q?Vp1H+Z0RYcuWy5DDlzLC1HR1e5+cOzcPeJ1jvw1e3BwKBIUbvlnbk/Opy8am?=
 =?us-ascii?Q?rKf0D6B5ViA0x6lOpOoIz7wriwr/h9Pft/Kjr810Nywk4Q9DDns9+GxAlUIN?=
 =?us-ascii?Q?X/JboO4oafPT+n6Q+eqetqgFio2/FPksl6F+9+Yy7xD9ZKap/shMLQeGbjY+?=
 =?us-ascii?Q?tWAwE9PfwUM9A5xJgZQUvL74ylUfyyM2uPE22UTIrZJDI6ibO/5AAF1KMZ4j?=
 =?us-ascii?Q?gd1YcIwMKbz3Yvf51AH2yh6aHUMtw0qw5ABW7pI7kqLH7JnUH2/yawzw/Pbh?=
 =?us-ascii?Q?al5LRbWHa7SowbBUZeqvNxJUL4MkbdRDkw05Qf83s00S/8oHVBhu7gXGfki9?=
 =?us-ascii?Q?cDTM93Z3F0EH4NqMk8QhfJibrhP7VDk+Rtk6m92Rf83yvMA2eW29w0LmXmBc?=
 =?us-ascii?Q?S9h6MjpbDyQw7w/8+lZGHBTPVsN2muUq45T5HtaQQAQ6L6/ooSODsP/3wmdx?=
 =?us-ascii?Q?7Jl7zVeYC1fcOEd8gROjpE1Z3+nLeTtw6/gZwOiT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce883e7-9962-40d3-829e-08dad1162da3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 07:57:21.1366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PArbeUmlKQCSzkVtbh7gxczaH62JweKN4Opyn3/lrHBVPIZlIOWNgzCy0rWABckFMU0APWzJMOvzd7WMouaMVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5548
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> The vfio.group_lock is now only used to serialize vfio_group creation
> and destruction, we don't need a micro-optimization of searching,
> unlocking, then allocating and searching again. Just hold the lock
> the whole time.
>=20
> Grabbed from:
> https://lore.kernel.org/kvm/20220922152338.2a2238fe.alex.williamson@red
> hat.com/
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
