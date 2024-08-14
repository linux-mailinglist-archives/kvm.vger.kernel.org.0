Return-Path: <kvm+bounces-24101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5219515BB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF0441C212FC
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 07:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8030C13AA45;
	Wed, 14 Aug 2024 07:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXbbQEY/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E768488
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723621528; cv=fail; b=nixO03+9nc60z08YeLIoYSWWaYdKCp0Xsaznlnx/alJFK6yxTysIx+YT8I4vg7yMEkB8cGaAMLAE1iAW4tZz5iJOoLc5I2Ym1f45hKFng37p4tUOYSovHHUkzJF+hIJmGiBd6pXP4iWgaD+QaPlX1PVbFQgn3iqndKZcye5FCJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723621528; c=relaxed/simple;
	bh=65n5BWeiWBkCzvJI0w5evHP7FCOvCvMLgAK/nct9TBs=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oHKgM/otnfLaryVOQ4s8nS2WRFWq9BKtYSfGE0L8QNBVDIYdq1SNDgAFs7lgCbCSyeHxb/OMeQTIoXl1SjHckgafdMT5Zq5gr34i7mCjHGSfcySPzz5yAa4NKQJT1rhMqXG4AKMp3fGjf95ZXSCp78JvVtXt3aYjbU9L+3q3/vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXbbQEY/; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723621527; x=1755157527;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=65n5BWeiWBkCzvJI0w5evHP7FCOvCvMLgAK/nct9TBs=;
  b=OXbbQEY/4NJj8eV0F+bEQFITugtxn1P6tYuFqY3pRpzAM+fTLbZcnuhu
   MsRHLurfU47AReixVSLeie7g6jflFGHWokbyY6wMPeipjCgMrnuzxHxw1
   h08AKdoGP8px1yGDHvmMt6H5/ysgx37ljUBP1y13tNlCSl9XYwlxGVT+5
   POQRNPhSLCwi//RN/rqZqqdy8gSZPpbvtp2pEuZE3qC/+32bfQ+mniYyI
   74XMvQ7qublReRGRm9q4R3/qlxlCX/T0px5pcTKzfhzzsElrP+1DrGYsd
   oPgiBj4REeb2AsEK+CvWYbu1rMLaO0eL4TZ2onbwzO4KmImFET9Ig3CgJ
   Q==;
X-CSE-ConnectionGUID: CIf5mXz3QCG8dmQP0OipMA==
X-CSE-MsgGUID: fdx8q+UjQ4qnM6QRqEdWWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="32395798"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="32395798"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 00:45:26 -0700
X-CSE-ConnectionGUID: scaw+YTUT2GNNCA/IquiWg==
X-CSE-MsgGUID: mFu9m0GaTdquXQyO52horA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59046885"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 00:45:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 00:45:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 00:45:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 00:45:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 00:45:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8nuENdkJzFQAqZlb6XybY+BKnG2OlmA+8HOrdIO8dEl4Ipqjd4w/ILthI70VJBIX6SwleF9ToIh7sjwjUiEI0mFOXdUrCgFR1qb8BI/2g9iwDUl20yvIxzFUtCrs0BdoIbkDRKQKlb5vf3biF/rM+fDTUgXG2W6wP2fgdFVHhkxsWWHw5qvxdu56aDky+L0TmT5Ifidw0WAyQtyw3q7gc+5vQHrUUSI5Juwsla2rCIEiuyFXkLnc3/No2wtV2GTSg7/Xgz5AKhcPN/UeTAX5dz+gzIHuE13/HGX7fuksjovVvHueqE+S/ysGuvX4+B0rdgH7RLq++8OB0qkea+/WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65n5BWeiWBkCzvJI0w5evHP7FCOvCvMLgAK/nct9TBs=;
 b=l1biLYTSbyMVS+Uft1mlYi2A93dSyiv6XcjqPzzTR1BhzQixqLmNul/l4kj6gmuRjmXlcTdwjBfnyqlO3MhUvYZkcq2C8JapdEsXQqq0aT+QpPVnt7RZ/yA0BdCUHYGU05uC2Gsy4nOHwiATr49y5XyAYs5V/XSLJ7VWjSZPzVbaZllkd6801Bl6XzWA8VHFbctEtDk24jU1jtNiFYWWuj+fUrhkcj970vkmBxdUALakvqoYgGFsw6ftChtJJoUdZdymIFLfi7LhwaNvNmu23luFqOnTrcUaveBvaOTxr9hSevufnp2+izcOtSu9vc3uOsJdNDFV8zfX/mI2AegrZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 07:45:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.031; Wed, 14 Aug 2024
 07:45:23 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Zhang Zekun <zhangzekun11@huawei.com>, "kwankhede@nvidia.com"
	<kwankhede@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio: mdev: Remove unused function declarations
Thread-Topic: [PATCH] vfio: mdev: Remove unused function declarations
Thread-Index: AQHa7LIuuVNn760vWkKikt8O2+ycarImYlHg
Date: Wed, 14 Aug 2024 07:45:23 +0000
Message-ID: <BN9PR11MB52762F188AC5AB0F26F1CE9E8C872@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240812120823.10968-1-zhangzekun11@huawei.com>
In-Reply-To: <20240812120823.10968-1-zhangzekun11@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4581:EE_
x-ms-office365-filtering-correlation-id: e8949d48-5d78-455d-121c-08dcbc350dfd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?gH4YHcFmCxIag9lSXXtQWmzbf+yzVP2WFyBO13YnN9SFcph4mXFOWlqrbGAf?=
 =?us-ascii?Q?0eQb2/3yZ01gMg5uNib1KPWtA8/tGCwl/++FodYobDsZSoHsyU6lnuc7LtMl?=
 =?us-ascii?Q?vOCIUTEz7+FnrFxHLbOD7AUqUYKmY1Ny+pt3nTtLxVez7h+QCzDnHg5g+lOw?=
 =?us-ascii?Q?vhCXVFmiNJjne+4Emcr/oYNSf46ZMr6OM+SxIYQHyQi3muvty0SulkPDCzEp?=
 =?us-ascii?Q?eur5SilfsjNFofUlD6tqX9detww/T1mtjVsWwHdvmS0Ob8HJhhIOkrJbKj6r?=
 =?us-ascii?Q?eFnlg0JfXe8lxsLHe6R/CjC6zKtrezEJJd14PLgdqQmqxvbH09kjgHeMueyi?=
 =?us-ascii?Q?aG03yZwCL/ypdis1nf2m+5sNmrxR0ZzAY8+jxWFRhQeDIfzUPuqv0GnZdqFY?=
 =?us-ascii?Q?HTKrShg5p3gNC7Qrxc19MjKjuTesadnZtKSiK+TKHrKvm89bYP6ZJATSrLXa?=
 =?us-ascii?Q?BFyRTsucEb8vIBYGfgXWKcjwrqAXXhN0fI2kZ0HY9Z29USTtjeq0MkXIuzzc?=
 =?us-ascii?Q?QbrDA7liKCpOK++SaLlcMx/XyovBhaGmEGyUXyVVP8M0f3KzzqWrAjswgWG2?=
 =?us-ascii?Q?k7FyOgpv08dDn+LlIQlHoVp4wurMnkeDRi/FdQ7MpVbDOWo1mnNJ+UhXhEOY?=
 =?us-ascii?Q?7e+S0F0iF0RgnnavpC4hhZIHyTydYs+qMi6GQzgY7SPk9V9nJ9wtwwXCI5s1?=
 =?us-ascii?Q?/9rSbLndYSJH5jue1J4K6KLLjHBHnLp/IV4E+4OrWWTnSLvDk7SSEV8TIBZa?=
 =?us-ascii?Q?kA98Ac5G9onrcBRM1ZXZAb+wu6gpP8met3DEoAqvalIftW5jK0sWki5I0t2Z?=
 =?us-ascii?Q?MlY+6MKcUlQ2Q/9rR9XHBDxPA1I+dnOPxnSevuAdpFByWTHF+RtZfLFdjUUi?=
 =?us-ascii?Q?SCKQKAcOA5LODOKdj4tLuanrfHfKc/IzYObdaK+lrvPMDjDphKEYsFVNEcNj?=
 =?us-ascii?Q?PxBZVSRVIPuiF6ulW5UazsFZXd+2XsOmemSo+/mqjHyY/xnoW6Zv2ayCT8xX?=
 =?us-ascii?Q?pJkoqT0xRko44kjK4CtFN5SOCRrUlOttD2MsmJaNOILoAlGsHuwlRoH6OoRx?=
 =?us-ascii?Q?WZO/x+gquIzxUqbkgjFfWqSav1wdZREIuVB4zvrd3NICcfPUbA1x1fJUkl21?=
 =?us-ascii?Q?1W2j8EYatHOWISamDm4l/pA/lIreWvG3oF+7FSX55ig5q2zLqM2obTO/RITM?=
 =?us-ascii?Q?yefeRqQ0VBAdD6xEYZUyCxqBwhuwAPqL5OJlxensswrQsKFmSJ89OpQmIwCm?=
 =?us-ascii?Q?PesaifZyh54xnhZdM08PqvzXeD+O22zHpj0EcBEO5o1LYqoU7xM/p0b2K1cj?=
 =?us-ascii?Q?2zueoSpdicS4leDfPq9UvoyaYt9aTCv+44Re7hoMKn15GNI8VNPfGOwriazY?=
 =?us-ascii?Q?VIB13SyI3OcdPfh1s1ieU32LdolFAy6I1KW6JzoqR5thMhQd0A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n4Uf9V/QiGNssRwkdWeDEBK3ss78LTtO77I+Yk+WHR2ffbNk3018baLTszst?=
 =?us-ascii?Q?YYdRWfY7LjIF6VZyOZpwDSoAAyJ0seCYNhRHYXLG8TbepHgjH3znk86N0Qcs?=
 =?us-ascii?Q?OV/0FqLy4D57lnqcJBzk0klmw+tZ/D04hH6yrFmrYAHn9naBMtny0B48/7SU?=
 =?us-ascii?Q?ZR28967AwyPODL8rhoIUvUV+OMvCEyqJ6uW3/t7UPBwvTVPlzNo62aSgHZrL?=
 =?us-ascii?Q?x1bLv6UBQvz4+82sq97tI0WPv2czswBNkrWU0GCFkdFQdYSmd2ZhRQQWKKIa?=
 =?us-ascii?Q?FXFKCJjR/dhbhvz601f3eYCdJgLnDifehpWpfffivksfu733WP7O0aKT/5ar?=
 =?us-ascii?Q?JTstitLY2XunSB0FZvY4iS//KyOWoTdzr7eJLa8akXKNtm0iEPVbNNQvk7UK?=
 =?us-ascii?Q?p7kZDrWXQiJ1xMJ5eY1Pww7bdRUbkai7UDxYydTcarFZ4k2UcQPiIuwJxiQa?=
 =?us-ascii?Q?Y/CeYiU2yzoyjrvbkDO2Ks+DmY2iH2EFNSt1idk46GQqTd3UxBgSoFpa0JuX?=
 =?us-ascii?Q?x2LsCNxUPzBklT6uGVOGeMXWxgaA7iwHzBuZNPKPe+ucAcivqt1/XISE8ySB?=
 =?us-ascii?Q?Qo34fTIHTmiUtl2Vxf9KBuXDIvbVpykDGYGR/XvuS7SjXTKeYjG9LMZZgZEz?=
 =?us-ascii?Q?USDPsdW0EtsOXuody0Y1SVm5hPT8CWzz93lHaVzpY9ypL8uy3yFNajdF9cpD?=
 =?us-ascii?Q?oIOasoClM0Y2S7ed7eds4g0FfiCU/C7r++TXdUAsOIsyVGSyavuRdEGRUVkU?=
 =?us-ascii?Q?1HGYf7sC9yQXNwktMMqtDzWqk/eRWi2mSsNoKC9kt1g1IkFHMsP93AvZMy3Z?=
 =?us-ascii?Q?GpAY7FjILHDOeFnu2W96hmCheFrvyVT2o2A6WkgEzxroxCMIngL5BDlt9bhr?=
 =?us-ascii?Q?w85oBU8WyNxztSOC4Q1aMnQpAM4t2e7NJK9RPeE3KVm7e1PbIxEQggrdRVvh?=
 =?us-ascii?Q?k3Zt8Kwnqv2fzZArZHBfGjQam6WlQFVkoyIWj7aANntiQtAU175MZpIOLslx?=
 =?us-ascii?Q?D0TInkpQRYTUPGJ1+vh7WtHTk+1hZAqtX7B1/Ly10l18Xrl7g0p9ZJ8lcDEL?=
 =?us-ascii?Q?KED449MiOxy2279TEMc0dc4uMTGgE4so/RnRGB+9YsNYWyK8bZ0Fhhk7nm7Y?=
 =?us-ascii?Q?i7r60dMp1mSDhEDi6e0zaoYCDTpAkv/s93ki19L7+7+A6NFgEXQWcsOCrHzV?=
 =?us-ascii?Q?Dq5Q69EIG87EmkTruDgG86Iq4570nj5UFpcNfx7aiDMVFbSs9xGNlsTWuPol?=
 =?us-ascii?Q?OLX+QZOlZqwloT+Hhr0BwsPft1+Q7jrA6zevBkl6rqgkMoxLhu6PCl8u4bTp?=
 =?us-ascii?Q?8mHTa2iLT2y1opUybgwDaltAs4DPHLt0vJc1lOcqnSJIptrCjITIjFNTGXwO?=
 =?us-ascii?Q?k0aJ7hFzsc1n4HnlY/G9NtQgzgJAKFDMvw8g4TNgJnSAroQAYVHEH5ZjaPda?=
 =?us-ascii?Q?3zhn2zJDqPK0d33t2Fh8N1rovdxIo7EWwDZCJt/on0M8Kx7bZ/G5FvMdZjZL?=
 =?us-ascii?Q?3euEhtJzViR5zVgVsCrvG9/Up0MmLBWYodR2Yq8SlzLXDy7qtk6u6WDwmjH4?=
 =?us-ascii?Q?qEbrbrQs2djX8EpQbf4hhJn8XER5w2awr9l7VvAB?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e8949d48-5d78-455d-121c-08dcbc350dfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 07:45:23.3610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AtFTL3f1deG/lU77TXtvoH3IwuvfZgE2tIG336dHLkPPX99PtHJWblQ7Kli5QmxRSfe8H4MaUU3xj6Xw1gDSIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: intel.com

> From: Zhang Zekun <zhangzekun11@huawei.com>
> Sent: Monday, August 12, 2024 8:08 PM
>=20
> The definition of mdev_bus_register() and mdev_bus_unregister() have been
> removed since commit 6c7f98b334a3 ("vfio/mdev: Remove vfio_mdev.c"). So,
> let's remove the unused declarations.
>=20
> Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

