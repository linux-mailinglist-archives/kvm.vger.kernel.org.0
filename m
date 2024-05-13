Return-Path: <kvm+bounces-17312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73DF58C4136
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BCDB1C22E49
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAB61509BD;
	Mon, 13 May 2024 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eTNVTSmd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA414F9CF;
	Mon, 13 May 2024 12:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605010; cv=fail; b=IbFJ4gMMxYz1Dpd2ki3t9gYF1+GzzfUPqms+uRsp/nPApyZTjLEz+JJ7ktDYo74923KF5UQlder9UIredSkVTCRDImxh4nojHsNNc26J++thl5eXNmDGO4dV4F0d6HvX5JU1vLZ5KvRSPAjS/4i84kWMsQjCbJnHtBKEXgq37kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605010; c=relaxed/simple;
	bh=YKunlTIDKXprbRCSV6cCI3MmsUaZPKW+avGaq7xNkzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pj8C9oDdyWlEaO6YAP7+QcpHEHapy9jTmAaRBmCV7jwPrbFbs3LNlxewBrv0oDD0BklpyZcD4ExcTAbybS9uhTgeN4RJzPKX0hhCjXjjugjkan7GXYfxB0yIE42WPVZvBaYMWVoBcSkJ7lDmr9JoKVkTYS7oWOMeKShhGSU04uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eTNVTSmd; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715605008; x=1747141008;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YKunlTIDKXprbRCSV6cCI3MmsUaZPKW+avGaq7xNkzo=;
  b=eTNVTSmd8NydZ0JYQRiClok7m1vN5JBmXbSD/yl83lI5WGd9Jn4mnD9r
   PjzwxihTfJFM/96hk0QQI98dUmfr8z4+jn0ofg2sXRsa5X4DGaLqJMOtb
   YotcRuP+9RG7waaxGWvjxs8UcBuILUurFdB/g2eMkP3Cws/R+z92ljMvt
   i5fzpaVdULbpOPY5xGZVvGxXjDE+YkcwaQ5EqbiekNMUiPxFkqeuil6IF
   0/qExvs8bDrWe1vsMEtKh/5CZYqDncmX1H8GKs6UgqPu1k8KoFYzAfY6X
   g8dSEbnYFOAioTF8K8wCbIR6p06cTpwMjGAUXwdsLg4JTdKHy7O+MOBah
   w==;
X-CSE-ConnectionGUID: osegzywHS1OWJG6R9ag9RA==
X-CSE-MsgGUID: ll0xiE8jRviTLDN6UjwHQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22935585"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="22935585"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 05:56:48 -0700
X-CSE-ConnectionGUID: TaclVbLlRq6m64ZVi0kCYw==
X-CSE-MsgGUID: M1v43OCMSsiBZakmOEJWCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="53538457"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 05:56:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:56:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 05:56:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 05:56:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VegC5LU7hlsPf7mXXDo0cOo2ZWFMaqCIqrXypV3Y5Cuzpc/iFaEk/BCklmW/0+SY+ONkLyi7qR+J/IGoX4xV3R01bPzbnRi/CgtcnH2VXDdt2R5rfelnWz3RRZVEY8ATmsndX6wQCni7/cCIMsAQJypBoI/aS3OBFJK9wiC/j54tF3DyEVjXoQ9RmNzut1c/MUx/ObboKdWW0/8n9CF4Bqn7/N8y1BQ+feRE16UZgtN7SBmEM/ZFgpEhhHnnwJ1uBsNqr+kp8txMwNFEcE15Lqyk+pNinMj3p8FYsS0O+f4Y0yDZ7w9RaFuSbv4ktFEVxmO8OVaYpfSNx3kGh0S8eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKunlTIDKXprbRCSV6cCI3MmsUaZPKW+avGaq7xNkzo=;
 b=CK6O2GgxTQFEDsevkZhbLp8cJQv9AoguzAsy20Irzb5gOrlCt68ENteTmpdihozWoYtwmRuGDEEVomfrFXuTtAX5SvqWZhk41PsOK18Xl9++xU/LK5m2TDRukQfu0L82w6qyKl9+rIkDl8Ynepqqyrb94IP/zvsBr/SuvybSe1utoZ9/X4yqmhDjA/c6br7HhZSJSUeNZ0dMTSH04QuUcEDahzQXHiJS7YsVsHk8zmH5qpyrXqB8spIbmIMTdO3Pf8cep2h5pkfJ2k3WJb050XJ0qcQe1SpjaGiCqtMCc3pi0OR7SA0T8j+vWSQQniXCTltnYdHgBUbdZZi4CngtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8246.namprd11.prod.outlook.com (2603:10b6:208:445::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 12:56:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 12:56:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Topic: [PATCH 3/4] KVM: Register cpuhp and syscore callbacks when
 enabling hardware
Thread-Index: AQHal2oZ96dGW+wLWEKQlyVIplybDrGVOy2A
Date: Mon, 13 May 2024 12:56:45 +0000
Message-ID: <d73b1e18c75d7f1370c3715dcaf46746becd5d3b.camel@intel.com>
References: <20240425233951.3344485-1-seanjc@google.com>
	 <20240425233951.3344485-4-seanjc@google.com>
In-Reply-To: <20240425233951.3344485-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8246:EE_
x-ms-office365-filtering-correlation-id: 15afe6d8-d6bc-4cc8-c469-08dc734c251d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WnBCRDhqR0szQmRUekgvdlJLLzNzSEoyK2ltYmptRTUzcGZuOEZ0MldSbHZU?=
 =?utf-8?B?bk1uNlhmR0M3Mmd2alhhMVZ6TWtHSW44TmorR1duZHFiY21ldk9FdXhnOFhD?=
 =?utf-8?B?VUY4QUZBQklQTmJ4RnhmWkxLOWVwdTNGamM2OXl4QS9KU3Y1aVFTTHRvT1V3?=
 =?utf-8?B?M1Zpc0E0Uy9VWS9WQkxjaEtoWnh2R2JPR2J1TkFLVnVPRFZyT0s2WXBKWjBS?=
 =?utf-8?B?L01OOGtpdlVnRWRDY2tOeGRqMldKOGtvUlBaQ1JjbWF3aVpXeTVGbmZxQlJU?=
 =?utf-8?B?QVZWN21YVkJ0VzlWZ1dON2lWbDVzc1FoRDBPbEZQaHMxYlF3eFNQWWpIcUZC?=
 =?utf-8?B?TG56VmlFcjZ4dGlETVRWNkJURDVaUXdZZXhLcEZPSWY5NDNJdG9NbFAzcGEz?=
 =?utf-8?B?M0hzMTQ2NEJJd2k5aytlMG9FejlTZzN1T2VHbTBUOHZSc2wxUVBCVEN0ajhh?=
 =?utf-8?B?N0wwemtNMGU0Z0pNaHNWUEZqSXFhNmZjSFBnV2ZGL1pQOWpLRC9aazlEL1hF?=
 =?utf-8?B?ZFdZdVVrUk9kUURHdU9GYWtnWFZFbXZoTWkwaXpibE9wdEdiQVRueE1XRGRs?=
 =?utf-8?B?VURKSVVkTjFnV0pVaFpDTlBkeFVoUXoxVlVRSFdONS8wY3VDMlJLNU9tSmJ1?=
 =?utf-8?B?cmowcWhpbGxPSit4YVNXdlFYVU1jYmxxZExoME5rNitWU0NJZkNCTStNdHZK?=
 =?utf-8?B?ejY4TkZ3VDhLUGRyWlpwVS9vT2FvQnREbWV1cC9ZRFN0UmZPWWRyaWh6Wit6?=
 =?utf-8?B?S2VaR1BVTkNVSVhJenpwWEZFNHNkVjBFandISGo4NXFVcGcrZjNWWWtKU2Nv?=
 =?utf-8?B?WnJSSnE3VktzNExNTTJ3eGV4anFlODJHTWtGNjR2Rzl6QTZXeFVocHV4V0Jh?=
 =?utf-8?B?b3VBa0Y4K1F0ano0SXNLYU45dnZDWjYvL3JTWDQ3S0hPaWp6YmNZQi9pWVRT?=
 =?utf-8?B?MkdYbndQa2RWazkrQlhqVTBWN1A0UjhLc3J5Q3FZZUdaQU16Q1M0bTV0Nndy?=
 =?utf-8?B?d2oyZHFnVjB1QVNvVXFvWll4aTZrRWUxQjI0K0ZKdVQ4Y2xUWDZwSmNyc3JY?=
 =?utf-8?B?MkJvNkhETnp5MXdyb1o0MjRiRk1WbmhsTG1ZdDVGZVFXVFhSNmY1Qmg0TGkx?=
 =?utf-8?B?aDVjWGdJOE5JVXVPa3Fya0pyaVV4aFNmVXNLcDJGZXpOUWNsTG1nNXgwS0c1?=
 =?utf-8?B?aHdaNk9KLy9VNEpxT3R2QTVVV0VsTlJob2g2K0ZVaVJheGpWMFlkZDNMTUdO?=
 =?utf-8?B?ZGxSK2d4WkxlVnpFZXdrYlJCR2I0cTd0aHhKRGVNOUdtUldwbFliVkFvQlZi?=
 =?utf-8?B?MzN3RWV0M0R2a3VQM1IxQ1YyK2pNcmNWN2Z5NlJvaXNoWnRJUVNkMDgwWHcy?=
 =?utf-8?B?cm1YNXF6dTN2K2lhN2ZlOHdVTjdlZS85Sjhib29SQ3RvODgzTzVqamZLUlYr?=
 =?utf-8?B?N2s0bGVwZDA0Y3BsdVJoS0YzUFY4MUhGSlNwTU9VZEtOcUpOclpXNUZzNThO?=
 =?utf-8?B?bi9vRGw4bDZUWjhOK1pvSWozVkd6cjlOa2VxdjZqVzZmbkROanpWbmVTRlRT?=
 =?utf-8?B?WVpqQmVqbmVpakNGUkZvZEZPSEVudXZuL0N4RjBLS1JuVFllWlJnS1R4YmpH?=
 =?utf-8?B?cjlTcVN5cHFxTlA2NzJmYkZOM01NQkkrZFB5UlZ0WTdDK2FZdlBDTWR4bUgw?=
 =?utf-8?B?eGFrd3A3NitNVUJneDNhUHpCR25uTUtLeVBQbGhYcU15d284RlF4U2VEOW0z?=
 =?utf-8?B?NFdYMllySndOVGpHbGR0dmhLQkNvNlcvc3VlQWpYVk12eVdrWTBiQ2d0czRD?=
 =?utf-8?B?elRzbWFOdlBpaGhpNFBqUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlM3MWNrb0JReEtvcjRWODZQU1d2QjdQdjY4Qk45SmdGQ3NNcnpDQ1VMZUNl?=
 =?utf-8?B?TFdGQ1FOY3ZqMkVWMFFBOFIxMXg0dzNubGxRWkNQdmRUc1EzZ21vL1NGSFdz?=
 =?utf-8?B?N3NMdDlwQ2dPaGlWV05LUkhGNnErZnJQZWR1SFd2bUgvNENDTDJ5dTJzQ0tq?=
 =?utf-8?B?aEEzZjdqZzJNS1JJOU4zTkU4QkZSVG12ODZqZ1VkdzMraUxFY2tBODJVeGI3?=
 =?utf-8?B?dFVTNHY0RnJTU3VxNXAzb1BVUzZQWGE5UU9KQVJtT2VKRjhUUXlFTlIzUzc5?=
 =?utf-8?B?enpUcng2dG9GSmw2eXBBb2FIRHpRVkhKVjNJOS9nb3dtcHNwVU1NcXJQQU15?=
 =?utf-8?B?MXp4QUdkZUNkczRGL00rQ3pIUTg0VUs0QXE4VTd4R2RHS2FNSE00eklGNE54?=
 =?utf-8?B?SzB2UmREVjQxK0xzQ2RaWjNGRDRFdVF3VlMxMEYrMVh2T0UxMkR2MGJHSkxo?=
 =?utf-8?B?U2hnMVNNZ2pEeDYreWpiOVNUM3ZVSWJxVWxCeVVsNXdPYXhnbjZGTzlTQ3gz?=
 =?utf-8?B?M3RGUDc0aC9CdzVhRzlVVmdwcnpMSGRHTWQyZjFHWmh5Q3JBa01qWDlBRmY3?=
 =?utf-8?B?cVhmRk5laitDTWV5MGdEKzZ3WEN0QThib1N3OFJqSVJCRkZsRlNhc2hMZUZk?=
 =?utf-8?B?VmhtR3JTWkpWVmlNckFVQStQR0JWMjBFZ0k5WE1UR0wvdGErQUFpK0NMdk9U?=
 =?utf-8?B?cldFWisvSU5Yd3dyK3NvZkcvdUt0MzgvMzZaT200Wk1talFjUHhtVHZ0M3Z0?=
 =?utf-8?B?Y0tjOTlROFdVK25Rd1dtZ1MvTkRVZ2pWYXY4b1R1OFg4YWNpT0J1cEJSMEcr?=
 =?utf-8?B?UUdaNGp2dlNtMFRZWUtCUUo3Rm1DYzNXait3R1YwVUx1WkpseXFLWE9jd2Y4?=
 =?utf-8?B?VVZtK3BaZWVvSi9tQkRiaDJ5T3RFZGkzbUFadCtiTzBTaDZuWTB3cnJPcnM0?=
 =?utf-8?B?YVlKVTI2d0daL3lSMXNWeVBTODhZZm1nb0RmZkhiQzZvY21RSnE0U0gwNm5j?=
 =?utf-8?B?ZkFlWGJSVWxkZTNkekZubkdQbGdvbEVIMjB5Z2hZSlJyZ1VqQjRGdzN1eVla?=
 =?utf-8?B?ejBhTkN1ejZVK1YrR1FtUTFrYWlQRUtqUHNCa0EvblljdHYzcklkaTdEYlll?=
 =?utf-8?B?K3pmWW1KWmROM1ZBNVVhSjltaDBqM0tDSVEzaUVXMWpmL2hWakVrQmxYRVVx?=
 =?utf-8?B?cnQ3NWN6WTZTZkpOM21uSkx2NHNaVkQ0OXpLKzlPaVBacHhPcEdNdGhKRnJJ?=
 =?utf-8?B?NXZTeFVEY2phYlh1Zlp6czFMamZIRmRldFBnQmlvN3YvcG5mWDRyNXFTZ0Y5?=
 =?utf-8?B?UzNQK2NiazAvenZnY0NKMG1LWUE5SjNYQ2xzbmJLbnVlQVBKTnFrcUkxVmw3?=
 =?utf-8?B?QzdFUjd1RU5IRkRsSDREWlFPZUFGQndhcldiUVl0YUthWGNYak1yaE5nWDhF?=
 =?utf-8?B?VUM1NzN4ZU9oeTRTUG9DMzByd3EyWmtsMjExbWd5S1I0dGVNN3NoVTl1ckw3?=
 =?utf-8?B?ZGlqa1VLTWdsZUJUZ0p5dmFxelRSamNaREtSblBKNW1INE53Umx4eTdlWGky?=
 =?utf-8?B?bHpMSkJxeTFYVUFDYm9jaS9YaW1HMTQvS1RBRDVrY3NoVmxEZVpIekdCankr?=
 =?utf-8?B?emJmL1R4U2YybCtJM0llUStBenB4N1dnbUt3QWdDL3hWYnV4K2wxVEdib2cz?=
 =?utf-8?B?NzJZYjh4aU1PakpjekNlVmRNL1V5VXMvZzhvMmVWRm4zWFd0L0NJNWFleVZM?=
 =?utf-8?B?OERCSmxzM1RqUXBTVGQ1VEJQSTM2MXJ4SXF5a0pKcG1RVm43bVFQN3ErVW1r?=
 =?utf-8?B?UWVhOWVuNzB6SHE0dytuSm4xcW1DQ2lDY25hazRuRkxyd1h1eW9YMGloT3c5?=
 =?utf-8?B?azdKVmVpSGhaR3lyaVBZK1FHcDNqaVJIZUNOZHJtZEhXUmxMbnpvN0JBdkh0?=
 =?utf-8?B?Y01sNjJQcnByWmo3VVRRLzNsK2hnOWVGdFZVNUxuNVl4WVlYWTU5REkyOHRR?=
 =?utf-8?B?d3duTFVMSXd4aXQ2aGhSTHE0RjU2d0tEUmxxbDlKOWVQQy82aXQvL21ZT1FR?=
 =?utf-8?B?aHJUWkZBWEFCV014czVJVmJ0dVZEeGUrc0FOZHlGODZVa1d5U29HVEZKK2tL?=
 =?utf-8?Q?DLsMHMgIrmoz+wR8afGuMFJw4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <877A2E26EE2D6643891E1436F012B8F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15afe6d8-d6bc-4cc8-c469-08dc734c251d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 12:56:45.6969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cJjeaGqTN0/j3cc/GZ+SwXl4xznGHb2mK2xHeAO0befmI3Wuj1zPbSQKpbA8PN+bR+f68MvfpWWZXKqjAmrT5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8246
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE2OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAtc3RhdGljIHZvaWQgaGFyZHdhcmVfZGlzYWJsZV9ub2xvY2sodm9pZCAqanVuaykN
Cj4gK3N0YXRpYyB2b2lkIGhhcmR3YXJlX2Rpc2FibGVfbm9sb2NrKHZvaWQgKmlnbikNCg0Kbml0
Og0KDQpOb3Qgc3VyZSB3aGV0aGVyIHRoaXMgaXMgaW50ZW5kZWQgY29kZSBjaGFuZ2U/DQo=

