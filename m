Return-Path: <kvm+bounces-11358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB068875E64
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 08:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 615A4283BCC
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 07:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63724EB55;
	Fri,  8 Mar 2024 07:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dFudUBGr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113554EB41;
	Fri,  8 Mar 2024 07:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709882606; cv=fail; b=QdAjUTO2r7+fzUeN13NHoYxxT8VEhR6GO7yWMc6dkySdO4onKj6TGte/WTCnhK1TxxwAxFCJ8e068nvn0eP/noO43SbfKVPztuc1m03mEqb7ks/y9LrWa/gyzGc8zsyN+dyKjhEEIgkO7tlGTugROpR8vJUczHNv0agV+cRh5PM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709882606; c=relaxed/simple;
	bh=Y6Lca8BVI6sXnPppRBXrYRNN92pncjYMRWkWD91/vqY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dfqhtJEFhZAr8VnY9nqIFfPqysKf5YM3vHmicsJ/Ewn36+p+OZioj6MZJLn2uvpCnV7ajmwPOIs58npEeg1mgMTGUG0WA41ilXzTe8buBAyWMpfsX5XRFUa0pAzf5OJYwGGL7YTUOZT9/GQMIMlGSRQjmwNw87o+PKuW0P4rZd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dFudUBGr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709882605; x=1741418605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y6Lca8BVI6sXnPppRBXrYRNN92pncjYMRWkWD91/vqY=;
  b=dFudUBGrqMJwyaMZSbOXYP1dOExXby9USVPLdqXmNrnTsj+LDlxc8GyN
   AyEIsTG6rm7I2euA39ferW8VLHR/4YqvzjqSVC+5WBGXIE4nWsgfG1oWr
   IeOY32l3rq4Yq/H+FpCMft2VHeeBk46obQN3J1hJ+dqNTsIktni1Ru9zF
   slB10Bnw506Wyfiqto+rgaTLkQHyf+aI05M2+8Bbqt3CWCnisgsc8elv2
   cKiACm4xO5sUeCHKAt4HvmKX5ood6xf6Lf7/nW9jdiTu2QfAMo3G25fLH
   LpVP1nSh2CJaDnW1dhzMd8KPvZvtMt0pITKLwqqxMDjJtWVpaPLL8a4E5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4730615"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4730615"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 23:23:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15071627"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 23:23:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:23:24 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 23:23:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 23:23:23 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 23:23:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYMzOg0A7ZEz003pxEcui9dG1+itaBVjkq4EwO+cBbx5aTQ3ZDXuBOqtiJgFhsh3OWo0Gtvt3JbamFCXNrdIMM9q2bd0R0WY0vgHquJAIgMp6PwYc5lsfj5OQLMtoSQMiOhW/Yy/NLg9KfCwTGm3Kma52G9q1eeM8KmWP41yJfP/Xc8jBfovLbcWlj4w1TXJNAt7Ep7Yp1tgFNjuCjIduTKyrBH5cDz2EsrfkzTQ87925hjSZS4S67j8K8WLEbdqqXEZRWoynWKU85/+no5xMBAoKsVcTuUqMFouVaewWJtANdBPGlK/+VfNwjJV/vCsbuXvU/RmmDPsKtOdK6KVSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6Lca8BVI6sXnPppRBXrYRNN92pncjYMRWkWD91/vqY=;
 b=E5gQaW1fSaF0WnKFUILquyA3GnVb44WRSzYKKPsShKSv7pKF5jQymzsq3UH/K6ZoZAOmbZrzYpo6+knn0xAZb8lUJT9aL52E49Ya26F2IkEOceP4dwKugmSuJxaUcuUmeoKFfrPB8hNtl/oAToVngPDP5+LVy8dlDF7Ts8iYepYLZ/FmbT+8HogxIR0mNuT+axJafeZRHgr2YGS0WrX8nnwRFTLrF922uuRRLqjcPObdW4gQJZWz+UVHNLtMBRHcK8RiZFi9eADd58HyTakvMNsw0f8UWHgJ2kWc3b0JJWZKHcn+msRLTIwSUdvSDS/0azMsn5XB3TbTAbI+5aTcLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB4660.namprd11.prod.outlook.com (2603:10b6:5:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.10; Fri, 8 Mar
 2024 07:23:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 07:23:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "clg@redhat.com" <clg@redhat.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Topic: [PATCH 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Thread-Index: AQHacAtu1xn5Hoku+0au9dqEK9o17bEr9ZgwgADFCQCAALeV4A==
Date: Fri, 8 Mar 2024 07:23:21 +0000
Message-ID: <BN9PR11MB5276DBB5FBC36939EB39A3CA8C272@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
	<20240306211445.1856768-2-alex.williamson@redhat.com>
	<BL1PR11MB527189373E8756AA8697E8D78C202@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20240307132348.5dbc57dc.alex.williamson@redhat.com>
In-Reply-To: <20240307132348.5dbc57dc.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM6PR11MB4660:EE_
x-ms-office365-filtering-correlation-id: 503dccc8-1d9b-4cb5-0d9d-08dc3f40a236
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2rausMaoEuVVWKoxorRD3hdGyPWz9swVU7uqUYEDc96jYFnjzg9mWR15jyAbmgtTtCP2Ja6FDFf2iZ1MwK4icaKTFyVosGSDrNJZ1qEc1xrQrGTS1nsmYkDZ0KtQ/uBO+CkQnM/lMfROIuMd/wLcleoJOj6GhsCCDZGcfSbahvEBHBZRClnH9FODt0wRGb9/F47hXqcWgR2COhWSSm/JfxK+F3aqMcgiTr8PnH41lY/tNXmXzULhV9xhGJ6ct9QJVBQllx+sod2oBEG+0W+9AD5lgHfNfkuUX/l4iT0YrGgTP1oebOvz05ORbk1J9UeHUyRfph4fCNXzX7if0r5DSbzjJ7BnFxV24kcaetBDNGBuq6uduNp2lw+3x0tA1Uur+NpW6y8shXnoRqTYO8XGyQkS8q4PzmT2a+oXBnzzZXUAHQr6490hDchcB3UPmjhxir1WpBVzurQOSKAFj1dt9pzxUWLWGbrdpZouzeF694e/NPmL9vEXzyKi/VENSLeiY1gSsxm9TKE+PW6MsQ4BkkN48TgtzGoMXmZqu9Qt75LcpVLkkUSB2NEQCebpH5tLxpIbJdsxUPZje4+G2zVfhKS5hB0dgINmCZOqQBEQKG006E0ydzOvYnDBsHesmjhWQfFR8IVrF80AVSzv9eqGmBsMcP4f72TA/ZkoW2RAMA4u3IzBNPC7X9WUVh7l4QOSygGqgprup86YgY9gMRa4V4kByeFGifoyGQOdX41hPs4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3hHcUJYTnJJVEJFOG5XeVVyUVlJK1o4N3BzNHFWS1k1OWpCTThnRWNWeVYv?=
 =?utf-8?B?cHFxUzY0REdscXFUUm1CUlltMVpzcTRqUUJabXNITVRrQTVsU0JrOFlnNWtW?=
 =?utf-8?B?UkdHaGdkSjc1RXJFWFl2bjd5dVlsZXozVjhSUzZzQ0RtL3dUZmtmaGNkaXd0?=
 =?utf-8?B?SFRkNEhIRlRxVGRCdVh2S2xJTE4zc3hUOHVPcVpYNFVhWC9Qc2lQU0xVQnZL?=
 =?utf-8?B?TjE3blVabzZveTVPd1hzanFYaVl6clpFRW5oQ1p5MmliY1o3TVhSbDFWd2du?=
 =?utf-8?B?M1ZaZXZVdHRBZkxoTENIQUVkNHZnMSs1ZDlMZnZKUGtYTVViYkpIRC8zRGRF?=
 =?utf-8?B?alBzb29Ia1gxK2pPQWxIbk9qcGs1ZVV3MnJNNFdqcmowRXVPL05aUThuaTNR?=
 =?utf-8?B?OE5JOGlEZDZkaFVnOXVWMk9HK0daSkttNEhUVXJ0eGdBTHNkTGM2RVBZWlkw?=
 =?utf-8?B?MS9hVzhZQnRaUHpPc2lWTHJibk1ab0VrdWRHUEgzQ2JmNGkzZ2s5aVd6MHUr?=
 =?utf-8?B?dVJtVndoTWxadERJdVlmbm05TjJuMEprUFVDUW9OUG9mRkxNRWFMZG1Sdi9q?=
 =?utf-8?B?OEd1ZzZ5bXpDOHpyYThsS0UzYjhkeks0L3lLMDhXdXZHZnphMzNHQUJtbkxz?=
 =?utf-8?B?K3ZZTDV2U0lPVFZRbEVuSVpMcWJOQzF4a0lWWEhVTmhVbVk5OFU1UHFHaEg2?=
 =?utf-8?B?eWNJZnZFek5JMnlheGFja3R0Q1I3U21iT3dJaUtOQXBCdWRBdEs5aW80U04r?=
 =?utf-8?B?empDM3dKMjFNMWNJeEJNQzhXRHg5ZHBFR2tPaWo2OUpyamdETzFpNGZuUW9P?=
 =?utf-8?B?ODk4L2JyVFZXcnFndWdKNTY2ajB0ZUg1a1BJMGxiYVdrWVdYc3NkbHNrK2ZI?=
 =?utf-8?B?cmxITVhvanVYN1hWQUZHNHdXaXZVSkFlTEtnb2JSM2hlWGxaaE82aHJ1OUNr?=
 =?utf-8?B?TmlYcnZKVVk4UFNHVVI2YTMwUms2VFpubGdYY3Jua3NhWWFSZEljcmI0bkw2?=
 =?utf-8?B?dHFyN050L3pmVUtJSldZTnZrbjkrRFZNKzhlRlBZK05TR1lseitaa3N6ZVVN?=
 =?utf-8?B?cjR6d0h2RDFJNmJ6OVFlQTJ0d000bjY1Mm1jOHNQTXZMWHdFYXBKNnBNMENK?=
 =?utf-8?B?eE4zV3FueE9xc05TWGtXSWZDSFhmN2xMc1FQZ3pCNkZ2cjZ1SWRiaThVNC9a?=
 =?utf-8?B?aHVoTmVuRk1Ya3ozNWpPOWRiV2VDUkpRdkY3OVFsU0lrRDJoSzA4Tm5sU3NS?=
 =?utf-8?B?K0NmNXZWYTIzT0NTbHIrUFRDSTJrbUcvMEtxdTdHK2pTa2JiZ2Z0ODM2dEZo?=
 =?utf-8?B?OFdNTWtxbWVDdmdteVRQWUI4M0M0Z0RkazhOaytCRzVYVkdpV1Y4U21LUEhj?=
 =?utf-8?B?V2pZc1kwcnBQa2ZCODhtbFp2OHdRcElraDFmbDJIZTFlbGJnQ3VxWEtiN3VT?=
 =?utf-8?B?OE5TQnFmaUEzUWk0SGNlbUVoeGxmUVhveGQxUzcreGszT0c1QytGYlplT0NW?=
 =?utf-8?B?S0hhZkJ4K0hVaUt1MlU2MmtCN3RjYmFoWlNXb2lLb2UzTEVGakdETEJSZUpo?=
 =?utf-8?B?UVJEbjMrYkJSa3hKOUVIMlpUMmMvWnR3NE54ZE5jTllKUUl1VFl5eWlKa3lq?=
 =?utf-8?B?dUhnR3ZMcDdaS2VSVWRUUE5JUXhUZjVCL0FYdjVkWHE1Z3ZGRklHaGZ4Y3F5?=
 =?utf-8?B?T3Vtb0FvSTBRVkYyYUlrQjMwSkJRdzZwc0U4a1g5dHB4V2pRMkhLc25vWGhV?=
 =?utf-8?B?UFNVM1c5NXYxTVh5V2o0WUlDTEJsKzd6QWdta0tja0tOZUpsR1FNaTRqd2ww?=
 =?utf-8?B?RVVJVzJBdGNLN1ZyMzFFREQ1TVg5WDg4TnBUN3AxL2VEbXMxRVh1WnZ3NHA1?=
 =?utf-8?B?NWNuNWpRU1lzd3g4QjR5cjhSYTgrbStMSjRhUUVqVlZzNzlCaENCTXlwNjIr?=
 =?utf-8?B?bmRPWlNSbnhCck9VWTZqQm5uYnlTQkpCUlpJaWEwZ01JN0xkOFhVRVpDeEt3?=
 =?utf-8?B?QzQxL1NTK3BYRU5YdVR2VkVKYzdRZlFsQkNnZTFmeEJESDVIcG1xZjBXK2o2?=
 =?utf-8?B?UGdock1ldjlFRU5SYjM3TkVVR2xoUnoxYUx6bEppNUVhSTdSRzczVy9VUk1l?=
 =?utf-8?Q?No5eHUpsB3XfgWjfGcKyfSeel?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 503dccc8-1d9b-4cb5-0d9d-08dc3f40a236
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 07:23:21.1522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXJTXqPRl4jWuTjjQ0BHEg8xO2ydMvGZSl4tzldhV4DhcxGf9nNMHgR2ex1Mp+sVaOJfY4B11ANJfpJ1eeu5CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4660
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBGcmlkYXksIE1hcmNoIDgsIDIwMjQgNDoyNCBBTQ0KPiANCj4gT24gVGh1LCA3IE1hciAy
MDI0IDA4OjM5OjE2ICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29t
PiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNv
bkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIE1hcmNoIDcsIDIwMjQgNToxNSBB
TQ0KPiA+ID4NCj4gPiA+IEN1cnJlbnRseSBmb3IgZGV2aWNlcyByZXF1aXJpbmcgbWFza2luZyBh
dCB0aGUgaXJxY2hpcCBmb3IgSU5UeCwgaWUuDQo+ID4gPiBkZXZpY2VzIHdpdGhvdXQgRGlzSU5U
eCBzdXBwb3J0LCB0aGUgSVJRIGlzIGVuYWJsZWQgaW4gcmVxdWVzdF9pcnEoKQ0KPiA+ID4gYW5k
IHN1YnNlcXVlbnRseSBkaXNhYmxlZCBhcyBuZWNlc3NhcnkgdG8gYWxpZ24gd2l0aCB0aGUgbWFz
a2VkIHN0YXR1cw0KPiA+ID4gZmxhZy4gIFRoaXMgcHJlc2VudHMgYSB3aW5kb3cgd2hlcmUgdGhl
IGludGVycnVwdCBjb3VsZCBmaXJlIGJldHdlZW4NCj4gPiA+IHRoZXNlIGV2ZW50cywgcmVzdWx0
aW5nIGluIHRoZSBJUlEgaW5jcmVtZW50aW5nIHRoZSBkaXNhYmxlIGRlcHRoIHR3aWNlLg0KPiA+
ID4gVGhpcyB3b3VsZCBiZSB1bnJlY292ZXJhYmxlIGZvciBhIHVzZXIgc2luY2UgdGhlIG1hc2tl
ZCBmbGFnIHByZXZlbnRzDQo+ID4gPiBuZXN0ZWQgZW5hYmxlcyB0aHJvdWdoIHZmaW8uDQo+ID4g
Pg0KPiA+ID4gSW5zdGVhZCwgaW52ZXJ0IHRoZSBsb2dpYyB1c2luZyBJUlFGX05PX0FVVE9FTiBz
dWNoIHRoYXQgZXhjbHVzaXZlIElOVHgNCj4gPiA+IGlzIG5ldmVyIGF1dG8tZW5hYmxlZCwgdGhl
biB1bm1hc2sgYXMgcmVxdWlyZWQuDQo+ID4gPg0KPiA+ID4gRml4ZXM6IDg5ZTFmN2Q0YzY2ZCAo
InZmaW86IEFkZCBQQ0kgZGV2aWNlIGRyaXZlciIpDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4
IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+DQo+ID4gQ0Mgc3Rh
YmxlPw0KPiANCj4gSSd2ZSBhbHdheXMgZm91bmQgdGhhdCBoYXZpbmcgYSBGaXhlczogdGFnIGlz
IHN1ZmZpY2llbnQgdG8gZ2V0IHBpY2tlZA0KPiB1cCBmb3Igc3RhYmxlLCBzbyBJIHR5cGljYWxs
eSBkb24ndCBkbyBib3RoLiAgSWYgaXQgaGVscHMgb3V0IHNvbWVvbmUncw0KPiBwcm9jZXNzIEkn
ZCBiZSBoYXBweSB0byB0aG91Z2guICBUaGFua3MsDQo+IA0KDQpBY2NvcmRpbmcgdG8gIkRvY3Vt
ZW50YXRpb24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0IjoNCg0KICBOb3RlOiBBdHRh
Y2hpbmcgYSBGaXhlczogdGFnIGRvZXMgbm90IHN1YnZlcnQgdGhlIHN0YWJsZSBrZXJuZWwgcnVs
ZXMNCiAgcHJvY2VzcyBub3IgdGhlIHJlcXVpcmVtZW50IHRvIENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnIG9uIGFsbCBzdGFibGUNCiAgcGF0Y2ggY2FuZGlkYXRlcy4gRm9yIG1vcmUgaW5mb3Jt
YXRpb24sIHBsZWFzZSByZWFkDQogIERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdGFibGUta2VybmVs
LXJ1bGVzLnJzdC4NCg0KUHJvYmFibHkgaXQncyBmaW5lIGFzIGxvbmcgYXMgdGhlIHN0YWJsZSBr
ZXJuZWwgbWFpbnRhaW5lcnMgZG9uJ3QgY29tcGxhaW4uIPCfmIoNCg==

