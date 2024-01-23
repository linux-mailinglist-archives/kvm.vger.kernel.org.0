Return-Path: <kvm+bounces-6724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 350C5838930
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 09:38:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594611C25116
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 08:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D5A5C60A;
	Tue, 23 Jan 2024 08:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2ykabYn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D651C33;
	Tue, 23 Jan 2024 08:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705998933; cv=fail; b=QFTh9PClAKMtM//RlLqlIIZdJLRKWx+L14Q5qOkJ83F94omSBVVMdK2YsWqCeiM7BB5YZBr0LKeoOUP68I0EDKwsDAzEwRqOfhpuFTEH5J0o4NryjLRvgkUhr6Nj7QeAONyevJJgXlJrLppFirBokh6HJQiVz5rLT+KHvdVuWvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705998933; c=relaxed/simple;
	bh=8K5jkTJAzvILvIc59X6wH+j9k+qXIF8yz+JETsXwOPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IMPKi2XDt3RoNuC4WWoTRCryipMEbEqdl7ANRX2MH9QJ/j6ohmlCtR/U98vnK7Q1SIC5qiMV4I/l+Khci8RuHLA2DLUXSmjqmTrgCBhLfu/rnySkc7niZjCH26G465TRq1aOkzUFNou/gb8PLS9dyRPmwU55zCQ7O+bP8pRvC/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2ykabYn; arc=fail smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705998932; x=1737534932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8K5jkTJAzvILvIc59X6wH+j9k+qXIF8yz+JETsXwOPU=;
  b=A2ykabYnLgARK3ofiQd/LJKtte3kbyPdLu8PGnUNvTHOO9tXsVizI7K5
   Ucp8uSVE4nNSj6wteeLJbdma5pYScOvgqVyFgBM1Q23VzlFFnlbercE6h
   F5q/WI7L/7W/ZFtZ5b0BfVNgRZFSd9uJDfs38itBIHjtqQkQn/EYesgm+
   jTWX80ndDR0Q/GTT8wDG01zD3TEXaKNct48Qg1MW6ia5zTxvpT0yMREsV
   XRJyfjBoCaq4YdHs8KSzb0O+Ww+iTZO/MH9XCL5kPFSnD5IV1t+KAWXDs
   H7mS+pjRnhSCX0XRK6OLkSf5Rk7qHb9Xq/IQiQjZBY/l75vO7RDPLkEWI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="398604505"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="398604505"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 00:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="909223636"
X-IronPort-AV: E=Sophos;i="6.05,213,1701158400"; 
   d="scan'208";a="909223636"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2024 00:35:29 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 23 Jan 2024 00:35:29 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 23 Jan 2024 00:35:29 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 23 Jan 2024 00:35:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGZGDb9hTBRK3Fx7SJALtT2Q8d9M+yKUKvMuNnQkopF6csv2yZpClItdPWqt2wdajZYMbgbddZvgZGFDLHi1/rxH1ooCRZUNtoq3rvM2vX4ubIxwiGsPx5mmJm7MfUbLZ/bCobmFPXAQn3/VK11hBBso4UFZrTyvT4VjfPbYpPhQnSrQ+gzB/UUisfMNNJsph98kV+oolJPcCrBG4JmoxAQgVjUei2xdbGcJ7VHtcUqbP37jeFMbNkEocNmHGMz98UCgNpNhfk34uORVNvKKiE3xfUpffuR5kuc1aTtLYrMRPrRdfpEOCFux2l4qYf3KfUyfLI6MbxdIkbAFiNeQvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8K5jkTJAzvILvIc59X6wH+j9k+qXIF8yz+JETsXwOPU=;
 b=KpwNBM81r+y8cDGBUgcK4tsa1GcA+aClVYMJDTjeXrE74ZSV7h2W4IwfN08jqteP/kU7D5mZW9bo8XVV1TtmHIdU5GQqGOQR1D7WnTHcl1aX/N0aSsrahPwymxDlq5svhX/G/61xincki7PAR9rB8enVoj8Zw8Gq1cBvEU8cozSb8crJ8gCepOFPOHX7UMdqFAXNkaBkjveW4Y0OmbTxBhYZuOpCydt48oGApktCFjShETnDaNkP/PctU0/K/UnOK4ztWT12Oed5UcDyhr1fd930Wh1pl9UKMR7GMWNk3sV0dTd3G/cFt8DTtnu3t1a1+ivElupfZTbXqlm68blR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8334.namprd11.prod.outlook.com (2603:10b6:208:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 08:35:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7202.035; Tue, 23 Jan 2024
 08:35:22 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Cong Liu <liucong2@kylinos.cn>, Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, "Shameer
 Kolothum" <shameerali.kolothum.thodi@huawei.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pds: Potential memory leak in
 pds_vfio_dirty_enable()
Thread-Topic: [PATCH] vfio/pds: Potential memory leak in
 pds_vfio_dirty_enable()
Thread-Index: AQHaTZlwVlOTDs9jR0q63g/dHzA1+7DnEt3g
Date: Tue, 23 Jan 2024 08:35:21 +0000
Message-ID: <BN9PR11MB5276F8A613FDFF5633ED98B98C742@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240123011319.6954-1-liucong2@kylinos.cn>
In-Reply-To: <20240123011319.6954-1-liucong2@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8334:EE_
x-ms-office365-filtering-correlation-id: 0e22376e-4575-44a5-763e-08dc1bee3d11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C7jcLJ1SDNNvHKJVBB2iNM6WVapHuo72tCgCX7elun7Rj5oiQWG99UHPt2R6gNnHXBQ76KDCXxnUN07Y+9xEj5eIausMPE8gQNhn3bhypqeGDtaDovpyr6xUWnDxwSHRgowo7IfGIJQ+/wXiK5+B0u4oC9QZbCBdyxV/nxvpNTA3jj8FpX1h07Q8hkRx0ea740AYSStbj2o+YD73hXoZJcJ5sJ0yrAtfqr7u+Tw4buOTOj5Zv9t+3qw0ahfwGCVXHZkrf+Xk1Zm9eQS8Vkojy91y8hi6pW8itVp3fCL9Al0xUQzb9qn1T/bMWplOJxkGqHgW91vlyXDifaHxVy0QQvnEe3JJpwTbdO5F4QJ0LN0hQzrvHpt6l/BZta/SGKzh+3ikqU6zMLNuZohruHVmRb+RducSUGhwljCoTXHhWwz64mtv9DfyKXNrKCJuMtMoiTH9IvQJYPNh+gqj1zvYccVY5q/NDl1jZ2Ve4awTnJJxPPXFSOGxJ2wzxQvd5Jd7mbNlKRZ99X0K40iDXAX8CipDygc+ReKqFWCIpRAOr4ILjWluakbNlfNUMrX0dgQFyjtcYfkLKiJz79yoI2RvjfimvgbvBK0uTdas/uLu7Szz6BbBb53/4D/oWHVovip7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(55016003)(26005)(71200400001)(6506007)(7696005)(9686003)(122000001)(82960400001)(38100700002)(558084003)(86362001)(33656002)(38070700009)(41300700001)(478600001)(2906002)(5660300002)(52536014)(8936002)(110136005)(8676002)(54906003)(76116006)(66476007)(64756008)(66446008)(4326008)(66556008)(66946007)(316002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wap0HBlNQD7kqNeXifyLOFj/5HcwKSQUy/YrljwAef5OUC0GsQx83kgQ5fE1?=
 =?us-ascii?Q?t1Nfm8k1Imq0W2aHJlxF9oZPEBcYPRune5GIMYcwDCC1SMD30vuipA5rSNMU?=
 =?us-ascii?Q?6TW1H+bscCHwYaQqKJ+YKxAHOhky7MBKtERyert3dO/5Ip8GBkMU4Bq+KYFE?=
 =?us-ascii?Q?GRcdNoViCPSjy49wH6HE6TJWA8e42AngACi13JxVg7YwnUpf/5RQBPW88ojs?=
 =?us-ascii?Q?pJWT9B7/a0NP/0OaYTOBzAqzFqbtW/pDZkWfzlzveMgcp+SjVz5YT6wv6IUY?=
 =?us-ascii?Q?J1gJ8zc19fDV6uxyLH8kuWQ8jwt70OEgzmHlBL7MdUYgEIId0SII4ye0iWWA?=
 =?us-ascii?Q?OTMhbAOdVKdHyYzoAKlBX33c9Lm9fe0SraJIPtTK1xWBwwT5xFHChq+89xO+?=
 =?us-ascii?Q?JlLpYiaDZ08ecf4IHoOKfbYoBxDK6PMDfk7xI8vVbzD7a8vgXVuY72776YPl?=
 =?us-ascii?Q?1r4Xic3Oe19A0wjQ1rG8FsSVvnzchzUhSJAJR5f/69Y+PMj6HEcYXxEPmClK?=
 =?us-ascii?Q?7ZsKs9edNWjyHvOjkRg53sbiYzMD+NiqywdxbduqUNerIMD8W1O/gvtsee3V?=
 =?us-ascii?Q?7VNx1MbuDW8hd5hZlSDChmsgd+JBwAPofbm4HhJFFipJlQRK26+fFF/Bvezc?=
 =?us-ascii?Q?E8POA6n8OSyMvHanSnHlHz8qHcYnBtEho7a0ZwaYlYC9cHF4/oAvqGgsta77?=
 =?us-ascii?Q?3z8qo7cQt8yUW/MO1paUIZVAez1F0nckxkmfbWW09buVXjn45w4t/miTG6MM?=
 =?us-ascii?Q?+EukCiTBsCxDyy30EIfIIiYrHgW+uldKtViCMxebZET0wvS+ZB446zArPo8h?=
 =?us-ascii?Q?zPzKPycu9dokE9KPxr6S6IvQOfAvBrR6CJnNKbhtVR023tn6ITyVZ5KWetoM?=
 =?us-ascii?Q?dBEudTdWUtmTIDpe/AVcVuYwqzeU5CcTIzBqef8OhcHO+7/JtDBPsnqyfpjs?=
 =?us-ascii?Q?bXx0Ye+SIjBGfMCOKyhDyOIOpWyfOb1wrqKnMF1LUdiG/NFdHsXwyhVQzO+I?=
 =?us-ascii?Q?4BOHBHdhTVcjwSn9cstIXmfjncnikRpsu1dh4BnKNbjAi5QzmwwL7fl89CvV?=
 =?us-ascii?Q?3f3seB7RQhHu+G/oHLzNaes+ad38fXonfwnIRNMX67yi4W64ONCY4flpHdvY?=
 =?us-ascii?Q?WzJQnrKT/QWv7p4mXniqzurPiDa4trIcoDzm6l6x0CaTs9X6YFo/PfvNoSqo?=
 =?us-ascii?Q?a0kow6ER9gKru0wDR3aVqfx3cMBN9OPI1tjJY+J/nVHQ/SpFtGfVdfIGs2db?=
 =?us-ascii?Q?UcX/vQqBRk67qm2sslNVGXj+PdSTO7HHIEp8jbXqW2Eks77yENGrBxHRsq+8?=
 =?us-ascii?Q?du0zLAWKPus4mXIZHHW0n+mamNB0Kbnp+Fhz1nI+nrw549LJfbkB70ONdzg0?=
 =?us-ascii?Q?yqCIQ7Ykrp6RDD9aNScaCtBBb6wYxBfvIfFqTNFO2MjbB0CDI781vKDPq110?=
 =?us-ascii?Q?sDoVlJ3iVAKUumJG6E0rO8EBTP8aKN+WU6kdc+KH7isw34j76Kje2o+p3nIO?=
 =?us-ascii?Q?VI6asZz2b/sTSa50QrehXxAb4PCkTTTf7Cbntkyk+Ue98TSGgRxNnELPh9Sf?=
 =?us-ascii?Q?278RmNYx+vuSb8uIxtULHWAQVa7QY4vxkUvQciNN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e22376e-4575-44a5-763e-08dc1bee3d11
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2024 08:35:22.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8kj4ap+kTP16QLzlkl6T32SLwA+oCqf3TN1uhIDpfBOreqhrUnEjHtg958gGSFq4azxBnubVyYF4M5Y0h8kbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8334
X-OriginatorOrg: intel.com

> From: Cong Liu <liucong2@kylinos.cn>
> Sent: Tuesday, January 23, 2024 9:13 AM
>=20
> the patch releases the region_info memory if the interval_tree_iter_first=
()
> function fails.
>=20
> Signed-off-by: Cong Liu <liucong2@kylinos.cn>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

