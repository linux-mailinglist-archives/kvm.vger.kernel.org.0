Return-Path: <kvm+bounces-16699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CA28BC9F8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 257781C209EC
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4A91422A4;
	Mon,  6 May 2024 08:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bq4hmfIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA81419BC;
	Mon,  6 May 2024 08:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714985349; cv=fail; b=GfvTe3+iNmvHLVkRLjnn6kU1YB6cA/tiF6HGqRw/1Rolp8dwFddn0mfOlGrT4r4uj1k1gLKMUCPH0KW/tobs+IHM8kdctogvxr27wnWfXN2JWdO1JR6VGAWzTBjmHpBDPNIJGZ98uojLy+cXaGuKcc6UxAA83GJniwea4PXSIOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714985349; c=relaxed/simple;
	bh=4iNjU/3i6KlC22tV8UZTKa/Iff9jBlmUVSvc3l/TkGU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gn8JbusPQCaL0aG0dd4eQdDu+1dOWjt2DzaSUbEvGa4RURixcjPN7zPtjMx9v/EkD5VbCTKdAVFh11yVh8GolXMS7G2NYmG1AFx/vm4nM1pdbPfY/rw5MTCA6Z4Tztt3lvY+HwbmvGnEcogsNqq25bfnOAU7/HtxBSuW++d6U2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bq4hmfIr; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714985347; x=1746521347;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4iNjU/3i6KlC22tV8UZTKa/Iff9jBlmUVSvc3l/TkGU=;
  b=Bq4hmfIrC0rLtcRBnsnjv8Tl6gkvEGJdXcpikEndAK4D7jkCiM9WKa6f
   7Qnq+PhBRvolm7qyEZuSjWBb+pniAWoA0OkkQzBTHAt4mN5jB4X04mWIZ
   AvvOFwI5gzQVSrBg6nfcqDbVg87C6mGB1SUBLGanuTlXA337z+/h+un8n
   TSIneR5dUiO0JLdexPAUPR2HgPdHPQguLleFCJ72Y5C3ZpGluOga1vE7L
   wVHwJ+zJ7zLEVmDpgg7xGOeK38NGdwMFOj2DAu5o73WX/LjNK/CeK1fMR
   0Wy5/i6xPWdKxlpaQGF6QVX0gdBWnkN3vhM49uSjb5gykT12sXWriRHfB
   A==;
X-CSE-ConnectionGUID: fiKKd+7oTmCqA2WUe8B7PA==
X-CSE-MsgGUID: l7lE7tfZRLOS2rsf7b7DSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="22129652"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="22129652"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:49:07 -0700
X-CSE-ConnectionGUID: oI04+sf2TYmbqwaMTn8nog==
X-CSE-MsgGUID: 956TWaReTsG7G4S4JJAp0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32771154"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 01:49:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:49:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 01:49:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 01:49:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 01:49:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICtkBy0B2SQrvLa1rV9/y+ITMNCfo4UdxjhKugX3ajy0Xauigr/OVHFUewFnIArl7urx6WqRJ9/YFLtl4+uDcEqfOKtkGeLr3LDE7bRFFtsuzNV16fodP9y70wjwODnAy5+3RE1kF1JlKbHlXRIWV2lv4ygCFnACd0OzBXGJscQnEBxaPn2dJ6uXxTTHeXLkNE//1WjpTHZgdo+XV1UMq2Qoe2cE7HsA+gfL3QzJhbsh9FAgontxpSd8bm45ddfYqBsoY5JBCceSrrDdMZVIMNW1+S/bSnHoPBUwV9uFAWNZbHJfpm90gqCBDot+mcJQjV01h3PnAmAmqo2nbVg+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZu0fSklIQm6Z699A1ff+T3rwSU6jg4Dj2LuueP95jg=;
 b=BpJPdgS2tYK586tZdNUwseenRANkY7LOrrEpy5127jTUkSTyaQ1477ecobQwgzoXI5W5mKew3KigChKdhplWJKqSC5R933X4jeoxGyGdK/lna9nIbjBGTPfON7W7SqLXKbkx6BOMymQcBpkYnPXUMPpJxyqnRJlhnkVuil6GwfekzIBf6iLRRBkvf2z6XkUObKSvpjGvW6E9waiQo8sNw8GpePPc4qRf2OnBJSYcD1F4dPbbo3Lo9s+g0BD4pUoJnCD9uXRB0Pmutpmuj8RqaW2LPiAShJKSnsC0PYxxnFU0bUErQjV1bwJ3se/5Zj8CmsgRD3Y1flF15zIS6HKiBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA2PR11MB4907.namprd11.prod.outlook.com (2603:10b6:806:111::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Mon, 6 May
 2024 08:49:03 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 08:49:03 +0000
Message-ID: <3f483ce7-0fcd-4f01-8d99-232582e03136@intel.com>
Date: Mon, 6 May 2024 16:48:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 22/27] KVM: VMX: Set up interception for CET MSRs
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-23-weijiang.yang@intel.com>
 <ZjLLNyvbpfemyN5g@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLLNyvbpfemyN5g@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0210.jpnprd01.prod.outlook.com
 (2603:1096:405:7a::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA2PR11MB4907:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b0adbb-c2be-48d0-8a65-08dc6da9612b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RG9CZFBTUGJ6TXhDNFRjd05mdkxsOGlLZkovM0VaRWFYWFJxSXVPRjRBMmxU?=
 =?utf-8?B?K0w5d29PZnBJYlJHV3VtdXJQWWxFT3crTjJpam82MEN1NVJ6RjBwSzBtZnhB?=
 =?utf-8?B?d2h3L0tnMzZ0SUl1d0tKOHNzY1Z5QkJFUHQ5K3lkdWhKRTdFQmRhdGoya0lq?=
 =?utf-8?B?UG4yQjZBbitVUUVxdWtiL2dUSm1oNXU1TXA4V0tPOXdJaGd0c2FEWFRkZkln?=
 =?utf-8?B?SUxsWi9ZeHB2K096MDZDc2VnSHNYYnVvR21pWDZSVElxd2FHUU1iVDBjNU16?=
 =?utf-8?B?N241L2pTUkxNQjd1dmFNWUxOc3ErR0FTbTdySzVpQWs0dUI3Ri9LMk1SQmdS?=
 =?utf-8?B?NVVYZHIrdThkQW5lQUJxRlhxSkMva2RnZnUxNHRiMmJDK1BXYW1oSloxZ3Rv?=
 =?utf-8?B?ZDZwZlZBZFlRSWd1U1I1b0oyZXl3SDJmOVVLd0NXY1BIYzdTL0VKNlMyV2xx?=
 =?utf-8?B?SmIxMkdrRUJRUW1GR3RhNUVySGRNVnlselFiOUM2ZXVuaXp5MXlLaGdTa1ln?=
 =?utf-8?B?VzdNa1pjbjAwNlU2bGdzMTMyejZFeXFja2pwL3p3akZOMWFQbWtBeHMzN05B?=
 =?utf-8?B?OVEvUC9qMUQzUUtOT3BhRUIwK0FQZXg2aTdsZUVYVXFTUEUwYWhzODBXNFdy?=
 =?utf-8?B?UFpNdXVWaHNJb2hFK042VndqRzBXcUhYU2lrbW1SNTNrZTZSdm10eVArcEZo?=
 =?utf-8?B?WmM4UUtqSDhrYUtTOWNYRC9xdlZDZ0ZHdDB1UDRVYk5DSVVpc1ZSU0lqUGJJ?=
 =?utf-8?B?K0sraXN5VGtKMDBkRW0xWDI0WCtLNnVtMHAvMkVieXgrdGlhUHA2TytqQWhZ?=
 =?utf-8?B?ejdyeHBUbmtURmp3Q3VXWUVWT1pHN1AwV0V2RE8vL0hWRVd0MDFjMExrOWJW?=
 =?utf-8?B?dVBJK1Nua1RvbG9BdEZlVll5QmxwaGd1NDhZOXJNNlRFSEx6L3JiZlAwSlQv?=
 =?utf-8?B?Z3E2b0tjWnA3V0VLMWxGM2hjOTZqRktBdldIdjRQMTRnTW1JTy9vaGlLa2tR?=
 =?utf-8?B?STFpRkJWMU1ZZmdmSVg1bVlqTkdyeU45dUpPWGFlZVJBa3RaNFNsaW8yREhK?=
 =?utf-8?B?OXJvd2FrTmlic3JUODNwVk0wM2I2WUUwelZrR3JFMCsvd2pIZmZBR2x6Z0tZ?=
 =?utf-8?B?cFQyRU90cGRteGVyc2ZEbU5qSTI3ZjhnRjc5bkRFQlhobE5SYUo5RGs3UTE0?=
 =?utf-8?B?a3dQOWlSU1M2TFVvUlovRkFyVlZQbUxNODhkTGVSRzA5Ty9KMktaWk9xNVhn?=
 =?utf-8?B?Y24ydUJTY2pCRkdNM3FtMXpZRHVFUXFkWjRLTlNicXFRb3dIaTF5aEZ6VmZS?=
 =?utf-8?B?a1VwcDlDZmw5enJyKzAzelZrK09kb1pXREVyTndlU2FNSHV1QVZUbnMzWU1u?=
 =?utf-8?B?akU1Q3E2RldFblNzMWdJVGVHSzBMVkxMeXVrcjdsUktjd3h4d0NvL1FQQ0w2?=
 =?utf-8?B?Z2d0OVBwZTJKbXZkTjFMbUJvOE1ZVUQyTFJxdmc1SXArSmRMQkxvdE9SOUFI?=
 =?utf-8?B?d1JxWEZtS0ZmdDYrejd4TnY1Zk5scmU0Vklma3ErTnFBVHdOaFVCa3VrWmRH?=
 =?utf-8?B?VkdwY3RQb2dEYWlWZlBXMmhJd0IrUkF2KzdpWExLd1dHMTBpRlQvaE85cXhJ?=
 =?utf-8?B?NnBKTG0zV3J3SUpnYjRYa0MyeEFTdXJNSy9ObTJDaFZCckUyNFJhU3dmTExU?=
 =?utf-8?B?eEt2aklrcjRNQkRQdjNhY2I0dnRuWFZWS0REb0RHVkRicmlxZ1hvaVdRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rk84Q3ZnUmRrNW91c2tTQlpJUjNNMzlMODhGbVE0WG1tYXFLK1cydW9OMThi?=
 =?utf-8?B?ZlliQWNpbEtQNGVzRmZYb2VTcjFVWEhzN3YrWTQ2OXpsc2liVzMraEkrQm1x?=
 =?utf-8?B?SHJ6Q05rb1paZThlRGRQWjM1LzlmeC9HSjB0SWdYNVNBT2ZDc3RaaDFrNmh3?=
 =?utf-8?B?VE5KU1FqK0FpR2IzdGJUdnluenRXZGJoQmZuMndSdm5kcmpxL0xLL2h6b1cw?=
 =?utf-8?B?S3hUR2tYd0w5VWFvSUEreXBNV2hNRXVmS0ZnakFUYmswZmVnMzhHcmdoN3dN?=
 =?utf-8?B?OEJNSDFXMHZZQmxjVzdGZm8rRktRSG5lNk5EbnkvWVFNVVY3SFlIcFh6U0NT?=
 =?utf-8?B?RmV2bEhQL1UyOTFtYVQxdXBHcHhPYUovZ0t6dXNqVzlTSm9TMEtMRnV2ejMw?=
 =?utf-8?B?anFFTUlYZlJoRC9XRnY0ZTNOcGt3Y0xVbDhGSGo2b0dnbVVHWHpsb2grYmNK?=
 =?utf-8?B?b1JhZ0psKzJORGhtS0UwMXZVWjZxTkVaQVFQOThMcDBhbUhVcmphREpxQ1Jm?=
 =?utf-8?B?TGhGbEFBZFUyU2VJSUtQN1o2UUV4WXl1eHJ1Z3lVM3VtTmg0T3E1bmNVSEIw?=
 =?utf-8?B?c3lNMWhwZ2szc0tYSmUyR1pkRmZpQ2g4OVhqNXB2MGs3TlcxVHpDdy9Ecitz?=
 =?utf-8?B?QU52Mng4M0NDZVgwM2ZNRko1SHFiV3ZsaHRnT2cvSU10Nm42ai9Nc3BsZGJG?=
 =?utf-8?B?d1NzNE1UUUhLTXNOTnE0MnJRdHdkY0J6b1ZQU0U5Tm1JZUtiRzBsMkJ0c1VY?=
 =?utf-8?B?QTRlK01yUEZ6YmxtUVlYNVVaUm5LY1lHUFVyeVNKelVINzk5WlB2Q3dOdlFr?=
 =?utf-8?B?VUJvMXRFcUk2YVEyZXNjVUE2Tnpmb1dCdXR3TVYwQTEreHNSZ09xZG1Saml2?=
 =?utf-8?B?REZsWXpBL1Y4ZzloTFpNZ2ZqYmpWZWRKaVhUY0U3dUlYMEN6REM1VllIQ2Ny?=
 =?utf-8?B?Nld1VVZub1NXOGZoYVJZUUlZUmxEbXZScytZYTVyeTJuMVlXc3FJeXJkSkRm?=
 =?utf-8?B?YmRjdTZ4M1Nxcm40Rnk5Y1pRcDlYTFJTZGJkRHNVZ3JldHRYVkJQaVNzVDh6?=
 =?utf-8?B?S1d6YzBQZVVXUGd1aitwam1Hb29STlh0eFJUQzl1TThzR2ZCRWRUckhKOUZL?=
 =?utf-8?B?dGN4SCszMHdtWkNRZTBzRWltU3h3dWpEV0FCR3FrUnJtV093cTJyNm5LVEoz?=
 =?utf-8?B?em8vbW1kR3VDcmI3N1VXT0plNStLMkJuOUNLN0pmelEzQVdkcXBIK2xITXZr?=
 =?utf-8?B?MHVLWmQ2SE9pcDloZ2hnWFR1Z0JwZWdJQllEQXhSREZ0dlVnbmY1c1U3aGhu?=
 =?utf-8?B?Sjd6NTY5UllwS2hnR01PR1Q4Ky93eWo2QU1jMTVta3lHQnNzRWZxSURLOVlM?=
 =?utf-8?B?b1c4UmV4WVlkVDd5NXNXUGh2Y2dyejBLcDBpWm5wUjZYdjhMN1lTenlxaCtV?=
 =?utf-8?B?ZG1CYWJ0T2pDbFBIWXBFRGVIa2toMVY2cnlpbnRrbzJRYlVYT0hRRit6RnR1?=
 =?utf-8?B?dkZtbDd2clRuZjB2ZWdRWk1uVWN5TEhyWXpHWTloQldUWDNVblNEZmZCbTRK?=
 =?utf-8?B?NTdESHRBQXpKWFI0Q2RVVHUxOE5MMHFFOUJPSFI5cFhFQ2RMbzZwa0Y5OGxI?=
 =?utf-8?B?cWxtWExJaE5hdXZrdG9ZZll2UjA4eTczTWhYam9ENmROUFljWU1PYW5SMGwv?=
 =?utf-8?B?SXdsWjV3OE9iekJSa0FiL2h1dUQydWVvbE54WnJmb1piQ3lpcmx4RlpJb2Q4?=
 =?utf-8?B?YUNPU042NWxtV05ncWdVblhJTTIraWxmbG5FdzZXZnVOZm53S05UaUcrSWRz?=
 =?utf-8?B?dVZuU0NsQzliRzN3QkQrN1l4akhkWVd2bVNXMitlYm5IUFRhOUV4UFNvdmhP?=
 =?utf-8?B?cU5xZFRDSTJ1ZUhsRzg5MUxROHZnQWJ5Y1JZZzZPSnJMUC9FSFpSL0lUNmxv?=
 =?utf-8?B?Unk5NWR6NVRUREpoZjFhaUN4NURoUnk3WkJXM2NhYm5PR0pNbkxFc1VDbGEv?=
 =?utf-8?B?NEtIbGlTTXFLaGRvMHZFVTJxM014dERNOVZoZHBTVElzZFRaVElKUmdCNGNP?=
 =?utf-8?B?Qk1Va0MzUkJjOXEyNDZTaEorTmFFRzdmZUZRQ1pFaEZzcjdTVUlFbEtBSGNI?=
 =?utf-8?B?K3RQMzJWVlMzOU5qRk5VRjJ6MFdlTXhVVkhJL1laaldNQm5CSzJTQUU2MHB4?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b0adbb-c2be-48d0-8a65-08dc6da9612b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 08:49:02.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwClc7+yZxnbH/gFyQ2omO0FppJUHjaJCsY31VOh8vUm2fnerC3tWfTaOY5F7z8Q51vn/s0drsNZSlqekPf47w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4907
X-OriginatorOrg: intel.com

On 5/2/2024 7:07 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> @@ -7767,6 +7771,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>>   		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>>   }
>>   
>> +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
>> +{
>> +	bool incpt;
>> +
>> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
>> +		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>> +
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
>> +					  MSR_TYPE_RW, incpt);
>> +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>> +					  MSR_TYPE_RW, incpt);
>> +		if (!incpt)
>> +			return;
> Hmm, I find this is unnecessarily confusing and brittle.  E.g. in the unlikely
> event more CET stuff comes along, this lurking return could cause problems.
>
> Why not handle S_CET and U_CET in a single common path?  IMO, this is less error
> prone, and more clearly captures the relationship between S/U_CET, SHSTK, and IBT.
> Updating MSR intercepts is not a hot path, so the overhead of checking guest CPUID
> multiple times should be a non-issue.  And eventually KVM should effectively cache
> all of those lookups, i.e. the cost will be negilible.
>
> 	bool incpt;
>
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> 		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
> 					  MSR_TYPE_RW, incpt);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
> 					  MSR_TYPE_RW, incpt);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
> 					  MSR_TYPE_RW, incpt);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
> 					  MSR_TYPE_RW, incpt);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
> 					  MSR_TYPE_RW, incpt);
> 	}
>
> 	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
> 	    kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> 		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_IBT) &&
> 			!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
> 					  MSR_TYPE_RW, incpt);
> 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
> 					  MSR_TYPE_RW, incpt);
> 	}

It looks fine to me, will apply it, thanks!



