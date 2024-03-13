Return-Path: <kvm+bounces-11726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2253A87A5B6
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 11:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70D65B215AC
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 10:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD47F39AC5;
	Wed, 13 Mar 2024 10:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eG9kxVLc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D138DFB;
	Wed, 13 Mar 2024 10:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710325354; cv=fail; b=ZoM1d2TtOaWBUd82u1CsNVWE9Ly+efdOmps7qYQYcRzt9HFyqV/HwUPmq9qaIc1YjYURsMFWJz83UM7Vv0DP6fXpKH7RyEacTOD0p0PuK9C3SjA1x4r/C8TN54Q46zS7dpuYe7hbaT6/0kIKqfiYzjInOtg7B29iwL6Xod7K9eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710325354; c=relaxed/simple;
	bh=XgjJdauNy9e0L7vfv4Vew0lEAFjqehF24a5zKP4NzA4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E93XtPqXQEbb3oJ7Gh86X14as8vVpajTecvH4nluCELJBQu+R5QACJD2dzc2S+4IcQqioGWd/JYhN2WB99y9figjZbN9HuMeXKRprIG6OHYo5KvwRxI+Ki/fZKBql7FqTmGcQc1ZYOa63uf6X4+vMuiGNuJwjDf9xx5o7PUTB4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eG9kxVLc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710325352; x=1741861352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XgjJdauNy9e0L7vfv4Vew0lEAFjqehF24a5zKP4NzA4=;
  b=eG9kxVLcRLaULMZiu50yP5CW4hkRyIc7iBn3k4kiNVeBdklK+YGKLCf2
   +SBQ4nrmHIp0oQKeZk/GvQFCWXiZoIQolK5Rva5zYu1F7iVcD/xPOawpV
   yCUDAq97tT5iYil2x86vBNFdg7gqx0hfkk3lq0rjTZm7IZcEiCPzh8I1M
   +Mgx5gU5Heq0yt/YivVRC2lVj87/5nIPe+ZxJftppiuIAXqfT2rpMVYf3
   7VrVyd6UuGs7O+PeOKssHh5Kqyau2aKp3d/Dh1NTnbhunJmGK4XRiN/2B
   FJYfXzzgy1sbHa6DN5JgjqI8XdMS9VRrrZeNYN0cCGX9oOqDeYyVFrBPt
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="8850015"
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="8850015"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2024 03:22:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,122,1708416000"; 
   d="scan'208";a="16446268"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Mar 2024 03:22:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 13 Mar 2024 03:22:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 13 Mar 2024 03:22:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 13 Mar 2024 03:22:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtB/ABVwdzCkRa041E5X+FiAW4ifCGJCw0ClWRsFvE7PS9j+3IgMwxNg1402qluOja8lnaYcEBMVWDKnjJkmzndyCMSRXLtdYZW4NP94MCm4VOzYOZGxJvWgtx6I9/kFGHnmtueXKe/7rahO0saX9cNumF0J5ITH5O9gNXMW0v3N0O3aTpcKD13rkM2PgESi/jsdfUSXtGOqCGaCY/zVxyCO+pePEw9k0xooNfL/WFuiTa2BwSui4dH0MWvgYDBfcKMyzF6FeNKG9FLKvi4Ibqw8ClbmjjwhzfMSj9iHvxQcP0toyQANfxhnL5cWEh3pPmHCpYNSg7tST9yB4xAAwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgjJdauNy9e0L7vfv4Vew0lEAFjqehF24a5zKP4NzA4=;
 b=JX5ttShDohXwkF4j9Fd4ARRBGUEqLHL0JfVLUsYAh6WaWP7jMexI1fzoPOc/00pqx0Y6YiLntzwBeM+pRNxr8+ShzxYrX6KfkGMljIJqaDDrienog8yCM1vIMLcFLvCybOqmbr/SP0QHJ0xghbKJkPXKnMAvNOEOVJmAg6bcqFVJ53VzjQtdnZ/nIuSp2nTCSpaj9ivt7LaMXCyNnBLi+KGgUvSK6WB2J2lz/PVyL1mYxYGSKfLa4iEaTXyQRZgZrdWf3PkW+Ce2lNAGGkMB0Xh4q5rbavExucv+YCrS+KL3sCMp/zszpB3jfyw88XJidUUorRUQ2OVFg9QxmpHjog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH8PR11MB6706.namprd11.prod.outlook.com (2603:10b6:510:1c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Wed, 13 Mar
 2024 10:22:15 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7362.019; Wed, 13 Mar 2024
 10:22:15 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Mingwei Zhang <mizhang@google.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Aaron Lewis <aaronlewis@google.com>, "Jim
 Mattson" <jmattson@google.com>
Subject: RE: [PATCH] KVM: x86/pmu: Return correct value of
 IA32_PERF_CAPABILITIES for userspace after vCPU has run
Thread-Topic: [PATCH] KVM: x86/pmu: Return correct value of
 IA32_PERF_CAPABILITIES for userspace after vCPU has run
Thread-Index: AQHadN6+h0SzoySC40a7EERM5w84M7E1POrQ
Date: Wed, 13 Mar 2024 10:22:15 +0000
Message-ID: <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240313003739.3365845-1-mizhang@google.com>
In-Reply-To: <20240313003739.3365845-1-mizhang@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH8PR11MB6706:EE_
x-ms-office365-filtering-correlation-id: 41010bfd-6b2c-42ba-185c-08dc4347742e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /wnyAmZfRvTGei5HvFad45VQJQFMIGdTs4dQl2lqkf0yYXMXwAXl/N35zAnWCYVxpkbnn0M+TXrkUZUZHCTkivSIFZO/NgK0dWT4SDSn27IQuuCwt4fXa008YIk4zCuIYeLQP04L28w29vykcWhFgbGMkuBbqvsNyamq25IBscl0B4WGBaX8RVDnH/2oTgVPUaeqSYGit58II6yUtP/vjvhIpWKScaLXtgRAhojF0pqjmKAkeuv60pd+GX1ubxzSL1EVT5F61fTn7S7RkoxlkiwpQeCQCq7dF/yihTNNbHBFZ17jWOu7RkjP5DXuWwLd56ufbYuCDqEpVG2ptTYir8a01L3KWC03SzWXEqAKs5fCnN8TZzulwZkJxJ6Wcer+E3Y7l9HpQ7/OCqnJYKCqB2++ge1xxalYCAHh+dW02UjSIGHq/aovlcPU+pq8/EgJyPA2b14LS7UcWKWY7RJLgMweeDfc9X/PR19cCBGTohVWrvzNVnP27d/+DgePNKCsMV4UNnGUvBgXduNQX4YomA3ffndFD02N1B9ZaMm1FMuXqBAl+Zd3JYc8gYObUJZf8HNVlTb0TN9KwnOKvdHhXc6D26PqjS8x11daLU+FWLt4KVULyTuSq0dsQEPSffoRhFhFsDQ14k4aCf9bosnvEeBnNbLY61Z3u5P+qs4xRJoApZqkNjg1J3cPibHU1Kunq5Z8Xay+MeFdcryxp97aj/Ud5qiZ9g2GbeorXod2KHE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkM5NHM4L294SkpXUk13Wmcva3RMYWxyYzdrckpPM1RlbXlRRXVGVUNjMXB0?=
 =?utf-8?B?SUlFVDQ4eUd3Sml4UjZ5Yjhsb3RvR3k2cGdRc0pVaFZPcUhvMjcybVR6ZVlM?=
 =?utf-8?B?OVJ1WUxKZXZYTkZMUDNEQ2tnb0lxeWl5VmFzYUtXdlB1cE9Qa3RtUHRQYmVw?=
 =?utf-8?B?c3JrTHBpc0lGZHBvWFlESjNNK3ZXbjFhY2g5NXMvaitleU4yQmpFaWtUYk5S?=
 =?utf-8?B?TWhBb09yaWlETTE1NW8rZkNRUGl3RGRRdmRCM2hYc2ZBVmtFb2pmSy9jUVdB?=
 =?utf-8?B?T3FwdGp2bkQvdWlDNElubXVlMVBIOUZDYkx3Ty9tRG03b2EyR2NUbUJsNlRR?=
 =?utf-8?B?MXp4ZWFYa0NHVG5KVHNWZFpQbmpjeTVaQWgycTJ6WkV0cEJFdnFJNGV1S1lm?=
 =?utf-8?B?T1gyRzM5Mkc2TmM5NjI5L0pRL2VUeEpuNXA2RzlGcXNSRnczL2d2TFcxdXEy?=
 =?utf-8?B?bWFiRW9MVUZDYzBnUVA4NjhnTDlzdWozL3IxZDEzZ3grRCtuRzZHTTE5MzBK?=
 =?utf-8?B?WHkwblFlbm9hU095ZHQyRVJhbi9DMXpOOEhTaFJuRWtJMHYweWRaUWtacjRL?=
 =?utf-8?B?eERmaWYwQmpEZjRjZGdwOTIvcmttNHlBdWpWUk1lZ1VSS2h2T2lIUElvYUNZ?=
 =?utf-8?B?NTFUZm5wRlRoMThEUkpmdVB1UzZmS3ZBZC9iNHF3bXNNWjZ4MklEVDRaaXV3?=
 =?utf-8?B?NXg2cWV0R2hTc05zaGZydmpQY055eklOU0dqYTYvTGY3aFVjV1RCcExKcW0z?=
 =?utf-8?B?bU9Bakdqemt1aDc5SzY5UjR2ZlVyOWo4NlRZNHNsbFBvZHRxejNvVHBvbURR?=
 =?utf-8?B?WHNFTmhNR1NHUXlrcndMYkNZanJoWm1ITE84UkM2N1Qyb0Fmc00vcGdwRHQx?=
 =?utf-8?B?VldFSlMrS2dQTlUxY01MVVVjVUI2WUtlZk5BcGFjQ3RZSUpHL2FOdkdMa1Bn?=
 =?utf-8?B?MVFhZ3FPbktDdmcwOU5hMkx2RTNWbm1PNVJaYUFuNTgvWHM5bzBYZStXSThw?=
 =?utf-8?B?WEJLZkhXN3pUblYzK1pEYjEzTzJsdFJYUHd1Njl5dE1velFYSGczNEs3Mm5h?=
 =?utf-8?B?SXJCM20zRDVwbmJkZE44aysvS0VzN3MwZklYLzJBM0czM1dkQlo4cHdsb2Ft?=
 =?utf-8?B?MWMrUjNYYlJPNW5WcFA1alpFVHJ2UVUrNk1ObnBiTGVTMjRTZDRQSy8yRDhN?=
 =?utf-8?B?YXBYeE9PMjJzMkZXcE5KcnNXWVIra1JhbnhuYm5wNmFXSGt1MEZlTVA3WE9T?=
 =?utf-8?B?azlHRlFLb0xwWkxBa3d3UGZPVlBVbEhkdW9nYW1Ic01TNW1EV0dFZGE5dkNR?=
 =?utf-8?B?N2VRa1FhNnVtNEpNSlQ0VjZqZGJaeG43VXhzWnpFdkdVQ0ZJT0RqdnlxOWVr?=
 =?utf-8?B?V0pUQXBCcVpJdUZKR3d0MVBHVnhqbG1rZHNpYnllVGFBamNhYkpVVmRpVTFt?=
 =?utf-8?B?R0tpKytmZFZqaEFnUG1EWXFlSkRLdW5GYjNTbnprdU5GY1JvV1BEelpOUmE3?=
 =?utf-8?B?SWhmZXdjdEpzWEpOV0x2ZGswd2lhRHZLZWhLMUtoYncrWDhWSW55VDB2cUNi?=
 =?utf-8?B?d09aSjhGUUIxMy9zNGFiTnpuUHhGaUYzOERBdnlHTUlWeUx1dDcraVpuSmts?=
 =?utf-8?B?US85b0lrUHZNWUJYZWxYR1BRaXFoU05GNWc2UHVhK0RBLzRRcy9OaUErYVpr?=
 =?utf-8?B?L0VvZ0xqNnBDRXY2anB4OURKMURxa3VWVFMxRlpWSzVyOS95YW1uYmVOYUJu?=
 =?utf-8?B?eklJWmE2OUdxOFdTU2ZWci9hRFFEcnYrdEhOOFZQTkZBQmJ0dEFRZ085WUlw?=
 =?utf-8?B?OFhwUUMwd2c3L3pmcjJlSEhrdHBLWmtMK2E5RzhrSUZwZ0ZidDJpTDdVZmEw?=
 =?utf-8?B?alM4ZVllZFcrUjFzZWZ4dHNaOGtmeUpQZ1JDYmVqNDNqSzdXK3BKVjVRczIv?=
 =?utf-8?B?b2VkM3VPU0xOM2pORDZXbHZLR3VIbVhWUFZxMnVsZTRZMEpPNStZZ3kvdmQ0?=
 =?utf-8?B?dWZ4VTFlYTI3RVJLZU5zL3RKcnB1czNEN3h3Znc3Ukw4QkwrZndMRDZaL0pj?=
 =?utf-8?B?ZWZIaEx5YjhicndGQlFSNE5RL09yQ0dHa3N1SDdhYStOamRPZkVSYlVtd1h1?=
 =?utf-8?Q?mQrB0rWwdL7c39Gh+JZ7uTSfm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41010bfd-6b2c-42ba-185c-08dc4347742e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2024 10:22:15.0321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 24ah2zhS3NLFhrgWM89XZHJHYzZSvmahlHbaenK/6JgLZwU2fK2g5bkbAuzovMQQLKIQjyxgu4aQQoCvej1HSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6706
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBNYXJjaCAxMywgMjAyNCA4OjM4IEFNLCBNaW5nd2VpIFpoYW5nIHdyb3Rl
Og0KPiBSZXR1cm4gY29ycmVjdCB2YWx1ZSBvZiBJQTMyX1BFUkZfQ0FQQUJJTElUSUVTIHdoZW4g
dXNlcnNwYWNlIHRyaWVzIHRvIHJlYWQNCj4gaXQgYWZ0ZXIgdkNQVSBoYXMgYWxyZWFkeSBydW4u
IFByZXZpb3VzbHksIEtWTSB3aWxsIGFsd2F5cyByZXR1cm4gdGhlIGd1ZXN0DQo+IGNhY2hlZCB2
YWx1ZSBvbiBnZXRfbXNyKCkgZXZlbiBpZiBndWVzdCBDUFVJRCBsYWNrcyBYODZfRkVBVFVSRV9Q
RENNLiBUaGUNCj4gZ3Vlc3QgY2FjaGVkIHZhbHVlIG9uIGRlZmF1bHQgaXMga3ZtX2NhcHMuc3Vw
cG9ydGVkX3BlcmZfY2FwLiBIb3dldmVyLA0KPiB3aGVuIHVzZXJzcGFjZSBzZXRzIHRoZSB2YWx1
ZSBkdXJpbmcgbGl2ZSBtaWdyYXRpb24sIHRoZSBjYWxsIGZhaWxzIGJlY2F1c2Ugb2YNCj4gdGhl
IGNoZWNrIG9uIFg4Nl9GRUFUVVJFX1BEQ00uDQoNCkNvdWxkIHlvdSBwb2ludCB3aGVyZSBpbiB0
aGUgc2V0X21zciBwYXRoIHRoYXQgY291bGQgZmFpbD8NCihJIGRvbuKAmXQgZmluZCB0aGVyZSBp
cyBhIGNoZWNrIG9mIFg4Nl9GRUFUVVJFX1BEQ00gaW4gdm14X3NldF9tc3IgYW5kDQprdm1fc2V0
X21zcl9jb21tb24pDQoNCj4gDQo+IEluaXRpYWxseSwgaXQgc291bmRzIGxpa2UgYSBwdXJlIHVz
ZXJzcGFjZSBpc3N1ZS4gSXQgaXMgbm90LiBBZnRlciB2Q1BVIGhhcyBydW4sDQo+IEtWTSBzaG91
bGQgZmFpdGhmdWxseSByZXR1cm4gY29ycmVjdCB2YWx1ZSB0byBzYXRpc2lmeSBsZWdpdGltYXRl
IHJlcXVlc3RzIGZyb20NCj4gdXNlcnNwYWNlIHN1Y2ggYXMgVk0gc3VzcGVuZC9yZXN1bWUgYW5k
IGxpdmUgbWlncmFydGlvbi4gSW4gdGhpcyBjYXNlLCBLVk0NCj4gc2hvdWxkIHJldHVybiAwIHdo
ZW4gZ3Vlc3QgY3B1aWQgbGFja3MgWDg2X0ZFQVRVUkVfUERDTS4gDQpTb21lIHR5cG9zIGFib3Zl
IChzYXRpc2Z5LCBtaWdyYXRpb24sIENQVUlEKQ0KDQpTZWVtcyB0aGUgZGVzY3JpcHRpb24gaGVy
ZSBpc27igJl0IGFsaWduZWQgdG8geW91ciBjb2RlIGJlbG93Pw0KVGhlIGNvZGUgYmVsb3cgcHJl
dmVudHMgdXNlcnNwYWNlIGZyb20gcmVhZGluZyB0aGUgTVNSIHZhbHVlIChub3QgcmV0dXJuIDAg
YXMgdGhlDQpyZWFkIHZhbHVlKSBpbiB0aGF0IGNhc2UuDQoNCj5TbyBmaXggdGhlDQo+IHByb2Js
ZW0gYnkgYWRkaW5nIGFuIGFkZGl0aW9uYWwgY2hlY2sgaW4gdm14X3NldF9tc3IoKS4NCj4gDQo+
IE5vdGUgdGhhdCBJQTMyX1BFUkZfQ0FQQUJJTElUSUVTIGlzIGVtdWxhdGVkIG9uIEFNRCBzaWRl
LCB3aGljaCBpcyBmaW5lDQo+IGJlY2F1c2UgaXQgc2V0X21zcigpIGlzIGd1YXJkZWQgYnkga3Zt
X2NhcHMuc3VwcG9ydGVkX3BlcmZfY2FwIHdoaWNoIGlzDQo+IGFsd2F5cyAwLg0KPiANCj4gQ2M6
IEFhcm9uIExld2lzIDxhYXJvbmxld2lzQGdvb2dsZS5jb20+DQo+IENjOiBKaW0gTWF0dHNvbiA8
am1hdHRzb25AZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTWluZ3dlaSBaaGFuZyA8bWl6
aGFuZ0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAxMSAr
KysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXgu
YyBpbmRleA0KPiA0MGUzNzgwZDczYWUuLjZkODY2N2I1NjA5MSAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva3ZtL3ZteC92bXguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBA
IC0yMDQ5LDYgKzIwNDksMTcgQEAgc3RhdGljIGludCB2bXhfZ2V0X21zcihzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUsDQo+IHN0cnVjdCBtc3JfZGF0YSAqbXNyX2luZm8pDQo+ICAJCW1zcl9pbmZvLT5k
YXRhID0gdG9fdm14KHZjcHUpLT5tc3JfaWEzMl9zZ3hsZXB1YmtleWhhc2gNCj4gIAkJCVttc3Jf
aW5mby0+aW5kZXggLSBNU1JfSUEzMl9TR1hMRVBVQktFWUhBU0gwXTsNCj4gIAkJYnJlYWs7DQo+
ICsJY2FzZSBNU1JfSUEzMl9QRVJGX0NBUEFCSUxJVElFUzoNCj4gKwkJLyoNCj4gKwkJICogSG9z
dCBWTU0gc2hvdWxkIG5vdCBnZXQgcG90ZW50aWFsbHkgaW52YWxpZCBNU1IgdmFsdWUgaWYNCj4g
dkNQVQ0KPiArCQkgKiBoYXMgYWxyZWFkeSBydW4gYnV0IGd1ZXN0IGNwdWlkIGxhY2tzIHRoZSBz
dXBwb3J0IGZvciB0aGUNCj4gKwkJICogTVNSLg0KPiArCQkgKi8NCj4gKwkJaWYgKG1zcl9pbmZv
LT5ob3N0X2luaXRpYXRlZCAmJg0KPiArCQkgICAga3ZtX3ZjcHVfaGFzX3J1bih2Y3B1KSAmJg0K
PiArCQkgICAgIWd1ZXN0X2NwdWlkX2hhcyh2Y3B1LCBYODZfRkVBVFVSRV9QRENNKSkNCj4gKwkJ
CXJldHVybiAxOw0KPiArCQlicmVhazsNCj4gIAljYXNlIEtWTV9GSVJTVF9FTVVMQVRFRF9WTVhf
TVNSIC4uLg0KPiBLVk1fTEFTVF9FTVVMQVRFRF9WTVhfTVNSOg0KPiAgCQlpZiAoIWd1ZXN0X2Nh
bl91c2UodmNwdSwgWDg2X0ZFQVRVUkVfVk1YKSkNCj4gIAkJCXJldHVybiAxOw0KPiANCj4gYmFz
ZS1jb21taXQ6IGZkODk0OTlhNTE1MWQxOTdiYTMwZjdiODAxZjZkOGY0NjQ2Y2Y0NDYNCj4gLS0N
Cj4gMi40NC4wLjI5MS5nYzFlYTg3ZDdlZS1nb29nDQo+IA0KDQo=

