Return-Path: <kvm+bounces-8092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBEA84B01F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91F71C24672
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9CC12D153;
	Tue,  6 Feb 2024 08:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L5BnLmBm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B617B12D140;
	Tue,  6 Feb 2024 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707208789; cv=fail; b=CeIguIYgIkLvsJMH9D5jLm9rjEwYEVZHroNmeMRG4Vn0t6/Lp1cI2Qw6awD3HDle81XFsmeljAGHibt1TGtGfFl2Ofsrkss3+15KIjRLPtUzL+ySUaGl6/tnJPq6ww7LgUih29yV8DtI1hIikTm+WC/UQo6Ojhz1nn37N0hCR/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707208789; c=relaxed/simple;
	bh=7dkW/T2x/lDrFtgUljyq/Jj0A1XB2aXfaHlXBH/Kg7k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tbAArLt/gEKr/cZHmhulz6+E1nmfP7zH4VOTUclSwuHZ8Obe3niaT0OH96KzvKKiRsxuvdebMiIrK5gMjrW/7PU0s6W415eC2Z4eRddGp8hXL+JToqGhRg0OOqEg3K6Tx2dH9/npZqej592MaT0lFWx+nu8R1vHCcCylDjcwiqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L5BnLmBm; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707208788; x=1738744788;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7dkW/T2x/lDrFtgUljyq/Jj0A1XB2aXfaHlXBH/Kg7k=;
  b=L5BnLmBmut6DIQIV1kHgvBpFd7RgyiHwsoLM5Ez/+gE7Sx89DYGoKafW
   3HLKy22GJVvXoDcH2dCpLG4u1Td/J8JkGvnu3AE/P/Q6YrCN94s70Viwx
   bHsyqE+8ZN2/N+/kH2Uo5sFSJ6dAQfNjLIzU80gwerk3jjUEI6emxtz3s
   GrK5w649DXugZS6PetIfJ05S//bSCTtn9Z3fxRihGPa4M+ZuDtNdfvYWh
   3Z1czvKMk9kzExc7Lr60x3YXgZEOe4c/wmEQE75qlGKXMgByg6BcjztFM
   9ESXN4b98OOduQw/B3d+2r2jtutocQS6VwU/SQqlNEorqpSOAAzhpF+bJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="597145"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="597145"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:39:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1238420"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 00:39:26 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:39:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:39:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 00:39:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 00:39:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HW4iq1WTwSE/TqVJfUFLj3wYM67oGDjWOcqwKCBxmr8CR/l/9G3jrYJ4mRiUidVbuIIb4B91GPaze7zNXeIgF3gAv5pEIpPPUkkOAyUByjBFz7eh3X9178zZ35+LkQNQVXyIXSL3/fBzc0Dfj0Xf9NqM8Pxtd7N8+J5haVkFRX4ZJSh6FDx1to0rc6becMoa5m1WwrohjNsNi16vO0928Q6koDlhYTTQd9DrbJj3d381X0WSSpfmLtgFY6LynozmTY+fo3r1X53O/rYEMjHq3UdFV909tn2U5P9kolfgJRuNkEOGch8CIyLEE3QyLtGepZXn9N/T1ccx8KoDxmyysw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7dkW/T2x/lDrFtgUljyq/Jj0A1XB2aXfaHlXBH/Kg7k=;
 b=gyPUdQOTfPrLbHwKmjP8SURZpbGeFNAJ3MxunLklQPcQqctMoLMEnx719+2x10HvLa5aVQYXh7QaHsYBTkU9apfk+x9lTmVefsJ/z0Ft4mb1LYCKaxFIltsEnT0qR2Xkh5ReeWUrRKt9Ir1fQPYLtkAjvmkAyRSGEn8Jw0j6Okkik9PsZNfypWiARt1YhAyC72FSsHkU5mtRVESky7BHK3utxC5i8936yYJI6ny1Ih+LngxXIQ1oKjRtEWl42qYAnvA6S8K6WkREHGan2+U8vBqEATTXH0IZk0BpawUN0lumBhWR10GRhTQfer6QAvlqW+k6WJPrJ5PJ3fs+C5cuUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 08:39:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:39:21 +0000
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
Subject: RE: [PATCH v11 16/16] iommu: Make iommu_report_device_fault() return
 void
Thread-Topic: [PATCH v11 16/16] iommu: Make iommu_report_device_fault() return
 void
Thread-Index: AQHaU1R/NF0uQzaXikurtIj0BN24LrD9CTKg
Date: Tue, 6 Feb 2024 08:39:21 +0000
Message-ID: <BN9PR11MB52769A2585FEAE31802518498C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-17-baolu.lu@linux.intel.com>
In-Reply-To: <20240130080835.58921-17-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: eb4a7083-af00-4c8b-64be-08dc26ef1dd9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gtzmTB69zEB8ftavGXl/EHFiqUmMDuuvkpyaebj5ynP3gbiWN0rc/YW/Wosvl5+8Z9J6/VSo/ves4S6fdNK8p80O1gCbdH4whQ+kPeDg5zQP4FB1GHJNJDFZLnpvPtYuWrqPgT/pCROrBYPA8IhZyJfqYSQHKvT4wjCnahQ5ZkALk4p3ahH1btSIDvxRywtAWHzdqe1AxvnARUCLSCgLNk44trG2x/uk18z7ZvYfikFBHxs93WMjTWOKZPvOrUZhpGf2MzEBFPIFx650XEl3JE7A+jo480H6S3uvN5tDJfXtWpQeAoEPJ/tlrpkYhVcT9JYC4jubGski1a96Y2DXBPAgoeLkuKNgmkSWDaDS/orcO/IeeEGhHxka+RsjcMZ2is6TesbR/tKvFEHRemjIAE2u23om/pYgioKBY9NbWwgfIXQr6mpfgQSD0D+sacQBkYDmGcXUXTTFwPS50arpD8qScYN+VcLEHD6krz1rY3oYUfYokWoomygwCDUkhYg5lGPKT6kbA94EusRFo0HhRfMFQrrNAaJVppJI+kfDbfZ9RRUftXPRDDM6qhfiZ06QKTyNP9hVSeVCsN1SdEr14dMGFOHhZg9FhWE3xZRGwmQkRCsd7rqzdhBtEe5Ck9JR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(39860400002)(376002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(2906002)(38100700002)(122000001)(82960400001)(55016003)(41300700001)(26005)(110136005)(38070700009)(64756008)(66446008)(66556008)(54906003)(66476007)(66946007)(76116006)(316002)(4744005)(7416002)(86362001)(52536014)(8676002)(8936002)(4326008)(7696005)(6506007)(9686003)(33656002)(71200400001)(5660300002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tfMPk4SQxyHtQmXw7xNaf6k0l87JyMGlpB5eEk5YdIVX2Zaufg+sC4ua/sbs?=
 =?us-ascii?Q?ro4DTUBkTlxetRXWDz/uXnvWw5c9n9rTk5NB0KjbW/kiADa/vtBBjvTtWFXG?=
 =?us-ascii?Q?OGw+ZKNBXfkPFXm2d1kk/7AgMsDUM6Yut9q1Oo/pLY8aIMLXqUe/fLdK+6j4?=
 =?us-ascii?Q?fEvmB6q1fnNMzzlt+2YnNWxIdf+Yt7DcGnZaF2jXh19KkHG1tqxJexP+IQMS?=
 =?us-ascii?Q?CSdVsAMQfQH6+7Bpc4S/9HQPONhgUVymK5sYDME+20RNugSUDKUlq/72jaWd?=
 =?us-ascii?Q?dSs2+2Y30q7XxazUsqCzMtKv875dib7OriB/18pyU0o2GT1Qw0cOrhQenMn8?=
 =?us-ascii?Q?BCX7TOlBE/A5rQOdfE69c2H3H4N7/HuF4Y60SXgKEk5xfycOvkOE3qoeNpzC?=
 =?us-ascii?Q?4xj3UnH/EN6kVFDOMPMcIzMTe6nGPt1S/OBIRf2oDITvkm+L76BAmGV2eyR8?=
 =?us-ascii?Q?5ObDwS83JwYr3CJ9yvI9dbOf+s8KIdt5gfwuNeHf5gQEtss/vsb32oeF0k8f?=
 =?us-ascii?Q?2ExC/gg+RoYyMfRG6Jns5yXT/ud+/tnpvqifLHbx52ZSqUMX/5jKXXYMlaGP?=
 =?us-ascii?Q?yOvNevKE/tk+NZ4vQReF5ngc4MrCa+k3uEH3HBgcHwrLKUIPtmi1VrcB6mSr?=
 =?us-ascii?Q?C+hdcHa4RibPQkTcLLG8nrA3FCFcmyPIj9/vswzZAx4N9BSVpnRaWkP5S30j?=
 =?us-ascii?Q?OsMCqueTzL301F+s48eFTIcLzJx3iPJLMCkasTo2M8XlVq+72b4eUg3PUd6t?=
 =?us-ascii?Q?nBHSJy3Fco2GyayxDmZBmJmighJ+K1u2RS2nFGElBoaL5EhPyaYLE7QLOHOX?=
 =?us-ascii?Q?jzc2uwfZlzKYVYKb2oFu++1RyWgNkywNbpZPrVk9HPYp0h8Xoqg8/AjYTdd+?=
 =?us-ascii?Q?xSj2zekvxCEcbL7iZ9CW7+vsZ0vGkghulemZJ37kBbq1Vqd/OMOvteTxUNYd?=
 =?us-ascii?Q?YoqnHyiRHc5XCLubcE3LMaiRIAEwDuwmcfvcA0ItkUBnTuTsXAHkpLr0LFst?=
 =?us-ascii?Q?TXgC42cJHnNXnpvLjW4rZeijqKM96A5B9ZlJfoOKZXCxckkST5wRfAiyRpxl?=
 =?us-ascii?Q?XQxO0tc3exarHIzrJ1Splbr95+gCg+HqR1yPYXJF/XErCCdxyvD+5OGeU8yT?=
 =?us-ascii?Q?/TGrFWwvwg9gyo4KvFk1PHGyWvVa0UyeD9BEOtd24VHmnAZDnuDrXaRRhy5C?=
 =?us-ascii?Q?Sv1yZyBLd3QHggDTD6PqOly6LTlRNPuwV3xNxmaY4v3ugNhu3DFaV2Yr0x1M?=
 =?us-ascii?Q?R8W16Z7T27Fg34fs2yYnDGbj9/Km0rqflihWcX1GYtqB4zIJFacui39P49KZ?=
 =?us-ascii?Q?pX/STkVo+dRkTz8vIDaoaDr7RcYg9ZuQpNWwXrp3gJwEpbjRY7hf8Zn/0s3q?=
 =?us-ascii?Q?Ifjbn3XoBl9kzXj0gDHnhrtFa7VUkv/zn6cbnpG1rlpxlHtWFCObxeqbig2E?=
 =?us-ascii?Q?7JDU5yeWT2xSY283PGAwewy7rdm+IL0+uTCf4cVb0XmOfAOpFj33jDTvq1X+?=
 =?us-ascii?Q?pW3gwkUEvLHostxCgw/XT9wVt47mwihSeLhhpGplvCaMueq8C4rDQgqsGh4I?=
 =?us-ascii?Q?NhL6CCbUA3OMQ15tjKdzontV0kxA+GBIVjd1+SFQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eb4a7083-af00-4c8b-64be-08dc26ef1dd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 08:39:21.9171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qz00jyLYu1lFOygSBu9/JNkh4beDXOIZqHHfNdQvmuC3FpLrqtIsLff0jvIE0COk+L/QRRXAG80jxdkhuTg/dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, January 30, 2024 4:09 PM
>=20
> As the iommu_report_device_fault() has been converted to auto-respond a
> page fault if it fails to enqueue it, there's no need to return a code
> in any case. Make it return void.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

