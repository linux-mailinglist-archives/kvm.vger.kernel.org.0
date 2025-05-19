Return-Path: <kvm+bounces-47030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71E84ABC836
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 22:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D2837A9B85
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 20:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F3B21516E;
	Mon, 19 May 2025 20:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2sXbZ+V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D72116F4;
	Mon, 19 May 2025 20:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747685688; cv=fail; b=gkdRkPRFDS23Us44Zg2c//81zITEEdk4D0fIoP2pWePcrusrYAS6mx88I0Rzx+4e+8zuBZNZwL/JaUS3TideXLTSt4X7lByvSkkFMvotwuPrw5JvxyEaz4Ogvm+UKfwODHpjMxrK7uTjNikUedw/VsqhYNzKIB2eOMMoP5ojUdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747685688; c=relaxed/simple;
	bh=nlXV9hn4UuPTeWH6aRsrMCErLqRkXbCduVvkZuUYJIc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kFHQ27c3QCTG9FNTSUioPjaMf8DDmqUG+7fMUZYzP7O6kQrdcEttJwHiZUFE7qJrSrX9uJwXcyGyg/EpUP0bRr1v73eSDp2wfB8cIgVvY8CY1hqxbozGvfrRFg3LhBhPrW8Ucajb9f5S9qLHzFjewiGzlE5n+2rOdg0JWSm8Wqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2sXbZ+V; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747685686; x=1779221686;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nlXV9hn4UuPTeWH6aRsrMCErLqRkXbCduVvkZuUYJIc=;
  b=A2sXbZ+Vn7ZS12qOSE3QcN3ZYyfuCv/NJ34inydYFFFDtKm1jZTYKgKc
   Kac5Pln5XZ7smvou/Jxz5MpYVCDSBBiwQrbDe9CFOgJwO4iHltAgDiNaI
   c/yp5jOT+s74DlTHe0eMofUSyfMjhk63e29+W3A8zSfSQUL4MBPAkPBs7
   RWFnSI9Z14abprqZc4r0p3OewUOtdsLocmvlAeaRWhABJXqlqYKgtK9RH
   j0S0didOh6h7nKFS2YiMrZvgdvAAEv6AdxWE5Ei106b8pAR3uzVejsYv3
   ILXTvpMYhCE5Y09dQ6w0OmSBnDbAwFfbzeaL41Tr2X0ypbTv8RB6FHVCa
   g==;
X-CSE-ConnectionGUID: NBt/qqbhS/6dOsziHXu3Ng==
X-CSE-MsgGUID: u+7rHYJYR9ykKK5EEO6PpA==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60633708"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="60633708"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:14:44 -0700
X-CSE-ConnectionGUID: 2rCwViX7TAqCx/jfEqfakg==
X-CSE-MsgGUID: rlKwunyrTD+fB25pdntWTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139982398"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 13:14:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 13:14:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 13:14:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 13:14:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAsvKRQQt6kZPTnc378EJT/uoAtSUJ6ox1lZLq4RZYniFNb4OcoOEEBjtGaj0NATuiNfDGVnk/Gwjjp2O0ytC3O+qIrW8DZLBHOR299r89tKarT9uEpPeAHtuIhkszdJ/vpnli1sT5t4MkijeeM3zwfT8pkIiwRRyas0k3iRzCKxS8g+cHzWIZrfl4hJ7RA9by2lKiqRVPkuPPm2ehtiFL7foOr8MUWg+ERhe1+KKY7NxZwgCvmg3t0aQzSYcQ0vy3P4ehlpPoRNzVqgSeiqsG0GxaaayswhvmMT7jwntXaK3z9MP7He+LXwcQ5qUIvSydqM3rgxFasUuRmFV1H53g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlXV9hn4UuPTeWH6aRsrMCErLqRkXbCduVvkZuUYJIc=;
 b=bPqE7vs600iKhBanPBJ/T8ehqnBUGmr/YgVHm7w5TFrr/C4dj4mrH+OsLiVP6lCBnNqRUZZYUepiBlb3PvYYv6VdnnrF4w9T3H5riIYCqFe2bzTk3iK4brwkYALzKuayH96cq7LmQo3vGH6KdnFHoidjg/8bD/HBhCKvaalciSsCAvnot/JDlhHtkQtjd48XvijJBvMTC7Kv2iSa4YM0lL2cbNwV0PXI1C7BPXSGVomSUtugQ2nL1vVEkMDShKsjBHMRFEOrYE0FfCNF2DR3VCrA3sbv44+SwvTIdmDsOys6FO9WKT+joXIt1gGNyQs4pIbtLZpIgC83vsZmdIVAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Mon, 19 May
 2025 20:14:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 20:14:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
Thread-Topic: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Thread-Index: AQHbyGdiXv6lSo2xSkiHY9GZD31B8bPZ9FUAgAAsmACAAA71AIAANHgA
Date: Mon, 19 May 2025 20:14:11 +0000
Message-ID: <183f06616d776b8d10272447cd004486ed833399.camel@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
	 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
	 <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
	 <aCtlDhNbgXKg4s5t@google.com>
In-Reply-To: <aCtlDhNbgXKg4s5t@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6097:EE_
x-ms-office365-filtering-correlation-id: 9db40467-5094-4978-d431-08dd9711b7ef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V2poMURhWFNkbitrSEJSZUxoYjFzVGZpc0pwNXBDcXRvSDYyK1UwdDd0ZU0z?=
 =?utf-8?B?ODJlOHEyUGhhTmRGcUs1VTE3V1RHUm1ZSkxYMjhSWk5BbFEzZ2tZVXBtaTVq?=
 =?utf-8?B?TTNGSzJFYnhIdzF5ci90Vlgva3JINVA4QUlIalVwa1ZBUHB2RU5NYnRxSEFx?=
 =?utf-8?B?Z3dNZWozdnl6Z1NUeWVhMW8zTDkzeWVaWER5YjQyRkFPVk85cTNjQnFkRGFP?=
 =?utf-8?B?TmZIUS80VCtzWE04Z1NHN1RhV1dWSzR4QnI3dEJkNkN4UnlNSk11OXVYaDNw?=
 =?utf-8?B?M1k2RmZuRVBVYm5iVFVYRktIOE83dk9NZzhnSGRaUDA0akdqbmZSWGc5ZDd3?=
 =?utf-8?B?SWZWWGExSkg0OGZMZEt3Y3R1SStGcC8wZjJ5cnpQM2JtdVBFYWgzbG5IYXVV?=
 =?utf-8?B?MDlKNzJhVmhoRGEydFQ5WDRCNDd4bkZaUStCNmZ0SnAxcFQrYzMrc3dBUHlm?=
 =?utf-8?B?WW1hcGtOMU5JVCt1cjZhemdYVzQ5QTlsTFNzaHZ3NXo1VVBkUUJsczFUcmpQ?=
 =?utf-8?B?dVdMZ2JFMmRwV21tM09pOWRTVURkZlVHNjl1M0NuVS9QSmhscnFGZ051ZlYy?=
 =?utf-8?B?bWxIbXBDNnA4aGJEdUhJZHRQc1ZubURYdVlSbVpjSkJodUdZN1dlTHBHSjdC?=
 =?utf-8?B?Q0c5UXhTZURtdDA3ajlQMm5nQ1BKbnBlZThERGlNOXpMclJRb29saks5T3lV?=
 =?utf-8?B?a0tLWVh5eVd0TS9YY2xqZGQ2eDNqT0xKU25XcEpRc3N6MlJjdVVDVEg4Slh1?=
 =?utf-8?B?bVA1c1hFcHRmYjlWSzFKN09BbzBvOEJzVlpLbjRTSzRyTHQ3WFpEQ3VwS0Fx?=
 =?utf-8?B?OTBMckJnajFMMEFSaDZiZE9SR2YweEhKdmk1ZHRScTViMFVZU1VLdlJ0dlpu?=
 =?utf-8?B?bnZJU05aV3RLeXh4UGFlNUZRTjNHVjM0Wit6VVZLYmJVT1U0WkxEVkdZV2RS?=
 =?utf-8?B?bDhUeUtaNEh3d1hKakdkekdRcjQ1Y2JUSW8xbU1SWVFXOHN1SE9rVVRzcFhM?=
 =?utf-8?B?ZDhlV1VEQmtQcXM2U1l4R1ZDRnBEd0pHU0JkMWpxb0ZqUEpXTXJOOW1hdmM3?=
 =?utf-8?B?Zm5FL3M0dmdOVkF1N0kya1IrWmdBVXJkL3AvR3F5bzl6M21NejVpYUVGWUw1?=
 =?utf-8?B?TEtzc050TWR3OE16TVdIVkk0RnB5dWIycGJCK25NWmVINTZ0NW1WRWI1aUxh?=
 =?utf-8?B?Qy9IbU9vU1E3OEZVZTJuU2xYeGJFVDhQTktZaWZQTXlvRjVrZEZXc0YvL0J6?=
 =?utf-8?B?RDhlWWxyZEdvUHRPdkJqVDNpR2E3TldpcmdBK0UwcUtqUzJOZ0pYSlFERXdk?=
 =?utf-8?B?ZG4vNWlIREtkQmRyc2dkUHFFOUs5R2J4SndZbUhBczVQZVpYYUhLcHRmbzRa?=
 =?utf-8?B?bHBwU1FJTmdwMDBDMy94Yi8zcGlSVVJjTE5ndmV1d0ltZjRTSmhXbUkxK204?=
 =?utf-8?B?ZW42VXY3MFJ5dUxzcm8za0ZmU2xrb3J3aC9TSE4zQ1JDbWtEUjBzMTlYYTVL?=
 =?utf-8?B?ajhsRFB5TVFJclp3Y3doWEh2elpma01XNytkODlOQXltZ2d4cVpSSU1QWDRZ?=
 =?utf-8?B?aVdORkRsTDVjN1NuMkhvV1JENE5DT0JLYW1WM1dqZnYwaTh5ekcyMFR0U0ta?=
 =?utf-8?B?TXhWNy9QUWtUcVRhK1cxWFJ4Y0I2TXA1SzF0eVMvY2FqQmRvWG5VTkQ2eWQ2?=
 =?utf-8?B?Q3NJUzVUc1dBR1RrejMrMlk2VDZiOGxsUnFtbUdYMGdueHJCQ3hWZm5JUnFv?=
 =?utf-8?B?elMwcUc3MCtTN1BXb0dWQWY4SkQxemYzZCt5a2hRNFZiL3B2RzB4cE0rVUo2?=
 =?utf-8?B?VHJxUjVYMWhnMWRoaHJlZVB1U2EzM3RsYnVRUkxYbEx2eU9lMkNaTnJmc1Vq?=
 =?utf-8?B?T05NWUZTTGdFek80dnRBZE9QM0t3RHJNbUlDZVF2NXpJWjNLZnlrQVJFR2xT?=
 =?utf-8?B?UEtVSS9ubjZqUmN1MXJOOThtNFZXOTFtL0JYUUtjTjZJNm54MXI3RFVKNFBW?=
 =?utf-8?Q?baNTpM1oyCtj1ol0rEg06gFg+9jvGc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vzh6WEFhNHhMangyeGxNTEZXTVZoNVhXUjZsYUJ0bWZsTGhDMnpTcjNscFU4?=
 =?utf-8?B?MzlqUldyWk41RHRTYXlLM3hyNHd5bGlTdHpwLzA1NVNpSGhOT3RXVHRHeGNv?=
 =?utf-8?B?SkNoS2pnVTFwM3Z4eUt3NkpQVWZITDBIZkZLaXMxakc1K0V4dmhUQUFXRXJI?=
 =?utf-8?B?R2tJWjNPOFAzYXB3Tjk1VkZHRWEzRTBlNk9BaHdJL2hndGZoSjcxaWpaWXFI?=
 =?utf-8?B?RTdDekI5Nm1oaXMwaGl3TnFpLzRyVUNGSjhHMFBLeW1TNVl1UHM5TWxTMXU2?=
 =?utf-8?B?aktrQmxvTml3LzZVaDk1ZWR5a2lHVXN3eWIxSWJ5UjUvZlZSUERJOUhKTGZm?=
 =?utf-8?B?UXArNVpFK2k1bDdBaGJGTW1OTkpha0h1WW5VZnRiYkpQQmNsaE1Hd2tXVzNS?=
 =?utf-8?B?azVBblZYU3J0SitlR2NZamdzT2NNWURPWG1ibEVmNExjZnFZK1NyejdHcmtX?=
 =?utf-8?B?ZEFWVWRNOHBCZEhUaTBubS9CZ3JXajBqdmE0cGdST3NoMVBneGRnVWZXc3hp?=
 =?utf-8?B?TFp6UDFsQWlmZDBmbkQ4NTNvbFpjTUljcDg0Ly9Xc05MNU1EWlBMYjVXdVRu?=
 =?utf-8?B?QzFBbEpNL1Y2WVV1UFdzUW5lV0cwUlVpdkZNY3MzV2tOQWFBL1VRSThETnpZ?=
 =?utf-8?B?VDJtbjMzZ2I5TjlXLzNhU1B3YkNIUnRnYjdXWG5rN1JnNENCTlhWUllpZXhm?=
 =?utf-8?B?VW5FTml0VnNJRGcwWmpwdkJiSitVQzlwTjhxRStPTm5NYk1wK3JrcTV3SGhD?=
 =?utf-8?B?Y0RGRlRkbXR0eUtBSjZydU05aDVLRURXaDhEVWJLTW9Tc25IaVpzSHVLYklK?=
 =?utf-8?B?VUVxalJqdnoxWm1PWnI4dkJDVkVSekI5dEVyOGJtdkcrSTBwclkxaXBveGFQ?=
 =?utf-8?B?TFhueTBEUUNQN1RzS1RJaGxhVExjb3FkZDNlTGtBRTBIV3JkQVUvamRpWWRE?=
 =?utf-8?B?eGNISU1DVVo2YUdCTlNURWExd3V1VGVTRXhnRFp4dkxSZ21CNnJxRkNzNE9L?=
 =?utf-8?B?dXYvVkRtaWx4TVRDYlRHZ0ZCZUkvTjNQeFcvVUs2eUFZd3RxUmtOQnREeU92?=
 =?utf-8?B?K2VDTkRVZmFQRTJOVWdEVzNzeGF5MmlEcnpENWtWMkZsNXdhWnp0dHdOd3o1?=
 =?utf-8?B?SHg2QWlMZ0RGd01GOXlIN2hQeWdDR1dFbmV0UVFGcGJNYVlDUmpEWUxhNFNp?=
 =?utf-8?B?WmlHR25hVGM1c3d4dHNaQzRNOWpZUlE5aVBJTFlkV3lvcGdvRUtXWFJHQnpK?=
 =?utf-8?B?Z2ZjKzV2b2ZjdUlBbXFraVNkTnRxTUFkc1I0bHNleGw2MzlYMmUvazR1TlMw?=
 =?utf-8?B?NlB3VFlCYnljbHgvL1RMWjJ0Ymowa1BkQWFic0E1OVYxdzVQK2dwTzB1NUMz?=
 =?utf-8?B?N2pHUGluQUw4VVdSTzFRSzJBbUFmWlJrdjJYM1l6TFhTNG1RbFkvM3Z2cHZO?=
 =?utf-8?B?dmwwTUtkcWs4SVc2dXVOS21WZkI3Y3N1SVFsckhYWkFGVzYveHBJRG5yOVlp?=
 =?utf-8?B?cG9Ic0pxdkxBT0lyVk4vdmpDblZtb3VVT3ZZK1Vqa0ZrWnNtUkpYT3pkQ0E5?=
 =?utf-8?B?KzlBaGFOaE1SYms4V1ZkYTdjRkJ1SUpJbFJwR0dNbkNjaFptL1dIQXRTcGZY?=
 =?utf-8?B?NzlBYlNjL3RaZ1h1TkhEKzRtV2VxMTd2ZnBJa2tjbWFnOXA4U05kTWx4VFYz?=
 =?utf-8?B?bWVXQ0tndC9uWWV4VmF6U3I1VUpLcnpGak91ODZQZzhpZVFsWmdGTWZYNVY3?=
 =?utf-8?B?Sit6TlU3UTU2SjBtayt5SGdmQzNKZGNjaUtMVlVnRHhIK1RMZnV0VEI4Wmlh?=
 =?utf-8?B?NWJSWHMvWEVyRGV2b29GT2FiT1MwSXBLVENRNVJHeWxOVzFNY0tOU2FHRTJT?=
 =?utf-8?B?dVE5dm8xcDNHNFAzY2krTjMxL0NqT3laTDRGWC82aE0yV2QwNGJBUlVzMmIw?=
 =?utf-8?B?N2U0b0EvVUtVUTE5RUg4M29Qd01WODk2VmRMeGFtTTMvc3BMOHRaOU8wWTAy?=
 =?utf-8?B?SXUrdFpiZkVTQUtibVVkZmNLZXZKbUtrQUUyWWppUU5pemphRVRrSGtsaUs3?=
 =?utf-8?B?cTZySWNMYzY1d2RqRTc4L3FYWGVQZ3d6V21JTEFRQkg3NE1OKzYyL1hjVFMw?=
 =?utf-8?B?aE9Uc2ZJSEpNREZrV0RtSE8zS1BBK285bmk1MjBmWmRETnZjMW13WmtOL0wr?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C7B32950D63CD41B5050EA4B1E20BE5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db40467-5094-4978-d431-08dd9711b7ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 20:14:11.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyRnSyhEGAZpx0AoncCS8Ahqm3p0f/QHnH+79u4gQwpsOWBgc/icgQgo36kxouO3xZ/uZxgjKsNUE3jD16uFVmHwLZlXxDujmttb1OJ5vcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6097
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDEwOjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1heSAxOSwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBNb24sIDIwMjUtMDUtMTkgYXQgMDY6MzMgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiBXYXMgdGhpcyBoaXQgYnkgYSByZWFsIFZNTT/CoCBJZiBzbywgd2h5IGlz
IGEgVERYIFZNTSByZW1vdmluZyBhIG1lbXNsb3Qgd2l0aG91dA0KPiA+ID4ga2lja2luZyB2Q1BV
cyBvdXQgb2YgS1ZNPw0KPiA+ID4gDQo+ID4gPiBSZWdhcmRsZXNzLCBJIHdvdWxkIHByZWZlciBu
b3QgdG8gYWRkIGEgbmV3IFJFVF9QRl8qIGZsYWcgZm9yIHRoaXMuwqAgQXQgYSBnbGFuY2UsDQo+
ID4gPiBLVk0gY2FuIHNpbXBseSBkcm9wIGFuZCByZWFjcXVpcmUgU1JDVSBpbiB0aGUgcmVsZXZh
bnQgcGF0aHMuDQo+ID4gDQo+ID4gRHVyaW5nIHRoZSBpbml0aWFsIGRlYnVnZ2luZyBhbmQga2lj
a2luZyBhcm91bmQgc3RhZ2UsIHRoaXMgaXMgdGhlIGZpcnN0DQo+ID4gZGlyZWN0aW9uIHdlIGxv
b2tlZC4gQnV0IGt2bV9nbWVtX3BvcHVsYXRlKCkgZG9lc24ndCBoYXZlIHNjcnUgbG9ja2VkLCBz
byB0aGVuDQo+ID4ga3ZtX3RkcF9tYXBfcGFnZSgpIHRyaWVzIHRvIHVubG9jayB3aXRob3V0IGl0
IGJlaW5nIGhlbGQuIChhbHRob3VnaCB0aGF0IHZlcnNpb24NCj4gPiBkaWRuJ3QgY2hlY2sgciA9
PSBSRVRfUEZfUkVUUlkgbGlrZSB5b3UgaGFkKS4gWWFuIGhhZCB0aGUgZm9sbG93aW5nIGNvbmNl
cm5zIGFuZA0KPiA+IGNhbWUgdXAgd2l0aCB0aGUgdmVyc2lvbiBpbiB0aGlzIHNlcmllcywgd2hp
Y2ggd2UgaGVsZCByZXZpZXcgb24gZm9yIHRoZSBsaXN0Og0KPiANCj4gQWgsIEkgbWlzc2VkIHRo
ZSBrdm1fZ21lbV9wb3B1bGF0ZSgpID0+IGt2bV90ZHBfbWFwX3BhZ2UoKSBjaGFpbi4NCj4gDQo+
ID4gPiBIb3dldmVyLCB1cG9uIGZ1cnRoZXIgY29uc2lkZXJhdGlvbiwgSSBhbSByZWx1Y3RhbnQg
dG8gaW1wbGVtZW50IHRoaXMgZml4IGZvcg0KPiANCj4gV2hpY2ggZml4Pw0KDQpUaGUgb25lIGNv
bnNpZGVyZWQgd2hlbiBkZWJ1Z2dpbmcgdGhlIGlzc3VlLiBJdCB3YXMgcHJldHR5IG11Y2ggZXhh
Y3RseSBsaWtlIHlvdQ0KZmlyc3Qgc3VnZ2VzdGVkLCBidXQgd2l0aCB0aGUgc2NydSBsb2NrIHRh
a2VuIGluIHRkeF9nbWVtX3Bvc3RfcG9wdWxhdGUoKS4gU2luY2UNCml0IHdhcyBwcmV0dHkgbXVj
aCB0aGUgc2FtZSBJIGp1c3Qgc2hhcmVkIFlhbidzIGNvbW1lbnQgb24gaXQuDQoNCkluIGNhc2Ug
aXQgbG9va3MgbGlrZSBpbnRlcm5hbCBjb2RlIHJldmlldywgaGVyZSBpcyBzb21lIG1vcmUgaGlz
dG9yeToNCjEuIFJlaW5ldHRlIHJlcG9ydHMgYnVnIGZyb20gaW50ZXJuYWwgdGVzdCwgd29uZGVy
aW5nIGlmIGl0J3MgdmFsaWQgdXNlcnNwYWNlDQpiZWhhdmlvcg0KMi4gSSBzdWdnZXN0IHNjcnUg
cm9vdCBjYXVzZQ0KMy4gWWFuIHByb3ZpZGVzIHNwZWNpZmljIGRpZmYgKHByZXR0eSBtdWNoIHdo
YXQgeW91IHN1Z2dlc3RlZCkgZm9yIFJlaW5ldHRlIHRvDQp0ZXN0LCB3aG8gZmluZHMgdGhlIHBv
c3RfcG9wdWxhdGUgY2FzZSBnZW5lcmF0ZXMgYSB3YXJuaW5nDQo0LiBZYW4gbG9va3MgYXQgZml4
aW5nIHVwIHBvc3RfcG9wdWxhdGUgY2FzZSwgYnV0IGRlY2lkZXMgc2hlIGRvZXNuJ3QgbGlrZSBp
dA0KKHRoZSBxdW90ZWQgYmx1cmIpIGFuZCBkZXZlbG9wcyB0aGUgYWx0ZXJuYXRpdmUgaW4gdGhp
cyBzZXJpZXMNCg0KPiA+ID4gdGhlIGZvbGxvd2luZyByZWFzb25zOg0KPiA+ID4gLSBrdm1fZ21l
bV9wb3B1bGF0ZSgpIGFscmVhZHkgaG9sZHMgdGhlIGt2bS0+c2xvdHNfbG9jay4NCj4gPiA+IC0g
V2hpbGUgcmV0cnlpbmcgd2l0aCBzcmN1IHVubG9jayBhbmQgbG9jayBjYW4gd29ya2Fyb3VuZCB0
aGUNCj4gPiA+ICAgS1ZNX01FTVNMT1RfSU5WQUxJRCBkZWFkbG9jaywgaXQgcmVzdWx0cyBpbiBl
YWNoIGt2bV92Y3B1X3ByZV9mYXVsdF9tZW1vcnkoKQ0KPiA+ID4gICBhbmQgdGR4X2hhbmRsZV9l
cHRfdmlvbGF0aW9uKCkgZmF1bHRpbmcgd2l0aCBkaWZmZXJlbnQgbWVtc2xvdCBsYXlvdXRzLg0K
PiANCj4gVGhpcyBiZWhhdmlvciBoYXMgZXhpc3RlZCBzaW5jZSBwcmV0dHkgbXVjaCB0aGUgYmVn
aW5uaW5nIG9mIEtWTSB0aW1lLg0KPiANCg0KVGhlIG5vbi10ZHggaXNzdWVzIHRvZGF5IGFyZSBy
ZWxhdGVkIHRvIHRoZSBwcmUtZmF1bHQgbWVtb3J5IHN0dWZmLCB3aGljaA0KZG9lc24ndCBlbnRl
ciB0aGUgZ3Vlc3QgZm9yIGEgZGlmZmVyZW50IHJlYXNvbi4NCg0KPiAgIFREWCBpcyB0aGUNCj4g
b2RkYmFsbCB0aGF0IGRvZXNuJ3QgcmUtZW50ZXIgdGhlIGd1ZXN0LiAgQWxsIG90aGVyIGZsYXZv
cnMgcmUtZW50ZXIgdGhlIGd1ZXN0IG9uDQo+IFJFVF9QRl9SRVRSWSwgd2hpY2ggbWVhbnMgZHJv
cHBpbmcgYW5kIHJlYWNxdWlyaW5nIFNSQ1UuICBXaGljaCBpcyB3aHkgSSBkb24ndCBsaWtlDQo+
IFJFVF9QRl9SRVRSWV9JTlZBTElEX1NMT1Q7IGl0J3Mgc2ltcGx5IGhhbmRsaW5nIHRoZSBjYXNl
IHdlIGtub3cgYWJvdXQuDQo+IA0KPiBBcmd1YWJseSwgX1REWF8gaXMgYnVnZ3kgYnkgbm90IHBy
b3ZpZGluZyB0aGlzIGJlaGF2aW9yLg0KDQpMb25nIHRlcm0gdGhlIHplcm8gc3RlcCBpc3N1ZSBu
ZWVkcyB0byBiZSByZXNvbHZlZC4gU28geWVhIHdlIHNob3VsZCBhdm9pZA0KYnVpbGRpbmcgYXJv
dW5kIGl0IGZvciBhbnl0aGluZyBub3QtY3JpdGljYWwgKGxpa2UgdGhpcykuIEJ1dCBJIGRvbid0
IHNlZSB3aHkNCnByZWZhdWx0IGlzIG5vdCBpbiB0aGUgc2FtZSBjYXRlZ29yeSBvZiBvZGRuZXNz
Lg0KDQo+IA0KPiA+IEknbSBub3Qgc3VyZSB3aHkgdGhlIHNlY29uZCBvbmUgaXMgcmVhbGx5IGEg
cHJvYmxlbS4gRm9yIHRoZSBmaXJzdCBvbmUgSSB0aGluaw0KPiA+IHRoYXQgcGF0aCBjb3VsZCBq
dXN0IHRha2UgdGhlIHNjcnUgbG9jayBpbiB0aGUgcHJvcGVyIG9yZGVyIHdpdGgga3ZtLQ0KPiA+
ID4gc2xvdHNfbG9jaz8NCj4gDQo+IEFjcXVpcmluZyBTUkNVIGluc2lkZSBzbG90c19sb2NrIHNo
b3VsZCBiZSBmaW5lLiAgVGhlIHJlc2VydmUgb3JkZXIgd291bGQgYmUNCj4gcHJvYmxlbWF0aWMs
IGFzIEtWTSBzeW5jaHJvbml6ZXMgU1JDVSB3aGlsZSBob2xkaW5nIHNsb3RzX2xvY2suDQo+IA0K
PiBUaGF0IHNhaWQsIEkgZG9uJ3QgbG92ZSB0aGUgaWRlYSBvZiBncmFiYmluZyBTUkNVLCBiZWNh
dXNlIGl0J3Mgc28gb2J2aW91c2x5IGENCj4gaGFjay4gIFdoYXQgYWJvdXQgc29tZXRoaW5nIGxp
a2UgdGhpcz8NCg0KTGlrZSBSZWluZXR0ZSBub3RpY2VkIGl0IGRvZXNuJ3QgcGFzcyB0aGUgaW5j
bHVkZWQgdGVzdC4gSXQgbG9va3MgbGlrZQ0Kc3luY2hyb25pemVfc3JjdV9leHBlZGl0ZWQoKSBp
cyBub3Qgd2FpdGluZyBhbnkgbG9uZ2VyLCBidXQgdGhlcmUgaXMgc29tZSBvdGhlcg0KUkVUX1BG
X1JFVFJZIGxvb3Agbm90IGNhdXNlZCBieSBLVk1fTUVNU0xPVF9JTlZBTElELiBNdXN0IGJlIHNv
bWUgc2lkZSBlZmZlY3QuDQpXaWxsIGRlYnVnIGZ1cnRoZXIuDQo=

