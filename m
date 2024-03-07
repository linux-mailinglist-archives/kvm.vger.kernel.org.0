Return-Path: <kvm+bounces-11280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C1F874A37
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 09:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D2B61F229F1
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 08:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9141B82D8F;
	Thu,  7 Mar 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AZbcXjC9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969D82D79;
	Thu,  7 Mar 2024 08:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709801911; cv=fail; b=PhwDGGwqaxrTG57l/RpLOnEbfr/rSvvc8ooCgENOK7P+xjdSuchYMscj/i4+EurPiJExGzeA3q3oImnvNeL8XpFPMXy+aV/MVaWNY28lCuLm8+6MhBctoP1tVSeKM+U+q7DjODdXZct5hbUDIT+J5R3UkOE8xBDK+tk2FHR9PoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709801911; c=relaxed/simple;
	bh=CSCP2R7pKfOd9HzLLeQeuLUdzjwXyonVd+7la9/luYQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ev4OGYLOVwWKsSBec0VgPp+mmOg/CMDhdKtWY1c7VRc1SzAhvxUfw2bzNUeAWG702yef5DKus5GywA03lbOGJKDCSKMiQJ7I2dNVPEV2fMv/fj039RBGZ9XYy3TdBdwuBywrcgzY+POpGIA06FGH/4SFV0JvFbmSJ9Rq8DIAOCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AZbcXjC9; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709801910; x=1741337910;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CSCP2R7pKfOd9HzLLeQeuLUdzjwXyonVd+7la9/luYQ=;
  b=AZbcXjC98qcnNl5S6+Q53UraESC08I/GqVKRHt+xPMHoVGTefbWWhUVp
   FIS2LRg+AM2e8Mr2zoBYrVO3X1R/IMRIP3YHE4S6MLUszQ1YG0SrW7lBz
   iicLqvxFj5sZXfVy2BK8U6Ti1e219yPHmsS7JhfKr3QRVMIQiK9Qjl7Fb
   zk79jG261fn0kLL62aSZxAmEmS2a1Qc3TrSghtSolgzeouc0sG+mppa+s
   t3w0ozIwgRrg9YEIaGorzDXar7HZ96ImWT32UPDioq4ETBkAZUxx/KGp3
   q1zQ0VLCfvarO7FO3H8u3tjGIoE3uDoE/ssKZoUlCCXTavzZNo0vBYoDs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="21909594"
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="21909594"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 00:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,211,1705392000"; 
   d="scan'208";a="10203967"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 00:58:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:58:28 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 00:58:28 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 00:58:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 00:58:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1+XeZkjNcPvcqlDPs5M3t/fzQoXjSfxI/2upYgKLiFz+ffS6DEhXsydG92/VN237LGwmDhTE696GQiIN6d9WHDlumOKfCuhEtyw6CZY6wzfxnFVZqkDcFxF0GsXGYah+w/dnBJh88NBjWK6soBXosFvWARp0qijcSxZBc7Yne38H4wDdlP7Ul/uNppBROWwZbm5qpDOOEA+7VhesknxoRrjHtqEDCkuVq6DbA2WpHsfOZX7eScXFpqQLLKR3ZgNY6RTsD2BzUdBy4uYhyVGVaqoKKYVLe+C6knjEcUDbOnj0pAbRnXsrGckRUgIUMdfE51KDEmaU3E/15NbUXi/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bsfben6k1ZpUhLDGcgs1DdQ8RNd96WRrcGsaW437/Vk=;
 b=lI0RTSc+j9GY1fg7paSMgny/MLZS0uuSRugvF+fYHq9onHZFSUW8kX90Y7zfAyjfB9lcDEHez7CqPG8nQhsSsSa7qiJWpfHlkQTeclg5cDUfCTUGbZLg5lN9auxgiU3eA2hWSaBJZjIoFbm4QQjxJzJrFDsvGGKmwSAGFLvg32bKXCDVo3MXuqSpsk8As8hixJoTlC3ThIfFwkFICCiy2/tmpk7VSWOPnLh4oHFfqRFmyRzYgFGT/YdeJpRFAi1km+WNzW2uFk9+nM9j63KcisJ63yQ1L15t8y2Hafo2aPrJ+9qpqpkCZRGwb0ujqiv4DNqzdExOZPnUOTziZO22Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM4PR11MB6189.namprd11.prod.outlook.com (2603:10b6:8:ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Thu, 7 Mar
 2024 08:58:26 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::ca67:e14d:c39b:5c01%4]) with mapi id 15.20.7386.006; Thu, 7 Mar 2024
 08:58:25 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/7] vfio: Introduce interface to flush virqfd inject
 workqueue
Thread-Topic: [PATCH 3/7] vfio: Introduce interface to flush virqfd inject
 workqueue
Thread-Index: AQHacAtgWadzXuU4iEWS5e6dDSVtWbEr+w0A
Date: Thu, 7 Mar 2024 08:58:25 +0000
Message-ID: <BL1PR11MB5271D127336AFCE2F79F64AC8C202@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-4-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-4-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DM4PR11MB6189:EE_
x-ms-office365-filtering-correlation-id: ef417eec-04d0-4416-ae83-08dc3e84c003
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PAY/ognY+0SU1uXdfNoLt7omduvkTCwaRuLd3b4Gwn70/ukxHfEs1vmuhxulMM/GRxl6Rv87aBAjRGDbvZxNFm+tuwhHutdkn2wRdYKo5fJaaMKR20bE3Ed+28taxTw3PMA7YC3/+Z1VDL7ueYqsX1/Ez0mzb8329rmoFDWX78FrhUfmh68t4OB8iqb+Ov9BZE4p3h313SWyiE6RWJ6WrM8NtXoe7q4eehaGCe6lEtvzGTaNL+TCTDsBHEn+j2CvqFpBuKkcOFv4EYNGM2n4WrsHcKgF+ARc3hgIuhvAgEjQuXBYVq76407taDj6HYXvAuWU/vYoXRMgGNSspr8joB1Tq1Gmsd3GE6dvcsKSjv5Jyq5Z2AZp8uOMxaacCRRR7FFNK4Ic/iuh/KB1hJ9tf19uTNITDONywxUOZxy4nCM/ViWcQzpLTiBRb+dqAtPTyUDQQghWuUg82b6SYP8SZk1yPFEEIACYxGlqQ/zfdQa8dqaO/YEgZy4GUZefJ7CjBd9+AL+tEN9WgsSXQ1Qab1T78AYVr7dq8kT17TwBypNZsnFk5SohS6XtAe1aAavStQDkyOwQtrjXi9sVG4iKzxX7eq4M10VTOrKjD6fcCeAxaTirLos1i6ZMY2eq5CCYQjxvdjnJ4kT44JJAd2hPZ5yl4lddNFocccXBzglEg3OeaScbI4rwuOlFs7Bqz2GB0gFj/qwpMltJQrfZeDlT8107dAu3BhF4FeSvfgX26bE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xLUVw6B9zy0962LObLBd1Lg80mRCZegAvHTVrQmCPiVJML2Vg7OEinPGIhXX?=
 =?us-ascii?Q?W76Xn+oijnRZJkc5AqLyHllCx1N4+sUkoLkqfBMeuD+G3dWovEfy7CsalS25?=
 =?us-ascii?Q?UFnjUCHgG86lclkwDUDYmZmFbDNSUewOEXSsVdmgJpEXShh4O8F45D2OqGx5?=
 =?us-ascii?Q?fqa/XnE8/ru4ZrSI7bgPqJS1/S0KnFbTjs3D00PrjEh/OxVCl43aQDjzk99S?=
 =?us-ascii?Q?Cn7hg2wELX634C4ugnlFgTxXGAEkgD1aqJOvTgQ2mEyd6spMNAutPsSG392q?=
 =?us-ascii?Q?py2/Vf0laQ9x7MfMak1jXuO23EdcCtGYwxMjbsGptiJfF2f9pVP7JilxB9n+?=
 =?us-ascii?Q?+N/P/mVIhJVulyFFGOs5vpipRgDreXUPdSd/4Y38KJ1XfFHmlkOODVRoa8hV?=
 =?us-ascii?Q?zLacO3fGhwHnpeheQibK9gGb92Htn/K4eNXT5MdyWZsYhMu/4gkUaahq0IJg?=
 =?us-ascii?Q?4vFCv2u2IfREcmheuGUKynrvNKtCtca9cgDiYyhG9XtnoPKJ7PkRGwWdyjdk?=
 =?us-ascii?Q?M1BvKsBmQC/P9ywTfcsQkwgI0ed+bvEWm01wRehKXeyb3OTLjDMI0m0H2sDL?=
 =?us-ascii?Q?U8KhVhB8BgfuOO2YF8aJLeYNV7y/RO+S9iFISYDj72KrRlsT9yDNpy8RZgAH?=
 =?us-ascii?Q?eVi5C7qAMTile3Gt5NPP6siqjlC75OrmwgK6igyfP4G9W6HlFh7qNIDXyInH?=
 =?us-ascii?Q?efQo35o2808RHn16s4flLe+mplLrEZ/MYZFavbdYhPVvkpEMfjnqPg4kgAgn?=
 =?us-ascii?Q?9nNoCoPV0NJNrbbJnt6CtlsW0xmqT45wlrXKY4UZMjcRlAdjHDYmPpsjt6O+?=
 =?us-ascii?Q?2YfolUZHXoNhPhgJDJyVvi9eV90wIZuUy9KOrU3qgoWCRxkZW4mN3rZQBW9p?=
 =?us-ascii?Q?MONb0TqXo1lFsHAe0o6HWRxCLAe/kXpFQr0s8xm9eFpzlvga4hqhVxP/gZnA?=
 =?us-ascii?Q?Rjh3tlf4a2BNT7uBgqn5uvNzzipyo6M7YPASQ6aYJADzxZKHVijOKAPRGyu0?=
 =?us-ascii?Q?heIBud69LB7v7GvsxVHVJXJ+D4iWUUKsDwWti+jYDZr7FiXNzzZTlbZywWDY?=
 =?us-ascii?Q?AS33SWkAJDbaNqRCT0l9+7NsHixWYZgPqyPxwiFKY0pvItjGBzz3tarmbtCa?=
 =?us-ascii?Q?921QggANR2nSJUsAeGBBRAhoPNsuRPRSAT+tlLOyqDQV5abK1yIeHMRrRWjY?=
 =?us-ascii?Q?MErAuIhoIfJUvtSW2zxI52iCWiR5ps2kMotLz6s6vwlc7bq4/0SAfsg7nN9Y?=
 =?us-ascii?Q?MsDKoL5bEpRIvwVJNDstYlnjXAzHbIgqGl4x6FGfYRnWSOG8QoYE1/mOsw0R?=
 =?us-ascii?Q?0CWV71SW4uZ+y80OvFLeIFUvzBXJlgpsOauS7PyhLEpm1ImXKbfAI99gqt9f?=
 =?us-ascii?Q?nrN0uxPiJ2mXZ+wNB7m6ByY+Qd9GhELkH9etoCFveB12HKlrmUs1+rmVSBcd?=
 =?us-ascii?Q?nfVslP6ZFa/UWoxp8kU49UjUsATG8FxKU54PtV/oQjO3dwRvCOGnljQjvcXl?=
 =?us-ascii?Q?Y6GyOFdlr7BI2iX9IO3CubZeMV7rA8wx9a4m3GFwXhAeddBqgiN/A3XSAr28?=
 =?us-ascii?Q?q/6HvnyB2DJXoeqZhtgx4QQEWtRSAQjpGyu5Y/on?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef417eec-04d0-4416-ae83-08dc3e84c003
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 08:58:25.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7O4IK55mDfR8WVk7DirG+0XEYiAPWg/6l6/5U+YnBvlGboxqqlHWArl56Kf3O4zrO3D4+XTPMPj81e8HEEJw1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6189
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, March 7, 2024 5:15 AM
>=20
> In order to synchronize changes that can affect the thread callback,
> introduce an interface to force a flush of the inject workqueue.  The
> irqfd pointer is only valid under spinlock, but the workqueue cannot
> be flushed under spinlock.  Therefore the flush work for the irqfd is
> queued under spinlock.  The vfio_irqfd_cleanup_wq workqueue is re-used
> for queuing this work such that flushing the workqueue is also ordered
> relative to shutdown.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

