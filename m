Return-Path: <kvm+bounces-72794-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yFhSFKMqqWkC2wAAu9opvQ
	(envelope-from <kvm+bounces-72794-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:02:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4645520C191
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 08:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A71B73025E20
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 07:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65022989B0;
	Thu,  5 Mar 2026 07:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6gN8zAD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B5C28A1D5;
	Thu,  5 Mar 2026 07:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772694171; cv=fail; b=If4fb3Ijcb6SzyrFiglqeihfOwCYoTfX9lHmFSZsH3UqTtbfmwZ+4AUxHobv4IZSePHuXz71S0QoILabLAtsDVzozF4e+bxQ7MOjMRI3kXINfC8md5mrv19jV1vVYFbLYzZflpj9UCYd0muPlJ1hrHeiYPfD+0xsXEkfoz5DV9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772694171; c=relaxed/simple;
	bh=qO3DDqQmKxfkiOs3klrBaC7mmgWQkZisO/HqrpNo7xw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GN/gcQCZKKLDKfongpCs8zSakJSc+rnMJ8w1XfzrQevDHEcaGVABp5hFoXNCXtzYmG766G2TFqpTPWMaRVsGIOY13fNrVSzTXtQkM9x21DwQ3kg6jogJhF9jOMvjmWHKZw+/SISaELKQnBgdG/cUO75SNez2DOA7koasAcVPYFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6gN8zAD; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772694167; x=1804230167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qO3DDqQmKxfkiOs3klrBaC7mmgWQkZisO/HqrpNo7xw=;
  b=C6gN8zADuw95cZq4BZCrEYf9SyZphWnMfK1yo/rj9x+OmYlOCe1TkbeN
   Hdq5kM4Ba6WGb7Vkn/PFux1KhT8MDIeeXFub7TlQBxQKnwGR8C0z1jTf+
   xZIZTaju+5LpqIzVUyU2CkOeoRaUjuTjgZTMZq6pxtjSqJl1K3b/OR2WK
   A6uA1cM7QBDpaYn/PWh1VucX3AXld2l0XEReag1zexZHggz+/tLLS84bV
   K/T0mNlPmr2GXhubzH+GUbaiTuYjZkRFuqyTo9G4/g1qrAVXQ1MZehKDq
   6DgLtT97pnsoxNqSSf7wWl47evP7mUYhfgcuRaewZB/P0TLYhwIofOata
   g==;
X-CSE-ConnectionGUID: /bONaa2QQzesasUwWSrSWg==
X-CSE-MsgGUID: cXPui+D2SJmyre4bM5klOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73472364"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="73472364"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:02:46 -0800
X-CSE-ConnectionGUID: FORxQ8CRTVC64TW8hoLHgA==
X-CSE-MsgGUID: vVOW+NVYQmqAVCWAqSWHOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="249057468"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 23:02:46 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:02:45 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 23:02:45 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.30) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 23:02:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uCHogS5BEc7/dnHmaUr0qzsJEEXlCW05tHjGQNMd9j3SsS5+0cowWzGg5aK2ArVxvoZWrQbFlB5myMPBjZ903YqcP7jC8iHlP8hRA5GvoaAr9sKm+bu/+mqMvwWCo30nRVrubVXzz/fdSqSFMhG7N1A32U6X34CkguCyXlxGiXu/JlJKF8zYhBhhWGEqog653cHaK/l7BbOq1CitWzVUH41w4rMSeKSyDrnDdfS6onNr0CtH/er73NvGee5TYcFe9AA6LVmurSG60btSffWvJE6UYJbsm9qoDnKkR1IxkzqmQsPeKHkv04QX/GlqzEihla8VD2YNko2/P9+GwnH3dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qO3DDqQmKxfkiOs3klrBaC7mmgWQkZisO/HqrpNo7xw=;
 b=PNES2a0apJo11HO/wPGpntqzjYmunWt5+6JZlc155Vk8LIOkCgZqaj1mWdUAUeB9TNkZrd5nU8Jm8xjFABb8URD+8HipLCI9oO7ZW9gd9lVV+FYq6YcYQRL4ajJLfjvaOvzYN2FsMfSNSXAGtbacF8ax0P8mtjqh5bVw/cnevb45H832gx2LMIvUFIH4qy4Fvm41Pu9ePYMv/GLYnxI69TdR8rGlgwxHqrYRf9CuIUIukO/v6MqqU+xh5hWEqbrbsTlf29SwpSan8ETV7prmAVd1d/iBXNctJOO+CKABAPdhhnRxr/JZbSbHdmT+aSKkfz/yzaUMWx4aEEPndAaifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 SA2PR11MB5179.namprd11.prod.outlook.com (2603:10b6:806:112::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Thu, 5 Mar 2026 07:02:37 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Thu, 5 Mar 2026
 07:02:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 08/24] x86/virt/seamldr: Block TDX Module updates if
 any CPU is offline
Thread-Topic: [PATCH v4 08/24] x86/virt/seamldr: Block TDX Module updates if
 any CPU is offline
Thread-Index: AQHcnCz9/3oTEjRns0C8a2Fuaveo3bWfo7yA
Date: Thu, 5 Mar 2026 07:02:37 +0000
Message-ID: <dd0996c343c0d0447a76f2edb073e67f8779c130.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-9-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-9-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|SA2PR11MB5179:EE_
x-ms-office365-filtering-correlation-id: 5479b79c-48ea-4b4f-a5ca-08de7a852f36
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: IBjf0xat5Lb5T054+Ub9JcZ62XNOuY2H1ZWwTt0Xc405N9xDC321kNnoJHGfsk/2xxd/tyoL/XCxl/u2feAVYBhK0QBPK/tsiFO3mkMQoWQKX9SVt9TJpbjIQlMXa5uEwaInGsU8IWmlubRFWc3xA8ZvyhptA0Eo1O0QsiILsBhcIretAcNTGBwxPC3FTujzsLz1jjv0oNirw4BUQDTESuhNBOf6uVpPhA7vxjQwRuLJ456ikjQdC/Tp2yAwrGM8XgD8Ohecelv8OCmlPU4+R2+rR4mdFP32fKZ9PHm4NBW/NDO1fDDKnx5npDVxUP/tEPN8XOqY+XcuiZcU22IRARDi6XTW9yzemgapWr2mHNFDDHp0lYoRpSFKT5SJT2CYjXICnjetW9qcFStkbk+9ZMxWV2c4EFKTyZBZyrecWj1hy2U4EX3NGFFQgk9a490AfYukiwJqzX0czBjJoDr5fbrpEjcOi0pF3iffnC5XGJ/kfpqCpK0JInMgSuPzVJ/mDJuCnTZM6G2E9cPTZ2R7cWXYCfs0ulMpdYZgojyzSonqysSR6RrqnZGbHfTcz0Nfbg+FASzoQKt41z3C8nXAK59tav8Utic8A2AN1VDECuc2JOjvSastm2AxJU01ZUFxEfBm7Hql3YsVdsO/3kplQ3K03ZSlAm2QNPnyGV9foQ62nUNd3AZhBjaMWCqkM/FaxH4vD4CVsyr1JAkAXhIT7ePaeaJ62IWrz8UXpe7Y5yNVRwVOB2ChOlRQ1on70UusIeJ2TIA5e8Tx/c5iQI/ASZmT/EY5NzWeU9z4/84kjxo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVAzTGE4dHoxT3ZyRE5waEltYkN4R3BKbmFqNy9BSDU1ZUorQmN0RDd3T1J5?=
 =?utf-8?B?ZEFUR0VzMGU0ZlNNTHBVMUE0emtNczBEZWtKSGFrSncxaitoUWNUU2dydWcv?=
 =?utf-8?B?eWlwdm5DQ05uUTNHR2h5cklydlZvc1RGd3ZMemk0WVRRZEVSYnVLQ0NUTnZx?=
 =?utf-8?B?UjVpV0UvbmtGK2Y5Vi9sK3c2UGxuUWoySCtMU3d3Z1VYSDJKZVMyc1UxaFBy?=
 =?utf-8?B?QkkzMG8wVFRpWU9QRDJ3MkU2U3hJREordjUwcVl2NnRoZHozbGdMWXFxS2VT?=
 =?utf-8?B?VVhhTG5DYTFJQWxrWTR1UTBMYklKSGxFbHdoQ1BHcSthUCsrYjdybGtNNytl?=
 =?utf-8?B?VHVsR3RSdW1COVJUMUZYZDJLU1pPTzliZUdSb2NHMnNYSzQ4R1lSKzRlL1pH?=
 =?utf-8?B?akF2Qyt6Zm9jV21XRytuaHZxRTZiK1ZIUUFGMzlIU3dRR0l1Uzhwc3FYSzA4?=
 =?utf-8?B?OFVWa2pCQTBXYzdLRkpmT1Y3WmpUcHl6bHdBMFgxL3pkRG5uVVhkVmxZSWw3?=
 =?utf-8?B?WHZuVm5OOVlOeDdqZERqTlJRSEdGYTFreFhTMXFaWkhKTUdwa25BbGtqZ21F?=
 =?utf-8?B?NjBVSTlZS2RzTmh1Qi8wazlvVUE0NS8va0JtQVRkR2Q5MWQrVm5BcmQ3VHZD?=
 =?utf-8?B?dlRzK3VjNlU3QkMzc0tsaVpPRGdIQmJiRDVvbEplY3paOWtFbG4xeXdoRHZi?=
 =?utf-8?B?dmVHSGp5NlBtOEJSdjAyQk5vTW9OdktWMnRkamh1TVNMSnM2ZjRITm9PYmF6?=
 =?utf-8?B?bkdYNXNQc3d4Myt4WmtIYXpHVjRGUHBOTmdnSDNoWncvKzlOMFY4RUxlYmhD?=
 =?utf-8?B?SjVFY2h3WWlIZmlxUkd5bW9PMXJUOEQzZ0hac3ljSzdnVWp2OWozcmVWQ2tj?=
 =?utf-8?B?Z3VDbDhNME5aNVNxbE1jdmZ6UWdHZDhiWGYyd1BxaHVZb01XVWdrT2hKR2lr?=
 =?utf-8?B?di9vWmFLQmhjb2hGMWxCZFlOam80VXZqdTZyVDYrY2ZFTStkQ1crcC9Fa2s0?=
 =?utf-8?B?VTlTdUdoVUNRZWpVdXVxQlo5YldPT2ZSMDdBcWp1VmpmVXp5V0d1ejdqREU4?=
 =?utf-8?B?RVdndlRXWmk2L2RWMWFDakNOYko3dVdydVFTeGp3NU9KWlU2Mk41QXBZVk1w?=
 =?utf-8?B?RkVCYjYzL2loUEZFMnlyWVlEcVBGWWlwclVCZG9zTzE4TXVoNmNZSEIwM3FN?=
 =?utf-8?B?Skc5Z3E0WHlSVUx5Qll1L0JLeUt1SjM1QWN1WUM2dVFyeG4xZUFNSXRlT1NN?=
 =?utf-8?B?ODdDQ1hQTWR3NHRMa0Y4aitJZTI3OHZtMEw3bjI4VDR3SjRsSGphUEU5RGhR?=
 =?utf-8?B?Unh0RDJoM0pRK0RqMS9oQzB1dWpDYWgxMWQ2cFJqTitDaWNyY25jQjdvc2s2?=
 =?utf-8?B?WVlpMitKM3pMaTdnUzJvZXhiSzdmUCt4UzZxWnptNGpMeVlXZlVXcVNGU1VN?=
 =?utf-8?B?cGpjU3lPSGNFOUhSaFZUTTkycWVjR3RUVW42ck9seFRsOTZZZkYxRERVN0dr?=
 =?utf-8?B?dXhmRWpVQTN6UENPMEswZXJCTFRiVGdTSWx1NTBwQVlZbXVPbThCMEFXTmRE?=
 =?utf-8?B?Q1lvNWFhSmZ1M21aN1NsaUpqWCsyb3NRRjl4QmFUQWx1LzdoS0x5Sjc5YkNM?=
 =?utf-8?B?N3lvWXNVdzA2WE02bmtma0NsM2tnMXdwVWxDZlNsU2ZMRjI0OW95ZDdmU2ZQ?=
 =?utf-8?B?Wjh6K2tPYVF5RGhFQWNySGlqSXgrYjlTQnBDeXFGYTIrSUw1MXlOc0lWT2F0?=
 =?utf-8?B?cVFsRUNTZUpFTXk4TS9KVzh5V3o5N0s0V0N3YUJCbkd4TW9vV3JrWHg2WFJn?=
 =?utf-8?B?NmVRMGYwYUpUdy9TcFlUYTdQTHp6MGp4TEtMZlZTblRSY0Q2M3VpeVdqRnJv?=
 =?utf-8?B?ZmhMa0h4SmU1WnNnN2ZaNE90dmNEL1R0RU50NkIvMEZPZGhZQUxiNWpTNitm?=
 =?utf-8?B?NHFYYkhyVEVwVnJDUVROWDVJaUxSNy8wa0ZwYm16Z0JrYkRnYkRZcU40VC9m?=
 =?utf-8?B?UUxuY1k0bXowNjdEbzFSS1ZjK2hxaUViY0xMNTBNaEVaZFI2NDEzMVl0TXpH?=
 =?utf-8?B?UVZIV3A1MFNoSjZQY1d1SXFVQVU4ajlLVzNVTmpLdUJ0a0pyK0J0YWprQmpk?=
 =?utf-8?B?ZjdpTVVCbkVHemQ5VktPUmpheGN0UkI0VDU3aXZ5TEZkcUtkZWdTZnNEVnow?=
 =?utf-8?B?WGlDVEoydFBsSUhtSitFaTJoZy9ocFBuN2x4SStqYy9VYVlpYmFSSmc2T3Er?=
 =?utf-8?B?Z0UzUGJ5eGU4Z2JWOG9QZkY3dXBzUU5YVWo5cEkzamxSZnYxcldVYUpwNXVn?=
 =?utf-8?B?UERpenh3Um5BbFNzaUlJcmQ2Y3VZdDBZVktpR3pjVVNCa1NVYVFydz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <804EED9B61C1574FA5402CA38B25C446@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5479b79c-48ea-4b4f-a5ca-08de7a852f36
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2026 07:02:37.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Z64fztn7X5nJtZbwIHmkKpiHBZOwVw4dscbu59z61Q1cgpGH9M/VYw1ZOKzB5S/jH4STppMgy72F29U5jVAlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5179
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 4645520C191
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72794-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gUC1T
RUFNTERSIHJlcXVpcmVzIGV2ZXJ5IENQVSB0byBjYWxsIFNFQU1MRFIuSU5TVEFMTCBkdXJpbmcg
dXBkYXRlcy4gU28sDQo+IGV2ZXJ5IENQVSBzaG91bGQgYmUgb25saW5lIGR1cmluZyB1cGRhdGVz
Lg0KPiANCj4gQ2hlY2sgaWYgYWxsIENQVXMgYXJlIG9ubGluZSBhbmQgYWJvcnQgdGhlIHVwZGF0
ZSBpZiBhbnkgQ1BVIGlzIG9mZmxpbmUgYXQNCj4gdGhlIHZlcnkgYmVnaW5uaW5nLiBXaXRob3V0
IHRoaXMgY2hlY2ssIFAtU0VBTUxEUiB3aWxsIHJlcG9ydCBmYWlsdXJlIGF0IGENCj4gbGF0ZXIg
cGhhc2Ugd2hlcmUgdGhlIG9sZCBURFggbW9kdWxlIGlzIGdvbmUgYW5kIFREcyBoYXZlIHRvIGJl
IGtpbGxlZC4NCj4gDQo+IEhvbGQgY3B1c19yZWFkX2xvY2sgdG8gYXZvaWQgcmFjZXMgYmV0d2Vl
biBDUFUgaG90cGx1ZyBhbmQgVERYIE1vZHVsZQ0KPiB1cGRhdGVzLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQ2hhbyBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFh1IFlp
bHVuIDx5aWx1bi54dUBsaW51eC5pbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBUb255IExpbmRn
cmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBI
dWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

