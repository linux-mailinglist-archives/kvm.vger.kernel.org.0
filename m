Return-Path: <kvm+bounces-8091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C87584B00B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:37:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D0051C245B0
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF0B12B176;
	Tue,  6 Feb 2024 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EoTjkRAw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ABA12B164;
	Tue,  6 Feb 2024 08:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707208634; cv=fail; b=MfDA1f3ov95TJbkHNgdNB4xypSLjytg+G/tBrUSsmi/DQJQv6ySkUU1ElBEL8xMxYVuMALF4aMb5crU5XF1AEPxxA9GmAaK5O8TRrkrTOHgdKrypCbsdfqYgIVFUFMmo9mlsrxg+VP8GS6Sjnkc+k6VoFY5ZQ8rHGvZgoSjCbjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707208634; c=relaxed/simple;
	bh=zCEAw0YeUaxOmFvKvtCUXewiM4k9QL8vE/Pk1H4h8hQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ez32nyiu3zvXf/iNwhVmd2Adui6Uh42RL9d1K9kqb/Y0nBQbbSy0sL5zKHld+ZLfHaMK9fEySNUHlZYim45ACGLy0SQhHlkGGejPIcINVDcghC34ewy5rSj+yZ+xHiL6+W0IWFtVQZP7gBXY7gAD2hTxB5B0Qvnlwgq4VtXIWSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EoTjkRAw; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707208632; x=1738744632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zCEAw0YeUaxOmFvKvtCUXewiM4k9QL8vE/Pk1H4h8hQ=;
  b=EoTjkRAwxPo7KO4jLbmyuWNJ4zNcGf2ZLHWk62RM+8ArYZFengxnAycP
   wqaMhrqAkMqwcWfRquaJZQ3yO8XD2Kbi82irn+Eb+Xby/QtKIDgCORRff
   0z9AqhsmCY8jj2IioPDnnLKoI/txEKc484pCWleGJIeLGR0oCyhaZXnJF
   Q0kQ++b3+evvGuES3Uz3X8r94DnWw3ixSoSAbhL6/g9+PH7OBuMufvCOq
   Yz0L5j5Dv0F6QdFUdCv2NUkAyFCQg5rDEDNyRMSy8eB3boq3w7kkKMgxs
   xOA/CwvoL/D/Qww9NbH1RxK1lwXsYQT8IDb+8DfKUuhYAPfKPrwfUOFcd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="596795"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="596795"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:37:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="1237336"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 00:37:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:37:10 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:37:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 00:37:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 00:37:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqHGwxBuqN9QJkzCpQY9AVIjfVns3/Pfv/p0qY7nFz9g0PmmcDbCWV3hOa3UKc38dVZJR9Uj2fAmeTiL7HKyhuRWHjv+SqVgy9/JD8qB7KaKIRBrZZ7Lt13hMXCqZobCHMfASF6HZURm8dg+LFGbDFk2/KvBjuTzy/2gKWrp804mhycepQojLejqsqp6aYGRo3lCemOprKmPiOtblTXbQ+mhx6xuEQM4wkvMorH4zNE+gf8N5lqhZedxEFeovAY95+/q2n2T6V3kcYkKesMbGM0HUEoCAK66g3SkPtT/7HWKJ5J/7uulrTY/hZ9KalVHWmtS8S8g+VLhcVfA8QpIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCEAw0YeUaxOmFvKvtCUXewiM4k9QL8vE/Pk1H4h8hQ=;
 b=Tdodye/8qhcsDt0gNhrSDzSGpS2wInbZubXY4Gf5mGYAClR3RhG8vNtiK42BRQ078JjxQ/gJwozu7+lIOjIKeGmPnSRGJunMIFVLuaN+354oUX5NE3E/G7uZjTtH0/ku8X6kq2GZhushd8ilQajcND6dkFE7aED3BA7Ri/ex5aay65B1xLPiIeywkLR5YGYdQZdhUPwancdsK+LpIZdN63BgyTRhUp5mSSZapAk/fSBGXhHGKJiGNGs8eoB57UEU1Etis8GqgEpSDgkWFGJotZqlHpdmvpR5fQelMeB4P23IVQcwOcd7oiP6EvjoS3thUKKAXPQKvSngWzLz+w1Qwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 08:37:07 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:37:07 +0000
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
Subject: RE: [PATCH v11 15/16] iommu: Make iopf_group_response() return void
Thread-Topic: [PATCH v11 15/16] iommu: Make iopf_group_response() return void
Thread-Index: AQHaU1R798c3cVWjI0SOx7NslDJDFbD9CJKw
Date: Tue, 6 Feb 2024 08:37:07 +0000
Message-ID: <BN9PR11MB5276F67A3A668B43B136E29C8C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-16-baolu.lu@linux.intel.com>
In-Reply-To: <20240130080835.58921-16-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: eb568f00-06e5-430a-5b99-08dc26eecde7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: txJf1wnah6X3uf9tiVTtAVuU3EEVr7unFr71MlFaz+IHQwxzwTiKLTED7J1ciGWwMQUZwa/lgaPgw92/EKUxJ70/7Ai6qd/AvxhODeGOthGAAGV8UGol9bFz2U6JmVn0DNk5dW8vDNcIqL1i70aHTR1mnpJiWP1qb47Oo5ZE6SNwKzio8FwPsP0+pNdwAhd8whAkeR6M7AN2vRmtwx0GMO+cBicTc5GRWZzo/l9xPl0QCj+FMJAycaSgMbrk7g+GaBHvElBoKEKOAA9ghYIVOb/PCXyyXBMIsn5DIK/2PTicJdIykygM7EqJpizpOr/3zI8u8u8Cw4VxdLDuF6NndU6mHLAxNVLRGFX5FlDAS6eh1HOJeIilC8sIJw4Z/oGBGq20Qh/qQCG8nGnO5A7icB/3ZGZQIkW6fXp9l93cVYAvEp46plnYFhBoML54v8m9Wdr6xh6a7OmqjgpW4GlP0Aj1EpqD4iLjs3y4aTRhPcBjBd0HqzHKYAxlsasyN7udj4jEadSaZjEK1RhP+ySLUfrwetkhEYDoNjrN+INrTj8uXj9j4obfVX2FE1CiV9g/PKs5zdRp/RaJ1dX5OhbVEOeLXSI+ELsYoOIfdji0X7NDZAWMO9/x1ooJUjtx/Arx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(39860400002)(376002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(83380400001)(2906002)(38100700002)(122000001)(82960400001)(55016003)(41300700001)(26005)(110136005)(38070700009)(64756008)(66446008)(66556008)(54906003)(66476007)(66946007)(76116006)(316002)(4744005)(7416002)(86362001)(52536014)(8676002)(8936002)(4326008)(7696005)(6506007)(9686003)(33656002)(71200400001)(5660300002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gg35/+SW4D6po9GAaICU4xiiRdKwUMB1GerHoO8ecWcxZdCTp9Iz7TLA7mHP?=
 =?us-ascii?Q?IQtjp41OrHuM+BijLpnp6derh27eQP+5qbVMBacHmCbzmY//7Q2AWd7DnbwA?=
 =?us-ascii?Q?XCdVTrvRgjHVxws912otYf50y76FdwjxHy4Tx0ZdKpWQal9b1Mak0FgDk6Dt?=
 =?us-ascii?Q?jlR9yD03IEy10EyReetMc4XVOwVcLq1hG8R3MKxI52YerkJ5YHkHdD4vo4Iu?=
 =?us-ascii?Q?oK8cP4yv4fqHIy14KWOOBVv3c7gH/rd+mDZi7RYIiuiQED7v1M0X157F3ffq?=
 =?us-ascii?Q?UQS+xgKffOvgSGrBSnvsk2XF3ojI8zIZ4Ge8d7Jbes4vf2me7EUcqUJD95lW?=
 =?us-ascii?Q?wlUCCfvWdiACS2Kg3EpnLgz2WeIHCwO0Qe8pA/RmP1xC7jAg5WAoi5qbTDye?=
 =?us-ascii?Q?EzEjhN8DDmC5S8p7S2jTXSpToKZoAWZ+jH2inzhWAqJQPmE89+0iticIlY5s?=
 =?us-ascii?Q?m74RlZ5d1JHtEjlrXMyiKb/ikvqQz5S+cwTmoM8chfgVS8C2tCEcb/LiIZL9?=
 =?us-ascii?Q?H5ZklLWnsjJtgvOEZv6zO2QjAjTw6idhXwyULCTpN4DE6laHYQ0yf4j8lRB1?=
 =?us-ascii?Q?qTvtFmPtw+ASIRZ80Mevy+QCtJ7FxoAPebnv6jm05NQLltZuB6ZsyKecU+tV?=
 =?us-ascii?Q?CMEVf/I8T7OsBQTfowEJaatxTOq5Jww4G2duPwE+tpUukGnnOjRL+Mu8uxaa?=
 =?us-ascii?Q?u/eKcTdO4s16B3geQTKXL5C5ebW6cI6IwQ+CdfJRZ0d44zclR8FWXpkHo9rp?=
 =?us-ascii?Q?oscxHu/oV8KS4ZglGv/u2ddlFFUsUfPgHhBaQ8/lbw5g5pHqnhr+iuQ38K7+?=
 =?us-ascii?Q?pqU6kERJv6cRCKhO6NDtJeCkl5CMCBITSpT32Iv7LWmE03DFXUMDkXiZKpgw?=
 =?us-ascii?Q?yo3dw2L/rpJ+93n39HEaccD+OdDL21nQWwUUalb5HRkzGUFS/Lpq/Dc3/dUL?=
 =?us-ascii?Q?6dw4bN4cbQN2B8jpDBkYfGwxAU2ZZxEQ5oxCuXOHDcl4waK1IOFxiag/BnCZ?=
 =?us-ascii?Q?PZNev5YHS/HRy83twV8wgW+ddwrWeOz3Fa7+yBbIQr6/KwIrZyfW49zAfCeG?=
 =?us-ascii?Q?T/9A0w12G/G6CifHErJ/XiVkYK3w4JDCyfQyVCw8HkucgvxrdqsU9INr68SD?=
 =?us-ascii?Q?TxWP0We9Lp6ztzM4quQy1AdAB7weeeG20sNFd/Yhv5BF3cTHz9OHrCHDuMUo?=
 =?us-ascii?Q?ar6wwIQz4FdRL8BoNbxiDXFAcIUgt3xB6gVUcdNDdLqYMxPnV5Lcb07eXii5?=
 =?us-ascii?Q?xWvH1LuuZtuuJOnY5bxjXt7Yoy5OuhwjR97Ow4RQAoL7jNAUV1rNY6eEG2cT?=
 =?us-ascii?Q?W0MKZHj9vSmtykP9etxAerdXnDYeucYo2g3N43iNyuSaD3v7uvDft5n2jvn/?=
 =?us-ascii?Q?zZhHyCMxsWdYNF9Uir0gHq16AjLeUgfzqq9eRKKZo4bIBX7D9KexDMpzq+OI?=
 =?us-ascii?Q?d8iMpzF8Bo3mJff9f3I7yE/hik9WxYZkmIs9in1BQTvmKdJASse1BMWp6tyM?=
 =?us-ascii?Q?mC3alOzIM+njG9AwoJyaNZ25z8UTb2TkZg/hZr5xttXEeZEEwaldTePOxkgl?=
 =?us-ascii?Q?lqih9OIbSWEDM3CcMx6DnskOeVzKnhsZ30oJ379W?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: eb568f00-06e5-430a-5b99-08dc26eecde7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 08:37:07.7901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +sZLqWG493h17vWSHcf8VY83/lLmxdtfKLGuuBrh1h8Bpmuipj4rKjjBGRv3QRvvSlLu7Hqmts840Y3Kk59Tig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Tuesday, January 30, 2024 4:09 PM
>=20
> The iopf_group_response() should return void, as nothing can do anything
> with the failure. This implies that ops->page_response() must also return
> void; this is consistent with what the drivers do. The failure paths,
> which are all integrity validations of the fault, should be WARN_ON'd,
> not return codes.
>=20
> If the iommu core fails to enqueue the fault, it should respond the fault
> directly by calling ops->page_response() instead of returning an error
> number and relying on the iommu drivers to do so. Consolidate the error
> fault handling code in the core.
>=20
> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

