Return-Path: <kvm+bounces-49215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D20AAD65C3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:38:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DD111BC190E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6531C7013;
	Thu, 12 Jun 2025 02:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kduyzeyH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AFB80BEC;
	Thu, 12 Jun 2025 02:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695900; cv=fail; b=HNaui1p69563NaTf8M7YnjcX6IZi8Fg80RkErLJVacfPQBnXr1HqO+lwJddR7NqwHyK3rJVqSzgXm8Eh5oKKTugvkVjjqgaskWRWoMqqf+2QJmtkFLvPNPH1OdXaEt5JvT36gXSowjm3ljSrdqflG/zrx4FZwji4h0Wmfe1cd0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695900; c=relaxed/simple;
	bh=yxnwyfeKzgHaAIspQTc7rQKXAj5xi8lLWrct27Jfo90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GM+39xhbTfJYFDg/cqr0gPo3SFI8ShnO3akk0mrgWV8AVxnmzSeIq9/+RsP2+zRaUajb+RNbBJ0JlQc/Jv1bl8hqAWhTbgzeTUnBlCXMDBix7MBqx0JEP5002IO4fS7dxKG0J212Xjo9UwjE5T7TKeDl8Zq/E+vKpOe2kbkdTi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kduyzeyH; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749695899; x=1781231899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yxnwyfeKzgHaAIspQTc7rQKXAj5xi8lLWrct27Jfo90=;
  b=kduyzeyHPBOPTz8NFSdTxmsKLSwu2dKl2LLp6b0wWqyYknkl+Ho9fxFH
   AhvH67UQVVHJ5FHjuwZKTzBWjKSYsC6Y8MO8Fqhe1dw8yoDTkVbeB2jKg
   dIKeK802N8MltVx6uPIWS4VbsdVzdoPqx21PeCj4gzk1NGDbdeLPfO1yN
   Kf8oZPOXzgfHXdJCjp0qAzZpQ8SwuM4C6a6Oih3YSSkJUu1NJfRse7Ae3
   mbHm/76FvxYaqheYPCuyo5zMU1bYLnci/Tiqje9RzLW48I48an+vEXjXQ
   azWRRgb8pkkpgrtWQqOFPL0JImeIHJUN5rWc9ky8gEguQ/IJq4qw6b20p
   w==;
X-CSE-ConnectionGUID: dstQuNG6T0S3TswgpN+Edw==
X-CSE-MsgGUID: sD+1WexIR7Wk76yPni+w0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="69295590"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="69295590"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:38:18 -0700
X-CSE-ConnectionGUID: I5SkUeFsRqe1mOE7tWrVRA==
X-CSE-MsgGUID: JQP8ajPFQEmpLYfXrszTOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="148278719"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:38:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:38:16 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:38:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:38:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tuu7uy+6Ws/fFIuIfZYCmlq3txdKFcPpxePrjpC3dSW7RJUvzQkbVSyuMNckl3ghFDeEF5A1rD0+f0HSZsmTpK+1u7PjvnNksUcjv/Z0ZbkqlthkYbJd5bIgyQZMUXlRdM93kpV14anabxQTZFTMm4KnEedcfv46A5bR3IKuT3yg3boeNHP2PLmkfKCvoxgd+QhZeQsZS92Oc4tmNUNQCr0STSHhuoURuocjfbUynLsrfNJtG+BaZFHGY/WlgIlIhAqZaOfl2tQn9Ro/dNNGG+rcdxFDhGnfqlVZAL156219bvyRUfCJ3l5hj7UzhtoFEJ2l0hWnll0RJJt/+8Za4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxnwyfeKzgHaAIspQTc7rQKXAj5xi8lLWrct27Jfo90=;
 b=ePzll2ZNLsMrKC33uL1EorwyCjSykksNQ3jytEy8H7KY8SH6B0Ruuefv/zE38xF+hnQy39RJMIhlr8DbrHaPzMLjruvdp78DCrNcWWUW07PC03AtRD5/I2QUIg76AfMtJMiW8GmS/hDzrzL4X0N4e6g+GdJ4sRaWqXxNMAiIt6Y7VHBOnvBXW0UXVHhgeU3m8rlNUoMHhAekCBQnX25Ve78Xh1Z/bvaEbjht/dbxxNihAaBqRSlHfiXWsbo9YKjuZF3HTocyDXjxhonNGKo6DRMRjaimfsqrFD8jz3cJsw1YA121v6Bf592j9iGyHsMHyLE+q93JKknNtI8D/yDAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN2PR11MB4598.namprd11.prod.outlook.com (2603:10b6:208:26f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Thu, 12 Jun
 2025 02:38:00 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:38:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Topic: [PATCH v2 04/18] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Index: AQHb2xjgdBz9JRDcZUyv9DbGRr27drP+z80A
Date: Thu, 12 Jun 2025 02:38:00 +0000
Message-ID: <44cb77805d1d05f7a28a50fc16e4d2d73aca88f3.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-5-seanjc@google.com>
In-Reply-To: <20250611213557.294358-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN2PR11MB4598:EE_
x-ms-office365-filtering-correlation-id: 08d96fd6-1436-496a-09f3-08dda95a25fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TkxRRHd5MjdxNXdqU3FwYWJodkZhVWhaYmtkeWF5NmFwL0xobmtuMzVYc3Ji?=
 =?utf-8?B?bnR6aUpXMzB0SG5ZMUtMSUFxMWhrWThmb3IxbE56K0VXWnRSSU03SkU4YUtN?=
 =?utf-8?B?c1N1UVZWYk94blhVa3lwUWMwdDUrU0hjcFJNUGlaUThYZE5CNGJQYk1jSTR4?=
 =?utf-8?B?MEhmY1EyRk4yMEZJSmpFVmxmbXRNOHpQbitLV2V1ZHcwTHFxY1VKdk5NbTR4?=
 =?utf-8?B?eCsvSWUrRmM4QzRQbmtTVVcrWHNqeHJremtCYkxHR1k4YS83T3ZpVmFPOTdX?=
 =?utf-8?B?bUxEMDJGbHROK2IyVjZiUnBNanhFcll5S0UvaitGR2RtSVZTVVFBWTkwdEt1?=
 =?utf-8?B?SW5KS3l5eWlSQTJ0SVNscWdFMWNZYWZVRThhczhMS1BhaEJzOE10VDlMeTF6?=
 =?utf-8?B?cElic3pZUDFja2traXlTL0oxOCtJQ0pnbGMrZ2J6L1plRm1xYUE3ck9lV2gw?=
 =?utf-8?B?OERmcm85ZUREa29IWitHd1NmRnlMVXJtRWl5SS9waVhrWVV6L1RKdU9SMmlE?=
 =?utf-8?B?ejhKYzZIdXVCL0hVbElhUkwvMURnanVmM2JHc01Gd3phdWVuR1JYUzg2ZHg1?=
 =?utf-8?B?WEhZWlIyb2JXc3htOWpISnlOZHRGQ3pDeTVKL2I1MWlCZVNzTmNiSFpaWlhD?=
 =?utf-8?B?TngxTjMxYjNqUjNaVENNank0ZzVsMHAxd1cwLzlBcFZUZ0lHUm1oS2NhWllY?=
 =?utf-8?B?RjhmZ2EzK2xIZHhGRkJIeHNaRjg2WGh1cG1ieUpOQ0JkOEhsSnpGZzJYeEh6?=
 =?utf-8?B?Nld4dGo1MGt2cjZ2MHBncTEvTVE4N2Fiajh2Q3lrTVo2RUk1NnhOM3hFb05N?=
 =?utf-8?B?UUlGaVF1TmxsSlRKU1VPSFU4eExMODhrcUQwK2ltcjRpZkM1Rm5ITm5ESWJD?=
 =?utf-8?B?dTVQdDloaC9KZkFzUGl4RUV4RUF5b3V6TERVWmxla3ZRYlR4L3FScVNidm1j?=
 =?utf-8?B?OWd2Zm1rVGp0VThDT0pvblVwS3ZzalF4d3VpME9mdkNEZlp0NERmMklwWkx2?=
 =?utf-8?B?STZzRWliYTlvMmNuNW1vK3pYd3ZiaWtNTzBWZTVzM2tyWVY3ZTM0THIzRW1n?=
 =?utf-8?B?dmdyVVFJbXE3ZERhNTc2TG5XV0JndjVNN2RXVE5sOExVMFRwajlNd1pNVGxh?=
 =?utf-8?B?ZVJ2bVAyN0NIU1lwTElQSVZ3a1lmZXluamhlVFBreEI0YXoxTUl1bGRNSEZC?=
 =?utf-8?B?TERlVmNGWmJrZXFRcFFlN041d2VtTGdBdldwSDVmY1F2dEMyTSt6V1E0NkVG?=
 =?utf-8?B?dDZJU05KYXFwNkE1dU1Hb2IzV3dJTDBKL0k4cHhBeVlBTFhoakF4YlhvcUtZ?=
 =?utf-8?B?RTUvRGxnWUVPL2RxdUZaQXJWd01BNndKQUx6RGZ2ZUhHdmNIV1JmblFYZ004?=
 =?utf-8?B?MWwrZVUwaWxUMStmTnczNDYvbkp2eldQYkFobjB6a2ZjWE5ILzJ1cXpaSkZZ?=
 =?utf-8?B?MHlKWnpsSHQwRUd2V0VtRjJrMGJCbE9UdVFKa0V5b05wVDJESWtCMzkxeEs3?=
 =?utf-8?B?cmgrVHhtbnlVbnBsVWNXMGRILzdvZmtiZUxTc2gxSGJQa1RUTzQralJUVzlp?=
 =?utf-8?B?NjVLMVVjbEw1RjNJaE1hajBCV2x6eXBVVUpST3RPejVyTWlqQm05WFpYcWRC?=
 =?utf-8?B?UUhHRFlkc1RZYU5HeXF4T3hBdU1RREd3eEdXVWlKVkpiS2xQbDA5NWVSaVN1?=
 =?utf-8?B?ZEszSENTSHAxbjBneEVXNFNyblp2Yzh1eE5zalFDQmFrM1BzZnNDOXovb3lt?=
 =?utf-8?B?T2hFUndyMXNsTlVZYTJBVkg2NEJtdHJnTXpOY0h3bS9ydmcxaTZDNjRRSmxE?=
 =?utf-8?B?TTlCZ0hJZ3FUR1loQmxrUkE4Y3NuRW1zaXNNQ1lFeTR0OUcwZnJMc01nSlBD?=
 =?utf-8?B?ZzcxNEhFNnhVbEhLVGFjVXpXMS9hZGs5UzVnNlMxcTQ0SGh1RmtmNGFtbzB6?=
 =?utf-8?B?NnpFK0FLVVo2dUI4NzBzdWRyL1RTbUR6MmxXc3FxZ1pEY0ZKTjRGZ3VEVldp?=
 =?utf-8?Q?3+pev12kCwIwK0MAk54V0N0jYkHSas=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHVHVU8yd2pSNDkrUStLU3lCdnZndkdMM0g4THlVTGpMNzVMaGc4ZHFGNFEw?=
 =?utf-8?B?bVl6WXlCdG94WDJNdWU2aG1KS2UrWjNoeTlyNmtLZE9sQ3FVZzJOc2pRVDNk?=
 =?utf-8?B?VkNKWklsM2t5aFMvVmVMY3hsZkN0WU11S1hWa2FRdGNaNHFuRHlleGQ1eThq?=
 =?utf-8?B?YVNqVllkNjl1YTBXY2l6dWdZSFdlWkNPUXIzbDFVOTlJZFZ5OS9CYTZORmdz?=
 =?utf-8?B?azd1MStxL0R4OEdpMjVhN01Cdi81U0poMm1ic0RobEFvTk5nYzVPUmFGTnRM?=
 =?utf-8?B?MWdhREtLQU1EYWV5RDhVVWZXVVpDZ0oxUllKdDBGdU1vV0pKMlZFR3J1MmZL?=
 =?utf-8?B?ZVZURWFZZEloNGRWaXZrWDRma1FSYTdoWHBQN3diZlhBRjdQNUVUb1VaLzM2?=
 =?utf-8?B?Y3FQQnZ5Z2ZrM0VMQ29scnllcmVkbHpRTXNzOTR3d05yaVBUOG8zcm5LTkdh?=
 =?utf-8?B?aFc2OER1NzM1M3NTMTE3Y2RTa2FSc25HclZ4NmdNbkpwRUM1d3pabVdDVjIz?=
 =?utf-8?B?dm9hcGl3aU1HZzVMeTdhTEc2c2JncEZtUWNUY2NUWEdDMFY3d2lXbVphd1Jv?=
 =?utf-8?B?VGMydGFtODdCemMySG1ZNEVGSGpKNkpQNHd2OGtQdDRqWThVK0tsc3FUbUkx?=
 =?utf-8?B?UXJyRlBFNGgrdDhod1lyV3pjMUFudHRBQ25qVm9jUk1XeDFrRGllRDFoUEEy?=
 =?utf-8?B?QkN2dW1od2V1dHZQb1FuS1lYVWRyd2ZyYU5OZ29GS1FCZ1F1elRxbk0wMktX?=
 =?utf-8?B?aTdCQVJOU3Z1STVpaUoxc0JBNTRSdWN0cUF5dW9jTVVyNzBENkdkRU02OXZs?=
 =?utf-8?B?ZHkyZ1BXS2VrbVRycTUrcXJsRzlRVGRiRWZxbG05dU1PVTgvNlVIV1pFSUpv?=
 =?utf-8?B?WE9UZUZkS0RreHZNaE90YkJnQmIybWdaYSs4STMxYWZXUVFGRktzT1QrSmlU?=
 =?utf-8?B?elhhQUpsWEJlUWhHUFoxYm01MmM3R0xFUzRtK0d0S2hySmxIc0RTZGk1NUtL?=
 =?utf-8?B?cmpGdisrbGZWQXpYM1RWa3VrVEpiV2dsMk9GMmh4b1hra3dZWHdtRkhoU0Fk?=
 =?utf-8?B?a0doSTFVM2tvYW1xM0hXTWs5NlZHdVFhTkVFR0VXRmdFSnY2SmxvK0I0Q0lW?=
 =?utf-8?B?TC96R2hxeDBUNFo0TU9yckRNcFZVclltTW5oUlhKQmRhYzdqQmpIQVhBM3By?=
 =?utf-8?B?Z3YzYUQ2VnhLRzBhS0lGc3lyb1pJa2pRS2NIOUl2WEJwaGduV1diYlZYdEFk?=
 =?utf-8?B?TE0yMENHQ21XUjJMcUJWcjFXM3FaQ1ArZCsybU9mRUxYL05oSitlVlVsRm1W?=
 =?utf-8?B?eGlyalpFRmh5SXhQMktOL1V2MlB0elRkQXdYQVF4TXppVW1wc1hTeGsrM3Bq?=
 =?utf-8?B?TzJvdEVEWnpzY2lKZ3lrc2xFZTNYQmdob2Zzc1R2NUI5dHpWWUM3OWc1SS9Q?=
 =?utf-8?B?TEtOTWhldWlIdlJLd2xsS0ZhN0FUeHZoVzJaWFhoazZlaktMdUFYakx0Ryt6?=
 =?utf-8?B?NE9zejE1RWtwWGYxeHQ0WHdwWmpGMmcyR3pqbW1ZODY0YkZVdzE1YlRGSzhH?=
 =?utf-8?B?ZExIQ0J1cWJMWjJlRVJMcEo3RS9UN2VlZlVGbEdodDdJZHdObFN4WGxNbk9m?=
 =?utf-8?B?Y0NwcGVMZmRrcUhzdWpnSkdPRnlqbkE1dUpKeDZrZHV1VlcvNWYwVHVHM21m?=
 =?utf-8?B?ZGlJazEybHl0WFkzSTVxcktCNzBqSXlRbWYzOThHWkxVNmRHby9xZGswWVl5?=
 =?utf-8?B?ODk0anJ6ZkFobEI5aW1HdEdEK1Y4dTMwZEkvR2xZMVpVZTdWc2JQdjVLUXli?=
 =?utf-8?B?ZnRaWitRS1pxV09qQTIweitIV05XWFRBK2paWmkzY1hmVi9ZS2dMdXF2MUow?=
 =?utf-8?B?bmRGKzZUaG4wR3FpMTlwblBRMHhzMGhnbFlwR2Q5c3Fzb0p1TFMvRHlHczhX?=
 =?utf-8?B?Zit5Tk5PaWUrMHhVSHh2VzZHUVU1cFFZU3RIdUtpTE1TZ3RXbG1pVzlrcTBa?=
 =?utf-8?B?WURrcVY1bHN3emNCRXBFenZwYnU1bTExd2R3aFV4L3FERURnZjRKNEhZYmxX?=
 =?utf-8?B?M3ViLy9RZ09xdXlPL1Y2RDNpazQvNzNPWHJ3Z0V1NXJiTm9lU0N5ZVJvcTVu?=
 =?utf-8?Q?qEGg5ogBqtGybwMKY84FohL90?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86141EB8121914499245F9388FFA9A34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d96fd6-1436-496a-09f3-08dda95a25fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 02:38:00.5497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BviA81cTkHxBr8qqJTVx9OJLX4R97g6XFsnQrBuLRI8mVw+5B3Tw/lRp4tttHnIqNh7Y13oAJvEVs3gpPOfKRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4598
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIHRoZSBzdXBlcmZsdW91cyBrdm1faHZfc2V0X3NpbnQoKSBhbmQgaW5zdGVh
ZCB3aXJlIHVwIC0+c2V0KCkgZGlyZWN0bHkNCj4gdG8gaXRzIGZpbmFsIGRlc3RpbmF0aW9uLCBr
dm1faHZfc3luaWNfc2V0X2lycSgpLiAgS2VlcCBodl9zeW5pY19zZXRfaXJxKCkNCj4gaW5zdGVh
ZCBvZiBrdm1faHZfc2V0X3NpbnQoKSB0byBwcm92aWRlIHNvbWUgYW1vdW50IG9mIGNvbnNpc3Rl
bmN5IGluIHRoZQ0KPiAtPnNldCgpIGhlbHBlcnMsIGUuZy4gdG8gbWF0Y2gga3ZtX3BpY19zZXRf
aXJxKCkgYW5kIGt2bV9pb2FwaWNfc2V0X2lycSgpLg0KPiANCj4ga3ZtX3NldF9tc2koKSBpcyBh
cmd1YWJseSB0aGUgb2RkYmFsbCwgZS5nLiBrdm1fc2V0X21zaV9pcnEoKSBzaG91bGQgYmUNCj4g
c29tZXRoaW5nIGxpa2Uga3ZtX21zaV90b19sYXBpY19pcnEoKSBzbyB0aGF0IGt2bV9zZXRfbXNp
KCkgY2FuIGluc3RlYWQgYmUNCj4ga3ZtX3NldF9tc2lfaXJxKCksIGJ1dCB0aGF0J3MgYSBmdXR1
cmUgcHJvYmxlbSB0byBzb2x2ZS4NCg0KQWdyZWVkIG9uIGt2bV9tc2lfdG9fbGFwaWNfaXJxKCks
IGJ1dCBpc24ndCBrdm1fbXNpX3NldF9pcnEoKSBhIG1hdHRlciBtYXRjaA0KdG8ga3ZtX3twaWMv
aW9hcGljL2h2X3N5bmljfV9zZXRfaXJxKCk/ICA6LSkNCg0KPiANCj4gTm8gZnVuY3Rpb25hbCBj
aGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBDYzogVml0YWx5IEt1em5ldHNvdiA8dmt1em5ldHNAcmVk
aGF0LmNvbT4NCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNCkFja2Vk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

