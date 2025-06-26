Return-Path: <kvm+bounces-50773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A7DBAE932F
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06D31189CBBB
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A4D2CCC0;
	Thu, 26 Jun 2025 00:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NP2pkKad"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C4D2F1FD1;
	Thu, 26 Jun 2025 00:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896361; cv=fail; b=sFaNH8tCq6w8nAJgsG/g0wx14fAH/UiN9KeFc9JmWKaK4zZYs6+7NLFcH/VpaVGnV62o8iZJjx030bw+Cnd9dHeEXqtXUT4BEJ3X5fDcs0/WoUdTXo1yYy+WgZWiakgsovlVyeAf007xImvNGtZ7aPndrDskm7yP/+fNFV6YC+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896361; c=relaxed/simple;
	bh=Wpm0OdDxqFWkTfTpF89mOdjvcpvxzygwvCIzhtFTwaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gGhWjYPoMt6UZWl/3qjYn9A8BCb7hiU0Q4oBRdwjQMdFNYc+Y+QXy2GEXrLem2bCUzdEa2HXzwid3QXxJrk7VBx9kCpCNR7xad9NGGJc6sAc+MK3bAh5HL6tlNxl/+wnTpUU5GoW0a8G1TA3i4NLjMw4gvUHTz9M4a2unS9BojY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NP2pkKad; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750896360; x=1782432360;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Wpm0OdDxqFWkTfTpF89mOdjvcpvxzygwvCIzhtFTwaE=;
  b=NP2pkKadxku5opKYmYADlRhQa0rxgFrtAVuw4G+BrnVQo20ULK5JclmP
   tEMYNFoxX/zYT9c1tKo+A08Okh8BrZ/iBb2aoX0dn/5MkiUmubjnhVtjX
   chCXoKFixCJddAyTNKynu9225F7NvJrzn21O5vnKQ137Vz9qzAYKROdGd
   CPgnZbZ7l1EW75RHcZ0hlV2f4LXukI7gP0Fg2N9fdiVH1donUzxudLibI
   VxgA58PF5agq1Jzb/Z2+mY8OC1N06AE17dydro7rsbdVZPDN1c1oqp8uQ
   14zRcexfyBLapT71etqTo/sbCR2fDqnAdYloNosdtvmu1sYQNOWc/z3e7
   w==;
X-CSE-ConnectionGUID: 0vf2nZRFSjaRsFTnoLE+gA==
X-CSE-MsgGUID: YWMkPgCER/2TmPKVstJTXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64539134"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="64539134"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:05:59 -0700
X-CSE-ConnectionGUID: U4826EOKTOiZpLcUVBeg+g==
X-CSE-MsgGUID: jMcySTlqS66G1huTR+aeBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="183249036"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 17:05:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:05:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 17:05:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.85)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 17:05:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tEhJm0oovkhmAo4l5sdXwaAnOtr7yupP58hAJvHj1zR0RwqKkMjDJylIY5vd3k5+XPw7ur34h4cTHAsYGRaD4RvzV/aWqNbOcgQjp/0SkCeCPQLmc6J1vBXiBYTfa+JH6WPOdGPC9bKNkB7KMcGidetdqe8H2zRXQgHVcGnk8M40KXbKtmQJPvMXw8O5n36daDWea3fsvDRfpG7L/9Wd8J5ie96e0enhRcid0aUW93xG920gW4Eq+oE+ytx2zC+FFJxOFLRY+dTTyhf662jljSVL8g0r7vbGHkX51+dTt40GtzRu3SQnqtGSop3yABZLHF4UDw0+1hCVECpq54CMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wpm0OdDxqFWkTfTpF89mOdjvcpvxzygwvCIzhtFTwaE=;
 b=GgRNLlFLrxc9wdWHbkQq1It5i80cQUQ7ZWw4WVwO7EQ/g0YDSH9xLJIGBEQEfKNkBWQ8sU8sfz7qZKsXkMZE0+1jBNTYYRZFaPgofb+uJJ36XRM/fI7Mo+7AeAO6yg/yre5gF0doLyFxa1/be6xmy2wJpxVt+kXdQEqhwWMCP1r2zzz6GWhDfQAy4+7HXdGn0+ld1E7rkJ9yjcP9tdZ7DyYxkzrGYXj+gD9xqxupMBH17D/Bucy1mmW0J2+hJmoBKWVQXo/esij6/rDAYdHRzFIvZa7jM/7eTJIoOgJX98fBk84VYpYSaibIcbaO06VJs538d+aJxwE5vJ34c9FTDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS0PR11MB7681.namprd11.prod.outlook.com (2603:10b6:8:f0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 00:05:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 00:05:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Topic: [PATCHv2 01/12] x86/tdx: Consolidate TDX error handling
Thread-Index: AQHb2XKrJt7qU930uUui0Jax44Bel7QUQqeAgABmmIA=
Date: Thu, 26 Jun 2025 00:05:53 +0000
Message-ID: <013baf358a7cfb958df6e44df0ccd518470a4d39.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-2-kirill.shutemov@linux.intel.com>
	 <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
In-Reply-To: <5cfb2e09-7ecb-4144-9122-c11152b18b5e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS0PR11MB7681:EE_
x-ms-office365-filtering-correlation-id: d3c5c34e-49be-4195-3da3-08ddb4453784
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VkMvaGFHY0RGM2JUZ1FDRGRXMjJqamRFNjByMVdrTVV0S1ZKRXVhWEF6M3dt?=
 =?utf-8?B?QjFNWWlkR29pUzdaMHpreFk0S3ZwWitLVzAyZlUwc21lbnpRcUVLbzFrTjZL?=
 =?utf-8?B?enhNbUJBL3pBdHZHZXNjNDBSam9ycklYdElqaHZ5UElhQTVOM2grMGFna2VS?=
 =?utf-8?B?NXJKc0I2SjNraWZycjh6U3pJeHpIUXFOMWJISGV0NER4cTZ2RGxRRVBYU2g2?=
 =?utf-8?B?SEVOUjYzWXcvNmRKM3U2T21wckF5ejRTbFpzOUticWgrK1RyQ3lPcm5VVXNO?=
 =?utf-8?B?bXJNUEJpNVlkUUhtcXhCQTFwdmJPVmJCOWg1MGNUM3FjRStDaUxRRGRQWUtz?=
 =?utf-8?B?NDlQMXNVTVhha29kU0ltYi91bUU4UndldGcyUVA1dDh3TmEwdThjY05wSXNs?=
 =?utf-8?B?QTBDUmwyV0VKNk5YRnJOMWw5cHNScGRxTDhQOTdZK2tnVTBEN2ExL3ljcU1n?=
 =?utf-8?B?R2p6a1hFOFV5eWpIRENXNUxhcTFtd28xbWtqZWpQYXBvUGRlKzVITFZqaElv?=
 =?utf-8?B?M1dZUTBLRk5Gc3huQlYrbEE1V1R6dlJSVnRQMWhiUklJakExN2FyUzJyd1Y3?=
 =?utf-8?B?TkJUaTYvMzBsQ2pFYkJxaUFYakNKMGE5UERJdzh2S0srakVOMkZCdmovNngr?=
 =?utf-8?B?OU5DRllsOVVTL2Q0MWJNdm84Q1plOVNxU2hRNit2NWt0RW5pK2Q1UVZSMUc1?=
 =?utf-8?B?c2o3MW0rTWpsSWhjT3FOY2Y0aytac1FBYkxMUCsxR0lKMWZ3d29TVVVrNlI0?=
 =?utf-8?B?d1FMcmNjcHd0NXVLSEZWbG1scnZaQ3o0T2p5Q29hMW1rOFArV2p3d01HWVo3?=
 =?utf-8?B?dHc5Q1pzOEVFa0xHdUVDR2dUNTZqdFU2WjIxaGNFcG1pQXZsTU50QmovMlhM?=
 =?utf-8?B?V1FWZ2Mzd1BwTUpwOXVBeC8yWm1tV3lIY0VwRUMyVFpBQzd4NFFpMWx0NnlB?=
 =?utf-8?B?NHJkM0x5RWptODlCRUluOTdkdUpWSW1mVk9ZS2JMMC9qUDNhS0w3R296VWdk?=
 =?utf-8?B?MUcvdElrYVF1T012aGUvNE5qdStmY215VUFscTZrNmZkTDVCanlZTEg4cTlM?=
 =?utf-8?B?bHhkV0dBc0x1Ny9lMmdnaGpQRzg4MFNOSVdQck5GdWZqYXB0NnJlZGVLTGdi?=
 =?utf-8?B?SGhNQVJqYXZPeTBjTTVSOHo1Mnl6WjhiSFV1L2VGaXlTQ2U2NWVMSnZNVmR6?=
 =?utf-8?B?T2R5Z0MrcTlBRkc2aFdmUGxYSVFrdjFMd25pMDhlcEF6ZWlQS2hEMDFEV0xI?=
 =?utf-8?B?Rkd0enlwT3BkMENrQzhtbEc5czdvS0plTFhDTXgvSkJETk9EY3FSYURJNm5u?=
 =?utf-8?B?RVZkUGh3SE9STC9Ld3ZnSi9uRWdRTHR1bVV0dFpUSVp0Vk9CRE9NR3JndUts?=
 =?utf-8?B?b3J5eThMakFnU0Y2bGJEdnE0blE0Q0VZb3FWb29idER3TmtUa0lXeXRUWDhz?=
 =?utf-8?B?TjVtam5oS3BEeEMxRU5uUk5aSzIvWXFEK21uaW8rK2lhd3JpeHNBRkRkK21J?=
 =?utf-8?B?OVN2TTFBOXlQVk1VcHpGeGFxUEQzQi95b2p5RS9XTk03eHNWOU1sQWRvSWN5?=
 =?utf-8?B?RFdzSXRIRHpmaXBwMGZmeG9sR0lzUDhpWVQwQ2xNT2FTTkppcmpyNnJOeTBp?=
 =?utf-8?B?MFk2ME9aTEpYMmtseHNuekFBWittV2tvaG8rZ290NzZ3ZmxkdDNXU0ttakZJ?=
 =?utf-8?B?aHdTcTV6MUxyaGR2OCtUR0QxV1Z5YjlEOHdvVE9VZkQ0a0hhMWdlT3h0Y1dB?=
 =?utf-8?B?aTJJUlNXVlVEODZ2MDZRT3JYQ3BQaEsrYXphSk51dmNVODZMQUZ2NnJVU3JS?=
 =?utf-8?B?NXd2aXBHYU96M2YzTXQzS1FTT3M5ZElOckkvK1NrTUVtNVNEcjQ1R2JrUlhX?=
 =?utf-8?B?OG8xeEp1ekRPbTVCb2puU0dkeUdQZk5ueDNVU3NoMDUxVGNtTzFDOUtBZUJT?=
 =?utf-8?B?SDVRWXAzdERPVjQ3cS9qUldvUzRYeXgxYlpHSXprMVJzZXBRdDdIUy9yb3RG?=
 =?utf-8?Q?PQSmg5GxORM7532TVwv/P5r2l73Bso=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTlhZ3o4ZU1SZnlMSTJ1cnBDbmJkTnpTOFRLaWJQRHVHck83UU9FQTNHRzVh?=
 =?utf-8?B?bnl5U3Q2QitRR0JXUTBUR3F4MzRlK1ZOSkhTbitVeHU0dlJxb0Z4NjVHVUNZ?=
 =?utf-8?B?RndGa1UyZXN4QTNLanBvR29EbGlpZzNpbE0zLy9DREFIbUxEUks3Q0JnSzdh?=
 =?utf-8?B?bkVHOGI3Mnc0UDhTVmd6YkYwSU1HcDJYTXh6TU8rNWVmTGNnZ0hqbm16VHFt?=
 =?utf-8?B?MlFGc1pBSUs1Ny9CVFg5SWMrdFQ0NXdHVzdSMTZPN1dKVnlXT1NRdkswUk8x?=
 =?utf-8?B?L2RMVXpDYjY3b0VwcEovLzRBRXJMbjl5NFhnSy9jMTlod0FRNjlSaTArWHdv?=
 =?utf-8?B?Y2tDUDU4ZXVwVzRBOGZ0cS8yZ05zKzJrZVM0OTJpU3pGNkdMeThPMTZZNkxW?=
 =?utf-8?B?dGV0ZTdWTVlPTlMxMHR0NThaQkpjSXBGNVIvaFRTeDJXTTJwQmhMTlJhQnZn?=
 =?utf-8?B?aWhSanBYa1hxRzhSR2FtbnlxN3NRdXFqWktMSmluYmJCQWpzbU9zMWlkUVZR?=
 =?utf-8?B?WiszL0JPOFQzMmtJRGlRTlNrQWlTSGtzRzZ1TDVQdUZhTG1Fa290cU5yU09u?=
 =?utf-8?B?TkdaTW51a21MWlRPMzE2ei9wM0dETlptRVRmc3diOTdBU2tCVW44Ty91K1hy?=
 =?utf-8?B?YmlUL3l6Y09oekxEU1ZJUTBudFBQN21sUEhROVpVVE9IYkFieEExWlJiR2Rh?=
 =?utf-8?B?OW9YTXRLUmV5bm5iVmVBdjdyc3NVMS9oRHFhSVYvQWRpdnlMenEwVzZhZmtz?=
 =?utf-8?B?N3JEeWVhWTVCZzkxOU5FUkVGemZPMDlWMkdBMTJYM2RPbG9JRURKTUhKd1JE?=
 =?utf-8?B?S2dDeXBrdExpSmdsaGVuMUFPL1NYQjZWbTBRRlE2eDdwbENYWFQ3NkdKTTl4?=
 =?utf-8?B?WnJNV1h3VFR6ZjlDSGRUWVhVUjl5c1djTE13V3NZMjZhKzZLalpjUkFQU2xQ?=
 =?utf-8?B?MVorMzRKZDA5d0IrQndoc0JPeTNSazNITkVIVjRFTXMyQ0haMUR3b216SlJD?=
 =?utf-8?B?dFRZL0tGWVlMcmhna2h2L1I3ZlBqWFpxTzczekwwOEdOU2h2K0tkN2ExdUFO?=
 =?utf-8?B?TUc0STFvbk9YYVdHckFZQnBjSGpkOFFublg5Vlp6RytoY1hrUzVLNlVHdnhL?=
 =?utf-8?B?U2NlYWhJMnRmNXJMcFZMRmZmTGhmR1l6MWw3bEJJd2lDR2NOcTJVSzEyYXE5?=
 =?utf-8?B?MUw2TVlhOXJJUGJxNUhBM1JkR3VRUThwOUM5TXR1WnVCcThldkw2VVVsWWg2?=
 =?utf-8?B?d0FGb2lHYml2SXRRTGR2bWU0TUl6dFBwRkJ5aUl5MkpHeWFGdHNIYW92QnpB?=
 =?utf-8?B?Nlo0SDZVQ1Z4WSs1YVhZODc5eVozcnFCMkhreVNQYlhaUVV5dDUwQVdkY2Fs?=
 =?utf-8?B?bjkyMFNsSkJkd1h0OVBMVzl2RHpsaUFlY3ZnOXRxUjdWb01hTVVSMi9NV0Z0?=
 =?utf-8?B?Zm1xTHBkOWtUbWhPSHYxU0pWc0hETG1NckdaUVhXMmRQRlV4UUNKRWxmOUtj?=
 =?utf-8?B?angrN3ZjY2hESzh1TFoxdVZ4M1dkQUNvWkE3VUE1RW9ndlFnSkFKbW5vR3Zj?=
 =?utf-8?B?R0Z0S3pzUFFjcCtZZmdySUhybU5OTUhYS0xwWFo2NzVWb2pYdElkRGhIUWF0?=
 =?utf-8?B?T3p1QVlkODBXeExDbnJUVXVXcWhMQmFrWm8rRGRybXJxYzJyaTJFV2JodkZo?=
 =?utf-8?B?Y0EvNVZ1aEtpK1dCOVU3MkhVV082am83dVpaMm1rMkNxUnFxUHhCNkxCMkI1?=
 =?utf-8?B?T09xc2JyMkVnMGdYMmorUlplSmJvcE92RlF1SXo5ZTRLbWprcDNnTFpqRE5o?=
 =?utf-8?B?akNTVVE0QUxpT2FpT054NnQwRUVNS1FsSnlZRnh3QWNCOE01NmR1NmsxaGk3?=
 =?utf-8?B?QTg5RW5iN1Uyb2RqZW1vN0tVUVRKaTZJU3lWYlZjZER5RDhCcVhFZlp3OHY0?=
 =?utf-8?B?R0FPWXQ4aGRTeFdKS1R1WDJZaU4ybGUxYVBpS0RQNitYQUt6RFFVMmRzSklO?=
 =?utf-8?B?a3hndWczVzZNK3A4UHlzRXlqa3BKVjl6NUNyNmxaZmpuVUloa3M0M1QyaTNQ?=
 =?utf-8?B?TWx4WlJMVDlvU2E3VFVCK0FJK1BTcDBHMTFYN1REWXhRbkV1U1NJMHhPcEZW?=
 =?utf-8?Q?9Gg6u/KF1mDgd2UlCP2f1voet?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CDFA1E8F86F0B49944DDE84ED7FD440@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c5c34e-49be-4195-3da3-08ddb4453784
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 00:05:53.3201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DIdukC3pCHQJattT69b25RoTgC5UppOkqvMOXfuBvnIF+Xc+DUxc+aS/PDV2jtP6knIZj2bR5fjtRfKfsdsabA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7681
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDEwOjU4IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
ID4gLS8qDQo+ID4gLSAqIFREWCBtb2R1bGUgU0VBTUNBTEwgbGVhZiBmdW5jdGlvbiBlcnJvciBj
b2Rlcw0KPiA+IC0gKi8NCj4gPiAtI2RlZmluZSBURFhfU1VDQ0VTUwkJMFVMTA0KPiA+IC0jZGVm
aW5lIFREWF9STkRfTk9fRU5UUk9QWQkweDgwMDAwMjAzMDAwMDAwMDBVTEwNCj4gDQo+IEthaSwg
eW91IHdlcmUgcmVzcG9uc2libGUgZm9yIHRoaXMgbnVnZ2V0LiBXaGF0IGRvIHlvdSB0aGluayBv
ZiB0aGlzIHBhdGNoPw0KDQooc29ycnkgZm9yIGdldHRpbmcgaW50byB0aGlzIGxhdGUpDQoNCkkg
YW0gMTAwJSB3aXRoIGNvbnNvbGlkYXRpbmcgVERYIGRlZmluaXRpb25zIGFjcm9zcyBLVk0gYW5k
IHRoZSBjb3JlIGtlcm5lbCwNCnNvIHRoYW5rcyBLaXJpbGwgZm9yIGRvaW5nIHRoaXMuDQoNCkJ1
dCBhcyB5b3Ugc3VnZ2VzdGVkLCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIHNwbGl0IHRoaXMgcGF0
Y2ggaW50byB0d286DQoNCiAtIE9uZSBwYXRjaCB0byBqdXN0IG1vdmUgZXJyb3IgY29kZSBmcm9t
IHRkeF9lcnJvci5oIGluIEtWTSBhbmQgVERYIGd1ZXN0DQpjb2RlIHRvIDxhc20vdGR4X2Vycm9y
Lmg+Lg0KIC0gT25lIHBhdGNoIHRvIGZ1cnRoZXIgaW50cm9kdWNlIHRob3NlIGhlbHBlcnMgKHRk
eF9ybmRfbm9fZW50cm9weSgpIGV0YykNCmFuZCBhY3R1YWxseSB1c2UgdGhlbSBpbiB0aGUgY29k
ZS4NCg0KSXQgd2lsbCBiZSBlYXNpZXIgdG8gcmV2aWV3IGFueXdheS4NCg==

