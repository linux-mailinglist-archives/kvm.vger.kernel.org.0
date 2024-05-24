Return-Path: <kvm+bounces-18108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C0A8CE271
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 10:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACD2EB212F0
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 08:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EAEF128829;
	Fri, 24 May 2024 08:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScI0eOJI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18F4208A1
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 08:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540034; cv=fail; b=bKI9y9Xo/FbdMygCwY0kLw8k+IgNyzTRrne/SkXnCUFE5AxLsuKWuOyRPqhlhoMABWMMA5Z5OHn0QoLr2XlFeqCJ7I/3UWBsLqgUEXp9TIhD8S9a2aZ29JTaKs22blhyj8cJt0vCZ3VKzvAyqSvDxsm0prJtJYnPPwzDh/KoZeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540034; c=relaxed/simple;
	bh=h/yITphjNb5IyZq+hVKQo7SiV1whrQ5i+yJ+NXAeuOU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uvQWXrnP2Fe3jk60JU41Xx+zL9H48lB3r/3uuecf4pNiQ5MsvZUXJHQ10IHxrgqsz4MeXUrVRgdzaoyU94GDdQ4Pn6nZEkDHqGjyL48N0rAi7mKGmXtZnXZZ4dE0cCRB5hXV12bjEGe+iEyYtQEbKC2p6IOWv3jZz+p7qUig+ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScI0eOJI; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716540033; x=1748076033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h/yITphjNb5IyZq+hVKQo7SiV1whrQ5i+yJ+NXAeuOU=;
  b=ScI0eOJIXdl54wCx6YN2GAu4AVqJ1wCCI8jHohFf2TD9n4gOsyG6G/3C
   rWx9/tqxih7ctHyJ35vdhqKQigj4eystvIBM3w1mly537B/ahczgXl/Vb
   tlQG7akZw4h1vl+2FYcC3nlpj9GOQjQcXbU3t/s36h+48td4jRCBsMM0Q
   Y5yHlQOH+jRzRYohczFEs9lAe8fJVdu57DzIXesFz84Lsto4JnBoLgZET
   BuGfan/xk7dzu6eb6exeFq+qnxhiylXI+ZL+LBvx8SWmyRZmKhRAJJ0ti
   UT+AjhBjPbvmmewtktwkAyPkjAI7Fr2zqDtCTxfp+s/5vwykU8/LiZGxe
   g==;
X-CSE-ConnectionGUID: 1ymiP7XaRu27TSPBwWV1gQ==
X-CSE-MsgGUID: 18KmJdR7S5eiIXCFGo6lCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="24315989"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="24315989"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2024 01:40:29 -0700
X-CSE-ConnectionGUID: NSRSLd9RQ5aH5ofaAOSJ1w==
X-CSE-MsgGUID: /79Qg1bbRWeTpv1YVwDorQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="33877879"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 May 2024 01:40:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 24 May 2024 01:40:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 24 May 2024 01:40:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 24 May 2024 01:40:28 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 24 May 2024 01:40:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JOmMdvBBjcrc16IpTx826usmZN4QhaDhzgVgQp/I7Nj1F+Jp81Dpr36jvo9ukMyCi0gjNo1YC4hnrzzuhfmjchrzakPmjpssMTKKfHXSqtXDzvlVTsZNrNxZE5q0xNYx1/1CjW6vFgYpzziUHBabiCiRg5BDW/ig6CCNrKAWlXmRUgc9AD7OgsAZ/wtQHKza+uNjT6obmjDsXY+lbk3+fRr2tgnPc9+5ssJhey+kaDle/O6ttIpXgqwvWUIbDqergr6E4LgzuxE77iBexKL3YjcrYIW5fzDI2ccQ1ozrFPH5y1Rf2sy3qIuk15Sm/i8n3/JmVP7o8KDoydBG0NXopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/yITphjNb5IyZq+hVKQo7SiV1whrQ5i+yJ+NXAeuOU=;
 b=UAU0+PkA7oM/g+IsLQPhFZ+tKgpHCNn/7vYvjdasFva46emkDmsPLpda3i8z2RYzcBhRLLnDdNSkWZbbCGfpEtHIfw0F6DfX7YkVLxvAbCc4SbR//CCF/CffY8lFmfuq1kptjNzMxNZdMOnvGTrjORBrZ46GHkw1Tq5FEhU97XPtcfQ5UHPit/nF0tE0tHpSJuytMXl70t4cPc46fpf/oE/yknPQTBTQqDw6gfH+kxh/jIj3DKWZPOM2ONJS5E/ifyFw8RMet96KIn/C8jcte1prWykzydx8q9+mpu+yPZhD57qZWGxfntB2PKnmkhQlYdki3yxed4bzRQAtLiDIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7800.namprd11.prod.outlook.com (2603:10b6:930:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 08:40:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 08:40:26 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Peter Xu <peterx@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>
Subject: RE: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Topic: [PATCH 2/2] vfio/pci: Use unmap_mapping_range()
Thread-Index: AQHarUtexRr63CDGcEKkpW21XYaJoLGlix6AgAACo4CAAIIXsA==
Date: Fri, 24 May 2024 08:40:26 +0000
Message-ID: <BN9PR11MB52764E958E6481A112649B5D8CF52@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-3-alex.williamson@redhat.com>
 <Zk/hye296sGU/zwy@yzhao56-desk.sh.intel.com> <Zk_j_zVp_0j75Zxr@x1n>
In-Reply-To: <Zk_j_zVp_0j75Zxr@x1n>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7800:EE_
x-ms-office365-filtering-correlation-id: f13d3f53-f3a7-4388-a902-08dc7bcd28cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?eVJPWm0rZnkwc2s1TktKRmVoUEtkcFVzbTBnNS83N2tadWwvb1l0aGZwV0FC?=
 =?utf-8?B?YUx5c2w0NGo3Q08yY1FXOEhUZHlwVXg2VzdoVkxuVjA3Qm8wenh1UzZtOE84?=
 =?utf-8?B?VnhLZlZaaTNRTEJ2UVh5QWE1YzIyNFV1TUFsUzdTenVYTkV0VTRNOGg5UUg2?=
 =?utf-8?B?WXRrZG4xcmhkWE5zL1g5UlJ5QUMvV0c0b0pvOHRlTTdDOVAvdVF0MEs5WW5a?=
 =?utf-8?B?Qm9YdmJhZGtzVmVsenhUMlJsYmR1d3FmaFdXY3J3bWlmOERpRklpZHFQbnk1?=
 =?utf-8?B?NTEraE16b0tRWTQxZGRBUUk3WGsveTlHaHlZTVozb25xaHo0bUltbllvL3pK?=
 =?utf-8?B?cVM4ZXI5NXpFUWVrSm1EdzFlRURDOFhoNlluY2RPclNudUJNeVM1aStFZHZU?=
 =?utf-8?B?KzBYVjBTYzdZWTRVTldpUU15QVVsb1lPTU5pOHNTTWlRQUdZdEJuSmE0SzZx?=
 =?utf-8?B?ZmFwOGV2d0J5ZWJrN1JqbktmN0tDdVhleEI3dDZ5V1Jza2tqUjBiWUp6SE9M?=
 =?utf-8?B?TXZPSEJnYk9NZDlSbkFGQ2NSeklXU3RCaHZBMlVLNVVaK0NDM21pMnUrelpE?=
 =?utf-8?B?RTcwakgxTjgrNytxc3B1UDBoNnA4N1FsRm5ibXVnZ1pEZXEydU1mZGZTWXkw?=
 =?utf-8?B?Z0ltOVhFM0RYTVBjNTFBVFRESFc0QStxZ0xKS0ZnN3J6YUZhNm40d0lUSTA5?=
 =?utf-8?B?QWMzYXYwQTV1STYzSmJrUldXbjBKbVNJL05MUnBUZVplQUlZczRuNHF6TkQ2?=
 =?utf-8?B?S2F0ZlV4ejNKZDNZZnBFZkRCZlNwQkgyZVBHdm5RWWQ3U0owK3pzdnBGditI?=
 =?utf-8?B?S1IyWS81ZEtMVGRnRHRPUkNIbnYxVXVBbDVpa3VQbFNVODJwakk1UHJpZ1VP?=
 =?utf-8?B?RWo5RnVTLzAzQVUxNnE3WUROM3I3SjlZczMvUFZQSUFSZUprT0pzeFJLZjdJ?=
 =?utf-8?B?WUdodlBnZ1BzL2dERDJrb1RvVjJkcExwaXc0M0N2REJ6S3F1aXRSdEJoZVQy?=
 =?utf-8?B?UU5WOTF5WStORWh1YXdHcnhRdFRWZktaZllTMVRuK09iTXJvZFFzMkhYeDRi?=
 =?utf-8?B?SDhDMFF2WFpocjVTNlA1aE1QQTRaWFVBMEJ1V2sxS050MTdpZzliU3pBS2dW?=
 =?utf-8?B?eWk4aDJDR0tFU0tSRkV5dUFIQmxSa25kUU1DSlMzdHhERGI4YXpOQ3RtVkVM?=
 =?utf-8?B?cFJVOFN1OGVNc2hxODFpaGdSWFU0V1lUNCt0UU41MnlFbWFseXFheC9GT3V5?=
 =?utf-8?B?eDhqWTVmTzNEQUxVQUoyclBpaDhSbWdNMWg2V2NaZExVcW1LU2MzN3dPR1hl?=
 =?utf-8?B?ZjdiYmc3S1JBbWwwSGtLMU5iR0dzeFpZUzMyRURPTGIzamwvV29zcVdwc3dl?=
 =?utf-8?B?WTNQcitITEgvUHdJaG9tQy9SOXNtVHR5dTVtMmRpQzZIS2MyL0xWdUZFSldn?=
 =?utf-8?B?di9YYUhTZ2RqR2xSVUhvRWhSWitwdUhqTmU4OXpkMmtlMm5JaXNtMGlrWkZF?=
 =?utf-8?B?ZSt2RERnUlBQUnNIMndWYXpBVDN1Uy95SkVuK1JoOEFreThvL0k1cy9HNWZB?=
 =?utf-8?B?YURKVGZxaTN4Mno4L01OVUt3RFo4VC9Mb05lSHdCOHduVFBiY0FCYnhpVHBz?=
 =?utf-8?B?Mm1YUnQ5WHlUKzZDMlpuSk01ZTJQb29HcnUzVW5Idkl0bnVsM05KVjk5SURu?=
 =?utf-8?B?VndFWGc5TzJHZzZ4L2dwVFJNTkY0a0RENC9SVTNvTUxZOUNWR0wyMmNRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cG5XRjVqS0grRENQeTNhblh3ZXM5SEk1VlBpTHJUdm02SVY0SkQrd2Q2TU5F?=
 =?utf-8?B?c1pEc0hubnN4LzB3ZTVaSkFmSFZ6MVRJZ1kvdzlzeDdIZ01EWHEzTk13WVFm?=
 =?utf-8?B?VW9rYUt3V2htMXdxMzFHL2FuTE5vMXJiSFVqenNzdkhpNDBtbHh6TStFV21K?=
 =?utf-8?B?dHpxTHpoQUxLNUtwMGhaOG5DTDMrZnlYaUJ1OHNHK09OUXY3WUZVUjhPUmI0?=
 =?utf-8?B?SHc2c2ZScW1ZNFExbmx3TlArM0J6Y1FEejk4QndLb1hnOEZNWVVlc3JsV2F5?=
 =?utf-8?B?ZjRNL09sZ1NzdnFxZXFVT3orQWx6YVhiOExBVGNkc3p0RE91ZGdCL0ppUTdE?=
 =?utf-8?B?OWxVMDlTY1I3L1FPR25zeVJKMHFyOEQwN0FBUzBPSzlUYnRqSTZ6ZDU4YmZJ?=
 =?utf-8?B?aWNiUmU4SDQrbVNMNVpYbFp6T3FlSGhwWXNrTXdFeXhpeTVHTFVjUWZZT1Jx?=
 =?utf-8?B?bTB1Sy8wd09sTG1YYWEwMSt2dHQ1WDl6aGlUMUM1S3FINXUxdWlkTnJRWHlR?=
 =?utf-8?B?emZkcnM3eFhGYVBKa2VrYzFYczNsZm1EY3BEdVdmQ0l3YTB4TXVrT2c3bFd6?=
 =?utf-8?B?RFR6OGRyN1Z1SUhQaGZWMVMrYUhiMnA2WFRpSXJuRVVlaVNpUEU1d29VQjdO?=
 =?utf-8?B?SWJ4K3p2TjNFZTZIQnNFbkN4WFVhNkhNemxWcHZMa0RSck5qYmdLYks1TUtH?=
 =?utf-8?B?NVNGNEdPYWV3bHVtdmtNVTdhYVhQSGRJRklFQjVSVVJ5YXNMVEVrcU5Ma2lq?=
 =?utf-8?B?bUVFakszYkp5aGx5cXdqVWRtdkJ5OXZnaENTdWdab1dHUlhjMUs3MmttZWhi?=
 =?utf-8?B?aUt3a0oxM0hqUXFFbEtsVG1iZjdCUVhjLzhsQkhGcURuNGVuYXk0QU9VNkZV?=
 =?utf-8?B?dXJwR095M1dIN3VGYVd2MkZZLzRqSkQ1MmI3UHowVmZldDF4T0pYdGQ1RWp0?=
 =?utf-8?B?THdMOUc0VmV3akduZ3lvU3RzTFdLMG1zR0QxNnlEY21rY0VjVW1FSjRzeXpn?=
 =?utf-8?B?NEc3NEpZUDlyOFU2OGxnczhqRzIyRS91WlNzdE90cEswdGt6U1kvY2phN1JK?=
 =?utf-8?B?cG1ncStJRlJxNVVzSTEvK1R6VWlmdFYrWnRRYm90MDNZTHpTQmhtK01kcWxF?=
 =?utf-8?B?TythaGpOQXoyaU9KWUVWaExjTzExVUVua2ZVaUZzcUQrdGtjZkY0WGhTMWRt?=
 =?utf-8?B?YS8yU3U1RUdZZ2kxakZ0T0MvclVXY1FTaWF2VGczQW93ajRVMUpKL0V4Z1N5?=
 =?utf-8?B?bFU3Q0hGb2xYeFFUWi9UeHQ0bFh1eDdSWWJteitFc2hWQXV6U0QzSmplcy91?=
 =?utf-8?B?ZFdFQzVoZiswS0dPcVNWSDN5dkFUQnIrc3lsSW5CaStOc2s5SFRBN1Z3RGtI?=
 =?utf-8?B?UEp0L1pXdklGcXd0Z2d2WVBGVVpSMnRpb0o4aWpNSENHMmtlUnFIWGNJVURZ?=
 =?utf-8?B?NDZDVk45bWJPb3UxRHBYblI1ekw3aFNhSkJ0SWllcVhraTBxQzdLZGJYMXVm?=
 =?utf-8?B?OXJsWnFGOXlIQ0Fjc1NYZDBqNSt1QkxxNVJDOWVyaWFzdHAyMjBORkcxZ2x0?=
 =?utf-8?B?aitxNEtIS3VkdFdCQm1DOVI3d2UxY3d6VlRqMytSMlZqWHVvcnNNK2ZLajVZ?=
 =?utf-8?B?L3VlQ1RUVE1iOEgzeGNvdGFtQ0dldWhFSjVYUTUzUXFDWDZUUVZ0d2VjVm5z?=
 =?utf-8?B?dEx4VkROSlFPSTF4ZjJVMVJEQzRoZDBTWGc4VnBIdGsyZ0c4RUlWYU9YbmZM?=
 =?utf-8?B?alhXWnM2WFUzY09oRHlnQmdDSVJsM1FJTEdIL2JQR01vZll3MWpDb1hsakIv?=
 =?utf-8?B?QzM4c2M4eEllQTRoUnpKNzJORVJlT2x3MnNIU25wbSthRXlQM2VIZUhHSzRC?=
 =?utf-8?B?WjFmQnhHOGQ4elo0Zlk0M1QxK1JGMkVVS3JXSEYyamtMNlNENlJEYVFENzdU?=
 =?utf-8?B?bnZyMjVlVkYzaWhZM28yZHZMNURUOUovMXBnQXVnV1dyVS8reDVFb1VtRGpF?=
 =?utf-8?B?WGMxSno2RnJ4RnVUbnJ3YStQL2ZzT3RaUmtDYVNFMHQrK3V2UDh6ZzJXaEtS?=
 =?utf-8?B?bkl4UUhwZ1k3dVQ0MVlhU3JYUlpQU3BmSTRMc2puRW1FMmlzb1N4aE0zeVgr?=
 =?utf-8?Q?MeCQ/7TIq/ae3bv8bNHOvpD8k?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f13d3f53-f3a7-4388-a902-08dc7bcd28cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2024 08:40:26.2844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ni+VYXKZf7NQsVIrCShr5z+u+84kaXcsyUo1psKSqMVbqdtfi3FkmdEkYv6c2JzF04QrDt6GoggoFbk/BdXeqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7800
X-OriginatorOrg: intel.com

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWF5
IDI0LCAyMDI0IDg6NDkgQU0NCj4gDQo+IEhpLCBZYW4sDQo+IA0KPiBPbiBGcmksIE1heSAyNCwg
MjAyNCBhdCAwODozOTozN0FNICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBPbiBUaHUsIE1h
eSAyMywgMjAyNCBhdCAwMTo1NjoyN1BNIC0wNjAwLCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+
ID4gPiBXaXRoIHRoZSB2ZmlvIGRldmljZSBmZCB0aWVkIHRvIHRoZSBhZGRyZXNzIHNwYWNlIG9m
IHRoZSBwc2V1ZG8gZnMNCj4gPiA+IGlub2RlLCB3ZSBjYW4gdXNlIHRoZSBtbSB0byB0cmFjayBh
bGwgdm1hcyB0aGF0IG1pZ2h0IGJlIG1tYXAnaW5nDQo+ID4gPiBkZXZpY2UgQkFScywgd2hpY2gg
cmVtb3ZlcyBvdXIgdm1hX2xpc3QgYW5kIGFsbCB0aGUgY29tcGxpY2F0ZWQgbG9jaw0KPiA+ID4g
b3JkZXJpbmcgbmVjZXNzYXJ5IHRvIG1hbnVhbGx5IHphcCBlYWNoIHJlbGF0ZWQgdm1hLg0KPiA+
ID4NCj4gPiA+IE5vdGUgdGhhdCB3ZSBjYW4gbm8gbG9uZ2VyIHN0b3JlIHRoZSBwZm4gaW4gdm1f
cGdvZmYgaWYgd2Ugd2FudCB0byB1c2UNCj4gPiA+IHVubWFwX21hcHBpbmdfcmFuZ2UoKSB0byB6
YXAgYSBzZWxlY3RpdmUgcG9ydGlvbiBvZiB0aGUgZGV2aWNlIGZkDQo+ID4gPiBjb3JyZXNwb25k
aW5nIHRvIEJBUiBtYXBwaW5ncy4NCj4gPiA+DQo+ID4gPiBUaGlzIGFsc28gY29udmVydHMgb3Vy
IG1tYXAgZmF1bHQgaGFuZGxlciB0byB1c2Ugdm1mX2luc2VydF9wZm4oKQ0KPiA+IExvb2tzIHZt
Zl9pbnNlcnRfcGZuKCkgZG9lcyBub3QgY2FsbCBtZW10eXBlX3Jlc2VydmUoKSB0byByZXNlcnZl
DQo+IG1lbW9yeSB0eXBlDQo+ID4gZm9yIHRoZSBQRk4gb24geDg2IGFzIHdoYXQncyBkb25lIGlu
IGlvX3JlbWFwX3Bmbl9yYW5nZSgpLg0KPiA+DQo+ID4gSW5zdGVhZCwgaXQganVzdCBjYWxscyBs
b29rdXBfbWVtdHlwZSgpIGFuZCBkZXRlcm1pbmUgdGhlIGZpbmFsIHByb3QgYmFzZWQNCj4gb24N
Cj4gPiB0aGUgcmVzdWx0IGZyb20gdGhpcyBsb29rdXAsIHdoaWNoIG1pZ2h0IG5vdCBwcmV2ZW50
IG90aGVycyBmcm9tIHJlc2VydmluZw0KPiB0aGUNCj4gPiBQRk4gdG8gb3RoZXIgbWVtb3J5IHR5
cGVzLg0KPiANCj4gSSBkaWRuJ3Qgd29ycnkgdG9vIG11Y2ggb24gb3RoZXJzIHJlc2VydmluZyB0
aGUgc2FtZSBwZm4gcmFuZ2UsIGFzIHRoYXQNCj4gc2hvdWxkIGJlIHRoZSBtbWlvIHJlZ2lvbiBm
b3IgdGhpcyBkZXZpY2UsIGFuZCB0aGlzIGRldmljZSBzaG91bGQgYmUgb3duZWQNCj4gYnkgdmZp
byBkcml2ZXIuDQoNCmFuZCB0aGUgZWFybGllc3QgcG9pbnQgZG9pbmcgbWVtdHlwZV9yZXNlcnZl
KCkgaXMgaGVyZToNCg0KdmZpb19wY2lfY29yZV9tbWFwKCkNCgl2ZGV2LT5iYXJtYXBbaW5kZXhd
ID0gcGNpX2lvbWFwKHBkZXYsIGluZGV4LCAwKTsNCg0KPiANCj4gSG93ZXZlciBJIHNoYXJlIHRo
ZSBzYW1lIHF1ZXN0aW9uLCBzZWU6DQo+IA0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIw
MjQwNTIzMjIzNzQ1LjM5NTMzNy0yLXBldGVyeEByZWRoYXQuY29tDQo+IA0KPiBTbyBmYXIgSSB0
aGluayBpdCdzIG5vdCBhIG1ham9yIGlzc3VlIGFzIFZGSU8gYWx3YXlzIHVzZSBVQy0gbWVtIHR5
cGUsIGFuZA0KPiB0aGF0J3MgYWxzbyB0aGUgZGVmYXVsdC4gIEJ1dCBJIGRvIGFsc28gZmVlbCBs
aWtlIHRoZXJlJ3Mgc29tZXRoaW5nIHdlIGNhbg0KPiBkbyBiZXR0ZXIsIGFuZCBJJ2xsIGtlZXAg
eW91IGNvcGllZCB0b28gaWYgSSdsbCByZXNlbmQgdGhlIHNlcmllcy4NCj4gDQoNCnZmaW8tbnZn
cmFjZSB1c2VzIFdDLiBCdXQgaXQgZGlyZWN0bHkgZG9lcyByZW1hcF9wZm5fcmFuZ2UoKSBpbiBp
dHMNCm52Z3JhY2VfZ3B1X21tYXAoKSBzbyBub3Qgc3VmZmVyaW5nIGZyb20gdGhlIGlzc3VlIGhl
cmUuDQo=

