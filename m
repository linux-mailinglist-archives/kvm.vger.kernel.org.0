Return-Path: <kvm+bounces-56013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4981CB39173
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53A8B687181
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C75248166;
	Thu, 28 Aug 2025 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZIA+BHb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E339F1E487;
	Thu, 28 Aug 2025 02:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756346733; cv=fail; b=UhFngAI5nQVr4iwKWgvEhQMd6TneoRmidNT6DUuLQj83OsABsVU7i8JvsOpPCttE/71NpqfwIAhA2iTfJcK27FxIo8On9cLlzt2SHu10EFc+zZvo6qeu0t11aGSQirrnnOMCjsaTLXhiIImfbARQ5LibAvnDgfJSz6F4HwyrFyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756346733; c=relaxed/simple;
	bh=uq0SGhN4SEQj1EdkxDRK6+9MQbH7cmToNBiCZBf8hTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SCIBMroSZRKpLqWTOWwKRsc4tOzKB4sNpxJWJFZs8rkdN/ZJDiqU+WqZ2mldKokvpr7sTxzNrh4ItiZUI7ECRBdUtSIWHZfQUZBwOV8sqE1oEICOlWyP+jf1LW2a4fpsKE5LflpDMYmg6BGALz5dT3Yz/WRT5Lz0k+ARxHpE7+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZIA+BHb; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756346732; x=1787882732;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uq0SGhN4SEQj1EdkxDRK6+9MQbH7cmToNBiCZBf8hTw=;
  b=PZIA+BHbGZqDp74aPclDUmqsqz67eqMekjHIfFZ1H2QQVKmhk1pLQ39a
   mHJoGdc0kpqr0nIDv77SgQhglwYv3VgjJG0CDM7nosfLCgcSzREi1W/5U
   5stD3owMJEz5xamc8loROjSSuEExhCyQvcSaZrDvBY3Ha0fInPdHr/MxF
   5eCFYgtwS9rmhtpyY+idgbfNa5OSJ0RNIma3lE6X7YB3XFV7kLiecz7lX
   /QpFX/1SHlcYgKjfsSwmRgdaWePZEVzeyze3wzedTEOBUULni7B5y8TnX
   Eiej13c7krBcj5AQ1Ld7ny7sYzd3mV6k4r1WbuzlG7HkJc/xU+Hviqe4t
   Q==;
X-CSE-ConnectionGUID: ElOVLwVUQmyE8RA+reMiSg==
X-CSE-MsgGUID: s3x7SQmiR2OE4JOIjKuv3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58318591"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58318591"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:05:31 -0700
X-CSE-ConnectionGUID: ceJBAvqIRBu2zH8qDMhHpw==
X-CSE-MsgGUID: kURG3fDCTSSICG34Kd+qog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169234097"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:05:31 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:05:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:05:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.70)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:05:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MaVuO4lb9L6vtENRTSRe9ASQsZ2JcPIunDVsNZUXGusMX8T3g9PAUk8ju2wSKI6/DRNnOVeI6s38fZRdvKwh0pINp2Zv7h1Cx/VQkY77yZzhQt9UNA0Fo0f6VcTRmlFwbiXUjC1WgXrDVyDGzR8bpdQ++m+j3O9r8YY/BOonMxydBQWEGZ0P7GFiKY9bVmZ2IE1/b9g0HOhN/3xLKvrzMGZkHUbVKQbIwX986751fJ6l3smg2YuqTQg0IeVMrKghAN9ioHFRVvd1/oQgNG1o9BDCE9FJRXKZp8NvK5p9ZebZIkig23I2MRIKLnwUR3ABYlccZ6Q+xRPzPe6oNMrfGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uq0SGhN4SEQj1EdkxDRK6+9MQbH7cmToNBiCZBf8hTw=;
 b=Q6t3g7XRlFmAvbuRBoivkErgJseRPsjMZw/RyLwu9f9zrpR/DelPI7Bantd0tkBEVxVKSPzL8c+qHkv8qCwseYf3LVdkoYIUzBCL7h3LbJSl0vYypQ/a4VRUQ5a7Yxiba6ArB3I81YzPvyoV2dF4WX93FNJr+Zd9PkRhJV53UkaXmf48RinfcbyhjPrLgsfbX7tj5Sx+efa6eXk4wCNxtvv6CQtEDZ02hOKLja4OOhmhBOwnyIGCBC73NXJE1XT7q3AreHyaGoZ63T1pqg8uR0EdpiOrJmAjuDBWnjggRHDSr/Z5u+zLitJ541R9SKSOtEqjU7iypPpGQ83KoeSjqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 02:05:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 02:05:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcFuZVUJRfaSDaNE20/aTUNZGWSrR2LJgAgAEl/oA=
Date: Thu, 28 Aug 2025 02:05:15 +0000
Message-ID: <aa1835299cfd79788572a212761d8838c388ed37.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-6-seanjc@google.com>
	 <aK7CvEcYXhr/p2wY@yzhao56-desk.sh.intel.com>
In-Reply-To: <aK7CvEcYXhr/p2wY@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6259:EE_
x-ms-office365-filtering-correlation-id: 3c5bbb0c-3d17-45d4-c1c8-08dde5d754bb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eHp0ZlZaNzBaVkZRLzVVNnQ4UDJKTXNNQW9SaDlybXg5RDM3NTVaVHp0WGdj?=
 =?utf-8?B?S2xhYUhoNElOdnFMREZRbENaTkNGdStUSWtUNHR1ZUxqMmJSR2ZheVRCWUR6?=
 =?utf-8?B?T3ZPcE5nV05lbE9nRVd0Qm5xVDhQUzJWRnBKbW53Q2c3bWFLMytjdE5ZUlhq?=
 =?utf-8?B?STJLRjRLT3A4K2I4MzhJejBYNHhPelY3U0p3N2svYnd5OTZIRlM5U3VYVkIy?=
 =?utf-8?B?emg5UHFiQTdyZkZiaFE2QTh2d2N2TEpPWFEzdFYwaytUb0d2WVMzV0FGOVdJ?=
 =?utf-8?B?cnpzOEdZU3dXZEJmRHk1blRXa296cEdSSnJIWk9GSHg1Y1VlcGZSOXgxaHdl?=
 =?utf-8?B?eXpGaGFaVldkZUszbXl1dVZZMXNFUWxaS05CSG54bXJ3dWZTd3hKYmQ4Zmtv?=
 =?utf-8?B?ZTB1MkFvK2JSdWtKeDNmaGdqR0t6RFBwbWZTRE9ZZlB6YmVYVytncWdrejUv?=
 =?utf-8?B?Wm9NaG9KdGQzT3IwOWgxQzk1VE9EdFhlTjJydmFMN2tDZXNpSmhzeS9zdzNu?=
 =?utf-8?B?QzVVenVIeGpKTGdmdm5XQ2I3ZEZIT28ycXhmUXMybzdHWm9xN2RZT00vQXJS?=
 =?utf-8?B?cm92amFkMVVtdkdLTG5pa2lqUk1SVEp5SUhiMjZ1SnZRZlcvaUJGYmRDbHN0?=
 =?utf-8?B?UnFGS0JhUU9xVmRndHh3SnYvNGZUcmc5Um5FUmVUU0RiU3VsdUd1aFFiWG1s?=
 =?utf-8?B?WHhyeXk5UkFDMkpQNUFxWmRoN1kwSzJPVkRIQ25oaVN6RSs3TzEvTGRLTGJD?=
 =?utf-8?B?Rmt4VmZJUFczQXFDeDA1T0M3WVpqMllSTXkxZk8wVWtvL29udnpUNU54K3lZ?=
 =?utf-8?B?bG93bkUzTU5SaHZ4b0w5bmNjOFIyVUNwVEpkbmp6OUdXSW1OVDZEWWdIcU5x?=
 =?utf-8?B?eHJiNWU0TDdab2ladFNTQVhMOU1RdGp0ZUJFN3RwUmtSakdvM2U2azJ2cG9h?=
 =?utf-8?B?dEhCSmdRbG8rUkxyWGZWWlArM2ZNZzZKRk9LSzFEV2JCS0NYV2l0Y2htQzRR?=
 =?utf-8?B?S2t0YVhUbUFYWkdxbFFkU2lucGk4MjZDUDIvdEtSbUc5Z2VmaFduRVZCcGtr?=
 =?utf-8?B?WHRtMEY0blIwQXhGVzVaUVNrd2UvbWRkSk1MZzdTbXlVOFhZaUNzbDc4dzEr?=
 =?utf-8?B?Z2ppaVNwZ0dCdCtCbDBPZjY4Nyt2bVArc3ZJb2REdWpBV28rVlQ5NkZxdjlN?=
 =?utf-8?B?MjlTb1pTYUpLSnB6WDhNWG4vVm9DUXY3eThyRXVZcUNUVmpJaEtuQzFxbkpJ?=
 =?utf-8?B?RmtzT1RYbklteU9DR0ZzUDJMb2dBU1VFYXJTN0JGNS8zZlRFTjlSajhDOUJs?=
 =?utf-8?B?ZlpiQ1JzN0ZJdDhsNTBubDhBRy9nWTM5TldCTWpFUEUxMm00dDVlckV4VHky?=
 =?utf-8?B?bzc2Sm9hVFQrdkM0bldLYkhDUFd4QnRQRnA4ZHJVL0lUa0FSZnM3Snd3aW5Z?=
 =?utf-8?B?M2p1b21YREU3ZXpUSVlOMmlHbmIrVHI0akZkM2ZRTDkrRm5ZU3dTaWlFTWE4?=
 =?utf-8?B?WXNmT0U0cnl1Z1JaaVh4cmlJcHJTUG1MWkh6dERjZjUxamV6VUF4V0NSYVRq?=
 =?utf-8?B?UEdCMTNlQzZMMFpLdUVTakw4NUZ0SmQ5Rmk3Z0pOSEk3dGRqTjY5UXpNQXNU?=
 =?utf-8?B?RmI5RTd4MWtNWDRzZHhUL0M3ZXQ0UjZQR1FqdE02SUUrNlBIR242YjFVb1U0?=
 =?utf-8?B?NFZTSUZ5dWNScjNCQWl1Q2Nkd05Pd0kwaktUZVlnNmI2U0Q4VGVhVkpsdGV5?=
 =?utf-8?B?VFFLai9Id0dQYWVOUXhIY2l3TlpmWUJid2Q3MUtpT1R6NnRaNWZUNWEyVDB3?=
 =?utf-8?B?Y0hOdkp5WEhadytha2l5bDhIMnhtUDZtSHBCVk1CVEUyeU9Cc2h3SkV4Z2RL?=
 =?utf-8?B?ZHFRZGdsaWJIRVg4eXV4SlBpTEVmbXVub25aZFEraXBBQy9Za0s0SXVvQ09L?=
 =?utf-8?B?WkZLU3lmRTNtZUhyZW9DN3BRR1gzRDRCSkJjL3NsRVJ6d0JtdjJtUjE0OXlQ?=
 =?utf-8?B?NnB5SDlnZ01BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm05by9MNHdHSTdhbGk5NGpmNGROeXp5bjFxSWo5dXBxNTIzK2JQY3htZXNF?=
 =?utf-8?B?UzlIcU1WUVNYS1NlOC9hdVJyL2NoKzBmMjlka3pZeVFVU3hLRWw5QytRU3hQ?=
 =?utf-8?B?WGtpS1d3N3ptczlkd2VyRndHNTM0VkpMKytMTGQwYVkzMHBnMzlXU2V2MStv?=
 =?utf-8?B?NkpIMkpNWHlQSFhQazQwZ2QyQWxwb1g4THpaMHFkcUd6U0hsYkVkUStIS0h1?=
 =?utf-8?B?NWYvNjF0dmduUkhhZGY1NDhLc2VDMXQ2RGcra1RWaEdOaU5BdEJSYUdMNVhx?=
 =?utf-8?B?aHE4U09hYkZvdStaMDllZFIwdTZ3c3BwOUZ0Y0FFVWVUUldTY2xucEQ3bzNG?=
 =?utf-8?B?cEhhR0k1N2YwVVd3TEJzaDVNMlhwM0dWcUlRQ0pCS2dFUHBrOC9sV1FmdFlu?=
 =?utf-8?B?MWZlcytNK3BLUG43UzZyVTFXdTdXVzdEcjVrQ1d0QnUxQ1V3b3Q0M3I1ZEVN?=
 =?utf-8?B?Zy9JSlpxdmpRd0FySEQ3RDJ2T1lxcDE4ajBXQnpvQWVVTS9RS3Z4a3AvNGZD?=
 =?utf-8?B?Rzl5VndOTmFsazBxLzlSQUUzejdINXhvUW9jR05BWEc2Q0pPR2JML1JxRWtH?=
 =?utf-8?B?SThFdmZTMFEvUHk0cVBicmdldnFIb0NMT2tLODNKSUcrelhNMlJEWm10NWJw?=
 =?utf-8?B?MWpCdjF5WDdOZ2JpbXVDZnloam9GQlhKMmI5ZWM2M1FUNXZsTUlnSzhHVlpL?=
 =?utf-8?B?Y1h3R1dYYjdoSWk4eThvdyszZ21zcEhNSzdzT3E5M2RwT2JyODFPMnhyT3p3?=
 =?utf-8?B?NGsrNmw5MDI5V1JPVUY3V3dPQTZOUkl5M3NwVlh4WlZZUVowd290TUxFbWFn?=
 =?utf-8?B?WUNFZHpZS1Eyb1N6Mm1BazZZbFI1Y2dadU5MUkp1SlNiQzluVk4yZWV2OWVy?=
 =?utf-8?B?Y0hwUmtqT0ZtL2Rpc3hsTGdueTBUeS9yVVcxZFBoaWJnZjJCaVI5VGhEaGZP?=
 =?utf-8?B?R1BwVENQNmJIaFZOSlU2bHJTSXJIcmYwU2FKWk1FdzNuNFNjM1V0anRPVTZ0?=
 =?utf-8?B?TmlNUVluZEF5a0NaV016QnBtNWFTUlk5QmRPSDBjVDVvbnJsNkFxVWtNTjBs?=
 =?utf-8?B?Qy9DbG5yV1NGUXhqUVJEZVZPZjRKcUdjNW94dkxZQVNtRFlzWDU0dFdtcmh4?=
 =?utf-8?B?b2ZleEo4Q3VkUzltK3A3bVJaN0VxUmU0QVFvenUrN1BXTE1WYmltdjE4Q2RH?=
 =?utf-8?B?R0NqeldleFpkajNtWTFVa0I1SERKdGVHL21xZlNueWFMZVd4eVVBKy9mbk1Z?=
 =?utf-8?B?Yjh3SitLNlJkSXlxZGJJa1BjbUhPSXQwNmJZMGlZMTZrbEc4S0FUQmhuSkdQ?=
 =?utf-8?B?c1IwVHN0OGY5U0M5Y3gyRTBsSWpPOU1nMjUyMjlGbmoxTWh2bXZXTkd4TjdE?=
 =?utf-8?B?ejY5NDRiQ3EyQjBReGJycUdSa2x5S0JoWS9aeGtjWjRzeEV0Z0xMdnh6NFRR?=
 =?utf-8?B?TW5FUmZZMGhBdEFoanMyY01XY2ZRK0xzUGZxeENseWV2YmhWWEJVMS9acUdM?=
 =?utf-8?B?NkRzQUw0czB6WXN6RTQrSlp6SkpBdzRtdkIvcmtSNFoyZGsxWDg4TUpEdGpt?=
 =?utf-8?B?VUhXNVpRa2dESFZRSW1Da1hPcis5TEJxb2t2ejJnMmpyMVJlL1ZQS0hOT3d0?=
 =?utf-8?B?aWI1UHp6VFljWk5YS0FjMVpkMUgybGdLU2pHVjkxK3VvWnBSR2d0RFpxdTZN?=
 =?utf-8?B?bEtHdVVJY251WE8wQ2U0aDVGc05NaHJkS0VSNkNEMzg4eTJXK0N1K1hPRmdI?=
 =?utf-8?B?dkRjZ0tvcEN6c0F1SktjQWVSOFdDblVxdFQvT1p1L3NBanVpcnBoNjE5YS9x?=
 =?utf-8?B?Yk9DQjhXbzFGTFN2OEFWUjZqVjZ0dUFYNDlNNEx1Qm01T09wQWtpMXVYNXND?=
 =?utf-8?B?ZGt1MCtJY3pnV3lWQ2xMVGEwb2JRdEpmUXdkRC9wNmIyM1JjSTBBQWxpRmFa?=
 =?utf-8?B?Ym84a21Uaks4Wjk0R0VkdkFTK0RjT3BFbVRScXYzUXF2Sit2ZGFTZFFGMWM2?=
 =?utf-8?B?cHRVelowRzY2cnRWdmM4RmphQ3ZUUWtCVW4wSmFraXRPaHY5WHVRdmlQejRO?=
 =?utf-8?B?T3lmZTRJQ3lnQnR5OTNwR0EvaU5sZFM1WmRDK0F0ZkNETUpPSU9ocDRsT3ov?=
 =?utf-8?B?RVZPby9XZDU1T0l0WFFVVWQ2S1hmYkxkZlQ3YVUwR09iY2l0QUtzMGovWFpo?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24DFBA52098E954C9BA4636BC54BD09D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5bbb0c-3d17-45d4-c1c8-08dde5d754bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:05:15.8362
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JPjqGQQ2aJeneKY7kolvPPtlsaJbOiDrKA7CBvyLWzovZbuv5dbRiFjgpEEoemVIbo9A2Uhll9QGmrB5/fkUbSsoQMMsPN50WMcKd4CLOyM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE2OjMzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBBdWcgMjYsIDIwMjUgYXQgMDU6MDU6MTVQTSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNv
biB3cm90ZToNCj4gPiBEb24ndCBleHBsaWNpdGx5IHBpbiBwYWdlcyB3aGVuIG1hcHBpbmcgcGFn
ZXMgaW50byB0aGUgUy1FUFQsIGd1ZXN0X21lbWZkDQo+ID4gZG9lc24ndCBzdXBwb3J0IHBhZ2Ug
bWlncmF0aW9uIGluIGFueSBjYXBhY2l0eSwgaS5lLiB0aGVyZSBhcmUgbm8gbWlncmF0ZQ0KPiA+
IGNhbGxiYWNrcyBiZWNhdXNlIGd1ZXN0X21lbWZkIHBhZ2VzICpjYW4ndCogYmUgbWlncmF0ZWQu
wqAgU2VlIHRoZSBXQVJOIGluDQo+ID4ga3ZtX2dtZW1fbWlncmF0ZV9mb2xpbygpLg0KPiBIbW0s
IHdlIGltcGxlbWVudGVkIGV4YWN0bHkgdGhlIHNhbWUgcGF0Y2ggYXQgWzFdLCB3aGVyZSB3ZSBl
eHBsYWluZWQgdGhlDQo+IHBvdGVudGlhbCBwcm9ibGVtcyBvZiBub3QgaG9sZGluZyBwYWdlIHJl
ZmNvdW50LCBhbmQgdGhlIGV4cGxvcmVkIHZhcmlvdXMNCj4gYXBwcm9hY2hlcywgYW5kIHJlbGF0
ZWQgY29uc2lkZXJhdGlvbnMuDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzIwMjUwODA3MDk0MjQxLjQ1MjMtMS15YW4ueS56aGFvQGludGVsLmNvbS8NCg0KWWVhLCBzbyB0
aGUgb3V0Y29tZSBvZiB0aGUgaHVnZSBwYWdlIHJlbGF0ZWQgZGlzY3Vzc2lvbiB3YXMgdGhhdCB3
ZSBzaG91bGQgbG9vaw0KYXQgc29tZSBzb3J0IG9mIGVtZXJnZW5jeSBwYWdlIHJlY2xhaW0gZmVh
dHVyZSBmb3IgdGhlIFREWCBtb2R1bGUgdG8gdXNlIGluIHRoZQ0KY2FzZSBvZiBidWdzLiBCdXQg
aW4gdGhlIG1lYW50aW1lIHRvIG1vdmUgZm9yd2FyZCB3aXRob3V0IGl0LCB1c2luZyBhIHNvbHV0
aW9uDQpsaWtlIGluIHRoaXMgcGF0Y2guDQo=

