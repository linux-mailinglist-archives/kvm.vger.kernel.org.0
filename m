Return-Path: <kvm+bounces-17440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F1C8C6990
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 17:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEAD5282BCD
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 15:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E427155A43;
	Wed, 15 May 2024 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dXoOt/x3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B321A62A02;
	Wed, 15 May 2024 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715786556; cv=fail; b=eXpldBFOVvLr+C4XIeQJQZzHT7Zo9Wasg6PF5Lx661kfCjeIek59uUYkUdMZV5WfAoZOFrrBybl9cEfsYlih8leAr7MFkrIJ6UpX84xoDZI1hefjbcPj4dmTg7evQ5VijyETtDVPVTUb6RQTWies87Abs/feoZH2PaTV/qMl0jE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715786556; c=relaxed/simple;
	bh=sdcHaVYFn/ofbc0zGkeB7RsprHY5sPI6W0XKA7C3fzs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rrWIcqj1BVAlfn2KLE9h/k3McPHJUUlPYaPMVU9XFmaPcH4bu4Ge1Bg9lMRmUJGSv1w3bWjRgKpfwqgDS+IJRu/RNOuFW8lzIVbgfgvkJhdLk62SDOPL1Wd0bpqB5AwoDqsVL9Bp0wvKzqMxgw4rleg1tEgSWjRKAFcxCA0Lf+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dXoOt/x3; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715786555; x=1747322555;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sdcHaVYFn/ofbc0zGkeB7RsprHY5sPI6W0XKA7C3fzs=;
  b=dXoOt/x3HYOSQC4TWp1NmBw2ZaU9lq3zsdRlV9Xev6OP+MlXHFuOEu+x
   Xf0LgbD9egvFtq6SM7lJ9XNDCg61c9AfYJs/R+TS7sA/++e5ySIZJnGm2
   gXpnsNPp6LCx0XYAsg/keu/j++lpAQ/+68fZV1w80h3Yr42FvF+3yrTWL
   cbUXE+/YsdyGrJEu9wf+jO0jZwiVtOhPdabxpjla89VYj5Ba2NLy0j40+
   BLz1T9gDPFsZvl4TLrvig5i9rW4/vuI3dgNQ5dZ21TD9XLIcAQe0HzhpU
   iEhemn45Q8cUHv2TsFBKAahFDcEaUj5UiWTqHscKc9q7HXvM5K1fdysRu
   A==;
X-CSE-ConnectionGUID: 8OMwkJpqR/S+EAhdetd5kw==
X-CSE-MsgGUID: +p+YEC7WRa+PFJCHCqRz9Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="14793825"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="14793825"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 08:22:34 -0700
X-CSE-ConnectionGUID: JVwRQCz4QqOKYmdT41Ai8w==
X-CSE-MsgGUID: 6LBmXFwfRJCGXxUsdmxOJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="30917774"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 08:22:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 08:22:33 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 08:22:33 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 08:22:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cI3oWuzan4Zsd2m4xc9PxdQ/2oF7ZslFU7CvyIUEKLJjqatdBXFxxAc6o4CjO8t/8zZEq/d9UP/uafE6+ILIN9Rk/WIfpVnBu+CJlszST2iojb+0aEH2+GMGFbGS12IqzJ0Eclh0+Uwd58hSUmugXSYNokcKCgXaT29XDNqZxwoGGZFWbY3yZmNGGno2/Oy74+I5IMbfX51SHfTWKlMgiqDhKCRCHgB6RZnH403rnV1ikqmCk2VV+6eG0JIqdGXO73/ZYkK7acDwzke8WpCuP0bYnzMfl7qkbSY/6QuhdnEUBDW9baFHFRa25OAOtxq70d6lSzUkMyMTjGVUnuFLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sdcHaVYFn/ofbc0zGkeB7RsprHY5sPI6W0XKA7C3fzs=;
 b=FyewzpY80S/dSy97uTEcZk+7MGyKtR2A0hF/6uXOD7wRfbho6AkONb+LCb9vc90ekxLmlWepXJEbl5QtAoRaKQYHa/s1iscwPQwAE8iT6ibOZQy0uQ2bXMl3eADtuX4gmQ/bjYCCjCYY8KYAh+LttEUhPr4tbRwphFkyJK+Gbe/bqUrFlswGARqnGlUgik/cRr4HllCHqxFTGmWVTaTUO47PEuXT7ELeZYcgeT5cWZ83MHLZEom9WHx38dwaTk6EhcuPnqkHfDehvfTav9Y4667WkbgH+/BXgojZN2pzXNK4k2E2TwtPfzRPhXgB3/wBgjlMqhJSDq4JKojJ+V+Lhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6850.namprd11.prod.outlook.com (2603:10b6:806:2a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Wed, 15 May
 2024 15:22:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 15:22:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGYSpqAgAAgBYA=
Date: Wed, 15 May 2024 15:22:30 +0000
Message-ID: <d0c16dc46ca0b21bffb2abeb3227d4d7f63ebaac.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <621f313d3ab43e3d5988a7192a047de588e4c1f5.camel@intel.com>
In-Reply-To: <621f313d3ab43e3d5988a7192a047de588e4c1f5.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6850:EE_
x-ms-office365-filtering-correlation-id: 49d90393-8cb9-4ed1-33c4-08dc74f2d610
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Z0dpTWJCY0hidld4MHE3QmovL2VXdGU3b09qbloyeC9MOG9sNWw4STlFVFpJ?=
 =?utf-8?B?b21Kb2pBVzJta1NVbitWTjZ0dzlaOGxKZWpTcTUzc0dSYU1lQW1PeXRnS3BC?=
 =?utf-8?B?Y0hrT1NDMVR5Ny96dFhWUVppWGZMckFwYTJ0L0N4anBOcFhRWGQ3VTdXREox?=
 =?utf-8?B?aUJOZmlHTXM0eDBEWGpLdnR1UlpnSkQwaEtPVTdQTlZ6UDNGZDlRS0JjZ2NO?=
 =?utf-8?B?bjNCWU5GZWtmR3FlaXF5V0J6UDNjYi96QnluZTczVE5iQUhoaUtxWHlkK0dy?=
 =?utf-8?B?V1VCL2N5ZithR3Z1K1Roc1Z4bEQ5YU1LaWY5ck4zOXRscU9ZM0pTZW9TK2Yv?=
 =?utf-8?B?L012NzA1dGVGQ2l1NTFwdi8xYjB6alNLaWYvR0paNnVuN3BxL082TG5OdFIz?=
 =?utf-8?B?eXZLT0tTbm1UNXdhaXJVbnZiQkxJU2lTNWdCUkkwUTlUTnpvSStnTU5VSFV4?=
 =?utf-8?B?QzB5aHA5a1RaU2Y4OGozbHhKaUovODM4Z29XRjA4d0hvQlYyNkVvSTRzZEkv?=
 =?utf-8?B?M0FkZmJ6S2VLMUFBbFI3b3hzVHlzY0F0SGhsMkF5WWVydW9jSkFjZ1UwQ05M?=
 =?utf-8?B?dWViUHlRSGMzclpXZUxuTjZVWWJzQ3k2WEJaeUl2WlVSY3BCbU1aVWx2ZkVm?=
 =?utf-8?B?Y2NQcGtQcXZmVzdSNmU4NEEvTGJHVjZRaXhUVG5EQVJ0MHNJQ1hqT3VkK2NS?=
 =?utf-8?B?NFdaeXpvQVphMk04T2oweWxDRGFHd2E3cFVDZXpuRXl3dWNZMmxTeitKN3Bw?=
 =?utf-8?B?QlhkNzNZSnI0MEZrTDVRVk9mbGdiaEV4d2lhMnNWcmxSMkVFQ0E0N3pjVlJh?=
 =?utf-8?B?Uk9GYUlNU2hyYjgxNkhKNUJsZ2hWY3k4eWdzNEd4S0RTZGNkak1sM0RFTEdD?=
 =?utf-8?B?RVJWa2lwUE95US9IeE4vUVg1ZjlqUG4xbng4dFhuSkZTWWdEMWhGa01zRU91?=
 =?utf-8?B?VkpweWpaL2JoaUV2VkRML2NWZEovdzR5ZnFvUy85UWJRQWdOaS9oSWVQWGZ4?=
 =?utf-8?B?S2pjdThYOWpTYW05WXBTUUljWC9zS2grVlBLNGpPOXZLb0hhVE1FbnlDMWFS?=
 =?utf-8?B?RGFFWG5CNFJ2NkhLNHNQdnNoL3ZPRkRtdDlhK1dNRDJTc3RkSUlVUnA2ak4z?=
 =?utf-8?B?Rzd6UC9hNWNmVVlJc3RWTVNCMzhBMUpNbzhSV2dkem5LTm9tRFZLdGZPU3VJ?=
 =?utf-8?B?MW5zcm9vcGFrZndLMElwQlluVlovc2h3b2J6VG4rVkdOL2pHWUozdE4xcG5Y?=
 =?utf-8?B?eTl4QzMxaXFhd2cyRE9MNDNta2NQdXR0ekJYZ1JCU3lmenVuQUdxMFI4QlBn?=
 =?utf-8?B?M0F6am10WDZlV2R0Uk1ud0dhL2g5WjVQQWZ3OGVnWXA3a0RxMTJHc0Z3Slgw?=
 =?utf-8?B?cXRCamhVb0tIMWl1WVlQVE12eHRzVFh2SjR5ckRjNERlOUVONjNjY1VNeEtN?=
 =?utf-8?B?Z3c1QXh5M2dTSkF3bWtFa0pTQU82TWpXZ1NGRjEwVXBOLzM4Q3pxSk9SbGNx?=
 =?utf-8?B?S2ZVTGpjWlRhaFBXRGFzeGFjeUtscVgwZEQ4OHRCS3ZTY1hMWmtqTm9VSGpE?=
 =?utf-8?B?N25LeFhHOWM0dlMrUTQxYjNCaTV6bkN3TFpkZUFnelpjdFlLVm42b2JrYm9x?=
 =?utf-8?B?dnhFTnlSMlJrc09IY2xMeklSTldpSHhiRHpjOXF5QnFOMnNrMUE4MHBKK1FN?=
 =?utf-8?B?KzVZaFJ3L3MvMXlDOXFocjZCa1JkeGUrY21rbTZndEcybXp1aXNzTDVEaWdq?=
 =?utf-8?B?Y1AxYm1UNGFJd3BtY3B4MkxBaS9CRTZwUklaaSt2YjNaMExYRExvdDJRSjhX?=
 =?utf-8?B?Wk4xTU5IL0drVzhtUFIxZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0svRk9NMXJ1UGEvRkkwbGdpT1RqWW9Ja29LbUh2eGIydXQrZGdLNTRaMlhT?=
 =?utf-8?B?OWw5WUsraTVuOUZ2bU9SSWRWSGsveU1WdFRiZUFrOEZzWmZZc0JOcXhQc1JB?=
 =?utf-8?B?eHl2RENPeG1rTGg1bmtSNlVZTnNwcGhLUFVJZzBIWkJMN2tES3pkNER6akhX?=
 =?utf-8?B?RVB3Rml5VVBVZCt4TjcxTE1EeS91Rzh2aGZYTnVlbmJyWHFoZWRGbTdmblJB?=
 =?utf-8?B?Mys0N2t1V2NNVnluNWtvS0QzMENIeXF1KzlQTmh2MDBwVU9TdXpNclI2aWly?=
 =?utf-8?B?NjBpaVBscDFzelk2NnpheXdpanhKaHVHQ09DZVpCdnd0UDIwME5wVUVaZXlq?=
 =?utf-8?B?QUxzK2V5Zzh0cWkyRk1FbE1FTU9jV0hXbGVxZ3VXdWFIZVFwSHJqREhKaGZK?=
 =?utf-8?B?UmhKcnVTYjIzTE5nT2pCTWcvbHEvTi9qUVl1VkRrSE1RZzdrU2FTOG9yWHVM?=
 =?utf-8?B?WEcyamR2SkhzTHFKZzhBTDcwcnZlTXBrem53QWJZWVFvYjJERlFsUGwwZVpD?=
 =?utf-8?B?ZUFtS3A2UzFNVkNWQnYxeFgzeithWmlTS1dGUVk0WkMxdjVMWG14ZnhIM3Jh?=
 =?utf-8?B?TmxjS0VaNlo5N1RocFJRVVFuUkxuQVJLYnFWdWwrRFhxVXY5bUFUU3VSSmFY?=
 =?utf-8?B?RHhKZVhtU0VERzZBaVNKNUNleWludU9oL1d6dTBHVEN2YkQranhwMkVEVFNW?=
 =?utf-8?B?VnJ5N08yVHJidHZYd2tHN0ZmWkpRbGZOajFsWDdSSGtLS041UTUwbEF6d09E?=
 =?utf-8?B?a1NRWlZYbk8ySTF0a1MrWFRpVENjQ25URkZhU1ROZ1kzZ0tJWnVlZTM1WlhI?=
 =?utf-8?B?d3RZTkl0OXNTSGg4QllnaWxVUHBDeExVcE5TYmd2a1dPd0puc3V4b1QzTVdi?=
 =?utf-8?B?Yi9xNWlxYlJDQ3lyUWFNU1dOT2xrQWpSc0IrMmtiVTBrSDdsekNPQ3EvU2JE?=
 =?utf-8?B?azMycEIyZldqVVVhcHRPV0VVemg3ZTBnNWlTMHc2QTd6ZUtJWGdlUmcwSXRR?=
 =?utf-8?B?aDZVYkdtZy9TOWg1UnhWcjdaWmE2SHptRkxXdW53Y1k1QTZDSzVuRVV5YlJH?=
 =?utf-8?B?NHliWk82OFUwS0FXV0lUVnBzcXlCYVg5THhBOTYzdVZobFhEOFRHN3dFZEg0?=
 =?utf-8?B?MUFuaW1VT2gvRjFpeGo4cU5XTllNbUowakJaU1B0WVhXOGtsb2FMZFZxU0RN?=
 =?utf-8?B?RG1aNVhwV1VFSWNsSXNuSlVtZ25CQXJkazVZYjZQVmVWTHJFYlhJNFlra3lr?=
 =?utf-8?B?dGUyWXZmSmg2a0FIZVNXc2JRZ0JnZUVaNlRObWg0YUJaeVV3bXRpSWRKQi9o?=
 =?utf-8?B?RVk2eGtlY1ZKYzhWYmU3QkdhNzRzS3l6ZE9JWGYzaGNNSFAxWlpoR2kyU2h3?=
 =?utf-8?B?VFhQQWFuUkJ0bVBaa045RTlJbUVOZWVYR2RKMllFTU9CS1c3T3k0SjJIdGxw?=
 =?utf-8?B?dE9nRU1qVnZHeXFHWkRLeDZ2NzRzazRTN0s5MmluVmx0YXliaTdGRzUzR0cy?=
 =?utf-8?B?YzltbHQ3bEVZR05JV3NZTXJrSXZXUEd0U2N5NVdFcFAyV3U4MkxsWmJ6Rnc2?=
 =?utf-8?B?ZFFyRTRKYnhjN0I2R3laVDBXTUxZNlp0bzE1RElpVTIrRWx2SzhXY0pSV2pK?=
 =?utf-8?B?TGxtdVNxTDk5VGg3ZWxvb0w0UlAzVWRjR1ZCZ0FhSm5FQVhGR3NsbFJaejlv?=
 =?utf-8?B?RVJqNlpiMTZ0UFhjelBrbGN4SUR6RjBkL216dXJPdFM5dkx3dmR2Z3luZ2d1?=
 =?utf-8?B?TXE3Z0I5bDY2Y1o0aWh5ZjFuOWJyVUZCcnl3aWFrc1orQ1hXLzN1TlAxT1p0?=
 =?utf-8?B?eWs1cDZNMkYwVys3VjFJS1JOTFBQVk10aENJbW5uQzlLVjZmL3VzTHNXNVVW?=
 =?utf-8?B?Sk5ndW12OTZ0SzN1VUFNdWU0WXRYc0dtc0gyeUl0TGt5UVg5UjN1UzV4MW1W?=
 =?utf-8?B?R0FBcmRFbmZKTkYwRHRPSjZjaFZwZVFrT3RpVUlWNDhxVGhtTzBaVXhibmZ2?=
 =?utf-8?B?Z1h2OW5DT1k1Rk1wMklIUEgxQUo3T09pMkRULy9vaDZONjQ2OThzY0l4bUhB?=
 =?utf-8?B?V3BvSUtyNDBlNXpLcm9JS21IUzJiRE44aFRYNDRTOFJBdHp5QUdmYk9ndmMz?=
 =?utf-8?B?ZkY1NUNCeVA0bDVNeHBDczl0OUV4TGROakxrWmdmc2U5T3FvR1NPTnE4WHJE?=
 =?utf-8?Q?5toDzojE7dYnFBIkiZ14p2s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BDEED35E6CA9F4381A99F835C3ED7CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d90393-8cb9-4ed1-33c4-08dc74f2d610
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 15:22:30.2040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2SsL4AtcjV8LO5BHMUdBbtjZ6w85HW8yNZiiYOtMNPu5/EA4X5cbAlWLdrahIUNSBGCj047IsrRyxUcddrRDqG51rv0CTXDKzHQbLywdP5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6850
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDEzOjI3ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4ga3ZtX3phcF9nZm5fcmFuZ2UoKSBsb29rcyBhIGdlbmVyaWMgZnVuY3Rpb24uwqAgSSB0aGlu
ayBpdCBtYWtlcyBtb3JlIHNlbnNlDQo+IHRvIGxldCB0aGUgY2FsbGVycyB0byBleHBsaWNpdGx5
IGNoZWNrIHdoZXRoZXIgVk0gaXMgVERYIGd1ZXN0IGFuZCBkbyB0aGUNCj4gS1ZNX0JVR19PTigp
Pw0KDQpPdGhlciBURFggY2hhbmdlcyB3aWxsIHByZXZlbnQgdGhpcyBmdW5jdGlvbiBnZXR0aW5n
IGNhbGxlZC4gU28gYmFzaWNhbGx5IGxpa2UNCnlvdSBhcmUgc3VnZ2VzdGluZy4gVGhpcyBjaGFu
Z2UgaXMgdG8gY2F0Y2ggYW55IG5ldyBjYXNlcyB0aGF0IHBvcCB1cCwgd2hpY2ggd2UNCmNhbid0
IGRvIGF0IHRoZSBjYWxsZXIuDQo=

