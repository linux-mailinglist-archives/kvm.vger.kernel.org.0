Return-Path: <kvm+bounces-24100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 139DE9515A8
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A8581F21E68
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 07:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A67F13C67E;
	Wed, 14 Aug 2024 07:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U4e51j0G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AC87F486
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723621111; cv=fail; b=bv1UNZjZK+gshQuy1XkxQJLvE1FyEJgffhifExWdketFbIhopNlAhx/me/V28xMzEB4gTByi1O5UTF2pqJrtztQg2RCMCWEuvxIekVW6JsBgl7r/XDoICzIQIcNBfhkwYGF5RzLoMBBQz4EBXOkTUzG6QxPY+y33FrpTKqzfpSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723621111; c=relaxed/simple;
	bh=4UH+LZJ1CJyeId/RdlEGH4DTJPL/6Rekrm1FIsEyaEo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sFf8cyHM4OowLOXprirmOyMqp7EbfVWeL0/ooKYMbSSkINwpQKn6v6qZrAMpv+xmxiTrd2dcNcxDzFqcSRLGyK/LigpEl3oD5k028eYqF7F4RXfIImJYxkE6MMYj3DmjjJyclDLUh6OQkY2iNj69WcLPBM4OWed3roBGREqft1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U4e51j0G; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723621110; x=1755157110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4UH+LZJ1CJyeId/RdlEGH4DTJPL/6Rekrm1FIsEyaEo=;
  b=U4e51j0GSh77OXLg1Cjkkbs+nfNCxjIYpl6fLABXaIrkOKCCOQONZl9w
   FgN0+56W8XHd87BwwGJxrIz2gXZUBb0G1IigELMg/JgDJJkN6UXo7ZmZ0
   Ad70aF9f3AqD1kuD3Men4/SHTdOtjnDKBF/Bn2gh8kQrCaAPdPHWhXeLZ
   KxLKBd84BX0JLi4V/EHhMXY8/0CMGJjHE62A6617UBVtlwMkihoY37RKI
   BCqtJNonFWqLtxTcP5aIZGf3VEnNVGbPdUmJ6eEU4T8aHKayrWthHbSSv
   ZyQk7H4sQ6oFgOiog8B3SEZL18cIjwED2pHIe3tcZ0pKLuyZqLEqp6b+1
   g==;
X-CSE-ConnectionGUID: 5lTcT+hzR9ayUH6C+XVSig==
X-CSE-MsgGUID: uHFzi337TGCYTAcTNfhWjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="13000649"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="13000649"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 00:38:29 -0700
X-CSE-ConnectionGUID: rWpsoA8wRB+l4HtRjBQeeA==
X-CSE-MsgGUID: QlDqU6NWTJ+mXQfBYmbe2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="58804302"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 00:38:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 00:38:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 00:38:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 00:38:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 00:38:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHJ2AfkNBQRwp93ktMXhMrVUECCQbkDmgm+ut+R3sXF0UQj38/wCgDYnIDn0/o3qHcgyIpDkWNJdl3v3E2ZqCUYfrGQCdDxnmLlVqxqcwjMEQIjQNdEESne8Vi0C8p3GbTEnnwwPtLZQTG+p9p1sjuaCAtlgTnLxAYUGIBzh9xJ8982Lk3coWezlGkpkoYGVhOCnuQEapTB5643JevDAauW3LNEVeApl1Ia4s4nkQ6QeOtfJQp+sgnWXyYFUblKivDT5LvrjFwwEQ5v8SVCjFr1mRBB2wRaoDhe13YLX86p7MfZlu3W32AU94AUYloVT3F1unhs7e1MxIXizh1IIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UH+LZJ1CJyeId/RdlEGH4DTJPL/6Rekrm1FIsEyaEo=;
 b=aLnXu9EnbrpQ482PfrzVcrJCD+WYNB8hBCB4pEcjTqEVi/G/sqwfZcK6U28ZvFLG8LlHiQjPM1RLicSNVaiWh+TdFIwqEDV0QkYJwhkCXpl6ozbp616uUQhFBgqMAtLcqCP+mJZUB4tXT1cXksLR6KAJrj0PqC3v98U5+DmnUbMTx55SS9mSLp7ti+xswdTEaWL8Y3sP/9W+9Hzxjze99NY5KseoPlDu2V3kpXyhcR4pgbzWiziiXFtrIkTulB8zR4tayxezd16SNjDdohqiWWLnWRkw5etdLlAFTn9YwrBy9z2+BP+CNnJarkn+mRe9meOLSoHh2S7RgrpQNL5Aaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4581.namprd11.prod.outlook.com (2603:10b6:208:26c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 07:38:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.031; Wed, 14 Aug 2024
 07:38:26 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgASNTwCAhOTNIIALrw6AgACT05CAAPXvAIAA2q0AgAJglQCAA7rsIIACSgqAgAwRjgCAAAv6AA==
Date: Wed, 14 Aug 2024 07:38:26 +0000
Message-ID: <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
In-Reply-To: <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4581:EE_
x-ms-office365-filtering-correlation-id: 5f7216c5-0cea-478d-f764-08dcbc341560
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TG9sb3ZteGRnZE9vUjJkSHhwTldHanEvMWFpaDU3a2dMWkpVam1aL0plWHp5?=
 =?utf-8?B?cDVOblhYd2FRNE1lZXFpVnlLbC9EUDNMZmJqMzQzbmZ5dFBGV2hRenc1Mk1y?=
 =?utf-8?B?NEh6RWo5NE9ZbG9DcHFHSHBHSDEwYWdibWZEa2JNSEFjUXE2QzFLMFA4UExx?=
 =?utf-8?B?NWhlTjdyNUlqWE05Y1ZHQTROY0RQSjhxWURXcUFPc0dYMGduQ3RJQ1RBd3JJ?=
 =?utf-8?B?YTh0b0t4RmlvbE5wVUFicjdlajBERnc4Y1g5aVRxSVhEcTFRaVh1K01pVzNk?=
 =?utf-8?B?UkdpTVgybmRKbTNGT3NINlZib0J5VnRkNnpzcVdZT1hYR0hSYm9IcEc0dnNu?=
 =?utf-8?B?WnA5RDI3M2FGb1h4bWQ5aldGdXB2WEZZdXFIWVA4RHk4emp4Qlhyc0I0eSt4?=
 =?utf-8?B?Ky9RRmFlQkdEOWNBaW9PMjdTbmlPNmlSVmdrN1BQNGpKckR6aHhIcjZuZzM1?=
 =?utf-8?B?RXdFamNMYk5HTy9UcEZVSkg0SnFjM1lLREdhcUdjM01wdForenFxMllUSXkr?=
 =?utf-8?B?TWlJeDZ3dTRjd2h5ZTRyUmRkVlJLMjhvNU5QcnFYNWRVYldRM1JOTjFEQld5?=
 =?utf-8?B?NGZ5WXZWZWdFNHhZVkg0K2FHTGgwMFNsaUtyaDg0d2pudDBFTEc4Mm1KeTND?=
 =?utf-8?B?cVI4UUZ0MGpSSFUvcFVBYUpERkhuOGhHeVpVRmZ3VzZEeC9KaVV6QjM2SUpB?=
 =?utf-8?B?YmVEM1R1ZFFhNXR5OTlVWnFwZVNjRC93VjkwTlNNYVdsRmRFVllIUDRtNWJV?=
 =?utf-8?B?L1lwRGtLbjh1SGFDdXIvT3BEVWtQT240Q2VFZjgvQXNya0NRQVVhbno5RnEy?=
 =?utf-8?B?eVBiRHVzdHUvSE1yTVBwUDd5WHhwbnpwMGw4Qld0OUdLYWVSeFNpQkpuY1Nr?=
 =?utf-8?B?WW9RN0ZmVllEUUtVNGJCbkxlUDNDOEUyVmtjU0pxQVdVNmJZaXZEbTRjY2ht?=
 =?utf-8?B?RnVqZllmUG9RNE9MT20zaG9GREVnZ3I0NERScUtKTlk3R1pNek9uMDhuWWs3?=
 =?utf-8?B?TlMwT1VTYmNHc2xkSno1Y3hQWnJQMTlwWStLeWxKZGFjQXJIK2RKa1ZJUXNv?=
 =?utf-8?B?ck85VXNLR0tjcG5oYXRHS3ZUMmw1MTEvYnZISlBnQXRmS1lSVDA4dU1ZWVAx?=
 =?utf-8?B?bjRUWHl1bW5MY2YzbDdpcXdMNzdWSFBDeUhYT0h1RUVaS3NzdTVnQzErWkl4?=
 =?utf-8?B?cSszNWtpNkQvOWlZN215Uk95ZjBwWVdjYnIwRE5BOGFncGduSEc4bmZrNUxa?=
 =?utf-8?B?YXBDWVhDMWczT0JmZ3h3c2YyODQzbUdOeTRSTnZEdld1WnZOdDZZdE50OHIr?=
 =?utf-8?B?RGFGRWJxc3JCQWNUR1hRclhEWkpNcEtzZlRuTVU3YkFiM3ZUUUpyL0hqdnVu?=
 =?utf-8?B?UzE2bEs5a3dCODBDL3lQZHB4Vy9DSWQ5UVJWRmdyeXJaUXQvSXh5QndZclIx?=
 =?utf-8?B?SmkrMkpkU0VTa2MzQ04zRkRWbHpFbzV1cjNVRy9NVHdWUjNPVk9nTzRIY3hV?=
 =?utf-8?B?UWRWazNjSWpwMTRhRmRJSUlYcVpxZ20yK1RKQS9mbmNmZU1jNE5ySmNMSjV2?=
 =?utf-8?B?UHhXdVpBUkJ6K3hkMnFBUkhzaFhZamZQaEhiZ01LeGUvRHlmQUJMaEE2bjdX?=
 =?utf-8?B?ZnZTVzAybnl2RWVmNURjd0t6Z3I4djZNQzRMb0ZuL0tQNWdEM2MyR1BvbVVs?=
 =?utf-8?B?L0J3QlEzTGJzYlBSN3hwUnZONTJ3cHB5dkVaTkZ5cFFldFhwelNyUlRmOUhY?=
 =?utf-8?B?ZUg0VDFsR0FtdTZmMnNwTjlqOW1zMDJMRjltTmp2NUNqaitUVFdwSFVZRFpY?=
 =?utf-8?B?VDV0MFdKeGxWTnFwa3VyM2xVNXRnQkJXcTBnenZabnlQdlU2bm1YN3lpaGt2?=
 =?utf-8?B?Q3R3UFRxZnFPUERJdGVjbFhuNW1ySUZOWGs2NTVwWFVadnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm50c0ZPeElWaUkwc2s0TjdQeHRqWVlrMTdDbndUSEJRUmthT3AxVlpFb3Z2?=
 =?utf-8?B?ZjNYNE0vczZwMFJpODlLMXRib040aDdhUWNOWEZ0RXhacDFoa3BrRHlkam82?=
 =?utf-8?B?RnB6cm5PYUpudG0razJSaWZYczhwYnFXZVFVMlhzdWxEMFhBVjEwYyswd1Nw?=
 =?utf-8?B?cVEyUWtTYXVvUFhrb3BPanhMUmc1Mlh0a0l0ZVhtSk5QbmZmZGxmT1hFcnZ3?=
 =?utf-8?B?YUF3SnBsRG1POFhOczFHa3RLVy9JR1hTblZ4blNvazdCWnlRYnkyRTRPSm50?=
 =?utf-8?B?Z0ZLMUlXZDdyMk15amo3U3R3TkxJRnE4RFlxMUswQzdTZENRMkNURU1NeUlk?=
 =?utf-8?B?UnVNTmNibGsrcUZFcU1UaGJHS0tNVk9wWlI1S3FUMGRnOHZVdFNiczBtTklX?=
 =?utf-8?B?NDViVzA3S3JHZHVWVWlnTUNVZzU5UHl5aHJraldqaFBkMUpSaGZJV3Z0NjVa?=
 =?utf-8?B?MHl4Ymh2blZpQ3BVVlR6NzAvRUI5Z1ZHM0g4S1dVbHJ6ZWJHTUNDUEV0RFdW?=
 =?utf-8?B?N2JtYnNxcTBycnJkSEs4TlZ6VCtEVzBic2hPMkJ6OXp0Nk1IRE45UXUzdkxo?=
 =?utf-8?B?ZWdJbm5XN0gyTThhYVdpd3llL2I5R3RnNE5mT1hwc1hPcyt3clRER2ZOODVU?=
 =?utf-8?B?b1VZTVlXUHhoeUlYM0Jkc1NGVW93aVFpdmNjZ1AyWXdSN0JCTFBUd2pFUHN6?=
 =?utf-8?B?cDMvT1dMMHdtQTZIQitYZVNINi8xWnJ2SFhOMkxIUkM4ZjZwbFY2N2t0SGxa?=
 =?utf-8?B?MnlaOVEvdGtQcGdXdU9wbytweEp6U0s0cUdiMlJVYUM2cWx6ZktNZVBoaXdq?=
 =?utf-8?B?cG5CZjdBQkhUanNGelUxd2xXMC9jaG1hR0JHQkxCTFM5YmtZWDV5bUhJWWZt?=
 =?utf-8?B?cm1wNStad1ZNeEk0K0JOSUtqdVFNcEx1b0JFT2U2OFlyMnFLTnVaai8xMUV1?=
 =?utf-8?B?RkdQU3Z0Y3pOWmg4N3BROXFadUtvVlNCSjBrZHFPaDhTWkVCVjFJaDRRdEoy?=
 =?utf-8?B?ZGVGaEk5L1hUcDJEYmVlN0FDRFI1VmRFdFg2T1lmS3B0U0tDYUVrT0RpZ2lR?=
 =?utf-8?B?OEFNKzZkb3RoM1RYNk1kWFBOK2cvaE9CbmsvNjVSbFMyOGxqUlN4SU5yWHpB?=
 =?utf-8?B?cGZRQ2lnK2RPTW9CSVcvaE95bmhQdzdvN2NUQzJGMlU4cHZFMHZDOEFMbGxn?=
 =?utf-8?B?UlEvZXNYSkdaSlVOMFJmVVV2MEJKLzE4UGVhQ0pTTm1UTEpRaERxQmUvTk5s?=
 =?utf-8?B?SnIrTTNUY0lYT1BoU0QzalRzcy96UlJYOVRvSlBNWkhpclRKeUVQeGdpbExx?=
 =?utf-8?B?Qk1VbVhFaG9wL0cyQjRVM0ZiRHBwNWhHQ2RqVzhyNFFyK09za1E4MDNETk5x?=
 =?utf-8?B?a2F0TWhXb3pMRmNTbDFLM3U1d1JMcWF0RmNiYXF6aFNsem5XVVVab0tjdG1y?=
 =?utf-8?B?NlRFb2ZmSW5qakhQeC82alduNU5xa0xEKzB5RGhKZXpjbWp1ZW5CZXFBOTBM?=
 =?utf-8?B?MFhxbXg2UDYxZnBldDdMUG5WT3BKZXBySCs3K2hzT1RBNVQ0Z3Z4M0NTNWNl?=
 =?utf-8?B?VU5IUmJ3ajh4QzFRYmwxR09PTHlmUDdwMGFKKzNoMi9TWWdtQytEQ3o4Skwv?=
 =?utf-8?B?VVlLUXVPSFZMTGozTEFIdUEwcmFEcTFibmZCSzZPOTBCWGRTdXZZQXZueXBu?=
 =?utf-8?B?UUh1T1FWT3NzSTRLMDVsNnlVbTFiQUlabE42TmxIRjZHVyt6TDBOcVd3cWF2?=
 =?utf-8?B?OGFhOWEyMjNsa0ErbHdreXJHSU9SU1FCTFpabzkvcDhHSGtHUzB1aXJaa2Rj?=
 =?utf-8?B?cUovV0RQcHl6NVluOWNBOW82UXBkdmtlUDUvaDRvdUlTMkZhaHF5dG91QzNZ?=
 =?utf-8?B?d0graCsxRGd1Y01uTXdoYXJLczFCUHVrd2l3ZlhhM3ZhaXJMNzcrUVEyYm83?=
 =?utf-8?B?MFY1V2NiK2tnS1EweTdoZGF2bjlEYzJwcnZJdS9nN2t4QUh4S0VBSWJlVEwz?=
 =?utf-8?B?MVEwZE1YR2sxM1hqaXZrb1RKa2pRR1FzeDNVQlpERjBCTDgwbFUwSU9SV2dN?=
 =?utf-8?B?ditJcCtKVGVCY1BZNUZ2Y3FMdHZCS0JvTWpodHp0YTZheURNODhhcHFHZWNV?=
 =?utf-8?Q?mSCVVhTCMU7kCIxd+KRAkV2Pm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7216c5-0cea-478d-f764-08dcbc341560
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 07:38:26.2154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fnYnrs0hCW53uKFB45wad8oTjMc30BPdwRBxUk1cg2FBXdZRLoYhQ+Ktaazuy46nZw8ELMyDlEDL86wzDW+7Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4581
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBBdWd1c3QgMTQsIDIwMjQgMjozOSBQTQ0KPiANCj4gT24gMjAyNC84LzYgMjI6MjAsIEphc29u
IEd1bnRob3JwZSB3cm90ZToNCj4gPiBPbiBNb24sIEF1ZyAwNSwgMjAyNCBhdCAwNTozNToxN0FN
ICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPg0KPiA+PiBPa2F5LiBXaXRoIHRoYXQgSSBl
ZGl0ZWQgbXkgZWFybGllciByZXBseSBhIGJpdCBieSByZW1vdmluZyB0aGUgbm90ZQ0KPiA+PiBv
ZiBjbWRsaW5lIG9wdGlvbiwgYWRkaW5nIERWU0VDIHBvc3NpYmlsaXR5LCBhbmQgbWFraW5nIGl0
IGNsZWFyIHRoYXQNCj4gPj4gdGhlIFBBU0lEIG9wdGlvbiBpcyBpbiB2SU9NTVU6DQo+ID4+DQo+
ID4+ICINCj4gPj4gT3ZlcmFsbCB0aGlzIHNvdW5kcyBhIGZlYXNpYmxlIHBhdGggdG8gbW92ZSBm
b3J3YXJkIC0gc3RhcnRpbmcgd2l0aA0KPiA+PiB0aGUgVk1NIHRvIGZpbmQgdGhlIGdhcCBhdXRv
bWF0aWNhbGx5IGlmIFBBU0lEIGlzIG9wdGVkIGluIHZJT01NVS4NCj4gPj4gRGV2aWNlcyB3aXRo
IGhpZGRlbiByZWdpc3RlcnMgbWF5IGZhaWwuIERldmljZXMgd2l0aCB2b2xhdGlsZQ0KPiA+PiBj
b25maWcgc3BhY2UgZHVlIHRvIEZXIHVwZ3JhZGUgb3IgY3Jvc3MgdmVuZG9ycyBtYXkgZmFpbCB0
byBtaWdyYXRlLg0KPiA+PiBUaGVuIGV2b2x2aW5nIGl0IHRvIHRoZSBmaWxlLWJhc2VkIHNjaGVt
ZSwgYW5kIHRoZXJlIGlzIHRpbWUgdG8gZGlzY3Vzcw0KPiA+PiBhbnkgaW50ZXJtZWRpYXRlIGlt
cHJvdmVtZW50IChmaXhlZCBxdWlya3MsIERWU0VDLCBldGMuKSBpbiBiZXR3ZWVuLg0KPiA+PiAi
DQo+ID4+DQo+ID4+IEphc29uLCB5b3VyIHRob3VnaHRzPw0KPiA+DQo+ID4gVGhpcyB0aHJlYWQg
aXMgYmlnIGFuZCBJJ3ZlIHJlYWQgaXQgcXVpY2tseSwgYnV0IEkgY291bGQgc3VwcG9ydCB0aGUN
Cj4gPiBhYm92ZSBzdW1tYXJ5Lg0KPiA+DQo+IA0KPiB0aGFua3MgZm9yIHRoZSBpZGVhcy4gSSB0
aGluayB3ZSBzdGlsbCBuZWVkIGEgdWFwaSB0byByZXBvcnQgaWYgdGhlIGRldmljZQ0KPiBzdXBw
b3J0cyBQQVNJRCBvciBub3QuIERvIHdlIGhhdmUgYWdyZWVtZW50IG9uIHdoZXJlIHNob3VsZCB0
aGlzIHVhcGkgYmUNCj4gZGVmaW5lZD8gdmZpbyBvciBpb21tdWZkLg0KDQpJT01NVUZEX0NNRF9H
RVRfSFdfSU5GTy4gDQoNCj4gDQo+IEJlc2lkZXMsIEkndmUgYSBxdWVzdGlvbiBvbiBob3cgdGhl
IHVzZXJzcGFjZSBrbm93IHRoZSBoaWRkZW4gcmVnaXN0ZXJzDQo+IHdoZW4gdHJ5aW5nIHRvIGZp
bmQgYSBnYXAgZm9yIHRoZSB2UEFTSUQgY2FwLiBJdCBzaG91bGQgb25seSBrbm93IHRoZQ0KPiBz
dGFuZGFyZCBwY2kgY2Fwcy4NCj4gDQoNCmZvciB0aGUgaW5pdGlhbCBpbXBsZW1lbnRhdGlvbiBW
TU0gZG9lc24ndCBrbm93IGFueSBoaWRkZW4gcmVnaXN0ZXJzLg0KVGhlIHVzZXIgcGFzc2VzIGEg
bmV3IHZJT01NVSBvcHRpb24gdG8gdGhlIFZNTSBmb3IgZXhwb3NpbmcNCnRoZSBQQVNJRCBjYXBh
YmlsaXR5IGluIHZJT01NVSBhbmQgaW4gZGV2aWNlLCBiYXNlZCBvbiBpbmZvIGluDQpJT01NVUZE
X0NNRF9HRVRfSFdfSU5GTy4gVGhlIFZNTSBpZGVudGlmaWVzIGEgaG9sZSBiZXR3ZWVuDQpleGlz
dGluZyBjYXBzIHRvIHB1dCB0aGUgdlBBU0lEIGNhcC4gSWYgYSBkZXZpY2Ugd2l0aCBoaWRkZW4g
cmVnaXN0ZXJzDQpkb2VzbuKAmXQgd29yayBjb3JyZWN0bHkgdGhlbiB0aGVuIGEgcXVpcmsgbWF5
IGJlIGFkZGVkIGZvciBpdC4NCg==

