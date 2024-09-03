Return-Path: <kvm+bounces-25776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E19796A4DD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A12581C23AED
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE4B18BC3A;
	Tue,  3 Sep 2024 16:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cYnZYRAy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D766117A90F;
	Tue,  3 Sep 2024 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725382407; cv=fail; b=Z1GzbbeK9sD1vdp82cVxrXu6fiSl//QzyNZ3wszCVfZP/e/mpnATqytf5vq9CTsyixho3mfSxNrKMKrOtFGIC1yOXZOvulVAIBw1JrWHSvE/UwKX9kqLj395fEGkpEEnzxoYXZVnbIlznrqe5RTZQihEQm71fmdBDXw4aD+EGsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725382407; c=relaxed/simple;
	bh=7E94LJ9uGnKntDcQ5RNO2jo2sRy3OwBFBTKMjJY0Mjk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cJQrkXzgV41YVOOwcWQ2A/ret9OWKZj65BhQPjki4lFzocKCNkRpaxIASdDzrAu7S54/xcevr9S3dDvxCq53LcxyCh1wd2pbilhreXWgNJtWyE4T8ltz3GiQXIScd027If/e2KUeqYRUi9Uc0HvdQWEh2vivrLVbd0ucp5xuJX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cYnZYRAy; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725382406; x=1756918406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7E94LJ9uGnKntDcQ5RNO2jo2sRy3OwBFBTKMjJY0Mjk=;
  b=cYnZYRAymghDldtb3S1ADGN7KOUDTpw3Nt3phrkY4ZPXSQjwT2NdFyvc
   LV6JrnFa/fvlIoV3xSVwdR8BukG/1yjqVyV3qO2Vg9k7i5a4r/ZytfcqF
   XXoZI/AAqTaKbZSqec8oPaoWyH6cbl+3ahK9z/gP1a62Clu7b44RQmx0e
   1XRHaR73qfsoDUOV/9dtXzo6svHW3T0uUxnToMtIM85hjl8kU67bJIGKH
   EVSrO3Fg3nH+w5ZhtwhZRNLdabgfEeeGA3IS9g9Leq6taEklZTGLINgdO
   OYU01n7zcKcS/yETPp3bm44VdN4PkNHAH6oUeY4D6IRLZcXrR/ODDTWE9
   w==;
X-CSE-ConnectionGUID: HS5OjwZqTw62mI8ladbZkQ==
X-CSE-MsgGUID: ZnqoO8RtQi+5iXdJ8CvDlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="35363096"
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="35363096"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 09:53:25 -0700
X-CSE-ConnectionGUID: NcC4HnXzSRCEu1gDO2pgLg==
X-CSE-MsgGUID: JYr5u22CR9WSYapFv/OFTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,199,1719903600"; 
   d="scan'208";a="64619376"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 09:53:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 09:53:24 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 09:53:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 09:53:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 09:53:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SccRMNAC9E1dqEVdkL3Lri8Jsy7A9L1FZI6nydo2U2UTJJJQjRfNnAlr/KUOqVugyW+qK84Au2aGtBkyxQxZ9ZmtMq0xug2lQ7S4fkpQZGO4EjEql99Y06vYXBP1cspx4+FOoVmmhZLdUS2th9Kz9ivCOjQlvULNn4dSUkk6QCUgYcIpacdz657Fr35Hofw1EwRpzxi0TjYzozML9f0gg9KzJdTu7q6CtmDSgRixFo6U0Xl9HhU6FmadcCqgSQxJuX0kzjuPwYMrGIpXWEuNGBnvjRG/RydZWgbzLQlmaalrkcUh57l7XYRyvWyY6guKp0WEkIrrtYsSHKAvay7k2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E94LJ9uGnKntDcQ5RNO2jo2sRy3OwBFBTKMjJY0Mjk=;
 b=R3+77nJ8KRbDSE6c2nvglnDntbLl1sFo4XAo9ez2l/GxnLPpl8yEpZNOR7oumJ8Y8b27zS+qAGuE2CIL+fGuSJd6VYdtgUX4jL0bnjOsywCHWTXzgxs7Iqs0+htUPzPnJvu2dsvYtrXoKZ3fObClQSTNtj786oCPW0B+fCCQrlOLGeOIi5xau7rBC8+gTZEQzxCIeemIRVK/zx79MziC3DxkFrEvI6xuenYTDyenfd0BFX5GO2HJfrX8EwdFYsJ9jf6HfBD7w/xAPKqyDqLGJ7E5jAUYksDjLeJfteSjvkSUgpXa5KYV30RAFt+inFJ9JWqaGMgtwv+Y6vOZDt91Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8095.namprd11.prod.outlook.com (2603:10b6:610:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Tue, 3 Sep
 2024 16:53:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 16:53:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Topic: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Index: AQHa7QnMfdJd7ajyXkyOXXExCWhU97IkhtqAgCHioIA=
Date: Tue, 3 Sep 2024 16:53:20 +0000
Message-ID: <1483ed2e0b61e8d01be7002b04807275f7748ea4.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
	 <ZrrSMaAxyqMBcp8a@chao-email>
In-Reply-To: <ZrrSMaAxyqMBcp8a@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8095:EE_
x-ms-office365-filtering-correlation-id: c7cda193-1341-4bfb-3463-08dccc38eacc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NEt6emNYQnNtUVErU2xuVUk5VE5XR2h2Z2RHa01vU0dpQjdyUDlyYkFjOHVJ?=
 =?utf-8?B?TDh4K2QxQ29tUTFXUHdwL1VVY3dlUnMrK1J4OEJ4WkhIMHJoMVIxNzI2dXc1?=
 =?utf-8?B?VHg2eUhHWWxVWHlDTDVkUVRzUGVNRDVOYnRYY2E3TE9YeittMm5ZZEJxYnkr?=
 =?utf-8?B?amJBZHFXbVhGQi9sUDV2N3VEUHJTcFNGeU5WcW5KOHV3dWFuV3RFMW9oVGxQ?=
 =?utf-8?B?alpuSGxaOFlxQmNPcmcyVnZvaExFZ2VzZEx3bG1ZbjhKR0oyYmcxdHZFOUhr?=
 =?utf-8?B?L2xKOGlaa1g5dng2Z0lUMFZWbEZpdm8rQS8zZW9JaWFXY3l2VHJIRkdYVnJ6?=
 =?utf-8?B?YURRbmxBbGVtYzZKWGdtNThPOUpxaTQ3QXY4WEhFOXQ5aWNzdmUzOERmLzN5?=
 =?utf-8?B?N3dKR2d3aHRlN1VLN1VkczMrOFI4ak5lbHRTUU5INDczYm8vbW45KzhyQ0FB?=
 =?utf-8?B?UStVcGlGNUtYNUYxUTI4cXF2dEJFZjg2bmlpMjhDVHh0clNWSWpScDAyRHJO?=
 =?utf-8?B?MFRuRWF1UWw2YUlWWWY0S0NNbkdyQ0FDM1ZONFJNWkxudkk3TVBYRzFMdGUx?=
 =?utf-8?B?VDRKRFNmSWx3WWZSdzhta1M3WEVvNXZKL1FoRExwYlJ5UHZxaGtKRmRNYk9v?=
 =?utf-8?B?OXg3Y0t2NURCUkNSZmh0N1FiNmc4ZmlXTyt6Qlc4SGZNeFZTbHE1RVJ3L1I0?=
 =?utf-8?B?UnZQR3ZvQkxMdXFmekhIYzRwNm1hUThkUmQ5Tm9BekVzVXlUMDI5YytzVk5C?=
 =?utf-8?B?R0ZQRWFjd1BBNTdHNUlsMGNET3crczQ0RHR2ZVVISnZmTkZmN05YcEVXV2Ny?=
 =?utf-8?B?OGtDY0RGeVZnK1FMelBMMU52SCtHQi9WdmR3TW4wbTdUaVVmZVloejBUNlAx?=
 =?utf-8?B?MVZQSmJkaUhETVhob2plWUd4cm1PUytSeEIwQzYrckdaL1R4aVJiRkM0SEVr?=
 =?utf-8?B?Uk1tME80WFZla0diQ1FLSFJaQ1ZGMVpjL3JqdUJxQXo3dEtQWmlsam9jT0ZW?=
 =?utf-8?B?b1FXSy9uRGJoaEdVZEtBUXB5WmhFQUx4TjhYL3cxdng0R1dQa0c1VTdnYkc5?=
 =?utf-8?B?Y0E1ZHY4MENYVzVrZTZjeGl3SnUwY0xRakJnU1BEc0xxK3R1eDdpYTdyL1Rz?=
 =?utf-8?B?aGErQ0laNWt3RUYrR2JWUlhVVXRvKzVETnc1SVJVOHNIOFJibWZtbEdraWls?=
 =?utf-8?B?aTA1S3VQVG9Lc1cvKzNEUHJzSkFFQ0p2dW1vNVBQOXlUcjdNcXJpV0tZaUNC?=
 =?utf-8?B?UjhsNlhPd1IvdVBIZjZEQlVRa0NHK1NGRTE1cmxMRlRMTGhKQlpuOURHdkpY?=
 =?utf-8?B?eXk1U2F2UFZESVpzWUF3ZGIxdkZncEdVcjEwKzc3VU9ZbWxmOGJiYXdFWWV3?=
 =?utf-8?B?bi9VK0thMEQ2RXNzNGZxdkRCZE5CVTdaRVZwOFk1S2QveVVFU3IzVFBwRVNV?=
 =?utf-8?B?NVZ3cFE4TVpwL2x2Mzdodnc3MjlVV3NCV2dIOHJiejBIcFlGTUNRcmpHM2N6?=
 =?utf-8?B?OThaR1FIcysvTnZvL0xNb1NueG10dE12dGxQQ05ZZUhoV1RRdUlWR0Q5cjZ0?=
 =?utf-8?B?YlpTQkpqNE9lSDVadmNCdjBmb2ZSSkhNcEZOYjgvZU9IdWl4VWhpQkNpblkz?=
 =?utf-8?B?WUoyYy90RlhOUm5BQVZ0S0xOOUZxM0c3K1NJdzl3RzVtcFJwTGZaL0xSVC93?=
 =?utf-8?B?dG1zU3RrdE1wYVBQTGZhdC9NbWg3ZDU0V05yUDhHZXhxVkVTZVhEM05UejlF?=
 =?utf-8?B?NmVoWUo5b0haMHFIWVZVS3VXS0xQeGkydkdPY1lFSVphUE55c0JqcFRNblB2?=
 =?utf-8?B?ZXlzdXIrRERBOWpjcmh3VllJWlltbkw0dTVJdFdEQlh2WGFiMGVxVFMvVlRi?=
 =?utf-8?B?bFpLKzNXVHExWTR3cTNua1JLdlVvd09CdVpaZGkyTXhEalE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVVXdkpMeVhGVkRIcERRQ3pQaC9nMElLYU5Ya2M3SkcxaDZBMmtzeDBiVGc1?=
 =?utf-8?B?S3BTeDBTWDlTZGxaZ0tGQzQ3akt3QVYzM2ZZakZuZFFXVnMwUVRwMndyckgy?=
 =?utf-8?B?a1gvdEV0eHpYSEdlR1ovSGhNVVhNOWtQdVVNTHFJQXdRWXlCUGtSOXFjN1hj?=
 =?utf-8?B?V2RialRQM2NRdnlkdHlLOGphZWxlT1AvVGhHbG1nbFJjUHgxbE5yRUpjSjVq?=
 =?utf-8?B?MW9NTTFFVjFha3l4cTlPVjErakZlL1I2aEo3Skg5dEo2dWtEK3lzYXBETzBD?=
 =?utf-8?B?NzVUOVVVbnJ1MURSMW1wNHc5dnFWL0s2S0VQMWxlM0RoOXFzSEVpWmdjaWQ5?=
 =?utf-8?B?UHBiSlQ0dkovaExzVnk3VVVqOWN6WWJZM0lWUVYxV2lodjJrZVJmbXRkbHUy?=
 =?utf-8?B?T0NCZmRWNGUzSkplU0dBVUt0bkZNelo1enYxZkVlODlyLzNjNWFvbEQ3Qy9v?=
 =?utf-8?B?enNXbncvNEF5ZXVUMjkxcy8xTDFsZVAzcmVKclR2ckcwdGJ1RzR5bEhiWXFk?=
 =?utf-8?B?TEpEc3hKcy9jMks4aTZwU0Y1c1lOaDVrOFVLaGdZajBnR0xwZzRjcWlLTm02?=
 =?utf-8?B?bmI0bE90SDMzMVVEWXF1OTRPVkZBZjVzbkJuOHhxL0RCU3lUbWhsb3BIVVZY?=
 =?utf-8?B?YVBSWXNGQUE0QmhINjRjeU1BdzFXK0thOGZWeUdUNTVZUVB1eXFHSENLZkE5?=
 =?utf-8?B?aGFIYW9kc2ptOWpWRDh0ZFdHaDdkSmNEdnR5RmdHZGEyV0dOSkNzWXBsNmYv?=
 =?utf-8?B?aWc2eGthejkvT1pDUlBGUFZXbktmTXZES20wZFJqcE5ZTGZHb3NYU1M1K3Nv?=
 =?utf-8?B?d2syVFhLQlVyUGpkcUFSTUJ0WndjK2JyQjV1TldHNXZxampWdWxRQlpYb0d3?=
 =?utf-8?B?OHZnOHZkdDg4VVFRZnVyQ05WT2RjcG9ldHlzc2JFQkRLdWNLc1VoQktRRmRD?=
 =?utf-8?B?STBDc1Bwd0tBQ0pkQlhQYk5wc1VTYXpMM3RiM20yaWIxbSt6ZnhuTTNmb0hy?=
 =?utf-8?B?RURCQzM5clZOYjc1dUpJS0RESTlSaTdIRU5KUmt5cTZnN3R4OXBiT3lxM2tL?=
 =?utf-8?B?Uk8rM1ZBY2R0V2E4STU0NU9uN0ZBamFwNUdVYmUzNHUxUGhpSlR5dkd6cG1i?=
 =?utf-8?B?Y2wranBqUGMySkNWMEJONVdjRHlMWmhSY0szcW5yd2UxdWRaWHByOFdxUndm?=
 =?utf-8?B?VmZOVTJKd0pHNStVNVM3aks1Z3IvM3U0c1J2NU9yd2xnR3NhZ1k3T2N4Y0tF?=
 =?utf-8?B?RzE5OTV3MlkrSlZqMUxEZlo2cDltOCtud0tzNmlZQ056TW8rZHIwRkdieDZZ?=
 =?utf-8?B?VElVdnNscWlPR2FRTDFKeEpCWHkxRzRYeHd2L3k2ZXVsM2c1NTluZU9rNDhk?=
 =?utf-8?B?YXpNZTlmMmVwdE53dFQvUUpwbkVxMDQ4NWk1S0o5ZUEwT2E3bE0rNUhZZnBU?=
 =?utf-8?B?OUJWNEFtSjBlbEdZWEFyR0lMZG41MmhZMks4UVQyK2d6akp2dnhnOTFkbkI4?=
 =?utf-8?B?RlpUQnFLOG1FR1h3aDBwTjRQZFpOMitUQ2lLUWg1M2xuSjM5M3VBeERoa3VQ?=
 =?utf-8?B?MWo3cHRwclhYSVBHV1dxb292K3dRZ2Y4M2tLRzVlNVhDTU9FVFo2cjVzLzRu?=
 =?utf-8?B?UVNjYzk1Zk5LR2hnSE9OSW5XbDR3dEFFbWZrc0lxNjVrMnRSTDJXazlmc05X?=
 =?utf-8?B?RlRJczZHZEhXK1pRa1Q0bWZZbk1lOXBsMDROSTFVYkFpc3VvL3kxMTlOb2Jh?=
 =?utf-8?B?VThZSDdrS0FUeHQyelNwR3Q5SXQwYmZxaTA1eERIZlBiREN0WVljN0dVRk92?=
 =?utf-8?B?Qm5mVDM2bWJFRjNqbS85WXNjVXpUTDZaSHdZNXh1TklBRXZQL3VVemYyMmZq?=
 =?utf-8?B?MDFOTUI3L2RheC9IYWplZlduY2pIbFlMQjRZTnBuMUxtb2xZdG9UbExCc0xE?=
 =?utf-8?B?Q3BVY3ZmbVNsY1FNdDlkTHRreEhWcUlkNTB1eVhmWkpPdWRYTHZtNVpzRXcz?=
 =?utf-8?B?UVROWmFQUlh2bDhwNGlkR2R6M2Jma1BwTWpWVWRTWFlwU28rM2hlZEpvc2lR?=
 =?utf-8?B?YUZLdTd4T0JGU0h4dzkwbVVCWHhZcmxIeXVQaWNyMHhoYldIT1F1RGFXcnZs?=
 =?utf-8?B?OWNab25WYkJ3MFdYczlYWkZQZE5IbmxscCtRb2dPRjRka1c2bExlSG5wMjFW?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2AA4DAA711E491418B94AE1DF087AE64@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cda193-1341-4bfb-3463-08dccc38eacc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2024 16:53:20.9201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cp/9kt84Twvhu3oHpgf4YzeC9/zASEFcmj6cUK2OHrPVZBOktvar9G1pf6vwKwxlEkcARjww0z5E9ZhV9UwfA493RpQoZbszPVNK2WL7RlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8095
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTEzIGF0IDExOjI1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAr
wqDCoMKgwqDCoMKgwqAvKg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIFBUIGFuZCBDRVQgY2FuIGJl
IGV4cG9zZWQgdG8gVEQgZ3Vlc3QgcmVnYXJkbGVzcyBvZiBLVk0ncyBYU1MsIFBUDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgICogYW5kLCBDRVQgc3VwcG9ydC4NCj4gPiArwqDCoMKgwqDCoMKgwqAgKi8N
Cj4gPiArwqDCoMKgwqDCoMKgwqBrdm1fc3VwcG9ydGVkIHw9IFhGRUFUVVJFX01BU0tfUFQgfCBY
RkVBVFVSRV9NQVNLX0NFVF9VU0VSIHwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBYRkVBVFVSRV9NQVNLX0NFVF9LRVJORUw7DQo+IA0KPiBJIHBy
ZWZlciB0byBhZGQgUFQvQ0VUIGJpdHMgaW4gc2VwYXJhdGUgcGF0Y2hlcyBiZWNhdXNlIFBUL0NF
VCByZWxhdGVkIE1TUnMNCj4gbWF5DQo+IG5lZWQgc2F2ZS9yZXN0b3JlLiBQdXR0aW5nIHRoZW0g
aW4gc2VwYXJhdGUgcGF0Y2hlcyBjYW4gZ2l2ZSB1cyB0aGUgY2hhbmNlIHRvDQo+IGV4cGxhaW4g
dGhpcyBpbiBkZXRhaWwuDQoNCkkgdGhpbmsgd2Ugc2hvdWxkIGp1c3QgZHJvcCB0aGVtIGZyb20g
dGhlIGJhc2Ugc2VyaWVzIHRvIHNhdmUgcmVxdWlyZWQgdGVzdGluZy4NCldlIGNhbiBsZWF2ZSB0
aGVtIGZvciB0aGUgZnV0dXJlLg0KDQoNCg0K

