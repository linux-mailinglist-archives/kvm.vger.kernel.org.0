Return-Path: <kvm+bounces-14744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DCD78A669F
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50A6D1C2107B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974FA84D05;
	Tue, 16 Apr 2024 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CwVASFd0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B423B205E10
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713258079; cv=fail; b=S9pHUWZVpJIx+32TIHKjofy7BfiowkXzz5C/LTsJzdZUr6cyR9TildRffuXEWVttXA1aaT/UTgJNm/BMKxwB6Y435gb7MlVXL/JIz24iAvm1bBgvT0raL5xKRm859qsSvSTPpEuCNeBEvNwkUF5caXqsTPZREDFxLKR5/gBv3EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713258079; c=relaxed/simple;
	bh=j/oqBFpz/J6d3Ihybgasr+DzY6YlT1RiYGRTqURL+mw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dZfCtAX/DqcMVhhtiFOLouhapQYfdLsR6pGrXNng+DXTHwwnNEpmi23aAP5qOsv6IHdRdmzn8amKpGQ0jM0L8H+1HM8RNyJcsqgjbAA7rrRlsFVmxC9L+ZfXPJ0/XD+hw5/8h7bD1Ql7tvj+bqKX1qEQ6OBrrVx07vm2xrWzUYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CwVASFd0; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713258077; x=1744794077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j/oqBFpz/J6d3Ihybgasr+DzY6YlT1RiYGRTqURL+mw=;
  b=CwVASFd0wgBjkAGfFyWjBKij8QRglmIfOmpgi5EMMM7nqiZOom2gIpFp
   cceE1Wl37BOF8qF0qEpXHCZ7rtJ8SliYAP7WwDHViuxZSUAIHke8fflkp
   z5izKD3s4l6dW0WYc00ndEc9UhJhwPznhpak945gq8DdbT0RvAVock+7B
   aMiNhjsVhhgqxPLBdrS3oslWBYoJS/duqxNgw1Yhcsk+GISSjWxEv/Rcv
   uVZ5UMKki3xXko33+bKG60WxWq76OZ2m6tuQLdcO0bb5GeD1l+9Ivs6pQ
   kSrsAGpu2HmbKE2CPTIKfskJrL+20vOf6T2SN/TRUbOEsGm6BiJKyspgJ
   A==;
X-CSE-ConnectionGUID: Tkfqge/eS/uIrKp3hw517w==
X-CSE-MsgGUID: +qMV6pLIRyK38nQq6byQRg==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="9236465"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="9236465"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:01:16 -0700
X-CSE-ConnectionGUID: QWEm2mdbSle5LKIpRLh61w==
X-CSE-MsgGUID: RXmnN5L7RAOC2VW/I2gaMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="22086910"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:01:16 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:01:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:01:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:01:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:01:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGxvxztgsfpoG68Er7GMLt8kavxA6CCvPmUHj3yg5RE6VTgwtC2uXa9wfgT6oMJBDkvUab56bCZfO39HZP7EXf/5GTGPyWBi3zeSB/xaRpK/4MBr4iS1LiVpTeMZ+wUV/PhyE7prmB1gBWQZRv31QB2bknR9PHG5oz7j/C088tFsr9usHTnaafcye2RPJn0F4y/ICsfv5OVY4hv1TWu0X9JcM307zUSzy/RgGiyeb8c7K8RGXakXpudk/Gr45fXQ9MBREfko4OqSkxBT096Ln6GzOIBPgMeETyksCbus9kze90RlyDXLMqrYONAoUdZXt3VeUNX7q68L6gr33vB7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elp6MC0mSMTnLGiwYd8/A4kcqNtce70ZjAlWX6IPRCI=;
 b=K8tMm2+GcWQ5OxZE4b6AnKpiQAhNzDulUaY1W18H+/cJUJy9/rx0CAbfvjrqs5asdEWsQXEHN72J8+KXxZJRSHP/2GcxTwZgt69HndTwLlrCUEM20Toq7s+W1wOYHjELRZJSQ3Dr7XPorU3p2FLbgY0qDTYXBi/s462efuVedD+AJETia9pB2Wxa/pxForpo9dWinVoxcbLooEHBmIt2ryzhCe0KPRK+hJLRbBImuS9QvhPvrRF464yxYOtEl+7R00eP04mrQWuCRhAJxuU0Fo3eeur4akm+YwToF5CP6tTnQfMdqMcw5kL4RJ28T2JMcxEdqqS+yjw0UMzorZoGRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4934.namprd11.prod.outlook.com (2603:10b6:510:30::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 09:01:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 09:01:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, Matthew Wilcox
	<willy@infradead.org>
Subject: RE: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Topic: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Thread-Index: AQHajLJvqbi+3itwa0qGlqKjcLbCc7Fqnojw
Date: Tue, 16 Apr 2024 09:01:12 +0000
Message-ID: <BN9PR11MB527623D4BA89D35C61A1D7D08C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
In-Reply-To: <20240412082121.33382-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4934:EE_
x-ms-office365-filtering-correlation-id: 7db3d0e2-c5c4-45d2-cb5a-08dc5df3c40e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EyunXKilULZdAO9Cq+4yRC1yyiLe65JRcpuk0hPFikyk8nef1S7uEdStD3+AxTbNbTdxXC1Dfb2w9zKbjfkuYzz/8W7lpD9YIaUSDlAQmxgndu7wJ3vOJy66PRw0pYr5HNwNoLRLbp4UCKDsviJROIXdtK0rEQKQpVJfD8y+ExLb3F02ODtjBQsKOwBSGALIREKKm1JoukOiOZsm8EqZBhty+3qNpuAFmgkP24BU6xvNWqN8zgOSP6Q7FhC9b+cg9Uket1HRV2TKjfRUdj62uUMgva+9DHKnnuVd8AewK4zvC7XOnlyML4fb8jLXb0MkuPls5nUuwBF0FTHFh5bDWgv82cm9YMSPRSWm44C90GdILElcj3Rkm8QR44qqmr1JqDHN36cf+6TTlPsFF3JXnlM+o22moZCI1qBlOxltceAQFqTwlfXd6xmj+ER2xIDaV8XDZwlwvbaPvh7gZoJ5XNFSCDxDvGYWQZVIp5dff2oYfeMEdzzm+jQWaRuaX5PlAg1kqETr9KODw52B3zGKo3hElN2Y3vNM31Kbg3VrV/To6zCKTEPIR45M2ne2KMrLTA4BGHgQAgOjXxMeLRAG+ABbx1n1sy+FZIlWwlXUNkc10Ybin/6kKF6azvbOGpxQ1NeuvPBeslQvoNRMzSNsT5IR1wXoliZBGDCEHCAYpMNNat3m678QDxzGZ2IqE1nFRNLUGyO8JDlRE3XfTJPd4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9UYfR66NkYsDZ4mCeQJYm8phQyxS6rOrZ1coqswiEWbJF5NZKnijetxmdvrP?=
 =?us-ascii?Q?bhYDbwvzTApBz1t4UXhQ0k71olEB+FbrmQTYlasVw1RaV+d0lGpNWkbeCT/w?=
 =?us-ascii?Q?EsOvULXYa9jDLe98JwH3qo6ywfrzuOX0uy81BkBdGbBm3Nif31kkUORK7nWH?=
 =?us-ascii?Q?xMj3p7v1QgQcHXNHpvtToy98mkoF41G48A4g+UYkeypHAtchP/ul1TMUO4EU?=
 =?us-ascii?Q?XdeAJt+tocQdGn3kBH275X1H8Duls8nJuZn6eoq0ouXvsB1L0/CsJhwuZrIX?=
 =?us-ascii?Q?88whLLUaZvIY+08bDJ1dTi/KMdWcnrGictixjyMmuTBrlerYo0kqG6R95ZN7?=
 =?us-ascii?Q?1EglGoeoH9Vpj+nUtQW/WRP8pmv2yOqB4VPx7DjQ02kPSSDW241ckuxFQI7t?=
 =?us-ascii?Q?eQQkjP34hF0VLCpD0aKMYdLFOyr7R+Fo9RsFYmunkEZXmP6zdG2SHwPoBN/7?=
 =?us-ascii?Q?v0IAUoIHaawOgDNeo+7Y4FFet8mQtJBE0G6ydpL8WtKRY+FXWB0xkr1ba2mf?=
 =?us-ascii?Q?+x/xX2G13eI/fo1udpMpwwjw3QE8qRsnOWrEmE06HcQOjBYV4AnG5M5ULTOR?=
 =?us-ascii?Q?nuy4OdgKbUP1VcFglBgiNC0HuXUFrXt5x2zRrSi2ODgAtZJnneYzyfzQvQH0?=
 =?us-ascii?Q?4ZnAC+3qsTWqMW5F+4gSxqY3EqlJgvyp3GS4xuSdekDDJrXYyPQrbRM7Y757?=
 =?us-ascii?Q?QETF+AvuETEMrP8CfQ5AkW7Z//NRyi7dYcZH4Zgm5LZ9ivzNle6WTfQFvqDK?=
 =?us-ascii?Q?Ioq/OLdG+wEz66pq6zfUK/aaUINspMaogedC270TW5ZhSIqMKO3+am6Po5pe?=
 =?us-ascii?Q?XFTpt6lTh+5M0eOiGZVpIUTOfkHMNjnKHRk3xkzhYz/n+icEPkBETJGnCQ11?=
 =?us-ascii?Q?dc1Rrn4pUn0Cz+wPD54tOkf48fhG7xrygXAKv78j1P7cOvH1ndYHCw3glIJU?=
 =?us-ascii?Q?hPaYZXroFV0wvt+IbVHD2tk2kumNhjxW2PvdFQyd4HFLaLMvF7ghxKw7/BmP?=
 =?us-ascii?Q?3Z8dJoaqrijldE9SbJdxjmtqI/7WRVlx+u9mdvNG2tNm25qlWpnbaaIGDz79?=
 =?us-ascii?Q?Zk5O1FhvAEFb7PvRdqeZTIYSk7TNKFOQJlQQ4C0rp/WpUN4MWjRucdsU5US9?=
 =?us-ascii?Q?8pPYDr+qIOIvHxMyGO7zuk/lFwjvd8I3rX05B2tHn1863WC0iJzM5RvMdzfH?=
 =?us-ascii?Q?sANkUPichVvMk9kDQ+QirOeyC/Yvyze3uH4V1+P3SEe0EOWotmeW21koHZcn?=
 =?us-ascii?Q?W8uzjZLzTC6EwP1v0GUHwVg4uEX1OhGp5caWYEah47p38v9ZKOMAsV+Lqlm9?=
 =?us-ascii?Q?xz2SLnbEqXg0810xhMsMaCvQD/MIIG+dfdsyE798VdSJMEfIF00Kcb15Ep0v?=
 =?us-ascii?Q?1pgtNsTBpe5A0RekNuuEDKEuXUTs0HiZLeK1X/HOJN7ZOQOSah3sRDL/Cc4K?=
 =?us-ascii?Q?a2BUj0iJS8LD2iT/TDqmP8PEIFm0Zc5iq293bfkVL6mt/r0YX+jbPiq6ZRvR?=
 =?us-ascii?Q?87I7NjMXfWRT/1VjDOt3ex3SL/bZfbRjPV26AYZbH6LXTusdLl13ZgclVhef?=
 =?us-ascii?Q?NgzvAjO2oeUw5xTtPJ6AgjOdKRsEEbVr5Hnzw2B3?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db3d0e2-c5c4-45d2-cb5a-08dc5df3c40e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 09:01:12.7265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cBTOTXZ72+nDBXw6RNZ/vonPmM5qIr3nHP8jDTZCy7uLdMAW0L+o362bVCDw8YTszoI3rwsAqbNiqI2ORs5V9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4934
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, April 12, 2024 4:21 PM
>=20
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
>  {
> +	int pasid =3D 0;
> +
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
> +	while (!ida_is_empty(&vdev->pasids)) {
> +		pasid =3D ida_get_lowest(&vdev->pasids, pasid, INT_MAX);
> +		if (pasid < 0)
> +			break;

WARN_ON as this shouldn't happen when ida is not empty.

>=20
> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
> +					    u32 pasid, u32 *pt_id)

the name is too long. What about removing 'physical' as there is no
plan (unlikely) to support pasid on mdev?

> +{
> +	int rc;
> +
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return -EINVAL;
> +
> +	rc =3D ida_get_lowest(&vdev->pasids, pasid, pasid);
> +	if (rc =3D=3D pasid)
> +		return iommufd_device_pasid_replace(vdev-
> >iommufd_device,
> +						    pasid, pt_id);
> +
> +	rc =3D iommufd_device_pasid_attach(vdev->iommufd_device, pasid,
> pt_id);
> +	if (rc)
> +		return rc;
> +
> +	rc =3D ida_alloc_range(&vdev->pasids, pasid, pasid, GFP_KERNEL);
> +	if (rc < 0) {
> +		iommufd_device_pasid_detach(vdev->iommufd_device,
> pasid);
> +		return rc;
> +	}

I'd do simple operation (ida_alloc_range()) first before doing attach.


