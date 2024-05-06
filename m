Return-Path: <kvm+bounces-16763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0A18BD4BB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 064511C22606
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E7B15887C;
	Mon,  6 May 2024 18:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hru2EpyX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E012BAE5
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715020813; cv=fail; b=hKFpHKwFw+S492ecvJVdjFtqEVK1i06r9+HnTXd9ElByJw2G+WhI3vVQROhTpOivn3Q/jIoEM91yT1Sb6E06qkwwzdwkDI3croe3+gKVKkzmcx5iVrCsEkg1IUh7hqX7YUWG84g3XgzS8OCFeoiqNMIRsnocw3hveBXYeHmXPoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715020813; c=relaxed/simple;
	bh=OLpH+9NpyaUbk4rK2NkL7QEjcnfx85ClYsrC1Nr3t+o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=go2+LWj5DuD1SRmTnoklf+TIIIxHJsU873zQlRlyVITGoDZWZa2g4o8eQC71cBIrlAPI5kEoIAfcNsET3kNB8wR92iBEWuVgQEtlF2D50eFHbp5ZtHzoWWC0LBo7dcBR1s1y2sJcJTLVe/tCgmNU92vdFVDCk6QM3jcUoekM7vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hru2EpyX; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715020812; x=1746556812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OLpH+9NpyaUbk4rK2NkL7QEjcnfx85ClYsrC1Nr3t+o=;
  b=Hru2EpyXt1D+mVwGnJRNDF6kblmsTc4I0MTvzhkjvk1nAUAszRu8oCJc
   H1iyju+AebiFMK2PhGMKe6RsUl0F5F0YpTh3tZNZsNoLxNWu8ugCiI1TD
   YFZP61b/jY1BmJuuhaXJ0TYS71jtgHW17lMf1cVWGZrZJyuuPrW1pnACw
   EkOvKVmhi/dVh1ZkMRoPAcD5mXpYrQTXGj63mn1d6IaRzNa7C2NnkrS+D
   T1EXZYZt4a9b+3Fk6DYFu51EE7tmcmQ6PfVvOCwko3uNM+IO6kcwXShXE
   5zcNb8qleTSRGd4/mskLpgoySf0QU+9lXQfGkYSg920pm9RBew3HhzxZ7
   w==;
X-CSE-ConnectionGUID: kKYU2PI/SUekrwdqcA38TA==
X-CSE-MsgGUID: QZUthd27QWyEwNrmXv5Cog==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="14592237"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="14592237"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:40:12 -0700
X-CSE-ConnectionGUID: Xc8/Wc1wStaJ5M+CrIvFVw==
X-CSE-MsgGUID: hHVLQOoHQ2mLfJMg3qeSmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="32749999"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 11:40:11 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 11:40:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 11:40:11 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 11:40:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHdQpCG7n/bLmkQ17XjpCo9RQLBEDCBshPphU9zMZbfkHjASKYLQJtnPJKyR5atTC0NOoMIeaBeBiwAUas0EkcYSPmELMeYD7tjK1c8dOvcIP/chPoIDXiJYspcR6YdFJt821yj/AG4DfvJtu/Bsk/yyDvfsZPQ3Mqmcnraq/gn9wSKbwUiCdWUswbL3Mxnys+nU8sdiFHcReWMkAJScL1K+GGRL5f4hFPvc/Llhv1x0Ek0zf64CKSDL92aViDA7iv42QmSFQltvCtGzOjGBojWcHnIbkapz7DVx5BbMILjCBgYEXjPubVf2bK2/Rct8DYGHUzFHnv9UroSugBPIlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLpH+9NpyaUbk4rK2NkL7QEjcnfx85ClYsrC1Nr3t+o=;
 b=PFROXArGLpRrzqDzsBWu74mWVSxp60UgPVt6NPp3h0eGHnkayBn5P97smwVYgbCz4/Lz8JhdcYEEpvyxvE1+ihp7WSjZrBzm4eqK1WtDcOTgtie5IHjOGtODD4Q0kzzxRs/qmFQaS0XjS5YcU4ak9bAJOkJiY0jZWN8Pm1ImGp5R+YY5JmdblPczO9JF61yarHW8XsYCxUyXpuV/Y+jU1G2HBd/Fizt/wq1tLpG84vqdmUaO74lDDfFEqGv9wlKRmUO0nn8hCbNUWhMly/339Yrl9Jk/FzXU8kOHueZn2iRUBUxqoEBjRJovIoD/8nYiVLc2LuuskZJkqvocKqVHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5227.namprd11.prod.outlook.com (2603:10b6:408:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.36; Mon, 6 May
 2024 18:40:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.036; Mon, 6 May 2024
 18:40:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYAgAA3YoCAABFSgIAAA1+AgAAETwCAAAWtgIAAAsmAgBD2IwA=
Date: Mon, 6 May 2024 18:40:03 +0000
Message-ID: <322e67ab6e965a70a7365da441179a7fa65f2314.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
	 <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
	 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
	 <ZirNfel6-9RcusQC@google.com>
	 <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
	 <Zire2UuF9lR2cmnQ@google.com>
	 <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
	 <ZirnOf10fJh3vWJ-@google.com>
	 <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
In-Reply-To: <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5227:EE_
x-ms-office365-filtering-correlation-id: 467b682c-643b-4768-8652-08dc6dfbf196
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VWVOVDhqMEVWMFJvRDQvaVppK2RCcEFiblZoZTFBMGR5YkFYaERvaEdpcUFJ?=
 =?utf-8?B?MnVDOFlaTXBkcjhna0JkYnIxOGlkR3B4STFhaGVqNk9GR3BMVUdVenpQRmRW?=
 =?utf-8?B?WDl3R0tsRWd1SWtheUZBQXZOZ0FhY0dBZjNWOEIwNXJ5aGV1NmFmWThXZHor?=
 =?utf-8?B?MG5VTXNHS3JTOWt5cnltM2p2cmJWVW91NkkrTFpBcmdiclFVc1d6VzQrUzRT?=
 =?utf-8?B?bysybjVoUWQrdy8rOHllVzZIemZEclZoUnhuL1Y2dE9CU3lBT2xkbzlFSm1X?=
 =?utf-8?B?QmozcWszOWlqSUNBVGZDVGhQN0ZzTHMwTE0zRmI3M09mbWNld2FYbGpBNDkv?=
 =?utf-8?B?Q2huYXRPZTlhSGtTRStYbmVTVEFpaUQ1ZU9LT05KRnc2RlVIaWFIa3hkVHNF?=
 =?utf-8?B?TGVIWldoT0hDQUpHdklhVUVzd2Q4Z3dCMnBlaXNOWmJBdzVjbDRVS2N6REd2?=
 =?utf-8?B?UlhFaWltMVlwQ0s3OWRmcC9DMHR6MW9LOUtxVjZ3U1M4NCtrWU1UaHRZRjAr?=
 =?utf-8?B?aHhHQnJNeFZvTEdsSldKS3RzeGpDMUpsdTI5NmpZdDErcTNJbjBIczg0SG5R?=
 =?utf-8?B?anpWSXNQa0YzYjljVDVDazI4bXhDRitaSVNLWlppSFp1TmVhQkJLeERoaFc0?=
 =?utf-8?B?azFSaW45bnhzWWg5Ym5FRDRVVEJoTW1waFlwTk9WVklpNXpiZ3lUZU04YzFW?=
 =?utf-8?B?OVpMbkpaL090UjNTb1RnUGhiNUlRWVRxVlBjTksxNWN3VmZYdDAyWDdSb210?=
 =?utf-8?B?d2tlSDBla0lHanZxVjFDTUgxcktCaDlhNCtHbkgzZ29xbmZVRkR1bTNyS1Vj?=
 =?utf-8?B?SGJkMmE0c2M3cWR6c24wd01ubStYUmJBU1N1Y09iaWw2b3lHaE13Sk1iMk8y?=
 =?utf-8?B?VTdSYmxRYzRDZklSVTcxSkN0YnJaUENMT0MyTjdnQUkzVXc4a2RQdDh0N0ps?=
 =?utf-8?B?YVcra1NzTWExd1hjaUxhVFBIQW1SK1pqWDQ1b05wNVRwY0VERlVQbGovYTN0?=
 =?utf-8?B?NDlLYXNsVm9vT3htcDB3UlR4K05ZMU55UStQOFpXa3QvaXB5VkM4OFpRNFFM?=
 =?utf-8?B?dm5ETmF1YzVDMHI3RVI2RmRpNExNOEZwZ0xnWFJvdlJzVzlrUVZDbldwcDNt?=
 =?utf-8?B?K0FDakJCcVk5dWo3SkdEdldHRXdLN29KQXRLdDJLVXhLdSt6Zy8reldVaTN6?=
 =?utf-8?B?ZjJCSjF1YlFTcy96UnpYczRaWnc1cVRraTh6VkFiTEZibFZQTmNETlI5amtL?=
 =?utf-8?B?RHJOa3dwLzJFem40SG11ZmNSY2hZMXV3NnluVUpVTk5haDdKQWx2SUw0VmVL?=
 =?utf-8?B?cFFBbVYwTFJRRzNqcS9Fdi8rU201MmVTUjNZWXZ4dGFtTm1LRjk0bk54cnRj?=
 =?utf-8?B?N0tOekdwOWJPdkhUK2lBODYzUHRQcGUreWRGZnI4SDd3andUU2FaeXJSNzZo?=
 =?utf-8?B?NERlTTl2MjQ4cUxyeG9uaVZudVZoSmZUS1V0VkI5YmlkUFlJakIyQ2x0Ris2?=
 =?utf-8?B?ZzZMc1crSDlkSVQwZHZSYWszS1BpZ1hpSXF1Q3cvcnJhUzBiMDFaRHJZc1g4?=
 =?utf-8?B?U2ord2pkZ3dyelZMQjhxdmpGamYyV2JWbE1NVlZndWVGSUlZL1Yrd1dPd241?=
 =?utf-8?B?eEZTQ3hMbWdXUG9UTURkaUEyeURvLzRwR0NnZUlxWUpzc2lQa1p5UFc5eFdL?=
 =?utf-8?B?RHc4NjRwa1g3UXZjaVg5eTNucGFKZ2RkM1UrdlNqSjlHUXVCai8yRDVtTloy?=
 =?utf-8?B?OVh5dlluRjN2ZG5ZN2hsdTMyMlczaW9LUk9aNUt3MDNPWUR3dkpqTUYvaGho?=
 =?utf-8?B?TGorelR2cDE5NlpsL25HQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3R5bVdjcndDRGtyOW83cVdORXNoeTFWekNnVzBxbFhrd0FUcVY5NUtXWUpF?=
 =?utf-8?B?YWs4bStEb293dFg0S2k5UjBOaGt2c1FWd2RCTUFnSDdLZXpNRkkreDdpK1ZV?=
 =?utf-8?B?VEkwZzUzM3Y2bVNQQ3JRMkZUYU0zMmw5R0pVQWs4Z0hHaTNCMnU3VGJRdjQy?=
 =?utf-8?B?enVPdmUzMVRqdmQzUUxreG83d05adlRRQk1PWFJkR1ErK1h2VWVXS2QzRVda?=
 =?utf-8?B?eDRtZEw1bFFQb21oUDN0dDY1eVc3emRkUEU4U2U0eTdHTTM0b2FFckRtbWxQ?=
 =?utf-8?B?R3JEa2UxUEUrcCsxYmZKUTZyWEJJTmM0enM1VVl4aXo5WXIxN3NITlVNMzVK?=
 =?utf-8?B?VkRYZjUwc05ZSm1UZ01Ib0ZYWHNmRXhOcDFNcWtTVGh5SFBvNkFjSEdKNzZM?=
 =?utf-8?B?MDFkL01sSFVhSzArWUxmMzdOL0MyNmRFQW91ZTVjTFhpdU82bU4zUlJyajBF?=
 =?utf-8?B?MzZoZWtzbVNHblFIWXdYWVowQkJtclZudklKR3pkNFZmVERLbndKQXZ4RmxV?=
 =?utf-8?B?V1VDbzNyaVMxMHVVbkxRQVlPTTUxaTcxWlgvaTFHSkUwTW9YQ0FCMlQ0czJF?=
 =?utf-8?B?dzMvS0dQcnlJVmhnZS9Nb1ROVGtPTTlmRitmQjljNHNBVFdWYnpJT05zenZx?=
 =?utf-8?B?SWNiS2JXZmg4VVRqVFJneTNVL1NrT204ODFFQXJqMkxRdDliWGdDZDFSS2pl?=
 =?utf-8?B?VTFRN3hpL3hDcWdSeGVDU3VIc3pMQ1d0SUFFNWdYaHhHTFgrSzhNTkxjeFdU?=
 =?utf-8?B?U2JQR0tIYnd4VDVrT0tBTzVsc1R0eUNnUktoQWxwN1hBcmRnS2FpdyswUEFR?=
 =?utf-8?B?U25qYjhSZ1ZsNjlUMUpFZlBHWWY4VVYrei9Rd3lqTzZjYVFReGRZWktFSnp1?=
 =?utf-8?B?b2Z0Q2Jtd0dWY1lZcUg0MCtJRU9uK1NHZVFxV29leW14b0o2OTlGUEpaVHM4?=
 =?utf-8?B?Wmpzc0d5OU9SYjJrQmhKTVFjOGFCZkdBazY3UXowakRMVTd1SVFmT2V0b2RL?=
 =?utf-8?B?VDRaVTNsSnViS1dFMXhVRENxaTNxMTJZSUlnOXNHV2g2ZVYzT2xnakJva0s0?=
 =?utf-8?B?VXRDYWI5VzdJbmFQa1MxYUV4Y0FPMFY2bk42T1FMVkkyRm9TZVpLV0pCZThL?=
 =?utf-8?B?bWtPcXhKZHJ1ZzlnRmV1YUJ2MElMMVNwQlRzVVVhVFVSU3Z2L3QwNWovUzRI?=
 =?utf-8?B?cTJLUTVLcVZLeDRLK3FCSzlZNzNTSnlRLzhYaUlBdW9HTmpuRGE5MlFyY0JY?=
 =?utf-8?B?UWdyUWFlOEdRY2xReG9ac24vNmUxQmMvZDZlUFZHbUpEL013UnZwcnJ1SmtG?=
 =?utf-8?B?ck1PNXBTeVV2azRnZm94dGtGRkswd3pQWjVSckQrQ015SzAzLytWYVJIRU8w?=
 =?utf-8?B?dHJMcmhyVFQ2T1NIU2tBQ2lWYzRnWFBJL25qRk95MnBhT0s0MFVidDVpOS8x?=
 =?utf-8?B?N3g1c2VPeDd6bnNRa3lnZFBzZC8rZThGME5hUVJZL3BNZzdyLzNwNzI1bkZS?=
 =?utf-8?B?cHBITlRBUE15NVJZblpDdGNhdldEeXE5TDJUQWFOQUV5VzZvQS8rVGFWdlIz?=
 =?utf-8?B?R2MxQTdyL1g1TkdYUWJINnM1dVFqd1dQbk9KMUE5eC9aZzh3RjdjV1U3d1dU?=
 =?utf-8?B?UmcwZU5rOVZPNnMvYzFXYlhkR3RFSkg1VU5MWFJ5bWg0ZGp1clpsbUJZamlN?=
 =?utf-8?B?ek5ZeC9IODNyWVVWNThZWGJjMElreHlMeTErTThhV2VmRk15SnpvVUtzMCtJ?=
 =?utf-8?B?L09CZ1EwbkNhL3N5NFJsbEszNkhyYisrL2tTT2V1Q3YwR3hRYnN4c3pKN2pL?=
 =?utf-8?B?aUdrOGJZenRpMjVsT2xOeEdTeWJ3Q1BqRUx0YzRQUGZ6Q205OWVqejBuZWFr?=
 =?utf-8?B?RjVMYzRCemQ1SlZRamVWQjNGS3hUWDYxd3VDQ0I2d01KeFFQSzc4aTdTM09H?=
 =?utf-8?B?bzA3TDMrWm5CMzZMaXB5NGhlTFVQdzc1M1EyMlBXaERvNG9kMllIWmdGZjhu?=
 =?utf-8?B?T3Y1MUJSZEFLVVVaUE5CWk9MMW1VaDdUOEJtZ2VMZ0pqMmRSZTAwd3R4L2lX?=
 =?utf-8?B?endyd21oYUZyanFud2JreWNUN29uQVp3aU1XRndYdE40SnFWbjQ5QW8wY3gz?=
 =?utf-8?B?NDdaRXBSbVZmcW9vWDF5UGZ0b3pCc0lOSUlnUWEvWDk3Vk9VcFpOMTFZM0dR?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD4151D24768B844917B0029F03F583D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 467b682c-643b-4768-8652-08dc6dfbf196
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 18:40:03.6552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3OoF55oR0Sr+Qr/FebClIYnLr8PrZ7AcyfvJ5mGGkJLIs20jzxCOD/LWfW8HIslaBxvMV103xCIs6q5sfPhbSQHS6/orQrNKZS7dKHfpbzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5227
X-OriginatorOrg: intel.com

Rm9sbG93IHVwIG9uIHRoaXM6DQoNCjEuIFRoZSBwbGFuIGlzIHRvIGp1c3QgYWx3YXlzIGluamVj
dCB0aGUgI1ZFcyBmb3IgcHJpdmF0ZSBhbmQgc2hhcmVkIEdQQXMgdGhhdA0KZXhjZWVkIEdQQVcu
IChpLmUuIG5vdCBwYXNzIHRoZSBzdWJzZXQgb2YgRVBUIHZpb2xhdGlvbnMgdGhhdCBjb3VsZCBi
ZSBoYW5kbGVkDQpieSB0aGUgVk1NIGJ5IGNsZWFyaW5nIHN1cHByZXNzICNWRSkNCg0KDQoyLiBU
aGVyZSB3YXMgc29tZSBjb25jZXJuIHRoYXQgZXhwb3Npbmcgbm9uLXplcm8gYml0cyBpbiBbMjM6
MTZdIGNvdWxkIGNvbmZ1c2UNCmV4aXN0aW5nIFREcy4gT2YgY291cnNlIEtWTSBkb2Vzbid0IHN1
cHBvcnQgYW55IFREcyB0b2RheSwgYnV0IGlmIHRoaXMgZmVhdHVyZQ0KY29tZXMgYWZ0ZXIgaW5p
dGlhbCBLVk0gc3VwcG9ydCBmb3IgVERYIGFuZCBLVk0gd2FudHMgdG8gc2V0IGl0IGJ5IGRlZmF1
bHQsIHRoZW4NCml0IGNvdWxkIGJlIGFuIGlzc3VlLg0KDQpGb3Igbm9ybWFsIFZNcywgaXMgdGhl
cmUgYW55IGNvbmNlcm4gdGhhdCBndWVzdHMgbWlnaHQgbm90IGJlIG1hc2tpbmcgdGhlIGJpdHMN
CmNvcnJlY3RseT8NCg0KVERYIG1vZHVsZSBmb2xrcyB3ZXJlIHB1c2hpbmcgZm9yIGEgZ3Vlc3Qg
b3B0LWluIG91dCBvZiBjb25jZXJuIHNvbWUgYnJlYWthZ2VzDQpjb3VsZCByZXN1bHQuIE9mIGNv
dXJzZSBpdCByZXF1aXJlcyBhZGRpdGlvbmFsIGVuYWJsaW5nIGluIHRoZSBndWVzdCBPUyBhbmQN
CnZCSU9TIHRoZW4uIEkgd2FzIHRoaW5raW5nIGl0IHNob3VsZCBiZSBhIGhvc3Qgb3B0LWluIHdp
dGhvdXQgZ3Vlc3QgY29udHJvbC4gSWYNCnRoZXJlIHdhcyBhIHByb2JsZW0gaXQgY291bGQgYmUg
YSBob3N0IHVzZXJzcGFjZSBvcHQtaW4uIEFueSBjb25jZXJucyB0aGVyZT8NCg0KVGhhbmtzLA0K
DQpSaWNrDQo=

