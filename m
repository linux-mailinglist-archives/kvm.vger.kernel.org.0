Return-Path: <kvm+bounces-14256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4414B8A161B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 15:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 667151C21E29
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 13:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1255E14F9D0;
	Thu, 11 Apr 2024 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eoys4ls1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E49C1EB26;
	Thu, 11 Apr 2024 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712842793; cv=fail; b=fRHsuQHSUIRjCb2rftf6BdeMg5rmlwfUcwl1NGcUleD62icM68Jl1ZG7jWvtCZbhC/VTdu+O2axtXwT9K3Q9/f3SfDj8CGlkJoynIHZyMDPNgt/iINEvCNGLK+4bXmJFFyw+ACx+0L/7S54DvgXt6SLmspkVqyNCvRqMl4loV/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712842793; c=relaxed/simple;
	bh=gopbjXQQ3vXvJtQlq/U253WKGApacCkg27RoLn3vNIE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tOGKpywd3aiv2P8zngBWkJvuCms+LirzVxwNSoELVjodO9p5o3okhkNAQSdLX09uPzSCMSp88D1h8VOPnLN/t+Zzw0GdZPov5rX3xMNk8MJdWlZR3VLIOztkxLuIq+bK4JWE3ubHs4HimBwctVPTsPN/rMhwuGM7taciZ3e72So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eoys4ls1; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712842791; x=1744378791;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gopbjXQQ3vXvJtQlq/U253WKGApacCkg27RoLn3vNIE=;
  b=eoys4ls1n2v9Ba0pTe72meVifhjyJIPzTD4API90WI+vc/9dPs2e/m6t
   F+wpaTb30Ov9lmcdP6iABYDhqK2LibO2gwF1ua2bLzkHBP251JgFxUl0z
   0vFigEnYMRWM+8Tkp8RKqarRFmQhL19x8+hQalhTN2jPYXLmy6x/s5ueX
   dXV5n8sXskojUjI0Br2EHA/IfHmjA3toa7NL38rboc9PUmg12yjIhCO9a
   en/LCg1tzuHCQNnAj9r+OAhLblkjdg6tqMIczu7lrY8YzQYffssbmD+qQ
   BPNsMZyDAzy6B9dbLc315yYIJIwvNwM15Iesi0TU7PfBE4epnyVhuNDbG
   Q==;
X-CSE-ConnectionGUID: lXIy/qjzQD6wyz1L9NDqFg==
X-CSE-MsgGUID: nsc4IuHjTJeUWeuust1DlQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="25705918"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25705918"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 06:39:50 -0700
X-CSE-ConnectionGUID: qHhjdnX0Tl+XgsQhLHmAKQ==
X-CSE-MsgGUID: XK7eWrptQLq0o+3wv+3hvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="25372663"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 06:39:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 06:39:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 06:39:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 06:39:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DspQCmiP492cp78dWXXQqDzh8fpZrWByMO1VkrRxtry+ZuLDX7huYOv0blQdM7vNVmqoUmUNh/cgOa63M3zKHSnGu1XOnXyMlSnVUrgJfzG2vcvx9EEibR2pdxw7e093JC2ACoNu0k4+fFbyNDRnaKHqGnP1w7bGTDcxn9+w7k5jOJbcWXXwyCIo6FyIubsymgNxZowNoIUDpeiOfoxsY0RnY2TqPT7WSleAa2h8RTjvj3u1LY5DUDzEhkC5AtRM0mjs1IV9Ek2puCW/LTZnncDEb5zZhdJz6MsoAbTsnJm6lYYgK8s2RV+gHlxonUTMm5Js1ejJUD4wMp6e9xOhkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gopbjXQQ3vXvJtQlq/U253WKGApacCkg27RoLn3vNIE=;
 b=jW3S5t+zHAMGI4X2NFFv5yJWMs8Rlw6BFfY6fTeQYfXlI43uLpZue+PGWQiYxeGRTqxOdl3l9bQIdj2e1XSstUqTi9E568iOk0zKKwbwvfc/mz92KXcGnAjtcZkZIYXMnqfUT28Y/R3TPMhoeR8W8puVBTmZ569FuxIB4XPebcPW0kYBxoKZweFhaQmInU6YTZhDYF498M5vgB7g1JGmE5l2/ad1EDmtgCq7FF1VBHrpoDxRYU6ifhK0Dx5OQbUB1mQUOlY+PkJjz7XYX1dGUof9ZtS4tGF0U+2Xdtk2vHYAra0bMGr42xTs2g4QBYThnahpAFxmrCAuninBfg7c1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7615.namprd11.prod.outlook.com (2603:10b6:510:26e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Thu, 11 Apr
 2024 13:39:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 13:39:47 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Wang, Wei W"
	<wei.w.wang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qR2Nu/69AJukeQby+vmb9H27FcJJkAgAJt44CAABa1gIAAE28AgAH8yACAANdXAIAAuIgAgAAtiACAAKWoAA==
Date: Thu, 11 Apr 2024 13:39:46 +0000
Message-ID: <92cb5115e1ab70e0149b686b6166eb4557fb818f.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <20240410011240.GA3039520@ls.amr.corp.intel.com>
	 <1628a8053e01d84bcc7a480947ca882028dbe5b9.camel@intel.com>
	 <20240411010352.GB3039520@ls.amr.corp.intel.com>
	 <20240411034650.GC3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240411034650.GC3039520@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB7615:EE_
x-ms-office365-filtering-correlation-id: 01a49435-4ae7-41f5-8668-08dc5a2cda78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 41HtlAsq3CrGYZFgBdKRDbed6NQxZzcZFVRNvg5Mt58FBvO8EBHXccKm2FSbtMuRNP+PhGe3nh79YsW92rfk8/Gffm+Cjy8FoLdjBYxa1l5d77JBUvsoLNlAqQm4L90WCQRlJsiinYlH2xqiVJ1gSaV2RczdAHDff8is5/w8a2Ey3aKJKJOyj/pHB8FxpIIWXB0OypUAFWva4+/nbMmcsssmd3MXBRdBTzJy1hmw2ycoZEWrn2++qhkznUhrF+GrIHzbX5tYga8lpkj81m0X24uhEq0imcD6p2EL+1r7Khl8p111IQclO3qW/QzDn3BuNdHhQYQkpp2jdXvoYo0SnqPYlLli5b7cv+P4zYgSXJiv8SwZtbaNdfNSHqvWXGFQWFLiKnj8allDG5HLrOeO9ZKt2O6MqgvqpNsAoHbjmlE91LEngIQzRlOq3HuJwYYDVR1ivq+a8g+C7aZat2T02p7Ztn2bE4n+ynMxn/ePlEC3pJ6r11c+EU1iUTf+c71dfwpaiElhrK5O5cLGm/eQDWkHdDeYhw1pM0uv4LKzmSS0c9+2xcTToZJuseb7n9LTpkxWBPlDydb3JlQpMXGaaHwbYAwNKGRO/LhR+Zh1/cOEqpUEwBZimoUhEr4hVwhk23CPWUiMd0k833vp1zGbQVzlHU1XIlLbirpAU2A68AQk7qNl+4di9xZppRsdFQSvJCCFaDujfYyojPHxJttZqcJcGGlGk7AmsOUqrStch18=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0tXa1JlcFJSd2NNaW5XVTBMWnlhK3czc05YbXd0THh6Z1VMWFNqdVY5bmFk?=
 =?utf-8?B?eFowaFc3cWJRSGM4SFFrc2l5UHRuWUc3YTNPWUFiZW8ybVNDYmg3bHdoUUZI?=
 =?utf-8?B?M3MrN3B0WVpOWGRDcWVXYy9iMVkyU3RRRFF4ay9KMlY2dXhaTjRKUE1scmdU?=
 =?utf-8?B?NEFGcXR0RGYzRzk3c1B6eFJnQnc0T3lGNzR2ZkVYbUFqRTBPYU5XVDFOME5L?=
 =?utf-8?B?WUJXbSs3anlCS1g4RUJyTk9iRm1HRFlHSlJ6bjV1VnRKVjlEOFZnb2xyS2hG?=
 =?utf-8?B?NnRSRitBbVpoekx5aVVhM1A0QisvbFZXYlRLQkdVd3V3T1JiUFVjQkxFTzhW?=
 =?utf-8?B?NDNwWmlzM2l3cGJNblUrQ0hXKzZYcXJjSUJXTDIwSlhXQVdGbTBuSm5ZRlhV?=
 =?utf-8?B?cEpaRk84b2RNYk5lRW5vVC9DZmFlVU9pbGRQTW1GVnc1M2U3SlpXVDlmNzBx?=
 =?utf-8?B?dEJ6WVIrMVBieWFnMXloMUhCQnRaaWFXOE9Na1lYRDNMTXBUeWRqTHlKa2E1?=
 =?utf-8?B?SExrVTBTZ3ZnSnhNL0ZhaWsycEIvVnVsT3hVY2tMRnlGVlpwS0EwUWNMV3JO?=
 =?utf-8?B?QnZPVDBEQjdKcGlpNE1FT1JOYkY0T0Q2a0dVbWxsOXcvMkF5OHZYeDRRY213?=
 =?utf-8?B?TDJURDZ4a2dkQ2NGSytoWmo5R2xROUgwNGRvRWdLVVlsSktlNC9RTjA4dkYw?=
 =?utf-8?B?L1AyamNOcXpKUzJoeitSRnNwVWNsdzcrTGNqSTBHSE1hTVlvR0s3QUM3OXpP?=
 =?utf-8?B?Y1NEanAvNDIxMnpvaGlUVVVZbnBsU0M1UVRadEh0eE9sS3ZYTmNsOGZUTmh0?=
 =?utf-8?B?WmJ6NnRJYVMyaGRGVmhTYzdZZXFDUFNHMnhWVU9lN2ZDeGV4ZkZ5VWxRYWha?=
 =?utf-8?B?cHo5WU14NWt5QnFUTC9DeTZ2V0NyUzc3UHBKK3A4cVJJdkVNVWVLTGViayty?=
 =?utf-8?B?TGhjN0hOek42REJyVG9hb2lRV3lCalZhV21DbWs5OUhmcVF6WFZZbnoraVZh?=
 =?utf-8?B?V3pTeW1lNGVLMXJST05VMS9nQlpVWEFjNUF3NjhmU0Y3eHZXN0ZjblIwczky?=
 =?utf-8?B?Tk80YzZ0NndmOVEzTEEvbWdFdUFwZjdORkg3MytoS0wrK0V5YjczMWk3SGVN?=
 =?utf-8?B?NjRvallLekRpdFdsM0VKM2kzaWhRakMzVjlnSE8yQ1hPMzFTR3l6akRGdHYw?=
 =?utf-8?B?azZUYVR5S2hxWWVUN200UFI5bjNrZkVEcDFRb0RBMlh6MFpXTVlEaCtCWmx2?=
 =?utf-8?B?dHdWMmRaeHhOclNNcEY0U3NpWm9LSDZZM3AxdEZROStkc0JJc3dYVjdWKzAv?=
 =?utf-8?B?dWgrSnZpQnhOOXk3dmx1ekwrNUQ4REJkdDZucjQ4bHoyRkhpV1psdWFJQmd1?=
 =?utf-8?B?VEdYOXdWeFNJbzJFak94OW9uSWQ4d2wwMkw5UVVNbnUrM2hUekRmTG1rUWUz?=
 =?utf-8?B?NWhnVkpwNjdKbEVCNnpkWVBwUGtoc0QxM2JwWGsyd2JsYjNMVmxqUFp2aDdm?=
 =?utf-8?B?bVBzSkhqZDExNDlqckg3T1pvYUNzUXNLTElSQTlNZTNUQ1AzMnV4T2VkT1I1?=
 =?utf-8?B?QmtEYWdqdUljUldYbUtkSUFWZGtUNjl0dDgyWHcveTVrdVVpM05FeCtRWWtO?=
 =?utf-8?B?TU5pWlNwMVV2eFVpS0ZZS2ptcE5BcHVXMllGNFZJY1U0Q2ZabndyUCt5Unc4?=
 =?utf-8?B?SXhaVEZlaXllbHhyc2J1dHh5b2JXbUczSGcrQzllUzdwUENGRW5TdGUvcU5h?=
 =?utf-8?B?TS8rRFZtS1JMYTJHcnJCNmxjSlFidWQ1Mk55RFQyN2ZBTXRxeTI3YjJlUHBB?=
 =?utf-8?B?bFh1akFhM204WmlQWGZUdCtTTW4xRFpCVHEzblhtRDAvT2V3LzZSWE1YSDlH?=
 =?utf-8?B?UzZjcnN3cURYZWlLUzJMR2M3dEg2aFhkTXhoYmwyTFhEVEtGTGlld2JrOUxq?=
 =?utf-8?B?Tm5YMDYxZVprWEdOaVdUTHhJTHBwN0d2OWlIdDlkYlhqUU1xSHduVFRFVjNJ?=
 =?utf-8?B?R2ZCYm10bXRVYjFoUDNXZDRLVnhwTmhBS1QySWJmY2ZLR3hhSVhwdkdtb013?=
 =?utf-8?B?RHJKYTRYaHhmZ2lIN1VSa3NicjY4RFkxczVBTVNRNHl6SndSOVBLTWFyMTlq?=
 =?utf-8?B?SnBJZWZuN3hjODNJZThkMDcySnpkSlZWZWJVYytSd1dpZyt0UnBNeWdObkhn?=
 =?utf-8?B?a1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EF515E5641A644AA8555EDCE8D07685@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a49435-4ae7-41f5-8668-08dc5a2cda78
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 13:39:46.9669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZoXVS9HbLxN0F33zTvUDsKizplOOea6jdBydS+mcDwLhNe0mps/Qw/0TgeNiJpRsQtnmOzc0xsSeiSbIevUoXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7615
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDIwOjQ2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBBcHIgMTAsIDIwMjQgYXQgMDY6MDM6NTJQTSAtMDcwMCwNCj4gSXNha3UgWWFt
YWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KPiA+IE9uIFdlZCwg
QXByIDEwLCAyMDI0IGF0IDAyOjAzOjI2UE0gKzAwMDAsDQo+ID4gIkh1YW5nLCBLYWkiIDxrYWku
aHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiANCj4gPiA+IE9uIFR1ZSwgMjAyNC0wNC0wOSBh
dCAxODoxMiAtMDcwMCwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+ID4gPiA+IE9uIE1vbiwgQXBy
IDA4LCAyMDI0IGF0IDA2OjUxOjQwUE0gKzAwMDAsDQo+ID4gPiA+IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gPiA+ID4gDQo+ID4gPiA+ID4gT24gTW9u
LCBBcHIgMDgsIDIwMjQsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+ID4gPiA+ID4gT24g
TW9uLCAyMDI0LTA0LTA4IGF0IDA5OjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3Rl
Og0KPiA+ID4gPiA+ID4gPiA+IEFub3RoZXIgb3B0aW9uIGlzIHRoYXQsIEtWTSBkb2Vzbid0IGFs
bG93IHVzZXJzcGFjZSB0byBjb25maWd1cmUNCj4gPiA+ID4gPiA+ID4gPiBDUFVJRCgweDgwMDBf
MDAwOCkuRUFYWzc6MF0uIEluc3RlYWQsIGl0IHByb3ZpZGVzIGEgZ3BhdyBmaWVsZCBpbiBzdHJ1
Y3QNCj4gPiA+ID4gPiA+ID4gPiBrdm1fdGR4X2luaXRfdm0gZm9yIHVzZXJzcGFjZSB0byBjb25m
aWd1cmUgZGlyZWN0bHkuDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gV2hhdCBk
byB5b3UgcHJlZmVyPw0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gSG1tLCBuZWl0aGVy
LsKgIEkgdGhpbmsgdGhlIGJlc3QgYXBwcm9hY2ggaXMgdG8gYnVpbGQgb24gR2VyZCdzIHNlcmll
cyB0byBoYXZlIEtWTQ0KPiA+ID4gPiA+ID4gPiBzZWxlY3QgNC1sZXZlbCB2cy4gNS1sZXZlbCBi
YXNlZCBvbiB0aGUgZW51bWVyYXRlZCBndWVzdC5NQVhQSFlBRERSLCBub3Qgb24NCj4gPiA+ID4g
PiA+ID4gaG9zdC5NQVhQSFlBRERSLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBTbyB0aGVu
IEdQQVcgd291bGQgYmUgY29kZWQgdG8gYmFzaWNhbGx5IGJlc3QgZml0IHRoZSBzdXBwb3J0ZWQg
Z3Vlc3QuTUFYUEhZQUREUiB3aXRoaW4gS1ZNLiBRRU1VDQo+ID4gPiA+ID4gPiBjb3VsZCBsb29r
IGF0IHRoZSBzdXBwb3J0ZWQgZ3Vlc3QuTUFYUEhZQUREUiBhbmQgdXNlIG1hdGNoaW5nIGxvZ2lj
IHRvIGRldGVybWluZSBHUEFXLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE9mZiB0b3BpYywgYW55
IGNoYW5jZSBJIGNhbiBicmliZS9jb252aW5jZSB5b3UgdG8gd3JhcCB5b3VyIGVtYWlsIHJlcGxp
ZXMgY2xvc2VyDQo+ID4gPiA+ID4gdG8gODAgY2hhcnMsIG5vdCAxMDA/ICBZZWFoLCBjaGVja3Bh
dGggbm8gbG9uZ2VyIGNvbXBsYWlucyB3aGVuIGNvZGUgZXhjZWVkcyA4MA0KPiA+ID4gPiA+IGNo
YXJzLCBidXQgbXkgYnJhaW4gaXMgc28gd2VsbCB0cmFpbmVkIGZvciA4MCB0aGF0IGl0IGFjdHVh
bGx5IHNsb3dzIG1lIGRvd24gYQ0KPiA+ID4gPiA+IGJpdCB3aGVuIHJlYWRpbmcgbWFpbHMgdGhh
dCBhcmUgd3JhcHBlZCBhdCAxMDAgY2hhcnMuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBPciBh
cmUgeW91IHN1Z2dlc3RpbmcgdGhhdCBLVk0gc2hvdWxkIGxvb2sgYXQgdGhlIHZhbHVlIG9mIENQ
VUlEKDBYODAwMF8wMDA4KS5lYXhbMjM6MTZdIHBhc3NlZCBmcm9tDQo+ID4gPiA+ID4gPiB1c2Vy
c3BhY2U/DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhpcy4gIE5vdGUsIG15IHBzZXVkby1wYXRj
aCBpbmNvcnJlY3RseSBsb29rZWQgYXQgYml0cyAxNTo4LCB0aGF0IHdhcyBqdXN0IG1lDQo+ID4g
PiA+ID4gdHJ5aW5nIHRvIGdvIG9mZiBtZW1vcnkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBJ
J20gbm90IGZvbGxvd2luZyB0aGUgY29kZSBleGFtcGxlcyBpbnZvbHZpbmcgc3RydWN0IGt2bV92
Y3B1LiBTaW5jZSBURFgNCj4gPiA+ID4gPiA+IGNvbmZpZ3VyZXMgdGhlc2UgYXQgYSBWTSBsZXZl
bCwgdGhlcmUgaXNuJ3QgYSB2Y3B1Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEFoLCBJIHRha2Ug
aXQgR1BBVyBpcyBhIFZNLXNjb3BlIGtub2I/ICBJIGZvcmdldCB3aGVyZSB3ZSBlbmRlZCB1cCB3
aXRoIHRoZSBvcmRlcmluZw0KPiA+ID4gPiA+IG9mIFREWCBjb21tYW5kcyB2cy4gY3JlYXRpbmcg
dkNQVXMuICBEb2VzIEtWTSBhbGxvdyBjcmVhdGluZyB2Q1BVIHN0cnVjdHVyZXMgaW4NCj4gPiA+
ID4gPiBhZHZhbmNlIG9mIHRoZSBURFggSU5JVCBjYWxsPyAgSWYgc28sIHRoZSBsZWFzdCBhd2Z1
bCBzb2x1dGlvbiBtaWdodCBiZSB0byB1c2UNCj4gPiA+ID4gPiB2Q1BVMCdzIENQVUlELg0KPiA+
ID4gPiANCj4gPiA+ID4gVGhlIGN1cnJlbnQgb3JkZXIgaXMsIEtWTSB2bSBjcmVhdGlvbiAoS1ZN
X0NSRUFURV9WTSksDQo+ID4gPiA+IEtWTSB2Y3B1IGNyZWF0aW9uKEtWTV9DUkVBVEVfVkNQVSks
IFREWCBWTSBpbml0aWFsaXphdGlvbiAoS1ZNX1REWF9JTklUX1ZNKS4NCj4gPiA+ID4gYW5kIFRE
WCBWQ1BVIGluaXRpYWxpemF0aW9uKEtWTV9URFhfSU5JVF9WQ1BVKS4NCj4gPiA+ID4gV2UgY2Fu
IGNhbGwgS1ZNX1NFVF9DUFVJRDIgYmVmb3JlIEtWTV9URFhfSU5JVF9WTS4gIFdlIGNhbiByZW1v
dmUgY3B1aWQgcGFydA0KPiA+ID4gPiBmcm9tIHN0cnVjdCBrdm1fdGR4X2luaXRfdm0gYnkgdmNw
dTAgY3B1aWQuDQo+ID4gPiANCj4gPiA+IFdoYXQncyB0aGUgcmVhc29uIHRvIGNhbGwgS1ZNX1RE
WF9JTklUX1ZNIGFmdGVyIEtWTV9DUkVBVEVfVkNQVT8NCj4gPiANCj4gPiBUaGUgS1ZNX1REWF9J
TklUX1ZNIChpdCByZXF1aXJlcyBjcHVpZHMpIGRvZXNuJ3QgcmVxdWlyZXMgYW55IG9yZGVyIGJl
dHdlZW4gdHdvLA0KPiA+IEtWTV9URFhfSU5JVF9WTSBhbmQgS1ZNX0NSRUFURV9WQ1BVLiAgV2Ug
Y2FuIGNhbGwgS1ZNX1REWF9JTklUX1ZNIGJlZm9yZSBvcg0KPiA+IGFmdGVyIEtWTV9DUkVBVEVf
VkNQVSBiZWNhdXNlIHRoZXJlIGlzIG5vIGxpbWl0YXRpb24gYmV0d2VlbiB0d28uDQo+ID4gDQo+
ID4gVGhlIHY1IFREWCBRRU1VIGhhcHBlbnMgdG8gY2FsbCBLVk1fQ1JFQVRFX1ZDUFUgYW5kIHRo
ZW4gS1ZNX1REWF9JTklUX1ZNDQo+ID4gYmVjYXVzZSBpdCBjcmVhdGVzIENQVUlEcyBmb3IgS1ZN
X1REWF9JTklUX1ZNIGZyb20gcWVtdSB2Q1BVIHN0cnVjdHVyZXMgYWZ0ZXINCj4gPiBLVk1fR0VU
X0NQVUlEMi4gIFdoaWNoIGlzIGFmdGVyIEtWTV9DUkVBVEVfVkNQVS4NCj4gDQo+IFNvcnJ5LCBs
ZXQgbWUgY29ycmVjdCBpdC4gUUVNVSBjcmVhdGVzIFFFTVUncyB2Q1BVIHN0cnVjdCB3aXRoIGl0
cyBDUFVJRHMuDQo+IEtWTV9URFhfSU5JVF9WTSwgS1ZNX0NSRUFURV9WQ1BVLCBhbmQgS1ZNX1NF
VF9DUFVJRDIuICBRRU1VIHBhc3NlcyBDUFVJRHMgYXMgaXMNCj4gdG8gS1ZNX1NFVF9DUFVJRDIu
DQo+IA0KPiBUaGUgdjE5IEtWTV9URFhfSU5JVF9WTSBjaGVja3MgaWYgdGhlIEtWTSB2Q1BVIGlz
IG5vdCBjcmVhdGVkIHlldC4gIEJ1dCBpdCdzIGNhbg0KPiBiZSByZWxheGVkLg0KDQpPSy4gIFNv
IGluIGN1cnJlbnQgaW1wbGVtZW50YXRpb24gS1ZNX1REWF9JTklUX1ZNIG11c3QgYmUgZG9uZSBi
ZWZvcmUNCktWTV9DUkVBVEVfVkNQVS4NCg0KV2hpY2ggc2VlbXMgbW9yZSByZWFzb25hYmxlIGNv
bmNlcHR1YWxseSwgSU1ITy4NCg0KRG9pbmcgS1ZNX1REWF9JTklUX1ZNIGFmdGVyIEtWTV9DUkVB
VEVfVkNQVSAod2VsbCBLVk1fU0VUX0NQVUlEMiBhY3R1YWxseSkgbG9va3MNCm1vcmUgbGlrZSBh
IHdvcmthcm91bmQsIGFuZCBpdCBpc24ndCBzdWZmaWNpZW50IGFjdHVhbGx5LCBpZiB3ZSB3YW50
DQpLVk1fVERYX0lOSVRfVk0gdG8gdXNlIHZDUFUwJ3MgQ1BVSUQuDQoNCkZvciB0aGF0IHdlIG5l
ZWQgdG8gZXhwbGljaXRseSBzYXk6DQoNCktWTV9URFhfSU5JVF9WTSBtdXN0IGJlIGNhbGxlZCBh
ZnRlciBLVk1fU0VUX0NQVUlEMiBpcyBjYWxsZWQgZm9yIHZDUFUwLg0KDQpXaGljaCBpcyBraW5k
YSBvZGQgYmVjYXVzZSBBRkFJQ1QgdXNlcnNwYWNlIHNob3VsZCBiZSBhYmxlIHRvIGxlZ2FsbHkg
ZG8gDQpLVk1fU0VUX0NQVUlEMiBpbiByYW5kb20gb3JkZXIgYWxsIHZDUFVzLg0KDQpJbiBvdGhl
ciB3b3JkcywgbWFraW5nIEtWTV9URFhfSU5JVF9WTSB1c2UgdkNQVTAncyBDUFVJRCBsb29rcyBt
b3JlIGxpa2UgYQ0Kd29ya2Fyb3VuZCwgYW5kIGl0IGlzIGEgbGl0dGxlIGJpdCBvZGQuDQoNCldo
ZW4gc29tZXRoaW5nIGxvb2tzIG9kZCwgaXQncyBlcnJvci1wcm9uZS4NCg0KQSBsZXNzIG9kZCB3
YXkgaXMgdG8gbWFrZSBLVk1fVERYX0lOSVRfVk0gbXVzdCBiZSBjYWxsZWQgYWZ0ZXIgS1ZNX1NF
VF9DUFVJRDIgaXMNCmNhbGxlZCBmb3IgX0FMTF8gdkNQVXMuICBJdCdzIF9sb29rc18gYmV0dGVy
LCBidXQgaW4gcHJhY3RpY2UgSSBhbSBub3Qgc3VyZSBLVk0NCmlzIGFibGUgdG8gZG8gc3VjaCBj
aGVjay4NCg0KQWxzbywgYmVjYXVzZSBDUFVJRCBpcyBqdXN0IG9uZSBwYXJ0IG9mIHRoZSBLVk1f
VERYX0lOSVRUX1ZNLCB0byBtZSB3ZSBhbHNvIG5lZWQNCmFzayBxdWVzdGlvbnMgbGlrZSB3aGV0
aGVyIGl0IHNob3VsZCBiZSBkb25lIGFmdGVyIG90aGVyIHZDUFUgSU9DVEwoKXMgKGUuZy4sDQpL
Vk1fU0VUX01TUiBldGMpIGJlY2F1c2UgdGhlcmUgYXJlIG1vcmUgdGhhbiAxIElPQ1RMcygpIHRv
IGluaXRpYWxpemUgdkNQVSBmcm9tDQp1c2Vyc3BhY2UuDQoNCkFnYWluLCBhbHRob3VnaCBwcm9i
YWJseSBhbGwgb2YgYWJvdmUgaXNzdWVzIGFyZSB0aGVvcmV0aWNhbCB0aGluZywgdG8gbWUgbG9v
a3MNCml0J3MgYmV0dGVyIHRvIGp1c3QgbWFrZSBLVk1fVERYX0lOSVRfVk0gbXVzdCBiZSBjYWxs
ZWQgYmVmb3JlIGNyZWF0aW5nIGFueQ0KdkNQVS4NCg0KRm9yIENQVUlEKDB4ODAwMF8wMDA4KSwg
d2UgY2FuIHJlcXVlc3QgS1ZNX1REWF9JTklUX1ZNIHRvIHBhc3MgaXQsIGFuZCBLVk0gY2FuDQpn
ZXQgR1BBVy9ndWVzdC5NQVhQSFlBRERSIGZyb20gaXQuICBLVk0gd2lsbCBuZWVkIHRvIGNvbnZl
cnQgdGhpcyBDUFVJRCBlbnRyeSB0bw0Kd2hhdCBUREguTU5HLklOSVQgY2FuIGFjY2VwdCwgYnV0
IHRoaXMgaXMgd2hhdCBLVk0gbmVlZHMgdG8gZG8gYW55d2F5IGV2ZW4gaXQNCnVzZXMgdkNQVTAn
cyBDUFVJRC4NCg0KU2VhbiwgYW55IGZlZWRiYWNrPw0KDQoNCg0KDQo=

