Return-Path: <kvm+bounces-12021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AC387F1A4
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 727221F2274F
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 21:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C608758127;
	Mon, 18 Mar 2024 21:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjvOQRwJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A54535C1;
	Mon, 18 Mar 2024 21:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795673; cv=fail; b=eIqZe2PzIE7FDhYKzCzk28pI5prdrJHpeDXToyc4CoNwAgS3v30X9HIbhEmfI8xtI8xS9bfkCUobjqL2oYy7Mz4YndNZHTWlfG4L8YuslPqKK97YtWZCR3Wq45rRee1tnieXCCiox70EUBMA3bx14y1fg0byzui73K0ykE73PBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795673; c=relaxed/simple;
	bh=dntwNc0LefTCYJVAFp+dxKZzkzYOaPuDhxghs/SW9c8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oJhFaUioWKzGnRPbHZ8HFjStr+gg0qVSJS8M//sZjG4oAkMkmPBEruqdbC0vDehyyuAyUbofsmTXmxqa3M6O077T6qJfNJbz3UdFmu4IxP5e66C1CV7UaJJvcSmThqqtlF+ejQ0t18MT8CNc6ZaiWDcvphAF8N8RwDYTpLoQmAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjvOQRwJ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710795671; x=1742331671;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dntwNc0LefTCYJVAFp+dxKZzkzYOaPuDhxghs/SW9c8=;
  b=fjvOQRwJwnWRQkarmEIfWz8M11E3IDS3l61eAS3G35YI6+owCptlXTyw
   kxyFPEyDoVnDI7m+xeDIxynRYBGL0taZfMAhliKrSlzJEj4clCqEFEqxk
   0FfQh8Su+2wGqhCkNTgHOpr61hOS8+/BSB8M+yFTYh/SklK+PicR9ziNZ
   XTDWbDX4MoDVz6Ye2nRqw9CgGy0HN/i02OdHSh9iNyfmWzoEtb3GRLtk8
   iN4EXygVEVWmTweIvBdvYgMNZgoa+qh5aD/SAgBWUkVnkAaZz9Ff/Zvdq
   HFvpqHmSUzHa/BOTIhEaLlCNGKiP/RKDwieUGi3qWkFCrsl/LrOGMwrUT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="5495235"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="5495235"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 14:01:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="13475370"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Mar 2024 14:01:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Mar 2024 14:01:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Mar 2024 14:01:09 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Mar 2024 14:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2vk/BcZYED4w/WrpFmokAjSSLBxWpiG/RDNmPDJBs3kUErC6AhJkNMwrQ/eYrWyzTxCHyHdKpB7v33CzLn6f6tfC0XC7dCgNCONcIkFrFEdFbPKpsoYdYLCbfiX7wKbpvCqa0lkMEef/Rh9lxn/G5l4dgJQIl4gVUu6ew4c3ZQ2hKMoGgHDXl6B0hRxF+g1KiJFh11Wnyaxm4NCJbPhBdM0n0ju5C0mknsswGhAqnOIORqGhfssq5q/+dTvRR25L7h88HVXb3tLbJEPJvDMAtRnE3vt/G0xDir4XaA9th6lf8DBwyYQ+iyxB210u1X5f2Ta4NkGilHSWddU+eCS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dntwNc0LefTCYJVAFp+dxKZzkzYOaPuDhxghs/SW9c8=;
 b=MPqW9tDH0XRlwYLbQ9ZytdmU9m1ajoK4idkPWyI5czyW2M6ZksVXMecZSFUoiGWAUysKpS3iWRMN6kLtPxdY3Zz9DKjDzgBzrVodZJbkK+gv47E1ptHqVZBqHYpaokmBoqxP4Azb0yATScE2+LeK3SLM7du9yVZEqfJNGvp+Dc3AazRAZnCHySHcfTAj76svjPN/cgA2pnDDgRv41gzTuSn6lGkaYEghPSj3edJ4akqer9udiihWv/HDalwQqE58nFswjRhfGT+KlW7Ea3z4IJL4OJn2s7tIgwOKXYp3ba3EkZ2JuMHFU+SrgvPAX0z4oQj6D74fJ0n7xNoKfnrLCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6828.namprd11.prod.outlook.com (2603:10b6:806:2a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.15; Mon, 18 Mar
 2024 21:01:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.008; Mon, 18 Mar 2024
 21:01:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Topic: [PATCH v19 078/130] KVM: TDX: Implement TDX vcpu enter/exit path
Thread-Index: AQHadnqxiwVmbk+2K02Y5yHT32WjBrE+AdEA
Date: Mon, 18 Mar 2024 21:01:05 +0000
Message-ID: <7a24c01a03f68a87b0bbfa82a5d6ccbf3cbd6f4b.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <dbaa6b1a6c4ebb1400be5f7099b4b9e3b54431bb.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6828:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LOozbLS6TdQIBqXdPDFwaDD48TzF2gLdwkAoCB5vs4wzgF5vetxOU7ph5Cwuuo4sXJjbQgsHcg7odNkoWFaCZGyl2HhUYU41dMM2O8tW8fOXhtHJozNKzpHT6R11OTJQPZe5GBj9rMqsOGWN9Ig2y3ZlLb04+SHjD2kTYWnaZjlc6obWLIB88wBeoDsHML5StpqlI7DAZUAtdIbJ9QlkZB9jtw9o/zi8zqFznru0JH+ABq3ZjZ4FWOEN8omfX88wwbs1EX1l1bIm7zOenbIoZkmkh24HDEPv+HhteF7o9HetejeBDmeipArYJezn0x8VFc7ubY78Dkg3hmZGRjBIVUl0kig+pNHf8nQsAAlXQ8E+DYlyYrBoEqgukCp//KUkaOwmWI7o7NbA7OP1qGmLb72NnxNaBYmY6bDFr6Pc5dIH2Y/TvOX9muhHmEtHysgWZuWksA+mba6IJtHskcFUHpdPQUku/U4zkWNUx99i933NoqQbMpzIpb6wrhYwTGB4wAp+Qtu7NAW/MfMhPTjmwIHX/t6vRHwvST29CW0MpaZw6qDdq4uzZSRLDsTcUnMbSJWn+lE/mmxDgu+o+Wzf4KWsov0NBL8+SjbYg006dogJmRX+uz5KG4TJKoS1EM7q4HbujOyUkkGdOxbhZwaOuiiZsLlJhAVpmVJGmTjzeDw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajlkeGptVlAxUzlId0tEdFcwdlFSVEdoQ1VFK0ovZ2E3V0hIZkJ0endGdm5E?=
 =?utf-8?B?ZXg0U3FPK1l6UnNha1hhQVVGNEtseXY1TGg4QXZtNkNjU0xIT1cvV3FkWWVr?=
 =?utf-8?B?UWQ3NU9yTEtNYlVreTVFR25sTmZlbjVWSnIwa1NtUXdCQ01rcXE2anl4YTkx?=
 =?utf-8?B?S09NVG1GYUtsZHRyRzJ1MDQxU1UzV3Mvc3g0aE9jdTdESHExbEl5Z3BVTDk0?=
 =?utf-8?B?MjE1RjFkWlRJenhlZmJlK0JDdmdVUjVJZ3R6TlpaRUZGK0pQN24zRjhNdm9S?=
 =?utf-8?B?eGtFWDRFNlJnWEpmOHV6QkV0Y0lQMkJId2ZITEIrMGdEUDVVQ0p5NXcvSGJY?=
 =?utf-8?B?M2xSekNjaGxtUGliQ0ZFSmhhejNIZytQbVBFVlpIdHpDa1E1cENaREpub0ZH?=
 =?utf-8?B?WHd5UU9qS2E0dUFJK1JFNktCWHdoSW13UjkrM3dHSDFmUHJRTmZHUjVwTnVB?=
 =?utf-8?B?NXAxdWJ4SUY0M3IzQ1pRdFlOMXA5dFRsYkJzN3NyS0tQK1NOQ2dCbk5Sam5q?=
 =?utf-8?B?dWI0MUsrd3dDVlBQVVdrMlNLb3pnWW9ya2ViTEhQbXlmVVFJZkZOSytwYnR4?=
 =?utf-8?B?ZmY5NWJlY21Lb1RQcFUvQlJIVHVsYUlJTDdTNXJQalhxV3pRNGR3WDUwaEV4?=
 =?utf-8?B?anczcEJYTUtDOHplUTZjOURLSEUyeEVQL1g4dlFIVWpMWkp6Tk8wMVFVZGN6?=
 =?utf-8?B?RldSeUhMZG4rNUpaMjh0L0Q3TUNUam9HRFl3UklXNnNJUnhJNzZHRm56eEw0?=
 =?utf-8?B?VjN2cHd0ZTBOK2QvbWJpdWhrakRlYm5UTk9tUnc0a0RKUjJOUzA4QVI2WnlH?=
 =?utf-8?B?dUlldjRsSzZKYzJZcFJYeG92NW9PemNza3RiNW5XS2t5SXh3Y3pZZ0xiRWFP?=
 =?utf-8?B?QTRvM0FpYy9pZlBLWkJsMzJnVkxpRk5ERWVsUGZRTkJidWd3amsxZThzQ050?=
 =?utf-8?B?ZG0ydm8zYUVTaVZtT2psU0NzNG13TWk1cS9FQmlTSHU0QU5NMk9iUTRKcUtm?=
 =?utf-8?B?dnc3azlaYTlZMlV3cUx5VlhibzNoRHN3TkprQ0FRc3MyMDV6bkhQb3pSL2xN?=
 =?utf-8?B?aXJSeXJQMWZTclFFMzVrTmlGa1RlZ3dZM2Z3ME0xcUhZbHByVExKVG1hTUlV?=
 =?utf-8?B?bWp4QVFUZ3o5NjVON3Y2NUhBanBGaGRrbjBSTDUrRVplR25xSDZzMXZieDU5?=
 =?utf-8?B?OW5Eay9tb1F3Q3loZ2R3d0pxZGNIVkVMS2RUL3BaWGNaem5EZlE5bzkvbU50?=
 =?utf-8?B?dXpaZVU0cDVuVFhkWnhVeDk4NnM1R2FQTkJuTFFYNTEwdFh0UmtyOURIMnpH?=
 =?utf-8?B?WjlhZ3R3M2hOY0JldEV1aTlRdjJlRUxucGMwenhkVjMrZThBSzVLdTBCdldr?=
 =?utf-8?B?TEpBVGI1RWZkRllteUdTbEVldXdhYzMyeGp5NUFGVGU1MVpQT3FodG9JZkJ1?=
 =?utf-8?B?NGJ0L2xqa1I0THV4NHJVZkIyR2daSCtEVjRuZEtwY2IxQ01qNnl3OEVuYkFI?=
 =?utf-8?B?c2tqdS9KSmxjcFBUV3VlRlFlaHB6SnNCZHA5Q01KQUpvUDNscVpiL2JLWmhQ?=
 =?utf-8?B?Tmtoc3M2aTRaTjRaTjVjVy92cUZ3KzRWTkl1ekdVZ0k4YVB5N1BJdUpBVHd5?=
 =?utf-8?B?S205alRvZy93d3RPdHBzY2RtdEhDaEk1WjY4RU90SGRtTjNLUUZkaCtGdDJs?=
 =?utf-8?B?M2hLWCtHVFNZamxrbjc5azB0NFc2N056U0V0ZjBWYUhUVG9mT01mMzZpd2ZK?=
 =?utf-8?B?R1REd2hHK2pvb21xMlVpZzltc1c1MnFjNU5XZktOYTlRb25qTDliYU91MU1O?=
 =?utf-8?B?WDVUTVFsa1VxVjFDa0czclBKMlBuV1VWOVpZaFdtNjBMUmNEMjhiTXlVSnA3?=
 =?utf-8?B?dCtCS3ZUYVFudG80SjFGVHcyL29KUmVUckdxVkI0eFB4RXBxQTNBaUc1bi9u?=
 =?utf-8?B?cUhSTko4N1FNbzVPa3BmNHAzYmNqUlhxcW9kUjhWK0J2OTFxSWVWK21mV25Q?=
 =?utf-8?B?Znp5Q1plZThPRE1nYkx1aU55OHdQbkwybmFwQTVjTEFqMUU5UjR4emY3Q2JN?=
 =?utf-8?B?VCtaZTJZazZqRm9LUHovQ2tlV29QMmJBK25jMFV3Y0FqaDJ4ejFoZHhKeVYz?=
 =?utf-8?B?RVFYRHpTV1hBOHc4OXFMYURlaW5vYk1aZllYOERoZHVHY2ZvT3NWYkpJeWtz?=
 =?utf-8?Q?D/EfBVOdb6SkVz8N34kcoiQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03A1BF91E1D2BE40B7BC2EA16480E31D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e286e102-7ce4-4cd2-a848-08dc478e8720
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2024 21:01:05.7413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWhxpapBaxBvIOaliiUP2GQrwfJbtlxz2SJPwTncdq/MFlvULOXj3PACD0EBF3Yz8bnylTqU3QncalOyXBQa8lidDZHHXiNM3d8TqZt9Q+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6828
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI2IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICtmYXN0cGF0aF90IHRkeF92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4
KHZjcHUpOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseSghdGR4LT5pbml0aWFs
aXplZCkpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsN
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHVubGlrZWx5KHZjcHUtPmt2bS0+dm1fYnVnZ2VkKSkgew0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdGR4LT5leGl0X3JlYXNvbi5mdWxsID0g
VERYX05PTl9SRUNPVkVSQUJMRV9WQ1BVOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcmV0dXJuIEVYSVRfRkFTVFBBVEhfTk9ORTsNCj4gK8KgwqDCoMKgwqDCoMKgfQ0KPiArDQoN
CklzYWt1LCBjYW4geW91IGVsYWJvcmF0ZSBvbiB3aHkgdGhpcyBuZWVkcyBzcGVjaWFsIGhhbmRs
aW5nPyBUaGVyZSBpcyBhDQpjaGVjayBpbiB2Y3B1X2VudGVyX2d1ZXN0KCkgbGlrZToNCglpZiAo
a3ZtX2NoZWNrX3JlcXVlc3QoS1ZNX1JFUV9WTV9ERUFELCB2Y3B1KSkgew0KCQlyID0gLUVJTzsN
CgkJZ290byBvdXQ7DQoJfQ0KDQpJbnN0ZWFkIGl0IHJldHVybnMgYSBTRUFNIGVycm9yIGNvZGUg
Zm9yIHNvbWV0aGluZyBhY3R1YXRlZCBieSBLVk0uIEJ1dA0KY2FuIGl0IGV2ZW4gYmUgcmVhY2hl
ZCBiZWNhdXNlIG9mIHRoZSBvdGhlciBjaGVjaz8gTm90IHN1cmUgaWYgdGhlcmUgaXMNCmEgcHJv
YmxlbSwganVzdCBzdGlja3Mgb3V0IHRvIG1lIGFuZCB3b25kZXJpbmcgd2hhdHMgZ29pbmcgb24u
DQo=

