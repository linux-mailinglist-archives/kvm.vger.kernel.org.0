Return-Path: <kvm+bounces-58879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 109DDBA489E
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 285997AC9BB
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD5823536B;
	Fri, 26 Sep 2025 16:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAWoQEYi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195241C3BE0;
	Fri, 26 Sep 2025 16:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758902606; cv=fail; b=JUJNbTv3yLKN6pZTYqSq9kiXVSfxLBmvQhVb+Z2/kIkIPAweZisrKxI/bQH7xOBx1TRw1TMYhd3yKJe+feDVi3wSr9wXNYxU86RFqs2Um4CwNNi8eBrl9gpzrxJ2O4xNhLu2hEQy7NRfE5buBqojcSiKtGwyLiAdFQ4RBGGihqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758902606; c=relaxed/simple;
	bh=3VzO0UBIVBBqkGNarlMScgpcKiI6iaohncMyrlErQ/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z8ZNXKcBpxmNAcscd/nCeatz5TVAHvgccX2wH9oaFPdh1TvLSq5vd1TqehXUdu/+4gYkA8SNckcRwdla8tAz1U8jumZR234B+aFwmeOcudpdRdeStTEyV39je8ZtyPdMXf0kaVkPTEtjANKOcmaekGzr+yzSnokOgFmRfX3sO4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAWoQEYi; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758902606; x=1790438606;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3VzO0UBIVBBqkGNarlMScgpcKiI6iaohncMyrlErQ/4=;
  b=LAWoQEYiBPVKfMXZnbLMDKTKGquZBbazu8PELyk9Vx7jH4Y+6+5ZAgeN
   OfBLlHNMxBNdZodALlBh86sx00aG/aRyUXtoxw1pTquAKOoT/l3NXITQ7
   HNdt1/1dMrmTVhJpkvEhbQioIOXCVModx7fKgUbCvkx8hKNCgTX0Pirag
   qUAAubybk4xelJh4olK3ad5inM1qxednqDopMro1ZOwsJeVAXWzBrC7yw
   nLxw9hM0P2SA3zDJ012BgV1BAeM+g7mBA1JluTpbQ/r3e21ftWiPz5ndd
   BnJoFg4qwFA5f1s/0/dVPV069y/9hfGwnRqlFbGs/p/41QmT8L966IW4z
   g==;
X-CSE-ConnectionGUID: IpSQoVArQju4/WsIqWU7Sg==
X-CSE-MsgGUID: c0o1bXB/SOCgOaP5cva4kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61152511"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61152511"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:03:25 -0700
X-CSE-ConnectionGUID: HiJnd7ZXRgaW9HAWIsSyhw==
X-CSE-MsgGUID: p0p/8a+eShKGJ4q0wjP3aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="181947620"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:03:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 09:03:16 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 09:03:16 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.67)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 09:02:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYptFY6FtdqzbTYZKKLrJVFIp49RZ52Jeur6Yh12DVe+5cgbPXGe0R6gP8AbFU3vYJwIgO0mzEBAKT31tXV68Hmuf+AroNqKN3CghqKJc3pRiieKqrsGSllcW8gmgLJbiFPZ4UHL95BooaqU+xAIaNkS6NjddnJjmfn479/xLazixJ3bwIH+MD/QEHjMpGxK4EzMoFmmzWjwKj6hqP2HB5k3NDwCdyzK0RFRh+SIlEmry6+XIjJYfM6RcoeyTaAJTjnm1M0f6wQqbG9SLiljyU+6l9++30WUNdaQ+zNi/BqyxGcx46He3pjEu8g3Ji6JGW3gNuWWWz39RAmP70SBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VzO0UBIVBBqkGNarlMScgpcKiI6iaohncMyrlErQ/4=;
 b=FAfgi8/7eFJVSEC92LO1lNRbH9IpZOZ5j76KtjquTqf4jXcCyEOGFuV8SVR8xby2Zy5SprYqq+TxP2GdE8CfRpZrfkbx9AnnahuV2uc6CfHnivmPZMVVoSRRR4MSMASlRnqEdDaTCMHqJAUaucOwSbWIVziovn1Pwkm/gpCbyXyykPtnv1+0C4vuKNGiYW9FoPIBDPk7ImjDoWuLdoPP4E5jAVap7yH3572VFEOzif6K2Oz8fuOjEoLzKJmPZNg11JoXLOlkvf7rRW5xB5WogltiLm2oq6/Qro6V+1cD4xZB8vXF8zC3tpayuSqswwZkZHszY6HLMlYRVh32Ig4f2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6315.namprd11.prod.outlook.com (2603:10b6:208:3b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Fri, 26 Sep
 2025 16:02:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 16:02:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Index: AQHcKPMxbI3n4d0yEEyHrd2rA1fcBLSkyKKAgADDrQCAAB+VAA==
Date: Fri, 26 Sep 2025 16:02:19 +0000
Message-ID: <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
	 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
In-Reply-To: <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6315:EE_
x-ms-office365-filtering-correlation-id: 3584d27c-8345-4d05-8938-08ddfd16124d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MFJHeDd5ZGMzOEErbHdhK3dMTHJEYnNCQUlDTVg2Y1VJV3ZubUpIczc3ekQ1?=
 =?utf-8?B?Z09BOVE4UENVckI2Mmc5c2xKTEJXQU9BQW9GdXlqekpYcVRBZTRlbVZ6YUR3?=
 =?utf-8?B?azk4NUFUSkNuKzE1V3FPSTYrK0p1K1ZNK0RTa2lLSDBuREl3eU05akNzTlFw?=
 =?utf-8?B?L3FxK2xlTmxVR1I0bmxaRytmK1RIekUwaWdqMEZKbWdSOHp5TDhUOFRZWUx0?=
 =?utf-8?B?K0VCMUdqajVwRGJnTkxLNEhlQWdSM0hTa2lPb3JyRzdDTW5yKzJvUFJXNkts?=
 =?utf-8?B?eUVsKzJmZzM3WWh0UW5CdzRPYkNXUUptb0I1YXI0SlZwSFg0ZTdQNWc4UE5O?=
 =?utf-8?B?bzRlSGhOV3dhYTVZYTVLZ3RxdXlWampzWUpaUy80T0hXMzNlVUtnYmF1UFlD?=
 =?utf-8?B?NGozeDFLWjNQSnhHcHl3QzBiSWdFN3ZYRzdNcHlaUDltRUNMSjlFdUg4c1Nr?=
 =?utf-8?B?aVBWeWFLbVczLzlqSW9CRE5lQmI1YlFjdkVwQjZHaWdUMW9LbUV6QVZpRFQz?=
 =?utf-8?B?c2tQcHZJMDM4SjB1UXFoWllTVHV0OG5VNWNlS0h4bUZJMWZZWWpQZWxFWXZZ?=
 =?utf-8?B?dUJsVExVeElwdWRWRU5Ia2ZaaTVVdy9vYTB6M3Z6bWI1Tm9UTStoRld3WUpG?=
 =?utf-8?B?MnpnSnFaYmVxUjlYL1ltWnIwMmhtd1VVNWh2K0dFT3phbUZIU1lWbXJTRElI?=
 =?utf-8?B?VlJhbFY2bVk1SVhoand0L1NqM2N6RVJ5eU9kQnVlaFZ5N2xmMEw5QTZxY00w?=
 =?utf-8?B?YlZZamFoQWdQNUpHSFd5ZVZVWG9nRzF6TEViV3ZMZU4vY0llQk8yMFpCMzUx?=
 =?utf-8?B?RWo0RXpTQWFMRUdkRWlaOGZrb0M0MWxLYkNGdVhqOG82OU9OM1l0eUtVNldK?=
 =?utf-8?B?ZUJ6WDIydDNwZXo2OVZFaWxGdUFaREU4NmNaR3doNWZsMmdFU2NwdnlTWGFj?=
 =?utf-8?B?RVlWazFCRUhtMzB5L2dzTERyOUFGQUZzZ3B2MURBMXlLRXo2QStIU29GdFU3?=
 =?utf-8?B?NjZjTGorTS85a01ENUp2R2Q4NkpnVGE1T2ZydWRKSG1xT2dWbDJQaGxNaE5I?=
 =?utf-8?B?eWtJeGtsanUwdmlnR0gzemNrMVlwS3d4WHM3Yk1hWVBZSlFwMUYxclEvSUJn?=
 =?utf-8?B?MG11YWwzaUVyeHFQbG5CREJneWRjRXcwczYzbms1a3dTU3ZqVkN6Wm9NVzJG?=
 =?utf-8?B?TFpuazU0bTU0WUlXdkQvRUtIenBkbCsvTFI5VmYxdGI5cEZzQmtFeDNHT1FI?=
 =?utf-8?B?V1ZZMWw3bGNsT3VMSlE5NzQ4OHltRXVYcmNnd1hSRHdjM3JsOGdFdUFUSkwv?=
 =?utf-8?B?YVZJTGhXZ2wxbGFVLzRXUkJtYytFOU9NTWloaWVuK1BmMCsyMlVRM1ZKMERZ?=
 =?utf-8?B?cW5qYWlvN3lDZmVLZmlyS1VHa1lQZ2diZmlQeDdTZVYxS2pJQVdQMFhxMEVQ?=
 =?utf-8?B?Q3VFVGlJWnpqZTBzR2txT0cyZ3hNcXl1Z2g3UVBBNUdHcnBEeExOTzczVVNT?=
 =?utf-8?B?WDgyL200QmdqeHlMOTV6RWk5S0M1eklyMGFFNUpsbHlNR3EwTi9OVzVJSGJx?=
 =?utf-8?B?VHZJZ2Z2VkFNY3dDd1JLVU5ZSE9zWUExQm1Xbm9ScllCN3BaZ3EwWElBbi9V?=
 =?utf-8?B?UWRJZGkwVHozTWlXd3ZOQWFIZi9vOGNiTVJvbmFWcms0dDhobTY2SjhxTTRN?=
 =?utf-8?B?bkYzUnJKalRGMW5wbG9xZis0ODdYcFlsb1VZYTJKdXAzM1JHUmsvZTVCbVJ0?=
 =?utf-8?B?cEFOaU1zYjZQcDN6UU9ldzdHY0hpV3krYVRpakdicWlHcDZiN3MzcWFhc202?=
 =?utf-8?B?OXJYZGdjVjE3SXF2V2swbk9iWW9UcERBTTB5QlFBdDErOWtKMzVBd0J1allS?=
 =?utf-8?B?M3RoMnp0b2g5T2ZLaDZhdHVTb0NWQ1B4d3BmbjQwUnIzU1VFK1pWK2RVU2w2?=
 =?utf-8?B?M2dQdTk5QlpvWDRpak9KZnNCOHBRaGNrZjN4b2dOWE5lMC9nTGxvUTBEVnpP?=
 =?utf-8?B?NTRNZVl4aUNpYmhsWXhIMkZVUWtMMld4ci9vejJsTWRIN1BYbFlPVDRMRHRS?=
 =?utf-8?Q?Ix91et?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEVXUGhhMGdiOUdCMmJlbURaSFBmOXFQR1BkZHk4Qmk2dzFUc3lIL2o5V2Vp?=
 =?utf-8?B?NjA5eWtxYVRqRW4rc2w3OHNkelBjWjhFMkl3VnBhdFVITnl2YjFPK0Y0cVpt?=
 =?utf-8?B?MTJaWVpMdUNiTGhIMTQrdUcyN2VETEI2c3BoN1pEeUtKZDRqeFV6emkyRGJ3?=
 =?utf-8?B?b1lQU1JFaWxvSzk4YVNqdU1QMFNRM1VRK0xPSktTWm5lZkl3bEVCUjdvUG9o?=
 =?utf-8?B?Z0djeHpINk4rakp0eGhvQ05QUTN6M0U1eGQyc1JTMitMODdwTU05V21HMThh?=
 =?utf-8?B?YXJZUW10RHd2K2xjazVrZmdiQ25MRzFZbmgrWDI2L1lkZzZBcXNvQ2Qxc0RX?=
 =?utf-8?B?eWp2dzM3Y09FYVdSanhBbmgzUldKQTNCUTl4K2hJK212MUt3UU8vTU1wbldN?=
 =?utf-8?B?cm5Fd0p4dGplL3NHWVk1NDVaL0wyWi8yQnRpYWpHbVJsSmM5OUF1dkFCSkll?=
 =?utf-8?B?SDcyZVo2bnVIczZIbmxlWWFDOGNwMko0RitUOHplWTBUNzVNMGMvdFJSa0Ux?=
 =?utf-8?B?NEY2dzdWUkNEQ010K2pvdFRtMmM5c1IrQXd2cGFXeXIvMHZYeFY4bDh2eHF1?=
 =?utf-8?B?N3hZNE4zUlIvMmwwWTMwV0kySGxFaFZxOFpTMEFWU0t0aGRyTjc1emNjR1BG?=
 =?utf-8?B?aDBHb29BN051aHdwU2p1NkwzTk5XQ2lPMWdxbVZUeVlVa1pHUGJuVGozTktI?=
 =?utf-8?B?aVVYbSs1TXNjZTdDUW15NGorZzg0eGFPS0RLRUxQN1kzZWFUdUIyK1NrYXlv?=
 =?utf-8?B?NENQeitKTHdaOHB3a3FCTXlWTzJCbVRvMjBoT2R5a1VlZHMvM0laSVZuenhP?=
 =?utf-8?B?OEV1YjBRQldDWUJZRk5JVk5pY2x4OGhNZlY5bFNaNmxOTVJ1NDJaeFVMTG9Q?=
 =?utf-8?B?R1ptYkpKbkNnWW5uV2pPWmtQUFJ0NTk1M05NM3FjZlNDUE1uOEc4T1FQNkNW?=
 =?utf-8?B?NHBwZmtWdGlLaFZOU2NscSs2RE5LM3NRbVBRRE1mTjNrNkwrZGhWUitPb3NO?=
 =?utf-8?B?L05pM2RSQzN6Y3VoWk9PMjcxemJGVjFlRHBDazNRVm9UdThyOWhmQ05tdXkz?=
 =?utf-8?B?MWZTYTI4WGZnSjRTSWNmUVU4SElkL1FlbGlPd3loRERmVEY4WDlVbjk0RW9T?=
 =?utf-8?B?cHlXOW8wYVRqdnV4QXllMkdYUWJnWEZXcFpqcFhaZlJlTG1ocVFFQUo0VWhw?=
 =?utf-8?B?RDB6ci96YUhiSjZoMjE3NENTVFFtbWJobmR6YVA0TlVWK1dWQStKYys2a0th?=
 =?utf-8?B?Tk5KUWk0TTZ2aWw1NXFkNTdEN0hoNng2TkJFSisvZ1M1QUF5RExXbndSVFdE?=
 =?utf-8?B?T25BYTFTcU1kTlBaVlN2dWs5RWZZbjBndDZaZmxMUFhRSEpVNDhjeEdRVE1y?=
 =?utf-8?B?aERSUjIrNDBhWjE3YmU1czJybUtGcHV0TitxSFp3OTI2cTNKV0lKamgyL2Fi?=
 =?utf-8?B?cFFOelovYmRPZ050aEJZSFJVOUxQU0lmK1E2VEE5RWRwSXpCcWlwUWs4eHdr?=
 =?utf-8?B?U1pzdEFPL2JpTTJsdCtJTS9Hc2hkL3d6VmhoVURadnlxSnY1R2wxRXFWeU1v?=
 =?utf-8?B?VGl2R0ZKYW1uN3BYRmsvWGFzYnVEZEd0azlWWlhXSTVOWkZva0VhZU10R0VR?=
 =?utf-8?B?R2VQUGhhZzIzR0k0RUxSbTFGcjZuamozTDd2T1lOMThsVVlBSlM1OU1udXNH?=
 =?utf-8?B?Q004c05BeWUrejZ1ekhXZHJvbXJXTWFJWnh5U0YrYVduOU00a2pnWDdMUitX?=
 =?utf-8?B?dGQwV2x4bFkvSGRucmVsN1BudlNtNzY1T2krSEZXVUpwTXl6RlN3MFZ0cUxs?=
 =?utf-8?B?UkFXSlRBaFlhWkRDNnhCTUllYy96LzliR3IwakFnMC9rMDBzNURycHFWTVlv?=
 =?utf-8?B?Zk5zbnJvOGtadG55aHFXb3k4Z0dZMzBKZWJZL1I5MDNYZ0JudHdOZHI0SW83?=
 =?utf-8?B?TUozNTJRVFIwMEQyeG13Z0pEVzROTU12R2FHTVBqL3JGejRsZWlOUXVCM1VR?=
 =?utf-8?B?WVhqdVZBVzdFSmdNeE5wU3Z1RG1sSWMyY0V6SC84ZTkzM0tsWmJHVUFpZWVp?=
 =?utf-8?B?ZnRiZHh1d2xmLzVBZ1RsYkxKMC93RVNQSjNYSG1IaHB4ZE1Fa00rbUpKQmtJ?=
 =?utf-8?B?K0VsN0szb3MvTFhPUHp0Y1hoZ3FETFZhWUs1R2VwYlFuMksrV1dZS0I3Zm5j?=
 =?utf-8?Q?NHZdiCQCemqda2jzVzht4HM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8551A18EC76034A8103BA027BC244CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3584d27c-8345-4d05-8938-08ddfd16124d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 16:02:19.4356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fZFlvGckA5NF0/Qx6VC9SZ4Pqn03UAKO2huT5v4wnPfPETFrQmelgvFL6ZzvcX2yudQoePjShBt6eZHVCEngwU5gp9NUqNonaZkYbw479ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6315
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDA3OjA5IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOS8yNS8yNSAxOToyOCwgWWFuIFpoYW8gd3JvdGU6DQo+ID4gPiBMYXN0bHksIFlhbiByYWlz
ZWQgc29tZSBsYXN0IG1pbnV0ZSBkb3VidHMgaW50ZXJuYWxseSBhYm91dCBURFgNCj4gPiA+IG1v
ZHVsZSBsb2NraW5nIGNvbnRlbnRpb24uIEnigJltIG5vdCBzdXJlIHRoZXJlIGlzIGEgcHJvYmxl
bSwgYnV0DQo+ID4gPiB3ZQ0KPiA+ID4gY2FuIGNvbWUgdG8gYW4gYWdyZWVtZW50IGFzIHBhcnQg
b2YgdGhlIHJldmlldy4NCj4gPiBZZXMsIEkgZm91bmQgYSBjb250ZW50aW9uIGlzc3VlIHRoYXQg
cHJldmVudHMgdXMgZnJvbSBkcm9wcGluZyB0aGUNCj4gPiBnbG9iYWwgbG9jay4gSSd2ZSBhbHNv
IHdyaXR0ZW4gYSBzYW1wbGUgdGVzdCB0aGF0IGRlbW9uc3RyYXRlcyB0aGlzDQo+ID4gY29udGVu
dGlvbi4NCj4gQnV0IHdoYXQgaXMgdGhlIGVuZCByZXN1bHQgd2hlbiB0aGlzIGNvbnRlbnRpb24g
aGFwcGVucz8gRG9lcw0KPiBldmVyeW9uZSBsaXZlbG9jaz8NCg0KWW91IGdldCBhIFREWF9PUEVS
QU5EX0JVU1kgZXJyb3IgY29kZSByZXR1cm5lZC4gSW5zaWRlIHRoZSBURFggbW9kdWxlDQplYWNo
IGxvY2sgaXMgYSB0cnkgbG9jay4gVGhlIFREWCBtb2R1bGUgdHJpZXMgdG8gdGFrZSBhIHNlcXVl
bmNlIG9mDQpsb2NrcyBhbmQgaWYgaXQgbWVldHMgYW55IGNvbnRlbnRpb24gaXQgd2lsbCByZWxl
YXNlIHRoZW0gYWxsIGFuZA0KcmV0dXJuIHRoZSBURFhfT1BFUkFORF9CVVNZLiBTb21lIHBhdGhz
IGluIEtWTSBjYW5ub3QgaGFuZGxlIGZhaWx1cmUNCmFuZCBzbyBkb24ndCBoYXZlIGEgd2F5IHRv
IGhhbmRsZSB0aGUgZXJyb3IuDQoNClNvIGFub3RoZXIgb3B0aW9uIHRvIGhhbmRsaW5nIHRoaXMg
aXMganVzdCB0byByZXRyeSB1bnRpbCB5b3Ugc3VjY2VlZC4NClRoZW4geW91IGhhdmUgYSB2ZXJ5
IHN0cmFuZ2Ugc3BpbmxvY2sgd2l0aCBhIGhlYXZ5d2VpZ2h0IGlubmVyIGxvb3AuDQpCdXQgc2lu
Y2UgZWFjaCB0aW1lIHRoZSBsb2NrcyBhcmUgcmVsZWFzZWQsIHNvbWUgYXN0cm9ub21pY2FsIGJh
ZA0KdGltaW5nIG1pZ2h0IHByZXZlbnQgZm9yd2FyZCBwcm9ncmVzcy4gT24gdGhlIEtWTSBzaWRl
IHdlIGhhdmUgYXZvaWRlZA0KbG9vcGluZy4gQWx0aG91Z2gsIEkgdGhpbmsgd2UgaGF2ZSBub3Qg
ZXhoYXVzdGVkIHRoaXMgcGF0aC4NCg==

