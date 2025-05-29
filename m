Return-Path: <kvm+bounces-47970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 238A5AC7D84
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB40E7A8F8D
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 11:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBF022258E;
	Thu, 29 May 2025 11:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VSoMKz3n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A091DF244;
	Thu, 29 May 2025 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748519979; cv=fail; b=nAgjg120Od3dA+liZpLoogohBverY80zLDRFrly9FNmf7GPQMJpyV8nsZk+BiVItpbenEjoVrTRTfZlYkV7QGSHqC53/LMJUxWUHNTG5e3esF8Tm3fRSzcxNObksfddPe275yMu8FE0jjQcWIvVlrDc+jpcXctGMvDoOkPyTa6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748519979; c=relaxed/simple;
	bh=gnaQ0oJ9RY8Qs+3PJqVfT5IRPd3Md0GGbbuUoMgY1Vk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KuSpmtyz0QTqXUbXY2rH6ok0lAg5kPQJWG2DLcexFEfTn+1V44n54goGCOl4vxXy5h7lATIRGbPd2PVUMyp+Kh5nAy8mHhbnFKlGDURm21GwKRr5XqTYaSp66PTyoAimYMu/FgRuYgoKpJ5cRIUChwlGo+RXbEr0nSl1GVEbO84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VSoMKz3n; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748519977; x=1780055977;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gnaQ0oJ9RY8Qs+3PJqVfT5IRPd3Md0GGbbuUoMgY1Vk=;
  b=VSoMKz3n8YDRks7QuYwvEDXT+mByBZm57VW6PxiBmsamY2AmvEz20byA
   UfsSRjsa4OX1yH+KFa8nvAWygUurr2qwb2C3IauDdu+1uMAQOOZCplIA/
   iyWq8OpImoNsyKu8PE7XVYMgv6JAYYcv1nOry36GC7kIqoaPGEsU2j9Qa
   hifpes+h63QT2lVBWjbQiT+a1JOxD5HZG0tIz3gXRTwscsXz41QW3No/n
   YYcHzzYyIaSOEIyR+8ZCSaIGBYBbXXejvFpLhuEheKn6IYfotkkRciAaI
   K9slRSu3OZMBNmgYOpazYIBoXsaaEovMfZGg9rmzhgU7wfc8Cs5q3WzME
   w==;
X-CSE-ConnectionGUID: 3Njf0TilSjSkKRuoGOJ3+w==
X-CSE-MsgGUID: WrZNt4KHQTeySUSClin+gQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="53202758"
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="53202758"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:59:36 -0700
X-CSE-ConnectionGUID: A2++vcYXQFCqgRxVvexe/g==
X-CSE-MsgGUID: 9UobknNOQJq3UEww9u5EjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="174546686"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:59:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 04:59:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 04:59:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.75)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 04:59:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SccZa99JWtdLWUrb0p5lVkhtwTWsknasAd4Z1omu+ThnTsX2i5bnGV3PZskKo6TvnGV+rdoMS1KWmvreyMFrV23gTasZvozyV9vnLpHy26nOcE2Ms4bE9ACbjF3ggp6WFo2na9G4i/kxAEthldxITe8GKH7v1MkP4lVj+j2CgyRjEDiehobW7yHFMzeU9bPwoM700oWy3Zr0o6/Eyfh+PDVICqSi+NpYbMR18b8Ld7LikolDsQSTkGHH6BUMOvqp3mpEAWgrdEHyOrTidXHOVfELFDaepEpjhrnPH40aZBcwuV/21k7k45m4Ack6EmR3xUsEOsEz+PoomfY4EDivgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnaQ0oJ9RY8Qs+3PJqVfT5IRPd3Md0GGbbuUoMgY1Vk=;
 b=U+CtkVgLSe4haMfCEM1SwJDJAwb5rST+7uyNCtKXIt4B8dXsRkrPhMHUb8OQZAEJN+qoSxv2yJX8Yos94rBcjvjGSoMVD+mQ+f+59A4b1cCGc02XafKdXc3/1ZjwDiahFt9fipOJtdj6ZrtUOR3myUiX41GFw1K34TLUzxvuKH5gPIrz8MC2aHIlN1vlhRg1npvIjsp77FtoYH9YvsOpp8PZaNjbLZAc/G8VfiBP7E/NhD7fCSmlczWKHyKQ8nt7Qv4W+boJ1EQkuZRvB7BaS2blvxbX5gVYvsiQxq9aqsmodY95LE9KjtYcpPQ1oIKrEHZoPSJPy9AG13TcoCPDhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 11:58:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 11:58:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/15] KVM: x86: Add I/O APIC kconfig, delete irq_comm.c
Thread-Topic: [PATCH 00/15] KVM: x86: Add I/O APIC kconfig, delete irq_comm.c
Thread-Index: AQHbyRXFOO6logEGIES/meMNFPk/t7Ppj+kA
Date: Thu, 29 May 2025 11:58:52 +0000
Message-ID: <77e95fc8f58fe709015ec8caf6476b150222f533.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6401:EE_
x-ms-office365-filtering-correlation-id: 0d878260-53c8-4360-66ab-08dd9ea82e55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?KzR4L2JaZW5kZmxSdG5wUE9RRkFzaWxTQlJHVlFGQ1hiL2srTnYrL0cwVXM2?=
 =?utf-8?B?Ni8yMWtZcXVpWlF0UVJYQlBZVS9qSGRQMmFDN2kxUUtRNzJyZnZhOTdqMmxL?=
 =?utf-8?B?bG1sd0dLb3gvQldZMGVISllxb2d2VVcwQnFhbmFmZ1VlMXV2aHNqVS9vakZE?=
 =?utf-8?B?eVVrTnhEbVN3STdVODVXVkdkdGQ0aFM3emRVcmYxY1YwaFRwNVJ5UndRL3hx?=
 =?utf-8?B?b3hkVTJLUlpDQ2lVbmhzQlhScGdzU0UydlAxUFNrLzJzcnVTOEpLYk5rOTRN?=
 =?utf-8?B?YW5ILzFQZjZaWFZlS3BhMCszeTdXQmlycHEvczhEMHpBWXFtcVkvUi9LbzRh?=
 =?utf-8?B?Z2o3SVBTb0daSlo4THNFWHo3VXJLSzFvUVJpeGZ0SnNGMGQ3cllTMFNudFRu?=
 =?utf-8?B?MHZCZCtnR3o3ZFZKSGFocEdXeFp0aDZ3TTBnVkgzVGYrRkM2YW5idUd5NkFR?=
 =?utf-8?B?VDlHSEhONHZBT29jL3RYRHdaNERMSlQ5akdIVk1NWHo4dmNXdnZrTTU1KzJV?=
 =?utf-8?B?NzJGYWRWemhFZ2xnUUx2WmJtV25FZldsVTVSZUR0RnhFRGQ2Mmx3Z1gzcXdl?=
 =?utf-8?B?MG1FWUdiOTZtUmltWmRabStzSS8yd2pya2hYclROZG9ITGR5cll4dm9LazZ6?=
 =?utf-8?B?aVZWclhucDZoNGV4Zmt4dU5aMko4SFRPQkpUMnRXNmh1OXpNeW5mdENIK0xZ?=
 =?utf-8?B?Q2xUanhEU25BR1Y5ZnRPR0NKeXBwaEhtSFhSQlN4MnhsbmYySjNPWG9NTUlO?=
 =?utf-8?B?eWx4dDRpTWcvbWNQVVYvRlBIWm1yUE8yWkl0YTZYQURtYnZpUnA3dHhRRjEy?=
 =?utf-8?B?Nk1uVW03NS9tbFRiblRjR2ZwYU01UHppdTFwQ1A1QzcrOGF3KzUxTVh5K1BM?=
 =?utf-8?B?KzdCNGtHaXUvN0VoSURoL2kvcU9DcFJuamsvL2pYWWxWTFY4WUNZRTlja3RV?=
 =?utf-8?B?VWI0bXh4TDhUWEJ3ck1oWUxHamdQU2orYW1EUytCSmY5clZuK2htcWdoMnpG?=
 =?utf-8?B?QjM5TW82S01mUnZTbGVDWkFZaGJ1Mm9nZE1xV2hWOEVuRjRPUEdHdHcyMUZn?=
 =?utf-8?B?WE5sbi9scnBXc0FpV05ib3M1M1VJd2hsa0gwT3hEYThHaS9GR1hHTlhWZFVx?=
 =?utf-8?B?VkFtcDh4dlZkU3krQTVTRlJqMEJnRGkrV0UzWFJLV1grWWtJS3dBbXp4TTB5?=
 =?utf-8?B?ZUFkdi9OdWJTeXUwTXZybmRJUTJHaGcwRXBuSTBRR2xEcERNU3kvWkxLcndV?=
 =?utf-8?B?Yjlia1M5ejZPbTRuT1F3VGNXenR2dkozZDZiOXN2dGlyajVOTTBpOFBrMVFv?=
 =?utf-8?B?dVIxT1FpSzJYS0dWRm5FMS9lZ3pFRlgvS045c0ZrTHBXOXZrczBzdlJvamZL?=
 =?utf-8?B?ejNUcStLc0E0OStSQURYbDNrU1VZbzFFdW5pNXlLZjMxdFllYXhmdFZHZGRV?=
 =?utf-8?B?OURjOW5Va1B4bFFKbVlxYVRjT0d3Y0g0MExxcGNkOERqTy85U1MxcUJJUDBI?=
 =?utf-8?B?N2Q0RFZjcEtWeElMMHV3WnNXWG1zOGFDSnBQOTVBcnd0NWo2OGNyUk9iVDhj?=
 =?utf-8?B?V0hxaFlwZGVnNXU5NnNmVGY1eEI2Y242OStHWFE5VDlZUUU3WE94TUw4NTZw?=
 =?utf-8?B?RloxUFJSdHJCWXlhWXVwMlZUaUx4bFViWEw2R21zNUVQeGcrTmJGOUNOU3FN?=
 =?utf-8?B?NlB5cXdiZmpRS3dXTFBza05jQTBhaENHLzJrK1dZaUFRd0oyMVpWMktCREVM?=
 =?utf-8?B?aTFEa2owWWQremptU1N2d2VWNkhCUjljWGgxOWtxZ2tJV3gvTWxSYmRUMW9K?=
 =?utf-8?B?MTVIYS81T1RTQjlGbUxCNmNyejNQWEZhdTVqdGRJYkEzWEYzMEd1NVNoZWo1?=
 =?utf-8?B?Wm9UTkFmTWMxc3pJT0dZRXJwSFlDelpCZlNxb1NyeUZiYUFGVWZkZk84MGxL?=
 =?utf-8?B?ajI5eWVTL0V2Z0lEbWxrUkhXdmd0Z09mTTA1c0ZXSVpITUszUG5uWkZMK0U3?=
 =?utf-8?Q?w8HdlvCha4rlu9wzaw+5hkPj9AGYF8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjcvYW9UVkRnQ1lzTmhlSkNFWnBGNU5xbjhTTTdJc3lOa1p4Qi8wODcwYjFv?=
 =?utf-8?B?YnVmTDE0NW5nb1l1eGx5OUJPUkdpUnRqWmVieUZ3MW1RR20zemtRbVpjRDJz?=
 =?utf-8?B?Mko5M1FuSzB4R2o3VWR0dVBNR0pFSk1BamNvLy9rcjhMd0t3UHlpY3N5bGdM?=
 =?utf-8?B?dXBrSHRLMHJNTTNrZEJXenlLYXFPVlpFMDVJU2loeGJSWDJ6S0xpMEJPaFNV?=
 =?utf-8?B?UlRmOEl2V3BTYTlDdUZ6Q0hlNmhZUmtqUllRSXBwbHE4OXlwL3ZWbi9taitP?=
 =?utf-8?B?UlF1M1pvb2Uzb1czelc3VjNpSTZRZVFxY2p5ZytLQzFmMENXcHJBNk1tMWhy?=
 =?utf-8?B?Z3BCSU83ZE1EcHJGbE56YUZXVnUyUUJmQlVtUUp1a0drSGg2NlE4OFpGYnhV?=
 =?utf-8?B?cFMvNzMvK1JPZUM3YXdxY0FET1YxaDJXRS81TFJxaUltUGJLaGNra09xeS96?=
 =?utf-8?B?S1Y2b3Q0RitsMWRUNWl1Nk10ZjJuWHN0Vk9VQ3UvaTFNbFFXbW5lOUVVSXUr?=
 =?utf-8?B?OThNcGVXL2xrejVjb3hFNzVNNUtFa1JxVHIveEg4aXJUd25SQVB4QWFDTXJZ?=
 =?utf-8?B?a2RXU2FxR2djeEZzT3F2YjNxcEVmbDNRQ3dFMUZPZUxVQ1BDbHNxK3RSc05P?=
 =?utf-8?B?VkVHc0wzVUdJdzNESDFKTWNhcjlNTkttaTVjSFBSdUlqejBLUklFbGUzbDlr?=
 =?utf-8?B?cEFnY0YrNkYydklDZ0diS2NHdjR4NHU1S3laNmIwdzdqQnk2ZU9NUG5sRVkw?=
 =?utf-8?B?S052WERJNEc1NWZ3RFV5R1V4MFVPalh6bHF6YmFrcm9za0lYQWpYSGEzbW13?=
 =?utf-8?B?THFtclc5RkpLZEVURnZaNldjYjloSXFnMkxvNUloUVF2WFlJRUt1TnpFUFpr?=
 =?utf-8?B?ZFgvc1FYbmhSeDdJZXh1MmFyaHI1WkZDNHpFUnNZUGQ0V2VRSnRBYnpRNEpY?=
 =?utf-8?B?MGtsUy9nZzA0M1hnSWMxbkdoNERIbk1Pdzh4OVpoWVJ5dzdqSGZwTVFzdXMy?=
 =?utf-8?B?MDJlR0YrdTlwVVFQTkt6ZVpmdkkzMWZFYWp5ZktaNGRxdlZaMXZqaXV3aE94?=
 =?utf-8?B?dUN5bEFRUGlsamtUNkRRQm10ZXlCTkpuK25YajRabm1IRTc0Ni80elpPbjVD?=
 =?utf-8?B?NGRMOVh6dUpGMy9nOVZCNUpiVEdyY05hSzJmL29HWVByK0VPZThDVWtNbGRH?=
 =?utf-8?B?Q0xudmJDb3I0VFluZEtnbkx4ejA1ZHlTbkdKVXo2RjZ2b1h5L09rbTBnNCs1?=
 =?utf-8?B?aEtvTmhSdENZVU5OV3RFaHROQUtSUElzR052b094OGt6aEV3TU1tYjJpWnJE?=
 =?utf-8?B?K1A4S1hQdXFLU0VPMTlKY0tsN1NKS0E4V2RKbkdSN3QvNUFPZkpZODhDeDRE?=
 =?utf-8?B?MW85Yzk3YWV0b0dyeG9xTTB0VU5vSEtoOFVqT0RWRHo4MFZpVVRiTDNXWGlo?=
 =?utf-8?B?bEY5K0g0SG9ObkY1MGJQVVFNeU1yV0RrT2tQakpnYWZvV2xrV2NyM1RnR2VN?=
 =?utf-8?B?YnEzdktkTjJxcUhuU0xvNm51S3l3eG4yWmVhdnBpMWs0WWp6Y3NLZ2Nacksv?=
 =?utf-8?B?MDZjY2ZuL2t5NGtZQUQvZG1Yc0VnVFFpVllPd3JldXVXd0RyQkJxZTV6SmRs?=
 =?utf-8?B?TFE1NjNMUHhvTEdJeWNWcWxNRUxRMEYyaEU5d1ZPUy94VFRNSzREanVKNElF?=
 =?utf-8?B?TWlTOEpTRmFSb0VmWDhqTVlvMWd0QTdBOWpkME0zVFM5Zkl1ZGRUVTNVdGN1?=
 =?utf-8?B?bUFsLy94U0ltK1Z3cENnVnZNTjhENG1RWnJNOWdVU3Q2bENvTHVlemNlQXh4?=
 =?utf-8?B?ZXNaYXZROFlrV1U2d3hvV2YvVWlwTTkrL29mNVE4QzJsaDZQdktmUjlqaGcx?=
 =?utf-8?B?bFRyZHJWRHZTbW9NQTROMzhDSzFTWDhMb0Y5WnBTT2lDbmJwdEFGNTgvc3pI?=
 =?utf-8?B?a3k1UEpPTnJ2dFF1eHExMWN0NTZ2NUdyZGpnWCtMSVhLUU5hTEFUbHhmVnEv?=
 =?utf-8?B?cDYwdkMwazdhWUNXSlBNNHpid2xqdHVrSmNEN2hnSWtPUEpsdjRFWjZzM0VJ?=
 =?utf-8?B?c2ltSjQ5V3BSUDZheUQ2SUFRVjhxMXAzbk4yQTVWalZVK0twc3dyamJMTC9h?=
 =?utf-8?B?QXBkb254eituRVFlZEpjTkdDOE5UcndpVHhOdFF1aXltbDAvY2NqY2RrTDZY?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B83C2E796A91CD4CAEDEEBDE689C1CB6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d878260-53c8-4360-66ab-08dd9ea82e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 11:58:52.5354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paNRnlGby0QJxG/XjfSY4UsyeU7RbPAhsB4wOAU5N0c1a//JN46BtfLQAgWE/BtrkCzSSrxlHQduglxWnbXz0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjI3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGlzIHNlcmllcyBpcyBwcmVwIHdvcmsgZm9yIHRoZSBiaWcgZGV2aWNlIHBvc3Rl
ZCBJUlFzIG92ZXJoYXVsWzFdLCBpbiB3aGljaA0KPiBQYW9sbyBzdWdnZXN0ZWQgZ2V0dGluZyBy
aWQgb2YgYXJjaC94ODYva3ZtL2lycV9jb21tLmNbMl0uICANCg0KRm9yIHRoaXMgc2VyaWVzLA0K
DQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

