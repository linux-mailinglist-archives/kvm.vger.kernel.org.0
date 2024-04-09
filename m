Return-Path: <kvm+bounces-13989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B3089DB90
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:02:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B9C1C2136E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBE7130E50;
	Tue,  9 Apr 2024 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WddN2ZFp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1D4130A4C;
	Tue,  9 Apr 2024 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712671274; cv=fail; b=s9BC6qIzbGAAB6a3ALRlYp837lSpg2B3K7c0Im84a8GvHfJvWIOp+4y4lvYS/pkGh/THVa2HDqNhX2m6IA9Uv1iUzTn8txS7jqRiCZlS6bulJ13V5J3ko8Gf4VqyZ+tCI/Zr+a9r+hReaO4pFK2JtaBfxa0C3jCBmFFu7U4ruEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712671274; c=relaxed/simple;
	bh=EvdzloiBIUevh3S0MZrNdLJixzWt94Jt3zEKVQ8+CDE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kXUI5YMyzSwLrBJkELBJ9nCFNN7TCUuWZfrCVBC6LzCdqR5GARWL/zmu32iAhzxzNK2N0wswB2vvlgh2IkLuFKE7SC2TUeUtNTML66rYky2Nlhl1ZgEfX2/PePGJsSE6N4S7clWPDmziMMr/vHwXRZ/XxWvRFD51c12V656S/YM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WddN2ZFp; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712671271; x=1744207271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EvdzloiBIUevh3S0MZrNdLJixzWt94Jt3zEKVQ8+CDE=;
  b=WddN2ZFp4R+zgJgDTEY3Bbt201npQalQDJlc0ilDHzsxnJIDL7Ka99HX
   7oLw47XXrUqn7LQ0m1ZuPnOCYtOMILj06w3FZwnNgoD8XiuQEiia9oKhE
   eiCkGIZCrQGCXZ+zW5TgIPnWzTP8TRux9fBJZYkNinBTI/v+I2PsGOM5O
   A9dUXesdCepaaAKC56KqF0Ww3z6YOXHl+xqd/+NJWhZJO8wCoL7pmiXLP
   2yf8k7xqP9BnV87U7aeqyc41b6z+1IiK8Oto9QT0RC1llKuqvE2447TwH
   TZdmz+sKCI0Z7n2o2NXpTX8N1shhxRjV5S2J+V8stvPFaSt3iH0KWNc/1
   g==;
X-CSE-ConnectionGUID: y2VbGQ1yRdupKtsf3cTTAA==
X-CSE-MsgGUID: U4ayfpQqRs+iOYCR5s6acg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="8108817"
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="8108817"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2024 07:01:10 -0700
X-CSE-ConnectionGUID: mj62D8FIQ02AswNRmdm30Q==
X-CSE-MsgGUID: gkabsDL9RHqJNl6gT9ZzHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,189,1708416000"; 
   d="scan'208";a="43437980"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Apr 2024 07:01:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 07:01:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 9 Apr 2024 07:01:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 9 Apr 2024 07:01:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 9 Apr 2024 07:01:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2n5Q5yIMp5cxnlZAGMekzBfAUpAjT6ybBa+9bKx+mtsgndhD0LWjxPeBI4nzAii33Yy9LFdJlaGf9j5T/mXSkHKCUl+w8+lXJuCA6NMrHNb0rl5pXB2eBrCIwQOy9fn53CSk+i+LEDrXgbaaghXDLDk1Ngm2xcSJuf43t35YrMkCN+Vt9rIoV9Ffoo1gzqiPfqPYlSzi4Uz995aTtlcFdPs9rds5fQM8PfDClbYSH2F/WPYdG4LCP7m76s8oVwFyuNPGRPN67nSCrzbCx11ZBBXN+Fu6q940O17gdFb5VslJ+gGFFWnwX7yHfhLuSO0EwxBg3JcHe5pOLXIQ0AKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvdzloiBIUevh3S0MZrNdLJixzWt94Jt3zEKVQ8+CDE=;
 b=Iu4Yu5onDFDsWoTuVZg259juOD1PrZ9R8kuThZIp/j8h71nkXGghWpR2Zsqb6t7BD/tWO0hPYwanA9aw1fGt32kBAITARJibiHJCHz10ShcngruHx8YlHgn/OCOI7owSHnxiXZPQas8bG1Oq2xt5usUoqFBERau2NKlMN0RhVFugBp2vfGNWsseahVJ+te77h/nDsoIf213EdNa+Vs2MnPViKNCXFAXMpLRc6HBR3T+6tbLtaeQ04+M78cl5bAxnjEBa/vsU0AZACDqfDUmrSJQcjL+JAf51GbwlgqHDbxEk2e9vuIZbyixVTnjf46MwzH9aAWZHeXph4GI2yt5BfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 9 Apr
 2024 14:01:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Tue, 9 Apr 2024
 14:01:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo
 features
Thread-Topic: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for
 CoCo features
Thread-Index: AQHah60wsHP29hDi6kKJ9JlK2WL9i7FfKRuAgADUQwA=
Date: Tue, 9 Apr 2024 14:01:05 +0000
Message-ID: <b10851221f8f9c2a60de5d302c0f6d15f802d77a.camel@intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
	 <20240404121327.3107131-8-pbonzini@redhat.com>
	 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
	 <ZhSYEVCHqSOpVKMh@google.com>
In-Reply-To: <ZhSYEVCHqSOpVKMh@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6653:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ZgNagSdgMbGYNXtObcJ4n7yzucguMwsQ5zyN4v7taBl0Kokx8ZScq4OrHOJeKKJBFSlwfP+wA4jByTTfFNaTZ5LADTM5EdNuNtBzzvcp04bLGbwUkgUus0f9JOX5fxpjDs+mCbpFJEf2Y4KwLr7JMoYcu8yUEB91NVW19K7Lt6afeJwC6YucDs/K81HpmmuJ31LtSe1DKp/IJLyCyJNynbfMDntCZSfaiDAyYzLpwCNQoTqrNRfB0ulHxuGJBqQpgH1HYD+cYnCndL4Lay62Hgse/dlNuTWWvCNTZZuuwbW5mAuP7lpy65pjiD7v0XzEE4DuSt+DnPJPzh9/F/MWWzH8jhH9aiG6pqoLT4ogJe/7+JbrjT09etsg1nr/Ro7Ws6fJ1jiCOOoycCT8hzZ54Rrphb3AbhnPbWN4TY8SwcOevU1NWR/0ivdXjQNgsXnVP3S64FsfMXAn5lDAr66ZAtXwMVx4VM0iPSJMgxm93n7Bc+ru105fBcUpXs6rh9JJlr40o9Y41D6MuylQd6rRaw3DXYYrRGtGO9pj73yNQN86g2XYoezbShwjFUglrr+PNyg/uuLAixcRedhMmbj52nNPsnvefbVjj4dLCpvyc8k7BC5xsf4aOaVYbXFu/DoTapqg+cOF1X8CPxHYSA996ILPjjPjshi7S2mmyOIc7c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YngvclRiQjZaYzhvZ1pxRW5tbG1DRkVPU09mSlg1SG1tWHdteXU4cHo3SWla?=
 =?utf-8?B?U25LdHR5aGZjOGV5MHE2eXMwdk1WM2g5M1RVNk1OR0M2MGJEQ3pMY0hBR0ts?=
 =?utf-8?B?QU1sSXdlZ2F5RUNKQ0QvTkhQRmdZUmZTN2UrQThlZ2ZTNk54UW1UbVV2bDJu?=
 =?utf-8?B?NnJwN1BXNmM2VzQ5TFJHQzlJbWlxbnpFWXdiZjdndW1ISHdUVnVyS0N4RUdL?=
 =?utf-8?B?RGV5dW5lRFhMRkpLalBYSzlWZ2tpdTR2aWtaUmxzNWZNLzRtNVJDcmI5cllB?=
 =?utf-8?B?TFlrbmJxekJVbmJoWTJpTUlzT1hPdkdENEk1dWdLVmd2blNoNHR6WGkzaGd4?=
 =?utf-8?B?RmpFaXViNWYxSEdDYTJ5ejVkZFlROU1Oc0lMNXFaNzM4TkRRdzlkQlFuMnVy?=
 =?utf-8?B?KzBsL2tvbjdTS0l3RkRZZTloQ29qUUtpYi9kMDhXU2dJR3ZVL3QvZU9oUUdh?=
 =?utf-8?B?Sm9UeVdURXZOVjEvNGJoNldGOFI3OUtDVWxuVFAwNk1FM0tVOFR4eGVVVGJU?=
 =?utf-8?B?TE5oZHZqbG5yWHZJTU1iTjBvbFJzb2UxOVkvMDV3V2dJWmVsQXFVMnB6RHRL?=
 =?utf-8?B?b3RXRDNrT2Jvb2RyN3RsRjRTVGgxZyt0OXR0RW1VckpONlhjbGhzbWQyKzdV?=
 =?utf-8?B?SmRsMmR6cXdDY1N1QkpPQkJIUEVJRHN5MEk4YWZiVmV1TkRJaTk2ZjlGQnhY?=
 =?utf-8?B?dHpsdnJBeXlPV1ZmU08zdjQ3SGFYRlhFUldxYlRKSmtqLzQ0VHplRWhTRnpk?=
 =?utf-8?B?VkdrYVVKcHR5VDB0M2tVMlFFRmRwNmNMUERrRzlubmFlVnoyZ0tUa3lIejFQ?=
 =?utf-8?B?blhyeFJYL2RaNkZFc04wVWRHblBqQ2wySlV6Q056M1IrYlNCR2s5Z2hjN2Uw?=
 =?utf-8?B?NmVQNllrSnova0xNc2hjMFhqWStMcmJDeUNiUEVjcnQ1WHkzTklYSWc4OHRS?=
 =?utf-8?B?U3hDckNmVFVlaHFzeDVmK2NRdDkyby8rWE1sdXFDazVXM0hMUEpDSkhKZkV3?=
 =?utf-8?B?d0ozQzI3R3NxeVlnZGlyTCtyRjVaTnAwSlMvNEdWeHBkRy9TYXZDVVJjMzFN?=
 =?utf-8?B?V3ZtNU5nMHNJVEZEcEdWWXc5bVE4c01JU0VmVmlldENZMUd2cndBUTZqTG1j?=
 =?utf-8?B?bW1yVU1ROHZuRlBjQzczUG5Wa3NrV21ML1Nualh0a2VnRWZJVUIwYlNVWnhT?=
 =?utf-8?B?Mm1kbnUvZVk0RERzMmc5ekVpQlRQZ0RnZktyRFpSdnlJMmlHMW15cndXN2FZ?=
 =?utf-8?B?OExzcmhMKzY3dXMrMEFoRHNyTFNMa2d3SExtN0QrNDdOVzBPWlE0VVkvNTZ5?=
 =?utf-8?B?ei83Wmt2d2o3KzNCNGhNbjB3OElnVHhGdkF2dEc3dGY4NGxUNnBqYW1yWVBO?=
 =?utf-8?B?OHNnSWpqU2pMaGNZaUdaMWJlMGdKTHFvVUVKVnNNMFo0L0NQbm9SRklCWTVq?=
 =?utf-8?B?eFVGNVkvY1loL1hJY1ZwRzc4WGREWVlHTHJxeGNWOFMwOW9PWFlpd3RkVGJT?=
 =?utf-8?B?SkpVV2dDT2VSd29ldk51dndOdlZ0OGNQSDlCNzIyMk5BTjM2N3NwQnBJTVRx?=
 =?utf-8?B?RFprd1JrRThXNldpYldPejhoMVlacDk2OUxOOXJZL2RoeHE5NnU4U0xkdFF4?=
 =?utf-8?B?VUhneVJXS0FEYXM0QlVjKzM3T0VObWxGTENrREpJU0V6bVRUNWFxYm8yOFZQ?=
 =?utf-8?B?aUJ1cVBQc3ZrN3JKSWpmTm5lN1RLMWgrOG9rUExLRUt1YnFaeTRWV2d5dCsw?=
 =?utf-8?B?ZVpxTG00ZXlXUTBlMlFDTU9HUld0NnpDNzVGSk8veCtvOFhRVVVFRTlub281?=
 =?utf-8?B?eWZMZXVyK243WVFCVmVLc2xYU08yTVdIZ0d5UVZtMUkxQlhlMno0SitBKzJF?=
 =?utf-8?B?b3BYU2lOM3RKM3VteHRpY2FhbjlJSFUwVE05VEdEK0ZVUUF5UytKOERTdXZq?=
 =?utf-8?B?SEtIdklzaWNSbWIydG5DbHllekt3Q2pvbStaY211Vk5EcTA4ck02Z2JLMmxz?=
 =?utf-8?B?RWU2eVhnOTgyQXBIeHZSeFJlQ2dNdDU0RHBvZVczNXNQa0hSVndOQXMxUmsr?=
 =?utf-8?B?djdFaXdITklvOWZsRVUxTU9TdmZrdkhCT3NGUjlMekJ4THo1Q0pZMmZrL0RJ?=
 =?utf-8?B?R09DVk1yU1lzSnBZWnUzdTBkbE9UdVVGWnJjZWJXYlZhQzVqN2JUQzRLRVkw?=
 =?utf-8?Q?1hqUpLxxsc42rEUIMCmWkqQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B3883E94CDCCD44A9E46443CCE4C3872@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd891a8d-ac57-406d-efd5-08dc589d7fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2024 14:01:05.8207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfmjNw9bx5xIfv40FFUupxkrINoh4P7lJJhu/2obILBO6do9k4fME6fynokRpf3KGpb1i3WL9jxi3gvbmPOr/FgMaM+yJbYI503f6IvXTuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDE4OjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gV2hhdGV2ZXIgeW91IGRvIHRoYXQgaXMgVERYIHNwZWNpZmljIGFuZCBhbiBp
bnRlcm5hbCBLVk0gdGhpbmcgaXMgbGlrZWx5IHRoZQ0KPiB3cm9uZw0KPiB0aGluZyA6LSkNCj4g
DQo+IFRoZSBtYWluIHJlYXNvbiBLVk0gZG9lc24ndCBkbyBhIHRhcmdldGVkIHphcCBvbiBtZW1z
bG90IHJlbW92YWwgaXMgYmVjYXVzZSBvZg0KPiBBQkkNCj4gYmFnZ2FnZSB0aGF0IHdlIF90aGlu
a18gaXMgbGltaXRlZCB0byBpbnRlcmFjdGlvbiB3aXRoIFZGSU8uwqAgU2luY2UgS1ZNDQo+IGRv
ZXNuJ3QNCj4gaGF2ZSBhbnkgQUJJIGZvciBURFggKm9yKiBTTlAsIEkgd2FudCB0byBhdCBsZWFz
dCBlbnRlcnRhaW4gdGhlIG9wdGlvbiBvZg0KPiBkb2luZw0KPiBhIHRhcmdldCB6YXAgZm9yIFNO
UCBhcyB3ZWxsIGFzIFREWCwgZXZlbiB0aG91Z2ggaXQncyBvbmx5IHRydWx5ICJuZWNlc3Nhcnki
DQo+IGZvcg0KPiBURFgsIGluIHF1b3RlcyBiZWNhdXNlIGl0J3Mgbm90IHN0cmljdGx5IG5lY2Vz
c2FyeSwgZS5nLiBLVk0gY291bGQgQkxPQ0sgdGhlDQo+IFMtRVBUDQo+IGVudHJpZXMgd2l0aG91
dCBmdWxseSByZW1vdmluZyB0aGUgbWFwcGluZ3MuDQo+IA0KPiBXaGV0aGVyIG9yIG5vdCB0YXJn
ZXRlZCB6YXBwaW5nIGlzIG9wdGltYWwgZm9yIFNOUCAob3IgYW55IFZNIHR5cGUpIGlzIHZlcnkN
Cj4gbXVjaA0KPiBUQkQsIGFuZCBsaWtlbHkgaGlnaGx5IGRlcGVuZGVudCBvbiB1c2UgY2FzZSwg
YnV0IGF0IHRoZSBzYW1lIHRpbWUgaXQgd291bGQgYmUNCj4gbmljZSB0byBub3QgcnVsZSBpdCBv
dXQgY29tcGxldGVseS4NCj4gDQo+IEUuZy4gQ2hyb21lT1MgY3VycmVudGx5IGhhcyBhIHVzZSBj
YXNlIHdoZXJlIHRoZXkgZnJlcXVlbnRseSBkZWxldGUgYW5kDQo+IHJlY3JlYXRlDQo+IGEgMkdp
QiAoZ2l2ZSBvciB0YWtlKSBtZW1zbG90LsKgIEZvciB0aGF0IHVzZSBjYXNlLCB6YXBwaW5nIF9q
dXN0XyB0aGF0IG1lbXNsb3QNCj4gaXMNCj4gbGlrZWx5IGZhciBzdXBlcmlvdXMgdGhhbiBibGFz
dGluZyBhbmQgcmVidWlsZGluZyB0aGUgZW50aXJlIFZNLsKgIEJ1dCBpZg0KPiB1c2Vyc3BhY2UN
Cj4gZGVsZXRlcyBhIDFUaUIgZm9yIHNvbWUgcmVhc29uLCBlLmcuIGZvciBtZW1vcnkgdW5wbHVn
PywgdGhlbiB0aGUgZmFzdCB6YXAgaXMNCj4gcHJvYmFibHkgYmV0dGVyLCBldmVuIHRob3VnaCBp
dCByZXF1aXJlcyByZWJ1aWxkaW5nIGFsbCBTUFRFcy4NCg0KSW50ZXJlc3RpbmcsIHRoYW5rcyBm
b3IgdGhlIGhpc3RvcnkuDQoNCj4gDQo+ID4gPiBUaGVyZSBzZWVtcyB0byBiZSBhbiBhdHRlbXB0
IHRvIGFic3RyYWN0IGF3YXkgdGhlIGV4aXN0ZW5jZSBvZiBTZWN1cmUtDQo+ID4gPiBFUFQgaW4g
bW11LmMsIHRoYXQgaXMgbm90IGZ1bGx5IHN1Y2Nlc3NmdWwuIEluIHRoaXMgY2FzZSB0aGUgY29k
ZQ0KPiA+ID4gY2hlY2tzIGt2bV9nZm5fc2hhcmVkX21hc2soKSB0byBzZWUgaWYgaXQgbmVlZHMg
dG8gaGFuZGxlIHRoZSB6YXBwaW5nDQo+ID4gPiBpbiBhIHdheSBzcGVjaWZpYyBuZWVkZWQgYnkg
Uy1FUFQuIEl0IGVuZHMgdXAgYmVpbmcgYSBsaXR0bGUgY29uZnVzaW5nDQo+ID4gPiBiZWNhdXNl
IHRoZSBhY3R1YWwgY2hlY2sgaXMgYWJvdXQgd2hldGhlciB0aGVyZSBpcyBhIHNoYXJlZCBiaXQu
IEl0DQo+ID4gPiBvbmx5IHdvcmtzIGJlY2F1c2Ugb25seSBTLUVQVCBpcyB0aGUgb25seSB0aGlu
ZyB0aGF0IGhhcyBhDQo+ID4gPiBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkuDQo+ID4gPiANCj4gPiA+
IERvaW5nIHNvbWV0aGluZyBsaWtlIChrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9W
TSkgbG9va3Mgd3JvbmcsDQo+ID4gPiBidXQgaXMgbW9yZSBob25lc3QgYWJvdXQgd2hhdCB3ZSBh
cmUgZ2V0dGluZyB1cCB0byBoZXJlLiBJJ20gbm90IHN1cmUNCj4gPiA+IHRob3VnaCwgd2hhdCBk
byB5b3UgdGhpbms/DQo+ID4gDQo+ID4gUmlnaHQsIEkgYXR0ZW1wdGVkIGFuZCBmYWlsZWQgaW4g
emFwcGluZyBjYXNlLsKgIFRoaXMgaXMgZHVlIHRvIHRoZQ0KPiA+IHJlc3RyaWN0aW9uDQo+ID4g
dGhhdCB0aGUgU2VjdXJlLUVQVCBwYWdlcyBtdXN0IGJlIHJlbW92ZWQgZnJvbSB0aGUgbGVhdmVz
LsKgIHRoZSBWTVggY2FzZQ0KPiA+IChhbHNvDQo+ID4gTlBULCBldmVuIFNOUCkgaGVhdmlseSBk
ZXBlbmRzIG9uIHphcHBpbmcgcm9vdCBlbnRyeSBhcyBvcHRpbWl6YXRpb24uDQo+IA0KPiBBcyBh
Ym92ZSwgaXQncyBtb3JlIG51YW5jZWQgdGhhbiB0aGF0LsKgIEtWTSBoYXMgY29tZSB0byBkZXBl
bmQgb24gdGhlIGZhc3QNCj4gemFwLA0KPiBidXQgaXQgZ290IHRoYXQgd2F5ICpiZWNhdXNlKiBL
Vk0gaGFzIGhpc3RvcmljYWwgemFwcGVkIGV2ZXJ5dGhpbmcsIGFuZA0KPiB1c2Vyc3BhY2UNCj4g
aGFzICh1bmtub3dpbmdseSkgcmVsaWVkIG9uIHRoYXQgYmVoYXZpb3IuDQo+IA0KPiA+IEkgY2Fu
IHRoaW5rIG9mDQo+ID4gLSBhZGQgVERYIGNoZWNrLiBMb29rcyB3cm9uZw0KPiA+IC0gVXNlIGt2
bV9nZm5fc2hhcmVkX21hc2soa3ZtKS4gY29uZnVzaW5nDQo+IA0KPiBZYSwgZXZlbiBpZiB3ZSBl
bmQgdXAgbWFraW5nIGl0IGEgaGFyZGNvZGVkIFREWCB0aGluZywgZHJlc3MgaXQgdXAgYSBiaXQu
wqANCj4gRS5nLg0KPiBldmVuIGlmIEtWTSBjaGVja3MgZm9yIGEgc2hhcmVkIG1hc2sgdW5kZXIg
dGhlIGhvb2QsIGFkZCBhIGhlbHBlciB0byBjYXB0dXJlDQo+IHRoZQ0KPiBsb2dpYywgZS5nLiBr
dm1femFwX2FsbF9zcHRlc19vbl9tZW1zbG90X2RlbGV0aW9uKGt2bSkuDQo+IA0KPiA+IC0gR2l2
ZSBvdGhlciBuYW1lIGZvciB0aGlzIGNoZWNrIGxpa2UgemFwX2Zyb21fbGVhZnMgKG9yIGJldHRl
ciBuYW1lPykNCj4gPiDCoMKgIFRoZSBpbXBsZW1lbnRhdGlvbiBpcyBzYW1lIHRvIGt2bV9nZm5f
c2hhcmVkX21hc2soKSB3aXRoIGNvbW1lbnQuDQo+ID4gwqDCoCAtIE9yIHdlIGNhbiBhZGQgYSBi
b29sZWFuIHZhcmlhYmxlIHRvIHN0cnVjdCBrdm0NCj4gDQo+IElmIHdlIF9kb24ndF8gaGFyZGNv
ZGUgdGhlIGJlaGF2aW9yLCBhIHBlci1tZW1zbG90IGZsYWcgb3IgYSBwZXItVk0gY2FwYWJpbGl0
eQ0KPiAoYW5kIHRodXMgYm9vbGVhbikgaXMgbGlrZWx5IHRoZSB3YXkgdG8gZ28uwqAgTXkgb2Zm
LXRoZS1jdWZmIHZvdGUgaXMgcHJvYmFibHkNCj4gZm9yDQo+IGEgcGVyLW1lbXNsb3QgZmxhZy4N
Cg0KVGhlIHBlci1tZW1zbG90IGZsYWcgaXMgaW50ZXJlc3RpbmcuIElmIHdlIGhhZCBhIHBlci1t
ZW1zbG90IGZsYWcgaXQgbWlnaHQgYmUNCm5pY2UgZm9yIHRoYXQgMkdCIG1lbXNsb3QuIEZvciBU
RFgsIG1ha2luZyB1c2Vyc3BhY2UgaGF2ZSB0byBrbm93IGFib3V0IHphcHBpbmcNCnJlcXVpcmVt
ZW50cyBpcyBub3QgaWRlYWwuIElmIFREWCBzb21laG93IGxvc2VzIHRoZSByZXN0cmljdGlvbiBz
b21lZGF5LCB0aGVuDQp1c2Vyc3BhY2Ugd291bGQgaGF2ZSB0byBtYW5hZ2UgdGhhdCBhcyB3ZWxs
LiBJIHRoaW5rIHRoZSBkZWNpc2lvbiBiZWxvbmdzIGluc2lkZQ0KS1ZNLCBmb3IgVERYIGF0IGxl
YXN0Lg0KDQpXZSdsbCBoYXZlIHRvIHRha2UgYSBsb29rIGF0IGhvdyB0aGV5IHdvdWxkIGNvbWUg
dG9nZXRoZXIgaW4gdGhlIGNvZGUuDQo=

