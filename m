Return-Path: <kvm+bounces-8078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA0184AF06
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFF8FB233D7
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 07:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5E512882E;
	Tue,  6 Feb 2024 07:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P8frzaX0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3D17EEE0
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707204798; cv=fail; b=Z0fdclubwwEnKyou4dSaaZN/TnYG6ljfbuhVy1OqGjAUIBZ/6aCG/q1zqd/d7uOqcuXt24hcPvmRg1VZ7S1sn1ascovc10qFqqQW2h4kFl0eu//zJEZzV3hsO4s0Y15LTwF0wk/bzW7rB7CxiI53EFF2njabFx82ecMrZiV5PHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707204798; c=relaxed/simple;
	bh=iC61knpLd3uMGwZ0pPxvnCSDFhwGkpfzIAgbgseZc4A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fUeLQAEcdhxM1v4CndOCsD8A5QaFD96tWNvSevoAPJUlHPNGkhT5gOwV46NJn5D+J4nYucAx85JXijX7FA8UgFqpRL8Bydjlvmat6nfwyDveh28PGQXJJDypd44Wii/o7wAlDxfTaJclSI1HVTx/vQu9mKZrXvlweVyzq5JG58Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P8frzaX0; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707204796; x=1738740796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iC61knpLd3uMGwZ0pPxvnCSDFhwGkpfzIAgbgseZc4A=;
  b=P8frzaX0t9QGeq8RKkVG/0aLwzRuWlh15L8Cs6qqxcnKQ2C1DMMqqbgM
   IXr9E5+nDHvFaSUXA/FpoZSGdGRH9aXYtbp22XIFx3G4Dk+fYLPp+HibJ
   1nWhVdPSKlSpU5p48m2UwiN81IXLcpU5P4QSjXaKbRGZ4sDwPAMrZGwm9
   wnCdhOthYrwq0A/heioK6HM1JObSFeCy568ptFJ7/kdd8I9qDknqYJyA6
   zJwi+OXgFYiDng5dkasb33jlDVquQJf/UJpw3I973q2AcSX3XqkUmO64W
   Fzr/zVCNyju2396F476wDSa8NiM+4kTkAjQ9QRrzamrGRG6SXshkGD8rB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="4569419"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="4569419"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 23:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="5562228"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Feb 2024 23:33:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 23:33:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 23:33:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 5 Feb 2024 23:33:10 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 5 Feb 2024 23:33:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxZqGXSEd4QggKaW5iPYjJx/pfruX3szGYB6u5yhXweqgXUAiOtuyg7g8fOkRJH/soV1J7E/e+1QH7zWWST+6DbZJPdTyXAuTCgY4R5kxKqmLaf+yTBiGlvGfzTptRGFp8NyrD7+3fkkr0ePc+BknnkMMaq5hDq380NMHii5mioI+hJ2h7wsvhl12uRKp5pkwbfzxvIFfJAOBNRKpE6kcT3b93FdwZgPUQlaLtx5jyWlObCqSBuGWhGw53Cr7ljKjG1fAw2/K69oizHDbNYdJwiZaelHMwYs2IrOqWZaJUgldeQ9tW/kU6Ob+QNNyv0M44Q5nlifzJI/9kdbvlLSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iC61knpLd3uMGwZ0pPxvnCSDFhwGkpfzIAgbgseZc4A=;
 b=g/SkniRIAZcUOxzBpxkvk8hz32rYLtIv2m5IW6irVPYrFT3V6OfKrSZ71ET5fEyvmapHpzDTGktilrWr6rLmrEnjuICYABma303KNx0kF6guB9VUthtTQFa1yMfzj/6Q0ZXGoNDBSXissts43azENJjx/JVE4SP1/h3heELwsT1GUY8IkVuqjXqP16FlZgzWkY3aL/WkcTjlnzs7/4L1H0muNIupVk2v4Zq0Eft8hAap6XhNBCOvCjoQtuF7LPClF3ErTtXLxUOUqeTXJtSxCZ0NImjh64s3jOP2L7Wr4eDU/e8kwl67vJ7zXS3s9UgjdEsE+sd4xLwtiSUs44MSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB8334.namprd11.prod.outlook.com (2603:10b6:208:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 07:33:09 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 07:33:08 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Yishai Hadas <yishaih@nvidia.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "leonro@nvidia.com" <leonro@nvidia.com>,
	"maorg@nvidia.com" <maorg@nvidia.com>
Subject: RE: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object events
Thread-Topic: [PATCH vfio 2/5] vfio/mlx5: Add support for tracker object
 events
Thread-Index: AQHaU55VErLgbW2DsEuQXOOLlNC0xrD7a26AgAAWdoCAAXP0YA==
Date: Tue, 6 Feb 2024 07:33:08 +0000
Message-ID: <BN9PR11MB5276795DF79D924246ABEDC88C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130170227.153464-1-yishaih@nvidia.com>
 <20240130170227.153464-3-yishaih@nvidia.com>
 <BN9PR11MB5276D9B9CA3E4F69D183D94A8C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <99c9fe4f-1812-440f-8f35-64a714984598@nvidia.com>
In-Reply-To: <99c9fe4f-1812-440f-8f35-64a714984598@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB8334:EE_
x-ms-office365-filtering-correlation-id: 551eebe0-2212-448e-9a6c-08dc26e5ddc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qBEJqoDF4TALVXC+4gQx5XJ1aPiGVdUf84cvlz9BFKUDqEM8q8dckwmBJ40cP3HrWnSLyCUdtlqFtDKsjGSlywCy4SURfMilQQrvb2L/ipiSONGBNt++uIqQ5RAuvd07m1OmQw4jRhdWhZQdN93+aGAMAtSUdklwICkSOXTr05FJspsMQgGBPUuuZ1tsSQuiBreUoAAGMd9t0osjHKW+62eMBD9cZmMLhrpl6YcRXlIziKbKUcsRDO9V32Fb7y+puR73mm6wNiIu3Vb3OtDBMdEYXTtWoccFXyYtLNGwEuGe+MSUl9qrO46X/XWntDs6y99VEqRfKI49dWy5KLIiTXT4EF+B/jC9yIGU29upAS8yWTUnjqvkrrBMb7gX6qI0RNbIBwwKYp35ixd0N57Mqo89RdTMU3Esaqzdrh3+2N4gB8IgLfFbNSxZEFdv08VNtkW3A2qWJ+ubGY2VYoUETr5yxuVv+zGBwYoRo3nQga8czmMsnINZX8QsH2wJqiqmkotgx4KgwogWPmfafJU/pUAfK2kvzWZ9D6YNFJvrwGEefDzNL6RjI/ZgKh4/9x7CJpg+H0V8d81a27sO9JBqOrLYi+wuVWSYbNUsP7FCdwHYItArEeM2lPMy5wkkst00
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(136003)(346002)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(38070700009)(64756008)(66446008)(110136005)(66556008)(54906003)(66476007)(66946007)(76116006)(316002)(5660300002)(4744005)(2906002)(4326008)(52536014)(8676002)(8936002)(83380400001)(82960400001)(38100700002)(122000001)(55016003)(33656002)(6506007)(7696005)(71200400001)(9686003)(53546011)(478600001)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bytJR0Vyc1poUGpvL2dvbTdicHpnek9pbkFPbGVOaGY0eFZCZGcvSFoxUTFr?=
 =?utf-8?B?bVlxQWZXM0xvaFhNS0U1TW1UaFJUYWc1TXdFODdnMUQ4SDJ2c1gvdDA4T1dS?=
 =?utf-8?B?VnVEVDBEWHI2WElEUU1rd0VZU29nTGl2Q3ZyeXBxOFZ5Zk5BemM4YzJ0QnJm?=
 =?utf-8?B?VEpGcTZSRVdtNGRoTlRuTytXNisxMGtadVlSL09TTnBHOWZZZ3M5QWp2SWJz?=
 =?utf-8?B?eE90UWFsTnprV0NmdXRoRm9NZytLRlNvUStCcWdwbmt5UHBidFFFcnhWQzFk?=
 =?utf-8?B?SVNvdjVDQUh2aTZQejVqcmFnSmxDelJPamw5UmhYdnpwbjJvL0hZL1VHbG8x?=
 =?utf-8?B?dDg4cG45UktTVG0wdDk4bkJoaG9WVW02NkNMcVVDSkEweHN1UXR6OGpHREJr?=
 =?utf-8?B?OHNFMytNdmZQbDdxNllWUm9nV2JvM2NIZHQ2L2VLN0dkN0hJcld4eWErd2lD?=
 =?utf-8?B?YVZKa3lRQzR4N1UzWS9jbUZLY05RTWw4bDJuR05zUVFDT3dFb2d4NysxNFpX?=
 =?utf-8?B?RE1BS056QUs5TGRvNGh3amFHN3F2TW43RFVnODZBaS9SaWw3dTFPMmVXVjFF?=
 =?utf-8?B?a2g2c1lwbWw5SUdid0JJNjY5Y0hySFdmQTFpKzJkNStIUGlMR2kwNkpFRjha?=
 =?utf-8?B?RUhtRzFhVC9IdUFqYVdua0NCRXR3M0tQMVVobFk3Lzl3bXRNY1RaalNVY2Fl?=
 =?utf-8?B?OEh5Qy9qS2piVDBKdGZIcnNic291a0ZzU3lTS2hJTk1qT010Ky9RYldYTnBl?=
 =?utf-8?B?MGMveC9ta3F2M29ESDZVSUJpU0t3OXVDdHk4U2NGRVVZeFlVTDBFRkJ6Q2lP?=
 =?utf-8?B?YjM4czgySHVZNzhOczBRWXhWeXpZTkJ4MjFRdFRMQWlzakVicFg5S3BiWVRz?=
 =?utf-8?B?cjdhUm15QUdlV3RVRVlOSm1nTWtLV2hXcGZ0MkI3WmRCc2FFZnloQXBGaWN5?=
 =?utf-8?B?WnczQjU2YnZoUFhYbldqTGtpTUF1TEdCTGZVWlowR1hVQkZ3L1FvcUdoQ1V3?=
 =?utf-8?B?NXQwUFQ2dFhqTXpzS0pRL3VEcW95bGFhWjRKL3RkQWlHQndOeHVlYzg1aW8r?=
 =?utf-8?B?WFVaUnZzZGt0MjFEWXBvOFlNalIzTXNmL1BCVUhsUXdXUDFPY0VLRFlodVkx?=
 =?utf-8?B?M01FYkMrMDhILzUySHRoTzdodVlpOEs4QUg1UkhzeGduVkRUM0h6WEZVWE1Q?=
 =?utf-8?B?QnFKU0RybVhjTWh4ZE9idUJPUS8rTkxKSFFNdFdFVTFjSjlGVkcrbWY1b0hF?=
 =?utf-8?B?WDFVM3FnSEhxNk1kUUwyU0wxTEpRUVdxUkpJMC9GUjRseTcrckJ1d01iVTAw?=
 =?utf-8?B?V3pISThjcWlyc0xmeU9Hdlo1Nmh4NmRrQ0FrUG5SQ01LMERiZUVOS25aMkVz?=
 =?utf-8?B?WW9zbFE5S1VuREJBcmx1SlQwNmJlYWxuYXN3d0hMaldzWXM3czZoMzd3OXJG?=
 =?utf-8?B?SWtCRWpWbnhRSXYzUDBZMjlQKzVISWh1R21lUlBDMUdyc3ovTVg5WWR2S0Ri?=
 =?utf-8?B?SjJ0OWc5REZwSjR3bG9wclgzSTNRcko4akFBN0V4OHJwS1lhNkY0VDMwUHhT?=
 =?utf-8?B?cFJLRE4vRXZsRVFxSVV3UDE2b1UxaTdrRnNuRVZvOXZXdFBPcTN6SkMvRUxR?=
 =?utf-8?B?U09PcGJUdEU0ZExhZGZCTzFqZXNpLzVwQVJ3ZlFGeXJkbzF3Y2h6cGxNY3dT?=
 =?utf-8?B?NTVxZ1YvRFZvWks5U09UUUFjMHUrYU1TVmVmRFloRTlDTDVXOXR4NlVhS0ky?=
 =?utf-8?B?eUNZeGVNNTRtOFRtY0VsWkdORkI2RVFYTWRzaHM1MHl6SmsrNGVhR1BDZG03?=
 =?utf-8?B?Q2hxdVFLc0RQOEFVVU5mVDRLRy9wRHdJOUliMWhnM2lHVzgvTDZkQUx5cDVR?=
 =?utf-8?B?MXlDNzQ0WUplcFFIQ2tHSmtDUGlNL2xON2RmT2tFaTNFdW5tWmhZUTVmWklH?=
 =?utf-8?B?cWdUczFqVlZoRXV3di94bFd0RVdPZmpvQ3YzbUloeThlaUdWd241RTZSMzNS?=
 =?utf-8?B?eGZCZi9BYUQyNXhTQmk4amQxSlhWQzBldGRjYVJIQm9nMUwvbW9Tb3BOT0RL?=
 =?utf-8?B?bExGSExnNXBhUmh2OGlHZnRwRXBRaGl2SUx5Si9jR2xrSnNDcmZYZkhWeDgv?=
 =?utf-8?Q?UzDujsYIQD44kXVlBaJeKvUnq?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 551eebe0-2212-448e-9a6c-08dc26e5ddc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 07:33:08.9559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gv7Zk2nzd8GgjiUQZPZtOCroWrsL/x7W0znO+gfdUmh0G29YfuD+1rR721pP/DvcakibIKKkVZjpfA0Ww5dFPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8334
X-OriginatorOrg: intel.com

PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlhLmNvbT4NCj4gU2VudDogTW9uZGF5
LCBGZWJydWFyeSA1LCAyMDI0IDU6MjEgUE0NCj4gDQo+IE9uIDA1LzAyLzIwMjQgMTA6MTAsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbnZpZGlh
LmNvbT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDMxLCAyMDI0IDE6MDIgQU0NCj4g
Pj4NCj4gPj4gK3N0YXRpYyB2b2lkIHNldF90cmFja2VyX2V2ZW50KHN0cnVjdCBtbHg1dmZfcGNp
X2NvcmVfZGV2aWNlICptdmRldikNCj4gPj4gK3sNCj4gPj4gKwltdmRldi0+dHJhY2tlci5ldmVu
dF9vY2N1ciA9IHRydWU7DQo+ID4+ICsJY29tcGxldGUoJm12ZGV2LT50cmFja2VyX2NvbXApOw0K
PiA+DQo+ID4gaXQncyBzbGlnaHRseSBjbGVhcmVyIHRvIGNhbGwgaXQgJ29iamVjdF9jaGFuZ2Vk
Jy4NCj4gDQo+IERvIHlvdSByZWZlciB0byB0aGUgJ2V2ZW50X29jY3VyJyBmaWVsZCA/IEkgY2Fu
IHJlbmFtZSBpdCwgaWYgeW91IHRoaW5rDQo+IHRoYXQgaXQncyBjbGVhcmVyLg0KDQp5ZXMNCg0K
PiANCj4gPg0KPiA+IGFuZCB3aHkgbm90IHNldHRpbmcgc3RhdGUtPmlzX2VyciB0b28/DQo+IA0K
PiBObyBuZWVkIGZvciBhbiBleHRyYSBjb2RlIGhlcmUuDQo+IA0KPiBVcG9uIG1seDV2Zl9jbWRf
cXVlcnlfdHJhY2tlcigpIHRoZSB0cmFja2VyLT5zdGF0dXMgZmllbGQgd2lsbCBiZQ0KPiB1cGRh
dGVkIHRvIGFuIGVycm9yLCB0aGUgd2hpbGUgbG9vcCB3aWxsIGRldGVjdCB0aGF0LCBhbmQgZG8g
dGhlIGpvYi4NCj4gDQoNCmV4Y2VwdCBiZWxvdyB3aGVyZSB0cmFja2VyLT5zdGF0dXMgaXMgbm90
IHVwZGF0ZWQ6DQoNCisJZXJyID0gbWx4NV9jbWRfZXhlYyhtZGV2LCBpbiwgc2l6ZW9mKGluKSwg
b3V0LCBzaXplb2Yob3V0KSk7DQorCWlmIChlcnIpDQorCQlyZXR1cm4gZXJyOw0K

