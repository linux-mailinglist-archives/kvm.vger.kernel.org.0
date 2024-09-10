Return-Path: <kvm+bounces-26432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A2139746FF
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 01:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E46E428351C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 23:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B8E1ABEDB;
	Tue, 10 Sep 2024 23:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOdKAdM+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9671AB52A;
	Tue, 10 Sep 2024 23:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726012183; cv=fail; b=Tm6V0rSUQh++FXFw3SxAc1vxKqWkGnuwUb3Jdwdm7npA0Em7xBN+BgVwpv0UFbNunnEw9uXgVKsVuXVDpaeL1aVoX3jFtHmVzRyLYzaJJDJ7fTsjghzQqLlgz1TzkAJCRLeYi5hQSrvKSPPr9Sd+oirlYLq6GJ/qcKfZu/n8V28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726012183; c=relaxed/simple;
	bh=du07Qf606efiTpXeVXKw5AU59oAjcZiuOjXCiMCRHk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bA7pzkqPnaUCO2tYgM+WEMO3BVqGArL/dszVOjlOgYB1+XsUGPTc/85ZfjJiN0i1+l5zFFZ2dmWQNi76Y61WuyLdQ0amFuQ9EEo8SAWTzVlf32XQy0zD+PYVLszlR9tO3aLNviBpnda8lyHa4nwdYYs4k0CGDv8ETr/ZY0pqi4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DOdKAdM+; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726012181; x=1757548181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=du07Qf606efiTpXeVXKw5AU59oAjcZiuOjXCiMCRHk8=;
  b=DOdKAdM+w11VfHcC1tnUjIwdYqVsaKO1nEBJFY58+x0JWpDEtZIa5xhZ
   kCKhjCSAXxovAasz2qu2upciM/cSH+RsjBVf6dc+JbgaPJFdOL4JmnCrO
   hzxKRUY8jcymQkPN38iUpJvJjbDCRPN6buDdcUCjSMRcWb79O+P/E+Ej5
   rnzd5yYUjkfCXIsvsTNl+v/Wphb2avxa9l1eM87QnhGqoNbr9FxQIw/05
   jD3gvZG1nifOYjFuNTWbc2ruc+/LEZ1/wZJDNQjCggR4rruAhBsyJnHlN
   d9I65hHQDrvkI9rSP+8NrysGnOlPhI5/YTHctIP9Z9H+1AZC4fsoh/X3u
   w==;
X-CSE-ConnectionGUID: 9Zd1ykBSTuSuwFw//OFXmw==
X-CSE-MsgGUID: MJGqT6NlRWGqgHlsnDn7CA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="42268393"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="42268393"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:49:41 -0700
X-CSE-ConnectionGUID: EQWnAU54S+GBX6MJkewjkA==
X-CSE-MsgGUID: SEzPS9+vRWSjKsWCQ3G81A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="71803919"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 16:49:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 16:49:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 16:49:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 16:49:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 16:49:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=swiyLkNlvLRbhpPDDJRgllAIZz9BbW8RJRpbkCwFTWkNVfHJmENSJY+F6sYq8zYDdsJG0Km6TAwOj0uQYok+5epQ7Xsuu7P4/3Hlb6VAmJjjYAHCRKK2275vcUs3ede09S3DGT0YjR/m6gxNaariDKjy9bWKwZdbTs7wmPX9ABAvpEJVjmAggTRX1K+zeA+WcjJCWT28sjbivDoEzwHdWHa/tDWfeHmchWgZc11B49xpFvc4rKPvUlAoguDAD5qV63BgKEvYcUX0uKAR3EkZDRfScAd/ri9WAUI/LcSHWxZ1cSQbV0ZP2ULlcHcXd1HlfrCNgsfQttPYN7zOTAg3sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=du07Qf606efiTpXeVXKw5AU59oAjcZiuOjXCiMCRHk8=;
 b=jQYrP3tJUefE/EkClYsnmLzIcXiyBQZdTsgT6Bk/JVl/5JToRNn77yzPJLynDi2v+sQu+j7CYCaQwLppi5S7SnCzh3GOiALg03519I00+JEszJJpMNpg9aYX9516qxvsFB0tl7pztNpAP9WEv1ilR7GX6JFPPb5r1JLrAvUOGkW4YT0VN1PfMaux+aijPFYu6nlI0h9BmzgdlaAVrVgH4yyGBVpC2WSjJRYgLT7Bsx+xaIunczPQ5uJerRPBDK3jB9n+mKKh+ZRKYp4i3+SzoM45u3FuI0T2mh53YIyYlEtQXSK3qECj5nvY5rzagLTKcHOmU2GySpvqAHjeaEfdPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6111.namprd11.prod.outlook.com (2603:10b6:208:3cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 23:49:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 23:49:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Topic: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
Thread-Index: AQHa/neyFCUwVv/2uUaPte14j/ISrrJQtoeAgAEEuAA=
Date: Tue, 10 Sep 2024 23:49:37 +0000
Message-ID: <78e34e6bc4ed89d1168ad492f5ef07039d479470.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
	 <e4ebdfca-fcb8-43fb-a15b-591d083b286f@redhat.com>
In-Reply-To: <e4ebdfca-fcb8-43fb-a15b-591d083b286f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6111:EE_
x-ms-office365-filtering-correlation-id: 23e64108-1bca-4006-b31f-08dcd1f33adf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YVNwdFQ4QWJ2V29MYi95Tml3aWkrMFdxdWV3VUcvWHgvUWNDYWFFVlFIemtq?=
 =?utf-8?B?WEdmNitMODJvUllCS2FTRktVaTlUUDNSMzVuWHRqdXF0K3FQNWczV1BLckV2?=
 =?utf-8?B?K1VNZ1ovY3MyZ2xsY1JDZ1dHUDZpR0FJRFNMWVhzbzhmR0U3dCtESk9YbHA2?=
 =?utf-8?B?VXA0UGxVaHlXRGxEOTQyZUMzSmUydUVaaXZxRWszcmFPS2JzeWlyLzJxRGJN?=
 =?utf-8?B?ckhIMGRrOGNhLzQxcGRjWDhhYzlQSlpJeE1qVVd4TUJNRFBWclVRR0FmWWRH?=
 =?utf-8?B?dnMwbEltdHEyeEUvRGRwemdNcHB3RTJsbTQ5cTJ4U052VHhoc3JHMnJCZE9o?=
 =?utf-8?B?TUh6RU9DWWlTRFhzc21OSlRtRTFIV0huaERsbGg0aDdrUXROaGR6ZjdvOHdQ?=
 =?utf-8?B?bnk0VitXQkxNZk5jMWNvNDFEUFZZTi81Ry9QaEZhMmYwdnZ3MjY5Y0VLYVMx?=
 =?utf-8?B?ajVUNkVvS0YxZnRWN2lkNGczcGtEZndXWlBtNk4zNjFSTjNIc2xyeDBBbDc2?=
 =?utf-8?B?VEFndWx4RGZiWDlNTWdpNFFaUmgzdmxKeTZDWE9sUEk1NEFXSUZSb0RpSUU4?=
 =?utf-8?B?akVMZSt6OUhKRXBVTjY2cGNHM0dXUlFUL3V5YmFvUlJTcGpJencyRFhsUm9m?=
 =?utf-8?B?YSt3bjhzSGd5cUR0QlRYRUx4U2hkY08vRWo1TTIza05LSDNMdXNCbTNkc2xM?=
 =?utf-8?B?WS9XKzR5K2QvQVIzeEdBUU1BdzZ2akx3VXBqNHMwQmxyYWdwT2hzMlhPY2Ir?=
 =?utf-8?B?WStpYVd4bXVvRXdORko4eEZZKzBIZkxJUkJzR1g5WDRadlZWdjBGN2RxVWFz?=
 =?utf-8?B?eElCREN0Zk5wT0h5MlhadDhuMytVYnI4aG1ZSGhSelR1dGwzR1h4WmJ2dlhj?=
 =?utf-8?B?aVFJMTNCSUg0TFNyUzFsWUNaNjJ6SEg3bjNVNFN4NStnb2NwVGxSZitiVm0r?=
 =?utf-8?B?OWFrOHQ0VHZocFM3cDg1eG50MVNMWGhHMllESGVGcnMydFk0UkFUd0I1TEYw?=
 =?utf-8?B?dnFrL3RuNkNvUHBaaDlta2hjZjV1SWdmVnFKcDZKZ3ZtZU93REJuQkIzMFU4?=
 =?utf-8?B?QlQ1amhmMkR0R01qWlBpK2hseFBwb0NEcUJPSnVJTTcyOEQrMEdKR0FhZlFv?=
 =?utf-8?B?NEFYT2lCRE84ZWg4NEVIUEVqVTBwQWl3RkNBOFlralBzSzF1QWdqSHRaRENv?=
 =?utf-8?B?bml4bVZWM0FrMXFoOGsrUUtLRXh1VGZEb3JSOGpRdmNFcWZicVdBZmpTcEh3?=
 =?utf-8?B?Qy9oUFo0R0xIS1BJWVQxbGdVMzEwRmNlTks2V2RkdEtQVlFMcTdvYkpxUFBz?=
 =?utf-8?B?eWFKODFncTBrc0Z3STJkbE1TM21WeGJteURkWXVDYTZLSGJYTVNjL3oyY2Nn?=
 =?utf-8?B?ZnJpWWhmUzNYZWsxa2taTllwelFlbEVSQzE2ZjJhWk42SGIzbGhmMWZKTDdQ?=
 =?utf-8?B?UFJ1aWZXUlg1NGpzR1dDNUhkWmRpenR4c1IrajBZbWpIeHg5TFhRVFEvVjhC?=
 =?utf-8?B?ZGNrV3o1SUtwY1I2UW5oV2lzYVVSZGRTMkJyeWw1VEY5Wk1uSTB5SUhOV2RQ?=
 =?utf-8?B?cDJtNkhXTEEyNnVhbmRaQUgxeWdaeE9YenBTTnhNWE12S2xzcjBHS3k2c1NB?=
 =?utf-8?B?dkcvZllXNE1tbEZsWmVYQ1J0b1kxQU5ZdksxTjAvbnAwdEl1eEl1aE5MQ0xj?=
 =?utf-8?B?TUVlYUtralNqWTZmNm1OWlpjNGc5YW1UNG0zMVFkcTZ6MTFLbDNqL3RUNXpK?=
 =?utf-8?B?YXRYOW5VMldvT1k1MEJwaHJLNEViRHB4WHhQbXo2Ni9KaGhlVDJmN0h1SkNC?=
 =?utf-8?B?dHo5Y1ZGWlVYdTM0V0ttUGJIdHhyemRSZ0xHWkVleTJSLzZYdVAzVkdFVHJ6?=
 =?utf-8?B?TFkrVW9zeU95Ums5Qy9pQUc2cUN4c2RPSXorY3Z3Y2pyeEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3BqTkxMcEtENTN1djd2b1NmcExPYXoyY21nNisvVVV0akNjYlBJYkRXUWVJ?=
 =?utf-8?B?eTlDWUZBSVBTb051cEE1RHBiOENxY1JqSm1BU0VYcTBiTlVCTWxhYTBZQXRW?=
 =?utf-8?B?RjdyRHpVRTZXZTk3Y1dZYndHMVlKY0RBcnZZR1FHVnNxeW5FMERXK2Q0OWt1?=
 =?utf-8?B?T2wyMUw5L0xrbHFJU2Z4UXRWV1ZKVXhHZVY3SStPYk0wWUFtWWEzTGZ2eGw2?=
 =?utf-8?B?SG5ORHdidlNSTGFUeENvb0VVTFdnRzFvSXllOE93RlZMR3I5MzBHSHZjV3Na?=
 =?utf-8?B?N281a1luQUlvRUw1RkV5UWt4cmlUWEYwM2xlT3JFRlFQdmliY3JGdHNkRGJa?=
 =?utf-8?B?Vi9ydnllTHk1dmd6KzlnUURxaWFrejlBdE9BUytDY0p2endubXBTdkVEbnV2?=
 =?utf-8?B?V1J2bDZ5ZHNhRlZuQlJwL0VpMytodnEvODVuOFRuVDlCZjh0R053ZGpZNXZt?=
 =?utf-8?B?K3NodkF0R0RJeDgzTWxZSTVmaURyUEswS1poV2lUa0VLTTZkZzJUalMrZmJm?=
 =?utf-8?B?anFVRnE1c0Uva1VFeHJUanRqVHRoc0ZKbjl6Z1dYT0MrcklEWE1uVzdlRnFQ?=
 =?utf-8?B?Qmt5NHROby9ib2JrTVdrZHFsM3BXZzhvcHhVZHdLeHNWaXcyTDVLQVNVUVpv?=
 =?utf-8?B?Y0xUUVlLWWozKzRIL0hRcFdwU1RaTlZGaVVTeHl1bXN0bVpZYWh4cDJ0eEkx?=
 =?utf-8?B?bS9PTmtwempGUHNLTkhGNDJkVDdzYVQwNVdXSUo0WjJxRHFDQWorZk1tL0Jq?=
 =?utf-8?B?NkNwTHRNK1o5WHdKNWR2Yi93NFl0MzNlQ0dxaTc4VGg2VDJTNlIwcFl1WkJq?=
 =?utf-8?B?RFhEMkFKZXFDQWdmcmhKYWJDL2tvWFFIRXVacnRuYm4yTkZhRFZQaWJKRkd3?=
 =?utf-8?B?anRYdFZkQlEybjlaNU9mQVNTUnFhYWRRdHZLMmgxbENLMTU0d1dGOUwyY05K?=
 =?utf-8?B?Ump2M2g5NHpSZDN1MlZXRE1ISmhBelpONWhYQ3FhTnpacWc1N05BYXZyOGJG?=
 =?utf-8?B?dVN5TXdGaldWaW5nRVRoVjlvQ1JQWlkwOVBmUzZFNlpFdnR6SHdycGhUV2Ny?=
 =?utf-8?B?SjNGSm82N1pLdExUWUJoV1d0N2RaUlA1MjhjaGZZUGx5TmdvcThhOWoxOWI2?=
 =?utf-8?B?Z3YyeDArVHVSRUtGQjNMenozQTBKYVVOWEdvUnhEdGEvSGtRUEV5a1BVcjJJ?=
 =?utf-8?B?TTI3Q21pZTJ6dXduYThtNGp4SHdQSXdJVVBVNWZKTUt5U29iMlMrbUZQeU1W?=
 =?utf-8?B?YzYrOFpNWXNmOTNxTlJOR1paMCtpTmtCdFgxOC9UT09GMDN5b3BKUnB1T0xD?=
 =?utf-8?B?UEtteEJ0a2lRMVkwbFZRVG0vY3h3bkhJRXZNekRxanZYOWhMK2QyakVobE5F?=
 =?utf-8?B?RzZCWitiTFNtaFBURnBEL21GemRraUJSMlJqbEtmM3VNYUJ5WFRkTi9zQnVR?=
 =?utf-8?B?cStCeXhQVXBPMk5ULzU3NFVybm95MmRuWmxUVjdCMWhka0UwTkMyOGlURmMz?=
 =?utf-8?B?RmxHR3dhajhLUVhPblpEZ3VOcWE2Yk9TRmdDYXh6NDNWZ0FneEZnZitRZWVT?=
 =?utf-8?B?SWZyT3duWkpJR29Ia1RmME9NQnpnMnZSSFJ6QXF3anJCbTdMWksyemJrcURH?=
 =?utf-8?B?UHUwQjdMRGljWFhVWTdGWDRRUjRJQWJtQStIRUk1RTdtRENDbUp2MmdJVHUr?=
 =?utf-8?B?MmxwUlk2aU9Ob2VBYXRKcWRwZm9UczBpdEpsVFNlN3JORzIxZzg3MUNLeFRQ?=
 =?utf-8?B?VENLYVBzbEVEcG5raVBsNzZmZmJZVDZZMzJpMFg2ZlJWMWNQanhLWEJreHls?=
 =?utf-8?B?d1dRMEs0bHRUMkR5TDd6MnJsclJkNWtvdVpSWWVMd1ptSFNybVZZd3lwb3Bi?=
 =?utf-8?B?QjJEdUFacmhmWTNjUHRUbWlrbld4Rjh4M2FxMVNUSTRyeEtDMDIyRTRqdmR2?=
 =?utf-8?B?eUNQRVV2K01Ia3dtWlVIVEJlQVA5Sk9raW15ZVdBaGs5NXVxb0ppTmxKUU9v?=
 =?utf-8?B?RFlRcnk2TzhIWmJ5dkR3c0xnRlF0aWNmY0dTRkVaYnFYNW05ckxZZ2VqR0Fx?=
 =?utf-8?B?UWhLV1Q2U2p6QmRsbytOcUdGMmppM3FrblFFWEdGUzFPTXJkdVAzUDRUSnZq?=
 =?utf-8?B?WkNUSmE2OENUek14WTJJUC92czZaTzRnNVFhU09sdjVhQmI2czdGeTQ5MmVm?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <062688A151DA5C49A9961FDFC69DBFC2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e64108-1bca-4006-b31f-08dcd1f33adf
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 23:49:37.4262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VaucVkm+cXR37k8isAOr0Ogfyt6qhMeIM8lNwj9UXUz0aKWIJt4u+w0XCOcfmGrmJ7/eVlnKV5/GedWlFrlk9/ZZjvxar1J9SL0tSGs36vg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6111
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEwOjE2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gSSdkIGRvIGl0IHNsaWdodGx5IGRpZmZlcmVudDoNCg0KRmFpciBlbm91Z2gsIHRoYW5r
cy4NCg==

