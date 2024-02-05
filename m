Return-Path: <kvm+bounces-7977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB11C8495C0
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 10:01:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B19E1F2134E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BFD11CB9;
	Mon,  5 Feb 2024 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2LY8zP4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82832125A2;
	Mon,  5 Feb 2024 09:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707123658; cv=fail; b=rHLPGCH7ucheQlF8AyZUaoDKPdOxeGTSoOuepSakKAuHT+KzDjzZnIV9Zy1yY3fiSD0B4XPbc7vbi9yeXhYEoFRd4Wbe96YSZiMbvAnE3B5LnFAXwVoZLR1CGRcD3MWKJpWEV8s+GFDOkzlNwxwGuv7iR5FoMfDn74iIh7AJf0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707123658; c=relaxed/simple;
	bh=L6p9HOlHBwUu5zDsML9FnSaBxBk4/KGeu+DFp4WrU9I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MI+UKgBz6J400j5wDKlvQN7QhQTuTh0DD2tKvMNRTW1zZty4mv17MX2HmJbEYjJcmeAu4RkGbVNZiYnwhrYVaqNZsTeADyLJoMvsH7bKD7yqioGB1SkvNu6nxYkX2KwMP6WQ+4ra7bhsNpX4M17GnVKgf0LRvb4WU+CVf1vbX5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2LY8zP4; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707123657; x=1738659657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L6p9HOlHBwUu5zDsML9FnSaBxBk4/KGeu+DFp4WrU9I=;
  b=E2LY8zP43ybsjXZ2s7NyvmPNC9BidkVkiljoRg1tRJe25GjWy3L5Mlew
   Uscxj37TsPdtM5DxXzrCGplzqWlQYRV1xmWcU1Q+rXwbvBX6AUy+ygeSD
   i59g1VVo+V+ggJJDNjMl4L83XCKg6j0A7nDLjoWwHSWTSigdmhy3Zqi6E
   jEi3xwvQwJOiLidlWjwWpj9Ely2QKX1mQBFUV7YvkVMJ1TN7rbnTFrKmN
   8ElLCfGIs14DF9eglXTwSh6g3SuulS8MIliRzuYPSoP3g2WQWSooiePgh
   kk+FDGZDjKtDWayQzDrRrgY+noOBwNqrp4XiGPtZIevk7tgJps/LZIP8M
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="373516"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="373516"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 01:00:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="5292404"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 01:00:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 01:00:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 01:00:54 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 01:00:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXRtJVTGP5Fp1i8Tgzjg7Zn6FobmjppFRAcp+CQ7W4sXXsLki521snKUXTcRGAlqrtuGSdW/U53s2QqK7BvPf0AxuwDLgStvxrX7je8ZzHCDXP3+LPUzAPPuW6DpepXguWFKSGzLnG6+mB1R/u2KLrj2nEAzLaCc7HtKo0aeaAspI0C5eA5vfJw79j5YYGAw3YOCm7qA8CrVQrAZbf9kvd1c4fPdxh/8t2KSUiZnXAnuGWP+F0nTPltwWpFcTC4zvV922my8D78RaQ1BCdKz2KIVvacMaQWXPV4pqYmXTsfilzncddHLEnsD7rC50KfdV9YeecKbAE1CLtFXS/bFvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgxqMST2Deq5fWPcifqvwnNayb84Ci/VG5yr0YBOJnY=;
 b=WlOzYpkSgOP2WXXNK+8IW/+Ub8FjWeC+3DreciYaoL4Ocv8Sb97ss4JrMRJSfmZRdhRRTUduAj8wgZXUDMxPXoa17dwJwy29cLNKYXcGWaiLdvgxROg4VYZx4SPhKbbOErFQKumEtIJhJx8y5w5lvSz5CFOal8W0CZ6Syn2VhfU/0tEPeV3+nl1kDK7FODnATlwfaW2J5kBYwCvzLzZkHLLWDR1fmCt9TG4i3cG65z+T6DRXPGDN0Z4KY7SveoH+Xf524bcItmp0vko/BuEcTaINI8ALV511OxE9C/sKJQXqJv/tYWptKtAQDEe7eB+BtK5WDGHUXC0pPwD1+9ty7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8519.namprd11.prod.outlook.com (2603:10b6:610:1ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Mon, 5 Feb
 2024 09:00:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 09:00:51 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, Joel Granados <j.granados@samsung.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Topic: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Index: AQHaU1RzuvzbDOxmwk6/Qx3I8sJBXLD7dmtA
Date: Mon, 5 Feb 2024 09:00:51 +0000
Message-ID: <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-14-baolu.lu@linux.intel.com>
In-Reply-To: <20240130080835.58921-14-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8519:EE_
x-ms-office365-filtering-correlation-id: ea811b2e-c16e-4869-a69a-08dc2628f449
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5SPvwUlnu9GwqbRNIuRgsgjaWKHJOByNMrE9GmCf8b+HmApnCE0FE54Cwatar1WJO/P7xHSP6GiXc95oNu1GTMnnXhGCDzq8AZa9CqY5UGNZPVtiZAJM+PMkynYbwPtFOBCYuhWiSVOGEAWjje9Q31CZmTNSsoOl6nugrYCH2a9zY3QE7cP/BOY3lCQSlb5hNYis7Re4nrD3Cgw4Bth6b+coBsNoa2tuhtmerwod9WQ4b2w6dMlAZIwP/L8aa6pmfT6WXRWly7wbpKa6eYBTyXS9i3dBW04sW3V1e3uyLqHfFTxIGn1Lc6xJj5PvL6PaebUlKG9a6g8CuI70xoBs6wx/fFtN+T9iqDnY17QR/WzCdyq50j/5o7htF0ewgWXW6gPqy53l2fkPYQ9hnTZLwyCNGIo4Y3JoS7+4pbMgIIIZBMiq4FNXpBNYT74Imt3dj1CzfMi04WCvL/ZNobg98+YiAnVeIQ9HHpvfc0vx0vNXNR4nyDZWbj6VoaEW+krmPFkylMdSwGvEEzS+7uU5h7Pw6ua46L602FiGWHbsHY7Y4kPa7euwsDtw4f94uvj6dp3nVY5ykd5FHXKjMaEMDkpu6Y16Qlr7r3XXoTCi0e8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(376002)(346002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(122000001)(38100700002)(82960400001)(55016003)(83380400001)(26005)(86362001)(33656002)(71200400001)(6506007)(7696005)(478600001)(9686003)(54906003)(110136005)(76116006)(316002)(41300700001)(38070700009)(66476007)(66446008)(64756008)(66946007)(66556008)(4326008)(2906002)(52536014)(8936002)(8676002)(5660300002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YvlwzyoqXvvNSVveR1kM7j5JwwUWBs+0w89hnB1727Q/CxpTQOG9SO6Trs8Y?=
 =?us-ascii?Q?Ib3m8SXNUM0m8tmZWW8oZtBxNmR+Adr0i0NO2MwsdysyXqaUIfgAa23NKeyH?=
 =?us-ascii?Q?rUuWSZS12Z52aICDBe38wPgHvGQIVM4xKLjR73jVWIa8QZwBmqluEv0BSM4R?=
 =?us-ascii?Q?MThjG2g5liYS4PYfkNCsTJ9PyF7IkHwx29B4iWGvOjZ1OUIGg1xNrNMiIRhS?=
 =?us-ascii?Q?ZP3driLhc28UN6REu4UGsIsilx1bLsbSpW40QlNqhxp2A2YB9bu86cbY+Hef?=
 =?us-ascii?Q?OjO8qIub6Bma04tPgnY6AwrZglsiGQpdAFXYeWw7NoJMgbuAiFtT29hle6s9?=
 =?us-ascii?Q?2oO3HZCenJqUCahevEgSEWC3oCitvQV/6lNG+HZKTjRN7++Yo7jS9ajLQFlo?=
 =?us-ascii?Q?iKRqK0X5I5EkNqaJZHPe6pR+t8vfyhgY7AmFg4C7xL0IZYGEXHB26M2Eid95?=
 =?us-ascii?Q?o7mZH7ZFNXgY7A5ehECb2u6PIFc4opbjuG0zKrQ5MHcJ4Q58eOYD9NYu2RLN?=
 =?us-ascii?Q?juNLH97yAKSiYk8qdxGXJoZdf1I9spfRWqjHAp3MegETNizgXRtELyPt0Ldy?=
 =?us-ascii?Q?lLUr5TvQEFFsaq3plROQb6iKkmC5tKXyaMvEVhzyZU+mAUnNdN0HIamiaUFv?=
 =?us-ascii?Q?eh34x/G0aWOBoK4U0mW/U9yEdzhQRLMj6Ex6TfDf38LpiwYKH4f0XKdKjEtU?=
 =?us-ascii?Q?AG90ZCNWNwm7h0bJINWSq9DA8V2dI255WHmVvEKlxTBdwNBzVG5WhExiInSg?=
 =?us-ascii?Q?/KDS4uN/8BENyj0jxJKeu3o2E1rH1OLE4Fas0WbcrUyee9qqz3rREIPNTkn3?=
 =?us-ascii?Q?K+i+VpW2dS0fcs4Fu/ecSMlA0IDMnXtYScwjJc8pFB1BVOVq/IrGKec7QOP3?=
 =?us-ascii?Q?MaiUezRlg2ghyF2echmh5LEYoqfH59/oXkMvl9hDaEa0ThrjDOXTDZSjFQHS?=
 =?us-ascii?Q?rTC085dmVQZhytdj2J84ZCmbklLAhU4p7eefIVcLKomqwquTC5b/a47LCsTv?=
 =?us-ascii?Q?r90qQcRXK2IUoV1YjwaMlBafWlKpOUiC0cNvLq/6fu6FDLHM4weJcpxloCuN?=
 =?us-ascii?Q?IIzQvhp5ZG7bKH+mvBS/SduzOz2dqfjeEyj08Lz6RQL1NMWqMpwNW+XPixgD?=
 =?us-ascii?Q?i1b5qzQd8ovCtxk3Q2Xi5IPdyHv9Pnms6dBrQnLBp7mbcf3uDFTMhoJJfT0e?=
 =?us-ascii?Q?Uz9nN72eMvCcKGSh1fYdqAKkNvjFdCPmANUuWeoTUrr9D/rkeViQt7ctvUFE?=
 =?us-ascii?Q?eD7zBhGtHKZgwgilc/0HKL0eBlsHaipsofw1r0i2BqyUfpCHxjH1rUYwt2cY?=
 =?us-ascii?Q?xkjNqeRWWOLyxkmut5Smzrw3P04298TuDmfxZpnpOKZYwhkLURDeQen/rARs?=
 =?us-ascii?Q?tYU1sp0aV7FzumHgnqDHMWIEjJyMypatvUx6IUioUmgekn9NdJunvad3QUPW?=
 =?us-ascii?Q?3nwm4ER7/QXvtrlTq+k5ka9FkbXIeu+CgoIVJT1rQUXWYwALLIt6FYjSeWnh?=
 =?us-ascii?Q?s1+4Fyopn/LaYvNLSkXDnC0k7LTchlb1NduzES9qQD+yzyeba535B8lyOv2F?=
 =?us-ascii?Q?Vo4cnvy//87Podua5XjrT8jmP7IBSK2QeSFtc/+R?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ea811b2e-c16e-4869-a69a-08dc2628f449
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2024 09:00:51.8201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBssPuqWgGgdX2Z9gF3yIKT3EUf8r3aXqwdRQj/3R5zp3pZ6loS9rbdq4QuwSUXqSKfafAznCNjTZAjWc2bEsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8519
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, January 30, 2024 4:09 PM
>   *
> - * Caller makes sure that no more faults are reported for this device.
> + * Removing a device from an iopf_queue. It's recommended to follow
> these
> + * steps when removing a device:
>   *
> - * Return: 0 on success and <0 on error.
> + * - Disable new PRI reception: Turn off PRI generation in the IOMMU
> hardware
> + *   and flush any hardware page request queues. This should be done
> before
> + *   calling into this helper.

this 1st step is already not followed by intel-iommu driver. The Page
Request Enable (PRE) bit is set in the context entry when a device
is attached to the default domain and cleared only in
intel_iommu_release_device().

but iopf_queue_remove_device() is called when IOMMU_DEV_FEAT_IOPF
is disabled e.g. when idxd driver is unbound from the device.

so the order is already violated.

> + * - Acknowledge all outstanding PRQs to the device: Respond to all
> outstanding
> + *   page requests with IOMMU_PAGE_RESP_INVALID, indicating the device
> should
> + *   not retry. This helper function handles this.
> + * - Disable PRI on the device: After calling this helper, the caller co=
uld
> + *   then disable PRI on the device.

intel_iommu_disable_iopf() disables PRI cap before calling this helper.

> + * - Tear down the iopf infrastructure: Calling iopf_queue_remove_device=
()
> + *   essentially disassociates the device. The fault_param might still e=
xist,
> + *   but iommu_page_response() will do nothing. The device fault paramet=
er
> + *   reference count has been properly passed from
> iommu_report_device_fault()
> + *   to the fault handling work, and will eventually be released after
> + *   iommu_page_response().

it's unclear what 'tear down' means here.=20

