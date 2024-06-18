Return-Path: <kvm+bounces-19903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 160E190E024
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 01:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DAA01C23006
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB9FB18A94E;
	Tue, 18 Jun 2024 23:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZ+seac+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B0D1891A8;
	Tue, 18 Jun 2024 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718754281; cv=fail; b=CsiRQ0gvxOXJwUy0WSDX/kKh8aGlft2gT/w0wR6RpkkQjsb21j7xU4reBEy8HTRQgki0yRuNuk7TeN1EL21vVky3eOD24GzUQEk0lfBHvPb25t5XSn4AdOUc8tZGVByDPqj8HijHl6zdETVvEkyqaRhvkqE6I4ACObOETMKnYSU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718754281; c=relaxed/simple;
	bh=dfQ7Q0ucm1qg5aeVIpaNYskHeeHshBnu75pZrJZzlWk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a9WxMRwgSprnxpVzVj+1p5wUT9DkgdJ6g/AkJZsjewAT483c/YNA4KaHX4pERWMVvdN/KpiPdTZGYcygLY3EQ5XWs6gHuVgRhR5DGjTfP66QCznLyVLtd9X9XhgkdN602CNqBzLq63IDcE861De1lMtMYUWyTzb4Gv4HSs1IAIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZ+seac+; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718754279; x=1750290279;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dfQ7Q0ucm1qg5aeVIpaNYskHeeHshBnu75pZrJZzlWk=;
  b=PZ+seac+wTHK5xZ0zrAVmQExw3cBJhI+Rq9GId+DEAoLiIHTcTdRwUe4
   bxgjVDDz2lqCoNSaFtQsCYKTueGmA6Bs4dNlmPE6IVO2ftBOwcZlpI2GZ
   B9U1aBSq6NCaenJ3ie/HxYVUnCkoDRjRDo+28UAiz1837+gH9GVrV/s4j
   SxYqH7RotesXMBtZinvZPlwTEX2urCgUiykm6cWABHFC+vYIhgHiRj9uM
   llcOTpuTcU+MBmipN2XuFZlgr2sksrg67bona2XyguhDW5HwdrAuxeonV
   XeXQ51JQks7uXktqhIQOxTYnxMoOH3ZUKzjLsXJxrmiY/YMgOzylAoONz
   A==;
X-CSE-ConnectionGUID: 1w+MiDMMSFC6uzYVth+khw==
X-CSE-MsgGUID: lO+ZtegLTHqgb2XOdediHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15797317"
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="15797317"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 16:44:39 -0700
X-CSE-ConnectionGUID: oKFMxvrhTqyi5qMpmp9Tkw==
X-CSE-MsgGUID: NE5wswvSRPi6lpenxtqNHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,247,1712646000"; 
   d="scan'208";a="41572654"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 16:44:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:44:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 16:44:37 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 16:44:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 16:44:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZL8rTgKTge+ok9PxwgdcA4tVLCZRNEEFQ1hMszGKi2VRR0uj5Pr4cV1O8c/65fukLxnU9hxzwMizS0FDSaN9TBUbKlWkA/JkEfYQ5nMI4U1V8nMvRJAqrcYeNUcojeS9SXW6H8t6+Gzqk/w1fdF2Pl87XjRMbJQ/U1s/e+1DgrShsDKL4ViUbzD5MJ6w5poW+2u1ZmLCS15VGXHpTl5+l7wYAH0QYFNX6D3ibCvVTeDua9sFQJyFZQd4NMy+ht/4scbzy7dBglOSA+VolMpqeqlq/T6+nkEs1nBqEZLK2w4K0tM8RstobM788X37/+gqs5Fh19Tcng9MOwGMOGvdGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfQ7Q0ucm1qg5aeVIpaNYskHeeHshBnu75pZrJZzlWk=;
 b=ZS4mTHhc0W47E6e3HSP0SZNd824PU4Hs2WAofCKGG+aX2eLfftcOuLT8pwTF9PzPiApZNu+7H5h1tIyVqfZueEc/6HK/tfQK/tgm8DhbD/9KTWGzA+zhte6wFEXEyzZVQnu+a4B6CdMUt2IdUvSFOcYYQKykNkhvd4X+BJLtGyrugLqeQpW6uSqXhnhwpgDBkJkjB8XO/Pjru7PCJXIn43I8GnA45BUX9eBEn1V4at8ZQz2y4sfbI8iGaJqINL+a6a5ldJcqITZtc1wu42k0Hwou0Kuf4cNUfOlnG2nFWoWU6nPU3CGAlZtFeCQ1mvA2D1pXjXFZkHVc8cbmWTt52A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 18 Jun
 2024 23:44:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 23:44:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 5/9] x86/virt/tdx: Move field mapping table of getting
 TDMR info to function local
Thread-Topic: [PATCH 5/9] x86/virt/tdx: Move field mapping table of getting
 TDMR info to function local
Thread-Index: AQHav+UGOEq8aDCzbkWm8BUDGbkzorHNauiAgADIOgA=
Date: Tue, 18 Jun 2024 23:44:34 +0000
Message-ID: <de8de1c36810fa46c58433f550e5c63409ba6c3d.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <c7d85f753172f16238b6b3c9cdb4acf8cbd7bfe6.1718538552.git.kai.huang@intel.com>
	 <e79e8576-1cdd-468f-9ee8-5543b8c6b1d5@suse.com>
In-Reply-To: <e79e8576-1cdd-468f-9ee8-5543b8c6b1d5@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BY1PR11MB8127:EE_
x-ms-office365-filtering-correlation-id: 586c8886-a056-4780-7066-08dc8ff09bb8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|7416011|366013|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?dnVtTkIxSFN6VUtISnZMN1NJUFhnUmMwMitXWEFoaEIzTU93TUxnTHdwQUty?=
 =?utf-8?B?MFJLT09iTmoyVmV1YmpMNEVvWWxWbGVJbkRqTzJQT3B4Y3pFK3ZuTTU5cGpT?=
 =?utf-8?B?SysvOEF2NFNUWHJ6S1VSVS82YlQ2OVJSYWdlMFRnd0VZTmtmbS94ZHZvVjIv?=
 =?utf-8?B?a1hVTFFnME5pNXFzUFM0eElUaVJBYUFRZERvNkdwKzI2WVQrTzV1RjBMc2Ur?=
 =?utf-8?B?TWQyWHBlVVBWbWZiWHVNYnVWZGorbXQzZEh4VTc0SEtIWHVLRjJmcmZBZHR3?=
 =?utf-8?B?dzloRlZMNXNoMzBwWm9aV1UxeU9zMnBQTUVYbVhPZVNzODZwZGY4aFBhMTNI?=
 =?utf-8?B?WEE1NHBuUTcxc3NPVVRlL1gxZGpuOFpZYStSdTBXa3IxY2dadWNUb21pajhQ?=
 =?utf-8?B?aXBYL3Q5ODRDNXJ2d3ErN1ZpUFI5Ni82MDI2NWdGMkxIbmE0ejAyN0t4WjZs?=
 =?utf-8?B?dnpXSXVacTBlSWY2U0xmS3huSWFXTWx3MFg1NDRQMVNiUC8wYmFCdVhnWFhz?=
 =?utf-8?B?blRET2ZSdThHNUJUU0k0ZHpXMksvSFpoTmtuNWdVUG4yamRwTGdFWGxnWlFD?=
 =?utf-8?B?VUowWC9Uci9oKzJ4emhib3RHM3dGcnUwVlBsVHpTYmhUelQvMmxiUkF5bE01?=
 =?utf-8?B?aXB0M21TYnFkRWpMYVZSYjZWd2dXR203L004Z2FvRVQrMHhPUkpUY210OE02?=
 =?utf-8?B?VGZsaU12anRiR0Iwa3Fnak5ORTkvc0QyejRYZWE0Si9DQTVFbFRPZDFOY1Ru?=
 =?utf-8?B?MVhhYSt0UU1VWWxrTWdTSmtUSWozVktBN0pDSmt5L1VFT09EYkF4b2pHSnJ1?=
 =?utf-8?B?VnhLN3VaY1ZlNDBrZFQwZC9UbDlLNXRINytjak9DcDluNXhla0NWK0JmTzRx?=
 =?utf-8?B?eTBBRC9iYVU1NnQ5QnJDQkhEQlAvN2ZMc3ZhU3o3a2ROK05NbHoyNkI3RExu?=
 =?utf-8?B?T2tSVnB0WjJlcWhpZ3hWODlHWFZwSHlJQTJROXY4aFQ5NUx2UkUxcGZHR245?=
 =?utf-8?B?UVpvdk92NElINU9LRGtlL0ZzS3A0WTFPRy9lcUhSWFhpaXBmZ3JaV2dEWFc3?=
 =?utf-8?B?cUtieUVlV0xmc1N5cXdxUUU0bHJyQjlxQmQ2Zkk1QjNNWHpBdXE3NjUxZjJQ?=
 =?utf-8?B?MzRvNUk4R1d2T1pSWkZibUtXVjFHcWpXUFlFMFVGaWlEbGpYSGxBZUFQVThN?=
 =?utf-8?B?cElRdVR6SUVTMjdnek9LYktrR1JoNTFrVkNVYXFYZmZhMDBNS3hxMXlOek0x?=
 =?utf-8?B?RnpWVVlPblJhQ2QxUzYrM08rQTIrbm1XL1p6bGtON0k2cFZhNE84T0lxSU1X?=
 =?utf-8?B?OTdkVDF0emxKS0xJR2JLMXptSE8vcDhIbWxCWjN1bWtFeExLVnFoTzI4NWEy?=
 =?utf-8?B?dG9MZm1LZGtuY2d2MVZKeFRRekJ3a2FHTWtpc3ZIWFYyaFR5Wnl0cVFPYk1t?=
 =?utf-8?B?ejJ3dDdhTHBSUGtIbkFTRmgrR29nekpjdUYvQW5TSG9uWGNqT21CanlXVm8v?=
 =?utf-8?B?a21id1c5anRFR0gwVjFFMGlUVVI0SWpNcmVKWFZ6N0xPUVZqYWR6UWdLa3Fw?=
 =?utf-8?B?bXVxemtyaWIzK2xEZVh4OWJsNmRsbFFveFB2ZGtZYm5HUG9TUGFxWFlGVjlX?=
 =?utf-8?B?ZnhjY3FYMU5VY1VNRWN2czNqTEhOOWFHWk5pL3FnbTJsT2pZbHZ1TFZONGJZ?=
 =?utf-8?B?Z0tXZzlIZ3lZdmRjZ1VyYVJrelZXQ3VQWDBnWCt2ZVN4N2NibGhuWm10NTBH?=
 =?utf-8?B?U1pzUlMvQzRkVG9oZ0RiOUJMd0lNZjhOditIU2VHWjN3MHE3SXY3QXRuVkYy?=
 =?utf-8?Q?BOVoVKrCYWP6ykr8ilnrmqhH2fmd0tKq3QR0o=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(7416011)(366013)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zi9xKzV3R2huWDlJbkV2MzdmbGJWeHVLTW1yWkZHNHcya0FNdlQ0M1dXWjRa?=
 =?utf-8?B?eG9WaTNGYmhmaWx2R05rQ3ZhT1hjcU9SQ0ZpSkRzY285cXVtNEYxd0ZOOU15?=
 =?utf-8?B?NHAwTDJaSDhYZEFHUWdxYkh1SVB6RWhvZ0NNam5lV0ZXK2wvMkZ1cjVSZmJB?=
 =?utf-8?B?TFd5WGFBNjZHQWMwVy9IV05QY1ZaTitOd3l5N3FWVGdPVnZLdThKWXVhWmUz?=
 =?utf-8?B?d1RvRms3VkFwWmgyVVNnNVQ0cDdPMUJ3OGhPVnBHQldlMkRZaVJ2MW1DUmV3?=
 =?utf-8?B?U1BLNTM1MVBvWGJSU3AzbURCcWdnYVNkS2gxdDhJREJhVHg1QS9sRHZLdm5i?=
 =?utf-8?B?bG8wUThwckl0VzRZdnQ4bWFEdGdFenk0eklLQmMzb0VDVCs2cUxBdmZFcXpN?=
 =?utf-8?B?N3lGVGxya1BlUk82V3FGemsrM3lxRmsyYnZkZXhlQzhhTGdWVm1CWGNlRkVj?=
 =?utf-8?B?eWRmcVBla3JyZnJreU1CZmJjb0phZFBsTlZBZnhJRmdWZTBKWU5vbFJGSHFl?=
 =?utf-8?B?Sk1vcUsvM2M3S0RUMzZMRjJ0c1pKSnpHZlVrVFoyZXdxZUNObE5YRitTUlh0?=
 =?utf-8?B?bFVDd1RSb2pic1hCNzVzRkNyNGpLT2hXRGhZSFJ0V1luNG1lSGhJUEtZbXZJ?=
 =?utf-8?B?b2NMRGY1Q00wN0g0Wm9ZcmpaY1BlZFQwWUFRYUV3QmhEVU0xcWc0a1JpTXN2?=
 =?utf-8?B?ZFlvN01VS1A4bU93Q0lGTlY4ZnpWTHN2NkU3emhrZkl2UDVUc2xBMktsYk95?=
 =?utf-8?B?ZTAvR2FXUjNRbUI3ek1kTld2K011b0V0czhOZmtTc0tTWnRta0ZVK0RKSGtM?=
 =?utf-8?B?YXBXYmo5S3pUZ20vTWdBZjNwem1RaFBiTFkvVEJaa09ERjhMWUE1NWx0VTlZ?=
 =?utf-8?B?Z1hwQm8zZTJUVHNGOWpheGV5SkhhQmtubVZMNzNaNXhUZzZEMkJJOE1XMVVl?=
 =?utf-8?B?Sjl2ZUFsbjdIWnRFeng4QS83NG1NTVY5YXJBd29SNHpsZDZPcE9DNUd2OFcv?=
 =?utf-8?B?eWYvRG5ic2FXS29ldkJIclZEaXJqUEo0WHJKVGF2YkpmclN2ZmZLR0xiVkk5?=
 =?utf-8?B?NVJTUkNvRFhrSU1uVStHYjNBelRvNDA4MlR5c25DUVNZaXlYZFZtNDlHbG1U?=
 =?utf-8?B?dndsSUQyOFdvNm5tMDZFM25zYks5Z0pBS2F6WnM2OGhLL3A5Z3laNlBCMVNC?=
 =?utf-8?B?b3hpWHllUGxMOVJiQzhpeFQxWmhvQTlySU11YVlmUmVUUG1xR3YwMmZaNVFr?=
 =?utf-8?B?SnVTOFB4OGJ6aXVMdmxnQTZMZExJMnhHOHV1blVuVmROVE9zTWdrdzBldGNE?=
 =?utf-8?B?SjkxTmRESDYrSWlQR25ONmhGTUJzZW8zMmNkbjNNMS9rSW96SkRsWHM4Y2NX?=
 =?utf-8?B?VlBXRFVEdkdrbWM2QmVDM1FoUm9OMXFtVDU5cGZhMU1uY0RXajNCTWREN0Mx?=
 =?utf-8?B?WEVEU00zVUdiZ2JCUFp1OVlnU0pSR3B5cldyUmt1akpVUHJ4bmVHZW1LcnFR?=
 =?utf-8?B?WlVVd2ROcGFXVHZVZk8zc0w0MEdaWFAvY2tIM1FuSlkyYUVzSW5EbWExQXBT?=
 =?utf-8?B?b1JJcFV1Mm9YKzBDZ3B4OWw0eWl0TlFaLzIxYnBTVlhNeExwaC91YzcyQm9j?=
 =?utf-8?B?Sld0dVNjQnppQmorNFFham9JZ1BhSUs4S1o3RzlnM3lWVjg1aGR3ZUt2LzRM?=
 =?utf-8?B?Mm5tejIzLzRFS3cwVzd3SktTMExHcExkOExkWWtNWmNvbDFZZDZ4WllQcE5L?=
 =?utf-8?B?VStTeVozT1Y5THNmT3dteWdXR1A3ekRxMlprNjFiaEovMWZnRXBNSDdUc2Zq?=
 =?utf-8?B?endoOHF3RjhUajA3OGxVZFFuNHdibW1lMVM0cUNFd3hRTXBsV1p4WTlvb0FN?=
 =?utf-8?B?U0Y4RVQwUjhRTjQwWmNxRUxqaThFOGJ2aDhra25aTHJhb0NsUW9UZFdLRm1q?=
 =?utf-8?B?czlNbDNWd0pmUDhxRTdtNmxlVXBHeEhWRGw4b2g0TjdVSFdJTXhjV2FId2Qx?=
 =?utf-8?B?MFFRR1F3ZnJjellrK2FXN3B3blRZS3NVUHhyR0tJWThzcG5MRWIzLzl3RzNW?=
 =?utf-8?B?dEdGZnY4dXJwU1lKN1RBQnZvNlUybFZwV0dTU25EaW56K1hYM3BIVlVuNHVK?=
 =?utf-8?Q?Rkd2c6OhL9LQ8qNb72vsoqK8P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4B989A7B259D249B93110EC1BC9D0C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586c8886-a056-4780-7066-08dc8ff09bb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2024 23:44:34.7116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J6wxc5/3L8S5Ac2yX01Rg/Yi9U51HarC7l9WNRuR7Dry/23oO5aFQg4mvJUfy0y1BRLuPBkob0sVWmsTs9u0hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDE0OjQ3ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+IA0KPiBPbiAxNi4wNi4yNCDQsy4gMTU6MDEg0YcuLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4g
Rm9yIG5vdyB0aGUga2VybmVsIG9ubHkgcmVhZHMgIlREIE1lbW9yeSBSZWdpb24iIChURE1SKSBy
ZWxhdGVkIGdsb2JhbA0KPiA+IG1ldGFkYXRhIGZpZWxkcyB0byBhICdzdHJ1Y3QgdGR4X3RkbXJf
c3lzaW5mbycgZm9yIGluaXRpYWxpemluZyB0aGUgVERYDQo+ID4gbW9kdWxlLiAgVGhlIGtlcm5l
bCBwb3B1bGF0ZXMgdGhlIHJlbGV2YW50IG1ldGFkYXRhIGZpZWxkcyBpbnRvIHRoZQ0KPiA+IHN0
cnVjdHVyZSB1c2luZyBhICJmaWVsZCBtYXBwaW5nIHRhYmxlIiBvZiBtZXRhZGF0YSBmaWVsZCBJ
RHMgYW5kIHRoZQ0KPiA+IHN0cnVjdHVyZSBtZW1iZXJzLg0KPiA+IA0KPiA+IEN1cnJlbnRseSB0
aGUgc2NvcGUgb2YgdGhpcyAiZmllbGQgbWFwcGluZyB0YWJsZSIgaXMgdGhlIGVudGlyZSBDIGZp
bGUuDQo+ID4gRnV0dXJlIGNoYW5nZXMgd2lsbCBuZWVkIHRvIHJlYWQgbW9yZSBnbG9iYWwgbWV0
YWRhdGEgZmllbGRzIHRoYXQgd2lsbA0KPiA+IGJlIG9yZ2FuaXplZCBpbiBvdGhlciBzdHJ1Y3R1
cmVzIGFuZCB1c2UgdGhpcyBraW5kIG9mIGZpZWxkIG1hcHBpbmcNCj4gPiB0YWJsZXMgZm9yIG90
aGVyIHN0cnVjdHVyZXMgdG9vLg0KPiA+IA0KPiA+IE1vdmUgdGhlIGZpZWxkIG1hcHBpbmcgdGFi
bGUgdG8gdGhlIGZ1bmN0aW9uIGxvY2FsIHRvIGxpbWl0IGl0cyBzY29wZSBzbw0KPiA+IHRoYXQg
dGhlIHNhbWUgbmFtZSBjYW4gYWxzbyBiZSB1c2VkIGJ5IG90aGVyIGZ1bmN0aW9ucy4NCj4gDQo+
IG5pdDogSSB0aGluayBhbGwgb2YgdGhpcyBjb3VsZCBiZSBjb25kZW5zZWQgc2ltcGx5IHRvIDoN
Cj4gDQo+ICJUaGUgbWFwcGluZyB0YWJsZSBpcyBvbmx5IHVzZWQgYnkgZm9vKCkgc28gbW92ZSBp
dCB0aGVyZSwgbm8gZnVuY3Rpb25hbCANCj4gY2hhbmdlcyIuIFRoZSBjb25zaWRlcmF0aW9uIGZv
ciBmdXR1cmUgdXNhZ2Ugc2VlbXMgc29tZXdoYXQgbW9vdCB3aXRoIA0KPiByZXNwZWN0IHRvIHN1
Y2ggYSB0cml2aWFsIGNoYW5nZS7CoA0KPiANCg0KV2l0aG91dCBmdXR1cmUgdXNhZ2UgSSBhbSBu
b3Qgc3VyZSB3aGV0aGVyIGl0IGlzIHdvcnRoIHRvIGRvIHN1Y2ggY2hhbmdlLA0Kc28gSSB3b3Vs
ZCBhdCBsZWFzdCBrZWVwIHRoZSBmdXR1cmUgdXNhZ2UgcGFydC4NCg0KQW5kIHRvIGV4cGxhaW4g
ImZ1dHVyZSB1c2FnZSIsIEkgdGhpbmsgaXQgd291bGQgYmUgaGVscGZ1bCB0byBoYXZlIHNvbWUN
CmJhY2tncm91bmQgdGV4dCBoZXJlLiAgU28gSSB0ZW5kIHRvIGtlZXAgdGhlIGN1cnJlbnQgd2F5
LiAgQnV0IEkgYW0gb3Blbg0Kb24gdGhpcyBpZiBvdGhlciBwZW9wbGUgaGF2ZSBjb21tZW50cy4N
Cg0KPiBJbiBhbnkgY2FzZToNCj4gDQo+IFJldmlld2VkLWJ5OiBOaWtvbGF5IEJvcmlzb3YgPG5p
ay5ib3Jpc292QHN1c2UuY29tPg0KDQpUaGFua3MhDQoNCj4gDQo+IA0KPiA+IA0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAg
IGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDE4ICsrKysrKysrKy0tLS0tLS0tLQ0KPiA+
ICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIGIvYXJjaC94ODYv
dmlydC92bXgvdGR4L3RkeC5jDQo+ID4gaW5kZXggYzY4ZmJhZjRhYTE1Li5mYWQ0MjAxNGNhMzcg
MTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gKysrIGIv
YXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ID4gQEAgLTMyMiwxNyArMzIyLDE3IEBAIHN0
YXRpYyBpbnQgc3RidWZfcmVhZF9zeXNtZF9tdWx0aShjb25zdCBzdHJ1Y3QgZmllbGRfbWFwcGlu
ZyAqZmllbGRzLA0KPiA+ICAgI2RlZmluZSBURF9TWVNJTkZPX01BUF9URE1SX0lORk8oX2ZpZWxk
X2lkLCBfbWVtYmVyKQlcDQo+ID4gICAJVERfU1lTSU5GT19NQVAoX2ZpZWxkX2lkLCBzdHJ1Y3Qg
dGR4X3RkbXJfc3lzaW5mbywgX21lbWJlcikNCj4gPiAgIA0KPiA+IC0vKiBNYXAgVERfU1lTSU5G
TyBmaWVsZHMgaW50byAnc3RydWN0IHRkeF90ZG1yX3N5c2luZm8nOiAqLw0KPiA+IC1zdGF0aWMg
Y29uc3Qgc3RydWN0IGZpZWxkX21hcHBpbmcgZmllbGRzW10gPSB7DQo+ID4gLQlURF9TWVNJTkZP
X01BUF9URE1SX0lORk8oTUFYX1RETVJTLAkJbWF4X3RkbXJzKSwNCj4gPiAtCVREX1NZU0lORk9f
TUFQX1RETVJfSU5GTyhNQVhfUkVTRVJWRURfUEVSX1RETVIsIG1heF9yZXNlcnZlZF9wZXJfdGRt
ciksDQo+ID4gLQlURF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF80S19FTlRSWV9TSVpFLCAg
ICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzRLXSksDQo+ID4gLQlURF9TWVNJTkZPX01BUF9URE1S
X0lORk8oUEFNVF8yTV9FTlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzJNXSks
DQo+ID4gLQlURF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF8xR19FTlRSWV9TSVpFLCAgICBw
YW10X2VudHJ5X3NpemVbVERYX1BTXzFHXSksDQo+ID4gLX07DQo+ID4gLQ0KPiA+ICAgc3RhdGlj
IGludCBnZXRfdGR4X3RkbXJfc3lzaW5mbyhzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5mbyAqdGRtcl9z
eXNpbmZvKQ0KPiA+ICAgew0KPiA+ICsJLyogTWFwIFREX1NZU0lORk8gZmllbGRzIGludG8gJ3N0
cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJzogKi8NCj4gPiArCXN0YXRpYyBjb25zdCBzdHJ1Y3QgZmll
bGRfbWFwcGluZyBmaWVsZHNbXSA9IHsNCj4gPiArCQlURF9TWVNJTkZPX01BUF9URE1SX0lORk8o
TUFYX1RETVJTLAkJbWF4X3RkbXJzKSwNCj4gPiArCQlURF9TWVNJTkZPX01BUF9URE1SX0lORk8o
TUFYX1JFU0VSVkVEX1BFUl9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpLA0KPiA+ICsJCVRE
X1NZU0lORk9fTUFQX1RETVJfSU5GTyhQQU1UXzRLX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlf
c2l6ZVtURFhfUFNfNEtdKSwNCj4gPiArCQlURF9TWVNJTkZPX01BUF9URE1SX0lORk8oUEFNVF8y
TV9FTlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzJNXSksDQo+ID4gKwkJVERf
U1lTSU5GT19NQVBfVERNUl9JTkZPKFBBTVRfMUdfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9z
aXplW1REWF9QU18xR10pLA0KPiA+ICsJfTsNCj4gPiArDQo+ID4gICAJLyogUG9wdWxhdGUgJ3Rk
bXJfc3lzaW5mbycgZmllbGRzIHVzaW5nIHRoZSBtYXBwaW5nIHN0cnVjdHVyZSBhYm92ZTogKi8N
Cj4gPiAgIAlyZXR1cm4gc3RidWZfcmVhZF9zeXNtZF9tdWx0aShmaWVsZHMsIEFSUkFZX1NJWkUo
ZmllbGRzKSwgdGRtcl9zeXNpbmZvKTsNCj4gPiAgIH0NCg0K

