Return-Path: <kvm+bounces-56361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 409C2B3C2CA
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 21:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4167168681
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4D3233140;
	Fri, 29 Aug 2025 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2zYGB7k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F130D30CDB9;
	Fri, 29 Aug 2025 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756494215; cv=fail; b=SVt3UkPyq+iVXVhlDo2e8ZdMwy8fbAHj9z8ZublCaKG1riF+pRGPshTS8Izx6sLQtanjknHUIzrhh1qG3JYBaqbXjP2+Bmqm33TFhRi0ng5hmcBXUBGgrl8YiDgPn7G6haYW01j/Mql6rxL7Q77NkCxCZEIJuT31YJzEkzEZbWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756494215; c=relaxed/simple;
	bh=2WGP3XQgwpVwaAyGsCa/d59rJQLJsOw0dNoWRoHWpTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iq7TY4X5VbHCdJore44wr50egt5cqhYElYdqNUmkLpsbw/+m8PrqR4Pq1wC4Wx8GKfFI4NiFpaUv/WN0uUDQbMwcR92fKsYK58lxVp7FXucNTmmxaERbwyYyhp7weO+rQSJB2ozrwRJg3DL+lfgekFLsAkQUKGf+W2bH6K+YrVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2zYGB7k; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756494214; x=1788030214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2WGP3XQgwpVwaAyGsCa/d59rJQLJsOw0dNoWRoHWpTA=;
  b=O2zYGB7kW2oofNh1exS7G4wUwpJZgC9WEote0Aq1BRjsgCF8T507AYmk
   VI7Xb4/CrEQYxmETdo7sBMnx7Sf343HIhJSuY3nWy/rpHOz1yge8bFyco
   FajVWxzbWfhvnu8CR+yxvZul6OGAu79fPjHguvFtT9y7iw8aNHiMQGj7Q
   Ick+dmmVtD/fWgSJ+A95I3ZQDqcbw3zv63QnQ/a3CTGrdSdMQ/1dHgUml
   QpRGLZl41Cnsr9c49w9U2C/P0QEUKAkT/YIpSj+TIgSSEGJE+t06z8VaI
   26S5bL1lteU6n+rzWJyWOCttUb69hkzSYo1q5F8MNHX70qGY0admVmzmr
   A==;
X-CSE-ConnectionGUID: jXUTDFAERsyn+ZvV4Q5RIw==
X-CSE-MsgGUID: 0+jKfoAYSiqW1evv096uJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="57981166"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57981166"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:03:29 -0700
X-CSE-ConnectionGUID: uQxjGDZUS1aOXFdF6ns31Q==
X-CSE-MsgGUID: B0aVAE4bS/2VxtSSwH9qKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170021062"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:03:29 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:03:27 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 12:03:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.43)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:03:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X968w68xyqhyIqF6NT5N7dN9lgSfSRzTd5Kg/hucPgsgS/LCsX/oTwK9c40r41lNfiQmlwQi1JofgCFq0WEwbXjGegrjv4LQnimEB10X1+oDaW7nr4/pPbVbhPqym1vc43+CZ+MqJ9F5OL6n1yQFTTnMboKH5VwHeQ8CWen9KjGURNGKEiRGjFjIO5PJkXUwsQMA6sxl8yBdsDTq+yMf02slA3pEzsvA2Rgbj5BUaDuVytMwkTXQKqf4VwKe4WujH1HUxtWSthz53YvqV9xO3W1QJHTSbCjtphiFzAHZcx8g7KcAIcl5IATtU+uesKxVRpDYFDR7ACuaLQaETxjo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2WGP3XQgwpVwaAyGsCa/d59rJQLJsOw0dNoWRoHWpTA=;
 b=dk+lJJkqVZrs+xvsfWb2MnZ1rtC8E7xOiSQVtL/YpiUfIU9nwN9wcZXWr1+skDcX+wMatLUHulavgbq184NmFAyco971LWC06xPqZvssSi6Moq3CmuD6W6W+Q/hsLHv6DQITBYzQdghjZWWqAF2TkeXgvYPTxzQysYwO3nx011PCYgrRez+P0gIm83oY2PYcYU+kct5unxwQ2U8Yb2Oe1vQtuQo2oLZFiBdgGGO4n9gtIPFgaGM1120Sgd3NJ6gN2uJGVksnqEYeqQfd8Fhz0A4alMhKQPIRXC0VYgwwzh/pZKC9snNV76VAZC6wmT+4EzDhtYZysy3e5FEl1Ic9Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7107.namprd11.prod.outlook.com (2603:10b6:930:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.18; Fri, 29 Aug
 2025 19:03:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 19:03:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 04/18] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_page_prefault()
Thread-Topic: [RFC PATCH v2 04/18] KVM: x86/mmu: Rename kvm_tdp_map_page() to
 kvm_tdp_page_prefault()
Thread-Index: AQHcGHjNwyzlovJpYEKWVkQblTJ9mbR5/iqA
Date: Fri, 29 Aug 2025 19:03:08 +0000
Message-ID: <f17b41c9f4e429ddb595a300cb85b95854fddc15.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-5-seanjc@google.com>
In-Reply-To: <20250829000618.351013-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7107:EE_
x-ms-office365-filtering-correlation-id: ea0e760f-b3e5-45da-694f-08dde72eb145
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZjJpbzg5bXZTUnJPNUsrUHdNR256aitzVnd5OG5DN0dBYVV2Sk5GdVRoOFF5?=
 =?utf-8?B?VWh0TkVlWDFnNzlCdXFCTWdlbGpYbEp1Q0dVeStBWkxhNlNuWksvQUExTE9R?=
 =?utf-8?B?ZnZvK3lXWGl4VTczMjRVL0lCaVRLd2dxZENoOFQwdDVOY0FsZU5kNFp2Qmhq?=
 =?utf-8?B?bitTeVF4dTBKTkZ3WS9PUVJqdmk3SjdKcnV4NEJIL01zTWN3NTJ5R3VCK013?=
 =?utf-8?B?N0UyNDFJL0lRUHQ5dzlSWEpTd3hET1A5TGNVZWZPdS9iblFPd2tGdThhUlFU?=
 =?utf-8?B?M0F4MGRLVEhya05GTkFHQTlPbU5LOFY1b2lmUU1BQ2Jna2w3cVN0Zk9iajh0?=
 =?utf-8?B?WnpWenVYWjBGKyt3S3o1eUdTUXJ1d3QrK2xHVklZK0IzdnRWWWVxN3JjZGpy?=
 =?utf-8?B?alBGY3lkWlVxOERwa1dvdU1NdVJoWE1CenI5VXdKZk53MWVPaE9zMjZRNHJF?=
 =?utf-8?B?bDEvKzV6cThoVHlPaTNuV1hCNmg1TVVkalVRUmUwVXVLanRPNGlUaEtrTTA5?=
 =?utf-8?B?eWdzZkRiTGc2eEFvY0kxS0FNZG9MMXRKOWlnT2o1RkhneWhINjNwTlF5Z1Np?=
 =?utf-8?B?Smp5dVJERnhNeXBzeFBVWFJtSTl5KzRVR25jUkZmeEdVTVdmWFJqcDRWNk5K?=
 =?utf-8?B?a0VpZ2hrL05pbkE0Yjgyd1Y0R0ErV3dseVcwSG15OWJHQXhpUXFYUVhtdFJX?=
 =?utf-8?B?R1l4blIrUGJTN0ZiVEFUdnF4MEhOamZuc21HRG0rZHUzVFI0Q0ZxUTQ1d1Vw?=
 =?utf-8?B?VHNDQTZYbmtyMC9wNVFiY0crZnEvVlBWZStaeERwbnVtamlCOCtaTzJkVHR5?=
 =?utf-8?B?N01FdnlXd0llSnZnTnF3cVl1d0IycC9hYTRkTGFycXdaNFJDNGl4SmtnSjJ4?=
 =?utf-8?B?cU1ncXRTZUNEODVLZ1NJamJvRkMxT0psdlVjS3pxUkFjbGpUU3JPbnNzMEpG?=
 =?utf-8?B?ZjMyd0FuRnNoa1lUUUFRd1QvcDVaQXB3clBCdnJIN1pDSWgxMStQVFU1TkRt?=
 =?utf-8?B?ZEd1ZlIzSHc1Z0VqMHVIb1dMQ0VHVXg0Y0lQY2x1RzJxc2o1bWxuUGRNV3FT?=
 =?utf-8?B?eVlkVDU4R1V0SDBpWE5UY2cxdVFVazA0eHRmbW91Y0NuYy84bFl4dG9FQjY5?=
 =?utf-8?B?WGJJQlZrSkNVUjJnUTF1eDd0cXhlQWlKSjBmNEwyb1hlcno1STdPTWFQbmhD?=
 =?utf-8?B?WG9hNEhINHp2N3Q2bzJJdlNRQTZXRFZiL2R0eUxYL2YwKzVuQXNhUWpDSnB1?=
 =?utf-8?B?bm1pZDBuQ21DRExRcFkxMUxIaFcrYjlwYkdXeDFJV1l4TlB4YVpBQjM5NE9z?=
 =?utf-8?B?a3pUd3BQUDZmU1Z1dm5MZmlBS1U0TUNGRVpsNjUwdnVoQW1sY0ZDT01OMWYz?=
 =?utf-8?B?VHZEdVNsVDF0N0VWQWdTR2VwZktyNkhPSEp6UkkyYkVqeVdrOXhZc1dQM0pM?=
 =?utf-8?B?MHFSVDNTN1ZKT3Ard2UrL3BXVkVST3dKZ3NPenF2RUhyOUhycWpEdmlaTVBa?=
 =?utf-8?B?S3R1aEVXTDRadUpkc0hjSnhoaDJrWHIxRDhkbTVONHFUMlpvTXZBUWZxQnVX?=
 =?utf-8?B?RVlWUGpCc1BoNzA3Y1lUb1k5T2tIcFdIT29zRVEzOS9BMldnNXphZVhKNnhY?=
 =?utf-8?B?bUdoTjZmUUdhMU9yemhYUEVrWU5xME5JUHFoOXpCOXpLdnM3Y0ptQ1daZFZm?=
 =?utf-8?B?WXRqS3NjdTV4WDZjZDJPL3hIMm5RakxBQS9ERDJKa3FNcWh6MFFsY3IwR1Qr?=
 =?utf-8?B?N2UwYzhVWlJxazhYNU0raU1CbFlKVSs5ZWliM3BmV0tITHBVZnd0andwb2Vu?=
 =?utf-8?B?VUtmaXZiczFMSi9GaXdDVHJncUVRcGZ3UEtIZFRvbHk4Rmd1WkNReUJBVmNr?=
 =?utf-8?B?NzlLTmpsK2tRZ2V3OGkwb3k0dGJlaWZETlNGaUdZMDhBS1lCbkVGRUlHbFIx?=
 =?utf-8?B?Y2d1cXE2elBFTGt3Yml5NkQxR25NNEdVQXVyeDBXVTNhQ3dtTzhvZXc4YnBC?=
 =?utf-8?B?dGRhNzIzM01BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEpuOTBTNGhhenRyVkN4QkkzUFppM25jNitIZjcwWDJ3VVlTYStGN25pdTNG?=
 =?utf-8?B?VXNpYTF1eXZoN25YeUJwaHE0d1F3Q1NDMHZGdDB4emVsZGM1bDNkMnMrbTd0?=
 =?utf-8?B?dnkyQlB4ZUlHVnpJWG9uUU5GYVZaY1MvcUJHYkRlR3VVSFB2NjRBT1FXcE4r?=
 =?utf-8?B?QmhhNVpWay9ORDZOczRKeERob3FaWFMxc2loYXUxV0YrWEpMc3Zpb01lbkR2?=
 =?utf-8?B?a2swZFdkVFRraC8yTjlXYXpyUURxTHorSjloVlJkM3pwTVNhTmY3ZzBiSnBu?=
 =?utf-8?B?NTV1YzAyMTR1MUpNZ29uL244Ni9iUUVwYW4yM2dKalhqVExjYXNUbXVhdTMv?=
 =?utf-8?B?ak11SUo2ejI4NXFhQ3p0S1ZTSHRaazFJUDJXUnlmN2lZY2psNzRDcytsZ0JV?=
 =?utf-8?B?VGhQMU1Lcm45bWVLMkRqNDRBbUtmcGdSOFVkSHBKVE9nNngwbTV4dmIxamY3?=
 =?utf-8?B?cGxIVG1PVjMwMW50eUdlV2ZLSzJ1dUNsSTJtZTJzNkRMMW9tbjFDNnNuT2tX?=
 =?utf-8?B?b01PNTQxRFlhb0pLN29JZ1llLzk4ZGFIcXR1a1BtWEVSVENWOUIxcS9xTVNr?=
 =?utf-8?B?d1VmRTF2U0NGbFc1UW0vdmwyQytPL0tSNjdITVI3MkNNNURrTEZQNjhLTFpj?=
 =?utf-8?B?SlF6dEl0M2JTMitXbVI5cG9LTmREdlF6bUU0eDBoWG90TFJTUGU0R0xjYWhT?=
 =?utf-8?B?T0llNU9WRXhIMWVLemtDS2VIVEJHa3hFZDJUQ1Zza1BsV09GSC9lTVRxeFVk?=
 =?utf-8?B?cTVWa0Z6Q2VVR084T0IvWVZndU9za1dYa3krWFVOV2RybzJocU9kaXFlOVpa?=
 =?utf-8?B?bFJERkxMRjMyTEd5RFlXMDcwTUlJUU1mdXduV3dxR2wxZlZ1bTR0UmFHblo5?=
 =?utf-8?B?RkdLUXk4RFBTR1lKRXNNSEtmblZhOGlBYmVMYkJhWHJITEJmUTZjMjNJYTMz?=
 =?utf-8?B?bUVJSmF4aTVlVVU3eUttOFp0c1ZxOXVNeXZUSjFrdWc1Ri9jOWsrRHkveFZX?=
 =?utf-8?B?SUNYcjNlUkwzZHNtSHlZeG9idXV0ZmE3K0tIQ1hzVkE0b2tjbFlJU1hsa1Bp?=
 =?utf-8?B?QllZaVo1bkc5b2RnZnhlY1B2ZmFQbE9JUXFZcHkyVGFNVWRDSDg4TEFjZ0F0?=
 =?utf-8?B?MHUyeDNHQ3JMVVQrRnJjby9DU1ZnekdGYkJOdmNlTFNmemVBTnM4VkFaQlhU?=
 =?utf-8?B?VUd4TXNDQ3hFSXJ4ZWlDOERCcm5UYmRBR1A2TjBMTFFNUUlhem1YcmRlUS9S?=
 =?utf-8?B?NTM4RlkrR3hFRmY3a0lvdW1qRVdtTHFrcnV6RkhET2VWc1NBQUYxWi9pcEhu?=
 =?utf-8?B?RU5vdEZYdGIvSjJPYmVsa0NTN1Bra1grbnRwN2k5RzM0UjJTU3BLaUFHZmFU?=
 =?utf-8?B?RXlLQzRlZ2gyL0cyM2I2SzNOU0hHRzMyWHRMbkNwbTRQK0h1QlkwRHFRV041?=
 =?utf-8?B?ZFBmZ3ZIQmh6akE5WU5kQnA3bHI1ZlBuNy8ycjlzWC9TT0VpWEVoTFV5L2xK?=
 =?utf-8?B?MXhzb2dhNHY2WDVpODF1YWl5NFB0ZEhDRzZ1UGFDNlVEOFozV2RwbTBwOEZ4?=
 =?utf-8?B?elMwMVpPMkYvaEtYdm0xME5PZVhkWTVpTTRTNWhCb0NpK08zeGN0UFVuL2pw?=
 =?utf-8?B?NE80VDl6SUtEQ2tLb2hBSEVFL0I5WTBteHZsWlNrdlpSNTlqM2RjeTZjaUJj?=
 =?utf-8?B?L0pDUWFMR3NWNTNsT1lFZFBkd2Z4STl4aEF2SzVPZHFZRm1BS0cxVWg1Qldn?=
 =?utf-8?B?TGt3NFdhRWhBMUZhVWh4ZC8rUW1TTGJrMzdQRkEyOFRyRURGeHZEbGJjemZ4?=
 =?utf-8?B?c3FZOHdtcGJsWm1aSThydktObFJIU2lpT0RzMDdTbjN3ditENnZnYkZWV1hq?=
 =?utf-8?B?WmMrT1BtLzA5aHkwcDZBZWNxNzdhaHNwblk2WFlOUzI0L2tXYTdsdXFLUDBm?=
 =?utf-8?B?b1Zoc0dGbkNkSDVTZjE1TWN2eElsNkVqTTBmMzlOR3JFdEczbkcxcWR0WEJY?=
 =?utf-8?B?dHB4UUJYSi9rT3ZiL0h0a1lra0xac2VtK0trK25kVFJtbWFXRE5rak96Ti9s?=
 =?utf-8?B?S1MzNEJOdzBKQ3JjQk5IaUs2SUJpTnczNmNncHRjVDE0L0FEU1YwS2FLdGxk?=
 =?utf-8?B?c1NKcUZQRHl5NlNBb1FHSFQvUHVOeUhOUkU2b0svaXFpRnc5VVJIU0J6ejR5?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <787D389B13A9CA4A94E121141ACB3549@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0e760f-b3e5-45da-694f-08dde72eb145
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 19:03:08.4634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7R4EG3LcxbVK7b/EsWaU8Xw8e/swi78F1XpMrVzfIOv9WU/s7vpJmT3ESAh/WX+e/Bep+E7Mru0Yf3A8cEiroGmiQTDbHBzB+3EdSotaDME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7107
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUga3ZtX3RkcF9tYXBfcGFnZSgpIHRvIGt2bV90ZHBfcGFnZV9wcmVmYXVs
dCgpIG5vdyB0aGF0IGl0J3MgdXNlZA0KPiBvbmx5IGJ5IGt2bV9hcmNoX3ZjcHVfcHJlX2ZhdWx0
X21lbW9yeSgpLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0K
UmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4N
Cg==

