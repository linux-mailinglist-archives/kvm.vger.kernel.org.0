Return-Path: <kvm+bounces-64749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A24C8BE76
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 74F684E480A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3CE34250E;
	Wed, 26 Nov 2025 20:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uk4sNt5d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305612DE1E4;
	Wed, 26 Nov 2025 20:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190044; cv=fail; b=AqqfinHEsy4F3y4Ds9761kG5tsFn5/uhgaYE46mZf2//4p5W4KGoaS94HgE9BcGPzZ2JuvT4qdnAW0CZegIvR82ohWlp8m9a+6GZmPPLBqshB+xwdZdbOdWEevOuylA6MZ3qbKbUwYwWMBuEcjmo1AJaUPLTf9HKG0cRcK4iI3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190044; c=relaxed/simple;
	bh=lBZyluv251yQwHlyhPuIXTJ6a4wsTOW5JyvElXB5Kqk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RaIX0R8RW5bhO5JDUXbW2WG3LEHKMsnx78mhynoPWYF8yUILG2RIQhhIXZPduSwQLoTu4njgsyY/nrTh8d0XojiQVNrkW/yIr3i7tCmNkW08ekTLIfZX/9WXMz1RpA78RLmMT3uPdBT44mm8/v/hiEAUiWV/20I5NLiAiT6lQk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uk4sNt5d; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764190044; x=1795726044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lBZyluv251yQwHlyhPuIXTJ6a4wsTOW5JyvElXB5Kqk=;
  b=Uk4sNt5df6z1D1up2CiaBqKVFyZhKFb6hbw3eaaeh7tm8qEspFect4vw
   pqH0MYqj35BhJosUGNGB6TKD5Jtqg0EVgu3bYSBh/biTWJJeeILG/LRcR
   2jIO3tzaVvo5AFD5qH3OG3D+atam5xFuUR/PNDKbuRdRWR69wj0LnliZY
   W9NGkefVdfQTQaUUI9FqqW/QGoheaWkeL0rntzwOWaHQLO6A0s1JVAG8U
   +83VgNj+9uaah/1uMOsFocHOXeDQnfW7+AVoJMkdiuhFOFRLsGN598VQG
   Ymg9QQeNvH37Ueplj6twDjJyx7slejahU70xy7uUjkS6BsrKyuIlXvn4m
   Q==;
X-CSE-ConnectionGUID: d5lxkssHQh+m+xtDR2DDEg==
X-CSE-MsgGUID: YnmwOzsSQkio5dTgNKMalQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66182458"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="66182458"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:47:23 -0800
X-CSE-ConnectionGUID: /en4aRwmQ6+xyLOfIIcMew==
X-CSE-MsgGUID: 9g3NlbnBSuehf/hX2XtJoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="230321819"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:47:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:47:22 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 12:47:22 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.15) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:47:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KR6BciZKMo7L+FFSmr8232aa/63euOci7fj8860MTJAkPl9mp6zA7ia++Df1kG34rqOikCFeEc6Tt778a28vpWWzHS32BmaLh1BFD6nFZFNBZaISgsmFFjmPICN1MS85bKwBF4C/0JvQQRrGRgTRXm4uhaFhkbPfKM5+kekIyNrTLiSlbQM70lHx6TzNl4jKBS6qTr2xxQO3kmtE/gBB0Vrq59DCy69ncZdSl3TiFVgmZVkDxb5g9tUVimVDzR5IDRDs6VwGM2xmcYD0A74RNhXCpgNokKjU5yuMi0D0Qx4NiGFMRGcA6TOxoHVx8pyBBLqLsQiGs3FqS+6FLy3zgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBZyluv251yQwHlyhPuIXTJ6a4wsTOW5JyvElXB5Kqk=;
 b=v1HPTGeNrM2pmVnBov0+FeUAoaWuNEAcDzzXSZfciOJDYx7QpOBlntR6v1XK0naocLrL8Gj8p1H3NKVVPot7CCAI2d0kWVNdRd095J6sW/ngxY+J582TnadKaZnWRCTu9kr3GvW11yRShk8XY9Wr33Dysuq6cSSghn9gyiIHFcHso9SkuEqNf64uWhbFIuiSE1tnVnqbgM6UBjVjYmfy8+fhBMDa+5GsL12MXucmlL/fPhc3ubJKfPAsIgbSbHOQj0fBRGugI2pHFYJajZPocgpAhbXhNSy5rIoHh1c+BMlajOQlWaC2JFIQkWpOZ+Aw1uRbEcegsrVO1pyecij97Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6378.namprd11.prod.outlook.com (2603:10b6:510:1fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 20:47:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 20:47:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Topic: [PATCH v4 06/16] x86/virt/tdx: Improve PAMT refcounts allocation
 for sparse memory
Thread-Index: AQHcWoEIX9Tgaj6+NEu+xgbyqcurk7UCvnYAgAK4PQA=
Date: Wed, 26 Nov 2025 20:47:19 +0000
Message-ID: <21a759efdcfb4429ed952303f7d7143263220b22.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-7-rick.p.edgecombe@intel.com>
	 <468165b7-46aa-4321-a47f-a97befaa993f@linux.intel.com>
In-Reply-To: <468165b7-46aa-4321-a47f-a97befaa993f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6378:EE_
x-ms-office365-filtering-correlation-id: 8b01e54b-2051-4347-522d-08de2d2cfdd9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?b0ZXYlNvOGhMVFB1NjdIcW02ZWxvN2trL3JOczFVVjNMVFRmWFdiYkpRTGxE?=
 =?utf-8?B?YktSSkJocjNENm5WUXUya0ZGTnpTOWhScFJHVEhJeFA0RjgwemZzNEZHcWFh?=
 =?utf-8?B?OG9kemlSMVdzQmoyaVRTWHRmQ0FEU3pzYVJBKzkyN0F1L3hDR0JWbmVuSVhy?=
 =?utf-8?B?ay9UWi81eng0cnJUemdpMDdiYklhZVdVS3IvSExWcFRJU3lmcFNuUUU4VEU4?=
 =?utf-8?B?ZEVGVjdxNGl4QURVOGRHeUpKRHdrdHVMR2RXanRvK0N4cUlmbFR5ck93d0lq?=
 =?utf-8?B?R2lyQlZSZ3NjT0c4MjNnTzM1VUFnTUFqTTJMc29BNUhBQnZ1bG4wUWNxSTRW?=
 =?utf-8?B?Ym5UWWNWTDYxdHVBVFdHNmYyOGpBTzN4MW9kdnVrYksrdHNNcXprSWFMQmdT?=
 =?utf-8?B?VFVjMTFWazIvZlJ2Z3dnS3ViTXl4amVsQ0F6ZE5Rai8rdS8xYlNiVXdGcVpS?=
 =?utf-8?B?Y3VUTW1jU2ZSZ3F4ZUwxeG5KUHl0bSs4bU5MLysxWkVBK1ZLZHNmZ0JMa1Zu?=
 =?utf-8?B?N0dWNjNBQTZqTEVVS1JUOU9LQ3JCcXlRYkdmalA4UUpRMm51Vit4U2FkQW41?=
 =?utf-8?B?REpteUdiZzh5SmNDRG9VWm1GYjFET3dRSUNCcUlLQ0VkUVJlUGllMTFCanhR?=
 =?utf-8?B?cnd1ZlhKQkxQMkF5TkFVQkQ2VldQQUwvR0VweWovTWRTblJGcUNsSU5hd0Rl?=
 =?utf-8?B?K1Jjcy9JQ2IzUkd2c0ZVSS8yMVhia1crbGpldkVNV0M3OTRhTmVVWTlxSllq?=
 =?utf-8?B?S0dheUp3dUFoZ3Zza0EzNVBMT01NcDZrVGNoK0dTMVpCSS9YanNyR3gzWGUv?=
 =?utf-8?B?NjREamVZSkc4UVRMUUtHNkxDMUVqQW5CbmRUN2ZjeFp5VGI2Y3MyNWVsSTcx?=
 =?utf-8?B?TjA5azJEVnpWZW9RWTIrSWFsNUZFZmJSZGI2U1MxOFdPNGhhTzRiL1F4U0hK?=
 =?utf-8?B?ckl6UGZCRHNRekdOR2k4bkpLTFQ5TXVkUWQ3M0ppekl0SGpZY05FejZNZGw0?=
 =?utf-8?B?MFRVZ2tnSmNQMG93aVNaQWI1RjR2aXE4eVVDTDJEbEFKVHJZN3o1WnRxbmpz?=
 =?utf-8?B?OVFBeU5sSXozQnZiL1FoWGFIa2tZR2tkRWk2a1I3N0hnUVFneVk1ZGwyNk1V?=
 =?utf-8?B?Ump4OXlkbmFieHljR0xCc3R1aW1uL0QvR1h3TkoyNDg2Q2ZCNi90b2Fidkdo?=
 =?utf-8?B?MndCdDRTclF4YWl1UCt6MTIyQlpBTXgyVVhWc2J2Z25JYTdoU0lid2d0dWk4?=
 =?utf-8?B?UDhtZW1aRnB5ei9HNEliczhHckdjN1UzQVJ3RDZnQ2FNZUMycy96NUFhQk90?=
 =?utf-8?B?TC9OWW9PeCtPRzRTRGp2dVhVUysrWXIvMDh0OTRNUVQzVlFSSmpsMXpENGVl?=
 =?utf-8?B?T2FINGdmSU1jRzNwbXo1VUxITE5XNVBiRk5JYlpEdEQvV0RlczdSMGhpR1Rk?=
 =?utf-8?B?dUR0YWRMYXlyZm5CVTlqUXE4ejhZc2czK1BIN0RiVmtqV3NGMVFyemk5emRp?=
 =?utf-8?B?R0VOejExbnkzb1dieG83L1NpRm5LbXJYSGpJRkRFMFFJTGphWjc0OVJzbEpH?=
 =?utf-8?B?RVpJOTFzaVRva2VoTDZJVUljS1N6cnhuL0lhRVloQ3Vma1NSVHNoRXJkMTNu?=
 =?utf-8?B?aURIK004cWdXOGFaVmI2dE9pRDIrN2QxZVRJR2Uxd2xGc2dBdVJFVW1WdTZ2?=
 =?utf-8?B?a1cyS3BGRmN5OU1sTkM3K1lZSnVNVGpLaVRYVGZjbkhQM2ZtY1IwQmpMM2kx?=
 =?utf-8?B?dmxqcHgvNDlTNkNNcFc4anhUTTFGT045Sjltd1JVYzlyTGFVOUhGd0xKdGor?=
 =?utf-8?B?M3RwNjd3ZUIwVjRhOVBVUnFWMjNzajNMaXhZRzFCekxjbGFSTSt2N1F0MGta?=
 =?utf-8?B?VCtkUXFSOGRZS3FNUGwvUXo0RGpMTGpvVFoxc1hTV2xFejJNS1RTbzRtMmIx?=
 =?utf-8?B?cmJpUVNhMHlGMWZZcSs3czZ6d1RyR0xRaHFMNVFDeEZ4VlhsMk0wWU9sOU8z?=
 =?utf-8?B?TjFhOE44Tmd1aVdzU2xBVEFjMXdVZlhBaXoxeGZEZ2tteVpLWVNZUVAzekZo?=
 =?utf-8?Q?wkwK+9?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWg3cHI5R2FYbVJ4MVJrMHo1dTJ5MDQxN1oxRmlrS0JSaHpONnVmVGpVSWlh?=
 =?utf-8?B?NlhuT2VXQ3pINUdSQk9sRDAvWEttdjBsaHpOenRtcE9uaW1QZi9aUkN3eWtP?=
 =?utf-8?B?ZzdMZ09kV2hyN1BGd0NMeUJNT3FmTytZd0tXaVYzVWp2S2w4MG9nMkhaZ3BB?=
 =?utf-8?B?S3lCRDNoQW5MTDFsM0F3ajFkWVpQWGIvdGFkVVptYURSbzJKUmcvQkN1VXl6?=
 =?utf-8?B?YkhYMHppUkEwR0pGRlVONzN2NkwwcXVDblJRQWxGaVJNZUduTy9JS1lqcTFm?=
 =?utf-8?B?em9kT21rbEg1QUkvUjhPUDh5eGN2OTlIRkVYbzhYd05qbks2MEt5OWIrWUoz?=
 =?utf-8?B?VnU5VkI5ZFd5QzlaZHIvMVE1a1d0QjB1NHJpZkNZSWRPNzBuVFVRODF6K05u?=
 =?utf-8?B?ZEVURjhaUmNJczFzYXRaVkdtVjNiR3REVTJ2RW81WmhicFJIVkkzcGpCcHlO?=
 =?utf-8?B?cnpNZmhGTUlyNnhraXhoQ3BCZkVDaWFoUkxKYnduYW9Ya3Flb29ZbENjSFd3?=
 =?utf-8?B?azdqYzVHK1UySDA0MC9qSTJENjR3RC9HVHhZc1FpdS9OMTQzUytGRFo3TE9F?=
 =?utf-8?B?dlRxV3FHRk53WWtPNVRnSlMybzR4Ykdpaml4K2s0UkIzVG0wdjNOS2xSQVIx?=
 =?utf-8?B?VkJlQzZyOHA1SGgzczY5ckhKUGdVNVhFZUtKWkIwSUE5M0J5bFZiOTJmTWdL?=
 =?utf-8?B?ZTQ0VXBZQmZPbnBiSWc4bDBTNk1YQlJFY2NaTEVjYnk2SlhPR2lrWURaVVoy?=
 =?utf-8?B?VWVYcnB5OGxBbGlQZm5ZcVJiK1hTTDU2S3RIbjJLS3RlSVFMcHlLbGJqdFQv?=
 =?utf-8?B?VTJQWmE0bEU2NWJsdVdEVDNoNHpvME5FcHorcGVwc2FYTGQrdHVITmRPRmJm?=
 =?utf-8?B?OHRyUXdHTHVaOGRhNVFma0c3bTY1WDNZSktxUXpFajV5ODVNQmh0Nk5Pd1dv?=
 =?utf-8?B?YTRoK3dubzI2YXg1MEgrR0EwblpROWlieXFiRVF0OWR2M1I1em1zNldWc3ds?=
 =?utf-8?B?YW9xd2ZoZFgraXVhNlNYY1pWV3pIZGtwSDQrcitCNXFlNlNHRUtnZ25EbnYx?=
 =?utf-8?B?cHpodjJSelg1cTVvcUo0djJBenNib3RpaEJZNzhUSW1iWWNSVFdKRXB1L0pD?=
 =?utf-8?B?aUVEaG5INld5Um5HZmthYzRtdlZ5Um1RRElCRTR3V0h4OXdtTFRseWtYakVy?=
 =?utf-8?B?NE1sZ01ad2xrTlBwbHpyODVGSW1Md1YvWnA4cXJTOFNldVhyNmJsa2duTlpZ?=
 =?utf-8?B?STJsQmk5MzNRN3FueDdXL09FZDdwUlRPSFoxQ3lET2RuUGpadXJ1SXU0SUI1?=
 =?utf-8?B?TGhqRnhKbEtTdTdnUXZldlZlU0crd1pqcFRiOS9nUVk1QVphc3orRkhvQ1hK?=
 =?utf-8?B?RXBWbDdhcStYUTA5eTdKR2l0TG1iZGprd1k0M1M0OWZjMDZjYmliT1VoUWlL?=
 =?utf-8?B?clJmMk54Sit4dHBiOEE2RTMyTFQ5aGgwUWRYUFZ4NVIzNkIzU2l3TlVlWG5F?=
 =?utf-8?B?TlFYb2QrY2loS1A0ZTBhL2RYUk90Y3pQdU1PTXdNN1AyQi9yYVFJQ2ozM3R2?=
 =?utf-8?B?ZzFVUXFpRkVtQkFoTEVRdDRlU0tLZmJGczkxT3RaSkdlbVB5SXdNZjUvbjll?=
 =?utf-8?B?VkgwVXJnNDFabG1JNmV5MDJmL0JQZzVuaTl4TkJKODVWVVYySjZtTUdNdW1R?=
 =?utf-8?B?UXJQcjYxaGc2WWVianhLSzU5VWczejFzUll1MXFGbXphM1A5QXdvZ3ZVTWNm?=
 =?utf-8?B?ZktJQktEOFR6OUE3L2lSMDJ5LzY1SUdXM01UTS9ZSUlnbnBzRy9DUGE2QVJ5?=
 =?utf-8?B?bjRGSUdvbTFGRVlLcVBUWS9rN2IwSTc4VnFSSm53VWJXOHdkeEJiN01oZzhu?=
 =?utf-8?B?VWhsOU9RSndrRk5WTmNheEpibzg4NUlOUGh1dG1XMUNnNjBSNWdVSmdZaThI?=
 =?utf-8?B?NGx1N0dGWGVQK2V4amVydytEbzhvYWJrbmI0R3E5QjhzMmlSRHNmNWdHK2VG?=
 =?utf-8?B?d0RwMmYwWmhMeHg0OFVoV3A4Qno4VkJSc1RtYnFqaysvbG9MK2pMam02eCs2?=
 =?utf-8?B?SzhSZGh5d2NkZXUrQTRpMHB2U0twbWdqdXpJUWNDeTZoU3dUTzVnZ25KMjhC?=
 =?utf-8?B?Rk5vUm9Ua1Z1VlNiOXVZSU9HZEF0Y0p1RTdOdU9TR0UzSzVCSU1qQy85bzVk?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F2D45D0DB6867945B45F0CD37E93CD0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b01e54b-2051-4347-522d-08de2d2cfdd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 20:47:19.3851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WuDEutcfDyaoYS/C81dFczV5pJp7VRS256UYacCwZ9wDiA/VKTu2cIUAPIC51bAM1iWm7bauj1q5W/CI5nQ19F177vc1p3j4DE4i/NMh3Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6378
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDExOjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IE9u
IDExLzIxLzIwMjUgODo1MSBBTSwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+IFsuLi5dDQo+ID4g
Kw0KPiA+ICsvKiBVbm1hcCBhIHBhZ2UgZnJvbSB0aGUgUEFNVCByZWZjb3VudCB2bWFsbG9jIHJl
Z2lvbiAqLw0KPiA+ICtzdGF0aWMgaW50IHBhbXRfcmVmY291bnRfZGVwb3B1bGF0ZShwdGVfdCAq
cHRlLCB1bnNpZ25lZCBsb25nIGFkZHIsIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCXN0cnVj
dCBwYWdlICpwYWdlOw0KPiA+ICsJcHRlX3QgZW50cnk7DQo+ID4gKw0KPiA+ICsJc3Bpbl9sb2Nr
KCZpbml0X21tLnBhZ2VfdGFibGVfbG9jayk7DQo+ID4gKw0KPiA+ICsJZW50cnkgPSBwdGVwX2dl
dChwdGUpOw0KPiA+ICsJLyogcmVmY291bnQgYWxsb2NhdGlvbiBpcyBzcGFyc2UsIG1heSBub3Qg
YmUgcG9wdWxhdGVkICovDQo+IA0KPiBOb3Qgc3VyZSB0aGlzIGNvbW1lbnQgYWJvdXQgInNwYXJz
ZSIgaXMgYWNjdXJhdGUgc2luY2UgdGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgdmlhDQo+IGFwcGx5
X3RvX2V4aXN0aW5nX3BhZ2VfcmFuZ2UoKS4NCj4gDQo+IEFuZCB0aGUgY2hlY2sgZm9yIG5vdCBw
cmVzZW50IGp1c3QgZm9yIHNhbml0eSBjaGVjaz8NCg0KWWVzLCBJIGRvbid0IHNlZSB3aGF0IHRo
YXQgY29tbWVudCBpcyByZWZlcnJpbmcgdG8uIEJ1dCB3ZSBkbyBuZWVkIGl0LCBiZWNhdXNlDQpo
eXBvdGhldGljYWxseSB0aGUgcmVmY291bnQgbWFwcGluZyBjb3VsZCBoYXZlIGZhaWxlZCBoYWxm
d2F5LiBTbyB3ZSB3aWxsIGhhdmUNCnB0ZV9ub25lKClzIGZvciB0aGUgcmFuZ2VzIHRoYXQgZGlk
bid0IGdldCBwb3B1bGF0ZWQuIEknbGwgdXNlOg0KDQovKiBSZWZjb3VudCBtYXBwaW5nIGNvdWxk
IGhhdmUgZmFpbGVkIHBhcnQgd2F5LCBoYW5kbGUgYWJvcnRlZCBtYXBwaW5ncy4gKi8NCg0K

