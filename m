Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD73504C78
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 08:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbiDRGMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 02:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbiDRGMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 02:12:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC59D17AB7
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 23:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650262174; x=1681798174;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i1hBZ3dNlW6nACUsRP35GnUVk669+XD892u03+dcx+E=;
  b=mQ/0rvmhtL0LvZB6RA/y30PCTPL3oNAswRA3KzzCKqBWmydilc7edYcQ
   VGBkidfvKqLETPZTWTZZTXFhmuEWsHWf7PUbW/iGk2q2N9eE1uitvBf1X
   FD37KalTdGUVL3pJLAct9o6vN6JXyX58VTzcNw9EvZhtsMrbi9nDzpkKQ
   xslo2cn+VoDjYv6pIJD+/ISm4b8GzpKTKpWEarngAegqWI31Oehop8iBN
   pWbVs+fxWZEzJysJ4aTVWtn1S6ZeGn2LDZRsUYlmJBiOlbO7gfLICtCd3
   2jcpUBhmAJVwDz+ZKDXv1uUmBA+zsRFXlIldB/ppu4FrpEAj4/zJR7DlM
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="323901392"
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="323901392"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2022 23:09:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="664990964"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 17 Apr 2022 23:09:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Apr 2022 23:09:33 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Apr 2022 23:09:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 17 Apr 2022 23:09:33 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 17 Apr 2022 23:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExhLCsTp4dR0RrBbBlnwJg8y1MS+M5RAKR580Qe+LKt8YxKwo0UkrRttwr7C5Y9VKIddDFQ7G8FGTvn8xPySlv3VA2azX4Q9uzt9czgZktXOYruFuAKGZ4944wWEsL1GrqQWEpUImRxSuPy/ls8WqmW+oYe9hAQeAH/5Rp4OT/55xU3Yxb39c9VTx6EAOETXw9kZo73FKEw1VBbKqXZ+d11RedDPveoHitL8SCxWJ6lOTzO/zOW1xHzUEmy6dI5YDDV6qE8nCk0IfteURvM00FuBliahKUvva4HgNcpZiT4rVa66hCz5h8rNBuH/nyzya4lB42FGgtzHasm7e5P1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i1hBZ3dNlW6nACUsRP35GnUVk669+XD892u03+dcx+E=;
 b=MqLc4NqCU/aEPInGRRMx2k6jZEO7K8BNlVWGfELY61mJIQx274YGiPqiyyAarfjID1splazpw/B/4LAmQ1wKy/eOr+C5JVQ+SKVddFPZ3zSATzO9rXxW81BqN2DatRfUGl7sCCQD1CYg/T+4w7nTg/x9Xx/hQ+6F65lqTr6RHYMD0IxHFPIZQrpf2V7CgxGIeXUwOvVFwHO/hkwWmERc2NbdPzgzgKLd4pAa4AmPs5mShjYD5eCP+MeWx6/71o/g0zN1ZGWqwiKY1IAJsLX414j07DY5NsRwuK9a2zKZPMC1LDMfokBPsmC98oef+aszcWiv3hsr+5yITT6R+Jl0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR1101MB2346.namprd11.prod.outlook.com (2603:10b6:3:a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Mon, 18 Apr
 2022 06:09:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:09:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Christoph Hellwig" <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Topic: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Index: AQHYUC/7oxrMq/lk40i2DwOU5MPLw6zwX1UwgAEnfwCAACeJ8IAAFW2AgANM/2A=
Date:   Mon, 18 Apr 2022 06:09:30 +0000
Message-ID: <BN9PR11MB5276C1822152AA34717B7A578CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215604.GN2120790@nvidia.com>
 <BN9PR11MB5276894C5E020B8925BB6C238CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220416013415.GQ2120790@nvidia.com>
In-Reply-To: <20220416013415.GQ2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4fa94d6-4eb3-4217-488a-08da21020089
x-ms-traffictypediagnostic: DM5PR1101MB2346:EE_
x-microsoft-antispam-prvs: <DM5PR1101MB2346F08204712B9237EE0E948CF39@DM5PR1101MB2346.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6nk/ir9QiuyDKWsvbZko0DNb19ONpczS39iZFCOy6wV9mRGRgNB1HHJ8fPkGrbzfjppzR5NbqPs9RiOz4Kae9BfYSIVq6iYYcAdLdIjpX9HrIMI3IOOXkYXJrBeu7/HZZyukGDjQsaqPg/ENxPa7wyjhUBeRsasgRWxL1rCwUEnuyLw9hjsb3nO0W5JUg7Mhzk5Jje+O4/oQo7DfD8bWOzjyX60Gj1TjOLP8UfwJXDqVomml9odm3ccZo7sue7OhDuVq1CGRUtcgGxx5bHxCsVpwVWhMA7q/DDdwohhtrUjUhvjPve+WFsX8d8IIcoO+U9U36BnjB0ES2XNnH7sMHGz1MI/LRNibXO7oY5UTcFnnSuATxUlhMjmjuQcbPQcxV22MGhxrpqtqnj+JIHN5TpT24PLz+E0nzi+5Rr5kPZjdDwEDsGe6sAzUcxImIqKjoLf3cV9k397wTiYeUGPwvDT7qOuGDg8AwbJeXrV7+d/E8hmHqnQxda0gAICDAM3GUprqSU9ra/8Ay0SwqYyeMRx0YutClPCSs+HAeeLkKqFddligjnAyqY5byXjcqvJaHoasOcFfmf2Hi2JI3QK+CNgbYZwcClXDljEN9yVKWIm3xxizVi5v6KlBm7s4qO5kCl80on6dCYBoVN2ZGq5w+nSjmRcXA8uaHjWqZnAlKTIfZehrixdRn7kmgvzLI5vQhayUEKqMJzSs5B+oD0T8hQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(83380400001)(55016003)(9686003)(33656002)(76116006)(8676002)(66946007)(316002)(6506007)(66476007)(66556008)(186003)(64756008)(71200400001)(66446008)(26005)(86362001)(54906003)(5660300002)(6916009)(2906002)(508600001)(38100700002)(38070700005)(82960400001)(52536014)(8936002)(107886003)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nk1RyiCLc33+c1HECL3bnzqzs+lLxjM8NzPvHDKnXu3vkiy3/WGtfAKwlonN?=
 =?us-ascii?Q?q8c+J43njJS0voyDrl4fF3GDcBkN8UaGB8qczBad49W6O4xQpDMxXQuICeba?=
 =?us-ascii?Q?68aC3w0XMyko9LXW0ZbGyvoT3Vivu+pULELeXqX1jSrMIoJjjxvbeaGGI6E+?=
 =?us-ascii?Q?Xyupmth13Gga68T3wSc132Eix/adg7fBuNqIdHlvHTGKVWfyeV7bqHpuwxM6?=
 =?us-ascii?Q?p9wxzhHBI3Wa1O2v4bkud7Zq2qEVDU7dnxANNmE7TvAaSeQrzhp8OrS1eLbx?=
 =?us-ascii?Q?Xaja3UFOru4CHmmsucfkeskqr0Kuykdngp//2odkonl3irHJap9MGxyVSp9a?=
 =?us-ascii?Q?IPQG5k4qaZK3GwCjsgmD5+sDWS+SUOlPvirB/b8OZXSOYDv1RZ65l2UNxWLM?=
 =?us-ascii?Q?B6UCMUZt8p2rYtLnLJfWnm0Xd3FFkuU14wlFHrGHw7zywKhSlNRtfvf/RT+N?=
 =?us-ascii?Q?BvvITqQQrk7exSZjWwTnIuMjcfNVBomVc2eNgoHrmYpI6bveM+VcypbKAP1c?=
 =?us-ascii?Q?rjUUTULuwM9DDPdoo4jIDAT0VZ3UGYQAK9xarPcaqhymMT+KlQGw9wWgDoQ3?=
 =?us-ascii?Q?4b2z803Fsp5X7Mxs1V8unxpWwUa/nQWgp6NndKN5dJHXzkvoOgK8krJKsBNC?=
 =?us-ascii?Q?a7sKzt86vr5xmdhXkVVbtjsThZcDvVvPPCGs07XJPCua0BjdXaXqMm97REbD?=
 =?us-ascii?Q?UBgzpbIs3OxO+zMhWapUW/+Uo0IzI2iavFmkygP+eKob55ARLadwFNvSKsWd?=
 =?us-ascii?Q?pEQ0YzsBt7ESUBI9grQ6beDSEBN2Mu/WIof39lgAjrjTRGtM6AViaRfDBwP0?=
 =?us-ascii?Q?C8ajbMjOs0V/eWQOThv+FfY+7k0Hz0bniezwmQsnyOHLOiS6YEdMnogcDLmY?=
 =?us-ascii?Q?/aqcAUySfSDs5II3eyNKDUiQmq/fXthT8siRMkwQQ86uCaHgZ13kCizXecJj?=
 =?us-ascii?Q?IeLmwfqD5ZZM40CsZRVgnVtM6wZ9pBglP2Afz/08kgCcUHv+1qhgM2QxZFou?=
 =?us-ascii?Q?14JqCCDzl6UTWxQ0q+URqIOnpNuXfy5U3HnPLiDpSu01q1zTaVNuEgzK/KVt?=
 =?us-ascii?Q?gMgiocQuIOxVxTC7/smHoHID0IgJ+MWwEs7iQiaKZkMJf6sluP1/f9y2QxfN?=
 =?us-ascii?Q?I2EgwDnRHNwAf199hD71bvpfWMcFCxhXGXVO9aOeHgnB4nlA9cNIEB562OrX?=
 =?us-ascii?Q?5rdwWt3uOS5vcVeDP3y8JHFg2KH6e2aiYqKqE0xFvsmdIxHvA+78bJtMRS3L?=
 =?us-ascii?Q?xQYJ87WWjcJHMrOweSL1iZ8wYgMgVJ4iQafWOotbcxl9b5ZZzwBsQhGDILGV?=
 =?us-ascii?Q?RM9N0jSb76uvU7sgwwrKKhsCfxF+tuowz0e6PI31vJ3c47OX6T43hHS9mNO2?=
 =?us-ascii?Q?E+FvHLhPxC1//0ZRkhA27Gl5BtL+PTIqVVtBaLVB/cyu0uJrNdzf7BzA/BY3?=
 =?us-ascii?Q?E4r55WGwDulyYyKk+iwzM5SB3Deo1W8JuoFTlexEupgH3jdirVO5jhlxsqlv?=
 =?us-ascii?Q?dhfmgO8HhcOdEDdC3MjmWw9+eGgy9GXFLVtQlaUeDHEFa6YEDckSMte5waKl?=
 =?us-ascii?Q?JfagK+MTeZnER7tQKLDUeT2XhJ2GHnjY5DRqrMU1H/T7yG0FF7EVT2b/qcy9?=
 =?us-ascii?Q?czeGqwnOIxscWcG3AomwqeWPGv56/deENWf1hCOe1KfilyKhMvoN8KOcAqR9?=
 =?us-ascii?Q?kSnpTRG0RIgGu9wvkMBdX6Jr4lddiafmOoDqfd/3Ul/i7p7SbZL29FKijgoQ?=
 =?us-ascii?Q?Ke/ZPlToRw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fa94d6-4eb3-4217-488a-08da21020089
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 06:09:30.7901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePGls5oMKH7nM/LQb2WB33VA4klLf/vwKJKnlG/bCd2UGSLrSjpUcUj4XwxUHp3JSAud/NbnZU77ERiAL1IVlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2346
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, April 16, 2022 9:34 AM
>=20
> On Sat, Apr 16, 2022 at 12:42:50AM +0000, Tian, Kevin wrote:
>=20
> > Then what about PPC? w/o holding a reference to container is there
> > any impact on spapr_tce_table which is attached to the group?
> > I don't know the relationship between this table and vfio container
> > and whether there is a lifetime dependency in between.
>=20
> table seems to have its own FD so it should be refcounted
> independently and not indirectly rely on the vfio container. It seemed
> like there was enough protection there..
>=20

the table in PPC context refers to a window in the global iova address
space. From this angle the reference should be torn down when the
group is detached from the container which represents the address
space. But given the detach operation also prevents the user from
accessing the device, having the reference held by KVM for a while
until KVM_DEV_VFIO_GROUP_DEL is called is probably not harmful.

In any case this is also worth an explanation similar to what you
did for cache coherency.

Thanks
Kevin
