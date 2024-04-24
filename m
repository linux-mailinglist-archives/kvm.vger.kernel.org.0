Return-Path: <kvm+bounces-15845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B305D8B100F
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:39:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 427DC1F267FE
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A558916C437;
	Wed, 24 Apr 2024 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AX+y2Pg5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0201591E6;
	Wed, 24 Apr 2024 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713976739; cv=fail; b=DOwY1EjXaEq3lflPwgqf3LBCNk+2C8N7PPq3ZsNqXdXcRjGlJIWgSVFAB87T+F7e2D3N2B32XL2FjvQUx9ssQLonnxGLh0XdNIBGBd66gFIWm/hk89MmoJSYI5OteOcdhh8IVGZZbiznFWlap8r7sBUIUxxsM9ow8fCI53jSO8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713976739; c=relaxed/simple;
	bh=V5oZkk5cg/4Dbu3anK95Y4rpHwMjZqYItAQTSMptzR8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dNCeqFkv57/8W8MCx50YhXGeddHYE/p0xxknjS31gOqO2+iGo3w0bOPv0/6Id5aSpYtivebenNOWvS2UBx3J12L4A5YhTQMGKHOO7wH9o88oTaqoVm+u0UZpD6MH6DSHeGOT6Jhy4vlqk0Q8/FCB0gHaF064MH4T7u9A9fEIGjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AX+y2Pg5; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713976739; x=1745512739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=V5oZkk5cg/4Dbu3anK95Y4rpHwMjZqYItAQTSMptzR8=;
  b=AX+y2Pg5iolxHrII4kUxq5c+U8yPyIMsO/NnOO9iWEif6oX5kPiRaB2M
   2L82Kk3UAHqldOVwopK5skbu7do9/ZeNekSBh6V/aACueOYJV//IThdoY
   IELY41CeLeJhgiWMB+seql1f9XKNpnW2o2MPV65kyeQZYpXSkN8EpiwQN
   prBos0l2jOidIVM/UxTojeX/4VgjEGDuZHunuFw0EdhTdC8EktGcSjitI
   XeqwUDHkp8NuiXH3v0R31AVJx2qjUTFA4q7FuGOx8jJ/KTfGQ9kEV3sXL
   uNjPS5Z+vOe6c0i2vNft1UPkgnyU2fbJtmbC4f4ZMSF8z044wwQDrTkKP
   w==;
X-CSE-ConnectionGUID: gxN3Taa1TxWvMjVrp75n3Q==
X-CSE-MsgGUID: xXmQB5ZjT2m0OsdAXJZJgw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="20769328"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="20769328"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 09:38:58 -0700
X-CSE-ConnectionGUID: qq27c2ROQ9K+8cr+Dlatzw==
X-CSE-MsgGUID: tvklAlJhTjSIlbTeWIceYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24835848"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Apr 2024 09:38:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 24 Apr 2024 09:38:56 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 24 Apr 2024 09:38:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 24 Apr 2024 09:38:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1BENh6tqMITxHckXr/7bxz9kmT3APbkma6iwEmjDgIy8LB4McKu0IRw5OJbfikQkzexmOxkVHnHlXaEFAdjvCpvOhHj/0nsfCbCnaKDpB+DrjMarQ9mbceaZ6mXVZfCkAZil7T0cE8yd5qJWbKgQhsmOZVAoIbYzVsdf3VirfNR96sZnNytgPC+YagukUrsKy5NUvf5LMCJWjBx5CBx/UrLtQ5DfUmhfiVxVmnAswDi6OfbPRQmvj6OJaR6Brvbl5sLSOhBwaI5XPhAYHzWabMI9E6dEyX/3yk6A1gVx3of+icEekrdWRdADmjOLhnpUEiwjrXV+RK9T4LR5YR5Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5oZkk5cg/4Dbu3anK95Y4rpHwMjZqYItAQTSMptzR8=;
 b=VpUpa6aiHWrjVbgL/KZL5evEe+M5Io2KPsswmA/oXnVZbNYO0ZMrkmbTglWrR5Dm5RkOfYNgHDtXHBHb2a0f990Cx+cN1R7fhcc9jOivajH0lDUaWBBprZedDHsGbeQPlGLs/GguIu5PoepXLj2Mj7Tvwm6ArLh2P913Yp4tfqgNaJleFSZTndSu6zLLuKYSfMK39pTyRHAd1JdC/pgq7lROWDK0INvfCSMHP3btwiluitCNAT+gRdU/FSIDe+8zBRgTJYf07WPIUhOyDSU6rZ0oj/OzbFV6P3g4w/TdVBlkJeyknHh0XNeOyiIkGikjSMJ+MLOqlOamYGz0EViZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7038.namprd11.prod.outlook.com (2603:10b6:806:2b3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Wed, 24 Apr
 2024 16:38:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Wed, 24 Apr 2024
 16:38:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC timer
 configurable
Thread-Topic: [PATCH V4 0/4] KVM: x86: Make bus clock frequency for vAPIC
 timer configurable
Thread-Index: AQHae64tVrLEvOd2BUmbFm4CAYtKL7FrSkSAgAyDDACAAAcbAA==
Date: Wed, 24 Apr 2024 16:38:52 +0000
Message-ID: <26073e608fc450c6c0dcfe1f5cb1590f14c71e96.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
	 <6fae9b07de98d7f56b903031be4490490042ff90.camel@intel.com>
	 <Ziku9m_1hQhJgm_m@google.com>
In-Reply-To: <Ziku9m_1hQhJgm_m@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7038:EE_
x-ms-office365-filtering-correlation-id: 1fb9875c-adc1-445c-4ddb-08dc647d06f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TU1QYkZqY2paVm1BV2MzWFhaQXI5aUFVWVNXb1pETzMxdnNCcFU3MVJTOUZQ?=
 =?utf-8?B?Uk9MN0FYOW1wM0Y0OS9VVW1pQ3NCVXFERVVtcVNZTVVHZTF2S3Jrbm1ZVDRn?=
 =?utf-8?B?MFB0NjlnZndrZWZnVjRkR3U2STZCZHBuelJQZFVwRzJhRDBkSmpvcVBYZGFr?=
 =?utf-8?B?ODgvV2pMTFlKdmRLUSs4c2k3YkYrZkFVaGV3R0xEWDFCRTlHdEI1dEVHTGFq?=
 =?utf-8?B?ZU9GTHBxRUpHVUpZWUJoMHpFUHI5VGI5d1REUXFmVXZFYXF3djZlRHYwTDB5?=
 =?utf-8?B?eW1LTURjMmRhOVlRYTZUdFRUSTlTQkQxSVBjZG15M09WLzEwM1J1aTVGWjNu?=
 =?utf-8?B?eG5PVzhWanZVSUtlL1k1UXNURU5YV0dPMUN1Vk90YjA2bGFZcGpzQkMwdHAw?=
 =?utf-8?B?VW8rVFFES1FXMk9RUWJ3TE5lRGpuVmJRenRBTEFCTThjN00zVjF4YXgxdGcr?=
 =?utf-8?B?L1VaZG1neUVVNSsrOGJJMHJieWxtNkUxcUNMcG9LQ2FWRjNXSExsZzZSYzVV?=
 =?utf-8?B?Z3AyNUlpU0ZNdnVWQzNqOFlrT3BoSFdIaWZIajJyRzJmSW5rU0ZHcHp0S0dx?=
 =?utf-8?B?b0FoSkJwWmhQL2tXcEFjZFdTNGdqMDR4VmIycGVyTFFKc292NVN6Q2ZQR0p0?=
 =?utf-8?B?clZodlFsN1Q0d2dUSWJpRXZ4RnpNc1lGWXkyMjRQcThBbnY1NVcveUhHUkl6?=
 =?utf-8?B?RDRkNExzRkhtWEdrMUhwVXFYLzVvaXZsYUU0ZnJGSklRczYybzNSbndrL094?=
 =?utf-8?B?UXY2Rm1wVjJuam1wSE9KYXdoRksxM2VaNTZCZUZMR0pXQ2pUdXZXcW5PUkg3?=
 =?utf-8?B?RnRubTRJbG9MMnYrWGFIaWRWbkRSSEw5S1I2RGErY1RwWDZ4NmdCYzNtTTNB?=
 =?utf-8?B?WVRBQlFvc3FUckkxQlJDSWdvL0Q3d0lnRWtoZDEwRGdpbHA3dDVkN0dzMnV2?=
 =?utf-8?B?Qlkrb1RPbW5oUVdTdzBWSDEwOEtOV1dNQW42ZVJPQ0UwV2ZxTkdEb3huZ0Rh?=
 =?utf-8?B?TklHeVRTanFMbGNTRUNDOHZlMitpeXJ2UitEa3JXMlhkSVk3ZUFPNnRwd2Q3?=
 =?utf-8?B?MzVsSElYeEJjNjJGZTNiWEtrR3FKNTNiZUpUcWNuOXpwTmRNSnZIN2VyQU8w?=
 =?utf-8?B?T25qWlNQd1hnNE9PSHFvc3BpelBJeUdTczJTZUxWUmoyLzg0M1NRcWs0b3dJ?=
 =?utf-8?B?RlhTTDB2SlErS3djZktCaDA1Mk1ZckFZUVJDN3cyOGFUNEV2WkFpVUs4eEU0?=
 =?utf-8?B?WG91YTUvTlhwcE9WcldBZnY4bnY2RVlmZUNXcDkrTWg1MkdkcTl2M0luTXNy?=
 =?utf-8?B?MFFzT0F4bDQ3SUZUd3cwd1orZEdoTW9UZ0RoMUxXeW16V3BWZlNkSVpaM2VU?=
 =?utf-8?B?cHhVQ0s2ZTQ0eXd6bGtOVUtXaWZLWXFVc0U2VVQ5dm5xTDhJNXhKSWM2dGFl?=
 =?utf-8?B?L210ZEJNVGt0MlFLRTNTSkJmY3RPVlU5Q0xvV2d5bk5ZSFovNmpPK0Zmb1NS?=
 =?utf-8?B?cXJ4TTc3RmpKZmtOYWRwRGNEZDM1ajd3dmNldzFTekFFUDNZc1drVmc0N3lO?=
 =?utf-8?B?ME43N2FhMXZKb1RCbGFpc3RHd1RMYzF0WlYzaE1VWW16UlpmK01CbDJsMm45?=
 =?utf-8?B?U2I1WndyeG41WTRoWkNSN0JMa1BpSkVTK1VQSmpFMkdlUGFWSzBKZ25KeGNV?=
 =?utf-8?B?K0Jza2lESDV0ZytIOXJBSFMxSlE2Ylp3dHBjQVdiODRiajE2Tm5NbmQyTEhX?=
 =?utf-8?B?bmpKRkc4cGJVcHJQbnN4ZzZ6THI3dWpPWXI0dXorU2tnQU44NEdRVWI2SHdy?=
 =?utf-8?B?TlVUNlB4Qi9MeGdXUmdHdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUcyWkxTY1NqR084dEdhaXBnU05OYVNwVGlTQmFtZlZXZ3hnYVlzMEJBcDRJ?=
 =?utf-8?B?eC9BdTl4QlN1MmNVT3d5TFJsSWc2YjBOcXpkRXBIdUtHZHZ3NU9XREpyS1BG?=
 =?utf-8?B?K1h6c1BWeU8yaGlUOEViOFJkbDRmVlovcGxwWERTV1F3cGZtRnlvUUd1TW45?=
 =?utf-8?B?clZwWnFVUjNoTzNJVDJCRFdDRlhYMVBmdHRtU3VQeFlpZU1xRXAyNURDRzRG?=
 =?utf-8?B?V01lV0dJdW5uV2sxYm1RV2VkVGNlYmJpT3FxK0FXWGtCeGFxUDBqczh5ay9D?=
 =?utf-8?B?aGlkYTNRb0Z1M3Z3WmlWTEJZek0yeWMrY0lveUxiZ1h4NG5BcUtkamtFaitN?=
 =?utf-8?B?NTh0T0tpS3lBWE90dnFtN1dFQjVEbXc0Q1ZrZnVrMFdYMzhYSHI5TU9kd05H?=
 =?utf-8?B?WUFxVnpacW03WUlaOXBRbmMvMER0V05malBiKzBidUNQekFUeVdYS1NyRWNU?=
 =?utf-8?B?cVRFd2ZPeHhYL0NxWHRVVWNpZThFUkc4Y040aFp2RUo5Rnd3ckU0SE5KOTNa?=
 =?utf-8?B?azlRdnkxTE50YWR4RE55V05hcThWNzBJSzVzbFV1Q2kzbkZwOUE4SDVrQWxC?=
 =?utf-8?B?anpWT3ZqcFlTWk1xakY5MDlXNUUyR0JxOXRUTGJVeVZHbitUSkJWTVhDRmsy?=
 =?utf-8?B?ZXkyTmtWRVErQm5PSW90M0ZKMWxDc0h0dHRzZnoyaTRTb0czd0pKSUlvQ0J0?=
 =?utf-8?B?QmdYamEyVEovMjhjZFVjdEhUQ0oxTGpuaTZZbnJwYlphTjFjU2xZNkJpQUt5?=
 =?utf-8?B?WFhUaCtHQ0VnNUVyVFQ5MHN5RWgrVHp0YkpTdVVvUjNrOS95L0RjdUtFaTBD?=
 =?utf-8?B?QThvREl3Vmp3SFFVUUIyNXp0TTN4WU5kOTJJeWxRNVdwRTJGQUVxRnVYaUFJ?=
 =?utf-8?B?eXJDMHg2ancrR3Q3NWY0dGNhSjhqb2lVeTV4bG5hNk12WDl0akl2a0wrbml5?=
 =?utf-8?B?RWJLNi9FMDlDMS96NG5aMHhsU1dMK0NWZkdqK2RRd0JWTVJ1aEo3T3h2elhD?=
 =?utf-8?B?NXoxd0VGMEVqN3hhM1FZZkhFcUV2R1NiOHVrVG9yRU9BVzc2NStmMGlQWmJ1?=
 =?utf-8?B?OUdqNjFDeHNhZERIQ256Yld4Y3NCQ0dRVXpXdHNqeC9QYTJtYUgyWVdWOEVJ?=
 =?utf-8?B?ZEx4RWtqNnVWYUdsb0hyV1JreHgvQ3ZLbGc5RTVyNHo3bmpoaE8xOWt4RVJT?=
 =?utf-8?B?c2ZhZE5PZTRIaXAzMjl3eHpZWmJGVTNtSzk4aEYxYW5VWHRCVzcvWUhJdlRo?=
 =?utf-8?B?dlJJeFhIR2JaWnBucms1bDIzWnFtcEd6dzE0UHQ2OU0rQ0ZOSXNXRThIRjYr?=
 =?utf-8?B?UWc0dklTZnBoWmNZTFNnYkdPYmRPT3NZcWkycXFUS3I2a2hKTC8vOHk3REl4?=
 =?utf-8?B?OE9aY3FQa0FMUUlaSG9aQWhyRW13a1JHUWF3b2RRMHVLKzBLK0hqenZYZVJv?=
 =?utf-8?B?ekk2NUdJeTYzNDlMSmdQTzBJNkM4YWV6WVZ0cVNCak44ZEFEeGR1aWpUM1h3?=
 =?utf-8?B?QzV2WWdDam5Gd3lsMDE5V3RMNytoODZ1TG1lb0pXdmxUK0tPRTZIM1FBdFVL?=
 =?utf-8?B?ditIMU9GNUpkUks5VXdWNUc3Q2dTc0tCb1llMWdTMUk1RmJXQjFNU0xCVUNM?=
 =?utf-8?B?SkVVUlZjeitYSDVEdHNKeVFyU3BDYVBNSW5HdXY3NXNwWVlpdG5QOVVKSGt2?=
 =?utf-8?B?NlQ0S3pMd2lkZzl1Y0xqY3NobFczOUZzL3FlbUw4b0hQbHpiQU5zZWxpODlm?=
 =?utf-8?B?NmJnMHlubUJISW5qZ1ZWa3pFR2JCSTJoYkNKMG9EbzZhWjFRZ1pqUzJtdldE?=
 =?utf-8?B?YURmbU56WllGU0RETkFTV0pCNlFRMFM3d0RIUGYxd1ozM0J2OW9nK0NhdjJR?=
 =?utf-8?B?VTFnZjhMM2hqM2tTcVMwM1ZpMzlIYUtRRStIMjloNjZQb0oxWjNFOWltQUxz?=
 =?utf-8?B?dVJZa3RFNTFIQ0hvM0lVNGxtT1paUTZseGU2WWE2QTRJNmkxVTRqRFIzaE9C?=
 =?utf-8?B?WnI2R09rd3l5UGJ5eXBoK3FnM084VG1BWlR2NlZkbTc1V3NZRmRpZy82TUFI?=
 =?utf-8?B?ai8xbHBxaTFxdUVlbHkrNmNEek5lUkJueDMwRjB2cENLNWJjVGNIR3ZLTkFh?=
 =?utf-8?B?VjJkK25qZldIdXNnZWVDWktmUWVxRVM5UFkxZm1uL3pBdWxUMDNydUtTcFpt?=
 =?utf-8?Q?3pEa5Nrhuy/F8DmnV+Q8EYE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9DB8DA175F44BB4286BCA0CF1794232C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb9875c-adc1-445c-4ddb-08dc647d06f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2024 16:38:52.9683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhBbMrPSY7UtP46Qo6JJQB7QpUsfNSxa7VpBLYXynGaJP1yG8PlovQoM+RUZLVoi7Ybqge8eJTwvfONFKTeDaa8az1X1bbC2fUr98iH+lgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7038
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTI0IGF0IDA5OjEzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAxNiwgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBUaHUsIDIwMjQtMDMtMjEgYXQgMDk6MzcgLTA3MDAsIFJlaW5ldHRlIENoYXRyZSB3cm90
ZToNCj4gPiA+IA0KPiA+ID4gU3VtbWFyeQ0KPiA+ID4gLS0tLS0tLQ0KPiA+ID4gQWRkIEtWTV9D
QVBfWDg2X0FQSUNfQlVTX0ZSRVFVRU5DWSBjYXBhYmlsaXR5IHRvIGNvbmZpZ3VyZSB0aGUgQVBJ
Qw0KPiA+ID4gYnVzIGNsb2NrIGZyZXF1ZW5jeSBmb3IgQVBJQyB0aW1lciBlbXVsYXRpb24uDQo+
ID4gPiBBbGxvdyBLVk1fRU5BQkxFX0NBUEFCSUxJVFkoS1ZNX0NBUF9YODZfQVBJQ19CVVNfRlJF
UVVFTkNZKSB0byBzZXQgdGhlDQo+ID4gPiBmcmVxdWVuY3kgaW4gbmFub3NlY29uZHMuIFdoZW4g
dXNpbmcgdGhpcyBjYXBhYmlsaXR5LCB0aGUgdXNlciBzcGFjZQ0KPiA+ID4gVk1NIHNob3VsZCBj
b25maWd1cmUgQ1BVSUQgbGVhZiAweDE1IHRvIGFkdmVydGlzZSB0aGUgZnJlcXVlbmN5Lg0KPiA+
IA0KPiA+IExvb2tzIGdvb2QgdG8gbWUgYW5kLi4uDQo+ID4gVGVzdGVkLWJ5OiBSaWNrIEVkZ2Vj
b21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+ID4gDQo+ID4gVGhlIG9ubHkgdGhp
bmcgbWlzc2luZyBpcyBhY3R1YWxseSBpbnRlZ3JhdGluZyBpdCBpbnRvIFREWCBxZW11IHBhdGNo
ZXMgYW5kDQo+ID4gdGVzdGluZyB0aGUgcmVzdWx0aW5nIFRELiBJIHRoaW5rIHdlIGFyZSBtYWtp
bmcgYSBmYWlyIGFzc3VtcHRpb24gdGhhdCB0aGUNCj4gPiBwcm9ibGVtIHNob3VsZCBiZSByZXNv
bHZlZCBiYXNlZCBvbiB0aGUgYW5hbHlzaXMsIGJ1dCB3ZSBoYXZlIG5vdCBhY3R1YWxseQ0KPiA+
IHRlc3RlZCB0aGF0IHBhcnQuIElzIHRoYXQgcmlnaHQ/DQo+IA0KPiBQbGVhc2UgdGVsbCBtZSB0
aGF0IFJpY2sgaXMgd3JvbmcsIGFuZCB0aGF0IHRoaXMgYWN0dWFsbHkgaGFzIGJlZW4gdGVzdGVk
IHdpdGgNCj4gYSBURFggZ3Vlc3QuwqAgSSBkb24ndCBjYXJlIF93aG9fIHRlc3RlZCBpdCwgb3Ig
d2l0aCB3aGF0IFZNTSBpdCBoYXMgYmVlbg0KPiB0ZXN0ZWQsDQo+IGJ1dCBfc29tZW9uZV8gbmVl
ZHMgdG8gdmVyaWZ5IHRoYXQgdGhpcyBhY3R1YWxseSBmaXhlcyB0aGUgVERYIGlzc3VlLg0KDQpJ
dCBpcyBpbiB0aGUgcHJvY2VzcyBvZiBnZXR0aW5nIGEgVERYIHRlc3QgZGV2ZWxvcGVkIChvciBy
YXRoZXIgdXBkYXRlZCkuDQpBZ3JlZWQsIGl0IHJlcXVpcmVzIHZlcmlmaWNhdGlvbiB0aGF0IGl0
IGZpeGVzIHRoZSBvcmlnaW5hbCBURFggaXNzdWUuIFRoYXQgaXMNCndoeSBJIHJhaXNlZCBpdC4N
Cg0KUmVpbmV0dGUgd2FzIHdvcmtpbmcgb24gdGhpcyBpbnRlcm5hbGx5IGFuZCBzb21lIGl0ZXJh
dGlvbnMgd2VyZSBoYXBwZW5pbmcsIGJ1dA0Kd2UgYXJlIHRyeWluZyB0byB3b3JrIG9uIHRoZSBw
dWJsaWMgbGlzdCBhcyBtdWNoIGFzIHBvc3NpYmxlIHBlciB5b3VyIGVhcmxpZXINCmNvbW1lbnRz
LiBTbyB0aGF0IGlzIHdoeSBzaGUgcG9zdGVkIGl0Lg0KDQpUaGVyZSB3YXMgYXQgbGVhc3Qgc29t
ZSBsZXZlbCBvZiBURFggaW50ZWdyYXRpb24gaW4gdGhlIHBhc3QuIEknbSBub3Qgc3VyZSB3aGF0
DQpleGFjdGx5IHdhcyB0ZXN0ZWQsIGJ1dCB3ZSBhcmUgZ29pbmcgdG8gcmUtdmVyaWZ5IGl0IHdp
dGggdGhlIGxhdGVzdCBldmVyeXRoaW5nLg0K

