Return-Path: <kvm+bounces-69330-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGJbJW2veWnayQEAu9opvQ
	(envelope-from <kvm+bounces-69330-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:40:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2334A9D7CD
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A41E53014861
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 06:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4C53358CD;
	Wed, 28 Jan 2026 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RvzwW+a8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840B132ED42;
	Wed, 28 Jan 2026 06:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769582440; cv=fail; b=svVdUFvH/qtNz2JLwNCL+CMAgb0gg3pRO4LpqjrsZv0eJSVGxn9Fc99aic6yB+9MlFj2QoLixRD9LQAdof1RP3RfttCgmR3wprvd8+Y0A8S31s4+2N/PU4VmjBCqTg0vgEwjWb3Pmsr8VjYsfLcJWhb4PAA7EKmcxN5tWMMS2lk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769582440; c=relaxed/simple;
	bh=8DM291NIBG3Y7TqsrMaWDAIG5/gDJWSkGa5GfCkK23M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pAyCSb0yFYa9pNFKx5GAor50CgaS1/TsB3aJvkE1DYrn23l5nyDJkO/QR4PtrlAuE6rNp88hKbsB8IBN4fERzoHTvt8FKyDvocZcLI0/1S5Cu+Qag5OiSHoXY89fqY0Io/6QX/cN6l4vwgglgwQZAAdnkxj7TZRYRTX+u5JRfU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RvzwW+a8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769582439; x=1801118439;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8DM291NIBG3Y7TqsrMaWDAIG5/gDJWSkGa5GfCkK23M=;
  b=RvzwW+a8Ur8xZ3dZWIoHgQbduFEpzmqaVYVlyUXJVOamTPc1e7JSHV7v
   tRZ7DPAV3Tq0kWdVdgSVxAhmSSg7mdhAl3ktHHZ2U9n/De0ekWUIVTqtG
   KbmpLFGZcfdh7Vzo05hu7PsParQ3wN10TNwUns6ohdOAlkvF3FoEVU23V
   806+rPgFJgeKkzb56qBZHAqgTaf4D/jSPdB9+I5/D6QtUoLFEOk9W3cE7
   5xrG8HvYpEYcs7DF+PaU4Dtn+t+KA16hyNxVisWv9Z8HPtJIZNQ3BewCP
   la8j9QvZS4tZhM8c8GqWGrWncntdDuzKYwCEuVMbauMu/13xqq1hQX9wn
   Q==;
X-CSE-ConnectionGUID: iUZm6yW/QLaYxIFXzzpGrg==
X-CSE-MsgGUID: AkkCIiLkTAuE8097F/LASQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="74415817"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="74415817"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:40:38 -0800
X-CSE-ConnectionGUID: oliS8e0uRE6VjSrTkSAQPw==
X-CSE-MsgGUID: 38HZRmHaT0eBVktY6ZZrQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208255499"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 22:40:38 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 22:40:37 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 22:40:37 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 22:40:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiwK8NRgaw7/LiteVzBhyMEou8ClBnj5Ms/KzV7C70MH47jYroEs7N5v0INzXcXeJ1xg5/3CdqmY/WJbul191N17+OYLvAL6ctzSSAD9znJFGF1wWyXlFsA4QnyUIxfUnZkba5GuyPzMBfWFpkM25/3QEWMF1jgRrU9RLJveb9xEPEcnX8wK/41RNcouj5h8q2sNYmY5fjfmbjrZxPLbAAbmDgIhIJmjn3n5ZZwwjvLCofim3jElR6WVfpHEJOcmR0Xisxud6LxkBx/Tbaag8Ka/PL8n8kFIAi8YIY5cvH75E2VS2wUJD3avOjvpYMVxFgE0EWXZLfMcbTkIS9PqPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DM291NIBG3Y7TqsrMaWDAIG5/gDJWSkGa5GfCkK23M=;
 b=d/F2ufgojEuCNG7N3nsXqr+ThARSNK0gKUpquy90YpkjrPJQ2PMCLJGhE1oQJ+Hd+rpuIMnNUwknH2i+o2SyrumF8aA0wN/BB1Kxnt/eRjUI4dgWAcDHuN3267X0MZs2s+i/U9fYQuG9KUVIoohj0cQd+Cu2dR+97HV5tVQH9cOOB1VOFqcLp+akXtRRfhiU8hTdkY+SKat/Angnqj20I7J0aPzJmttQOfclcBBG899A/lBQHzkCaflKJFMRq7mm+huBJ0DMsBzGNeexh3DzUaQz8qDFmtas7rmvHK6IX8dQ0neC7xsiWJ4u3aW/6SbHLBrLzaAYarBG+qEVa6bTHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPFA3FE8A23F.namprd11.prod.outlook.com (2603:10b6:518:1::d3f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 06:40:33 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 06:40:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "seanjc@google.com"
	<seanjc@google.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "Kohler, Jon" <jon@nutanix.com>, "x86@kernel.org" <x86@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"shaju.abraham@nutanix.com" <shaju.abraham@nutanix.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcjGf2hzr1Aefe/EG2AzLgdqhXDbVnKS0A
Date: Wed, 28 Jan 2026 06:40:33 +0000
Message-ID: <a02bfdf3448cdd7738c9a11a1624baf0d8bdffdd.camel@intel.com>
References: <20260123125657.3384063-1-khushit.shah@nutanix.com>
	 <feb11efd6bfbc5e7d5f6f430f40d4df5544f1d39.camel@infradead.org>
	 <aXkyz3IbBOphjNEi@google.com>
	 <ea294969d05fc9c37e72053d7343e11fa9ffdded.camel@infradead.org>
	 <699708d7f3da2e2a41e3282c1a87e6f4d69a4e89.camel@intel.com>
	 <c7eab673dd567936761a8cc6e091a432b38d08da.camel@infradead.org>
	 <SA2PR02MB756478359EE9185285ACE6158891A@SA2PR02MB7564.namprd02.prod.outlook.com>
	 <DBAD995F-C9E1-46C8-A49A-9D774D6D4612@nutanix.com>
In-Reply-To: <DBAD995F-C9E1-46C8-A49A-9D774D6D4612@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPFA3FE8A23F:EE_
x-ms-office365-filtering-correlation-id: 5f191f39-55ec-49fa-9c67-08de5e382320
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?alJDYWY4OTlWaXpZN1o4V3BCRytyL09xdFZaaUhITlFHY0FvTGhCTGVuRXdk?=
 =?utf-8?B?QVhESExCS0lsTEdTR2lQZ1JrR0t4clM3Q3NXTmtnTWZuV0ZtNGN3OVZTVk5L?=
 =?utf-8?B?cDJaaUtySnl2ellxNWFrWVdFUm4yaGo1bXYvSTNzY0NWN1YxMmRBc0NSbXpN?=
 =?utf-8?B?RWpUTWNaUnN3Tmk1bkREZUFjZ1pzNVpSN3JIRFVZM285MTh3MkhvMXpYbXdm?=
 =?utf-8?B?THlOMlgwMmdPcGI1QVU1NmJ2QThWVDNMcFdJNEFkODB5UTZ2a3hqLzM3ZFVN?=
 =?utf-8?B?MTNkTEFxTTZKTVZFS2NlTDNsSGtudElrSENUbXF1aTBIWEV5c3M3YmtkQTlQ?=
 =?utf-8?B?RFFJLytJMnRvek14eklKQXlJZHp6ODRIR1lKeitySjVVbWJsWXlnb2diazlY?=
 =?utf-8?B?Q0V1dlZ6NHkrY09RWDFoMFZPMWtIOC8vbkpURkdrV3FrdWc2MEFQdStZTU9H?=
 =?utf-8?B?N21CeXBSaEZJU2ZGcEpZY1RzTG9pUldpZEdndDk0RHhmSm9BaC9hYTN6aTJh?=
 =?utf-8?B?Ylh2Smt6S251aDllY041YUJubzIvVTJpaFUwZ0dNUVFKWG1WdEFpVjBKcXNU?=
 =?utf-8?B?b0J2UEN5NEwvOTlqSEZ3Q3QyTDhRYTlabEVaR29ScHUvWkFDYWc5d3lydDhR?=
 =?utf-8?B?NnBUTXBlSkFIRE1ibmp0dW5lUjJEczRDMi9QQUs5M0VibE9hcFZra2QzRkhh?=
 =?utf-8?B?ajhQZzJGam1VbVFvVEgyRHVlSThTbUVMdCs2by84SzJZdzFQYWRIL1owR3Vp?=
 =?utf-8?B?L2U2dDh0enVIVUVuT0poNXQzS1lpZlFqamg5d2lGNUNPSHhFRFpic0xNdytu?=
 =?utf-8?B?NVhoRjIrTU4vZitVb3ZHSzBsVmM2cFB4ZzRsK1poRWNDejZLOFVsMkJtSjJk?=
 =?utf-8?B?Rk5Dbk1EOHZUcVBPbjIxNjBKWWdMK3UxN1VGSjc5TjJVdW82MDkvcy9IMFUw?=
 =?utf-8?B?Z1dhR2FrVXZHYjdvYzBvc0VFMERNdnBvTndOYlhRSnloYWltY2JtemxySm1T?=
 =?utf-8?B?WUNkUXNKWHl0b3pIU1BENEc1K1FUYlM1bXFGRVJWQWo3dzVINFQvOUlEY0JP?=
 =?utf-8?B?dmcvZVVyU3ZwaGJoUkFZd1kzV0hhTW0yWThnRktOOTFDS2g4emxFait4bDhT?=
 =?utf-8?B?YUNWUUpJdFhzWXNsZXNTTytYL1ppZlExTXZYVmtwVVdvVUF3M2JqazBwMDY5?=
 =?utf-8?B?YWhDWlBDVFZTUUE3cVFVRGpWUTZsdW1zRmtYR3VHamlPcjBCMWNQMzJyL2Ja?=
 =?utf-8?B?Z2xWelovMHRoTHFuVzdFVm9JVjFWQ2pHbmNMSDNnM1FaNHJydlRyMVNGblVV?=
 =?utf-8?B?Y3l0dEMxSEJ5Wm1tOFRwV3l0bGNwR3lXK3UzYU1KVVRQWU0rL0ZTbkZLdWRF?=
 =?utf-8?B?YS9LcGtjd1A2M0w4NWdsSGprVE5QT3ppWXNLVWozT0g3cUtBd3hlS3IzOU5S?=
 =?utf-8?B?QXlKMmJ3N2oyYlVRbEh1bUtlZGZwdFNxRUtKYW5ncWNpblcvenk2MHBHWmpo?=
 =?utf-8?B?NG52YXYxTitXbUM0S3NhWUxNeWZ6Q1VOT0laMzZ4WEFiVEFwOG55dC9teHFw?=
 =?utf-8?B?b0R3SHlCd05UaENxR2F0WjZ2TDlqVXRxK2pVMUduZEVBeERHZHpkN05MZ1Jr?=
 =?utf-8?B?OHVtOVh2eXFQOUYvdDdPRzRJUEI3VzAweXg4T0FnM25NaE9KeG1UQmVIVG1Q?=
 =?utf-8?B?VDB5TkljTTdVajZUcTNnUmNQeFIreU1qci80bGMwaDlwZWxhR1hHNEJHNGc3?=
 =?utf-8?B?RkZMaEpGVHZSNVJuVmdPWW02NzZYT0FvamZSS3Fwc1VyS1VQRDVFcUlpdzZM?=
 =?utf-8?B?WXZhdHpuM0MvNzhoZDVueTdRY25PL0xqQTFpRHovQ3REMlNJc2xhRm9JNjIw?=
 =?utf-8?B?NDBocjVvWXJ0Z2x0Ni9DcDhkakpodU5McFZyZWtNWXNUNTMyZDFjVStsemEy?=
 =?utf-8?B?WmJnM1V3Z2hCVHNQTHQrRkhEbWo5MGkzczZmTXNLN0ZlUmFCdlFHdENhc2pV?=
 =?utf-8?B?bWNVS2gyczJ5M3VCckZXWk5TcE12UXpEY0g5TGh6M2tZR1dTbmpaWFUrMEc2?=
 =?utf-8?B?RVRDUGNiMWJpQUNkT0k2VXlSRmFXUkNzcmJFcFlndmZZdXE1Y2k1ek1pRE9Q?=
 =?utf-8?B?WDZ5OHErTTZaL2loZ21vYmFXQTVYeTF1QWV4Ym1FQnpPaGdpMFhrL0NJR01C?=
 =?utf-8?Q?0KW4+azMclCPUvri5JemrTk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXNVRmpKeHJNTGVaOHhNWUVhMkh5b0R4RENKV2VndGpvT2Zrc0lCVXVGYjJi?=
 =?utf-8?B?OG40em1QOGxtTGpING5lM251bkdGUlBnaUIvUU1nN3BXeVhTVFROR3FwaHo5?=
 =?utf-8?B?NGZGaTYyVlhMTmpubThzb0lBUlRIaktFclJleEJwamFBVEZmcjFjYWJ3T053?=
 =?utf-8?B?enlMekZBd3B1Z1drVzZNaFZJbjNnWnZIUkNEWDA5emtRVWM5V3B1SVpuYURI?=
 =?utf-8?B?L3pLTFlxbGw2QTJoZUFya1dIa3MwMzhiNDE2WDVaN1Z4dGxIMWk3V1NhZjhy?=
 =?utf-8?B?SG5aMEZRMXJVTExuVkNyOHI1d2tXZThna3BONUt0THlWWVppNmhnN09yL2tm?=
 =?utf-8?B?R1VkaDB2aUJZTlZNWDZjSnlWVTllZEVONlRsQWR0R285MWxtZEd5bmR6LzFw?=
 =?utf-8?B?TzJ5NmI1RnJCVkJsa3diZzcwQ2hVZjgvMnl0VXVYcnZLZWg0ZDZmR092c3J2?=
 =?utf-8?B?ZlE3a3VidmtrWFZ4MWFCTlpuaDNwUzhjS25wcjlVSVBVK1ZPMlZSUThrRVhu?=
 =?utf-8?B?UGUwK09keEg1N0h1eDB4SkxIektBb3ZIMWc3R2RtL2VOMjlPbXZycXVnTmJo?=
 =?utf-8?B?b3lhNXk5QVRod3VpT3NnSkw0N2J1cVFFV3c1NFF1VnBaRjBmcjJ2ME82Y2tW?=
 =?utf-8?B?dzdKUFVLZU1yOUNEV08vWDBsaFFBM0dQMElsa3N5YWhZNllEYmhSaWZLN29R?=
 =?utf-8?B?V291ZC9MZ3JYR0RDUzJudktSRmNWK21pckFSS2hKZ1pWUFJHbmVYamZpckRI?=
 =?utf-8?B?L1k3UUNmSWtjRE1rbStRUDA3Y3FaTjdKMzljUlFtM0xxY2tVRWMyVzF4M1gw?=
 =?utf-8?B?aTVQdWdGdmpLMW5jbU5jYlNGelRadnZyNVdZRElhVFdiVTQwaVFta3pvRFVm?=
 =?utf-8?B?cjd6UjhLUDJHNXAwdW1hdU5BckxUbDVibU1WcEdCM2VnTUtPNFFHcUt2SWM0?=
 =?utf-8?B?eC9Qc3AxZmYySnRiaEZRSnQ3MThsZjh2WHN0Nk1GVlJIM0J2Y3hHNTVhc0Qv?=
 =?utf-8?B?b1ozaTlqR2ZnWk9jbGJSQVlYVm5yb3hoMjNXZUhHbUU5VnV4RmUzenJjcm41?=
 =?utf-8?B?VU1VY1J1ZWJja0Z2a3lJa2svbHkzRWdEQ2ZCMmNOaVJxZWtOQjNnOXU5OGw1?=
 =?utf-8?B?ZWZVTk1UR21nRUZ3NitTc1h6N2hqT1lWVk5XekFWSm12OEN6VGFiRWo1azN6?=
 =?utf-8?B?aDlxdE8rcU5wSy9abGNlR28rK3RvbkxtZGVmNHJ3NmlvOTA3NkREVVJTdS9B?=
 =?utf-8?B?czBROGpPWW9oZFpLRzE2aVo1NWNnTHp1Ui9KV0VhZStBVUJLdTI3aW12blk1?=
 =?utf-8?B?Y3hNRnVGM2xsMXB6SjFjU2RoaEpISzJ4TWwreStHd0IxSFp2R3ZKdTA5dUYx?=
 =?utf-8?B?NTZlRFlBdkltbmN5ZCtpOGZGYmhxbkkwd0VlV2pYeEJIM3pjSTVTOENlOEh2?=
 =?utf-8?B?ZkVBQ2VYdElwcXNxSitjNjA4RzB6eHJ1Yno3RnpQZEpteHpNZHp0eWFQV3o5?=
 =?utf-8?B?V3ludnZWU3JFVmN1cGl5STl0R3FuOW9OSENwb2p0aW1BZmQvSVhwRlhSaDd5?=
 =?utf-8?B?NW8yMGd6M0lTL2dLanBrWE1zYlUvVC9NSjlLclgxMHE3N0NiR3c1ZmhHbE5h?=
 =?utf-8?B?aTNUZmJlcUZISGZJaEdqbXo4SDJPV2RmZWdiRkVrbkl1V3pVYS81dTl4azZI?=
 =?utf-8?B?MThVTjF4aHV0UFIwTkFyM1RKQXc1bnRPdURIdVhxTEZRcnpJdEk5anhhSkRp?=
 =?utf-8?B?QnpLOE9ZV3MzVGloVy9mRlFsMDk2UjcrMEhseC85cld1WEs3VXJDUzJpSlAx?=
 =?utf-8?B?dFJ6K2c5ampUTERmb2tycmNxaU5iNjN4cit6eUh5bk9aZ1JwVWNXWVlJUUNX?=
 =?utf-8?B?OFliWlRWMjdvcjdXZ2Rld1R4MEhGQlZwOXdhZmZaMlQ4UnQ5NitjQUYxbGFI?=
 =?utf-8?B?cDFlSnhtWmtnNEw4Sm45cEIxTnN3b0VBdjg5SVkvQXUzWnRqci9TaDFiTmV4?=
 =?utf-8?B?bkFBY1BIZkZ5NUJwZGI2Ym9ocGxyMU9YNS8zeVdGQ3NMbklwYlRSVXlxVFBk?=
 =?utf-8?B?eWMxV3psZXl6WXJKRi8zbkZCUXpQNzVGdzVDQ0xTc3puM1ZBL1RNVnhqVW0w?=
 =?utf-8?B?N3RadnU4Wm54ZFNPS1RHM2IxODlUdENWUDNCMUVYcHdjbEFuTHlGc3pIMkhE?=
 =?utf-8?B?OFpFbmhuU3JoVWhMbXlGWW9TaXRqQkxHWTVHUmU2Z3FCQ3VNVHRDV1RoZUxZ?=
 =?utf-8?B?RVo5SFVzRGN0RmUxOWc5WGc2eDgxbGcyZzdiVU1mVHQ2UTZ0VERvMVBKbWs2?=
 =?utf-8?B?WEhSdHl6SkN5N0tpT3g2QlFRRlB3NVZnVjBNd1FiYjZvTXNJcFY0UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2329CFFA38DAF41AF2E558CEEFCE3ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f191f39-55ec-49fa-9c67-08de5e382320
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 06:40:33.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuBkhbf1I4yCTEVJ6J2B3l6JvobzpjZ3TAjqkkGrIOjf2ACzoRzASixSLAaJaWbzUG+fAMeSoEOJ8O/jMTxhWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFA3FE8A23F
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69330-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 2334A9D7CD
X-Rspamd-Action: no action

PiA+ID4gDQo+ID4gPiA+IEFoLCBzbyB1c2Vyc3BhY2Ugd2hpY2ggY2hlY2tzIGFsbCB0aGUga2Vy
bmVsJ3MgY2FwYWJpbGl0aWVzICpmaXJzdCoNCj4gPiA+ID4gd2lsbCBub3Qgc2VlIEtWTV9YMkFQ
SUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1QgYWR2ZXJ0aXNlZCwNCj4gPiA+ID4gYmVj
YXVzZSBpdCBuZWVkcyB0byBlbmFibGUgS1ZNX0NBUF9TUExJVF9JUlFDSElQIGZpcnN0Pw0KPiA+
ID4gPiA+ID4gSSBndWVzcyB0aGF0J3MgdG9sZXJhYmxlwrkgYnV0IHRoZSBkb2N1bWVudGF0aW9u
IGNvdWxkIG1ha2UgaXQgY2xlYXJlciwNCj4gPiA+ID4gcGVyaGFwcz8gSSBjYW4gc2VlIFZNTXMg
c2lsZW50bHkgZmFpbGluZyB0byBkZXRlY3QgdGhlIGZlYXR1cmUgYmVjYXVzZQ0KPiA+ID4gPiB0
aGV5IGp1c3QgZG9uJ3Qgc2V0IHNwbGl0LWlycWNoaXAgYmVmb3JlIGNoZWNraW5nIGZvciBpdD8g
PiA+ID4gPiA+ID4gwrkgYWx0aG91Z2ggSSBzdGlsbCBraW5kIG9mIGhhdGUgaXQgYW5kIHdvdWxk
IGhhdmUgcHJlZmVycmVkIHRvIGhhdmUgdGhlDQo+ID4gPiA+IMKgwqDCoEkvTyBBUElDIHBhdGNo
OyB1c2Vyc3BhY2Ugc3RpbGwgaGFzIHRvIGludGVudGlvbmFsbHkgKmVuYWJsZSogdGhhdA0KPiA+
ID4gPiDCoMKgwqBjb21iaW5hdGlvbi4gQnV0IE9LLCBJJ3ZlIHJlbHVjdGFudGx5IGNvbmNlZGVk
IHRoYXQuDQo+ID4gPiA+IFRvIG1ha2UgaXQgZXZlbiBtb3JlIHJvYnVzdCwgcGVyaGFwcyB3ZSBj
YW4gZ3JhYiBrdm0tPmxvY2sgbXV0ZXggaW4NCj4gPiA+IGt2bV92bV9pb2N0bF9lbmFibGVfY2Fw
KCkgZm9yIEtWTV9DQVBfWDJBUElDX0FQSSwgc28gdGhhdCBpdCB3b24ndCByYWNlIHdpdGgNCj4g
PiA+IEtWTV9DUkVBVEVfSVJRQ0hJUCAod2hpY2ggYWxyZWFkeSBncmFicyBrdm0tPmxvY2spIGFu
ZA0KPiA+ID4gS1ZNX0NBUF9TUExJVF9JUlFDSElQPw0KPiA+ID4gPiBFdmVuIG1vcmUsIHdlIGNh
biBhZGQgYWRkaXRpb25hbCBjaGVjayBpbiBLVk1fQ1JFQVRFX0lSUUNISVAgdG8gcmV0dXJuIC0N
Cj4gPiA+IEVJTlZBTCB3aGVuIGl0IHNlZXMga3ZtLT5hcmNoLnN1cHByZXNzX2VvaV9icm9hZGNh
c3RfbW9kZSBpcw0KPiA+ID4gS1ZNX1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FT
VD8NCj4gPiANCj4gPiBJZiB3ZSBkbyB0aGF0LCB0aGVuIHRoZSBxdWVyeSBmb3IgS1ZNX0NBUF9Y
MkFQSUNfQVBJIGNvdWxkIGFkdmVydGlzZQ0KPiA+IHRoZSBLVk1fWDJBUElDX0VOQUJMRV9TVVBQ
UkVTU19FT0lfQlJPQURDQVNUIGZvciBhIGZyZXNobHkgY3JlYXRlZCBLVk0sDQo+ID4gZXZlbiBi
ZWZvcmUgdXNlcnNwYWNlIGhhcyBlbmFibGVkICplaXRoZXIqIEtWTV9DUkVBVEVfSVJRQ0hJUCBu
b3INCj4gPiBLVk1fQ0FQX1NQTElUX0lSUUNISVA/DQo+ID4gDQo+ID4gVGhhdCB3b3VsZCBiZSBz
bGlnaHRseSBiZXR0ZXIgdGhhbiB0aGUgZXhpc3RpbmcgcHJvcG9zZWQgYXdmdWxuZXNzDQo+ID4g
d2hlcmUgdGhlIGtlcm5lbCBkb2Vzbid0ICphZG1pdCogdG8gaGF2aW5nIHRoZSBfRU5BQkxFXyBj
YXBhYmlsaXR5DQo+ID4gdW50aWwgdXNlcnNwYWNlIGZpcnN0IGVuYWJsZXMgdGhlIEtWTV9DQVBf
U1BMSVRfSVJRQ0hJUC4NCj4gDQo+IA0KPiBIb3cgYWJvdXQgd2UgbWFrZSBhbiBleHBsaWNpdCBf
RU5BQkxFXyBiaXQgZm9yIHNwbGl0IElSUUNISVA/DQo+IFdoZW4vaWYgaW4ta2VybmVsIElSUUNI
SVAgc3RhcnRzIHN1cHBvcnRpbmcgSS9PIEFQSUMgMHgyMCwgd2UNCj4gY2FuIGFkZCBhIHNlcGFy
YXRlIGJpdCBmb3IgdGhhdCBpbiB0aGUgQ0FQLiANCj4gDQo+IFRoaXMgd2F5Og0KPiAtIFRoZSBm
bGFnIG5hbWUgKEtWTV9YMkFQSUNfU1BMSVRfRU5BQkxFX1NFT0lCKSBpcyBzZWxmLWRvY3VtZW50
aW5nLg0KPiAtIFdlIGFsd2F5cyBhZHZlcnRpc2UgaXQgaW4gS1ZNX0NIRUNLX0VYVEVOU0lPTi4N
Cj4gLSBFbmFibGluZyByZXF1aXJlcyBzcGxpdCBJUlFDSElQIHRvIGJlIGNvbmZpZ3VyZWQgZmly
c3QuDQo+IC0gTXV0ZXggcHJvdGVjdHMgYWdhaW5zdCByYWNlcyB3aXRoIEtWTV9DQVBfU1BMSVRf
SVJRQ0hJUC4NCj4gDQo+IERpZmYgYmVsb3cgKGNvbXBpbGUgdGVzdGVkKToNCj4gDQoNCihTb21l
aG93IEkgb25seSBzYXcgdGhpcyByZXBseSBhZnRlciBJIHJlcGxpZWQgdG8gRGF2aWQuKQ0KDQpM
b29rcyBiZXR0ZXIgdG8gbWUsIHNvIEFjay4NCg0K

