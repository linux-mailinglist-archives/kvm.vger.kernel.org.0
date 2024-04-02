Return-Path: <kvm+bounces-13318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E29A88949A8
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 04:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59E65B24F5F
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 02:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A09B13FF6;
	Tue,  2 Apr 2024 02:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dKDFsaWr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88206FB5
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 02:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712026487; cv=fail; b=A5rXzgavPi83Km/jIytjrdbnQhE/BKHVCSwIMDBTlJMFwsi7i3x+FBvlOIjLPPxtsSPvmfnuz/PM7+irGcen7PxoQV3ikTj/PqdLznnx3fL+S7TvBbztjHFb9IzV3iBWWnv+aJHLauNq2n1mYcjT5M+vPfxbx87pGoxdZz5pRYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712026487; c=relaxed/simple;
	bh=lD/JfuGoSj1ioVuTaGCu95NOkc/1MztjOJxpVfXZ09Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NenYcgJPvB3Kvox/syfiuzpaYScmnCOOMmqVFWbYeD4QSDA1rlUyxNJyGxZUNR83lfqf6AosZ0f5CAlv3UAiJvILckA3AkMxa8nFDJpwlaeKHlhgJmR+7Gf8JeV4YvSNaSM24oF94Vzm9BPFA/nDoKGlCJ1uJGyCzGxO9bKKCxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dKDFsaWr; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712026486; x=1743562486;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lD/JfuGoSj1ioVuTaGCu95NOkc/1MztjOJxpVfXZ09Y=;
  b=dKDFsaWrzkDd5lJUBO0LiUNxtcZ01kx6TztIG06x9gNw70ecZJqa7isT
   A3cY7bfB+ysNiaTEkt70+qSn0b+Tln97IrzuqIAkmJtwewVbwiSwkOpcL
   uXM56O92FVg7eaAqWAjwLWOLQz+sKlCvHSASSFTiK8qXGd73YUeT30qvS
   6pcQOyVNfg5SvV7eq3ggK5pJKb7eUB8E3Qe0DNkpS+XX15Rk6ePQyh2A/
   DLH1cCwgALjwi+jGo14jRIrWCoo4VJdrEw0usxeSRIzzDaoxttLCtNZl3
   TYIjMLflVd6BvbkD71Ng3EKgOIoB+N6yFdWftwOc0DBAP+XoWLQMkE8Ub
   g==;
X-CSE-ConnectionGUID: shQCirsVS3aZVxLZ+DOAPw==
X-CSE-MsgGUID: KgUtye1hRUG5E61HETw/EA==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="24632494"
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="24632494"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 19:54:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,173,1708416000"; 
   d="scan'208";a="22647159"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 19:54:46 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 19:54:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 19:54:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 19:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnsV4E8eet1Va9ku2nP6AdNKkzSf5+yM2+iM7uWdiM//n95GaTltlNj3Ux8n6rsq6fGJOfVNt+rthCDiJJUjQ9Tr7Evyl2PfDXt3C3KdURFRksOb64RtMOptV0kzaEkmarr9Wu4FIdVfUR5tnbhsN3eF+4DT28HOUkrwTlOVEuvsDWqvybghZvZIPjaj+i5XawvsQqGg5WRErDGSWwsSYrg5hPjQAN8uxe7S1Qb8AIbNch7GwDoOjsQKF2ed/X3gyARFMjd+JyxXrdZnlRykp69N97m+K9IN9La1Xm97d2WuwuwUuYfOuOGc91HiSeYfiqNTzx2zgzqQHM57UxdZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLF7PL6mPHoPFh/nKwzx52fhg1QAl2XMZXM/jH+rgww=;
 b=aMGP8k1DRrTX8vKM/lLF7EU5gsHFXZqwSbZydfQ8X1oqpEz5dDJslSkFVsgtDLMk+B6bmwKvELGOJhIFgTaH53n2CF4B6BOR6l0cutdHW1x27uG6tg7eScPq2VIqv0A7OGR6KDRsFQ2aadlNW+0VJrC5fu8QU6VGpGmvtpMMIr5ufnY3RXMLn9x+dDMisYnevu0cBPqNxqMcMPzmBHCaL0UEh1+tP/Kc3wQmvkM1winG1cjFuXyHNSVlQBVhExAOurAbrW5+u6Xa32oZeptUX2F8Bj5+T3xhAHTQzjCZVtbp2W1L+a+MzecV0VgvqzEPf80ONK4coLZiN2QIwhjtLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6515.namprd11.prod.outlook.com (2603:10b6:208:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.24; Tue, 2 Apr
 2024 02:54:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 02:54:42 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: RE: [PATCH 1/2] vfio/pci: Pass eventfd context to IRQ handler
Thread-Topic: [PATCH 1/2] vfio/pci: Pass eventfd context to IRQ handler
Thread-Index: AQHahG5xo6QbhIiUUka5sHVlRl6JJrFUSUjQ
Date: Tue, 2 Apr 2024 02:54:42 +0000
Message-ID: <BN9PR11MB5276B5AC1B02848B3F367A078C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240401195406.3720453-1-alex.williamson@redhat.com>
 <20240401195406.3720453-2-alex.williamson@redhat.com>
In-Reply-To: <20240401195406.3720453-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6515:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KgmTS6qmRqOMyu74cLKMNnLxQ3ONwnpHm9+aqdoB1HdA7jU2S3ssdsuzO2hx7FWPHaescutooEIqXT0TNYXW3sDroEk4ewliPK489HIaBRLn5Gy+Ox6Q226iOfyuZh71Q0PrCnEEnB8XceJQzon560k9YzGhLSHoMCm8ULn2vt6iO3cpR0P5BmLJchLlTAchlaDr2UdmOR0WvsZg4HZq75LEJWOR4ipNdzaXuMMIMzHwaPltF1JfZDlKPJ/9hI7YQGDMucVvCmbfoXSvezbFangDtb0V2g1E48/mHF6BlwbwGPjjBcEb6VslkpHK9h3HIDsH5hPgPjAg4+DBeqsHUnlXi7tHdssMUYo4YWSPMbb+wKcvOVhge1s8MNlpGiqWID2OHUQ6LOa2c48OwiVlpNey/m9SbBqj2haR7TWJTkiLu/LHsspTetdHv9HEtTQ3mv22xFPjqS0uB/Py1jfyCf5tvSJ5U0hukNg56AhkpBQxRwQ06LT5lQW0FF/w0MjQsg/lq/VjMk0ofCCccXsoyWS2JU9wYQCxsAC1huLsS3Ifjhl6lYrrGK2k1hJUYUVcRQYbd5LNxDay0n1UdG/VH9S2FYkL/siyIdRCxhyolfbUERA3/7rJCwE+quH3/fXqStlIjJBZycYOBMZ8FoT0OPyh9BmLHLtaMmLwWRqqx8U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6grVZZyvhFHZZZFkVEYccZmESQKlduXBHPQP8bKk1XTfntvXvUpKViDTfoiN?=
 =?us-ascii?Q?oVyYlGfqlnN0y4aue5+bL+Xp9q70Hk5/gK9oJavSq9m0c2lTt6VSBLQRQwr5?=
 =?us-ascii?Q?h93iGD09jW2eeXPSWI3an/icgj30PR5ZHvFjsUFSYVoR4Ei0NFbL3tvAX9NL?=
 =?us-ascii?Q?0+7DF0IHqhnrkunP0vREtKB5TLySU/ZVwU/6gMqPwlx3dQ3V8qUvqIMBwSOe?=
 =?us-ascii?Q?rpiI7NuOiPMtMR3+yZvyVMnTmCCMgpVoD9ZEgktPxvFeR+ciGrnzeAtvo+zX?=
 =?us-ascii?Q?SKcyUDNuCA2ZjmBk2Yr2vys/e8gIKYL5ezSZPwo3q/WqoPijp7khTLnwTGm1?=
 =?us-ascii?Q?1s3OhKBXhZvtFA5VoEnJuE//SKJk/DAwIpyGzMB7lBnRwkeTvUFYEMLst9x0?=
 =?us-ascii?Q?05dyCrkggpU+5Pjp0CO58Y65uB7oPAJ02YFLlaE9j+XFp4OWkpHb8Dje5Q3w?=
 =?us-ascii?Q?zmeHOoUhtrN9de0qzYFkRllEHaG5s8TNpVW/gBMOlkg2u4OxS+b2Uhvcgd5F?=
 =?us-ascii?Q?Vx9lWhrVzRwBFInu8+XzFtvTEydDcpWk54WDq2jafKR7vJKV62J2SJbPE5I8?=
 =?us-ascii?Q?BFVg+n7zxAEerawcY3hnZX3v+IvBSwr57zU2+zY3Na5i7zf9p+0Hw4mJEgIO?=
 =?us-ascii?Q?uRcpYtdY9ICeamQfEGwwAq6KAewUL2Ljf2kzo03i88bKYLGspN5wJaXUijzR?=
 =?us-ascii?Q?NDV9HO4hMre9P1BvNVaN4rSRZnnzA1tJ49HfdyLUSrRrPogLPtPVDn76eI+u?=
 =?us-ascii?Q?gyIqrxX+RxL4l7Edr+VR4cIBMU8Rz9AcrDJdXJvE1yo6hRhmRo5VJvaMz0GM?=
 =?us-ascii?Q?y0/5U6gQZOhsftmIhdksrE9pI6Tsx7HqQ4gEI1OHf06KUZh487NwvvpzB/Dz?=
 =?us-ascii?Q?2CT7PhExPqTjs0xrK2A2vlKPzu24Nyv8DAk42VddbLr/jAcrXqoqQU4vjahe?=
 =?us-ascii?Q?P/KF6gRsssCf7mzeguPWaDOimIFFqVxbRFtZjRqBmI7dre3+VcaFKwj2CfFQ?=
 =?us-ascii?Q?ke4PrxtS0Z/CS+bil+ON5oXZ+BzbTHzWVrb1ReHGXS71WoiQ44ZucjyZhgC/?=
 =?us-ascii?Q?WL1AMw/eSOgmx6Gpd8DALnehZxEn3QPS/eAvki4pnqp41mGYUqsWo135SU44?=
 =?us-ascii?Q?OM1K4V9D5MFW+tzPCXsRpZY26okExAC9JCRnGvzIgI9PWssmeGeNDNGS1ags?=
 =?us-ascii?Q?94sChWXLvcmL1df5n9ZVtHT1l80Imje1EbARm30ktU3jOnB/m8ztlfwmxbns?=
 =?us-ascii?Q?YeJ5+DKu7Uz0pn+QShlas/Q2Dmupp5olnXQsm+ny71GpoG3JGGgxEST0nvC4?=
 =?us-ascii?Q?YgpcrWW4dG31XcbOC42Ru3o5V+ROA2Mll5zc/1fpKd7RfUtzhu1rMTw9Av9J?=
 =?us-ascii?Q?ScmdHViZFyfAo1M/t5/9jff+9FEZIPPQ14SOoRg4Sbz5eTOizgxvzyjpPmXU?=
 =?us-ascii?Q?ENoluGQ1KS6pXotblTcRiWr/q9YKTA73ac27QQaQXjeqvC6GgLWynMMtjejy?=
 =?us-ascii?Q?xyniMFAHxIdcFs+SLDTf+CevheH1Xqs9jgdRwzng9OxjUcepogmob5NSFWuG?=
 =?us-ascii?Q?B5AvTS1jeVQEIoheMRaEe7ZewNpGKm7oQCr5Lg9y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b456fb7-0d6d-42f8-62b2-08dc52c03f31
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2024 02:54:42.6692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CkYcDsSDuY6bCYsJFLoqktWf0+3SivByGDszIGhHRK3JYNRBzKzhFLOIp/wcOhxNtreqhkgUeX7jQHQ0MckSyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6515
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 2, 2024 3:54 AM
>=20
> Create a link back to the vfio_pci_core_device on the eventfd context
> object to avoid lookups in the interrupt path.  The context is known
> valid in the interrupt handler.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

