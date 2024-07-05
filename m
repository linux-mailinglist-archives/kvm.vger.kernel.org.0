Return-Path: <kvm+bounces-21042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 746E392853C
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 11:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 033CF1F24D32
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 09:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0EEB1474B5;
	Fri,  5 Jul 2024 09:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ULV0iAKs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69455145B27;
	Fri,  5 Jul 2024 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720172190; cv=fail; b=thJra4pDuwNb13gInszZz0M4EYdMYlysA38q7JOmXokC9GAoOIP9kA7TB81n2xNHCGSNtfVgsyd6Q/Wlby0sAPCOdKI0kTINA8VW4Hk72ZrKIp6gQNTz1zHIJL0Tz0xNdHrLXcepmJaXS9yphGlhpm+8Y0DU2bmmUj3RUFq6gZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720172190; c=relaxed/simple;
	bh=NPo+ZY6UXLp+rRjWCSzOPVWYnsMLrh1bAwLmT/zPs0w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rlVcHyFOqDWthciMrRlpW/dbHZCbSqRb1Uk+/1/zw9i+d5HbbZahTKQ5rrQoeG48PJLdiCJoKAkmXt0pA7o/oQXg1MfecmJAOtObm0UoHYw4fZLSZpdjZ/5F/5TMGS0mKKL+cusSCtVi2X2TLuvjwPwkcYA/bnnEmFcktpUFEoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ULV0iAKs; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720172189; x=1751708189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NPo+ZY6UXLp+rRjWCSzOPVWYnsMLrh1bAwLmT/zPs0w=;
  b=ULV0iAKscRAyNPGOPYL9vA7dL8mkmp7SFB5y2GcTz7LTr8ACAiOIx7Ha
   vwaTXAtEz7RolK6bMF5xVQw9TeM+FyqSrpaiw+396EV4noqAbG5IzYr2X
   r4fRrLL3OKRETLrSGv6zMHq0J2EBa79IGOzCADvoB+eElywlffXzPD+Hs
   s5DlhGxc2vsiPU3XWKRNVEgh7SuO6oqRXmFkumetVbAL+5cxs7oOB+HPT
   dENdrXVxAuRc1z74nJ0SoeaWXfe9QZlrsaNSOgp96mA33wY8KTyc1uDa8
   O7fPDCsSLAXdHPrEise7vAVQ2+SC1MaIXA+xrCOX/3Y24avl5OKWS/13a
   A==;
X-CSE-ConnectionGUID: ZudEle2OREChr2q2QBX0Qw==
X-CSE-MsgGUID: s+dcG/9KSUKTd8ccBjGQ6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="28061747"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="28061747"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 02:36:28 -0700
X-CSE-ConnectionGUID: 8wFK77OjQZSJnwm3Fooccg==
X-CSE-MsgGUID: KSGkzmUXRsi6PuuGjIXZEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="51776859"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jul 2024 02:36:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 5 Jul 2024 02:36:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 5 Jul 2024 02:36:27 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 5 Jul 2024 02:36:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADDNbg3XPTT3fvhG+SG2hwXVDs+NcMIaYEhbIlfqnMUjL1AUtpTNOAA1ZNXQnDdi4J8Pcx70T0CcJ+RY6dPioPlVsFO30pT9aHDf/NY/U0rdQCd+FUSYvyI2S9KBYiwcXdzm9Gvfl2IBEApYjw+BE4T6/vb09JX+pFn0Q06vbgfCZwFjgKIw1+dwGoWtddivkzU6saPhqd7PLHdJj8Cu3Kyq+iO6lzhZKF9/bqioQ7vCqLjLpVPh1Rhzlly+Ayb/3vksmLClpILG0YC20g1SKQx4G6vGynInNeTzGOZc1Bp1+r34UidYWo+ipb8qar/A+AuzvWK57GcRj/g99DxP2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPo+ZY6UXLp+rRjWCSzOPVWYnsMLrh1bAwLmT/zPs0w=;
 b=Mix4Dofb65L7Er1aiKur5gYSqwLZWtgOydvgFjx9NOUPhkcQwOUi/pSbArX+d1ztwd6Vnk+Lavt5mM2NRQ6McA3u5QeYMhe2wZWBc5ygmFdKKztUEJKpzTcLX6EYHGRFJEsxDbsxjRAW38mA8+f5c2xZR0RYePdLTYSgwx9R7G2p5OTvmICLwzu8bzkiFdbtJyElfyTJGedQAWucqhydBvrWEWmUpSc8YJobU2QCOm8fE0ACgAoEVFtAQT208GyRvg30gUObMi+h+AGXslTqcHM9jqP0QZR+wt0LZhkZEoD1F+phAKXgEhn8LZsEkPttQel2J/gugkWMVTd3nlo5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8089.namprd11.prod.outlook.com (2603:10b6:8:17f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 09:36:25 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7741.029; Fri, 5 Jul 2024
 09:36:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Topic: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Index: AQHav+UTEitueRT63E611vGc3hxz1LHNo3oAgACrYgCAGUBLAIAAbqeA
Date: Fri, 5 Jul 2024 09:36:25 +0000
Message-ID: <fd90c6d56f95991c9a29c454e9d1ddd2a7f55340.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
	 <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
	 <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
	 <5c3c81dc-ec15-4f7a-9807-a308082c9fc8@linux.intel.com>
In-Reply-To: <5c3c81dc-ec15-4f7a-9807-a308082c9fc8@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB8089:EE_
x-ms-office365-filtering-correlation-id: 4640ac1d-ce4a-48aa-fbf7-08dc9cd5f067
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?L2JmL1VUOTF3Nk9yYXlyRWRJd2ZIdkVuZ0dRSHp0akNOUjRtUTFyWEc5VDBO?=
 =?utf-8?B?eGJqV21wWXlPdDVtdytiblFvRHNRUCtNcjV4cFBHRVNSZmVMN2dUa3VEc2JB?=
 =?utf-8?B?RUdsWXJuckV3V0pvN3ZaZmVRRkpKcEF4RSt4RUIvT0p2eFAzemROUmhha09O?=
 =?utf-8?B?d1EwN1d4V2IwbmhXQXp5SEtYUUJjQjNRMlRlNVZoN0ZkLzhLcWZMSUJscThr?=
 =?utf-8?B?UVFENlVyK2VpRlQ2WTlIOW5hQkRVQmI2QVZ6MUF6OURHdVE4RytnQTg5TEhB?=
 =?utf-8?B?RHlCSFNQS1A1TDVoMWZuMGkvUlpMNytnaXJVUEdTTTE3WTE0REsrQ3ZmOHJR?=
 =?utf-8?B?ck1vcjB5M0YrV3lnZ3dUc1BFMjJDTHVsWmNmNndud2IrVDVvNFh1RXdZd0dh?=
 =?utf-8?B?REZGT29VQndpaEMvR1JOOVRRSTNrSFZicjRET29TUkZEZnJmdXk0dkE3WXRp?=
 =?utf-8?B?LzN3dVduWDB0elB6Y2FiNld1alpxN2pXdGx2TllBM2YxMXExU0V5akZ2RHRk?=
 =?utf-8?B?LzNZWTd0TS8xNzdhRy9Fb2hBYlRqaTRHZnR1ZS95KytldUNweGV0MFpTZmp0?=
 =?utf-8?B?MlNFeUxHSXNSRExWT2dneFZjblUrYTB5cjIxcysyb0NDcWptQzhPOUM2Rzda?=
 =?utf-8?B?OUZnejE1VlFaN1FOYlROVndXNi95NHFPVEh5NkNEcUZ6TFd3TFNYOHNYOGMx?=
 =?utf-8?B?dVRVckFYKzlLYXRQaHh3RnpuYXUzQkdTNEN2T1NLa3k2aDVrRjBTVTQ5WTJT?=
 =?utf-8?B?VGhrMkhhRTFBa0N5blR5NU5HZi94MGJYY29KVWZaWFFQUFZwVzNBNXFuV242?=
 =?utf-8?B?RUlabDJ0VzdyWmF4em1IZE4xWEV3YmFoMGNGOWZtZmFKbk4xOEJKWUhlSFcv?=
 =?utf-8?B?OVNKRFNoNG94WUI3bVh2enFKMTFxYXBvMzBITUxteFh6MWYxcERvVDRJaU9n?=
 =?utf-8?B?V1dacWtLU0thYWpXZmlpOUtIV2hycTVMUGdpT2NBTHBTV0FWcnAveFhFNm1C?=
 =?utf-8?B?dFQrWUsrMjI4WUVyRklqRWFQOWkxS05nWjVDK0RTclViUmVXeHRKaS9DZnIv?=
 =?utf-8?B?Rm1Ka2dKam9qUUg0SWFZUTRQaVU4SW5IM2tQT3UremtrSzZkR0x2SnJSaVMz?=
 =?utf-8?B?QkUxRURHTW5xNUwwZVZycG4wZXloUjhQS0F1eXByeFRZNGw3SHh4VTZDaEFt?=
 =?utf-8?B?SmRtZDFlbXgvQzNnME16ZEZmTThBbHlhUElrS0oxbmZDTkhjQkZiMkY1OGl4?=
 =?utf-8?B?c3lsTjFuVE9YQnQ4KytoMXdvLzRoaUFuMWI4a2duZlI5OC9EeFNxVitoZ0dw?=
 =?utf-8?B?c0NZa2kySzFvZ2FzNlRZZ1FoL2pCckMrSTdvS2cyRjhtWk9qMjdDc2tnZTBU?=
 =?utf-8?B?aTNoQjJlanZWSE5LdGI0MHRENThiMTZDS25vaGYrcDlUUWhQNjAvdmRzSWEw?=
 =?utf-8?B?OTY4SGtGb3h0YnpNd25OU0Zjd0YwZVJTeFZXanNDTWFEL0FBZEMwNzZnczZl?=
 =?utf-8?B?TzJ1UGZPTHR5UVZJWC9vMDc1VXRPQVVqTldWWXIwY3RsRlFaKzNoNDl1cG1S?=
 =?utf-8?B?T0hCY3pwdGtrLzg0K3IydUVKa1lTRFhpMDlFTTE2cGRjay95MmtOTUJZVmlj?=
 =?utf-8?B?eTdlL284dVRwL296U3pIVzF2V0I3a01xU3pndnYyeFZFYjAybTZTOFZTZWZl?=
 =?utf-8?B?bkYzZERQWm9Rc0ZDbDQrU2pUZnpvRVF0b1RFcVRoUlhrendoUDR2dExTT2ta?=
 =?utf-8?B?MDluL0pTNGZablpFdnBVUU9xS09WMkhZNFhXZjUvQTNHRllLaGR3R0lKVnlk?=
 =?utf-8?B?bTRMdFZIZ2cwNktWSkpQRVNRVmdKQTg4dFpLdkIwSXJTZ1lZZ1ZURTE4QnFk?=
 =?utf-8?B?b0RySzRnZ1haY002OHZUcHpXeUx6bzlwRlFOQitBZGZlWmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0U5emcyN3M3dy9CQVdpQ2sxZ1dWdkdRK0NnRHJDYTViQXJEeTgzVVZaTnJ0?=
 =?utf-8?B?QUJ5WE5zNmFrMmMvL3cvUGJ6anpyRklaNUNOSU1NbDVyaE1CV0RxUU9mUXE3?=
 =?utf-8?B?YkNtdkFBM2dNWmpJcGJpL0h1NE5STFBTZGJqZ0dWYnNWYUdOT2M1WFE1TndH?=
 =?utf-8?B?N3dhUEppV0J6NTZMdnlyQ3lYZWlPa0VFMXZNdDExYUtuazFEQUN5VG40MEM5?=
 =?utf-8?B?UG1pYjhCNENLcUIxaEIvK0xMTC9hRnl2Nm1VQUVFTm5Wa2V1ZmVVbjFLR0Ur?=
 =?utf-8?B?c3czeFBueXFXSUU5d3lmVkhsMHlJdVhmRmdUSFljbUhHblFleFU3azJlM1dZ?=
 =?utf-8?B?MVc5SHBmQjBzb002TXBQSnlLYkQ0QXptdStGc2pWdDRVSkxaN1pMVjJETEtB?=
 =?utf-8?B?VXpoRUgrR0lVMHg1ZnRZVTV3TjdLZlFWYjEza2ZTK256TVF5VlB6NFNKUitC?=
 =?utf-8?B?N0ZOOENLcllPa0tMeXpwMko3TVJPV0V6cDZwU2gwanpOQUwwU29QaTBFZkNq?=
 =?utf-8?B?STZtZGZsQ0pxRlQvYUp0NVVweGJYS29jTHphWjMzRkdBYWJNU0FVRDRMVlV4?=
 =?utf-8?B?WEFhVnR5N0FVUXNUeTMrQVRUUlNBcTlxS3QvR21EV1lyZUtOc1hXbzB0a0ZO?=
 =?utf-8?B?VnFGb1NOb29wOGN6ckl1SkREaStPS2RsSUMyYnBKdEVWV0JLRmk5aVV4dXJU?=
 =?utf-8?B?V0Y2Umd6UCs2ci9KQXFSNUIzYmNIc08vTnU4TWhvMTJKa3NXSnBWUURZcWQ5?=
 =?utf-8?B?cFI2cC9tMXM3dlhlZldlNzNobFAxSjlSek85bFFYbjdmNG9vTklnRXd0OHJ1?=
 =?utf-8?B?ZTNQYkN5cUVtQVpteDBxSHV4eUNpQU5vVlFGeDNZK3NXV2pNTEZzYmpUeDFD?=
 =?utf-8?B?SWZKVHYvMTFlK3BzL0xITkwzZGVwcXk4VFdwbFRiV2F5UXVUOGRiUGxDRllF?=
 =?utf-8?B?QUZHd2hWaW1KeXVYQXN5L2t5TDM0K0t2TUQ1NkZXOWlGV3g1ZWM5M3h1bWJx?=
 =?utf-8?B?U05KSXVITEdGMkdlV2xRWG5NNlpsOFhGWWd1OGY5NURsZVJFbXg5Yy9jb3E5?=
 =?utf-8?B?QllLT3NBcUs4SkZ2QTFPN2owSEZ3aVRJRHF3L2hMcjA3eHJHYVFIQ3BjeVVL?=
 =?utf-8?B?MzVCcW94RW5JamlOL1BjdnFQR0kybVRoYU1jbjBFZ2xnRVRIQ0NPaFhiVG5o?=
 =?utf-8?B?NUxRVDZMVEtOQUpjOVVKaFUxS2dsYnpiZndqbTlHU3lYL24zMjZYcld4ZVEv?=
 =?utf-8?B?WjFGRDA0YmtZamNZQ001NjdKM1gwMnkzL2k4dG9NaGRrRFVOV1lsbVJ6UjVF?=
 =?utf-8?B?bUlpdk4xTmZ1S1NMTmpHcnYrNEVicjJZKzhGazdSeSsvalBFY1MrWGI0b1BV?=
 =?utf-8?B?ZXkzbjRaSHl3Y2FLQnVkVG1tSlVzbjVxM25oNE5sVkNiZk1BYm5vVll4WHJG?=
 =?utf-8?B?dm1LZzdnTzhmTjVuQTFuMytjZ2p3c3lpQ2dtbFlQT2pNeTZ5RndvQmlNOWlJ?=
 =?utf-8?B?ODFpUVkwSkdxMjMzTy8xS0RzdWg4RGNxUFV2WCswd0syOU5kNm5TbnpEMlpx?=
 =?utf-8?B?RysyV282aW9jY3RZOTQxZkt2c0d4Q1JoUVNlaklOcDlSRGVUdFYrTmZ3bmdi?=
 =?utf-8?B?ZTJVQ1FKd0NRL2x0clBQQlNOa1FOeXE2djJuUDI1UUZqQVdpNGJXcUpRRDdo?=
 =?utf-8?B?MU5Yd1d5b3JHVW90a2VxWUlUS2ZSWWtzYi82Um5RVTJFVlRRektubkNFSC93?=
 =?utf-8?B?b2ZwQUNGOXZNclhVcTlpV0w3bkdkUkU0OUlOaHRnc3ZWTHdmWTFFME5zRjQ2?=
 =?utf-8?B?R09FZFJ4QUgwaVdMN2VLeUt3bGlzRXp2ZWV2aEZnSVVwNVg0RUk0WDM4UnMy?=
 =?utf-8?B?Q3NGL2lpRXdOV3JlYytKM1JSVnZKck8vaXNwMFlEZ2FQVk45N0dmTTM5dUpN?=
 =?utf-8?B?VFlqRmRKUjRFc0ZVVjlBcDJtWTltMDNCVnc0QjNVbDE3VzBubVg0VFlEakV4?=
 =?utf-8?B?aXBobUtIT1VVc2E4TUtSYWRCU292ZytBMVdGSDdrdTVEcnNsZTEzdVdpdjNi?=
 =?utf-8?B?TGt1ajhIbzd6K0taUzZYQ0RsUFRaaWt1VE1uYUxrOEdaYVkwbVF0Ni9VWHMv?=
 =?utf-8?Q?DEuv1XeDncP6FKkGql1uExnCY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6BA014FBBD17B4CAEFFAE6E69ECCA48@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4640ac1d-ce4a-48aa-fbf7-08dc9cd5f067
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 09:36:25.4977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5HRSZDRRnkYm+ywmlpmi0miN4rgpfvLCDanMfhUnOYK/am/zBJMHB4gR1mMAmcOfdVZRpjtvoia41UrbsbUDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8089
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA3LTA1IGF0IDExOjAwICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiA2LzE5LzIwMjQgOToyMyBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gWy4uLl0NCj4gPiAN
Cj4gPiA+IGZ1cnRoZXJtb3JlIHRoZSBhbGlnbmVtZW50IGNoZWNrcw0KPiA+ID4gc3VnZ2VzdCBp
dCdzIGFjdHVhbGx5IHNvbWUgc2FuaXR5IGNoZWNraW5nIGZ1bmN0aW9uLiBGdXJ0aGVybW9yZSBp
ZiB3ZQ0KPiA+ID4gaGF2ZToiDQo+ID4gPiANCj4gPiA+IE9SRElOQVJZX0NNUixFTVBUWV9DTVIs
T1JESU5BUllfQ01SDQo+ID4gPiANCj4gPiA+IChJcyBzdWNoIGEgc2NlbmFyaW8gZXZlbiBwb3Nz
aWJsZSksIGluIHRoaXMgY2FzZSB3ZSdsbCBvbW1pdCBhbHNvIHRoZQ0KPiA+ID4gbGFzdCBvcmRp
bmFyeSBjbXIgcmVnaW9uPw0KPiA+IEl0IGNhbm5vdCBoYXBwZW4uDQo+ID4gDQo+ID4gVGhlIGZh
Y3QgaXM6DQo+ID4gDQo+ID4gMSkgQ01SIGJhc2Uvc2l6ZSBhcmUgNEtCIGFsaWduZWQuICBUaGlz
IGlzIGFyY2hpdGVjdHVyYWwgYmVoYXZpb3VyLg0KPiA+IDIpIFREWCBhcmNoaXRlY3R1cmFsbHkg
c3VwcG9ydHMgMzIgQ01ScyBtYXhpbXVtbHk7DQo+IERvIHlvdSB0aGluayBpdCdzIHdvcnRoIGEg
Y29tbWVudCB0byB0aGUgZGVmaW5pdGlvbiBvZiBURFhfTUFYX0NNUlMgdGhhdCANCj4gdGhlIG51
bWJlciBpcyBhcmNoaXRlY3R1cmFsPw0KPiANCg0KT0sgd2lsbCBkby4gdGhhbmtzLg0K

