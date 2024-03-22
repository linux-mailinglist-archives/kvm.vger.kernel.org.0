Return-Path: <kvm+bounces-12461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89590886476
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 01:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF2E2B2150C
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 00:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7D310F2;
	Fri, 22 Mar 2024 00:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LG6NbLb/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61CA376;
	Fri, 22 Mar 2024 00:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068019; cv=fail; b=sgVxdqOPVOxXZursUpK4W80QoWis8uUR2cbbOMiZP2KeN6WESdYzTUzkhibOr4gm/V+NpkMhQ4oVKQXS++UklRZKa+WZLMQtDoRdJ9fj+c+4hb/GKefEkTFkAQ1EAPP9cZgGi87d7+wVKzSUiB5VGhWtcZE3LFrINrWOKu9Wutk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068019; c=relaxed/simple;
	bh=UGRfISmuh0hPUseCpExkGZo8+2Y9dnnNANKsppZENDk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qEaDtC57A1yglKcBtchbeEmsxt8T3c2AZ2owB01IX7Nyr0KuetNj3RtjmloKZoHE6Vg57SLV15df7cBybgXqXNpqvhR/LQjRDnRGZiNUtiTttE9cU8fAzbhdrzz3QAB1kE5y4rS8rC14soFDXaSqPRuFO1to4qTWjg2OMVcKczA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LG6NbLb/; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711068017; x=1742604017;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UGRfISmuh0hPUseCpExkGZo8+2Y9dnnNANKsppZENDk=;
  b=LG6NbLb/7KUV/sZJiiRQw54TDPzYmbPq5TKyi3ct3doV+a+S2jdIWb4r
   eES1W+HJYKNTpZlX46T4rcYB1JwDPmTOpJ1aBFoK/xqZXGzvaHLWw1sbY
   I+kgOb6TwNYBhYm65XlamlvEs3eut2Nq0lj2Ti2v2/Y8TRxuUnQDlsE4v
   NuUYL2IcafmxXuKP4w8cumatuQ4jf6ISkHHo+ad1k3dAZmTPhvZ4/2H8j
   ABABAGd54D7iTGn8fissQEMoYO9+6PPyMn7sgh3+tXUe6NJgYde9UTND4
   FILKw6JhSTvcJCZ5wlRYiGHyZlogX8z2JYkSbv/hcvwvP7ttEmnwu1eYW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9885331"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="9885331"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 17:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="19413296"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 17:40:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 17:40:16 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 17:40:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 17:40:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 17:40:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoNke3ahNl16euKKDiykVd97HdiLbwxYiNVibmPfjZ0qHsH627/JdNiRFyO4xL+k1n+E0d/TGz2FbjWGGcRygYsgx7s7x71y8K0/x7cFleGFISj3qnPC8TRl40KW2ZGvhvgiOR9ply2d0/SPOySC7Io/cbLMelSTJ4ne+GqpYZf3O/WYLXA5oE5wxg06VT9gmcKOr08lad3itTcHyIX+eAjmiOEpsEht+bh7qAVezxcIy/EfB6V0wUEJ4HBdSk21CrEdwruJfpBGXLR5FtRAM3XFC4uc9sy2v73R7kn9c1zDqi/qhjhlLTrRg7gU3RcCJkhvWgcK9KRUL6w3orNTmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGRfISmuh0hPUseCpExkGZo8+2Y9dnnNANKsppZENDk=;
 b=g9IChzq+SWYooeIq20e45HrRQ82aS78qFhkxGvVM/reNOdx0LQnY9w+Xlvjf+KQxHn/F515zhp22sdK8MkUE3oNncsACqSCLa0Bc53PTjTQjZBC3esh+62I2nzXxIsGfU0j0P/eAFM8qQTZBk59q4GxGEP+uiG2dNmQpDdpb6AhL0YZalYKrQfew8QHTLY6UFjkRGfgomb/qSRe0kpgoCEk5pICsGq0HzGU8DfBqUyyCtqofFZXUt5g9pHDPUOuAuD7EbW27SpzrvGFOHX1EHLTJ3ZBKCURzdRIQr5daRpy/ZBB9+I2j11WSiA0wZqqd8mR4LUEmYLj+PEn1lCr69g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8249.namprd11.prod.outlook.com (2603:10b6:510:1a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Fri, 22 Mar
 2024 00:40:12 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 00:40:12 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
	<hang.yuan@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gA==
Date: Fri, 22 Mar 2024 00:40:12 +0000
Message-ID: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
	 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
	 <20240319235654.GC1994522@ls.amr.corp.intel.com>
	 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
	 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
	 <20240321225910.GU1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240321225910.GU1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8249:EE_
x-ms-office365-filtering-correlation-id: ed314abf-c69d-40ad-084a-08dc4a08a26d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uhW9l29S7B8AizCvuxjBnvEDd2Lbdcgb+NdLWn+zMTV2nPA3VdKVxTQ67jefQoSiMhubcZGtCGSPkNRtWWjqKuAllBMz/w9/tKx9yu+mNypFV75eYoKIOA1DKLTy6KKKHLNh2J55RI0Y1ECPXEIC9zz6MJC+NBP4ZwAyrjo8fUTeH0BbEWw1PcL4dF88kfGNyyo2vncKeJ1zb1NEnGbExn+28xP2HLjIWUSHLTKQjnzduGWrN71SqK+z5szaRzlnkrRDdVfz6Dgst9wLsEQNMHcQ3dLIG6pCMAWqRnKbyQ2/ESWl69rKKgDFFucPZqw7ED62lD4MkNJPaMuUqWBeHcVMzwaZQbSrPAQ1Jk14aIkEkFLEMVTUpoSRAso2z+g6CQwYy+yXMeyIMSZzfDj1HNKrF7o0wNhNTB/xbX9dO5JadcJqdz/xdboQqTmnVbxbUA1UKJ5Kw+N9k8pzGRoSR44AhjmrFHcot/kZFSIrtT2famgU06tifS9XxhW2gYMqH7pFd3TKg2x0aPzNZOeqbw1o2dTrIqdN9YDpToy339Cafxp6lpk29Qe4twPM4zEdvCHqSvsUwwLejWJeO+rAdYXscNfJM3SycqzWzOz9RxW24+McehH6DSNKR2wftqARqxy4L0UPhm/Xfjyv7sLIBH4tvJO6HCnWdoXnSFW7PbwEl+Ahvv5O4NlE5pVW375g+D7csuEjs3IrEB7hcIiW4wuemWchRUO4bb0YQyCoVPo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anBJYXNaYkU1SDVHK01TeEdYK3doNnNKWW1MTjlXZmdOMzJtSEJPcmxQZ2kw?=
 =?utf-8?B?Vkk3d2toU1dlMG5wa0pzMWJZQTM3YUxnSGJzMmR4MlZJbEdmRWx6RmNoZEFL?=
 =?utf-8?B?U3F3NzZQbmJaUjhSUHB1ZXcya3U4MWZ4Qnljb00zWmNzYnF5emRnR1gycWlj?=
 =?utf-8?B?aWZ1RUhsVGhWdUplekE2ZzF4RTY1dW9IRzVNcGlnZXBpYlZGbFdjbk1Ca3JH?=
 =?utf-8?B?azJ0THk2TG9KOWNMNmRkTFFSQ0x0eHg3NFEwVm1VWGU0dEhGeGFXRHJvQngr?=
 =?utf-8?B?QTh4a2dwaHBDK0t0bzNsZ04ySG90TTBuSTA4Z0lOZnJLNW0vZm9HVmkwN3Bp?=
 =?utf-8?B?aDZhWGROSTEwY2ZZdzlVcitYc0JLMjF6all1dGdhWlFzbnlZT1dMRXoyVGNa?=
 =?utf-8?B?SEpXTThLOHNmMkRTR1JpQjFLY0ZpdzBJRUdab3BJTUF6VTkrajJ5dHBDNFp4?=
 =?utf-8?B?c0FaZzc1VE05ODJqZFlyUG9OQUc0S0l0RkpuQUN0alFmQ2FoS2pOaWFPOFJn?=
 =?utf-8?B?VGVQcW10SGRGekpNMGdxMEVMZ2hwU0pEVkNReS9hYWV5UGZqSGlXU09rNWlR?=
 =?utf-8?B?bVJLSDZGY2EzUkVKclpFcU13d1oyMkVJL3lSKzczaHhQdWxQaE5BL0VvMkF3?=
 =?utf-8?B?Lzd5SG8rbXJxZjJyekZTUCtON3ZoRzd2OTREemJJVUtRR1gyMExsTFlMMm90?=
 =?utf-8?B?SlplckhZN0RkSmNYbnZ0OVduMlkvbk9KSmxwY1pFNS84Q3Q5TnNSTGFnR3NS?=
 =?utf-8?B?REU0TWNCREE1MG1rcUpUZytDS3VEVFZXekcxNGthMVg5NTN3YW9rUTE1a3BS?=
 =?utf-8?B?bkoyVG5HZThwc2RMN1ZtSklRZDlyVllQVjRHT29vSjJRcHdVSDk5aDRHOHlW?=
 =?utf-8?B?Z3JRMnFqRjdLZW5xL3VHaWZONW9ZS203OUVOQlNyTUwxZ3hwdHc3UzRwUG9R?=
 =?utf-8?B?aVdKYytMbHNDV0xQU2dSdzNrVWN5V2tveVJlbEZwekdmNXlVazl1MUJiYnVG?=
 =?utf-8?B?M284VnZwcEZrbUk5aGJ4NkZ0c3ZzRE84Vk1FRi9lNlRSRnJSRFNvQWo4Vy9S?=
 =?utf-8?B?aUhiL01hdHhVOU9Dc1k5Q2tWMGJ1R01KUkRNQTJKOERXeUtPSllsYzVldFht?=
 =?utf-8?B?N3loZ2Y4RzNzSm5IQ010MzdQcm5tbURGQ1ZiZUVacC91a1ZVVm43L2wxdWRP?=
 =?utf-8?B?ZG1BWkk1dnZWd0pPM08zL252elhONFljVTlJTnNvbWw4VGJDN0o4aklOYXpv?=
 =?utf-8?B?N1FqTitqaEtzcXFncjE0WGRQR0liOHdDZlVMVnNQTXorcmJncjY4dDJZRnZ0?=
 =?utf-8?B?RUpXa3EvalZzbXVHVFNUR2pPdlVja1YyUGY0ZDZNbzcxT0hBS0o3YVBVR2xo?=
 =?utf-8?B?SXR6em9UbXhIMjJDbEZnMXl2NGtQUnV6R1QxQlMyTEhiOUt6M2MrREY0NEVx?=
 =?utf-8?B?VzFsV3BrUkwxSS9EdTJ6MTMxVjZ6WlczUTdGYlN6RlJzUS9seHROQjJwa2Vk?=
 =?utf-8?B?YUhybWkrTWhoK1M0M2luOU9aQjduTUhZOEM3N2RJNzE1Uk5Jc0l0dWhBNWNH?=
 =?utf-8?B?bWhHSHJ6RkpBWXBjRUZObVZ1Z2UvRzhERjU4dXJzdnV4K1Q4bkdEMHpFZlA3?=
 =?utf-8?B?WHNXOTJTRk92NlQ1UW01dWw1RUYvdko3L1FidkJFcG5iV2ZhY0QxTFJwS2xB?=
 =?utf-8?B?SmxpZndKZk5KeFA1VmNUUzMyWmp6SXk1eWtacU5Gbm1HSzBLQ1FXNXhJUEpw?=
 =?utf-8?B?eFZxTzBqNkxZc3NLa08wcGVOSm5zQ1hjSWxVK2RtK2VBRSt2YjM4S0VZRHVs?=
 =?utf-8?B?QURqVFVHek9DSW1qNHN2N1o3NEpkRmVyNEljNUxSNWFjVXdiYzY1cUlROU80?=
 =?utf-8?B?d3ZGc2ZLdlZtNHJkZDJpMjlOVE5WTTNFSUhFRXc2b2tJODJwZmdFNW8rMjVj?=
 =?utf-8?B?a1V6T29aZkMrMENBLzFReVBJUzhQdW9Vb0g1eDBJYlRxcitIQW1hSXhxcno2?=
 =?utf-8?B?L1hUeUhFRnIzZm1SSmYvd3BiQ2NxNkloWWVUbkl4aWszTm9VNVhIUENlY0Nv?=
 =?utf-8?B?SGNBUTA2M0tmZ1l3aVByOUp3QS9CR1VFb2M5SUh2cm56dnB1OXlxbTQ0U01a?=
 =?utf-8?B?K2VJeTZyZjdNbmN2ZFVUbU9qM1E1akh5Qmt3NlQ0dmluaFVrajNxSTlEUUxJ?=
 =?utf-8?B?SEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A17E8BAD200A9049933E43D3D36A0290@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed314abf-c69d-40ad-084a-08dc4a08a26d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 00:40:12.4396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNRcZzn8c1bg+exmW+wj/6PT8XYCt+UQuXhElGTsCa8m+TqFolW8hT2qYhp12/8RCnsc49VTpltz5ELYkP05qZFAG1CYPNxsqx2nxMXsJlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8249
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDE1OjU5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiANCj4gPiBPaywgSSBzZWUgbm93IGhvdyB0aGlzIHdvcmtzLiBNVFJScyBhbmQgQVBJQyB6
YXBwaW5nIGhhcHBlbiB0byB1c2UNCj4gPiB0aGUNCj4gPiBzYW1lIGZ1bmN0aW9uOiBrdm1femFw
X2dmbl9yYW5nZSgpLiBTbyByZXN0cmljdGluZyB0aGF0IGZ1bmN0aW9uDQo+ID4gZnJvbQ0KPiA+
IHphcHBpbmcgcHJpdmF0ZSBwYWdlcyBoYXMgdGhlIGRlc2lyZWQgYWZmZWN0LiBJIHRoaW5rIGl0
J3Mgbm90DQo+ID4gaWRlYWwNCj4gPiB0aGF0IGt2bV96YXBfZ2ZuX3JhbmdlKCkgc2lsZW50bHkg
c2tpcHMgemFwcGluZyBzb21lIHJhbmdlcy4gSQ0KPiA+IHdvbmRlcg0KPiA+IGlmIHdlIGNvdWxk
IHBhc3Mgc29tZXRoaW5nIGluLCBzbyBpdCdzIG1vcmUgY2xlYXIgdG8gdGhlIGNhbGxlci4NCj4g
PiANCj4gPiBCdXQgY2FuIHRoZXNlIGNvZGUgcGF0aHMgZXZlbiBnZXQgcmVhY2hlcyBpbiBURFg/
IEl0IHNvdW5kZWQgbGlrZQ0KPiA+IE1UUlJzDQo+ID4gYmFzaWNhbGx5IHdlcmVuJ3Qgc3VwcG9y
dGVkLg0KPiANCj4gV2UgY2FuIG1ha2UgdGhlIGNvZGUgcGF0aHMgc28gd2l0aCB0aGUgKG5ldykg
YXNzdW1wdGlvbiB0aGF0IGd1ZXN0DQo+IE1UUlIgY2FuDQo+IGJlIGRpc2FibGVkIGNsZWFubHku
DQoNClNvIHRoZSBzaXR1YXRpb24gaXMgKHBsZWFzZSBjb3JyZWN0KToNCktWTSBoYXMgYSBubyAi
bWFraW5nIHVwIGFyY2hpdGVjdHVyYWwgYmVoYXZpb3IiIHJ1bGUsIHdoaWNoIGlzIGFuDQppbXBv
cnRhbnQgb25lLiBCdXQgVERYIG1vZHVsZSBkb2Vzbid0IHN1cHBvcnQgTVRSUnMuIFNvIFREIGd1
ZXN0cyBjYW4ndA0KaGF2ZSBhcmNoaXRlY3R1cmFsIGJlaGF2aW9yIGZvciBNVFJScy4gU28gdGhp
cyBwYXRjaCBpcyB0cnlpbmcgYXMgYmVzdA0KYXMgcG9zc2libGUgdG8gbWF0Y2ggd2hhdCBNVFJS
IGJlaGF2aW9yIGl0IGNhbiAobm90IGNyYXNoIHRoZSBndWVzdCBpZg0Kc29tZW9uZSB0cmllcyku
DQoNCkZpcnN0IG9mIGFsbCwgaWYgdGhlIGd1ZXN0IHVubWFwcyB0aGUgcHJpdmF0ZSBtZW1vcnks
IGRvZXNuJ3QgaXQgaGF2ZQ0KdG8gYWNjZXB0IGl0IGFnYWluIHdoZW4gZ2V0cyByZS1hZGRlZD8g
U28gd2lsbCB0aGUgZ3Vlc3Qgbm90IGNyYXNoDQphbnl3YXk/DQoNCkJ1dCwgSSBndWVzcyB3ZSBz
aG91bGQgcHVudCB0byB1c2Vyc3BhY2UgaXMgdGhlIGd1ZXN0IHRyaWVzIHRvIHVzZQ0KTVRSUnMs
IG5vdCB0aGF0IHVzZXJzcGFjZSBjYW4gaGFuZGxlIGl0IGhhcHBlbmluZyBpbiBhIFRELi4uICBC
dXQgaXQNCnNlZW1zIGNsZWFuZXIgYW5kIHNhZmVyIHRoZW4gc2tpcHBpbmcgemFwcGluZyBzb21l
IHBhZ2VzIGluc2lkZSB0aGUNCnphcHBpbmcgY29kZS4NCg0KSSdtIHN0aWxsIG5vdCBzdXJlIGlm
IEkgdW5kZXJzdGFuZCB0aGUgaW50ZW50aW9uIGFuZCBjb25zdHJhaW50cyBmdWxseS4NClNvIHBs
ZWFzZSBjb3JyZWN0LiBUaGlzICh0aGUgc2tpcHBpbmcgdGhlIHphcHBpbmcgZm9yIHNvbWUgb3Bl
cmF0aW9ucykNCmlzIGEgdGhlb3JldGljYWwgY29ycmVjdG5lc3MgaXNzdWUgcmlnaHQ/IEl0IGRv
ZXNuJ3QgcmVzb2x2ZSBhIFREDQpjcmFzaD8NCg==

