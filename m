Return-Path: <kvm+bounces-59365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9722DBB18E6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 21:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D4CB7B18E7
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 19:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990992EC562;
	Wed,  1 Oct 2025 19:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OHP9XiY4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECFD2D63E5;
	Wed,  1 Oct 2025 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759345259; cv=fail; b=hMo707+M4f2zAIYOl/WcZAMiXbCR1xr5EL7yOpQ6Y51Njrt8an8Ziyfxi5YViIF6bbDl9Hxb9ey0lvTfJl8Mf40+HUxhTEH117NLMCz+ERYEQbKMBUUWPn+IxT+vvfk3rkQJXo+uqqO4m++VtP/XmXIxSNPPG69bE5pzVQkQBs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759345259; c=relaxed/simple;
	bh=1vwsJW2KLyaGCq9gdIoimFkFmZEFRH3MBKwGpthKiHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B6/TdMpkTSNONal4JschFpzOolNc9/uKD+SjHttqGxI/wGT1eR68saYVeAg1ILRrigRVTIWyOeyyOeM51pTVZQA6DmGWhkMHmy9pGifAMlaOCFdNBUN0ct0Oy6vzXNC9p//CKBjF6Yji+ZCBhvXHmzS9iM47cTlHO+5mXASRpt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OHP9XiY4; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759345258; x=1790881258;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1vwsJW2KLyaGCq9gdIoimFkFmZEFRH3MBKwGpthKiHQ=;
  b=OHP9XiY4R7Srbg6d1zq4K810wmAK1WKdVaw8YpY6Qg+3bIu2CXTAfth5
   DupEUgGEmxdBiE99mehnulNW8puR6ykaQrwn00M71alnSmXJI+/qv2kDf
   mBjSR8wS6XTcpO1oVu6LsYgGH2fzMCZaFFWbZiURs+v1ZSuvNLlNL6PvD
   ncc113ddkORIWoPd4INwY4qzNoTxpJZyCR1sW682yuq/LzDmYFGjeYcvl
   CyJTiRqF9n6lStwJYWh1NpfHXINWBzX9gQTVRERaEPbtDDcTYG1lK9lXB
   54fX8mOoOeVm3Qke9MhWY39zn+Nw3clWcDFbB8gQVlgyZLxGu0i2anJ4p
   Q==;
X-CSE-ConnectionGUID: Sqvd6lV2S0aKuXzFode1Hg==
X-CSE-MsgGUID: ogTL0jOWSlOZuuhB019Ijw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65453443"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65453443"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:00:58 -0700
X-CSE-ConnectionGUID: CoIhalLMTQmy+5a9ymJ97A==
X-CSE-MsgGUID: FfpiX0tTRgiD7NWUZZVKIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="178484769"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:00:57 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 12:00:56 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 1 Oct 2025 12:00:56 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.17) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 1 Oct 2025 12:00:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sn5C632lzLiP03qPqC6Bo8t79BfZpmKywpYzXtEDmCeWByLZLfcchh4s+BL/h1DMxwlZs2sz3+boBlNgKOrUgRUEIVYG3QJyzGJ/x6aExP0l7PVTFT5coiwmKxE9soiN+/MlHfSKacqierAws/p7QW0akimIVu5oOwpGUxJWgdnyk5GsoR8z+0sgQxrtL3HIeGPrM/SYZfYqw8ij0ZYfcVNez36OZ5/h9hTSgb/elugNttE9dq3YOMyctwJTYhyHY55LEP7lSj/xOqFkgs/ig/DHv2Iol992GKimHUu2jx60lnyRs6aVc/D3wE0MVkaP1Eqj2Q6tQxTbE9Y5m7yoGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vwsJW2KLyaGCq9gdIoimFkFmZEFRH3MBKwGpthKiHQ=;
 b=alHGYwTmj4qnnsvST+dztCH26aS3RMOdFgTga4C5uvn46qLE2cXaEu0NH2Tg5N/VOKonBmrclqxonFJc197TE4xORDf/8XthExVuT0LDSGETUAdg+NJ5glQeLsgkpJLPPu89BsBmjDfvI1I8VROD5HgVcX4DINSLMwUjM0B3JPwp90d/eHqGlxZnam9PxZAYUQY0VWAyIibf+9Q82IPgc8GbpJQ/QzgDAyO2shNd02WjwanptxQeuCr0n0IK8atlFrezTJP2aAKd81MMq1DeeieFFalnjQESAPYx506oREqTKS7fmZBRdTOESVd1V7qvdtmw3IGw0n0V7dLcOku4OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7057.namprd11.prod.outlook.com (2603:10b6:930:53::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 19:00:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 19:00:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0eZqFwOSc+ES1GzTBQe5/Z7SaG0KAgAZudgCAAWNPAIAAI4MAgApzb4CAAKnbgIAAi6yA
Date: Wed, 1 Oct 2025 19:00:51 +0000
Message-ID: <404c3dddef3025537d2942386ab0ea0f72ab9dc3.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
	 <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
	 <e455cb2c-a51c-494e-acc1-12743c4f4d3f@linux.intel.com>
	 <7ad102d6105b6244c32e0daebcdb2ac46a5dcc68.camel@intel.com>
	 <19889f85-cfd0-4283-bd32-935ef92b3b93@linux.intel.com>
	 <ca13c7f77f2d36fa12e25cf2b9fb61861c9ed38c.camel@intel.com>
	 <894408f8987034fcbe945f7c46b68a840d333527.camel@intel.com>
In-Reply-To: <894408f8987034fcbe945f7c46b68a840d333527.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7057:EE_
x-ms-office365-filtering-correlation-id: a3339da8-a480-4425-716d-08de011cd70e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eStyS0NBZ1dCNXRHbGZhRTFneG11Skd5REdiRW5LT1ZtbWVaS2wwemxXM293?=
 =?utf-8?B?NTdvb3RJNnZLUWJBNHZURzlqT25ZV0NZamE4R1Z6ZmNkT2ZHakFMZWt6Wncz?=
 =?utf-8?B?aVJkcmtuUTQ3ajZXTEJ6MndHQ3RmMFl4T01BWW9BUElGSVdwUFFQbWVGNXZl?=
 =?utf-8?B?VHhycDRvR3JaY2RCaU1IU2U5bW5zZHh0djg5YkhNRDdBSFM2ckxnd0UxVVdq?=
 =?utf-8?B?RXlhRHZnVGV4a25WQ09JdWZYc3VPNjg3NE5LTzF5MmJ5YkJzdjlQRk1GekE2?=
 =?utf-8?B?NjhKRW1HSSttUGp2RU8rZWI2dlliZHdUUFY1MDVQb1h6Z3A3TWpvcUV5RmpH?=
 =?utf-8?B?d09hOEJjZ0d0amE1NTM4VlhxNFRuT0hlK0FldkwxaW9McVhSTHJhbEtLWmFu?=
 =?utf-8?B?dDR5V05PcWJXZTBKNDlsWUtCaFFOVmVnQWlYa0hKVlp3aWxaTXVZQy9BV2ZZ?=
 =?utf-8?B?MG9XSjY3U2dnajlOdTlDY21MTzVwL3Q4K0JlWExkV1pVc2dYUmg3ck1iOHJH?=
 =?utf-8?B?dDBDY2g0Q3RubnlvOXQveHV6ZElobXZydDRkU3gzMmhtNktvS0dIZXJadTJs?=
 =?utf-8?B?S1dsRFc2Um81U2VOaGcvSkFrcW9TUlJlSGNieitydGlyR3JpUlZobjZOc2dY?=
 =?utf-8?B?RjZSZG85YmJUcHRpdFpCa2dRL3hkZFA2VE9lcjFqNXpEMXM0NGNqc2Y4SUxx?=
 =?utf-8?B?K0tva05HTXNKYUVkZ2J6U3F4Z1RCTE1ndGFRdm5zL2FNR1E5dmxYUUtYbmp3?=
 =?utf-8?B?VWoyeVNnclFDSWMwQWswcFRLOSs0c2ZxV1prTUVFNk95SlAzRy9PS3dmRldZ?=
 =?utf-8?B?NzkwbEFZYW9UZTdKQjJVTmgrb3lHaDZZczlDTEJTR0UwVkh1Rk1vMXNFZFRQ?=
 =?utf-8?B?bklLaHVUMEJQV3FZcTYreVRNSlpLaGU2VGpzNXdicWhVa09iWjhzRis2K0h1?=
 =?utf-8?B?WHU3cDJUN0lKQkJNM3dSU1JBQzBjcUZBYkdTRUpMN2p1S3cwTGhHT25yTlhY?=
 =?utf-8?B?VTE4WFlqVlVlckovWXNOMHFWUFpGTjMwUVI3ODlqWExPanpMNmZjVzd1R0N2?=
 =?utf-8?B?YTVhQ213Z2V1L2M3YlZad3FncU1uV2MrVXlCb00vTmR5d3Y0L0xIVmUraXJj?=
 =?utf-8?B?dktEOFpGRlpHQStadGF1ZS96bzRSS21PSURsKzY1TjhZcllzQTBOOHhqODhC?=
 =?utf-8?B?WExKSUxjQS9tajVITWFSbEIxeFIvK1VQbVJZOWhTdzVJeHFoUnY5OGI4THAz?=
 =?utf-8?B?RlBnM1NFMkN3VU5seGlkNE16RFJOMS8rQlAwWXVRYnB6NHdKSmlqZnhTZ29C?=
 =?utf-8?B?K0F4OG9hTnE3YmVzVi82RnpWVlZyRGNydWFzZUtUNzNsc3ArQldnTmxOdG1Q?=
 =?utf-8?B?ZHNkV0xaUnEzTEFGd2xYT0NwSW9VbWdaMGJXc1djM3ljcXhYbG91Z2cxdlVV?=
 =?utf-8?B?dUhYZW5mWVMwRjJKNVM5bExHRlc0RWY2Rm4xbWN1Z01sc3dyYjF0MkNpRVM2?=
 =?utf-8?B?WGtVd3BCcEMxLy9yM05CTUdmMy9TS2w1L0NlWSsrdkwzaTdiTkhHczRpUnRh?=
 =?utf-8?B?YW1wOGZQL2oxZFREUlBtZWNidXk5cGpxMi9STDQrenl3SmpUVU8rNG1mRmRs?=
 =?utf-8?B?cXN1KytWRWJ4Ly9IbXl6eG1mVEs2Mks5QlpaTktZb09oN0M1MWxYOTZVa3Bn?=
 =?utf-8?B?OEJsaFhiM1Y3MWtGU0hTYzBsaG4yNk1HMlZ3NXhLTXZnM3cySXlabm8xTGdH?=
 =?utf-8?B?NG01Q1Z6ckMwY0NvWkpMa3pZNVQweEVEN0dvZkg5MWJTVEIrL3pSUk1YS1ZS?=
 =?utf-8?B?a3VaQUFxUFBvZVdJd2REakIrOEt0OXFQZEtXZEtOMmlBYnBmZ1BTNVk2UHhW?=
 =?utf-8?B?cVZjYWRjTFE1dGJubU1Nd1BtTUZKMUZsc2hDV2h1ei9aUTVYSGFhcU4zQUtG?=
 =?utf-8?B?Uk9uSkpMR3dyYXRvaWdwQ0hyU0YvUFJUK0ZRTVJCY1h2bi9pc1E0VzVYdXVQ?=
 =?utf-8?B?WjZ2WXZRem9IQUJvNWxSRUZWNFhFK2dxVi9jdElrYTNteExIVFRkaFFQbzNQ?=
 =?utf-8?Q?8uSmw0?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWlrR3NQODErYS9FWEkwZ3JCaGhhczU3dm1jalNZMmFmL1IrQ3J1SFBQNkNR?=
 =?utf-8?B?UG5qSXhyZXpZVytxSkc4UHVJbUE5RU1BaERoMm9oSG9rTXhoRjZ1TEFxUWhY?=
 =?utf-8?B?RHRyVlZaUjl1aWtBRm90Z0UrdU1FdkpCWFh1b094QVBZUlp1bExJU0ZNV3U3?=
 =?utf-8?B?aENOQ28rK2RJcHNHR2l6L3hyaVkyZ0dIMm9OZ1JBTVZIU2VzRzVtS2NEOUpn?=
 =?utf-8?B?ZnNyZGRybGhwQjhZYTRpT21ERXZuaVRnSHA5YUJaakhIQmRLZFp3OE4ra3Vy?=
 =?utf-8?B?T0ZZQ2NJSlB5N0FlL0poMHZOMVcvOVlRWmxIaTZCSHhjWWVTd1U2aGR3aDNR?=
 =?utf-8?B?bnZTNXFHQXAvcFh5eDQ4T0RvdWpYd3U2RGMvSVlnR1doSU02Ry9yeTRYTUtu?=
 =?utf-8?B?NldDK3Nlbzh1RzJrT2VaQW9iaGpzVjR6U0ljcU11bnBZYkc1UnhtaHNtSjZI?=
 =?utf-8?B?Ylp0Q1dJZEdTQ2gyWGRmTTFBYi9POEpVbThlb3RHOUhvd0I1cnZrZ3d0M243?=
 =?utf-8?B?ektjcGlNWFduSk1TQnZ0V2FHZEE3ZUJFcVNFbGxEcEQ5MTZ6MXZGaTJON3ZZ?=
 =?utf-8?B?emNhT2lodnFuR3VpRVF3SUVRYUU3NjdnTHB6dVlVN0hrNTJuZzd0SXg1dGlP?=
 =?utf-8?B?NVpVTXFVTWYrdysvM1FXSEt3VndoQ3JCeHRoK1hOR1U2cU5ITWVORlhGZytQ?=
 =?utf-8?B?OXp2Ylp2Qk1GOS8zNjBsZ2pvMVNkN2QweVl0d2toSW1ISW9jaWtRR283cEtv?=
 =?utf-8?B?bVdPSDVMQlh0a09RTDlINlBxL2hrVFhXRXdKU1hFYzRwTENFYUplSFlqRFdW?=
 =?utf-8?B?ZXlYNm41eGUzdFJPeVNNTk1ZclQ3NDdDRHFTVTJLSkMzZXdQaGNXRXJlN0pP?=
 =?utf-8?B?SmxPRUp5YU9QK3Y4a0IvNjQvTzFQL2UyRVp6UDJ4eEtXQ3ZpODRjS01KMHZI?=
 =?utf-8?B?VVY0WDZJRENHa3pOMHEvaHBCTFBVZ0htaDJRS0xXRU1jbEp0dnJ0dVNmTzhY?=
 =?utf-8?B?SnZ4eUxYV2luQmI4UVNLcXUxMlp4SUZFOXN5UXlCTTU2V210RFhYZVRqMlU2?=
 =?utf-8?B?U3JqMlpkS09wUmw4TnZ0SVZHWDZGZGxmZHpSL0U2VTJzNTdiT1pObXBFV24z?=
 =?utf-8?B?VUJLVXhrM1VqWm1VV05PR20xbklUNmM1TnZ5N1R2eVhaTmZjbHcyMDE5U3hM?=
 =?utf-8?B?TmdYekljRlhlcm5aeVhKdkpuOFJtdGdIbzNzejJkeS9XK1E5RHpKWlk4SDdM?=
 =?utf-8?B?dXBCd0ZHNys3bnAydTR4Y1kzbWNKYU9wSkxac2ZPREtuOHgwN3MrcjczeGRw?=
 =?utf-8?B?NXVTenVIYmJzbWI3L0d2YWloaGFzT2JYcHZVUXJ4Rkp6VUYwL1lnekRDSFZv?=
 =?utf-8?B?NWJqWG8vV1hFeUREbThwRzFJV0oyRzk5dmJhallsK1UwRXNUdWlPdGg3enBY?=
 =?utf-8?B?VkQ4VU85NllTWnlydGJTYXNOQ1hqaW9WK3ZabXFMZFFVcGQ5ZVF0Syt2alFt?=
 =?utf-8?B?WW91V2d4QmR1T2dncitjMGhlbWZCT3pPUUV6eTBKa25pdE9sRnpiMUdMTUsy?=
 =?utf-8?B?cS9WV1FyaXd0QkRpR3RDQ004NG92QStZc3NHS1NSNk56REs3MzhxcVlkbzk2?=
 =?utf-8?B?RWJzd0VVOUswMEo4Y3dBUkZpaVp1SXAzMGl5TUo1WlZqWi82VW5ueVRwZWJ5?=
 =?utf-8?B?ckc3TzdveDk0T0w0c2hvd1ZnSU1zcTJPVE5pSHoxd051TVVNaGhXbHArdUhs?=
 =?utf-8?B?a1cxTy9OSXJ1a09DT1VZei9KOXNwSDhFaFVnTU8rR1BsR0lmVHl0bzhWYVpx?=
 =?utf-8?B?eTNMTjJleWRHV20rTW4wSy8rbzg4QzdJUGRic3c1VENKY2Q1aEFoamZ3Z0dt?=
 =?utf-8?B?VU15ZHBpdlVodklBVEplSlJWdnVwU29CWDBUVjJqR2IzU3F1MlZtRVZxU0l3?=
 =?utf-8?B?d1NLV1g1b1c2dGRFMGpkdDN2QWRoQ0tXME5tVno4bm12alJsTnV4d2tWZDVH?=
 =?utf-8?B?RFUxSjliZmFUQWhSK01FSkg1VHZzQkJYUDZOa3Q5eDArQ0FlMm5lazlZTDdR?=
 =?utf-8?B?N0xlRUFORXNVcVRHN2p4MkZ1SUpMWXl2b09IdGw1OWd6aTg2U0xRU2hsRHVE?=
 =?utf-8?B?dk82NlhCeDJCaGsvaklpNUhuUlpSd2F4OW5ueXR6WXVGOTdPYjBjcGFWQUFT?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D66DEC0B21DE4E4F9D4A376F99A4BD81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3339da8-a480-4425-716d-08de011cd70e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 19:00:51.1681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VMwPlqjVpY9F/+BevsFr0jDxx6QNry505eRULh09/e41x4rAo2PXrHuq9dqDyr0CbEOB5cisPTZnknY+wxj8BcJX8pm4fPdbjqqUip70eP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7057
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTAxIGF0IDEwOjQwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjUtMTAtMDEgYXQgMDA6MzIgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IA0KPiA+IFBhcnQgb2YgdGhlIHByb2JsZW0gaXMgdGhhdCB0ZHhfZmluZF9wYW10X3Jl
ZmNvdW50KCkgZXhwZWN0cyB0aGUgaHBhIHBhc3NlZCBpbg0KPiA+IHRvIGJlIFBNRCBhbGlnbmVk
LiBUaGUgb3RoZXIgY2FsbGVycyBvZiB0ZHhfZmluZF9wYW10X3JlZmNvdW50KCkgYWxzbyBtYWtl
IHN1cmUNCj4gPiB0aGF0IHRoZSBQQSBwYXNzZWQgaW4gaXMgMk1CIGFsaWduZWQgYmVmb3JlIGNh
bGxpbmcsIGFuZCBjb21wdXRlIHRoaXMgc3RhcnRpbmcNCj4gPiB3aXRoIGEgUEZOLiBTbyB0byB0
cnkgdG8gbWFrZSBpdCBlYXNpZXIgdG8gcmVhZCBhbmQgYmUgY29ycmVjdCB3aGF0IGRvIHlvdSB0
aGluaw0KPiA+IGFib3V0IHRoZSBiZWxvdzoNCj4gPiANCj4gPiBzdGF0aWMgYXRvbWljX3QgKnRk
eF9maW5kX3BhbXRfcmVmY291bnQodW5zaWduZWQgbG9uZyBwZm4pIHsNCj4gPiAgICAgdW5zaWdu
ZWQgbG9uZyBocGEgPSBBTElHTl9ET1dOKHBmbiwgUE1EX1NJWkUpOw0KPiANCj4gU2hvdWxkbid0
IGl0IGJlOg0KPiANCj4gCWhwYSA9IEFMSUdOX0RPV04oUEZOX1BIWVMocGZuKSwgUE1EX1NJWkUp
KTsNCj4gPw0KDQpFcnIsIHllcy4NCg0KPiA+IA0KPiA+ICAgICByZXR1cm4gJnBhbXRfcmVmY291
bnRzW2hwYSAvIFBNRF9TSVpFXTsNCj4gPiB9DQo+ID4gDQo+ID4gLyoNCj4gPiAgKiAnc3RhcnRf
cGZuJyBpcyBpbmNsdXNpdmUgYW5kICdlbmRfcGZuJyBpcyBleGNsdXNpdmUuwqANCj4gPiANCj4g
DQo+IEkgdGhpbmsgJ2VuZF9wZm4nIGlzIGV4Y2x1c2l2ZSBpcyBhIGxpdHRsZSBiaXQgY29uZnVz
aW5nPw0KPiANCg0KSXQncyB0cnlpbmcgdG8gc2F5IHRoYXQgZW5kX3BmbiBpcyBhbiBleGNsdXNp
dmUgcmFuZ2UgdmFsdWUsIHNvIHRoZSByYW5nZSBpbg0KcXVlc3Rpb24gZG9lcyBub3QgYWN0dWFs
bHkgaW5jbHVkZSBlbmRfcGZuLiBUaGF0IGlzIGhvdyB0aGUgY2FsbGluZyBjb2RlIGxvb2tlZA0K
dG8gbWUsIGJ1dCBwbGVhc2UgY2hlY2suDQoNCk1heWJlIEkgY2FuIGNsYXJpZnkgdGhhdCBzdGFy
dF9wZm4gYW5kIGVuZF9wZm4gYXJlIGEgcmFuZ2U/IEl0IHNlZW1zIHJlZHVuZGFudC4NCg0KPiAg
IEl0IHNvdW5kcyBsaWtlDQo+IHRoZSBwaHlzaWNhbCByYW5nZSBmcm9tIFBGTl9QSFlTKGVuZF9w
Zm4gLSAxKSB0byBQRk5fUEhZUyhlbmRfcGZuKSBpcyBhbHNvDQo+IGV4Y2x1c2l2ZSwgYnV0IGl0
IGlzIGFjdHVhbGx5IG5vdD8NCj4gDQoNCk5vdCBzdXJlIHdoYXQgeW91IG1lYW4uIEZvciBjbGFy
aXR5LCB3aGVuIGRlc2NyaWJpbmcgYSByYW5nZSBzb21ldGltZXMgdGhlIHN0YXJ0DQpvciBlbmQg
aW5jbHVkZSB0aGF0IHZhbHVlLCBhbmQgc29tZXRpbWVzIHRoZXkgZG9uJ3QuIFNvIGV4Y2x1c2l2
ZSBoZXJlIG1lYW5zDQp0aGF0IHRoZSBlbmRfcGZuIGlzIG5vdCBpbmNsdWRlZCBpbiB0aGUgcmFu
Z2UuIEFzIGluIHdlIGRvbid0IG5lZWQgYSByZWZjb3VudA0KYWxsb2NhdGlvbiBmb3IgZW5kX3Bm
bi4NCg0KPiAgIFRvIG1lIGl0J3MgbW9yZSBsaWtlIG9ubHkgdGhlIHBoeXNpY2FsDQo+IGFkZHJl
c3MgUEZOX1BIWVMoZW5kX3BmbikgaXMgZXhjbHVzaXZlLg0KPiANCj4gPiBDb21wdXRlIHRoZcKg
DQo+ID4gICogcGFnZSByYW5nZSB0byBiZSBpbmNsdXNpdmUgb2YgdGhlIHN0YXJ0IGFuZCBlbmQg
cmVmY291bnQNCj4gPiAgKiBhZGRyZXNzZXMgYW5kIGF0IGxlYXN0IGEgcGFnZSBpbiBzaXplLiBU
aGUgdGVhcmRvd24gbG9naWMgbmVlZHMNCj4gPiAgKiB0byBoYW5kbGUgcG90ZW50aWFsbHkgb3Zl
cmxhcHBpbmcgcmVmY291bnRzIG1hcHBpbmdzIHJlc3VsdGluZw0KPiA+ICAqIGZyb20gdGhpcy4N
Cj4gPiAgKi8NCj4gPiBzdGFydCA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRfcmVmY291
bnQoc3RhcnRfcGZuKTsNCj4gPiBlbmQgICA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRf
cmVmY291bnQoZW5kX3BmbiAtIDEpOw0KPiA+IHN0YXJ0ID0gQUxJR05fRE9XTihzdGFydCwgUEFH
RV9TSVpFKTsNCj4gPiBlbmQgICA9IEFMSUdOX0RPV04oZW5kLCBQQUdFX1NJWkUpICsgUEFHRV9T
SVpFOw0KPiANCj4gVGhpcyBsb29rcyBmaW5lIHRvIG1lLiAgSSBtZWFuIHRoZSByZXN1bHQgc2hv
dWxkIGJlIGNvcnJlY3QsIGJ1dCB0aGUNCj4gJ2VuZF9wZm4gLSAxJyAoZHVlIHRvICdlbmRfcGZu
JyBpcyBleGNsdXNpdmUpIGlzIGEgYml0IGNvbmZ1c2luZyB0byBtZSBhcw0KPiBzYWlkIGFib3Zl
LCBidXQgbWF5YmUgaXQncyBvbmx5IG1lLCBzbyBmZWVsIGZyZWUgdG8gaWdub3JlLg0KDQpTb3Jy
eSwgSSdtIG5vdCBmb2xsb3dpbmcgdGhlIGNvbmZ1c2lvbi4gTWF5YmUgd2UgY2FuIGhhdmUgYSBx
dWljayBjaGF0IHdoZW4geW91DQpjb21lIG9ubGluZS4NCg0KPiANCj4gT3IsIGFzIHNhaWQgYWJv
dmUsIEkgdGhpbmsgdGhlIHByb2JsZW0gb2YgdGhlICJBYm92ZSBmaXgiIGlzIHdoZW4NCj4gY2Fs
Y3VsYXRpbmcgdGhlIEBlbmQgd2UgZGlkbid0IGNvbnNpZGVyIHRoZSBjYXNlIHdoZXJlIGl0IGVx
dWFscyB0byBAc3RhcnQNCj4gYW5kIGlzIGFscmVhZHkgcGFnZSBhbGlnbmVkLiAgRG9lcyBiZWxv
dyB3b3JrIChhc3N1bWluZw0KPiB0ZHhfZmluZF9wYW10X3JlZmNvdW50KCkgc3RpbGwgdGFrZXMg
J2hwYScpPw0KPiANCj4gICAgIHN0YXJ0ID0gKHVuc2lnbmVkIGxvbmcpdGR4X2ZpbmRfcGFtdF9y
ZWZjb3VudChQRk5fUEhZUyhzdGFydF9wZm4pKTsNCj4gICAgIGVuZCAgID0gKHVuc2lnbmVkIGxv
bmcpdGR4X2ZpbmRfcGFtdF9yZWZjb3VudChQRk5fUEhZUyhlbmRfcGZuKSAtIDEpKTsNCj4gICAg
IHN0YXJ0ID0gUEFHRV9BTElHTl9ET1dOKHN0YXJ0KTsNCj4gICAgIGVuZCAgID0gUEFHRV9BTElH
Tl9ET1dOKGVuZCkgKyBQQUdFX1NJWkU7DQoNClRoZSByZWZjb3VudHMgYXJlIGFjdHVhbGx5IHBl
ciBwYWdlL3BmbiBub3QgcGVyIFBBLiBTbyBJIHRoaW5rIGludHJvZHVjaW5nIHRoZQ0KY29uY2Vw
dCBvZiBhIHJlZmNvdW50IGZvciBhIFBBLCBlc3BlY2lhbGx5IGFzIHBhcnQgb2YgdGhlIGludGVy
ZmFjZXMgaXMgYWRkaW5nDQpjb25mdXNpb24uIFRoZSBtYXRoIGhhcHBlbnMgdG8gd29yayBvdXQs
IGJ1dCBpdCdzIGEgbGF5ZXIgb2YgaW5kaXJlY3Rpb24uDQoNClRoZSBvdGhlciBwcm9ibGVtIHRo
aXMgY29sbGlkZXMgd2l0aCBpcyB0aGF0IHRkeF9maW5kX3BhbXRfcmVmY291bnQoKSBjYWxsZXJz
DQphbGwgaGF2ZSB0byBjb252ZXJ0IFBGTiB0byBQQS4gVGhpcyBzaG91bGQgYmUgZml4ZWQuDQoN
Cg0KSSBndWVzcyB3ZSBhcmUgcmVhbGx5IGRvaW5nIHR3byBzZXBhcmF0ZSBjYWxjdWxhdGlvbnMu
IEZpcnN0IGNhbGN1bGF0ZSB0aGUgcmFuZ2UNCm9mIHJlZmNvdW50cyB3ZSBuZWVkLCBhbmQgdGhl
biBjYWxjdWxhdGUgdGhlIHJhbmdlIG9mIHZtYWxsb2Mgc3BhY2Ugd2UgbmVlZC4gSG93DQphYm91
dCB0aGlzLCBpcyBpdCBjbGVhcmVyIHRvIHlvdT8gSXQgaXMgdmVyeSBzcGVjaWZpYyBhYm91dCB3
aGF0L3doeSB3ZSBhY3R1YWxseQ0KYXJlIGRvaW5nLCBidXQgYXQgdGhlIGV4cGVuc2Ugb2YgbWlu
aW1pemluZyBvcGVyYXRpb25zLiBJbiB0aGlzIHNsb3cgcGF0aCwgSQ0KdGhpbmsgY2xhcml0eSBp
cyB0aGUgcHJpb3JpdHkuDQoNCnN0YXRpYyBpbnQgYWxsb2NfcGFtdF9yZWZjb3VudCh1bnNpZ25l
ZCBsb25nIHN0YXJ0X3BmbiwgdW5zaWduZWQgbG9uZyBlbmRfcGZuKQ0Kew0KCXVuc2lnbmVkIGxv
bmcgcmVmY291bnRfZmlyc3QsIHJlZmNvdW50X2xhc3Q7DQoJdW5zaWduZWQgbG9uZyBtYXBwaW5n
X3N0YXJ0LCBtYXBwaW5nX2VuZDsNCg0KCS8qDQoJICogJ3N0YXJ0X3BmbicgaXMgaW5jbHVzaXZl
IGFuZCAnZW5kX3BmbicgaXMgZXhjbHVzaXZlLiBGaW5kIHRoZQ0KCSAqIHJhbmdlIG9mIHJlZmNv
dW50cyB0aGUgcGZuIHJhbmdlIHdpbGwgbmVlZC4NCgkgKi8NCglyZWZjb3VudF9maXJzdCA9ICh1
bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRfcmVmY291bnQoc3RhcnRfcGZuKTsNCglyZWZjb3Vu
dF9sYXN0ICAgPSAodW5zaWduZWQgbG9uZyl0ZHhfZmluZF9wYW10X3JlZmNvdW50KGVuZF9wZm4g
LSAxKTsNCg0KCS8qDQoJICogQ2FsY3VsYXRlIHRoZSBwYWdlIGFsaWduZWQgcmFuZ2UgdGhhdCBp
bmNsdWRlcyB0aGUgcmVmY291bnRzLiBUaGUNCgkgKiB0ZWFyZG93biBsb2dpYyBuZWVkcyB0byBo
YW5kbGUgcG90ZW50aWFsbHkgb3ZlcmxhcHBpbmcgcmVmY291bnQNCgkgKiBtYXBwaW5ncyByZXN1
bHRpbmcgZnJvbSB0aGUgYWxpZ25tZW50cy4NCgkgKi8NCgltYXBwaW5nX3N0YXJ0ID0gcm91bmRf
ZG93bihyZWZjb3VudF9maXJzdCwgUEFHRV9TSVpFKTsNCgltYXBwaW5nX2VuZCAgID0gcm91bmRf
dXAocmVmY291bnRfbGFzdCArIHNpemVvZigqcGFtdF9yZWZjb3VudHMpLA0KUEFHRV9TSVpFKTsN
Cg0KDQoJcmV0dXJuIGFwcGx5X3RvX3BhZ2VfcmFuZ2UoJmluaXRfbW0sIG1hcHBpbmdfc3RhcnQs
IG1hcHBpbmdfZW5kIC0NCm1hcHBpbmdfc3RhcnQsDQoJCQkJICAgcGFtdF9yZWZjb3VudF9wb3B1
bGF0ZSwgTlVMTCk7DQp9DQoNCj4gDQo+IEFueXdheSwgZG9uJ3QgaGF2ZSBzdHJvbmcgb3Bpbmlv
biBoZXJlLCBzbyB1cCB0byB5b3UuDQoNCg==

