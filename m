Return-Path: <kvm+bounces-17812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C67A88CA520
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:39:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C58B1F22AB7
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29AFC137C28;
	Mon, 20 May 2024 23:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E5gZ7noG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A63611A;
	Mon, 20 May 2024 23:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716248354; cv=fail; b=gTVFQ6TmKSmdb5Yhf6wbDAn6vuRdbKt1tAXJa/RwtoAoSWX8pyuJE6DN6TNzzeGQHyj1844gsq1KI6UCHIr6994HPs2m14SgREzEgBtBTP3Y3MAX6FDa0cCwf5lCCH+tNefrh8cZYpY09Iq8l6bI3PuUO36m8p1yoOgFxIw4zL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716248354; c=relaxed/simple;
	bh=kjuMdtnaW7rlO8fgTfJQ6x/MtN66a72eCHF8NKbbMk4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bF/IdRdrh+YMKXsQwwk/PgbkLO5i4UMaPgajay12ULvjHrXCYf4ItKQR/h0pqA/RFvvAywwKg2qdlw6AqH49dYoo23ZCobQDr5/Prs/291SImdqqAXOoTK35+4QSBm9v10Kvpujzcg4zi7axu2+/0d8k3g2fEPtB11NTNggsWtg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E5gZ7noG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716248352; x=1747784352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kjuMdtnaW7rlO8fgTfJQ6x/MtN66a72eCHF8NKbbMk4=;
  b=E5gZ7noG1dCoqY/3aHYgKjTJJZKa3rIhHytpa5M0dz4FpmMTdYj+RE2L
   8H2vXzwNrUYqJ04IYHVzMBbmZcpV0qzUyqlIhFozDyEJY7fPiBHxjN0Xi
   d9cE0bE9Okvgt2am3sVaajYA1FutP3r70YCElo/Fr+m2XQ+sWf16xuuR0
   +DUG/IZZaQ7+mIzi/LkXKZo7h1B0X1UAzw/PJ3agoyKTV0D2xzznvAImt
   tW2a44kywZrE2kgEbvuHAasX4wd+XYQmD/FC5ns23jmEZtoQJGGPXemV/
   3L5NBuAlMAq1vnBBJSxB8vSl6ygMnUB1oObrpQsAb8SwihFYE+HU0QVrr
   w==;
X-CSE-ConnectionGUID: ZV92DblzTDKE2tCvRYl3Wg==
X-CSE-MsgGUID: dm25IQGZQmynX/nlKo6Tuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="34927006"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="34927006"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:39:12 -0700
X-CSE-ConnectionGUID: RIIEswYxS8KBd28D//+9Ww==
X-CSE-MsgGUID: 2okXUl7rSsyvCkaWKXIbNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32739457"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 16:39:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:39:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 16:39:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 16:39:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqIgKMRNzjjtA6joByFxqBK7AkEE9AMpEEh5AagxW+kWWxjDmc3v4OWjFcQyE1hq2HgMxJ/HI4VNRe2aRlB/ZK//AAoSCnWr9BMmoUztDOnuqykrRH0OKeluqzG/+sKcMdFmUQJU+J4zOSJB2Yue+T1RlxJ63ImXRpc63Dz1PydUCnFFi+EK9XYn6n2gk+5UUaY+YiUPjBS5gP86XKhh/1FbBwS/NuUcyU0SKdlXuBlDbiKP6nhgMOBPxUQ/VtsFdj6La9bqB/9oBSiOtyYLpYRz7lah3h1Q9LPSts4d1d92h9Dhffwxjm5fqLH/jeQi00hb9aXhCl7Q9gmHQJTvTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjuMdtnaW7rlO8fgTfJQ6x/MtN66a72eCHF8NKbbMk4=;
 b=gtRGbXaOOYFBZzyaoG5vzy2P5cJTnaUdzn741TVIv9fiRNLQT7/kY/pVforpxYgo5zx0RBDEjQjPLOAeyOE0SlBuGKwCLfEaApISIDjpYNXHsGnf5k4rxSFyJXAf44tSANg6jwIaNwfnNPhdOikeDzqf189mk7czWGa6La4UhIwzP+KA4GTtb9N2y7STV1SIYzkTanpGRjXkA3L11LJm559d0btbqMT+9reG2Qy8LpFARGFGhMQX0AHQ1xh8mflWQzh0FHRsaZ+xznuT4anad4yu8ftxqLkglJjE+Ge6tgeLBveznd8aKm3h99xHBqydZn0Ift5oPWiCaWAdA1KDOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5024.namprd11.prod.outlook.com (2603:10b6:a03:2dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 23:39:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 23:39:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgIAAM8qAgABz1ICAAF5sAIABZ7wAgACnZ4CAAtAtAIAAi4KAgAABJACAAE1QgA==
Date: Mon, 20 May 2024 23:39:06 +0000
Message-ID: <2ee12c152c8db9f5e4acd131b95411bac0abb22c.camel@intel.com>
References: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
	 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
	 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
	 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
	 <20240520185817.GA22775@ls.amr.corp.intel.com>
	 <91444be8576ac220fb66cd8546697912988c4a87.camel@intel.com>
In-Reply-To: <91444be8576ac220fb66cd8546697912988c4a87.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5024:EE_
x-ms-office365-filtering-correlation-id: 663cf4ca-ccd9-4639-4d30-08dc79260a0a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TS9OdzA5Uml1OTk4KzZqa0pKWVhUV3VoN3F2Y3ZwUTI2VmtUeEVVRGtaQW1I?=
 =?utf-8?B?RmRxS0FmUzVtYWw4aSt0cnhJdnFxWmQvc2N1TWorTzQvdngyYWJlcGp1VUxq?=
 =?utf-8?B?N200YzRNaWVSa0x3L2FNUEMzbmtrc3B0NTdJMXliZVE1cW85aENCbnRXeXpZ?=
 =?utf-8?B?YXRpQk1yUlA0WGREeEREYXE2VFNJdUxvS2dXemtFbjBJT3RWemNRak9tY3RC?=
 =?utf-8?B?a3VZS2l3YWtaRHBJanJBZDZvUUp5bG9pV080UGpYalJ1MHk2TXIweEpQZTB3?=
 =?utf-8?B?L2hkbmRSdU1IQUllcTdFM1pURnNxYkJWTjh5UVBwZFl0MktReFVpUlZYRHdW?=
 =?utf-8?B?SUNZcnlycGx3amF0elVKNktkOHhTNnhzamlNK3FhRHgrZWdjOG9tY2VsRVBn?=
 =?utf-8?B?RWxwcEZrbW52MUYwUXB3SlFPalZvckt4R2xpRVFtenFpR1RCekM0cThWTUdB?=
 =?utf-8?B?MmJIbWEvSzVIUU5LVkFyVm84SjdtUmVDK1VRVXBNQXJzK0pmNE0yZ0ZxU005?=
 =?utf-8?B?TGVjQ3I1ZGZGVUM0ZTJIc1hvNmhSdmRBQ25PNkVNN1pEM2ZPdnRQeENUK3dR?=
 =?utf-8?B?MHNTWlhSSjlkWDE5MDR3RXZTZnRpMVZ5clVhZ2ZZTHg1WDF4NXZzQ1pEcGky?=
 =?utf-8?B?Q0xEdkpvY0JDWFd4aUdDY2VNKytjWE9KZDNveEttZDA2WlJta3VZUTRIbzZC?=
 =?utf-8?B?bkJ5S1hpdGt6UDRTL1hzQTVSVkV3MUdUWVdwaThiNEtYeXpiRllzU01pRVpL?=
 =?utf-8?B?am9qOGlDM3I4bm9QSU55RmdrUkxqMEVaVnlMRUxSZXlBT2R4cytlS3cwYkRh?=
 =?utf-8?B?SmtYTEdTY2lLRU9ITzVGQWpmSFRyUzJmMEk5akFOa2JLM3ptb29xdmw0TGpx?=
 =?utf-8?B?N0Fvd1VRM2RybHliZHFJaGtnNWlLRkVobkdZK21KWlFoZTM4REl2dHlweThk?=
 =?utf-8?B?dVZIc0dQM2MwL3FMRXdxNlZlaDZRU1hPMWVNbEZPaXpRWUFmWHdoSDNuQi9n?=
 =?utf-8?B?QXpHb1hjdCtPMnY0cGNwWC8yaDVHcm9PM0tiREhkeDMxTE5vZUVRQ2ozdms2?=
 =?utf-8?B?THpLN05zRWp6RTI5MVlYM3lqYzZoTFVqazNTUXV3aWlYRXAzSUcrWDBxdEdB?=
 =?utf-8?B?OWw3UDNWY3RkQTlCSWtScyt3UElXcWQ2ampSdmZnb2JISm5mUXUwcFFvMDV1?=
 =?utf-8?B?M20zeE1pbzA0R2ZoV3BuVWRYeDkyNG51bHVhZWU4ZWozVDcrZGNyYmtDYU9E?=
 =?utf-8?B?LytmUkM4dk14NUFiTFZXWjM1ODVmZ1ZCTDIrdmx2VEYydkVSNGV6UW8yMmhB?=
 =?utf-8?B?U3NmZ0pWeFI4ZWsrMDV4Q1JJek5BWGdtRWI3dDEvSlVTVlJvSkQvbEdQT283?=
 =?utf-8?B?MlJkSjFXYWlaa1cvajFMLzkzdmVNMkd4Q2pzbUxLWStnQjFZbkRaN1IySWVV?=
 =?utf-8?B?aXB1MkFjMXFiOGJ5V3N1czFUcmRhcVhaOERUOUd5d2VMMHJ4Q3hTRlhhUjh6?=
 =?utf-8?B?eDk2Vlh5MHpJZ3FHQmhvVVpKbGpGUmZ1K0JVZFJrUnBRVml4TFQzT1NSODRp?=
 =?utf-8?B?U3RiUUVHRXF6NmF3TG14ZWRzN2xnaU5VMEI1WDlac3ozcTlOMzFtWFoxRzRB?=
 =?utf-8?B?RE9DQ2F4cWZkRzNUaVljUG5GUzYvRGZ1M0IrbzZmbWwrdjNzZTg1djVtajRL?=
 =?utf-8?B?Q1dEN1hsK2N3cE1uaHlqK1grb3hJZzMzZ1BIMlZodkRrZW9wV2M4VmVnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmdmQ253UllaMEhvd2k3cVM5czNPenJUQUNIRGdweHZMenNIOVQ0U2h5VENZ?=
 =?utf-8?B?M3FSaWdHRXFPcVBXdE9RVUx2QXNhRk04M1luVVpTd0hxSHNmYVhxV1N3YVJB?=
 =?utf-8?B?YUZubm8xZHNPVk1HSHdJc3VnbzhlTzdUa296bURJeUwyMmFoaWRYb21MTnhG?=
 =?utf-8?B?K2k1TjRXQ2FJVmlzM2llT3haaUVadmNHSUxUZE1EWWN5R3cxc3o0ZHYyakcy?=
 =?utf-8?B?VXVRYW01TDh6M3FMeks5bHM5WWZQUjNYMHBJdENCeEswb1RjZXEvclBLTWhF?=
 =?utf-8?B?TXdPSzluYkFqbnpVZHIrL3dSTnJsTTNaTlFncG5DU3FJdmN2cjRyMnlScE5i?=
 =?utf-8?B?Mi90YWsyL0IxdjgxcWtUY2c4WXQ1YUhITHEvS3orL3JGS2lPbUp3cUY5QzFo?=
 =?utf-8?B?R3d4Nis1NHlMN1ZabFVMSmovQ2tFdUkxaHgwOVdBb21GclRaeTlNUXozVCto?=
 =?utf-8?B?QktCZThmanFpTklXRUg3ZDBvRFMwcXJUeld4aE1DK1lhb1BNWGJqT0J1RE9X?=
 =?utf-8?B?bVVzaDFMRFBXMVppTFpvZmswcWJNelRudk9xdDUxNEdnaS8vcmlpUWgwY3du?=
 =?utf-8?B?ajF5RjNJUFU1UFQrZTJVTll5V3h6WTV0NUJxZk5PQk9mUzlLMjFDNFB4OXpV?=
 =?utf-8?B?Ymw2WXBlbzh4dXE2VWRTWVU5eDl3Q2srbWhOQVRZWEQ0NHpuU0xlMXBwQXE4?=
 =?utf-8?B?U0RzeWRhNGVOeTNBcWd4bW15TzNFYjZnKzJiZlN1dVdVZjgyTVdUd0RnMUVi?=
 =?utf-8?B?bVdiUTgwR2EzWlBiV3ZLekpYK2VZekV0ampXTEJKbkNYZnU1VWhvd3NzZS85?=
 =?utf-8?B?MUNvVVNjdFRTaFdGZStDSVdoa25SZXVHVVFmVlFnaEFLSm56YVE4c3JMZGVh?=
 =?utf-8?B?Yk92Q0JzckNIbzNCYmxwRDRKcGtpRzBzVVpUL0VIdDdRUlRNcFlTaFhLMk1W?=
 =?utf-8?B?MzBWaEx5R3VPZDlQZnNUNzhDNzRnV0N5a01GNXVkOEhzVmw5bkpMR0NxaGRK?=
 =?utf-8?B?UmVtaVdqeTllajgzSzJEMDBjblBORTEyUVlWNmJvbDhXdEg2RkVXVWROQzNJ?=
 =?utf-8?B?NFhxdjFqVW93aVRSK2puVFRCR1ljbHNWRVk0MHM2YlNxY092Z3d2L2pYb0lR?=
 =?utf-8?B?V1BaTzVqUFR1cnpxdWJLdjFjc1hkbk9ZOVNWNW9iVWxwdXJQSzdKSHBsQkJu?=
 =?utf-8?B?Q2tzU092Q0taZERtTWxVZ2hKVU5EekNkUk50dVVScmhKS2QvTUdWNFZCQTVP?=
 =?utf-8?B?dFIwNk5CMTN4NGo5YVp1a2wyOTdncHNUU2I4K2RpWnQ0QW1sNkpRMjVmRnNt?=
 =?utf-8?B?SjRLN25KTDVOQ1kvTXB3M3NrbTBUL1c0OTZ5QjJuTVpCU25IVWgyZEwxZmtB?=
 =?utf-8?B?OEwwOEVUVlMyeitGVWgxS2tqZTNTb3d6NlEvOTlVYVh1UklQblpxMXAxNWh2?=
 =?utf-8?B?WFBZcVFzS0FhUzJiRUtrT0FsY0V3cTJnc2JyWk1LNjkvTS9EYVZlTDdRVXpE?=
 =?utf-8?B?eXNnbEhlTVQxU3dWMnJ6Y2toYzIyOGoyeExFcHJ0UnRTeHhPUWJ3THlGdW9O?=
 =?utf-8?B?cVZwbHc1ZzlSMEZ3TXFybmdxUnM3OEV1YWs5OHJxVmlOTWtXeGIxQUw5ODhL?=
 =?utf-8?B?QVFXbVBpcW1lWHhGNzdNZWlNcFNLNlFOallZMWliNWluR20vWml5Yk9VOXdu?=
 =?utf-8?B?aVZsS21kenc2bXFPZTd0NlM2eHZMdHd5RzdRYXN3dGVISmNvRVhKYzFMNkhM?=
 =?utf-8?B?TGRTbHpOWW52RkxXR0gyaU5MNjZsd01WcTFZUW00Y3VsTkFFR3ZnUWlQb2JY?=
 =?utf-8?B?ejdsaUNCZWlFOE5BcGRBeElrT2IraThzRGh1YThQOHVkTDBJYTdPV005Q1I3?=
 =?utf-8?B?M0ROWWdvSzduTVEwZDR2NmhuUFlVdit6T2lVWVI3NDBqdFpqcmg2R2R6Tmp5?=
 =?utf-8?B?enVHbmRUbGQzamhIdy9yS1Jqa3VHWEZmTklaWGcreWdoaStJdDlENGZtaEsw?=
 =?utf-8?B?ak03d01mUDhFUlhJKzhrQllYSllNc1VkSFhzY2dwNWlwYWVRSXhVbWxPNFlY?=
 =?utf-8?B?M2szdXU4WG5mUkJLeW9WamhVOU5sYit3T2EwdlVMcXhvRjR2cTNMZlRGb2xT?=
 =?utf-8?B?UFU3M0hkcTN4aHluSU9tYjBVY2wwbVBvSDIraUdkQk9JeFQ5eVNaQm9XaVUr?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <118243AD682BFC4CA804B32A0A972B12@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663cf4ca-ccd9-4639-4d30-08dc79260a0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 23:39:06.3357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ze96fDxqSjFgNTUB//2GWra+Ucn5xE/QRw6x5e3A5HP1f5TLyhGfMeJ/+HL9C8RzDCT0DbBu8TL7vDPkuNz6BJQ2Dp2lA4Nd9xslocHPUa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5024
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTIwIGF0IDEyOjAyIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gDQo+IHJlZmxlY3QgaXMgYSBuaWNlIG5hbWUuIEknbSB0cnlpbmcgdGhpcyBwYXRoIHJpZ2h0
IG5vdy4gSSdsbCBzaGFyZSBhIGJyYW5jaC4NCg0KSGVyZSBpcyB0aGUgYnJhbmNoOg0KaHR0cHM6
Ly9naXRodWIuY29tL3JwZWRnZWNvL2xpbnV4L2NvbW1pdC82NzRjZDY4YjZiYTYyNmU0OGZlMjQ0
Njc5N2QwNjdlMzhkY2E4MGUzDQoNClRPRE86DQogLSBrdm1fbW11X21heF9nZm4oKSB1cGRhdGVz
IGZyb20gaXRlcmF0b3IgY2hhbmdlcw0KIC0ga3ZtX2ZsdXNoX3JlbW90ZV90bGJzX2dmbigpIHVw
ZGF0ZXMgZnJvbSBpdGVyYXRvciBjaGFuZ2VzDQoNClRoZSBoaXN0b3JpY2FsbHkgY29udHJvdmVy
c2lhbCBtbXUuaCBoZWxwZXJzOg0Kc3RhdGljIGlubGluZSBnZm5fdCBrdm1fZ2ZuX2RpcmVjdF9t
YXNrKGNvbnN0IHN0cnVjdCBrdm0gKmt2bSkNCnsNCgkvKiBPbmx5IFREWCBzZXRzIHRoaXMgYW5k
IGl0J3MgdGhlIHNoYXJlZCBtYXNrICovDQoJcmV0dXJuIGt2bS0+YXJjaC5nZm5fc2hhcmVkX21h
c2s7DQp9DQoNCi8qIFRoZSBWTSBrZWVwcyBhIG1pcnJvcmVkIGNvcHkgb2YgdGhlIHByaXZhdGUg
bWVtb3J5ICovDQpzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2hhc19taXJyb3JlZF90ZHAoY29uc3Qg
c3RydWN0IGt2bSAqa3ZtKQ0Kew0KCXJldHVybiBrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2
X1REWF9WTTsNCn0NCg0Kc3RhdGljIGlubGluZSBib29sIGt2bV9vbl9taXJyb3IoY29uc3Qgc3Ry
dWN0IGt2bSAqa3ZtLCBlbnVtIGt2bV9wcm9jZXNzDQpwcm9jZXNzKQ0Kew0KCWlmICgha3ZtX2hh
c19taXJyb3JlZF90ZHAoa3ZtKSkNCgkJcmV0dXJuIGZhbHNlOw0KDQoJcmV0dXJuIHByb2Nlc3Mg
JiBLVk1fUFJPQ0VTU19QUklWQVRFOw0KfQ0KDQpzdGF0aWMgaW5saW5lIGJvb2wga3ZtX29uX2Rp
cmVjdChjb25zdCBzdHJ1Y3Qga3ZtICprdm0sIGVudW0ga3ZtX3Byb2Nlc3MNCnByb2Nlc3MpDQp7
DQoJaWYgKCFrdm1faGFzX21pcnJvcmVkX3RkcChrdm0pKQ0KCQlyZXR1cm4gdHJ1ZTsNCg0KCXJl
dHVybiBwcm9jZXNzICYgS1ZNX1BST0NFU1NfU0hBUkVEOw0KfQ0KDQpzdGF0aWMgaW5saW5lIGJv
b2wga3ZtX3phcF9sZWFmc19vbmx5KGNvbnN0IHN0cnVjdCBrdm0gKmt2bSkNCnsNCglyZXR1cm4g
a3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9URFhfVk07DQp9DQoNCg0KSW4gdGhpcyBzb2x1
dGlvbiwgdGhlIHRkcF9tbXUuYyBkb2Vzbid0IGhhdmUgYSBjb25jZXB0IG9mIHByaXZhdGUgdnMg
c2hhcmVkIEVQVA0Kb3IgR1BBIGFsaWFzZXMuIEl0IGp1c3Qga25vd3MgS1ZNX1BST0NFU1NfUFJJ
VkFURS9TSEFSRUQsIGFuZCBmYXVsdC0+aXNfcHJpdmF0ZS4NCg0KQmFzZWQgb24gdGhlIFBST0NF
U1MgZW51bXMgb3IgZmF1bHQtPmlzX3ByaXZhdGUsIGhlbHBlcnMgaW4gbW11LmggZW5jYXBzdWxh
dGUNCndoZXRoZXIgdG8gb3BlcmF0ZSBvbiB0aGUgbm9ybWFsICJkaXJlY3QiIHJvb3RzIG9yIHRo
ZSBtaXJyb3JlZCByb290cy4gV2hlbg0KIVREWCwgaXQgYWx3YXlzIG9wZXJhdGVzIG9uIGRpcmVj
dC4NCg0KVGhlIGNvZGUgdGhhdCBkb2VzIFBURSBzZXR0aW5nL3phcHBpbmcgZXRjLCBjYWxscyBv
dXQgdGhlIG1pcnJvcmVkICJyZWZsZWN0Ig0KaGVscGVyIGFuZCBkb2VzIHRoZSBleHRyYSBhdG9t
aWNpdHkgc3R1ZmYgd2hlbiBpdCBzZWVzIHRoZSBtaXJyb3JlZCByb2xlIGJpdC4NCg0KSW4gSXNh
a3UncyBjb2RlIHRvIG1ha2UgZ2ZuJ3MgbmV2ZXIgaGF2ZSBzaGFyZWQgYml0cywgdGhlcmUgd2Fz
IHN0aWxsIHRoZQ0KY29uY2VwdCBvZiAic2hhcmVkIiBpbiB0aGUgVERQIE1NVS4gQnV0IG5vdyBz
aW5jZSB0aGUgVERQIE1NVSBmb2N1c2VzIG9uDQptaXJyb3JlZCB2cyBkaXJlY3QgaW5zdGVhZCwg
YW4gYWJzdHJhY3Rpb24gaXMgaW50cm9kdWNlZCB0byBqdXN0IGFzayBmb3IgdGhlDQptYXNrIGZv
ciB0aGUgcm9vdC4gRm9yIFREWCB0aGUgZGlyZWN0IHJvb3QgaXMgZm9yIHNoYXJlZCBtZW1vcnks
IHNvIGluc3RlYWQgdGhlDQprdm1fZ2ZuX2RpcmVjdF9tYXNrKCkgZ2V0cyBhcHBsaWVkIHdoZW4g
b3BlcmF0aW5nIG9uIHRoZSBkaXJlY3Qgcm9vdC4NCg0KSSB0aGluayB0aGVyZSBhcmUgc3RpbGwg
c29tZSB0aGluZ3MgdG8gYmUgcG9saXNoZWQgaW4gdGhlIGJyYW5jaCwgYnV0IG92ZXJhbGwgaXQN
CmRvZXMgYSBnb29kIGpvYiBvZiBjbGVhbmluZyB1cCB0aGUgY29uZnVzaW9uIGFib3V0IHRoZSBj
b25uZWN0aW9uIGJldHdlZW4NCnByaXZhdGUgYW5kIG1pcnJvcmVkLiBBbmQgYWxzbyBiZXR3ZWVu
IHRoaXMgYW5kIHRoZSBwcmV2aW91cyBjaGFuZ2VzLCBpbXByb3Zlcw0KbGl0dGVyaW5nIHRoZSBn
ZW5lcmljIE1NVSBjb2RlIHdpdGggcHJpdmF0ZS9zaGFyZWQgYWxpYXMgY29uY2VwdHMuDQoNCkF0
IHRoZSBzYW1lIHRpbWUsIEkgdGhpbmsgdGhlIGFic3RyYWN0aW9ucyBoYXZlIGEgc21hbGwgY29z
dCBpbiBjbGFyaXR5IGlmIHlvdQ0KYXJlIGxvb2tpbmcgYXQgdGhlIGNvZGUgZnJvbSBURFgncyBw
ZXJzcGVjdGl2ZS4gSXQgcHJvYmFibHkgd29udCByYWlzZSBhbnkNCmV5ZWJyb3dzIGZvciBwZW9w
bGUgdXNlZCB0byB0cmFjaW5nIG5lc3RlZCBFUFQgdmlvbGF0aW9ucyB0aHJvdWdoIHBhZ2luZ190
bXBsLmguDQpCdXQgY29tcGFyZWQgdG8gbmFtaW5nIGV2ZXJ5dGhpbmcgbWlycm9yZWRfcHJpdmF0
ZSwgdGhlcmUgaXMgbW9yZSBvYmZ1c2NhdGlvbiBvZg0KdGhlIGJpdHMgdHdpZGRsZWQuDQoNCg0K

