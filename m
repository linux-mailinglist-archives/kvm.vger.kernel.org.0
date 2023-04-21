Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69326EA29F
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 06:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjDUEKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 00:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUEKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 00:10:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A836C44A6
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 21:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682050244; x=1713586244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KBqm8UvVgsrhskLh+CDAnZy9Pp2Bu5mcfVJdb7XPQ3o=;
  b=jIcOc7CPF4o6Kn0X2D1kssdA4efTLTu/p0pFE/7VYftFWsqAg7205ajz
   nhrg9NGXWHNwcZJnE2NA//dcpXYO0wJgO+uh8Vl9ondmiMTw6iPK9vNCM
   Zlzxqe9RTLwPM6I5KepfXcfj02mGVxJkvPtEzfOSdWu+8MhspvXFobYpM
   o8CY09WP/K7fPQ1oK71EjrHVYhcZDbyHVhlhSKuk+igqs4onueuPGLBYN
   zLhaXTsZT9E/elTED4uobAGDHPOmN8bkqtBPiyX/M758GW0uPQ1tjNM8a
   9Qk/UdxckZzfmdALpqFgvQWf/eB0Ak3bNdeVl3zYqy4CJmsr9wqGr8rWv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343401235"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="343401235"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 21:10:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="694837210"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="694837210"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 20 Apr 2023 21:10:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 21:10:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 21:10:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 21:10:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 21:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoQV2wx59AiJGEJl/BZZEU5pGgEMkOvQjrqdsCpxNPD6pwA/hEaEZQUk+Jg9ajYMywujuqfmKhXW8AXKZllilnuVlbtYLgkCZ0o0dH6r9uhd/VRG53heH69Njv21sdjxgM8I834ryXovn/W6ScXKX+quvRAc7XWl9xnJbvH8+Lts6hAFspAigEktFsevfUQrUoQvsZAYa20D6isvVJjCoVaxAfhyDo0WnMXrBXPuR3OQVt1Qd1LQIh0u/7Nr4RFdOXvLHNolTJvalIWHZHURwkkO5RX5YBsNV7gdSKOH8OjAk+1dT/A8bT4M1Pyt6YNAwr2L/asEwehZfO9Q90p6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKLo1BYb+P1GLkH1AlWzMR8wsSbrUTZ3hhU4ZbVCPL0=;
 b=N/HeAvK9DdIIU9U9EFaUvNQByTVIPFW+6ProYmMbdw3w6KPsGq/OFD0CZE+rarqmqVWnSw6FoIlh2rhADoznV/Lhf7S2QHCiRM+Q43PPUR7oNpRfgv35RQu6n8nf3WfoN2HDWzezIfdh63r4DIVOEFSNoKF2d92LAC7UPu/NB+dKJHfLJBAEzaYJe613L2+sdpzghX9X9truJ3YKG69ihRiTL++6nJzj7vTZ9BUeK3oqblGy54OEXLNBlQ+3ptVcrK4KuiE+g3dowllPkc1MpnS6p2H67Apd+cxoi34FR2Qtbkkg9yNdqzR22VaGRMkNFkRB7zJRL672ejdsgTwX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7518.namprd11.prod.outlook.com (2603:10b6:a03:4c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 04:10:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 04:10:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: RMRR device on non-Intel platform
Thread-Topic: RMRR device on non-Intel platform
Thread-Index: AdlzU1l2SINtdgKASzuG/OHqnI4zdAAPzvCAAAAmJYAAAQTsAAAEaOkAAApGNYAADQGI8A==
Date:   Fri, 21 Apr 2023 04:10:41 +0000
Message-ID: <BN9PR11MB52760FCB2D35D08723BE3F2A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230420081539.6bf301ad.alex.williamson@redhat.com>
        <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
        <20230420084906.2e4cce42.alex.williamson@redhat.com>
        <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
In-Reply-To: <20230420154933.1a79de4e.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7518:EE_
x-ms-office365-filtering-correlation-id: cd4c2d2b-120c-4f87-5beb-08db421e5ed7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5rt0rA1tz5rjDW3j9hc3yaeC0U3aE/RTH9b19AjDNznZGtpRV2F1mKmL7gBcXhJqpfA+66CCETSJplte4wmWBTIb4Uu7aCRwShorUNRgE9DCZylzvXkUHc8Y36pGCa4GuwoJhu/pMdkabWCA7Bk6cAXZSZvCBvY35AjON2hr+c9QvIvWNgx0mr2KSACT/Wuc2c7QfoszZ4w0PenBPvyGBJQwuCasy4/aHt8U0AFrREARhe+iEDmPsNH8L7DMf+K7u5cikAUW2BeUnjhYkHZKs6KVYtvnIQTmamabZGOjgPFCg5hTIRRiksXHVGi3grLhuQviOdb4dAMJc+/2GGX3WrxeVZOmwsDacalBBwQCjfI+NHti2ht2xAkYyvSZIkcDhNbEHd6iL4WmXW1XM3+9opMclBJON4HUkNu6F8zJhFY6ND5fFvWBTJ1iNtNto+5FCyMDX7Jd16UYt5cyG6fYiycJNu24sbOYz5isllw2H8nY0W6AQPnlwmNpIY474tsEE7pNUjqDzwvecGuEME1H0YTeWmcH3eMZeNUEL2PbOmeExutuaypGXui/dLIcHcwqFdgVJ52GCphJwvxeVEx3EZqyL3FPbSQLYWxmmqiLF2hkw8SObodiAbxoP9UW6M5V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199021)(4326008)(9686003)(53546011)(64756008)(8676002)(8936002)(86362001)(38070700005)(41300700001)(66476007)(316002)(76116006)(52536014)(5660300002)(66946007)(66446008)(66556008)(26005)(54906003)(110136005)(122000001)(38100700002)(2906002)(55016003)(33656002)(71200400001)(7696005)(82960400001)(478600001)(107886003)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IzZncSO7wRLqE34lXiYs015btaN447AhljhB6TFpG4HDaSE0KXLjCxFmrCO9?=
 =?us-ascii?Q?hYUIkF0qKabuOXTCyX1TB7Vz/sramYnVqsQNkUTmQa9Ib+4C2E1h1iOB0JnM?=
 =?us-ascii?Q?tGny4eyQhz3HYeIIlHbCQfKdugyZ6HJv9TxY6gQRRHxF+XLixjIS2jY3W3fz?=
 =?us-ascii?Q?X+aduQ7BwXeAJQksFScgG/jTtnVrrth/XzXjK+9srxvHHmhAir6mj2szP6D0?=
 =?us-ascii?Q?Z66TqwCHsEOA2kAxYegy2L1Fa9K7H4bvWlvRgy6Ek9ZRsMx+mPyD86B1U4Yh?=
 =?us-ascii?Q?N4kpCldSPKM7CDIv2Nsd/VxC8n0r2TUjG/UcCrsnrT3NWN6Dbyi8+aDGvhjZ?=
 =?us-ascii?Q?aD1YiKoKIiZw43zL68KHxGO6f5T1UVIVsJ4Q4ic30MkU3OQVfyr+RSNQtL7a?=
 =?us-ascii?Q?5RlUYpQ9g6IxwR46v1eutxzBCBHQ5+QaDr7Hf7ziuYuWCtz38HUJrnV5QABr?=
 =?us-ascii?Q?LxuHx2kEwbhXp1uDFs4cL4Qyrp32BunicQUArx39q1pDqeLIaPqiT7o1OHLO?=
 =?us-ascii?Q?UuwMeet3jlsYdLAjoUTaHQ20ooRgSIlaVF1rVfPtyo78Po6FzqZJEJzojHFZ?=
 =?us-ascii?Q?pddiXVNAALOIvBNJhY/9ixrlH2Z5WGYWfOCfGW3YT1zs4LmeVq9tC02UWEIq?=
 =?us-ascii?Q?ATcZ+tpSMWfXolytqCaTkBlEAmuigMvNW5sI7kLrqgmhwp1Rws2eEC93ZSii?=
 =?us-ascii?Q?j1QtkRN/Nx9OP+Zn56b764nmdAjJ+myUXVLwJ4Es2bDbskKrb+UyaMdvswBi?=
 =?us-ascii?Q?vuwaXMfAudq4Exc86BwZd8FMiQGifv4QMHqH4lRRI+4ZUVNw859QblrwGrIs?=
 =?us-ascii?Q?fKUPsKoOEIf+FQxmTmrEenHpQCiPJ56qXXMcI+APEKFHSN18XWLZH8gu8/Xi?=
 =?us-ascii?Q?cP4dxK6k49w+C+yqRpUsY5IW+Ne/1R7KhAFuBxRzGsX/1f+VX2r/pEZ6zpIH?=
 =?us-ascii?Q?HHtOPMJMK+E2gePnB0iuXa7HXQ9msedYrWdvFqW8rEkSBprLCeSXOl9v6xmI?=
 =?us-ascii?Q?XO/dmUl7u21pYPDUeoryQyPPwiVZW4nvLCUr3HavWR/GgJ+biCcL9oS85dw1?=
 =?us-ascii?Q?QQibOZkvrKTbEQX6EARiRM+F5IaiL6mICyUH42F7p3taU9PFVnVi5tLn5KXp?=
 =?us-ascii?Q?8bxu1Ujcg3a4pwO8ryORw9PL3MeW9ukCBcBIPZibkyXYWUsRZfZbRK3x28fw?=
 =?us-ascii?Q?fiuNpiO/364OhQ7r2z1PjDVmskOogThUeSkQIKnWjYxGtxww6LAdserUITQT?=
 =?us-ascii?Q?fOTLk/jK5YPkFji2EJZv3uJJ3OzTdugklL8LY9b0t2bolzwP8aKK5y9zlfAI?=
 =?us-ascii?Q?AA114A/O2IBeL1UpmXHo95DHXNYYDgCDkkz3JcYInC9niGudqP/2xEjCPP6D?=
 =?us-ascii?Q?KtTLOuJeZfqSG17ykDTa24TprnHI6Av3RB3xE0w+ZO4FD7UU2rXNPoYW2lOP?=
 =?us-ascii?Q?ODJuO65ardvkjLkA6D/r6ujy1fTng5o4gntSZcFgljXGypDxLmzTGK+d/FR3?=
 =?us-ascii?Q?m8KqNd5dKLFCTTb2e4+1J+74/ljWUWwscRtp6K9WFJrBwlOSWQ42PtNK1Vs9?=
 =?us-ascii?Q?O4kG/vI81kBLuSvP7WgzNDChaAM/Ohng4gSOWYcE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4c2d2b-120c-4f87-5beb-08db421e5ed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 04:10:41.0447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxHrfLR4ObTed6xTX83+V6apWY0dQWlFCLe68rfAkgno67ss6n3QkOIXQyKgLlk3siMb060B4Nw6xsQO9t/bmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7518
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, April 21, 2023 5:50 AM
>=20
> On Thu, 20 Apr 2023 17:55:22 +0100
> Robin Murphy <robin.murphy@arm.com> wrote:
>=20
> > On 20/04/2023 3:49 pm, Alex Williamson wrote:
> > > On Thu, 20 Apr 2023 15:19:55 +0100
> > > Robin Murphy <robin.murphy@arm.com> wrote:
> > >
> > >> On 2023-04-20 15:15, Alex Williamson wrote:
> > >>> On Thu, 20 Apr 2023 06:52:01 +0000
> > >>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > >>>
> > >>>> Hi, Alex,
> > >>>>
> > >>>> Happen to see that we may have inconsistent policy about RMRR
> devices cross
> > >>>> different vendors.
> > >>>>
> > >>>> Previously only Intel supports RMRR. Now both AMD/ARM have
> similar thing,
> > >>>> AMD IVMD and ARM RMR.
> > >>>
> > >>> Any similar requirement imposed by system firmware that the
> operating
> > >>> system must perpetually maintain a specific IOVA mapping for the
> device
> > >>> should impose similar restrictions as we've implemented for VT-d
> > >>> RMMR[1].  Thanks,
> > >>
> > >> Hmm, does that mean that vfio_iommu_resv_exclude() going to the
> trouble
> > >> of punching out all the reserved region holes isn't really needed?
> > >
> > > While "Reserved Memory Region Reporting", might suggest that the
> ranges
> > > are simply excluded, RMRR actually require that specific mappings are
> > > maintained for ongoing, side-band activity, which is not compatible
> > > with the ideas that userspace owns the IOVA address space for the
> > > device or separation of host vs userspace control of the device.  Suc=
h
> > > mappings suggest things like system health monitoring where the
> > > influence of a user-owned device can easily extend to a system-wide
> > > scope if the user it able to manipulate the device to deny that
> > > interaction or report bad data.
> > >
> > > If these ARM and AMD tables impose similar requirements, we should
> > > really be restricting devices encumbered by such requirements from
> > > userspace access as well.  Thanks,
> >
> > Indeed the primary use-case behind Arm's RMRs was certain devices like
> > big complex RAID controllers which have already been started by UEFI
> > firmware at boot and have live in-memory data which needs to be
> preserved.
> >
> > However, my point was more that if it's a VFIO policy that any device
> > with an IOMMU_RESV_DIRECT reservation is not suitable for userspace
> > assignment, then vfio_iommu_type1_attach_group() already has
> everything
> > it would need to robustly enforce that policy itself. It seems silly to
> > me for it to expect the IOMMU driver to fail the attach, then go ahead
> > and dutifully punch out direct regions if it happened not to. A couple
> > of obvious trivial tweaks and there could be no dependency on driver
> > behaviour at all, other than correctly reporting resv_regions to begin =
with.
> >
> > If we think this policy deserves to go beyond VFIO and userspace, and
> > it's reasonable that such devices should never be allowed to attach to
> > any other kind of kernel-owned unmanaged domain either, then we can
> > still trivially enforce that in core IOMMU code. I really see no need
> > for it to be in drivers at all.
>=20
> It seems like a reasonable choice to me that any mixing of unmanaged
> domains with IOMMU_RESV_DIRECT could be restricted globally.  Do we
> even have infrastructure for a driver to honor the necessary mapping
> requirements?
>=20
> It looks pretty easy to do as well, something like this (untested):
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 10db680acaed..521f9a731ce9 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2012,11 +2012,29 @@ static void
> __iommu_group_set_core_domain(struct iommu_group *group)
>  static int __iommu_attach_device(struct iommu_domain *domain,
>  				 struct device *dev)
>  {
> -	int ret;
> +	int ret =3D 0;
>=20
>  	if (unlikely(domain->ops->attach_dev =3D=3D NULL))
>  		return -ENODEV;
>=20
> +	if (domain->type =3D=3D IOMMU_DOMAIN_UNMANAGED) {
> +		struct iommu_resv_region *region;
> +		LIST_HEAD(resv_regions);
> +
> +		iommu_get_resv_regions(dev, &resv_regions);
> +		list_for_each_entry(region, &resv_regions, list) {
> +			if (region->type =3D=3D IOMMU_RESV_DIRECT) {
> +				ret =3D -EPERM;
> +				break;
> +			}
> +		}
> +		iommu_put_resv_regions(dev, &resv_regions);
> +		if (ret) {
> +			dev_warn(dev, "Device may not be used with an
> unmanaged IOMMU domain due to reserved direct mapping
> requirement.\n");
> +			return ret;
> +		}
> +	}
> +
>  	ret =3D domain->ops->attach_dev(domain, dev);
>  	if (ret)
>  		return ret;
>=20
> Restrictions in either type1 or iommufd would be pretty trivial as well,
> but centralizing it in core IOMMU code would do a better job of covering
> all use cases.
>=20
> This effectively makes the VT-d code further down the same path
> redundant, so no new restrictions there.
>=20
> What sort of fall-out should we expect on ARM or AMD?  This was a pretty
> painful restriction to add on Intel.  Thanks,
>=20

What about device_rmrr_is_relaxable()? Leave it in specific driver or
consolidate to be generic?

intel-iommu sets RELAXABLE for USB and GPU assuming their RMRR region
is not used post boot.

Presumably same policy can be applied to AMD too.

ARM RMR reports an explicit flag (ACPI_IORT_RMR_REMAP_PERMITTED) to
mark out whether a RMR region is relaxable. I'm not sure whether USB/GPU
is already covered.
