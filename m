Return-Path: <kvm+bounces-58906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 57273BA54A1
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 00:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 335264E037D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 22:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853B4299A96;
	Fri, 26 Sep 2025 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SvSpcGPx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34931290DBB;
	Fri, 26 Sep 2025 22:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758924319; cv=fail; b=An7XYte90Qb7lPt9k5BkKnGP3Luf1y0y6pB7rgTDs/IVFB1iefEjIElYXPWR6h9EFfmAkKIAaeN8KGOyuGg2nrDRIjdSl/diBjlgTWErRzXGfznPcEGXVW+OfArTexqvaENtZF1fBNxNj0ZhRhsHOAhPS8UOhE+HQq5Ypb10n5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758924319; c=relaxed/simple;
	bh=fQmfOYklpAO3gfiu9XUdUInyOARojahpyu9gzraEBAs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zr0yHFQIEWiRehM9OSNpCXhkVIseuizgdufSdzeHBH8faqtPUePyRyjVBrNluu4qKKIl8id4GL39FHYKWHf9+Qb42S9IjKW0TOVyPHuqO8opb7MO9vdRtmkl1pUfCG1RQOuKgXmX4BfgIr3tlLVbmLGKJ1rvqO7MUvj18Wtk0BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SvSpcGPx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758924318; x=1790460318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fQmfOYklpAO3gfiu9XUdUInyOARojahpyu9gzraEBAs=;
  b=SvSpcGPxR4C/0WnnvCrEnXWX2jmM0NH/nY5v/fVled+cUjswj3qgUUyC
   CeodgEK43FuS702Xho7NPCsS8157KpC87wha6txSiVGo8xOnnHAJoyFTY
   l6EzHqSAm6v5vfTitajmNiY6iUuNB9niVmEOmS9Ctt7aqPN6ralFhdwQ8
   hv0E/tqrM0ms1mIhb1JdKP8Lb6Qa+9qmNfwAj6KC5iglqaqqqtgDFxu3R
   Ab3nV7BD6/TxZvgzHrfKDvqmdBp/KSXaNIYWqHsa45k4aJw+UFaanT9yc
   ANAswiQkglavZX9cJy/IS0ZxLxt+9AKiCNdAaxoyHYRiXPuNjOvqIJqhC
   g==;
X-CSE-ConnectionGUID: jmfslnX0RxGqkfMURyCEZA==
X-CSE-MsgGUID: uEDjONpbSGOt9tZ5XhY0+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="61430650"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="61430650"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:05:17 -0700
X-CSE-ConnectionGUID: K5divDPRRC2SwWBokhk1iw==
X-CSE-MsgGUID: g7h8hHolQm2p4hIG1GEOUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="182127916"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 15:05:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:05:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 15:05:16 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 15:05:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cc6/L2IpIrpW2b8kH3+gBFAP2S4zuYB2Km/SsXXnIGO7BtObwh4P3FB1aDMsAR9YxI6Nou5TI8rKpShN/PvPugjsx6+ED2DWSaBth0o3lsN7EYvS/IixMAHmXz58MyfRbBLB/I0ZHPuXMrH6yDZQu7UE7I/YOhrnRbSU15cGxhu4jdH6TEAVld/8L4HltJfzGQ0Yy4Cmhd63FN6gHcZttKPPT1v3ph6F81WUX9rDarMrtdD64zwqBbmoAuZBXrwuhEtcv9oAKqFSqoOIpnwKbrJCu8ySPMXY9fc3FguH4WefBZfxEhLsKcwRh/pUXIzxc/G8v+CNKk1sUGA1kbyvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQmfOYklpAO3gfiu9XUdUInyOARojahpyu9gzraEBAs=;
 b=KTAIevWszBiWUmrnSh0WIE4QIb2ZNZn7tK7O/oYBhBBbF+zoI6lw3XU8F59esk5uI3o4WLqNaYxHH13Y9Faj67h4T2QROskKXpJPUww1I98L43JLnltJCGOtH71sVzKg56dQPQRmOlNz1hetZRv6JNqK2FFR7xm3SmnDOyximR4h2zOVgy4USev8g24X+Kq9MEz5hWkrIRZ7K1jBrTgdcF2kdHJqVxCuwEux0Ivcn9TR1c7o2iUygC7w/mdIXd76LHq4JPdq8F9x0TArlceMey4/y74MSDKOwMa7X1Kb0zrUai+307lPZb6r2iJtYECesfcYI6fFGx/YxAMdzmKbkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4867.namprd11.prod.outlook.com (2603:10b6:303:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 22:05:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 22:05:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM47wNFJAdMMkCLNWN+W5B0ObSkvGOAgAFU5gA=
Date: Fri, 26 Sep 2025 22:05:12 +0000
Message-ID: <b3b70404aaf634cca9199b917a9987ccdb3a66b0.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
	 <aNXwEft+ioM9Ut8Q@yzhao56-desk.sh.intel.com>
In-Reply-To: <aNXwEft+ioM9Ut8Q@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4867:EE_
x-ms-office365-filtering-correlation-id: 70cc27b2-955f-4fb9-69c3-08ddfd48c43b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aHUwKytQYktZNW9FT1U3T2dDVVh1emJXb1JiNDlEVHkvZlVNU3ZKQkJlenhH?=
 =?utf-8?B?RXpUK0lnMlU3cW00MS9SeXoxMnMrVWkvRkowWlQrNk9JWWRyQSttdTMyTlZp?=
 =?utf-8?B?TkZLL21QbTdZU0d0Tmw3dlVsdndERGZaOFN3eU93WS9CWEl6KzlEb2FybTRE?=
 =?utf-8?B?VzlDeFpoaHhIS3E4M2lrd3puMUFsdmxVTFVQZDhzY1BxdENoMHBhYVNuQlZ3?=
 =?utf-8?B?WmZqSWZxMzBWY1A1azFiUmowaUxoWGRQU1RjcE5ISHczS3paQXh6cHc5M00z?=
 =?utf-8?B?bkFWYm5HSTEya1YvZDFnVWlseklKQU4yVkpPLzZRTVJkVXhqaVZ3dk5sNEZQ?=
 =?utf-8?B?ZjJibFM1bmFQaGIwaDRpZ0VsdkNZQXdJMnVwVHFIMWRvOCtSNmVtUlVPRDVa?=
 =?utf-8?B?QVBBRUlMc1lOTHd3SldKbnZ0UjdVMFRYWG8zL3BpanF2TGVvTnRQVjBZcU1U?=
 =?utf-8?B?ZStKZFlzTklrMmwwN0d3dmVnYWhWZTZ6cjU1MXhkMm13SERXUS9idFJSMXpv?=
 =?utf-8?B?U2VBQk5zTk9rRnpPNUx3aDgwOWxJb0xDdUxHRkdOOHhWUzBHUGQ4SHVYZ3Ni?=
 =?utf-8?B?ZERCWFhjTmJ5eUhGUE5XRko4Tm9wZ2dPdjdFYTdXQ0ttNmxnRUt1anVNd2dX?=
 =?utf-8?B?MlUvK0dmVHN2QWw2ZzEvU0p5N1pnd1d1eEdOcFU0VFpwR092WnBOMlEvNFQ5?=
 =?utf-8?B?TnJndndPcXJqRzhoZjgyajNiTVN3NVorSkFTeXU4c0JSU2VHVnNvNVFvRU0z?=
 =?utf-8?B?Q2krOXR3Nm02SDFEenhoL0lzSVZVZ29lKzNwUlpoWGRZb0FZa0l0UmNoRnlO?=
 =?utf-8?B?MDMzMUJPZzFEY242QnZXWklCMUwxTUk4N3JocTVBUkdIYVA4N0thbkhPeSs4?=
 =?utf-8?B?MndEbUl3RzFma2libFJBSURBMFhZQjhLZnVpZEMvczAvcVR6TDh3OFowMVJH?=
 =?utf-8?B?N2VTNVVPNXpRZFpMSnlQT2hxZVVkY0xaTHN3VGF1dTFqVUluVHJaNUpqNURL?=
 =?utf-8?B?eGV6RTlmOTVEZG1ZdGNsenk4MnJ2TTUwdXlVS05tZ3BIMWRHYTBwMW15VXhO?=
 =?utf-8?B?cXhwQjFYcVR2eHJmU1F3eE9PSXV2YnI3d0pHZWNCc3g2TTRMUVU1dzVkRk1U?=
 =?utf-8?B?WldleG4yd3lPNXZOTlUzV295WmF6dE9jbUNnTnlUc1lCR25xeWpWaTNSTmt1?=
 =?utf-8?B?VVgzRUY3L1UxdTVTV1lkY21xMWFhNGFUQ1dYbFJMV3d4T0dTNkVDMDU0WGNP?=
 =?utf-8?B?OC9rZkpKSTJFTUhxdDE0cDdGNy81QnhMcWdWK0J2cU5TSDU1NG41RUs3T1ZB?=
 =?utf-8?B?OGtXVVZtZlJacnZGMUhIejRIcnFJQ3pSQ1R6NkdHd25vTzd0bWhVdTRGOG9C?=
 =?utf-8?B?RFVpUTI3RWgzNDQ1VFpxaVdlTEUzRmNhbXlGQUpqTk1qWHpYUHJnL2duUmV1?=
 =?utf-8?B?Q1pTNGpaRVN4bUlwTHdtc29RRmQyVmtwOFJIOVBnQ0ZBbmZGaTFrOWdmMnJs?=
 =?utf-8?B?ejVETEFWR3JpYnBhSmRvTkcwUUw3K2tTaFVWcTFiN3VNNGk0VTg2K2pma29o?=
 =?utf-8?B?SkNGRStHbUNsMzRZN3RhOG5rdWcvSkg0QkpsYVQ5TlBvMFZPQWc5d2tEZDkz?=
 =?utf-8?B?RWJJbFVGcm1hNzI0cWVnRmpsbmJHc3E3RnpzdUVLSm95c3c4NTFRaDVwRE9j?=
 =?utf-8?B?Z0pzd3NyN3gyRTc0dTNtOFd5SG84Z3JlTWx1VkxXRlpQaEg1c3MydHJwWmEw?=
 =?utf-8?B?OHV1c2RhTmVmbm9Sb0x4MGswcmZtalcwQlBiRVdkKzVTaWwweG5nbnh0UmZW?=
 =?utf-8?B?WFpacVBqbktPUWovTi9UdjVBOUJRYy9aSUxSSkhhbkVZb0tCV2lxTDZQMFh2?=
 =?utf-8?B?bjhTSDJURTVpdzZBS2t4ZEc5dWE1RkdMMVNiK0ZCTVFQZW1GN245NU5NZCsr?=
 =?utf-8?B?NzFFQXlJVUdTdVVDSEU5bUVLNkZicE82a1k4QWxsYnZqODVVeTM3OFQzR05r?=
 =?utf-8?B?amZsNmowOWI1THgyZ1JHMjhidDVzUko2cFNUNlo3ejVIK2lZK2N1UVE5bFNK?=
 =?utf-8?Q?SrpVct?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3lKbythTzhldFR0OG83VDZKQ0E1ZjJXUHZqZzBycmhwaWZwcGFBSnZ4aFpM?=
 =?utf-8?B?SUNxTkVWcFlaeW1oSlA5NzJ4aXZrVXpsRG5zM000bHhFdXYwc251eFBPbllT?=
 =?utf-8?B?eURYNmZCN2RLNmFScjAvdkdVVGNMTjVDL0VtSk9EOWVaKytHSjU5NjV5WnRP?=
 =?utf-8?B?M0RUNFVZUXVsdkxTSUtNaTZ2enV2M2FFKzVXQkxSN0NQRDlCSmVoRnlwM0JJ?=
 =?utf-8?B?T2p3Qm1GQ3hsVmhUMGlrdThCd1NxOGdnSFRLV0ovNGwwR0N2Tk4rcEd1ZnlZ?=
 =?utf-8?B?RnVmMUN3UEFjVmczNVFqMnhPUENDNm5PYkVreTN4MmhrQUFzTS83VnRzdnda?=
 =?utf-8?B?dVN0aE1za2RtaUwraGV4NUxpWTdlVFY5WXVWMzAvRThqOVl2S3UxZ3ZPYXFv?=
 =?utf-8?B?SXZraDVZZ0pCdEw2ZVhPSjJ4eUJuaHYyVWdFUkhVZXV1bzNiTnZyTm8wTTJV?=
 =?utf-8?B?bnVDZUZSSDNMNEVKWFZrcCsyclh2U1B2MDUvOXhFMWxDL0ttUTlvOEVJMFVY?=
 =?utf-8?B?eUlzU2lmcXRsbGxJa20wMFc1ZTlBRlBHNVdZUkFsYmpFd0xEd2JrT2hoT1pS?=
 =?utf-8?B?RkpnQ2diUitpQTlPWnZCYU81cml6SkZoak5wcllkOFJhM2dsR093L24wMHhl?=
 =?utf-8?B?QXFzS3hLT0s3WUw2a2tweS9ML0M5VnpSQ25ycHV1YW4wNFVxQnA1TkwvUjh0?=
 =?utf-8?B?QU0vZ3hxVHd2VUVMUzBGMXdhTzNmSU8wS25mNzd6bG4wQnBFcHluWWJTKzlD?=
 =?utf-8?B?SDhueldYZVF5d2dtSWE5SzhHcmNVYjdsZzREa3FpYVZjcWZDMjdVZ0ZzRGxF?=
 =?utf-8?B?MURMOEtkTXJSajE0dlkxcnRVVnMyMk5sZzZzU3RkSlJyRms1dUFLSitQN01q?=
 =?utf-8?B?a3FoYmx0ZlZWelNEd3F2N0hiSlFzTk1aM01JaDlCcEN5Z0hKaCs1ajA0Ympx?=
 =?utf-8?B?NmpIU0tsYk5hZm81TGZJbzVKOU1zb1ZxRVB1MDNlTWFFQ1pqY2NBYm55UVJv?=
 =?utf-8?B?TFRoT0xEcmpVRmk3U3hmSVNENmlyTlVaelYxSWxPY1F6UzM3VmJqRDBFT3hG?=
 =?utf-8?B?NWZFRHhuaWZ1YVFrTjhUdm5KTExFL29lVzR4ZDhxcDhuT1gydzJySWh2VWhv?=
 =?utf-8?B?L2JNeXF4cXVSL0pCUkJxOWs1YUJsbDYybXRtOG5WOEpIMWZ3ekdmcWVvRG4x?=
 =?utf-8?B?ZWUxUkxYM1FKeWZkOUxyektCeHVNbjFOODJzUnVramRXN2pDUTBGTmhGdktv?=
 =?utf-8?B?TzAyQkg4Z0RwcEFVYXdVSThybmw3OVpkbksrWE1mSFlPOEJPSzFHdUZXQVBh?=
 =?utf-8?B?ek5YdkZZMExRbllsUEgzM3lZYlFZQ3laWUNMd2JIU1R2akRhQzVpMUsrcThX?=
 =?utf-8?B?cGJURU5OTU50bkF6Rm5GK0ZaZzhYUVBOQ1hDeVptdEtaRXc2WXVGSHpZUWQx?=
 =?utf-8?B?VXI1Vk9zOXA2K3MyQTkreFFDMTBOZklTYVhZRVVpSXhzWS9ZejRDTnBxYkxt?=
 =?utf-8?B?Sm11TVQzRStnbkgxUmVUSXZmNUZVbTlZWXZ4dlp6Wi9VOHZGdVp0ZzFqZ1NS?=
 =?utf-8?B?WVp3TCtTbGJkK05XT0szYmpUYlhhSi9GMWJxSG4wYjZsb0tTRG5RRVRVbldi?=
 =?utf-8?B?cmtTSTZBczVHbkR6WDEvZStXV20wN2xnVVdmbGR0Tm9BTmZBK3g3bUpGcVR1?=
 =?utf-8?B?Q1Jmb2I5WXYvOTByUkxBS1N2NGhNZVdqSGxzeGVhUFhGcmUraDRWb3JobWJt?=
 =?utf-8?B?UXRJUkFWaFk4L1BFM1dWbTJ0VDFGTEU2NlpMTHBsdytWSXpNdWxsY2VUUzE2?=
 =?utf-8?B?QTNWRnhOcW9SWUI0RFlEanhBZk50K2hMMytSK2VTbkdKQVZEbW5odXgzQkNO?=
 =?utf-8?B?RGs0SlkvOCtvaWZuUmFzdVhSSURSOVg1ZlhRZ0RuTWs3MVlFQ2JIYW5wdmJh?=
 =?utf-8?B?WUszeFJESTcvNDJ4RWd5MytEOWUzaDVVdmJWQWxxRlJDaVBzTnVNald3d2ps?=
 =?utf-8?B?NjBYK2hsWko5SFdUNjJDQ3AxVEV6UmRBOXNpNTBmMGdaSFU4aWNUOTJLdVVU?=
 =?utf-8?B?eXBiZjV5VzFBZG8yMktGdTIreGtnUHJqNW1Ra09MR1krUXVPM09xVE5ySHdW?=
 =?utf-8?B?MmpqSXRSbis0YjJzZGF2WmQyRWVPUkoyQzlOaFdxZU9VN0FFRTJXN3FxVHZE?=
 =?utf-8?Q?XLQ33NiDaIq+U6spvyjmUYQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF3E4BF8051FB149A16F1C75BA3B1492@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70cc27b2-955f-4fb9-69c3-08ddfd48c43b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 22:05:12.8097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQvxa9B7GBXrX5gbSV1MCxN70h+qc4+BEpa9GOQ+HrBNSWAkVwX8PqxcrrnaqxWEBd0VCtGUSrpimIT0wDUF+vv2UHRa8Y+lGkKtANJP+AI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4867
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDA5OjQ0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiAt
CXJldHVybiBrdm1fbW11X3RvcHVwX21lbW9yeV9jYWNoZSgmdGR4LQ0KPiA+ID5tbXVfZXh0ZXJu
YWxfc3B0X2NhY2hlLA0KPiA+IC0JCQkJCcKgIFBUNjRfUk9PVF9NQVhfTEVWRUwpOw0KPiA+ICsJ
LyogRXh0ZXJuYWwgcGFnZSB0YWJsZXMgKi8NCj4gPiArCW1pbl9mYXVsdF9jYWNoZV9zaXplID0g
UFQ2NF9ST09UX01BWF9MRVZFTDsNCj4gDQo+IG1pbl9mYXVsdF9jYWNoZV9zaXplID0gUFQ2NF9S
T09UX01BWF9MRVZFTCAtIDE/DQo+IFdlIGRvbid0IG5lZWQgdG8gYWxsb2NhdGUgcGFnZSBmb3Ig
dGhlIHJvb3QgcGFnZS4NCg0KV2h5IGNoYW5nZSBpdCBpbiB0aGlzIHBhdGNoPw0KDQo+IA0KPiA+
ICsJLyogRHluYW1pYyBQQU1UIHBhZ2VzIChpZiBlbmFibGVkKSAqLw0KPiA+ICsJbWluX2ZhdWx0
X2NhY2hlX3NpemUgKz0gdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCkgKg0KPiA+IFBUNjRfUk9PVF9N
QVhfTEVWRUw7DQo+ID4gKw0KPiBXaGF0IGFib3V0IGNvbW1lbnRpbmcgdGhhdCBpdCdzDQo+IHRk
eF9kcGFtdF9lbnRyeV9wYWdlcygpICogKChQVDY0X1JPT1RfTUFYX0xFVkVMIC0gMSkgKyAxKSA/
DQo+IGkuZS4sDQo+IChQVDY0X1JPT1RfTUFYX0xFVkVMwqAgLSAxKSBmb3IgcGFnZSB0YWJsZSBw
YWdlcywgYW5kIDEgZm9yIGd1ZXN0DQo+IHByaXZhdGUgcGFnZS4NCg0KWWVzIHRoZSBjb21tZW50
IGNvdWxkIGJlIGltcHJvdmVkLiBJJ2xsIGVuaGFuY2UgaXQuIFRoYW5rcy4NCg==

