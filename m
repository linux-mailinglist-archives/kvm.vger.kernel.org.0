Return-Path: <kvm+bounces-47968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4814BAC7D77
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0444D4E6FA9
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 11:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9007F2222D1;
	Thu, 29 May 2025 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eEZG9Dx5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0904155335;
	Thu, 29 May 2025 11:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748519747; cv=fail; b=n7k9bOwObO0Vp8w4ULdInGSBxvP9JI4WjFPz+fclw9vf1fapmVgkDaOpI7ipeAVm67v75chOFcYQJalK+kJjjUC94fMrMDgjIGToM3QWsUfQWUGc9kBEUolxUBqINR0vp26b2IqkFgNvm8SDQUrVfDXdZxIBpp//38lINj4lDW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748519747; c=relaxed/simple;
	bh=eGDy8V/2CS2xMquGTOVudX0pzNWZMw9NvMiwjvybqeE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lvR9Oh3YUyIb/Cl0CRnrP64lGHVnnRWFTS3Qa/SLonZ5v/aB4Jop8KsmXggN4lpsNOFYo1g2iTGYx+NUz1nG/IIrVgiGTJgKJtD3JtYPD21URbLIdYlNjaROKDqRUX6f6pkl+UKSJakD5gicA9/KuZDtpncclI6vCIcho0hy5Dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eEZG9Dx5; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748519746; x=1780055746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eGDy8V/2CS2xMquGTOVudX0pzNWZMw9NvMiwjvybqeE=;
  b=eEZG9Dx5kse/JWa33ZRz3FKHY1ofPEjXS0TrDi2X0ShKSX006Vc+KKG6
   yoSt2aBvQjMjwgS7JITG41GZHxREQPAw1CpoHZ1JNZ16jAfeStQt+OkY2
   b6eafd1MX2ZEFpCuNy6cjYDusSJvbPe8Duk6VyXvkzKNSfSJMjUEqtZjq
   66nVPBxv/9HML4FnV0CSmB27wZ11ONp0wd1txqRncZzTeJFOHsJ0wqDFH
   acxQU+YjmOlyHnADZKh82bWjfT/cRSvmNoq1IQYQC/m848CV+GOHeN6Lz
   wBoRQ+oJqsCuixFNH2PL+F7HeNlbInx1x24eoHtRdwhYz+INMzRAkIyIR
   w==;
X-CSE-ConnectionGUID: t4tX5eGMT4y6/pyqlqJo3w==
X-CSE-MsgGUID: EoNmVmQdRZ6ctOZN7lNZLw==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="54381607"
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="54381607"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:55:45 -0700
X-CSE-ConnectionGUID: /fNbEVowRCO8ISHw3i6gpA==
X-CSE-MsgGUID: KKiRzezRTYe8aeljg7vX+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="144172877"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:55:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 04:55:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 04:55:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.46)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 04:55:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7M63Ar58i7ZbXSCqWl5+7kuMdqAbvIV+2PcwrZ6+a1fIkPMKRSRAW140nIqdXXTwAhkfqAnIYszUxA7vUFEt1Yl5FYzcLTA9T6QwmT4MJly0nYwx48vtpDj4tNI/U3K3kahwmWQajSAfTnIMPHudoGpKd02SUMn8vFhFc4ADQ/b9wQygMSHhzkmkYBNu9ot3IDka7wOW74F+MdTry///wt1FqCzPh/tYG3TAUsMLT7o/rU5QcX1GycUAqC9LUp2Y2eEUytU7mD0KUF8bxQ6V4FhiUtPHSW1HGzaNR81X26jAQkHVn5bkgY87peuzkyO1H3PSIVDoVHCnS4l6zmn7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGDy8V/2CS2xMquGTOVudX0pzNWZMw9NvMiwjvybqeE=;
 b=aIkFXrIrZ0p7glCmgKCU/YGvYYe7/Z+YmdhDmU20MgIFC8YnDlBNWsWsVW1EggIgDbScCykQ9gbh2CA6C1CpYZdC3oXtrj5w09ar7kTW58p89tJ1DpjRlpI4zK9JSHarxGtobxSmm999/KOVFkglBSGd+NWI8PztEXEpZmNux4wgp7sq2Qcwu1eFsoktrZybCknvM4L+UU71CZ5YlJalwjd+JgGZbpv+V/c3hAGA3nJhgK6zel1AHATlRm2lQehmYO2+dMuThwnH7/yvBDGwsDNWTS8kHhtS5j9sGFWvQuE89AV464EBrVnh98iJ5n9GWnCSI07qMRpW3Js9hfPRzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6401.namprd11.prod.outlook.com (2603:10b6:510:1fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 11:55:13 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 11:55:13 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Topic: [PATCH 11/15] KVM: x86: Add CONFIG_KVM_IOAPIC to allow disabling
 in-kernel I/O APIC
Thread-Index: AQHbyRYxNH/GJBJvrUmF7CZUp+ur/rPpjuOA
Date: Thu, 29 May 2025 11:55:13 +0000
Message-ID: <d131524927ffe1ec70300296343acdebd31c35b3.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-12-seanjc@google.com>
In-Reply-To: <20250519232808.2745331-12-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6401:EE_
x-ms-office365-filtering-correlation-id: e6e730f9-4ad2-43f2-117f-08dd9ea7abdd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N25EQnBJUlZJckNHQVZ3eUVER2NvbVN4VjFWdVM3bHoxZmQ5akkyd2lKcmVi?=
 =?utf-8?B?S3FNeDVwUVNwSmRON3BTaVRqc0Ivb3BJd25INVMrUTN3SE9FQ1ZVb1drbGk4?=
 =?utf-8?B?ZE5hbDNBSk8wOUQvRC9haFhZZXhudVd6RUlwaGZJYkN1ajY3MnlIM1Urc0Vx?=
 =?utf-8?B?azN2NC9YYkhVdWdrSmdEcmRqRHQySUVXZ3pQa1cwdWFoQng1MC8zMW12NjRH?=
 =?utf-8?B?bFlObkNSMS9la3Rvb1NTdVRRRkpxQzJYcDVrOTNra2c5cDdjRlhBdE5TZDRq?=
 =?utf-8?B?U1dad1dZN3dwTkdETUhhNi9vUG9JejMzQ0hIblYrbnYrMmk5TFZJeXV6Q1Ux?=
 =?utf-8?B?T2tCTmM3TzYxSFdVdHhoVWtjcy9rTi9WOEc5TVYvK1FrcHVwTnRpblVGQSsv?=
 =?utf-8?B?ZWVsUWVqS0JIYnBYeFg3SU5Eam5mbkRGc3N3cE4xWXNtVWxKbHVSdWVNVHRm?=
 =?utf-8?B?L2E1L2FrS044MSsvL3h6SXh6ZHkwZnF6NmppTUhQMUJJaVFuRGNZV1NyTUFp?=
 =?utf-8?B?ZjJRRWpoRWdaWEo0STg0UWVLMmljdjRoaHg3RUZCTXB2eDhQL2N1bys0cVdv?=
 =?utf-8?B?cjlENWYvcHFPRVVQVXFpSm4yVURzRTlVQUcyMHpWcG4rTC9uSW1yZElHU3gw?=
 =?utf-8?B?S2IxV0pDWDN3N21USU9ka3FzTzhQczFCYVVqeTJlVFZuYmM2OWxza0xWTHJy?=
 =?utf-8?B?VU5VSHZLUmZDK3FPZnRrc1lPYlN1c1dMeHlDSENHT2E2V2Q4Zi9JMEdXYTUv?=
 =?utf-8?B?USsyMkxMVkxadTdURGdRQklCekJCbDhoQS9vMUltR2dlL212djh5UDlvZEd6?=
 =?utf-8?B?SkhjSHN0L2EyYkFBSHdXSnpQTDg4SHpFY3RPUXhVeDB4MlpIMy9rem53cWdR?=
 =?utf-8?B?czYycmJBVjFHNVlzV3Z1T1RYVFo3ejl4RVp4VzB1KzhRaVBSMHlGTUp3OVlE?=
 =?utf-8?B?TVJsOHllek9SR0YwQWlUWVcybWE4R1JTcnZYb2ZSWWhrSjlqMEdvZlhXdWN1?=
 =?utf-8?B?UFl2YlZ2b0JQUjhxL08xbHRBcFIyb3BNeTdjd3drOHoyaWNlTm10amR5djcr?=
 =?utf-8?B?Y29aREtUcDE0U2kzd0ZhTllnVDZJSDJqM29jc0haNFRGdHVLTDl6RWloTFM3?=
 =?utf-8?B?VnNBQmhnbS9CR2NLTk1IcHVaY0QvY2pEbDZwcWhCbjhzb0o2ZTdRQkJXb2px?=
 =?utf-8?B?YWlBMWllSDJzbkFSWXdkUnJMRzVlY2RyNGxMT1RGWTI1SFNzZm9VQWxmbDMw?=
 =?utf-8?B?ME5pN2tFbUhWQnJnQzRJWDRnZFNzTXhzSkswK0xZNU15a3JlczI4OEYzZzd4?=
 =?utf-8?B?emYvaFJmdTB5V1Z1cTI1aUNoNUIvMVd6ZmpLQ25LZHRvVkdaOU9uajR6RFBL?=
 =?utf-8?B?czdqUmZ0WXJlOXNscW84bGpUbXkrV1B6MFU1cS81K0ZUWjZNOFF0S1o0Q0Fa?=
 =?utf-8?B?S1R6MzJYMW9BTUFIdk9vTzdyL0c2N29VNXdGMzJlZVlPbGUvVC9XMkNKZUth?=
 =?utf-8?B?bGFzRmhtenlBTWtrNnI1MFVLMXFrVzNoR0wyTXkzSDBrbnpFaW5rdVg5UkxG?=
 =?utf-8?B?UVI4TkUzbnRnS3l5MWhDcnk2UE04SEt3YlVDV0hyQU81UDJmZ1hKZXZoak5z?=
 =?utf-8?B?Q1BJQkhlZEhzeTZnRVlPdjhQR1lJV3lZZThxeFRXZ2FtaWVkcTZKZlpTekth?=
 =?utf-8?B?VGVxbXNKczZ4SytsUmh6MmMramhOSkpsMkZlemJsZmF2RDFhczZDc2YxZHEv?=
 =?utf-8?B?N2JZQWRxSndoQjJMSEN6ZFFKRWtVbjFkSDRSeitZYVZWVFNISFpkeTNUcUFL?=
 =?utf-8?B?NEM3Y2NXejVwMWQ2U2lHc2VEemQxaUkwZ0xzbDA1OXduVmNWdjJ4YW91aENQ?=
 =?utf-8?B?ZWsyM3JzWTF5Uy93U3JNRFc2TTVTLzFRVWdFZHd6d2FBMFV1OXBjVkZVcHN6?=
 =?utf-8?B?TTkyYmJWc0dnaVpBeVZUbElWM3VkSThZOStaVHBUZ2t0YzI5YWpReWZycys0?=
 =?utf-8?B?TExWTFlBUENnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkNLOXU3ZFFiNjI3WlZ1eTNTR2wzSnBMSklKbXBPejJPbHpKUUYza2pTVzFY?=
 =?utf-8?B?bDNMNUFYRXBOT3dScWxScXJnbVRvUXhGeW1zaUlYQi9Mb25JT0tNNnJNdElF?=
 =?utf-8?B?TGgxYklhZjJzUXZCNFhWYUlSYWFMWUhmNVpsOWYwOXZOdXh0L3RRYjZXZEs4?=
 =?utf-8?B?OGEyRHAwd3NUTGFHcHdFaW1vR09yNm1NYkhoOENNWHhkOG9XY3d4S2VCNkZo?=
 =?utf-8?B?TmdhclNXdDVSMkNFbnVMN1VpeGhneGQ1TDFOK29NamJiMEUzTERYRmJEeHQ4?=
 =?utf-8?B?MWU4YzFyQ1UvNVpSaUNwTXlmZnVJMk9FeVZhakE5UUNSRkVZRDA4K3pXYjJC?=
 =?utf-8?B?S3RCTTQ2bUc3eDhsdDQwRi9xZXRLV3h0aFpJdDkyL0VuMmxLejRGeWM1QTlZ?=
 =?utf-8?B?RFdtR3loUG5tbHQyOXBMNXJQVUZKTjdQSUZkc2V3akpGeFMxNkdZM09ITGpC?=
 =?utf-8?B?Y2p6MDU5eDZmUXhpYTI5TDFMejhKOGtodWxlUnI1SU9XZjVvREQ0ZG5xWjlU?=
 =?utf-8?B?U0wwZ21GWW1INm5tdXVqeklKMi9qNmh6czFXSnB2aTNUY2hZeVBjSnBpQnN2?=
 =?utf-8?B?OENJTXpOenF3cEpxTkRnSFBPRTQvZThmcWRSdkw5ckk2eHBxZ3lEOEtVaCtx?=
 =?utf-8?B?MG1Wa3ZaU3MxTE5PeWp0Y1I2TkVnemY1d3hGNmF1TXEyQ2p1YTZ1Y09oSE5n?=
 =?utf-8?B?ejJQNUtFczJrVXRLK1RXTXJub09hbVpZT1RtWkJpQUUrTkh0bkRHTndXbEFw?=
 =?utf-8?B?RDBESVJGdjU1RkI1bi85b1pJZWRZQk5kaGpvVS9zUXdMSkNDTVFjRmx1cmNi?=
 =?utf-8?B?cmtVNmVUcEZFcVhzaGJ6NFczRTBhQ1ltSU1IbWdjYTJURWRzVFhMbGZwWDQz?=
 =?utf-8?B?bGxZenFtL0JDQlBzS3l2cklpZm9MRnhqTlFObmlzOTJLcXhNL3Z6VHZiQytX?=
 =?utf-8?B?WkdFQmsyYVh4eisrOEtVUjdJV2pJRWJQQkZHZ1ZWU1Vka002Q1dlVkFaNDVO?=
 =?utf-8?B?b1NvU1ozNFFrNkxnN01FVUpoalY0QjhoN1ZURTg0b0NVWUJ5TUYvWjNMM0hP?=
 =?utf-8?B?WW54RmlYR0dNbWY5TzFaVU5NRjZGbDhqemJRdStWWTBNVkYwU2hYb3NHWFV5?=
 =?utf-8?B?S1RKS2QrdEJEdHprSGRYZjU4b0ZYN2cyeVgwN0swbFY0QllJb29ZZURWZENl?=
 =?utf-8?B?NDRDUjdDR3dOQTlxbmZrcmJhQ05ZT2FYK1pQWGxLUythWWx2QW1kTHlWcXZq?=
 =?utf-8?B?c1J6YTBVTlZlSEl4MGV3bWtsWXdINjJLZGRKbFMycEVrb3ZmWnI2Y2hjMzRR?=
 =?utf-8?B?ZEFvUUYwTXJOeUNndmZvVXlUZlpMWUhyMHhjcFZ4ZTJsV1VFYk5uOXZNSjYz?=
 =?utf-8?B?b3k5YkcyMU40a25oWG9tNFViVzU0T1NsS1Nwc0NydU83ai9FTjN6aHA5aTJy?=
 =?utf-8?B?SVMwdFhMc3dEbkduSFIxWkxUYUJodU4wWXdudmFiVGt1R1ozcVJUbzhSRlFq?=
 =?utf-8?B?MDl0aEJ6SVF3MFVPQUNadUtHK2RuYklHZjJiYjBzVzFla3pyRU5IYkJ0OVJq?=
 =?utf-8?B?U080YWdZM1BienQ4WlZFN2VrUDVzcXdZOGJwSVlCdHZlWFB2MnJEZUh0Zmcw?=
 =?utf-8?B?dm04Znc4eW45UTV1b0V1YnErM0NLbjhIR2hlNFZXSjNVVjYraC8yTDNrSndi?=
 =?utf-8?B?WEU2WlFsZFdLWFVjbzlLNmxvd3F6Mm5lRndFc01PNUVHUHZWTzY2NlIwYm9a?=
 =?utf-8?B?SURXS1ZqWC90T1Mva1RUVUR4UjdBVGloWGJ5aVN3aGo5QjJVZjNYNzZVQjRr?=
 =?utf-8?B?MUMxUHM1VDNMMGR3M2lFTmZTM3Y5emxPQ0hLS2RFOUcvdS9aNnpnczZuaFZW?=
 =?utf-8?B?dnhQbVVZUkNlWEZBeFJrRjdyVmRtdUk5eFZnRVo1elFxN0V3ME9UWnpMajBF?=
 =?utf-8?B?U05BYTUzV3F2UGNsSzQySWo4Z0dxM2drbEp3ZGgrWllvVnNNRWVmSElnMXVU?=
 =?utf-8?B?Nk5BbE5hVWh1aXlOcWl3RmxLdkwvdkhQeHNyb0hPb2dtT0tPRDJoTVRSQWZo?=
 =?utf-8?B?N2xpT0tldUxXSjRKQ29mc3U5cjR1MVg4alhJWGM2cHpMMk85RHg4U2p3Z0Ru?=
 =?utf-8?Q?/1iqbPf0IkgfyuRQ98PuZ13gv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <008C706D2552A34EB7AAC892E1C96D75@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e730f9-4ad2-43f2-117f-08dd9ea7abdd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 11:55:13.6048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fo+HSXryJm7N9hMlvr2k2ivI+rb1CkcbIZGkKGqVLeGhIawVolncsszzvxQHZvwLTVQ/YsFt/TWrljpttr8aNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6401
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYSBLY29uZmlnIHRvIGFsbG93aW5nIGJ1aWxkaW5nIEtWTSB3aXRob3V0IHN1
cHBvcnQgZm9yIGVtdWxhdGluZyBhbg0KCQkgICBeDQoJCSAgIGFsbG93DQoNCj4gSS9PIEFQSUMs
IFBJQywgYW5kIFBJVCwgd2hpY2ggaXMgZGVzaXJhYmxlIGZvciBkZXBsb3ltZW50cyB0aGF0IGVm
ZmVjdGl2ZWx5DQo+IGRvbid0IHN1cHBvcnQgYSBmdWxseSBpbi1rZXJuZWwgSVJRIGNoaXAsIGku
ZS4gbmV2ZXIgZXhwZWN0IGFueSBWTU0gdG8NCj4gY3JlYXRlIGFuIGluLWtlcm5lbCBJL08gQVBJ
Qy4gwqANCj4gDQoNCkRvIHlvdSBoYXBwZW4gdG8ga25vdyB3aGF0IGRldmVsb3BtZW50cyBkb24n
dCBzdXBwb3J0IGEgZnVsbCBpbi1rZXJuZWwgSVJRIGNoaXA/DQoNCkRvIHRoZXkgb25seSBzdXBw
b3J0IHVzZXJzcGFjZSBJUlEgY2hpcCwgb3Igbm90IHN1cHBvcnQgYW55IElSUSBjaGlwIGF0IGFs
bD8NCg==

