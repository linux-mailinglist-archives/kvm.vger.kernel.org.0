Return-Path: <kvm+bounces-14773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D5B88A6DC0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E1F01C22879
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9531304B7;
	Tue, 16 Apr 2024 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9ETi34m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032C812BF31;
	Tue, 16 Apr 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713276770; cv=fail; b=gqr8OilaJwCPZwWmjKEgFEXlkBKUKDQZ7zKDeyz65rH7MyhLI8WBkTZ948YsRigCo20ir6W9HvxUegWQnontNWpp18McxFwpkDmShjw7GwYWwU48YhD2LB1IVjVYYNbudeJE6Vau18Cyd42N5byDfLhZvgsyvIa1N1xs3mRqHB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713276770; c=relaxed/simple;
	bh=Eyc+zUDKnj/hPFU9vWe5v1UW93iwGg6vy4QKpSjBbFg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iGCraOF+XEgKoz5yA5egBTcv0f6N/7N4bcYuEZ1+OSwUgl5g4zgjWTPgwW7scbrUmGBpzwEbQy/tkrT/8pgI/D+3knPRj6a/hbCHnjUb2jFC8gRG5enZaq5GRssWVYKt4uLNHiWcNjW2nb9gkgMXvJdPpFJkqpM+WvBTEXbeFmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9ETi34m; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713276765; x=1744812765;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Eyc+zUDKnj/hPFU9vWe5v1UW93iwGg6vy4QKpSjBbFg=;
  b=U9ETi34mCUsA4MAeRIVlYKiL8cd/6eiBHCQcx6GfwbeE6OtCnqaMBZLL
   gUTSGXoa+zJuGjux+9SouT2HgCsFFzK1sA0XpAh7eewXBXkshlSPLHgB0
   cfTmR3prBYmbYpw/dPiyHXzisIGLgWPn7PheXo3Ybemis4IYIBjsENxQC
   LgIuoQ1zAcQrNYHU4DWt14Lc5rCPLjXWiK1wv2eeYWWy0n4MhbwDTeclz
   MFr4O7zVeRuzluKdJKgHnWq1fV4to+nuNuMBguSJPkzX1Ne8lHYI1FjCw
   LwM/fYB2aJuBFdXOLPDeDOVCNvo3Y9P3Dmwrrly9Q1j9Mfdkt+yOdr/X3
   Q==;
X-CSE-ConnectionGUID: vN1DtXhZQGGVIav0OqNT8w==
X-CSE-MsgGUID: REeGmtyaSjO4UyMWphbbfQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8881477"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8881477"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:12:35 -0700
X-CSE-ConnectionGUID: LqyqfmHSR32IOD8HyoLHsg==
X-CSE-MsgGUID: T0csb4ARQ8OZM4MT0Qesew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22746252"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:12:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:12:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:12:34 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:12:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:12:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoPK54Zo1spqTwNO8WvUy1ZVFFfBDa08B8zfmZZDm4FCOphhT7lPUjoGGAtHI/jHuW4mze91tkJyDKa7Up0uPiUQFoe+0wk+TZ782CoebEtZMDJADgSt5GvpX1aXY2aBaFLZVG1Cn39qHSIHzPOaOTkepustjIVBTjwLOW2vAAg83CH2mi6622oXyl8bsp1K+4XvtA27SXWiVYPf6DztTx7STiTSTREVFYamVh8vttZT0pbVyN1cfmyPbc2bMFUwm/e0Y8zCLVGdMXPEayj+mLjyqbpWROvBF1G01ISd/RF5vxjUe3g1shp6Tw0qGzpJ3bKfY78d7K5T7pUmsebmtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eyc+zUDKnj/hPFU9vWe5v1UW93iwGg6vy4QKpSjBbFg=;
 b=B4PJQ2624ait9Xp8Y55BgCDekFiNUc0kbSsoDomgd78EkgYioKpmbUzKDZQwRVOtdt7trofXAmxB/5OLMp+ihD9TVubJJ9Lcfy0CCUq5FOQX7AaM1N17aU5Zy6PfhtNXxIqIJpPQi7DVWhljCNUPPthn9cz2KP0PvnnTz+julaLPyXp8r+ixeFEKuTSfKIMukF5I84/0AuJWlWZoKPgpMLPEA7hUsbNlGpDo8LZim4SfGsP8BhCpX2/gxwCX7hd4rrtcXyl6iDBYzHVrNOeJxElI/x1wkVworXq+u+VhfPqs+1Xzmjq2caxHctItzFdOXJkBHKXfzV1mBTYXpQoA4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7972.namprd11.prod.outlook.com (2603:10b6:8:124::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.49; Tue, 16 Apr
 2024 14:12:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:12:31 +0000
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
Subject: Re: [PATCH v19 089/130] KVM: TDX: Add support for find pending IRQ in
 a protected local APIC
Thread-Topic: [PATCH v19 089/130] KVM: TDX: Add support for find pending IRQ
 in a protected local APIC
Thread-Index: AQHadnrInhYIuE6hvUO044g2mpbwrLFrI0eA
Date: Tue, 16 Apr 2024 14:12:31 +0000
Message-ID: <dbd397a5b61899fdd5b90959a2f58f603102c333.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8ea6ffce742842da725a7e3f891a38583bdb099b.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <8ea6ffce742842da725a7e3f891a38583bdb099b.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7972:EE_
x-ms-office365-filtering-correlation-id: 0f2a2bc7-6000-4c53-a72b-08dc5e1f41ab
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Krmzx9I6ss/Uh7G7qklp2GYceW1OOboyTX/5YfJxd4jS5LjrJRzZ9E72ie2oE2avBS3LvO7VDjmQBkYCWTbGkF2DplRsf1aw21V3C1OswnOHcd6ZEiTr+EyZBAR8nwjkJT4lLQSq5/Ln1fGUwkvLAoyyWhxMlIt5aW+FYbxuCx1DSPV3X3VAUACnBxxQfXDUtgW61/7IMFm7QqLJJaZOcdTNPgD9ujgHFcIcntcJqUkDfYLuV7A64LqgIOB7T4tzhb3TEnXrX6Zykjbe+tj1TFxpNdjP/vHa1LCwSaJlAPnZSJDMXL3/w6nx/KEh9GvkKPP2xHNo97Of6meHBillzbTi5EFsWgXxobyByz+F5RQFr/H7haDec8L+637x7vy1WqKsEQVvLVhUSdU1sbSOj80pr0zNR2jNiRMRqbT3uZva/OnfiFFtDcmA49lxh87hNJQbq2gTmuwOt3Co40FPHVQ0QWSFmai8FQlBGVfbPxgpv4AWtGqW7PUVSozacVUI5J05LoxRzKUHwi6cWQyN7H0KoQJ2ZUhOQ6mL/VSmOexGCT63mrLcvUENkvag9JZWbWFFVyetvX3PwLQ+vIX0V+yL3dGENNq2vqA9sdp7pnfZm5ldoaAsHsOp0LRFvzdW9eKm+WRCaUqXQOSok2NZcZXk0vG3m92smENiPwBqgWE+W/rghROoWsSv4+uDWotYjrrXdkAm9vk+FGei2E6UJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3pDTWxqbUhRMlVsdDBSR2oyWm1HSm9nMXU5YXBUUDJzV0VYVXlwQzhCaUl5?=
 =?utf-8?B?b1NzQUdZZWZYRloySGlKWEJlTE90anZrNjRmMGhMNm1KVmNnYWQ3UjA1bTBM?=
 =?utf-8?B?c3dTUlZDdnJWam8rVnQ3RG9hTlp0UnFiV2ZGWEdCMVpOSGJ5V3ZmQ3V1d0da?=
 =?utf-8?B?UWFsZUlmZDBTRXZHaU9jcXJyMHhYMVZMZlNTb1hjWmltaGdWUXFyT0FFZ0Zi?=
 =?utf-8?B?RkV1UjM4OERnN1p6L1d5aFhLRjF3YUZPMmNSTVZaM0N3NTVRWEtDMjUwSTAv?=
 =?utf-8?B?Vm5xT2tkQ2RUWnM0SjlRZm5uNHJmdDNDb0NLbktrR2JyYm1jRnFTOTVLRTdn?=
 =?utf-8?B?QTBFb0EzeXNkR000c2M2a0RIai9ZeFBFeVYyek1HRWdKajlOUCtKbE80ejYw?=
 =?utf-8?B?WVd4eHd4Y2tKK3lGS2N3Ulh4azE2UVpDb3EvTUxjVE51ZzVnSTdDL1NHaFlj?=
 =?utf-8?B?b3oyZHZpOGVCOE1oZnM2VFpnSUtYVGs0bnZBVFJ4Q3V2UUw3aDhZaDRxU0ZQ?=
 =?utf-8?B?b2pSKzBhcVFQMm5QZDgxZktValNlczd4QmV2WGZUcU55OXFYR0JSR013VWEz?=
 =?utf-8?B?UVJuSzBTc3FOcGwvZVNwRUpTWGczUnNiSVowazJkbStaZExjcGo5V3Y0bWxh?=
 =?utf-8?B?RWdTSys5dmFDaStrakZRMUF3ZW9ZNUEvNnVnQnJVSllxTmFncUFMZVp0K2Jt?=
 =?utf-8?B?SWlPV3VqNllPZVdzVGZFSEwraUpSeHc1dUQ5bERHS2lxSEQ0RmJFRE8yaFdJ?=
 =?utf-8?B?QlhxQW94Zm9xcW96WmpTTmdXVkNwcTlVZU9qSHZoT3dlWTQrV2h2VnE2NEE5?=
 =?utf-8?B?M0IzbGFWWktIN3V1L1g0Zm13MFVvakNZQ0U3akRJOWYrSTlNQjhFVGk4UzVn?=
 =?utf-8?B?cmxnT3dYb1ZWUWlyUUhtdlNjVTkyL25DV3loUE04THBFYW54Y2JQdi9zb3JD?=
 =?utf-8?B?aWE1NTNSTXFQZlBWTllZVWRpR3h3NXNjeWNpTjh4U0laQlhvL2pyOGNrRk5S?=
 =?utf-8?B?VnFuZ1MwUUN6QTVDeXhGWmg1c1ZxUFNXL3pIN212Rng4bStrNklaUjZDeFlt?=
 =?utf-8?B?a1QxaldTSTNpWk8ySTVSTHgwV2NoOGlBU2VLdkN5eVY5UkZtSHZYV0wxTThS?=
 =?utf-8?B?cUZ3WTZaOG54YnMveHUvYUM3dW9nWXdzMjZmRWk4Z1kzM2lJYXAzWmxnSzZW?=
 =?utf-8?B?SERrWE5SVThDLzdyeW1uRmlOYjNtMzI4a01lMEVINEM3UUl5dXNybXk4OEFE?=
 =?utf-8?B?MlpTdnhobFdQYTdEZFAvWE9EeDl2QjJqb2tHRVZSUi9sMUN3Q0lwOWVTeWll?=
 =?utf-8?B?ek0xMVltb2FJTjZobUNidFpzeGpnME9VaGdvMG16ZGNxRTlVcDRJN29PQkRq?=
 =?utf-8?B?MEl1MnByc3NiSFRHWHpGUmV1L2N5Sk4wMlIzcnEwSU90bVJ4ODZZWUhXWFg5?=
 =?utf-8?B?aS84SytEZWtZa1BFSU1ERHRQeG02ekRNaHV0TDdCcS9FREFkVXpHUVJlVHdu?=
 =?utf-8?B?MWhoNGVBNmsvNU9UVWMxK1NOZ0Fna1RacDF1eUJ3OWpzM2hGN2Y1dDF0eUdn?=
 =?utf-8?B?R2FZN3duNlVZclpBSkpEc2VRVEV0WEhLaTlmeGVjbkZnRC9XRlBlZ2JVMFJh?=
 =?utf-8?B?bUZnRm1qd3ZoRGhxV29lLzVEUnQwOG4yNHVxUFBVMExzOEdLeTJ5TXF4dndm?=
 =?utf-8?B?YmtLTWxhZHBDc3ZtM2Z3NmdERHI5T0ZwMjl0OEVxdnM0czZmUXJBNDdsVXUz?=
 =?utf-8?B?S1FVK2xGVlFReUdLNndhQUV5TVRER2Z3cytITy9NNm9uUGhGdENCU0w1aE9X?=
 =?utf-8?B?Si9xTmh6M3o5aEkybUVXTTgxZXVuWElPb2lWZk5naGtSWE1lbzFMYk9aTTgw?=
 =?utf-8?B?amxTLys1YlV4cnJ3bUxiL3VMNUdIR20zMkhzVk03ekFYb2FscnZPbzY0K291?=
 =?utf-8?B?b0dKZ0lVMXU3Z1A0NWtHUmoyYkxxMStGM1cwMk5iZzFsUHVCNHJoYVJranB4?=
 =?utf-8?B?a3Fmd3ZYWDR5a3RkeWs5N08wd0RiVHNoekRWMDhtQlA0V3cxNCtzWjlMY1Fj?=
 =?utf-8?B?ZEpRK0pkWGFFS0tGTHNDZHpHSnN3VHdZL2FxUWlibjlRUUZyMTFBaXo0SnY4?=
 =?utf-8?B?UHdWY3g5ejhBUllNdlFwZU9MYzE1MXVtK3dMem1VVC82Qm80QVIyNkducVdy?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6EC2BC71BE1A84E9C58B78F813740FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2a2bc7-6000-4c53-a72b-08dc5e1f41ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:12:31.8070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aw78HI6QbQ/yOrcvlZrCi3ZEIyAqdCBAyBb2s/vboyvSWhbzGdvZ57TAgbMN9o6IoWe5x2eUE75uNCiX8U/VCzI2TmtQzQ/dqbIClaoVUD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7972
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI2IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IMKgDQo+ICtzdGF0aWMgYm9vbCB2dF9wcm90ZWN0ZWRfYXBpY19oYXNfaW50
ZXJydXB0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gK3sNCj4gK8KgwqDCoMKgwqDCoMKgS1ZN
X0JVR19PTighaXNfdGRfdmNwdSh2Y3B1KSwgdmNwdS0+a3ZtKTsNCj4gKw0KPiArwqDCoMKgwqDC
oMKgwqByZXR1cm4gdGR4X3Byb3RlY3RlZF9hcGljX2hhc19pbnRlcnJ1cHQodmNwdSk7DQo+ICt9
DQo+ICsNCg0KVGhlcmUgd2FzIHNvbWUgaW50ZXJuYWwgZGlzY3Vzc2lvbiBvbiB3aGV0aGVyIHRv
IGRyb3AgdGhlIEtWTV9CVUdfT04oKSBoZXJlLCBhbmQNCnRoZW4gc2luY2UgdnRfcHJvdGVjdGVk
X2FwaWNfaGFzX2ludGVycnVwdCgpIHdvdWxkIGJlIGp1c3QgYSBzaW1wbGUgY2FsbCB0bw0KdGR4
X3Byb3RlY3RlZF9hcGljX2hhc19pbnRlcnJ1cHQoKSwganVzdCB3aXJlIGluDQp0ZHhfcHJvdGVj
dGVkX2FwaWNfaGFzX2ludGVycnVwdCgpIGRpcmVjdGx5Lg0KDQpUaGUgcmVhc29uaW5nIGZvciBk
cm9wcGluZyB0aGUgS1ZNX0JVR19PTigpIGlzIHRoYXQgdGhlIGZ1bmN0aW9uIGhhcyAicHJvdGVj
dGVkIg0KaW4gaXRzIG5hbWUgc28gaXMgdW5saWtlbHkgdG8gYmUgY2FsbGVkIGluIGFub3RoZXIg
Y29udGV4dC4gSXQgd2FzIGFwcGFyZW50bHkNCmFkZGVkIHdoZW4gdGhlIFREWCBzZXJpZXMgd2Fz
IHN0aWxsIG5ldy4gQnV0IHdpdGggdGhlIG1vcmUgbWF0dXJlIHNlcmllcyBpdA0KZG9lc24ndCBz
ZWVtIGxpa2VseSB0byBmaW5kIGFueSBidWdzLiBUaGUgY2FsbGVyIGNoZWNrcw0KdmNwdS0+YXJj
aC5hcGljLT5ndWVzdF9hcGljX3Byb3RlY3RlZC4NCg==

