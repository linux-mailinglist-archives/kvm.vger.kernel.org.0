Return-Path: <kvm+bounces-56014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E03B6B39185
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:12:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BF9C84E1703
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB58246BB7;
	Thu, 28 Aug 2025 02:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="faPe4Y8m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1BF30CD89;
	Thu, 28 Aug 2025 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756347124; cv=fail; b=IDPSPS7adYOLxC188nF4ABz/RcH2P2Jr0E3/XUUbWrQtTtpE2YT0CiWwA/uTu4/550nD+kYYIVG4IKgxYjXc/pDwJfHJeG9oYUhLuC1lX3p+iCA3/NHCOfoG6nboG/7pfZNwbpi2J/MhIkY5ogN3xiqWzh+hjOhC4DpHAKL+VLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756347124; c=relaxed/simple;
	bh=Cpnw3CNpLD5SnQOXXGCsZq8WqzA9NUyxZarxQXMQnzs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qM1i0UI2l//Q+WBO+X8HZTfJvyoDNabB6piJnr8y/iTGE/9/q60BOdMjyWM11Z05cNUqgpWPKJuCwVJkb2kGWO0HF/qx2DeRPQ1k++ai/W608hwxsmfDCMutSxSRZFnP3pLaLsGOIeq2TEZ9UVW5uXD/ZZYzGrXNHd0gIuBuunY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=faPe4Y8m; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756347123; x=1787883123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cpnw3CNpLD5SnQOXXGCsZq8WqzA9NUyxZarxQXMQnzs=;
  b=faPe4Y8mjkLB1Ju/menhvCpvSbBOojiLh3ldEqLTWDcMrg/p9a30X4ue
   Wm8B1Y+Jp84CGI2x6ugZNyUk1R1IJfhJ/E2jtDg1enxXACYpYQtmJtFLV
   gY6atR+UFOVZdmDbDn28AyNRJ5uENstlFLbT2ENl1AD6SWe+B3dj+fkeS
   Oe8s90T3HD6TidNfHaAMJV8d102tGEvnqutA5mLxBwVQ+XyEbnHm2xogP
   kQSMdgGezcyAOyx1u4mNiKRNu63Wp1IKWGfWicKLkeFq4fDes0/CL6c1t
   3XYAPP+JguHarqguu8ML0N7jjQ9Ae3izIzG7zB1yugnp8FGDdDudwPGoe
   w==;
X-CSE-ConnectionGUID: jsJRpuhUTb6XrsGHToeAEQ==
X-CSE-MsgGUID: p3/Znp7cQCqvHJkT+cqxcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58319124"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58319124"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:12:01 -0700
X-CSE-ConnectionGUID: 7n91T0GAQDWXAVbJvvha7Q==
X-CSE-MsgGUID: CjzuGrseQGSrYJuMnEomrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169234846"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:12:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:12:01 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:12:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:12:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ATUB8TAPi7W90wihLI3lqXf4amC/Cwr4h3Y3dICDE3rD+hezopAGmDvT28bR078sk44I4h+gS1GtxCO3sply1ju4y1MaETv/llcuuSL5sRkJEHNie6IhRZnYDVO9ywYLeu/UYCl8XKupqnciXUbefxDd/YrAp/jx4ZnMHJFtlEl+wuKhsoWgtwlJ8hbkNc9Aodbp/MT7amyJ5Z9b6D5jN31Ar9qwTA1wDAsQSXnEscRytKFlUYWF8hGJYMP0kdrjLVns2cYx2yNnebviz7X5Po6pkzGZX6QuCsRBEQnq28dxtnbN4HVIRaJVkaVcyvts7VFmjUAhP2KRWIt/Bb1iog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cpnw3CNpLD5SnQOXXGCsZq8WqzA9NUyxZarxQXMQnzs=;
 b=IjcD9z4hK2vdKwVFkGHanu3/7KRJZhuBlyja1RFaEUrdctg6KqY93Sj50r1Q0nFOUAO2DJNRbJ33z/9G5Zg5zTMBRO8hcE/Mlg2P2Va8WqtJvkVc3IxftB2GpcWKYYcmVQ8ae6ksGwgj+KRbgoGi6p1zR1FKZbnPCxO3JKf7nGwZEXyqIx7YKlHJGSRgseRSQLXpfGemm+LDElAxFx+v2pNETbWw/nlRuVLHhMBx+k8xaaKQER3EslrYBEd02dV4Bb07Bcz5zYTA/d/nQPpESgbBzC0NE//8tXaVHRBtbfzkEgFkA5N5pspFW80MZ23XcYjOFNgQ0omtu5UeLtFDtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 02:11:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 02:11:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Topic: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Thread-Index: AQHcFuZaACFmy6w2NkqjEK4wxyWKhLR3VG6A
Date: Thu, 28 Aug 2025 02:11:52 +0000
Message-ID: <11edfb8db22a48d2fe1c7a871f50fc07b77494d8.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-7-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6259:EE_
x-ms-office365-filtering-correlation-id: 387a24fb-0208-46e7-e9e9-08dde5d84105
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDZUWmdYVkRlZmNkWlhZUEJHWVFYckxqajFYNG1IWDlkcHYrb3puUFYyeWwr?=
 =?utf-8?B?bHFMMVIvdndnNEVvcTFCTThrZHVNYmprQjlKdE5PbndPTUh5U0pUWWw5U0pl?=
 =?utf-8?B?R096Wjk0WVU1K2hub05tV3JBNTV6bDBOczBzRWF6SUxSR3ZMamdMWTlvQ3JZ?=
 =?utf-8?B?eVpKRks4VzB2ZGp6YkRBOFY1YktEeVRXUDdpZkxlUzRyQWVsRitYL3UxS3hI?=
 =?utf-8?B?RXZQNjlkWm85Y3JodjhJZnduRVZzMGdrTHNPaThhcG5tb1ZicVlNcTVPMlJD?=
 =?utf-8?B?SmJZSTlVOWZxdjFiWWNZaG1jKzlZSXQvYm1WSFBJYlFYWVFTQ2UvdG5oeklh?=
 =?utf-8?B?MWIvN1RMd1UxU3hVSXdCUTJnQklnVWc1V3BMVTVMczJmbk95djE3RmZqKzNw?=
 =?utf-8?B?RVpEWE1NUDFPc09YbGtRWmZsSUhJcWpmL29BbHViUjRIbW96d1RoclNSTlI0?=
 =?utf-8?B?N1F4WU8vdlc2SjBCS1orWVE5WDI2Z3huaFl4VVBzK1VYeFppNC82ZWxWSEtw?=
 =?utf-8?B?MU1qbCs2bWNVSWpCbXFrdzhlOVhMT1RmV2xIZjBqVjgrNjN1ZWs2U2J1TUJM?=
 =?utf-8?B?Q2YrR3QwUk9jaTgySythVFRTUnBaeXNZcVJnekpiZGhiK1Bvc29RMURkWEta?=
 =?utf-8?B?VTIvRHlxcDQzZndXOTY3TW92aTN5a2E2SVJoYXVhNVBwejRIU21wSk5DV3hS?=
 =?utf-8?B?SkZpWUc0cEtianAyWml6YlpRejRkQmJwQzJxTTVyU2paSGdMOWp5RFJ2NkVm?=
 =?utf-8?B?dVdtaGcvTFlUV2U2RkFEdktESVc4REhaSVp5RHBLOENMMWp1TlVsVWRvK0RP?=
 =?utf-8?B?VC8vTnBJLzFXZzltaW93RjFnazdlNlhsTGptbkpxZ3Znc1lwZXA4bUhTZDF3?=
 =?utf-8?B?UDU4UEtVNnVxK2NCWVF2TjU5Q1R6SlpRYWc2eTVwRTRlNTlhTHlGM0RIUDFJ?=
 =?utf-8?B?NTJ4Z3F3ZGNXZTZxdnBZRTFEVWVpTU1VanBqdEZ2SE1wOVdBSWM2SG1WRlV2?=
 =?utf-8?B?b3ZndlhhdE5ZV1pyZUV2UjF2WEI5cGg1SEY1Nkp3czVvT2ExbFZuNmdJS2pw?=
 =?utf-8?B?REI0d1hRazlDdG5lSzR0aDhwVFA2dmNiczd5MzYzNVFxUmxmakRRVGxTSTRO?=
 =?utf-8?B?SWZZYUloblY2TEJiN2J6cDk2YUlMZitPb3hEQmowVzVta05JMlBVMi9SeG94?=
 =?utf-8?B?bGY5VzFDeUZFbkhuaFlrOVBDWHBMbHc1NC9CUFdjYnh2NUQ3MjFCZ2p1SDhZ?=
 =?utf-8?B?Mm9BNnRmV0xOTGZabkcxVHNSWXVvYUYwK29qUnduNHJ2WU81VWowdHBhZU11?=
 =?utf-8?B?UnhxZitRWkYvam5Pc2ZzeEhVd1R3SFpJOUdXNGNpSktZNDBJNlUrSmFhZTRu?=
 =?utf-8?B?b2tuQnlXZlBGS1g1OEErTkNiNUswVXZkK2dEWi8xL1M0ZGRhb2hJOGVZOUha?=
 =?utf-8?B?RmcvTlpzK3V3WmsvdHd4Y2lDZGFNc2F6dS9FL24zb21vK2hVeW9QT2hQT3h4?=
 =?utf-8?B?bnplUGl1ZnlLSVN6T1VKd3J4aDUxRXRqTjlCMTZ4cjlRYWFyQzRkcEV3TUw2?=
 =?utf-8?B?VEFYaFE3elJJRnkrQlk1RXBMRUdLWVBiOUZZVjdieFUzY01BVGxnamxsZkFM?=
 =?utf-8?B?SkNheENkOFNtSVVVWFpxbzBVM2FocmltSFE4L1A0WWp2MlNQWXY5NFE2VVc3?=
 =?utf-8?B?Tnh3b2pEWHFrV2NOYVNMNG9FU0FUcHBXRWl6WUR3VDlGZTk2dDNXVXNZdUc4?=
 =?utf-8?B?cnBNZkhpWUJNNkp0U2N2R1N1MzFuVXRsYmFBcGVMZ3U4NUlJT1ZNS0cwTG8v?=
 =?utf-8?B?RFhMMC9YUHpaVjBxVktOck5STEVYU1QwNDd1dGNyZ052aXZCZXRlVjl6RkdL?=
 =?utf-8?B?YzZ5cE80RDkxVGE5bUV4QjNtcDdsb3NvSHhwZmtsandTVmVqNzU0Rnlzc0ly?=
 =?utf-8?B?M2VVeW1sbXo0ZFdpbUJGUENERkpIOXBob1NTUlE3Z3JGZVRUcWxoOXB4S01Y?=
 =?utf-8?Q?3s2uuVHRWWx7nXCGz3MlMEVTTb3xv0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3RWcVhLeXdvSDZFV1dibVFFUWp0aVB3UkhjVWlwTUtEeStmdnhNZmE1VHNK?=
 =?utf-8?B?MmZDNDliaEppS2NoY2ozR0NIa1JESlZ2OTRIa0lrMEZqQTJVWmJsZWJNS1ZM?=
 =?utf-8?B?YUUrUXBtNWtSdFA4VUN3RWw1MjI1d3ROd1poLzJEeCtKWmRhNTVsWForZmho?=
 =?utf-8?B?b0NrMzlUcVFOTWt2ZW9EMVlCN09IblFNYWlXeDJpbHE0a25jRi80TTV6TTlp?=
 =?utf-8?B?dFRFRmRoUEVrZk1WM0xrYlVEdGxKamM5L3B0ZllnaUs0VU9SdlZCM2xzYk9n?=
 =?utf-8?B?N1ZsblI2Zjh5aE14blRVby9kRUEyNHF2amhneTU2dlRaSzRhRFpEbDZrZk5C?=
 =?utf-8?B?NmpsS2tmZXJCTXkrV3ZwaWdMZW5qakp5RFUxREdwZ29kVGw4VnhmcnltUzRC?=
 =?utf-8?B?OGxuZXVqUUtSWndZWHZ3VXZXYTBHWGpGeDFtR3VPNlRGM21kbWp2L3hsa0dj?=
 =?utf-8?B?dVErd24wSjJKTmZ1M1NxNEdWLzNIaXVVaEQyQXgzVGZWcmRjVnduUWVHdDVv?=
 =?utf-8?B?S2lORjNLUzF4U1RSNFBSc0NiemlLUm5SN2t2TktiZVYzblFVVHUyby95cGhj?=
 =?utf-8?B?S013OVVZOGQ1OXZtVS9OdWlrbGVBU2l4czh4cVc4eUI5bDErbEluS0hzVlVC?=
 =?utf-8?B?KzhWWFBQYTdxVTZPM09BSG1GTWM0QWl1NWR2QW9wMW84Z0ppb0NRTGUxckZh?=
 =?utf-8?B?dUFXWGV3NDNJU2VVMEp1ZTBvanlwWG1uVTZFZkJ2YjJ6WnQxYzVRVUtVekxP?=
 =?utf-8?B?TnVIMGFRYkxCUjJIKzhkdzBHeHVOOVEyTlZTRjJHampmeUZrOEdNWXRIZHR5?=
 =?utf-8?B?R3YxTnU5SGFleVhBZTN5eFM0QWVZa3ZEVWJValJwTE5zMTZLdW5qVHp2MEtV?=
 =?utf-8?B?R3NmU3AvNHlWNGdmZGZiRTRycGhpNGtUbHRxQytOQk4xdjhlKzFBQTgwU04y?=
 =?utf-8?B?czR5TTRwcm9SYVI1K2cwVzJRN2QwSXVJc2draDI3cVB4N3NoWFdPTVBDSGZ0?=
 =?utf-8?B?bCtBaGlwZ0xxSVVCdFNNV095eWg0MFVETExmRnpSZ0tSN3MzMzJMMVQ0Y1hv?=
 =?utf-8?B?VWozQWZCck1yak8raXUzZTlHSER3Yi9MZEZwMi8vQlBuR2RFeHdsR0VOSmEz?=
 =?utf-8?B?T01YbHM2MTdmdTNTTFBRVkhzdzNkaER4VUl0cEU1N3h5SEhkK0lSU1VXRUh6?=
 =?utf-8?B?akltOXFHVkMvZnBhQTk2Nm9FWTQxVzAvZGtzdWQvYnJRa00yU2N3Wjg4aUZ4?=
 =?utf-8?B?RmE0Um9YakV1TG1mbkRwbEFCd3FxcVNxMEcvUlJ5K2U0RkNIOU9od3dvQmhk?=
 =?utf-8?B?WWRBamNFUnF6RHlvWTFvK2hvY1h4eFVwUENvbTJRTmFFVHhpb0hWSkdDOTls?=
 =?utf-8?B?V214OUNEaHU2N1RiRStlNVpNbFoyZndFU1F4ZE15QlVpZHUrYTdFSmpKcEpW?=
 =?utf-8?B?S0NzRWxIandvOUNFNzI1c0trZTBYS1RZZktJY1FFWCtoVTEydTM1cWJOTTAy?=
 =?utf-8?B?WVdXSXNXckNCaStWclp6WnN4SW9kcUkxKzg1ckwwWEwwMlp6OW5Pb0dyNmo3?=
 =?utf-8?B?RTZJV1VCQWJJSjd6S0pWbXBxNjB1NFNzcmF5amxKWllzZFRNWHdqUnp3YkFI?=
 =?utf-8?B?eXRTMFc5UFhhTk5wSXNGY0lYUHU5ZGQxTGg4azJkZ1JRS0ZSUExVaXdoaVhW?=
 =?utf-8?B?U1ZQZ0ZWQXM5WEhWdWduNnpDMHNVaExXRWJmM2YzQVFVeVVVSkZwTG9KbWNH?=
 =?utf-8?B?N1R6RGtLazlNenVHNWFsSkZhempDM1hySi9nVE9JQ1ZIMjJXclVaZ2Y0OGd2?=
 =?utf-8?B?cGhBa29zeGw1QnhhanpBMkFaVXJ4cDVjOUZDRmJ3WjNIQTdzZzgyWFVsOTM0?=
 =?utf-8?B?Y01TcVhaTlI0VkxodWVWM1FiVUs2cGIzaDNBTlUrZVB2a3FXVmpqUWVqNkFP?=
 =?utf-8?B?VEtaWDg1V3RHNVF6QkRJQVUzK0NodUhqVXdiNWVlZXdiOGRkWnNwMkZmSGJ5?=
 =?utf-8?B?WE9Gb2YzLzVhZjJNZjZXTDkzeDhSWHZ6NXlKTy9CdTZiMmNpTUZkVUtlSG1h?=
 =?utf-8?B?WFlYODBLLzQ3aGFIRm13VHR6WUJqaHRVNjFpU0xrNVZRL2hUOGpUcVVqK2s2?=
 =?utf-8?B?WHVNTFZtUTU4MjlmQ092RFp1aCtVQXc3ZHladzA0citLUFB3T3NhM0h3UFpG?=
 =?utf-8?Q?ypvR9IaI5xYG1TRQ4soCseg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4674452F238B924E9274B09288D8C548@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387a24fb-0208-46e7-e9e9-08dde5d84105
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:11:52.2440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SU2+1OX46mehkkPZCr477B+6o9VaTXWC5I9TRoNoqzTJutVp3uaILRBkfl0kMmrYea6tQZWe+9nl28LSdTzwGBHGB7LtPGV60o1mUtriVcg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXR1cm4gLUVJTyB3aGVuIGEgS1ZNX0JVR19PTigpIGlzIHRyaXBwZWQsIGFzIEtW
TSdzIEFCSSBpcyB0byByZXR1cm4gLUVJTw0KPiB3aGVuIGEgVk0gaGFzIGJlZW4ga2lsbGVkIGR1
ZSB0byBhIEtWTSBidWcsIG5vdCAtRUlOVkFMLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYva3Zt
L3ZteC90ZHguYyB8IDggKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90
ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggOWZiNmU1ZjAyY2M5Li5lZjRm
ZmNhZDEzMWYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiBAQCAtMTYyNCw3ICsxNjI0LDcgQEAgc3RhdGljIGlu
dCB0ZHhfbWVtX3BhZ2VfcmVjb3JkX3ByZW1hcF9jbnQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBn
Zm4sDQo+ICAJc3RydWN0IGt2bV90ZHggKmt2bV90ZHggPSB0b19rdm1fdGR4KGt2bSk7DQo+ICAN
Cj4gIAlpZiAoS1ZNX0JVR19PTihrdm0tPmFyY2gucHJlX2ZhdWx0X2FsbG93ZWQsIGt2bSkpDQo+
IC0JCXJldHVybiAtRUlOVkFMOw0KPiArCQlyZXR1cm4gLUVJTzsNCj4gIA0KPiAgCS8qIG5yX3By
ZW1hcHBlZCB3aWxsIGJlIGRlY3JlYXNlZCB3aGVuIHRkaF9tZW1fcGFnZV9hZGQoKSBpcyBjYWxs
ZWQuICovDQo+ICAJYXRvbWljNjRfaW5jKCZrdm1fdGR4LT5ucl9wcmVtYXBwZWQpOw0KPiBAQCAt
MTYzOCw3ICsxNjM4LDcgQEAgc3RhdGljIGludCB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlKHN0
cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgDQo+ICAJLyogVE9ETzogaGFuZGxlIGxhcmdl
IHBhZ2VzLiAqLw0KPiAgCWlmIChLVk1fQlVHX09OKGxldmVsICE9IFBHX0xFVkVMXzRLLCBrdm0p
KQ0KPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJcmV0dXJuIC1FSU87DQo+ICANCj4gIAkvKg0K
PiAgCSAqIFJlYWQgJ3ByZV9mYXVsdF9hbGxvd2VkJyBiZWZvcmUgJ2t2bV90ZHgtPnN0YXRlJzsg
c2VlIG1hdGNoaW5nDQo+IEBAIC0xODQ5LDcgKzE4NDksNyBAQCBzdGF0aWMgaW50IHRkeF9zZXB0
X2ZyZWVfcHJpdmF0ZV9zcHQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ICAJICogYW5k
IHNsb3QgbW92ZS9kZWxldGlvbi4NCj4gIAkgKi8NCj4gIAlpZiAoS1ZNX0JVR19PTihpc19oa2lk
X2Fzc2lnbmVkKGt2bV90ZHgpLCBrdm0pKQ0KPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJcmV0
dXJuIC1FSU87DQo+ICANCj4gIAkvKg0KPiAgCSAqIFRoZSBIS0lEIGFzc2lnbmVkIHRvIHRoaXMg
VEQgd2FzIGFscmVhZHkgZnJlZWQgYW5kIGNhY2hlIHdhcw0KPiBAQCAtMTg3MCw3ICsxODcwLDcg
QEAgc3RhdGljIGludCB0ZHhfc2VwdF9yZW1vdmVfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2
bSwgZ2ZuX3QgZ2ZuLA0KPiAgCSAqIHRoZXJlIGNhbid0IGJlIGFueXRoaW5nIHBvcHVsYXRlZCBp
biB0aGUgcHJpdmF0ZSBFUFQuDQo+ICAJICovDQo+ICAJaWYgKEtWTV9CVUdfT04oIWlzX2hraWRf
YXNzaWduZWQodG9fa3ZtX3RkeChrdm0pKSwga3ZtKSkNCj4gLQkJcmV0dXJuIC1FSU5WQUw7DQo+
ICsJCXJldHVybiAtRUlPOw0KPiAgDQo+ICAJcmV0ID0gdGR4X3NlcHRfemFwX3ByaXZhdGVfc3B0
ZShrdm0sIGdmbiwgbGV2ZWwsIHBhZ2UpOw0KPiAgCWlmIChyZXQgPD0gMCkNCg0KDQpEaWQgeW91
IG1pc3M/DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2
bS92bXgvdGR4LmMNCmluZGV4IGY5YWM1OTBlOGZmMC4uZmQxYjhmZWE1NWE5IDEwMDY0NA0KLS0t
IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0K
QEAgLTE2NTYsMTAgKzE2NTYsMTAgQEAgc3RhdGljIGludCB0ZHhfc2VwdF9kcm9wX3ByaXZhdGVf
c3B0ZShzdHJ1Y3Qga3ZtICprdm0sDQpnZm5fdCBnZm4sDQogDQogICAgICAgIC8qIFRPRE86IGhh
bmRsZSBsYXJnZSBwYWdlcy4gKi8NCiAgICAgICAgaWYgKEtWTV9CVUdfT04obGV2ZWwgIT0gUEdf
TEVWRUxfNEssIGt2bSkpDQotICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQorICAgICAg
ICAgICAgICAgcmV0dXJuIC1FSU87DQogDQogICAgICAgIGlmIChLVk1fQlVHX09OKCFpc19oa2lk
X2Fzc2lnbmVkKGt2bV90ZHgpLCBrdm0pKQ0KLSAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFM
Ow0KKyAgICAgICAgICAgICAgIHJldHVybiAtRUlPOw0KIA0KICAgICAgICAvKg0KICAgICAgICAg
KiBXaGVuIHphcHBpbmcgcHJpdmF0ZSBwYWdlLCB3cml0ZSBsb2NrIGlzIGhlbGQuIFNvIG5vIHJh
Y2UgY29uZGl0aW9uDQoNCg0KV2UgcmVhbGx5IGhhdmUgYSBsb3Qgb2YgS1ZNX0JVR19PTigpcyBp
biB0ZHggY29kZS4gSSBoZXNpdGF0ZSB0byBwdWxsIHRoZW0gb3V0DQpidXQgaXQgZmVlbHMgYSBi
aXQgZ3JhdHVpdG91cy4NCg==

