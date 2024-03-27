Return-Path: <kvm+bounces-12800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6182888DC69
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 921E2B21C82
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63FFB5A4CC;
	Wed, 27 Mar 2024 11:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSwxSTln"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7CB3BBD3;
	Wed, 27 Mar 2024 11:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711538507; cv=fail; b=APgkflu6J2GOOFjTT14Ym/W1y+dG1Of5esK88bdhHVigaLc8ZEiFTOf1hjJK7kSDPNNcKurANOc4zqsygG5Gz3MZ2aS1sCmLVieVcS5kxLya9YCaGz7W+gm4zIgFKeu+QXH4U+L5tgYzoWHANrGc9bQpsi6VY05cAwKqBbms11w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711538507; c=relaxed/simple;
	bh=/v33l5tor09CuWGX3cAIrB+gzYIB54mPQTCgWCAGv7U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WbS9DZuK77QPLn2ZjfqZwcd4yDWHU4fzcq2NBgd5wA2FwJA6phN2weFO6/il6QS3WCyhYcnqmwAPxm4h2Ncxf6r/fAatCYBMCACw5m3ibZpnxaDb+gPvrkJEVwZazeNn/XNQ/v48o9eO35QdPGajRgKnyyAhIrSWmc34dNQXxZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSwxSTln; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711538506; x=1743074506;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/v33l5tor09CuWGX3cAIrB+gzYIB54mPQTCgWCAGv7U=;
  b=lSwxSTlnCZmZI3dXF6LoOTg4LDdpnlPBZzBu7H/SfEyAt/gZbIZ5RoFc
   V9Z1OMG1HwqB33kwCg/ResY1BLjg6R4gJSmQVniqbSMqhfFTsNVarMv5/
   bshtGt9sMcxE7wjUrMzBAwO6x+Qd0cHELWOkB0pwFs31BBYz3vQBUkdAc
   44qgvrDHUS/6N1L7QR94ilt9oMXmtOjq47JrF9ct2sMxqWud2E5BPJNyI
   f1nOj9kZua6beq1oUsCqejOT743cULylY0nOv17E/EteIDdpLbN9nKL9j
   htIe7KlUPTwMa1srYaFKOJ9QM3/SnrcQcLsrB3XDz9JvPPwi7FTQQLAAB
   A==;
X-CSE-ConnectionGUID: cxzm0N8hSxOsQvSvd6Pzeg==
X-CSE-MsgGUID: ELF4osyPS52gIjkW0Dvv5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="18017431"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="18017431"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16252586"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 04:21:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:21:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:21:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 04:21:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 04:21:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSjG2atOOxPHKMnCS3fvxOwn5mjyHN3HSSAky/69GZ4IARF0Zv/H2noxEAqd9O52fsXLKFHm0XAZByOXj9FkqNF0QHr3QO7wD2wZfRne2BEvXHcBxVGF/6RNICLjjMhcIrsMS/j3o8bs74F5WENB0Uf5/j7D5DlRa0Sayla1xsjnKVl4jApakpj8KSE26wNLv/4bG9Z+9l+JVqTxmU2YRqnL957A5AfEQfYFEIimO+DBwOwbT10hZwzsl0vHHEPFQeihxvfopIJed9hb1zLvhFPay1ThUzG0Qk4Tws0S8kN76co3nBFeN7cHCD1gnE8dj78MKr6JzwAagvcV01pq3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/v33l5tor09CuWGX3cAIrB+gzYIB54mPQTCgWCAGv7U=;
 b=fSUMPbxEraFAn2HXqbIn2FLuJtS1nR8hJ0wOgLLyCmmagBzGVXyiK08/pbNv9k6pucI9adaxti4tnREE8EYpIETFzgYSd6qJBhb9g9VDgj8kZahUP7ZnHjgJcHbTfPNQVJBmQo/Ot4j1cZXnHNT11lCV97tpbmU1WvUVSypbv73MM5ZQ+pI9HOWMwgE9VTiLRntKEMhaOufJGYucTRRc5bTAIL4Gns8Bc6Bq61ADtqUQoQdJcizM7WorJTNHRl59ULwxXJJCk2Qpr3pdejC740kaRsphYuSK1YBu/bs8zreeqQi7lus88L5P+VSK00buqeA20ongcd8wuOnzh9JUCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Wed, 27 Mar
 2024 11:21:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 11:21:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/9] x86/cpu: KVM: Move macro to encode PAT value to
 common header
Thread-Topic: [PATCH v6 2/9] x86/cpu: KVM: Move macro to encode PAT value to
 common header
Thread-Index: AQHaccD+v4jU7jSaEUOuH0fHSwvjIrFLjjKA
Date: Wed, 27 Mar 2024 11:21:06 +0000
Message-ID: <776fb43332564b4fab963214ff88f8a37186f875.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-3-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5814:EE_
x-ms-office365-filtering-correlation-id: 7966fa2f-daf8-41f9-b451-08dc4e4ffe9b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sViZmlwYAzzMCAkjeWvh2bN+nXLZpbK5KCuu5wk4SASWNLrdSUi5aUXDofHO1U9oz+TBl+h27BXKiJh9DLFnLgA6K3jKehnLb4mrjU4AX5MfyPyuE8VVrt1mfGUfqY2D6y2Yky9A90Zwc31YHqbqN150xbCFsXIAp3zG576Nn1fXuuXwCNo3GZehdtQSByPBwRIiJjasbp2jIMB7o1cKvCiZFlhiJ9/XVtUVpKrPHmnLgwRq8K8j6miY6rvcPqjNcVeGxJmpUkuLgjneLz/UtViunrb4dUjGsnUek8JNWvDp+YV39mDdVMVA9Akn19n/1/FIS1ltMYEQYjQYq29aQFD7U5iHonRkjnBtJxBfHmN3H1IL2OyB8M0sSo/CzZO3+SUMwLGgbYmRscsYMGHhdGPwOAcRT2NLf8yMg73uhH2wBjkDAOCu80XGbVKXm/YGecI5LOMJNg6VdLz5FETAmJETg3Npf1O78YZUoDO4Ss3OYh1O3nB0i0tVJW4fq3b+pUIkGFSqRuzPqqEMdGFuGCL0QkPuWzORGqGk+tFWm78a+4KfQa2ARww/67+ho/YWdkujk9oDf9mOUyt60LfOOAyuwPEddxIL+pKlL27b5P+fwYQGkIhDhSi1o7S/Gha60urLAN1qLLOA2BSXmseGjypVpR6GJ3I5x3vpJFyeEGholklDDOEQu9lEZ1vdNHmTAktafgZHofoiRVepjyeu1Ohg4oPUlxrpzgc8emHKEKM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDJvRXgyVXVnQTdHV1drWWZtdllWb3poV1ltVlJiK1FYdDk3Y2tKNEhrblU4?=
 =?utf-8?B?eEFydW8yaklPUFZrSFU5blhYZmhGR2JmL0hhcnF3d2VrM2JpT0dxdHgwR1d1?=
 =?utf-8?B?amtNMjQzQ2FVTFU3Vkkrd2VTTkIrZ3BjWGVjUlhGS3dWbnBpdTQ1bWJETTIv?=
 =?utf-8?B?RWpub1U3N2piMDFFdkdGZnlyT25xWGFCMTVHM3psUGk5SVgvdWpaWktQeVlD?=
 =?utf-8?B?bHVlUHRkNDV2TkpIaVlOQml2OVpncnBQbXZJOXNUTUdmUWd3cDlKdndXcmo1?=
 =?utf-8?B?TUZLcmlmbnh2WDMyNUkrRjUvNE5oRXYzdlhnU0FrZ0RBTUkyWllUckpZMW5V?=
 =?utf-8?B?d1Z1NEtSTHdHSTIrWW93SldOSmpjbzNHUFBQWm12cXJOYzI2M29QWHNhUEdi?=
 =?utf-8?B?L1BDSGhQblVmUkV4Zi9NMmFoQ2VJTGdGUHN0YWpFUXNEVmw0RGlDZzdxNHpt?=
 =?utf-8?B?VDFJRjB6ZS9KUDVteUZNcXpUdUR2NVpiaHV6ZHVpdy9OVGJqbTBXK2M0RHhI?=
 =?utf-8?B?U2RJbEh0c0ZFYU8rT1plcEEzZFJEZTI0RFhaalJqT3JOcUdsQVJ6QUkyUmdl?=
 =?utf-8?B?SUNQT21FeWFvRStsdWlRWVhrVGFSa3BJM2Fma1VJZ3pwMnZMeS9sUXVldXh3?=
 =?utf-8?B?d05YWDhhaGllNVU0YVR1bVVxUnNISHVzWE1JN3JJb3dtOXdyTWdTNFV1TXNI?=
 =?utf-8?B?MmJJR3YvUjQvNU1uWWtJR3Mrc3U1T1NsRGwyZ0gwSVVPSWY3ZmlqMzNOdEI4?=
 =?utf-8?B?MWROZEdtZzU1dXAySHBLZ2FvNGszZGVYeGlBcVQ2K3p5QlM3azV6SCtXTjM3?=
 =?utf-8?B?VndRajNidTIxTDdickdFMHFaeEphdDNFU3Y0MWhuNFZSWGJXYTVMSkY4K3Ev?=
 =?utf-8?B?V0VuVkdwRlNYM1EvdDNCUld3WE1HVisvU0ZURjhIT1RSYmdiOFZTTjhOMFIz?=
 =?utf-8?B?MG90dTd0OFMraFlHWHNtd1pGa2xMUHV5bk1nVGdqL3lqNW53RjEySlg2azdR?=
 =?utf-8?B?eEJhM2dNOEdNL1N5SjBGblJBUmY4TGp3TmFPWExnU1BYLzYvVHBmZ0pKbGtE?=
 =?utf-8?B?N3N2amNLNm5YYU1vRHpaQjFFWkpPUG5HQ1BrT21VVytmc25JQVVWWDVmTlhr?=
 =?utf-8?B?U2h6RlZvMCthc1A1OEFJUEhmalJkVkgyQ0IxTnluRWFxMDIrY0UxVzNtY09a?=
 =?utf-8?B?YmJEMjhrdWtLSmttbTdmRWoyMlpLUnZLOGdESHl4eXpIaExreXBZRStKeFB4?=
 =?utf-8?B?dzJMUkZGY05ZS1BNZnN5eGpCSHQrK1pwMjBDLzI4dGJReENtbXJqenF1OEYy?=
 =?utf-8?B?cUpwUmVlMXJRcUNjK0YybHEwTjVJaW94eUlEenJ5ZEVSQ2taaTlNdTNoTHBa?=
 =?utf-8?B?Y3NEamtra2UvMzFOckRiSXRDMk9meDJrblZpUWdFS01aNkZxQ0RKUHdCMlpp?=
 =?utf-8?B?NWpKRWVBM3lvVTFYZzIwWEFIUG9iTUROeWN0bGJlNFNzbTk3SklPQmJucDMv?=
 =?utf-8?B?NHlCTjA4N1NYQ1BNbWhPb1dXS1ArNFdDOEdFS2FqSjNRZGpoTEpqbFFBYi9S?=
 =?utf-8?B?SktZV1RKVzU5cE0yaTFYQVFKTUxLajkvaHFlY1NjK0dkZU82OTUvY05oNXZJ?=
 =?utf-8?B?WXIzMU1jcHc3dUtYRHF0c0VVY0d1SHZLUjJmU214dEZDaDF0T0laUDh5S2lI?=
 =?utf-8?B?SHdCRkFNalVaUWpGbURvdlZiK1Ivcyt4aFgzdWZpUTJ0ZDFnSit4T3JGajR1?=
 =?utf-8?B?MW1qVEhwSWJ3bjh1MUx3bklLZW55M1dqT3lPR0VYVTAxYXpsWXNOKzRoMTlR?=
 =?utf-8?B?NXk1RWF1UG01dyt0NzR2K3ltVWk3bk5nRkc3THEycU50L0VZQ0p4SktqYmZj?=
 =?utf-8?B?blZrb0xWTGp1bnI0bjRISDN3aHJTWlBnS0FXNk5Ub25pTnhIQ0wrVmh3OFZ5?=
 =?utf-8?B?ZmxhMCtTdFhEeXhXcUFaQlhpVFd3OWgrcGN4bmltYy9GL01aMDFUU2s2Tm82?=
 =?utf-8?B?ajdvUTJuckpKN2lERTZxakJjSXVpTjEvaTgwcGtPaXlIS1lNWUxZdTVoNi9w?=
 =?utf-8?B?SG9PS1FNK2NYY3BHaEV2SVk4MlF4YmNpN2IrZ0d0QVgvcUtWMkpuTUZ5ZU9y?=
 =?utf-8?B?cjVyLzg3MTJQelNOTjVvUVZRRzVxUE95aGRrVkE5TEs3Uml5SXE2R0kvVzd1?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B596DF382C8FEA48A1AAEA6F9E675714@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7966fa2f-daf8-41f9-b451-08dc4e4ffe9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 11:21:06.0226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dy8kX88LVqmZC1Y8J63pHOkmO5ylGRN4NB3N5GyEImfhzWGgCKZusubEFdaNN2tVRNWYhHqN81nqU8Z9WEz5sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHBhdC9tZW10eXBlLmMncyBQQVQoKSBtYWNybyB0byBtc3ItaW5kZXguaCBh
cyBQQVRfVkFMVUUoKSwgYW5kIHVzZSBpdA0KPiBpbiBLVk0gdG8gZGVmaW5lIHRoZSBkZWZhdWx0
IChQb3dlci1PbiAvIFJFU0VUKSBQQVQgdmFsdWUgaW5zdGVhZCBvZiBvcGVuDQo+IGNvZGluZyBh
biBpbnNjcnV0YWJsZSBtYWdpYyBudW1iZXIuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBp
bnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KPiANCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCg==

